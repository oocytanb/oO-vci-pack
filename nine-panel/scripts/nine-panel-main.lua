-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local settings = (function ()
    local cballSettingsLspid = 'ae00bdfc-98ec-4fbf-84a6-1a52823cfe69'
    local ignoreTag = 'cytanb-ignore'

    return {
        enableDebugging = false,
        lsp = cytanb.CreateLocalSharedProperties(cballSettingsLspid, tostring(cytanb.RandomUUID())),
        throwableTag = 'cytanb-throwable',
        ballTag = 'cytanb-ball',
        ignoreTag = ignoreTag,
        panelCount = 9,
        panelBaseName = 'nine-panel-base#' .. ignoreTag,
        panelControllerName = 'panel-controller',
        panelControllerOperatorLampName = 'panel-controller-operator-lamp',
        panelFrameOperatorLampName = 'panel-frame-operator-lamp',
        panelTiltName = 'frame-tilt',
        initialPanelTiltAngle = -90,
        panelPosPrefix = 'panel-pos#',
        panelMeshPrefix = 'panel-mesh#',
        panelColliderPrefix = 'panel-collider#cytanb-target=',
        panelSimLongSide = 0.5,
        breakEfkContainerName = 'break-efk',
        breakPanelAudioName = 'break-se',
        tickVector = Vector3.__new(0.0, 0.0111, 0.0),
        audioVolumePropertyName = 'audioVolume',
        audioVolumeSwitchName = 'volume-switch',
        audioVolumeKnobName = 'volume-knob',
        audioVolumeKnobPos = 'volume-knob-pos',
        audioVolumeMinValue = 0,
        audioVolumeMaxValue = 100,
        tiltSwitchName = 'tilt-switch',
        tiltKnobName = 'tilt-knob',
        tiltKnobPos = 'tilt-knob-pos',
        tiltMinValue = -90,
        tiltMaxValue = 90,
        resetSwitchName = 'reset-switch',
        resetSwitchMesh = 'reset-switch-mesh',
        avatarColliders = {'Head', 'Chest', 'Hips', 'RightArm', 'LeftArm', 'RightHand', 'LeftHand', 'RightThigh', 'LeftThigh', 'RightFoot', 'LeftFoot', 'RightToes', 'LeftToes'},
        envColliders = {'HandPointMarker', 'NameBoard(Clone)', 'RailButton', 'Controller (right)', 'Controller (left)', 'HandiCamera(Clone)', 'GuestCamera(Clone)', 'AutoFollowCamera(Clone)', 'CaptureCamera(Clone)', 'MovieCaptureCamera(Clone)', 'MirroObjectOrg', 'Monitor Board Collider', 'Region Visualizer', 'LightSource(Clone)', 'TransparentPlane'},
        limitHitSource = false,
        grabClickTiming = TimeSpan.FromMilliseconds(1000),
        resetOperationTime = TimeSpan.FromMilliseconds(1500),
        minRequestIntervalTime = TimeSpan.FromMilliseconds(200),
        maxRequestIntervalTime = TimeSpan.FromMilliseconds(3000),
        panelMendIntervalTime = TimeSpan.FromSeconds(2),
        autoResetWaitingTime = TimeSpan.FromSeconds(60)
    }
end)()

local panelNS = 'com.github.oocytanb.oO-vci-pack.nine-panel'
local statusMessageName = panelNS .. '.status'
local queryStatusMessageName = panelNS .. '.query-status'
local resetMessageName = panelNS .. '.reset'
local breakPanelMessageName = panelNS .. '.break-panel'
local changePanelBaseMessageName = panelNS .. '.change-panel-base'

local cballNS = 'com.github.oocytanb.oO-vci-pack.cball'
local hitMessageName = cballNS .. '.hit'

local vciLoaded = false

local hiddenPosition

local ignoredColliderMap
local panelBase, panelTilt, panelFrameOperatorLamp, panelMap
local panelController, panelControllerOperatorLamp, panelControllerGlue
local slideSwitchMap, audioVolumeSwitch, tiltSwitch
local resetSwitch

local breakEfkContainer, breakEfk

local panelBaseStatus = {
    --- フレームがつかまれているか。
    grabbed = false,

    --- フレームの傾きが変更されていることを示すフラグ。
    tiltChanged = false,

    --- オペレーターランプの状態。
    operatorLampOn = false,

    --- パネルの傾きを送った時間。
    tiltSentTime = TimeSpan.Zero,

    --- 最後にパネルを直した時間。
    lastMendedTime = TimeSpan.Zero,

    --- すべてのパネルがヒットしてゲームが終了した時間。
    gameCompletedTime = TimeSpan.Zero
}

