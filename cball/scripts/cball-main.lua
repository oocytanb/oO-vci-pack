-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g;local h;local i;local j;local k=false;local l;local m;local n;local a;local o=function(p,q)local r=p+q-1;return p,r,r+1 end;local s=function(p,q)local r=p-q+1;return r,p,r-1 end;local t=function(u,v,w,p,x)local y=w.searchMap;for z,q in pairs(w.lengthList)do if q<=0 then error('SearchPattern: Invalid parameter: searchLen <= 0')else local A,B,r=x(p,q)if A>=1 and B<=v then local C=string.sub(u,A,B)if y[C]then return true,q,r end end end end;return false,-1,-1 end;local D=function(u,w,p,x)if u==nil or w==nil then return false,-1 end;if w.hasEmptySearch then return true,0 end;local v=string.len(u)local E=w.repeatMin;local F=w.repeatMax;local G=F<0;local H=p;local I=0;local J=0;while G or J<F do local K,L,r=t(u,v,w,H,x)if K then if L<=0 then error('SearchPattern: Invalid parameter')end;H=r;I=I+L;J=J+1 else break end end;if J>=E then return true,I else return false,-1 end end;local M=function(u,N,p,O,x,P)if u==nil or N==nil then return false,-1 end;local q=string.len(N)if O then local K=P(u,N)return K,K and q or-1 else if q==0 then return true,q end;local v=string.len(u)local A,B=x(p,q)if A>=1 and B<=v then local C=string.sub(u,A,B)local K=P(C,N)return K,K and q or-1 else return false,-1 end end end;local Q=function(R,S)for T=1,4 do local U=R[T]-S[T]if U~=0 then return U end end;return 0 end;local V;V={__eq=function(R,S)return R[1]==S[1]and R[2]==S[2]and R[3]==S[3]and R[4]==S[4]end,__lt=function(R,S)return Q(R,S)<0 end,__le=function(R,S)return Q(R,S)<=0 end,__tostring=function(W)local X=W[2]or 0;local Y=W[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(W[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(X,16),0xFFFF),bit32.band(X,0xFFFF),bit32.band(bit32.rshift(Y,16),0xFFFF),bit32.band(Y,0xFFFF),bit32.band(W[4]or 0,0xFFFFFFFF))end,__concat=function(R,S)local Z=getmetatable(R)local _=Z==V or type(Z)=='table'and Z.__concat==V.__concat;local a0=getmetatable(S)local a1=a0==V or type(a0)=='table'and a0.__concat==V.__concat;if not _ and not a1 then error('UUID: attempt to concatenate illegal values',2)end;return(_ and V.__tostring(R)or R)..(a1 and V.__tostring(S)or S)end}local a2='__CYTANB_CONST_VARIABLES'local a3=function(table,a4)local a5=getmetatable(table)if a5 then local a6=rawget(a5,a2)if a6 then local a7=rawget(a6,a4)if type(a7)=='function'then return a7(table,a4)else return a7 end end end;return nil end;local a8=function(table,a4,a9)local a5=getmetatable(table)if a5 then local a6=rawget(a5,a2)if a6 then if rawget(a6,a4)~=nil then error('Cannot assign to read only field "'..a4 ..'"',2)end end end;rawset(table,a4,a9)end;local aa=function(ab,ac)local ad=ab[a.TypeParameterName]if a.NillableHasValue(ad)and a.NillableValue(ad)~=ac then return false,false end;return a.NillableIfHasValueOrElse(h[ac],function(ae)local af=ae.compositionFieldNames;local ag=ae.compositionFieldLength;local ah=false;for ai,a9 in pairs(ab)do if af[ai]then ag=ag-1;if ag<=0 and ah then break end elseif ai~=a.TypeParameterName then ah=true;if ag<=0 then break end end end;return ag<=0,ah end,function()return false,false end)end;local aj=function(u)return a.StringReplace(a.StringReplace(u,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local ak=function(u,al)local am=string.len(u)local an=string.len(a.EscapeSequenceTag)if an>am then return u end;local ao=''local T=1;while T<am do local B,ap=string.find(u,a.EscapeSequenceTag,T,true)if not B then if T==1 then ao=u else ao=ao..string.sub(u,T)end;break end;if B>T then ao=ao..string.sub(u,T,B-1)end;local aq=false;for ar,as in ipairs(g)do local K=a.StringStartsWith(u,as.search,B)if K then ao=ao..(al and al(as.tag)or as.replacement)T=B+string.len(as.search)aq=true;break end end;if not aq then ao=ao..a.EscapeSequenceTag;T=ap+1 end end;return ao end;local at;at=function(au,av)if type(au)~='table'then return au end;if not av then av={}end;if av[au]then error('circular reference')end;av[au]=true;local aw={}for ai,a9 in pairs(au)do local ax=type(ai)local ay;if ax=='string'then ay=aj(ai)elseif ax=='number'then ay=tostring(ai)..a.ArrayNumberTag else ay=ai end;local az=type(a9)if az=='string'then aw[ay]=aj(a9)elseif az=='number'and a9<0 then aw[tostring(ay)..a.NegativeNumberTag]=tostring(a9)else aw[ay]=at(a9,av)end end;av[au]=nil;return aw end;local aA;aA=function(aw,aB)if type(aw)~='table'then return aw end;local au={}for ai,a9 in pairs(aw)do local ay;local aC=false;if type(ai)=='string'then local aD=false;ay=ak(ai,function(aE)if aE==a.NegativeNumberTag then aC=true elseif aE==a.ArrayNumberTag then aD=true end;return nil end)if aD then ay=tonumber(ay)or ay end else ay=ai;aC=false end;if aC and type(a9)=='string'then au[ay]=tonumber(a9)elseif type(a9)=='string'then au[ay]=ak(a9,function(aE)return i[aE]end)else au[ay]=aA(a9,aB)end end;if not aB then a.NillableIfHasValue(au[a.TypeParameterName],function(aF)a.NillableIfHasValue(h[aF],function(ae)local aG,ah=ae.fromTableFunc(au)if not ah then a.NillableIfHasValue(aG,function(W)au=W end)end end)end)end;return au end;local aH={['nil']=function(aI)return nil end,['number']=function(aI)return tonumber(aI)end,['string']=function(aI)return tostring(aI)end,['boolean']=function(aI)if aI then return true else return false end end}local aJ=function(aI,aK)local aL=type(aI)if aL==aK then return aI else local aM=aH[aK]if aM then return aM(aI)else return nil end end end;local aN=function(aO,aP)if aP and type(aP)=='table'then local aQ={}for a4,aI in pairs(aO)do local aR=aP[a4]local aS;if aR==nil then aS=aI else local aT=aJ(aR,type(aI))if aT==nil then aS=aI else aS=aT end end;aQ[a4]=aS end;aQ[a.MessageOriginalSender]=aO;return aQ else return aO end end;a={InstanceID=function()if m==''then m=vci.state.Get(b)or''end;return m end,NillableHasValue=function(aU)return aU~=nil end,NillableValue=function(aU)if aU==nil then error('nillable: value is nil',2)end;return aU end,NillableValueOrDefault=function(aU,aV)if aU==nil then if aV==nil then error('nillable: defaultValue is nil',2)end;return aV else return aU end end,NillableIfHasValue=function(aU,aW)if aU==nil then return nil else return aW(aU)end end,NillableIfHasValueOrElse=function(aU,aW,aX)if aU==nil then return aX()else return aW(aU)end end,MakeSearchPattern=function(aY,aZ,a_)local E=aZ and math.floor(aZ)or 1;if E<0 then error('SearchPattern: Invalid parameter: optRepeatMin < 0')end;local F=a_ and math.floor(a_)or E;if F>=0 and F<E then error('SearchPattern: Invalid parameter: repeatMax < repeatMin')end;local b0=F==0;local y={}local b1={}local b2={}local b3=0;for b4,b5 in pairs(aY)do local q=string.len(b5)if q==0 then b0=true else y[b5]=q;if not b1[q]then b1[q]=true;b3=b3+1;b2[b3]=q end end end;table.sort(b2,function(b6,K)return b6>K end)return{hasEmptySearch=b0,searchMap=y,lengthList=b2,repeatMin=E,repeatMax=F}end,StringStartsWith=function(u,N,b7)local H=b7 and math.max(1,math.floor(b7))or 1;if type(N)=='table'then return D(u,N,H,o)else return M(u,N,H,H==1,o,string.startsWith)end end,StringEndsWith=function(u,N,b8)if u==nil then return false,-1 end;local v=string.len(u)local H=b8 and math.min(v,math.floor(b8))or v;if type(N)=='table'then return D(u,N,H,s)else return M(u,N,H,H==v,s,string.endsWith)end end,StringTrimStart=function(u,b9)if u==nil or u==''then return u end;local K,L=a.StringStartsWith(u,b9 or c)if K and L>=1 then return string.sub(u,L+1)else return u end end,StringTrimEnd=function(u,b9)if u==nil or u==''then return u end;local K,L=a.StringEndsWith(u,b9 or c)if K and L>=1 then return string.sub(u,1,string.len(u)-L)else return u end end,StringTrim=function(u,b9)return a.StringTrimEnd(a.StringTrimStart(u,b9),b9)end,StringReplace=function(u,ba,bb)local bc;local am=string.len(u)if ba==''then bc=bb;for T=1,am do bc=bc..string.sub(u,T,T)..bb end else bc=''local T=1;while true do local A,B=string.find(u,ba,T,true)if A then bc=bc..string.sub(u,T,A-1)..bb;T=B+1;if T>am then break end else bc=T==1 and u or bc..string.sub(u,T)break end end end;return bc end,SetConst=function(ba,bd,W)if type(ba)~='table'then error('Cannot set const to non-table target',2)end;local be=getmetatable(ba)local a5=be or{}local bf=rawget(a5,a2)if rawget(ba,bd)~=nil then error('Non-const field "'..bd..'" already exists',2)end;if not bf then bf={}rawset(a5,a2,bf)a5.__index=a3;a5.__newindex=a8 end;rawset(bf,bd,W)if not be then setmetatable(ba,a5)end;return ba end,
SetConstEach=function(ba,bg)for ai,a9 in pairs(bg)do a.SetConst(ba,ai,a9)end;return ba end,Extend=function(ba,bh,bi,bj,av)if ba==bh or type(ba)~='table'or type(bh)~='table'then return ba end;if bi then if not av then av={}end;if av[bh]then error('circular reference')end;av[bh]=true end;for ai,a9 in pairs(bh)do if bi and type(a9)=='table'then local bk=ba[ai]ba[ai]=a.Extend(type(bk)=='table'and bk or{},a9,bi,bj,av)else ba[ai]=a9 end end;if not bj then local bl=getmetatable(bh)if type(bl)=='table'then if bi then local bm=getmetatable(ba)setmetatable(ba,a.Extend(type(bm)=='table'and bm or{},bl,true))else setmetatable(ba,bl)end end end;if bi then av[bh]=nil end;return ba end,Vars=function(a9,bn,bo,av)local bp;if bn then bp=bn~='__NOLF'else bn='  'bp=true end;if not bo then bo=''end;if not av then av={}end;local bq=type(a9)if bq=='table'then av[a9]=av[a9]and av[a9]+1 or 1;local br=bp and bo..bn or''local u='('..tostring(a9)..') {'local bs=true;for a4,aI in pairs(a9)do if bs then bs=false else u=u..(bp and','or', ')end;if bp then u=u..'\n'..br end;if type(aI)=='table'and av[aI]and av[aI]>0 then u=u..a4 ..' = ('..tostring(aI)..')'else u=u..a4 ..' = '..a.Vars(aI,bn,br,av)end end;if not bs and bp then u=u..'\n'..bo end;u=u..'}'av[a9]=av[a9]-1;if av[a9]<=0 then av[a9]=nil end;return u elseif bq=='function'or bq=='thread'or bq=='userdata'then return'('..bq..')'elseif bq=='string'then return'('..bq..') '..string.format('%q',a9)else return'('..bq..') '..tostring(a9)end end,GetLogLevel=function()return j end,SetLogLevel=function(bt)j=bt end,IsOutputLogLevelEnabled=function()return k end,SetOutputLogLevelEnabled=function(bu)k=not not bu end,Log=function(bt,...)if bt<=j then local bv=k and(l[bt]or'LOG LEVEL '..tostring(bt))..' | 'or''local bw=table.pack(...)if bw.n==1 then local a9=bw[1]if a9~=nil then local u=type(a9)=='table'and a.Vars(a9)or tostring(a9)print(k and bv..u or u)else print(bv)end else local u=bv;for T=1,bw.n do local a9=bw[T]if a9~=nil then u=u..(type(a9)=='table'and a.Vars(a9)or tostring(a9))end end;print(u)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(bx,by)local bz={}if by==nil then for ai,a9 in pairs(bx)do bz[a9]=a9 end elseif type(by)=='function'then for ai,a9 in pairs(bx)do local bA,bB=by(a9)bz[bA]=bB end else for ai,a9 in pairs(bx)do bz[a9]=by end end;return bz end,Round=function(bC,bD)if bD then local bE=10^bD;return math.floor(bC*bE+0.5)/bE else return math.floor(bC+0.5)end end,Clamp=function(W,bF,bG)return math.max(bF,math.min(W,bG))end,Lerp=function(b6,K,bq)if bq<=0.0 then return b6 elseif bq>=1.0 then return K else return b6+(K-b6)*bq end end,LerpUnclamped=function(b6,K,bq)if bq==0.0 then return b6 elseif bq==1.0 then return K else return b6+(K-b6)*bq end end,PingPong=function(bq,bH)if bH==0 then return 0,1 end;local bI=math.floor(bq/bH)local bJ=bq-bI*bH;if bI<0 then if(bI+1)%2==0 then return bH-bJ,-1 else return bJ,1 end else if bI%2==0 then return bJ,1 else return bH-bJ,-1 end end end,VectorApproximatelyEquals=function(bK,bL)return(bK-bL).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(bK,bL)local bM=Quaternion.Dot(bK,bL)return bM<1.0+1E-06 and bM>1.0-1E-06 end,QuaternionToAngleAxis=function(bN)local bI=bN.normalized;local bO=math.acos(bI.w)local bP=math.sin(bO)local bQ=math.deg(bO*2.0)local bR;if math.abs(bP)<=Quaternion.kEpsilon then bR=Vector3.right else local A=1.0/bP;bR=Vector3.__new(bI.x*A,bI.y*A,bI.z*A)end;return bQ,bR end,QuaternionTwist=function(bN,bS)if bS.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local bT=Vector3.__new(bN.x,bN.y,bN.z)if bT.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local bU=Vector3.Project(bT,bS)if bU.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local bV=Quaternion.__new(bU.x,bU.y,bU.z,bN.w)bV.Normalize()return bV else return Quaternion.AngleAxis(0,bS)end else local bW=a.QuaternionToAngleAxis(bN)return Quaternion.AngleAxis(bW,bS)end end,ApplyQuaternionToVector3=function(bN,bX)local bY=bN.w*bX.x+bN.y*bX.z-bN.z*bX.y;local bZ=bN.w*bX.y-bN.x*bX.z+bN.z*bX.x;local b_=bN.w*bX.z+bN.x*bX.y-bN.y*bX.x;local c0=-bN.x*bX.x-bN.y*bX.y-bN.z*bX.z;return Vector3.__new(c0*-bN.x+bY*bN.w+bZ*-bN.z-b_*-bN.y,c0*-bN.y-bY*-bN.z+bZ*bN.w+b_*-bN.x,c0*-bN.z+bY*-bN.y-bZ*-bN.x+b_*bN.w)end,RotateAround=function(c1,c2,c3,c4)return c3+c4*(c1-c3),c4*c2 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(c5)return V.__tostring(c5)end,UUIDFromNumbers=function(...)local c6=...local bq=type(c6)local c7,c8,c9,ca;if bq=='table'then c7=c6[1]c8=c6[2]c9=c6[3]ca=c6[4]else c7,c8,c9,ca=...end;local c5={bit32.band(c7 or 0,0xFFFFFFFF),bit32.band(c8 or 0,0xFFFFFFFF),bit32.band(c9 or 0,0xFFFFFFFF),bit32.band(ca or 0,0xFFFFFFFF)}setmetatable(c5,V)return c5 end,UUIDFromString=function(u)local am=string.len(u)if am==32 then local c5=a.UUIDFromNumbers(0,0,0,0)for T=1,4 do local A=1+(T-1)*8;if not a.StringStartsWith(u,e,A)then return nil end;c5[T]=tonumber(string.sub(u,A,A+7),16)end;return c5 elseif am==36 then if not a.StringStartsWith(u,e,1)then return nil end;local c7=tonumber(string.sub(u,1,8),16)if not a.StringStartsWith(u,'-',9)or not a.StringStartsWith(u,d,10)or not a.StringStartsWith(u,'-',14)or not a.StringStartsWith(u,d,15)then return nil end;local c8=tonumber(string.sub(u,10,13)..string.sub(u,15,18),16)if not a.StringStartsWith(u,'-',19)or not a.StringStartsWith(u,d,20)or not a.StringStartsWith(u,'-',24)or not a.StringStartsWith(u,d,25)then return nil end;local c9=tonumber(string.sub(u,20,23)..string.sub(u,25,28),16)if not a.StringStartsWith(u,e,29)then return nil end;local ca=tonumber(string.sub(u,29),16)return a.UUIDFromNumbers(c7,c8,c9,ca)else return nil end end,ParseUUID=function(u)return a.UUIDFromString(u)end,CreateCircularQueue=function(cb)if type(cb)~='number'or cb<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(cb),2)end;local self;local cc=math.floor(cb)local ao={}local cd=0;local ce=0;local cf=0;self={Size=function()return cf end,Clear=function()cd=0;ce=0;cf=0 end,IsEmpty=function()return cf==0 end,Offer=function(cg)ao[cd+1]=cg;cd=(cd+1)%cc;if cf<cc then cf=cf+1 else ce=(ce+1)%cc end;return true end,OfferFirst=function(cg)ce=(cc+ce-1)%cc;ao[ce+1]=cg;if cf<cc then cf=cf+1 else cd=(cc+cd-1)%cc end;return true end,Poll=function()if cf==0 then return nil else local cg=ao[ce+1]ce=(ce+1)%cc;cf=cf-1;return cg end end,PollLast=function()if cf==0 then return nil else cd=(cc+cd-1)%cc;local cg=ao[cd+1]cf=cf-1;return cg end end,Peek=function()if cf==0 then return nil else return ao[ce+1]end end,PeekLast=function()if cf==0 then return nil else return ao[(cc+cd-1)%cc+1]end end,Get=function(ch)if ch<1 or ch>cf then a.LogError('CreateCircularQueue.Get: index is outside the range: '..ch)return nil end;return ao[(ce+ch-1)%cc+1]end,IsFull=function()return cf>=cc end,MaxSize=function()return cc end}return self end,DetectClicks=function(ci,cj,ck)local cl=ci or 0;local cm=ck or TimeSpan.FromMilliseconds(500)local cn=vci.me.Time;local co=cj and cn>cj+cm and 1 or cl+1;return co,cn end,ColorRGBToHSV=function(cp)local bJ=math.max(0.0,math.min(cp.r,1.0))local cq=math.max(0.0,math.min(cp.g,1.0))local K=math.max(0.0,math.min(cp.b,1.0))local bG=math.max(bJ,cq,K)local bF=math.min(bJ,cq,K)local cr=bG-bF;local a7;if cr==0.0 then a7=0.0 elseif bG==bJ then a7=(cq-K)/cr/6.0 elseif bG==cq then a7=(2.0+(K-bJ)/cr)/6.0 else a7=(4.0+(bJ-cq)/cr)/6.0 end;if a7<0.0 then a7=a7+1.0 end;local cs=bG==0.0 and cr or cr/bG;local a9=bG;return a7,cs,a9 end,ColorFromARGB32=function(ct)local cu=type(ct)=='number'and ct or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(cu,16),0xFF)/0xFF,bit32.band(bit32.rshift(cu,8),0xFF)/0xFF,bit32.band(cu,0xFF)/0xFF,bit32.band(bit32.rshift(cu,24),0xFF)/0xFF)end,ColorToARGB32=function(cp)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*cp.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*cp.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*cp.g),0xFF),8),bit32.band(a.Round(0xFF*cp.b),0xFF))end,ColorFromIndex=function(cv,cw,cx,cy,cz)local cA=math.max(math.floor(cw or a.ColorHueSamples),1)local cB=cz and cA or cA-1;local cC=math.max(math.floor(cx or a.ColorSaturationSamples),1)local cD=math.max(math.floor(cy or a.ColorBrightnessSamples),1)local ch=a.Clamp(math.floor(cv or 0),0,cA*cC*cD-1)local cE=ch%cA;local cF=math.floor(ch/cA)local A=cF%cC;local cG=math.floor(cF/cC)if cz or cE~=cB then local a7=cE/cB;local cs=(cC-A)/cC;local a9=(cD-cG)/cD;return Color.HSVToRGB(a7,cs,a9)else local a9=(cD-cG)/cD*A/(cC-1)return Color.HSVToRGB(0.0,0.0,a9)end end,
ColorToIndex=function(cp,cw,cx,cy,cz)local cA=math.max(math.floor(cw or a.ColorHueSamples),1)local cB=cz and cA or cA-1;local cC=math.max(math.floor(cx or a.ColorSaturationSamples),1)local cD=math.max(math.floor(cy or a.ColorBrightnessSamples),1)local a7,cs,a9=a.ColorRGBToHSV(cp)local A=a.Round(cC*(1.0-cs))if cz or A<cC then local cH=a.Round(cB*a7)if cH>=cB then cH=0 end;if A>=cC then A=cC-1 end;local cG=math.min(cD-1,a.Round(cD*(1.0-a9)))return cH+cA*(A+cC*cG)else local cI=a.Round((cC-1)*a9)if cI==0 then local cJ=a.Round(cD*(1.0-a9))if cJ>=cD then return cA-1 else return cA*(1+a.Round(a9*(cC-1)/(cD-cJ)*cD)+cC*cJ)-1 end else return cA*(1+cI+cC*a.Round(cD*(1.0-a9*(cC-1)/cI)))-1 end end end,ColorToTable=function(cp)return{[a.TypeParameterName]=a.ColorTypeName,r=cp.r,g=cp.g,b=cp.b,a=cp.a}end,ColorFromTable=function(ab)local K,ah=aa(ab,a.ColorTypeName)return K and Color.__new(ab.r,ab.g,ab.b,ab.a)or nil,ah end,Vector2ToTable=function(W)return{[a.TypeParameterName]=a.Vector2TypeName,x=W.x,y=W.y}end,Vector2FromTable=function(ab)local K,ah=aa(ab,a.Vector2TypeName)return K and Vector2.__new(ab.x,ab.y)or nil,ah end,Vector3ToTable=function(W)return{[a.TypeParameterName]=a.Vector3TypeName,x=W.x,y=W.y,z=W.z}end,Vector3FromTable=function(ab)local K,ah=aa(ab,a.Vector3TypeName)return K and Vector3.__new(ab.x,ab.y,ab.z)or nil,ah end,Vector4ToTable=function(W)return{[a.TypeParameterName]=a.Vector4TypeName,x=W.x,y=W.y,z=W.z,w=W.w}end,Vector4FromTable=function(ab)local K,ah=aa(ab,a.Vector4TypeName)return K and Vector4.__new(ab.x,ab.y,ab.z,ab.w)or nil,ah end,QuaternionToTable=function(W)return{[a.TypeParameterName]=a.QuaternionTypeName,x=W.x,y=W.y,z=W.z,w=W.w}end,QuaternionFromTable=function(ab)local K,ah=aa(ab,a.QuaternionTypeName)return K and Quaternion.__new(ab.x,ab.y,ab.z,ab.w)or nil,ah end,TableToSerializable=function(au)return at(au)end,TableFromSerializable=function(aw,aB)return aA(aw,aB)end,TableToSerialiable=function(au)return at(au)end,TableFromSerialiable=function(aw,aB)return aA(aw,aB)end,EmitMessage=function(bd,cK)local aw=a.NillableIfHasValueOrElse(cK,function(au)if type(au)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(au)end,function()return{}end)aw[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(bd,json.serialize(aw))end,OnMessage=function(bd,aW)local aM=function(aO,cL,cM)if type(cM)=='string'and string.startsWith(cM,'{')then local cN,aw=pcall(json.parse,cM)if cN and type(aw)=='table'and aw[a.InstanceIDParameterName]then local cO=a.TableFromSerializable(aw)aW(aN(aO,cO[a.MessageSenderOverride]),cL,cO)return end end;aW(aO,cL,{[a.MessageValueParameterName]=cM})end;vci.message.On(bd,aM)return{Off=function()if aM then aM=nil end end}end,OnInstanceMessage=function(bd,aW)local aM=function(aO,cL,cK)local cP=a.InstanceID()if cP~=''and cP==cK[a.InstanceIDParameterName]then aW(aO,cL,cK)end end;return a.OnMessage(bd,aM)end,EmitCommentMessage=function(cM,aP)local cQ={type='comment',name='',commentSource=''}local cK={[a.MessageValueParameterName]=tostring(cM),[a.MessageSenderOverride]=type(aP)=='table'and a.Extend(cQ,aP,true)or cQ}a.EmitMessage('comment',cK)end,OnCommentMessage=function(aW)local aM=function(aO,cL,cK)local cM=tostring(cK[a.MessageValueParameterName]or'')aW(aO,cL,cM)end;return a.OnMessage('comment',aM)end,EmitNotificationMessage=function(cM,aP)local cQ={type='notification',name='',commentSource=''}local cK={[a.MessageValueParameterName]=tostring(cM),[a.MessageSenderOverride]=type(aP)=='table'and a.Extend(cQ,aP,true)or cQ}a.EmitMessage('notification',cK)end,OnNotificationMessage=function(aW)local aM=function(aO,cL,cK)local cM=tostring(cK[a.MessageValueParameterName]or'')aW(aO,cL,cM)end;return a.OnMessage('notification',aM)end,GetEffekseerEmitterMap=function(bd)local cR=vci.assets.GetEffekseerEmitters(bd)if not cR then return nil end;local bz={}for T,cS in pairs(cR)do bz[cS.EffectName]=cS end;return bz end,ClientID=function()return n end,ParseTagString=function(u)local cT=string.find(u,'#',1,true)if not cT then return{},u end;local cU={}local cV=string.sub(u,1,cT-1)cT=cT+1;local am=string.len(u)while cT<=am do local cW,cX=a.StringStartsWith(u,f,cT)if cW then local cY=cT+cX;local cZ=string.sub(u,cT,cY-1)local c_=cZ;cT=cY;if cT<=am and a.StringStartsWith(u,'=',cT)then cT=cT+1;local d0,d1=a.StringStartsWith(u,f,cT)if d0 then local d2=cT+d1;c_=string.sub(u,cT,d2-1)cT=d2 else c_=''end end;cU[cZ]=c_ end;cT=string.find(u,'#',cT,true)if not cT then break end;cT=cT+1 end;return cU,cV end,CalculateSIPrefix=(function()local d3=9;local d4={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local d5=#d4;return function(bC)local d6=bC==0 and 0 or a.Clamp(math.floor(math.log(math.abs(bC),1000)),1-d3,d5-d3)return d6==0 and bC or bC/1000^d6,d4[d3+d6],d6*3 end end)(),CreateLocalSharedProperties=function(d7,d8)local d9=TimeSpan.FromSeconds(5)local da='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local db='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(d7)~='string'or string.len(d7)<=0 or type(d8)~='string'or string.len(d8)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local dc=_G[da]if not dc then dc={}_G[da]=dc end;dc[d8]=vci.me.UnscaledTime;local dd=_G[d7]if not dd then dd={[db]={}}_G[d7]=dd end;local de=dd[db]local self;self={GetLspID=function()return d7 end,GetLoadID=function()return d8 end,GetProperty=function(a4,aV)local W=dd[a4]if W==nil then return aV else return W end end,SetProperty=function(a4,W)if a4==db then error('LocalSharedProperties: Invalid argument: key = ',a4,2)end;local cn=vci.me.UnscaledTime;local df=dd[a4]dd[a4]=W;for dg,cP in pairs(de)do local bq=dc[cP]if bq and bq+d9>=cn then dg(self,a4,W,df)else dg(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)de[dg]=nil;dc[cP]=nil end end end,Clear=function()for a4,W in pairs(dd)do if a4~=db then self.SetProperty(a4,nil)end end end,Each=function(aW)for a4,W in pairs(dd)do if a4~=db and aW(W,a4,self)==false then return false end end end,AddListener=function(dg)de[dg]=d8 end,RemoveListener=function(dg)de[dg]=nil end,UpdateAlive=function()dc[d8]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(dh)local di=1.0;local dj=1000.0;local dk=TimeSpan.FromSeconds(0.02)local dl=0xFFFF;local dm=a.CreateCircularQueue(64)local dn=TimeSpan.FromSeconds(5)local dp=TimeSpan.FromSeconds(30)local dq=false;local dr=vci.me.Time;local ds=a.Random32()local dt=Vector3.__new(bit32.bor(0x400,bit32.band(ds,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(ds,16),0x1FFF)),0.0)dh.SetPosition(dt)dh.SetRotation(Quaternion.identity)dh.SetVelocity(Vector3.zero)dh.SetAngularVelocity(Vector3.zero)dh.AddForce(Vector3.__new(0.0,0.0,di*dj))local self={Timestep=function()return dk end,Precision=function()return dl end,IsFinished=function()return dq end,Update=function()if dq then return dk end;local du=vci.me.Time-dr;local dv=du.TotalSeconds;if dv<=Vector3.kEpsilon then return dk end;local dw=dh.GetPosition().z-dt.z;local dx=dw/dv;local dy=dx/dj;if dy<=Vector3.kEpsilon then return dk end;dm.Offer(dy)local dz=dm.Size()if dz>=2 and du>=dn then local dA=0.0;for T=1,dz do dA=dA+dm.Get(T)end;local dB=dA/dz;local dC=0.0;for T=1,dz do dC=dC+(dm.Get(T)-dB)^2 end;local dD=dC/dz;if dD<dl then dl=dD;dk=TimeSpan.FromSeconds(dB)end;if du>dp then dq=true;dh.SetPosition(dt)dh.SetRotation(Quaternion.identity)dh.SetVelocity(Vector3.zero)dh.SetAngularVelocity(Vector3.zero)end else dk=TimeSpan.FromSeconds(dy)end;return dk end}return self end,AlignSubItemOrigin=function(dE,dF,dG)local dH=dE.GetRotation()if not a.QuaternionApproximatelyEquals(dF.GetRotation(),dH)then dF.SetRotation(dH)end;local dI=dE.GetPosition()if not a.VectorApproximatelyEquals(dF.GetPosition(),dI)then dF.SetPosition(dI)end;if dG then dF.SetVelocity(Vector3.zero)dF.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local dJ={}local self;self={Contains=function(dK,dL)return a.NillableIfHasValueOrElse(dJ[dK],function(bg)return a.NillableHasValue(bg[dL])end,function()return false end)end,Add=function(dK,dM,dG)if not dK or not dM then local dN='SubItemGlue.Add: Invalid arguments '..(not dK and', parent = '..tostring(dK)or'')..(not dM and', children = '..tostring(dM)or'')error(dN,2)end;local bg=a.NillableIfHasValueOrElse(dJ[dK],function(dO)return dO end,function()local dO={}dJ[dK]=dO;return dO end)if type(dM)=='table'then for a4,aI in pairs(dM)do bg[aI]={velocityReset=not not dG}end else bg[dM]={velocityReset=not not dG}end end,Remove=function(dK,dL)return a.NillableIfHasValueOrElse(dJ[dK],function(bg)if a.NillableHasValue(bg[dL])then bg[dL]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(dK)if a.NillableHasValue(dJ[dK])then dJ[dK]=nil;return true else return false end end,RemoveAll=function()dJ={}return true end,Each=function(aW,dP)return a.NillableIfHasValueOrElse(dP,function(dK)return a.NillableIfHasValue(dJ[dK],function(bg)for dL,dQ in pairs(bg)do if aW(dL,dK,self)==false then return false end end end)end,function()for dK,bg in pairs(dJ)do if self.Each(aW,dK)==false then return false end end end)end,Update=function(dR)for dK,bg in pairs(dJ)do local dS=dK.GetPosition()local dT=dK.GetRotation()for dL,dQ in pairs(bg)do if dR or dL.IsMine then if not a.QuaternionApproximatelyEquals(dL.GetRotation(),dT)then dL.SetRotation(dT)end;if not a.VectorApproximatelyEquals(dL.GetPosition(),dS)then dL.SetPosition(dS)end;if dQ.velocityReset then dL.SetVelocity(Vector3.zero)dL.SetAngularVelocity(Vector3.zero)end end end end end}return self end,
CreateUpdateRoutine=function(dU,dV)return coroutine.wrap(function()local dW=TimeSpan.FromSeconds(30)local dX=vci.me.UnscaledTime;local dY=dX;local cj=vci.me.Time;local dZ=true;while true do local cP=a.InstanceID()if cP~=''then break end;local d_=vci.me.UnscaledTime;if d_-dW>dX then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;dY=d_;cj=vci.me.Time;dZ=false;coroutine.yield(100)end;if dZ then dY=vci.me.UnscaledTime;cj=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(dV,function(e0)e0()end)while true do local cn=vci.me.Time;local e1=cn-cj;local d_=vci.me.UnscaledTime;local e2=d_-dY;dU(e1,e2)cj=cn;dY=d_;coroutine.yield(100)end end)end,CreateSlideSwitch=function(e3)local e4=a.NillableValue(e3.colliderItem)local e5=a.NillableValue(e3.baseItem)local e6=a.NillableValue(e3.knobItem)local e7=a.NillableValueOrDefault(e3.minValue,0)local e8=a.NillableValueOrDefault(e3.maxValue,10)if e7>=e8 then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local e9=(e7+e8)*0.5;local ea=function(aI)local eb,ec=a.PingPong(aI-e7,e8-e7)return eb+e7,ec end;local W=ea(a.NillableValueOrDefault(e3.value,0))local ed=a.NillableIfHasValueOrElse(e3.tickFrequency,function(ee)if ee<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(ee,e8-e7)end,function()return(e8-e7)/10.0 end)local ef=a.NillableIfHasValueOrElse(e3.tickVector,function(bR)return Vector3.__new(bR.x,bR.y,bR.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local eg=ef.magnitude;if eg<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local eh=a.NillableValueOrDefault(e3.snapToTick,true)local ei=e3.valueTextName;local ej=a.NillableValueOrDefault(e3.valueToText,tostring)local ek=TimeSpan.FromMilliseconds(1000)local el=TimeSpan.FromMilliseconds(50)local em,en;local de={}local self;local eo=false;local ep=0;local eq=false;local er=TimeSpan.Zero;local es=TimeSpan.Zero;local et=function(eu,ev)if ev or eu~=W then local df=W;W=eu;for dg,a9 in pairs(de)do dg(self,W,df)end end;e6.SetLocalPosition((eu-e9)/ed*ef)if ei then vci.assets.SetText(ei,ej(eu,self))end end;local ew=function()local ex=em()local ey,ez=ea(ex)local eA=ex+ed;local eB,eC=ea(eA)assert(eB)local eu;if ez==eC or ey==e8 or ey==e7 then eu=eA else eu=ez>=0 and e8 or e7 end;es=vci.me.UnscaledTime;if eu==e8 or eu==e7 then er=es end;en(eu)end;a.NillableIfHasValueOrElse(e3.lsp,function(eD)if not a.NillableHasValue(e3.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local eE=a.NillableValue(e3.propertyName)em=function()return eD.GetProperty(eE,W)end;en=function(aI)eD.SetProperty(eE,aI)end;eD.AddListener(function(bh,a4,eF,eG)if a4==eE then et(ea(eF),true)end end)end,function()local eF=W;em=function()return eF end;en=function(aI)eF=aI;et(ea(aI),true)end end)self={GetColliderItem=function()return e4 end,GetBaseItem=function()return e5 end,GetKnobItem=function()return e6 end,GetMinValue=function()return e7 end,GetMaxValue=function()return e8 end,GetValue=function()return W end,GetScaleValue=function(eH,eI)assert(eH<=eI)return eH+(eI-eH)*(W-e7)/(e8-e7)end,SetValue=function(aI)en(ea(aI))end,GetTickFrequency=function()return ed end,IsSnapToTick=function()return eh end,AddListener=function(dg)de[dg]=dg end,RemoveListener=function(dg)de[dg]=nil end,DoUse=function()if not eo then eq=true;er=vci.me.UnscaledTime;ew()end end,DoUnuse=function()eq=false end,DoGrab=function()if not eq then eo=true;ep=(W-e9)/ed end end,DoUngrab=function()eo=false end,Update=function()if eo then local eJ=e4.GetPosition()-e5.GetPosition()local eK=e6.GetRotation()*ef;local eL=Vector3.Project(eJ,eK)local eM=(Vector3.Dot(eK,eL)>=0 and 1 or-1)*eL.magnitude/eg+ep;local eN=(eh and a.Round(eM)or eM)*ed+e9;local eu=a.Clamp(eN,e7,e8)if eu~=W then en(eu)end elseif eq then local eO=vci.me.UnscaledTime;if eO>=er+ek and eO>=es+el then ew()end elseif e4.IsMine then a.AlignSubItemOrigin(e5,e4)end end}et(ea(em()),false)return self end,CreateSubItemConnector=function()local eP=function(eQ,dF,eR)eQ.item=dF;eQ.position=dF.GetPosition()eQ.rotation=dF.GetRotation()eQ.initialPosition=eQ.position;eQ.initialRotation=eQ.rotation;eQ.propagation=not not eR;return eQ end;local eS=function(eT)for dF,eQ in pairs(eT)do eP(eQ,dF,eQ.propagation)end end;local eU=function(p,c4,eQ,eV,eW)local eJ=p-eQ.initialPosition;local eX=c4*Quaternion.Inverse(eQ.initialRotation)eQ.position=p;eQ.rotation=c4;for dF,eY in pairs(eV)do if dF~=eQ.item and(not eW or eW(eY))then eY.position,eY.rotation=a.RotateAround(eY.initialPosition+eJ,eY.initialRotation,p,eX)dF.SetPosition(eY.position)dF.SetRotation(eY.rotation)end end end;local eZ={}local e_=true;local f0=false;local self;self={IsEnabled=function()return e_ end,SetEnabled=function(bu)e_=bu;if bu then eS(eZ)f0=false end end,Contains=function(f1)return a.NillableHasValue(eZ[f1])end,Add=function(f2,f3)if not f2 then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(f2),2)end;local f4=type(f2)=='table'and f2 or{f2}eS(eZ)f0=false;for ai,dF in pairs(f4)do eZ[dF]=eP({},dF,not f3)end end,Remove=function(f1)local K=a.NillableHasValue(eZ[f1])eZ[f1]=nil;return K end,RemoveAll=function()eZ={}return true end,Each=function(aW)for dF,eQ in pairs(eZ)do if aW(dF,self)==false then return false end end end,GetItems=function()local f4={}for dF,eQ in pairs(eZ)do table.insert(f4,dF)end;return f4 end,Update=function()if not e_ then return end;local f5=false;for dF,eQ in pairs(eZ)do local cT=dF.GetPosition()local f6=dF.GetRotation()if not a.VectorApproximatelyEquals(cT,eQ.position)or not a.QuaternionApproximatelyEquals(f6,eQ.rotation)then if eQ.propagation then if dF.IsMine then eU(cT,f6,eZ[dF],eZ,function(eY)if eY.item.IsMine then return true else f0=true;return false end end)f5=true;break else f0=true end else f0=true end end end;if not f5 and f0 then eS(eZ)f0=false end end}return self end,GetSubItemTransform=function(f1)local p=f1.GetPosition()local c4=f1.GetRotation()local f7=f1.GetLocalScale()return{positionX=p.x,positionY=p.y,positionZ=p.z,rotationX=c4.x,rotationY=c4.y,rotationZ=c4.z,rotationW=c4.w,scaleX=f7.x,scaleY=f7.y,scaleZ=f7.z}end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',MessageSenderOverride='__CYTANB_MESSAGE_SENDER_OVERRIDE',MessageOriginalSender='__CYTANB_MESSAGE_ORIGINAL_SENDER',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c=a.MakeSearchPattern({'\t','\n','\v','\f','\r',' '},1,-1)d,e=(function()local f8={'A','B','C','D','E','F','a','b','c','d','e','f','0','1','2','3','4','5','6','7','8','9'}return a.MakeSearchPattern(f8,4,4),a.MakeSearchPattern(f8,8,8)end)()f=a.MakeSearchPattern({'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','_','-','.','(',')','!','~','*','\'','%'},1,-1)g={{tag=a.NegativeNumberTag,search=a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,search=a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,search=a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,search=a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}h={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}i=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})j=a.LogLevelInfo;l={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;m,n=(function()local d7='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local dd=_G[d7]if not dd then dd={}_G[d7]=dd end;local f9=dd.randomSeedValue;if not f9 then f9=os.time()-os.clock()*10000;dd.randomSeedValue=f9;math.randomseed(f9)end;local fa=dd.clientID;if type(fa)~='string'then fa=tostring(a.RandomUUID())dd.clientID=fa end;local fb=vci.state.Get(b)or''if fb==''and vci.assets.IsMine then fb=tostring(a.RandomUUID())vci.state.Set(b,fb)end;return fb,fa end)()return a end)()

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
