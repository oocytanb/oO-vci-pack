-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g;local h;local i;local j;local k;local l;local m=false;local n;local o;local p;local a;local q=function(r,s)local t=r+s-1;return r,t,t+1 end;local u=function(r,s)local t=r-s+1;return t,r,t-1 end;local v=function(w,x,y,r,z)local A=y.searchMap;for B,s in pairs(y.lengthList)do if s<=0 then error('SearchPattern: Invalid parameter: searchLen <= 0')else local C,D,t=z(r,s)if C>=1 and D<=x then local E=string.sub(w,C,D)if A[E]then return true,s,t end end end end;return false,-1,-1 end;local F=function(w,y,r,z)if w==nil or y==nil then return false,-1 end;if y.hasEmptySearch then return true,0 end;local x=string.len(w)local G=y.repeatMin;local H=y.repeatMax;local I=H<0;local J=r;local K=0;local L=0;while I or L<H do local M,N,t=v(w,x,y,J,z)if M then if N<=0 then error('SearchPattern: Invalid parameter')end;J=t;K=K+N;L=L+1 else break end end;if L>=G then return true,K else return false,-1 end end;local O=function(w,P,r,Q,z,R)if w==nil or P==nil then return false,-1 end;local s=string.len(P)if Q then local M=R(w,P)return M,M and s or-1 else if s==0 then return true,s end;local x=string.len(w)local C,D=z(r,s)if C>=1 and D<=x then local E=string.sub(w,C,D)local M=R(E,P)return M,M and s or-1 else return false,-1 end end end;local S=function(w,T,U)if T<=U then local V=string.unicode(w,T,T)if V>=0xDC00 or V<=0xDFFF then return true,1,V end end;return false,-1,nil end;local W=function(w,T,U,X)if T<=U then local Y,Z=a.StringStartsWith(w,d,T)if Y then local _=T+Z;if _<=U then local a0,a1=a.StringStartsWith(w,e,_)if a0 then local a2=_+a1;if a2<=U and string.unicode(w,a2,a2)==0x3E then local a3=tonumber(string.sub(w,_,_+a1-1))if a3<=X then return true,a2-T+1,a3 end end end end end end;return false,-1,nil end;local a4=function(a5,a6)for a7=1,4 do local a8=a5[a7]-a6[a7]if a8~=0 then return a8 end end;return 0 end;local a9;a9={__eq=function(a5,a6)return a5[1]==a6[1]and a5[2]==a6[2]and a5[3]==a6[3]and a5[4]==a6[4]end,__lt=function(a5,a6)return a4(a5,a6)<0 end,__le=function(a5,a6)return a4(a5,a6)<=0 end,__tostring=function(aa)local ab=aa[2]or 0;local ac=aa[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(aa[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(ab,16),0xFFFF),bit32.band(ab,0xFFFF),bit32.band(bit32.rshift(ac,16),0xFFFF),bit32.band(ac,0xFFFF),bit32.band(aa[4]or 0,0xFFFFFFFF))end,__concat=function(a5,a6)local ad=getmetatable(a5)local ae=ad==a9 or type(ad)=='table'and ad.__concat==a9.__concat;local af=getmetatable(a6)local ag=af==a9 or type(af)=='table'and af.__concat==a9.__concat;if not ae and not ag then error('UUID: attempt to concatenate illegal values',2)end;return(ae and a9.__tostring(a5)or a5)..(ag and a9.__tostring(a6)or a6)end}local ah='__CYTANB_CONST_VARIABLES'local ai=function(table,aj)local ak=getmetatable(table)if ak then local al=rawget(ak,ah)if al then local am=rawget(al,aj)if type(am)=='function'then return am(table,aj)else return am end end end;return nil end;local an=function(table,aj,ao)local ak=getmetatable(table)if ak then local al=rawget(ak,ah)if al then if rawget(al,aj)~=nil then error('Cannot assign to read only field "'..aj..'"',2)end end end;rawset(table,aj,ao)end;local ap=function(aq,ar)local as=aq[a.TypeParameterName]if a.NillableHasValue(as)and a.NillableValue(as)~=ar then return false,false end;return a.NillableIfHasValueOrElse(j[ar],function(at)local au=at.compositionFieldNames;local av=at.compositionFieldLength;local aw=false;for ax,ao in pairs(aq)do if au[ax]then av=av-1;if av<=0 and aw then break end elseif ax~=a.TypeParameterName then aw=true;if av<=0 then break end end end;return av<=0,aw end,function()return false,false end)end;local ay=function(w)return a.StringReplace(a.StringReplace(w,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local az=function(w,aA)local aB=string.len(w)local aC=string.len(a.EscapeSequenceTag)if aC>aB then return w end;local aD=''local a7=1;while a7<aB do local D,aE=string.find(w,a.EscapeSequenceTag,a7,true)if not D then if a7==1 then aD=w else aD=aD..string.sub(w,a7)end;break end;if D>a7 then aD=aD..string.sub(w,a7,D-1)end;local aF=false;for aG,aH in ipairs(i)do local M=a.StringStartsWith(w,aH.search,D)if M then aD=aD..(aA and aA(aH.tag)or aH.replacement)a7=D+string.len(aH.search)aF=true;break end end;if not aF then aD=aD..a.EscapeSequenceTag;a7=aE+1 end end;return aD end;local aI;aI=function(aJ,aK)if type(aJ)~='table'then return aJ end;if not aK then aK={}end;if aK[aJ]then error('circular reference')end;aK[aJ]=true;local aL={}for ax,ao in pairs(aJ)do local aM=type(ax)local aN;if aM=='string'then aN=ay(ax)elseif aM=='number'then aN=tostring(ax)..a.ArrayNumberTag else aN=ax end;local aO=type(ao)if aO=='string'then aL[aN]=ay(ao)elseif aO=='number'and ao<0 then aL[tostring(aN)..a.NegativeNumberTag]=tostring(ao)else aL[aN]=aI(ao,aK)end end;aK[aJ]=nil;return aL end;local aP;aP=function(aL,aQ)if type(aL)~='table'then return aL end;local aJ={}for ax,ao in pairs(aL)do local aN;local aR=false;if type(ax)=='string'then local aS=false;aN=az(ax,function(aT)if aT==a.NegativeNumberTag then aR=true elseif aT==a.ArrayNumberTag then aS=true end;return nil end)if aS then aN=tonumber(aN)or aN end else aN=ax;aR=false end;if aR and type(ao)=='string'then aJ[aN]=tonumber(ao)elseif type(ao)=='string'then aJ[aN]=az(ao,function(aT)return k[aT]end)else aJ[aN]=aP(ao,aQ)end end;if not aQ then a.NillableIfHasValue(aJ[a.TypeParameterName],function(aU)a.NillableIfHasValue(j[aU],function(at)local aV,aw=at.fromTableFunc(aJ)if not aw then a.NillableIfHasValue(aV,function(aa)aJ=aa end)end end)end)end;return aJ end;local aW={['nil']=function(aX)return nil end,['number']=function(aX)return tonumber(aX)end,['string']=function(aX)return tostring(aX)end,['boolean']=function(aX)if aX then return true else return false end end}local aY=function(aX,aZ)local a_=type(aX)if a_==aZ then return aX else local b0=aW[aZ]if b0 then return b0(aX)else return nil end end end;local b1=function(b2,b3)if b3 and type(b3)=='table'then local b4={}for aj,aX in pairs(b2)do local b5=b3[aj]local b6;if b5==nil then b6=aX else local b7=aY(b5,type(aX))if b7==nil then b6=aX else b6=b7 end end;b4[aj]=b6 end;b4[a.MessageOriginalSender]=b2;return b4 else return b2 end end;local b8=function(b9,ba,b3,bb)local bc={type=bb,name='',commentSource=''}local bd={[a.MessageValueParameterName]=tostring(ba),[a.MessageSenderOverride]=type(b3)=='table'and a.Extend(bc,b3,true)or bc}a.EmitMessage(b9,bd)end;local be=function(b9,bf,bg)local bh,bi=(function()local b0=function(b2,bj,bd)local ba=tostring(bd[a.MessageValueParameterName]or'')bg(b2,bf,ba)end;local bh=a.OnMessage(b9,b0)local bi=a.OnMessage(bf,b0)return bh,bi end)()return{Off=function()bh.Off()bi.Off()end}end;a={InstanceID=function()if o==''then o=vci.state.Get(b)or''end;return o end,NillableHasValue=function(bk)return bk~=nil end,NillableValue=function(bk)if bk==nil then error('nillable: value is nil',2)end;return bk end,NillableValueOrDefault=function(bk,bl)if bk==nil then if bl==nil then error('nillable: defaultValue is nil',2)end;return bl else return bk end end,NillableIfHasValue=function(bk,bg)if bk==nil then return nil else return bg(bk)end end,NillableIfHasValueOrElse=function(bk,bg,bm)if bk==nil then return bm()else return bg(bk)end end,MakeSearchPattern=function(bn,bo,bp)local G=bo and math.floor(bo)or 1;if G<0 then error('SearchPattern: Invalid parameter: optRepeatMin < 0')end;local H=bp and math.floor(bp)or G;if H>=0 and H<G then error('SearchPattern: Invalid parameter: repeatMax < repeatMin')end;local bq=H==0;local A={}local br={}local bs={}local bt=0;for bu,bv in pairs(bn)do local s=string.len(bv)if s==0 then bq=true else A[bv]=s;if not br[s]then br[s]=true;bt=bt+1;bs[bt]=s end end end;table.sort(bs,function(bw,M)return bw>M end)return{hasEmptySearch=bq,searchMap=A,lengthList=bs,repeatMin=G,repeatMax=H}end,StringStartsWith=function(w,P,bx)local J=bx and math.max(1,math.floor(bx))or 1;if type(P)=='table'then return F(w,P,J,q)else return O(w,P,J,J==1,q,string.startsWith)end end,StringEndsWith=function(w,P,by)if w==nil then return false,-1 end;local x=string.len(w)local J=by and math.min(x,math.floor(by))or x;if type(P)=='table'then return F(w,P,J,u)else return O(w,P,J,J==x,u,string.endsWith)end end,StringTrimStart=function(w,bz)if w==nil or w==''then return w end;local M,N=a.StringStartsWith(w,bz or c)if M and N>=1 then return string.sub(w,N+1)else return w end end,StringTrimEnd=function(w,bz)if w==nil or w==''then return w end;local M,N=a.StringEndsWith(w,bz or c)if M and N>=1 then return string.sub(w,1,string.len(w)-N)else return w end end,StringTrim=function(w,bz)return a.StringTrimEnd(a.StringTrimStart(w,bz),bz)end,StringReplace=function(w,bA,bB)local bC;local aB=string.len(w)if bA==''then bC=bB;for a7=1,aB do bC=bC..string.sub(w,a7,a7)..bB end else bC=''local a7=1;while true do local C,D=string.find(w,bA,a7,true)if C then bC=bC..string.sub(w,a7,C-1)..bB;a7=D+1;if a7>aB then break end else bC=a7==1 and w or bC..string.sub(w,a7)break end end end;return bC end,
StringEachCode=function(w,bg,bD,a7,bE,bF,bG,bH)local aB=string.len(w)if aB==0 then return 0,0,0 end;local bI=a7 and math.floor(a7)or 1;local U=bE and math.floor(bE)or aB;local X=math.min(bH or 3182,0x1FFFFF)if bI<=0 or U>aB or bI>U then error('StringEachCode: invalid range')end;local bJ=0;local bK=bI;local bL=bK;while bK<=U do local C=bK;local V=string.unicode(w,bK,bK)if V>=0xD800 and V<=0xDBFF then local M,N=S(w,bK+1,U)if M then bK=bK+N end elseif bF and V==0x3C then local M,N,a3=W(w,bK+1,U,X)if M and(not bG or bG(a3))then bK=bK+N end end;bJ=bJ+1;bL=bK;if bg and bg(string.sub(w,C,bK),bJ,bD,C,bK)==false then break end;bK=bK+1 end;return bJ,bI,bL end,SetConst=function(bA,b9,aa)if type(bA)~='table'then error('Cannot set const to non-table target',2)end;local bM=getmetatable(bA)local ak=bM or{}local bN=rawget(ak,ah)if rawget(bA,b9)~=nil then error('Non-const field "'..b9 ..'" already exists',2)end;if not bN then bN={}rawset(ak,ah,bN)ak.__index=ai;ak.__newindex=an end;rawset(bN,b9,aa)if not bM then setmetatable(bA,ak)end;return bA end,SetConstEach=function(bA,bO)for ax,ao in pairs(bO)do a.SetConst(bA,ax,ao)end;return bA end,Extend=function(bA,bP,bQ,bR,aK)if bA==bP or type(bA)~='table'or type(bP)~='table'then return bA end;if bQ then if not aK then aK={}end;if aK[bP]then error('circular reference')end;aK[bP]=true end;for ax,ao in pairs(bP)do if bQ and type(ao)=='table'then local bS=bA[ax]bA[ax]=a.Extend(type(bS)=='table'and bS or{},ao,bQ,bR,aK)else bA[ax]=ao end end;if not bR then local bT=getmetatable(bP)if type(bT)=='table'then if bQ then local bU=getmetatable(bA)setmetatable(bA,a.Extend(type(bU)=='table'and bU or{},bT,true))else setmetatable(bA,bT)end end end;if bQ then aK[bP]=nil end;return bA end,Vars=function(ao,bV,bW,aK)local bX;if bV then bX=bV~='__NOLF'else bV='  'bX=true end;if not bW then bW=''end;if not aK then aK={}end;local bY=type(ao)if bY=='table'then aK[ao]=aK[ao]and aK[ao]+1 or 1;local bZ=bX and bW..bV or''local w='('..tostring(ao)..') {'local b_=true;for aj,aX in pairs(ao)do if b_ then b_=false else w=w..(bX and','or', ')end;if bX then w=w..'\n'..bZ end;if type(aX)=='table'and aK[aX]and aK[aX]>0 then w=w..aj..' = ('..tostring(aX)..')'else w=w..aj..' = '..a.Vars(aX,bV,bZ,aK)end end;if not b_ and bX then w=w..'\n'..bW end;w=w..'}'aK[ao]=aK[ao]-1;if aK[ao]<=0 then aK[ao]=nil end;return w elseif bY=='function'or bY=='thread'or bY=='userdata'then return'('..bY..')'elseif bY=='string'then return'('..bY..') '..string.format('%q',ao)else return'('..bY..') '..tostring(ao)end end,GetLogLevel=function()return l end,SetLogLevel=function(c0)l=c0 end,IsOutputLogLevelEnabled=function()return m end,SetOutputLogLevelEnabled=function(c1)m=not not c1 end,Log=function(c0,...)if c0<=l then local c2=m and(n[c0]or'LOG LEVEL '..tostring(c0))..' | 'or''local c3=table.pack(...)if c3.n==1 then local ao=c3[1]if ao~=nil then local w=type(ao)=='table'and a.Vars(ao)or tostring(ao)print(m and c2 ..w or w)else print(c2)end else local w=c2;for a7=1,c3.n do local ao=c3[a7]if ao~=nil then w=w..(type(ao)=='table'and a.Vars(ao)or tostring(ao))end end;print(w)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(c4,c5)local c6={}if c5==nil then for ax,ao in pairs(c4)do c6[ao]=ao end elseif type(c5)=='function'then for ax,ao in pairs(c4)do local c7,c8=c5(ao)c6[c7]=c8 end else for ax,ao in pairs(c4)do c6[ao]=c5 end end;return c6 end,Round=function(c9,ca)if ca then local cb=10^ca;return math.floor(c9*cb+0.5)/cb else return math.floor(c9+0.5)end end,Clamp=function(aa,cc,cd)return math.max(cc,math.min(aa,cd))end,Lerp=function(bw,M,bY)if bY<=0.0 then return bw elseif bY>=1.0 then return M else return bw+(M-bw)*bY end end,LerpUnclamped=function(bw,M,bY)if bY==0.0 then return bw elseif bY==1.0 then return M else return bw+(M-bw)*bY end end,PingPong=function(bY,ce)if ce==0 then return 0,1 end;local cf=math.floor(bY/ce)local cg=bY-cf*ce;if cf<0 then if(cf+1)%2==0 then return ce-cg,-1 else return cg,1 end else if cf%2==0 then return cg,1 else return ce-cg,-1 end end end,VectorApproximatelyEquals=function(ch,ci)return(ch-ci).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(ch,ci)local cj=Quaternion.Dot(ch,ci)return cj<1.0+1E-06 and cj>1.0-1E-06 end,QuaternionToAngleAxis=function(ck)local cf=ck.normalized;local cl=math.acos(cf.w)local cm=math.sin(cl)local cn=math.deg(cl*2.0)local co;if math.abs(cm)<=Quaternion.kEpsilon then co=Vector3.right else local C=1.0/cm;co=Vector3.__new(cf.x*C,cf.y*C,cf.z*C)end;return cn,co end,QuaternionTwist=function(ck,cp)if cp.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local cq=Vector3.__new(ck.x,ck.y,ck.z)if cq.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local cr=Vector3.Project(cq,cp)if cr.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local cs=Quaternion.__new(cr.x,cr.y,cr.z,ck.w)cs.Normalize()return cs else return Quaternion.AngleAxis(0,cp)end else local ct=a.QuaternionToAngleAxis(ck)return Quaternion.AngleAxis(ct,cp)end end,ApplyQuaternionToVector3=function(ck,cu)local cv=ck.w*cu.x+ck.y*cu.z-ck.z*cu.y;local cw=ck.w*cu.y-ck.x*cu.z+ck.z*cu.x;local cx=ck.w*cu.z+ck.x*cu.y-ck.y*cu.x;local cy=-ck.x*cu.x-ck.y*cu.y-ck.z*cu.z;return Vector3.__new(cy*-ck.x+cv*ck.w+cw*-ck.z-cx*-ck.y,cy*-ck.y-cv*-ck.z+cw*ck.w+cx*-ck.x,cy*-ck.z+cv*-ck.y-cw*-ck.x+cx*ck.w)end,RotateAround=function(cz,cA,cB,cC)return cB+cC*(cz-cB),cC*cA end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(cD)return a9.__tostring(cD)end,UUIDFromNumbers=function(...)local cE=...local bY=type(cE)local cF,cG,cH,cI;if bY=='table'then cF=cE[1]cG=cE[2]cH=cE[3]cI=cE[4]else cF,cG,cH,cI=...end;local cD={bit32.band(cF or 0,0xFFFFFFFF),bit32.band(cG or 0,0xFFFFFFFF),bit32.band(cH or 0,0xFFFFFFFF),bit32.band(cI or 0,0xFFFFFFFF)}setmetatable(cD,a9)return cD end,UUIDFromString=function(w)local aB=string.len(w)if aB==32 then local cD=a.UUIDFromNumbers(0,0,0,0)for a7=1,4 do local C=1+(a7-1)*8;if not a.StringStartsWith(w,g,C)then return nil end;cD[a7]=tonumber(string.sub(w,C,C+7),16)end;return cD elseif aB==36 then if not a.StringStartsWith(w,g,1)then return nil end;local cF=tonumber(string.sub(w,1,8),16)if not a.StringStartsWith(w,'-',9)or not a.StringStartsWith(w,f,10)or not a.StringStartsWith(w,'-',14)or not a.StringStartsWith(w,f,15)then return nil end;local cG=tonumber(string.sub(w,10,13)..string.sub(w,15,18),16)if not a.StringStartsWith(w,'-',19)or not a.StringStartsWith(w,f,20)or not a.StringStartsWith(w,'-',24)or not a.StringStartsWith(w,f,25)then return nil end;local cH=tonumber(string.sub(w,20,23)..string.sub(w,25,28),16)if not a.StringStartsWith(w,g,29)then return nil end;local cI=tonumber(string.sub(w,29),16)return a.UUIDFromNumbers(cF,cG,cH,cI)else return nil end end,ParseUUID=function(w)return a.UUIDFromString(w)end,CreateCircularQueue=function(cJ)if type(cJ)~='number'or cJ<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(cJ),2)end;local self;local cK=math.floor(cJ)local aD={}local cL=0;local cM=0;local cN=0;self={Size=function()return cN end,Clear=function()cL=0;cM=0;cN=0 end,IsEmpty=function()return cN==0 end,Offer=function(cO)aD[cL+1]=cO;cL=(cL+1)%cK;if cN<cK then cN=cN+1 else cM=(cM+1)%cK end;return true end,OfferFirst=function(cO)cM=(cK+cM-1)%cK;aD[cM+1]=cO;if cN<cK then cN=cN+1 else cL=(cK+cL-1)%cK end;return true end,Poll=function()if cN==0 then return nil else local cO=aD[cM+1]cM=(cM+1)%cK;cN=cN-1;return cO end end,PollLast=function()if cN==0 then return nil else cL=(cK+cL-1)%cK;local cO=aD[cL+1]cN=cN-1;return cO end end,Peek=function()if cN==0 then return nil else return aD[cM+1]end end,PeekLast=function()if cN==0 then return nil else return aD[(cK+cL-1)%cK+1]end end,Get=function(cP)if cP<1 or cP>cN then a.LogError('CreateCircularQueue.Get: index is outside the range: '..cP)return nil end;return aD[(cM+cP-1)%cK+1]end,IsFull=function()return cN>=cK end,MaxSize=function()return cK end}return self end,DetectClicks=function(cQ,cR,cS)local bJ=cQ or 0;local cT=cS or TimeSpan.FromMilliseconds(500)local cU=vci.me.Time;local cV=cR and cU>cR+cT and 1 or bJ+1;return cV,cU end,ColorRGBToHSV=function(cW)local cg=math.max(0.0,math.min(cW.r,1.0))local cX=math.max(0.0,math.min(cW.g,1.0))local M=math.max(0.0,math.min(cW.b,1.0))local cd=math.max(cg,cX,M)local cc=math.min(cg,cX,M)local cY=cd-cc;local am;if cY==0.0 then am=0.0 elseif cd==cg then am=(cX-M)/cY/6.0 elseif cd==cX then am=(2.0+(M-cg)/cY)/6.0 else am=(4.0+(cg-cX)/cY)/6.0 end;if am<0.0 then am=am+1.0 end;local cZ=cd==0.0 and cY or cY/cd;local ao=cd;return am,cZ,ao end,ColorFromARGB32=function(c_)local d0=type(c_)=='number'and c_ or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(d0,16),0xFF)/0xFF,bit32.band(bit32.rshift(d0,8),0xFF)/0xFF,bit32.band(d0,0xFF)/0xFF,bit32.band(bit32.rshift(d0,24),0xFF)/0xFF)end,ColorToARGB32=function(cW)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*cW.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*cW.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*cW.g),0xFF),8),bit32.band(a.Round(0xFF*cW.b),0xFF))end,
ColorFromIndex=function(d1,d2,d3,d4,d5)local d6=math.max(math.floor(d2 or a.ColorHueSamples),1)local d7=d5 and d6 or d6-1;local d8=math.max(math.floor(d3 or a.ColorSaturationSamples),1)local d9=math.max(math.floor(d4 or a.ColorBrightnessSamples),1)local cP=a.Clamp(math.floor(d1 or 0),0,d6*d8*d9-1)local da=cP%d6;local db=math.floor(cP/d6)local C=db%d8;local dc=math.floor(db/d8)if d5 or da~=d7 then local am=da/d7;local cZ=(d8-C)/d8;local ao=(d9-dc)/d9;return Color.HSVToRGB(am,cZ,ao)else local ao=(d9-dc)/d9*C/(d8-1)return Color.HSVToRGB(0.0,0.0,ao)end end,ColorToIndex=function(cW,d2,d3,d4,d5)local d6=math.max(math.floor(d2 or a.ColorHueSamples),1)local d7=d5 and d6 or d6-1;local d8=math.max(math.floor(d3 or a.ColorSaturationSamples),1)local d9=math.max(math.floor(d4 or a.ColorBrightnessSamples),1)local am,cZ,ao=a.ColorRGBToHSV(cW)local C=a.Round(d8*(1.0-cZ))if d5 or C<d8 then local dd=a.Round(d7*am)if dd>=d7 then dd=0 end;if C>=d8 then C=d8-1 end;local dc=math.min(d9-1,a.Round(d9*(1.0-ao)))return dd+d6*(C+d8*dc)else local de=a.Round((d8-1)*ao)if de==0 then local df=a.Round(d9*(1.0-ao))if df>=d9 then return d6-1 else return d6*(1+a.Round(ao*(d8-1)/(d9-df)*d9)+d8*df)-1 end else return d6*(1+de+d8*a.Round(d9*(1.0-ao*(d8-1)/de)))-1 end end end,ColorToTable=function(cW)return{[a.TypeParameterName]=a.ColorTypeName,r=cW.r,g=cW.g,b=cW.b,a=cW.a}end,ColorFromTable=function(aq)local M,aw=ap(aq,a.ColorTypeName)return M and Color.__new(aq.r,aq.g,aq.b,aq.a)or nil,aw end,Vector2ToTable=function(aa)return{[a.TypeParameterName]=a.Vector2TypeName,x=aa.x,y=aa.y}end,Vector2FromTable=function(aq)local M,aw=ap(aq,a.Vector2TypeName)return M and Vector2.__new(aq.x,aq.y)or nil,aw end,Vector3ToTable=function(aa)return{[a.TypeParameterName]=a.Vector3TypeName,x=aa.x,y=aa.y,z=aa.z}end,Vector3FromTable=function(aq)local M,aw=ap(aq,a.Vector3TypeName)return M and Vector3.__new(aq.x,aq.y,aq.z)or nil,aw end,Vector4ToTable=function(aa)return{[a.TypeParameterName]=a.Vector4TypeName,x=aa.x,y=aa.y,z=aa.z,w=aa.w}end,Vector4FromTable=function(aq)local M,aw=ap(aq,a.Vector4TypeName)return M and Vector4.__new(aq.x,aq.y,aq.z,aq.w)or nil,aw end,QuaternionToTable=function(aa)return{[a.TypeParameterName]=a.QuaternionTypeName,x=aa.x,y=aa.y,z=aa.z,w=aa.w}end,QuaternionFromTable=function(aq)local M,aw=ap(aq,a.QuaternionTypeName)return M and Quaternion.__new(aq.x,aq.y,aq.z,aq.w)or nil,aw end,TableToSerializable=function(aJ)return aI(aJ)end,TableFromSerializable=function(aL,aQ)return aP(aL,aQ)end,TableToSerialiable=function(aJ)return aI(aJ)end,TableFromSerialiable=function(aL,aQ)return aP(aL,aQ)end,EmitMessage=function(b9,bd)local aL=a.NillableIfHasValueOrElse(bd,function(aJ)if type(aJ)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(aJ)end,function()return{}end)aL[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(b9,json.serialize(aL))end,OnMessage=function(b9,bg)local b0=function(b2,bj,ba)if type(ba)=='string'and string.startsWith(ba,'{')then local dg,aL=pcall(json.parse,ba)if dg and type(aL)=='table'and aL[a.InstanceIDParameterName]then local dh=a.TableFromSerializable(aL)bg(b1(b2,dh[a.MessageSenderOverride]),bj,dh)return end end;bg(b2,bj,{[a.MessageValueParameterName]=ba})end;vci.message.On(b9,b0)return{Off=function()if b0 then b0=nil end end}end,OnInstanceMessage=function(b9,bg)local b0=function(b2,bj,bd)local di=a.InstanceID()if di~=''and di==bd[a.InstanceIDParameterName]then bg(b2,bj,bd)end end;return a.OnMessage(b9,b0)end,EmitCommentMessage=function(ba,b3)b8(a.DedicatedCommentMessageName,ba,b3,'comment')end,OnCommentMessage=function(bg)return be(a.DedicatedCommentMessageName,'comment',bg)end,EmitNotificationMessage=function(ba,b3)b8(a.DedicatedNotificationMessageName,ba,b3,'notification')end,OnNotificationMessage=function(bg)return be(a.DedicatedNotificationMessageName,'notification',bg)end,GetEffekseerEmitterMap=function(b9)local dj=vci.assets.GetEffekseerEmitters(b9)if not dj then return nil end;local c6={}for a7,dk in pairs(dj)do c6[dk.EffectName]=dk end;return c6 end,ClientID=function()return p end,ParseTagString=function(w)local bK=string.find(w,'#',1,true)if not bK then return{},w end;local dl={}local dm=string.sub(w,1,bK-1)bK=bK+1;local aB=string.len(w)while bK<=aB do local dn,dp=a.StringStartsWith(w,h,bK)if dn then local dq=bK+dp;local dr=string.sub(w,bK,dq-1)local ds=dr;bK=dq;if bK<=aB and a.StringStartsWith(w,'=',bK)then bK=bK+1;local dt,du=a.StringStartsWith(w,h,bK)if dt then local dv=bK+du;ds=string.sub(w,bK,dv-1)bK=dv else ds=''end end;dl[dr]=ds end;bK=string.find(w,'#',bK,true)if not bK then break end;bK=bK+1 end;return dl,dm end,CalculateSIPrefix=(function()local dw=9;local dx={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local dy=#dx;return function(c9)local dz=c9==0 and 0 or a.Clamp(math.floor(math.log(math.abs(c9),1000)),1-dw,dy-dw)return dz==0 and c9 or c9/1000^dz,dx[dw+dz],dz*3 end end)(),CreateLocalSharedProperties=function(dA,dB)local dC=TimeSpan.FromSeconds(5)local dD='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local dE='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(dA)~='string'or string.len(dA)<=0 or type(dB)~='string'or string.len(dB)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local dF=_G[dD]if not dF then dF={}_G[dD]=dF end;dF[dB]=vci.me.UnscaledTime;local dG=_G[dA]if not dG then dG={[dE]={}}_G[dA]=dG end;local dH=dG[dE]local self;self={GetLspID=function()return dA end,GetLoadID=function()return dB end,GetProperty=function(aj,bl)local aa=dG[aj]if aa==nil then return bl else return aa end end,SetProperty=function(aj,aa)if aj==dE then error('LocalSharedProperties: Invalid argument: key = ',aj,2)end;local cU=vci.me.UnscaledTime;local dI=dG[aj]dG[aj]=aa;for dJ,di in pairs(dH)do local bY=dF[di]if bY and bY+dC>=cU then dJ(self,aj,aa,dI)else dJ(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)dH[dJ]=nil;dF[di]=nil end end end,Clear=function()for aj,aa in pairs(dG)do if aj~=dE then self.SetProperty(aj,nil)end end end,Each=function(bg)for aj,aa in pairs(dG)do if aj~=dE and bg(aa,aj,self)==false then return false end end end,AddListener=function(dJ)dH[dJ]=dB end,RemoveListener=function(dJ)dH[dJ]=nil end,UpdateAlive=function()dF[dB]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(dK)local dL=1.0;local dM=1000.0;local dN=TimeSpan.FromSeconds(0.02)local dO=0xFFFF;local dP=a.CreateCircularQueue(64)local dQ=TimeSpan.FromSeconds(5)local dR=TimeSpan.FromSeconds(30)local dS=false;local dT=vci.me.Time;local dU=a.Random32()local dV=Vector3.__new(bit32.bor(0x400,bit32.band(dU,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(dU,16),0x1FFF)),0.0)dK.SetPosition(dV)dK.SetRotation(Quaternion.identity)dK.SetVelocity(Vector3.zero)dK.SetAngularVelocity(Vector3.zero)dK.AddForce(Vector3.__new(0.0,0.0,dL*dM))local self={Timestep=function()return dN end,Precision=function()return dO end,IsFinished=function()return dS end,Update=function()if dS then return dN end;local dW=vci.me.Time-dT;local dX=dW.TotalSeconds;if dX<=Vector3.kEpsilon then return dN end;local dY=dK.GetPosition().z-dV.z;local dZ=dY/dX;local d_=dZ/dM;if d_<=Vector3.kEpsilon then return dN end;dP.Offer(d_)local e0=dP.Size()if e0>=2 and dW>=dQ then local e1=0.0;for a7=1,e0 do e1=e1+dP.Get(a7)end;local e2=e1/e0;local e3=0.0;for a7=1,e0 do e3=e3+(dP.Get(a7)-e2)^2 end;local e4=e3/e0;if e4<dO then dO=e4;dN=TimeSpan.FromSeconds(e2)end;if dW>dR then dS=true;dK.SetPosition(dV)dK.SetRotation(Quaternion.identity)dK.SetVelocity(Vector3.zero)dK.SetAngularVelocity(Vector3.zero)end else dN=TimeSpan.FromSeconds(d_)end;return dN end}return self end,AlignSubItemOrigin=function(e5,e6,e7)local e8=e5.GetRotation()if not a.QuaternionApproximatelyEquals(e6.GetRotation(),e8)then e6.SetRotation(e8)end;local e9=e5.GetPosition()if not a.VectorApproximatelyEquals(e6.GetPosition(),e9)then e6.SetPosition(e9)end;if e7 then e6.SetVelocity(Vector3.zero)e6.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local ea={}local self;self={Contains=function(eb,ec)return a.NillableIfHasValueOrElse(ea[eb],function(bO)return a.NillableHasValue(bO[ec])end,function()return false end)end,Add=function(eb,ed,e7)if not eb or not ed then local ee='SubItemGlue.Add: Invalid arguments '..(not eb and', parent = '..tostring(eb)or'')..(not ed and', children = '..tostring(ed)or'')error(ee,2)end;local bO=a.NillableIfHasValueOrElse(ea[eb],function(ef)return ef end,function()local ef={}ea[eb]=ef;return ef end)if type(ed)=='table'then for aj,aX in pairs(ed)do bO[aX]={velocityReset=not not e7}end else bO[ed]={velocityReset=not not e7}end end,Remove=function(eb,ec)return a.NillableIfHasValueOrElse(ea[eb],function(bO)if a.NillableHasValue(bO[ec])then bO[ec]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(eb)if a.NillableHasValue(ea[eb])then ea[eb]=nil;return true else return false end end,RemoveAll=function()ea={}return true end,Each=function(bg,eg)return a.NillableIfHasValueOrElse(eg,function(eb)return a.NillableIfHasValue(ea[eb],function(bO)for ec,eh in pairs(bO)do if bg(ec,eb,self)==false then return false end end end)end,function()for eb,bO in pairs(ea)do if self.Each(bg,eb)==false then return false end end end)end,Update=function(ei)for eb,bO in pairs(ea)do local ej=eb.GetPosition()local ek=eb.GetRotation()for ec,eh in pairs(bO)do if ei or ec.IsMine then if not a.QuaternionApproximatelyEquals(ec.GetRotation(),ek)then ec.SetRotation(ek)end;if not a.VectorApproximatelyEquals(ec.GetPosition(),ej)then ec.SetPosition(ej)end;if eh.velocityReset then ec.SetVelocity(Vector3.zero)ec.SetAngularVelocity(Vector3.zero)end end end end end}return self end,
CreateUpdateRoutine=function(el,em)return coroutine.wrap(function()local en=TimeSpan.FromSeconds(30)local eo=vci.me.UnscaledTime;local ep=eo;local cR=vci.me.Time;local eq=true;while true do local di=a.InstanceID()if di~=''then break end;local er=vci.me.UnscaledTime;if er-en>eo then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;ep=er;cR=vci.me.Time;eq=false;coroutine.yield(100)end;if eq then ep=vci.me.UnscaledTime;cR=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(em,function(es)es()end)while true do local cU=vci.me.Time;local et=cU-cR;local er=vci.me.UnscaledTime;local eu=er-ep;el(et,eu)cR=cU;ep=er;coroutine.yield(100)end end)end,CreateSlideSwitch=function(ev)local ew=a.NillableValue(ev.colliderItem)local ex=a.NillableValue(ev.baseItem)local ey=a.NillableValue(ev.knobItem)local ez=a.NillableValueOrDefault(ev.minValue,0)local eA=a.NillableValueOrDefault(ev.maxValue,10)if ez>=eA then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local eB=(ez+eA)*0.5;local eC=function(aX)local eD,eE=a.PingPong(aX-ez,eA-ez)return eD+ez,eE end;local aa=eC(a.NillableValueOrDefault(ev.value,0))local eF=a.NillableIfHasValueOrElse(ev.tickFrequency,function(eG)if eG<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(eG,eA-ez)end,function()return(eA-ez)/10.0 end)local eH=a.NillableIfHasValueOrElse(ev.tickVector,function(co)return Vector3.__new(co.x,co.y,co.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local eI=eH.magnitude;if eI<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local eJ=a.NillableValueOrDefault(ev.snapToTick,true)local eK=ev.valueTextName;local eL=a.NillableValueOrDefault(ev.valueToText,tostring)local eM=TimeSpan.FromMilliseconds(1000)local eN=TimeSpan.FromMilliseconds(50)local eO,eP;local dH={}local self;local eQ=false;local eR=0;local eS=false;local eT=TimeSpan.Zero;local eU=TimeSpan.Zero;local eV=function(eW,eX)if eX or eW~=aa then local dI=aa;aa=eW;for dJ,ao in pairs(dH)do dJ(self,aa,dI)end end;ey.SetLocalPosition((eW-eB)/eF*eH)if eK then vci.assets.SetText(eK,eL(eW,self))end end;local eY=function()local eZ=eO()local e_,f0=eC(eZ)local f1=eZ+eF;local f2,f3=eC(f1)assert(f2)local eW;if f0==f3 or e_==eA or e_==ez then eW=f1 else eW=f0>=0 and eA or ez end;eU=vci.me.UnscaledTime;if eW==eA or eW==ez then eT=eU end;eP(eW)end;a.NillableIfHasValueOrElse(ev.lsp,function(f4)if not a.NillableHasValue(ev.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local f5=a.NillableValue(ev.propertyName)eO=function()return f4.GetProperty(f5,aa)end;eP=function(aX)f4.SetProperty(f5,aX)end;f4.AddListener(function(bP,aj,f6,f7)if aj==f5 then eV(eC(f6),true)end end)end,function()local f6=aa;eO=function()return f6 end;eP=function(aX)f6=aX;eV(eC(aX),true)end end)self={GetColliderItem=function()return ew end,GetBaseItem=function()return ex end,GetKnobItem=function()return ey end,GetMinValue=function()return ez end,GetMaxValue=function()return eA end,GetValue=function()return aa end,GetScaleValue=function(f8,f9)assert(f8<=f9)return f8+(f9-f8)*(aa-ez)/(eA-ez)end,SetValue=function(aX)eP(eC(aX))end,GetTickFrequency=function()return eF end,IsSnapToTick=function()return eJ end,AddListener=function(dJ)dH[dJ]=dJ end,RemoveListener=function(dJ)dH[dJ]=nil end,DoUse=function()if not eQ then eS=true;eT=vci.me.UnscaledTime;eY()end end,DoUnuse=function()eS=false end,DoGrab=function()if not eS then eQ=true;eR=(aa-eB)/eF end end,DoUngrab=function()eQ=false end,Update=function()if eQ then local fa=ew.GetPosition()-ex.GetPosition()local fb=ey.GetRotation()*eH;local fc=Vector3.Project(fa,fb)local fd=(Vector3.Dot(fb,fc)>=0 and 1 or-1)*fc.magnitude/eI+eR;local fe=(eJ and a.Round(fd)or fd)*eF+eB;local eW=a.Clamp(fe,ez,eA)if eW~=aa then eP(eW)end elseif eS then local ff=vci.me.UnscaledTime;if ff>=eT+eM and ff>=eU+eN then eY()end elseif ew.IsMine then a.AlignSubItemOrigin(ex,ew)end end}eV(eC(eO()),false)return self end,CreateSubItemConnector=function()local fg=function(fh,e6,fi)fh.item=e6;fh.position=e6.GetPosition()fh.rotation=e6.GetRotation()fh.initialPosition=fh.position;fh.initialRotation=fh.rotation;fh.propagation=not not fi;return fh end;local fj=function(fk)for e6,fh in pairs(fk)do fg(fh,e6,fh.propagation)end end;local fl=function(r,cC,fh,fm,fn)local fa=r-fh.initialPosition;local fo=cC*Quaternion.Inverse(fh.initialRotation)fh.position=r;fh.rotation=cC;for e6,fp in pairs(fm)do if e6~=fh.item and(not fn or fn(fp))then fp.position,fp.rotation=a.RotateAround(fp.initialPosition+fa,fp.initialRotation,r,fo)e6.SetPosition(fp.position)e6.SetRotation(fp.rotation)end end end;local fq={}local fr=true;local fs=false;local self;self={IsEnabled=function()return fr end,SetEnabled=function(c1)fr=c1;if c1 then fj(fq)fs=false end end,Contains=function(ft)return a.NillableHasValue(fq[ft])end,Add=function(fu,fv)if not fu then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(fu),2)end;local fw=type(fu)=='table'and fu or{fu}fj(fq)fs=false;for ax,e6 in pairs(fw)do fq[e6]=fg({},e6,not fv)end end,Remove=function(ft)local M=a.NillableHasValue(fq[ft])fq[ft]=nil;return M end,RemoveAll=function()fq={}return true end,Each=function(bg)for e6,fh in pairs(fq)do if bg(e6,self)==false then return false end end end,GetItems=function()local fw={}for e6,fh in pairs(fq)do table.insert(fw,e6)end;return fw end,Update=function()if not fr then return end;local fx=false;for e6,fh in pairs(fq)do local bK=e6.GetPosition()local fy=e6.GetRotation()if not a.VectorApproximatelyEquals(bK,fh.position)or not a.QuaternionApproximatelyEquals(fy,fh.rotation)then if fh.propagation then if e6.IsMine then fl(bK,fy,fq[e6],fq,function(fp)if fp.item.IsMine then return true else fs=true;return false end end)fx=true;break else fs=true end else fs=true end end end;if not fx and fs then fj(fq)fs=false end end}return self end,GetSubItemTransform=function(ft)local r=ft.GetPosition()local cC=ft.GetRotation()local fz=ft.GetLocalScale()return{positionX=r.x,positionY=r.y,positionZ=r.z,rotationX=cC.x,rotationY=cC.y,rotationZ=cC.z,rotationW=cC.w,scaleX=fz.x,scaleY=fz.y,scaleZ=fz.z}end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',MessageSenderOverride='__CYTANB_MESSAGE_SENDER_OVERRIDE',MessageOriginalSender='__CYTANB_MESSAGE_ORIGINAL_SENDER',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',DedicatedCommentMessageName='cytanb.comment.a2a6a035-6b8d-4e06-b4f9-07e6209b0639',DedicatedNotificationMessageName='cytanb.notification.698ba55f-2b69-47f2-a68d-bc303994cff3',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c=a.MakeSearchPattern({'\t','\n','\v','\f','\r',' '},1,-1)d=a.MakeSearchPattern({'sprite=','SPRITE='})e=a.MakeSearchPattern({'0','1','2','3','4','5','6','7','8','9'},1,9)f,g=(function()local fA={'A','B','C','D','E','F','a','b','c','d','e','f','0','1','2','3','4','5','6','7','8','9'}return a.MakeSearchPattern(fA,4,4),a.MakeSearchPattern(fA,8,8)end)()h=a.MakeSearchPattern({'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','_','-','.','(',')','!','~','*','\'','%'},1,-1)i={{tag=a.NegativeNumberTag,search=a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,search=a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,search=a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,search=a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}j={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}k=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})l=a.LogLevelInfo;n={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;o,p=(function()local dA='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local dG=_G[dA]if not dG then dG={}_G[dA]=dG end;local fB=dG.randomSeedValue;if not fB then fB=os.time()-os.clock()*10000;dG.randomSeedValue=fB;math.randomseed(fB)end;local fC=dG.clientID;if type(fC)~='string'then fC=tostring(a.RandomUUID())dG.clientID=fC end;local fD=vci.state.Get(b)or''if fD==''and vci.assets.IsMine then fD=tostring(a.RandomUUID())vci.state.Set(b,fD)end;return fD,fC end)()return a end)()

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
        local horizontalAttitude = li.GetPosition().y >= - settings.standLightSimLongSide and IsHorizontalAttitude(li.GetRotation(), Vector3.up, settings.standLightHorizontalAttitudeThreshold)
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
            local pos = item.GetPosition()
            local entry = {
                item = item,
                index = index,
                status = cytanb.Extend(cytanb.Extend({}, standLightInitialStatus), {
                    respawnPosition = Vector3.__new(pos.x, math.max(pos.y, settings.standLightSimLongSide), pos.z),
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
