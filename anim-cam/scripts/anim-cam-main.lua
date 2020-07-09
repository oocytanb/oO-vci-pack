-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,{[a.EscapeSequenceTag]=a.EscapeSequenceTag..a.EscapeSequenceTag}),'/',{['/']=a.SolidusTag})end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(af)return af~=nil end,NillableValue=function(af)if af==nil then error('nillable: value is nil',2)end;return af end,NillableValueOrDefault=function(af,ag)if af==nil then if ag==nil then error('nillable: defaultValue is nil',2)end;return ag else return af end end,NillableIfHasValue=function(af,ah)if af==nil then return nil else return ah(af)end end,NillableIfHasValueOrElse=function(af,ah,ai)if af==nil then return ai()else return ah(af)end end,StringReplace=function(P,aj,ak)local al;local S=string.len(P)if aj==''then al=ak;for n=1,S do al=al..string.sub(P,n,n)..ak end else al=''local n=1;while true do local am,V=string.find(P,aj,n,true)if am then al=al..string.sub(P,n,am-1)..ak;n=V+1;if n>S then break end else al=n==1 and P or al..string.sub(P,n)break end end end;return al end,SetConst=function(aj,an,q)if type(aj)~='table'then error('Cannot set const to non-table target',2)end;local ao=getmetatable(aj)local A=ao or{}local ap=rawget(A,x)if rawget(aj,an)~=nil then error('Non-const field "'..an..'" already exists',2)end;if not ap then ap={}rawset(A,x,ap)A.__index=y;A.__newindex=D end;rawset(ap,an,q)if not ao then setmetatable(aj,A)end;return aj end,SetConstEach=function(aj,aq)for N,E in pairs(aq)do a.SetConst(aj,N,E)end;return aj end,Extend=function(aj,ar,as,at,a3)if aj==ar or type(aj)~='table'or type(ar)~='table'then return aj end;if as then if not a3 then a3={}end;if a3[ar]then error('circular reference')end;a3[ar]=true end;for N,E in pairs(ar)do if as and type(E)=='table'then local au=aj[N]aj[N]=a.Extend(type(au)=='table'and au or{},E,as,at,a3)else aj[N]=E end end;if not at then local av=getmetatable(ar)if type(av)=='table'then if as then local aw=getmetatable(aj)setmetatable(aj,a.Extend(type(aw)=='table'and aw or{},av,true))else setmetatable(aj,av)end end end;if as then a3[ar]=nil end;return aj end,Vars=function(E,ax,ay,a3)local az;if ax then az=ax~='__NOLF'else ax='  'az=true end;if not ay then ay=''end;if not a3 then a3={}end;local aA=type(E)if aA=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local aB=az and ay..ax or''local P='('..tostring(E)..') {'local aC=true;for z,aD in pairs(E)do if aC then aC=false else P=P..(az and','or', ')end;if az then P=P..'\n'..aB end;if type(aD)=='table'and a3[aD]and a3[aD]>0 then P=P..z..' = ('..tostring(aD)..')'else P=P..z..' = '..a.Vars(aD,ax,aB,a3)end end;if not aC and az then P=P..'\n'..ay end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif aA=='function'or aA=='thread'or aA=='userdata'then return'('..aA..')'elseif aA=='string'then return'('..aA..') '..string.format('%q',E)else return'('..aA..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aE)f=aE end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aF)g=not not aF end,Log=function(aE,...)if aE<=f then local aG=g and(h[aE]or'LOG LEVEL '..tostring(aE))..' | 'or''local aH=table.pack(...)if aH.n==1 then local E=aH[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aG..P or P)else print(aG)end else local P=aG;for n=1,aH.n do local E=aH[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aI,aJ)local aK={}if aJ==nil then for N,E in pairs(aI)do aK[E]=E end elseif type(aJ)=='function'then for N,E in pairs(aI)do local aL,aM=aJ(E)aK[aL]=aM end else for N,E in pairs(aI)do aK[E]=aJ end end;return aK end,Round=function(aN,aO)if aO then local aP=10^aO;return math.floor(aN*aP+0.5)/aP else return math.floor(aN+0.5)end end,Clamp=function(q,aQ,aR)return math.max(aQ,math.min(q,aR))end,Lerp=function(aS,aT,aA)if aA<=0.0 then return aS elseif aA>=1.0 then return aT else return aS+(aT-aS)*aA end end,LerpUnclamped=function(aS,aT,aA)if aA==0.0 then return aS elseif aA==1.0 then return aT else return aS+(aT-aS)*aA end end,PingPong=function(aA,aU)if aU==0 then return 0,1 end;local aV=math.floor(aA/aU)local aW=aA-aV*aU;if aV<0 then if(aV+1)%2==0 then return aU-aW,-1 else return aW,1 end else if aV%2==0 then return aW,1 else return aU-aW,-1 end end end,VectorApproximatelyEquals=function(aX,aY)return(aX-aY).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aX,aY)local aZ=Quaternion.Dot(aX,aY)return aZ<1.0+1E-06 and aZ>1.0-1E-06 end,
QuaternionToAngleAxis=function(a_)local aV=a_.normalized;local b0=math.acos(aV.w)local b1=math.sin(b0)local b2=math.deg(b0*2.0)local b3;if math.abs(b1)<=Quaternion.kEpsilon then b3=Vector3.right else local am=1.0/b1;b3=Vector3.__new(aV.x*am,aV.y*am,aV.z*am)end;return b2,b3 end,QuaternionTwist=function(a_,b4)if b4.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local b5=Vector3.__new(a_.x,a_.y,a_.z)if b5.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b6=Vector3.Project(b5,b4)if b6.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b7=Quaternion.__new(b6.x,b6.y,b6.z,a_.w)b7.Normalize()return b7 else return Quaternion.AngleAxis(0,b4)end else local b8=a.QuaternionToAngleAxis(a_)return Quaternion.AngleAxis(b8,b4)end end,ApplyQuaternionToVector3=function(a_,b9)local ba=a_.w*b9.x+a_.y*b9.z-a_.z*b9.y;local bb=a_.w*b9.y-a_.x*b9.z+a_.z*b9.x;local bc=a_.w*b9.z+a_.x*b9.y-a_.y*b9.x;local bd=-a_.x*b9.x-a_.y*b9.y-a_.z*b9.z;return Vector3.__new(bd*-a_.x+ba*a_.w+bb*-a_.z-bc*-a_.y,bd*-a_.y-ba*-a_.z+bb*a_.w+bc*-a_.x,bd*-a_.z+ba*-a_.y-bb*-a_.x+bc*a_.w)end,RotateAround=function(be,bf,bg,bh)return bg+bh*(be-bg),bh*bf end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bi)return p.__tostring(bi)end,UUIDFromNumbers=function(...)local bj=...local aA=type(bj)local bk,bl,bm,bn;if aA=='table'then bk=bj[1]bl=bj[2]bm=bj[3]bn=bj[4]else bk,bl,bm,bn=...end;local bi={bit32.band(bk or 0,0xFFFFFFFF),bit32.band(bl or 0,0xFFFFFFFF),bit32.band(bm or 0,0xFFFFFFFF),bit32.band(bn or 0,0xFFFFFFFF)}setmetatable(bi,p)return bi end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bo='[0-9a-f-A-F]+'local bp='^('..bo..')$'local bq='^-('..bo..')$'local br,bs,bt,bu;if S==32 then local bi=a.UUIDFromNumbers(0,0,0,0)local bv=1;for n,bw in ipairs({8,16,24,32})do br,bs,bt=string.find(string.sub(P,bv,bw),bp)if not br then return nil end;bi[n]=tonumber(bt,16)bv=bw+1 end;return bi else br,bs,bt=string.find(string.sub(P,1,8),bp)if not br then return nil end;local bk=tonumber(bt,16)br,bs,bt=string.find(string.sub(P,9,13),bq)if not br then return nil end;br,bs,bu=string.find(string.sub(P,14,18),bq)if not br then return nil end;local bl=tonumber(bt..bu,16)br,bs,bt=string.find(string.sub(P,19,23),bq)if not br then return nil end;br,bs,bu=string.find(string.sub(P,24,28),bq)if not br then return nil end;local bm=tonumber(bt..bu,16)br,bs,bt=string.find(string.sub(P,29,36),bp)if not br then return nil end;local bn=tonumber(bt,16)return a.UUIDFromNumbers(bk,bl,bm,bn)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bx)if type(bx)~='number'or bx<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bx),2)end;local self;local by=math.floor(bx)local U={}local bz=0;local bA=0;local bB=0;self={Size=function()return bB end,Clear=function()bz=0;bA=0;bB=0 end,IsEmpty=function()return bB==0 end,Offer=function(bC)U[bz+1]=bC;bz=(bz+1)%by;if bB<by then bB=bB+1 else bA=(bA+1)%by end;return true end,OfferFirst=function(bC)bA=(by+bA-1)%by;U[bA+1]=bC;if bB<by then bB=bB+1 else bz=(by+bz-1)%by end;return true end,Poll=function()if bB==0 then return nil else local bC=U[bA+1]bA=(bA+1)%by;bB=bB-1;return bC end end,PollLast=function()if bB==0 then return nil else bz=(by+bz-1)%by;local bC=U[bz+1]bB=bB-1;return bC end end,Peek=function()if bB==0 then return nil else return U[bA+1]end end,PeekLast=function()if bB==0 then return nil else return U[(by+bz-1)%by+1]end end,Get=function(bD)if bD<1 or bD>bB then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bD)return nil end;return U[(bA+bD-1)%by+1]end,IsFull=function()return bB>=by end,MaxSize=function()return by end}return self end,DetectClicks=function(bE,bF,bG)local bH=bE or 0;local bI=bG or TimeSpan.FromMilliseconds(500)local bJ=vci.me.Time;local bK=bF and bJ>bF+bI and 1 or bH+1;return bK,bJ end,ColorRGBToHSV=function(bL)local aW=math.max(0.0,math.min(bL.r,1.0))local bM=math.max(0.0,math.min(bL.g,1.0))local aT=math.max(0.0,math.min(bL.b,1.0))local aR=math.max(aW,bM,aT)local aQ=math.min(aW,bM,aT)local bN=aR-aQ;local C;if bN==0.0 then C=0.0 elseif aR==aW then C=(bM-aT)/bN/6.0 elseif aR==bM then C=(2.0+(aT-aW)/bN)/6.0 else C=(4.0+(aW-bM)/bN)/6.0 end;if C<0.0 then C=C+1.0 end;local bO=aR==0.0 and bN or bN/aR;local E=aR;return C,bO,E end,ColorFromARGB32=function(bP)local bQ=type(bP)=='number'and bP or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bQ,16),0xFF)/0xFF,bit32.band(bit32.rshift(bQ,8),0xFF)/0xFF,bit32.band(bQ,0xFF)/0xFF,bit32.band(bit32.rshift(bQ,24),0xFF)/0xFF)end,ColorToARGB32=function(bL)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bL.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bL.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bL.g),0xFF),8),bit32.band(a.Round(0xFF*bL.b),0xFF))end,ColorFromIndex=function(bR,bS,bT,bU,bV)local bW=math.max(math.floor(bS or a.ColorHueSamples),1)local bX=bV and bW or bW-1;local bY=math.max(math.floor(bT or a.ColorSaturationSamples),1)local bZ=math.max(math.floor(bU or a.ColorBrightnessSamples),1)local bD=a.Clamp(math.floor(bR or 0),0,bW*bY*bZ-1)local b_=bD%bW;local c0=math.floor(bD/bW)local am=c0%bY;local c1=math.floor(c0/bY)if bV or b_~=bX then local C=b_/bX;local bO=(bY-am)/bY;local E=(bZ-c1)/bZ;return Color.HSVToRGB(C,bO,E)else local E=(bZ-c1)/bZ*am/(bY-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bL,bS,bT,bU,bV)local bW=math.max(math.floor(bS or a.ColorHueSamples),1)local bX=bV and bW or bW-1;local bY=math.max(math.floor(bT or a.ColorSaturationSamples),1)local bZ=math.max(math.floor(bU or a.ColorBrightnessSamples),1)local C,bO,E=a.ColorRGBToHSV(bL)local am=a.Round(bY*(1.0-bO))if bV or am<bY then local c2=a.Round(bX*C)if c2>=bX then c2=0 end;if am>=bY then am=bY-1 end;local c1=math.min(bZ-1,a.Round(bZ*(1.0-E)))return c2+bW*(am+bY*c1)else local c3=a.Round((bY-1)*E)if c3==0 then local c4=a.Round(bZ*(1.0-E))if c4>=bZ then return bW-1 else return bW*(1+a.Round(E*(bY-1)/(bZ-c4)*bZ)+bY*c4)-1 end else return bW*(1+c3+bY*a.Round(bZ*(1.0-E*(bY-1)/c3)))-1 end end end,ColorToTable=function(bL)return{[a.TypeParameterName]=a.ColorTypeName,r=bL.r,g=bL.g,b=bL.b,a=bL.a}end,ColorFromTable=function(G)local aT,M=F(G,a.ColorTypeName)return aT and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local aT,M=F(G,a.Vector2TypeName)return aT and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local aT,M=F(G,a.Vector3TypeName)return aT and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local aT,M=F(G,a.Vector4TypeName)return aT and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local aT,M=F(G,a.QuaternionTypeName)return aT and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(an,c5)local a4=a.NillableIfHasValueOrElse(c5,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(an,json.serialize(a4))end,OnMessage=function(an,ah)local c6=function(c7,c8,c9)if type(c9)=='string'and c9~=''and string.sub(c9,1,1)=='{'then local ca,a4=pcall(json.parse,c9)if ca and type(a4)=='table'and a4[a.InstanceIDParameterName]then local cb=a.TableFromSerializable(a4)local cc;local cd=cb[a.MessageSenderOverride]if cd then cc=a.Extend(a.Extend({},c7,true),cd,true)cb[a.MessageOriginalSender]=c7 else cc=c7 end;ah(cc,c8,cb)return end end;ah(c7,c8,{[a.MessageValueParameterName]=c9})end;vci.message.On(an,c6)return{Off=function()if c6 then c6=nil end end}end,OnInstanceMessage=function(an,ah)local c6=function(c7,c8,c5)local ce=a.InstanceID()if ce~=''and ce==c5[a.InstanceIDParameterName]then ah(c7,c8,c5)end end;return a.OnMessage(an,c6)end,
EmitCommentMessage=function(c9,cd)local cf={type='comment',name='',commentSource=''}local c5={[a.MessageValueParameterName]=tostring(c9),[a.MessageSenderOverride]=type(cd)=='table'and a.Extend(cf,cd,true)or cf}a.EmitMessage('comment',c5)end,OnCommentMessage=function(ah)local c6=function(c7,c8,c5)local c9=tostring(c5[a.MessageValueParameterName]or'')ah(c7,c8,c9)end;return a.OnMessage('comment',c6)end,EmitNotificationMessage=function(c9,cd)local cf={type='notification',name='',commentSource=''}local c5={[a.MessageValueParameterName]=tostring(c9),[a.MessageSenderOverride]=type(cd)=='table'and a.Extend(cf,cd,true)or cf}a.EmitMessage('notification',c5)end,OnNotificationMessage=function(ah)local c6=function(c7,c8,c5)local c9=tostring(c5[a.MessageValueParameterName]or'')ah(c7,c8,c9)end;return a.OnMessage('notification',c6)end,GetEffekseerEmitterMap=function(an)local cg=vci.assets.GetEffekseerEmitters(an)if not cg then return nil end;local aK={}for n,ch in pairs(cg)do aK[ch.EffectName]=ch end;return aK end,ClientID=function()return j end,ParseTagString=function(P)local ci=string.find(P,'#',1,true)if not ci then return{},P end;local cj={}local ck=string.sub(P,1,ci-1)ci=ci+1;local S=string.len(P)local cl='^[A-Za-z0-9_%-.()!~*\'%%]+'while ci<=S do local cm,cn=string.find(P,cl,ci)if cm then local co=string.sub(P,cm,cn)local cp=co;ci=cn+1;if ci<=S and string.sub(P,ci,ci)=='='then ci=ci+1;local cq,cr=string.find(P,cl,ci)if cq then cp=string.sub(P,cq,cr)ci=cr+1 else cp=''end end;cj[co]=cp end;ci=string.find(P,'#',ci,true)if not ci then break end;ci=ci+1 end;return cj,ck end,CalculateSIPrefix=(function()local cs=9;local ct={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local cu=#ct;return function(aN)local cv=aN==0 and 0 or a.Clamp(math.floor(math.log(math.abs(aN),1000)),1-cs,cu-cs)return cv==0 and aN or aN/1000^cv,ct[cs+cv],cv*3 end end)(),CreateLocalSharedProperties=function(cw,cx)local cy=TimeSpan.FromSeconds(5)local cz='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cA='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(cw)~='string'or string.len(cw)<=0 or type(cx)~='string'or string.len(cx)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cB=_G[cz]if not cB then cB={}_G[cz]=cB end;cB[cx]=vci.me.UnscaledTime;local cC=_G[cw]if not cC then cC={[cA]={}}_G[cw]=cC end;local cD=cC[cA]local self;self={GetLspID=function()return cw end,GetLoadID=function()return cx end,GetProperty=function(z,ag)local q=cC[z]if q==nil then return ag else return q end end,SetProperty=function(z,q)if z==cA then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bJ=vci.me.UnscaledTime;local cE=cC[z]cC[z]=q;for cF,ce in pairs(cD)do local aA=cB[ce]if aA and aA+cy>=bJ then cF(self,z,q,cE)else cF(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)cD[cF]=nil;cB[ce]=nil end end end,Clear=function()for z,q in pairs(cC)do if z~=cA then self.SetProperty(z,nil)end end end,Each=function(ah)for z,q in pairs(cC)do if z~=cA and ah(q,z,self)==false then return false end end end,AddListener=function(cF)cD[cF]=cx end,RemoveListener=function(cF)cD[cF]=nil end,UpdateAlive=function()cB[cx]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(cG)local cH=1.0;local cI=1000.0;local cJ=TimeSpan.FromSeconds(0.02)local cK=0xFFFF;local cL=a.CreateCircularQueue(64)local cM=TimeSpan.FromSeconds(5)local cN=TimeSpan.FromSeconds(30)local cO=false;local cP=vci.me.Time;local cQ=a.Random32()local cR=Vector3.__new(bit32.bor(0x400,bit32.band(cQ,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cQ,16),0x1FFF)),0.0)cG.SetPosition(cR)cG.SetRotation(Quaternion.identity)cG.SetVelocity(Vector3.zero)cG.SetAngularVelocity(Vector3.zero)cG.AddForce(Vector3.__new(0.0,0.0,cH*cI))local self={Timestep=function()return cJ end,Precision=function()return cK end,IsFinished=function()return cO end,Update=function()if cO then return cJ end;local cS=vci.me.Time-cP;local cT=cS.TotalSeconds;if cT<=Vector3.kEpsilon then return cJ end;local cU=cG.GetPosition().z-cR.z;local cV=cU/cT;local cW=cV/cI;if cW<=Vector3.kEpsilon then return cJ end;cL.Offer(cW)local cX=cL.Size()if cX>=2 and cS>=cM then local cY=0.0;for n=1,cX do cY=cY+cL.Get(n)end;local cZ=cY/cX;local c_=0.0;for n=1,cX do c_=c_+(cL.Get(n)-cZ)^2 end;local d0=c_/cX;if d0<cK then cK=d0;cJ=TimeSpan.FromSeconds(cZ)end;if cS>cN then cO=true;cG.SetPosition(cR)cG.SetRotation(Quaternion.identity)cG.SetVelocity(Vector3.zero)cG.SetAngularVelocity(Vector3.zero)end else cJ=TimeSpan.FromSeconds(cW)end;return cJ end}return self end,AlignSubItemOrigin=function(d1,d2,d3)local d4=d1.GetRotation()if not a.QuaternionApproximatelyEquals(d2.GetRotation(),d4)then d2.SetRotation(d4)end;local d5=d1.GetPosition()if not a.VectorApproximatelyEquals(d2.GetPosition(),d5)then d2.SetPosition(d5)end;if d3 then d2.SetVelocity(Vector3.zero)d2.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local d6={}local self;self={Contains=function(d7,d8)return a.NillableIfHasValueOrElse(d6[d7],function(aq)return a.NillableHasValue(aq[d8])end,function()return false end)end,Add=function(d7,d9,d3)if not d7 or not d9 then local da='SubItemGlue.Add: Invalid arguments '..(not d7 and', parent = '..tostring(d7)or'')..(not d9 and', children = '..tostring(d9)or'')error(da,2)end;local aq=a.NillableIfHasValueOrElse(d6[d7],function(db)return db end,function()local db={}d6[d7]=db;return db end)if type(d9)=='table'then for z,aD in pairs(d9)do aq[aD]={velocityReset=not not d3}end else aq[d9]={velocityReset=not not d3}end end,Remove=function(d7,d8)return a.NillableIfHasValueOrElse(d6[d7],function(aq)if a.NillableHasValue(aq[d8])then aq[d8]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(d7)if a.NillableHasValue(d6[d7])then d6[d7]=nil;return true else return false end end,RemoveAll=function()d6={}return true end,Each=function(ah,dc)return a.NillableIfHasValueOrElse(dc,function(d7)return a.NillableIfHasValue(d6[d7],function(aq)for d8,dd in pairs(aq)do if ah(d8,d7,self)==false then return false end end end)end,function()for d7,aq in pairs(d6)do if self.Each(ah,d7)==false then return false end end end)end,Update=function(de)for d7,aq in pairs(d6)do local df=d7.GetPosition()local dg=d7.GetRotation()for d8,dd in pairs(aq)do if de or d8.IsMine then if not a.QuaternionApproximatelyEquals(d8.GetRotation(),dg)then d8.SetRotation(dg)end;if not a.VectorApproximatelyEquals(d8.GetPosition(),df)then d8.SetPosition(df)end;if dd.velocityReset then d8.SetVelocity(Vector3.zero)d8.SetAngularVelocity(Vector3.zero)end end end end end}return self end,CreateUpdateRoutine=function(dh,di)return coroutine.wrap(function()local dj=TimeSpan.FromSeconds(30)local dk=vci.me.UnscaledTime;local dl=dk;local bF=vci.me.Time;local dm=true;while true do local ce=a.InstanceID()if ce~=''then break end;local dn=vci.me.UnscaledTime;if dn-dj>dk then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;dl=dn;bF=vci.me.Time;dm=false;coroutine.yield(100)end;if dm then dl=vci.me.UnscaledTime;bF=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(di,function(dp)dp()end)while true do local bJ=vci.me.Time;local dq=bJ-bF;local dn=vci.me.UnscaledTime;local dr=dn-dl;dh(dq,dr)bF=bJ;dl=dn;coroutine.yield(100)end end)end,
CreateSlideSwitch=function(ds)local dt=a.NillableValue(ds.colliderItem)local du=a.NillableValue(ds.baseItem)local dv=a.NillableValue(ds.knobItem)local dw=a.NillableValueOrDefault(ds.minValue,0)local dx=a.NillableValueOrDefault(ds.maxValue,10)if dw>=dx then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local dy=(dw+dx)*0.5;local dz=function(aD)local dA,dB=a.PingPong(aD-dw,dx-dw)return dA+dw,dB end;local q=dz(a.NillableValueOrDefault(ds.value,0))local dC=a.NillableIfHasValueOrElse(ds.tickFrequency,function(dD)if dD<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(dD,dx-dw)end,function()return(dx-dw)/10.0 end)local dE=a.NillableIfHasValueOrElse(ds.tickVector,function(b3)return Vector3.__new(b3.x,b3.y,b3.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local dF=dE.magnitude;if dF<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local dG=a.NillableValueOrDefault(ds.snapToTick,true)local dH=ds.valueTextName;local dI=a.NillableValueOrDefault(ds.valueToText,tostring)local dJ=TimeSpan.FromMilliseconds(1000)local dK=TimeSpan.FromMilliseconds(50)local dL,dM;local cD={}local self;local dN=false;local dO=0;local dP=false;local dQ=TimeSpan.Zero;local dR=TimeSpan.Zero;local dS=function(dT,dU)if dU or dT~=q then local cE=q;q=dT;for cF,E in pairs(cD)do cF(self,q,cE)end end;dv.SetLocalPosition((dT-dy)/dC*dE)if dH then vci.assets.SetText(dH,dI(dT,self))end end;local dV=function()local dW=dL()local dX,dY=dz(dW)local dZ=dW+dC;local d_,e0=dz(dZ)assert(d_)local dT;if dY==e0 or dX==dx or dX==dw then dT=dZ else dT=dY>=0 and dx or dw end;dR=vci.me.UnscaledTime;if dT==dx or dT==dw then dQ=dR end;dM(dT)end;a.NillableIfHasValueOrElse(ds.lsp,function(e1)if not a.NillableHasValue(ds.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local e2=a.NillableValue(ds.propertyName)dL=function()return e1.GetProperty(e2,q)end;dM=function(aD)e1.SetProperty(e2,aD)end;e1.AddListener(function(ar,z,e3,e4)if z==e2 then dS(dz(e3),true)end end)end,function()local e3=q;dL=function()return e3 end;dM=function(aD)e3=aD;dS(dz(aD),true)end end)self={GetColliderItem=function()return dt end,GetBaseItem=function()return du end,GetKnobItem=function()return dv end,GetMinValue=function()return dw end,GetMaxValue=function()return dx end,GetValue=function()return q end,GetScaleValue=function(e5,e6)assert(e5<=e6)return e5+(e6-e5)*(q-dw)/(dx-dw)end,SetValue=function(aD)dM(dz(aD))end,GetTickFrequency=function()return dC end,IsSnapToTick=function()return dG end,AddListener=function(cF)cD[cF]=cF end,RemoveListener=function(cF)cD[cF]=nil end,DoUse=function()if not dN then dP=true;dQ=vci.me.UnscaledTime;dV()end end,DoUnuse=function()dP=false end,DoGrab=function()if not dP then dN=true;dO=(q-dy)/dC end end,DoUngrab=function()dN=false end,Update=function()if dN then local e7=dt.GetPosition()-du.GetPosition()local e8=dv.GetRotation()*dE;local e9=Vector3.Project(e7,e8)local ea=(Vector3.Dot(e8,e9)>=0 and 1 or-1)*e9.magnitude/dF+dO;local eb=(dG and a.Round(ea)or ea)*dC+dy;local dT=a.Clamp(eb,dw,dx)if dT~=q then dM(dT)end elseif dP then local ec=vci.me.UnscaledTime;if ec>=dQ+dJ and ec>=dR+dK then dV()end elseif dt.IsMine then a.AlignSubItemOrigin(du,dt)end end}dS(dz(dL()),false)return self end,CreateSubItemConnector=function()local ed=function(ee,d2,ef)ee.item=d2;ee.position=d2.GetPosition()ee.rotation=d2.GetRotation()ee.initialPosition=ee.position;ee.initialRotation=ee.rotation;ee.propagation=not not ef;return ee end;local eg=function(eh)for d2,ee in pairs(eh)do ed(ee,d2,ee.propagation)end end;local ei=function(ej,bh,ee,ek,el)local e7=ej-ee.initialPosition;local em=bh*Quaternion.Inverse(ee.initialRotation)ee.position=ej;ee.rotation=bh;for d2,en in pairs(ek)do if d2~=ee.item and(not el or el(en))then en.position,en.rotation=a.RotateAround(en.initialPosition+e7,en.initialRotation,ej,em)d2.SetPosition(en.position)d2.SetRotation(en.rotation)end end end;local eo={}local ep=true;local eq=false;local self;self={IsEnabled=function()return ep end,SetEnabled=function(aF)ep=aF;if aF then eg(eo)eq=false end end,Contains=function(er)return a.NillableHasValue(eo[er])end,Add=function(es,et)if not es then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(es),2)end;local eu=type(es)=='table'and es or{es}eg(eo)eq=false;for N,d2 in pairs(eu)do eo[d2]=ed({},d2,not et)end end,Remove=function(er)local aT=a.NillableHasValue(eo[er])eo[er]=nil;return aT end,RemoveAll=function()eo={}return true end,Each=function(ah)for d2,ee in pairs(eo)do if ah(d2,self)==false then return false end end end,GetItems=function()local eu={}for d2,ee in pairs(eo)do table.insert(eu,d2)end;return eu end,Update=function()if not ep then return end;local ev=false;for d2,ee in pairs(eo)do local ci=d2.GetPosition()local ew=d2.GetRotation()if not a.VectorApproximatelyEquals(ci,ee.position)or not a.QuaternionApproximatelyEquals(ew,ee.rotation)then if ee.propagation then if d2.IsMine then ei(ci,ew,eo[d2],eo,function(en)if en.item.IsMine then return true else eq=true;return false end end)ev=true;break else eq=true end else eq=true end end end;if not ev and eq then eg(eo)eq=false end end}return self end,GetSubItemTransform=function(er)local ej=er.GetPosition()local bh=er.GetRotation()local ex=er.GetLocalScale()return{positionX=ej.x,positionY=ej.y,positionZ=ej.z,rotationX=bh.x,rotationY=bh.y,rotationZ=bh.z,rotationW=bh.w,scaleX=ex.x,scaleY=ex.y,scaleZ=ex.z}end,RestoreCytanbTransform=function(ey)local ci=ey.positionX and ey.positionY and ey.positionZ and Vector3.__new(ey.positionX,ey.positionY,ey.positionZ)or nil;local ew=ey.rotationX and ey.rotationY and ey.rotationZ and ey.rotationW and Quaternion.__new(ey.rotationX,ey.rotationY,ey.rotationZ,ey.rotationW)or nil;local ex=ey.scaleX and ey.scaleY and ey.scaleZ and Vector3.__new(ey.scaleX,ey.scaleY,ey.scaleZ)or nil;return ci,ew,ex end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',MessageSenderOverride='__CYTANB_MESSAGE_SENDER_OVERRIDE',MessageOriginalSender='__CYTANB_MESSAGE_ORIGINAL_SENDER',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local cw='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local cC=_G[cw]if not cC then cC={}_G[cw]=cC end;local ez=cC.randomSeedValue;if not ez then ez=os.time()-os.clock()*10000;cC.randomSeedValue=ez;math.randomseed(ez)end;local eA=cC.clientID;if type(eA)~='string'then eA=tostring(a.RandomUUID())cC.clientID=eA end;local eB=vci.state.Get(b)or''if eB==''and vci.assets.IsMine then eB=tostring(a.RandomUUID())vci.state.Set(b,eB)end;return eB,eA end)()return a end)()

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

    --- スイッチのトラックのディスプレイのテキストオブジェクト名。
    camSwitchDisplayTrack = 'anim-cam-switch-display-track',

    --- スイッチのトラックのディスプレイの桁数。
    camSwitchDisplayTrackPlaceDigits = 2,

    --- カメラのスイッチのテクスチャーのオフセット座標。
    camSwitchTextureOffset = Vector2.__new(0, 356 / 1024),

    --- デバッグ機能を有効にするかを指定する。(true | false)
    enableDebugging = false
}

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
    local text = ''
    for i = 1, conf.camSwitchDisplayTrackPlaceDigits do
        text = tostring(num % 10) .. text
        num = math.floor(num / 10)
    end
    vci.assets.SetText(conf.camSwitchDisplayTrack, text)
end

local EmitDirectiveStateMessage = function ()
    local state = directiveProcessor.GetState()
    local trackIndex = directiveProcessor.GetTrackIndex()
    cytanb.LogTrace('Emit directiveStateMessage: state = ', state, ', trackIndex = ', trackIndex)
    cytanb.EmitMessage(directiveStateMessageName, {state = state, trackIndex = trackIndex})
end

local UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
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
    end,

    function ()
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
)

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
