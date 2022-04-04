local pausemenu2 = {}

local ready = false

local pauseplus = require("pauseplus")
local playerManager = require("playerManager")
local textplus = require("textplus")
local exitFadeActive = false
local exitFadeOut = 0

function pausemenu2.onInitAPI()
	registerEvent(pausemenu2, "onKeyboardPress")
	registerEvent(pausemenu2, "onDraw")
	registerEvent(pausemenu2, "onLevelExit")
	registerEvent(pausemenu2, "onTick")
	registerEvent(pausemenu2, "onInputUpdate")
	registerEvent(pausemenu2, "onStart")
	registerEvent(pausemenu2, "onExit")
	registerEvent(pausemenu2, "onPause")
	registerEvent(pausemenu2, "onTickEnd")
	
	ready = true
end

function pausemenu2.onTickEnd()
	if pauseplus.currentSubmenu == nil then
       Audio.MusicVolume(pauseplus.getSelectionValue("settings","Music Volume"))
	end
	pauseplus.originalMusicVolume = pauseplus.getSelectionValue("settings","Music Volume")
end

local RESOLUTION_FULL = "fullscreen"
local RESOLUTION_WIDE = "widescreen"
local RESOLUTION_ULTRAWIDE = "ultrawide"
local RESOLUTION_NES = "nes"
local RESOLUTION_GB = "gameboy"
local RESOLUTION_GBA = "gba"
local RESOLUTION_IPHONEONE = "iphone1st"
local RESOLUTION_THREEDS = "3ds"

local LETTERBOXYES = true
local LETTERBOXNO = false

resolutions = SaveData.resolution
letterboxes = SaveData.letterbox

local screenModes = {
	[RESOLUTION_FULL] = {resolutions = "fullscreen"},
	[RESOLUTION_WIDE] = {resolutions = "widescreen"},
	[RESOLUTION_ULTRAWIDE] = {resolutions = "ultrawide"},
	[RESOLUTION_NES] = {resolutions = "nes"},
	[RESOLUTION_GB] = {resolutions = "gameboy"},
	[RESOLUTION_GBA] = {resolutions = "gba"},
	[RESOLUTION_IPHONEONE] = {resolutions = "iphone1st"},
	[RESOLUTION_THREEDS] = {resolutions = "3ds"},
}

local letterboxModes = {
	[LETTERBOXYES] = {letterboxes = true},
	[LETTERBOXNO] = {letterboxes = false},
}

local function changeresolution()
	SFX.play("_OST/_Sound Effects/resolution-set.ogg")
	screenModes = pauseplus.getSelectionValue("settings","Switch Resolution")
	if screenModes == RESOLUTION_FULL then
		SaveData.resolution = "fullscreen"
	elseif screenModes == RESOLUTION_WIDE then
		SaveData.resolution = "widescreen"
	elseif screenModes == RESOLUTION_ULTRAWIDE then
		SaveData.resolution = "ultrawide"
	elseif screenModes == RESOLUTION_NES then
		SaveData.resolution = "nes"
	elseif screenModes == RESOLUTION_GB then
		SaveData.resolution = "gameboy"
	elseif screenModes == RESOLUTION_GBA then
		SaveData.resolution = "gba"
	elseif screenModes == RESOLUTION_IPHONEONE then
		SaveData.resolution = "iphone1st"
	elseif screenModes == RESOLUTION_THREEDS then
		SaveData.resolution = "3ds"
	end
end

local function changeletterbox()
	if pauseplus.getSelectionValue("settings","Toggle Letterbox Scaling") then
		SFX.play("_OST/_Sound Effects/letterbox-disable.ogg")
		SaveData.letterbox = false
	else
		SFX.play("_OST/_Sound Effects/letterbox-enable.ogg")
		SaveData.letterbox = true
	end
end

local function changeresolutionborder()
	if pauseplus.getSelectionValue("settings","Toggle Resolution Border") then
		SFX.play("_OST/_Sound Effects/resolutionborder-enable.ogg")
		SaveData.borderEnabled = true
	else
		SFX.play("_OST/_Sound Effects/resolutionborder-disable.ogg")
		SaveData.borderEnabled = false
	end
