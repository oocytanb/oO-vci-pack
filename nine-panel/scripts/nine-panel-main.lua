-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(af)return af~=nil end,NillableValue=function(af)if af==nil then error('nillable: value is nil',2)end;return af end,NillableValueOrDefault=function(af,ag)if af==nil then if ag==nil then error('nillable: defaultValue is nil',2)end;return ag else return af end end,NillableIfHasValue=function(af,ah)if af==nil then return nil else return ah(af)end end,NillableIfHasValueOrElse=function(af,ah,ai)if af==nil then return ai()else return ah(af)end end,SetConst=function(aj,ak,q)if type(aj)~='table'then error('Cannot set const to non-table target',2)end;local al=getmetatable(aj)local A=al or{}local am=rawget(A,x)if rawget(aj,ak)~=nil then error('Non-const field "'..ak..'" already exists',2)end;if not am then am={}rawset(A,x,am)A.__index=y;A.__newindex=D end;rawset(am,ak,q)if not al then setmetatable(aj,A)end;return aj end,SetConstEach=function(aj,an)for N,E in pairs(an)do a.SetConst(aj,N,E)end;return aj end,Extend=function(aj,ao,ap,aq,a3)if aj==ao or type(aj)~='table'or type(ao)~='table'then return aj end;if ap then if not a3 then a3={}end;if a3[ao]then error('circular reference')end;a3[ao]=true end;for N,E in pairs(ao)do if ap and type(E)=='table'then local ar=aj[N]aj[N]=a.Extend(type(ar)=='table'and ar or{},E,ap,aq,a3)else aj[N]=E end end;if not aq then local as=getmetatable(ao)if type(as)=='table'then if ap then local at=getmetatable(aj)setmetatable(aj,a.Extend(type(at)=='table'and at or{},as,true))else setmetatable(aj,as)end end end;if ap then a3[ao]=nil end;return aj end,Vars=function(E,au,av,a3)local aw;if au then aw=au~='__NOLF'else au='  'aw=true end;if not av then av=''end;if not a3 then a3={}end;local ax=type(E)if ax=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local ay=aw and av..au or''local P='('..tostring(E)..') {'local az=true;for z,aA in pairs(E)do if az then az=false else P=P..(aw and','or', ')end;if aw then P=P..'\n'..ay end;if type(aA)=='table'and a3[aA]and a3[aA]>0 then P=P..z..' = ('..tostring(aA)..')'else P=P..z..' = '..a.Vars(aA,au,ay,a3)end end;if not az and aw then P=P..'\n'..av end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif ax=='function'or ax=='thread'or ax=='userdata'then return'('..ax..')'elseif ax=='string'then return'('..ax..') '..string.format('%q',E)else return'('..ax..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aB)f=aB end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aC)g=not not aC end,Log=function(aB,...)if aB<=f then local aD=g and(h[aB]or'LOG LEVEL '..tostring(aB))..' | 'or''local aE=table.pack(...)if aE.n==1 then local E=aE[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aD..P or P)else print(aD)end else local P=aD;for n=1,aE.n do local E=aE[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aF,aG)local aH={}if aG==nil then for N,E in pairs(aF)do aH[E]=E end elseif type(aG)=='function'then for N,E in pairs(aF)do local aI,aJ=aG(E)aH[aI]=aJ end else for N,E in pairs(aF)do aH[E]=aG end end;return aH end,Round=function(aK,aL)if aL then local aM=10^aL;return math.floor(aK*aM+0.5)/aM else return math.floor(aK+0.5)end end,Clamp=function(q,aN,aO)return math.max(aN,math.min(q,aO))end,Lerp=function(aP,aQ,ax)if ax<=0.0 then return aP elseif ax>=1.0 then return aQ else return aP+(aQ-aP)*ax end end,LerpUnclamped=function(aP,aQ,ax)if ax==0.0 then return aP elseif ax==1.0 then return aQ else return aP+(aQ-aP)*ax end end,PingPong=function(ax,aR)if aR==0 then return 0,1 end;local aS=math.floor(ax/aR)local aT=ax-aS*aR;if aS<0 then if(aS+1)%2==0 then return aR-aT,-1 else return aT,1 end else if aS%2==0 then return aT,1 else return aR-aT,-1 end end end,VectorApproximatelyEquals=function(aU,aV)return(aU-aV).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aU,aV)local aW=Quaternion.Dot(aU,aV)return aW<1.0+1E-06 and aW>1.0-1E-06 end,
QuaternionToAngleAxis=function(aX)local aS=aX.normalized;local aY=math.acos(aS.w)local aZ=math.sin(aY)local a_=math.deg(aY*2.0)local b0;if math.abs(aZ)<=Quaternion.kEpsilon then b0=Vector3.right else local b1=1.0/aZ;b0=Vector3.__new(aS.x*b1,aS.y*b1,aS.z*b1)end;return a_,b0 end,QuaternionTwist=function(aX,b2)if b2.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local b3=Vector3.__new(aX.x,aX.y,aX.z)if b3.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b4=Vector3.Project(b3,b2)if b4.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b5=Quaternion.__new(b4.x,b4.y,b4.z,aX.w)b5.Normalize()return b5 else return Quaternion.AngleAxis(0,b2)end else local b6=a.QuaternionToAngleAxis(aX)return Quaternion.AngleAxis(b6,b2)end end,ApplyQuaternionToVector3=function(aX,b7)local b8=aX.w*b7.x+aX.y*b7.z-aX.z*b7.y;local b9=aX.w*b7.y-aX.x*b7.z+aX.z*b7.x;local ba=aX.w*b7.z+aX.x*b7.y-aX.y*b7.x;local bb=-aX.x*b7.x-aX.y*b7.y-aX.z*b7.z;return Vector3.__new(bb*-aX.x+b8*aX.w+b9*-aX.z-ba*-aX.y,bb*-aX.y-b8*-aX.z+b9*aX.w+ba*-aX.x,bb*-aX.z+b8*-aX.y-b9*-aX.x+ba*aX.w)end,RotateAround=function(bc,bd,be,bf)return be+bf*(bc-be),bf*bd end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bg)return p.__tostring(bg)end,UUIDFromNumbers=function(...)local bh=...local ax=type(bh)local bi,bj,bk,bl;if ax=='table'then bi=bh[1]bj=bh[2]bk=bh[3]bl=bh[4]else bi,bj,bk,bl=...end;local bg={bit32.band(bi or 0,0xFFFFFFFF),bit32.band(bj or 0,0xFFFFFFFF),bit32.band(bk or 0,0xFFFFFFFF),bit32.band(bl or 0,0xFFFFFFFF)}setmetatable(bg,p)return bg end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bm='[0-9a-f-A-F]+'local bn='^('..bm..')$'local bo='^-('..bm..')$'local bp,bq,br,bs;if S==32 then local bg=a.UUIDFromNumbers(0,0,0,0)local bt=1;for n,bu in ipairs({8,16,24,32})do bp,bq,br=string.find(string.sub(P,bt,bu),bn)if not bp then return nil end;bg[n]=tonumber(br,16)bt=bu+1 end;return bg else bp,bq,br=string.find(string.sub(P,1,8),bn)if not bp then return nil end;local bi=tonumber(br,16)bp,bq,br=string.find(string.sub(P,9,13),bo)if not bp then return nil end;bp,bq,bs=string.find(string.sub(P,14,18),bo)if not bp then return nil end;local bj=tonumber(br..bs,16)bp,bq,br=string.find(string.sub(P,19,23),bo)if not bp then return nil end;bp,bq,bs=string.find(string.sub(P,24,28),bo)if not bp then return nil end;local bk=tonumber(br..bs,16)bp,bq,br=string.find(string.sub(P,29,36),bn)if not bp then return nil end;local bl=tonumber(br,16)return a.UUIDFromNumbers(bi,bj,bk,bl)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bv)if type(bv)~='number'or bv<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bv),2)end;local self;local bw=math.floor(bv)local U={}local bx=0;local by=0;local bz=0;self={Size=function()return bz end,Clear=function()bx=0;by=0;bz=0 end,IsEmpty=function()return bz==0 end,Offer=function(bA)U[bx+1]=bA;bx=(bx+1)%bw;if bz<bw then bz=bz+1 else by=(by+1)%bw end;return true end,OfferFirst=function(bA)by=(bw+by-1)%bw;U[by+1]=bA;if bz<bw then bz=bz+1 else bx=(bw+bx-1)%bw end;return true end,Poll=function()if bz==0 then return nil else local bA=U[by+1]by=(by+1)%bw;bz=bz-1;return bA end end,PollLast=function()if bz==0 then return nil else bx=(bw+bx-1)%bw;local bA=U[bx+1]bz=bz-1;return bA end end,Peek=function()if bz==0 then return nil else return U[by+1]end end,PeekLast=function()if bz==0 then return nil else return U[(bw+bx-1)%bw+1]end end,Get=function(bB)if bB<1 or bB>bz then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bB)return nil end;return U[(by+bB-1)%bw+1]end,IsFull=function()return bz>=bw end,MaxSize=function()return bw end}return self end,DetectClicks=function(bC,bD,bE)local bF=bC or 0;local bG=bE or TimeSpan.FromMilliseconds(500)local bH=vci.me.Time;local bI=bD and bH>bD+bG and 1 or bF+1;return bI,bH end,ColorRGBToHSV=function(bJ)local aT=math.max(0.0,math.min(bJ.r,1.0))local bK=math.max(0.0,math.min(bJ.g,1.0))local aQ=math.max(0.0,math.min(bJ.b,1.0))local aO=math.max(aT,bK,aQ)local aN=math.min(aT,bK,aQ)local bL=aO-aN;local C;if bL==0.0 then C=0.0 elseif aO==aT then C=(bK-aQ)/bL/6.0 elseif aO==bK then C=(2.0+(aQ-aT)/bL)/6.0 else C=(4.0+(aT-bK)/bL)/6.0 end;if C<0.0 then C=C+1.0 end;local bM=aO==0.0 and bL or bL/aO;local E=aO;return C,bM,E end,ColorFromARGB32=function(bN)local bO=type(bN)=='number'and bN or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bO,16),0xFF)/0xFF,bit32.band(bit32.rshift(bO,8),0xFF)/0xFF,bit32.band(bO,0xFF)/0xFF,bit32.band(bit32.rshift(bO,24),0xFF)/0xFF)end,ColorToARGB32=function(bJ)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bJ.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bJ.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bJ.g),0xFF),8),bit32.band(a.Round(0xFF*bJ.b),0xFF))end,ColorFromIndex=function(bP,bQ,bR,bS,bT)local bU=math.max(math.floor(bQ or a.ColorHueSamples),1)local bV=bT and bU or bU-1;local bW=math.max(math.floor(bR or a.ColorSaturationSamples),1)local bX=math.max(math.floor(bS or a.ColorBrightnessSamples),1)local bB=a.Clamp(math.floor(bP or 0),0,bU*bW*bX-1)local bY=bB%bU;local bZ=math.floor(bB/bU)local b1=bZ%bW;local b_=math.floor(bZ/bW)if bT or bY~=bV then local C=bY/bV;local bM=(bW-b1)/bW;local E=(bX-b_)/bX;return Color.HSVToRGB(C,bM,E)else local E=(bX-b_)/bX*b1/(bW-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bJ,bQ,bR,bS,bT)local bU=math.max(math.floor(bQ or a.ColorHueSamples),1)local bV=bT and bU or bU-1;local bW=math.max(math.floor(bR or a.ColorSaturationSamples),1)local bX=math.max(math.floor(bS or a.ColorBrightnessSamples),1)local C,bM,E=a.ColorRGBToHSV(bJ)local b1=a.Round(bW*(1.0-bM))if bT or b1<bW then local c0=a.Round(bV*C)if c0>=bV then c0=0 end;if b1>=bW then b1=bW-1 end;local b_=math.min(bX-1,a.Round(bX*(1.0-E)))return c0+bU*(b1+bW*b_)else local c1=a.Round((bW-1)*E)if c1==0 then local c2=a.Round(bX*(1.0-E))if c2>=bX then return bU-1 else return bU*(1+a.Round(E*(bW-1)/(bX-c2)*bX)+bW*c2)-1 end else return bU*(1+c1+bW*a.Round(bX*(1.0-E*(bW-1)/c1)))-1 end end end,ColorToTable=function(bJ)return{[a.TypeParameterName]=a.ColorTypeName,r=bJ.r,g=bJ.g,b=bJ.b,a=bJ.a}end,ColorFromTable=function(G)local aQ,M=F(G,a.ColorTypeName)return aQ and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local aQ,M=F(G,a.Vector2TypeName)return aQ and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local aQ,M=F(G,a.Vector3TypeName)return aQ and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local aQ,M=F(G,a.Vector4TypeName)return aQ and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local aQ,M=F(G,a.QuaternionTypeName)return aQ and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ak,c3)local a4=a.NillableIfHasValueOrElse(c3,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ak,json.serialize(a4))end,OnMessage=function(ak,ah)local c4=function(c5,c6,c7)local c8=nil;if c5.type~='comment'and type(c7)=='string'then local c9,a4=pcall(json.parse,c7)if c9 and type(a4)=='table'then c8=a.TableFromSerializable(a4)end end;local c3=c8 and c8 or{[a.MessageValueParameterName]=c7}ah(c5,c6,c3)end;vci.message.On(ak,c4)return{Off=function()if c4 then c4=nil end end}end,OnInstanceMessage=function(ak,ah)local c4=function(c5,c6,c3)local ca=a.InstanceID()if ca~=''and ca==c3[a.InstanceIDParameterName]then ah(c5,c6,c3)end end;return a.OnMessage(ak,c4)end,
GetEffekseerEmitterMap=function(ak)local cb=vci.assets.GetEffekseerEmitters(ak)if not cb then return nil end;local aH={}for n,cc in pairs(cb)do aH[cc.EffectName]=cc end;return aH end,ClientID=function()return j end,CreateLocalSharedProperties=function(cd,ce)local cf=TimeSpan.FromSeconds(5)local cg='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local ch='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(cd)~='string'or string.len(cd)<=0 or type(ce)~='string'or string.len(ce)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local ci=_G[cg]if not ci then ci={}_G[cg]=ci end;ci[ce]=vci.me.UnscaledTime;local cj=_G[cd]if not cj then cj={[ch]={}}_G[cd]=cj end;local ck=cj[ch]local self;self={GetLspID=function()return cd end,GetLoadID=function()return ce end,GetProperty=function(z,ag)local q=cj[z]if q==nil then return ag else return q end end,SetProperty=function(z,q)if z==ch then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bH=vci.me.UnscaledTime;local cl=cj[z]cj[z]=q;for cm,ca in pairs(ck)do local ax=ci[ca]if ax and ax+cf>=bH then cm(self,z,q,cl)else cm(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)ck[cm]=nil;ci[ca]=nil end end end,AddListener=function(cm)ck[cm]=ce end,RemoveListener=function(cm)ck[cm]=nil end,UpdateAlive=function()ci[ce]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(cn)local co=1.0;local cp=1000.0;local cq=TimeSpan.FromSeconds(0.02)local cr=0xFFFF;local cs=a.CreateCircularQueue(64)local ct=TimeSpan.FromSeconds(5)local cu=TimeSpan.FromSeconds(30)local cv=false;local cw=vci.me.Time;local cx=a.Random32()local cy=Vector3.__new(bit32.bor(0x400,bit32.band(cx,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cx,16),0x1FFF)),0.0)cn.SetPosition(cy)cn.SetRotation(Quaternion.identity)cn.SetVelocity(Vector3.zero)cn.SetAngularVelocity(Vector3.zero)cn.AddForce(Vector3.__new(0.0,0.0,co*cp))local self={Timestep=function()return cq end,Precision=function()return cr end,IsFinished=function()return cv end,Update=function()if cv then return cq end;local cz=vci.me.Time-cw;local cA=cz.TotalSeconds;if cA<=Vector3.kEpsilon then return cq end;local cB=cn.GetPosition().z-cy.z;local cC=cB/cA;local cD=cC/cp;if cD<=Vector3.kEpsilon then return cq end;cs.Offer(cD)local cE=cs.Size()if cE>=2 and cz>=ct then local cF=0.0;for n=1,cE do cF=cF+cs.Get(n)end;local cG=cF/cE;local cH=0.0;for n=1,cE do cH=cH+(cs.Get(n)-cG)^2 end;local cI=cH/cE;if cI<cr then cr=cI;cq=TimeSpan.FromSeconds(cG)end;if cz>cu then cv=true;cn.SetPosition(cy)cn.SetRotation(Quaternion.identity)cn.SetVelocity(Vector3.zero)cn.SetAngularVelocity(Vector3.zero)end else cq=TimeSpan.FromSeconds(cD)end;return cq end}return self end,AlignSubItemOrigin=function(cJ,cK,cL)local cM=cJ.GetRotation()if not a.QuaternionApproximatelyEquals(cK.GetRotation(),cM)then cK.SetRotation(cM)end;local cN=cJ.GetPosition()if not a.VectorApproximatelyEquals(cK.GetPosition(),cN)then cK.SetPosition(cN)end;if cL then cK.SetVelocity(Vector3.zero)cK.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local cO={}local self;self={Contains=function(cP,cQ)return a.NillableIfHasValueOrElse(cO[cP],function(an)return a.NillableHasValue(an[cQ])end,function()return false end)end,Add=function(cP,cR,cL)if not cP or not cR then local cS='SubItemGlue.Add: Invalid arguments '..(not cP and', parent = '..tostring(cP)or'')..(not cR and', children = '..tostring(cR)or'')error(cS,2)end;local an=a.NillableIfHasValueOrElse(cO[cP],function(cT)return cT end,function()local cT={}cO[cP]=cT;return cT end)if type(cR)=='table'then for z,aA in pairs(cR)do an[aA]={velocityReset=not not cL}end else an[cR]={velocityReset=not not cL}end end,Remove=function(cP,cQ)return a.NillableIfHasValueOrElse(cO[cP],function(an)if a.NillableHasValue(an[cQ])then an[cQ]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(cP)if a.NillableHasValue(cO[cP])then cO[cP]=nil;return true else return false end end,RemoveAll=function()cO={}return true end,Each=function(ah,cU)return a.NillableIfHasValueOrElse(cU,function(cP)return a.NillableIfHasValue(cO[cP],function(an)for cQ,cV in pairs(an)do if ah(cQ,cP,self)==false then return false end end end)end,function()for cP,an in pairs(cO)do if self.Each(ah,cP)==false then return false end end end)end,Update=function(cW)for cP,an in pairs(cO)do local cX=cP.GetPosition()local cY=cP.GetRotation()for cQ,cV in pairs(an)do if cW or cQ.IsMine then if not a.QuaternionApproximatelyEquals(cQ.GetRotation(),cY)then cQ.SetRotation(cY)end;if not a.VectorApproximatelyEquals(cQ.GetPosition(),cX)then cQ.SetPosition(cX)end;if cV.velocityReset then cQ.SetVelocity(Vector3.zero)cQ.SetAngularVelocity(Vector3.zero)end end end end end}return self end,
CreateSlideSwitch=function(cZ)local c_=a.NillableValue(cZ.colliderItem)local d0=a.NillableValue(cZ.baseItem)local d1=a.NillableValue(cZ.knobItem)local d2=a.NillableValueOrDefault(cZ.minValue,0)local d3=a.NillableValueOrDefault(cZ.maxValue,10)if d2>=d3 then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local d4=(d2+d3)*0.5;local d5=function(aA)local d6,d7=a.PingPong(aA-d2,d3-d2)return d6+d2,d7 end;local q=d5(a.NillableValueOrDefault(cZ.value,0))local d8=a.NillableIfHasValueOrElse(cZ.tickFrequency,function(d9)if d9<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(d9,d3-d2)end,function()return(d3-d2)/10.0 end)local da=a.NillableIfHasValueOrElse(cZ.tickVector,function(b0)return Vector3.__new(b0.x,b0.y,b0.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local db=da.magnitude;if db<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local dc=a.NillableValueOrDefault(cZ.snapToTick,true)local dd=TimeSpan.FromMilliseconds(1000)local de=TimeSpan.FromMilliseconds(50)local df,dg;local ck={}local self;local dh=false;local di=0;local dj=false;local dk=TimeSpan.Zero;local dl=TimeSpan.Zero;local dm=function()local dn=d5(df())if dn~=q then q=dn;for cm,E in pairs(ck)do cm(self,q)end end;d1.SetLocalPosition((dn-d4)/d8*da)end;local dp=function()local dq=df()local dr,ds=d5(dq)local dt=dq+d8;local du,dv=d5(dt)assert(du)local dn;if ds==dv or dr==d3 or dr==d2 then dn=dt else dn=ds>=0 and d3 or d2 end;dl=vci.me.UnscaledTime;if dn==d3 or dn==d2 then dk=dl end;dg(dn)end;a.NillableIfHasValueOrElse(cZ.lsp,function(dw)if not a.NillableHasValue(cZ.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local dx=a.NillableValue(cZ.propertyName)df=function()return dw.GetProperty(dx,q)end;dg=function(aA)dw.SetProperty(dx,aA)end;dw.AddListener(function(ao,z,dy,dz)if z==dx then dm()end end)end,function()local dy=q;df=function()return dy end;dg=function(aA)dy=aA;dm()end end)self={GetColliderItem=function()return c_ end,GetBaseItem=function()return d0 end,GetKnobItem=function()return d1 end,GetMinValue=function()return d2 end,GetMaxValue=function()return d3 end,GetValue=function()return q end,SetValue=function(aA)dg(d5(aA))end,GetTickFrequency=function()return d8 end,IsSnapToTick=function()return dc end,AddListener=function(cm)ck[cm]=cm end,RemoveListener=function(cm)ck[cm]=nil end,DoUse=function()if not dh then dj=true;dk=vci.me.UnscaledTime;dp()end end,DoUnuse=function()dj=false end,DoGrab=function()if not dj then dh=true;di=(q-d4)/d8 end end,DoUngrab=function()dh=false end,Update=function()if dh then local dA=c_.GetPosition()-d0.GetPosition()local dB=d1.GetRotation()*da;local dC=Vector3.Project(dA,dB)local dD=(Vector3.Dot(dB,dC)>=0 and 1 or-1)*dC.magnitude/db+di;local dE=(dc and a.Round(dD)or dD)*d8+d4;local dn=a.Clamp(dE,d2,d3)if dn~=q then dg(dn)end elseif dj then local dF=vci.me.UnscaledTime;if dF>=dk+dd and dF>=dl+de then dp()end elseif c_.IsMine then a.AlignSubItemOrigin(d0,c_)end end}dm()return self end,CreateSubItemConnector=function()local dG=function(dH,cK,dI)dH.item=cK;dH.position=cK.GetPosition()dH.rotation=cK.GetRotation()dH.initialPosition=dH.position;dH.initialRotation=dH.rotation;dH.propagation=not not dI;return dH end;local dJ=function(dK)for cK,dH in pairs(dK)do dG(dH,cK,dH.propagation)end end;local dL=function(dM,bf,dH,dN,dO)local dA=dM-dH.initialPosition;local dP=bf*Quaternion.Inverse(dH.initialRotation)dH.position=dM;dH.rotation=bf;for cK,dQ in pairs(dN)do if cK~=dH.item and(not dO or dO(dQ))then dQ.position,dQ.rotation=a.RotateAround(dQ.initialPosition+dA,dQ.initialRotation,dM,dP)cK.SetPosition(dQ.position)cK.SetRotation(dQ.rotation)end end end;local dR={}local dS=true;local dT=false;local self;self={IsEnabled=function()return dS end,SetEnabled=function(aC)dS=aC;if aC then dJ(dR)dT=false end end,Contains=function(dU)return a.NillableHasValue(dR[dU])end,Add=function(dV,dW)if not dV then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(dV),2)end;local dX=type(dV)=='table'and dV or{dV}dJ(dR)dT=false;for N,cK in pairs(dX)do dR[cK]=dG({},cK,not dW)end end,Remove=function(dU)local aQ=a.NillableHasValue(dR[dU])dR[dU]=nil;return aQ end,RemoveAll=function()dR={}return true end,Each=function(ah)for cK,dH in pairs(dR)do if ah(cK,self)==false then return false end end end,GetItems=function()local dX={}for cK,dH in pairs(dR)do table.insert(dX,cK)end;return dX end,Update=function()if not dS then return end;local dY=false;for cK,dH in pairs(dR)do local dZ=cK.GetPosition()local d_=cK.GetRotation()if not a.VectorApproximatelyEquals(dZ,dH.position)or not a.QuaternionApproximatelyEquals(d_,dH.rotation)then if dH.propagation then if cK.IsMine then dL(dZ,d_,dR[cK],dR,function(dQ)if dQ.item.IsMine then return true else dT=true;return false end end)dY=true;break else dT=true end else dT=true end end end;if not dY and dT then dJ(dR)dT=false end end}return self end,GetSubItemTransform=function(dU)local dM=dU.GetPosition()local bf=dU.GetRotation()local e0=dU.GetLocalScale()return{positionX=dM.x,positionY=dM.y,positionZ=dM.z,rotationX=bf.x,rotationY=bf.y,rotationZ=bf.z,rotationW=bf.w,scaleX=e0.x,scaleY=e0.y,scaleZ=e0.z}end,RestoreCytanbTransform=function(e1)local dZ=e1.positionX and e1.positionY and e1.positionZ and Vector3.__new(e1.positionX,e1.positionY,e1.positionZ)or nil;local d_=e1.rotationX and e1.rotationY and e1.rotationZ and e1.rotationW and Quaternion.__new(e1.rotationX,e1.rotationY,e1.rotationZ,e1.rotationW)or nil;local e0=e1.scaleX and e1.scaleY and e1.scaleZ and Vector3.__new(e1.scaleX,e1.scaleY,e1.scaleZ)or nil;return dZ,d_,e0 end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local cd='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local cj=_G[cd]if not cj then cj={}_G[cd]=cj end;local e2=cj.randomSeedValue;if not e2 then e2=os.time()-os.clock()*10000;cj.randomSeedValue=e2;math.randomseed(e2)end;local e3=cj.clientID;if type(e3)~='string'then e3=tostring(a.RandomUUID())cj.clientID=e3 end;local e4=vci.state.Get(b)or''if e4==''and vci.assets.IsMine then e4=tostring(a.RandomUUID())vci.state.Set(b,e4)end;return e4,e3 end)()return a end)()

local settings = (function ()
    local cballSettingsLspid = 'ae00bdfc-98ec-4fbf-84a6-1a52823cfe69'
    local ignoreTag = '#cytanb-ignore'

    return {
        enableDebugging = false,
        lsp = cytanb.CreateLocalSharedProperties(cballSettingsLspid, tostring(cytanb.RandomUUID())),
        throwableTag = '#cytanb-throwable',
        ballTag = '#cytanb-ball',
        ignoreTag = ignoreTag,
        panelCount = 9,
        panelBaseName = 'nine-panel-base' .. ignoreTag,
        panelControllerName = 'panel-controller',
        panelTiltName = 'frame-tilt',
        initialPanelTiltAngle = -90,
        panelPosPrefix = 'panel-pos#',
        panelMeshPrefix = 'panel-mesh#',
        panelColliderPrefix = 'panel-collider#cytanb-target#',
        panelSimLongSide = 0.5,
        breakEfkContainerName = 'break-efk',
        breakPanelAudioName = 'break-se',
        tickVector = Vector3.__new(0.0, 0.0111, 0.0),
        audioVolumePropertyName = 'audioVolume',
        audioVolumeSwitchName = 'volume-switch',
        audioVolumeKnobName = 'volume-knob',
        audioVolumeKnobPos = 'volume-knob-pos',
        audioVolumeMinValue = 0,
        audioVolumeMaxValue = 100,
        tiltSwitchName = 'tilt-switch',
        tiltKnobName = 'tilt-knob',
        tiltKnobPos = 'tilt-knob-pos',
        tiltMinValue = -90,
        tiltMaxValue = 90,
        resetSwitchName = 'reset-switch',
        resetSwitchMesh = 'reset-switch-mesh',
        avatarColliders = {'Head', 'Chest', 'Hips', 'RightArm', 'LeftArm', 'RightHand', 'LeftHand', 'RightThigh', 'LeftThigh', 'RightFoot', 'LeftFoot', 'RightToes', 'LeftToes'},
        envColliders = {'HandPointMarker', 'NameBoard(Clone)', 'RailButton', 'Controller (right)', 'Controller (left)', 'TransparentPlane'},
        limitHitSource = false,
        grabClickTiming = TimeSpan.FromMilliseconds(1000),
        minRequestIntervalTime = TimeSpan.FromMilliseconds(200),
        maxRequestIntervalTime = TimeSpan.FromMilliseconds(3000),
        panelMendIntervalTime = TimeSpan.FromSeconds(2),
        autoResetWaitingTime = TimeSpan.FromSeconds(60)
    }
end)()

local panelNS = 'com.github.oocytanb.oO-vci-pack.nine-panel'
local statusMessageName = panelNS .. '.status'
local queryStatusMessageName = panelNS .. '.query-status'
local resetMessageName = panelNS .. '.reset'
local breakPanelMessageName = panelNS .. '.break-panel'
local changePanelBaseMessageName = panelNS .. '.change-panel-base'

local vciLoaded = false

local hiddenPosition

local ignoredColliderMap
local panelBase, panelTilt, panelMap
local panelController, panelControllerGlue
local slideSwitchMap, audioVolumeSwitch, tiltSwitch
local resetSwitch

local breakEfkContainer, breakEfk

--- パネルのフレームがつかまれているか
local panelBaseGrabbed = false

--- パネルの傾きが変更されていることを示すフラグ
local panelBaseTiltChanged = false

--- 最後にパネルの傾きを送った時間
local lastPanelBaseTiltSendTime = TimeSpan.Zero

--- 最後にパネルを直した時間。
local lastPanelMendedTime = TimeSpan.Zero

--- リセットスイッチのクリック数。
local resetSwitchClickCount = 0

--- リセットスイッチのクリック時間。
local resetSwitchClickTime = TimeSpan.Zero

-- すべてのパネルがヒットしてゲームが終了した時間。
local gameCompletedTime = TimeSpan.Zero

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local IsHitSource = function (name)
    return (
        not ignoredColliderMap[name] and
        not string.find(name, settings.ignoreTag, 1, true) and (
            not settings.limitHitSource or
            string.find(name, settings.throwableTag, 1, true) or
            string.find(name, settings.ballTag, 1, true)
        )
    ) and true or false
end

local CreatePanelBaseStatusParameter = function ()
    return {
        tiltAngle = tiltSwitch.GetValue()
    }
end

local CreatePanelStatusParameter = function (panel)
    return {
        index = panel.index,
        name = panel.name,
        active = panel.active
    }
end

local ShowPanelMesh = function (panel, show)
    local meshItem = panel.meshItem
    if show then
        meshItem.SetLocalPosition(Vector3.zero)
        meshItem.SetLocalRotation(Quaternion.identity)
    else
        meshItem.SetPosition(hiddenPosition)
    end
end

local BreakPanel = function (panel)
    if not panel.active then
        return false
    end

    cytanb.LogTrace('break-panel: ', panel.name)

    panel.active = false
    panel.inactiveTime = vci.me.UnscaledTime

    cytanb.AlignSubItemOrigin(panel.posItem, breakEfkContainer)
    breakEfk.Play()

    local audioVolume = audioVolumeSwitch.GetValue()
    if audioVolume > 0 then
        vci.assets.audio.Play(settings.breakPanelAudioName, audioVolume / settings.audioVolumeMaxValue, false)
    end

    ShowPanelMesh(panel, false)

    local item = panel.item
    if item.IsMine then
        item.SetPosition(hiddenPosition + panel.posItem.GetLocalPosition())
        item.SetRotation(Quaternion.identity)
        item.SetVelocity(Vector3.zero)
        item.SetAngularVelocity(Vector3.zero)
    end

    return true
end

local MendPanel = function (panel)
    if not panel.active then
        return
    end

    local item = panel.item
    if item.IsMine then
        cytanb.AlignSubItemOrigin(panel.posItem, item, true)
    end
end

local MendAllPanels = function ()
    local alive = false
    for name, panel in pairs(panelMap) do
        if panel.active then
            alive = true
        end
        MendPanel(panel)
    end

    local now = vci.me.UnscaledTime
    lastPanelMendedTime = now

    if panelBase.IsMine and not alive and gameCompletedTime <= TimeSpan.Zero then
        cytanb.LogTrace('Game Completed!!')
        gameCompletedTime = now
    end
end

local NormalizePanelBaseRotation = function ()
    if panelBase.IsMine then
        local baseAngles = panelBase.GetRotation().eulerAngles
        if baseAngles.x ^ 2 + baseAngles.z ^ 2 >= 1E-10 then
            -- cytanb.LogTrace('panel base rotation Y: ', baseAngles.y)
            panelBase.SetRotation(Quaternion.AngleAxis(baseAngles.y, Vector3.up))
        end
    end
end

local SetPanelBaseTilt = function (tiltAngle)
    NormalizePanelBaseRotation()
    panelTilt.SetLocalRotation(Quaternion.AngleAxis(settings.initialPanelTiltAngle + tiltAngle, Vector3.right))
    MendAllPanels()
end

local ResetAll = function ()
    cytanb.LogTrace('ResetAll')

    for name, panel in pairs(panelMap) do
        panel.active = true
        panel.inactiveTime = TimeSpan.Zero

        ShowPanelMesh(panel, true)
        MendPanel(panel)
    end

    lastPanelMendedTime = vci.me.UnscaledTime
    gameCompletedTime = TimeSpan.Zero
end

local EmitResetMessage = function (reason)
    cytanb.EmitMessage(resetMessageName, {
        resetAll = true,
        senderID = cytanb.ClientID(),
        itemOperator = panelBase.IsMine,
        itemLayouter = vci.assets.IsMine,
        reason = reason or ''
    })
end

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    settings.lsp.UpdateAlive()
    vciLoaded = true

    local uuid = cytanb.UUIDFromString(cytanb.InstanceID())
    hiddenPosition = Vector3.__new(uuid[1] / 0x100000, 0x1000, uuid[2] / 0x100000)
    -- cytanb.LogTrace('hiddenPosition: ', hiddenPosition)

    ignoredColliderMap = cytanb.Extend(
        cytanb.ListToMap(settings.avatarColliders, true),
        cytanb.ListToMap(settings.envColliders, true),
        false, false
    )

    panelBase = cytanb.NillableValue(vci.assets.GetSubItem(settings.panelBaseName))
    panelTilt = cytanb.NillableValue(vci.assets.GetSubItem(settings.panelTiltName))

    panelMap = {}

    for i = 1, settings.panelCount do
        local name = settings.panelColliderPrefix .. i

        ignoredColliderMap[name] = true

        local panel = {
            index = i,
            name = name,
            item = cytanb.NillableValue(vci.assets.GetSubItem(name)),
            posItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.panelPosPrefix .. i)),
            meshItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.panelMeshPrefix .. i)),
            active = true,
            inactiveTime = TimeSpan.Zero,
        }

        panelMap[panel.name] = panel
    end

    panelController = cytanb.NillableValue(vci.assets.GetSubItem(settings.panelControllerName))
    panelControllerGlue = cytanb.CreateSubItemGlue()

    slideSwitchMap = {}

    audioVolumeSwitch = cytanb.CreateSlideSwitch({
        colliderItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.audioVolumeSwitchName)),
        knobItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.audioVolumeKnobName)),
        baseItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.audioVolumeKnobPos)),
        tickVector = settings.tickVector,
        minValue = settings.audioVolumeMinValue,
        maxValue = settings.audioVolumeMaxValue,
        lsp = settings.lsp,
        propertyName = settings.audioVolumePropertyName
    })
    audioVolumeSwitch.AddListener(function (source, value)
        cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
    end)
    slideSwitchMap[settings.audioVolumeSwitchName] = audioVolumeSwitch

    tiltSwitch = cytanb.CreateSlideSwitch({
        colliderItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.tiltSwitchName)),
        knobItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.tiltKnobName)),
        baseItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.tiltKnobPos)),
        tickVector = settings.tickVector,
        minValue = settings.tiltMinValue,
        maxValue = settings.tiltMaxValue
    })
    tiltSwitch.AddListener(function (source, value)
        cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
        SetPanelBaseTilt(value)
        panelBaseTiltChanged = true
    end)
    slideSwitchMap[settings.tiltSwitchName] = tiltSwitch

    resetSwitch = cytanb.NillableValue(vci.assets.GetSubItem(settings.resetSwitchName))
    panelControllerGlue.Add(cytanb.NillableValue(vci.assets.GetSubItem(settings.resetSwitchMesh)), resetSwitch)

    breakEfkContainer = cytanb.NillableValue(vci.assets.GetSubItem(settings.breakEfkContainerName))
    breakEfk = cytanb.NillableValue(vci.assets.GetEffekseerEmitter(settings.breakEfkContainerName))

    settings.lsp.AddListener(function (source, key, value, oldValue)
        if key == cytanb.LOCAL_SHARED_PROPERTY_EXPIRED_KEY then
            -- cytanb.LogInfo('lsp: expired')
            vciLoaded = false
        end
    end)

    local OnChangePanelBase = function (parameterMap)
        cytanb.LogTrace('OnChangePanelBase')
        cytanb.NillableIfHasValue(parameterMap.panelBase, function (base)
            cytanb.NillableIfHasValue(base.tiltAngle, function (tiltAngle)
                tiltSwitch.SetValue(tiltAngle)
            end)
        end)
    end

    cytanb.OnInstanceMessage(resetMessageName, function (sender, name, parameterMap)
        if parameterMap.resetAll then
            cytanb.LogTrace('on resetAll: ', cytanb.Vars(parameterMap))
            ResetAll()
        end
    end)

    cytanb.OnInstanceMessage(breakPanelMessageName, function (sender, name, parameterMap)
        cytanb.NillableIfHasValue(parameterMap.target, function (panelParameters)
            cytanb.NillableIfHasValue(panelMap[panelParameters.name], function (panel)
                BreakPanel(panel)
            end)
        end)
    end)

    cytanb.OnInstanceMessage(changePanelBaseMessageName, function (sender, name, parameterMap)
        if parameterMap.senderID ~= cytanb.ClientID() then
            OnChangePanelBase(parameterMap)
        end
    end)

    ResetAll()
    SetPanelBaseTilt(tiltSwitch.GetValue())

    -- マスターが交代したときのことを考慮して、全ユーザーが OnMessage で登録する。
    cytanb.OnInstanceMessage(queryStatusMessageName, function (sender, name, parameterMap)
        if not vci.assets.IsMine then
            -- マスターでなければリターンする。
            return
        end

        local panelStatusList = {}
        for key, panel in pairs(panelMap) do
            panelStatusList[panel.index] = CreatePanelStatusParameter(panel)
        end

        cytanb.EmitMessage(statusMessageName, {
            senderID = cytanb.ClientID(),
            panelBase = CreatePanelBaseStatusParameter(),
            panels = panelStatusList
        })
    end)

    cytanb.OnInstanceMessage(statusMessageName, function (sender, name, parameterMap)
        if parameterMap.senderID ~= cytanb.ClientID() then
            cytanb.LogTrace('on statusMessage')
            OnChangePanelBase(parameterMap)

            for key, panelParameters in pairs(parameterMap.panels) do
                cytanb.NillableIfHasValue(panelMap[panelParameters.name], function (panel)
                    -- cytanb.LogTrace('panelParameters.active: ', panelParameters.active, ', panel.active = ', panel.active)
                    if panelParameters.active ~= panel.active then
                        panel.active = panelParameters.active
                        ShowPanelMesh(panel, panel.active)
                    end
                end)
            end
        end
    end)

    -- 現在のステータスを問い合わせる。
    -- 設置者よりも、ゲストのロードが早いケースを考慮して、全ユーザーがクエリーメッセージを送る。
    cytanb.EmitMessage(queryStatusMessageName)
