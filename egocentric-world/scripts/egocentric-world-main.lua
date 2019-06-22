----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

-- エレベーターのアニメーション時間。+1 秒はマージン。
local EGO_ELEVATOR_ANIM_TIME = TimeSpan.FromSeconds(10 + 1)
local EGO_ELEVATOR_ANIM_WAIT_TIME = TimeSpan.FromSeconds(1)

-- 世界を上昇させるアニメーションの、開始キーフレームのオブジェクト位置。
local EGO_WORLD_RISE_ANIM_START_POSITION = Vector3.__new(0.0, -30, 0.0)

local EGO_BASKET_SWITCH_NORMAL_COLOR = Color.__new(0.8, 0.8, 0.25)
local EGO_BASKET_SWITCH_ELEVATING_COLOR = Color.__new(0.8, 0.25, 0.25)
local EGO_BASKET_SWITCH_DARK_COLOR = Color.__new(0.25, 0.25, 0.25)
local EGO_BASKET_SWITCH_MATERIAL_NAME = "ego_basket_switch"

-- ゼロ地点を確認するためのコーン。
local zero_cone = vci.assets.GetSubItem("zero_cone")

local ego_set = vci.assets.GetSubItem("ego_set")
local ego_world_wrapper = vci.assets.GetSubItem("ego_world_wrapper")
local ego_world = vci.assets.GetSubItem("ego_world")

local worldState = 0
local waitingForNextState = false;
local elevatorAnimStartTime = TimeSpan.MinValue
local elevatorAnimWaitTime = TimeSpan.MinValue

-- アイテムを設置したときの初期化処理
if vci.assets.IsMine then
    vci.state.Set("worldState", worldState)
    vci.assets._ALL_SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_NORMAL_COLOR)

    zero_cone.SetPosition(Vector3.zero)
    zero_cone.SetRotation(Quaternion.identity)

    -- Y座標の位置だけを、ゼロにする。
    local position = ego_set.GetPosition()
    position.y = 0
    ego_set.SetPosition(position)
    ego_set.SetRotation(Quaternion.identity)
end

local function delaySyncWorldPosition()
    if ego_set.IsMine then
        if elevatorAnimWaitTime < TimeSpan.Zero then
            elevatorAnimWaitTime = vci.me.Time
        elseif (elevatorAnimWaitTime < TimeSpan.MaxValue) and (vci.me.Time >= elevatorAnimWaitTime + EGO_ELEVATOR_ANIM_WAIT_TIME) then
            -- 待機時間を経過したので、停止位置を全ユーザーに同期させる。
            print("sync world position")
            elevatorAnimWaitTime = TimeSpan.MaxValue

            local position = ego_world_wrapper.GetLocalPosition() + ego_world.GetLocalPosition()
            ego_world_wrapper.SetLocalPosition(Vector3.zero)
            ego_world.SetLocalPosition(position)
        end
    end
end

local function resetWorldPosition()
    elevatorAnimStartTime = TimeSpan.MinValue
    elevatorAnimWaitTime = TimeSpan.MinValue
    vci.assets.StopAnimation()
    if ego_world_wrapper.GetLocalPosition() ~= Vector3.zero then
        ego_world_wrapper.SetLocalPosition(Vector3.zero)
    end
    if ego_world.GetLocalPosition() then
        ego_world.SetLocalPosition(Vector3.zero)
    end
    vci.assets.SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_NORMAL_COLOR)
end

