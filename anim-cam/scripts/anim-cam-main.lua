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
    ---     {type = 'play', name = 'anim-cam-clip-0', length = TimeSpan.FromSeconds(61)},
    ---     {type = 'play', name = 'anim-cam-clip-1', length = TimeSpan.FromSeconds(141)}
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
    camContainerTransformToWorld = true,

    --- デバッグ機能を有効にするかを指定する。(true | false)
    enableDebugging = false
}

---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()math.randomseed(os.time()-os.clock()*10000)local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local a;local g=function(h,i)for j=1,4 do local k=h[j]-i[j]if k~=0 then return k end end;return 0 end;local l;l={__eq=function(h,i)return h[1]==i[1]and h[2]==i[2]and h[3]==i[3]and h[4]==i[4]end,__lt=function(h,i)return g(h,i)<0 end,__le=function(h,i)return g(h,i)<=0 end,__tostring=function(m)local n=m[2]or 0;local o=m[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(m[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(n,16),0xFFFF),bit32.band(n,0xFFFF),bit32.band(bit32.rshift(o,16),0xFFFF),bit32.band(o,0xFFFF),bit32.band(m[4]or 0,0xFFFFFFFF))end,__concat=function(h,i)local p=getmetatable(h)local q=p==l or type(p)=='table'and p.__concat==l.__concat;local r=getmetatable(i)local s=r==l or type(r)=='table'and r.__concat==l.__concat;if not q and not s then error('attempt to concatenate illegal values')end;return(q and l.__tostring(h)or h)..(s and l.__tostring(i)or i)end}local t='__CYTANB_CONST_VARIABLES'local u=function(table,v)local w=getmetatable(table)if w then local x=rawget(w,t)if x then local y=rawget(x,v)if type(y)=='function'then return y(table,v)else return y end end end;return nil end;local z=function(table,v,A)local w=getmetatable(table)if w then local x=rawget(w,t)if x then if rawget(x,v)~=nil then error('Cannot assign to read only field "'..v..'"')end end end;rawset(table,v,A)end;local B=function(C)return string.gsub(string.gsub(C,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local D=function(C,E)local F=string.len(C)local G=string.len(a.EscapeSequenceTag)if G>F then return C end;local H=''local j=1;while j<F do local I,J=string.find(C,a.EscapeSequenceTag,j,true)if not I then if j==1 then H=C else H=H..string.sub(C,j)end;break end;if I>j then H=H..string.sub(C,j,I-1)end;local K=false;for L,M in ipairs(c)do local N,O=string.find(C,M.pattern,I)if N then H=H..(E and E(M.tag)or M.replacement)j=O+1;K=true;break end end;if not K then H=H..a.EscapeSequenceTag;j=J+1 end end;return H end;a={InstanceID=function()if f==''then f=vci.state.Get(b)or''end;return f end,SetConst=function(P,Q,m)if type(P)~='table'then error('Cannot set const to non-table target')end;local R=getmetatable(P)local w=R or{}local S=rawget(w,t)if rawget(P,Q)~=nil then error('Non-const field "'..Q..'" already exists')end;if not S then S={}rawset(w,t,S)w.__index=u;w.__newindex=z end;rawset(S,Q,m)if not R then setmetatable(P,w)end;return P end,SetConstEach=function(P,T)for U,A in pairs(T)do a.SetConst(P,U,A)end;return P end,Extend=function(P,V,W,X,Y)if P==V or type(P)~='table'or type(V)~='table'then return P end;if W then if not Y then Y={}end;if Y[V]then error('circular reference')end;Y[V]=true end;for U,A in pairs(V)do if W and type(A)=='table'then local Z=P[U]P[U]=a.Extend(type(Z)=='table'and Z or{},A,W,X,Y)else P[U]=A end end;if not X then local _=getmetatable(V)if type(_)=='table'then if W then local a0=getmetatable(P)setmetatable(P,a.Extend(type(a0)=='table'and a0 or{},_,true))else setmetatable(P,_)end end end;if W then Y[V]=nil end;return P end,Vars=function(A,a1,a2,Y)local a3;if a1 then a3=a1~='__NOLF'else a1='  'a3=true end;if not a2 then a2=''end;if not Y then Y={}end;local a4=type(A)if a4=='table'then Y[A]=Y[A]and Y[A]+1 or 1;local a5=a3 and a2 ..a1 or''local C='('..tostring(A)..') {'local a6=true;for v,a7 in pairs(A)do if a6 then a6=false else C=C..(a3 and','or', ')end;if a3 then C=C..'\n'..a5 end;if type(a7)=='table'and Y[a7]and Y[a7]>0 then C=C..v..' = ('..tostring(a7)..')'else C=C..v..' = '..a.Vars(a7,a1,a5,Y)end end;if not a6 and a3 then C=C..'\n'..a2 end;C=C..'}'Y[A]=Y[A]-1;if Y[A]<=0 then Y[A]=nil end;return C elseif a4=='function'or a4=='thread'or a4=='userdata'then return'('..a4 ..')'elseif a4=='string'then return'('..a4 ..') '..string.format('%q',A)else return'('..a4 ..') '..tostring(A)end end,GetLogLevel=function()return e end,SetLogLevel=function(a8)e=a8 end,Log=function(a8,...)if a8<=e then local a9=table.pack(...)if a9.n==1 then local A=a9[1]if A~=nil then print(type(A)=='table'and a.Vars(A)or tostring(A))else print('')end else local C=''for j=1,a9.n do local A=a9[j]if A~=nil then C=C..(type(A)=='table'and a.Vars(A)or tostring(A))end end;print(C)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aa,ab)local table={}local ac=ab==nil;for U,A in pairs(aa)do table[A]=ac and A or ab end;return table end,Round=function(ad,ae)if ae then local af=10^ae;return math.floor(ad*af+0.5)/af else return math.floor(ad+0.5)end end,Clamp=function(m,ag,ah)return math.max(ag,math.min(m,ah))end,Lerp=function(ai,aj,a4)if a4<=0.0 then return ai elseif a4>=1.0 then return aj else return ai+(aj-ai)*a4 end end,LerpUnclamped=function(ai,aj,a4)if a4==0.0 then return ai elseif a4==1.0 then return aj else return ai+(aj-ai)*a4 end end,PingPong=function(a4,ak)if ak==0 then return 0 end;local al=math.floor(a4/ak)local am=a4-al*ak;if al<0 then if(al+1)%2==0 then return ak-am else return am end else if al%2==0 then return am else return ak-am end end end,QuaternionToAngleAxis=function(an)local al=an.normalized;local ao=math.acos(al.w)local ap=math.sin(ao)local aq=math.deg(ao*2.0)local ar;if math.abs(ap)<=Quaternion.kEpsilon then ar=Vector3.right else local as=1.0/ap;ar=Vector3.__new(al.x*as,al.y*as,al.z*as)end;return aq,ar end,ApplyQuaternionToVector3=function(an,at)local au=an.w*at.x+an.y*at.z-an.z*at.y;local av=an.w*at.y-an.x*at.z+an.z*at.x;local aw=an.w*at.z+an.x*at.y-an.y*at.x;local ax=-an.x*at.x-an.y*at.y-an.z*at.z;return Vector3.__new(ax*-an.x+au*an.w+av*-an.z-aw*-an.y,ax*-an.y-au*-an.z+av*an.w+aw*-an.x,ax*-an.z+au*-an.y-av*-an.x+aw*an.w)end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(ay)return l.__tostring(ay)end,UUIDFromNumbers=function(...)local az=...local a4=type(az)local aA,aB,aC,aD;if a4=='table'then aA=az[1]aB=az[2]aC=az[3]aD=az[4]else aA,aB,aC,aD=...end;local ay={bit32.band(aA or 0,0xFFFFFFFF),bit32.band(aB or 0,0xFFFFFFFF),bit32.band(aC or 0,0xFFFFFFFF),bit32.band(aD or 0,0xFFFFFFFF)}setmetatable(ay,l)return ay end,UUIDFromString=function(C)local F=string.len(C)if F~=32 and F~=36 then return nil end;local aE='[0-9a-f-A-F]+'local aF='^('..aE..')$'local aG='^-('..aE..')$'local aH,aI,aJ,aK;if F==32 then local ay=a.UUIDFromNumbers(0,0,0,0)local aL=1;for j,aM in ipairs({8,16,24,32})do aH,aI,aJ=string.find(string.sub(C,aL,aM),aF)if not aH then return nil end;ay[j]=tonumber(aJ,16)aL=aM+1 end;return ay else aH,aI,aJ=string.find(string.sub(C,1,8),aF)if not aH then return nil end;local aA=tonumber(aJ,16)aH,aI,aJ=string.find(string.sub(C,9,13),aG)if not aH then return nil end;aH,aI,aK=string.find(string.sub(C,14,18),aG)if not aH then return nil end;local aB=tonumber(aJ..aK,16)aH,aI,aJ=string.find(string.sub(C,19,23),aG)if not aH then return nil end;aH,aI,aK=string.find(string.sub(C,24,28),aG)if not aH then return nil end;local aC=tonumber(aJ..aK,16)aH,aI,aJ=string.find(string.sub(C,29,36),aF)if not aH then return nil end;local aD=tonumber(aJ,16)return a.UUIDFromNumbers(aA,aB,aC,aD)end end,ParseUUID=function(C)return a.UUIDFromString(C)end,CreateCircularQueue=function(aN)if type(aN)~='number'or aN<1 then error('Invalid argument: capacity = '..tostring(aN))end;local self;local aO=math.floor(aN)local H={}local aP=0;local aQ=0;local aR=0;self={Size=function()return aR end,Clear=function()aP=0;aQ=0;aR=0 end,IsEmpty=function()return aR==0 end,Offer=function(aS)H[aP+1]=aS;aP=(aP+1)%aO;if aR<aO then aR=aR+1 else aQ=(aQ+1)%aO end;return true end,OfferFirst=function(aS)aQ=(aO+aQ-1)%aO;H[aQ+1]=aS;if aR<aO then aR=aR+1 else aP=(aO+aP-1)%aO end;return true end,Poll=function()if aR==0 then return nil else local aS=H[aQ+1]aQ=(aQ+1)%aO;aR=aR-1;return aS end end,PollLast=function()if aR==0 then return nil else aP=(aO+aP-1)%aO;local aS=H[aP+1]aR=aR-1;return aS end end,Peek=function()if aR==0 then return nil else return H[aQ+1]end end,PeekLast=function()if aR==0 then return nil else return H[(aO+aP-1)%aO+1]end end,Get=function(aT)if aT<1 or aT>aR then a.LogError('CreateCircularQueue.Get: index is outside the range: '..aT)return nil end;return H[(aQ+aT-1)%aO+1]end,IsFull=function()return aR>=aO end,MaxSize=function()return aO end}return self end,
ColorFromARGB32=function(aU)local aV=type(aU)=='number'and aU or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(aV,16),0xFF)/0xFF,bit32.band(bit32.rshift(aV,8),0xFF)/0xFF,bit32.band(aV,0xFF)/0xFF,bit32.band(bit32.rshift(aV,24),0xFF)/0xFF)end,ColorToARGB32=function(aW)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*aW.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*aW.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*aW.g),0xFF),8),bit32.band(a.Round(0xFF*aW.b),0xFF))end,ColorFromIndex=function(aX,aY,aZ,a_,b0)local b1=math.max(math.floor(aY or a.ColorHueSamples),1)local b2=b0 and b1 or b1-1;local b3=math.max(math.floor(aZ or a.ColorSaturationSamples),1)local b4=math.max(math.floor(a_ or a.ColorBrightnessSamples),1)local aT=a.Clamp(math.floor(aX or 0),0,b1*b3*b4-1)local b5=aT%b1;local b6=math.floor(aT/b1)local as=b6%b3;local b7=math.floor(b6/b3)if b0 or b5~=b2 then local y=b5/b2;local b8=(b3-as)/b3;local A=(b4-b7)/b4;return Color.HSVToRGB(y,b8,A)else local A=(b4-b7)/b4*as/(b3-1)return Color.HSVToRGB(0.0,0.0,A)end end,GetSubItemTransform=function(b9)local ba=b9.GetPosition()local bb=b9.GetRotation()local bc=b9.GetLocalScale()return{positionX=ba.x,positionY=ba.y,positionZ=ba.z,rotationX=bb.x,rotationY=bb.y,rotationZ=bb.z,rotationW=bb.w,scaleX=bc.x,scaleY=bc.y,scaleZ=bc.z}end,TableToSerializable=function(bd,Y)if type(bd)~='table'then return bd end;if not Y then Y={}end;if Y[bd]then error('circular reference')end;Y[bd]=true;local be={}for U,A in pairs(bd)do local bf=type(U)local bg;if bf=='string'then bg=B(U)elseif bf=='number'then bg=tostring(U)..a.ArrayNumberTag else bg=U end;local bh=type(A)if bh=='string'then be[bg]=B(A)elseif bh=='number'and A<0 then be[tostring(bg)..a.NegativeNumberTag]=tostring(A)else be[bg]=a.TableToSerializable(A,Y)end end;Y[bd]=nil;return be end,TableFromSerializable=function(be)if type(be)~='table'then return be end;local bd={}for U,A in pairs(be)do local bg;local bi=false;if type(U)=='string'then local bj=false;bg=D(U,function(bk)if bk==a.NegativeNumberTag then bi=true elseif bk==a.ArrayNumberTag then bj=true end;return nil end)if bj then bg=tonumber(bg)or bg end else bg=U;bi=false end;if bi and type(A)=='string'then bd[bg]=tonumber(A)elseif type(A)=='string'then bd[bg]=D(A,function(bk)return d[bk]end)else bd[bg]=a.TableFromSerializable(A)end end;return bd end,TableToSerialiable=function(bd,Y)return a.TableToSerializable(bd,Y)end,TableFromSerialiable=function(be)return a.TableFromSerializable(be)end,EmitMessage=function(Q,bl)local table=bl and a.TableToSerializable(bl)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(Q,json.serialize(table))end,OnMessage=function(Q,bm)local bn=function(bo,bp,bq)local br=nil;if bo.type~='comment'and type(bq)=='string'then local bs,be=pcall(json.parse,bq)if bs and type(be)=='table'then br=a.TableFromSerializable(be)end end;local bl=br and br or{[a.MessageValueParameterName]=bq}bm(bo,bp,bl)end;vci.message.On(Q,bn)return{Off=function()if bn then bn=nil end end}end,OnInstanceMessage=function(Q,bm)local bn=function(bo,bp,bl)local bt=a.InstanceID()if bt~=''and bt==bl[a.InstanceIDParameterName]then bm(bo,bp,bl)end end;return a.OnMessage(Q,bn)end}a.SetConstEach(a,{LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}d=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})e=a.LogLevelInfo;package.loaded['cytanb']=a;f=vci.state.Get(b)or''if f==''and vci.assets.IsMine then f=tostring(a.RandomUUID())vci.state.Set(b,f)end;return a end)()

