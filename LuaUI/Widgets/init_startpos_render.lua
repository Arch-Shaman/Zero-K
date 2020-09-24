function widget:GetInfo()
	return {
		name      = "Lua Start positions",
		desc      = "Draws lua start positions.",
		author    = "Shaman",
		date      = "Aug 21, 2020",
		license   = "PD",
		layer     = -1,
		enabled   = true,
		alwaysStart = true,
		handler = true,
	}
end

--[[local modOptions = Spring.GetModOptions()

if modOptions.singleplayercampaignbattleid then
	Spring.Echo("StartHandler is using legacy start handler.")
	widgetHandler:RemoveWidget(widget)
	return
end]]

--Spring.IsAABBInView

--openGL speedups
local glColor = gl.Color
local glDepthTest = gl.DepthTest
local glDepthMask = gl.DepthMask
local glLighting = gl.Lighting
local glPushMatrix = gl.PushMatrix
local glLoadIdentity = gl.LoadIdentity
local glTranslate = gl.Translate
local glRotate = gl.Rotate
local glUnitShape = gl.UnitShape
local glPopMatrix = gl.PopMatrix
local glDrawGroundCircle = gl.DrawGroundCircle
local glText = gl.Text
local spEcho = Spring.Echo
local spGetTeamColor = Spring.GetTeamColor
local spGetGroundHeight = Spring.GetGroundHeight
local spGetPlayerInfo = Spring.GetPlayerInfo
local spWorldToScreenCoords = Spring.WorldToScreenCoords
local spGetTeamInfo = Spring.GetTeamInfo
local spSendLuaRulesMsg = Spring.SendLuaRulesMsg
local knownCommanderStarts = {} -- teamID = {[num] = {x=x,y=y,z=z,def=UnitDefID}} NB: Teams may have multiple commanders. (See: commshare, uneven teams, etc)
local startPoses = 0

local function Echo(txt)
	spEcho("[StartPosAPI] Rendering: " .. txt)
end

local function DrawCommander(uDefID, teamID, ux, uy, uz, startposnum) -- borrowed this from initial queue.
	local r,g,b,a = spGetTeamColor(teamID)
	local textZ = uz - 10
	local textY = spGetGroundHeight(ux,textZ)
	local name = spGetPlayerInfo(select())
	if #spGetPlayerList(teamID) > 1 then
		name = name .. "'s squad (" .. startposnum .. ")"
	else
		name = name .. "(" .. startposnum .. ")"
	end
	glColor(1.0, 1.0, 1.0, 1.0)
	glDepthTest(GL.LEQUAL)
	glDepthMask(true)
	glLighting(true)
	if uDefID ~= '?' and uDefID ~= nil then
		glPushMatrix()
			glLoadIdentity()
			glTranslate(ux, uy, uz)
			glRotate(0, 0, 1, 0)
			glUnitShape(uDefID, teamID, false, false, false)
		glPopMatrix()
	end
	local sx, sy, sz = spWorldToScreenCoords(ux,uy,uz)
	if sx then
		if uDefID == nil or uDefID == '?' then
			glDrawGroundCircle(ux,uy,uz, 20,8)
		end
		glColor(r,g,b,a)
		glText(name,sx,sz,'co')
		glColor(1,1,1,1)
	end
	glLighting(false)
	glDepthTest(false)
	glDepthMask(false)
end

local function CheckIfExists(teamID,id)
	local startpos = knownCommanderStarts[teamID]
	for i=1, #startpos do
		if startpos[i].id == id then
			return i
		end
	end
end

local function StartUnitUpdate(teamID, commid, unitdef)
	if knownCommanderStarts[teamID] == nil then
		knownCommanderStarts[teamID] = {[1] = {x = x, y = y, z = z, def = unitdef, id = commid}}
	else
		local index = CheckIfExists(teamID, commid)
		if index then
			knownCommanderStarts[teamID][index].def = unitdef
		else
			knownCommanderStarts[teamID][#knownCommanderStarts[teamID]+1] = {x = x, y = y, z = z, def = unitdef, id = commid}
		end
	end
end

local function StartUpdated(teamID, x,y,z,commid) -- note playerID can be 
	if knownCommanderStarts[teamID] == nil then
		knownCommanderStarts[teamID] = {[1] = {x = x, y = y, z = z, def = '?', id = commid}}
		startPoses = startPoses + 1
	else
		local index = CheckIfExists(teamID, commid)
		if index then
			knownCommanderStarts[teamID][index].x = x
			knownCommanderStarts[teamID][index].y = y
			knownCommanderStarts[teamID][index].z = z
		else
			knownCommanderStarts[teamID][#knownCommanderStarts[teamID]+1] = {x = x, y = y, z = z, def = '?', id = commid}
		end
	end
	if WG then
		WG.StartPositions = knownCommanderStarts -- for other widgets.
	end
end

function widget:DrawWorld()
	if startPoses > 0 then
		for id,startpos in pairs(knownCommanderStarts) do
			if #startpos > 0 then
				for i=1, #startpos do
					local x,y,z = startpos[i].x, startpos[i].y,startpos[i].z
					DrawCommander(startpos[i].def,id,x,y,z,i)
				end
			end
		end
	end
end

local function Shutdown()
	Echo("Removing renderer.")
	widgetHandler:DeregisterGlobal('StartPosUpdate')
	widgetHandler:DeregisterGlobal('StartUnitUpdate')
	widgetHandler:RemoveWidget(widget)
	WG.StartPositions = nil
end

function widget:GameStart()
	Shutdown()
end

function widget:PlayerChanged(playerID) -- change out with player changed team later on.
	if playerID == myID then
		spSendLuaRulesMsg('startpos playerchanged')
	end
end

function widget:Initialize()
	if spGetGameFrame() > 0 then
		Shutdown()
	end
	widgetHandler:RegisterGlobal('StartPosUpdate',StartUpdated)
	widgetHandler:RegisterGlobal('StartUnitUpdate',StartUnitUpdate)
	spSendLuaRulesMsg("startpos resend") -- tell syncland i crashed or restarted.
end
