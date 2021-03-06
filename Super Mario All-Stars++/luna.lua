--SUPER MARIO ALL-STARS++
--By Spencer Everly
--Here's the starting code that loads it all. How'd I do?

--Total Stars:
--SMB1 = 43 (Done!)
--SMB2 = 22 (Done! Still need code for several things though)
--SMB3 = TBD (WIP)
--SMBLL (Optional) = 52 (Done!)
--SMW = TBD (WIP)
--SMBS = TBD (WIP)
--WSMBA = 24 (Done!)
--Lava Lands = 5 (WIP)
--Side Quest (Optional) = TBD (WIP)
--True Ending = 1 (WIP)

--Make sure we aren't running Beta 3 and below before we actually start...
if (VER_BETA4_PATCH_3 == nil) or (SMBX_VERSION < VER_BETA4_PATCH_3) then
	Misc.dialog("Hey wait a minute! At least SMBX2 Beta 4 Patch 3 is required to play this game. Please download it from the official site by going to https://codehaus.wohlsoft.ru/. Until then, you can't run this episode. Sorry about that!")
	Misc.exitEngine()
end

--Make sure to save the current episode folder and save slot numbers to it's own GameData variables to prevent the broken 1.3 launcher from launching the episode...
GameData.__EpisodeFolder = Misc.episodePath()
GameData.__SaveSlot = Misc.saveSlot()

--Make sure we warn the user to upgrade the legacy save data while we can...
if not Misc.inMarioChallenge() then
	if mem(0x00B251E0, FIELD_WORD) >= 1 then
		if GameData.warnUserAboutOldStars == nil then
			GameData.warnUserAboutOldStars = true
		end
		if GameData.warnUserAboutOldStars == true then
			Misc.dialog("It looks like your using a legacy save file from before Demo 3 (Or before April 10th, 2022). You'll need to migrate your save data as soon as you boot the game! That way your data can still be used in the future. Please migrate your save while you can!")
			GameData.warnUserAboutOldStars = false
		end
	end
end

--For SEE Mod users, where they have a definite version of LunaLua.
if SMBX_VERSION == VER_SEE_MOD then
	Misc.setWindowTitle("Super Mario All-Stars++")
	Misc.setWindowIcon(Graphics.loadImageResolved("graphics/icon/icon.png"))
end

--Now, before we get started, we require the most important libraries on the top.
GameData.levelMusicTemporary = {}
GameData.levelMusic = {}
GameData.warpStarDoorCount = {}
_G.smwMap = require("smwMap")
_G.extrasounds = require("extrasounds")
_G.classicEvents = require("classiceventsmod")
_G.EventManager = require("main_events_mod")
_G.extraNPCProperties = require("extraNPCProperties")

--SMAS specific functions need to be required as well:
_G.smasfunctions = require("smasfunctions")
_G.smasverbosemode = require("smasverbosemode")
_G.smasbooleans = require("smasbooleans")
_G.smastables = require("smastables")
_G.smascheats = require("smascheats")
_G.smashud = require("smashud")

--Making sure we're in the Mario Challenge... if so, reload the level if its in the noLevel table.
local rng = require("base/rng") --Load up rng for etc. things
if Misc.inMarioChallenge() then
	SaveData.disableX2char = false
end

--This will add multiple player arguments for a future feature (Online). Coming in the near end of development, is when it's planned.
for _,p in ipairs(Player.get()) do
    _G["player".. p.idx] = p
end

--Then we fix up some functions that the X2 team didn't fix yet (If they released a patch and fixed a certain thing, the code will be removed from here).
function Player:teleport(x, y, bottomCenterAligned) --This fixes 2nd player teleporting, when using player/player2:teleport. This will be removed after a few months when the next SMBX2 patch releases (The next patch will fix this), to make sure people upgrade on time.
	-- If using bottom center aligned coordinates, handle that sensibly
	if bottomCenterAligned then
		x = x - (self.width * 0.5)
		y = y - self.height
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

