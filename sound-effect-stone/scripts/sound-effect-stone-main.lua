-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

local blue_stone_name = 'blue-stone'
local blue_stone = assert(vci.assets.GetSubItem(blue_stone_name))
local ripple_se = assert(blue_stone.GetAudioSources()[1])
local ripple_efk = vci.assets.GetEffekseerEmitter(blue_stone_name)

local green_stone_name = 'green-stone'
local green_audio_source_anim_root_name = 'green-audio-source-anim-root'
local green_audio_source_name = 'green-audio-source'
local green_audio_source_anim_name = 'green-audio-source-clip'
local green_stone = assert(vci.assets.GetSubItem(green_stone_name))
local green_audio_source_anim_root = assert(
    vci.assets.GetTransform(green_audio_source_anim_root_name)
)
local green_animator = green_audio_source_anim_root.GetAnimation()
local green_audio_source_obj = assert(
    vci.assets.GetTransform(green_audio_source_name)
)
local locus_se = assert(green_audio_source_obj.GetAudioSources()[1])
local locus_efk = vci.assets.GetEffekseerEmitter(green_stone_name)

local message_ns = 'com.github.oocytanb.oO-vci-pack.cytanb-sound-effect-stone'
local play_locus_message_name = message_ns .. '.play_locus'

-- 'blue-stone' の音とエフェクトを再生します。
-- 操作したユーザーだけが `_ALL_` 付きの再生関数を呼び出すことで、全ユーザーにおいて
-- 再生命令が実行されます。
local function play_ripple()
    ripple_se._ALL_Play(1, false)
    ripple_efk._ALL_PlayOneShot()
end

-- 'green-stone' の音とエフェクトを再生します。
-- 音源のオブジェクトを、アニメーションで移動させています。
-- エフェクトと音源の位置を合わせるために、メッセージを受信したタイミングで、
-- ユーザーローカルで再生を行います。
vci.message.On(play_locus_message_name, function (name, sender, value)
    green_audio_source_anim_root.SetPosition(green_stone.GetPosition())
    green_audio_source_anim_root.SetRotation(green_stone.GetRotation())
    green_animator.Stop()
    green_animator.PlayFromName(green_audio_source_anim_name, false)
    locus_se.Play(1, false)
    locus_efk.Play()
end)

function onUse(use)
    if use == 'blue-stone' then
        play_ripple()
    elseif use == 'green-stone' then
        vci.message.EmitWithId(
            play_locus_message_name,
            '',
            vci.assets.GetInstanceId()
        )
    end
end
