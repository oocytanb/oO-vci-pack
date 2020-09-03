-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local GetGameObjectTransform = function (name) return assert(vci.assets.GetTransform(name)) end
local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end

local settings = (function ()
    local hueSwitchName = 'hue-switch'
    local saturationSwitchName = 'saturation-switch'
    local brightnessSwitchName = 'brightness-switch'
    local alphaSwitchName = 'alpha-switch'
    local elevationSwitchName = 'elevation-switch'
    local scaleSwitchName = 'scale-switch'

    local defaultMinScaleValue = 0
    local defaultMaxScaleValue = 1

    local elevationMinScaleValue = -1
    local elevationMaxScaleValue = 1

    local scaleMinScaleValue = -5
    local scaleMaxScaleValue = 5

    return {
        enableDebugging = false,
        lsp = cytanb.CreateLocalSharedProperties('88057c29-4e07-4d95-a498-ecf93a5f0d46', tostring(cytanb.RandomUUID())),
        opaqueDomeName = 'opaque-dome',
        alphaDomeName = 'alpha-dome',
        opaqueDomeMat = 'opaque-dome-mat',
        alphaDomeMat = 'alpha-dome-mat',
        domeControllerName = 'dome-controller',
        powerLampOnRotation = Quaternion.identity,
        powerLampOffRotation = Quaternion.AngleAxis(180, Vector3.right),

        powerLampName = 'power-lamp',
        resetSwitchName = 'reset-switch',
        resetSwitchKnob = 'reset-knob',

        hueSwitchName = hueSwitchName,
        saturationSwitchName = saturationSwitchName,
        brightnessSwitchName = brightnessSwitchName,
        alphaSwitchName = alphaSwitchName,
        elevationSwitchName = elevationSwitchName,
        scaleSwitchName = scaleSwitchName,

        --- 調節用スイッチのパラメーター。
        switchParameters = cytanb.ListToMap({
            {
                colliderName = hueSwitchName,
                baseName = 'hue-knob-position',
                knobName = 'hue-knob',
                minScaleValue = defaultMinScaleValue,
                maxScaleValue = defaultMaxScaleValue
            },
            {
                colliderName = saturationSwitchName,
                baseName = 'saturation-knob-position',
                knobName = 'saturation-knob',
                minScaleValue = defaultMinScaleValue,
                maxScaleValue = defaultMaxScaleValue
            },
            {
                colliderName = brightnessSwitchName,
                baseName = 'brightness-knob-position',
                knobName = 'brightness-knob',
                minScaleValue = defaultMinScaleValue,
                maxScaleValue = defaultMaxScaleValue
            },
            {
                colliderName = alphaSwitchName,
                baseName = 'alpha-knob-position',
                knobName = 'alpha-knob',
                value = 100,
                minScaleValue = defaultMinScaleValue,
                maxScaleValue = defaultMaxScaleValue
            },
            {
                colliderName = elevationSwitchName,
                baseName = 'elevation-knob-position',
                knobName = 'elevation-knob',
                minValue = -50,
                maxValue = 50,
                value = -1,
                minScaleValue = elevationMinScaleValue,
                maxScaleValue = elevationMaxScaleValue,
                calcSwitchValue = function (switch)
                    local sv = switch.GetScaleValue(elevationMinScaleValue, elevationMaxScaleValue)
                    local av = math.abs(sv)
                    local minX = -5
                    local maxX = 5
                    local exp = (maxX - minX) * av + minX
                    return 12.5122 * (sv >= 0 and 1 or -1) * (2 ^ exp - 2 ^ minX)
                end
            },
            {
                colliderName = scaleSwitchName,
                baseName = 'scale-knob-position',
                knobName = 'scale-knob',
                value = 80,
                minScaleValue = scaleMinScaleValue,
                maxScaleValue = scaleMaxScaleValue,
                calcSwitchValue = function (switch)
                    local sv = switch.GetScaleValue(scaleMinScaleValue, scaleMaxScaleValue)
                    return 25.0244 * (2 ^ sv - 2 ^ scaleMinScaleValue)
                end
            }
        }, function (entry)
            local minValue = entry.minValue or 0
            local maxValue = entry.maxValue or 100
            local minScaleValue = entry.minScaleValue or minValue
            local maxScaleValue = entry.maxScaleValue or maxValue

            local calcSwitchValue = entry.calcSwitchValue or function (switch)
                return switch.GetScaleValue(minScaleValue, maxScaleValue)
            end

            local valueToText = entry.valueToText or function (value, source)
                return string.format('%.2f', calcSwitchValue(source))
            end

            return entry.colliderName, {
                colliderName = entry.colliderName,
                baseName = entry.baseName,
                knobName = entry.knobName,
                minValue = minValue,
                maxValue = maxValue,
                value = entry.value or 0,
                minScaleValue = minScaleValue,
                maxScaleValue = maxScaleValue,
                tickFrequency = 1,
                tickVector = Vector3.__new(0.0, 0.11 / (maxValue - minValue), 0.0),
                valueTextName = entry.colliderName .. '-value-text',
                valueToText = valueToText,
                calcSwitchValue = calcSwitchValue
            }
        end)
    }
end)()

