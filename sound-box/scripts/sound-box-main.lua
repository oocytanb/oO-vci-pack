-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

function onUse (use)
    if use == "Subitem0" then
        -- "Subitem0" のアイテムがグリップされたら、0 番目の音声を再生する
        vci.assets._ALL_PlayAudioFromIndex(0)
    elseif use == "Subitem1" then
        -- "Subitem1" のアイテムがグリップされたら、1 番目の音声を再生する
        vci.assets._ALL_PlayAudioFromIndex(1)
    end
end
