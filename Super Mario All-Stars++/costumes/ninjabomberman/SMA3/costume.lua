local playerManager = require("playerManager")
local npcManager = require("npcManager")
local Routine = require("routine")

local costume = {}

local eventsRegistered = false

function costume.onInit(p)
	Routine = require("routine")
	registerEvent(costume,"onStart")
	registerEvent(costume,"onTick")
	Routine.run(costumechange)
	eventsRegistered = true
end

function costumechange()
	Routine.wait(0.1)
	yoshi = require("yiYoshi/yiYoshi")
	local resetAnimationData
	yoshi.generalSettings.mainImage = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/main.png")
	yoshi.generalSettings.babyMarioImage = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/babyMario.png")
	yoshi.tongueSettings.image = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/tongue.png")
	yoshi.customExitSettings.passOnMusic = SFX.open(Misc.resolveSoundFile("_OST/Super Mario Advance 3/Goal.ogg"))
    yoshi.customExitSettings.keyMusic = SFX.open(Misc.resolveSoundFile("_OST/Super Mario Advance 3/Big Boss Clear (SFX).ogg"))
    yoshi.customExitSettings.keyMusicStar = SFX.open(Misc.resolveSoundFile("_OST/Super Mario Advance 3/Big Boss Clear (SFX).ogg"))
	
	yoshi.generalSettings.mainImage = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/main.png")
	yoshi.generalSettings.babyMarioImage = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/babyMario.png")
	yoshi.tongueSettings.image = Graphics.loadImageResolved("costumes/ninjabomberman/SMA3/tongue.png")

	yoshi.generalSettings.jumpSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/jump2"))
    yoshi.generalSettings.hurtSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/hurt"))
    yoshi.generalSettings.deathSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/dies"))
    yoshi.generalSettings.coinSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/coin"))
	
	Audio.sounds[1].sfx  = yoshi.generalSettings.jumpSound
    Audio.sounds[5].sfx  = yoshi.generalSettings.hurtSound
    Audio.sounds[8].sfx  = yoshi.generalSettings.deathSound
    Audio.sounds[14].sfx = yoshi.generalSettings.coinSound
	
	--yoshi.generalSettings.babyCreateBubbleSound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_bubbleCreated"))
    yoshi.generalSettings.babyPopBubbleSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/pop"))
    yoshi.generalSettings.babyCrySound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/babyMario"))
    --yoshi.generalSettings.babyRescuedSound = SFX.open(Misc.resolveSoundFile("yoshi"))
    --yoshi.generalSettings.babyKidnappedSound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_kidnapped"))
    --yoshi.generalSettings.babyCarriedOffSound = SFX.open(Misc.resolveSoundFile("yiYoshi/baby_carriedOff"))

    --yoshi.generalSettings.starCounterBackImage = Graphics.loadImageResolved("yiYoshi/starCounter_back.png")
    --yoshi.generalSettings.starCounterNumbersImage = Graphics.loadImageResolved("yiYoshi/starCounter_numbers.png")

    --yoshi.generalSettings.starCounterReplenishedSound = SFX.open(Misc.resolveSoundFile("yiYoshi/starCounter_replenished"))
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
    yoshi.tongueSettings.failedSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/hurt-minor"))
    yoshi.tongueSettings.spitSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/spit"))
    yoshi.tongueSettings.swallowSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/swallow"))

    yoshi.tongueSettings.createEggSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/swallow"))
    --yoshi.tongueSettings.startAimSound = SFX.open(Misc.resolveSoundFile("yoshi-tongue"))
    --yoshi.tongueSettings.cycleEggsSound = SFX.open(Misc.resolveSoundFile("swim"))
    yoshi.tongueSettings.eggThrowSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/wah"))
    yoshi.tongueSettings.failedThrowSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/wah"))
    yoshi.tongueSettings.eggAimSound = SFX.open(Misc.resolveSoundFile("yiYoshi/aim"))
	
	yoshi.groundPoundSettings.startSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/plying"))
    yoshi.groundPoundSettings.landSound = SFX.open(Misc.resolveSoundFile("costumes/ninjabomberman/SMA3/SFX/pound-withrumble"))
	yoshi.initCharacter()
end

function costume.onCleanup(p)
	yoshi = require("yiYoshi/yiYoshi")
	Audio.sounds[1].sfx  = nil
    Audio.sounds[5].sfx  = nil
    Audio.sounds[8].sfx  = nil
    Audio.sounds[14].sfx = nil
    Audio.sounds[19].sfx = nil
    Audio.sounds[60].sfx = nil
    Audio.sounds[21].sfx = nil
    Audio.sounds[40].sfx = nil
	yoshi.generalSettings.mainImage = Graphics.loadImageResolved("yiYoshi/main.png")
	yoshi.generalSettings.babyMarioImage = Graphics.loadImageResolved("yiYoshi/babyMario.png")
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
	yoshi.initCharacter()
end

return costume