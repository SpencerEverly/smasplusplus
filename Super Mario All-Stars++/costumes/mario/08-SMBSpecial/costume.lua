--[[

    Updated SMW Mario, Luigi and Toad Costumes
    by MrDoubleA


    Mario sprites by: Nintendo, GlacialSiren484, AwesomeZack
    Luigi sprites by: Nintendo, GlacialSiren484, AwesomeZack, MauricioN64
    Toad  sprites by: Nintendo, GlacialSiren484, MauricioN64, Jamestendo64, LinkStormZ

    Super Sheet Part 1:                 https://mfgg.net/index.php?act=resdb&param=02&c=1&id=37883
    Super Sheet Part 2:                 https://mfgg.net/index.php?act=resdb&param=02&c=1&id=38074
    AwesomeZack's Original Mario sheet: https://mfgg.net/index.php?act=resdb&param=02&c=1&id=32929
    AwesomeZack's Original Luigi sheet: https://mfgg.net/index.php?act=resdb&param=02&c=1&id=31073
    Toad map sheet:                     https://mfgg.net/index.php?act=resdb&param=02&c=1&id=37667

]]

local playerManager = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}


costume.pSpeedAnimationsEnabled = true
costume.yoshiHitAnimationEnabled = true
costume.kickAnimationEnabled = true

costume.hammerID = 171
costume.hammerConfig = {
    gfxwidth = 32,
    gfxheight = 32,
    frames = 8,
    framespeed = 4,
    framestyle = 1,
}

costume.playersList = {}
costume.playerData = {}


local eventsRegistered = false

local fallingFrame = 1
local noFallingFrameSmall = {1, 4, 8, 11, 12, 13, 15, 22, 23, 25, 26, 27, 30, 31, 32, 34, 35, 40, 41, 42, 43, 45}
local noFallingFrameBig = {1, 6, 7, 11, 12, 13, 15, 22, 23, 25, 26, 27, 30, 31, 32, 34, 35, 40, 41, 42, 43, 44, 45}
local updateFallingFrame = 2


local characterSpeedModifiers = {
    [CHARACTER_PEACH] = 0.93,
    [CHARACTER_TOAD]  = 1.07,
}
local characterNeededPSpeeds = {
    [CHARACTER_MARIO] = 35,
    [CHARACTER_LUIGI] = 40,
    [CHARACTER_PEACH] = 80,
    [CHARACTER_TOAD]  = 60,
}
local characterDeathEffects = {
    [CHARACTER_MARIO] = 3,
    [CHARACTER_LUIGI] = 5,
    [CHARACTER_PEACH] = 129,
    [CHARACTER_TOAD]  = 130,
}

local deathEffectFrames = 2

local leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKIE}
local shootingPowerups = table.map{PLAYER_FIREFLOWER,PLAYER_ICE,PLAYER_HAMMER}

local smb2Characters = table.map{CHARACTER_PEACH,CHARACTER_TOAD}


local hammerPropertiesList = table.unmap(costume.hammerConfig)
local oldHammerConfig = {}

-- Detects if the player is on the ground, the redigit way. Sometimes more reliable than just p:isOnGround().
local function isOnGround(p)
    return (
        p.speedY == 0 -- "on a block"
        or p:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or p:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end


local function isSlidingOnIce(p)
    return (p:mem(0x0A,FIELD_BOOL) and (not p.keys.left and not p.keys.right))
end

local function isSlowFalling(p)
    return (leafPowerups[p.powerup] and p.speedY > 0 and (p.keys.jump or p.keys.altJump))
end


local function canBuildPSpeed(p)
    return (
        costume.pSpeedAnimationsEnabled
        and p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and p.mount ~= MOUNT_BOOT and p.mount ~= MOUNT_CLOWNCAR
        and not p.climbing
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not p:mem(0x4A,FIELD_BOOL) -- statue
        and p:mem(0x34,FIELD_WORD) == 0 -- underwater
    )
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

local function canDuck(p)
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
            or (p.holdingNPC ~= nil and p.powerup == PLAYER_SMALL) -- small and holding an NPC
            or p:mem(0x34,FIELD_WORD) > 0 -- underwater
        )
    )
