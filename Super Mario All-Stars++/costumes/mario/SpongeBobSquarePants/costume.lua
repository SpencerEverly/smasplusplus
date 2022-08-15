local pm = require("playerManager")
local extrasounds = require("extrasounds")
local rng = require("base/rng")

local costume = {}

local eventsRegistered = false
local plr
local jumpingactive = false
local cooldown = 0
local timer = 50
local timer2 = 5
local p = player
local hasJumped = false

local leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKI}

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onStart")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPlayerKill")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onTickEnd")
    registerEvent(costume,"onCleanup")
    registerEvent(costume,"onInputUpdate")
    local icantswim = require("icantswim")
    icantswim.splashSound = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/spongebob-splash.ogg")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/player-jump.ogg")
    --Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/stomped.ogg")
    --Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/block-hit.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/player-shrink.ogg")
    --Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/player-grow.ogg")
    --extrasounds.sound.sfx[7]  = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/mushroom.ogg")
    --extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/player-died.ogg")
    --Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/shell-hit.ogg")
    --extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/player-slide.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/coin.ogg"))
    extrasounds.sound.sfx[15] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/1up.ogg"))
    --Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/fireball.ogg"))
    --Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/grab.ogg")
    --Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/spring.ogg")
    --Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/do.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/keyhole.ogg")
    --Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/pswitch.ogg")
    --extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/tail.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/door.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/got-star.ogg")
    --Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/player-died2.ogg")
    --Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/smw-checkpoint.ogg")
    --extrasounds.sound.sfx[59] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/dragon-coin.ogg"))
    --Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/climbing.ogg")
    --Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/swim.ogg")
    --Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/grab2.ogg")
    --Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/smb2-throw.ogg")
    --Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/SpongeBobSquarePants/smb2-hit.ogg")
    extrasounds.sound.sfx93 = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/fireball.ogg"))
    
    flybeginsound = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/spongebob-flyingdown.ogg"))
    
    Graphics.sprites.hardcoded["33-2"].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/hardcoded-33-2.png")
    Graphics.sprites.hardcoded["33-5"].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/hardcoded-33-5.png")
    
    Graphics.sprites.npc[10].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-10.png")
    Graphics.sprites.npc[33].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-33.png")
    Graphics.sprites.npc[88].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-88.png")
    Graphics.sprites.npc[999].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-97.png")
    Graphics.sprites.npc[1000].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-97.png")
    Graphics.sprites.npc[103].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-103.png")
    Graphics.sprites.npc[258].img = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/npc-258.png")
    
    Defines.jumpheight = 14
    Defines.player_walkspeed = 2.7
    Defines.player_runspeed = 4.5
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
    
    costume.abilitesenabled = true
    costume.useFallingFrame = false
end

