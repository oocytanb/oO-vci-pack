----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()math.randomseed(os.time()-os.clock()*10000)local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local a;local g=function(h,i)for j=1,4 do local k=h[j]-i[j]if k~=0 then return k end end;return 0 end;local l;l={__eq=function(h,i)return h[1]==i[1]and h[2]==i[2]and h[3]==i[3]and h[4]==i[4]end,__lt=function(h,i)return g(h,i)<0 end,__le=function(h,i)return g(h,i)<=0 end,__tostring=function(m)local n=m[2]or 0;local o=m[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(m[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(n,16),0xFFFF),bit32.band(n,0xFFFF),bit32.band(bit32.rshift(o,16),0xFFFF),bit32.band(o,0xFFFF),bit32.band(m[4]or 0,0xFFFFFFFF))end,__concat=function(h,i)local p=getmetatable(h)local q=p==l or type(p)=='table'and p.__concat==l.__concat;local r=getmetatable(i)local s=r==l or type(r)=='table'and r.__concat==l.__concat;if not q and not s then error('attempt to concatenate illegal values')end;return(q and l.__tostring(h)or h)..(s and l.__tostring(i)or i)end}local t='__CYTANB_CONST_VARIABLES'local u=function(table,v)local w=getmetatable(table)if w then local x=rawget(w,t)if x then local y=rawget(x,v)if type(y)=='function'then return y(table,v)else return y end end end;return nil end;local z=function(table,v,A)local w=getmetatable(table)if w then local x=rawget(w,t)if x then if rawget(x,v)~=nil then error('Cannot assign to read only field "'..v..'"')end end end;rawset(table,v,A)end;local B=function(C)return string.gsub(string.gsub(C,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local D=function(C,E)local F=string.len(C)local G=string.len(a.EscapeSequenceTag)if G>F then return C end;local H=''local j=1;while j<F do local I,J=string.find(C,a.EscapeSequenceTag,j,true)if not I then if j==1 then H=C else H=H..string.sub(C,j)end;break end;if I>j then H=H..string.sub(C,j,I-1)end;local K=false;for L,M in ipairs(c)do local N,O=string.find(C,M.pattern,I)if N then H=H..(E and E(M.tag)or M.replacement)j=O+1;K=true;break end end;if not K then H=H..a.EscapeSequenceTag;j=J+1 end end;return H end;a={InstanceID=function()if f==''then f=vci.state.Get(b)or''end;return f end,SetConst=function(P,Q,m)if type(P)~='table'then error('Cannot set const to non-table target')end;local R=getmetatable(P)local w=R or{}local S=rawget(w,t)if rawget(P,Q)~=nil then error('Non-const field "'..Q..'" already exists')end;if not S then S={}rawset(w,t,S)w.__index=u;w.__newindex=z end;rawset(S,Q,m)if not R then setmetatable(P,w)end;return P end,SetConstEach=function(P,T)for U,A in pairs(T)do a.SetConst(P,U,A)end;return P end,Extend=function(P,V,W,X,Y)if P==V or type(P)~='table'or type(V)~='table'then return P end;if W then if not Y then Y={}end;if Y[V]then error('circular reference')end;Y[V]=true end;for U,A in pairs(V)do if W and type(A)=='table'then local Z=P[U]P[U]=a.Extend(type(Z)=='table'and Z or{},A,W,X,Y)else P[U]=A end end;if not X then local _=getmetatable(V)if type(_)=='table'then if W then local a0=getmetatable(P)setmetatable(P,a.Extend(type(a0)=='table'and a0 or{},_,true))else setmetatable(P,_)end end end;if W then Y[V]=nil end;return P end,Vars=function(A,a1,a2,Y)local a3;if a1 then a3=a1~='__NOLF'else a1='  'a3=true end;if not a2 then a2=''end;if not Y then Y={}end;local a4=type(A)if a4=='table'then Y[A]=Y[A]and Y[A]+1 or 1;local a5=a3 and a2 ..a1 or''local C='('..tostring(A)..') {'local a6=true;for v,a7 in pairs(A)do if a6 then a6=false else C=C..(a3 and','or', ')end;if a3 then C=C..'\n'..a5 end;if type(a7)=='table'and Y[a7]and Y[a7]>0 then C=C..v..' = ('..tostring(a7)..')'else C=C..v..' = '..a.Vars(a7,a1,a5,Y)end end;if not a6 and a3 then C=C..'\n'..a2 end;C=C..'}'Y[A]=Y[A]-1;if Y[A]<=0 then Y[A]=nil end;return C elseif a4=='function'or a4=='thread'or a4=='userdata'then return'('..a4 ..')'elseif a4=='string'then return'('..a4 ..') '..string.format('%q',A)else return'('..a4 ..') '..tostring(A)end end,GetLogLevel=function()return e end,SetLogLevel=function(a8)e=a8 end,Log=function(a8,...)if a8<=e then local a9=table.pack(...)if a9.n==1 then local A=a9[1]if A~=nil then print(type(A)=='table'and a.Vars(A)or tostring(A))else print('')end else local C=''for j=1,a9.n do local A=a9[j]if A~=nil then C=C..(type(A)=='table'and a.Vars(A)or tostring(A))end end;print(C)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aa,ab)local table={}local ac=ab==nil;for U,A in pairs(aa)do table[A]=ac and A or ab end;return table end,Round=function(ad,ae)if ae then local af=10^ae;return math.floor(ad*af+0.5)/af else return math.floor(ad+0.5)end end,Clamp=function(m,ag,ah)return math.max(ag,math.min(m,ah))end,Lerp=function(ai,aj,a4)if a4<=0.0 then return ai elseif a4>=1.0 then return aj else return ai+(aj-ai)*a4 end end,LerpUnclamped=function(ai,aj,a4)if a4==0.0 then return ai elseif a4==1.0 then return aj else return ai+(aj-ai)*a4 end end,PingPong=function(a4,ak)if ak==0 then return 0 end;local al=math.floor(a4/ak)local am=a4-al*ak;if al<0 then if(al+1)%2==0 then return ak-am else return am end else if al%2==0 then return am else return ak-am end end end,QuaternionToAngleAxis=function(an)local al=an.normalized;local ao=math.acos(al.w)local ap=math.sin(ao)local aq=math.deg(ao*2.0)local ar;if math.abs(ap)<=Quaternion.kEpsilon then ar=Vector3.right else local as=1.0/ap;ar=Vector3.__new(al.x*as,al.y*as,al.z*as)end;return aq,ar end,ApplyQuaternionToVector3=function(an,at)local au=an.w*at.x+an.y*at.z-an.z*at.y;local av=an.w*at.y-an.x*at.z+an.z*at.x;local aw=an.w*at.z+an.x*at.y-an.y*at.x;local ax=-an.x*at.x-an.y*at.y-an.z*at.z;return Vector3.__new(ax*-an.x+au*an.w+av*-an.z-aw*-an.y,ax*-an.y-au*-an.z+av*an.w+aw*-an.x,ax*-an.z+au*-an.y-av*-an.x+aw*an.w)end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(ay)return l.__tostring(ay)end,UUIDFromNumbers=function(...)local az=...local a4=type(az)local aA,aB,aC,aD;if a4=='table'then aA=az[1]aB=az[2]aC=az[3]aD=az[4]else aA,aB,aC,aD=...end;local ay={bit32.band(aA or 0,0xFFFFFFFF),bit32.band(aB or 0,0xFFFFFFFF),bit32.band(aC or 0,0xFFFFFFFF),bit32.band(aD or 0,0xFFFFFFFF)}setmetatable(ay,l)return ay end,UUIDFromString=function(C)local F=string.len(C)if F~=32 and F~=36 then return nil end;local aE='[0-9a-f-A-F]+'local aF='^('..aE..')$'local aG='^-('..aE..')$'local aH,aI,aJ,aK;if F==32 then local ay=a.UUIDFromNumbers(0,0,0,0)local aL=1;for j,aM in ipairs({8,16,24,32})do aH,aI,aJ=string.find(string.sub(C,aL,aM),aF)if not aH then return nil end;ay[j]=tonumber(aJ,16)aL=aM+1 end;return ay else aH,aI,aJ=string.find(string.sub(C,1,8),aF)if not aH then return nil end;local aA=tonumber(aJ,16)aH,aI,aJ=string.find(string.sub(C,9,13),aG)if not aH then return nil end;aH,aI,aK=string.find(string.sub(C,14,18),aG)if not aH then return nil end;local aB=tonumber(aJ..aK,16)aH,aI,aJ=string.find(string.sub(C,19,23),aG)if not aH then return nil end;aH,aI,aK=string.find(string.sub(C,24,28),aG)if not aH then return nil end;local aC=tonumber(aJ..aK,16)aH,aI,aJ=string.find(string.sub(C,29,36),aF)if not aH then return nil end;local aD=tonumber(aJ,16)return a.UUIDFromNumbers(aA,aB,aC,aD)end end,ParseUUID=function(C)return a.UUIDFromString(C)end,CreateCircularQueue=function(aN)if type(aN)~='number'or aN<1 then error('Invalid argument: capacity = '..tostring(aN))end;local self;local aO=math.floor(aN)local H={}local aP=0;local aQ=0;local aR=0;self={Size=function()return aR end,Clear=function()aP=0;aQ=0;aR=0 end,IsEmpty=function()return aR==0 end,Offer=function(aS)H[aP+1]=aS;aP=(aP+1)%aO;if aR<aO then aR=aR+1 else aQ=(aQ+1)%aO end;return true end,OfferFirst=function(aS)aQ=(aO+aQ-1)%aO;H[aQ+1]=aS;if aR<aO then aR=aR+1 else aP=(aO+aP-1)%aO end;return true end,Poll=function()if aR==0 then return nil else local aS=H[aQ+1]aQ=(aQ+1)%aO;aR=aR-1;return aS end end,PollLast=function()if aR==0 then return nil else aP=(aO+aP-1)%aO;local aS=H[aP+1]aR=aR-1;return aS end end,Peek=function()if aR==0 then return nil else return H[aQ+1]end end,PeekLast=function()if aR==0 then return nil else return H[(aO+aP-1)%aO+1]end end,Get=function(aT)if aT<1 or aT>aR then a.LogError('CreateCircularQueue.Get: index is outside the range: '..aT)return nil end;return H[(aQ+aT-1)%aO+1]end,IsFull=function()return aR>=aO end,MaxSize=function()return aO end}return self end,
ColorFromARGB32=function(aU)local aV=type(aU)=='number'and aU or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(aV,16),0xFF)/0xFF,bit32.band(bit32.rshift(aV,8),0xFF)/0xFF,bit32.band(aV,0xFF)/0xFF,bit32.band(bit32.rshift(aV,24),0xFF)/0xFF)end,ColorToARGB32=function(aW)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*aW.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*aW.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*aW.g),0xFF),8),bit32.band(a.Round(0xFF*aW.b),0xFF))end,ColorFromIndex=function(aX,aY,aZ,a_,b0)local b1=math.max(math.floor(aY or a.ColorHueSamples),1)local b2=b0 and b1 or b1-1;local b3=math.max(math.floor(aZ or a.ColorSaturationSamples),1)local b4=math.max(math.floor(a_ or a.ColorBrightnessSamples),1)local aT=a.Clamp(math.floor(aX or 0),0,b1*b3*b4-1)local b5=aT%b1;local b6=math.floor(aT/b1)local as=b6%b3;local b7=math.floor(b6/b3)if b0 or b5~=b2 then local y=b5/b2;local b8=(b3-as)/b3;local A=(b4-b7)/b4;return Color.HSVToRGB(y,b8,A)else local A=(b4-b7)/b4*as/(b3-1)return Color.HSVToRGB(0.0,0.0,A)end end,GetSubItemTransform=function(b9)local ba=b9.GetPosition()local bb=b9.GetRotation()local bc=b9.GetLocalScale()return{positionX=ba.x,positionY=ba.y,positionZ=ba.z,rotationX=bb.x,rotationY=bb.y,rotationZ=bb.z,rotationW=bb.w,scaleX=bc.x,scaleY=bc.y,scaleZ=bc.z}end,TableToSerializable=function(bd,Y)if type(bd)~='table'then return bd end;if not Y then Y={}end;if Y[bd]then error('circular reference')end;Y[bd]=true;local be={}for U,A in pairs(bd)do local bf=type(U)local bg;if bf=='string'then bg=B(U)elseif bf=='number'then bg=tostring(U)..a.ArrayNumberTag else bg=U end;local bh=type(A)if bh=='string'then be[bg]=B(A)elseif bh=='number'and A<0 then be[tostring(bg)..a.NegativeNumberTag]=tostring(A)else be[bg]=a.TableToSerializable(A,Y)end end;Y[bd]=nil;return be end,TableFromSerializable=function(be)if type(be)~='table'then return be end;local bd={}for U,A in pairs(be)do local bg;local bi=false;if type(U)=='string'then local bj=false;bg=D(U,function(bk)if bk==a.NegativeNumberTag then bi=true elseif bk==a.ArrayNumberTag then bj=true end;return nil end)if bj then bg=tonumber(bg)or bg end else bg=U;bi=false end;if bi and type(A)=='string'then bd[bg]=tonumber(A)elseif type(A)=='string'then bd[bg]=D(A,function(bk)return d[bk]end)else bd[bg]=a.TableFromSerializable(A)end end;return bd end,TableToSerialiable=function(bd,Y)return a.TableToSerializable(bd,Y)end,TableFromSerialiable=function(be)return a.TableFromSerializable(be)end,EmitMessage=function(Q,bl)local table=bl and a.TableToSerializable(bl)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(Q,json.serialize(table))end,OnMessage=function(Q,bm)local bn=function(bo,bp,bq)local br=nil;if bo.type~='comment'and type(bq)=='string'then local bs,be=pcall(json.parse,bq)if bs and type(be)=='table'then br=a.TableFromSerializable(be)end end;local bl=br and br or{[a.MessageValueParameterName]=bq}bm(bo,bp,bl)end;vci.message.On(Q,bn)return{Off=function()if bn then bn=nil end end}end,OnInstanceMessage=function(Q,bm)local bn=function(bo,bp,bl)local bt=a.InstanceID()if bt~=''and bt==bl[a.InstanceIDParameterName]then bm(bo,bp,bl)end end;return a.OnMessage(Q,bn)end}a.SetConstEach(a,{LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}d=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})e=a.LogLevelInfo;package.loaded['cytanb']=a;f=vci.state.Get(b)or''if f==''and vci.assets.IsMine then f=tostring(a.RandomUUID())vci.state.Set(b,f)end;return a end)()