end

local function characterchange()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(6, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_MEGAMAN) then
		player:transform(7, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_WARIO) then
		player:transform(8, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_BOWSER) then
		player:transform(9, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_KLONOA) then
		player:transform(10, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_NINJABOMBERMAN) then
		player:transform(11, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ROSALINA) then
		player:transform(12, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_SNAKE) then
		player:transform(13, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ZELDA) then
		player:transform(14, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ULTIMATERINKA) then
		player:transform(15, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_UNCLEBROADSWORD) then
		player:transform(16, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_SAMUS) then
		player:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchange13()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchange13_2p()
	local character = player2.character;
	if (character == CHARACTER_MARIO) then
		player2:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player2:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player2:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player2:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player2:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchangeleft()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(16, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_MEGAMAN) then
		player:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_WARIO) then
		player:transform(6, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_BOWSER) then
		player:transform(7, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_KLONOA) then
		player:transform(8, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_NINJABOMBERMAN) then
		player:transform(9, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ROSALINA) then
		player:transform(10, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_SNAKE) then
		player:transform(11, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ZELDA) then
		player:transform(12, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ULTIMATERINKA) then
		player:transform(13, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_UNCLEBROADSWORD) then
		player:transform(14, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_SAMUS) then
		player:transform(15, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchange13left()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchange13_2pleft()
	local character = player2.character;
	if (character == CHARACTER_MARIO) then
		player2:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player2:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player2:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player2:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player2:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function costumechangeright()
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumeIdx = table.ifind(costumes,currentCostume)
	
	if costumeIdx ~= nil then
		player:setCostume(costumes[costumeIdx + 1])
	else
		player:setCostume(costumes[1])
	end
	SFX.play("_OST/_Sound Effects/charcost_costume.ogg")
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
end

local function costumechangeleft()
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumeIdx = table.ifind(costumes,currentCostume)
	
	if costumeIdx ~= nil then
		player:setCostume(costumes[costumeIdx - 1])
	else
		player:setCostume(costumes[1])
	end
	SFX.play("_OST/_Sound Effects/charcost_costume.ogg")
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
end

function pausemenu2.onDraw()
	if exitFadeActive then
		Audio.MusicVolume(0)
		Misc.pause(true)
		exitFadeOut = math.min(1, exitFadeOut + 0.02)
		Graphics.drawScreen{color = Color.black.. exitFadeOut,priority = 4}
	end
	if SaveData.resolution == "fullscreen" then
		resolutionshow = "<color red>Resolution: Fullscreen (4:3)</color>"
	end
	if SaveData.resolution == "widescreen" then
		resolutionshow = "<color red>Resolution: Widescreen (16:9)</color>"
	end
	if SaveData.resolution == "ultrawide" then
		resolutionshow = "<color red>Resolution: Ultrawide (21:9)</color>"
	end
	if SaveData.resolution == "nes" then
		resolutionshow = "<color red>Resolution: NES/SNES</color>"
	end
	if SaveData.resolution == "gameboy" then
		resolutionshow = "<color red>Resolution: Gameboy/Gameboy Color</color>"
	end
	if SaveData.resolution == "gba" then
		resolutionshow = "<color red>Resolution: Gameboy Advance</color>"
	end
	if SaveData.resolution == "iphone1st" then
		resolutionshow = "<color red>Resolution: iPhone (1st Generation)</color>"
	end
	if SaveData.resolution == "3ds" then
		resolutionshow = "<color red>Resolution: Nintendo 3DS (Top Screen)</color>"
	end
	
	if SaveData.letterbox == true then
		letterboxscale = "<color red>Scaling enabled: No</color>"
	end
	if SaveData.letterbox == false then
		letterboxscale = "<color red>Scaling enabled: Yes</color>"
	end
	
	if SaveData.borderEnabled == true then
		resolutiontheme = "<color red>Border enabled: Yes</color>"
	end
	if SaveData.borderEnabled == false then
		resolutiontheme = "<color red>Border enabled: No</color>"
	end
	
	local currentCostume = player:getCostume()
	if currentCostume then
		costumename = "<color red>Current costume: "..currentCostume.."</color>"
	end
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		costumename = "<color red>Current costume: SMAS++ 2012 Beta Mario</color>"
	end
	if currentCostume == "1-SMB1-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. (NES)</color>"
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		costumename = "<color red>Current costume: Super Mario Bros. (Recolored)</color>"
	end
	if currentCostume == "3-SMB1-SMAS" then
		costumename = "<color red>Current costume: Super Mario Bros. (SNES)</color>"
	end
	if currentCostume == "4-SMB2-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. 2 (NES)</color>"
	end
	if currentCostume == "5-SMB2-SMAS" then
		costumename = "<color red>Current costume: Super Mario Bros. 2 (SNES)</color>"
	end
	if currentCostume == "6-SMB3-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. 3 (NES)</color>"
	end
	if currentCostume == "7-SML2" then
		costumename = "<color red>Current costume: Super Mario Land 2 (GB)</color>"
	end
	if currentCostume == "9-SMW-PIRATE" then
		costumename = "<color red>Current costume: Super Mario World (NES, Bootleg)</color>"
	end
	if currentCostume == "11-SMA1" then
		costumename = "<color red>Current costume: Super Mario Advance 1 (GBA)</color>"
	end
	if currentCostume == "12-SMA2" then
		costumename = "<color red>Current costume: Super Mario Advance 2 (GBA)</color>"
	end
	if currentCostume == "13-SMA4" then
		costumename = "<color red>Current costume: Super Mario Advance 4 (GBA)</color>"
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		costumename = "<color red>Current costume: New Super Mario Bros. (SMBX)</color>"
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		costumename = "<color red>Current costume: New Super Mario Bros. (NDS)</color>"
	end
	if currentCostume == "A2XT-DEMO" then
		costumename = "<color red>Current costume: Demo (A2XT)</color>"
	end
	if currentCostume == "DEMO-XMASPILY" then
		costumename = "<color red>Current costume: Pily (A2XT: Gaiden 2)</color>"
	end
	if currentCostume == "GA-CAILLOU" then
		costumename = "<color red>Current costume: Caillou (GoAnimate, Vyond)</color>"
	end
	if currentCostume == "GOLDENMARIO" then
		costumename = "<color red>Current costume: Golden Mario (SMBX)</color>"
	end
	if currentCostume == "GOOMBA" then
		costumename = "<color red>Current costume: Goomba (SMBX)</color>"
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		costumename = "<color red>Current costume: JC Foster Takes it to the Moon</color>"
	end
	if currentCostume == "MARINK" then
		costumename = "<color red>Current costume: The Legend of Mario (SMBX)</color>"
	end
	if currentCostume == "MODERN" then
		costumename = "<color red>Current costume: Modern Mario Bros.</color>"
	end
	if currentCostume == "PRINCESSRESCUE" then
		costumename = "<color red>Current costume: Princess Rescue (Atari 2600)</color>"
	end
	if currentCostume == "SMB0" then
		costumename = "<color red>Current costume: Super Mario Bros. 0 (SMBX)</color>"
	end
	if currentCostume == "SMG4" then
		costumename = "<color red>Current costume: SuperMarioGlitchy4 (YouTube)</color>"
	end
	if currentCostume == "SMM2-MARIO" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Mario)</color>"
	end
	if currentCostume == "SMM2-LUIGI" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Luigi)</color>"
	end
	if currentCostume == "SMM2-TOAD" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Toad)</color>"
	end
	if currentCostume == "SMM2-TOADETTE" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Toadette)</color>"
	end
	if currentCostume == "SMM2-YELLOWTOAD" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Yellow Toad)</color>"
	end
	if currentCostume == "SMW-MARIO" then
		costumename = "<color red>Current costume: Super Mario World (SNES)</color>"
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		costumename = "<color red>Current costume: Eric Cartman (South Park)</color>"
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		costumename = "<color red>Current costume: Super Mario World 2 (SNES)</color>"
	end
	
	if currentCostume == "0-SPENCEREVERLY" then
		costumename = "<color red>Current costume: Spencer Everly (SMBS)</color>"
	end
	if currentCostume == "3-SMB1-RETRO-MODERN" then
		costumename = "<color red>Current costume: Super Mario Bros. (NES, Modern)</color>"
	end
	if currentCostume == "4-SMB1-SMAS" then
		costumename = "<color red>Current costume: Super Mario Bros. (SNES)</color>"
	end
	if currentCostume == "5-SMB2-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. 2 (NES)</color>"
	end
	if currentCostume == "6-SMB2-SMAS" then
		costumename = "<color red>Current costume: Super Mario Bros. 2 (SNES)</color>"
	end
	if currentCostume == "7-SMB3-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. 3 (NES)</color>"
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		costumename = "<color red>Current costume: Marigi</color>"
	end
	if currentCostume == "10-SMW-ORIGINAL" then
		costumename = "<color red>Current costume: Super Mario World (SNES)</color>"
	end
	if currentCostume == "13-SMBDX" then
		costumename = "<color red>Current costume: Super Mario Bros. Deluxe (GBC)</color>"
	end
	if currentCostume == "15-SMA2" then
		costumename = "<color red>Current costume: Super Mario Advance 2 (GBA)</color>"
	end
	if currentCostume == "16-SMA4" then
		costumename = "<color red>Current costume: Super Mario Advance 4 (GBA)</color>"
	end
	if currentCostume == "17-NSMBDS-SMBX" then
		costumename = "<color red>Current costume: New Super Mario Bros. (SMBX)</color>"
	end
	if currentCostume == "A2XT-IRIS" then
		costumename = "<color red>Current costume: Iris (A2XT)</color>"
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		costumename = "<color red>Current costume: Larry (VeggieTales)</color>"
	end
	if currentCostume == "UNDERTALE-FRISK" then
		costumename = "<color red>Current costume: Frisk (Undertale)</color>"
	end
	if currentCostume == "WALUIGI" then
		costumename = "<color red>Current costume: Waluigi</color>"
	end
	if currentCostume == "SMW-LUIGI" then
		costumename = "<color red>Current costume: Super Mario World (SMAS)</color>"
	end
	
	if currentCostume == nil then
		costumename = "<color red>Current costume: N/A</color>"
	end
