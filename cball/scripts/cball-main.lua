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

---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()math.randomseed(os.time()-os.clock()*10000)local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local a;local j=function(k,l)for m=1,4 do local n=k[m]-l[m]if n~=0 then return n end end;return 0 end;local o;o={__eq=function(k,l)return k[1]==l[1]and k[2]==l[2]and k[3]==l[3]and k[4]==l[4]end,__lt=function(k,l)return j(k,l)<0 end,__le=function(k,l)return j(k,l)<=0 end,__tostring=function(p)local q=p[2]or 0;local r=p[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(p[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(q,16),0xFFFF),bit32.band(q,0xFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(p[4]or 0,0xFFFFFFFF))end,__concat=function(k,l)local s=getmetatable(k)local t=s==o or type(s)=='table'and s.__concat==o.__concat;local u=getmetatable(l)local v=u==o or type(u)=='table'and u.__concat==o.__concat;if not t and not v then error('attempt to concatenate illegal values',2)end;return(t and o.__tostring(k)or k)..(v and o.__tostring(l)or l)end}local w='__CYTANB_CONST_VARIABLES'local x=function(table,y)local z=getmetatable(table)if z then local A=rawget(z,w)if A then local B=rawget(A,y)if type(B)=='function'then return B(table,y)else return B end end end;return nil end;local C=function(table,y,D)local z=getmetatable(table)if z then local A=rawget(z,w)if A then if rawget(A,y)~=nil then error('Cannot assign to read only field "'..y..'"',2)end end end;rawset(table,y,D)end;local E=function(F,G)local H=F[a.TypeParameterName]if a.NillableHasValue(H)and a.NillableValue(H)~=G then return false,false end;local I=c[G]if not a.NillableHasValue(I)then return false,false end;local J=a.NillableValue(I)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,D in pairs(F)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local m=1;while m<S do local V,W=string.find(P,a.EscapeSequenceTag,m,true)if not V then if m==1 then U=P else U=U..string.sub(P,m)end;break end;if V>m then U=U..string.sub(P,m,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)m=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;m=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,D in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(D)if a7=='string'then a4[a6]=O(D)elseif a7=='number'and D<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(D)else a4[a6]=a1(D,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,D in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(D)=='string'then a2[a6]=tonumber(D)elseif type(D)=='string'then a2[a6]=Q(D,function(ac)return e[ac]end)else a2[a6]=a8(D,a9)end end;local H=a2[a.TypeParameterName]if not a9 and a.NillableHasValue(H)then local I=c[a.NillableValue(H)]if a.NillableHasValue(I)then local ad,M=a.NillableValue(I).fromTableFunc(a2)if a.NillableHasValue(ad)and not M then return a.NillableValue(ad)end end end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(ae)return ae~=nil end,NillableValue=function(ae)if ae==nil then error('value is nil',2)end;return ae end,NillableValueOrDefault=function(ae,af)if ae==nil then if af==nil then error('defaultValue is nil',2)end;return af else return ae end end,SetConst=function(ag,ah,p)if type(ag)~='table'then error('Cannot set const to non-table target',2)end;local ai=getmetatable(ag)local z=ai or{}local aj=rawget(z,w)if rawget(ag,ah)~=nil then error('Non-const field "'..ah..'" already exists',2)end;if not aj then aj={}rawset(z,w,aj)z.__index=x;z.__newindex=C end;rawset(aj,ah,p)if not ai then setmetatable(ag,z)end;return ag end,SetConstEach=function(ag,ak)for N,D in pairs(ak)do a.SetConst(ag,N,D)end;return ag end,Extend=function(ag,al,am,an,a3)if ag==al or type(ag)~='table'or type(al)~='table'then return ag end;if am then if not a3 then a3={}end;if a3[al]then error('circular reference')end;a3[al]=true end;for N,D in pairs(al)do if am and type(D)=='table'then local ao=ag[N]ag[N]=a.Extend(type(ao)=='table'and ao or{},D,am,an,a3)else ag[N]=D end end;if not an then local ap=getmetatable(al)if type(ap)=='table'then if am then local aq=getmetatable(ag)setmetatable(ag,a.Extend(type(aq)=='table'and aq or{},ap,true))else setmetatable(ag,ap)end end end;if am then a3[al]=nil end;return ag end,Vars=function(D,ar,as,a3)local at;if ar then at=ar~='__NOLF'else ar='  'at=true end;if not as then as=''end;if not a3 then a3={}end;local au=type(D)if au=='table'then a3[D]=a3[D]and a3[D]+1 or 1;local av=at and as..ar or''local P='('..tostring(D)..') {'local aw=true;for y,ax in pairs(D)do if aw then aw=false else P=P..(at and','or', ')end;if at then P=P..'\n'..av end;if type(ax)=='table'and a3[ax]and a3[ax]>0 then P=P..y..' = ('..tostring(ax)..')'else P=P..y..' = '..a.Vars(ax,ar,av,a3)end end;if not aw and at then P=P..'\n'..as end;P=P..'}'a3[D]=a3[D]-1;if a3[D]<=0 then a3[D]=nil end;return P elseif au=='function'or au=='thread'or au=='userdata'then return'('..au..')'elseif au=='string'then return'('..au..') '..string.format('%q',D)else return'('..au..') '..tostring(D)end end,GetLogLevel=function()return f end,SetLogLevel=function(ay)f=ay end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(az)g=not not az end,Log=function(ay,...)if ay<=f then local aA=g and(h[ay]or'LOG LEVEL '..tostring(ay))..' | 'or''local aB=table.pack(...)if aB.n==1 then local D=aB[1]if D~=nil then local P=type(D)=='table'and a.Vars(D)or tostring(D)print(g and aA..P or P)else print(aA)end else local P=aA;for m=1,aB.n do local D=aB[m]if D~=nil then P=P..(type(D)=='table'and a.Vars(D)or tostring(D))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aC,aD)local table={}local aE=aD==nil;for N,D in pairs(aC)do table[D]=aE and D or aD end;return table end,Round=function(aF,aG)if aG then local aH=10^aG;return math.floor(aF*aH+0.5)/aH else return math.floor(aF+0.5)end end,Clamp=function(p,aI,aJ)return math.max(aI,math.min(p,aJ))end,Lerp=function(aK,aL,au)if au<=0.0 then return aK elseif au>=1.0 then return aL else return aK+(aL-aK)*au end end,LerpUnclamped=function(aK,aL,au)if au==0.0 then return aK elseif au==1.0 then return aL else return aK+(aL-aK)*au end end,
PingPong=function(au,aM)if aM==0 then return 0 end;local aN=math.floor(au/aM)local aO=au-aN*aM;if aN<0 then if(aN+1)%2==0 then return aM-aO else return aO end else if aN%2==0 then return aO else return aM-aO end end end,VectorApproximatelyEquals=function(aP,aQ)return(aP-aQ).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aP,aQ)local aR=Quaternion.Dot(aP,aQ)return aR<1.0+1E-06 and aR>1.0-1E-06 end,QuaternionToAngleAxis=function(aS)local aN=aS.normalized;local aT=math.acos(aN.w)local aU=math.sin(aT)local aV=math.deg(aT*2.0)local aW;if math.abs(aU)<=Quaternion.kEpsilon then aW=Vector3.right else local aX=1.0/aU;aW=Vector3.__new(aN.x*aX,aN.y*aX,aN.z*aX)end;return aV,aW end,ApplyQuaternionToVector3=function(aS,aY)local aZ=aS.w*aY.x+aS.y*aY.z-aS.z*aY.y;local a_=aS.w*aY.y-aS.x*aY.z+aS.z*aY.x;local b0=aS.w*aY.z+aS.x*aY.y-aS.y*aY.x;local b1=-aS.x*aY.x-aS.y*aY.y-aS.z*aY.z;return Vector3.__new(b1*-aS.x+aZ*aS.w+a_*-aS.z-b0*-aS.y,b1*-aS.y-aZ*-aS.z+a_*aS.w+b0*-aS.x,b1*-aS.z+aZ*-aS.y-a_*-aS.x+b0*aS.w)end,RotateAround=function(b2,b3,b4,b5)return b4+a.ApplyQuaternionToVector3(b5,b2-b4),b5*b3 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(b6)return o.__tostring(b6)end,UUIDFromNumbers=function(...)local b7=...local au=type(b7)local b8,b9,ba,bb;if au=='table'then b8=b7[1]b9=b7[2]ba=b7[3]bb=b7[4]else b8,b9,ba,bb=...end;local b6={bit32.band(b8 or 0,0xFFFFFFFF),bit32.band(b9 or 0,0xFFFFFFFF),bit32.band(ba or 0,0xFFFFFFFF),bit32.band(bb or 0,0xFFFFFFFF)}setmetatable(b6,o)return b6 end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bc='[0-9a-f-A-F]+'local bd='^('..bc..')$'local be='^-('..bc..')$'local bf,bg,bh,bi;if S==32 then local b6=a.UUIDFromNumbers(0,0,0,0)local bj=1;for m,bk in ipairs({8,16,24,32})do bf,bg,bh=string.find(string.sub(P,bj,bk),bd)if not bf then return nil end;b6[m]=tonumber(bh,16)bj=bk+1 end;return b6 else bf,bg,bh=string.find(string.sub(P,1,8),bd)if not bf then return nil end;local b8=tonumber(bh,16)bf,bg,bh=string.find(string.sub(P,9,13),be)if not bf then return nil end;bf,bg,bi=string.find(string.sub(P,14,18),be)if not bf then return nil end;local b9=tonumber(bh..bi,16)bf,bg,bh=string.find(string.sub(P,19,23),be)if not bf then return nil end;bf,bg,bi=string.find(string.sub(P,24,28),be)if not bf then return nil end;local ba=tonumber(bh..bi,16)bf,bg,bh=string.find(string.sub(P,29,36),bd)if not bf then return nil end;local bb=tonumber(bh,16)return a.UUIDFromNumbers(b8,b9,ba,bb)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bl)if type(bl)~='number'or bl<1 then error('Invalid argument: capacity = '..tostring(bl),2)end;local self;local bm=math.floor(bl)local U={}local bn=0;local bo=0;local bp=0;self={Size=function()return bp end,Clear=function()bn=0;bo=0;bp=0 end,IsEmpty=function()return bp==0 end,Offer=function(bq)U[bn+1]=bq;bn=(bn+1)%bm;if bp<bm then bp=bp+1 else bo=(bo+1)%bm end;return true end,OfferFirst=function(bq)bo=(bm+bo-1)%bm;U[bo+1]=bq;if bp<bm then bp=bp+1 else bn=(bm+bn-1)%bm end;return true end,Poll=function()if bp==0 then return nil else local bq=U[bo+1]bo=(bo+1)%bm;bp=bp-1;return bq end end,PollLast=function()if bp==0 then return nil else bn=(bm+bn-1)%bm;local bq=U[bn+1]bp=bp-1;return bq end end,Peek=function()if bp==0 then return nil else return U[bo+1]end end,PeekLast=function()if bp==0 then return nil else return U[(bm+bn-1)%bm+1]end end,Get=function(br)if br<1 or br>bp then a.LogError('CreateCircularQueue.Get: index is outside the range: '..br)return nil end;return U[(bo+br-1)%bm+1]end,IsFull=function()return bp>=bm end,MaxSize=function()return bm end}return self end,DetectClicks=function(bs,bt,bu)local bv=bs or 0;local bw=bu or TimeSpan.FromMilliseconds(500)local bx=vci.me.Time;local by=bt and bx>bt+bw and 1 or bv+1;return by,bx end,ColorFromARGB32=function(bz)local bA=type(bz)=='number'and bz or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bA,16),0xFF)/0xFF,bit32.band(bit32.rshift(bA,8),0xFF)/0xFF,bit32.band(bA,0xFF)/0xFF,bit32.band(bit32.rshift(bA,24),0xFF)/0xFF)end,ColorToARGB32=function(bB)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bB.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bB.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bB.g),0xFF),8),bit32.band(a.Round(0xFF*bB.b),0xFF))end,ColorFromIndex=function(bC,bD,bE,bF,bG)local bH=math.max(math.floor(bD or a.ColorHueSamples),1)local bI=bG and bH or bH-1;local bJ=math.max(math.floor(bE or a.ColorSaturationSamples),1)local bK=math.max(math.floor(bF or a.ColorBrightnessSamples),1)local br=a.Clamp(math.floor(bC or 0),0,bH*bJ*bK-1)local bL=br%bH;local bM=math.floor(br/bH)local aX=bM%bJ;local bN=math.floor(bM/bJ)if bG or bL~=bI then local B=bL/bI;local bO=(bJ-aX)/bJ;local D=(bK-bN)/bK;return Color.HSVToRGB(B,bO,D)else local D=(bK-bN)/bK*aX/(bJ-1)return Color.HSVToRGB(0.0,0.0,D)end end,ColorToTable=function(bB)return{[a.TypeParameterName]=a.ColorTypeName,r=bB.r,g=bB.g,b=bB.b,a=bB.a}end,ColorFromTable=function(F)local aL,M=E(F,a.ColorTypeName)return aL and Color.__new(F.r,F.g,F.b,F.a)or nil,M end,
Vector2ToTable=function(p)return{[a.TypeParameterName]=a.Vector2TypeName,x=p.x,y=p.y}end,Vector2FromTable=function(F)local aL,M=E(F,a.Vector2TypeName)return aL and Vector2.__new(F.x,F.y)or nil,M end,Vector3ToTable=function(p)return{[a.TypeParameterName]=a.Vector3TypeName,x=p.x,y=p.y,z=p.z}end,Vector3FromTable=function(F)local aL,M=E(F,a.Vector3TypeName)return aL and Vector3.__new(F.x,F.y,F.z)or nil,M end,Vector4ToTable=function(p)return{[a.TypeParameterName]=a.Vector4TypeName,x=p.x,y=p.y,z=p.z,w=p.w}end,Vector4FromTable=function(F)local aL,M=E(F,a.Vector4TypeName)return aL and Vector4.__new(F.x,F.y,F.z,F.w)or nil,M end,QuaternionToTable=function(p)return{[a.TypeParameterName]=a.QuaternionTypeName,x=p.x,y=p.y,z=p.z,w=p.w}end,QuaternionFromTable=function(F)local aL,M=E(F,a.QuaternionTypeName)return aL and Quaternion.__new(F.x,F.y,F.z,F.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ah,bP)local table=bP and a.TableToSerializable(bP)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ah,json.serialize(table))end,OnMessage=function(ah,bQ)local bR=function(bS,bT,bU)local bV=nil;if bS.type~='comment'and type(bU)=='string'then local bW,a4=pcall(json.parse,bU)if bW and type(a4)=='table'then bV=a.TableFromSerializable(a4)end end;local bP=bV and bV or{[a.MessageValueParameterName]=bU}bQ(bS,bT,bP)end;vci.message.On(ah,bR)return{Off=function()if bR then bR=nil end end}end,OnInstanceMessage=function(ah,bQ)local bR=function(bS,bT,bP)local bX=a.InstanceID()if bX~=''and bX==bP[a.InstanceIDParameterName]then bQ(bS,bT,bP)end end;return a.OnMessage(ah,bR)end,GetEffekseerEmitterMap=function(ah)local bY=vci.assets.GetEffekseerEmitters(ah)if not bY then return nil end;local bZ={}for m,b_ in pairs(bY)do bZ[b_.EffectName]=b_ end;return bZ end,CreateSubItemConnector=function()local c0=function(c1,c2,c3)c1.item=c2;c1.position=c2.GetPosition()c1.rotation=c2.GetRotation()c1.initialPosition=c1.position;c1.initialRotation=c1.rotation;c1.propagation=not not c3;return c1 end;local c4=function(c5)for c2,c1 in pairs(c5)do c0(c1,c2,c1.propagation)end end;local c6=function(c7,b5,c1,c8,c9)local ca=c7-c1.initialPosition;local cb=b5*Quaternion.Inverse(c1.initialRotation)c1.position=c7;c1.rotation=b5;for c2,cc in pairs(c8)do if c2~=c1.item and(not c9 or c9(cc))then cc.position,cc.rotation=a.RotateAround(cc.initialPosition+ca,cc.initialRotation,c7,cb)c2.SetPosition(cc.position)c2.SetRotation(cc.rotation)end end end;local cd={}local ce=true;local cf=false;local self={IsEnabled=function()return ce end,SetEnabled=function(az)ce=az;if az then c4(cd)cf=false end end,Contains=function(cg)return a.NillableHasValue(cd[cg])end,GetItems=function()local ch={}for c2,c1 in pairs(cd)do table.insert(ch,c2)end;return ch end,Add=function(ci,cj)if not ci then error('INVALID ARGUMENT: subItems = '..tostring(ci))end;local ch=type(ci)=='table'and ci or{ci}c4(cd)cf=false;for N,c2 in pairs(ch)do cd[c2]=c0({},c2,not cj)end end,Remove=function(cg)local aL=a.NillableHasValue(cd[cg])cd[cg]=nil;return aL end,RemoveAll=function()cd={}return true end,Update=function()if not ce then return end;local ck=false;for c2,c1 in pairs(cd)do local cl=c2.GetPosition()local cm=c2.GetRotation()if not a.VectorApproximatelyEquals(cl,c1.position)or not a.QuaternionApproximatelyEquals(cm,c1.rotation)then if c1.propagation then if c2.IsMine then c6(cl,cm,cd[c2],cd,function(cc)if cc.item.IsMine then return true else cf=true;return false end end)ck=true;break else cf=true end else cf=true end end end;if not ck and cf then c4(cd)cf=false end end}return self end,GetSubItemTransform=function(cg)local c7=cg.GetPosition()local b5=cg.GetRotation()local cn=cg.GetLocalScale()return{positionX=c7.x,positionY=c7.y,positionZ=c7.z,rotationX=b5.x,rotationY=b5.y,rotationZ=b5.z,rotationW=b5.w,scaleX=cn.x,scaleY=cn.y,scaleZ=cn.z}end,RestoreCytanbTransform=function(co)local cl=co.positionX and co.positionY and co.positionZ and Vector3.__new(co.positionX,co.positionY,co.positionZ)or nil;local cm=co.rotationX and co.rotationY and co.rotationZ and co.rotationW and Quaternion.__new(co.rotationX,co.rotationY,co.rotationZ,co.rotationW)or nil;local cn=co.scaleX and co.scaleY and co.scaleZ and Vector3.__new(co.scaleX,co.scaleY,co.scaleZ)or nil;return cl,cm,cn end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i=vci.state.Get(b)or''if i==''and vci.assets.IsMine then i=tostring(a.RandomUUID())vci.state.Set(b,i)end;return a end)()

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
local statusMessageName = cballNS .. '.status'
local queryStatusMessageName = cballNS .. '.query-status'
local discernibleColorChangedMessageName = cballNS .. '.discernible-color-changed'
local ballStatusChangedMessageName = cballNS .. '.ball-status-changed'
local respawnBallMessageName = cballNS .. '.respawn-ball'
local buildStandLightMessageName = cballNS .. '.build-standlight'
local buildAllStandLightsMessageName = cballNS .. '.build-all-standlights'
local hitMessageName = cballNS .. '.hit'
local showSettingsPanelMessageName = cballNS .. '.show-settings-panel'

