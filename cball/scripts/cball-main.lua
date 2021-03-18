-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local IsHorizontalAttitude = function (rotation, up, angleAccuracy)
    local angle, axis = cytanb.QuaternionToAngleAxis(rotation)
    local acc = angleAccuracy or 1.0
    if angle <= acc or 360 - angle <= acc then
        return true
    else
        local au = Vector3.Angle(axis, up or Vector3.up)
        return au <= acc or 180 - au <= acc
    end
end

local ApplyAltitudeAngle = function (vec, angle, upwards)
    local axis = Vector3.Cross(upwards or Vector3.up, vec)
    if axis == Vector3.zero then
        -- upwards と軸が同じであれば、元のベクトルを返す。
        return vec
    else
        return Quaternion.AngleAxis(- angle, axis) * vec
    end
end

local IsContactWithTarget = function (sourcePosition, sourceLongSide, targetPosition, targetLongSide)
    -- `GetPosition()` が正確に衝突した位置を返すとは限らないので、ズレを考慮して幅を持たせる。
    return (sourcePosition - targetPosition).sqrMagnitude <= ((sourceLongSide + targetLongSide) * 0.75 ) ^ 2
end

local settings = require('cball-settings').Load(_ENV, cytanb)

local cballNS = 'com.github.oocytanb.oO-vci-pack.cball'
local statusMessageName = cballNS .. '.status'
local queryStatusMessageName = cballNS .. '.query-status'
local statusChangedMessageName = cballNS .. '.status-changed'
local respawnBallMessageName = cballNS .. '.respawn-ball'
local buildStandLightMessageName = cballNS .. '.build-standlight'
local buildAllStandLightsMessageName = cballNS .. '.build-all-standlights'
local hitMessageName = cballNS .. '.hit'
local throwingStatsMessageName = cballNS .. '.throwing-stats'
local showSettingsPanelMessageName = cballNS .. '.show-settings-panel'

local colorPaletteItemStatusMessageName = 'cytanb.color-palette.item-status'

--- VCI がロードされたか。
local vciLoaded = false

local hiddenPosition

local avatarColliderMap = cytanb.ListToMap(settings.avatarColliders, true)
local timestepEstimater
local fixedTimestep

-- VCAS の GetPosition() などは、前のフレームの値を返すため、時間も合わせる。
local prevTime

local ball, ballCup
local ballEfkContainer, ballEfk, ballEfkFade, ballEfkFadeMove, ballEfkFadeFly, ballEfkOne, ballEfkOneLarge, ballDiscernibleEfkPlayer
local standLights, standLightEfkContainer, standLightHitEfk, standLightDirectHitEfk
local colorPickers, currentColorPicker
local impactForceGauge, impactSpinGauge
local settingsPanel, settingsPanelGlue, closeSwitch
local slideSwitchMap, velocitySwitch, angularVelocitySwitch, altitudeSwitch, throwingAdjustmentSwitch, gravitySwitch, efkLevelSwitch, audioVolumeSwitch

local ballStatus = {
    --- ボールがつかまれているか。
    grabbed = false,

    --- ボールがグリップされたか。
    gripPressed = false,

    --- ボールがグリップされた時間。
    gripStartTime = TimeSpan.Zero,

    --- ボールを投げた時間。
    throwTime = vci.me.Time,

    --- ボールがアクティブになった時間。
    activeTime = vci.me.Time,

    --- インアクティブのエフェクトを再生した時間。
    inactiveEfkPlayTime = TimeSpan.Zero,

    --- ボールがリスポーンした時間。
    respawnTime = vci.me.Time,

    --- 重力係数。
    gravityFactor = 0.0,

    --- ボールのトランスフォームのキュー。
    transformQueue = cytanb.CreateCircularQueue(32),

    --- ボールの角速度のシミュレーション値。
    simAngularVelocity = Vector3.zero,

    --- ボールがライト以外に当たった回数。
    boundCount = 0
}

local ballCupStatus = {
    --- カップがつかまれているか。
    grabbed = false,

    --- カップのクリック数。
    clickCount = 0,

    --- カップのクリック時間。
    clickTime = TimeSpan.Zero,

    --- カップのグラブによるクリック数。
    grabClickCount = 0,

    --- カップのグラブによるクリック時間。
    grabClickTime = TimeSpan.Zero
}

local standLightInitialStatus = {
    --- ビルドが必要であることを示すフラグ。
    buildFlag = false,

    --- ライトがアクティブであるか。
    active = true,

    --- ライトがインアクティブになったときの時間。
    inactiveTime = TimeSpan.Zero,

    --- ライトをインアクティブにできるようになった時間。操作権の違うボールがヒットしたときに、セットされる。
    readyInactiveTime = TimeSpan.Zero,

    --- ヒットメッセージを処理したときの時間。短時間で複数回ヒット処理をしてしまうのを避けるために利用される。
    hitMessageTime = TimeSpan.Zero,

    --- ヒットの起点となったボールのクライアント ID。ライト同士が玉突き状態で倒れた時に、起点の ID を識別できるようにする。
    hitSourceID = '',

    --- ボールが直接ライトにヒットしたか。
    directHit = false
}

local discernibleColorStatus = {
    --- 識別色の初期化を行ったか。
    initialized = not vci.assets.IsMine,

    --- 存在する識別色のインデックステーブル。
    existentIndexTable = {},

    --- 識別色の存在チェックをリクエストした時間。
    checkRequestedTime = TimeSpan.Zero,

    --- カラーパレットへの衝突カウント。
    paletteCollisionCount = 0,

    --- カラーパレットへ衝突した時間。
    paletteCollisionTime = TimeSpan.Zero
}

local impactStatus = {
    --- 投球フェーズ。
    phase = 0,

    --- 投球の威力の比率。
    forceGaugeRatio = 0,

    --- 投球のスピンの比率。
    spinGaugeRatio = 0,

    --- 投球のゲージの表示開始時間。
    gaugeStartTime = TimeSpan.Zero
}

local settingsPanelStatus = {
    --- 設定パネルがつかまれているか。
    grabbed = false,

    --- 設定パネルがグリップされたか。
    gripPressed = false,

    --- 設定パネルがグリップされた時間。
    gripStartTime = TimeSpan.Zero
}

--- 統計情報のキャッシュ
local statsCache = {
    --- 最後に統計情報を出力した時間。
    lastOutputTime = vci.me.UnscaledTime,

    --- 投球をキャッシュしている数。この値がゼロより大きければ、適当なタイミングで統計情報を出力する。
    throwingCache = 0,

    --- 最後に投球を行ったときの速度。
    throwingVelocity = Vector3.zero,

    --- 最後に投球を行ったときの回転速度。
    throwingAngularVelocity = Vector3.zero,

    --- 最後に投球を行ったときの位置。
    throwingPosition = Vector3.zero,

    --- 最後に投球を行ったときのフレームタイム。
    throwingFrameSeconds = 0,

    --- 重力加速度。
    gravity = settings.defaultGravity,
}

--- ライトを組み立てるリクエストを送った時間。
local standLightsLastRequestTime = vci.me.UnscaledTime

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local ResetStats = function ()
    cytanb.LogInfo('Reset stats')
    statsCache.throwingCache = 0
    settings.statsLsp.Clear()
end

local StatsToString = function (stats)
    local indent = '  '

    -- 設定値
    local settingsString = ''
    for name, val in pairs(stats.settingsValues) do
        settingsString = (settingsString == '' and '' or settingsString .. ', ') .. name .. ': ' .. tostring(val)
    end
    settingsString = settingsString .. '}'

    -- 直線距離での、予測飛距離を計算する。
    -- カーブを考慮しないことや、フレームレートの影響による AddForce の変動、その他の要因により、実測とは異なる。
    local predictedFlyingDistanceString
    if stats.throwingPosition.y > 0 and stats.gravity < 0 then
        local g = - stats.gravity
        local h = stats.throwingPosition.y
        local vx0 = math.sqrt(stats.throwingVelocity.x ^ 2 + stats.throwingVelocity.z ^ 2)
        local vy0 = stats.throwingVelocity.y
        local distance = vx0 * (vy0 + math.sqrt(vy0 ^ 2 + 2 * g * h)) / g
        local uDistance, siPrefix = cytanb.CalculateSIPrefix(distance)
        predictedFlyingDistanceString = cytanb.Round(uDistance, 2) .. ' [' .. siPrefix .. 'm]'
    else
        predictedFlyingDistanceString = 'N/A'
    end

    local frameTimeLine = stats.throwingFrameSeconds <= 0
        and ''
        or indent .. 'frameTime: ' .. cytanb.Round(stats.throwingFrameSeconds * 1000)
            .. ' [ms] (' .. cytanb.Round(1.0 / stats.throwingFrameSeconds, 2) .. '), timestep: '
            .. cytanb.Round(timestepEstimater.Timestep().TotalMilliseconds, 2) .. ' [ms]\n'

    return indent .. 'settings: ' .. settingsString
        .. '\n' .. frameTimeLine
        .. indent .. 'throwingCount: ' .. stats.throwingCount
        .. '\n' .. indent .. 'velocity: ' .. cytanb.Round(stats.throwingVelocity.magnitude * 3.6, 2) .. ' [km/h], Vector3' .. tostring(stats.throwingVelocity)
        .. '\n' .. indent .. 'angularVelocity: magnitude(' .. cytanb.Round(stats.throwingAngularVelocity.magnitude, 2) .. '), Vector3' .. tostring(stats.throwingAngularVelocity)
        .. '\n' .. indent .. 'predictedFlyingDistance: ' .. predictedFlyingDistanceString
