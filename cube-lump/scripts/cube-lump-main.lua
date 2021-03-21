-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local GetGameObjectTransform = function (name) return assert(vci.assets.GetTransform(name)) end
local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end

local settings = {
    enableDebugging = false
}

--- カラーパレットのメッセージの名前空間。
local ColorPaletteMessageNS = 'cytanb.color-palette'

--- メッセージフォーマットの最小バージョン。
local ColorPaletteMinMessageVersion = 0x10000

--- アイテムのステータスを通知するメッセージ名。
local ColorPaletteItemStatusMessageName = ColorPaletteMessageNS .. '.item-status'

local lumpNS = 'com.github.oocytanb.oO-vci-pack.cube-lump'
local statusMessageName = lumpNS .. '.status'
local queryStatusMessageName = lumpNS .. '.query-status'

local vciLoaded = false

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local BinarySearchInsert = function (sortedList, size, value, less)
    local listSize = math.floor(size)
    local beginIndex = 1
    local endIndex = listSize

    if endIndex <= 0 then
        sortedList[1] = value
        return 1
    end

    while beginIndex < endIndex do
        local middleIndex = bit32.rshift(beginIndex + endIndex, 1)
        if less(value, sortedList[middleIndex]) then
            endIndex = middleIndex - 1
        else
            beginIndex = middleIndex + 1
        end
    end

    local insertIndex = less(value, sortedList[beginIndex]) and beginIndex or beginIndex + 1
    table.insert(sortedList, insertIndex, value)
    return insertIndex
end

local RingIterator; RingIterator = {
    Make = function (list, i, j)
        local beginIndex = i and math.floor(i) or 1
        local endIndex = j and math.floor(j) or #list

        local size
        if beginIndex == 0 and endIndex == 0 then
            size = 0
        elseif beginIndex >= 1 and beginIndex <= endIndex then
            size = endIndex - beginIndex + 1
        else
            error('RingIterator: invalid range')
        end

        return {
            list = list,
            size = size,
            offset = beginIndex - 1,
            index = 0
        }
    end,

    Next = function (self)
        if self.size > 0 then
            local nextIndex = self.index % self.size + 1
            self.index = nextIndex
            return self.list[self.offset + nextIndex]
        else
            return nil
        end
    end
}

local TenthCube; TenthCube = cytanb.SetConstEach({
    ItemName = function (x, y, z)
        return TenthCube.Prefix .. x .. '-' .. y .. '-' .. z
    end,

    IsApproximatelySamePosition = function (pos1, pos2)
        return (pos1 - pos2).sqrMagnitude < TenthCube.SqrMinDistanceThreshold
    end,

    Make = function (x, y, z, relativePosition)
        local name = TenthCube.ItemName(x, y, z)
        return {
            name = name,
            x = x,
            y = y,
            z = z,
            relativePosition = relativePosition,
            distance = relativePosition.magnitude,
            item = GetGameObjectTransform(name),
        }
    end,

    TargetPosition = function (self, posistion, rotation)
        return posistion + rotation * self.relativePosition
    end
}, {
    Prefix = 'tenth-cube-',
    EdgeLength = 0.1,
    IntervalLength = 0.05,
    SqrMinDistanceThreshold = 1E-4,
})

local CubeMaterial; CubeMaterial = {
    Make = function (name)
        local color = assert(vci.assets.material.GetColor(name))
        local h, s, v = cytanb.ColorRGBToHSV(color)
        local hsv = {h = h, s = s, v = v}
        return {
            name = name,
            initialHSV = hsv,
            hsv = cytanb.Extend({}, hsv),
        }
    end,

    SetHSV = function (self, h, s, v)
        local hsv = self.hsv
        hsv.h = h - math.floor(h)
        hsv.s = s
        hsv.v = v
        vci.assets.material.SetColor(self.name, Color.HSVToRGB(hsv.h, hsv.s, hsv.v))
        return self
    end,
}