function classicEvents.doEvents() --To prevent the plObject a nil value error, this needs to be redone here
    local players = Player.get()
    for plIndex, plData in ipairs(playerData) do
        local plObject = players[plIndex]
		if plObject == nil then --Let's prevent the plObject a nil value error
			--Player(2).isValid = false
		end
        for _,keymapEnumValue in ipairs(playerKeymapKeys) do
            local keymapPropertyName = playerKeymapProperties[keymapEnumValue]
            checkKeyboardEvent(plObject, plIndex, plData, keymapPropertyName, keymapEnumValue)
        end
        
        if(plObject:mem(0x60, FIELD_WORD) == -1 and plData.playerJumping == false)then
            EventManager.callEventInternal("onJump", {plIndex})
        elseif(plObject:mem(0x60, FIELD_WORD) == 0 and plData.playerJumping == true)then
            EventManager.callEventInternal("onJumpEnd", {plIndex})
        end
        
        local section = plObject.section
        if(section ~= plData.currentSection)then
            local evLoadSecitionName = "onLoadSection"
            EventManager.callEventInternal(evLoadSecitionName, {plIndex})
            EventManager.callEventInternal(evLoadSecitionName .. section, {plIndex})
        end
        EventManager.callEventInternal("onLoopSection" .. section, {plIndex})
        
        -- Copy new data here to plData
        for _,keymapEnumValue in ipairs(playerKeymapKeys) do
            local keymapPropertyName = playerKeymapProperties[keymapEnumValue]
            plData[keymapPropertyName] = plObject[keymapPropertyName]
        end
        
        plData.playerJumping = plObject:mem(0x60, FIELD_WORD) == -1
        
        plData.currentSection = section
    end
end

--Now that everything has been loaded, start loading the medium important stuff
local globalgenerals = require("globalgenerals") --Most important library of all. This loads general stuff for levels.
local repll = require("repll") --Custom sound command line, for not only testing in the editor, but for an additional clear history command
local playerManager = require("playermanager") --Load up this to change Ultimate Rinka and Ninja Bomberman to Steve and Yoshi (You can still use UR and NB, check out the Toad costumes)
if SaveData.speedrunMode == true then
	speedruntimer = require("speedruntimer") -- Speedrun Timer Script on World Map (from MaGLX3 episode)
	inputoverlay = require("inputoverlay") -- Input Overlay (GFX by Wohlstand for TheXTech, script by me)
end

local loadactivate = true
local steve = require("steve")
playerManager.overrideCharacterLib(CHARACTER_ULTIMATERINKA,require("steve"))
local yoshi = require("yiYoshi/yiYoshi")
--These will need to be overwritten over the original libraries, because we're fixing graphics/bugs from these characters.
playerManager.overrideCharacterLib(CHARACTER_MEGAMAN,require("megamann"))
playerManager.overrideCharacterLib(CHARACTER_SNAKE,require("snakey"))
playerManager.overrideCharacterLib(CHARACTER_BOWSER,require("bowserr"))
playerManager.overrideCharacterLib(CHARACTER_ROSALINA,require("rosalinaa"))
playerManager.overrideCharacterLib(CHARACTER_SAMUS,require("samuss"))
playerManager.overrideCharacterLib(CHARACTER_WARIO,require("warioo"))
playerManager.overrideCharacterLib(CHARACTER_ZELDA,require("zeldaa"))
playerManager.overrideCharacterLib(CHARACTER_KLONOA,require("klonoaa"))
playerManager.overrideCharacterLib(CHARACTER_UNCLEBROADSWORD,require("unclebroadswordd"))
Graphics.sprites.effect[152].img = Graphics.loadImageResolved("graphics/smbx2og/effect/effect-152.png")
Graphics.sprites.effect[153].img = Graphics.loadImageResolved("graphics/smbx2og/effect/effect-153.png")
Graphics.sprites.ultimaterinka[player.powerup].img = Graphics.loadImageResolved("graphics/smbx2og/character/ultimaterinka-2.png")

--First time SaveData setting, for resolutions and other settings
if SaveData.resolution == nil then --By default, the resolution will be set as fullscreen.
	SaveData.resolution = "fullscreen"
end
if SaveData.letterbox == nil then --Letterbox default is true
	SaveData.letterbox = true
end
if SaveData.borderEnabled == nil then --Border default is true
	SaveData.borderEnabled = true
end
if SaveData.clockTheme == nil then
	SaveData.clockTheme = "normal"
end
if SaveData.totalStarCount == nil then --This will make a new star count system that won't corrupt save files
	SaveData.totalStarCount = 0
end
if SaveData.completeLevels == nil then --This will add a table to list completed levels when collecting win states
	SaveData.completeLevels = {}
