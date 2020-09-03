-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local EnableDebugging = false

--- カラーパレットの共有変数の名前空間。
local ColorPaletteSharedNS = 'com.github.oocytanb.cytanb-tso-collab.color-palette'

--- パレットで選択した色を格納する共有変数名。別の VCI から色を取得可能。ARGB 32 bit 値。
local ARGB32SharedName = ColorPaletteSharedNS .. '.argb32'

--- パレットで選択した色のインデックス値を格納する共有変数名。
local ColorIndexSharedName = ColorPaletteSharedNS .. '.color-index'

--- カラーパレットのメッセージの名前空間。
local ColorPaletteMessageNS = 'cytanb.color-palette'

--- メッセージフォーマットのバージョン。
local MessageVersion = 0x10001

--- メッセージフォーマットの最小バージョン。
local MinMessageVersion = 0x10000

--- アイテムのステータスを問い合わせるメッセージ名。
local QueryStatusMessageName = ColorPaletteMessageNS .. '.query-status'

--- アイテムのステータスを通知するメッセージ名。
local ItemStatusMessageName = ColorPaletteMessageNS .. '.item-status'

--- カラーパレットのタグ。
local ColorPaletteTag = '#cytanb-color-palette'

--- カラーピッカーのタグ。
local ColorPickerTag = '#cytanb-color-picker'

local ColorIndexPrefix = 'cytanb-color-index-'
local CurrentColorMaterialName = 'current-color-mat'

local HitIndexStateName = 'hit-index-state'

local PaletteMaterialName = 'color-palette-mat'
local PalettePageHeight = 200.0 / 1024.0

local AllowedPickerList = {'HandPointMarker', 'RightArm', 'LeftArm', 'RightHand', 'LeftHand'}
local AllowedPickerMap = cytanb.ListToMap(AllowedPickerList, true)

local UpdatePeriod = TimeSpan.FromMilliseconds(100)

local PaletteBase = cytanb.NillableValue(vci.assets.GetSubItem('palette-base' .. ColorPaletteTag))

--- スイッチ類
local advancedSwitch, pickerSwitch, opacitySwitch, brightnessSwitch

local CreateSwitch = function (name, maxState, defaultState, advancedFunction, uvHeight, panelColor, inputInterval)
    local materialName = name .. '-mat'
    local stateName = name .. '-state'
    local default = defaultState or 0
    local height = uvHeight or (50.0 / 1024.0)
    local color = panelColor or Color.__new(0.8, 0.8, 0.8, 1.0)
    local hiddenColor = Color.__new(color.r, color.g, color.b, 0.0)
    local interval = inputInterval or TimeSpan.FromMilliseconds(100)
    local pickerEntered = false
    local lastInputTime = TimeSpan.Zero
    local lastState = nil
    local lastAdvancedState = nil

    local self
    self = {
        name = name,
        item = cytanb.NillableValue(vci.assets.GetSubItem(name)),
        maxState = maxState,
        advancedFunction = advancedFunction,

        GetState = function ()
            return vci.state.Get(stateName) or default
        end,

        SetState = function (state)
            vci.state.Set(stateName, state)
        end,

        NextState = function ()
            local state = (self.GetState() + 1) % (maxState + 1)
            self.SetState(state)
            return state
        end,

        DoInput = function ()
            -- advancedFunction が設定されているスイッチは、advanced モードのときのみ処理する
            if advancedFunction and advancedSwitch.GetState() == 0 then
                return
            end

            local time = vci.me.Time
            if time >= lastInputTime + interval then
                lastInputTime = time
                self.NextState()
            end
        end,

        SetPickerEntered = function (entered)
            pickerEntered = entered
        end,

        IsPickerEntered = function ()
            return pickerEntered
        end,

        Update = function (force)
            local state = self.GetState()
            local advancedState = advancedSwitch.GetState()
            if advancedFunction and (force or advancedState ~= lastAdvancedState) then
                lastAdvancedState = advancedState
                -- advancedFunction が設定されているスイッチは、advanced モードのときのみ表示する
                vci.assets.SetMaterialColorFromName(materialName, advancedState == 0 and hiddenColor or color)
            end

            if force or state ~= lastState then
                lastState = state
                vci.assets.SetMaterialTextureOffsetFromName(materialName, Vector2.__new(0.0, 1.0 - height * state))
                return true
            else
                return false
            end
        end
    }
    return self