local resetSwitchStatus = {
    --- クリック数。
    clickCount = 0,

    --- クリック時間。
    clickTime = TimeSpan.Zero,

    --- グリップされているか。
    gripPressed = false,

    --- リセットスイッチがグリップされた時間。
    gripStartTime = TimeSpan.MaxValue
}

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local IsContactWithTarget = function (sourcePosition, sourceLongSide, targetPosition, targetLongSide)
    -- `GetPosition()` が正確に衝突した位置を返すとは限らないので、ズレを考慮して幅を持たせる。
    return (sourcePosition - targetPosition).sqrMagnitude <= ((sourceLongSide + targetLongSide) * 0.75 ) ^ 2
end

local IsHitSource = function (name)
    if cytanb.NillableHasValue(ignoredColliderMap[name]) then
        return false
    end

    local tagMap = cytanb.ParseTagString(name)
    return not cytanb.NillableHasValue(tagMap[settings.ignoreTag]) and (
        not settings.limitHitSource or
        cytanb.NillableHasValue(tagMap[settings.throwableTag]) or
        cytanb.NillableHasValue(tagMap[settings.ballTag])
    )
end

local CreatePanelBaseStatusParameter = function ()
    return {
        tiltAngle = tiltSwitch.GetValue()
    }
end

local CreatePanelStatusParameter = function (panel)
    return {
        index = panel.index,
        name = panel.name,
        active = panel.active
    }
end

local ShowPanelMesh = function (panel, show)
    local meshItem = panel.meshItem
    if show then
        meshItem.SetLocalPosition(Vector3.zero)
        meshItem.SetLocalRotation(Quaternion.identity)
    else
        meshItem.SetPosition(hiddenPosition)
    end
end

local BreakPanel = function (panel)
    if not panel.active then
        return false
    end

    cytanb.LogTrace('break-panel: ', panel.name)

    panel.active = false
    panel.inactiveTime = vci.me.UnscaledTime

    cytanb.AlignSubItemOrigin(panel.posItem, breakEfkContainer)
    breakEfk.Play()

    local audioVolume = audioVolumeSwitch.GetValue()
    if audioVolume > 0 then
        vci.assets.audio.Play(settings.breakPanelAudioName, audioVolume / settings.audioVolumeMaxValue, false)
    end

    ShowPanelMesh(panel, false)

    local item = panel.item
    if item.IsMine then
        item.SetPosition(hiddenPosition + panel.posItem.GetLocalPosition())
        item.SetRotation(Quaternion.identity)
        item.SetVelocity(Vector3.zero)
        item.SetAngularVelocity(Vector3.zero)
    end

    return true
end

local PanelCollided = function (panel)
    if not panel.item.IsMine then
        return false
    end

    if not BreakPanel(panel) then
        return false
    end

    cytanb.LogTrace('emit break-panel: ', panel.name)
    cytanb.EmitMessage(breakPanelMessageName, {
        senderID = cytanb.ClientID(),
        target = CreatePanelStatusParameter(panel)
    })
    return true
end

local MendPanel = function (panel)
    if not panel.active then
        return
    end

    local item = panel.item
    if item.IsMine then
        cytanb.AlignSubItemOrigin(panel.posItem, item, true)
    end
end

local MendAllPanels = function ()
    local alive = false
    for name, panel in pairs(panelMap) do
        if panel.active then
            alive = true
        end
        MendPanel(panel)
    end

    local now = vci.me.UnscaledTime
    panelBaseStatus.lastMendedTime = now

    if panelBase.IsMine and not alive and panelBaseStatus.gameCompletedTime <= TimeSpan.Zero then
        cytanb.LogTrace('Game Completed!!')
        panelBaseStatus.gameCompletedTime = now
    end
end

local NormalizePanelBaseRotation = function ()
    if panelBase.IsMine then
        local baseAngles = panelBase.GetRotation().eulerAngles
        if baseAngles.x ^ 2 + baseAngles.z ^ 2 >= 1E-10 then
            -- cytanb.LogTrace('panel base rotation Y: ', baseAngles.y)
            panelBase.SetRotation(Quaternion.AngleAxis(baseAngles.y, Vector3.up))
        end
    end
end

local SetPanelBaseTilt = function (tiltAngle)
    NormalizePanelBaseRotation()
    panelTilt.SetLocalRotation(Quaternion.AngleAxis(settings.initialPanelTiltAngle + tiltAngle, Vector3.right))
    MendAllPanels()
end