end
if SaveData.completeLevelsOptional == nil then --This will add a table to list completed levels when collecting win states in optional levels
	SaveData.completeLevelsOptional = {}
end
if SaveData.totalcoins == nil then --The total coin count, used outside of the classic coin count which counts all coins overall
	SaveData.totalcoins = 0
end
if SaveData.deathCount == nil then --Death count! For outside 1.3 mode, and inside it
	SaveData.deathCount = 0
end
if SaveData.totalLives == nil then --The total lives used the for the episode.
	SaveData.totalLives = 5
end
if SaveData.totalCoinsClassic == nil then --This will display a classic coin count for the episode
	SaveData.totalCoinsClassic = 0
end
if SaveData.totalScoreClassic == nil then --This will add a score counter which goes up to a billion, cause why not
	SaveData.totalScoreClassic = 0
end
if SaveData.deathquickoption == true or SaveData.deathquickoption == false then --deathquickoption is unstable, so don't enable it if used before April
	SaveData.deathquickoption = nil
end
if SaveData.disableX2char == nil then --This will make sure 1.3 Mode isn't enabled on first boot, which will also prevent errors
	SaveData.disableX2char = false
end
if SaveData.dateplayedmonth == nil then
	SaveData.dateplayedmonth = os.date("%m")
end
if SaveData.dateplayedday == nil then
	SaveData.dateplayedday = os.date("%d")
end
if SaveData.dateplayedyear == nil then
	SaveData.dateplayedyear = os.date("%Y")
end
if SaveData.firstBootMapPathFixed == nil then
    SaveData.firstBootMapPathFixed = false
end

Progress.value = SaveData.totalStarCount --Every level load, we will save the total stars used with the launcher
if SaveData.playerName == nil then
	Progress.savename = "Player" --If the player name is nil, use "Player" instead
else
	Progress.savename = SaveData.playerName --Or else just use the SaveData variable if it exists
end

--Get some day/month/year stuff for the weather changing...
SaveData.dateplayedday = os.date("%d")
SaveData.dateplayedmonth = os.date("%m")
SaveData.dateplayedyear = os.date("%Y")

--Make sure the warp door system doesn't get active until onStart saves the original count first...
local warpstaractive = false

--Camera stuff to prevent player2 from doing split screen...
--Gets the index of the player that the camera belongs to. A return value of 0 means that it belongs to everybody
function onCameraUpdate(c, camIdx)
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

--Now load the loading sound file!
local loadingsoundFile = Misc.resolveSoundFile("loadscreen.ogg")

--Placing in levels onto a table that'll prevent the loading sound from playing
smastables._noLoadingSoundLevels = {
	"SMAS - Start.lvlx",
	"SMAS - Raca's World (Part 0).lvlx",
	"SMAS - Raca's World (Part 1).lvlx",
	"map.lvlx"
}

--Now use onLoad to play the loading sound...
function onLoad()
	if not Misc.inEditor() and not table.icontains(smastables._noLoadingSoundLevels,Level.filename()) and loadactivate == true then --If luna errors during testing in the editor, this will be useful to not load the audio to prevent the audio from still being played until the engine is terminated
		loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
		loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
		fadetolevel = true
	end
end

function onLoop() --I'm sorry for using deprecated crap, this is used specifically for stopping the loading sound when erroring
	if unexpected_condition then loadingSoundObject:Stop() end
end

function warpDoorBegin()
	local warps = Warp.get()
	for _, warp in ipairs(warps) do
		GameData.warpStarDoorCount = warp.starsRequired
	end
	Routine.wait(0.1, true)
	warpstaractive = true
end