end

local ProcessStatsCache = function ()
    if statsCache.throwingCache <= 0 then
        return
    end

    local now = vci.me.UnscaledTime
    if now - settings.resetOperationTime <= statsCache.lastOutputTime then
        return
    end
    statsCache.lastOutputTime = now

    settings.statsLsp.SetProperty(
        settings.statsThrowingCountPropertyName,
        settings.statsLsp.GetProperty(settings.statsThrowingCountPropertyName, 0) + statsCache.throwingCache
    )

    statsCache.throwingCache = 0

    local settingsValues = {}
    for switchName, parameter in pairs(settings.switchParameters) do
        settingsValues[parameter.propertyName] = slideSwitchMap[switchName].GetValue()
    end

    cytanb.EmitMessage(throwingStatsMessageName, {
        clientID = cytanb.ClientID(),
        stats = {
            throwingCount = settings.statsLsp.GetProperty(settings.statsThrowingCountPropertyName, 0),
            throwingVelocity = cytanb.Vector3ToTable(statsCache.throwingVelocity),
            throwingAngularVelocity = cytanb.Vector3ToTable(statsCache.throwingAngularVelocity),
            throwingPosition = cytanb.Vector3ToTable(statsCache.throwingPosition),
            throwingFrameSeconds = statsCache.throwingFrameSeconds,
            gravity = statsCache.gravity,
            settingsValues = settingsValues
        }
    })
end

local IncrementStatsHitCount = function (targetName)
    local propertyName = settings.statsHitCountPropertyNamePrefix .. targetName
    settings.statsLsp.SetProperty(
        propertyName,
        settings.statsLsp.GetProperty(propertyName, 0) + 1
    )
end

local CalcDirectionAngle = function (angle360)
    local angle = angle360 % 360
    return (angle <= 180 and angle or angle - 360)
end

local CalcAngularVelocity = function (axis, directionAngle180, seconds)
    return axis * ((directionAngle180 <= 0 and 1 or -1) * math.rad(directionAngle180 / seconds))
end

local CalcAdjustmentValue = function (switch, impactMode)
    local parameters = cytanb.NillableValue(settings.switchParameters[switch.GetColliderItem().GetName()])
    local min = impactMode and parameters.minImpactScaleValue or parameters.minScaleValue
    local max = impactMode and parameters.maxImpactScaleValue or parameters.maxScaleValue
    return min + (max - min) * (switch.GetValue() - parameters.minValue) / (parameters.maxValue - parameters.minValue)
end

local CalcThrowingAdjustmentSeconds = function ()
    return CalcAdjustmentValue(throwingAdjustmentSwitch, false) ^ settings.ballThrowingAdjustmentTimeExponent
end

local CalcGravityFactor = function ()
    return - CalcAdjustmentValue(gravitySwitch, false)
end

local CalcAudioVolume = function ()
    return cytanb.Clamp(audioVolumeSwitch.GetValue() / audioVolumeSwitch.GetMaxValue(), 0.0, 1.0)
end

local CreateDiscernibleEfkPlayer = function (efk, periodTime)
    local period = periodTime
    local color = Color.__new(0, 0, 0, 0)
    local lastPlayTime = TimeSpan.Zero

    local self
    self = {
        GetEfk = function ()
            return efk
        end,

        GetPeriod = function ()
            return period
        end,

        SetPeriod = function (time)
            period = time
        end,

        GetColor = function ()
            return color
        end,

        SetColor = function (discernibleColor)
            color = discernibleColor
        end,

        ContinualPlay = function ()
            local efkLevel = efkLevelSwitch.GetValue()
            if efkLevel >= 9 then
                local now = vci.me.UnscaledTime
                if now >= lastPlayTime + period then
                    lastPlayTime = now
                    efk.Stop()
                    efk.Play()
                    efk.SetAllColor(color)
                end
            end
        end,

        Stop = function ()
            if lastPlayTime ~= TimeSpan.Zero then
                efk.Stop()
                lastPlayTime = TimeSpan.Zero
            end
        end
    }
    return self
end

local SetDiscernibleColor = function (color)
    local h, s, v = cytanb.ColorRGBToHSV(color)
    cytanb.LogDebug('SetDiscernibleColor: color = ', color, ', h = ', h, ', s = ', s, ', v = ', v)
    ballDiscernibleEfkPlayer.SetColor(color)

    local efkLevel = efkLevelSwitch.GetValue()
    local mc = (efkLevel <= 7 or v <= 0.75)
        and color
        or Color.HSVToRGB(h, s, v * settings.discernibleColorValueFactor * math.min(10, efkLevel) / 10)

    vci.assets.SetMaterialColorFromName(settings.ballCoveredLightMat, mc)
end

local OfferBallTransform = function (position, rotation, time)
    ballStatus.transformQueue.Offer({position = position, rotation = rotation, time = time})
end

local CreateDiscernibleColorParameter = function ()
    return {
        clientID = cytanb.ClientID(),
        discernibleColor = cytanb.ColorToTable(ballDiscernibleEfkPlayer.GetColor())
    }
end

local CreateBallStatusParameter = function ()
    return {
        name = ball.GetName(),
        position = cytanb.Vector3ToTable(ball.GetPosition()),
        rotation = cytanb.QuaternionToTable(ball.GetRotation()),
        longSide = settings.ballSimLongSide,
        mass = settings.ballSimMass,
        grabbed = ballStatus.grabbed,
        operator = ball.IsMine
    }
end

local CreateStandLightStatusParameter = function (light)
    local li = light.item
    local ls = light.status
    return {
        name = li.GetName(),
        position = cytanb.Vector3ToTable(li.GetPosition()),
        rotation = cytanb.QuaternionToTable(li.GetRotation()),
        longSide = settings.standLightSimLongSide,
        mass = settings.standLightSimMass,
        respawnPosition = cytanb.Vector3ToTable(ls.respawnPosition),
        grabbed = ls.grabbed,
        operator = li.IsMine
    }
end

local EmitHitBall = function (targetName, hitBaseName)
    if not ball.IsMine then
        cytanb.LogWarn('Unexpected operation: ball is not mine @EmitHitBall')
        return
    end

    local queueSize = ballStatus.transformQueue.Size()
    local velocity
    if queueSize >= 3 then
        -- 直前の位置をとると、衝突後の位置が入っているため、その前の位置を採用する
        local et = ballStatus.transformQueue.Get(queueSize - 1)
        local st = ballStatus.transformQueue.Get(queueSize - 2)
        local dp = et.position - st.position
        local deltaSec = (et.time - st.time).TotalSeconds
        velocity = dp / (deltaSec > 0 and deltaSec or 0.000001)
        cytanb.LogTrace('EmitHitBall: deltaPos = ', dp, ', deltaSec = ', deltaSec)
    else
        velocity = Vector3.zero
        cytanb.LogTrace('EmitHitBall: zero velocity')
    end

    cytanb.LogTrace('  emit ', hitMessageName, ': target = ', targetName, ', velocity = ', velocity, ', boundCount = ', ballStatus.boundCount)
    cytanb.EmitMessage(hitMessageName, {
        source = cytanb.Extend(CreateBallStatusParameter(), {
            velocity = cytanb.Vector3ToTable(velocity),
            hitSourceID = cytanb.ClientID()
        }),
        target = {
            name = targetName
        },
        directHit = ballStatus.boundCount == 0
    })

    -- ライト以外のターゲットに当たったら、ヒットカウントを更新する。
    -- ライトは自前で倒れた処理をしているので、そちらでカウントする。
    if not cytanb.NillableHasValue(standLights[targetName]) then
        IncrementStatsHitCount(hitBaseName == '' and targetName or hitBaseName)
    end
end

local EmitHitStandLight = function (light, targetName)
    local li = light.item
    local ls = light.status
    if not li.IsMine then
        cytanb.LogWarn('Unexpected operation: light is not mine @EmitHitStandLight')
        return
    end

    local now = vci.me.Time
    if now > ls.inactiveTime + settings.requestIntervalTime then
        -- 自身のライトが倒れている状態でヒットした場合は、無視する
        return
    end

    local deltaSec = (now - ls.inactiveTime).TotalSeconds
    local velocity
    if deltaSec > 0 then
        local dp = li.GetPosition() - ls.respawnPosition
        velocity = dp / deltaSec
        cytanb.LogTrace('EmitHitStandLight: deltaPos = ', dp, ', deltaSec = ', deltaSec)
    else
        velocity = Vector3.zero
        cytanb.LogTrace('EmitHitStandLight: zero velocity')
    end

    --@todo hitMessage が来る前に、ライトがターゲットに当たった場合は、hitSourceID を正しく設定できないので、対策を考える。
    local hitSourceID = now <= ls.hitMessageTime + settings.requestIntervalTime and ls.hitSourceID or ''

    cytanb.LogTrace('  emit ', hitMessageName, ': target = ', targetName, ', velocity = ', velocity, ', hitSourceID = ', hitSourceID)
    cytanb.EmitMessage(hitMessageName, {
        source = cytanb.Extend(CreateStandLightStatusParameter(light), {
            velocity = cytanb.Vector3ToTable(velocity),
            hitSourceID = hitSourceID
        }),
        target = {
            name = targetName
        },
        directHit = false
    })
