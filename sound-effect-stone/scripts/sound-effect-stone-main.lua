-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

local green_stone_name = 'green-stone'
local blue_stone_name = 'blue-stone'

local green_stone = assert(vci.assets.GetSubItem(green_stone_name))
local blue_stone = assert(vci.assets.GetSubItem(blue_stone_name))

local locus_se = assert(green_stone.GetAudioSources()[1])
local ripple_se = assert(blue_stone.GetAudioSources()[1])

local locus_efk = vci.assets.GetEffekseerEmitter(green_stone_name)
local ripple_efk = vci.assets.GetEffekseerEmitter(blue_stone_name)

function onUse(use)
    if use == "green-stone" then
        -- 'green-stone' のアイテムがグリップされたら、音声とエフェクトを再生する
        locus_se._ALL_Play(1, false)
        locus_efk._ALL_Play()
    elseif use == "blue-stone" then
        -- 'blue-stone' のアイテムがグリップされたら、音声とエフェクトを再生する
        ripple_se._ALL_Play(1, false)
        ripple_efk._ALL_PlayOneShot()
    end
end
