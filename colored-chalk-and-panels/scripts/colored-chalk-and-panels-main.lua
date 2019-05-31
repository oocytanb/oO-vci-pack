----------------------------------------------------------------
--  Copyright (c) 2019 oO (https://github.com/oocytanb)
--  MIT Licensed
----------------------------------------------------------------

local cytanb=(function()local b={FatalLogLevel=100,ErrorLogLevel=200,WarnLogLevel=300,InfoLogLevel=400,DebugLogLevel=500,TraceLogLevel=600,ColorHueSamples=10,ColorSaturationSamples=4,ColorBrightnessSamples=5,ColorMapSize=10*4*5,NegativeNumberTag='#__CYTANB_NEGATIVE_NUMBER',InstanceIDParameterName='__CYTANB_INSTANCE_ID'}local c='__CYTANB_INSTANCE_ID'local d=400;local e;local a;a={InstanceID=function()if e==''then e=vci.state.Get(c)or''end;return e end,Vars=function(f,g,h,i)local j;if g then j=g~='__NOLF'else g='  'j=true end;if not h then h=''end;if not i then i={}end;local k=type(f)if k=='table'then i[f]=i[f]and i[f]+1 or 1;local l=j and h..g or''local m='('..tostring(f)..') {'local n=true;for o,p in pairs(f)do if n then n=false else m=m..(j and','or', ')end;if j then m=m..'\n'..l end;if type(p)=='table'and i[p]and i[p]>0 then m=m..o..' = ('..tostring(p)..')'else m=m..o..' = '..a.Vars(p,g,l,i)end end;if not n and j then m=m..'\n'..h end;m=m..'}'i[f]=i[f]-1;if i[f]<=0 then i[f]=nil end;return m elseif k=='function'or k=="thread"or k=="userdata"then return'('..k..')'elseif k=='string'then return'('..k..') '..string.format('%q',f)else return'('..k..') '..tostring(f)end end,GetLogLevel=function()return d end,SetLogLevel=function(q)d=q end,Log=function(q,...)if q<=d then local r=table.pack(...)if r.n==1 then local f=r[1]if f~=nil then print(type(f)=='table'and a.Vars(f)or tostring(f))else print('')end else local m=''for s=1,r.n do local f=r[s]if f~=nil then m=m..(type(f)=='table'and a.Vars(f)or tostring(f))end end;print(m)end end end,FatalLog=function(...)a.Log(b.FatalLogLevel,...)end,ErrorLog=function(...)a.Log(b.ErrorLogLevel,...)end,WarnLog=function(...)a.Log(b.WarnLogLevel,...)end,InfoLog=function(...)a.Log(b.InfoLogLevel,...)end,DebugLog=function(...)a.Log(b.DebugLogLevel,...)end,TraceLog=function(...)a.Log(b.TraceLogLevel,...)end,ListToMap=function(t,u)local table={}local v=u==nil;for w,f in pairs(t)do table[f]=v and f or u end;return table end,Random32=function()return math.random(-2147483648,2147483646)end,RandomUUID=function()return{a.Random32(),bit32.bor(0x4000,bit32.band(a.Random32(),0xFFFF0FFF)),bit32.bor(0x80000000,bit32.band(a.Random32(),0x3FFFFFFF)),a.Random32()}end,UUIDString=function(x)local y=x[2]or 0;local z=x[3]or 0;return string.format('%08x-%04x-%04x-%04x-%04x%08x',bit32.band(x[1]or 0,0xFFFFFFFF),bit32.band(bit32.rshift(y,16),0xFFFF),bit32.band(y,0xFFFF),bit32.band(bit32.rshift(z,16),0xFFFF),bit32.band(z,0xFFFF),bit32.band(x[4]or 0,0xFFFFFFFF))end,ColorFromARGB32=function(A)local B=type(A)=='number'and A or 0xFF000000;return Color.__new(bit32.band(bit32.rshift(B,16),0xFF)/0xFF,bit32.band(bit32.rshift(B,8),0xFF)/0xFF,bit32.band(B,0xFF)/0xFF,bit32.band(bit32.rshift(B,24),0xFF)/0xFF)end,ColorToARGB32=function(C)return bit32.bor(bit32.lshift(math.floor(255*C.a+0.5),24),bit32.lshift(math.floor(255*C.r+0.5),16),bit32.lshift(math.floor(255*C.g+0.5),8),math.floor(255*C.b+0.5))end,ColorFromIndex=function(D,E,F,G,H)local I=math.max(math.floor(E or b.ColorHueSamples),1)local J=H and I or I-1;local K=math.max(math.floor(F or b.ColorSaturationSamples),1)local L=math.max(math.floor(G or b.ColorBrightnessSamples),1)local M=math.max(math.min(math.floor(D or 0),I*K*L-1),0)local N=M%I;local O=math.floor(M/I)local P=O%K;local Q=math.floor(O/K)if H or N~=J then local R=N/J;local S=(K-P)/K;local f=(L-Q)/L;return Color.HSVToRGB(R,S,f)else local f=(L-Q)/L*P/(K-1)return Color.HSVToRGB(0.0,0.0,f)end end,GetSubItemTransform=function(T)local U=T.GetPosition()local V=T.GetRotation()local W=T.GetLocalScale()return{positionX=U.x,positionY=U.y,positionZ=U.z,rotationX=V.x,rotationY=V.y,rotationZ=V.z,rotationW=V.w,scaleX=W.x,scaleY=W.y,scaleZ=W.z}end,TableToSerialiable=function(X,i)if type(X)~='table'then return X end;if not i then i={}end;if i[X]then error('circular reference')end;i[X]=true;local Y={}for w,f in pairs(X)do if type(f)=='number'and f<0 then Y[w..b.NegativeNumberTag]=tostring(f)else Y[w]=a.TableToSerialiable(f,i)end end;i[X]=nil;return Y end,TableFromSerialiable=function(Y)if type(Y)~='table'then return Y end;local X={}for w,f in pairs(Y)do if type(f)=='string'and string.endsWith(w,b.NegativeNumberTag)then X[string.sub(w,1,#w-#b.NegativeNumberTag)]=tonumber(f)else X[w]=a.TableFromSerialiable(f)end end;return X end,EmitMessage=function(Z,_)local table=_ and a.TableToSerialiable(_)or{}table[b.InstanceIDParameterName]=a.InstanceID()vci.message.Emit(Z,json.serialize(table))end,OnMessage=function(Z,a0)local a1=function(a2,a3,a4)local _;if a4==''then _={}else local a5,Y=pcall(json.parse,a4)if not a5 or type(Y)~='table'then a.TraceLog('Invalid message format: ',a4)return end;_=a.TableFromSerialiable(Y)end;a0(a2,a3,_)end;vci.message.On(Z,a1)return{Off=function()if a1 then a1=nil end end}end}setmetatable(a,{__index=b})package.loaded.cytanb=a;if vci.assets.IsMine then e=a.UUIDString(a.RandomUUID())vci.state.Set(c,e)else e=''end;return a end)()

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
