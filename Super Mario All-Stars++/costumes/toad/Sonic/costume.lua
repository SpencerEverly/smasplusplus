local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smashud = require("smashud")
local particles = require('particles')

local costume = {}

local eventsRegistered = false
local plr
local balled
local ballboost = 0
local collidersize = 0
local homing = false
local brake = false
local spinframes = {4}
local lefthomingtrail = particles.Emitter(0,0, Misc.resolveFile('costumes/toad/Sonic/particles_homing-left.ini'))
local righthomingtrail = particles.Emitter(0,0, Misc.resolveFile('costumes/toad/Sonic/particles_homing-right.ini'))    -- Toad's trail when homing attacking
local homingCollider = Colliders.Circle(player.x + 1 * player.width, player.y + 1 * player.height, 160)    -- for Sonic's Homing Attack range
local hominghitCollider = Colliders.Rect(0, 0, 1, 1, 0)        -- for Sonic's homing attack (for hurting the enemy)
local prevspeed = 0
local prevX = 0
local isColliding = false            -- for colliding with a ceiling
local particletimer = 0                -- so the particles won't be spammed
local customoffset = 0                            -- cameraoffset to make bouncing off walls at high speeds look nicer
local spintimer = 0                            -- counting for the fastspin particle
local connected = false
local gravtimer = 0
local flipstate = false                        -- Used for Sonic spinning. Thanks for Marioman for copying code
local rotation = 0                            -- stolen content warning ^
local rotSpeed = 20                            -- ^
local radius = 40                            -- ^
local spinDirection = 1                        -- ^
local playerOpacity = 0                        -- ^
local corksframe = 0                        -- the frame of Sonjc's Corkscrew
local toadspins = Graphics.loadImageResolved("costumes/toad/Sonic/homingframes.png")
local cooldown = 0

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onStart")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPostPlayerHarm")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onTickEnd")
    registerEvent(costume,"onCleanup")
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onPostBlockHit")
    local icantswim = require("icantswim")
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/toad/Sonic/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/toad/Sonic/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/toad/Sonic/block-hit.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen("costumes/toad/Sonic/mushroom.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/toad/Sonic/player-died.ogg")
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/toad/Sonic/shell-hit.ogg")
    extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/toad/Sonic/player-slide.ogg")
    Audio.sounds[12].sfx = Audio.SfxOpen("costumes/toad/Sonic/has-item.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/Sonic/coin.ogg"))
    extrasounds.sound.sfx[15] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/Sonic/1up.ogg"))
    Audio.sounds[16].sfx = Audio.SfxOpen("costumes/toad/Sonic/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/toad/Sonic/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/Sonic/fireball.ogg"))
    Audio.sounds[22].sfx = Audio.SfxOpen("costumes/toad/Sonic/bullet-bill.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/toad/Sonic/grab.ogg")
    Audio.sounds[24].sfx = Audio.SfxOpen("costumes/toad/Sonic/spring.ogg")
    Audio.sounds[25].sfx = Audio.SfxOpen("costumes/toad/Sonic/hammer.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/toad/Sonic/do.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/toad/Sonic/key.ogg")
    Audio.sounds[32].sfx = Audio.SfxOpen("costumes/toad/Sonic/pswitch.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/toad/Sonic/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/toad/Sonic/racoon.ogg")
    extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/Sonic/smash.ogg"))
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/toad/Sonic/door.ogg")
    Audio.sounds[48].sfx = Audio.SfxOpen("costumes/toad/Sonic/yoshi.ogg")
    Audio.sounds[49].sfx = Audio.SfxOpen("costumes/toad/Sonic/yoshi-hurt.ogg")
    Audio.sounds[50].sfx = Audio.SfxOpen("costumes/toad/Sonic/yoshi-tongue.ogg")
    Audio.sounds[51].sfx = Audio.SfxOpen("costumes/toad/Sonic/yoshi-egg.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/toad/Sonic/got-star.ogg")
    Audio.sounds[53].sfx = Audio.SfxOpen("costumes/toad/Sonic/zelda-kill.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/toad/Sonic/player-died2.ogg")
    Audio.sounds[55].sfx = Audio.SfxOpen("costumes/toad/Sonic/yoshi-swallow.ogg")
    Audio.sounds[58].sfx = Audio.SfxOpen("costumes/toad/Sonic/smw-checkpoint.ogg")
    extrasounds.sound.sfx[59] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/Sonic/dragon-coin.ogg"))
    Audio.sounds[71].sfx = Audio.SfxOpen("costumes/toad/Sonic/climbing.ogg")
    Audio.sounds[72].sfx = Audio.SfxOpen("costumes/toad/Sonic/swim.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/toad/Sonic/grab2.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/toad/Sonic/smb2-throw.ogg")
    Audio.sounds[76].sfx = Audio.SfxOpen("costumes/toad/Sonic/smb2-hit.ogg")
    
    --Sonic settings! This is useful for accuracy.
    Defines.player_walkspeed = 9
    Defines.player_runspeed = 9
    Defines.jumpheight = 25
    Defines.jumpheight_bounce = 31
    Defines.projectilespeedx = 10
    Defines.player_grav = 0.5
    
    costume.abilitesenabled = true
    smashud.visible.itembox = false