local GetEffekseerEmitterMap = function (name)
    local efkList = vci.assets.GetEffekseerEmitters(name)
    if not efkList then
        return nil
    end

    local map = {}
    for i, efk in pairs(efkList) do
        map[efk.EffectName] = efk
    end
    return map
end

local DefaultClickTiming = TimeSpan.FromMilliseconds(500)
local DetectClicks = function (lastClickCount, lastTime, clickTiming)
    local count = lastClickCount and lastClickCount or 0
    local timing = clickTiming and clickTiming or DefaultClickTiming
    local now = vci.me.Time
    local result = (lastTime and now > lastTime + timing) and 1 or count + 1
    return result, now
end

local IsHorizontalAttitude = function (rotation, up, angleAccuracy)
    local angle, axis = cytanb.QuaternionToAngleAxis(rotation)
    local acc = angleAccuracy or 1.0
    if angle <= acc or 360 - angle <= acc then
        return true
    else
        local au = Vector3.Angle(axis, up or Vector3.up)
        return au <= acc or 180 - au <= acc
    end
end

local ApplyAltitudeAngle = function (vec, angle, upwards)
    local axis = Vector3.Cross(upwards or Vector3.up, vec)
    if axis == Vector3.zero then
        -- upwards と軸が同じであれば、元のベクトルを返す。
        return vec
    else
        return cytanb.ApplyQuaternionToVector3(Quaternion.AngleAxis(- angle, axis), vec)
    end
