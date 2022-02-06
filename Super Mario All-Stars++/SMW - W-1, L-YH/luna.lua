local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

--Copy these, they'll be important for changing music throughout characters
local section0 = 0
local section1 = 1
local section2 = 2
local section3 = 3
local section4 = 4
local section5 = 5
local section6 = 6
local section7 = 7
local section8 = 8
local section9 = 9
local section10 = 10
local section11 = 11
local section12 = 12
local section13 = 13
local section14 = 14
local section15 = 15
local section16 = 16
local section17 = 17
local section18 = 18
local section19 = 19
local section20 = 20

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/SMWOverworld.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.7")
	end
	if currentCostume == "11-SMA1" then
		Audio.MusicChange(0, "_OST/Super Mario Advance 2/Overworld.ogg")
	end
	if currentCostume == "12-SMA2" then
		Audio.MusicChange(0, "_OST/Super Mario Advance 2/Overworld.ogg")
	end
	if currentCostume == "13-SMA4" then
		Audio.MusicChange(0, "_OST/Super Mario Advance 2/Overworld.ogg")
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		Audio.MusicChange(0, "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.7")
	end
end