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

--MALCmusic costume switching music

        currentCostume = player:getCostume()
        character = player.character
        
        --CHARACTER_MARIO
        if currentCostume == "00-SMASPLUSPLUS-BETA" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg"
            Section(2).musicPath = "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg"
            Section(3).musicPath = "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg"
            Section(7).musicPath = "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg"
            Section(8).musicPath = "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg"
            Section(11).musicPath = "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg"
            Section(12).musicPath = "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg"
            Section(13).musicPath = "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg"
        end
        if currentCostume == "01-SMB1-RETRO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(2).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(3).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(7).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(8).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(11).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2"
            Section(12).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2"
            Section(13).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2"
        end
        if currentCostume == "02-SMB1-RECOLORED" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "03-SMB1-SMAS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "04-SMB2-RETRO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(2).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(3).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(7).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(8).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(11).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(12).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(13).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
        end
        if currentCostume == "05-SMB2-SMAS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "06-SMB3-RETRO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(2).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(3).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(7).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(8).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(11).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2"
            Section(12).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2"
            Section(13).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2"
        end
        if currentCostume == "07-SML2" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Land 2 - OST.gbs|5;g=2"
            Section(2).musicPath = "_OST/Super Mario Land 2 - OST.gbs|5;g=2"
            Section(3).musicPath = "_OST/Super Mario Land 2 - OST.gbs|5;g=2"
            Section(7).musicPath = "_OST/Super Mario Land 2 - OST.gbs|5;g=2"
            Section(8).musicPath = "_OST/Super Mario Land 2 - OST.gbs|5;g=2"
            Section(11).musicPath = "_OST/Super Mario Land 2 - OST.gbs|4;g=2"
            Section(12).musicPath = "_OST/Super Mario Land 2 - OST.gbs|0;g=2"
            Section(13).musicPath = "_OST/Super Mario Land 2 - OST.gbs|0;g=2"
        end
        if currentCostume == "09-SMW-PIRATE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2"
            Section(2).musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2"
            Section(3).musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2"
            Section(7).musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2"
            Section(8).musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2"
            Section(11).musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2"
            Section(12).musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2"
            Section(13).musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2"
        end
        if currentCostume == "Z-SMW2-ADULTMARIO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 7).spc|0;g=2.0"
            Section(2).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0"
            Section(3).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0"
            Section(7).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0"
            Section(8).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 3).spc|0;g=2.0"
            Section(11).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7"
            Section(12).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7"
            Section(13).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7"
        end
        if currentCostume == "11-SMA1" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(2).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(3).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(7).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(8).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(11).musicPath = "_OST/Super Mario Advance/Choose A Player.ogg"
            Section(12).musicPath = "_OST/Super Mario Advance/Choose A Player.ogg"
            Section(13).musicPath = "_OST/Super Mario Advance/Choose A Player.ogg"
        end
        if currentCostume == "12-SMA2" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(2).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(3).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(7).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(8).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(11).musicPath = "_OST/Super Mario Advance 2/Choose A Game.ogg"
            Section(12).musicPath = "_OST/Super Mario Advance 2/Choose A Game.ogg"
            Section(13).musicPath = "_OST/Super Mario Advance 2/Choose A Game.ogg"
        end
        if currentCostume == "13-SMA4" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(2).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(3).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(7).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(8).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(11).musicPath = "_OST/Super Mario Advance 4/Choose A Game!.ogg"
            Section(12).musicPath = "_OST/Super Mario Advance 4/Choose A Game!.ogg"
            Section(13).musicPath = "_OST/Super Mario Advance 4/Choose A Game!.ogg"
        end
        if currentCostume == "14-NSMBDS-SMBX" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
            Section(12).musicPath = "_OST/New Super Mario Bros. DS/Toad House.ogg"
            Section(13).musicPath = "_OST/New Super Mario Bros. DS/Toad House.ogg"
        end
        if currentCostume == "15-NSMBDS-ORIGINAL" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
            Section(12).musicPath = "_OST/New Super Mario Bros. DS/Toad House.ogg"
            Section(13).musicPath = "_OST/New Super Mario Bros. DS/Toad House.ogg"
        end
        if currentCostume == "A2XT-DEMO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(2).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(3).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(7).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(8).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(11).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(12).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(13).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
        end
        if currentCostume == "GOOMBA" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "DEMO-XMASPILY" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(2).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(3).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(7).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(8).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(11).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(12).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(13).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
        end
        if currentCostume == "GOLDENMARIO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "MODERN" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Modern Mario/SMB2 - Character Select.ogg"
            Section(2).musicPath = "_OST/Modern Mario/SMB2 - Character Select.ogg"
            Section(3).musicPath = "_OST/Modern Mario/SMB2 - Character Select.ogg"
            Section(7).musicPath = "_OST/Modern Mario/SMB2 - Character Select.ogg"
            Section(8).musicPath = "_OST/Modern Mario/SMB2 - Character Select.ogg"
            Section(11).musicPath = "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg"
            Section(12).musicPath = "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg"
            Section(13).musicPath = "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg"
        end
        if currentCostume == "PRINCESSRESCUE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Princess Rescue/Overworld.ogg"
            Section(2).musicPath = "_OST/Princess Rescue/Overworld.ogg"
            Section(3).musicPath = "_OST/Princess Rescue/Overworld.ogg"
            Section(7).musicPath = "_OST/Princess Rescue/Overworld.ogg"
            Section(8).musicPath = "_OST/Princess Rescue/Overworld.ogg"
            Section(11).musicPath = "_OST/Princess Rescue/Overworld.ogg"
            Section(12).musicPath = "_OST/Princess Rescue/Overworld.ogg"
            Section(13).musicPath = "_OST/Princess Rescue/Overworld.ogg"
        end
        if currentCostume == "SMBDDX-MARIO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros. DDX/Overworld (Remastered).ogg"
            Section(2).musicPath = "_OST/Super Mario Bros. DDX/Overworld (Remastered).ogg"
            Section(3).musicPath = "_OST/Super Mario Bros. DDX/Overworld (Remastered).ogg"
            Section(7).musicPath = "_OST/Super Mario Bros. DDX/Overworld (Remastered).ogg"
            Section(8).musicPath = "_OST/Super Mario Bros. DDX/Overworld (Remastered).ogg"
            Section(11).musicPath = "_OST/Super Mario Bros. DDX/Overworld (Remastered).ogg"
            Section(12).musicPath = "_OST/Super Mario Bros. DDX/Overworld (Remastered).ogg"
            Section(13).musicPath = "_OST/Super Mario Bros. DDX/Overworld (Remastered).ogg"
        end
        if currentCostume == "SMG4" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg"
            Section(12).musicPath = "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg"
            Section(13).musicPath = "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg"
        end
        if currentCostume == "SMW-MARIO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(2).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(3).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(7).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(8).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(11).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(12).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(13).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
        end
        if currentCostume == "SP-1-ERICCARTMAN" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/South Park (N64)/Insane Toys.ogg"
            Section(2).musicPath = "_OST/South Park (N64)/Insane Toys.ogg"
            Section(3).musicPath = "_OST/South Park (N64)/Insane Toys.ogg"
            Section(7).musicPath = "_OST/South Park (N64)/Insane Toys.ogg"
            Section(8).musicPath = "_OST/South Park (N64)/Insane Toys.ogg"
            Section(11).musicPath = "_OST/South Park (N64)/Banjo Barnyard.ogg"
            Section(12).musicPath = "_OST/South Park (N64)/Banjo Barnyard.ogg"
            Section(13).musicPath = "_OST/South Park (N64)/Banjo Barnyard.ogg"
        end
        if currentCostume == "BOBTHETOMATO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(2).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(3).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(7).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(8).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(11).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(12).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(13).musicPath = "_OST/VeggieTales/Theme Song.ogg"
        end
        if currentCostume == "GA-CAILLOU" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(2).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(3).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(7).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(8).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(11).musicPath = "_OST/GoAnimate/Very Old Songs/GoAnimate Jingle by the Anime Master.mp3"
            Section(12).musicPath = "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3"
            Section(13).musicPath = "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3"
        end
        if currentCostume == "JCFOSTERTAKESITTOTHEMOON" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5"
            Section(2).musicPath = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5"
            Section(3).musicPath = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5"
            Section(7).musicPath = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5"
            Section(8).musicPath = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5"
            Section(11).musicPath = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5"
            Section(12).musicPath = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5"
            Section(13).musicPath = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5"
        end
        if currentCostume == "SMB0" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros 0/Shop.ogg"
            Section(2).musicPath = "_OST/Super Mario Bros 0/Shop.ogg"
            Section(3).musicPath = "_OST/Super Mario Bros 0/Shop.ogg"
            Section(7).musicPath = "_OST/Super Mario Bros 0/Shop.ogg"
            Section(8).musicPath = "_OST/Super Mario Bros 0/Shop.ogg"
            Section(11).musicPath = "_OST/Super Mario Bros 0/Intro.ogg"
            Section(12).musicPath = "_OST/Super Mario Bros 0/Intro.ogg"
            Section(13).musicPath = "_OST/Super Mario Bros 0/Intro.ogg"
        end
        if currentCostume == "SMM2-MARIO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(2).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(3).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(7).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(8).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(11).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(12).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(13).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
        end
        if currentCostume == "MARINK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8"
            Section(2).musicPath = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8"
            Section(3).musicPath = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8"
            Section(7).musicPath = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8"
            Section(8).musicPath = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8"
            Section(11).musicPath = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.8"
            Section(12).musicPath = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.8"
            Section(13).musicPath = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.8"
        end
        if currentCostume == "SPONGEBOBSQUAREPANTS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/SpongeBob Squarepants - Battle for Bikini Bottom (PS2)/MNU5 Spongebob BB 44.ogg"
            Section(2).musicPath = "_OST/SpongeBob Squarepants - Battle for Bikini Bottom (PS2)/MNU5 Spongebob BB 44.ogg"
            Section(3).musicPath = "_OST/SpongeBob Squarepants - Battle for Bikini Bottom (PS2)/MNU5 Spongebob BB 44.ogg"
            Section(7).musicPath = "_OST/SpongeBob Squarepants - Battle for Bikini Bottom (PS2)/MNU5 Spongebob BB 44.ogg"
            Section(8).musicPath = "_OST/SpongeBob Squarepants - Battle for Bikini Bottom (PS2)/MNU5 Spongebob BB 44.ogg"
            Section(11).musicPath = "_OST/SpongeBob Squarepants - Battle for Bikini Bottom (PS2)/MNU5 Spongebob BB 44.ogg"
            Section(12).musicPath = "_OST/SpongeBob Squarepants - Battle for Bikini Bottom (PS2)/MNU5 Spongebob JF 44.ogg"
            Section(13).musicPath = "_OST/SpongeBob Squarepants - Battle for Bikini Bottom (PS2)/MNU5 Spongebob JF 44.ogg"
        end
        
        
        
        
        
        
        
        
        
        --CHARACTER_LUIGI
        if currentCostume == "00-SPENCEREVERLY" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Super Mario Bros Spencer/Overworld.ogg"
            Section(12).musicPath = "_OST/Super Mario Bros Spencer/Athletic.ogg"
            Section(13).musicPath = "_OST/Super Mario Bros Spencer/Athletic.ogg"
        end
        if currentCostume == "03-SMB1-RETRO-MODERN" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(2).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(3).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(7).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(8).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(11).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2"
            Section(12).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2"
            Section(13).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2"
        end
        if currentCostume == "04-SMB1-SMAS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "05-SMB2-RETRO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(2).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(3).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(7).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(8).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(11).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(12).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(13).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
        end
        if currentCostume == "06-SMB2-SMAS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "07-SMB3-RETRO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(2).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(3).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(7).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(8).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
            Section(11).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2"
            Section(12).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2"
            Section(13).musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2"
        end
        if currentCostume == "09-SMB3-MARIOCLOTHES" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "10-SMW-ORIGINAL" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(2).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(3).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(7).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(8).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(11).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(12).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(13).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
        end
        if currentCostume == "13-SMBDX" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros Deluxe.gbs|20;g=2"
            Section(2).musicPath = "_OST/Super Mario Bros Deluxe.gbs|20;g=2"
            Section(3).musicPath = "_OST/Super Mario Bros Deluxe.gbs|20;g=2"
            Section(7).musicPath = "_OST/Super Mario Bros Deluxe.gbs|20;g=2"
            Section(8).musicPath = "_OST/Super Mario Bros Deluxe.gbs|20;g=2"
            Section(11).musicPath = "_OST/Super Mario Bros Deluxe.gbs|18;g=2"
            Section(12).musicPath = "_OST/Super Mario Bros Deluxe.gbs|11;g=2"
            Section(13).musicPath = "_OST/Super Mario Bros Deluxe.gbs|11;g=2"
        end
        if currentCostume == "15-SMA2" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(2).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(3).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(7).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(8).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(11).musicPath = "_OST/Super Mario Advance 2/Choose A Game.ogg"
            Section(12).musicPath = "_OST/Super Mario Advance 2/Choose A Game.ogg"
            Section(13).musicPath = "_OST/Super Mario Advance 2/Choose A Game.ogg"
        end
        if currentCostume == "16-SMA4" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(2).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(3).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(7).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(8).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(11).musicPath = "_OST/Super Mario Advance 4/Choose A Game!.ogg"
            Section(12).musicPath = "_OST/Super Mario Advance 4/Choose A Game!.ogg"
            Section(13).musicPath = "_OST/Super Mario Advance 4/Choose A Game!.ogg"
        end
        if currentCostume == "17-NSMBDS-SMBX" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "__OST/New Super Mario Bros. DS/Walking the Plains.ogg"
            Section(12).musicPath = "_OST/New Super Mario Bros. DS/Toad House.ogg"
            Section(13).musicPath = "_OST/New Super Mario Bros. DS/Toad House.ogg"
        end
        if currentCostume == "A2XT-IRIS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(2).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(3).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(7).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(8).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(11).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(12).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(13).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
        end
        if currentCostume == "LARRYTHECUCUMBER" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(2).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(3).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(7).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(8).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(11).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(12).musicPath = "_OST/VeggieTales/Theme Song.ogg"
            Section(13).musicPath = "_OST/VeggieTales/Theme Song.ogg"
        end
        if currentCostume == "SMM2-LUIGI" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(2).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(3).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(7).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(8).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(11).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(12).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(13).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
        end
        if currentCostume == "SMW1-YOSHI" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "SMW-LUIGI" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(2).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(3).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(7).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(8).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(11).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(12).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(13).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
        end
        if currentCostume == "UNDERTALE-FRISK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Undertale/mus_town.ogg"
            Section(2).musicPath = "_OST/Undertale/mus_town.ogg"
            Section(3).musicPath = "_OST/Undertale/mus_town.ogg"
            Section(7).musicPath = "_OST/Undertale/mus_town.ogg"
            Section(8).musicPath = "_OST/Undertale/mus_town.ogg"
            Section(11).musicPath = "_OST/Undertale/mus_dogshrine_1.ogg"
            Section(12).musicPath = "_OST/Undertale/mus_zz_megalovania.ogg"
            Section(13).musicPath = "_OST/Undertale/mus_zz_megalovania.ogg"
        end
        if currentCostume == "WALUIGI" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "WOHLSTAND" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "GA-BORIS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(2).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(3).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(7).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(8).musicPath = "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3"
            Section(11).musicPath = "_OST/GoAnimate/Very Old Songs/GoAnimate Jingle by the Anime Master.mp3"
            Section(12).musicPath = "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3"
            Section(13).musicPath = "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3"
        end
        
        
        
        
        
        
        
        
        
        
        --CHARACTER_PEACH
        if currentCostume == "02-SMB1-SMAS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "A2XT-KOOD" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(2).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(3).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(7).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(8).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(11).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(12).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(13).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
        end
        if currentCostume == "DAISY" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "KIRBY-SMB3" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(2).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(3).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(7).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(8).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(11).musicPath = "_OST/Kirby Superstar/16 Peanut Plain.spc|0;g=2.7"
            Section(12).musicPath = "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.7"
        end
        if currentCostume == "PAULINE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "SMA4" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(2).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(3).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(7).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(8).musicPath = "_OST/Super Mario Advance/Me and Larry City (GBA).ogg"
            Section(11).musicPath = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
            Section(12).musicPath = "_OST/Super Mario Advance 4/N-Spade Bonus.ogg"
            Section(13).musicPath = "_OST/Super Mario Advance 4/N-Spade Bonus.ogg"
        end
        if currentCostume == "SMW-PEACH" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(2).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(3).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(7).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(8).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(11).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(12).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(13).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
        end
        if currentCostume == "TUX" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Tux Racer/Race 01.mp3"
            Section(2).musicPath = "_OST/Tux Racer/Race 01.mp3"
            Section(3).musicPath = "_OST/Tux Racer/Race 01.mp3"
            Section(7).musicPath = "_OST/Tux Racer/Race 01.mp3"
            Section(8).musicPath = "_OST/Tux Racer/Race 01.mp3"
            Section(11).musicPath = "_OST/Tux Racer/Race 02.mp3"
            Section(12).musicPath = "_OST/Tux Racer/Start Menu.mp3"
            Section(13).musicPath = "_OST/Tux Racer/Start Menu.mp3"
        end
        if currentCostume == "NINJABOMBERMAN" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Bomberman GB - OST.gbs|0;g=1.5"
            Section(13).musicPath = "_OST/Bomberman GB - OST.gbs|0;g=1.5"
        end
        
        
        
        
        
        
        
        
        
        --CHARACTER_TOAD
        if currentCostume == "01-SMB1-RETRO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(2).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(3).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(7).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(8).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2"
            Section(11).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2"
            Section(12).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2"
            Section(13).musicPath = "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2"
        end
        if currentCostume == "02-SMB1-SMAS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "03-SMB2-RETRO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(2).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(3).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(7).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(8).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(11).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(12).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(13).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
        end
        if currentCostume == "04-SMB2-RETRO-YELLOW" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(2).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(3).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(7).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(8).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(11).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(12).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(13).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
        end
        if currentCostume == "05-SMB2-RETRO-RED" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(2).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(3).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(7).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(8).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
            Section(11).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(12).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
            Section(13).musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
        end
        if currentCostume == "06-SMB3-BLUE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "07-SMB3-YELLOW" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "A2XT-RAOCOW" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(2).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(3).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(7).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(8).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(11).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(12).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(13).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
        end
        if currentCostume == "CAPTAINTOAD" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg"
            Section(2).musicPath = "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg"
            Section(3).musicPath = "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg"
            Section(7).musicPath = "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg"
            Section(8).musicPath = "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg"
            Section(11).musicPath = "_OST/Captain Toad - Treasure Tracker (Wii U)/Kp_bgm_Book02.nk.32.dspadpcm.ogg"
            Section(12).musicPath = "_OST/Captain Toad - Treasure Tracker (Wii U)/Kp_bgm_Book01.nk.32.dspadpcm.ogg"
            Section(13).musicPath = "_OST/Captain Toad - Treasure Tracker (Wii U)/Kp_bgm_Book01.nk.32.dspadpcm.ogg"
        end
        if currentCostume == "HAMTARO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg"
            Section(2).musicPath = "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg"
            Section(3).musicPath = "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg"
            Section(7).musicPath = "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg"
            Section(8).musicPath = "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg"
            Section(11).musicPath = "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg"
            Section(12).musicPath = "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg"
            Section(13).musicPath = "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg"
        end
        if currentCostume == "LEGOSTARWARS-REBELTROOPER" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/LEGO Star Wars II - The Original Trilogy (GBA)/Mos Cantine.ogg"
            Section(2).musicPath = "_OST/LEGO Star Wars II - The Original Trilogy (GBA)/Mos Cantine.ogg"
            Section(3).musicPath = "_OST/LEGO Star Wars II - The Original Trilogy (GBA)/Mos Cantine.ogg"
            Section(7).musicPath = "_OST/LEGO Star Wars II - The Original Trilogy (GBA)/Mos Cantine.ogg"
            Section(8).musicPath = "_OST/LEGO Star Wars II - The Original Trilogy (GBA)/Mos Cantine.ogg"
            Section(11).musicPath = "_OST/LEGO Star Wars II - The Original Trilogy (GBA)/Mos Cantine.ogg"
            Section(12).musicPath = "_OST/LEGO Star Wars II - The Original Trilogy (GBA)/Mos Cantine.ogg"
            Section(13).musicPath = "_OST/LEGO Star Wars II - The Original Trilogy (GBA)/Mos Cantine.ogg"
        end
        if currentCostume == "SEE-TANGENT" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Nintendogs + Cats/CFR_BGM_SHOP_INTERIOR.ogg"
            Section(2).musicPath = "_OST/Nintendogs + Cats/CFR_BGM_SHOP_HOTEL.ogg"
            Section(3).musicPath = "_OST/Nintendogs + Cats/CFR_BGM_SHOP_INTERIOR.ogg"
            Section(7).musicPath = "_OST/Nintendogs + Cats/CFR_BGM_SHOP_KENNEL_2.ogg"
            Section(8).musicPath = "_OST/Nintendogs + Cats/CFR_BGM_SHOP_HOTEL.ogg"
            Section(11).musicPath = "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg"
            Section(12).musicPath = "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg"
            Section(13).musicPath = "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg"
        end
        if currentCostume == "SMM2-TOAD" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(2).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(3).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(7).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(8).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(11).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(12).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(13).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
        end
        if currentCostume == "SMM2-TOADETTE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(2).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(3).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(7).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(8).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(11).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(12).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(13).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
        end
        if currentCostume == "SMM2-YELLOWTOAD" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(2).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(3).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(7).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(8).musicPath = "_OST/Super Mario World/Status Screen.spc|0;g=2.6"
            Section(11).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(12).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
            Section(13).musicPath = "_OST/Super Mario World/Choose a Game.spc|0;g=2.6"
        end
        if currentCostume == "SONIC" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Sonic Mania/MainMenu.ogg"
            Section(2).musicPath = "_OST/Sonic Mania/MainMenu.ogg"
            Section(3).musicPath = "_OST/Sonic Mania/MainMenu.ogg"
            Section(7).musicPath = "_OST/Sonic Mania/MainMenu.ogg"
            Section(8).musicPath = "_OST/Sonic Mania/MainMenu.ogg"
            Section(11).musicPath = "_OST/Sonic Mania/SaveSelect.ogg"
            Section(12).musicPath = "_OST/Sonic Mania/SaveSelect.ogg"
            Section(13).musicPath = "_OST/Sonic Mania/SaveSelect.ogg"
        end
        if currentCostume == "TOADETTE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "YOSHI-SMB3" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "JUNI" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "MOTHERBRAINRINKA" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "ULTIMATERINKA" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        
        
        
        
        
        
        
        
        
        
        
        --CHARACTER_LINK
        if currentCostume == "01-ZELDA1-NES" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|3;g=1.5"
            Section(2).musicPath = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|3;g=1.5"
            Section(3).musicPath = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|3;g=1.5"
            Section(7).musicPath = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|3;g=1.5"
            Section(8).musicPath = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|3;g=1.5"
            Section(11).musicPath = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|1;g=1.5"
            Section(12).musicPath = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.5"
            Section(13).musicPath = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.5"
        end
        if currentCostume == "05-LINKWAKE-SNES" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg"
            Section(2).musicPath = "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg"
            Section(3).musicPath = "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg"
            Section(7).musicPath = "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg"
            Section(8).musicPath = "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg"
            Section(11).musicPath = "_OST/Legend of Zelda - Link's Awakening (Switch)/12_StrangeForest.ry.48.dspadpcm.ogg"
            Section(12).musicPath = "_OST/Legend of Zelda - Link's Awakening (Switch)/10_Field_Normal.ry.48.dspadpcm.ogg"
            Section(13).musicPath = "_OST/Legend of Zelda - Link's Awakening (Switch)/10_Field_Normal.ry.48.dspadpcm.ogg"
        end
        if currentCostume == "A2XT-SHEATH" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(2).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(3).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(7).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(8).musicPath = "_OST/Adventures of Demo/bossa-ing_around.s3m"
            Section(11).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(12).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
            Section(13).musicPath = "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0"
        end
        if currentCostume == "NESS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3"
            Section(2).musicPath = "_OST/EarthBound/024 Enjoy Your Stay.spc|0;g=2.3"
            Section(3).musicPath = "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3"
            Section(7).musicPath = "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3"
            Section(8).musicPath = "_OST/EarthBound/024 Enjoy Your Stay.spc|0;g=2.3"
            Section(11).musicPath = "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3"
            Section(12).musicPath = "_OST/EarthBound/019b Onett Theme.spc|0;g=2.3"
            Section(13).musicPath = "_OST/EarthBound/019b Onett Theme.spc|0;g=2.3"
        end
        if currentCostume == "SEE-SHERBERTLUSSIEBACK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg"
        end
        if currentCostume == "SMB1-SNES" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "SMB2-SNES" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "SMB3-BANDANA-DEE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(2).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(3).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(7).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(8).musicPath = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7"
            Section(11).musicPath = "_OST/Kirby Superstar/16 Peanut Plain.spc|0;g=2.7"
            Section(12).musicPath = "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.7"
        end
        if currentCostume == "TAKESHI" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
            Section(2).musicPath = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
            Section(3).musicPath = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
            Section(7).musicPath = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
            Section(8).musicPath = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
            Section(11).musicPath = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
            Section(12).musicPath = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
            Section(13).musicPath = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
        end
        if currentCostume == "TAKESHI-SNES" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
            Section(2).musicPath = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
            Section(3).musicPath = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
            Section(7).musicPath = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
            Section(8).musicPath = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
            Section(11).musicPath = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
            Section(12).musicPath = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
            Section(13).musicPath = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
        end
        
        
        
        
        --CHARACTER_KLONOA
        if currentCostume == "MARINALITEYEARS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "MISCHEIFMAKERS-MARINA" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "SMW2-YOSHI" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 7).spc|0;g=2.0"
            Section(2).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0"
            Section(3).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0"
            Section(7).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0"
            Section(8).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 3).spc|0;g=2.0"
            Section(11).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7"
            Section(12).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7"
            Section(13).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7"
        end
        if currentCostume == "YS-GREEN" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Yoshi's Story/Yoshi's Song.ogg"
            Section(12).musicPath = "_OST/Yoshi's Story/Yoshi's Song.ogg"
            Section(13).musicPath = "_OST/Yoshi's Story/Yoshi's Song.ogg"
        end
        
        
        
        
        
        --CHARACTER_STEVE (ULTIMATE_RINKA)
        if currentCostume == "DJCTRE-CUBIXTRON" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(2).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(3).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(7).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(8).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(11).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(12).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(13).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
        end
        if currentCostume == "DJCTRE-CUBIXTRONDAD" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(2).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(3).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(7).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(8).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(11).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(12).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(13).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
        end
        if currentCostume == "DJCTRE-STULTUS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(2).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(3).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(7).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(8).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(11).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(12).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
            Section(13).musicPath = "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg"
        end
        if currentCostume == "DLC-FESTIVE-CHRISTMASTREE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "ED-EDEDDANDEDDY" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "EXPLODINGTNT" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "GEORGENOTFOUNDYT" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "HANGOUTYOSHIGUYYT" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "KARLJACOBSYT" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "KOOPAPANZER" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-ALEX" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-CAPTAINTOAD" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-FNF-BOYFRIEND" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-FNF-GIRLFRIEND" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-FRISK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-HEROBRINE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-IMPOSTOR" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-ITSJERRY" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-ITSHARRY" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-KERALIS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-KRIS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-MARIO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-NOELLE-DELTARUNE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-NOTCH" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-PATRICK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-RALSEI" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-SONIC" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-SPIDERMAN" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-SPONGEBOB" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-SQUIDWARD" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-SUSIE-DELTARUNE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-TAILS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "MC-ZOMBIE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "QUACKITYYT" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "SEE-MC-EVILME" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-GERANIUM" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-LEWBERTLUSSIEBACK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-LILIJUCIEBACK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-MIMIJUCIEBACK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-RONDAVIS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-SHENICLE" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-SHELLEYKIRK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-SHERBERTLUSSIEBACK" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-SPENCER2" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-SPENCEREVERLY" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "SEE-MC-TIANELY" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(2).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(3).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(7).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(8).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(11).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(12).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
            Section(13).musicPath = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg"
        end
        if currentCostume == "TOMMYINNITYT" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        if currentCostume == "UNOFFICIALSTUDIOSYT" then
            Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
            Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
            Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        end
        
        
        
        
        --CHARACTER_YOSHI (KLONOA)
        if currentCostume == "SMA3" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Super Mario Advance 3/Overworld.ogg"
            Section(2).musicPath = "_OST/Super Mario Advance 3/Overworld.ogg"
            Section(3).musicPath = "_OST/Super Mario Advance 3/Overworld.ogg"
            Section(7).musicPath = "_OST/Super Mario Advance 3/Overworld.ogg"
            Section(8).musicPath = "_OST/Super Mario Advance 3/Overworld.ogg"
            Section(11).musicPath = "_OST/Super Mario Advance 3/Flower Garden.ogg"
            Section(12).musicPath = "_OST/Super Mario Advance 3/Training Course.ogg"
            Section(13).musicPath = "_OST/Super Mario Advance 3/Training Course.ogg"
        end
        
        
        
        
        
        
        
        --CHARACTER_ROSALINA
        if currentCostume == "KING BOO" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "SMB2-SMAS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "UTSUHOREIUJI" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        
        
        
        
        
        
        
        
        --CHARACTER_MEGAMAN
        if currentCostume == "BAD BOX ART MEGA MAN" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "BASS" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "DR. WILY" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "MARISAKIRISAME" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "MEGAMAN-NES" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6"
            Section(2).musicPath = "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6"
            Section(3).musicPath = "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6"
            Section(7).musicPath = "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6"
            Section(8).musicPath = "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6"
            Section(11).musicPath = "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|9;g=1.6"
            Section(12).musicPath = "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|7;g=1.6"
            Section(13).musicPath = "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|7;g=1.6"
        end
        if currentCostume == "PROTOMAN" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "ROLL" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "MEGAMAN-8BITMM" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Mega Man 2 - OST.nsf|3;g=1.4"
            Section(2).musicPath = "_OST/Mega Man 2 - OST.nsf|3;g=1.4"
            Section(3).musicPath = "_OST/Mega Man 2 - OST.nsf|3;g=1.4"
            Section(7).musicPath = "_OST/Mega Man 2 - OST.nsf|3;g=1.4"
            Section(8).musicPath = "_OST/Mega Man 2 - OST.nsf|3;g=1.4"
            Section(11).musicPath = "_OST/Mega Man 2 - OST.nsf|4;g=1.4"
            Section(12).musicPath = "_OST/Mega Man 2 - OST.nsf|6;g=1.4"
            Section(13).musicPath = "_OST/Mega Man 2 - OST.nsf|6;g=1.4"
        end
        if currentCostume == "MEGAMAN-MARISA" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        
        
        
        
        
        
        --CHARACTER_SAMUS
        if currentCostume == "BILLRIZER" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
        if currentCostume == "SAMUS-NES" and malcmusic.holiday == false then
            Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
            Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
            Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
            Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        end
    end