end

local IsContactWithTarget = function (sourcePosition, sourceLongSide, targetPosition, targetLongSide)
    return (sourcePosition - targetPosition).sqrMagnitude <= (sourceLongSide + targetLongSide) ^ 2
end

local settings = require('cball-settings').Load(_ENV, tostring(cytanb.RandomUUID()))

local cballNS = 'com.github.oocytanb.oO-vci-pack.cball'
local respawnBallMessageName = cballNS .. '.respawn-ball'
local buildStandLightMessageName = cballNS .. '.build-standlight'
local buildAllStandLightsMessageName = cballNS .. '.build-all-standlights'
local hitMessageName = cballNS .. '.hit'
local showSettingsPanelMessageName = cballNS .. '.show-settings-panel'

--- VCI がロードされたか。
local vciLoaded = false

local hiddenPosition

local avatarColliderMap = cytanb.ListToMap(settings.avatarColliders, true)

local ball, ballEfkContainer, ballEfk, ballEfkFade, ballEfkFadeMove, ballEfkOne, ballEfkOneLarge, ballCup, standLights, standLightEfkContainer, standLightHitEfk, standLightDirectHitEfk, impactForceGauge, impactSpinGauge, settingsPanel, closeSwitch, adjustmentSwitches, propertyNameSwitchMap

--- 設定パネルがつかまれているか。
local settingsPanelGrabbed = false

--- ボールがつかまれているか。
local ballGrabbed = false

--- ボールのトランスフォームのキュー。
local ballTransformQueue = cytanb.CreateCircularQueue(32)

--- ボールの角速度のシミュレーション値。
local ballSimAngularVelocity = Vector3.zero

--- ボールがライト以外に当たった回数。
local ballBoundCount = 0

--- 入力タイミングによる投球フェーズ。
local impactPhase = 0

--- 入力タイミングによる投球の威力の比率。
local impactForceGaugeRatio = 0

--- 入力タイミングによる投球のスピンの比率。
local impactSpinGaugeRatio = 0

--- 入力タイミングによる投球のゲージの表示開始時間。
local impactGaugeStartTime = TimeSpan.Zero

--- カップがつかまれているか。
local cupGrabbed = false

--- カップのクリック数。
local cupClickCount = 0

--- カップのクリック時間。
local cupClickTime = TimeSpan.Zero

--- ライトを組み立てるリクエストを送った時間。
local standLightsLastRequestTime = vci.me.Time

if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelTrace)
    if settings[settings.efkLevelPropertyName] == 0 then
        -- デバッグ用にエフェクトの初期値を設定する
        settings[settings.efkLevelPropertyName] = 3
    end

    if vci.assets.IsMine then
        -- デバッグ用にスローイングのエフェクトを有効にする
        settings.enableThrowingEfk = true
    end
end

local CreateAdjustmentSwitch = function (switchName, knobName, propertyName)
    local knob = vci.assets.GetSubItem(knobName)
    local initialKnobPosition = knob.GetLocalPosition()
    local defaultValue = math.floor(cytanb.Clamp(settings[propertyName], -5, 5))
    local value = defaultValue
    local grabCount = 0
    local grabTime = TimeSpan.Zero

    local self
    self = {
        item = vci.assets.GetSubItem(switchName),

        GetValue = function ()
            return value
        end,

        DoInput = function (byGrab)
            if byGrab then
                -- Grab による入力の場合は、移動させるためにつかんだ時の誤操作を避けるために、2クリック以上で入力を受け付ける
                grabCount, grabTime = DetectClicks(grabCount, grabTime, settings.settingsPanelGrabClickTiming)
                if grabCount <= 1 then
                    return
                end
            end
            local inputCount = settings.localSharedProperties.GetProperty(propertyName, defaultValue) + 1
            settings.localSharedProperties.SetProperty(propertyName, inputCount)
        end,

        Update = function ()
            local inputCount = settings.localSharedProperties.GetProperty(propertyName, defaultValue)
            value = cytanb.PingPong(inputCount + 5, 10) - 5
            knob.SetLocalPosition(Vector3.__new(initialKnobPosition.x, settings.settingsPanelAdjustmentSwitchNeutralPositionY + value * settings.settingsPanelAdjustmentSwitchDivisionScale, initialKnobPosition.z))
            cytanb.LogInfo('on update[', switchName, ']: value = ', value, ', count = ', inputCount)
        end
    }
    self.Update()
    return self
end

local CalcAdjustment = function (adjustmentValue, min, max)
    -- max - min を 100% とし、中央値に adjustmentValue の 20% を加える。
    return min + (max - min) * 0.5 * cytanb.Clamp(1 + adjustmentValue * 0.2, 0.0, 2.0)
end

local OfferBallTransform = function (position, rotation, time)
    ballTransformQueue.Offer({position = position, rotation = rotation, time = time or vci.me.Time})
end

local EmitHitBall = function (targetName)
    if not ball.IsMine then
        cytanb.LogWarn('Unexpected operation: ball is not mine @EmitHitBall')
        return
    end

    local queueSize = ballTransformQueue.Size()
    local velocity
    if queueSize >= 3 then
        -- 直前の位置をとると、衝突後の位置が入っているため、その前の位置を採用する
        local et = ballTransformQueue.Get(queueSize - 1)
        local st = ballTransformQueue.Get(queueSize - 2)
        local dp = et.position - st.position
        local deltaSec = (et.time - st.time).TotalSeconds
        velocity = dp / (deltaSec > 0 and deltaSec or 0.000001)
        cytanb.LogTrace('EmitHitBall: deltaPos = ', dp, ', deltaSec = ', deltaSec)
    else
        velocity = Vector3.zero
        cytanb.LogTrace('EmitHitBall: zero velocity')
    end

    cytanb.LogTrace('  emit ', hitMessageName, ': target = ', targetName, ', velocity = ', velocity, ', boundCount = ', ballBoundCount)
    cytanb.EmitMessage(hitMessageName, {
        source = {
            name = ball.GetName(),
            transform = cytanb.GetSubItemTransform(ball),
            velocity = {
                x = velocity.x,
                y = velocity.y,
                z = velocity.z
            },
            longSide = settings.ballSimLongSide,
            mass = settings.ballSimMass,
            clientID = settings.localSharedProperties.GetClientID()
        },
        target = {
            name = targetName
        },
        directHit = ballBoundCount == 0
    })
