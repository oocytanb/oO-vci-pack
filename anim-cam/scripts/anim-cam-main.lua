--[[
MIT License

Copyright (c) 2019 oO (https://github.com/oocytanb)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

--- カメラのアニメーションやオブジェクトの設定。構成に合わせてカスタマイズする。
local conf = {
    --- カメラのコンテナーのオブジェクト名。
    camContainerName = 'anim-cam-container',

    --- カメラのマーカーのオブジェクト名。
    camMarkerName = 'anim-cam-marker',

    --- 再生スイッチのオブジェクト名。
    camSwitchName = 'anim-cam-switch',

    --- カメラのアニメーションの再生方法の指示。
    ---   type: 指示のタイプを指定する。('play': アニメーションを再生する。)
    ---   name: アニメーションクリップの名前を指定する。
    ---   length: アニメーションクリップの長さを TimeSpan で指定する。省略した場合は再生を終了しない。
    ---   loop: アニメーションをループ再生するかを指定する。省略した場合はループ再生しない。(true | false)
    ---
    --- 連続してアニメーションクリップを再生する例:
    --- ```
    --- directives = {
    ---     {type = 'play', name = 'anim-cam-clip-0', length = TimeSpan.FromSeconds(16)},
    ---     {type = 'play', name = 'anim-cam-clip-1', length = TimeSpan.FromSeconds(31)}
    --- },
    --- ```
    directives = {
       {type = 'play', name = 'anim-cam-clip-0', loop = true}
    },

    --- ロード時に自動的に再生を開始するかを指定する。(true | false)
    --- true を指定すると、アイテムを設置・削除で、アニメーションの再生・停止を切り替えるような使い方が出来る。
    playOnLoad = false,

    --- カメラをつかんだ時に、再生を停止するかを指定する。(true | false)
    stopOnCameraGrabbed = true,

    --- 操作するカメラの名前。('HandiCamera' | 'AutoFollowCamera' | 'SwitchingCamera' | 'WindowCamera')
    systemCamName = 'HandiCamera',

    --- カメラのコンテナーオブジェクトの初期位置をワールド座標へセットするかを指定する。(true | false)
    --- アイテムを設置した位置を初期位置とする場合は、false を指定する。
    camContainerTransformToWorld = true
}

---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()math.randomseed(os.time()-os.clock()*10000)local b='__CYTANB_INSTANCE_ID'local c;local d;local a;local e=function(f,g)for h=1,4 do local i=f[h]-g[h]if i~=0 then return i end end;return 0 end;local j;j={__eq=function(f,g)return f[1]==g[1]and f[2]==g[2]and f[3]==g[3]and f[4]==g[4]end,__lt=function(f,g)return e(f,g)<0 end,__le=function(f,g)return e(f,g)<=0 end,__tostring=function(k)local l=k[2]or 0;local m=k[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(k[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(l,16),0xFFFF),bit32.band(l,0xFFFF),bit32.band(bit32.rshift(m,16),0xFFFF),bit32.band(m,0xFFFF),bit32.band(k[4]or 0,0xFFFFFFFF))end,__concat=function(f,g)local n=getmetatable(f)local o=n==j or type(n)=='table'and n.__concat==j.__concat;local p=getmetatable(g)local q=p==j or type(p)=='table'and p.__concat==j.__concat;if not o and not q then error('attempt to concatenate illegal values')end;return(o and j.__tostring(f)or f)..(q and j.__tostring(g)or g)end}local r='__CYTANB_CONST_VARIABLES'local s=function(table,t)local u=getmetatable(table)if u then local v=rawget(u,r)if v then local w=rawget(v,t)if type(w)=='function'then return w(table,t)else return w end end end;return nil end;local x=function(table,t,y)local u=getmetatable(table)if u then local v=rawget(u,r)if v then if rawget(v,t)~=nil then error('Cannot assign to read only field "'..t..'"')end end end;rawset(table,t,y)end;a={InstanceID=function()if d==''then d=vci.state.Get(b)or''end;return d end,SetConst=function(z,A,k)if type(z)~='table'then error('Cannot set const to non-table target')end;local B=getmetatable(z)local u=B or{}local C=rawget(u,r)if rawget(z,A)~=nil then error('Non-const field "'..A..'" already exists')end;if not C then C={}rawset(u,r,C)u.__index=s;u.__newindex=x end;rawset(C,A,k)if not B then setmetatable(z,u)end;return z end,SetConstEach=function(z,D)for E,y in pairs(D)do a.SetConst(z,E,y)end;return z end,Extend=function(z,F,G,H,I)if z==F or type(z)~='table'or type(F)~='table'then return z end;if G then if not I then I={}end;if I[F]then error('circular reference')end;I[F]=true end;for E,y in pairs(F)do if G and type(y)=='table'then local J=z[E]z[E]=a.Extend(type(J)=='table'and J or{},y,G,H,I)else z[E]=y end end;if not H then local K=getmetatable(F)if type(K)=='table'then if G then local L=getmetatable(z)setmetatable(z,a.Extend(type(L)=='table'and L or{},K,true))else setmetatable(z,K)end end end;if G then I[F]=nil end;return z end,Vars=function(y,M,N,I)local O;if M then O=M~='__NOLF'else M='  'O=true end;if not N then N=''end;if not I then I={}end;local P=type(y)if P=='table'then I[y]=I[y]and I[y]+1 or 1;local Q=O and N..M or''local R='('..tostring(y)..') {'local S=true;for t,T in pairs(y)do if S then S=false else R=R..(O and','or', ')end;if O then R=R..'\n'..Q end;if type(T)=='table'and I[T]and I[T]>0 then R=R..t..' = ('..tostring(T)..')'else R=R..t..' = '..a.Vars(T,M,Q,I)end end;if not S and O then R=R..'\n'..N end;R=R..'}'I[y]=I[y]-1;if I[y]<=0 then I[y]=nil end;return R elseif P=='function'or P=='thread'or P=='userdata'then return'('..P..')'elseif P=='string'then return'('..P..') '..string.format('%q',y)else return'('..P..') '..tostring(y)end end,GetLogLevel=function()return c end,SetLogLevel=function(U)c=U end,Log=function(U,...)if U<=c then local V=table.pack(...)if V.n==1 then local y=V[1]if y~=nil then print(type(y)=='table'and a.Vars(y)or tostring(y))else print('')end else local R=''for h=1,V.n do local y=V[h]if y~=nil then R=R..(type(y)=='table'and a.Vars(y)or tostring(y))end end;print(R)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(W,X)local table={}local Y=X==nil;for E,y in pairs(W)do table[y]=Y and y or X end;return table end,Round=function(Z,_)if _ then local a0=10^_;return math.floor(Z*a0+0.5)/a0 else return math.floor(Z+0.5)end end,Clamp=function(k,a1,a2)return math.max(a1,math.min(k,a2))end,Lerp=function(a3,a4,P)if P<=0.0 then return a3 elseif P>=1.0 then return a4 else return a3+(a4-a3)*P end end,LerpUnclamped=function(a3,a4,P)if P==0.0 then return a3 elseif P==1.0 then return a4 else return a3+(a4-a3)*P end end,PingPong=function(P,a5)if a5==0 then return 0 end;local a6=math.floor(P/a5)local a7=P-a6*a5;if a6<0 then if(a6+1)%2==0 then return a5-a7 else return a7 end else if a6%2==0 then return a7 else return a5-a7 end end end,QuaternionToAngleAxis=function(a8)local a6=a8.normalized;local a9=math.acos(a6.w)local aa=math.sin(a9)local ab=math.deg(a9*2.0)local ac;if math.abs(aa)<=Quaternion.kEpsilon then ac=Vector3.right else local ad=1.0/aa;ac=Vector3.__new(a6.x*ad,a6.y*ad,a6.z*ad)end;return ab,ac end,ApplyQuaternionToVector3=function(a8,ae)local af=a8.w*ae.x+a8.y*ae.z-a8.z*ae.y;local ag=a8.w*ae.y-a8.x*ae.z+a8.z*ae.x;local ah=a8.w*ae.z+a8.x*ae.y-a8.y*ae.x;local ai=-a8.x*ae.x-a8.y*ae.y-a8.z*ae.z;return Vector3.__new(ai*-a8.x+af*a8.w+ag*-a8.z-ah*-a8.y,ai*-a8.y-af*-a8.z+ag*a8.w+ah*-a8.x,ai*-a8.z+af*-a8.y-ag*-a8.x+ah*a8.w)end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(aj)return j.__tostring(aj)end,UUIDFromNumbers=function(...)local ak=...local P=type(ak)local al,am,an,ao;if P=='table'then al=ak[1]am=ak[2]an=ak[3]ao=ak[4]else al,am,an,ao=...end;local aj={bit32.band(al or 0,0xFFFFFFFF),bit32.band(am or 0,0xFFFFFFFF),bit32.band(an or 0,0xFFFFFFFF),bit32.band(ao or 0,0xFFFFFFFF)}setmetatable(aj,j)return aj end,UUIDFromString=function(R)local ap=string.len(R)if ap~=32 and ap~=36 then return nil end;local aq='[0-9a-f-A-F]+'local ar='^('..aq..')$'local as='^-('..aq..')$'local at,au,av,aw;if ap==32 then local aj=a.UUIDFromNumbers(0,0,0,0)local ax=1;for h,ay in ipairs({8,16,24,32})do at,au,av=string.find(string.sub(R,ax,ay),ar)if not at then return nil end;aj[h]=tonumber(av,16)ax=ay+1 end;return aj else at,au,av=string.find(string.sub(R,1,8),ar)if not at then return nil end;local al=tonumber(av,16)at,au,av=string.find(string.sub(R,9,13),as)if not at then return nil end;at,au,aw=string.find(string.sub(R,14,18),as)if not at then return nil end;local am=tonumber(av..aw,16)at,au,av=string.find(string.sub(R,19,23),as)if not at then return nil end;at,au,aw=string.find(string.sub(R,24,28),as)if not at then return nil end;local an=tonumber(av..aw,16)at,au,av=string.find(string.sub(R,29,36),ar)if not at then return nil end;local ao=tonumber(av,16)return a.UUIDFromNumbers(al,am,an,ao)end end,ParseUUID=function(R)return a.UUIDFromString(R)end,CreateCircularQueue=function(az)if type(az)~='number'or az<1 then error('Invalid argument: capacity = '..tostring(az))end;local self;local aA=math.floor(az)local aB={}local aC=0;local aD=0;local aE=0;self={Size=function()return aE end,Clear=function()aC=0;aD=0;aE=0 end,IsEmpty=function()return aE==0 end,Offer=function(aF)aB[aC+1]=aF;aC=(aC+1)%aA;if aE<aA then aE=aE+1 else aD=(aD+1)%aA end;return true end,OfferFirst=function(aF)aD=(aA+aD-1)%aA;aB[aD+1]=aF;if aE<aA then aE=aE+1 else aC=(aA+aC-1)%aA end;return true end,Poll=function()if aE==0 then return nil else local aF=aB[aD+1]aD=(aD+1)%aA;aE=aE-1;return aF end end,PollLast=function()if aE==0 then return nil else aC=(aA+aC-1)%aA;local aF=aB[aC+1]aE=aE-1;return aF end end,Peek=function()if aE==0 then return nil else return aB[aD+1]end end,PeekLast=function()if aE==0 then return nil else return aB[(aA+aC-1)%aA+1]end end,Get=function(aG)if aG<1 or aG>aE then a.LogError('CreateCircularQueue.Get: index is outside the range: '..aG)return nil end;return aB[(aD+aG-1)%aA+1]end,IsFull=function()return aE>=aA end,MaxSize=function()return aA end}return self end,ColorFromARGB32=function(aH)local aI=type(aH)=='number'and aH or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(aI,16),0xFF)/0xFF,bit32.band(bit32.rshift(aI,8),0xFF)/0xFF,bit32.band(aI,0xFF)/0xFF,bit32.band(bit32.rshift(aI,24),0xFF)/0xFF)end,ColorToARGB32=function(aJ)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*aJ.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*aJ.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*aJ.g),0xFF),8),bit32.band(a.Round(0xFF*aJ.b),0xFF))end,ColorFromIndex=function(aK,aL,aM,aN,aO)local aP=math.max(math.floor(aL or a.ColorHueSamples),1)local aQ=aO and aP or aP-1;local aR=math.max(math.floor(aM or a.ColorSaturationSamples),1)local aS=math.max(math.floor(aN or a.ColorBrightnessSamples),1)local aG=a.Clamp(math.floor(aK or 0),0,aP*aR*aS-1)local aT=aG%aP;local aU=math.floor(aG/aP)local ad=aU%aR;local aV=math.floor(aU/aR)if aO or aT~=aQ then local w=aT/aQ;local aW=(aR-ad)/aR;local y=(aS-aV)/aS;return Color.HSVToRGB(w,aW,y)else local y=(aS-aV)/aS*ad/(aR-1)return Color.HSVToRGB(0.0,0.0,y)end end,
GetSubItemTransform=function(aX)local aY=aX.GetPosition()local aZ=aX.GetRotation()local a_=aX.GetLocalScale()return{positionX=aY.x,positionY=aY.y,positionZ=aY.z,rotationX=aZ.x,rotationY=aZ.y,rotationZ=aZ.z,rotationW=aZ.w,scaleX=a_.x,scaleY=a_.y,scaleZ=a_.z}end,TableToSerializable=function(b0,I)if type(b0)~='table'then return b0 end;if not I then I={}end;if I[b0]then error('circular reference')end;I[b0]=true;local b1={}for E,y in pairs(b0)do local b2=type(E)=='number'and tostring(E)..a.ArrayNumberTag or E;if type(y)=='number'and y<0 then b1[tostring(b2)..a.NegativeNumberTag]=tostring(y)else b1[b2]=a.TableToSerializable(y,I)end end;I[b0]=nil;return b1 end,TableFromSerializable=function(b1)if type(b1)~='table'then return b1 end;local b0={}for E,y in pairs(b1)do local b2;local b3;if type(E)=='string'then if string.endsWith(E,a.NegativeNumberTag)then b2=string.sub(E,1,-1-#a.NegativeNumberTag)b3=true else b2=E;b3=false end;if string.endsWith(b2,a.ArrayNumberTag)then local b4=string.sub(b2,1,-1-#a.ArrayNumberTag)b2=tonumber(b4)or b4 end else b2=E;b3=false end;b0[b2]=b3 and type(y)=='string'and tonumber(y)or a.TableFromSerializable(y)end;return b0 end,TableToSerialiable=function(b0,I)return a.TableToSerializable(b0,I)end,TableFromSerialiable=function(b1)return a.TableFromSerializable(b1)end,EmitMessage=function(A,b5)local table=b5 and a.TableToSerializable(b5)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(A,json.serialize(table))end,OnMessage=function(A,b6)local b7=function(b8,b9,ba)local bb=nil;if b8.type~='comment'and type(ba)=='string'then local bc,b1=pcall(json.parse,ba)if bc and type(b1)=='table'then bb=a.TableFromSerializable(b1)end end;local b5=bb and bb or{[a.MessageValueParameterName]=ba}b6(b8,b9,b5)end;vci.message.On(A,b7)return{Off=function()if b7 then b7=nil end end}end,OnInstanceMessage=function(A,b6)local b7=function(b8,b9,b5)local bd=a.InstanceID()if bd~=''and bd==b5[a.InstanceIDParameterName]then b6(b8,b9,b5)end end;return a.OnMessage(A,b7)end}a.SetConstEach(a,{LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c=a.LogLevelInfo;package.loaded['cytanb']=a;d=vci.state.Get(b)or''if d==''and vci.assets.IsMine then d=tostring(a.RandomUUID())vci.state.Set(b,d)end;return a end)()

local animCamNS = 'com.github.oocytanb.oO-vci-pack.anim-cam'
local togglePlayMessageName = animCamNS .. '.toggle-play'

---@class DirectiveProcessorState DirectiveProcessor の状態。
---@field stop number @停止している。
---@field processing number @処理中である。
local DirectiveProcessorState = cytanb.SetConstEach({}, {
    stop = 0,
    processing = 1
})

---@class DirectiveProcessor @ディレクティブのプロセッサー。
---@field Start fun (): boolean @ディレクティブの最初のエントリーから開始する。また、その成否を返す。
---@field Stop fun (): boolean @処理を停止する。また、その成否を返す。
---@field Update fun () @処理を更新する。
---@field GetState fun (): DirectiveProcessorState @現在の状態を取得する。

---@return DirectiveProcessor
local CreateDirectiveProcessor = function (directives, animator, camMarker, stopOnCameraGrabbed, systemCamName)
    local systemCameraGetters = {
        HandiCamera = vci.studio.GetHandiCamera,
        AutoFollowCamera = vci.studio.GetAutoFollowCamera,
        SwitchingCamera = vci.studio.GetSwitchingCamera,
        WindowCamera = vci.studio.GetWindowCamera
    }

    if not systemCamName then
        systemCamName = 'HandiCamera'
    end

    local systemCam = nil
    local currentIndex = -1
    local entryExpectedTime = TimeSpan.MaxValue
    local state = DirectiveProcessorState.stop

    local ProcessEntry = function (index)
        local dir = directives[index]
        if not dir then
            return DirectiveProcessorState.stop, TimeSpan.MaxValue
        end

        if dir.type == 'play' then
            if not dir.name then
                cytanb.LogError('Invalid directive parameter: animation clip name is not specified')
                return DirectiveProcessorState.stop, TimeSpan.MaxValue
            end

            animator._ALL_PlayFromName(dir.name, not not dir.loop)
            local expectedTime = dir.length and vci.me.time + dir.length or TimeSpan.MaxValue
            return DirectiveProcessorState.processing, expectedTime
        else
            cytanb.LogError('Unsupported directive: ', dir.type)
            return DirectiveProcessorState.stop, TimeSpan.MaxValue
        end
    end

    local self
    self = {
        Start = function ()
            if not vci.assets.IsMine then
                cytanb.LogError('Unexpected: not vci.assets.IsMine')
                return false
            end

            self.Stop()

            systemCam = systemCameraGetters[systemCamName]()
            if not systemCam then
                cytanb.LogWarn('SYSTEM_CAMERA_NOT_FOUND: ', systemCamName)
                return false
            end

            currentIndex = 1
            state, entryExpectedTime = ProcessEntry(currentIndex)
            if state == DirectiveProcessorState.stop then
                currentIndex = -1
            end
            return true
        end,

        Stop = function ()
            if not vci.assets.IsMine then
                cytanb.LogError('Unexpected: not vci.assets.IsMine')
                return false
            end

            animator._ALL_Stop()
            currentIndex = -1
            state = DirectiveProcessorState.stop

            return true
        end,

        Update = function ()
            if not vci.assets.IsMine then
                return
            end

            if state ~= DirectiveProcessorState.processing then
                return
            end

            if vci.me.Time >= entryExpectedTime then
                -- エントリーの終了予定時間に到達したので、次のエントリーを処理する
                animator._ALL_Stop()
                currentIndex = currentIndex + 1
                state, entryExpectedTime = ProcessEntry(currentIndex)
                if state == DirectiveProcessorState.stop then
                    self.Stop()
                end
            else
                if systemCam.IsGrabbed() then
                    if stopOnCameraGrabbed then
                        self.Stop()
                    end
                else
                    -- カメラがつかまれていなければ、マーカーの位置と回転をカメラに適用する
                    systemCam.SetPosition(camMarker.GetPosition())
                    systemCam.SetRotation(camMarker.GetRotation())
                end
            end
        end,

        GetState = function ()
            return state
        end
    }
    return self
end

--- VCI がロードされたか。
local vciLoaded = false

local camContainer, camSwitch

---@type DirectiveProcessor
local directiveProcessor

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    vciLoaded = true

    camContainer = vci.assets.GetSubItem(conf.camContainerName)
    if conf.camContainerTransformToWorld then
        camContainer.SetPosition(camContainer.GetLocalPosition())
        camContainer.SetRotation(camContainer.GetLocalRotation())
    end

    camSwitch = conf.camSwitchName and vci.assets.GetSubItem(conf.camSwitchName) or nil

    directiveProcessor = CreateDirectiveProcessor(conf.directives, camContainer.GetAnimation(), vci.assets.GetSubItem(conf.camMarkerName), conf.stopOnCameraGrabbed, conf.systemCamName)

    cytanb.OnInstanceMessage(togglePlayMessageName, function (sender, name, parameterMap)
        if vci.assets.IsMine then
            cytanb.LogTrace('on toggle play message')
            if directiveProcessor.GetState() == DirectiveProcessorState.processing then
                directiveProcessor.Stop()
            else
                directiveProcessor.Start()
            end
        end
    end)

    if conf.playOnLoad then
        directiveProcessor.Start()
    end
end

local OnUpdate = function (deltaTime)
    if vci.assets.IsMine then
        directiveProcessor.Update()
    end
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
            cytanb.LogError('Timeout: Could not receive Instance ID.')
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
    OnLoad()

    while true do
        local now = vci.me.Time
        local delta = now - lastTime
        OnUpdate(delta > TimeSpan.Zero and delta or TimeSpan.FromTicks(100))
        lastTime = now
        coroutine.yield(100)
    end
    -- return 0
end)

function updateAll ()
    UpdateCw()
end

function onUse (use)
    if not vciLoaded then
        return
    end

    if camSwitch and use == camSwitch.GetName() then
        cytanb.LogTrace('Emit toggle play message')
        cytanb.EmitMessage(togglePlayMessageName)
    end
end
