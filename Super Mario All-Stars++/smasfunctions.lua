local smasfunctions = {}

local extrasounds = require("extrasounds")

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

function lifeCount()
	if SaveData.totalLives == nil then
		return 0
	else
		return SaveData.totalLives
	end
end

function manageLives(lives, mathcount, maxlives) --arg1 = number of lives, arg2 = to add (true) or subtract them (false), maxout = whenever to max out all the lives to 999..optional
	if lives == nil then
		error("You need to specify the number of lives.")
	end
	if mathcount == nil then
		error("You need to specify whenever to add (true) or subtract (false) the life count.")
	end
	if maxlives == nil then
		maxlives = false
	end
	if not mathcount and not maxlives then
		SaveData.totalLives = SaveData.totalLives - lives
	elseif mathcount and not maxlives then
		SaveData.totalLives = SaveData.totalLives + lives
	elseif not mathcount and maxlives then
		SaveData.totalLives = 999
	elseif mathcount and maxlives then
		SaveData.totalLives = 999
	end
end

function starCount()
	if SaveData.totalStarCount == nil then
		return 0
	else
		return SaveData.totalStarCount
	end
end

function manageStars(arg1, arg2, clearcount) --arg1 = Number of stars, arg2 = To add or subtract them, arg3 = Whenever to clear everything that holds info regarding where stars were collected or not, and it's star count..optional
	if arg1 == nil then
		error("You need to specify the number of stars.")
	end
	if arg2 == nil then
		error("You need to specify whenever to subtract or add the stars.")
	end
	if cleartable == nil then
		cleartable = false
	end
	if (arg1 ~= nil) and (arg2 ~= nil) then
		stars = arg1
		mathcount = arg2
	else
	end
	if mathcount == subtract and not clearcount then
		SaveData.totalStarCount = SaveData.totalStarCount - stars
	elseif mathcount == add and not clearcount then
		SaveData.totalStarCount = SaveData.totalStarCount + stars
	elseif mathcount == subtract and clearcount then
		return
	elseif mathcount == add and clearcount then
		return
	end
	if clearcount then
		SaveData.totalStarCount = 0
		for k in pairs(SaveData.completeLevels) do
			SaveData.completeLevels[k] = nil
		end
		SaveData.completeLevels = {}
	end
end

function getEpisodeFilename() --Thanks KBM_Quine!
	if not Misc.inEditor then
		return mem(mem(0x00B250FC, FIELD_DWORD)+(mem(0x00B2C628, FIELD_WORD)-1)*0x30+0x08, FIELD_STRING)
	else
		return "Editor Mode"
	end
end

return smasfunctions