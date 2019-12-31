-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(af)return af~=nil end,NillableValue=function(af)if af==nil then error('nillable: value is nil',2)end;return af end,NillableValueOrDefault=function(af,ag)if af==nil then if ag==nil then error('nillable: defaultValue is nil',2)end;return ag else return af end end,NillableIfHasValue=function(af,ah)if af==nil then return nil else return ah(af)end end,NillableIfHasValueOrElse=function(af,ah,ai)if af==nil then return ai()else return ah(af)end end,SetConst=function(aj,ak,q)if type(aj)~='table'then error('Cannot set const to non-table target',2)end;local al=getmetatable(aj)local A=al or{}local am=rawget(A,x)if rawget(aj,ak)~=nil then error('Non-const field "'..ak..'" already exists',2)end;if not am then am={}rawset(A,x,am)A.__index=y;A.__newindex=D end;rawset(am,ak,q)if not al then setmetatable(aj,A)end;return aj end,SetConstEach=function(aj,an)for N,E in pairs(an)do a.SetConst(aj,N,E)end;return aj end,Extend=function(aj,ao,ap,aq,a3)if aj==ao or type(aj)~='table'or type(ao)~='table'then return aj end;if ap then if not a3 then a3={}end;if a3[ao]then error('circular reference')end;a3[ao]=true end;for N,E in pairs(ao)do if ap and type(E)=='table'then local ar=aj[N]aj[N]=a.Extend(type(ar)=='table'and ar or{},E,ap,aq,a3)else aj[N]=E end end;if not aq then local as=getmetatable(ao)if type(as)=='table'then if ap then local at=getmetatable(aj)setmetatable(aj,a.Extend(type(at)=='table'and at or{},as,true))else setmetatable(aj,as)end end end;if ap then a3[ao]=nil end;return aj end,Vars=function(E,au,av,a3)local aw;if au then aw=au~='__NOLF'else au='  'aw=true end;if not av then av=''end;if not a3 then a3={}end;local ax=type(E)if ax=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local ay=aw and av..au or''local P='('..tostring(E)..') {'local az=true;for z,aA in pairs(E)do if az then az=false else P=P..(aw and','or', ')end;if aw then P=P..'\n'..ay end;if type(aA)=='table'and a3[aA]and a3[aA]>0 then P=P..z..' = ('..tostring(aA)..')'else P=P..z..' = '..a.Vars(aA,au,ay,a3)end end;if not az and aw then P=P..'\n'..av end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif ax=='function'or ax=='thread'or ax=='userdata'then return'('..ax..')'elseif ax=='string'then return'('..ax..') '..string.format('%q',E)else return'('..ax..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aB)f=aB end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aC)g=not not aC end,Log=function(aB,...)if aB<=f then local aD=g and(h[aB]or'LOG LEVEL '..tostring(aB))..' | 'or''local aE=table.pack(...)if aE.n==1 then local E=aE[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aD..P or P)else print(aD)end else local P=aD;for n=1,aE.n do local E=aE[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aF,aG)local aH={}if aG==nil then for N,E in pairs(aF)do aH[E]=E end elseif type(aG)=='function'then for N,E in pairs(aF)do local aI,aJ=aG(E)aH[aI]=aJ end else for N,E in pairs(aF)do aH[E]=aG end end;return aH end,Round=function(aK,aL)if aL then local aM=10^aL;return math.floor(aK*aM+0.5)/aM else return math.floor(aK+0.5)end end,Clamp=function(q,aN,aO)return math.max(aN,math.min(q,aO))end,Lerp=function(aP,aQ,ax)if ax<=0.0 then return aP elseif ax>=1.0 then return aQ else return aP+(aQ-aP)*ax end end,LerpUnclamped=function(aP,aQ,ax)if ax==0.0 then return aP elseif ax==1.0 then return aQ else return aP+(aQ-aP)*ax end end,PingPong=function(ax,aR)if aR==0 then return 0,1 end;local aS=math.floor(ax/aR)local aT=ax-aS*aR;if aS<0 then if(aS+1)%2==0 then return aR-aT,-1 else return aT,1 end else if aS%2==0 then return aT,1 else return aR-aT,-1 end end end,VectorApproximatelyEquals=function(aU,aV)return(aU-aV).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aU,aV)local aW=Quaternion.Dot(aU,aV)return aW<1.0+1E-06 and aW>1.0-1E-06 end,
QuaternionToAngleAxis=function(aX)local aS=aX.normalized;local aY=math.acos(aS.w)local aZ=math.sin(aY)local a_=math.deg(aY*2.0)local b0;if math.abs(aZ)<=Quaternion.kEpsilon then b0=Vector3.right else local b1=1.0/aZ;b0=Vector3.__new(aS.x*b1,aS.y*b1,aS.z*b1)end;return a_,b0 end,ApplyQuaternionToVector3=function(aX,b2)local b3=aX.w*b2.x+aX.y*b2.z-aX.z*b2.y;local b4=aX.w*b2.y-aX.x*b2.z+aX.z*b2.x;local b5=aX.w*b2.z+aX.x*b2.y-aX.y*b2.x;local b6=-aX.x*b2.x-aX.y*b2.y-aX.z*b2.z;return Vector3.__new(b6*-aX.x+b3*aX.w+b4*-aX.z-b5*-aX.y,b6*-aX.y-b3*-aX.z+b4*aX.w+b5*-aX.x,b6*-aX.z+b3*-aX.y-b4*-aX.x+b5*aX.w)end,RotateAround=function(b7,b8,b9,ba)return b9+a.ApplyQuaternionToVector3(ba,b7-b9),ba*b8 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bb)return p.__tostring(bb)end,UUIDFromNumbers=function(...)local bc=...local ax=type(bc)local bd,be,bf,bg;if ax=='table'then bd=bc[1]be=bc[2]bf=bc[3]bg=bc[4]else bd,be,bf,bg=...end;local bb={bit32.band(bd or 0,0xFFFFFFFF),bit32.band(be or 0,0xFFFFFFFF),bit32.band(bf or 0,0xFFFFFFFF),bit32.band(bg or 0,0xFFFFFFFF)}setmetatable(bb,p)return bb end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bh='[0-9a-f-A-F]+'local bi='^('..bh..')$'local bj='^-('..bh..')$'local bk,bl,bm,bn;if S==32 then local bb=a.UUIDFromNumbers(0,0,0,0)local bo=1;for n,bp in ipairs({8,16,24,32})do bk,bl,bm=string.find(string.sub(P,bo,bp),bi)if not bk then return nil end;bb[n]=tonumber(bm,16)bo=bp+1 end;return bb else bk,bl,bm=string.find(string.sub(P,1,8),bi)if not bk then return nil end;local bd=tonumber(bm,16)bk,bl,bm=string.find(string.sub(P,9,13),bj)if not bk then return nil end;bk,bl,bn=string.find(string.sub(P,14,18),bj)if not bk then return nil end;local be=tonumber(bm..bn,16)bk,bl,bm=string.find(string.sub(P,19,23),bj)if not bk then return nil end;bk,bl,bn=string.find(string.sub(P,24,28),bj)if not bk then return nil end;local bf=tonumber(bm..bn,16)bk,bl,bm=string.find(string.sub(P,29,36),bi)if not bk then return nil end;local bg=tonumber(bm,16)return a.UUIDFromNumbers(bd,be,bf,bg)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bq)if type(bq)~='number'or bq<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bq),2)end;local self;local br=math.floor(bq)local U={}local bs=0;local bt=0;local bu=0;self={Size=function()return bu end,Clear=function()bs=0;bt=0;bu=0 end,IsEmpty=function()return bu==0 end,Offer=function(bv)U[bs+1]=bv;bs=(bs+1)%br;if bu<br then bu=bu+1 else bt=(bt+1)%br end;return true end,OfferFirst=function(bv)bt=(br+bt-1)%br;U[bt+1]=bv;if bu<br then bu=bu+1 else bs=(br+bs-1)%br end;return true end,Poll=function()if bu==0 then return nil else local bv=U[bt+1]bt=(bt+1)%br;bu=bu-1;return bv end end,PollLast=function()if bu==0 then return nil else bs=(br+bs-1)%br;local bv=U[bs+1]bu=bu-1;return bv end end,Peek=function()if bu==0 then return nil else return U[bt+1]end end,PeekLast=function()if bu==0 then return nil else return U[(br+bs-1)%br+1]end end,Get=function(bw)if bw<1 or bw>bu then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bw)return nil end;return U[(bt+bw-1)%br+1]end,IsFull=function()return bu>=br end,MaxSize=function()return br end}return self end,DetectClicks=function(bx,by,bz)local bA=bx or 0;local bB=bz or TimeSpan.FromMilliseconds(500)local bC=vci.me.Time;local bD=by and bC>by+bB and 1 or bA+1;return bD,bC end,ColorRGBToHSV=function(bE)local aT=math.max(0.0,math.min(bE.r,1.0))local bF=math.max(0.0,math.min(bE.g,1.0))local aQ=math.max(0.0,math.min(bE.b,1.0))local aO=math.max(aT,bF,aQ)local aN=math.min(aT,bF,aQ)local bG=aO-aN;local C;if bG==0.0 then C=0.0 elseif aO==aT then C=(bF-aQ)/bG/6.0 elseif aO==bF then C=(2.0+(aQ-aT)/bG)/6.0 else C=(4.0+(aT-bF)/bG)/6.0 end;if C<0.0 then C=C+1.0 end;local bH=aO==0.0 and bG or bG/aO;local E=aO;return C,bH,E end,ColorFromARGB32=function(bI)local bJ=type(bI)=='number'and bI or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bJ,16),0xFF)/0xFF,bit32.band(bit32.rshift(bJ,8),0xFF)/0xFF,bit32.band(bJ,0xFF)/0xFF,bit32.band(bit32.rshift(bJ,24),0xFF)/0xFF)end,ColorToARGB32=function(bE)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bE.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bE.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bE.g),0xFF),8),bit32.band(a.Round(0xFF*bE.b),0xFF))end,ColorFromIndex=function(bK,bL,bM,bN,bO)local bP=math.max(math.floor(bL or a.ColorHueSamples),1)local bQ=bO and bP or bP-1;local bR=math.max(math.floor(bM or a.ColorSaturationSamples),1)local bS=math.max(math.floor(bN or a.ColorBrightnessSamples),1)local bw=a.Clamp(math.floor(bK or 0),0,bP*bR*bS-1)local bT=bw%bP;local bU=math.floor(bw/bP)local b1=bU%bR;local bV=math.floor(bU/bR)if bO or bT~=bQ then local C=bT/bQ;local bH=(bR-b1)/bR;local E=(bS-bV)/bS;return Color.HSVToRGB(C,bH,E)else local E=(bS-bV)/bS*b1/(bR-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bE,bL,bM,bN,bO)local bP=math.max(math.floor(bL or a.ColorHueSamples),1)local bQ=bO and bP or bP-1;local bR=math.max(math.floor(bM or a.ColorSaturationSamples),1)local bS=math.max(math.floor(bN or a.ColorBrightnessSamples),1)local C,bH,E=a.ColorRGBToHSV(bE)local b1=a.Round(bR*(1.0-bH))if bO or b1<bR then local bW=a.Round(bQ*C)if bW>=bQ then bW=0 end;if b1>=bR then b1=bR-1 end;local bV=math.min(bS-1,a.Round(bS*(1.0-E)))return bW+bP*(b1+bR*bV)else local bX=a.Round((bR-1)*E)if bX==0 then local bY=a.Round(bS*(1.0-E))if bY>=bS then return bP-1 else return bP*(1+a.Round(E*(bR-1)/(bS-bY)*bS)+bR*bY)-1 end else return bP*(1+bX+bR*a.Round(bS*(1.0-E*(bR-1)/bX)))-1 end end end,ColorToTable=function(bE)return{[a.TypeParameterName]=a.ColorTypeName,r=bE.r,g=bE.g,b=bE.b,a=bE.a}end,ColorFromTable=function(G)local aQ,M=F(G,a.ColorTypeName)return aQ and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local aQ,M=F(G,a.Vector2TypeName)return aQ and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local aQ,M=F(G,a.Vector3TypeName)return aQ and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local aQ,M=F(G,a.Vector4TypeName)return aQ and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local aQ,M=F(G,a.QuaternionTypeName)return aQ and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ak,bZ)local a4=a.NillableIfHasValueOrElse(bZ,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ak,json.serialize(a4))end,OnMessage=function(ak,ah)local b_=function(c0,c1,c2)local c3=nil;if c0.type~='comment'and type(c2)=='string'then local c4,a4=pcall(json.parse,c2)if c4 and type(a4)=='table'then c3=a.TableFromSerializable(a4)end end;local bZ=c3 and c3 or{[a.MessageValueParameterName]=c2}ah(c0,c1,bZ)end;vci.message.On(ak,b_)return{Off=function()if b_ then b_=nil end end}end,OnInstanceMessage=function(ak,ah)local b_=function(c0,c1,bZ)local c5=a.InstanceID()if c5~=''and c5==bZ[a.InstanceIDParameterName]then ah(c0,c1,bZ)end end;return a.OnMessage(ak,b_)end,
GetEffekseerEmitterMap=function(ak)local c6=vci.assets.GetEffekseerEmitters(ak)if not c6 then return nil end;local aH={}for n,c7 in pairs(c6)do aH[c7.EffectName]=c7 end;return aH end,ClientID=function()return j end,CreateLocalSharedProperties=function(c8,c9)local ca=TimeSpan.FromSeconds(5)local cb='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cc='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(c8)~='string'or string.len(c8)<=0 or type(c9)~='string'or string.len(c9)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cd=_G[cb]if not cd then cd={}_G[cb]=cd end;cd[c9]=vci.me.UnscaledTime;local ce=_G[c8]if not ce then ce={[cc]={}}_G[c8]=ce end;local cf=ce[cc]local self;self={GetLspID=function()return c8 end,GetLoadID=function()return c9 end,GetProperty=function(z,ag)local q=ce[z]if q==nil then return ag else return q end end,SetProperty=function(z,q)if z==cc then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bC=vci.me.UnscaledTime;local cg=ce[z]ce[z]=q;for ch,c5 in pairs(cf)do local ax=cd[c5]if ax and ax+ca>=bC then ch(self,z,q,cg)else ch(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)cf[ch]=nil;cd[c5]=nil end end end,AddListener=function(ch)cf[ch]=c9 end,RemoveListener=function(ch)cf[ch]=nil end,UpdateAlive=function()cd[c9]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(ci)local cj=1.0;local ck=1000.0;local cl=TimeSpan.FromSeconds(0.02)local cm=0xFFFF;local cn=a.CreateCircularQueue(64)local co=TimeSpan.FromSeconds(5)local cp=TimeSpan.FromSeconds(30)local cq=false;local cr=vci.me.Time;local cs=a.Random32()local ct=Vector3.__new(bit32.bor(0x400,bit32.band(cs,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cs,16),0x1FFF)),0.0)ci.SetPosition(ct)ci.SetRotation(Quaternion.identity)ci.SetVelocity(Vector3.zero)ci.SetAngularVelocity(Vector3.zero)ci.AddForce(Vector3.__new(0.0,0.0,cj*ck))local self={Timestep=function()return cl end,Precision=function()return cm end,IsFinished=function()return cq end,Update=function()if cq then return cl end;local cu=vci.me.Time-cr;local cv=cu.TotalSeconds;if cv<=Vector3.kEpsilon then return cl end;local cw=ci.GetPosition().z-ct.z;local cx=cw/cv;local cy=cx/ck;if cy<=Vector3.kEpsilon then return cl end;cn.Offer(cy)local cz=cn.Size()if cz>=2 and cu>=co then local cA=0.0;for n=1,cz do cA=cA+cn.Get(n)end;local cB=cA/cz;local cC=0.0;for n=1,cz do cC=cC+(cn.Get(n)-cB)^2 end;local cD=cC/cz;if cD<cm then cm=cD;cl=TimeSpan.FromSeconds(cB)end;if cu>cp then cq=true;ci.SetPosition(ct)ci.SetRotation(Quaternion.identity)ci.SetVelocity(Vector3.zero)ci.SetAngularVelocity(Vector3.zero)end else cl=TimeSpan.FromSeconds(cy)end;return cl end}return self end,AlignSubItemOrigin=function(cE,cF,cG)local cH=cE.GetRotation()if not a.QuaternionApproximatelyEquals(cF.GetRotation(),cH)then cF.SetRotation(cH)end;local cI=cE.GetPosition()if not a.VectorApproximatelyEquals(cF.GetPosition(),cI)then cF.SetPosition(cI)end;if cG then cF.SetVelocity(Vector3.zero)cF.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local cJ={}local self;self={Contains=function(cK,cL)return a.NillableIfHasValueOrElse(cJ[cK],function(an)return a.NillableHasValue(an[cL])end,function()return false end)end,Add=function(cK,cM,cG)if not cK or not cM then local cN='SubItemGlue.Add: Invalid arguments '..(not cK and', parent = '..tostring(cK)or'')..(not cM and', children = '..tostring(cM)or'')error(cN,2)end;local an=a.NillableIfHasValueOrElse(cJ[cK],function(cO)return cO end,function()local cO={}cJ[cK]=cO;return cO end)if type(cM)=='table'then for z,aA in pairs(cM)do an[aA]={velocityReset=not not cG}end else an[cM]={velocityReset=not not cG}end end,Remove=function(cK,cL)return a.NillableIfHasValueOrElse(cJ[cK],function(an)if a.NillableHasValue(an[cL])then an[cL]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(cK)if a.NillableHasValue(cJ[cK])then cJ[cK]=nil;return true else return false end end,RemoveAll=function()cJ={}return true end,Each=function(ah,cP)return a.NillableIfHasValueOrElse(cP,function(cK)return a.NillableIfHasValue(cJ[cK],function(an)for cL,cQ in pairs(an)do if ah(cL,cK,self)==false then return false end end end)end,function()for cK,an in pairs(cJ)do if self.Each(ah,cK)==false then return false end end end)end,Update=function(cR)for cK,an in pairs(cJ)do local cS=cK.GetPosition()local cT=cK.GetRotation()for cL,cQ in pairs(an)do if cR or cL.IsMine then if not a.QuaternionApproximatelyEquals(cL.GetRotation(),cT)then cL.SetRotation(cT)end;if not a.VectorApproximatelyEquals(cL.GetPosition(),cS)then cL.SetPosition(cS)end;if cQ.velocityReset then cL.SetVelocity(Vector3.zero)cL.SetAngularVelocity(Vector3.zero)end end end end end}return self end,
CreateSlideSwitch=function(cU)local cV=a.NillableValue(cU.colliderItem)local cW=a.NillableValue(cU.baseItem)local cX=a.NillableValue(cU.knobItem)local cY=a.NillableValueOrDefault(cU.minValue,0)local cZ=a.NillableValueOrDefault(cU.maxValue,10)if cY>=cZ then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local c_=(cY+cZ)*0.5;local d0=function(aA)local d1,d2=a.PingPong(aA-cY,cZ-cY)return d1+cY,d2 end;local q=d0(a.NillableValueOrDefault(cU.value,0))local d3=a.NillableIfHasValueOrElse(cU.tickFrequency,function(d4)if d4<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(d4,cZ-cY)end,function()return(cZ-cY)/10.0 end)local d5=a.NillableIfHasValueOrElse(cU.tickVector,function(b0)return Vector3.__new(b0.x,b0.y,b0.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local d6=d5.magnitude;if d6<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local d7=a.NillableValueOrDefault(cU.snapToTick,true)local d8=TimeSpan.FromMilliseconds(1000)local d9=TimeSpan.FromMilliseconds(50)local da,db;local cf={}local self;local dc=false;local dd=0;local de=false;local df=TimeSpan.Zero;local dg=TimeSpan.Zero;local dh=function()local di=d0(da())if di~=q then q=di;for ch,E in pairs(cf)do ch(self,q)end end;cX.SetLocalPosition((di-c_)/d3*d5)end;local dj=function()local dk=da()local dl,dm=d0(dk)local dn=dk+d3;local dp,dq=d0(dn)assert(dp)local di;if dm==dq or dl==cZ or dl==cY then di=dn else di=dm>=0 and cZ or cY end;dg=vci.me.UnscaledTime;if di==cZ or di==cY then df=dg end;db(di)end;a.NillableIfHasValueOrElse(cU.lsp,function(dr)if not a.NillableHasValue(cU.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local ds=a.NillableValue(cU.propertyName)da=function()return dr.GetProperty(ds,q)end;db=function(aA)dr.SetProperty(ds,aA)end;dr.AddListener(function(ao,z,dt,du)if z==ds then dh()end end)end,function()local dt=q;da=function()return dt end;db=function(aA)dt=aA;dh()end end)self={GetColliderItem=function()return cV end,GetBaseItem=function()return cW end,GetKnobItem=function()return cX end,GetMinValue=function()return cY end,GetMaxValue=function()return cZ end,GetValue=function()return q end,SetValue=function(aA)db(d0(aA))end,GetTickFrequency=function()return d3 end,IsSnapToTick=function()return d7 end,AddListener=function(ch)cf[ch]=ch end,RemoveListener=function(ch)cf[ch]=nil end,DoUse=function()de=true;df=vci.me.UnscaledTime;dj()end,DoUnuse=function()de=false end,DoGrab=function()dc=true;dd=(q-c_)/d3 end,DoUngrab=function()dc=false end,Update=function()if dc then local dv=cV.GetPosition()-cW.GetPosition()local dw=cX.GetRotation()*d5;local dx=Vector3.Project(dv,dw)local dy=(Vector3.Dot(dw,dx)>=0 and 1 or-1)*dx.magnitude/d6+dd;local dz=(d7 and a.Round(dy)or dy)*d3+c_;local di=a.Clamp(dz,cY,cZ)if di~=q then db(di)end elseif de then local dA=vci.me.UnscaledTime;if dA>=df+d8 and dA>=dg+d9 then dj()end elseif cV.IsMine then a.AlignSubItemOrigin(cW,cV)end end}dh()return self end,CreateSubItemConnector=function()local dB=function(dC,cF,dD)dC.item=cF;dC.position=cF.GetPosition()dC.rotation=cF.GetRotation()dC.initialPosition=dC.position;dC.initialRotation=dC.rotation;dC.propagation=not not dD;return dC end;local dE=function(dF)for cF,dC in pairs(dF)do dB(dC,cF,dC.propagation)end end;local dG=function(dH,ba,dC,dI,dJ)local dv=dH-dC.initialPosition;local dK=ba*Quaternion.Inverse(dC.initialRotation)dC.position=dH;dC.rotation=ba;for cF,dL in pairs(dI)do if cF~=dC.item and(not dJ or dJ(dL))then dL.position,dL.rotation=a.RotateAround(dL.initialPosition+dv,dL.initialRotation,dH,dK)cF.SetPosition(dL.position)cF.SetRotation(dL.rotation)end end end;local dM={}local dN=true;local dO=false;local self;self={IsEnabled=function()return dN end,SetEnabled=function(aC)dN=aC;if aC then dE(dM)dO=false end end,Contains=function(dP)return a.NillableHasValue(dM[dP])end,Add=function(dQ,dR)if not dQ then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(dQ),2)end;local dS=type(dQ)=='table'and dQ or{dQ}dE(dM)dO=false;for N,cF in pairs(dS)do dM[cF]=dB({},cF,not dR)end end,Remove=function(dP)local aQ=a.NillableHasValue(dM[dP])dM[dP]=nil;return aQ end,RemoveAll=function()dM={}return true end,Each=function(ah)for cF,dC in pairs(dM)do if ah(cF,self)==false then return false end end end,GetItems=function()local dS={}for cF,dC in pairs(dM)do table.insert(dS,cF)end;return dS end,Update=function()if not dN then return end;local dT=false;for cF,dC in pairs(dM)do local dU=cF.GetPosition()local dV=cF.GetRotation()if not a.VectorApproximatelyEquals(dU,dC.position)or not a.QuaternionApproximatelyEquals(dV,dC.rotation)then if dC.propagation then if cF.IsMine then dG(dU,dV,dM[cF],dM,function(dL)if dL.item.IsMine then return true else dO=true;return false end end)dT=true;break else dO=true end else dO=true end end end;if not dT and dO then dE(dM)dO=false end end}return self end,GetSubItemTransform=function(dP)local dH=dP.GetPosition()local ba=dP.GetRotation()local dW=dP.GetLocalScale()return{positionX=dH.x,positionY=dH.y,positionZ=dH.z,rotationX=ba.x,rotationY=ba.y,rotationZ=ba.z,rotationW=ba.w,scaleX=dW.x,scaleY=dW.y,scaleZ=dW.z}end,RestoreCytanbTransform=function(dX)local dU=dX.positionX and dX.positionY and dX.positionZ and Vector3.__new(dX.positionX,dX.positionY,dX.positionZ)or nil;local dV=dX.rotationX and dX.rotationY and dX.rotationZ and dX.rotationW and Quaternion.__new(dX.rotationX,dX.rotationY,dX.rotationZ,dX.rotationW)or nil;local dW=dX.scaleX and dX.scaleY and dX.scaleZ and Vector3.__new(dX.scaleX,dX.scaleY,dX.scaleZ)or nil;return dU,dV,dW end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local c8='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local ce=_G[c8]if not ce then ce={}_G[c8]=ce end;local dY=ce.randomSeedValue;if not dY then dY=os.time()-os.clock()*10000;ce.randomSeedValue=dY;math.randomseed(dY)end;local dZ=ce.clientID;if type(dZ)~='string'then dZ=tostring(a.RandomUUID())ce.clientID=dZ end;local d_=vci.state.Get(b)or''if d_==''and vci.assets.IsMine then d_=tostring(a.RandomUUID())vci.state.Set(b,d_)end;return d_,dZ end)()return a end)()

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
