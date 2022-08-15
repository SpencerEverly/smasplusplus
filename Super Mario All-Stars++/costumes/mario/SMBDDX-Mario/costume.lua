local pm = require("playerManager")
local extrasounds = require("extrasounds")
local textplus = require("textplus")
local smashud = require("smashud")

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
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/block-hit.ogg")
    extrasounds.sound.sfx[4]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/block-smash.ogg"))
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/mushroom.ogg"))
    extrasounds.sound.sfx[8]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/player-died.ogg"))
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/shell-hit.ogg")
    --extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/player-slide.ogg")
    --Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/item-dropped.ogg")
    --Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/has-item.ogg")
    --Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/camera-change.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/coin.ogg"))
    extrasounds.sound.sfx[15] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/1up.ogg"))
    Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/fireball.ogg"))
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
    --extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/tail.ogg")
    --Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/racoon.ogg")
    --Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/boot.ogg")
    --extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/thwomp.ogg")
    --Audio.sounds[38].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/birdo-spit.ogg")
    --extrasounds.sound.sfx[39] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/birdo-hit.ogg")
    --Audio.sounds[41].sfx = Audio.SfxOpen("costumes/mario/SMBDDX-Mario/birdo-beat.ogg")
    --extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/npc-fireball.ogg"))
    extrasounds.sound.sfx[43] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/fireworks.ogg"))
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
    --extrasounds.sound.sfx[59] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SMBDDX-Mario/dragon-coin.ogg"))
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

local function canDuck()
    return (
        player.forcedState == FORCEDSTATE_NONE
        and player.deathTimer == 0 and not player:mem(0x13C,FIELD_BOOL) -- not dead
        and player.mount == MOUNT_NONE
        and not player.climbing
        and not player:mem(0x0C,FIELD_BOOL) -- fairy
        and not player:mem(0x3C,FIELD_BOOL) -- sliding
        and not player:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not player:mem(0x4A,FIELD_BOOL) -- statue
        and not player:mem(0x50,FIELD_BOOL) -- spin jumping
        and player:mem(0x26,FIELD_WORD) == 0 -- picking up something from the top
        and (player:mem(0x34,FIELD_WORD) == 0 or isOnGround()) -- underwater or on ground

        and (
            player:mem(0x48,FIELD_WORD) == 0 -- not on a slope (ducking on a slope is weird due to sliding)
            or (player.holdingNPC ~= nil and player.powerup == PLAYER_SMALL) -- small and holding an NPC
            or player:mem(0x34,FIELD_WORD) > 0 -- underwater
        )
    )
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
            if isSlowFalling() and not isOnGround() and not player:mem(0x12E, FIELD_BOOL) then
                plr:playAnim({5,37,11,37}, 4, false, -25)
            end
        end
    end
end

function costume.onDraw()
    
end

function costume.onCleanup(p)
    extrasounds.sound.sfx[1] = nil    
    Audio.sounds[2].sfx  = nil
    Audio.sounds[3].sfx  = nil
    extrasounds.sound.sfx[4] = nil
    Audio.sounds[5].sfx  = nil
    Audio.sounds[6].sfx  = nil
    extrasounds.sound.sfx[7] = nil
    extrasounds.sound.sfx[8] = nil
    Audio.sounds[9].sfx  = nil
    extrasounds.sound.sfx[10] = nil
    Audio.sounds[11].sfx = nil
    Audio.sounds[12].sfx = nil
    Audio.sounds[13].sfx = nil
    extrasounds.sound.sfx[14] = nil
    extrasounds.sound.sfx[15] = nil
    Audio.sounds[16].sfx = nil
    Audio.sounds[17].sfx = nil
    extrasounds.sound.sfx[18] = nil
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
    extrasounds.sound.sfx[33] = nil
    Audio.sounds[34].sfx = nil
    Audio.sounds[35].sfx = nil
    extrasounds.sound.sfx[36] = nil
    Audio.sounds[37].sfx = nil
    Audio.sounds[38].sfx = nil
    extrasounds.sound.sfx[39] = nil
    Audio.sounds[41].sfx = nil
    extrasounds.sound.sfx[42] = nil
    extrasounds.sound.sfx[43] = nil
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
    extrasounds.sound.sfx[59] = nil
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
    extrasounds.sound.sfx[92] = nil
    extrasounds.sound.sfx[93] = nil
    extrasounds.sound.sfx[94] = nil
    extrasounds.sound.sfx[95] = nil
    extrasounds.sound.sfx[96] = nil
    extrasounds.sound.sfx[97] = nil
    extrasounds.sound.sfx[98] = nil
    extrasounds.sound.sfx[99] = nil
    extrasounds.sound.sfx[100] = nil
    extrasounds.sound.sfx[101] = nil
    extrasounds.sound.sfx[102] = nil
    extrasounds.sound.sfx[103] = nil
    extrasounds.sound.sfx[104] = nil
    extrasounds.sound.sfx[105] = nil
    extrasounds.sound.sfx[106] = nil
    extrasounds.sound.sfx[107] = nil
    extrasounds.sound.sfx[108] = nil
    extrasounds.sound.sfx[109] = nil
    extrasounds.sound.sfx[110] = nil
    extrasounds.sound.sfx[111] = nil
    extrasounds.sound.sfx[112] = nil
    
    Graphics.overrideHUD(Graphics.drawVanillaHUD)
    costume.abilitesenabled = false
end

return costume