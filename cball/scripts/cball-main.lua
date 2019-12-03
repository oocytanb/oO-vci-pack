--[[
MIT License

Copyright (c) 2019 oO (https://github.com/oocytanb)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()math.randomseed(os.time()-os.clock()*10000)local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local a;local j=function(k,l)for m=1,4 do local n=k[m]-l[m]if n~=0 then return n end end;return 0 end;local o;o={__eq=function(k,l)return k[1]==l[1]and k[2]==l[2]and k[3]==l[3]and k[4]==l[4]end,__lt=function(k,l)return j(k,l)<0 end,__le=function(k,l)return j(k,l)<=0 end,__tostring=function(p)local q=p[2]or 0;local r=p[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(p[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(q,16),0xFFFF),bit32.band(q,0xFFFF),bit32.band(bit32.rshift(r,16),0xFFFF),bit32.band(r,0xFFFF),bit32.band(p[4]or 0,0xFFFFFFFF))end,__concat=function(k,l)local s=getmetatable(k)local t=s==o or type(s)=='table'and s.__concat==o.__concat;local u=getmetatable(l)local v=u==o or type(u)=='table'and u.__concat==o.__concat;if not t and not v then error('UUID: attempt to concatenate illegal values',2)end;return(t and o.__tostring(k)or k)..(v and o.__tostring(l)or l)end}local w='__CYTANB_CONST_VARIABLES'local x=function(table,y)local z=getmetatable(table)if z then local A=rawget(z,w)if A then local B=rawget(A,y)if type(B)=='function'then return B(table,y)else return B end end end;return nil end;local C=function(table,y,D)local z=getmetatable(table)if z then local A=rawget(z,w)if A then if rawget(A,y)~=nil then error('Cannot assign to read only field "'..y..'"',2)end end end;rawset(table,y,D)end;local E=function(F,G)local H=F[a.TypeParameterName]if a.NillableHasValue(H)and a.NillableValue(H)~=G then return false,false end;local I=c[G]if not a.NillableHasValue(I)then return false,false end;local J=a.NillableValue(I)local K=J.compositionFieldNames;local L=J.compositionFieldLength;local M=false;for N,D in pairs(F)do if K[N]then L=L-1;if L<=0 and M then break end elseif N~=a.TypeParameterName then M=true;if L<=0 then break end end end;return L<=0,M end;local O=function(P)return string.gsub(string.gsub(P,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local Q=function(P,R)local S=string.len(P)local T=string.len(a.EscapeSequenceTag)if T>S then return P end;local U=''local m=1;while m<S do local V,W=string.find(P,a.EscapeSequenceTag,m,true)if not V then if m==1 then U=P else U=U..string.sub(P,m)end;break end;if V>m then U=U..string.sub(P,m,V-1)end;local X=false;for Y,Z in ipairs(d)do local _,a0=string.find(P,Z.pattern,V)if _ then U=U..(R and R(Z.tag)or Z.replacement)m=a0+1;X=true;break end end;if not X then U=U..a.EscapeSequenceTag;m=W+1 end end;return U end;local a1;a1=function(a2,a3)if type(a2)~='table'then return a2 end;if not a3 then a3={}end;if a3[a2]then error('circular reference')end;a3[a2]=true;local a4={}for N,D in pairs(a2)do local a5=type(N)local a6;if a5=='string'then a6=O(N)elseif a5=='number'then a6=tostring(N)..a.ArrayNumberTag else a6=N end;local a7=type(D)if a7=='string'then a4[a6]=O(D)elseif a7=='number'and D<0 then a4[tostring(a6)..a.NegativeNumberTag]=tostring(D)else a4[a6]=a1(D,a3)end end;a3[a2]=nil;return a4 end;local a8;a8=function(a4,a9)if type(a4)~='table'then return a4 end;local a2={}for N,D in pairs(a4)do local a6;local aa=false;if type(N)=='string'then local ab=false;a6=Q(N,function(ac)if ac==a.NegativeNumberTag then aa=true elseif ac==a.ArrayNumberTag then ab=true end;return nil end)if ab then a6=tonumber(a6)or a6 end else a6=N;aa=false end;if aa and type(D)=='string'then a2[a6]=tonumber(D)elseif type(D)=='string'then a2[a6]=Q(D,function(ac)return e[ac]end)else a2[a6]=a8(D,a9)end end;local H=a2[a.TypeParameterName]if not a9 and a.NillableHasValue(H)then local I=c[a.NillableValue(H)]if a.NillableHasValue(I)then local ad,M=a.NillableValue(I).fromTableFunc(a2)if a.NillableHasValue(ad)and not M then return a.NillableValue(ad)end end end;return a2 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(ae)return ae~=nil end,NillableValue=function(ae)if ae==nil then error('nillable: value is nil',2)end;return ae end,NillableValueOrDefault=function(ae,af)if ae==nil then if af==nil then error('nillable: defaultValue is nil',2)end;return af else return ae end end,SetConst=function(ag,ah,p)if type(ag)~='table'then error('Cannot set const to non-table target',2)end;local ai=getmetatable(ag)local z=ai or{}local aj=rawget(z,w)if rawget(ag,ah)~=nil then error('Non-const field "'..ah..'" already exists',2)end;if not aj then aj={}rawset(z,w,aj)z.__index=x;z.__newindex=C end;rawset(aj,ah,p)if not ai then setmetatable(ag,z)end;return ag end,SetConstEach=function(ag,ak)for N,D in pairs(ak)do a.SetConst(ag,N,D)end;return ag end,Extend=function(ag,al,am,an,a3)if ag==al or type(ag)~='table'or type(al)~='table'then return ag end;if am then if not a3 then a3={}end;if a3[al]then error('circular reference')end;a3[al]=true end;for N,D in pairs(al)do if am and type(D)=='table'then local ao=ag[N]ag[N]=a.Extend(type(ao)=='table'and ao or{},D,am,an,a3)else ag[N]=D end end;if not an then local ap=getmetatable(al)if type(ap)=='table'then if am then local aq=getmetatable(ag)setmetatable(ag,a.Extend(type(aq)=='table'and aq or{},ap,true))else setmetatable(ag,ap)end end end;if am then a3[al]=nil end;return ag end,Vars=function(D,ar,as,a3)local at;if ar then at=ar~='__NOLF'else ar='  'at=true end;if not as then as=''end;if not a3 then a3={}end;local au=type(D)if au=='table'then a3[D]=a3[D]and a3[D]+1 or 1;local av=at and as..ar or''local P='('..tostring(D)..') {'local aw=true;for y,ax in pairs(D)do if aw then aw=false else P=P..(at and','or', ')end;if at then P=P..'\n'..av end;if type(ax)=='table'and a3[ax]and a3[ax]>0 then P=P..y..' = ('..tostring(ax)..')'else P=P..y..' = '..a.Vars(ax,ar,av,a3)end end;if not aw and at then P=P..'\n'..as end;P=P..'}'a3[D]=a3[D]-1;if a3[D]<=0 then a3[D]=nil end;return P elseif au=='function'or au=='thread'or au=='userdata'then return'('..au..')'elseif au=='string'then return'('..au..') '..string.format('%q',D)else return'('..au..') '..tostring(D)end end,GetLogLevel=function()return f end,SetLogLevel=function(ay)f=ay end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(az)g=not not az end,Log=function(ay,...)if ay<=f then local aA=g and(h[ay]or'LOG LEVEL '..tostring(ay))..' | 'or''local aB=table.pack(...)if aB.n==1 then local D=aB[1]if D~=nil then local P=type(D)=='table'and a.Vars(D)or tostring(D)print(g and aA..P or P)else print(aA)end else local P=aA;for m=1,aB.n do local D=aB[m]if D~=nil then P=P..(type(D)=='table'and a.Vars(D)or tostring(D))end end;print(P)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aC,aD)local table={}local aE=aD==nil;for N,D in pairs(aC)do table[D]=aE and D or aD end;return table end,Round=function(aF,aG)if aG then local aH=10^aG;return math.floor(aF*aH+0.5)/aH else return math.floor(aF+0.5)end end,Clamp=function(p,aI,aJ)return math.max(aI,math.min(p,aJ))end,Lerp=function(aK,aL,au)if au<=0.0 then return aK elseif au>=1.0 then return aL else return aK+(aL-aK)*au end end,LerpUnclamped=function(aK,aL,au)if au==0.0 then return aK elseif au==1.0 then return aL else return aK+(aL-aK)*au end end,
PingPong=function(au,aM)if aM==0 then return 0 end;local aN=math.floor(au/aM)local aO=au-aN*aM;if aN<0 then if(aN+1)%2==0 then return aM-aO else return aO end else if aN%2==0 then return aO else return aM-aO end end end,VectorApproximatelyEquals=function(aP,aQ)return(aP-aQ).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aP,aQ)local aR=Quaternion.Dot(aP,aQ)return aR<1.0+1E-06 and aR>1.0-1E-06 end,QuaternionToAngleAxis=function(aS)local aN=aS.normalized;local aT=math.acos(aN.w)local aU=math.sin(aT)local aV=math.deg(aT*2.0)local aW;if math.abs(aU)<=Quaternion.kEpsilon then aW=Vector3.right else local aX=1.0/aU;aW=Vector3.__new(aN.x*aX,aN.y*aX,aN.z*aX)end;return aV,aW end,ApplyQuaternionToVector3=function(aS,aY)local aZ=aS.w*aY.x+aS.y*aY.z-aS.z*aY.y;local a_=aS.w*aY.y-aS.x*aY.z+aS.z*aY.x;local b0=aS.w*aY.z+aS.x*aY.y-aS.y*aY.x;local b1=-aS.x*aY.x-aS.y*aY.y-aS.z*aY.z;return Vector3.__new(b1*-aS.x+aZ*aS.w+a_*-aS.z-b0*-aS.y,b1*-aS.y-aZ*-aS.z+a_*aS.w+b0*-aS.x,b1*-aS.z+aZ*-aS.y-a_*-aS.x+b0*aS.w)end,RotateAround=function(b2,b3,b4,b5)return b4+a.ApplyQuaternionToVector3(b5,b2-b4),b5*b3 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(b6)return o.__tostring(b6)end,UUIDFromNumbers=function(...)local b7=...local au=type(b7)local b8,b9,ba,bb;if au=='table'then b8=b7[1]b9=b7[2]ba=b7[3]bb=b7[4]else b8,b9,ba,bb=...end;local b6={bit32.band(b8 or 0,0xFFFFFFFF),bit32.band(b9 or 0,0xFFFFFFFF),bit32.band(ba or 0,0xFFFFFFFF),bit32.band(bb or 0,0xFFFFFFFF)}setmetatable(b6,o)return b6 end,UUIDFromString=function(P)local S=string.len(P)if S~=32 and S~=36 then return nil end;local bc='[0-9a-f-A-F]+'local bd='^('..bc..')$'local be='^-('..bc..')$'local bf,bg,bh,bi;if S==32 then local b6=a.UUIDFromNumbers(0,0,0,0)local bj=1;for m,bk in ipairs({8,16,24,32})do bf,bg,bh=string.find(string.sub(P,bj,bk),bd)if not bf then return nil end;b6[m]=tonumber(bh,16)bj=bk+1 end;return b6 else bf,bg,bh=string.find(string.sub(P,1,8),bd)if not bf then return nil end;local b8=tonumber(bh,16)bf,bg,bh=string.find(string.sub(P,9,13),be)if not bf then return nil end;bf,bg,bi=string.find(string.sub(P,14,18),be)if not bf then return nil end;local b9=tonumber(bh..bi,16)bf,bg,bh=string.find(string.sub(P,19,23),be)if not bf then return nil end;bf,bg,bi=string.find(string.sub(P,24,28),be)if not bf then return nil end;local ba=tonumber(bh..bi,16)bf,bg,bh=string.find(string.sub(P,29,36),bd)if not bf then return nil end;local bb=tonumber(bh,16)return a.UUIDFromNumbers(b8,b9,ba,bb)end end,ParseUUID=function(P)return a.UUIDFromString(P)end,CreateCircularQueue=function(bl)if type(bl)~='number'or bl<1 then error('Invalid argument: capacity = '..tostring(bl),2)end;local self;local bm=math.floor(bl)local U={}local bn=0;local bo=0;local bp=0;self={Size=function()return bp end,Clear=function()bn=0;bo=0;bp=0 end,IsEmpty=function()return bp==0 end,Offer=function(bq)U[bn+1]=bq;bn=(bn+1)%bm;if bp<bm then bp=bp+1 else bo=(bo+1)%bm end;return true end,OfferFirst=function(bq)bo=(bm+bo-1)%bm;U[bo+1]=bq;if bp<bm then bp=bp+1 else bn=(bm+bn-1)%bm end;return true end,Poll=function()if bp==0 then return nil else local bq=U[bo+1]bo=(bo+1)%bm;bp=bp-1;return bq end end,PollLast=function()if bp==0 then return nil else bn=(bm+bn-1)%bm;local bq=U[bn+1]bp=bp-1;return bq end end,Peek=function()if bp==0 then return nil else return U[bo+1]end end,PeekLast=function()if bp==0 then return nil else return U[(bm+bn-1)%bm+1]end end,Get=function(br)if br<1 or br>bp then a.LogError('CreateCircularQueue.Get: index is outside the range: '..br)return nil end;return U[(bo+br-1)%bm+1]end,IsFull=function()return bp>=bm end,MaxSize=function()return bm end}return self end,DetectClicks=function(bs,bt,bu)local bv=bs or 0;local bw=bu or TimeSpan.FromMilliseconds(500)local bx=vci.me.Time;local by=bt and bx>bt+bw and 1 or bv+1;return by,bx end,ColorRGBToHSV=function(bz)local aO=math.max(0.0,math.min(bz.r,1.0))local bA=math.max(0.0,math.min(bz.g,1.0))local aL=math.max(0.0,math.min(bz.b,1.0))local aJ=math.max(aO,bA,aL)local aI=math.min(aO,bA,aL)local bB=aJ-aI;local B;if bB==0.0 then B=0.0 elseif aJ==aO then B=(bA-aL)/bB/6.0 elseif aJ==bA then B=(2.0+(aL-aO)/bB)/6.0 else B=(4.0+(aO-bA)/bB)/6.0 end;if B<0.0 then B=B+1.0 end;local bC=aJ==0.0 and bB or bB/aJ;local D=aJ;return B,bC,D end,ColorFromARGB32=function(bD)local bE=type(bD)=='number'and bD or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bE,16),0xFF)/0xFF,bit32.band(bit32.rshift(bE,8),0xFF)/0xFF,bit32.band(bE,0xFF)/0xFF,bit32.band(bit32.rshift(bE,24),0xFF)/0xFF)end,ColorToARGB32=function(bz)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bz.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bz.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bz.g),0xFF),8),bit32.band(a.Round(0xFF*bz.b),0xFF))end,ColorFromIndex=function(bF,bG,bH,bI,bJ)local bK=math.max(math.floor(bG or a.ColorHueSamples),1)local bL=bJ and bK or bK-1;local bM=math.max(math.floor(bH or a.ColorSaturationSamples),1)local bN=math.max(math.floor(bI or a.ColorBrightnessSamples),1)local br=a.Clamp(math.floor(bF or 0),0,bK*bM*bN-1)local bO=br%bK;local bP=math.floor(br/bK)local aX=bP%bM;local bQ=math.floor(bP/bM)if bJ or bO~=bL then local B=bO/bL;local bC=(bM-aX)/bM;local D=(bN-bQ)/bN;return Color.HSVToRGB(B,bC,D)else local D=(bN-bQ)/bN*aX/(bM-1)return Color.HSVToRGB(0.0,0.0,D)end end,ColorToIndex=function(bz,bG,bH,bI,bJ)local bK=math.max(math.floor(bG or a.ColorHueSamples),1)local bL=bJ and bK or bK-1;local bM=math.max(math.floor(bH or a.ColorSaturationSamples),1)local bN=math.max(math.floor(bI or a.ColorBrightnessSamples),1)local B,bC,D=a.ColorRGBToHSV(bz)local aX=a.Round(bM*(1.0-bC))if bJ or aX<bM then local bR=a.Round(bL*B)if bR>=bL then bR=0 end;if aX>=bM then aX=bM-1 end;local bQ=math.min(bN-1,a.Round(bN*(1.0-D)))return bR+bK*(aX+bM*bQ)else local bS=a.Round((bM-1)*D)if bS==0 then local bT=a.Round(bN*(1.0-D))if bT>=bN then return bK-1 else return bK*(1+a.Round(D*(bM-1)/(bN-bT)*bN)+bM*bT)-1 end else return bK*(1+bS+bM*a.Round(bN*(1.0-D*(bM-1)/bS)))-1 end end end,ColorToTable=function(bz)return{[a.TypeParameterName]=a.ColorTypeName,r=bz.r,g=bz.g,b=bz.b,a=bz.a}end,ColorFromTable=function(F)local aL,M=E(F,a.ColorTypeName)return aL and Color.__new(F.r,F.g,F.b,F.a)or nil,M end,Vector2ToTable=function(p)return{[a.TypeParameterName]=a.Vector2TypeName,x=p.x,y=p.y}end,Vector2FromTable=function(F)local aL,M=E(F,a.Vector2TypeName)return aL and Vector2.__new(F.x,F.y)or nil,M end,Vector3ToTable=function(p)return{[a.TypeParameterName]=a.Vector3TypeName,x=p.x,y=p.y,z=p.z}end,Vector3FromTable=function(F)local aL,M=E(F,a.Vector3TypeName)return aL and Vector3.__new(F.x,F.y,F.z)or nil,M end,Vector4ToTable=function(p)return{[a.TypeParameterName]=a.Vector4TypeName,x=p.x,y=p.y,z=p.z,w=p.w}end,Vector4FromTable=function(F)local aL,M=E(F,a.Vector4TypeName)return aL and Vector4.__new(F.x,F.y,F.z,F.w)or nil,M end,QuaternionToTable=function(p)return{[a.TypeParameterName]=a.QuaternionTypeName,x=p.x,y=p.y,z=p.z,w=p.w}end,QuaternionFromTable=function(F)local aL,M=E(F,a.QuaternionTypeName)return aL and Quaternion.__new(F.x,F.y,F.z,F.w)or nil,M end,
TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ah,bU)local table=bU and a.TableToSerializable(bU)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ah,json.serialize(table))end,OnMessage=function(ah,bV)local bW=function(bX,bY,bZ)local b_=nil;if bX.type~='comment'and type(bZ)=='string'then local c0,a4=pcall(json.parse,bZ)if c0 and type(a4)=='table'then b_=a.TableFromSerializable(a4)end end;local bU=b_ and b_ or{[a.MessageValueParameterName]=bZ}bV(bX,bY,bU)end;vci.message.On(ah,bW)return{Off=function()if bW then bW=nil end end}end,OnInstanceMessage=function(ah,bV)local bW=function(bX,bY,bU)local c1=a.InstanceID()if c1~=''and c1==bU[a.InstanceIDParameterName]then bV(bX,bY,bU)end end;return a.OnMessage(ah,bW)end,GetEffekseerEmitterMap=function(ah)local c2=vci.assets.GetEffekseerEmitters(ah)if not c2 then return nil end;local c3={}for m,c4 in pairs(c2)do c3[c4.EffectName]=c4 end;return c3 end,EstimateFixedTimestep=function(c5)local c6=1.0;local c7=1000.0;local c8=TimeSpan.FromSeconds(0.02)local c9=0xFFFF;local ca=a.CreateCircularQueue(64)local cb=TimeSpan.FromSeconds(5)local cc=TimeSpan.FromSeconds(30)local cd=false;local ce=vci.me.Time;local cf=a.Random32()local cg=Vector3.__new(bit32.bor(0x400,bit32.band(cf,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cf,16),0x1FFF)),0.0)c5.SetPosition(cg)c5.SetRotation(Quaternion.identity)c5.SetVelocity(Vector3.zero)c5.SetAngularVelocity(Vector3.zero)c5.AddForce(Vector3.__new(0.0,0.0,c6*c7))local self={Timestep=function()return c8 end,Precision=function()return c9 end,IsFinished=function()return cd end,Update=function()if cd then return c8 end;local ch=vci.me.Time-ce;local ci=ch.TotalSeconds;if ci<=Vector3.kEpsilon then return c8 end;local cj=c5.GetPosition().z-cg.z;local ck=cj/ci;local cl=ck/c7;if cl<=Vector3.kEpsilon then return c8 end;ca.Offer(cl)local cm=ca.Size()if cm>=2 and ch>=cb then local cn=0.0;for m=1,cm do cn=cn+ca.Get(m)end;local co=cn/cm;local cp=0.0;for m=1,cm do cp=cp+(ca.Get(m)-co)^2 end;local cq=cp/cm;if cq<c9 then c9=cq;c8=TimeSpan.FromSeconds(co)end;if ch>cc then cd=true;c5.SetPosition(cg)c5.SetRotation(Quaternion.identity)c5.SetVelocity(Vector3.zero)c5.SetAngularVelocity(Vector3.zero)end else c8=TimeSpan.FromSeconds(cl)end;return c8 end}return self end,CreateSubItemConnector=function()local cr=function(cs,ct,cu)cs.item=ct;cs.position=ct.GetPosition()cs.rotation=ct.GetRotation()cs.initialPosition=cs.position;cs.initialRotation=cs.rotation;cs.propagation=not not cu;return cs end;local cv=function(cw)for ct,cs in pairs(cw)do cr(cs,ct,cs.propagation)end end;local cx=function(cy,b5,cs,cz,cA)local cB=cy-cs.initialPosition;local cC=b5*Quaternion.Inverse(cs.initialRotation)cs.position=cy;cs.rotation=b5;for ct,cD in pairs(cz)do if ct~=cs.item and(not cA or cA(cD))then cD.position,cD.rotation=a.RotateAround(cD.initialPosition+cB,cD.initialRotation,cy,cC)ct.SetPosition(cD.position)ct.SetRotation(cD.rotation)end end end;local cE={}local cF=true;local cG=false;local self={IsEnabled=function()return cF end,SetEnabled=function(az)cF=az;if az then cv(cE)cG=false end end,Contains=function(cH)return a.NillableHasValue(cE[cH])end,GetItems=function()local cI={}for ct,cs in pairs(cE)do table.insert(cI,ct)end;return cI end,Add=function(cJ,cK)if not cJ then error('CreateSubItemConnector.Add: INVALID ARGUMENT: subItems = '..tostring(cJ))end;local cI=type(cJ)=='table'and cJ or{cJ}cv(cE)cG=false;for N,ct in pairs(cI)do cE[ct]=cr({},ct,not cK)end end,Remove=function(cH)local aL=a.NillableHasValue(cE[cH])cE[cH]=nil;return aL end,RemoveAll=function()cE={}return true end,Update=function()if not cF then return end;local cL=false;for ct,cs in pairs(cE)do local cM=ct.GetPosition()local cN=ct.GetRotation()if not a.VectorApproximatelyEquals(cM,cs.position)or not a.QuaternionApproximatelyEquals(cN,cs.rotation)then if cs.propagation then if ct.IsMine then cx(cM,cN,cE[ct],cE,function(cD)if cD.item.IsMine then return true else cG=true;return false end end)cL=true;break else cG=true end else cG=true end end end;if not cL and cG then cv(cE)cG=false end end}return self end,GetSubItemTransform=function(cH)local cy=cH.GetPosition()local b5=cH.GetRotation()local cO=cH.GetLocalScale()return{positionX=cy.x,positionY=cy.y,positionZ=cy.z,rotationX=b5.x,rotationY=b5.y,rotationZ=b5.z,rotationW=b5.w,scaleX=cO.x,scaleY=cO.y,scaleZ=cO.z}end,RestoreCytanbTransform=function(cP)local cM=cP.positionX and cP.positionY and cP.positionZ and Vector3.__new(cP.positionX,cP.positionY,cP.positionZ)or nil;local cN=cP.rotationX and cP.rotationY and cP.rotationZ and cP.rotationW and Quaternion.__new(cP.rotationX,cP.rotationY,cP.rotationZ,cP.rotationW)or nil;local cO=cP.scaleX and cP.scaleY and cP.scaleZ and Vector3.__new(cP.scaleX,cP.scaleY,cP.scaleZ)or nil;return cM,cN,cO end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i=vci.state.Get(b)or''if i==''and vci.assets.IsMine then i=tostring(a.RandomUUID())vci.state.Set(b,i)end;return a end)()

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

