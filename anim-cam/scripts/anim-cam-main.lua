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
    --- カメラのアニメーションの再生方法の指示。
    ---   type: 指示のタイプを指定する。('play': アニメーションを再生する。)
    ---   name: アニメーションクリップの名前を指定する。
    ---   length: アニメーションクリップの長さを TimeSpan で指定する。省略した場合は再生を終了しない。
    ---   loop: アニメーションをループ再生するかを指定する。省略した場合はループ再生しない。(true | false)
    ---   stopOnEnd: このアニメーションクリップの再生を終えたら、停止するかを指定する。省略した場合は次のクリップを再生する。(true | false)
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

    --- 全体をループ再生するかを指定する。(true | false)
    loopAll = false,

    --- ロード時に自動的に再生を開始するかを指定する。(true | false)
    --- true を指定すると、アイテムを設置・削除で、アニメーションの再生・停止を切り替えるような使い方が出来る。
    playOnLoad = false,

    --- カメラをつかんだ時に、再生を停止するかを指定する。(true | false)
    stopOnCameraGrabbed = true,

    --- 操作するカメラの名前。('HandiCamera' | 'AutoFollowCamera' | 'SwitchingCamera' | 'WindowCamera')
    systemCamName = 'HandiCamera',

    --- カメラのコンテナーオブジェクトの初期位置をワールド座標の原点へ移動するかを指定する。(true | false)
    --- アイテムを設置した位置を初期位置とする場合は、false を指定する。
    camContainerToWorldOrigin = true,

    --- カメラのコンテナーのオブジェクト名。
    camContainerName = 'anim-cam-container',

    --- カメラのマーカーのオブジェクト名。
    camMarkerName = 'anim-cam-marker',

    --- 再生/停止スイッチのオブジェクト名。
    camSwitchName = 'anim-cam-switch',

    --- 次へ進むスイッチのオブジェクト名。
    camNextSwitchName = 'anim-cam-next-switch',

    --- 前へ戻るスイッチのオブジェクト名。
    camPrevSwitchName = 'anim-cam-prev-switch',

    --- スイッチのトラックのディスプレイのオブジェクト名の接頭辞。
    camSwitchDisplayTrackPlacePrefix = 'anim-cam-switch-display-track-place-',

    --- スイッチのトラックのディスプレイの桁数。
    camSwitchDisplayTrackPlaceDigits = 2,

    --- スイッチのトラックのディスプレイのテクスチャーのオフセット座標。
    camSwitchDisplayTrackTextureOffset = Vector2.__new(8 / 1024, 0),

    --- カメラのスイッチのテクスチャーのオフセット座標。
    camSwitchTextureOffset = Vector2.__new(0, 356 / 1024),

    --- デバッグ機能を有効にするかを指定する。(true | false)
    enableDebugging = false
}

