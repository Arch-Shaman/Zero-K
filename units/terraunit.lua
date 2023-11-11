return { terraunit = {
  name                   = [[Terraform]],
  description            = [[Spent: 0]],
  builder                = false,
  buildPic               = [[levelterra.png]],
  capturable             = false,
  category               = [[TERRAFORM STUPIDTARGET]],
  collisionVolumeOffsets = [[0 -3000 0]],
  collisionVolumeScales  = [[32 32 32]],
  collisionVolumeType    = [[box]],
  selectionVolumeOffsets = [[0 0 0]],
  selectionVolumeScales  = [[44 22 44]],
  selectionVolumeType    = [[box]],

  customParams           = {
    dontcount      = [[1]],
    dontkill       = [[1]],
    mobilebuilding = [[1]],
    cannotcloak    = [[1]],
    instantselfd   = [[1]],
  },

  explodeAs              = [[NOWEAPON]],
  footprintX             = 2,
  footprintZ             = 2,
  health                 = 100000,
  idleAutoHeal           = 0,
  isFeature              = false,
  levelGround            = false,
  maxSlope               = 255,
  metalCost              = 100000,
  minCloakDistance       = 0,
  objectName             = [[sphere.s3o]],
  reclaimable            = false,
  script                 = [[terraunit.lua]],
  selfDestructAs         = [[NOWEAPON]],
  selfDestructCountdown  = 0,
  sightDistance          = 0,
  stealth                = true,
  upright                = false,
  workerTime             = 0,
  yardMap                = [[yyyy]],
} }
