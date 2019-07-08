----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

local COLOR_LIST = {
    Color.__new(0.9, 0.7, 0.133),
    Color.__new(0.04, 0.9, 0.04),
    Color.__new(0.0, 0.66, 0.04),
    Color.__new(0.0, 0.58, 0.85),
    Color.__new(0.4, 0.19, 0.56),
    Color.__new(0.93, 0.2, 0.31)
}

local UpdatePeriod = TimeSpan.FromMilliseconds(500)
local chunkEvaluatedTime = vci.me.Time
local lastUpdateTime = TimeSpan.Zero
local lastColorIndex = -1

-- アイテムを設置したときの初期化処理
if vci.assets.IsMine then
    vci.state.Set('colorIndex', 1)
else
    print('on guest init: colorIndex = ' .. tostring(vci.state.Get('colorIndex')))
end

local function GetColorIndex()
    return vci.state.Get('colorIndex') or 1
end

function updateAll()
    local time = vci.me.Time
    if time >= lastUpdateTime + UpdatePeriod then
        lastUpdateTime = time
        local colorIndex = GetColorIndex()
        if colorIndex ~= lastColorIndex then
            print('color index changed: ' .. colorIndex .. '  | time = ' .. (time - chunkEvaluatedTime).TotalMilliseconds .. ' ms')
            lastColorIndex = colorIndex
            vci.assets.SetMaterialColorFromIndex(0, COLOR_LIST[colorIndex])
        end
    end
end

-- SubItem をトリガーでつかむと呼び出される。
function onGrab(target)
    print('onGrab: ' .. target)
end

-- グリップしてアイテムを使用すると呼び出される。
function onUse(use)
    local colorIndex = GetColorIndex() % #COLOR_LIST + 1
    local color = COLOR_LIST[colorIndex]
    print('onUse: ' .. use .. '  | colorIndex = ' .. colorIndex .. ' , color = ' .. tostring(color))
    vci.state.Set('colorIndex', colorIndex)
    lastUpdateTime = TimeSpan.Zero
end
