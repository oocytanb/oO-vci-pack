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
local cytanb=(function()local b='__CYTANB_INSTANCE_ID'local c;local d;local e;local f;local g=false;local h;local i;local a(function()local j='eff3a188-bfc7-4b0e-93cb-90fd1adc508c'local k=_G[j]if not k then k={}_G[j]=k end;local l=k.randomSeedValue;if not l then l=os.time()-os.clock()*10000;k.randomSeedValue=l;math.randomseed(l)end;return l end)()local m=function(n,o)for p=1,4 do local q=n[p]-o[p]if q~=0 then return q end end;return 0 end;local r;r={__eq=function(n,o)return n[1]==o[1]and n[2]==o[2]and n[3]==o[3]and n[4]==o[4]end,__lt=function(n,o)return m(n,o)<0 end,__le=function(n,o)return m(n,o)<=0 end,__tostring=function(s)local t=s[2]or 0;local u=s[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(s[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(t,16),0xFFFF),bit32.band(t,0xFFFF),bit32.band(bit32.rshift(u,16),0xFFFF),bit32.band(u,0xFFFF),bit32.band(s[4]or 0,0xFFFFFFFF))end,__concat=function(n,o)local v=getmetatable(n)local w=v==r or type(v)=='table'and v.__concat==r.__concat;local x=getmetatable(o)local y=x==r or type(x)=='table'and x.__concat==r.__concat;if not w and not y then error('UUID: attempt to concatenate illegal values',2)end;return(w and r.__tostring(n)or n)..(y and r.__tostring(o)or o)end}local z='__CYTANB_CONST_VARIABLES'local A=function(table,B)local C=getmetatable(table)if C then local D=rawget(C,z)if D then local E=rawget(D,B)if type(E)=='function'then return E(table,B)else return E end end end;return nil end;local F=function(table,B,G)local C=getmetatable(table)if C then local D=rawget(C,z)if D then if rawget(D,B)~=nil then error('Cannot assign to read only field "'..B..'"',2)end end end;rawset(table,B,G)end;local H=function(I,J)local K=I[a.TypeParameterName]if a.NillableHasValue(K)and a.NillableValue(K)~=J then return false,false end;return a.NillableIfHasValueOrElse(c[J],function(L)local M=L.compositionFieldNames;local N=L.compositionFieldLength;local O=false;for P,G in pairs(I)do if M[P]then N=N-1;if N<=0 and O then break end elseif P~=a.TypeParameterName then O=true;if N<=0 then break end end end;return N<=0,O end,function()return false,false end)end;local Q=function(R)return string.gsub(string.gsub(R,a.EscapeSequenceTag,a.EscapeSequenceTag..a.EscapeSequenceTag),'/',a.SolidusTag)end;local S=function(R,T)local U=string.len(R)local V=string.len(a.EscapeSequenceTag)if V>U then return R end;local W=''local p=1;while p<U do local X,Y=string.find(R,a.EscapeSequenceTag,p,true)if not X then if p==1 then W=R else W=W..string.sub(R,p)end;break end;if X>p then W=W..string.sub(R,p,X-1)end;local Z=false;for _,a0 in ipairs(d)do local a1,a2=string.find(R,a0.pattern,X)if a1 then W=W..(T and T(a0.tag)or a0.replacement)p=a2+1;Z=true;break end end;if not Z then W=W..a.EscapeSequenceTag;p=Y+1 end end;return W end;local a3;a3=function(a4,a5)if type(a4)~='table'then return a4 end;if not a5 then a5={}end;if a5[a4]then error('circular reference')end;a5[a4]=true;local a6={}for P,G in pairs(a4)do local a7=type(P)local a8;if a7=='string'then a8=Q(P)elseif a7=='number'then a8=tostring(P)..a.ArrayNumberTag else a8=P end;local a9=type(G)if a9=='string'then a6[a8]=Q(G)elseif a9=='number'and G<0 then a6[tostring(a8)..a.NegativeNumberTag]=tostring(G)else a6[a8]=a3(G,a5)end end;a5[a4]=nil;return a6 end;local aa;aa=function(a6,ab)if type(a6)~='table'then return a6 end;local a4={}for P,G in pairs(a6)do local a8;local ac=false;if type(P)=='string'then local ad=false;a8=S(P,function(ae)if ae==a.NegativeNumberTag then ac=true elseif ae==a.ArrayNumberTag then ad=true end;return nil end)if ad then a8=tonumber(a8)or a8 end else a8=P;ac=false end;if ac and type(G)=='string'then a4[a8]=tonumber(G)elseif type(G)=='string'then a4[a8]=S(G,function(ae)return e[ae]end)else a4[a8]=aa(G,ab)end end;if not ab then a.NillableIfHasValue(a4[a.TypeParameterName],function(af)a.NillableIfHasValue(c[af],function(L)local ag,O=L.fromTableFunc(a4)if not O then a.NillableIfHasValue(ag,function(s)a4=s end)end end)end)end;return a4 end;a={InstanceID=function()if i==''then i=vci.state.Get(b)or''end;return i end,NillableHasValue=function(ah)return ah~=nil end,NillableValue=function(ah)if ah==nil then error('nillable: value is nil',2)end;return ah end,NillableValueOrDefault=function(ah,ai)if ah==nil then if ai==nil then error('nillable: defaultValue is nil',2)end;return ai else return ah end end,NillableIfHasValue=function(ah,aj)if ah==nil then return nil else return aj(ah)end end,NillableIfHasValueOrElse=function(ah,aj,ak)if ah==nil then return ak()else return aj(ah)end end,SetConst=function(al,am,s)if type(al)~='table'then error('Cannot set const to non-table target',2)end;local an=getmetatable(al)local C=an or{}local ao=rawget(C,z)if rawget(al,am)~=nil then error('Non-const field "'..am..'" already exists',2)end;if not ao then ao={}rawset(C,z,ao)C.__index=A;C.__newindex=F end;rawset(ao,am,s)if not an then setmetatable(al,C)end;return al end,SetConstEach=function(al,ap)for P,G in pairs(ap)do a.SetConst(al,P,G)end;return al end,Extend=function(al,aq,ar,as,a5)if al==aq or type(al)~='table'or type(aq)~='table'then return al end;if ar then if not a5 then a5={}end;if a5[aq]then error('circular reference')end;a5[aq]=true end;for P,G in pairs(aq)do if ar and type(G)=='table'then local at=al[P]al[P]=a.Extend(type(at)=='table'and at or{},G,ar,as,a5)else al[P]=G end end;if not as then local au=getmetatable(aq)if type(au)=='table'then if ar then local av=getmetatable(al)setmetatable(al,a.Extend(type(av)=='table'and av or{},au,true))else setmetatable(al,au)end end end;if ar then a5[aq]=nil end;return al end,Vars=function(G,aw,ax,a5)local ay;if aw then ay=aw~='__NOLF'else aw='  'ay=true end;if not ax then ax=''end;if not a5 then a5={}end;local az=type(G)if az=='table'then a5[G]=a5[G]and a5[G]+1 or 1;local aA=ay and ax..aw or''local R='('..tostring(G)..') {'local aB=true;for B,aC in pairs(G)do if aB then aB=false else R=R..(ay and','or', ')end;if ay then R=R..'\n'..aA end;if type(aC)=='table'and a5[aC]and a5[aC]>0 then R=R..B..' = ('..tostring(aC)..')'else R=R..B..' = '..a.Vars(aC,aw,aA,a5)end end;if not aB and ay then R=R..'\n'..ax end;R=R..'}'a5[G]=a5[G]-1;if a5[G]<=0 then a5[G]=nil end;return R elseif az=='function'or az=='thread'or az=='userdata'then return'('..az..')'elseif az=='string'then return'('..az..') '..string.format('%q',G)else return'('..az..') '..tostring(G)end end,GetLogLevel=function()return f end,SetLogLevel=function(aD)f=aD end,IsOutputLogLevelEnabled=function()return g end,SetOutputLogLevelEnabled=function(aE)g=not not aE end,Log=function(aD,...)if aD<=f then local aF=g and(h[aD]or'LOG LEVEL '..tostring(aD))..' | 'or''local aG=table.pack(...)if aG.n==1 then local G=aG[1]if G~=nil then local R=type(G)=='table'and a.Vars(G)or tostring(G)print(g and aF..R or R)else print(aF)end else local R=aF;for p=1,aG.n do local G=aG[p]if G~=nil then R=R..(type(G)=='table'and a.Vars(G)or tostring(G))end end;print(R)end end end,LogFatal=function(...)a.Log(a.LogLevelFatal,...)end,LogError=function(...)a.Log(a.LogLevelError,...)end,LogWarn=function(...)a.Log(a.LogLevelWarn,...)end,LogInfo=function(...)a.Log(a.LogLevelInfo,...)end,LogDebug=function(...)a.Log(a.LogLevelDebug,...)end,LogTrace=function(...)a.Log(a.LogLevelTrace,...)end,FatalLog=function(...)a.LogFatal(...)end,ErrorLog=function(...)a.LogError(...)end,WarnLog=function(...)a.LogWarn(...)end,InfoLog=function(...)a.LogInfo(...)end,DebugLog=function(...)a.LogDebug(...)end,TraceLog=function(...)a.LogTrace(...)end,ListToMap=function(aH,aI)local table={}local aJ=aI==nil;for P,G in pairs(aH)do table[G]=aJ and G or aI end;return table end,Round=function(aK,aL)if aL then local aM=10^aL;return math.floor(aK*aM+0.5)/aM else return math.floor(aK+0.5)end end,Clamp=function(s,aN,aO)return math.max(aN,math.min(s,aO))end,Lerp=function(aP,aQ,az)if az<=0.0 then return aP elseif az>=1.0 then return aQ else return aP+(aQ-aP)*az end end,LerpUnclamped=function(aP,aQ,az)if az==0.0 then return aP elseif az==1.0 then return aQ else return aP+(aQ-aP)*az end end,PingPong=function(az,aR)if aR==0 then return 0 end;local aS=math.floor(az/aR)local aT=az-aS*aR;if aS<0 then if(aS+1)%2==0 then return aR-aT else return aT end else if aS%2==0 then return aT else return aR-aT end end end,VectorApproximatelyEquals=function(aU,aV)return(aU-aV).sqrMagnitude<1E-10 end,QuaternionApproximatelyEquals=function(aU,aV)local aW=Quaternion.Dot(aU,aV)return aW<1.0+1E-06 and aW>1.0-1E-06 end,
QuaternionToAngleAxis=function(aX)local aS=aX.normalized;local aY=math.acos(aS.w)local aZ=math.sin(aY)local a_=math.deg(aY*2.0)local b0;if math.abs(aZ)<=Quaternion.kEpsilon then b0=Vector3.right else local b1=1.0/aZ;b0=Vector3.__new(aS.x*b1,aS.y*b1,aS.z*b1)end;return a_,b0 end,ApplyQuaternionToVector3=function(aX,b2)local b3=aX.w*b2.x+aX.y*b2.z-aX.z*b2.y;local b4=aX.w*b2.y-aX.x*b2.z+aX.z*b2.x;local b5=aX.w*b2.z+aX.x*b2.y-aX.y*b2.x;local b6=-aX.x*b2.x-aX.y*b2.y-aX.z*b2.z;return Vector3.__new(b6*-aX.x+b3*aX.w+b4*-aX.z-b5*-aX.y,b6*-aX.y-b3*-aX.z+b4*aX.w+b5*-aX.x,b6*-aX.z+b3*-aX.y-b4*-aX.x+b5*aX.w)end,RotateAround=function(b7,b8,b9,ba)return b9+a.ApplyQuaternionToVector3(ba,b7-b9),ba*b8 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bb)return r.__tostring(bb)end,UUIDFromNumbers=function(...)local bc=...local az=type(bc)local bd,be,bf,bg;if az=='table'then bd=bc[1]be=bc[2]bf=bc[3]bg=bc[4]else bd,be,bf,bg=...end;local bb={bit32.band(bd or 0,0xFFFFFFFF),bit32.band(be or 0,0xFFFFFFFF),bit32.band(bf or 0,0xFFFFFFFF),bit32.band(bg or 0,0xFFFFFFFF)}setmetatable(bb,r)return bb end,UUIDFromString=function(R)local U=string.len(R)if U~=32 and U~=36 then return nil end;local bh='[0-9a-f-A-F]+'local bi='^('..bh..')$'local bj='^-('..bh..')$'local bk,bl,bm,bn;if U==32 then local bb=a.UUIDFromNumbers(0,0,0,0)local bo=1;for p,bp in ipairs({8,16,24,32})do bk,bl,bm=string.find(string.sub(R,bo,bp),bi)if not bk then return nil end;bb[p]=tonumber(bm,16)bo=bp+1 end;return bb else bk,bl,bm=string.find(string.sub(R,1,8),bi)if not bk then return nil end;local bd=tonumber(bm,16)bk,bl,bm=string.find(string.sub(R,9,13),bj)if not bk then return nil end;bk,bl,bn=string.find(string.sub(R,14,18),bj)if not bk then return nil end;local be=tonumber(bm..bn,16)bk,bl,bm=string.find(string.sub(R,19,23),bj)if not bk then return nil end;bk,bl,bn=string.find(string.sub(R,24,28),bj)if not bk then return nil end;local bf=tonumber(bm..bn,16)bk,bl,bm=string.find(string.sub(R,29,36),bi)if not bk then return nil end;local bg=tonumber(bm,16)return a.UUIDFromNumbers(bd,be,bf,bg)end end,ParseUUID=function(R)return a.UUIDFromString(R)end,CreateCircularQueue=function(bq)if type(bq)~='number'or bq<1 then error('Invalid argument: capacity = '..tostring(bq),2)end;local self;local br=math.floor(bq)local W={}local bs=0;local bt=0;local bu=0;self={Size=function()return bu end,Clear=function()bs=0;bt=0;bu=0 end,IsEmpty=function()return bu==0 end,Offer=function(bv)W[bs+1]=bv;bs=(bs+1)%br;if bu<br then bu=bu+1 else bt=(bt+1)%br end;return true end,OfferFirst=function(bv)bt=(br+bt-1)%br;W[bt+1]=bv;if bu<br then bu=bu+1 else bs=(br+bs-1)%br end;return true end,Poll=function()if bu==0 then return nil else local bv=W[bt+1]bt=(bt+1)%br;bu=bu-1;return bv end end,PollLast=function()if bu==0 then return nil else bs=(br+bs-1)%br;local bv=W[bs+1]bu=bu-1;return bv end end,Peek=function()if bu==0 then return nil else return W[bt+1]end end,PeekLast=function()if bu==0 then return nil else return W[(br+bs-1)%br+1]end end,Get=function(bw)if bw<1 or bw>bu then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bw)return nil end;return W[(bt+bw-1)%br+1]end,IsFull=function()return bu>=br end,MaxSize=function()return br end}return self end,DetectClicks=function(bx,by,bz)local bA=bx or 0;local bB=bz or TimeSpan.FromMilliseconds(500)local bC=vci.me.Time;local bD=by and bC>by+bB and 1 or bA+1;return bD,bC end,ColorRGBToHSV=function(bE)local aT=math.max(0.0,math.min(bE.r,1.0))local bF=math.max(0.0,math.min(bE.g,1.0))local aQ=math.max(0.0,math.min(bE.b,1.0))local aO=math.max(aT,bF,aQ)local aN=math.min(aT,bF,aQ)local bG=aO-aN;local E;if bG==0.0 then E=0.0 elseif aO==aT then E=(bF-aQ)/bG/6.0 elseif aO==bF then E=(2.0+(aQ-aT)/bG)/6.0 else E=(4.0+(aT-bF)/bG)/6.0 end;if E<0.0 then E=E+1.0 end;local bH=aO==0.0 and bG or bG/aO;local G=aO;return E,bH,G end,ColorFromARGB32=function(bI)local bJ=type(bI)=='number'and bI or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bJ,16),0xFF)/0xFF,bit32.band(bit32.rshift(bJ,8),0xFF)/0xFF,bit32.band(bJ,0xFF)/0xFF,bit32.band(bit32.rshift(bJ,24),0xFF)/0xFF)end,ColorToARGB32=function(bE)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bE.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bE.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bE.g),0xFF),8),bit32.band(a.Round(0xFF*bE.b),0xFF))end,ColorFromIndex=function(bK,bL,bM,bN,bO)local bP=math.max(math.floor(bL or a.ColorHueSamples),1)local bQ=bO and bP or bP-1;local bR=math.max(math.floor(bM or a.ColorSaturationSamples),1)local bS=math.max(math.floor(bN or a.ColorBrightnessSamples),1)local bw=a.Clamp(math.floor(bK or 0),0,bP*bR*bS-1)local bT=bw%bP;local bU=math.floor(bw/bP)local b1=bU%bR;local bV=math.floor(bU/bR)if bO or bT~=bQ then local E=bT/bQ;local bH=(bR-b1)/bR;local G=(bS-bV)/bS;return Color.HSVToRGB(E,bH,G)else local G=(bS-bV)/bS*b1/(bR-1)return Color.HSVToRGB(0.0,0.0,G)end end,ColorToIndex=function(bE,bL,bM,bN,bO)local bP=math.max(math.floor(bL or a.ColorHueSamples),1)local bQ=bO and bP or bP-1;local bR=math.max(math.floor(bM or a.ColorSaturationSamples),1)local bS=math.max(math.floor(bN or a.ColorBrightnessSamples),1)local E,bH,G=a.ColorRGBToHSV(bE)local b1=a.Round(bR*(1.0-bH))if bO or b1<bR then local bW=a.Round(bQ*E)if bW>=bQ then bW=0 end;if b1>=bR then b1=bR-1 end;local bV=math.min(bS-1,a.Round(bS*(1.0-G)))return bW+bP*(b1+bR*bV)else local bX=a.Round((bR-1)*G)if bX==0 then local bY=a.Round(bS*(1.0-G))if bY>=bS then return bP-1 else return bP*(1+a.Round(G*(bR-1)/(bS-bY)*bS)+bR*bY)-1 end else return bP*(1+bX+bR*a.Round(bS*(1.0-G*(bR-1)/bX)))-1 end end end,ColorToTable=function(bE)return{[a.TypeParameterName]=a.ColorTypeName,r=bE.r,g=bE.g,b=bE.b,a=bE.a}end,ColorFromTable=function(I)local aQ,O=H(I,a.ColorTypeName)return aQ and Color.__new(I.r,I.g,I.b,I.a)or nil,O end,Vector2ToTable=function(s)return{[a.TypeParameterName]=a.Vector2TypeName,x=s.x,y=s.y}end,Vector2FromTable=function(I)local aQ,O=H(I,a.Vector2TypeName)return aQ and Vector2.__new(I.x,I.y)or nil,O end,Vector3ToTable=function(s)return{[a.TypeParameterName]=a.Vector3TypeName,x=s.x,y=s.y,z=s.z}end,Vector3FromTable=function(I)local aQ,O=H(I,a.Vector3TypeName)return aQ and Vector3.__new(I.x,I.y,I.z)or nil,O end,Vector4ToTable=function(s)return{[a.TypeParameterName]=a.Vector4TypeName,x=s.x,y=s.y,z=s.z,w=s.w}end,Vector4FromTable=function(I)local aQ,O=H(I,a.Vector4TypeName)return aQ and Vector4.__new(I.x,I.y,I.z,I.w)or nil,O end,QuaternionToTable=function(s)return{[a.TypeParameterName]=a.QuaternionTypeName,x=s.x,y=s.y,z=s.z,w=s.w}end,QuaternionFromTable=function(I)local aQ,O=H(I,a.QuaternionTypeName)return aQ and Quaternion.__new(I.x,I.y,I.z,I.w)or nil,O end,TableToSerializable=function(a4)return a3(a4)end,TableFromSerializable=function(a6,ab)return aa(a6,ab)end,TableToSerialiable=function(a4)return a3(a4)end,TableFromSerialiable=function(a6,ab)return aa(a6,ab)end,EmitMessage=function(am,bZ)local a6=a.NillableIfHasValueOrElse(bZ,function(a4)if type(a4)~='table'then error('EmitMessage: invalid arguments: table expected',3)end;return a.TableToSerializable(a4)end,function()return{}end)a6[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(am,json.serialize(a6))end,OnMessage=function(am,aj)local b_=function(c0,c1,c2)local c3=nil;if c0.type~='comment'and type(c2)=='string'then local c4,a6=pcall(json.parse,c2)if c4 and type(a6)=='table'then c3=a.TableFromSerializable(a6)end end;local bZ=c3 and c3 or{[a.MessageValueParameterName]=c2}aj(c0,c1,bZ)end;vci.message.On(am,b_)return{Off=function()if b_ then b_=nil end end}end,OnInstanceMessage=function(am,aj)local b_=function(c0,c1,bZ)local c5=a.InstanceID()if c5~=''and c5==bZ[a.InstanceIDParameterName]then aj(c0,c1,bZ)end end;return a.OnMessage(am,b_)end,
GetEffekseerEmitterMap=function(am)local c6=vci.assets.GetEffekseerEmitters(am)if not c6 then return nil end;local c7={}for p,c8 in pairs(c6)do c7[c8.EffectName]=c8 end;return c7 end,EstimateFixedTimestep=function(c9)local ca=1.0;local cb=1000.0;local cc=TimeSpan.FromSeconds(0.02)local cd=0xFFFF;local ce=a.CreateCircularQueue(64)local cf=TimeSpan.FromSeconds(5)local cg=TimeSpan.FromSeconds(30)local ch=false;local ci=vci.me.Time;local cj=a.Random32()local ck=Vector3.__new(bit32.bor(0x400,bit32.band(cj,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cj,16),0x1FFF)),0.0)c9.SetPosition(ck)c9.SetRotation(Quaternion.identity)c9.SetVelocity(Vector3.zero)c9.SetAngularVelocity(Vector3.zero)c9.AddForce(Vector3.__new(0.0,0.0,ca*cb))local self={Timestep=function()return cc end,Precision=function()return cd end,IsFinished=function()return ch end,Update=function()if ch then return cc end;local cl=vci.me.Time-ci;local cm=cl.TotalSeconds;if cm<=Vector3.kEpsilon then return cc end;local cn=c9.GetPosition().z-ck.z;local co=cn/cm;local cp=co/cb;if cp<=Vector3.kEpsilon then return cc end;ce.Offer(cp)local cq=ce.Size()if cq>=2 and cl>=cf then local cr=0.0;for p=1,cq do cr=cr+ce.Get(p)end;local cs=cr/cq;local ct=0.0;for p=1,cq do ct=ct+(ce.Get(p)-cs)^2 end;local cu=ct/cq;if cu<cd then cd=cu;cc=TimeSpan.FromSeconds(cs)end;if cl>cg then ch=true;c9.SetPosition(ck)c9.SetRotation(Quaternion.identity)c9.SetVelocity(Vector3.zero)c9.SetAngularVelocity(Vector3.zero)end else cc=TimeSpan.FromSeconds(cp)end;return cc end}return self end,CreateSubItemGlue=function()local cv={}local self;self={Contains=function(cw,cx)return a.NillableIfHasValueOrElse(cv[cw],function(ap)return a.NillableHasValue(ap[cx])end,function()return false end)end,Add=function(cw,cy,cz)if not cw or not cy then local cA='CreateSubItemGlue.Add: INVALID ARGUMENT '..(not cw and', parent = '..tostring(cw)or'')..(not cy and', children = '..tostring(cy)or'')error(cA,2)end;local ap=a.NillableIfHasValueOrElse(cv[cw],function(cB)return cB end,function()local cB={}cv[cw]=cB;return cB end)if type(cy)=='table'then for B,aC in pairs(cy)do ap[aC]={velocityReset=not not cz}end else ap[cy]={velocityReset=not not cz}end end,Remove=function(cw,cx)return a.NillableIfHasValueOrElse(cv[cw],function(ap)if a.NillableHasValue(ap[cx])then ap[cx]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(cw)if a.NillableHasValue(cv[cw])then cv[cw]=nil;return true else return false end end,RemoveAll=function()cv={}return true end,Each=function(aj,cC)return a.NillableIfHasValueOrElse(cC,function(cw)return a.NillableIfHasValue(cv[cw],function(ap)for cx,cD in pairs(ap)do if aj(cx,cw,self)==false then return false end end end)end,function()for cw,ap in pairs(cv)do if self.Each(aj,cw)==false then return false end end end)end,Update=function(cE)for cw,ap in pairs(cv)do local cF=cw.GetPosition()local cG=cw.GetRotation()for cx,cD in pairs(ap)do if cE or cx.IsMine then if not a.QuaternionApproximatelyEquals(cx.GetRotation(),cG)then cx.SetRotation(cG)end;if not a.VectorApproximatelyEquals(cx.GetPosition(),cF)then cx.SetPosition(cF)end;if cD.velocityReset then cx.SetVelocity(Vector3.zero)cx.SetAngularVelocity(Vector3.zero)end end end end end}return self end,CreateSubItemConnector=function()local cH=function(cI,cJ,cK)cI.item=cJ;cI.position=cJ.GetPosition()cI.rotation=cJ.GetRotation()cI.initialPosition=cI.position;cI.initialRotation=cI.rotation;cI.propagation=not not cK;return cI end;local cL=function(cM)for cJ,cI in pairs(cM)do cH(cI,cJ,cI.propagation)end end;local cN=function(cO,ba,cI,cP,cQ)local cR=cO-cI.initialPosition;local cS=ba*Quaternion.Inverse(cI.initialRotation)cI.position=cO;cI.rotation=ba;for cJ,cT in pairs(cP)do if cJ~=cI.item and(not cQ or cQ(cT))then cT.position,cT.rotation=a.RotateAround(cT.initialPosition+cR,cT.initialRotation,cO,cS)cJ.SetPosition(cT.position)cJ.SetRotation(cT.rotation)end end end;local cU={}local cV=true;local cW=false;local self;self={IsEnabled=function()return cV end,SetEnabled=function(aE)cV=aE;if aE then cL(cU)cW=false end end,Contains=function(cX)return a.NillableHasValue(cU[cX])end,Add=function(cY,cZ)if not cY then error('CreateSubItemConnector.Add: INVALID ARGUMENT: subItems = '..tostring(cY),2)end;local c_=type(cY)=='table'and cY or{cY}cL(cU)cW=false;for P,cJ in pairs(c_)do cU[cJ]=cH({},cJ,not cZ)end end,Remove=function(cX)local aQ=a.NillableHasValue(cU[cX])cU[cX]=nil;return aQ end,RemoveAll=function()cU={}return true end,Each=function(aj)for cJ,cI in pairs(cU)do if aj(cJ,self)==false then return false end end end,GetItems=function()local c_={}for cJ,cI in pairs(cU)do table.insert(c_,cJ)end;return c_ end,Update=function()if not cV then return end;local d0=false;for cJ,cI in pairs(cU)do local d1=cJ.GetPosition()local d2=cJ.GetRotation()if not a.VectorApproximatelyEquals(d1,cI.position)or not a.QuaternionApproximatelyEquals(d2,cI.rotation)then if cI.propagation then if cJ.IsMine then cN(d1,d2,cU[cJ],cU,function(cT)if cT.item.IsMine then return true else cW=true;return false end end)d0=true;break else cW=true end else cW=true end end end;if not d0 and cW then cL(cU)cW=false end end}return self end,GetSubItemTransform=function(cX)local cO=cX.GetPosition()local ba=cX.GetRotation()local d3=cX.GetLocalScale()return{positionX=cO.x,positionY=cO.y,positionZ=cO.z,rotationX=ba.x,rotationY=ba.y,rotationZ=ba.z,rotationW=ba.w,scaleX=d3.x,scaleY=d3.y,scaleZ=d3.z}end,RestoreCytanbTransform=function(d4)local d1=d4.positionX and d4.positionY and d4.positionZ and Vector3.__new(d4.positionX,d4.positionY,d4.positionZ)or nil;local d2=d4.rotationX and d4.rotationY and d4.rotationZ and d4.rotationW and Quaternion.__new(d4.rotationX,d4.rotationY,d4.rotationZ,d4.rotationW)or nil;local d3=d4.scaleX and d4.scaleY and d4.scaleZ and Vector3.__new(d4.scaleX,d4.scaleY,d4.scaleZ)or nil;return d1,d2,d3 end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i=vci.state.Get(b)or''if i==''and vci.assets.IsMine then i=tostring(a.RandomUUID())vci.state.Set(b,i)end;return a end)()

local settings = {
    panelCount = 9,
    enableDebugging = false
}

local panelBase
local panelList, panelMap
local panelGlue
local resetSwitch

local vciLoaded = false

local panelBaseGrabbed = false

cytanb.SetOutputLogLevelEnabled(true)
if settings.enableDebugging then
    cytanb.SetLogLevel(cytanb.LogLevelAll)
end

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
