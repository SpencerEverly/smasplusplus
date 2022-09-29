local starman = require("starman/star")
local mega2 = require("mega/megashroom")
local playerManager = require("playermanager")
local littleDialogue = require("littleDialogue")
local extendedKoopas = require("extendedKoopas")
local warpTransition = require("warpTransition")
local textplus = require("textplus")
local repll = require("repll")
local namehover = require("namehover")
local hearthover = require("hearthover")
local steve = require("steve")
local yoshi = require("yiYoshi/yiYoshi")
local inventory = require("customInventory")
local inputconfigurator = require("inputconfig")
local customCamera = require("customCamera")
local smallScreen = require("smallScreen")
local musicalchairs = require("musicalchairs")

_G.smasacecoins = require("smasacecoins")
_G.smascharacterinfo = require("smascharacterinfo")
_G.smascharacterintros = require("smascharacterintros")
_G.smasextraactions = require("smasextraactions")
_G.smasblocksystem = require("smasblocksystem")

if SMBX_VERSION == VER_SEE_MOD then
    smasonlineplay = require("smasonlineplay")
end

customCamera.transitionSpeed = 5

local widebars = Graphics.loadImageResolved("graphics/resolutions/widescreen.png")
local ultrawidebars = Graphics.loadImageResolved("graphics/resolutions/ultrawide.png")
local nesbars = Graphics.loadImageResolved("graphics/resolutions/nes.png")
local threedsbars = Graphics.loadImageResolved("graphics/resolutions/3ds.png")

local numberfont = textplus.loadFont("littleDialogue/font/1.ini")

if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
    if not SaveData.disableX2char then
        if SaveData.accessibilityTwirl then
            twirl = require("Twirl")
        end
        if SaveData.accessibilityWallJump then
            aw = require("anotherwalljump")
            aw.registerAllPlayersDefault()
        end
        if SaveData.accessibilityGroundPound then
            GP = require("GroundPound")
            GP.enabled = true
        end
    end
end

if GameData.rushModeActive == true then
    level_dependencies_rushmode = require("level_dependencies_rushmode")
end

if SaveData.SMB1HardModeActivated == nil then
    SaveData.SMB1HardModeActivated = false
end
if SaveData.SMB1LLAllNightNipponActivated == nil then
    SaveData.SMB1LLAllNightNipponActivated = false
end
if SaveData.WSMBAOriginalGraphicsActivated == nil then
    SaveData.WSMBAOriginalGraphicsActivated = false
end
if SaveData.SMA1ModeActivated == nil then
    SaveData.SMA1ModeActivated = false
end

if SaveData.framerateEnabled == nil then
    SaveData.framerateEnabled = false
end
if SaveData.disablePWingSFX == nil then
    SaveData.disablePWingSFX = false
end
if SaveData.SMBXSoundSystem == nil then
    SaveData.SMBXSoundSystem = false
end

namehover.active = false
local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

smashud.priority = -4.2
smashud.visible.starcoins = false
GameData.activateAbilityMessage = false
GameData.forcedStateActive = false

local eastercrash = false
local eastercrashdone = false
local eastercrashmsg = false
local eastercrashprevload = false
local blockidx5000check = false

local nesborder = Graphics.loadImageResolved("graphics/resolutionborders/nes.png")
local gbborder = Graphics.loadImageResolved("graphics/resolutionborders/gb.png")
local gbaborder = Graphics.loadImageResolved("graphics/resolutionborders/gba.png")
local iphoneoneborder = Graphics.loadImageResolved("graphics/resolutionborders/iphone1st.png")
local threedsborder = Graphics.loadImageResolved("graphics/resolutionborders/3ds.png")

--customCamera.transitionSpeed = 0.25

SaveData._anothercurrency = {SaveData.totalcoins}

if table.icontains(smastables._noTransitionLevels,Level.filename()) or GameData.rushModeActive == true then
    warpTransition.musicFadeOut = false
    warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
    warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.activateOnInstantWarps = false
end