---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()math.randomseed(os.time()-os.clock()*10000)local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local a;local j=function(k,l)for m=1,4 do local n=k[m]-l[m]if n~=0 then return n end end;return 0 end;local o;o={__eq=function(k,l)return k[1]==l[1]and k[2]==l[2]and k[3]==l[3]and k[4]==l[4]end,__lt=function(k,l)return j(k,l)<0 end,__le=function(k,l)return j(k,l)<=0 end,__tostring=function(p)local q=p[2]or 0;local r=p[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(p[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(q,16),0xFFFF),bit32.band(q,0xFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(p[4]or 0,0xFFFFFFFF))end,__concat=function(k,l)local s=getmetatable(k)local t=s==o or type(s)=='table'and s.__concat==o.__concat;local u=getmetatable(l)local v=u==o or type(u)=='table'and u.__concat==o.__concat;if not t and not v then error('attempt to concatenate illegal values',2)end;return(t and o.__tostring(k)or k)..(v and o.__tostring(l)or l)end}local w='__CYTANB_CONST_VARIABLES'local x=function(table,y)local z=getmetatable(table)if z then local A=rawget(z,w)if A then local B=rawget(A,y)if type(B)=='function'then return B(table,y)else return B end end end;return nil end;local C=function(table,y,D)local z=getmetatable(table)if z then local A=rawget(z,w)if A then if rawget(A,y)~=nil then error('Cannot assign to read only field "'..y..'"',2)end end end;rawset(table,y,D)end;local E=function(F,G)local H=F[a.TypeParameterName]if a.NillableHasValue(H)and a.NillableValue(H)~=G then return false,false end;local I=c[G]if not a.NillableHasValue(I)then return false,false end;local J=a.NillableValue(I)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,D in pairs(F)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local m=1;while m<S do local V,W=string.find(P,a.EscapeSequenceTag,m,true)if not V then if m==1 then U=P else U=U..string.sub(P,m)end;break end;if V>m then U=U..string.sub(P,m,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)m=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;m=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,D in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(D)if a7=='string'then a4[a6]=O(D)elseif a7=='number'and D<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(D)else a4[a6]=a1(D,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,D in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(D)=='string'then a2[a6]=tonumber(D)elseif type(D)=='string'then a2[a6]=Q(D,function(ac)return e[ac]end)else a2[a6]=a8(D,a9)end end;local H=a2[a.TypeParameterName]if not a9 and a.NillableHasValue(H)then local I=c[a.NillableValue(H)]if a.NillableHasValue(I)then local ad,M=a.NillableValue(I).fromTableFunc(a2)if a.NillableHasValue(ad)and not M then return a.NillableValue(ad)end end end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(ae)return ae~=nil end,NillableValue=function(ae)if ae==nil then error('value is nil',2)end;return ae end,NillableValueOrDefault=function(ae,af)if ae==nil then if af==nil then error('defaultValue is nil',2)end;return af else return ae end end,SetConst=function(ag,ah,p)if type(ag)~='table'then error('Cannot set const to non-table target',2)end;local ai=getmetatable(ag)local z=ai or{}local aj=rawget(z,w)if rawget(ag,ah)~=nil then error('Non-const field "'..ah..'" already exists',2)end;if not aj then aj={}rawset(z,w,aj)z.__index=x;z.__newindex=C end;rawset(aj,ah,p)if not ai then setmetatable(ag,z)end;return ag end,SetConstEach=function(ag,ak)for N,D in pairs(ak)do a.SetConst(ag,N,D)end;return ag end,Extend=function(ag,al,am,an,a3)if ag==al or type(ag)~='table'or type(al)~='table'then return ag end;if am then if not a3 then a3={}end;if a3[al]then error('circular reference')end;a3[al]=true end;for N,D in pairs(al)do if am and type(D)=='table'then local ao=ag[N]ag[N]=a.Extend(type(ao)=='table'and ao or{},D,am,an,a3)else ag[N]=D end end;if not an then local ap=getmetatable(al)if type(ap)=='table'then if am then local aq=getmetatable(ag)setmetatable(ag,a.Extend(type(aq)=='table'and aq or{},ap,true))else setmetatable(ag,ap)end end end;if am then a3[al]=nil end;return ag end,Vars=function(D,ar,as,a3)local at;if ar then at=ar~='__NOLF'else ar='  'at=true end;if not as then as=''end;if not a3 then a3={}end;local au=type(D)if au=='table'then a3[D]=a3[D]and a3[D]+1 or 1;local av=at and as..ar or''local P='('..tostring(D)..') {'local aw=true;for y,ax in pairs(D)do if aw then aw=false else P=P..(at and','or', ')end;if at then P=P..'\n'..av end;if type(ax)=='table'and a3[ax]and a3[ax]>0 then P=P..y..' = ('..tostring(ax)..')'else P=P..y..' = '..a.Vars(ax,ar,av,a3)end end;if not aw and at then P=P..'\n'..as end;P=P..'}'a3[D]=a3[D]-1;if a3[D]<=0 then a3[D]=nil end;return P elseif au=='function'or au=='thread'or au=='userdata'then return'('..au..')'elseif au=='string'then return'('..au..') '..string.format('%q',D)else return'('..au..') '..tostring(D)end end,GetLogLevel=function()return f end,SetLogLevel=function(ay)f=ay end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(az)g=not not az end,Log=function(ay,...)if ay<=f then local aA=g and(h[ay]or'LOG LEVEL '..tostring(ay))..' | 'or''local aB=table.pack(...)if aB.n==1 then local D=aB[1]if D~=nil then local P=type(D)=='table'and a.Vars(D)or tostring(D)print(g and aA..P or P)else print(aA)end else local P=aA;for m=1,aB.n do local D=aB[m]if D~=nil then P=P..(type(D)=='table'and a.Vars(D)or tostring(D))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aC,aD)local table={}local aE=aD==nil;for N,D in pairs(aC)do table[D]=aE and D or aD end;return table end,Round=function(aF,aG)if aG then local aH=10^aG;return math.floor(aF*aH+0.5)/aH else return math.floor(aF+0.5)end end,Clamp=function(p,aI,aJ)return math.max(aI,math.min(p,aJ))end,Lerp=function(aK,aL,au)if au<=0.0 then return aK elseif au>=1.0 then return aL else return aK+(aL-aK)*au end end,LerpUnclamped=function(aK,aL,au)if au==0.0 then return aK elseif au==1.0 then return aL else return aK+(aL-aK)*au end end,
PingPong=function(au,aM)if aM==0 then return 0 end;local aN=math.floor(au/aM)local aO=au-aN*aM;if aN<0 then if(aN+1)%2==0 then return aM-aO else return aO end else if aN%2==0 then return aO else return aM-aO end end end,VectorApproximatelyEquals=function(aP,aQ)return(aP-aQ).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aP,aQ)local aR=Quaternion.Dot(aP,aQ)return aR<1.0+1E-06 and aR>1.0-1E-06 end,QuaternionToAngleAxis=function(aS)local aN=aS.normalized;local aT=math.acos(aN.w)local aU=math.sin(aT)local aV=math.deg(aT*2.0)local aW;if math.abs(aU)<=Quaternion.kEpsilon then aW=Vector3.right else local aX=1.0/aU;aW=Vector3.__new(aN.x*aX,aN.y*aX,aN.z*aX)end;return aV,aW end,ApplyQuaternionToVector3=function(aS,aY)local aZ=aS.w*aY.x+aS.y*aY.z-aS.z*aY.y;local a_=aS.w*aY.y-aS.x*aY.z+aS.z*aY.x;local b0=aS.w*aY.z+aS.x*aY.y-aS.y*aY.x;local b1=-aS.x*aY.x-aS.y*aY.y-aS.z*aY.z;return Vector3.__new(b1*-aS.x+aZ*aS.w+a_*-aS.z-b0*-aS.y,b1*-aS.y-aZ*-aS.z+a_*aS.w+b0*-aS.x,b1*-aS.z+aZ*-aS.y-a_*-aS.x+b0*aS.w)end,RotateAround=function(b2,b3,b4,b5)return b4+a.ApplyQuaternionToVector3(b5,b2-b4),b5*b3 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(b6)return o.__tostring(b6)end,UUIDFromNumbers=function(...)local b7=...local au=type(b7)local b8,b9,ba,bb;if au=='table'then b8=b7[1]b9=b7[2]ba=b7[3]bb=b7[4]else b8,b9,ba,bb=...end;local b6={bit32.band(b8 or 0,0xFFFFFFFF),bit32.band(b9 or 0,0xFFFFFFFF),bit32.band(ba or 0,0xFFFFFFFF),bit32.band(bb or 0,0xFFFFFFFF)}setmetatable(b6,o)return b6 end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bc='[0-9a-f-A-F]+'local bd='^('..bc..')$'local be='^-('..bc..')$'local bf,bg,bh,bi;if S==32 then local b6=a.UUIDFromNumbers(0,0,0,0)local bj=1;for m,bk in ipairs({8,16,24,32})do bf,bg,bh=string.find(string.sub(P,bj,bk),bd)if not bf then return nil end;b6[m]=tonumber(bh,16)bj=bk+1 end;return b6 else bf,bg,bh=string.find(string.sub(P,1,8),bd)if not bf then return nil end;local b8=tonumber(bh,16)bf,bg,bh=string.find(string.sub(P,9,13),be)if not bf then return nil end;bf,bg,bi=string.find(string.sub(P,14,18),be)if not bf then return nil end;local b9=tonumber(bh..bi,16)bf,bg,bh=string.find(string.sub(P,19,23),be)if not bf then return nil end;bf,bg,bi=string.find(string.sub(P,24,28),be)if not bf then return nil end;local ba=tonumber(bh..bi,16)bf,bg,bh=string.find(string.sub(P,29,36),bd)if not bf then return nil end;local bb=tonumber(bh,16)return a.UUIDFromNumbers(b8,b9,ba,bb)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bl)if type(bl)~='number'or bl<1 then error('Invalid argument: capacity = '..tostring(bl),2)end;local self;local bm=math.floor(bl)local U={}local bn=0;local bo=0;local bp=0;self={Size=function()return bp end,Clear=function()bn=0;bo=0;bp=0 end,IsEmpty=function()return bp==0 end,Offer=function(bq)U[bn+1]=bq;bn=(bn+1)%bm;if bp<bm then bp=bp+1 else bo=(bo+1)%bm end;return true end,OfferFirst=function(bq)bo=(bm+bo-1)%bm;U[bo+1]=bq;if bp<bm then bp=bp+1 else bn=(bm+bn-1)%bm end;return true end,Poll=function()if bp==0 then return nil else local bq=U[bo+1]bo=(bo+1)%bm;bp=bp-1;return bq end end,PollLast=function()if bp==0 then return nil else bn=(bm+bn-1)%bm;local bq=U[bn+1]bp=bp-1;return bq end end,Peek=function()if bp==0 then return nil else return U[bo+1]end end,PeekLast=function()if bp==0 then return nil else return U[(bm+bn-1)%bm+1]end end,Get=function(br)if br<1 or br>bp then a.LogError('CreateCircularQueue.Get: index is outside the range: '..br)return nil end;return U[(bo+br-1)%bm+1]end,IsFull=function()return bp>=bm end,MaxSize=function()return bm end}return self end,DetectClicks=function(bs,bt,bu)local bv=bs or 0;local bw=bu or TimeSpan.FromMilliseconds(500)local bx=vci.me.Time;local by=bt and bx>bt+bw and 1 or bv+1;return by,bx end,ColorFromARGB32=function(bz)local bA=type(bz)=='number'and bz or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bA,16),0xFF)/0xFF,bit32.band(bit32.rshift(bA,8),0xFF)/0xFF,bit32.band(bA,0xFF)/0xFF,bit32.band(bit32.rshift(bA,24),0xFF)/0xFF)end,ColorToARGB32=function(bB)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bB.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bB.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bB.g),0xFF),8),bit32.band(a.Round(0xFF*bB.b),0xFF))end,ColorFromIndex=function(bC,bD,bE,bF,bG)local bH=math.max(math.floor(bD or a.ColorHueSamples),1)local bI=bG and bH or bH-1;local bJ=math.max(math.floor(bE or a.ColorSaturationSamples),1)local bK=math.max(math.floor(bF or a.ColorBrightnessSamples),1)local br=a.Clamp(math.floor(bC or 0),0,bH*bJ*bK-1)local bL=br%bH;local bM=math.floor(br/bH)local aX=bM%bJ;local bN=math.floor(bM/bJ)if bG or bL~=bI then local B=bL/bI;local bO=(bJ-aX)/bJ;local D=(bK-bN)/bK;return Color.HSVToRGB(B,bO,D)else local D=(bK-bN)/bK*aX/(bJ-1)return Color.HSVToRGB(0.0,0.0,D)end end,ColorToTable=function(bB)return{[a.TypeParameterName]=a.ColorTypeName,r=bB.r,g=bB.g,b=bB.b,a=bB.a}end,ColorFromTable=function(F)local aL,M=E(F,a.ColorTypeName)return aL and Color.__new(F.r,F.g,F.b,F.a)or nil,M end,
Vector2ToTable=function(p)return{[a.TypeParameterName]=a.Vector2TypeName,x=p.x,y=p.y}end,Vector2FromTable=function(F)local aL,M=E(F,a.Vector2TypeName)return aL and Vector2.__new(F.x,F.y)or nil,M end,Vector3ToTable=function(p)return{[a.TypeParameterName]=a.Vector3TypeName,x=p.x,y=p.y,z=p.z}end,Vector3FromTable=function(F)local aL,M=E(F,a.Vector3TypeName)return aL and Vector3.__new(F.x,F.y,F.z)or nil,M end,Vector4ToTable=function(p)return{[a.TypeParameterName]=a.Vector4TypeName,x=p.x,y=p.y,z=p.z,w=p.w}end,Vector4FromTable=function(F)local aL,M=E(F,a.Vector4TypeName)return aL and Vector4.__new(F.x,F.y,F.z,F.w)or nil,M end,QuaternionToTable=function(p)return{[a.TypeParameterName]=a.QuaternionTypeName,x=p.x,y=p.y,z=p.z,w=p.w}end,QuaternionFromTable=function(F)local aL,M=E(F,a.QuaternionTypeName)return aL and Quaternion.__new(F.x,F.y,F.z,F.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ah,bP)local table=bP and a.TableToSerializable(bP)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ah,json.serialize(table))end,OnMessage=function(ah,bQ)local bR=function(bS,bT,bU)local bV=nil;if bS.type~='comment'and type(bU)=='string'then local bW,a4=pcall(json.parse,bU)if bW and type(a4)=='table'then bV=a.TableFromSerializable(a4)end end;local bP=bV and bV or{[a.MessageValueParameterName]=bU}bQ(bS,bT,bP)end;vci.message.On(ah,bR)return{Off=function()if bR then bR=nil end end}end,OnInstanceMessage=function(ah,bQ)local bR=function(bS,bT,bP)local bX=a.InstanceID()if bX~=''and bX==bP[a.InstanceIDParameterName]then bQ(bS,bT,bP)end end;return a.OnMessage(ah,bR)end,GetEffekseerEmitterMap=function(ah)local bY=vci.assets.GetEffekseerEmitters(ah)if not bY then return nil end;local bZ={}for m,b_ in pairs(bY)do bZ[b_.EffectName]=b_ end;return bZ end,CreateSubItemConnector=function()local c0=function(c1,c2,c3)c1.item=c2;c1.position=c2.GetPosition()c1.rotation=c2.GetRotation()c1.initialPosition=c1.position;c1.initialRotation=c1.rotation;c1.propagation=not not c3;return c1 end;local c4=function(c5)for c2,c1 in pairs(c5)do c0(c1,c2,c1.propagation)end end;local c6=function(c7,b5,c1,c8,c9)local ca=c7-c1.initialPosition;local cb=b5*Quaternion.Inverse(c1.initialRotation)c1.position=c7;c1.rotation=b5;for c2,cc in pairs(c8)do if c2~=c1.item and(not c9 or c9(cc))then cc.position,cc.rotation=a.RotateAround(cc.initialPosition+ca,cc.initialRotation,c7,cb)c2.SetPosition(cc.position)c2.SetRotation(cc.rotation)end end end;local cd={}local ce=true;local cf=false;local self={IsEnabled=function()return ce end,SetEnabled=function(az)ce=az;if az then c4(cd)cf=false end end,Contains=function(cg)return a.NillableHasValue(cd[cg])end,GetItems=function()local ch={}for c2,c1 in pairs(cd)do table.insert(ch,c2)end;return ch end,Add=function(ci,cj)if not ci then error('INVALID ARGUMENT: subItems = '..tostring(ci))end;local ch=type(ci)=='table'and ci or{ci}c4(cd)cf=false;for N,c2 in pairs(ch)do cd[c2]=c0({},c2,not cj)end end,Remove=function(cg)local aL=a.NillableHasValue(cd[cg])cd[cg]=nil;return aL end,RemoveAll=function()cd={}return true end,Update=function()if not ce then return end;local ck=false;for c2,c1 in pairs(cd)do local cl=c2.GetPosition()local cm=c2.GetRotation()if not a.VectorApproximatelyEquals(cl,c1.position)or not a.QuaternionApproximatelyEquals(cm,c1.rotation)then if c1.propagation then if c2.IsMine then c6(cl,cm,cd[c2],cd,function(cc)if cc.item.IsMine then return true else cf=true;return false end end)ck=true;break else cf=true end else cf=true end end end;if not ck and cf then c4(cd)cf=false end end}return self end,GetSubItemTransform=function(cg)local c7=cg.GetPosition()local b5=cg.GetRotation()local cn=cg.GetLocalScale()return{positionX=c7.x,positionY=c7.y,positionZ=c7.z,rotationX=b5.x,rotationY=b5.y,rotationZ=b5.z,rotationW=b5.w,scaleX=cn.x,scaleY=cn.y,scaleZ=cn.z}end,RestoreCytanbTransform=function(co)local cl=co.positionX and co.positionY and co.positionZ and Vector3.__new(co.positionX,co.positionY,co.positionZ)or nil;local cm=co.rotationX and co.rotationY and co.rotationZ and co.rotationW and Quaternion.__new(co.rotationX,co.rotationY,co.rotationZ,co.rotationW)or nil;local cn=co.scaleX and co.scaleY and co.scaleZ and Vector3.__new(co.scaleX,co.scaleY,co.scaleZ)or nil;return cl,cm,cn end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i=vci.state.Get(b)or''if i==''and vci.assets.IsMine then i=tostring(a.RandomUUID())vci.state.Set(b,i)end;return a end)()

