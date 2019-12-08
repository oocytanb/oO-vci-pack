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
TableToSerializable=function(a2)return a1(a2)end,TableFromSerializable=function(a4,a9)return a8(a4,a9)end,TableToSerialiable=function(a2)return a1(a2)end,TableFromSerialiable=function(a4,a9)return a8(a4,a9)end,EmitMessage=function(ah,bU)local table=bU and a.TableToSerializable(bU)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(ah,json.serialize(table))end,OnMessage=function(ah,bV)local bW=function(bX,bY,bZ)local b_=nil;if bX.type~='comment'and type(bZ)=='string'then local c0,a4=pcall(json.parse,bZ)if c0 and type(a4)=='table'then b_=a.TableFromSerializable(a4)end end;local bU=b_ and b_ or{[a.MessageValueParameterName]=bZ}bV(bX,bY,bU)end;vci.message.On(ah,bW)return{Off=function()if bW then bW=nil end end}end,OnInstanceMessage=function(ah,bV)local bW=function(bX,bY,bU)local c1=a.InstanceID()if c1~=''and c1==bU[a.InstanceIDParameterName]then bV(bX,bY,bU)end end;return a.OnMessage(ah,bW)end,GetEffekseerEmitterMap=function(ah)local c2=vci.assets.GetEffekseerEmitters(ah)if not c2 then return nil end;local c3={}for m,c4 in pairs(c2)do c3[c4.EffectName]=c4 end;return c3 end,EstimateFixedTimestep=function(c5)local c6=1.0;local c7=1000.0;local c8=TimeSpan.FromSeconds(0.02)local c9=0xFFFF;local ca=a.CreateCircularQueue(64)local cb=TimeSpan.FromSeconds(5)local cc=TimeSpan.FromSeconds(30)local cd=false;local ce=vci.me.Time;local cf=a.Random32()local cg=Vector3.__new(bit32.bor(0x400,bit32.band(cf,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cf,16),0x1FFF)),0.0)c5.SetPosition(cg)c5.SetRotation(Quaternion.identity)c5.SetVelocity(Vector3.zero)c5.SetAngularVelocity(Vector3.zero)c5.AddForce(Vector3.__new(0.0,0.0,c6*c7))local self={Timestep=function()return c8 end,Precision=function()return c9 end,IsFinished=function()return cd end,Update=function()if cd then return c8 end;local ch=vci.me.Time-ce;local ci=ch.TotalSeconds;if ci<=Vector3.kEpsilon then return c8 end;local cj=c5.GetPosition().z-cg.z;local ck=cj/ci;local cl=ck/c7;if cl<=Vector3.kEpsilon then return c8 end;ca.Offer(cl)local cm=ca.Size()if cm>=2 and ch>=cb then local cn=0.0;for m=1,cm do cn=cn+ca.Get(m)end;local co=cn/cm;local cp=0.0;for m=1,cm do cp=cp+(ca.Get(m)-co)^2 end;local cq=cp/cm;if cq<c9 then c9=cq;c8=TimeSpan.FromSeconds(co)end;if ch>cc then cd=true;c5.SetPosition(cg)c5.SetRotation(Quaternion.identity)c5.SetVelocity(Vector3.zero)c5.SetAngularVelocity(Vector3.zero)end else c8=TimeSpan.FromSeconds(cl)end;return c8 end}return self end,CreateSubItemGlue=function()local cr={}local self={Contains=function(cs,ct)local cu=cr[cs]return a.NillableHasValue(cu)and a.NillableHasValue(a.NillableValue(cu)[ct])end,Add=function(cs,cv,cw)if not cs or not cv then local cx='CreateSubItemGlue.Add: INVALID ARGUMENT '..(not cs and', parent = '..tostring(cs)or'')..(not cv and', children = '..tostring(cv)or'')error(cx,2)end;local cu=cr[cs]if not a.NillableHasValue(cu)then cu={}cr[cs]=cu end;local Z=a.NillableValue(cu)if type(cv)=='table'then for y,ax in pairs(cv)do Z[ax]={velocityReset=not not cw}end else Z[cv]={velocityReset=not not cw}end end,RemoveParent=function(cs)if not a.NillableHasValue(cr[cs])then return false end;cr[cs]=nil;return true end,RemoveChild=function(cs,ct)local cu=cr[cs]if not a.NillableHasValue(cu)then return false end;local Z=a.NillableValue(cu)if not a.NillableHasValue(Z[ct])then return false end;Z[ct]=nil;return true end,RemoveAll=function()cr={}return true end,Update=function(cy)for cs,Z in pairs(cr)do local cz=cs.GetPosition()local cA=cs.GetRotation()for ct,cB in pairs(Z)do if cy or ct.IsMine then if ct.GetRotation()~=cA then ct.SetRotation(cA)end;if ct.GetPosition()~=cz then ct.SetPosition(cz)end;if cB.velocityReset then ct.SetVelocity(Vector3.zero)ct.SetAngularVelocity(Vector3.zero)end end end end end}return self end,CreateSubItemConnector=function()local cC=function(cD,cE,cF)cD.item=cE;cD.position=cE.GetPosition()cD.rotation=cE.GetRotation()cD.initialPosition=cD.position;cD.initialRotation=cD.rotation;cD.propagation=not not cF;return cD end;local cG=function(cH)for cE,cD in pairs(cH)do cC(cD,cE,cD.propagation)end end;local cI=function(cJ,b5,cD,cK,cL)local cM=cJ-cD.initialPosition;local cN=b5*Quaternion.Inverse(cD.initialRotation)cD.position=cJ;cD.rotation=b5;for cE,cO in pairs(cK)do if cE~=cD.item and(not cL or cL(cO))then cO.position,cO.rotation=a.RotateAround(cO.initialPosition+cM,cO.initialRotation,cJ,cN)cE.SetPosition(cO.position)cE.SetRotation(cO.rotation)end end end;local cP={}local cQ=true;local cR=false;local self={IsEnabled=function()return cQ end,SetEnabled=function(az)cQ=az;if az then cG(cP)cR=false end end,Contains=function(cS)return a.NillableHasValue(cP[cS])end,GetItems=function()local cT={}for cE,cD in pairs(cP)do table.insert(cT,cE)end;return cT end,Add=function(cU,cV)if not cU then error('CreateSubItemConnector.Add: INVALID ARGUMENT: subItems = '..tostring(cU),2)end;local cT=type(cU)=='table'and cU or{cU}cG(cP)cR=false;for N,cE in pairs(cT)do cP[cE]=cC({},cE,not cV)end end,Remove=function(cS)local aL=a.NillableHasValue(cP[cS])cP[cS]=nil;return aL end,RemoveAll=function()cP={}return true end,Update=function()if not cQ then return end;local cW=false;for cE,cD in pairs(cP)do local cX=cE.GetPosition()local cY=cE.GetRotation()if not a.VectorApproximatelyEquals(cX,cD.position)or not a.QuaternionApproximatelyEquals(cY,cD.rotation)then if cD.propagation then if cE.IsMine then cI(cX,cY,cP[cE],cP,function(cO)if cO.item.IsMine then return true else cR=true;return false end end)cW=true;break else cR=true end else cR=true end end end;if not cW and cR then cG(cP)cR=false end end}return self end,GetSubItemTransform=function(cS)local cJ=cS.GetPosition()local b5=cS.GetRotation()local cZ=cS.GetLocalScale()return{positionX=cJ.x,positionY=cJ.y,positionZ=cJ.z,rotationX=b5.x,rotationY=b5.y,rotationZ=b5.z,rotationW=b5.w,scaleX=cZ.x,scaleY=cZ.y,scaleZ=cZ.z}end,RestoreCytanbTransform=function(c_)local cX=c_.positionX and c_.positionY and c_.positionZ and Vector3.__new(c_.positionX,c_.positionY,c_.positionZ)or nil;local cY=c_.rotationX and c_.rotationY and c_.rotationZ and c_.rotationW and Quaternion.__new(c_.rotationX,c_.rotationY,c_.rotationZ,c_.rotationW)or nil;local cZ=c_.scaleX and c_.scaleY and c_.scaleZ and Vector3.__new(c_.scaleX,c_.scaleY,c_.scaleZ)or nil;return cX,cY,cZ end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i=vci.state.Get(b)or''if i==''and vci.assets.IsMine then i=tostring(a.RandomUUID())vci.state.Set(b,i)end;return a end)()


