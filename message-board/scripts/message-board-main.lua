-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end

local textContent = tostring(require('text').textContent)

local settings = {
    tmpName = 'text-content',
    boardNamePrefix = 'message-item-',
    boardCount = 3,
    hiddenPositionBase = Vector3.__new(0, 2050, 0),
    maxAvatarListLength = 32
}

local makeBoards = function (settings)
    local boards = {}
    for i = 1, settings.boardCount do
        local name = settings.boardNamePrefix .. tostring(i)
        boards[name] = {
            name = name,
            index = i,
            item = GetSubItem(name),
            hiddenPosition = settings.hiddenPositionBase + Vector3.__new(0, 10 * i, 0),
            grabbed = false
        }
    end
    return boards
end

local boards = makeBoards(settings)

local nextBoard = function (currentIndex)
    return boards[settings.boardNamePrefix .. tostring(currentIndex % settings.boardCount + 1)]
end


-- アバターの一覧を更新する
local updateAvatarList = function ()
    local avatarList = vci.studio.GetAvatars()
    if avatarList then
        for i = 1, settings.maxAvatarListLength do
            local ava = avatarList[i]
            if not ava then
                break
            end
            local id = ava and ava.GetId() or ''
            local name = ava and ava.GetName() or ''
            print(name .. ' : ' .. id)
        end
    end
end

local vciLoaded = false
local initialUpdateSkipped = false

updateAll = function ()
    if not initialUpdateSkipped then
        initialUpdateSkipped = true
        return
    end

    if not vciLoaded then
        -- ロード完了
        vciLoaded = true
        vci.assets.SetText(settings.tmpName, textContent)

        -- ロード時に、アバターリストを初期化する
        updateAvatarList()

        -- 入退室の通知メッセージを受信したタイミングで、更新する。
        -- updateAll での更新は不要になる。
        vci.message.On('notification', function (sender, name, message)
            if message == 'joined' or message == 'left' then
                updateAvatarList()
            end
        end)
    end
end

onGrab = function (target)
    if not vciLoaded then
        return
    end

    local board = boards[target]
    if board then
        board.grabbed = true
    end

end

onUngrab = function (target)
    if not vciLoaded then
        return
    end
    
    local board = boards[target]
    if board then
        board.grabbed = false
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    local board = boards[use]
    if board and not board.grabbed then
        -- ボードがつかまれていない状態で、Use されたなら、次のボードに入れ替える。
        local nextBoard = nextBoard(board.index)

        local item = board.item
        local pos = item.GetPosition()
        local rot = item.GetRotation()
        item.SetPosition(board.hiddenPosition)

        local nextItem = nextBoard.item
        nextItem.SetPosition(pos)
        nextItem.SetRotation(rot)
    end
end