end

advancedSwitch = CreateSwitch('advanced-switch', 1, 0, false)
pickerSwitch = CreateSwitch('picker-switch', 1, 0, true)
opacitySwitch = CreateSwitch('opacity-switch', 4, 0, true)
brightnessSwitch = CreateSwitch('brightness-switch', cytanb.ColorBrightnessSamples - 1, 0, true)

local switchMap = {
    [advancedSwitch.name] = advancedSwitch,
    [pickerSwitch.name] = pickerSwitch,
    [opacitySwitch.name] = opacitySwitch,
    [brightnessSwitch.name] = brightnessSwitch
}

local colorIndexSwitchMap = (function ()
    local map = {}
    for i = 1, cytanb.ColorHueSamples * cytanb.ColorSaturationSamples do
        local name = ColorIndexPrefix .. (i - 1)
        map[name] = cytanb.NillableValue(vci.assets.GetSubItem(name))
    end
    return map
end)()

-- サブアイテムを動かした状態で、ゲストが凸したときのことを考慮して、チャンクが評価された時点の位置で、コネクターを作成する。
local switchConnector = (function ()
    local items = {PaletteBase}
    local itemCount = #items
    for name, switch in pairs(switchMap) do
        itemCount = itemCount + 1
        items[itemCount] = switch.item
    end

    for name, item in pairs(colorIndexSwitchMap) do
        itemCount = itemCount + 1
        items[itemCount] = item
    end

    local connector = cytanb.CreateSubItemConnector()
    connector.Add(items)
    return connector
end)()

cytanb.SetOutputLogLevelEnabled(true)
if EnableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local CalculateColor = function (hitIndex, brightnessPage, opacityPage)
    local colorIndex = hitIndex + cytanb.ColorHueSamples * cytanb.ColorSaturationSamples * brightnessPage
    local color = cytanb.ColorFromIndex(colorIndex)
    color.a = (opacitySwitch.maxState - opacityPage) / opacitySwitch.maxState
    return color, colorIndex
end

local GetHitIndex = function ()
    return vci.state.Get(HitIndexStateName) or 9
end

local IsPickerHit = function (hit)
    return hit and (pickerSwitch.GetState() == 1 or AllowedPickerMap[hit] or string.contains(hit, ColorPickerTag))
end

local EmitStatus = function (color, colorIndex)
    local indexSwitch = cytanb.NillableValue(colorIndexSwitchMap[ColorIndexPrefix .. ((colorIndex - 1) % (cytanb.ColorHueSamples * cytanb.ColorSaturationSamples))])
    cytanb.LogDebug('emit status: colorIndex = ', colorIndex, ', color = ', color, ', indexSwitch = ', indexSwitch.GetName())

    local params = {
        version = MessageVersion,
        position = cytanb.Vector3ToTable(PaletteBase.GetPosition()),
        rotation = cytanb.QuaternionToTable(PaletteBase.GetRotation()),
        color = cytanb.ColorToTable(color),
        argb32 = cytanb.ColorToARGB32(color),
        colorIndex = colorIndex,
        colorIndexPosition = cytanb.Vector3ToTable(indexSwitch.GetPosition())
    }

    -- 後方互換性を保つため
    cytanb.Extend(params, cytanb.GetSubItemTransform(PaletteBase))

    cytanb.EmitMessage(ItemStatusMessageName, params)
end