function onStart() --Now do onStart...
	--From earlier, if the GameData info is mismatched, run a dialog and afterward exit the engine
	if GameData.__EpisodeFolder ~= Misc.episodePath() and GameData.__SaveSlot ~= Misc.saveSlot() then
		Misc.dialog("Uh oh... it looks like you launched the episode using the broken SMBX 1.3 Launcher. Please use the SMBX2 launcher to launch the episode. Until then, you can't run this episode. Sorry about that!")
		Misc.exitEngine()
	end
	Routine.run(warpDoorBegin) --This will run the routine to save the original count and to start the system from there
	if Misc.inMarioChallenge() then
		SaveData.totalCoinsClassic = tonumber(mem(0x00B2C5A8, FIELD_WORD))
		SaveData.totalScoreClassic = tonumber(Misc.score())
		SaveData.totalLives = tonumber(mem(0x00B2C5AC, FIELD_FLOAT))
		SaveData.totalStarCount = tonumber(mem(0x00B251E0, FIELD_WORD))
	end
	--Do the weather SaveData additions
	if SaveData.dateplayedweather == nil then
		SaveData.dateplayedweather = weatherControl
	end
	--Calculate Easter Sunday
	osEaster(os.date("*t").year)
	if SaveData.dateplayedyesterday == nil then
		yesterdaynumber = os.date("*t").day - 1
		SaveData.dateplayedyesterday = yesterdaynumber
	end
	if SaveData.dateplayedtomorrow == nil then
		tomorrownumber = os.date("*t").day + 1
		SaveData.dateplayedtomorrow = tomorrownumber
	end
	if GameData.weatherset == true then --This'll be better in the future. For now, it just loads the weather when restarting the game to the start preboot screen, or starting it up every time
		possibleWeather = {"sunny","rain","snow"}
		weatherControl = rng.randomEntry(possibleWeather)
		SaveData.dateplayedweather = weatherControl --Write in a better onetime day function for this
		GameData.weatherset = false
	end
	if not Misc.inEditor() and not table.icontains(smastables._noLoadingSoundLevels,Level.filename()) then --Make sure to fade out the loading sound when onStart is active...
		fadetolevel = false
		if loadactivate == true then
			loadingSoundObject:FadeOut(800)
			loadactivate = false
		end
	end
	tomorrowget()
	yesterdayget()
	if SaveData.disableX2char == 0 then --Migrate old saves from pre-March 2022 if there are any.
		SaveData.disableX2char = false
	end
	if SaveData.disableX2char == 1 then
		SaveData.disableX2char = true
	end
	if SaveData.firstBootCompleted == 0 then
		SaveData.firstBootCompleted = false
	end
	if SaveData.firstBootCompleted == 1 then
		SaveData.firstBootCompleted = true
	end
	Audio.MusicVolume(nil) --Reset the music volume on onStart, just in case
end

function tomorrowget()
	tomorrownumber = os.date("*t").day + 1
	SaveData.dateplayedtomorrow = tomorrownumber
end

function yesterdayget()
	yesterdaynumber = os.date("*t").day - 1
	SaveData.dateplayedyesterday = yesterdaynumber
end

local stardoor = Graphics.loadImageResolved("starlock.png")
local cameratimer = 10
local cameratimer2 = 10
GameData.__startGif = false
GameData.__endGif = true
GameData.__gifIsRecording = false

local inputhudbg = Graphics.loadImage(Misc.resolveFile("inputhud/inputhud.png"))
local controlkey = Graphics.loadImage(Misc.resolveFile("inputhud/control.png"))
local jumpkey = Graphics.loadImage(Misc.resolveFile("inputhud/jump.png"))
local altjumpkey = Graphics.loadImage(Misc.resolveFile("inputhud/altjump.png"))
local runkey = Graphics.loadImage(Misc.resolveFile("inputhud/run.png"))
local altrunkey = Graphics.loadImage(Misc.resolveFile("inputhud/altrun.png"))
local bottomkeys = Graphics.loadImage(Misc.resolveFile("inputhud/bottomkey.png"))

