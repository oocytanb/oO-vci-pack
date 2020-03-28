-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

local locus_efk = vci.assets.GetEffekseerEmitter("green-stone")
local ripple_efk = vci.assets.GetEffekseerEmitter("blue-stone")

onUse = function (use)
    if use == "green-stone" then
        -- "green-stone" のアイテムがグリップされたら、音声とエフェクトを再生する
        vci.assets.audio._ALL_Play("sound-locus-se", 1, false)
        locus_efk._ALL_Play()
    elseif use == "blue-stone" then
        -- "blue-stone" のアイテムがグリップされたら、音声とエフェクトを再生する
        vci.assets.audio._ALL_Play("sound-ripple-se", 1, false)
        ripple_efk._ALL_PlayOneShot()
    end
end
