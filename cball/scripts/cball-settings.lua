----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

local ballTag = '#cytanb-ball'

return {
    --- 速度の調整値。初期設定値を変更する場合はこの値を変更する。([-5, 5] の範囲)
    ballVelocityAdjustment = 0,

    --- 角速度の調整値。初期設定値を変更する場合はこの値を変更する。([-5, 5] の範囲)
    ballAngularVelocityAdjustment = 0,

    --- 仰俯角の調整値。初期設定値を変更する場合はこの値を変更する。([-5, 5] の範囲)
    ballAltitudeAdjustment = 0,

    --- 投球動作として、リリースポイントからさかのぼって速度計算に反映する時間。([100, 250] ms 程度の範囲)
    ballKinematicTime = TimeSpan.FromMilliseconds(200),

    --- 投球動作とみなす速度の閾値。
    ballKinematicVelocityThreshold = 1.0,

    --- 投球動作による速度係数の最小値。
    ballKinematicMinVelocityFactor = 0.125,

    --- 投球動作による速度係数の最大値。
    ballKinematicMaxVelocityFactor = 0.875,

    --- 投球動作による角速度係数の最小値。
    ballKinematicMinAngularVelocityFactor = 0.5,

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
    ballInpactMinAltitudeScale = -45,

    --- 入力タイミングによる仰俯角のスケールの最大値。
    ballInpactMaxAltitudeScale = 45,

    --- ボールの回転のシミレーション係数。
    ballSimAngularFactor = 0.01,

    --- ボールの回転抵抗のシミュレーション係数。
    ballSimAngularDrag = 0.1,

    --- 体のコライダーとの接触を避けるための、オフセット係数。
    ballForwardOffsetFactor = 0.1,

    --- 体のコライダーとの接触を避けるための、オフセットの最大値。
    ballMaxForwardOffset = 0.5,

    --- ボールのリスポーン位置のオフセット。
    ballRespawnOffsetY = 0.75,

    --- ボールがアクティブであることを判定する閾値。
    ballActiveThreshold = 0.75 + 0.25,

    --- ボールがリスポーンするまでの待ち時間。
    ballWaitingTime = TimeSpan.FromSeconds(30),

    --- ボールのプレイエリアの半径。これを超えるとリスポーンする。
    ballPlayAreaRadius = 30,

    --- ゲージの毎秒の変化率。
    impactGaugeRatioPerSec = 1,

    --- ゲージの UV の最大値。
    impactGaugeMaxUV = 0.135,

    --- ゲージの表示時間。
    impactGaugeDisplayTime = TimeSpan.FromSeconds(2),

    --- ライトの水平姿勢判定の閾値。
    standLightHorizontalAttitudeThreshold = 5.0,

    --- ライトのジャンプ係数。
    standLightJumpFactor = 100,

    --- ライトがリスポーンするまでの待ち時間。
    standLightWaitingTime = TimeSpan.FromSeconds(60),

    --- ライトにメッセージを送るインターバル時間。
    standLightRequestIntervalTime = TimeSpan.FromSeconds(3),

    --- 設定パネルの距離の閾値。
    settingsPanelDistanceThreshold = 3.0,

    --- 設定パネルの調節スイッチのY座標。
    settingsPanelAdjustmentSwitchNeutralPositionY = -0.1185,

    --- 設定パネルの調節スイッチの目盛り。
    settingsPanelAdjustmentSwitchDivisionScale = 0.01,

    --- ボールのタグ名。
    ballTag = ballTag,

    --- ボールのオブジェクト名。
    ballName = 'cball' .. ballTag,

    --- ボールのカップのオブジェクト名。
    ballCupName = 'ball-cup',

    --- ライトのオブジェクト名の接頭辞。
    standLightPrefix = 'oO-standlight-',

    --- ライトのオブジェクト数。
    standLightCount = 3,

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
        {switchName = 'cball-settings-velocity-switch', knobName = 'cball-settings-velocity-knob', propertyName = 'ballVelocityAdjustment'},
        {switchName = 'cball-settings-angular-velocity-switch', knobName = 'cball-settings-angular-velocity-knob', propertyName = 'ballAngularVelocityAdjustment'},
        {switchName = 'cball-settings-altitude-switch', knobName = 'cball-settings-altitude-knob', propertyName = 'ballAltitudeAdjustment'}
    },

    --- デバッギングを有効にするか。
    enableDebugging = false
}
