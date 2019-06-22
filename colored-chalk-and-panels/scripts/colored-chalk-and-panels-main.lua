----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

---@type cytanb @See `cytanb_annotations.lua`
local cytanb=(function()math.randomseed(os.time()-os.clock()*10000)local b='__CYTANB_INSTANCE_ID'local c=400;local d;local a;a={InstanceID=function()if d==''then d=vci.state.Get(b)or''end;return d end,SetConst=function(e,f,g)if type(e)~='table'then error('Cannot set const to non-table target')end;local h=getmetatable(e)local i=h or{}local j=type(i.__index)=='table'if e[f]~=nil and(not j or i.__index[f]==nil)then error('Non-const field "'..f..'" already exists')end;if not j then i.__index={}end;local k=i.__index;k[f]=g;if not j or type(i.__newindex)~='function'then i.__newindex=function(table,l,m)if table==e and k[l]~=nil then error('Cannot assign to read only field "'..l..'"')end;rawset(table,l,m)end end;if not h then setmetatable(e,i)end;return e end,Extend=function(e,n,o,p,q)if e==n or type(e)~='table'or type(n)~='table'then return e end;if o then if not q then q={}end;if q[n]then error('circular reference')end;q[n]=true end;for r,m in pairs(n)do if o and type(m)=='table'then local s=e[r]e[r]=a.Extend(type(s)=='table'and s or{},m,o,p,q)else e[r]=m end end;if not p then local t=getmetatable(n)if type(t)=='table'then if o then local u=getmetatable(e)setmetatable(e,a.Extend(type(u)=='table'and u or{},t,true))else setmetatable(e,t)end end end;if o then q[n]=nil end;return e end,Vars=function(m,v,w,q)local x;if v then x=v~='__NOLF'else v='  'x=true end;if not w then w=''end;if not q then q={}end;local y=type(m)if y=='table'then q[m]=q[m]and q[m]+1 or 1;local z=x and w..v or''local A='('..tostring(m)..') {'local B=true;for l,C in pairs(m)do if B then B=false else A=A..(x and','or', ')end;if x then A=A..'\n'..z end;if type(C)=='table'and q[C]and q[C]>0 then A=A..l..' = ('..tostring(C)..')'else A=A..l..' = '..a.Vars(C,v,z,q)end end;if not B and x then A=A..'\n'..w end;A=A..'}'q[m]=q[m]-1;if q[m]<=0 then q[m]=nil end;return A elseif y=='function'or y=="thread"or y=="userdata"then return'('..y..')'elseif y=='string'then return'('..y..') '..string.format('%q',m)else return'('..y..') '..tostring(m)end end,GetLogLevel=function()return c end,SetLogLevel=function(D)c=D end,Log=function(D,...)if D<=c then local E=table.pack(...)if E.n==1 then local m=E[1]if m~=nil then print(type(m)=='table'and a.Vars(m)or tostring(m))else print('')end else local A=''for F=1,E.n do local m=E[F]if m~=nil then A=A..(type(m)=='table'and a.Vars(m)or tostring(m))end end;print(A)end end end,FatalLog=function(...)a.Log(a.FatalLogLevel,...)end,ErrorLog=function(...)a.Log(a.ErrorLogLevel,...)end,WarnLog=function(...)a.Log(a.WarnLogLevel,...)end,InfoLog=function(...)a.Log(a.InfoLogLevel,...)end,DebugLog=function(...)a.Log(a.DebugLogLevel,...)end,TraceLog=function(...)a.Log(a.TraceLogLevel,...)end,ListToMap=function(G,H)local table={}local I=H==nil;for r,m in pairs(G)do table[m]=I and m or H end;return table end,Random32=function()return bit32.band(math.random(-2147483648,2147483646),0xFFFFFFFF)end,RandomUUID=function()return{a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32()}end,UUIDString=function(J)local K=J[2]or 0;local L=J[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(J[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(K,16),0xFFFF),bit32.band(K,0xFFFF),bit32.band(bit32.rshift(L,16),0xFFFF),bit32.band(L,0xFFFF),bit32.band(J[4]or 0,0xFFFFFFFF))end,ParseUUID=function(A)local M=string.len(A)if M~=32 and M~=36 then return nil end;local N='[0-9a-f-A-F]+'local O='^('..N..')$'local P='^-('..N..')$'local J={}local Q,R,S,T;if M==32 then local U=1;for F,V in ipairs({8,16,24,32})do Q,R,S=string.find(string.sub(A,U,V),O)if not Q then return nil end;J[F]=tonumber(S,16)U=V+1 end else Q,R,S=string.find(string.sub(A,1,8),O)if not Q then return nil end;J[1]=tonumber(S,16)Q,R,S=string.find(string.sub(A,9,13),P)if not Q then return nil end;Q,R,T=string.find(string.sub(A,14,18),P)if not Q then return nil end;J[2]=tonumber(S..T,16)Q,R,S=string.find(string.sub(A,19,23),P)if not Q then return nil end;Q,R,T=string.find(string.sub(A,24,28),P)if not Q then return nil end;J[3]=tonumber(S..T,16)Q,R,S=string.find(string.sub(A,29,36),O)if not Q then return nil end;J[4]=tonumber(S,16)end;return J end,ColorFromARGB32=function(W)local X=type(W)=='number'and W or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(X,16),0xFF)/0xFF,bit32.band(bit32.rshift(X,8),0xFF)/0xFF,bit32.band(X,0xFF)/0xFF,bit32.band(bit32.rshift(X,24),0xFF)/0xFF)end,ColorToARGB32=function(Y)return bit32.bor(bit32.lshift(math.floor(255*Y.a+0.5),24),bit32.lshift(math.floor(255*Y.r+0.5),16),bit32.lshift(math.floor(255*Y.g+0.5),8),math.floor(255*Y.b+0.5))end,ColorFromIndex=function(Z,_,a0,a1,a2)local a3=math.max(math.floor(_ or a.ColorHueSamples),1)local a4=a2 and a3 or a3-1;local a5=math.max(math.floor(a0 or a.ColorSaturationSamples),1)local a6=math.max(math.floor(a1 or a.ColorBrightnessSamples),1)local a7=math.max(math.min(math.floor(Z or 0),a3*a5*a6-1),0)local a8=a7%a3;local a9=math.floor(a7/a3)local aa=a9%a5;local ab=math.floor(a9/a5)if a2 or a8~=a4 then local ac=a8/a4;local ad=(a5-aa)/a5;local m=(a6-ab)/a6;return Color.HSVToRGB(ac,ad,m)else local m=(a6-ab)/a6*aa/(a5-1)return Color.HSVToRGB(0.0,0.0,m)end end,GetSubItemTransform=function(ae)local af=ae.GetPosition()local ag=ae.GetRotation()local ah=ae.GetLocalScale()return{positionX=af.x,positionY=af.y,positionZ=af.z,rotationX=ag.x,rotationY=ag.y,rotationZ=ag.z,rotationW=ag.w,scaleX=ah.x,scaleY=ah.y,scaleZ=ah.z}end,TableToSerializable=function(ai,q)if type(ai)~='table'then return ai end;if not q then q={}end;if q[ai]then error('circular reference')end;q[ai]=true;local aj={}for r,m in pairs(ai)do if type(m)=='number'and m<0 then aj[r..a.NegativeNumberTag]=tostring(m)else aj[r]=a.TableToSerializable(m,q)end end;q[ai]=nil;return aj end,TableFromSerializable=function(aj)if type(aj)~='table'then return aj end;local ai={}for r,m in pairs(aj)do if type(m)=='string'and string.endsWith(r,a.NegativeNumberTag)then ai[string.sub(r,1,#r-#a.NegativeNumberTag)]=tonumber(m)else ai[r]=a.TableFromSerializable(m)end end;return ai end,EmitMessage=function(f,ak)local table=ak and a.TableToSerializable(ak)or{}table[a.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(f,json.serialize(table))end,OnMessage=function(f,al)local am=function(an,ao,ap)local ak;if ap==''then ak={}else local aq,aj=pcall(json.parse,ap)if not aq or type(aj)~='table'then a.TraceLog('Invalid message format: ',ap)return end;ak=a.TableFromSerializable(aj)end;al(an,ao,ak)end;vci.message.On(f,am)return{Off=function()if am then am=nil end end}end}a:SetConst('FatalLogLevel',100):SetConst('ErrorLogLevel',200):SetConst('WarnLogLevel',300):SetConst('InfoLogLevel',400):SetConst('DebugLogLevel',500):SetConst('TraceLogLevel',600):SetConst('ColorHueSamples',10):SetConst('ColorSaturationSamples',4):SetConst('ColorBrightnessSamples',5):SetConst('ColorMapSize',a.ColorHueSamples*a.ColorSaturationSamples*a.ColorBrightnessSamples):SetConst('NegativeNumberTag','#__CYTANB_NEGATIVE_NUMBER'):SetConst('InstanceIDParameterName','__CYTANB_INSTANCE_ID')package.loaded['cytanb']=a;if vci.assets.IsMine then d=a.UUIDString(a.RandomUUID())vci.state.Set(b,d)else d=''end;return a end)()

cytanb.SetLogLevel(cytanb.DebugLogLevel)

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

local PanelTag = '#panel'

local ColorStatusPrefix = 'color.'

local AutoChangeUnimsgReceiverStateName = 'autoChangeUnimsgReceiver'
local AutoChangeAnymsgReceiverStateName = 'autoChangeAnymsgReceiver'
local LinkedPaletteInstanceIDState = 'linkedColorPaletteInstanceID'

local ItemNameList, AllMaterialTable, ChalkMaterialTable, PanelMaterialTable, DefaultItemColorMap = (
	function (chalkList, panelList, colorList)
		local ci = 1
		local itemNameList = {}
		local allMaterialTable = {}
		local itemColorMap = {}

		local chalkMaterialTable = {}
		for i, v in ipairs(chalkList) do
			local name = v .. ColorPickerTag
			chalkMaterialTable[name] = v .. '-mat'
			allMaterialTable[name] = chalkMaterialTable[name]
			itemColorMap[name] = cytanb.ColorFromARGB32(colorList[ci])
			table.insert(itemNameList, name)
			ci = ci + 1
		end

		local panelMaterialTable = {}
		for i, v in ipairs(panelList) do
			local name = v .. PanelTag
			panelMaterialTable[name] = v .. '-panel-mat'
			allMaterialTable[name] = panelMaterialTable[name]
			itemColorMap[name] = cytanb.ColorFromARGB32(colorList[ci])
			table.insert(itemNameList, name)
			ci = ci + 1
		end

		return itemNameList, allMaterialTable, chalkMaterialTable, panelMaterialTable, itemColorMap
	end
)(
	{'large-chalk', 'middle-chalk', 'small-chalk'},
	{'shared-variable', 'unimsg-receiver', 'anymsg-receiver'},
	{0xFFE6B422, 0xFF65318E, 0xFFE7E7E7, 0xFF006888, 0xFF00552E, 0xFFA22041}
)

local UnimsgReceiverName = ItemNameList[5]
local AnymsgReceiverName = ItemNameList[6]

local UpdatePeriod = TimeSpan.FromMilliseconds(100)
local QueryPeriod = TimeSpan.FromSeconds(2)

local linkPaletteCw = nil

local function GetLinkedInstanceID()
	return vci.state.Get(LinkedPaletteInstanceIDState) or ''
end

-- 現在のカラーパレットとのリンクを解除する
local function UnlinkPalette()
	vci.state.Set(LinkedPaletteInstanceIDState, '')
end

local function IsAutoChangeUnimsgReceiver()
	local b = vci.state.Get(AutoChangeUnimsgReceiverStateName)
	if b == nil then
		return false
	else
		return b
	end
end

local function IsAutoChangeAnymsgReceiver()
	local b = vci.state.Get(AutoChangeAnymsgReceiverStateName)
	if b == nil then
		return true
	else
		return b
	end
end

local function GetItemColor(itemName)
	return cytanb.ColorFromARGB32(vci.state.Get(ColorStatusPrefix .. itemName))
end

local function SetItemColor(itemName, color)
	vci.state.Set(ColorStatusPrefix .. itemName, cytanb.ColorToARGB32(color))
end

local function LinkPaletteProc()
	local itemPosition = vci.assets.GetSubItem(UnimsgReceiverName).GetPosition()
	local candId = ''
	local candPosition = nil
	local candDistance = nil
	local candARGB32 = nil

	UnlinkPalette()

	-- 新しいカラーパレットとリンクするために、問い合わせる
	cytanb.DebugLog('emitMessage: ', QueryStatusMessageName)
	cytanb.EmitMessage(QueryStatusMessageName, {version = MessageVersion})

	local queryExpires = vci.me.Time + QueryPeriod
	while true do
		local cont, parameterMap = coroutine.yield(100)
		if not cont then
			-- abort
			cytanb.DebugLog('LinkPaletteProc aborted.')
			return -301
		end

		if parameterMap then
			-- パレットとの距離を調べる
			local instanceID = parameterMap[cytanb.InstanceIDParameterName]
			local x = parameterMap['positionX']
			local y = parameterMap['positionY']
			local z = parameterMap['positionZ']
			if instanceID and instanceID ~= '' and x and y and z then
				local position = Vector3.__new(x, y, z)
				local distance = Vector3.Distance(position, itemPosition)
				if not candPosition or  distance < candDistance then
					-- より近い距離のパレットを候補にする
					candId = instanceID
					candPosition = position
					candDistance = distance
					candARGB32 = parameterMap['argb32']
				end
			end
		end

		if queryExpires < vci.me.Time then
			-- タイムアウトしたので処理を抜ける
			break
		end
	end

	return 0, candId, candARGB32
end

local function ResumeLinkPalette(parameterMap)
	if not linkPaletteCw then return end

	local code, instanceID, argb32 = linkPaletteCw(true, parameterMap)
	if code <= 0 then
		-- スレッド終了
		cytanb.DebugLog('linkPaletteCw stoped: ', code)
		linkPaletteCw = nil

		if instanceID and instanceID ~= '' and instanceID ~= GetLinkedInstanceID() then
			-- 新しいパレットのインスタンスにリンクする
			print('linked to color-palette #', instanceID)
			vci.state.Set(LinkedPaletteInstanceIDState, instanceID)
			SetItemColor(UnimsgReceiverName, cytanb.ColorFromARGB32(argb32))
		end
	end
end

local updateStateCw = coroutine.wrap(function ()
	local lastUpdateTime = vci.me.Time
	local lastItemColorMap = {}
	local lastAutoChangeUnimsg = IsAutoChangeUnimsgReceiver()

	while true do
		local time = vci.me.Time
		if time >= lastUpdateTime + UpdatePeriod then
			lastUpdateTime = time

			for itemName, materialName in pairs(AllMaterialTable) do
				local color = GetItemColor(itemName)
				if color ~= lastItemColorMap[itemName] then
					lastItemColorMap[itemName] = color
					vci.assets.SetMaterialColorFromName(materialName, color)
				end
			end

			if vci.assets.IsMine then
				local autoChangeUnimsg = IsAutoChangeUnimsgReceiver()
				if autoChangeUnimsg ~= lastAutoChangeUnimsg then
					lastAutoChangeUnimsg = autoChangeUnimsg

					if autoChangeUnimsg then
						if linkPaletteCw then
							-- abort previous thread
							linkPaletteCw(false)
						end

						linkPaletteCw = coroutine.wrap(LinkPaletteProc)
					else
						UnlinkPalette()
					end
				end
			end
		end

		coroutine.yield(100)
	end
	return 0
end)

-- アイテムを設置したときの初期化処理
if vci.assets.IsMine then
	for k, v in pairs(DefaultItemColorMap) do
		SetItemColor(k, v)
	end
end

-- 全ユーザーで、毎フレーム呼び出される。
function updateAll()
	updateStateCw()

	if vci.assets.IsMine then
		ResumeLinkPalette()
	end
end

-- グリップしてアイテムを使用すると呼び出される。
function onUse(use)
	-- 共有変数から色情報を取得する
	local color = cytanb.ColorFromARGB32(vci.studio.shared.Get(ARGB32SharedName))
	cytanb.DebugLog('onUse: ', use, ' ,  shared color = ', color)

	local chalkMaterial = ChalkMaterialTable[use]
	if chalkMaterial then
		SetItemColor(use, color)
	end

	local panelMaterial = PanelMaterialTable[use]
	if panelMaterial then
		SetItemColor(use, color)

		if use == UnimsgReceiverName then
			-- 自動でパレットの選択色に変更するかを切り替える
			vci.state.Set(AutoChangeUnimsgReceiverStateName, not IsAutoChangeUnimsgReceiver())
		elseif use == AnymsgReceiverName then
			-- 自動でパレットの選択色に変更するかを切り替える
			vci.state.Set(AutoChangeAnymsgReceiverStateName, not IsAutoChangeAnymsgReceiver())
		end
	end
end

--- 操作権があるユーザーで、アイテムに Collider (Is Trigger = OFF) が衝突したときに呼び出される。
function onCollisionEnter(item, hit)
	cytanb.DebugLog('on collision enter: item = ', item, ' , hit = ', hit)

	local chalkMaterial = ChalkMaterialTable[item]
	local panelMaterial = PanelMaterialTable[hit]
	if chalkMaterial and panelMaterial then
		-- チョークがパネルにヒットしたときは、チョークの色をパネルに設定する
		local chalkColor = GetItemColor(item)

		-- まったく同色にすると、チョークと区別できないため、若干値を下げる。
		local d = 0.1
		local color = Color.__new(math.max(chalkColor.r - d, 0.0), math.max(chalkColor.g - d, 0.0), math.max(chalkColor.b - d, 0.0), chalkColor.a)
		cytanb.DebugLog('change panel[', hit, '] color to chalk[', item, ']: color = ', color)
		SetItemColor(hit, color)
	end
end

cytanb.OnMessage(ItemStatusMessageName, function (sender, name, parameterMap)
	if not vci.assets.IsMine then return end

	local version = parameterMap['version']
	if not version or parameterMap['version'] < MinMessageVersion then return end

	-- vci.message から色情報を取得する
	local color = cytanb.ColorFromARGB32(parameterMap['argb32'])
	cytanb.DebugLog('on item status: color = ', color)

	ResumeLinkPalette(parameterMap)

	if IsAutoChangeUnimsgReceiver() then
		local instanceID = parameterMap[cytanb.InstanceIDParameterName]
		local linkedInstanceID = GetLinkedInstanceID()

		if linkedInstanceID ~= '' and linkedInstanceID == instanceID then
			-- リンクされたカラーパレットの色情報の場合のみ、パネルの色を変更する
			print('set unimsg receiver color')
			SetItemColor(UnimsgReceiverName, color)
		end
	end

	if IsAutoChangeAnymsgReceiver() then
		-- どのカラーパレットの色情報であっても、パネルの色を変更する
		print('set anymsg receiver color')
		SetItemColor(AnymsgReceiverName, color)
	end
end)
