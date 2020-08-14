-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g;local h;local i;local j;local k;local l;local m=false;local n;local o;local p;local a;local q=function(r,s)local t=r+s-1;return r,t,t+1 end;local u=function(r,s)local t=r-s+1;return t,r,t-1 end;local v=function(w,x,y,r,z)local A=y.searchMap;for B,s in pairs(y.lengthList)do if s<=0 then error('SearchPattern: Invalid parameter: searchLen <= 0')else local C,D,t=z(r,s)if C>=1 and D<=x then local E=string.sub(w,C,D)if A[E]then return true,s,t end end end end;return false,-1,-1 end;local F=function(w,y,r,z)if w==nil or y==nil then return false,-1 end;if y.hasEmptySearch then return true,0 end;local x=string.len(w)local G=y.repeatMin;local H=y.repeatMax;local I=H<0;local J=r;local K=0;local L=0;while I or L<H do local M,N,t=v(w,x,y,J,z)if M then if N<=0 then error('SearchPattern: Invalid parameter')end;J=t;K=K+N;L=L+1 else break end end;if L>=G then return true,K else return false,-1 end end;local O=function(w,P,r,Q,z,R)if w==nil or P==nil then return false,-1 end;local s=string.len(P)if Q then local M=R(w,P)return M,M and s or-1 else if s==0 then return true,s end;local x=string.len(w)local C,D=z(r,s)if C>=1 and D<=x then local E=string.sub(w,C,D)local M=R(E,P)return M,M and s or-1 else return false,-1 end end end;local S=function(w,T,U)if T<=U then local V=string.unicode(w,T,T)if V>=0xDC00 or V<=0xDFFF then return true,1,V end end;return false,-1,nil end;local W=function(w,T,U,X)if T<=U then local Y,Z=a.StringStartsWith(w,d,T)if Y then local _=T+Z;if _<=U then local a0,a1=a.StringStartsWith(w,e,_)if a0 then local a2=_+a1;if a2<=U and string.unicode(w,a2,a2)==0x3E then local a3=tonumber(string.sub(w,_,_+a1-1))if a3<=X then return true,a2-T+1,a3 end end end end end end;return false,-1,nil end;local a4=function(a5,a6)for a7=1,4 do local a8=a5[a7]-a6[a7]if a8~=0 then return a8 end end;return 0 end;local a9;a9={__eq=function(a5,a6)return a5[1]==a6[1]and a5[2]==a6[2]and a5[3]==a6[3]and a5[4]==a6[4]end,__lt=function(a5,a6)return a4(a5,a6)<0 end,__le=function(a5,a6)return a4(a5,a6)<=0 end,__tostring=function(aa)local ab=aa[2]or 0;local ac=aa[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(aa[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(ab,16),0xFFFF),bit32.band(ab,0xFFFF),bit32.band(bit32.rshift(ac,16),0xFFFF),bit32.band(ac,0xFFFF),bit32.band(aa[4]or 0,0xFFFFFFFF))end,__concat=function(a5,a6)local ad=getmetatable(a5)local ae=ad==a9 or type(ad)=='table'and ad.__concat==a9.__concat;local af=getmetatable(a6)local ag=af==a9 or type(af)=='table'and af.__concat==a9.__concat;if not ae and not ag then error('UUID: attempt to concatenate illegal values',2)end;return(ae and a9.__tostring(a5)or a5)..(ag and a9.__tostring(a6)or a6)end}local ah='__CYTANB_CONST_VARIABLES'local ai=function(table,aj)local ak=getmetatable(table)if ak then local al=rawget(ak,ah)if al then local am=rawget(al,aj)if type(am)=='function'then return am(table,aj)else return am end end end;return nil end;local an=function(table,aj,ao)local ak=getmetatable(table)if ak then local al=rawget(ak,ah)if al then if rawget(al,aj)~=nil then error('Cannot assign to read only field "'..aj..'"',2)end end end;rawset(table,aj,ao)end;local ap=function(aq,ar)local as=aq[a.TypeParameterName]if a.NillableHasValue(as)and a.NillableValue(as)~=ar then return false,false end;return a.NillableIfHasValueOrElse(j[ar],function(at)local au=at.compositionFieldNames;local av=at.compositionFieldLength;local aw=false;for ax,ao in pairs(aq)do if au[ax]then av=av-1;if av<=0 and aw then break end elseif ax~=a.TypeParameterName then aw=true;if av<=0 then break end end end;return av<=0,aw end,function()return false,false end)end;local ay=function(w)return a.StringReplace(a.StringReplace(w,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local az=function(w,aA)local aB=string.len(w)local aC=string.len(a.EscapeSequenceTag)if aC>aB then return w end;local aD=''local a7=1;while a7<aB do local D,aE=string.find(w,a.EscapeSequenceTag,a7,true)if not D then if a7==1 then aD=w else aD=aD..string.sub(w,a7)end;break end;if D>a7 then aD=aD..string.sub(w,a7,D-1)end;local aF=false;for aG,aH in ipairs(i)do local M=a.StringStartsWith(w,aH.search,D)if M then aD=aD..(aA and aA(aH.tag)or aH.replacement)a7=D+string.len(aH.search)aF=true;break end end;if not aF then aD=aD..a.EscapeSequenceTag;a7=aE+1 end end;return aD end;local aI;aI=function(aJ,aK)if type(aJ)~='table'then return aJ end;if not aK then aK={}end;if aK[aJ]then error('circular reference')end;aK[aJ]=true;local aL={}for ax,ao in pairs(aJ)do local aM=type(ax)local aN;if aM=='string'then aN=ay(ax)elseif aM=='number'then aN=tostring(ax)..a.ArrayNumberTag else aN=ax end;local aO=type(ao)if aO=='string'then aL[aN]=ay(ao)elseif aO=='number'and ao<0 then aL[tostring(aN)..a.NegativeNumberTag]=tostring(ao)else aL[aN]=aI(ao,aK)end end;aK[aJ]=nil;return aL end;local aP;aP=function(aL,aQ)if type(aL)~='table'then return aL end;local aJ={}for ax,ao in pairs(aL)do local aN;local aR=false;if type(ax)=='string'then local aS=false;aN=az(ax,function(aT)if aT==a.NegativeNumberTag then aR=true elseif aT==a.ArrayNumberTag then aS=true end;return nil end)if aS then aN=tonumber(aN)or aN end else aN=ax;aR=false end;if aR and type(ao)=='string'then aJ[aN]=tonumber(ao)elseif type(ao)=='string'then aJ[aN]=az(ao,function(aT)return k[aT]end)else aJ[aN]=aP(ao,aQ)end end;if not aQ then a.NillableIfHasValue(aJ[a.TypeParameterName],function(aU)a.NillableIfHasValue(j[aU],function(at)local aV,aw=at.fromTableFunc(aJ)if not aw then a.NillableIfHasValue(aV,function(aa)aJ=aa end)end end)end)end;return aJ end;local aW={['nil']=function(aX)return nil end,['number']=function(aX)return tonumber(aX)end,['string']=function(aX)return tostring(aX)end,['boolean']=function(aX)if aX then return true else return false end end}local aY=function(aX,aZ)local a_=type(aX)if a_==aZ then return aX else local b0=aW[aZ]if b0 then return b0(aX)else return nil end end end;local b1=function(b2,b3)if b3 and type(b3)=='table'then local b4={}for aj,aX in pairs(b2)do local b5=b3[aj]local b6;if b5==nil then b6=aX else local b7=aY(b5,type(aX))if b7==nil then b6=aX else b6=b7 end end;b4[aj]=b6 end;b4[a.MessageOriginalSender]=b2;return b4 else return b2 end end;local b8=function(b9,ba,b3,bb)local bc={type=bb,name='',commentSource=''}local bd={[a.MessageValueParameterName]=tostring(ba),[a.MessageSenderOverride]=type(b3)=='table'and a.Extend(bc,b3,true)or bc}a.EmitMessage(b9,bd)end;local be=function(b9,bf,bg)local bh,bi=(function()local b0=function(b2,bj,bd)local ba=tostring(bd[a.MessageValueParameterName]or'')bg(b2,bf,ba)end;local bh=a.OnMessage(b9,b0)local bi=a.OnMessage(bf,b0)return bh,bi end)()return{Off=function()bh.Off()bi.Off()end}end;a={InstanceID=function()if o==''then o=vci.state.Get(b)or''end;return o end,NillableHasValue=function(bk)return bk~=nil end,NillableValue=function(bk)if bk==nil then error('nillable: value is nil',2)end;return bk end,NillableValueOrDefault=function(bk,bl)if bk==nil then if bl==nil then error('nillable: defaultValue is nil',2)end;return bl else return bk end end,NillableIfHasValue=function(bk,bg)if bk==nil then return nil else return bg(bk)end end,NillableIfHasValueOrElse=function(bk,bg,bm)if bk==nil then return bm()else return bg(bk)end end,MakeSearchPattern=function(bn,bo,bp)local G=bo and math.floor(bo)or 1;if G<0 then error('SearchPattern: Invalid parameter: optRepeatMin < 0')end;local H=bp and math.floor(bp)or G;if H>=0 and H<G then error('SearchPattern: Invalid parameter: repeatMax < repeatMin')end;local bq=H==0;local A={}local br={}local bs={}local bt=0;for bu,bv in pairs(bn)do local s=string.len(bv)if s==0 then bq=true else A[bv]=s;if not br[s]then br[s]=true;bt=bt+1;bs[bt]=s end end end;table.sort(bs,function(bw,M)return bw>M end)return{hasEmptySearch=bq,searchMap=A,lengthList=bs,repeatMin=G,repeatMax=H}end,StringStartsWith=function(w,P,bx)local J=bx and math.max(1,math.floor(bx))or 1;if type(P)=='table'then return F(w,P,J,q)else return O(w,P,J,J==1,q,string.startsWith)end end,StringEndsWith=function(w,P,by)if w==nil then return false,-1 end;local x=string.len(w)local J=by and math.min(x,math.floor(by))or x;if type(P)=='table'then return F(w,P,J,u)else return O(w,P,J,J==x,u,string.endsWith)end end,StringTrimStart=function(w,bz)if w==nil or w==''then return w end;local M,N=a.StringStartsWith(w,bz or c)if M and N>=1 then return string.sub(w,N+1)else return w end end,StringTrimEnd=function(w,bz)if w==nil or w==''then return w end;local M,N=a.StringEndsWith(w,bz or c)if M and N>=1 then return string.sub(w,1,string.len(w)-N)else return w end end,StringTrim=function(w,bz)return a.StringTrimEnd(a.StringTrimStart(w,bz),bz)end,StringReplace=function(w,bA,bB)local bC;local aB=string.len(w)if bA==''then bC=bB;for a7=1,aB do bC=bC..string.sub(w,a7,a7)..bB end else bC=''local a7=1;while true do local C,D=string.find(w,bA,a7,true)if C then bC=bC..string.sub(w,a7,C-1)..bB;a7=D+1;if a7>aB then break end else bC=a7==1 and w or bC..string.sub(w,a7)break end end end;return bC end,
StringEachCode=function(w,bg,bD,a7,bE,bF,bG,bH)local aB=string.len(w)if aB==0 then return 0,0,0 end;local bI=a7 and math.floor(a7)or 1;local U=bE and math.floor(bE)or aB;local X=math.min(bH or 3182,0x1FFFFF)if bI<=0 or U>aB or bI>U then error('StringEachCode: invalid range')end;local bJ=0;local bK=bI;local bL=bK;while bK<=U do local C=bK;local V=string.unicode(w,bK,bK)if V>=0xD800 and V<=0xDBFF then local M,N=S(w,bK+1,U)if M then bK=bK+N end elseif bF and V==0x3C then local M,N,a3=W(w,bK+1,U,X)if M and(not bG or bG(a3))then bK=bK+N end end;bJ=bJ+1;bL=bK;if bg and bg(string.sub(w,C,bK),bJ,bD,C,bK)==false then break end;bK=bK+1 end;return bJ,bI,bL end,SetConst=function(bA,b9,aa)if type(bA)~='table'then error('Cannot set const to non-table target',2)end;local bM=getmetatable(bA)local ak=bM or{}local bN=rawget(ak,ah)if rawget(bA,b9)~=nil then error('Non-const field "'..b9 ..'" already exists',2)end;if not bN then bN={}rawset(ak,ah,bN)ak.__index=ai;ak.__newindex=an end;rawset(bN,b9,aa)if not bM then setmetatable(bA,ak)end;return bA end,SetConstEach=function(bA,bO)for ax,ao in pairs(bO)do a.SetConst(bA,ax,ao)end;return bA end,Extend=function(bA,bP,bQ,bR,aK)if bA==bP or type(bA)~='table'or type(bP)~='table'then return bA end;if bQ then if not aK then aK={}end;if aK[bP]then error('circular reference')end;aK[bP]=true end;for ax,ao in pairs(bP)do if bQ and type(ao)=='table'then local bS=bA[ax]bA[ax]=a.Extend(type(bS)=='table'and bS or{},ao,bQ,bR,aK)else bA[ax]=ao end end;if not bR then local bT=getmetatable(bP)if type(bT)=='table'then if bQ then local bU=getmetatable(bA)setmetatable(bA,a.Extend(type(bU)=='table'and bU or{},bT,true))else setmetatable(bA,bT)end end end;if bQ then aK[bP]=nil end;return bA end,Vars=function(ao,bV,bW,aK)local bX;if bV then bX=bV~='__NOLF'else bV='  'bX=true end;if not bW then bW=''end;if not aK then aK={}end;local bY=type(ao)if bY=='table'then aK[ao]=aK[ao]and aK[ao]+1 or 1;local bZ=bX and bW..bV or''local w='('..tostring(ao)..') {'local b_=true;for aj,aX in pairs(ao)do if b_ then b_=false else w=w..(bX and','or', ')end;if bX then w=w..'\n'..bZ end;if type(aX)=='table'and aK[aX]and aK[aX]>0 then w=w..aj..' = ('..tostring(aX)..')'else w=w..aj..' = '..a.Vars(aX,bV,bZ,aK)end end;if not b_ and bX then w=w..'\n'..bW end;w=w..'}'aK[ao]=aK[ao]-1;if aK[ao]<=0 then aK[ao]=nil end;return w elseif bY=='function'or bY=='thread'or bY=='userdata'then return'('..bY..')'elseif bY=='string'then return'('..bY..') '..string.format('%q',ao)else return'('..bY..') '..tostring(ao)end end,GetLogLevel=function()return l end,SetLogLevel=function(c0)l=c0 end,IsOutputLogLevelEnabled=function()return m end,SetOutputLogLevelEnabled=function(c1)m=not not c1 end,Log=function(c0,...)if c0<=l then local c2=m and(n[c0]or'LOG LEVEL '..tostring(c0))..' | 'or''local c3=table.pack(...)if c3.n==1 then local ao=c3[1]if ao~=nil then local w=type(ao)=='table'and a.Vars(ao)or tostring(ao)print(m and c2 ..w or w)else print(c2)end else local w=c2;for a7=1,c3.n do local ao=c3[a7]if ao~=nil then w=w..(type(ao)=='table'and a.Vars(ao)or tostring(ao))end end;print(w)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(c4,c5)local c6={}if c5==nil then for ax,ao in pairs(c4)do c6[ao]=ao end elseif type(c5)=='function'then for ax,ao in pairs(c4)do local c7,c8=c5(ao)c6[c7]=c8 end else for ax,ao in pairs(c4)do c6[ao]=c5 end end;return c6 end,Round=function(c9,ca)if ca then local cb=10^ca;return math.floor(c9*cb+0.5)/cb else return math.floor(c9+0.5)end end,Clamp=function(aa,cc,cd)return math.max(cc,math.min(aa,cd))end,Lerp=function(bw,M,bY)if bY<=0.0 then return bw elseif bY>=1.0 then return M else return bw+(M-bw)*bY end end,LerpUnclamped=function(bw,M,bY)if bY==0.0 then return bw elseif bY==1.0 then return M else return bw+(M-bw)*bY end end,PingPong=function(bY,ce)if ce==0 then return 0,1 end;local cf=math.floor(bY/ce)local cg=bY-cf*ce;if cf<0 then if(cf+1)%2==0 then return ce-cg,-1 else return cg,1 end else if cf%2==0 then return cg,1 else return ce-cg,-1 end end end,VectorApproximatelyEquals=function(ch,ci)return(ch-ci).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(ch,ci)local cj=Quaternion.Dot(ch,ci)return cj<1.0+1E-06 and cj>1.0-1E-06 end,QuaternionToAngleAxis=function(ck)local cf=ck.normalized;local cl=math.acos(cf.w)local cm=math.sin(cl)local cn=math.deg(cl*2.0)local co;if math.abs(cm)<=Quaternion.kEpsilon then co=Vector3.right else local C=1.0/cm;co=Vector3.__new(cf.x*C,cf.y*C,cf.z*C)end;return cn,co end,QuaternionTwist=function(ck,cp)if cp.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local cq=Vector3.__new(ck.x,ck.y,ck.z)if cq.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local cr=Vector3.Project(cq,cp)if cr.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local cs=Quaternion.__new(cr.x,cr.y,cr.z,ck.w)cs.Normalize()return cs else return Quaternion.AngleAxis(0,cp)end else local ct=a.QuaternionToAngleAxis(ck)return Quaternion.AngleAxis(ct,cp)end end,ApplyQuaternionToVector3=function(ck,cu)local cv=ck.w*cu.x+ck.y*cu.z-ck.z*cu.y;local cw=ck.w*cu.y-ck.x*cu.z+ck.z*cu.x;local cx=ck.w*cu.z+ck.x*cu.y-ck.y*cu.x;local cy=-ck.x*cu.x-ck.y*cu.y-ck.z*cu.z;return Vector3.__new(cy*-ck.x+cv*ck.w+cw*-ck.z-cx*-ck.y,cy*-ck.y-cv*-ck.z+cw*ck.w+cx*-ck.x,cy*-ck.z+cv*-ck.y-cw*-ck.x+cx*ck.w)end,RotateAround=function(cz,cA,cB,cC)return cB+cC*(cz-cB),cC*cA end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(cD)return a9.__tostring(cD)end,UUIDFromNumbers=function(...)local cE=...local bY=type(cE)local cF,cG,cH,cI;if bY=='table'then cF=cE[1]cG=cE[2]cH=cE[3]cI=cE[4]else cF,cG,cH,cI=...end;local cD={bit32.band(cF or 0,0xFFFFFFFF),bit32.band(cG or 0,0xFFFFFFFF),bit32.band(cH or 0,0xFFFFFFFF),bit32.band(cI or 0,0xFFFFFFFF)}setmetatable(cD,a9)return cD end,UUIDFromString=function(w)local aB=string.len(w)if aB==32 then local cD=a.UUIDFromNumbers(0,0,0,0)for a7=1,4 do local C=1+(a7-1)*8;if not a.StringStartsWith(w,g,C)then return nil end;cD[a7]=tonumber(string.sub(w,C,C+7),16)end;return cD elseif aB==36 then if not a.StringStartsWith(w,g,1)then return nil end;local cF=tonumber(string.sub(w,1,8),16)if not a.StringStartsWith(w,'-',9)or not a.StringStartsWith(w,f,10)or not a.StringStartsWith(w,'-',14)or not a.StringStartsWith(w,f,15)then return nil end;local cG=tonumber(string.sub(w,10,13)..string.sub(w,15,18),16)if not a.StringStartsWith(w,'-',19)or not a.StringStartsWith(w,f,20)or not a.StringStartsWith(w,'-',24)or not a.StringStartsWith(w,f,25)then return nil end;local cH=tonumber(string.sub(w,20,23)..string.sub(w,25,28),16)if not a.StringStartsWith(w,g,29)then return nil end;local cI=tonumber(string.sub(w,29),16)return a.UUIDFromNumbers(cF,cG,cH,cI)else return nil end end,ParseUUID=function(w)return a.UUIDFromString(w)end,CreateCircularQueue=function(cJ)if type(cJ)~='number'or cJ<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(cJ),2)end;local self;local cK=math.floor(cJ)local aD={}local cL=0;local cM=0;local cN=0;self={Size=function()return cN end,Clear=function()cL=0;cM=0;cN=0 end,IsEmpty=function()return cN==0 end,Offer=function(cO)aD[cL+1]=cO;cL=(cL+1)%cK;if cN<cK then cN=cN+1 else cM=(cM+1)%cK end;return true end,OfferFirst=function(cO)cM=(cK+cM-1)%cK;aD[cM+1]=cO;if cN<cK then cN=cN+1 else cL=(cK+cL-1)%cK end;return true end,Poll=function()if cN==0 then return nil else local cO=aD[cM+1]cM=(cM+1)%cK;cN=cN-1;return cO end end,PollLast=function()if cN==0 then return nil else cL=(cK+cL-1)%cK;local cO=aD[cL+1]cN=cN-1;return cO end end,Peek=function()if cN==0 then return nil else return aD[cM+1]end end,PeekLast=function()if cN==0 then return nil else return aD[(cK+cL-1)%cK+1]end end,Get=function(cP)if cP<1 or cP>cN then a.LogError('CreateCircularQueue.Get: index is outside the range: '..cP)return nil end;return aD[(cM+cP-1)%cK+1]end,IsFull=function()return cN>=cK end,MaxSize=function()return cK end}return self end,DetectClicks=function(cQ,cR,cS)local bJ=cQ or 0;local cT=cS or TimeSpan.FromMilliseconds(500)local cU=vci.me.Time;local cV=cR and cU>cR+cT and 1 or bJ+1;return cV,cU end,ColorRGBToHSV=function(cW)local cg=math.max(0.0,math.min(cW.r,1.0))local cX=math.max(0.0,math.min(cW.g,1.0))local M=math.max(0.0,math.min(cW.b,1.0))local cd=math.max(cg,cX,M)local cc=math.min(cg,cX,M)local cY=cd-cc;local am;if cY==0.0 then am=0.0 elseif cd==cg then am=(cX-M)/cY/6.0 elseif cd==cX then am=(2.0+(M-cg)/cY)/6.0 else am=(4.0+(cg-cX)/cY)/6.0 end;if am<0.0 then am=am+1.0 end;local cZ=cd==0.0 and cY or cY/cd;local ao=cd;return am,cZ,ao end,ColorFromARGB32=function(c_)local d0=type(c_)=='number'and c_ or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(d0,16),0xFF)/0xFF,bit32.band(bit32.rshift(d0,8),0xFF)/0xFF,bit32.band(d0,0xFF)/0xFF,bit32.band(bit32.rshift(d0,24),0xFF)/0xFF)end,ColorToARGB32=function(cW)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*cW.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*cW.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*cW.g),0xFF),8),bit32.band(a.Round(0xFF*cW.b),0xFF))end,
ColorFromIndex=function(d1,d2,d3,d4,d5)local d6=math.max(math.floor(d2 or a.ColorHueSamples),1)local d7=d5 and d6 or d6-1;local d8=math.max(math.floor(d3 or a.ColorSaturationSamples),1)local d9=math.max(math.floor(d4 or a.ColorBrightnessSamples),1)local cP=a.Clamp(math.floor(d1 or 0),0,d6*d8*d9-1)local da=cP%d6;local db=math.floor(cP/d6)local C=db%d8;local dc=math.floor(db/d8)if d5 or da~=d7 then local am=da/d7;local cZ=(d8-C)/d8;local ao=(d9-dc)/d9;return Color.HSVToRGB(am,cZ,ao)else local ao=(d9-dc)/d9*C/(d8-1)return Color.HSVToRGB(0.0,0.0,ao)end end,ColorToIndex=function(cW,d2,d3,d4,d5)local d6=math.max(math.floor(d2 or a.ColorHueSamples),1)local d7=d5 and d6 or d6-1;local d8=math.max(math.floor(d3 or a.ColorSaturationSamples),1)local d9=math.max(math.floor(d4 or a.ColorBrightnessSamples),1)local am,cZ,ao=a.ColorRGBToHSV(cW)local C=a.Round(d8*(1.0-cZ))if d5 or C<d8 then local dd=a.Round(d7*am)if dd>=d7 then dd=0 end;if C>=d8 then C=d8-1 end;local dc=math.min(d9-1,a.Round(d9*(1.0-ao)))return dd+d6*(C+d8*dc)else local de=a.Round((d8-1)*ao)if de==0 then local df=a.Round(d9*(1.0-ao))if df>=d9 then return d6-1 else return d6*(1+a.Round(ao*(d8-1)/(d9-df)*d9)+d8*df)-1 end else return d6*(1+de+d8*a.Round(d9*(1.0-ao*(d8-1)/de)))-1 end end end,ColorToTable=function(cW)return{[a.TypeParameterName]=a.ColorTypeName,r=cW.r,g=cW.g,b=cW.b,a=cW.a}end,ColorFromTable=function(aq)local M,aw=ap(aq,a.ColorTypeName)return M and Color.__new(aq.r,aq.g,aq.b,aq.a)or nil,aw end,Vector2ToTable=function(aa)return{[a.TypeParameterName]=a.Vector2TypeName,x=aa.x,y=aa.y}end,Vector2FromTable=function(aq)local M,aw=ap(aq,a.Vector2TypeName)return M and Vector2.__new(aq.x,aq.y)or nil,aw end,Vector3ToTable=function(aa)return{[a.TypeParameterName]=a.Vector3TypeName,x=aa.x,y=aa.y,z=aa.z}end,Vector3FromTable=function(aq)local M,aw=ap(aq,a.Vector3TypeName)return M and Vector3.__new(aq.x,aq.y,aq.z)or nil,aw end,Vector4ToTable=function(aa)return{[a.TypeParameterName]=a.Vector4TypeName,x=aa.x,y=aa.y,z=aa.z,w=aa.w}end,Vector4FromTable=function(aq)local M,aw=ap(aq,a.Vector4TypeName)return M and Vector4.__new(aq.x,aq.y,aq.z,aq.w)or nil,aw end,QuaternionToTable=function(aa)return{[a.TypeParameterName]=a.QuaternionTypeName,x=aa.x,y=aa.y,z=aa.z,w=aa.w}end,QuaternionFromTable=function(aq)local M,aw=ap(aq,a.QuaternionTypeName)return M and Quaternion.__new(aq.x,aq.y,aq.z,aq.w)or nil,aw end,TableToSerializable=function(aJ)return aI(aJ)end,TableFromSerializable=function(aL,aQ)return aP(aL,aQ)end,TableToSerialiable=function(aJ)return aI(aJ)end,TableFromSerialiable=function(aL,aQ)return aP(aL,aQ)end,EmitMessage=function(b9,bd)local aL=a.NillableIfHasValueOrElse(bd,function(aJ)if type(aJ)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(aJ)end,function()return{}end)aL[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(b9,json.serialize(aL))end,OnMessage=function(b9,bg)local b0=function(b2,bj,ba)if type(ba)=='string'and string.startsWith(ba,'{')then local dg,aL=pcall(json.parse,ba)if dg and type(aL)=='table'and aL[a.InstanceIDParameterName]then local dh=a.TableFromSerializable(aL)bg(b1(b2,dh[a.MessageSenderOverride]),bj,dh)return end end;bg(b2,bj,{[a.MessageValueParameterName]=ba})end;vci.message.On(b9,b0)return{Off=function()if b0 then b0=nil end end}end,OnInstanceMessage=function(b9,bg)local b0=function(b2,bj,bd)local di=a.InstanceID()if di~=''and di==bd[a.InstanceIDParameterName]then bg(b2,bj,bd)end end;return a.OnMessage(b9,b0)end,EmitCommentMessage=function(ba,b3)b8(a.DedicatedCommentMessageName,ba,b3,'comment')end,OnCommentMessage=function(bg)return be(a.DedicatedCommentMessageName,'comment',bg)end,EmitNotificationMessage=function(ba,b3)b8(a.DedicatedNotificationMessageName,ba,b3,'notification')end,OnNotificationMessage=function(bg)return be(a.DedicatedNotificationMessageName,'notification',bg)end,GetEffekseerEmitterMap=function(b9)local dj=vci.assets.GetEffekseerEmitters(b9)if not dj then return nil end;local c6={}for a7,dk in pairs(dj)do c6[dk.EffectName]=dk end;return c6 end,ClientID=function()return p end,ParseTagString=function(w)local bK=string.find(w,'#',1,true)if not bK then return{},w end;local dl={}local dm=string.sub(w,1,bK-1)bK=bK+1;local aB=string.len(w)while bK<=aB do local dn,dp=a.StringStartsWith(w,h,bK)if dn then local dq=bK+dp;local dr=string.sub(w,bK,dq-1)local ds=dr;bK=dq;if bK<=aB and a.StringStartsWith(w,'=',bK)then bK=bK+1;local dt,du=a.StringStartsWith(w,h,bK)if dt then local dv=bK+du;ds=string.sub(w,bK,dv-1)bK=dv else ds=''end end;dl[dr]=ds end;bK=string.find(w,'#',bK,true)if not bK then break end;bK=bK+1 end;return dl,dm end,CalculateSIPrefix=(function()local dw=9;local dx={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local dy=#dx;return function(c9)local dz=c9==0 and 0 or a.Clamp(math.floor(math.log(math.abs(c9),1000)),1-dw,dy-dw)return dz==0 and c9 or c9/1000^dz,dx[dw+dz],dz*3 end end)(),CreateLocalSharedProperties=function(dA,dB)local dC=TimeSpan.FromSeconds(5)local dD='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local dE='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(dA)~='string'or string.len(dA)<=0 or type(dB)~='string'or string.len(dB)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local dF=_G[dD]if not dF then dF={}_G[dD]=dF end;dF[dB]=vci.me.UnscaledTime;local dG=_G[dA]if not dG then dG={[dE]={}}_G[dA]=dG end;local dH=dG[dE]local self;self={GetLspID=function()return dA end,GetLoadID=function()return dB end,GetProperty=function(aj,bl)local aa=dG[aj]if aa==nil then return bl else return aa end end,SetProperty=function(aj,aa)if aj==dE then error('LocalSharedProperties: Invalid argument: key = ',aj,2)end;local cU=vci.me.UnscaledTime;local dI=dG[aj]dG[aj]=aa;for dJ,di in pairs(dH)do local bY=dF[di]if bY and bY+dC>=cU then dJ(self,aj,aa,dI)else dJ(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)dH[dJ]=nil;dF[di]=nil end end end,Clear=function()for aj,aa in pairs(dG)do if aj~=dE then self.SetProperty(aj,nil)end end end,Each=function(bg)for aj,aa in pairs(dG)do if aj~=dE and bg(aa,aj,self)==false then return false end end end,AddListener=function(dJ)dH[dJ]=dB end,RemoveListener=function(dJ)dH[dJ]=nil end,UpdateAlive=function()dF[dB]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(dK)local dL=1.0;local dM=1000.0;local dN=TimeSpan.FromSeconds(0.02)local dO=0xFFFF;local dP=a.CreateCircularQueue(64)local dQ=TimeSpan.FromSeconds(5)local dR=TimeSpan.FromSeconds(30)local dS=false;local dT=vci.me.Time;local dU=a.Random32()local dV=Vector3.__new(bit32.bor(0x400,bit32.band(dU,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(dU,16),0x1FFF)),0.0)dK.SetPosition(dV)dK.SetRotation(Quaternion.identity)dK.SetVelocity(Vector3.zero)dK.SetAngularVelocity(Vector3.zero)dK.AddForce(Vector3.__new(0.0,0.0,dL*dM))local self={Timestep=function()return dN end,Precision=function()return dO end,IsFinished=function()return dS end,Update=function()if dS then return dN end;local dW=vci.me.Time-dT;local dX=dW.TotalSeconds;if dX<=Vector3.kEpsilon then return dN end;local dY=dK.GetPosition().z-dV.z;local dZ=dY/dX;local d_=dZ/dM;if d_<=Vector3.kEpsilon then return dN end;dP.Offer(d_)local e0=dP.Size()if e0>=2 and dW>=dQ then local e1=0.0;for a7=1,e0 do e1=e1+dP.Get(a7)end;local e2=e1/e0;local e3=0.0;for a7=1,e0 do e3=e3+(dP.Get(a7)-e2)^2 end;local e4=e3/e0;if e4<dO then dO=e4;dN=TimeSpan.FromSeconds(e2)end;if dW>dR then dS=true;dK.SetPosition(dV)dK.SetRotation(Quaternion.identity)dK.SetVelocity(Vector3.zero)dK.SetAngularVelocity(Vector3.zero)end else dN=TimeSpan.FromSeconds(d_)end;return dN end}return self end,AlignSubItemOrigin=function(e5,e6,e7)local e8=e5.GetRotation()if not a.QuaternionApproximatelyEquals(e6.GetRotation(),e8)then e6.SetRotation(e8)end;local e9=e5.GetPosition()if not a.VectorApproximatelyEquals(e6.GetPosition(),e9)then e6.SetPosition(e9)end;if e7 then e6.SetVelocity(Vector3.zero)e6.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local ea={}local self;self={Contains=function(eb,ec)return a.NillableIfHasValueOrElse(ea[eb],function(bO)return a.NillableHasValue(bO[ec])end,function()return false end)end,Add=function(eb,ed,e7)if not eb or not ed then local ee='SubItemGlue.Add: Invalid arguments '..(not eb and', parent = '..tostring(eb)or'')..(not ed and', children = '..tostring(ed)or'')error(ee,2)end;local bO=a.NillableIfHasValueOrElse(ea[eb],function(ef)return ef end,function()local ef={}ea[eb]=ef;return ef end)if type(ed)=='table'then for aj,aX in pairs(ed)do bO[aX]={velocityReset=not not e7}end else bO[ed]={velocityReset=not not e7}end end,Remove=function(eb,ec)return a.NillableIfHasValueOrElse(ea[eb],function(bO)if a.NillableHasValue(bO[ec])then bO[ec]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(eb)if a.NillableHasValue(ea[eb])then ea[eb]=nil;return true else return false end end,RemoveAll=function()ea={}return true end,Each=function(bg,eg)return a.NillableIfHasValueOrElse(eg,function(eb)return a.NillableIfHasValue(ea[eb],function(bO)for ec,eh in pairs(bO)do if bg(ec,eb,self)==false then return false end end end)end,function()for eb,bO in pairs(ea)do if self.Each(bg,eb)==false then return false end end end)end,Update=function(ei)for eb,bO in pairs(ea)do local ej=eb.GetPosition()local ek=eb.GetRotation()for ec,eh in pairs(bO)do if ei or ec.IsMine then if not a.QuaternionApproximatelyEquals(ec.GetRotation(),ek)then ec.SetRotation(ek)end;if not a.VectorApproximatelyEquals(ec.GetPosition(),ej)then ec.SetPosition(ej)end;if eh.velocityReset then ec.SetVelocity(Vector3.zero)ec.SetAngularVelocity(Vector3.zero)end end end end end}return self end,
CreateUpdateRoutine=function(el,em)return coroutine.wrap(function()local en=TimeSpan.FromSeconds(30)local eo=vci.me.UnscaledTime;local ep=eo;local cR=vci.me.Time;local eq=true;while true do local di=a.InstanceID()if di~=''then break end;local er=vci.me.UnscaledTime;if er-en>eo then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;ep=er;cR=vci.me.Time;eq=false;coroutine.yield(100)end;if eq then ep=vci.me.UnscaledTime;cR=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(em,function(es)es()end)while true do local cU=vci.me.Time;local et=cU-cR;local er=vci.me.UnscaledTime;local eu=er-ep;el(et,eu)cR=cU;ep=er;coroutine.yield(100)end end)end,CreateSlideSwitch=function(ev)local ew=a.NillableValue(ev.colliderItem)local ex=a.NillableValue(ev.baseItem)local ey=a.NillableValue(ev.knobItem)local ez=a.NillableValueOrDefault(ev.minValue,0)local eA=a.NillableValueOrDefault(ev.maxValue,10)if ez>=eA then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local eB=(ez+eA)*0.5;local eC=function(aX)local eD,eE=a.PingPong(aX-ez,eA-ez)return eD+ez,eE end;local aa=eC(a.NillableValueOrDefault(ev.value,0))local eF=a.NillableIfHasValueOrElse(ev.tickFrequency,function(eG)if eG<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(eG,eA-ez)end,function()return(eA-ez)/10.0 end)local eH=a.NillableIfHasValueOrElse(ev.tickVector,function(co)return Vector3.__new(co.x,co.y,co.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local eI=eH.magnitude;if eI<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local eJ=a.NillableValueOrDefault(ev.snapToTick,true)local eK=ev.valueTextName;local eL=a.NillableValueOrDefault(ev.valueToText,tostring)local eM=TimeSpan.FromMilliseconds(1000)local eN=TimeSpan.FromMilliseconds(50)local eO,eP;local dH={}local self;local eQ=false;local eR=0;local eS=false;local eT=TimeSpan.Zero;local eU=TimeSpan.Zero;local eV=function(eW,eX)if eX or eW~=aa then local dI=aa;aa=eW;for dJ,ao in pairs(dH)do dJ(self,aa,dI)end end;ey.SetLocalPosition((eW-eB)/eF*eH)if eK then vci.assets.SetText(eK,eL(eW,self))end end;local eY=function()local eZ=eO()local e_,f0=eC(eZ)local f1=eZ+eF;local f2,f3=eC(f1)assert(f2)local eW;if f0==f3 or e_==eA or e_==ez then eW=f1 else eW=f0>=0 and eA or ez end;eU=vci.me.UnscaledTime;if eW==eA or eW==ez then eT=eU end;eP(eW)end;a.NillableIfHasValueOrElse(ev.lsp,function(f4)if not a.NillableHasValue(ev.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local f5=a.NillableValue(ev.propertyName)eO=function()return f4.GetProperty(f5,aa)end;eP=function(aX)f4.SetProperty(f5,aX)end;f4.AddListener(function(bP,aj,f6,f7)if aj==f5 then eV(eC(f6),true)end end)end,function()local f6=aa;eO=function()return f6 end;eP=function(aX)f6=aX;eV(eC(aX),true)end end)self={GetColliderItem=function()return ew end,GetBaseItem=function()return ex end,GetKnobItem=function()return ey end,GetMinValue=function()return ez end,GetMaxValue=function()return eA end,GetValue=function()return aa end,GetScaleValue=function(f8,f9)assert(f8<=f9)return f8+(f9-f8)*(aa-ez)/(eA-ez)end,SetValue=function(aX)eP(eC(aX))end,GetTickFrequency=function()return eF end,IsSnapToTick=function()return eJ end,AddListener=function(dJ)dH[dJ]=dJ end,RemoveListener=function(dJ)dH[dJ]=nil end,DoUse=function()if not eQ then eS=true;eT=vci.me.UnscaledTime;eY()end end,DoUnuse=function()eS=false end,DoGrab=function()if not eS then eQ=true;eR=(aa-eB)/eF end end,DoUngrab=function()eQ=false end,Update=function()if eQ then local fa=ew.GetPosition()-ex.GetPosition()local fb=ey.GetRotation()*eH;local fc=Vector3.Project(fa,fb)local fd=(Vector3.Dot(fb,fc)>=0 and 1 or-1)*fc.magnitude/eI+eR;local fe=(eJ and a.Round(fd)or fd)*eF+eB;local eW=a.Clamp(fe,ez,eA)if eW~=aa then eP(eW)end elseif eS then local ff=vci.me.UnscaledTime;if ff>=eT+eM and ff>=eU+eN then eY()end elseif ew.IsMine then a.AlignSubItemOrigin(ex,ew)end end}eV(eC(eO()),false)return self end,CreateSubItemConnector=function()local fg=function(fh,e6,fi)fh.item=e6;fh.position=e6.GetPosition()fh.rotation=e6.GetRotation()fh.initialPosition=fh.position;fh.initialRotation=fh.rotation;fh.propagation=not not fi;return fh end;local fj=function(fk)for e6,fh in pairs(fk)do fg(fh,e6,fh.propagation)end end;local fl=function(r,cC,fh,fm,fn)local fa=r-fh.initialPosition;local fo=cC*Quaternion.Inverse(fh.initialRotation)fh.position=r;fh.rotation=cC;for e6,fp in pairs(fm)do if e6~=fh.item and(not fn or fn(fp))then fp.position,fp.rotation=a.RotateAround(fp.initialPosition+fa,fp.initialRotation,r,fo)e6.SetPosition(fp.position)e6.SetRotation(fp.rotation)end end end;local fq={}local fr=true;local fs=false;local self;self={IsEnabled=function()return fr end,SetEnabled=function(c1)fr=c1;if c1 then fj(fq)fs=false end end,Contains=function(ft)return a.NillableHasValue(fq[ft])end,Add=function(fu,fv)if not fu then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(fu),2)end;local fw=type(fu)=='table'and fu or{fu}fj(fq)fs=false;for ax,e6 in pairs(fw)do fq[e6]=fg({},e6,not fv)end end,Remove=function(ft)local M=a.NillableHasValue(fq[ft])fq[ft]=nil;return M end,RemoveAll=function()fq={}return true end,Each=function(bg)for e6,fh in pairs(fq)do if bg(e6,self)==false then return false end end end,GetItems=function()local fw={}for e6,fh in pairs(fq)do table.insert(fw,e6)end;return fw end,Update=function()if not fr then return end;local fx=false;for e6,fh in pairs(fq)do local bK=e6.GetPosition()local fy=e6.GetRotation()if not a.VectorApproximatelyEquals(bK,fh.position)or not a.QuaternionApproximatelyEquals(fy,fh.rotation)then if fh.propagation then if e6.IsMine then fl(bK,fy,fq[e6],fq,function(fp)if fp.item.IsMine then return true else fs=true;return false end end)fx=true;break else fs=true end else fs=true end end end;if not fx and fs then fj(fq)fs=false end end}return self end,GetSubItemTransform=function(ft)local r=ft.GetPosition()local cC=ft.GetRotation()local fz=ft.GetLocalScale()return{positionX=r.x,positionY=r.y,positionZ=r.z,rotationX=cC.x,rotationY=cC.y,rotationZ=cC.z,rotationW=cC.w,scaleX=fz.x,scaleY=fz.y,scaleZ=fz.z}end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',MessageSenderOverride='__CYTANB_MESSAGE_SENDER_OVERRIDE',MessageOriginalSender='__CYTANB_MESSAGE_ORIGINAL_SENDER',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',DedicatedCommentMessageName='cytanb.comment.a2a6a035-6b8d-4e06-b4f9-07e6209b0639',DedicatedNotificationMessageName='cytanb.notification.698ba55f-2b69-47f2-a68d-bc303994cff3',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c=a.MakeSearchPattern({'\t','\n','\v','\f','\r',' '},1,-1)d=a.MakeSearchPattern({'sprite=','SPRITE='})e=a.MakeSearchPattern({'0','1','2','3','4','5','6','7','8','9'},1,9)f,g=(function()local fA={'A','B','C','D','E','F','a','b','c','d','e','f','0','1','2','3','4','5','6','7','8','9'}return a.MakeSearchPattern(fA,4,4),a.MakeSearchPattern(fA,8,8)end)()h=a.MakeSearchPattern({'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','_','-','.','(',')','!','~','*','\'','%'},1,-1)i={{tag=a.NegativeNumberTag,search=a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,search=a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,search=a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,search=a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}j={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}k=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})l=a.LogLevelInfo;n={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;o,p=(function()local dA='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local dG=_G[dA]if not dG then dG={}_G[dA]=dG end;local fB=dG.randomSeedValue;if not fB then fB=os.time()-os.clock()*10000;dG.randomSeedValue=fB;math.randomseed(fB)end;local fC=dG.clientID;if type(fC)~='string'then fC=tostring(a.RandomUUID())dG.clientID=fC end;local fD=vci.state.Get(b)or''if fD==''and vci.assets.IsMine then fD=tostring(a.RandomUUID())vci.state.Set(b,fD)end;return fD,fC end)()return a end)()

local GetGameObjectTransform = function (name) return assert(vci.assets.GetTransform(name)) end
local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end

local settings = {
    enableDebugging = false
}

--- カラーパレットのメッセージの名前空間。
local ColorPaletteMessageNS = 'cytanb.color-palette'

--- メッセージフォーマットの最小バージョン。
local ColorPaletteMinMessageVersion = 0x10000

--- アイテムのステータスを通知するメッセージ名。
local ColorPaletteItemStatusMessageName = ColorPaletteMessageNS .. '.item-status'

local lumpNS = 'com.github.oocytanb.oO-vci-pack.cube-lump'
local statusMessageName = lumpNS .. '.status'
local queryStatusMessageName = lumpNS .. '.query-status'

local vciLoaded = false

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local BinarySearchInsert = function (sortedList, size, value, less)
    local listSize = math.floor(size)
    local beginIndex = 1
    local endIndex = listSize

    if endIndex <= 0 then
        sortedList[1] = value
        return 1
    end

    while beginIndex < endIndex do
        local middleIndex = bit32.rshift(beginIndex + endIndex, 1)
        if less(value, sortedList[middleIndex]) then
            endIndex = middleIndex - 1
        else
            beginIndex = middleIndex + 1
        end
    end

    local insertIndex = less(value, sortedList[beginIndex]) and beginIndex or beginIndex + 1
    table.insert(sortedList, insertIndex, value)
    return insertIndex
end

local RingIterator; RingIterator = {
    Make = function (list, i, j)
        local beginIndex = i and math.floor(i) or 1
        local endIndex = j and math.floor(j) or #list

        local size
        if beginIndex == 0 and endIndex == 0 then
            size = 0
        elseif beginIndex >= 1 and beginIndex <= endIndex then
            size = endIndex - beginIndex + 1
        else
            error('RingIterator: invalid range')
        end

        return {
            list = list,
            size = size,
            offset = beginIndex - 1,
            index = 0
        }
    end,

    Next = function (self)
        if self.size > 0 then
            local nextIndex = self.index % self.size + 1
            self.index = nextIndex
            return self.list[self.offset + nextIndex]
        else
            return nil
        end
    end
}

local TenthCube; TenthCube = cytanb.SetConstEach({
    ItemName = function (x, y, z)
        return TenthCube.Prefix .. x .. '-' .. y .. '-' .. z
    end,

    IsApproximatelySamePosition = function (pos1, pos2)
        return (pos1 - pos2).sqrMagnitude < TenthCube.SqrMinDistanceThreshold
    end,

    Make = function (x, y, z, relativePosition)
        local name = TenthCube.ItemName(x, y, z)
        return {
            name = name,
            x = x,
            y = y,
            z = z,
            relativePosition = relativePosition,
            distance = relativePosition.magnitude,
            item = GetGameObjectTransform(name),
        }
    end,

    TargetPosition = function (self, posistion, rotation)
        return posistion + rotation * self.relativePosition
    end
}, {
    Prefix = 'tenth-cube-',
    EdgeLength = 0.1,
    IntervalLength = 0.05,
    SqrMinDistanceThreshold = 1E-4,
})

local CubeMaterial; CubeMaterial = {
    Make = function (name)
        local color = assert(vci.assets.material.GetColor(name))
        local h, s, v = cytanb.ColorRGBToHSV(color)
        local hsv = {h = h, s = s, v = v}
        return {
            name = name,
            initialHSV = hsv,
            hsv = cytanb.Extend({}, hsv),
        }
    end,

    SetHSV = function (self, h, s, v)
        local hsv = self.hsv
        hsv.h = h - math.floor(h)
        hsv.s = s
        hsv.v = v
        vci.assets.material.SetColor(self.name, Color.HSVToRGB(hsv.h, hsv.s, hsv.v))
        return self
    end,
}

local CubeLump; CubeLump = cytanb.SetConstEach({
    CubeIndex = function (edgeSize, x, y, z)
        return (z * edgeSize + y) * edgeSize + x + 1
    end,

    CalcCubeEdgeOffset = function (edgeLength, n)
        return (- edgeLength + TenthCube.EdgeLength) * 0.5 + (TenthCube.EdgeLength + TenthCube.IntervalLength) * n
    end,

    LazyMake = function ()
        return coroutine.wrap(function ()
            -- check edge size.
            local edgeSize = 0
            while true do
                local name = TenthCube.ItemName(0, 0, edgeSize)
                if not vci.assets.GetTransform(name) then
                    break
                end
                edgeSize = edgeSize + 1
            end

            if edgeSize <= 0 then
                error('CubeLump: invalid range: edgeSize = ' .. tostring(edgeSize))
            end

            local edgeLength = (TenthCube.EdgeLength + TenthCube.IntervalLength) * edgeSize - TenthCube.IntervalLength
            local size = edgeSize ^ 3
            local blockSize = math.min(size, math.floor(CubeLump.MaxBlockSize / edgeSize) * edgeSize)

            -- make cubes.
            local cubes = {}
            local i = 1
            for x = 0, edgeSize - 1 do
                local px = CubeLump.CalcCubeEdgeOffset(edgeLength, x)
                for y = 0, edgeSize - 1 do
                    local py = CubeLump.CalcCubeEdgeOffset(edgeLength, y)
                    for z = 0, edgeSize - 1 do
                        local pz = CubeLump.CalcCubeEdgeOffset(edgeLength, z)
                        local relativePosition = Vector3.__new(px, py, pz)
                        local index = CubeLump.CubeIndex(edgeSize, x, y, z)
                        local cube = TenthCube.Make(x, y, z, relativePosition)
                        cubes[index] = cube

                        if i < size and i % blockSize == 0 then
                            coroutine.yield()
                        end
                        i = i + 1
                    end
                end
            end

            return {
                edgeSize = edgeSize,
                cubes = cubes,
                size = size,
                boundsItem = GetSubItem(CubeLump.BoundsName),
                blockSize = blockSize,
                grabbed = false
            }
        end)
    end,

    Update = function (self)
        if self.grabbed and not self.boundsItem.IsMine then
            CubeLump.Ungrab(self)
        end
    end,

    Grab = function (self)
        self.grabbed = true
    end,

    Ungrab = function (self)
        if self.grabbed then
            self.grabbed = false
        end
    end
}, {
    BoundsName = 'bounds-item',
    MaxBlockSize = 50
})

local CubeInterpolator; CubeInterpolator = cytanb.SetConstEach({
    Make = function (cube)
        return {
            cube = cube,
            startSec = 0,
            durationSec = 0,
            processingSec = 0,
            startPosition = cube.relativePosition,
            startRotation = Quaternion.identity,
            targetPosition = cube.relativePosition,
            targetRotation = Quaternion.identity,
            processingPosition = cube.relativePosition,
            processingRotation = Quaternion.identity
        }
    end,

    SetTarget = function (self, targetPosition, targetRotation, currentSec, optDurationSec)
        local item = self.cube.item
        if CubeInterpolator.IsProcessing(self) then
            self.startPosition = self.processingPosition
            self.startRotation = self.processingRotation
        else
            self.startPosition = item.GetPosition()
            self.startRotation = item.GetRotation()
        end
        self.startSec = currentSec
        self.durationSec = optDurationSec or CubeInterpolator.InterpolationSec
        self.processingSec = 0
        self.targetPosition = targetPosition
        self.targetRotation = targetRotation
    end,

    IsProcessing = function (self)
        return self.processingSec < self.durationSec
    end,

    Process = function (self, currentSec)
        if not CubeInterpolator.IsProcessing(self) then
            return false
        end

        local pos, rot
        if self.durationSec > 0 then
            self.processingSec = currentSec - self.startSec
            local t = self.processingSec / self.durationSec
            pos = Vector3.Lerp(self.startPosition, self.targetPosition, t)
            rot = Quaternion.Lerp(self.startRotation, self.targetRotation, t)
        else
            self.processingSec = self.durationSec
            pos = self.targetPosition
            rot = self.targetRotation
        end

        self.processingPosition = pos
        self.processingRotation = rot

        local item = self.cube.item
        item.SetPosition(pos)
        item.SetRotation(rot)

        return true
    end
}, {
    InterpolationSec = 5.0,
    PrimaryInterpolationSec = 0.01
})

local CubeTransformer; CubeTransformer = {
    SetInterpolatorTarget = function (interpolator, boundsPosition, boundsRotation, currentSec, optDurationSec)
        local targetPosition = TenthCube.TargetPosition(interpolator.cube, boundsPosition, boundsRotation)
        CubeInterpolator.SetTarget(interpolator, targetPosition, boundsRotation, currentSec, optDurationSec)
    end,

    LazyMake = function (lump)
        return coroutine.wrap(function ()
            local cubes = lump.cubes
            local interpolators = {}
            local size = lump.size
            local blockSize = lump.blockSize
            for i = 1, size do
                BinarySearchInsert(interpolators, i - 1, CubeInterpolator.Make(cubes[i]), function (a, b)
                    return a.cube.distance < b.cube.distance
                end)

                if i < size and i % blockSize == 0 then
                    coroutine.yield()
                end
            end

            -- make primary block iterators.
            local primaryBlockIterator = RingIterator.Make(interpolators, 1, blockSize)
            coroutine.yield()

            -- make secondary block.
            local secondaryBlockSize = size - blockSize
            local secondaryQueue = cytanb.CreateCircularQueue(secondaryBlockSize)
            local secondaryProcessingQueue = cytanb.CreateCircularQueue(blockSize)
            local secondaryRestQueue = cytanb.CreateCircularQueue(secondaryBlockSize)

            for i = blockSize + 1, size do
                secondaryQueue.Offer(interpolators[i])
                if i < size and i % blockSize == 0 then
                    coroutine.yield()
                end
            end

            return {
                interpolators = interpolators,
                size = size,
                blockSize = blockSize,
                boundsItem = lump.boundsItem,
                primaryBlockIterator = primaryBlockIterator,
                positionChangedSec = 0,
                secondaryQueue = secondaryQueue,
                secondaryProcessingQueue = secondaryProcessingQueue,
                secondaryRestQueue = secondaryRestQueue,
                operationStartTime = vci.me.UnscaledTime,
                operationCount = 0,
            }
        end)
    end,

    ProcessPrimaryBlock = function (self, boundsPosition, boundsRotation, currentSec)
        local iterator = self.primaryBlockIterator
        local blockSize = self.blockSize
        local headIpl = RingIterator.Next(iterator)
        local headPos = CubeInterpolator.IsProcessing(headIpl) and headIpl.targetPosition or headIpl.cube.item.GetPosition()
        local headTargetPosition = TenthCube.TargetPosition(headIpl.cube, boundsPosition, boundsRotation)
        if TenthCube.IsApproximatelySamePosition(headTargetPosition, headPos) then
            -- 先頭のキューブの位置がおよそ同じであった場合。
            if CubeInterpolator.IsProcessing(headIpl) then
                CubeInterpolator.Process(headIpl, currentSec)
                for i = 2, blockSize do
                    local ipl = RingIterator.Next(iterator)
                    CubeInterpolator.Process(ipl, currentSec)
                end
                return blockSize, false
            else
                -- 処理が完了している。
                return 0, false
            end
        else
            -- 先頭のキューブの位置が離れていた場合。
            CubeInterpolator.Process(headIpl, currentSec)
            CubeInterpolator.SetTarget(headIpl, headTargetPosition, boundsRotation, currentSec, CubeInterpolator.PrimaryInterpolationSec)
            for i = 2, blockSize do
                local ipl = RingIterator.Next(iterator)
                CubeInterpolator.Process(ipl, currentSec)
                CubeTransformer.SetInterpolatorTarget(ipl, boundsPosition, boundsRotation, currentSec, CubeInterpolator.PrimaryInterpolationSec)
            end
            return blockSize, true
        end
    end,

    ProcessSecondaryBlock = function (self, boundsPosition, boundsRotation, currentSec)
        local operationCount = 0

        -- rest queue.
        while not self.secondaryRestQueue.IsEmpty() do
            local ipl = self.secondaryRestQueue.Poll()
            if ipl.startSec < self.positionChangedSec then
                -- 位置が変更されたので、キューに返す。
                self.secondaryQueue.Offer(ipl)
                operationCount = operationCount + 1
                if operationCount >= self.blockSize then
                    return operationCount
                end
            else
                -- そのまま rest に戻して break。1つだけ検査すれば十分。
                self.secondaryRestQueue.Offer(ipl)
                break
            end
        end

        -- processing queue.
        for i = 1, self.secondaryProcessingQueue.Size() do
            local ipl = self.secondaryProcessingQueue.Poll()
            CubeInterpolator.Process(ipl, currentSec)

            if ipl.startSec < self.positionChangedSec and ipl.processingSec >= ipl.durationSec * 0.5 then
                -- 位置が変更されたので、キューに返す。
                self.secondaryQueue.Offer(ipl)
            elseif CubeInterpolator.IsProcessing(ipl) then
                -- 処理続行。
                self.secondaryProcessingQueue.Offer(ipl)
            else
                -- 処理を終えた。
                self.secondaryRestQueue.Offer(ipl)
            end

            operationCount = operationCount + 1
            if operationCount >= self.blockSize then
                return operationCount
            end
        end

        -- 新しく処理する対象を選択する。
        if not self.secondaryProcessingQueue.IsFull() and not self.secondaryQueue.IsEmpty() then
            local sizeRatio = self.secondaryQueue.Size() / (self.secondaryProcessingQueue.MaxSize() - self.secondaryProcessingQueue.Size())
            local maxTrials = math.floor(sizeRatio)
            local remain = maxTrials >= 2 and 1 or 0
            while not self.secondaryProcessingQueue.IsFull() and not self.secondaryQueue.IsEmpty() do
                local ipl = self.secondaryQueue.Poll()
                if remain <= 0 or math.random(0, remain) == 0 then
                    CubeTransformer.SetInterpolatorTarget(ipl, boundsPosition, boundsRotation, currentSec)
                    self.secondaryProcessingQueue.Offer(ipl)
                    remain = maxTrials
                    operationCount = operationCount + 1
                    if operationCount >= self.blockSize then
                        return operationCount
                    end
                else
                    -- 再試行
                    self.secondaryQueue.Offer(ipl)
                    remain = remain - 1
                end
            end
        end

        return operationCount
    end,

    Update = function (self)
        local boundsItem = self.boundsItem
        local boundsPosition = boundsItem.GetPosition()
        local boundsRotation = boundsItem.GetRotation()
        local currentSec = vci.me.UnscaledTime.TotalSeconds

        local primaryOperationCount, positionChanged = CubeTransformer.ProcessPrimaryBlock(self, boundsPosition, boundsRotation, currentSec)
        if positionChanged then
            self.positionChangedSec = currentSec
        end

        self.operationCount = self.operationCount
            + primaryOperationCount
            + CubeTransformer.ProcessSecondaryBlock(self, boundsPosition, boundsRotation, currentSec)

        if settings.enableDebugging then
            local now = vci.me.UnscaledTime
            local odt = (now - self.operationStartTime).TotalSeconds
            if odt >= 10 then
                cytanb.LogTrace('transform operation rate: ', cytanb.Round(self.operationCount / odt, 2), ' [op/sec]')
                self.operationStartTime = now
                self.operationCount = 0
            end
        end
    end
}

local CubeTeleporter; CubeTeleporter = cytanb.SetConstEach({
    Teleport = function (node, boundsPosition, boundsRotation, currentSec)
        local cube = node.cube
        local targetPosition = TenthCube.TargetPosition(cube, boundsPosition, boundsRotation)
        node.startSec = currentSec
        cube.item.SetPosition(targetPosition)
        cube.item.SetRotation(boundsRotation)
    end,

    LazyMake = function (lump)
        local MakeCubeNode = function (cube)
            return {
                cube = cube,
                startSec = 0
            }
        end

        return coroutine.wrap(function ()
            local cubes = lump.cubes
            local nodes = {}
            local size = lump.size
            local blockSize = lump.blockSize
            for i = 1, size do
                BinarySearchInsert(nodes, i - 1, MakeCubeNode(cubes[i]), function (a, b)
                    return a.cube.distance < b.cube.distance
                end)

                if i < size and i % blockSize == 0 then
                    coroutine.yield()
                end
            end

            -- make primary block iterators.
            local primaryBlockIterator = RingIterator.Make(nodes, 1, blockSize)
            coroutine.yield()

            -- make secondary block.
            local secondaryBlockSize = size - blockSize
            local secondaryRestQueue = cytanb.CreateCircularQueue(secondaryBlockSize)
            local secondaryProcessingQueue = cytanb.CreateCircularQueue(secondaryBlockSize)

            for i = blockSize + 1, size do
                secondaryRestQueue.Offer(nodes[i])
                if i < size and i % blockSize == 0 then
                    coroutine.yield()
                end
            end

            return {
                nodes = nodes,
                size = size,
                blockSize = blockSize,
                boundsItem = lump.boundsItem,
                primaryBlockIterator = primaryBlockIterator,
                positionChangedSec = 0,
                secondaryRestQueue = secondaryRestQueue,
                secondaryProcessingQueue = secondaryProcessingQueue,
                operationStartTime = vci.me.UnscaledTime,
                operationCount = 0,
            }
        end)
    end,

    ProcessPrimaryBlock = function (self, boundsPosition, boundsRotation, currentSec)
        local iterator = self.primaryBlockIterator
        local blockSize = self.blockSize
        local headNode = RingIterator.Next(iterator)
        local headPos = headNode.cube.item.GetPosition()
        local headTargetPosition = TenthCube.TargetPosition(headNode.cube, boundsPosition, boundsRotation)
        if TenthCube.IsApproximatelySamePosition(headTargetPosition, headPos) then
            -- 先頭のキューブの位置がおよそ同じであった場合。
            return 0, false
        else
            -- 先頭のキューブの位置が離れていた場合。
            for i = 1, blockSize do
                local node = RingIterator.Next(iterator)
                CubeTeleporter.Teleport(node, boundsPosition, boundsRotation, currentSec)
            end
            return blockSize, true
        end
    end,

    ProcessSecondaryBlock = function (self, boundsPosition, boundsRotation, currentSec)
        local operationCount = 0

        -- TODO 秒間に処理する個数にあわせて、実装する。現状は仮実装として、1 フレームにつき1個だけ。
        if not self.secondaryRestQueue.IsEmpty() then
            -- rest queue.
            local node = self.secondaryRestQueue.PollLast()
            if node.startSec < self.positionChangedSec then
                -- 位置が変更された。
                CubeTeleporter.Teleport(node, CubeTeleporter.HiddenPosition, boundsRotation, currentSec)
                self.secondaryProcessingQueue.OfferFirst(node)
                operationCount = operationCount + 1
                return operationCount
            else
                -- そのままキューに戻す。
                self.secondaryRestQueue.Offer(node)
            end
        end

        -- processing queue.
        if not self.secondaryProcessingQueue.IsEmpty() then
            local node = self.secondaryProcessingQueue.Poll()
            if node.startSec + CubeTeleporter.IntervalSec < currentSec then
                CubeTeleporter.Teleport(node, boundsPosition, boundsRotation, currentSec)
                self.secondaryRestQueue.Offer(node)
                operationCount = operationCount + 1
            else
                -- そのままキューに戻す。
                self.secondaryProcessingQueue.OfferFirst(node)
            end
        end
        return operationCount
    end,

    Update = function (self)
        local boundsItem = self.boundsItem
        local boundsPosition = boundsItem.GetPosition()
        local boundsRotation = boundsItem.GetRotation()
        local currentSec = vci.me.UnscaledTime.TotalSeconds

        local primaryOperationCount, positionChanged = CubeTeleporter.ProcessPrimaryBlock(self, boundsPosition, boundsRotation, currentSec)
        if positionChanged then
            self.positionChangedSec = currentSec
        end

        self.operationCount = self.operationCount
            + primaryOperationCount
            + CubeTeleporter.ProcessSecondaryBlock(self, boundsPosition, boundsRotation, currentSec)

        if settings.enableDebugging then
            local now = vci.me.UnscaledTime
            local odt = (now - self.operationStartTime).TotalSeconds
            if odt >= 10 then
                cytanb.LogTrace('teleport operation rate: ', cytanb.Round(self.operationCount / odt, 2), ' [op/sec]')
                self.operationStartTime = now
                self.operationCount = 0
            end
        end
    end
}, {
    HiddenPosition = Vector3.__new(0xC00, 0xC00, 0xC00),
    IntervalSec = 5
})

local CubeColorWavelet; CubeColorWavelet = cytanb.SetConstEach({
    LazyMake = function ()
        return coroutine.wrap(function ()
            local size = 0
            local materials = {}
            local originMaterial = nil
            local blockSize = CubeLump.MaxBlockSize
            for k, name in pairs(vci.assets.material.GetNames()) do
                if cytanb.StringStartsWith(name, TenthCube.Prefix) then
                    size = size + 1
                    local mat = CubeMaterial.Make(name)
                    materials[size] = mat
                    if originMaterial then
                        if mat.initialHSV.s > originMaterial.initialHSV.s then
                            originMaterial = mat
                        end
                    else
                        originMaterial = mat
                    end
                end

                if size % blockSize == 0 then
                    coroutine.yield()
                end
            end

            local originHSV = originMaterial and cytanb.Extend({}, originMaterial.initialHSV) or { h = 0, s = 0, v = 0 }

            local ringIterator = RingIterator.Make(materials, 1, size)

            return {
                materials = materials,
                size = size,
                originHSV = originHSV,
                keyHSV = cytanb.Extend({}, originHSV),
                ringIterator = ringIterator,
                startTime = vci.me.UnscaledTime,
                operationStartTime = vci.me.UnscaledTime,
                operationCount = 0,
            }
        end)
    end,

    Update = function (self)
        -- 最大で、1 フレームあたり、1 マテリアルを変更する。
        local now = vci.me.UnscaledTime
        local deltaSec = (now - self.startTime).TotalSeconds

        local material = RingIterator.Next(self.ringIterator)
        local hsv = material.initialHSV
        local h = hsv.h + self.keyHSV.h - self.originHSV.h
        local s = cytanb.PingPong(hsv.s + deltaSec * CubeColorWavelet.WaveletPerSec, 1.0)
        local v = hsv.v + self.keyHSV.v - self.originHSV.v
        if math.abs(material.hsv.s - s) >= CubeColorWavelet.WaveletThreshold then
            CubeMaterial.SetHSV(material, h, s, v)

            if settings.enableDebugging then
                local odt = (now - self.operationStartTime).TotalSeconds
                self.operationCount = self.operationCount + 1
                if odt >= 10 then
                    cytanb.LogTrace('material operation rate: ', cytanb.Round(self.operationCount / odt, 2), ' [op/sec]')
                    self.operationStartTime = now
                    self.operationCount = 0
                end
            end
        end
    end,

    SetKeyHSV = function (self, h, s, v)
        self.keyHSV.h = h
        self.keyHSV.s = s
        self.keyHSV.v = v
    end
}, {
    WaveletPerSec = 0.01,
    WaveletThreshold = 0.01,
})

local CubeRoutine; CubeRoutine = {
    Make = function (optReadyCallback)
        local self; self = {
            lump = nil,
            teleporter = nil,
            colorWavelet = nil,

            _cw = coroutine.wrap(function ()
                local lumpCw = CubeLump.LazyMake()
                while not self.lump do
                    self.lump = lumpCw()
                    coroutine.yield()
                end

                local teleporterCw = CubeTeleporter.LazyMake(self.lump)
                while not self.teleporter do
                    self.teleporter = teleporterCw()
                    coroutine.yield()
                end

                local colorWaveletCw = CubeColorWavelet.LazyMake()
                while not self.colorWavelet do
                    self.colorWavelet = colorWaveletCw()
                    coroutine.yield()
                end

                cytanb.LogInfo('cubes: ', self.lump.size, ', materials: ', self.colorWavelet.size)

                if optReadyCallback then
                    optReadyCallback(self)
                end

                while true do
                    CubeLump.Update(self.lump)
                    CubeTeleporter.Update(self.teleporter)
                    CubeColorWavelet.Update(self.colorWavelet)
                    coroutine.yield()
                end
            end)
        }
        return self
    end,

    Update = function (self)
        self._cw()
    end
}

local MakeStatusParameters = function (routine)
    return {
        senderID = cytanb.ClientID(),
        keyHSV = routine.colorWavelet.keyHSV
    }
end

local routine

local UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        if deltaTime <= TimeSpan.Zero then
            return
        end

        CubeRoutine.Update(routine)
    end,

    function ()
        cytanb.LogTrace('OnLoad')

        routine = CubeRoutine.Make(function ()
            vciLoaded = true

            cytanb.OnMessage(ColorPaletteItemStatusMessageName, function (sender, name, parameterMap)
                local version = parameterMap.version
                if version and version >= ColorPaletteMinMessageVersion and routine.lump.grabbed then
                    -- クリームを掴んでいる場合は、カラーパレットから色情報を取得する
                    local color = cytanb.ColorFromARGB32(parameterMap.argb32)
                    local h, s, v = cytanb.ColorRGBToHSV(color)
                    local keyHSV = routine.colorWavelet.keyHSV
                    if keyHSV.h ~= h or keyHSV.s ~= s or keyHSV.v ~= v then
                        cytanb.LogDebug('on palette color: ', color)
                        CubeColorWavelet.SetKeyHSV(routine.colorWavelet, h, s, v)
                        cytanb.EmitMessage(statusMessageName, MakeStatusParameters(routine))
                    end
                end
            end)

            cytanb.OnInstanceMessage(queryStatusMessageName, function (sender, name, parameterMap)
                if vci.assets.IsMine then
                    -- マスターのみ応答する
                    cytanb.EmitMessage(statusMessageName, MakeStatusParameters(routine))
                end
            end)

            cytanb.OnInstanceMessage(statusMessageName, function (sender, name, parameterMap)
                if parameterMap.senderID ~= cytanb.ClientID() then
                    cytanb.LogTrace('on lump status message')
                    local keyHSV = parameterMap.keyHSV
                    if keyHSV then
                        CubeColorWavelet.SetKeyHSV(routine.colorWavelet, keyHSV.h, keyHSV.s, keyHSV.v)
                    end
                end
            end)

            -- 現在のステータスを問い合わせる。
            cytanb.EmitMessage(queryStatusMessageName)
        end)
    end
)

updateAll = function ()
    UpdateCw()
end

onGrab = function (target)
    if not vciLoaded then
        return
    end

    if target == CubeLump.BoundsName then
        CubeLump.Grab(routine.lump)
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    if target == CubeLump.BoundsName then
        CubeLump.Ungrab(routine.lump)
    end
end
