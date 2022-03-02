local function anyValidFields() --This is to prevent any player2 errors while switching btween 1/2 player modes. If it's still not working then paste what's below into data/scripts/base/darkness.lua at line 854 and save. Hopefully this'll be fixed in the next patch, along with the teleporting issue
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

if os then --This is to erase saves when selecting erase save under the boot menu
	local nativeOS = os
	local newOS = {}
	newOS.clock = nativeOS.clock
	newOS.date = nativeOS.date
	newOS.time = nativeOS.time
	newOS.difftime = nativeOS.difftime
	newOS.remove = nativeOS.remove
	newOS.rename = nativeOS.rename
	newOS.exit = function() error("Shutdown") end
	
	os = newOS
	_G.os = newOS
end

local classicevents = require("classiceventsmod")
local globalgenerals = require("globalgenerals")

loadingsoundFile = Misc.resolveSoundFile("_OST/All Stars Menu/Loading Screen.ogg")

function onLoad()
	if not Misc.inEditor() and (Level.filename() == "SMAS - Start.lvlx") == false then --If luna errors during testing, this will be useful to not load the audio to prevent the audio from still being played until terminated
		loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
		loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
		fadetolevel = true
	end
end

function onTick()
	local currentCostume = player:getCostume()
	if currentCostume == "SMB3-WALUIGI" then
		Player.setCostume(10, nil)
	end
end