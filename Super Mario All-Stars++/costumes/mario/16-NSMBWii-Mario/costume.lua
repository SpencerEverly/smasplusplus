--[[

    NSMBWii Mario
    By Spencer Everly (Sprites from Mario Multiverse, originally by Keira, and Racoon poses by me)
    Original code by MrDoubleA + Cpt. Mono

]]

local playerManager = require("playerManager")
local extrasounds = require("extrasounds")
local rng = require("base/rng")
local textplus = require("textplus")
local smashud = require("smashud")
_G.smasfunctions = require("smasfunctions")

local costume = {}

costume.loadedSounds = false

local marioHead = Graphics.loadImageResolved("costumes/mario/16-NSMBWii-Mario/hud/lifehead.png")
local coinCounter = Graphics.loadImageResolved("costumes/mario/16-NSMBWii-Mario/hud/coin.png")
local timeCounter = Graphics.loadImageResolved("costumes/mario/16-NSMBWii-Mario/hud/timer.png")
local nsmbWiiFont = textplus.loadFont("littleDialogue/font/nsmbwii-font.ini")

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
local characterList = {"mario", "luigi", "toad", "peach"}
--Please, don't even try putting this over a character besides those four. It's not worth the effort.

local footstepcounter = 0

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

local characterNeededHalfPSpeeds = {
    [CHARACTER_MARIO] = 5,
    [CHARACTER_LUIGI] = 8,
    [CHARACTER_PEACH] = 20,
    [CHARACTER_TOAD]  = 15,
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

local function isJumping(p)
    return (
        p.speedY < 0
        and not p.climbing
    )
end

local function isFalling(p)
    return (
        p.speedY > 0
        and not p.climbing
    )
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
-- Properties are: frameDelay, loops, setFrameInOnDraw
local animations = {
    -- Big only animations
    standing = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47, frameDelay = 3},
    walk = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27, frameDelay = 2},
    halfrun  = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18, frameDelay = 2},
    run  = {1,2,3,4,5,6,7,8,9,10,11,12,13, frameDelay = 2},
    jump = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, frameDelay = 2, loops = false},
    jumphold = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18, frameDelay = 2, loops = false},
    fall = {17,18,19,20,21,22, frameDelay = 2, loops = false},
    walkHolding = {1,2,3,4,5,6,7,8,9,10,11,12,13,14, frameDelay = 2},
    duck = {1,2,3,4, frameDelay = 2, loops = false},
    skid = {1,2, frameDelay = 2, loops = false},
    spinjump = {1,2,3,4,5,6,7,8, frameDelay = 2},
    climbing = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26, frameDelay = 2},
    climbingstill = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24, frameDelay = 2},
    dooropen = {1, frameDelay = 3},
    pipe = {1,2,3,4, frameDelay = 2, loops = false},
    standinghold = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34, frameDelay = 3},
    
    -- Small only animation
    standingSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46, frameDelay = 3},
    walkSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28, frameDelay = 2},
    halfrunSmall  = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20, frameDelay = 2},
    runSmall  = {1,2,3,4,5,6,7,8,9,10,11,12,13, frameDelay = 2},
    jumpSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17, frameDelay = 2, loops = false},
    jumpholdSmall = {1,2,3,4,5,6,7,8,9,10,11,12,11,10,9,8,7,6,5,4,3,2,1, frameDelay = 2, loops = false},
    walkHoldingSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14, frameDelay = 2},
    duckSmall = {1,2,3,4, frameDelay = 2, loops = false},
    spinjumpSmall = {1,2,3,4,5,6,7,8, frameDelay = 2},
    fallSmall = {19,20,21,22,23, frameDelay = 2, loops = false},
    skidSmall = {1,2, frameDelay = 2, loops = false},
    climbingSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27, frameDelay = 1.3},
    climbingstillSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20, frameDelay = 2},
    dooropenSmall = {1, frameDelay = 3},
    pipeSmall = {1,2,3,4, frameDelay = 2, loops = false},
    standingholdSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34, frameDelay = 3},

    -- SMB2 characters (like toad)
    walkSmallSMB2 = {2,1,   frameDelay = 6},
    runSmallSMB2  = {16,17, frameDelay = 6},
    walkHoldingSmallSMB2 = {8,9, frameDelay = 6},


    -- Some other animations
    lookUp = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46, frameDelay = 3},
    lookUpHolding = {33},
    
    grabbing = {1,2, frameDelay = 6},

    duckHolding = {1},

    yoshiHit = {1,2,3,4, frameDelay = 2,loops = false},
    yoshiHitSmall = {1,2,3,4,5,6,7,8,9,10, frameDelay = 2,loops = false},
    yoshiidle = {1, frameDelay = 5},
    yoshiidleSmall = {1, frameDelay = 5},

    kick = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19, frameDelay = 2, loops = false},
    kickSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17, frameDelay = 2, loops = false},

    runJump = {19},


    clearPipeHorizontal = {19, setFrameInOnDraw = true},
    clearPipeVertical = {15, setFrameInOnDraw = true},


    -- Fire/ice/hammer things
    shootGround = {1,2,3,4,5,6,7,8,9,10,11,12,13,14, frameDelay = 1,loops = false},


    -- Leaf things
    slowFall = {11,39,5, frameDelay = 5},
    runSlowFall = {19,20,21, frameDelay = 5},
    fallLeafUp = {11},
    runJumpLeafDown = {21},
    flyLeaf = {1,2,3},
    tailSwipe = {1,2,3},


    -- Swimming
    swimIdle = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19, frameDelay = 2},
    swimIdleSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17, frameDelay = 2},
    swimStroke = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34, frameDelay = 2,loops = false},
    swimStrokeSmall = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22, frameDelay = 2,loops = false},
    


    -- To fix a dumb bug with toad's spinjump while holding an item
    spinjumpSidwaysToad = {8},
}