if SaveData.disableX2char == true then
    warpTransition.musicFadeOut = false
    warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
    warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.activateOnInstantWarps = false
    extrasounds.enableFireFlowerHitting = false
    mega2.sfxFile = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom13.ogg")
    mega2.megagrowsfx = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom-grow-1.3.ogg")
    mega2.megashrinksfx = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom-shrink-1.3.ogg")
    mega2.megarunningoutsfx = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom-runningout-1.3.ogg")
    starman.sfxFile = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/starman.ogg")
    extrasounds.sound.sfx[1]  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-hit.ogg")
    extrasounds.sound.sfx[4]  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/block-smash.ogg"))
    Audio.sounds[5].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/mushroom.ogg"))
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died.ogg")
    Audio.sounds[9].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/shell-hit.ogg")
    extrasounds.sound.sfx[10] = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-slide.ogg")
    Audio.sounds[11].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/item-dropped.ogg")
    Audio.sounds[12].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/has-item.ogg")
    Audio.sounds[13].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/camera-change.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/coin.ogg"))
    extrasounds.sound.sfx[15] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/1up.ogg"))
    Audio.sounds[16].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireball.ogg"))
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
    extrasounds.sound.sfx[33] = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/racoon.ogg")
    Audio.sounds[35].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boot.ogg")
    extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/thwomp.ogg")
    extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/npc-fireball.ogg"))
    extrasounds.sound.sfx[43] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireworks.ogg"))
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
    extrasounds.sound.sfx[59] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg"))
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
    extrasounds.sound.sfx[81] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/zelda-rupee.ogg"))
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
    extrasounds.sound.sfx[92] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/sprout-vine.ogg")) --Vine sprout
    extrasounds.sound.sfx[93] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/iceball.ogg")) --Iceball
    extrasounds.sound.sfx[94] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/yi_freeze.ogg")) --Freeze enemies
    extrasounds.sound.sfx[95] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/yi_icebreak.ogg")) --Enemy ice breaker
    extrasounds.sound.sfx[96] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/2up.ogg")) --2UP
    extrasounds.sound.sfx[97] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/3up.ogg")) --3UP
    extrasounds.sound.sfx[98] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/5up.ogg")) --5UP
    extrasounds.sound.sfx[99] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #2
    extrasounds.sound.sfx[100] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #3
    extrasounds.sound.sfx[101] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #4
    extrasounds.sound.sfx[102] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #5
    extrasounds.sound.sfx[103] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/cherry.ogg")) --Cherry
    extrasounds.sound.sfx[104] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/explode.ogg")) --SMB2 Explosion
    extrasounds.sound.sfx[105] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/hammerthrow.ogg")) --Player hammer throw
    extrasounds.sound.sfx[106] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo1.ogg")) --Shell hit 2
    extrasounds.sound.sfx[107] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo2.ogg")) --Shell hit 3
    extrasounds.sound.sfx[108] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo3.ogg")) --Shell hit 4
    extrasounds.sound.sfx[109] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo4.ogg")) --Shell hit 5
    extrasounds.sound.sfx[110] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo5.ogg")) --Shell hit 6
    extrasounds.sound.sfx[111] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo6.ogg")) --Shell hit 7
    extrasounds.sound.sfx[112] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo7.ogg")) --Shell hit 8
    extrasounds.sound.sfx[113] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/score-tally.ogg")) --SMB1 Flagpole Score Tally
    extrasounds.sound.sfx[114] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/score-tally-end.ogg")) --SMB1 Flagpole Score Tally (End)
    extrasounds.sound.sfx[115] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/bowser-fire.ogg")) --Bowser Fireball
    extrasounds.sound.sfx[116] = Audio.SfxOpen(Misc.resolveSoundFile("boomerang.ogg")) --Boomerang
    extrasounds.sound.sfx[117] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/smb2-charge.ogg")) --SMB2 High Jump Charge
    extrasounds.sound.sfx[118] = Audio.SfxOpen(Misc.resolveSoundFile("stopwatch.ogg")) --Stopwatch
    extrasounds.sound.sfx[119] = Audio.SfxOpen(Misc.resolveSoundFile("whale-spout.ogg")) --SMB2 Whale Water Sprout
    extrasounds.sound.sfx[120] = Audio.SfxOpen(Misc.resolveSoundFile("door-reveal.ogg")) --SMB3 Door Reveal (Peach)
    extrasounds.sound.sfx[121] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/p-wing.ogg")) --SMB3 P-Wing
    extrasounds.sound.sfx[122] = Audio.SfxOpen(Misc.resolveSoundFile("wand-moving.ogg")) --SMB3 Wand Moving
    extrasounds.sound.sfx[123] = Audio.SfxOpen(Misc.resolveSoundFile("wand-whoosh.ogg")) --SMB3 Wand Air Whoosh (Custom)
    extrasounds.sound.sfx[124] = Audio.SfxOpen(Misc.resolveSoundFile("hop.ogg")) --SMB3 Hop
    extrasounds.sound.sfx[125] = Audio.SfxOpen(Misc.resolveSoundFile("smash-big.ogg")) --Big Smash (SMB1 Toad Pile)
    extrasounds.sound.sfx[126] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/smb2-hitenemy.ogg")) --SMB2 Enemy Hit
    extrasounds.sound.sfx[127] = Audio.SfxOpen(Misc.resolveSoundFile("boss-fall.ogg")) --SMW Boss Fall
    extrasounds.sound.sfx[128] = Audio.SfxOpen(Misc.resolveSoundFile("boss-lava.ogg")) --SMW Boss Lava Hit
    extrasounds.sound.sfx[129] = Audio.SfxOpen(Misc.resolveSoundFile("boss-shrink.ogg")) --SMW Boss Shrink (Shrinking)
    extrasounds.sound.sfx[130] = Audio.SfxOpen(Misc.resolveSoundFile("boss-shrink-done.ogg")) --SMW Boss Shrink (Done Shrinking)
    extrasounds.sound.sfx[131] = Audio.SfxOpen(Misc.resolveSoundFile("hp-get.ogg")) --Recieve HP (Mario Multiverse)
    extrasounds.sound.sfx[132] = Audio.SfxOpen(Misc.resolveSoundFile("hp-max.ogg")) --HP is maxed out (Mario Multiverse)
    extrasounds.sound.sfx[133] = Audio.SfxOpen(Misc.resolveSoundFile("cape-feather.ogg")) --Cape Feather (SMW)
    extrasounds.sound.sfx[134] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/cape-fly.ogg")) --Cape Flying (SMW)
    extrasounds.sound.sfx[135] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/flag-slide.ogg")) --Flagpole Sliding (SMB1)
    extrasounds.sound.sfx[136] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-exit.ogg")) --Flagpole Fanfare (SMB1)
    extrasounds.sound.sfx[137] = Audio.SfxOpen(Misc.resolveSoundFile("smb2-clear.ogg")) --World Clear Fanfare (SMB2)
    extrasounds.sound.sfx[138] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-world-clear.ogg")) --World Clear Fanfare (SMB1)
    extrasounds.sound.sfx[139] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-underground-overworld.ogg")) --Going Underground, Overworld (SMB1)
    extrasounds.sound.sfx[140] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-underground-desert.ogg")) --Going Underground, Desert (SMB1)
    extrasounds.sound.sfx[141] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-underground-sky.ogg")) --Going Underground, Sky (SMB1)
