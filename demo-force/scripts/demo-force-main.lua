-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local CreateSoftImpactor = function (item, maxForceMagnitude)
    local AssertMaxForceMagnitude = function (forceMagnitude)
        if forceMagnitude < 0 then
            error('CreateSoftImpactor: Invalid argument: forceMagnitude < 0', 3)
        end
        return forceMagnitude
    end

    local maxMagnitude = AssertMaxForceMagnitude(maxForceMagnitude)
    local accf = Vector3.zero

    return {
        Reset = function ()
            accf = Vector3.zero
        end,

        GetMaxForceMagnitude = function ()
            return maxMagnitude
        end,

        SetMaxForceMagnitude = function (magnitude)
            maxMagnitude = AssertMaxForceMagnitude(magnitude)
        end,

        GetAccumulatedForce = function ()
            return accf
        end,

        AccumulateForce = function (force, deltaTime, fixedTimestep)
            local ds = deltaTime.TotalSeconds
            local fs = fixedTimestep.TotalSeconds
            if ds <= 0 or fs <= 0 then
                return
            end

            accf = accf + ds / fs * force
        end,

        --- `updateAll` 関数の最後で、この関数を呼び出すこと。
        Update = function ()
            if accf == Vector3.zero then
                return
            end

            if not item.IsMine then
                -- 操作権が無い場合はリセットする。
                accf = Vector3.zero
                return
            end

            if maxMagnitude <= 0 then
                return
            end

            local am = accf.magnitude
            local f
            if am <= maxMagnitude then
                f = accf
                accf = Vector3.zero
            else
                -- 制限を超えている部分は、次以降のフレームに繰り越す
                f = maxMagnitude / am * accf
                accf = accf - f
                -- cytanb.LogTrace('CreateSoftImpactor: on Update: accf.magnitude = ', accf.magnitude)
            end

            item.AddForce(f)
        end
    }
end

local demoForceNS = 'com.github.oocytanb.oO-vci-pack.demo-force'
local statusMessageName = demoForceNS .. '.status'

local impactorEnabled = true

local statusLabelName = 'status-label'
local resetSwitch

local mdgPosBase
local mdgDistance = 0.5
local mdgList
local m1d0g0, m1d0g1, m1d0gf, m5d0g0, m5d0g1, m5d0gf, m5d9g0, m5d9g1, m5d9gf
local estimaterObject

local timeQueue = cytanb.CreateCircularQueue(120)
local statusPeriod = TimeSpan.FromMilliseconds(200)
local lastStatusTime = TimeSpan.Zero
local messagePeriod = TimeSpan.FromSeconds(3)
local lastMessageTime = TimeSpan.Zero

local timestepEstimaterOptions = {
    minCalcInterval = TimeSpan.FromMinutes(3),
    maxCalcInterval = TimeSpan.FromMinutes(20)
}

local timestepEstimater
local fixedTimestep
local timestepPrecision
local initialEstimater = true
local startEstimateFlag = false

local vciLoaded = false

cytanb.SetLogLevel(cytanb.LogLevelAll)
cytanb.SetOutputLogLevelEnabled(true)

local CalcFrameRate = function (queue)
    local frameCount = queue.Size()
    if frameCount < 2 then
        return 0, 0
    end

    local s = queue.Peek()
    local e = queue.PeekLast()
    local dt = (e.time - s.time).TotalSeconds
    local unscaledDt = (e.unscaledTime - s.unscaledTime).TotalSeconds
    return dt > 0 and frameCount / dt or 0, unscaledDt > 0 and frameCount / unscaledDt or 0
end

local UpdateStatusText = function (statusMap)
    local statusText = 'timestep: ' .. cytanb.Round(statusMap.timestep.TotalSeconds, 4) .. ' (precision: ' .. cytanb.Round(statusMap.timestepPrecision, 4) .. ')\n' ..
                        'timestep being calculated: ' .. cytanb.Round(statusMap.timestepBeingCalculated.TotalSeconds, 4) .. ' (precision: ' .. cytanb.Round(statusMap.timestepPrecisionBeingCalculated, 4) .. ')\n' ..
                        'rate: ' .. cytanb.Round(statusMap.fps > 0 and 1 / statusMap.fps or 0, 4) .. ' (' .. cytanb.Round(statusMap.fps, 4) .. ')\n' ..
                        --'unscaled rate: ' .. cytanb.Round(unscaledFps > 0 and 1 / unscaledFps or 0, 4) .. ' (' .. cytanb.Round(unscaledFps, 4) .. ')\n' ..
                        'IsMine: ' .. tostring(resetSwitch.IsMine)
    vci.assets.SetText(statusLabelName, statusText)
