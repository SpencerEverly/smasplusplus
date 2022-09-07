local playerManager = require("playerManager")
local extrasounds = require("extrasounds")
local smashud = require("smashud")

local costume = {}

local plr
local mariohp
local hit = false

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPostPlayerHarm")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onPlayerKill")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/10-HotelMario/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/10-HotelMario/stomped.ogg")
    --Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/10-HotelMario/block-hit.ogg")
    --extrasounds.sound.sfx[4]  = Audio.SfxOpen("costumes/mario/10-HotelMario/block-smash.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/10-HotelMario/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/10-HotelMario/player-grow.ogg")
    --extrasounds.sound.sfx[7]  = Audio.SfxOpen("costumes/mario/10-HotelMario/mushroom.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/mario/10-HotelMario/player-died.ogg")
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/10-HotelMario/shell-hit.ogg")
    --extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/mario/10-HotelMario/player-slide.ogg")
    --Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/item-dropped.ogg")
    --Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/has-item.ogg")
    --Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/camera-change.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen("costumes/mario/10-HotelMario/coin.ogg")
    --extrasounds.sound.sfx[15] = Audio.SfxOpen("costumes/mario/10-HotelMario/1up.ogg")
    --Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/lava.ogg")
    --Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen("costumes/mario/10-HotelMario/fireball.ogg")
    --Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/level-win.ogg")
    --Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/boss-beat.ogg")
    --Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/dungeon-win.ogg")
    --Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/bullet-bill.ogg")
    --Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/grab.ogg")
    Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/spring.ogg")
    --Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/hammer.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/do.ogg")
    --Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/key.ogg")
    --Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/pswitch.ogg")
    --extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/10-HotelMario/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/racoon.ogg")
    --Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/boot.ogg")
    --extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/10-HotelMario/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/thwomp.ogg")
    --Audio.sounds[38].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/birdo-spit.ogg")
    --extrasounds.sound.sfx[39] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/10-HotelMario/birdo-hit.ogg"))
    --Audio.sounds[41].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/birdo-beat.ogg")
    --extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/10-HotelMario/npc-fireball.ogg"))
    --extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/mario/10-HotelMario/fireworks.ogg")
    --Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/bowser-killed.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/door.ogg")
    --Audio.sounds[47].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/message.ogg")
    --Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/yoshi.ogg")
    --Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/yoshi-hurt.ogg")
    --Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/yoshi-tongue.ogg")
    --Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/yoshi-egg.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/player-died2.ogg")
    --Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/yoshi-swallow.ogg")
    --Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/dry-bones.ogg")
    --Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/smw-checkpoint.ogg")
    --extrasounds.sound.sfx[59] = Audio.SfxOpen("costumes/mario/10-HotelMario/dragon-coin.ogg")
    --Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/smw-blaarg.ogg")
    --Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/wart-bubble.ogg")
    --Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/wart-die.ogg")
    --Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/climbing.ogg")
    --Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/swim.ogg")
    --Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/grab2.ogg")
    --Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/saw.ogg")
    --Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/smb2-throw.ogg")
    --Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/smb2-hit.ogg")
    --Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/10-HotelMario/bubble.ogg")
    
    smashud.visible.itembox = false
    mariohp = 2
end

function costume.onPostNPCKill(npc, harmType)
    local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
    local healitems = table.map{9,184,185,249,14,182,183,34,169,170,277,264}
    if healitems[npc.id] and Colliders.collide(plr, npc) then
        mariohp = mariohp + 1
    end
end

function costume.onDraw()
    if SaveData.toggleCostumeAbilities == true then
        --Health system
        if plr.powerup <= 1 then
            plr.powerup = 2
        end
        if plr.powerup >= 5 then --Until we get all powerups implemented, this'll do for now
            plr.powerup = 4
        end
        if mariohp > 3 then
            mariohp = 3
        end
        if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL or player.forcedState == FORCEDSTATE_POWERDOWN_FIRE or player.forcedState == FORCEDSTATE_POWERDOWN_ICE then
            player.forcedState = FORCEDSTATE_NONE
            player:mem(0x140, FIELD_WORD, 150)
        end
        if smashud.visible.customitembox == true then
            local heartfull = Graphics.loadImageResolved("hardcoded/hardcoded-36-1.png")
            local heartempty = Graphics.loadImageResolved("hardcoded/hardcoded-36-2.png")
            if mariohp <= 0 then
                Graphics.drawImageWP(heartempty, 357,  16, -4.2)
                Graphics.drawImageWP(heartempty, 388,  16, -4.2)
                Graphics.drawImageWP(heartempty, 421,  16, -4.2)
            end
            if mariohp == 1 then
                Graphics.drawImageWP(heartfull, 357,  16, -4.2)
                Graphics.drawImageWP(heartempty, 388,  16, -4.2)
                Graphics.drawImageWP(heartempty, 421,  16, -4.2)
            end
            if mariohp == 2 then
                Graphics.drawImageWP(heartfull, 357,  16, -4.2)
                Graphics.drawImageWP(heartfull, 388,  16, -4.2)
                Graphics.drawImageWP(heartempty, 421,  16, -4.2)
            end
            if mariohp >= 3 then
                Graphics.drawImageWP(heartfull, 357,  16, -4.2)
                Graphics.drawImageWP(heartfull, 388,  16, -4.2)
                Graphics.drawImageWP(heartfull, 421,  16, -4.2)
            end
        end
    end
end

function costume.hphit()
    if SaveData.toggleCostumeAbilities == true then
        if not player.hasStarman and not player.isMega then
            hit = true
            if hit then
                mariohp = mariohp - 1
            end
            if mariohp < 1 then
                player:kill()
            end
        end
    end
end

function costume.onPlayerHarm()
    costume.hphit()
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
    
    smashud.visible.itembox = true
end

return costume