local vciLoaded = false

local hiddenPosition

local opaqueDome = GetGameObjectTransform(settings.opaqueDomeName)
local alphaDome = GetGameObjectTransform(settings.alphaDomeName)
local powerLamp = GetGameObjectTransform(settings.powerLampName)

local controllerGlue
local resetSwitch
local slideSwitchMap, hueSwitch, saturationSwitch, brightnessSwitch, alphaSwitch, elevationSwitch, scaleSwitch

local domeStatus = {
    item = opaqueDome,
    itemMat = settings.opaqueDomeMat,
    point = Vector3.__new(0, 0, 0),
    color = Color.__new(0, 0, 0),
    elevation = 0,
    uniScale = 0,
    visible = false,
    dirty = false
}

local resetSwitchStatus = {
    clickCount = 0,
    clickTime = TimeSpan.Zero
}

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local GetSwitchParameters = function (switch)
    return assert(settings.switchParameters[switch.GetColliderItem().GetName()])
end

local CalcColorSwitchValue = function ()
    local color = Color.HSVToRGB(
        GetSwitchParameters(hueSwitch).calcSwitchValue(hueSwitch),
        GetSwitchParameters(saturationSwitch).calcSwitchValue(saturationSwitch),
        GetSwitchParameters(brightnessSwitch).calcSwitchValue(brightnessSwitch)
    )
    color.a = GetSwitchParameters(alphaSwitch).calcSwitchValue(alphaSwitch)
    return color
end

local CalcElevationSwitchValue = function ()
    return GetSwitchParameters(elevationSwitch).calcSwitchValue(elevationSwitch)
end

local CalcScaleSwitchValue = function ()
    return GetSwitchParameters(scaleSwitch).calcSwitchValue(scaleSwitch)
end

local UpdateDomeColor = function (dome, color)
    cytanb.LogTrace('update dome color: ', color)
    dome.color = color
    vci.assets.material.SetColor(dome.itemMat, color)
end

local UpdateDomeElevation = function (dome, elevation)
    cytanb.LogTrace('update dome elevation: ', elevation)
    dome.elevation = elevation
    dome.item.SetPosition(dome.visible and Vector3.__new(dome.point.x, elevation, dome.point.z) or hiddenPosition)
end

local UpdateDomeScale = function (dome, uniScale)
    cytanb.LogTrace('update dome scale: ', uniScale)
    dome.uniScale = uniScale
    dome.item.SetLocalScale(dome.visible and Vector3.__new(uniScale, uniScale, uniScale) or Vector3.zero)
end

local UpdateDomeVisible = function (dome, visible)
    cytanb.LogTrace('update dome visible: ', visible)
    dome.visible = visible
    UpdateDomeElevation(dome, dome.elevation)
    UpdateDomeScale(dome, dome.uniScale)
    powerLamp.SetLocalRotation(visible and settings.powerLampOnRotation or settings.powerLampOffRotation)
end

local FlipDome = function (dome, opaque)
    cytanb.LogTrace('flip dome: opaque = ', opaque)
    local iDome
    if opaque then
        dome.item = opaqueDome
        dome.itemMat = settings.opaqueDomeMat
        iDome = alphaDome
    else
        dome.item = alphaDome
        dome.itemMat = settings.alphaDomeMat
        iDome = opaqueDome
    end

    UpdateDomeElevation(dome, dome.elevation)
    UpdateDomeScale(dome, dome.uniScale)

    iDome.SetPosition(hiddenPosition)
    iDome.SetLocalScale(Vector3.zero)
end

local ResetDome = function (dome)
    for name, switch in pairs(slideSwitchMap) do
        switch.SetValue(GetSwitchParameters(switch).value)
    end

    FlipDome(dome, true)
    UpdateDomeElevation(dome, CalcElevationSwitchValue())
    UpdateDomeScale(dome, CalcScaleSwitchValue())
    UpdateDomeColor(dome, CalcColorSwitchValue())

    dome.dirty = false
end

