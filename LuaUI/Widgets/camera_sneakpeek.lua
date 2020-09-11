function widget:GetInfo()
	return {
		name      = 'Quick peek v2',
		desc      = 'have a quick look at most recent screen message by pressing a hotkey',
		version   = "1.1",
		author    = 'Jools, adapted/fixed by Shaman',
		date      = 'September 10, 2020',
		license   = 'PD', 
		layer     = 1,
		enabled   = false,
	}
end

include("keysym.lua")
local markFrame = -2
local mx, my, mz
local cx,cy,cz
local CAMTIME = 0.15 -- in seconds
local key
local keymods = {ctrl = false, alt = false, shift = false, meta = false}
local TIMEOUT = 0
local strupper = string.upper
local strgsub = string.gsub

local function ToKeysyms(key)
	if not key then
		return
	end
	if tonumber(key) then
		return KEYSYMS["N_" .. key], key
	end
	local keyCode = KEYSYMS[string.upper(key)]
	if keyCode == nil then
		keyCode = specialKeyCodes[key]
	end
	key = strupper(key) or key
	key = strgsub(key, "NUMPAD", "NP") or key
	key = strgsub(key, "KP", "NP") or key
	return keyCode, key
end

local function HotkeyChanged()
	local hotkey = WG.crude.GetHotkey("epic_quick_peek_v2_hotkey")
	keymods.ctrl = false
	keymods.alt = false
	keymods.shift = false
	keymods.meta = false
	if hotkey == '' then
		hotkey = -99999
	else
		hotkey = hotkey:gsub('+','')
		hotkey = hotkey:gsub(' ','')
		if hotkey:find('Shift') then
			keymods.shift = true
			hotkey = hotkey:gsub('Shift', '')
		end
		if hotkey:find('Ctrl') then
			keymods.ctrl = true
			hotkey = hotkey:gsub('Ctrl','')
		end
		if hotkey:find('Alt') then
			keymods.alt = true
			hotkey = hotkey:gsub('Alt','')
		end
		if hotkey:find('Meta') then
			keymods.meta = true
			hotkey = hotkey:gsub('Meta','')
		end
		key = ToKeysyms(hotkey)
	end
end

options_path = 'Settings/Camera/Quick Peek'
options = {
	hotkey = { 
		name = "hotkey", 
		type = "button",
		OnHotkeyChange = function(self)
			HotkeyChanged()
		end,
		desc = "quickpeek hotkey",
		hotkey = "H",
	},
	timeout = { 
		name = "Label Lifespan", 
		type = "number",
		value = 10,
		min = 0,
		max = 60,
		step = 1,
		OnChange = function(self) 
			TIMEOUT = self.value * 30
		end,
	},
}

-- speedups --
local spGetCameraPosition = Spring.GetCameraPosition
local spGetGameFrame = Spring.GetGameFrame
local spGetViewGeometry = Spring.GetViewGeometry
local spTraceScreenRay = Spring.TraceScreenRay
local spSetCameraTarget = Spring.SetCameraTarget
local mathCeil = math.ceil

function widget:MapDrawCmd(playerID, cmdType, px, py, pz)
	if cmdType == "point" or cmdType == "label"  then
		markFrame = spGetGameFrame() + TIMEOUT
		mx,my,mz = px, py, pz
	end
end

function widget:KeyPress(k, mods, isRepeat)
	if k == key and (not isRepeat) and markFrame >= spGetGameFrame() and (mods.ctrl == keymods.ctrl and mods.alt == keymods.alt and mods.shift == keymods.shift and mods.meta == keymods.meta) then
		_,cy,_ = spGetCameraPosition()
		local screenx,screenz,_ = spGetViewGeometry()
		local x = screenx/2
		local z = screenz/2
		local _,pos = spTraceScreenRay(x,z,true)
		cx = pos[1]
		cz = mathCeil(pos[3]) -- needed because camera position shifts up or down a little each time the hotkey is pressed. this is unique to the z axis for some reason
		spSetCameraTarget(mx, my, mz)
		return true
	end
	return false
end

function widget:KeyRelease(k)
	if k  == key and cx then
		spSetCameraTarget(cx,cy,cz,CAMTIME)
		return true
	end
	return false
end

function widget:Initialize()
	HotkeyChanged()
	TIMEOUT = options.timeout.value * 30
end