end

function malcmusic.onEvent(eventName)
    if eventName == "MarioChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
        Section(13).musicPath = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
    end
    if eventName == "LuigiChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
        Section(13).musicPath = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
    end
    if eventName == "PeachChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5"
        Section(13).musicPath = "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5"
    end
    if eventName == "ToadChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5"
        Section(13).musicPath = "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5"
    end
    if eventName == "LinkChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5"
        Section(2).musicPath = "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5"
        Section(3).musicPath = "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5"
        Section(7).musicPath = "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5"
        Section(8).musicPath = "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5"
        Section(11).musicPath = "_OST/Legend of Zelda - A Link to the Past/05a Majestic Castle.spc|0;g=2.5"
        Section(12).musicPath = "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5"
        Section(13).musicPath = "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5"
    end
    if eventName == "WarioChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Wario Land 3.gbs|3;g=2"
        Section(2).musicPath = "_OST/Wario Land 3.gbs|3;g=2"
        Section(3).musicPath = "_OST/Wario Land 3.gbs|3;g=2"
        Section(7).musicPath = "_OST/Wario Land 3.gbs|3;g=2"
        Section(8).musicPath = "_OST/Wario Land 3.gbs|3;g=2"
        Section(11).musicPath = "_OST/Wario Land 3.gbs|3;g=2"
        Section(12).musicPath = "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2"
        Section(13).musicPath = "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2"
    end
    if eventName == "BowserChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3"
        Section(2).musicPath = "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3"
        Section(3).musicPath = "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3"
        Section(7).musicPath = "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3"
        Section(8).musicPath = "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3"
        Section(11).musicPath = "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3"
        Section(12).musicPath = "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3"
        Section(13).musicPath = "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3"
    end
    if eventName == "BombChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Bomberman GB - OST.gbs|0;g=1.7"
        Section(13).musicPath = "_OST/Bomberman GB - OST.gbs|0;g=1.7"
    end
    if eventName == "MegaChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Mega Man 10 - OST.nsf|7;g=1.7"
        Section(13).musicPath = "_OST/Mega Man 10 - OST.nsf|7;g=1.7"
    end
    if eventName == "ZeldaChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5"
        Section(13).musicPath = "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5"
    end
    if eventName == "RosaChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
    end
    if eventName == "SamusChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Metroid - Zero Mission/Brinstar.ogg"
        Section(13).musicPath = "_OST/Metroid - Zero Mission/Brinstar.ogg"
    end
    if eventName == "UncleChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme.ogg"
        Section(11).musicPath = "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7"
        Section(12).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
        Section(13).musicPath = "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7"
    end
    if eventName == "RinkaChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
        Section(2).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
        Section(3).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
        Section(7).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
        Section(8).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
        Section(11).musicPath = "_OST/Minecraft/mc03_mce_earth.ogg"
        Section(12).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
        Section(13).musicPath = "_OST/Minecraft/mc02_mc_toysonatear.ogg"
    end
    if eventName == "SnakeChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Metal Gear - OST.nsf|8;g=2"
        Section(2).musicPath = "_OST/Metal Gear - OST.nsf|8;g=2"
        Section(3).musicPath = "_OST/Metal Gear - OST.nsf|8;g=2"
        Section(7).musicPath = "_OST/Metal Gear - OST.nsf|8;g=2"
        Section(8).musicPath = "_OST/Metal Gear - OST.nsf|8;g=2"
        Section(11).musicPath = "_OST/Metal Gear - OST.nsf|7;g=2"
        Section(12).musicPath = "_OST/Metal Gear - OST.nsf|6;g=2"
        Section(13).musicPath = "_OST/Metal Gear - OST.nsf|6;g=2"
    end
    if eventName == "YoshiChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5"
        Section(2).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5"
        Section(3).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5"
        Section(7).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5"
        Section(8).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5"
        Section(11).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5"
        Section(12).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5"
        Section(13).musicPath = "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5"
    end
    if eventName == "KlonoaChar" and malcmusic.holiday == false then
        Section(1).musicPath = "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg"
        Section(2).musicPath = "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg"
        Section(3).musicPath = "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg"
        Section(7).musicPath = "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg"
        Section(8).musicPath = "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg"
        Section(11).musicPath = "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg"
        Section(12).musicPath = "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg"
        Section(13).musicPath = "_OST/Klonoa (Wii)/217 - Hiroshi Okubo - The Ring.ogg"
    end
    if eventName == "StageGenoside" and malcmusic.holiday == false then
        Section(0).musicPath = "_OST/Me and Larry City/Main Theme (Genoside).ogg"
        Section(1).musicPath = "_OST/Me and Larry City/Main Theme (Genoside).ogg"
        Section(2).musicPath = "_OST/Me and Larry City/Main Theme (Genoside).ogg"
        Section(3).musicPath = "_OST/Me and Larry City/Main Theme (Genoside).ogg"
        Section(4).musicPath = "_OST/Me and Larry City/Story Mode Hub Theme 3, Genoside (Super Mario Maker 2).ogg"
        Section(5).musicPath = "_OST/Undertale/mus_smallshock_genoside.ogg"
        Section(6).musicPath = "_OST/Me and Larry City/Main Theme (Genoside).ogg"
        Section(7).musicPath = "_OST/Me and Larry City/Main Theme (Genoside).ogg"
        Section(8).musicPath = "_OST/Me and Larry City/Main Theme (Genoside).ogg"
        Section(9).musicPath = "_OST/Undertale/mus_chara.ogg"
        Section(10).musicPath = "_OST/Me and Larry City/Main Theme (Genoside).ogg"
        Section(11).musicPath = "_OST/Undertale/mus_chara.ogg"
        Section(12).musicPath = "_OST/Undertale/mus_chara.ogg"
        Section(13).musicPath = "_OST/Undertale/mus_chara.ogg"
        Section(14).musicPath = "_OST/Me and Larry City/Main Theme (Genoside).ogg"
    end