end

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

function costume.onStart()
    lefthomingtrail:attach(player)
    righthomingtrail:attach(player)
end

local exclusionNPCs = table.map{13,263,265}

function costume.onTick()
    if SaveData.toggleCostumeAbilities == true then
        local isJumping = player:mem(0x11C, FIELD_WORD) and not isOnGround(p) and not player:mem(0x50,FIELD_BOOL) --Jumping detection
        if isJumping then
            balled = true
        elseif not isJumping then
            balled = false
        end
        --plr.powerup = PLAYER_BIG
        player:mem(0x160, FIELD_WORD, 0) --Fireballs are now less delayed!
        local hitNPCs = Colliders.getColliding{a = player, b = hitNPCs, btype = Colliders.NPC}
        
        if balled and player.holdingNPC == nil and player.standingNPC == nil and not hit then
            for _,npc in ipairs(hitNPCs) do
                if exclusionNPCs[npc.id] then
                    return
                elseif npc ~= v and npc.id > 0 then
                    -- Hurt the NPC, and make sure to not give the automatic score
                    local oldScore = NPC.config[npc.id].score
                    NPC.config[npc.id].score = 0
                    NPC.config[npc.id].score = oldScore
                    
                    local hurtNPC = harmNPC(npc,HARM_TYPE_SWORD)
                    if hurtNPC then
                        Misc.givePoints(0,{x = npc.x+npc.width*1.5,y = npc.y+npc.height*0.5},true)
                    end
                end
            end
        end
        
        if spinballed and player.speedX ~= 0 and player:mem(0x26, FIELD_WORD) == 0 and isOnGround(p) and not hit then
            for _,npc in ipairs(hitNPCs) do
                if npc ~= v and npc.id > 0 then
                    -- Hurt the NPC, and make sure to not give the automatic score
                    local oldScore = NPC.config[npc.id].score
                    NPC.config[npc.id].score = 0
                    NPC.config[npc.id].score = oldScore
                    
                    local hurtNPC = harmNPC(npc,HARM_TYPE_SWORD)
                    if hurtNPC then
                        Misc.givePoints(0,{x = npc.x+npc.width*1.5,y = npc.y+npc.height*0.5},true)
                    end
                end
            end
        end
        
        if hit then
            plr.forcedState = FORCEDSTATE_NONE
            plr:mem(0x140, FIELD_WORD, 100)
            hitTicks = hitTicks + 1

            plr.keys.left = false
            plr.keys.right = false
            plr.keys.up = false
            plr.keys.down = false
            plr.keys.jump = false
            plr.keys.altJump = false
            plr.keys.run = false
            plr.keys.altRun = false

            plr.x = plr.x + 4 * plr.direction

            if plr:isGroundTouching() and hitTicks > 5 or (plr:mem(0x148, FIELD_WORD) >= 2 or plr:mem(0x14C, FIELD_WORD) >= 2) then
                hit = false
                plr:mem(0x140, FIELD_WORD, 200)
                Defines.gravity = Defines.gravity * 2
            end
        end
        if (player.powerup == 5) == false then
            if not (isOnGround(p)) and (player.keys.altRun == KEYS_PRESSED) and not homing then
                homing = true
            end
        end

        if (flipstate) or balled and not hit and not GameData.winStateActive then
            --Rotate Toad
            player:setFrame(-50) -- Make player invisible
            rotation = rotation + 36
            gravtimer = gravtimer + 1
            spintimer = spintimer + 1
            if (corksframe < 3) and (gravtimer > 10) then
            corksframe = corksframe + 1
            gravtimer = 0
            end
            Graphics.drawBox{
                texture      = toadspins,
                sceneCoords  = true,
                x            = player.x + (player.width / 2),
                y            = player.y + (player.height / 2),
                width        = 150,
                height       = 150,
                sourceX      = 150 * (player.powerup - 1),
                sourceY      = 150 * corksframe,
                sourceWidth  = 150,
                sourceHeight = 150,
                centered     = true,
                priority     = -25,
                color        = Color.white .. 1,--playerOpacity,
                rotation     = rotation * spinDirection,
            }
            if (spintimer > 60) or connected then    -- if the player is on Ground, homing attacking or has done 2 full rotations, stop rotating
                spintimer = 0
                corksframe = 0
                gravtimer = 0
                flipstate = false
                rotation = 0
            end
        end
    end
