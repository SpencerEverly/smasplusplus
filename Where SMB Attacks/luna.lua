local function anyValidFields() --This is to prevent any player2 errors while switching between 1/2 player modes. If it's still not working then paste what's below into data/scripts/base/darkness.lua at line 854 and save. Hopefully this'll be fixed in the next patch, along with the teleporting issue
	sectionlist[1] = player.section
	if player2 and player2.isValid then
		sectionlist[2] = player2.section
	else
		sectionlist[2] = nil
	end
end

function Player:teleport(x, y, bottomCenterAligned) --Fixing 2nd player teleporting
	-- If using bottom center aligned coordinates, handle that sensibly
	if bottomCenterAligned then
		x = x - (player.width * 0.5)
		y = y - player.height
	end

	-- Move the player and update section, including music
	local oldSection = self.section
	local newSection = Section.getIdxFromCoords(x, y)
	self.x, self.y = x, y
	if (newSection ~= oldSection) then
		self.section = newSection
		playMusic(newSection)
	end
end

local littleDialogue = require("littleDialogue")
local hudoverride = require("hudoverridee")
local customCamera = require("customCamera")
local extrasounds = require("extrasounds")
local modernReserveItems = require("modernReserveItems")
local pausemenu = require("pausemenu")
local smallScreen = require("smallScreen")

local wideborder = Graphics.loadImageResolved("graphics/resolutionborders/widescreen.png")
local ultrawideborder = Graphics.loadImageResolved("graphics/resolutionborders/ultrawide.png")
local nesborder = Graphics.loadImageResolved("graphics/resolutionborders/nes.png")
local gbborder = Graphics.loadImageResolved("graphics/resolutionborders/gb.png")
local gbaborder = Graphics.loadImageResolved("graphics/resolutionborders/gba.png")
local iphoneoneborder = Graphics.loadImageResolved("graphics/resolutionborders/iphone1st.png")
local threedsborder = Graphics.loadImageResolved("graphics/resolutionborders/3ds.png")

if SMBX_VERSION == VER_SEE_MOD then
	__customPauseMenuActive = true
end

littleDialogue.defaultStyleName = "smbx13"

customCamera.transitionSpeed = 5

local cooldown = 0
local killed = false

function p1teleportdoor()
	Routine.waitFrames(30)
	player:mem(0x140,FIELD_WORD,100)
	player2:mem(0x140,FIELD_WORD,100)
	Player(2):teleport(Player(1).x - 32, Player(1).y - 32, bottomCenterAligned)
end

function p2teleportdoor()
	Routine.waitFrames(30)
	player:mem(0x140,FIELD_WORD,100)
	player2:mem(0x140,FIELD_WORD,100)
	Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
end

function onStart()
	Audio.MusicVolume(64)
	if SaveData.resolution == nil then
		SaveData.resolution = "fullscreen"
	end
	if SaveData.letterbox == nil then
		SaveData.letterbox = true
	end
	if SaveData.resolution == "fullscreen" then
		littleDialogue.defaultStyleName = "smbx13"
	end
	if SaveData.resolution == "widescreen" then
		littleDialogue.defaultStyleName = "smbx13wide"
	end
end

function onCameraUpdate(c, camIdx)
	if player.count(2) then
		if c == 1 then
			camera.renderX, camera.rendery = 0, 0
			camera.width, camera.height = 800, 600
		else
			camera2.renderX  = 800
		end
		local screenType = mem(0x00B25130,FIELD_WORD)

		if camera2.isSplit or screenType == 6 then -- split screen or supermario2 is active
			return camIdx
		elseif screenType == 5 then -- dynamic screen
			if Player(1):mem(0x13C,FIELD_BOOL) then -- player 1 is dead
				return 2
			elseif Player(2):mem(0x13C,FIELD_BOOL) then -- player 2 is dead
				return 1
			else
				return 0
			end
		elseif screenType == 2 or screenType == 3 or screenType == 7 then -- follows all players
			return 0
		else
			return 1
		end
	end
end

function onInputUpdate()
	if Player(2) and Player(2).isValid then
		if Player(1).keys.altRun == KEYS_PRESSED and Player(1).keys.up == KEYS_PRESSED then
			if pausemenu.paused == false then
				Player(1):teleport(Player(2).x + 32, Player(2).y - 32, bottomCenterAligned)
				SFX.play("_OST/_Sound Effects/player-tp-2player.ogg")
				cooldown = 5
				Player(1):mem(0x172,FIELD_BOOL,false)
			end
			if cooldown <= 0 then
				Player(1):mem(0x172,FIELD_BOOL,true)
			end
		end
		if Player(2).keys.altRun == KEYS_PRESSED and Player(2).keys.up == KEYS_PRESSED then
			if pausemenu.paused == false then
				Player(2):teleport(Player(1).x - 32, Player(1).y - 32, bottomCenterAligned)
				SFX.play("_OST/_Sound Effects/player-tp-2player.ogg")
				cooldown = 5
				Player(2):mem(0x172,FIELD_BOOL,false)
			end
			if cooldown <= 0 then
				Player(2):mem(0x172,FIELD_BOOL,true)
			end
		end
	end