end

local BuildStandLight = function (light)
    local li = light.item
    local ls = light.status

    cytanb.Extend(ls, standLightInitialStatus)
    ls.inactiveTime = vci.me.Time

    if li.IsMine and not ls.grabbed then
        li.SetRotation(Quaternion.identity)
        li.SetPosition(ls.respawnPosition)
        li.SetVelocity(Vector3.zero)
        li.SetAngularVelocity(Vector3.zero)
    end
end

local HitStandLight = function (light)
    local li = light.item
    local ls = light.status
    local now = vci.me.Time
    -- ライトが倒れた直後ならヒットしたものとして判定する
    if not ls.active and now <= ls.inactiveTime + settings.requestIntervalTime then
        if ls.hitSourceID == cytanb.ClientID() then
            IncrementStatsHitCount(settings.standLightBaseName)
        end

        local efkLevel = efkLevelSwitch.GetValue()
        if efkLevel == 5 and ball.IsMine then
            -- レベル 5 で、ボールの操作権があるときは、レベル 6 のエフェクトを表示する
            efkLevel = 6
        end

        if efkLevel >= 6 then
            local efk = ls.directHit and standLightDirectHitEfk or standLightHitEfk
            cytanb.LogTrace('play efk: ', efk.EffectName, ',', li.GetName())
            standLightEfkContainer.SetPosition(li.GetPosition())
            efk.Play()
            efk.SetAllColor(ballDiscernibleEfkPlayer.GetColor())
        end

        local volume = CalcAudioVolume()
        if volume > 0 then
            local clipName
            if ls.directHit then
                clipName = settings.standLightDirectHitAudioName
            else
                clipName = settings.standLightHitAudioPrefix .. light.index
            end
            cytanb.LogTrace('play audio: ', clipName, ', volume = ', volume)
            vci.assets.audio.PlayOneShot(clipName, volume)
        end

        ls.readyInactiveTime = TimeSpan.Zero
    end
end

--- ゲージをリセットする。
local ResetGauge = function ()
    impactStatus.phase = 0
    impactStatus.spinGaugeRatio = 0
    impactStatus.forceGaugeRatio = 0
    impactStatus.gaugeStartTime = vci.me.Time
    ballStatus.simAngularVelocity = Vector3.zero

    impactForceGauge.SetPosition(hiddenPosition)
    impactForceGauge.SetRotation(Quaternion.identity)
    impactSpinGauge.SetPosition(hiddenPosition)
    impactSpinGauge.SetRotation(Quaternion.identity)
    vci.assets.SetMaterialTextureOffsetFromName(settings.impactForceGaugeMat, Vector2.zero)
end

local ResetBallCup = function ()
    if ballCup.IsMine and not ballCupStatus.grabbed and not IsHorizontalAttitude(ballCup.GetRotation()) then
        cytanb.LogTrace('reset cup rotation')
        ballCup.SetRotation(Quaternion.identity)
    end
end

--- ボールをカップへ戻す。
local RespawnBall = function ()
    ballDiscernibleEfkPlayer.Stop()
    ResetGauge()
    ResetBallCup()

    ballStatus.throwTime = prevTime

    if ball.IsMine then
        ball.SetVelocity(Vector3.zero)
        ball.SetAngularVelocity(Vector3.zero)

        local ballPos = ballCup.GetPosition() + Vector3.__new(0, settings.ballRespawnOffsetY, 0)
        local ballRot = Quaternion.identity
        ball.SetPosition(ballPos)
        ball.SetRotation(ballRot)

        local now = vci.me.Time
        ballStatus.transformQueue.Clear()
        OfferBallTransform(ballPos, ballRot, now)
        ballStatus.respawnTime = now
        cytanb.LogDebug('on respawn ball: position = ', ballPos)
    end
end

local DrawThrowingTrail = function ()
    local queueSize = ballStatus.transformQueue.Size()
    if not settings.enableThrowingEfk or queueSize < 2 then
        return
    end

    local headTransform = ballStatus.transformQueue.PeekLast()
    local headTime = headTransform.time

    for i = queueSize, 1, -1 do
        local element = ballStatus.transformQueue.Get(i)
        if not element then
            break
        end

        if headTime - element.time > settings.ballThrowingAdjustmentTimeThreshold then
            break
        end

        local pos = element.position
        ballEfkContainer.SetPosition(pos)
        ballEfkOneLarge.Play()
    end
end

local PlayThrowingAudio = function (velocityMagnitude)
    local volume = CalcAudioVolume()
    local min = settings.ballThrowingVelocityThreshold
    if volume > 0 and velocityMagnitude > min then
        local max = settings.ballMaxThrowingAudioVelocity
        local mvol = volume * (cytanb.Clamp(velocityMagnitude, min, max) - min) / (max - min)
        -- cytanb.LogTrace('play throwing audio: mvol = ', mvol)
        vci.assets.audio.PlayOneShot(settings.ballThrowingAudioName, mvol)
    end
end

local IsInThrowingMotion = function ()
    local queueSize = ballStatus.transformQueue.Size()
    if not ball.IsMine or queueSize < 2 then
        return false
    end

    local head = ballStatus.transformQueue.Get(queueSize)
    local prev = ballStatus.transformQueue.Get(queueSize - 1)

    local deltaSec = (head.time - prev.time).TotalSeconds
    local dp = head.position - prev.position
    if deltaSec > 0 then
        local velocity = dp.magnitude / deltaSec
        local b = velocity >= settings.ballThrowingVelocityThreshold * 0.5
        cytanb.LogTrace('test throwing motion: ', b, ', velocity = ', velocity, ', deltaSec = ', deltaSec)
        return b
    else
        return false
    end
end

