-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

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
local updateUserCountTime = TimeSpan.MaxValue
local lastUpdateTime = TimeSpan.Zero
local lastColorIndex = -1

local UpdateUserCountState = function ()
    local avatars = vci.studio.GetAvatars()
    local count = avatars and #avatars or -1
    vci.state.Set('userCount', count)

    local updateTime = vci.me.Time.TotalSeconds
    vci.state.Set('updateTime', updateTime)
    print('updateTime: ' .. tostring(updateTime) .. ' | vci.state.Get: ' .. tostring(vci.state.Get('updateTime')))
end

-- アイテムを設置したときの初期化処理
print('vci.assets.IsMine: ' .. tostring(vci.assets.IsMine))
if vci.assets.IsMine then
    vci.state.Set('colorIndex', 0)
    vci.state.Set('stateInitialized', 'OK')
end
print('on chunk evaluated: colorIndex = ' .. tostring(vci.state.Get('colorIndex')))

updateAll = function ()
    local time = vci.me.Time
    local waitTime = lastUpdateTime + (lastColorIndex < 0 and TimeSpan.FromMilliseconds(10) or UpdatePeriod)
    if time >= waitTime then
        lastUpdateTime = time
        local colorIndex = vci.state.Get('colorIndex')
        if colorIndex and colorIndex ~= lastColorIndex then
            if lastColorIndex < 0 then
                print('sync time = ' .. (time - chunkEvaluatedTime).TotalMilliseconds .. ' ms')
            end
            print('color index changed: ' .. colorIndex)
            lastColorIndex = colorIndex
            vci.assets.SetMaterialColorFromIndex(0, COLOR_LIST[colorIndex % #COLOR_LIST + 1])
        end
    end

    if vci.assets.IsMine and time >= updateUserCountTime then
        updateUserCountTime = TimeSpan.MaxValue
        UpdateUserCountState()
    end
end

onGrab = function (target)
    print('onGrab: ' .. target)
end

onUse = function (use)
    print('onUse: ' .. use .. ', vci.assets.IsMine: ' .. tostring(vci.assets.IsMine))
    UpdateUserCountState()
    vci.state.Add('colorIndex', 1)
    lastUpdateTime = TimeSpan.Zero
end

vci.message.On('notification', function (sender, name, message)
    if vci.assets.IsMine then
        if message == 'joined' then
            UpdateUserCountState()
            updateUserCountTime = vci.me.Time + TimeSpan.FromSeconds(30)
        end
    end
end)
