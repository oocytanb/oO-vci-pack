-- SPDX-License-Identifier: MIT
-- Copyright (c) 2021 oO (https://github.com/oocytanb)
local str = ''

local width = 57
local height = 58
local sprite_count = 3300

for y = 0, height - 1 do
    for x = 0, width - 1 do
        local n = x * height + y
        local c = n < sprite_count and '<sprite=' .. tostring(n) .. '>' or ' '
        str = str .. c
    end
    str = str .. '\n'
end

vci.assets.SetText('sprite_text', str)