local CubeLump; CubeLump = cytanb.SetConstEach({
    CubeIndex = function (edgeSize, x, y, z)
        return (z * edgeSize + y) * edgeSize + x + 1
    end,

    CalcCubeEdgeOffset = function (edgeLength, n)
        return (- edgeLength + TenthCube.EdgeLength) * 0.5 + (TenthCube.EdgeLength + TenthCube.IntervalLength) * n
    end,

    LazyMake = function ()
        return coroutine.wrap(function ()
            -- check edge size.
            local edgeSize = 0
            while true do
                local name = TenthCube.ItemName(0, 0, edgeSize)
                if not vci.assets.GetTransform(name) then
                    break
                end
                edgeSize = edgeSize + 1
            end

            if edgeSize <= 0 then
                error('CubeLump: invalid range: edgeSize = ' .. tostring(edgeSize))
            end

            local edgeLength = (TenthCube.EdgeLength + TenthCube.IntervalLength) * edgeSize - TenthCube.IntervalLength
            local size = edgeSize ^ 3
            local blockSize = math.min(size, math.floor(CubeLump.MaxBlockSize / edgeSize) * edgeSize)

            -- make cubes.
            local cubes = {}
            local i = 1
            for x = 0, edgeSize - 1 do
                local px = CubeLump.CalcCubeEdgeOffset(edgeLength, x)
                for y = 0, edgeSize - 1 do
                    local py = CubeLump.CalcCubeEdgeOffset(edgeLength, y)
                    for z = 0, edgeSize - 1 do
                        local pz = CubeLump.CalcCubeEdgeOffset(edgeLength, z)
                        local relativePosition = Vector3.__new(px, py, pz)
                        local index = CubeLump.CubeIndex(edgeSize, x, y, z)
                        local cube = TenthCube.Make(x, y, z, relativePosition)
                        cubes[index] = cube

                        if i < size and i % blockSize == 0 then
                            coroutine.yield()
                        end
                        i = i + 1
                    end
                end
            end

            return {
                edgeSize = edgeSize,
                cubes = cubes,
                size = size,
                boundsItem = GetSubItem(CubeLump.BoundsName),
                blockSize = blockSize,
                grabbed = false
            }
        end)
    end,

    Update = function (self)
        if self.grabbed and not self.boundsItem.IsMine then
            CubeLump.Ungrab(self)
        end
    end,

    Grab = function (self)
        self.grabbed = true
    end,

    Ungrab = function (self)
        if self.grabbed then
            self.grabbed = false
        end
    end
}, {
    BoundsName = 'bounds-item',
    MaxBlockSize = 50
})

local CubeInterpolator; CubeInterpolator = cytanb.SetConstEach({
    Make = function (cube)
        return {
            cube = cube,
            startSec = 0,
            durationSec = 0,
            processingSec = 0,
            startPosition = cube.relativePosition,
            startRotation = Quaternion.identity,
            targetPosition = cube.relativePosition,
            targetRotation = Quaternion.identity,
            processingPosition = cube.relativePosition,
            processingRotation = Quaternion.identity
        }
    end,

    SetTarget = function (self, targetPosition, targetRotation, currentSec, optDurationSec)
        local item = self.cube.item
        if CubeInterpolator.IsProcessing(self) then
            self.startPosition = self.processingPosition
            self.startRotation = self.processingRotation
        else
            self.startPosition = item.GetPosition()
            self.startRotation = item.GetRotation()
        end
        self.startSec = currentSec
        self.durationSec = optDurationSec or CubeInterpolator.InterpolationSec
        self.processingSec = 0
        self.targetPosition = targetPosition
        self.targetRotation = targetRotation
    end,

    IsProcessing = function (self)
        return self.processingSec < self.durationSec
    end,

    Process = function (self, currentSec)
        if not CubeInterpolator.IsProcessing(self) then
            return false
        end

        local pos, rot
        if self.durationSec > 0 then
            self.processingSec = currentSec - self.startSec
            local t = self.processingSec / self.durationSec
            pos = Vector3.Lerp(self.startPosition, self.targetPosition, t)
            rot = Quaternion.Lerp(self.startRotation, self.targetRotation, t)
        else
            self.processingSec = self.durationSec
            pos = self.targetPosition
            rot = self.targetRotation
        end

        self.processingPosition = pos
        self.processingRotation = rot

        local item = self.cube.item
        item.SetPosition(pos)
        item.SetRotation(rot)

        return true
    end
}, {
    InterpolationSec = 5.0,
    PrimaryInterpolationSec = 0.01
})

