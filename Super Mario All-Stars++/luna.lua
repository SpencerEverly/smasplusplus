--SUPER MARIO ALL-STARS++
--By Spencer Everly
--Here's the starting code that loads it all. How'd I do?

--Total Stars:
--SMB1 = 43
--SMB2 = 22
--SMB3 = TBD
--SMBLL = TBD
--SMW = TBD
--SMBS = TBD
--Lava Lands = 5
--True Ending = 1

--Make sure we aren't running Beta 3 and below before we actually start...
if (VER_BETA4_PATCH_3 == nil) or (SMBX_VERSION < VER_BETA4_PATCH_3) then
	Misc.dialog("Hey wait a minute! At least SMBX2 Beta 4 Patch 3 is required to play this game. Please download it from the official site by going to https://codehaus.wohlsoft.ru/. Until then, you can't run this episode. Sorry about that!")
	Misc.exitEngine()
end

--Make sure to save the current episode folder and save slot numbers to it's own GameData variables to prevent the broken 1.3 launcher from launching the episode...
GameData.__EpisodeFolder = GameData.__EpisodeFolder or Misc.episodePath()
GameData.__SaveSlot = GameData.__SaveSlot or Misc.saveSlot()

--If it's mismatched, run a dialog and afterward exit the engine
if GameData.__EpisodeFolder ~= Misc.episodePath() and GameData.__SaveSlot ~= Misc.saveSlot() then
    Misc.dialog("Uh oh... it looks like you launched the episode using the broken SMBX 1.3 Launcher. Please use the SMBX2 launcher to launch the episode. Until then, you can't run this episode. Sorry about that!")
    Misc.exitEngine()
end

--Make sure we warn the user of the dangers of the old star system...
if mem(0x00B251E0, FIELD_WORD) >= 1 then
	if GameData.warnUserAboutOldStars == nil then
		GameData.warnUserAboutOldStars = true
	end
	if GameData.warnUserAboutOldStars == true then
		Misc.dialog("Uh oh... it looks like your save file is using the old star system. Be warned that things related to the old star system may not work with the new system as intended and you should restart your save file due to this. I'm sorry for the inconvenience, and hope to be a better developer next time when it comes to these things.")
		GameData.warnUserAboutOldStars = false
	end
end

--Now, before we get started, we require the most important libraries on the top.
GameData.levelMusicTemporary = {}
GameData.levelMusic = {}
GameData.warpStarDoorCount = {}
local smwMap = require("smwMap")
local classicEvents = require("classiceventsmod")
local EventManager = require("main_events_mod")
local extrasounds = require("extrasounds")

--Next up is some new functions, for simplifying the functions:
local smasfunctions = require("smasfunctions")

--Then we fix up some functions that the X2 team didn't fix yet (If they released a patch and fixed a certain thing, the code will be removed from here).
local function anyValidFields() --This is to prevent any player2 errors while switching between 1/2 player modes. If it's still not working (Hopefully that's not the case) then paste what's below into data/scripts/base/darkness.lua at line 854 and save. Hopefully this'll be fixed in the next patch, along with the teleporting issue
	sectionlist[1] = player.section
	if Player(2) and Player(2).isValid then
		sectionlist[2] = player2.section
	else
		sectionlist[2] = nil
	end
end

function Player:teleport(x, y, bottomCenterAligned) --This fixes 2nd player teleporting, when using player/player2:teleport.
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

--Placing in levels onto a table that'll prevent the loading sound from playing
local noloadingsounds = {
	"SMAS - Start.lvlx",
	"SMAS - Raca's World (Part 0).lvlx",
	"SMAS - Raca's World (Part 1).lvlx",
	"map.lvlx"
}