end

function returntolastlevel()
	pauseplus.canControlMenu = false
	SFX.play("_OST/_Sound Effects/lastlevel_warp.ogg")
	startFadeOut()
	Misc.saveGame()
	Routine.wait(1.3,true)
	Misc.unpause()
	exitFadeActive = false
	Level.load(SaveData.lastLevelPlayed, nil, nil)
end

function saveAndQuitRoutine()
	pauseplus.canControlMenu = false
	SFX.play("_OST/_Sound Effects/savequit.ogg")
	startFadeOut()
	Misc.saveGame()
	Routine.wait(1.6,true)
	Misc.unpause()
	exitFadeActive = false
	Misc.exitEngine()
end

function quitonly()
	pauseplus.canControlMenu = false
	SFX.play("_OST/_Sound Effects/nosave.ogg")
	startFadeOut()
	Routine.wait(0.7,true)
	Misc.unpause()
	exitFadeActive = false
	Misc.exitEngine()
end

function startFadeOut()
    exitFadeActive = true
end

function restartlevel()
	pauseplus.canControlMenu = false
	SFX.play("_OST/_Sound Effects/skip-intro.ogg")
	Misc.saveGame()
	startFadeOut()
	Routine.wait(1.6,true)
	Misc.unpause()
	exitFadeActive = false
	Level.load(Level.filename())
