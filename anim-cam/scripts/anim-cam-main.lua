-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

--- カメラのアニメーションやオブジェクトの設定。構成に合わせてカスタマイズする。
local conf = {
    --- カメラのアニメーションの再生方法の指示。
    ---   type: 指示のタイプを指定する。('play': アニメーションを再生する。)
    ---   name: アニメーションクリップの名前を指定する。
    ---   length: アニメーションクリップの長さを TimeSpan で指定する。省略した場合は再生を終了しない。
    ---   loop: アニメーションをループ再生するかを指定する。省略した場合はループ再生しない。(true | false)
    ---   stopOnEnd: このアニメーションクリップの再生を終えたら、停止するかを指定する。省略した場合は次のクリップを再生する。(true | false)
    ---
    --- 連続してアニメーションクリップを再生する例:
    --- ```
    --- directives = {
    ---     {type = 'play', name = 'anim-cam-clip-0', length = TimeSpan.FromSeconds(61)},
    ---     {type = 'play', name = 'anim-cam-clip-1', length = TimeSpan.FromSeconds(141)}
    --- },
    --- ```
    directives = {
        {type = 'play', name = 'anim-cam-clip-0', loop = true}
    },

    --- 全体をループ再生するかを指定する。(true | false)
    loopAll = false,

    --- ロード時に自動的に再生を開始するかを指定する。(true | false)
    --- true を指定すると、アイテムを設置・削除で、アニメーションの再生・停止を切り替えるような使い方が出来る。
    playOnLoad = false,

    --- カメラをつかんだ時に、再生を停止するかを指定する。(true | false)
    stopOnCameraGrabbed = true,

    --- 操作するカメラの名前。('HandiCamera' | 'AutoFollowCamera' | 'SwitchingCamera' | 'WindowCamera')
    systemCamName = 'HandiCamera',

    --- カメラのコンテナーオブジェクトの初期位置をワールド座標の原点へ移動するかを指定する。(true | false)
    --- アイテムを設置した位置を初期位置とする場合は、false を指定する。
    camContainerToWorldOrigin = true,

    --- カメラのコンテナーのオブジェクト名。
    camContainerName = 'anim-cam-container',

    --- カメラのマーカーのオブジェクト名。
    camMarkerName = 'anim-cam-marker',

    --- 再生/停止スイッチのオブジェクト名。
    camSwitchName = 'anim-cam-switch',

    --- 次へ進むスイッチのオブジェクト名。
    camNextSwitchName = 'anim-cam-next-switch',

    --- 前へ戻るスイッチのオブジェクト名。
    camPrevSwitchName = 'anim-cam-prev-switch',

    --- スイッチのトラックのディスプレイのテキストオブジェクト名。
    camSwitchDisplayTrack = 'anim-cam-switch-display-track',

    --- スイッチのトラックのディスプレイの桁数。
    camSwitchDisplayTrackPlaceDigits = 2,

    --- カメラのスイッチのテクスチャーのオフセット座標。
    camSwitchTextureOffset = Vector2.__new(0, 356 / 1024),

    --- デバッグ機能を有効にするかを指定する。(true | false)
    enableDebugging = false
}

local animCamNS = 'com.github.oocytanb.oO-vci-pack.anim-cam'
local commandMessageName = animCamNS .. '.cam-switch-command'
local directiveStateMessageName = animCamNS .. '.directive-state'
local queryDirectiveStateMessageName = animCamNS .. '.query-directive-state'

---@class CommandMessageParameter
---@field togglePlay string
---@field nextTrack string
---@field prevTrack string
local CommandMessageParameter = cytanb.SetConstEach({}, {
    togglePlay = 'togglePlay',
    nextTrack = 'nextTrack',
    prevTrack = 'prevTrack'
})

---@class StudioSystemCameraAccessor
---@field get ExportSystemCamera
---@field has boolean