--All SMB1 levels, for the SMB1 Hard Mode feature
GameData._smb1Levels = {
	"SMB1 - W-1, L-1.lvlx",
	"SMB1 - W-1, L-2.lvlx",
	"SMB1 - W-1, L-3.lvlx",
	"SMB1 - W-1, L-4.lvlx",
	"SMB1 - W-2, L-1.lvlx",
	"SMB1 - W-2, L-2.lvlx",
	"SMB1 - W-2, L-3.lvlx",
	"SMB1 - W-2, L-4.lvlx",
	"SMB1 - W-3, L-1.lvlx",
	"SMB1 - W-3, L-2.lvlx",
	"SMB1 - W-3, L-3.lvlx",
	"SMB1 - W-3, L-4.lvlx",
	"SMB1 - W-4, L-1.lvlx",
	"SMB1 - W-4, L-2.lvlx",
	"SMB1 - W-4, L-3.lvlx",
	"SMB1 - W-4, L-4.lvlx",
	"SMB1 - W-5, L-1.lvlx",
	"SMB1 - W-5, L-2.lvlx",
	"SMB1 - W-5, L-3.lvlx",
	"SMB1 - W-5, L-4.lvlx",
	"SMB1 - W-6, L-1.lvlx",
	"SMB1 - W-6, L-2.lvlx",
	"SMB1 - W-6, L-3.lvlx",
	"SMB1 - W-6, L-4.lvlx",
	"SMB1 - W-7, L-1.lvlx",
	"SMB1 - W-7, L-2.lvlx",
	"SMB1 - W-7, L-3.lvlx",
	"SMB1 - W-7, L-4.lvlx",
	"SMB1 - W-8, L-1.lvlx",
	"SMB1 - W-8, L-2.lvlx",
	"SMB1 - W-8, L-3.lvlx",
	"SMB1 - W-8, L-4.lvlx",
	"SMB1 - W-9, L-1.lvlx",
	"SMB1 - W-9, L-2.lvlx",
	"SMB1 - W-9, L-3.lvlx",
	"SMB1 - W-9, L-4.lvlx"
}

--All SMB2 levels, for the ace coin system
GameData._smb2Levels = {
	"SMB2 - W-1, L-1.lvlx",
	"SMB2 - W-1, L-2.lvlx",
	"SMB2 - W-1, L-3.lvlx",
	"SMB2 - W-2, L-1.lvlx",
	"SMB2 - W-2, L-2.lvlx",
	"SMB2 - W-2, L-3.lvlx",
	"SMB2 - W-3, L-1.lvlx",
	"SMB2 - W-3, L-2.lvlx",
	"SMB2 - W-3, L-3.lvlx",
	"SMB2 - W-4, L-1.lvlx",
	"SMB2 - W-4, L-2.lvlx",
	"SMB2 - W-4, L-3.lvlx",
	"SMB2 - W-5, L-1.lvlx",
	"SMB2 - W-5, L-2.lvlx",
	"SMB2 - W-5, L-3.lvlx",
	"SMB2 - W-6, L-1.lvlx",
	"SMB2 - W-6, L-2.lvlx",
	"SMB2 - W-6, L-3.lvlx",
	"SMB2 - W-7, L-1.lvlx",
	"SMB2 - W-7, L-2.lvlx"
}

--Friendly place table for Mother Brain Rinka
GameData.friendlyplaces = {
	"SMAS - Start.lvlx",
	"map.lvlx",
	"intro_8bit.lvlx",
	"intro_bossedit8.lvlx",
	"intro_jakebrito1.lvlx",
	"intro_marioforever.lvlx",
	"intro_S!TS!.lvlx",
	"intro_scrollingheights.lvlx",
	"intro_SMAS.lvlx",
	"intro_SMBX1.0.lvlx",
	"intro_SMBX1.1.lvlx",
	"intro_SMBX1.2.lvlx",
	"intro_SMBX1.3.lvlx",
	"intro_SMBX1.3og.lvlx",
	"intro_SMBX2.lvlx",
	"intro_SMBX2b3.lvlx",
	"intro_sunsetbeach.lvlx",
	"intro_WSMBA.lvlx",
	"MALC - HUB.lvlx",
	"SMAS - Credits.lvlx",
	"SMAS - DLC Levels.lvlx",
	"SMAS - Intro.lvlx",
	"SMAS - Online (Menu).lvlx",
	"SMAS - Test Level.lvlx",
	"SMAS - True Ending.lvlx",
	"SMAS - World Map Warp.lvlx",
	"SMB1 - Level Backtrack 1.lvlx",
	"SMB1 - Level Backtrack 2.lvlx",
	"SMB1 - Level Backtrack 3.lvlx",
	"SMB1 - Level Backtrack 4.lvlx",
	"SMB1 - Level Backtrack 5.lvlx",
	"SMB1 - Level Backtrack 6.lvlx",
	"SMB1 - Level Backtrack 7.lvlx",
	"SMB2 - Ending.lvlx",
	"SMB2 - Level Backtrack 1.lvlx",
	"SMB2 - Level Backtrack 2.lvlx",
	"SMB2 - Level Backtrack 3.lvlx",
	"SMB2 - Level Backtrack 4.lvlx",
	"SMB2 - Level Backtrack 5.lvlx",
	"SMB2 - Level Backtrack 6.lvlx",
	"SMBLL - Level Backtrack 1.lvlx",
	"SMBLL - Level Backtrack 2.lvlx",
	"SMBLL - Level Backtrack 3.lvlx",
	"SMBLL - Level Backtrack 4.lvlx",
	"SMBLL - Level Backtrack 5.lvlx",
	"SMBLL - Level Backtrack 6.lvlx",
	"SMBLL - Level Backtrack 7.lvlx",
	"SMBS - Opening.lvlx",
	"SMW - W-0, L-Green Switch.lvlx",
	"SMW - W-0, L-Yellow Switch.lvlx",
	"SMW - W-0, L-Blue Switch.lvlx"
}