end


local EmitHitStandLight = function (light, targetName)
    local li = light.item
    local ls = light.status
    if not li.IsMine then
        cytanb.LogWarn('Unexpected operation: light is not mine @EmitHitStandLight')
        return
    end

    local now = vci.me.Time
    if now > ls.inactiveTime + settings.standLightRequestIntervalTime then
        -- 自身のライトが倒れている状態でヒットした場合は、無視する
        return
    end

    local deltaSec = (now - ls.inactiveTime).TotalSeconds
    local velocity
    if deltaSec > 0 then
        local dp = li.GetPosition() - ls.respawnPosition
        velocity = dp / deltaSec
        cytanb.LogTrace('EmitHitStandLight: deltaPos = ', dp, ', deltaSec = ', deltaSec)
    else
        velocity = Vector3.zero
        cytanb.LogTrace('EmitHitStandLight: zero velocity')
    end

    --@todo hitMessage が来る前に、ライトがターゲットに当たった場合は、hitClientID を正しく設定できないので、対策を考える。
    local hitClientID = now <= ls.hitMessageTime + settings.standLightRequestIntervalTime and ls.hitClientID or ''

    cytanb.LogTrace('  emit ', hitMessageName, ': target = ', targetName, ', velocity = ', velocity, ', hitClientID = ', hitClientID)
    cytanb.EmitMessage(hitMessageName, {
        source = {
            name = li.GetName(),
            transform = cytanb.GetSubItemTransform(li),
            velocity = {
                x = velocity.x,
                y = velocity.y,
                z = velocity.z
            },
            longSide = settings.standLightSimLongSide,
            mass = settings.standLightSimMass,
            clientID = hitClientID
        },
        target = {
            name = targetName
        },
        directHit = false
    })
end