--- コントローラーの運動による投球。
local ThrowBallByKinematic = function (trsTime)
    -- 物理運動の正しさではなく、簡単に投げられて楽しめるものを目指して、計算を行う。
    -- 理由は、機器、投げ方、操作の慣れなどは、人それぞれ違うので、なるべく多くの人に楽しんでほしいから。

    if impactStatus.phase ~= 0 then
        ResetGauge()
    end

    DrawThrowingTrail()

    if not ball.IsMine then
        return
    end

    local queue = ballStatus.transformQueue
    if queue.Size() <= 2 then
        return
    end

    ballStatus.gravityFactor = CalcGravityFactor()

    local headTransform = queue.PollLast()
    local headTime = headTransform.time
    local ballPos = headTransform.position
    local ballRot = headTransform.rotation

    local releaseVector = Vector3.zero
    local releaseVectorChecked = false

    local velocityDirection = Vector3.zero
    local totalVelocityMagnitude = 0

    local angularVelocityDirection = Vector3.zero
    local totalAngle = 0

    local totalWeightSec = 0

    local st = headTime
    local sp = ballPos
    local sr = ballRot

    -- 補正時間を計算
    local ft = headTime
    local frameCount = 0
    for i = queue.Size(), 1, -1 do
        local element = queue.Get(i)
        -- 重複しているタイムは除く
        if element.time ~= ft then
            frameCount = frameCount + 1
            ft = element.time
            if frameCount > 10 then
                break
            end
        end
    end

    if frameCount <= 0 then
        return
    end

    local frameSec = (headTime - ft).TotalSeconds / frameCount
    if frameSec <= 0 then
        return
    end
    -- cytanb.LogTrace('frameCount: ', frameCount, ', frameSec: ', frameSec)

    local adjustmentSec = CalcThrowingAdjustmentSeconds() * math.max(0.75, settings.ballThrowingAdjustmentFrameTimeFactor1 * frameSec + settings.ballThrowingAdjustmentFrameTimeFactor2)
    cytanb.LogTrace('adjustmentSec: ', adjustmentSec)

    while true do
        local element = queue.PollLast()
        if not element then
            break
        end

        local kdTime = headTime - element.time
        -- cytanb.LogTrace('kdTime: ', kdTime.TotalSeconds)
        if kdTime > settings.ballThrowingAdjustmentTimeThreshold then
            break
        end

        if kdTime.TotalSeconds > adjustmentSec and velocityDirection ~= Vector3.zero then
            break
        end

        local deltaSec = (st - element.time).TotalSeconds
        if deltaSec > Vector3.kEpsilon then
            local dp = sp - element.position
            local dpMagnitude = dp.magnitude
            if releaseVectorChecked then
                if Vector3.Dot(releaseVector, dp) < 0 then
                    -- リリース時のベクトルから、90 度を超えた開きがある場合は、終了する
                    cytanb.LogTrace('skip: out of angle range [', (headTime - element.time).TotalSeconds, ' sec]')
                    break
                end
            else
                if dpMagnitude <= Vector3.kEpsilon then
                    -- リリース時が静止状態であったとみなして、終了する
                    break
                end
                releaseVectorChecked = true
                releaseVector = dp
            end

            local dhSec = (headTime - st).TotalSeconds
            local weight = settings.ballThrowingAdjustmentWeightBase ^ dhSec
            local dirWeight = settings.ballThrowingAdjustmentDirWeightBase ^ dhSec
            -- cytanb.LogTrace('ballThrowingAdjustment: dhSec = ', dhSec, ', weight = ', weight, ', dirWeight = ', dirWeight)

            totalVelocityMagnitude = (totalVelocityMagnitude + dpMagnitude * weight)
            velocityDirection = (velocityDirection + dp * dirWeight)

            local dr = sr * Quaternion.Inverse(element.rotation)
            local da, axis = cytanb.QuaternionToAngleAxis(dr)
            if (da ~= 0 and da ~= 360) or axis ~= Vector3.right then
                local angle = CalcDirectionAngle(da)
                totalAngle = (totalAngle + angle * weight)
                angularVelocityDirection = (angularVelocityDirection + CalcAngularVelocity(axis, angle * dirWeight, 1))
            end

            totalWeightSec = totalWeightSec + deltaSec * weight
        end

        -- cytanb.LogTrace('velocityDirection: ', velocityDirection, ', angularVelocityDirection: ', angularVelocityDirection)
        st = element.time
        sp = element.position
        sr = element.rotation
    end
    queue.Clear()

    local kinematicVelocityMagnitude = totalWeightSec > Vector3.kEpsilon and totalVelocityMagnitude / totalWeightSec or 0
    cytanb.LogTrace('>> kinematicVelocityMagnitude: ', kinematicVelocityMagnitude)

    if kinematicVelocityMagnitude > settings.ballThrowingVelocityThreshold then
        local velocityMagnitude = CalcAdjustmentValue(velocitySwitch, false) * kinematicVelocityMagnitude
        local velocity = ApplyAltitudeAngle(velocityDirection.normalized, CalcAdjustmentValue(altitudeSwitch, false)) * velocityMagnitude
        local forwardOffset = velocity * (math.min(velocityMagnitude * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset) / velocityMagnitude)

        local angularVelocity = CalcAngularVelocity(angularVelocityDirection.normalized, CalcAdjustmentValue(angularVelocitySwitch, false) * totalAngle, totalWeightSec)

        ballStatus.simAngularVelocity = angularVelocity
        cytanb.LogTrace('Throw ball by kinematic: velocity: ', velocity, ', velocityMagnitude: ', velocityMagnitude, ', angularVelocity: ', angularVelocity, ', angularVelocity.magnitude: ', angularVelocity.magnitude, ', fixedTimestep: ', fixedTimestep.TotalSeconds)
        ball.SetVelocity(velocity)
        ball.SetAngularVelocity(angularVelocity)

        -- update stats
        statsCache.lastOutputTime = vci.me.UnscaledTime
        statsCache.throwingCache = statsCache.throwingCache + 1
        statsCache.throwingVelocity = velocity
        statsCache.throwingAngularVelocity = angularVelocity
        statsCache.throwingPosition = ballPos
        statsCache.throwingFrameSeconds = frameSec
        statsCache.gravity = settings.defaultGravity + ballStatus.gravityFactor

        -- 体のコライダーに接触しないように、オフセットを足す
        ballPos = ballPos + forwardOffset
        ball.SetPosition(ballPos)

        PlayThrowingAudio(velocityMagnitude)
    else
        ballStatus.simAngularVelocity = Vector3.zero
    end

    OfferBallTransform(ballPos, ballRot, trsTime)
end

--- タイミング入力による投球
local ThrowBallByInputTiming = function (trsTime)
    if not ball.IsMine then
        return
    end

    cytanb.LogTrace('Throw ball by input timing: impactSpinGaugeRatio: ', impactStatus.spinGaugeRatio, ', impactForceGaugeRatio: ', impactStatus.forceGaugeRatio, ', fixedTimestep: ', fixedTimestep.TotalSeconds)

    ballStatus.gravityFactor = CalcGravityFactor()

    local forward = impactForceGauge.GetForward()
    local velocityMagnitude = CalcAdjustmentValue(velocitySwitch, true) * impactStatus.forceGaugeRatio
    local forwardOffset = forward * math.min(velocityMagnitude * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset)
    local velocity = ApplyAltitudeAngle(forward * velocityMagnitude, CalcAdjustmentValue(altitudeSwitch, true))

    ballStatus.simAngularVelocity = Vector3.up * (CalcAdjustmentValue(angularVelocitySwitch, true) * math.pi * impactStatus.spinGaugeRatio)
    cytanb.LogTrace('velocity: ', velocity, ', velociytMagnitude: ', velocityMagnitude, ', angularVelocity: ', ballStatus.simAngularVelocity, ', angularVelocity.magnitude: ', ballStatus.simAngularVelocity.magnitude)
    local curBallPos = ball.GetPosition()
    ball.SetVelocity(velocity)
    ball.SetAngularVelocity(ballStatus.simAngularVelocity)

    -- update stats
    statsCache.lastOutputTime = vci.me.UnscaledTime
    statsCache.throwingCache = statsCache.throwingCache + 1
    statsCache.throwingVelocity = velocity
    statsCache.throwingAngularVelocity = ballStatus.simAngularVelocity
    statsCache.throwingPosition = curBallPos
    statsCache.throwingFrameSeconds = 0
    statsCache.gravity = settings.defaultGravity + ballStatus.gravityFactor

    -- 体のコライダーに接触しないように、オフセットを足す
    local ballPos = curBallPos + forwardOffset
    ball.SetPosition(ballPos)

    PlayThrowingAudio(velocityMagnitude)

    ballStatus.transformQueue.Clear()
    OfferBallTransform(ballPos, ball.GetRotation(), trsTime)
end

--- 識別エフェクトの処理をする。
local OnUpdateDiscernibleEfk = function (trsTime)
    if vci.assets.IsMine and not discernibleColorStatus.initialized and vci.me.UnscaledTime > discernibleColorStatus.checkRequestedTime + settings.requestIntervalTime then
        -- 他のインスタンスの識別色と重複しないように、色を選択する
        local lots = {}
        local count = 0
        for si = 0, cytanb.ColorSaturationSamples - 1 do
            count = 0
            for hi = 0, cytanb.ColorHueSamples - 2 do
                local index = hi + si * cytanb.ColorHueSamples
                if not discernibleColorStatus.existentIndexTable[index] then
                    lots[count] = index
                    count = count + 1
                end
            end
            if count >= 1 then
                break
            end
        end

        local colorIndex = count == 0 and math.random(0, cytanb.ColorHueSamples - 1) or lots[math.random(0, count - 1)]
        cytanb.LogDebug('discernibleColor initialized: colorIndex = ', colorIndex)
        SetDiscernibleColor(cytanb.ColorFromIndex(colorIndex))

        discernibleColorStatus.checkRequestedTime = TimeSpan.Zero
        discernibleColorStatus.initialized = true

        cytanb.EmitMessage(statusChangedMessageName, CreateDiscernibleColorParameter())
    end

    if settings.discernibleEfkEnabled and not ballStatus.grabbed then
        if not ballStatus.transformQueue.IsEmpty() and (ball.GetPosition() - ballStatus.transformQueue.PeekLast().position).sqrMagnitude > 0.0001 then
            -- ボールが動いている時は、識別エフェクトを停止する。
            ballDiscernibleEfkPlayer.Stop()
        else
            -- ボールが動いていない場合は、識別エフェクトを再生する
            ballDiscernibleEfkPlayer.ContinualPlay()
        end
    end
end

