local pm = require("playerManager")
local extrasounds = require("extrasounds")
local textplus = require("textplus")
local hudoverride = require("hudoverridee")

local costume = {}

local smbddxfont = textplus.loadFont("littleDialogue/font/verdana.ini")
local coinCounter = Graphics.loadImageResolved("costumes/mario/SMBDDX-Mario/coincounter.png")
local starCounter = Graphics.loadImageResolved("costumes/mario/SMBDDX-Mario/starcounter.png")
local marioHead = Graphics.loadImageResolved("costumes/mario/SMBDDX-Mario/mariohead.png")

local plr

function costume.onInit(p)
	plr = p
	registerEvent(costume,"onTick")
	registerEvent(costume,"onDraw")
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/block-hit.ogg")
	extrasounds.id[4]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/block-smash.ogg"))
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/player-grow.ogg")
	extrasounds.id[7]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/mushroom.ogg"))
	extrasounds.id[8]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/player-died.ogg"))
	Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/shell-hit.ogg")
	--Audio.sounds[10].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/player-slide.ogg")
	--Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/item-dropped.ogg")
	--Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/has-item.ogg")
	--Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/camera-change.ogg")
	extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/coin.ogg"))
	extrasounds.id[15] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/1up.ogg"))
	Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/lava.ogg")
	Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/warp.ogg")
	extrasounds.id[18] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/fireball.ogg"))
	--Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/level-win.ogg")
	--Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/boss-beat.ogg")
	--Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/dungeon-win.ogg")
	Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/bullet-bill.ogg")
	--Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/grab.ogg")
	Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/spring.ogg")
	--Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/hammer.ogg")
	--Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/do.ogg")
	--Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/key.ogg")
	Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/pswitch.ogg")
	--Audio.sounds[33].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/tail.ogg")
	--Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/racoon.ogg")
	--Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/boot.ogg")
	--Audio.sounds[36].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/smash.ogg")
	Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/thwomp.ogg")
	--Audio.sounds[38].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/birdo-spit.ogg")
	--Audio.sounds[39].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/birdo-hit.ogg")
	--Audio.sounds[41].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/birdo-beat.ogg")
	--Audio.sounds[42].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/npc-fireball.ogg")
	extrasounds.id[43] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/fireworks.ogg"))
	--Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/bowser-killed.ogg")
	--Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/door.ogg")
	--Audio.sounds[47].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/message.ogg")
	--Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/yoshi.ogg")
	--Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/yoshi-hurt.ogg")
	--Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/yoshi-tongue.ogg")
	--Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/yoshi-egg.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/got-star.ogg")
	--Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/player-died2.ogg")
	--Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/yoshi-swallow.ogg")
	--Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/dry-bones.ogg")
	--Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/smw-checkpoint.ogg")
	--extrasounds.id[59] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/dragon-coin.ogg"))
	--Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/smw-blaarg.ogg")
	--Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/wart-bubble.ogg")
	--Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/wart-die.ogg")
	--Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/climbing.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/swim.ogg")
	--Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/grab2.ogg")
	--Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/saw.ogg")
	--Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/smb2-throw.ogg")
	--Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/smb2-hit.ogg")
	--Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/bubble.ogg")
	
	Graphics.overrideHUD(costume.drawHUD)
	costume.abilitesenabled = true
end

function costume.drawHUD(camIdx,priority,isSplit)
	--Lives
	Graphics.drawImageWP(marioHead, 107, 30, -4.3)
	textplus.print{text = "x", font = minFont, priority = -4.3, x = 137, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
	textplus.print{text = tostring(SaveData.totalLives), font = minFont, priority = -4.3, x = 152, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
	
	--Coins
    Graphics.drawImageWP(coinCounter, 202, 22, -4.3)
	textplus.print{text = "x", font = minFont, priority = -4.3, x = 225, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    textplus.print{text = tostring(SaveData.totalCoinsClassic), font = minFont, priority = -4.3, x = 240, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}

    --Stars
	Graphics.drawImageWP(starCounter, 305, 26, -4.3)
	textplus.print{text = "x", font = minFont, priority = -4.3, x = 335, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    textplus.print{text = tostring(SaveData.totalStarCount), font = minFont, priority = -4.3, x = 350, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}

    --Score
    textplus.print{text = tostring(SaveData.totalScoreClassic), font = minFont, priority = -4.3, x = 432, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}

    --Time
    textplus.print{text = "Time "..tostring(Timer.getValue()), font = minFont, priority = -4.3, x = 590, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)} 
end

local leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKI}

local function isSlowFalling()
	return (leafPowerups[player.powerup] and player.speedY > 0 and (player.keys.jump or player.keys.altJump))
end

local function isOnGround()
	return (
		player.speedY == 0 -- "on a block"
		or player:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
		or player:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
	)
end

function costume.onTick()
	if SaveData.toggleCostumeAbilities == true then
		if plr.holdingNPC == nil then
			if isSlowFalling() and not isOnGround() then
				plr:playAnim({5,37,11,37}, 4, false, -25)
			end
		end
	end
end

function costume.onDraw()
	
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
	
	Graphics.overrideHUD(Graphics.drawVanillaHUD)
	costume.abilitesenabled = false
end

return costume