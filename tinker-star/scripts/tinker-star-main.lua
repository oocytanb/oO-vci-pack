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

-- アイテムを設置したときの初期化処理
if vci.assets.IsMine then
    vci.state.Set("colorIndex", 1)
    vci.assets._ALL_SetMaterialColorFromIndex(0, COLOR_LIST[1])
end

-- SubItem をトリガーでつかむと呼び出される。
function onGrab(target)
    print("onGrab: " .. target)
end

-- グリップしてアイテムを使用すると呼び出される。
function onUse(use)
    local colorIndex = vci.state.Get("colorIndex")
    if colorIndex == nil then
        colorIndex = 1
    end
    colorIndex = colorIndex % #COLOR_LIST + 1
    vci.state.Set("colorIndex", colorIndex)

    local color = COLOR_LIST[colorIndex]
    print("onUse: " .. use .. "    colorIndex=" .. colorIndex .. "    color=" .. tostring(color))

    vci.assets._ALL_SetMaterialColorFromIndex(0, color)
end