-- This function returns the name of the custom animation currently playing.
local function findAnimation(p)
    local data = costume.playerData[p]
    
    --Half P-Speed
    local atHalfPSpeed = (p.holdingNPC == nil)

    if atHalfPSpeed then
        if leafPowerups[p.powerup] then
            atHalfPSpeed = p:mem(0x16C,FIELD_BOOL) or p:mem(0x16E,FIELD_BOOL)
        else
            if characterNeededHalfPSpeeds[p.character] >= data.halfpSpeed then
                atHalfPSpeed = (data.halfpSpeed >= characterNeededHalfPSpeeds[p.character])
            end
        end
    end

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
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-yoshihit.png") end)
            -- Hitting yoshi in the back of the head
            if data.yoshiHitTimer == 1 then
                if p.powerup == PLAYER_SMALL then
                    return "yoshiHitSmall"
                else
                    return "yoshiHit"
                end
            elseif (data.currentAnimation == "yoshiHit" and not data.animationFinished) then
                return data.currentAnimation
            end
        end
        
        if data.yoshiHitTimer == 0 then
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-yoshi.png") end)
        end
        if p.powerup == PLAYER_SMALL then
            return "yoshiidleSmall"
        else
            return "yoshiidle"
        end
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
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-walk.png") end)
            if p.powerup == PLAYER_SMALL then
                return "walkSmall",0.5
            else
                return "walk",0.5
            end
        elseif direction == 1 or direction == 3 then
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-pipe.png") end)
            if p.powerup == PLAYER_SMALL then
                return "pipeSmall",0.5
            else
                return "pipe",0.5
            end
        end
    elseif p.forcedState == FORCEDSTATE_DOOR then
        -- Clear pipe stuff (it's weird)
        local frame = data.frameInOnDraw
        pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup..".png") end)

        if clearPipeHorizontalFrames[frame] then
            return "clearPipeHorizontal"
        elseif clearPipeVerticalFrames[frame] then
            return "clearPipeVertical"
        else
            if p.powerup == PLAYER_SMALL then
                return "dooropenSmall",0.5
            else
                return "dooropen",0.5
            end
        end
    elseif p.forcedState ~= FORCEDSTATE_NONE then
        return nil
    end

    
    --Grabbing from below
    if p:mem(0x26,FIELD_WORD) > 0 then
        pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-grab.png") end)
        return "grabbing"
    end


    if p:mem(0x12E,FIELD_BOOL) then
        if smb2Characters[p.character] then
            return nil
        elseif p.holdingNPC ~= nil then
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-duckgrab.png") end)
            return "duckHolding"
        elseif p.powerup == PLAYER_SMALL then
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-duck.png") end)
            return "duckSmall"
        else
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-duck.png") end)
            return "duck"
        end
    end


    
    if p:mem(0x3C,FIELD_BOOL) -- sliding
    or p:mem(0x44,FIELD_BOOL) -- shell surfing
    or p:mem(0x4A,FIELD_BOOL) -- statue
    then
        return nil
    end
    
    if p:mem(0x164,FIELD_WORD) ~= 0 then
        pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-swipe.png") end)
        if p.powerup == PLAYER_LEAF then
            return "tailSwipe"
        elseif p.powerup == PLAYER_TANOOKIE then
            return "tailSwipe"
        else
            return nil
        end
    end
    
    if p.climbing then
        if p.speedX == 0 and p.speedY == 0 or p.speedY >= 0 then
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-climbstill.png") end)
            if p.powerup == PLAYER_SMALL then
                return "climbingstillSmall"
            else
                return "climbingstill"
            end
        elseif p.speedX ~= 0 or p.speedY <= 0 then
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-climb.png") end)
            if p.powerup == PLAYER_SMALL then
                return "climbingSmall"
            else
                return "climbing"
            end
        end
    end
    
    
    if p:mem(0x50,FIELD_BOOL) then -- spin jumping
        pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-spinjump.png") end)
        if smb2Characters[p.character] and p.frame == 5 then -- dumb bug
            return "spinjumpSidwaysToad"
        elseif p.powerup == PLAYER_SMALL then
            return "spinjumpSmall"
        elseif p.powerup == PLAYER_LEAF or p.powerup == PLAYER_TANOOKIE then
            return "spinjump"
        else
            return "spinjump"
        end
    end


    local isShooting = (p:mem(0x118,FIELD_FLOAT) >= 100 and p:mem(0x118,FIELD_FLOAT) <= 118 and shootingPowerups[p.powerup])


    -- Kicking
    if data.currentAnimation == "kick" and not data.animationFinished then
        return data.currentAnimation
    elseif p.holdingNPC == nil and data.wasHoldingNPC and costume.kickAnimationEnabled then -- stopped holding an NPC
        pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-throw.png") end)
        if not smb2Characters[p.character] then
            local e = Effect.spawn(75, p.x + p.width*0.5 + p.width*0.5*p.direction,p.y + p.height*0.5)

            e.x = e.x - e.width *0.5
            e.y = e.y - e.height*0.5
        end
        if p.powerup == PLAYER_SMALL then
            return "kickSmall"
        else
            return "kick"
        end
    end


    if isOnGround(p) then
        -- GROUNDED ANIMATIONS --
        
        
        --Shooting fire/ice
        if isShooting then
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-shoot.png") end)
            return "shootGround"
        end


        -- Skidding
        if (p.speedX < 0 and p.keys.right) or (p.speedX > 0 and p.keys.left) or p:mem(0x136,FIELD_BOOL) then
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-skid.png") end)
            if p.powerup == PLAYER_SMALL then
                return "skidSmall"
            else
                return "skid"
            end
        end

        
        --Standing
        if p.speedX == 0 and not isSlidingOnIce(p) and not isShooting and not p:mem(0x12E,FIELD_BOOL) then
            if p.holdingNPC == nil then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup..".png") end)
                if p.powerup == PLAYER_SMALL then
                    return "standingSmall"
                else
                    return "standing"
                end
            elseif p.holdingNPC ~= nil then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-hold.png") end)
                 if p.powerup == PLAYER_SMALL then
                    return "standingholdSmall"
                else
                    return "standinghold"
                end
            end
        end
        
        
        -- Walking
        if p.speedX ~= 0 and not isSlidingOnIce(p) then
            local walkSpeed = math.max(0.35,math.abs(p.speedX)/Defines.player_walkspeed)

            local animationName
            if atPSpeed then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-run.png") end)
                animationName = "run"
            elseif atHalfPSpeed then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-halfrun.png") end)
                animationName = "halfrun"
            else
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-walk.png") end)
                animationName = "walk"

                if p.holdingNPC ~= nil then
                    pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-holdwalk.png") end)
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
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup..".png") end)
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
            return "shootGround"
        end
        

        if p:mem(0x38,FIELD_WORD) == 15 then
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-swimjump.png") end)
            if p.powerup == PLAYER_SMALL then
                return "swimStrokeSmall"
            else
                return "swimStroke"
            end
        elseif ((data.currentAnimation == "swimStroke" and p.powerup ~= PLAYER_SMALL) or (data.currentAnimation == "swimStrokeSmall" and p.powerup == PLAYER_SMALL)) and not data.animationFinished then
            return data.currentAnimation
        end
        
        pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..player.powerup.."-swim.png") end)
        if p.powerup == PLAYER_SMALL then
            return "swimIdleSmall"
        else
            return "swimIdle"
        end
    else
        -- AIR ANIMATIONS --


        if isShooting then
            return "shootGround"
        end
        

        if p:mem(0x16E,FIELD_BOOL) then -- flying with leaf
            pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-fly.png") end)
            if p.powerup == 4 then
                return "flyLeaf"
            elseif p.powerup == 4 then
                return "flyLeaf"
            else
                return nil
            end
        end

        
        if atPSpeed then
            if isSlowFalling(p) then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-fly.png") end)
                return "runSlowFall"
            elseif leafPowerups[p.powerup] and p.speedY > 0 then
                return "runJumpLeafDown"
            elseif isJumping(p) then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-jump.png") end)
                if p.powerup == 1 then
                    return "jumpSmall"
                else
                    return "jump"
                end
            elseif isFalling(p) then
                if p.holdingNPC == nil then
                    pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-jump.png") end)
                    if p.powerup == 1 then
                        return "fallSmall"
                    else
                       return "fall"
                    end
                elseif p.holdingNPC ~= nil then
                    pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-jump.png") end)
                    if p.powerup == 1 then
                        return "jumpholdSmall"
                    else
                        return "jumphold"
                    end
                end
            end
        end
        
        --JUMPING
        if isJumping(p) then
            if p.holdingNPC == nil then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-jump.png") end)
                if p.powerup == 1 then
                    return "jumpSmall"
                else
                    return "jump"
                end
            elseif p.holdingNPC ~= nil then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-holdjump.png") end)
                if p.powerup == 1 then
                    return "jumpholdSmall"
                else
                    return "jumphold"
                end
            end
        end
        
        --FALLING
        if isFalling(p) then
            if p.holdingNPC == nil then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-jump.png") end)
                if p.powerup == 1 then
                    return "fallSmall"
                else
                    return "fall"
                end
            elseif p.holdingNPC ~= nil then
                pcall(function() Graphics.sprites.mario[p.powerup].img = Graphics.loadImageResolved("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..p.powerup.."-holdjump.png") end)
                if p.powerup == 1 then
                    return "jumpholdSmall"
                else
                    return "jumphold"
                end
            end
        end


        if p.holdingNPC == nil then
            if isSlowFalling(p) then
                return "slowFall"
            elseif data.useFallingFrame then
                if p.powerup == PLAYER_SMALL and not smb2Characters[p.character] then
                    return "fallSmall"
                elseif leafPowerups[p.powerup] and p.speedY <= 0 then
                    return "fallLeafUp"
                else
                    return "fall"
                end
            end
        end

        return nil
    end
end

function costume.onInputUpdate()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]
        if p.keys.down == KEYS_PRESSED and canDuck(p) and not Misc.isPaused() then
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX("mario/16-NSMBWii-Mario/player-duck.ogg")
            end
        end
    end
end

function costume.onPostNPCKill(npc, harmType)
    for _,p in ipairs(Player.get()) do
        local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
        local starman = table.map{996,994}
        for k,v in ipairs(NPC.get({996,994})) do
            if starman[npc.id] and Colliders.collide(p, v) then
                local rngkey = rng.randomInt(1,3)
                Sound.playSFX("mario/16-NSMBWii-Mario/mario-gotstar"..rngkey..".ogg")
            end
        end
    end
end

function costume.onInit(p)
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
    Graphics.overrideHUD(costume.drawHUD)
    
    -- If events have not been registered yet, do so
    if not eventsRegistered then
        registerEvent(costume,"onStart")
        registerEvent(costume,"onTick")
        registerEvent(costume,"onTickEnd")
        registerEvent(costume,"onDraw")
        registerEvent(costume,"onInputUpdate")
        registerEvent(costume,"onPostNPCKill")
        
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
            halfpSpeed = 0,
        }

        table.insert(costume.playersList,p)
    end

    -- Edit the hammer a little
    if costume.hammerID ~= nil and (p.character == CHARACTER_MARIO or p.character == CHARACTER_LUIGI) then
        local config = NPC.config[costume.hammerID]

        for _,name in ipairs(hammerPropertiesList) do
            oldHammerConfig[name] = config[name]
            config[name] = costume.hammerConfig[name]
        end
    end