end

local function warpzonehub()
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
	player:teleport(20496, 19520, bottomCenterAligned)
end

local function touristhub()
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
	player:teleport(-119968, -120128, bottomCenterAligned)
end

local function starthub()
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
	player:teleport(-200608, -200128, bottomCenterAligned)
end

local function switchhub()
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
	player:teleport(40176, 39876, bottomCenterAligned)
end

local function shophub()
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
	player:teleport(80144, 79868, bottomCenterAligned)
end

local function startteleport()
	cooldown = 5
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	world.playerX = -2880
	world.playerY = -1664
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
end

local function sideteleport()
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	world.playerX = -3168
	world.playerY = -1536
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
end

local function hubmapteleport()
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	world.playerX = -3040
	world.playerY = -1760
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
end

local function dlcteleport()
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	world.playerX = -1760
	world.playerY = -1568
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
end

--Main Menu
pauseplus.font = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")
pauseplus.scale = 1.5
pauseplus.priority = -1
pauseplus.doResizing = false
pauseplus.optionGap = 4
pauseplus.offset = vector(0,0)
pauseplus.horizontalSpace = 59
pauseplus.verticalSpace   = 16
pauseplus.backgroundDarkness = 0
pauseplus.createSubmenu("main",{headerText = "<size 1.5>Paused.</size>"})
pauseplus.createOption("main",{text = "Continue",closeMenu = true,description = "Continue the game.",action = function() SFX.play("_OST/_Sound Effects/pausemenu-closed.ogg") end})
if not isOverworld then
	pauseplus.createOption("main",{text = "Restart",closeMenu = true,description = "Restart the area you're currently in. You'll warp back to the last checkpoint if crossed one.", action = function() Routine.run(restartlevel) end})
