----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

local CreateLocalSharedProperties = function (lspid, loadid, studioTimeGetter)
    local maxAliveTime = TimeSpan.FromSeconds(5)
    local clientLspid = '84cda5f8-ebd7-442c-9269-5160dac50b9e'
    local aliveLspid = '58d17509-83b7-486b-be8f-aa74b7d6cc75'
    local listenerMapKey = '__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'
    local propertyChangeEventName = 'property_change'
    local expiredEventName = 'expired'

    if type(lspid) ~= 'string' or type(loadid) ~= 'string' then
        error('Invalid argument')
    end

    local clientID = _G[clientLspid]
    if not clientID then
        clientID = loadid
        _G[clientLspid] = clientID
    end

    local aliveMap = _G[aliveLspid]
    if not aliveMap then
        aliveMap = {}
        _G[aliveLspid] = aliveMap
    end
    aliveMap[loadid] = studioTimeGetter()

    local pmap = _G[lspid]
    if not pmap then
        pmap = {[listenerMapKey] = {}}
        _G[lspid] = pmap
    end
    local listenerMap = pmap[listenerMapKey]

    return {
        propertyChangeEventName = propertyChangeEventName,

        expiredEventName = expiredEventName,

        GetLspID = function ()
            return lspid
        end,

        GetLoadID = function ()
            return loadid
        end,

        GetClientID = function ()
            return clientID
        end,

        GetProperty = function (key, defaultValue)
            local value = pmap[key]
            if value == nil then
                return defaultValue
            else
                return value
            end
        end,

        SetProperty = function (key, value)
            if key == listenerMapKey then
                error('Invalid argument: key = ', key)
            end

            local now = studioTimeGetter()
            local oldValue = pmap[key]
            pmap[key] = value

            for listener, id in pairs(listenerMap) do
                local t = aliveMap[id]
                if t and t + maxAliveTime >= now then
                    listener(propertyChangeEventName, key, value, oldValue)
                else
                    -- 期限切れしたリスナーを解除する
                    listener(expiredEventName, key, value, oldValue)
                    listenerMap[listener] = nil
                    aliveMap[id] = nil
                end
            end
        end,

        AddListener = function (listener)
            listenerMap[listener] = loadid
        end,

        RemoveListener = function (listener)
            listenerMap[listener] = nil
        end,

        UpdateAlive = function ()
            aliveMap[loadid] = studioTimeGetter()
        end
    }
end

