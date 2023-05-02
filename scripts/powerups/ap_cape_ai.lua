--[[

    Cape for smaspowerupsystem.lua
    by MrDoubleA
    Modified by Spencer Everly

    Credit to JDaster64 for making a SMW physics guide and ripping SMA4 Mario/Luigi sprites
    Custom Toad and Link sprites by Legend-Tony980 (https://www.deviantart.com/legend-tony980/art/SMBX-Toad-s-sprites-Fourth-Update-724628909, https://www.deviantart.com/legend-tony980/art/SMBX-Link-s-sprites-Sixth-Update-672269804)
    Custom Peach sprites by Lx Xzit and Pakesho
    SMW Mario and Luigi graphics from AwesomeZack

    Credit to FyreNova for generally being cool (oh and maybe working on a SMBX38A version of this, too)

]]

local playerManager = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")

local apt = {}


local MOUNT_NONE     = 0
local MOUNT_BOOT     = 1
local MOUNT_CLOWNCAR = 2
local MOUNT_YOSHI    = 3


local colBox = Colliders.Box(0,0,0,0)


apt.screenShake = 0


-- Convenience functions
local function isOnGround()
    return (
        player:isOnGround()
        or (player.mount == MOUNT_BOOT and player:mem(0x10C,FIELD_BOOL)) -- Hopping in boot
        or player:mem(0x40,FIELD_WORD) > 0                               -- Climbing
        or player.mount == MOUNT_CLOWNCAR
    )
end
local function isOnGroundRedigit() -- isOnGround, except redigit
    return (
        player.speedY == 0
        or player.standingNPC ~= nil
        or player:mem(0x48,FIELD_WORD) > 0 -- On a slope
    )
end
local function getPlayerGravity()
    local gravity = Defines.player_grav
    if player:mem(0x34,FIELD_WORD) > 0 and player:mem(0x06,FIELD_WORD) == 0 then
        gravity = gravity*0.1
    elseif player:mem(0x3A,FIELD_WORD) > 0 then
        gravity = 0
    elseif playerManager.getBaseID(player.character) == CHARACTER_LUIGI then
        gravity = gravity*0.9
    end

    return gravity
end
local function isUnderwater()
    return (
        player:mem(0x36,FIELD_BOOL)          -- In a liquid
        and player:mem(0x06,FIELD_WORD) == 0 -- Not in quicksand
    )
end

-- "Requirement" functions
local function powerupAbilitiesDisabled()
    return (
        player.forcedState > 0 or player.deathTimer > 0 or player:mem(0x13C,FIELD_BOOL) -- In a forced state/dead
        or player:mem(0x40,FIELD_WORD) > 0 -- Climbing
        or player:mem(0x0C,FIELD_BOOL)     -- Fairy
        or player.mount == MOUNT_CLOWNCAR
    )
end
local function canFallSlowly()
    return (
        not powerupAbilitiesDisabled()
        and not isOnGround()
        and not player:mem(0x36,FIELD_BOOL) -- Not in a liquid
        and not player:mem(0x5C,FIELD_BOOL) -- Not ground pounding with a purple yoshi
        and apt.flyingState == nil
    )
end
local function canSpin()
    return (
        not powerupAbilitiesDisabled()
        and not player:mem(0x12E,FIELD_BOOL) -- Ducking
        and not player:mem(0x3C,FIELD_BOOL)  -- Sliding
        and player.character ~= CHARACTER_LINK
        and player.mount == MOUNT_NONE
        and player.holdingNPC == nil
    )
end
local function canBuildPSpeed()
    return (
        not powerupAbilitiesDisabled()
        and not player:mem(0x36,FIELD_BOOL) -- In a liquid
        and player.mount ~= MOUNT_CLOWNCAR
    )
end
local function canFly()
    return (
        canBuildPSpeed()
        and (player.keys.run or player.keys.altRun)
        and not player:mem(0x50,FIELD_BOOL) -- Spin jumping
        and player.mount == MOUNT_NONE
        and player.holdingNPC == nil
    )
end


local function isSlipping()
    return (
        player:mem(0x0A,FIELD_BOOL)                          -- On a slippery block
        and (not player.keys.left and not player.keys.right) -- Slip, sliding away
    )
end

local walkingFrames = {[CHARACTER_MARIO] = table.map{1,2,3,16,17,18},[CHARACTER_LINK] = table.map{1,2,3,4,16,17,18}}
local jumpingFrames = {[CHARACTER_MARIO] = table.map{4,5,19}        ,[CHARACTER_LINK] = table.map{5,3,19}          }
local function isInWalkingAnimation() -- Note: doesn't account for walking while holding an NPC
    local currentFrame = player:getFrame()

    return (
        (walkingFrames[player.character] or walkingFrames[CHARACTER_MARIO])[currentFrame]

        and ((player.forcedState == 0 and player.speedX ~= 0 and not isSlipping()) or player.forcedState == 3)
        and player.deathTimer == 0 and not player:mem(0x13C,FIELD_BOOL) -- Dead
        and not player:mem(0x50,FIELD_BOOL) -- Spin jumping
        and isOnGroundRedigit()

        and player.mount == MOUNT_NONE
    )
end
local function isInJumpingAnimation()
    local currentFrame = player:getFrame()

    return (
        (jumpingFrames[player.character] or jumpingFrames[CHARACTER_MARIO])[currentFrame]

        and player.deathTimer == 0 and not player:mem(0x13C,FIELD_BOOL) -- Dead
        and not isOnGroundRedigit()
        and not isUnderwater()

        and player.forcedState == 0
        and player.mount == MOUNT_NONE
    )
end

local invisibleStates = table.map{5,8,10}
local function canDrawCape()
    return (
        player.deathTimer == 0 and not player:mem(0x13C,FIELD_BOOL) -- Dead
        and not invisibleStates[player.forcedState] -- In a forced state that prevents rendering
        and player.powerup ~= PLAYER_SMALL          -- Small, from the "powering down" animation
        and not player:mem(0x142,FIELD_BOOL)        -- Flashing
        and not player:mem(0x0C,FIELD_BOOL)         -- Fairy
    )
end

-- Cape animation stuff
local findCapeAnimation
do
    apt.capeAnimations = {
        idle        = {1,           isIdle = true},
        idleOnYoshi = {14,          isIdle = true},
        duckOnYoshi = {1,           isIdle = true,priorityDifference = -0.02},

        walk        = {2,3,4,5,     loopPoint = 1},
        fall        = {2,3,6,7,8,9, loopPoint = 3},
        spin        = {10,3,        loopPoint = 1,frameDelay = 2},
        rest        = {10,11},

        frontFacing = {12,          isIdle = true,priorityDifference = -0.01},
        backFacing  = {12,          isIdle = true,priorityDifference =  0.01},

        invisible = {0},
    }

    function apt.setCapeAnimation(name,forceRestart)
        if apt.capeAnimations[name] == nil then
            error("Cape animation '".. tostring(name).. "' does not exist.")
        end


        if name == apt.capeAnimation and not forceRestart then return end
    
        apt.capeAnimation = name
        apt.capeAnimationTimer = 0
        apt.capeAnimationSpeed = 1
    
        apt.capeAnimationFinished = false
    end
    
    apt.setCapeAnimation("idle",true)
    apt.capeFrame = 1


    local frontFrames = table.map{0,15}
    local backFrames = table.map{13,25,26}

    local function isSpinning()
        return (
            player:mem(0x50,FIELD_BOOL) -- Spin jumping
            or apt.spinTimer > 0        -- Spin attack
        )
    end
    local function isInFlight()
        return (
            apt.flyingState ~= nil
            or apt.slidingFromFlight
        )
    end

    local horizontalDirections = table.map{2,4}
    local function isUsingHorizontalPipe()
        local warp = Warp(player:mem(0x15E,FIELD_WORD)-1)

        return (
            player.forcedState == 3
            and (
                (player.forcedTimer == 0 and horizontalDirections[warp:mem(0x80,FIELD_WORD)])
                or (player.forcedTimer == 2 and horizontalDirections[warp:mem(0x82,FIELD_WORD)])
            )
        )
    end

    local function findCapeIdleAnimation()
        local animation = apt.capeAnimations[apt.capeAnimation]

        if (apt.capeAnimation == "rest" and apt.capeAnimationFinished) or (animation.isIdle) then
            if player.mount ~= MOUNT_YOSHI then
                return "idle"
            elseif not player:mem(0x12E,FIELD_BOOL) then
                return "idleOnYoshi"
            else
                return "duckOnYoshi"
            end
        else
            return "rest"
        end
    end

    function findCapeAnimation()
        local playerFrame = player:getFrame()


        if player.mount == MOUNT_CLOWNCAR then
            return findCapeIdleAnimation()
        end


        if (player.speedY > 0 or player:mem(0x1C,FIELD_WORD) > 0) and not isOnGround() and not isInFlight() then
            return "fall"
        end


        if isSpinning() then
            return "spin"
        end


        if isInFlight() then
            return "invisible"
        end


        if player.character ~= CHARACTER_LINK then
            if backFrames[playerFrame] then
                return "backFacing"
            elseif frontFrames[playerFrame] then
                return "frontFacing"
            end
        end


        if (isOnGround() and player.speedX ~= 0 or isUsingHorizontalPipe()) or (apt.ascentTimer ~= nil) then
            return "walk",math.max(0.2,math.abs(player.speedX)/Defines.player_runspeed)
        elseif player.forcedState == 0 and not isOnGround() and isUnderwater() then
            return "walk",0.4
        end


        return findCapeIdleAnimation()
    end
end


local ascentDisableKeys = {"down"}
local flightDisableKeys = {"left","right","down"}

local directionKeys = {[DIR_LEFT] = "left",[DIR_RIGHT] = "right"}


local function getCheatIsActive(name)
    if Cheats == nil or Cheats.get == nil then
        return false
    end

    local cheat = Cheats.get(name)

    return (cheat ~= nil and cheat.active)
end



local function capeHitNPCFilter(npc)
    return (
        Colliders.FILTER_COL_NPC_DEF(npc)
        and npc.despawnTimer > 0
        and npc:mem(0x138,FIELD_WORD) == 0 -- In a forced state
        and npc:mem(0x12C,FIELD_WORD) == 0 -- Being held
        and npc:mem(0x26,FIELD_WORD)  == 0 -- Tail/sword cooldown
    )
end
local function spinAttack()
    colBox.width  = apt.spinAttackSettings.hitboxSize.x
    colBox.height = apt.spinAttackSettings.hitboxSize.y

    colBox.x = player.x+(player.width /2)-(colBox.width /2)
    colBox.y = player.y+(player.height/2)-(colBox.height/2)


    for _,block in ipairs(Colliders.getColliding{a = colBox,btype = Colliders.BLOCK}) do
        block:hit(false,player)
    end
    for _,npc in ipairs(Colliders.getColliding{a = colBox,b = NPC.HITTABLE,btype = Colliders.NPC,filter = capeHitNPCFilter}) do
        local oldProjectileFlag = npc:mem(0x136,FIELD_BOOL)
        local oldSpeed = npc.speedY
        local oldID = npc.id


        npc:harm(HARM_TYPE_TAIL)
        npc:mem(0x26,FIELD_WORD,8) -- Tail invincibility frames

        
        if npc:mem(0x122,FIELD_WORD) > 0 or oldProjectileFlag ~= npc:mem(0x136,FIELD_BOOL) or oldSpeed ~= npc.speedY or oldID ~= npc.id then -- If this NPC got affected
            local effect = Effect.spawn(73,npc.x+(npc.width/2),npc.y+(npc.height/2))

            effect.x = effect.x-(effect.width /2)
            effect.y = effect.y-(effect.height/2)
        end
    end
end


local characterSpeedMultipliers = {
    [CHARACTER_PEACH] = 0.93,
    [CHARACTER_TOAD ] = 1.07,
}
local function getPlayerMaxSpeed()
    return (Defines.player_runspeed*(characterSpeedMultipliers[playerManager.getBaseID(player.character)] or 1))
end

local smwCostumes = table.map{"SMW-MARIO","SMW-LUIGI"}
local function pSpeedRunningAnimation()
    local currentFrame = player:getFrame()


    -- Custom walk cycle stuff
    local isUsingSMWCostume = smwCostumes[player:getCostume()]
    local isLink = (player.character == CHARACTER_LINK)

    if (isUsingSMWCostume or isLink) and isInWalkingAnimation() then
        apt.walkingTimer = (apt.walkingTimer + math.max(1,math.abs(player.speedX)))%45

        local timer = math.floor(apt.walkingTimer)
        if isUsingSMWCostume then
            timer = (45-timer)-1
        end

        currentFrame = math.floor(timer/15)+1
    elseif isLink and isInJumpingAnimation() then
        if player.speedY < 0 then
            currentFrame = 4
        else
            currentFrame = 5
        end
    else
        apt.walkingTimer = 0
    end


    if not isInWalkingAnimation() and not isInJumpingAnimation() then
        return
    end


    local runningFrameIndex = table.ifind(apt.flightSettings.runningFrames,currentFrame)
    local walkingFrameIndex = table.ifind(apt.flightSettings.normalFrames ,currentFrame)



    if apt.usePSpeedFrames then
        if walkingFrameIndex ~= nil then
            player:setFrame(apt.flightSettings.runningFrames[walkingFrameIndex])
        end
    else
        if runningFrameIndex ~= nil then
            player:setFrame(apt.flightSettings.normalFrames[runningFrameIndex])
        elseif walkingFrameIndex ~= nil and isUsingSMWCostume then
            player:setFrame(currentFrame) -- Make sure that its P-speed animations don't happen
        end
    end
end


local function disableLinkJump()
    local baseCharacter = playerManager.getBaseID(player.character)

    if baseCharacter == CHARACTER_LINK and player:mem(0x12E,FIELD_BOOL) then
        local settings = PlayerSettings.get(baseCharacter,player.powerup)

        player.y = player.y+player.height-settings.hitboxHeight
        player.height = settings.hitboxHeight

        player:mem(0x12E,FIELD_BOOL,false)
    end
end


local function diveBombNPCFilter(npc)
    return (
        Colliders.FILTER_COL_NPC_DEF(npc)
        and npc.despawnTimer > 0
        and npc:mem(0x138,FIELD_WORD) == 0 -- In a forced state
        and npc:mem(0x12C,FIELD_WORD) == 0 -- Being held
        and npc.collidesBlockBottom
    )
end
local function flightDiveBomb()
    for _,npc in NPC.iterate() do
        if diveBombNPCFilter(npc) then
            -- Redigit stuff
            local block = Block(0)
            block.y = npc.y+npc.height


            npc:harm(HARM_TYPE_FROMBELOW)
        end
    end

    apt.screenShake = 8
    SFX.play(37)
end



function apt.onInitAPI()
    registerEvent(apt,"onCameraUpdate")
    registerEvent(apt,"onPlayerHarm")
end




local function resetSpinAttack()
    player:mem(0x164,FIELD_WORD,0)
    apt.spinTimer = 0
end
local function resetPSpeed()
    apt.pSpeed = 0
    apt.pSpeedSmokeTimer = 0
    apt.usePSpeedFrames = false
end
local function resetAscent()
    apt.ascentTimer = nil
end
local function resetFlight()
    apt.flyingState = nil
    apt.pullingBack = false
    apt.catchingAirTimer = 0

    apt.highestFlyingState = nil
end

local function resetState()
    resetSpinAttack()
    resetPSpeed()
    resetAscent()
    resetFlight()

    apt.slidingFromFlight = false

    apt.walkingTimer = 0 -- For the SMW-Mario costume and Link

    --apt.poweringUpTimer = nil
end
resetState()



local canSpinJumpCharacters = table.map{CHARACTER_MARIO,CHARACTER_LUIGI,CHARACTER_TOAD}
function apt.onPlayerHarm(eventObj,p)
    if p ~= player or (apt.flyingState == nil or not canFly()) then return end

    player:mem(0x140,FIELD_WORD,150)
    eventObj.cancelled = true

    player:mem(0x50,FIELD_BOOL,canSpinJumpCharacters[player.character])

    resetFlight()

    if apt.flightSettings.hitSFX ~= nil then
        SFX.play(apt.flightSettings.hitSFX)
    end
end



function apt.onEnable(library)
    resetState()

    if player.forcedState == 4 or player.forcedState == 41 then -- Not being instantly enabled
        local effect = Effect.spawn(10,player.x+(player.width/2),player.y+(player.height/2))

        effect.x = effect.x-(effect.width /2)
        effect.y = effect.y-(effect.height/2)


        apt.poweringUpTimer = 0
    end
end

function apt.onDisable(library)
    resetState()
end


function apt.onTick(library)
    -- Make link... actually work
    if player.character == CHARACTER_LINK and (player:mem(0x14,FIELD_WORD) == 0 or player:mem(0x14,FIELD_WORD) < -7) then
        player:mem(0x160,FIELD_WORD,0)
    end


    -- Slow falling
    if canFallSlowly() and (player.keys.jump or player.keys.altJump) then
        player.speedY = math.min(player.speedY,apt.slowFallSettings.speed-getPlayerGravity())
    end

    -- Spin attack
    if canSpin() then
        if player:mem(0x50,FIELD_BOOL) then -- Spin jumping
            resetSpinAttack()
            spinAttack()
        elseif (player.keys.run == KEYS_PRESSED or player.keys.altRun == KEYS_PRESSED) then
            SFX.play(apt.spinAttackSettings.sfx)
            apt.spinTimer = 1

            if apt.flyingState ~= nil then
                player.direction = -player.direction
            end
        end

        if apt.spinTimer > apt.spinAttackSettings.length then
            resetSpinAttack()
        elseif apt.spinTimer > 0 then
            player:mem(0x164,FIELD_WORD,-1)

            apt.spinTimer = apt.spinTimer + 1
            spinAttack()
        end
    else
        resetSpinAttack()
    end

    -- P-Speed
    if canBuildPSpeed() then
        if math.abs(player.speedX) >= getPlayerMaxSpeed() and isOnGround() then
            apt.pSpeed = math.min(apt.flightSettings.neededRunTime,apt.pSpeed + 1)

            apt.usePSpeedFrames = (apt.pSpeed >= apt.flightSettings.neededRunTime)
        else
            apt.pSpeed = math.max(0,apt.pSpeed - 0.5)

            apt.usePSpeedFrames = (apt.usePSpeedFrames and not isOnGround())
        end

        if apt.usePSpeedFrames and isOnGround() then
            apt.pSpeedSmokeTimer = apt.pSpeedSmokeTimer + 1

            if apt.pSpeedSmokeTimer%4 == 0 then
                local effect = Effect.spawn(74,player.x+(player.width/2)-(8*player.direction),player.y+player.height)

                effect.x = effect.x-(effect.width /2)
                effect.y = effect.y-(effect.height/2)
            end
        end
    else
        resetPSpeed()
    end



    -- Ascent
    if canBuildPSpeed() then
        if (apt.pSpeed >= apt.flightSettings.neededRunTime or getCheatIsActive("wingman")) and player:mem(0x11C,FIELD_WORD) > 0 then
            -- Start ascent
            player:mem(0x11C,FIELD_WORD,0) -- Stop the jump force

            apt.ascentTimer = apt.flightSettings.maximumAscentTime
            apt.usePSpeedFrames = true
        end

        if apt.ascentTimer ~= nil then
            apt.ascentTimer = math.max(0,apt.ascentTimer-1)

            -- This isn't exactly accurate to SMW, but it's the best I could do without it feeling like a soggy bag of potatoes. The default numbers are pretty much accurate, though.
            if apt.ascentTimer > 0 and (player.keys.jump or player.keys.altJump) or (apt.flightSettings.maximumAscentTime-apt.ascentTimer) < apt.flightSettings.minimumAscentTime then
                player.speedY = math.max(apt.flightSettings.ascentMaxSpeed,player.speedY+apt.flightSettings.ascentAcceleration)-getPlayerGravity()
            else
                apt.ascentTimer = 0
            end

            if player.speedY > 0 or player:mem(0x14A,FIELD_WORD) > 0 then
                if canFly() then
                    resetFlight()
                    apt.flyingState = 1

                    apt.usePSpeedFrames = false
                end

                resetAscent()
            end


            for _,name in ipairs(ascentDisableKeys) do
                player.keys[name] = false
            end
        end
    else
        resetAscent()
    end

    -- Flight
    if canFly() and not isOnGround() and apt.flyingState ~= nil then
        local holdingForward   = player.keys[directionKeys[ player.direction]]
        local holdingBackwards = player.keys[directionKeys[-player.direction]]

        local stateChangeSpeed = apt.flightSettings.stateChangeSpeed


        if player:mem(0x11C,FIELD_WORD) > 0 then -- Bounced on an enemy or something
            player:mem(0x11C,FIELD_WORD,0) -- Stop the jump force

            apt.pullingBack = true
        end

        player:mem(0x18,FIELD_BOOL,false) -- Stop Peach's hover



        if apt.pullingBack then
            local fromDiveBomb = (apt.highestFlyingState >= 6)

            if fromDiveBomb then
                stateChangeSpeed = -apt.flightSettings.stateChangeSpeedFast
            else
                stateChangeSpeed = -stateChangeSpeed
            end


            if apt.flyingState < 2 then
                apt.flyingState = 1
                apt.pullingBack = false

                if apt.highestFlyingState >= 3 and (player.speedX*player.direction) > 0 then
                    if fromDiveBomb then
                        apt.catchingAirTimer = apt.flightSettings.catchAirTimeLong
                    else
                        apt.catchingAirTimer = apt.flightSettings.catchAirTime
                    end

                    player.speedY = 0

                    SFX.play(apt.flightSettings.catchAirSFX)
                end
            end
        elseif apt.catchingAirTimer > 0 then
            apt.catchingAirTimer = apt.catchingAirTimer - 1

            player.speedY = player.speedY + apt.flightSettings.catchAirSpeed

            stateChangeSpeed = -stateChangeSpeed
        elseif holdingBackwards then
            apt.pullingBack = true

            stateChangeSpeed = 0
        elseif player.speedY < -1 then
            stateChangeSpeed = 0
        elseif holdingForward then
            player.speedX = player.speedX + (apt.flightSettings.acceleration*player.direction)
        else
            stateChangeSpeed = stateChangeSpeed*math.sign(3-apt.flyingState)
        end



        if apt.flyingState == 1 then
            apt.highestFlyingState = 1
        else
            apt.highestFlyingState = math.max(apt.flyingState,apt.highestFlyingState or 1)
        end

        if stateChangeSpeed ~= 0 then
            apt.flyingState = math.clamp(apt.flyingState + (1/stateChangeSpeed),1,6)
        end
        

        local gravity = (apt.flightSettings.gravity*apt.flyingState)
        local terminalVelocity = (apt.flightSettings.maxDownwardsSpeed*apt.flyingState)

        player.speedY = math.clamp(player.speedY-getPlayerGravity()+gravity,apt.flightSettings.maxUpwardsSpeed,terminalVelocity)


        for _,name in ipairs(flightDisableKeys) do
            player.keys[name] = false
        end
        

        --Text.print(apt.flyingState,32,32)
        --Text.print(apt.highestFlyingState,32,64)
        --Text.print(apt.catchingAirTimer,32,96)
    elseif canFly() and apt.flyingState ~= nil then
        if apt.flyingState >= 5 then
            flightDiveBomb()
        else
            player:mem(0x3C,FIELD_BOOL,true)
            apt.slidingFromFlight = true
        end

        player:mem(0x18,FIELD_BOOL,false) -- Give back Peach's hover

        resetFlight()
    else
        resetFlight()
    end


    -- Sliding after flight
    apt.slidingFromFlight = (apt.slidingFromFlight and player:mem(0x3C,FIELD_BOOL))
end


function apt.onTickEnd(library)
    -- Powering up animation
    if apt.poweringUpTimer ~= nil then
        apt.poweringUpTimer = apt.poweringUpTimer + 1

        if player.forcedState == 0 or (apt.poweringUpTimer > 16 and player.powerup ~= PLAYER_BIG) then
            apt.poweringUpTimer = nil
            player.forcedState = 0
            player.forcedTimer = 0
        else
            player:mem(0x142,FIELD_BOOL,true) -- Make the player invisible
        end
    end

    -- Find player frame
    local currentFrame = player:getFrame()

    if canSpin() and apt.spinTimer > 0 then
        local frameIndex = (apt.spinTimer%#apt.spinAttackSettings.frames)+1

        player:setFrame(apt.spinAttackSettings.frames[frameIndex])
    elseif (canFly() and apt.flyingState ~= nil) or (player:mem(0x3C,FIELD_BOOL) and apt.slidingFromFlight) then
        local frameIndex = 1

        if apt.flyingState ~= nil then
            frameIndex = math.floor(apt.flyingState)
        elseif apt.slidingFromFlight then
            local slopeBlock = Block(player:mem(0x48,FIELD_WORD))
            if slopeBlock.idx == 0 or not slopeBlock.isValid then
                slopeBlock = nil
            end


            if slopeBlock ~= nil then
                local config = Block.config[slopeBlock.id]
                local againstPlayer = (player.direction ~= config.floorslope)


                frameIndex = math.floor(slopeBlock.width/slopeBlock.height)

                if not againstPlayer then
                    frameIndex = #apt.flightSettings.frames-frameIndex
                end
            elseif isOnGround() then
                frameIndex = 3
            elseif player.speedY < 0 then
                frameIndex = 1
            else
                frameIndex = 2
            end
        end


        frameIndex = math.clamp(frameIndex,1,#apt.flightSettings.frames)

        player:setFrame(apt.flightSettings.frames[frameIndex])
    else
        -- P-Speed frames
        pSpeedRunningAnimation()
    end

    -- Janky, janky, here comes the redigit
    if apt.usePSpeedFrames or apt.flyingState ~= nil then
        disableLinkJump()
    end

    
    -- Find the cape's animation
    local name,speed = findCapeAnimation()

    if name ~= nil then
        apt.setCapeAnimation(name)
    end
    apt.capeAnimationSpeed = speed or apt.capeAnimationSpeed


    -- Actually handle the animation
    local animation = apt.capeAnimations[apt.capeAnimation]
    local frameIndex = math.floor(apt.capeAnimationTimer/(animation.frameDelay or 4))+1

    apt.capeAnimationTimer = apt.capeAnimationTimer + apt.capeAnimationSpeed

    if frameIndex > #animation then -- Finished the animation
        if animation.loopPoint ~= nil then
            local loopingFrames = (#animation-animation.loopPoint)+1

            frameIndex = (frameIndex%loopingFrames)+animation.loopPoint
        else
            apt.capeAnimationFinished = true
            frameIndex = #animation
        end
    end

    apt.capeFrame = animation[frameIndex]
end


-- Drawing
do
    local capeImageSize = 100

    local capeBuffer = Graphics.CaptureBuffer(capeImageSize,capeImageSize)


    local starmanShader = Shader()
    starmanShader:compileFromFile(nil,Misc.multiResolveFile("starman.frag","shaders/npc/starman.frag"))


    local function round(value)
        if value%1 < 0.5 then
            return math.floor(value)
        else
            return math.ceil(value)
        end
    end

    local clownCarOffsets = {
        [CHARACTER_MARIO] = {[PLAYER_SMALL] = 24,[PLAYER_BIG] = 36},
        [CHARACTER_LUIGI] = {[PLAYER_SMALL] = 24,[PLAYER_BIG] = 38},
        [CHARACTER_PEACH] = {[PLAYER_SMALL] = 24,[PLAYER_BIG] = 30},
        [CHARACTER_TOAD]  = {[PLAYER_SMALL] = 24,[PLAYER_BIG] = 30},
        [CHARACTER_LINK]  = {[PLAYER_SMALL] = 30,[PLAYER_BIG] = 30},
    }
    local characterOffsets = {
        [CHARACTER_PEACH] = -4,
        [CHARACTER_LINK]  = -8,
    }

    local function getPosition()
        local baseCharacter = playerManager.getBaseID(player.character)

        local settings = PlayerSettings.get(baseCharacter,player.powerup)
        local animation = apt.capeAnimations[apt.capeAnimation]

        local position = vector(player.x+(player.width/2),player.y+player.height)

        if player.mount == MOUNT_CLOWNCAR then
            local clownCarOffset = clownCarOffsets[baseCharacter]
            clownCarOffset = clownCarOffset[player.powerup] or clownCarOffset[PLAYER_BIG]

            position.y = player.y-clownCarOffset+settings.hitboxHeight
        elseif player.mount == MOUNT_YOSHI then
            position.x = position.x - (4*player.direction)

            position.y = position.y + player:mem(0x10E,FIELD_WORD) + 2
            position.y = position.y-player.height+settings.hitboxHeight
        end

        if not animation.isIdle then
            position.y = position.y+(characterOffsets[player.character] or 0)
        end


        position.y = position.y-(capeImageSize/2)+32

        position = vector(round(position.x),round(position.y))


        return position
    end

    local function getCapePriority()
        local animation = apt.capeAnimations[apt.capeAnimation]

        local priority = -25
        if player.forcedState == 3 then
            priority = -70
        elseif player.mount == MOUNT_CLOWNCAR then
            priority = -35
        end

        priority = priority+(animation.priorityDifference or -0.01)
        if player.mount == MOUNT_YOSHI then
            priority = priority+0.01
        end

        return priority
    end


    local function drawCape(spritesheets,position,priority,sceneCoords,target)
        local texture = spritesheets[player.character] or spritesheets[CHARACTER_MARIO]

        if texture == nil then return end


        if apt.sprite == nil or apt.sprite.texture ~= texture then
            apt.sprite = Sprite{texture = texture,frames = texture.height/capeImageSize,pivot = vector(0.5,0.5)}
        end


        local direction = player.direction
        if player:getFrame() < 0 then
            direction = -direction
        end

        local shader,uniforms
        local color = Color.white
        if player.hasStarman then
            shader = starmanShader
            uniforms = {time = lunatime.tick()*2}
        elseif Defines.cheat_shadowmario then
            color = Color.black
        end

        

        --local position = getPosition()
        --position = vector(round(position.x),round(position.y))


        apt.sprite.texpivot = vector((-direction+1)*0.5,0)
        apt.sprite.width = texture.width*direction

        apt.sprite.position = position or getPosition()

        apt.sprite:draw{
            frame = apt.capeFrame or 1,
            color = color,shader = shader,uniforms = uniforms,
            priority = priority or getCapePriority(),sceneCoords = (sceneCoords ~= false),target = target,
        }
    end

    apt.drawCape = drawCape -- why not, I guess


    local pipeCutoffRules = {}

    -- Moving up on entrance/moving down on exit
    pipeCutoffRules[1] = (function(position,sourcePosition,sourceSize,warpPosition,warpSize)
        sourcePosition.y = math.max(0,warpPosition.y-position.y)
        sourceSize.y = (sourceSize.y - sourcePosition.y)

        position.y = math.max(position.y,warpPosition.y)

        return position,sourcePosition,sourceSize
    end)

    -- Moving left on entrance/moving right on exit
    pipeCutoffRules[2] = (function(position,sourcePosition,sourceSize,warpPosition,warpSize)
        sourcePosition.x = math.max(0,warpPosition.x-position.x)
        position.x = math.max(position.x,warpPosition.x)

        return position,sourcePosition,sourceSize
    end)

    -- Moving down on entrance/moving up on exit
    pipeCutoffRules[3] = (function(position,sourcePosition,sourceSize,warpPosition,warpSize)
        sourceSize.y = math.max(0,(warpPosition.y+warpSize.y)-position.y)

        return position,sourcePosition,sourceSize
    end)

    -- Moving right on entrance/moving left on exit
    pipeCutoffRules[4] = (function(position,sourcePosition,sourceSize,warpPosition,warpSize)
        sourceSize.x = math.max(0,(warpPosition.x+warpSize.x)-position.x)

        return position,sourcePosition,sourceSize
    end)


    function apt.onDraw(library)
        if not canDrawCape() or (apt.capeFrame ~= nil and apt.capeFrame < 1) then return end
        

        local bufferSize = vector(capeBuffer.width,capeBuffer.height)

        -- First, draw the cape to a buffer
        capeBuffer:clear(-100)

        drawCape(library.capeSpritesheets,bufferSize/2,-100,false,capeBuffer)

        -- Then draw that to the screen (but cut off if going through a pipe)
        local position = getPosition()-(bufferSize/2)
        local priority = getCapePriority()

        local sourcePosition = vector.zero2
        local sourceSize = vector(capeBuffer.width,capeBuffer.height)


        if player.forcedState == 3 then
            local warp = Warp(player:mem(0x15E,FIELD_WORD)-1)

            if player.forcedTimer == 0 then
                local warpPosition = vector(warp.entranceX    ,warp.entranceY     )
                local warpSize     = vector(warp.entranceWidth,warp.entranceHeight)

                position,sourcePosition,sourceSize = pipeCutoffRules[warp:mem(0x80,FIELD_WORD)](position,sourcePosition,sourceSize,warpPosition,warpSize)
            elseif player.forcedTimer == 2 then
                local warpPosition = vector(warp.exitX    ,warp.exitY     )
                local warpSize     = vector(warp.exitWidth,warp.exitHeight)

                position,sourcePosition,sourceSize = pipeCutoffRules[warp:mem(0x82,FIELD_WORD)](position,sourcePosition,sourceSize,warpPosition,warpSize)
            elseif player.forcedTimer == 1 or player.forcedTimer >= 100 then
                sourceSize = vector.zero2
            end            
        end

        
        local x1 = ((sourcePosition.x             )/capeBuffer.width )
        local x2 = ((sourcePosition.x+sourceSize.x)/capeBuffer.width )
        local y1 = ((sourcePosition.y             )/capeBuffer.height)
        local y2 = ((sourcePosition.y+sourceSize.y)/capeBuffer.height)

        Graphics.drawBox{
            texture = capeBuffer,priority = priority,sceneCoords = true,
            x = position.x,y = position.y,width = sourceSize.x,height = sourceSize.y,
            textureCoords = {
                x1,y1,
                x2,y1,
                x2,y2,
                x1,y2,
            },
        }
    end
end


-- Camera stuff
do
    apt.cameraY = nil
    apt.cameraMovementStartSection = nil


    function apt.onCameraUpdate()
        if apt.cameraMovementStartSection ~= nil and apt.cameraMovementStartSection ~= player.section then
            -- Stop the custom camera stuff if the player changed sections
            apt.cameraY = nil
            apt.cameraMovementStartSection = nil
        elseif apt.flyingState ~= nil and not apt.flightSettings.normalFlyingCamera then
            -- Stop the camera from going higher during flight
            if apt.cameraY == nil then
                apt.cameraY = camera.y
                apt.cameraMovementStartSection = player.section
            end

            apt.cameraY = math.max(apt.cameraY,player.y+player.height-(camera.height/2))
        elseif apt.cameraY ~= nil then
            -- Return the camera to its normal position
            local distance = (camera.y-apt.cameraY)

            apt.cameraY = apt.cameraY+(math.sign(distance)*math.min(math.abs(distance),12))

            if apt.cameraY == camera.y then
                apt.cameraY = nil
                apt.cameraMovementStartSection = nil
            end
        end


        if apt.cameraY ~= nil then
            local bounds = player.sectionObj.boundary
            apt.cameraY = math.clamp(apt.cameraY,bounds.top,bounds.bottom-camera.height)

            camera.y = apt.cameraY
        end



        -- Custom screenshake effect
        if apt.screenShake > 0 then
            apt.screenShake = apt.screenShake - 1

            camera.renderY = (apt.screenShake*((math.sign(apt.screenShake%2)*2)-1))
        end
    end
end


do
    local function dropItem(id)
        if isOverworld then return end

        if Graphics.getHUDType(player.character) == Graphics.HUD_ITEMBOX then
            player.reservePowerup = id
        else
            local config = NPC.config[id]
            local npc = NPC.spawn(id,camera.x+(camera.width/2)-(config.width/2),camera.y+32,player.section)

            npc:mem(0x138,FIELD_WORD,2)
        end
    end

    function apt.register(library)
        -- Cheats
        if library.cheats ~= nil and Cheats ~= nil and Cheats.register ~= nil then
            local aliases = table.iclone(library.cheats)
            table.remove(aliases,1)

            Cheats.register(library.cheats[1],{
                onActivate = (function() 
                    dropItem(library.items[1])
                    return true
                end),
                activateSFX = 12,
                aliases = aliases,
            })
        end
    end
end

-- Tools
--[[do
    function _G.convertSMWFrameCount(value)
        return (value/60)*Misc.GetEngineTPS()
    end
    function _G.convertSMWSpeed(value,accountForDoubleSize,accountForFramerate)
        if accountForDoubleSize == nil then
            accountForDoubleSize = true
        end
        if accountForFramerate == nil then
            accountForFramerate = true
        end


        local inHex = bit.tohex(value)
        --inHex = inHex:sub(inHex:find("[^0]"),#inHex)
        inHex = inHex:sub(5,#inHex)

        local blocks       = tonumber("0x".. inHex:sub(1,1))
        local pixels       = tonumber("0x".. inHex:sub(2,2))
        local subpixels    = tonumber("0x".. inHex:sub(3,3))
        local subsubpixels = tonumber("0x".. inHex:sub(4,4))

        local final = (blocks*16)+(pixels)+(subpixels/16)+(subsubpixels/256)

        if accountForDoubleSize then
            final = final*2
        end
        if accountForFramerate then
            final = (final/Misc.GetEngineTPS())*60
        end


        return final
    end
end]]



-- SETTINGS

apt.slowFallSettings = {
    -- How fast the player falls when holding jump.
    speed = 1.872,
}

apt.spinAttackSettings = {
    -- The series of frames used when doing a spin attack. Note that this will loop until the attack is over.
    frames = {1,1,15,-15,-1,-1,-13,13},
    -- How many frames it takes to complete a full spin attack.
    length = 18,
    -- The width/height of the spin attack's hitbox.
    hitboxSize = vector(72,24),

    -- The sound effect played when using the spin attack.
    sfx = 33,
}

apt.flightSettings = {
    -- How long the player needs to run at full speed in order to get P-Speed.
    neededRunTime = 56,
    
    -- The frames used when running with and without P-Speed. The frames go: walking 1, walking 2, walking 3, jumping, and falling.
    runningFrames = {16,17,18,19,19},
    normalFrames  = {1 ,2 ,3 ,4 ,5 },

    -- The longest and shortest times that the player can ascend for.
    maximumAscentTime = 84,
    minimumAscentTime = 16,

    -- How fast the player accelerates upwards while ascending.
    ascentAcceleration = -0.351,
    -- The maximum speed the player will move up at while ascending.
    ascentMaxSpeed = -6.552,



    -- How much gravity the player feels while flying. Note that this is multiplied by the current 'flying state'.
    gravity = 0.117,
    -- The maximum downwards Y speed when flying. Note that this is also affected by the current 'flying state'.
    maxDownwardsSpeed = 1.872,
    -- The maximum upwards Y speed when flying.
    maxUpwardsSpeed = -6.552,

    -- How quickly the player accelerates when flying and holding forwards.
    acceleration = 0.47,

    -- How quickly the player changes between states/sprites.
    stateChangeSpeed = 8,
    stateChangeSpeedFast = 2,

    -- The speed that the player gets when "catching air".
    catchAirSpeed = -1.404,
    -- How long the player will be catching air for after pulling back.
    catchAirTime = 3,
    catchAirTimeLong = 8,


    -- The frames used when flying.
    frames = {37,38,39,47,48,49},
    -- The sound played when catching air.
    catchAirSFX = smasExtraSounds.sounds[134].sfx,


    -- The sound played when hit while flying.
    hitSFX = 35,

    -- If true, the camera will not be restricted when flying.
    normalFlyingCamera = false,
}


return apt