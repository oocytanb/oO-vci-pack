-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(af)return af~=nil end,NillableValue=function(af)if af==nil then error('nillable: value is nil',2)end;return af end,NillableValueOrDefault=function(af,ag)if af==nil then if ag==nil then error('nillable: defaultValue is nil',2)end;return ag else return af end end,NillableIfHasValue=function(af,ah)if af==nil then return nil else return ah(af)end end,NillableIfHasValueOrElse=function(af,ah,ai)if af==nil then return ai()else return ah(af)end end,SetConst=function(aj,ak,q)if type(aj)~='table'then error('Cannot set const to non-table target',2)end;local al=getmetatable(aj)local A=al or{}local am=rawget(A,x)if rawget(aj,ak)~=nil then error('Non-const field "'..ak..'" already exists',2)end;if not am then am={}rawset(A,x,am)A.__index=y;A.__newindex=D end;rawset(am,ak,q)if not al then setmetatable(aj,A)end;return aj end,SetConstEach=function(aj,an)for N,E in pairs(an)do a.SetConst(aj,N,E)end;return aj end,Extend=function(aj,ao,ap,aq,a3)if aj==ao or type(aj)~='table'or type(ao)~='table'then return aj end;if ap then if not a3 then a3={}end;if a3[ao]then error('circular reference')end;a3[ao]=true end;for N,E in pairs(ao)do if ap and type(E)=='table'then local ar=aj[N]aj[N]=a.Extend(type(ar)=='table'and ar or{},E,ap,aq,a3)else aj[N]=E end end;if not aq then local as=getmetatable(ao)if type(as)=='table'then if ap then local at=getmetatable(aj)setmetatable(aj,a.Extend(type(at)=='table'and at or{},as,true))else setmetatable(aj,as)end end end;if ap then a3[ao]=nil end;return aj end,Vars=function(E,au,av,a3)local aw;if au then aw=au~='__NOLF'else au='  'aw=true end;if not av then av=''end;if not a3 then a3={}end;local ax=type(E)if ax=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local ay=aw and av..au or''local P='('..tostring(E)..') {'local az=true;for z,aA in pairs(E)do if az then az=false else P=P..(aw and','or', ')end;if aw then P=P..'\n'..ay end;if type(aA)=='table'and a3[aA]and a3[aA]>0 then P=P..z..' = ('..tostring(aA)..')'else P=P..z..' = '..a.Vars(aA,au,ay,a3)end end;if not az and aw then P=P..'\n'..av end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif ax=='function'or ax=='thread'or ax=='userdata'then return'('..ax..')'elseif ax=='string'then return'('..ax..') '..string.format('%q',E)else return'('..ax..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aB)f=aB end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aC)g=not not aC end,Log=function(aB,...)if aB<=f then local aD=g and(h[aB]or'LOG LEVEL '..tostring(aB))..' | 'or''local aE=table.pack(...)if aE.n==1 then local E=aE[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aD..P or P)else print(aD)end else local P=aD;for n=1,aE.n do local E=aE[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aF,aG)local aH={}if aG==nil then for N,E in pairs(aF)do aH[E]=E end elseif type(aG)=='function'then for N,E in pairs(aF)do local aI,aJ=aG(E)aH[aI]=aJ end else for N,E in pairs(aF)do aH[E]=aG end end;return aH end,Round=function(aK,aL)if aL then local aM=10^aL;return math.floor(aK*aM+0.5)/aM else return math.floor(aK+0.5)end end,Clamp=function(q,aN,aO)return math.max(aN,math.min(q,aO))end,Lerp=function(aP,aQ,ax)if ax<=0.0 then return aP elseif ax>=1.0 then return aQ else return aP+(aQ-aP)*ax end end,LerpUnclamped=function(aP,aQ,ax)if ax==0.0 then return aP elseif ax==1.0 then return aQ else return aP+(aQ-aP)*ax end end,PingPong=function(ax,aR)if aR==0 then return 0,1 end;local aS=math.floor(ax/aR)local aT=ax-aS*aR;if aS<0 then if(aS+1)%2==0 then return aR-aT,-1 else return aT,1 end else if aS%2==0 then return aT,1 else return aR-aT,-1 end end end,VectorApproximatelyEquals=function(aU,aV)return(aU-aV).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aU,aV)local aW=Quaternion.Dot(aU,aV)return aW<1.0+1E-06 and aW>1.0-1E-06 end,
QuaternionToAngleAxis=function(aX)local aS=aX.normalized;local aY=math.acos(aS.w)local aZ=math.sin(aY)local a_=math.deg(aY*2.0)local b0;if math.abs(aZ)<=Quaternion.kEpsilon then b0=Vector3.right else local b1=1.0/aZ;b0=Vector3.__new(aS.x*b1,aS.y*b1,aS.z*b1)end;return a_,b0 end,ApplyQuaternionToVector3=function(aX,b2)local b3=aX.w*b2.x+aX.y*b2.z-aX.z*b2.y;local b4=aX.w*b2.y-aX.x*b2.z+aX.z*b2.x;local b5=aX.w*b2.z+aX.x*b2.y-aX.y*b2.x;local b6=-aX.x*b2.x-aX.y*b2.y-aX.z*b2.z;return Vector3.__new(b6*-aX.x+b3*aX.w+b4*-aX.z-b5*-aX.y,b6*-aX.y-b3*-aX.z+b4*aX.w+b5*-aX.x,b6*-aX.z+b3*-aX.y-b4*-aX.x+b5*aX.w)end,RotateAround=function(b7,b8,b9,ba)return b9+ba*(b7-b9),ba*b8 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bb)return p.__tostring(bb)end,UUIDFromNumbers=function(...)local bc=...local ax=type(bc)local bd,be,bf,bg;if ax=='table'then bd=bc[1]be=bc[2]bf=bc[3]bg=bc[4]else bd,be,bf,bg=...end;local bb={bit32.band(bd or 0,0xFFFFFFFF),bit32.band(be or 0,0xFFFFFFFF),bit32.band(bf or 0,0xFFFFFFFF),bit32.band(bg or 0,0xFFFFFFFF)}setmetatable(bb,p)return bb end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bh='[0-9a-f-A-F]+'local bi='^('..bh..')$'local bj='^-('..bh..')$'local bk,bl,bm,bn;if S==32 then local bb=a.UUIDFromNumbers(0,0,0,0)local bo=1;for n,bp in ipairs({8,16,24,32})do bk,bl,bm=string.find(string.sub(P,bo,bp),bi)if not bk then return nil end;bb[n]=tonumber(bm,16)bo=bp+1 end;return bb else bk,bl,bm=string.find(string.sub(P,1,8),bi)if not bk then return nil end;local bd=tonumber(bm,16)bk,bl,bm=string.find(string.sub(P,9,13),bj)if not bk then return nil end;bk,bl,bn=string.find(string.sub(P,14,18),bj)if not bk then return nil end;local be=tonumber(bm..bn,16)bk,bl,bm=string.find(string.sub(P,19,23),bj)if not bk then return nil end;bk,bl,bn=string.find(string.sub(P,24,28),bj)if not bk then return nil end;local bf=tonumber(bm..bn,16)bk,bl,bm=string.find(string.sub(P,29,36),bi)if not bk then return nil end;local bg=tonumber(bm,16)return a.UUIDFromNumbers(bd,be,bf,bg)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bq)if type(bq)~='number'or bq<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bq),2)end;local self;local br=math.floor(bq)local U={}local bs=0;local bt=0;local bu=0;self={Size=function()return bu end,Clear=function()bs=0;bt=0;bu=0 end,IsEmpty=function()return bu==0 end,Offer=function(bv)U[bs+1]=bv;bs=(bs+1)%br;if bu<br then bu=bu+1 else bt=(bt+1)%br end;return true end,OfferFirst=function(bv)bt=(br+bt-1)%br;U[bt+1]=bv;if bu<br then bu=bu+1 else bs=(br+bs-1)%br end;return true end,Poll=function()if bu==0 then return nil else local bv=U[bt+1]bt=(bt+1)%br;bu=bu-1;return bv end end,PollLast=function()if bu==0 then return nil else bs=(br+bs-1)%br;local bv=U[bs+1]bu=bu-1;return bv end end,Peek=function()if bu==0 then return nil else return U[bt+1]end end,PeekLast=function()if bu==0 then return nil else return U[(br+bs-1)%br+1]end end,Get=function(bw)if bw<1 or bw>bu then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bw)return nil end;return U[(bt+bw-1)%br+1]end,IsFull=function()return bu>=br end,MaxSize=function()return br end}return self end,DetectClicks=function(bx,by,bz)local bA=bx or 0;local bB=bz or TimeSpan.FromMilliseconds(500)local bC=vci.me.Time;local bD=by and bC>by+bB and 1 or bA+1;return bD,bC end,ColorRGBToHSV=function(bE)local aT=math.max(0.0,math.min(bE.r,1.0))local bF=math.max(0.0,math.min(bE.g,1.0))local aQ=math.max(0.0,math.min(bE.b,1.0))local aO=math.max(aT,bF,aQ)local aN=math.min(aT,bF,aQ)local bG=aO-aN;local C;if bG==0.0 then C=0.0 elseif aO==aT then C=(bF-aQ)/bG/6.0 elseif aO==bF then C=(2.0+(aQ-aT)/bG)/6.0 else C=(4.0+(aT-bF)/bG)/6.0 end;if C<0.0 then C=C+1.0 end;local bH=aO==0.0 and bG or bG/aO;local E=aO;return C,bH,E end,ColorFromARGB32=function(bI)local bJ=type(bI)=='number'and bI or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bJ,16),0xFF)/0xFF,bit32.band(bit32.rshift(bJ,8),0xFF)/0xFF,bit32.band(bJ,0xFF)/0xFF,bit32.band(bit32.rshift(bJ,24),0xFF)/0xFF)end,ColorToARGB32=function(bE)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bE.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bE.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bE.g),0xFF),8),bit32.band(a.Round(0xFF*bE.b),0xFF))end,ColorFromIndex=function(bK,bL,bM,bN,bO)local bP=math.max(math.floor(bL or a.ColorHueSamples),1)local bQ=bO and bP or bP-1;local bR=math.max(math.floor(bM or a.ColorSaturationSamples),1)local bS=math.max(math.floor(bN or a.ColorBrightnessSamples),1)local bw=a.Clamp(math.floor(bK or 0),0,bP*bR*bS-1)local bT=bw%bP;local bU=math.floor(bw/bP)local b1=bU%bR;local bV=math.floor(bU/bR)if bO or bT~=bQ then local C=bT/bQ;local bH=(bR-b1)/bR;local E=(bS-bV)/bS;return Color.HSVToRGB(C,bH,E)else local E=(bS-bV)/bS*b1/(bR-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bE,bL,bM,bN,bO)local bP=math.max(math.floor(bL or a.ColorHueSamples),1)local bQ=bO and bP or bP-1;local bR=math.max(math.floor(bM or a.ColorSaturationSamples),1)local bS=math.max(math.floor(bN or a.ColorBrightnessSamples),1)local C,bH,E=a.ColorRGBToHSV(bE)local b1=a.Round(bR*(1.0-bH))if bO or b1<bR then local bW=a.Round(bQ*C)if bW>=bQ then bW=0 end;if b1>=bR then b1=bR-1 end;local bV=math.min(bS-1,a.Round(bS*(1.0-E)))return bW+bP*(b1+bR*bV)else local bX=a.Round((bR-1)*E)if bX==0 then local bY=a.Round(bS*(1.0-E))if bY>=bS then return bP-1 else return bP*(1+a.Round(E*(bR-1)/(bS-bY)*bS)+bR*bY)-1 end else return bP*(1+bX+bR*a.Round(bS*(1.0-E*(bR-1)/bX)))-1 end end end,ColorToTable=function(bE)return{[a.TypeParameterName]=a.ColorTypeName,r=bE.r,g=bE.g,b=bE.b,a=bE.a}end,ColorFromTable=function(G)local aQ,M=F(G,a.ColorTypeName)return aQ and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local aQ,M=F(G,a.Vector2TypeName)return aQ and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local aQ,M=F(G,a.Vector3TypeName)return aQ and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local aQ,M=F(G,a.Vector4TypeName)return aQ and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local aQ,M=F(G,a.QuaternionTypeName)return aQ and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ak,bZ)local a4=a.NillableIfHasValueOrElse(bZ,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ak,json.serialize(a4))end,OnMessage=function(ak,ah)local b_=function(c0,c1,c2)local c3=nil;if c0.type~='comment'and type(c2)=='string'then local c4,a4=pcall(json.parse,c2)if c4 and type(a4)=='table'then c3=a.TableFromSerializable(a4)end end;local bZ=c3 and c3 or{[a.MessageValueParameterName]=c2}ah(c0,c1,bZ)end;vci.message.On(ak,b_)return{Off=function()if b_ then b_=nil end end}end,OnInstanceMessage=function(ak,ah)local b_=function(c0,c1,bZ)local c5=a.InstanceID()if c5~=''and c5==bZ[a.InstanceIDParameterName]then ah(c0,c1,bZ)end end;return a.OnMessage(ak,b_)end,
GetEffekseerEmitterMap=function(ak)local c6=vci.assets.GetEffekseerEmitters(ak)if not c6 then return nil end;local aH={}for n,c7 in pairs(c6)do aH[c7.EffectName]=c7 end;return aH end,ClientID=function()return j end,CreateLocalSharedProperties=function(c8,c9)local ca=TimeSpan.FromSeconds(5)local cb='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cc='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(c8)~='string'or string.len(c8)<=0 or type(c9)~='string'or string.len(c9)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cd=_G[cb]if not cd then cd={}_G[cb]=cd end;cd[c9]=vci.me.UnscaledTime;local ce=_G[c8]if not ce then ce={[cc]={}}_G[c8]=ce end;local cf=ce[cc]local self;self={GetLspID=function()return c8 end,GetLoadID=function()return c9 end,GetProperty=function(z,ag)local q=ce[z]if q==nil then return ag else return q end end,SetProperty=function(z,q)if z==cc then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bC=vci.me.UnscaledTime;local cg=ce[z]ce[z]=q;for ch,c5 in pairs(cf)do local ax=cd[c5]if ax and ax+ca>=bC then ch(self,z,q,cg)else ch(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)cf[ch]=nil;cd[c5]=nil end end end,AddListener=function(ch)cf[ch]=c9 end,RemoveListener=function(ch)cf[ch]=nil end,UpdateAlive=function()cd[c9]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(ci)local cj=1.0;local ck=1000.0;local cl=TimeSpan.FromSeconds(0.02)local cm=0xFFFF;local cn=a.CreateCircularQueue(64)local co=TimeSpan.FromSeconds(5)local cp=TimeSpan.FromSeconds(30)local cq=false;local cr=vci.me.Time;local cs=a.Random32()local ct=Vector3.__new(bit32.bor(0x400,bit32.band(cs,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cs,16),0x1FFF)),0.0)ci.SetPosition(ct)ci.SetRotation(Quaternion.identity)ci.SetVelocity(Vector3.zero)ci.SetAngularVelocity(Vector3.zero)ci.AddForce(Vector3.__new(0.0,0.0,cj*ck))local self={Timestep=function()return cl end,Precision=function()return cm end,IsFinished=function()return cq end,Update=function()if cq then return cl end;local cu=vci.me.Time-cr;local cv=cu.TotalSeconds;if cv<=Vector3.kEpsilon then return cl end;local cw=ci.GetPosition().z-ct.z;local cx=cw/cv;local cy=cx/ck;if cy<=Vector3.kEpsilon then return cl end;cn.Offer(cy)local cz=cn.Size()if cz>=2 and cu>=co then local cA=0.0;for n=1,cz do cA=cA+cn.Get(n)end;local cB=cA/cz;local cC=0.0;for n=1,cz do cC=cC+(cn.Get(n)-cB)^2 end;local cD=cC/cz;if cD<cm then cm=cD;cl=TimeSpan.FromSeconds(cB)end;if cu>cp then cq=true;ci.SetPosition(ct)ci.SetRotation(Quaternion.identity)ci.SetVelocity(Vector3.zero)ci.SetAngularVelocity(Vector3.zero)end else cl=TimeSpan.FromSeconds(cy)end;return cl end}return self end,AlignSubItemOrigin=function(cE,cF,cG)local cH=cE.GetRotation()if not a.QuaternionApproximatelyEquals(cF.GetRotation(),cH)then cF.SetRotation(cH)end;local cI=cE.GetPosition()if not a.VectorApproximatelyEquals(cF.GetPosition(),cI)then cF.SetPosition(cI)end;if cG then cF.SetVelocity(Vector3.zero)cF.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local cJ={}local self;self={Contains=function(cK,cL)return a.NillableIfHasValueOrElse(cJ[cK],function(an)return a.NillableHasValue(an[cL])end,function()return false end)end,Add=function(cK,cM,cG)if not cK or not cM then local cN='SubItemGlue.Add: Invalid arguments '..(not cK and', parent = '..tostring(cK)or'')..(not cM and', children = '..tostring(cM)or'')error(cN,2)end;local an=a.NillableIfHasValueOrElse(cJ[cK],function(cO)return cO end,function()local cO={}cJ[cK]=cO;return cO end)if type(cM)=='table'then for z,aA in pairs(cM)do an[aA]={velocityReset=not not cG}end else an[cM]={velocityReset=not not cG}end end,Remove=function(cK,cL)return a.NillableIfHasValueOrElse(cJ[cK],function(an)if a.NillableHasValue(an[cL])then an[cL]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(cK)if a.NillableHasValue(cJ[cK])then cJ[cK]=nil;return true else return false end end,RemoveAll=function()cJ={}return true end,Each=function(ah,cP)return a.NillableIfHasValueOrElse(cP,function(cK)return a.NillableIfHasValue(cJ[cK],function(an)for cL,cQ in pairs(an)do if ah(cL,cK,self)==false then return false end end end)end,function()for cK,an in pairs(cJ)do if self.Each(ah,cK)==false then return false end end end)end,Update=function(cR)for cK,an in pairs(cJ)do local cS=cK.GetPosition()local cT=cK.GetRotation()for cL,cQ in pairs(an)do if cR or cL.IsMine then if not a.QuaternionApproximatelyEquals(cL.GetRotation(),cT)then cL.SetRotation(cT)end;if not a.VectorApproximatelyEquals(cL.GetPosition(),cS)then cL.SetPosition(cS)end;if cQ.velocityReset then cL.SetVelocity(Vector3.zero)cL.SetAngularVelocity(Vector3.zero)end end end end end}return self end,
CreateSlideSwitch=function(cU)local cV=a.NillableValue(cU.colliderItem)local cW=a.NillableValue(cU.baseItem)local cX=a.NillableValue(cU.knobItem)local cY=a.NillableValueOrDefault(cU.minValue,0)local cZ=a.NillableValueOrDefault(cU.maxValue,10)if cY>=cZ then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local c_=(cY+cZ)*0.5;local d0=function(aA)local d1,d2=a.PingPong(aA-cY,cZ-cY)return d1+cY,d2 end;local q=d0(a.NillableValueOrDefault(cU.value,0))local d3=a.NillableIfHasValueOrElse(cU.tickFrequency,function(d4)if d4<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(d4,cZ-cY)end,function()return(cZ-cY)/10.0 end)local d5=a.NillableIfHasValueOrElse(cU.tickVector,function(b0)return Vector3.__new(b0.x,b0.y,b0.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local d6=d5.magnitude;if d6<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local d7=a.NillableValueOrDefault(cU.snapToTick,true)local d8=TimeSpan.FromMilliseconds(1000)local d9=TimeSpan.FromMilliseconds(50)local da,db;local cf={}local self;local dc=false;local dd=0;local de=false;local df=TimeSpan.Zero;local dg=TimeSpan.Zero;local dh=function()local di=d0(da())if di~=q then q=di;for ch,E in pairs(cf)do ch(self,q)end end;cX.SetLocalPosition((di-c_)/d3*d5)end;local dj=function()local dk=da()local dl,dm=d0(dk)local dn=dk+d3;local dp,dq=d0(dn)assert(dp)local di;if dm==dq or dl==cZ or dl==cY then di=dn else di=dm>=0 and cZ or cY end;dg=vci.me.UnscaledTime;if di==cZ or di==cY then df=dg end;db(di)end;a.NillableIfHasValueOrElse(cU.lsp,function(dr)if not a.NillableHasValue(cU.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local ds=a.NillableValue(cU.propertyName)da=function()return dr.GetProperty(ds,q)end;db=function(aA)dr.SetProperty(ds,aA)end;dr.AddListener(function(ao,z,dt,du)if z==ds then dh()end end)end,function()local dt=q;da=function()return dt end;db=function(aA)dt=aA;dh()end end)self={GetColliderItem=function()return cV end,GetBaseItem=function()return cW end,GetKnobItem=function()return cX end,GetMinValue=function()return cY end,GetMaxValue=function()return cZ end,GetValue=function()return q end,SetValue=function(aA)db(d0(aA))end,GetTickFrequency=function()return d3 end,IsSnapToTick=function()return d7 end,AddListener=function(ch)cf[ch]=ch end,RemoveListener=function(ch)cf[ch]=nil end,DoUse=function()if not dc then de=true;df=vci.me.UnscaledTime;dj()end end,DoUnuse=function()de=false end,DoGrab=function()if not de then dc=true;dd=(q-c_)/d3 end end,DoUngrab=function()dc=false end,Update=function()if dc then local dv=cV.GetPosition()-cW.GetPosition()local dw=cX.GetRotation()*d5;local dx=Vector3.Project(dv,dw)local dy=(Vector3.Dot(dw,dx)>=0 and 1 or-1)*dx.magnitude/d6+dd;local dz=(d7 and a.Round(dy)or dy)*d3+c_;local di=a.Clamp(dz,cY,cZ)if di~=q then db(di)end elseif de then local dA=vci.me.UnscaledTime;if dA>=df+d8 and dA>=dg+d9 then dj()end elseif cV.IsMine then a.AlignSubItemOrigin(cW,cV)end end}dh()return self end,CreateSubItemConnector=function()local dB=function(dC,cF,dD)dC.item=cF;dC.position=cF.GetPosition()dC.rotation=cF.GetRotation()dC.initialPosition=dC.position;dC.initialRotation=dC.rotation;dC.propagation=not not dD;return dC end;local dE=function(dF)for cF,dC in pairs(dF)do dB(dC,cF,dC.propagation)end end;local dG=function(dH,ba,dC,dI,dJ)local dv=dH-dC.initialPosition;local dK=ba*Quaternion.Inverse(dC.initialRotation)dC.position=dH;dC.rotation=ba;for cF,dL in pairs(dI)do if cF~=dC.item and(not dJ or dJ(dL))then dL.position,dL.rotation=a.RotateAround(dL.initialPosition+dv,dL.initialRotation,dH,dK)cF.SetPosition(dL.position)cF.SetRotation(dL.rotation)end end end;local dM={}local dN=true;local dO=false;local self;self={IsEnabled=function()return dN end,SetEnabled=function(aC)dN=aC;if aC then dE(dM)dO=false end end,Contains=function(dP)return a.NillableHasValue(dM[dP])end,Add=function(dQ,dR)if not dQ then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(dQ),2)end;local dS=type(dQ)=='table'and dQ or{dQ}dE(dM)dO=false;for N,cF in pairs(dS)do dM[cF]=dB({},cF,not dR)end end,Remove=function(dP)local aQ=a.NillableHasValue(dM[dP])dM[dP]=nil;return aQ end,RemoveAll=function()dM={}return true end,Each=function(ah)for cF,dC in pairs(dM)do if ah(cF,self)==false then return false end end end,GetItems=function()local dS={}for cF,dC in pairs(dM)do table.insert(dS,cF)end;return dS end,Update=function()if not dN then return end;local dT=false;for cF,dC in pairs(dM)do local dU=cF.GetPosition()local dV=cF.GetRotation()if not a.VectorApproximatelyEquals(dU,dC.position)or not a.QuaternionApproximatelyEquals(dV,dC.rotation)then if dC.propagation then if cF.IsMine then dG(dU,dV,dM[cF],dM,function(dL)if dL.item.IsMine then return true else dO=true;return false end end)dT=true;break else dO=true end else dO=true end end end;if not dT and dO then dE(dM)dO=false end end}return self end,GetSubItemTransform=function(dP)local dH=dP.GetPosition()local ba=dP.GetRotation()local dW=dP.GetLocalScale()return{positionX=dH.x,positionY=dH.y,positionZ=dH.z,rotationX=ba.x,rotationY=ba.y,rotationZ=ba.z,rotationW=ba.w,scaleX=dW.x,scaleY=dW.y,scaleZ=dW.z}end,RestoreCytanbTransform=function(dX)local dU=dX.positionX and dX.positionY and dX.positionZ and Vector3.__new(dX.positionX,dX.positionY,dX.positionZ)or nil;local dV=dX.rotationX and dX.rotationY and dX.rotationZ and dX.rotationW and Quaternion.__new(dX.rotationX,dX.rotationY,dX.rotationZ,dX.rotationW)or nil;local dW=dX.scaleX and dX.scaleY and dX.scaleZ and Vector3.__new(dX.scaleX,dX.scaleY,dX.scaleZ)or nil;return dU,dV,dW end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local c8='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local ce=_G[c8]if not ce then ce={}_G[c8]=ce end;local dY=ce.randomSeedValue;if not dY then dY=os.time()-os.clock()*10000;ce.randomSeedValue=dY;math.randomseed(dY)end;local dZ=ce.clientID;if type(dZ)~='string'then dZ=tostring(a.RandomUUID())ce.clientID=dZ end;local d_=vci.state.Get(b)or''if d_==''and vci.assets.IsMine then d_=tostring(a.RandomUUID())vci.state.Set(b,d_)end;return d_,dZ end)()return a end)()

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

--- 設定パネルがつかまれているか。
local settingsPanelGrabbed = false

--- ライトを組み立てるリクエストを送った時間。
local standLightsLastRequestTime = vci.me.UnscaledTime

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

local EmitHitBall = function (targetName)
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
    if not ls.active and now <= ls.inactiveTime + settings.requestIntervalTime then
        -- ライトが倒れた直後ならヒットしたものとして判定
        if ls.hitSourceID == cytanb.ClientID() then
            -- スコアを更新
            local propertyName = ls.directHit and settings.scoreDirectHitCountPropertyName or settings.scoreHitCountPropertyName
            local score = (settings.lsp.GetProperty(propertyName) or 0) + 1
            settings.lsp.SetProperty(propertyName, score)
            cytanb.LogInfo(propertyName, ': ', score)
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

        cytanb.LogTrace('Throw ball by kinematic: velocity: ', velocity, ', velocityMagnitude: ', velocityMagnitude, ', angularVelocity: ', angularVelocity, ', angularVelocity.magnitude: ', angularVelocity.magnitude, ', fixedTimestep: ', fixedTimestep.TotalSeconds)
        ballStatus.simAngularVelocity = angularVelocity
        ball.SetVelocity(velocity)
        ball.SetAngularVelocity(angularVelocity)

        -- 体のコライダーに接触しないように、オフセットを足す
        ballPos = ball.GetPosition() + forwardOffset
        ball.SetPosition(ballPos)

        PlayThrowingAudio(velocityMagnitude)
    else
        ballStatus.simAngularVelocity = Vector3.zero
    end

    OfferBallTransform(ballPos, ballRot)
end

--- 入力タイミングによる投球
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

    ball.SetVelocity(velocity)
    ball.SetAngularVelocity(ballStatus.simAngularVelocity)

    -- 体のコライダーに接触しないように、オフセットを足す
    local ballPos = ball.GetPosition() + forwardOffset
    ball.SetPosition(ballPos)

    PlayThrowingAudio(velocityMagnitude)

    ballStatus.transformQueue.Clear()
    OfferBallTransform(ballPos, ball.GetRotation())
end

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    settings.lsp.UpdateAlive()
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

    local slideSwitchListener = function (source, value)
        cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
    end

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
        switch.AddListener(slideSwitchListener)
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

    settings.lsp.AddListener(function (source, key, value, oldValue)
        if key == cytanb.LOCAL_SHARED_PROPERTY_EXPIRED_KEY then
            -- cytanb.LogInfo('lsp: expired')
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

    if vci.assets.IsMine then
        -- 全 VCI からのクエリーに応答する。
        cytanb.OnMessage(queryStatusMessageName, function (sender, name, parameterMap)
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
    end

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
            if IsContactWithTarget(source.position, source.longSide or 1.0, li.GetPosition(), settings.standLightSimLongSide) and now > ls.hitMessageTime + settings.requestIntervalTime then
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
        return
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
                            -- 上向きに力を加える場合は、下向きに落下するはずが、フレームレートの減少による浮き上がりを起こさないように制限する
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
    settingsPanelGlue.Update()

    for name, switch in pairs(slideSwitchMap) do
        switch.Update()
    end

    if deltaTime <= TimeSpan.Zero then
        return
    end

    fixedTimestep = timestepEstimater.Update()

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
        settingsPanelGrabbed = true
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
        settingsPanelGrabbed = false
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
        -- 入力タイミングのフェーズを進行する。
        -- ただし、運動による投球動作に入っている場合は、入力タイミングモードに移行しない。
        if ballStatus.grabbed and impactStatus.phase < 3 and not (impactStatus.phase == 0 and IsInThrowingMotion()) then
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
        if not settingsPanelGrabbed and settingsPanel.IsMine then
            settingsPanel.SetPosition(hiddenPosition)
        end
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

    cytanb.NillableIfHasValue(slideSwitchMap[use], function (switch)
        switch.DoUnuse()
    end)
end

onCollisionEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    if item == ball.GetName() then
        if ball.IsMine and not ballStatus.grabbed then
            if string.find(hit, settings.targetTag, 1, true) then
                EmitHitBall(hit)
            elseif not avatarColliderMap[hit] then
                -- ライトかアバターのコライダー以外に衝突した場合は、カウントアップする
                ballStatus.boundCount = ballStatus.boundCount + 1
                cytanb.LogTrace('ball bounds: hit = ', hit, ', boundCount = ', ballStatus.boundCount)
            end
        end
    elseif string.startsWith(item, settings.standLightPrefix) then
        if string.find(hit, settings.targetTag, 1, true) then
            cytanb.NillableIfHasValue((StandLightFromName(item)), function (light)
                if light.item.IsMine and not light.status.grabbed then
                    EmitHitStandLight(light, hit)
                end
            end)
        end
    end
end

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
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
            cytanb.TraceLog('onTriggerEnter: colorPaletteCollisionCount = ', discernibleColorStatus.paletteCollisionCount, ' hit = ', hit)
        end
    end)
end