local colorPaletteItemStatusMessageName = 'cytanb.color-palette.item-status'

--- VCI がロードされたか。
local vciLoaded = false

local hiddenPosition

local avatarColliderMap = cytanb.ListToMap(settings.avatarColliders, true)

local ball, ballEfkContainer, ballEfk, ballEfkFade, ballEfkFadeMove, ballEfkOne, ballEfkOneLarge, ballDiscernibleEfk, ballCup, standLights, standLightEfkContainer, standLightHitEfk, standLightDirectHitEfk, impactForceGauge, impactSpinGauge, settingsPanel, closeSwitch, adjustmentSwitches, propertyNameSwitchMap

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

--- 識別エフェクトの色。
local discernibleColor = Color.__new(0.0, 0.8, 0.8, 0.25)

--- 最後に識別エフェクトを再生した時間。
local lastDiscernibleEfkPlayTime = TimeSpan.Zero

--- ライトを組み立てるリクエストを送った時間。
local standLightsLastRequestTime = vci.me.Time

--- カラーパレットへの接触カウント
local colorPaletteCollisionCount = 0

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local CalcDirectionAngle = function (angle360)
    local angle = angle360 % 360
    return (angle <= 180 and angle or angle - 360)
end

local CalcAngularVelocity = function (axis, directionAngle180, seconds)
    return axis * ((directionAngle180 <= 0 and 1 or -1) * math.rad(directionAngle180 / seconds))
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
                grabCount, grabTime = cytanb.DetectClicks(grabCount, grabTime, settings.settingsPanelGrabClickTiming)
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
            cytanb.LogInfo('on update[', switchName, ']: value = ', value)
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

