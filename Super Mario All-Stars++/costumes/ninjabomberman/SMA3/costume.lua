local playerManager = require("playerManager")
local npcManager = require("npcManager")
local Routine = require("routine")
local extrasounds = require("extrasounds")
local rng = require("base/rng")

local costume = {}

costume.loaded = false

local eventsRegistered = false
local ready = false

function costume.onInit(p)
    Routine = require("routine")
    Routine.run(costumechange)
    registerEvent(costume,"onTickEnd")
    if not costume.loaded then
        Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/stomped.ogg")
        Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/block-hit.ogg")
        extrasounds.sounds[4].sfx  = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/block-smash.ogg")
        Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/player-shrink.ogg")
        Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/player-grow.ogg")
        extrasounds.sounds[7].sfx  = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/mushroom.ogg")
        Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/shell-hit.ogg")
        extrasounds.sounds[10].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/player-slide.ogg")
        Audio.sounds[11].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/item-dropped.ogg")
        Audio.sounds[12].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/has-item.ogg")
        Audio.sounds[13].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/camera-change.ogg")
        extrasounds.sounds[15].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/1up.ogg")
        Audio.sounds[16].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/lava.ogg")
        Audio.sounds[17].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/warp.ogg")
        extrasounds.sounds[18].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/fireball.ogg")
        Audio.sounds[20].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/boss-beat.ogg")
        Audio.sounds[22].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/bullet-bill.ogg")
        Audio.sounds[23].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/grab.ogg")
        Audio.sounds[24].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/spring.ogg")
        Audio.sounds[25].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/hammer.ogg")
        Audio.sounds[29].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/do.ogg")
        Audio.sounds[31].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/key.ogg")
        Audio.sounds[32].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/pswitch.ogg")
        extrasounds.sounds[33].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/tail.ogg")
        Audio.sounds[34].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/racoon.ogg")
        Audio.sounds[35].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/boot.ogg")
        extrasounds.sounds[36].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/smash.ogg"))
        Audio.sounds[37].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/thwomp.ogg")
        Audio.sounds[38].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/birdo-spit.ogg")
        extrasounds.sounds[39].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/birdo-hit.ogg"))
        Audio.sounds[41].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/birdo-beat.ogg")
        extrasounds.sounds[42].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/npc-fireball.ogg"))
        extrasounds.sounds[43].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/fireworks.ogg")
        Audio.sounds[44].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/bowser-killed.ogg")
        Audio.sounds[46].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/door.ogg")
        Audio.sounds[47].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/message.ogg")
        Audio.sounds[48].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/yoshi.ogg")
        Audio.sounds[49].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/yoshi-hurt.ogg")
        Audio.sounds[50].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/yoshi-tongue.ogg")
        Audio.sounds[51].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/yoshi-egg.ogg")
        --Audio.sounds[52].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/got-star.ogg")
        Audio.sounds[54].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/player-died2.ogg")
        Audio.sounds[55].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/yoshi-swallow.ogg")
        Audio.sounds[57].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/dry-bones.ogg")
        Audio.sounds[58].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/smw-checkpoint.ogg")
        extrasounds.sounds[59].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/dragon-coin.ogg")
        Audio.sounds[61].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/smw-blaarg.ogg")
        Audio.sounds[62].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/wart-bubble.ogg")
        Audio.sounds[63].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/wart-die.ogg")
        Audio.sounds[71].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/climbing.ogg")
        Audio.sounds[72].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/swim.ogg")
        Audio.sounds[73].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/grab2.ogg")
        --Audio.sounds[74].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/saw.ogg")
        Audio.sounds[75].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/smb2-throw.ogg")
        Audio.sounds[76].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/smb2-hit.ogg")
        Audio.sounds[91].sfx = Audio.SfxOpen("costumes/ninjabomberman/SMA3/SFX/bubble.ogg")
        costume.loaded = true
    end
    eventsRegistered = true
end