--Menu table for any costume with troublesome sounds
GameData.nolevelplaces = {
	"SMAS - Start.lvlx",
	"map.lvlx",
	"intro_8bit.lvlx",
	"intro_bossedit8.lvlx",
	"intro_jakebrito1.lvlx",
	"intro_marioforever.lvlx",
	"intro_S!TS!.lvlx",
	"intro_scrollingheights.lvlx",
	"intro_SMAS.lvlx",
	"intro_SMBX1.0.lvlx",
	"intro_SMBX1.1.lvlx",
	"intro_SMBX1.2.lvlx",
	"intro_SMBX1.3.lvlx",
	"intro_SMBX1.3og.lvlx",
	"intro_SMBX2.lvlx",
	"intro_SMBX2b3.lvlx",
	"intro_sunsetbeach.lvlx",
	"intro_WSMBA.lvlx",
	"SMAS - Credits.lvlx",
	"SMAS - Intro.lvlx",
	"SMAS - Online (Menu).lvlx",
	"SMB2 - Ending.lvlx"
}

--Now that everything has been loaded, start loading the medium important stuff
local globalgenerals = require("globalgenerals") --Most important library of all. This loads general stuff for levels.
local repll = require("repll") --Custom sound command line, for testing in the editor
local rng = require("base/rng") --Load up rng for etc. things
local playerManager = require("playermanager") --Load up this to change Ultimate Rinka and Ninja Bomberman to Steve and Yoshi
local smascheats = require("smascheats") --To enable edited cheats and some new ones

loadactivate = true
local steve = require("steve")
playerManager.overrideCharacterLib(CHARACTER_ULTIMATERINKA,require("steve"))
local yoshi = require("yiYoshi/yiYoshi")
playerManager.overrideCharacterLib(CHARACTER_MEGAMAN,require("megamann"))
playerManager.overrideCharacterLib(CHARACTER_SNAKE,require("snakey"))
playerManager.overrideCharacterLib(CHARACTER_BOWSER,require("bowserr"))
playerManager.overrideCharacterLib(CHARACTER_ROSALINA,require("rosalinaa"))
playerManager.overrideCharacterLib(CHARACTER_SAMUS,require("samuss"))
playerManager.overrideCharacterLib(CHARACTER_WARIO,require("warioo"))
playerManager.overrideCharacterLib(CHARACTER_ZELDA,require("zeldaa"))
Graphics.sprites.effect[152].img = Graphics.loadImageResolved("graphics/smbx2og/effect/effect-152.png")
Graphics.sprites.effect[153].img = Graphics.loadImageResolved("graphics/smbx2og/effect/effect-153.png")
Graphics.sprites.ultimaterinka[player.powerup].img = Graphics.loadImageResolved("graphics/smbx2og/character/ultimaterinka-2.png")

--First time SaveData setting, for resolutions and other settings
if SaveData.resolution == nil then
	SaveData.resolution = "fullscreen"
end
if SaveData.letterbox == nil then
	SaveData.letterbox = true
end
if SaveData.borderEnabled == nil then
	SaveData.borderEnabled = true
end
if SaveData.totalStarCount == nil then --This will make a new star count system that won't corrupt save files
	SaveData.totalStarCount = 0
end
if SaveData.completeLevels == nil then --This will add a table to list completed levels
	SaveData.completeLevels = {}
end
if SaveData.deathquickoption == true then
	SaveData.deathquickoption = false
end