--- ゲージの表示を更新する。
local OnUpdateImpactGauge = function (trsTime, deltaTime)
    if impactStatus.phase < 1 then
        local now = vci.me.Time
        if ballStatus.grabbed and ballStatus.gripPressed and now - settings.impactModeTransitionTime > ballStatus.gripStartTime and not IsInThrowingMotion() then
            -- 連続して呼び出されないようにしておく
            ballStatus.gripStartTime = TimeSpan.MaxValue

            -- グリップ長押し状態で、運動による投球動作を行っていない場合は、タイミング入力に移行する。
            cytanb.LogTrace('Start impact mode')
            impactStatus.phase = 1
            impactStatus.gaugeStartTime = now
        else
            -- タイミング入力状態ではないためリターンする。
            return
        end
    end

    if ballStatus.grabbed then
        local ballPos = ball.GetPosition()
        impactForceGauge.SetPosition(ballPos)
        if impactStatus.phase >= 2 then
            impactSpinGauge.SetPosition(ballPos)
        end

        if impactStatus.phase == 1 then
            -- 方向の入力フェーズ
            local ratio = settings.impactGaugeRatioPerSec * deltaTime.TotalSeconds
            local angle = 180 * ratio
            local rotD = Quaternion.AngleAxis(angle, Vector3.up)
            -- cytanb.LogTrace('ratio: ', ratio, ', angle: ', angle, ', rotD : ', rotD)
            impactForceGauge.SetRotation(impactForceGauge.GetRotation() * rotD)
        elseif impactStatus.phase == 2 then
            -- スピンの入力フェーズ
            local ratio = cytanb.PingPong(settings.impactGaugeRatioPerSec * (vci.me.Time - impactStatus.gaugeStartTime).TotalSeconds + 0.5, 1) - 0.5
            local angle = 180 * ratio
            local rotD = Quaternion.AngleAxis(angle, Vector3.up)
            -- cytanb.LogTrace('ratio: ', ratio, ', angle: ', angle, ', rotD : ', rotD)
            impactSpinGauge.SetRotation(impactForceGauge.GetRotation() * rotD)

            -- 境界付近の値を調整する
            local absRatio = math.abs(ratio)
            if absRatio <= 0.05 then
                impactStatus.spinGaugeRatio = 0
            elseif absRatio >= 0.45 then
                impactStatus.spinGaugeRatio = ratio < 0 and -0.5 or 0.5
            else
                impactStatus.spinGaugeRatio = ratio
            end
        elseif impactStatus.phase == 3 then
            -- 威力の入力フェーズ
            local ratio = cytanb.PingPong(settings.impactGaugeRatioPerSec * (vci.me.Time - impactStatus.gaugeStartTime).TotalSeconds, 1)
            local offsetY = settings.impactGaugeMaxUV * ratio
            -- cytanb.LogTrace('ratio: ', ratio, ', offsetY: ', offsetY)
            vci.assets.SetMaterialTextureOffsetFromName(settings.impactForceGaugeMat, Vector2.__new(0, offsetY))

            -- 境界付近の値を調整する
            if ratio <= 0.05 then
                impactStatus.forceGaugeRatio = 0
            elseif ratio >= 0.95 then
                impactStatus.forceGaugeRatio = 1
            else
                impactStatus.forceGaugeRatio = ratio
            end
        end
    else
        if vci.me.Time > impactStatus.gaugeStartTime + settings.impactGaugeDisplayTime then
            -- ゲージの表示時間を終えた
            impactStatus.phase = 0
            impactForceGauge.SetPosition(hiddenPosition)
            impactSpinGauge.SetPosition(hiddenPosition)
        end
    end
end

local OnUpdateBallTrajectory = function (ballPos, lastPos, deltaSec, velocity)
    -- 角速度を計算する
    ballStatus.simAngularVelocity = ballStatus.simAngularVelocity * (1.0 - math.min(1.0, settings.ballSimAngularDrag * deltaSec))
    local angularVelocitySqrMagnitude = ballStatus.simAngularVelocity.sqrMagnitude
    if angularVelocitySqrMagnitude <= 0.0025 then
        ballStatus.simAngularVelocity = Vector3.zero
        angularVelocitySqrMagnitude = 0
    end

    -- スピンを適用する処理
    local horzVelocity = Vector3.__new(velocity.x, 0, velocity.z)
    local velocityMagnitude = horzVelocity.magnitude
    if velocityMagnitude > 0.0025 and angularVelocitySqrMagnitude ~= 0 then
        -- 水平方向の力を計算する
        local rf = settings.ballSimAngularFactor * settings.ballSimMass * ballStatus.simAngularVelocity.y * math.min(settings.maxForceTimeRate, deltaSec / fixedTimestep.TotalSeconds)
        local vo = Vector3.Cross(Vector3.__new(0, rf, 0), horzVelocity / velocityMagnitude)
        local vca = Vector3.__new(vo.x, 0, vo.z)
        ball.AddForce(vca)
        -- cytanb.LogTrace('vca: ', vca, ', vo: ', vo, ', velocity: ', velocity)
    end

    if ballPos.y < -0.25 and ballPos.y < lastPos.y then
        -- 床抜けの対策。
        local leapY = 0.125
        local minY = 0.25 - ballPos.y
        local dy = lastPos.y - ballPos.y
        local vy = dy * 0.5 + math.min(minY - leapY, dy * 0.25)
        local forceY = settings.ballSimMass * vy / deltaSec / fixedTimestep.TotalSeconds
        cytanb.LogDebug('leap ball: position = ', ballPos, ', vy = ', vy, ', forceY = ', forceY)
        ball.SetPosition(Vector3.__new(ballPos.x, leapY, ballPos.z))
        ball.AddForce(Vector3.__new(0, forceY, 0))
    elseif ballPos.y > settings.ballSimLongSide and math.abs(ballStatus.gravityFactor) > Vector3.kEpsilon then
        -- 重力処理
        local fixedSec = fixedTimestep.TotalSeconds
        local timeRate = deltaSec / fixedSec
        local accY
        if ballStatus.gravityFactor > 0.0 and timeRate > 1.0 and velocity.y <= 0.0 then
            -- 上向きに力を加える場合は、下向きに落下するはずが、フレームレートの減少による浮き上がりをなるべく抑える
            accY = math.min(ballStatus.gravityFactor - velocity.y / fixedSec, ballStatus.gravityFactor * timeRate)
        else
            accY = ballStatus.gravityFactor * math.min(settings.maxForceTimeRate, timeRate)
        end
        ball.AddForce(Vector3.__new(0, settings.ballSimMass * accY, 0))
    end
end

local OnUpdateBallEfk = function (trsTime, ballPos, lastPos, deltaSec, velocity, cupSqrDistance, inactive)
    local efkLevel = efkLevelSwitch.GetValue()
    if efkLevel == 5 and ball.IsMine then
        -- レベル 5 で、ボールの操作権があるときは、レベル 6 のエフェクトを表示する
        efkLevel = 6
    end

    if inactive then
        if efkLevel >= 10 then
            local tp = trsTime - settings.ballEfkInactiveMinPeriod
            if tp >= ballStatus.activeTime and tp >= ballStatus.inactiveEfkPlayTime then
                ballStatus.inactiveEfkPlayTime = trsTime

                local dp = Vector3.__new(0, 0, settings.ballSimLongSide * 0.2)
                for i = 1, 20 do
                    local rot = Quaternion.AngleAxis(math.random() * 360, Vector3.__new(math.random(), math.random(), math.random()))
                    ballEfkContainer.SetPosition(ballPos + rot * dp)
                    ballEfkContainer.SetRotation(rot)
                    ballEfkFadeMove.Play()
                end
            end
        end
    else
        if efkLevel >= 9 or (efkLevel >= 6 and not ballStatus.grabbed) then
            local vm = velocity.magnitude
            local vmThreshold = efkLevel >= 9 and settings.ballTrailVelocityElaborateThreshold or settings.ballTrailVelocityThreshold
            if vm >= vmThreshold then
                local near = cupSqrDistance <= settings.ballNearSqrDistance
                local vmNodes = math.max(1, math.ceil(vm / (settings.ballSimLongSide * settings.ballTrailInterpolationDistanceFactor * (near and 0.5 or 1.0) / deltaSec)))
                local nodes = math.min(vmNodes, settings.ballTrailInterpolationNodesPerFrame + cytanb.Clamp(math.floor((efkLevel - 6 + (near and 1 or 0)) * 2), 0, 4))
                local iNodes = 1.0 / nodes
                local efk
                if ballStatus.grabbed then
                    efk = ballEfkFadeFly
                    ballEfkContainer.SetRotation(Quaternion.FromToRotation(Vector3.forward, velocity))
                elseif near then
                    -- 近距離の場合は、エフェクトレベルに合わせる
                    if efkLevel >= 8 then
                        efk = ballEfkFadeMove
                    elseif efkLevel == 7 then
                        efk = ballEfkFade
                    else
                        efk = ballEfk
                    end
                elseif cupSqrDistance >= settings.ballFarSqrDistance then
                    -- 遠距離の場合は、簡易エフェクト
                    efk = ballEfkOne
                else
                    -- それ以外の場合は、通常エフェクト
                    efk = ballEfk
                end

                -- cytanb.LogTrace('ballEfk: nodes = ', nodes, ', vmNodes = ', vmNodes, ', near = ', near, ', efkName = ', efk.EffectName)
                for i = 1, nodes do
                    local trailPos = Vector3.Lerp(lastPos, ballPos, i * iNodes)
                    -- cytanb.LogTrace('  ballEfk lerp: velocity.sqrMagnitude = ', vm, ', lerp nodes = ', nodes, ', trailPos = ', trailPos)
                    ballEfkContainer.SetPosition(trailPos)
                    efk.Play()
                end
            end
        end
    end
end