local animCamNS = 'com.github.oocytanb.oO-vci-pack.anim-cam'
local commandMessageName = animCamNS .. '.cam-switch-command'
local directiveStateMessageName = animCamNS .. '.directive-state'
local queryDirectiveStateMessageName = animCamNS .. '.query-directive-state'

---@class CommandMessageParameter
---@field togglePlay string
---@field nextTrack string
---@field prevTrack string
local CommandMessageParameter = cytanb.SetConstEach({}, {
    togglePlay = 'togglePlay',
    nextTrack = 'nextTrack',
    prevTrack = 'prevTrack'
})

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

---@class DirectiveType Directive のタイプ。
---@field play string @アニメーションクリップを再生する。
local DirectiveType = cytanb.SetConstEach({}, {
    play = 'play',
})

---@class DirectiveProcessor ディレクティブのプロセッサー。
---@field SetStopOnCameraGrabbed fun (enabled: boolean) @カメラをつかんだ時に、再生を停止するかを指定する。
---@field IsStopOnCameraGrabbed fun (): boolean @カメラをつかんだ時に、再生を停止するかを調べる。規定値は `true`。
---@field SetLoopAll fun (enabled: boolean) @全体をループ再生するかを指定する。
---@field IsLoopAll fun (): boolean @全体をループ再生するかを調べる。規定値は `false`。
---@field Start fun (): boolean @ディレクティブの最初のエントリーから開始する。また、その成否を返す。
---@field Stop fun (): boolean @処理を停止する。また、その成否を返す。
---@field Update fun () @処理を更新する。
---@field GetState fun (): DirectiveProcessorState @現在の状態を取得する。
---@field GetTrackSize fun (): number @トラックのサイズを取得する。
---@field GetTrackIndex fun (): number @現在のトラックのインデックスを取得する。
---@field SetTrackIndex fun (index: number) @現在のトラックのインデックスを設定する。
---@field NextTrack fun () @次のトラックへ移動する。
---@field PrevTrack fun () @前のトラックへ移動する。

