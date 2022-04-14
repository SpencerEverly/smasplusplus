--SUPER MARIO ALL-STARS++
--By Spencer Everly
--Here's the starting code that loads it all. How'd I do?

--Make sure we aren't running Beta 3 before we actually start...
if (VER_BETA4_PATCH_3 == nil) or (SMBX_VERSION < VER_BETA4_PATCH_3) then
	Misc.dialog("Hey wait a minute! At least SMBX2 Beta 4 Patch 3 is required to play this game. Please download it from the official site by going to https://codehaus.wohlsoft.ru/. Until then, you can't run this episode. Sorry about that!")
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

GameData.levelMusicTemporary = {temporary}
GameData.levelMusic = {temporary}
GameData.warpStarDoorCount = {temporary}
local smwMap = require("smwMap")
local classicEvents = require("classiceventsmod")
local EventManager = require("main_events_mod")
local extrasounds = require("extrasounds")

--Then we fix up some functions that the X2 team didn't fix yet (If they released a patch and fixed a certain thing, the code will be removed from here).

local function anyValidFields() --This is to prevent any player2 errors while switching between 1/2 player modes. If it's still not working (Hopefully that's not the case) then paste what's below into data/scripts/base/darkness.lua at line 854 and save. Hopefully this'll be fixed in the next patch, along with the teleporting issue
	sectionlist[1] = player.section
	if player2 and player2.isValid then
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

local serializer = require("ext/serializer") --We will then detect to see if the broken SMBX launcher has launched the game. If so, it'll prevent us from loading the episode and recommend us to launch using the SMBX2 launcher instead.
local function loadSaveSlot(slot)
	local filename = "save"..slot.."-ext.dat"
	local f = io.open(Misc.episodePath():gsub([[[\/]+]], [[/]])..filename, "r")
	if f then
		local content = f:read("*all")
		f:close()
		if content ~= "" then
			local s,e = pcall(serializer.deserialize, content, filename)
			if s then
				return e
			else
				pcall(Misc.dialog, "Error loading SaveData information. Your save file may be corrupted, or you launched the broken SMBX launcher. Please seek assistance on the Codehaus Discord server (https://discord.gg/usMKuKF7SN), repairing your save data if you know how, or start a new game.\n\n=============\n"..e)
			end
		end
		return {}
	end
	return {}
end

--Next up is some new resolveFile requiring functions, for simplifying the functions:

