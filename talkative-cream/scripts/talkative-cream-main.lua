-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end

local EmitRawCommentMessage = function (msg)
    vci.message.Emit('comment', tostring(msg))
end

local settings = {
    enableDebugging = false,
    talkativeCreamName = 'talkative-cream',
    talkativeCreamMat = 'cream_mat'
}

--- カラーパレットのメッセージの名前空間。
local ColorPaletteMessageNS = 'cytanb.color-palette'

--- メッセージフォーマットの最小バージョン。
local ColorPaletteMinMessageVersion = 0x10000

--- アイテムのステータスを通知するメッセージ名。
local ColorPaletteItemStatusMessageName = ColorPaletteMessageNS .. '.item-status'

local creamNS = 'com.github.oocytanb.oO-vci-pack.talkative-cream'
local statusMessageName = creamNS .. '.status'
local queryStatusMessageName = creamNS .. '.query-status'

local vciLoaded = false

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local TalkativeCream; TalkativeCream = {
    Make = function (name)
        return {
            name = name,
            item = GetSubItem(name),
            color = cytanb.ColorFromARGB32(0xFFE7E7E7),
            grabbed = false
        }
    end,

    SetColor = function (self, color)
        self.color = color
        vci.assets.material.SetColor(settings.talkativeCreamMat, color)
    end,

    MakeStatusParameters = function (self)
        return {
            senderID = cytanb.ClientID(),
            argb32 = cytanb.ColorToARGB32(self.color)
        }
    end,

    Update = function (self)
        if self.grabbed and not self.item.IsMine then
            TalkativeCream.Ungrab(self)
        end
    end,

    Grab = function (self)
        self.grabbed = true
    end,

    Ungrab = function (self)
        self.grabbed = false
    end
}

local cream = TalkativeCream.Make(settings.talkativeCreamName)

local UpdateCw; UpdateCw = cytanb.CreateUpdateRoutine(
    function ()
        TalkativeCream.Update(cream)
    end,

    function ()
        cytanb.LogTrace('OnLoad')
        vciLoaded = true

        cytanb.OnMessage(ColorPaletteItemStatusMessageName, function (sender, name, parameterMap)
            local version = parameterMap.version
            if version and version >= ColorPaletteMinMessageVersion and cream.grabbed then
                -- クリームを掴んでいる場合は、カラーパレットから色情報を取得する
                local color = cytanb.ColorFromARGB32(parameterMap.argb32)
                if cream.color ~= color then
                    cytanb.LogDebug('on item status: color = ', color)
                    TalkativeCream.SetColor(cream, color)
                    cytanb.EmitMessage(statusMessageName, TalkativeCream.MakeStatusParameters(cream))
                end
            end
        end)

        cytanb.OnInstanceMessage(queryStatusMessageName, function (sender, name, parameterMap)
            if vci.assets.IsMine then
                -- マスターのみ応答する
                cytanb.EmitMessage(statusMessageName, TalkativeCream.MakeStatusParameters(cream))
            end
        end)

        cytanb.OnInstanceMessage(statusMessageName, function (sender, name, parameterMap)
            if parameterMap.senderID ~= cytanb.ClientID() then
                cytanb.LogTrace('on cream status message')
                if parameterMap.argb32 then
                    TalkativeCream.SetColor(cream, cytanb.ColorFromARGB32(parameterMap.argb32))
                end
            end
        end)

        cytanb.OnCommentMessage(function (sender, name, message)
            local originalLength = string.len(message)
            local trimmedMessage = cytanb.StringTrim(message)
            local messageLength = string.len(trimmedMessage)
            cytanb.LogInfo(
                'on comment: senderName = ', sender.name,
                ', commentSource = ', sender.commentSource,
                ', message = ', trimmedMessage,
                ' [length = ', messageLength , (messageLength == originalLength and '' or ', originalLength = ' .. tostring(originalLength)), ']'
            )

            local codeText = ''
            local codeCount = cytanb.StringEachCode(trimmedMessage, function(codeString)
                codeText = codeText .. ' <' .. codeString .. ':' .. string.len(codeString) .. '>'
            end, nil, 1, messageLength, true)
            cytanb.LogTrace('codeCount: ', codeCount, ', codes: ', codeText)
        end)

        cytanb.OnNotificationMessage(function (sender, name, message)
            cytanb.LogInfo('on notification: senderName = ', sender.name, ', message = ', message)
        end)

        TalkativeCream.SetColor(cream, cream.color)
        cytanb.EmitMessage(queryStatusMessageName)
    end,

    function (reason)
        cytanb.LogError('Error on update routine: ', reason)
        UpdateCw = function () end
    end
)

