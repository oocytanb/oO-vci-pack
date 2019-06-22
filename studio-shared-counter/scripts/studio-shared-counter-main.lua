----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

local SHARED_COUNTER_NAME = "com.github.oocytanb.cytanb-tso-collab.studio-shared-counter"

local lastUpdateTime = vci.me.Time
local lastCounter = -1

function setCounterUV(counter)
    -- 0 ～ 9 までの UV 座標を設定する。
    local x = (counter % 10) / 10.0
    local offset = Vector2.__new(x, 0)
    vci.assets._ALL_SetMaterialTextureOffsetFromIndex(0, offset)
end

function update()
    local currentTime = vci.me.Time
    if (currentTime - lastUpdateTime).TotalSeconds >= 1 then
        lastUpdateTime = currentTime
        local counter = vci.studio.shared.Get(SHARED_COUNTER_NAME)
        if counter ~= nil and counter ~= lastCounter then
            print("update counter: " .. counter)
            lastCounter = counter
            setCounterUV(counter)
        end
    end
end

-- SubItem をトリガーでつかむと呼び出される。
function onGrab(target)
    print("onGrab: " .. target)
end

-- グリップしてアイテムを使用すると呼び出される。
function onUse(use)
    local counter = (vci.studio.shared.Get(SHARED_COUNTER_NAME) or 0) + 1
    print("onUse: " .. use .. "    counter=" .. counter)
    lastUpdateTime = vci.me.Time
    lastCounter = counter
    vci.studio.shared.Set(SHARED_COUNTER_NAME, counter)
    setCounterUV(counter)
end
