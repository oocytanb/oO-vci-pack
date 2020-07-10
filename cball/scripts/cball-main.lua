-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,{[a.EscapeSequenceTag]=a.EscapeSequenceTag..a.EscapeSequenceTag}),'/',{['/']=a.SolidusTag})end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;local af={['nil']=function(ag)return nil end,['number']=function(ag)return tonumber(ag)end,['string']=function(ag)return tostring(ag)end,['boolean']=function(ag)if ag then return true else return false end end}local ah=function(ag,ai)local aj=type(ag)if aj==ai then return ag else local ak=af[ai]if ak then return ak(ag)else return nil end end end;local al=function(am,an)if an and type(an)=='table'then local ao={}for z,ag in pairs(am)do local ap=an[z]local aq;if ap==nil then aq=ag else local ar=ah(ap,type(ag))if ar==nil then aq=ag else aq=ar end end;ao[z]=aq end;ao[a.MessageOriginalSender]=am;return ao else return am end end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(as)return as~=nil end,NillableValue=function(as)if as==nil then error('nillable: value is nil',2)end;return as end,NillableValueOrDefault=function(as,at)if as==nil then if at==nil then error('nillable: defaultValue is nil',2)end;return at else return as end end,NillableIfHasValue=function(as,au)if as==nil then return nil else return au(as)end end,NillableIfHasValueOrElse=function(as,au,av)if as==nil then return av()else return au(as)end end,StringReplace=function(P,aw,ax)local ay;local S=string.len(P)if aw==''then ay=ax;for n=1,S do ay=ay..string.sub(P,n,n)..ax end else ay=''local n=1;while true do local az,V=string.find(P,aw,n,true)if az then ay=ay..string.sub(P,n,az-1)..ax;n=V+1;if n>S then break end else ay=n==1 and P or ay..string.sub(P,n)break end end end;return ay end,SetConst=function(aw,aA,q)if type(aw)~='table'then error('Cannot set const to non-table target',2)end;local aB=getmetatable(aw)local A=aB or{}local aC=rawget(A,x)if rawget(aw,aA)~=nil then error('Non-const field "'..aA..'" already exists',2)end;if not aC then aC={}rawset(A,x,aC)A.__index=y;A.__newindex=D end;rawset(aC,aA,q)if not aB then setmetatable(aw,A)end;return aw end,SetConstEach=function(aw,aD)for N,E in pairs(aD)do a.SetConst(aw,N,E)end;return aw end,Extend=function(aw,aE,aF,aG,a3)if aw==aE or type(aw)~='table'or type(aE)~='table'then return aw end;if aF then if not a3 then a3={}end;if a3[aE]then error('circular reference')end;a3[aE]=true end;for N,E in pairs(aE)do if aF and type(E)=='table'then local aH=aw[N]aw[N]=a.Extend(type(aH)=='table'and aH or{},E,aF,aG,a3)else aw[N]=E end end;if not aG then local aI=getmetatable(aE)if type(aI)=='table'then if aF then local aJ=getmetatable(aw)setmetatable(aw,a.Extend(type(aJ)=='table'and aJ or{},aI,true))else setmetatable(aw,aI)end end end;if aF then a3[aE]=nil end;return aw end,Vars=function(E,aK,aL,a3)local aM;if aK then aM=aK~='__NOLF'else aK='  'aM=true end;if not aL then aL=''end;if not a3 then a3={}end;local aN=type(E)if aN=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local aO=aM and aL..aK or''local P='('..tostring(E)..') {'local aP=true;for z,ag in pairs(E)do if aP then aP=false else P=P..(aM and','or', ')end;if aM then P=P..'\n'..aO end;if type(ag)=='table'and a3[ag]and a3[ag]>0 then P=P..z..' = ('..tostring(ag)..')'else P=P..z..' = '..a.Vars(ag,aK,aO,a3)end end;if not aP and aM then P=P..'\n'..aL end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif aN=='function'or aN=='thread'or aN=='userdata'then return'('..aN..')'elseif aN=='string'then return'('..aN..') '..string.format('%q',E)else return'('..aN..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aQ)f=aQ end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aR)g=not not aR end,Log=function(aQ,...)if aQ<=f then local aS=g and(h[aQ]or'LOG LEVEL '..tostring(aQ))..' | 'or''local aT=table.pack(...)if aT.n==1 then local E=aT[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aS..P or P)else print(aS)end else local P=aS;for n=1,aT.n do local E=aT[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aU,aV)local aW={}if aV==nil then for N,E in pairs(aU)do aW[E]=E end elseif type(aV)=='function'then for N,E in pairs(aU)do local aX,aY=aV(E)aW[aX]=aY end else for N,E in pairs(aU)do aW[E]=aV end end;return aW end,Round=function(aZ,a_)if a_ then local b0=10^a_;return math.floor(aZ*b0+0.5)/b0 else return math.floor(aZ+0.5)end end,Clamp=function(q,b1,b2)return math.max(b1,math.min(q,b2))end,Lerp=function(b3,b4,aN)if aN<=0.0 then return b3 elseif aN>=1.0 then return b4 else return b3+(b4-b3)*aN end end,LerpUnclamped=function(b3,b4,aN)if aN==0.0 then return b3 elseif aN==1.0 then return b4 else return b3+(b4-b3)*aN end end,
PingPong=function(aN,b5)if b5==0 then return 0,1 end;local b6=math.floor(aN/b5)local b7=aN-b6*b5;if b6<0 then if(b6+1)%2==0 then return b5-b7,-1 else return b7,1 end else if b6%2==0 then return b7,1 else return b5-b7,-1 end end end,VectorApproximatelyEquals=function(b8,b9)return(b8-b9).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(b8,b9)local ba=Quaternion.Dot(b8,b9)return ba<1.0+1E-06 and ba>1.0-1E-06 end,QuaternionToAngleAxis=function(bb)local b6=bb.normalized;local bc=math.acos(b6.w)local bd=math.sin(bc)local be=math.deg(bc*2.0)local bf;if math.abs(bd)<=Quaternion.kEpsilon then bf=Vector3.right else local az=1.0/bd;bf=Vector3.__new(b6.x*az,b6.y*az,b6.z*az)end;return be,bf end,QuaternionTwist=function(bb,bg)if bg.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local bh=Vector3.__new(bb.x,bb.y,bb.z)if bh.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local bi=Vector3.Project(bh,bg)if bi.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local bj=Quaternion.__new(bi.x,bi.y,bi.z,bb.w)bj.Normalize()return bj else return Quaternion.AngleAxis(0,bg)end else local bk=a.QuaternionToAngleAxis(bb)return Quaternion.AngleAxis(bk,bg)end end,ApplyQuaternionToVector3=function(bb,bl)local bm=bb.w*bl.x+bb.y*bl.z-bb.z*bl.y;local bn=bb.w*bl.y-bb.x*bl.z+bb.z*bl.x;local bo=bb.w*bl.z+bb.x*bl.y-bb.y*bl.x;local bp=-bb.x*bl.x-bb.y*bl.y-bb.z*bl.z;return Vector3.__new(bp*-bb.x+bm*bb.w+bn*-bb.z-bo*-bb.y,bp*-bb.y-bm*-bb.z+bn*bb.w+bo*-bb.x,bp*-bb.z+bm*-bb.y-bn*-bb.x+bo*bb.w)end,RotateAround=function(bq,br,bs,bt)return bs+bt*(bq-bs),bt*br end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bu)return p.__tostring(bu)end,UUIDFromNumbers=function(...)local bv=...local aN=type(bv)local bw,bx,by,bz;if aN=='table'then bw=bv[1]bx=bv[2]by=bv[3]bz=bv[4]else bw,bx,by,bz=...end;local bu={bit32.band(bw or 0,0xFFFFFFFF),bit32.band(bx or 0,0xFFFFFFFF),bit32.band(by or 0,0xFFFFFFFF),bit32.band(bz or 0,0xFFFFFFFF)}setmetatable(bu,p)return bu end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bA='[0-9a-f-A-F]+'local bB='^('..bA..')$'local bC='^-('..bA..')$'local bD,bE,bF,bG;if S==32 then local bu=a.UUIDFromNumbers(0,0,0,0)local bH=1;for n,bI in ipairs({8,16,24,32})do bD,bE,bF=string.find(string.sub(P,bH,bI),bB)if not bD then return nil end;bu[n]=tonumber(bF,16)bH=bI+1 end;return bu else bD,bE,bF=string.find(string.sub(P,1,8),bB)if not bD then return nil end;local bw=tonumber(bF,16)bD,bE,bF=string.find(string.sub(P,9,13),bC)if not bD then return nil end;bD,bE,bG=string.find(string.sub(P,14,18),bC)if not bD then return nil end;local bx=tonumber(bF..bG,16)bD,bE,bF=string.find(string.sub(P,19,23),bC)if not bD then return nil end;bD,bE,bG=string.find(string.sub(P,24,28),bC)if not bD then return nil end;local by=tonumber(bF..bG,16)bD,bE,bF=string.find(string.sub(P,29,36),bB)if not bD then return nil end;local bz=tonumber(bF,16)return a.UUIDFromNumbers(bw,bx,by,bz)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bJ)if type(bJ)~='number'or bJ<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bJ),2)end;local self;local bK=math.floor(bJ)local U={}local bL=0;local bM=0;local bN=0;self={Size=function()return bN end,Clear=function()bL=0;bM=0;bN=0 end,IsEmpty=function()return bN==0 end,Offer=function(bO)U[bL+1]=bO;bL=(bL+1)%bK;if bN<bK then bN=bN+1 else bM=(bM+1)%bK end;return true end,OfferFirst=function(bO)bM=(bK+bM-1)%bK;U[bM+1]=bO;if bN<bK then bN=bN+1 else bL=(bK+bL-1)%bK end;return true end,Poll=function()if bN==0 then return nil else local bO=U[bM+1]bM=(bM+1)%bK;bN=bN-1;return bO end end,PollLast=function()if bN==0 then return nil else bL=(bK+bL-1)%bK;local bO=U[bL+1]bN=bN-1;return bO end end,Peek=function()if bN==0 then return nil else return U[bM+1]end end,PeekLast=function()if bN==0 then return nil else return U[(bK+bL-1)%bK+1]end end,Get=function(bP)if bP<1 or bP>bN then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bP)return nil end;return U[(bM+bP-1)%bK+1]end,IsFull=function()return bN>=bK end,MaxSize=function()return bK end}return self end,DetectClicks=function(bQ,bR,bS)local bT=bQ or 0;local bU=bS or TimeSpan.FromMilliseconds(500)local bV=vci.me.Time;local bW=bR and bV>bR+bU and 1 or bT+1;return bW,bV end,ColorRGBToHSV=function(bX)local b7=math.max(0.0,math.min(bX.r,1.0))local bY=math.max(0.0,math.min(bX.g,1.0))local b4=math.max(0.0,math.min(bX.b,1.0))local b2=math.max(b7,bY,b4)local b1=math.min(b7,bY,b4)local bZ=b2-b1;local C;if bZ==0.0 then C=0.0 elseif b2==b7 then C=(bY-b4)/bZ/6.0 elseif b2==bY then C=(2.0+(b4-b7)/bZ)/6.0 else C=(4.0+(b7-bY)/bZ)/6.0 end;if C<0.0 then C=C+1.0 end;local b_=b2==0.0 and bZ or bZ/b2;local E=b2;return C,b_,E end,ColorFromARGB32=function(c0)local c1=type(c0)=='number'and c0 or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(c1,16),0xFF)/0xFF,bit32.band(bit32.rshift(c1,8),0xFF)/0xFF,bit32.band(c1,0xFF)/0xFF,bit32.band(bit32.rshift(c1,24),0xFF)/0xFF)end,ColorToARGB32=function(bX)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bX.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bX.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bX.g),0xFF),8),bit32.band(a.Round(0xFF*bX.b),0xFF))end,ColorFromIndex=function(c2,c3,c4,c5,c6)local c7=math.max(math.floor(c3 or a.ColorHueSamples),1)local c8=c6 and c7 or c7-1;local c9=math.max(math.floor(c4 or a.ColorSaturationSamples),1)local ca=math.max(math.floor(c5 or a.ColorBrightnessSamples),1)local bP=a.Clamp(math.floor(c2 or 0),0,c7*c9*ca-1)local cb=bP%c7;local cc=math.floor(bP/c7)local az=cc%c9;local cd=math.floor(cc/c9)if c6 or cb~=c8 then local C=cb/c8;local b_=(c9-az)/c9;local E=(ca-cd)/ca;return Color.HSVToRGB(C,b_,E)else local E=(ca-cd)/ca*az/(c9-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bX,c3,c4,c5,c6)local c7=math.max(math.floor(c3 or a.ColorHueSamples),1)local c8=c6 and c7 or c7-1;local c9=math.max(math.floor(c4 or a.ColorSaturationSamples),1)local ca=math.max(math.floor(c5 or a.ColorBrightnessSamples),1)local C,b_,E=a.ColorRGBToHSV(bX)local az=a.Round(c9*(1.0-b_))if c6 or az<c9 then local ce=a.Round(c8*C)if ce>=c8 then ce=0 end;if az>=c9 then az=c9-1 end;local cd=math.min(ca-1,a.Round(ca*(1.0-E)))return ce+c7*(az+c9*cd)else local cf=a.Round((c9-1)*E)if cf==0 then local cg=a.Round(ca*(1.0-E))if cg>=ca then return c7-1 else return c7*(1+a.Round(E*(c9-1)/(ca-cg)*ca)+c9*cg)-1 end else return c7*(1+cf+c9*a.Round(ca*(1.0-E*(c9-1)/cf)))-1 end end end,ColorToTable=function(bX)return{[a.TypeParameterName]=a.ColorTypeName,r=bX.r,g=bX.g,b=bX.b,a=bX.a}end,ColorFromTable=function(G)local b4,M=F(G,a.ColorTypeName)return b4 and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local b4,M=F(G,a.Vector2TypeName)return b4 and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local b4,M=F(G,a.Vector3TypeName)return b4 and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local b4,M=F(G,a.Vector4TypeName)return b4 and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local b4,M=F(G,a.QuaternionTypeName)return b4 and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(aA,ch)local a4=a.NillableIfHasValueOrElse(ch,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(aA,json.serialize(a4))end,OnMessage=function(aA,au)local ak=function(am,ci,cj)if type(cj)=='string'and cj~=''and string.sub(cj,1,1)=='{'then local ck,a4=pcall(json.parse,cj)if ck and type(a4)=='table'and a4[a.InstanceIDParameterName]then local cl=a.TableFromSerializable(a4)au(al(am,cl[a.MessageSenderOverride]),ci,cl)return end end;au(am,ci,{[a.MessageValueParameterName]=cj})end;vci.message.On(aA,ak)return{Off=function()if ak then ak=nil end end}end,
OnInstanceMessage=function(aA,au)local ak=function(am,ci,ch)local cm=a.InstanceID()if cm~=''and cm==ch[a.InstanceIDParameterName]then au(am,ci,ch)end end;return a.OnMessage(aA,ak)end,EmitCommentMessage=function(cj,an)local cn={type='comment',name='',commentSource=''}local ch={[a.MessageValueParameterName]=tostring(cj),[a.MessageSenderOverride]=type(an)=='table'and a.Extend(cn,an,true)or cn}a.EmitMessage('comment',ch)end,OnCommentMessage=function(au)local ak=function(am,ci,ch)local cj=tostring(ch[a.MessageValueParameterName]or'')au(am,ci,cj)end;return a.OnMessage('comment',ak)end,EmitNotificationMessage=function(cj,an)local cn={type='notification',name='',commentSource=''}local ch={[a.MessageValueParameterName]=tostring(cj),[a.MessageSenderOverride]=type(an)=='table'and a.Extend(cn,an,true)or cn}a.EmitMessage('notification',ch)end,OnNotificationMessage=function(au)local ak=function(am,ci,ch)local cj=tostring(ch[a.MessageValueParameterName]or'')au(am,ci,cj)end;return a.OnMessage('notification',ak)end,GetEffekseerEmitterMap=function(aA)local co=vci.assets.GetEffekseerEmitters(aA)if not co then return nil end;local aW={}for n,cp in pairs(co)do aW[cp.EffectName]=cp end;return aW end,ClientID=function()return j end,ParseTagString=function(P)local cq=string.find(P,'#',1,true)if not cq then return{},P end;local cr={}local cs=string.sub(P,1,cq-1)cq=cq+1;local S=string.len(P)local ct='^[A-Za-z0-9_%-.()!~*\'%%]+'while cq<=S do local cu,cv=string.find(P,ct,cq)if cu then local cw=string.sub(P,cu,cv)local cx=cw;cq=cv+1;if cq<=S and string.sub(P,cq,cq)=='='then cq=cq+1;local cy,cz=string.find(P,ct,cq)if cy then cx=string.sub(P,cy,cz)cq=cz+1 else cx=''end end;cr[cw]=cx end;cq=string.find(P,'#',cq,true)if not cq then break end;cq=cq+1 end;return cr,cs end,CalculateSIPrefix=(function()local cA=9;local cB={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local cC=#cB;return function(aZ)local cD=aZ==0 and 0 or a.Clamp(math.floor(math.log(math.abs(aZ),1000)),1-cA,cC-cA)return cD==0 and aZ or aZ/1000^cD,cB[cA+cD],cD*3 end end)(),CreateLocalSharedProperties=function(cE,cF)local cG=TimeSpan.FromSeconds(5)local cH='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cI='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(cE)~='string'or string.len(cE)<=0 or type(cF)~='string'or string.len(cF)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cJ=_G[cH]if not cJ then cJ={}_G[cH]=cJ end;cJ[cF]=vci.me.UnscaledTime;local cK=_G[cE]if not cK then cK={[cI]={}}_G[cE]=cK end;local cL=cK[cI]local self;self={GetLspID=function()return cE end,GetLoadID=function()return cF end,GetProperty=function(z,at)local q=cK[z]if q==nil then return at else return q end end,SetProperty=function(z,q)if z==cI then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bV=vci.me.UnscaledTime;local cM=cK[z]cK[z]=q;for cN,cm in pairs(cL)do local aN=cJ[cm]if aN and aN+cG>=bV then cN(self,z,q,cM)else cN(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)cL[cN]=nil;cJ[cm]=nil end end end,Clear=function()for z,q in pairs(cK)do if z~=cI then self.SetProperty(z,nil)end end end,Each=function(au)for z,q in pairs(cK)do if z~=cI and au(q,z,self)==false then return false end end end,AddListener=function(cN)cL[cN]=cF end,RemoveListener=function(cN)cL[cN]=nil end,UpdateAlive=function()cJ[cF]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(cO)local cP=1.0;local cQ=1000.0;local cR=TimeSpan.FromSeconds(0.02)local cS=0xFFFF;local cT=a.CreateCircularQueue(64)local cU=TimeSpan.FromSeconds(5)local cV=TimeSpan.FromSeconds(30)local cW=false;local cX=vci.me.Time;local cY=a.Random32()local cZ=Vector3.__new(bit32.bor(0x400,bit32.band(cY,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cY,16),0x1FFF)),0.0)cO.SetPosition(cZ)cO.SetRotation(Quaternion.identity)cO.SetVelocity(Vector3.zero)cO.SetAngularVelocity(Vector3.zero)cO.AddForce(Vector3.__new(0.0,0.0,cP*cQ))local self={Timestep=function()return cR end,Precision=function()return cS end,IsFinished=function()return cW end,Update=function()if cW then return cR end;local c_=vci.me.Time-cX;local d0=c_.TotalSeconds;if d0<=Vector3.kEpsilon then return cR end;local d1=cO.GetPosition().z-cZ.z;local d2=d1/d0;local d3=d2/cQ;if d3<=Vector3.kEpsilon then return cR end;cT.Offer(d3)local d4=cT.Size()if d4>=2 and c_>=cU then local d5=0.0;for n=1,d4 do d5=d5+cT.Get(n)end;local d6=d5/d4;local d7=0.0;for n=1,d4 do d7=d7+(cT.Get(n)-d6)^2 end;local d8=d7/d4;if d8<cS then cS=d8;cR=TimeSpan.FromSeconds(d6)end;if c_>cV then cW=true;cO.SetPosition(cZ)cO.SetRotation(Quaternion.identity)cO.SetVelocity(Vector3.zero)cO.SetAngularVelocity(Vector3.zero)end else cR=TimeSpan.FromSeconds(d3)end;return cR end}return self end,AlignSubItemOrigin=function(d9,da,db)local dc=d9.GetRotation()if not a.QuaternionApproximatelyEquals(da.GetRotation(),dc)then da.SetRotation(dc)end;local dd=d9.GetPosition()if not a.VectorApproximatelyEquals(da.GetPosition(),dd)then da.SetPosition(dd)end;if db then da.SetVelocity(Vector3.zero)da.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local de={}local self;self={Contains=function(df,dg)return a.NillableIfHasValueOrElse(de[df],function(aD)return a.NillableHasValue(aD[dg])end,function()return false end)end,Add=function(df,dh,db)if not df or not dh then local di='SubItemGlue.Add: Invalid arguments '..(not df and', parent = '..tostring(df)or'')..(not dh and', children = '..tostring(dh)or'')error(di,2)end;local aD=a.NillableIfHasValueOrElse(de[df],function(dj)return dj end,function()local dj={}de[df]=dj;return dj end)if type(dh)=='table'then for z,ag in pairs(dh)do aD[ag]={velocityReset=not not db}end else aD[dh]={velocityReset=not not db}end end,Remove=function(df,dg)return a.NillableIfHasValueOrElse(de[df],function(aD)if a.NillableHasValue(aD[dg])then aD[dg]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(df)if a.NillableHasValue(de[df])then de[df]=nil;return true else return false end end,RemoveAll=function()de={}return true end,Each=function(au,dk)return a.NillableIfHasValueOrElse(dk,function(df)return a.NillableIfHasValue(de[df],function(aD)for dg,dl in pairs(aD)do if au(dg,df,self)==false then return false end end end)end,function()for df,aD in pairs(de)do if self.Each(au,df)==false then return false end end end)end,Update=function(dm)for df,aD in pairs(de)do local dn=df.GetPosition()local dp=df.GetRotation()for dg,dl in pairs(aD)do if dm or dg.IsMine then if not a.QuaternionApproximatelyEquals(dg.GetRotation(),dp)then dg.SetRotation(dp)end;if not a.VectorApproximatelyEquals(dg.GetPosition(),dn)then dg.SetPosition(dn)end;if dl.velocityReset then dg.SetVelocity(Vector3.zero)dg.SetAngularVelocity(Vector3.zero)end end end end end}return self end,CreateUpdateRoutine=function(dq,dr)return coroutine.wrap(function()local ds=TimeSpan.FromSeconds(30)local dt=vci.me.UnscaledTime;local du=dt;local bR=vci.me.Time;local dv=true;while true do local cm=a.InstanceID()if cm~=''then break end;local dw=vci.me.UnscaledTime;if dw-ds>dt then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;du=dw;bR=vci.me.Time;dv=false;coroutine.yield(100)end;if dv then du=vci.me.UnscaledTime;bR=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(dr,function(dx)dx()end)while true do local bV=vci.me.Time;local dy=bV-bR;local dw=vci.me.UnscaledTime;local dz=dw-du;dq(dy,dz)bR=bV;du=dw;coroutine.yield(100)end end)end,
CreateSlideSwitch=function(dA)local dB=a.NillableValue(dA.colliderItem)local dC=a.NillableValue(dA.baseItem)local dD=a.NillableValue(dA.knobItem)local dE=a.NillableValueOrDefault(dA.minValue,0)local dF=a.NillableValueOrDefault(dA.maxValue,10)if dE>=dF then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local dG=(dE+dF)*0.5;local dH=function(ag)local dI,dJ=a.PingPong(ag-dE,dF-dE)return dI+dE,dJ end;local q=dH(a.NillableValueOrDefault(dA.value,0))local dK=a.NillableIfHasValueOrElse(dA.tickFrequency,function(dL)if dL<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(dL,dF-dE)end,function()return(dF-dE)/10.0 end)local dM=a.NillableIfHasValueOrElse(dA.tickVector,function(bf)return Vector3.__new(bf.x,bf.y,bf.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local dN=dM.magnitude;if dN<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local dO=a.NillableValueOrDefault(dA.snapToTick,true)local dP=dA.valueTextName;local dQ=a.NillableValueOrDefault(dA.valueToText,tostring)local dR=TimeSpan.FromMilliseconds(1000)local dS=TimeSpan.FromMilliseconds(50)local dT,dU;local cL={}local self;local dV=false;local dW=0;local dX=false;local dY=TimeSpan.Zero;local dZ=TimeSpan.Zero;local d_=function(e0,e1)if e1 or e0~=q then local cM=q;q=e0;for cN,E in pairs(cL)do cN(self,q,cM)end end;dD.SetLocalPosition((e0-dG)/dK*dM)if dP then vci.assets.SetText(dP,dQ(e0,self))end end;local e2=function()local e3=dT()local e4,e5=dH(e3)local e6=e3+dK;local e7,e8=dH(e6)assert(e7)local e0;if e5==e8 or e4==dF or e4==dE then e0=e6 else e0=e5>=0 and dF or dE end;dZ=vci.me.UnscaledTime;if e0==dF or e0==dE then dY=dZ end;dU(e0)end;a.NillableIfHasValueOrElse(dA.lsp,function(e9)if not a.NillableHasValue(dA.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local ea=a.NillableValue(dA.propertyName)dT=function()return e9.GetProperty(ea,q)end;dU=function(ag)e9.SetProperty(ea,ag)end;e9.AddListener(function(aE,z,eb,ec)if z==ea then d_(dH(eb),true)end end)end,function()local eb=q;dT=function()return eb end;dU=function(ag)eb=ag;d_(dH(ag),true)end end)self={GetColliderItem=function()return dB end,GetBaseItem=function()return dC end,GetKnobItem=function()return dD end,GetMinValue=function()return dE end,GetMaxValue=function()return dF end,GetValue=function()return q end,GetScaleValue=function(ed,ee)assert(ed<=ee)return ed+(ee-ed)*(q-dE)/(dF-dE)end,SetValue=function(ag)dU(dH(ag))end,GetTickFrequency=function()return dK end,IsSnapToTick=function()return dO end,AddListener=function(cN)cL[cN]=cN end,RemoveListener=function(cN)cL[cN]=nil end,DoUse=function()if not dV then dX=true;dY=vci.me.UnscaledTime;e2()end end,DoUnuse=function()dX=false end,DoGrab=function()if not dX then dV=true;dW=(q-dG)/dK end end,DoUngrab=function()dV=false end,Update=function()if dV then local ef=dB.GetPosition()-dC.GetPosition()local eg=dD.GetRotation()*dM;local eh=Vector3.Project(ef,eg)local ei=(Vector3.Dot(eg,eh)>=0 and 1 or-1)*eh.magnitude/dN+dW;local ej=(dO and a.Round(ei)or ei)*dK+dG;local e0=a.Clamp(ej,dE,dF)if e0~=q then dU(e0)end elseif dX then local ek=vci.me.UnscaledTime;if ek>=dY+dR and ek>=dZ+dS then e2()end elseif dB.IsMine then a.AlignSubItemOrigin(dC,dB)end end}d_(dH(dT()),false)return self end,CreateSubItemConnector=function()local el=function(em,da,en)em.item=da;em.position=da.GetPosition()em.rotation=da.GetRotation()em.initialPosition=em.position;em.initialRotation=em.rotation;em.propagation=not not en;return em end;local eo=function(ep)for da,em in pairs(ep)do el(em,da,em.propagation)end end;local eq=function(er,bt,em,es,et)local ef=er-em.initialPosition;local eu=bt*Quaternion.Inverse(em.initialRotation)em.position=er;em.rotation=bt;for da,ev in pairs(es)do if da~=em.item and(not et or et(ev))then ev.position,ev.rotation=a.RotateAround(ev.initialPosition+ef,ev.initialRotation,er,eu)da.SetPosition(ev.position)da.SetRotation(ev.rotation)end end end;local ew={}local ex=true;local ey=false;local self;self={IsEnabled=function()return ex end,SetEnabled=function(aR)ex=aR;if aR then eo(ew)ey=false end end,Contains=function(ez)return a.NillableHasValue(ew[ez])end,Add=function(eA,eB)if not eA then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(eA),2)end;local eC=type(eA)=='table'and eA or{eA}eo(ew)ey=false;for N,da in pairs(eC)do ew[da]=el({},da,not eB)end end,Remove=function(ez)local b4=a.NillableHasValue(ew[ez])ew[ez]=nil;return b4 end,RemoveAll=function()ew={}return true end,Each=function(au)for da,em in pairs(ew)do if au(da,self)==false then return false end end end,GetItems=function()local eC={}for da,em in pairs(ew)do table.insert(eC,da)end;return eC end,Update=function()if not ex then return end;local eD=false;for da,em in pairs(ew)do local cq=da.GetPosition()local eE=da.GetRotation()if not a.VectorApproximatelyEquals(cq,em.position)or not a.QuaternionApproximatelyEquals(eE,em.rotation)then if em.propagation then if da.IsMine then eq(cq,eE,ew[da],ew,function(ev)if ev.item.IsMine then return true else ey=true;return false end end)eD=true;break else ey=true end else ey=true end end end;if not eD and ey then eo(ew)ey=false end end}return self end,GetSubItemTransform=function(ez)local er=ez.GetPosition()local bt=ez.GetRotation()local eF=ez.GetLocalScale()return{positionX=er.x,positionY=er.y,positionZ=er.z,rotationX=bt.x,rotationY=bt.y,rotationZ=bt.z,rotationW=bt.w,scaleX=eF.x,scaleY=eF.y,scaleZ=eF.z}end,RestoreCytanbTransform=function(eG)local cq=eG.positionX and eG.positionY and eG.positionZ and Vector3.__new(eG.positionX,eG.positionY,eG.positionZ)or nil;local eE=eG.rotationX and eG.rotationY and eG.rotationZ and eG.rotationW and Quaternion.__new(eG.rotationX,eG.rotationY,eG.rotationZ,eG.rotationW)or nil;local eF=eG.scaleX and eG.scaleY and eG.scaleZ and Vector3.__new(eG.scaleX,eG.scaleY,eG.scaleZ)or nil;return cq,eE,eF end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',MessageSenderOverride='__CYTANB_MESSAGE_SENDER_OVERRIDE',MessageOriginalSender='__CYTANB_MESSAGE_ORIGINAL_SENDER',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local cE='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local cK=_G[cE]if not cK then cK={}_G[cE]=cK end;local eH=cK.randomSeedValue;if not eH then eH=os.time()-os.clock()*10000;cK.randomSeedValue=eH;math.randomseed(eH)end;local eI=cK.clientID;if type(eI)~='string'then eI=tostring(a.RandomUUID())cK.clientID=eI end;local eJ=vci.state.Get(b)or''if eJ==''and vci.assets.IsMine then eJ=tostring(a.RandomUUID())vci.state.Set(b,eJ)end;return eJ,eI end)()return a end)()

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
