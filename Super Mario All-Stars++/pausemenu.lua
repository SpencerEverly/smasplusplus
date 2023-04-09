local textplus = require("textplus")
local imagic = require("imagic")
local rng = require("rng")
local playerManager = require("playerManager")
local Routine = require("routine")

local battledependencies = require("classicbattlemode")
battledependencies.battlemodeactive = false

smasBooleans.musicMuted = false
local musicmuted = false
local blackscreen = Graphics.loadImage("blackscreen.png")

local active = true
local active2 = false
local ready = false
local exitscreen = false

local pausefont = textplus.loadFont("littleDialogue/font/sonicMania-bigFont.ini")
local pausefont2 = textplus.loadFont("littleDialogue/font/smb1-a.ini")
local pausefont3 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")

local cooldown = 0

onePressedState = false
twoPressedState = false
threePressedState = false
fourPressedState = false
fivePressedState = false
sixPressedState = false
sevenPressedState = false
eightPressedState = false
ninePressedState = false
zeroPressedState = false

local flag = true
local str = "Loading HUB..."

local pausemenu = {}

pausemenu.costumechanged = false
pausemenu.pauseactivated = true

local soundObject

local battlelevelsrng = {"battle_battleshrooms.lvlx", "battle_battle-zone.lvlx", "battle_classic-castle-battle.lvlx", "battle_dry-dry-desert.lvlx", "battle_hyrule-temple.lvlx", "battle_invasion-battlehammer.lvlx", "battle_lakitu-mechazone.lvlx", "battle_lethal-lava-level.lvlx", "battle_slippy-slap-snowland.lvlx", "battle_woody-warzone.lvlx","battle_retroville-underground.lvlx","battle_testlevel.lvlx"}
local selecter = rng.randomInt(1,#battlelevelsrng)
local randombattlelevel = battlelevelsrng[selecter]

if not isOverworld then
    local levelname = Level.filename()
    local levelformat = Level.format()
    local costumes = playerManager.getCostumes(player.character)
    local level = Level.filename()
end

pausemenu.paused = false;
pausemenu.paused_char = false;
pausemenu.paused_tele = false;
pausemenu.paused_other = false;

pausemenu.pause_box = nil
local pause_height = 0;
local pause_height_char = 350;
local pause_height_other = 725;
local pause_width = 700;

local pause_options;
local pause_options_char;
local pause_options_tele;
local pause_options_other;
local character_options;
local pause_index = 0
local pause_index_char = 0
local pause_index_tele = 0
local pause_index_other = 0

pausemenu.pauseactive = false
local charactive = false
local teleactive = false
local otheractive = false

function pausemenu.onInitAPI()
    registerEvent(pausemenu, "onKeyboardPress")
    registerEvent(pausemenu, "onDraw")
    registerEvent(pausemenu, "onLevelExit")
    registerEvent(pausemenu, "onTick")
    registerEvent(pausemenu, "onInputUpdate")
    registerEvent(pausemenu, "onStart")
    registerEvent(pausemenu, "onExit")
    
    local Routine = require("routine")
    
    ready = true
end

local function nothing()
    --Nothing happens here
end

local function unpause()
    pausemenu.paused = false
    Misc.unpause()
    Sound.playSFX("pausemenu-closed.ogg")
    cooldown = 5
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
end

function pausemenu.onStart()
    if not ready then return end
end

local function battlemodenewstage()
    smasBooleans.musicMuted = true
    Audio.MusicVolume(0)
    Sound.playSFX("skip-intro.ogg")
    Routine.run(function() exitscreen = true Routine.wait(1.5, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(65) Level.load(battlelevelsrng[selecter], nil, nil) end)
end

local function battlemodeexit()
    smasBooleans.musicMuted = true
    Audio.MusicVolume(0)
    Sound.playSFX("world_warp.ogg")
    Routine.run(function() exitscreen = true Routine.wait(0.4, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(65) Level.load("SMAS - Start.lvlx", nil, nil) end)
end

local function switchtochar()
    Sound.playSFX("charcost_open.ogg")
    pause_index_char = 0
    Routine.run(function() Routine.wait(0.01, true) pause_index_char = 1 end)
    cooldown = 1
    pausemenu.paused_char = true
    pausemenu.paused = false
end

local function switchtotele()
    Sound.playSFX("hub_easytravel.ogg")
    pause_index_tele = 0
    Routine.run(function() Routine.wait(0.01, true) pause_index_tele = 1 end)
    cooldown = 1
    pausemenu.paused_tele = true
    pausemenu.paused = false
end

local function switchtoothermenu()
    Sound.playSFX("quitmenu.ogg")
    pause_index_other = 0
    Routine.run(function() Routine.wait(0.01, true) pause_index_other = 1 end)
    cooldown = 1
    pausemenu.paused_other = true
    pausemenu.paused = false
end

local function pausemenureturn()
    Sound.playSFX("charcost-close.ogg")
    pause_index_char = 0
    Routine.run(function() Routine.wait(0.01, true) pause_index_other = 1 end)
    cooldown = 1
    pausemenu.paused = true
    pausemenu.paused_char = false
end

local function pausemenureturnhub()
    Sound.playSFX("hub_quitmenu.ogg")
    pause_index_tele = 0
    cooldown = 1
    pausemenu.paused = true
    pausemenu.paused_tele = false
end

local function pausemenureturnother()
    Sound.playSFX("quitmenu_close.ogg")
    pause_index_char = 0
    Routine.run(function() Routine.wait(0.01, true) pause_index_other = 1 end)
    cooldown = 1
    pausemenu.paused = true
    pausemenu.paused_other = false
end

local function x2modedisable()
    pausemenu.paused = false
    pausemenu.paused_other = false
    Misc.unpause()
    player:transform(1, false)
    if SaveData.disableX2char == false then
        SaveData.disableX2char = true
        Level.load(Level.filename())
    end
end

local function x2modeenable()
    Graphics.activateHud(false)
    Cheats.trigger("1player")
    Defines.player_hasCheated = false
    if SaveData.disableX2char == true then
        SaveData.disableX2char = false
        Level.load(Level.filename())
    end
    pausemenu.paused = false
    pausemenu.paused_other = false
    Misc.unpause()
end

local function mutemusic()
    smasBooleans.musicMuted = not smasBooleans.musicMuted
    if smasBooleans.musicMuted then
        Sound.playSFX("paused_on.ogg")
        musicmuted = true
    elseif not smasBooleans.musicMuted then
        Sound.playSFX("paused_off.ogg")
        musicmuted = false
    end
    --pausemenu.paused = false
    --pausemenu.paused_char = false
    --pausemenu.paused_tele = false
    --pausemenu.paused_other = false
    --Misc.unpause()
end

local function quitgame()
    Audio.MusicVolume(0)
    Audio.MusicPause()
    Misc.saveGame()
    Sound.playSFX("savequit.ogg")
    smasBooleans.musicMuted = true
    Routine.run(function() exitscreen = true Routine.wait(1.8, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function quitonly()
    Graphics.drawScreen{color = Color.black, priority = 10}
    Audio.MusicVolume(0)
    Audio.MusicPause()
    Sound.playSFX("nosave.ogg")
    smasBooleans.musicMuted = true
    Routine.run(function() exitscreen = true Routine.wait(0.9, true) pausemenu.paused = false pausemenu.paused_other = false Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function savegame()
    pausemenu.paused = false
    Sound.playSFX("save_dismiss.ogg")
    Misc.saveGame()
    Misc.unpause()
end

local function quitgamemap()
    Audio.MusicVolume(0)
    Audio.MusicPause()
    Misc.saveGame()
    smasBooleans.musicMuted = true
    Sound.playSFX("savequit.ogg")
    Routine.run(function() exitscreen = true Routine.wait(1.8, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function changeresolution()
    Sound.playSFX("resolution-set.ogg")
    if SaveData.resolution == "fullscreen" then
        SaveData.resolution = "widescreen"
    elseif SaveData.resolution == "widescreen" then
        SaveData.resolution = "ultrawide"
    elseif SaveData.resolution == "ultrawide" then
        SaveData.resolution = "nes"
    elseif SaveData.resolution == "nes" then
        SaveData.resolution = "gameboy"
    elseif SaveData.resolution == "gameboy" then
        SaveData.resolution = "gba"
    elseif SaveData.resolution == "gba" then
        SaveData.resolution = "iphone1st"
    elseif SaveData.resolution == "iphone1st" then
        SaveData.resolution = "3ds"
    elseif SaveData.resolution == "3ds" then
        SaveData.resolution = "fullscreen"
    end
end

local function changeresolutionborder()
    if SaveData.borderEnabled == true then
        Sound.playSFX("resolutionborder-disable.ogg")
        SaveData.borderEnabled = false
    elseif SaveData.borderEnabled == false then
        Sound.playSFX("resolutionborder-enable.ogg")
        SaveData.borderEnabled = true
    end
end

local function changeletterbox()
    if SaveData.letterbox == true then
        Sound.playSFX("letterbox-disable.ogg")
        SaveData.letterbox = false
    elseif SaveData.letterbox == false then
        Sound.playSFX("letterbox-enable.ogg")
        SaveData.letterbox = true
    end
end

local function quitonlymap()
    Graphics.drawScreen{color = Color.black, priority = 10}
    Audio.MusicVolume(0)
    Audio.MusicPause()
    Sound.playSFX("nosave.ogg")
    smasBooleans.musicMuted = true
    Routine.run(function() exitscreen = true Routine.wait(0.9, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function savegamemap()
    pausemenu.paused = false
    cooldown = 5
    Misc.unpause()
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Misc.saveGame();
    Sound.playSFX("save_dismiss.ogg")
end

local function returntolastlevel()
    Audio.MusicVolume(0)
    Audio.MusicPause()
    Sound.playSFX("lastlevel_warp.ogg")
    Routine.run(function() exitscreen = true Routine.wait(1.3, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Level.load(SaveData.lastLevelPlayed, nil, nil) end)
end

local function exitlevel2()
    Audio.MusicVolume(0)
    Audio.MusicPause()
    Sound.playSFX("world_warp.ogg")
    Routine.run(function() exitscreen = true Routine.wait(0.7, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Level.load("map.lvlx") end)
end

local function exitlevel()
    Audio.MusicVolume(0)
    smasBooleans.musicMuted = true
    Audio.MusicPause()
    Sound.playSFX("quitmenu_close.ogg")
    Routine.run(function() exitscreen = true Routine.wait(0.4, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) smasBooleans.musicMuted = false Level.load("map.lvlx") end)
end

local function restartlevel()
    Audio.MusicVolume(0)
    smasBooleans.musicMuted = true
    Audio.MusicPause()
    Sound.playSFX("skip-intro.ogg")
    Routine.run(function() exitscreen = true Routine.wait(1.5, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) smasBooleans.musicMuted = false Level.load(Level.filename()) end)
end

local function restartlevelhub()
    Audio.MusicVolume(0)
    Audio.MusicPause()
    smasBooleans.musicMuted = true
    Sound.playSFX("skip-intro.ogg")
    Routine.run(function() exitscreen = true Routine.wait(1.5, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) smasBooleans.musicMuted = false Level.load("MALC - HUB.lvlx", nil, nil) end)
end

local function warpzonehub()
    pausemenu.paused = false
    pausemenu.paused_tele = false
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(20496, 19520, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(20454, 19520, bottomCenterAligned)
    end
end

local function touristhub()
    pausemenu.paused = false
    pausemenu.paused_tele = false
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(-119968, -120128, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(-120010, -120128, bottomCenterAligned)
    end
end

local function starthub()
    pausemenu.paused = false
    pausemenu.paused_tele = false
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(-200608, -200128, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(-200650, -200128, bottomCenterAligned)
    end
end

local function switchhub()
    pausemenu.paused = false
    pausemenu.paused_tele = false
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(40176, 39876, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(40134, 39876, bottomCenterAligned)
    end
end

local function shophub()
    pausemenu.paused = false
    pausemenu.paused_tele = false
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(80144, 79868, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(80102, 79868, bottomCenterAligned)
    end
end

local function startteleport()
    pausemenu.paused_tele = false;
    cooldown = 5
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Sound.playSFX("hub_travelactivated.ogg")
    world.playerX = -2880
    world.playerY = -1664
    Sound.playSFX("world_warp.ogg")
end

local function sideteleport()
    pausemenu.paused_tele = false;
    cooldown = 5
    Misc.unpause()
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Sound.playSFX("hub_travelactivated.ogg")
    world.playerX = -3168
    world.playerY = -1536
    Sound.playSFX("world_warp.ogg")
end

local function hubmapteleport()
    pausemenu.paused_tele = false;
    cooldown = 5
    Misc.unpause()
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Sound.playSFX("hub_travelactivated.ogg")
    world.playerX = -3040
    world.playerY = -1760
    Sound.playSFX("world_warp.ogg")
end

local function dlcteleport()
    pausemenu.paused_tele = false;
    cooldown = 5
    Misc.unpause()
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Sound.playSFX("hub_travelactivated.ogg")
    world.playerX = -1760
    world.playerY = -1568
    Sound.playSFX("world_warp.ogg")
end

local function charmario()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(1, false)
end

local function charluigi()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(2, false)
end

local function charpeach()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(3, false)
end

local function chartoad()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(4, false)
end

local function charlink()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(5, false)
end

local function charmegaman()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(6, false)
end

local function charmegaman()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(6, false)
end

local function charwario()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(7, false)
end

local function charbowser()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(8, false)
end

local function charklonoa()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(9, false)
end

local function charyoshi()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(10, false)
end

local function charrosalina()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(11, false)
end

local function charsnake()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(12, false)
end

local function charzelda()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(13, false)
end

local function charsteve()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(14, false)
end

local function charunclebroadsword()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(15, false)
end

local function charsamus()
    Sound.playSFX("charcost-selected.ogg")
    Sound.playSFX("racoon-changechar.ogg")
    player:transform(16, false)
end

local function characterchange()
    local character = player.character;
    if (character == CHARACTER_MARIO) then
        player:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player:transform(6, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_MEGAMAN) then
        player:transform(7, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_WARIO) then
        player:transform(8, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_BOWSER) then
        player:transform(9, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_KLONOA) then
        player:transform(10, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_NINJABOMBERMAN) then
        player:transform(11, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ROSALINA) then
        player:transform(12, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_SNAKE) then
        player:transform(13, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ZELDA) then
        player:transform(14, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ULTIMATERINKA) then
        player:transform(15, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_UNCLEBROADSWORD) then
        player:transform(16, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_SAMUS) then
        player:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchange13()
    local character = player.character;
    if (character == CHARACTER_MARIO) then
        player:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchange13_2p()
    local character = player2.character;
    if (character == CHARACTER_MARIO) then
        player2:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player2:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player2:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player2:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player2:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchangeleft()
    local character = player.character;
    if (character == CHARACTER_MARIO) then
        player:transform(16, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_MEGAMAN) then
        player:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_WARIO) then
        player:transform(6, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_BOWSER) then
        player:transform(7, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_KLONOA) then
        player:transform(8, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_NINJABOMBERMAN) then
        player:transform(9, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ROSALINA) then
        player:transform(10, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_SNAKE) then
        player:transform(11, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ZELDA) then
        player:transform(12, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ULTIMATERINKA) then
        player:transform(13, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_UNCLEBROADSWORD) then
        player:transform(14, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_SAMUS) then
        player:transform(15, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchange13left()
    local character = player.character;
    if (character == CHARACTER_MARIO) then
        player:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchange13_2pleft()
    local character = player2.character;
    if (character == CHARACTER_MARIO) then
        player2:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player2:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player2:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player2:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player2:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function costumechangeright()
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()
    local costumeIdx = table.ifind(costumes,currentCostume)
    
    if costumeIdx ~= nil then
        player:setCostume(costumes[costumeIdx + 1])
    else
        player:setCostume(costumes[1])
    end
    --pausemenu.costumechanged = true
    Sound.playSFX("charcost_costume.ogg")
    Sound.playSFX("charcost-selected.ogg")
end

local function costumechangeleftmap()
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()
    local costumeIdx = table.ifind(costumes,currentCostume)
    
    if costumeIdx ~= nil then
        player:setCostume(costumes[costumeIdx - 1])
    else
        player:setCostume(costumes[1])
    end
    Sound.playSFX("charcost_costume.ogg")
    Sound.playSFX("charcost-selected.ogg")
end

local function costumechangeleft()
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()
    local costumeIdx = table.ifind(costumes,currentCostume)
    
    if costumeIdx ~= nil then
        player:setCostume(costumes[costumeIdx - 1])
    else
        player:setCostume(costumes[1])
    end
    --pausemenu.costumechanged = true
    Sound.playSFX("charcost_costume.ogg")
    Sound.playSFX("charcost-selected.ogg")
end

local function costumechangerightmap()
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()
    local costumeIdx = table.ifind(costumes,currentCostume)
    
    if costumeIdx ~= nil then
        player:setCostume(costumes[costumeIdx + 1])
    else
        player:setCostume(costumes[1])
    end
    Sound.playSFX("charcost_costume.ogg")
    Sound.playSFX("charcost-selected.ogg")
end

local function mainmenu()
    pausemenu.paused = false
    Misc.unpause()
    Misc.saveGame()
    smasBooleans.musicMuted = true
    Routine.run(function() exitscreen = true Audio.MusicVolume(0) Sound.playSFX("shutdown.ogg") Routine.wait(2.4, true) paused = false Misc.saveGame() Misc.unpause() smasBooleans.musicMuted = false Audio.MusicVolume(65) Level.load("SMAS - Start.lvlx", nil, nil) end)
end

local function wrong()
    Sound.playSFX("wrong.ogg")
end

local function hubteleport()
    pausemenu.paused = false
    pausemenu.paused_other = false
    Misc.unpause()
    Level.load("MALC - HUB.lvlx", nil, nil)
end

local function dlcmapload()
    pausemenu.paused = false
    pausemenu.paused_other = false
    Misc.unpause()
    Level.load("map.lvlx", nil, nil)
end

local function cycle(dir)
    if #pause_options_char[pause_index_char] == 0 then return end
    SFX.play(sfx.move)
    currentMenuPosition[pause_index_char] = currentMenuPosition[pause_index_char] + dir
    local pos = currentMenuPosition[pause_index_char]
    if (not pause_options_char[pause_index_char][pos] and pos > 0 and pos <= #pause_options_char[pause_index_char]) then
        return cycle(dir)
    end

    if currentMenuPosition[pause_index_char] <= 0 then
        currentMenuPosition[pause_index_char] = #pause_options_char[pause_index_char] + 1
        return cycle(dir)
    end

    if currentMenuPosition[pause_index_char] > #pause_options_char[pause_index_char] then
        currentMenuPosition[pause_index_char] = 0
        return cycle(dir)
    end
end

local function drawPauseMenu(y, alpha)
    local name = "<color yellow>PAUSED</color>"
    --local font = textblox.FONT_SPRITEDEFAULT3X2;
    
    local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
    local w,h = layout.width, layout.height
    if not isOverworld then
        textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = -1}
    end
    if isOverworld then
        textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 8}
    end
    --local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
    
    h = h+16+4--font.charHeight;
    y = y+h;
    
    
    if(pause_options == nil) then
        pause_options = 
        {
            {name="Continue", action=unpause}
        }
        if not isOverworld then
            if not battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Restart", action = restartlevel});
            end
        end
        if not isOverworld then
            if not battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Exit to the Main Map", action = exitlevel2});
            end
        end
        if not isOverworld then
            if not battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Return to the Previous Level", action = returntolastlevel});
            end
        end
        if not isOverworld then
            if not battledependencies.battlemodeactive then
                if Level.filename() == "MALC - HUB.lvlx" then
                    table.insert(pause_options, {name="Teleporting Options", action = switchtotele});
                end
            end
        end
        if isOverworld then
            if not battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Teleporting Options", action = switchtotele});
            end
        end
        if not battledependencies.battlemodeactive then
            table.insert(pause_options, {name="Character Options", action = switchtochar});
        end
        if not battledependencies.battlemodeactive then
            table.insert(pause_options, {name="Other Options", action = switchtoothermenu});
        end
        if not isOverworld then
            if not battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Save and Continue", action = savegame});
            end
        end
        if isOverworld then
            if not battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Save and Continue", action = savegamemap});
            end
        end
        if not isOverworld then
            if not battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Save and Reset Game", action = mainmenu});
            end
        end
        if not isOverworld then
            if not battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Save and Quit", action = quitgame});
            end
        end
        if isOverworld then
            table.insert(pause_options, {name="Save and Quit", action = quitgamemap});
        end
        if not isOverworld then
            if battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Start a New Stage", action = battlemodenewstage});
            end
        end
        if not isOverworld then
            if battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Restart this Stage", action = restartlevel});
            end
        end
        if not isOverworld then
            if battledependencies.battlemodeactive then
                table.insert(pause_options, {name="Exit Battle Mode", action = battlemodeexit});
            end
        end
    end
    for k,v in ipairs(pause_options) do
        local c = 0xFFFFFF00;
        local n = v.name;
        if(v.inactive) then
            c = 0x99999900;
        end
        if(k == pause_index+1) then
            n = "<color rainbow><wave 1>"..n.."</wave></color>";
        end
            
        local layout = textplus.layout(textplus.parse(n, {xscale=1.5, yscale=1.5, font=pausefont3}), pause_width)
        local h2 = layout.height
        if not isOverworld then
            textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y+8, color = Color.fromHex(c+alpha*255), priority = -1}
        end
        if isOverworld then
            textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y+8, color = Color.fromHex(c+alpha*255), priority = 8}
        end
        
        --local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
        h2 = h2+2+4--font.charHeight;
        y = y+h2;
        h = h+h2;
    end

    
    return h;
end

local function drawCharacterMenu(y, alpha)
    local name = "<color yellow>PAUSED</color>"
    --local font = textblox.FONT_SPRITEDEFAULT3X2;
    
    local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
    local w,h = layout.width, layout.height
    if not isOverworld then
        textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = -1}
    end
    if isOverworld then
        textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 8}
    end
    --local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
    
    h = h+16+4--font.charHeight;
    y = y+h;
    
    
    if(pause_options_char == nil) then
        pause_options_char = 
        {
            {name2="Character Options", action=nothing}
        }
        
        table.insert(pause_options_char, {name2="Go Back", action = pausemenureturn});
        if SaveData.disableX2char == false then
            table.insert(pause_options_char, {name2="Change Character (Left)", action = characterchangeleft});
        end
        if SaveData.disableX2char == false then
            table.insert(pause_options_char, {name2="Change Character (Right)", action = characterchange});
        end
        if SaveData.disableX2char == true then
            table.insert(pause_options_char, {name2="Change 1P's Character (Left)", action = characterchange13left});
        end
        if SaveData.disableX2char == true then
            table.insert(pause_options_char, {name2="Change 1P's Character (Right)", action = characterchange13});
        end
        if SaveData.disableX2char == true then
            if Player.count() == 2 then
                table.insert(pause_options_char, {name2="Change 2P's Character (Left)", action = characterchange13_2pleft});
                table.insert(pause_options_char, {name2="Change 2P's Character (Right)", action = characterchange13_2p});
            end
        end
        if isOverworld then
            if SaveData.disableX2char == false then
                table.insert(pause_options_char, {name2="Change Costume (Left)", action = costumechangeleftmap});
            end
        end
        if isOverworld then
            if SaveData.disableX2char == false then
                table.insert(pause_options_char, {name2="Change Costume (Right)", action = costumechangerightmap});
            end
        end
        if not isOverworld then
            if SaveData.disableX2char == false then
                table.insert(pause_options_char, {name2="Change Costume (Left)", action = costumechangeleft});
            end
        end
        if not isOverworld then
            if SaveData.disableX2char == false then
                table.insert(pause_options_char, {name2="Change Costume (Right)", action = costumechangeright});
            end
        end
    end
    
    for k,v in ipairs(pause_options_char) do
        local c = 0xFFFFFF00;
        local n = v.name2;
        if(v.inactive) then
            c = 0x99999900;
        end
        if(k == pause_index_char+1) then
            n = "<color rainbow><wave 1>"..n.."</wave></color>";
        end
            
        local layout = textplus.layout(textplus.parse(n, {xscale=1.5, yscale=1.5, font=pausefont3}), pause_width)
        local h2 = layout.height
        if not isOverworld then
            textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y, color = Color.fromHex(c+alpha*255), priority = -1}
        end
        if isOverworld then
            textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y, color = Color.fromHex(c+alpha*255), priority = 8}
        end
        --local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
        h2 = h2+2+4--font.charHeight;
        y = y+h2;
        h = h+h2;
    end
    
    local currentCostume = player:getCostume()
    if currentCostume then
        costumename = "<color red>Current costume: "..currentCostume.."</color>"
    end
    if currentCostume == "00-SMASPLUSPLUS-BETA" then
        costumename = "<color red>Current costume: SMAS++ 2012 Beta Mario</color>"
    end
    if currentCostume == "01-SMB1-RETRO" then
        costumename = "<color red>Current costume: Super Mario Bros. (NES)</color>"
    end
    if currentCostume == "02-SMB1-RECOLORED" then
        costumename = "<color red>Current costume: Super Mario Bros. (Recolored)</color>"
    end
    if currentCostume == "03-SMB1-SMAS" then
        costumename = "<color red>Current costume: Super Mario Bros. (SNES)</color>"
    end
    if currentCostume == "04-SMB2-RETRO" then
        costumename = "<color red>Current costume: Super Mario Bros. 2 (NES)</color>"
    end
    if currentCostume == "05-SMB2-SMAS" then
        costumename = "<color red>Current costume: Super Mario Bros. 2 (SNES)</color>"
    end
    if currentCostume == "06-SMB3-RETRO" then
        costumename = "<color red>Current costume: Super Mario Bros. 3 (NES)</color>"
    end
    if currentCostume == "07-SML2" then
        costumename = "<color red>Current costume: Super Mario Land 2 (GB)</color>"
    end
    if currentCostume == "09-SMW-PIRATE" then
        costumename = "<color red>Current costume: Super Mario World (NES, Bootleg)</color>"
    end
    if currentCostume == "11-SMA1" then
        costumename = "<color red>Current costume: Super Mario Advance 1 (GBA)</color>"
    end
    if currentCostume == "12-SMA2" then
        costumename = "<color red>Current costume: Super Mario Advance 2 (GBA)</color>"
    end
    if currentCostume == "13-SMA4" then
        costumename = "<color red>Current costume: Super Mario Advance 4 (GBA)</color>"
    end
    if currentCostume == "14-NSMBDS-SMBX" then
        costumename = "<color red>Current costume: New Super Mario Bros. (SMBX)</color>"
    end
    if currentCostume == "15-NSMBDS-ORIGINAL" then
        costumename = "<color red>Current costume: New Super Mario Bros. (NDS)</color>"
    end
    if currentCostume == "A2XT-DEMO" then
        costumename = "<color red>Current costume: Demo (A2XT)</color>"
    end
    if currentCostume == "DEMO-XMASPILY" then
        costumename = "<color red>Current costume: Pily (A2XT: Gaiden 2)</color>"
    end
    if currentCostume == "GA-CAILLOU" then
        costumename = "<color red>Current costume: Caillou (GoAnimate, Vyond)</color>"
    end
    if currentCostume == "GOLDENMARIO" then
        costumename = "<color red>Current costume: Golden Mario (SMBX)</color>"
    end
    if currentCostume == "GOOMBA" then
        costumename = "<color red>Current costume: Goomba (SMBX)</color>"
    end
    if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
        costumename = "<color red>Current costume: JC Foster Takes it to the Moon</color>"
    end
    if currentCostume == "MARINK" then
        costumename = "<color red>Current costume: The Legend of Mario (SMBX)</color>"
    end
    if currentCostume == "MODERN" then
        costumename = "<color red>Current costume: Modern Mario Bros.</color>"
    end
    if currentCostume == "PRINCESSRESCUE" then
        costumename = "<color red>Current costume: Princess Rescue (Atari 2600)</color>"
    end
    if currentCostume == "SMB0" then
        costumename = "<color red>Current costume: Super Mario Bros. 0 (SMBX)</color>"
    end
    if currentCostume == "SMG4" then
        costumename = "<color red>Current costume: SuperMarioGlitchy4 (YouTube)</color>"
    end
    if currentCostume == "SMM2-MARIO" then
        costumename = "<color red>Current costume: Super Mario Maker (SMW, Mario)</color>"
    end
    if currentCostume == "SMM2-LUIGI" then
        costumename = "<color red>Current costume: Super Mario Maker (SMW, Luigi)</color>"
    end
    if currentCostume == "SMM2-TOAD" then
        costumename = "<color red>Current costume: Super Mario Maker (SMW, Toad)</color>"
    end
    if currentCostume == "SMM2-TOADETTE" then
        costumename = "<color red>Current costume: Super Mario Maker (SMW, Toadette)</color>"
    end
    if currentCostume == "SMM2-YELLOWTOAD" then
        costumename = "<color red>Current costume: Super Mario Maker (SMW, Yellow Toad)</color>"
    end
    if currentCostume == "SMW-MARIO" then
        costumename = "<color red>Current costume: Super Mario World (SNES)</color>"
    end
    if currentCostume == "SP-1-ERICCARTMAN" then
        costumename = "<color red>Current costume: Eric Cartman (South Park)</color>"
    end
    if currentCostume == "Z-SMW2-ADULTMARIO" then
        costumename = "<color red>Current costume: Super Mario World 2 (SNES)</color>"
    end
    
    if currentCostume == "00-SPENCEREVERLY" then
        costumename = "<color red>Current costume: Spencer Everly (SMBS)</color>"
    end
    if currentCostume == "03-SMB1-RETRO-MODERN" then
        costumename = "<color red>Current costume: Super Mario Bros. (NES, Modern)</color>"
    end
    if currentCostume == "04-SMB1-SMAS" then
        costumename = "<color red>Current costume: Super Mario Bros. (SNES)</color>"
    end
    if currentCostume == "05-SMB2-RETRO" then
        costumename = "<color red>Current costume: Super Mario Bros. 2 (NES)</color>"
    end
    if currentCostume == "06-SMB2-SMAS" then
        costumename = "<color red>Current costume: Super Mario Bros. 2 (SNES)</color>"
    end
    if currentCostume == "07-SMB3-RETRO" then
        costumename = "<color red>Current costume: Super Mario Bros. 3 (NES)</color>"
    end
    if currentCostume == "09-SMB3-MARIOCLOTHES" then
        costumename = "<color red>Current costume: Marigi</color>"
    end
    if currentCostume == "10-SMW-ORIGINAL" then
        costumename = "<color red>Current costume: Super Mario World (SNES)</color>"
    end
    if currentCostume == "13-SMBDX" then
        costumename = "<color red>Current costume: Super Mario Bros. Deluxe (GBC)</color>"
    end
    if currentCostume == "15-SMA2" then
        costumename = "<color red>Current costume: Super Mario Advance 2 (GBA)</color>"
    end
    if currentCostume == "16-SMA4" then
        costumename = "<color red>Current costume: Super Mario Advance 4 (GBA)</color>"
    end
    if currentCostume == "17-NSMBDS-SMBX" then
        costumename = "<color red>Current costume: New Super Mario Bros. (SMBX)</color>"
    end
    if currentCostume == "A2XT-IRIS" then
        costumename = "<color red>Current costume: Iris (A2XT)</color>"
    end
    if currentCostume == "LARRYTHECUCUMBER" then
        costumename = "<color red>Current costume: Larry (VeggieTales)</color>"
    end
    if currentCostume == "UNDERTALE-FRISK" then
        costumename = "<color red>Current costume: Frisk (Undertale)</color>"
    end
    if currentCostume == "WALUIGI" then
        costumename = "<color red>Current costume: Waluigi</color>"
    end
    if currentCostume == "SMW-LUIGI" then
        costumename = "<color red>Current costume: Super Mario World (SMAS)</color>"
    end
    
    if currentCostume == nil then
        costumename = "<color red>Current costume: N/A</color>"
    end
    --local font = textblox.FONT_SPRITEDEFAULT3X2;
    
    local layout = textplus.layout(textplus.parse(costumename, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
    if not isOverworld then
        textplus.render{layout = layout, x = 222 - w*0.5, y = y+4, color = Color.white..alpha, priority = -1}
    end
    if isOverworld then
        textplus.render{layout = layout, x = 222 - w*0.5, y = y+4, color = Color.white..alpha, priority = 8}
    end
    --local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
    
    h = h+4+16--font.charHeight;
    y = y+h;

    
    return h;
end

local function drawHUBTeleportMenu(y, alpha)
    local name = "<color yellow>PAUSED</color>"
    --local font = textblox.FONT_SPRITEDEFAULT3X2;
    
    local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
    local w,h = layout.width, layout.height
    if not isOverworld then
        textplus.render{layout = layout, x = 450 - w*0.5, y = y+8, color = Color.white..alpha, priority = -1}
    end
    if isOverworld then
        textplus.render{layout = layout, x = 450 - w*0.5, y = y+8, color = Color.white..alpha, priority = 8}
    end
    --local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
    
    h = h+16+4--font.charHeight;
    y = y+h;
    
    
    if(pause_options_tele == nil) then
        pause_options_tele = 
        {
            {name3="Teleporting Options", action=nothing}
        }
        
        table.insert(pause_options_tele, {name3="Go Back", action = pausemenureturnhub});
        if not isOverworld then
            table.insert(pause_options_tele, {name3="Teleport to the Tourist Center", action = touristhub});
        end
        if not isOverworld then
            table.insert(pause_options_tele, {name3="Teleport to the Warp Zone", action = warpzonehub});
        end
        if not isOverworld then
            table.insert(pause_options_tele, {name3="Teleport to the Character Switch Menu", action = switchhub});
        end
        if not isOverworld then
            table.insert(pause_options_tele, {name3="Teleport to the Shop", action = shophub});
        end
        if not isOverworld then
            table.insert(pause_options_tele, {name3="Teleport Back to the Start", action = starthub});
        end
        if isOverworld then
            table.insert(pause_options_tele, {name3="Teleport back to the Start", action = startteleport});
        end
        if isOverworld then
            table.insert(pause_options_tele, {name3="Teleport to the Hub", action = hubmapteleport});
        end
        if isOverworld then
            table.insert(pause_options_tele, {name3="Teleport to the Side Quest", action = sideteleport});
        end
        if isOverworld then
            table.insert(pause_options_tele, {name3="Teleport to the DLC World", action = dlcteleport});
        end
    end
    for k,v in ipairs(pause_options_tele) do
        local c = 0xFFFFFF00;
        local n = v.name3;
        if(v.inactive) then
            c = 0x99999900;
        end
        if(k == pause_index_tele+1) then
            n = "<color rainbow><wave 1>"..n.."</wave></color>";
        end
            
        local layout = textplus.layout(textplus.parse(n, {xscale=1.5, yscale=1.5, font=pausefont3}), pause_width)
        local h2 = layout.height
        if not isOverworld then
            textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y, color = Color.fromHex(c+alpha*255), priority = -1}
        end
        if isOverworld then
            textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y, color = Color.fromHex(c+alpha*255), priority = 8}
        end
        --local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
        h2 = h2+2+4--font.charHeight;
        y = y+h2;
        h = h+h2;
    end

    
    return h;
end

local function drawOtherOptionMenu(y, alpha)
    local name = "<color yellow>PAUSED</color>"
    --local font = textblox.FONT_SPRITEDEFAULT3X2;
    
    local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
    local w,h = layout.width, layout.height
    if not isOverworld then
        textplus.render{layout = layout, x = 400 - w*0.5, y = y+16, color = Color.white..alpha, priority = -1}
    end
    if isOverworld then
        textplus.render{layout = layout, x = 400 - w*0.5, y = y+16, color = Color.white..alpha, priority = 8}
    end
    --local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
    
    h = h+16+8--font.charHeight;
    y = y+h;
    
    
    if(pause_options_other == nil) then
        pause_options_other = 
        {
            {name4="Other Options", action=nothing}
        }
        
        table.insert(pause_options_other, {name4="Go Back", action = pausemenureturnother});
        table.insert(pause_options_other, {name4="Change Resolution", action = changeresolution});
        table.insert(pause_options_other, {name4="Toggle Letterbox Scaling", action = changeletterbox});
        table.insert(pause_options_other, {name4="Toggle Resolution Border", action = changeresolutionborder});
        if not isOverworld then
            table.insert(pause_options_other, {name4="Go to the Extra Game/DLC Map", action = dlcmapload});
        end
        if not isOverworld then
            table.insert(pause_options_other, {name4="Teleport to the Hub", action = hubteleport});
        end
        if not isOverworld then
            table.insert(pause_options_other, {name4="Mute/Unmute Music", action = mutemusic});
        end
        if not isOverworld then
            if SaveData.disableX2char == true then
                table.insert(pause_options_other, {name4="Turn OFF SMBX 1.3 Mode", action = x2modeenable});
            end
        end
        if not isOverworld then
            if SaveData.disableX2char == false then
                table.insert(pause_options_other, {name4="Turn ON SMBX 1.3 Mode", action = x2modedisable});
            end
        end
        if not isOverworld then
            table.insert(pause_options_other, {name4="Exit without Saving", action = quitonly});
        end
        if isOverworld then
            table.insert(pause_options_other, {name4="Exit without Saving", action = quitonlymap});
        end
    end
    for k,v in ipairs(pause_options_other) do
        local c = 0xFFFFFF00;
        local n = v.name4;
        if(v.inactive) then
            c = 0x99999900;
        end
        if(k == pause_index_other+1) then
            n = "<color rainbow><wave 1>"..n.."</wave></color>";
        end
            
        local layout = textplus.layout(textplus.parse(n, {xscale=1.5, yscale=1.5, font=pausefont3}), pause_width)
        local h2 = layout.height
        if not isOverworld then
            textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y+8, color = Color.fromHex(c+alpha*255), priority = -1}
        end
        if isOverworld then
            textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y+8, color = Color.fromHex(c+alpha*255), priority = 8}
        end
        --local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
        h2 = h2+2+8--font.charHeight;
        y = y+h2;
        h = h+h2;
    end
    
    if SaveData.resolution == "fullscreen" then
        resolutionshow = "<color red>Resolution: Fullscreen (4:3)</color>"
    end
    if SaveData.resolution == "widescreen" then
        resolutionshow = "<color red>Resolution: Widescreen (16:9)</color>"
    end
    if SaveData.resolution == "ultrawide" then
        resolutionshow = "<color red>Resolution: Ultrawide (21:9)</color>"
    end
    if SaveData.resolution == "nes" then
        resolutionshow = "<color red>Resolution: NES/SNES</color>"
    end
    if SaveData.resolution == "gameboy" then
        resolutionshow = "<color red>Resolution: Gameboy/Gameboy Color</color>"
    end
    if SaveData.resolution == "gba" then
        resolutionshow = "<color red>Resolution: Gameboy Advance</color>"
    end
    if SaveData.resolution == "iphone1st" then
        resolutionshow = "<color red>Resolution: iPhone (1st Generation)</color>"
    end
    if SaveData.resolution == "3ds" then
        resolutionshow = "<color red>Resolution: Nintendo 3DS (Top Screen)</color>"
    end
    
    if SaveData.letterbox == true then
        letterboxscale = "<color red>Scaling enabled: No</color>"
    end
    if SaveData.letterbox == false then
        letterboxscale = "<color red>Scaling enabled: Yes</color>"
    end
    
    if SaveData.borderEnabled == true then
        resolutiontheme = "<color red>Border enabled: Yes</color>"
    end
    if SaveData.borderEnabled == false then
        resolutiontheme = "<color red>Border enabled: No</color>"
    end
    
    if musicmuted == true then
        musicmutedialogue = "<color red>Music muted: Yes</color>"
    end
    if musicmuted == false then
        musicmutedialogue = "<color red>Music muted: No</color>"
    end
    --local font = textblox.FONT_SPRITEDEFAULT3X2;

    local layout = textplus.layout(textplus.parse(resolutionshow, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
    local layout2 = textplus.layout(textplus.parse(letterboxscale, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
    local layout3 = textplus.layout(textplus.parse(resolutiontheme, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
    local layout4 = textplus.layout(textplus.parse(musicmutedialogue, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
    if not isOverworld then
        textplus.render{layout = layout, x = 250 - w*0.5, y = y+16, color = Color.white..alpha, priority = -1}
        textplus.render{layout = layout2, x = 250 - w*0.5, y = y+32, color = Color.white..alpha, priority = -1}
        textplus.render{layout = layout3, x = 250 - w*0.5, y = y+48, color = Color.white..alpha, priority = -1}
        textplus.render{layout = layout4, x = 250 - w*0.5, y = y+68, color = Color.white..alpha, priority = -1}
    end
    if isOverworld then
        textplus.render{layout = layout, x = 250 - w*0.5, y = y+16, color = Color.white..alpha, priority = 8}
        textplus.render{layout = layout2, x = 250 - w*0.5, y = y+32, color = Color.white..alpha, priority = 8}
        textplus.render{layout = layout3, x = 250 - w*0.5, y = y+48, color = Color.white..alpha, priority = 8}
        textplus.render{layout = layout4, x = 250 - w*0.5, y = y+68, color = Color.white..alpha, priority = 8}
    end
    --local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})

    h = h+4+62--font.charHeight;
    y = y+h;

    
    return h;
end

function pausemenu.onDraw(isSplit)
    if pausemenu.paused then
        Misc.pause()
        if(pausemenu.pause_box == nil) then
            pause_height = drawPauseMenu(-600,0);
            pausemenu.pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
        end
        if not isOverworld then
            pausemenu.pause_box:Draw(-2, 0x00000077);
        end
        if isOverworld then
            pausemenu.pause_box:Draw(7, 0x00000077);
        end
        drawPauseMenu(300-pause_height*0.5,1)
        
        --Fix for anything calling Misc.unpause
        --Misc.pause();
    end
    if not pausemenu.paused then
        pausemenu.pause_box = nil
    end
    if pausemenu.paused_char then
        Misc.pause()
        if(pausemenu.pause_box == nil) then
            pause_height = drawCharacterMenu(-600,0);
            pausemenu.pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
        end
        if not isOverworld then
            pausemenu.pause_box:Draw(-2, 0x00000077);
        end
        if isOverworld then
            pausemenu.pause_box:Draw(7, 0x00000077);
        end
        drawCharacterMenu(300-pause_height*0.5,1)
        
        --Fix for anything calling Misc.unpause
        --Misc.pause();
    end
    if not pausemenu.paused_char then
        pausemenu.pause_box = nil
    end
    if pausemenu.paused_tele then
        Misc.pause()
        if(pausemenu.pause_box == nil) then
            pause_height = drawHUBTeleportMenu(-600,0);
            pausemenu.pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
        end
        if not isOverworld then
            pausemenu.pause_box:Draw(-2, 0x00000077);
        end
        if isOverworld then
            pausemenu.pause_box:Draw(7, 0x00000077);
        end
        drawHUBTeleportMenu(300-pause_height*0.5,1)
        
        --Fix for anything calling Misc.unpause
        Misc.pause();
    end
    if not pausemenu.paused_tele then
        pausemenu.pause_box = nil
    end
    if pausemenu.paused_other then
        Misc.pause()
        if not isOverworld then
            if(pausemenu.pause_box == nil) then
                pause_height_other = drawOtherOptionMenu(-600,0);
                pausemenu.pause_box = imagic.Create{x=400,y=300,width=460,height=pause_height_other+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
            end
            pausemenu.pause_box:Draw(-2, 0x00000077);
            drawOtherOptionMenu(231-pause_height*0.5,1)
        end
        if isOverworld then
            if(pausemenu.pause_box == nil) then
                pause_height_other = drawOtherOptionMenu(-600,0);
                pausemenu.pause_box = imagic.Create{x=400,y=300,width=460,height=pause_height_other+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
            end
            pausemenu.pause_box:Draw(7, 0x00000077);
            drawOtherOptionMenu(248-pause_height*0.5,1)
        end
        
        --Fix for anything calling Misc.unpause
        --Misc.pause();
    end
    if not pausemenu.paused_other then
        pausemenu.pause_box = nil
    end
    if exitscreen then
        Graphics.drawScreen{color = Color.black, priority = 10}
    end
end

local lastPauseKey = false;

function pausemenu.onInputUpdate()
    if(player.pauseKeyPressing == true and not lastPauseKey) then
        if pausemenu.paused then
            pausemenu.paused = false
            pausemenu.paused_char = false
            pausemenu.paused_tele = false
            pausemenu.paused_other = false
            pausemenu.pauseactive = false
            Sound.playSFX("pausemenu-closed.ogg")
            cooldown = 5
            Misc.unpause()
            player:mem(0x11E,FIELD_BOOL,false)
        elseif(player:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and pausemenu.pauseactivated == true) then
            --Misc.pause();
            pausemenu.paused = true
            pausemenu.pauseactive = true
            pause_index = 0;
            Sound.playSFX("pausemenu.ogg")
        elseif Player.count() >= 2 then
            if pausemenu.paused then
                pausemenu.paused = false
                pausemenu.paused_char = false
                pausemenu.paused_tele = false
                pausemenu.paused_other = false
                pausemenu.pauseactive = false
                Sound.playSFX("pausemenu-closed.ogg")
                cooldown = 5
                Misc.unpause()
                player2:mem(0x11E,FIELD_BOOL,false)
            end
            if(player2:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and pausemenu.pauseactivated == true) then
                --Misc.pause();
                pausemenu.paused = true
                pausemenu.pauseactive = true
                pause_index = 0;
                Sound.playSFX("pausemenu.ogg")
            end
        end
        if cooldown <= 0 then
            player:mem(0x11E,FIELD_BOOL,true)
        end
        if pause_index_char == -1 then
            if player.keys.down == KEYS_PRESSED then
                cycle(1)
            end
            if player.keys.up == KEYS_PRESSED then
                cycle(-1)
            end
        end
        if pause_index_tele == 0 then
            pause_index_tele = pause_index_tele + 1
        end
        if pause_index_other == 0 then
            pause_index_other = pause_index_other + 1
        end
    end
    lastPauseKey = player.keys.pause;
    
    if(pausemenu.paused and pause_options) then
        if(player.keys.down == KEYS_PRESSED) then
            repeat
                pause_index = (pause_index+1)%#pause_options;
            until(not pause_options[pause_index+1].inactive);
            Sound.playSFX("pausemenu_cursor.ogg")
        elseif(player.keys.up == KEYS_PRESSED) then
            repeat
                pause_index = (pause_index-1)%#pause_options;
            until(not pause_options[pause_index+1].inactive);
            Sound.playSFX("pausemenu_cursor.ogg")
        elseif(player.keys.left == KEYS_PRESSED) then
            player.keys.left = KEYS_UNPRESSED
        elseif(player.keys.right == KEYS_PRESSED) then
            player.keys.right = KEYS_UNPRESSED
        elseif(player.keys.jump == KEYS_PRESSED) then
            player:mem(0x11E,FIELD_BOOL,false)
            for i=1, 3 do
                for k,v in ipairs(pause_options[i]) do
                    if v then
                        v.activeLerp = 0
                    end
                end
            end
            pause_options[pause_index+1].action();
            Misc.unpause();
        end
        if Player.count() >= 2 then
            if(player2.keys.down == KEYS_PRESSED) then
                repeat
                    pause_index = (pause_index+1)%#pause_options;
                until(not pause_options[pause_index+1].inactive);
                Sound.playSFX("pausemenu_cursor.ogg")
            elseif(player2.keys.up == KEYS_PRESSED) then
                repeat
                    pause_index = (pause_index-1)%#pause_options;
                until(not pause_options[pause_index+1].inactive);
                Sound.playSFX("pausemenu_cursor.ogg")
            elseif(player2.keys.left == KEYS_PRESSED) then
                player2.keys.left = KEYS_UNPRESSED
            elseif(player2.keys.right == KEYS_PRESSED) then
                player2.keys.right = KEYS_UNPRESSED
            elseif(player2.keys.jump == KEYS_PRESSED) then
                pause_options[pause_index+1].action();
                Misc.unpause();
            end
        end
    end
    if(pausemenu.paused_char and pause_options_char) then
        if(player.keys.down == KEYS_PRESSED) then
            repeat
                pause_index_char = (pause_index_char+1)%#pause_options_char;
            until(not pause_options_char[pause_index_char+1].inactive);
            Sound.playSFX("pausemenu_cursor.ogg")
        elseif(player.keys.up == KEYS_PRESSED) then
            repeat
                pause_index_char = (pause_index_char-1)%#pause_options_char;
            until(not pause_options_char[pause_index_char+1].inactive);
            Sound.playSFX("pausemenu_cursor.ogg")
        elseif(player.keys.left == KEYS_PRESSED) then
            player.keys.left = KEYS_UNPRESSED
        elseif(player.keys.right == KEYS_PRESSED) then
            player.keys.right = KEYS_UNPRESSED
        elseif(player.keys.jump == KEYS_PRESSED) then
            pause_options_char[pause_index_char+1].action();
            Misc.unpause();
        end
        if Player.count() >= 2 then
            if(player2.keys.down == KEYS_PRESSED) then
                repeat
                    pause_index_char = (pause_index_char+1)%#pause_options_char;
                until(not pause_options_char[pause_index_char+1].inactive);
                Sound.playSFX("pausemenu_cursor.ogg")
            elseif(player2.keys.up == KEYS_PRESSED) then
                repeat
                    pause_index_char = (pause_index_char-1)%#pause_options_char;
                until(not pause_options_char[pause_index_char+1].inactive);
                Sound.playSFX("pausemenu_cursor.ogg")
            elseif(player2.keys.left == KEYS_PRESSED) then
                player2.keys.left = KEYS_UNPRESSED
            elseif(player2.keys.right == KEYS_PRESSED) then
                player2.keys.right = KEYS_UNPRESSED
            elseif(player2.keys.jump == KEYS_PRESSED) then
                pause_options_char[pause_index_char+1].action();
                Misc.unpause();
            end
        end
    end
    if(pausemenu.paused_tele and pause_options_tele) then
        if(player.keys.down == KEYS_PRESSED) then
            repeat
                pause_index_tele = (pause_index_tele+1)%#pause_options_tele;
            until(not pause_options_tele[pause_index_tele+1].inactive);
            Sound.playSFX("pausemenu_cursor.ogg")
        elseif(player.keys.up == KEYS_PRESSED) then
            repeat
                pause_index_tele = (pause_index_tele-1)%#pause_options_tele;
            until(not pause_options_tele[pause_index_tele+1].inactive);
            Sound.playSFX("pausemenu_cursor.ogg")
        elseif(player.keys.left == KEYS_PRESSED) then
            player.keys.left = KEYS_UNPRESSED
        elseif(player.keys.right == KEYS_PRESSED) then
            player.keys.right = KEYS_UNPRESSED
        elseif(player.keys.jump == KEYS_PRESSED) then
            pause_options_tele[pause_index_tele+1].action();
            Misc.unpause();
        end
        if Player.count() >= 2 then
            if(player2.keys.down == KEYS_PRESSED) then
                repeat
                    pause_index_tele = (pause_index_tele+1)%#pause_options_tele;
                until(not pause_options_tele[pause_index_tele+1].inactive);
                Sound.playSFX("pausemenu_cursor.ogg")
            elseif(player2.keys.up == KEYS_PRESSED) then
                repeat
                    pause_index_tele = (pause_index_tele-1)%#pause_options_tele;
                until(not pause_options_tele[pause_index_tele+1].inactive);
                Sound.playSFX("pausemenu_cursor.ogg")
            elseif(player2.keys.left == KEYS_PRESSED) then
                player2.keys.left = KEYS_UNPRESSED
            elseif(player2.keys.right == KEYS_PRESSED) then
                player2.keys.right = KEYS_UNPRESSED
            elseif(player2.keys.jump == KEYS_PRESSED) then
                pause_options_tele[pause_index_tele+1].action();
                Misc.unpause();
            end
        end
    end
    if(pausemenu.paused_other and pause_options_other) then
        if(player.keys.down == KEYS_PRESSED) then
            repeat
                pause_index_other = (pause_index_other+1)%#pause_options_other;
            until(not pause_options_other[pause_index_other+1].inactive);
            Sound.playSFX("pausemenu_cursor.ogg")
        elseif(player.keys.up == KEYS_PRESSED) then
            repeat
                pause_index_other = (pause_index_other-1)%#pause_options_other;
            until(not pause_options_other[pause_index_other+1].inactive);
            Sound.playSFX("pausemenu_cursor.ogg")
        elseif(player.keys.left == KEYS_PRESSED) then
            player.keys.left = KEYS_UNPRESSED
        elseif(player.keys.right == KEYS_PRESSED) then
            player.keys.right = KEYS_UNPRESSED
        elseif(player.keys.jump == KEYS_PRESSED) then
            pause_options_other[pause_index_other+1].action();
            Misc.unpause();
        end
        if Player.count() >= 2 then
            if(player2.keys.down == KEYS_PRESSED) then
                repeat
                    pause_index_other = (pause_index_other+1)%#pause_options_other;
                until(not pause_options_other[pause_index_other+1].inactive);
                Sound.playSFX("pausemenu_cursor.ogg")
            elseif(player2.keys.up == KEYS_PRESSED) then
                repeat
                    pause_index_other = (pause_index_other-1)%#pause_options_other;
                until(not pause_options_other[pause_index_other+1].inactive);
                Sound.playSFX("pausemenu_cursor.ogg")
            elseif(player2.keys.left == KEYS_PRESSED) then
                player2.keys.left = KEYS_UNPRESSED
            elseif(player2.keys.right == KEYS_PRESSED) then
                player2.keys.right = KEYS_UNPRESSED
            elseif(player2.keys.jump == KEYS_PRESSED) then
                pause_options_other[pause_index_other+1].action();
                Misc.unpause();
            end
        end
    end
end

function pausemenu.onTick()
    if musicmuted == true then
        Audio.MusicVolume(0)
    end
    if musicmuted == false then
        if smasBooleans.musicMuted == true or smasBooleans.musicMuted == true or smasBooleans.musicMuted == true then
            Audio.MusicVolume(0)
        else
            Audio.MusicVolume(65)
        end
    end
    if(pausemenu.paused) then
        --Misc.pause();
    end
    if(pausemenu.paused_char) then
        if pause_index_char == 0 then
            pause_index_char = 1
        end
        if pause_options_char == 0 then
            pause_options_char = 1
        end
    end
    if(pausemenu.paused_tele) then
        if pause_index_tele == 0 then
            pause_index_tele = 1
        end
        if pause_options_tele == 0 then
            pause_options_tele = 1
        end
    end
    if(pausemenu.paused_other) then
        if pause_index_tele == 0 then
            pause_index_other = 1
        end
        if pause_options_other == 0 then
            pause_options_other = 1
        end
    end
    if pausemenu.pauseactivated == true then
        if player.pauseKeyPressing == false then
            player.pauseKeyPressing = true
        end
        if Player.count() >= 2 then
            if Player(2).pauseKeyPressing == false then
                Player(2).pauseKeyPressing = true
            end
        end
    end
    if pausemenu.pauseactivated == false then
        if player.pauseKeyPressing == true then
            player.pauseKeyPressing = false
        end
        if Player.count() >= 2 then
            if Player(2).pauseKeyPressing == true then
                Player(2).pauseKeyPressing = false
            end
        end
    end
end

function pausemenu.onExit()
    musicmuted = false
end

return pausemenu