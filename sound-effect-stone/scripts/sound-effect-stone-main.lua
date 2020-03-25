-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

local locus_efk = vci.assets.GetEffekseerEmitter("sound-effect-stone-locus")
local ripple_efk = vci.assets.GetEffekseerEmitter("sound-effect-stone-ripple")

onUse = function (use)
    if use == "sound-effect-stone-locus" then
        -- "sound-effect-stone-locus" のアイテムがグリップされたら、音声とエフェクトを再生する
        vci.assets.audio._ALL_Play("sound-locus-se", 1, false)
        locus_efk._ALL_Play()
    elseif use == "sound-effect-stone-ripple" then
        -- "sound-effect-stone-ripple" のアイテムがグリップされたら、音声とエフェクトを再生する
        vci.assets.audio._ALL_Play("sound-ripple-se", 1, false)
        ripple_efk._ALL_PlayOneShot()
    end
end
