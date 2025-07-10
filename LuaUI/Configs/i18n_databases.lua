local translationExtras = { -- lists databases to be merged into the main one
	units = {"campaign_units", "pw_units"},
	interface = {"common", "healthbars", "resbars"},
}

local translations = {
	units = true,
	epicmenu = true,
	interface = true,
	missions = true,
}

local cjkLangs = {
	["ja"] = true,
	["zh-tw"] = true,
	["zh-cn"] = true,
	["zh"] = true,
	["tw"] = true,
	["ko"] = true,
}

return translationExtras, translations, cjkLangs