local CubeTransformer; CubeTransformer = {
    SetInterpolatorTarget = function (interpolator, boundsPosition, boundsRotation, currentSec, optDurationSec)
        local targetPosition = TenthCube.TargetPosition(interpolator.cube, boundsPosition, boundsRotation)
        CubeInterpolator.SetTarget(interpolator, targetPosition, boundsRotation, currentSec, optDurationSec)
    end,

    LazyMake = function (lump)
        return coroutine.wrap(function ()
            local cubes = lump.cubes
            local interpolators = {}
            local size = lump.size
            local blockSize = lump.blockSize
            for i = 1, size do
                BinarySearchInsert(interpolators, i - 1, CubeInterpolator.Make(cubes[i]), function (a, b)
                    return a.cube.distance < b.cube.distance
                end)

                if i < size and i % blockSize == 0 then
                    coroutine.yield()
                end
            end

            -- make primary block iterators.
            local primaryBlockIterator = RingIterator.Make(interpolators, 1, blockSize)
            coroutine.yield()

            -- make secondary block.
            local secondaryBlockSize = size - blockSize
            local secondaryQueue = cytanb.CreateCircularQueue(secondaryBlockSize)
            local secondaryProcessingQueue = cytanb.CreateCircularQueue(blockSize)
            local secondaryRestQueue = cytanb.CreateCircularQueue(secondaryBlockSize)

            for i = blockSize + 1, size do
                secondaryQueue.Offer(interpolators[i])
                if i < size and i % blockSize == 0 then
                    coroutine.yield()
                end
            end

            return {
                interpolators = interpolators,
                size = size,
                blockSize = blockSize,
                boundsItem = lump.boundsItem,
                primaryBlockIterator = primaryBlockIterator,
                positionChangedSec = 0,
                secondaryQueue = secondaryQueue,
                secondaryProcessingQueue = secondaryProcessingQueue,
                secondaryRestQueue = secondaryRestQueue,
                operationStartTime = vci.me.UnscaledTime,
                operationCount = 0,
            }
        end)
    end,

    ProcessPrimaryBlock = function (self, boundsPosition, boundsRotation, currentSec)
        local iterator = self.primaryBlockIterator
        local blockSize = self.blockSize
        local headIpl = RingIterator.Next(iterator)
        local headPos = CubeInterpolator.IsProcessing(headIpl) and headIpl.targetPosition or headIpl.cube.item.GetPosition()
        local headTargetPosition = TenthCube.TargetPosition(headIpl.cube, boundsPosition, boundsRotation)
        if TenthCube.IsApproximatelySamePosition(headTargetPosition, headPos) then
            -- 先頭のキューブの位置がおよそ同じであった場合。
            if CubeInterpolator.IsProcessing(headIpl) then
                CubeInterpolator.Process(headIpl, currentSec)
                for i = 2, blockSize do
                    local ipl = RingIterator.Next(iterator)
                    CubeInterpolator.Process(ipl, currentSec)
                end
                return blockSize, false
            else
                -- 処理が完了している。
                return 0, false
            end
        else
            -- 先頭のキューブの位置が離れていた場合。
            CubeInterpolator.Process(headIpl, currentSec)
            CubeInterpolator.SetTarget(headIpl, headTargetPosition, boundsRotation, currentSec, CubeInterpolator.PrimaryInterpolationSec)
            for i = 2, blockSize do
                local ipl = RingIterator.Next(iterator)
                CubeInterpolator.Process(ipl, currentSec)
                CubeTransformer.SetInterpolatorTarget(ipl, boundsPosition, boundsRotation, currentSec, CubeInterpolator.PrimaryInterpolationSec)
            end
            return blockSize, true
        end
    end,

    ProcessSecondaryBlock = function (self, boundsPosition, boundsRotation, currentSec)
        local operationCount = 0

        -- rest queue.
        while not self.secondaryRestQueue.IsEmpty() do
            local ipl = self.secondaryRestQueue.Poll()
            if ipl.startSec < self.positionChangedSec then
                -- 位置が変更されたので、キューに返す。
                self.secondaryQueue.Offer(ipl)
                operationCount = operationCount + 1
                if operationCount >= self.blockSize then
                    return operationCount
                end
            else
                -- そのまま rest に戻して break。1つだけ検査すれば十分。
                self.secondaryRestQueue.Offer(ipl)
                break
            end
        end

        -- processing queue.
        for i = 1, self.secondaryProcessingQueue.Size() do
            local ipl = self.secondaryProcessingQueue.Poll()
            CubeInterpolator.Process(ipl, currentSec)

            if ipl.startSec < self.positionChangedSec and ipl.processingSec >= ipl.durationSec * 0.5 then
                -- 位置が変更されたので、キューに返す。
                self.secondaryQueue.Offer(ipl)
            elseif CubeInterpolator.IsProcessing(ipl) then
                -- 処理続行。
                self.secondaryProcessingQueue.Offer(ipl)
            else
                -- 処理を終えた。
                self.secondaryRestQueue.Offer(ipl)
            end

            operationCount = operationCount + 1
            if operationCount >= self.blockSize then
                return operationCount
            end
        end

        -- 新しく処理する対象を選択する。
        if not self.secondaryProcessingQueue.IsFull() and not self.secondaryQueue.IsEmpty() then
            local sizeRatio = self.secondaryQueue.Size() / (self.secondaryProcessingQueue.MaxSize() - self.secondaryProcessingQueue.Size())
            local maxTrials = math.floor(sizeRatio)
            local remain = maxTrials >= 2 and 1 or 0
            while not self.secondaryProcessingQueue.IsFull() and not self.secondaryQueue.IsEmpty() do
                local ipl = self.secondaryQueue.Poll()
                if remain <= 0 or math.random(0, remain) == 0 then
                    CubeTransformer.SetInterpolatorTarget(ipl, boundsPosition, boundsRotation, currentSec)
                    self.secondaryProcessingQueue.Offer(ipl)
                    remain = maxTrials
                    operationCount = operationCount + 1
                    if operationCount >= self.blockSize then
                        return operationCount
                    end
                else
                    -- 再試行
                    self.secondaryQueue.Offer(ipl)
                    remain = remain - 1
                end
            end
        end

        return operationCount
    end,

    Update = function (self)
        local boundsItem = self.boundsItem
        local boundsPosition = boundsItem.GetPosition()
        local boundsRotation = boundsItem.GetRotation()
        local currentSec = vci.me.UnscaledTime.TotalSeconds

        local primaryOperationCount, positionChanged = CubeTransformer.ProcessPrimaryBlock(self, boundsPosition, boundsRotation, currentSec)
        if positionChanged then
            self.positionChangedSec = currentSec
        end

        self.operationCount = self.operationCount
            + primaryOperationCount
            + CubeTransformer.ProcessSecondaryBlock(self, boundsPosition, boundsRotation, currentSec)

        if settings.enableDebugging then
            local now = vci.me.UnscaledTime
            local odt = (now - self.operationStartTime).TotalSeconds
            if odt >= 10 then
                cytanb.LogTrace('transform operation rate: ', cytanb.Round(self.operationCount / odt, 2), ' [op/sec]')
                self.operationStartTime = now
                self.operationCount = 0
            end
        end
    end
}

