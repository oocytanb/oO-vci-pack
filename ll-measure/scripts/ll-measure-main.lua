-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end
local GetGameObjectTransform = function (name) return assert(vci.assets.GetTransform(name)) end

local settings = (function ()
    return {
        enableDebugging = false,
        indexTag = 'cytanb-index',
        measureName = 'll-measure',
        colorMat = 'measure-color-mat',
        colorBrightness = 0.75,
        colorStateName = 'measure-color',
        displayTextName = 'measure-display',
        updatePeriod = TimeSpan.FromMilliseconds(200),
        directionOffset = Vector3.__new(0, 0.25, 0.05),
        directionEfkContainerName = 'direction-efk',
        directionOperationTime = TimeSpan.FromMilliseconds(3000)
    }
end)()

---@class MeasureTerminal
---@field name string
---@field index number
---@field item ExportTransform
---@field new fun (index: number, directionEfkContainer: ExportTransform, directionEfk: ExportEffekseer): MeasureTerminal
---@field Update fun (self: MeasureTerminal)
---@field DoUse fun (self: MeasureTerminal)
---@field DoUnuse fun (self: MeasureTerminal)
local MeasureTerminal

---@type table<string, MeasureTerminal>
local terminalMap

---@type MeasureTerminal[]
local terminalList

MeasureTerminal = {
    new = function (index, directionEfkContainer, directionEfk)
        local name = settings.measureName .. '#' .. settings.indexTag .. '=' .. index

        return setmetatable({
            name = name,
            index = index,
            item = GetSubItem(name),
            directionEfkContainer = assert(directionEfkContainer),
            directionEfk = assert(directionEfk),
            gripPressed = false,
            gripStartTime = TimeSpan.MaxValue
        }, {
            __index = MeasureTerminal
        })
    end,

    Update = function (self)
        local now = vci.me.UnscaledTime
        if self.gripPressed and now - settings.directionOperationTime >= self.gripStartTime then
            -- グリップ長押しで、方向を表示する
            self.gripStartTime = now
            cytanb.LogTrace('play direction-efk: ', self.name)
            local pos = self.item.GetPosition() + self.item.GetRotation() * settings.directionOffset
            local targetPos = terminalList[self.index % 2 + 1].item.GetPosition()
            local lr = Quaternion.LookRotation(targetPos - pos)
            self.directionEfkContainer.SetPosition(pos)
            self.directionEfkContainer.SetRotation(lr)
            self.directionEfk.Play()
        end
    end,

    DoUse = function (self)
        self.gripPressed = true
        self.gripStartTime = vci.me.UnscaledTime
    end,

    DoUnuse = function (self)
        self.gripPressed = false
        self.gripStartTime = TimeSpan.MaxValue
    end
}

local vciLoaded = false

local measureStatus = {
    colorInitialized = false,
    distance = -1,
    lastUpdateTime = TimeSpan.Zero
}

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local UpdateDisplay = function (force)
    local now = vci.me.UnscaledTime
    if not force and now - settings.updatePeriod < measureStatus.lastUpdateTime then
        -- 更新周期に満たない
        return
    end

    local distance = (terminalList[1].item.GetPosition() - terminalList[2].item.GetPosition()).magnitude
    if not force and distance == measureStatus.distance then
        -- 距離に変更がない
        return
    end

    measureStatus.lastUpdateTime = now
    measureStatus.distance = distance

    local uDistance, siPrefix = cytanb.CalculateSIPrefix(measureStatus.distance)
    local str = string.format('%.2f %sm', uDistance, siPrefix)
    vci.assets.SetText(settings.displayTextName, str)
    cytanb.LogTrace('update display: ', str)
end

local UpdateCw; UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        -- 色を設定する。
        if not measureStatus.colorInitialized then
            local argb = vci.state.Get(settings.colorStateName)
            if argb then
                measureStatus.colorInitialized = true
                local color = cytanb.ColorFromARGB32(argb)
                vci.assets.material.SetColor(settings.colorMat, color)
                cytanb.LogTrace('set color: ', color)
            end
        end

        UpdateDisplay()

        for name, terminal in pairs(terminalMap) do
            MeasureTerminal.Update(terminal)
        end
    end,

    function ()
        cytanb.LogTrace('OnLoad')
        vciLoaded = true

        local directionEfkContainer = GetGameObjectTransform(settings.directionEfkContainerName)
        local directionEfk = assert(vci.assets.GetEffekseerEmitter(settings.directionEfkContainerName))

        terminalMap = {}
        terminalList = {}
        for i = 1, 2 do
            local terminal = MeasureTerminal.new(i, directionEfkContainer, directionEfk)
            terminalMap[terminal.name] = terminal
            terminalList[i] = terminal
        end

        if vci.assets.IsMine and not vci.state.Get(settings.colorStateName) then
            -- ランダムで色を決定する。
            local color = Color.HSVToRGB(math.random(), 1, settings.colorBrightness)
            vci.state.Set(settings.colorStateName, cytanb.ColorToARGB32(color))
        end

        -- initialize
        UpdateDisplay(true)
    end,

    function (reason)
        cytanb.LogError('Error on update routine: ', reason)
        UpdateCw = function () end
    end
)

updateAll = function ()
    UpdateCw()
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    local terminal = terminalMap[use]
    if terminal then
        MeasureTerminal.DoUse(terminal)
    end
end

onUnuse = function (use)
    if not vciLoaded then
        return
    end

    local terminal = terminalMap[use]
    if terminal then
        MeasureTerminal.DoUnuse(terminal)
    end
end