local StandLightFromName = function (name)
    local indexStr = string.sub(name, #settings.standLightPrefix + 1)
    local num = tonumber(indexStr)
    local index = num and math.floor(num) + 1 or -1
    if index >= 1 then
        local light = index <= settings.standLightCount and standLights[index] or nil
        return light, index
    else
        return nil, index
    end
end

local BuildStandLight = function (light, respawnPosition)
    if not light then
        return
    end

    local li = light.item
    local ls = light.status
    if respawnPosition then
        ls.respawnPosition = respawnPosition
    end
    ls.active = true
    ls.inactiveTime = vci.me.Time
    ls.readyInactiveTime = TimeSpan.Zero
    ls.hitMessageTime = TimeSpan.Zero
    ls.hitClientID = ''
    ls.directHit = false
    if li.IsMine then
        li.SetRotation(Quaternion.identity)
        li.SetPosition(ls.respawnPosition)
        li.SetVelocity(Vector3.zero)
        li.SetAngularVelocity(Vector3.zero)
    end
end

local HitStandLight = function (light)
    local li = light.item
    local ls = light.status
    local now = vci.me.Time
    if not ls.active and now <= ls.inactiveTime + settings.standLightRequestIntervalTime then
        -- ライトが倒れた直後ならヒットしたものとして判定
        if ls.hitClientID == settings.localSharedProperties.GetClientID() then
            -- スコアを更新
            local propertyName = ls.directHit and settings.scoreDirectHitCountPropertyName or settings.scoreHitCountPropertyName
            local score = (settings.localSharedProperties.GetProperty(propertyName) or 0) + 1
            settings.localSharedProperties.SetProperty(propertyName, score)
            cytanb.LogInfo(propertyName, ': ', score)
        end

        local efkLevel = propertyNameSwitchMap[settings.efkLevelPropertyName].GetValue()
        local efk
        if ls.directHit and efkLevel >= 0 then
            efk = standLightDirectHitEfk
        elseif not ls.directHit and efkLevel >= 1 then
            efk = standLightHitEfk
        else
            efk = nil
        end

        if efk then
            cytanb.LogTrace('play efk: ', efk.EffectName, ',', li.GetName())
            standLightEfkContainer.SetPosition(li.GetPosition())
            efk.Play()
        end

        local volume = cytanb.Clamp(0.0, (propertyNameSwitchMap[settings.audioVolumePropertyName].GetValue() + 5) / 10.0, 1.0)
        if volume > 0 then
            local clipName
            if ls.directHit then
                clipName = settings.standLightDirectHitAudioName
            else
                local l, i = StandLightFromName(li.GetName())
                clipName = settings.standLightHitAudioPrefix .. (i - 1)
                if light ~= l then
                    cytanb.LogWarn('eq-test failed')
                end
            end
            cytanb.LogTrace('play audio: ', clipName, ', volume = ', volume)
            vci.assets.audio.PlayOneShot(clipName, volume)
        end

        ls.readyInactiveTime = TimeSpan.Zero
    end
end

--- ゲージをリセットする。
local ResetGauge = function ()
    impactPhase = 0
    impactSpinGaugeRatio = 0
    impactForceGaugeRatio = 0
    impactGaugeStartTime = vci.me.Time
    ballSimAngularVelocity = Vector3.zero

    impactForceGauge.SetPosition(hiddenPosition)
    impactForceGauge.SetRotation(Quaternion.identity)
    impactSpinGauge.SetPosition(hiddenPosition)
    impactSpinGauge.SetRotation(Quaternion.identity)
    vci.assets.SetMaterialTextureOffsetFromName(settings.impactForceGaugeMat, Vector2.zero)
end

local ResetBallCup = function ()
    if ballCup.IsMine and not cupGrabbed and not IsHorizontalAttitude(ballCup.GetRotation()) then
        cytanb.LogTrace('reset cup rotation')
        ballCup.SetRotation(Quaternion.identity)
    end
end

--- ボールをカップへ戻す。
local RespawnBall = function ()
    ResetGauge()
    ResetBallCup()

    if ball.IsMine then
        ball.SetVelocity(Vector3.zero)
        ball.SetAngularVelocity(Vector3.zero)

        local ballPos = ballCup.GetPosition() + Vector3.__new(0, settings.ballRespawnOffsetY, 0)
        local ballRot = Quaternion.identity
        ball.SetPosition(ballPos)
        ball.SetRotation(ballRot)
        ballTransformQueue.Clear()
        OfferBallTransform(ballPos, ballRot)
        cytanb.LogDebug('on respawn ball: position = ', ballPos)
    end
end

local DrawThrowingTrail = function ()
    local queueSize = ballTransformQueue.Size()
    if not settings.enableThrowingEfk or queueSize < 2 then
        return
    end

    local headTransform = ballTransformQueue.PeekLast()
    local headTime = headTransform.time

    for i = queueSize, 1, -1 do
        local element = ballTransformQueue.Get(i)
        if not element then
            break
        end

        if headTime - element.time > settings.ballKinematicTime then
            break
        end

        local pos = element.position
        ballEfkContainer.SetPosition(pos)
        ballEfkOneLarge.Play()
    end
end

local IsInThrowingMotion = function ()
    local queueSize = ballTransformQueue.Size()
    if not ball.IsMine or queueSize < 2 then
        return false
    end

    local head = ballTransformQueue.Get(queueSize)
    local prev = ballTransformQueue.Get(queueSize - 1)

    local deltaSec = (head.time - prev.time).totalSeconds
    local dp = head.position - prev.position
    if deltaSec > 0 then
        local velocity = dp.magnitude / deltaSec
        local b = velocity >= settings.ballKinematicVelocityThreshold * 0.5
        cytanb.LogTrace('test throwing motion: ', b, ', velocity = ', velocity, ', deltaSec = ', deltaSec)
        return b
    else
        return false
    end
end

--- コントローラーの運動による投球
local ThrowBallByKinematic = function ()
    DrawThrowingTrail()

    if not ball.IsMine or ballTransformQueue.Size() < 2 then
        return
    end

    local headTransform = ballTransformQueue.PollLast()
    local headTime = headTransform.time
    local ballPos = headTransform.position
    local ballRot = headTransform.rotation

    local totalVelocity = Vector3.zero
    local totalAngularVelocity = Vector3.zero

    local st = headTime
    local sp = ballPos
    local sr = ballRot

    while true do
        local element = ballTransformQueue.PollLast()
        if not element then
            break
        end

        if headTime - element.time > settings.ballKinematicTime then
            break
        end

        -- cytanb.LogTrace('test-eq-transform: time = ', st == element.time, ', pos = ', sp == element.position, ', rot = ', sr == element.rotation)

        local deltaSec = (st - element.time).totalSeconds
        if deltaSec > Vector3.kEpsilon then
            -- 古いデータほど係数を下げる
            local deltaVelocityFactor = math.max(0.0, 1.0 - (headTime - st).totalSeconds * 1.25)
            -- cytanb.LogTrace('deltaVelocityFactor = ', deltaVelocityFactor)

            local dp = sp - element.position
            local velocity = dp * deltaVelocityFactor / deltaSec
            totalVelocity = totalVelocity + velocity

            local dr = sr * Quaternion.Inverse(element.rotation)
            local da, axis = cytanb.QuaternionToAngleAxis(dr)
            if (da ~= 0 and da ~= 360) or not Vector3.right then
                local angular = - (da <= 180 and 1 or da - 360)
                local angularVelocity = axis * ((angular >= 0 and 1 or -1) * cytanb.Clamp(angular / deltaSec, -360, 360) * math.pi / 180 * deltaVelocityFactor)
                totalAngularVelocity = totalAngularVelocity + angularVelocity
            end
        end

        -- cytanb.LogTrace('totalVelocity: ', totalVelocity, ', totalAngularVelocity: ', totalAngularVelocity)
        st = element.time
        sp = element.position
        sr = element.rotation
    end
    ballTransformQueue.Clear()

    totalVelocity = totalVelocity * CalcAdjustment(propertyNameSwitchMap[settings.ballVelocityAdjustmentPropertyName].GetValue(), settings.ballKinematicMinVelocityFactor, settings.ballKinematicMaxVelocityFactor)
    totalAngularVelocity = totalAngularVelocity * CalcAdjustment(propertyNameSwitchMap[settings.ballAngularVelocityAdjustmentPropertyName].GetValue(), settings.ballKinematicMinAngularVelocityFactor, settings.ballKinematicMaxAngularVelocityFactor)

    local velocityMagnitude = totalVelocity.magnitude
    cytanb.LogTrace('velocity magnitude: ', velocityMagnitude)
    if velocityMagnitude > settings.ballKinematicVelocityThreshold then
        local velocity = ApplyAltitudeAngle(totalVelocity, CalcAdjustment(propertyNameSwitchMap[settings.ballAltitudeAdjustmentPropertyName].GetValue(), settings.ballKinematicMinAltitudeFactor, settings.ballKinematicMaxAltitudeFactor))
        local forwardOffset = velocity * (math.min(velocityMagnitude * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset) / velocityMagnitude)
        cytanb.LogTrace('Throw ball by kinematic: velocity: ', velocity, ', angularVelocity: ', totalAngularVelocity)
        ballSimAngularVelocity = totalAngularVelocity
        ball.SetVelocity(velocity)
        ball.SetAngularVelocity(totalAngularVelocity)

        -- 体のコライダーに接触しないように、オフセットを足す
        ballPos = ball.GetPosition() + forwardOffset
        ball.SetPosition(ballPos)
    else
        ballSimAngularVelocity = Vector3.zero
    end

    OfferBallTransform(ballPos, ballRot)
end

--- 入力タイミングによる投球
local ThrowBallByInputTiming = function ()
    if not ball.IsMine then
        return
    end

    cytanb.LogTrace('Throw ball by input timing: impactSpinGaugeRatio: ', impactSpinGaugeRatio, ', impactForceGaugeRatio: ', impactForceGaugeRatio)
    local forward = impactForceGauge.GetForward()
    local forwardScale = CalcAdjustment(propertyNameSwitchMap[settings.ballVelocityAdjustmentPropertyName].GetValue(), settings.ballInpactMinVelocityScale, settings.ballInpactMaxVelocityScale) * impactForceGaugeRatio
    local forwardOffset = forward * math.min(forwardScale * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset)
    local velocity = ApplyAltitudeAngle(forward * forwardScale, CalcAdjustment(propertyNameSwitchMap[settings.ballAltitudeAdjustmentPropertyName].GetValue(), settings.ballInpactMinAltitudeScale, settings.ballInpactMaxAltitudeScale))

    ballSimAngularVelocity = Vector3.up * (CalcAdjustment(propertyNameSwitchMap[settings.ballAngularVelocityAdjustmentPropertyName].GetValue(), settings.ballInpactMinAngularVelocityScale, settings.ballInpactMaxAngularVelocityScale) * math.pi * impactSpinGaugeRatio)
    cytanb.LogTrace('velocity: ', velocity, ', angularVelocity: ', ballSimAngularVelocity)

    ball.SetVelocity(velocity)
    ball.SetAngularVelocity(ballSimAngularVelocity)

    -- 体のコライダーに接触しないように、オフセットを足す
    local ballPos = ball.GetPosition() + forwardOffset
    ball.SetPosition(ballPos)

    ballTransformQueue.Clear()
    OfferBallTransform(ballPos, ball.GetRotation())
end

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    vciLoaded = true

    local uuid = cytanb.UUIDFromString(cytanb.InstanceID())
    hiddenPosition = Vector3.__new(uuid[1] / 0x100000, 0x1000, uuid[2] / 0x100000)
    cytanb.LogTrace('hiddenPosition: ', hiddenPosition)

    ball = vci.assets.GetSubItem(settings.ballName)
    ballEfkContainer = vci.assets.GetSubItem(settings.ballEfkContainerName)

    local ballEfkMap = GetEffekseerEmitterMap(settings.ballEfkContainerName)
    ballEfk = ballEfkMap[settings.ballEfkName]
    ballEfkFade = ballEfkMap[settings.ballEfkFadeName]
    ballEfkFadeMove = ballEfkMap[settings.ballEfkFadeMoveName]
    ballEfkOne = ballEfkMap[settings.ballEfkOneName]
    ballEfkOneLarge = ballEfkMap[settings.ballEfkOneLargeName]

    ballCup = vci.assets.GetSubItem(settings.ballCupName)

    standLights = {}
    for i = 1, settings.standLightCount do
        local item = vci.assets.GetSubItem(settings.standLightPrefix .. (i - 1))
        standLights[i] = {
            item = item,
            status = {
                respawnPosition = item.GetPosition(),
                grabbed = false,
                active = true,
                inactiveTime = TimeSpan.Zero,
                readyInactiveTime = TimeSpan.Zero,
                hitMessageTime = TimeSpan.Zero,
                hitClientID = '',
                directHit = false
            }
        }
    end

    standLightEfkContainer = vci.assets.GetSubItem(settings.standLightEfkContainerName)

    local standLightEfkMap = GetEffekseerEmitterMap(settings.standLightEfkContainerName)
    standLightHitEfk = standLightEfkMap[settings.standLightHitEfkName]
    standLightDirectHitEfk = standLightEfkMap[settings.standLightDirectHitEfkName]

    impactForceGauge = vci.assets.GetSubItem(settings.impactForceGaugeName)
    impactForceGauge.SetPosition(hiddenPosition)

    impactSpinGauge = vci.assets.GetSubItem(settings.impactSpinGaugeName)
    impactSpinGauge.SetPosition(hiddenPosition)

    settingsPanel = vci.assets.GetSubItem(settings.settingsPanelName)

    closeSwitch = vci.assets.GetSubItem(settings.closeSwitchName)

    propertyNameSwitchMap = {}
    adjustmentSwitches = {}
    for index, entry in ipairs(settings.adjustmentSwitchNames) do
        local switch = CreateAdjustmentSwitch(entry.switchName, entry.knobName, entry.propertyName)
        propertyNameSwitchMap[entry.propertyName] = switch
        adjustmentSwitches[entry.switchName] = switch
    end

    settings.localSharedProperties.AddListener(function (eventName, key, value, oldValue)
        if eventName == settings.localSharedProperties.propertyChangeEventName then
            -- cytanb.LogInfo('localSharedProperties: on ', eventName, ', key = ', key, ', value = ', value)
            local switch = propertyNameSwitchMap[key]
            if switch then
                switch.Update()
            end
        elseif eventName == settings.localSharedProperties.expiredEventName then
            cytanb.LogInfo('localSharedProperties: on ', eventName)
            -- 期限切れとなったので、アンロード処理をする
            vciLoaded = false
        else
            cytanb.LogInfo('localSharedProperties: unknown event: ', eventName)
        end
    end)

    cytanb.OnInstanceMessage(respawnBallMessageName, function (sender, name, parameterMap)
        RespawnBall()
    end)

    -- ライトを組み立てる。
    cytanb.OnInstanceMessage(buildStandLightMessageName, function (sender, name, parameterMap)
        cytanb.LogDebug('onBuildStandLight')

        local targets = parameterMap.targets
        if targets then
            for i, options in pairs(targets) do
                local transform = options and options.transform
                local respawnPosition = transform and Vector3.__new(transform.positionX, transform.positionY >= 0 and transform.positionY or 0.25, transform.positionZ) or nil
                BuildStandLight(standLights[i], respawnPosition)
            end
        end
    end)

    -- 全てのライトを組み立てる。別 VCI から送られてくるケースも考慮する。
    cytanb.OnMessage(buildAllStandLightsMessageName, function (sender, name, parameterMap)
        for i = 1, settings.standLightCount do
            BuildStandLight(standLights[i])
        end
    end)

    -- ターゲットにヒットした。別 VCI から送られてくるケースも考慮する。
    cytanb.OnMessage(hitMessageName, function (sender, name, parameterMap)
        local source = parameterMap.source
        local sourceTransform = source.transform
        local light, index = StandLightFromName(parameterMap.target.name)
        if not sourceTransform or not light then
            return
        end

        local li = light.item
        local ls = light.status
        local sourcePos = Vector3.__new(sourceTransform.positionX, sourceTransform.positionY, sourceTransform.positionZ)
        local now = vci.me.Time
        if IsContactWithTarget(sourcePos, source.longSide or 1.0, li.GetPosition(), settings.standLightSimLongSide) and now > ls.hitMessageTime + settings.standLightRequestIntervalTime then
            -- 自 VCI のターゲットにヒットした
            cytanb.LogTrace('onHitMessage: standLight[', index, ']')
            ls.hitMessageTime = now
            ls.hitClientID = source.clientID
            ls.directHit = parameterMap.directHit

            if ls.active then
                -- ライトが倒れていないので、レディ状態をセットする
                cytanb.LogTrace('ready inactive: ', li.GetName(), ', directHit = ', ls.directHit)
                ls.readyInactiveTime = now

                if li.IsMine and not ls.grabbed and source.clientID ~= settings.localSharedProperties.GetClientID() then
                    -- ライトの操作権があり、ソースのクライアントIDが自身のIDと異なる場合は、ソースの操作権が別ユーザーであるため、自力で倒れる
                    local hitForce
                    local sourceVelocity = source.velocity and Vector3.__new(source.velocity.x, source.velocity.y, source.velocity.z) or Vector3.zero
                    local horzSqrMagnitude = sourceVelocity.x ^ 2 + sourceVelocity.y ^ 2
                    cytanb.LogTrace(' horzSqrMagnitude = ', horzSqrMagnitude, ', source.velocity = ', source.velocity)
                    if horzSqrMagnitude > 0.0025 then
                        local horzMagnitude = math.sqrt(horzSqrMagnitude)
                        local im = cytanb.Clamp(horzMagnitude, settings.standLightMinHitMagnitude, settings.standLightMaxHitMagnitude) / horzMagnitude
                        hitForce = Vector3.__new(sourceVelocity.x * im, cytanb.Clamp(sourceVelocity.y, settings.standLightMinHitMagnitudeY, settings.standLightMaxHitMagnitudeY), sourceVelocity.z * im)
                        cytanb.LogTrace(li.GetName(), ' self-hit: source force = ', hitForce)
                    else
                        local rx = math.random()
                        local dx = (rx * 2 >= 1 and 1 or -1) * (rx * (settings.standLightMaxHitMagnitude - settings.standLightMinHitMagnitude) * 0.5 + settings.standLightMinHitMagnitude)
                        local rz = math.random()
                        local dz = (rz * 2 >= 1 and 1 or -1) * (rz * (settings.standLightMaxHitMagnitude - settings.standLightMinHitMagnitude) * 0.5 + settings.standLightMinHitMagnitude)
                        local dy = math.random() * (settings.standLightMaxHitMagnitudeY - settings.standLightMinHitMagnitudeY) + settings.standLightMinHitMagnitudeY
                        hitForce = Vector3.__new(dx, dy, dz)
                        cytanb.LogTrace(li.GetName(), ' self-hit: random force = ', hitForce)
                    end

                    local mass = source.mass > 0 and source.mass or 1.0
                    li.AddForce(hitForce * (mass * settings.standLightHitForceFactor))
                end
            else
                HitStandLight(light)
            end
        end
    end)

    -- 設定パネルを表示する
    cytanb.OnInstanceMessage(showSettingsPanelMessageName, function (sender, name, parameterMap)
        if not settingsPanel.IsMine then
            return
        end

        local cupPosition = ballCup.GetPosition()
        if Vector3.Distance(cupPosition, settingsPanel.GetPosition()) > settings.settingsPanelDistanceThreshold then
            -- 設定パネルが離れていた場合は、近づけて表示する。
            local position = cupPosition + settings.settingsPanelOffset
            cytanb.LogTrace('ShowSettingsPanel: posotion = ', position)
            settingsPanel.SetPosition(position)
            settingsPanel.SetRotation(Quaternion.LookRotation(Vector3.__new(- settings.settingsPanelOffset.x, 0, - settings.settingsPanelOffset.z)))
        end
    end)

    if vci.assets.IsMine then
        cytanb.EmitMessage(showSettingsPanelMessageName)
    end
end

--- ゲージの表示を更新する。
local OnUpdateImpactGauge = function (deltaTime)
    if impactPhase < 1 then
        return
    end

    if ballGrabbed then
        local ballPos = ball.GetPosition()
        impactForceGauge.SetPosition(ballPos)
        if impactPhase >= 2 then
            impactSpinGauge.SetPosition(ballPos)
        end

        if impactPhase == 1 then
            -- 方向の入力フェーズ
            local ratio = settings.impactGaugeRatioPerSec * deltaTime.TotalSeconds
            local angle = 180 * ratio
            local rotD = Quaternion.AngleAxis(angle, Vector3.up)
            -- cytanb.LogTrace('ratio: ', ratio, ', angle: ', angle, ', rotD : ', rotD)
            impactForceGauge.SetRotation(impactForceGauge.GetRotation() * rotD)
        elseif impactPhase == 2 then
            -- スピンの入力フェーズ
            local ratio = cytanb.PingPong(settings.impactGaugeRatioPerSec * (vci.me.Time - impactGaugeStartTime).TotalSeconds + 0.5, 1) - 0.5
            local angle = 180 * ratio
            local rotD = Quaternion.AngleAxis(angle, Vector3.up)
            -- cytanb.LogTrace('ratio: ', ratio, ', angle: ', angle, ', rotD : ', rotD)
            impactSpinGauge.SetRotation(impactForceGauge.GetRotation() * rotD)

            -- 境界付近の値を調整する
            local absRatio = math.abs(ratio)
            if absRatio <= 0.05 then
                impactSpinGaugeRatio = 0
            elseif absRatio >= 0.45 then
                impactSpinGaugeRatio = ratio < 0 and -0.5 or 0.5
            else
                impactSpinGaugeRatio = ratio
            end
        elseif impactPhase == 3 then
            -- 威力の入力フェーズ
            local ratio = cytanb.PingPong(settings.impactGaugeRatioPerSec * (vci.me.Time - impactGaugeStartTime).TotalSeconds, 1)
            local offsetY = settings.impactGaugeMaxUV * ratio
            -- cytanb.LogTrace('ratio: ', ratio, ', offsetY: ', offsetY)
            vci.assets.SetMaterialTextureOffsetFromName(settings.impactForceGaugeMat, Vector2.__new(0, offsetY))

            -- 境界付近の値を調整する
            if ratio <= 0.05 then
                impactForceGaugeRatio = 0
            elseif ratio >= 0.95 then
                impactForceGaugeRatio = 1
            else
                impactForceGaugeRatio = ratio
            end
        end
    else
        if vci.me.Time > impactGaugeStartTime + settings.impactGaugeDisplayTime then
            -- ゲージの表示時間を終えた
            impactPhase = 0
            impactForceGauge.SetPosition(hiddenPosition)
            impactSpinGauge.SetPosition(hiddenPosition)
        end
    end
end

--- ボールの更新処理をする。カーブさせるための計算をする。
local OnUpdateBall = function (deltaTime)
    local ballPos = ball.GetPosition()
    local ballRot = ball.GetRotation()
    local respawned = false

    if not ballGrabbed and not ballTransformQueue.IsEmpty() then
        local lastTransform = ballTransformQueue.PeekLast()
        local lastPos = lastTransform.position
        -- カップとの距離が離れていたら、ボールが転がっているものとして処理する
        local cupSqrDistance = (ballPos - ballCup.GetPosition()).sqrMagnitude
        if cupSqrDistance > settings.ballActiveThreshold ^ 2 then
            if vci.me.Time <= impactGaugeStartTime + settings.ballWaitingTime and cupSqrDistance <= settings.ballPlayAreaRadius ^ 2 then
                -- ボールの前回位置と現在位置から速度を計算する
                local deltaSec = deltaTime.TotalSeconds
                local velocity = (ballPos - lastPos) / deltaSec

                if ball.IsMine then
                    -- 角速度を計算する
                    ballSimAngularVelocity = ballSimAngularVelocity * (1.0 - math.min(1.0, settings.ballSimAngularDrag * deltaSec))
                    local angularVelocitySqrMagnitude = ballSimAngularVelocity.sqrMagnitude
                    if angularVelocitySqrMagnitude <= 0.0025 then
                        ballSimAngularVelocity = Vector3.zero
                        angularVelocitySqrMagnitude = 0
                    end

                    -- スピンを適用する処理
                    local horzVelocity = Vector3.__new(velocity.x, 0, velocity.z)
                    local velocityMagnitude = horzVelocity.magnitude
                    if velocityMagnitude > 0.0025 and angularVelocitySqrMagnitude ~= 0 then
                        -- 水平方向の力を計算する
                        local vcr = Vector3.__new(0, ballSimAngularVelocity.y, 0)
                        local vo = Vector3.Cross(vcr * (settings.ballSimAngularFactor * settings.ballSimMass / deltaSec), horzVelocity / velocityMagnitude)
                        local vca = Vector3.__new(vo.x, 0, vo.z)
                        ball.AddForce(vca)
                        -- cytanb.LogTrace('vca: ', vca, ', vo: ', vo, ', velocity: ', velocity)
                    end

                    -- 床抜けの対策。
                    if ballPos.y < 0 and ballPos.y < lastPos.y then
                        local leapY = 0.25 - ballPos.y
                        local leapV = Vector3.__new(0, leapY / (deltaSec ^ 2), 0)
                        cytanb.LogDebug('leap ball: position = ', ballPos, ', leapY = ', leapY, ', force = ', leapV)
                        ball.SetPosition(Vector3.__new(ballPos.x, 0.125, ballPos.z))
                        ball.AddForce(leapV)
                    end
                end

                local efkLevel = propertyNameSwitchMap[settings.efkLevelPropertyName].GetValue()
                if efkLevel >= 3 then
                    local vm = velocity.magnitude
                    if vm >= settings.ballTrailVelocityThreshold then
                        local near = cupSqrDistance <= settings.ballNearDistance ^ 2
                        local vmNodes = math.max(1, math.ceil(vm / (settings.ballSimLongSide * settings.ballTrailInterpolationDistanceFactor * (near and 0.5 or 1.0) / deltaSec)))
                        local nodes = math.min(vmNodes, settings.ballTrailInterpolationNodesPerFrame + math.max(0, math.floor((efkLevel - 3 + (near and 1 or 0)) * 2)))
                        local iNodes = 1.0 / nodes
                        local efk
                        if near then
                            -- 近距離の場合は、エフェクトレベルに合わせる
                            if efkLevel >= 5 then
                                efk = ballEfkFadeMove
                            elseif efkLevel == 4 then
                                efk = ballEfkFade
                            else
                                efk = ballEfk
                            end
                        elseif cupSqrDistance >= settings.ballFarDistance ^ 2 then
                            -- 遠距離の場合は、簡易エフェクト
                            efk = ballEfkOne
                        else
                            -- それ以外の場合は、通常エフェクト
                            efk = ballEfk
                        end

                        -- cytanb.LogTrace('ballEfk: nodes = ', nodes, ', vmNodes = ', vmNodes, ', near = ', near, ', efkName = ', efk.EffectName)
                        for i = 1, nodes do
                            local trailPos = Vector3.Lerp(lastPos, ballPos, i * iNodes)
                            -- cytanb.LogTrace('  ballEfk lerp: velocity.sqrMagnitude = ', vm, ', lerp nodes = ', nodes, ', trailPos = ', trailPos)
                            ballEfkContainer.SetPosition(trailPos)
                            efk.Play()
                        end
                    end
                end
            elseif ball.IsMine and not cupGrabbed then
                -- タイムアウトしたかエリア外に出たボールをカップへ戻す。
                cytanb.LogTrace('elapsed: ' , (vci.me.Time - impactGaugeStartTime).TotalSeconds, ', sqrDistance: ', cupSqrDistance)
                RespawnBall()
                respawned = true
            end
        end
    end

    if not respawned then
        OfferBallTransform(ballPos, ballRot)
    end
end

--- ライトが倒れた判定、復活処理を行う。
local OnUpdateStandLight = function (deltaTime)
    local needBuilding = false
    local targets = {}
    for i = 1, settings.standLightCount do
        local light = standLights[i]
        local li = light.item
        local ls = light.status
        local horizontalAttitude = IsHorizontalAttitude(li.GetRotation(), Vector3.up, settings.standLightHorizontalAttitudeThreshold)
        if horizontalAttitude then
            if not ls.active then
                -- 復活した
                cytanb.LogTrace('change standLight[', i, '] state to active')
                ls.active = true
            end
        else
            local now = vci.me.Time
            if ls.active then
                -- 倒れたことを検知した
                cytanb.TraceLog('change standLight[', i, '] state to inactive')
                ls.active = false
                ls.inactiveTime = vci.me.Time
                if now <= ls.readyInactiveTime + settings.standLightRequestIntervalTime then
                    cytanb.TraceLog('  call HitStandLight: light = ', li.GetName(), ', directHit = ', ls.directHit, ' @OnUpdateStandLight')
                    HitStandLight(light)
                end
            elseif now > ls.inactiveTime + settings.standLightWaitingTime then
                -- 倒れてから時間経過したので、復活させる。
                needBuilding = true
                targets[i] = {}
                -- cytanb.LogTrace('need building: standLight[', i, ']')
            end
        end
    end

    if vci.assets.IsMine and needBuilding and vci.me.Time > standLightsLastRequestTime + settings.standLightRequestIntervalTime then
        cytanb.LogTrace('request buildStandLight')
        standLightsLastRequestTime = vci.me.Time
        cytanb.EmitMessage(buildStandLightMessageName, {targets = targets})
    end
end

local OnUpdate = function (deltaTime)
    OnUpdateImpactGauge(deltaTime)
    OnUpdateBall(deltaTime)
    OnUpdateStandLight(deltaTime)
end

local UpdateCw = coroutine.wrap(function ()
    -- InstanceID を取得できるまで待つ。
    local MaxWaitTime = TimeSpan.FromSeconds(30)
    local startTime = vci.me.Time
    local lastTime = startTime
    local needWaiting = true
    while true do
        local id = cytanb.InstanceID()
        if id ~= '' then
            break
        end

        local now = vci.me.Time
        if now > startTime + MaxWaitTime then
            cytanb.LogError('TIMEOUT: Could not receive Instance ID.')
            return -1
        end

        lastTime = now
        needWaiting = false
        coroutine.yield(100)
    end

    if needWaiting then
        -- VCI アイテムを出して 1 フレーム目の update 後に、onUngrab が発生するのを待つ。
        lastTime = vci.me.Time
        coroutine.yield(100)
    end

    -- ロード完了。
    settings.localSharedProperties.UpdateAlive()
    OnLoad()

    while true do
        local now = vci.me.Time
        local delta = now - lastTime
        settings.localSharedProperties.UpdateAlive()
        OnUpdate(delta > TimeSpan.Zero and delta or TimeSpan.FromTicks(100))
        lastTime = now
        coroutine.yield(100)
    end
    -- return 0
end)

function updateAll ()
    UpdateCw()
end

function onGrab (target)
    if not vciLoaded then
        return
    end

    if target == ballCup.GetName() then
        cupGrabbed = true
    elseif target == ball.GetName() then
        ballGrabbed = true
        ball.SetVelocity(Vector3.zero)
        ball.SetAngularVelocity(Vector3.zero)
        ResetGauge()
        ballTransformQueue.Clear()
    elseif target == settingsPanel.GetName() then
        settingsPanelGrabbed = true
    elseif string.startsWith(target, settings.standLightPrefix) then
        local light = StandLightFromName(target)
        if light then
            light.status.grabbed = true
        end
    elseif adjustmentSwitches[target] then
        adjustmentSwitches[target].DoInput(true)
    end
end

function onUngrab (target)
    if not vciLoaded then
        return
    end

    if target == ballCup.GetName() then
        cupGrabbed = false
        ResetBallCup()
    elseif target == ball.GetName() then
        if ballGrabbed then
            ballGrabbed = false
            if ball.IsMine then
                if impactPhase == 0 then
                    ThrowBallByKinematic()
                else
                    ThrowBallByInputTiming()
                end
                ballBoundCount = 0
            end
            impactGaugeStartTime = vci.me.Time
        end
    elseif string.startsWith(target, settings.standLightPrefix) then
        local light, index = StandLightFromName(target)
        cytanb.LogTrace('ungrab ', target, ', index = ', index, ', light = ', type(light))
        if light then
            local li = light.item
            local ls = light.status
            ls.grabbed = false
            if li.IsMine then
                local targets = {}
                targets[index] = {transform = cytanb.GetSubItemTransform(li)}
                cytanb.LogTrace('request build ', li.GetName(), ': index = ', index, ', position = ', li.GetPosition())
                cytanb.EmitMessage(buildStandLightMessageName, {targets = targets})
            end
        end
    elseif target == settingsPanel.GetName() then
        settingsPanelGrabbed = false
    end
end

function onUse (use)
    if not vciLoaded then
        return
    end

    if use == ball.GetName() then
        -- 入力タイミングのフェーズを進行する。
        -- ただし、運動による投球動作に入っている場合は、入力タイミングモードに移行しない。
        if ballGrabbed and impactPhase < 3 and not (impactPhase == 0 and IsInThrowingMotion()) then
            impactPhase = impactPhase + 1
            impactGaugeStartTime = vci.me.Time
        end
    elseif use == ballCup.GetName() then
        cupClickCount, cupClickTime = DetectClicks(cupClickCount, cupClickTime)
        cytanb.LogTrace('cupClickCount = ', cupClickCount)

        if cupClickCount == 1 then
            cytanb.EmitMessage(respawnBallMessageName)
        elseif cupClickCount == 2 then
            cytanb.EmitMessage(buildAllStandLightsMessageName)
        elseif cupClickCount == 3 then
            cytanb.EmitMessage(showSettingsPanelMessageName)
        end
    elseif use == closeSwitch.GetName() then
        if not settingsPanelGrabbed and settingsPanel.IsMine then
            settingsPanel.SetPosition(hiddenPosition)
        end
    elseif adjustmentSwitches[use] then
        adjustmentSwitches[use].DoInput(false)
    end
end

function onCollisionEnter (item, hit)
    if not vciLoaded then
        return
    end

    if item == ball.GetName() then
        if ball.IsMine and not ballGrabbed then
            if string.find(hit, settings.targetTag, 1, true) then
                EmitHitBall(hit)
            elseif not avatarColliderMap[hit] then
                -- ライトかアバターのコライダー以外に衝突した場合は、カウントアップする
                ballBoundCount = ballBoundCount + 1
                cytanb.LogTrace('ball bounds: hit = ', hit, ', boundCount = ', ballBoundCount)
            end
        end
    elseif string.startsWith(item, settings.standLightPrefix) then
        if string.find(hit, settings.targetTag, 1, true) then
            local light = StandLightFromName(item)
            if light and light.item.IsMine and not light.status.grabbed then
                EmitHitStandLight(light, hit)
            end
        end
    end
end
