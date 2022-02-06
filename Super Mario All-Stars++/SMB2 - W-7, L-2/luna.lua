local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

--Copy these, they'll be important for changing music throughout rooms. Not copying these WILL throw an "overload" error
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
	
	--STARTS WITH 2 SINCE THIS IS SMB2 7-2
	
	if currentCostume == nil then
		Audio.MusicChange(2, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(3, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(4, "_OST/Super Metroid/97 Continue.spc|0;g=2.7")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
	end
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/Town.ogg")
		Audio.MusicChange(3, "_OST/Super Mario All-Stars++ (Beta)/Town.ogg")
		Audio.MusicChange(4, "_OST/Super Mario All-Stars++ (Beta)/Subcon.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|18;g=2")
		Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|18;g=2")
		Audio.MusicChange(4, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(5, "_OST/Super Mario Bros (NES)/Volcano.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros (NES)/Volcano.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros (NES)/Volcano.ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros (NES)/Volcano.ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros (NES)/Volcano.ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros (NES)/Volcano.ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros (NES)/Volcano.ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros (NES)/Volcano.ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros (NES)/Volcano.ogg")
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		Audio.MusicChange(2, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(3, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(4, "_OST/Super Metroid/97 Continue.spc|0;g=2.7")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
	end
	if currentCostume == "3-SMB1-SMAS" then
		Audio.MusicChange(2, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(3, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(4, "_OST/Super Metroid/97 Continue.spc|0;g=2.7")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
	end
	if currentCostume == "4-SMB2-RETRO" then
		Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES)/File Clear.ogg")
		Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES)/File Clear.ogg")
		Audio.MusicChange(4, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
	end
	if currentCostume == "5-SMB2-SMAS" then
		Audio.MusicChange(2, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(3, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(4, "_OST/Super Metroid/97 Continue.spc|0;g=2.7")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
	end
	if currentCostume == "6-SMB3-RETRO" then
		Audio.MusicChange(2, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(3, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(4, "_OST/Super Metroid/97 Continue.spc|0;g=2.7")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/126 Ending (part 1).spc|0;g=2.5")
		Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/126 Ending (part 1).spc|0;g=2.5")
		Audio.MusicChange(4, "_OST/Super Mario World 2 - Yoshi's Island/117 Room Before Boss.spc|0;g=2.1")
		Audio.MusicChange(5, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
		Audio.MusicChange(6, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
		Audio.MusicChange(9, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
		Audio.MusicChange(10, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
		Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
		Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
	end
	if currentCostume == "11-SMA1" then
		Audio.MusicChange(2, "_OST/Super Mario Advance/Ending.ogg") --changing later
		Audio.MusicChange(3, "_OST/Super Mario Advance/Ending.ogg") --changing later
		Audio.MusicChange(4, "_OST/Metroid - Zero Mission/Save Room.ogg")
		Audio.MusicChange(5, "_OST/Super Mario Advance/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Advance/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Advance/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Advance/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Advance/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Advance/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Advance/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Advance/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Advance/Castle (Phase 3).ogg")
	end
	if currentCostume == "11-SMA2" then
		Audio.MusicChange(2, "_OST/Super Mario Advance/Ending.ogg") --changing later
		Audio.MusicChange(3, "_OST/Super Mario Advance/Ending.ogg") --changing later
		Audio.MusicChange(4, "_OST/Metroid - Zero Mission/Save Room.ogg")
		Audio.MusicChange(5, "_OST/Super Mario Advance/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Advance/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Advance/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Advance/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Advance/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Advance/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Advance/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Advance/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Advance/Castle (Phase 3).ogg")
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		Audio.MusicChange(2, "_OST/New Super Mario Bros. DS/Chilling in Heaven.ogg") --changing later
		Audio.MusicChange(3, "_OST/New Super Mario Bros. DS/Chilling in Heaven.ogg") --changing later
		Audio.MusicChange(4, "_OST/New Super Mario Bros. DS/Flowing Lava.ogg")
		Audio.MusicChange(5, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(6, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(7, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(8, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(9, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(10, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(11, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		Audio.MusicChange(2, "_OST/New Super Mario Bros. DS/Chilling in Heaven.ogg") --changing later
		Audio.MusicChange(3, "_OST/New Super Mario Bros. DS/Chilling in Heaven.ogg") --changing later
		Audio.MusicChange(4, "_OST/New Super Mario Bros. DS/Flowing Lava.ogg")
		Audio.MusicChange(5, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(6, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(7, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(8, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(9, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(10, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(11, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
		Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Castle Theme.ogg")
	end
	if currentCostume == "A2XT-DEMO" then
		Audio.MusicChange(2, "_OST/Adventures of Demo/Grassy Overworld.spc|0;g=2.7")
		Audio.MusicChange(3, "_OST/Adventures of Demo/Grassy Overworld.spc|0;g=2.7")
		Audio.MusicChange(4, "_OST/Adventures of Demo/MelancholicMarch.spc|0;g=2.7")
		Audio.MusicChange(5, "_OST/Adventures of Demo/snipers.it")
		Audio.MusicChange(6, "_OST/Adventures of Demo/snipers.it")
		Audio.MusicChange(7, "_OST/Adventures of Demo/snipers.it")
		Audio.MusicChange(8, "_OST/Adventures of Demo/snipers.it")
		Audio.MusicChange(9, "_OST/Adventures of Demo/snipers.it")
		Audio.MusicChange(10, "_OST/Adventures of Demo/snipers.it")
		Audio.MusicChange(11, "_OST/Adventures of Demo/snipers.it")
		Audio.MusicChange(12, "_OST/Adventures of Demo/snipers.it")
		Audio.MusicChange(13, "_OST/Adventures of Demo/snipers.it")
	end
	if currentCostume == "MODERN" then
		Audio.MusicChange(2, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(3, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(4, "_OST/Super Metroid/97 Continue.spc|0;g=2.7")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
	end
	if currentCostume == "PRINCESSRESCUE" then
		Audio.MusicChange(2, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(3, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(4, "_OST/Super Metroid/97 Continue.spc|0;g=2.7")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
	end
	if currentCostume == "SMW-MARIO" then
		Audio.MusicChange(2, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(3, "_OST/Doki Doki Panic/File Clear.spc|0;g=2.7")
		Audio.MusicChange(4, "_OST/Super Metroid/97 Continue.spc|0;g=2.7")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2/Castle.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2/Castle (Item Room).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(9, "_OST/Super Mario Bros 2/Castle (Phase 2).ogg")
		Audio.MusicChange(10, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Castle (Phase 3).ogg")
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		Audio.MusicChange(2, "_OST/South Park (N64)/Banjo Barnyard.ogg")
		Audio.MusicChange(3, "_OST/South Park (N64)/Banjo Barnyard.ogg")
		Audio.MusicChange(4, "_OST/South Park (N64)/Caves Of South Park.ogg")
		Audio.MusicChange(5, "_OST/South Park (N64)/Mad Robots.ogg")
		Audio.MusicChange(6, "_OST/South Park (N64)/Mad Robots.ogg")
		Audio.MusicChange(7, "_OST/South Park (N64)/Mad Robots.ogg")
		Audio.MusicChange(8, "_OST/South Park (N64)/Mad Robots.ogg")
		Audio.MusicChange(9, "_OST/South Park (N64)/Mad Robots.ogg")
		Audio.MusicChange(10, "_OST/South Park (N64)/Mad Robots.ogg")
		Audio.MusicChange(11, "_OST/South Park (N64)/Mad Robots.ogg")
		Audio.MusicChange(12, "_OST/South Park (N64)/Mad Robots.ogg")
		Audio.MusicChange(13, "_OST/South Park (N64)/Mad Robots.ogg")
	end
end

function onEvent(eventName)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if eventName == "CostChangeMusic" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
	end
	if eventName == "BossBegin" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
	end
	
	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario All Stars++ (Beta)/Wart.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|10;g=2")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/117 Room Before Boss.spc|0;g=2.4")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Before Boss.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Before Boss.ogg")
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5")
		end
	end
	if currentCostume == "MODERN" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario All Stars++ (Beta)/Wart.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|10;g=2")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/118b Big Boss (No Intro).spc|0;g=2.3")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/King Wart.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/King Wart.ogg")
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Castle Boss.ogg")
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Castle Boss.ogg")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/snipers.it")
		end
	end
	if currentCostume == "MODERN" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/South Park (N64)/South Park Boss Encounter.ogg")
		end
	end
end