local OnResetCommand = function ()
    if domeStatus.dirty then
        -- ダーティーフラグがセットされていた場合は、デフォルト値にリセットする
        domeStatus.dirty = false
        cytanb.LogTrace('Reset settings')
        ResetDome(domeStatus)
    else
        -- ダーティーフラグがセットされていない場合は、表示・非表示を切り替える
        UpdateDomeVisible(domeStatus, not domeStatus.visible)
    end
end

local UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        controllerGlue.Update()

        for name, switch in pairs(slideSwitchMap) do
            switch.Update()
        end

        if deltaTime <= TimeSpan.Zero then
            return
        end
    end,

    function ()
        cytanb.LogTrace('OnLoad')
        vciLoaded = true

        local uuid = cytanb.UUIDFromString(cytanb.InstanceID())
        hiddenPosition = Vector3.__new(uuid[1] / 0x100000, 0x1000, uuid[2] / 0x100000)

        controllerGlue = cytanb.CreateSubItemGlue()

        resetSwitch = GetSubItem(settings.resetSwitchName)
        controllerGlue.Add(GetGameObjectTransform(settings.resetSwitchKnob), resetSwitch)

        slideSwitchMap = {}
        for k, parameters in pairs(settings.switchParameters) do
            local switch = cytanb.CreateSlideSwitch(
                cytanb.Extend({
                    colliderItem = GetSubItem(parameters.colliderName),
                    baseItem = GetGameObjectTransform(parameters.baseName),
                    knobItem = GetGameObjectTransform(parameters.knobName),
                    tickFrequency = parameters.tickFrequency
                }, parameters, false, true)
            )

            slideSwitchMap[parameters.colliderName] = switch
        end

        local SwitchValueChanged = function ()
            domeStatus.dirty = true
            if not domeStatus.visible then
                UpdateDomeVisible(domeStatus, true)
            end
        end

        local hsvListener = function (source, value)
            UpdateDomeColor(domeStatus, CalcColorSwitchValue())
            SwitchValueChanged()
        end

        hueSwitch = assert(slideSwitchMap[settings.hueSwitchName])
        hueSwitch.AddListener(hsvListener)

        saturationSwitch = assert(slideSwitchMap[settings.saturationSwitchName])
        saturationSwitch.AddListener(hsvListener)

        brightnessSwitch = assert(slideSwitchMap[settings.brightnessSwitchName])
        brightnessSwitch.AddListener(hsvListener)

        alphaSwitch = assert(slideSwitchMap[settings.alphaSwitchName])
        alphaSwitch.AddListener(function (source, value)
            local color = CalcColorSwitchValue()
            if color.a == 1 then
                -- 完全に不透明
                if domeStatus.color.a ~= 1 then
                    FlipDome(domeStatus, true)
                end
            else
                if domeStatus.color.a == 1 then
                    FlipDome(domeStatus, false)
                end
            end

            UpdateDomeColor(domeStatus, color)
            SwitchValueChanged()
        end)

        elevationSwitch = assert(slideSwitchMap[settings.elevationSwitchName])
        elevationSwitch.AddListener(function (source, value)
            UpdateDomeElevation(domeStatus, CalcElevationSwitchValue())
            SwitchValueChanged()
        end)

        scaleSwitch = assert(slideSwitchMap[settings.scaleSwitchName])
        scaleSwitch.AddListener(function (source, value)
            -- cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
            UpdateDomeScale(domeStatus, CalcScaleSwitchValue())
            SwitchValueChanged()
        end)

        -- initialize
        ResetDome(domeStatus)
        UpdateDomeVisible(domeStatus, false)
    end
)

updateAll = function ()
    UpdateCw()
end

onGrab = function (target)
    if not vciLoaded then
        return
    end

    if target == settings.resetSwitchName then
        resetSwitchStatus.clickCount, resetSwitchStatus.clickTime = cytanb.DetectClicks(resetSwitchStatus.clickCount, resetSwitchStatus.clickTime, settings.grabClickTiming)
        if resetSwitchStatus.clickCount >= 2 then
            -- リセットスイッチを 2 回以上グラブする操作で、リセットを行う。
            -- (ユーザーは、スライドスイッチをグラブすると操作できるので、同じ入力キーで操作できるものと期待するため)
            OnResetCommand()
        end
    else
        local switch = slideSwitchMap[target]
        if switch then
            switch.DoGrab()
        end
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    local switch = slideSwitchMap[target]
    if switch then
        switch.DoUngrab()
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == settings.resetSwitchName then
        OnResetCommand()
    else
        local switch = slideSwitchMap[use]
        if switch then
            switch.DoUse()
        end
    end
end

onUnuse = function (use)
    if not vciLoaded then
        return
    end

    local switch = slideSwitchMap[use]
    if switch then
        switch.DoUnuse()
    end
end