local settings = {
    panelCount = 9
}

local panelBase
local panelList, panelMap
local panelGlue
local resetSwitch

local vciLoaded = false

local panelBaseGrabbed = false

local OnLoad = function ()
    cytanb.LogTrace('OnLoad')
    vciLoaded = true

    panelBase = cytanb.NillableValue(vci.assets.GetSubItem('nine-panel-base'))

    panelList = {}
    panelMap = {}
    panelGlue = cytanb.CreateSubItemGlue()
    for i = 1, settings.panelCount do
        local name = 'panel#cytanb-target#' .. i

        local panel = {
            index = i,
            name = name,
            item = cytanb.NillableValue(vci.assets.GetSubItem(name)),
            posItem = cytanb.NillableValue(vci.assets.GetSubItem('panel-pos-' .. i))
        }

        panelList[i] = panel
        panelMap[panel.name] = panel

        panelGlue.Add(panel.posItem, panel.item, true)
    end

    resetSwitch = cytanb.NillableValue(vci.assets.GetSubItem('reset-switch'))
end

local OnUpdate = function (deltaTime, unscaledDeltaTime)
    if deltaTime <= TimeSpan.Zero then
        return
    end

    if panelBaseGrabbed then
        panelGlue.Update()
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
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end

    if target == panelBase.GetName() then
        panelBaseGrabbed = false
        panelGlue.Update()
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    if use == resetSwitch.GetName() or use == panelBase.GetName() then
        panelGlue.Update()
    end
end