return {
    Load = function (mainEnv, loadid)
        local cballSettingsLspid = 'e63ae798-cdd4-42c0-a2a0-33655c9514a4'
        local ballTag = '#cytanb-ball'
        local targetTag = '#cytanb-target'
        local ballVelocityAdjustmentPropertyName = 'ballVelocityAdjustment'
        local ballAngularVelocityAdjustmentPropertyName = 'ballAngularVelocityAdjustment'
        local ballAltitudeAdjustmentPropertyName = 'ballAltitudeAdjustment'
        local efkLevelPropertyName = 'efkLevel'
        local audioVolumePropertyName = 'audioVolume'

        return {
            --- 速度の調整値の初期設定値。カスタマイズする場合は、この値を変更する。([-5, 5] の範囲)
            [ballVelocityAdjustmentPropertyName] = 0,

            --- 角速度の調整値の初期設定値。カスタマイズする場合は、この値を変更する。([-5, 5] の範囲)
            [ballAngularVelocityAdjustmentPropertyName] = 0,

            --- 仰俯角の調整値の初期設定値。カスタマイズする場合は、この値を変更する。([-5, 5] の範囲)
            [ballAltitudeAdjustmentPropertyName] = 0,

            --- エフェクトレベルの初期設定値。カスタマイズする場合は、この値を変更する。([-5, 5] の範囲)
            [efkLevelPropertyName] = 0,

            --- 音量の初期設定値。カスタマイズする場合は、この値を変更する。([-5, 5] の範囲)
            [audioVolumePropertyName] = -5,

            --- 投球動作として、リリースポイントからさかのぼって速度計算に反映する時間。([100, 250] ms 程度の範囲)
            ballKinematicTime = TimeSpan.FromMilliseconds(135),

            --- 投球動作とみなす速度の閾値。
            ballKinematicVelocityThreshold = 1.0,

            --- 投球動作による速度係数の最小値。
            ballKinematicMinVelocityFactor = 0.0625,

            --- 投球動作による速度係数の最大値。
            ballKinematicMaxVelocityFactor = 0.875,

            --- 投球動作による角速度係数の最小値。
            ballKinematicMinAngularVelocityFactor = 0.0625,

            --- 投球動作による角速度係数の最大値。
            ballKinematicMaxAngularVelocityFactor = 7.5,

            --- 投球動作による仰俯角係数の最小値。
            ballKinematicMinAltitudeFactor = -25,

            --- 投球動作による仰俯角係数の最大値。
            ballKinematicMaxAltitudeFactor = 25,

            --- 入力タイミングによる速度のスケールの最小値。
            ballInpactMinVelocityScale = 2.0,

            --- 入力タイミングによる速度のスケールの最大値。
            ballInpactMaxVelocityScale = 22.0,

            --- 入力タイミングによる角速度のスケールの最小値。
            ballInpactMinAngularVelocityScale = 2.0,

            --- 入力タイミングによる角速度のスケールの最大値。
            ballInpactMaxAngularVelocityScale = 22.0,

            --- 入力タイミングによる仰俯角のスケールの最小値。
            ballInpactMinAltitudeScale = -75.0,

            --- 入力タイミングによる仰俯角のスケールの最大値。
            ballInpactMaxAltitudeScale = 75.0,

            --- ボールの長辺のシミュレーション値。
            ballSimLongSide = 0.217,

            --- ボールの質量のシミュレーション値。
            ballSimMass = 35.0,

            --- ボールの回転抵抗のシミュレーション値。
            ballSimAngularDrag = 0.1,

            --- ボールの回転のシミレーション係数。
            ballSimAngularFactor = 0.0012,

            --- 体のコライダーとの接触を避けるための、オフセット係数。
            ballForwardOffsetFactor = 0.1,

            --- 体のコライダーとの接触を避けるための、オフセットの最大値。
            ballMaxForwardOffset = 0.5,

            --- ボールのリスポーン位置のオフセット。
            ballRespawnOffsetY = 0.75,

            --- ボールがアクティブであることを判定する閾値。
            ballActiveThreshold = 0.75 + 0.25,

            --- ボールがリスポーンするまでの待ち時間。
            ballWaitingTime = TimeSpan.FromSeconds(90),

            --- ボールのプレイエリアの半径。これを超えるとリスポーンする。
            ballPlayAreaRadius = 100,

            --- ボールが近距離にあると判定する距離。
            ballNearDistance = 5,

            --- ボールが遠距離にあると判定する距離。
            ballFarDistance = 20,

            --- ボールの軌跡を表示する速度の閾値。
            ballTrailVelocityThreshold = 1.4,

            --- ボールの軌跡を補間する距離の係数。
            ballTrailInterpolationDistanceFactor = 0.5,

            --- ボールの軌跡の毎フレームの補間ノード数の基準値。
            ballTrailInterpolationNodesPerFrame = 5,

            --- ゲージの毎秒の変化率。
            impactGaugeRatioPerSec = 1,

            --- ゲージの UV の最大値。
            impactGaugeMaxUV = 0.135,

            --- ゲージの表示時間。
            impactGaugeDisplayTime = TimeSpan.FromSeconds(2),

            --- ライトの長辺のシミュレーション値。
            standLightSimLongSide = 0.56,

            --- ライトの質量のシミュレーション値。
            standLightSimMass = 1.0,

            --- ライトの水平姿勢判定の閾値。
            standLightHorizontalAttitudeThreshold = 5.0,

            --- ライトの最小ヒットマグニチュード。
            standLightMinHitMagnitude = 0.5,

            --- ライトの最大ヒットマグニチュード。
            standLightMaxHitMagnitude = 1.5,

            --- ライトのY方向の最小ヒットマグニチュード。
            standLightMinHitMagnitudeY = 0.5,

            --- ライトのY方向の最大ヒットマグニチュード。
            standLightMaxHitMagnitudeY = 0.75,

            --- ライトにヒットしたときの力の係数。
            standLightHitForceFactor = 2.0,

            --- ライトがリスポーンするまでの待ち時間。
            standLightWaitingTime = TimeSpan.FromSeconds(60),

            --- ライトにメッセージを送るインターバル時間。
            standLightRequestIntervalTime = TimeSpan.FromSeconds(3),

            --- 設定パネルを表示するオフセット位置。
            settingsPanelOffset = Vector3.__new(-0.8, 0.25, 0),

            --- 設定パネルの距離の閾値。
            settingsPanelDistanceThreshold = 3.0,

            --- 設定パネルの調節スイッチのY座標。
            settingsPanelAdjustmentSwitchNeutralPositionY = -0.1,

            --- 設定パネルの調節スイッチの目盛り。
            settingsPanelAdjustmentSwitchDivisionScale = 0.01,

            --- 設定パネルのグラブによるクリックタイミング。
            settingsPanelGrabClickTiming = TimeSpan.FromMilliseconds(2000),

            --- ボールのタグ名。
            ballTag = ballTag,

            --- ボールのオブジェクト名。
            ballName = 'cball' .. ballTag,

            --- ボールのエフェクトのコンテナー名。
            ballEfkContainerName = 'ball-efk',

            --- ボールのエフェクト名。
            ballEfkName = 'cball-trail',

            --- ボールのエフェクト名(フェード有り)。
            ballEfkFadeName = 'cball-trail-fade',

            --- ボールのエフェクト名(フェード+ムーブ有り)。
            ballEfkFadeMoveName = 'cball-trail-fade-move',

            --- ボールのエフェクト名(生成数1)。
            ballEfkOneName = 'cball-trail-one',

            --- ボールのエフェクト名(生成数1,大)。
            ballEfkOneLargeName = 'cball-trail-one-large',

            --- ボールのカップのオブジェクト名。
            ballCupName = 'ball-cup',

            --- ターゲットのタグ名。
            targetTag = targetTag,

            --- ライトのオブジェクト名の接頭辞。
            standLightPrefix = 'oO-standlight' .. targetTag .. '#',

            --- ライトのオブジェクト数。
            standLightCount = 3,

            --- ライトのエフェクトのコンテナー名。
            standLightEfkContainerName = 'standlight-efk',

            --- ライトのエフェクト名。(ヒット)
            standLightHitEfkName = 'standlight-hit',

            --- ライトのエフェクト名。(ダイレクトヒット)
            standLightDirectHitEfkName = 'standlight-direct-hit',

            --- ライトのヒット音のクリップ名の接頭辞。
            standLightHitAudioPrefix = 'standlight-hit-',

            --- ライトのダイレクトヒット音のクリップ名。
            standLightDirectHitAudioName = 'standlight-direct-hit',

            --- 威力のゲージのマテリアル名。
            impactForceGaugeMat = 'impact-force-gauge-mat',

            --- 威力のゲージのオブジェクト名。
            impactForceGaugeName = 'impact-force-gauge',

            --- スピンゲージのオブジェクト名。
            impactSpinGaugeName = 'impact-spin-gauge',

            --- 設定パネルのオブジェクト名。
            settingsPanelName = 'cball-settings-panel',

            --- 設定パネルの閉じるスイッチのオブジェクト名。
            closeSwitchName = 'cball-settings-close-switch',

            --- 設定パネルの調節スイッチのオブジェクト名。
            adjustmentSwitchNames = {
                {switchName = 'cball-settings-velocity-switch', knobName = 'cball-settings-velocity-knob', propertyName = ballVelocityAdjustmentPropertyName},
                {switchName = 'cball-settings-angular-velocity-switch', knobName = 'cball-settings-angular-velocity-knob', propertyName = ballAngularVelocityAdjustmentPropertyName},
                {switchName = 'cball-settings-altitude-switch', knobName = 'cball-settings-altitude-knob', propertyName = ballAltitudeAdjustmentPropertyName},
                {switchName = 'cball-settings-efk-switch', knobName = 'cball-settings-efk-knob', propertyName = efkLevelPropertyName},
                {switchName = 'cball-settings-volume-switch', knobName = 'cball-settings-volume-knob', propertyName = audioVolumePropertyName}
            },

            --- 速度の調整値のプロパティ名。
            ballVelocityAdjustmentPropertyName = ballVelocityAdjustmentPropertyName,

            --- 角速度の調整値のプロパティ名。
            ballAngularVelocityAdjustmentPropertyName = ballAngularVelocityAdjustmentPropertyName,

            --- 仰俯角の調整値のプロパティ名。
            ballAltitudeAdjustmentPropertyName = ballAltitudeAdjustmentPropertyName,

            --- エフェクトレベルのプロパティ名。
            efkLevelPropertyName = efkLevelPropertyName,

            --- 音量のプロパティ名。
            audioVolumePropertyName = audioVolumePropertyName,

            --- スコアのヒット数のプロパティ名。
            scoreHitCountPropertyName = 'scoreHitCount',

            --- スコアのダイレクトヒット数のプロパティ名。
            scoreDirectHitCountPropertyName = 'scoreDirectHitCount',

            --- アバターのコライダー名リスト。
            avatarColliders = {'Head', 'Chest', 'Hips', 'RightArm', 'LeftArm', 'RightHand', 'LeftHand', 'RightThigh', 'LeftThigh', 'RightFoot', 'LeftFoot', 'RightToes', 'LeftToes'},

            --- ローカルの共有プロパティ。
            localSharedProperties = CreateLocalSharedProperties(cballSettingsLspid, loadid, function () return mainEnv.vci.me.Time end),

            --- スローイングのエフェクトを有効にするか。
            enableThrowingEfk = false,

            --- デバッギングを有効にするか。
            enableDebugging = false
        }
    end
}
