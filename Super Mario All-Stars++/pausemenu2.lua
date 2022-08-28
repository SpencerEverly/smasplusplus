local pausemenu2 = {}

if Misc.inMarioChallenge() then return end

if GameData.____editorPowerupState == nil then
    GameData.____editorPowerupState = 1
end
if SaveData.enablePowerupReloadOnEditor == nil then
    SaveData.enablePowerupReloadOnEditor = false
end

local ready = false

local pauseplus = require("pauseplus")
local playerManager = require("playerManager")
local rng = require("rng")
local textplus = require("textplus")
local smashudsystem = require("smashudsystem")
--local musicalchairs = require("musicalchairs")
local extrasounds = require("extrasounds")
local sprite = require("base/sprite")
local smascharacterintros = require("smascharacterintros")
local exitFadeActive = false
local exitFadeActiveDone = false
local exitFadeOut = 0
local cooldown = 0

local battledependencies = require("classicbattlemode")
battledependencies.battlemodeactive = false

GameData.editorAreaStartingPoint = 0

if SaveData.toggleCostumeAbilities == nil then
    SaveData.toggleCostumeAbilities = true
end
if SaveData.toggleCostumeProfanity == nil then
    SaveData.toggleCostumeProfanity = false
end

local pausefont3 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")

function pausemenu2.onInitAPI()
    registerEvent(pausemenu2, "onKeyboardPress")
    registerEvent(pausemenu2, "onDraw")
    registerEvent(pausemenu2, "onLevelExit")
    registerEvent(pausemenu2, "onTick")
    registerEvent(pausemenu2, "onInputUpdate")
    registerEvent(pausemenu2, "onStart")
    registerEvent(pausemenu2, "onExit")
    registerEvent(pausemenu2, "onPause")
    registerEvent(pausemenu2, "onTickEnd")
    registerEvent(pausemenu2, "onPlayerKill")
    
    ready = true
end

local RESOLUTION_FULL = "Fullscreen (4:3)"
local RESOLUTION_WIDE = "Widescreen (16:9)"
local RESOLUTION_ULTRAWIDE = "Ultrawide (21:9)"
local RESOLUTION_NES = "NES/SNES/Genesis"
local RESOLUTION_GB = "Gameboy/Gameboy Color"
local RESOLUTION_GBA = "Gameboy Advance"
local RESOLUTION_IPHONEONE = "iPhone (1st Generation)"
local RESOLUTION_THREEDS = "Nintendo 3DS (Top Screen)"

local COSTUME_NAME = player:getCostume() or "N/A"

local POWERUP_SMALL = "Small"
local POWERUP_BIG = "Big"
local POWERUP_FIRE = "Fire Flower"
local POWERUP_LEAF = "Super Leaf"
local POWERUP_TANOOKI = "Tanooki Suit"
local POWERUP_HAMMER = "Hammer Suit"
local POWERUP_ICE = "Ice Flower"

local LETTERBOXYES = true
local LETTERBOXNO = false

resolutions = SaveData.resolution
letterboxes = SaveData.letterbox
costumenaming = player:getCostume()
powerupstate = player.powerup

local screenModes = {
    [RESOLUTION_FULL] = {resolutions = "fullscreen"},
    [RESOLUTION_WIDE] = {resolutions = "widescreen"},
    [RESOLUTION_ULTRAWIDE] = {resolutions = "ultrawide"},
    [RESOLUTION_NES] = {resolutions = "nes"},
    [RESOLUTION_GB] = {resolutions = "gameboy"},
    [RESOLUTION_GBA] = {resolutions = "gba"},
    [RESOLUTION_IPHONEONE] = {resolutions = "iphone1st"},
    [RESOLUTION_THREEDS] = {resolutions = "3ds"},
}

local powerupStates = {
    [POWERUP_SMALL] = {powerupstate = 1},
    [POWERUP_BIG] = {powerupstate = 2},
    [POWERUP_FIRE] = {powerupstate = 3},
    [POWERUP_LEAF] = {powerupstate = 4},
    [POWERUP_TANOOKI] = {powerupstate = 5},
    [POWERUP_HAMMER] = {powerupstate = 6},
    [POWERUP_ICE] = {powerupstate = 7},
}

local letterboxModes = {
    [LETTERBOXYES] = {letterboxes = true},
    [LETTERBOXNO] = {letterboxes = false},
}

local costumenames = {
    [COSTUME_NAME] = {costumenaming = "costume"},
}

function pausemenu2.onTick()
    
end

local function smb1hardmodetoggle()
    if pauseplus.getSelectionValue("miscsettings","Enable SMB1 Hard Mode") then
        SaveData.SMB1HardModeActivated = true
    else
        SaveData.SMB1HardModeActivated = false
    end
end

local function smb1allnightnipponoggle()
    if pauseplus.getSelectionValue("miscsettings","Enable All Night Nippon Mode") then
        SaveData.SMB1LLAllNightNipponActivated = true
    else
        SaveData.SMB1LLAllNightNipponActivated = false
    end
end

local function wsmbaoriginalgraphicsoggle()
    if pauseplus.getSelectionValue("miscsettings","Enable Original WSMBA Mode") then
        SaveData.WSMBAOriginalGraphicsActivated = true
    else
        SaveData.WSMBAOriginalGraphicsActivated = false
    end
end

local function changeresolution()
    Sound.playSFX("resolution-set.ogg")
    screenModes = pauseplus.getSelectionValue("resolutionsettings","Switch Resolution")
    if screenModes == RESOLUTION_FULL then
        SaveData.resolution = "fullscreen"
    elseif screenModes == RESOLUTION_WIDE then
        SaveData.resolution = "widescreen"
    elseif screenModes == RESOLUTION_ULTRAWIDE then
        SaveData.resolution = "ultrawide"
    elseif screenModes == RESOLUTION_NES then
        SaveData.resolution = "nes"
    elseif screenModes == RESOLUTION_GBA then
        SaveData.resolution = "gba"
    elseif screenModes == RESOLUTION_THREEDS then
        SaveData.resolution = "3ds"
    end
end

local function changeresolutionborder()
    if pauseplus.getSelectionValue("resolutionsettings","Disable Resolution Border") then
        Sound.playSFX("resolutionborder-disable.ogg")
        SaveData.borderEnabled = false
    else
        Sound.playSFX("resolutionborder-enable.ogg")
        SaveData.borderEnabled = true
    end
end

local sectionNumberArea

local function debugpowerup()
    Sound.playSFX("console/console_info.ogg")
    powerupStates = pauseplus.getSelectionValue("editormenu","Choose Powerup")
    for k,p in ipairs(Player.get()) do
        if powerupStates == POWERUP_SMALL then
            p.powerup = 1
            GameData.____editorPowerupState = player.powerup
        elseif powerupStates == POWERUP_BIG then
            p.powerup = 2
            GameData.____editorPowerupState = player.powerup
        elseif powerupStates == POWERUP_FIRE then
            p.powerup = 3
            GameData.____editorPowerupState = player.powerup
        elseif powerupStates == POWERUP_LEAF then
            p.powerup = 4
            GameData.____editorPowerupState = player.powerup
        elseif powerupStates == POWERUP_TANOOKI then
            p.powerup = 5
            GameData.____editorPowerupState = player.powerup
        elseif powerupStates == POWERUP_HAMMER then
            p.powerup = 6
            GameData.____editorPowerupState = player.powerup
        elseif powerupStates == POWERUP_ICE then
            p.powerup = 7
            GameData.____editorPowerupState = player.powerup
        end
    end
