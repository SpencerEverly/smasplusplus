--extrasounds.lua by Spencer Everly (v0.2.2)
--
--To use this everywhere, you can simply put this under luna.lua:
--_G.extrasounds = require("extrasounds")
--
--And to have costume compability, require this library with playermanager on any/all costumes you're using, then replace sound slot IDs 4,7,8,14,15,18,39,42,43,59 from (example):
--
--Audio.sounds[14].sfx = Audio.SfxOpen("costumes/(character)/(costume)/coin.ogg")
--to
--extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/(character)/(costume)/coin.ogg"))
--
--Check the lua file for info on which things does what

local extrasounds = {}

--Are the extra sounds active? If not, they won't play. If false the library won't be used and will revert to the stock sound system. Useful for muting all sounds for a boot menu, cutscene, or something like that by using Audio.sounds[id].muted = true instead.
extrasounds.active = true

--**DELAY SETTINGS**
--Set this to any number to change how much the P-Switch Timer should delay to. Default is 50.
extrasounds.pSwitchTimerDelay = 50
--Set this to any number to change how much the P-Switch Timer should delay to when the timer has almost run out. Default is 15.
extrasounds.pSwitchTimerDelayFast = 15
--Set this to any number to change how much the P-Wing sound should delay to. Default is 7.
extrasounds.pWingDelay = 7

--**FIRE/ICE/HAMMER SETTINGS**
--Whenever to enable the Fire Flower sound.
extrasounds.enableFireFlowerSFX = true
--Whenever to enable the Ice Flower sound.
extrasounds.enableIceFlowerSFX = true
--Whenever to enable the Hammer Suit sound.
extrasounds.enableHammerSuitSFX = true

--Whenever to revert to the fire flower sound when using an ice flower instead of using the custom sound.
extrasounds.useFireSoundForIce = false
--Whenever to revert to the fire flower sound when using a hammer suit instead of using the custom sound.
extrasounds.useFireSoundForHammerSuit = false

--**PROJECTILE SETTINGS**
--Whenever to enable the boomerang SFX for Toad.
extrasounds.enableToadBoomerangSFX = true
--Whenever to enable the boomerang SFX for the Boomerang Bros.
extrasounds.enableBoomerangBroBoomerangSFX = true

--**1UP SETTINGS**
--Whenever to use the original 1UP sound instead of using the other custom sounds.
extrasounds.use1UPSoundForAll1UPs = false

--**EXPLOSION SETTINGS**
--Whenever to enable the SMB2 explosion SFX.
extrasounds.enableSMB2ExplosionSFX = true
--Whenever to use the original explosion sound instead of using the other custom sounds.
extrasounds.useFireworksInsteadOfOtherExplosions = false

--**BLOCK SETTINGS**
--Whenever to enable all normal brick smashing SFXs.
extrasounds.enableBrickSmashing = true
--Whenever to enable coin SFXs when hitting blocks.
extrasounds.enableBlockCoinCollecting = true
--Whenever to use the original sprout sound instead of using the other custom sounds.
extrasounds.useOriginalBlockSproutInstead = false

--**COIN SETTINGS**
--Whenever to enable the coin collecting SFX.
extrasounds.enableCoinCollecting = true
--Whenever to enable the cherry collecting SFX.
extrasounds.enableCherryCollecting = true
--Whenever to use the original dragon coin sounds instead of the other custom sounds.
extrasounds.useOriginalDragonCoinSounds = false

--**MISC SETTINGS**
--Whenever to enable the NPC to Coin SFX.
extrasounds.enableNPCtoCoin = true
--Whenever to enable the HP get SFXs.
extrasounds.enableHPCollecting = true
--Whenever to use the original spinjumping SFX for big enemies instead.
extrasounds.useOriginalSpinJumpForBigEnemies = false
--Whenever to enable the SMB2 enemy kill sounds.
extrasounds.enableSMB2EnemyKillSounds = true
--Whenever to enable star collecting sounds.
extrasounds.enableStarCollecting = true

local blockManager = require("blockManager") --Used to detect brick breaks when spinjumping

local spinballcounter = 1
local combo = 0
local time = 0
local yoshimouthindex = 0
local jumptimer = 0

local ready = false --This library isn't ready until onInit is finished

extrasounds.id = {}
extrasounds.id[0]   = Audio.SfxOpen(Misc.resolveSoundFile("nothing.ogg")) --General sound to mute anything, really

