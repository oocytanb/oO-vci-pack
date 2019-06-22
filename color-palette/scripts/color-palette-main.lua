----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()math.randomseed(os.time()-os.clock()*10000)local b='__CYTANB_INSTANCE_ID'local c=400;local d;local a;a={InstanceID=function()if d==''then d=vci.state.Get(b)or''end;return d end,SetConst=function(e,f,g)if type(e)~='table'then error('Cannot set const to non-table target')end;local h=getmetatable(e)local i=h or{}local j=type(i.__index)=='table'if e[f]~=nil and(not j or i.__index[f]==nil)then error('Non-const field "'..f..'" already exists')end;if not j then i.__index={}end;local k=i.__index;k[f]=g;if not j or type(i.__newindex)~='function'then i.__newindex=function(table,l,m)if table==e and k[l]~=nil then error('Cannot assign to read only field "'..l..'"')end;rawset(table,l,m)end end;if not h then setmetatable(e,i)end;return e end,Extend=function(e,n,o,p,q)if e==n or type(e)~='table'or type(n)~='table'then return e end;if o then if not q then q={}end;if q[n]then error('circular reference')end;q[n]=true end;for r,m in pairs(n)do if o and type(m)=='table'then local s=e[r]e[r]=a.Extend(type(s)=='table'and s or{},m,o,p,q)else e[r]=m end end;if not p then local t=getmetatable(n)if type(t)=='table'then if o then local u=getmetatable(e)setmetatable(e,a.Extend(type(u)=='table'and u or{},t,true))else setmetatable(e,t)end end end;if o then q[n]=nil end;return e end,Vars=function(m,v,w,q)local x;if v then x=v~='__NOLF'else v='  'x=true end;if not w then w=''end;if not q then q={}end;local y=type(m)if y=='table'then q[m]=q[m]and q[m]+1 or 1;local z=x and w..v or''local A='('..tostring(m)..') {'local B=true;for l,C in pairs(m)do if B then B=false else A=A..(x and','or', ')end;if x then A=A..'\n'..z end;if type(C)=='table'and q[C]and q[C]>0 then A=A..l..' = ('..tostring(C)..')'else A=A..l..' = '..a.Vars(C,v,z,q)end end;if not B and x then A=A..'\n'..w end;A=A..'}'q[m]=q[m]-1;if q[m]<=0 then q[m]=nil end;return A elseif y=='function'or y=="thread"or y=="userdata"then return'('..y..')'elseif y=='string'then return'('..y..') '..string.format('%q',m)else return'('..y..') '..tostring(m)end end,GetLogLevel=function()return c end,SetLogLevel=function(D)c=D end,Log=function(D,...)if D<=c then local E=table.pack(...)if E.n==1 then local m=E[1]if m~=nil then print(type(m)=='table'and a.Vars(m)or tostring(m))else print('')end else local A=''for F=1,E.n do local m=E[F]if m~=nil then A=A..(type(m)=='table'and a.Vars(m)or tostring(m))end end;print(A)end end end,FatalLog=function(...)a.Log(a.FatalLogLevel,...)end,ErrorLog=function(...)a.Log(a.ErrorLogLevel,...)end,WarnLog=function(...)a.Log(a.WarnLogLevel,...)end,InfoLog=function(...)a.Log(a.InfoLogLevel,...)end,DebugLog=function(...)a.Log(a.DebugLogLevel,...)end,TraceLog=function(...)a.Log(a.TraceLogLevel,...)end,ListToMap=function(G,H)local table={}local I=H==nil;for r,m in pairs(G)do table[m]=I and m or H end;return table end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return{a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32()}end,UUIDString=function(J)local K=J[2]or 0;local L=J[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(J[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(K,16),0xFFFF),bit32.band(K,0xFFFF),bit32.band(bit32.rshift(L,16),0xFFFF),bit32.band(L,0xFFFF),bit32.band(J[4]or 0,0xFFFFFFFF))end,ParseUUID=function(A)local M=string.len(A)if M~=32 and M~=36 then return nil end;local N='[0-9a-f-A-F]+'local O='^('..N..')$'local P='^-('..N..')$'local J={}local Q,R,S,T;if M==32 then local U=1;for F,V in ipairs({8,16,24,32})do Q,R,S=string.find(string.sub(A,U,V),O)if not Q then return nil end;J[F]=tonumber(S,16)U=V+1 end else Q,R,S=string.find(string.sub(A,1,8),O)if not Q then return nil end;J[1]=tonumber(S,16)Q,R,S=string.find(string.sub(A,9,13),P)if not Q then return nil end;Q,R,T=string.find(string.sub(A,14,18),P)if not Q then return nil end;J[2]=tonumber(S..T,16)Q,R,S=string.find(string.sub(A,19,23),P)if not Q then return nil end;Q,R,T=string.find(string.sub(A,24,28),P)if not Q then return nil end;J[3]=tonumber(S..T,16)Q,R,S=string.find(string.sub(A,29,36),O)if not Q then return nil end;J[4]=tonumber(S,16)end;return J end,ColorFromARGB32=function(W)local X=type(W)=='number'and W or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(X,16),0xFF)/0xFF,bit32.band(bit32.rshift(X,8),0xFF)/0xFF,bit32.band(X,0xFF)/0xFF,bit32.band(bit32.rshift(X,24),0xFF)/0xFF)end,ColorToARGB32=function(Y)return bit32.bor(bit32.lshift(math.floor(255*Y.a+0.5),24),bit32.lshift(math.floor(255*Y.r+0.5),16),bit32.lshift(math.floor(255*Y.g+0.5),8),math.floor(255*Y.b+0.5))end,ColorFromIndex=function(Z,_,a0,a1,a2)local a3=math.max(math.floor(_ or a.ColorHueSamples),1)local a4=a2 and a3 or a3-1;local a5=math.max(math.floor(a0 or a.ColorSaturationSamples),1)local a6=math.max(math.floor(a1 or a.ColorBrightnessSamples),1)local a7=math.max(math.min(math.floor(Z or 0),a3*a5*a6-1),0)local a8=a7%a3;local a9=math.floor(a7/a3)local aa=a9%a5;local ab=math.floor(a9/a5)if a2 or a8~=a4 then local ac=a8/a4;local ad=(a5-aa)/a5;local m=(a6-ab)/a6;return Color.HSVToRGB(ac,ad,m)else local m=(a6-ab)/a6*aa/(a5-1)return Color.HSVToRGB(0.0,0.0,m)end end,GetSubItemTransform=function(ae)local af=ae.GetPosition()local ag=ae.GetRotation()local ah=ae.GetLocalScale()return{positionX=af.x,positionY=af.y,positionZ=af.z,rotationX=ag.x,rotationY=ag.y,rotationZ=ag.z,rotationW=ag.w,scaleX=ah.x,scaleY=ah.y,scaleZ=ah.z}end,TableToSerializable=function(ai,q)if type(ai)~='table'then return ai end;if not q then q={}end;if q[ai]then error('circular reference')end;q[ai]=true;local aj={}for r,m in pairs(ai)do if type(m)=='number'and m<0 then aj[r..a.NegativeNumberTag]=tostring(m)else aj[r]=a.TableToSerializable(m,q)end end;q[ai]=nil;return aj end,TableFromSerializable=function(aj)if type(aj)~='table'then return aj end;local ai={}for r,m in pairs(aj)do if type(m)=='string'and string.endsWith(r,a.NegativeNumberTag)then ai[string.sub(r,1,#r-#a.NegativeNumberTag)]=tonumber(m)else ai[r]=a.TableFromSerializable(m)end end;return ai end,EmitMessage=function(f,ak)local table=ak and a.TableToSerializable(ak)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(f,json.serialize(table))end,OnMessage=function(f,al)local am=function(an,ao,ap)local ak;if ap==''then ak={}else local aq,aj=pcall(json.parse,ap)if not aq or type(aj)~='table'then a.TraceLog('Invalid message format: ',ap)return end;ak=a.TableFromSerializable(aj)end;al(an,ao,ak)end;vci.message.On(f,am)return{Off=function()if am then am=nil end end}end}a:SetConst('FatalLogLevel',100):SetConst('ErrorLogLevel',200):SetConst('WarnLogLevel',300):SetConst('InfoLogLevel',400):SetConst('DebugLogLevel',500):SetConst('TraceLogLevel',600):SetConst('ColorHueSamples',10):SetConst('ColorSaturationSamples',4):SetConst('ColorBrightnessSamples',5):SetConst('ColorMapSize',a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples):SetConst('NegativeNumberTag','#__CYTANB_NEGATIVE_NUMBER'):SetConst('InstanceIDParameterName','__CYTANB_INSTANCE_ID')package.loaded['cytanb']=a;if vci.assets.IsMine then d=a.UUIDString(a.RandomUUID())vci.state.Set(b,d)else d=''end;return a end)()

--- カラーパレットの共有変数の名前空間。
local ColorPaletteSharedNS = 'com.github.oocytanb.cytanb-tso-collab.color-palette'

--- パレットで選択した色を格納する共有変数名。別の VCI から色を取得可能。ARGB 32 bit 値。
local ARGB32SharedName = ColorPaletteSharedNS .. '.argb32'

--- パレットで選択した色のインデックス値を格納する共有変数名。
local ColorIndexSharedName = ColorPaletteSharedNS .. '.color-index'

--- カラーパレットのメッセージの名前空間。
local ColorPaletteMessageNS = 'cytanb.color-palette'

--- メッセージフォーマットのバージョン。
local MessageVersion = 0x10000

--- メッセージフォーマットの最小バージョン。
local MinMessageVersion = 0x10000

--- アイテムのステータスを問い合わせるメッセージ名。
local QueryStatusMessageName = ColorPaletteMessageNS .. '.query-status'

--- アイテムのステータスを通知するメッセージ名。
local ItemStatusMessageName = ColorPaletteMessageNS .. '.item-status'

--- カラーピッカーのタグ。
local ColorPickerTag = '#cytanb-color-picker'

local ColorIndexPrefix = 'cytanb-color-index-'
local CurrentColorMaterialName = 'current-color-mat'

local HitIndexStateName = 'hit-index-state'

local PaletteMaterialName = 'color-palette-mat'
local PalettePageHeight = 200.0 / 1024.0

local AllowedPickerList = {'HandPointMarker', 'RightArm', 'LeftArm', 'RightHand', 'LeftHand'}
local AllowedPickerMap = cytanb.ListToMap(AllowedPickerList, true)

local UpdatePeriod = TimeSpan.FromMilliseconds(100)

local PaletteBase = vci.assets.GetSubItem('palette-base')

--- スイッチ類
local advancedSwitch, pickerSwitch, opacitySwitch, brightnessSwitch

local function CreateSwitch(name, maxState, defaultState, advancedFunction, uvHeight, panelColor, inputInterval)
	local materialName = name .. '-mat'
	local stateName = name .. '-state'
	local default = defaultState or 0
	local height = uvHeight or (50.0 / 1024.0)
	local color = panelColor or Color.__new(0.8, 0.8, 0.8, 1.0)
	local hiddenColor = Color.__new(color.r, color.g, color.b, 0.0)
	local interval = inputInterval or TimeSpan.FromMilliseconds(100)
	local pickerEntered = false
	local lastInputTime = TimeSpan.Zero
	local lastState = nil
	local lastAdvancedState = nil

	local self
	self = {
		name = name,
		maxState = maxState,
		advancedFunction = advancedFunction,

		GetState = function()
			return vci.state.Get(stateName) or default
		end,

		SetState = function(state)
			vci.state.Set(stateName, state)
		end,

		NextState = function()
			local state = (self.GetState() + 1) % (maxState + 1)
			self.SetState(state)
			return state
		end,

		DoInput = function()
			-- advancedFunction が設定されているスイッチは、advanced モードのときのみ処理する
			if advancedFunction and advancedSwitch.GetState() == 0 then
				return
			end

			local time = vci.me.Time
			if time >= lastInputTime + interval then
				lastInputTime = time
				self.NextState()
			end
		end,

		SetPickerEntered = function(entered)
			pickerEntered = entered
		end,

		IsPickerEntered = function()
			return pickerEntered
		end,

		Update = function(force)
			local state = self.GetState()
			local advancedState = advancedSwitch.GetState()
			if advancedFunction and (force or advancedState ~= lastAdvancedState) then
				lastAdvancedState = advancedState
				-- advancedFunction が設定されているスイッチは、advanced モードのときのみ表示する
				vci.assets.SetMaterialColorFromName(materialName, advancedState == 0 and hiddenColor or color)
			end

			if force or state ~= lastState then
				lastState = state
				vci.assets.SetMaterialTextureOffsetFromName(materialName, Vector2.__new(0.0, 1.0 - height * state))
				return true
			else
				return false
			end
		end
	}
	return self
end

advancedSwitch = CreateSwitch('advanced-switch', 1, 0, false)
pickerSwitch = CreateSwitch('picker-switch', 1, 0, true)
opacitySwitch = CreateSwitch('opacity-switch', 4, 0, true)
brightnessSwitch = CreateSwitch('brightness-switch', cytanb.ColorBrightnessSamples - 1, 0, true)

local switchMap = {
	[advancedSwitch.name] = advancedSwitch,
	[pickerSwitch.name] = pickerSwitch,
	[opacitySwitch.name] = opacitySwitch,
	[brightnessSwitch.name] = brightnessSwitch
}

local function CalculateColor(hitIndex, brightnessPage, opacityPage)
	local colorIndex = hitIndex + cytanb.ColorHueSamples * cytanb.ColorSaturationSamples * brightnessPage
	local color = cytanb.ColorFromIndex(colorIndex)
	color.a = (opacitySwitch.maxState - opacityPage) / opacitySwitch.maxState
	return color, colorIndex
end

local function GetHitIndex()
	return vci.state.Get(HitIndexStateName) or 9
end

local function IsPickerHit(hit)
	return hit and (pickerSwitch.GetState() == 1 or AllowedPickerMap[hit] or string.contains(hit, ColorPickerTag))
end

local function EmitStatus(color, colorIndex)
	local argb32 = cytanb.ColorToARGB32(color)

	cytanb.DebugLog('emit status: colorIndex = ', colorIndex, ', color = ', color)

	local params = cytanb.GetSubItemTransform(PaletteBase)
	params['version'] = MessageVersion
	params['argb32'] = argb32
	params['colorIndex'] = colorIndex
	cytanb.EmitMessage(ItemStatusMessageName, params)
end

local function UpdateStatus(color, colorIndex)
	if not vci.assets.IsMine then return end

	cytanb.DebugLog('update status: colorIndex = ', colorIndex, ' ,  color = ', color)

	local argb32 = cytanb.ColorToARGB32(color)
	vci.studio.shared.Set(ARGB32SharedName, argb32)
	vci.studio.shared.Set(ColorIndexSharedName, colorIndex)

	EmitStatus(color, colorIndex)
end

local updateStateCw = coroutine.wrap(function ()
	local firstUpdate = true

	local lastUpdateTime = vci.me.Time
	local lastHitIndex = -1

	while true do
		local time = vci.me.Time
		if time >= lastUpdateTime + UpdatePeriod then
			lastUpdateTime = time

			--
			local switchChanged = false
			for k, v in pairs(switchMap) do
				local b = v.Update(firstUpdate)
				if v == brightnessSwitch or v == opacitySwitch then
					switchChanged = switchChanged or b
				end
			end

			--
			local hitIndex = GetHitIndex()
			if firstUpdate or lastHitIndex ~= hitIndex or switchChanged then
				local brightnessPage = brightnessSwitch.GetState()
				local color, colorIndex = CalculateColor(hitIndex, brightnessPage, opacitySwitch.GetState())

				cytanb.DebugLog('update currentColor: colorIndex = ', colorIndex, ' ,  color = ', color)
				lastHitIndex = hitIndex

				vci.assets.SetMaterialColorFromName(CurrentColorMaterialName, color)
				vci.assets.SetMaterialTextureOffsetFromName(PaletteMaterialName, Vector2.__new(0.0, 1.0 - PalettePageHeight * brightnessPage))

				UpdateStatus(color, colorIndex)
			end

			--
			firstUpdate = false
		end

		coroutine.yield(100)
	end
	return 0
end)

cytanb.OnMessage(QueryStatusMessageName, function (sender, name, parameterMap)
	if not vci.assets.IsMine then return end

	local color, colorIndex = CalculateColor(GetHitIndex(), brightnessSwitch.GetState(), opacitySwitch.GetState())
	EmitStatus(color, colorIndex)
end)

-- アイテムを設置したときの初期化処理
if vci.assets.IsMine then
	local color, colorIndex = CalculateColor(GetHitIndex(), brightnessSwitch.GetState(), opacitySwitch.GetState())
	UpdateStatus(color, colorIndex)
end

-- 全ユーザーで、毎フレーム呼び出される。
function updateAll()
	updateStateCw()
end

--- SubItem をトリガーでつかむと呼び出される。
function onGrab(target)
	cytanb.DebugLog('onGrab: ', target)
end

--- グリップしてアイテムを使用すると呼び出される。
function onUse(use)
	if advancedSwitch.IsPickerEntered() then
		cytanb.DebugLog('onUse: ', advancedSwitch.name)
		advancedSwitch.DoInput()
	elseif pickerSwitch.IsPickerEntered() then
		cytanb.DebugLog('onUse: ', pickerSwitch.name)
		pickerSwitch.DoInput()
	end
end

--- 操作権があるユーザーで、アイテムに Collider (Is Trigger = ON) が衝突したときに呼び出される。
function onTriggerEnter(item, hit)
	if IsPickerHit(hit) then
		local switch = switchMap[item]
		if switch then
			if PaletteBase.IsMine then
				switch.SetPickerEntered(true)
			end

			if switch == opacitySwitch or switch == brightnessSwitch then
				switch.DoInput()
			end
		elseif string.startsWith(item, ColorIndexPrefix) then
			local hitIndex = math.floor(tonumber(string.sub(item, 1 + string.len(ColorIndexPrefix))))
			cytanb.DebugLog('on trigger: hitIndex = ', hitIndex, ' hit = ', hit)
			if (hitIndex) then
				vci.state.Set(HitIndexStateName, hitIndex)
			end
		end
	end
end

function onTriggerExit(item, hit)
	local switch = switchMap[item]
	if switch then
		switchMap[item].SetPickerEntered(false)
	end
end