end

local killed = false
local killed2 = false

local pipecounter = 0
local pipecounter2 = 0
local doorcounter = 0
local doorcounter2 = 0
local fadetolevel = false

local ready = false

local globalgenerals = {}

local pipecounter1p = 0
local pipecounter2p = 0

function globalgenerals.onInitAPI()
    registerEvent(globalgenerals,"onExit")
    registerEvent(globalgenerals,"onExitLevel")
    registerEvent(globalgenerals,"onStart")
    registerEvent(globalgenerals,"onTick")
    registerEvent(globalgenerals,"onTickEnd")
    registerEvent(globalgenerals,"onCameraUpdate")
    registerEvent(globalgenerals,"onInputUpdate")
    registerEvent(globalgenerals,"onEvent")
    registerEvent(globalgenerals,"onDraw")
    registerEvent(globalgenerals,"onPlayerHarm")
    registerEvent(globalgenerals,"onPostNPCKill")
    registerEvent(globalgenerals,"onPostBlockHit")
    registerEvent(globalgenerals,"onBlockHit")
    registerEvent(globalgenerals,"onPause")
    registerEvent(globalgenerals,"onExplosion")
    registerEvent(globalgenerals,"onKeyboardPress")
    registerEvent(globalgenerals,"onControllerButtonPress")
    
    local Routine = require("routine")
    
    ready = true
end

function lavashroomeasteregg()
    eastercrashprevload = true
    smasbooleans.musicMuted = true
    Sound.playSFX("easteregg_smbx13crash.ogg")
    eastercrashmsg = true
    Routine.wait(2, true)
    smasbooleans.musicMuted = false
    Routine.wait(20, true)
    eastercrashmsg = false
    eastercrashdone = true
    eastercrash = false
