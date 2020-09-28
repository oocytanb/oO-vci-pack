-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local panelNS = 'com.github.oocytanb.oO-vci-pack.cgoal'
local evalMessageName = panelNS .. '.eval'

local vciLoaded = false
local frameCount = 0

cytanb.SetOutputLogLevelEnabled(true)
cytanb.SetLogLevel(cytanb.LogLevelAll)

cytanb.LogTrace('ge: vci.state.__CYTANB_INSTANCE_ID = ', vci.state.Get('__CYTANB_INSTANCE_ID'), ', cytanb.InstanceID() = ', cytanb.InstanceID())

cytanb.EmitMessage(evalMessageName, { foo = 'test'})

local UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        if deltaTime <= TimeSpan.Zero then
            return
        end
    end,
    function ()
        cytanb.LogTrace('OnLoad')
        vciLoaded = true

        local goal = vci.assets.GetSubItem('cgoal')
        print(tostring(goal.GetPosition()))
    end
)

updateAll = function ()
    frameCount = frameCount + 1
    if frameCount <= 2 then
        cytanb.LogTrace('updateAll: frameCount = ', frameCount, ', vci.state.__CYTANB_INSTANCE_ID = ', vci.state.Get('__CYTANB_INSTANCE_ID'), ', cytanb.InstanceID() = ', cytanb.InstanceID())
    end
    UpdateCw()
end

onGrab = function (target)
    cytanb.LogTrace('onGrab: ', target, ' | frameCount = ', frameCount)
    if not vciLoaded then
        return
    end
end

onUngrab = function (target)
    cytanb.LogTrace('onUngrab: ', target, ' | frameCount = ', frameCount)
    if not vciLoaded then
        return
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end
end

cytanb.OnInstanceMessage(evalMessageName, function (sender, name, parameterMap)
    cytanb.LogTrace('on ', name, ' message: frameCount = ', frameCount)
end)

assert((function()
    -- assert(string.gsub('|㌣|', '#', '@') == '|㌣|', 'string.gsub failed')
    assert(string.gsub('|㌣|', '#', {['#'] = '@'}) == '|㌣|', 'string.gsub failed')
    assert(cytanb.StringReplace('#|㌣|', '#', '@') == '@|㌣|', 'cytanb.StringReplace failed')
    assert(cytanb.StringReplace('色白い', '色白', 'いろじろ') == 'いろじろい', 'cytanb.StringReplace failed')
    assert(cytanb.TableToSerializable({solidas_and_cytanb_tag_data = '|伯|㌣た⽟千す協㑁低あ|'}).solidas_and_cytanb_tag_data == '|伯|㌣た⽟千す協㑁低あ|', 'cytanb.TableToSerializable failed')

    assert(not cytanb.StringStartsWith('幡a', 'a'))
    assert(cytanb.StringStartsWith('a幡', 'a'))

    assert(not cytanb.StringEndsWith('a幡', 'a'))
    assert(cytanb.StringEndsWith('幡a', 'a'))

    assert(cytanb.StringTrim('') == '')
    assert(cytanb.StringTrim(' \t\n\v\f\r') == '')
    assert(cytanb.StringTrim(' \t\n|hoge piyo\t  hogepiyo|\v\f\r') == '|hoge piyo\t  hogepiyo|')
    assert(cytanb.StringTrim('㤠伉弊尋希怍') == '㤠伉弊尋希怍')
    assert(cytanb.StringTrim('　') == '　', 'zenkaku space')

    assert(cytanb.UUIDFromString('帰弱怲帳弴崵崶強常弹孡形幣孤履てぁ⽂千恄居商0000000000') == nil)
    assert(cytanb.UUIDFromString('帰弱怲帳弴崵崶強-常弹孡形-幣孤履てЭぁ⽂千恄-居商0000000000') == nil)

    local pm50, pn50 = cytanb.ParseTagString('㌣なまえ#garply=waldo㌣孡形幣㌽孤履て#123=_987㌣⽂千恄')
    local pl50 = 0
    for _k, _v in pairs(pm50) do pl50 = pl50 + 1 end
    assert(pn50 == '㌣なまえ')
    assert(pm50['garply'] == 'waldo')
    assert(pm50['123'] == '_987')
    assert(pl50 == 2)

    local pm51, pn51 = cytanb.ParseTagString('なまえ#孡形幣=⽂千恄')
    local pl51 = 0
    for _k, _v in pairs(pm51) do pl51 = pl51 + 1 end
    assert(pn51 == 'なまえ')
    assert(pl51 == 0)

    local pm52, pn52 = cytanb.ParseTagString('なまえ#ab孡形幣=cd⽂千恄')
    local pl52 = 0
    for _k, _v in pairs(pm52) do pl52 = pl52 + 1 end
    assert('なまえ', pn52)
    assert(pm52.ab == 'ab')
    assert(pl52 == 1)

    local CodeAccumulator = function (codeString, index, cbArg, beginPos, endPos)
        table.insert(cbArg, {codeString, index, beginPos, endPos})
    end

    local ea70 = {}
    local ec70 = {cytanb.StringEachCode('aあ😀#㌣', CodeAccumulator, ea70)}
    cytanb.LogInfo(ec70)
    cytanb.LogInfo(ea70)
    assert(ec70[1] == 5)
    assert(ec70[2] == 1)
    assert(ec70[3] == string.len('aあ😀#㌣'))
    assert(#ea70 == 5)
    assert(ea70[1][1] == 'a'); assert(ea70[1][2] == 1); assert(ea70[1][3] == 1); assert(ea70[1][4] == 1)
    assert(ea70[2][1] == 'あ'); assert(ea70[2][2] == 2); assert(ea70[2][3] == 2); assert(ea70[2][4] == 2)
    assert(ea70[3][1] == '😀'); assert(ea70[3][2] == 3); assert(ea70[3][3] == 3); assert(ea70[3][4] == 4)
    assert(ea70[4][1] == '#'); assert(ea70[4][2] == 4); assert(ea70[4][3] == 5); assert(ea70[4][4] == 5)
    assert(ea70[5][1] == '㌣'); assert(ea70[5][2] == 5); assert(ea70[5][3] == 6); assert(ea70[5][4] == 6)

    local now = os.time()
    assert(now == cytanb.UnixTime())
    assert(now == cytanb.UnixTime(now))
    assert(0 == cytanb.UnixTime(0))

    return true
end)())