---@class StudioSystemCameraCollection
---@field HandiCamera StudioSystemCameraAccessor
---@field AutoFollowCamera StudioSystemCameraAccessor
---@field SwitchingCamera StudioSystemCameraAccessor
---@field WindowCamera StudioSystemCameraAccessor
local StudioSystemCameraCollection = cytanb.SetConstEach({}, {
    HandiCamera = {get = vci.studio.GetHandiCamera, has = vci.studio.HasHandiCamera},
    AutoFollowCamera = {get = vci.studio.GetAutoFollowCamera, has = vci.studio.HasAutoFollowCamera},
    SwitchingCamera = {get = vci.studio.GetSwitchingCamera, has = vci.studio.HasSwitchingCamera},
    WindowCamera = {get = vci.studio.GetWindowCamera, has = vci.studio.HasWindowCamera}
})

---@class DirectiveProcessorState DirectiveProcessor の状態。
---@field stop number @停止している。
---@field processing number @処理中である。
local DirectiveProcessorState = cytanb.SetConstEach({}, {
    stop = 0,
    processing = 1
})

---@class DirectiveType Directive のタイプ。
---@field play string @アニメーションクリップを再生する。
local DirectiveType = cytanb.SetConstEach({}, {
    play = 'play',
})

---@class DirectiveProcessor ディレクティブのプロセッサー。
---@field SetStopOnCameraGrabbed fun (enabled: boolean) @カメラをつかんだ時に、再生を停止するかを指定する。
---@field IsStopOnCameraGrabbed fun (): boolean @カメラをつかんだ時に、再生を停止するかを調べる。規定値は `true`。
---@field SetLoopAll fun (enabled: boolean) @全体をループ再生するかを指定する。
---@field IsLoopAll fun (): boolean @全体をループ再生するかを調べる。規定値は `false`。
---@field Start fun (): boolean @ディレクティブの最初のエントリーから開始する。また、その成否を返す。
---@field Stop fun (): boolean @処理を停止する。また、その成否を返す。
---@field Update fun () @処理を更新する。
---@field GetState fun (): DirectiveProcessorState @現在の状態を取得する。
---@field GetTrackSize fun (): number @トラックのサイズを取得する。
---@field GetTrackIndex fun (): number @現在のトラックのインデックスを取得する。
---@field SetTrackIndex fun (index: number) @現在のトラックのインデックスを設定する。
---@field NextTrack fun () @次のトラックへ移動する。
---@field PrevTrack fun () @前のトラックへ移動する。

