-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end
local GetGameObjectTransform = function (name) return assert(vci.assets.GetTransform(name)) end

local settings = {
    jointBaseName = 'family_doll_joint',
    jointTag = 'cytanb-joint',
    jointMat = 'family_doll_joint_mat',
    jointColor = Color.__new(1.0, 1.0, 0.5, 0.25),
    transparentColor = Color.__new(0, 0, 0, 0),

    characterRootName = 'oo_hands_character',

    -- ボーン名のリスト。先頭要素はルートとして、特別に扱われる。
    boneNameList = {
        --'oo_hands_character',
        'Head',
        'LeftUpperArm',
        'RightUpperArm',
        'LeftLowerArm',
        'RightLowerArm',
        'LeftHand',
        'RightHand',
        'LeftLowerLeg',
        'RightLowerLeg'
    },

    blendShapeNameMap = {
        joy = 'bs_joy',
        fun = 'bs_fun',
        angry = 'bs_angry',
        sorrow = 'bs_sorrow'
    },

    operatorColliderMap = cytanb.ListToMap({
        'HandPointMarker',
        'LeftHand',
        'RightHand'
    }),

    -- operatorBoneNameList = {'LeftHand', 'RightHand'},
    -- operatorSqrDistance = 0.3 ^ 2,

    jointDisplayDuration = TimeSpan.FromSeconds(5),
    longPressTime = TimeSpan.FromSeconds(1),
    emotionInterval = TimeSpan.FromSeconds(3),
    emotionRatio = 0.75,
    enableDebugging = false
}

local vciLoaded = false

-- local operatorAvatar = cytanb.NillableValue(vci.studio.GetLocalAvatar())
-- local lastOperatorEntered = false
local characterRoot
local jointMap

--- @class operatorStatus
local operatorStatus = {
    entered = false,
    enteredTime = TimeSpan.Zero,
    lastEmotionTime = TimeSpan.Zero,
}

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local JointName = function (boneName)
    return settings.jointBaseName .. '#' .. settings.jointTag .. '=' .. boneName
end

local ResetJoint = function (joint)
    joint.bone.SetLocalRotation(Quaternion.identity)
end

local ResetAllJoints = function (joints)
    for name, joint in pairs(joints) do
        ResetJoint(joint)
    end
end

local SetJointColor = function (operatorEntered)
    vci.assets.material.SetColor(
        settings.jointMat,
        operatorEntered and settings.jointColor or settings.transparentColor
    )
end

--- @param status operatorStatus
local UpdateOperatorStatus = function (status, entered)
    if entered then
        status.enteredTime = vci.me.UnscaledTime
        if not status.entered then
            status.entered = entered
            SetJointColor(entered)
        end
    else
        if status.entered and
            vci.me.UnscaledTime - settings.jointDisplayDuration > status.enteredTime
        then
            -- 表示時間を過ぎた場合は、更新を行う
            status.entered = entered
            SetJointColor(entered)
        end
    end
end

local UpdateCw; UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        if deltaTime <= TimeSpan.Zero then
            return
        end

        local operator = characterRoot.IsMine

        -- local operatorBonePositionMap = {}
        -- for i, name in ipairs(settings.operatorBoneNameList) do
        --     cytanb.NillableIfHasValue(operatorAvatar.GetBoneTransform(name), function (bt)
        --         operatorBonePositionMap[name] = bt.position
        --     end)
        -- end

        local operatorEntered = false

        for name, joint in pairs(jointMap) do
            local jointPos = joint.item.GetPosition()
            local jointRot = joint.item.GetRotation()

            -- ジョイントの位置に、オペレーターが近づいたかを調べる。
            -- if not operatorEntered then
            --     for name, position in pairs(operatorBonePositionMap) do
            --         operatorEntered = (jointPos - position).sqrMagnitude <= settings.operatorSqrDistance
            --     end
            -- end

            local operating = operator and joint.grabbed
            if operating then
                -- ジョイントをつかんでいた場合は、操作を継続している
                operatorEntered = operatorEntered or operating
            elseif joint.grabbed then
                joint.grabbed = false
            end

            local bonePos = joint.bone.GetPosition()
            local boneRot = joint.bone.GetRotation()
            if not cytanb.VectorApproximatelyEquals(jointPos, bonePos) or
                not cytanb.QuaternionApproximatelyEquals(jointRot, boneRot)
            then
                if not operator or joint.grabbed then
                    -- ポジションを変更しないため、つかんだサブアイテムの位置を、
                    -- 前フレームの位置をセットすることで固定する。
                    -- (`GetPosition()` が前フレームの位置を返すことを利用)
                    joint.item.SetPosition(jointPos)

                    joint.bone.SetRotation(jointRot)
                else
                    joint.item.SetPosition(bonePos)
                    joint.item.SetRotation(boneRot)
                end
            end

            -- グリップの長押しでリセットする
            if operator and joint.gripPressed and
                vci.me.UnscaledTime - settings.longPressTime > joint.gripStartTime
            then
                joint.gripStartTime = TimeSpan.MaxValue

                cytanb.LogTrace('Reset joint: ', joint.name)
                ResetJoint(joint)
            end
        end

        -- if operatorEntered ~= lastOperatorEntered then
        --     lastOperatorEntered = operatorEntered
        --     SetJointColor(operatorEntered)
        -- end

        UpdateOperatorStatus(operatorStatus, operatorEntered)
    end,

    function ()
        characterRoot = GetSubItem(settings.characterRootName)

        jointMap = {}
        for i, boneName in ipairs(settings.boneNameList) do
            local name = JointName(boneName)
            cytanb.NillableIfHasValue(vci.assets.GetSubItem(name), function (item)
                local joint = {
                    name = name,
                    item = item,
                    bone = GetGameObjectTransform(boneName),
                    grabbed = false,
                    gripPressed = false,
                    gripStartTime = TimeSpan.Zero
                }
                jointMap[name] = joint
            end)
        end

        cytanb.LogTrace('OnLoad')
        vciLoaded = true
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

    cytanb.NillableIfHasValue(jointMap[target], function (joint)
        cytanb.LogTrace('Grabbed: ', joint.name)
        joint.grabbed = true
    end)
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    cytanb.NillableIfHasValue(jointMap[target], function (joint)
        cytanb.LogTrace('Ungrabbed: ', joint.name)
        joint.grabbed = false
    end)
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    cytanb.NillableIfHasValue(jointMap[use], function (joint)
        joint.gripPressed = true
        joint.gripStartTime = vci.me.UnscaledTime
    end)
end

onUnuse = function (use)
    if not vciLoaded then
        return
    end

    cytanb.NillableIfHasValue(jointMap[use], function (joint)
        joint.gripPressed = false
    end)
end

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    cytanb.NillableIfHasValue(cytanb.ParseTagString(item)[settings.jointTag], function (jointTagValue)
        cytanb.NillableIfHasValue(settings.operatorColliderMap[hit], function (operatorCollider)
            UpdateOperatorStatus(operatorStatus, true)
        end)

        if jointTagValue == 'Head' then
            local now = vci.me.UnscaledTime
            if operatorStatus.lastEmotionTime + settings.emotionInterval <= now then
                operatorStatus.lastEmotionTime = now

                local clipName = math.random() <= settings.emotionRatio and settings.blendShapeNameMap.joy or settings.blendShapeNameMap.fun
                vci.assets._ALL_PlayAnimationFromName(clipName, false)
            end
        end
    end)
end