---@return DirectiveProcessor
local CreateDirectiveProcessor = function (directives, animator, camMarker, systemCamName)
    local ParseDirectives = function (directiveList)
        local list = {}
        local trackSize = 0
        for i, dir in ipairs(directiveList) do
            if dir.type == DirectiveType.play then
                -- 現在は 'play' のみ対応。
                if not dir.name then
                    cytanb.LogError('INVALID DIRECTIVE PARAMETER: animation clip name is not specified')
                else
                    table.insert(list, cytanb.Extend({}, dir))
                    trackSize = trackSize + 1
                end
            else
                cytanb.LogWarn('UNKNOWN DIRECTIVE TYPE: ', dir.type)
            end
        end
        return list, trackSize
    end

    local systemCamAccessor = StudioSystemCameraCollection[systemCamName]
    if not systemCamAccessor then
        systemCamName = 'HandiCamera'
        systemCamAccessor = StudioSystemCameraCollection.HandiCamera
    end

    local stopOnCameraGrabbed = true
    local loopAll = false

    local directiveList, trackSize = ParseDirectives(directives)
    local systemCam = nil
    local trackIndex = 1
    local entryExpectedTime = TimeSpan.MaxValue
    local state = DirectiveProcessorState.stop

    local ProcessEntry = function (index)
        local dir = directiveList[index]
        if not dir then
            return DirectiveProcessorState.stop, TimeSpan.MaxValue
        end

        if dir.type == DirectiveType.play then
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
        SetStopOnCameraGrabbed = function (enabled)
            stopOnCameraGrabbed = not not enabled
        end,

        IsStopOnCameraGrabbed = function ()
            return stopOnCameraGrabbed
        end,

        SetLoopAll = function (enabled)
            loopAll = not not enabled
        end,

        IsLoopAll = function ()
            return loopAll
        end,

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

            if trackIndex <= 0 then
                trackIndex = 1
            end

            state, entryExpectedTime = ProcessEntry(trackIndex)
            if state == DirectiveProcessorState.stop then
                trackIndex = 1
            end
            return true
        end,

        Stop = function ()
            if not vci.assets.IsMine then
                cytanb.LogError('UNSUPPORTED OPERATION: not vci.assets.IsMine')
                return false
            end

            animator._ALL_Stop()
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
                local nillableDir = directiveList[trackIndex]
                if cytanb.NillableHasValue(nillableDir) and cytanb.NillableValue(nillableDir).stopOnEnd then
                    -- 停止指示がある場合は、このエントリーで停止する
                    self.Stop()
                else
                    -- 停止指示がなければ、次のエントリーを再生する
                    -- インデックスが最終トラックで loopAll が指定されている場合は、先頭に戻す。
                    trackIndex = (trackIndex >= trackSize and loopAll) and 1 or trackIndex + 1
                    state, entryExpectedTime = ProcessEntry(trackIndex)
                    if state == DirectiveProcessorState.stop then
                        self.Stop()
                        trackIndex = 1
                    end
                end
            else
                if systemCam.IsGrabbed() then
                    if stopOnCameraGrabbed then
                        -- カメラがつかまれていれば、停止する
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
        end,

        GetTrackSize = function ()
            return trackSize
        end,

        GetTrackIndex = function ()
            return trackIndex
        end,

        SetTrackIndex = function (index)
            local stateIsProcessing = state == DirectiveProcessorState.processing
            if stateIsProcessing then
                self.Stop()
            end

            trackIndex = math.max(1, math.min(math.floor(index), trackSize))

            if stateIsProcessing then
                self.Start()
            end

            return trackIndex
        end,

        NextTrack = function ()
            self.SetTrackIndex(trackIndex < trackSize and trackIndex + 1 or 1)
            return trackIndex
        end,

        PrevTrack = function ()
            self.SetTrackIndex(trackIndex > 1 and trackIndex - 1 or trackSize)
            return trackIndex
        end
    }
    return self
