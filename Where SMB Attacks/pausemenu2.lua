local pausemenu2 = {}

local ready = false

local pauseplus = require("pauseplus")
local playerManager = require("playerManager")
local rng = require("rng")
local textplus = require("textplus")
if not isOverworld then
	extrasounds = require("extrasounds")
	customCamera = require("customCamera")
end
local sprite = require("base/sprite")
local exitFadeActive = false
local exitFadeActiveDone = false
local exitFadeOut = 0
local cooldown = 0

local pausefont3 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")

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
	if pauseplus.getSelectionValue("settings","Enable Letterbox Scaling") then
		SFX.play("_OST/_Sound Effects/letterbox-disable.ogg")
		SaveData.letterbox = false
	else
		SFX.play("_OST/_Sound Effects/letterbox-enable.ogg")
		SaveData.letterbox = true
	end
end

local function changeresolutionborder()
	if pauseplus.getSelectionValue("settings","Disable Resolution Border") then
		SFX.play("_OST/_Sound Effects/resolutionborder-disable.ogg")
		SaveData.borderEnabled = false
	else
		SFX.play("_OST/_Sound Effects/resolutionborder-enable.ogg")
		SaveData.borderEnabled = true
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

local function enable2player()
	SFX.play(1001)
	Cheats.trigger("2player")
end

local function disable2player()
	SFX.play(1001)
	mem(0x00B2595E, FIELD_WORD, 1)
end

function pausemenu2.onDraw()
	if GameData.musicMuted == true then
		Audio.MusicVolume(0)
	elseif GameData.musicMuted == false or GameData.musicMuted == nil then
		Audio.MusicVolume(pauseplus.getSelectionValue("settings","Music Volume"))
	end
	sfxVolume = pauseplus.getSelectionValue("settings","SFX Volume")
	for i = 1, 91 do
		Audio.sounds[i].sfx.volume = math.floor(sfxVolume * 128 + 0.5)
		if not isOverworld then
			if extrasounds.active == true then
				if Audio.sounds[43].muted then
					Audio.sounds[43].sfx.volume = 0
				end
			end
		end
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
end

local function checkingplayerstatus13()
	if player.count() == 1 then
		SFX.play(1001)
		Cheats.trigger("2player")
		cooldown = 5
		player:mem(0x11E,FIELD_BOOL,false)
		if cooldown <= 0 then
			player:mem(0x11E,FIELD_BOOL,true)
		end
	elseif player.count() == 2 then
		SFX.play(1001)
		mem(0x00B2595E, FIELD_WORD, 1)
		player:mem(0x11E,FIELD_BOOL,false)
		if cooldown <= 0 then
			player:mem(0x11E,FIELD_BOOL,true)
		end
	elseif player.count() >= 3 then
		SFX.play(1001)
		mem(0x00B2595E, FIELD_WORD, 1)
		player:mem(0x11E,FIELD_BOOL,false)
		if cooldown <= 0 then
			player:mem(0x11E,FIELD_BOOL,true)
		end
	end
end