end

function costume.onCleanup(p)
    for i = 1,91 do
        Audio.sounds[i].sfx = nil
    end
    for i = 1,165 do
        extrasounds.sound.sfx[i] = nil
    end
    
    Graphics.overrideHUD(Graphics.drawVanillaHUD)
    
    -- Remove the player from the list
    if costume.playerData[p] ~= nil then
        Audio.sounds[30].sfx  = nil
        Audio.sounds[52].sfx  = nil
        costume.playerData[p] = nil

        local spot = table.ifind(costume.playersList,p)

        if spot ~= nil then
            table.remove(costume.playersList,spot)
        end
    end

    -- Clean up the hammer edit
    if costume.hammerID ~= nil and (p.character == CHARACTER_MARIO or p.character == CHARACTER_LUIGI) then
        local config = NPC.config[costume.hammerID]

        for _,name in ipairs(hammerPropertiesList) do
            config[name] = oldHammerConfig[name] or config[name]
            oldHammerConfig[name] = nil
        end
    end
end



function costume.onTick()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]

        handleDucking(p)
        
        --Shell kick voice
        if p.holdingNPC ~= nil and p.keys.run == KEYS_UNPRESSED then
            local rngshellkick = rng.randomInt(1,6)
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX("mario/16-NSMBWii-Mario/mario-shellkick"..rngshellkick..".ogg")
            end
        end
        
        --Footstep system
        if p:isOnGround() and not p.keys.down then
            if not (p.speedX < 0 and p.keys.right) or (p.speedX > 0 and p.keys.left) then
                if footstepcounter >= 5 then
                    footstepcounter = 0
                end
                if p.speedX == 0 then
                    footstepcounter = 0
                elseif p.speedX >= 2 or p.speedX <= -2 then
                    footstepcounter = footstepcounter + 0.2
                    if footstepcounter >= 2.0 and footstepcounter <= 2.2 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep1.ogg", 0.7)
                    elseif footstepcounter >= 4.0 and footstepcounter <= 4.2 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep2.ogg", 0.7)
                    end
                elseif p.speedX >= 3 or p.speedX <= -3 then
                    footstepcounter = footstepcounter + 0.5
                    if footstepcounter >= 2.0 and footstepcounter <= 2.2 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep1.ogg", 0.7)
                    elseif footstepcounter >= 4.0 and footstepcounter <= 4.2 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep2.ogg", 0.7)
                    end
                elseif p.speedX >= 4 or p.speedX <= -4 then
                    footstepcounter = footstepcounter + 1
                    if footstepcounter >= 2.0 and footstepcounter <= 2.4 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep1.ogg", 0.7)
                    elseif footstepcounter >= 4.0 and footstepcounter <= 4.4 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep2.ogg", 0.7)
                    end
                elseif p.speedX >= 5 or p.speedX <= -5 then
                    footstepcounter = footstepcounter + 5
                    if footstepcounter >= 2.0 and footstepcounter <= 2.5 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep1.ogg", 0.7)
                    elseif footstepcounter >= 4.0 and footstepcounter <= 4.5 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep2.ogg", 0.7)
                    end
                elseif p.speedX >= 5.5 or p.speedX <= -5.5 then
                    footstepcounter = footstepcounter + 8
                    if footstepcounter >= 2.0 and footstepcounter <= 2.6 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep1.ogg", 0.7)
                    elseif footstepcounter >= 4.0 and footstepcounter <= 4.6 then
                        Sound.playSFX("mario/16-NSMBWii-Mario/player-footstep2.ogg", 0.7)
                    end
                end
            end
        end
        
        
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
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]


        handleDucking(p)

        
        -- Half Run/P-Speed
        if canBuildPSpeed(p) then
            if isOnGround(p) then
                if math.abs(p.speedX) >= Defines.player_runspeed*(characterSpeedModifiers[p.character] or 1) then
                    data.halfpSpeed = math.min(characterNeededPSpeeds[p.character] or 0,data.pSpeed + 1)
                else
                    data.halfpSpeed = math.max(0,data.pSpeed - 0.3)
                end
                if math.abs(p.speedX) >= Defines.player_runspeed*(characterSpeedModifiers[p.character] or 1) then
                    data.pSpeed = math.min(characterNeededPSpeeds[p.character] or 0,data.pSpeed + 1)
                else
                    data.pSpeed = math.max(0,data.pSpeed - 0.3)
                end
            end
        else
            data.pSpeed = 0
            data.halfpSpeed = 0
        end

        -- Falling (once you start the falling animation, you stay in it)
        if canFall(p) then
            data.useFallingFrame = (data.useFallingFrame or p.speedY > 0)
        else
            data.useFallingFrame = false
        end

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
                return nil
                --error("Animation '".. newAnimation.. "' does not exist")
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

