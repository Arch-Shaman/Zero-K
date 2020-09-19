function widget:GetInfo()
  return {
    name      = "Attack Warning",
    desc      = "Warns if stuff gets attacked",
    author    = "knorke",
    date      = "Oct 2011",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true,
  }
end

local spGetSpectatingState	= Spring.GetSpectatingState
local myPlayerID = Spring.GetMyPlayerID()
local warningDelay = 30 * 5 	--in frames
local lastWarning = 0			--in frames
local localTeamID = Spring.GetLocalTeamID ()

local under_attack_translation
local function languageChanged ()
	under_attack_translation = WG.Translate ("interface", "unit_under_attack")
end

function widget:UnitDamaged (unitID, unitDefID, unitTeam, damage, paralyzer, weaponID, attackerID, attackerDefID, attackerTeam)
	if damage <= 0 then return end -- TODO: Add status damage?
	local currentFrame = Spring.GetGameFrame ()
	if (lastWarning+warningDelay > currentFrame) then
		return
	end
	if (localTeamID==unitTeam and not Spring.IsUnitInView (unitID)) then
		lastWarning = currentFrame
		Spring.Echo ("game_message: " .. Spring.Utilities.GetHumanName(UnitDefs[unitDefID])  .. " " .. under_attack_translation)
		--Spring.PlaySoundFile (blabla attack.wav, ... "userinterface")
		local x,y,z = Spring.GetUnitPosition (unitID)
		if (x and y and z) then
			Spring.SetLastMessagePosition (x,y,z)
		end
	end
end

function widget:Initialize()
	if spGetSpectatingState() then
		widgetHandler:RemoveWidget()
	end

	WG.InitializeTranslation (languageChanged, GetInfo().name)
end

function widget:Shutdown()
	WG.ShutdownTranslation(GetInfo().name)
end

function widget:PlayerResigned(playerID)
	if playerID == myID then
		widgetHandler:RemoveWidget()
	end
end

function widget:PlayerChangedTeam(playerID,oldteam,newteam)
	if playerID == myPlayerID then
		localTeamID = newteam
	end
end