--- ボールの更新処理をする。カーブさせるための計算をする。
local OnUpdateBall = function (trsTime)
    local ballPos = ball.GetPosition()
    local ballRot = ball.GetRotation()

    if not ballStatus.transformQueue.IsEmpty() then
        local lastTransform = ballStatus.transformQueue.PeekLast()
        local lastPos = lastTransform.position
        local deltaSec = (trsTime - lastTransform.time).TotalSeconds
        local cupSqrDistance = (ballPos - ballCup.GetPosition()).sqrMagnitude

        local outbound = trsTime - settings.ballWaitingTime > ballStatus.throwTime or cupSqrDistance > settings.ballPlayAreaSqrRadius
        if outbound and ball.IsMine and not ballStatus.grabbed and not ballCupStatus.grabbed then
            -- タイムアウトしたかエリア外に出たボールをカップへ戻す。
            cytanb.LogTrace('elapsed: ' , (trsTime - ballStatus.throwTime).TotalSeconds, ', sqrDistance: ', cupSqrDistance)
            RespawnBall()
            return
        end

        local inactive
        if (ballPos - lastPos).sqrMagnitude <= 1E-06 then
            inactive = trsTime - settings.ballInactiveTimeThreshold >= ballStatus.activeTime
        else
            ballStatus.activeTime = trsTime
            inactive = false
        end

        if not outbound and deltaSec > 0 and trsTime - settings.ballRespawnCoolTime > ballStatus.respawnTime then
            -- ボールの前回位置と現在位置から速度を計算する
            local velocity = (ballPos - lastPos) / deltaSec

            if ball.IsMine and not ballStatus.grabbed and not inactive then
                OnUpdateBallTrajectory(ballPos, lastPos, deltaSec, velocity)
            end

            OnUpdateBallEfk(trsTime, ballPos, lastPos, deltaSec, velocity, cupSqrDistance, inactive)
        end
    end

    OfferBallTransform(ballPos, ballRot, trsTime)
end

--- ライトが倒れた判定、復活処理を行う。
local OnUpdateStandLight = function (trsTime)
    local needBuilding = false
    local targets = {}
    for lightName, light in pairs(standLights) do
        local li = light.item
        local ls = light.status
        local horizontalAttitude = li.GetPosition().y >= - settings.standLightSimLongSide and IsHorizontalAttitude(li.GetRotation(), Vector3.up, settings.standLightHorizontalAttitudeThreshold)
        if horizontalAttitude then
            if not ls.active then
                -- 復活した
                cytanb.LogTrace('change [', lightName, '] state to active')
                ls.active = true
            end
        else
            local now = vci.me.Time
            if ls.active then
                -- 倒れたことを検知した
                cytanb.TraceLog('change [', lightName, '] state to inactive')
                ls.active = false
                ls.inactiveTime = now
                if now <= ls.readyInactiveTime + settings.requestIntervalTime then
                    cytanb.TraceLog('  call HitStandLight: ', lightName, ', directHit = ', ls.directHit, ' @OnUpdateStandLight')
                    HitStandLight(light)
                end
            elseif li.IsMine then
                if not ls.buildFlag then
                    -- リスポーンしてから一定時間内に倒れたか、倒れてから時間経過した場合は、復活させる。
                    ls.buildFlag = (now >= ls.respawnTime + settings.standLightMinRebuildTime and now <= ls.respawnTime + settings.standLightMaxRebuildTime) or
                                        (now > ls.inactiveTime + settings.standLightWaitingTime)
                end

                if ls.buildFlag then
                    needBuilding = true
                    targets[light.index] = { name = lightName }
                end
            end
        end
    end

    local unow = vci.me.UnscaledTime
    if unow > standLightsLastRequestTime + settings.requestIntervalTime then
        standLightsLastRequestTime = unow
        if needBuilding then
            cytanb.LogTrace('request buildStandLight')
            cytanb.EmitMessage(buildStandLightMessageName, {targets = targets})
        end
    end
end