end
pauseplus.createSubmenu("settings",{headerText = "<size 1.5>Settings/Options</size>"})
pauseplus.createSubmenu("charactermenu",{headerText = "<size 1.5>Character Options</size>"})
pauseplus.createSubmenu("teleportmenu",{headerText = "<size 1.5>Teleportation Options</size>"})
if not isOverworld then
	pauseplus.createOption("main",{text = "Return to the Previous Level",closeMenu = true,description = "Returns to the previously played level. Useful while you're in the Hub or the other map.",action = function() Routine.run(returntolastlevel) end})
end
pauseplus.createOption("main",{text = "Character Options",goToSubmenu = "charactermenu",description = "Switch characters on the fly!"})
pauseplus.createOption("main",{text = "Settings/Options",goToSubmenu = "settings",description = "Set some settings to enhance your gameplay."})
if isOverworld then
	pauseplus.createOption("main",{text = "Teleportation Options",goToSubmenu = "teleportmenu",description = "Teleport to many places with this option (Select areas)."})
elseif (Level.filename() == "MALC - HUB.lvlx") == true then
	pauseplus.createOption("main",{text = "Teleportation Options",goToSubmenu = "teleportmenu",description = "Teleport to many places with this option (Select areas)."})
end
pauseplus.createOption("main",{text = "Save and Continue",description = "Save and continue your game.",pauseplus.save,closeMenu = true,action = function() SFX.play("_OST/_Sound Effects/save_dismiss.ogg") end})
pauseplus.createOption("main",{text = "Save and Quit",description = "Save and exit. You can continue later at any point. Remember to take breaks!",action = function() Routine.run(saveAndQuitRoutine) end})