local UpdateStatus = function (color, colorIndex)
    if not vci.assets.IsMine then return end

    cytanb.LogDebug('update status: colorIndex = ', colorIndex, ' ,  color = ', color)

    local argb32 = cytanb.ColorToARGB32(color)
    vci.studio.shared.Set(ARGB32SharedName, argb32)
    vci.studio.shared.Set(ColorIndexSharedName, colorIndex)

    EmitStatus(color, colorIndex)
end

local updateStateCw = coroutine.wrap(function ()
    local firstUpdate = true

    local lastUpdateTime = vci.me.Time
    local lastHitIndex = -1

    while true do
        local time = vci.me.Time

        if not firstUpdate then
            switchConnector.Update()
        end

        if time >= lastUpdateTime + UpdatePeriod then
            lastUpdateTime = time

            --
            local switchChanged = false
            for k, v in pairs(switchMap) do
                local b = v.Update(firstUpdate)
                if v == brightnessSwitch or v == opacitySwitch then
                    switchChanged = switchChanged or b
                end
            end

            --
            local hitIndex = GetHitIndex()
            if firstUpdate or lastHitIndex ~= hitIndex or switchChanged then
                local brightnessPage = brightnessSwitch.GetState()
                local color, colorIndex = CalculateColor(hitIndex, brightnessPage, opacitySwitch.GetState())

                cytanb.LogDebug('update currentColor: colorIndex = ', colorIndex, ' ,  color = ', color)
                lastHitIndex = hitIndex

                vci.assets.SetMaterialColorFromName(CurrentColorMaterialName, color)
                vci.assets.SetMaterialTextureOffsetFromName(PaletteMaterialName, Vector2.__new(0.0, 1.0 - PalettePageHeight * brightnessPage))

                UpdateStatus(color, colorIndex)
            end

            --
            firstUpdate = false
        end

        coroutine.yield(100)
    end
    -- return 0
end)

cytanb.OnMessage(QueryStatusMessageName, function (sender, name, parameterMap)
    if not vci.assets.IsMine then
        return
    end

    if parameterMap.version and (parameterMap.version < MinMessageVersion or parameterMap.version > MessageVersion) then
        -- バージョン指定がされていて、範囲外であった場合は無視する。
        return
    end

    local color, colorIndex = CalculateColor(GetHitIndex(), brightnessSwitch.GetState(), opacitySwitch.GetState())
    EmitStatus(color, colorIndex)
end)

-- アイテムを設置したときの初期化処理
if vci.assets.IsMine then
    local color, colorIndex = CalculateColor(GetHitIndex(), brightnessSwitch.GetState(), opacitySwitch.GetState())
    UpdateStatus(color, colorIndex)
end

updateAll = function ()
    updateStateCw()
end

onGrab = function (target)
    cytanb.LogDebug('onGrab: ', target)
end

onUse = function (use)
    if advancedSwitch.IsPickerEntered() then
        cytanb.LogDebug('onUse: ', advancedSwitch.name)
        advancedSwitch.DoInput()
    elseif pickerSwitch.IsPickerEntered() then
        cytanb.LogDebug('onUse: ', pickerSwitch.name)
        pickerSwitch.DoInput()
    end
end

onTriggerEnter = function (item, hit)
    if IsPickerHit(hit) then
        local switch = switchMap[item]
        if switch then
            if PaletteBase.IsMine then
                switch.SetPickerEntered(true)
            end

            if switch == opacitySwitch or switch == brightnessSwitch then
                switch.DoInput()
            end
        elseif string.startsWith(item, ColorIndexPrefix) then
            local hitIndex = math.floor(tonumber(string.sub(item, 1 + string.len(ColorIndexPrefix))))
            cytanb.LogDebug('on trigger: hitIndex = ', hitIndex, ' hit = ', hit)
            if (hitIndex) then
                vci.state.Set(HitIndexStateName, hitIndex)
            end
        end
    end
end

onTriggerExit = function (item, hit)
    local switch = switchMap[item]
    if switch then
        switchMap[item].SetPickerEntered(false)
    end
end