local PlayDiscernibleEfk = function (playNow)
    local efkLevel = propertyNameSwitchMap[settings.efkLevelPropertyName].GetValue()
    if efkLevel >= 4 then
        local now = vci.me.Time
        local expired = now >= lastDiscernibleEfkPlayTime + settings.discernibleEfkPeriod
        if expired or playNow then
            if not expired then
                ballDiscernibleEfk.Stop()
            end
            lastDiscernibleEfkPlayTime = now
            ballDiscernibleEfk.Play()
            ballDiscernibleEfk.SetAllColor(discernibleColor)
        end
    end
end

local StopDiscernibleEfk = function ()
    if lastDiscernibleEfkPlayTime ~= TimeSpan.Zero then
        ballDiscernibleEfk.Stop()
        lastDiscernibleEfkPlayTime = TimeSpan.Zero
    end
end

local CreateBallStatusParameter = function ()
    return {
        name = ball.GetName(),
        position = cytanb.Vector3ToTable(ball.GetPosition()),
        rotation = cytanb.QuaternionToTable(ball.GetRotation()),
        longSide = settings.ballSimLongSide,
        mass = settings.ballSimMass,
        grabbed = ballGrabbed,
        operator = ball.IsMine
    }
end

local CreateStatusParameter = function ()
    return {
        owner = vci.assets.IsMine,
        clientID = settings.localSharedProperties.GetClientID(),
        discernibleColor = discernibleColor,
        ball = CreateBallStatusParameter()
    }
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
        if efkLevel == 0 and ball.IsMine then
            -- レベル 0 で、ボールの操作権があるときは、レベル 1 のエフェクトを表示する
            efkLevel = 1
        end

        if efkLevel >= 1 then
            local efk = ls.directHit and standLightDirectHitEfk or standLightHitEfk
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
    StopDiscernibleEfk()
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

        if headTime - element.time > settings.ballKinematicDetectionTimeThreshold then
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