--Stock SMBX Sounds
extrasounds.id[1]   = Audio.SfxOpen(Misc.resolveSoundFile("player-jump.ogg"))
extrasounds.id[2]   = Audio.SfxOpen(Misc.resolveSoundFile("stomped.ogg"))
extrasounds.id[3]   = Audio.SfxOpen(Misc.resolveSoundFile("block-hit.ogg"))
extrasounds.id[4]   = Audio.SfxOpen(Misc.resolveSoundFile("block-smash.ogg"))
extrasounds.id[5]   = Audio.SfxOpen(Misc.resolveSoundFile("player-shrink.ogg"))
extrasounds.id[6]   = Audio.SfxOpen(Misc.resolveSoundFile("player-grow.ogg"))
extrasounds.id[7]   = Audio.SfxOpen(Misc.resolveSoundFile("mushroom.ogg"))
extrasounds.id[8]   = Audio.SfxOpen(Misc.resolveSoundFile("player-died.ogg"))
extrasounds.id[9]   = Audio.SfxOpen(Misc.resolveSoundFile("shell-hit.ogg"))
extrasounds.id[10]  = Audio.SfxOpen(Misc.resolveSoundFile("player-slide.ogg"))
extrasounds.id[11]  = Audio.SfxOpen(Misc.resolveSoundFile("item-dropped.ogg"))
extrasounds.id[12]  = Audio.SfxOpen(Misc.resolveSoundFile("has-item.ogg"))
extrasounds.id[13]  = Audio.SfxOpen(Misc.resolveSoundFile("camera-change.ogg"))
extrasounds.id[14]  = Audio.SfxOpen(Misc.resolveSoundFile("coin.ogg"))
extrasounds.id[15]  = Audio.SfxOpen(Misc.resolveSoundFile("1up.ogg"))
extrasounds.id[16]  = Audio.SfxOpen(Misc.resolveSoundFile("lava.ogg"))
extrasounds.id[17]  = Audio.SfxOpen(Misc.resolveSoundFile("warp.ogg"))
extrasounds.id[18]  = Audio.SfxOpen(Misc.resolveSoundFile("fireball.ogg"))
extrasounds.id[19]  = Audio.SfxOpen(Misc.resolveSoundFile("level-win.ogg"))
extrasounds.id[20]  = Audio.SfxOpen(Misc.resolveSoundFile("boss-beat.ogg"))
extrasounds.id[21]  = Audio.SfxOpen(Misc.resolveSoundFile("dungeon-win.ogg"))
extrasounds.id[22]  = Audio.SfxOpen(Misc.resolveSoundFile("bullet-bill.ogg"))
extrasounds.id[23]  = Audio.SfxOpen(Misc.resolveSoundFile("grab.ogg"))
extrasounds.id[24]  = Audio.SfxOpen(Misc.resolveSoundFile("spring.ogg"))
extrasounds.id[25]  = Audio.SfxOpen(Misc.resolveSoundFile("hammer.ogg"))
extrasounds.id[26]  = Audio.SfxOpen(Misc.resolveSoundFile("slide.ogg"))
extrasounds.id[27]  = Audio.SfxOpen(Misc.resolveSoundFile("newpath.ogg"))
extrasounds.id[28]  = Audio.SfxOpen(Misc.resolveSoundFile("level-select.ogg"))
extrasounds.id[29]  = Audio.SfxOpen(Misc.resolveSoundFile("do.ogg"))
extrasounds.id[30]  = Audio.SfxOpen(Misc.resolveSoundFile("pause.ogg"))
extrasounds.id[31]  = Audio.SfxOpen(Misc.resolveSoundFile("key.ogg"))
extrasounds.id[32]  = Audio.SfxOpen(Misc.resolveSoundFile("pswitch.ogg"))
extrasounds.id[33]  = Audio.SfxOpen(Misc.resolveSoundFile("tail.ogg"))
extrasounds.id[34]  = Audio.SfxOpen(Misc.resolveSoundFile("racoon.ogg"))
extrasounds.id[35]  = Audio.SfxOpen(Misc.resolveSoundFile("boot.ogg"))
extrasounds.id[36]  = Audio.SfxOpen(Misc.resolveSoundFile("smash.ogg"))
extrasounds.id[37]  = Audio.SfxOpen(Misc.resolveSoundFile("thwomp.ogg"))
extrasounds.id[38]  = Audio.SfxOpen(Misc.resolveSoundFile("birdo-spit.ogg"))
extrasounds.id[39]  = Audio.SfxOpen(Misc.resolveSoundFile("birdo-hit.ogg"))
extrasounds.id[40]  = Audio.SfxOpen(Misc.resolveSoundFile("smb2-exit.ogg"))
extrasounds.id[41]  = Audio.SfxOpen(Misc.resolveSoundFile("birdo-beat.ogg"))
extrasounds.id[42]  = Audio.SfxOpen(Misc.resolveSoundFile("npc-fireball.ogg"))
extrasounds.id[43]  = Audio.SfxOpen(Misc.resolveSoundFile("fireworks.ogg"))
extrasounds.id[44]  = Audio.SfxOpen(Misc.resolveSoundFile("bowser-killed.ogg"))
extrasounds.id[45]  = Audio.SfxOpen(Misc.resolveSoundFile("game-beat.ogg"))
extrasounds.id[46]  = Audio.SfxOpen(Misc.resolveSoundFile("door.ogg"))
extrasounds.id[47]  = Audio.SfxOpen(Misc.resolveSoundFile("message.ogg"))
extrasounds.id[48]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi.ogg"))
extrasounds.id[49]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-hurt.ogg"))
extrasounds.id[50]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-tongue.ogg"))
extrasounds.id[51]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-egg.ogg"))
extrasounds.id[52]  = Audio.SfxOpen(Misc.resolveSoundFile("got-star.ogg"))
extrasounds.id[53]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-kill.ogg"))
extrasounds.id[54]  = Audio.SfxOpen(Misc.resolveSoundFile("player-died2.ogg"))
extrasounds.id[55]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-swallow.ogg"))
extrasounds.id[56]  = Audio.SfxOpen(Misc.resolveSoundFile("ring.ogg"))
extrasounds.id[57]  = Audio.SfxOpen(Misc.resolveSoundFile("dry-bones.ogg"))
extrasounds.id[58]  = Audio.SfxOpen(Misc.resolveSoundFile("smw-checkpoint.ogg"))
extrasounds.id[59]  = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin.ogg"))
extrasounds.id[60]  = Audio.SfxOpen(Misc.resolveSoundFile("smw-exit.ogg"))
extrasounds.id[61]  = Audio.SfxOpen(Misc.resolveSoundFile("smw-blaarg.ogg"))
extrasounds.id[62]  = Audio.SfxOpen(Misc.resolveSoundFile("wart-bubble.ogg"))
extrasounds.id[63]  = Audio.SfxOpen(Misc.resolveSoundFile("wart-die.ogg"))
extrasounds.id[64]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-block-hit.ogg"))
extrasounds.id[65]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-killed.ogg"))
extrasounds.id[66]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-hurt.ogg"))
extrasounds.id[67]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-glass.ogg"))
extrasounds.id[68]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-boss-hit.ogg"))
extrasounds.id[69]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-cry.ogg"))
extrasounds.id[70]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-explosion.ogg"))
extrasounds.id[71]  = Audio.SfxOpen(Misc.resolveSoundFile("climbing.ogg"))
extrasounds.id[72]  = Audio.SfxOpen(Misc.resolveSoundFile("swim.ogg"))
extrasounds.id[73]  = Audio.SfxOpen(Misc.resolveSoundFile("grab2.ogg"))
extrasounds.id[74]  = Audio.SfxOpen(Misc.resolveSoundFile("smw-saw.ogg"))
extrasounds.id[75]  = Audio.SfxOpen(Misc.resolveSoundFile("smb2-throw.ogg"))
extrasounds.id[76]  = Audio.SfxOpen(Misc.resolveSoundFile("smb2-hit.ogg"))
extrasounds.id[77]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-stab.ogg"))
extrasounds.id[78]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-hurt.ogg"))
extrasounds.id[79]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-heart.ogg"))
extrasounds.id[80]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-died.ogg"))
extrasounds.id[81]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-rupee.ogg"))
extrasounds.id[82]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-fire.ogg"))
extrasounds.id[83]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-item.ogg"))
extrasounds.id[84]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-key.ogg"))
extrasounds.id[85]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-shield.ogg"))
extrasounds.id[86]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-dash.ogg"))
extrasounds.id[87]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-fairy.ogg"))
extrasounds.id[88]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-grass.ogg"))
extrasounds.id[89]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-hit.ogg"))
extrasounds.id[90]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-sword-beam.ogg"))
extrasounds.id[91]  = Audio.SfxOpen(Misc.resolveSoundFile("bubble.ogg"))

