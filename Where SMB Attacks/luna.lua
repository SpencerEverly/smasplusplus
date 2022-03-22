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
local hudoverride = require("hudoverride")
local customCamera = require("customCamera")
local smallScreen = require("smallscreen")
local extrasounds = require("extrasounds")

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
	if Player(2) and Player(2).isValid then
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
	if player.count() == 1 then
		--Nothing
	end
	if Player(2) and Player(2).isValid then
		if Player(2).keys.altRun == KEYS_PRESSED then
			if not Misc.isPaused() then
				Player(2):teleport(player.x - 32, player.y - 32, bottomCenterAligned)
				SFX.play("player-tp-2player.ogg")
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
	if SaveData.resolution == "fullscreen" then
		littleDialogue.defaultStyleName = "smbx13"
		customCamera.defaultScreenHeight = 600
		customCamera.defaultZoom = 1
		smallScreen.scaleY = 1
		
		hudoverride.offsets.keys = 		{x = 64, 	y = 26, align = hudoverride.ALIGN_LEFT};
		hudoverride.offsets.itembox = 	{x = 0, 	y = 16, item = {x = 28, y = 28, align = hudoverride.ALIGN_MID}, align = hudoverride.ALIGN_MID};
		hudoverride.offsets.hearts = 	{x = 5, 	y = 16, align = hudoverride.ALIGN_MID};
		hudoverride.offsets.score = 	{x = 170, 	y = 47, align = hudoverride.ALIGN_RIGHT};

		hudoverride.offsets.bombs = 	{x = 0, 	y = 52, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = hudoverride.ALIGN_LEFT}, align = hudoverride.ALIGN_MID};
		hudoverride.offsets.coins = 	{x = 88, 	y = 26, cross = {x = 24, y = 1}, value = {x = 82, y = 1, align = hudoverride.ALIGN_RIGHT}, align = hudoverride.ALIGN_LEFT};
		hudoverride.offsets.lives = 	{x = -166, 	y = 26, cross = {x = 40, y = 1}, value = {x = 62, y = 1, align = hudoverride.ALIGN_LEFT}, align = hudoverride.ALIGN_LEFT};
		hudoverride.offsets.stars = 	{x = -150, 	y = 46, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = hudoverride.ALIGN_LEFT}, align = hudoverride.ALIGN_LEFT};
		hudoverride.offsets.starcoins = {x = -384, y = 27, cross = {x = 24, y = 0},	value = {x = 45, y = 0, align = hudoverride.ALIGN_LEFT}, grid = {x = 0, y = 40, width = 5, height = 3, offset = 0, table = {}, align = hudoverride.ALIGN_LEFT},	align = hudoverride.ALIGN_LEFT}
		hudoverride.offsets.timer = {x = 264, y = 25, cross = {x = 24, y = 2},	value = {x = 106, y = 2, align = hudoverride.ALIGN_RIGHT}, align = hudoverride.ALIGN_LEFT}
	end
	if SaveData.resolution == "widescreen" then
		littleDialogue.defaultStyleName = "smbx13wide"
		customCamera.defaultScreenHeight = 450
		customCamera.defaultZoom = 0.75
		if SaveData.letterbox == false then
			smallScreen.scaleY = 1.33
		elseif SaveData.letterbox == true then
			smallScreen.scaleY = 1
		end

		hudoverride.offsets = {}
		hudoverride.offsets.keys = 		{x = 64, 	y = 86, align = hudoverride.ALIGN_LEFT};
		hudoverride.offsets.itembox = 	{x = 0, 	y = 86, item = {x = 28, y = 28, align = hudoverride.ALIGN_MID}, align = hudoverride.ALIGN_MID};
		hudoverride.offsets.hearts = 	{x = 5, 	y = 86, align = hudoverride.ALIGN_MID};
		hudoverride.offsets.score = 	{x = 170, 	y = 117, align = hudoverride.ALIGN_RIGHT};

		hudoverride.offsets.bombs = 	{x = 0, 	y = 122, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = hudoverride.ALIGN_LEFT}, align = hudoverride.ALIGN_MID};
		hudoverride.offsets.coins = 	{x = 88, 	y = 96, cross = {x = 24, y = 1}, value = {x = 82, y = 1, align = hudoverride.ALIGN_RIGHT}, align = hudoverride.ALIGN_LEFT};
		hudoverride.offsets.lives = 	{x = -166, 	y = 96, cross = {x = 40, y = 1}, value = {x = 62, y = 1, align = hudoverride.ALIGN_LEFT}, align = hudoverride.ALIGN_LEFT};
		hudoverride.offsets.stars = 	{x = -150, 	y = 116, cross = {x = 24, y = 1}, value = {x = 45, y = 1, align = hudoverride.ALIGN_LEFT}, align = hudoverride.ALIGN_LEFT};
		hudoverride.offsets.starcoins = {x = -384, y = 97, cross = {x = 24, y = 0},	value = {x = 45, y = 0, align = hudoverride.ALIGN_LEFT}, grid = {x = 0, y = 40, width = 5, height = 3, offset = 0, table = {}, align = hudoverride.ALIGN_LEFT},	align = hudoverride.ALIGN_LEFT}
		hudoverride.offsets.timer = {x = 264, y = 95, cross = {x = 24, y = 2},	value = {x = 106, y = 2, align = hudoverride.ALIGN_RIGHT}, align = hudoverride.ALIGN_LEFT}
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