-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(af)return af~=nil end,NillableValue=function(af)if af==nil then error('nillable: value is nil',2)end;return af end,NillableValueOrDefault=function(af,ag)if af==nil then if ag==nil then error('nillable: defaultValue is nil',2)end;return ag else return af end end,NillableIfHasValue=function(af,ah)if af==nil then return nil else return ah(af)end end,NillableIfHasValueOrElse=function(af,ah,ai)if af==nil then return ai()else return ah(af)end end,SetConst=function(aj,ak,q)if type(aj)~='table'then error('Cannot set const to non-table target',2)end;local al=getmetatable(aj)local A=al or{}local am=rawget(A,x)if rawget(aj,ak)~=nil then error('Non-const field "'..ak..'" already exists',2)end;if not am then am={}rawset(A,x,am)A.__index=y;A.__newindex=D end;rawset(am,ak,q)if not al then setmetatable(aj,A)end;return aj end,SetConstEach=function(aj,an)for N,E in pairs(an)do a.SetConst(aj,N,E)end;return aj end,Extend=function(aj,ao,ap,aq,a3)if aj==ao or type(aj)~='table'or type(ao)~='table'then return aj end;if ap then if not a3 then a3={}end;if a3[ao]then error('circular reference')end;a3[ao]=true end;for N,E in pairs(ao)do if ap and type(E)=='table'then local ar=aj[N]aj[N]=a.Extend(type(ar)=='table'and ar or{},E,ap,aq,a3)else aj[N]=E end end;if not aq then local as=getmetatable(ao)if type(as)=='table'then if ap then local at=getmetatable(aj)setmetatable(aj,a.Extend(type(at)=='table'and at or{},as,true))else setmetatable(aj,as)end end end;if ap then a3[ao]=nil end;return aj end,Vars=function(E,au,av,a3)local aw;if au then aw=au~='__NOLF'else au='  'aw=true end;if not av then av=''end;if not a3 then a3={}end;local ax=type(E)if ax=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local ay=aw and av..au or''local P='('..tostring(E)..') {'local az=true;for z,aA in pairs(E)do if az then az=false else P=P..(aw and','or', ')end;if aw then P=P..'\n'..ay end;if type(aA)=='table'and a3[aA]and a3[aA]>0 then P=P..z..' = ('..tostring(aA)..')'else P=P..z..' = '..a.Vars(aA,au,ay,a3)end end;if not az and aw then P=P..'\n'..av end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif ax=='function'or ax=='thread'or ax=='userdata'then return'('..ax..')'elseif ax=='string'then return'('..ax..') '..string.format('%q',E)else return'('..ax..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aB)f=aB end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aC)g=not not aC end,Log=function(aB,...)if aB<=f then local aD=g and(h[aB]or'LOG LEVEL '..tostring(aB))..' | 'or''local aE=table.pack(...)if aE.n==1 then local E=aE[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aD..P or P)else print(aD)end else local P=aD;for n=1,aE.n do local E=aE[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aF,aG)local aH={}if aG==nil then for N,E in pairs(aF)do aH[E]=E end elseif type(aG)=='function'then for N,E in pairs(aF)do local aI,aJ=aG(E)aH[aI]=aJ end else for N,E in pairs(aF)do aH[E]=aG end end;return aH end,Round=function(aK,aL)if aL then local aM=10^aL;return math.floor(aK*aM+0.5)/aM else return math.floor(aK+0.5)end end,Clamp=function(q,aN,aO)return math.max(aN,math.min(q,aO))end,Lerp=function(aP,aQ,ax)if ax<=0.0 then return aP elseif ax>=1.0 then return aQ else return aP+(aQ-aP)*ax end end,LerpUnclamped=function(aP,aQ,ax)if ax==0.0 then return aP elseif ax==1.0 then return aQ else return aP+(aQ-aP)*ax end end,PingPong=function(ax,aR)if aR==0 then return 0,1 end;local aS=math.floor(ax/aR)local aT=ax-aS*aR;if aS<0 then if(aS+1)%2==0 then return aR-aT,-1 else return aT,1 end else if aS%2==0 then return aT,1 else return aR-aT,-1 end end end,VectorApproximatelyEquals=function(aU,aV)return(aU-aV).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aU,aV)local aW=Quaternion.Dot(aU,aV)return aW<1.0+1E-06 and aW>1.0-1E-06 end,
QuaternionToAngleAxis=function(aX)local aS=aX.normalized;local aY=math.acos(aS.w)local aZ=math.sin(aY)local a_=math.deg(aY*2.0)local b0;if math.abs(aZ)<=Quaternion.kEpsilon then b0=Vector3.right else local b1=1.0/aZ;b0=Vector3.__new(aS.x*b1,aS.y*b1,aS.z*b1)end;return a_,b0 end,QuaternionTwist=function(aX,b2)if b2.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local b3=Vector3.__new(aX.x,aX.y,aX.z)if b3.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b4=Vector3.Project(b3,b2)if b4.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local b5=Quaternion.__new(b4.x,b4.y,b4.z,aX.w)b5.Normalize()return b5 else return Quaternion.AngleAxis(0,b2)end else local b6=a.QuaternionToAngleAxis(aX)return Quaternion.AngleAxis(b6,b2)end end,ApplyQuaternionToVector3=function(aX,b7)local b8=aX.w*b7.x+aX.y*b7.z-aX.z*b7.y;local b9=aX.w*b7.y-aX.x*b7.z+aX.z*b7.x;local ba=aX.w*b7.z+aX.x*b7.y-aX.y*b7.x;local bb=-aX.x*b7.x-aX.y*b7.y-aX.z*b7.z;return Vector3.__new(bb*-aX.x+b8*aX.w+b9*-aX.z-ba*-aX.y,bb*-aX.y-b8*-aX.z+b9*aX.w+ba*-aX.x,bb*-aX.z+b8*-aX.y-b9*-aX.x+ba*aX.w)end,RotateAround=function(bc,bd,be,bf)return be+bf*(bc-be),bf*bd end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bg)return p.__tostring(bg)end,UUIDFromNumbers=function(...)local bh=...local ax=type(bh)local bi,bj,bk,bl;if ax=='table'then bi=bh[1]bj=bh[2]bk=bh[3]bl=bh[4]else bi,bj,bk,bl=...end;local bg={bit32.band(bi or 0,0xFFFFFFFF),bit32.band(bj or 0,0xFFFFFFFF),bit32.band(bk or 0,0xFFFFFFFF),bit32.band(bl or 0,0xFFFFFFFF)}setmetatable(bg,p)return bg end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bm='[0-9a-f-A-F]+'local bn='^('..bm..')$'local bo='^-('..bm..')$'local bp,bq,br,bs;if S==32 then local bg=a.UUIDFromNumbers(0,0,0,0)local bt=1;for n,bu in ipairs({8,16,24,32})do bp,bq,br=string.find(string.sub(P,bt,bu),bn)if not bp then return nil end;bg[n]=tonumber(br,16)bt=bu+1 end;return bg else bp,bq,br=string.find(string.sub(P,1,8),bn)if not bp then return nil end;local bi=tonumber(br,16)bp,bq,br=string.find(string.sub(P,9,13),bo)if not bp then return nil end;bp,bq,bs=string.find(string.sub(P,14,18),bo)if not bp then return nil end;local bj=tonumber(br..bs,16)bp,bq,br=string.find(string.sub(P,19,23),bo)if not bp then return nil end;bp,bq,bs=string.find(string.sub(P,24,28),bo)if not bp then return nil end;local bk=tonumber(br..bs,16)bp,bq,br=string.find(string.sub(P,29,36),bn)if not bp then return nil end;local bl=tonumber(br,16)return a.UUIDFromNumbers(bi,bj,bk,bl)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bv)if type(bv)~='number'or bv<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bv),2)end;local self;local bw=math.floor(bv)local U={}local bx=0;local by=0;local bz=0;self={Size=function()return bz end,Clear=function()bx=0;by=0;bz=0 end,IsEmpty=function()return bz==0 end,Offer=function(bA)U[bx+1]=bA;bx=(bx+1)%bw;if bz<bw then bz=bz+1 else by=(by+1)%bw end;return true end,OfferFirst=function(bA)by=(bw+by-1)%bw;U[by+1]=bA;if bz<bw then bz=bz+1 else bx=(bw+bx-1)%bw end;return true end,Poll=function()if bz==0 then return nil else local bA=U[by+1]by=(by+1)%bw;bz=bz-1;return bA end end,PollLast=function()if bz==0 then return nil else bx=(bw+bx-1)%bw;local bA=U[bx+1]bz=bz-1;return bA end end,Peek=function()if bz==0 then return nil else return U[by+1]end end,PeekLast=function()if bz==0 then return nil else return U[(bw+bx-1)%bw+1]end end,Get=function(bB)if bB<1 or bB>bz then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bB)return nil end;return U[(by+bB-1)%bw+1]end,IsFull=function()return bz>=bw end,MaxSize=function()return bw end}return self end,DetectClicks=function(bC,bD,bE)local bF=bC or 0;local bG=bE or TimeSpan.FromMilliseconds(500)local bH=vci.me.Time;local bI=bD and bH>bD+bG and 1 or bF+1;return bI,bH end,ColorRGBToHSV=function(bJ)local aT=math.max(0.0,math.min(bJ.r,1.0))local bK=math.max(0.0,math.min(bJ.g,1.0))local aQ=math.max(0.0,math.min(bJ.b,1.0))local aO=math.max(aT,bK,aQ)local aN=math.min(aT,bK,aQ)local bL=aO-aN;local C;if bL==0.0 then C=0.0 elseif aO==aT then C=(bK-aQ)/bL/6.0 elseif aO==bK then C=(2.0+(aQ-aT)/bL)/6.0 else C=(4.0+(aT-bK)/bL)/6.0 end;if C<0.0 then C=C+1.0 end;local bM=aO==0.0 and bL or bL/aO;local E=aO;return C,bM,E end,ColorFromARGB32=function(bN)local bO=type(bN)=='number'and bN or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bO,16),0xFF)/0xFF,bit32.band(bit32.rshift(bO,8),0xFF)/0xFF,bit32.band(bO,0xFF)/0xFF,bit32.band(bit32.rshift(bO,24),0xFF)/0xFF)end,ColorToARGB32=function(bJ)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bJ.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bJ.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bJ.g),0xFF),8),bit32.band(a.Round(0xFF*bJ.b),0xFF))end,ColorFromIndex=function(bP,bQ,bR,bS,bT)local bU=math.max(math.floor(bQ or a.ColorHueSamples),1)local bV=bT and bU or bU-1;local bW=math.max(math.floor(bR or a.ColorSaturationSamples),1)local bX=math.max(math.floor(bS or a.ColorBrightnessSamples),1)local bB=a.Clamp(math.floor(bP or 0),0,bU*bW*bX-1)local bY=bB%bU;local bZ=math.floor(bB/bU)local b1=bZ%bW;local b_=math.floor(bZ/bW)if bT or bY~=bV then local C=bY/bV;local bM=(bW-b1)/bW;local E=(bX-b_)/bX;return Color.HSVToRGB(C,bM,E)else local E=(bX-b_)/bX*b1/(bW-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bJ,bQ,bR,bS,bT)local bU=math.max(math.floor(bQ or a.ColorHueSamples),1)local bV=bT and bU or bU-1;local bW=math.max(math.floor(bR or a.ColorSaturationSamples),1)local bX=math.max(math.floor(bS or a.ColorBrightnessSamples),1)local C,bM,E=a.ColorRGBToHSV(bJ)local b1=a.Round(bW*(1.0-bM))if bT or b1<bW then local c0=a.Round(bV*C)if c0>=bV then c0=0 end;if b1>=bW then b1=bW-1 end;local b_=math.min(bX-1,a.Round(bX*(1.0-E)))return c0+bU*(b1+bW*b_)else local c1=a.Round((bW-1)*E)if c1==0 then local c2=a.Round(bX*(1.0-E))if c2>=bX then return bU-1 else return bU*(1+a.Round(E*(bW-1)/(bX-c2)*bX)+bW*c2)-1 end else return bU*(1+c1+bW*a.Round(bX*(1.0-E*(bW-1)/c1)))-1 end end end,ColorToTable=function(bJ)return{[a.TypeParameterName]=a.ColorTypeName,r=bJ.r,g=bJ.g,b=bJ.b,a=bJ.a}end,ColorFromTable=function(G)local aQ,M=F(G,a.ColorTypeName)return aQ and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local aQ,M=F(G,a.Vector2TypeName)return aQ and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local aQ,M=F(G,a.Vector3TypeName)return aQ and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local aQ,M=F(G,a.Vector4TypeName)return aQ and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local aQ,M=F(G,a.QuaternionTypeName)return aQ and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ak,c3)local a4=a.NillableIfHasValueOrElse(c3,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ak,json.serialize(a4))end,OnMessage=function(ak,ah)local c4=function(c5,c6,c7)local c8=nil;if c5.type~='comment'and type(c7)=='string'then local c9,a4=pcall(json.parse,c7)if c9 and type(a4)=='table'then c8=a.TableFromSerializable(a4)end end;local c3=c8 and c8 or{[a.MessageValueParameterName]=c7}ah(c5,c6,c3)end;vci.message.On(ak,c4)return{Off=function()if c4 then c4=nil end end}end,OnInstanceMessage=function(ak,ah)local c4=function(c5,c6,c3)local ca=a.InstanceID()if ca~=''and ca==c3[a.InstanceIDParameterName]then ah(c5,c6,c3)end end;return a.OnMessage(ak,c4)end,
GetEffekseerEmitterMap=function(ak)local cb=vci.assets.GetEffekseerEmitters(ak)if not cb then return nil end;local aH={}for n,cc in pairs(cb)do aH[cc.EffectName]=cc end;return aH end,ClientID=function()return j end,ParseTagString=function(P)local cd=string.find(P,'#',1,true)if not cd then return{},P end;local ce={}local cf=string.sub(P,1,cd-1)cd=cd+1;local S=string.len(P)local cg='^[A-Za-z0-9_%-.()!~*\'%%]+'while cd<=S do local ch,ci=string.find(P,cg,cd)if ch then local cj=string.sub(P,ch,ci)local ck=cj;cd=ci+1;if cd<=S and string.sub(P,cd,cd)=='='then cd=cd+1;local cl,cm=string.find(P,cg,cd)if cl then ck=string.sub(P,cl,cm)cd=cm+1 else ck=''end end;ce[cj]=ck end;cd=string.find(P,'#',cd,true)if not cd then break end;cd=cd+1 end;return ce,cf end,CalculateSIPrefix=(function()local cn=9;local co={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local cp=#co;return function(aK)local cq=aK==0 and 0 or a.Clamp(math.floor(math.log(math.abs(aK),1000)),1-cn,cp-cn)return cq==0 and aK or aK/1000^cq,co[cn+cq],cq*3 end end)(),CreateLocalSharedProperties=function(cr,cs)local ct=TimeSpan.FromSeconds(5)local cu='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cv='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(cr)~='string'or string.len(cr)<=0 or type(cs)~='string'or string.len(cs)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cw=_G[cu]if not cw then cw={}_G[cu]=cw end;cw[cs]=vci.me.UnscaledTime;local cx=_G[cr]if not cx then cx={[cv]={}}_G[cr]=cx end;local cy=cx[cv]local self;self={GetLspID=function()return cr end,GetLoadID=function()return cs end,GetProperty=function(z,ag)local q=cx[z]if q==nil then return ag else return q end end,SetProperty=function(z,q)if z==cv then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bH=vci.me.UnscaledTime;local cz=cx[z]cx[z]=q;for cA,ca in pairs(cy)do local ax=cw[ca]if ax and ax+ct>=bH then cA(self,z,q,cz)else cA(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)cy[cA]=nil;cw[ca]=nil end end end,Clear=function()for z,q in pairs(cx)do if z~=cv then self.SetProperty(z,nil)end end end,Each=function(ah)for z,q in pairs(cx)do if z~=cv and ah(q,z,self)==false then return false end end end,AddListener=function(cA)cy[cA]=cs end,RemoveListener=function(cA)cy[cA]=nil end,UpdateAlive=function()cw[cs]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(cB)local cC=1.0;local cD=1000.0;local cE=TimeSpan.FromSeconds(0.02)local cF=0xFFFF;local cG=a.CreateCircularQueue(64)local cH=TimeSpan.FromSeconds(5)local cI=TimeSpan.FromSeconds(30)local cJ=false;local cK=vci.me.Time;local cL=a.Random32()local cM=Vector3.__new(bit32.bor(0x400,bit32.band(cL,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cL,16),0x1FFF)),0.0)cB.SetPosition(cM)cB.SetRotation(Quaternion.identity)cB.SetVelocity(Vector3.zero)cB.SetAngularVelocity(Vector3.zero)cB.AddForce(Vector3.__new(0.0,0.0,cC*cD))local self={Timestep=function()return cE end,Precision=function()return cF end,IsFinished=function()return cJ end,Update=function()if cJ then return cE end;local cN=vci.me.Time-cK;local cO=cN.TotalSeconds;if cO<=Vector3.kEpsilon then return cE end;local cP=cB.GetPosition().z-cM.z;local cQ=cP/cO;local cR=cQ/cD;if cR<=Vector3.kEpsilon then return cE end;cG.Offer(cR)local cS=cG.Size()if cS>=2 and cN>=cH then local cT=0.0;for n=1,cS do cT=cT+cG.Get(n)end;local cU=cT/cS;local cV=0.0;for n=1,cS do cV=cV+(cG.Get(n)-cU)^2 end;local cW=cV/cS;if cW<cF then cF=cW;cE=TimeSpan.FromSeconds(cU)end;if cN>cI then cJ=true;cB.SetPosition(cM)cB.SetRotation(Quaternion.identity)cB.SetVelocity(Vector3.zero)cB.SetAngularVelocity(Vector3.zero)end else cE=TimeSpan.FromSeconds(cR)end;return cE end}return self end,AlignSubItemOrigin=function(cX,cY,cZ)local c_=cX.GetRotation()if not a.QuaternionApproximatelyEquals(cY.GetRotation(),c_)then cY.SetRotation(c_)end;local d0=cX.GetPosition()if not a.VectorApproximatelyEquals(cY.GetPosition(),d0)then cY.SetPosition(d0)end;if cZ then cY.SetVelocity(Vector3.zero)cY.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local d1={}local self;self={Contains=function(d2,d3)return a.NillableIfHasValueOrElse(d1[d2],function(an)return a.NillableHasValue(an[d3])end,function()return false end)end,Add=function(d2,d4,cZ)if not d2 or not d4 then local d5='SubItemGlue.Add: Invalid arguments '..(not d2 and', parent = '..tostring(d2)or'')..(not d4 and', children = '..tostring(d4)or'')error(d5,2)end;local an=a.NillableIfHasValueOrElse(d1[d2],function(d6)return d6 end,function()local d6={}d1[d2]=d6;return d6 end)if type(d4)=='table'then for z,aA in pairs(d4)do an[aA]={velocityReset=not not cZ}end else an[d4]={velocityReset=not not cZ}end end,Remove=function(d2,d3)return a.NillableIfHasValueOrElse(d1[d2],function(an)if a.NillableHasValue(an[d3])then an[d3]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(d2)if a.NillableHasValue(d1[d2])then d1[d2]=nil;return true else return false end end,RemoveAll=function()d1={}return true end,Each=function(ah,d7)return a.NillableIfHasValueOrElse(d7,function(d2)return a.NillableIfHasValue(d1[d2],function(an)for d3,d8 in pairs(an)do if ah(d3,d2,self)==false then return false end end end)end,function()for d2,an in pairs(d1)do if self.Each(ah,d2)==false then return false end end end)end,Update=function(d9)for d2,an in pairs(d1)do local da=d2.GetPosition()local db=d2.GetRotation()for d3,d8 in pairs(an)do if d9 or d3.IsMine then if not a.QuaternionApproximatelyEquals(d3.GetRotation(),db)then d3.SetRotation(db)end;if not a.VectorApproximatelyEquals(d3.GetPosition(),da)then d3.SetPosition(da)end;if d8.velocityReset then d3.SetVelocity(Vector3.zero)d3.SetAngularVelocity(Vector3.zero)end end end end end}return self end,CreateUpdateRoutine=function(dc,dd)return coroutine.wrap(function()local de=TimeSpan.FromSeconds(30)local df=vci.me.UnscaledTime;local dg=df;local bD=vci.me.Time;local dh=true;while true do local ca=a.InstanceID()if ca~=''then break end;local di=vci.me.UnscaledTime;if di-de>df then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;dg=di;bD=vci.me.Time;dh=false;coroutine.yield(100)end;if dh then dg=vci.me.UnscaledTime;bD=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(dd,function(dj)dj()end)while true do local bH=vci.me.Time;local dk=bH-bD;local di=vci.me.UnscaledTime;local dl=di-dg;dc(dk,dl)bD=bH;dg=di;coroutine.yield(100)end end)end,
CreateSlideSwitch=function(dm)local dn=a.NillableValue(dm.colliderItem)local dp=a.NillableValue(dm.baseItem)local dq=a.NillableValue(dm.knobItem)local dr=a.NillableValueOrDefault(dm.minValue,0)local ds=a.NillableValueOrDefault(dm.maxValue,10)if dr>=ds then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local dt=(dr+ds)*0.5;local du=function(aA)local dv,dw=a.PingPong(aA-dr,ds-dr)return dv+dr,dw end;local q=du(a.NillableValueOrDefault(dm.value,0))local dx=a.NillableIfHasValueOrElse(dm.tickFrequency,function(dy)if dy<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(dy,ds-dr)end,function()return(ds-dr)/10.0 end)local dz=a.NillableIfHasValueOrElse(dm.tickVector,function(b0)return Vector3.__new(b0.x,b0.y,b0.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local dA=dz.magnitude;if dA<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local dB=a.NillableValueOrDefault(dm.snapToTick,true)local dC=TimeSpan.FromMilliseconds(1000)local dD=TimeSpan.FromMilliseconds(50)local dE,dF;local cy={}local self;local dG=false;local dH=0;local dI=false;local dJ=TimeSpan.Zero;local dK=TimeSpan.Zero;local dL=function()local dM=du(dE())if dM~=q then q=dM;for cA,E in pairs(cy)do cA(self,q)end end;dq.SetLocalPosition((dM-dt)/dx*dz)end;local dN=function()local dO=dE()local dP,dQ=du(dO)local dR=dO+dx;local dS,dT=du(dR)assert(dS)local dM;if dQ==dT or dP==ds or dP==dr then dM=dR else dM=dQ>=0 and ds or dr end;dK=vci.me.UnscaledTime;if dM==ds or dM==dr then dJ=dK end;dF(dM)end;a.NillableIfHasValueOrElse(dm.lsp,function(dU)if not a.NillableHasValue(dm.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local dV=a.NillableValue(dm.propertyName)dE=function()return dU.GetProperty(dV,q)end;dF=function(aA)dU.SetProperty(dV,aA)end;dU.AddListener(function(ao,z,dW,dX)if z==dV then dL()end end)end,function()local dW=q;dE=function()return dW end;dF=function(aA)dW=aA;dL()end end)self={GetColliderItem=function()return dn end,GetBaseItem=function()return dp end,GetKnobItem=function()return dq end,GetMinValue=function()return dr end,GetMaxValue=function()return ds end,GetValue=function()return q end,SetValue=function(aA)dF(du(aA))end,GetTickFrequency=function()return dx end,IsSnapToTick=function()return dB end,AddListener=function(cA)cy[cA]=cA end,RemoveListener=function(cA)cy[cA]=nil end,DoUse=function()if not dG then dI=true;dJ=vci.me.UnscaledTime;dN()end end,DoUnuse=function()dI=false end,DoGrab=function()if not dI then dG=true;dH=(q-dt)/dx end end,DoUngrab=function()dG=false end,Update=function()if dG then local dY=dn.GetPosition()-dp.GetPosition()local dZ=dq.GetRotation()*dz;local d_=Vector3.Project(dY,dZ)local e0=(Vector3.Dot(dZ,d_)>=0 and 1 or-1)*d_.magnitude/dA+dH;local e1=(dB and a.Round(e0)or e0)*dx+dt;local dM=a.Clamp(e1,dr,ds)if dM~=q then dF(dM)end elseif dI then local e2=vci.me.UnscaledTime;if e2>=dJ+dC and e2>=dK+dD then dN()end elseif dn.IsMine then a.AlignSubItemOrigin(dp,dn)end end}dL()return self end,CreateSubItemConnector=function()local e3=function(e4,cY,e5)e4.item=cY;e4.position=cY.GetPosition()e4.rotation=cY.GetRotation()e4.initialPosition=e4.position;e4.initialRotation=e4.rotation;e4.propagation=not not e5;return e4 end;local e6=function(e7)for cY,e4 in pairs(e7)do e3(e4,cY,e4.propagation)end end;local e8=function(e9,bf,e4,ea,eb)local dY=e9-e4.initialPosition;local ec=bf*Quaternion.Inverse(e4.initialRotation)e4.position=e9;e4.rotation=bf;for cY,ed in pairs(ea)do if cY~=e4.item and(not eb or eb(ed))then ed.position,ed.rotation=a.RotateAround(ed.initialPosition+dY,ed.initialRotation,e9,ec)cY.SetPosition(ed.position)cY.SetRotation(ed.rotation)end end end;local ee={}local ef=true;local eg=false;local self;self={IsEnabled=function()return ef end,SetEnabled=function(aC)ef=aC;if aC then e6(ee)eg=false end end,Contains=function(eh)return a.NillableHasValue(ee[eh])end,Add=function(ei,ej)if not ei then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(ei),2)end;local ek=type(ei)=='table'and ei or{ei}e6(ee)eg=false;for N,cY in pairs(ek)do ee[cY]=e3({},cY,not ej)end end,Remove=function(eh)local aQ=a.NillableHasValue(ee[eh])ee[eh]=nil;return aQ end,RemoveAll=function()ee={}return true end,Each=function(ah)for cY,e4 in pairs(ee)do if ah(cY,self)==false then return false end end end,GetItems=function()local ek={}for cY,e4 in pairs(ee)do table.insert(ek,cY)end;return ek end,Update=function()if not ef then return end;local el=false;for cY,e4 in pairs(ee)do local cd=cY.GetPosition()local em=cY.GetRotation()if not a.VectorApproximatelyEquals(cd,e4.position)or not a.QuaternionApproximatelyEquals(em,e4.rotation)then if e4.propagation then if cY.IsMine then e8(cd,em,ee[cY],ee,function(ed)if ed.item.IsMine then return true else eg=true;return false end end)el=true;break else eg=true end else eg=true end end end;if not el and eg then e6(ee)eg=false end end}return self end,GetSubItemTransform=function(eh)local e9=eh.GetPosition()local bf=eh.GetRotation()local en=eh.GetLocalScale()return{positionX=e9.x,positionY=e9.y,positionZ=e9.z,rotationX=bf.x,rotationY=bf.y,rotationZ=bf.z,rotationW=bf.w,scaleX=en.x,scaleY=en.y,scaleZ=en.z}end,RestoreCytanbTransform=function(eo)local cd=eo.positionX and eo.positionY and eo.positionZ and Vector3.__new(eo.positionX,eo.positionY,eo.positionZ)or nil;local em=eo.rotationX and eo.rotationY and eo.rotationZ and eo.rotationW and Quaternion.__new(eo.rotationX,eo.rotationY,eo.rotationZ,eo.rotationW)or nil;local en=eo.scaleX and eo.scaleY and eo.scaleZ and Vector3.__new(eo.scaleX,eo.scaleY,eo.scaleZ)or nil;return cd,em,en end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local cr='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local cx=_G[cr]if not cx then cx={}_G[cr]=cx end;local ep=cx.randomSeedValue;if not ep then ep=os.time()-os.clock()*10000;cx.randomSeedValue=ep;math.randomseed(ep)end;local eq=cx.clientID;if type(eq)~='string'then eq=tostring(a.RandomUUID())cx.clientID=eq end;local er=vci.state.Get(b)or''if er==''and vci.assets.IsMine then er=tostring(a.RandomUUID())vci.state.Set(b,er)end;return er,eq end)()return a end)()

local vciLoaded = false

local UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        if deltaTime <= TimeSpan.Zero then
            return
        end
    end,
    function ()
        cytanb.LogTrace('OnLoad')
        vciLoaded = true

        local goal = vci.assets.GetSubItem('cgoal')
        print(tostring(goal.GetPosition()))
    end
)

updateAll = function ()
    UpdateCw()
end

onGrab = function (target)
    if not vciLoaded then
        return
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
end
