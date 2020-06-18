-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,{[a.EscapeSequenceTag]=a.EscapeSequenceTag..a.EscapeSequenceTag}),'/',{['/']=a.SolidusTag})end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(af)return af~=nil end,NillableValue=function(af)if af==nil then error('nillable: value is nil',2)end;return af end,NillableValueOrDefault=function(af,ag)if af==nil then if ag==nil then error('nillable: defaultValue is nil',2)end;return ag else return af end end,NillableIfHasValue=function(af,ah)if af==nil then return nil else return ah(af)end end,NillableIfHasValueOrElse=function(af,ah,ai)if af==nil then return ai()else return ah(af)end end,StringReplace=function(P,aj,ak)local al;local S=string.len(P)if aj==''then al=ak;for n=1,S do al=al..string.sub(P,n,n)..ak end else al=''local n=1;while true do local am,V=string.find(P,aj,n,true)if am then al=al..string.sub(P,n,am-1)..ak;n=V+1;if n>S then break end else al=n==1 and P or al..string.sub(P,n)break end end end;return al end,SetConst=function(aj,an,q)if type(aj)~='table'then error('Cannot set const to non-table target',2)end;local ao=getmetatable(aj)local A=ao or{}local ap=rawget(A,x)if rawget(aj,an)~=nil then error('Non-const field "'..an..'" already exists',2)end;if not ap then ap={}rawset(A,x,ap)A.__index=y;A.__newindex=D end;rawset(ap,an,q)if not ao then setmetatable(aj,A)end;return aj end,SetConstEach=function(aj,aq)for N,E in pairs(aq)do a.SetConst(aj,N,E)end;return aj end,Extend=function(aj,ar,as,at,a3)if aj==ar or type(aj)~='table'or type(ar)~='table'then return aj end;if as then if not a3 then a3={}end;if a3[ar]then error('circular reference')end;a3[ar]=true end;for N,E in pairs(ar)do if as and type(E)=='table'then local au=aj[N]aj[N]=a.Extend(type(au)=='table'and au or{},E,as,at,a3)else aj[N]=E end end;if not at then local av=getmetatable(ar)if type(av)=='table'then if as then local aw=getmetatable(aj)setmetatable(aj,a.Extend(type(aw)=='table'and aw or{},av,true))else setmetatable(aj,av)end end end;if as then a3[ar]=nil end;return aj end,Vars=function(E,ax,ay,a3)local az;if ax then az=ax~='__NOLF'else ax='  'az=true end;if not ay then ay=''end;if not a3 then a3={}end;local aA=type(E)if aA=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local aB=az and ay..ax or''local P='('..tostring(E)..') {'local aC=true;for z,aD in pairs(E)do if aC then aC=false else P=P..(az and','or', ')end;if az then P=P..'\n'..aB end;if type(aD)=='table'and a3[aD]and a3[aD]>0 then P=P..z..' = ('..tostring(aD)..')'else P=P..z..' = '..a.Vars(aD,ax,aB,a3)end end;if not aC and az then P=P..'\n'..ay end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif aA=='function'or aA=='thread'or aA=='userdata'then return'('..aA..')'elseif aA=='string'then return'('..aA..') '..string.format('%q',E)else return'('..aA..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aE)f=aE end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aF)g=not not aF end,Log=function(aE,...)if aE<=f then local aG=g and(h[aE]or'LOG LEVEL '..tostring(aE))..' | 'or''local aH=table.pack(...)if aH.n==1 then local E=aH[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aG..P or P)else print(aG)end else local P=aG;for n=1,aH.n do local E=aH[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aI,aJ)local aK={}if aJ==nil then for N,E in pairs(aI)do aK[E]=E end elseif type(aJ)=='function'then for N,E in pairs(aI)do local aL,aM=aJ(E)aK[aL]=aM end else for N,E in pairs(aI)do aK[E]=aJ end end;return aK end,Round=function(aN,aO)if aO then local aP=10^aO;return math.floor(aN*aP+0.5)/aP else return math.floor(aN+0.5)end end,Clamp=function(q,aQ,aR)return math.max(aQ,math.min(q,aR))end,Lerp=function(aS,aT,aA)if aA<=0.0 then return aS elseif aA>=1.0 then return aT else return aS+(aT-aS)*aA end end,LerpUnclamped=function(aS,aT,aA)if aA==0.0 then return aS elseif aA==1.0 then return aT else return aS+(aT-aS)*aA end end,PingPong=function(aA,aU)if aU==0 then return 0,1 end;local aV=math.floor(aA/aU)local aW=aA-aV*aU;if aV<0 then if(aV+1)%2==0 then return aU-aW,-1 else return aW,1 end else if aV%2==0 then return aW,1 else return aU-aW,-1 end end end,VectorApproximatelyEquals=function(aX,aY)return(aX-aY).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aX,aY)local aZ=Quaternion.Dot(aX,aY)return aZ<1.0+1E-06 and aZ>1.0-1E-06 end,
QuaternionToAngleAxis=function(a_)local aV=a_.normalized;local b0=math.acos(aV.w)local b1=math.sin(b0)local b2=math.deg(b0*2.0)local b3;if math.abs(b1)<=Quaternion.kEpsilon then b3=Vector3.right else local am=1.0/b1;b3=Vector3.__new(aV.x*am,aV.y*am,aV.z*am)end;return b2,b3 end,QuaternionTwist=function(a_,b4)if b4.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local b5=Vector3.__new(a_.x,a_.y,a_.z)if b5.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b6=Vector3.Project(b5,b4)if b6.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b7=Quaternion.__new(b6.x,b6.y,b6.z,a_.w)b7.Normalize()return b7 else return Quaternion.AngleAxis(0,b4)end else local b8=a.QuaternionToAngleAxis(a_)return Quaternion.AngleAxis(b8,b4)end end,ApplyQuaternionToVector3=function(a_,b9)local ba=a_.w*b9.x+a_.y*b9.z-a_.z*b9.y;local bb=a_.w*b9.y-a_.x*b9.z+a_.z*b9.x;local bc=a_.w*b9.z+a_.x*b9.y-a_.y*b9.x;local bd=-a_.x*b9.x-a_.y*b9.y-a_.z*b9.z;return Vector3.__new(bd*-a_.x+ba*a_.w+bb*-a_.z-bc*-a_.y,bd*-a_.y-ba*-a_.z+bb*a_.w+bc*-a_.x,bd*-a_.z+ba*-a_.y-bb*-a_.x+bc*a_.w)end,RotateAround=function(be,bf,bg,bh)return bg+bh*(be-bg),bh*bf end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bi)return p.__tostring(bi)end,UUIDFromNumbers=function(...)local bj=...local aA=type(bj)local bk,bl,bm,bn;if aA=='table'then bk=bj[1]bl=bj[2]bm=bj[3]bn=bj[4]else bk,bl,bm,bn=...end;local bi={bit32.band(bk or 0,0xFFFFFFFF),bit32.band(bl or 0,0xFFFFFFFF),bit32.band(bm or 0,0xFFFFFFFF),bit32.band(bn or 0,0xFFFFFFFF)}setmetatable(bi,p)return bi end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bo='[0-9a-f-A-F]+'local bp='^('..bo..')$'local bq='^-('..bo..')$'local br,bs,bt,bu;if S==32 then local bi=a.UUIDFromNumbers(0,0,0,0)local bv=1;for n,bw in ipairs({8,16,24,32})do br,bs,bt=string.find(string.sub(P,bv,bw),bp)if not br then return nil end;bi[n]=tonumber(bt,16)bv=bw+1 end;return bi else br,bs,bt=string.find(string.sub(P,1,8),bp)if not br then return nil end;local bk=tonumber(bt,16)br,bs,bt=string.find(string.sub(P,9,13),bq)if not br then return nil end;br,bs,bu=string.find(string.sub(P,14,18),bq)if not br then return nil end;local bl=tonumber(bt..bu,16)br,bs,bt=string.find(string.sub(P,19,23),bq)if not br then return nil end;br,bs,bu=string.find(string.sub(P,24,28),bq)if not br then return nil end;local bm=tonumber(bt..bu,16)br,bs,bt=string.find(string.sub(P,29,36),bp)if not br then return nil end;local bn=tonumber(bt,16)return a.UUIDFromNumbers(bk,bl,bm,bn)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bx)if type(bx)~='number'or bx<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bx),2)end;local self;local by=math.floor(bx)local U={}local bz=0;local bA=0;local bB=0;self={Size=function()return bB end,Clear=function()bz=0;bA=0;bB=0 end,IsEmpty=function()return bB==0 end,Offer=function(bC)U[bz+1]=bC;bz=(bz+1)%by;if bB<by then bB=bB+1 else bA=(bA+1)%by end;return true end,OfferFirst=function(bC)bA=(by+bA-1)%by;U[bA+1]=bC;if bB<by then bB=bB+1 else bz=(by+bz-1)%by end;return true end,Poll=function()if bB==0 then return nil else local bC=U[bA+1]bA=(bA+1)%by;bB=bB-1;return bC end end,PollLast=function()if bB==0 then return nil else bz=(by+bz-1)%by;local bC=U[bz+1]bB=bB-1;return bC end end,Peek=function()if bB==0 then return nil else return U[bA+1]end end,PeekLast=function()if bB==0 then return nil else return U[(by+bz-1)%by+1]end end,Get=function(bD)if bD<1 or bD>bB then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bD)return nil end;return U[(bA+bD-1)%by+1]end,IsFull=function()return bB>=by end,MaxSize=function()return by end}return self end,DetectClicks=function(bE,bF,bG)local bH=bE or 0;local bI=bG or TimeSpan.FromMilliseconds(500)local bJ=vci.me.Time;local bK=bF and bJ>bF+bI and 1 or bH+1;return bK,bJ end,ColorRGBToHSV=function(bL)local aW=math.max(0.0,math.min(bL.r,1.0))local bM=math.max(0.0,math.min(bL.g,1.0))local aT=math.max(0.0,math.min(bL.b,1.0))local aR=math.max(aW,bM,aT)local aQ=math.min(aW,bM,aT)local bN=aR-aQ;local C;if bN==0.0 then C=0.0 elseif aR==aW then C=(bM-aT)/bN/6.0 elseif aR==bM then C=(2.0+(aT-aW)/bN)/6.0 else C=(4.0+(aW-bM)/bN)/6.0 end;if C<0.0 then C=C+1.0 end;local bO=aR==0.0 and bN or bN/aR;local E=aR;return C,bO,E end,ColorFromARGB32=function(bP)local bQ=type(bP)=='number'and bP or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bQ,16),0xFF)/0xFF,bit32.band(bit32.rshift(bQ,8),0xFF)/0xFF,bit32.band(bQ,0xFF)/0xFF,bit32.band(bit32.rshift(bQ,24),0xFF)/0xFF)end,ColorToARGB32=function(bL)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bL.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bL.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bL.g),0xFF),8),bit32.band(a.Round(0xFF*bL.b),0xFF))end,ColorFromIndex=function(bR,bS,bT,bU,bV)local bW=math.max(math.floor(bS or a.ColorHueSamples),1)local bX=bV and bW or bW-1;local bY=math.max(math.floor(bT or a.ColorSaturationSamples),1)local bZ=math.max(math.floor(bU or a.ColorBrightnessSamples),1)local bD=a.Clamp(math.floor(bR or 0),0,bW*bY*bZ-1)local b_=bD%bW;local c0=math.floor(bD/bW)local am=c0%bY;local c1=math.floor(c0/bY)if bV or b_~=bX then local C=b_/bX;local bO=(bY-am)/bY;local E=(bZ-c1)/bZ;return Color.HSVToRGB(C,bO,E)else local E=(bZ-c1)/bZ*am/(bY-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bL,bS,bT,bU,bV)local bW=math.max(math.floor(bS or a.ColorHueSamples),1)local bX=bV and bW or bW-1;local bY=math.max(math.floor(bT or a.ColorSaturationSamples),1)local bZ=math.max(math.floor(bU or a.ColorBrightnessSamples),1)local C,bO,E=a.ColorRGBToHSV(bL)local am=a.Round(bY*(1.0-bO))if bV or am<bY then local c2=a.Round(bX*C)if c2>=bX then c2=0 end;if am>=bY then am=bY-1 end;local c1=math.min(bZ-1,a.Round(bZ*(1.0-E)))return c2+bW*(am+bY*c1)else local c3=a.Round((bY-1)*E)if c3==0 then local c4=a.Round(bZ*(1.0-E))if c4>=bZ then return bW-1 else return bW*(1+a.Round(E*(bY-1)/(bZ-c4)*bZ)+bY*c4)-1 end else return bW*(1+c3+bY*a.Round(bZ*(1.0-E*(bY-1)/c3)))-1 end end end,ColorToTable=function(bL)return{[a.TypeParameterName]=a.ColorTypeName,r=bL.r,g=bL.g,b=bL.b,a=bL.a}end,ColorFromTable=function(G)local aT,M=F(G,a.ColorTypeName)return aT and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local aT,M=F(G,a.Vector2TypeName)return aT and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local aT,M=F(G,a.Vector3TypeName)return aT and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local aT,M=F(G,a.Vector4TypeName)return aT and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local aT,M=F(G,a.QuaternionTypeName)return aT and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(an,c5)local a4=a.NillableIfHasValueOrElse(c5,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(an,json.serialize(a4))end,OnMessage=function(an,ah)local c6=function(c7,c8,c9)local ca=nil;if c7.type~='comment'and type(c9)=='string'then local cb,a4=pcall(json.parse,c9)if cb and type(a4)=='table'then ca=a.TableFromSerializable(a4)end end;local c5=ca and ca or{[a.MessageValueParameterName]=c9}ah(c7,c8,c5)end;vci.message.On(an,c6)return{Off=function()if c6 then c6=nil end end}end,OnInstanceMessage=function(an,ah)local c6=function(c7,c8,c5)local cc=a.InstanceID()if cc~=''and cc==c5[a.InstanceIDParameterName]then ah(c7,c8,c5)end end;return a.OnMessage(an,c6)end,
GetEffekseerEmitterMap=function(an)local cd=vci.assets.GetEffekseerEmitters(an)if not cd then return nil end;local aK={}for n,ce in pairs(cd)do aK[ce.EffectName]=ce end;return aK end,ClientID=function()return j end,ParseTagString=function(P)local cf=string.find(P,'#',1,true)if not cf then return{},P end;local cg={}local ch=string.sub(P,1,cf-1)cf=cf+1;local S=string.len(P)local ci='^[A-Za-z0-9_%-.()!~*\'%%]+'while cf<=S do local cj,ck=string.find(P,ci,cf)if cj then local cl=string.sub(P,cj,ck)local cm=cl;cf=ck+1;if cf<=S and string.sub(P,cf,cf)=='='then cf=cf+1;local cn,co=string.find(P,ci,cf)if cn then cm=string.sub(P,cn,co)cf=co+1 else cm=''end end;cg[cl]=cm end;cf=string.find(P,'#',cf,true)if not cf then break end;cf=cf+1 end;return cg,ch end,CalculateSIPrefix=(function()local cp=9;local cq={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local cr=#cq;return function(aN)local cs=aN==0 and 0 or a.Clamp(math.floor(math.log(math.abs(aN),1000)),1-cp,cr-cp)return cs==0 and aN or aN/1000^cs,cq[cp+cs],cs*3 end end)(),CreateLocalSharedProperties=function(ct,cu)local cv=TimeSpan.FromSeconds(5)local cw='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cx='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(ct)~='string'or string.len(ct)<=0 or type(cu)~='string'or string.len(cu)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cy=_G[cw]if not cy then cy={}_G[cw]=cy end;cy[cu]=vci.me.UnscaledTime;local cz=_G[ct]if not cz then cz={[cx]={}}_G[ct]=cz end;local cA=cz[cx]local self;self={GetLspID=function()return ct end,GetLoadID=function()return cu end,GetProperty=function(z,ag)local q=cz[z]if q==nil then return ag else return q end end,SetProperty=function(z,q)if z==cx then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bJ=vci.me.UnscaledTime;local cB=cz[z]cz[z]=q;for cC,cc in pairs(cA)do local aA=cy[cc]if aA and aA+cv>=bJ then cC(self,z,q,cB)else cC(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)cA[cC]=nil;cy[cc]=nil end end end,Clear=function()for z,q in pairs(cz)do if z~=cx then self.SetProperty(z,nil)end end end,Each=function(ah)for z,q in pairs(cz)do if z~=cx and ah(q,z,self)==false then return false end end end,AddListener=function(cC)cA[cC]=cu end,RemoveListener=function(cC)cA[cC]=nil end,UpdateAlive=function()cy[cu]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(cD)local cE=1.0;local cF=1000.0;local cG=TimeSpan.FromSeconds(0.02)local cH=0xFFFF;local cI=a.CreateCircularQueue(64)local cJ=TimeSpan.FromSeconds(5)local cK=TimeSpan.FromSeconds(30)local cL=false;local cM=vci.me.Time;local cN=a.Random32()local cO=Vector3.__new(bit32.bor(0x400,bit32.band(cN,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cN,16),0x1FFF)),0.0)cD.SetPosition(cO)cD.SetRotation(Quaternion.identity)cD.SetVelocity(Vector3.zero)cD.SetAngularVelocity(Vector3.zero)cD.AddForce(Vector3.__new(0.0,0.0,cE*cF))local self={Timestep=function()return cG end,Precision=function()return cH end,IsFinished=function()return cL end,Update=function()if cL then return cG end;local cP=vci.me.Time-cM;local cQ=cP.TotalSeconds;if cQ<=Vector3.kEpsilon then return cG end;local cR=cD.GetPosition().z-cO.z;local cS=cR/cQ;local cT=cS/cF;if cT<=Vector3.kEpsilon then return cG end;cI.Offer(cT)local cU=cI.Size()if cU>=2 and cP>=cJ then local cV=0.0;for n=1,cU do cV=cV+cI.Get(n)end;local cW=cV/cU;local cX=0.0;for n=1,cU do cX=cX+(cI.Get(n)-cW)^2 end;local cY=cX/cU;if cY<cH then cH=cY;cG=TimeSpan.FromSeconds(cW)end;if cP>cK then cL=true;cD.SetPosition(cO)cD.SetRotation(Quaternion.identity)cD.SetVelocity(Vector3.zero)cD.SetAngularVelocity(Vector3.zero)end else cG=TimeSpan.FromSeconds(cT)end;return cG end}return self end,AlignSubItemOrigin=function(cZ,c_,d0)local d1=cZ.GetRotation()if not a.QuaternionApproximatelyEquals(c_.GetRotation(),d1)then c_.SetRotation(d1)end;local d2=cZ.GetPosition()if not a.VectorApproximatelyEquals(c_.GetPosition(),d2)then c_.SetPosition(d2)end;if d0 then c_.SetVelocity(Vector3.zero)c_.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local d3={}local self;self={Contains=function(d4,d5)return a.NillableIfHasValueOrElse(d3[d4],function(aq)return a.NillableHasValue(aq[d5])end,function()return false end)end,Add=function(d4,d6,d0)if not d4 or not d6 then local d7='SubItemGlue.Add: Invalid arguments '..(not d4 and', parent = '..tostring(d4)or'')..(not d6 and', children = '..tostring(d6)or'')error(d7,2)end;local aq=a.NillableIfHasValueOrElse(d3[d4],function(d8)return d8 end,function()local d8={}d3[d4]=d8;return d8 end)if type(d6)=='table'then for z,aD in pairs(d6)do aq[aD]={velocityReset=not not d0}end else aq[d6]={velocityReset=not not d0}end end,Remove=function(d4,d5)return a.NillableIfHasValueOrElse(d3[d4],function(aq)if a.NillableHasValue(aq[d5])then aq[d5]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(d4)if a.NillableHasValue(d3[d4])then d3[d4]=nil;return true else return false end end,RemoveAll=function()d3={}return true end,Each=function(ah,d9)return a.NillableIfHasValueOrElse(d9,function(d4)return a.NillableIfHasValue(d3[d4],function(aq)for d5,da in pairs(aq)do if ah(d5,d4,self)==false then return false end end end)end,function()for d4,aq in pairs(d3)do if self.Each(ah,d4)==false then return false end end end)end,Update=function(db)for d4,aq in pairs(d3)do local dc=d4.GetPosition()local dd=d4.GetRotation()for d5,da in pairs(aq)do if db or d5.IsMine then if not a.QuaternionApproximatelyEquals(d5.GetRotation(),dd)then d5.SetRotation(dd)end;if not a.VectorApproximatelyEquals(d5.GetPosition(),dc)then d5.SetPosition(dc)end;if da.velocityReset then d5.SetVelocity(Vector3.zero)d5.SetAngularVelocity(Vector3.zero)end end end end end}return self end,CreateUpdateRoutine=function(de,df)return coroutine.wrap(function()local dg=TimeSpan.FromSeconds(30)local dh=vci.me.UnscaledTime;local di=dh;local bF=vci.me.Time;local dj=true;while true do local cc=a.InstanceID()if cc~=''then break end;local dk=vci.me.UnscaledTime;if dk-dg>dh then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;di=dk;bF=vci.me.Time;dj=false;coroutine.yield(100)end;if dj then di=vci.me.UnscaledTime;bF=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(df,function(dl)dl()end)while true do local bJ=vci.me.Time;local dm=bJ-bF;local dk=vci.me.UnscaledTime;local dn=dk-di;de(dm,dn)bF=bJ;di=dk;coroutine.yield(100)end end)end,
CreateSlideSwitch=function(dp)local dq=a.NillableValue(dp.colliderItem)local dr=a.NillableValue(dp.baseItem)local ds=a.NillableValue(dp.knobItem)local dt=a.NillableValueOrDefault(dp.minValue,0)local du=a.NillableValueOrDefault(dp.maxValue,10)if dt>=du then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local dv=(dt+du)*0.5;local dw=function(aD)local dx,dy=a.PingPong(aD-dt,du-dt)return dx+dt,dy end;local q=dw(a.NillableValueOrDefault(dp.value,0))local dz=a.NillableIfHasValueOrElse(dp.tickFrequency,function(dA)if dA<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(dA,du-dt)end,function()return(du-dt)/10.0 end)local dB=a.NillableIfHasValueOrElse(dp.tickVector,function(b3)return Vector3.__new(b3.x,b3.y,b3.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local dC=dB.magnitude;if dC<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local dD=a.NillableValueOrDefault(dp.snapToTick,true)local dE=dp.valueTextName;local dF=a.NillableValueOrDefault(dp.valueToText,tostring)local dG=TimeSpan.FromMilliseconds(1000)local dH=TimeSpan.FromMilliseconds(50)local dI,dJ;local cA={}local self;local dK=false;local dL=0;local dM=false;local dN=TimeSpan.Zero;local dO=TimeSpan.Zero;local dP=function(dQ,dR)if dR or dQ~=q then local cB=q;q=dQ;for cC,E in pairs(cA)do cC(self,q,cB)end end;ds.SetLocalPosition((dQ-dv)/dz*dB)if dE then vci.assets.SetText(dE,dF(dQ,self))end end;local dS=function()local dT=dI()local dU,dV=dw(dT)local dW=dT+dz;local dX,dY=dw(dW)assert(dX)local dQ;if dV==dY or dU==du or dU==dt then dQ=dW else dQ=dV>=0 and du or dt end;dO=vci.me.UnscaledTime;if dQ==du or dQ==dt then dN=dO end;dJ(dQ)end;a.NillableIfHasValueOrElse(dp.lsp,function(dZ)if not a.NillableHasValue(dp.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local d_=a.NillableValue(dp.propertyName)dI=function()return dZ.GetProperty(d_,q)end;dJ=function(aD)dZ.SetProperty(d_,aD)end;dZ.AddListener(function(ar,z,e0,e1)if z==d_ then dP(dw(e0),true)end end)end,function()local e0=q;dI=function()return e0 end;dJ=function(aD)e0=aD;dP(dw(aD),true)end end)self={GetColliderItem=function()return dq end,GetBaseItem=function()return dr end,GetKnobItem=function()return ds end,GetMinValue=function()return dt end,GetMaxValue=function()return du end,GetValue=function()return q end,GetScaleValue=function(e2,e3)assert(e2<=e3)return e2+(e3-e2)*(q-dt)/(du-dt)end,SetValue=function(aD)dJ(dw(aD))end,GetTickFrequency=function()return dz end,IsSnapToTick=function()return dD end,AddListener=function(cC)cA[cC]=cC end,RemoveListener=function(cC)cA[cC]=nil end,DoUse=function()if not dK then dM=true;dN=vci.me.UnscaledTime;dS()end end,DoUnuse=function()dM=false end,DoGrab=function()if not dM then dK=true;dL=(q-dv)/dz end end,DoUngrab=function()dK=false end,Update=function()if dK then local e4=dq.GetPosition()-dr.GetPosition()local e5=ds.GetRotation()*dB;local e6=Vector3.Project(e4,e5)local e7=(Vector3.Dot(e5,e6)>=0 and 1 or-1)*e6.magnitude/dC+dL;local e8=(dD and a.Round(e7)or e7)*dz+dv;local dQ=a.Clamp(e8,dt,du)if dQ~=q then dJ(dQ)end elseif dM then local e9=vci.me.UnscaledTime;if e9>=dN+dG and e9>=dO+dH then dS()end elseif dq.IsMine then a.AlignSubItemOrigin(dr,dq)end end}dP(dw(dI()),false)return self end,CreateSubItemConnector=function()local ea=function(eb,c_,ec)eb.item=c_;eb.position=c_.GetPosition()eb.rotation=c_.GetRotation()eb.initialPosition=eb.position;eb.initialRotation=eb.rotation;eb.propagation=not not ec;return eb end;local ed=function(ee)for c_,eb in pairs(ee)do ea(eb,c_,eb.propagation)end end;local ef=function(eg,bh,eb,eh,ei)local e4=eg-eb.initialPosition;local ej=bh*Quaternion.Inverse(eb.initialRotation)eb.position=eg;eb.rotation=bh;for c_,ek in pairs(eh)do if c_~=eb.item and(not ei or ei(ek))then ek.position,ek.rotation=a.RotateAround(ek.initialPosition+e4,ek.initialRotation,eg,ej)c_.SetPosition(ek.position)c_.SetRotation(ek.rotation)end end end;local el={}local em=true;local en=false;local self;self={IsEnabled=function()return em end,SetEnabled=function(aF)em=aF;if aF then ed(el)en=false end end,Contains=function(eo)return a.NillableHasValue(el[eo])end,Add=function(ep,eq)if not ep then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(ep),2)end;local er=type(ep)=='table'and ep or{ep}ed(el)en=false;for N,c_ in pairs(er)do el[c_]=ea({},c_,not eq)end end,Remove=function(eo)local aT=a.NillableHasValue(el[eo])el[eo]=nil;return aT end,RemoveAll=function()el={}return true end,Each=function(ah)for c_,eb in pairs(el)do if ah(c_,self)==false then return false end end end,GetItems=function()local er={}for c_,eb in pairs(el)do table.insert(er,c_)end;return er end,Update=function()if not em then return end;local es=false;for c_,eb in pairs(el)do local cf=c_.GetPosition()local et=c_.GetRotation()if not a.VectorApproximatelyEquals(cf,eb.position)or not a.QuaternionApproximatelyEquals(et,eb.rotation)then if eb.propagation then if c_.IsMine then ef(cf,et,el[c_],el,function(ek)if ek.item.IsMine then return true else en=true;return false end end)es=true;break else en=true end else en=true end end end;if not es and en then ed(el)en=false end end}return self end,GetSubItemTransform=function(eo)local eg=eo.GetPosition()local bh=eo.GetRotation()local eu=eo.GetLocalScale()return{positionX=eg.x,positionY=eg.y,positionZ=eg.z,rotationX=bh.x,rotationY=bh.y,rotationZ=bh.z,rotationW=bh.w,scaleX=eu.x,scaleY=eu.y,scaleZ=eu.z}end,RestoreCytanbTransform=function(ev)local cf=ev.positionX and ev.positionY and ev.positionZ and Vector3.__new(ev.positionX,ev.positionY,ev.positionZ)or nil;local et=ev.rotationX and ev.rotationY and ev.rotationZ and ev.rotationW and Quaternion.__new(ev.rotationX,ev.rotationY,ev.rotationZ,ev.rotationW)or nil;local eu=ev.scaleX and ev.scaleY and ev.scaleZ and Vector3.__new(ev.scaleX,ev.scaleY,ev.scaleZ)or nil;return cf,et,eu end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local ct='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local cz=_G[ct]if not cz then cz={}_G[ct]=cz end;local ew=cz.randomSeedValue;if not ew then ew=os.time()-os.clock()*10000;cz.randomSeedValue=ew;math.randomseed(ew)end;local ex=cz.clientID;if type(ex)~='string'then ex=tostring(a.RandomUUID())cz.clientID=ex end;local ey=vci.state.Get(b)or''if ey==''and vci.assets.IsMine then ey=tostring(a.RandomUUID())vci.state.Set(b,ey)end;return ey,ex end)()return a end)()

local CreateSoftImpactor = function (item, maxForceMagnitude)
    local AssertMaxForceMagnitude = function (forceMagnitude)
        if forceMagnitude < 0 then
            error('CreateSoftImpactor: Invalid argument: forceMagnitude < 0', 3)
        end
        return forceMagnitude
    end

    local maxMagnitude = AssertMaxForceMagnitude(maxForceMagnitude)
    local accf = Vector3.zero

    return {
        Reset = function ()
            accf = Vector3.zero
        end,

        GetMaxForceMagnitude = function ()
            return maxMagnitude
        end,

        SetMaxForceMagnitude = function (maxForceMagnitude)
            maxMagnitude = AssertMaxForceMagnitude(maxForceMagnitude)
        end,

        GetAccumulatedForce = function ()
            return accf
        end,

        AccumulateForce = function (force, deltaTime, fixedTimestep)
            local ds = deltaTime.TotalSeconds
            local fs = fixedTimestep.TotalSeconds
            if ds <= 0 or fs <= 0 then
                return
            end

            accf = accf + ds / fs * force
        end,

        --- `updateAll` 関数の最後で、この関数を呼び出すこと。
        Update = function ()
            if accf == Vector3.zero then
                return
            end

            if not item.IsMine then
                -- 操作権が無い場合はリセットする。
                accf = Vector3.zero
                return
            end

            if maxMagnitude <= 0 then
                return
            end

            local am = accf.magnitude
            local f
            if am <= maxMagnitude then
                f = accf
                accf = Vector3.zero
            else
                -- 制限を超えている部分は、次以降のフレームに繰り越す
                f = maxMagnitude / am * accf
                accf = accf - f
                -- cytanb.LogTrace('CreateSoftImpactor: on Update: accf.magnitude = ', accf.magnitude)
            end

            item.AddForce(f)
        end
    }
end

local demoForceNS = 'com.github.oocytanb.oO-vci-pack.demo-force'
local statusMessageName = demoForceNS .. '.status'

local impactorEnabled = true

local statusLabelName = 'status-label'
local resetSwitch

local mdgPosBase
local mdgDistance = 0.5
local mdgList
local m1d0g0, m1d0g1, m1d0gf, m5d0g0, m5d0g1, m5d0gf, m5d9g0, m5d9g1, m5d9gf
local estimaterObject

local timeQueue = cytanb.CreateCircularQueue(120)
local statusPeriod = TimeSpan.FromMilliseconds(200)
local lastStatusTime = TimeSpan.Zero
local messagePeriod = TimeSpan.FromSeconds(3)
local lastMessageTime = TimeSpan.Zero

local timestepEstimater
local fixedTimestep
local timestepPrecision
local initialEstimater = true
local startEstimateFlag = false

local vciLoaded = false

cytanb.SetLogLevel(cytanb.LogLevelAll)
cytanb.SetOutputLogLevelEnabled(true)

local CalcFrameRate = function (queue)
    local frameCount = queue.Size()
    if frameCount < 2 then
        return 0, 0
    end

    local s = queue.Peek()
    local e = queue.PeekLast()
    local dt = (e.time - s.time).TotalSeconds
    local unscaledDt = (e.unscaledTime - s.unscaledTime).TotalSeconds
    return dt > 0 and frameCount / dt or 0, unscaledDt > 0 and frameCount / unscaledDt or 0
end

local UpdateStatusText = function (statusMap)
    local statusText = 'timestep: ' .. cytanb.Round(statusMap.timestep.TotalSeconds, 4) .. ' (precision: ' .. cytanb.Round(statusMap.timestepPrecision, 4) .. ')\n' ..
                        'timestep being calculated: ' .. cytanb.Round(statusMap.timestepBeingCalculated.TotalSeconds, 4) .. ' (precision: ' .. cytanb.Round(statusMap.timestepPrecisionBeingCalculated, 4) .. ')\n' ..
                        'rate: ' .. cytanb.Round(statusMap.fps > 0 and 1 / statusMap.fps or 0, 4) .. ' (' .. cytanb.Round(statusMap.fps, 4) .. ')\n' ..
                        --'unscaled rate: ' .. cytanb.Round(unscaledFps > 0 and 1 / unscaledFps or 0, 4) .. ' (' .. cytanb.Round(unscaledFps, 4) .. ')\n' ..
                        'IsMine: ' .. tostring(resetSwitch.IsMine)
    vci.assets.SetText(statusLabelName, statusText)
end

local CreateMdg = function (name, mass, drag, useGravity)
    local item = cytanb.NillableValue(vci.assets.GetSubItem(name))
    local simMass = mass or 1.0
    return {
        name = name,
        item = item,
        mass = simMass,
        drag = drag or 0.0,
        useGravity = not not useGravity,
        impactor = CreateSoftImpactor(item, simMass * 9.81 * 2.0)
    }
end

local ResetMdgPosition = function ()
    local basePos = mdgPosBase.GetPosition()
    local baseRot = mdgPosBase.GetRotation()
    local baseRight = mdgPosBase.GetRight()
    local baseUp = mdgPosBase.GetUp()

    for i, mdg in ipairs(mdgList) do
        local item = mdg.item
        item.SetPosition(basePos + baseUp * -0.25 + baseRight * ((i - 1) * mdgDistance))
        item.SetRotation(baseRot)
        item.SetVelocity(Vector3.zero)
        item.SetAngularVelocity(Vector3.zero)
        mdg.impactor.Reset()
    end
end

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    vciLoaded = true

    resetSwitch = cytanb.NillableValue(vci.assets.GetSubItem('reset-switch'))
    mdgPosBase = cytanb.NillableValue(vci.assets.GetSubItem('cube-pos-base'))

    m1d0g0 = CreateMdg('m1d0g0', 1.0, 0.0, false)
    m1d0g1 = CreateMdg('m1d0g1', 1.0, 0.0, true)
    m1d0gf = CreateMdg('m1d0gf', 1.0, 0.0, true)
    m5d0g0 = CreateMdg('m5d0g0', 5.0, 0.0, false)
    m5d0g1 = CreateMdg('m5d0g1', 5.0, 0.0, true)
    m5d0gf = CreateMdg('m5d0gf', 5.0, 0.0, true)
    m5d9g0 = CreateMdg('m5d9g0', 5.0, 9.0, false)
    m5d9g1 = CreateMdg('m5d9g1', 5.0, 9.0, true)
    m5d9gf = CreateMdg('m5d9gf', 5.0, 9.0, true)
    estimaterObject = CreateMdg('timestep-estimater', 1.0, 0.0, false)

    mdgList = {m1d0g0, m1d0g1, m1d0gf, m5d0g0, m5d0g1, m5d0gf, m5d9g0, m5d9g1, m5d9gf}

    timestepEstimater = cytanb.EstimateFixedTimestep(estimaterObject.item)
    fixedTimestep = timestepEstimater.Timestep()
    timestepPrecision = timestepEstimater.Precision()

    cytanb.OnInstanceMessage(statusMessageName, function (sender, name, parameterMap)
        if not resetSwitch.IsMine then
            cytanb.LogTrace('on status: timestep = ', cytanb.Round(TimeSpan.FromTicks(parameterMap.timestepTicks).TotalSeconds, 4), ', rate: ', cytanb.Round(parameterMap.fps > 0 and 1 / parameterMap.fps or 0, 4), ' (', cytanb.Round(parameterMap.fps, 4), ')')
            UpdateStatusText(cytanb.Extend({
                timestep = TimeSpan.FromTicks(parameterMap.timestepTicks),
                timestepBeingCalculated = TimeSpan.FromTicks(parameterMap.timestepTicksBeingCalculated)
            }, parameterMap))
        end
    end)
end

local OnUpdate = function (deltaTime, unscaledDeltaTime)
    if deltaTime <= TimeSpan.Zero then
        --return
    end

    if startEstimateFlag then
        timestepEstimater = cytanb.EstimateFixedTimestep(estimaterObject.item)
        startEstimateFlag = false
    else
        timestepEstimater.Update()
        if initialEstimater then
            fixedTimestep = timestepEstimater.Timestep()
            timestepPrecision = timestepEstimater.Precision()
        end
    end

    if resetSwitch.IsMine then
        local unscaledTime = vci.me.UnscaledTime
        timeQueue.Offer({time = vci.me.Time, unscaledTime = unscaledTime})
        local fps, unscaledFps = CalcFrameRate(timeQueue)
        local statusMap = {
            timestep = fixedTimestep,
            timestepPrecision = timestepPrecision,
            timestepBeingCalculated = timestepEstimater.Timestep(),
            timestepPrecisionBeingCalculated = timestepEstimater.Precision(),
            fps = fps,
            unscaledFps = unscaledFps
        }
        
        if unscaledTime > lastStatusTime + statusPeriod then
            UpdateStatusText(statusMap)
            lastStatusTime = unscaledTime
        end

        if unscaledTime > lastMessageTime + messagePeriod then
            local parameterMap = cytanb.Extend({
                timestepTicks = statusMap.timestep.Ticks,
                timestepTicksBeingCalculated = timestepEstimater.Timestep().Ticks
            }, statusMap)
            cytanb.EmitMessage(statusMessageName, parameterMap)
            lastMessageTime = unscaledTime
            cytanb.LogTrace('emit status: timestep = ', cytanb.Round(parameterMap.timestep.TotalSeconds, 4), ', rate: ', cytanb.Round(parameterMap.fps > 0 and 1 / parameterMap.fps or 0, 4), ' (', cytanb.Round(parameterMap.fps, 4), ')')
        end

        -- Unity の重力加速度の規定値は 9.81 だが、update で AddForce する分には、完全に静止することはない。
        if impactorEnabled then
            local acc = 9.81
            m1d0g0.impactor.AccumulateForce(Vector3.up * (m1d0g1.mass * -acc), deltaTime, fixedTimestep)
            m1d0gf.impactor.AccumulateForce(Vector3.up * (m1d0gf.mass * acc), deltaTime, fixedTimestep)

            m5d0g0.impactor.AccumulateForce(Vector3.up * (m5d0g0.mass * -acc), deltaTime, fixedTimestep)
            m5d0gf.impactor.AccumulateForce(Vector3.up * (m5d0gf.mass * acc), deltaTime, fixedTimestep)

            m5d9g0.impactor.AccumulateForce(Vector3.up * (m5d9g0.mass * -acc), deltaTime, fixedTimestep)
            m5d9gf.impactor.AccumulateForce(Vector3.up * (m5d9gf.mass * acc), deltaTime, fixedTimestep)
        else
            local acc = 9.81 * deltaTime.TotalSeconds / fixedTimestep.TotalSeconds
            --local acc = 9.81
            --cytanb.LogTrace('deltaSec: ', deltaTime.TotalSeconds)

            m1d0g0.item.AddForce(Vector3.up * (m1d0g1.mass * -acc))
            m1d0gf.item.AddForce(Vector3.up * (m1d0gf.mass * acc))

            m5d0g0.item.AddForce(Vector3.up * (m5d0g0.mass * -acc))
            m5d0gf.item.AddForce(Vector3.up * (m5d0gf.mass * acc))

            m5d9g0.item.AddForce(Vector3.up * (m5d9g0.mass * -acc))
            m5d9gf.item.AddForce(Vector3.up * (m5d9gf.mass * acc))
        end
    end

    if impactorEnabled then
        for i, mdg in ipairs(mdgList) do
            mdg.impactor.Update()
            -- local accf = mdg.impactor.GetAccumulatedForce()
            -- if accf ~= Vector3.zero then
            --     cytanb.LogTrace('accf = ', accf, ', maxMagnitude = ', mdg.impactor.GetMaxForceMagnitude())
            --     mdg.impactor.SetMaxForceMagnitude(mdg.impactor.GetMaxForceMagnitude() * 1.1)
            -- end
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

onGrab = function (target)
    if not vciLoaded then
        return
    end

    if target == resetSwitch.GetName() then
        timeQueue.Clear()
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == resetSwitch.GetName() then
        ResetMdgPosition()
        fixedTimestep = timestepEstimater.Timestep()
        timestepPrecision = timestepEstimater.Precision()
        initialEstimater = false
        startEstimateFlag = true
    end
end