updateAll = function ()
    UpdateCw()
end

onGrab = function (target)
    if not vciLoaded then
        return
    end

    if target == cream.name then
        TalkativeCream.Grab(cream)
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    if target == cream.name then
        TalkativeCream.Ungrab(cream)
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == cream.name then
        -- 疑似的に、コメントメッセージを送信します。コメントの内容は、自由に書き換えて使います。
        EmitRawCommentMessage('これは、おしゃべりなクリームからの、テストメッセージです。')
        EmitRawCommentMessage('VCIから、スタジオ内にコメントメッセージを送信しています。')
        EmitRawCommentMessage('そのため、送信者名や送信元が特殊な状態になっています。')
        -- EmitRawCommentMessage('😀|👩🏻‍🚀|<sprite=1580>')

        -- 疑似的に、ニコニコのコメントメッセージを送信します。`cytanb.OnCommentMessage` 関数を使って受信する必要があります。
        -- cytanb.EmitCommentMessage('ニコニコのコメントのテストメッセージです。', {name = 'DummyNicoUser', commentSource = 'Nicolive'})
        -- cytanb.EmitCommentMessage('名前が空文字のテストメッセージです。', {name = '', commentSource = 'Nicolive'})

        -- 疑似的に、Twitter のコメントメッセージを送信します。`cytanb.OnCommentMessage` 関数を使って受信する必要があります。
        -- cytanb.EmitCommentMessage('Twitterのコメントのテストメッセージです。', {name = 'DummyTwitterUser', commentSource = 'Twitter'})
        -- cytanb.EmitCommentMessage('', {name = 'DummyTwitterEmptyMessenger', commentSource = 'Twitter'})
        -- cytanb.EmitCommentMessage('  ', {name = 'DummyTwitterWhiteSpaceMessenger', commentSource = 'Twitter'})

        -- 疑似的に、Showroom のコメントメッセージを送信します。`cytanb.OnCommentMessage` 関数を使って受信する必要があります。
        -- cytanb.EmitCommentMessage('Showroomのコメントのテストメッセージです。', {name = 'DummyShowroomUser', commentSource = 'Showroom'})
        -- cytanb.EmitCommentMessage('-1', {name = 'DummyShowroomUser', commentSource = 'Showroom'})
        -- cytanb.EmitCommentMessage('0', {name = 'DummyShowroomUser', commentSource = 'Showroom'})
        -- cytanb.EmitCommentMessage('1', {name = 'DummyShowroomUser', commentSource = 'Showroom'})
        -- cytanb.EmitCommentMessage('2', {name = 'DummyShowroomUser', commentSource = 'Showroom'})
        -- cytanb.EmitCommentMessage('49', {name = 'DummyShowroomUser', commentSource = 'Showroom'})
        -- cytanb.EmitCommentMessage('50', {name = 'DummyShowroomUser', commentSource = 'Showroom'})
        -- cytanb.EmitCommentMessage('51', {name = 'DummyShowroomUser', commentSource = 'Showroom'})

        -- 疑似的に、入室メッセージを送信します。`cytanb.OnNotificationMessage` 関数を使って受信する必要があります。
        -- cytanb.EmitNotificationMessage('joined', {name = 'DummyNotificationUser'})

        -- 疑似的に、退室メッセージを送信します。`cytanb.OnNotificationMessage` 関数を使って受信する必要があります。
        -- cytanb.EmitNotificationMessage('left', {name = 'DummyNotificationUser'})
    end
end