-- Settings
pauseplus.createOption("settings",{text = "Switch Resolution",selectionType = pauseplus.SELECTION_NAMES,description = "Switch between resolutions.",selectionNames = {RESOLUTION_FULL,RESOLUTION_WIDE,RESOLUTION_ULTRAWIDE,RESOLUTION_NES,RESOLUTION_GB,RESOLUTION_GBA,RESOLUTION_IPHONEONE,RESOLUTION_THREEDS}, action = function() changeresolution() end})
pauseplus.createOption("settings",{text = "Toggle Letterbox Scaling",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Toggle scaling to display a full resolution while in fullscreen mode (Use F4 while in fullscreen).", action =  function() changeletterbox() end})
pauseplus.createOption("settings",{text = "Toggle Resolution Border",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Enable/disable borders when using other additional borders.", action =  function() changeresolutionborder() end})
pauseplus.createOption("settings",{text = "Music Volume",description = "Turn the music volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 60,selectionMin = 0,selectionMax = 100,selectionStep = 10,selectionFormat = "%d%%"})
if not isOverworld then
	pauseplus.createOption("settings",{text = "Turn ON/OFF 1.3 Mode",description = "Turn off/on 1.3 Mode to reenable/disable several features, including multiplayer.",pauseplus.save,closeMenu = true, actions = {function() SaveData.disableX2char = not SaveData.disableX2char Misc.unpause() Level.load(Level.filename()) end}})
end
if not isOverworld then
	pauseplus.createOption("settings",{text = "Go to the Extra Game/DLC Map",description = "Teleport to the Extra Game/DLC Map. Useful for fast traveling!",closeMenu = true, actions = {function() Misc.unpause() Level.load("SMAS - Map.lvlx", nil, nil) end}})
end
if not isOverworld then
	pauseplus.createOption("settings",{text = "Teleport to the Hub",description = "Teleport to the Me and Larry City Hub. Useful for fast traveling!",closeMenu = true, actions = {function() Misc.unpause() Level.load("MALC - HUB.lvlx", nil, nil) end}})
end
pauseplus.createOption("settings",{text = "Exit without Saving",description = "Exit without saving. YOU WILL LOSE PROGRESS IF YOU SELECT THIS OPTION!",action = {function() Routine.run(quitonly) end}})

--Character Menu
if SaveData.disableX2char == false then
	pauseplus.createOption("charactermenu",{text = "Change Character (Left)", action =  function() characterchangeleft() end})
	pauseplus.createOption("charactermenu",{text = "Change Character (Right)", action =  function() characterchange() end})
	pauseplus.createOption("charactermenu",{text = "Change Costumes (Left)", action =  function() costumechangeleft() end})
	pauseplus.createOption("charactermenu",{text = "Change Costumes (Right)", action =  function() costumechangeright() end})
end
if SaveData.disableX2char == true then
	pauseplus.createOption("charactermenu",{text = "Change Character 1P (Left)", action =  function() characterchange13left() end})
	pauseplus.createOption("charactermenu",{text = "Change Character 1P (Right)", action =  function() characterchange13() end})
	if Player.count() == 2 then
		pauseplus.createOption("charactermenu",{text = "Change Character 2P (Left)", action =  function() characterchange13_2pleft() end})
		pauseplus.createOption("charactermenu",{text = "Change Character 2P (Right)", action =  function() characterchange13_2p() end})
	end
end

--Teleportation Menu
if not isOverworld then
	if (Level.filename() == "MALC - HUB.lvlx") == true then
		pauseplus.createOption("teleportmenu",{text = "Teleport to the Tourist Center",closeMenu = true, action =  function() Routine.run(touristhub) end})
		pauseplus.createOption("teleportmenu",{text = "Teleport to the Warp Zone",closeMenu = true, action =  function() Routine.run(warpzonehub) end})
		pauseplus.createOption("teleportmenu",{text = "Teleport to the Character Switch Menu",closeMenu = true, action =  function() Routine.run(switchhub) end})
		pauseplus.createOption("teleportmenu",{text = "Teleport to the Shop",closeMenu = true, action =  function() Routine.run(shophub) end})
		pauseplus.createOption("teleportmenu",{text = "Teleport Back to the Start",closeMenu = true, action =  function() Routine.run(shophub) end})
	end
end
if isOverworld then
	pauseplus.createOption("teleportmenu",{text = "Teleport back to the Start",closeMenu = true, action =  function() Routine.run(startteleport) end})
	pauseplus.createOption("teleportmenu",{text = "Teleport to the Hub",closeMenu = true, action =  function() Routine.run(hubmapteleport) end})
	pauseplus.createOption("teleportmenu",{text = "Teleport to the Side Quest",closeMenu = true, action =  function() Routine.run(sideteleport) end})
	pauseplus.createOption("teleportmenu",{text = "Teleport to the DLC World",closeMenu = true, action =  function() Routine.run(dlcteleport) end})
end

return pausemenu2