end

--- VCI がロードされたか。
local vciLoaded = false

local camContainer = cytanb.NillableValue(vci.assets.GetSubItem(conf.camContainerName))
local nillableCamSwitch = conf.camSwitchName and vci.assets.GetSubItem(conf.camSwitchName) or nil
local nillableCamNextSwitch = conf.camNextSwitchName and vci.assets.GetSubItem(conf.camNextSwitchName) or nil
local nillableCamPrevSwitch = conf.camPrevSwitchName and vci.assets.GetSubItem(conf.camPrevSwitchName) or nil
local camSwitchMap, camNextSwitchMap, camPrevSwitchMap

---@type DirectiveProcessor
local directiveProcessor = CreateDirectiveProcessor(conf.directives, camContainer.GetAnimation(), vci.assets.GetSubItem(conf.camMarkerName), conf.systemCamName)
directiveProcessor.SetLoopAll(conf.loopAll)
directiveProcessor.SetStopOnCameraGrabbed(conf.stopOnCameraGrabbed)

local lastDirectiveState = DirectiveProcessorState.stop
local lastDirectiveTrackIndex = -1

local multiTrackSwitchEnabled = cytanb.NillableHasValue(nillableCamSwitch) and cytanb.NillableHasValue(nillableCamNextSwitch) and cytanb.NillableHasValue(nillableCamPrevSwitch) and directiveProcessor.GetTrackSize() >= 2

