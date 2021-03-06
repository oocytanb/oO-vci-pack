-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

--- ARGB 32 bit 値から、Color オブジェクトへ変換する。
--- @param argb32 number
--- @return Color
local ColorFromARGB32 = function (argb32)
    local n = (type(argb32) == 'number') and argb32 or 0xFF000000
    return Color.__new(
        bit32.band(bit32.rshift(n, 16), 0xFF) / 0xFF,
        bit32.band(bit32.rshift(n, 8), 0xFF) / 0xFF,
        bit32.band(n, 0xFF) / 0xFF,
        bit32.band(bit32.rshift(n, 24), 0xFF) / 0xFF
    )
end

-- カラーパレットが存在しない場合のデフォルト色。
local DefaultARGB32 = 0xFF5573BE

local item = assert(vci.assets.GetSubItem('SubItem-strong'))
local se_clip = assert(item.GetAudioSources()[1])

onUse = function (use)
    -- カラーパレットの共有変数から値を取得する。
    local color = ColorFromARGB32(vci.studio.shared.Get('com.github.oocytanb.cytanb-tso-collab.color-palette.argb32') or DefaultARGB32)

    print('onUse: ' .. use .. ',  color = ' .. tostring(color))
    vci.assets._ALL_SetMaterialColorFromIndex(0, color)
    se_clip._ALL_PlayOneShot(1)
end