--- コントローラーの運動による投球。
local ThrowBallByKinematic = function ()
    -- 物理運動の正しさではなく、簡単に投げられて楽しめるものを目指して、計算を行う。
    -- 理由は、機器、投げ方、操作の慣れなどは、人それぞれ違うので、なるべく多くの人に楽しんでほしいから。

    DrawThrowingTrail()

    if not ball.IsMine or ballTransformQueue.Size() < 2 then
        return
    end

    -- detection time に関しては、UI 上の正負を反転させる。
    local detectionSec = CalcAdjustment(- propertyNameSwitchMap[settings.ballKinematicDetectionTimePropertyName].GetValue(), settings.ballKinematicMinDetectionTime.TotalSeconds, settings.ballKinematicMaxDetectionTime.TotalSeconds)
    -- cytanb.LogTrace('detectionSec = ', detectionSec)

    local headTransform = ballTransformQueue.PollLast()
    local headTime = headTransform.time
    local ballPos = headTransform.position
    local ballRot = headTransform.rotation

    local velocityDirection = Vector3.zero
    local totalVelocityMagnitude = 0

    local angularVelocityDirection = Vector3.zero
    local totalAngle = 0

    local totalSec = 0

    local st = headTime
    local sp = ballPos
    local sr = ballRot

    while true do
        local element = ballTransformQueue.PollLast()
        if not element then
            break
        end

        local kdTime = headTime - element.time
        -- cytanb.LogTrace('kdTime: ', kdTime.TotalSeconds)
        if kdTime > settings.ballKinematicDetectionTimeThreshold then
            break
        end

        if kdTime.TotalSeconds > detectionSec and velocityDirection ~= Vector3.zero then
            break
        end

        local deltaSec = (st - element.time).totalSeconds
        if deltaSec > Vector3.kEpsilon then
            local directionWeight = math.max(0.0, 1.0 - settings.ballKinematicDetectionFactor * (headTime - st).totalSeconds / detectionSec)
            -- cytanb.LogTrace('directionWeight = ', directionWeight)

            local dp = sp - element.position
            totalVelocityMagnitude = totalVelocityMagnitude + dp.magnitude
            velocityDirection = velocityDirection + dp * (directionWeight / deltaSec)

            local dr = sr * Quaternion.Inverse(element.rotation)
            local da, axis = cytanb.QuaternionToAngleAxis(dr)
            if (da ~= 0 and da ~= 360) or axis ~= Vector3.right then
                local angle = CalcDirectionAngle(da)
                totalAngle = totalAngle + angle
                angularVelocityDirection = angularVelocityDirection + CalcAngularVelocity(axis, angle * directionWeight, deltaSec)
            end

            totalSec = (headTime - element.time).totalSeconds
        end

        -- cytanb.LogTrace('velocityDirection: ', velocityDirection, ', angularVelocityDirection: ', angularVelocityDirection)
        st = element.time
        sp = element.position
        sr = element.rotation
    end
    ballTransformQueue.Clear()

    local velocityMagnitude
    if totalSec > Vector3.kEpsilon then
        local velocityFactor = CalcAdjustment(propertyNameSwitchMap[settings.ballVelocityAdjustmentPropertyName].GetValue(), settings.ballKinematicMinVelocityFactor, settings.ballKinematicMaxVelocityFactor)
        velocityMagnitude = velocityFactor * totalVelocityMagnitude / totalSec
    else
        velocityMagnitude = 0
    end

    -- cytanb.LogTrace('velocity magnitude: ', velocityMagnitude)
    if velocityMagnitude > settings.ballKinematicVelocityThreshold then
        local altitudeAdjustment = CalcAdjustment(propertyNameSwitchMap[settings.ballAltitudeAdjustmentPropertyName].GetValue(), settings.ballKinematicMinAltitudeFactor, settings.ballKinematicMaxAltitudeFactor)
        local velocity = ApplyAltitudeAngle(velocityDirection.normalized, altitudeAdjustment) * velocityMagnitude
        local forwardOffset = velocity * (math.min(velocityMagnitude * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset) / velocityMagnitude)

        local angularVelocityFactor = CalcAdjustment(propertyNameSwitchMap[settings.ballAngularVelocityAdjustmentPropertyName].GetValue(), settings.ballKinematicMinAngularVelocityFactor, settings.ballKinematicMaxAngularVelocityFactor)
        local angularVelocity = CalcAngularVelocity(angularVelocityDirection.normalized, angularVelocityFactor * totalAngle, totalSec)

        cytanb.LogTrace('Throw ball by kinematic: velocity: ', velocity, ', velocity.magnitude: ', velocity.magnitude, ', angularVelocity: ', angularVelocity, ', angularVelocity.magnitude: ', angularVelocity.magnitude)
        ballSimAngularVelocity = angularVelocity
        ball.SetVelocity(velocity)
        ball.SetAngularVelocity(angularVelocity)

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
    cytanb.LogTrace('velocity: ', velocity, ', velociyt.magnitude: ', velocity.magnitude, ', angularVelocity: ', ballSimAngularVelocity, ', angularVelocity.magnitude: ', ballSimAngularVelocity.magnitude)

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
    settings.localSharedProperties.UpdateAlive()
    vciLoaded = true

    local uuid = cytanb.UUIDFromString(cytanb.InstanceID())
    hiddenPosition = Vector3.__new(uuid[1] / 0x100000, 0x1000, uuid[2] / 0x100000)
    cytanb.LogTrace('hiddenPosition: ', hiddenPosition)

    ball = vci.assets.GetSubItem(settings.ballName)
    ballEfkContainer = vci.assets.GetSubItem(settings.ballEfkContainerName)

    local ballEfkMap = cytanb.GetEffekseerEmitterMap(settings.ballEfkContainerName)
    ballEfk = ballEfkMap[settings.ballEfkName]
    ballEfkFade = ballEfkMap[settings.ballEfkFadeName]
    ballEfkFadeMove = ballEfkMap[settings.ballEfkFadeMoveName]
    ballEfkOne = ballEfkMap[settings.ballEfkOneName]
    ballEfkOneLarge = ballEfkMap[settings.ballEfkOneLargeName]

    ballDiscernibleEfk = vci.assets.GetEffekseerEmitter(settings.ballName)

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

    local standLightEfkMap = cytanb.GetEffekseerEmitterMap(settings.standLightEfkContainerName)
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

    if vci.assets.IsMine then
        -- 全 VCI からのクエリーに応答する。
        cytanb.OnMessage(queryStatusMessageName, function (sender, name, parameterMap)
            cytanb.LogDebug('onQueryStatus')
            cytanb.EmitMessage(statusMessageName, CreateStatusParameter())
        end)
    end

    cytanb.OnInstanceMessage(statusMessageName, function (sender, name, parameterMap)
        cytanb.LogDebug('onStatus')
        if parameterMap.clientID ~= settings.localSharedProperties.GetClientID() then
            discernibleColor = cytanb.NillableValueOrDefault(parameterMap.discernibleColor, discernibleColor)
        end
    end)

    cytanb.OnInstanceMessage(discernibleColorChangedMessageName, function (sender, name, parameterMap)
        cytanb.LogDebug('onDiscernibleColorChangedMessageName')
        if parameterMap.clientID ~= settings.localSharedProperties.GetClientID() then
            discernibleColor = cytanb.NillableValueOrDefault(parameterMap.discernibleColor, discernibleColor)
        end
    end)

    cytanb.OnInstanceMessage(ballStatusChangedMessageName, function (sender, name, parameterMap)
        cytanb.LogDebug('onBallStatusChanged')
        if not ball.IsMine and parameterMap.clientID ~= settings.localSharedProperties.GetClientID() then
            -- 他人が操作しているボールの状態が変わった場合は、識別エフェクトの処理を行う
            local ballStatus = parameterMap.ball
            if ballStatus.operator and ballStatus.grabbed then
                StopDiscernibleEfk()
            end
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

    cytanb.OnMessage(colorPaletteItemStatusMessageName, function (sender, name, parameterMap)
        if ball.IsMine and colorPaletteCollisionCount >= 1 then
            discernibleColor = cytanb.ColorFromARGB32(parameterMap.argb32)
            PlayDiscernibleEfk(true)

            cytanb.EmitMessage(discernibleColorChangedMessageName, CreateStatusParameter())
        end
    end)

    if vci.assets.IsMine then
        cytanb.EmitMessage(showSettingsPanelMessageName)
    else
        cytanb.EmitMessage(queryStatusMessageName)
    end
end

--- ゲージの表示を更新する。
local OnUpdateImpactGauge = function (deltaTime, unscaledDeltaTime)
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
local OnUpdateBall = function (deltaTime, unscaledDeltaTime)
    local ballPos = ball.GetPosition()
    local ballRot = ball.GetRotation()
    local moving = false
    local respawned = false

    if not ballGrabbed and not ballTransformQueue.IsEmpty() then
        local lastTransform = ballTransformQueue.PeekLast()
        local lastPos = lastTransform.position
        moving = (ballPos - lastPos).sqrMagnitude > 0.0025

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
                if efkLevel == 0 and ball.IsMine then
                    -- レベル 0 で、ボールの操作権があるときは、レベル 1 のエフェクトを表示する
                    efkLevel = 1
                end

                if efkLevel >= 1 then
                    local vm = velocity.magnitude
                    if vm >= settings.ballTrailVelocityThreshold then
                        local near = cupSqrDistance <= settings.ballNearDistance ^ 2
                        local vmNodes = math.max(1, math.ceil(vm / (settings.ballSimLongSide * settings.ballTrailInterpolationDistanceFactor * (near and 0.5 or 1.0) / deltaSec)))
                        local nodes = math.min(vmNodes, settings.ballTrailInterpolationNodesPerFrame + cytanb.Clamp(math.floor((efkLevel - 1 + (near and 1 or 0)) * 2), 0, 4))
                        local iNodes = 1.0 / nodes
                        local efk
                        if near then
                            -- 近距離の場合は、エフェクトレベルに合わせる
                            if efkLevel >= 3 then
                                efk = ballEfkFadeMove
                            elseif efkLevel == 2 then
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

    if moving then
        if colorPaletteCollisionCount <= 0 then
            -- ボールが動いている時は、識別エフェクトを停止する。
            StopDiscernibleEfk()
        end
    elseif not ballGrabbed then
        -- ボールが動いていない場合は、識別エフェクトを再生する
        PlayDiscernibleEfk()
    end

    if not respawned then
        OfferBallTransform(ballPos, ballRot)
    end
end

--- ライトが倒れた判定、復活処理を行う。
local OnUpdateStandLight = function (deltaTime, unscaledDeltaTime)
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

local OnUpdate = function (deltaTime, unscaledDeltaTime)
    settings.localSharedProperties.UpdateAlive()

    if deltaTime <= TimeSpan.Zero then
        return
    end

    OnUpdateImpactGauge(deltaTime, unscaledDeltaTime)
    OnUpdateBall(deltaTime, unscaledDeltaTime)
    OnUpdateStandLight(deltaTime, unscaledDeltaTime)
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

onGrab = function (target)
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
        StopDiscernibleEfk()
        cytanb.EmitMessage(statusMessageName, CreateStatusParameter())
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

onUngrab = function (target)
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

onUse = function (use)
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
        cupClickCount, cupClickTime = cytanb.DetectClicks(cupClickCount, cupClickTime)
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

onCollisionEnter = function (item, hit)
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

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    if item == ball.GetName() then
        if string.startsWith(hit, settings.colorIndexNamePrefix) then
            colorPaletteCollisionCount = colorPaletteCollisionCount + 1
            cytanb.TraceLog('onTriggerEnter: colorPaletteCollisionCount = ', colorPaletteCollisionCount, ' hit = ', hit)
        end
    end
end

onTriggerExit = function (item, hit)
    if not vciLoaded then
        return
    end

    if item == ball.GetName() then
        if string.startsWith(hit, settings.colorIndexNamePrefix) then
            colorPaletteCollisionCount = colorPaletteCollisionCount - 1
            cytanb.TraceLog('onTriggerExit: colorPaletteCollisionCount = ', colorPaletteCollisionCount, ' hit = ', hit)
        end
    end
end