local function isOnGround(p)
    return (
        p.speedY == 0 -- "on a block"
        or p:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or p:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end

local atPSpeed = p:mem(0x16C,FIELD_BOOL) or p:mem(0x16E,FIELD_BOOL)

local function isSlowFalling(p)
    return (leafPowerups[p.powerup] and p.speedY > 0 and (p.keys.jump or p.keys.altJump))
end

local function canFall(p)
    return (
        p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and not isOnGround(p)
        and p.mount == MOUNT_NONE
        and not p.climbing
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p:mem(0x3C,FIELD_BOOL) -- sliding
        and not p:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not p:mem(0x4A,FIELD_BOOL) -- statue
        and p:mem(0x34,FIELD_WORD) == 0 -- underwater
    )
end

function costume.onStart()
    if SaveData.toggleCostumeAbilities == true then
        --Audio.playSFX("costumes/mario/SpongeBobSquarePants/start-level.ogg")
    end
end

function costume.onPostNPCKill(npc, harmType)
    if SaveData.toggleCostumeAbilities == true then
        local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
        local rngkey = rng.randomInt(1,12)
        if items[npc.id] and Colliders.collide(plr, npc) then
            SFX.play("costumes/SpongeBobSquarePants/spongebob-grow"..rngkey..".ogg", 1, 1, 80)
        end
    end
end

function costume.onTickEnd()
    if SaveData.toggleCostumeAbilities == true then
        if canFall(p) then
            costume.useFallingFrame = player.speedY > 0
        else
            costume.useFallingFrame = false
        end
    end
end

local function isSlidingOnIce(plr)
    return (plr:mem(0x0A,FIELD_BOOL) and (not plr.keys.left and not plr.keys.right))
end

function costume.onTick(repeated)
    if SaveData.toggleCostumeAbilities == true then
        if player.speedX ~= 0 and not isSlidingOnIce(plr) then
            --if player.frame == 3 or player.frame == 9 then
                --SFX.play("costumes/SpongeBobSquarePants/spongebob-footsteps.ogg", 0.4, 1, 40)
            --end
        end
        if leafPowerups[p.powerup] then
            if p.holdingNPC == nil then
                if isSlowFalling(p) then
                    plr:setFrame(27)
                    timer2 = timer2 - 1
                    if timer2 == 4 then
                        if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                            SFX.play(flybeginsound, 1, 1, 10)
                        end
                    elseif timer2 <= 3 then
                        if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                            if flybeginsound.playing then
                                flybeginsound:stop()
                            end
                        end
                    end
                end
            end
            if player:isGroundTouching() == true or player:isClimbing() == true then
                timer2 = 5
            end
        end
        if player:isOnGround() or player:isClimbing() then --Checks to see if the player is on the ground, is climbing, is not underwater (smasfunctions), the death timer is at least 0, the end state is none, or the mount is a clown car
            hasJumped = false
        elseif (not hasJumped) and player.keys.jump == KEYS_PRESSED and player.deathTimer == 0 and Level.endState() == 0 and player.mount == 0 and not isPlayerUnderwater(player) then
            hasJumped = true
            player:mem(0x11C, FIELD_WORD, 16)
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX("mario/SpongeBobSquarePants/player-jump-twice.ogg")
            end
        end
    end
end

function costume.onPlayerHarm()
    
end

function costume.onPlayerKill()
    local rngkey = rng.randomInt(1,7)
    Sound.playSFX("mario/SpongeBobSquarePants/spongebob-dead"..rngkey..".ogg")
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
    extrasounds.sound.sfx92 = Audio.SfxOpen(Misc.resolveSoundFile("sound/sprout-vine.ogg"))
    extrasounds.sound.sfx93 = Audio.SfxOpen(Misc.resolveSoundFile("sound/iceball.ogg"))
    extrasounds.sound.sfx94 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi-freeze.ogg"))
    extrasounds.sound.sfx95 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi-icebreak.ogg"))
    extrasounds.sound.sfx96 = Audio.SfxOpen(Misc.resolveSoundFile("sound/2up.ogg"))
    extrasounds.sound.sfx97 = Audio.SfxOpen(Misc.resolveSoundFile("sound/3up.ogg"))
    extrasounds.sound.sfx98 = Audio.SfxOpen(Misc.resolveSoundFile("sound/5up.ogg"))
    extrasounds.sound.sfx99 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get2.ogg"))
    extrasounds.sound.sfx100 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get3.ogg"))
    extrasounds.sound.sfx101 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get4.ogg"))
    extrasounds.sound.sfx102 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get5.ogg"))
    extrasounds.sound.sfx103 = Audio.SfxOpen(Misc.resolveSoundFile("sound/cherry.ogg"))
    extrasounds.sound.sfx104 = Audio.SfxOpen(Misc.resolveSoundFile("sound/explode.ogg")) --SMB2 Explosion
    extrasounds.sound.sfx105 = Audio.SfxOpen(Misc.resolveSoundFile("sound/hammerthrow.ogg")) --Player hammer throw
    extrasounds.sound.sfx106 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo1.ogg")) --Shell hit 2
    extrasounds.sound.sfx107 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo2.ogg")) --Shell hit 3
    extrasounds.sound.sfx108 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo3.ogg")) --Shell hit 4
    extrasounds.sound.sfx109 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo4.ogg")) --Shell hit 5
    extrasounds.sound.sfx110 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo5.ogg")) --Shell hit 6
    extrasounds.sound.sfx111 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo6.ogg")) --Shell hit 7
    extrasounds.sound.sfx112 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo7.ogg")) --Shell hit 8
    
    Graphics.sprites.hardcoded["33-2"].img = nil
    Graphics.sprites.hardcoded["33-5"].img = nil
    
    Graphics.sprites.npc[10].img = nil
    Graphics.sprites.npc[33].img = nil
    Graphics.sprites.npc[88].img = nil
    Graphics.sprites.npc[97].img = nil
    Graphics.sprites.npc[103].img = nil
    Graphics.sprites.npc[258].img = nil
        
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
    
    costume.abilitesenabled = false
end

return costume