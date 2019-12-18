-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(af)return af~=nil end,NillableValue=function(af)if af==nil then error('nillable: value is nil',2)end;return af end,NillableValueOrDefault=function(af,ag)if af==nil then if ag==nil then error('nillable: defaultValue is nil',2)end;return ag else return af end end,NillableIfHasValue=function(af,ah)if af==nil then return nil else return ah(af)end end,NillableIfHasValueOrElse=function(af,ah,ai)if af==nil then return ai()else return ah(af)end end,SetConst=function(aj,ak,q)if type(aj)~='table'then error('Cannot set const to non-table target',2)end;local al=getmetatable(aj)local A=al or{}local am=rawget(A,x)if rawget(aj,ak)~=nil then error('Non-const field "'..ak..'" already exists',2)end;if not am then am={}rawset(A,x,am)A.__index=y;A.__newindex=D end;rawset(am,ak,q)if not al then setmetatable(aj,A)end;return aj end,SetConstEach=function(aj,an)for N,E in pairs(an)do a.SetConst(aj,N,E)end;return aj end,Extend=function(aj,ao,ap,aq,a3)if aj==ao or type(aj)~='table'or type(ao)~='table'then return aj end;if ap then if not a3 then a3={}end;if a3[ao]then error('circular reference')end;a3[ao]=true end;for N,E in pairs(ao)do if ap and type(E)=='table'then local ar=aj[N]aj[N]=a.Extend(type(ar)=='table'and ar or{},E,ap,aq,a3)else aj[N]=E end end;if not aq then local as=getmetatable(ao)if type(as)=='table'then if ap then local at=getmetatable(aj)setmetatable(aj,a.Extend(type(at)=='table'and at or{},as,true))else setmetatable(aj,as)end end end;if ap then a3[ao]=nil end;return aj end,Vars=function(E,au,av,a3)local aw;if au then aw=au~='__NOLF'else au='  'aw=true end;if not av then av=''end;if not a3 then a3={}end;local ax=type(E)if ax=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local ay=aw and av..au or''local P='('..tostring(E)..') {'local az=true;for z,aA in pairs(E)do if az then az=false else P=P..(aw and','or', ')end;if aw then P=P..'\n'..ay end;if type(aA)=='table'and a3[aA]and a3[aA]>0 then P=P..z..' = ('..tostring(aA)..')'else P=P..z..' = '..a.Vars(aA,au,ay,a3)end end;if not az and aw then P=P..'\n'..av end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif ax=='function'or ax=='thread'or ax=='userdata'then return'('..ax..')'elseif ax=='string'then return'('..ax..') '..string.format('%q',E)else return'('..ax..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aB)f=aB end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aC)g=not not aC end,Log=function(aB,...)if aB<=f then local aD=g and(h[aB]or'LOG LEVEL '..tostring(aB))..' | 'or''local aE=table.pack(...)if aE.n==1 then local E=aE[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aD..P or P)else print(aD)end else local P=aD;for n=1,aE.n do local E=aE[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aF,aG)local table={}local aH=aG==nil;for N,E in pairs(aF)do table[E]=aH and E or aG end;return table end,Round=function(aI,aJ)if aJ then local aK=10^aJ;return math.floor(aI*aK+0.5)/aK else return math.floor(aI+0.5)end end,Clamp=function(q,aL,aM)return math.max(aL,math.min(q,aM))end,Lerp=function(aN,aO,ax)if ax<=0.0 then return aN elseif ax>=1.0 then return aO else return aN+(aO-aN)*ax end end,LerpUnclamped=function(aN,aO,ax)if ax==0.0 then return aN elseif ax==1.0 then return aO else return aN+(aO-aN)*ax end end,PingPong=function(ax,aP)if aP==0 then return 0,1 end;local aQ=math.floor(ax/aP)local aR=ax-aQ*aP;if aQ<0 then if(aQ+1)%2==0 then return aP-aR,-1 else return aR,1 end else if aQ%2==0 then return aR,1 else return aP-aR,-1 end end end,VectorApproximatelyEquals=function(aS,aT)return(aS-aT).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aS,aT)local aU=Quaternion.Dot(aS,aT)return aU<1.0+1E-06 and aU>1.0-1E-06 end,
QuaternionToAngleAxis=function(aV)local aQ=aV.normalized;local aW=math.acos(aQ.w)local aX=math.sin(aW)local aY=math.deg(aW*2.0)local aZ;if math.abs(aX)<=Quaternion.kEpsilon then aZ=Vector3.right else local a_=1.0/aX;aZ=Vector3.__new(aQ.x*a_,aQ.y*a_,aQ.z*a_)end;return aY,aZ end,ApplyQuaternionToVector3=function(aV,b0)local b1=aV.w*b0.x+aV.y*b0.z-aV.z*b0.y;local b2=aV.w*b0.y-aV.x*b0.z+aV.z*b0.x;local b3=aV.w*b0.z+aV.x*b0.y-aV.y*b0.x;local b4=-aV.x*b0.x-aV.y*b0.y-aV.z*b0.z;return Vector3.__new(b4*-aV.x+b1*aV.w+b2*-aV.z-b3*-aV.y,b4*-aV.y-b1*-aV.z+b2*aV.w+b3*-aV.x,b4*-aV.z+b1*-aV.y-b2*-aV.x+b3*aV.w)end,RotateAround=function(b5,b6,b7,b8)return b7+a.ApplyQuaternionToVector3(b8,b5-b7),b8*b6 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(b9)return p.__tostring(b9)end,UUIDFromNumbers=function(...)local ba=...local ax=type(ba)local bb,bc,bd,be;if ax=='table'then bb=ba[1]bc=ba[2]bd=ba[3]be=ba[4]else bb,bc,bd,be=...end;local b9={bit32.band(bb or 0,0xFFFFFFFF),bit32.band(bc or 0,0xFFFFFFFF),bit32.band(bd or 0,0xFFFFFFFF),bit32.band(be or 0,0xFFFFFFFF)}setmetatable(b9,p)return b9 end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bf='[0-9a-f-A-F]+'local bg='^('..bf..')$'local bh='^-('..bf..')$'local bi,bj,bk,bl;if S==32 then local b9=a.UUIDFromNumbers(0,0,0,0)local bm=1;for n,bn in ipairs({8,16,24,32})do bi,bj,bk=string.find(string.sub(P,bm,bn),bg)if not bi then return nil end;b9[n]=tonumber(bk,16)bm=bn+1 end;return b9 else bi,bj,bk=string.find(string.sub(P,1,8),bg)if not bi then return nil end;local bb=tonumber(bk,16)bi,bj,bk=string.find(string.sub(P,9,13),bh)if not bi then return nil end;bi,bj,bl=string.find(string.sub(P,14,18),bh)if not bi then return nil end;local bc=tonumber(bk..bl,16)bi,bj,bk=string.find(string.sub(P,19,23),bh)if not bi then return nil end;bi,bj,bl=string.find(string.sub(P,24,28),bh)if not bi then return nil end;local bd=tonumber(bk..bl,16)bi,bj,bk=string.find(string.sub(P,29,36),bg)if not bi then return nil end;local be=tonumber(bk,16)return a.UUIDFromNumbers(bb,bc,bd,be)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bo)if type(bo)~='number'or bo<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bo),2)end;local self;local bp=math.floor(bo)local U={}local bq=0;local br=0;local bs=0;self={Size=function()return bs end,Clear=function()bq=0;br=0;bs=0 end,IsEmpty=function()return bs==0 end,Offer=function(bt)U[bq+1]=bt;bq=(bq+1)%bp;if bs<bp then bs=bs+1 else br=(br+1)%bp end;return true end,OfferFirst=function(bt)br=(bp+br-1)%bp;U[br+1]=bt;if bs<bp then bs=bs+1 else bq=(bp+bq-1)%bp end;return true end,Poll=function()if bs==0 then return nil else local bt=U[br+1]br=(br+1)%bp;bs=bs-1;return bt end end,PollLast=function()if bs==0 then return nil else bq=(bp+bq-1)%bp;local bt=U[bq+1]bs=bs-1;return bt end end,Peek=function()if bs==0 then return nil else return U[br+1]end end,PeekLast=function()if bs==0 then return nil else return U[(bp+bq-1)%bp+1]end end,Get=function(bu)if bu<1 or bu>bs then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bu)return nil end;return U[(br+bu-1)%bp+1]end,IsFull=function()return bs>=bp end,MaxSize=function()return bp end}return self end,DetectClicks=function(bv,bw,bx)local by=bv or 0;local bz=bx or TimeSpan.FromMilliseconds(500)local bA=vci.me.Time;local bB=bw and bA>bw+bz and 1 or by+1;return bB,bA end,ColorRGBToHSV=function(bC)local aR=math.max(0.0,math.min(bC.r,1.0))local bD=math.max(0.0,math.min(bC.g,1.0))local aO=math.max(0.0,math.min(bC.b,1.0))local aM=math.max(aR,bD,aO)local aL=math.min(aR,bD,aO)local bE=aM-aL;local C;if bE==0.0 then C=0.0 elseif aM==aR then C=(bD-aO)/bE/6.0 elseif aM==bD then C=(2.0+(aO-aR)/bE)/6.0 else C=(4.0+(aR-bD)/bE)/6.0 end;if C<0.0 then C=C+1.0 end;local bF=aM==0.0 and bE or bE/aM;local E=aM;return C,bF,E end,ColorFromARGB32=function(bG)local bH=type(bG)=='number'and bG or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bH,16),0xFF)/0xFF,bit32.band(bit32.rshift(bH,8),0xFF)/0xFF,bit32.band(bH,0xFF)/0xFF,bit32.band(bit32.rshift(bH,24),0xFF)/0xFF)end,ColorToARGB32=function(bC)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bC.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bC.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bC.g),0xFF),8),bit32.band(a.Round(0xFF*bC.b),0xFF))end,ColorFromIndex=function(bI,bJ,bK,bL,bM)local bN=math.max(math.floor(bJ or a.ColorHueSamples),1)local bO=bM and bN or bN-1;local bP=math.max(math.floor(bK or a.ColorSaturationSamples),1)local bQ=math.max(math.floor(bL or a.ColorBrightnessSamples),1)local bu=a.Clamp(math.floor(bI or 0),0,bN*bP*bQ-1)local bR=bu%bN;local bS=math.floor(bu/bN)local a_=bS%bP;local bT=math.floor(bS/bP)if bM or bR~=bO then local C=bR/bO;local bF=(bP-a_)/bP;local E=(bQ-bT)/bQ;return Color.HSVToRGB(C,bF,E)else local E=(bQ-bT)/bQ*a_/(bP-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bC,bJ,bK,bL,bM)local bN=math.max(math.floor(bJ or a.ColorHueSamples),1)local bO=bM and bN or bN-1;local bP=math.max(math.floor(bK or a.ColorSaturationSamples),1)local bQ=math.max(math.floor(bL or a.ColorBrightnessSamples),1)local C,bF,E=a.ColorRGBToHSV(bC)local a_=a.Round(bP*(1.0-bF))if bM or a_<bP then local bU=a.Round(bO*C)if bU>=bO then bU=0 end;if a_>=bP then a_=bP-1 end;local bT=math.min(bQ-1,a.Round(bQ*(1.0-E)))return bU+bN*(a_+bP*bT)else local bV=a.Round((bP-1)*E)if bV==0 then local bW=a.Round(bQ*(1.0-E))if bW>=bQ then return bN-1 else return bN*(1+a.Round(E*(bP-1)/(bQ-bW)*bQ)+bP*bW)-1 end else return bN*(1+bV+bP*a.Round(bQ*(1.0-E*(bP-1)/bV)))-1 end end end,ColorToTable=function(bC)return{[a.TypeParameterName]=a.ColorTypeName,r=bC.r,g=bC.g,b=bC.b,a=bC.a}end,ColorFromTable=function(G)local aO,M=F(G,a.ColorTypeName)return aO and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local aO,M=F(G,a.Vector2TypeName)return aO and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local aO,M=F(G,a.Vector3TypeName)return aO and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local aO,M=F(G,a.Vector4TypeName)return aO and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local aO,M=F(G,a.QuaternionTypeName)return aO and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ak,bX)local a4=a.NillableIfHasValueOrElse(bX,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ak,json.serialize(a4))end,OnMessage=function(ak,ah)local bY=function(bZ,b_,c0)local c1=nil;if bZ.type~='comment'and type(c0)=='string'then local c2,a4=pcall(json.parse,c0)if c2 and type(a4)=='table'then c1=a.TableFromSerializable(a4)end end;local bX=c1 and c1 or{[a.MessageValueParameterName]=c0}ah(bZ,b_,bX)end;vci.message.On(ak,bY)return{Off=function()if bY then bY=nil end end}end,OnInstanceMessage=function(ak,ah)local bY=function(bZ,b_,bX)local c3=a.InstanceID()if c3~=''and c3==bX[a.InstanceIDParameterName]then ah(bZ,b_,bX)end end;return a.OnMessage(ak,bY)end,
GetEffekseerEmitterMap=function(ak)local c4=vci.assets.GetEffekseerEmitters(ak)if not c4 then return nil end;local c5={}for n,c6 in pairs(c4)do c5[c6.EffectName]=c6 end;return c5 end,ClientID=function()return j end,CreateLocalSharedProperties=function(c7,c8)local c9=TimeSpan.FromSeconds(5)local ca='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cb='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(c7)~='string'or string.len(c7)<=0 or type(c8)~='string'or string.len(c8)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cc=_G[ca]if not cc then cc={}_G[ca]=cc end;cc[c8]=vci.me.UnscaledTime;local cd=_G[c7]if not cd then cd={[cb]={}}_G[c7]=cd end;local ce=cd[cb]local self;self={GetLspID=function()return c7 end,GetLoadID=function()return c8 end,GetProperty=function(z,ag)local q=cd[z]if q==nil then return ag else return q end end,SetProperty=function(z,q)if z==cb then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bA=vci.me.UnscaledTime;local cf=cd[z]cd[z]=q;for cg,c3 in pairs(ce)do local ax=cc[c3]if ax and ax+c9>=bA then cg(self,z,q,cf)else cg(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)ce[cg]=nil;cc[c3]=nil end end end,AddListener=function(cg)ce[cg]=c8 end,RemoveListener=function(cg)ce[cg]=nil end,UpdateAlive=function()cc[c8]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(ch)local ci=1.0;local cj=1000.0;local ck=TimeSpan.FromSeconds(0.02)local cl=0xFFFF;local cm=a.CreateCircularQueue(64)local cn=TimeSpan.FromSeconds(5)local co=TimeSpan.FromSeconds(30)local cp=false;local cq=vci.me.Time;local cr=a.Random32()local cs=Vector3.__new(bit32.bor(0x400,bit32.band(cr,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cr,16),0x1FFF)),0.0)ch.SetPosition(cs)ch.SetRotation(Quaternion.identity)ch.SetVelocity(Vector3.zero)ch.SetAngularVelocity(Vector3.zero)ch.AddForce(Vector3.__new(0.0,0.0,ci*cj))local self={Timestep=function()return ck end,Precision=function()return cl end,IsFinished=function()return cp end,Update=function()if cp then return ck end;local ct=vci.me.Time-cq;local cu=ct.TotalSeconds;if cu<=Vector3.kEpsilon then return ck end;local cv=ch.GetPosition().z-cs.z;local cw=cv/cu;local cx=cw/cj;if cx<=Vector3.kEpsilon then return ck end;cm.Offer(cx)local cy=cm.Size()if cy>=2 and ct>=cn then local cz=0.0;for n=1,cy do cz=cz+cm.Get(n)end;local cA=cz/cy;local cB=0.0;for n=1,cy do cB=cB+(cm.Get(n)-cA)^2 end;local cC=cB/cy;if cC<cl then cl=cC;ck=TimeSpan.FromSeconds(cA)end;if ct>co then cp=true;ch.SetPosition(cs)ch.SetRotation(Quaternion.identity)ch.SetVelocity(Vector3.zero)ch.SetAngularVelocity(Vector3.zero)end else ck=TimeSpan.FromSeconds(cx)end;return ck end}return self end,AlignSubItemOrigin=function(cD,cE,cF)local cG=cD.GetRotation()if not a.QuaternionApproximatelyEquals(cE.GetRotation(),cG)then cE.SetRotation(cG)end;local cH=cD.GetPosition()if not a.VectorApproximatelyEquals(cE.GetPosition(),cH)then cE.SetPosition(cH)end;if cF then cE.SetVelocity(Vector3.zero)cE.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local cI={}local self;self={Contains=function(cJ,cK)return a.NillableIfHasValueOrElse(cI[cJ],function(an)return a.NillableHasValue(an[cK])end,function()return false end)end,Add=function(cJ,cL,cF)if not cJ or not cL then local cM='SubItemGlue.Add: Invalid arguments '..(not cJ and', parent = '..tostring(cJ)or'')..(not cL and', children = '..tostring(cL)or'')error(cM,2)end;local an=a.NillableIfHasValueOrElse(cI[cJ],function(cN)return cN end,function()local cN={}cI[cJ]=cN;return cN end)if type(cL)=='table'then for z,aA in pairs(cL)do an[aA]={velocityReset=not not cF}end else an[cL]={velocityReset=not not cF}end end,Remove=function(cJ,cK)return a.NillableIfHasValueOrElse(cI[cJ],function(an)if a.NillableHasValue(an[cK])then an[cK]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(cJ)if a.NillableHasValue(cI[cJ])then cI[cJ]=nil;return true else return false end end,RemoveAll=function()cI={}return true end,Each=function(ah,cO)return a.NillableIfHasValueOrElse(cO,function(cJ)return a.NillableIfHasValue(cI[cJ],function(an)for cK,cP in pairs(an)do if ah(cK,cJ,self)==false then return false end end end)end,function()for cJ,an in pairs(cI)do if self.Each(ah,cJ)==false then return false end end end)end,Update=function(cQ)for cJ,an in pairs(cI)do local cR=cJ.GetPosition()local cS=cJ.GetRotation()for cK,cP in pairs(an)do if cQ or cK.IsMine then if not a.QuaternionApproximatelyEquals(cK.GetRotation(),cS)then cK.SetRotation(cS)end;if not a.VectorApproximatelyEquals(cK.GetPosition(),cR)then cK.SetPosition(cR)end;if cP.velocityReset then cK.SetVelocity(Vector3.zero)cK.SetAngularVelocity(Vector3.zero)end end end end end}return self end,
CreateSlideSwitch=function(cT)local cU=a.NillableValue(cT.colliderItem)local cV=a.NillableValue(cT.baseItem)local cW=a.NillableValue(cT.knobItem)local cX=a.NillableValueOrDefault(cT.minValue,0)local cY=a.NillableValueOrDefault(cT.maxValue,10)if cX>=cY then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local cZ=cY-cX;local c_=function(aA)local d0,d1=a.PingPong(aA-cX,cZ)return d0+cX,d1 end;local q=c_(a.NillableValueOrDefault(cT.value,0))local d2=a.NillableIfHasValueOrElse(cT.tickFrequency,function(d3)if d3<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(d3,cZ)end,function()return cZ/10.0 end)local d4=a.NillableIfHasValueOrElse(cT.tickVector,function(aZ)return Vector3.__new(aZ.x,aZ.y,aZ.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local d5=d4.magnitude;if d5<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local d6=a.NillableValueOrDefault(cT.snapToTick,true)local d7=TimeSpan.FromMilliseconds(1000)local d8=TimeSpan.FromMilliseconds(50)local d9,da;local ce={}local self;local db=false;local dc=false;local dd=TimeSpan.Zero;local de=TimeSpan.Zero;local df=Vector3.zero;local dg=function()local dh=c_(d9())if dh~=q then q=dh;for cg,E in pairs(ce)do cg(self,q)end end;local di=(dh-cX-cZ*0.5)/d2*d4;cW.SetPosition(cV.GetPosition()+cW.GetRotation()*di)end;local dj=function()local dk=d9()local dl,dm=c_(dk)local dn=dk+d2;local dp,dq=c_(dn)assert(dp)local dh;if dm==dq or dl==cY or dl==cX then dh=dn else dh=dm>=0 and cY or cX end;de=vci.me.UnscaledTime;if dh==cY or dh==cX then dd=de end;da(dh)end;a.NillableIfHasValueOrElse(cT.lsp,function(dr)if not a.NillableHasValue(cT.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local ds=a.NillableValue(cT.propertyName)d9=function()return dr.GetProperty(ds,q)end;da=function(aA)dr.SetProperty(ds,aA)end;dr.AddListener(function(ao,z,dt,du)if z==ds then dg()end end)end,function()local dt=q;d9=function()return dt end;da=function(aA)dt=aA;dg()end end)self={GetColliderItem=function()return cU end,GetBaseItem=function()return cV end,GetKnobItem=function()return cW end,GetMinValue=function()return cX end,GetMaxValue=function()return cY end,GetValue=function()return q end,SetValue=function(aA)da(c_(aA))end,GetTickFrequency=function()return d2 end,IsSnapToTick=function()return d6 end,AddListener=function(cg)ce[cg]=cg end,RemoveListener=function(cg)ce[cg]=nil end,DoUse=function()dc=true;dd=vci.me.UnscaledTime;dj()end,DoUnuse=function()dc=false end,DoGrab=function()db=true;df=cW.GetPosition()-cV.GetPosition()end,DoUngrab=function()db=false end,Update=function()if db then local dv=cU.GetPosition()-cV.GetPosition()+df;local dw=cW.GetRotation()*d4;local dx=Vector3.Project(dv,dw)local dy=(Vector3.Dot(d4,dx)>=0 and 1 or-1)*dx.magnitude/d5;local dz=(d6 and a.Round(dy)or dy)*d2+(cX+cY)*0.5;local dh=a.Clamp(dz,cX,cY)if dh~=q then da(dh)end elseif dc then local dA=vci.me.UnscaledTime;if dA>=dd+d7 and dA>=de+d8 then dj()end elseif cU.IsMine then a.AlignSubItemOrigin(cV,cU)end end}dg()return self end,CreateSubItemConnector=function()local dB=function(dC,cE,dD)dC.item=cE;dC.position=cE.GetPosition()dC.rotation=cE.GetRotation()dC.initialPosition=dC.position;dC.initialRotation=dC.rotation;dC.propagation=not not dD;return dC end;local dE=function(dF)for cE,dC in pairs(dF)do dB(dC,cE,dC.propagation)end end;local dG=function(dH,b8,dC,dI,dJ)local dv=dH-dC.initialPosition;local dK=b8*Quaternion.Inverse(dC.initialRotation)dC.position=dH;dC.rotation=b8;for cE,dL in pairs(dI)do if cE~=dC.item and(not dJ or dJ(dL))then dL.position,dL.rotation=a.RotateAround(dL.initialPosition+dv,dL.initialRotation,dH,dK)cE.SetPosition(dL.position)cE.SetRotation(dL.rotation)end end end;local dM={}local dN=true;local dO=false;local self;self={IsEnabled=function()return dN end,SetEnabled=function(aC)dN=aC;if aC then dE(dM)dO=false end end,Contains=function(dP)return a.NillableHasValue(dM[dP])end,Add=function(dQ,dR)if not dQ then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(dQ),2)end;local dS=type(dQ)=='table'and dQ or{dQ}dE(dM)dO=false;for N,cE in pairs(dS)do dM[cE]=dB({},cE,not dR)end end,Remove=function(dP)local aO=a.NillableHasValue(dM[dP])dM[dP]=nil;return aO end,RemoveAll=function()dM={}return true end,Each=function(ah)for cE,dC in pairs(dM)do if ah(cE,self)==false then return false end end end,GetItems=function()local dS={}for cE,dC in pairs(dM)do table.insert(dS,cE)end;return dS end,Update=function()if not dN then return end;local dT=false;for cE,dC in pairs(dM)do local dU=cE.GetPosition()local dV=cE.GetRotation()if not a.VectorApproximatelyEquals(dU,dC.position)or not a.QuaternionApproximatelyEquals(dV,dC.rotation)then if dC.propagation then if cE.IsMine then dG(dU,dV,dM[cE],dM,function(dL)if dL.item.IsMine then return true else dO=true;return false end end)dT=true;break else dO=true end else dO=true end end end;if not dT and dO then dE(dM)dO=false end end}return self end,GetSubItemTransform=function(dP)local dH=dP.GetPosition()local b8=dP.GetRotation()local dW=dP.GetLocalScale()return{positionX=dH.x,positionY=dH.y,positionZ=dH.z,rotationX=b8.x,rotationY=b8.y,rotationZ=b8.z,rotationW=b8.w,scaleX=dW.x,scaleY=dW.y,scaleZ=dW.z}end,RestoreCytanbTransform=function(dX)local dU=dX.positionX and dX.positionY and dX.positionZ and Vector3.__new(dX.positionX,dX.positionY,dX.positionZ)or nil;local dV=dX.rotationX and dX.rotationY and dX.rotationZ and dX.rotationW and Quaternion.__new(dX.rotationX,dX.rotationY,dX.rotationZ,dX.rotationW)or nil;local dW=dX.scaleX and dX.scaleY and dX.scaleZ and Vector3.__new(dX.scaleX,dX.scaleY,dX.scaleZ)or nil;return dU,dV,dW end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local c7='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local cd=_G[c7]if not cd then cd={}_G[c7]=cd end;local dY=cd.randomSeedValue;if not dY then dY=os.time()-os.clock()*10000;cd.randomSeedValue=dY;math.randomseed(dY)end;local dZ=cd.clientID;if type(dZ)~='string'then dZ=tostring(a.RandomUUID())cd.clientID=dZ end;local d_=vci.state.Get(b)or''if d_==''and vci.assets.IsMine then d_=tostring(a.RandomUUID())vci.state.Set(b,d_)end;return d_,dZ end)()return a end)()

local settings = (function ()
    local cballSettingsLspid = 'ae00bdfc-98ec-4fbf-84a6-1a52823cfe69'

    return {
        enableDebugging = false,
        lsp = cytanb.CreateLocalSharedProperties(cballSettingsLspid, tostring(cytanb.RandomUUID())),
        throwableTag = '#cytanb-throwable',
        ballTag = '#cytanb-ball',
        ignoreTag = '#cytanb-ignore',
        panelCount = 9,
        panelBaseName = 'nine-panel-base#cytanb-ignore',
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
local resetSwitch
local slideSwitchMap

local breakEfkContainer, breakEfk

-- パネルのフレームがつかまれているか
local panelBaseGrabbed = false

-- パネルの傾きが変更されていることを示すフラグ
local panelBaseTiltChanged = false

-- 最後にパネルの傾きを送った時間
local lastPanelBaseTiltSendTime = TimeSpan.MinValue

-- 最後にパネルを直した時間。
local lastPanelMendedTime = TimeSpan.Zero

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
        tiltAngle = slideSwitchMap[settings.tiltSwitchName].GetValue()
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
    if panelBaseGrabbed or not panel.active then
        return false
    end

    cytanb.LogTrace('break-panel: ', panel.name)

    panel.active = false
    panel.inactiveTime = vci.me.UnscaledTime

    local posItem = panel.posItem
    breakEfkContainer.SetPosition(posItem.GetPosition())
    breakEfkContainer.SetRotation(posItem.GetRotation())
    breakEfk.Play()

    local audioVolume = slideSwitchMap[settings.audioVolumeSwitchName].GetValue()
    if audioVolume > 0 then
        vci.assets.audio.Play(settings.breakPanelAudioName, audioVolume / settings.audioVolumeMaxValue, false)
    end

    ShowPanelMesh(panel, false)

    local item = panel.item
    if item.IsMine then
        item.SetPosition(hiddenPosition + posItem.GetLocalPosition())
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

    local posItem = panel.posItem
    local item = panel.item

    if item.IsMine then
        cytanb.AlignSubItemOrigin(posItem, item, true)
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
    local volumeSwitch = cytanb.CreateSlideSwitch({
        colliderItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.audioVolumeSwitchName)),
        knobItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.audioVolumeKnobName)),
        baseItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.audioVolumeKnobPos)),
        tickVector = settings.tickVector,
        minValue = settings.audioVolumeMinValue,
        maxValue = settings.audioVolumeMaxValue,
        lsp = settings.lsp,
        propertyName = settings.audioVolumePropertyName
    })
    volumeSwitch.AddListener(function (source, value)
        cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
    end)
    slideSwitchMap[settings.audioVolumeSwitchName] = volumeSwitch

    local tiltSwitch = cytanb.CreateSlideSwitch({
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
            cytanb.LogInfo('lsp: expired')
            -- 期限切れとなったので、アンロード処理をする
            vciLoaded = false
        end
    end)

    local OnChangePanelBase = function (parameterMap)
        cytanb.LogTrace('OnChangePanelBase')
        cytanb.NillableIfHasValue(parameterMap.panelBase, function (base)
            cytanb.NillableIfHasValue(base.tiltAngle, function (tiltAngle)
                slideSwitchMap[settings.tiltSwitchName].SetValue(tiltAngle)
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
    SetPanelBaseTilt(slideSwitchMap[settings.tiltSwitchName].GetValue())

    if vci.assets.IsMine then
        cytanb.OnInstanceMessage(queryStatusMessageName, function (sender, name, parameterMap)
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
    else
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

        cytanb.EmitMessage(queryStatusMessageName)
    end
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

    if not panelBaseGrabbed and IsHitSource(hit) then
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
