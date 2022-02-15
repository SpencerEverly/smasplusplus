local level_dependencies_normal = require("level_dependencies_hub")

local playermanager = require("playerManager")

local stars = mem(0x00B251E0, FIELD_WORD)

local littleDialogue = require("littleDialogue")

local HUDimage = Graphics.loadImage("MALC-HUD.png")

local playerManager = require("playerManager")

local areaNames = require("areaNames")

local textplus = require("textplus")

local hour = os.date("%H")

local day = os.date("%d")

local month = os.date("%m")

local exacttime = os.date("%X")

local minute = os.date("%M")

local second = os.date("%S")

local infobooth1 = textplus.loadFont("littleDialogue/font/smb3-c.ini")


littleDialogue.registerStyle("endingtextone",{
	openSpeed = 1,
	pageScrollSpeed = 1, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 1, -- How fast it scrolls when switching answer pages.

	windowingOpeningEffectEnabled = true,

	typewriterEnabled = false,
    showTextWhileOpening = false,

	closeSoundEnabled = false,
	continueArrowEnabled = false,
	scrollArrowEnabled   = false,
	selectorImageEnabled = false,
})

areaNames.sectionNames = {
	[0] = "Me and Larry City (Main City)",
	[1] = "Building 3: ???",
	[2] = "Building 2: Hotel",
	[3] = "Building 4: Town Hall",
	[4] = "Building 1: Tourist Center",
	[5] = "Building 5: The True Ending",
	[6] = "Me and Larry City (Side Quest Area 1)",
	[7] = "Building 6: Plumber Area",
	[8] = "Hotel: Floors 1-5",
	[9] = "Information Booth",
	[10] = "Me and Larry City (Side Quest Area 2 & Ocean)",
	[11] = "Me and Larry City (Warp Zone)",
	[12] = "Character Switch Room",
	[13] = "Character Testing Area",
}

