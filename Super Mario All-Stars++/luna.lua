local classicEvents = require("classiceventsmod")
local EventManager = require("main_events_mod")
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

local serializer = require("ext/serializer")
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
				pcall(Misc.dialog, "Error loading SaveData information. Your save file may be corrupted, or you launched the broken X2 launcher. Please seek assistance on the Codehaus Discord server (https://discord.gg/usMKuKF7SN), repairing your save data if you know how, or start a new game.\n\n=============\n"..e)
			end
		end
		return {}
	end
	return {}
end

Misc.saveGame()

local globalgenerals = require("globalgenerals")
local repll = require("repll")
local rng = require("base/rng")
local playerManager = require("playermanager")

if SMBX_VERSION == VER_SEE_SMASPLUSPLUS then
	Graphics.sprites.block[647].img = Graphics.loadImageResolved("graphics/seemod/block/block-647.png")
	Graphics.sprites.block[648].img = Graphics.loadImageResolved("graphics/seemod/block/block-648.png")
	Graphics.sprites.block[655].img = Graphics.loadImageResolved("graphics/seemod/block/block-655.png")
	Graphics.sprites.block[656].img = Graphics.loadImageResolved("graphics/seemod/block/block-656.png")
elseif SMBX_VERSION <= VER_BETA4_PATCH_4_1 then
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

if SaveData.resolution == nil then
	SaveData.resolution = "fullscreen"
end
if SaveData.letterbox == nil then
	SaveData.letterbox = true
end
if SaveData.borderEnabled == nil then
	SaveData.borderEnabled = true
end

-- Gets the index of the player that the camera belongs to. A return value of 0 means that it belongs to everybody
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

local loadingsoundFile = Misc.resolveSoundFile("_OST/All Stars Menu/Loading Screen.ogg")
local noloadingsounds = {
	["SMAS - Start.lvlx"] = true,
	["SMAS - Raca's World (Part 0).lvlx"] = true,
	["SMAS - Raca's World (Part 1).lvlx"] = true,
	["SMAS - Map.lvlx"] = true
}

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

function onLoad()
	if SMBX_VERSION <= VER_BETA4_PATCH_4_1 then
		if not Misc.inEditor() or (noloadingsounds[Level.filename()]) == true then --If luna errors during testing, this will be useful to not load the audio to prevent the audio from still being played until terminated
			loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
			loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
			fadetolevel = true
		end
	end
end

function onStart()
	loadSaveSlot(Misc.saveSlot())
	if SaveData.dateplayedweather == nil then
		SaveData.dateplayedweather = weatherControl
	end
	if SaveData.dateplayedmonth == nil then
		SaveData.dateplayedmonth = os.date("%m")
	end
	if SaveData.dateplayedday == nil then
		SaveData.dateplayedday = os.date("%d")
	end
	if SMBX_VERSION <= VER_BETA4_PATCH_4_1 then
		fadetolevel = false
	end
	if (friendlyplaces[Level.filename()]) == true then
		GameData.friendlyArea = true
	end
	--if __LUNALUA == "0.7 SEE Mod" then
		--GameData.fadetolevel = false
	--end
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
	if GameData.weatherset == true then
		possibleWeather = {"sunny","rain","snow"}
		weatherControl = rng.randomEntry(possibleWeather)
		SaveData.dateplayedweather = weatherControl --Write in a better onetime day function for this
		GameData.weatherset = false
	end
	if SMBX_VERSION <= VER_BETA4_PATCH_4_1 then
		if not Misc.inEditor() or (Level.filename() == noloadingsounds[Level.filename()]) == true then
			fadetolevel = false
			loadingSoundObject:FadeOut(800)
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
	if SaveData.disableX2char == 0 then --Migrate old saves if there are any
		SaveData.disableX2char = false
	end
	if SaveData.disableX2char == 1 then
		SaveData.disableX2char = true
	end
	if GameData.cutsceneMusicControl == false then
		Audio.MusicVolume(65)
	end
	if GameData.cutsceneMusicControl == true then
		Audio.MusicVolume(0)
	end
	--if __LUNALUA == "0.7 SEE Mod" then
		--if GameData.fadetolevel == false then
			--GameData.loadingSoundObject:FadeOut(800)
		--end
	---else
end

function isLeapYear(y)
    return y % 4 == 0 and y % 100 ~= 0 or y % 400 == 0
end

local years = {}
local startD, endD = 1, 2020
for i = startD, endD do
  if isLeapYear(i) then years[#years + 1] = i end
end
--[[
  Note: You Can just plainly use 'isLeapYear()' if you just want to check if a year is a leap year!
]]--

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

function onTick()
	mem(0x00B25130,FIELD_WORD, 2)
end

function onExit()
	--if __LUNALUA == "0.7 SEE Mod" then
		--if not Misc.inEditor() then --If luna errors during testing, this will be useful to not load the audio to prevent the audio from still being played until terminated
			--loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
			--GameData.loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
			--GameData.fadetolevel = true
		--end
	--end
end