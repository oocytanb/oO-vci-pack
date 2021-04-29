-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local item = assert(vci.assets.GetSubItem('SubItem-normal'))
local se_clip = assert(item.GetAudioSources()[1])

function onUse(use)
    se_clip._ALL_PlayOneShot(1)
end

cytanb.OnMessage('cytanb.color-palette.item-status', function (sender, name, parameterMap)
    -- `parameterMap.color` にパレットで選択した色情報が渡されます。
    -- ログ出力して確認します。
    print(tostring(parameterMap.color))

    -- マテリアルの色を変更します。
    vci.assets._ALL_SetMaterialColorFromIndex(0, parameterMap.color)
end)
