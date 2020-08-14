if not gadgetHandler:IsSyncedCode() then
	return
end

function gadget:GetInfo()
	return {
		name    = "Zenith Skyline Checker",
		desc    = "Blocks Zenith Meteor spawn when the beam is broken",
		author  = "Shaman",
		date    = "July 8 2020",
		license = "CC-0",
		layer   = -1,
		enabled = true,
	}
end

GG.zenith_spawnBlocked = {}

local gravityWeaponDefID = WeaponDefNames["zenith_gravity_neg"].id
local spSetUnitRulesParam = Spring.SetUnitRulesParam

function gadget:Explosion(weaponDefID, px, py, pz, attackerID, projectileID)
	if weaponDefID == gravityWeaponDefID then
		GG.zenith_spawnBlocked[attackerID] = true
	end
end

function gadget:Initialize()
	Script.SetWatchExplosion(gravityWeaponDefID, true)
end