local function exitlevel2()
	pauseplus.canControlMenu = false
	Audio.MusicVolume(0)
	Audio.MusicPause()
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
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
	SFX.play(59)
	SFX.play(31)
	startFadeOut()
	Misc.saveGame()
	Routine.wait(2.1, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Misc.loadEpisode("Super Mario All-Stars++")
end

function quitonly()
	pauseplus.canControlMenu = false
	SFX.play("_OST/_Sound Effects/wrong.ogg")
	SFX.play(31)
	startFadeOut()
	Routine.wait(2.1, true)
	Misc.unpause()
	exitFadeActive = false
	exitFadeActiveDone = true
	Misc.loadEpisode("Super Mario All-Stars++")
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
	exitFadeActiveDone = true
	Level.load(Level.filename())
end

local function startteleport()
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	world.playerX = 832
	world.playerY = -1152
	SFX.play(34)
end

local function hubmapteleport()
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	world.playerX = 320
	world.playerY = -1088
	SFX.play(34)
end

--Main Menu
pauseplus.font = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")
pauseplus.scale = 1.5
if not isOverworld then
	pauseplus.priority = -1
end
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
if not isOverworld then
	pauseplus.createOption("main",{text = "Return to the Map",closeMenu = true,description = "Returns to the map of the game.",action = function() Routine.run(exitlevel2) end})
end
pauseplus.createSubmenu("settings",{headerText = "<size 1.5>Settings/Options</size>"})
pauseplus.createSubmenu("charactermenu",{headerText = "<size 1.5>Character Options</size>"})
pauseplus.createSubmenu("teleportmenu",{headerText = "<size 1.5>Teleportation Options</size>"})
pauseplus.createOption("main",{text = "Character Options",goToSubmenu = "charactermenu",description = "Switch characters on the fly!"})
pauseplus.createOption("main",{text = "Settings/Options",goToSubmenu = "settings",description = "Set some settings to enhance your gameplay."})
if isOverworld then
	pauseplus.createOption("main",{text = "Teleportation Options",goToSubmenu = "teleportmenu",description = "Teleport to many places with this option (Select areas)."})
end
pauseplus.createOption("main",{text = "Save and Continue",description = "Save and continue your game.",pauseplus.save,closeMenu = true,action = function() SFX.play("save_dismiss.ogg") end})
pauseplus.createOption("main",{text = "Save and Quit",description = "Save and exit back to SMAS++. You can continue later at any point. Remember to take breaks!",action = function() Routine.run(saveAndQuitRoutine) end})

-- Settings
pauseplus.createOption("settings",{text = "Switch Resolution",selectionType = pauseplus.SELECTION_NAMES,description = "Switch between resolutions.",selectionNames = {RESOLUTION_FULL,RESOLUTION_WIDE,RESOLUTION_ULTRAWIDE,RESOLUTION_NES,RESOLUTION_GB,RESOLUTION_GBA,RESOLUTION_IPHONEONE,RESOLUTION_THREEDS}, action = function() changeresolution() end})
pauseplus.createOption("settings",{text = "Enable Letterbox Scaling",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Enable scaling to display a full resolution while in fullscreen mode (Use F4 while in fullscreen).", action =  function() changeletterbox() end})
pauseplus.createOption("settings",{text = "Disable Resolution Border",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Disable the border when using other additional resolutions.", action =  function() changeresolutionborder() end})
pauseplus.createOption("settings",{text = "Music Volume",description = "Turn the music volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 60,selectionMin = 0,selectionMax = 100,selectionStep = 5,selectionFormat = "%d%%"})
pauseplus.createOption("settings",{text = "SFX Volume",description = "Turn the sound effect volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 1,selectionMin = 0,selectionMax = 1,selectionStep = 0.1,selectionFormat = "%d%%"})
pauseplus.createOption("settings",{text = "Exit without Saving",description = "Exit without saving back to SMAS++. YOU WILL LOSE PROGRESS IF YOU SELECT THIS OPTION!",action = {function() Routine.run(quitonly) end}})

--Character Menu

pauseplus.createOption("charactermenu",{text = "Change Character 1P (Left)",description = "Switch the 1st Player's character to anything of your choice!",action =  function() characterchange13left() end})
pauseplus.createOption("charactermenu",{text = "Change Character 1P (Right)",description = "Switch the 1st Player's character to anything of your choice!",action =  function() characterchange13() end})
if Player(2) and Player(2).isValid and Player.count() == 2 then
	pauseplus.createOption("charactermenu",{text = "Change Character 2P (Left)",description = "Switch the 2nd Player's character to anything of your choice!",action =  function() characterchange13_2pleft() end})
	pauseplus.createOption("charactermenu",{text = "Change Character 2P (Right)",description = "Switch the 2nd Player's character to anything of your choice!",action =  function() characterchange13_2p() end})
end
if not isOverworld then
	pauseplus.createOption("charactermenu",{text = "Enable/Disable Multiplayer",closeMenu = true,description = "Toggle the status of multiplayer at anytime.",action = function() checkingplayerstatus13() end})
end

--Teleportation Menu
if isOverworld then
	pauseplus.createOption("teleportmenu",{text = "Teleport back to the Start",closeMenu = true,description = "Teleports back to the starting point of the map, so you can set some episode-specific settings. Useful for fast traveling!", action =  function() Routine.run(startteleport) end})
	pauseplus.createOption("teleportmenu",{text = "Teleport to the Hub",closeMenu = true,description = "Teleports back to the Hub marker on the map. Useful for fast traveling!", action = function() Routine.run(hubmapteleport) end})
end

return pausemenu2