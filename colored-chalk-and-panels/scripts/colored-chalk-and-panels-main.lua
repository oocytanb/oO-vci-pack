-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

cytanb.SetOutputLogLevelEnabled(true)
cytanb.SetLogLevel(cytanb.LogLevelDebug)

--- カラーパレットの共有変数の名前空間。
local ColorPaletteSharedNS = 'com.github.oocytanb.cytanb-tso-collab.color-palette'

--- パレットで選択した色を格納する共有変数名。別の VCI から色を取得可能。ARGB 32 bit 値。
local ARGB32SharedName = ColorPaletteSharedNS .. '.argb32'

-- パレットで選択した色のインデックス値を格納する共有変数名。
-- local ColorIndexSharedName = ColorPaletteSharedNS .. '.color-index'

--- カラーパレットのメッセージの名前空間。
local ColorPaletteMessageNS = 'cytanb.color-palette'

--- メッセージフォーマットのバージョン。
local MessageVersion = 0x10000

--- メッセージフォーマットの最小バージョン。
local MinMessageVersion = 0x10000

--- アイテムのステータスを問い合わせるメッセージ名。
local QueryStatusMessageName = ColorPaletteMessageNS .. '.query-status'

--- アイテムのステータスを通知するメッセージ名。
local ItemStatusMessageName = ColorPaletteMessageNS .. '.item-status'

--- カラーピッカーのタグ。
local ColorPickerTag = '#cytanb-color-picker'

local PanelTag = '#panel'

local ColorStatusPrefix = 'color.'

local AutoChangeUnimsgReceiverStateName = 'autoChangeUnimsgReceiver'
local AutoChangeAnymsgReceiverStateName = 'autoChangeAnymsgReceiver'
local LinkedPaletteInstanceIDState = 'linkedColorPaletteInstanceID'

local ItemNameList, AllMaterialTable, ChalkMaterialTable, PanelMaterialTable, DefaultItemColorMap = (
    function (chalkList, panelList, colorList)
        local ci = 1
        local itemNameList = {}
        local allMaterialTable = {}
        local itemColorMap = {}

        local chalkMaterialTable = {}
        for i, v in ipairs(chalkList) do
            local name = v .. ColorPickerTag
            chalkMaterialTable[name] = v .. '-mat'
            allMaterialTable[name] = chalkMaterialTable[name]
            itemColorMap[name] = cytanb.ColorFromARGB32(colorList[ci])
            table.insert(itemNameList, name)
            ci = ci + 1
        end

        local panelMaterialTable = {}
        for i, v in ipairs(panelList) do
            local name = v .. PanelTag
            panelMaterialTable[name] = v .. '-panel-mat'
            allMaterialTable[name] = panelMaterialTable[name]
            itemColorMap[name] = cytanb.ColorFromARGB32(colorList[ci])
            table.insert(itemNameList, name)
            ci = ci + 1
        end

        return itemNameList, allMaterialTable, chalkMaterialTable, panelMaterialTable, itemColorMap
    end
)(
    {'large-chalk', 'middle-chalk', 'small-chalk'},
    {'shared-variable', 'unimsg-receiver', 'anymsg-receiver'},
    {0xFFE6B422, 0xFF65318E, 0xFFE7E7E7, 0xFF006888, 0xFF00552E, 0xFFA22041}
)

local UnimsgReceiverName = ItemNameList[5]
local AnymsgReceiverName = ItemNameList[6]

local UpdatePeriod = TimeSpan.FromMilliseconds(100)
local QueryPeriod = TimeSpan.FromSeconds(2)

local linkPaletteCw = nil

local GetLinkedInstanceID = function()
    return vci.state.Get(LinkedPaletteInstanceIDState) or ''
end

-- 現在のカラーパレットとのリンクを解除する
local UnlinkPalette = function ()
    vci.state.Set(LinkedPaletteInstanceIDState, '')
end

local IsAutoChangeUnimsgReceiver = function ()
    local b = vci.state.Get(AutoChangeUnimsgReceiverStateName)
    if b == nil then
        return false
    else
        return b
    end
end

local IsAutoChangeAnymsgReceiver = function ()
    local b = vci.state.Get(AutoChangeAnymsgReceiverStateName)
    if b == nil then
        return true
    else
        return b
    end
end

local GetItemColor = function (itemName)
    return cytanb.ColorFromARGB32(vci.state.Get(ColorStatusPrefix .. itemName))
end

local SetItemColor = function (itemName, color)
    vci.state.Set(ColorStatusPrefix .. itemName, cytanb.ColorToARGB32(color))
end

local LinkPaletteProc = function ()
    local itemPosition = vci.assets.GetSubItem(UnimsgReceiverName).GetPosition()
    local candId = ''
    local candPosition = nil
    local candDistance = nil
    local candARGB32 = nil

    UnlinkPalette()

    -- 新しいカラーパレットとリンクするために、問い合わせる
    cytanb.LogDebug('emitMessage: ', QueryStatusMessageName)
    cytanb.EmitMessage(QueryStatusMessageName, {version = MessageVersion})

    local queryExpires = vci.me.Time + QueryPeriod
    while true do
        local cont, parameterMap = coroutine.yield(100)
        if not cont then
            -- abort
            cytanb.LogDebug('LinkPaletteProc aborted.')
            return -301
        end

        if parameterMap then
            -- パレットとの距離を調べる
            local instanceID = parameterMap[cytanb.InstanceIDParameterName]
            local x = parameterMap['positionX']
            local y = parameterMap['positionY']
            local z = parameterMap['positionZ']
            if instanceID and instanceID ~= '' and x and y and z then
                local position = Vector3.__new(x, y, z)
                local distance = Vector3.Distance(position, itemPosition)
                if not candPosition or  distance < candDistance then
                    -- より近い距離のパレットを候補にする
                    candId = instanceID
                    candPosition = position
                    candDistance = distance
                    candARGB32 = parameterMap['argb32']
                end
            end
        end

        if queryExpires < vci.me.Time then
            -- タイムアウトしたので処理を抜ける
            break
        end
    end

    return 0, candId, candARGB32