function costume.drawHUD(camIdx,priority,isSplit)
    --Lives
    Graphics.drawImageWP(marioHead, 30, 30, -4.3)
    textplus.print{text = tostring(SaveData.totalLives), font = nsmbWiiFont, priority = -4.3, x = 68, y = 60, color = Color.fromHexRGBA(0xFFFFFFFF)}
    
    --Coins
    Graphics.drawImageWP(coinCounter, 30, 70, -4.3)
    --textplus.print{text = "x", font = minFont, priority = -4.3, x = 225, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    textplus.print{text = tostring(SaveData.totalCoinsClassic), font = nsmbWiiFont, priority = -4.2, x = 44, y = 100, color = Color.fromHexRGBA(0xFFFFFFFF)}

    --Stars
    --Graphics.drawImageWP(starCounter, 305, 26, -4.3)
    --textplus.print{text = "x", font = minFont, priority = -4.3, x = 335, y = 26, xscale = 2, yscale = 2, color = Color.fromHexRGBA(0xFFFFFFFF)}
    textplus.print{text = tostring(SaveData.totalStarCount), font = nsmbWiiFont, priority = -4.3, x = 300, y = 60, color = Color.fromHexRGBA(0xFFFFFFFF)}

    --Score
    textplus.print{text = tostring(SaveData.totalScoreClassic), font = nsmbWiiFont, priority = -4.3, x = 432, y = 60, color = Color.fromHexRGBA(0xFFFFFFFF)}

    --Time
    Graphics.drawImageWP(timeCounter, 682, 40, -4.3)
    textplus.print{text = tostring(Timer.getValue()), font = nsmbWiiFont, priority = -4.3, x = 710, y = 60, color = Color.fromHexRGBA(0xFFFFFFFF)} 
end

function costume.onDraw()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]

        data.frameInOnDraw = p.frame
        
        if not Misc.inEditor() then
            if p.powerup >= 4 then --Until it fully works, this'll do for now.
                p.powerup = 3
            end
        end

        local animationData = animations[data.currentAnimation]

        if (animationData ~= nil and animationData.setFrameInOnDraw) and data.forcedFrame ~= nil then
            p.frame = data.forcedFrame
        end
    end


    -- Change death effects
    if costume.playersList[1] ~= nil then
        local deathEffectID = characterDeathEffects[costume.playersList[1].character]

        for _,e in ipairs(Effect.get(deathEffectID)) do
            e.animationFrame = -999

            local image = Graphics.sprites.effect[e.id].img

            local width = image.width
            local height = image.height / deathEffectFrames

            local frame = math.floor((150 - e.timer) / 8) % deathEffectFrames

            Graphics.drawImageToSceneWP(image, e.x + e.width*0.5 - width*0.5,e.y + e.height*0.5 - height*0.5, 0,frame*height, width,height, -5)
        end
    end
end


return costume