end

local function canHitYoshi(p)
    return (
        costume.yoshiHitAnimationEnabled
        and p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and p.mount == MOUNT_YOSHI
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
    )
end


local clearPipeHorizontalFrames = table.map{2,42,44}
local clearPipeVerticalFrames = table.map{15}

local function isInClearPipe(p)
    local frame = costume.playerData[p].frameInOnDraw

    return (
        p.forcedState == FORCEDSTATE_DOOR
        and (clearPipeHorizontalFrames[frame] or clearPipeVerticalFrames[frame])
    )
end


local function setHeldNPCPosition(p,x,y)
    local holdingNPC = p.holdingNPC

    holdingNPC.x = x
    holdingNPC.y = y


    if holdingNPC.id == 49 and holdingNPC.ai2 > 0 then -- toothy pipe
        -- You'd think that redigit's pointers work, but nope! this has to be done instead
        for _,toothy in NPC.iterate(50,p.section) do
            if toothy.ai1 == p.idx then
                if p.direction == DIR_LEFT then
                    toothy.x = holdingNPC.x - toothy.width
                else
                    toothy.x = holdingNPC.x + holdingNPC.width
                end

                toothy.y = holdingNPC.y
            end
        end
    end
end

local function handleDucking(p)
    if p.keys.down and not smb2Characters[p.character] and (p.holdingNPC ~= nil or p.powerup == PLAYER_SMALL) and canDuck(p) then
        p:mem(0x12E,FIELD_BOOL,true)

        if isOnGround(p) then
            if p.keys.left then
                p.direction = DIR_LEFT
            elseif p.keys.right then
                p.direction = DIR_RIGHT
            end

            p.keys.left = false
            p.keys.right = false
        end


        if p.holdingNPC ~= nil and p.holdingNPC.isValid then
            local settings = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)

            local heldNPCY = (p.y + p.height - p.holdingNPC.height)
            local heldNPCX

            if p.direction == DIR_RIGHT then
                heldNPCX = p.x + settings.grabOffsetX
            else
                heldNPCX = p.x + p.width - settings.grabOffsetX - p.holdingNPC.width
            end

            setHeldNPCPosition(p,heldNPCX,heldNPCY)
        end
    end

    if smb2Characters[p.character] and p.holdingNPC ~= nil and p.holdingNPC.isValid and not isInClearPipe(p) then
        -- Change the held NPC's position for toad
        local settings = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)

        local heldNPCX = p.x + p.width*0.5 - p.holdingNPC.width*0.5 + settings.grabOffsetX
        local heldNPCY = p.y - p.holdingNPC.height + settings.grabOffsetY

        setHeldNPCPosition(p,heldNPCX,heldNPCY)
    end
end


-- This table contains all the custom animations that this costume has.
-- Properties are: frameDelau, loops, setFrameInOnDraw
local animations = {
    -- Big only animations
    walk = {2,3,36, frameDelay = 4},
    run  = {2,3,36, frameDelay = 6},
    walkHolding = {9,37,38, frameDelay = 4},
    duckSmall = {8},

    -- Small only animation
    walkSmall = {2,9,10,   frameDelay = 4},
    runSmall  = {16,17,18, frameDelay = 6},
    walkHoldingSmall = {36,37,6, frameDelay = 4},

    -- SMB2 characters (like toad)
    walkSmallSMB2 = {2,1,   frameDelay = 6},
    runSmallSMB2  = {16,17, frameDelay = 6},
    walkHoldingSmallSMB2 = {8,9, frameDelay = 6},


    -- Some other animations
    lookUp = {32},
    lookUpHolding = {33},

    duckHolding = {27},

    yoshiHit = {35,45, frameDelay = 6,loops = false},

    kick = {34, frameDelay = 12,loops = false},

    runJump = {19},

    clearPipeHorizontal = {19, setFrameInOnDraw = true},
    clearPipeVertical = {15, setFrameInOnDraw = true},


    -- Fire/ice/hammer things
    shootGround = {11,12,11, frameDelay = 6,loops = false},
    shootAir    = {40,41,40, frameDelay = 6,loops = false},
    shootWater  = {43,43,43, frameDelay = 6,loops = false},


    -- Leaf things
    slowFall = {11,39,5, frameDelay = 5},
    runSlowFall = {19,20,21, frameDelay = 5},
    fallLeafUp = {11},
    runJumpLeafDown = {21},


    -- Swimming
    swimIdle = {40,41, frameDelay = 10},
    swimStroke = {42,43,41,42,43, frameDelay = 4,loops = false},
    swimStrokeSmall = {42,43,41,42,43, frameDelay = 4,loops = false},


    -- To fix a dumb bug with toad's spinjump while holding an item
    spinjumpSidwaysToad = {8},
}


