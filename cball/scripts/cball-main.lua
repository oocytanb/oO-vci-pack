----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()math.randomseed(os.time()-os.clock()*10000)local b='__CYTANB_INSTANCE_ID'local c;local d;local a;local e=function(f,g)for h=1,4 do local i=f[h]-g[h]if i~=0 then return i end end;return 0 end;local j;j={__eq=function(f,g)return f[1]==g[1]and f[2]==g[2]and f[3]==g[3]and f[4]==g[4]end,__lt=function(f,g)return e(f,g)<0 end,__le=function(f,g)return e(f,g)<=0 end,__tostring=function(k)local l=k[2]or 0;local m=k[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(k[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(l,16),0xFFFF),bit32.band(l,0xFFFF),bit32.band(bit32.rshift(m,16),0xFFFF),bit32.band(m,0xFFFF),bit32.band(k[4]or 0,0xFFFFFFFF))end,__concat=function(f,g)local n=getmetatable(f)local o=n==j or type(n)=='table'and n.__concat==j.__concat;local p=getmetatable(g)local q=p==j or type(p)=='table'and p.__concat==j.__concat;if not o and not q then error('attempt to concatenate illegal values')end;return(o and j.__tostring(f)or f)..(q and j.__tostring(g)or g)end}local r='__CYTANB_CONST_VARIABLES'local s=function(table,t)local u=getmetatable(table)if u then local v=rawget(u,r)if v then local w=rawget(v,t)if type(w)=='function'then return w(table,t)else return w end end end;return nil end;local x=function(table,t,y)local u=getmetatable(table)if u then local v=rawget(u,r)if v then if rawget(v,t)~=nil then error('Cannot assign to read only field "'..t..'"')end end end;rawset(table,t,y)end;a={InstanceID=function()if d==''then d=vci.state.Get(b)or''end;return d end,SetConst=function(z,A,k)if type(z)~='table'then error('Cannot set const to non-table target')end;local B=getmetatable(z)local u=B or{}local C=rawget(u,r)if rawget(z,A)~=nil then error('Non-const field "'..A..'" already exists')end;if not C then C={}rawset(u,r,C)u.__index=s;u.__newindex=x end;rawset(C,A,k)if not B then setmetatable(z,u)end;return z end,SetConstEach=function(z,D)for E,y in pairs(D)do a.SetConst(z,E,y)end;return z end,Extend=function(z,F,G,H,I)if z==F or type(z)~='table'or type(F)~='table'then return z end;if G then if not I then I={}end;if I[F]then error('circular reference')end;I[F]=true end;for E,y in pairs(F)do if G and type(y)=='table'then local J=z[E]z[E]=a.Extend(type(J)=='table'and J or{},y,G,H,I)else z[E]=y end end;if not H then local K=getmetatable(F)if type(K)=='table'then if G then local L=getmetatable(z)setmetatable(z,a.Extend(type(L)=='table'and L or{},K,true))else setmetatable(z,K)end end end;if G then I[F]=nil end;return z end,Vars=function(y,M,N,I)local O;if M then O=M~='__NOLF'else M='  'O=true end;if not N then N=''end;if not I then I={}end;local P=type(y)if P=='table'then I[y]=I[y]and I[y]+1 or 1;local Q=O and N..M or''local R='('..tostring(y)..') {'local S=true;for t,T in pairs(y)do if S then S=false else R=R..(O and','or', ')end;if O then R=R..'\n'..Q end;if type(T)=='table'and I[T]and I[T]>0 then R=R..t..' = ('..tostring(T)..')'else R=R..t..' = '..a.Vars(T,M,Q,I)end end;if not S and O then R=R..'\n'..N end;R=R..'}'I[y]=I[y]-1;if I[y]<=0 then I[y]=nil end;return R elseif P=='function'or P=='thread'or P=='userdata'then return'('..P..')'elseif P=='string'then return'('..P..') '..string.format('%q',y)else return'('..P..') '..tostring(y)end end,GetLogLevel=function()return c end,SetLogLevel=function(U)c=U end,Log=function(U,...)if U<=c then local V=table.pack(...)if V.n==1 then local y=V[1]if y~=nil then print(type(y)=='table'and a.Vars(y)or tostring(y))else print('')end else local R=''for h=1,V.n do local y=V[h]if y~=nil then R=R..(type(y)=='table'and a.Vars(y)or tostring(y))end end;print(R)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(W,X)local table={}local Y=X==nil;for E,y in pairs(W)do table[y]=Y and y or X end;return table end,Round=function(Z,_)if _ then local a0=10^_;return math.floor(Z*a0+0.5)/a0 else return math.floor(Z+0.5)end end,Clamp=function(k,a1,a2)return math.max(a1,math.min(k,a2))end,Lerp=function(a3,a4,P)if P<=0.0 then return a3 elseif P>=1.0 then return a4 else return a3+(a4-a3)*P end end,LerpUnclamped=function(a3,a4,P)if P==0.0 then return a3 elseif P==1.0 then return a4 else return a3+(a4-a3)*P end end,PingPong=function(P,a5)if a5==0 then return 0 end;local a6=math.floor(P/a5)local a7=P-a6*a5;if a6<0 then if(a6+1)%2==0 then return a5-a7 else return a7 end else if a6%2==0 then return a7 else return a5-a7 end end end,QuaternionToAngleAxis=function(a8)local a6=a8.normalized;local a9=math.acos(a6.w)local aa=math.sin(a9)local ab=math.deg(a9*2.0)local ac;if math.abs(aa)<=Quaternion.kEpsilon then ac=Vector3.right else local ad=1.0/aa;ac=Vector3.__new(a6.x*ad,a6.y*ad,a6.z*ad)end;return ab,ac end,ApplyQuaternionToVector3=function(a8,ae)local af=a8.w*ae.x+a8.y*ae.z-a8.z*ae.y;local ag=a8.w*ae.y-a8.x*ae.z+a8.z*ae.x;local ah=a8.w*ae.z+a8.x*ae.y-a8.y*ae.x;local ai=-a8.x*ae.x-a8.y*ae.y-a8.z*ae.z;return Vector3.__new(ai*-a8.x+af*a8.w+ag*-a8.z-ah*-a8.y,ai*-a8.y-af*-a8.z+ag*a8.w+ah*-a8.x,ai*-a8.z+af*-a8.y-ag*-a8.x+ah*a8.w)end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(aj)return j.__tostring(aj)end,UUIDFromNumbers=function(...)local ak=...local P=type(ak)local al,am,an,ao;if P=='table'then al=ak[1]am=ak[2]an=ak[3]ao=ak[4]else al,am,an,ao=...end;local aj={bit32.band(al or 0,0xFFFFFFFF),bit32.band(am or 0,0xFFFFFFFF),bit32.band(an or 0,0xFFFFFFFF),bit32.band(ao or 0,0xFFFFFFFF)}setmetatable(aj,j)return aj end,UUIDFromString=function(R)local ap=string.len(R)if ap~=32 and ap~=36 then return nil end;local aq='[0-9a-f-A-F]+'local ar='^('..aq..')$'local as='^-('..aq..')$'local at,au,av,aw;if ap==32 then local aj=a.UUIDFromNumbers(0,0,0,0)local ax=1;for h,ay in ipairs({8,16,24,32})do at,au,av=string.find(string.sub(R,ax,ay),ar)if not at then return nil end;aj[h]=tonumber(av,16)ax=ay+1 end;return aj else at,au,av=string.find(string.sub(R,1,8),ar)if not at then return nil end;local al=tonumber(av,16)at,au,av=string.find(string.sub(R,9,13),as)if not at then return nil end;at,au,aw=string.find(string.sub(R,14,18),as)if not at then return nil end;local am=tonumber(av..aw,16)at,au,av=string.find(string.sub(R,19,23),as)if not at then return nil end;at,au,aw=string.find(string.sub(R,24,28),as)if not at then return nil end;local an=tonumber(av..aw,16)at,au,av=string.find(string.sub(R,29,36),ar)if not at then return nil end;local ao=tonumber(av,16)return a.UUIDFromNumbers(al,am,an,ao)end end,ParseUUID=function(R)return a.UUIDFromString(R)end,CreateCircularQueue=function(az)if type(az)~='number'or az<1 then error('Invalid argument: capacity = '..tostring(az))end;local self;local aA=math.floor(az)local aB={}local aC=0;local aD=0;local aE=0;self={Size=function()return aE end,Clear=function()aC=0;aD=0;aE=0 end,IsEmpty=function()return aE==0 end,Offer=function(aF)aB[aC+1]=aF;aC=(aC+1)%aA;if aE<aA then aE=aE+1 else aD=(aD+1)%aA end;return true end,OfferFirst=function(aF)aD=(aA+aD-1)%aA;aB[aD+1]=aF;if aE<aA then aE=aE+1 else aC=(aA+aC-1)%aA end;return true end,Poll=function()if aE==0 then return nil else local aF=aB[aD+1]aD=(aD+1)%aA;aE=aE-1;return aF end end,PollLast=function()if aE==0 then return nil else aC=(aA+aC-1)%aA;local aF=aB[aC+1]aE=aE-1;return aF end end,Peek=function()if aE==0 then return nil else return aB[aD+1]end end,PeekLast=function()if aE==0 then return nil else return aB[(aA+aC-1)%aA+1]end end,Get=function(aG)if aG<1 or aG>aE then a.LogError('CreateCircularQueue.Get: index is outside the range: '..aG)return nil end;return aB[(aD+aG-1)%aA+1]end,IsFull=function()return aE>=aA end,MaxSize=function()return aA end}return self end,ColorFromARGB32=function(aH)local aI=type(aH)=='number'and aH or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(aI,16),0xFF)/0xFF,bit32.band(bit32.rshift(aI,8),0xFF)/0xFF,bit32.band(aI,0xFF)/0xFF,bit32.band(bit32.rshift(aI,24),0xFF)/0xFF)end,ColorToARGB32=function(aJ)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*aJ.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*aJ.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*aJ.g),0xFF),8),bit32.band(a.Round(0xFF*aJ.b),0xFF))end,ColorFromIndex=function(aK,aL,aM,aN,aO)local aP=math.max(math.floor(aL or a.ColorHueSamples),1)local aQ=aO and aP or aP-1;local aR=math.max(math.floor(aM or a.ColorSaturationSamples),1)local aS=math.max(math.floor(aN or a.ColorBrightnessSamples),1)local aG=a.Clamp(math.floor(aK or 0),0,aP*aR*aS-1)local aT=aG%aP;local aU=math.floor(aG/aP)local ad=aU%aR;local aV=math.floor(aU/aR)if aO or aT~=aQ then local w=aT/aQ;local aW=(aR-ad)/aR;local y=(aS-aV)/aS;return Color.HSVToRGB(w,aW,y)else local y=(aS-aV)/aS*ad/(aR-1)return Color.HSVToRGB(0.0,0.0,y)end end,
GetSubItemTransform=function(aX)local aY=aX.GetPosition()local aZ=aX.GetRotation()local a_=aX.GetLocalScale()return{positionX=aY.x,positionY=aY.y,positionZ=aY.z,rotationX=aZ.x,rotationY=aZ.y,rotationZ=aZ.z,rotationW=aZ.w,scaleX=a_.x,scaleY=a_.y,scaleZ=a_.z}end,TableToSerializable=function(b0,I)if type(b0)~='table'then return b0 end;if not I then I={}end;if I[b0]then error('circular reference')end;I[b0]=true;local b1={}for E,y in pairs(b0)do local b2=type(E)=='number'and tostring(E)..a.ArrayNumberTag or E;if type(y)=='number'and y<0 then b1[tostring(b2)..a.NegativeNumberTag]=tostring(y)else b1[b2]=a.TableToSerializable(y,I)end end;I[b0]=nil;return b1 end,TableFromSerializable=function(b1)if type(b1)~='table'then return b1 end;local b0={}for E,y in pairs(b1)do local b2;local b3;if type(E)=='string'then if string.endsWith(E,a.NegativeNumberTag)then b2=string.sub(E,1,-1-#a.NegativeNumberTag)b3=true else b2=E;b3=false end;if string.endsWith(b2,a.ArrayNumberTag)then local b4=string.sub(b2,1,-1-#a.ArrayNumberTag)b2=tonumber(b4)or b4 end else b2=E;b3=false end;b0[b2]=b3 and type(y)=='string'and tonumber(y)or a.TableFromSerializable(y)end;return b0 end,TableToSerialiable=function(b0,I)return a.TableToSerializable(b0,I)end,TableFromSerialiable=function(b1)return a.TableFromSerializable(b1)end,EmitMessage=function(A,b5)local table=b5 and a.TableToSerializable(b5)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(A,json.serialize(table))end,OnMessage=function(A,b6)local b7=function(b8,b9,ba)local bb=nil;if b8.type~='comment'and type(ba)=='string'then local bc,b1=pcall(json.parse,ba)if bc and type(b1)=='table'then bb=a.TableFromSerializable(b1)end end;local b5=bb and bb or{[a.MessageValueParameterName]=ba}b6(b8,b9,b5)end;vci.message.On(A,b7)return{Off=function()if b7 then b7=nil end end}end,OnInstanceMessage=function(A,b6)local b7=function(b8,b9,b5)local bd=a.InstanceID()if bd~=''and bd==b5[a.InstanceIDParameterName]then b6(b8,b9,b5)end end;return a.OnMessage(A,b7)end}a.SetConstEach(a,{LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c=a.LogLevelInfo;package.loaded['cytanb']=a;d=vci.state.Get(b)or''if d==''and vci.assets.IsMine then d=tostring(a.RandomUUID())vci.state.Set(b,d)end;return a end)()

local DefaultClickTiming = TimeSpan.FromMilliseconds(500)
local DetectClicks = function (lastClickCount, lastTime, clickTiming)
    local count = lastClickCount and lastClickCount or 0
    local timing = clickTiming and clickTiming or DefaultClickTiming
    local now = vci.me.Time
    local result = (lastTime and lastTime + timing < now) and 1 or count + 1
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

local ApplyAltitudeAngle = function (vec, angle)
    local axis = Vector3.Cross(Vector3.up, vec)
    if axis == Vector3.zero then
        -- 垂直方向のベクトルであれば、元のベクトルを返す。
        return vec
    else
        return cytanb.ApplyQuaternionToVector3(Quaternion.AngleAxis(- angle, axis), vec)
    end
end

local settings = require('cball-settings').Load(_ENV)

local cballNS = 'com.github.oocytanb.oO-vci-pack.cball'
local respawnBallMessageName = cballNS .. '.respawn-ball'
local buildStandLightMessageName = cballNS .. '.build-standlight'
local jumpStandLightMessageName = cballNS .. '.jump-standlight'
local showSettingsPanelMessageName = cballNS .. '.show-settings-panel'

--- VCI がロードされたか。
local vciLoaded = false

local hiddenPosition

local ball, ballCup, standLights, impactForceGauge, impactSpinGauge, settingsPanel, closeSwitch, adjustmentSwitches

--- 設定パネルがつかまれているか。
local settingsPanelGrabbed = false

--- ボールがつかまれているか。
local ballGrabbed = false

--- ボールのトランスフォームのキュー。
local ballTransformQueue = cytanb.CreateCircularQueue(32)

--- ボールの角速度のシミュレーション値。
local ballSimAngularVelocity = Vector3.zero

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
end

local CreateAdjustmentSwitch = function (switchName, knobName, propertyName)
    local knob = vci.assets.GetSubItem(knobName)
    local initialKnobPosition = knob.GetLocalPosition()
    local inputCount = math.floor(cytanb.Clamp(settings[propertyName], -5, 5))

    local UpdateKnob = function ()
        local value = cytanb.PingPong(inputCount + 5, 10) - 5
        knob.SetLocalPosition(Vector3.__new(initialKnobPosition.x, settings.settingsPanelAdjustmentSwitchNeutralPositionY + value * settings.settingsPanelAdjustmentSwitchDivisionScale, initialKnobPosition.z))
        return value
    end

    UpdateKnob()

    local self
    self = {
        item = vci.assets.GetSubItem(switchName),
        DoInput = function ()
            inputCount = inputCount + 1
            local value = UpdateKnob()
            settings[propertyName] = value
            cytanb.LogTrace('on DoInput[', switchName, ']: value = ', value, ', count = ', inputCount)
            return value
        end
    }
    return self
end

local CalcAdjustment = function (adjustmentValue, min, max)
    -- max - min を 100% とし、中央値に adjustmentValue の 20% を加える。
    return min + (max - min) * 0.5 * cytanb.Clamp(1 + adjustmentValue * 0.2, 0.0, 2.0)
end

local OfferBallTransform = function (position, rotation, time)
    ballTransformQueue.Offer({position = position, rotation = rotation, time = time or vci.me.Time})
end

local StandLightFromName = function (name)
    local indexStr = string.sub(name, #settings.standLightPrefix + 1)
    local num = tonumber(indexStr)
    local index = num and math.floor(num) + 1 or -1
    if index >= 1 and index <= settings.standLightCount then
        return standLights[index], index
    else
        return nil, index
    end
end

-- 「ボールが当たったみたい。私、飛ばなきゃ！えいっ！ ＞＜」
local JumpStandLight = function (light)
    local li = light.item
    local ls = light.status
    local now = vci.me.Time
    if li.IsMine and ls.jumpTime + settings.standLightRequestIntervalTime < now and IsHorizontalAttitude(li.GetRotation(), Vector3.up, settings.standLightHorizontalAttitudeThreshold) then
        ls.jumpTime = now
        local rx = math.random()
        local dx = (rx * 2 >= 1 and 1 or -1) * (rx * 0.2 + 0.1)
        local rz = math.random()
        local dz = (rz * 2 >= 1 and 1 or -1) * (rz * 0.2 + 0.1)
        local direction = Vector3.__new(dx, 1.0, dz)
        cytanb.LogTrace(li.GetName(), ' jumps: ', direction)
        li.AddForce(direction * settings.standLightJumpFactor)
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

--- ボールをカップへ戻す。
local RespawnBall = function ()
    ResetGauge()

    if ballCup.IsMine and not cupGrabbed and not IsHorizontalAttitude(ballCup.GetRotation()) then
        cytanb.LogTrace('reset cup rotation')
        ballCup.SetRotation(Quaternion.identity)
    end

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

--- コントローラーの運動による投球
local ThrowBallByKinematic = function ()
    if not ball.IsMine then
        return
    end

    local now = vci.me.Time
    local ballPos = ball.GetPosition()
    local ballRot = ball.GetRotation()

    if not ballTransformQueue.IsEmpty() then
        local totalVelocity = Vector3.zero
        local totalAngularVelocity = Vector3.zero

        local st = now
        local sp = ballPos
        local sr = ballRot

        while true do
            local element = ballTransformQueue.PollLast()
            if not element then
                break
            end

            if now - element.time > settings.ballKinematicTime then
                break
            end

            local deltaSec = (st - element.time).totalSeconds
            if deltaSec > Vector3.kEpsilon then
                -- 古いデータほど係数を下げる
                local deltaVelocityFactor = math.max(0.0, 1.0 - (now - st).totalSeconds * 1.25)
                cytanb.LogTrace('deltaVelocityFactor = ', deltaVelocityFactor)

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

            cytanb.LogTrace('totalVelocity: ', totalVelocity, ', totalAngularVelocity: ', totalAngularVelocity)

            st = element.time
            sp = element.position
            sr = element.rotation
        end
        ballTransformQueue.Clear()

        totalVelocity = totalVelocity * CalcAdjustment(settings.ballVelocityAdjustment, settings.ballKinematicMinVelocityFactor, settings.ballKinematicMaxVelocityFactor)
        totalAngularVelocity = totalAngularVelocity * CalcAdjustment(settings.ballAngularVelocityAdjustment, settings.ballKinematicMinAngularVelocityFactor, settings.ballKinematicMaxAngularVelocityFactor)

        local velocityMagnitude = totalVelocity.magnitude
        cytanb.LogTrace('velocity magnitude: ', velocityMagnitude)
        if velocityMagnitude > settings.ballKinematicVelocityThreshold then
            local velocity = ApplyAltitudeAngle(totalVelocity, CalcAdjustment(settings.ballAltitudeAdjustment, settings.ballKinematicMinAltitudeFactor, settings.ballKinematicMaxAltitudeFactor))
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
    local forwardScale = CalcAdjustment(settings.ballVelocityAdjustment, settings.ballInpactMinVelocityScale, settings.ballInpactMaxVelocityScale) * impactForceGaugeRatio
    local forwardOffset = forward * math.min(forwardScale * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset)
    local velocity = ApplyAltitudeAngle(forward * forwardScale, CalcAdjustment(settings.ballAltitudeAdjustment, settings.ballInpactMinAltitudeScale, settings.ballInpactMaxAltitudeScale))

    ballSimAngularVelocity = Vector3.up * (CalcAdjustment(settings.ballAngularVelocityAdjustment, settings.ballInpactMinAngularVelocityScale, settings.ballInpactMaxAngularVelocityScale) * math.pi * impactSpinGaugeRatio)
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
    ballCup = vci.assets.GetSubItem(settings.ballCupName)

    standLights = {}
    for i = 1, settings.standLightCount do
        local item = vci.assets.GetSubItem(settings.standLightPrefix .. (i - 1))
        standLights[i] = {
            item = item,
            status = {
                respawnPosition = item.GetPosition(),
                active = true,
                inactiveTime = TimeSpan.Zero,
                jumpTime = TimeSpan.Zero
            }
        }
    end

    impactForceGauge = vci.assets.GetSubItem(settings.impactForceGaugeName)
    impactForceGauge.SetPosition(hiddenPosition)

    impactSpinGauge = vci.assets.GetSubItem(settings.impactSpinGaugeName)
    impactSpinGauge.SetPosition(hiddenPosition)

    settingsPanel = vci.assets.GetSubItem(settings.settingsPanelName)

    closeSwitch = vci.assets.GetSubItem(settings.closeSwitchName)

    adjustmentSwitches = {}
    for index, entry in ipairs(settings.adjustmentSwitchNames) do
        adjustmentSwitches[entry.switchName] = CreateAdjustmentSwitch(entry.switchName, entry.knobName, entry.propertyName)
    end

    cytanb.OnInstanceMessage(respawnBallMessageName, function (sender, name, parameterMap)
        RespawnBall()
    end)

    -- ライトを組み立てる。
    cytanb.OnInstanceMessage(buildStandLightMessageName, function (sender, name, parameterMap)
        cytanb.LogDebug('onBuildStandLight')

        local targets = parameterMap.targets
        -- targets が指定されていない場合は、すべてが対象
        local allTargets = not parameterMap.targets

        for i = 1, settings.standLightCount do
            if allTargets or targets[i] then
                local light = standLights[i]
                local li = light.item
                local ls = light.status
                local transform = targets and targets[i] and targets[i].transform
                if transform then
                    -- transform が指定されていた場合は、respawnPosition を変更する。
                    ls.respawnPosition = Vector3.__new(transform.positionX, transform.positionY >= 0 and transform.positionY or 0.25, transform.positionZ)
                end
                ls.active = true
                ls.inactiveTime = vci.me.Time
                ls.jumpTime = TimeSpan.Zero
                if li.IsMine then
                    li.SetRotation(Quaternion.identity)
                    li.SetPosition(ls.respawnPosition)
                    li.SetVelocity(Vector3.zero)
                    li.SetAngularVelocity(Vector3.zero)
                end
            end
        end
    end)

    -- ライトをジャンプさせる
    cytanb.OnInstanceMessage(jumpStandLightMessageName, function (sender, name, parameterMap)
        local targets = parameterMap.targets
        if targets then
            for i, v in pairs(targets) do
                if i <= settings.standLightCount and v then
                    cytanb.LogDebug('onJumpStandLight: index = ', i)
                    JumpStandLight(standLights[i])
                end
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
    if not ball.IsMine then
        return
    end

    local ballPos = ball.GetPosition()
    local ballRot = ball.GetRotation()
    local respawned = false

    if not ballGrabbed and not ballTransformQueue.IsEmpty() then
        local lastTransform = ballTransformQueue.PollLast()
        -- カップとの距離が離れていたら、ボールが転がっているものとして処理する
        local cupDistance = (ballPos - ballCup.GetPosition()).magnitude
        if cupDistance > settings.ballActiveThreshold then
            if vci.me.Time <= impactGaugeStartTime + settings.ballWaitingTime and cupDistance <= settings.ballPlayAreaRadius then
                -- ボールの前回位置と現在位置から速度を計算する
                local deltaSec = deltaTime.TotalSeconds
                local velocity = (ballPos - lastTransform.position) / deltaSec

                -- 角速度を計算する
                ballSimAngularVelocity = ballSimAngularVelocity * (1.0 - math.min(1.0, settings.ballSimAngularDrag * deltaSec))
                local angularVelocityMagnitude = ballSimAngularVelocity.magnitude
                if angularVelocityMagnitude <= 0.05 then
                    ballSimAngularVelocity = Vector3.zero
                    angularVelocityMagnitude = 0
                end

                -- スピンを適用する処理
                local horzVelocity = Vector3.__new(velocity.x, 0, velocity.z)
                local velocityMagnitude = horzVelocity.magnitude
                if velocityMagnitude > 0.0025 and angularVelocityMagnitude ~= 0 then
                    -- 水平方向の力を計算する
                    local vcr = Vector3.__new(0, ballSimAngularVelocity.y, 0)
                    local vo = Vector3.Cross(vcr * (settings.ballSimAngularFactor * settings.ballSimMass / deltaSec), horzVelocity / velocityMagnitude)
                    local vca = Vector3.__new(vo.x, 0, vo.z)
                    ball.AddForce(vca)
                    -- cytanb.LogTrace('vca: ', vca, ', vo: ', vo, ', velocity: ', velocity)
                end

                -- local velocityMagnitude = velocity.magnitude
                -- if velocityMagnitude > 0.0025 and angularVelocityMagnitude ~= 0 then
                --     local vo = Vector3.Cross(ballSimAngularVelocity * (settings.ballSimAngularFactor * settings.ballSimMass / deltaSec), velocity / velocityMagnitude)
                --     local vca = Vector3.__new(vo.x, 0, vo.z)
                --     ball.AddForce(vca)
                --     -- cytanb.LogTrace('vca: ', vca, ', vo: ', vo, ', velocity: ', velocity)
                -- end

                -- local horzVelocity = Vector3.__new(velocity.x, 0, velocity.z)
                -- if horzVelocity.sqrMagnitude > 0.0025 and angularVelocityMagnitude ~= 0 then
                --     local vo = cytanb.ApplyQuaternionToVector3(Quaternion.AngleAxis(ballSimAngularVelocity.y >= 0 and 90 or -90, Vector3.up), horzVelocity).normalized
                --     local curveScale = settings.ballSimAngularFactor * settings.ballSimMass * math.abs(ballSimAngularVelocity.y) / deltaSec
                --     local vca = vo * curveScale
                --     ball.AddForce(vca)
                --     cytanb.LogTrace('velocity: ', velocity, ', horz: ', horzVelocity, ', vo: ', vo, ', angularVelocity: ', ballSimAngularVelocity)
                --     cytanb.LogTrace('curveScale: ', curveScale, ', vca: ', vca)
                -- end

                -- 床抜けの対策。
                if ballPos.y < 0 and ballPos.y < lastTransform.position.y then
                    local leapY = 0.25 - ballPos.y
                    local leapV = Vector3.__new(0, leapY / (deltaSec ^ 2), 0)
                    cytanb.LogDebug('leap ball: position = ', ballPos, ', leapY = ', leapY, ', force = ', leapV)
                    ball.SetPosition(Vector3.__new(ballPos.x, 0.125, ballPos.z))
                    ball.AddForce(leapV)
                end
            elseif not cupGrabbed then
                -- タイムアウトしたかエリア外に出たボールをカップへ戻す。
                cytanb.LogTrace('elapsed: ' , (vci.me.Time - impactGaugeStartTime).TotalSeconds, ', distance: ', cupDistance)
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
    if not vci.assets.IsMine then
        return
    end

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
            if ls.active then
                -- 倒れたことを検知した
                cytanb.TraceLog('change standLight[', i, '] state to inactive')
                ls.active = false
                ls.inactiveTime = vci.me.Time
            elseif ls.inactiveTime + settings.standLightWaitingTime < vci.me.Time then
                -- 倒れてから時間経過したので、復活させる。
                needBuilding = true
                targets[i] = {}
                -- cytanb.LogTrace('need building: standLight[', i, ']')
            end
        end
    end

    if needBuilding and standLightsLastRequestTime + settings.standLightRequestIntervalTime < vci.me.Time then
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
    local frameCount = 0
    while true do
        local id = cytanb.InstanceID()
        if id ~= '' then
            break
        end

        if vci.me.Time > startTime + MaxWaitTime then
            cytanb.LogError('Timeout: Could not receive Instance ID.')
            return -1
        end

        frameCount = frameCount + 1
        coroutine.yield(100)
    end

    if frameCount <= 0 then
        -- VCI アイテムを出して 1 フレーム目の update 後に、onUngrab が発生するのを待つ。
        frameCount = frameCount + 1
        coroutine.yield(100)
    end

    -- ロード完了。
    OnLoad()
    frameCount = frameCount + 1
    coroutine.yield(100)

    -- メッセージループ。
    local lastTime = vci.me.Time
    while true do
        local time = vci.me.Time
        local delta = time - lastTime
        OnUpdate(delta > TimeSpan.Zero and delta or TimeSpan.FromTicks(100))
        lastTime = time
        frameCount = frameCount + 1
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
    end
end

function onUngrab (target)
    if not vciLoaded then
        return
    end

    if target == ballCup.GetName() then
        cupGrabbed = false
    elseif target == ball.GetName() then
        if ballGrabbed then
            ballGrabbed = false
            if ball.IsMine then
                if impactPhase == 0 then
                    ThrowBallByKinematic()
                else
                    ThrowBallByInputTiming()
                end
            end
            impactGaugeStartTime = vci.me.Time
        end
    elseif string.startsWith(target, settings.standLightPrefix) then
        local light, index = StandLightFromName(target)
        cytanb.LogTrace('ungrab ', target, ', index = ', index, ', light = ', type(light))
        if light then
            local li = light.item
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
        if ballGrabbed and impactPhase < 3 then
            impactPhase = impactPhase + 1
            impactGaugeStartTime = vci.me.Time
        end
    elseif use == ballCup.GetName() then
        cupClickCount, cupClickTime = DetectClicks(cupClickCount, cupClickTime)
        cytanb.LogTrace('cupClickCount = ', cupClickCount)

        if cupClickCount == 1 then
            cytanb.EmitMessage(respawnBallMessageName)
        elseif cupClickCount == 2 then
            cytanb.EmitMessage(buildStandLightMessageName, {})
        elseif cupClickCount == 3 then
            cytanb.EmitMessage(showSettingsPanelMessageName)
        end
    elseif use == closeSwitch.GetName() then
        if not settingsPanelGrabbed and settingsPanel.IsMine then
            settingsPanel.SetPosition(hiddenPosition)
        end
    elseif adjustmentSwitches[use] then
        adjustmentSwitches[use].DoInput()
    end
end

function onCollisionEnter (item, hit)
    if not vciLoaded then
        return
    end

    if item == ball.GetName() then
        if string.startsWith(hit, settings.standLightPrefix) then
            cytanb.LogTrace('onCollisionEnter: item = ', item, ', hit = ', hit)
            local light, index = StandLightFromName(hit)
            if light then
                local li = light.item
                if ball.IsMine and not li.IsMine then
                    -- ライトとボールの操作権が別ユーザーであれば、位置の同期のタイミングによっては、
                    -- ライト側で衝突イベントが発生しないため、メッセージで送る。
                    local targets = {}
                    targets[index] = true
                    cytanb.EmitMessage(jumpStandLightMessageName, {targets = targets})
                end
            end
        end
    elseif string.startsWith(item, settings.standLightPrefix) and string.find(hit, settings.ballTag, 1, true) then
        cytanb.LogTrace('onCollisionEnter: item = ', item, ', hit = ', hit)
        local light = StandLightFromName(item)
        if light then
            local li = light.item
            if li.IsMine and (not ball.IsMine or hit ~= ball.GetName()) then
                -- ライトとボールの操作権が別ユーザーか、別 VCI のボールであれば、自力で飛ぶ。
                JumpStandLight(light)
            end
        end
    end
end
