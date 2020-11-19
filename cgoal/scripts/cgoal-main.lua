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

local UpdateCw; UpdateCw = cytanb.CreateUpdateRoutine(
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
    end,

    function (reason)
        cytanb.LogError('Error on update routine: ', reason)
        UpdateCw = function () end
    end,

    TimeSpan.FromSeconds(10)
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

    assert(0 == cytanb.UnixTime(0))
    local now = os.time()
    assert(now == cytanb.UnixTime(now))
    assert(os.time() == cytanb.UnixTime())

    assert(function ()
        print('json.null: ' .. type(json.null))
        print('json.isnull: ' .. type(json.isnull))
        print('json.isNull: ' .. type(json.isNull))

        local table1 = {foo = "apple"}
        local table2 = {bar = 1234.5}
        local table3 = {qux = true, quux = table1}
        local table4 = {baz = nil}
        local table20 = {negativeNumber = -567}
        -- local table21 = {[-90] = "negativeNumberIndex"}
        -- local table22 = {[92] = "someNumberIndex"}

        local arr40 = {arr = {100, 200, 300}}
        local arr41 = {arr = {{101, 102}}}
        local arr42 = {arr = {{{111, 112}}}}
        local arr43 = {arr = {100, {201, 202}}}
        local arr44 = {arr = {100, {{211, 212}, 202}}}
        local arr45 = {arr = {100, {201, {{2111}}, 203}}}
        local arr46 = {arr = {100, {201, {211, {2111}}, 203}}}
        -- local arr47 = {arr = {[1] = 100, [2] = 200, [4040] = 4040}}
        -- local arr48 = {arr = {[1] = 100, [2] = 200, foo = "apple"}}
        -- local arr49 = {arr = {[0] = 0, [1] = 100, [2] = 200}}

        local jstr1 = json.serialize(table1)
        local jstr2 = json.serialize(table2)
        local jstr3 = json.serialize(table3)
        local jstr4 = json.serialize(table4)
        local jstr20 = json.serialize(table20)
        -- local jstr21 = json.serialize(table21)
        -- local jstr22 = json.serialize(table22)

        local jarr40 = json.serialize(arr40)
        local jarr41 = json.serialize(arr41)
        local jarr42 = json.serialize(arr42)
        local jarr43 = json.serialize(arr43)
        local jarr44 = json.serialize(arr44)
        local jarr45 = json.serialize(arr45)
        local jarr46 = json.serialize(arr46)
        -- local jarr47 = json.serialize(arr47)
        -- local jarr48 = json.serialize(arr48)
        -- local jarr49 = json.serialize(arr49)

        assert('{"foo":"apple"}' == jstr1)
        assert('{"bar":1234.5}' == jstr2)
        assert('{"baz":null}' == jstr4)
        assert('{"negativeNumber":-567}' == jstr20)
        --assert('{"-90":"negativeNumberIndex"}' == jstr21)             -- VCAS 2.0.0a: '{}'
        --assert('{"92":"someNumberIndex"}' == jstr22)                  -- VCAS 2.0.0a: '{}'

        assert('{"arr":[100,200,300]}' == jarr40)
        assert('{"arr":[[101,102]]}' == jarr41)
        assert('{"arr":[[[111,112]]]}' == jarr42)
        assert('{"arr":[100,[201,202]]}' == jarr43)
        assert('{"arr":[100,[[211,212],202]]}' == jarr44)
        assert('{"arr":[100,[201,[[2111]],203]]}' == jarr45)
        assert('{"arr":[100,[201,[211,[2111]],203]]}' == jarr46)
        -- assert('{"arr":{"1":100,"2":200,"4040":4040}}' == jarr47)    -- VCAS 2.0.0a: '{"arr":[100,200]}'
        -- assert('{"arr":{"1":100,"2":200,"foo":"apple"}}' == jarr48)  -- VCAS 2.0.0a: '{"arr":[100,200]}'
        -- assert('{"arr":{"0":0,"1":100,"2":200}}' == jarr49)          -- VCAS 2.0.0a: '{"arr":[100,200]}'

        assert("apple" == json.parse(jstr1).foo)
        assert(1234.5 == json.parse(jstr2).bar)
        assert(true == json.parse(jstr3).qux)
        assert("apple" == json.parse(jstr3).quux.foo)
        assert(json.isnull(json.parse(jstr4).baz))
        -- assert(-567 == json.parse(jstr20).negativeNumber)        -- VCAS 2.0.0a: https://virtualcast.jp/wiki/doku.php?id=vci:updatelog:2.0.0a
        -- assert("negativeNumberIndex" == json.parse(jstr21)["-90"])
        -- assert("someNumberIndex" == json.parse(jstr22)["92"])
        -- assert("/" == json.parse('{"solidas":"\\/"}').solidas)   -- VCAS 2.0.0a: https://virtualcast.jp/blog/2020/11/virtualcast200a_beta/

        assert(300 == json.parse(jarr40).arr[3])
        -- assert(102 == json.parse(jarr41).arr[1][2])      -- VCAS 2.0.0a: Unexpected token : '101,102'
        -- assert(112 == json.parse(jarr42).arr[1][1][2])   -- VCAS 2.0.0a: Unexpected token : '[111,112'
        assert(202 == json.parse(jarr43).arr[2][2])
        -- assert(212, json.parse(jarr44).arr[2][1][2])     -- VCAS 2.0.0a: Unexpected token : '211,212],202'
        -- assert(2111, json.parse(jarr45).arr[2][2][1][1]) -- VCAS 2.0.0a: Unexpected token : '2111'
        assert(2111, json.parse(jarr46).arr[2][2][2][1])

        return true
    end)()

    return true
end)())
