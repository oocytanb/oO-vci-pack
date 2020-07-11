-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g;local h;local i;local j;local k=false;local l;local m;local n;local a;local o=function(p,q)local r=p+q-1;return p,r,r+1 end;local s=function(p,q)local r=p-q+1;return r,p,r-1 end;local t=function(u,v,w,p,x)local y=w.searchMap;for z,q in pairs(w.lengthList)do if q<=0 then error('SearchPattern: Invalid parameter: searchLen <= 0')else local A,B,r=x(p,q)if A>=1 and B<=v then local C=string.sub(u,A,B)if y[C]then return true,q,r end end end end;return false,-1,-1 end;local D=function(u,w,p,x)if u==nil or w==nil then return false,-1 end;if w.hasEmptySearch then return true,0 end;local v=string.len(u)local E=w.repeatMin;local F=w.repeatMax;local G=F<0;local H=p;local I=0;local J=0;while G or J<F do local K,L,r=t(u,v,w,H,x)if K then if L<=0 then error('SearchPattern: Invalid parameter')end;H=r;I=I+L;J=J+1 else break end end;if J>=E then return true,I else return false,-1 end end;local M=function(u,N,p,O,x,P)if u==nil or N==nil then return false,-1 end;local q=string.len(N)if O then local K=P(u,N)return K,K and q or-1 else if q==0 then return true,q end;local v=string.len(u)local A,B=x(p,q)if A>=1 and B<=v then local C=string.sub(u,A,B)local K=P(C,N)return K,K and q or-1 else return false,-1 end end end;local Q=function(R,S)for T=1,4 do local U=R[T]-S[T]if U~=0 then return U end end;return 0 end;local V;V={__eq=function(R,S)return R[1]==S[1]and R[2]==S[2]and R[3]==S[3]and R[4]==S[4]end,__lt=function(R,S)return Q(R,S)<0 end,__le=function(R,S)return Q(R,S)<=0 end,__tostring=function(W)local X=W[2]or 0;local Y=W[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(W[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(X,16),0xFFFF),bit32.band(X,0xFFFF),bit32.band(bit32.rshift(Y,16),0xFFFF),bit32.band(Y,0xFFFF),bit32.band(W[4]or 0,0xFFFFFFFF))end,__concat=function(R,S)local Z=getmetatable(R)local _=Z==V or type(Z)=='table'and Z.__concat==V.__concat;local a0=getmetatable(S)local a1=a0==V or type(a0)=='table'and a0.__concat==V.__concat;if not _ and not a1 then error('UUID: attempt to concatenate illegal values',2)end;return(_ and V.__tostring(R)or R)..(a1 and V.__tostring(S)or S)end}local a2='__CYTANB_CONST_VARIABLES'local a3=function(table,a4)local a5=getmetatable(table)if a5 then local a6=rawget(a5,a2)if a6 then local a7=rawget(a6,a4)if type(a7)=='function'then return a7(table,a4)else return a7 end end end;return nil end;local a8=function(table,a4,a9)local a5=getmetatable(table)if a5 then local a6=rawget(a5,a2)if a6 then if rawget(a6,a4)~=nil then error('Cannot assign to read only field "'..a4 ..'"',2)end end end;rawset(table,a4,a9)end;local aa=function(ab,ac)local ad=ab[a.TypeParameterName]if a.NillableHasValue(ad)and a.NillableValue(ad)~=ac then return false,false end;return a.NillableIfHasValueOrElse(h[ac],function(ae)local af=ae.compositionFieldNames;local ag=ae.compositionFieldLength;local ah=false;for ai,a9 in pairs(ab)do if af[ai]then ag=ag-1;if ag<=0 and ah then break end elseif ai~=a.TypeParameterName then ah=true;if ag<=0 then break end end end;return ag<=0,ah end,function()return false,false end)end;local aj=function(u)return a.StringReplace(a.StringReplace(u,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local ak=function(u,al)local am=string.len(u)local an=string.len(a.EscapeSequenceTag)if an>am then return u end;local ao=''local T=1;while T<am do local B,ap=string.find(u,a.EscapeSequenceTag,T,true)if not B then if T==1 then ao=u else ao=ao..string.sub(u,T)end;break end;if B>T then ao=ao..string.sub(u,T,B-1)end;local aq=false;for ar,as in ipairs(g)do local K=a.StringStartsWith(u,as.search,B)if K then ao=ao..(al and al(as.tag)or as.replacement)T=B+string.len(as.search)aq=true;break end end;if not aq then ao=ao..a.EscapeSequenceTag;T=ap+1 end end;return ao end;local at;at=function(au,av)if type(au)~='table'then return au end;if not av then av={}end;if av[au]then error('circular reference')end;av[au]=true;local aw={}for ai,a9 in pairs(au)do local ax=type(ai)local ay;if ax=='string'then ay=aj(ai)elseif ax=='number'then ay=tostring(ai)..a.ArrayNumberTag else ay=ai end;local az=type(a9)if az=='string'then aw[ay]=aj(a9)elseif az=='number'and a9<0 then aw[tostring(ay)..a.NegativeNumberTag]=tostring(a9)else aw[ay]=at(a9,av)end end;av[au]=nil;return aw end;local aA;aA=function(aw,aB)if type(aw)~='table'then return aw end;local au={}for ai,a9 in pairs(aw)do local ay;local aC=false;if type(ai)=='string'then local aD=false;ay=ak(ai,function(aE)if aE==a.NegativeNumberTag then aC=true elseif aE==a.ArrayNumberTag then aD=true end;return nil end)if aD then ay=tonumber(ay)or ay end else ay=ai;aC=false end;if aC and type(a9)=='string'then au[ay]=tonumber(a9)elseif type(a9)=='string'then au[ay]=ak(a9,function(aE)return i[aE]end)else au[ay]=aA(a9,aB)end end;if not aB then a.NillableIfHasValue(au[a.TypeParameterName],function(aF)a.NillableIfHasValue(h[aF],function(ae)local aG,ah=ae.fromTableFunc(au)if not ah then a.NillableIfHasValue(aG,function(W)au=W end)end end)end)end;return au end;local aH={['nil']=function(aI)return nil end,['number']=function(aI)return tonumber(aI)end,['string']=function(aI)return tostring(aI)end,['boolean']=function(aI)if aI then return true else return false end end}local aJ=function(aI,aK)local aL=type(aI)if aL==aK then return aI else local aM=aH[aK]if aM then return aM(aI)else return nil end end end;local aN=function(aO,aP)if aP and type(aP)=='table'then local aQ={}for a4,aI in pairs(aO)do local aR=aP[a4]local aS;if aR==nil then aS=aI else local aT=aJ(aR,type(aI))if aT==nil then aS=aI else aS=aT end end;aQ[a4]=aS end;aQ[a.MessageOriginalSender]=aO;return aQ else return aO end end;a={InstanceID=function()if m==''then m=vci.state.Get(b)or''end;return m end,NillableHasValue=function(aU)return aU~=nil end,NillableValue=function(aU)if aU==nil then error('nillable: value is nil',2)end;return aU end,NillableValueOrDefault=function(aU,aV)if aU==nil then if aV==nil then error('nillable: defaultValue is nil',2)end;return aV else return aU end end,NillableIfHasValue=function(aU,aW)if aU==nil then return nil else return aW(aU)end end,NillableIfHasValueOrElse=function(aU,aW,aX)if aU==nil then return aX()else return aW(aU)end end,MakeSearchPattern=function(aY,aZ,a_)local E=aZ and math.floor(aZ)or 1;if E<0 then error('SearchPattern: Invalid parameter: optRepeatMin < 0')end;local F=a_ and math.floor(a_)or E;if F>=0 and F<E then error('SearchPattern: Invalid parameter: repeatMax < repeatMin')end;local b0=F==0;local y={}local b1={}local b2={}local b3=0;for b4,b5 in pairs(aY)do local q=string.len(b5)if q==0 then b0=true else y[b5]=q;if not b1[q]then b1[q]=true;b3=b3+1;b2[b3]=q end end end;table.sort(b2,function(b6,K)return b6>K end)return{hasEmptySearch=b0,searchMap=y,lengthList=b2,repeatMin=E,repeatMax=F}end,StringStartsWith=function(u,N,b7)local H=b7 and math.max(1,math.floor(b7))or 1;if type(N)=='table'then return D(u,N,H,o)else return M(u,N,H,H==1,o,string.startsWith)end end,StringEndsWith=function(u,N,b8)if u==nil then return false,-1 end;local v=string.len(u)local H=b8 and math.min(v,math.floor(b8))or v;if type(N)=='table'then return D(u,N,H,s)else return M(u,N,H,H==v,s,string.endsWith)end end,StringTrimStart=function(u,b9)if u==nil or u==''then return u end;local K,L=a.StringStartsWith(u,b9 or c)if K and L>=1 then return string.sub(u,L+1)else return u end end,StringTrimEnd=function(u,b9)if u==nil or u==''then return u end;local K,L=a.StringEndsWith(u,b9 or c)if K and L>=1 then return string.sub(u,1,string.len(u)-L)else return u end end,StringTrim=function(u,b9)return a.StringTrimEnd(a.StringTrimStart(u,b9),b9)end,StringReplace=function(u,ba,bb)local bc;local am=string.len(u)if ba==''then bc=bb;for T=1,am do bc=bc..string.sub(u,T,T)..bb end else bc=''local T=1;while true do local A,B=string.find(u,ba,T,true)if A then bc=bc..string.sub(u,T,A-1)..bb;T=B+1;if T>am then break end else bc=T==1 and u or bc..string.sub(u,T)break end end end;return bc end,SetConst=function(ba,bd,W)if type(ba)~='table'then error('Cannot set const to non-table target',2)end;local be=getmetatable(ba)local a5=be or{}local bf=rawget(a5,a2)if rawget(ba,bd)~=nil then error('Non-const field "'..bd..'" already exists',2)end;if not bf then bf={}rawset(a5,a2,bf)a5.__index=a3;a5.__newindex=a8 end;rawset(bf,bd,W)if not be then setmetatable(ba,a5)end;return ba end,
SetConstEach=function(ba,bg)for ai,a9 in pairs(bg)do a.SetConst(ba,ai,a9)end;return ba end,Extend=function(ba,bh,bi,bj,av)if ba==bh or type(ba)~='table'or type(bh)~='table'then return ba end;if bi then if not av then av={}end;if av[bh]then error('circular reference')end;av[bh]=true end;for ai,a9 in pairs(bh)do if bi and type(a9)=='table'then local bk=ba[ai]ba[ai]=a.Extend(type(bk)=='table'and bk or{},a9,bi,bj,av)else ba[ai]=a9 end end;if not bj then local bl=getmetatable(bh)if type(bl)=='table'then if bi then local bm=getmetatable(ba)setmetatable(ba,a.Extend(type(bm)=='table'and bm or{},bl,true))else setmetatable(ba,bl)end end end;if bi then av[bh]=nil end;return ba end,Vars=function(a9,bn,bo,av)local bp;if bn then bp=bn~='__NOLF'else bn='  'bp=true end;if not bo then bo=''end;if not av then av={}end;local bq=type(a9)if bq=='table'then av[a9]=av[a9]and av[a9]+1 or 1;local br=bp and bo..bn or''local u='('..tostring(a9)..') {'local bs=true;for a4,aI in pairs(a9)do if bs then bs=false else u=u..(bp and','or', ')end;if bp then u=u..'\n'..br end;if type(aI)=='table'and av[aI]and av[aI]>0 then u=u..a4 ..' = ('..tostring(aI)..')'else u=u..a4 ..' = '..a.Vars(aI,bn,br,av)end end;if not bs and bp then u=u..'\n'..bo end;u=u..'}'av[a9]=av[a9]-1;if av[a9]<=0 then av[a9]=nil end;return u elseif bq=='function'or bq=='thread'or bq=='userdata'then return'('..bq..')'elseif bq=='string'then return'('..bq..') '..string.format('%q',a9)else return'('..bq..') '..tostring(a9)end end,GetLogLevel=function()return j end,SetLogLevel=function(bt)j=bt end,IsOutputLogLevelEnabled=function()return k end,SetOutputLogLevelEnabled=function(bu)k=not not bu end,Log=function(bt,...)if bt<=j then local bv=k and(l[bt]or'LOG LEVEL '..tostring(bt))..' | 'or''local bw=table.pack(...)if bw.n==1 then local a9=bw[1]if a9~=nil then local u=type(a9)=='table'and a.Vars(a9)or tostring(a9)print(k and bv..u or u)else print(bv)end else local u=bv;for T=1,bw.n do local a9=bw[T]if a9~=nil then u=u..(type(a9)=='table'and a.Vars(a9)or tostring(a9))end end;print(u)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(bx,by)local bz={}if by==nil then for ai,a9 in pairs(bx)do bz[a9]=a9 end elseif type(by)=='function'then for ai,a9 in pairs(bx)do local bA,bB=by(a9)bz[bA]=bB end else for ai,a9 in pairs(bx)do bz[a9]=by end end;return bz end,Round=function(bC,bD)if bD then local bE=10^bD;return math.floor(bC*bE+0.5)/bE else return math.floor(bC+0.5)end end,Clamp=function(W,bF,bG)return math.max(bF,math.min(W,bG))end,Lerp=function(b6,K,bq)if bq<=0.0 then return b6 elseif bq>=1.0 then return K else return b6+(K-b6)*bq end end,LerpUnclamped=function(b6,K,bq)if bq==0.0 then return b6 elseif bq==1.0 then return K else return b6+(K-b6)*bq end end,PingPong=function(bq,bH)if bH==0 then return 0,1 end;local bI=math.floor(bq/bH)local bJ=bq-bI*bH;if bI<0 then if(bI+1)%2==0 then return bH-bJ,-1 else return bJ,1 end else if bI%2==0 then return bJ,1 else return bH-bJ,-1 end end end,VectorApproximatelyEquals=function(bK,bL)return(bK-bL).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(bK,bL)local bM=Quaternion.Dot(bK,bL)return bM<1.0+1E-06 and bM>1.0-1E-06 end,QuaternionToAngleAxis=function(bN)local bI=bN.normalized;local bO=math.acos(bI.w)local bP=math.sin(bO)local bQ=math.deg(bO*2.0)local bR;if math.abs(bP)<=Quaternion.kEpsilon then bR=Vector3.right else local A=1.0/bP;bR=Vector3.__new(bI.x*A,bI.y*A,bI.z*A)end;return bQ,bR end,QuaternionTwist=function(bN,bS)if bS.sqrMagnitude<Vector3.kEpsilonNormalSqrt then return Quaternion.identity end;local bT=Vector3.__new(bN.x,bN.y,bN.z)if bT.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local bU=Vector3.Project(bT,bS)if bU.sqrMagnitude>=Vector3.kEpsilonNormalSqrt then local bV=Quaternion.__new(bU.x,bU.y,bU.z,bN.w)bV.Normalize()return bV else return Quaternion.AngleAxis(0,bS)end else local bW=a.QuaternionToAngleAxis(bN)return Quaternion.AngleAxis(bW,bS)end end,ApplyQuaternionToVector3=function(bN,bX)local bY=bN.w*bX.x+bN.y*bX.z-bN.z*bX.y;local bZ=bN.w*bX.y-bN.x*bX.z+bN.z*bX.x;local b_=bN.w*bX.z+bN.x*bX.y-bN.y*bX.x;local c0=-bN.x*bX.x-bN.y*bX.y-bN.z*bX.z;return Vector3.__new(c0*-bN.x+bY*bN.w+bZ*-bN.z-b_*-bN.y,c0*-bN.y-bY*-bN.z+bZ*bN.w+b_*-bN.x,c0*-bN.z+bY*-bN.y-bZ*-bN.x+b_*bN.w)end,RotateAround=function(c1,c2,c3,c4)return c3+c4*(c1-c3),c4*c2 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(c5)return V.__tostring(c5)end,UUIDFromNumbers=function(...)local c6=...local bq=type(c6)local c7,c8,c9,ca;if bq=='table'then c7=c6[1]c8=c6[2]c9=c6[3]ca=c6[4]else c7,c8,c9,ca=...end;local c5={bit32.band(c7 or 0,0xFFFFFFFF),bit32.band(c8 or 0,0xFFFFFFFF),bit32.band(c9 or 0,0xFFFFFFFF),bit32.band(ca or 0,0xFFFFFFFF)}setmetatable(c5,V)return c5 end,UUIDFromString=function(u)local am=string.len(u)if am==32 then local c5=a.UUIDFromNumbers(0,0,0,0)for T=1,4 do local A=1+(T-1)*8;if not a.StringStartsWith(u,e,A)then return nil end;c5[T]=tonumber(string.sub(u,A,A+7),16)end;return c5 elseif am==36 then if not a.StringStartsWith(u,e,1)then return nil end;local c7=tonumber(string.sub(u,1,8),16)if not a.StringStartsWith(u,'-',9)or not a.StringStartsWith(u,d,10)or not a.StringStartsWith(u,'-',14)or not a.StringStartsWith(u,d,15)then return nil end;local c8=tonumber(string.sub(u,10,13)..string.sub(u,15,18),16)if not a.StringStartsWith(u,'-',19)or not a.StringStartsWith(u,d,20)or not a.StringStartsWith(u,'-',24)or not a.StringStartsWith(u,d,25)then return nil end;local c9=tonumber(string.sub(u,20,23)..string.sub(u,25,28),16)if not a.StringStartsWith(u,e,29)then return nil end;local ca=tonumber(string.sub(u,29),16)return a.UUIDFromNumbers(c7,c8,c9,ca)else return nil end end,ParseUUID=function(u)return a.UUIDFromString(u)end,CreateCircularQueue=function(cb)if type(cb)~='number'or cb<1 then error('CreateCircularQueue: Invalid argument: capacity = '..tostring(cb),2)end;local self;local cc=math.floor(cb)local ao={}local cd=0;local ce=0;local cf=0;self={Size=function()return cf end,Clear=function()cd=0;ce=0;cf=0 end,IsEmpty=function()return cf==0 end,Offer=function(cg)ao[cd+1]=cg;cd=(cd+1)%cc;if cf<cc then cf=cf+1 else ce=(ce+1)%cc end;return true end,OfferFirst=function(cg)ce=(cc+ce-1)%cc;ao[ce+1]=cg;if cf<cc then cf=cf+1 else cd=(cc+cd-1)%cc end;return true end,Poll=function()if cf==0 then return nil else local cg=ao[ce+1]ce=(ce+1)%cc;cf=cf-1;return cg end end,PollLast=function()if cf==0 then return nil else cd=(cc+cd-1)%cc;local cg=ao[cd+1]cf=cf-1;return cg end end,Peek=function()if cf==0 then return nil else return ao[ce+1]end end,PeekLast=function()if cf==0 then return nil else return ao[(cc+cd-1)%cc+1]end end,Get=function(ch)if ch<1 or ch>cf then a.LogError('CreateCircularQueue.Get: index is outside the range: '..ch)return nil end;return ao[(ce+ch-1)%cc+1]end,IsFull=function()return cf>=cc end,MaxSize=function()return cc end}return self end,DetectClicks=function(ci,cj,ck)local cl=ci or 0;local cm=ck or TimeSpan.FromMilliseconds(500)local cn=vci.me.Time;local co=cj and cn>cj+cm and 1 or cl+1;return co,cn end,ColorRGBToHSV=function(cp)local bJ=math.max(0.0,math.min(cp.r,1.0))local cq=math.max(0.0,math.min(cp.g,1.0))local K=math.max(0.0,math.min(cp.b,1.0))local bG=math.max(bJ,cq,K)local bF=math.min(bJ,cq,K)local cr=bG-bF;local a7;if cr==0.0 then a7=0.0 elseif bG==bJ then a7=(cq-K)/cr/6.0 elseif bG==cq then a7=(2.0+(K-bJ)/cr)/6.0 else a7=(4.0+(bJ-cq)/cr)/6.0 end;if a7<0.0 then a7=a7+1.0 end;local cs=bG==0.0 and cr or cr/bG;local a9=bG;return a7,cs,a9 end,ColorFromARGB32=function(ct)local cu=type(ct)=='number'and ct or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(cu,16),0xFF)/0xFF,bit32.band(bit32.rshift(cu,8),0xFF)/0xFF,bit32.band(cu,0xFF)/0xFF,bit32.band(bit32.rshift(cu,24),0xFF)/0xFF)end,ColorToARGB32=function(cp)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*cp.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*cp.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*cp.g),0xFF),8),bit32.band(a.Round(0xFF*cp.b),0xFF))end,ColorFromIndex=function(cv,cw,cx,cy,cz)local cA=math.max(math.floor(cw or a.ColorHueSamples),1)local cB=cz and cA or cA-1;local cC=math.max(math.floor(cx or a.ColorSaturationSamples),1)local cD=math.max(math.floor(cy or a.ColorBrightnessSamples),1)local ch=a.Clamp(math.floor(cv or 0),0,cA*cC*cD-1)local cE=ch%cA;local cF=math.floor(ch/cA)local A=cF%cC;local cG=math.floor(cF/cC)if cz or cE~=cB then local a7=cE/cB;local cs=(cC-A)/cC;local a9=(cD-cG)/cD;return Color.HSVToRGB(a7,cs,a9)else local a9=(cD-cG)/cD*A/(cC-1)return Color.HSVToRGB(0.0,0.0,a9)end end,
ColorToIndex=function(cp,cw,cx,cy,cz)local cA=math.max(math.floor(cw or a.ColorHueSamples),1)local cB=cz and cA or cA-1;local cC=math.max(math.floor(cx or a.ColorSaturationSamples),1)local cD=math.max(math.floor(cy or a.ColorBrightnessSamples),1)local a7,cs,a9=a.ColorRGBToHSV(cp)local A=a.Round(cC*(1.0-cs))if cz or A<cC then local cH=a.Round(cB*a7)if cH>=cB then cH=0 end;if A>=cC then A=cC-1 end;local cG=math.min(cD-1,a.Round(cD*(1.0-a9)))return cH+cA*(A+cC*cG)else local cI=a.Round((cC-1)*a9)if cI==0 then local cJ=a.Round(cD*(1.0-a9))if cJ>=cD then return cA-1 else return cA*(1+a.Round(a9*(cC-1)/(cD-cJ)*cD)+cC*cJ)-1 end else return cA*(1+cI+cC*a.Round(cD*(1.0-a9*(cC-1)/cI)))-1 end end end,ColorToTable=function(cp)return{[a.TypeParameterName]=a.ColorTypeName,r=cp.r,g=cp.g,b=cp.b,a=cp.a}end,ColorFromTable=function(ab)local K,ah=aa(ab,a.ColorTypeName)return K and Color.__new(ab.r,ab.g,ab.b,ab.a)or nil,ah end,Vector2ToTable=function(W)return{[a.TypeParameterName]=a.Vector2TypeName,x=W.x,y=W.y}end,Vector2FromTable=function(ab)local K,ah=aa(ab,a.Vector2TypeName)return K and Vector2.__new(ab.x,ab.y)or nil,ah end,Vector3ToTable=function(W)return{[a.TypeParameterName]=a.Vector3TypeName,x=W.x,y=W.y,z=W.z}end,Vector3FromTable=function(ab)local K,ah=aa(ab,a.Vector3TypeName)return K and Vector3.__new(ab.x,ab.y,ab.z)or nil,ah end,Vector4ToTable=function(W)return{[a.TypeParameterName]=a.Vector4TypeName,x=W.x,y=W.y,z=W.z,w=W.w}end,Vector4FromTable=function(ab)local K,ah=aa(ab,a.Vector4TypeName)return K and Vector4.__new(ab.x,ab.y,ab.z,ab.w)or nil,ah end,QuaternionToTable=function(W)return{[a.TypeParameterName]=a.QuaternionTypeName,x=W.x,y=W.y,z=W.z,w=W.w}end,QuaternionFromTable=function(ab)local K,ah=aa(ab,a.QuaternionTypeName)return K and Quaternion.__new(ab.x,ab.y,ab.z,ab.w)or nil,ah end,TableToSerializable=function(au)return at(au)end,TableFromSerializable=function(aw,aB)return aA(aw,aB)end,TableToSerialiable=function(au)return at(au)end,TableFromSerialiable=function(aw,aB)return aA(aw,aB)end,EmitMessage=function(bd,cK)local aw=a.NillableIfHasValueOrElse(cK,function(au)if type(au)~='table'then error('EmitMessage: Invalid argument: table expected',3)end;return a.TableToSerializable(au)end,function()return{}end)aw[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(bd,json.serialize(aw))end,OnMessage=function(bd,aW)local aM=function(aO,cL,cM)if type(cM)=='string'and string.startsWith(cM,'{')then local cN,aw=pcall(json.parse,cM)if cN and type(aw)=='table'and aw[a.InstanceIDParameterName]then local cO=a.TableFromSerializable(aw)aW(aN(aO,cO[a.MessageSenderOverride]),cL,cO)return end end;aW(aO,cL,{[a.MessageValueParameterName]=cM})end;vci.message.On(bd,aM)return{Off=function()if aM then aM=nil end end}end,OnInstanceMessage=function(bd,aW)local aM=function(aO,cL,cK)local cP=a.InstanceID()if cP~=''and cP==cK[a.InstanceIDParameterName]then aW(aO,cL,cK)end end;return a.OnMessage(bd,aM)end,EmitCommentMessage=function(cM,aP)local cQ={type='comment',name='',commentSource=''}local cK={[a.MessageValueParameterName]=tostring(cM),[a.MessageSenderOverride]=type(aP)=='table'and a.Extend(cQ,aP,true)or cQ}a.EmitMessage('comment',cK)end,OnCommentMessage=function(aW)local aM=function(aO,cL,cK)local cM=tostring(cK[a.MessageValueParameterName]or'')aW(aO,cL,cM)end;return a.OnMessage('comment',aM)end,EmitNotificationMessage=function(cM,aP)local cQ={type='notification',name='',commentSource=''}local cK={[a.MessageValueParameterName]=tostring(cM),[a.MessageSenderOverride]=type(aP)=='table'and a.Extend(cQ,aP,true)or cQ}a.EmitMessage('notification',cK)end,OnNotificationMessage=function(aW)local aM=function(aO,cL,cK)local cM=tostring(cK[a.MessageValueParameterName]or'')aW(aO,cL,cM)end;return a.OnMessage('notification',aM)end,GetEffekseerEmitterMap=function(bd)local cR=vci.assets.GetEffekseerEmitters(bd)if not cR then return nil end;local bz={}for T,cS in pairs(cR)do bz[cS.EffectName]=cS end;return bz end,ClientID=function()return n end,ParseTagString=function(u)local cT=string.find(u,'#',1,true)if not cT then return{},u end;local cU={}local cV=string.sub(u,1,cT-1)cT=cT+1;local am=string.len(u)while cT<=am do local cW,cX=a.StringStartsWith(u,f,cT)if cW then local cY=cT+cX;local cZ=string.sub(u,cT,cY-1)local c_=cZ;cT=cY;if cT<=am and a.StringStartsWith(u,'=',cT)then cT=cT+1;local d0,d1=a.StringStartsWith(u,f,cT)if d0 then local d2=cT+d1;c_=string.sub(u,cT,d2-1)cT=d2 else c_=''end end;cU[cZ]=c_ end;cT=string.find(u,'#',cT,true)if not cT then break end;cT=cT+1 end;return cU,cV end,CalculateSIPrefix=(function()local d3=9;local d4={'y','z','a','f','p','n','u','m','','k','M','G','T','P','E','Z','Y'}local d5=#d4;return function(bC)local d6=bC==0 and 0 or a.Clamp(math.floor(math.log(math.abs(bC),1000)),1-d3,d5-d3)return d6==0 and bC or bC/1000^d6,d4[d3+d6],d6*3 end end)(),CreateLocalSharedProperties=function(d7,d8)local d9=TimeSpan.FromSeconds(5)local da='33657f0e-7c44-4ee7-acd9-92dd8b8d807a'local db='__CYTANB_LOCAL_SHARED_PROPERTIES_LISTENER_MAP'if type(d7)~='string'or string.len(d7)<=0 or type(d8)~='string'or string.len(d8)<=0 then error('LocalSharedProperties: Invalid arguments',2)end;local dc=_G[da]if not dc then dc={}_G[da]=dc end;dc[d8]=vci.me.UnscaledTime;local dd=_G[d7]if not dd then dd={[db]={}}_G[d7]=dd end;local de=dd[db]local self;self={GetLspID=function()return d7 end,GetLoadID=function()return d8 end,GetProperty=function(a4,aV)local W=dd[a4]if W==nil then return aV else return W end end,SetProperty=function(a4,W)if a4==db then error('LocalSharedProperties: Invalid argument: key = ',a4,2)end;local cn=vci.me.UnscaledTime;local df=dd[a4]dd[a4]=W;for dg,cP in pairs(de)do local bq=dc[cP]if bq and bq+d9>=cn then dg(self,a4,W,df)else dg(self,a.LOCAL_SHARED_PROPERTY_EXPIRED_KEY,true,false)de[dg]=nil;dc[cP]=nil end end end,Clear=function()for a4,W in pairs(dd)do if a4~=db then self.SetProperty(a4,nil)end end end,Each=function(aW)for a4,W in pairs(dd)do if a4~=db and aW(W,a4,self)==false then return false end end end,AddListener=function(dg)de[dg]=d8 end,RemoveListener=function(dg)de[dg]=nil end,UpdateAlive=function()dc[d8]=vci.me.UnscaledTime end}return self end,EstimateFixedTimestep=function(dh)local di=1.0;local dj=1000.0;local dk=TimeSpan.FromSeconds(0.02)local dl=0xFFFF;local dm=a.CreateCircularQueue(64)local dn=TimeSpan.FromSeconds(5)local dp=TimeSpan.FromSeconds(30)local dq=false;local dr=vci.me.Time;local ds=a.Random32()local dt=Vector3.__new(bit32.bor(0x400,bit32.band(ds,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(ds,16),0x1FFF)),0.0)dh.SetPosition(dt)dh.SetRotation(Quaternion.identity)dh.SetVelocity(Vector3.zero)dh.SetAngularVelocity(Vector3.zero)dh.AddForce(Vector3.__new(0.0,0.0,di*dj))local self={Timestep=function()return dk end,Precision=function()return dl end,IsFinished=function()return dq end,Update=function()if dq then return dk end;local du=vci.me.Time-dr;local dv=du.TotalSeconds;if dv<=Vector3.kEpsilon then return dk end;local dw=dh.GetPosition().z-dt.z;local dx=dw/dv;local dy=dx/dj;if dy<=Vector3.kEpsilon then return dk end;dm.Offer(dy)local dz=dm.Size()if dz>=2 and du>=dn then local dA=0.0;for T=1,dz do dA=dA+dm.Get(T)end;local dB=dA/dz;local dC=0.0;for T=1,dz do dC=dC+(dm.Get(T)-dB)^2 end;local dD=dC/dz;if dD<dl then dl=dD;dk=TimeSpan.FromSeconds(dB)end;if du>dp then dq=true;dh.SetPosition(dt)dh.SetRotation(Quaternion.identity)dh.SetVelocity(Vector3.zero)dh.SetAngularVelocity(Vector3.zero)end else dk=TimeSpan.FromSeconds(dy)end;return dk end}return self end,AlignSubItemOrigin=function(dE,dF,dG)local dH=dE.GetRotation()if not a.QuaternionApproximatelyEquals(dF.GetRotation(),dH)then dF.SetRotation(dH)end;local dI=dE.GetPosition()if not a.VectorApproximatelyEquals(dF.GetPosition(),dI)then dF.SetPosition(dI)end;if dG then dF.SetVelocity(Vector3.zero)dF.SetAngularVelocity(Vector3.zero)end end,CreateSubItemGlue=function()local dJ={}local self;self={Contains=function(dK,dL)return a.NillableIfHasValueOrElse(dJ[dK],function(bg)return a.NillableHasValue(bg[dL])end,function()return false end)end,Add=function(dK,dM,dG)if not dK or not dM then local dN='SubItemGlue.Add: Invalid arguments '..(not dK and', parent = '..tostring(dK)or'')..(not dM and', children = '..tostring(dM)or'')error(dN,2)end;local bg=a.NillableIfHasValueOrElse(dJ[dK],function(dO)return dO end,function()local dO={}dJ[dK]=dO;return dO end)if type(dM)=='table'then for a4,aI in pairs(dM)do bg[aI]={velocityReset=not not dG}end else bg[dM]={velocityReset=not not dG}end end,Remove=function(dK,dL)return a.NillableIfHasValueOrElse(dJ[dK],function(bg)if a.NillableHasValue(bg[dL])then bg[dL]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(dK)if a.NillableHasValue(dJ[dK])then dJ[dK]=nil;return true else return false end end,RemoveAll=function()dJ={}return true end,Each=function(aW,dP)return a.NillableIfHasValueOrElse(dP,function(dK)return a.NillableIfHasValue(dJ[dK],function(bg)for dL,dQ in pairs(bg)do if aW(dL,dK,self)==false then return false end end end)end,function()for dK,bg in pairs(dJ)do if self.Each(aW,dK)==false then return false end end end)end,Update=function(dR)for dK,bg in pairs(dJ)do local dS=dK.GetPosition()local dT=dK.GetRotation()for dL,dQ in pairs(bg)do if dR or dL.IsMine then if not a.QuaternionApproximatelyEquals(dL.GetRotation(),dT)then dL.SetRotation(dT)end;if not a.VectorApproximatelyEquals(dL.GetPosition(),dS)then dL.SetPosition(dS)end;if dQ.velocityReset then dL.SetVelocity(Vector3.zero)dL.SetAngularVelocity(Vector3.zero)end end end end end}return self end,
CreateUpdateRoutine=function(dU,dV)return coroutine.wrap(function()local dW=TimeSpan.FromSeconds(30)local dX=vci.me.UnscaledTime;local dY=dX;local cj=vci.me.Time;local dZ=true;while true do local cP=a.InstanceID()if cP~=''then break end;local d_=vci.me.UnscaledTime;if d_-dW>dX then a.LogError('TIMEOUT: Could not receive Instance ID.')return-1 end;dY=d_;cj=vci.me.Time;dZ=false;coroutine.yield(100)end;if dZ then dY=vci.me.UnscaledTime;cj=vci.me.Time;coroutine.yield(100)end;a.NillableIfHasValue(dV,function(e0)e0()end)while true do local cn=vci.me.Time;local e1=cn-cj;local d_=vci.me.UnscaledTime;local e2=d_-dY;dU(e1,e2)cj=cn;dY=d_;coroutine.yield(100)end end)end,CreateSlideSwitch=function(e3)local e4=a.NillableValue(e3.colliderItem)local e5=a.NillableValue(e3.baseItem)local e6=a.NillableValue(e3.knobItem)local e7=a.NillableValueOrDefault(e3.minValue,0)local e8=a.NillableValueOrDefault(e3.maxValue,10)if e7>=e8 then error('SlideSwitch: Invalid argument: minValue >= maxValue',2)end;local e9=(e7+e8)*0.5;local ea=function(aI)local eb,ec=a.PingPong(aI-e7,e8-e7)return eb+e7,ec end;local W=ea(a.NillableValueOrDefault(e3.value,0))local ed=a.NillableIfHasValueOrElse(e3.tickFrequency,function(ee)if ee<=0 then error('SlideSwitch: Invalid argument: tickFrequency <= 0',3)end;return math.min(ee,e8-e7)end,function()return(e8-e7)/10.0 end)local ef=a.NillableIfHasValueOrElse(e3.tickVector,function(bR)return Vector3.__new(bR.x,bR.y,bR.z)end,function()return Vector3.__new(0.01,0.0,0.0)end)local eg=ef.magnitude;if eg<Vector3.kEpsilon then error('SlideSwitch: Invalid argument: tickVector is too small',2)end;local eh=a.NillableValueOrDefault(e3.snapToTick,true)local ei=e3.valueTextName;local ej=a.NillableValueOrDefault(e3.valueToText,tostring)local ek=TimeSpan.FromMilliseconds(1000)local el=TimeSpan.FromMilliseconds(50)local em,en;local de={}local self;local eo=false;local ep=0;local eq=false;local er=TimeSpan.Zero;local es=TimeSpan.Zero;local et=function(eu,ev)if ev or eu~=W then local df=W;W=eu;for dg,a9 in pairs(de)do dg(self,W,df)end end;e6.SetLocalPosition((eu-e9)/ed*ef)if ei then vci.assets.SetText(ei,ej(eu,self))end end;local ew=function()local ex=em()local ey,ez=ea(ex)local eA=ex+ed;local eB,eC=ea(eA)assert(eB)local eu;if ez==eC or ey==e8 or ey==e7 then eu=eA else eu=ez>=0 and e8 or e7 end;es=vci.me.UnscaledTime;if eu==e8 or eu==e7 then er=es end;en(eu)end;a.NillableIfHasValueOrElse(e3.lsp,function(eD)if not a.NillableHasValue(e3.propertyName)then error('SlideSwitch: Invalid argument: propertyName is nil',3)end;local eE=a.NillableValue(e3.propertyName)em=function()return eD.GetProperty(eE,W)end;en=function(aI)eD.SetProperty(eE,aI)end;eD.AddListener(function(bh,a4,eF,eG)if a4==eE then et(ea(eF),true)end end)end,function()local eF=W;em=function()return eF end;en=function(aI)eF=aI;et(ea(aI),true)end end)self={GetColliderItem=function()return e4 end,GetBaseItem=function()return e5 end,GetKnobItem=function()return e6 end,GetMinValue=function()return e7 end,GetMaxValue=function()return e8 end,GetValue=function()return W end,GetScaleValue=function(eH,eI)assert(eH<=eI)return eH+(eI-eH)*(W-e7)/(e8-e7)end,SetValue=function(aI)en(ea(aI))end,GetTickFrequency=function()return ed end,IsSnapToTick=function()return eh end,AddListener=function(dg)de[dg]=dg end,RemoveListener=function(dg)de[dg]=nil end,DoUse=function()if not eo then eq=true;er=vci.me.UnscaledTime;ew()end end,DoUnuse=function()eq=false end,DoGrab=function()if not eq then eo=true;ep=(W-e9)/ed end end,DoUngrab=function()eo=false end,Update=function()if eo then local eJ=e4.GetPosition()-e5.GetPosition()local eK=e6.GetRotation()*ef;local eL=Vector3.Project(eJ,eK)local eM=(Vector3.Dot(eK,eL)>=0 and 1 or-1)*eL.magnitude/eg+ep;local eN=(eh and a.Round(eM)or eM)*ed+e9;local eu=a.Clamp(eN,e7,e8)if eu~=W then en(eu)end elseif eq then local eO=vci.me.UnscaledTime;if eO>=er+ek and eO>=es+el then ew()end elseif e4.IsMine then a.AlignSubItemOrigin(e5,e4)end end}et(ea(em()),false)return self end,CreateSubItemConnector=function()local eP=function(eQ,dF,eR)eQ.item=dF;eQ.position=dF.GetPosition()eQ.rotation=dF.GetRotation()eQ.initialPosition=eQ.position;eQ.initialRotation=eQ.rotation;eQ.propagation=not not eR;return eQ end;local eS=function(eT)for dF,eQ in pairs(eT)do eP(eQ,dF,eQ.propagation)end end;local eU=function(p,c4,eQ,eV,eW)local eJ=p-eQ.initialPosition;local eX=c4*Quaternion.Inverse(eQ.initialRotation)eQ.position=p;eQ.rotation=c4;for dF,eY in pairs(eV)do if dF~=eQ.item and(not eW or eW(eY))then eY.position,eY.rotation=a.RotateAround(eY.initialPosition+eJ,eY.initialRotation,p,eX)dF.SetPosition(eY.position)dF.SetRotation(eY.rotation)end end end;local eZ={}local e_=true;local f0=false;local self;self={IsEnabled=function()return e_ end,SetEnabled=function(bu)e_=bu;if bu then eS(eZ)f0=false end end,Contains=function(f1)return a.NillableHasValue(eZ[f1])end,Add=function(f2,f3)if not f2 then error('SubItemConnector.Add: Invalid argument: subItems = '..tostring(f2),2)end;local f4=type(f2)=='table'and f2 or{f2}eS(eZ)f0=false;for ai,dF in pairs(f4)do eZ[dF]=eP({},dF,not f3)end end,Remove=function(f1)local K=a.NillableHasValue(eZ[f1])eZ[f1]=nil;return K end,RemoveAll=function()eZ={}return true end,Each=function(aW)for dF,eQ in pairs(eZ)do if aW(dF,self)==false then return false end end end,GetItems=function()local f4={}for dF,eQ in pairs(eZ)do table.insert(f4,dF)end;return f4 end,Update=function()if not e_ then return end;local f5=false;for dF,eQ in pairs(eZ)do local cT=dF.GetPosition()local f6=dF.GetRotation()if not a.VectorApproximatelyEquals(cT,eQ.position)or not a.QuaternionApproximatelyEquals(f6,eQ.rotation)then if eQ.propagation then if dF.IsMine then eU(cT,f6,eZ[dF],eZ,function(eY)if eY.item.IsMine then return true else f0=true;return false end end)f5=true;break else f0=true end else f0=true end end end;if not f5 and f0 then eS(eZ)f0=false end end}return self end,GetSubItemTransform=function(f1)local p=f1.GetPosition()local c4=f1.GetRotation()local f7=f1.GetLocalScale()return{positionX=p.x,positionY=p.y,positionZ=p.z,rotationX=c4.x,rotationY=c4.y,rotationZ=c4.z,rotationW=c4.w,scaleX=f7.x,scaleY=f7.y,scaleZ=f7.z}end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',MessageSenderOverride='__CYTANB_MESSAGE_SENDER_OVERRIDE',MessageOriginalSender='__CYTANB_MESSAGE_ORIGINAL_SENDER',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion',LOCAL_SHARED_PROPERTY_EXPIRED_KEY='__CYTANB_LOCAL_SHARED_PROPERTY_EXPIRED'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c=a.MakeSearchPattern({'\t','\n','\v','\f','\r',' '},1,-1)d,e=(function()local f8={'A','B','C','D','E','F','a','b','c','d','e','f','0','1','2','3','4','5','6','7','8','9'}return a.MakeSearchPattern(f8,4,4),a.MakeSearchPattern(f8,8,8)end)()f=a.MakeSearchPattern({'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','_','-','.','(',')','!','~','*','\'','%'},1,-1)g={{tag=a.NegativeNumberTag,search=a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,search=a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,search=a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,search=a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}h={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}i=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})j=a.LogLevelInfo;l={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;m,n=(function()local d7='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local dd=_G[d7]if not dd then dd={}_G[d7]=dd end;local f9=dd.randomSeedValue;if not f9 then f9=os.time()-os.clock()*10000;dd.randomSeedValue=f9;math.randomseed(f9)end;local fa=dd.clientID;if type(fa)~='string'then fa=tostring(a.RandomUUID())dd.clientID=fa end;local fb=vci.state.Get(b)or''if fb==''and vci.assets.IsMine then fb=tostring(a.RandomUUID())vci.state.Set(b,fb)end;return fb,fa end)()return a end)()

local GetGameObjectTransform = function (name) return assert(vci.assets.GetTransform(name)) end
local GetSubItem = function (name) return assert(vci.assets.GetSubItem(name)) end

local settings = (function ()
    local hueSwitchName = 'hue-switch'
    local saturationSwitchName = 'saturation-switch'
    local brightnessSwitchName = 'brightness-switch'
    local alphaSwitchName = 'alpha-switch'
    local elevationSwitchName = 'elevation-switch'
    local scaleSwitchName = 'scale-switch'

    local defaultMinScaleValue = 0
    local defaultMaxScaleValue = 1

    local elevationMinScaleValue = -1
    local elevationMaxScaleValue = 1

    local scaleMinScaleValue = -5
    local scaleMaxScaleValue = 5

    return {
        enableDebugging = false,
        lsp = cytanb.CreateLocalSharedProperties('88057c29-4e07-4d95-a498-ecf93a5f0d46', tostring(cytanb.RandomUUID())),
        opaqueDomeName = 'opaque-dome',
        alphaDomeName = 'alpha-dome',
        opaqueDomeMat = 'opaque-dome-mat',
        alphaDomeMat = 'alpha-dome-mat',
        domeControllerName = 'dome-controller',
        powerLampOnRotation = Quaternion.identity,
        powerLampOffRotation = Quaternion.AngleAxis(180, Vector3.right),

        powerLampName = 'power-lamp',
        resetSwitchName = 'reset-switch',
        resetSwitchKnob = 'reset-knob',

        hueSwitchName = hueSwitchName,
        saturationSwitchName = saturationSwitchName,
        brightnessSwitchName = brightnessSwitchName,
        alphaSwitchName = alphaSwitchName,
        elevationSwitchName = elevationSwitchName,
        scaleSwitchName = scaleSwitchName,

        --- 調節用スイッチのパラメーター。
        switchParameters = cytanb.ListToMap({
            {
                colliderName = hueSwitchName,
                baseName = 'hue-knob-position',
                knobName = 'hue-knob',
                minScaleValue = defaultMinScaleValue,
                maxScaleValue = defaultMaxScaleValue
            },
            {
                colliderName = saturationSwitchName,
                baseName = 'saturation-knob-position',
                knobName = 'saturation-knob',
                minScaleValue = defaultMinScaleValue,
                maxScaleValue = defaultMaxScaleValue
            },
            {
                colliderName = brightnessSwitchName,
                baseName = 'brightness-knob-position',
                knobName = 'brightness-knob',
                minScaleValue = defaultMinScaleValue,
                maxScaleValue = defaultMaxScaleValue
            },
            {
                colliderName = alphaSwitchName,
                baseName = 'alpha-knob-position',
                knobName = 'alpha-knob',
                value = 100,
                minScaleValue = defaultMinScaleValue,
                maxScaleValue = defaultMaxScaleValue
            },
            {
                colliderName = elevationSwitchName,
                baseName = 'elevation-knob-position',
                knobName = 'elevation-knob',
                minValue = -50,
                maxValue = 50,
                value = -1,
                minScaleValue = elevationMinScaleValue,
                maxScaleValue = elevationMaxScaleValue,
                calcSwitchValue = function (switch)
                    local sv = switch.GetScaleValue(elevationMinScaleValue, elevationMaxScaleValue)
                    local av = math.abs(sv)
                    local minX = -5
                    local maxX = 5
                    local exp = (maxX - minX) * av + minX
                    return 12.5122 * (sv >= 0 and 1 or -1) * (2 ^ exp - 2 ^ minX)
                end
            },
            {
                colliderName = scaleSwitchName,
                baseName = 'scale-knob-position',
                knobName = 'scale-knob',
                value = 80,
                minScaleValue = scaleMinScaleValue,
                maxScaleValue = scaleMaxScaleValue,
                calcSwitchValue = function (switch)
                    local sv = switch.GetScaleValue(scaleMinScaleValue, scaleMaxScaleValue)
                    return 25.0244 * (2 ^ sv - 2 ^ scaleMinScaleValue)
                end
            }
        }, function (entry)
            local minValue = entry.minValue or 0
            local maxValue = entry.maxValue or 100
            local minScaleValue = entry.minScaleValue or minValue
            local maxScaleValue = entry.maxScaleValue or maxValue

            local calcSwitchValue = entry.calcSwitchValue or function (switch)
                return switch.GetScaleValue(minScaleValue, maxScaleValue)
            end

            local valueToText = entry.valueToText or function (value, source)
                return string.format('%.2f', calcSwitchValue(source))
            end

            return entry.colliderName, {
                colliderName = entry.colliderName,
                baseName = entry.baseName,
                knobName = entry.knobName,
                minValue = minValue,
                maxValue = maxValue,
                value = entry.value or 0,
                minScaleValue = minScaleValue,
                maxScaleValue = maxScaleValue,
                tickFrequency = 1,
                tickVector = Vector3.__new(0.0, 0.11 / (maxValue - minValue), 0.0),
                valueTextName = entry.colliderName .. '-value-text',
                valueToText = valueToText,
                calcSwitchValue = calcSwitchValue
            }
        end)
    }
end)()

local vciLoaded = false

local hiddenPosition

local opaqueDome = GetGameObjectTransform(settings.opaqueDomeName)
local alphaDome = GetGameObjectTransform(settings.alphaDomeName)
local powerLamp = GetGameObjectTransform(settings.powerLampName)

local controllerGlue
local resetSwitch
local slideSwitchMap, hueSwitch, saturationSwitch, brightnessSwitch, alphaSwitch, elevationSwitch, scaleSwitch

local domeStatus = {
    item = opaqueDome,
    itemMat = settings.opaqueDomeMat,
    point = Vector3.__new(0, 0, 0),
    color = Color.__new(0, 0, 0),
    elevation = 0,
    uniScale = 0,
    visible = false,
    dirty = false
}

local resetSwitchStatus = {
    clickCount = 0,
    clickTime = TimeSpan.Zero
}

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local GetSwitchParameters = function (switch)
    return assert(settings.switchParameters[switch.GetColliderItem().GetName()])
end

local CalcColorSwitchValue = function ()
    local color = Color.HSVToRGB(
        GetSwitchParameters(hueSwitch).calcSwitchValue(hueSwitch),
        GetSwitchParameters(saturationSwitch).calcSwitchValue(saturationSwitch),
        GetSwitchParameters(brightnessSwitch).calcSwitchValue(brightnessSwitch)
    )
    color.a = GetSwitchParameters(alphaSwitch).calcSwitchValue(alphaSwitch)
    return color
end

local CalcElevationSwitchValue = function ()
    return GetSwitchParameters(elevationSwitch).calcSwitchValue(elevationSwitch)
end

local CalcScaleSwitchValue = function ()
    return GetSwitchParameters(scaleSwitch).calcSwitchValue(scaleSwitch)
end

local UpdateDomeColor = function (dome, color)
    cytanb.LogTrace('update dome color: ', color)
    dome.color = color
    vci.assets.material.SetColor(dome.itemMat, color)
end

local UpdateDomeElevation = function (dome, elevation)
    cytanb.LogTrace('update dome elevation: ', elevation)
    dome.elevation = elevation
    dome.item.SetPosition(dome.visible and Vector3.__new(dome.point.x, elevation, dome.point.z) or hiddenPosition)
end

local UpdateDomeScale = function (dome, uniScale)
    cytanb.LogTrace('update dome scale: ', uniScale)
    dome.uniScale = uniScale
    dome.item.SetLocalScale(dome.visible and Vector3.__new(uniScale, uniScale, uniScale) or Vector3.zero)
end

local UpdateDomeVisible = function (dome, visible)
    cytanb.LogTrace('update dome visible: ', visible)
    dome.visible = visible
    UpdateDomeElevation(dome, dome.elevation)
    UpdateDomeScale(dome, dome.uniScale)
    powerLamp.SetLocalRotation(visible and settings.powerLampOnRotation or settings.powerLampOffRotation)
end

local FlipDome = function (dome, opaque)
    cytanb.LogTrace('flip dome: opaque = ', opaque)
    local iDome
    if opaque then
        dome.item = opaqueDome
        dome.itemMat = settings.opaqueDomeMat
        iDome = alphaDome
    else
        dome.item = alphaDome
        dome.itemMat = settings.alphaDomeMat
        iDome = opaqueDome
    end

    UpdateDomeElevation(dome, dome.elevation)
    UpdateDomeScale(dome, dome.uniScale)

    iDome.SetPosition(hiddenPosition)
    iDome.SetLocalScale(Vector3.zero)
end

local ResetDome = function (dome)
    for name, switch in pairs(slideSwitchMap) do
        switch.SetValue(GetSwitchParameters(switch).value)
    end

    FlipDome(dome, true)
    UpdateDomeElevation(dome, CalcElevationSwitchValue())
    UpdateDomeScale(dome, CalcScaleSwitchValue())
    UpdateDomeColor(dome, CalcColorSwitchValue())

    dome.dirty = false
end

local OnResetCommand = function ()
    if domeStatus.dirty then
        -- ダーティーフラグがセットされていた場合は、デフォルト値にリセットする
        domeStatus.dirty = false
        cytanb.LogTrace('Reset settings')
        ResetDome(domeStatus)
    else
        -- ダーティーフラグがセットされていない場合は、表示・非表示を切り替える
        UpdateDomeVisible(domeStatus, not domeStatus.visible)
    end
end

local UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        controllerGlue.Update()

        for name, switch in pairs(slideSwitchMap) do
            switch.Update()
        end

        if deltaTime <= TimeSpan.Zero then
            return
        end
    end,

    function ()
        cytanb.LogTrace('OnLoad')
        vciLoaded = true

        local uuid = cytanb.UUIDFromString(cytanb.InstanceID())
        hiddenPosition = Vector3.__new(uuid[1] / 0x100000, 0x1000, uuid[2] / 0x100000)

        controllerGlue = cytanb.CreateSubItemGlue()

        resetSwitch = GetSubItem(settings.resetSwitchName)
        controllerGlue.Add(GetGameObjectTransform(settings.resetSwitchKnob), resetSwitch)

        slideSwitchMap = {}
        for k, parameters in pairs(settings.switchParameters) do
            local switch = cytanb.CreateSlideSwitch(
                cytanb.Extend({
                    colliderItem = GetSubItem(parameters.colliderName),
                    baseItem = GetGameObjectTransform(parameters.baseName),
                    knobItem = GetGameObjectTransform(parameters.knobName),
                    tickFrequency = parameters.tickFrequency
                }, parameters, false, true)
            )

            slideSwitchMap[parameters.colliderName] = switch
        end

        local SwitchValueChanged = function ()
            domeStatus.dirty = true
            if not domeStatus.visible then
                UpdateDomeVisible(domeStatus, true)
            end
        end

        local hsvListener = function (source, value)
            UpdateDomeColor(domeStatus, CalcColorSwitchValue())
            SwitchValueChanged()
        end

        hueSwitch = assert(slideSwitchMap[settings.hueSwitchName])
        hueSwitch.AddListener(hsvListener)

        saturationSwitch = assert(slideSwitchMap[settings.saturationSwitchName])
        saturationSwitch.AddListener(hsvListener)

        brightnessSwitch = assert(slideSwitchMap[settings.brightnessSwitchName])
        brightnessSwitch.AddListener(hsvListener)

        alphaSwitch = assert(slideSwitchMap[settings.alphaSwitchName])
        alphaSwitch.AddListener(function (source, value)
            local color = CalcColorSwitchValue()
            if color.a == 1 then
                -- 完全に不透明
                if domeStatus.color.a ~= 1 then
                    FlipDome(domeStatus, true)
                end
            else
                if domeStatus.color.a == 1 then
                    FlipDome(domeStatus, false)
                end
            end

            UpdateDomeColor(domeStatus, color)
            SwitchValueChanged()
        end)

        elevationSwitch = assert(slideSwitchMap[settings.elevationSwitchName])
        elevationSwitch.AddListener(function (source, value)
            UpdateDomeElevation(domeStatus, CalcElevationSwitchValue())
            SwitchValueChanged()
        end)

        scaleSwitch = assert(slideSwitchMap[settings.scaleSwitchName])
        scaleSwitch.AddListener(function (source, value)
            -- cytanb.LogTrace('switch[', source.GetColliderItem().GetName(), '] value changed: ', value)
            UpdateDomeScale(domeStatus, CalcScaleSwitchValue())
            SwitchValueChanged()
        end)

        -- initialize
        ResetDome(domeStatus)
        UpdateDomeVisible(domeStatus, false)
    end
)

updateAll = function ()
    UpdateCw()
end

onGrab = function (target)
    if not vciLoaded then
        return
    end

    if target == settings.resetSwitchName then
        resetSwitchStatus.clickCount, resetSwitchStatus.clickTime = cytanb.DetectClicks(resetSwitchStatus.clickCount, resetSwitchStatus.clickTime, settings.grabClickTiming)
        if resetSwitchStatus.clickCount >= 2 then
            -- リセットスイッチを 2 回以上グラブする操作で、リセットを行う。
            -- (ユーザーは、スライドスイッチをグラブすると操作できるので、同じ入力キーで操作できるものと期待するため)
            OnResetCommand()
        end
    else
        local switch = slideSwitchMap[target]
        if switch then
            switch.DoGrab()
        end
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    local switch = slideSwitchMap[target]
    if switch then
        switch.DoUngrab()
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == settings.resetSwitchName then
        OnResetCommand()
    else
        local switch = slideSwitchMap[use]
        if switch then
            switch.DoUse()
        end
    end
end

onUnuse = function (use)
    if not vciLoaded then
        return
    end

    local switch = slideSwitchMap[use]
    if switch then
        switch.DoUnuse()
    end
end