end

local CreateMdg = function (name, mass, drag, useGravity)
    local item = cytanb.NillableValue(vci.assets.GetSubItem(name))
    local simMass = mass or 1.0
    return {
        name = name,
        item = item,
        mass = simMass,
        drag = drag or 0.0,
        useGravity = not not useGravity,
        impactor = CreateSoftImpactor(item, simMass * 9.81 * 2.0)
    }
end

local ResetMdgPosition = function ()
    local basePos = mdgPosBase.GetPosition()
    local baseRot = mdgPosBase.GetRotation()
    local baseRight = mdgPosBase.GetRight()
    local baseUp = mdgPosBase.GetUp()

    for i, mdg in ipairs(mdgList) do
        local item = mdg.item
        item.SetPosition(basePos + baseUp * -0.25 + baseRight * ((i - 1) * mdgDistance))
        item.SetRotation(baseRot)
        item.SetVelocity(Vector3.zero)
        item.SetAngularVelocity(Vector3.zero)
        mdg.impactor.Reset()
    end
end

local UpdateCw; UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        if startEstimateFlag then
            timestepEstimater = cytanb.EstimateFixedTimestep(estimaterObject.item, timestepEstimaterOptions)
            startEstimateFlag = false
        else
            timestepEstimater.Update()
            if initialEstimater then
                fixedTimestep = timestepEstimater.Timestep()
                timestepPrecision = timestepEstimater.Precision()
            end

            -- if not timestepEstimater.IsFinished() then
            --     cytanb.LogTrace('timestep: ', timestepEstimater.Timestep().TotalSeconds, ' | percision: ', timestepEstimater.Precision())
            -- end
        end

        if resetSwitch.IsMine then
            local unscaledTime = vci.me.UnscaledTime
            timeQueue.Offer({time = vci.me.Time, unscaledTime = unscaledTime})
            local fps, unscaledFps = CalcFrameRate(timeQueue)
            local statusMap = {
                timestep = fixedTimestep,
                timestepPrecision = timestepPrecision,
                timestepBeingCalculated = timestepEstimater.Timestep(),
                timestepPrecisionBeingCalculated = timestepEstimater.Precision(),
                fps = fps,
                unscaledFps = unscaledFps
            }

            if unscaledTime > lastStatusTime + statusPeriod then
                UpdateStatusText(statusMap)
                lastStatusTime = unscaledTime
            end

            if unscaledTime > lastMessageTime + messagePeriod then
                local parameterMap = cytanb.Extend({
                    timestepTicks = statusMap.timestep.Ticks,
                    timestepTicksBeingCalculated = timestepEstimater.Timestep().Ticks
                }, statusMap)
                cytanb.EmitMessage(statusMessageName, parameterMap)
                lastMessageTime = unscaledTime
                cytanb.LogTrace('emit status: timestep = ', cytanb.Round(parameterMap.timestep.TotalSeconds, 4), ', rate: ', cytanb.Round(parameterMap.fps > 0 and 1 / parameterMap.fps or 0, 4), ' (', cytanb.Round(parameterMap.fps, 4), ')')
            end

            -- Unity の重力加速度の規定値は 9.81 だが、update で AddForce する分には、完全に静止することはない。
            if impactorEnabled then
                local acc = 9.81
                m1d0g0.impactor.AccumulateForce(Vector3.up * (m1d0g1.mass * -acc), deltaTime, fixedTimestep)
                m1d0gf.impactor.AccumulateForce(Vector3.up * (m1d0gf.mass * acc), deltaTime, fixedTimestep)

                m5d0g0.impactor.AccumulateForce(Vector3.up * (m5d0g0.mass * -acc), deltaTime, fixedTimestep)
                m5d0gf.impactor.AccumulateForce(Vector3.up * (m5d0gf.mass * acc), deltaTime, fixedTimestep)

                m5d9g0.impactor.AccumulateForce(Vector3.up * (m5d9g0.mass * -acc), deltaTime, fixedTimestep)
                m5d9gf.impactor.AccumulateForce(Vector3.up * (m5d9gf.mass * acc), deltaTime, fixedTimestep)
            else
                local acc = 9.81 * deltaTime.TotalSeconds / fixedTimestep.TotalSeconds
                --local acc = 9.81
                --cytanb.LogTrace('deltaSec: ', deltaTime.TotalSeconds)

                m1d0g0.item.AddForce(Vector3.up * (m1d0g1.mass * -acc))
                m1d0gf.item.AddForce(Vector3.up * (m1d0gf.mass * acc))

                m5d0g0.item.AddForce(Vector3.up * (m5d0g0.mass * -acc))
                m5d0gf.item.AddForce(Vector3.up * (m5d0gf.mass * acc))

                m5d9g0.item.AddForce(Vector3.up * (m5d9g0.mass * -acc))
                m5d9gf.item.AddForce(Vector3.up * (m5d9gf.mass * acc))
            end
        end

        if impactorEnabled then
            for i, mdg in ipairs(mdgList) do
                mdg.impactor.Update()
                -- local accf = mdg.impactor.GetAccumulatedForce()
                -- if accf ~= Vector3.zero then
                --     cytanb.LogTrace('accf = ', accf, ', maxMagnitude = ', mdg.impactor.GetMaxForceMagnitude())
                --     mdg.impactor.SetMaxForceMagnitude(mdg.impactor.GetMaxForceMagnitude() * 1.1)
                -- end
            end
        end
    end,

    function ()
        cytanb.LogTrace('OnLoad')
        vciLoaded = true

        resetSwitch = cytanb.NillableValue(vci.assets.GetSubItem('reset-switch'))
        mdgPosBase = cytanb.NillableValue(vci.assets.GetSubItem('cube-pos-base'))

        m1d0g0 = CreateMdg('m1d0g0', 1.0, 0.0, false)
        m1d0g1 = CreateMdg('m1d0g1', 1.0, 0.0, true)
        m1d0gf = CreateMdg('m1d0gf', 1.0, 0.0, true)
        m5d0g0 = CreateMdg('m5d0g0', 5.0, 0.0, false)
        m5d0g1 = CreateMdg('m5d0g1', 5.0, 0.0, true)
        m5d0gf = CreateMdg('m5d0gf', 5.0, 0.0, true)
        m5d9g0 = CreateMdg('m5d9g0', 5.0, 9.0, false)
        m5d9g1 = CreateMdg('m5d9g1', 5.0, 9.0, true)
        m5d9gf = CreateMdg('m5d9gf', 5.0, 9.0, true)
        estimaterObject = CreateMdg('timestep-estimater', 1.0, 0.0, false)

        mdgList = {m1d0g0, m1d0g1, m1d0gf, m5d0g0, m5d0g1, m5d0gf, m5d9g0, m5d9g1, m5d9gf}

        timestepEstimater = cytanb.EstimateFixedTimestep(estimaterObject.item, timestepEstimaterOptions)
        fixedTimestep = timestepEstimater.Timestep()
        timestepPrecision = timestepEstimater.Precision()

        cytanb.OnInstanceMessage(statusMessageName, function (sender, name, parameterMap)
            if not resetSwitch.IsMine then
                cytanb.LogTrace('on status: timestep = ', cytanb.Round(TimeSpan.FromTicks(parameterMap.timestepTicks).TotalSeconds, 4), ', rate: ', cytanb.Round(parameterMap.fps > 0 and 1 / parameterMap.fps or 0, 4), ' (', cytanb.Round(parameterMap.fps, 4), ')')
                UpdateStatusText(cytanb.Extend({
                    timestep = TimeSpan.FromTicks(parameterMap.timestepTicks),
                    timestepBeingCalculated = TimeSpan.FromTicks(parameterMap.timestepTicksBeingCalculated)
                }, parameterMap))
            end
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

    if target == resetSwitch.GetName() then
        timeQueue.Clear()
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == resetSwitch.GetName() then
        ResetMdgPosition()
        fixedTimestep = timestepEstimater.Timestep()
        timestepPrecision = timestepEstimater.Precision()
        initialEstimater = false
        startEstimateFlag = true
    end
end
