-- $Id: modrules.lua 4625 2009-05-16 13:11:14Z google frog $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    modrules.lua
--  brief:   modrules definitions
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local modrules  = {
  
  movement = {
    allowAirPlanesToLeaveMap = true;  -- defaults to true
    allowPushingEnemyUnits   = true; -- defaults to false
    allowCrushingAlliedUnits = false; -- defaults to false
    allowUnitCollisionDamage = true; -- defaults to false
  },
  
  construction = {
    constructionDecay      = false; -- defaults to true
    constructionDecayTime  = 6.66;  -- defaults to 6.66
    constructionDecaySpeed = 0.03;  -- defaults to 0.03
  },


  reclaim = {
    multiReclaim  = 1;    -- defaults to 0
    reclaimMethod = 0;    -- defaults to 1
    unitMethod    = 0;    -- defaults to 1

    unitEnergyCostFactor    = 0;  -- defaults to 0
    unitEfficiency          = 0.5;  -- defaults to 1
    featureEnergyCostFactor = 0;  -- defaults to 0

    allowEnemies  = false;  -- defaults to true
    allowAllies   = false;  -- defaults to true
  },


  repair = {
    energyCostFactor = 1/3,  -- defaults to 0
  },


  resurrect = {
    energyCostFactor = 1.5,  -- defaults to 0.5
  },


  capture = {
    energyCostFactor = 1,  -- defaults to 0
  },
  
  
  paralyze = {
    paralyzeOnMaxHealth = true, -- defaults to true
  },

  sensors = {
    requireSonarUnderWater = true,  -- defaults to true
    
    los = {
      losMipLevel = 3,  -- defaults to 1
      losMul      = 1,  -- defaults to 1
      airMipLevel = 4,  -- defaults to 2
      airMul      = 1,  -- defaults to 1
    },
  },


  transportability = {
    transportGround = 1;   -- defaults to 1
    transportHover  = 1;   -- defaults to 0
    transportShip   = 1;  -- defaults to 0
    transportAir    = 0;  -- defaults to 0
  },


  flankingBonus = {
    -- defaults to 1
    -- 0: no flanking bonus  
    -- 1: global coords, mobile  
    -- 2: unit coords, mobile  
    -- 3: unit coords, locked 
    defaultMode=0;
  },


  experience = {
    experienceMult = 1.0; -- defaults to 1.0

    -- these are all used in the following form:
    --   value = defValue * (1 + (scale * (exp / (exp + 1))))
    powerScale  = 0.3;  -- defaults to 1.0
    healthScale = 0;  -- defaults to 0.7
    reloadScale = 0;  -- defaults to 0.4
  },


  fireAtDead = {
    fireAtKilled   = false;  -- defaults to false
    fireAtCrashing = false;   -- defaults to false
  },

  movement = {
    allowUnitCollisionOverlap = true,	-- defaults to true
    useClassicGroundMoveType = (Spring.GetModOptions() and (Spring.GetModOptions().pathfinder == "classic") and true) or false,
  },

  nanospray = {
    allow_team_colors = true;  -- defaults to true
  },
  
  featureLOS = {
    -- 0 - no default LOS for features
    -- 1 - gaia features always visible
    -- 2 - allyteam/gaia features always visible
    -- 3 - all features always visible
    -- default 3
    featureVisibility = 1;
  },
  
  system = {
    pathFinderSystem = (Spring.GetModOptions() and (Spring.GetModOptions().pathfinder == "qtpfs") and 1) or 0,
  },
}
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

return modrules

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