end

function costume.onInputUpdate()
    if SaveData.toggleCostumeAbilities then
        if player.speedX ~= 0 and player.keys.down == KEYS_DOWN and isOnGround(p) then
            spinballed = true
            flipstate = true
        elseif player.speedX == 0 and player.keys.down == KEYS_UP or not isOnGround(p) then
            spinballed = false
            flipstate = false
        end
        if player.speedX ~= 0 and player.keys.down == KEYS_PRESSED and isOnGround(p) then
            SFX.play("costumes/toad/Sonic/sonic-charge.ogg")
        end
        if player.keys.altRun == KEYS_PRESSED then
            player:mem(0x172,FIELD_BOOL,false) --Disables alt running
        end
        if (homing) then
            if collidersize < 160 then
                collidersize = collidersize + 16
            elseif collidersize > 159 and not (connected) then
                collidersize = 0
                homing = false
                end
            end
            for p, n in ipairs(Colliders.getColliding{a = homingCollider, btype = Colliders.NPC, filter = function(o)        -- when an NPC is nearby when drill pounding
            if NPC.HITTABLE_MAP[o.id] and not o.friendly and not o.isHidden then
                    return true
                end
            end
        }) do
                    if ((n.x > player.x) and player.direction > 0) or ((n.x < player.x) and player.direction < 0) then
                        connected = true                    -- Toad connects a Homing Attack
                        Sound.playSFX("toad/Sonic/homing.ogg")
                        n.speedY = 0
                        n.speedX = 0                        -- you should hit the target, so it stops just for you!
                        player:mem(0x3A,FIELD_WORD,40)        -- you don't need things like... GRAVITY
                        Defines.player_runspeed = 12
                        player:mem(0x11E,FIELD_BOOL,false)    -- disables jumping midair
                        player:mem(0x120,FIELD_BOOL,false)    -- disables spinjumping midair
                        if math.abs(n.x - player.x) > 48 then     -- if Toad is further away, make him faster
                            player.speedX = player.direction * 10
                        elseif math.abs(n.x - player.x) < 48 then -- if Toad is near the enemy, make him slower (to not overshoot the goal)
                            player.speedX = player.direction * 5
                        end
                        player.speedY = (n.y - player.y - 20)    -- the vertical speed you need homing in on your enemy
                        if player.speedY < -10 then
                            player.speedY = -10                    -- making this the maximum speed they can get vertically
                        end
                        gravtimer = gravtimer + 1
                        player:mem(0x140, FIELD_WORD,40)        -- makes you invincible for 40 frames
                        if (player.direction > 0) and (gravtimer > 1) then
                            --righthomingtrail:Emit(1)
                            gravtimer = 0
                        elseif (player.direction < 0) and (gravtimer > 1) then
                            --lefthomingtrail:Emit(1)
                            gravtimer = 0
                        end
                    end
            end

        if (player.character == CHARACTER_TOAD and isOnGround(p)) then
            homing = false
            connected = false
            collidersize = 0
        elseif (player.character == CHARACTER_TOAD) and (connected and homing) then
            for p, n in ipairs(Colliders.getColliding{a = hominghitCollider, btype = Colliders.NPC, filter = function(o) if NPC.HITTABLE_MAP[o.id] and not o.friendly and not o.isHidden then return true end end}) do
                n.speedX = player.direction * 4
                n.speedY = -6                    -- bounce them away, if they aren't ded
                n:harm(3)                        -- hit the enemy
                player.speedY = -12                -- bounce Toad up a bit
                Defines.player_runspeed = 6
                player.speedX = 0
                collidersize = 0
                homing = false                    -- reset homing attack checks
                connected = false
                spinDirection = player.direction
                flipstate = true
                gravtimer = 0
            end
        end
    end
