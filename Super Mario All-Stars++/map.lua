local steve = require("steve")
local textplus = require("textplus")
local playerManager = require("playermanager")
local yoshi = require("yiYoshi/yiYoshi")
local lib3d = require("lib3d")
local travL = require("travL")
local wandR = require("wandRr")
local jukebox = require("jukebox-v11")
local pause_music = require("map_music")
local Routine = require("routine")

local loadlevelanimation = false
local levelnames = Level.get()
local timer = 100
local cooldown = 0

local timer1 = 0
local speed = 0
local numberup = 0
local time = 0

local opacity = timer1/speed
local middle = math.floor(timer1*numberup)

local map3d = require("mapp3d")
map3d.CameraSettings.fov = 65
map3d.CameraSettings.height = 350;
map3d.BGPlane.tile = 394
map3d.Light.enabled = false
map3d.Heightmap.texture = Graphics.loadImage("heightmap.png");
map3d.Heightmap.position = vector.v2(6496, 0)

local middle = 0
local transitionTimer = 0

function onLoad()
	if SaveData.disableX2char == 0 then
		inventory = require("customInventory")
		smoothWorld = require("smoothWorld")
		pausemenu = require("pausemenu_map")
	end
	if SaveData.disableX2char == 1 then
		pausemenu13 = require("pausemenu13map")
	end
end

function levelload()
	if player.rawKeys.jump == KEYS_PRESSED then
		player.rawKeys.jump = KEYS_UNPRESSED
	end
	SFX.play("_OST/_Sound Effects/levelload.ogg")
	loadlevelanimation = true
	Audio.MusicVolume(0)
	Misc.pause()
	player:mem(0x17A, FIELD_BOOL, true)
	Routine.waitFrames(78, true)
	Misc.unpause()
	player:mem(0xFA, FIELD_BOOL, true)
	loadlevelanimation = nil
	loadlevelanimationin = true
	Audio.MusicVolume(56)
	Routine.waitFrames(78, true)
	loadlevelanimationin = nil
end

function onInputUpdate()
	if Misc.isPausedByLua() == false then
		if world.levelTitle and world.levelObj then
			if player.rawKeys.jump == KEYS_PRESSED then
				Routine.run(levelload)
				if player.keys.left == KEYS_PRESSED then
					player.keys.left = KEYS_UNPRESSED
				elseif player.keys.right == KEYS_PRESSED then
					player.keys.right = KEYS_UNPRESSED
				end
			end
		end
	end
end

function onStart()
	if Misc.resolveFile("worlds/Super Mario All-Stars++/exeextracted.txt") == nil then
		--Nothing
	end
	if Misc.resolveFile("worlds/Super Mario All-Stars++/exeextracted.txt") == true then
		Misc.showRichDialog("EXE Extraction installination detected!", "Hello!\n\nAre you are trying to play the game on a public computer from a EXE Extraction install?\n\nIf so, things may be unstable with the episode running everything this\nway. Please use the official installination on your own\ncomputer to make the game work as intended.\n\nThank you!", true)
	end
	Audio.MusicVolume(nil)
	mem(0xB25728, FIELD_BOOL, false) -- Sets the episode back to world map type. Without it, the intro will still play everytime you try to exit the level, rendering SMAS++ unusable
end

function onTick()
	Defines.player_hasCheated = false
	
	if SaveData.disableX2char == 0 then
		playerManager.overworldCharacters = {CHARACTER_MARIO, CHARACTER_LUIGI, CHARACTER_PEACH, CHARACTER_TOAD, CHARACTER_LINK, CHARACTER_MEGAMAN, CHARACTER_WARIO, CHARACTER_BOWSER, CHARACTER_YOSHI, CHARACTER_NINJABOMBERMAN, CHARACTER_ROSALINA, CHARACTER_SNAKE, CHARACTER_ZELDA, CHARACTER_ULTIMATERINKA, CHARACTER_UNCLEBROADSWORD, CHARACTER_SAMUS}
	end
	if SaveData.disableX2char == 1 then
		playerManager.overworldCharacters = {CHARACTER_MARIO, CHARACTER_LUIGI, CHARACTER_PEACH, CHARACTER_TOAD, CHARACTER_LINK}
	end
end

function onPause(evt) --Because there's a new pause menu, the og pause menu has to be disabled
	evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onDraw()
	Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=8}
	textplus.print{x=724, y=580, text = "Time - ", priority=8, color=Color.white} --What time is it...!?
	textplus.print{x=755, y=580, text = os.date("%I"), priority=8, color=Color.white}
	textplus.print{x=765, y=580, text = ":", priority=8, color=Color.white}
	textplus.print{x=768, y=580, text = os.date("%M"), priority=8, color=Color.white}
	textplus.print{x=780, y=580, text = os.date("%p"), priority=8, color=Color.white}
	Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=8}
	textplus.print{x=700, y=557, text = "Date - ", priority=8, color=Color.white} --What's the day, sir?!
	textplus.print{x=733, y=557, text = os.date("%a"), priority=8, color=Color.white}
	textplus.print{x=752, y=557, text = os.date("%x"), priority=8, color=Color.white}
	
	local customtileone = Graphics.loadImage("customtile401.png")
	Graphics.drawImageToSceneWP(customtileone, -3328, -1824, 4)
	
	if loadlevelanimation then
		time = time + 1
		Graphics.drawScreen{color = Color.black..math.max(0,time/32),priority = 10}
	end
	if loadlevelanimationin then
		time = time - 1
		Graphics.drawScreen{color = Color.black..math.min(1,time/24),priority = 10}
	end
end

--Some cheats will break playing this game. Demo 2 will start having these cheats that could break any point of the game disabled. Most things, like the framerate, chracter stuff, most other cheats that won't break the game in normal cases, and until the release, imtiredofallthiswalking, will be kept in. To see a list of disabled cheats for levels, check out the luna.lua in the root of the episode.

--travR and wandR break when this code is being used.
Cheats.deregister("illparkwhereiwant") --Allows the player to move anywhere. travR and wandR will let the player move, but the player will keep going regardless of stopping... that's why it's disabled.