local CubeTeleporter; CubeTeleporter = cytanb.SetConstEach({
    Teleport = function (node, boundsPosition, boundsRotation, currentSec)
        local cube = node.cube
        local targetPosition = TenthCube.TargetPosition(cube, boundsPosition, boundsRotation)
        node.startSec = currentSec
        cube.item.SetPosition(targetPosition)
        cube.item.SetRotation(boundsRotation)
    end,

    LazyMake = function (lump)
        local MakeCubeNode = function (cube)
            return {
                cube = cube,
                startSec = 0
            }
        end

        return coroutine.wrap(function ()
            local cubes = lump.cubes
            local nodes = {}
            local size = lump.size
            local blockSize = lump.blockSize
            for i = 1, size do
                BinarySearchInsert(nodes, i - 1, MakeCubeNode(cubes[i]), function (a, b)
                    return a.cube.distance < b.cube.distance
                end)

                if i < size and i % blockSize == 0 then
                    coroutine.yield()
                end
            end

            -- make primary block iterators.
            local primaryBlockIterator = RingIterator.Make(nodes, 1, blockSize)
            coroutine.yield()

            -- make secondary block.
            local secondaryBlockSize = size - blockSize
            local secondaryRestQueue = cytanb.CreateCircularQueue(secondaryBlockSize)
            local secondaryProcessingQueue = cytanb.CreateCircularQueue(secondaryBlockSize)

            for i = blockSize + 1, size do
                secondaryRestQueue.Offer(nodes[i])
                if i < size and i % blockSize == 0 then
                    coroutine.yield()
                end
            end

            return {
                nodes = nodes,
                size = size,
                blockSize = blockSize,
                boundsItem = lump.boundsItem,
                primaryBlockIterator = primaryBlockIterator,
                positionChangedSec = 0,
                secondaryRestQueue = secondaryRestQueue,
                secondaryProcessingQueue = secondaryProcessingQueue,
                operationStartTime = vci.me.UnscaledTime,
                operationCount = 0,
            }
        end)
    end,

    ProcessPrimaryBlock = function (self, boundsPosition, boundsRotation, currentSec)
        local iterator = self.primaryBlockIterator
        local blockSize = self.blockSize
        local headNode = RingIterator.Next(iterator)
        local headPos = headNode.cube.item.GetPosition()
        local headTargetPosition = TenthCube.TargetPosition(headNode.cube, boundsPosition, boundsRotation)
        if TenthCube.IsApproximatelySamePosition(headTargetPosition, headPos) then
            -- 先頭のキューブの位置がおよそ同じであった場合。
            return 0, false
        else
            -- 先頭のキューブの位置が離れていた場合。
            for i = 1, blockSize do
                local node = RingIterator.Next(iterator)
                CubeTeleporter.Teleport(node, boundsPosition, boundsRotation, currentSec)
            end
            return blockSize, true
        end
    end,

    ProcessSecondaryBlock = function (self, boundsPosition, boundsRotation, currentSec)
        local operationCount = 0

        -- TODO 秒間に処理する個数にあわせて、実装する。現状は仮実装として、1 フレームにつき1個だけ。
        if not self.secondaryRestQueue.IsEmpty() then
            -- rest queue.
            local node = self.secondaryRestQueue.PollLast()
            if node.startSec < self.positionChangedSec then
                -- 位置が変更された。
                CubeTeleporter.Teleport(node, CubeTeleporter.HiddenPosition, boundsRotation, currentSec)
                self.secondaryProcessingQueue.OfferFirst(node)
                operationCount = operationCount + 1
                return operationCount
            else
                -- そのままキューに戻す。
                self.secondaryRestQueue.Offer(node)
            end
        end

        -- processing queue.
        if not self.secondaryProcessingQueue.IsEmpty() then
            local node = self.secondaryProcessingQueue.Poll()
            if node.startSec + CubeTeleporter.IntervalSec < currentSec then
                CubeTeleporter.Teleport(node, boundsPosition, boundsRotation, currentSec)
                self.secondaryRestQueue.Offer(node)
                operationCount = operationCount + 1
            else
                -- そのままキューに戻す。
                self.secondaryProcessingQueue.OfferFirst(node)
            end
        end
        return operationCount
    end,

    Update = function (self)
        local boundsItem = self.boundsItem
        local boundsPosition = boundsItem.GetPosition()
        local boundsRotation = boundsItem.GetRotation()
        local currentSec = vci.me.UnscaledTime.TotalSeconds

        local primaryOperationCount, positionChanged = CubeTeleporter.ProcessPrimaryBlock(self, boundsPosition, boundsRotation, currentSec)
        if positionChanged then
            self.positionChangedSec = currentSec
        end

        self.operationCount = self.operationCount
            + primaryOperationCount
            + CubeTeleporter.ProcessSecondaryBlock(self, boundsPosition, boundsRotation, currentSec)

        if settings.enableDebugging then
            local now = vci.me.UnscaledTime
            local odt = (now - self.operationStartTime).TotalSeconds
            if odt >= 10 then
                cytanb.LogTrace('teleport operation rate: ', cytanb.Round(self.operationCount / odt, 2), ' [op/sec]')
                self.operationStartTime = now
                self.operationCount = 0
            end
        end
    end
}, {
    HiddenPosition = Vector3.__new(0xC00, 0xC00, 0xC00),
    IntervalSec = 5
})