---@return DirectiveProcessor
local CreateDirectiveProcessor = function (directives, animator, camMarker, systemCamName)
    local ParseDirectives = function (directiveList)
        local list = {}
        local trackSize = 0
        for i, dir in ipairs(directiveList) do
            if dir.type == DirectiveType.play then
                -- 現在は 'play' のみ対応。
                if not dir.name then
                    cytanb.LogError('INVALID DIRECTIVE PARAMETER: animation clip name is not specified')
                else
                    table.insert(list, cytanb.Extend({}, dir))
                    trackSize = trackSize + 1
                end
            else
                cytanb.LogWarn('UNKNOWN DIRECTIVE TYPE: ', dir.type)
            end
        end
        return list, trackSize
    end

    local systemCamAccessor = StudioSystemCameraCollection[systemCamName]
    if not systemCamAccessor then
        systemCamName = 'HandiCamera'
        systemCamAccessor = StudioSystemCameraCollection.HandiCamera
    end

    local stopOnCameraGrabbed = true
    local loopAll = false

    local directiveList, trackSize = ParseDirectives(directives)
    local systemCam = nil
    local trackIndex = 1
    local entryExpectedTime = TimeSpan.MaxValue
    local state = DirectiveProcessorState.stop

    local ProcessEntry = function (index)
        local dir = directiveList[index]
        if not dir then
            return DirectiveProcessorState.stop, TimeSpan.MaxValue
        end

        if dir.type == DirectiveType.play then
            animator._ALL_PlayFromName(dir.name, not not dir.loop)
            local expectedTime = dir.length and vci.me.time + dir.length or TimeSpan.MaxValue
            return DirectiveProcessorState.processing, expectedTime
        else
            cytanb.LogError('UNSUPPORTED DIRECTIVE: type = ', dir.type)
            return DirectiveProcessorState.stop, TimeSpan.MaxValue
        end
    end

    local self
    self = {
        SetStopOnCameraGrabbed = function (enabled)
            stopOnCameraGrabbed = not not enabled
        end,

        IsStopOnCameraGrabbed = function ()
            return stopOnCameraGrabbed
        end,

        SetLoopAll = function (enabled)
            loopAll = not not enabled
        end,

        IsLoopAll = function ()
            return loopAll
        end,

        Start = function ()
            if not vci.assets.IsMine then
                cytanb.LogError('UNSUPPORTED OPERATION: not vci.assets.IsMine')
                return false
            end

            self.Stop()

            systemCam = systemCamAccessor.get()
            if not systemCam then
                cytanb.LogWarn('SYSTEM_CAMERA_NOT_FOUND: ', systemCamName)
                return false
            end

            if trackIndex <= 0 then
                trackIndex = 1
            end

            state, entryExpectedTime = ProcessEntry(trackIndex)
            if state == DirectiveProcessorState.stop then
                trackIndex = 1
            end
            return true
        end,

        Stop = function ()
            if not vci.assets.IsMine then
                cytanb.LogError('UNSUPPORTED OPERATION: not vci.assets.IsMine')
                return false
            end

            animator._ALL_Stop()
            state = DirectiveProcessorState.stop

            return true
        end,

        Update = function ()
            if not vci.assets.IsMine then
                return
            end

            if state ~= DirectiveProcessorState.processing then
                return
            end

            if not systemCamAccessor.has() then
                -- カメラが削除されたため、停止する。
                cytanb.LogWarn('SYSTEM_CAMERA_LOST: ', systemCamName)
                self.Stop()
                return
            end

            if vci.me.Time >= entryExpectedTime then
                -- エントリーの終了予定時間に到達したので、次のエントリーを処理する
                animator._ALL_Stop()
                local nillableDir = directiveList[trackIndex]
                if cytanb.NillableHasValue(nillableDir) and cytanb.NillableValue(nillableDir).stopOnEnd then
                    -- 停止指示がある場合は、このエントリーで停止する
                    self.Stop()
                else
                    -- 停止指示がなければ、次のエントリーを再生する
                    -- インデックスが最終トラックで loopAll が指定されている場合は、先頭に戻す。
                    trackIndex = (trackIndex >= trackSize and loopAll) and 1 or trackIndex + 1
                    state, entryExpectedTime = ProcessEntry(trackIndex)
                    if state == DirectiveProcessorState.stop then
                        self.Stop()
                        trackIndex = 1
                    end
                end
            else
                if systemCam.IsGrabbed() then
                    if stopOnCameraGrabbed then
                        -- カメラがつかまれていれば、停止する
                        self.Stop()
                    end
                else
                    -- カメラがつかまれていなければ、マーカーの位置と回転をカメラに適用する
                    systemCam.SetPosition(camMarker.GetPosition())
                    systemCam.SetRotation(camMarker.GetRotation())
                end
            end
        end,

        GetState = function ()
            return state
        end,

        GetTrackSize = function ()
            return trackSize
        end,

        GetTrackIndex = function ()
            return trackIndex
        end,

        SetTrackIndex = function (index)
            local stateIsProcessing = state == DirectiveProcessorState.processing
            if stateIsProcessing then
                self.Stop()
            end

            trackIndex = math.max(1, math.min(math.floor(index), trackSize))

            if stateIsProcessing then
                self.Start()
            end

            return trackIndex
        end,

        NextTrack = function ()
            self.SetTrackIndex(trackIndex < trackSize and trackIndex + 1 or 1)
            return trackIndex
        end,

        PrevTrack = function ()
            self.SetTrackIndex(trackIndex > 1 and trackIndex - 1 or trackSize)
            return trackIndex
        end
    }
    return self
