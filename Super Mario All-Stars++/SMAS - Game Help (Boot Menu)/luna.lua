Graphics.activateHud(false)
Misc.saveGame()

local littleDialogue = require("littleDialogue")
local warpTransition = require("warpTransition")

warpTransition.musicFadeOut = false
warpTransition.levelStartTransition = warpTransition.TRANSITION_FADE
warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
warpTransition.crossSectionTransition = warpTransition.TRANSITION_FADE
warpTransition.activateOnInstantWarps = false
warpTransition.TRANSITION_FADE = 1
warpTransition.TRANSITION_SWIRL = 1
warpTransition.TRANSITION_IRIS_OUT = 1
warpTransition.TRANSITION_PAN = 6

local playerManager = require("playerManager")
local textplus = require("textplus")
local autoscroll = require("autoscroll")
if not Misc.inMarioChallenge() then
    datetime = require("datetime")
end
local Routine = require("routine")
local extrasounds = require("extrasounds")
local anothercurrency = require("ShopSystem/anothercurrency")

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

function p1teleportdoor()
    Routine.waitFrames(30)
    player:mem(0x140,FIELD_WORD,100)
    player2:mem(0x140,FIELD_WORD,100)
    Player(2):teleport(Player(1).x - 32, Player(1).y - 32, bottomCenterAligned)
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
    local character = player.character;
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()
    
    local costumes
    if SaveData.disableX2char == false then
        mm = require("Characters/megaman");
        mm.playIntro = false;
        undertaledepends = require("level_dependencies_undertale")
        anotherPowerDownLibrary = require("anotherPowerDownLibrary")
        playerphysicspatch = require("playerphysicspatch")
        kindHurtBlock = require("kindHurtBlock")
        comboSounds = require("comboSounds")
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
        littleDialogue.defaultStyleName = "smbx13og"
        Audio.sounds[1].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-jump.ogg")
        Audio.sounds[2].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/stomped.ogg")
        Audio.sounds[3].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-hit.ogg")
        extrasounds.sounds[4].sfx  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/block-smash.ogg"))
        Audio.sounds[5].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-shrink.ogg")
        Audio.sounds[6].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-grow.ogg")
        extrasounds.sounds[7].sfx  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/mushroom.ogg"))
        extrasounds.sounds[8].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died.ogg")
        Audio.sounds[9].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/shell-hit.ogg")
        Audio.sounds[10].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-slide.ogg")
        Audio.sounds[11].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/item-dropped.ogg")
        Audio.sounds[12].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/has-item.ogg")
        Audio.sounds[13].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/camera-change.ogg")
        extrasounds.sounds[14].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/coin.ogg"))
        extrasounds.sounds[15].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/1up.ogg"))
        Audio.sounds[16].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/lava.ogg")
        Audio.sounds[17].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/warp.ogg")
        extrasounds.sounds[18].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireball.ogg"))
        Audio.sounds[19].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/level-win.ogg")
        Audio.sounds[20].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boss-beat.ogg")
        Audio.sounds[21].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dungeon-win.ogg")
        Audio.sounds[22].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bullet-bill.ogg")
        Audio.sounds[23].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab.ogg")
        Audio.sounds[24].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/spring.ogg")
        Audio.sounds[25].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/hammer.ogg")
        Audio.sounds[29].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/do.ogg")
        Audio.sounds[31].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/key.ogg")
        Audio.sounds[32].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/pswitch.ogg")
        Audio.sounds[33].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/tail.ogg")
        Audio.sounds[34].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/racoon.ogg")
        Audio.sounds[35].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boot.ogg")
        Audio.sounds[36].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smash.ogg")
        Audio.sounds[37].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/thwomp.ogg")
        Audio.sounds[42].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/npc-fireball.ogg")
        extrasounds.sounds[43].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireworks.ogg"))
        Audio.sounds[44].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bowser-killed.ogg")
        Audio.sounds[46].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/door.ogg")
        Audio.sounds[48].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi.ogg")
        Audio.sounds[49].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-hurt.ogg")
        Audio.sounds[50].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-tongue.ogg")
        Audio.sounds[51].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-egg.ogg")
        Audio.sounds[52].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/got-star.ogg")
        Audio.sounds[54].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died2.ogg")
        Audio.sounds[55].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-swallow.ogg")
        Audio.sounds[57].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dry-bones.ogg")
        Audio.sounds[58].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-checkpoint.ogg")
        extrasounds.sounds[59].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg"))
        Audio.sounds[61].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-blaarg.ogg")
        Audio.sounds[62].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-bubble.ogg")
        Audio.sounds[63].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-die.ogg")
        Audio.sounds[71].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/climbing.ogg")
        Audio.sounds[72].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/swim.ogg")
        Audio.sounds[73].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab2.ogg")
        Audio.sounds[75].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-throw.ogg")
        Audio.sounds[76].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-hit.ogg")
        Audio.sounds[77].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-stab.ogg")
        Audio.sounds[78].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hurt.ogg")
        Audio.sounds[79].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-heart.ogg")
        Audio.sounds[80].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-died.ogg")
        Audio.sounds[81].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-rupee.ogg")
        Audio.sounds[82].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fire.ogg")
        Audio.sounds[83].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-item.ogg")
        Audio.sounds[84].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-key.ogg")
        Audio.sounds[85].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-shield.ogg")
        Audio.sounds[86].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-dash.ogg")
        Audio.sounds[87].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fairy.ogg")
        Audio.sounds[88].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-grass.ogg")
        Audio.sounds[89].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hit.ogg")
        Audio.sounds[90].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-sword-beam.ogg")
        Audio.sounds[91].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bubble.ogg")
    end
    if character == "CHARACTER_LUIGI" then
        if currentCostume == "UNDERTALE-FRISK" then
            if SaveData.ut_enabled == 0 then
                SaveData.ut_enabled = SaveData.ut_enabled + 1
            end
            level_dependencies_undertale = require("level_dependencies_undertale")
        end
        if currentCostume == "WALUIGI" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "MODERN" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "LARRYTHECUCUMBER" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "A2XT-IRIS" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "17-NSMBDS-SMBX" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "16-SMA4" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "15-SMA2" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "13-SMBDX" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "10-SMW-ORIGINAL" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "09-SMB3-MARIOCLOTHES" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "07-SMB3-RETRO" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "06-SMB2-SMAS" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "05-SMB2-RETRO" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "04-SMB1-SMAS" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "03-SMB1-RETRO-MODERN" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "02-SMB1-RECOLORED" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "01-SMB1-RETRO" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
        end
        if currentCostume == "00-SPENCEREVERLY" then
            if SaveData.ut_enabled == 1 then
                SaveData.ut_enabled = SaveData.ut_enabled - 1
            end
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
    local character = player.character;
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()

    local costumes
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

Cheats.register("fcommandssuck",{
    onActivate = (function()
        Defines.player_hasCheated = false
        --spartaremix = require("spartaremix")
        malcwarp = require("malcwarp")
        thecostume = require("thecostume")
        exitcommands = require("exitcommands")
        commandlist = require("commandlist")
        return true -- this makes the cheat not toggleable
    end),
    flashPlayer = true,activateSFX = "_OST/_Sound Effects/hits1.ogg",
})

return dependencies