end

--Resolution system

if SaveData.resolution == "fullscreen" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 600
        customCamera.defaultZoom = 1
        customCamera.defaultScreenOffsetX = 0
        customCamera.defaultScreenOffsetY = 0
        customCamera.defaultOffsetX = 0
        customCamera.defaultOffsetY = 0
        smallScreen.offsetX = 0
        smallScreen.offsetY = 0
        smallScreen.priority = 4
        if SaveData.letterbox == false then
            smallScreen.priority = 10
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox == true then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
    end
    if SaveData.resolution == "widescreen" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 450
        customCamera.defaultZoom = 0.75
        customCamera.defaultScreenOffsetX = 0
        customCamera.defaultScreenOffsetY = 0
        customCamera.defaultOffsetX = 0
        customCamera.defaultOffsetY = 0
        if SaveData.letterbox == false then
            smallScreen.priority = 10
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1.33
            smallScreen.offsetX = 0
        smallScreen.offsetY = 0
        elseif SaveData.letterbox == true then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
    end
    if SaveData.resolution == "ultrawide" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 337
        customCamera.defaultZoom = 0.562
        customCamera.defaultScreenOffsetX = 0
        customCamera.defaultScreenOffsetY = 0
        customCamera.defaultOffsetX = 0
        customCamera.defaultOffsetY = 0
        smallScreen.scaleX = 1
        smallScreen.scaleY = 1
        smallScreen.offsetX = 0
        smallScreen.offsetY = 0
        if SaveData.letterbox == false then
            smallScreen.priority = 10
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1.80
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox == true then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
    end
    if SaveData.resolution == "nes" then
        customCamera.defaultScreenWidth = 512
        customCamera.defaultScreenHeight = 448
        customCamera.defaultZoom = 0.75
        customCamera.defaultScreenOffsetX = 0
        customCamera.defaultScreenOffsetY = 0.20
        customCamera.defaultOffsetX = 0
        customCamera.defaultOffsetY = 0
        smallScreen.offsetX = 0
        smallScreen.offsetY = 0
        if SaveData.letterbox == false then
            smallScreen.priority = 10
            smallScreen.scaleX = 1.56
            smallScreen.scaleY = 1.34
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox == true then
            smallScreen.priority = 4
            smallScreen.scaleX = 1.25
            smallScreen.scaleY = 1.08
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(nesborder, 0, 0, 8)
        end
    end
    if SaveData.resolution == "gameboy" then
        customCamera.defaultScreenWidth = 320
        customCamera.defaultScreenHeight = 228
        customCamera.defaultZoom = 0.38
        customCamera.defaultScreenOffsetX = 0
        customCamera.defaultScreenOffsetY = 0
        customCamera.defaultOffsetX = 0
        customCamera.defaultOffsetY = 0
        smallScreen.scaleX = 1
        smallScreen.scaleY = 1
        smallScreen.offsetX = 0
        smallScreen.offsetY = 0
        if SaveData.letterbox == false then
            smallScreen.priority = 10
            smallScreen.scaleX = 2.5
            smallScreen.scaleY = 2.65
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox == true then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(gbborder, 0, 0, 8)
        end
    end
    if SaveData.resolution == "gba" then
        customCamera.defaultScreenWidth = 480
        customCamera.defaultScreenHeight = 320
        customCamera.defaultZoom = 0.54
        customCamera.defaultScreenOffsetX = 0
        customCamera.defaultScreenOffsetY = 0
        customCamera.defaultOffsetX = 0
        customCamera.defaultOffsetY = 0
        smallScreen.offsetX = 0
        smallScreen.offsetY = 0
        if SaveData.letterbox == false then
            smallScreen.priority = 10
            smallScreen.scaleX = 1.7
            smallScreen.scaleY = 1.9
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox == true then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(gbaborder, 0, 0, 8)
        end
    end
    if SaveData.resolution == "iphone1st" then
        customCamera.defaultScreenWidth = 400
        customCamera.defaultScreenHeight = 600
        customCamera.defaultZoom = 0.62
        customCamera.defaultScreenOffsetX = 0
        customCamera.defaultScreenOffsetY = 0
        customCamera.defaultOffsetX = 0
        customCamera.defaultOffsetY = 0
        smallScreen.scaleX = 1
        smallScreen.scaleY = 1
        smallScreen.offsetX = 0
        smallScreen.offsetY = 0
        if SaveData.letterbox == false then
            smallScreen.priority = 10
            smallScreen.scaleX = 3.3
            smallScreen.scaleY = 1.65
            smallScreen.offsetX = 5
            smallScreen.offsetY = -8
        elseif SaveData.letterbox == true then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(iphoneoneborder, 0, 0, 8)
        end
    end
    if SaveData.resolution == "3ds" then
        customCamera.defaultScreenWidth = 700
        customCamera.defaultScreenHeight = 419
        customCamera.defaultZoom = 0.58
        customCamera.defaultScreenOffsetX = 0
        customCamera.defaultScreenOffsetY = 70
        customCamera.defaultOffsetX = 0
        customCamera.defaultOffsetY = 0
        smallScreen.scaleX = 1
        smallScreen.scaleY = 1
        smallScreen.offsetX = 0
        smallScreen.offsetY = 0
        if SaveData.letterbox == false then
            smallScreen.priority = 10
            smallScreen.scaleX = 1.50
            smallScreen.scaleY = 1.72
            smallScreen.offsetX = 4
            smallScreen.offsetY = -118
        elseif SaveData.letterbox == true then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(threedsborder, 0, 0, 8)
        end
    end