Progress.value = SaveData.totalStarCount
if SaveData.playerName == nil then
	Progress.savename = "Player"
else
	Progress.savename = SaveData.playerName
end

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

--Now use onLoad to play the loading sound...
function onLoad()
	if not Misc.inEditor() and not table.icontains(noloadingsounds,Level.filename()) and loadactivate == true then --If luna errors during testing in the editor, this will be useful to not load the audio to prevent the audio from still being played until the engine is terminated
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
	loadSaveSlot(Misc.saveSlot()) --This will load the save slot twice, to check to make sure it's been properly loaded
	Routine.run(warpDoorBegin) --This will run the routine to save the original count and to start the system from there
	--Do the weather SaveData additions
	if SaveData.dateplayedweather == nil then
		SaveData.dateplayedweather = weatherControl
	end
	if SaveData.dateplayedmonth == nil then
		SaveData.dateplayedmonth = os.date("%m")
	end
	if SaveData.dateplayedday == nil then
		SaveData.dateplayedday = os.date("%d")
	end
	--Calculate Easter Sunday
	osEaster(os.date("*t").year)
	if SaveData.dateplayedyesterday == nil then
		yesterdaynumber = os.date("*t").day - 1
		yesterdaystring = tostring(yesterdaynumber)
		SaveData.dateplayedyesterday = yesterdaystring
	end
	if SaveData.dateplayedtomorrow == nil then
		tomorrownumber = os.date("*t").day + 1
		tomorrowstring = tostring(tomorrownumber)
		SaveData.dateplayedtomorrow = tomorrowstring
	end
	if GameData.weatherset == true then --This'll be better in the future. For now, it just loads the weather when restarting the game to the start preboot screen, or starting it up every time
		possibleWeather = {"sunny","rain","snow"}
		weatherControl = rng.randomEntry(possibleWeather)
		SaveData.dateplayedweather = weatherControl --Write in a better onetime day function for this
		GameData.weatherset = false
	end
	if not Misc.inEditor() and not table.icontains(noloadingsounds,Level.filename()) then --Make sure to fade out the loading sound when onStart is active...
		fadetolevel = false
		if loadactivate == true then
			loadingSoundObject:FadeOut(800)
			loadactivate = false
		end
	end
	SaveData.dateplayedday = os.date("%d")
	SaveData.dateplayedmonth = os.date("%m")
	tomorrowget()
	yesterdayget()
	if SaveData.dateplayedyear == nil then
		SaveData.dateplayedyear = os.date("%Y")
	end
	SaveData.dateplayedyear = os.date("%Y")
	if SaveData.disableX2char == 0 then --Migrate old saves from pre-March 2022 if there are any.
		SaveData.disableX2char = false
	end
	if SaveData.disableX2char == 1 then
		SaveData.disableX2char = true
	end
	Audio.MusicVolume(nil) --Reset the music volume on onStart, just in case
end

function tomorrowget()
	tomorrownumber = os.date("*t").day + 1
	tomorrowstring = tostring(tomorrownumber)
	SaveData.dateplayedtomorrow = tomorrowstring
end

function yesterdayget()
	yesterdaynumber = os.date("*t").day - 1
	yesterdaystring = tostring(yesterdaynumber)
	SaveData.dateplayedyesterday = yesterdaystring
end

local stardoor = Graphics.loadImageResolved("starlock.png")
local cameratimer = 10
local cameratimer2 = 10
local startGif = false
local endGif = true
local gifIsRecording = false

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
		startGif = false
		endGif = true
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
		startGif = false
		endGif = true
		gifIsRecording = true
		if cameratimer <= 0 then
			cameratimer = 10
			Audio.sounds[12].muted = false
			Audio.sounds[24].muted = false
			noItemSoundGif = false
		end
	end
	if gifIsRecording then
		
	end
end

local startGif = false

function onKeyboardPressDirect(k) --This will replace the GIF recording/snapshot sounds to some custom ones
	if k == VK_F11 then
		Audio.sounds[12].muted = true
		Audio.sounds[24].muted = true
		noSoundGif = true
		if not gifIsRecording then
			playSound("gif-start.ogg")
		elseif gifIsRecording then
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
	if table.icontains(GameData.friendlyplaces,Level.filename()) == true then
		GameData.friendlyArea = true --Set this to prevent Princess Rinka from getting killed in places such as the boot screen, intro, or the Hub
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

--That's the end of this file!