end

--New pause menu was made, this is to prevent the old pause menu from opening
function globalgenerals.onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function globalgenerals.onEvent(eventName)
    if eventName then --If it executes any event...
        if smasbooleans.musicMuted then --If the music has been muted for any reason...
            for i = 0,20 do
                if Section(i).music ~= 0 then --If the music is anything but 0...
                    Sound.refreshMusic(i) --Refresh that specific section
                    Sound.muteMusic(i) --Then mute
                end
            end
        end
    end
end

function globalgenerals.onStart()
    if smasbooleans.targetPlayers then
        for _,p in ipairs(Player.get()) do
            if p.isValid then
                table.insert(customCamera.targets,p)
            elseif not p.isValid then
                table.remove(customCamera.targets,p)
            end
        end
    end
    for i = 0,20 do
        GameData.levelMusic[i] = Section(i).music
    end
    for i = 0,20 do
        GameData.levelMusicTemporary[i] = Section(i).music
    end
    if Player.count() <= 0 then
        Playur.activate1stPlayer()
    end
    if not SaveData.disableX2char then
        Playur.activate1stPlayer()
    end
    if Misc.inEditor() then
        debugbox = require("debugbox")
        debugbox.bootactive = true
    end
    if GameData.____mainMenuComplete == true then
        if (mem(0xB25724, FIELD_STRING) == "SMAS - Start.lvlx") then
            mem(0xB25724, FIELD_STRING, "map.lvlx")
        end
    end
    if SaveData.lastLevelPlayed == nil then
        SaveData.lastLevelPlayed = SaveData.lastLevelPlayed or Level.filename()
    end
    if SaveData.disablePWingSFX then
        extrasounds.enablePWingSFX = false
    elseif not SaveData.disablePWingSFX then
        extrasounds.enablePWingSFX = true
    end
    if SaveData.SMBXSoundSystem then
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
    elseif not SaveData.SMBXSoundSystem then
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
    end
end

function CheckStarAvailability()
    GameData.activateAbilityMessage = false
end

function ExitFeature()
    GameData.activateAbilityMessage = false
end

littleDialogue.registerAnswer("WallOfWeaponsDialog",{text = "Yes",chosenFunction = function() Routine.run(CheckStarAvailability) end})
littleDialogue.registerAnswer("WallOfWeaponsDialog",{text = "No",chosenFunction = function() Routine.run(ExitFeature) end})

local cooldown = 0

function globalgenerals.checkSpecialAbilityMessage()
    if SaveData.currentCostume == "GA-BORIS" then
        if not Misc.isPaused() then
            if SaveData.toggleCostumeAbilities == true then
                if player.keys.altRun == KEYS_PRESSED and GameData.activateAbilityMessage == false or GameData.activateAbilityMessage == nil then
                    if table.icontains(smastables._friendlyPlaces,Level.filename()) == false then
                        player:mem(0x172, FIELD_BOOL, false)
                        cooldown = 5
                        GameData.activateAbilityMessage = true
                        littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.4>Would you like to use The Wall of Weapons? You can only use this every 5 stars you collect.<question WallOfWeaponsDialog>", pauses = true, updatesInPause = true})
                        if cooldown <= 0 then
                            player:mem(0x172, FIELD_BOOL, true)
                        end
                    else
                        player:mem(0x172, FIELD_BOOL, false)
                        cooldown = 10
                        if cooldown <= 0 then
                            player:mem(0x172, FIELD_BOOL, true)
                        end
                    end
                end
            end
        end
    end
end