function onStart()
	Audio.MusicVolume(nil)
	if stars >= 4 then
		triggerEvent("Stage0.5")
	end
	if stars >= 10 then
		triggerEvent("Stage1")
	end
	if stars >= 16 then
		triggerEvent("Stage2")
	end
	if stars >= 22 then
		triggerEvent("Stage3")
	end
	if stars >= 28 then
		triggerEvent("Stage4")
	end
	if stars >= 32 then
		triggerEvent("Stage5")
	end
	if stars >= 38 then
		triggerEvent("Stage6")
	end
	--if stars >= 100 then
	--	triggerEvent("StageGenoside")
	--end
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumes
	if character == "CHARACTER_MARIO" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
	end
	if character == "CHARACTER_LUIGI" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if character == "CHARACTER_PEACH" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
	end
	if character == "CHARACTER_TOAD" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
	end
	if character == "CHARACTER_LINK" then
		Audio.MusicChange(1, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(3, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(11, "_OST/Legend of Zelda - A Link to the Past/05a Majestic Castle.spc|0;g=2.5")
		Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
	end
	if character == "CHARACTER_WARIO" then
		Audio.MusicChange(1, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(2, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(3, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(7, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(8, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(11, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(12, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
		Audio.MusicChange(13, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
	end
	if character == "CHARACTER_YOSHI" then
		Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
	end
	if character == "CHARACTER_BOWSER" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(2, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(3, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(7, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(8, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(11, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
	end
	if character == "CHARACTER_NINJABOMBERMAN" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
		Audio.MusicChange(13, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
	end
	if character == "CHARACTER_MEGAMAN" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
		Audio.MusicChange(13, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
	end
	if character == "CHARACTER_ZELDA" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
	end
	if character == "CHARACTER_ROSALINA" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if character == "CHARACTER_SAMUS" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Metroid - Zero Mission/Brinstar.ogg")
		Audio.MusicChange(13, "_OST/Metroid - Zero Mission/Brinstar.ogg")
	end
	if character == "CHARACTER_UNCLEBROADSWORD" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if character == "CHARACTER_ULTIMATERINKA" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
end

function onDraw()
	Graphics.drawImageWP(HUDimage, 0, 0, 4)
	
	if player.section == 9 then
		textplus.print{x=-19760, y=-20272, text = "Floor 1: Star List", priority=-86, color=Color.white, sceneCoords=true, font=infobooth1}
		textplus.print{x=-19808, y=-20656, text = "Floor 2: General Info", priority=-86, color=Color.white, sceneCoords=true, font=infobooth1}
		textplus.print{x=-19776, y=-21104, text = "Floor 3: Other Info", priority=-86, color=Color.white, sceneCoords=true, font=infobooth1}
	end
end

function onTick()
	if hour == "00" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg")
	end
	if hour == "01" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg")
	end
	if hour == "02" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg")
	end
	if hour == "03" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg")
	end
	if hour == "04" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg")
	end
	if hour == "05" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg")
	end
	if hour == "06" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg")
	end
	if hour == "07" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg")
	end
	if hour == "08" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg")
	end
	if hour == "09" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg")
	end
	if hour == "10" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg")
	end
	if hour == "11" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg")
	end
	if hour == "12" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg")
	end
	if hour == "13" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg")
	end
	if hour == "14" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg")
	end
	if hour == "15" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg")
	end
	if hour == "16" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg")
	end
	if hour == "17" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg")
	end
	if hour == "18" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg")
	end
	if hour == "19" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg")
	end
	if hour == "20" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg")
	end
	if hour == "21" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg")
	end
	if hour == "22" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg")
	end
	if hour == "23" then
		Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg")
		Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg")
		Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg")
	end
	if month == "04" and day == "04" then
		Audio.MusicChange(0, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(1, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(2, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(3, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(4, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(5, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(6, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(7, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(8, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(9, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(10, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(11, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(12, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		Audio.MusicChange(13, "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg")
		triggerEvent("SEDay")
	end
	if month == "12" and day == "25" then
		Section(0).getWeatherEffect(2)
		Section(6).getWeatherEffect(2)
		Section(10).getWeatherEffect(2)
		Audio.MusicChange(0, "_OST/GoAnimate/Old Songs/We Wish You a Merry Christmas (Jazz Classic).mp3")
		Audio.MusicChange(1, "_OST/GoAnimate/Old Songs/Jingle Bells (1).mp3")
		Audio.MusicChange(2, "_OST/GoAnimate/Old Songs/Jingle Bells (1).mp3")
		Audio.MusicChange(3, "_OST/GoAnimate/Old Songs/Jingle Bells (1).mp3")
		Audio.MusicChange(4, "_OST/GoAnimate/Old Songs/God Rest Ye Merry Gentlemen (hip-hop gangsta).mp3")
		Audio.MusicChange(5, "_OST/GoAnimate/Old Songs/We Wish You a Merry Christmas (Jazz Classic).mp3")
		Audio.MusicChange(6, "_OST/GoAnimate/Old Songs/We Wish You a Merry Christmas (Jazz Classic).mp3")
		Audio.MusicChange(7, "_OST/GoAnimate/Old Songs/Deck the Halls (Jazz Classic).mp3")
		Audio.MusicChange(8, "_OST/GoAnimate/Old Songs/Deck the Halls (Jazz Classic).mp3")
		Audio.MusicChange(9, "_OST/GoAnimate/Old Songs/God Rest Ye Merry Gentlemen (hip-hop gangsta).mp3")
		Audio.MusicChange(10, "_OST/GoAnimate/Old Songs/We Wish You a Merry Christmas (Jazz Classic).mp3")
		Audio.MusicChange(11, "_OST/GoAnimate/Old Songs/God Rest Ye Merry Gentlemen (hip-hop gangsta).mp3")
		Audio.MusicChange(12, "_OST/GoAnimate/Old Songs/God Rest Ye Merry Gentlemen (hip-hop gangsta).mp3")
		Audio.MusicChange(13, "_OST/GoAnimate/Old Songs/God Rest Ye Merry Gentlemen (hip-hop gangsta).mp3")
		triggerEvent("Christmas")
	end
	if month == "04" and day == "20" then
		Audio.MusicChange(0, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(1, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(2, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(3, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(4, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(5, "__OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(6, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(7, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(8, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(9, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(10, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(11, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(12, "_OST/All Stars Secrets/smok wed everyda.ogg")
		Audio.MusicChange(13, "_OST/All Stars Secrets/smok wed everyda.ogg")
		triggerEvent("Weed")
	end
	if SaveData.disableX2char == nil then
        SaveData.disableX2char = SaveData.disableX2char or 0
    end
	if SaveData.disableX2char == 0 then
		triggerEvent("ShowX2Stuff")
	end
	if SaveData.disableX2char == 1 then
		triggerEvent("HideX2Stuff")
		Player.setCostume(1, nil)
		Player.setCostume(2, nil)
		Player.setCostume(3, nil)
		Player.setCostume(4, nil)
		Player.setCostume(5, nil)
	end
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumes
	if player.section == 9 then
		Text.printWP("Welcome to the information booth.", 10, 577, 5)
	end





	--CHARACTER_MARIO
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
		Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
		Audio.MusicChange(3, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
		Audio.MusicChange(7, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
		Audio.MusicChange(8, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
		Audio.MusicChange(11, "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg")
		Audio.MusicChange(12, "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg")
		Audio.MusicChange(13, "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(1, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(7, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(8, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(11, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		Audio.MusicChange(12, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		Audio.MusicChange(13, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "3-SMB1-SMAS" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "4-SMB2-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
	end
	if currentCostume == "5-SMB2-SMAS" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "6-SMB3-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(7, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(8, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(11, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2")
		Audio.MusicChange(12, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
		Audio.MusicChange(13, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
	end
	if currentCostume == "9-SMW-PIRATE" then
		Audio.MusicChange(1, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
		Audio.MusicChange(2, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
		Audio.MusicChange(3, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
		Audio.MusicChange(7, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
		Audio.MusicChange(8, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
		Audio.MusicChange(11, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2")
		Audio.MusicChange(12, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2")
		Audio.MusicChange(13, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2")
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 7).spc|0;g=2.0")
		Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
		Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
		Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
		Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 3).spc|0;g=2.0")
		Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
		Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
		Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
	end
	if currentCostume == "11-SMA1" then
		Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Advance/Choose A Player.ogg")
		Audio.MusicChange(12, "_OST/Super Mario Advance/Choose A Player.ogg")
		Audio.MusicChange(13, "_OST/Super Mario Advance/Choose A Player.ogg")
	end
	if currentCostume == "12-SMA2" then
		Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Advance 2/Choose A Game.ogg")
		Audio.MusicChange(12, "_OST/Super Mario Advance 2/Choose A Game.ogg")
		Audio.MusicChange(13, "_OST/Super Mario Advance 2/Choose A Game.ogg")
	end
	if currentCostume == "13-SMA4" then
		Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Advance 4/Choose A Game!.ogg")
		Audio.MusicChange(12, "_OST/Super Mario Advance 4/Choose A Game!.ogg")
		Audio.MusicChange(13, "_OST/Super Mario Advance 4/Choose A Game!.ogg")
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
		Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Toad House.ogg")
		Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Toad House.ogg")
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
		Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Toad House.ogg")
		Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Toad House.ogg")
	end
	if currentCostume == "A2XT-DEMO" then
		Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
	end
	if currentCostume == "GOOMBA" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "DEMO-XMASPILY" then
		Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
	end
	if currentCostume == "GOLDENMARIO" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "MODERN" then
		Audio.MusicChange(1, "_OST/Modern Mario/SMB2 - Character Select.ogg")
		Audio.MusicChange(2, "_OST/Modern Mario/SMB2 - Character Select.ogg")
		Audio.MusicChange(3, "_OST/Modern Mario/SMB2 - Character Select.ogg")
		Audio.MusicChange(7, "_OST/Modern Mario/SMB2 - Character Select.ogg")
		Audio.MusicChange(8, "_OST/Modern Mario/SMB2 - Character Select.ogg")
		Audio.MusicChange(11, "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg")
		Audio.MusicChange(12, "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg")
		Audio.MusicChange(13, "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg")
	end
	if currentCostume == "PRINCESSRESCUE" then
		Audio.MusicChange(1, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(2, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(3, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(7, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(8, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(11, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(12, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(13, "_OST/Princess Rescue/Overworld.ogg")
	end
	if currentCostume == "SMG4" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg")
		Audio.MusicChange(12, "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg")
		Audio.MusicChange(13, "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg")
	end
	if currentCostume == "SMW-MARIO" then
		Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
		Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
		Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
		Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
		Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
		Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.3")
		Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.3")
		Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.3")
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		Audio.MusicChange(1, "_OST/South Park (N64)/Insane Toys.ogg")
		Audio.MusicChange(2, "_OST/South Park (N64)/Insane Toys.ogg")
		Audio.MusicChange(3, "_OST/South Park (N64)/Insane Toys.ogg")
		Audio.MusicChange(7, "_OST/South Park (N64)/Insane Toys.ogg")
		Audio.MusicChange(8, "_OST/South Park (N64)/Insane Toys.ogg")
		Audio.MusicChange(11, "_OST/South Park (N64)/Banjo Barnyard.ogg")
		Audio.MusicChange(12, "_OST/South Park (N64)/Banjo Barnyard.ogg")
		Audio.MusicChange(13, "_OST/South Park (N64)/Banjo Barnyard.ogg")
	end
	if currentCostume == "BOBTHETOMATO" then
		Audio.MusicChange(1, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(2, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(3, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(7, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(8, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(11, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(12, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(13, "_OST/VeggieTales/Theme Song.ogg")
	end
	if currentCostume == "GA-CAILLOU" then
		Audio.MusicChange(1, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
		Audio.MusicChange(2, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
		Audio.MusicChange(3, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
		Audio.MusicChange(7, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
		Audio.MusicChange(8, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
		Audio.MusicChange(11, "_OST/GoAnimate/Very Old Songs/GoAnimate Jingle by the Anime Master.mp3")
		Audio.MusicChange(12, "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3")
		Audio.MusicChange(13, "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3")
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		Audio.MusicChange(1, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(3, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(11, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(12, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
	end
	if currentCostume == "SMB0" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 0/Shop.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Bros 0/Shop.ogg")
		Audio.MusicChange(3, "_OST/Super Mario Bros 0/Shop.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Bros 0/Shop.ogg")
		Audio.MusicChange(8, "_OST/Super Mario Bros 0/Shop.ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros 0/Intro.ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros 0/Intro.ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros 0/Intro.ogg")
	end
	if currentCostume == "MARINK" then
		Audio.MusicChange(1, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
		Audio.MusicChange(2, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
		Audio.MusicChange(3, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
		Audio.MusicChange(7, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
		Audio.MusicChange(8, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
		Audio.MusicChange(11, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.8")
		Audio.MusicChange(12, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.8")
		Audio.MusicChange(13, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.8")
	end
	
	
	
	
	
	
	
	
	
	--CHARACTER_LUIGI
	if currentCostume == "0-SPENCEREVERLY" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Super Mario Bros Spencer/Overworld.ogg")
		Audio.MusicChange(12, "_OST/Super Mario Bros Spencer/Athletic.ogg")
		Audio.MusicChange(13, "_OST/Super Mario Bros Spencer/Athletic.ogg")
	end
	if currentCostume == "3-SMB1-RETRO-MODERN" then
		Audio.MusicChange(1, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(7, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(8, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(11, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		Audio.MusicChange(12, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		Audio.MusicChange(13, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
	end
	if currentCostume == "4-SMB1-SMAS" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "5-SMB2-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
	end
	if currentCostume == "6-SMB2-SMAS" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "7-SMB3-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(7, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(8, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(11, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2")
		Audio.MusicChange(12, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
		Audio.MusicChange(13, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "10-SMW-ORIGINAL" then
		Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
	end
	if currentCostume == "13-SMBDX" then
		Audio.MusicChange(1, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
		Audio.MusicChange(3, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
		Audio.MusicChange(7, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
		Audio.MusicChange(8, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
		Audio.MusicChange(11, "_OST/Super Mario Bros Deluxe.gbs|18;g=2")
		Audio.MusicChange(12, "_OST/Super Mario Bros Deluxe.gbs|11;g=2")
		Audio.MusicChange(13, "_OST/Super Mario Bros Deluxe.gbs|11;g=2")
	end
	if currentCostume == "15-SMA2" then
		Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
		Audio.MusicChange(11, "_OST/Super Mario Advance 2/Choose A Game.ogg")
		Audio.MusicChange(12, "_OST/Super Mario Advance 2/Choose A Game.ogg")
		Audio.MusicChange(13, "_OST/Super Mario Advance 2/Choose A Game.ogg")
	end
	if currentCostume == "17-NSMBDS-SMBX" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "__OST/New Super Mario Bros. DS/Walking the Plains.ogg")
		Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Toad House.ogg")
		Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Toad House.ogg")
	end
	if currentCostume == "A2XT-IRIS" then
		Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		Audio.MusicChange(1, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(2, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(3, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(7, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(8, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(11, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(12, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(13, "_OST/VeggieTales/Theme Song.ogg")
	end
	if currentCostume == "SMW-LUIGI" then
		Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
		Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
	end
	if currentCostume == "UNDERTALE-FRISK" then
		Audio.MusicChange(1, "_OST/Undertale/mus_town.ogg")
		Audio.MusicChange(2, "_OST/Undertale/mus_town.ogg")
		Audio.MusicChange(3, "_OST/Undertale/mus_town.ogg")
		Audio.MusicChange(7, "_OST/Undertale/mus_town.ogg")
		Audio.MusicChange(8, "_OST/Undertale/mus_town.ogg")
		Audio.MusicChange(11, "_OST/Undertale/mus_dogshrine_1.ogg")
		Audio.MusicChange(12, "_OST/Undertale/mus_zz_megalovania.ogg")
		Audio.MusicChange(13, "_OST/Undertale/mus_zz_megalovania.ogg")
	end
	if currentCostume == "WALUIGI" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	
	
	
	
	
	
	
	
	
	
	--CHARACTER_PEACH
	
	
	
	
	
	
	
	
	
	
	--CHARACTER_TOAD
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(1, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(7, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(8, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(11, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		Audio.MusicChange(12, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		Audio.MusicChange(13, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
	end
	if currentCostume == "2-SMB1-SMAS" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "3-SMB2-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
	end
	if currentCostume == "4-SMB2-RETRO-YELLOW" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
	end
	if currentCostume == "5-SMB2-RETRO-RED" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
		Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
	end
	if currentCostume == "6-SMB3-BLUE" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "7-SMB3-YELLOW" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "A2XT-RAOCOW" then
		Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
		Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
	end
	if currentCostume == "SEE-TANGENT" then
		Audio.MusicChange(1, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_INTERIOR.ogg")
		Audio.MusicChange(2, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_HOTEL.ogg")
		Audio.MusicChange(3, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_INTERIOR.ogg")
		Audio.MusicChange(7, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_KENNEL_2.ogg")
		Audio.MusicChange(8, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_HOTEL.ogg")
		Audio.MusicChange(11, "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg")
		Audio.MusicChange(12, "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg")
		Audio.MusicChange(13, "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg")
	end
	if currentCostume == "SONIC" then
		Audio.MusicChange(1, "_OST/Sonic Mania/MainMenu.ogg")
		Audio.MusicChange(2, "_OST/Sonic Mania/MainMenu.ogg")
		Audio.MusicChange(3, "_OST/Sonic Mania/MainMenu.ogg")
		Audio.MusicChange(7, "_OST/Sonic Mania/MainMenu.ogg")
		Audio.MusicChange(8, "_OST/Sonic Mania/MainMenu.ogg")
		Audio.MusicChange(11, "_OST/Sonic Mania/SaveSelect.ogg")
		Audio.MusicChange(12, "_OST/Sonic Mania/SaveSelect.ogg")
		Audio.MusicChange(13, "_OST/Sonic Mania/SaveSelect.ogg")
	end
	if currentCostume == "TOADETTE" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if currentCostume == "YOSHI-SMB3" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	
	
	
	
	
	
	
	
	
	
	
	--CHARACTER_LINK
	if currentCostume == "NESS" then
		Audio.MusicChange(1, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
		Audio.MusicChange(2, "_OST/EarthBound/024 Enjoy Your Stay.spc|0;g=2.3")
		Audio.MusicChange(3, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
		Audio.MusicChange(7, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
		Audio.MusicChange(8, "_OST/EarthBound/024 Enjoy Your Stay.spc|0;g=2.3")
		Audio.MusicChange(11, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
		Audio.MusicChange(12, "_OST/EarthBound/019b Onett Theme.spc|0;g=2.3")
		Audio.MusicChange(13, "_OST/EarthBound/019b Onett Theme.spc|0;g=2.3")
	end
	if currentCostume == "SEE-SHERBERTLUSSIEBACK" then
		Audio.MusicChange(1, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
	end
	if currentCostume == "TAKESHI" then
		Audio.MusicChange(1, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		Audio.MusicChange(2, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		Audio.MusicChange(3, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		Audio.MusicChange(7, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		Audio.MusicChange(8, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		Audio.MusicChange(11, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		Audio.MusicChange(12, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		Audio.MusicChange(13, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
	end
	if currentCostume == "TAKESHI-SNES" then
		Audio.MusicChange(1, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		Audio.MusicChange(2, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		Audio.MusicChange(3, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		Audio.MusicChange(7, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		Audio.MusicChange(8, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		Audio.MusicChange(11, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		Audio.MusicChange(12, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		Audio.MusicChange(13, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
	end
	
	
	
	
	
	--CHARACTER_STEVE (ULTIMATE_RINKA)
	if currentCostume == "DJCTRE-CUBIXTRON" then
		Audio.MusicChange(1, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(2, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(3, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(7, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(8, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(11, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(12, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(13, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
	end
	if currentCostume == "DJCTRE-CUBIXTRONDAD" then
		Audio.MusicChange(1, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(2, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(3, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(7, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(8, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(11, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(12, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(13, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
	end
	if currentCostume == "DJCTRE-STULTUS" then
		Audio.MusicChange(1, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(2, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(3, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(7, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(8, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(11, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(12, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		Audio.MusicChange(13, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
	end
	if currentCostume == "DLC-FESTIVE-CHRISTMASTREE" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "EXPLODINGTNT" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "GEORGENOTFOUNDYT" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "KARLJACOBSYT" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-ALEX" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-CAPTAINTOAD" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-FNF-BOYFRIEND" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-FNF-GIRLFRIEND" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-FRISK" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-HEROBRINE" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-IMPOSTOR" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-ITSJERRY" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-ITSHARRY" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-KERALIS" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-KRIS" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-MARIO" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-NOELLE-DELTARUNE" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-NOTCH" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-PATRICK" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-RALSEI" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-RILEY" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-SONIC" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-SPIDERMAN" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-SPONGEBOB" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-SQUIDWARD" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-SUSIE-DELTARUNE" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-TAILS" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "MC-ZOMBIE" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "QUACKITYYT" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if currentCostume == "SEE-MC-EVILME" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-GERANIUM" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-LEWBERTLUSSIEBACK" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-LILIJUCIEBACK" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-MIMIJUCIEBACK" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-RONDAVIS" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-SHENICLE" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-SHELLEYKIRK" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-SHERBERTLUSSIEBACK" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-SPENCER2" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-SPENCEREVERLY" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "SEE-MC-TIANELY" then
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
	end
	if currentCostume == "TOMMYINNITYT" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	
	
	
	
	--CHARACTER_YOSHI (KLONOA)
	if currentCostume == "SMA3" then
		Audio.MusicChange(1, "_OST/Super Mario Advance 3/Overworld.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Advance 3/Overworld.ogg")
		Audio.MusicChange(3, "_OST/Super Mario Advance 3/Overworld.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Advance 3/Overworld.ogg")
		Audio.MusicChange(8, "_OST/Super Mario Advance 3/Overworld.ogg")
		Audio.MusicChange(11, "_OST/Super Mario Advance 3/Flower Garden.ogg")
		Audio.MusicChange(12, "_OST/Super Mario Advance 3/Training Course.ogg")
		Audio.MusicChange(13, "_OST/Super Mario Advance 3/Training Course.ogg")
	end
	
	
	
	
	
	
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_MARIO) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_LUIGI) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_PEACH) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_TOAD) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_LINK) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_MEGAMAN) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_WARIO) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_BOWSER) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_NINJABOMBERMAN) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_ROSALINA) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_ZELDA) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_ULTIMATERINKA) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_UNCLEBROADSWORD) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_SAMUS) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_YOSHI) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
	if SaveData.disableX2char == 0 then
		if (character == CHARACTER_SNAKE) then
			triggerEvent("PreventYIGlitchOthers")
		end
	end
end

function onEvent(eventName)
	if eventName == "SideQuestWarpOpen" then
		SFX.play(27)
	end
	if eventName == "DLCWarpOpen" then
		SFX.play(27)
	end
	if eventName == "StarList" then
		littleDialogue.create({text = "<boxStyle infobooth>OUR RECORDS SHOW THAT YOU HAVE AT LEAST "..stars.." STARS IN YOUR GAME PROGRESSION.<page>THE STARS YOU HAVE COLLECTED IN THE MANDATORY LEVELS IS (number). THE STARS YOU HAVE COLLECTED IN ALL OTHER LEVELS IS (tbd).<page>THE STAR COUNT OF EVERY STAR YOU COLLECTED OVERALL IS "..SaveData.starsgrabbed..".<page>TO FINISH YOUR GAME AND UNLOCK THE TRUE ENDING, YOU'LL NEED TO COLLECT (starcounttbd) MORE.<page>THANKS FOR PROCESSING THE INFORMATION I HAVE EXPLAINED. GOOD DAY."})
	end
	if eventName == "GeneralList" then
		littleDialogue.create({text = "<boxStyle infobooth>OUR RECORDS SHOW THAT YOU HAVE GOT "..SaveData.GameOverCount.." GAME OVERS IN YOUR GAME PROGRESSION.<page>YOU ALSO HAVE RECENTLY WENT IN (number) LEVELS.<page>THE SCORE COUNT IS "..Misc.score().." AND THE COIN COUNT IS "..Misc.coins()..".<page>YOU HAVE ALSO STOMPED ON "..SaveData.goombaStomps.." GOOMBAS, AND "..SaveData.koopaStomps.." KOOPA TROOPAS.<page>THE TOTAL AMOUNT OF COINS COLLECTED OVERALL IS "..SaveData.totalcoins..".<page>OVERALL, YOU HAVE USED "..SaveData.totalmushrooms.." MUSHROOMS, "..SaveData.totalfireflowers.." FIRE FLOWERS, "..SaveData.totalleafs.." SUPER LEAFS, "..SaveData.totaltanookis.." TANOOKI SUITS, "..SaveData.totalhammersuits.." HAMMER SUITS, AND "..SaveData.totaliceflowers.." ICE FLOWERS.<page>YOU ALSO GRABBED "..SaveData.starsgrabbed.." TOTAL STARS REGARDLESS OF COMPLETION OR NOT, USED "..SaveData.starmansused.." STARMANS, "..SaveData.megamushroomssused.." MEGA MUSHROOMS,<page>AND I HOPE YOU'VE HAD A FUN TIME.<page>THANKS FOR PROCESSING THE INFORMATION I HAVE EXPLAINED. GOOD DAY."})
	end
	if eventName == "OtherList" then
		littleDialogue.create({text = "<boxStyle infobooth>OUR RECORDS SHOW THAT YOU HAVE GOT TO WAIT UNTIL THIS LIST WORKS.<page>THIS PART OF THE INFORMATION BOOTH WILL TELL YOU OTHER THINGS NOT RELATED TO ANYTHING.<page>COME BACK WHEN THE FULL EPISODE IS RELEASED. THANK YOU FOR YOUR TIME."})
	end
	if eventName == "Stage5" then
		Audio.MusicChange(4, "_OST/Me and Larry City/Story Mode Hub Theme 3, With Building Sounds (Super Mario Maker 2).ogg")
	end
	if eventName == "Stage6" then
		Audio.MusicChange(4, "_OST/Me and Larry City/Story Mode Hub Theme 3, With Building Sounds (Super Mario Maker 2).ogg")
	end
	if eventName == "MarioChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
	end
	if eventName == "LuigiChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if eventName == "PeachChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
	end
	if eventName == "ToadChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
	end
	if eventName == "LinkChar" then
		Audio.MusicChange(0, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(1, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(3, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(6, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(10, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(11, "_OST/Legend of Zelda - A Link to the Past/05a Majestic Castle.spc|0;g=2.5")
		Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
	end
	if eventName == "WarioChar" then
		Audio.MusicChange(0, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(1, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(2, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(3, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(6, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(7, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(8, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(10, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(11, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(12, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
		Audio.MusicChange(13, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
	end
	if eventName == "BowserChar" then
		Audio.MusicChange(0, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(1, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(2, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(3, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(6, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(7, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(8, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(10, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(11, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
	end
	if eventName == "BombChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
		Audio.MusicChange(13, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
	end
	if eventName == "MegaChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
		Audio.MusicChange(13, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
	end
	if eventName == "ZeldaChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
	end
	if eventName == "RosaChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if eventName == "SamusChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Metroid - Zero Mission/Brinstar.ogg")
		Audio.MusicChange(13, "_OST/Metroid - Zero Mission/Brinstar.ogg")
	end
	if eventName == "UncleChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if eventName == "RinkaChar" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if eventName == "SnakeChar" then
		Audio.MusicChange(1, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(2, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(3, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(7, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(8, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(11, "_OST/Metal Gear - OST.nsf|7;g=2")
		Audio.MusicChange(12, "_OST/Metal Gear - OST.nsf|6;g=2")
		Audio.MusicChange(13, "_OST/Metal Gear - OST.nsf|6;g=2")
	end
	if eventName == "YoshiChar" then
		Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
	end
	if eventName == "KlonoaChar" then
		Audio.MusicChange(1, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(2, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(3, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(7, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(8, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(11, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Threer.ogg")
		Audio.MusicChange(11, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Threer.ogg")
		Audio.MusicChange(13, "_OST/Klonoa (Wii)/217 - Hiroshi Okubo - The Ring.ogg")
	end
	if eventName == "StageGenoside" then
		Audio.MusicChange(0, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(4, "_OST/Me and Larry City/Story Mode Hub Theme 3, Genoside (Super Mario Maker 2).ogg")
		Audio.MusicChange(5, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(6, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(9, "_OST/Undertale/mus_chara.ogg")
		Audio.MusicChange(10, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(11, "_OST/Undertale/mus_chara.ogg")
		Audio.MusicChange(12, "_OST/Undertale/mus_chara.ogg")
		Audio.MusicChange(13, "_OST/Undertale/mus_chara.ogg")
	end
	if eventName == ("DisEnabledX2Char") then
		if SaveData.disableX2char == 0 then
			triggerEvent("HUBDisableX2")
			Level.load(Level.filename())
		end
		if SaveData.disableX2char == 1 then
			triggerEvent("HUBEnableX2")
			Level.load(Level.filename())
		end
	end
	if eventName == "HUBEnableX2" then
		SaveData.disableX2char = SaveData.disableX2char - 1
	end
	if eventName == "HUBDisableX2" then
		SaveData.disableX2char = SaveData.disableX2char + 1
	end
	if eventName == "HourChange" then
		SFX.play("hour-change.ogg")
		if hour == "00" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg")
		end
		if hour == "01" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg")
		end
		if hour == "02" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg")
		end
		if hour == "03" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg")
		end
		if hour == "04" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg")
		end
		if hour == "05" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg")
		end
		if hour == "06" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg")
		end
		if hour == "07" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg")
		end
		if hour == "08" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg")
		end
		if hour == "09" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg")
		end
		if hour == "10" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg")
		end
		if hour == "11" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg")
		end
		if hour == "12" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg")
		end
		if hour == "13" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg")
		end
		if hour == "14" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg")
		end
		if hour == "15" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg")
		end
		if hour == "16" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg")
		end
		if hour == "17" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg")
		end
		if hour == "18" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg")
		end
		if hour == "19" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg")
		end
		if hour == "20" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg")
		end
		if hour == "21" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg")
		end
		if hour == "22" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg")
		end
		if hour == "23" and minute == "00" and second == "00" then
			Audio.MusicChange(0, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg")
			Audio.MusicChange(6, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg")
			Audio.MusicChange(10, "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg")
		end
	end
end

-- Register questions


littleDialogue.registerAnswer("favgame1",{text = "Super Mario All-Stars Plus Plus",addText = "This must be the best game then, isn't it? I love it too!"})
littleDialogue.registerAnswer("favgame1",{text = "EarthBound",addText = "Is that the Trading Company or something? That name isn't familiar. Oh well..."})
littleDialogue.registerAnswer("favgame1",{text = "Sonic the Hedgehog",addText = "Heh, such a hedgehog! I really like Sonic Mania! It's the best."})
littleDialogue.registerAnswer("favgame1",{text = "Super Mario 64",addText = "Hey, that's what I played! I forgot what it was called. Thank for reminding me!"})
littleDialogue.registerAnswer("favgame1",{text = "Have you even played a video game before?",addText = "Yes, I think it had this one objective to collect stars, but I don't know what it was called..."})
littleDialogue.registerAnswer("favgame1",{text = "Aren't we all in a video game?",addText = "...really? You must be that hero that's splitting facts or something!"})





littleDialogue.registerAnswer("strike1",{text = "No thanks",addText = "I hate you, you stupid hero!"})
littleDialogue.registerAnswer("strike1",{text = "Sure",addText = "That's one signature ahead of our goal! Thanks, hero!"})





littleDialogue.registerAnswer("mayoradvice",{text = "My name is wrong (Or something isn't right).",addText = "If you're name is wrong, don't direct it to me! Direct it to Spencer Everly. They'll fix the issue on the next update.<page>Spencer should be able to reach you on Discord at Spencer Everly#1997.<page>Or use their email at spencer.everly@gmail.com.<page>Reporting bugs makes the player experience a lot better if you do these things!"})
littleDialogue.registerAnswer("mayoradvice",{text = "Give me advice.",addText = "Sure thing! Here is what you need to know:"})
littleDialogue.registerAnswer("mayoradvice",{text = "Why is everyone orange guns?",addText = "Because Spencer Everly was a dumb kid who made this species. I don't have anything else to say."})
littleDialogue.registerAnswer("mayoradvice",{text = "Is life even good anymore?",addText = "If you feel suicidal, call 1-800-273-8255.<page>I can't see another life taken away from me, and NOT right here."})
littleDialogue.registerAnswer("mayoradvice",{text = "Where am I?",addText = "You're in Mars, in the biggest city of the planet, Me and Larry City.<page>Filled with tall buildings and many areas, us Mearians roam through life trying to live and survive like any other human does.<page>Where did we come from? Why are we here? Why can't we live with humans in peace?<page>Nobody knows..."})
littleDialogue.registerAnswer("mayoradvice",{text = "Nevermind.",addText = "Gotcha. Let me know if you need anything."})





littleDialogue.registerAnswer("mayoradvicehigh",{text = "My name is wrong (Or something isn't right).",addText = "Do a... email...<page>spencer.everly@outloo... uh, yahoo... uh...<page>No... it's gmail.com... yeah.<page>Email that."})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Give me advice.",addText = "Advise 1: I want more weed.<page>Advise 2: Then give me more weed.<page>Advise 3: Uh... I forgot, what again?"})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Why is everyone orange guns?",addText = "Because tomatoes talk in... a show... I forgot."})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Is life even good anymore?",addText = "Call 1-800-273-8255.<page>It's a number... weed, ack!"})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Where am I?",addText = "You... are in some planet...<page>Gee, I forgot where I even am... stupid weed..."})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Nevermind.",addText = "Ah okay..."})





littleDialogue.registerAnswer("semoviefav",{text = "Super Mario All-Stars Plus Plus",addText = "That's not a movie, that's a game you dolt!"})
littleDialogue.registerAnswer("semoviefav",{text = "Caillou Gets Grounded: The Movie",addText = "Are you deranged or something? I hated those killing scenes!"})
littleDialogue.registerAnswer("semoviefav",{text = "Beverly Hills ChihWALL-E",addText = "And we're married! ...that movie is weird."})
littleDialogue.registerAnswer("semoviefav",{text = "Caillou Gets Grounded 2: The Revenge",addText = "Massive improvement, not gonna lie...<page>Some stuff felt... off though. But that's just me."})
littleDialogue.registerAnswer("semoviefav",{text = "The Spencer! The Show! Endgame",addText = "I really liked that one! It shows how much Spencer has improved."})
littleDialogue.registerAnswer("semoviefav",{text = "Spencer! The Movie! FOR REAL",addText = "I heard that Spencer regret making that movie. I don't know why, but they do."})





littleDialogue.registerAnswer("dumbhigh1",{text = "Your face.",addText = "I didn't know I had a face... I'm seeing colors..."})
littleDialogue.registerAnswer("dumbhigh1",{text = "Your butt.",addText = "Good answer... hahahahaha!!!!!"})
littleDialogue.registerAnswer("dumbhigh1",{text = "You ask someone something for an answer.",addText = "That's... wrong!!!!!! it's my PET SHOP Hoi!<page>I'm so high right now........"})




littleDialogue.registerAnswer("YesNoX2Char",{text = "Yes, sure.",chosenFunction = function() triggerEvent("DisEnabledX2Char") end})
littleDialogue.registerAnswer("YesNoX2Char",{text = "No thanks.",addText = "Gotcha. Hit the block again if you want to choose next time!"})



littleDialogue.registerAnswer("strangerQuestion",{text = "Uh...",addText = "What? Are you afraid imma KILL YA? <question strangerQuestionTwo>"})
littleDialogue.registerAnswer("strangerQuestion",{text = "No thanks.",addText = "You ASKED for it!! HAHAHAHA!",chosenFunction = function() player:kill() SFX.play("_OST/_Sound Effects/evil-laugh.ogg") end})



littleDialogue.registerAnswer("strangerQuestionTwo",{text = "Nonononono!",addText = "Huh... well imma kill someone else now, bye!"})
littleDialogue.registerAnswer("strangerQuestionTwo",{text = "YES!",addText = "Well today's your LUCKY DAY!!!! HAHAHAHA!",chosenFunction = function() player:kill() SFX.play("_OST/_Sound Effects/evil-laugh.ogg") end})



littleDialogue.registerAnswer("starcountinfo",{text = "Sure",chosenFunction = function() triggerEvent("StarList") end})
littleDialogue.registerAnswer("starcountinfo",{text = "No thanks",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("generalcountinfo",{text = "Sure",chosenFunction = function() triggerEvent("GeneralList") end})
littleDialogue.registerAnswer("generalcountinfo",{text = "No thanks",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("othercountinfo",{text = "Sure",chosenFunction = function() triggerEvent("OtherList") end})
littleDialogue.registerAnswer("othercountinfo",{text = "No thanks",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("malcbeginmsg",{text = "Warp me to the Side Quest Levels",addText = "PROCESS ACCEPTED. ENTER THE PIPE TO MEET YOUR SATISFACTION.",chosenFunction = function() triggerEvent("SideQuestWarpOpen") end})
littleDialogue.registerAnswer("malcbeginmsg",{text = "Warp me to the DLC World",addText = "PROCESS ACCEPTED. ENTER THE PIPE TO MEET YOUR SATISFACTION.",chosenFunction = function() triggerEvent("DLCWarpOpen") end})
littleDialogue.registerAnswer("malcbeginmsg",{text = "Nevermind",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})