local settings = require('cball-settings').Load(_ENV, tostring(cytanb.RandomUUID()))

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
local settingsPanel, closeSwitch, adjustmentSwitches, propertyNameSwitchMap

local ballStatus = {
    --- ボールがつかまれているか。
    grabbed = false,

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
    clickTime = TimeSpan.Zero
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

local CreateAdjustmentSwitch = function (switchName, knobName, propertyName)
    local knob = cytanb.NillableValue(vci.assets.GetSubItem(knobName))
    local initialKnobPosition = knob.GetLocalPosition()
    local defaultValue = math.floor(cytanb.Clamp(settings[propertyName], -5, 5))
    local value = defaultValue
    local grabCount = 0
    local grabTime = TimeSpan.Zero

    local self
    self = {
        item = cytanb.NillableValue(vci.assets.GetSubItem(switchName)),

        GetValue = function ()
            return value
        end,

        DoInput = function (byGrab)
            if byGrab then
                -- Grab による入力の場合は、移動させるためにつかんだ時の誤操作を避けるために、2クリック以上で入力を受け付ける
                grabCount, grabTime = cytanb.DetectClicks(grabCount, grabTime, settings.settingsPanelGrabClickTiming)
                if grabCount <= 1 then
                    return
                end
            end
            local inputCount = settings.localSharedProperties.GetProperty(propertyName, defaultValue) + 1
            settings.localSharedProperties.SetProperty(propertyName, inputCount)
        end,

        Update = function ()
            local inputCount = settings.localSharedProperties.GetProperty(propertyName, defaultValue)
            value = cytanb.PingPong(inputCount + 5, 10) - 5
            knob.SetLocalPosition(Vector3.__new(initialKnobPosition.x, settings.settingsPanelAdjustmentSwitchNeutralPositionY + value * settings.settingsPanelAdjustmentSwitchDivisionScale, initialKnobPosition.z))
            cytanb.LogInfo('on update[', switchName, ']: value = ', value)
        end
    }
    self.Update()
    return self
end

local CalcAdjustment = function (adjustmentValue, min, max)
    -- max - min を 100% とし、adjustmentValue を割合として計算するr。
    return min + (max - min) * 0.5 * cytanb.Clamp(1 + adjustmentValue / 5.0, 0.0, 2.0)
end

local CalcGravityFactor = function ()
    return - CalcAdjustment(propertyNameSwitchMap[settings.ballGravityAdjustmentPropertyName].GetValue(), settings.ballMinGravityFactor, settings.ballMaxGravityFactor)
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
            local efkLevel = propertyNameSwitchMap[settings.efkLevelPropertyName].GetValue()
            if efkLevel >= 4 then
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
        clientID = settings.localSharedProperties.GetClientID(),
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
            hitSourceID = settings.localSharedProperties.GetClientID()
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
        if ls.hitSourceID == settings.localSharedProperties.GetClientID() then
            -- スコアを更新
            local propertyName = ls.directHit and settings.scoreDirectHitCountPropertyName or settings.scoreHitCountPropertyName
            local score = (settings.localSharedProperties.GetProperty(propertyName) or 0) + 1
            settings.localSharedProperties.SetProperty(propertyName, score)
            cytanb.LogInfo(propertyName, ': ', score)
        end

        local efkLevel = propertyNameSwitchMap[settings.efkLevelPropertyName].GetValue()
        if efkLevel == 0 and ball.IsMine then
            -- レベル 0 で、ボールの操作権があるときは、レベル 1 のエフェクトを表示する
            efkLevel = 1
        end

        if efkLevel >= 1 then
            local efk = ls.directHit and standLightDirectHitEfk or standLightHitEfk
            cytanb.LogTrace('play efk: ', efk.EffectName, ',', li.GetName())
            standLightEfkContainer.SetPosition(li.GetPosition())
            efk.Play()
            efk.SetAllColor(ballDiscernibleEfkPlayer.GetColor())
        end

        local volume = cytanb.Clamp(0.0, (propertyNameSwitchMap[settings.audioVolumePropertyName].GetValue() + 5) / 10.0, 1.0)
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

    local detectionSec = CalcAdjustment(propertyNameSwitchMap[settings.ballKinematicDetectionTimePropertyName].GetValue(), settings.ballKinematicMinDetectionTime.TotalSeconds, settings.ballKinematicMaxDetectionTime.TotalSeconds)
    -- cytanb.LogTrace('detectionSec = ', detectionSec)

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

    local velocityMagnitude
    if totalSec > Vector3.kEpsilon then
        local velocityFactor = CalcAdjustment(propertyNameSwitchMap[settings.ballVelocityAdjustmentPropertyName].GetValue(), settings.ballKinematicMinVelocityFactor, settings.ballKinematicMaxVelocityFactor)
        velocityMagnitude = velocityFactor * totalVelocityMagnitude / totalSec
    else
        velocityMagnitude = 0
    end

    -- cytanb.LogTrace('velocity magnitude: ', velocityMagnitude)
    if velocityMagnitude > settings.ballKinematicVelocityThreshold then
        local altitudeAdjustment = CalcAdjustment(propertyNameSwitchMap[settings.ballAltitudeAdjustmentPropertyName].GetValue(), settings.ballKinematicMinAltitudeFactor, settings.ballKinematicMaxAltitudeFactor)
        local velocity = ApplyAltitudeAngle(velocityDirection.normalized, altitudeAdjustment) * velocityMagnitude
        local forwardOffset = velocity * (math.min(velocityMagnitude * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset) / velocityMagnitude)

        local angularVelocityFactor = CalcAdjustment(propertyNameSwitchMap[settings.ballAngularVelocityAdjustmentPropertyName].GetValue(), settings.ballKinematicMinAngularVelocityFactor, settings.ballKinematicMaxAngularVelocityFactor)
        local angularVelocity = CalcAngularVelocity(angularVelocityDirection.normalized, angularVelocityFactor * totalAngle, totalSec)

        cytanb.LogTrace('Throw ball by kinematic: velocity: ', velocity, ', velocity.magnitude: ', velocity.magnitude, ', angularVelocity: ', angularVelocity, ', angularVelocity.magnitude: ', angularVelocity.magnitude, ', fixedTimestep: ', fixedTimestep.TotalSeconds)
        ballStatus.simAngularVelocity = angularVelocity
        ball.SetVelocity(velocity)
        ball.SetAngularVelocity(angularVelocity)

        -- 体のコライダーに接触しないように、オフセットを足す
        ballPos = ball.GetPosition() + forwardOffset
        ball.SetPosition(ballPos)
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
    local forwardScale = CalcAdjustment(propertyNameSwitchMap[settings.ballVelocityAdjustmentPropertyName].GetValue(), settings.ballInpactMinVelocityScale, settings.ballInpactMaxVelocityScale) * impactStatus.forceGaugeRatio
    local forwardOffset = forward * math.min(forwardScale * settings.ballForwardOffsetFactor, settings.ballMaxForwardOffset)
    local velocity = ApplyAltitudeAngle(forward * forwardScale, CalcAdjustment(propertyNameSwitchMap[settings.ballAltitudeAdjustmentPropertyName].GetValue(), settings.ballInpactMinAltitudeScale, settings.ballInpactMaxAltitudeScale))

    ballStatus.simAngularVelocity = Vector3.up * (CalcAdjustment(propertyNameSwitchMap[settings.ballAngularVelocityAdjustmentPropertyName].GetValue(), settings.ballInpactMinAngularVelocityScale, settings.ballInpactMaxAngularVelocityScale) * math.pi * impactStatus.spinGaugeRatio)
    cytanb.LogTrace('velocity: ', velocity, ', velociyt.magnitude: ', velocity.magnitude, ', angularVelocity: ', ballStatus.simAngularVelocity, ', angularVelocity.magnitude: ', ballStatus.simAngularVelocity.magnitude)

    ball.SetVelocity(velocity)
    ball.SetAngularVelocity(ballStatus.simAngularVelocity)

    -- 体のコライダーに接触しないように、オフセットを足す
    local ballPos = ball.GetPosition() + forwardOffset
    ball.SetPosition(ballPos)

    ballStatus.transformQueue.Clear()
    OfferBallTransform(ballPos, ball.GetRotation())
end

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    settings.localSharedProperties.UpdateAlive()
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

    closeSwitch = cytanb.NillableValue(vci.assets.GetSubItem(settings.closeSwitchName))

    propertyNameSwitchMap = {}
    adjustmentSwitches = {}
    for index, entry in ipairs(settings.adjustmentSwitchNames) do
        local switch = CreateAdjustmentSwitch(entry.switchName, entry.knobName, entry.propertyName)
        propertyNameSwitchMap[entry.propertyName] = switch
        adjustmentSwitches[entry.switchName] = switch
    end

    ballStatus.gravityFactor = CalcGravityFactor()

    settings.localSharedProperties.AddListener(function (eventName, key, value, oldValue)
        if eventName == settings.localSharedProperties.propertyChangeEventName then
            -- cytanb.LogInfo('localSharedProperties: on ', eventName, ', key = ', key, ', value = ', value)
            local switch = propertyNameSwitchMap[key]
            if switch then
                switch.Update()
            end
        elseif eventName == settings.localSharedProperties.expiredEventName then
            cytanb.LogInfo('localSharedProperties: on ', eventName)
            -- 期限切れとなったので、アンロード処理をする
            vciLoaded = false
        else
            cytanb.LogInfo('localSharedProperties: unknown event: ', eventName)
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
                clientID = settings.localSharedProperties.GetClientID(),
                discernibleColor = cytanb.ColorToTable(ballDiscernibleEfkPlayer.GetColor()),
                ball = CreateBallStatusParameter(),
                standLights = standLightsParameter
            })
        end)
    end

    cytanb.OnMessage(statusMessageName, function (sender, name, parameterMap)
        if parameterMap[cytanb.InstanceIDParameterName] == cytanb.InstanceID() then
            if parameterMap.clientID ~= settings.localSharedProperties.GetClientID() then
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
        if parameterMap.clientID ~= settings.localSharedProperties.GetClientID() then
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
                local nillableLight = standLights[i]
                if cytanb.NillableHasValue(nillableLight) then
                    BuildStandLight(cytanb.NillableValue(nillableLight))
                end
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
        local nillableLight, index = StandLightFromName(parameterMap.target.name)
        if not source.position or not cytanb.NillableHasValue(nillableLight) then
            return
        end

        local light = cytanb.NillableValue(nillableLight)
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

                if li.IsMine and not ls.grabbed and parameterMap.hitSourceID ~= settings.localSharedProperties.GetClientID() then
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

    -- 設定パネルを表示する
    cytanb.OnInstanceMessage(showSettingsPanelMessageName, function (sender, name, parameterMap)
        if not settingsPanel.IsMine then
            return
        end

        local cupPosition = ballCup.GetPosition()
        if Vector3.Distance(cupPosition, settingsPanel.GetPosition()) > settings.settingsPanelDistanceThreshold then
            -- 設定パネルが離れていた場合は、近づけて表示する。
            local position = cupPosition + settings.settingsPanelOffset
            cytanb.LogTrace('ShowSettingsPanel: posotion = ', position)
            settingsPanel.SetPosition(position)
            settingsPanel.SetRotation(Quaternion.LookRotation(Vector3.__new(- settings.settingsPanelOffset.x, 0, - settings.settingsPanelOffset.z)))
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
        local lastTransform = ballStatus.transformQueue.PeekLast()
        local lastPos = lastTransform.position

        -- カップとの距離が離れていたら、ボールが転がっているものとして処理する
        local cupSqrDistance = (ballPos - ballCup.GetPosition()).sqrMagnitude
        if cupSqrDistance > settings.ballActiveThreshold ^ 2 then
            if vci.me.Time <= impactStatus.gaugeStartTime + settings.ballWaitingTime and cupSqrDistance <= settings.ballPlayAreaRadius ^ 2 then
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
                        local rf = settings.ballSimAngularFactor * settings.ballSimMass * ballStatus.simAngularVelocity.y * deltaSec / fixedTimestep.TotalSeconds
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
                        local forceY = settings.ballSimMass * ballStatus.gravityFactor * deltaSec / fixedTimestep.TotalSeconds
                        ball.AddForce(Vector3.__new(0, forceY, 0))
                    end
                end

                local efkLevel = propertyNameSwitchMap[settings.efkLevelPropertyName].GetValue()
                if efkLevel == 0 and ball.IsMine then
                    -- レベル 0 で、ボールの操作権があるときは、レベル 1 のエフェクトを表示する
                    efkLevel = 1
                end

                if efkLevel >= 1 then
                    local vm = velocity.magnitude
                    if vm >= settings.ballTrailVelocityThreshold then
                        local near = cupSqrDistance <= settings.ballNearDistance ^ 2
                        local vmNodes = math.max(1, math.ceil(vm / (settings.ballSimLongSide * settings.ballTrailInterpolationDistanceFactor * (near and 0.5 or 1.0) / deltaSec)))
                        local nodes = math.min(vmNodes, settings.ballTrailInterpolationNodesPerFrame + cytanb.Clamp(math.floor((efkLevel - 1 + (near and 1 or 0)) * 2), 0, 4))
                        local iNodes = 1.0 / nodes
                        local efk
                        if near then
                            -- 近距離の場合は、エフェクトレベルに合わせる
                            if efkLevel >= 3 then
                                efk = ballEfkFadeMove
                            elseif efkLevel == 2 then
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
                cytanb.LogTrace('elapsed: ' , (vci.me.Time - impactStatus.gaugeStartTime).TotalSeconds, ', sqrDistance: ', cupSqrDistance)
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
    settings.localSharedProperties.UpdateAlive()

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
        local nillableLight = StandLightFromName(target)
        if cytanb.NillableHasValue(nillableLight) then
            local light = cytanb.NillableValue(nillableLight)
            light.status.grabbed = true
        end
    elseif adjustmentSwitches[target] then
        adjustmentSwitches[target].DoInput(true)
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
        if cytanb.NillableHasValue(nillableLight) then
            cytanb.LogTrace('ungrab ', target, ', index = ', index)
            local light = cytanb.NillableValue(nillableLight)
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
                    clientID = settings.localSharedProperties.GetClientID(),
                    standLights = {
                        [index] = {
                            respawnPosition = cytanb.Vector3ToTable(ls.respawnPosition)
                        }
                    }
                })
            end
        end
    elseif target == settingsPanel.GetName() then
        settingsPanelGrabbed = false
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
    elseif adjustmentSwitches[use] then
        adjustmentSwitches[use].DoInput(false)
    end
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
            local nillableLight = StandLightFromName(item)
            if cytanb.NillableHasValue(nillableLight) then
                local light = cytanb.NillableValue(nillableLight)
                if light.item.IsMine and not light.status.grabbed then
                    EmitHitStandLight(light, hit)
                end
            end
        end
    end
end

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
    end

    local nillablePicker = colorPickers[item]
    if cytanb.NillableHasValue(nillablePicker) then
        local picker = cytanb.NillableValue(nillablePicker)
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
    end
end