function costumechange()
    Routine.wait(0)
    yoshi = require("yiYoshi/yiYoshi")

    yoshi.generalSettings.mainImage = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/main.png")
    yoshi.generalSettings.babyMarioImage = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/babyMario.png")
    yoshi.tongueSettings.image = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/tongue.png")
    yoshi.generalSettings.palettesImage = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/palettes.png")
    
    yoshi.customExitSettings.passOnMusic = SFX.open(Misc.resolveSoundFile("_OST/Super Mario Advance 3/Goal (SFX).ogg"))
    yoshi.customExitSettings.keyMusic = SFX.open(Misc.resolveSoundFile("_OST/Super Mario Advance 3/Big Boss Clear (SFX).ogg"))
    yoshi.customExitSettings.keyMusicStar = SFX.open(Misc.resolveSoundFile("_OST/Super Mario Advance 3/Big Boss Clear (SFX).ogg"))
    
    local rngjump = rng.randomInt(0,1)
    if rngjump == 0 then
        yoshi.generalSettings.jumpSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/jump"))
    elseif rngjump == 1 then
        yoshi.generalSettings.jumpSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/jump2"))
    end
    yoshi.generalSettings.hurtSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/hurt"))
    yoshi.generalSettings.deathSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/dieswithmusic"))
    yoshi.generalSettings.coinSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/coin"))
    
    Audio.sounds[5].sfx  = yoshi.generalSettings.hurtSound
    extrasounds.sounds[8].sfx  = yoshi.generalSettings.deathSound
    extrasounds.sounds[14].sfx = yoshi.generalSettings.coinSound
    
    yoshi.generalSettings.babyCreateBubbleSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/baby_bubbleCreated"))
    yoshi.generalSettings.babyPopBubbleSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/pop"))
    yoshi.generalSettings.babyCrySound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/babymario"))
    yoshi.generalSettings.babyRescuedSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/yoshi"))
    yoshi.generalSettings.babyKidnappedSound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_kidnapped"))
    yoshi.generalSettings.babyCarriedOffSound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_carriedOff"))

    --yoshi.generalSettings.starCounterBackImage = Graphics.loadImageResolved("yiYoshi/starCounter_back.png")
    --yoshi.generalSettings.starCounterNumbersImage = Graphics.loadImageResolved("yiYoshi/starCounter_numbers.png")

    yoshi.generalSettings.starCounterReplenishedSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/starCounter_replenished"))
    yoshi.generalSettings.starCounterSlowBeepingSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/countdownTimerNormal"))
    yoshi.generalSettings.starCounterFastBeepingSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/countdownTimerCritical"))
    yoshi.generalSettings.starCounterIncreaseSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/starget"))
    
    yoshi.introSettings.sound = SFX.open(Misc.resolveSoundFile("_OST/Super Mario Advance 3/Game Start (SFX).ogg"))
    
    yoshi.customExitSettings.keyVictorySound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/yoshi-chant2"))
    yoshi.customExitSettings.keyOpenSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/reveal"))
    yoshi.customExitSettings.keyCloseSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/keyclose"))
    
    yoshi.customExitSettings.scoreMusic = SFX.open(Misc.resolveSoundFile("_OST/Super Mario Advance 3/Score (SFX).ogg"))
    
    yoshi.flutterSettings.sound = SFX.open(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
    yoshi.flutterSettings.soundDelay = 0
    
    yoshi.tongueSettings.startSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/tongue"))
    yoshi.tongueSettings.failedSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/hurt"))
    yoshi.tongueSettings.spitSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/spit"))
    yoshi.tongueSettings.swallowSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/swallow"))

    yoshi.tongueSettings.createEggSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/swallow"))
    yoshi.tongueSettings.startAimSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/yoshi-tongue2"))
    yoshi.tongueSettings.cycleEggsSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/swim2"))
    yoshi.tongueSettings.eggThrowSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/wah"))
    yoshi.tongueSettings.failedThrowSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/wah"))
    yoshi.tongueSettings.eggAimSound = SFX.open(Misc.resolveSoundFile("yiYoshi/aim"))
    
    yoshi.groundPoundSettings.startSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/plying"))
    yoshi.groundPoundSettings.landSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/pound-withrumble"))
    yoshi.initCharacter()
    
    ready = true
end

function costume.onTickEnd()
    local rngjump = rng.randomInt(0,1)
    if rngjump == 0 then
        extrasounds.sounds[1].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/jump"))
    elseif rngjump == 1 then
        extrasounds.sounds[1].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/jump2"))
    end
end

function costume.onCleanup(p)
    extrasounds.sounds[1].sfx = nil    
    Audio.sounds[2].sfx  = nil
    Audio.sounds[3].sfx  = nil
    Audio.sounds[4].sfx  = nil
    Audio.sounds[6].sfx  = nil
    Audio.sounds[7].sfx  = nil
    Audio.sounds[9].sfx  = nil
    extrasounds.sounds[10].sfx = nil
    Audio.sounds[11].sfx = nil
    Audio.sounds[12].sfx = nil
    Audio.sounds[13].sfx = nil
    Audio.sounds[14].sfx = nil
    Audio.sounds[15].sfx = nil
    Audio.sounds[16].sfx = nil
    Audio.sounds[17].sfx = nil
    Audio.sounds[18].sfx = nil
    Audio.sounds[19].sfx = nil
    Audio.sounds[20].sfx = nil
    Audio.sounds[21].sfx = nil
    Audio.sounds[22].sfx = nil
    Audio.sounds[23].sfx = nil
    Audio.sounds[24].sfx = nil
    Audio.sounds[25].sfx = nil
    Audio.sounds[29].sfx = nil
    Audio.sounds[31].sfx = nil
    Audio.sounds[32].sfx = nil
    extrasounds.sounds[33].sfx = nil
    Audio.sounds[34].sfx = nil
    Audio.sounds[35].sfx = nil
    extrasounds.sounds[36].sfx = nil
    Audio.sounds[37].sfx = nil
    Audio.sounds[38].sfx = nil
    extrasounds.sounds[39].sfx = nil
    Audio.sounds[41].sfx = nil
    extrasounds.sounds[42].sfx = nil
    extrasounds.sounds[43].sfx = nil
    Audio.sounds[44].sfx = nil
    Audio.sounds[46].sfx = nil
    Audio.sounds[47].sfx = nil
    Audio.sounds[48].sfx = nil
    Audio.sounds[49].sfx = nil
    Audio.sounds[50].sfx = nil
    Audio.sounds[51].sfx = nil
    Audio.sounds[52].sfx = nil
    Audio.sounds[54].sfx = nil
    Audio.sounds[55].sfx = nil
    Audio.sounds[56].sfx = nil
    Audio.sounds[57].sfx = nil
    Audio.sounds[58].sfx = nil
    Audio.sounds[59].sfx = nil
    Audio.sounds[61].sfx = nil
    Audio.sounds[62].sfx = nil
    Audio.sounds[63].sfx = nil
    Audio.sounds[71].sfx = nil
    Audio.sounds[72].sfx = nil
    Audio.sounds[73].sfx = nil
    Audio.sounds[75].sfx = nil
    Audio.sounds[76].sfx = nil
    extrasounds.sounds[77].sfx = nil
    Audio.sounds[78].sfx = nil
    Audio.sounds[79].sfx = nil
    Audio.sounds[80].sfx = nil
    extrasounds.sounds[81].sfx = nil
    Audio.sounds[82].sfx = nil
    Audio.sounds[91].sfx = nil
    local character = player.character;
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()

    local costumes
    yoshi = require("yiYoshi/yiYoshi")
    yoshi.generalSettings.mainImage = Graphics.loadImageResolved("yiYoshi/main.png")
    yoshi.generalSettings.babyMarioImage = Graphics.loadImageResolved("yiYoshi/babyMario.png")
    yoshi.generalSettings.palettesImage = Graphics.loadImageResolved("yiYoshi/palettes.png")
    
    yoshi.generalSettings.jumpSound  = SFX.open(Misc.resolveSoundFile("yiYoshi/jump"))
    yoshi.generalSettings.hurtSound  = SFX.open(Misc.resolveSoundFile("yoshi-hurt"))
    yoshi.generalSettings.deathSound = SFX.open(Misc.resolveSoundFile("yiYoshi/death"))
    yoshi.generalSettings.coinSound  = SFX.open(Misc.resolveSoundFile("yiYoshi/coin"))
    
    yoshi.generalSettings.babyCreateBubbleSound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_bubbleCreated"))
    yoshi.generalSettings.babyPopBubbleSound = SFX.open(Misc.resolveSoundFile("yiYoshi/pop"))
    yoshi.generalSettings.babyCrySound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_cry"))
    yoshi.generalSettings.babyRescuedSound = SFX.open(Misc.resolveSoundFile("yoshi"))
    yoshi.generalSettings.babyKidnappedSound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_kidnapped"))
    yoshi.generalSettings.babyCarriedOffSound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_carriedOff"))

    yoshi.generalSettings.starCounterBackImage = Graphics.loadImageResolved("yiYoshi/starCounter_back.png")
    yoshi.generalSettings.starCounterNumbersImage = Graphics.loadImageResolved("yiYoshi/starCounter_numbers.png")

    yoshi.generalSettings.starCounterReplenishedSound = SFX.open(Misc.resolveSoundFile("yiYoshi/starCounter_replenished"))
    yoshi.generalSettings.starCounterSlowBeepingSound = SFX.open(Misc.resolveSoundFile("yiYoshi/starCounter_slowBeeping"))
    yoshi.generalSettings.starCounterFastBeepingSound = SFX.open(Misc.resolveSoundFile("yiYoshi/starCounter_fastBeeping"))
    yoshi.generalSettings.starCounterIncreaseSound = SFX.open(Misc.resolveSoundFile("yiYoshi/starCounter_increase"))
    
    yoshi.introSettings.sound = SFX.open(Misc.resolveSoundFile("yiYoshi/intro.ogg"))
    
    yoshi.customExitSettings.keyVictorySound = SFX.open(Misc.resolveSoundFile("yoshi"))
    yoshi.customExitSettings.keyOpenSound = SFX.open(Misc.resolveSoundFile("yiYoshi/reveal"))
    yoshi.customExitSettings.keyCloseSound = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_keyClose"))

    yoshi.customExitSettings.passOnMusic = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_start"))
    yoshi.customExitSettings.keyMusic = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_key"))
    yoshi.customExitSettings.keyMusicStar = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_key_star"))
    yoshi.customExitSettings.scoreMusic = SFX.open(Misc.resolveSoundFile("yiYoshi/exit_score"))
    
    yoshi.flutterSettings.sound = SFX.open(Misc.resolveSoundFile("yiYoshi/flutter"))
    yoshi.flutterSettings.soundDelay = 0
    
    yoshi.tongueSettings.image = Graphics.loadImageResolved("yiYoshi/tongue.png")
    yoshi.tongueSettings.startSound = SFX.open(Misc.resolveSoundFile("yiYoshi/tongue_start"))
    yoshi.tongueSettings.failedSound = SFX.open(Misc.resolveSoundFile("yiYoshi/tongue_failed"))
    yoshi.tongueSettings.spitSound = SFX.open(Misc.resolveSoundFile("birdo-spit"))
    yoshi.tongueSettings.swallowSound = SFX.open(Misc.resolveSoundFile("yoshi-swallow"))

    yoshi.tongueSettings.createEggSound = SFX.open(Misc.resolveSoundFile("yiYoshi/pop"))
    yoshi.tongueSettings.startAimSound = SFX.open(Misc.resolveSoundFile("yoshi-tongue"))
    yoshi.tongueSettings.cycleEggsSound = SFX.open(Misc.resolveSoundFile("swim"))
    yoshi.tongueSettings.eggThrowSound = SFX.open(Misc.resolveSoundFile("yiYoshi/egg_thrown"))
    yoshi.tongueSettings.failedThrowSound = SFX.open(Misc.resolveSoundFile("yiYoshi/egg_failedThrow"))
    yoshi.tongueSettings.eggAimSound = SFX.open(Misc.resolveSoundFile("yiYoshi/aim"))
    
    yoshi.groundPoundSettings.startSound = SFX.open(Misc.resolveSoundFile("yiYoshi/groundPound_start"))
    yoshi.groundPoundSettings.landSound = SFX.open(Misc.resolveSoundFile("yiYoshi/groundPound_land"))
    yoshi.flutterSettings.soundDelay = 6
    
    Defines.player_walkspeed = nil
    Defines.player_runspeed = nil

    Defines.player_grabSideEnabled = nil
    Defines.player_grabTopEnabled = nil
    Defines.player_grabShellEnabled = nil

    Sound.cleanupCostumeSounds()
    
    yoshi.cleanupCharacter()
    
    if character then
        Defines.player_walkspeed = nil
        Defines.player_runspeed = nil
    end
end

Misc.storeLatestCostumeData(costume)

return costume