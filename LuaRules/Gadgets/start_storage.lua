function gadget:GetInfo()
	return {
		name      = "Storage Setup",
		desc      = "Implements storage.",
		author    = "Original by Licho, CarRepairer, Google Frog, SirMaverick. Rewritten by Shaman.",
		date      = "September 21, 2020",
		license   = "PD",
		layer     = 3, -- after facplop and start_unit_setup
		enabled   = true  --  loaded by default?
	}
end

if not (gadgetHandler:IsSyncedCode()) then
	return
end

local loadGame = false
local storagedefs = {}
include("LuaRules/Configs/constants.lua")
include("LuaRules/Configs/start_resources.lua")

local spGetTeamUnitDefCount = Spring.GetTeamUnitDefCount
local spSetTeamResource = Spring.SetTeamResource
local spGetTeamInfo = Spring.GetTeamInfo
local tobool = Spring.Utilities.tobool

for i=1, #UnitDefs do -- added for mod support.
	local ud = UnitDefs[i]
	if ud.metalStorage then
		storagedefs[i] = ud.metalStorage
	end
end

local function SetupStorage(teamID)
	local ammount = 0
	for id,storage in pairs(storagedefs) do
		ammount = ammount + spGetTeamUnitDefCount(teamID, id) * storage
	end
	ammount = HIDDEN_STORAGE + ammount
	spSetTeamResource(teamID, "es", ammount)
	spSetTeamResource(teamID, "ms", ammount)
	spSetTeamResource(teamID, "energy", 0)
	spSetTeamResource(teamID, "metal", 0)
	local _, _, _, _, _, _, teamInfo = spGetTeamInfo(teamID, true)
	spSetTeamResource(teamID, "es", START_STORAGE + HIDDEN_STORAGE)
	spSetTeamResource(teamID, "ms", START_STORAGE + HIDDEN_STORAGE)
	spSetTeamResource(teamID, "energy", teamInfo.start_energy or START_ENERGY)
	spSetTeamResource(teamID, "metal", teamInfo.start_metal or START_METAL + metal)
end

function gadget:Load()
	loadGame = true
end

function gadget:GameStart()
		if loadGame or tobool(Spring.GetGameRulesParam("loadedGame")) then
			return
		end
		local teamlist = Spring.GetTeamList()
		for i=1, #teamlist do
			local teamID = teamlist[i]
			SetupStorage(teamID)
		end
	end
end