-- サブアイテムを動かした状態で、ゲストが凸したときのことを考慮して、チャンクが評価された時点の位置で、コネクターを作成する。
local camSwitchConnector = cytanb.CreateSubItemConnector()
if multiTrackSwitchEnabled then
    local switch = cytanb.NillableValue(nillableCamSwitch)
    local nextSwitch = cytanb.NillableValue(nillableCamNextSwitch)
    local prevSwitch = cytanb.NillableValue(nillableCamPrevSwitch)
    camSwitchMap = {[switch.GetName()] = switch}
    camNextSwitchMap = {[nextSwitch.GetName()] = nextSwitch}
    camPrevSwitchMap = {[prevSwitch.GetName()] = prevSwitch}
    camSwitchConnector.Add({switch, nextSwitch, prevSwitch})
else
    -- マルチトラックが無効のときは、Next/Prev を camSwitch として利用する。
    local switchList = {}
    if cytanb.NillableHasValue(nillableCamSwitch) then
        local switch = cytanb.NillableValue(nillableCamSwitch)
        camSwitchMap = {[switch.GetName()] = switch}
        table.insert(switchList, switch)
    else
        camSwitchMap = {}
    end

    if cytanb.NillableHasValue(nillableCamNextSwitch) then
        local nextSwitch = cytanb.NillableValue(nillableCamNextSwitch)
        camSwitchMap[nextSwitch.GetName()] = nextSwitch
        table.insert(switchList, nextSwitch)
    end

    if cytanb.NillableHasValue(nillableCamPrevSwitch) then
        local prevSwitch = cytanb.NillableValue(nillableCamPrevSwitch)
        camSwitchMap[prevSwitch.GetName()] = prevSwitch
        table.insert(switchList, prevSwitch)
    end

    camNextSwitchMap = {}
    camPrevSwitchMap = {}

    if #switchList >= 2 then
        camSwitchConnector.Add(switchList)
    else
        -- 1つ以下の場合は、コネクターを無効にする
        camSwitchConnector.SetEnabled(false)
    end