local ResetAll = function ()
    cytanb.LogTrace('ResetAll')

    for name, panel in pairs(panelMap) do
        panel.active = true
        panel.inactiveTime = TimeSpan.Zero

        ShowPanelMesh(panel, true)
        MendPanel(panel)
    end

    panelBaseStatus.lastMendedTime = vci.me.UnscaledTime
    panelBaseStatus.gameCompletedTime = TimeSpan.Zero
end

local EmitResetMessage = function (broadcast, reason)
    cytanb.EmitMessage(resetMessageName, {
        resetAll = true,
        broadcast = not not broadcast,
        senderID = cytanb.ClientID(),
        itemOperator = panelBase.IsMine,
        itemLayouter = vci.assets.IsMine,
        reason = reason or ''
    })
end

local UpdateCw; UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        settings.lsp.UpdateAlive()
        panelControllerGlue.Update()

        for name, switch in pairs(slideSwitchMap) do
            switch.Update()
        end

        if deltaTime <= TimeSpan.Zero then
            return
        end

        if panelBase.IsMine then
            local now = vci.me.UnscaledTime
            if not panelBaseStatus.grabbed then
                -- 傾きの変更を、インターバルを設けてメッセージで通知する
                if panelBaseStatus.tiltChanged and now >= panelBaseStatus.tiltSentTime + settings.minRequestIntervalTime then
                    panelBaseStatus.tiltChanged = false
                    panelBaseStatus.tiltSentTime = now

                    if panelBase.IsMine then
                        cytanb.EmitMessage(changePanelBaseMessageName, {
                            senderID = cytanb.ClientID(),
                            panelBase = CreatePanelBaseStatusParameter()
                        })
                    end
                end

                -- パネルの位置関係を、インターバルを設けて直す
                if now >= panelBaseStatus.lastMendedTime + settings.panelMendIntervalTime then
                    MendAllPanels()
                end
            end

            if resetSwitchStatus.gripPressed and now - settings.resetOperationTime > resetSwitchStatus.gripStartTime then
                -- グリップ長押しでリセットする
                resetSwitchStatus.gripStartTime = TimeSpan.MaxValue
                EmitResetMessage(true, 'ButtonLongPressed')
            elseif panelBaseStatus.gameCompletedTime > TimeSpan.Zero and now >= panelBaseStatus.gameCompletedTime + settings.autoResetWaitingTime then
                -- 時間経過による自動リセット
                panelBaseStatus.gameCompletedTime = TimeSpan.Zero
                cytanb.LogTrace('AutoReset: emit resetAll')
                EmitResetMessage(false, 'AutoReset @OnUpdate')
            end
        end

        if panelBaseStatus.operatorLampOn ~= panelBase.IsMine then
            -- ランプの状態を変更する
            panelBaseStatus.operatorLampOn = not panelBaseStatus.operatorLampOn
            panelControllerOperatorLamp.SetLocalPosition(panelBaseStatus.operatorLampOn and Vector3.zero or hiddenPosition)
            panelFrameOperatorLamp.SetLocalPosition(panelBaseStatus.operatorLampOn and Vector3.zero or hiddenPosition)
        end
    end,

    function ()
        cytanb.LogTrace('OnLoad')
        settings.lsp.UpdateAlive()
        vciLoaded = true

        local uuid = cytanb.UUIDFromString(cytanb.InstanceID())
        hiddenPosition = Vector3.__new(uuid[1] / 0x100000, 0x1000, uuid[2] / 0x100000)
        -- cytanb.LogTrace('hiddenPosition: ', hiddenPosition)

        ignoredColliderMap = cytanb.Extend(
            cytanb.ListToMap(settings.avatarColliders, true),
            cytanb.ListToMap(settings.envColliders, true),
            false, false
        )

        panelBase = cytanb.NillableValue(vci.assets.GetSubItem(settings.panelBaseName))
        panelTilt = cytanb.NillableValue(vci.assets.GetTransform(settings.panelTiltName))

        panelMap = {}

        for i = 1, settings.panelCount do
            local name = settings.panelColliderPrefix .. i

            ignoredColliderMap[name] = true

            local panel = {
                index = i,
                name = name,
                item = cytanb.NillableValue(vci.assets.GetSubItem(name)),
                posItem = cytanb.NillableValue(vci.assets.GetTransform(settings.panelPosPrefix .. i)),
                meshItem = cytanb.NillableValue(vci.assets.GetTransform(settings.panelMeshPrefix .. i)),
                active = true,
                inactiveTime = TimeSpan.Zero,
            }

            panelMap[panel.name] = panel
        end

        panelController = cytanb.NillableValue(vci.assets.GetSubItem(settings.panelControllerName))
        panelControllerOperatorLamp = cytanb.NillableValue(vci.assets.GetTransform(settings.panelControllerOperatorLampName))
        panelFrameOperatorLamp = cytanb.NillableValue(vci.assets.GetTransform(settings.panelFrameOperatorLampName))
        panelControllerGlue = cytanb.CreateSubItemGlue()

        slideSwitchMap = {}

        audioVolumeSwitch = cytanb.CreateSlideSwitch({
            colliderItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.audioVolumeSwitchName)),
            knobItem = cytanb.NillableValue(vci.assets.GetTransform(settings.audioVolumeKnobName)),
            baseItem = cytanb.NillableValue(vci.assets.GetTransform(settings.audioVolumeKnobPos)),
            tickVector = settings.tickVector,
            minValue = settings.audioVolumeMinValue,
            maxValue = settings.audioVolumeMaxValue,
            lsp = settings.lsp,
            propertyName = settings.audioVolumePropertyName
        })
        audioVolumeSwitch.AddListener(function (source, value)
            cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
        end)
        slideSwitchMap[settings.audioVolumeSwitchName] = audioVolumeSwitch

        tiltSwitch = cytanb.CreateSlideSwitch({
            colliderItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.tiltSwitchName)),
            knobItem = cytanb.NillableValue(vci.assets.GetTransform(settings.tiltKnobName)),
            baseItem = cytanb.NillableValue(vci.assets.GetTransform(settings.tiltKnobPos)),
            tickVector = settings.tickVector,
            minValue = settings.tiltMinValue,
            maxValue = settings.tiltMaxValue
        })
        tiltSwitch.AddListener(function (source, value)
            cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
            SetPanelBaseTilt(value)
            panelBaseStatus.tiltChanged = true
        end)
        slideSwitchMap[settings.tiltSwitchName] = tiltSwitch

        resetSwitch = cytanb.NillableValue(vci.assets.GetSubItem(settings.resetSwitchName))
        panelControllerGlue.Add(cytanb.NillableValue(vci.assets.GetTransform(settings.resetSwitchMesh)), resetSwitch)

        breakEfkContainer = cytanb.NillableValue(vci.assets.GetTransform(settings.breakEfkContainerName))
        breakEfk = cytanb.NillableValue(vci.assets.GetEffekseerEmitter(settings.breakEfkContainerName))

        settings.lsp.AddListener(function (source, key, value, oldValue)
            if key == cytanb.LOCAL_SHARED_PROPERTY_EXPIRED_KEY then
                -- cytanb.LogTrace('lsp: expired')
                vciLoaded = false
            end
        end)

        local OnChangePanelBase = function (parameterMap)
            cytanb.LogTrace('OnChangePanelBase')
            cytanb.NillableIfHasValue(parameterMap.panelBase, function (base)
                cytanb.NillableIfHasValue(base.tiltAngle, function (tiltAngle)
                    tiltSwitch.SetValue(tiltAngle)
                end)
            end)
        end

        cytanb.OnMessage(resetMessageName, function (sender, name, parameterMap)
            -- ブロードキャストか、自己のインスタンスから送られた、リセットメッセージを処理する
            if parameterMap.resetAll and (parameterMap.broadcast or parameterMap[cytanb.InstanceIDParameterName] == cytanb.InstanceID()) then
                cytanb.LogTrace('on resetAll: ', cytanb.Vars(parameterMap))
                ResetAll()
            end
        end)

        cytanb.OnInstanceMessage(breakPanelMessageName, function (sender, name, parameterMap)
            cytanb.NillableIfHasValue(parameterMap.target, function (panelParameters)
                cytanb.NillableIfHasValue(panelMap[panelParameters.name], function (panel)
                    BreakPanel(panel)
                end)
            end)
        end)

        cytanb.OnInstanceMessage(changePanelBaseMessageName, function (sender, name, parameterMap)
            if parameterMap.senderID ~= cytanb.ClientID() then
                OnChangePanelBase(parameterMap)
            end
        end)

        -- マスターが交代したときのことを考慮して、全ユーザーが OnMessage で登録する。
        cytanb.OnInstanceMessage(queryStatusMessageName, function (sender, name, parameterMap)
            if not vci.assets.IsMine then
                -- マスターでなければリターンする。
                return
            end

            local panelStatusList = {}
            for key, panel in pairs(panelMap) do
                panelStatusList[panel.index] = CreatePanelStatusParameter(panel)
            end

            cytanb.EmitMessage(statusMessageName, {
                senderID = cytanb.ClientID(),
                panelBase = CreatePanelBaseStatusParameter(),
                panels = panelStatusList
            })
        end)

        cytanb.OnInstanceMessage(statusMessageName, function (sender, name, parameterMap)
            if parameterMap.senderID ~= cytanb.ClientID() then
                cytanb.LogTrace('on statusMessage')
                OnChangePanelBase(parameterMap)

                for key, panelParameters in pairs(parameterMap.panels) do
                    cytanb.NillableIfHasValue(panelMap[panelParameters.name], function (panel)
                        -- cytanb.LogTrace('panelParameters.active: ', panelParameters.active, ', panel.active = ', panel.active)
                        if panelParameters.active ~= panel.active then
                            -- 通知された状態と異なれば、変更を行う
                            panel.active = panelParameters.active
                            ShowPanelMesh(panel, panel.active)
                        end
                    end)
                end
            end
        end)

        -- ターゲットにヒットしたメッセージが、別 VCI から送られてくる。
        cytanb.OnMessage(hitMessageName, function (sender, name, parameterMap)
            cytanb.NillableIfHasValue(parameterMap.source, function (source)
                if not source.position then
                    return
                end

                cytanb.NillableIfHasValue(parameterMap.target, function (targetParameters)
                    cytanb.NillableIfHasValue(panelMap[targetParameters.name], function (panel)
                        if not panel.item.IsMine then
                            return
                        end

                        if IsContactWithTarget(source.position, source.longSide or 0.5, panel.item.GetPosition(), settings.panelSimLongSide) then
                            if PanelCollided(panel) then
                                cytanb.LogTrace('    @on hit message: source = ', source.name or '[unknown]')
                            end
                        end
                    end)
                end)
            end)
        end)

        ResetAll()
        SetPanelBaseTilt(tiltSwitch.GetValue())

        -- 現在のステータスを問い合わせる。
        -- 設置者よりも、ゲストのロードが早いケースを考慮して、全ユーザーがクエリーメッセージを送る。
        cytanb.EmitMessage(queryStatusMessageName)
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

    if target == panelBase.GetName() then
        panelBaseStatus.grabbed = true
    elseif target == resetSwitch.GetName() then
        resetSwitchStatus.clickCount, resetSwitchStatus.clickTime = cytanb.DetectClicks(resetSwitchStatus.clickCount, resetSwitchStatus.clickTime, settings.grabClickTiming)
        if resetSwitchStatus.clickCount == 2 then
            -- リセットスイッチを 2 回グラブする操作で、リセットを行う。
            -- (ユーザーは、スライドスイッチをグラブすると操作できるので、同じ入力キーで操作できるものと期待するため)
            EmitResetMessage(false, 'GrabButtonTwoTimes')
        end
    else
        cytanb.NillableIfHasValue(slideSwitchMap[target], function (switch)
            switch.DoGrab()
        end)
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    if target == panelBase.GetName() then
        panelBaseStatus.grabbed = false
        NormalizePanelBaseRotation()
        MendAllPanels()
    else
        cytanb.NillableIfHasValue(slideSwitchMap[target], function (switch)
            switch.DoUngrab()
        end)
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == resetSwitch.GetName() then
        resetSwitchStatus.gripPressed = true
        resetSwitchStatus.gripStartTime = vci.me.UnscaledTime
    elseif use == panelBase.GetName() then
        EmitResetMessage(false, 'UsePanelFrame')
    else
        cytanb.NillableIfHasValue(slideSwitchMap[use], function (switch)
            switch.DoUse()
        end)
    end
end

onUnuse = function (use)
    if not vciLoaded then
        return
    end

    if use == resetSwitch.GetName() then
        if resetSwitchStatus.gripPressed and resetSwitchStatus.gripStartTime ~= TimeSpan.MaxValue then
            -- 長押しされなかった場合は、自己のインスタンスのみリセットする
            EmitResetMessage(false, 'UseButton @onUnuse')
        end
        resetSwitchStatus.gripPressed = false
        resetSwitchStatus.gripStartTime = TimeSpan.MaxValue
    else
        cytanb.NillableIfHasValue(slideSwitchMap[use], function (switch)
            switch.DoUnuse()
        end)
    end
end

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    if panelBase.IsMine and not panelBaseStatus.grabbed and IsHitSource(hit) then
        cytanb.NillableIfHasValue(panelMap[item], function (panel)
            panelBaseStatus.lastMendedTime = vci.me.UnscaledTime
            if PanelCollided(panel) then
                cytanb.LogTrace('    @onTriggerEnter: panel = ', item, ', hit = ', hit)
            end
        end)
    end
end
