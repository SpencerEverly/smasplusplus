local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

local plr

function costume.onInit(p)
	plr = p
	registerEvent(costume,"onTick")
	registerEvent(costume,"onDraw")
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX/block-hit.ogg")
	extrasounds.id[4]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX/block-smash.ogg"))
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX/player-grow.ogg")
	extrasounds.id[7]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX/mushroom.ogg"))
	extrasounds.id[8]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX/player-died.ogg"))
	Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX/shell-hit.ogg")
	--Audio.sounds[10].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/player-slide.ogg")
	--Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/item-dropped.ogg")
	--Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/has-item.ogg")
	--Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/camera-change.ogg")
	extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX/coin.ogg"))
	extrasounds.id[15] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX/1up.ogg"))
	Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/lava.ogg")
	Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/warp.ogg")
	extrasounds.id[18] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX/fireball.ogg"))
	--Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/level-win.ogg")
	--Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/boss-beat.ogg")
	--Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/dungeon-win.ogg")
	Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/bullet-bill.ogg")
	--Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/grab.ogg")
	Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/spring.ogg")
	--Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/hammer.ogg")
	--Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/do.ogg")
	--Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/key.ogg")
	Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/pswitch.ogg")
	--Audio.sounds[33].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/tail.ogg")
	--Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/racoon.ogg")
	--Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/boot.ogg")
	--Audio.sounds[36].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/smash.ogg")
	Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/thwomp.ogg")
	--Audio.sounds[38].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/birdo-spit.ogg")
	--Audio.sounds[39].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/birdo-hit.ogg")
	--Audio.sounds[41].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/birdo-beat.ogg")
	--Audio.sounds[42].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/npc-fireball.ogg")
	extrasounds.id[43] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX/fireworks.ogg"))
	--Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/bowser-killed.ogg")
	--Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/door.ogg")
	--Audio.sounds[47].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/message.ogg")
	--Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/yoshi.ogg")
	--Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/yoshi-hurt.ogg")
	--Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/yoshi-tongue.ogg")
	--Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/yoshi-egg.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/got-star.ogg")
	--Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/player-died2.ogg")
	--Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/yoshi-swallow.ogg")
	--Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/dry-bones.ogg")
	--Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/smw-checkpoint.ogg")
	--extrasounds.id[59] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX/dragon-coin.ogg"))
	--Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/smw-blaarg.ogg")
	--Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/wart-bubble.ogg")
	--Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/wart-die.ogg")
	--Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/climbing.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/swim.ogg")
	--Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/grab2.ogg")
	--Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/saw.ogg")
	--Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/smb2-throw.ogg")
	--Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/smb2-hit.ogg")
	--Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/SMBDDX/bubble.ogg")
	
	costume.abilitesenabled = true
end

local function isSlidingOnIce()
	return (player:mem(0x0A,FIELD_BOOL) and (not player.keys.left and not player.keys.right))
end

function costume.onTick()
	if costume.abilitesenabled == true and SaveData.toggleCostumeAbilities == true then
		local isJumping = player:mem(0x11C, FIELD_WORD) and not player:isOnGround() --Jumping detection
		local isUnderwater = plr:mem(0x36, FIELD_BOOL) --Underwater detection
		if plr.speedX ~= 0 and not isSlidingOnIce() and not isJumping and not isUnderwater then
			plr:playAnim({2,32,3}, 6, false, -25)
		end
	end
end

function costume.onCleanup(p)
	Audio.sounds[1].sfx  = nil	
	Audio.sounds[2].sfx  = nil
	Audio.sounds[3].sfx  = nil
	extrasounds.id[4]  = Audio.SfxOpen(Misc.resolveSoundFile("block-smash.ogg"))
	Audio.sounds[5].sfx  = nil
	Audio.sounds[6].sfx  = nil
	extrasounds.id[7]  = Audio.SfxOpen(Misc.resolveSoundFile("mushroom.ogg"))
	extrasounds.id[8] = Audio.SfxOpen(Misc.resolveSoundFile("player-died"))
	Audio.sounds[9].sfx  = nil
	Audio.sounds[10].sfx = nil
	Audio.sounds[11].sfx = nil
	Audio.sounds[12].sfx = nil
	Audio.sounds[13].sfx = nil
	extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("coin.ogg"))
	extrasounds.id[15] = Audio.SfxOpen(Misc.resolveSoundFile("1up.ogg"))
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	extrasounds.id[18] = Audio.SfxOpen(Misc.resolveSoundFile("fireball.ogg"))
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
	extrasounds.id[43] = Audio.SfxOpen(Misc.resolveSoundFile("fireworks.ogg"))
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
	extrasounds.id[59] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin.ogg"))
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
	extrasounds.id[92] = Audio.SfxOpen(Misc.resolveSoundFile("sound/sprout-vine.ogg"))
	extrasounds.id[93] = Audio.SfxOpen(Misc.resolveSoundFile("sound/iceball.ogg"))
	extrasounds.id[94] = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_freeze.ogg"))
	extrasounds.id[95] = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_icebreak.ogg"))
	extrasounds.id[96] = Audio.SfxOpen(Misc.resolveSoundFile("sound/2up.ogg"))
	extrasounds.id[97] = Audio.SfxOpen(Misc.resolveSoundFile("sound/3up.ogg"))
	extrasounds.id[98] = Audio.SfxOpen(Misc.resolveSoundFile("sound/5up.ogg"))
	extrasounds.id[99] = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get2.ogg"))
	extrasounds.id[100] = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get3.ogg"))
	extrasounds.id[101] = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get4.ogg"))
	extrasounds.id[102] = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get5.ogg"))
	extrasounds.id[103] = Audio.SfxOpen(Misc.resolveSoundFile("sound/cherry.ogg"))
	extrasounds.id[104] = Audio.SfxOpen(Misc.resolveSoundFile("sound/explode.ogg")) --SMB2 Explosion
	extrasounds.id[105] = Audio.SfxOpen(Misc.resolveSoundFile("sound/hammerthrow.ogg")) --Player hammer throw
	extrasounds.id[106] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo1.ogg")) --Shell hit 2
	extrasounds.id[107] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo2.ogg")) --Shell hit 3
	extrasounds.id[108] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo3.ogg")) --Shell hit 4
	extrasounds.id[109] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo4.ogg")) --Shell hit 5
	extrasounds.id[110] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo5.ogg")) --Shell hit 6
	extrasounds.id[111] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo6.ogg")) --Shell hit 7
	extrasounds.id[112] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo7.ogg")) --Shell hit 8
	
	costume.abilitesenabled = false
end

return costume