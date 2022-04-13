local pausemenu2 = {}

local ready = false

local pauseplus = require("pauseplus")
local playerManager = require("playerManager")
local rng = require("rng")
local textplus = require("textplus")
local rooms = require("rooms")
local smasdeathsystem = require("smasdeathsystem")
local musicalchairs = require("musicalchairs")
local sprite = require("base/sprite")
local exitFadeActive = false
local exitFadeActiveDone = false
local exitFadeOut = 0

if SaveData.deathquickoption == nil then
	SaveData.deathquickoption = false
end

local pausefont3 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")

local battlelevelsrng = {"battle_battleshrooms.lvl", "battle_battle-zone.lvl", "battle_classic-castle-battle.lvl", "battle_dry-dry-desert.lvl", "battle_hyrule-temple.lvl", "battle_invasion-battlehammer.lvl", "battle_lakitu-mechazone.lvl", "battle_lethal-lava-level.lvl", "battle_slippy-slap-snowland.lvl", "battle_woody-warzone.lvl","battle_retroville-underground.lvl","battle_testlevel.lvlx"}
local selecter = rng.randomInt(1,#battlelevelsrng)

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
	registerEvent(pausemenu2, "onPlayerKill")
	
	ready = true
end

local RESOLUTION_FULL = "Fullscreen (4:3)"
local RESOLUTION_WIDE = "Widescreen (16:9)"
local RESOLUTION_ULTRAWIDE = "Ultrawide (21:9)"
local RESOLUTION_NES = "NES/SNES/Genesis"
local RESOLUTION_GB = "Gameboy/Gameboy Color"
local RESOLUTION_GBA = "Gameboy Advance"
local RESOLUTION_IPHONEONE = "iPhone (1st Generation)"
local RESOLUTION_THREEDS = "Nintendo 3DS (Top Screen)"

local COSTUME_NAME = player:getCostume() or "N/A"

local LETTERBOXYES = true
local LETTERBOXNO = false

resolutions = SaveData.resolution
letterboxes = SaveData.letterbox
costumenaming = player:getCostume()

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

local costumenames = {
	[COSTUME_NAME] = {costumenaming = "costume"},
}

function pausemenu2.onTick()
	if SaveData.deathquickoption == true then
		Audio.sounds[8].muted = true
		rooms.quickRespawn = true
		-- Whether or not collectibles (coins, mushrooms, 1-ups, etc) respawn after dying (only affects quick respawn).
		rooms.collectiblesRespawn = true
		-- Whether or not blocks reset themselves and the p-switch effect resets after dying (only affects quick respawn).
		rooms.blocksReset = true
		-- Whether or not non-saved star coins will reset after dying (only affects quick respawn).
		rooms.starCoinsReset = false
		-- Whether or not to create a pseudo "checkpoint" on entering a different section.
		rooms.checkpointOnEnterSection = true
		-- Whether or not everything is reset on entering a room.
		rooms.resetOnEnteringRoom = true
		smasdeathsystem.activated = false
		rooms.deathSoundEffect = 54
	elseif SaveData.deathquickoption == false then
		Audio.sounds[8].muted = true
		rooms.quickRespawn = false
		-- Whether or not collectibles (coins, mushrooms, 1-ups, etc) respawn after dying (only affects quick respawn).
		rooms.collectiblesRespawn = true
		-- Whether or not blocks reset themselves and the p-switch effect resets after dying (only affects quick respawn).
		rooms.blocksReset = false
		-- Whether or not non-saved star coins will reset after dying (only affects quick respawn).
		rooms.starCoinsReset = false
		-- Whether or not to create a pseudo "checkpoint" on entering a different section.
		rooms.checkpointOnEnterSection = false
		-- Whether or not everything is reset on entering a room.
		rooms.resetOnEnteringRoom = false
		smasdeathsystem.activated = true
		rooms.deathSoundEffect = 8
	end
end

function pausemenu2.onPlayerKill()
	if SaveData.deathquickoption == true then
		SFX.play(rooms.deathSoundEffect)
	end
end

local function changeresolution()
	playSound("resolution-set.ogg")
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
		playSound("letterbox-disable.ogg")
		SaveData.letterbox = false
	else
		playSound("letterbox-enable.ogg")
		SaveData.letterbox = true
	end
end

local function changeresolutionborder()
	if pauseplus.getSelectionValue("settings","Toggle Resolution Border") then
		playSound("resolutionborder-enable.ogg")
		SaveData.borderEnabled = true
	else
		playSound("resolutionborder-disable.ogg")
		SaveData.borderEnabled = false
	end
end

local function quickdeathoption()
	if pauseplus.getSelectionValue("settings","Enable Quick Death") then
		if SaveData.disablexchar == false and GameData.battlemodeactive == nil or GameData.battlemodeactive == false then
			SaveData.deathquickoption = true
			playSound("quickdeath_enabled.ogg")
		end
	else
		SaveData.deathquickoption = false
		playSound("quickdeath_disabled.ogg")
	end
end

local function characterchange()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(2, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(3, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(4, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(5, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(6, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_MEGAMAN) then
		player:transform(7, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_WARIO) then
		player:transform(8, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_BOWSER) then
		player:transform(9, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_KLONOA) then
		player:transform(10, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_NINJABOMBERMAN) then
		player:transform(11, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_ROSALINA) then
		player:transform(12, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_SNAKE) then
		player:transform(13, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_ZELDA) then
		player:transform(14, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_ULTIMATERINKA) then
		player:transform(15, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_UNCLEBROADSWORD) then
		player:transform(16, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if SMBX_VERSION <= VER_BETA4_PATCH_4_1 then
		if (character == CHARACTER_SAMUS) then
			player:transform(1, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	elseif SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_SAMUS) then
			player:transform(17, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
	if SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_YIYOSHI) then
			player:transform(18, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
	if SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_JUNI) then
			player:transform(19, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
	if SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_MCSTEVE) then
			player:transform(20, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
	if SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_PRINCESSRINKA) then
			player:transform(1, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
end

local function characterchange13()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(2, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(3, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(4, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(5, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(1, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
end

local function characterchange13_2p()
	local character = player2.character;
	if (character == CHARACTER_MARIO) then
		player2:transform(2, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player2:transform(3, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player2:transform(4, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player2:transform(5, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player2:transform(1, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
end

local function characterchangeleft()
	local character = player.character;
	if SMBX_VERSION <= VER_BETA4_PATCH_4_1 then
		if (character == CHARACTER_MARIO) then
			player:transform(16, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	elseif SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_MARIO) then
			player:transform(20, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(1, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(2, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(3, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(4, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_MEGAMAN) then
		player:transform(5, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_WARIO) then
		player:transform(6, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_BOWSER) then
		player:transform(7, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_KLONOA) then
		player:transform(8, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_NINJABOMBERMAN) then
		player:transform(9, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_ROSALINA) then
		player:transform(10, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_SNAKE) then
		player:transform(11, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_ZELDA) then
		player:transform(12, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_ULTIMATERINKA) then
		player:transform(13, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_UNCLEBROADSWORD) then
		player:transform(14, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_SAMUS) then
		player:transform(15, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_YIYOSHI) then
			player:transform(16, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
	if SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_JUNI) then
			player:transform(17, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
	if SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_MCSTEVE) then
			player:transform(18, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
	if SMBX_VERSION == VER_SEE_MOD then
		if (character == CHARACTER_PRINCESSRINKA) then
			player:transform(19, false)
			SFX.play(32)
			playSound("charcost-selected.ogg")
			playSound("racoon-changechar.ogg")
		end
	end
end

local function characterchange13left()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(5, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(1, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(2, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(3, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(4, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
end

local function characterchange13_2pleft()
	local character = player2.character;
	if (character == CHARACTER_MARIO) then
		player2:transform(5, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player2:transform(1, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player2:transform(2, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player2:transform(3, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player2:transform(4, false)
		SFX.play(32)
		playSound("charcost-selected.ogg")
		playSound("racoon-changechar.ogg")
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
	playSound("charcost_costume.ogg")
	playSound("charcost-selected.ogg")
	Routine.run(musicalchairs.switcher)
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
	playSound("charcost_costume.ogg")
	playSound("charcost-selected.ogg")
	Routine.run(musicalchairs.switcher)
end

function pausemenu2.onDraw()
	if GameData.starActive == true or GameData.megashroomActive == true or GameData.cutsceneMusicControl == true or GameData.muteMusic == true then
		Audio.MusicVolume(0)
	elseif GameData.muteMusic == false or GameData.muteMusic == nil or GameData.starActive == false or GameData.megashroomActive == false or GameData.cutsceneMusicControl == false or GameData.starActive == nil or GameData.megashroomActive == nil or GameData.cutsceneMusicControl == nil then
		Audio.MusicVolume(pauseplus.getSelectionValue("settings","Music Volume"))
	end
	sfxVolume = pauseplus.getSelectionValue("settings","SFX Volume")
	for i = 1, 91 do
		Audio.sounds[i].sfx.volume = math.floor(sfxVolume * 128 + 0.5)
	end
	SFX.volume.MASTER = sfxVolume
	if exitFadeActive then
		Audio.MusicVolume(0)
		Misc.pause(true)
		exitFadeOut = math.min(1, exitFadeOut + 0.05)
		Graphics.drawScreen{color = Color.black.. exitFadeOut,priority = 4}
	end
	if exitFadeActiveDone then
		Graphics.drawScreen{color = Color.black,priority = 4}
	end
	local currentCostume = player:getCostume()
	if currentCostume then
		costtext = currentCostume
	end
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		costtext = "SMAS++ 2012 Beta Mario"
	end
	if currentCostume == "1-SMB1-RETRO" then
		costtext = "Super Mario Bros. (NES)"
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		costtext = "Super Mario Bros. (Recolored)"
	end
	if currentCostume == "3-SMB1-SMAS" then
		costtext = "Super Mario Bros. (SNES)"
	end
	if currentCostume == "4-SMB2-RETRO" then
		costtext = "Super Mario Bros. 2 (NES)"
	end
	if currentCostume == "5-SMB2-SMAS" then
		costtext = "Super Mario Bros. 2 (SNES)"
	end
	if currentCostume == "6-SMB3-RETRO" then
		costtext = "Super Mario Bros. 3 (NES)"
	end
	if currentCostume == "7-SML2" then
		costtext = "Super Mario Land 2 (GB)"
	end
	if currentCostume == "9-SMW-PIRATE" then
		costtext = "Super Mario World (NES, Bootleg)"
	end
	if currentCostume == "11-SMA1" then
		costtext = "Super Mario Advance 1 (GBA)"
	end
	if currentCostume == "12-SMA2" then
		costtext = "Super Mario Advance 2 (GBA)"
	end
	if currentCostume == "13-SMA4" then
		costtext = "Super Mario Advance 4 (GBA)"
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		costtext = "New Super Mario Bros. (SMBX)"
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		costtext = "New Super Mario Bros. (NDS)"
	end
	if currentCostume == "A2XT-DEMO" then
		costtext = "Demo (A2XT)"
	end
	if currentCostume == "DEMO-XMASPILY" then
		costtext = "Pily (A2XT: Gaiden 2)"
	end
	if currentCostume == "GA-CAILLOU" then
		costtext = "Caillou (GoAnimate, Vyond)"
	end
	if currentCostume == "GOLDENMARIO" then
		costtext = "Golden Mario (SMBX)"
	end
	if currentCostume == "GOOMBA" then
		costtext = "Goomba (SMBX)"
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		costtext = "JC Foster Takes it to the Moon"
	end
	if currentCostume == "MARINK" then
		costtext = "The Legend of Mario (SMBX)"
	end
	if currentCostume == "MODERN" then
		costtext = "Modern Mario Bros."
	end
	if currentCostume == "PRINCESSRESCUE" then
		costtext = "Princess Rescue (Atari 2600)"
	end
	if currentCostume == "SMB0" then
		costtext = "Super Mario Bros. 0 (SMBX)"
	end
	if currentCostume == "SMG4" then
		costtext = "SuperMarioGlitchy4 (YouTube)"
	end
	if currentCostume == "SMM2-MARIO" then
		costtext = "Super Mario Maker (SMW, Mario)"
	end
	if currentCostume == "SMM2-LUIGI" then
		costtext = "Super Mario Maker (SMW, Luigi)"
	end
	if currentCostume == "SMM2-TOAD" then
		costtext = "Super Mario Maker (SMW, Toad)"
	end
	if currentCostume == "SMM2-TOADETTE" then
		costtext = "Super Mario Maker (SMW, Toadette)"
	end
	if currentCostume == "SMM2-YELLOWTOAD" then
		costtext = "Super Mario Maker (SMW, Yellow Toad)"
	end
	if currentCostume == "SMW-MARIO" then
		costtext = "Super Mario World (SNES)"
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		costtext = "Eric Cartman (South Park)"
	end
	if currentCostume == "SPONGEBOBSQUAREPANTS" then
		costtext = "SpongeBob SquarePants"
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		costtext = "Super Mario World 2 (SNES)"
	end
	
	if currentCostume == "0-SPENCEREVERLY" then
		costtext = "Spencer Everly (SMBS)"
	end
	if currentCostume == "3-SMB1-RETRO-MODERN" then
		costtext = "Super Mario Bros. (NES, Modern)"
	end
	if currentCostume == "4-SMB1-SMAS" then
		costtext = "Super Mario Bros. (SNES)"
	end
	if currentCostume == "5-SMB2-RETRO" then
		costtext = "Super Mario Bros. 2 (NES)"
	end
	if currentCostume == "6-SMB2-SMAS" then
		costtext = "Super Mario Bros. 2 (SNES)"
	end
	if currentCostume == "7-SMB3-RETRO" then
		costtext = "Super Mario Bros. 3 (NES)"
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		costtext = "Marigi"
	end
	if currentCostume == "10-SMW-ORIGINAL" then
		costtext = "Super Mario World (SNES)"
	end
	if currentCostume == "13-SMBDX" then
		costtext = "Super Mario Bros. Deluxe (GBC)"
	end
	if currentCostume == "15-SMA2" then
		costtext = "Super Mario Advance 2 (GBA)"
	end
	if currentCostume == "16-SMA4" then
		costtext = "Super Mario Advance 4 (GBA)"
	end
	if currentCostume == "17-NSMBDS-SMBX" then
		costtext = "New Super Mario Bros. (SMBX)"
	end
	if currentCostume == "A2XT-IRIS" then
		costtext = "Iris (A2XT)"
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		costtext = "Larry (VeggieTales)"
	end
	if currentCostume == "UNDERTALE-FRISK" then
		costtext = "Frisk (Undertale)"
	end
	if currentCostume == "WALUIGI" then
		costtext = "Waluigi"
	end
	if currentCostume == "SMW-LUIGI" then
		costtext = "Super Mario World (SMAS)"
	end
	
	if currentCostume == nil then
		costtext = "N/A"
	end
	if pauseplus.currentSubmenu then
		if not isOverworld then
			textplus.print{x = 20, y = 560, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = 0, xscale = 1.5, yscale = 1.5}
			if SaveData.playerPfp == nil then
				sprite.draw{texture = loadImg("___MainUserDirectory/pfp/pfp.png"), width = 70, height = 70, x = 40, y = 35, priority = -1}
			else
				sprite.draw{texture = loadImg("___MainUserDirectory/"..SaveData.playerPfp..""), width = 70, height = 70, x = 40, y = 35, priority = -1}
			end
			textplus.print{x = 125, y = 60, text = "<color rainbow>"..SaveData.playerName.."</color>", font = pausefont3, priority = 0, xscale = 1.5, yscale = 1.5}
		elseif isOverworld then
			if SaveData.resolution == "fullscreen" then
				textplus.print{x = 20, y = 560, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = 8, xscale = 1.5, yscale = 1.5}
			elseif SaveData.resolution == "widescreen" then
				textplus.print{x = 20, y = 490, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = 8, xscale = 1.5, yscale = 1.5}
			elseif SaveData.resolution == "ultrawide" then
				textplus.print{x = 20, y = 440, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = 8, xscale = 1.5, yscale = 1.5}
			elseif SaveData.resolution == "nes" then
				textplus.print{x = 160, y = 490, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = 8, xscale = 1.5, yscale = 1.5}
			elseif SaveData.resolution == "gameboy" then
				textplus.print{x = 250, y = 400, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = 8, xscale = 0.8, yscale = 0.8}
			elseif SaveData.resolution == "gba" then
				textplus.print{x = 190, y = 440, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = 8, xscale = 1.2, yscale = 1.2}
			elseif SaveData.resolution == "iphone1st" then
				textplus.print{x = 280, y = 490, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = 8, xscale = 1.2, yscale = 1.2}
			elseif SaveData.resolution == "3ds" then
				textplus.print{x = 300, y = 558, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = 8, xscale = 1.2, yscale = 1.2}
			end
		end
	end
end

function battlemodenewstage()
	pauseplus.canControlMenu = false
	playSound("skip-intro.ogg")
	startFadeOut()
	Routine.wait(1.5, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load(battlelevelsrng[selecter], nil, nil)
end

function battlemodeexit()
	pauseplus.canControlMenu = false
	playSound("world_warp.ogg")
	startFadeOut()
	Routine.wait(0.4, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load("SMAS - Start.lvlx", nil, nil)
end

function returntolastlevel()
	pauseplus.canControlMenu = false
	playSound("lastlevel_warp.ogg")
	startFadeOut()
	Misc.saveGame()
	Routine.wait(1.3,true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load(SaveData.lastLevelPlayed, nil, nil)
end

local function exitlevel2()
	pauseplus.canControlMenu = false
	Audio.MusicVolume(0)
	Audio.MusicPause()
	playSound("world_warp.ogg")
	startFadeOut()
	Misc.saveGame()
	Routine.wait(0.7, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.exit()
end

function saveAndQuitRoutine()
	pauseplus.canControlMenu = false
	playSound("savequit.ogg")
	startFadeOut()
	Misc.saveGame()
	Routine.wait(1.6,true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Misc.exitEngine()
end

function quitonly()
	pauseplus.canControlMenu = false
	playSound("nosave.ogg")
	startFadeOut()
	Routine.wait(0.7,true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Misc.exitEngine()
end

function onethreemodeactivate()
	pauseplus.canControlMenu = false
	if SaveData.disableX2char == false then
		playSound("1.3Mode/dragon-coin.ogg")
		playSound("1.3Mode/key.ogg")
	elseif SaveData.disableX2char == true then
		playSound("dragon-coin.ogg")
		playSound("key.ogg")
	end
	startFadeOut()
	Misc.saveGame()
	Routine.wait(2.3,true)
	SaveData.disableX2char = not SaveData.disableX2char
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Graphics.activateHud(false)
	Cheats.trigger("1player")
	player:transform(1, false)
	Level.load(Level.filename())
end

function startFadeOut()
    exitFadeActive = true
end

function restartlevel()
	pauseplus.canControlMenu = false
	playSound("skip-intro.ogg")
	Misc.saveGame()
	startFadeOut()
	Routine.wait(1.6,true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load(Level.filename())
end

function mainmenu()
	pauseplus.canControlMenu = false
	playSound("shutdown.ogg")
	startFadeOut()
	Misc.saveGame()
	Routine.wait(2.4, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load("SMAS - Start.lvlx", nil, nil)
end

local function warpzonehub()
	Misc.unpause()
	playSound("hub_travelactivated.ogg")
	playSound("world_warp.ogg")
	player:teleport(20496, 19520, bottomCenterAligned)
end

local function touristhub()
	Misc.unpause()
	playSound("hub_travelactivated.ogg")
	playSound("world_warp.ogg")
	player:teleport(-119968, -120128, bottomCenterAligned)
end

local function starthub()
	Misc.unpause()
	playSound("hub_travelactivated.ogg")
	playSound("world_warp.ogg")
	player:teleport(-200608, -200128, bottomCenterAligned)
end

local function switchhub()
	Misc.unpause()
	playSound("hub_travelactivated.ogg")
	playSound("world_warp.ogg")
	player:teleport(40176, 39876, bottomCenterAligned)
end

local function shophub()
	Misc.unpause()
	playSound("hub_travelactivated.ogg")
	playSound("world_warp.ogg")
	player:teleport(80144, 79868, bottomCenterAligned)
end

local function hubteleportlevel()
	cooldown = 5
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	playSound("hub_travelactivated.ogg")
	playSound("world_warp.ogg")
	pauseplus.canControlMenu = false
	startFadeOut()
	Routine.wait(1.0, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load("MALC - HUB.lvlx", nil, nil)
end

local function startteleport()
	cooldown = 5
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	playSound("hub_travelactivated.ogg")
	SaveData.smwMap.playerX = -195072
	SaveData.smwMap.playerY = -197760
	playSound("world_warp.ogg")
	pauseplus.canControlMenu = false
	startFadeOut()
	Routine.wait(1.0, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load(Level.filename())
end

local function sideteleport()
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	playSound("hub_travelactivated.ogg")
	world.playerX = -3168
	world.playerY = -1536
	playSound("world_warp.ogg")
	pauseplus.canControlMenu = false
	startFadeOut()
	Routine.wait(1.0, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load(Level.filename())
end

local function hubmapteleport()
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	playSound("hub_travelactivated.ogg")
	SaveData.smwMap.playerX = -195232
	SaveData.smwMap.playerY = -197856
	playSound("world_warp.ogg")
	pauseplus.canControlMenu = false
	startFadeOut()
	Routine.wait(1.0, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load(Level.filename())
end

local function dlcteleport()
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	playSound("hub_travelactivated.ogg")
	SaveData.smwMap.playerX = -199040
	SaveData.smwMap.playerY = -199936
	playSound("world_warp.ogg")
	pauseplus.canControlMenu = false
	startFadeOut()
	Routine.wait(1.0, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Level.load(Level.filename(), nil, nil)
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
pauseplus.createOption("main",{text = "Continue",closeMenu = true,description = "Continue the game.",action = function() playSound("pausemenu-closed.ogg") end})
if GameData.battlemodeactive == true then
	if not isOverworld then
		pauseplus.createOption("main",{text = "Start a New Stage",closeMenu = true,description = "Starts a new stage in Classic Battle Mode. The stage will be picked at random!",action = function() Routine.run(battlemodenewstage) end})
		pauseplus.createOption("main",{text = "Restart this Stage",closeMenu = true,description = "Restarts the same stage over. Useful if you're stuck somewhere and need to restart the match.",action = function() Routine.run(restartlevel) end})
		pauseplus.createOption("main",{text = "Exit Battle Mode",closeMenu = true,description = "To exit battle mode, use this option. This will reset the game back to the preboot menu.",action = function() Routine.run(battlemodeexit) end})
	end
end
if GameData.battlemodeactive == nil or GameData.battlemodeactive == false then
	if (Level.filename() == "map.lvlx") == false then
		pauseplus.createOption("main",{text = "Restart",closeMenu = true,description = "Restart the area you're currently in. You'll warp back to the last checkpoint if crossed one.", action = function() Routine.run(restartlevel) end})
	end
	if (Level.filename() == "map.lvlx") == false then
		pauseplus.createOption("main",{text = "Return to the Map",closeMenu = true,description = "Returns to the map of the game.",action = function() Routine.run(exitlevel2) end})
	end
	pauseplus.createSubmenu("settings",{headerText = "<size 1.5>Settings/Options</size>"})
	pauseplus.createSubmenu("charactermenu",{headerText = "<size 1.5>Character Options</size>"})
	pauseplus.createSubmenu("teleportmenu",{headerText = "<size 1.5>Teleportation Options</size>"})
	pauseplus.createOption("main",{text = "Character Options",goToSubmenu = "charactermenu",description = "Switch characters on the fly!"})
	pauseplus.createOption("main",{text = "Settings/Options",goToSubmenu = "settings",description = "Set some settings to enhance your gameplay."})
	if (Level.filename() == "map.lvlx") == true then
		pauseplus.createOption("main",{text = "Teleportation Options",goToSubmenu = "teleportmenu",description = "Teleport to many places with this option (Select areas)."})
	elseif (Level.filename() == "MALC - HUB.lvlx") == true then
		pauseplus.createOption("main",{text = "Teleportation Options",goToSubmenu = "teleportmenu",description = "Teleport to many places with this option (Select areas)."})
	elseif (Level.filename() == "MALC - HUB.lvlx") == false then
		pauseplus.createOption("main",{text = "Teleportation Options",goToSubmenu = "teleportmenu",description = "Teleport to many places with this option (Select areas)."})
	end
	pauseplus.createOption("main",{text = "Save and Continue",description = "Save and continue your game.",pauseplus.save,closeMenu = true,action = function() playSound("save_dismiss.ogg") end})
	if not isOverworld then
		pauseplus.createOption("main",{text = "Save and Reset Game",description = "Saves and resets the game back to the preboot menu. Useful for setting options you can't set in the pause menu.",pauseplus.save,closeMenu = true,action = function() Routine.run(mainmenu) end})
	end
	pauseplus.createOption("main",{text = "Save and Quit",description = "Save and exit. You can continue later at any point. Remember to take breaks!",action = function() Routine.run(saveAndQuitRoutine) end})

	-- Settings
	pauseplus.createOption("settings",{text = "Switch Resolution",selectionType = pauseplus.SELECTION_NAMES,description = "Switch between resolutions.",selectionNames = {RESOLUTION_FULL,RESOLUTION_WIDE,RESOLUTION_ULTRAWIDE,RESOLUTION_NES,RESOLUTION_GB,RESOLUTION_GBA,RESOLUTION_IPHONEONE,RESOLUTION_THREEDS}, action = function() changeresolution() end})
	pauseplus.createOption("settings",{text = "Toggle Letterbox Scaling",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Toggle scaling to display a full resolution while in fullscreen mode (Use F4 while in fullscreen).", action =  function() changeletterbox() end})
	pauseplus.createOption("settings",{text = "Toggle Resolution Border",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Enable/disable borders when using other additional borders.", action =  function() changeresolutionborder() end})
	if not isOverworld then
		pauseplus.createOption("settings",{text = "Enable Quick Death",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Enable/disable quick dying animations. This won't affect 1.3 Mode.", action =  function() quickdeathoption() end})
	end
	pauseplus.createOption("settings",{text = "Music Volume",description = "Turn the music volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 60,selectionMin = 0,selectionMax = 100,selectionStep = 5,selectionFormat = "%d%%"})
	pauseplus.createOption("settings",{text = "SFX Volume",description = "Turn the sound effect volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 1,selectionMin = 0,selectionMax = 1,selectionStep = 0.1,selectionFormat = "%d%%"})
	if (Level.filename() == "map.lvlx") == false then
		pauseplus.createOption("settings",{text = "Turn ON/OFF 1.3 Mode",description = "Turn off/on 1.3 Mode to enable/disable several features, including multiplayer. COSTUMES WILL BE RESET!",pauseplus.save,closeMenu = true, actions = {function() Routine.run(onethreemodeactivate) end}})
	end
	pauseplus.createOption("settings",{text = "Exit without Saving",description = "Exit without saving. YOU WILL LOSE PROGRESS IF YOU SELECT THIS OPTION!",action = {function() Routine.run(quitonly) end}})

	--Character Menu
	if SaveData.disableX2char == false then
		pauseplus.createOption("charactermenu",{text = "Change Character (Left)",description = "Switch the player's character to anything of your choice!", action =  function() characterchangeleft() end})
		pauseplus.createOption("charactermenu",{text = "Change Character (Right)",description = "Switch the player's character to anything of your choice!", action =  function() characterchange() end})
		pauseplus.createOption("charactermenu",{text = "Change Costumes (Left)",description = "Switch the player's costume to anything of your choice!", action =  function() costumechangeleft() end})
		pauseplus.createOption("charactermenu",{text = "Change Costumes (Right)",description = "Switch the player's costume to anything of your choice!", action =  function() costumechangeright() end})
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
		if (Level.filename() == "map.lvlx") == false then
			pauseplus.createOption("teleportmenu",{text = "Teleport to the Previous Level",closeMenu = true,description = "Returns to the previously played level. Useful while you're in the Hub.",action = function() Routine.run(returntolastlevel) end})
		end
		if (Level.filename() == "MALC - HUB.lvlx") == true then
			pauseplus.createOption("teleportmenu",{text = "Teleport to the Tourist Center",closeMenu = true,description = "Teleports to inside of the 1st building in Me and Larry City. Useful for fast traveling!", action =  function() Routine.run(touristhub) end})
			pauseplus.createOption("teleportmenu",{text = "Teleport to the Warp Zone",closeMenu = true,description = "Teleports to the skies, in the Hub Warp Zone. Useful for fast traveling!", action =  function() Routine.run(warpzonehub) end})
			pauseplus.createOption("teleportmenu",{text = "Teleport to the Character Switch Menu",closeMenu = true,description = "Teleports to the Tourist Center's Character Switch Room. Useful for fast traveling!", action =  function() Routine.run(switchhub) end})
			pauseplus.createOption("teleportmenu",{text = "Teleport to the Shop",closeMenu = true,description = "Teleports to inside of the 6th building located in Me and Larry City. Useful for fast traveling!", action =  function() Routine.run(shophub) end})
			pauseplus.createOption("teleportmenu",{text = "Teleport Back to the Start",closeMenu = true,description = "Teleports back to the starting point of the Hub. Useful for fast traveling!", action =  function() Routine.run(shophub) end})
		end
	end
	if (Level.filename() == "map.lvlx") == true then
		pauseplus.createOption("teleportmenu",{text = "Teleport back to the Start",closeMenu = true,description = "Teleports back to the starting point of the map. Useful for fast traveling!", action =  function() Routine.run(startteleport) end})
		pauseplus.createOption("teleportmenu",{text = "Teleport to the Hub",closeMenu = true,description = "Teleports back to the Hub marker on the map. Useful for fast traveling!", action = function() Routine.run(hubmapteleport) end})
		--pauseplus.createOption("teleportmenu",{text = "Teleport to the Side Quest",closeMenu = true,description = "Teleports back to the Side Quest starting point of the map. Useful for fast traveling!", action = function() Routine.run(sideteleport) end})
		pauseplus.createOption("teleportmenu",{text = "Teleport to the DLC World",closeMenu = true,description = "Teleports back to the DLC World starting point of the map. Useful for fast traveling!", action = function() Routine.run(dlcteleport) end})
	end
	if not isOverworld and (Level.filename() == "MALC - HUB.lvlx") == false and (Level.filename() == "map.lvlx") == false then
		pauseplus.createOption("teleportmenu",{text = "Teleport to the Hub",description = "Teleport to the Me and Larry City Hub. Useful for fast traveling!",closeMenu = true, actions = {function() Routine.run(hubteleportlevel) end}})
	end
end

return pausemenu2