-- 全ユーザーで、毎フレーム呼び出される。
function updateAll()
    local newState = vci.state.Get("worldState")
    if (newState == nil) then
        return
    end

    local stateChanged = newState ~= worldState
    worldState = newState

    if waitingForNextState then
        if stateChanged then
            -- 次の状態へ移行したので、待機フラグをクリアする
            waitingForNextState = false
        else
            -- 次の状態へ移行するのを待っている
            return
        end
    end

    if worldState == 0 then
        -- 初期位置で停止している状態
        if stateChanged then
            resetWorldPosition()
        end
        delaySyncWorldPosition()
    elseif worldState == 1 then
        if stateChanged then
            elevatorAnimStartTime = TimeSpan.MinValue
            elevatorAnimWaitTime = vci.me.Time
            vci.assets.SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_DARK_COLOR)
        end

        if elevatorAnimStartTime < TimeSpan.Zero then
            -- スイッチが押され、世界を下降させるアニメーションを開始するまでの、待機状態。

            if vci.me.Time >= elevatorAnimWaitTime + EGO_ELEVATOR_ANIM_WAIT_TIME then
                -- 待機時間を経過したので、世界を下降させるアニメーション開始。(カゴが上昇しているように見える)
                print("play anim: world-fall")
                elevatorAnimStartTime = vci.me.Time
                vci.assets.SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_ELEVATING_COLOR)
                vci.assets.PlayAnimationFromName("world-fall", false)
            end
        elseif vci.me.Time >= elevatorAnimStartTime + EGO_ELEVATOR_ANIM_TIME then
           print("world-fall anim finished.")
           elevatorAnimStartTime = TimeSpan.MinValue
           elevatorAnimWaitTime = TimeSpan.MinValue
           waitingForNextState = true
           if ego_set.IsMine then
               vci.state.Set("worldState", 3)
           end
           vci.assets.SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_NORMAL_COLOR)
       end
    elseif worldState == 2 then
        -- 世界を下降させるアニメーションを、緊急停止した状態。
        if stateChanged then
            print("emergency stop world-fall anim.")
            elevatorAnimStartTime = TimeSpan.MinValue
            elevatorAnimWaitTime = TimeSpan.MinValue
            vci.assets.StopAnimation()
            vci.assets.SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_NORMAL_COLOR)
        end
        delaySyncWorldPosition()
    elseif worldState == 3 then
        -- 世界を下降させるアニメーションが完了して、停止している状態。
        delaySyncWorldPosition()
    elseif worldState == 4 then
        if stateChanged then
            elevatorAnimStartTime = TimeSpan.MinValue
            elevatorAnimWaitTime = vci.me.Time
            vci.assets.SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_DARK_COLOR)
        end

        if elevatorAnimStartTime < TimeSpan.Zero then
            -- スイッチが押され、世界を上昇させるアニメーションを開始するまでの、待機状態。

            if vci.me.Time >= elevatorAnimWaitTime + EGO_ELEVATOR_ANIM_WAIT_TIME then
                -- 待機時間を経過したので、世界を上昇させるアニメーション開始。(カゴが下降しているように見える)
                print("play anim: world-rise")
                elevatorAnimStartTime = vci.me.Time
                vci.assets.SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_ELEVATING_COLOR)

                local position = ego_world.GetLocalPosition() - EGO_WORLD_RISE_ANIM_START_POSITION
                if ego_world_wrapper.GetLocalPosition() ~= position then
                    -- アニメーションの開始時のオブジェクト位置を、wrapper に設定することで、疑似的に現在の位置から開始するように見せる
                    ego_world_wrapper.SetLocalPosition(position)
                end
                vci.assets.PlayAnimationFromName("world-rise", false)
            end
        elseif vci.me.Time >= elevatorAnimStartTime + EGO_ELEVATOR_ANIM_TIME then
            print("world-rise anim finished.")
            elevatorAnimStartTime = TimeSpan.MinValue
            elevatorAnimWaitTime = TimeSpan.MinValue
            waitingForNextState = true
            if ego_set.IsMine then
                vci.state.Set("worldState", 0)
            end
            vci.assets.SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_NORMAL_COLOR)
        elseif (ego_world_wrapper.GetLocalPosition() + ego_world.GetLocalPosition()).y >= -0.1 then
            -- 世界を上昇中に、地面に近づいたので、アニメーションを停止させる。
            -- (途中位置から上昇させた場合は、地面を越えてしまうので対策)
            print("stop world-rise anim: position rised near the ground.")
            resetWorldPosition()
            waitingForNextState = true
            if ego_set.IsMine then
                vci.state.Set("worldState", 0)
            end
        end
    elseif worldState == 5 then
        -- 世界を上昇させるアニメーションを、緊急停止した状態。
        if stateChanged then
            print("emergency stop world-rise anim.")
            elevatorAnimStartTime = TimeSpan.MinValue
            elevatorAnimWaitTime = TimeSpan.MinValue
            vci.assets.StopAnimation()
            vci.assets.SetMaterialColorFromName(EGO_BASKET_SWITCH_MATERIAL_NAME, EGO_BASKET_SWITCH_NORMAL_COLOR)
        end
        delaySyncWorldPosition()
    end
end

-- グリップしてアイテムを使用すると呼び出される。
function onUse(use)
    print("onUse: " .. use)

    if use == "ego_set" then
        -- スイッチが使用された。
        if worldState == 2 then
            vci.state.Set("worldState", 4)
        elseif worldState >= 5 then
            -- 世界の上昇中に緊急停止した状態で、再度スイッチを使用した状態。世界をゼロ地点にリセットする。
            print("reset world position.")
            resetWorldPosition()
            vci.state.Set("worldState", 0)
        else
            vci.state.Set("worldState", worldState + 1)
        end
    end
end
