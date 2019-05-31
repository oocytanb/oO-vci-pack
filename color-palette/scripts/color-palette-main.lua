----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

local cytanb=(function()local b={FatalLogLevel=100,ErrorLogLevel=200,WarnLogLevel=300,InfoLogLevel=400,DebugLogLevel=500,TraceLogLevel=600,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,ColorMapSize=10*4*5,NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID'}local c='__CYTANB_INSTANCE_ID'local d=400;local e;local a;a={InstanceID=function()if e==''then e=vci.state.Get(c)or''end;return e end,Vars=function(f,g,h,i)local j;if g then j=g~='__NOLF'else g='  'j=true end;if not h then h=''end;if not i then i={}end;local k=type(f)if k=='table'then i[f]=i[f]and i[f]+1 or 1;local l=j and h..g or''local m='('..tostring(f)..') {'local n=true;for o,p in pairs(f)do if n then n=false else m=m..(j and','or', ')end;if j then m=m..'\n'..l end;if type(p)=='table'and i[p]and i[p]>0 then m=m..o..' = ('..tostring(p)..')'else m=m..o..' = '..a.Vars(p,g,l,i)end end;if not n and j then m=m..'\n'..h end;m=m..'}'i[f]=i[f]-1;if i[f]<=0 then i[f]=nil end;return m elseif k=='function'or k=="thread"or k=="userdata"then return'('..k..')'elseif k=='string'then return'('..k..') '..string.format('%q',f)else return'('..k..') '..tostring(f)end end,GetLogLevel=function()return d end,SetLogLevel=function(q)d=q end,Log=function(q,...)if q<=d then local r=table.pack(...)if r.n==1 then local f=r[1]if f~=nil then print(type(f)=='table'and a.Vars(f)or tostring(f))else print('')end else local m=''for s=1,r.n do local f=r[s]if f~=nil then m=m..(type(f)=='table'and a.Vars(f)or tostring(f))end end;print(m)end end end,FatalLog=function(...)a.Log(b.FatalLogLevel,...)end,ErrorLog=function(...)a.Log(b.ErrorLogLevel,...)end,WarnLog=function(...)a.Log(b.WarnLogLevel,...)end,InfoLog=function(...)a.Log(b.InfoLogLevel,...)end,DebugLog=function(...)a.Log(b.DebugLogLevel,...)end,TraceLog=function(...)a.Log(b.TraceLogLevel,...)end,ListToMap=function(t,u)local table={}local v=u==nil;for w,f in pairs(t)do table[f]=v and f or u end;return table end,Random32=function()return math.random(-2147483648,2147483646)end,RandomUUID=function()return{a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32()}end,UUIDString=function(x)local y=x[2]or 0;local z=x[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(x[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(y,16),0xFFFF),bit32.band(y,0xFFFF),bit32.band(bit32.rshift(z,16),0xFFFF),bit32.band(z,0xFFFF),bit32.band(x[4]or 0,0xFFFFFFFF))end,ColorFromARGB32=function(A)local B=type(A)=='number'and A or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(B,16),0xFF)/0xFF,bit32.band(bit32.rshift(B,8),0xFF)/0xFF,bit32.band(B,0xFF)/0xFF,bit32.band(bit32.rshift(B,24),0xFF)/0xFF)end,ColorToARGB32=function(C)return bit32.bor(bit32.lshift(math.floor(255*C.a+0.5),24),bit32.lshift(math.floor(255*C.r+0.5),16),bit32.lshift(math.floor(255*C.g+0.5),8),math.floor(255*C.b+0.5))end,ColorFromIndex=function(D,E,F,G,H)local I=math.max(math.floor(E or b.ColorHueSamples),1)local J=H and I or I-1;local K=math.max(math.floor(F or b.ColorSaturationSamples),1)local L=math.max(math.floor(G or b.ColorBrightnessSamples),1)local M=math.max(math.min(math.floor(D or 0),I*K*L-1),0)local N=M%I;local O=math.floor(M/I)local P=O%K;local Q=math.floor(O/K)if H or N~=J then local R=N/J;local S=(K-P)/K;local f=(L-Q)/L;return Color.HSVToRGB(R,S,f)else local f=(L-Q)/L*P/(K-1)return Color.HSVToRGB(0.0,0.0,f)end end,GetSubItemTransform=function(T)local U=T.GetPosition()local V=T.GetRotation()local W=T.GetLocalScale()return{positionX=U.x,positionY=U.y,positionZ=U.z,rotationX=V.x,rotationY=V.y,rotationZ=V.z,rotationW=V.w,scaleX=W.x,scaleY=W.y,scaleZ=W.z}end,TableToSerialiable=function(X,i)if type(X)~='table'then return X end;if not i then i={}end;if i[X]then error('circular reference')end;i[X]=true;local Y={}for w,f in pairs(X)do if type(f)=='number'and f<0 then Y[w..b.NegativeNumberTag]=tostring(f)else Y[w]=a.TableToSerialiable(f,i)end end;i[X]=nil;return Y end,TableFromSerialiable=function(Y)if type(Y)~='table'then return Y end;local X={}for w,f in pairs(Y)do if type(f)=='string'and string.endsWith(w,b.NegativeNumberTag)then X[string.sub(w,1,#w-#b.NegativeNumberTag)]=tonumber(f)else X[w]=a.TableFromSerialiable(f)end end;return X end,EmitMessage=function(Z,_)local table=_ and a.TableToSerialiable(_)or{}table[b.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(Z,json.serialize(table))end,OnMessage=function(Z,a0)local a1=function(a2,a3,a4)local _;if a4==''then _={}else local a5,Y=pcall(json.parse,a4)if not a5 or type(Y)~='table'then a.TraceLog('Invalid message format: ',a4)return end;_=a.TableFromSerialiable(Y)end;a0(a2,a3,_)end;vci.message.On(Z,a1)return{Off=function()if a1 then a1=nil end end}end}setmetatable(a,{__index=b})package.loaded.cytanb=a;if vci.assets.IsMine then e=a.UUIDString(a.RandomUUID())vci.state.Set(c,e)else e=''end;return a end)()

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
			local hitIndex = tonumber(string.sub(item, 1 + string.len(ColorIndexPrefix)), 10)
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