function loadFile(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
	return Misc.resolveFile(name)
		or Misc.resolveFile("_OST/" .. name)
		or Misc.resolveFile("_OST/_Sound Effects/"..name)
		or Misc.resolveFile("costumes/" .. name)
		or Misc.resolveFile("scripts/" .. name)
		or Misc.resolveFile("graphics/" .. name)
		or Misc.resolveFile("sound/" .. name)
		or Misc.resolveFile("___MainUserDirectory/" .. name)
end

function loadImg(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
	local file = loadFile(name) or loadFile(name..".png")
	if file then
		return Graphics.loadImageResolved(name)
			or Graphics.loadImageResolved("_OST/" .. name)
			or Graphics.loadImageResolved("costumes/" .. name)
			or Graphics.loadImageResolved("scripts/" .. name)
			or Graphics.loadImageResolved("graphics/" .. name)
			or Graphics.loadImageResolved("___MainUserDirectory/" .. name)
	end
	return nil
end

--drawImg(ImageName, x coordinate, y coordinate, true/false if it's with the priority, true/false if using scene coordinates, priority, opacity)
function drawImg(name, x, y, withPriority, sceneCoords, arg6, arg7) --Drawing graphics got a lot better.
	local fileImage = loadImg(name)
	
	if priority == nil then
		local priority = -1
	end
	if opacity == nil then
		local opacity = 1
	end
	
	if x == nil or y == nil then
		error("You didn't specify the image with any coordinates. Try specifiying coordinates and try again.")
	end
	if withPriority == nil or sceneCoords == nil then
		error("You didn't specify if the image is with a priority, or with scene coordinates. Try setting the booleans and try again.")
	end
	
	if (arg6 ~= nil) and (arg7 ~= nil) then
		if (withPriority) then
			priority = arg6
		end
		opacity = arg7
	elseif (arg7 ~= nil) and ((not withPriority) or (arg6 ~= nil)) then
		opacity = arg6
	elseif (withPriority) then
		priority = arg6
	else
	end
	if (withPriority) and (sceneCoords) then
		Graphics.drawImageToSceneWP(fileImage, x, y, true, true, arg7, arg6)
	elseif (withPriority) and (not sceneCoords) then
		Graphics.drawImageWP(fileImage, x, y, true, false, arg7, arg6)
	elseif (not withPriority) and (sceneCoords) then
		Graphics.drawImageToScene(fileImage, x, y, false, true, arg6)
	elseif (not withPriority) and (not sceneCoords) then
		Graphics.drawImage(fileImage, x, y, false, false, arg6)
	end
end

function openSound(name) --Opening SFXs
	SFX.open(name)
end

function playSound(name) --Playing SFXs
	if name == nil then
		error("That sound doesn't exist.")
	end
	if unexpected_condition then error("That sound doesn't exist.") end
	
	if extrasounds.id[name] then
		SFX.play(extrasounds.id[name])
	elseif name then
		loadSound(name)
	end
end

function loadSound(name) --Opening external sounds and playing them. Also can use playSound alternatively
	local file = Misc.resolveSoundFile(name) or Misc.resolveSoundFile("_OST/"..name) or Misc.resolveSoundFile("_OST/_Sound Effects/"..name) or Misc.resolveSoundFile("costumes/"..name) or Misc.resolveSoundFile("___MainUserDirectory/"..name) --Common sound directories, see above for the entire list
	SFX.play(file) --Play it afterward, since there isn't anywhere else I can do this
end

function changeMusic(name, sectionid) --Music changing is now a LOT easier
	if sectionid == -1 then --If -1, all section music will change to the specified song
		for i = 0,20 do
			Audio.MusicChange(i, name)
		end
	elseif sectionid >= 0 or sectionid <= 20 then
		Audio.MusicChange(sectionid, name)
	end
end

function muteMusic(sectionid) --Mute all section music, or just mute a specific section
	if sectionid == -1 then --If -1, all section music will be muted
		for i = 0,20 do
			musiclist = {Section(i).music}
			GameData.levelMusicTemporary[i] = Section(i).music
			Audio.MusicChange(i, 0)
		end
	elseif sectionid >= 0 or sectionid <= 20 then
		musiclist = {Section(sectionid).music}
		GameData.levelMusicTemporary[sectionid] = Section(sectionid).music
		Audio.MusicChange(sectionid, 0)
	end
end

function restoreMusic(sectionid) --Restore all section music, or just restore a specific section
	if sectionid == -1 then --If -1, all section music will be restored
		for i = 0,20 do
			songname = GameData.levelMusicTemporary[i]
			Section(i).music = songname
		end
	elseif sectionid >= 0 or sectionid <= 20 then
		songname = GameData.levelMusicTemporary[sectionid]
		Section(sectionid).music = songname
	end
end

function refreshMusic(sectionid) --Refresh the music that's currently playing by updating the music table
	if sectionid == -1 then --If -1, all section music will be counted
		for i = 0,20 do
			musiclist = {Section(i).music}
			GameData.levelMusicTemporary[i] = Section(i).music
		end
	elseif sectionid >= 0 or sectionid <= 20 then
		musiclist = {Section(sectionid).music}
		GameData.levelMusicTemporary[sectionid] = Section(sectionid).music
	end
end

--Now we get to the Hub date detection stuff. First, we start with Easter...
function div (x, y) return math.floor(x / y) end
function calculateeaster(year) --"Happy easter! (Foot goes into the toilet with a kick sound)" - Vince
    local G = year % 19
    local C = div(year, 100)
    local H = (C - div(C, 4) - div((8 * C + 13), 25) + 19 * G + 15) % 30
    local I = H - div(H, 28) * (1 - div(29, H + 1)) * (div(21 - G, 11))
    local J = (year + div(year, 4) + I + 2 - C + div(C, 4)) % 7
    local L = I - J
    local month = 3 + div(L + 40, 44)
	SaveData.eastermonth = month
	SaveData.easterday = L + 28 - 31 * div(month, 4)
	return "Easter Sunday is on: ",month,"/",L + 28 - 31 * div(month, 4),". The data has been saved."
end

function isLeapYear(y) --Now for the leap year detection...
    return y % 4 == 0 and y % 100 ~= 0 or y % 400 == 0
end

local years = {}
local startD, endD = 1, 2020
for i = startD, endD do
  if isLeapYear(i) then years[#years + 1] = i end
end
--Note: You can just plainly use 'isLeapYear()' if you just want to check if a year is a leap year!

--Now that everything has been loaded, save the game and start loading the medium important stuff
Misc.saveGame()
local globalgenerals = require("globalgenerals") --Most important library of all. This loads general stuff for levels.
local repll = require("repll") --Custom sound command line, for testing in the editor
local rng = require("base/rng") --Load up rng for etc. things
local playerManager = require("playermanager") --Load up this to change Ultimate Rinka and Ninja Bomberman to Steve and Yoshi

if SMBX_VERSION == VER_SEE_MOD then --SEE Mod stuff
	Graphics.sprites.block[647].img = Graphics.loadImageResolved("graphics/seemod/block/block-647.png")
	Graphics.sprites.block[648].img = Graphics.loadImageResolved("graphics/seemod/block/block-648.png")
	Graphics.sprites.block[655].img = Graphics.loadImageResolved("graphics/seemod/block/block-655.png")
	Graphics.sprites.block[656].img = Graphics.loadImageResolved("graphics/seemod/block/block-656.png")
	princessRinka = require("characters/princessrinka")
	Misc.setWindowTitle("Super Mario All-Stars++")
	__disablePauseMenu = true
	Misc.setWindowIcon(Graphics.loadImageResolved("graphics/icon/icon.png"))
elseif SMBX_VERSION <= VER_BETA4_PATCH_4_1 then --This will load things for any other SMB2 version
	loadactivate = true
	steve = require("steve")
	playerManager.overrideCharacterLib(CHARACTER_ULTIMATERINKA,require("steve"))
	yoshi = require("yiYoshi/yiYoshi")
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
end

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
if SaveData.completeLevels == nil then
	SaveData.completeLevels = {}
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

--Placing in levels onto a table that'll prevent the loading sound from playing
local noloadingsounds = {
	["SMAS - Start.lvlx"] = true,
	["SMAS - Raca's World (Part 0).lvlx"] = true,
	["SMAS - Raca's World (Part 1).lvlx"] = true,
	["map.lvlx"] = true
}

--Friendly place table for the SEE Mod's Princess Rinka
local friendlyplaces = {
	["SMAS - Start.lvlx"] = true,
	["SMAS - Map.lvlx"] = true,
	["intro_8bit.lvlx"] = true,
	["intro_bossedit8.lvlx"] = true,
	["intro_jakebrito1.lvlx"] = true,
	["intro_marioforever.lvlx"] = true,
	["intro_S!TS!.lvlx"] = true,
	["intro_scrollingheights.lvlx"] = true,
	["intro_SMAS.lvlx"] = true,
	["intro_SMBX1.0.lvlx"] = true,
	["intro_SMBX1.1.lvlx"] = true,
	["intro_SMBX1.2.lvlx"] = true,
	["intro_SMBX1.3.lvlx"] = true,
	["intro_SMBX1.3og.lvlx"] = true,
	["intro_SMBX2.lvlx"] = true,
	["intro_SMBX2b3.lvlx"] = true,
	["intro_sunsetbeach.lvlx"] = true,
	["intro_WSMBA.lvlx"] = true,
	["MALC - HUB.lvlx"] = true,
	["SMAS - Credits.lvlx"] = true,
	["SMAS - DLC Levels.lvlx"] = true,
	["SMAS - Intro.lvlx"] = true,
	["SMAS - Online (Menu).lvlx"] = true,
	["SMAS - Test Level.lvlx"] = true,
	["SMAS - True Ending.lvlx"] = true,
	["SMAS - World Map Warp.lvlx"] = true,
	["SMB1 - Level Backtrack 1.lvlx"] = true,
	["SMB1 - Level Backtrack 2.lvlx"] = true,
	["SMB1 - Level Backtrack 3.lvlx"] = true,
	["SMB1 - Level Backtrack 4.lvlx"] = true,
	["SMB1 - Level Backtrack 5.lvlx"] = true,
	["SMB1 - Level Backtrack 6.lvlx"] = true,
	["SMB1 - Level Backtrack 7.lvlx"] = true,
	["SMB2 - Ending.lvlx"] = true,
	["SMB2 - Level Backtrack 1.lvlx"] = true,
	["SMB2 - Level Backtrack 2.lvlx"] = true,
	["SMB2 - Level Backtrack 3.lvlx"] = true,
	["SMB2 - Level Backtrack 4.lvlx"] = true,
	["SMB2 - Level Backtrack 5.lvlx"] = true,
	["SMB2 - Level Backtrack 6.lvlx"] = true,
	["SMBLL - Level Backtrack 1.lvlx"] = true,
	["SMBLL - Level Backtrack 2.lvlx"] = true,
	["SMBLL - Level Backtrack 3.lvlx"] = true,
	["SMBLL - Level Backtrack 4.lvlx"] = true,
	["SMBLL - Level Backtrack 5.lvlx"] = true,
	["SMBLL - Level Backtrack 6.lvlx"] = true,
	["SMBLL - Level Backtrack 7.lvlx"] = true,
	["SMBS - Opening.lvlx"] = true,
	["SMW - W-0, L-Green Switch.lvlx"] = true,
	["SMW - W-0, L-Yellow Switch.lvlx"] = true,
	["SMW - W-0, L-Blue Switch.lvlx"] = true
}

--Now use onLoad to play the loading sound...
function onLoad()
	if not Misc.inEditor() or (Level.filename()[noloadingsounds]) == true and loadactivate == true then --If luna errors during testing in the editor, this will be useful to not load the audio to prevent the audio from still being played until the engine is terminated
		loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
		loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
		fadetolevel = true
	end
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
	if (Level.filename()[friendlyplaces]) == true then
		if SMBX_VERSION == VER_SEE_MOD then
			princessRinka.friendlyArea = true --Set this to prevent Princess Rinka from getting killed in places such as the boot screen, intro, or the Hub
		end
	end
	--Calculate Easter Sunday
	calculateeaster(os.date("*t").year)
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
	if not Misc.inEditor() or (Level.filename() == noloadingsounds[Level.filename()]) == true then --Make sure to fade out the loading sound when onStart is active...
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

function onMessageBox(eventObj,message,playerObj,npcObj)
    if message == "You need 1 star to enter." then
        eventObj.cancelled = true
		
    elseif message:match("You need %d stars to enter.") ~= nil then
        eventObj.cancelled = true
    end
end

local stardoor = Graphics.loadImageResolved("starlock.png")

function onDraw()
	local warps = Warp.get()
	for _, v in ipairs(warps) do
		if v.isValid and (not v.isHidden) and v.starsRequired > SaveData.totalStarCount then
			Graphics.drawImageToSceneWP(stardoor, v.entranceX + 0.5 * v.entranceWidth - 12, v.entranceY - 20, -40)
        end
    end
end

function onTick() --This will prevent split screen, again (Just in case)
	mem(0x00B25130,FIELD_WORD, 2)
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