end

--- VCI がロードされたか。
local vciLoaded = false

local camContainer = cytanb.NillableValue(vci.assets.GetSubItem(conf.camContainerName))
local nillableCamSwitch = conf.camSwitchName and vci.assets.GetSubItem(conf.camSwitchName) or nil
local nillableCamNextSwitch = conf.camNextSwitchName and vci.assets.GetSubItem(conf.camNextSwitchName) or nil
local nillableCamPrevSwitch = conf.camPrevSwitchName and vci.assets.GetSubItem(conf.camPrevSwitchName) or nil
local camSwitchMap, camNextSwitchMap, camPrevSwitchMap

---@type DirectiveProcessor
local directiveProcessor = CreateDirectiveProcessor(conf.directives, camContainer.GetAnimation(), vci.assets.GetSubItem(conf.camMarkerName), conf.systemCamName)
directiveProcessor.SetLoopAll(conf.loopAll)
directiveProcessor.SetStopOnCameraGrabbed(conf.stopOnCameraGrabbed)

local lastDirectiveState = DirectiveProcessorState.stop
local lastDirectiveTrackIndex = -1

local multiTrackSwitchEnabled = cytanb.NillableHasValue(nillableCamSwitch) and cytanb.NillableHasValue(nillableCamNextSwitch) and cytanb.NillableHasValue(nillableCamPrevSwitch) and directiveProcessor.GetTrackSize() >= 2

-- サブアイテムを動かした状態で、ゲストが凸したときのことを考慮して、チャンクが評価された時点の位置で、コネクターを作成する。
local camSwitchConnector = cytanb.CreateSubItemConnector()
if multiTrackSwitchEnabled then
    local switch = cytanb.NillableValue(nillableCamSwitch)
    local nextSwitch = cytanb.NillableValue(nillableCamNextSwitch)
    local prevSwitch = cytanb.NillableValue(nillableCamPrevSwitch)
    camSwitchMap = {[switch.GetName()] = switch}
    camNextSwitchMap = {[nextSwitch.GetName()] = nextSwitch}
    camPrevSwitchMap = {[prevSwitch.GetName()] = prevSwitch}
    camSwitchConnector.Add({switch, nextSwitch, prevSwitch})
else
    -- マルチトラックが無効のときは、Next/Prev を camSwitch として利用する。
    local switchList = {}
    if cytanb.NillableHasValue(nillableCamSwitch) then
        local switch = cytanb.NillableValue(nillableCamSwitch)
        camSwitchMap = {[switch.GetName()] = switch}
        table.insert(switchList, switch)
    else
        camSwitchMap = {}
    end

    if cytanb.NillableHasValue(nillableCamNextSwitch) then
        local nextSwitch = cytanb.NillableValue(nillableCamNextSwitch)
        camSwitchMap[nextSwitch.GetName()] = nextSwitch
        table.insert(switchList, nextSwitch)
    end

    if cytanb.NillableHasValue(nillableCamPrevSwitch) then
        local prevSwitch = cytanb.NillableValue(nillableCamPrevSwitch)
        camSwitchMap[prevSwitch.GetName()] = prevSwitch
        table.insert(switchList, prevSwitch)
    end

    camNextSwitchMap = {}
    camPrevSwitchMap = {}

    if #switchList >= 2 then
        camSwitchConnector.Add(switchList)
    else
        -- 1つ以下の場合は、コネクターを無効にする
        camSwitchConnector.SetEnabled(false)
    end
end

if conf.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelTrace)
end

local SetDisplayTrackIndex = function (index)
    if not cytanb.NillableHasValue(nillableCamSwitch) then
        return
    end

    local num = (index >= 1 and index <= directiveProcessor.GetTrackSize()) and index or 0
    local text = ''
    for i = 1, conf.camSwitchDisplayTrackPlaceDigits do
        text = tostring(num % 10) .. text
        num = math.floor(num / 10)
    end
    vci.assets.SetText(conf.camSwitchDisplayTrack, text)