local CubeColorWavelet; CubeColorWavelet = cytanb.SetConstEach({
    LazyMake = function ()
        return coroutine.wrap(function ()
            local size = 0
            local materials = {}
            local originMaterial = nil
            local blockSize = CubeLump.MaxBlockSize
            for k, name in pairs(vci.assets.material.GetNames()) do
                if cytanb.StringStartsWith(name, TenthCube.Prefix) then
                    size = size + 1
                    local mat = CubeMaterial.Make(name)
                    materials[size] = mat
                    if originMaterial then
                        if mat.initialHSV.s > originMaterial.initialHSV.s then
                            originMaterial = mat
                        end
                    else
                        originMaterial = mat
                    end
                end

                if size % blockSize == 0 then
                    coroutine.yield()
                end
            end

            local originHSV = originMaterial and cytanb.Extend({}, originMaterial.initialHSV) or { h = 0, s = 0, v = 0 }

            local ringIterator = RingIterator.Make(materials, 1, size)

            return {
                materials = materials,
                size = size,
                originHSV = originHSV,
                keyHSV = cytanb.Extend({}, originHSV),
                ringIterator = ringIterator,
                startTime = vci.me.UnscaledTime,
                operationStartTime = vci.me.UnscaledTime,
                operationCount = 0,
            }
        end)
    end,

    Update = function (self)
        -- 最大で、1 フレームあたり、1 マテリアルを変更する。
        local now = vci.me.UnscaledTime
        local deltaSec = (now - self.startTime).TotalSeconds

        local material = RingIterator.Next(self.ringIterator)
        local hsv = material.initialHSV
        local h = hsv.h + self.keyHSV.h - self.originHSV.h
        local s = cytanb.PingPong(hsv.s + deltaSec * CubeColorWavelet.WaveletPerSec, 1.0)
        local v = hsv.v + self.keyHSV.v - self.originHSV.v
        if math.abs(material.hsv.s - s) >= CubeColorWavelet.WaveletThreshold then
            CubeMaterial.SetHSV(material, h, s, v)

            if settings.enableDebugging then
                local odt = (now - self.operationStartTime).TotalSeconds
                self.operationCount = self.operationCount + 1
                if odt >= 10 then
                    cytanb.LogTrace('material operation rate: ', cytanb.Round(self.operationCount / odt, 2), ' [op/sec]')
                    self.operationStartTime = now
                    self.operationCount = 0
                end
            end
        end
    end,

    SetKeyHSV = function (self, h, s, v)
        self.keyHSV.h = h
        self.keyHSV.s = s
        self.keyHSV.v = v
    end
}, {
    WaveletPerSec = 0.01,
    WaveletThreshold = 0.01,
})