end

function costume.onDraw()
    if SaveData.toggleCostumeAbilities then
        if hit then
            plr.frame = 16
        end
        if balled and not hit then
            plr.frame = 4
        end
        if spinballed and player.speedX ~= 0 and player.keys.down == KEYS_DOWN and not hit then
            plr.frame = 4
        end
        lefthomingtrail:draw(-30)
        righthomingtrail:draw(-30)
    end
end

function costume.onTickEnd()
    homingCollider.radius = collidersize
    homingCollider.x = player.x + (player.width / 2)
    homingCollider.y = player.y + (player.width / 2)

    hominghitCollider.width = player.width + 22
    hominghitCollider.height = player.height + 22
    hominghitCollider.x = player.x + (player.width / 2)
    hominghitCollider.y = player.y + (player.height / 2)
end    

function costume.onPlayerHarm(e, p)
    if SaveData.toggleCostumeAbilities == true then
        if hit then
            e.cancelled = true
        end
        if balled then
            e.cancelled = true
        end
        if spinballed and p.speedX ~= 0 then
            e.cancelled = true
        end
        if p.hasStarman or p.isMega then
            e.cancelled = true
            return
        end
        if (spinmode == true) and math.abs(p.speedX) > 5 then
            for p,n in ipairs(Colliders.getColliding{atype = Colliders.NPC, b = p, filter = function(o) if NPC.HITTABLE_MAP[o.id] and not o.friendly and not o.isHidden then return true end end}) do
                n:harm()
            end
            e.cancelled = true
        end
    end
end

function costume.onPostPlayerHarm(p)
    if not p.hasStarman or not p.isMega then
        if SaveData.toggleCostumeAbilities then
            if SaveData.totalCoinsClassic > 0 then
                hit = true
                hitTicks = 0
                plr.speedY = -8
                plr.speedX = 0
                Defines.gravity = Defines.gravity / 2
                SFX.play(5)
                SaveData.totalCoinsClassic = 0
                Effect.spawn(11, p.x, p.y)
            else
                p:kill()
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
        
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
    
    costume.abilitesenabled = false
    smashud.visible.itembox = true
end

return costume