end

local EmitDirectiveStateMessage = function ()
    local state = directiveProcessor.GetState()
    local trackIndex = directiveProcessor.GetTrackIndex()
    cytanb.LogTrace('Emit directiveStateMessage: state = ', state, ', trackIndex = ', trackIndex)
    cytanb.EmitMessage(directiveStateMessageName, {state = state, trackIndex = trackIndex})
end

local UpdateCw; UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        if deltaTime <= TimeSpan.Zero then
            return
        end

        camSwitchConnector.Update()

        if vci.assets.IsMine then
            directiveProcessor.Update()
            local state = directiveProcessor.GetState()
            local trackIndex = directiveProcessor.GetTrackIndex()
            if state ~= lastDirectiveState or trackIndex ~= lastDirectiveTrackIndex then
                lastDirectiveState = state
                lastDirectiveTrackIndex = trackIndex
                EmitDirectiveStateMessage()
            end
        end
    end,

    function ()
        cytanb.LogTrace('OnLoad')
        vciLoaded = true

        if vci.assets.IsMine and conf.camContainerToWorldOrigin then
            camContainer.SetPosition(Vector3.zero)
            camContainer.SetRotation(Quaternion.identity)
        end

        if cytanb.NillableHasValue(nillableCamSwitch) then
            vci.assets.SetMaterialTextureOffsetFromName(conf.camSwitchName, multiTrackSwitchEnabled and conf.camSwitchTextureOffset or Vector2.zero)
            SetDisplayTrackIndex(directiveProcessor.GetTrackIndex())
        end

        cytanb.OnInstanceMessage(commandMessageName, function (sender, name, parameterMap)
            if not vci.assets.IsMine then
                return
            end

            local command = parameterMap.command
            cytanb.LogTrace('onCommandMessage: ', command)
            if command == CommandMessageParameter.togglePlay then
                if directiveProcessor.GetState() == DirectiveProcessorState.processing then
                    directiveProcessor.Stop()
                else
                    directiveProcessor.Start()
                end
            elseif command == CommandMessageParameter.nextTrack then
                directiveProcessor.NextTrack()
            elseif command == CommandMessageParameter.prevTrack then
                directiveProcessor.PrevTrack()
            end
        end)

        cytanb.OnInstanceMessage(directiveStateMessageName, function (sender, name, parameterMap)
            local state = parameterMap.state
            local trackIndex = parameterMap.trackIndex
            cytanb.LogInfo('onDirectiveStateMessage: state = ', state, ', trackIndex = ', trackIndex)
            SetDisplayTrackIndex(trackIndex)
        end)

        cytanb.OnInstanceMessage(queryDirectiveStateMessageName, function (sender, name, parameterMap)
            if vci.assets.IsMine then
                cytanb.LogTrace('onQueryDirectiveStateMessage')
                EmitDirectiveStateMessage()
            end
        end)

        if conf.playOnLoad then
            directiveProcessor.Start()
        end

        if not vci.assets.IsMine then
            cytanb.EmitMessage(queryDirectiveStateMessageName)
        end
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

    cytanb.LogTrace('onUse: ', use)

    if camSwitchMap[use] then
        cytanb.LogTrace('Emit toggle play command')
        cytanb.EmitMessage(commandMessageName, {command = CommandMessageParameter.togglePlay})
    elseif camNextSwitchMap[use] then
        cytanb.LogTrace('Emit next track command')
        cytanb.EmitMessage(commandMessageName, {command = CommandMessageParameter.nextTrack})
    elseif camPrevSwitchMap[use] then
        cytanb.LogTrace('Emit prev track command')
        cytanb.EmitMessage(commandMessageName, {command = CommandMessageParameter.prevTrack})
    end
end
