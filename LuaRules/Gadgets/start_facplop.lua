function gadget:GetInfo()
	return {
		name      = "Facplop",
		desc      = "Implements facplopping.",
		author    = "Original by Licho, CarRepairer, Google Frog, SirMaverick. Rewritten by Shaman",
		date      = "September 21, 2020",
		license   = "PD",
		layer     = -1, -- Before terraforming gadget (for facplop terraforming)
		enabled   = true,  --  loaded by default?
	}
end

if not (gadgetHandler:IsSyncedCode()) then
	return
end

local ploppables = {
  "factoryhover",
  "factoryveh",
  "factorytank",
  "factoryshield",
  "factorycloak",
  "factoryamph",
  "factoryjump",
  "factoryspider",
  "factoryship",
  "factoryplane",
  "factorygunship",
}

local ploppableDefs = {}
for i = 1, #ploppables do
	local ud = UnitDefNames[ploppables[i]]
	if ud and ud.id then
		ploppableDefs[ud.id] = true
	end
end

local spGetAllUnits = Spring.GetAllUnits
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spSetUnitRulesParam = Spring.SetUnitRulesParam
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetUnitHealth = Spring.GetUnitHealth
local spSpawnCEG = Spring.SpawnCEG
local spSetUnitHealth = Spring.SetUnitHealth
local spGetUnitPosition = Spring.GetUnitPosition
local spSendComamnds = Spring.SendCommands
local spGetPlayerInfo = Spring.GetPlayerInfo
local spGetTeamInfo = Spring.GetTeamInfo
local spPlaySoundFile = Spring.PlaySoundFile
local spGetGameFrame = Spring.GetGameFrame
local spGetUnitCurrentCommand = Spring.GetUnitCurrentCommand
local spEcho = Spring.Echo
local spIsCheatingEnabled = Spring.IsCheatingEnabled
local IN_LOS = {inlos = true}

local facplopsremaining = 0
local debugMode = false
local CampaignSafety = false

if VFS.FileExists("mission.lua") then
	CampaignSafety = true
	
	function GG.GiveFacplop(unitID)(unitID) -- no longer deprecated due to how ShamanPlop's automatic shutoff works.
		facplopsremaining = facplopsremaining + 1
		spSetUnitRulesParam(unitID, "facplop", 1, IN_LOS)
		if facplopsremaining > 0 then
			gadgetHandler:UpdateCallIn('UnitCreated')
		end
	end

end

function gadget:UnitCreated(unitID, unitDefID, unitTeam, builderID)
	if spGetGameFrame() < 3 and UnitDefs[unitDefID].customParams.commtype then
		facplopsremaining = facplopsremaining + 1
		if debugMode then
			spEcho("Facplops left: " .. facplopsremaining)
		end
	end
	if ploppableDefs[unitDefID] and builderID and spGetUnitRulesParam(builderID, "facplop") == 1 then
		facplopsremaining = facplopsremaining - 1
		if debugMode then
			spEcho("Facplop: " .. unitID)
		end
		spSetUnitRulesParam(builderID, "facplop", 0, IN_LOS)
		spSetUnitRulesParam(unitID,"ploppee",1, IN_LOS)
		local _, _, cmdTag = spGetUnitCurrentCommand(builderID)
		spGiveOrderToUnit(builderID, CMD.REMOVE, cmdTag, CMD.OPT_ALT)
		local maxHealth = select(2,spGetUnitHealth(unitID))
		spSetUnitHealth(unitID, {health = maxHealth, build = 1})
		local x, y, z = spGetUnitPosition(unitID)
		spSpawnCEG("gate", x, y, z)
		-- Stats collection (actually not, see below)
		if GG.mod_stats_AddFactoryPlop then
			GG.mod_stats_AddFactoryPlop(teamID, unitDefID)
		end
		-- FIXME: temporary hack because I'm in a hurry
		-- proper way: get rid of all the useless shit in modstats, reenable and collect plop stats that way (see above)
		local str = "SPRINGIE:facplop," .. UnitDefs[unitDefID].name .. "," .. teamID .. "," .. select(6, spGetTeamInfo(teamID, false)) .. ","
		local _, playerID, _, isAI = spGetTeamInfo(teamID, false)
		if isAI then
			str = str .. "Nightwatch" -- existing account just in case infra explodes otherwise
		else
			str = str .. (spGetPlayerInfo(playerID, false) or "ChanServ") -- ditto, different acc to differentiate
		end
		str = str .. ",END_PLOP"
		spSendCommands("wbynum 255 " .. str)
		spPlaySoundFile("sounds/misc/teleport2.wav", 10, x, y, z) -- this is fine now because of preloading (hopefully)
		if facplopsremaining == 0 and not CampaignSafety then
			gadgetHandler:RemoveCallin('UnitCreated')
		end
	end
end

local function CheckUnits()
	local allunits = spGetAllUnits()
	if #allunits == 0 then
		return
	end
	for i=1, #allunits do
		local unitID = allunits[i]
		if spGetUnitRulesParam(unitID, "facplop") == 1 then
			facplopsremaining = facplopsremaining + 1
			if debugMode then
				spEcho("Facplops left: " .. facplopsremaining)
			end
		end
	end
end

local function ToggleDebug()
	if spIsCheatingEnabled() then -- toggle debugMode
		debugMode = not debugMode
	else
		spEcho("[Facplop] Enable cheats to toggle debug mode.")
		return
	end
	if debugMode then
		spEcho("[Facplop] Debug enabled.")
	else
		spEcho("[Facplop] Debug disabled.")
	end
end

function gadget:Load() -- TODO: implement proper saving the amount of facplops remaining.
	CheckUnits()
	if facplopsremaining == 0 and not CampaignSafety then
		gadgetHandler:RemoveCallIn('UnitCreated')
	end
end

function gadget:Initialize()
	gadgetHandler:AddChatAction("debugfacplop", ToggleDebug, "Toggles facplop debugMode echos.")
end
