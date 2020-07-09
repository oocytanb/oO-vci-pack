-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,{[a.EscapeSequenceTag]=a.EscapeSequenceTag..a.EscapeSequenceTag}),'/',{['/']=a.SolidusTag})end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(af)return af~=nil end,NillableValue=function(af)if af==nil then error('nillable: value is nil',2)end;return af end,NillableValueOrDefault=function(af,ag)if af==nil then if ag==nil then error('nillable: defaultValue is nil',2)end;return ag else return af end end,NillableIfHasValue=function(af,ah)if af==nil then return nil else return ah(af)end end,NillableIfHasValueOrElse=function(af,ah,ai)if af==nil then return ai()else return ah(af)end end,StringReplace=function(P,aj,ak)local al;local S=string.len(P)if aj==''then al=ak;for n=1,S do al=al..string.sub(P,n,n)..ak end else al=''local n=1;while true do local am,V=string.find(P,aj,n,true)if am then al=al..string.sub(P,n,am-1)..ak;n=V+1;if n>S then break end else al=n==1 and P or al..string.sub(P,n)break end end end;return al end,SetConst=function(aj,an,q)if type(aj)~='table'then error('Cannot set const to non-table target',2)end;local ao=getmetatable(aj)local A=ao or{}local ap=rawget(A,x)if rawget(aj,an)~=nil then error('Non-const field "'..an..'" already exists',2)end;if not ap then ap={}rawset(A,x,ap)A.__index=y;A.__newindex=D end;rawset(ap,an,q)if not ao then setmetatable(aj,A)end;return aj end,SetConstEach=function(aj,aq)for N,E in pairs(aq)do a.SetConst(aj,N,E)end;return aj end,Extend=function(aj,ar,as,at,a3)if aj==ar or type(aj)~='table'or type(ar)~='table'then return aj end;if as then if not a3 then a3={}end;if a3[ar]then error('circular reference')end;a3[ar]=true end;for N,E in pairs(ar)do if as and type(E)=='table'then local au=aj[N]aj[N]=a.Extend(type(au)=='table'and au or{},E,as,at,a3)else aj[N]=E end end;if not at then local av=getmetatable(ar)if type(av)=='table'then if as then local aw=getmetatable(aj)setmetatable(aj,a.Extend(type(aw)=='table'and aw or{},av,true))else setmetatable(aj,av)end end end;if as then a3[ar]=nil end;return aj end,Vars=function(E,ax,ay,a3)local az;if ax then az=ax~='__NOLF'else ax='  'az=true end;if not ay then ay=''end;if not a3 then a3={}end;local aA=type(E)if aA=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local aB=az and ay..ax or''local P='('..tostring(E)..') {'local aC=true;for z,aD in pairs(E)do if aC then aC=false else P=P..(az and','or', ')end;if az then P=P..'\n'..aB end;if type(aD)=='table'and a3[aD]and a3[aD]>0 then P=P..z..' = ('..tostring(aD)..')'else P=P..z..' = '..a.Vars(aD,ax,aB,a3)end end;if not aC and az then P=P..'\n'..ay end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif aA=='function'or aA=='thread'or aA=='userdata'then return'('..aA..')'elseif aA=='string'then return'('..aA..') '..string.format('%q',E)else return'('..aA..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aE)f=aE end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aF)g=not not aF end,Log=function(aE,...)if aE<=f then local aG=g and(h[aE]or'LOG LEVEL '..tostring(aE))..' | 'or''local aH=table.pack(...)if aH.n==1 then local E=aH[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aG..P or P)else print(aG)end else local P=aG;for n=1,aH.n do local E=aH[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aI,aJ)local aK={}if aJ==nil then for N,E in pairs(aI)do aK[E]=E end elseif type(aJ)=='function'then for N,E in pairs(aI)do local aL,aM=aJ(E)aK[aL]=aM end else for N,E in pairs(aI)do aK[E]=aJ end end;return aK end,Round=function(aN,aO)if aO then local aP=10^aO;return math.floor(aN*aP+0.5)/aP else return math.floor(aN+0.5)end end,Clamp=function(q,aQ,aR)return math.max(aQ,math.min(q,aR))end,Lerp=function(aS,aT,aA)if aA<=0.0 then return aS elseif aA>=1.0 then return aT else return aS+(aT-aS)*aA end end,LerpUnclamped=function(aS,aT,aA)if aA==0.0 then return aS elseif aA==1.0 then return aT else return aS+(aT-aS)*aA end end,PingPong=function(aA,aU)if aU==0 then return 0,1 end;local aV=math.floor(aA/aU)local aW=aA-aV*aU;if aV<0 then if(aV+1)%2==0 then return aU-aW,-1 else return aW,1 end else if aV%2==0 then return aW,1 else return aU-aW,-1 end end end,VectorApproximatelyEquals=function(aX,aY)return(aX-aY).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aX,aY)local aZ=Quaternion.Dot(aX,aY)return aZ<1.0+1E-06 and aZ>1.0-1E-06 end,
QuaternionToAngleAxis=function(a_)local aV=a_.normalized;local b0=math.acos(aV.w)local b1=math.sin(b0)local b2=math.deg(b0*2.0)local b3;if math.abs(b1)<=Quaternion.kEpsilon then b3=Vector3.right else local am=1.0/b1;b3=Vector3.__new(aV.x*am,aV.y*am,aV.z*am)end;return b2,b3 end,QuaternionTwist=function(a_,b4)if b4.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local b5=Vector3.__new(a_.x,a_.y,a_.z)if b5.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b6=Vector3.Project(b5,b4)if b6.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b7=Quaternion.__new(b6.x,b6.y,b6.z,a_.w)b7.Normalize()return b7 else return Quaternion.AngleAxis(0,b4)end else local b8=a.QuaternionToAngleAxis(a_)return Quaternion.AngleAxis(b8,b4)end end,ApplyQuaternionToVector3=function(a_,b9)local ba=a_.w*b9.x+a_.y*b9.z-a_.z*b9.y;local bb=a_.w*b9.y-a_.x*b9.z+a_.z*b9.x;local bc=a_.w*b9.z+a_.x*b9.y-a_.y*b9.x;local bd=-a_.x*b9.x-a_.y*b9.y-a_.z*b9.z;return Vector3.__new(bd*-a_.x+ba*a_.w+bb*-a_.z-bc*-a_.y,bd*-a_.y-ba*-a_.z+bb*a_.w+bc*-a_.x,bd*-a_.z+ba*-a_.y-bb*-a_.x+bc*a_.w)end,RotateAround=function(be,bf,bg,bh)return bg+bh*(be-bg),bh*bf end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bi)return p.__tostring(bi)end,UUIDFromNumbers=function(...)local bj=...local aA=type(bj)local bk,bl,bm,bn;if aA=='table'then bk=bj[1]bl=bj[2]bm=bj[3]bn=bj[4]else bk,bl,bm,bn=...end;local bi={bit32.band(bk or 0,0xFFFFFFFF),bit32.band(bl or 0,0xFFFFFFFF),bit32.band(bm or 0,0xFFFFFFFF),bit32.band(bn or 0,0xFFFFFFFF)}setmetatable(bi,p)return bi end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bo='[0-9a-f-A-F]+'local bp='^('..bo..')$'local bq='^-('..bo..')$'local br,bs,bt,bu;if S==32 then local bi=a.UUIDFromNumbers(0,0,0,0)local bv=1;for n,bw in ipairs({8,16,24,32})do br,bs,bt=string.find(string.sub(P,bv,bw),bp)if not br then return nil end;bi[n]=tonumber(bt,16)bv=bw+1 end;return bi else br,bs,bt=string.find(string.sub(P,1,8),bp)if not br then return nil end;local bk=tonumber(bt,16)br,bs,bt=string.find(string.sub(P,9,13),bq)if not br then return nil end;br,bs,bu=string.find(string.sub(P,14,18),bq)if not br then return nil end;local bl=tonumber(bt..bu,16)br,bs,bt=string.find(string.sub(P,19,23),bq)if not br then return nil end;br,bs,bu=string.find(string.sub(P,24,28),bq)if not br then return nil end;local bm=tonumber(bt..bu,16)br,bs,bt=string.find(string.sub(P,29,36),bp)if not br then return nil end;local bn=tonumber(bt,16)return a.UUIDFromNumbers(bk,bl,bm,bn)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bx)if type(bx)~='number'or bx<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bx),2)end;local self;local by=math.floor(bx)local U={}local bz=0;local bA=0;local bB=0;self={Size=function()return bB end,Clear=function()bz=0;bA=0;bB=0 end,IsEmpty=function()return bB==0 end,Offer=function(bC)U[bz+1]=bC;bz=(bz+1)%by;if bB<by then bB=bB+1 else bA=(bA+1)%by end;return true end,OfferFirst=function(bC)bA=(by+bA-1)%by;U[bA+1]=bC;if bB<by then bB=bB+1 else bz=(by+bz-1)%by end;return true end,Poll=function()if bB==0 then return nil else local bC=U[bA+1]bA=(bA+1)%by;bB=bB-1;return bC end end,PollLast=function()if bB==0 then return nil else bz=(by+bz-1)%by;local bC=U[bz+1]bB=bB-1;return bC end end,Peek=function()if bB==0 then return nil else return U[bA+1]end end,PeekLast=function()if bB==0 then return nil else return U[(by+bz-1)%by+1]end end,Get=function(bD)if bD<1 or bD>bB then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bD)return nil end;return U[(bA+bD-1)%by+1]end,IsFull=function()return bB>=by end,MaxSize=function()return by end}return self end,DetectClicks=function(bE,bF,bG)local bH=bE or 0;local bI=bG or TimeSpan.FromMilliseconds(500)local bJ=vci.me.Time;local bK=bF and bJ>bF+bI and 1 or bH+1;return bK,bJ end,ColorRGBToHSV=function(bL)local aW=math.max(0.0,math.min(bL.r,1.0))local bM=math.max(0.0,math.min(bL.g,1.0))local aT=math.max(0.0,math.min(bL.b,1.0))local aR=math.max(aW,bM,aT)local aQ=math.min(aW,bM,aT)local bN=aR-aQ;local C;if bN==0.0 then C=0.0 elseif aR==aW then C=(bM-aT)/bN/6.0 elseif aR==bM then C=(2.0+(aT-aW)/bN)/6.0 else C=(4.0+(aW-bM)/bN)/6.0 end;if C<0.0 then C=C+1.0 end;local bO=aR==0.0 and bN or bN/aR;local E=aR;return C,bO,E end,ColorFromARGB32=function(bP)local bQ=type(bP)=='number'and bP or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bQ,16),0xFF)/0xFF,bit32.band(bit32.rshift(bQ,8),0xFF)/0xFF,bit32.band(bQ,0xFF)/0xFF,bit32.band(bit32.rshift(bQ,24),0xFF)/0xFF)end,ColorToARGB32=function(bL)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bL.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bL.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bL.g),0xFF),8),bit32.band(a.Round(0xFF*bL.b),0xFF))end,ColorFromIndex=function(bR,bS,bT,bU,bV)local bW=math.max(math.floor(bS or a.ColorHueSamples),1)local bX=bV and bW or bW-1;local bY=math.max(math.floor(bT or a.ColorSaturationSamples),1)local bZ=math.max(math.floor(bU or a.ColorBrightnessSamples),1)local bD=a.Clamp(math.floor(bR or 0),0,bW*bY*bZ-1)local b_=bD%bW;local c0=math.floor(bD/bW)local am=c0%bY;local c1=math.floor(c0/bY)if bV or b_~=bX then local C=b_/bX;local bO=(bY-am)/bY;local E=(bZ-c1)/bZ;return Color.HSVToRGB(C,bO,E)else local E=(bZ-c1)/bZ*am/(bY-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bL,bS,bT,bU,bV)local bW=math.max(math.floor(bS or a.ColorHueSamples),1)local bX=bV and bW or bW-1;local bY=math.max(math.floor(bT or a.ColorSaturationSamples),1)local bZ=math.max(math.floor(bU or a.ColorBrightnessSamples),1)local C,bO,E=a.ColorRGBToHSV(bL)local am=a.Round(bY*(1.0-bO))if bV or am<bY then local c2=a.Round(bX*C)if c2>=bX then c2=0 end;if am>=bY then am=bY-1 end;local c1=math.min(bZ-1,a.Round(bZ*(1.0-E)))return c2+bW*(am+bY*c1)else local c3=a.Round((bY-1)*E)if c3==0 then local c4=a.Round(bZ*(1.0-E))if c4>=bZ then return bW-1 else return bW*(1+a.Round(E*(bY-1)/(bZ-c4)*bZ)+bY*c4)-1 end else return bW*(1+c3+bY*a.Round(bZ*(1.0-E*(bY-1)/c3)))-1 end end end,ColorToTable=function(bL)return{[a.TypeParameterName]=a.ColorTypeName,r=bL.r,g=bL.g,b=bL.b,a=bL.a}end,ColorFromTable=function(G)local aT,M=F(G,a.ColorTypeName)return aT and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local aT,M=F(G,a.Vector2TypeName)return aT and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local aT,M=F(G,a.Vector3TypeName)return aT and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local aT,M=F(G,a.Vector4TypeName)return aT and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local aT,M=F(G,a.QuaternionTypeName)return aT and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(an,c5)local a4=a.NillableIfHasValueOrElse(c5,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(an,json.serialize(a4))end,OnMessage=function(an,ah)local c6=function(c7,c8,c9)if type(c9)=='string'and c9~=''and string.sub(c9,1,1)=='{'then local ca,a4=pcall(json.parse,c9)if ca and type(a4)=='table'and a4[a.InstanceIDParameterName]then local cb=a.TableFromSerializable(a4)local cc;local cd=cb[a.MessageSenderOverride]if cd then cc=a.Extend(a.Extend({},c7,true),cd,true)cb[a.MessageOriginalSender]=c7 else cc=c7 end;ah(cc,c8,cb)return end end;ah(c7,c8,{[a.MessageValueParameterName]=c9})end;vci.message.On(an,c6)return{Off=function()if c6 then c6=nil end end}end,OnInstanceMessage=function(an,ah)local c6=function(c7,c8,c5)local ce=a.InstanceID()if ce~=''and ce==c5[a.InstanceIDParameterName]then ah(c7,c8,c5)end end;return a.OnMessage(an,c6)end,
EmitCommentMessage=function(c9,cd)local cf={type='comment',name='',commentSource=''}local c5={[a.MessageValueParameterName]=tostring(c9),[a.MessageSenderOverride]=type(cd)=='table'and a.Extend(cf,cd,true)or cf}a.EmitMessage('comment',c5)end,OnCommentMessage=function(ah)local c6=function(c7,c8,c5)local c9=tostring(c5[a.MessageValueParameterName]or'')ah(c7,c8,c9)end;return a.OnMessage('comment',c6)end,EmitNotificationMessage=function(c9,cd)local cf={type='notification',name='',commentSource=''}local c5={[a.MessageValueParameterName]=tostring(c9),[a.MessageSenderOverride]=type(cd)=='table'and a.Extend(cf,cd,true)or cf}a.EmitMessage('notification',c5)end,OnNotificationMessage=function(ah)local c6=function(c7,c8,c5)local c9=tostring(c5[a.MessageValueParameterName]or'')ah(c7,c8,c9)end;return a.OnMessage('notification',c6)end,GetEffekseerEmitterMap=function(an)local cg=vci.assets.GetEffekseerEmitters(an)if not cg then return nil end;local aK={}for n,ch in pairs(cg)do aK[ch.EffectName]=ch end;return aK end,ClientID=function()return j end,ParseTagString=function(P)local ci=string.find(P,'#',1,true)if not ci then return{},P end;local cj={}local ck=string.sub(P,1,ci-1)ci=ci+1;local S=string.len(P)local cl='^[A-Za-z0-9_%-.()!~*\'%%]+'while ci<=S do local cm,cn=string.find(P,cl,ci)if cm then local co=string.sub(P,cm,cn)local cp=co;ci=cn+1;if ci<=S and string.sub(P,ci,ci)=='='then ci=ci+1;local cq,cr=string.find(P,cl,ci)if cq then cp=string.sub(P,cq,cr)ci=cr+1 else cp=''end end;cj[co]=cp end;ci=string.find(P,'#',ci,true)if not ci then break end;ci=ci+1 end;return cj,ck end,CalculateSIPrefix=(function()local cs=9;local ct={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local cu=#ct;return function(aN)local cv=aN==0 and 0 or a.Clamp(math.floor(math.log(math.abs(aN),1000)),1-cs,cu-cs)return cv==0 and aN or aN/1000^cv,ct[cs+cv],cv*3 end end)(),CreateLocalSharedProperties=function(cw,cx)local cy=TimeSpan.FromSeconds(5)local cz='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cA='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(cw)~='string'or string.len(cw)<=0 or type(cx)~='string'or string.len(cx)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cB=_G[cz]if not cB then cB={}_G[cz]=cB end;cB[cx]=vci.me.UnscaledTime;local cC=_G[cw]if not cC then cC={[cA]={}}_G[cw]=cC end;local cD=cC[cA]local self;self={GetLspID=function()return cw end,GetLoadID=function()return cx end,GetProperty=function(z,ag)local q=cC[z]if q==nil then return ag else return q end end,SetProperty=function(z,q)if z==cA then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bJ=vci.me.UnscaledTime;local cE=cC[z]cC[z]=q;for cF,ce in pairs(cD)do local aA=cB[ce]if aA and aA+cy>=bJ then cF(self,z,q,cE)else cF(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)cD[cF]=nil;cB[ce]=nil end end end,Clear=function()for z,q in pairs(cC)do if z~=cA then self.SetProperty(z,nil)end end end,Each=function(ah)for z,q in pairs(cC)do if z~=cA and ah(q,z,self)==false then return false end end end,AddListener=function(cF)cD[cF]=cx end,RemoveListener=function(cF)cD[cF]=nil end,UpdateAlive=function()cB[cx]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(cG)local cH=1.0;local cI=1000.0;local cJ=TimeSpan.FromSeconds(0.02)local cK=0xFFFF;local cL=a.CreateCircularQueue(64)local cM=TimeSpan.FromSeconds(5)local cN=TimeSpan.FromSeconds(30)local cO=false;local cP=vci.me.Time;local cQ=a.Random32()local cR=Vector3.__new(bit32.bor(0x400,bit32.band(cQ,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cQ,16),0x1FFF)),0.0)cG.SetPosition(cR)cG.SetRotation(Quaternion.identity)cG.SetVelocity(Vector3.zero)cG.SetAngularVelocity(Vector3.zero)cG.AddForce(Vector3.__new(0.0,0.0,cH*cI))local self={Timestep=function()return cJ end,Precision=function()return cK end,IsFinished=function()return cO end,Update=function()if cO then return cJ end;local cS=vci.me.Time-cP;local cT=cS.TotalSeconds;if cT<=Vector3.kEpsilon then return cJ end;local cU=cG.GetPosition().z-cR.z;local cV=cU/cT;local cW=cV/cI;if cW<=Vector3.kEpsilon then return cJ end;cL.Offer(cW)local cX=cL.Size()if cX>=2 and cS>=cM then local cY=0.0;for n=1,cX do cY=cY+cL.Get(n)end;local cZ=cY/cX;local c_=0.0;for n=1,cX do c_=c_+(cL.Get(n)-cZ)^2 end;local d0=c_/cX;if d0<cK then cK=d0;cJ=TimeSpan.FromSeconds(cZ)end;if cS>cN then cO=true;cG.SetPosition(cR)cG.SetRotation(Quaternion.identity)cG.SetVelocity(Vector3.zero)cG.SetAngularVelocity(Vector3.zero)end else cJ=TimeSpan.FromSeconds(cW)end;return cJ end}return self end,AlignSubItemOrigin=function(d1,d2,d3)local d4=d1.GetRotation()if not a.QuaternionApproximatelyEquals(d2.GetRotation(),d4)then d2.SetRotation(d4)end;local d5=d1.GetPosition()if not a.VectorApproximatelyEquals(d2.GetPosition(),d5)then d2.SetPosition(d5)end;if d3 then d2.SetVelocity(Vector3.zero)d2.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local d6={}local self;self={Contains=function(d7,d8)return a.NillableIfHasValueOrElse(d6[d7],function(aq)return a.NillableHasValue(aq[d8])end,function()return false end)end,Add=function(d7,d9,d3)if not d7 or not d9 then local da='SubItemGlue.Add: Invalid arguments '..(not d7 and', parent = '..tostring(d7)or'')..(not d9 and', children = '..tostring(d9)or'')error(da,2)end;local aq=a.NillableIfHasValueOrElse(d6[d7],function(db)return db end,function()local db={}d6[d7]=db;return db end)if type(d9)=='table'then for z,aD in pairs(d9)do aq[aD]={velocityReset=not not d3}end else aq[d9]={velocityReset=not not d3}end end,Remove=function(d7,d8)return a.NillableIfHasValueOrElse(d6[d7],function(aq)if a.NillableHasValue(aq[d8])then aq[d8]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(d7)if a.NillableHasValue(d6[d7])then d6[d7]=nil;return true else return false end end,RemoveAll=function()d6={}return true end,Each=function(ah,dc)return a.NillableIfHasValueOrElse(dc,function(d7)return a.NillableIfHasValue(d6[d7],function(aq)for d8,dd in pairs(aq)do if ah(d8,d7,self)==false then return false end end end)end,function()for d7,aq in pairs(d6)do if self.Each(ah,d7)==false then return false end end end)end,Update=function(de)for d7,aq in pairs(d6)do local df=d7.GetPosition()local dg=d7.GetRotation()for d8,dd in pairs(aq)do if de or d8.IsMine then if not a.QuaternionApproximatelyEquals(d8.GetRotation(),dg)then d8.SetRotation(dg)end;if not a.VectorApproximatelyEquals(d8.GetPosition(),df)then d8.SetPosition(df)end;if dd.velocityReset then d8.SetVelocity(Vector3.zero)d8.SetAngularVelocity(Vector3.zero)end end end end end}return self end,CreateUpdateRoutine=function(dh,di)return coroutine.wrap(function()local dj=TimeSpan.FromSeconds(30)local dk=vci.me.UnscaledTime;local dl=dk;local bF=vci.me.Time;local dm=true;while true do local ce=a.InstanceID()if ce~=''then break end;local dn=vci.me.UnscaledTime;if dn-dj>dk then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;dl=dn;bF=vci.me.Time;dm=false;coroutine.yield(100)end;if dm then dl=vci.me.UnscaledTime;bF=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(di,function(dp)dp()end)while true do local bJ=vci.me.Time;local dq=bJ-bF;local dn=vci.me.UnscaledTime;local dr=dn-dl;dh(dq,dr)bF=bJ;dl=dn;coroutine.yield(100)end end)end,
CreateSlideSwitch=function(ds)local dt=a.NillableValue(ds.colliderItem)local du=a.NillableValue(ds.baseItem)local dv=a.NillableValue(ds.knobItem)local dw=a.NillableValueOrDefault(ds.minValue,0)local dx=a.NillableValueOrDefault(ds.maxValue,10)if dw>=dx then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local dy=(dw+dx)*0.5;local dz=function(aD)local dA,dB=a.PingPong(aD-dw,dx-dw)return dA+dw,dB end;local q=dz(a.NillableValueOrDefault(ds.value,0))local dC=a.NillableIfHasValueOrElse(ds.tickFrequency,function(dD)if dD<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(dD,dx-dw)end,function()return(dx-dw)/10.0 end)local dE=a.NillableIfHasValueOrElse(ds.tickVector,function(b3)return Vector3.__new(b3.x,b3.y,b3.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local dF=dE.magnitude;if dF<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local dG=a.NillableValueOrDefault(ds.snapToTick,true)local dH=ds.valueTextName;local dI=a.NillableValueOrDefault(ds.valueToText,tostring)local dJ=TimeSpan.FromMilliseconds(1000)local dK=TimeSpan.FromMilliseconds(50)local dL,dM;local cD={}local self;local dN=false;local dO=0;local dP=false;local dQ=TimeSpan.Zero;local dR=TimeSpan.Zero;local dS=function(dT,dU)if dU or dT~=q then local cE=q;q=dT;for cF,E in pairs(cD)do cF(self,q,cE)end end;dv.SetLocalPosition((dT-dy)/dC*dE)if dH then vci.assets.SetText(dH,dI(dT,self))end end;local dV=function()local dW=dL()local dX,dY=dz(dW)local dZ=dW+dC;local d_,e0=dz(dZ)assert(d_)local dT;if dY==e0 or dX==dx or dX==dw then dT=dZ else dT=dY>=0 and dx or dw end;dR=vci.me.UnscaledTime;if dT==dx or dT==dw then dQ=dR end;dM(dT)end;a.NillableIfHasValueOrElse(ds.lsp,function(e1)if not a.NillableHasValue(ds.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local e2=a.NillableValue(ds.propertyName)dL=function()return e1.GetProperty(e2,q)end;dM=function(aD)e1.SetProperty(e2,aD)end;e1.AddListener(function(ar,z,e3,e4)if z==e2 then dS(dz(e3),true)end end)end,function()local e3=q;dL=function()return e3 end;dM=function(aD)e3=aD;dS(dz(aD),true)end end)self={GetColliderItem=function()return dt end,GetBaseItem=function()return du end,GetKnobItem=function()return dv end,GetMinValue=function()return dw end,GetMaxValue=function()return dx end,GetValue=function()return q end,GetScaleValue=function(e5,e6)assert(e5<=e6)return e5+(e6-e5)*(q-dw)/(dx-dw)end,SetValue=function(aD)dM(dz(aD))end,GetTickFrequency=function()return dC end,IsSnapToTick=function()return dG end,AddListener=function(cF)cD[cF]=cF end,RemoveListener=function(cF)cD[cF]=nil end,DoUse=function()if not dN then dP=true;dQ=vci.me.UnscaledTime;dV()end end,DoUnuse=function()dP=false end,DoGrab=function()if not dP then dN=true;dO=(q-dy)/dC end end,DoUngrab=function()dN=false end,Update=function()if dN then local e7=dt.GetPosition()-du.GetPosition()local e8=dv.GetRotation()*dE;local e9=Vector3.Project(e7,e8)local ea=(Vector3.Dot(e8,e9)>=0 and 1 or-1)*e9.magnitude/dF+dO;local eb=(dG and a.Round(ea)or ea)*dC+dy;local dT=a.Clamp(eb,dw,dx)if dT~=q then dM(dT)end elseif dP then local ec=vci.me.UnscaledTime;if ec>=dQ+dJ and ec>=dR+dK then dV()end elseif dt.IsMine then a.AlignSubItemOrigin(du,dt)end end}dS(dz(dL()),false)return self end,CreateSubItemConnector=function()local ed=function(ee,d2,ef)ee.item=d2;ee.position=d2.GetPosition()ee.rotation=d2.GetRotation()ee.initialPosition=ee.position;ee.initialRotation=ee.rotation;ee.propagation=not not ef;return ee end;local eg=function(eh)for d2,ee in pairs(eh)do ed(ee,d2,ee.propagation)end end;local ei=function(ej,bh,ee,ek,el)local e7=ej-ee.initialPosition;local em=bh*Quaternion.Inverse(ee.initialRotation)ee.position=ej;ee.rotation=bh;for d2,en in pairs(ek)do if d2~=ee.item and(not el or el(en))then en.position,en.rotation=a.RotateAround(en.initialPosition+e7,en.initialRotation,ej,em)d2.SetPosition(en.position)d2.SetRotation(en.rotation)end end end;local eo={}local ep=true;local eq=false;local self;self={IsEnabled=function()return ep end,SetEnabled=function(aF)ep=aF;if aF then eg(eo)eq=false end end,Contains=function(er)return a.NillableHasValue(eo[er])end,Add=function(es,et)if not es then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(es),2)end;local eu=type(es)=='table'and es or{es}eg(eo)eq=false;for N,d2 in pairs(eu)do eo[d2]=ed({},d2,not et)end end,Remove=function(er)local aT=a.NillableHasValue(eo[er])eo[er]=nil;return aT end,RemoveAll=function()eo={}return true end,Each=function(ah)for d2,ee in pairs(eo)do if ah(d2,self)==false then return false end end end,GetItems=function()local eu={}for d2,ee in pairs(eo)do table.insert(eu,d2)end;return eu end,Update=function()if not ep then return end;local ev=false;for d2,ee in pairs(eo)do local ci=d2.GetPosition()local ew=d2.GetRotation()if not a.VectorApproximatelyEquals(ci,ee.position)or not a.QuaternionApproximatelyEquals(ew,ee.rotation)then if ee.propagation then if d2.IsMine then ei(ci,ew,eo[d2],eo,function(en)if en.item.IsMine then return true else eq=true;return false end end)ev=true;break else eq=true end else eq=true end end end;if not ev and eq then eg(eo)eq=false end end}return self end,GetSubItemTransform=function(er)local ej=er.GetPosition()local bh=er.GetRotation()local ex=er.GetLocalScale()return{positionX=ej.x,positionY=ej.y,positionZ=ej.z,rotationX=bh.x,rotationY=bh.y,rotationZ=bh.z,rotationW=bh.w,scaleX=ex.x,scaleY=ex.y,scaleZ=ex.z}end,RestoreCytanbTransform=function(ey)local ci=ey.positionX and ey.positionY and ey.positionZ and Vector3.__new(ey.positionX,ey.positionY,ey.positionZ)or nil;local ew=ey.rotationX and ey.rotationY and ey.rotationZ and ey.rotationW and Quaternion.__new(ey.rotationX,ey.rotationY,ey.rotationZ,ey.rotationW)or nil;local ex=ey.scaleX and ey.scaleY and ey.scaleZ and Vector3.__new(ey.scaleX,ey.scaleY,ey.scaleZ)or nil;return ci,ew,ex end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',MessageSenderOverride='__CYTANB_MESSAGE_SENDER_OVERRIDE',MessageOriginalSender='__CYTANB_MESSAGE_ORIGINAL_SENDER',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local cw='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local cC=_G[cw]if not cC then cC={}_G[cw]=cC end;local ez=cC.randomSeedValue;if not ez then ez=os.time()-os.clock()*10000;cC.randomSeedValue=ez;math.randomseed(ez)end;local eA=cC.clientID;if type(eA)~='string'then eA=tostring(a.RandomUUID())cC.clientID=eA end;local eB=vci.state.Get(b)or''if eB==''and vci.assets.IsMine then eB=tostring(a.RandomUUID())vci.state.Set(b,eB)end;return eB,eA end)()return a end)()

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
        return Quaternion.AngleAxis(- angle, axis) * vec
    end
end

local IsContactWithTarget = function (sourcePosition, sourceLongSide, targetPosition, targetLongSide)
    -- `GetPosition()` が正確に衝突した位置を返すとは限らないので、ズレを考慮して幅を持たせる。
    return (sourcePosition - targetPosition).sqrMagnitude <= ((sourceLongSide + targetLongSide) * 0.75 ) ^ 2
end

local settings = require('cball-settings').Load(_ENV, cytanb)

local cballNS = 'com.github.oocytanb.oO-vci-pack.cball'
local statusMessageName = cballNS .. '.status'
local queryStatusMessageName = cballNS .. '.query-status'
local statusChangedMessageName = cballNS .. 'status-changed'
local respawnBallMessageName = cballNS .. '.respawn-ball'
local buildStandLightMessageName = cballNS .. '.build-standlight'
local buildAllStandLightsMessageName = cballNS .. '.build-all-standlights'
local hitMessageName = cballNS .. '.hit'
local throwingStatsMessageName = cballNS .. 'throwing-stats'
local showSettingsPanelMessageName = cballNS .. '.show-settings-panel'

local colorPaletteItemStatusMessageName = 'cytanb.color-palette.item-status'

--- VCI がロードされたか。
local vciLoaded = false

local hiddenPosition

local avatarColliderMap = cytanb.ListToMap(settings.avatarColliders, true)
local timestepEstimater
local fixedTimestep

local ball, ballCup
local ballEfkContainer, ballEfk, ballEfkFade, ballEfkFadeMove, ballEfkOne, ballEfkOneLarge, ballDiscernibleEfkPlayer
local standLights, standLightEfkContainer, standLightHitEfk, standLightDirectHitEfk
local colorPickers, currentColorPicker
local impactForceGauge, impactSpinGauge
local settingsPanel, settingsPanelGlue, closeSwitch
local slideSwitchMap, velocitySwitch, angularVelocitySwitch, altitudeSwitch, throwingAdjustmentSwitch, gravitySwitch, efkLevelSwitch, audioVolumeSwitch

local ballStatus = {
    --- ボールがつかまれているか。
    grabbed = false,

    --- ボールがグリップされたか。
    gripPressed = false,

    --- ボールがグリップされた時間。
    gripStartTime = TimeSpan.Zero,

    --- ボールがリスポーンした時間。
    respawnTime = vci.me.Time,

    --- 重力係数。
    gravityFactor = 0.0,

    --- ボールのトランスフォームのキュー。
    transformQueue = cytanb.CreateCircularQueue(32),

    --- ボールの角速度のシミュレーション値。
    simAngularVelocity = Vector3.zero,

    --- ボールがライト以外に当たった回数。
    boundCount = 0
}

local ballCupStatus = {
    --- カップがつかまれているか。
    grabbed = false,

    --- カップのクリック数。
    clickCount = 0,

    --- カップのクリック時間。
    clickTime = TimeSpan.Zero,

    --- カップのグラブによるクリック数。
    grabClickCount = 0,

    --- カップのグラブによるクリック時間。
    grabClickTime = TimeSpan.Zero
}

local standLightInitialStatus = {
    --- ビルドが必要であることを示すフラグ。
    buildFlag = false,

    --- ライトがアクティブであるか。
    active = true,

    --- ライトがインアクティブになったときの時間。
    inactiveTime = TimeSpan.Zero,

    --- ライトをインアクティブにできるようになった時間。操作権の違うボールがヒットしたときに、セットされる。
    readyInactiveTime = TimeSpan.Zero,

    --- ヒットメッセージを処理したときの時間。短時間で複数回ヒット処理をしてしまうのを避けるために利用される。
    hitMessageTime = TimeSpan.Zero,

    --- ヒットの起点となったボールのクライアント ID。ライト同士が玉突き状態で倒れた時に、起点の ID を識別できるようにする。
    hitSourceID = '',

    --- ボールが直接ライトにヒットしたか。
    directHit = false
}

local discernibleColorStatus = {
    --- 識別色の初期化を行ったか。
    initialized = not vci.assets.IsMine,

    --- 存在する識別色のインデックステーブル。
    existentIndexTable = {},

    --- 識別色の存在チェックをリクエストした時間。
    checkRequestedTime = TimeSpan.Zero,

    --- カラーパレットへの衝突カウント。
    paletteCollisionCount = 0,

    --- カラーパレットへ衝突した時間。
    paletteCollisionTime = TimeSpan.Zero
}

local impactStatus = {
    --- 投球フェーズ。
    phase = 0,

    --- 投球の威力の比率。
    forceGaugeRatio = 0,

    --- 投球のスピンの比率。
    spinGaugeRatio = 0,

    --- 投球のゲージの表示開始時間。
    gaugeStartTime = TimeSpan.Zero
}

local settingsPanelStatus = {
    --- 設定パネルがつかまれているか。
    grabbed = false,

    --- 設定パネルがグリップされたか。
    gripPressed = false,

    --- 設定パネルがグリップされた時間。
    gripStartTime = TimeSpan.Zero
}

--- 統計情報のキャッシュ
local statsCache = {
    --- 最後に統計情報を出力した時間。
    lastOutputTime = vci.me.Time,

    --- 投球をキャッシュしている数。この値がゼロより大きければ、適当なタイミングで統計情報を出力する。
    throwingCache = 0,

    --- 最後に投球を行ったときの速度。
    throwingVelocity = Vector3.zero,

    --- 最後に投球を行ったときの回転速度。
    throwingAngularVelocity = Vector3.zero,

    --- 最後に投球を行ったときの位置。
    throwingPosition = Vector3.zero,

    --- 最後に投球を行ったときのフレームタイム。
    throwingFrameSeconds = 0,

    --- 重力加速度。
    gravity = settings.defaultGravity,
}

--- ライトを組み立てるリクエストを送った時間。
local standLightsLastRequestTime = vci.me.UnscaledTime

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local ResetStats = function ()
    cytanb.LogInfo('Reset stats')
    statsCache.throwingCache = 0
    settings.statsLsp.Clear()
end

local StatsToString = function (stats)
    local indent = '  '

    -- 設定値
    local settingsString = ''
    for name, val in pairs(stats.settingsValues) do
        settingsString = (settingsString == '' and '' or settingsString .. ', ') .. name .. ': ' .. tostring(val)
    end
    settingsString = settingsString .. '}'

    -- 直線距離での、予測飛距離を計算する。
    -- カーブを考慮しないことや、フレームレートの影響による AddForce の変動、その他の要因により、実測とは異なる。
    local predictedFlyingDistanceString
    if stats.throwingPosition.y > 0 and stats.gravity < 0 then
        local g = - stats.gravity
        local h = stats.throwingPosition.y
        local vx0 = math.sqrt(stats.throwingVelocity.x ^ 2 + stats.throwingVelocity.z ^ 2)
        local vy0 = stats.throwingVelocity.y
        local distance = vx0 * (vy0 + math.sqrt(vy0 ^ 2 + 2 * g * h)) / g
        local uDistance, siPrefix = cytanb.CalculateSIPrefix(distance)
        predictedFlyingDistanceString = cytanb.Round(uDistance, 2) .. ' [' .. siPrefix .. 'm]'
    else
        predictedFlyingDistanceString = 'N/A'
    end

    local frameTimeLine = stats.throwingFrameSeconds <= 0 and '' or indent .. 'frameTime: ' .. cytanb.Round(stats.throwingFrameSeconds * 1000) .. ' [ms] (' .. cytanb.Round(1.0 / stats.throwingFrameSeconds, 2) .. ')\n'

    return indent .. 'settings: ' .. settingsString
        .. '\n' .. frameTimeLine
        .. indent .. 'throwingCount: ' .. stats.throwingCount
        .. '\n' .. indent .. 'velocity: ' .. cytanb.Round(stats.throwingVelocity.magnitude * 3.6, 2) .. ' [km/h], Vector3' .. tostring(stats.throwingVelocity)
        .. '\n' .. indent .. 'angularVelocity: magnitude(' .. cytanb.Round(stats.throwingAngularVelocity.magnitude, 2) .. '), Vector3' .. tostring(stats.throwingAngularVelocity)
        .. '\n' .. indent .. 'predictedFlyingDistance: ' .. predictedFlyingDistanceString
end

local TreatStatsCache = function ()
    if statsCache.throwingCache <= 0 then
        return
    end

    local now = vci.me.Time
    if now - settings.resetOperationTime <= statsCache.lastOutputTime then
        return
    end
    statsCache.lastOutputTime = now

    settings.statsLsp.SetProperty(
        settings.statsThrowingCountPropertyName,
        settings.statsLsp.GetProperty(settings.statsThrowingCountPropertyName, 0) + statsCache.throwingCache
    )

    statsCache.throwingCache = 0

    local settingsValues = {}
    for switchName, parameter in pairs(settings.switchParameters) do
        settingsValues[parameter.propertyName] = slideSwitchMap[switchName].GetValue()
    end

    cytanb.EmitMessage(throwingStatsMessageName, {
        clientID = cytanb.ClientID(),
        stats = {
            throwingCount = settings.statsLsp.GetProperty(settings.statsThrowingCountPropertyName, 0),
            throwingVelocity = cytanb.Vector3ToTable(statsCache.throwingVelocity),
            throwingAngularVelocity = cytanb.Vector3ToTable(statsCache.throwingAngularVelocity),
            throwingPosition = cytanb.Vector3ToTable(statsCache.throwingPosition),
            throwingFrameSeconds = statsCache.throwingFrameSeconds,
            gravity = statsCache.gravity,
            settingsValues = settingsValues
        }
    })
end

local IncrementStatsHitCount = function (targetName)
    local propertyName = settings.statsHitCountPropertyNamePrefix .. targetName
    settings.statsLsp.SetProperty(
        propertyName,
        settings.statsLsp.GetProperty(propertyName, 0) + 1
    )
end

local CalcDirectionAngle = function (angle360)
    local angle = angle360 % 360
    return (angle <= 180 and angle or angle - 360)
end

local CalcAngularVelocity = function (axis, directionAngle180, seconds)
    return axis * ((directionAngle180 <= 0 and 1 or -1) * math.rad(directionAngle180 / seconds))
end

local CalcAdjustmentValue = function (switch, impactMode)
    local parameters = cytanb.NillableValue(settings.switchParameters[switch.GetColliderItem().GetName()])
    local min = impactMode and parameters.minImpactScaleValue or parameters.minScaleValue
    local max = impactMode and parameters.maxImpactScaleValue or parameters.maxScaleValue
    return min + (max - min) * (switch.GetValue() - parameters.minValue) / (parameters.maxValue - parameters.minValue)
end

local CalcThrowingAdjustmentSeconds = function ()
    return CalcAdjustmentValue(throwingAdjustmentSwitch, false) ^ settings.ballThrowingAdjustmentTimeExponent
end

local CalcGravityFactor = function ()
    return - CalcAdjustmentValue(gravitySwitch, false)
end

local CalcAudioVolume = function ()
    return cytanb.Clamp(audioVolumeSwitch.GetValue() / audioVolumeSwitch.GetMaxValue(), 0.0, 1.0)
end

local CreateDiscernibleEfkPlayer = function (efk, periodTime)
    local period = periodTime
    local color = Color.__new(0, 0, 0, 0)
    local lastPlayTime = TimeSpan.Zero

    local self
    self = {
        GetEfk = function ()
            return efk
        end,

        GetPeriod = function ()
            return period
        end,

        SetPeriod = function (time)
            period = time
        end,

        GetColor = function ()
            return color
        end,

        SetColor = function (discernibleColor)
            color = discernibleColor
        end,

        ContinualPlay = function ()
            local efkLevel = efkLevelSwitch.GetValue()
            if efkLevel >= 9 then
                local now = vci.me.UnscaledTime
                if now >= lastPlayTime + period then
                    lastPlayTime = now
                    efk.Stop()
                    efk.Play()
                    efk.SetAllColor(color)
                end
            end
        end,

        Stop = function ()
            if lastPlayTime ~= TimeSpan.Zero then
                efk.Stop()
                lastPlayTime = TimeSpan.Zero
            end
        end
    }
    return self
end

local SetDiscernibleColor = function (color)
    cytanb.LogDebug('SetDiscernibleColor: color = ', color)
    ballDiscernibleEfkPlayer.SetColor(color)
    vci.assets.SetMaterialColorFromName(settings.ballCoveredLightMat, color)
    -- vci.assets.SetMaterialEmissionColorFromName(settings.ballCoveredLightMat, Color.__new(color.r * 1.5, color.g * 1.5, color.b * 1.5, 1.0))
end

local OfferBallTransform = function (position, rotation, time)
    ballStatus.transformQueue.Offer({position = position, rotation = rotation, time = time or vci.me.Time})
end

local CreateDiscernibleColorParameter = function ()
    return {
        clientID = cytanb.ClientID(),
        discernibleColor = cytanb.ColorToTable(ballDiscernibleEfkPlayer.GetColor())
    }
end

local CreateBallStatusParameter = function ()
    return {
        name = ball.GetName(),
        position = cytanb.Vector3ToTable(ball.GetPosition()),
        rotation = cytanb.QuaternionToTable(ball.GetRotation()),
        longSide = settings.ballSimLongSide,
        mass = settings.ballSimMass,
        grabbed = ballStatus.grabbed,
        operator = ball.IsMine
    }
end

local CreateStandLightStatusParameter = function (light)
    local li = light.item
    local ls = light.status
    return {
        name = li.GetName(),
        position = cytanb.Vector3ToTable(li.GetPosition()),
        rotation = cytanb.QuaternionToTable(li.GetRotation()),
        longSide = settings.standLightSimLongSide,
        mass = settings.standLightSimMass,
        respawnPosition = cytanb.Vector3ToTable(ls.respawnPosition),
        grabbed = ls.grabbed,
        operator = li.IsMine
    }
end

local EmitHitBall = function (targetName, hitBaseName)
    if not ball.IsMine then
        cytanb.LogWarn('Unexpected operation: ball is not mine @EmitHitBall')
        return
    end

    local queueSize = ballStatus.transformQueue.Size()
    local velocity
    if queueSize >= 3 then
        -- 直前の位置をとると、衝突後の位置が入っているため、その前の位置を採用する
        local et = ballStatus.transformQueue.Get(queueSize - 1)
        local st = ballStatus.transformQueue.Get(queueSize - 2)
        local dp = et.position - st.position
        local deltaSec = (et.time - st.time).TotalSeconds
        velocity = dp / (deltaSec > 0 and deltaSec or 0.000001)
        cytanb.LogTrace('EmitHitBall: deltaPos = ', dp, ', deltaSec = ', deltaSec)
    else
        velocity = Vector3.zero
        cytanb.LogTrace('EmitHitBall: zero velocity')
    end

    cytanb.LogTrace('  emit ', hitMessageName, ': target = ', targetName, ', velocity = ', velocity, ', boundCount = ', ballStatus.boundCount)
    cytanb.EmitMessage(hitMessageName, {
        source = cytanb.Extend(CreateBallStatusParameter(), {
            velocity = cytanb.Vector3ToTable(velocity),
            hitSourceID = cytanb.ClientID()
        }),
        target = {
            name = targetName
        },
        directHit = ballStatus.boundCount == 0
    })

    -- ライト以外のターゲットに当たったら、ヒットカウントを更新する。
    -- ライトは自前で倒れた処理をしているので、そちらでカウントする。
    if not cytanb.NillableHasValue(standLights[targetName]) then
        IncrementStatsHitCount(hitBaseName == '' and targetName or hitBaseName)
    end
end

local EmitHitStandLight = function (light, targetName)
    local li = light.item
    local ls = light.status
    if not li.IsMine then
        cytanb.LogWarn('Unexpected operation: light is not mine @EmitHitStandLight')
        return
    end

    local now = vci.me.Time
    if now > ls.inactiveTime + settings.requestIntervalTime then
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

    --@todo hitMessage が来る前に、ライトがターゲットに当たった場合は、hitSourceID を正しく設定できないので、対策を考える。
    local hitSourceID = now <= ls.hitMessageTime + settings.requestIntervalTime and ls.hitSourceID or ''

    cytanb.LogTrace('  emit ', hitMessageName, ': target = ', targetName, ', velocity = ', velocity, ', hitSourceID = ', hitSourceID)
    cytanb.EmitMessage(hitMessageName, {
        source = cytanb.Extend(CreateStandLightStatusParameter(light), {
            velocity = cytanb.Vector3ToTable(velocity),
            hitSourceID = hitSourceID
        }),
        target = {
            name = targetName
        },
        directHit = false
    })
end

local BuildStandLight = function (light)
    local li = light.item
    local ls = light.status

    cytanb.Extend(ls, standLightInitialStatus)
    ls.inactiveTime = vci.me.Time

    if li.IsMine and not ls.grabbed then
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
    -- ライトが倒れた直後ならヒットしたものとして判定する
    if not ls.active and now <= ls.inactiveTime + settings.requestIntervalTime then
        if ls.hitSourceID == cytanb.ClientID() then
            IncrementStatsHitCount(settings.standLightBaseName)
        end

        local efkLevel = efkLevelSwitch.GetValue()
        if efkLevel == 5 and ball.IsMine then
            -- レベル 5 で、ボールの操作権があるときは、レベル 6 のエフェクトを表示する
            efkLevel = 6
        end

        if efkLevel >= 6 then
            local efk = ls.directHit and standLightDirectHitEfk or standLightHitEfk
            cytanb.LogTrace('play efk: ', efk.EffectName, ',', li.GetName())
            standLightEfkContainer.SetPosition(li.GetPosition())
            efk.Play()
            efk.SetAllColor(ballDiscernibleEfkPlayer.GetColor())
        end

        local volume = CalcAudioVolume()
        if volume > 0 then
            local clipName
            if ls.directHit then
                clipName = settings.standLightDirectHitAudioName
            else
                clipName = settings.standLightHitAudioPrefix .. light.index
            end
            cytanb.LogTrace('play audio: ', clipName, ', volume = ', volume)
            vci.assets.audio.PlayOneShot(clipName, volume)
        end

        ls.readyInactiveTime = TimeSpan.Zero
    end
end

--- ゲージをリセットする。
local ResetGauge = function ()
    impactStatus.phase = 0
    impactStatus.spinGaugeRatio = 0
    impactStatus.forceGaugeRatio = 0
    impactStatus.gaugeStartTime = vci.me.Time
    ballStatus.simAngularVelocity = Vector3.zero

    impactForceGauge.SetPosition(hiddenPosition)
    impactForceGauge.SetRotation(Quaternion.identity)
    impactSpinGauge.SetPosition(hiddenPosition)
    impactSpinGauge.SetRotation(Quaternion.identity)
    vci.assets.SetMaterialTextureOffsetFromName(settings.impactForceGaugeMat, Vector2.zero)
end

local ResetBallCup = function ()
    if ballCup.IsMine and not ballCupStatus.grabbed and not IsHorizontalAttitude(ballCup.GetRotation()) then
        cytanb.LogTrace('reset cup rotation')
        ballCup.SetRotation(Quaternion.identity)
    end
end

--- ボールをカップへ戻す。
local RespawnBall = function ()
    ballDiscernibleEfkPlayer.Stop()
    ResetGauge()
    ResetBallCup()

    if ball.IsMine then
        ball.SetVelocity(Vector3.zero)
        ball.SetAngularVelocity(Vector3.zero)

        local ballPos = ballCup.GetPosition() + Vector3.__new(0, settings.ballRespawnOffsetY, 0)
        local ballRot = Quaternion.identity
        ball.SetPosition(ballPos)
        ball.SetRotation(ballRot)
        ballStatus.transformQueue.Clear()
        OfferBallTransform(ballPos, ballRot)
        ballStatus.respawnTime = vci.me.Time
        cytanb.LogDebug('on respawn ball: position = ', ballPos)
    end
end

local DrawThrowingTrail = function ()
    local queueSize = ballStatus.transformQueue.Size()
    if not settings.enableThrowingEfk or queueSize < 2 then
        return
    end

    local headTransform = ballStatus.transformQueue.PeekLast()
    local headTime = headTransform.time

    for i = queueSize, 1, -1 do
        local element = ballStatus.transformQueue.Get(i)
        if not element then
            break
        end

        if headTime - element.time > settings.ballThrowingAdjustmentTimeThreshold then
            break
        end

        local pos = element.position
        ballEfkContainer.SetPosition(pos)
        ballEfkOneLarge.Play()
    end
end

local PlayThrowingAudio = function (velocityMagnitude)
    local volume = CalcAudioVolume()
    local min = settings.ballThrowingVelocityThreshold
    if volume > 0 and velocityMagnitude > min then
        local max = settings.ballMaxThrowingAudioVelocity
        local mvol = volume * (cytanb.Clamp(velocityMagnitude, min, max) - min) / (max - min)
        -- cytanb.LogTrace('play throwing audio: mvol = ', mvol)
        vci.assets.audio.PlayOneShot(settings.ballThrowingAudioName, mvol)
    end
end

local IsInThrowingMotion = function ()
    local queueSize = ballStatus.transformQueue.Size()
    if not ball.IsMine or queueSize < 2 then
        return false
    end

    local head = ballStatus.transformQueue.Get(queueSize)
    local prev = ballStatus.transformQueue.Get(queueSize - 1)

    local deltaSec = (head.time - prev.time).TotalSeconds
    local dp = head.position - prev.position
    if deltaSec > 0 then
        local velocity = dp.magnitude / deltaSec
        local b = velocity >= settings.ballThrowingVelocityThreshold * 0.5
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

    if impactStatus.phase ~= 0 then
        ResetGauge()
    end

    DrawThrowingTrail()

    if not ball.IsMine then
        return
    end

    if ballStatus.transformQueue.Size() <= 2 then
        return
    end

    ballStatus.gravityFactor = CalcGravityFactor()

    local headTransform = ballStatus.transformQueue.PollLast()
    local headTime = headTransform.time
    local ballPos = headTransform.position
    local ballRot = headTransform.rotation

    local releaseVector = Vector3.zero
    local releaseVectorChecked = false

    local velocityDirection = Vector3.zero
    local totalVelocityMagnitude = 0

    local angularVelocityDirection = Vector3.zero
    local totalAngle = 0

    local totalWeightSec = 0

    local st = headTime
    local sp = ballPos
    local sr = ballRot

    -- 補正時間を計算
    local ft = headTime
    local frameCount = 0
    for i = ballStatus.transformQueue.Size(), 1, -1 do
        local element = ballStatus.transformQueue.Get(i)
        -- 重複しているタイムは除く
        if element.time ~= ft then
            frameCount = frameCount + 1
            ft = element.time
            if frameCount > 10 then
                break
            end
        end
    end

    if frameCount <= 0 then
        return
    end

    local frameSec = (headTime - ft).TotalSeconds / frameCount
    if frameSec <= 0 then
        return
    end
    -- cytanb.LogTrace('frameCount: ', frameCount, ', frameSec: ', frameSec)

    local adjustmentSec = CalcThrowingAdjustmentSeconds() * math.max(0.75, settings.ballThrowingAdjustmentFrameTimeFactor1 * frameSec + settings.ballThrowingAdjustmentFrameTimeFactor2)
    cytanb.LogTrace('adjustmentSec: ', adjustmentSec)

    while true do
        local element = ballStatus.transformQueue.PollLast()
        if not element then
            break
        end

        local kdTime = headTime - element.time
        -- cytanb.LogTrace('kdTime: ', kdTime.TotalSeconds)
        if kdTime > settings.ballThrowingAdjustmentTimeThreshold then
            break
        end

        if kdTime.TotalSeconds > adjustmentSec and velocityDirection ~= Vector3.zero then
            break
        end

        local deltaSec = (st - element.time).TotalSeconds
        if deltaSec > Vector3.kEpsilon then
            local dp = sp - element.position
            local dpMagnitude = dp.magnitude
            if releaseVectorChecked then
                if Vector3.Dot(releaseVector, dp) < 0 then
                    -- リリース時のベクトルから、90 度を超えた開きがある場合は、終了する
                    cytanb.LogTrace('skip: out of angle range [', (headTime - element.time).TotalSeconds, ' sec]')
                    break
                end
            else
                if dpMagnitude <= Vector3.kEpsilon then
                    -- リリース時が静止状態であったとみなして、終了する
                    break
                end
                releaseVectorChecked = true
                releaseVector = dp
            end

            local dhSec = (headTime - st).TotalSeconds
            local weight = settings.ballThrowingAdjustmentWeightBase ^ dhSec
            local dirWeight = settings.ballThrowingAdjustmentDirWeightBase ^ dhSec
            -- cytanb.LogTrace('ballThrowingAdjustment: dhSec = ', dhSec, ', weight = ', weight, ', dirWeight = ', dirWeight)

            totalVelocityMagnitude = (totalVelocityMagnitude + dpMagnitude * weight)
            velocityDirection = (velocityDirection + dp * dirWeight)

            local dr = sr * Quaternion.Inverse(element.rotation)
            local da, axis = cytanb.QuaternionToAngleAxis(dr)
            if (da ~= 0 and da ~= 360) or axis ~= Vector3.right then
                local angle = CalcDirectionAngle(da)
                totalAngle = (totalAngle + angle * weight)
                angularVelocityDirection = (angularVelocityDirection + CalcAngularVelocity(axis, angle * dirWeight, 1))
            end

            totalWeightSec = totalWeightSec + deltaSec * weight
        end

        -- cytanb.LogTrace('velocityDirection: ', velocityDirection, ', angularVelocityDirection: ', angularVelocityDirection)
        st = element.time
        sp = element.position
        sr = element.rotation
    end
    ballStatus.transformQueue.Clear()

    local kinematicVelocityMagnitude = totalWeightSec > Vector3.kEpsilon and totalVelocityMagnitude / totalWeightSec or 0
    -- cytanb.LogTrace('kinematicVelocityMagnitude: ', kinematicVelocityMagnitude)

    if kinematicVelocityMagnitude > settings.ballThrowingVelocityThreshold then
        local velocityMagnitude = CalcAdjustmentValue(velocitySwitch, false) * kinematicVelocityMagnitude
        local velocity = ApplyAltitudeAngle(velocityDirection.normalized, CalcAdjustmentValue(altitudeSwitch, false)) * velocityMagnitude
        local forwardOffset = velocity * (math.min(velocityMagnitude * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset) / velocityMagnitude)

        local angularVelocity = CalcAngularVelocity(angularVelocityDirection.normalized, CalcAdjustmentValue(angularVelocitySwitch, false) * totalAngle, totalWeightSec)

        ballStatus.simAngularVelocity = angularVelocity
        cytanb.LogTrace('Throw ball by kinematic: velocity: ', velocity, ', velocityMagnitude: ', velocityMagnitude, ', angularVelocity: ', angularVelocity, ', angularVelocity.magnitude: ', angularVelocity.magnitude, ', fixedTimestep: ', fixedTimestep.TotalSeconds)
        local curBallPos = ball.GetPosition()
        ball.SetVelocity(velocity)
        ball.SetAngularVelocity(angularVelocity)

        -- update stats
        statsCache.lastOutputTime = vci.me.Time
        statsCache.throwingCache = statsCache.throwingCache + 1
        statsCache.throwingVelocity = velocity
        statsCache.throwingAngularVelocity = angularVelocity
        statsCache.throwingPosition = curBallPos
        statsCache.throwingFrameSeconds = frameSec
        statsCache.gravity = settings.defaultGravity + ballStatus.gravityFactor

        -- 体のコライダーに接触しないように、オフセットを足す
        ballPos = curBallPos + forwardOffset
        ball.SetPosition(ballPos)

        PlayThrowingAudio(velocityMagnitude)
    else
        ballStatus.simAngularVelocity = Vector3.zero
    end

    OfferBallTransform(ballPos, ballRot)
end

--- タイミング入力による投球
local ThrowBallByInputTiming = function ()
    if not ball.IsMine then
        return
    end

    cytanb.LogTrace('Throw ball by input timing: impactSpinGaugeRatio: ', impactStatus.spinGaugeRatio, ', impactForceGaugeRatio: ', impactStatus.forceGaugeRatio, ', fixedTimestep: ', fixedTimestep.TotalSeconds)

    ballStatus.gravityFactor = CalcGravityFactor()

    local forward = impactForceGauge.GetForward()
    local velocityMagnitude = CalcAdjustmentValue(velocitySwitch, true) * impactStatus.forceGaugeRatio
    local forwardOffset = forward * math.min(velocityMagnitude * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset)
    local velocity = ApplyAltitudeAngle(forward * velocityMagnitude, CalcAdjustmentValue(altitudeSwitch, true))

    ballStatus.simAngularVelocity = Vector3.up * (CalcAdjustmentValue(angularVelocitySwitch, true) * math.pi * impactStatus.spinGaugeRatio)
    cytanb.LogTrace('velocity: ', velocity, ', velociytMagnitude: ', velocityMagnitude, ', angularVelocity: ', ballStatus.simAngularVelocity, ', angularVelocity.magnitude: ', ballStatus.simAngularVelocity.magnitude)
    local curBallPos = ball.GetPosition()
    ball.SetVelocity(velocity)
    ball.SetAngularVelocity(ballStatus.simAngularVelocity)

    -- update stats
    statsCache.lastOutputTime = vci.me.Time
    statsCache.throwingCache = statsCache.throwingCache + 1
    statsCache.throwingVelocity = velocity
    statsCache.throwingAngularVelocity = ballStatus.simAngularVelocity
    statsCache.throwingPosition = curBallPos
    statsCache.throwingFrameSeconds = 0
    statsCache.gravity = settings.defaultGravity + ballStatus.gravityFactor

    -- 体のコライダーに接触しないように、オフセットを足す
    local ballPos = curBallPos + forwardOffset
    ball.SetPosition(ballPos)

    PlayThrowingAudio(velocityMagnitude)

    ballStatus.transformQueue.Clear()
    OfferBallTransform(ballPos, ball.GetRotation())
end

--- 識別エフェクトの処理をする。
local OnUpdateDiscernibleEfk = function (deltaTime, unscaledDeltaTime)
    if vci.assets.IsMine and not discernibleColorStatus.initialized and vci.me.UnscaledTime > discernibleColorStatus.checkRequestedTime + settings.requestIntervalTime then
        -- 他のインスタンスの識別色と重複しないように、色を選択する
        local lots = {}
        local count = 0
        for si = 0, cytanb.ColorSaturationSamples - 1 do
            count = 0
            for hi = 0, cytanb.ColorHueSamples - 2 do
                local index = hi + si * cytanb.ColorHueSamples
                if not discernibleColorStatus.existentIndexTable[index] then
                    lots[count] = index
                    count = count + 1
                end
            end
            if count >= 1 then
                break
            end
        end

        local colorIndex = count == 0 and math.random(0, cytanb.ColorHueSamples - 1) or lots[math.random(0, count - 1)]
        cytanb.LogDebug('discernibleColor initialized: colorIndex = ', colorIndex)
        SetDiscernibleColor(cytanb.ColorFromIndex(colorIndex))

        discernibleColorStatus.checkRequestedTime = TimeSpan.Zero
        discernibleColorStatus.initialized = true

        cytanb.EmitMessage(statusChangedMessageName, CreateDiscernibleColorParameter())
    end

    if not ballStatus.grabbed then
        if not ballStatus.transformQueue.IsEmpty() and (ball.GetPosition() - ballStatus.transformQueue.PeekLast().position).sqrMagnitude > 0.0001 then
            -- ボールが動いている時は、識別エフェクトを停止する。
            ballDiscernibleEfkPlayer.Stop()
        else
            -- ボールが動いていない場合は、識別エフェクトを再生する
            ballDiscernibleEfkPlayer.ContinualPlay()
        end
    end
end

--- ゲージの表示を更新する。
local OnUpdateImpactGauge = function (deltaTime, unscaledDeltaTime)
    if impactStatus.phase < 1 then
        local now = vci.me.Time
        if ballStatus.grabbed and ballStatus.gripPressed and now - settings.impactModeTransitionTime > ballStatus.gripStartTime and not IsInThrowingMotion() then
            -- 連続して呼び出されないようにしておく
            ballStatus.gripStartTime = TimeSpan.MaxValue

            -- グリップ長押し状態で、運動による投球動作を行っていない場合は、タイミング入力に移行する。
            cytanb.LogTrace('Start impact mode')
            impactStatus.phase = 1
            impactStatus.gaugeStartTime = now
        else
            -- タイミング入力状態ではないためリターンする。
            return
        end
    end

    if ballStatus.grabbed then
        local ballPos = ball.GetPosition()
        impactForceGauge.SetPosition(ballPos)
        if impactStatus.phase >= 2 then
            impactSpinGauge.SetPosition(ballPos)
        end

        if impactStatus.phase == 1 then
            -- 方向の入力フェーズ
            local ratio = settings.impactGaugeRatioPerSec * deltaTime.TotalSeconds
            local angle = 180 * ratio
            local rotD = Quaternion.AngleAxis(angle, Vector3.up)
            -- cytanb.LogTrace('ratio: ', ratio, ', angle: ', angle, ', rotD : ', rotD)
            impactForceGauge.SetRotation(impactForceGauge.GetRotation() * rotD)
        elseif impactStatus.phase == 2 then
            -- スピンの入力フェーズ
            local ratio = cytanb.PingPong(settings.impactGaugeRatioPerSec * (vci.me.Time - impactStatus.gaugeStartTime).TotalSeconds + 0.5, 1) - 0.5
            local angle = 180 * ratio
            local rotD = Quaternion.AngleAxis(angle, Vector3.up)
            -- cytanb.LogTrace('ratio: ', ratio, ', angle: ', angle, ', rotD : ', rotD)
            impactSpinGauge.SetRotation(impactForceGauge.GetRotation() * rotD)

            -- 境界付近の値を調整する
            local absRatio = math.abs(ratio)
            if absRatio <= 0.05 then
                impactStatus.spinGaugeRatio = 0
            elseif absRatio >= 0.45 then
                impactStatus.spinGaugeRatio = ratio < 0 and -0.5 or 0.5
            else
                impactStatus.spinGaugeRatio = ratio
            end
        elseif impactStatus.phase == 3 then
            -- 威力の入力フェーズ
            local ratio = cytanb.PingPong(settings.impactGaugeRatioPerSec * (vci.me.Time - impactStatus.gaugeStartTime).TotalSeconds, 1)
            local offsetY = settings.impactGaugeMaxUV * ratio
            -- cytanb.LogTrace('ratio: ', ratio, ', offsetY: ', offsetY)
            vci.assets.SetMaterialTextureOffsetFromName(settings.impactForceGaugeMat, Vector2.__new(0, offsetY))

            -- 境界付近の値を調整する
            if ratio <= 0.05 then
                impactStatus.forceGaugeRatio = 0
            elseif ratio >= 0.95 then
                impactStatus.forceGaugeRatio = 1
            else
                impactStatus.forceGaugeRatio = ratio
            end
        end
    else
        if vci.me.Time > impactStatus.gaugeStartTime + settings.impactGaugeDisplayTime then
            -- ゲージの表示時間を終えた
            impactStatus.phase = 0
            impactForceGauge.SetPosition(hiddenPosition)
            impactSpinGauge.SetPosition(hiddenPosition)
        end
    end
end

--- ボールの更新処理をする。カーブさせるための計算をする。
local OnUpdateBall = function (deltaTime, unscaledDeltaTime)
    local ballPos = ball.GetPosition()
    local ballRot = ball.GetRotation()
    local respawned = false

    if not ballStatus.grabbed and not ballStatus.transformQueue.IsEmpty() then
        local now = vci.me.Time
        local lastTransform = ballStatus.transformQueue.PeekLast()
        local lastPos = lastTransform.position

        -- カップとの距離が離れていたら、ボールが転がっているものとして処理する
        local cupSqrDistance = (ballPos - ballCup.GetPosition()).sqrMagnitude
        if now > ballStatus.respawnTime + settings.ballRespawnCoolTime and cupSqrDistance > settings.ballActiveDistanceThreshold ^ 2 then
            if now <= impactStatus.gaugeStartTime + settings.ballWaitingTime and cupSqrDistance <= settings.ballPlayAreaRadius ^ 2 then
                -- ボールの前回位置と現在位置から速度を計算する
                local deltaSec = deltaTime.TotalSeconds
                local velocity = (ballPos - lastPos) / deltaSec

                if ball.IsMine then
                    -- 角速度を計算する
                    ballStatus.simAngularVelocity = ballStatus.simAngularVelocity * (1.0 - math.min(1.0, settings.ballSimAngularDrag * deltaSec))
                    local angularVelocitySqrMagnitude = ballStatus.simAngularVelocity.sqrMagnitude
                    if angularVelocitySqrMagnitude <= 0.0025 then
                        ballStatus.simAngularVelocity = Vector3.zero
                        angularVelocitySqrMagnitude = 0
                    end

                    -- スピンを適用する処理
                    local horzVelocity = Vector3.__new(velocity.x, 0, velocity.z)
                    local velocityMagnitude = horzVelocity.magnitude
                    if velocityMagnitude > 0.0025 and angularVelocitySqrMagnitude ~= 0 then
                        -- 水平方向の力を計算する
                        local rf = settings.ballSimAngularFactor * settings.ballSimMass * ballStatus.simAngularVelocity.y * math.min(settings.maxForceTimeRate, deltaSec / fixedTimestep.TotalSeconds)
                        local vo = Vector3.Cross(Vector3.__new(0, rf, 0), horzVelocity / velocityMagnitude)
                        local vca = Vector3.__new(vo.x, 0, vo.z)
                        ball.AddForce(vca)
                        -- cytanb.LogTrace('vca: ', vca, ', vo: ', vo, ', velocity: ', velocity)
                    end

                    if ballPos.y < -0.25 and ballPos.y < lastPos.y then
                        -- 床抜けの対策。
                        local leapY = 0.125
                        local minY = 0.25 - ballPos.y
                        local dy = lastPos.y - ballPos.y
                        local vy = dy * 0.5 + math.min(minY - leapY, dy * 0.25)
                        local forceY = settings.ballSimMass * vy / deltaSec / fixedTimestep.TotalSeconds
                        cytanb.LogDebug('leap ball: position = ', ballPos, ', vy = ', vy, ', forceY = ', forceY)
                        ball.SetPosition(Vector3.__new(ballPos.x, leapY, ballPos.z))
                        ball.AddForce(Vector3.__new(0, forceY, 0))
                    elseif ballPos.y > settings.ballSimLongSide and math.abs(ballStatus.gravityFactor) > Vector3.kEpsilon then
                        -- 重力処理
                        local fixedSec = fixedTimestep.TotalSeconds
                        local timeRate = deltaSec / fixedSec
                        local accY
                        if ballStatus.gravityFactor > 0.0 and timeRate > 1.0 and velocity.y <= 0.0 then
                            -- 上向きに力を加える場合は、下向きに落下するはずが、フレームレートの減少による浮き上がりをなるべく抑える
                            accY = math.min(ballStatus.gravityFactor - velocity.y / fixedSec, ballStatus.gravityFactor * timeRate)
                        else
                            accY = ballStatus.gravityFactor * math.min(settings.maxForceTimeRate, timeRate)
                        end
                        ball.AddForce(Vector3.__new(0, settings.ballSimMass * accY, 0))
                    end
                end

                local efkLevel = efkLevelSwitch.GetValue()
                if efkLevel == 5 and ball.IsMine then
                    -- レベル 5 で、ボールの操作権があるときは、レベル 6 のエフェクトを表示する
                    efkLevel = 6
                end

                if efkLevel >= 8 or (efkLevel >= 6 and not ballStatus.grabbed) then
                    local vm = velocity.magnitude
                    if vm >= settings.ballTrailVelocityThreshold then
                        local near = cupSqrDistance <= settings.ballNearDistance ^ 2
                        local vmNodes = math.max(1, math.ceil(vm / (settings.ballSimLongSide * settings.ballTrailInterpolationDistanceFactor * (near and 0.5 or 1.0) / deltaSec)))
                        local nodes = math.min(vmNodes, settings.ballTrailInterpolationNodesPerFrame + cytanb.Clamp(math.floor((efkLevel - 6 + (near and 1 or 0)) * 2), 0, 4))
                        local iNodes = 1.0 / nodes
                        local efk
                        if near then
                            -- 近距離の場合は、エフェクトレベルに合わせる
                            if efkLevel >= 8 then
                                efk = ballEfkFadeMove
                            elseif efkLevel == 7 then
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
            elseif ball.IsMine and not ballCupStatus.grabbed then
                -- タイムアウトしたかエリア外に出たボールをカップへ戻す。
                cytanb.LogTrace('elapsed: ' , (now - impactStatus.gaugeStartTime).TotalSeconds, ', sqrDistance: ', cupSqrDistance)
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
local OnUpdateStandLight = function (deltaTime, unscaledDeltaTime)
    local needBuilding = false
    local targets = {}
    for lightName, light in pairs(standLights) do
        local li = light.item
        local ls = light.status
        local horizontalAttitude = IsHorizontalAttitude(li.GetRotation(), Vector3.up, settings.standLightHorizontalAttitudeThreshold)
        if horizontalAttitude then
            if not ls.active then
                -- 復活した
                cytanb.LogTrace('change [', lightName, '] state to active')
                ls.active = true
            end
        else
            local now = vci.me.Time
            if ls.active then
                -- 倒れたことを検知した
                cytanb.TraceLog('change [', lightName, '] state to inactive')
                ls.active = false
                ls.inactiveTime = now
                if now <= ls.readyInactiveTime + settings.requestIntervalTime then
                    cytanb.TraceLog('  call HitStandLight: ', lightName, ', directHit = ', ls.directHit, ' @OnUpdateStandLight')
                    HitStandLight(light)
                end
            elseif li.IsMine then
                if not ls.buildFlag then
                    -- リスポーンしてから一定時間内に倒れたか、倒れてから時間経過した場合は、復活させる。
                    ls.buildFlag = (now >= ls.respawnTime + settings.standLightMinRebuildTime and now <= ls.respawnTime + settings.standLightMaxRebuildTime) or
                                        (now > ls.inactiveTime + settings.standLightWaitingTime)
                end

                if ls.buildFlag then
                    needBuilding = true
                    targets[light.index] = { name = lightName }
                end
            end
        end
    end

    local unow = vci.me.UnscaledTime
    if unow > standLightsLastRequestTime + settings.requestIntervalTime then
        standLightsLastRequestTime = unow
        if needBuilding then
            cytanb.LogTrace('request buildStandLight')
            cytanb.EmitMessage(buildStandLightMessageName, {targets = targets})
        end
    end
end

local UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        settings.lsp.UpdateAlive()
        settings.statsLsp.UpdateAlive()
        settingsPanelGlue.Update()

        for name, switch in pairs(slideSwitchMap) do
            switch.Update()
        end

        if deltaTime <= TimeSpan.Zero then
            return
        end

        fixedTimestep = timestepEstimater.Update()

        if settingsPanelStatus.gripPressed and vci.me.Time - settings.resetOperationTime > settingsPanelStatus.gripStartTime then
            -- 連続して呼び出されないようにしておく
            settingsPanelStatus.gripStartTime = TimeSpan.MaxValue

            -- 設定パネルのグリップ長押しで、統計情報をリセットする
            ResetStats()
        end
        TreatStatsCache()

        OnUpdateDiscernibleEfk(deltaTime, unscaledDeltaTime)
        OnUpdateImpactGauge(deltaTime, unscaledDeltaTime)
        OnUpdateBall(deltaTime, unscaledDeltaTime)
        OnUpdateStandLight(deltaTime, unscaledDeltaTime)
    end,

    function ()
        cytanb.LogTrace('OnLoad')
        settings.lsp.UpdateAlive()
        settings.statsLsp.UpdateAlive()
        vciLoaded = true

        local uuid = cytanb.UUIDFromString(cytanb.InstanceID())
        hiddenPosition = Vector3.__new(uuid[1] / 0x100000, 0x1000, uuid[2] / 0x100000)
        cytanb.LogTrace('hiddenPosition: ', hiddenPosition)

        timestepEstimater = cytanb.EstimateFixedTimestep(cytanb.NillableValue(vci.assets.GetTransform('timestep-estimater')))
        fixedTimestep = timestepEstimater.Timestep()

        ball = cytanb.NillableValue(vci.assets.GetSubItem(settings.ballName))

        ballEfkContainer = cytanb.NillableValue(vci.assets.GetTransform(settings.ballEfkContainerName))

        local ballEfkMap = cytanb.GetEffekseerEmitterMap(settings.ballEfkContainerName)
        ballEfk = cytanb.NillableValue(ballEfkMap[settings.ballEfkName])
        ballEfkFade = cytanb.NillableValue(ballEfkMap[settings.ballEfkFadeName])
        ballEfkFadeMove = cytanb.NillableValue(ballEfkMap[settings.ballEfkFadeMoveName])
        ballEfkOne = cytanb.NillableValue(ballEfkMap[settings.ballEfkOneName])
        ballEfkOneLarge = cytanb.NillableValue(ballEfkMap[settings.ballEfkOneLargeName])

        ballDiscernibleEfkPlayer = CreateDiscernibleEfkPlayer(
            cytanb.NillableValue(vci.assets.GetEffekseerEmitter(settings.ballName)),
            settings.discernibleEfkMinPeriod
        )

        ballCup = cytanb.NillableValue(vci.assets.GetSubItem(settings.ballCupName))

        currentColorPicker = {
            item = ball,
            status = ballStatus
        }

        colorPickers = {
            [currentColorPicker.item.GetName()] = currentColorPicker
        }

        standLights = {}
        for i = 1, settings.standLightCount do
            local index = i - 1
            local name = settings.standLightPrefix .. index
            local item = cytanb.NillableValue(vci.assets.GetSubItem(name))
            local entry = {
                item = item,
                index = index,
                status = cytanb.Extend(cytanb.Extend({}, standLightInitialStatus), {
                    respawnPosition = item.GetPosition(),
                    respawnTime = vci.me.Time,
                    grabbed = false,
                })
            }
            standLights[name] = entry
            colorPickers[name] = entry
        end

        standLightEfkContainer = cytanb.NillableValue(vci.assets.GetTransform(settings.standLightEfkContainerName))

        local standLightEfkMap = cytanb.GetEffekseerEmitterMap(settings.standLightEfkContainerName)
        standLightHitEfk = cytanb.NillableValue(standLightEfkMap[settings.standLightHitEfkName])
        standLightDirectHitEfk = cytanb.NillableValue(standLightEfkMap[settings.standLightDirectHitEfkName])

        impactForceGauge = cytanb.NillableValue(vci.assets.GetTransform(settings.impactForceGaugeName))
        impactForceGauge.SetPosition(hiddenPosition)

        impactSpinGauge = cytanb.NillableValue(vci.assets.GetTransform(settings.impactSpinGaugeName))
        impactSpinGauge.SetPosition(hiddenPosition)

        settingsPanel = cytanb.NillableValue(vci.assets.GetSubItem(settings.settingsPanelName))
        settingsPanelGlue = cytanb.CreateSubItemGlue()

        closeSwitch = cytanb.NillableValue(vci.assets.GetSubItem(settings.closeSwitchName))
        settingsPanelGlue.Add(cytanb.NillableValue(vci.assets.GetTransform(settings.closeSwitchBaseName)), closeSwitch)

        slideSwitchMap = {}
        for k, parameters in pairs(settings.switchParameters) do
            local switch = cytanb.CreateSlideSwitch(
                cytanb.Extend({
                    colliderItem = cytanb.NillableValue(vci.assets.GetSubItem(parameters.colliderName)),
                    baseItem = cytanb.NillableValue(vci.assets.GetTransform(parameters.baseName)),
                    knobItem = cytanb.NillableValue(vci.assets.GetTransform(parameters.knobName)),
                    lsp = settings.lsp
                }, parameters, false, true)
            )

            if settings.enableDebugging then
                switch.AddListener(function (source, value)
                    cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
                end)
            end

            slideSwitchMap[parameters.colliderName] = switch
        end

        velocitySwitch = cytanb.NillableValue(slideSwitchMap[settings.velocitySwitchName])
        angularVelocitySwitch = cytanb.NillableValue(slideSwitchMap[settings.angularVelocitySwitchName])
        altitudeSwitch = cytanb.NillableValue(slideSwitchMap[settings.altitudeSwitchName])
        throwingAdjustmentSwitch = cytanb.NillableValue(slideSwitchMap[settings.throwingAdjustmentSwitchName])
        gravitySwitch = cytanb.NillableValue(slideSwitchMap[settings.gravitySwitchName])
        efkLevelSwitch = cytanb.NillableValue(slideSwitchMap[settings.efkLevelSwitchName])
        audioVolumeSwitch = cytanb.NillableValue(slideSwitchMap[settings.audioVolumeSwitchName])

        ballStatus.gravityFactor = CalcGravityFactor()

        settings.statsLsp.AddListener(function (source, key, value, oldValue)
            if key == cytanb.LOCAL_SHARED_PROPERTY_EXPIRED_KEY then
                -- cytanb.LogTrace('statsLsp: expired')
                vciLoaded = false
            end
        end)

        local updateStatus = function (parameterMap)
            if parameterMap.discernibleColor then
                SetDiscernibleColor(parameterMap.discernibleColor)
            end

            if parameterMap.standLights then
                for i, lightParameter in pairs(parameterMap.standLights) do
                    cytanb.NillableIfHasValue(standLights[lightParameter.name], function (light)
                        local ls = light.status
                        if lightParameter.respawnPosition then
                            cytanb.Extend(ls, standLightInitialStatus)
                            ls.respawnPosition = lightParameter.respawnPosition
                            ls.respawnTime = vci.me.Time
                        end
                    end)
                end
            end
        end

        -- 全 VCI からのクエリーに応答する。
        -- マスターが交代したときのことを考慮して、全ユーザーが OnMessage で登録する。
        cytanb.OnMessage(queryStatusMessageName, function (sender, name, parameterMap)
            if not vci.assets.IsMine then
                -- マスターでなければリターンする。
                return
            end

            cytanb.LogDebug('onQueryStatus')

            local standLightsParameter = {}
            for lightName, light in pairs(standLights) do
                standLightsParameter[light.index] = CreateStandLightStatusParameter(light)
            end

            cytanb.EmitMessage(statusMessageName, {
                clientID = cytanb.ClientID(),
                discernibleColor = cytanb.ColorToTable(ballDiscernibleEfkPlayer.GetColor()),
                ball = CreateBallStatusParameter(),
                standLights = standLightsParameter
            })
        end)

        cytanb.OnMessage(statusMessageName, function (sender, name, parameterMap)
            if parameterMap[cytanb.InstanceIDParameterName] == cytanb.InstanceID() then
                if parameterMap.clientID ~= cytanb.ClientID() then
                    -- インスタンスの設置者から状態通知が来たので、ローカルの値を更新する
                    cytanb.LogDebug('onStatus @instance')
                    updateStatus(parameterMap)
                end
            else
                -- 他のインスタンスの識別色を収集する
                if vci.assets.IsMine and not discernibleColorStatus.initialized and vci.me.UnscaledTime <= discernibleColorStatus.checkRequestedTime + settings.requestIntervalTime then
                    if parameterMap.discernibleColor and parameterMap.discernibleColor.a > 0.0 then
                        local colorIndex = cytanb.ColorToIndex(parameterMap.discernibleColor)
                        cytanb.LogDebug('onStatus @other: colorIndex = ', colorIndex, ', discernibleColor = ', parameterMap.discernibleColor)
                        discernibleColorStatus.existentIndexTable[colorIndex] = true
                    end
                end
            end
        end)

        cytanb.OnInstanceMessage(statusChangedMessageName, function (sender, name, parameterMap)
            if parameterMap.clientID ~= cytanb.ClientID() then
                cytanb.LogDebug('onStatusChanged')
                updateStatus(parameterMap)
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
                for i, lightParameter in pairs(targets) do
                    cytanb.NillableIfHasValue(standLights[lightParameter.name], function (light)
                        BuildStandLight(light)
                    end)
                end
            end
        end)

        -- 全てのライトを組み立てる。別 VCI から送られてくるケースも考慮する。
        cytanb.OnMessage(buildAllStandLightsMessageName, function (sender, name, parameterMap)
            for lightName, light in pairs(standLights) do
                BuildStandLight(light)
            end
        end)

        -- ターゲットにヒットした。別 VCI から送られてくるケースも考慮する。
        cytanb.OnMessage(hitMessageName, function (sender, name, parameterMap)
            local source = parameterMap.source
            if not source.position then
                return
            end

            cytanb.NillableIfHasValue(standLights[parameterMap.target.name], function (light)
                local li = light.item
                local ls = light.status
                local now = vci.me.Time
                if IsContactWithTarget(source.position, source.longSide or 0.5, li.GetPosition(), settings.standLightSimLongSide) and now > ls.hitMessageTime + settings.requestIntervalTime then
                    -- 自 VCI のターゲットにヒットした
                    cytanb.LogTrace('onHitMessage: ', li.GetName())
                    ls.hitMessageTime = now
                    ls.hitSourceID = source.hitSourceID
                    ls.directHit = parameterMap.directHit

                    if ls.active then
                        -- ライトが倒れていないので、レディ状態をセットする
                        cytanb.LogTrace('ready inactive: ', li.GetName(), ', directHit = ', ls.directHit)
                        ls.readyInactiveTime = now

                        if li.IsMine and not ls.grabbed and parameterMap.hitSourceID ~= cytanb.ClientID() then
                            -- ライトの操作権があり、メッセージのクライアントIDが自身のIDと異なる場合は、ソースの操作権が別ユーザーであるため、自力で倒れる
                            local hitVelocity
                            local sourceVelocity = source.velocity or Vector3.zero
                            local horzSqrMagnitude = sourceVelocity.x ^ 2 + sourceVelocity.y ^ 2
                            cytanb.LogTrace(' horzSqrMagnitude = ', horzSqrMagnitude, ', source.velocity = ', source.velocity)
                            if horzSqrMagnitude > 0.0025 then
                                local horzMagnitude = math.sqrt(horzSqrMagnitude)
                                local im = cytanb.Clamp(horzMagnitude, settings.standLightMinHitMagnitude, settings.standLightMaxHitMagnitude) / horzMagnitude
                                hitVelocity = Vector3.__new(sourceVelocity.x * im, cytanb.Clamp(sourceVelocity.y, settings.standLightMinHitMagnitudeY, settings.standLightMaxHitMagnitudeY), sourceVelocity.z * im)
                                cytanb.LogTrace(li.GetName(), ' self-hit: source, hit velocity = ', hitVelocity)
                            else
                                local rx = math.random()
                                local dx = (rx * 2 >= 1 and 1 or -1) * (rx * (settings.standLightMaxHitMagnitude - settings.standLightMinHitMagnitude) * 0.5 + settings.standLightMinHitMagnitude)
                                local rz = math.random()
                                local dz = (rz * 2 >= 1 and 1 or -1) * (rz * (settings.standLightMaxHitMagnitude - settings.standLightMinHitMagnitude) * 0.5 + settings.standLightMinHitMagnitude)
                                local dy = math.random() * (settings.standLightMaxHitMagnitudeY - settings.standLightMinHitMagnitudeY) + settings.standLightMinHitMagnitudeY
                                hitVelocity = Vector3.__new(dx, dy, dz)
                                cytanb.LogTrace(li.GetName(), ' self-hit: random, hit velocity = ', hitVelocity)
                            end

                            local sourceMass = source.mass > 0 and math.min(settings.standLightSimMass * settings.standLightMaxHitMassFactor, source.mass) or settings.standLightSimMass
                            li.AddForce(hitVelocity * (sourceMass / fixedTimestep.TotalSeconds))
                        end
                    else
                        HitStandLight(light)
                    end
                end
            end)
        end)

        cytanb.OnInstanceMessage(throwingStatsMessageName, function (sender, name, parameterMap)
            cytanb.NillableIfHasValue(parameterMap.stats, function (stats)
                print(StatsToString(stats))
            end)
        end)

        -- 設定パネルを表示する
        cytanb.OnInstanceMessage(showSettingsPanelMessageName, function (sender, name, parameterMap)
            if not settingsPanel.IsMine then
                return
            end

            local cupPosition = ballCup.GetPosition()
            local dp = cupPosition - settingsPanel.GetPosition()
            if dp.magnitude > settings.settingsPanelDistanceThreshold then
                -- 設定パネルが離れていた場合は、近づけて表示する。
                local position = cupPosition + settings.settingsPanelOffset
                cytanb.LogTrace('ShowSettingsPanel: posotion = ', position)
                settingsPanel.SetPosition(position)
                settingsPanel.SetRotation(Quaternion.LookRotation(Vector3.__new(- settings.settingsPanelOffset.x, 0, - settings.settingsPanelOffset.z)))
            elseif Vector3.Angle(settingsPanel.GetForward(), dp) > settings.settingsPanelAngleThreshold then
                -- 設定パネルが近い位置にあり、角度に開きがある場合は、回転させる。
                cytanb.LogTrace('ShowSettingsPanel: rotate')
                settingsPanel.SetRotation(Quaternion.LookRotation(Vector3.__new(dp.x, 0, dp.z)))
            end
        end)

        cytanb.OnMessage(colorPaletteItemStatusMessageName, function (sender, name, parameterMap)
            if currentColorPicker.item.IsMine and discernibleColorStatus.paletteCollisionCount >= 1 then
                if currentColorPicker.status.grabbed and vci.me.UnscaledTime <= discernibleColorStatus.paletteCollisionTime + settings.requestIntervalTime then
                    discernibleColorStatus.paletteCollisionCount = discernibleColorStatus.paletteCollisionCount - 1
                    SetDiscernibleColor(cytanb.ColorFromARGB32(parameterMap.argb32))
                    cytanb.EmitMessage(statusChangedMessageName, CreateDiscernibleColorParameter())
                else
                    discernibleColorStatus.paletteCollisionCount = 0
                end
            end
        end)

        if vci.assets.IsMine then
            cytanb.EmitMessage(showSettingsPanelMessageName)
            discernibleColorStatus.checkRequestedTime = vci.me.UnscaledTime
        end
        cytanb.EmitMessage(queryStatusMessageName)
    end
)

updateAll = function ()
    UpdateCw()
end

onGrab = function (target)
    if not vciLoaded then
        return
    end

    if target == ballCup.GetName() then
        ballCupStatus.grabbed = true
        ballStatus.gravityFactor = CalcGravityFactor()
        ballCupStatus.grabClickCount, ballCupStatus.grabClickTime = cytanb.DetectClicks(ballCupStatus.grabClickCount, ballCupStatus.grabClickTime)
        if ballCupStatus.grabClickCount == 2 then
            cytanb.EmitMessage(respawnBallMessageName)
        elseif ballCupStatus.grabClickCount == 3 then
            cytanb.EmitMessage(buildAllStandLightsMessageName)
        elseif ballCupStatus.grabClickCount == 4 then
            cytanb.EmitMessage(showSettingsPanelMessageName)
        end
    elseif target == ball.GetName() then
        ballStatus.grabbed = true
        ball.SetVelocity(Vector3.zero)
        ball.SetAngularVelocity(Vector3.zero)
        ResetGauge()
        ballStatus.transformQueue.Clear()
        ballDiscernibleEfkPlayer.Stop()
    elseif target == settingsPanel.GetName() then
        settingsPanelStatus.grabbed = true
    else
        cytanb.NillableIfHasValue(standLights[target], function (light)
            light.status.grabbed = true
        end)

        cytanb.NillableIfHasValue(slideSwitchMap[target], function (switch)
            switch.DoGrab()
        end)
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    if target == ballCup.GetName() then
        ballCupStatus.grabbed = false
        ResetBallCup()
    elseif target == ball.GetName() then
        if ballStatus.grabbed then
            ballStatus.grabbed = false
            if ball.IsMine then
                if impactStatus.phase == 3 then
                    -- タイミング入力の最終フェーズのときに、ボールを離した場合は、タイミング入力による投球を行う。
                    ThrowBallByInputTiming()
                else
                    -- それ以外の場合は、腕を振って投球する。タイミング入力の途中のフェーズで手を離した場合は、キャンセルしたとみなす。
                    ThrowBallByKinematic()
                end
                ballStatus.boundCount = 0
            end
            impactStatus.gaugeStartTime = vci.me.Time
        end
    elseif target == settingsPanel.GetName() then
        settingsPanelStatus.grabbed = false
    else
        cytanb.NillableIfHasValue(standLights[target], function (light)
            cytanb.LogTrace('ungrab ', target)
            local li = light.item
            local ls = light.status

            cytanb.Extend(ls, standLightInitialStatus)
            ls.respawnTime = vci.me.Time
            ls.grabbed = false

            if li.IsMine then
                -- リスポーン位置を送信する
                local pos = li.GetPosition()
                local ry = settings.standLightSimLongSide * 0.5 + math.random(settings.standLightSimLongSide * 1.5)
                ls.respawnPosition = pos.y >= ry and pos or Vector3.__new(pos.x, ry, pos.z)

                cytanb.LogTrace('emit StatusChanged: ', li.GetName(), ': respawnPosition = ', ls.respawnPosition)
                cytanb.EmitMessage(statusChangedMessageName, {
                    clientID = cytanb.ClientID(),
                    standLights = {
                        [light.index] = {
                            name = li.GetName(),
                            respawnPosition = cytanb.Vector3ToTable(ls.respawnPosition)
                        }
                    }
                })
            end
        end)

        cytanb.NillableIfHasValue(slideSwitchMap[target], function (switch)
            switch.DoUngrab()
        end)
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == ball.GetName() then
        ballStatus.gripPressed = true
        ballStatus.gripStartTime = vci.me.Time
        if ballStatus.grabbed and impactStatus.phase >= 1 and impactStatus.phase < 3 then
            -- タイミング入力のフェーズを進行する。
            impactStatus.phase = impactStatus.phase + 1
            impactStatus.gaugeStartTime = vci.me.Time
        end
    elseif use == ballCup.GetName() then
        ballCupStatus.clickCount, ballCupStatus.clickTime = cytanb.DetectClicks(ballCupStatus.clickCount, ballCupStatus.clickTime)
        cytanb.LogTrace('cupClickCount = ', ballCupStatus.clickCount)

        if ballCupStatus.clickCount == 1 then
            cytanb.EmitMessage(respawnBallMessageName)
        elseif ballCupStatus.clickCount == 2 then
            cytanb.EmitMessage(buildAllStandLightsMessageName)
        elseif ballCupStatus.clickCount == 3 then
            cytanb.EmitMessage(showSettingsPanelMessageName)
        end
    elseif use == closeSwitch.GetName() then
        if not settingsPanelStatus.grabbed and settingsPanel.IsMine then
            settingsPanel.SetPosition(hiddenPosition)
        end
    elseif use == settingsPanel.GetName() then
        settingsPanelStatus.gripPressed = true
        settingsPanelStatus.gripStartTime = vci.me.Time
    else
        cytanb.NillableIfHasValue(slideSwitchMap[use], function (switch)
            switch.DoUse()
        end)
    end
end

onUnuse = function (use)
    if not vciLoaded then
        return
    end

    if use == ball.GetName() then
        ballStatus.gripPressed = false
    elseif use == settingsPanel.GetName() then
        settingsPanelStatus.gripPressed = false
    else
        cytanb.NillableIfHasValue(slideSwitchMap[use], function (switch)
            switch.DoUnuse()
        end)
    end
end

local OnCollisionOrTriggerEnter = function (item, hit, collision)
    if item == ball.GetName() then
        if ball.IsMine and not ballStatus.grabbed then
            local tagMap, hitBaseName = cytanb.ParseTagString(hit)
            if cytanb.NillableHasValue(tagMap[settings.targetTag]) then
                EmitHitBall(hit, hitBaseName)
            elseif collision and not avatarColliderMap[hit] then
                -- ライトかアバターのコライダー以外に衝突した場合は、カウントアップする
                ballStatus.boundCount = ballStatus.boundCount + 1
                cytanb.LogTrace('ball bounds: hit = ', hit, ', boundCount = ', ballStatus.boundCount)
                if ballStatus.boundCount == 1 then
                    local hpos = ball.GetPosition()
                    hpos.y = statsCache.throwingPosition.y
                    cytanb.LogTrace('ball bounds: horizontal distance = ', cytanb.Round(Vector3.Distance(hpos, statsCache.throwingPosition), 2), ' [m]')
                end
            end
        end
    else
        cytanb.NillableIfHasValue(standLights[item], function (light)
            if light.item.IsMine and not light.status.grabbed then
                if cytanb.NillableHasValue(cytanb.ParseTagString(hit)[settings.targetTag]) then
                    EmitHitStandLight(light, hit)
                end
            end
        end)
    end

    cytanb.NillableIfHasValue(colorPickers[item], function (picker)
        if picker.item.IsMine and string.startsWith(hit, settings.colorIndexNamePrefix) then
            local now = vci.me.UnscaledTime
            if discernibleColorStatus.paletteCollisionCount >= 1 and now > discernibleColorStatus.paletteCollisionTime + settings.requestIntervalTime then
                -- 期限が切れていた場合は、カウンターをリセットする。
                discernibleColorStatus.paletteCollisionCount = 0
            end
            discernibleColorStatus.paletteCollisionCount = discernibleColorStatus.paletteCollisionCount + 1
            discernibleColorStatus.paletteCollisionTime = now
            currentColorPicker = picker
            cytanb.TraceLog('colorPaletteCollisionCount = ', discernibleColorStatus.paletteCollisionCount, ' hit = ', hit)
        end
    end)
end

onCollisionEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    OnCollisionOrTriggerEnter(item, hit, true)
end

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    OnCollisionOrTriggerEnter(item, hit, false)
end