end

if conf.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelTrace)
end

local SetDisplayTrackIndex = function (index)
    if not cytanb.NillableHasValue(nillableCamSwitch) then
        return
    end

    local num = (index >= 1 and index <= directiveProcessor.GetTrackSize()) and index or 0
    for i = 0, conf.camSwitchDisplayTrackPlaceDigits - 1 do
        local name = conf.camSwitchDisplayTrackPlacePrefix .. i
        local d = num % 10
        vci.assets.SetMaterialTextureOffsetFromName(name, conf.camSwitchDisplayTrackTextureOffset * d)
        num = math.floor(num / 10)
    end
end

local EmitDirectiveStateMessage = function ()
    local state = directiveProcessor.GetState()
    local trackIndex = directiveProcessor.GetTrackIndex()
    cytanb.LogTrace('Emit directiveStateMessage: state = ', state, ', trackIndex = ', trackIndex)
    cytanb.EmitMessage(directiveStateMessageName, {state = state, trackIndex = trackIndex})
end

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    vciLoaded = true

    if vci.assets.IsMine and conf.camContainerToWorldOrigin then
        camContainer.SetPosition(Vector3.zero)
        camContainer.SetRotation(Quaternion.identity)
    end

    if cytanb.NillableHasValue(nillableCamSwitch) then
        vci.assets.SetMaterialTextureOffsetFromName(conf.camSwitchName, multiTrackSwitchEnabled and conf.camSwitchTextureOffset or Vector2.zero)
        SetDisplayTrackIndex(directiveProcessor.GetTrackIndex())
    end

    cytanb.OnInstanceMessage(commandMessageName, function (sender, name, parameterMap)
        if not vci.assets.IsMine then
            return
        end

        local command = parameterMap.command
        cytanb.LogTrace('onCommandMessage: ', command)
        if command == CommandMessageParameter.togglePlay then
            if directiveProcessor.GetState() == DirectiveProcessorState.processing then
                directiveProcessor.Stop()
            else
                directiveProcessor.Start()
            end
        elseif command == CommandMessageParameter.nextTrack then
            directiveProcessor.NextTrack()
        elseif command == CommandMessageParameter.prevTrack then
            directiveProcessor.PrevTrack()
        end
    end)

    cytanb.OnInstanceMessage(directiveStateMessageName, function (sender, name, parameterMap)
        local state = parameterMap.state
        local trackIndex = parameterMap.trackIndex
        cytanb.LogInfo('onDirectiveStateMessage: state = ', state, ', trackIndex = ', trackIndex)
        SetDisplayTrackIndex(trackIndex)
    end)

    cytanb.OnInstanceMessage(queryDirectiveStateMessageName, function (sender, name, parameterMap)
        if vci.assets.IsMine then
            cytanb.LogTrace('onQueryDirectiveStateMessage')
            EmitDirectiveStateMessage()
        end
    end)

    if conf.playOnLoad then
        directiveProcessor.Start()
    end

    if not vci.assets.IsMine then
        cytanb.EmitMessage(queryDirectiveStateMessageName)
    end
