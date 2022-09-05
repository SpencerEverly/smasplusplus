local littleDialogue = require("littleDialogue")
local playerManager = require("playerManager")
local inventory = require("customInventory")
local textplus = require("textplus")
if not Misc.inMarioChallenge() then
    datetime = require("datetime")
end
local Routine = require("routine")
local extrasounds = require("extrasounds")
local anothercurrency = require("ShopSystem/anothercurrency")
local smashudsystem = require("smashudsystem")
local comboSounds = require("comboSounds")

extrasounds.active = false

local dying = false;
local deathVisibleCount = 198;
local deathTimer = deathVisibleCount;
local earlyDeathCheck = 3;
local cooldown = 0

local timer_deathTimer;
local deltaTime = Routine.deltaTime
local deathDelay = lunatime.toTicks(1.2)
local deathTimer = deathDelay

local costumes = {}

local dependencies = {}

local battledependencies = require("classicbattlemode")
battledependencies.battlemodeactive = false

function p1teleportdoor()
    Routine.waitFrames(30)
    player:mem(0x140,FIELD_WORD,100)
    if Player.count() >= 2 then
        Player(2):mem(0x140,FIELD_WORD,100)
        Player(2):teleport(Player(1).x - 32, Player(1).y - 32, bottomCenterAligned)
    end
end

function p2teleportdoor()
    Routine.waitFrames(30)
    player:mem(0x140,FIELD_WORD,100)
    player2:mem(0x140,FIELD_WORD,100)
    Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
end

function dependencies.onInitAPI()
    registerEvent(dependencies, "onStart")
    registerEvent(dependencies, "onLoad")
    registerEvent(dependencies, "onTick")
    registerEvent(dependencies, "onDraw")
    registerEvent(dependencies, "onCameraUpdate")
    registerEvent(dependencies, "onInputUpdate")
end

function dependencies.onStart()
    if SaveData.ut_enabled == nil then
        SaveData.ut_enabled = SaveData.ut_enabled or 0
    end
    
    if player.character == CHARACTER_NINJABOMBERMAN then
        Defines.player_walkspeed = 6
        Defines.player_runspeed = 6
    end
    
    if SaveData.disableX2char == false then
        mm = require("megamann");
        mm.playIntro = false;
        pausemenu = require("pausemenu")
        warpTransition = require("warpTransition")
        anotherPowerDownLibrary = require("anotherPowerDownLibrary")
        playerphysicspatch = require("playerphysicspatch")
        kindHurtBlock = require("kindHurtBlock")
        furyinventory = require("furyinventory")
        warpTransition.musicFadeOut = false
        warpTransition.levelStartTransition = warpTransition.TRANSITION_FADE
        warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
        warpTransition.crossSectionTransition = warpTransition.TRANSITION_FADE
        warpTransition.activateOnInstantWarps = false
        warpTransition.TRANSITION_FADE = 1
        warpTransition.TRANSITION_SWIRL = 1
        warpTransition.TRANSITION_IRIS_OUT = 1
        warpTransition.TRANSITION_PAN = 6
        littleDialogue.defaultStyleName = "smw"
    end
    if SaveData.disableX2char == true then
        Cheats.deregister("dressmeup")
        Cheats.deregister("undress")
        Cheats.deregister("laundryday")
        warpTransition = require("warpTransition")
        warpTransition.musicFadeOut = false
        warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
        warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
        warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
        warpTransition.activateOnInstantWarps = false
        pausemenu = require("pausemenu")
        littleDialogue.defaultStyleName = "smbx13og"
    end
    if character == "CHARACTER_LUIGI" then
        if currentCostume == "UNDERTALE-FRISK" then
            level_dependencies_undertale = require("level_dependencies_undertale")
        end
    end
end

function dependencies.onTick()
    if Player.count() >= 2 then
        if Player(1).forcedState == FORCEDSTATE_PIPE then
            if Player(1).forcedTimer >= 70 and not Misc.isPaused() then
                player:mem(0x140,FIELD_WORD,100)
                player2:mem(0x140,FIELD_WORD,100)
                Player(2):teleport(player.x - 32, player.y - 32, bottomCenterAligned)
            end
        end
        if Player(2).forcedState == FORCEDSTATE_PIPE then
            if Player(2).forcedTimer >= 70 and not Misc.isPaused() then
                player:mem(0x140,FIELD_WORD,100)
                player2:mem(0x140,FIELD_WORD,100)
                Player(1):teleport(Player(2).x - 32, Player(2).y - 32, bottomCenterAligned)
            end
        end
    end
    if Player.count() >= 2 then
        if Player(1).forcedState == FORCEDSTATE_DOOR then
            if Player(1).forcedTimer == 1 then
                Routine.run(p1teleportdoor)
            end
        end
        if Player(2).forcedState == FORCEDSTATE_DOOR then
            if Player(2).forcedTimer == 1 then
                Routine.run(p2teleportdoor)
            end
        end
    end
    if player.character == CHARACTER_SNAKE then
        Graphics.activateHud(true)
    end
    if player.character == CHARACTER_NINJABOMBERMAN then
        Graphics.activateHud(true)
    end
    if table.icontains(smastables.__smb2Levels,Level.filename()) == true then
        if NPC.config[274].score == 11 then
            Sound.playSFX(147)
            NPC.config[274].score = 6
        end
    elseif Level.filename() then
        if NPC.config[274].score == 11 then
            NPC.config[274].score = 6 --Nothing plays btw, just resets
        end
    end
end

return dependencies