function globalgenerals.teleport2playermodecontroller(button, playerIdx)
    if Player.count() >= 2 then
        if playerIdx == 1 then
            if not Misc.isPaused() then
                player:teleport(player2.x + 32, player2.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
            end
        end
        if playerIdx == 2 then
            if not Misc.isPaused() then
                player2:teleport(player.x - 32, player.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
            end
        end
    end
end

function globalgenerals.teleport2playermode1P()
    if Player.count() >= 2 then
        if not Misc.isPaused() then
            player:teleport(player2.x + 32, player2.y - 32, bottomCenterAligned)
            Sound.playSFX("player-tp-2player.ogg")
        end
    end
end

function globalgenerals.teleport2playermode2P()
    if Player.count() >= 2 then
        if not Misc.isPaused() then
            player2:teleport(player.x - 32, player.y - 32, bottomCenterAligned)
            Sound.playSFX("player-tp-2player.ogg")
        end
    end
end

function globalgenerals.teleport2playermodecontroller(button, playerIdx)
    if Player.count() >= 2 then
        if playerIdx == 1 then
            if not Misc.isPaused() then
                player:teleport(player2.x + 32, player2.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
                cooldown = 1
                Player(1):mem(0x172,FIELD_BOOL,false)
            end
            if cooldown <= 0 then
                Player(1):mem(0x172,FIELD_BOOL,true)
            end
        end
        if playerIdx == 2 then
            if not Misc.isPaused() then
                player2:teleport(player.x - 32, player.y - 32, bottomCenterAligned)
                Sound.playSFX("player-tp-2player.ogg")
                cooldown = 1
                Player(2):mem(0x172,FIELD_BOOL,false)
            end
            if cooldown <= 0 then
                Player(2):mem(0x172,FIELD_BOOL,true)
            end
        end
    end
end

local yoshinpcs = table.map{1095,1100,1098,1099,1149,1150,1228,1148,1325,1326,1327,1328,1329,1330,1331,1332}

function globalgenerals.onPostBlockHit(block, fromUpper, playerornil)
    for _,p in ipairs(Player.get()) do
        if p.mount == MOUNT_YOSHI and yoshinpcs[block.contentID] then
            block.contentID = 1187
        end
    end
end

function globalgenerals.onTickEnd()
    -- Fix blinking when starting the level/changing sections (Thanks MDA!)
    mem(0x00B250D4,FIELD_BOOL,false)
end

local pSwitchMusic

function globalgenerals.onTick()
    if table.icontains(smastables.__wsmbaLevels,Level.filename()) then
        if SaveData.disableX2char == false then
            littleDialogue.defaultStyleName = "smbx13"
        end
        warpTransition.musicFadeOut = false
        warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
        warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
        warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
        warpTransition.activateOnInstantWarps = false
    end
    if player.character == CHARACTER_SNAKE then
        smashud.visible.keys = true
        smashud.visible.itembox = true
        smashud.visible.bombs = true
        smashud.visible.coins = true
        smashud.visible.stars = true
        smashud.visible.timer = true
        smashud.visible.levelname = true
        smashud.visible.overworldPlayer = true
    end
    if player.character == CHARACTER_NINJABOMBERMAN then
        smashud.visible.keys = true
        smashud.visible.itembox = true
        smashud.visible.bombs = true
        smashud.visible.coins = true
        smashud.visible.stars = true
        smashud.visible.timer = true
        smashud.visible.levelname = true
        smashud.visible.overworldPlayer = true
    end
    if player.character == CHARACTER_UNCLEBROADSWORD then
        --smashud.visible.lives = false
    end
    if player.character == CHARACTER_ULTIMATERINKA then
        smashud.visible.keys = true
        smashud.visible.itembox = true
        smashud.visible.bombs = true
        smashud.visible.coins = true
        smashud.visible.stars = true
        smashud.visible.timer = true
        smashud.visible.levelname = true
        smashud.visible.overworldPlayer = true
    end
    for k,block in ipairs(Block.get{371,405,30,406,1268,404,420,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487}) do
        if block.idx >= 5000 then --Easter egg block IDX detection, for the epic 1.3 mode crash thingy
            blockidx5000check = true
        end
    end
    
    if SaveData.currentCostume == "SMB3-WALUIGI" then
        Player.setCostume(10, nil)
    end
    
    Defines.pswitch_music = false
    
    for _,p in ipairs(Player.get()) do --Make sure all players are counted if i.e. using supermario128...
        if mem(0x00B2C5AC,FIELD_FLOAT) == 0 then --If 0, do these things...
            if(not killed and p:mem(0x13E,FIELD_BOOL)) then --Checks to see if the player actually died...
                killed = true --If so, this is true.
                mem(0x00B2C5AC,FIELD_FLOAT, 1) --Increase the life to 1 to prevent being kicked to the broken SMBX launcher after dying
            end
            if Player.count() >= 2 then --Player(2) compability! This one is a bit of a mess, but I tried
                if(not killed2 and p.deathTimer >= 1 and p:mem(0x13C, FIELD_BOOL)) then --Because 0X13E doesn't check in multiplayer, use the death timer instead.
                    killed2 = true --This one has a different variable set for player2
                    mem(0x00B2C5AC,FIELD_FLOAT, 1) --Also same as above
                    if p.deathTimer >= 199 then --If player2's death timer is almost 200, do a failsafe and load the level again, when setting the legacy lives to 1
                        Level.load(Level.filename())
                    end
                end
            end
        end
        --P-Switch code
        if mem(0x00B2C62C, FIELD_WORD) == 776 or mem(0x00B2C62E, FIELD_WORD) == 776 then
            if not p.hasStarman and not p.isMega then
                Sound.muteMusic(-1)
                smasbooleans.musicMuted = true
                pSwitchMusic = SFX.play(smascharacterinfo.pSwitchMusic, Audio.MusicVolume() / 100, 0)
            end
            smasbooleans.pSwitchActive = true
        end
        if p.hasStarman or p.isMega or GameData.winStateActive or Level.endState() > 0 then
            if pSwitchMusic ~= nil then
                smasbooleans.musicMuted = false
                pSwitchMusic:Stop()
            end
        end
        if mem(0x00B2C62C, FIELD_WORD) == 1 or mem(0x00B2C62E, FIELD_WORD) == 1 then
            smasbooleans.pSwitchActive = false
            if pSwitchMusic ~= nil then
                pSwitchMusic:Stop()
            end
            if not p.hasStarman and not p.isMega then
                smasbooleans.musicMuted = false
                Sound.restoreMusic(-1)
            end
        end
    end
    
    if SaveData.GameOverCount == nil then
        SaveData.GameOverCount = SaveData.GameOverCount or 0
    end
    if SaveData.goombaStomps == nil then
        SaveData.goombaStomps = SaveData.goombaStomps or 0
    end
    if SaveData.koopaStomps == nil then
        SaveData.koopaStomps = SaveData.koopaStomps or 0
    end
    if SaveData.starmansused == nil then
        SaveData.starmansused = SaveData.starmansused or 0
    end
    if SaveData.megamushroomssused == nil then
        SaveData.megamushroomssused = SaveData.megamushroomssused or 0
    end
    if SaveData.starsgrabbed == nil then
        SaveData.starsgrabbed = SaveData.starsgrabbed or 0
    end
    if SaveData.totalmushrooms == nil then
        SaveData.totalmushrooms = SaveData.totalmushrooms or 0
    end
    if SaveData.totalfireflowers == nil then
        SaveData.totalfireflowers = SaveData.totalfireflowers or 0
    end
    if SaveData.totalleafs == nil then
        SaveData.totalleafs = SaveData.totalleafs or 0
    end
    if SaveData.totaltanookis == nil then
        SaveData.totaltanookis = SaveData.totaltanookis or 0
    end
    if SaveData.totalhammersuits == nil then
        SaveData.totalhammersuits = SaveData.totalhammersuits or 0
    end
    if SaveData.totaliceflowers == nil then
        SaveData.totaliceflowers = SaveData.totaliceflowers or 0
    end
    if SaveData.mandatoryStars == nil then
        SaveData.mandatoryStars = SaveData.mandatoryStars or 0
    end
    --if SaveData.totalmandatoryStars == nil then
        --SaveData.mandatoryStars = SaveData.mandatoryStars or 999 --Value isn't final, until all levels are made
    --end
end

function globalgenerals.onPostNPCKill(npc, harmType)
    for _,p in ipairs(Player.get()) do
        local goombas = table.map{1,2,27,71,89,242,243,379,392,393,466,467}
        if goombas[npc.id] then
            SaveData.goombaStomps = SaveData.goombaStomps + 1
        end
        local koopas = table.map{4,5,6,7,55,72,73,76,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,161,172,173,174,175,176,177,194,578,920,921}
        if koopas[npc.id] then
            SaveData.koopaStomps = SaveData.koopaStomps + 1
        end
        local starmans = table.map{994,996}
        if starmans[npc.id] and Colliders.collide(p, npc) then
            SaveData.starmansused = SaveData.starmansused + 1
        end
        if npc.id == 997 and Colliders.collide(p, npc) then
            SaveData.megamushroomssused = SaveData.megamushroomssused + 1
        end
        local stars = table.map{97,196,999,1000}
        if stars[npc.id] and Colliders.collide(p, npc) then
            SaveData.starsgrabbed = SaveData.starsgrabbed + 1
        end
        local coins = table.map{10,33,88,103,138,251,252,253,258,528}
        if coins[npc.id] and Colliders.collide(p, npc) then
            SaveData.totalcoins = SaveData.totalcoins + 1
        end
        local mushrooms = table.map{9,184,185,249}
        if mushrooms[npc.id] and Colliders.collide(p, npc) then
            SaveData.totalmushrooms = SaveData.totalmushrooms + 1
        end
        local fireflowers = table.map{14,182,183}
        if fireflowers[npc.id] and Colliders.collide(p, npc) then
            SaveData.totalfireflowers = SaveData.totalfireflowers + 1
        end
        if npc.id == 34 and Colliders.collide(p, npc) then
            SaveData.totalleafs = SaveData.totalleafs + 1
        end
        if npc.id == 169 and Colliders.collide(p, npc) then
            SaveData.totaltanookis = SaveData.totaltanookis + 1
        end
        if npc.id == 170 and Colliders.collide(p, npc) then
            SaveData.totalhammersuits = SaveData.totalhammersuits + 1
        end
        if npc.id == 277 or npc.id == 264 and Colliders.collide(p, npc) then
            SaveData.totaliceflowers = SaveData.totaliceflowers + 1
        end
        local interactable = table.map{9,10,14,31,33,34,35,88,90,92,139,140,141,142,143,144,145,146,147,153,154,155,156,157,169,170,184,185,186,187,188,191,193,249,250,258,274,293,425,462,559,994,996,997}
        if SaveData.disableX2char == true then
            if interactable[npc.id] then
                if blockidx5000check == true then
                    if harmType == HARM_TYPE_LAVA then
                        eastercrash = true
                        if eastercrashprevload == false then
                            Routine.run(lavashroomeasteregg)
                        end
                    end
                end
            end
        end
    end
end

local frametimer = 0
local actualframecount

function globalgenerals.onDraw()
    if smasbooleans.targetPlayers then
        for _,p in ipairs(Player.get()) do
            if p.isValid then
                table.insert(customCamera.targets,p)
            elseif not p.isValid then
                table.remove(customCamera.targets,p)
            end
        end
    end
    if SaveData.disableX2char == false then
        if player.character <= 5 then
            local costumes = playerManager.getCostumes(player.character)
            local currentCostume = player:getCostume()
            local costumeIdx = table.ifind(costumes,currentCostume)
            if costumeIdx == nil then
                playerManager.setCostume(player.character, "!Default")
            end
        end
    end
    if not smasbooleans.targetPlayers and not smasbooleans.overrideTargets then
        customCamera.targets = {}
    end
    if SaveData._basegame.hud.score > 9999900 then
        SaveData._basegame.hud.score = 9990000
    end
    if SaveData.resolution == "fullscreen" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 600
        customCamera.defaultZoom = 1
        customCamera.defaultScreenOffsetY = 0
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
    elseif SaveData.resolution == "widescreen" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 450
        customCamera.defaultZoom = 0.75
        customCamera.defaultScreenOffsetY = 0
        Graphics.drawImageWP(widebars, 0, 0, 7)
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
    elseif SaveData.resolution == "ultrawide" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 337
        customCamera.defaultZoom = 0.562
        customCamera.defaultScreenOffsetY = 0
        Graphics.drawImageWP(ultrawidebars, 0, 0, 7)
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
        customCamera.defaultScreenWidth = 520
        customCamera.defaultScreenHeight = 612
        customCamera.defaultZoom = 0.60
        customCamera.defaultScreenOffsetY = 0
        Graphics.drawImageWP(nesbars, 0, 0, 7)
        if SaveData.letterbox == false then
            smallScreen.priority = 10
            smallScreen.scaleX = 1.56
            smallScreen.scaleY = 1.67
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
    if SaveData.resolution == "gba" then
        customCamera.defaultScreenWidth = 480
        customCamera.defaultScreenHeight = 320
        customCamera.defaultZoom = 0.54
        customCamera.defaultScreenOffsetY = 0
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
    if SaveData.resolution == "3ds" then
        customCamera.defaultScreenWidth = 700
        customCamera.defaultScreenHeight = 419
        customCamera.defaultZoom = 0.58
        customCamera.defaultScreenOffsetY = 70
        Graphics.drawImageWP(threedsbars, 0, 0, 7)
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
    if Misc.inEditor() then
        for k,p in ipairs(Player.get()) do
            p.keys.pause = false
        end
    end
    frametimer = frametimer + 1
    if actualframecount == nil then
        actualframecount = tostring(0)
    end
    if not Misc.isPaused() then
        if frametimer >= 65 then
            actualframecount = tostring(mem(0x00B2C670, FIELD_DWORD))
            frametimer = 0
        end
    end
    if SaveData.framerateEnabled then
        textplus.print{x = 8, y = 8, text = actualframecount, font = numberfont, priority = 0, xscale = 1, yscale = 1}
    end
    if Player.count() >= 2 then
        local playerboundaryx = Player(2).x - player.x
        local playerboundaryy = Player(2).y - player.y
        --Kill player2 if far away, out of the camera bounds
        --if (player.forcedState == FORCEDSTATE_PIPE) == false or (player.forcedState == FORCEDSTATE_DOOR) == false then
            --if playerboundaryx >= 800 and Player(2):mem(0x13C, FIELD_BOOL) == false then
                --Player(2):kill()
            --elseif playerboundaryx <= -800 and Player(2):mem(0x13C, FIELD_BOOL) == false then
                --Player(2):kill()
            --elseif playerboundaryy >= 1200 and Player(2):mem(0x13C, FIELD_BOOL) == false then
                --Player(2):kill()
            --elseif playerboundaryy <= -1200 and Player(2):mem(0x13C, FIELD_BOOL) == false then
                --Player(2):kill()
            --end
        --end
    end
    if eastercrashmsg then
        textplus.print{x=145, y=80, text = "Congrats! You reached more than the 5000th block idx and burned a ", priority=-3, color=Color.yellow, font=statusFont}
        textplus.print{x=155, y=90, text = "collectable in the lava. This would've crashed SMBX 1.3!", priority=-3, color=Color.yellow, font=statusFont}
        textplus.print{x=195, y=100, text = "You're really good at finding secrets, player ;)", priority=-3, color=Color.yellow, font=statusFont}
    end
end

function globalgenerals.onKeyboardPress(keyCode, repeated)
    if SaveData.toggleCostumeAbilities == true then
        if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
            globalgenerals.checkSpecialAbilityMessage()
        end
    end
    if Player.count() >= 2 then
        if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
            globalgenerals.teleport2playermode1P()
        elseif keyCode == smastables.keyboardMap[SaveData.specialkey2ndplayer] and not repeated then
            globalgenerals.teleport2playermode2P()
        end
    end
end

function globalgenerals.onControllerButtonPress(button, playerIdx)
    if SaveData.toggleCostumeAbilities == true then
        if playerIdx == 1 then
            if button == SaveData.specialbutton1stplayer then
                globalgenerals.checkSpecialAbilityMessage()
            end
        end
    end
    if Player.count() >= 2 then
        globalgenerals.teleport2playermodecontroller(button, playerIdx)
    end
end

function globalgenerals.onExitLevel(winType)
    if not Misc.inMarioChallenge() then
        if winType >= 1 and winType ~= LEVEL_END_STATE_GAMEEND then
            if not Misc.inEditor() then
                Level.load("map.lvlx")
            elseif Misc.inEditor() then
                Level.load(SaveData.editorWinnerLevelReload)
            end
        elseif winType == LEVEL_END_STATE_GAMEEND then
            Level.load("SMAS - Credits.lvlx")
        elseif winType == LEVEL_END_STATE_SMB2ORB then
            if not Misc.inEditor() then
                Level.load("map.lvlx")
            elseif Misc.inEditor() then
                Level.load(SaveData.editorWinnerLevelReload)
            end
        end
    end
end

function globalgenerals.onExit()
    if mem(0x00B2C5AC,FIELD_FLOAT) == 0 then
        if killed == true or killed2 == true then
            Level.load(Level.filename())
            mem(0x00B2C5AC,FIELD_FLOAT,1)
        end
    end
    if mem(0x00B2C89C, FIELD_BOOL) then --Let's prevent the credits from execution.
        Level.load("SMAS - Credits.lvlx")
    end
    if table.icontains(smastables._friendlyPlaces,Level.filename()) == false then
        SaveData.lastLevelPlayed = Level.filename()
    end
    if not Misc.inMarioChallenge() then
        File.writeToFile("loadscreeninfo.txt", SaveData.resolution)
    elseif Misc.inMarioChallenge() then
        File.writeToFile("loadscreeninfo.txt", "mariochallenge")
    end
end

return globalgenerals