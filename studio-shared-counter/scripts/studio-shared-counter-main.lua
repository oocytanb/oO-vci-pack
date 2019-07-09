----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

local SHARED_COUNTER_NAME = 'com.github.oocytanb.cytanb-tso-collab.studio-shared-counter'

local UpdatePeriod = TimeSpan.FromMilliseconds(500)
local chunkEvaluatedTime = vci.me.Time
local lastUpdateTime = TimeSpan.Zero
local lastCounter = -1

print('on chunk evaluated: counter = ' .. tostring(vci.studio.shared.Get(SHARED_COUNTER_NAME)))

local function setCounterUV(counter)
    -- 0 ～ 9 までの UV 座標を設定する。
    local x = (counter % 10) / 10.0
    local offset = Vector2.__new(x, 0)
    vci.assets.SetMaterialTextureOffsetFromIndex(0, offset)
end

function updateAll()
    local time = vci.me.Time
    local waitTime = lastUpdateTime + (lastCounter < 0 and TimeSpan.FromMilliseconds(10) or UpdatePeriod)
    if time >= waitTime then
        lastUpdateTime = time
        local counter = vci.studio.shared.Get(SHARED_COUNTER_NAME)
        if counter and counter ~= lastCounter then
            if lastCounter < 0 then
                print('sync time = ' .. (time - chunkEvaluatedTime).TotalMilliseconds .. ' ms')
            end
            print('counter changed: ' .. counter)
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
    print('onUse: ' .. use)
    vci.studio.shared.Add(SHARED_COUNTER_NAME, 1)
    lastUpdateTime = TimeSpan.Zero
end
