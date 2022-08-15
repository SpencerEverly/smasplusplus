local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

local jumphighertimer = 0
local jumphigherframeactive = false

function isPlayerDucking(p) --Returns if the player is ducking.
    return (
        p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and p.mount == MOUNT_NONE
        and not p.climbing
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p:mem(0x3C,FIELD_BOOL) -- sliding
        and not p:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not p:mem(0x4A,FIELD_BOOL) -- statue
        and not p:mem(0x50,FIELD_BOOL) -- spin jumping
        and p:mem(0x26,FIELD_WORD) == 0 -- picking up something from the top
        and (p:mem(0x34,FIELD_WORD) == 0 or isOnGround(p)) -- underwater or on ground

        and (
            p:mem(0x48,FIELD_WORD) == 0 -- not on a slope (ducking on a slope is weird due to sliding)
            or (p.holdingNPC ~= nil) -- holding an NPC
            or p:mem(0x34,FIELD_WORD) > 0 -- underwater
        )
    )
end

function isJumping(p)
    return (p:mem(0x11E, FIELD_BOOL) and p.keys.jump == KEYS_PRESSED)
end

function costume.onInit(p)
    registerEvent(costume,"onTick")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/block-hit.ogg")
    extrasounds.sound.sfx[4]  = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/block-smash.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/mushroom.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/player-died.ogg")
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/shell-hit.ogg")
    extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/player-slide.ogg")
    Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/item-dropped.ogg")
    Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/has-item.ogg")
    Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/camera-change.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/coin.ogg")
    extrasounds.sound.sfx[15] = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/1up.ogg")
    Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/fireball.ogg")
    Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/level-win.ogg")
    Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/boss-beat.ogg")
    Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/dungeon-win.ogg")
    Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/bullet-bill.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/grab.ogg")
    Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/spring.ogg")
    Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/hammer.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/do.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/key.ogg")
    Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/pswitch.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/racoon.ogg")
    Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/boot.ogg")
    extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/04-SMB2-Retro/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/thwomp.ogg")
    Audio.sounds[38].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/birdo-spit.ogg")
    extrasounds.sound.sfx[39] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/04-SMB2-Retro/birdo-hit.ogg"))
    Audio.sounds[41].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/birdo-beat.ogg")
    extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/04-SMB2-Retro/npc-fireball.ogg"))
    extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/fireworks.ogg")
    Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/bowser-killed.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/door.ogg")
    Audio.sounds[47].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/message.ogg")
    Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/yoshi.ogg")
    Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/yoshi-hurt.ogg")
    Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/yoshi-tongue.ogg")
    Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/yoshi-egg.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/player-died2.ogg")
    Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/yoshi-swallow.ogg")
    Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/dry-bones.ogg")
    Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/smw-checkpoint.ogg")
    extrasounds.sound.sfx[59] = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/dragon-coin.ogg")
    Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/smw-blaarg.ogg")
    Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/wart-bubble.ogg")
    Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/wart-die.ogg")
    Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/climbing.ogg")
    Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/swim.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/grab2.ogg")
    --Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/saw.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/smb2-throw.ogg")
    Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/smb2-hit.ogg")
    Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/04-SMB2-Retro/bubble.ogg")
end

function costume.onTick()
    for _,p in ipairs(Player.get()) do
        if p.keys.down == KEYS_DOWN then
            if isPlayerDucking(p) then
                if p.powerup == 1 then
                    p:setFrame(8 * player.direction)
                end
                jumphighertimer = jumphighertimer + 1
                if jumphighertimer == 120 then
                    if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                        Sound.playSFX(117)
                    end
                end
                if isJumping(p) and jumphighertimer >= 120 then
                    if p.powerup == 1 then
                        p:setFrame(3 * player.direction)
                    else
                        p:setFrame(4 * player.direction)
                    end
                    p.speedY = -16
                    jumphigherframeactive = true
                    jumphighertimer = 0
                end
            end
        end
        if not isPlayerDucking(p) then
            jumphighertimer = 0
        end
        if jumphigherframeactive then
            p.keys.down = false
            if p.speedY < 0 or not p.climbing then
                if p.powerup == 1 then
                    p:setFrame(3 * player.direction)
                else
                    p:setFrame(4 * player.direction)
                end
            end
            if p.speedY > 0 or p.climbing then
                jumphigherframeactive = false
            end
        end
    end
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
end

return costume