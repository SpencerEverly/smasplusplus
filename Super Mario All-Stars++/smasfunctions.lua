--smasfunctions.lua
--v1.0
--These are simplified functions useful for doing certain commands that don't rely
--on so much code. Below are the functions and what they do.

--FILE LOADING/IMAGES
--_ loadFile('path/to/file.extension'): Loads a file from any of the common directories, plus
--the common SMAS directories as well.
--_ loadImg('path/to/file.extension'): Loads an image from any of the common directories, plus
--the common SMAS directories as well.
--_ function drawImg('path/to/file.extension', x, y, withPriority, sceneCoords, priority,
--opacity): Draws an image using a simplified function.
--
--MUSIC/SOUNDS
--_ openSound('path/to/file.extension'): Opens a sound for reading.
--_ playSound('path/to/file.extension'/number): Plays a sound. This library is compatible with
--extrasounds (Enter extrasoundsHelp() for more info).
--_ loadSound('path/to/file.extension'): Alternative to playSound, except without
--extrasounds support.
--_ loadSoundOnly('path/to/file.extension'): Loads a sound only, and doesn't play
--it back.
--_ resolveCostumeSound(sound): Used for switching costume sounds throughout when
--wearing a costume.
--_ loadCostumeSounds(): Used to load up the sounds for the costume.
--_ changeMusic('path/to/file.extension', section ID): Changes the music to a
--specified path. If using -1 as the section ID, all sections will be counted.
--_ muteMusic(section ID): Mute the music to a specified section. The music before
--changing will be temporarily stored. If using -1 as the section ID, all sections
--will be counted. Be sure not to activate this twice, or else the muted music will
--be perma-stored in the temporary table. Use restoreOriginalMusic(-1) if you
--accidentally activate it twice.
--_ restoreMusic(section ID): Restores the music to a specified section. The music after
--changing using muteMusic will be restored. If using -1 as the section ID, all sections
--will be counted. (Don't run this before using muteMusic())
--_ refreshMusic(section ID): Refreshes the currently changed music by putting the new
--music into the temporary table. If using -1 as the section ID, all sections
--will be counted.
--_ restoreOriginalMusic(section ID): Restores the original music from the unmodifiable
--level music which gets stored when onStart is called. If using -1 as the section ID,
--all sections will be counted.
--
--GAME/FILE MANAGEMENT
--_ writeToFile('path/to/file.extension', 'text'): Write to a file using io. This will
--overwrite everything with the text specified, so BE CAREFUL!
--_ addToFile('path/to/file.extension', 'text'): Add to a file using io. This won't
--overwrite everything, just adds something to the file, so this one is fine.
--_ lifeCount(): Returns the SMAS++ life count.
--_ lifeCountWithCrowns(): Returns the SMAs++ life count with the crowns. Every
--crown will be with a "!" since that's the symbol being used for displaying the
--crown.
--_ manageLives(lives, true/false): Manages the lives. If true, it'll add the lives. If false, it'll
--subtract the lives.
--_ maxOutLives(): Maxes out lives to 1110.
--_ resetLives(): Resets the lives back to the default value (5).
--_ deathCount(): Returns the SMAS++ death count.
--_ maxOutDeathCount(): Maxes out death count to 999.
--_ resetDeathCount(): Resets the death count back to the default value (0).
--_ starCount(): Returns the SMAS++ star count.
--_ maxOutStars(): Maxes out the star count to 9999
--_ clearAllStars(): This clears all the stars, and even the level table
--_ manageStars(number of stars, add/subtract): Manages the star count. 'add' will add,
--'subtract' will subtract the stars.
--
--DATE/TIME
--_ osDay(): Lists the day.
--_ osMonth(): Lists the month.
--_ osYear(): Lists the year.
--_ osHour(): Lists the hour.
--_ osMinute(): Lists the minute.
--_ osSecond(): Lists the second.
--_ osTomorrow(): Lists the day after today.
--_ osYesterday(): Lists the day before today.
--_ osDayJulian(): Converts the Gregorian Day to Julian.
--_ osJulianNumber(): Lists the number of the real Julian Time.
--_ osEaster(year): Lists when Easter Sunday is on the specified year. The date will
--be saved into SaveData (This automatically runs with the real year every level
--boot)
--_ osLeapYear(year): Lists if the year has a leap day during the year.
--
--PLAYER FUNCTIONS
--_ betterPlayer(player ID, function(plr) plr.code() end): A better way to run
--functions with the player without the fangled 'if Player(2) and Player(2).isValid'
--mess. Useful for running commands on things like all players (-1), or just one of
--them.
--_ activate1stPlayer(): If in 2nd Player Mode and greater, this will revert to 1st
--Player.
--_ activate2ndPlayer(): This activates 2 player mode.
--_ activate3rdPlayer(): Wip 3 player mode. Not done yet.
--_ activate4thPlayer(): Wip 4 player mode. Not done yet.
--_ activatePlayerIntroMode(): This activates the intro imitaiton mode, where 6
--players move to the right while jumping around automatically. This is normally
--used on the main menu of the episode (Certain themes).
--_ isAnyPlayerAlive(): Returns if any player is still alive.
--_ isPlayerUnderwater(): Returns true if the first player is underwater.
--_ isPlayerGrabbing(): Returns true if the first player is grabbing something.
--_ toggleStarman(): Activates or deactivates the starman.
--_ toggleMegashroom(): Activates or deactivates the megashroom.
--
--NPC FUNCTIONS
--_ harmAllNPCs(): Harms every single NPC is the entire level.
--_ harmSpecificNPC(id): Harms a specific NPC ID in the entire level.
--
--MISC FUNCTIONS
--_ getEpisodeFilename(): Gets the episode filename for the episode. If under the
--editor, it'll return 'Editor Mode' instead.
--_ isExtraSoundsActive(): Checks to see if extrasounds is turned on.
--_ listUserFiles(path): Lists the files in the main modifiable user directory.
--_ toggleWindowOnly(): This, when fullscreen, will only toggle a window instead
--of being in fullscreen. Toggle again to turn off.
--_ doPSwitchUntimed(bool): This will turn on the P-Switch, without a timer.
--_ rngTrueValue(argument): RNGs a random value, truly.
--_ loadSaveSlot(slot): Loads any save slot.
--_ saveSaveSlot(slot): Saves a specified save slot.
--_ moveSaveSlot(slot, destination): This moves a save slot to another save slot.
--Highest you can go is 32767 (The original slot will be reset after moving, due to
--os.remove not existing on LunaLua).
--_ eraseSaveSlot(slot): This is only used for the SMAS++ erase save slot tool
--and speedrun save data purge option. This will reset your save data, but
--without clearing SaveData/GameData.
--_ getLegacyStarsCollected(): This is for the Demo 3 save migration tool which
--runs when stars were collected from Demo 2 and below. This will be unused
--by the time Demo 4 releases (And/or the full release happens).
--_ getLegacyStarsCollectedNameOnly(): Same as last, except it only lists
--the names via a table.

local smasfunctions = {}

local extrasounds = require("extrasounds")
local rng = require("base/rng")
local customCamera = require("customCamera")
local starman = require("starman/star")
local megashroom = require("mega/megashroom")
local playerManager = require("playermanager")
local smasverbosemode = require("smasverbosemode")
local smastables = require("smastables")

local GM_PLAYERS_ADDR = mem(0x00B25A20, FIELD_DWORD) --For the player adding and removing function
local GM_PLAYERS_COUNT_ADDR = 0x00B2595E
local GM_STAR_ADDR = mem(0x00B25714, FIELD_DWORD)

local costumes = playerManager.getCostumes(player.character)
local currentCostume = player:getCostume()

local intromodeactivated = false
local introtime = 0
local jumptime = 0
local activatejump = false

local threeplayermode = false
local fourplayermode = false

function smasfunctions.onInitAPI()
	registerEvent(smasfunctions,"onDraw")
	registerEvent(smasfunctions,"onInputUpdate")
	registerEvent(smasfunctions,"onStart")
end

function smasfunctions.onInputUpdate()
	if intromodeactivated then
		local playernumber = rng.randomInt(1,6)
		for i = 1,6 do
			Player(i).keys.left = false
			Player(i).keys.right = true --These keys are force-held like the og intro
			Player(i).keys.run = true
		end
		if Player(i).powerup == 4 or Player(i).powerup == 5 then --If leaf or tanooki, fly down when flying
			if Player(i):mem(0x16E, FIELD_BOOL, true) then
				Player(i).keys.jump = true
			end
		end
		if Player(i):mem(0x11C, FIELD_WORD) >= 1 then --Jump momentum detection
			Player(i).keys.jump = true
		end
		if activatejump then
			Player(playernumber).keys.jump = true
		end
	end
	if threeplayermode then
		for k,p in ipairs(Player.get()) do
			if Player(2) and Player(2).isValid then
				
			end
			if Player(3) and Player(3).isValid then
				
			end
		end
	end
end

function smasfunctions.onDraw()
	if intromodeactivated then
		introtime = introtime - 3
		jumptime = 29
		for i = 1,6 do
			Player(i).direction = 1 --Direction is always right
			if introtime <= 0 then
				introtime = rng.randomInt(1,120)
				activatejump = true
			end
			if activatejump then
				jumptime = jumptime - 1
				if jumptime <= 0 then
					jumptime = 29
					activatejump = false
				end
			end
		end
	end
end

-----------------------
--File Loading/Images
-----------------------

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
	local fileImage = Misc.resolveGraphicsFile(name)
	if fileImage == nil then
		fileImage = Graphics.loadImageResolved("noimage.png")
	end
	
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

----------------
--Music/Sounds
----------------

function openSound(name) --Opening SFXs
	SFX.open(name)
end

function playSound(name) --Playing SFXs
	if name == nil then
		error("That sound doesn't exist. Play something else.")
	end
	if unexpected_condition then error("That sound doesn't exist. Play something else.") end
	
	if extrasounds.id[name] then
		SFX.play(extrasounds.id[name])
	elseif name then
		local file = Misc.resolveSoundFile(name) or Misc.resolveSoundFile("_OST/"..name) or Misc.resolveSoundFile("_OST/_Sound Effects/"..name) or Misc.resolveSoundFile("costumes/"..name) or Misc.resolveSoundFile("___MainUserDirectory/"..name) --Common sound directories, see above for the entire list
		SFX.play(file) --Then play it afterward
	end
end

function loadSoundOnly(name) --Opening external sounds, but doesn't play them.
	local file = Misc.resolveSoundFile(name) or Misc.resolveSoundFile("_OST/"..name) or Misc.resolveSoundFile("_OST/_Sound Effects/"..name) or Misc.resolveSoundFile("costumes/"..name) or Misc.resolveSoundFile("___MainUserDirectory/"..name) --Common sound directories, see above for the entire list
end

function resolveCostumeSound(name) --Resolve a sound for a costume being worn.
	local costumesounddir
	if player:getCostume() == nil then
		costumesounddir = Misc.resolveSoundFile(name)
	else
		costumesounddir = Misc.resolveSoundFile("costumes/" .. playerManager.getName(player.character) .. "/" .. player:getCostume() .. "/" .. name)
	end
	if costumesounddir == nil then
		--Sound could not be found
		return nil
	end
	return SFX.open(costumesounddir)
end

function loadCostumeSounds() --Load up the sounds when a costume is being worn. If there is no costume, it'll load up stock sounds instead.
	for k,v in ipairs(smastables.soundNamesInOrder) do
		if smastables.extrasoundsNumbersInOrder[k] then
			extrasounds.id[k] = resolveCostumeSound(v)
		else
			Audio.sounds[k].sfx = resolveCostumeSound(v)
		end
	end
end

function changeMusic(name, sectionid) --Music changing is now a LOT easier
	if sectionid == -1 then --If -1, all section music will change to the specified song
		for i = 0,20 do
			Section(i).music = name
		end
	elseif sectionid >= 0 or sectionid <= 20 then
		Section(sectionid).music = name
	elseif sectionid >= 21 then
		error("That's higher than SMBX2 can go. Go to a lower section than that.")
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
	elseif sectionid >= 21 then
		error("That's higher than SMBX2 can go. Go to a lower section than that.")
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
	elseif sectionid >= 21 then
		error("That's higher than SMBX2 can go. Go to a lower section than that.")
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
	elseif sectionid >= 21 then
		error("That's higher than SMBX2 can go. Go to a lower section than that.")
	end
end

function restoreOriginalMusic(sectionid) --Restore all original section music, or just restore a specific section
	if sectionid == -1 then --If -1, all section music will be restored
		for i = 0,20 do
			songname = GameData.levelMusic[i]
			Section(i).music = songname
		end
	elseif sectionid >= 0 or sectionid <= 20 then
		songname = GameData.levelMusic[sectionid]
		Section(sectionid).music = songname
	elseif sectionid >= 21 then
		error("That's higher than SMBX2 can go. Go to a lower section than that.")
	end
end

------------------------
--Game/File Management
------------------------

function writeToFile(name, text) --Write to a file using io. This will overwrite everything with the text specified, so BE CAREFUL!
    name = Misc.resolveFile(name)
    if name == nil then
        error("You need to specify the name of the file.")
    end
	if not "string" then
		error("That needs to be a string.")
	end

    local f = io.open(name,"w")
    if f == nil then
        return
    end

    f:write(text)
    f:close()
end

function addToFile(name, text) --Add to a file using io. This won't overwrite everything, just adds something to the file, so this one is fine.
    name = Misc.resolveFile(name)
    if name == nil then
        error("You need to specify the name of the file.")
    end
	if not "string" then
		error("That needs to be a string.")
	end

    local f = io.open(name,"a")
    if f == nil then
        return
    end

    f:write(text)
    f:close()
end

--Lives

function lifeCount() --This lists the current life count
	if SaveData.totalLives == nil then
		return 0
	else
		return SaveData.totalLives
	end
end

function lifeCountWithCrowns() --This lists the current life count, with the crown system. Crowns will be with "!" instead of an actual crown symbol.
	if SaveData.totalLives == nil then
		return 0
	elseif SaveData.totalLives < 1000 then
		return SaveData.totalLives
	elseif SaveData.totalLives >= 1000 and SaveData.totalLives <= 1009 then
		return string.format("!0%1d",tostring(SaveData.totalLives):sub(3, 4))
	elseif SaveData.totalLives >= 1010 and SaveData.totalLives < 1100 then
		return string.format("!%2d",tostring(SaveData.totalLives):sub(3, 4))
	elseif SaveData.totalLives >= 1100 and SaveData.totalLives < 1110 then
		return string.format("!!%1d",tostring(SaveData.totalLives):sub(4, 4))
	elseif SaveData.totalLives == 1110 then
		return "!!!"
	end
end

function lifeCountWithCrownsAndZeroFailsafe() --This lists the current life count, with the crown system. Crowns will be with "!" instead of an actual crown symbol.
	if SaveData.totalLives == nil then
		return 0
	elseif SaveData.totalLives < 0 then
		return 0
	elseif SaveData.totalLives < 1000 then
		return SaveData.totalLives
	elseif SaveData.totalLives >= 1000 and SaveData.totalLives <= 1009 then
		return string.format("!0%1d",tostring(SaveData.totalLives):sub(3, 4))
	elseif SaveData.totalLives >= 1010 and SaveData.totalLives < 1100 then
		return string.format("!%2d",tostring(SaveData.totalLives):sub(3, 4))
	elseif SaveData.totalLives >= 1100 and SaveData.totalLives < 1110 then
		return string.format("!!%1d",tostring(SaveData.totalLives):sub(4, 4))
	elseif SaveData.totalLives == 1110 then
		return "!!!"
	end
end

function manageLives(lives, mathcount) --arg1 = number of lives, arg2 = to add (true) or subtract them (false)
	if lives == nil then
		error("You need to specify the number of lives.")
	end
	if mathcount == nil then
		error("You need to specify whenever to add (true) or subtract (false) the life count.")
	end
	if not mathcount then
		SaveData.totalLives = SaveData.totalLives - lives
	elseif mathcount then
		SaveData.totalLives = SaveData.totalLives + lives
	end
end

function maxOutLives() --This maxes out the lives to 1110 (All three crowns).
	playSound(98)
	SaveData.totalLives = 1110
end

function resetLives() --This resets the lives back to 5
	playSound(67)
	SaveData.totalLives = 5
end

--Death Count

function deathCount() --This lists the current life count
	if SaveData.deathCount == nil then
		return 0
	else
		return SaveData.deathCount
	end
end

function maxOutDeathCount() --This maxes out the death count to 999
	playSound(67)
	SaveData.deathCount = 999
end

function resetDeathCount() --This resets the death count back to 0
	playSound(98)
	SaveData.deathCount = 0
end

--Star Count

function starCount() --This lists the count of the stars
	if SaveData.totalStarCount == nil then
		return 0
	else
		return SaveData.totalStarCount
	end
end

function maxOutStars() --This maxs the star count to 9999
	SaveData.totalStarCount = 9999
end

function clearAllStars() --This clears all the stars, and even all the level tables
	playSound(67)
	SaveData.totalStarCount = 0
	for k in pairs(SaveData.completeLevels) do
		SaveData.completeLevels[k] = nil
	end
	for k in pairs(SaveData.completeLevelsOptional) do
		SaveData.completeLevelsOptional[k] = nil
	end
	SaveData.completeLevels = {}
	SaveData.completeLevelsOptional = {}
end

function manageStars(arg1, arg2) --arg1 = Number of stars, arg2 = To add or subtract them
	if arg1 == nil then
		error("You need to specify the number of stars.")
	end
	if arg2 == nil then
		error("You need to specify whenever to subtract or add the stars.")
	end
	if (arg1 ~= nil) and (arg2 ~= nil) then
		stars = arg1
		mathcount = arg2
	else
	end
	if mathcount == subtract then
		SaveData.totalStarCount = SaveData.totalStarCount - stars
	elseif mathcount == add then
		SaveData.totalStarCount = SaveData.totalStarCount + stars
	end
end

function scoreCount() --Returns the score count.
	return SaveData.totalScoreClassic
end

function scoreCountWithZeroes() --Returns the score count with zeroes.
	if SaveData.totalScoreClassic >= 0 then
		return string.format("%000000009d",tostring(SaveData.totalScoreClassic))
	elseif SaveData.totalScoreClassic >= 9 then
		return string.format("%00000008d",tostring(SaveData.totalScoreClassic))
	elseif SaveData.totalScoreClassic >= 99 then
		return string.format("%0000007d",tostring(SaveData.totalScoreClassic))
	elseif SaveData.totalScoreClassic >= 999 then
		return string.format("%000006d",tostring(SaveData.totalScoreClassic))
	elseif SaveData.totalScoreClassic >= 9999 then
		return string.format("%00005d",tostring(SaveData.totalScoreClassic))
	elseif SaveData.totalScoreClassic >= 99999 then
		return string.format("%0004d",tostring(SaveData.totalScoreClassic))
	elseif SaveData.totalScoreClassic >= 999999 then
		return string.format("%003d",tostring(SaveData.totalScoreClassic))
	elseif SaveData.totalScoreClassic >= 9999999 then
		return string.format("%02d",tostring(SaveData.totalScoreClassic))
	elseif SaveData.totalScoreClassic >= 99999999 then
		return string.format("%1d",tostring(SaveData.totalScoreClassic))
	elseif SaveData.totalScoreClassic >= 999999999 then
		return SaveData.totalScoreClassic
	end
end

function scoreCount13() --Returns the score count limited within 1.3 Mode's digit numbers.
	if SaveData.totalScoreClassic <= 9999999 then
		return SaveData.totalScoreClassic
	elseif SaveData.totalScoreClassic >= 9999999 then
		return 9999999
	end
end

function coinCountClassic() --Returns the classic coin count.
	return SaveData.totalCoinsClassic
end

function coinCountClassicWith99Limit() --Returns the classic coin count, but with a 99 coin limiter when above 100.
	if SaveData.totalCoinsClassic < 100 then
		return SaveData.totalCoinsClassic
	elseif SaveData.totalCoinsClassic >= 100 then
		return 99
	end
end

-----------------------
--Date/Time Functions
-----------------------

--Below are the usual day/month/year counts
function osDay()
	return os.date("*t").day
end

function osMonth()
	return os.date("*t").month
end

function osYear()
	return os.date("*t").year
end

function osHour()
	return os.date("*t").hour
end

function osMinute()
	return os.date("*t").min
end

function osSecond()
	return os.date("*t").sec
end

function osTomorrow()
	return SaveData.dateplayedtomorrow
end

function osYesterday()
	return SaveData.dateplayedyesterday
end

function osDayJulian() --Converts Gregorian day to the Julian day.
	return (os.date("*t").day - 13)
end

function osJulianNumber() --A number telling the real Julian time
	return (os.time() / 86400) + 2440587.5
end

function easterdiv(x, y) --This is used for calculating Easter
	return math.floor(x / y)
end

function osEaster(year) --This will calculate Easter Sunday, and show the day and time after saving it to SaveData.
    local G = year % 19
    local C = easterdiv(year, 100)
    local H = (C - easterdiv(C, 4) - easterdiv((8 * C + 13), 25) + 19 * G + 15) % 30
    local I = H - easterdiv(H, 28) * (1 - easterdiv(29, H + 1)) * (easterdiv(21 - G, 11))
    local J = (year + easterdiv(year, 4) + I + 2 - C + easterdiv(C, 4)) % 7
    local L = I - J
    local month = 3 + easterdiv(L + 40, 44)
	SaveData.eastermonth = month
	SaveData.easterday = L + 28 - 31 * easterdiv(month, 4)
	return "Easter Sunday is on "..SaveData.eastermonth.."/"..SaveData.easterday.."."
end

function osLeapYear(y) --This detects the Leap Year.
    return y % 4 == 0 and y % 100 ~= 0 or y % 400 == 0
end

local years = {}
local startD, endD = 1, 2020
for i = startD, endD do
	if osLeapYear(i) then years[#years + 1] = i end
end

--------------------
--Player functions
--------------------

function betterPlayer(index, func) --Better player/player2 detection, for simplifying mem functions, or detecting either player for any code-related function. Example: betterPlayer(1, function(plr) plr:kill() end)
	if index == nil then
		index = 1
	end
	if index == -1 then
		for i = 1,128 do
			if Player(i) and Player(i).isValid then
				func(Player(i))
			end
		end
	else
		local plr = Player(index)
		if plr and plr.isValid then
			func(plr)
		end
	end
end

function activate1stPlayer()
	mem(0x00B2595E, FIELD_WORD, 1)
end

function activate2ndPlayer()
	mem(0x00B2595E, FIELD_WORD, 2)
	if Player(2) and Player(2).isValid then
		Player(2).x = player.x + 36
		Player(2).y = player.y - 72
		Player(2).character = 2
		if Player(2).powerup == 0 then
			Player(2).powerup = 2
		end
	end
end

function activate3rdPlayer()
	mem(0x00B2595E, FIELD_WORD, 3)
	if Player(2) and Player(2).isValid then
		Player(2).x = player.x + 36
		Player(2).y = player.y - 72
		Player(2).character = 2
		if Player(2).powerup == 0 then
			Player(2).powerup = 2
		end
	end
	if Player(3) and Player(3).isValid then
		Player(3).x = player.x + 94
		Player(3).y = player.y - 72
		Player(3).character = 3
		if Player(3).powerup == 0 then
			Player(3).powerup = 2
		end
	end
end

function activate4thPlayer()
	mem(0x00B2595E, FIELD_WORD, 4)
	if Player(2) and Player(2).isValid then
		Player(2).x = player.x + 36
		Player(2).y = player.y - 72
		Player(2).character = 2
		if Player(2).powerup == 0 then
			Player(2).powerup = 2
		end
	end
	if Player(3) and Player(3).isValid then
		Player(3).x = player.x + 94
		Player(3).y = player.y - 72
		Player(3).character = 3
		if Player(3).powerup == 0 then
			Player(3).powerup = 2
		end
	end
	if Player(4) and Player(4).isValid then
		Player(4).x = player.x + 130
		Player(4).y = player.y - 72
		Player(4).character = 4
		if Player(4).powerup == 0 then
			Player(4).powerup = 2
		end
	end
end

function activatePlayerIntroMode()
	mem(0x00B2595E, FIELD_WORD, 6)
	if Player(2) and Player(2).isValid then
		Player(2).x = player.x
		Player(2).y = player.y
		Player(2).character = 2
		if Player(2).powerup == 0 then
			Player(2).powerup = 2
		end
	end
	if Player(3) and Player(3).isValid then
		Player(3).x = player.x
		Player(3).y = player.y
		Player(3).character = 3
		if Player(3).powerup == 0 then
			Player(3).powerup = 2
		end
	end
	if Player(4) and Player(4).isValid then
		Player(4).x = player.x
		Player(4).y = player.y
		Player(4).character = 4
		if Player(4).powerup == 0 then
			Player(4).powerup = 2
		end
	end
	if Player(5) and Player(5).isValid then
		Player(5).x = player.x
		Player(5).y = player.y
		Player(5).character = 4
		if Player(5).powerup == 0 then
			Player(5).powerup = 2
		end
	end
	if Player(6) and Player(6).isValid then
		Player(6).x = player.x
		Player(6).y = player.y
		Player(6).character = 4
		if Player(6).powerup == 0 then
			Player(6).powerup = 2
		end
	end
	local rngcharacter1 = rng.randomInt(1,5)
	local rngcharacter2 = rng.randomInt(1,5)
	local rngcharacter3 = rng.randomInt(1,5)
	local rngcharacter4 = rng.randomInt(1,5)
	local rngcharacter5 = rng.randomInt(1,5)
	local rngcharacter6 = rng.randomInt(1,5)
	local poweruprng1 = rng.randomInt(1,7)
	local poweruprng2 = rng.randomInt(1,7)
	local poweruprng3 = rng.randomInt(1,7)
	local poweruprng4 = rng.randomInt(1,7)
	local poweruprng5 = rng.randomInt(1,7)
	local poweruprng6 = rng.randomInt(1,7)
	Player(1):transform(rngcharacter1, false)
	Player(2):transform(rngcharacter2, false)
	Player(3):transform(rngcharacter3, false)
	Player(4):transform(rngcharacter4, false)
	Player(5):transform(rngcharacter5, false)
	Player(6):transform(rngcharacter6, false)
	Player(1).powerup = poweruprng1
	Player(2).powerup = poweruprng2
	Player(3).powerup = poweruprng3
	Player(4).powerup = poweruprng4
	Player(5).powerup = poweruprng5
	Player(6).powerup = poweruprng6
	intromodeactivated = true
end

function checkLivingIndex() --Code to check the isAnyPlayerAlive() code.
	for k,p in ipairs(Player.get()) do
		if p.deathTimer == 0 and p:mem(0x13C, FIELD_BOOL) == false then
			return p.idx
		end
	end
end

function isAnyPlayerAlive() --Returns if any player is still alive.
	if checkLivingIndex() ~= nil then
		return true
	else
		return false
	end
end

function isPlayerUnderwater() --Returns true if the first player is underwater.
	return player:mem(0x36, FIELD_BOOL)
end

function isPlayerGrabbing() --Returns true if the first player is grabbing something.
	if player:mem(0x26, FIELD_WORD) >= 1 then
		return true
	elseif player:mem(0x26, FIELD_WORD) == 0 then
		return false
	end
end

function player2Active()
	if Player(2) and Player(2).isValid then
		return true
	else
		return false
	end
end

function activateStarman()
	if(starman) then
		for k,p in ipairs(Player.get()) do
			starman.start(p)
		end
	end
end

function activateMegashroom()
	for k,p in ipairs(Player.get()) do
		if(megashroom) then
			if(not player.isMega) then
				megashroom.StartMega(p, 996)
			else
				megashroom.StopMega(p)
			end
		end
	end
end

-----------------
--NPC functions
-----------------

function harmAllNPCs(npc,...) -- npc:harm but it harms all NPCs with a specified HARM_TYPE
    local oldKilled     = npc:mem(0x122,FIELD_WORD)
    local oldProjectile = npc:mem(0x136,FIELD_BOOL)
    local oldHitCount   = npc:mem(0x148,FIELD_FLOAT)
    local oldImmune     = npc:mem(0x156,FIELD_WORD)
    local oldID         = npc.id
    local oldSpeedX     = npc.speedX
    local oldSpeedY     = npc.speedY

    npc:harm(...)

    return (
           oldKilled     ~= npc:mem(0x122,FIELD_WORD)
        or oldProjectile ~= npc:mem(0x136,FIELD_BOOL)
        or oldHitCount   ~= npc:mem(0x148,FIELD_FLOAT)
        or oldImmune     ~= npc:mem(0x156,FIELD_WORD)
        or oldID         ~= npc.id
        or oldSpeedX     ~= npc.speedX
        or oldSpeedY     ~= npc.speedY
    )
end

function harmSpecificNPC(npcid,...) -- npc:harm but it harms all of a specific NPC and not everything with a specified HARM_TYPE
	if npcid == nil then
		return
	end
	for k,v in ipairs(NPC.get(npcid)) do
		local oldKilled     = v:mem(0x122,FIELD_WORD)
		local oldProjectile = v:mem(0x136,FIELD_BOOL)
		local oldHitCount   = v:mem(0x148,FIELD_FLOAT)
		local oldImmune     = v:mem(0x156,FIELD_WORD)
		local oldID         = v.id
		local oldSpeedX     = v.speedX
		local oldSpeedY     = v.speedY

		v:harm(...)

		return (
			   oldKilled     ~= v:mem(0x122,FIELD_WORD)
			or oldProjectile ~= v:mem(0x136,FIELD_BOOL)
			or oldHitCount   ~= v:mem(0x148,FIELD_FLOAT)
			or oldImmune     ~= v:mem(0x156,FIELD_WORD)
			or oldID         ~= v.id
			or oldSpeedX     ~= v.speedX
			or oldSpeedY     ~= v.speedY
		)
	end
end

-------------------
--Misc. functions
-------------------

function listCustomCameraTargets() --Lists the targets currently being used for customCamera.
	return customCamera.listTargets()
end

function getEpisodeFilename() --Gets the episode filename. If in editor made, it just returns it's in the Editor. Thanks KBM_Quine!
	if not Misc.inEditor then
		local episodeFiles = Misc.listFiles(Misc.episodePath())
		local worldFile
		for _,v in ipairs(episodeFiles) do
			if string.match(v, ".*%.wld") then
				worldFile = string.match(v, ".*%.wld")
			end
		end
		return worldFile
	else
		return "Editor Mode"
	end
end

function isExtraSoundsActive()
	return extrasounds.active
end

function listUserFiles(path)
	if path == nil then
		return Misc.listFiles(Misc.episodePath().."___MainUserDirectory/")
	else
		return Misc.listFiles(Misc.episodePath().."___MainUserDirectory/"..path)
	end
end

function toggleVerboseMode() --This, when activated, will spit out a verbose list of things you have done/executed. Toggle again to turn off.
	if smasverbosemode.activated == true then
		smasverbosemode.activated = false
	elseif smasverbosemode.activated == false then
		smasverbosemode.activated = true
	end
end

function toggleWindowOnly() --This, when fullscreen, will only toggle a window instead of being in fullscreen. Toggle again to turn off.
	if mem(0x00B250D8, FIELD_BOOL) == true then
		return mem(0x00B250D8, FIELD_BOOL, false)
	elseif mem(0x00B250D8, FIELD_BOOL) == false then
		return mem(0x00B250D8, FIELD_BOOL, true)
	end
end

function doPSwitchUntimed(bool)
	if bool == nil then
		return
	end
	if bool == true then
		Misc.doPSwitchRaw(true)
		muteMusic(-1)
		changeMusic("_OST/P-Switch (v2).ogg", -1)
	elseif bool == false then
		Misc.doPSwitchRaw(false)
		restoreMusic(-1)
	end
end

function rngTrueValue(argument) --Thanks Seija!
	math.randomseed(os.time())
	if argument == "y" then
		return rng.randomInt(1,10)
	end
end

function saveSaveSlot(slot)
	Misc.saveSlot(slot)
	Misc.saveGame()
end

function moveSaveSlot(slot, destination)
	if slot == nil then
		error("You must specify a moving save slot.")
	end
	if destination == nil then
		error("You must specify a target save slot.")
	end
	local filename = "save"..slot.."-ext.dat"
	local filenamesav = "save"..slot..".sav"
	local filename2 = "save"..destination.."-ext.dat"
	local filename2sav = "save"..destination..".sav"
	local f = io.open(Misc.episodePath()..filename, "a+")
	local f2 = io.open(Misc.episodePath()..filename2, "w")
	local f3 = io.open(Misc.episodePath()..filenamesav, "a+")
	local f4 = io.open(Misc.episodePath()..filename2sav, "w")
	if f then
		f:read("*all")
		if f2 then
			f2:write("*all")
			f2:close()
		end
	end
	if f3 then
		f3:read("*all")
		if f4 then
			f4:write("*all")
			f4:close()
		end
	end
	Misc.saveSlot(destination)
	eraseSaveSlot(slot)
	Misc.saveGame()
end

function eraseMainSaveSlot(slot) --This only erases the main save in the save slot.
	local f = io.open(Misc.episodePath().."save"..slot..".sav","w")
	if f == nil then
		return
	end

	f:write('64\n3\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n#FALSE#\n"next"\n"next"\n"next"\n"next"\n0\n')
	f:close()
end

function eraseSaveSlot(slot) --This erases all the save data in a specific slot.
	local f = io.open(Misc.episodePath().."save"..slot..".sav","w")
	if f == nil then
		return
	end

	f:write('64\n3\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n#FALSE#\n"next"\n"next"\n"next"\n"next"\n0\n')
	f:close()
	
	local f2 = io.open(Misc.episodePath().."save"..slot.."-ext.dat","w")
	if f2 == nil then
		return
	end

	f2:write('{ \r--[1]-- \r{ \r   ["__costumes"]={2}, \r   ["__launcher"]={3}, \r   ["_basegame"]={4} \r}, \r--[2]-- \r{ \r \r}, \r--[3]-- \r{ \r \r}, \r--[4]-- \r{ \r   ["bigSwitch"]={5}, \r   ["_characterdata"]={6}, \r   ["starcoin"]={7}, \r   ["hud"]={8}, \r   ["starcoinCounter"]=0 \r}, \r--[5]-- \r{ \r \r}, \r--[6]-- \r{ \r   ["8"]={9}, \r   ["10"]={10}, \r   ["9"]={11}, \r   ["6"]={12}, \r   ["16"]={13}, \r   ["11"]={14}, \r   ["12"]={15}, \r   ["7"]={16}, \r   ["15"]={17}, \r   ["13"]={18}, \r   ["14"]={19} \r}, \r--[7]-- \r{ \r \r}, \r--[8]-- \r{ \r   ["score"]=0 \r}, \r--[9]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[10]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[11]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[12]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[13]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[14]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[15]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[16]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[17]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[18]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[19]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[20]-- \r{ \r   ["maxID"]=0, \r   ["alive"]={21} \r}, \r--[21]-- \r{ \r \r} \r}')
	f2:close()
end

function getLegacyStarsCollected() --This is for the Demo 3 save migration tool which runs when stars were collected from Demo 2 and below. This will be scrapped by the time Demo 4 releases (And/or the full release happens).
    local t = {}
    for i=1, mem(0x00B251E0, FIELD_WORD) do
        t[i] = {filename = mem(GM_STAR_ADDR+(i - 1)*0x08+0x00, FIELD_STRING), index = mem(GM_STAR_ADDR+(i - 1)*0x08+0x04, FIELD_WORD)}
    end
    return t
end

function getLegacyStarsCollectedNameOnly() --This is for the Demo 3 save migration tool which runs when stars were collected from Demo 2 and below. This will be scrapped by the time Demo 4 releases (And/or the full release happens).
    local t = {}
    for i=1, mem(0x00B251E0, FIELD_WORD) do
        t[i] = mem(GM_STAR_ADDR+(i - 1)*0x08+0x00, FIELD_STRING)
    end
    return t
end

return smasfunctions