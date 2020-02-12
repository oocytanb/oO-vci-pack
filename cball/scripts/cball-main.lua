-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(af)return af~=nil end,NillableValue=function(af)if af==nil then error('nillable: value is nil',2)end;return af end,NillableValueOrDefault=function(af,ag)if af==nil then if ag==nil then error('nillable: defaultValue is nil',2)end;return ag else return af end end,NillableIfHasValue=function(af,ah)if af==nil then return nil else return ah(af)end end,NillableIfHasValueOrElse=function(af,ah,ai)if af==nil then return ai()else return ah(af)end end,SetConst=function(aj,ak,q)if type(aj)~='table'then error('Cannot set const to non-table target',2)end;local al=getmetatable(aj)local A=al or{}local am=rawget(A,x)if rawget(aj,ak)~=nil then error('Non-const field "'..ak..'" already exists',2)end;if not am then am={}rawset(A,x,am)A.__index=y;A.__newindex=D end;rawset(am,ak,q)if not al then setmetatable(aj,A)end;return aj end,SetConstEach=function(aj,an)for N,E in pairs(an)do a.SetConst(aj,N,E)end;return aj end,Extend=function(aj,ao,ap,aq,a3)if aj==ao or type(aj)~='table'or type(ao)~='table'then return aj end;if ap then if not a3 then a3={}end;if a3[ao]then error('circular reference')end;a3[ao]=true end;for N,E in pairs(ao)do if ap and type(E)=='table'then local ar=aj[N]aj[N]=a.Extend(type(ar)=='table'and ar or{},E,ap,aq,a3)else aj[N]=E end end;if not aq then local as=getmetatable(ao)if type(as)=='table'then if ap then local at=getmetatable(aj)setmetatable(aj,a.Extend(type(at)=='table'and at or{},as,true))else setmetatable(aj,as)end end end;if ap then a3[ao]=nil end;return aj end,Vars=function(E,au,av,a3)local aw;if au then aw=au~='__NOLF'else au='  'aw=true end;if not av then av=''end;if not a3 then a3={}end;local ax=type(E)if ax=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local ay=aw and av..au or''local P='('..tostring(E)..') {'local az=true;for z,aA in pairs(E)do if az then az=false else P=P..(aw and','or', ')end;if aw then P=P..'\n'..ay end;if type(aA)=='table'and a3[aA]and a3[aA]>0 then P=P..z..' = ('..tostring(aA)..')'else P=P..z..' = '..a.Vars(aA,au,ay,a3)end end;if not az and aw then P=P..'\n'..av end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif ax=='function'or ax=='thread'or ax=='userdata'then return'('..ax..')'elseif ax=='string'then return'('..ax..') '..string.format('%q',E)else return'('..ax..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aB)f=aB end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aC)g=not not aC end,Log=function(aB,...)if aB<=f then local aD=g and(h[aB]or'LOG LEVEL '..tostring(aB))..' | 'or''local aE=table.pack(...)if aE.n==1 then local E=aE[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aD..P or P)else print(aD)end else local P=aD;for n=1,aE.n do local E=aE[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aF,aG)local aH={}if aG==nil then for N,E in pairs(aF)do aH[E]=E end elseif type(aG)=='function'then for N,E in pairs(aF)do local aI,aJ=aG(E)aH[aI]=aJ end else for N,E in pairs(aF)do aH[E]=aG end end;return aH end,Round=function(aK,aL)if aL then local aM=10^aL;return math.floor(aK*aM+0.5)/aM else return math.floor(aK+0.5)end end,Clamp=function(q,aN,aO)return math.max(aN,math.min(q,aO))end,Lerp=function(aP,aQ,ax)if ax<=0.0 then return aP elseif ax>=1.0 then return aQ else return aP+(aQ-aP)*ax end end,LerpUnclamped=function(aP,aQ,ax)if ax==0.0 then return aP elseif ax==1.0 then return aQ else return aP+(aQ-aP)*ax end end,PingPong=function(ax,aR)if aR==0 then return 0,1 end;local aS=math.floor(ax/aR)local aT=ax-aS*aR;if aS<0 then if(aS+1)%2==0 then return aR-aT,-1 else return aT,1 end else if aS%2==0 then return aT,1 else return aR-aT,-1 end end end,VectorApproximatelyEquals=function(aU,aV)return(aU-aV).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aU,aV)local aW=Quaternion.Dot(aU,aV)return aW<1.0+1E-06 and aW>1.0-1E-06 end,
QuaternionToAngleAxis=function(aX)local aS=aX.normalized;local aY=math.acos(aS.w)local aZ=math.sin(aY)local a_=math.deg(aY*2.0)local b0;if math.abs(aZ)<=Quaternion.kEpsilon then b0=Vector3.right else local b1=1.0/aZ;b0=Vector3.__new(aS.x*b1,aS.y*b1,aS.z*b1)end;return a_,b0 end,QuaternionTwist=function(aX,b2)if b2.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local b3=Vector3.__new(aX.x,aX.y,aX.z)if b3.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b4=Vector3.Project(b3,b2)if b4.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b5=Quaternion.__new(b4.x,b4.y,b4.z,aX.w)b5.Normalize()return b5 else return Quaternion.AngleAxis(0,b2)end else local b6=a.QuaternionToAngleAxis(aX)return Quaternion.AngleAxis(b6,b2)end end,ApplyQuaternionToVector3=function(aX,b7)local b8=aX.w*b7.x+aX.y*b7.z-aX.z*b7.y;local b9=aX.w*b7.y-aX.x*b7.z+aX.z*b7.x;local ba=aX.w*b7.z+aX.x*b7.y-aX.y*b7.x;local bb=-aX.x*b7.x-aX.y*b7.y-aX.z*b7.z;return Vector3.__new(bb*-aX.x+b8*aX.w+b9*-aX.z-ba*-aX.y,bb*-aX.y-b8*-aX.z+b9*aX.w+ba*-aX.x,bb*-aX.z+b8*-aX.y-b9*-aX.x+ba*aX.w)end,RotateAround=function(bc,bd,be,bf)return be+bf*(bc-be),bf*bd end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bg)return p.__tostring(bg)end,UUIDFromNumbers=function(...)local bh=...local ax=type(bh)local bi,bj,bk,bl;if ax=='table'then bi=bh[1]bj=bh[2]bk=bh[3]bl=bh[4]else bi,bj,bk,bl=...end;local bg={bit32.band(bi or 0,0xFFFFFFFF),bit32.band(bj or 0,0xFFFFFFFF),bit32.band(bk or 0,0xFFFFFFFF),bit32.band(bl or 0,0xFFFFFFFF)}setmetatable(bg,p)return bg end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bm='[0-9a-f-A-F]+'local bn='^('..bm..')$'local bo='^-('..bm..')$'local bp,bq,br,bs;if S==32 then local bg=a.UUIDFromNumbers(0,0,0,0)local bt=1;for n,bu in ipairs({8,16,24,32})do bp,bq,br=string.find(string.sub(P,bt,bu),bn)if not bp then return nil end;bg[n]=tonumber(br,16)bt=bu+1 end;return bg else bp,bq,br=string.find(string.sub(P,1,8),bn)if not bp then return nil end;local bi=tonumber(br,16)bp,bq,br=string.find(string.sub(P,9,13),bo)if not bp then return nil end;bp,bq,bs=string.find(string.sub(P,14,18),bo)if not bp then return nil end;local bj=tonumber(br..bs,16)bp,bq,br=string.find(string.sub(P,19,23),bo)if not bp then return nil end;bp,bq,bs=string.find(string.sub(P,24,28),bo)if not bp then return nil end;local bk=tonumber(br..bs,16)bp,bq,br=string.find(string.sub(P,29,36),bn)if not bp then return nil end;local bl=tonumber(br,16)return a.UUIDFromNumbers(bi,bj,bk,bl)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bv)if type(bv)~='number'or bv<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bv),2)end;local self;local bw=math.floor(bv)local U={}local bx=0;local by=0;local bz=0;self={Size=function()return bz end,Clear=function()bx=0;by=0;bz=0 end,IsEmpty=function()return bz==0 end,Offer=function(bA)U[bx+1]=bA;bx=(bx+1)%bw;if bz<bw then bz=bz+1 else by=(by+1)%bw end;return true end,OfferFirst=function(bA)by=(bw+by-1)%bw;U[by+1]=bA;if bz<bw then bz=bz+1 else bx=(bw+bx-1)%bw end;return true end,Poll=function()if bz==0 then return nil else local bA=U[by+1]by=(by+1)%bw;bz=bz-1;return bA end end,PollLast=function()if bz==0 then return nil else bx=(bw+bx-1)%bw;local bA=U[bx+1]bz=bz-1;return bA end end,Peek=function()if bz==0 then return nil else return U[by+1]end end,PeekLast=function()if bz==0 then return nil else return U[(bw+bx-1)%bw+1]end end,Get=function(bB)if bB<1 or bB>bz then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bB)return nil end;return U[(by+bB-1)%bw+1]end,IsFull=function()return bz>=bw end,MaxSize=function()return bw end}return self end,DetectClicks=function(bC,bD,bE)local bF=bC or 0;local bG=bE or TimeSpan.FromMilliseconds(500)local bH=vci.me.Time;local bI=bD and bH>bD+bG and 1 or bF+1;return bI,bH end,ColorRGBToHSV=function(bJ)local aT=math.max(0.0,math.min(bJ.r,1.0))local bK=math.max(0.0,math.min(bJ.g,1.0))local aQ=math.max(0.0,math.min(bJ.b,1.0))local aO=math.max(aT,bK,aQ)local aN=math.min(aT,bK,aQ)local bL=aO-aN;local C;if bL==0.0 then C=0.0 elseif aO==aT then C=(bK-aQ)/bL/6.0 elseif aO==bK then C=(2.0+(aQ-aT)/bL)/6.0 else C=(4.0+(aT-bK)/bL)/6.0 end;if C<0.0 then C=C+1.0 end;local bM=aO==0.0 and bL or bL/aO;local E=aO;return C,bM,E end,ColorFromARGB32=function(bN)local bO=type(bN)=='number'and bN or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bO,16),0xFF)/0xFF,bit32.band(bit32.rshift(bO,8),0xFF)/0xFF,bit32.band(bO,0xFF)/0xFF,bit32.band(bit32.rshift(bO,24),0xFF)/0xFF)end,ColorToARGB32=function(bJ)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bJ.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bJ.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bJ.g),0xFF),8),bit32.band(a.Round(0xFF*bJ.b),0xFF))end,ColorFromIndex=function(bP,bQ,bR,bS,bT)local bU=math.max(math.floor(bQ or a.ColorHueSamples),1)local bV=bT and bU or bU-1;local bW=math.max(math.floor(bR or a.ColorSaturationSamples),1)local bX=math.max(math.floor(bS or a.ColorBrightnessSamples),1)local bB=a.Clamp(math.floor(bP or 0),0,bU*bW*bX-1)local bY=bB%bU;local bZ=math.floor(bB/bU)local b1=bZ%bW;local b_=math.floor(bZ/bW)if bT or bY~=bV then local C=bY/bV;local bM=(bW-b1)/bW;local E=(bX-b_)/bX;return Color.HSVToRGB(C,bM,E)else local E=(bX-b_)/bX*b1/(bW-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bJ,bQ,bR,bS,bT)local bU=math.max(math.floor(bQ or a.ColorHueSamples),1)local bV=bT and bU or bU-1;local bW=math.max(math.floor(bR or a.ColorSaturationSamples),1)local bX=math.max(math.floor(bS or a.ColorBrightnessSamples),1)local C,bM,E=a.ColorRGBToHSV(bJ)local b1=a.Round(bW*(1.0-bM))if bT or b1<bW then local c0=a.Round(bV*C)if c0>=bV then c0=0 end;if b1>=bW then b1=bW-1 end;local b_=math.min(bX-1,a.Round(bX*(1.0-E)))return c0+bU*(b1+bW*b_)else local c1=a.Round((bW-1)*E)if c1==0 then local c2=a.Round(bX*(1.0-E))if c2>=bX then return bU-1 else return bU*(1+a.Round(E*(bW-1)/(bX-c2)*bX)+bW*c2)-1 end else return bU*(1+c1+bW*a.Round(bX*(1.0-E*(bW-1)/c1)))-1 end end end,ColorToTable=function(bJ)return{[a.TypeParameterName]=a.ColorTypeName,r=bJ.r,g=bJ.g,b=bJ.b,a=bJ.a}end,ColorFromTable=function(G)local aQ,M=F(G,a.ColorTypeName)return aQ and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local aQ,M=F(G,a.Vector2TypeName)return aQ and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local aQ,M=F(G,a.Vector3TypeName)return aQ and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local aQ,M=F(G,a.Vector4TypeName)return aQ and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local aQ,M=F(G,a.QuaternionTypeName)return aQ and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ak,c3)local a4=a.NillableIfHasValueOrElse(c3,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ak,json.serialize(a4))end,OnMessage=function(ak,ah)local c4=function(c5,c6,c7)local c8=nil;if c5.type~='comment'and type(c7)=='string'then local c9,a4=pcall(json.parse,c7)if c9 and type(a4)=='table'then c8=a.TableFromSerializable(a4)end end;local c3=c8 and c8 or{[a.MessageValueParameterName]=c7}ah(c5,c6,c3)end;vci.message.On(ak,c4)return{Off=function()if c4 then c4=nil end end}end,OnInstanceMessage=function(ak,ah)local c4=function(c5,c6,c3)local ca=a.InstanceID()if ca~=''and ca==c3[a.InstanceIDParameterName]then ah(c5,c6,c3)end end;return a.OnMessage(ak,c4)end,
GetEffekseerEmitterMap=function(ak)local cb=vci.assets.GetEffekseerEmitters(ak)if not cb then return nil end;local aH={}for n,cc in pairs(cb)do aH[cc.EffectName]=cc end;return aH end,ClientID=function()return j end,ParseTagString=function(P)local cd=string.find(P,'#',1,true)if not cd then return{},P end;local ce={}local cf=string.sub(P,1,cd-1)cd=cd+1;local S=string.len(P)local cg='^[A-Za-z0-9_%-.()!~*\'%%]+'while cd<=S do local ch,ci=string.find(P,cg,cd)if ch then local cj=string.sub(P,ch,ci)local ck=cj;cd=ci+1;if cd<=S and string.sub(P,cd,cd)=='='then cd=cd+1;local cl,cm=string.find(P,cg,cd)if cl then ck=string.sub(P,cl,cm)cd=cm+1 else ck=''end end;ce[cj]=ck end;cd=string.find(P,'#',cd,true)if not cd then break end;cd=cd+1 end;return ce,cf end,CreateLocalSharedProperties=function(cn,co)local cp=TimeSpan.FromSeconds(5)local cq='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cr='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(cn)~='string'or string.len(cn)<=0 or type(co)~='string'or string.len(co)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cs=_G[cq]if not cs then cs={}_G[cq]=cs end;cs[co]=vci.me.UnscaledTime;local ct=_G[cn]if not ct then ct={[cr]={}}_G[cn]=ct end;local cu=ct[cr]local self;self={GetLspID=function()return cn end,GetLoadID=function()return co end,GetProperty=function(z,ag)local q=ct[z]if q==nil then return ag else return q end end,SetProperty=function(z,q)if z==cr then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bH=vci.me.UnscaledTime;local cv=ct[z]ct[z]=q;for cw,ca in pairs(cu)do local ax=cs[ca]if ax and ax+cp>=bH then cw(self,z,q,cv)else cw(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)cu[cw]=nil;cs[ca]=nil end end end,Clear=function()for z,q in pairs(ct)do if z~=cr then self.SetProperty(z,nil)end end end,Each=function(ah)for z,q in pairs(ct)do if z~=cr and ah(q,z,self)==false then return false end end end,AddListener=function(cw)cu[cw]=co end,RemoveListener=function(cw)cu[cw]=nil end,UpdateAlive=function()cs[co]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(cx)local cy=1.0;local cz=1000.0;local cA=TimeSpan.FromSeconds(0.02)local cB=0xFFFF;local cC=a.CreateCircularQueue(64)local cD=TimeSpan.FromSeconds(5)local cE=TimeSpan.FromSeconds(30)local cF=false;local cG=vci.me.Time;local cH=a.Random32()local cI=Vector3.__new(bit32.bor(0x400,bit32.band(cH,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cH,16),0x1FFF)),0.0)cx.SetPosition(cI)cx.SetRotation(Quaternion.identity)cx.SetVelocity(Vector3.zero)cx.SetAngularVelocity(Vector3.zero)cx.AddForce(Vector3.__new(0.0,0.0,cy*cz))local self={Timestep=function()return cA end,Precision=function()return cB end,IsFinished=function()return cF end,Update=function()if cF then return cA end;local cJ=vci.me.Time-cG;local cK=cJ.TotalSeconds;if cK<=Vector3.kEpsilon then return cA end;local cL=cx.GetPosition().z-cI.z;local cM=cL/cK;local cN=cM/cz;if cN<=Vector3.kEpsilon then return cA end;cC.Offer(cN)local cO=cC.Size()if cO>=2 and cJ>=cD then local cP=0.0;for n=1,cO do cP=cP+cC.Get(n)end;local cQ=cP/cO;local cR=0.0;for n=1,cO do cR=cR+(cC.Get(n)-cQ)^2 end;local cS=cR/cO;if cS<cB then cB=cS;cA=TimeSpan.FromSeconds(cQ)end;if cJ>cE then cF=true;cx.SetPosition(cI)cx.SetRotation(Quaternion.identity)cx.SetVelocity(Vector3.zero)cx.SetAngularVelocity(Vector3.zero)end else cA=TimeSpan.FromSeconds(cN)end;return cA end}return self end,AlignSubItemOrigin=function(cT,cU,cV)local cW=cT.GetRotation()if not a.QuaternionApproximatelyEquals(cU.GetRotation(),cW)then cU.SetRotation(cW)end;local cX=cT.GetPosition()if not a.VectorApproximatelyEquals(cU.GetPosition(),cX)then cU.SetPosition(cX)end;if cV then cU.SetVelocity(Vector3.zero)cU.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local cY={}local self;self={Contains=function(cZ,c_)return a.NillableIfHasValueOrElse(cY[cZ],function(an)return a.NillableHasValue(an[c_])end,function()return false end)end,Add=function(cZ,d0,cV)if not cZ or not d0 then local d1='SubItemGlue.Add: Invalid arguments '..(not cZ and', parent = '..tostring(cZ)or'')..(not d0 and', children = '..tostring(d0)or'')error(d1,2)end;local an=a.NillableIfHasValueOrElse(cY[cZ],function(d2)return d2 end,function()local d2={}cY[cZ]=d2;return d2 end)if type(d0)=='table'then for z,aA in pairs(d0)do an[aA]={velocityReset=not not cV}end else an[d0]={velocityReset=not not cV}end end,Remove=function(cZ,c_)return a.NillableIfHasValueOrElse(cY[cZ],function(an)if a.NillableHasValue(an[c_])then an[c_]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(cZ)if a.NillableHasValue(cY[cZ])then cY[cZ]=nil;return true else return false end end,RemoveAll=function()cY={}return true end,Each=function(ah,d3)return a.NillableIfHasValueOrElse(d3,function(cZ)return a.NillableIfHasValue(cY[cZ],function(an)for c_,d4 in pairs(an)do if ah(c_,cZ,self)==false then return false end end end)end,function()for cZ,an in pairs(cY)do if self.Each(ah,cZ)==false then return false end end end)end,Update=function(d5)for cZ,an in pairs(cY)do local d6=cZ.GetPosition()local d7=cZ.GetRotation()for c_,d4 in pairs(an)do if d5 or c_.IsMine then if not a.QuaternionApproximatelyEquals(c_.GetRotation(),d7)then c_.SetRotation(d7)end;if not a.VectorApproximatelyEquals(c_.GetPosition(),d6)then c_.SetPosition(d6)end;if d4.velocityReset then c_.SetVelocity(Vector3.zero)c_.SetAngularVelocity(Vector3.zero)end end end end end}return self end,
CreateSlideSwitch=function(d8)local d9=a.NillableValue(d8.colliderItem)local da=a.NillableValue(d8.baseItem)local db=a.NillableValue(d8.knobItem)local dc=a.NillableValueOrDefault(d8.minValue,0)local dd=a.NillableValueOrDefault(d8.maxValue,10)if dc>=dd then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local de=(dc+dd)*0.5;local df=function(aA)local dg,dh=a.PingPong(aA-dc,dd-dc)return dg+dc,dh end;local q=df(a.NillableValueOrDefault(d8.value,0))local di=a.NillableIfHasValueOrElse(d8.tickFrequency,function(dj)if dj<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(dj,dd-dc)end,function()return(dd-dc)/10.0 end)local dk=a.NillableIfHasValueOrElse(d8.tickVector,function(b0)return Vector3.__new(b0.x,b0.y,b0.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local dl=dk.magnitude;if dl<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local dm=a.NillableValueOrDefault(d8.snapToTick,true)local dn=TimeSpan.FromMilliseconds(1000)local dp=TimeSpan.FromMilliseconds(50)local dq,dr;local cu={}local self;local ds=false;local dt=0;local du=false;local dv=TimeSpan.Zero;local dw=TimeSpan.Zero;local dx=function()local dy=df(dq())if dy~=q then q=dy;for cw,E in pairs(cu)do cw(self,q)end end;db.SetLocalPosition((dy-de)/di*dk)end;local dz=function()local dA=dq()local dB,dC=df(dA)local dD=dA+di;local dE,dF=df(dD)assert(dE)local dy;if dC==dF or dB==dd or dB==dc then dy=dD else dy=dC>=0 and dd or dc end;dw=vci.me.UnscaledTime;if dy==dd or dy==dc then dv=dw end;dr(dy)end;a.NillableIfHasValueOrElse(d8.lsp,function(dG)if not a.NillableHasValue(d8.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local dH=a.NillableValue(d8.propertyName)dq=function()return dG.GetProperty(dH,q)end;dr=function(aA)dG.SetProperty(dH,aA)end;dG.AddListener(function(ao,z,dI,dJ)if z==dH then dx()end end)end,function()local dI=q;dq=function()return dI end;dr=function(aA)dI=aA;dx()end end)self={GetColliderItem=function()return d9 end,GetBaseItem=function()return da end,GetKnobItem=function()return db end,GetMinValue=function()return dc end,GetMaxValue=function()return dd end,GetValue=function()return q end,SetValue=function(aA)dr(df(aA))end,GetTickFrequency=function()return di end,IsSnapToTick=function()return dm end,AddListener=function(cw)cu[cw]=cw end,RemoveListener=function(cw)cu[cw]=nil end,DoUse=function()if not ds then du=true;dv=vci.me.UnscaledTime;dz()end end,DoUnuse=function()du=false end,DoGrab=function()if not du then ds=true;dt=(q-de)/di end end,DoUngrab=function()ds=false end,Update=function()if ds then local dK=d9.GetPosition()-da.GetPosition()local dL=db.GetRotation()*dk;local dM=Vector3.Project(dK,dL)local dN=(Vector3.Dot(dL,dM)>=0 and 1 or-1)*dM.magnitude/dl+dt;local dO=(dm and a.Round(dN)or dN)*di+de;local dy=a.Clamp(dO,dc,dd)if dy~=q then dr(dy)end elseif du then local dP=vci.me.UnscaledTime;if dP>=dv+dn and dP>=dw+dp then dz()end elseif d9.IsMine then a.AlignSubItemOrigin(da,d9)end end}dx()return self end,CreateSubItemConnector=function()local dQ=function(dR,cU,dS)dR.item=cU;dR.position=cU.GetPosition()dR.rotation=cU.GetRotation()dR.initialPosition=dR.position;dR.initialRotation=dR.rotation;dR.propagation=not not dS;return dR end;local dT=function(dU)for cU,dR in pairs(dU)do dQ(dR,cU,dR.propagation)end end;local dV=function(dW,bf,dR,dX,dY)local dK=dW-dR.initialPosition;local dZ=bf*Quaternion.Inverse(dR.initialRotation)dR.position=dW;dR.rotation=bf;for cU,d_ in pairs(dX)do if cU~=dR.item and(not dY or dY(d_))then d_.position,d_.rotation=a.RotateAround(d_.initialPosition+dK,d_.initialRotation,dW,dZ)cU.SetPosition(d_.position)cU.SetRotation(d_.rotation)end end end;local e0={}local e1=true;local e2=false;local self;self={IsEnabled=function()return e1 end,SetEnabled=function(aC)e1=aC;if aC then dT(e0)e2=false end end,Contains=function(e3)return a.NillableHasValue(e0[e3])end,Add=function(e4,e5)if not e4 then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(e4),2)end;local e6=type(e4)=='table'and e4 or{e4}dT(e0)e2=false;for N,cU in pairs(e6)do e0[cU]=dQ({},cU,not e5)end end,Remove=function(e3)local aQ=a.NillableHasValue(e0[e3])e0[e3]=nil;return aQ end,RemoveAll=function()e0={}return true end,Each=function(ah)for cU,dR in pairs(e0)do if ah(cU,self)==false then return false end end end,GetItems=function()local e6={}for cU,dR in pairs(e0)do table.insert(e6,cU)end;return e6 end,Update=function()if not e1 then return end;local e7=false;for cU,dR in pairs(e0)do local cd=cU.GetPosition()local e8=cU.GetRotation()if not a.VectorApproximatelyEquals(cd,dR.position)or not a.QuaternionApproximatelyEquals(e8,dR.rotation)then if dR.propagation then if cU.IsMine then dV(cd,e8,e0[cU],e0,function(d_)if d_.item.IsMine then return true else e2=true;return false end end)e7=true;break else e2=true end else e2=true end end end;if not e7 and e2 then dT(e0)e2=false end end}return self end,GetSubItemTransform=function(e3)local dW=e3.GetPosition()local bf=e3.GetRotation()local e9=e3.GetLocalScale()return{positionX=dW.x,positionY=dW.y,positionZ=dW.z,rotationX=bf.x,rotationY=bf.y,rotationZ=bf.z,rotationW=bf.w,scaleX=e9.x,scaleY=e9.y,scaleZ=e9.z}end,RestoreCytanbTransform=function(ea)local cd=ea.positionX and ea.positionY and ea.positionZ and Vector3.__new(ea.positionX,ea.positionY,ea.positionZ)or nil;local e8=ea.rotationX and ea.rotationY and ea.rotationZ and ea.rotationW and Quaternion.__new(ea.rotationX,ea.rotationY,ea.rotationZ,ea.rotationW)or nil;local e9=ea.scaleX and ea.scaleY and ea.scaleZ and Vector3.__new(ea.scaleX,ea.scaleY,ea.scaleZ)or nil;return cd,e8,e9 end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local cn='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local ct=_G[cn]if not ct then ct={}_G[cn]=ct end;local eb=ct.randomSeedValue;if not eb then eb=os.time()-os.clock()*10000;ct.randomSeedValue=eb;math.randomseed(eb)end;local ec=ct.clientID;if type(ec)~='string'then ec=tostring(a.RandomUUID())ct.clientID=ec end;local ed=vci.state.Get(b)or''if ed==''and vci.assets.IsMine then ed=tostring(a.RandomUUID())vci.state.Set(b,ed)end;return ed,ec end)()return a end)()

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
local slideSwitchMap, velocitySwitch, angularVelocitySwitch, altitudeSwitch, throwingDetectionSwitch, gravitySwitch, efkLevelSwitch, audioVolumeSwitch

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

local OutputStats = function ()
    local indent = '  '
    local propBuf = ''
    local hitBuf = ''
    settings.statsLsp.Each(function (value, key, lsp)
        if string.startsWith(key, settings.statsHitCountPropertyNamePrefix) then
            if hitBuf == '' then
                hitBuf = indent
            else
                hitBuf = hitBuf .. ', '
            end
            hitBuf = hitBuf .. key .. ' = ' .. tostring(value)
        else
            propBuf = propBuf .. indent .. key .. ' = ' .. tostring(value) .. '\n'
        end
    end)

    local buf = ((hitBuf ~= '') and hitBuf .. '\n' or '') .. propBuf

    buf = buf .. indent .. 'velocity = ' .. cytanb.Round(statsCache.throwingVelocity.magnitude * 3.6, 2) .. ' [km/s], Vector3' .. tostring(statsCache.throwingVelocity)

    buf = buf .. '\n' .. indent .. 'angularVelocity = magnitude(' .. cytanb.Round(statsCache.throwingAngularVelocity.magnitude, 2) .. '), Vector3' .. tostring(statsCache.throwingAngularVelocity)

    -- 直線距離での、予測飛距離を計算する。
    -- カーブを考慮しないことや、フレームレートの影響による AddForce の変動、その他の要因により、実測とは異なる。
    local predictedFlyingDistanceString
    if statsCache.throwingPosition.y > 0 and statsCache.gravity < 0 then
        local g = - statsCache.gravity
        local h = statsCache.throwingPosition.y
        local vx0 = math.sqrt(statsCache.throwingVelocity.x ^ 2 + statsCache.throwingVelocity.z ^ 2)
        local vy0 = statsCache.throwingVelocity.y
        local distance = vx0 * (vy0 + math.sqrt(vy0 ^ 2 + 2 * g * h)) / g
        predictedFlyingDistanceString = cytanb.Round(distance, 2) .. ' [m]'
    else
        predictedFlyingDistanceString = 'N/A'
    end
    buf = buf .. '\n' .. indent .. 'predictedFlyingDistance = ' .. predictedFlyingDistanceString

    print(buf)
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

    OutputStats()
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
    vci.assets.SetMaterialEmissionColorFromName(settings.ballCoveredLightMat, Color.__new(color.r * 1.5, color.g * 1.5, color.b * 1.5, 1.0))
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

    -- update stats
    local propertyName = settings.statsHitCountPropertyNamePrefix .. hitBaseName
    settings.statsLsp.SetProperty(
        propertyName,
        settings.statsLsp.GetProperty(propertyName, 0) + 1
    )
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

        if headTime - element.time > settings.ballKinematicDetectionTimeThreshold then
            break
        end

        local pos = element.position
        ballEfkContainer.SetPosition(pos)
        ballEfkOneLarge.Play()
    end
end

local PlayThrowingAudio = function (velocityMagnitude)
    local volume = CalcAudioVolume()
    local min = settings.ballKinematicVelocityThreshold
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

    if not ball.IsMine or ballStatus.transformQueue.Size() < 2 then
        return
    end

    ballStatus.gravityFactor = CalcGravityFactor()

    local detectionSec = CalcAdjustmentValue(throwingDetectionSwitch, false)
    local headTransform = ballStatus.transformQueue.PollLast()
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
        local element = ballStatus.transformQueue.PollLast()
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

        local deltaSec = (st - element.time).TotalSeconds
        if deltaSec > Vector3.kEpsilon then
            local directionWeight = math.max(0.0, 1.0 - settings.ballKinematicDetectionFactor * (headTime - st).TotalSeconds / detectionSec)
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

            totalSec = (headTime - element.time).TotalSeconds
        end

        -- cytanb.LogTrace('velocityDirection: ', velocityDirection, ', angularVelocityDirection: ', angularVelocityDirection)
        st = element.time
        sp = element.position
        sr = element.rotation
    end
    ballStatus.transformQueue.Clear()

    local kinematicVelocityMagnitude = totalSec > Vector3.kEpsilon and totalVelocityMagnitude / totalSec or 0
    -- cytanb.LogTrace('kinematicVelocityMagnitude: ', kinematicVelocityMagnitude)

    if kinematicVelocityMagnitude > settings.ballKinematicVelocityThreshold then
        local velocityMagnitude = CalcAdjustmentValue(velocitySwitch, false) * kinematicVelocityMagnitude
        local velocity = ApplyAltitudeAngle(velocityDirection.normalized, CalcAdjustmentValue(altitudeSwitch, false)) * velocityMagnitude
        local forwardOffset = velocity * (math.min(velocityMagnitude * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset) / velocityMagnitude)

        local angularVelocity = CalcAngularVelocity(angularVelocityDirection.normalized, CalcAdjustmentValue(angularVelocitySwitch, false) * totalAngle, totalSec)

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
    statsCache.gravity = settings.defaultGravity + ballStatus.gravityFactor

    -- 体のコライダーに接触しないように、オフセットを足す
    local ballPos = curBallPos + forwardOffset
    ball.SetPosition(ballPos)

    PlayThrowingAudio(velocityMagnitude)

    ballStatus.transformQueue.Clear()
    OfferBallTransform(ballPos, ball.GetRotation())
end

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    settings.lsp.UpdateAlive()
    settings.statsLsp.UpdateAlive()
    vciLoaded = true

    local uuid = cytanb.UUIDFromString(cytanb.InstanceID())
    hiddenPosition = Vector3.__new(uuid[1] / 0x100000, 0x1000, uuid[2] / 0x100000)
    cytanb.LogTrace('hiddenPosition: ', hiddenPosition)

    timestepEstimater = cytanb.EstimateFixedTimestep(cytanb.NillableValue(vci.assets.GetSubItem('timestep-estimater')))
    fixedTimestep = timestepEstimater.Timestep()

    ball = cytanb.NillableValue(vci.assets.GetSubItem(settings.ballName))

    ballEfkContainer = cytanb.NillableValue(vci.assets.GetSubItem(settings.ballEfkContainerName))

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
        local item = cytanb.NillableValue(vci.assets.GetSubItem(settings.standLightPrefix .. (i - 1)))
        local entry = {
            item = item,
            status = cytanb.Extend(cytanb.Extend({}, standLightInitialStatus), {
                respawnPosition = item.GetPosition(),
                respawnTime = vci.me.Time,
                grabbed = false,
            })
        }
        standLights[i] = entry
        colorPickers[item.GetName()] = entry
    end

    standLightEfkContainer = cytanb.NillableValue(vci.assets.GetSubItem(settings.standLightEfkContainerName))

    local standLightEfkMap = cytanb.GetEffekseerEmitterMap(settings.standLightEfkContainerName)
    standLightHitEfk = cytanb.NillableValue(standLightEfkMap[settings.standLightHitEfkName])
    standLightDirectHitEfk = cytanb.NillableValue(standLightEfkMap[settings.standLightDirectHitEfkName])

    impactForceGauge = cytanb.NillableValue(vci.assets.GetSubItem(settings.impactForceGaugeName))
    impactForceGauge.SetPosition(hiddenPosition)

    impactSpinGauge = cytanb.NillableValue(vci.assets.GetSubItem(settings.impactSpinGaugeName))
    impactSpinGauge.SetPosition(hiddenPosition)

    settingsPanel = cytanb.NillableValue(vci.assets.GetSubItem(settings.settingsPanelName))
    settingsPanelGlue = cytanb.CreateSubItemGlue()

    closeSwitch = cytanb.NillableValue(vci.assets.GetSubItem(settings.closeSwitchName))
    settingsPanelGlue.Add(cytanb.NillableValue(vci.assets.GetSubItem(settings.closeSwitchBaseName)), closeSwitch)

    slideSwitchMap = {}
    for k, parameters in pairs(settings.switchParameters) do
        local switch = cytanb.CreateSlideSwitch(
            cytanb.Extend({
                colliderItem = cytanb.NillableValue(vci.assets.GetSubItem(parameters.colliderName)),
                baseItem = cytanb.NillableValue(vci.assets.GetSubItem(parameters.baseName)),
                knobItem = cytanb.NillableValue(vci.assets.GetSubItem(parameters.knobName)),
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
    throwingDetectionSwitch = cytanb.NillableValue(slideSwitchMap[settings.throwingDetectionSwitchName])
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
                if standLights[i] then
                    local light = standLights[i]
                    local ls = light.status
                    if lightParameter.respawnPosition then
                        cytanb.Extend(ls, standLightInitialStatus)
                        ls.respawnPosition = lightParameter.respawnPosition
                        ls.respawnTime = vci.me.Time
                    end
                end
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
        for i = 1, settings.standLightCount do
            standLightsParameter[i] = CreateStandLightStatusParameter(standLights[i])
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
            for i, options in pairs(targets) do
                cytanb.NillableIfHasValue(standLights[i], function (light)
                    BuildStandLight(light)
                end)
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
        if not source.position then
            return
        end

        local nillableLight, index = StandLightFromName(parameterMap.target.name)
        cytanb.NillableIfHasValue(nillableLight, function (light)
            local li = light.item
            local ls = light.status
            local now = vci.me.Time
            if IsContactWithTarget(source.position, source.longSide or 0.5, li.GetPosition(), settings.standLightSimLongSide) and now > ls.hitMessageTime + settings.requestIntervalTime then
                -- 自 VCI のターゲットにヒットした
                cytanb.LogTrace('onHitMessage: standLights[', index, ']')
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

                    if ballPos.y < 0 and ballPos.y < lastPos.y then
                        -- 床抜けの対策。
                        local leapY = 0.125
                        local minY = 0.25 - ballPos.y
                        local dy = lastPos.y - ballPos.y
                        local vy = dy + math.min(minY - leapY, dy * 0.5)
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
    for i = 1, settings.standLightCount do
        local light = standLights[i]
        local li = light.item
        local ls = light.status
        local horizontalAttitude = IsHorizontalAttitude(li.GetRotation(), Vector3.up, settings.standLightHorizontalAttitudeThreshold)
        if horizontalAttitude then
            if not ls.active then
                -- 復活した
                cytanb.LogTrace('change standLights[', i, '] state to active')
                ls.active = true
            end
        else
            local now = vci.me.Time
            if ls.active then
                -- 倒れたことを検知した
                cytanb.TraceLog('change standLights[', i, '] state to inactive')
                ls.active = false
                ls.inactiveTime = now
                if now <= ls.readyInactiveTime + settings.requestIntervalTime then
                    cytanb.TraceLog('  call HitStandLight: light = ', li.GetName(), ', directHit = ', ls.directHit, ' @OnUpdateStandLight')
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
                    targets[i] = {}
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


local OnUpdate = function (deltaTime, unscaledDeltaTime)
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
    elseif string.startsWith(target, settings.standLightPrefix) then
        cytanb.NillableIfHasValue((StandLightFromName(target)), function (light)
            light.status.grabbed = true
        end)
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

    if target == ballCup.GetName() then
        ballCupStatus.grabbed = false
        ResetBallCup()
    elseif target == ball.GetName() then
        if ballStatus.grabbed then
            ballStatus.grabbed = false
            if ball.IsMine then
                if impactStatus.phase == 0 then
                    ThrowBallByKinematic()
                else
                    ThrowBallByInputTiming()
                end
                ballStatus.boundCount = 0
            end
            impactStatus.gaugeStartTime = vci.me.Time
        end
    elseif string.startsWith(target, settings.standLightPrefix) then
        local nillableLight, index = StandLightFromName(target)
        cytanb.NillableIfHasValue(nillableLight, function (light)
            cytanb.LogTrace('ungrab ', target, ', index = ', index)
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

                cytanb.LogTrace('emit StatusChanged: ', li.GetName(), ': index = ', index, ', respawnPosition = ', ls.respawnPosition)
                cytanb.EmitMessage(statusChangedMessageName, {
                    clientID = cytanb.ClientID(),
                    standLights = {
                        [index] = {
                            respawnPosition = cytanb.Vector3ToTable(ls.respawnPosition)
                        }
                    }
                })
            end
        end)
    elseif target == settingsPanel.GetName() then
        settingsPanelStatus.grabbed = false
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
        cytanb.NillableIfHasValue((StandLightFromName(item)), function (light)
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