local CubeRoutine; CubeRoutine = {
    Make = function (optReadyCallback)
        local self; self = {
            lump = nil,
            teleporter = nil,
            colorWavelet = nil,

            _cw = coroutine.wrap(function ()
                local lumpCw = CubeLump.LazyMake()
                while not self.lump do
                    self.lump = lumpCw()
                    coroutine.yield()
                end

                local teleporterCw = CubeTeleporter.LazyMake(self.lump)
                while not self.teleporter do
                    self.teleporter = teleporterCw()
                    coroutine.yield()
                end

                local colorWaveletCw = CubeColorWavelet.LazyMake()
                while not self.colorWavelet do
                    self.colorWavelet = colorWaveletCw()
                    coroutine.yield()
                end

                cytanb.LogInfo('cubes: ', self.lump.size, ', materials: ', self.colorWavelet.size)

                if optReadyCallback then
                    optReadyCallback(self)
                end

                while true do
                    CubeLump.Update(self.lump)
                    CubeTeleporter.Update(self.teleporter)
                    CubeColorWavelet.Update(self.colorWavelet)
                    coroutine.yield()
                end
            end)
        }
        return self
    end,

    Update = function (self)
        self._cw()
    end
}

local MakeStatusParameters = function (routine)
    return {
        senderID = cytanb.ClientID(),
        keyHSV = routine.colorWavelet.keyHSV
    }