end

local ResumeLinkPalette = function (parameterMap)
    if not linkPaletteCw then return end

    local code, instanceID, argb32 = linkPaletteCw(true, parameterMap)
    if code <= 0 then
        -- スレッド終了
        cytanb.LogDebug('linkPaletteCw stoped: ', code)
        linkPaletteCw = nil

        if instanceID and instanceID ~= '' and instanceID ~= GetLinkedInstanceID() then
            -- 新しいパレットのインスタンスにリンクする
            print('linked to color-palette #', instanceID)
            vci.state.Set(LinkedPaletteInstanceIDState, instanceID)
            SetItemColor(UnimsgReceiverName, cytanb.ColorFromARGB32(argb32))
        end
    end
end

local updateStateCw = coroutine.wrap(function ()
    local lastUpdateTime = vci.me.Time
    local lastItemColorMap = {}
    local lastAutoChangeUnimsg = IsAutoChangeUnimsgReceiver()

    while true do
        local time = vci.me.Time
        if time >= lastUpdateTime + UpdatePeriod then
            lastUpdateTime = time

            for itemName, materialName in pairs(AllMaterialTable) do
                local color = GetItemColor(itemName)
                if color ~= lastItemColorMap[itemName] then
                    lastItemColorMap[itemName] = color
                    vci.assets.SetMaterialColorFromName(materialName, color)
                end
            end

            if vci.assets.IsMine then
                local autoChangeUnimsg = IsAutoChangeUnimsgReceiver()
                if autoChangeUnimsg ~= lastAutoChangeUnimsg then
                    lastAutoChangeUnimsg = autoChangeUnimsg

                    if autoChangeUnimsg then
                        if linkPaletteCw then
                            -- abort previous thread
                            linkPaletteCw(false)
                        end

                        linkPaletteCw = coroutine.wrap(LinkPaletteProc)
                    else
                        UnlinkPalette()
                    end
                end
            end
        end

        coroutine.yield(100)
    end
    -- return 0
end)

-- アイテムを設置したときの初期化処理
if vci.assets.IsMine then
    for k, v in pairs(DefaultItemColorMap) do
        SetItemColor(k, v)
    end
end

updateAll = function ()
    updateStateCw()

    if vci.assets.IsMine then
        ResumeLinkPalette()
    end
end

onUse = function (use)
    -- 共有変数から色情報を取得する
    local color = cytanb.ColorFromARGB32(vci.studio.shared.Get(ARGB32SharedName))
    cytanb.LogDebug('onUse: ', use, ' ,  shared color = ', color)

    local chalkMaterial = ChalkMaterialTable[use]
    if chalkMaterial then
        SetItemColor(use, color)
    end

    local panelMaterial = PanelMaterialTable[use]
    if panelMaterial then
        SetItemColor(use, color)

        if use == UnimsgReceiverName then
            -- 自動でパレットの選択色に変更するかを切り替える
            vci.state.Set(AutoChangeUnimsgReceiverStateName, not IsAutoChangeUnimsgReceiver())
        elseif use == AnymsgReceiverName then
            -- 自動でパレットの選択色に変更するかを切り替える
            vci.state.Set(AutoChangeAnymsgReceiverStateName, not IsAutoChangeAnymsgReceiver())
        end
    end
end

onCollisionEnter = function (item, hit)
    cytanb.LogDebug('on collision enter: item = ', item, ' , hit = ', hit)

    local chalkMaterial = ChalkMaterialTable[item]
    local panelMaterial = PanelMaterialTable[hit]
    if chalkMaterial and panelMaterial then
        -- チョークがパネルにヒットしたときは、チョークの色をパネルに設定する
        local chalkColor = GetItemColor(item)

        -- まったく同色にすると、チョークと区別できないため、若干値を下げる。
        local d = 0.1
        local color = Color.__new(math.max(chalkColor.r - d, 0.0), math.max(chalkColor.g - d, 0.0), math.max(chalkColor.b - d, 0.0), chalkColor.a)
        cytanb.LogDebug('change panel[', hit, '] color to chalk[', item, ']: color = ', color)
        SetItemColor(hit, color)
    end
end

cytanb.OnMessage(ItemStatusMessageName, function (sender, name, parameterMap)
    if not vci.assets.IsMine then return end

    local version = parameterMap['version']
    if not version or parameterMap['version'] < MinMessageVersion then return end

    -- vci.message から色情報を取得する
    local color = cytanb.ColorFromARGB32(parameterMap['argb32'])
    cytanb.LogDebug('on item status: color = ', color)

    ResumeLinkPalette(parameterMap)

    if IsAutoChangeUnimsgReceiver() then
        local instanceID = parameterMap[cytanb.InstanceIDParameterName]
        local linkedInstanceID = GetLinkedInstanceID()

        if linkedInstanceID ~= '' and linkedInstanceID == instanceID then
            -- リンクされたカラーパレットの色情報の場合のみ、パネルの色を変更する
            print('set unimsg receiver color')
            SetItemColor(UnimsgReceiverName, color)
        end
    end

    if IsAutoChangeAnymsgReceiver() then
        -- どのカラーパレットの色情報であっても、パネルの色を変更する
        print('set anymsg receiver color')
        SetItemColor(AnymsgReceiverName, color)
    end
end)
