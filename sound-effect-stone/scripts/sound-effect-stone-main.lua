-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

local blue_stone_name = 'blue-stone'
local green_stone_name = 'green-stone'
local green_audio_source_name = 'green-stone-audio-source'
local green_audio_total_time = TimeSpan.FromSeconds(6)
local green_audio_throttle_time = TimeSpan.FromMilliseconds(100)

local locus_velocity = Vector3.__new(0, 1.2, 0)
local locus_rotation_axis = Vector3.down
local locus_rotation_angle_per_sec = math.deg(5.25)
local locus_head_position = Vector3.__new(1, 0, 0)

local blue_stone = assert(vci.assets.GetSubItem(blue_stone_name))
local green_stone = assert(vci.assets.GetSubItem(green_stone_name))
local green_audio_source = assert(
    vci.assets.GetTransform(green_audio_source_name)
)

local ripple_se = assert(blue_stone.GetAudioSources()[1])
local locus_se = assert(green_audio_source.GetAudioSources()[1])

local ripple_efk = vci.assets.GetEffekseerEmitter(blue_stone_name)
local locus_efk = vci.assets.GetEffekseerEmitter(green_stone_name)

local message_ns = 'com.github.oocytanb.oO-vci-pack.cytanb-sound-effect-stone'
local play_locus_message_name = message_ns .. '.play_locus'

local green_start_time = TimeSpan.Zero
local green_start_position = Vector3.zero
local green_start_rotation = Quaternion.identity

-- 'blue-stone' の音とエフェクトを再生する
local function play_ripple()
    ripple_se._ALL_Play(1, false)
    ripple_efk._ALL_PlayOneShot()
end

local function calc_green_audio_source_position(position, rotation, t)
    local head_rot = Quaternion.AngleAxis(
        locus_rotation_angle_per_sec * t,
        locus_rotation_axis
    )

    local head_pos = locus_velocity * t + head_rot * locus_head_position

    return position + rotation * head_pos
end

local function move_green_audio_source(t)
    local pos = calc_green_audio_source_position(
        green_start_position,
        green_start_rotation,
        t
    )

    green_audio_source.SetPosition(pos)
end

-- 'green-stone' の音とエフェクトを再生する
-- 再生位置とエフェクトのタイミングを合わせるために、メッセージで受信する
vci.message.On(play_locus_message_name, function (name, sender, value)
    green_start_time = vci.me.UnscaledTime
    green_start_position = green_stone.GetPosition()
    green_start_rotation = green_stone.GetRotation()
    green_audio_source.SetRotation(green_start_rotation)
    move_green_audio_source(0)

    locus_se.Play(1, false)
    locus_efk.Play()
end)

function updateAll()
    local dt = vci.me.UnscaledTime - green_start_time
    if dt <= green_audio_total_time then
        move_green_audio_source(dt.TotalSeconds)
    end
end

function onUse(use)
    if use == 'blue-stone' then
        play_ripple()
    elseif use == 'green-stone' then
        if vci.me.UnscaledTime - green_audio_throttle_time >= green_start_time
        then
            vci.message.EmitWithId(
                play_locus_message_name,
                '',
                vci.assets.GetInstanceId()
            )
        end
    end
end