local animCamNS = 'com.github.oocytanb.oO-vci-pack.anim-cam'
local togglePlayMessageName = animCamNS .. '.toggle-play'

---@class StudioSystemCameraAccessor
---@field get ExportSystemCamera
---@field has boolean

---@class StudioSystemCameraCollection
---@field HandiCamera StudioSystemCameraAccessor
---@field AutoFollowCamera StudioSystemCameraAccessor
---@field SwitchingCamera StudioSystemCameraAccessor
---@field WindowCamera StudioSystemCameraAccessor
local StudioSystemCameraCollection = cytanb.SetConstEach({}, {
    HandiCamera = {get = vci.studio.GetHandiCamera, has = vci.studio.HasHandiCamera},
    AutoFollowCamera = {get = vci.studio.GetAutoFollowCamera, has = vci.studio.HasAutoFollowCamera},
    SwitchingCamera = {get = vci.studio.GetSwitchingCamera, has = vci.studio.HasSwitchingCamera},
    WindowCamera = {get = vci.studio.GetWindowCamera, has = vci.studio.HasWindowCamera}
})

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
    local systemCamAccessor = StudioSystemCameraCollection[systemCamName]
    if not systemCamAccessor then
        systemCamName = 'HandiCamera'
        systemCamAccessor = StudioSystemCameraCollection.HandiCamera
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
                cytanb.LogError('INVALID DIRECTIVE PARAMETER: animation clip name is not specified')
                return DirectiveProcessorState.stop, TimeSpan.MaxValue
            end

            animator._ALL_PlayFromName(dir.name, not not dir.loop)
            local expectedTime = dir.length and vci.me.time + dir.length or TimeSpan.MaxValue
            return DirectiveProcessorState.processing, expectedTime
        else
            cytanb.LogError('UNSUPPORTED DIRECTIVE: type = ', dir.type)
            return DirectiveProcessorState.stop, TimeSpan.MaxValue
        end
    end

    local self
    self = {
        Start = function ()
            if not vci.assets.IsMine then
                cytanb.LogError('UNSUPPORTED OPERATION: not vci.assets.IsMine')
                return false
            end

            self.Stop()

            systemCam = systemCamAccessor.get()
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
                cytanb.LogError('UNSUPPORTED OPERATION: not vci.assets.IsMine')
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

            if not systemCamAccessor.has() then
                -- カメラが削除されたため、停止する。
                cytanb.LogWarn('SYSTEM_CAMERA_LOST: ', systemCamName)
                self.Stop()
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

if conf.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelTrace)
end

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    vciLoaded = true

    camContainer = vci.assets.GetSubItem(conf.camContainerName)
    if vci.assets.IsMine and conf.camContainerTransformToWorld then
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