end

function onTick()
	littleDialogue.defaultStyleName = "smbx13"
	if Player(2) and Player(2).isValid then
		if Player(1).forcedState == FORCEDSTATE_PIPE then
			if Player(1).forcedTimer >= 70 and not Misc.isPaused() then
				player:mem(0x140,FIELD_WORD,100)
				player2:mem(0x140,FIELD_WORD,100)
				Player(2):teleport(player.x - 32, player.y - 32, bottomCenterAligned)
			end
		end
		if Player(2).forcedState == FORCEDSTATE_PIPE then
			if Player(2).forcedTimer >= 70 and not Misc.isPaused() then
				player:mem(0x140,FIELD_WORD,100)
				player2:mem(0x140,FIELD_WORD,100)
				Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
			end
		end
	end
	if Player(2) and Player(2).isValid then
		if Player(1).forcedState == FORCEDSTATE_DOOR then
			if Player(1).forcedTimer == 1 then
				Routine.run(p1teleportdoor)
			end
		end
		if Player(2).forcedState == FORCEDSTATE_DOOR then
			if Player(2).forcedTimer == 1 then
				Routine.run(p2teleportdoor)
			end
		end
	end
	if playerlives == 0 then
        if(not killed and player:mem(0x13E,FIELD_BOOL)) then
            killed = true
            mem(0x00B2C5AC,FIELD_FLOAT, 1)
        end
	end
end

function onDraw()
	if SaveData.resolution == "fullscreen" then
		customCamera.defaultScreenWidth = 800
		customCamera.defaultScreenHeight = 600
		customCamera.defaultZoom = 1
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		smallScreen.priority = 4
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
	end
	if SaveData.resolution == "widescreen" then
		customCamera.defaultScreenWidth = 800
		customCamera.defaultScreenHeight = 450
		customCamera.defaultZoom = 0.75
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1.33
			smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			if SaveData.letterbox == true then
				Graphics.drawImageWP(wideborder, 0, 0, 5)
			end
		end
	end
	if SaveData.resolution == "ultrawide" then
		customCamera.defaultScreenWidth = 800
		customCamera.defaultScreenHeight = 337
		customCamera.defaultZoom = 0.562
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.scaleX = 1
		smallScreen.scaleY = 1
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1.80
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			if SaveData.letterbox == true then
				Graphics.drawImageWP(ultrawideborder, 0, 0, 5)
			end
		end
	end
	if SaveData.resolution == "nes" then
		customCamera.defaultScreenWidth = 512
		customCamera.defaultScreenHeight = 448
		customCamera.defaultZoom = 0.75
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0.20
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1.56
			smallScreen.scaleY = 1.34
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1.25
			smallScreen.scaleY = 1.08
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(nesborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "gameboy" then
		customCamera.defaultScreenWidth = 320
		customCamera.defaultScreenHeight = 228
		customCamera.defaultZoom = 0.38
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.scaleX = 1
		smallScreen.scaleY = 1
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 2.5
			smallScreen.scaleY = 2.65
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(gbborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "gba" then
		customCamera.defaultScreenWidth = 480
		customCamera.defaultScreenHeight = 320
		customCamera.defaultZoom = 0.54
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1.7
			smallScreen.scaleY = 1.9
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(gbaborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "iphone1st" then
		customCamera.defaultScreenWidth = 400
		customCamera.defaultScreenHeight = 600
		customCamera.defaultZoom = 0.62
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.scaleX = 1
		smallScreen.scaleY = 1
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 3.3
			smallScreen.scaleY = 1.65
			smallScreen.offsetX = 5
			smallScreen.offsetY = -8
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(iphoneoneborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "3ds" then
		customCamera.defaultScreenWidth = 700
		customCamera.defaultScreenHeight = 419
		customCamera.defaultZoom = 0.58
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 70
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.scaleX = 1
		smallScreen.scaleY = 1
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1.50
			smallScreen.scaleY = 1.72
			smallScreen.offsetX = 4
			smallScreen.offsetY = -118
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(threedsborder, 0, 0, 5)
		end
	end
end

function onExit()
	if playerlives == 0 then
		if killed == true then
			Level.load("Game Over.lvlx", nil, nil)
		end
	end
	if mem(0x00B2C89C, FIELD_BOOL) then --Let's prevent the credits from execution.
		Level.exit()
	end
end