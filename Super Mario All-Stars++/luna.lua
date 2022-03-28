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

local globalgenerals = require("globalgenerals")
local repll = require("repll")
local classicEvents = require("classiceventsmod")
local playerManager = require("playermanager")

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

if SaveData.resolution == nil then
	SaveData.resolution = "fullscreen"
end
if SaveData.letterbox == nil then
	SaveData.letterbox = true
end
if SaveData.borderEnabled == nil then
	SaveData.borderEnabled = true
end

loadingsoundFile = Misc.resolveSoundFile("_OST/All Stars Menu/Loading Screen.ogg")

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

function onLoad(err)
	if Misc.inEditor() or (Level.filename() == "SMAS - Start.lvlx") == false then --If luna errors during testing, this will be useful to not load the audio to prevent the audio from still being played until terminated
		loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
		loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
		fadetolevel = true
	end
	if error then
		Audio.SfxStop(-1)
	end
end

function onStart()
	fadetolevel = false
	if (Level.filename() == "SMAS - Start.lvlx") == false then
		loadingSoundObject:FadeOut(800)
	end
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
end

function onTick()
	mem(0x00B25130,FIELD_WORD, 2)
end