-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

return {
    Load = function (mainEnv, cytanb)
        local loadid = tostring(cytanb.RandomUUID())
        local cballSettingsLspid = 'ae00bdfc-98ec-4fbf-84a6-1a52823cfe69'
        local statsLspid = '00eb227b-db40-4e45-8e51-b694d18b2a15'

        local throwableTag = 'cytanb-throwable'
        local ballTag = 'cytanb-ball'
        local targetTag = 'cytanb-target'
        local colorPickerTag = 'cytanb-color-picker'

        local velocitySwitchName = 'cball-settings-velocity-switch'
        local angularVelocitySwitchName = 'cball-settings-angular-velocity-switch'
        local altitudeSwitchName = 'cball-settings-altitude-switch'
        local throwingDetectionSwitchName = 'cball-settings-throwing-detection-switch'
        local gravitySwitchName = 'cball-settings-gravity-switch'
        local efkLevelSwitchName = 'cball-settings-efk-switch'
        local audioVolumeSwitchName = 'cball-settings-volume-switch'

        return {
            velocitySwitchName = velocitySwitchName,
            angularVelocitySwitchName = angularVelocitySwitchName,
            altitudeSwitchName = altitudeSwitchName,
            throwingDetectionSwitchName = throwingDetectionSwitchName,
            gravitySwitchName = gravitySwitchName,
            efkLevelSwitchName = efkLevelSwitchName,
            audioVolumeSwitchName = audioVolumeSwitchName,

            --- 調整用スイッチのパラメーター。
            switchParameters = cytanb.ListToMap({
                -- 速度
                {
                    colliderName = velocitySwitchName,
                    baseName = 'cball-settings-velocity-knob-pos',
                    knobName = 'cball-settings-velocity-knob',
                    propertyName = 'ballVelocityAdjustment',
                    minScaleValue = 0.5,
                    maxScaleValue = 6.0,
                    minImpactScaleValue = 2.0,
                    maxImpactScaleValue = 22.0
                },
                -- 角速度
                {
                    colliderName = angularVelocitySwitchName,
                    baseName = 'cball-settings-angular-velocity-knob-pos',
                    knobName = 'cball-settings-angular-velocity-knob',
                    propertyName = 'ballAngularVelocityAdjustment',
                    minScaleValue = 0.0078125,
                    maxScaleValue = 2.0625,
                    minImpactScaleValue = 0.125,
                    maxImpactScaleValue = 11
                },
                -- 仰俯角
                {
                    colliderName = altitudeSwitchName,
                    baseName = 'cball-settings-altitude-knob-pos',
                    knobName = 'cball-settings-altitude-knob',
                    propertyName = 'ballAltitudeAdjustment',
                    minScaleValue = -25,
                    maxScaleValue = 25,
                    minImpactScaleValue = -75,
                    maxImpactScaleValue = 75
                },
                -- 投球動作の判定時間
                {
                    colliderName = throwingDetectionSwitchName,
                    baseName = 'cball-settings-throwing-detection-knob-pos',
                    knobName = 'cball-settings-throwing-detection-knob',
                    propertyName = 'ballKinematicDetectionTime',
                    -- 単位は秒
                    minScaleValue = 0.005,
                    maxScaleValue = 0.18
                },
                -- 重力
                {
                    colliderName = gravitySwitchName,
                    baseName = 'cball-settings-gravity-knob-pos',
                    knobName = 'cball-settings-gravity-knob',
                    propertyName = 'ballGravityAdjustment',
                    minScaleValue = -9.5,
                    maxScaleValue = 9.5
                },
                -- エフェクトレベル
                {
                    colliderName = efkLevelSwitchName,
                    baseName = 'cball-settings-efk-knob-pos',
                    knobName = 'cball-settings-efk-knob',
                    propertyName = 'efkLevel'
                },
                -- 音量
                {
                    colliderName = audioVolumeSwitchName,
                    baseName = 'cball-settings-volume-knob-pos',
                    knobName = 'cball-settings-volume-knob',
                    propertyName = 'audioVolume',
                    minValue = 0,
                    maxValue = 100,
                    value = 0
                }
            }, function (entry)
                local minValue = cytanb.NillableValueOrDefault(entry.minValue, 0)
                local maxValue = cytanb.NillableValueOrDefault(entry.maxValue, 10)
                local minScaleValue = cytanb.NillableValueOrDefault(entry.minScaleValue, minValue)
                local maxScaleValue = cytanb.NillableValueOrDefault(entry.maxScaleValue, maxValue)

                return entry.colliderName, {
                    colliderName = entry.colliderName,
                    baseName = entry.baseName,
                    knobName = entry.knobName,
                    propertyName = entry.propertyName,
                    minValue = minValue,
                    maxValue = maxValue,
                    value = cytanb.NillableValueOrDefault(entry.value, 5),
                    minScaleValue = minScaleValue,
                    maxScaleValue = maxScaleValue,
                    minImpactScaleValue = cytanb.NillableValueOrDefault(entry.minImpactScaleValue, minScaleValue),
                    maxImpactScaleValue = cytanb.NillableValueOrDefault(entry.maxImpactScaleValue, maxScaleValue),
                    tickVector = Vector3.__new(0.0, 0.01, 0.0)
                }
            end),

            --- 重力加速度の規定値
            defaultGravity = -9.81,

            --- 力を加える時の、最大タイムレート。
            maxForceTimeRate = 16.0,

            --- 投球動作とみなす速度の閾値。
            ballKinematicVelocityThreshold = 1.0,

            --- 投球動作の判定時間の閾値。
            ballKinematicDetectionTimeThreshold = TimeSpan.FromMilliseconds(300),

            --- 投球動作の判定の係数。
            ballKinematicDetectionFactor = 0.25,

            --- ボールの長辺のシミュレーション値。
            ballSimLongSide = 0.217,

            --- ボールの質量のシミュレーション値。
            ballSimMass = 35.0,

            --- ボールの回転抵抗のシミュレーション値。
            ballSimAngularDrag = 0.1,

            --- ボールの回転のシミュレーション係数。
            ballSimAngularFactor = 0.125,

            --- 体のコライダーとの接触を避けるための、オフセット係数。
            ballForwardOffsetFactor = 0.1,

            --- 体のコライダーとの接触を避けるための、オフセットの最大値。
            ballMaxForwardOffset = 0.5,

            --- ボールのリスポーン時間。
            ballRespawnCoolTime = TimeSpan.FromSeconds(0.75),

            --- ボールのリスポーン位置のオフセット。
            ballRespawnOffsetY = 0.75,

            --- ボールがアクティブであることを判定する距離の閾値。
            ballActiveDistanceThreshold = 0.25,

            --- ボールがリスポーンするまでの待ち時間。
            ballWaitingTime = TimeSpan.FromMinutes(30),

            --- ボールのプレイエリアの半径。これを超えたら軌道計算などを行わない。
            ballPlayAreaRadius = 500,

            --- ボールが近距離にあると判定する距離。
            ballNearDistance = 5,

            --- ボールが遠距離にあると判定する距離。
            ballFarDistance = 20,

            --- ボールの軌跡を表示する速度の閾値。
            ballTrailVelocityThreshold = 1.25,

            --- ボールの軌跡を補間する距離の係数。
            ballTrailInterpolationDistanceFactor = 0.5,

            --- ボールの軌跡の毎フレームの補間ノード数の基準値。
            ballTrailInterpolationNodesPerFrame = 5,

            --- 投球音の最大速度。
            ballMaxThrowingAudioVelocity = 15.0,

            --- 入力モードの遷移時間。
            impactModeTransitionTime = TimeSpan.FromMilliseconds(500),

            --- ゲージの毎秒の変化率。
            impactGaugeRatioPerSec = 1,

            --- ゲージの UV の最大値。
            impactGaugeMaxUV = 0.135,

            --- ゲージの表示時間。
            impactGaugeDisplayTime = TimeSpan.FromSeconds(2),

            --- ライトの長辺のシミュレーション値。
            standLightSimLongSide = 0.575,

            --- ライトの質量のシミュレーション値。
            standLightSimMass = 1.0,

            --- ライトの水平姿勢判定の閾値。
            standLightHorizontalAttitudeThreshold = 5.0,

            --- ライトの最小ヒットマグニチュード。
            standLightMinHitMagnitude = 0.5,

            --- ライトの最大ヒットマグニチュード。
            standLightMaxHitMagnitude = 3.0,

            --- ライトのY方向の最小ヒットマグニチュード。
            standLightMinHitMagnitudeY = 0.5,

            --- ライトのY方向の最大ヒットマグニチュード。
            standLightMaxHitMagnitudeY = 0.75,

            --- ライトにヒットしたときに、最大質量係数。
            standLightMaxHitMassFactor = 3.0,

            --- ライトを放したときに倒れていた場合に、立て直す最小時間。
            standLightMinRebuildTime = TimeSpan.FromSeconds(2),

            --- ライトを放したときに倒れていた場合に、立て直す最大時間。
            standLightMaxRebuildTime = TimeSpan.FromSeconds(5),

            --- ライトがリスポーンするまでの待ち時間。
            standLightWaitingTime = TimeSpan.FromSeconds(60),

            --- 設定パネルを表示するオフセット位置。
            settingsPanelOffset = Vector3.__new(-1.5, 0.25, 0),

            --- 設定パネルの距離の閾値。
            settingsPanelDistanceThreshold = 5.0,

            --- 設定パネルの角度の閾値。
            settingsPanelAngleThreshold = 70,

            --- リセット操作の時間。
            resetOperationTime = TimeSpan.FromMilliseconds(1000),

            --- メッセージのインターバル時間。
            requestIntervalTime = TimeSpan.FromSeconds(3),

            --- 投擲物のタグ名。
            throwableTag = throwableTag,

            --- ボールのタグ名。
            ballTag = ballTag,

            --- ボールのオブジェクト名。
            ballName = 'cball#' .. throwableTag .. '#' .. ballTag .. '#' .. colorPickerTag,

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

            --- ボールの投球音のクリップ名。
            ballThrowingAudioName = 'throwing-wind-se',

            --- ボールのカップのオブジェクト名。
            ballCupName = 'ball-cup',

            --- ボールのカップのライトのマテリアル名。
            ballCoveredLightMat = 'covered-light-mat',

            --- カラーピッカーのタグ名。
            colorPickerTag = colorPickerTag,

            --- カラーインデックスオブジェクトのプレフィックス。
            colorIndexNamePrefix = 'cytanb-color-index-',

            --- 識別エフェクトの最小再生周期。
            discernibleEfkMinPeriod = TimeSpan.FromSeconds(4.5),

            --- 識別エフェクトの最大再生周期。
            discernibleEfkMaxPeriod = TimeSpan.FromSeconds(10),

            --- ターゲットのタグ名。
            targetTag = targetTag,

            --- ライトのオブジェクト名の接頭辞。
            standLightPrefix = 'oO-standlight#' .. targetTag .. '#' .. colorPickerTag .. '#',

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

            --- 設定パネルの閉じるスイッチの基準オブジェクト名。
            closeSwitchBaseName = 'cball-settings-close-knob-pos',

            --- アバターのコライダー名リスト。
            avatarColliders = {'Head', 'Chest', 'Hips', 'RightArm', 'LeftArm', 'RightHand', 'LeftHand', 'RightThigh', 'LeftThigh', 'RightFoot', 'LeftFoot', 'RightToes', 'LeftToes'},

            --- ローカルの共有プロパティ。
            lsp = cytanb.CreateLocalSharedProperties(cballSettingsLspid, loadid),

            --- 統計の共有プロパティ。
            statsLsp = cytanb.CreateLocalSharedProperties(statsLspid, loadid),

            --- 投球回数のプロパティ名。
            statsThrowingCountPropertyName = 'throwing.count',

            --- ターゲットへのヒット数のプロパティ名のプレフィックス。
            statsHitCountPropertyNamePrefix = 'hit.',

            --- スローイングのエフェクトを有効にするか。
            enableThrowingEfk = false,

            --- デバッギングを有効にするか。
            enableDebugging = false
        }
    end
}
