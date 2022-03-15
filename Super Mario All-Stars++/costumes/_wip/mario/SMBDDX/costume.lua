local particles = require("particles")

local animatx = require("animatx2_xmas2020")
local actorsys = require("a2xt_actor")
local ep3Playables = require("extendedCostumes")
local extrasounds = require("extrasounds")

local players = {}
local playerCount = 0

-- Library table for the costume, config for default ep3Playables behavior goes here
local costume = {
	baseCharID = CHARACTER_MARIO,
	index = "SMBDDX",
	path = "costumes/mario/SMBDDX",

	namespace = ACTOR_SMBDDX,
	keepPowerupOnHit = true,
	paletteenabled = false,
	emittersenabled = false
}

costume.playerData = {}
costume.playersList = {}

local ppp
local lastCt
local pDat

function costume.onInit(playerObj, pDat)
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/mario/Demo-XmasPily/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/Demo-XmasPily/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/Demo-XmasPily/block-hit.ogg")
	extrasounds.playersoundid4  = Audio.SfxOpen("costumes/mario/Demo-XmasPily/block-smash.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/Demo-XmasPily/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/Demo-XmasPily/player-grow.ogg")
	extrasounds.playersoundid7  = Audio.SfxOpen("costumes/mario/Demo-XmasPily/mushroom.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/mario/Demo-XmasPily/player-died.ogg")
	Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/Demo-XmasPily/shell-hit.ogg")
	Audio.sounds[10].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/player-slide.ogg")
	Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/item-dropped.ogg")
	Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/has-item.ogg")
	Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/camera-change.ogg")
	extrasounds.playersoundid14 = Audio.SfxOpen("costumes/mario/Demo-XmasPily/coin.ogg")
	extrasounds.playersoundid15 = Audio.SfxOpen("costumes/mario/Demo-XmasPily/1up.ogg")
	Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/lava.ogg")
	Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/warp.ogg")
	extrasounds.playersoundid18 = Audio.SfxOpen("costumes/mario/Demo-XmasPily/fireball.ogg")
	Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/level-win.ogg")
	Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/boss-beat.ogg")
	Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/dungeon-win.ogg")
	Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/bullet-bill.ogg")
	Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/grab.ogg")
	Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/spring.ogg")
	Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/hammer.ogg")
	--Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/do.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/key.ogg")
	Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/pswitch.ogg")
	Audio.sounds[33].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/tail.ogg")
	--Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/racoon.ogg")
	--Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/boot.ogg")
	--Audio.sounds[36].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/smash.ogg")
	Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/thwomp.ogg")
	Audio.sounds[38].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/birdo-spit.ogg")
	Audio.sounds[39].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/birdo-hit.ogg")
	Audio.sounds[41].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/birdo-beat.ogg")
	--Audio.sounds[42].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/npc-fireball.ogg")
	--Audio.sounds[43].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/fireworks.ogg")
	Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/bowser-killed.ogg")
	Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/door.ogg")
	Audio.sounds[47].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/message.ogg")
	Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/yoshi.ogg")
	Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/yoshi-hurt.ogg")
	Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/yoshi-tongue.ogg")
	Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/yoshi-egg.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/player-died2.ogg")
	Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/yoshi-swallow.ogg")
	Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/dry-bones.ogg")
	Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/smw-checkpoint.ogg")
	extrasounds.playersoundid59 = Audio.SfxOpen("costumes/mario/Demo-XmasPily/dragon-coin.ogg")
	Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/smw-blaarg.ogg")
	--Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/wart-bubble.ogg")
	--Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/wart-die.ogg")
	Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/climbing.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/swim.ogg")
	Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/grab2.ogg")
	--Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/saw.ogg")
	Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/smb2-throw.ogg")
	Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/smb2-hit.ogg")
	Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/Demo-XmasPily/bubble.ogg")
	ppp = require("playerphysicspatch");

	local config = NPC.config[171]

	players[playerObj] = ep3Playables.register(playerObj, costume, inputEvent, animEvent, drawEndEvent);

	registerEvent(costume, "onPostNPCKill");
	registerEvent(costume, "onTick");
	playerCount = playerCount+1