local UpdateCw; UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime)
        local trsTime = prevTime
        prevTime = vci.me.Time
        settings.lsp.UpdateAlive()
        settings.statsLsp.UpdateAlive()
        settingsPanelGlue.Update()

        for name, switch in pairs(slideSwitchMap) do
            switch.Update()
        end

        if deltaTime <= TimeSpan.Zero then
            return
        end

        fixedTimestep = timestepEstimater.Update()

        if settingsPanelStatus.gripPressed and trsTime - settings.resetOperationTime > settingsPanelStatus.gripStartTime then
            -- 連続して呼び出されないようにしておく
            settingsPanelStatus.gripStartTime = TimeSpan.MaxValue

            -- 設定パネルのグリップ長押しで、統計情報をリセットする
            ResetStats()
        end

        ProcessStatsCache()

        OnUpdateDiscernibleEfk(trsTime)
        OnUpdateImpactGauge(trsTime, deltaTime)
        OnUpdateBall(trsTime)
        OnUpdateStandLight(trsTime)
    end,

    function ()
        cytanb.LogTrace('OnLoad')
        settings.lsp.UpdateAlive()
        settings.statsLsp.UpdateAlive()
        vciLoaded = true

        local uuid = cytanb.UUIDFromString(cytanb.InstanceID())
        hiddenPosition = Vector3.__new(uuid[1] / 0x100000, 0x1000, uuid[2] / 0x100000)
        cytanb.LogTrace('hiddenPosition: ', hiddenPosition)

        timestepEstimater = cytanb.EstimateFixedTimestep(
            cytanb.NillableValue(vci.assets.GetTransform('timestep-estimater')),
            settings.timestepEstimaterParameter
        )
        fixedTimestep = timestepEstimater.Timestep()
        prevTime = vci.me.Time
        local trsTime = prevTime

        ball = cytanb.NillableValue(vci.assets.GetSubItem(settings.ballName))

        ballEfkContainer = cytanb.NillableValue(vci.assets.GetTransform(settings.ballEfkContainerName))

        local ballEfkMap = cytanb.GetEffekseerEmitterMap(settings.ballEfkContainerName)
        ballEfk = cytanb.NillableValue(ballEfkMap[settings.ballEfkName])
        ballEfkFade = cytanb.NillableValue(ballEfkMap[settings.ballEfkFadeName])
        ballEfkFadeMove = cytanb.NillableValue(ballEfkMap[settings.ballEfkFadeMoveName])
        ballEfkFadeFly = cytanb.NillableValue(ballEfkMap[settings.ballEfkFadeFlyName])
        ballEfkOne = cytanb.NillableValue(ballEfkMap[settings.ballEfkOneName])
        ballEfkOneLarge = cytanb.NillableValue(ballEfkMap[settings.ballEfkOneLargeName])

        ballDiscernibleEfkPlayer = CreateDiscernibleEfkPlayer(
            cytanb.NillableValue(vci.assets.GetEffekseerEmitter(settings.ballName)),
            settings.discernibleEfkMinPeriod
        )

        ballCup = cytanb.NillableValue(vci.assets.GetSubItem(settings.ballCupName))

        currentColorPicker = {
            item = ball,
            status = ballStatus
        }

        colorPickers = {
            [currentColorPicker.item.GetName()] = currentColorPicker
        }

        standLights = {}
        for i = 1, settings.standLightCount do
            local index = i - 1
            local name = settings.standLightPrefix .. index .. '#'
            local item = cytanb.NillableValue(vci.assets.GetSubItem(name))
            local pos = item.GetPosition()
            local entry = {
                item = item,
                index = index,
                status = cytanb.Extend(cytanb.Extend({}, standLightInitialStatus), {
                    respawnPosition = Vector3.__new(pos.x, math.max(pos.y, settings.standLightSimLongSide), pos.z),
                    respawnTime = trsTime,
                    grabbed = false,
                })
            }
            standLights[name] = entry
            colorPickers[name] = entry
        end

        standLightEfkContainer = cytanb.NillableValue(vci.assets.GetTransform(settings.standLightEfkContainerName))

        local standLightEfkMap = cytanb.GetEffekseerEmitterMap(settings.standLightEfkContainerName)
        standLightHitEfk = cytanb.NillableValue(standLightEfkMap[settings.standLightHitEfkName])
        standLightDirectHitEfk = cytanb.NillableValue(standLightEfkMap[settings.standLightDirectHitEfkName])

        impactForceGauge = cytanb.NillableValue(vci.assets.GetTransform(settings.impactForceGaugeName))
        impactForceGauge.SetPosition(hiddenPosition)

        impactSpinGauge = cytanb.NillableValue(vci.assets.GetTransform(settings.impactSpinGaugeName))
        impactSpinGauge.SetPosition(hiddenPosition)

        settingsPanel = cytanb.NillableValue(vci.assets.GetSubItem(settings.settingsPanelName))
        settingsPanelGlue = cytanb.CreateSubItemGlue()

        closeSwitch = cytanb.NillableValue(vci.assets.GetSubItem(settings.closeSwitchName))
        settingsPanelGlue.Add(cytanb.NillableValue(vci.assets.GetTransform(settings.closeSwitchBaseName)), closeSwitch)

        slideSwitchMap = {}
        for k, parameters in pairs(settings.switchParameters) do
            local switch = cytanb.CreateSlideSwitch(
                cytanb.Extend({
                    colliderItem = cytanb.NillableValue(vci.assets.GetSubItem(parameters.colliderName)),
                    baseItem = cytanb.NillableValue(vci.assets.GetTransform(parameters.baseName)),
                    knobItem = cytanb.NillableValue(vci.assets.GetTransform(parameters.knobName)),
                    lsp = settings.lsp
                }, parameters, false, true)
            )

            if settings.enableDebugging then
                switch.AddListener(function (source, value)
                    cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
                end)
            end

            slideSwitchMap[parameters.colliderName] = switch
        end

        velocitySwitch = cytanb.NillableValue(slideSwitchMap[settings.velocitySwitchName])
        angularVelocitySwitch = cytanb.NillableValue(slideSwitchMap[settings.angularVelocitySwitchName])
        altitudeSwitch = cytanb.NillableValue(slideSwitchMap[settings.altitudeSwitchName])
        throwingAdjustmentSwitch = cytanb.NillableValue(slideSwitchMap[settings.throwingAdjustmentSwitchName])
        gravitySwitch = cytanb.NillableValue(slideSwitchMap[settings.gravitySwitchName])
        efkLevelSwitch = cytanb.NillableValue(slideSwitchMap[settings.efkLevelSwitchName])
        audioVolumeSwitch = cytanb.NillableValue(slideSwitchMap[settings.audioVolumeSwitchName])

        efkLevelSwitch.AddListener(function (source, value)
            SetDiscernibleColor(ballDiscernibleEfkPlayer.GetColor())
        end)

        ballStatus.gravityFactor = CalcGravityFactor()

        settings.statsLsp.AddListener(function (source, key, value, oldValue)
            if key == cytanb.LOCAL_SHARED_PROPERTY_EXPIRED_KEY then
                -- cytanb.LogTrace('statsLsp: expired')
                vciLoaded = false
            end
        end)

        local updateStatus = function (parameterMap)
            if parameterMap.discernibleColor then
                SetDiscernibleColor(parameterMap.discernibleColor)
            end

            if parameterMap.standLights then
                for i, lightParameter in pairs(parameterMap.standLights) do
                    cytanb.NillableIfHasValue(standLights[lightParameter.name], function (light)
                        local ls = light.status
                        if lightParameter.respawnPosition then
                            cytanb.Extend(ls, standLightInitialStatus)
                            ls.respawnPosition = lightParameter.respawnPosition
                            ls.respawnTime = trsTime
                        end
                    end)
                end
            end
        end

        -- 全 VCI からのクエリーに応答する。
        -- マスターが交代したときのことを考慮して、全ユーザーが OnMessage で登録する。
        cytanb.OnMessage(queryStatusMessageName, function (sender, name, parameterMap)
            if not vci.assets.IsMine then
                -- マスターでなければリターンする。
                return
            end

            cytanb.LogDebug('onQueryStatus')

            local standLightsParameter = {}
            for lightName, light in pairs(standLights) do
                standLightsParameter[light.index] = CreateStandLightStatusParameter(light)
            end

            cytanb.EmitMessage(statusMessageName, {
                clientID = cytanb.ClientID(),
                discernibleColor = cytanb.ColorToTable(ballDiscernibleEfkPlayer.GetColor()),
                ball = CreateBallStatusParameter(),
                standLights = standLightsParameter
            })
        end)

        cytanb.OnMessage(statusMessageName, function (sender, name, parameterMap)
            if parameterMap[cytanb.InstanceIDParameterName] == cytanb.InstanceID() then
                if parameterMap.clientID ~= cytanb.ClientID() then
                    -- インスタンスの設置者から状態通知が来たので、ローカルの値を更新する
                    cytanb.LogDebug('onStatus @instance')
                    updateStatus(parameterMap)
                end
            else
                -- 他のインスタンスの識別色を収集する
                if vci.assets.IsMine and not discernibleColorStatus.initialized and vci.me.UnscaledTime <= discernibleColorStatus.checkRequestedTime + settings.requestIntervalTime then
                    if parameterMap.discernibleColor and parameterMap.discernibleColor.a > 0.0 then
                        local colorIndex = cytanb.ColorToIndex(parameterMap.discernibleColor)
                        cytanb.LogDebug('onStatus @other: colorIndex = ', colorIndex, ', discernibleColor = ', parameterMap.discernibleColor)
                        discernibleColorStatus.existentIndexTable[colorIndex] = true
                    end
                end
            end
        end)

        cytanb.OnInstanceMessage(statusChangedMessageName, function (sender, name, parameterMap)
            if parameterMap.clientID ~= cytanb.ClientID() then
                cytanb.LogDebug('onStatusChanged')
                updateStatus(parameterMap)
            end
        end)

        cytanb.OnInstanceMessage(respawnBallMessageName, function (sender, name, parameterMap)
            RespawnBall()
        end)

        -- ライトを組み立てる。
        cytanb.OnInstanceMessage(buildStandLightMessageName, function (sender, name, parameterMap)
            cytanb.LogDebug('onBuildStandLight')

            local targets = parameterMap.targets
            if targets then
                for i, lightParameter in pairs(targets) do
                    cytanb.NillableIfHasValue(standLights[lightParameter.name], function (light)
                        BuildStandLight(light)
                    end)
                end
            end
        end)

        -- 全てのライトを組み立てる。別 VCI から送られてくるケースも考慮する。
        cytanb.OnMessage(buildAllStandLightsMessageName, function (sender, name, parameterMap)
            for lightName, light in pairs(standLights) do
                BuildStandLight(light)
            end
        end)

        -- ターゲットにヒットした。別 VCI から送られてくるケースも考慮する。
        cytanb.OnMessage(hitMessageName, function (sender, name, parameterMap)
            local source = parameterMap.source
            if not source.position then
                return
            end

            cytanb.NillableIfHasValue(standLights[parameterMap.target.name], function (light)
                local li = light.item
                local ls = light.status
                local now = vci.me.Time
                if IsContactWithTarget(source.position, source.longSide or 0.5, li.GetPosition(), settings.standLightSimLongSide) and now > ls.hitMessageTime + settings.requestIntervalTime then
                    -- 自 VCI のターゲットにヒットした
                    cytanb.LogTrace('onHitMessage: ', li.GetName())
                    ls.hitMessageTime = now
                    ls.hitSourceID = source.hitSourceID
                    ls.directHit = parameterMap.directHit

                    if ls.active then
                        -- ライトが倒れていないので、レディ状態をセットする
                        cytanb.LogTrace('ready inactive: ', li.GetName(), ', directHit = ', ls.directHit)
                        ls.readyInactiveTime = now

                        if li.IsMine and not ls.grabbed and parameterMap.hitSourceID ~= cytanb.ClientID() then
                            -- ライトの操作権があり、メッセージのクライアントIDが自身のIDと異なる場合は、ソースの操作権が別ユーザーであるため、自力で倒れる
                            local hitVelocity
                            local sourceVelocity = source.velocity or Vector3.zero
                            local horzSqrMagnitude = sourceVelocity.x ^ 2 + sourceVelocity.y ^ 2
                            cytanb.LogTrace(' horzSqrMagnitude = ', horzSqrMagnitude, ', source.velocity = ', source.velocity)
                            if horzSqrMagnitude > 0.0025 then
                                local horzMagnitude = math.sqrt(horzSqrMagnitude)
                                local im = cytanb.Clamp(horzMagnitude, settings.standLightMinHitMagnitude, settings.standLightMaxHitMagnitude) / horzMagnitude
                                hitVelocity = Vector3.__new(sourceVelocity.x * im, cytanb.Clamp(sourceVelocity.y, settings.standLightMinHitMagnitudeY, settings.standLightMaxHitMagnitudeY), sourceVelocity.z * im)
                                cytanb.LogTrace(li.GetName(), ' self-hit: source, hit velocity = ', hitVelocity)
                            else
                                local rx = math.random()
                                local dx = (rx * 2 >= 1 and 1 or -1) * (rx * (settings.standLightMaxHitMagnitude - settings.standLightMinHitMagnitude) * 0.5 + settings.standLightMinHitMagnitude)
                                local rz = math.random()
                                local dz = (rz * 2 >= 1 and 1 or -1) * (rz * (settings.standLightMaxHitMagnitude - settings.standLightMinHitMagnitude) * 0.5 + settings.standLightMinHitMagnitude)
                                local dy = math.random() * (settings.standLightMaxHitMagnitudeY - settings.standLightMinHitMagnitudeY) + settings.standLightMinHitMagnitudeY
                                hitVelocity = Vector3.__new(dx, dy, dz)
                                cytanb.LogTrace(li.GetName(), ' self-hit: random, hit velocity = ', hitVelocity)
                            end

                            local sourceMass = source.mass > 0 and math.min(settings.standLightSimMass * settings.standLightMaxHitMassFactor, source.mass) or settings.standLightSimMass
                            li.AddForce(hitVelocity * (sourceMass / fixedTimestep.TotalSeconds))
                        end
                    else
                        HitStandLight(light)
                    end
                end
            end)
        end)

        cytanb.OnInstanceMessage(throwingStatsMessageName, function (sender, name, parameterMap)
            cytanb.NillableIfHasValue(parameterMap.stats, function (stats)
                print(StatsToString(stats))
            end)
        end)

        -- 設定パネルを表示する
        cytanb.OnInstanceMessage(showSettingsPanelMessageName, function (sender, name, parameterMap)
            if not settingsPanel.IsMine then
                return
            end

            local cupPosition = ballCup.GetPosition()
            local dp = cupPosition - settingsPanel.GetPosition()
            if dp.magnitude > settings.settingsPanelDistanceThreshold then
                -- 設定パネルが離れていた場合は、近づけて表示する。
                local position = cupPosition + settings.settingsPanelOffset
                cytanb.LogTrace('ShowSettingsPanel: posotion = ', position)
                settingsPanel.SetPosition(position)
                settingsPanel.SetRotation(Quaternion.LookRotation(Vector3.__new(- settings.settingsPanelOffset.x, 0, - settings.settingsPanelOffset.z)))
            elseif Vector3.Angle(settingsPanel.GetForward(), dp) > settings.settingsPanelAngleThreshold then
                -- 設定パネルが近い位置にあり、角度に開きがある場合は、回転させる。
                cytanb.LogTrace('ShowSettingsPanel: rotate')
                settingsPanel.SetRotation(Quaternion.LookRotation(Vector3.__new(dp.x, 0, dp.z)))
            end
        end)

        cytanb.OnMessage(colorPaletteItemStatusMessageName, function (sender, name, parameterMap)
            if currentColorPicker.item.IsMine and discernibleColorStatus.paletteCollisionCount >= 1 then
                if currentColorPicker.status.grabbed and vci.me.UnscaledTime <= discernibleColorStatus.paletteCollisionTime + settings.requestIntervalTime then
                    discernibleColorStatus.paletteCollisionCount = discernibleColorStatus.paletteCollisionCount - 1
                    SetDiscernibleColor(cytanb.ColorFromARGB32(parameterMap.argb32))
                    cytanb.EmitMessage(statusChangedMessageName, CreateDiscernibleColorParameter())
                else
                    discernibleColorStatus.paletteCollisionCount = 0
                end
            end
        end)

        if vci.assets.IsMine then
            cytanb.EmitMessage(showSettingsPanelMessageName)
            discernibleColorStatus.checkRequestedTime = vci.me.UnscaledTime
        end
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

    if target == ballCup.GetName() then
        ballCupStatus.grabbed = true
        ballStatus.gravityFactor = CalcGravityFactor()
        ballCupStatus.grabClickCount, ballCupStatus.grabClickTime = cytanb.DetectClicks(ballCupStatus.grabClickCount, ballCupStatus.grabClickTime)
        if ballCupStatus.grabClickCount == 2 then
            cytanb.EmitMessage(respawnBallMessageName)
        elseif ballCupStatus.grabClickCount == 3 then
            cytanb.EmitMessage(buildAllStandLightsMessageName)
        elseif ballCupStatus.grabClickCount == 4 then
            cytanb.EmitMessage(showSettingsPanelMessageName)
        end
    elseif target == ball.GetName() then
        ballStatus.grabbed = true
        ball.SetVelocity(Vector3.zero)
        ball.SetAngularVelocity(Vector3.zero)
        ResetGauge()
        ballStatus.transformQueue.Clear()
        ballDiscernibleEfkPlayer.Stop()
    elseif target == settingsPanel.GetName() then
        settingsPanelStatus.grabbed = true
    else
        cytanb.NillableIfHasValue(standLights[target], function (light)
            light.status.grabbed = true
        end)

        cytanb.NillableIfHasValue(slideSwitchMap[target], function (switch)
            switch.DoGrab()
        end)
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    if target == ballCup.GetName() then
        ballCupStatus.grabbed = false
        ResetBallCup()
    elseif target == ball.GetName() then
        if ballStatus.grabbed then
            ballStatus.grabbed = false
            if ball.IsMine then
                ballStatus.throwTime = prevTime
                ballStatus.boundCount = 0

                if impactStatus.phase == 3 then
                    -- タイミング入力の最終フェーズのときに、ボールを離した場合は、タイミング入力による投球を行う。
                    ThrowBallByInputTiming(prevTime)
                else
                    -- それ以外の場合は、腕を振って投球する。タイミング入力の途中のフェーズで手を離した場合は、キャンセルしたとみなす。
                    ThrowBallByKinematic(prevTime)
                end
            end
            impactStatus.gaugeStartTime = vci.me.Time
        end
    elseif target == settingsPanel.GetName() then
        settingsPanelStatus.grabbed = false
    else
        cytanb.NillableIfHasValue(standLights[target], function (light)
            cytanb.LogTrace('ungrab ', target)
            local li = light.item
            local ls = light.status

            cytanb.Extend(ls, standLightInitialStatus)
            ls.respawnTime = vci.me.Time
            ls.grabbed = false

            if li.IsMine then
                -- リスポーン位置を送信する
                local pos = li.GetPosition()
                local ry = settings.standLightSimLongSide * 0.5 + math.random(settings.standLightSimLongSide * 1.5)
                ls.respawnPosition = pos.y >= ry and pos or Vector3.__new(pos.x, ry, pos.z)

                cytanb.LogTrace('emit StatusChanged: ', li.GetName(), ': respawnPosition = ', ls.respawnPosition)
                cytanb.EmitMessage(statusChangedMessageName, {
                    clientID = cytanb.ClientID(),
                    standLights = {
                        [light.index] = {
                            name = li.GetName(),
                            respawnPosition = cytanb.Vector3ToTable(ls.respawnPosition)
                        }
                    }
                })
            end
        end)

        cytanb.NillableIfHasValue(slideSwitchMap[target], function (switch)
            switch.DoUngrab()
        end)
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == ball.GetName() then
        ballStatus.gripPressed = true
        ballStatus.gripStartTime = vci.me.Time
        if ballStatus.grabbed and impactStatus.phase >= 1 and impactStatus.phase < 3 then
            -- タイミング入力のフェーズを進行する。
            impactStatus.phase = impactStatus.phase + 1
            impactStatus.gaugeStartTime = vci.me.Time
        end
    elseif use == ballCup.GetName() then
        ballCupStatus.clickCount, ballCupStatus.clickTime = cytanb.DetectClicks(ballCupStatus.clickCount, ballCupStatus.clickTime)
        cytanb.LogTrace('cupClickCount = ', ballCupStatus.clickCount)

        if ballCupStatus.clickCount == 1 then
            cytanb.EmitMessage(respawnBallMessageName)
        elseif ballCupStatus.clickCount == 2 then
            cytanb.EmitMessage(buildAllStandLightsMessageName)
        elseif ballCupStatus.clickCount == 3 then
            cytanb.EmitMessage(showSettingsPanelMessageName)
        end
    elseif use == closeSwitch.GetName() then
        if not settingsPanelStatus.grabbed and settingsPanel.IsMine then
            settingsPanel.SetPosition(hiddenPosition)
        end
    elseif use == settingsPanel.GetName() then
        settingsPanelStatus.gripPressed = true
        settingsPanelStatus.gripStartTime = vci.me.Time
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

    if use == ball.GetName() then
        ballStatus.gripPressed = false
    elseif use == settingsPanel.GetName() then
        settingsPanelStatus.gripPressed = false
    else
        cytanb.NillableIfHasValue(slideSwitchMap[use], function (switch)
            switch.DoUnuse()
        end)
    end
