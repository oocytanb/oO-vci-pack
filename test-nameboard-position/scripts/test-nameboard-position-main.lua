-- SPDX-License-Identifier: CC0-1.0

--[[
- ネームボードに関する、エラーを検証するためのVCIです。
- ユーザースタジオで、ホストがこのアイテムを設置する必要があります。
- **エラーが発生すると、スタジオを作り直す必要があります。**
- **よく理解されたうえで、ご使用ください。**

## 手順
  1. ユーザースタジオで、ホストがこのアイテムを設置します。
  2. ゲストが凸します。
  3. シリンダー型のアイテムをグリップして、スタジオ内のネームボードオブジェクトを取得します。
    (vci.studio.GetNameBoard)
  4. キューブ型のアイテムをグリップし、ネームボードの位置設定を、開始します。
    アイテムが黄色になり、毎フレーム、処理状況がログに出力され続けます。
    (NameBoard.SetPosition)
  5. ゲストが退室します。
  6. エラーが発生し、スタジオの Lua スレッドが停止します。
    (System.Reflection.TargetInvocationException:
      Exception has been thrown by the target of an invocation.
      ---> System.NullReferenceException:
        Object reference not set to an instance of an object.
        at Infiniteloop.VRLive.Item.RequestInteraction () [0x00000]
          in <00000000000000000000000000000000>:0)

## 確認したバージョン
安定板 VCAS 1.9.3h
]]

local settings = {
    refreshSwitchName = 'refresh-switch',
    nameboardActionSwitchName = 'nameboard-action-switch',

    defaultColor = Color.white,
    nameBoardActionProcessingColor = Color.__new(0.9, 0.7, 0.15),

    -- 毎回 HasNameBoard でチェックを行い、GetNameBoard でネームボードオブジェクトを、取得するようにするかを指定します。
    nameboardCheckAndGet = false,

    -- notification メッセージを受信した際に、メンバーリストを更新するかを指定します。
    refreshMembersOnNotification = false,

    -- ログ出力を行うかを指定します。
    outputDebugLog = true,
}

local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end

local OutputLog = function (msg)
    if settings.outputDebugLog then
        print(msg)
    end
end

local MakeStudioMembers = function ()
    local members = {}
    local i = 1
    for _k, avatar in ipairs(vci.studio.GetAvatars()) do
        local id = avatar.GetId()
        local name = avatar.GetName()
        local nameBoard = vci.studio.GetNameBoard(id)
        if id and name and nameBoard then
            members[i] = {
                id = id,
                name = name,
                avatar = avatar,
                nameBoard = nameBoard
            }
            i = i + 1
        end
    end
    return members
end

local ArrayToString = function (arr, predicate)
    local str = '['
    for i, item in ipairs(arr) do
        str = (i == 1 and str or str .. ', ')
            .. (predicate and tostring(predicate(item, i)) or tostring(item))
    end
    str = str .. ']'
    return str
end

local StudioMembersNameString = function (members)
    return ArrayToString(members, function (member) return member.name end)
end

local AvatarsNameString = function (avatars)
    return ArrayToString(avatars, function (avatar) return avatar.GetName() end)
end

local ActionStudioMembersNameBoard = function (members)
    OutputLog(
        '# ActionStudioMembersNameBoard\n'
        .. '  - studio.GetAvatars: ' .. AvatarsNameString(vci.studio.GetAvatars())
    )

    for _k, member in ipairs(members) do
        local hasNameBoard = vci.studio.HasNameBoard(member.id)
        local nameBoard
        if settings.nameboardCheckAndGet then
            if hasNameBoard then
                nameBoard = vci.studio.GetNameBoard(member.id)
            else
                nameBoard = nil
            end
        else
            nameBoard = member.nameBoard
        end

        if nameBoard then
            local newPosition = Vector3.zero

            -- 凸者が退室後も、GetName/GetPosition は動作する模様。
            OutputLog(
                '  - [' .. member.name .. '].nameBoard\n'
                .. '    - HasNameBoard: ' .. tostring(hasNameBoard) .. '\n'
                .. '    - GetName: ' .. tostring(nameBoard.GetName()) .. '\n'
                .. '    - GetPosition: ' .. tostring(nameBoard.GetPosition()) .. '\n'
                .. '    - NewPosition: ' .. tostring(newPosition)
            )

            -- 凸者が退室後に、SetPosition すると、System.Reflection.TargetInvocationException　が発生する。
            nameBoard.SetPosition(newPosition)
            OutputLog('    - [' .. member.name .. '].nameBoard.SetPosition proceeded')
            -- SetRotation でも再現する。
            -- nameBoard.SetRotation(Quaternion.identity)
        else
            OutputLog(
                '  - **SKIPPED** [' .. member.name .. '].nameBoard\n'
                .. '    - HasNameBoard: ' .. tostring(hasNameBoard)
            )
        end
    end
end

GetSubItem(settings.refreshSwitchName)
GetSubItem(settings.nameboardActionSwitchName)

-- 初期色を設定する。途中入室時の同期は考慮しない。
vci.assets.material.SetColorFromIndex(0, settings.defaultColor)

local studioMembers = MakeStudioMembers()
local nameBoardActionProcessing = false

local OnRefreshStudioMembers = function ()
    studioMembers = MakeStudioMembers()
    OutputLog('# studio members: ' .. StudioMembersNameString(studioMembers))
end

local OnNameBoardAction = function ()
    nameBoardActionProcessing = not nameBoardActionProcessing

    -- アクションの実行状況に応じて色を設定する。途中入室時の同期は考慮しない。
    local color = nameBoardActionProcessing and settings.nameBoardActionProcessingColor or settings.defaultColor
    vci.assets.material._ALL_SetColorFromIndex(0, color)
end

onUse = function (use)
    if vci.assets.IsMine then
        if use == settings.refreshSwitchName then
            OnRefreshStudioMembers()
        elseif use == settings.nameboardActionSwitchName then
            OnNameBoardAction()
        end
    end
end

update = function ()
    if nameBoardActionProcessing then
        ActionStudioMembersNameBoard(studioMembers)
    end
end

vci.message.On('notification', function (sender, messageName, message)
    OutputLog(
        '# on notification: [' .. sender.name .. ']  ' .. message .. '\n'
        .. '  - studio.GetAvatars: ' .. AvatarsNameString(vci.studio.GetAvatars())
    )

    if settings.refreshMembersOnNotification then
        OnRefreshStudioMembers()
    end
end)
