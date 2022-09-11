local pm = require("playerManager")
local extrasounds = require("extrasounds")
local sprite = require("base/sprite")

local costume = {}

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onPostBlockHit")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/link/01-Zelda1-NES/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/link/01-Zelda1-NES/block-hit.ogg")
    extrasounds.sound.sfx[4]  = Audio.SfxOpen("costumes/link/01-Zelda1-NES/block-smash.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/link/01-Zelda1-NES/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/link/01-Zelda1-NES/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen("costumes/link/01-Zelda1-NES/mushroom.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/link/01-Zelda1-NES/player-died.ogg")
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/link/01-Zelda1-NES/shell-hit.ogg")
    extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/player-slide.ogg")
    Audio.sounds[11].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/item-dropped.ogg")
    Audio.sounds[12].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/has-item.ogg")
    Audio.sounds[13].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/camera-change.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/coin.ogg")
    extrasounds.sound.sfx[15] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/1up.ogg")
    Audio.sounds[16].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/fireball.ogg")
    Audio.sounds[19].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/level-win.ogg")
    Audio.sounds[20].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/boss-beat.ogg")
    Audio.sounds[21].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/dungeon-win.ogg")
    Audio.sounds[22].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/bullet-bill.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/grab.ogg")
    Audio.sounds[24].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/spring.ogg")
    Audio.sounds[25].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/hammer.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/do.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/key.ogg")
    Audio.sounds[32].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/pswitch.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/racoon.ogg")
    Audio.sounds[35].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/boot.ogg")
    extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/link/01-Zelda1-NES/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/thwomp.ogg")
    extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/link/01-Zelda1-NES/npc-fireball.ogg"))
    extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/fireworks.ogg")
    Audio.sounds[44].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/bowser-killed.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/door.ogg")
    Audio.sounds[48].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/yoshi.ogg")
    Audio.sounds[49].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/yoshi-hurt.ogg")
    Audio.sounds[50].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/yoshi-tongue.ogg")
    Audio.sounds[51].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/yoshi-egg.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/player-died2.ogg")
    Audio.sounds[55].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/yoshi-swallow.ogg")
    Audio.sounds[57].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/dry-bones.ogg")
    Audio.sounds[58].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/smw-checkpoint.ogg")
    extrasounds.sound.sfx[59] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/dragon-coin.ogg")
    Audio.sounds[61].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/smw-blaarg.ogg")
    Audio.sounds[62].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/wart-bubble.ogg")
    Audio.sounds[63].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/wart-die.ogg")
    Audio.sounds[71].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/climbing.ogg")
    Audio.sounds[72].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/swim.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/grab2.ogg")
    --Audio.sounds[74].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/saw.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/smb2-throw.ogg")
    Audio.sounds[76].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/smb2-hit.ogg")
    extrasounds.sound.sfx[77] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-stab.ogg")
    Audio.sounds[78].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-hurt.ogg")
    Audio.sounds[79].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-heart.ogg")
    Audio.sounds[80].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-died.ogg")
    extrasounds.sound.sfx[81] = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-rupee.ogg")
    Audio.sounds[82].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-fire.ogg")
    Audio.sounds[83].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-item.ogg")
    Audio.sounds[84].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-key.ogg")
    Audio.sounds[85].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-shield.ogg")
    Audio.sounds[86].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-dash.ogg")
    Audio.sounds[87].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-fairy.ogg")
    Audio.sounds[88].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-grass.ogg")
    Audio.sounds[89].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-hit.ogg")
    Audio.sounds[90].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/zelda-sword-beam.ogg")
    Audio.sounds[91].sfx = Audio.SfxOpen("costumes/link/01-Zelda1-NES/bubble.ogg")
    
    Defines.player_walkspeed = 3.5
    Defines.player_runspeed = 3.5
    Defines.jumpheight = 17
    Defines.jumpheight_bounce = 27
    Defines.projectilespeedx = 7.0
    Defines.player_grav = 0.3
    
    costume.abilitesenabled = true
end

local swimtimer = 11
local rotationjump = 0

local function isSlidingOnIce()
    return (player:mem(0x0A,FIELD_BOOL) and (not player.keys.left and not player.keys.right))
end

-- Detects if the player is on the ground, the redigit way. Sometimes more reliable than just p:isOnGround().
local function isOnGround(p)
    return (
        player.speedY == 0 -- "on a block"
        or player:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or player:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end

function costume.onTick()
    if SaveData.toggleCostumeAbilities == true then
        local isJumping = player:mem(0x11C, FIELD_WORD) and not isOnGround(p) --Jumping detection
        local isUnderwater = plr:mem(0x36, FIELD_BOOL) --Underwater detection
        if isJumping and plr:mem(0x14, FIELD_WORD) <= 0 and not isUnderwater and not isOnGround(p) then --Checks to see if the player is jumping...
            plr:setFrame(12)
            --local rotationjump = rotationjump % 360
            --player:render{frame = 12, x = player.x - camera.x, y = player.y - camera.y, priority = -25}
        end
        if not isJumping then
            --rotationjump = 0
        end
        local swimframes = {13,14}
        if isUnderwater and player:mem(0x14, FIELD_WORD) <= 0 and not isOnGround(p) then --Swim frames!
            plr:playAnim(swimframes, 8, false, -25)
            Defines.player_walkspeed = 4.5 --This is to make sure the player goes faster underwater
            Defines.player_runspeed = 4.5
        end
        if not isUnderwater then
            --swimtimer = 11
            Defines.player_walkspeed = 3.5
            Defines.player_runspeed = 3.5
        end
        local walkframes = {1,2}
        if plr.speedX ~= 0 and not isSlidingOnIce() then
            local walkSpeed = math.max(0.35,math.abs(plr.speedX)/Defines.player_walkspeed) --Making sure the walk animation is slower
            plr:playAnim(walkframes, 8, false, -25)
        end
        if Level.endState() >= 1 and not Level.endState() == 3 then --If win state, he poses
            plr:setFrame(16)
        end
    end
end

function costume.onPostBlockHit(block, fromUpper)
    local bricks = table.map{4,60,90,186,188,226,293,668} --These are a list of breakable bricks.
    if bricks[block.id] and block.contentID == nil or block.contentID == 0 or block.contentID == 1000 then
        block:remove(true)
    end
end

function costume.onInputUpdate()
    if SaveData.toggleCostumeAbilities == true then
        if player.keys.run == KEYS_DOWN then
            plr:mem(0x168, FIELD_FLOAT, 10)
        else
            plr:mem(0x168, FIELD_FLOAT, 0)
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
    extrasounds.sound.sfx[77] = nil
    Audio.sounds[78].sfx = nil
    Audio.sounds[79].sfx = nil
    Audio.sounds[80].sfx = nil
    extrasounds.sound.sfx[81] = nil
    Audio.sounds[82].sfx = nil
    Audio.sounds[83].sfx = nil
    Audio.sounds[84].sfx = nil
    Audio.sounds[85].sfx = nil
    Audio.sounds[86].sfx = nil
    Audio.sounds[87].sfx = nil
    Audio.sounds[88].sfx = nil
    Audio.sounds[89].sfx = nil
    Audio.sounds[90].sfx = nil
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
    
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
end

return costume