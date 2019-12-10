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
QuaternionToAngleAxis=function(aX)local aS=aX.normalized;local aY=math.acos(aS.w)local aZ=math.sin(aY)local a_=math.deg(aY*2.0)local b0;if math.abs(aZ)<=Quaternion.kEpsilon then b0=Vector3.right else local b1=1.0/aZ;b0=Vector3.__new(aS.x*b1,aS.y*b1,aS.z*b1)end;return a_,b0 end,ApplyQuaternionToVector3=function(aX,b2)local b3=aX.w*b2.x+aX.y*b2.z-aX.z*b2.y;local b4=aX.w*b2.y-aX.x*b2.z+aX.z*b2.x;local b5=aX.w*b2.z+aX.x*b2.y-aX.y*b2.x;local b6=-aX.x*b2.x-aX.y*b2.y-aX.z*b2.z;return Vector3.__new(b6*-aX.x+b3*aX.w+b4*-aX.z-b5*-aX.y,b6*-aX.y-b3*-aX.z+b4*aX.w+b5*-aX.x,b6*-aX.z+b3*-aX.y-b4*-aX.x+b5*aX.w)end,RotateAround=function(b7,b8,b9,ba)return b9+a.ApplyQuaternionToVector3(ba,b7-b9),ba*b8 end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return a.UUIDFromNumbers(a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32())end,UUIDString=function(bb)return r.__tostring(bb)end,UUIDFromNumbers=function(...)local bc=...local az=type(bc)local bd,be,bf,bg;if az=='table'then bd=bc[1]be=bc[2]bf=bc[3]bg=bc[4]else bd,be,bf,bg=...end;local bb={bit32.band(bd or 0,0xFFFFFFFF),bit32.band(be or 0,0xFFFFFFFF),bit32.band(bf or 0,0xFFFFFFFF),bit32.band(bg or 0,0xFFFFFFFF)}setmetatable(bb,r)return bb end,UUIDFromString=function(R)local U=string.len(R)if U~=32 and U~=36 then return nil end;local bh='[0-9a-f-A-F]+'local bi='^('..bh..')$'local bj='^-('..bh..')$'local bk,bl,bm,bn;if U==32 then local bb=a.UUIDFromNumbers(0,0,0,0)local bo=1;for p,bp in ipairs({8,16,24,32})do bk,bl,bm=string.find(string.sub(R,bo,bp),bi)if not bk then return nil end;bb[p]=tonumber(bm,16)bo=bp+1 end;return bb else bk,bl,bm=string.find(string.sub(R,1,8),bi)if not bk then return nil end;local bd=tonumber(bm,16)bk,bl,bm=string.find(string.sub(R,9,13),bj)if not bk then return nil end;bk,bl,bn=string.find(string.sub(R,14,18),bj)if not bk then return nil end;local be=tonumber(bm..bn,16)bk,bl,bm=string.find(string.sub(R,19,23),bj)if not bk then return nil end;bk,bl,bn=string.find(string.sub(R,24,28),bj)if not bk then return nil end;local bf=tonumber(bm..bn,16)bk,bl,bm=string.find(string.sub(R,29,36),bi)if not bk then return nil end;local bg=tonumber(bm,16)return a.UUIDFromNumbers(bd,be,bf,bg)end end,ParseUUID=function(R)return a.UUIDFromString(R)end,CreateCircularQueue=function(bq)if type(bq)~='number'or bq<1 then error('Invalid argument: capacity = '..tostring(bq),2)end;local self;local br=math.floor(bq)local W={}local bs=0;local bt=0;local bu=0;self={Size=function()return bu end,Clear=function()bs=0;bt=0;bu=0 end,IsEmpty=function()return bu==0 end,Offer=function(bv)W[bs+1]=bv;bs=(bs+1)%br;if bu<br then bu=bu+1 else bt=(bt+1)%br end;return true end,OfferFirst=function(bv)bt=(br+bt-1)%br;W[bt+1]=bv;if bu<br then bu=bu+1 else bs=(br+bs-1)%br end;return true end,Poll=function()if bu==0 then return nil else local bv=W[bt+1]bt=(bt+1)%br;bu=bu-1;return bv end end,PollLast=function()if bu==0 then return nil else bs=(br+bs-1)%br;local bv=W[bs+1]bu=bu-1;return bv end end,Peek=function()if bu==0 then return nil else return W[bt+1]end end,PeekLast=function()if bu==0 then return nil else return W[(br+bs-1)%br+1]end end,Get=function(bw)if bw<1 or bw>bu then a.LogError('CreateCircularQueue.Get: index is outside the range: '..bw)return nil end;return W[(bt+bw-1)%br+1]end,IsFull=function()return bu>=br end,MaxSize=function()return br end}return self end,DetectClicks=function(bx,by,bz)local bA=bx or 0;local bB=bz or TimeSpan.FromMilliseconds(500)local bC=vci.me.Time;local bD=by and bC>by+bB and 1 or bA+1;return bD,bC end,ColorRGBToHSV=function(bE)local aT=math.max(0.0,math.min(bE.r,1.0))local bF=math.max(0.0,math.min(bE.g,1.0))local aQ=math.max(0.0,math.min(bE.b,1.0))local aO=math.max(aT,bF,aQ)local aN=math.min(aT,bF,aQ)local bG=aO-aN;local E;if bG==0.0 then E=0.0 elseif aO==aT then E=(bF-aQ)/bG/6.0 elseif aO==bF then E=(2.0+(aQ-aT)/bG)/6.0 else E=(4.0+(aT-bF)/bG)/6.0 end;if E<0.0 then E=E+1.0 end;local bH=aO==0.0 and bG or bG/aO;local G=aO;return E,bH,G end,ColorFromARGB32=function(bI)local bJ=type(bI)=='number'and bI or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(bJ,16),0xFF)/0xFF,bit32.band(bit32.rshift(bJ,8),0xFF)/0xFF,bit32.band(bJ,0xFF)/0xFF,bit32.band(bit32.rshift(bJ,24),0xFF)/0xFF)end,ColorToARGB32=function(bE)return bit32.bor(bit32.lshift(bit32.band(a.Round(0xFF*bE.a),0xFF),24),bit32.lshift(bit32.band(a.Round(0xFF*bE.r),0xFF),16),bit32.lshift(bit32.band(a.Round(0xFF*bE.g),0xFF),8),bit32.band(a.Round(0xFF*bE.b),0xFF))end,ColorFromIndex=function(bK,bL,bM,bN,bO)local bP=math.max(math.floor(bL or a.ColorHueSamples),1)local bQ=bO and bP or bP-1;local bR=math.max(math.floor(bM or a.ColorSaturationSamples),1)local bS=math.max(math.floor(bN or a.ColorBrightnessSamples),1)local bw=a.Clamp(math.floor(bK or 0),0,bP*bR*bS-1)local bT=bw%bP;local bU=math.floor(bw/bP)local b1=bU%bR;local bV=math.floor(bU/bR)if bO or bT~=bQ then local E=bT/bQ;local bH=(bR-b1)/bR;local G=(bS-bV)/bS;return Color.HSVToRGB(E,bH,G)else local G=(bS-bV)/bS*b1/(bR-1)return Color.HSVToRGB(0.0,0.0,G)end end,ColorToIndex=function(bE,bL,bM,bN,bO)local bP=math.max(math.floor(bL or a.ColorHueSamples),1)local bQ=bO and bP or bP-1;local bR=math.max(math.floor(bM or a.ColorSaturationSamples),1)local bS=math.max(math.floor(bN or a.ColorBrightnessSamples),1)local E,bH,G=a.ColorRGBToHSV(bE)local b1=a.Round(bR*(1.0-bH))if bO or b1<bR then local bW=a.Round(bQ*E)if bW>=bQ then bW=0 end;if b1>=bR then b1=bR-1 end;local bV=math.min(bS-1,a.Round(bS*(1.0-G)))return bW+bP*(b1+bR*bV)else local bX=a.Round((bR-1)*G)if bX==0 then local bY=a.Round(bS*(1.0-G))if bY>=bS then return bP-1 else return bP*(1+a.Round(G*(bR-1)/(bS-bY)*bS)+bR*bY)-1 end else return bP*(1+bX+bR*a.Round(bS*(1.0-G*(bR-1)/bX)))-1 end end end,ColorToTable=function(bE)return{[a.TypeParameterName]=a.ColorTypeName,r=bE.r,g=bE.g,b=bE.b,a=bE.a}end,ColorFromTable=function(I)local aQ,O=H(I,a.ColorTypeName)return aQ and Color.__new(I.r,I.g,I.b,I.a)or nil,O end,Vector2ToTable=function(s)return{[a.TypeParameterName]=a.Vector2TypeName,x=s.x,y=s.y}end,Vector2FromTable=function(I)local aQ,O=H(I,a.Vector2TypeName)return aQ and Vector2.__new(I.x,I.y)or nil,O end,Vector3ToTable=function(s)return{[a.TypeParameterName]=a.Vector3TypeName,x=s.x,y=s.y,z=s.z}end,Vector3FromTable=function(I)local aQ,O=H(I,a.Vector3TypeName)return aQ and Vector3.__new(I.x,I.y,I.z)or nil,O end,Vector4ToTable=function(s)return{[a.TypeParameterName]=a.Vector4TypeName,x=s.x,y=s.y,z=s.z,w=s.w}end,Vector4FromTable=function(I)local aQ,O=H(I,a.Vector4TypeName)return aQ and Vector4.__new(I.x,I.y,I.z,I.w)or nil,O end,QuaternionToTable=function(s)return{[a.TypeParameterName]=a.QuaternionTypeName,x=s.x,y=s.y,z=s.z,w=s.w}end,QuaternionFromTable=function(I)local aQ,O=H(I,a.QuaternionTypeName)return aQ and Quaternion.__new(I.x,I.y,I.z,I.w)or nil,O end,TableToSerializable=function(a4)return a3(a4)end,TableFromSerializable=function(a6,ab)return aa(a6,ab)end,TableToSerialiable=function(a4)return a3(a4)end,TableFromSerialiable=function(a6,ab)return aa(a6,ab)end,EmitMessage=function(am,bZ)local table=bZ and a.TableToSerializable(bZ)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(am,json.serialize(table))end,OnMessage=function(am,aj)local b_=function(c0,c1,c2)local c3=nil;if c0.type~='comment'and type(c2)=='string'then local c4,a6=pcall(json.parse,c2)if c4 and type(a6)=='table'then c3=a.TableFromSerializable(a6)end end;local bZ=c3 and c3 or{[a.MessageValueParameterName]=c2}aj(c0,c1,bZ)end;vci.message.On(am,b_)return{Off=function()if b_ then b_=nil end end}end,OnInstanceMessage=function(am,aj)local b_=function(c0,c1,bZ)local c5=a.InstanceID()if c5~=''and c5==bZ[a.InstanceIDParameterName]then aj(c0,c1,bZ)end end;return a.OnMessage(am,b_)end,
GetEffekseerEmitterMap=function(am)local c6=vci.assets.GetEffekseerEmitters(am)if not c6 then return nil end;local c7={}for p,c8 in pairs(c6)do c7[c8.EffectName]=c8 end;return c7 end,EstimateFixedTimestep=function(c9)local ca=1.0;local cb=1000.0;local cc=TimeSpan.FromSeconds(0.02)local cd=0xFFFF;local ce=a.CreateCircularQueue(64)local cf=TimeSpan.FromSeconds(5)local cg=TimeSpan.FromSeconds(30)local ch=false;local ci=vci.me.Time;local cj=a.Random32()local ck=Vector3.__new(bit32.bor(0x400,bit32.band(cj,0x1FFF)),bit32.bor(0x400,bit32.band(bit32.rshift(cj,16),0x1FFF)),0.0)c9.SetPosition(ck)c9.SetRotation(Quaternion.identity)c9.SetVelocity(Vector3.zero)c9.SetAngularVelocity(Vector3.zero)c9.AddForce(Vector3.__new(0.0,0.0,ca*cb))local self={Timestep=function()return cc end,Precision=function()return cd end,IsFinished=function()return ch end,Update=function()if ch then return cc end;local cl=vci.me.Time-ci;local cm=cl.TotalSeconds;if cm<=Vector3.kEpsilon then return cc end;local cn=c9.GetPosition().z-ck.z;local co=cn/cm;local cp=co/cb;if cp<=Vector3.kEpsilon then return cc end;ce.Offer(cp)local cq=ce.Size()if cq>=2 and cl>=cf then local cr=0.0;for p=1,cq do cr=cr+ce.Get(p)end;local cs=cr/cq;local ct=0.0;for p=1,cq do ct=ct+(ce.Get(p)-cs)^2 end;local cu=ct/cq;if cu<cd then cd=cu;cc=TimeSpan.FromSeconds(cs)end;if cl>cg then ch=true;c9.SetPosition(ck)c9.SetRotation(Quaternion.identity)c9.SetVelocity(Vector3.zero)c9.SetAngularVelocity(Vector3.zero)end else cc=TimeSpan.FromSeconds(cp)end;return cc end}return self end,CreateSubItemGlue=function()local cv={}local self;self={Contains=function(cw,cx)return a.NillableIfHasValueOrElse(cv[cw],function(ap)return a.NillableHasValue(ap[cx])end,function()return false end)end,Add=function(cw,cy,cz)if not cw or not cy then local cA='CreateSubItemGlue.Add: INVALID ARGUMENT '..(not cw and', parent = '..tostring(cw)or'')..(not cy and', children = '..tostring(cy)or'')error(cA,2)end;local ap=a.NillableIfHasValueOrElse(cv[cw],function(cB)return cB end,function()local cB={}cv[cw]=cB;return cB end)if type(cy)=='table'then for B,aC in pairs(cy)do ap[aC]={velocityReset=not not cz}end else ap[cy]={velocityReset=not not cz}end end,Remove=function(cw,cx)return a.NillableIfHasValueOrElse(cv[cw],function(ap)if a.NillableHasValue(ap[cx])then ap[cx]=nil;return true else return false end end,function()return false end)end,RemoveParent=function(cw)if a.NillableHasValue(cv[cw])then cv[cw]=nil;return true else return false end end,RemoveAll=function()cv={}return true end,Each=function(aj,cC)return a.NillableIfHasValueOrElse(cC,function(cw)return a.NillableIfHasValue(cv[cw],function(ap)for cx,cD in pairs(ap)do if aj(cx,cw,self)==false then return false end end end)end,function()for cw,ap in pairs(cv)do if self.Each(aj,cw)==false then return false end end end)end,Update=function(cE)for cw,ap in pairs(cv)do local cF=cw.GetPosition()local cG=cw.GetRotation()for cx,cD in pairs(ap)do if cE or cx.IsMine then if not a.QuaternionApproximatelyEquals(cx.GetRotation(),cG)then cx.SetRotation(cG)end;if not a.VectorApproximatelyEquals(cx.GetPosition(),cF)then cx.SetPosition(cF)end;if cD.velocityReset then cx.SetVelocity(Vector3.zero)cx.SetAngularVelocity(Vector3.zero)end end end end end}return self end,CreateSubItemConnector=function()local cH=function(cI,cJ,cK)cI.item=cJ;cI.position=cJ.GetPosition()cI.rotation=cJ.GetRotation()cI.initialPosition=cI.position;cI.initialRotation=cI.rotation;cI.propagation=not not cK;return cI end;local cL=function(cM)for cJ,cI in pairs(cM)do cH(cI,cJ,cI.propagation)end end;local cN=function(cO,ba,cI,cP,cQ)local cR=cO-cI.initialPosition;local cS=ba*Quaternion.Inverse(cI.initialRotation)cI.position=cO;cI.rotation=ba;for cJ,cT in pairs(cP)do if cJ~=cI.item and(not cQ or cQ(cT))then cT.position,cT.rotation=a.RotateAround(cT.initialPosition+cR,cT.initialRotation,cO,cS)cJ.SetPosition(cT.position)cJ.SetRotation(cT.rotation)end end end;local cU={}local cV=true;local cW=false;local self;self={IsEnabled=function()return cV end,SetEnabled=function(aE)cV=aE;if aE then cL(cU)cW=false end end,Contains=function(cX)return a.NillableHasValue(cU[cX])end,Add=function(cY,cZ)if not cY then error('CreateSubItemConnector.Add: INVALID ARGUMENT: subItems = '..tostring(cY),2)end;local c_=type(cY)=='table'and cY or{cY}cL(cU)cW=false;for P,cJ in pairs(c_)do cU[cJ]=cH({},cJ,not cZ)end end,Remove=function(cX)local aQ=a.NillableHasValue(cU[cX])cU[cX]=nil;return aQ end,RemoveAll=function()cU={}return true end,Each=function(aj)for cJ,cI in pairs(cU)do if aj(cJ,self)==false then return false end end end,GetItems=function()local c_={}for cJ,cI in pairs(cU)do table.insert(c_,cJ)end;return c_ end,Update=function()if not cV then return end;local d0=false;for cJ,cI in pairs(cU)do local d1=cJ.GetPosition()local d2=cJ.GetRotation()if not a.VectorApproximatelyEquals(d1,cI.position)or not a.QuaternionApproximatelyEquals(d2,cI.rotation)then if cI.propagation then if cJ.IsMine then cN(d1,d2,cU[cJ],cU,function(cT)if cT.item.IsMine then return true else cW=true;return false end end)d0=true;break else cW=true end else cW=true end end end;if not d0 and cW then cL(cU)cW=false end end}return self end,GetSubItemTransform=function(cX)local cO=cX.GetPosition()local ba=cX.GetRotation()local d3=cX.GetLocalScale()return{positionX=cO.x,positionY=cO.y,positionZ=cO.z,rotationX=ba.x,rotationY=ba.y,rotationZ=ba.z,rotationW=ba.w,scaleX=d3.x,scaleY=d3.y,scaleZ=d3.z}end,RestoreCytanbTransform=function(d4)local d1=d4.positionX and d4.positionY and d4.positionZ and Vector3.__new(d4.positionX,d4.positionY,d4.positionZ)or nil;local d2=d4.rotationX and d4.rotationY and d4.rotationZ and d4.rotationW and Quaternion.__new(d4.rotationX,d4.rotationY,d4.rotationZ,d4.rotationW)or nil;local d3=d4.scaleX and d4.scaleY and d4.scaleZ and Vector3.__new(d4.scaleX,d4.scaleY,d4.scaleZ)or nil;return d1,d2,d3 end}a.SetConstEach(a,{LogLevelOff=0,LogLevelFatal=100,LogLevelError=200,LogLevelWarn=300,LogLevelInfo=400,LogLevelDebug=500,LogLevelTrace=600,LogLevelAll=0x7FFFFFFF,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,EscapeSequenceTag='#__CYTANB',SolidusTag='#__CYTANB_SOLIDUS',NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',ArrayNumberTag='#__CYTANB_ARRAY_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID',MessageValueParameterName='__CYTANB_MESSAGE_VALUE',TypeParameterName='__CYTANB_TYPE',ColorTypeName='Color',Vector2TypeName='Vector2',Vector3TypeName='Vector3',Vector4TypeName='Vector4',QuaternionTypeName='Quaternion'})a.SetConstEach(a,{ColorMapSize=a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples,FatalLogLevel=a.LogLevelFatal,ErrorLogLevel=a.LogLevelError,WarnLogLevel=a.LogLevelWarn,InfoLogLevel=a.LogLevelInfo,DebugLogLevel=a.LogLevelDebug,TraceLogLevel=a.LogLevelTrace})c={[a.ColorTypeName]={compositionFieldNames=a.ListToMap({'r','g','b','a'}),compositionFieldLength=4,toTableFunc=a.ColorToTable,fromTableFunc=a.ColorFromTable},[a.Vector2TypeName]={compositionFieldNames=a.ListToMap({'x','y'}),compositionFieldLength=2,toTableFunc=a.Vector2ToTable,fromTableFunc=a.Vector2FromTable},[a.Vector3TypeName]={compositionFieldNames=a.ListToMap({'x','y','z'}),compositionFieldLength=3,toTableFunc=a.Vector3ToTable,fromTableFunc=a.Vector3FromTable},[a.Vector4TypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.Vector4ToTable,fromTableFunc=a.Vector4FromTable},[a.QuaternionTypeName]={compositionFieldNames=a.ListToMap({'x','y','z','w'}),compositionFieldLength=4,toTableFunc=a.QuaternionToTable,fromTableFunc=a.QuaternionFromTable}}d={{tag=a.NegativeNumberTag,pattern='^'..a.NegativeNumberTag,replacement=''},{tag=a.ArrayNumberTag,pattern='^'..a.ArrayNumberTag,replacement=''},{tag=a.SolidusTag,pattern='^'..a.SolidusTag,replacement='/'},{tag=a.EscapeSequenceTag,pattern='^'..a.EscapeSequenceTag..a.EscapeSequenceTag,replacement=a.EscapeSequenceTag}}e=a.ListToMap({a.NegativeNumberTag,a.ArrayNumberTag})f=a.LogLevelInfo;h={[a.LogLevelFatal]='FATAL',[a.LogLevelError]='ERROR',[a.LogLevelWarn]='WARN',[a.LogLevelInfo]='INFO',[a.LogLevelDebug]='DEBUG',[a.LogLevelTrace]='TRACE'}package.loaded['cytanb']=a;i=vci.state.Get(b)or''if i==''and vci.assets.IsMine then i=tostring(a.RandomUUID())vci.state.Set(b,i)end;return a end)()

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

    local kinematicVelocityMagnitude = totalSec > Vector3.kEpsilon and totalVelocityMagnitude / totalSec or 0
    -- cytanb.LogTrace('kinematicVelocityMagnitude: ', kinematicVelocityMagnitude)

    if kinematicVelocityMagnitude > settings.ballKinematicVelocityThreshold then
        local altitudeAdjustment = CalcAdjustment(propertyNameSwitchMap[settings.ballAltitudeAdjustmentPropertyName].GetValue(), settings.ballKinematicMinAltitudeFactor, settings.ballKinematicMaxAltitudeFactor)
        local velocityFactor = CalcAdjustment(propertyNameSwitchMap[settings.ballVelocityAdjustmentPropertyName].GetValue(), settings.ballKinematicMinVelocityFactor, settings.ballKinematicMaxVelocityFactor)
        local velocityMagnitude = velocityFactor * kinematicVelocityMagnitude
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
                cytanb.NillableIfHasValue(standLights[i], function (light)
                    BuildStandLight(light)
                end)
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
        if not source.position then
            return
        end

        local nillableLight, index = StandLightFromName(parameterMap.target.name)
        cytanb.NillableIfHasValue(nillableLight, function (light)
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

                if efkLevel >= 3 or (efkLevel >= 1 and not ballStatus.grabbed) then
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
        ballStatus.gravityFactor = CalcGravityFactor()
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
        cytanb.NillableIfHasValue((StandLightFromName(target)), function (light)
            light.status.grabbed = true
        end)
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
        cytanb.NillableIfHasValue(nillableLight, function (light)
            cytanb.LogTrace('ungrab ', target, ', index = ', index)
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
        end)
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
            cytanb.NillableIfHasValue((StandLightFromName(item)), function (light)
                if light.item.IsMine and not light.status.grabbed then
                    EmitHitStandLight(light, hit)
                end
            end)
        end
    end
end

onTriggerEnter = function (item, hit)
    if not vciLoaded then
        return
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
            cytanb.TraceLog('onTriggerEnter: colorPaletteCollisionCount = ', discernibleColorStatus.paletteCollisionCount, ' hit = ', hit)
        end
    end)
end