--Additional SMBX Sounds
extrasounds.id[92]  = Audio.SfxOpen(Misc.resolveSoundFile("sprout-vine.ogg")) --Vine Sprout
extrasounds.id[93]  = Audio.SfxOpen(Misc.resolveSoundFile("iceball.ogg")) --Iceball
extrasounds.id[94]  = Audio.SfxOpen(Misc.resolveSoundFile("yi-freeze.ogg")) --Freeze (Yoshi's Island)
extrasounds.id[95]  = Audio.SfxOpen(Misc.resolveSoundFile("yi-icebreak.ogg")) --Ice Break (Yoshi's Island)
extrasounds.id[96]  = Audio.SfxOpen(Misc.resolveSoundFile("2up.ogg")) --2UP
extrasounds.id[97]  = Audio.SfxOpen(Misc.resolveSoundFile("3up.ogg")) --3UP
extrasounds.id[98]  = Audio.SfxOpen(Misc.resolveSoundFile("5up.ogg")) --5UP
extrasounds.id[99]  = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin-get2.ogg")) --Dragon Coin #2
extrasounds.id[100] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin-get3.ogg")) --Dragon Coin #3
extrasounds.id[101] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin-get4.ogg")) --Dragon Coin #4
extrasounds.id[102] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin-get5.ogg")) --Dragon Coin #5
extrasounds.id[103] = Audio.SfxOpen(Misc.resolveSoundFile("cherry.ogg")) --Cherry
extrasounds.id[104] = Audio.SfxOpen(Misc.resolveSoundFile("explode.ogg")) --SMB2 Explosion
extrasounds.id[105] = Audio.SfxOpen(Misc.resolveSoundFile("hammerthrow.ogg")) --Player Hammer Throw
extrasounds.id[106] = Audio.SfxOpen(Misc.resolveSoundFile("combo1.ogg")) --Shell Hit 2
extrasounds.id[107] = Audio.SfxOpen(Misc.resolveSoundFile("combo2.ogg")) --Shell Hit 3
extrasounds.id[108] = Audio.SfxOpen(Misc.resolveSoundFile("combo3.ogg")) --Shell Hit 4
extrasounds.id[109] = Audio.SfxOpen(Misc.resolveSoundFile("combo4.ogg")) --Shell Hit 5
extrasounds.id[110] = Audio.SfxOpen(Misc.resolveSoundFile("combo5.ogg")) --Shell Hit 6
extrasounds.id[111] = Audio.SfxOpen(Misc.resolveSoundFile("combo6.ogg")) --Shell Hit 7
extrasounds.id[112] = Audio.SfxOpen(Misc.resolveSoundFile("combo7.ogg")) --Shell Hit 8
extrasounds.id[113] = Audio.SfxOpen(Misc.resolveSoundFile("score-tally.ogg")) --SMB1 Flagpole Score Tally
extrasounds.id[114] = Audio.SfxOpen(Misc.resolveSoundFile("score-tally-end.ogg")) --SMB1 Flagpole Score Tally (End)
extrasounds.id[115] = Audio.SfxOpen(Misc.resolveSoundFile("bowser-fire.ogg")) --Bowser Fireball
extrasounds.id[116] = Audio.SfxOpen(Misc.resolveSoundFile("boomerang.ogg")) --Boomerang
extrasounds.id[117] = Audio.SfxOpen(Misc.resolveSoundFile("smb2-charge.ogg")) --SMB2 High Jump Charge
extrasounds.id[118] = Audio.SfxOpen(Misc.resolveSoundFile("stopwatch.ogg")) --Stopwatch
extrasounds.id[119] = Audio.SfxOpen(Misc.resolveSoundFile("whale-spout.ogg")) --SMB2 Whale Water Sprout
extrasounds.id[120] = Audio.SfxOpen(Misc.resolveSoundFile("door-reveal.ogg")) --SMB3 Door Reveal (Peach)
extrasounds.id[121] = Audio.SfxOpen(Misc.resolveSoundFile("p-wing.ogg")) --SMB3 P-Wing
extrasounds.id[122] = Audio.SfxOpen(Misc.resolveSoundFile("wand-moving.ogg")) --SMB3 Wand Moving
extrasounds.id[123] = Audio.SfxOpen(Misc.resolveSoundFile("wand-whoosh.ogg")) --SMB3 Wand Air Whoosh (Custom)
extrasounds.id[124] = Audio.SfxOpen(Misc.resolveSoundFile("hop.ogg")) --SMB3 Hop
extrasounds.id[125] = Audio.SfxOpen(Misc.resolveSoundFile("smash-big.ogg")) --Big Smash (SMB1 Toad Pile)
extrasounds.id[126] = Audio.SfxOpen(Misc.resolveSoundFile("smb2-hitenemy.ogg")) --SMB2 Enemy Hit
extrasounds.id[127] = Audio.SfxOpen(Misc.resolveSoundFile("boss-fall.ogg")) --SMW Boss Fall
extrasounds.id[128] = Audio.SfxOpen(Misc.resolveSoundFile("boss-lava.ogg")) --SMW Boss Lava Hit
extrasounds.id[129] = Audio.SfxOpen(Misc.resolveSoundFile("boss-shrink.ogg")) --SMW Boss Shrink (Shrinking)
extrasounds.id[130] = Audio.SfxOpen(Misc.resolveSoundFile("boss-shrink-done.ogg")) --SMW Boss Shrink (Done Shrinking)
extrasounds.id[131] = Audio.SfxOpen(Misc.resolveSoundFile("hp-get.ogg")) --Recieve HP (Mario Multiverse)
extrasounds.id[132] = Audio.SfxOpen(Misc.resolveSoundFile("hp-max.ogg")) --HP is maxed out (Mario Multiverse)
extrasounds.id[133] = Audio.SfxOpen(Misc.resolveSoundFile("cape-feather.ogg")) --Cape Feather (SMW)
extrasounds.id[134] = Audio.SfxOpen(Misc.resolveSoundFile("cape-fly.ogg")) --Cape Flying (SMW)
extrasounds.id[135] = Audio.SfxOpen(Misc.resolveSoundFile("flag-slide.ogg")) --Flagpole Sliding (SMB1)
extrasounds.id[136] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-clear.ogg")) --Flagpole Fanfare (SMB1)
extrasounds.id[137] = Audio.SfxOpen(Misc.resolveSoundFile("smb2-clear.ogg")) --World Clear Fanfare (SMB2)
extrasounds.id[138] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-world-clear.ogg")) --World Clear Fanfare (SMB1)
extrasounds.id[139] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-underground-overworld.ogg")) --Going Underground, Overworld (SMB1)
extrasounds.id[140] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-underground-desert.ogg")) --Going Underground, Desert (SMB1)
extrasounds.id[141] = Audio.SfxOpen(Misc.resolveSoundFile("smb1-underground-sky.ogg")) --Going Underground, Sky (SMB1)
extrasounds.id[142] = Audio.SfxOpen(Misc.resolveSoundFile("goaltape-countdown-start.ogg")) --Goaltape, Start (SMW)
extrasounds.id[143] = Audio.SfxOpen(Misc.resolveSoundFile("goaltape-countdown-loop.ogg")) --Goaltape, Loop (SMW)
extrasounds.id[144] = Audio.SfxOpen(Misc.resolveSoundFile("goaltape-countdown-end.ogg")) --Goaltape, End (SMW)
extrasounds.id[145] = Audio.SfxOpen(Misc.resolveSoundFile("goaltape-irisout.ogg")) --Goaltape, Iris Out (SMW)
extrasounds.id[146] = Audio.SfxOpen(Misc.resolveSoundFile("smw-exit-orb.ogg")) --SMW Orb Exit
extrasounds.id[147] = Audio.SfxOpen(Misc.resolveSoundFile("ace-coins-5.ogg")) --SMA All Ace Coins Collected
extrasounds.id[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg")) --SMB3 Door Close
extrasounds.id[149] = Audio.SfxOpen(Misc.resolveSoundFile("sprout-megashroom.ogg")) --Mega Mushroom Block Sprout (Custom)
extrasounds.id[150] = Audio.SfxOpen(Misc.resolveSoundFile("0up.ogg")) --0up (Super Mario Maker 2)
extrasounds.id[151] = Audio.SfxOpen(Misc.resolveSoundFile("correct.ogg")) --Correct (SMAS)
extrasounds.id[152] = Audio.SfxOpen(Misc.resolveSoundFile("wrong.ogg")) --Wrong (SMAS)
extrasounds.id[153] = Audio.SfxOpen(Misc.resolveSoundFile("castle-destroy.ogg")) --Destroy Castle (SMW)

--Non-Changable Sounds (Specific to SMAS++, which doesn't necessarily use any character utilizing to use these sounds)
extrasounds.id[1000] = Audio.SfxOpen(Misc.resolveSoundFile("menu/dialog.ogg")) --Dialog Menu Picker
extrasounds.id[1001] = Audio.SfxOpen(Misc.resolveSoundFile("menu/dialog-confirm.ogg")) --Dialog Menu Choosing Confirmed

extrasounds.stockSoundNumbersInOrder = table.map{1,2,3,5,6,9,10,11,12,13,14,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,40,41,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91}

extrasounds.allVanillaSoundNumbersInOrder = table.map{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91}

--Uncomment below for each official SMBX2 library release.
--function playSound(name) --If you want to play any of these sounds simply, you can use playSound(id), or you can use a string. This is similar to SFX.play, but with extrasounds support!
	--if name == nil then
		--error("That sound doesn't exist. Play something else.")
	--end
	--if unexpected_condition then error("That sound doesn't exist. Play something else.") end
	
	--if extrasounds.active then
		--if extrasounds.id[name] and not extrasounds.stockSoundNumbersInOrder[name] then
			--SFX.play(extrasounds.id[name])
		--elseif extrasounds.stockSoundNumbersInOrder[name] then
			--SFX.play(name)
		--elseif name then
			--local file = Misc.resolveSoundFile(name)
			--SFX.play(file) --Then play it afterward
		--end
	--elseif not extrasounds.active then
		--if extrasounds.allVanillaSoundNumbersInOrder[name] then
			--SFX.play(name)
		--elseif name then
			--local file = Misc.resolveSoundFile(name)
			--SFX.play(file) --Then play it afterward
		--end
	--end
--end

local spinjumpablebricks = table.map{90,526}

local extrasoundsblock90 = {}
local extrasoundsblock668 = {}

function extrasounds.onInitAPI() --This'll require a bunch of events to start
	registerEvent(extrasounds, "onKeyboardPress")
	registerEvent(extrasounds, "onDraw")
	registerEvent(extrasounds, "onLevelExit")
	registerEvent(extrasounds, "onTick")
	registerEvent(extrasounds, "onTickEnd")
	registerEvent(extrasounds, "onInputUpdate")
	registerEvent(extrasounds, "onStart")
	registerEvent(extrasounds, "onPostNPCKill")
	registerEvent(extrasounds, "onNPCKill")
	registerEvent(extrasounds, "onPostNPCHarm")
	registerEvent(extrasounds, "onNPCHarm")
	registerEvent(extrasounds, "onPostPlayerHarm")
	registerEvent(extrasounds, "onPostPlayerKill")
	registerEvent(extrasounds, "onPostExplosion")
	registerEvent(extrasounds, "onExplosion")
	registerEvent(extrasounds, "onPostBlockHit")
	registerEvent(extrasounds, "onPlayerKill")
	
	blockManager.registerEvent(90, extrasoundsblock90, "onCollideBlock")
	blockManager.registerEvent(668, extrasoundsblock668, "onCollideBlock")
	
	local Routine = require("routine")
	
	ready = true --We're ready, so we can begin
end

local function harmNPC(npc,...) -- npc:harm but it returns if it actually did anything
    local oldKilled     = npc:mem(0x122,FIELD_WORD)
    local oldProjectile = npc:mem(0x136,FIELD_BOOL)
    local oldHitCount   = npc:mem(0x148,FIELD_FLOAT)
    local oldImmune     = npc:mem(0x156,FIELD_WORD)
    local oldID         = npc.id
    local oldSpeedX     = npc.speedX
    local oldSpeedY     = npc.speedY

    npc:harm(...)

    return (
           oldKilled     ~= npc:mem(0x122,FIELD_WORD)
        or oldProjectile ~= npc:mem(0x136,FIELD_BOOL)
        or oldHitCount   ~= npc:mem(0x148,FIELD_FLOAT)
        or oldImmune     ~= npc:mem(0x156,FIELD_WORD)
        or oldID         ~= npc.id
        or oldSpeedX     ~= npc.speedX
        or oldSpeedY     ~= npc.speedY
    )
end

local leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKI}
local shootingPowerups = table.map{PLAYER_FIREFLOWER,PLAYER_ICE,PLAYER_HAMMER}

local starmans = table.map{994,996}
local coins = table.map{10,33,88,103,138,258,411,528}
local oneups = table.map{90,186,187}
local threeups = table.map{188}
local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
local healitems = table.map{9,184,185,249,14,182,183,34,169,170,277,264}
local allenemies = table.map{1,2,3,4,5,6,7,8,12,15,17,18,19,20,23,24,25,27,28,29,36,37,38,39,42,43,44,47,48,51,52,53,54,55,59,61,63,65,71,72,73,74,76,77,89,93,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,135,137,161,162,163,164,165,166,167,168,172,173,174,175,176,177,180,189,199,200,201,203,204,205,206,207,209,210,229,230,231,232,233,234,235,236,242,243,244,245,247,261,262,267,268,270,271,272,275,280,281,284,285,286,294,295,296,298,299,301,302,303,304,305,307,309,311,312,313,314,315,316,317,318,321,323,324,333,345,346,347,350,351,352,357,360,365,368,369,371,372,373,374,375,377,379,380,382,383,386,388,389,392,393,395,401,406,407,408,409,413,415,431,437,446,447,448,449,459,460,461,463,464,466,467,469,470,471,472,485,486,487,490,491,492,493,509,510,512,513,514,515,516,517,418,519,520,521,522,523,524,529,530,539,562,563,564,572,578,579,580,586,587,588,589,590,610,611,612,613,614,616,618,619,624,666} --Every single X2 enemy.
local allsmallenemies = table.map{1,2,3,4,5,6,7,8,12,15,17,18,19,20,23,24,25,27,28,29,36,37,38,39,42,43,44,47,48,51,52,53,54,55,59,61,63,65,73,74,76,77,89,93,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,135,137,161,162,163,164,165,166,167,168,172,173,174,175,176,177,180,189,199,200,201,203,204,205,206,207,209,210,229,230,231,232,233,234,235,236,242,243,244,245,247,261,262,267,268,270,271,272,275,280,281,284,285,286,294,295,296,298,299,301,302,303,304,305,307,309,311,312,313,314,315,316,317,318,321,323,324,333,345,346,347,350,351,352,357,360,365,368,369,371,372,373,374,375,377,379,380,382,383,386,388,389,392,393,395,401,406,407,408,409,413,415,431,437,446,447,448,449,459,460,461,463,464,469,470,471,472,485,486,487,490,491,492,493,509,510,512,513,514,515,516,517,418,519,520,521,522,523,524,529,530,539,562,563,564,572,578,579,580,586,587,588,589,590,610,611,612,613,614,616,619,624,666} --Every single small X2 enemy.
local allbigenemies = table.map{71,72,466,467,618} --Every single big X2 enemy.

function isJumping()
	for k,p in ipairs(Player.get()) do
		if p.character == CHARACTER_MARIO or p.character == CHARACTER_LUIGI or p.character == CHARACTER_PEACH or p.character == CHARACTER_TOAD or p.character == CHARACTER_MEGAMAN or p.character == CHARACTER_WARIO or p.character == CHARACTER_BOWSER or p.character == CHARACTER_NINJABOMBERMAN or p.character == CHARACTER_YOSHI or p.character == CHARACTER_ROSALINA or p.character == CHARACTER_ZELDA or p.character == CHARACTER_UNTIMATERINKA or p.character == CHARACTER_UNCLEBROADSWORD or p.character == CHARACTER_SAMUS or p.character == CHARACTER_STEVE then
			return not p:isGroundTouching() and not p:isClimbing() and (p:mem(0x114, FIELD_WORD) == 4 or p:mem(0x114, FIELD_WORD) == 5 or p:mem(0x114, FIELD_WORD) == 9  or p:mem(0x114, FIELD_WORD) == 10) and p:mem(0x34, FIELD_WORD) ~= 2;
		elseif p.character == CHARACTER_LINK or p.character == CHARACTER_SNAKE then
			return not p:isGroundTouching() and not p:isClimbing() and (p:mem(0x114, FIELD_WORD) == 5 or p:mem(0x114, FIELD_WORD) == 10) and p:mem(0x34, FIELD_WORD) ~= 2;
		elseif p.character == CHARACTER_KLONOA then
			return not player:isGroundTouching() and not p:isClimbing() and (player:mem(0x114, FIELD_WORD) == 4 or player:mem(0x114, FIELD_WORD) == 5 or player:mem(0x114, FIELD_WORD) == 9  or player:mem(0x114, FIELD_WORD) == 10) and player:mem(0x34, FIELD_WORD) ~= 2;
		end
	end
end

function extrasounds.onDraw()
	--Text.print(player.speedY, 100, 100)
end

function extrasounds.onTick() --This is a list of sounds that'll need to be replaced within each costume. They're muted here for obivious reasons.
	if extrasounds.active == true then --Only mute when active
		--Audio.sounds[1].muted = true --player-jump.ogg
		Audio.sounds[4].muted = true --block-smash.ogg
		Audio.sounds[7].muted = true --mushroom.ogg
		Audio.sounds[8].muted = true --player-dead.ogg
		Audio.sounds[14].muted = true --coin.ogg
		Audio.sounds[15].muted = true --1up.ogg
		Audio.sounds[18].muted = true --fireball.ogg
		Audio.sounds[36].muted = true --smash.ogg
		Audio.sounds[39].muted = true --birdo-hit.ogg
		Audio.sounds[42].muted = true --npc-fireball.ogg
		Audio.sounds[43].muted = true --fireworks.ogg
		Audio.sounds[59].muted = true --dragon-coin.ogg
		
		
		
		
		--**SPINJUMPING**
		for k,p in ipairs(Player.get()) do
			if p:mem(0x50, FIELD_BOOL) == true then --Is the player spinjumping?
				if p:mem(0x160, FIELD_WORD) == 29 then --Is the fireball cooldown set to the highest number?
					if p.powerup == 3 then --Fireball sound
						if extrasounds.enableFireFlowerSFX then
							playSound(18)
						end
					end
					if p.powerup == 7 then --Iceball sound
						if extrasounds.enableIceFlowerSFX then
							if not extrasounds.useFireSoundForIce then
								playSound(93)
							elseif extrasounds.useFireSoundForIce then
								playSound(18)
							end
						end
					end
				end
			end
		end
		
		
		
		
		--**PSWITCH TIMER**
		if mem(0x00B2C62C, FIELD_WORD) >= 150 and mem(0x00B2C62C, FIELD_WORD) < 750 then
			if Level.endState() <= 0 then
				if not GameData.winStateActive then
					SFX.play(extrasounds.id[118], 1, 1, extrasounds.pSwitchTimerDelay)
				end
			end
		elseif mem(0x00B2C62C, FIELD_WORD) <= 300 and mem(0x00B2C62C, FIELD_WORD) >= 1 then
			if Level.endState() <= 0 then
				if not GameData.winStateActive then
					SFX.play(extrasounds.id[118], 1, 1, extrasounds.pSwitchTimerDelayFast)
				end
			end
		end
		
		
		
		--**P-WING**
		for k,p in ipairs(Player.get()) do
			if p:mem(0x66, FIELD_BOOL) == false and p.deathTimer <= 0 and p.forcedState == FORCEDSTATE_NONE and Level.endState() <= 0 then
				if p:mem(0x16C, FIELD_BOOL) == true then
					SFX.play(extrasounds.id[121], 1, 1, extrasounds.pWingDelay)
				end
				if p:mem(0x170, FIELD_WORD) >= 1 then
					SFX.play(extrasounds.id[121], 1, 1, extrasounds.pWingDelay)
				end
			end
		end
		
		
		
		
		--**NPCS**
		
		
		--*BOSSES*
		--
		--*SMB3 Bowser*
		for k,v in ipairs(NPC.get(86)) do --Make sure the seperate Bowser fire sound plays when SMB3 Bowser actually fires up a fireball
			if v.ai4 == 4 then
				if v.ai3 == 25 then
					playSound(115)
				end
			end
		end
		--*SMB1 Bowser*
		for k,v in ipairs(NPC.get(200)) do --Make sure the seperate Bowser fire sound plays when SMB1 Bowser actually fires up a fireball
			if v.ai3 == 40 then
				playSound(115)
			end
		end
		--*SMW Ludwig Koopa*
		for k,v in ipairs(NPC.get(280)) do --Make sure the actual fire sound plays when Ludwig Koopa actually fires up a fireball
			if v.ai1 == 2 then
				SFX.play(extrasounds.id[42], 1, 1, 35)
			end
		end
		--*SMB3 Boom Boom*
		for k,v in ipairs(NPC.get(15)) do --Adding a hurt sound for Boom Boom cause why not lol
			if v.ai1 == 4 then
				SFX.play(extrasounds.id[39], 1, 1, 100)
			end
		end
		
		
		
		
		
		--**PROJECTILES**
		--*Toad's Boomerang*
		for k,v in ipairs(NPC.get(292)) do --Boomerang sounds! (Toad's Boomerang)
			if extrasounds.enableToadBoomerangSFX then
				SFX.play(extrasounds.id[116], 1, 1, 12)
			end
		end
		--*Boomerang Bro. Projectile*
		for k,v in ipairs(NPC.get(615)) do --Boomerang sounds! (Boomerang Bros.)
			if extrasounds.enableBoomerangBroBoomerangSFX then
				local boomerangbrox = v.x - camera.x
				local boomerangbroy = v.y + camera.y
				if boomerangbrox <= -800 or boomerangbrox <= 800 then
					if boomerangbroy <= -600 or boomerangbroy <= 600 then
						--Text.print(boomerangbrox, 100, 100)
						SFX.play(extrasounds.id[116], 1, 1, 12)
					end
				end
			end
		end
		
		
		
		--**1UPS**
		if not isOverworld then
			for index,scoreboard in ipairs(Animation.get(79)) do --Score values!
				if scoreboard.animationFrame == 9 and scoreboard.speedY == -1.94 then --1UP
					playSound(15)
				end
				if scoreboard.animationFrame == 10 and scoreboard.speedY == -1.94 then --2UP
					if not extrasounds.use1UPSoundForAll1UPs then
						playSound(96)
					elseif extrasounds.use1UPSoundForAll1UPs then
						playSound(15)
					end
				end
				if scoreboard.animationFrame == 11 and scoreboard.speedY == -1.94 then --3UP
					if not extrasounds.use1UPSoundForAll1UPs then
						playSound(97)
					elseif extrasounds.use1UPSoundForAll1UPs then
						playSound(15)
					end
				end
				if scoreboard.animationFrame == 12 and scoreboard.speedY == -1.94 then --5UP
					if not extrasounds.use1UPSoundForAll1UPs then
						playSound(98)
					elseif extrasounds.use1UPSoundForAll1UPs then
						playSound(15)
					end
				end
			end
			
			
			
			
		--**EXPLOSIONS**
			for index,explosion in ipairs(Animation.get(69)) do --Explosions!
				if extrasounds.enableSMB2ExplosionSFX then
					if not extrasounds.useFireworksInsteadOfOtherExplosions then
						SFX.play(extrasounds.id[104], 1, 1, 70)
					elseif extrasounds.useFireworksInsteadOfOtherExplosions then
						SFX.play(extrasounds.id[43], 1, 1, 70)
					end
				end
			end
			for index,explosion in ipairs(Animation.get(71)) do
				SFX.play(extrasounds.id[43], 1, 1, 70)
			end
		end
		
		
		
		
		
		
		
		--**NPCTOCOIN**
		if mem(0x00A3C87F, FIELD_BYTE) == 14 and Level.endState() == 2 or Level.endState() == 4 then --This plays a coin sound when NpcToCoin happens
			if extrasounds.enableNPCtoCoin then
				SFX.play(extrasounds.id[14], 1, 1, 2500)
			end
		end
		
		
		
		
		
		
	end
	if extrasounds.active == false then --Unmute when not active
		--Audio.sounds[1].muted = false --player-jump.ogg
		Audio.sounds[4].muted = false --block-smash.ogg
		Audio.sounds[7].muted = false --mushroom.ogg
		Audio.sounds[8].muted = false --player-dead.ogg
		Audio.sounds[14].muted = false --coin.ogg
		Audio.sounds[15].muted = false --1up.ogg
		Audio.sounds[18].muted = false --fireball.ogg
		Audio.sounds[36].muted = false --smash.ogg
		Audio.sounds[39].muted = false --birdo-hit.ogg
		Audio.sounds[42].muted = false --npc-fireball.ogg
		Audio.sounds[43].muted = false --fireworks.ogg
		Audio.sounds[59].muted = false --dragon-coin.ogg
	end
end

local blockSmashTable = {
	[4] = 4,
	[60] = 4,
	[90] = 4,
	[186] = 43,
	[188] = 4,
	[226] = 4,
	[293] = 4,
	[668] = 4,
}

function bricksmashsound(block, fromUpper, playerornil) --This will smash bricks, as said from the source code.
	Routine.waitFrames(2, true)
	if block.isHidden and block.layerName == "Destroyed Blocks" then
		if extrasounds.enableBrickSmashing then
			playSound(blockSmashTable[block.id])
		end
	end
end

function brickkillsound(block, hitter) --Alternative way to play the sound. Used with the SMW block, the Brinstar Block, and the Unstable Turn Block.
	Routine.waitFrames(2, true)
	if block.isHidden and block.layerName == "Destroyed Blocks" then
		if extrasounds.enableBrickSmashing then
			playSound(blockSmashTable[block.id])
		end
	end
end

function extrasoundsblock90.onCollideBlock(block, hitter) --SMW BLock
	if type(hitter) == "Player" then
		if (hitter.y+hitter.height) <= (block.y+4) then
			if (hitter:mem(0x50, FIELD_BOOL)) then --Is the player spinjumping?
				Routine.run(brickkillsound,block,hitter)
			end
		end
	end
end

function extrasoundsblock668.onCollideBlock(block, hitter) --Unstable Turn Block
	if type(hitter) == "Player" then
		Routine.run(brickkillsound,block,hitter)
	end
end

function extrasounds.onPostBlockHit(block, fromUpper, playerornil) --Let's start off with block hitting.
	local bricks = table.map{4,60,90,188,226,293,526} --These are a list of breakable bricks
	local bricksnormal = table.map{4,60,90,188,226,293} --These are a list of breakable bricks, without the Super Metroid breakable.
	if extrasounds.active == true then --If it's true, play them
		if not Misc.isPaused() then --Making sure the sound only plays when not paused...
			for _,p in ipairs(Player.get()) do --This will get actions regarding all players
			
				
				
				
				
				--**CONTENT ID DETECTION**
				if block.contentID == nil then --For blocks that are already used
					
				end
				if block.contentID == 1225 then --Add 1000 to get an actual content ID number. The first three are vine blocks.
					if not extrasounds.useOriginalBlockSproutInstead then
						playSound(92)
					elseif extrasounds.useOriginalBlockSproutInstead then
						playSound(7)
					end
				elseif block.contentID == 1226 then
					if not extrasounds.useOriginalBlockSproutInstead then
						playSound(92)
					elseif extrasounds.useOriginalBlockSproutInstead then
						playSound(7)
					end
				elseif block.contentID == 1227 then
					if not extrasounds.useOriginalBlockSproutInstead then
						playSound(92)
					elseif extrasounds.useOriginalBlockSproutInstead then
						playSound(7)
					end
				elseif block.contentID == 1997 then
					if not extrasounds.useOriginalBlockSproutInstead then
						playSound(149)
					elseif extrasounds.useOriginalBlockSproutInstead then
						playSound(7)
					end
				elseif block.contentID == 0 then --This is to prevent a coin sound from playing when hitting an nonexistant block
					
				elseif block.contentID == 1000 then --Same as last
					
				elseif block.contentID >= 1001 then --Greater than blocks, exceptional to vine blocks, will play a mushroom spawn sound
					playSound(7)
				elseif block.contentID <= 99 then --Elseif, we'll play a coin sound with things less than 99, the coin block limit
					if extrasounds.enableBlockCoinCollecting then
						playSound(14)
					end
				end
				
				
				
				
				--**BOWSER BRICKS**
				if block.id == 186 then --SMB3 Bowser Brick detection, thanks to looking at the source code
					playSound(43)
				end
				
				
				
				
				--**BRICK SMASHING**
				if bricksnormal[block.id] or block.id == 186 then
					Routine.run(bricksmashsound, block, fromUpper, playerornil)
				end
				
				
				
			end
		end
	end
end

function extrasounds.onPostPlayerKill()
	if extrasounds.active == true then
		for _,p in ipairs(Player.get()) do --This will get actions regards to the player itself
	
	
	
	
			--**PLAYER DYING**
			if p.character == CHARACTER_LINK then
				SFX.play(80)
			else
				playSound(8)
			end
		
		
		
		end
	end
end

function extrasounds.onInputUpdate() --Button pressing for such commands
	if not Misc.isPaused() then
		if extrasounds.active == true then
			
			
			
			
			
			
			--**FIREBALLS**
			for k,p in ipairs(Player.get()) do
				local isShootingFire = (p:mem(0x118,FIELD_FLOAT) >= 100 and p:mem(0x118,FIELD_FLOAT) <= 118 and p.powerup == 3)
				local isShootingHammer = (p:mem(0x118,FIELD_FLOAT) >= 100 and p:mem(0x118,FIELD_FLOAT) <= 118 and p.powerup == 6)
				local isShootingIce = (p:mem(0x118,FIELD_FLOAT) >= 100 and p:mem(0x118,FIELD_FLOAT) <= 118 and p.powerup == 7)
				if isShootingFire then --Fireball sound
					if extrasounds.enableFireFlowerSFX then
						SFX.play(extrasounds.id[18], 1, 1, 25)
					end
				end
				if isShootingHammer then --Hammer Throw sound
					if extrasounds.enableHammerSuitSFX then
						if not extrasounds.useFireSoundForHammerSuit then
							SFX.play(extrasounds.id[105], 1, 1, 25)
						elseif extrasounds.useFireSoundForHammerSuit then
							SFX.play(extrasounds.id[18], 1, 1, 25)
						end
					end
				end
				if isShootingIce then --Iceball sound
					if extrasounds.enableIceFlowerSFX then
						if not extrasounds.useFireSoundForIce then
							SFX.play(extrasounds.id[93], 1, 1, 25)
						elseif extrasounds.useFireSoundForIce then
							SFX.play(extrasounds.id[18], 1, 1, 25)
						end
					end
				end
			end
			
			
			
			--*YOSHI FIRE SPITTING*
			for k,p in ipairs(Player.get()) do
				if p:mem(0x68, FIELD_BOOL) == true then --If it's detected that Yoshi has the fire ability...
					if p.keys.run == KEYS_PRESSED or p.keys.altRun == KEYS_PRESSED then --Then if it's spit out...
						playSound(42) --Play the sound
					end
				end
			end
			
			
			
			--**JUMPING**
			--for k,p in ipairs(Player.get()) do
				--if p.keys.jump == KEYS_DOWN then
					--jumptimer = jumptimer + 1
					--if jumptimer == 1 and isJumping() then
						--playSound(1)
					--elseif p:mem(0x174, FIELD_BOOL) then
						--playSound(1)
					--end
				--end
				--if p:isGroundTouching() then
					--jumptimer = 0
				--end
			--end
			
			
			
			
		end
	end
end

function extrasounds.onPostNPCHarm(npc, harmtype, player)
	if not Misc.isPaused() then
		if extrasounds.active == true then
			for _,p in ipairs(Player.get()) do --This will get actions regards to the player itself
				
				
				
				--*BOSSES*
				--
				--*SMB1 Bowser*
				if harmtype ~= HARM_TYPE_VANISH then
					if npc.id == 200 then --Play the hurt sound when hurting SMB1 Bowser
						playSound(39)
					end
					--*SMB3 Bowser*
					if npc.id == 86 then --Play the hurt sound when hurting SMB3 Bowser
						playSound(39)
					end
					--*SMB3 Boom Boom*
					if npc.id == 15 then --Play the hurt sound when hurting SMB3 Boom Boom
						playSound(39)
					end
					--*SMB3 Larry Koopa*
					if npc.id == 267 or npc.id == 268 then --Play the hurt sound when hurting SMB3 Larry Koopa
						playSound(39)
					end
					--*SMB2 Birdo*
					if npc.id == 39 then --Play the hurt sound when hurting SMB2 Birdo
						playSound(39)
					end
					--*SMB2 Mouser*
					if npc.id == 262 then --Play the hurt sound when hurting SMB2 Mouser
						playSound(39)
					end
					--*SMB2 Wart*
					if npc.id == 201 then --Play the hurt sound when hurting SMB2 Wart
						playSound(39)
					end
				end
				
				
				
				
			end
		end
	end
end

function extrasounds.onPostNPCKill(npc, harmtype) --NPC Kill stuff, for custom coin sounds and etc.
	if not Misc.isPaused() then
		if extrasounds.active == true then
			for _,p in ipairs(Player.get()) do --This will get actions regards to the player itself
				
				
				
				
				--**HP COLLECTING**
				if healitems[npc.id] and Colliders.collide(p, npc) then
					if p.character == CHARACTER_PEACH or p.character == CHARACTER_TOAD or p.character == CHARACTER_LINK or p.character == CHARACTER_KLONOA or p.character == CHARACTER_ROSALINA or p.character == CHARACTER_ULTIMATERINKA or p.character == CHARACTER_STEVE then
						if p:mem(0x16, FIELD_WORD) <= 2 then
							if extrasounds.enableHPCollecting then
								playSound(131)
							end
						elseif p:mem(0x16, FIELD_WORD) == 3 then
							if extrasounds.enableHPCollecting then
								playSound(132)
							end
						end
					end
				end
				
				
				
				--**PLAYER SMASHING**
				if allsmallenemies[npc.id] and harmtype == HARM_TYPE_SPINJUMP then
					playSound(36)
				end
				if npc.id >= 751 and harmtype == HARM_TYPE_SPINJUMP then
					playSound(36)
				end
				if allbigenemies[npc.id] and harmtype == HARM_TYPE_SPINJUMP then
					if not extrasounds.useOriginalSpinJumpForBigEnemies then
						playSound(125)
					elseif extrasounds.useOriginalSpinJumpForBigEnemies then
						playSound(36)
					end
				end
				
				
				
				
				--**COIN COLLECTING**
				if coins[npc.id] and Colliders.collide(p, npc) then --Any coin ID that was marked above will play this sound when collected
					if extrasounds.enableCoinCollecting then
						playSound(14)
					end
				end
				
				
				
				
				--**CHERRY COLLECTING**
				if npc.id == 558 and Colliders.collide(p, npc) then --Cherry sound effect
					if extrasounds.enableCherryCollecting then
						playSound(103)
					end
				end
				
				
				
				
				--**ICE BLOCKS**
				if npc.id == 45 then
					if extrasounds.enableBrickSmashing then
						playSound(4)
					end
				end
				
				
				
				--**SMW POWER STARS**
				if npc.id == 196 then
					if extrasounds.enableStarCollecting then
						playSound(59)
					end
				end
				
				
				
				
				--**DRAGON COINS**
				if npc.id == 274 and Colliders.collide(p, npc) then --Dragon coin counter sounds
					if not extrasounds.useOriginalDragonCoinSounds then
						if NPC.config[npc.id].score == 7 then
							playSound(59)
						elseif NPC.config[npc.id].score == 8 then
							playSound(99)
						elseif NPC.config[npc.id].score == 9 then
							playSound(100)
						elseif NPC.config[npc.id].score == 10 then
							playSound(101)
						elseif NPC.config[npc.id].score == 11 then
							playSound(102)
						end
					elseif extrasounds.useOriginalDragonCoinSounds then
						if NPC.config[npc.id].score == 7 then
							playSound(59)
						elseif NPC.config[npc.id].score == 8 then
							playSound(59)
						elseif NPC.config[npc.id].score == 9 then
							playSound(59)
						elseif NPC.config[npc.id].score == 10 then
							playSound(59)
						elseif NPC.config[npc.id].score == 11 then
							playSound(59)
						end
					end
				end
				
				
				
				--**SMB2 ENEMY KILLS**
				for k,v in ipairs(NPC.get({19,20,25,130,131,132,470,471,129,345,346,347,371,372,373,272,350,530,374,247,206})) do --SMB2 Enemies
					if (v.killFlag ~= 0) and not (v.killFlag == HARM_TYPE_VANISH) then
						if extrasounds.enableSMB2EnemyKillSounds then
							playSound(126)
						end
					end
				end
				
				
				
				
			end
		end
	end
end

return extrasounds --This ends the library