end

local reloadChooser

if SaveData.editorWinnerLevelReload == nil then
    SaveData.editorWinnerLevelReload = "map.lvlx"
end

if SaveData.reloadLevelFilenameInEditor == nil then
    SaveData.reloadLevelFilenameInEditor = false
end

local function editorreloadchooser()
    Sound.playSFX("console/console_info.ogg")
    reloadChooser = pauseplus.getSelectionValue("editormenu","Reload on Level Win Exit to")
    if reloadChooser == "World Map" then
        SaveData.reloadLevelFilenameInEditor = false
        SaveData.editorWinnerLevelReload = "map.lvlx"
    elseif reloadChooser == "Restart Level" then
        SaveData.reloadLevelFilenameInEditor = true
        SaveData.editorWinnerLevelReload = Level.filename()
    elseif reloadChooser == "Boot Menu" then
        SaveData.reloadLevelFilenameInEditor = false
        SaveData.editorWinnerLevelReload = "SMAS - Start.lvlx"
    end
end

local function toggleeditorpowerupstate()
    if pauseplus.getSelectionValue("editormenu","Reload with Selected Powerup") then
        SaveData.enablePowerupReloadOnEditor = true
    else
        SaveData.enablePowerupReloadOnEditor = false
    end
end

local function changeletterbox()
    if pauseplus.getSelectionValue("resolutionsettings","Enable Letterbox Scaling") then
        Sound.playSFX("letterbox-disable.ogg")
        SaveData.letterbox = false
    else
        Sound.playSFX("letterbox-enable.ogg")
        SaveData.letterbox = true
    end
end

local function togglepwingsfx()
    if pauseplus.getSelectionValue("soundsettings","Disable P-Wing Sound") then
        SaveData.disablePWingSFX = true
        extrasounds.enablePWingSFX = false
    else
        SaveData.disablePWingSFX = false
        extrasounds.enablePWingSFX = true
    end
end

local function smbxdefaultsoundsystem()
    if pauseplus.getSelectionValue("soundsettings","Use the Original SMBX Sound System") then
        SaveData.SMBXSoundSystem = true
        extrasounds.enableGrabShellSFX = false
        extrasounds.playPSwitchTimerSFX = false
        extrasounds.enableSMB2EnemyKillSounds = false
        extrasounds.useOriginalSpinJumpForBigEnemies = true
        extrasounds.enableHPCollecting = false
        extrasounds.useOriginalDragonCoinSounds = true
        extrasounds.useOriginalBowserFireballInstead = true
        extrasounds.enableIceBlockBreaking = false
        extrasounds.useOriginalBlockSproutInstead = true
        extrasounds.useFireworksInsteadOfOtherExplosions = true
        extrasounds.use1UPSoundForAll1UPs = true
        extrasounds.useJumpSoundInsteadWhenUnmountingYoshi = true
        extrasounds.enableBoomerangBroBoomerangSFX = false
        extrasounds.enableToadBoomerangSFX = false
        extrasounds.useFireSoundForHammerSuit = true
        extrasounds.useFireSoundForIce = true
        extrasounds.enableIceMeltingSFX = false
    else
        SaveData.SMBXSoundSystem = false
        extrasounds.enableGrabShellSFX = true
        extrasounds.playPSwitchTimerSFX = true
        extrasounds.enableSMB2EnemyKillSounds = true
        extrasounds.useOriginalSpinJumpForBigEnemies = false
        extrasounds.enableHPCollecting = true
        extrasounds.useOriginalDragonCoinSounds = false
        extrasounds.useOriginalBowserFireballInstead = false
        extrasounds.enableIceBlockBreaking = true
        extrasounds.useOriginalBlockSproutInstead = false
        extrasounds.useFireworksInsteadOfOtherExplosions = false
        extrasounds.use1UPSoundForAll1UPs = false
        extrasounds.useJumpSoundInsteadWhenUnmountingYoshi = false
        extrasounds.enableBoomerangBroBoomerangSFX = true
        extrasounds.enableToadBoomerangSFX = true
        extrasounds.useFireSoundForHammerSuit = false
        extrasounds.useFireSoundForIce = false
        extrasounds.enableIceMeltingSFX = true
    end
end

local function toggleabilitiescost()
    if pauseplus.getSelectionValue("costumeoptions","Disable Abilities") then
        SaveData.toggleCostumeAbilities = false
    else
        SaveData.toggleCostumeAbilities = true
    end
end

local function toggleprofanecostume()
    if pauseplus.getSelectionValue("costumeoptions","Enable Profane Voices") then
        SaveData.toggleCostumeProfanity = true
    else
        SaveData.toggleCostumeProfanity = false
    end
end

local function toggleintroscostume()
    if pauseplus.getSelectionValue("costumeoptions","Skip Character Intros") then
        SaveData.enableIntros = false
    else
        SaveData.enableIntros = true
    end
end


