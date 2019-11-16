--[[
MIT License

Copyright (c) 2019 oO (https://github.com/oocytanb)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

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

onUse = function (use)
    -- カラーパレットの共有変数から値を取得する。
    local color = ColorFromARGB32(vci.studio.shared.Get('com.github.oocytanb.cytanb-tso-collab.color-palette.argb32') or DefaultARGB32)

    print('onUse: ' .. use .. ',  color = ' .. tostring(color))
    vci.assets._ALL_SetMaterialColorFromIndex(0, color)
    vci.assets._ALL_PlayAudioFromIndex(0)
end