function onDraw()
	local warps = Warp.get()
	for _, v in ipairs(warps) do
		if v.isValid and (not v.isHidden) and v.starsRequired > SaveData.totalStarCount then
			Graphics.drawImageToSceneWP(stardoor, v.entranceX + 0.5 * v.entranceWidth - 12, v.entranceY - 20, -40) --This will draw the star door locks, since the original image is invisible
        end
    end
	if noItemSound then
		Audio.sounds[12].muted = true
		cameratimer = cameratimer - 1
		GameData.__startGif = false
		GameData.__endGif = true
		if cameratimer <= 0 then
			cameratimer = 10
			Audio.sounds[12].muted = false
			noItemSound = false
		end
	end
	if noSoundGif then
		Audio.sounds[12].muted = true
		Audio.sounds[24].muted = true
		cameratimer = cameratimer - 1
		GameData.__startGif = false
		GameData.__endGif = true
		GameData.__gifIsRecording = true
		if cameratimer <= 0 then
			cameratimer = 10
			Audio.sounds[12].muted = false
			Audio.sounds[24].muted = false
			noItemSoundGif = false
		end
	end
	if GameData.__gifIsRecording then
		
	end
	if SaveData.speedrunMode == true then
		Graphics.drawImageWP(inputhudbg,4,566,-1.9) -- Released Keys
		if player.keys.left == KEYS_DOWN then -- Pressed Left Key
			Graphics.drawImageWP(controlkey,8,578,-1) 
		end
		if player.keys.right == KEYS_DOWN then -- Pressed Right Key
			Graphics.drawImageWP(controlkey,20,578,-1)
		end
		if player.keys.up == KEYS_DOWN then -- Pressed Up Key
			Graphics.drawImageWP(controlkey,14,572,-1)
		end
		if player.keys.down == KEYS_DOWN then -- Pressed Down Key
			Graphics.drawImageWP(controlkey,14,584,-1)
		end
		if player.keys.jump == KEYS_DOWN then -- Pressed Jump Key
			Graphics.drawImageWP(jumpkey,68,584,-1)
		end
		if player.keys.run == KEYS_DOWN then -- Pressed Run Key
			Graphics.drawImageWP(runkey,58,582,-1)
		end
		if player.keys.altJump == KEYS_DOWN then -- Pressed Alt Jump Key
			Graphics.drawImageWP(altjumpkey,70,574,-1)
		end
		if player.keys.altRun == KEYS_DOWN then -- Pressed Alt Run Key
			Graphics.drawImageWP(altrunkey,60,572,-1)
		end
		if player.keys.dropItem == KEYS_DOWN then -- Pressed Drop Item Key
			Graphics.drawImageWP(bottomkeys,30,588,-1)
		end
		if player.keys.pause == KEYS_DOWN then -- Pressed Pause Key
			Graphics.drawImageWP(bottomkeys,44,588,-1)
		end
	end
end

GameData.__startGif = false

function onKeyboardPressDirect(k) --This will replace the GIF recording/snapshot sounds to some custom ones
	if k == VK_F11 then
		Audio.sounds[12].muted = true
		Audio.sounds[24].muted = true
		noSoundGif = true
		if not GameData.__gifIsRecording then
			playSound("gif-start.ogg")
		elseif GameData.__gifIsRecording then
			playSound("gif-end.ogg")
		end
	end
	if k == VK_F12 then
		Audio.sounds[12].muted = true
		noItemSound = true
		playSound("snapshot.ogg")
	end
end

function onTick() --This will prevent split screen, again (Just in case)
	mem(0x00B25130,FIELD_WORD, 2)
	if SaveData.disableX2char == false then --Let's not get game overs/broken launcher kicking during Normal Mode.
		if mem(0x00B2C5AC,FIELD_FLOAT) < 2 then
			mem(0x00B2C5AC,FIELD_FLOAT,3)
		end
	end
	if table.icontains(smastables._friendlyPlaces,Level.filename()) == true then
		GameData.friendlyArea = true --Set this to prevent Mother Brain Rinka from getting killed in places such as the boot screen, intro, or the Hub
	end
	--Now we'll overhaul the door star required system
	if warpstaractive == true then
		local numberOfWarps = Warp.count()
		local warps = Warp.get()
		for _, warp in ipairs(warps) do
			if warp.starsRequired <= SaveData.totalStarCount then
				warp.starsRequired = 0
			elseif warp.starsRequired > SaveData.totalStarCount then
				--warp.starsRequired = 9999 --This has been uncommented because the original star count is 0 regardless, which means don't bump up the required stars
			end
			--if mem(0x00B251E0, FIELD_WORD) >= 1 then
				--mem(0x00B251E0, FIELD_WORD, 0)
			--end
		end
	end
end

function onExit()
	if Misc.inMarioChallenge() then
		local oldpoints = Misc.score()
		if oldpoints > 9999999 then
			oldpoints = 9999999
		end
		mem(0x00B2C5A8, FIELD_WORD, SaveData.totalCoinsClassic)
		Misc.score(oldpoints - SaveData.totalScoreClassic)
        if SaveData.totalLives > 99 then
            mem(0x00B2C5AC, FIELD_FLOAT, 99)
        else
            mem(0x00B2C5AC, FIELD_FLOAT, SaveData.totalLives)
        end
	end
end

--That's the end of this file!