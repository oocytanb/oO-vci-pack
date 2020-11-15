-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end

local textContent = tostring(require('text').textContent)

local settings = {
    tmpName = 'text-content',
    boardNamePrefix = 'message-item-',
    boardCount = 3,
    hiddenPositionBase = Vector3.__new(0, 2050, 0)
}

local makeBoards = function (boardSettings)
    local boards = {}
    for i = 1, boardSettings.boardCount do
        local name = boardSettings.boardNamePrefix .. tostring(i)
        boards[name] = {
            name = name,
            index = i,
            item = GetSubItem(name),
            hiddenPosition = boardSettings.hiddenPositionBase + Vector3.__new(0, 10 * i, 0),
            grabbed = false
        }
    end
    return boards
end

local boards = makeBoards(settings)

local nextBoard = function (currentIndex)
    return boards[settings.boardNamePrefix .. tostring(currentIndex % settings.boardCount + 1)]
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
        local next = nextBoard(board.index)

        local item = board.item
        local pos = item.GetPosition()
        local rot = item.GetRotation()
        item.SetPosition(board.hiddenPosition)

        local nextItem = next.item
        nextItem.SetPosition(pos)
        nextItem.SetRotation(rot)
    end
end