end

local OnUpdate = function (deltaTime, unscaledDeltaTime)
    if deltaTime <= TimeSpan.Zero then
        return
    end

    camSwitchConnector.Update()

    if vci.assets.IsMine then
        directiveProcessor.Update()
        local state = directiveProcessor.GetState()
        local trackIndex = directiveProcessor.GetTrackIndex()
        if state ~= lastDirectiveState or trackIndex ~= lastDirectiveTrackIndex then
            lastDirectiveState = state
            lastDirectiveTrackIndex = trackIndex
            EmitDirectiveStateMessage()
        end
    end
end

local UpdateCw = coroutine.wrap(function ()
    -- InstanceID を取得できるまで待つ。
    local MaxWaitTime = TimeSpan.FromSeconds(30)
    local unscaledStartTime = vci.me.UnscaledTime
    local unscaledLastTime = unscaledStartTime
    local lastTime = vci.me.Time
    local needWaiting = true
    while true do
        local id = cytanb.InstanceID()
        if id ~= '' then
            break
        end

        local unscaledNow = vci.me.UnscaledTime
        if unscaledNow > unscaledStartTime + MaxWaitTime then
            cytanb.LogError('TIMEOUT: Could not receive Instance ID.')
            return -1
        end

        unscaledLastTime = unscaledNow
        lastTime = vci.me.Time
        needWaiting = false
        coroutine.yield(100)
    end

    if needWaiting then
        -- VCI アイテムを出して 1 フレーム目の update 後に、onUngrab が発生するのを待つ。
        unscaledLastTime = vci.me.UnscaledTime
        lastTime = vci.me.Time
        coroutine.yield(100)
    end

    -- ロード完了。
    OnLoad()

    while true do
        local now = vci.me.Time
        local delta = now - lastTime
        local unscaledNow = vci.me.UnscaledTime
        local unscaledDelta = unscaledNow - unscaledLastTime
        OnUpdate(delta, unscaledDelta)
        lastTime = now
        unscaledLastTime = unscaledNow
        coroutine.yield(100)
    end
    -- return 0
end)

updateAll = function ()
    UpdateCw()
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    cytanb.LogTrace('onUse: ', use)

    if camSwitchMap[use] then
        cytanb.LogTrace('Emit toggle play command')
        cytanb.EmitMessage(commandMessageName, {command = CommandMessageParameter.togglePlay})
    elseif camNextSwitchMap[use] then
        cytanb.LogTrace('Emit next track command')
        cytanb.EmitMessage(commandMessageName, {command = CommandMessageParameter.nextTrack})
    elseif camPrevSwitchMap[use] then
        cytanb.LogTrace('Emit prev track command')
        cytanb.EmitMessage(commandMessageName, {command = CommandMessageParameter.prevTrack})
    end
end
