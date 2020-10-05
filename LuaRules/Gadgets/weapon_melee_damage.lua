function gadget:GetInfo()
	return {
		name      = "Melee weapons always do full damage",
		desc      = "Melee weapons do full damage.",
		author    = "Shaman",
		date      = "September 10, 2020",
		license   = "PD",
		layer     = 0,
		enabled   = true,
	}
end

if not (gadgetHandler:IsSyncedCode()) then 
	return
end

local meleeweapons = {} -- weapondefID = damage


for weaponDefID = 1, #WeaponDefs do
	local wd = WeaponDefs[weaponDefID]
	if wd.customParams and wd.customParams.melee and not wd.noExplode then
		meleeweapons[weaponDefID] = wd.damage
	end
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if meleeweapons[weaponDefID] then
		return meleeweapons[weaponDefID], 1.0
	end
end

function gadget:FeaturePreDamaged(featureID, featureDefID, featureTeam, damage, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
	if meleeweapons[weaponDefID] then
		return meleeweapons[weaponDefID], 1.0
	end
end
