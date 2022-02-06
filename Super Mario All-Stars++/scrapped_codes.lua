--Scrapped LunaLua codes

--Music change for each character--

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

function onStart()
local character = player.character;
if (character == CHARACTER_LINK) then
	Audio.MusicChange(section0, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.7")
	end
if (character == CHARACTER_LINK) then
	Audio.MusicChange(section1, "_OST/Legend of Zelda - A Link to the Past/14 Lost Ancient Ruins.spc|0;g=2.7")
	end
if (character == CHARACTER_MEGAMAN) then
	Audio.MusicChange(section0, "_OST/Mega Man 10 - OST.nsf|7;g=2.1")
	end
if (character == CHARACTER_MEGAMAN) then
	Audio.MusicChange(section1, "_OST/Mega Man 10 - OST.nsf|8;g=2.1")
	end
if (character == CHARACTER_SAMUS) then
	Audio.MusicChange(section0, "_OST/Metroid - Zero Mission/Brinstar Theme.ogg")
	end
if (character == CHARACTER_SAMUS) then
	Audio.MusicChange(section1, "_OST/Super Metroid/91 Crateria Underground.spc|0;g=2.7")
	end
if (character == CHARACTER_YOSHI) then
	Audio.MusicChange(section0, "_OST/Super Mario World 2 - Yoshi's Island/114 Overworld.spc|0;g=2.7")
	end
if (character == CHARACTER_YOSHI) then
	Audio.MusicChange(section1, "_OST/Super Mario World 2 - Yoshi's Island/109 Underground.spc|0;g=2.7")
	end
if (character == CHARACTER_NINJABOMBERMAN) then
	Audio.MusicChange(section0, "_OST/Bomberman - OST.nsf|3;g=2.1")
	end
if (character == CHARACTER_NINJABOMBERMAN) then
	Audio.MusicChange(section1, "_OST/Bomberman - OST.nsf|2;g=2.1")
	end
end

--1-4

--Copy these, they'll be important for changing music throughout characters
local section0 = 0
local section1 = 1
local section2 = 2
local section3 = 3
local section4 = 4

local bowser = "Boss Start"

function onStart()
local character = player.character;
if (character == CHARACTER_LINK) then
	Audio.MusicChange(section0, "_OST/Legend of Zelda - A Link to the Past/23 Dungeon of Shadows.spc|0;g=2.7")
	end
if (character == CHARACTER_LINK) then
	Audio.MusicChange(section1, "_OST/Legend of Zelda - A Link to the Past/03 Seal of Seven Maidens.spc|0;g=2.7")
	end
if (character == CHARACTER_MEGAMAN) then
	Audio.MusicChange(section0, "_OST/Mega Man 10 - OST.nsf|14;g=2.1")
	end
if (character == CHARACTER_MEGAMAN) then
	Audio.MusicChange(section1, "_OST/Mega Man 2 - OST.nsf|14;g=2.1")
	end
if (character == CHARACTER_SAMUS) then
	Audio.MusicChange(section0, "_OST/Super Metroid/22 Escape.spc|0;g=2.7")
	end
if (character == CHARACTER_SAMUS) then
	Audio.MusicChange(section1, "_OST/Super Metroid/19 Chozo Statue Awakens.spc|0;g=2.7")
	end
if (character == CHARACTER_YOSHI) then
	Audio.MusicChange(section0, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.7")
	end
if (character == CHARACTER_YOSHI) then
	Audio.MusicChange(section1, "_OST/Super Mario World 2 - Yoshi's Island/111 Kamek's Theme.spc|0;g=2.7")
	end
if (character == CHARACTER_NINJABOMBERMAN) then
	Audio.MusicChange(section0, "_OST/Bomberman GB - OST.gbs|8;g=2.1")
	end
if (character == CHARACTER_NINJABOMBERMAN) then
	Audio.MusicChange(section1, "_OST/Bomberman - OST.nsf|3;g=2.1")
	end
end

function onEvent(bowser)
local character = player.character;
if (character == CHARACTER_MARIO) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_LUIGI) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_PEACH) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_TOAD) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_LINK) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Legend of Zelda - A Link to the Past/28 The Prince of Darkness.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_MEGAMAN) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Mega Man 10 - OST.nsf|12;g=2.1")
		end
	end
if (character == CHARACTER_WARIO) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_BOWSER) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_SAMUS) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Metroid/15 Big Boss Confrontation 2.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_YOSHI) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario World 2 - Yoshi's Island/118b Big Boss (No Intro).spc|0;g=2.7")
		end
	end
if (character == CHARACTER_NINJABOMBERMAN) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Bomberman GB - OST.gbs|9;g=2.1")
		end
	end
if (character == CHARACTER_ROSALINA) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_ZELDA) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_ULTIMATERINKA) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
if (character == CHARACTER_UNCLEBROADSWORD) then
	if triggerEvent == "Boss Start" then
		Audio.MusicChange("_OST/Super Mario Bros/Bowser.spc|0;g=2.7")
		end
	end
end