end

local OnUpdate = function (deltaTime, unscaledDeltaTime)
    settings.lsp.UpdateAlive()
    panelControllerGlue.Update()

    for name, switch in pairs(slideSwitchMap) do
        switch.Update()
    end

    if deltaTime <= TimeSpan.Zero then
        return
    end

    if panelBase.IsMine then
        local now = vci.me.UnscaledTime
        if not panelBaseGrabbed then
            -- 傾きの変更を、インターバルを設けてメッセージで通知する
            if panelBaseTiltChanged and now >= lastPanelBaseTiltSendTime + settings.minRequestIntervalTime then
                panelBaseTiltChanged = false
                lastPanelBaseTiltSendTime = now

                if panelBase.IsMine then
                    cytanb.EmitMessage(changePanelBaseMessageName, {
                        senderID = cytanb.ClientID(),
                        panelBase = CreatePanelBaseStatusParameter()
                    })
                end
            end

            -- パネルの位置関係を、インターバルを設けて直す
            if now >= lastPanelMendedTime + settings.panelMendIntervalTime then
                MendAllPanels()
            end
        end

        if gameCompletedTime > TimeSpan.Zero and now >= gameCompletedTime + settings.autoResetWaitingTime then
            gameCompletedTime = TimeSpan.Zero
            cytanb.LogTrace('AutoReset: emit resetAll')
            EmitResetMessage('AutoReset @OnUpdate')
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

    if target == panelBase.GetName() then
        panelBaseGrabbed = true
    elseif target == resetSwitch.GetName() then
        resetSwitchClickCount, resetSwitchClickTime = cytanb.DetectClicks(resetSwitchClickCount, resetSwitchClickTime, settings.grabClickTiming)
        if resetSwitchClickCount == 3 then
            -- リセットスイッチを3回グラブする操作で、リセットを行う。
            -- (ユーザーは、スライドスイッチをグラブすると操作できるので、同じ入力キーで操作できるものと期待するため)
            EmitResetMessage('@onGrab 3 times')
        end
    else
        cytanb.NillableIfHasValue(slideSwitchMap[target], function (switch)
            switch.DoGrab()
        end)
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    if target == panelBase.GetName() then
        panelBaseGrabbed = false
        NormalizePanelBaseRotation()
        MendAllPanels()
    else
        cytanb.NillableIfHasValue(slideSwitchMap[target], function (switch)
            switch.DoUngrab()
        end)
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == resetSwitch.GetName() or use == panelBase.GetName() then
        EmitResetMessage('@onUse')
    else
        cytanb.NillableIfHasValue(slideSwitchMap[use], function (switch)
            switch.DoUse()
        end)
    end
end

onUnuse = function (use)
    cytanb.NillableIfHasValue(slideSwitchMap[use], function (switch)
        switch.DoUnuse()
    end)
end

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    -- cytanb.LogTrace('onTriggerEnter: item = ', item, ', hit = ', hit)

    if panelBase.IsMine and not panelBaseGrabbed and IsHitSource(hit) then
        cytanb.NillableIfHasValue(panelMap[item], function (panel)
            cytanb.LogTrace('onTriggerEnter: panel = ', item, ', hit = ', hit)
            lastPanelMendedTime = vci.me.UnscaledTime

            if BreakPanel(panel) then
                cytanb.LogTrace('emit break-panel: ', item)
                cytanb.EmitMessage(breakPanelMessageName, {
                    senderID = cytanb.ClientID(),
                    target = CreatePanelStatusParameter(panel)
                })
            end
        end)
    end
end
