-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local j;local a;local k=function(l,m)for n=1,4 do local o=l[n]-m[n]if o~=0 then return o end end;return 0 end;local p;p={__eq=function(l,m)return l[1]==m[1]and l[2]==m[2]and l[3]==m[3]and l[4]==m[4]end,__lt=function(l,m)return k(l,m)<0 end,__le=function(l,m)return k(l,m)<=0 end,__tostring=function(q)local r=q[2]or 0;local s=q[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(q[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(bit32.rshift(s,16),0xFFFF),bit32.band(s,0xFFFF),bit32.band(q[4]or 0,0xFFFFFFFF))end,__concat=function(l,m)local t=getmetatable(l)local u=t==p or type(t)=='table'and t.__concat==p.__concat;local v=getmetatable(m)local w=v==p or type(v)=='table'and v.__concat==p.__concat;if not u and not w then error('UUID: attempt to concatenate illegal values',2)end;return(u and p.__tostring(l)or l)..(w and p.__tostring(m)or m)end}local x='__CYTANB_CONST_VARIABLES'local y=function(table,z)local A=getmetatable(table)if A then local B=rawget(A,x)if B then local C=rawget(B,z)if type(C)=='function'then return C(table,z)else return C end end end;return nil end;local D=function(table,z,E)local A=getmetatable(table)if A then local B=rawget(A,x)if B then if rawget(B,z)~=nil then error('Cannot assign to read only field "'..z..'"',2)end end end;rawset(table,z,E)end;local F=function(G,H)local I=G[a.TypeParameterName]if a.NillableHasValue(I)and a.NillableValue(I)~=H then return false,false end;return a.NillableIfHasValueOrElse(c[H],function(J)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,E in pairs(G)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end,function()return false,false end)end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,{[a.EscapeSequenceTag]=a.EscapeSequenceTag..a.EscapeSequenceTag}),'/',{['/']=a.SolidusTag})end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local n=1;while n<S do local V,W=string.find(P,a.EscapeSequenceTag,n,true)if not V then if n==1 then U=P else U=U..string.sub(P,n)end;break end;if V>n then U=U..string.sub(P,n,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)n=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;n=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,E in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(E)if a7=='string'then a4[a6]=O(E)elseif a7=='number'and E<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(E)else a4[a6]=a1(E,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,E in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(E)=='string'then a2[a6]=tonumber(E)elseif type(E)=='string'then a2[a6]=Q(E,function(ac)return e[ac]end)else a2[a6]=a8(E,a9)end end;if not a9 then a.NillableIfHasValue(a2[a.TypeParameterName],function(ad)a.NillableIfHasValue(c[ad],function(J)local ae,M=J.fromTableFunc(a2)if not M then a.NillableIfHasValue(ae,function(q)a2=q end)end end)end)end;return a2 end;local af={['nil']=function(ag)return nil end,['number']=function(ag)return tonumber(ag)end,['string']=function(ag)return tostring(ag)end,['boolean']=function(ag)if ag then return true else return false end end}local ah=function(ag,ai)local aj=type(ag)if aj==ai then return ag else local ak=af[ai]if ak then return ak(ag)else return nil end end end;local al=function(am,an)if an and type(an)=='table'then local ao={}for z,ag in pairs(am)do local ap=an[z]local aq;if ap==nil then aq=ag else local ar=ah(ap,type(ag))if ar==nil then aq=ag else aq=ar end end;ao[z]=aq end;ao[a.MessageOriginalSender]=am;return ao else return am end end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(as)return as~=nil end,NillableValue=function(as)if as==nil then error('nillable: value is nil',2)end;return as end,NillableValueOrDefault=function(as,at)if as==nil then if at==nil then error('nillable: defaultValue is nil',2)end;return at else return as end end,NillableIfHasValue=function(as,au)if as==nil then return nil else return au(as)end end,NillableIfHasValueOrElse=function(as,au,av)if as==nil then return av()else return au(as)end end,StringReplace=function(P,aw,ax)local ay;local S=string.len(P)if aw==''then ay=ax;for n=1,S do ay=ay..string.sub(P,n,n)..ax end else ay=''local n=1;while true do local az,V=string.find(P,aw,n,true)if az then ay=ay..string.sub(P,n,az-1)..ax;n=V+1;if n>S then break end else ay=n==1 and P or ay..string.sub(P,n)break end end end;return ay end,SetConst=function(aw,aA,q)if type(aw)~='table'then error('Cannot set const to non-table target',2)end;local aB=getmetatable(aw)local A=aB or{}local aC=rawget(A,x)if rawget(aw,aA)~=nil then error('Non-const field "'..aA..'" already exists',2)end;if not aC then aC={}rawset(A,x,aC)A.__index=y;A.__newindex=D end;rawset(aC,aA,q)if not aB then setmetatable(aw,A)end;return aw end,SetConstEach=function(aw,aD)for N,E in pairs(aD)do a.SetConst(aw,N,E)end;return aw end,Extend=function(aw,aE,aF,aG,a3)if aw==aE or type(aw)~='table'or type(aE)~='table'then return aw end;if aF then if not a3 then a3={}end;if a3[aE]then error('circular reference')end;a3[aE]=true end;for N,E in pairs(aE)do if aF and type(E)=='table'then local aH=aw[N]aw[N]=a.Extend(type(aH)=='table'and aH or{},E,aF,aG,a3)else aw[N]=E end end;if not aG then local aI=getmetatable(aE)if type(aI)=='table'then if aF then local aJ=getmetatable(aw)setmetatable(aw,a.Extend(type(aJ)=='table'and aJ or{},aI,true))else setmetatable(aw,aI)end end end;if aF then a3[aE]=nil end;return aw end,Vars=function(E,aK,aL,a3)local aM;if aK then aM=aK~='__NOLF'else aK='  'aM=true end;if not aL then aL=''end;if not a3 then a3={}end;local aN=type(E)if aN=='table'then a3[E]=a3[E]and a3[E]+1 or 1;local aO=aM and aL..aK or''local P='('..tostring(E)..') {'local aP=true;for z,ag in pairs(E)do if aP then aP=false else P=P..(aM and','or', ')end;if aM then P=P..'\n'..aO end;if type(ag)=='table'and a3[ag]and a3[ag]>0 then P=P..z..' = ('..tostring(ag)..')'else P=P..z..' = '..a.Vars(ag,aK,aO,a3)end end;if not aP and aM then P=P..'\n'..aL end;P=P..'}'a3[E]=a3[E]-1;if a3[E]<=0 then a3[E]=nil end;return P elseif aN=='function'or aN=='thread'or aN=='userdata'then return'('..aN..')'elseif aN=='string'then return'('..aN..') '..string.format('%q',E)else return'('..aN..') '..tostring(E)end end,GetLogLevel=function()return f end,SetLogLevel=function(aQ)f=aQ end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aR)g=not not aR end,Log=function(aQ,...)if aQ<=f then local aS=g and(h[aQ]or'LOG LEVEL '..tostring(aQ))..' | 'or''local aT=table.pack(...)if aT.n==1 then local E=aT[1]if E~=nil then local P=type(E)=='table'and a.Vars(E)or tostring(E)print(g and aS..P or P)else print(aS)end else local P=aS;for n=1,aT.n do local E=aT[n]if E~=nil then P=P..(type(E)=='table'and a.Vars(E)or tostring(E))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aU,aV)local aW={}if aV==nil then for N,E in pairs(aU)do aW[E]=E end elseif type(aV)=='function'then for N,E in pairs(aU)do local aX,aY=aV(E)aW[aX]=aY end else for N,E in pairs(aU)do aW[E]=aV end end;return aW end,Round=function(aZ,a_)if a_ then local b0=10^a_;return math.floor(aZ*b0+0.5)/b0 else return math.floor(aZ+0.5)end end,Clamp=function(q,b1,b2)return math.max(b1,math.min(q,b2))end,Lerp=function(b3,b4,aN)if aN<=0.0 then return b3 elseif aN>=1.0 then return b4 else return b3+(b4-b3)*aN end end,LerpUnclamped=function(b3,b4,aN)if aN==0.0 then return b3 elseif aN==1.0 then return b4 else return b3+(b4-b3)*aN end end,
PingPong=function(aN,b5)if b5==0 then return 0,1 end;local b6=math.floor(aN/b5)local b7=aN-b6*b5;if b6<0 then if(b6+1)%2==0 then return b5-b7,-1 else return b7,1 end else if b6%2==0 then return b7,1 else return b5-b7,-1 end end end,VectorApproximatelyEquals=function(b8,b9)return(b8-b9).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(b8,b9)local ba=Quaternion.Dot(b8,b9)return ba<1.0+1E-06 and ba>1.0-1E-06 end,QuaternionToAngleAxis=function(bb)local b6=bb.normalized;local bc=math.acos(b6.w)local bd=math.sin(bc)local be=math.deg(bc*2.0)local bf;if math.abs(bd)<=Quaternion.kEpsilon then bf=Vector3.right else local az=1.0/bd;bf=Vector3.__new(b6.x*az,b6.y*az,b6.z*az)end;return be,bf end,QuaternionTwist=function(bb,bg)if bg.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local bh=Vector3.__new(bb.x,bb.y,bb.z)if bh.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local bi=Vector3.Project(bh,bg)if bi.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local bj=Quaternion.__new(bi.x,bi.y,bi.z,bb.w)bj.Normalize()return bj else return Quaternion.AngleAxis(0,bg)end else local bk=a.QuaternionToAngleAxis(bb)return Quaternion.AngleAxis(bk,bg)end end,ApplyQuaternionToVector3=function(bb,bl)local bm=bb.w*bl.x+bb.y*bl.z-bb.z*bl.y;local bn=bb.w*bl.y-bb.x*bl.z+bb.z*bl.x;local bo=bb.w*bl.z+bb.x*bl.y-bb.y*bl.x;local bp=-bb.x*bl.x-bb.y*bl.y-bb.z*bl.z;return Vector3.__new(bp*-bb.x+bm*bb.w+bn*-bb.z-bo*-bb.y,bp*-bb.y-bm*-bb.z+bn*bb.w+bo*-bb.x,bp*-bb.z+bm*-bb.y-bn*-bb.x+bo*bb.w)end,RotateAround=function(bq,br,bs,bt)return bs+bt*(bq-bs),bt*br end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bu)return p.__tostring(bu)end,UUIDFromNumbers=function(...)local bv=...local aN=type(bv)local bw,bx,by,bz;if aN=='table'then bw=bv[1]bx=bv[2]by=bv[3]bz=bv[4]else bw,bx,by,bz=...end;local bu={bit32.band(bw or 0,0xFFFFFFFF),bit32.band(bx or 0,0xFFFFFFFF),bit32.band(by or 0,0xFFFFFFFF),bit32.band(bz or 0,0xFFFFFFFF)}setmetatable(bu,p)return bu end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bA='[0-9a-f-A-F]+'local bB='^('..bA..')$'local bC='^-('..bA..')$'local bD,bE,bF,bG;if S==32 then local bu=a.UUIDFromNumbers(0,0,0,0)local bH=1;for n,bI in ipairs({8,16,24,32})do bD,bE,bF=string.find(string.sub(P,bH,bI),bB)if not bD then return nil end;bu[n]=tonumber(bF,16)bH=bI+1 end;return bu else bD,bE,bF=string.find(string.sub(P,1,8),bB)if not bD then return nil end;local bw=tonumber(bF,16)bD,bE,bF=string.find(string.sub(P,9,13),bC)if not bD then return nil end;bD,bE,bG=string.find(string.sub(P,14,18),bC)if not bD then return nil end;local bx=tonumber(bF..bG,16)bD,bE,bF=string.find(string.sub(P,19,23),bC)if not bD then return nil end;bD,bE,bG=string.find(string.sub(P,24,28),bC)if not bD then return nil end;local by=tonumber(bF..bG,16)bD,bE,bF=string.find(string.sub(P,29,36),bB)if not bD then return nil end;local bz=tonumber(bF,16)return a.UUIDFromNumbers(bw,bx,by,bz)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bJ)if type(bJ)~='number'or bJ<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(bJ),2)end;local self;local bK=math.floor(bJ)local U={}local bL=0;local bM=0;local bN=0;self={Size=function()return bN end,Clear=function()bL=0;bM=0;bN=0 end,IsEmpty=function()return bN==0 end,Offer=function(bO)U[bL+1]=bO;bL=(bL+1)%bK;if bN<bK then bN=bN+1 else bM=(bM+1)%bK end;return true end,OfferFirst=function(bO)bM=(bK+bM-1)%bK;U[bM+1]=bO;if bN<bK then bN=bN+1 else bL=(bK+bL-1)%bK end;return true end,Poll=function()if bN==0 then return nil else local bO=U[bM+1]bM=(bM+1)%bK;bN=bN-1;return bO end end,PollLast=function()if bN==0 then return nil else bL=(bK+bL-1)%bK;local bO=U[bL+1]bN=bN-1;return bO end end,Peek=function()if bN==0 then return nil else return U[bM+1]end end,PeekLast=function()if bN==0 then return nil else return U[(bK+bL-1)%bK+1]end end,Get=function(bP)if bP<1 or bP>bN then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bP)return nil end;return U[(bM+bP-1)%bK+1]end,IsFull=function()return bN>=bK end,MaxSize=function()return bK end}return self end,DetectClicks=function(bQ,bR,bS)local bT=bQ or 0;local bU=bS or TimeSpan.FromMilliseconds(500)local bV=vci.me.Time;local bW=bR and bV>bR+bU and 1 or bT+1;return bW,bV end,ColorRGBToHSV=function(bX)local b7=math.max(0.0,math.min(bX.r,1.0))local bY=math.max(0.0,math.min(bX.g,1.0))local b4=math.max(0.0,math.min(bX.b,1.0))local b2=math.max(b7,bY,b4)local b1=math.min(b7,bY,b4)local bZ=b2-b1;local C;if bZ==0.0 then C=0.0 elseif b2==b7 then C=(bY-b4)/bZ/6.0 elseif b2==bY then C=(2.0+(b4-b7)/bZ)/6.0 else C=(4.0+(b7-bY)/bZ)/6.0 end;if C<0.0 then C=C+1.0 end;local b_=b2==0.0 and bZ or bZ/b2;local E=b2;return C,b_,E end,ColorFromARGB32=function(c0)local c1=type(c0)=='number'and c0 or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(c1,16),0xFF)/0xFF,bit32.band(bit32.rshift(c1,8),0xFF)/0xFF,bit32.band(c1,0xFF)/0xFF,bit32.band(bit32.rshift(c1,24),0xFF)/0xFF)end,ColorToARGB32=function(bX)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bX.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bX.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bX.g),0xFF),8),bit32.band(a.Round(0xFF*bX.b),0xFF))end,ColorFromIndex=function(c2,c3,c4,c5,c6)local c7=math.max(math.floor(c3 or a.ColorHueSamples),1)local c8=c6 and c7 or c7-1;local c9=math.max(math.floor(c4 or a.ColorSaturationSamples),1)local ca=math.max(math.floor(c5 or a.ColorBrightnessSamples),1)local bP=a.Clamp(math.floor(c2 or 0),0,c7*c9*ca-1)local cb=bP%c7;local cc=math.floor(bP/c7)local az=cc%c9;local cd=math.floor(cc/c9)if c6 or cb~=c8 then local C=cb/c8;local b_=(c9-az)/c9;local E=(ca-cd)/ca;return Color.HSVToRGB(C,b_,E)else local E=(ca-cd)/ca*az/(c9-1)return Color.HSVToRGB(0.0,0.0,E)end end,ColorToIndex=function(bX,c3,c4,c5,c6)local c7=math.max(math.floor(c3 or a.ColorHueSamples),1)local c8=c6 and c7 or c7-1;local c9=math.max(math.floor(c4 or a.ColorSaturationSamples),1)local ca=math.max(math.floor(c5 or a.ColorBrightnessSamples),1)local C,b_,E=a.ColorRGBToHSV(bX)local az=a.Round(c9*(1.0-b_))if c6 or az<c9 then local ce=a.Round(c8*C)if ce>=c8 then ce=0 end;if az>=c9 then az=c9-1 end;local cd=math.min(ca-1,a.Round(ca*(1.0-E)))return ce+c7*(az+c9*cd)else local cf=a.Round((c9-1)*E)if cf==0 then local cg=a.Round(ca*(1.0-E))if cg>=ca then return c7-1 else return c7*(1+a.Round(E*(c9-1)/(ca-cg)*ca)+c9*cg)-1 end else return c7*(1+cf+c9*a.Round(ca*(1.0-E*(c9-1)/cf)))-1 end end end,ColorToTable=function(bX)return{[a.TypeParameterName]=a.ColorTypeName,r=bX.r,g=bX.g,b=bX.b,a=bX.a}end,ColorFromTable=function(G)local b4,M=F(G,a.ColorTypeName)return b4 and Color.__new(G.r,G.g,G.b,G.a)or nil,M end,Vector2ToTable=function(q)return{[a.TypeParameterName]=a.Vector2TypeName,x=q.x,y=q.y}end,Vector2FromTable=function(G)local b4,M=F(G,a.Vector2TypeName)return b4 and Vector2.__new(G.x,G.y)or nil,M end,Vector3ToTable=function(q)return{[a.TypeParameterName]=a.Vector3TypeName,x=q.x,y=q.y,z=q.z}end,Vector3FromTable=function(G)local b4,M=F(G,a.Vector3TypeName)return b4 and Vector3.__new(G.x,G.y,G.z)or nil,M end,Vector4ToTable=function(q)return{[a.TypeParameterName]=a.Vector4TypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,Vector4FromTable=function(G)local b4,M=F(G,a.Vector4TypeName)return b4 and Vector4.__new(G.x,G.y,G.z,G.w)or nil,M end,QuaternionToTable=function(q)return{[a.TypeParameterName]=a.QuaternionTypeName,x=q.x,y=q.y,z=q.z,w=q.w}end,QuaternionFromTable=function(G)local b4,M=F(G,a.QuaternionTypeName)return b4 and Quaternion.__new(G.x,G.y,G.z,G.w)or nil,M end,TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(aA,ch)local a4=a.NillableIfHasValueOrElse(ch,function(a2)if type(a2)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(a2)end,function()return{}end)a4[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(aA,json.serialize(a4))end,OnMessage=function(aA,au)local ak=function(am,ci,cj)if type(cj)=='string'and cj~=''and string.sub(cj,1,1)=='{'then local ck,a4=pcall(json.parse,cj)if ck and type(a4)=='table'and a4[a.InstanceIDParameterName]then local cl=a.TableFromSerializable(a4)au(al(am,cl[a.MessageSenderOverride]),ci,cl)return end end;au(am,ci,{[a.MessageValueParameterName]=cj})end;vci.message.On(aA,ak)return{Off=function()if ak then ak=nil end end}end,
OnInstanceMessage=function(aA,au)local ak=function(am,ci,ch)local cm=a.InstanceID()if cm~=''and cm==ch[a.InstanceIDParameterName]then au(am,ci,ch)end end;return a.OnMessage(aA,ak)end,EmitCommentMessage=function(cj,an)local cn={type='comment',name='',commentSource=''}local ch={[a.MessageValueParameterName]=tostring(cj),[a.MessageSenderOverride]=type(an)=='table'and a.Extend(cn,an,true)or cn}a.EmitMessage('comment',ch)end,OnCommentMessage=function(au)local ak=function(am,ci,ch)local cj=tostring(ch[a.MessageValueParameterName]or'')au(am,ci,cj)end;return a.OnMessage('comment',ak)end,EmitNotificationMessage=function(cj,an)local cn={type='notification',name='',commentSource=''}local ch={[a.MessageValueParameterName]=tostring(cj),[a.MessageSenderOverride]=type(an)=='table'and a.Extend(cn,an,true)or cn}a.EmitMessage('notification',ch)end,OnNotificationMessage=function(au)local ak=function(am,ci,ch)local cj=tostring(ch[a.MessageValueParameterName]or'')au(am,ci,cj)end;return a.OnMessage('notification',ak)end,GetEffekseerEmitterMap=function(aA)local co=vci.assets.GetEffekseerEmitters(aA)if not co then return nil end;local aW={}for n,cp in pairs(co)do aW[cp.EffectName]=cp end;return aW end,ClientID=function()return j end,ParseTagString=function(P)local cq=string.find(P,'#',1,true)if not cq then return{},P end;local cr={}local cs=string.sub(P,1,cq-1)cq=cq+1;local S=string.len(P)local ct='^[A-Za-z0-9_%-.()!~*\'%%]+'while cq<=S do local cu,cv=string.find(P,ct,cq)if cu then local cw=string.sub(P,cu,cv)local cx=cw;cq=cv+1;if cq<=S and string.sub(P,cq,cq)=='='then cq=cq+1;local cy,cz=string.find(P,ct,cq)if cy then cx=string.sub(P,cy,cz)cq=cz+1 else cx=''end end;cr[cw]=cx end;cq=string.find(P,'#',cq,true)if not cq then break end;cq=cq+1 end;return cr,cs end,CalculateSIPrefix=(function()local cA=9;local cB={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local cC=#cB;return function(aZ)local cD=aZ==0 and 0 or a.Clamp(math.floor(math.log(math.abs(aZ),1000)),1-cA,cC-cA)return cD==0 and aZ or aZ/1000^cD,cB[cA+cD],cD*3 end end)(),CreateLocalSharedProperties=function(cE,cF)local cG=TimeSpan.FromSeconds(5)local cH='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local cI='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(cE)~='string'or string.len(cE)<=0 or type(cF)~='string'or string.len(cF)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local cJ=_G[cH]if not cJ then cJ={}_G[cH]=cJ end;cJ[cF]=vci.me.UnscaledTime;local cK=_G[cE]if not cK then cK={[cI]={}}_G[cE]=cK end;local cL=cK[cI]local self;self={GetLspID=function()return cE end,GetLoadID=function()return cF end,GetProperty=function(z,at)local q=cK[z]if q==nil then return at else return q end end,SetProperty=function(z,q)if z==cI then error('LocalSharedProperties: Invalid argument: key = ',z,2)end;local bV=vci.me.UnscaledTime;local cM=cK[z]cK[z]=q;for cN,cm in pairs(cL)do local aN=cJ[cm]if aN and aN+cG>=bV then cN(self,z,q,cM)else cN(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)cL[cN]=nil;cJ[cm]=nil end end end,Clear=function()for z,q in pairs(cK)do if z~=cI then self.SetProperty(z,nil)end end end,Each=function(au)for z,q in pairs(cK)do if z~=cI and au(q,z,self)==false then return false end end end,AddListener=function(cN)cL[cN]=cF end,RemoveListener=function(cN)cL[cN]=nil end,UpdateAlive=function()cJ[cF]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(cO)local cP=1.0;local cQ=1000.0;local cR=TimeSpan.FromSeconds(0.02)local cS=0xFFFF;local cT=a.CreateCircularQueue(64)local cU=TimeSpan.FromSeconds(5)local cV=TimeSpan.FromSeconds(30)local cW=false;local cX=vci.me.Time;local cY=a.Random32()local cZ=Vector3.__new(bit32.bor(0x400,bit32.band(cY,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cY,16),0x1FFF)),0.0)cO.SetPosition(cZ)cO.SetRotation(Quaternion.identity)cO.SetVelocity(Vector3.zero)cO.SetAngularVelocity(Vector3.zero)cO.AddForce(Vector3.__new(0.0,0.0,cP*cQ))local self={Timestep=function()return cR end,Precision=function()return cS end,IsFinished=function()return cW end,Update=function()if cW then return cR end;local c_=vci.me.Time-cX;local d0=c_.TotalSeconds;if d0<=Vector3.kEpsilon then return cR end;local d1=cO.GetPosition().z-cZ.z;local d2=d1/d0;local d3=d2/cQ;if d3<=Vector3.kEpsilon then return cR end;cT.Offer(d3)local d4=cT.Size()if d4>=2 and c_>=cU then local d5=0.0;for n=1,d4 do d5=d5+cT.Get(n)end;local d6=d5/d4;local d7=0.0;for n=1,d4 do d7=d7+(cT.Get(n)-d6)^2 end;local d8=d7/d4;if d8<cS then cS=d8;cR=TimeSpan.FromSeconds(d6)end;if c_>cV then cW=true;cO.SetPosition(cZ)cO.SetRotation(Quaternion.identity)cO.SetVelocity(Vector3.zero)cO.SetAngularVelocity(Vector3.zero)end else cR=TimeSpan.FromSeconds(d3)end;return cR end}return self end,AlignSubItemOrigin=function(d9,da,db)local dc=d9.GetRotation()if not a.QuaternionApproximatelyEquals(da.GetRotation(),dc)then da.SetRotation(dc)end;local dd=d9.GetPosition()if not a.VectorApproximatelyEquals(da.GetPosition(),dd)then da.SetPosition(dd)end;if db then da.SetVelocity(Vector3.zero)da.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local de={}local self;self={Contains=function(df,dg)return a.NillableIfHasValueOrElse(de[df],function(aD)return a.NillableHasValue(aD[dg])end,function()return false end)end,Add=function(df,dh,db)if not df or not dh then local di='SubItemGlue.Add: Invalid arguments '..(not df and', parent = '..tostring(df)or'')..(not dh and', children = '..tostring(dh)or'')error(di,2)end;local aD=a.NillableIfHasValueOrElse(de[df],function(dj)return dj end,function()local dj={}de[df]=dj;return dj end)if type(dh)=='table'then for z,ag in pairs(dh)do aD[ag]={velocityReset=not not db}end else aD[dh]={velocityReset=not not db}end end,Remove=function(df,dg)return a.NillableIfHasValueOrElse(de[df],function(aD)if a.NillableHasValue(aD[dg])then aD[dg]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(df)if a.NillableHasValue(de[df])then de[df]=nil;return true else return false end end,RemoveAll=function()de={}return true end,Each=function(au,dk)return a.NillableIfHasValueOrElse(dk,function(df)return a.NillableIfHasValue(de[df],function(aD)for dg,dl in pairs(aD)do if au(dg,df,self)==false then return false end end end)end,function()for df,aD in pairs(de)do if self.Each(au,df)==false then return false end end end)end,Update=function(dm)for df,aD in pairs(de)do local dn=df.GetPosition()local dp=df.GetRotation()for dg,dl in pairs(aD)do if dm or dg.IsMine then if not a.QuaternionApproximatelyEquals(dg.GetRotation(),dp)then dg.SetRotation(dp)end;if not a.VectorApproximatelyEquals(dg.GetPosition(),dn)then dg.SetPosition(dn)end;if dl.velocityReset then dg.SetVelocity(Vector3.zero)dg.SetAngularVelocity(Vector3.zero)end end end end end}return self end,CreateUpdateRoutine=function(dq,dr)return coroutine.wrap(function()local ds=TimeSpan.FromSeconds(30)local dt=vci.me.UnscaledTime;local du=dt;local bR=vci.me.Time;local dv=true;while true do local cm=a.InstanceID()if cm~=''then break end;local dw=vci.me.UnscaledTime;if dw-ds>dt then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;du=dw;bR=vci.me.Time;dv=false;coroutine.yield(100)end;if dv then du=vci.me.UnscaledTime;bR=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(dr,function(dx)dx()end)while true do local bV=vci.me.Time;local dy=bV-bR;local dw=vci.me.UnscaledTime;local dz=dw-du;dq(dy,dz)bR=bV;du=dw;coroutine.yield(100)end end)end,
CreateSlideSwitch=function(dA)local dB=a.NillableValue(dA.colliderItem)local dC=a.NillableValue(dA.baseItem)local dD=a.NillableValue(dA.knobItem)local dE=a.NillableValueOrDefault(dA.minValue,0)local dF=a.NillableValueOrDefault(dA.maxValue,10)if dE>=dF then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local dG=(dE+dF)*0.5;local dH=function(ag)local dI,dJ=a.PingPong(ag-dE,dF-dE)return dI+dE,dJ end;local q=dH(a.NillableValueOrDefault(dA.value,0))local dK=a.NillableIfHasValueOrElse(dA.tickFrequency,function(dL)if dL<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(dL,dF-dE)end,function()return(dF-dE)/10.0 end)local dM=a.NillableIfHasValueOrElse(dA.tickVector,function(bf)return Vector3.__new(bf.x,bf.y,bf.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local dN=dM.magnitude;if dN<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local dO=a.NillableValueOrDefault(dA.snapToTick,true)local dP=dA.valueTextName;local dQ=a.NillableValueOrDefault(dA.valueToText,tostring)local dR=TimeSpan.FromMilliseconds(1000)local dS=TimeSpan.FromMilliseconds(50)local dT,dU;local cL={}local self;local dV=false;local dW=0;local dX=false;local dY=TimeSpan.Zero;local dZ=TimeSpan.Zero;local d_=function(e0,e1)if e1 or e0~=q then local cM=q;q=e0;for cN,E in pairs(cL)do cN(self,q,cM)end end;dD.SetLocalPosition((e0-dG)/dK*dM)if dP then vci.assets.SetText(dP,dQ(e0,self))end end;local e2=function()local e3=dT()local e4,e5=dH(e3)local e6=e3+dK;local e7,e8=dH(e6)assert(e7)local e0;if e5==e8 or e4==dF or e4==dE then e0=e6 else e0=e5>=0 and dF or dE end;dZ=vci.me.UnscaledTime;if e0==dF or e0==dE then dY=dZ end;dU(e0)end;a.NillableIfHasValueOrElse(dA.lsp,function(e9)if not a.NillableHasValue(dA.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local ea=a.NillableValue(dA.propertyName)dT=function()return e9.GetProperty(ea,q)end;dU=function(ag)e9.SetProperty(ea,ag)end;e9.AddListener(function(aE,z,eb,ec)if z==ea then d_(dH(eb),true)end end)end,function()local eb=q;dT=function()return eb end;dU=function(ag)eb=ag;d_(dH(ag),true)end end)self={GetColliderItem=function()return dB end,GetBaseItem=function()return dC end,GetKnobItem=function()return dD end,GetMinValue=function()return dE end,GetMaxValue=function()return dF end,GetValue=function()return q end,GetScaleValue=function(ed,ee)assert(ed<=ee)return ed+(ee-ed)*(q-dE)/(dF-dE)end,SetValue=function(ag)dU(dH(ag))end,GetTickFrequency=function()return dK end,IsSnapToTick=function()return dO end,AddListener=function(cN)cL[cN]=cN end,RemoveListener=function(cN)cL[cN]=nil end,DoUse=function()if not dV then dX=true;dY=vci.me.UnscaledTime;e2()end end,DoUnuse=function()dX=false end,DoGrab=function()if not dX then dV=true;dW=(q-dG)/dK end end,DoUngrab=function()dV=false end,Update=function()if dV then local ef=dB.GetPosition()-dC.GetPosition()local eg=dD.GetRotation()*dM;local eh=Vector3.Project(ef,eg)local ei=(Vector3.Dot(eg,eh)>=0 and 1 or-1)*eh.magnitude/dN+dW;local ej=(dO and a.Round(ei)or ei)*dK+dG;local e0=a.Clamp(ej,dE,dF)if e0~=q then dU(e0)end elseif dX then local ek=vci.me.UnscaledTime;if ek>=dY+dR and ek>=dZ+dS then e2()end elseif dB.IsMine then a.AlignSubItemOrigin(dC,dB)end end}d_(dH(dT()),false)return self end,CreateSubItemConnector=function()local el=function(em,da,en)em.item=da;em.position=da.GetPosition()em.rotation=da.GetRotation()em.initialPosition=em.position;em.initialRotation=em.rotation;em.propagation=not not en;return em end;local eo=function(ep)for da,em in pairs(ep)do el(em,da,em.propagation)end end;local eq=function(er,bt,em,es,et)local ef=er-em.initialPosition;local eu=bt*Quaternion.Inverse(em.initialRotation)em.position=er;em.rotation=bt;for da,ev in pairs(es)do if da~=em.item and(not et or et(ev))then ev.position,ev.rotation=a.RotateAround(ev.initialPosition+ef,ev.initialRotation,er,eu)da.SetPosition(ev.position)da.SetRotation(ev.rotation)end end end;local ew={}local ex=true;local ey=false;local self;self={IsEnabled=function()return ex end,SetEnabled=function(aR)ex=aR;if aR then eo(ew)ey=false end end,Contains=function(ez)return a.NillableHasValue(ew[ez])end,Add=function(eA,eB)if not eA then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(eA),2)end;local eC=type(eA)=='table'and eA or{eA}eo(ew)ey=false;for N,da in pairs(eC)do ew[da]=el({},da,not eB)end end,Remove=function(ez)local b4=a.NillableHasValue(ew[ez])ew[ez]=nil;return b4 end,RemoveAll=function()ew={}return true end,Each=function(au)for da,em in pairs(ew)do if au(da,self)==false then return false end end end,GetItems=function()local eC={}for da,em in pairs(ew)do table.insert(eC,da)end;return eC end,Update=function()if not ex then return end;local eD=false;for da,em in pairs(ew)do local cq=da.GetPosition()local eE=da.GetRotation()if not a.VectorApproximatelyEquals(cq,em.position)or not a.QuaternionApproximatelyEquals(eE,em.rotation)then if em.propagation then if da.IsMine then eq(cq,eE,ew[da],ew,function(ev)if ev.item.IsMine then return true else ey=true;return false end end)eD=true;break else ey=true end else ey=true end end end;if not eD and ey then eo(ew)ey=false end end}return self end,GetSubItemTransform=function(ez)local er=ez.GetPosition()local bt=ez.GetRotation()local eF=ez.GetLocalScale()return{positionX=er.x,positionY=er.y,positionZ=er.z,rotationX=bt.x,rotationY=bt.y,rotationZ=bt.z,rotationW=bt.w,scaleX=eF.x,scaleY=eF.y,scaleZ=eF.z}end,RestoreCytanbTransform=function(eG)local cq=eG.positionX and eG.positionY and eG.positionZ and Vector3.__new(eG.positionX,eG.positionY,eG.positionZ)or nil;local eE=eG.rotationX and eG.rotationY and eG.rotationZ and eG.rotationW and Quaternion.__new(eG.rotationX,eG.rotationY,eG.rotationZ,eG.rotationW)or nil;local eF=eG.scaleX and eG.scaleY and eG.scaleZ and Vector3.__new(eG.scaleX,eG.scaleY,eG.scaleZ)or nil;return cq,eE,eF end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',MessageSenderOverride='__CYTANB_MESSAGE_SENDER_OVERRIDE',MessageOriginalSender='__CYTANB_MESSAGE_ORIGINAL_SENDER',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i,j=(function()local cE='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local cK=_G[cE]if not cK then cK={}_G[cE]=cK end;local eH=cK.randomSeedValue;if not eH then eH=os.time()-os.clock()*10000;cK.randomSeedValue=eH;math.randomseed(eH)end;local eI=cK.clientID;if type(eI)~='string'then eI=tostring(a.RandomUUID())cK.clientID=eI end;local eJ=vci.state.Get(b)or''if eJ==''and vci.assets.IsMine then eJ=tostring(a.RandomUUID())vci.state.Set(b,eJ)end;return eJ,eI end)()return a end)()

local settings = (function ()
    local cballSettingsLspid = 'ae00bdfc-98ec-4fbf-84a6-1a52823cfe69'
    local ignoreTag = 'cytanb-ignore'

    return {
        enableDebugging = false,
        lsp = cytanb.CreateLocalSharedProperties(cballSettingsLspid, tostring(cytanb.RandomUUID())),
        throwableTag = 'cytanb-throwable',
        ballTag = 'cytanb-ball',
        ignoreTag = ignoreTag,
        panelCount = 9,
        panelBaseName = 'nine-panel-base#' .. ignoreTag,
        panelControllerName = 'panel-controller',
        panelControllerOperatorLampName = 'panel-controller-operator-lamp',
        panelFrameOperatorLampName = 'panel-frame-operator-lamp',
        panelTiltName = 'frame-tilt',
        initialPanelTiltAngle = -90,
        panelPosPrefix = 'panel-pos#',
        panelMeshPrefix = 'panel-mesh#',
        panelColliderPrefix = 'panel-collider#cytanb-target=',
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
        resetOperationTime = TimeSpan.FromMilliseconds(1500),
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

local cballNS = 'com.github.oocytanb.oO-vci-pack.cball'
local hitMessageName = cballNS .. '.hit'

local vciLoaded = false

local hiddenPosition

local ignoredColliderMap
local panelBase, panelTilt, panelFrameOperatorLamp, panelMap
local panelController, panelControllerOperatorLamp, panelControllerGlue
local slideSwitchMap, audioVolumeSwitch, tiltSwitch
local resetSwitch

local breakEfkContainer, breakEfk

local panelBaseStatus = {
    --- フレームがつかまれているか。
    grabbed = false,

    --- フレームの傾きが変更されていることを示すフラグ。
    tiltChanged = false,

    --- オペレーターランプの状態。
    operatorLampOn = false,

    --- パネルの傾きを送った時間。
    tiltSentTime = TimeSpan.Zero,

    --- 最後にパネルを直した時間。
    lastMendedTime = TimeSpan.Zero,

    --- すべてのパネルがヒットしてゲームが終了した時間。
    gameCompletedTime = TimeSpan.Zero
}

local resetSwitchStatus = {
    --- クリック数。
    clickCount = 0,

    --- クリック時間。
    clickTime = TimeSpan.Zero,

    --- グリップされているか。
    gripPressed = false,

    --- リセットスイッチがグリップされた時間。
    gripStartTime = TimeSpan.MaxValue
}

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local IsContactWithTarget = function (sourcePosition, sourceLongSide, targetPosition, targetLongSide)
    -- `GetPosition()` が正確に衝突した位置を返すとは限らないので、ズレを考慮して幅を持たせる。
    return (sourcePosition - targetPosition).sqrMagnitude <= ((sourceLongSide + targetLongSide) * 0.75 ) ^ 2
end

local IsHitSource = function (name)
    if cytanb.NillableHasValue(ignoredColliderMap[name]) then
        return false
    end

    local tagMap = cytanb.ParseTagString(name)
    return not cytanb.NillableHasValue(tagMap[settings.ignoreTag]) and (
        not settings.limitHitSource or
        cytanb.NillableHasValue(tagMap[settings.throwableTag]) or
        cytanb.NillableHasValue(tagMap[settings.ballTag])
    )
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

local PanelCollided = function (panel)
    if not panel.item.IsMine then
        return false
    end

    if not BreakPanel(panel) then
        return false
    end

    cytanb.LogTrace('emit break-panel: ', panel.name)
    cytanb.EmitMessage(breakPanelMessageName, {
        senderID = cytanb.ClientID(),
        target = CreatePanelStatusParameter(panel)
    })
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
    panelBaseStatus.lastMendedTime = now

    if panelBase.IsMine and not alive and panelBaseStatus.gameCompletedTime <= TimeSpan.Zero then
        cytanb.LogTrace('Game Completed!!')
        panelBaseStatus.gameCompletedTime = now
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

    panelBaseStatus.lastMendedTime = vci.me.UnscaledTime
    panelBaseStatus.gameCompletedTime = TimeSpan.Zero
end

local EmitResetMessage = function (broadcast, reason)
    cytanb.EmitMessage(resetMessageName, {
        resetAll = true,
        broadcast = not not broadcast,
        senderID = cytanb.ClientID(),
        itemOperator = panelBase.IsMine,
        itemLayouter = vci.assets.IsMine,
        reason = reason or ''
    })
end

local UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
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
            if not panelBaseStatus.grabbed then
                -- 傾きの変更を、インターバルを設けてメッセージで通知する
                if panelBaseStatus.tiltChanged and now >= panelBaseStatus.tiltSentTime + settings.minRequestIntervalTime then
                    panelBaseStatus.tiltChanged = false
                    panelBaseStatus.tiltSentTime = now

                    if panelBase.IsMine then
                        cytanb.EmitMessage(changePanelBaseMessageName, {
                            senderID = cytanb.ClientID(),
                            panelBase = CreatePanelBaseStatusParameter()
                        })
                    end
                end

                -- パネルの位置関係を、インターバルを設けて直す
                if now >= panelBaseStatus.lastMendedTime + settings.panelMendIntervalTime then
                    MendAllPanels()
                end
            end

            if resetSwitchStatus.gripPressed and now - settings.resetOperationTime > resetSwitchStatus.gripStartTime then
                -- グリップ長押しでリセットする
                resetSwitchStatus.gripStartTime = TimeSpan.MaxValue
                EmitResetMessage(true, 'ButtonLongPressed')
            elseif panelBaseStatus.gameCompletedTime > TimeSpan.Zero and now >= panelBaseStatus.gameCompletedTime + settings.autoResetWaitingTime then
                -- 時間経過による自動リセット
                panelBaseStatus.gameCompletedTime = TimeSpan.Zero
                cytanb.LogTrace('AutoReset: emit resetAll')
                EmitResetMessage(false, 'AutoReset @OnUpdate')
            end
        end

        if panelBaseStatus.operatorLampOn ~= panelBase.IsMine then
            -- ランプの状態を変更する
            panelBaseStatus.operatorLampOn = not panelBaseStatus.operatorLampOn
            panelControllerOperatorLamp.SetLocalPosition(panelBaseStatus.operatorLampOn and Vector3.zero or hiddenPosition)
            panelFrameOperatorLamp.SetLocalPosition(panelBaseStatus.operatorLampOn and Vector3.zero or hiddenPosition)
        end
    end,

    function ()
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
        panelTilt = cytanb.NillableValue(vci.assets.GetTransform(settings.panelTiltName))

        panelMap = {}

        for i = 1, settings.panelCount do
            local name = settings.panelColliderPrefix .. i

            ignoredColliderMap[name] = true

            local panel = {
                index = i,
                name = name,
                item = cytanb.NillableValue(vci.assets.GetSubItem(name)),
                posItem = cytanb.NillableValue(vci.assets.GetTransform(settings.panelPosPrefix .. i)),
                meshItem = cytanb.NillableValue(vci.assets.GetTransform(settings.panelMeshPrefix .. i)),
                active = true,
                inactiveTime = TimeSpan.Zero,
            }

            panelMap[panel.name] = panel
        end

        panelController = cytanb.NillableValue(vci.assets.GetSubItem(settings.panelControllerName))
        panelControllerOperatorLamp = cytanb.NillableValue(vci.assets.GetTransform(settings.panelControllerOperatorLampName))
        panelFrameOperatorLamp = cytanb.NillableValue(vci.assets.GetTransform(settings.panelFrameOperatorLampName))
        panelControllerGlue = cytanb.CreateSubItemGlue()

        slideSwitchMap = {}

        audioVolumeSwitch = cytanb.CreateSlideSwitch({
            colliderItem = cytanb.NillableValue(vci.assets.GetSubItem(settings.audioVolumeSwitchName)),
            knobItem = cytanb.NillableValue(vci.assets.GetTransform(settings.audioVolumeKnobName)),
            baseItem = cytanb.NillableValue(vci.assets.GetTransform(settings.audioVolumeKnobPos)),
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
            knobItem = cytanb.NillableValue(vci.assets.GetTransform(settings.tiltKnobName)),
            baseItem = cytanb.NillableValue(vci.assets.GetTransform(settings.tiltKnobPos)),
            tickVector = settings.tickVector,
            minValue = settings.tiltMinValue,
            maxValue = settings.tiltMaxValue
        })
        tiltSwitch.AddListener(function (source, value)
            cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
            SetPanelBaseTilt(value)
            panelBaseStatus.tiltChanged = true
        end)
        slideSwitchMap[settings.tiltSwitchName] = tiltSwitch

        resetSwitch = cytanb.NillableValue(vci.assets.GetSubItem(settings.resetSwitchName))
        panelControllerGlue.Add(cytanb.NillableValue(vci.assets.GetTransform(settings.resetSwitchMesh)), resetSwitch)

        breakEfkContainer = cytanb.NillableValue(vci.assets.GetTransform(settings.breakEfkContainerName))
        breakEfk = cytanb.NillableValue(vci.assets.GetEffekseerEmitter(settings.breakEfkContainerName))

        settings.lsp.AddListener(function (source, key, value, oldValue)
            if key == cytanb.LOCAL_SHARED_PROPERTY_EXPIRED_KEY then
                -- cytanb.LogTrace('lsp: expired')
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

        cytanb.OnMessage(resetMessageName, function (sender, name, parameterMap)
            -- ブロードキャストか、自己のインスタンスから送られた、リセットメッセージを処理する
            if parameterMap.resetAll and (parameterMap.broadcast or parameterMap[cytanb.InstanceIDParameterName] == cytanb.InstanceID()) then
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
                            -- 通知された状態と異なれば、変更を行う
                            panel.active = panelParameters.active
                            ShowPanelMesh(panel, panel.active)
                        end
                    end)
                end
            end
        end)

        -- ターゲットにヒットしたメッセージが、別 VCI から送られてくる。
        cytanb.OnMessage(hitMessageName, function (sender, name, parameterMap)
            cytanb.NillableIfHasValue(parameterMap.source, function (source)
                if not source.position then
                    return
                end

                cytanb.NillableIfHasValue(parameterMap.target, function (targetParameters)
                    cytanb.NillableIfHasValue(panelMap[targetParameters.name], function (panel)
                        if not panel.item.IsMine then
                            return
                        end

                        if IsContactWithTarget(source.position, source.longSide or 0.5, panel.item.GetPosition(), settings.panelSimLongSide) then
                            if PanelCollided(panel) then
                                cytanb.LogTrace('    @on hit message: source = ', source.name or '[unknown]')
                            end
                        end
                    end)
                end)
            end)
        end)

        ResetAll()
        SetPanelBaseTilt(tiltSwitch.GetValue())

        -- 現在のステータスを問い合わせる。
        -- 設置者よりも、ゲストのロードが早いケースを考慮して、全ユーザーがクエリーメッセージを送る。
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

    if target == panelBase.GetName() then
        panelBaseStatus.grabbed = true
    elseif target == resetSwitch.GetName() then
        resetSwitchStatus.clickCount, resetSwitchStatus.clickTime = cytanb.DetectClicks(resetSwitchStatus.clickCount, resetSwitchStatus.clickTime, settings.grabClickTiming)
        if resetSwitchStatus.clickCount == 2 then
            -- リセットスイッチを 2 回グラブする操作で、リセットを行う。
            -- (ユーザーは、スライドスイッチをグラブすると操作できるので、同じ入力キーで操作できるものと期待するため)
            EmitResetMessage(false, 'GrabButtonTwoTimes')
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
        panelBaseStatus.grabbed = false
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

    if use == resetSwitch.GetName() then
        resetSwitchStatus.gripPressed = true
        resetSwitchStatus.gripStartTime = vci.me.UnscaledTime
    elseif use == panelBase.GetName() then
        EmitResetMessage(false, 'UsePanelFrame')
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

    if use == resetSwitch.GetName() then
        if resetSwitchStatus.gripPressed and resetSwitchStatus.gripStartTime ~= TimeSpan.MaxValue then
            -- 長押しされなかった場合は、自己のインスタンスのみリセットする
            EmitResetMessage(false, 'UseButton @onUnuse')
        end
        resetSwitchStatus.gripPressed = false
        resetSwitchStatus.gripStartTime = TimeSpan.MaxValue
    else
        cytanb.NillableIfHasValue(slideSwitchMap[use], function (switch)
            switch.DoUnuse()
        end)
    end
end

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    if panelBase.IsMine and not panelBaseStatus.grabbed and IsHitSource(hit) then
        cytanb.NillableIfHasValue(panelMap[item], function (panel)
            panelBaseStatus.lastMendedTime = vci.me.UnscaledTime
            if PanelCollided(panel) then
                cytanb.LogTrace('    @onTriggerEnter: panel = ', item, ', hit = ', hit)
            end
        end)
    end
end