end

local routine

local UpdateCw; UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        if deltaTime <= TimeSpan.Zero then
            return
        end

        CubeRoutine.Update(routine)
    end,

    function ()
        cytanb.LogTrace('OnLoad')

        routine = CubeRoutine.Make(function ()
            vciLoaded = true

            cytanb.OnMessage(ColorPaletteItemStatusMessageName, function (sender, name, parameterMap)
                local version = parameterMap.version
                if version and version >= ColorPaletteMinMessageVersion and routine.lump.grabbed then
                    -- クリームを掴んでいる場合は、カラーパレットから色情報を取得する
                    local color = cytanb.ColorFromARGB32(parameterMap.argb32)
                    local h, s, v = cytanb.ColorRGBToHSV(color)
                    local keyHSV = routine.colorWavelet.keyHSV
                    if keyHSV.h ~= h or keyHSV.s ~= s or keyHSV.v ~= v then
                        cytanb.LogDebug('on palette color: ', color)
                        CubeColorWavelet.SetKeyHSV(routine.colorWavelet, h, s, v)
                        cytanb.EmitInstanceMessage(statusMessageName, MakeStatusParameters(routine))
                    end
                end
            end)

            cytanb.OnInstanceMessage(queryStatusMessageName, function (sender, name, parameterMap)
                if vci.assets.IsMine then
                    -- マスターのみ応答する
                    cytanb.EmitInstanceMessage(statusMessageName, MakeStatusParameters(routine))
                end
            end)

            cytanb.OnInstanceMessage(statusMessageName, function (sender, name, parameterMap)
                if parameterMap.senderID ~= cytanb.ClientID() then
                    cytanb.LogTrace('on lump status message')
                    local keyHSV = parameterMap.keyHSV
                    if keyHSV then
                        CubeColorWavelet.SetKeyHSV(routine.colorWavelet, keyHSV.h, keyHSV.s, keyHSV.v)
                    end
                end
            end)

            -- 現在のステータスを問い合わせる。
            cytanb.EmitInstanceMessage(queryStatusMessageName)
        end)
    end,

    function (reason)
        cytanb.LogError('Error on update routine: ', reason)
        UpdateCw = function () end
    end
)

updateAll = function ()
    UpdateCw()
end

onGrab = function (target)
    if not vciLoaded then
        return
    end

    if target == CubeLump.BoundsName then
        CubeLump.Grab(routine.lump)
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    if target == CubeLump.BoundsName then
        CubeLump.Ungrab(routine.lump)
    end
end