-- This function returns the name of the custom animation currently playing.
local function findAnimation(p)
    local data = costume.playerData[p]


    -- What P-Speed values gets used is dependent on if the player has a leaf powerup
    local atPSpeed = (p.holdingNPC == nil)

    if atPSpeed then
        if leafPowerups[p.powerup] then
            atPSpeed = p:mem(0x16C,FIELD_BOOL) or p:mem(0x16E,FIELD_BOOL)
        else
            atPSpeed = (data.pSpeed >= characterNeededPSpeeds[p.character])
        end
    end


    if p.deathTimer > 0 then
        return nil
    end


    if p.mount == MOUNT_YOSHI then
        if canHitYoshi(p) then
            -- Hitting yoshi in the back of the head
            if data.yoshiHitTimer == 1 then
                return "yoshiHit"
            elseif (data.currentAnimation == "yoshiHit" and not data.animationFinished) then
                return data.currentAnimation
            end
        end

        return nil
    elseif p.mount ~= MOUNT_NONE then
        return nil
    end


    if p.forcedState == FORCEDSTATE_PIPE then
        local warp = Warp(p:mem(0x15E,FIELD_WORD) - 1)

        local direction
        if p.forcedTimer == 0 then
            direction = warp.entranceDirection
        else
            direction = warp.exitDirection
        end

        if direction == 2 or direction == 4 then
            if p.powerup == PLAYER_SMALL then
                return "walkSmall",0.5
            else
                return "walk",0.5
            end
        end

        return nil
    elseif p.forcedState == FORCEDSTATE_DOOR then
        -- Clear pipe stuff (it's weird)
        local frame = data.frameInOnDraw

        if clearPipeHorizontalFrames[frame] then
            return "clearPipeHorizontal"
        elseif clearPipeVerticalFrames[frame] then
            return "clearPipeVertical"
        end


        return nil
    elseif p.forcedState ~= FORCEDSTATE_NONE then
        return nil
    end


    if p:mem(0x26,FIELD_WORD) > 0 then
        return nil
    end


    if p:mem(0x12E,FIELD_BOOL) then
        if smb2Characters[p.character] then
            return nil
        elseif p.holdingNPC ~= nil then
            return "duckHolding"
        elseif p.powerup == PLAYER_SMALL then
            return "duckSmall"
        else
            return nil
        end
    end


    
    if p.climbing
    or p:mem(0x3C,FIELD_BOOL) -- sliding
    or p:mem(0x44,FIELD_BOOL) -- shell surfing
    or p:mem(0x4A,FIELD_BOOL) -- statue
    or p:mem(0x164,FIELD_WORD) ~= 0 -- tail attack
    then
        return nil
    end


    if p:mem(0x50,FIELD_BOOL) then -- spin jumping
        if smb2Characters[p.character] and p.frame == 5 then -- dumb bug
            return "spinjumpSidwaysToad"
        else
            return nil
        end
    end


    local isShooting = (p:mem(0x118,FIELD_FLOAT) >= 100 and p:mem(0x118,FIELD_FLOAT) <= 118 and shootingPowerups[p.powerup])


    -- Kicking
    if data.currentAnimation == "kick" and not data.animationFinished then
        return data.currentAnimation
    elseif p.holdingNPC == nil and data.wasHoldingNPC and costume.kickAnimationEnabled then -- stopped holding an NPC
        if not smb2Characters[p.character] then
            local e = Effect.spawn(75, p.x + p.width*0.5 + p.width*0.5*p.direction,p.y + p.height*0.5)

            e.x = e.x - e.width *0.5
            e.y = e.y - e.height*0.5
        end

        return "kick"
    end


    if isOnGround(p) then
        -- GROUNDED ANIMATIONS --


        if isShooting then
            return "shootGround"
        end


        -- Skidding
        if (p.speedX < 0 and p.keys.right) or (p.speedX > 0 and p.keys.left) or p:mem(0x136,FIELD_BOOL) then
            return nil
        end


        -- Walking
        if p.speedX ~= 0 and not isSlidingOnIce(p) then
            local walkSpeed = math.max(0.35,math.abs(p.speedX)/Defines.player_walkspeed)

            local animationName

            if atPSpeed then
                animationName = "run"
            else
                animationName = "walk"

                if p.holdingNPC ~= nil then
                    animationName = animationName.. "Holding"
                end
            end

            if p.powerup == PLAYER_SMALL then
                animationName = animationName.. "Small"

                if smb2Characters[p.character] then
                    animationName = animationName.. "SMB2"
                end
            end


            return animationName,walkSpeed
        end

        -- Looking up
        if p.keys.up then
            if p.holdingNPC == nil then
                return "lookUp"
            else
                return "lookUpHolding"
            end
        end

        return nil
    elseif (p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0) and p.holdingNPC == nil then -- swimming
        -- SWIMMING ANIMATIONS --


        if isShooting then
            return "shootWater"
        end
        

        if p:mem(0x38,FIELD_WORD) == 15 then
            if p.powerup == PLAYER_SMALL then
                return "swimStrokeSmall"
            else
                return "swimStroke"
            end
        elseif ((data.currentAnimation == "swimStroke" and p.powerup ~= PLAYER_SMALL) or (data.currentAnimation == "swimStrokeSmall" and p.powerup == PLAYER_SMALL)) and not data.animationFinished then
            return data.currentAnimation
        end

        return "swimIdle"
    else
        -- AIR ANIMATIONS --


        if isShooting then
            return "shootAir"
        end
        

        if p:mem(0x16E,FIELD_BOOL) then -- flying with leaf
            return nil
        end

        
        if atPSpeed then
            if isSlowFalling(p) then
                return "runSlowFall"
            elseif leafPowerups[p.powerup] and p.speedY > 0 then
                return "runJumpLeafDown"
            else
                return nil
            end
        end


        if p.holdingNPC == nil then
            if isSlowFalling(p) then
                return "slowFall"
            elseif data.useFallingFrame then
                --Text.print("true", 100, 100)
                if leafPowerups[p.powerup] and p.speedY <= 0 then
                    return "fallLeafUp"
                end
            end
        end

        return nil
    end
end


function costume.onInit(p)
    if p.powerup == 1 then
        extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/08-SMBSpecial/player-jump-small.ogg")
    elseif p.powerup >= 2 then
        extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/08-SMBSpecial/player-jump.ogg")
    end
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/mario/08-SMBSpecial/stomped.ogg")
    Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/mario/08-SMBSpecial/block-hit.ogg")
    extrasounds.sound.sfx[4]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/block-smash.ogg"))
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/08-SMBSpecial/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/08-SMBSpecial/player-grow.ogg")
    extrasounds.sound.sfx[7]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/mushroom.ogg"))
    extrasounds.sound.sfx[8]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/player-died.ogg"))
    Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/mario/08-SMBSpecial/shell-hit.ogg")
    extrasounds.sound.sfx[10] = Audio.SfxOpen("costumes/mario/08-SMBSpecial/player-slide.ogg")
    --Audio.sounds[11].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/item-dropped.ogg")
    --Audio.sounds[12].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/has-item.ogg")
    Audio.sounds[13].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/camera-change.ogg")
    extrasounds.sound.sfx[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/coin.ogg"))
    extrasounds.sound.sfx[15] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/1up.ogg"))
    Audio.sounds[16].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/lava.ogg")
    Audio.sounds[17].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/warp.ogg")
    extrasounds.sound.sfx[18] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/fireball.ogg"))
    --Audio.sounds[19].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/level-win.ogg")
    --Audio.sounds[20].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/boss-beat.ogg")
    --Audio.sounds[21].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/dungeon-win.ogg")
    Audio.sounds[22].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/bullet-bill.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/grab.ogg")
    Audio.sounds[24].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/spring.ogg")
    Audio.sounds[25].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/hammer.ogg")
    Audio.sounds[29].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/do.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/key.ogg")
    Audio.sounds[32].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/pswitch.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/mario/08-SMBSpecial/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/racoon.ogg")
    Audio.sounds[35].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/boot.ogg")
    --extrasounds.sound.sfx[36] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/smash.ogg"))
    Audio.sounds[37].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/thwomp.ogg")
    Audio.sounds[38].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/birdo-spit.ogg")
    extrasounds.sound.sfx[39] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/birdo-hit.ogg"))
    Audio.sounds[41].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/birdo-beat.ogg")
    extrasounds.sound.sfx[42] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/npc-fireball.ogg"))
    extrasounds.sound.sfx[43] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/fireworks.ogg"))
    --Audio.sounds[44].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/bowser-killed.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/door.ogg")
    --Audio.sounds[47].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/message.ogg")
    Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/yoshi.ogg")
    Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/yoshi-hurt.ogg")
    --Audio.sounds[50].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/yoshi-tongue.ogg")
    Audio.sounds[51].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/yoshi-egg.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/player-died2.ogg")
    Audio.sounds[55].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/yoshi-swallow.ogg")
    Audio.sounds[57].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/dry-bones.ogg")
    Audio.sounds[58].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/smw-checkpoint.ogg")
    extrasounds.sound.sfx[59] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/dragon-coin.ogg"))
    --Audio.sounds[61].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/smw-blaarg.ogg")
    --Audio.sounds[62].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/wart-bubble.ogg")
    --Audio.sounds[63].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/wart-die.ogg")
    Audio.sounds[71].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/climbing.ogg")
    Audio.sounds[72].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/swim.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/grab2.ogg")
    --Audio.sounds[74].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/saw.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/smb2-throw.ogg")
    Audio.sounds[76].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/smb2-hit.ogg")
    Audio.sounds[91].sfx = Audio.SfxOpen("costumes/mario/08-SMBSpecial/bubble.ogg")
    extrasounds.sound.sfx[92] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/sprout-vine.ogg")) --Vine sprout
    extrasounds.sound.sfx[93] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/iceball.ogg")) --Iceball
    extrasounds.sound.sfx[96] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/2up.ogg")) --2UP
    extrasounds.sound.sfx[97] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/3up.ogg")) --3UP
    extrasounds.sound.sfx[98] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/5up.ogg")) --5UP
    extrasounds.sound.sfx[99] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/dragon-coin-get2.ogg")) --Dragon Coin #2
    extrasounds.sound.sfx[100] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/dragon-coin-get3.ogg")) --Dragon Coin #3
    extrasounds.sound.sfx[101] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/dragon-coin-get4.ogg")) --Dragon Coin #4
    extrasounds.sound.sfx[102] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/dragon-coin-get5.ogg")) --Dragon Coin #5
    extrasounds.sound.sfx[103] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/cherry.ogg")) --Cherry
    extrasounds.sound.sfx[104] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/explode.ogg")) --SMB2 Explosion
    extrasounds.sound.sfx[105] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/08-SMBSpecial/hammerthrow.ogg")) --Player hammer throw
    -- If events have not been registered yet, do so
    if not eventsRegistered then
        registerEvent(costume,"onTick")
        registerEvent(costume,"onTickEnd")
        registerEvent(costume,"onDraw")

        eventsRegistered = true
    end


    -- Add this player to the list
    if costume.playerData[p] == nil then
        costume.playerData[p] = {
            currentAnimation = "",
            animationTimer = 0,
            animationSpeed = 1,
            animationFinished = false,

            forcedFrame = nil,

            frameInOnDraw = p.frame,


            pSpeed = 0,
            useFallingFrame = false,
            wasHoldingNPC = false,
            yoshiHitTimer = 0,
        }

        table.insert(costume.playersList,p)
    end

    -- Edit the hammer a little
    --if costume.hammerID ~= nil and (p.character == CHARACTER_MARIO or p.character == CHARACTER_LUIGI) then
    --    local config = NPC.config[costume.hammerID]
--
    --    for _,name in ipairs(hammerPropertiesList) do
    --        oldHammerConfig[name] = config[name]
    --        config[name] = costume.hammerConfig[name]
    --    end
    --end
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
    extrasounds.sound.sfx[81] = nil
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
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.4
    -- Remove the player from the list
    if costume.playerData[p] ~= nil then
        costume.playerData[p] = nil

        local spot = table.ifind(costume.playersList,p)

        if spot ~= nil then
            table.remove(costume.playersList,spot)
        end
    end

    -- Clean up the hammer edit
    --if costume.hammerID ~= nil and (p.character == CHARACTER_MARIO or p.character == CHARACTER_LUIGI) then
    --    local config = NPC.config[costume.hammerID]
--
    --    for _,name in ipairs(hammerPropertiesList) do
    --        config[name] = oldHammerConfig[name] or config[name]
    --        oldHammerConfig[name] = nil
    --    end
    --end
end



function costume.onTick()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]


        handleDucking(p)

        -- Yoshi hitting (creates a small delay between hitting the run button and yoshi actually sticking his tongue out)
        if canHitYoshi(p) then
            if data.yoshiHitTimer > 0 then
                data.yoshiHitTimer = data.yoshiHitTimer + 1

                if data.yoshiHitTimer >= 8 then
                    -- Force yoshi's tongue out
                    p:mem(0x10C,FIELD_WORD,1) -- set tongue out
                    p:mem(0xB4,FIELD_WORD,0) -- set tongue length
                    p:mem(0xB6,FIELD_BOOL,false) -- set tongue retracting

                    SFX.play(50)

                    data.yoshiHitTimer = 0
                else
                    p:mem(0x172,FIELD_BOOL,false)
                end
            elseif p.keys.run and p:mem(0x172,FIELD_BOOL) and (p:mem(0x10C,FIELD_WORD) == 0 and p:mem(0xB8,FIELD_WORD) == 0 and p:mem(0xBA,FIELD_WORD) == 0) then
                p:mem(0x172,FIELD_BOOL,false)
                data.yoshiHitTimer = 1
            end
        else
            data.yoshiHitTimer = 0
        end
    end
end

function costume.onTickEnd()
    if player.powerup == 1 then
        extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/08-SMBSpecial/player-jump-small.ogg")
    elseif player.powerup >= 2 then
        extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/mario/08-SMBSpecial/player-jump.ogg")
    end
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]


        handleDucking(p)


        -- P-Speed
        if canBuildPSpeed(p) then
            if isOnGround(p) then
                if math.abs(p.speedX) >= Defines.player_runspeed*(characterSpeedModifiers[p.character] or 1) then
                    data.pSpeed = math.min(characterNeededPSpeeds[p.character] or 0,data.pSpeed + 1)
                else
                    data.pSpeed = math.max(0,data.pSpeed - 0.3)
                end
            end
        else
            data.pSpeed = 0
        end

        -- Falling (once you start the falling animation, you stay in it)
        if canFall(p) then
            data.useFallingFrame = (data.useFallingFrame or p.speedY > 0)
        else
            data.useFallingFrame = false
        end
        
        if player:isGroundTouching() and updateFallingFrame ~= 1 then
            updateFallingFrame = 1
        elseif player.speedY <= 0 and not player:isClimbing() and updateFallingFrame == 1 then
            updateFallingFrame = updateFallingFrame - 1
            fallingFrame = player:getFrame()
        else
            updateFallingFrame = 0
        end
        
        if player:isGroundTouching() or player.mount ~= 0 or player:mem(0x170, FIELD_WORD) > 0 or player:isClimbing() or 
        player:mem(0x34, FIELD_WORD) == 2 or player:mem(0x50, FIELD_BOOL) == true and player.forcedState ~= 3 then
            airdirection = player.direction
        elseif airdirection ~= nil then
            player.direction = airdirection
        end

        --Water physics
        if player:mem(0x34, FIELD_WORD) == 2 and player:mem(0x36, FIELD_BOOL) then
            player.speedY = player.speedY - .0005
            player:mem(0x38, FIELD_WORD, 4)
            if player.keys.jump == 1 then
                if player.powerup == 1 then
                    fallingFrame = 3
                else
                    fallingFrame = 4
                end
                player.speedY = -2
                SFX.play(72)
                player:mem(0x38, FIELD_WORD, 15)
            end
        end
        
        --Awkward Jumping Physics
        --local xspeed = player.speedX * player.direction
        --Text.print(player:mem(0x11E, FIELD_BOOL), 100, 164)
        --Text.print(player.speedX, 100, 180)
        --Text.print(xspeed, 100, 196)
        
        --Text.print(player:mem(0x11C, FIELD_WORD), 300, 116)
        --Text.print(player.speedY, 300, 132)
        
        Defines.jumpheight = 22
        Defines.jumpheight_bounce = 22
        Defines.player_grav = 0.55
        
        --if player:isGroundTouching() or player:isClimbing() then
        --    if player:mem(0x36, FIELD_BOOL) == false then
        --        if player:mem(0x11C, FIELD_WORD) ~= 0 and xspeed < 6 and player.speedY < -6 then
        --            Text.print("Testing", 300, 100)
        --        end
        --    end
        --end

        -- Yoshi hit (change yoshi's head frame)
        if data.yoshiHitTimer >= 3 and canHitYoshi(p) then
            local yoshiHeadFrame = p:mem(0x72,FIELD_WORD)

            if yoshiHeadFrame == 0 or yoshiHeadFrame == 5 then
                p:mem(0x72,FIELD_WORD, yoshiHeadFrame + 2)
            end
        end

        -- Find and start the new animation
        local newAnimation,newSpeed,forceRestart = findAnimation(p)

        if data.currentAnimation ~= newAnimation or forceRestart then
            data.currentAnimation = newAnimation
            data.animationTimer = 0
            data.animationFinished = false

            if newAnimation ~= nil and animations[newAnimation] == nil then
                error("Animation '".. newAnimation.. "' does not exist")
            end
        end

        data.animationSpeed = newSpeed or 1

        -- Progress the animation
        local animationData = animations[data.currentAnimation]

        if animationData ~= nil then
            local frameCount = #animationData

            local frameIndex = math.floor(data.animationTimer / (animationData.frameDelay or 1))

            if frameIndex >= frameCount then -- the animation is finished
                if animationData.loops ~= false then -- this animation loops
                    frameIndex = frameIndex % frameCount
                else -- this animation doesn't loop
                    frameIndex = frameCount - 1
                end

                data.animationFinished = true
            end

            p.frame = animationData[frameIndex + 1]
            data.forcedFrame = p.frame

            data.animationTimer = data.animationTimer + data.animationSpeed
        else
            data.forcedFrame = nil
        end


        -- For kicking
        data.wasHoldingNPC = (p.holdingNPC ~= nil)
    end
end

function costume.onDraw()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]

        data.frameInOnDraw = p.frame

        if data.useFallingFrame and not isSlowFalling(p) and not leafPowerups[p.powerup] and not player:mem(0x50, FIELD_BOOL) 
        and player:mem(0x160, FIELD_WORD) == 0 and not player:mem(0x12E, FIELD_BOOL) then
        --Checks for no leaf, not slow falling, no spinjumping, and no shooting projectiles
            if player.powerup == 1 and table.contains(noFallingFrameSmall, fallingFrame) then
                fallingFrame = 2
            elseif player.powerup ~= 1 and table.contains(noFallingFrameBig, fallingFrame) then
                fallingFrame = 3
            end
            p.frame = fallingFrame
        end

        local animationData = animations[data.currentAnimation]

        if (animationData ~= nil and animationData.setFrameInOnDraw) and data.forcedFrame ~= nil then
            p.frame = data.forcedFrame
        end
    end
    
    --Text.print(updateFallingFrame, 100, 116)
    --Text.print(fallingFrame, 100, 132)
end


return costume