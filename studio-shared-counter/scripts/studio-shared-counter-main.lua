----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

local SHARED_COUNTER_NAME = 'com.github.oocytanb.cytanb-tso-collab.studio-shared-counter'

local UpdatePeriod = TimeSpan.FromMilliseconds(500)
local chunkEvaluatedTime = vci.me.Time
local lastUpdateTime = TimeSpan.Zero
local lastCounter = -1

local function GetCounter()
    return vci.studio.shared.Get(SHARED_COUNTER_NAME) or 0
end

local function setCounterUV(counter)
    -- 0 ～ 9 までの UV 座標を設定する。
    local x = (counter % 10) / 10.0
    local offset = Vector2.__new(x, 0)
    vci.assets.SetMaterialTextureOffsetFromIndex(0, offset)
end

function updateAll()
    local time = vci.me.Time
    if time >= lastUpdateTime + UpdatePeriod then
        lastUpdateTime = time
        local counter = GetCounter()
        if counter ~= lastCounter then
            print('counter changed: ' .. counter .. '  | time = ' .. (time - chunkEvaluatedTime).TotalMilliseconds .. ' ms')
            lastCounter = counter
            setCounterUV(counter)
        end
    end
end

-- SubItem をトリガーでつかむと呼び出される。
function onGrab(target)
    print('onGrab: ' .. target)
end

-- グリップしてアイテムを使用すると呼び出される。
function onUse(use)
    local counter = GetCounter() + 1
    print('onUse: ' .. use .. '  | counter = ' .. counter)
    vci.studio.shared.Set(SHARED_COUNTER_NAME, counter)
    lastUpdateTime = TimeSpan.Zero
end