end

function costume.onTick()
	for _,p in ipairs(costume.playersList) do
		local data = costume.playerData[playerObj]
	end	
end

function costume.onCleanup(playerObj, p)
	Audio.sounds[1].sfx  = nil	
	Audio.sounds[2].sfx  = nil
	Audio.sounds[3].sfx  = nil
	Audio.sounds[4].sfx  = nil
	Audio.sounds[5].sfx  = nil
	Audio.sounds[6].sfx  = nil
	Audio.sounds[7].sfx  = nil
	Audio.sounds[8].sfx  = nil
	Audio.sounds[9].sfx  = nil
	Audio.sounds[10].sfx = nil
	Audio.sounds[11].sfx = nil
	Audio.sounds[12].sfx = nil
	Audio.sounds[13].sfx = nil
	extrasounds.playersoundid14 = Audio.SfxOpen(Misc.resolveSoundFile("coin.ogg"))
	extrasounds.playersoundid15 = Audio.SfxOpen(Misc.resolveSoundFile("1up.ogg"))
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	extrasounds.playersoundid18 = Audio.SfxOpen(Misc.resolveSoundFile("fireball.ogg"))
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
	Audio.sounds[33].sfx = nil
	Audio.sounds[34].sfx = nil
	Audio.sounds[35].sfx = nil
	Audio.sounds[36].sfx = nil
	Audio.sounds[37].sfx = nil
	Audio.sounds[38].sfx = nil
	Audio.sounds[39].sfx = nil
	Audio.sounds[41].sfx = nil
	Audio.sounds[42].sfx = nil
	Audio.sounds[43].sfx = nil
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
	Audio.sounds[77].sfx = nil
	Audio.sounds[78].sfx = nil
	Audio.sounds[79].sfx = nil
	Audio.sounds[80].sfx = nil
	Audio.sounds[81].sfx = nil
	Audio.sounds[82].sfx = nil
	Audio.sounds[91].sfx = nil
	extrasounds.playersoundid92 = Audio.SfxOpen(Misc.resolveSoundFile("sound/sprout-vine.ogg"))
	extrasounds.playersoundid93 = Audio.SfxOpen(Misc.resolveSoundFile("sound/iceball.ogg"))
	extrasounds.playersoundid94 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_freeze.ogg"))
	extrasounds.playersoundid95 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_icebreak.ogg"))
	extrasounds.playersoundid96 = Audio.SfxOpen(Misc.resolveSoundFile("sound/2up.ogg"))
	extrasounds.playersoundid97 = Audio.SfxOpen(Misc.resolveSoundFile("sound/3up.ogg"))
	extrasounds.playersoundid98 = Audio.SfxOpen(Misc.resolveSoundFile("sound/5up.ogg"))
	extrasounds.playersoundid99 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get2.ogg"))
	extrasounds.playersoundid100 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get3.ogg"))
	extrasounds.playersoundid101 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get4.ogg"))
	extrasounds.playersoundid102 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get5.ogg"))
	extrasounds.playersoundid103 = Audio.SfxOpen(Misc.resolveSoundFile("sound/cherry.ogg"))
	ep3Playables.cleanup(playerObj, costume, costumeTable, extraInputFunct, extraAnimFunct, extraDrawFunct, 
	inputEvent, animEvent, drawEndEvent);
	playerCount = playerCount-1
	players[playerObj] = nil
	for _,p in ipairs(costume.playersList) do
		ep3Playables.cleanup(playerObj, characterInfo, costume)
	end
	local config = NPC.config[171]
	
	local spot = table.ifind(costume.playersList,playerObj)

	if spot ~= nil then
		table.remove(costume.playersList,spot)
	end

	if  playerCount == 0  then
		unregisterEvent(costume, "onPostNPCKill");
		--unregisterEvent(costume, "onInputUpdate");
	end
	
end

return costume