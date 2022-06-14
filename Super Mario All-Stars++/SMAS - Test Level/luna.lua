local warpTransition = require("warpTransition")
local textplus = require("textplus")
local littleDialogue = require("littleDialogue")
local pausemenu = require("pausemenu2")
--local megaluavania = require("megaluavania")
local debugbox = require("debugbox")
local extrasounds = require("extrasounds")
local smasdeathsystem = require("smashudsystem")
local comboSounds = require("comboSounds")

littleDialogue.defaultStyleName = "smbx13"

function onStart()
	if SMBX_VERSION == VER_SEE_MOD then
		
	end
	if SaveData.disableX2char == false then
		undertaledepends = require("level_dependencies_undertale")
		warpTransition = require("warpTransition")
		anotherPowerDownLibrary = require("anotherPowerDownLibrary")
		playerphysicspatch = require("playerphysicspatch")
		kindHurtBlock = require("kindHurtBlock")
		furyinventory = require("furyinventory")
		warpTransition.musicFadeOut = false
		warpTransition.levelStartTransition = warpTransition.TRANSITION_FADE
		warpTransition.sameSectionTransition = warpTransition.TRANSITION_PAN
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
		littleDialogue.defaultStyleName = "smbx13og"
		Audio.sounds[1].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-jump.ogg")
		Audio.sounds[2].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/stomped.ogg")
		Audio.sounds[3].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-hit.ogg")
		extrasounds.id[4]  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/block-smash.ogg"))
		Audio.sounds[5].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-shrink.ogg")
		Audio.sounds[6].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-grow.ogg")
		extrasounds.id[7]  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/mushroom.ogg"))
		extrasounds.id[8]  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died.ogg")
		Audio.sounds[9].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/shell-hit.ogg")
		Audio.sounds[10].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-slide.ogg")
		Audio.sounds[11].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/item-dropped.ogg")
		Audio.sounds[12].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/has-item.ogg")
		Audio.sounds[13].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/camera-change.ogg")
		extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/coin.ogg"))
		extrasounds.id[15] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/1up.ogg"))
		Audio.sounds[16].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/lava.ogg")
		Audio.sounds[17].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/warp.ogg")
		extrasounds.id[18] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireball.ogg"))
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
		extrasounds.id[43] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireworks.ogg"))
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
		extrasounds.id[59] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg"))
		Audio.sounds[61].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-blaarg.ogg")
		Audio.sounds[62].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-bubble.ogg")
		Audio.sounds[63].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-die.ogg")
		Audio.sounds[71].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/climbing.ogg")
		Audio.sounds[72].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/swim.ogg")
		Audio.sounds[73].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab2.ogg")
		--Audio.sounds[74].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/saw.ogg")
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
		extrasounds.id[92] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/sprout-vine.ogg")) --Vine sprout
		extrasounds.id[93] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/iceball.ogg")) --Iceball
		extrasounds.id[94] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/yi_freeze.ogg")) --Freeze enemies
		extrasounds.id[95] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/yi_icebreak.ogg")) --Enemy ice breaker
		extrasounds.id[96] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/2up.ogg")) --2UP
		extrasounds.id[97] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/3up.ogg")) --3UP
		extrasounds.id[98] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/5up.ogg")) --5UP
		extrasounds.id[99] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #2
		extrasounds.id[100] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #3
		extrasounds.id[101] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #4
		extrasounds.id[102] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #5
		extrasounds.id[103] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/cherry.ogg")) --Cherry
		extrasounds.id[104] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/explode.ogg")) --SMB2 Explosion
		extrasounds.id[105] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/hammerthrow.ogg")) --Player hammer throw
		extrasounds.id[106] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo1.ogg")) --Shell hit 2
		extrasounds.id[107] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo2.ogg")) --Shell hit 3
		extrasounds.id[108] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo3.ogg")) --Shell hit 4
		extrasounds.id[109] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo4.ogg")) --Shell hit 5
		extrasounds.id[110] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo5.ogg")) --Shell hit 6
		extrasounds.id[111] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo6.ogg")) --Shell hit 7
		extrasounds.id[112] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo7.ogg")) --Shell hit 8
	end
end

function onEvent(eventName)
	if eventName == "pauseenable" then
		pausemenu.pauseactivated = true
	end
	if eventName == "pausedisable" then
		pausemenu.pauseactivated = false
	end
end

function onTick()
	littleDialogue.defaultStyleName = "smbx13"
end

function onDraw()
	
end