local function unlockbrokenpaths()
    Sound.playSFX(27)
    Misc.unlockAnyBrokenPaths()
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
    --Routine.run(musicalchairs.switcher)
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
    if Player.count() >= 2 then
        local character = Player(2).character;
        if (character == CHARACTER_MARIO) then
            Player(2):transform(2, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
        if (character == CHARACTER_LUIGI) then
            Player(2):transform(3, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
        if (character == CHARACTER_PEACH) then
            Player(2):transform(4, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
        if (character == CHARACTER_TOAD) then
            Player(2):transform(5, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
        if (character == CHARACTER_LINK) then
            Player(2):transform(1, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
    else
        Sound.playSFX("wrong.ogg")
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
    --Routine.run(musicalchairs.switcher)
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
    if Player.count() >= 2 then
        local character = Player(2).character
        if (character == CHARACTER_MARIO) then
            Player(2):transform(5, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
        if (character == CHARACTER_LUIGI) then
            Player(2):transform(1, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
        if (character == CHARACTER_PEACH) then
            Player(2):transform(2, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
        if (character == CHARACTER_TOAD) then
            Player(2):transform(3, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
        if (character == CHARACTER_LINK) then
            Player(2):transform(4, false)
            SFX.play(32)
            Sound.playSFX("charcost-selected.ogg")
            Sound.playSFX("racoon-changechar.ogg")
        end
    else
        Sound.playSFX("wrong.ogg")
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
    Sound.playSFX("charcost_costume.ogg")
    Sound.playSFX("charcost-selected.ogg")
    --Routine.run(musicalchairs.switcher)
end

local function costumechangeleft()
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()
    local costumeIdx = table.ifind(costumes,currentCostume)
    local costumeIdxLast = #costumes
    
    if costumeIdx <= 1 then
        player:setCostume(costumes[costumeIdxLast])
    elseif costumeIdx ~= nil then
        player:setCostume(costumes[costumeIdx - 1])
    else
        player:setCostume(costumes[costumeIdxLast])
    end
    Sound.playSFX("charcost_costume.ogg")
    Sound.playSFX("charcost-selected.ogg")
    --Routine.run(musicalchairs.switcher)
end

local function enable2player()
    Sound.playSFX(1001)
    Cheats.trigger("2player")
end

local function disable2player()
    Sound.playSFX(1001)
    mem(0x00B2595E, FIELD_WORD, 1)
end

function pausemenu2.onDraw()
    if smasbooleans.musicMuted and not smasbooleans.overrideMusicVolume then
        Audio.MusicVolume(0)
    elseif not smasbooleans.musicMuted and not smasbooleans.overrideMusicVolume then
        Audio.MusicVolume(pauseplus.getSelectionValue("soundsettings","Music Volume"))
    end
    GameData.____currentMusicVolume = pauseplus.getSelectionValue("soundsettings","Music Volume")
    GameData.____sfxVolume = pauseplus.getSelectionValue("soundsettings","SFX Volume")
    for i = 1, 91 do
        Audio.sounds[i].sfx.volume = math.floor(GameData.____sfxVolume * 128 + 0.5)
        if extrasounds.active == true then
            if Audio.sounds[43].muted then
                Audio.sounds[43].sfx.volume = 0
            end
        end
    end
    SFX.volume.MASTER = GameData.____sfxVolume
    sectionNumberArea = pauseplus.getSelectionValue("editormenu","Select Area")
    if sectionNumberArea == 0 then
        GameData.editorAreaStartingPoint = 0
    else
        for i = 1, Warp.count() do
            if sectionNumberArea == i then
                GameData.editorAreaStartingPoint = i
            end
        end
    end
    if SaveData.reloadLevelFilenameInEditor then
        SaveData.editorWinnerLevelReload = Level.filename()
    end
    if exitFadeActive then
        Audio.MusicVolume(0)
        Misc.pause(true)
        exitFadeOut = math.min(1, exitFadeOut + 0.05)
        Graphics.drawScreen{color = Color.black.. exitFadeOut,priority = 10}
    end
    if exitFadeActiveDone then
        Graphics.drawScreen{color = Color.black,priority = 10}
    end
    local currentCostume = player:getCostume()
    if currentCostume then
        costtext = currentCostume
    end
    
    
    if currentCostume == "!DEFAULT" then
        costtext = "Default (SMAS++)"
    end
    if currentCostume == "!DEFAULT-ORIGINAL" then
        costtext = "Default (SMBX 1.3)"
    end
    if currentCostume == "!DEFAULT-38A" then
        costtext = "Default (SMBX 1.4.5)"
    end
    
    
    if currentCostume == "00-SMASPLUSPLUS-BETA" then
        costtext = "SMAS++ 2012 Beta Mario"
    end
    if currentCostume == "01-SMB1-RETRO" then
        costtext = "Super Mario Bros. (NES)"
    end
    if currentCostume == "02-SMB1-RECOLORED" then
        costtext = "Super Mario Bros. (Recolored)"
    end
    if currentCostume == "03-SMB1-SMAS" then
        costtext = "Super Mario Bros. (SNES)"
    end
    if currentCostume == "04-SMB2-RETRO" then
        costtext = "Super Mario Bros. 2 (NES)"
    end
    if currentCostume == "05-SMB2-SMAS" then
        costtext = "Super Mario Bros. 2 (SNES)"
    end
    if currentCostume == "06-SMB3-RETRO" then
        costtext = "Super Mario Bros. 3 (NES)"
    end
    if currentCostume == "07-SML2" then
        costtext = "Super Mario Land 2 (GB)"
    end
    if currentCostume == "08-SMBSPECIAL" then
        costtext = "Super Mario Bros. Special (PC-88/Sharp X1)"
    end
    if currentCostume == "09-SMW-PIRATE" then
        costtext = "Super Mario World (NES, Bootleg)"
    end
    if currentCostume == "11-SMA1" then
        costtext = "Super Mario Advance 1 (GBA)"
    end
    if currentCostume == "12-SMA2" then
        costtext = "Super Mario Advance 2 (GBA)"
    end
    if currentCostume == "13-SMA4" then
        costtext = "Super Mario Advance 4 (GBA)"
    end
    if currentCostume == "14-NSMBDS-SMBX" then
        costtext = "New Super Mario Bros. (SMBX)"
    end
    if currentCostume == "15-NSMBDS-ORIGINAL" then
        costtext = "New Super Mario Bros. (NDS)"
    end
    if currentCostume == "16-NSMBWII-MARIO" then
        costtext = "New Super Mario Bros. Wii (Wii)"
    end
    if currentCostume == "A2XT-DEMO" then
        costtext = "Demo (A2XT)"
    end
    if currentCostume == "DEMO-XMASPILY" then
        costtext = "Pily (A2XT: Gaiden 2)"
    end
    if currentCostume == "GA-CAILLOU" then
        costtext = "Caillou (GoAnimate, Vyond)"
    end
    if currentCostume == "GO-10SECONDRUN" then
        costtext = "10 Second Run (GO Series)"
    end
    if currentCostume == "GOLDENMARIO" then
        costtext = "Golden Mario (SMBX)"
    end
    if currentCostume == "GOOMBA" then
        costtext = "Goomba (SMBX)"
    end
    if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
        costtext = "JC Foster Takes it to the Moon"
    end
    if currentCostume == "MARINK" then
        costtext = "The Legend of Mario (SMBX)"
    end
    if currentCostume == "MODERN" then
        costtext = "Modern Mario Bros."
    end
    if currentCostume == "MODERN2" then
        costtext = "Super Mario World: Mario Enhanced"
    end
    if currentCostume == "PRINCESSRESCUE" then
        costtext = "Princess Rescue (Atari 2600)"
    end
    if currentCostume == "ROSALINA" then
        costtext = "Rosalina"
    end
    if currentCostume == "SMB0" then
        costtext = "Super Mario Bros. 0 (SMBX)"
    end
    if currentCostume == "SMBDDX-MARIO" then
        costtext = "Super Mario Bros. DDX (Guinea)"
    end
    if currentCostume == "SMG4" then
        costtext = "SuperMarioGlitchy4 (YouTube)"
    end
    if currentCostume == "SMM2-MARIO" then
        costtext = "Super Mario Maker (SMW, Mario)"
    end
    if currentCostume == "SMM2-LUIGI" then
        costtext = "Super Mario Maker (SMW, Luigi)"
    end
    if currentCostume == "SMM2-TOAD" then
        costtext = "Super Mario Maker (SMW, Toad)"
    end
    if currentCostume == "SMM2-TOADETTE" then
        costtext = "Super Mario Maker (SMW, Toadette)"
    end
    if currentCostume == "SMM2-YELLOWTOAD" then
        costtext = "Super Mario Maker (SMW, Yellow Toad)"
    end
    if currentCostume == "SMW-MARIO" then
        costtext = "Super Mario World (SNES)"
    end
    if currentCostume == "SP-1-ERICCARTMAN" then
        costtext = "Eric Cartman (South Park)"
    end
    if currentCostume == "SPONGEBOBSQUAREPANTS" then
        costtext = "SpongeBob SquarePants"
    end
    if currentCostume == "Z-SMW2-ADULTMARIO" then
        costtext = "Super Mario World 2 (SNES)"
    end
    
    
    
    
    
    
    if currentCostume == "00-SPENCEREVERLY" then
        costtext = "Spencer Everly (SMBS)"
    end
    if currentCostume == "03-SMB1-RETRO-MODERN" then
        costtext = "Super Mario Bros. (NES, Modern)"
    end
    if currentCostume == "04-SMB1-SMAS" then
        costtext = "Super Mario Bros. (SNES)"
    end
    if currentCostume == "05-SMB2-RETRO" then
        costtext = "Super Mario Bros. 2 (NES)"
    end
    if currentCostume == "06-SMB2-SMAS" then
        costtext = "Super Mario Bros. 2 (SNES)"
    end
    if currentCostume == "07-SMB3-RETRO" then
        costtext = "Super Mario Bros. 3 (NES)"
    end
    if currentCostume == "09-SMB3-MARIOCLOTHES" then
        costtext = "Marigi"
    end
    if currentCostume == "10-SMW-ORIGINAL" then
        costtext = "Super Mario World (SNES)"
    end
    if currentCostume == "13-SMBDX" then
        costtext = "Super Mario Bros. Deluxe (GBC)"
    end
    if currentCostume == "15-SMA2" then
        costtext = "Super Mario Advance 2 (GBA)"
    end
    if currentCostume == "16-SMA4" then
        costtext = "Super Mario Advance 4 (GBA)"
    end
    if currentCostume == "17-NSMBDS-SMBX" then
        costtext = "New Super Mario Bros. (SMBX)"
    end
    if currentCostume == "A2XT-IRIS" then
        costtext = "Iris (A2XT)"
    end
    if currentCostume == "GA-BORIS" then
        costtext = "Boris (GoAnimate, Vyond)"
    end
    if currentCostume == "LARRYTHECUCUMBER" then
        costtext = "Larry (VeggieTales)"
    end
    if currentCostume == "UNDERTALE-FRISK" then
        costtext = "Frisk (Undertale)"
    end
    if currentCostume == "WALUIGI" then
        costtext = "Waluigi"
    end
    if currentCostume == "SMW-LUIGI" then
        costtext = "Super Mario World (SMAS)"
    end
    
    
    
    
    
    
    if currentCostume == "02-SMB1-SMAS" then
        costtext = "Super Mario Bros. (SNES)"
    end
    if currentCostume == "A2XT-KOOD" then
        costtext = "Kood (A2XT)"
    end
    if currentCostume == "DAISY" then
        costtext = "Daisy"
    end
    if currentCostume == "KIRBY-SMB3" then
        costtext = "Kirby (SMB3)"
    end
    if currentCostume == "NINJABOMBERMAN" then
        costtext = "Plunder Bomber"
    end
    if currentCostume == "PAULINE" then
        costtext = "Pauline"
    end
    if currentCostume == "SMA4" then
        costtext = "Super Mario Advance 4 (GBA)"
    end
    if currentCostume == "SMB3-WALUIGI" then
        costtext = "Waluigi (SMB3)"
    end
    if currentCostume == "SMW-PEACH" then
        costtext = "Super Mario World (SNES)"
    end
    
    
    
    
    
    if currentCostume == "03-SMB2-RETRO" then
        costtext = "Super Mario Bros. 2 (NES, Blue)"
    end
    if currentCostume == "04-SMB2-RETRO-YELLOW" then
        costtext = "Super Mario Bros. 2 (NES, Yellow)"
    end
    if currentCostume == "05-SMB2-RETRO-RED" then
        costtext = "Super Mario Bros. 2 (NES, Red)"
    end
    if currentCostume == "06-SMB3-BLUE" then
        costtext = "Super Mario Bros. 3 (SNES, Blue)"
    end
    if currentCostume == "07-SMB3-YELLOW" then
        costtext = "Super Mario Bros. 3 (SNES, Yellow)"
    end
    if currentCostume == "A2XT-RAOCOW" then
        costtext = "Raocow (A2XT)"
    end
    if currentCostume == "CAPTAINTOAD" then
        costtext = "Captain Toad (SNES)"
    end
    if currentCostume == "DIGDUG-DIGGINGSTRIKE" then
        costtext = "Taizo (Dig Dug: Digging Strike)"
    end
    if currentCostume == "HAMTARO" then
        costtext = "Hamtaro"
    end
    if currentCostume == "IMAJIN-NES" then
        costtext = "Imajin (DDP)"
    end
    if currentCostume == "JASMINE" then
        costtext = "Jasmine (SEE)"
    end
    if currentCostume == "LEGOSTARWARS-REBELTROOPER" then
        costtext = "Rebel Trooper (LEGO Star Wars)"
    end
    if currentCostume == "MOTHERBRAINRINKA" then
        costtext = "Mother Brain Rinka"
    end
    if currentCostume == "PACMAN-ARRANGEMENT-PACMAN" then
        costtext = "PAC-MAN (Pac-Man Arrangement 1996)"
    end
    if currentCostume == "SEE-TANGENT" then
        costtext = "Tangent Everly (SEE)"
    end
    if currentCostume == "SONIC" then
        costtext = "Sonic the Hedgehog"
    end
    if currentCostume == "TOADETTE" then
        costtext = "Toadette"
    end
    if currentCostume == "ULTIMATERINKA" then
        costtext = "Ultimate Rinka (SMBX2)"
    end
    if currentCostume == "YOSHI-SMB3" then
        costtext = "Yoshi (SMB3)"
    end
    
    
    
    
    if currentCostume == "01-ZELDA1-NES" then
        costtext = "The Legend of Zelda (NES)"
    end
    if currentCostume == "05-LINKWAKE-SNES" then
        costtext = "Link's Awakening (SNES)"
    end
    if currentCostume == "A2XT-SHEATH" then
        costtext = "Sheath (A2XT)"
    end
    if currentCostume == "MOTHER3-LUCAS" then
        costtext = "Lucas (MOTHER 3)"
    end
    if currentCostume == "NESS" then
        costtext = "Ness (EarthBound)"
    end
    if currentCostume == "SEE-SHERBERTLUSSIEBACK" then
        costtext = "Sherbert Lussieback (S!TS! REBOOT)"
    end
    if currentCostume == "SMB1-SNES" then
        costtext = "Super Mario Bros. (SNES)"
    end
    if currentCostume == "SMB2-SNES" then
        costtext = "Super Mario Bros. 2 (SNES)"
    end
    if currentCostume == "SMB3-BANDANA-DEE" then
        costtext = "Bandana Dee (SMB3)"
    end
    if currentCostume == "TAKESHI" then
        costtext = "Takeshi's Challenge (NES)"
    end
    if currentCostume == "TAKESHI-SNES" then
        costtext = "Takeshi's Challenge (SNES)"
    end
    
    
    
    
    
    if currentCostume == nil then
        costtext = "Default (SMBX)"
    end
    
    
    
    
    
    
    if pauseplus.currentSubmenu then
        if not isOverworld then
            textplus.print{x = 20, y = 570, text = "<color red>Current costume: "..costtext.."</color>", font = pausefont3, priority = -1.4, xscale = 1.5, yscale = 1.5}
            if SaveData.playerPfp == nil then
                sprite.draw{texture = Img.load("pfp/pfp.png"), width = 70, height = 70, x = 20, y = 490, priority = -1.7}
            elseif SaveData.playerPfp then
                sprite.draw{texture = Img.load("___MainUserDirectory/"..SaveData.playerPfp..""), width = 70, height = 70, x = 20, y = 490, priority = -1.7}
            elseif unexpected_condition then
                sprite.draw{texture = Img.load("pfp/pfp.png"), width = 70, height = 70, x = 20, y = 490, priority = -1.7}
            end
            if SaveData.playerName == nil then
                textplus.print{x = 105, y = 518, text = "<color rainbow>Player</color>", font = pausefont3, priority = 0, xscale = 1.5, yscale = 1.5}
            else
                textplus.print{x = 105, y = 518, text = "<color rainbow>"..SaveData.playerName.."</color>", font = pausefont3, priority = -1.4, xscale = 1.5, yscale = 1.5}
            end
        end
    end
end

local function purgesavedata()
    pauseplus.canControlMenu = false
    Sound.playSFX(67)
    startFadeOut()
    Routine.wait(2, true)
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    Misc.eraseSaveSlot(Misc.saveSlot())
    Misc.dialog("There WILL be a few errors before restarting. This is normal. Just click okay (Or press ENTER) on all dialog boxes that pop up, and the episode will restart.")
    SaveData.clear()
    GameData.clear()
    SaveData.flush()
    if Misc.loadEpisode("Super Mario All-Stars++") == false then
        SFX.play("wrong.ogg")
        error("SMAS++ is not found. How is that even possible? Reinstall the game using the SMASUpdater, since something has gone terribly wrong.")
    end
end

local function checkingplayerstatus()
    if player.count() == 1 then
        Sound.playSFX(1001)
        Sound.playSFX(152)
    elseif player.count() >= 2 then
        Sound.playSFX(1001)
        Playur.activate1stPlayer()
        player:mem(0x11E,FIELD_BOOL,false)
        if cooldown <= 0 then
            player:mem(0x11E,FIELD_BOOL,true)
        end
    end
end

local function checkingplayerstatus13()
    if Player.count() == 1 then
        Sound.playSFX(1001)
        Playur.activate2ndPlayer()
        cooldown = 5
        player:mem(0x11E,FIELD_BOOL,false)
        if cooldown <= 0 then
            player:mem(0x11E,FIELD_BOOL,true)
        end
    elseif Player.count() == 2 then
        Sound.playSFX(1001)
        Playur.activate1stPlayer()
        player:mem(0x11E,FIELD_BOOL,false)
        if cooldown <= 0 then
            player:mem(0x11E,FIELD_BOOL,true)
        end
    elseif Player.count() >= 3 then
        Sound.playSFX(1001)
        Playur.activate1stPlayer()
        player:mem(0x11E,FIELD_BOOL,false)
        if cooldown <= 0 then
            player:mem(0x11E,FIELD_BOOL,true)
        end
    end
end

function battlemodenewstage()
    pauseplus.canControlMenu = false
    Sound.playSFX("skip-intro.ogg")
    startFadeOut()
    Routine.wait(1.5, true)
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    Level.load(smastables.__classicBattleModeLevels[rng.randomInt(1,#smastables.__classicBattleModeLevels)], nil, nil)
end

function battlemodeexit()
    pauseplus.canControlMenu = false
    Sound.playSFX("world_warp.ogg")
    startFadeOut()
    Routine.wait(0.8, true)
    Misc.unpause()
    GameData.rushModeActive = false
    battledependencies.battlemodeactive = false
    exitFadeActive = false
    exitFadeActiveDone = true
    Playur.setBattleLives(0)
    Playur.activate1stPlayer()
    Level.load("SMAS - Start.lvlx", nil, nil)
end

function rushmodenewstage()
    pauseplus.canControlMenu = false
    Sound.playSFX("skip-intro.ogg")
    startFadeOut()
    Routine.wait(1.5, true)
    Misc.unpause()
    GameData.rushModeWon = false
    exitFadeActive = false
    exitFadeActiveDone = true
    Level.load(smastables.__allMandatoryLevels[rng.randomInt(1,#smastables.__allMandatoryLevels)], nil, nil)
end

function returntolastlevel()
    pauseplus.canControlMenu = false
    Sound.playSFX("lastlevel_warp.ogg")
    startFadeOut()
    Misc.saveGame()
    Routine.wait(1.3,true)
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    Level.load(SaveData.lastLevelPlayed, nil, nil)
end

local function exitlevel2()
    pauseplus.canControlMenu = false
    Audio.MusicVolume(0)
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    Sound.playSFX("world_warp.ogg")
    startFadeOut()
    Misc.saveGame()
    Routine.wait(0.7, true)
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    smasbooleans.musicMuted = false
    Level.load("map.lvlx")
end

function saveAndQuitRoutine()
    pauseplus.canControlMenu = false
    Sound.playSFX("savequit.ogg")
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    startFadeOut()
    Misc.saveGame()
    Routine.wait(1.6,true)
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    Misc.exitEngine()
end

function quitonly()
    pauseplus.canControlMenu = false
    Sound.playSFX("nosave.ogg")
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    startFadeOut()
    Routine.wait(0.7,true)
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    Misc.exitEngine()
end

function onethreemodeactivate()
    pauseplus.canControlMenu = false
    if SaveData.disableX2char == false then
        Sound.playSFX("1.3Mode/dragon-coin.ogg")
        Sound.playSFX("1.3Mode/key.ogg")
    elseif SaveData.disableX2char == true then
        Sound.playSFX("dragon-coin.ogg")
        Sound.playSFX("key.ogg")
    end
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    startFadeOut()
    Misc.saveGame()
    Routine.wait(2.3,true)
    SaveData.disableX2char = not SaveData.disableX2char
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    Graphics.activateHud(false)
    Playur.activate1stPlayer()
    player:transform(1, false)
    Level.load(Level.filename())
end

function startFadeOut()
    exitFadeActive = true
end

function restartlevel()
    pauseplus.canControlMenu = false
    Sound.playSFX("skip-intro.ogg")
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    Misc.saveGame()
    startFadeOut()
    Routine.wait(1.6,true)
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    smasbooleans.musicMuted = false
    Level.load(Level.filename())
end

function mainmenu()
    pauseplus.canControlMenu = false
    Sound.playSFX("shutdown.ogg")
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    startFadeOut()
    Misc.saveGame()
    Routine.wait(2.4, true)
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    Level.load("SMAS - Start.lvlx", nil, nil)
end

local function warpzonehub()
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(20496, 19520, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(20454, 19520, bottomCenterAligned)
    end
end

local function touristhub()
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(-119968, -120128, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(-120010, -120128, bottomCenterAligned)
    end
end

local function starthub()
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(-200608, -200126, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(-200650, -200126, bottomCenterAligned)
    end
end

local function switchhub()
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(40176, 39876, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(40134, 39876, bottomCenterAligned)
    end
end

local function shophub()
    Misc.unpause()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    player:teleport(80144, 79868, bottomCenterAligned)
    if Player.count() >= 2 then
        Player(2):teleport(80102, 79868, bottomCenterAligned)
    end
end

local function hubteleportlevel()
    cooldown = 5
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    Sound.playSFX("hub_travelactivated.ogg")
    Sound.playSFX("world_warp.ogg")
    pauseplus.canControlMenu = false
    startFadeOut()
    Routine.wait(1.0, true)
    Misc.unpause()
    exitFadeActive = false
    exitFadeActiveDone = true
    Level.load("MALC - HUB.lvlx", nil, nil)
end

local function startteleport()
    cooldown = 5
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    Sound.playSFX("hub_travelactivated.ogg")
    SaveData.smwMap.playerX = -195072
    SaveData.smwMap.playerY = -197760
    smwMap.initPlayers()
    Sound.playSFX("world_warp.ogg")
    Misc.unpause()
end

local function sideteleport()
    cooldown = 5
    Misc.unpause()
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    Sound.playSFX("hub_travelactivated.ogg")
    SaveData.smwMap.playerX = -195616
    SaveData.smwMap.playerY = -196736
    Sound.playSFX("world_warp.ogg")
    smwMap.initPlayers()
    Misc.unpause()
end

local function hubmapteleport()
    cooldown = 5
    Misc.unpause()
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    Sound.playSFX("hub_travelactivated.ogg")
    SaveData.smwMap.playerX = -195232
    SaveData.smwMap.playerY = -197856
    Sound.playSFX("world_warp.ogg")
    smwMap.initPlayers()
    Misc.unpause()
end

local function dlcteleport()
    cooldown = 5
    Misc.unpause()
    player:mem(0x17A,FIELD_BOOL,false)
    if cooldown <= 0 then
        player:mem(0x17A,FIELD_BOOL,true)
    end
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    Sound.playSFX("hub_travelactivated.ogg")
    SaveData.smwMap.playerX = -199584
    SaveData.smwMap.playerY = -196768
    Sound.playSFX("world_warp.ogg")
    smwMap.initPlayers()
    Misc.unpause()
end

--Main Menu
function pausemenu2.onStart()
    if Misc.inEditor() then
        for _,p in ipairs(Player.get()) do
            if SaveData.enablePowerupReloadOnEditor then
                p.powerup = GameData.____editorPowerupState
            end
        end
    end
    pauseplus.font = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")
    pauseplus.scale = 1.5
    pauseplus.priority = -3.5
    pauseplus.doResizing = true
    pauseplus.optionGap = 4
    pauseplus.offset = vector(0,0)
    pauseplus.horizontalSpace = 59
    pauseplus.verticalSpace   = 16
    pauseplus.backgroundDarkness = 0
    pauseplus.createSubmenu("main",{headerText = "<size 1.5>Paused.</size>"})
    pauseplus.createOption("main",{text = "Continue",closeMenu = true,description = "Continue the game.",action = function() Sound.playSFX("pausemenu-closed.ogg") end})
    if battledependencies.battlemodeactive then
        if not isOverworld then
            pauseplus.createOption("main",{text = "Start a New Stage",closeMenu = true,description = "Starts a new stage in Classic Battle Mode. The stage will be picked at random!",action = function() Routine.run(battlemodenewstage) end})
            pauseplus.createOption("main",{text = "Restart this Stage",closeMenu = true,description = "Restarts the same stage over. Useful if you're stuck somewhere and need to restart the match.",action = function() Routine.run(restartlevel) end})
            pauseplus.createSubmenu("settings",{headerText = "<size 1.5>Settings/Options</size>"})
            pauseplus.createOption("settings",{text = "Music Volume",description = "Turn the music volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 60,selectionMin = 0,selectionMax = 100,selectionStep = 5,selectionFormat = "%d%%"})
            pauseplus.createOption("settings",{text = "SFX Volume",description = "Turn the sound effect volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 1,selectionMin = 0,selectionMax = 1,selectionStep = 0.1,selectionFormat = "%d%%"})
            pauseplus.createOption("main",{text = "Exit Battle Mode",closeMenu = true,description = "To exit battle mode, use this option. This will reset the game back to the preboot menu.",action = function() Routine.run(battlemodeexit) end})
        end
    end
    if GameData.rushModeActive == true then
        if not isOverworld then
            pauseplus.createOption("main",{text = "Start a New Stage",closeMenu = true,description = "Starts a new stage in Rush Mode. The stage will be picked at random!",action = function() Routine.run(rushmodenewstage) end})
            pauseplus.createOption("main",{text = "Restart this Stage",closeMenu = true,description = "Restarts the same stage over. Useful if you're stuck somewhere.",action = function() Routine.run(restartlevel) end})
            pauseplus.createSubmenu("settings",{headerText = "<size 1.5>Settings/Options</size>"})
            pauseplus.createOption("settings",{text = "Music Volume",description = "Turn the music volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 60,selectionMin = 0,selectionMax = 100,selectionStep = 5,selectionFormat = "%d%%"})
            pauseplus.createOption("settings",{text = "SFX Volume",description = "Turn the sound effect volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 1,selectionMin = 0,selectionMax = 1,selectionStep = 0.1,selectionFormat = "%d%%"})
            pauseplus.createOption("main",{text = "Exit Rush Mode",closeMenu = true,description = "To exit Rush Mode, use this option. This will reset the game back to the preboot menu.",action = function() Routine.run(battlemodeexit) end})
        end
    end
    if not battledependencies.battlemodeactive then
        if GameData.rushModeActive == nil or GameData.rushModeActive == false then
            if Misc.inMarioChallenge() == false then
                pauseplus.createSubmenu("editormenu",{headerText = "<size 1.5>Editor Menu</size>"})
                if Misc.inEditor() then
                    pauseplus.createOption("main",{text = "Editor Menu",goToSubmenu = "editormenu",description = "Testing 1-2-3! If testing the game, this menu is for you!"})
                end
                if (Level.filename() == "map.lvlx") == false then
                    pauseplus.createOption("main",{text = "Restart",closeMenu = true,description = "Restart the area you're currently in. You'll warp back to the last checkpoint if crossed one.", action = function() Routine.run(restartlevel) end})
                end
                if (Level.filename() == "map.lvlx") == false then
                    pauseplus.createOption("main",{text = "Return to the Map",closeMenu = true,description = "Returns to the map of the game.",action = function() Routine.run(exitlevel2) end})
                end
                pauseplus.createSubmenu("settings",{headerText = "<size 1.5>Settings/Options</size>"})
                pauseplus.createSubmenu("charactermenu",{headerText = "<size 1.5>Character Options</size>"})
                pauseplus.createSubmenu("teleportmenu",{headerText = "<size 1.5>Teleportation Options</size>"})
                pauseplus.createSubmenu("miscsettings",{headerText = "<size 1.5>Miscellaneous Settings</size>"})
                pauseplus.createSubmenu("soundsettings",{headerText = "<size 1.5>Sound Settings</size>"})
                pauseplus.createSubmenu("resolutionsettings",{headerText = "<size 1.5>Resolution Settings</size>"})
                pauseplus.createOption("main",{text = "Character Options",goToSubmenu = "charactermenu",description = "Switch characters on the fly!"})
                pauseplus.createOption("main",{text = "Settings/Options",goToSubmenu = "settings",description = "Set some settings to enhance your gameplay."})
                if (Level.filename() == "map.lvlx") == true then
                    pauseplus.createOption("main",{text = "Teleportation Options",goToSubmenu = "teleportmenu",description = "Teleport to many places with this option (Select areas)."})
                elseif (Level.filename() == "MALC - HUB.lvlx") == true then
                    pauseplus.createOption("main",{text = "Teleportation Options",goToSubmenu = "teleportmenu",description = "Teleport to many places with this option (Select areas)."})
                elseif (Level.filename() == "MALC - HUB.lvlx") == false then
                    pauseplus.createOption("main",{text = "Teleportation Options",goToSubmenu = "teleportmenu",description = "Teleport to many places with this option (Select areas)."})
                end
                pauseplus.createOption("main",{text = "Save and Continue",description = "Save and continue your game.",pauseplus.save,closeMenu = true,action = function() Sound.playSFX("save_dismiss.ogg") end})
                if not isOverworld then
                    pauseplus.createOption("main",{text = "Save and Reset Game",description = "Saves and resets the game back to the preboot menu. Useful for setting options you can't set in the pause menu.",pauseplus.save,closeMenu = true,action = function() Routine.run(mainmenu) end})
                end
                pauseplus.createOption("main",{text = "Save and Quit",description = "Save and exit. You can continue later at any point. Remember to take breaks!",action = function() Routine.run(saveAndQuitRoutine) end})
                
                --Editor Menu
                if Misc.inEditor() then
                    pauseplus.createSubmenu("editormenuhud",{headerText = "<size 1.5>Editor Menu (Hud Options)</size>"})
                    pauseplus.createOption("editormenu",{text = "Instantly Restart Level",description = "Instantly restart the level, at the selected area on this menu.",pauseplus.save,closeMenu = true, actions = {function() Level.load(Level.filename(), nil, GameData.editorAreaStartingPoint) end}})
                    pauseplus.createOption("editormenu",{text = "Reload on Level Win Exit to",selectionType = pauseplus.SELECTION_NAMES,description = "Whenever winning the level, reload to this specific area.",selectionNames = {"World Map","Restart Level","Boot Menu"}, action = function() editorreloadchooser() end})
                    pauseplus.createOption("editormenu",{text = "Choose Powerup",selectionType = pauseplus.SELECTION_NAMES,description = "Choose the powerup of every player. This will affect all players.",selectionNames = {POWERUP_SMALL, POWERUP_BIG, POWERUP_FIRE, POWERUP_LEAF, POWERUP_TANOOKI, POWERUP_HAMMER, POWERUP_ICE}, action = function() debugpowerup() end})
                    pauseplus.createOption("editormenu",{text = "Select Area",description = "Select the area you want to load. This will be affected by the next restart.",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 0,selectionMin = 0,selectionMax = Warp.count(),selectionStep = 1,selectionFormat = "%d%%"})
                    pauseplus.createOption("editormenu",{text = "Reload with Selected Powerup",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Reload with the selected powerup in this menu, or not.", action = function() toggleeditorpowerupstate() end})
                    pauseplus.createOption("editormenu",{text = "Hud Options",goToSubmenu = "editormenuhud",description = "Options specific for the Hud."})
                    
                    --Editor Menu (Hud Options)
                    pauseplus.createOption("editormenuhud",{text = "Max Lives to Three Crowns",description = "Fill all the lives to the maximum life count (All three crowns).",pauseplus.save,closeMenu = true, actions = {function() SysManager.maxOutLives() end}})
                    pauseplus.createOption("editormenuhud",{text = "Reset Lives Back to 5",description = "Reset all the lives back to 5.",pauseplus.save,closeMenu = true, actions = {function() SysManager.resetLives() end}})
                    pauseplus.createOption("editormenuhud",{text = "Max the Death Count",description = "Max the death count to 999. Any higher will show 999+ on the Hud.",pauseplus.save,closeMenu = true, actions = {function() SysManager.maxOutDeathCount() end}})
                    pauseplus.createOption("editormenuhud",{text = "Reset Death Count",description = "Reset the death count back to 0.",pauseplus.save,closeMenu = true, actions = {function() SysManager.resetDeathCount() end}})
                end
                
                -- Settings
                pauseplus.createOption("settings",{text = "Resolution Settings",goToSubmenu = "resolutionsettings",description = "Set the resolution to enhance your gameplay."})
                pauseplus.createOption("settings",{text = "Sound Settings",goToSubmenu = "soundsettings",description = "Set some sound settings to enhance your gameplay."})
                pauseplus.createOption("settings",{text = "Miscellaneous Settings",goToSubmenu = "miscsettings",description = "Set some other settings to enhance your gameplay."})
                if (Level.filename() == "map.lvlx") == true then
                    pauseplus.createOption("settings",{text = "Unlock Broken Map Paths",description = "If any paths were broken, or you have recovered a save from a very weird error, this option can unlock any paths you already have unlocked prior.",closeMenu = true, actions = {function() Routine.run(unlockbrokenpaths) end}})
                end
                if (Level.filename() == "map.lvlx") == false then
                    pauseplus.createOption("settings",{text = "Turn ON/OFF 1.3 Mode",description = "Turn off/on 1.3 Mode to enable/disable several features, including multiplayer. COSTUMES WILL BE RESET!",pauseplus.save,closeMenu = true, actions = {function() Routine.run(onethreemodeactivate) end}})
                end
                if SaveData.speedrunMode == true then
                    pauseplus.createOption("settings",{text = "Purge Save Data",description = "In speedrun mode, you can use this option to erase your save and start over your speedrun. YOU WILL LOSE YOUR SAVE DATA IF YOU SELECT THIS OPTION!",actions = {function() Routine.run(purgesavedata) end}})
                end
                pauseplus.createOption("settings",{text = "Exit without Saving",description = "Exit without saving. YOU WILL LOSE PROGRESS IF YOU SELECT THIS OPTION!",action = {function() Routine.run(quitonly) end}})
                
                -- Misc. Settings
                pauseplus.createOption("miscsettings",{text = "Enable SMB1 Hard Mode",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Enable SMB1 Hard Mode. This will only apply to SMB1 levels.", action = function() smb1hardmodetoggle() end})
                pauseplus.createOption("miscsettings",{text = "Enable All Night Nippon Mode",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Enable the All Night Nippon Mode. This will only apply to SMB1 and SMBLL levels.", action = function() smb1allnightnipponoggle() end})
                pauseplus.createOption("miscsettings",{text = "Enable Original WSMBA Mode",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Enable the original Where SMB Attacks mode. This will only apply to WSMBA levels.", action = function() wsmbaoriginalgraphicsoggle() end})
                
                --Sound Settings
                pauseplus.createOption("soundsettings",{text = "Music Volume",description = "Turn the music volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 60,selectionMin = 0,selectionMax = 100,selectionStep = 5,selectionFormat = "%d%%"})
                pauseplus.createOption("soundsettings",{text = "SFX Volume",description = "Turn the sound effect volume lower or higher. Useful for gameplay while using headphones!",selectionType = pauseplus.SELECTION_NUMBERS,selectionDefault = 1,selectionMin = 0,selectionMax = 1,selectionStep = 0.1,selectionFormat = "%d%%"})
                pauseplus.createOption("soundsettings",{text = "Disable P-Wing Sound",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Disables the P-Wing sound. Toggle again to turn on.",action = function() togglepwingsfx() end})
                pauseplus.createOption("soundsettings",{text = "Use the Original SMBX Sound System",selectionType = pauseplus.SELECTION_CHECKBOX,description = "This options disables all the new sounds (Except P-Wing) and reverts back to the original sound system.",action = function() smbxdefaultsoundsystem() end})
                
                --Resolution Settings
                pauseplus.createOption("resolutionsettings",{text = "Switch Resolution",selectionType = pauseplus.SELECTION_NAMES,description = "Switch between resolutions.",selectionNames = {RESOLUTION_FULL,RESOLUTION_WIDE,RESOLUTION_ULTRAWIDE,RESOLUTION_NES,RESOLUTION_GBA,RESOLUTION_THREEDS}, action = function() changeresolution() end})
                pauseplus.createOption("resolutionsettings",{text = "Enable Letterbox Scaling",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Enable scaling to display a full resolution while in fullscreen mode (Use F4 while in fullscreen).", action =  function() changeletterbox() end})
                pauseplus.createOption("resolutionsettings",{text = "Disable Resolution Border",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Disable the border when using other additional resolutions.", action =  function() changeresolutionborder() end})
                
                --Character Menu
                if SaveData.disableX2char == false then
                    pauseplus.createSubmenu("costumeoptions",{headerText = "<size 1.5>Costume Specific Options</size>"})
                    pauseplus.createOption("charactermenu",{text = "Change Character (Previous)",description = "Switch the player's character to anything of your choice!", action =  function() characterchangeleft() end})
                    pauseplus.createOption("charactermenu",{text = "Change Character (Next)",description = "Switch the player's character to anything of your choice!", action =  function() characterchange() end})
                    pauseplus.createOption("charactermenu",{text = "Change Costumes (Previous)",description = "Switch the player's costume to anything of your choice!", action =  function() costumechangeleft() end})
                    pauseplus.createOption("charactermenu",{text = "Change Costumes (Next)",description = "Switch the player's costume to anything of your choice!", action =  function() costumechangeright() end})
                    pauseplus.createOption("charactermenu",{text = "Costume Specific Options",goToSubmenu = "costumeoptions",description = "Change settings regarding the costume that is currently being worn."})
                    if (Level.filename() == "map.lvlx") == false then
                        pauseplus.createOption("charactermenu",{text = "Enable/Disable Multiplayer",closeMenu = true,description = "Toggle the status of multiplayer. This will only work on 1.3 Mode (If in Normal Mode this won't do anything).",action = function() checkingplayerstatus() end})
                    end
                end
                if SaveData.disableX2char == true then
                    pauseplus.createOption("charactermenu",{text = "Change Character 1P (Previous)",description = "Switch the 1st Player's character to anything of your choice!",action =  function() characterchange13left() end})
                    pauseplus.createOption("charactermenu",{text = "Change Character 1P (Next)",description = "Switch the 1st Player's character to anything of your choice!",action =  function() characterchange13() end})
                    pauseplus.createOption("charactermenu",{text = "Change Character 2P (Previous)",description = "Switch the 2nd Player's character to anything of your choice!",action =  function() characterchange13_2pleft() end})
                    pauseplus.createOption("charactermenu",{text = "Change Character 2P (Next)",description = "Switch the 2nd Player's character to anything of your choice!",action =  function() characterchange13_2p() end})
                    if (Level.filename() == "map.lvlx") == false then
                        pauseplus.createOption("charactermenu",{text = "Enable/Disable Multiplayer",closeMenu = true,description = "Toggle the status of multiplayer. This will only work on 1.3 Mode (If in Normal Mode this won't do anything).",action = function() checkingplayerstatus13() end})
                    end
                end
                
                --Costume Menu
                if SaveData.disableX2char == false then
                    pauseplus.createOption("costumeoptions",{text = "Disable Abilities",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Whenever to disable costume abilities or keep them enabled. Default option is enabled.", action =  function() Routine.run(toggleabilitiescost) end})
                    pauseplus.createOption("costumeoptions",{text = "Enable Profane Voices",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Whenever to enable specific character profanity or not. Default option is disabled.", action =  function() Routine.run(toggleprofanecostume) end})
                    pauseplus.createOption("costumeoptions",{text = "Skip Character Intros",selectionType = pauseplus.SELECTION_CHECKBOX,description = "Whenever to enable character specific intros or not. Default option is enabled.", action =  function() Routine.run(toggleintroscostume) end})
                end

                --Teleportation Menu
                if not isOverworld then
                    if (Level.filename() == "map.lvlx") == false then
                        pauseplus.createOption("teleportmenu",{text = "Teleport to the Previous Level",closeMenu = true,description = "Returns to the previously played level. Useful while you're in the Hub.",action = function() Routine.run(returntolastlevel) end})
                    end
                    if (Level.filename() == "MALC - HUB.lvlx") == true then
                        pauseplus.createOption("teleportmenu",{text = "Teleport to the Tourist Center",closeMenu = true,description = "Teleports to inside of the 1st building in Me and Larry City. Useful for fast traveling!", action =  function() Routine.run(touristhub) end})
                        pauseplus.createOption("teleportmenu",{text = "Teleport to the Warp Zone",closeMenu = true,description = "Teleports to the skies, in the Hub Warp Zone. Useful for fast traveling!", action =  function() Routine.run(warpzonehub) end})
                        pauseplus.createOption("teleportmenu",{text = "Teleport to the Character Switch Menu",closeMenu = true,description = "Teleports to the Tourist Center's Character Switch Room. Useful for fast traveling!", action =  function() Routine.run(switchhub) end})
                        pauseplus.createOption("teleportmenu",{text = "Teleport to the Shop",closeMenu = true,description = "Teleports to inside of the 6th building located in Me and Larry City. Useful for fast traveling!", action =  function() Routine.run(shophub) end})
                        pauseplus.createOption("teleportmenu",{text = "Teleport Back to the Start",closeMenu = true,description = "Teleports back to the starting point of the Hub. Useful for fast traveling!", action =  function() Routine.run(shophub) end})
                    end
                end
                if (Level.filename() == "map.lvlx") == true then
                    pauseplus.createOption("teleportmenu",{text = "Teleport back to the Start",closeMenu = true,description = "Teleports back to the starting point of the map. Useful for fast traveling!", action =  function() Routine.run(startteleport) end})
                    pauseplus.createOption("teleportmenu",{text = "Teleport to the Hub",closeMenu = true,description = "Teleports back to the Hub marker on the map. Useful for fast traveling!", action = function() Routine.run(hubmapteleport) end})
                    pauseplus.createOption("teleportmenu",{text = "Teleport to the Side Quest",closeMenu = true,description = "Teleports back to the Side Quest starting point of the map. Useful for fast traveling!", action = function() Routine.run(sideteleport) end})
                    pauseplus.createOption("teleportmenu",{text = "Teleport to the DLC World",closeMenu = true,description = "Teleports back to the DLC World starting point of the map. Useful for fast traveling!", action = function() Routine.run(dlcteleport) end})
                end
                if not isOverworld and (Level.filename() == "MALC - HUB.lvlx") == false and (Level.filename() == "map.lvlx") == false then
                    pauseplus.createOption("teleportmenu",{text = "Teleport to the Hub",description = "Teleport to the Me and Larry City Hub. Useful for fast traveling!",closeMenu = true, actions = {function() Routine.run(hubteleportlevel) end}})
                end
            end
        end
    end
end

return pausemenu2