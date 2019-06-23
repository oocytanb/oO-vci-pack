----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

-- vci.message の送受信を確認するためのスクリプト。

-- グリップしてアイテムを使用すると呼び出される。
function onUse(use)
    print('onUse: ' .. use)

    vci.message.Emit('print-msg', 'fish')

    -- value に nil を指定すると、nil として受信される。
    vci.message.Emit('print-msg-nil', nil)

    -- value を省略すると、そのメッセージは受信されない。
    vci.message.Emit('print-msg-no-value-arg')
end

local function printMessage(sender, name, message)
    local buf = '\non ' .. name .. '\n'
    for k, v in pairs(sender) do
        buf = buf .. '  sender.'  .. tostring(k) .. ' : ' .. tostring(v) .. '\n'
    end
    buf = buf .. '  message : ' .. tostring(message) .. '\n'
    print(buf)
end

vci.message.On('print-msg', printMessage)
vci.message.On('print-msg-nil', printMessage)
vci.message.On('print-msg-no-value-arg', printMessage)
vci.message.On('comment', printMessage)