end

local OnCollisionOrTriggerEnter = function (item, hit, collision)
    if item == ball.GetName() then
        if ball.IsMine and not ballStatus.grabbed then
            local tagMap, hitBaseName = cytanb.ParseTagString(hit)
            if cytanb.NillableHasValue(tagMap[settings.targetTag]) then
                EmitHitBall(hit, hitBaseName)
            elseif collision and not avatarColliderMap[hit] then
                -- ライトかアバターのコライダー以外に衝突した場合は、カウントアップする
                ballStatus.boundCount = ballStatus.boundCount + 1
                cytanb.LogTrace('ball bounds: hit = ', hit, ', boundCount = ', ballStatus.boundCount)
                if ballStatus.boundCount == 1 then
                    local hpos = ball.GetPosition()
                    hpos.y = statsCache.throwingPosition.y
                    cytanb.LogTrace('ball bounds: horizontal distance = ', cytanb.Round(Vector3.Distance(hpos, statsCache.throwingPosition), 2), ' [m]')
                end
            end
        end
    else
        cytanb.NillableIfHasValue(standLights[item], function (light)
            if light.item.IsMine and not light.status.grabbed then
                if cytanb.NillableHasValue(cytanb.ParseTagString(hit)[settings.targetTag]) then
                    EmitHitStandLight(light, hit)
                end
            end
        end)
    end

    cytanb.NillableIfHasValue(colorPickers[item], function (picker)
        if picker.item.IsMine and string.startsWith(hit, settings.colorIndexNamePrefix) then
            local now = vci.me.UnscaledTime
            if discernibleColorStatus.paletteCollisionCount >= 1 and now > discernibleColorStatus.paletteCollisionTime + settings.requestIntervalTime then
                -- 期限が切れていた場合は、カウンターをリセットする。
                discernibleColorStatus.paletteCollisionCount = 0
            end
            discernibleColorStatus.paletteCollisionCount = discernibleColorStatus.paletteCollisionCount + 1
            discernibleColorStatus.paletteCollisionTime = now
            currentColorPicker = picker
            cytanb.TraceLog('colorPaletteCollisionCount = ', discernibleColorStatus.paletteCollisionCount, ' hit = ', hit)
        end
    end)
end

onCollisionEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    OnCollisionOrTriggerEnter(item, hit, true)
end

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    OnCollisionOrTriggerEnter(item, hit, false)
end
