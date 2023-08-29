local playerManager = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasFunctions = require("smasFunctions")

local animationPal = require("animationPal")

local costume = {}

local plr

costume.loaded = false

local animationSet = {
    idle = {1, defaultFrameX = 1},
    walk = {2,3, defaultFrameX = 1,frameDelay = 4},
    jump = {1,2, defaultFrameX = 2,loops = false},
    fall = {1, defaultFrameX = 2},

    holdingIdle = {1, defaultFrameX = 3},
    holdingWalk = {2,3, defaultFrameX = 3,frameDelay = 6},
    holdingJump = {1,2, defaultFrameX = 4,loops = false},
    holdingFall = {1, defaultFrameX = 4},

    duck = {1, defaultFrameX = 5},
    slide = {2, defaultFrameX = 5},
    pluck = {3,4, defaultFrameX = 5,frameDelay = 6,loops = false},

    front = {1, defaultFrameX = 6},
    back = {2, defaultFrameX = 6},

    climb = {1,2, defaultFrameX = 7,frameDelay = 8},

    skid = {1, defaultFrameX = 8},

    swimIdle = {1, defaultFrameX = 9},
    swimStroke = {2,3,2, defaultFrameX = 9,frameDelay = 4,loops = false},

    yoshi = {1, defaultFrameX = 10},
    yoshiDuck = {2, defaultFrameX = 10},
}


local function getWalkAnimationSpeed(p)
    return math.max(0.35,math.abs(p.speedX)/Defines.player_walkspeed)
end

local function findAnimation(p,animator)
    -- Mounts
    if p.mount == MOUNT_YOSHI then
        -- Yoshi
        if p:mem(0x12E,FIELD_BOOL) then -- ducking
            return "yoshiDuck"
        end

        return "yoshi"
    elseif p.mount ~= MOUNT_NONE then
        -- Boot / clown car
        return "idle"
    end


    -- Pipes
    if p.forcedState == FORCEDSTATE_PIPE then
        local direction = animationPal.utils.getPipeDirection(p)

        if direction == 2 or direction == 4 then
            -- Sideways pipe
			return "walk",0.5
        else
            -- Vertical pipe
            return "front"
		end
    end

    -- Doors
    if p.forcedState == FORCEDSTATE_DOOR then
        return "back"
    end

    -- Other forced states
    if p.forcedState ~= FORCEDSTATE_NONE then
        return "idle"
    end


    -- Climbing
    if p.climbing then
        local speedX,speedY = animationPal.utils.getClimbingSpeed(p)

        if speedX ~= 0 or speedY < -0.1 then
            return "climb",1
        else
            return "climb",0
        end
    end

    -- Holding something
    if p.holdingNPC ~= nil then
        if not animationPal.utils.isOnGroundAnimation(p) then -- in the air/swimming
            if p.speedY < 0 then -- rising
                return "holdingJump"
            else -- falling
                return "holdingFall"
            end
        end

        -- Walking
        if p.speedX ~= 0 and not animationPal.utils.isSlidingOnIce(p) then
            return "holdingWalk"
        end

        return "holdingIdle"
    end


    -- Spin jumping
    if p:mem(0x50,FIELD_BOOL) or p:mem(0x4A,FIELD_BOOL) then
        if p:mem(0x52,FIELD_WORD) < 3 then
            return "idle"
        elseif p:mem(0x52,FIELD_WORD) < 6 then
            return "back"
        elseif p:mem(0x52,FIELD_WORD) < 9 then
            return "idle"
        else
            return "front"
        end
    end


    if p:mem(0x26,FIELD_WORD) > 0 then -- plucking something from the ground
        return "pluck"
    elseif p:mem(0x12E,FIELD_BOOL) then -- ducking
        return "duck"
    end

    if p:mem(0x3C,FIELD_BOOL) then -- sliding
        return "slide"
    end


    if animationPal.utils.isOnGroundAnimation(p) then
        -- GROUNDED ANIMATIONS --

        -- Skidding
        if animationPal.utils.isSkidding(p) then
            return "skid"
        end

        -- Walking
        if p.speedX ~= 0 and not animationPal.utils.isSlidingOnIce(p) then
            return "walk"
        end

        return "idle"
    elseif p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0 then
        -- WATER ANIMATIONS --

        if p:mem(0x38,FIELD_WORD) == 15 then
            return "swimStroke",1,true
        end

        if animator.currentAnimation == "swimStroke" and not animator.animationFinished then
            return "swimStroke"
        end

        return "swimIdle"
    else
        -- AIR ANIMATIONS --

        if p.speedY < 0 then -- rising
            return "jump"
        else -- falling
            return "fall"
        end
    end
end

function costume.onInit(p)
    plr = p
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    animationPal.registerCharacter(CHARACTER_TOAD,{
        findAnimationFunc = findAnimation,
        animationSet = animationSet,

        imageDirection = DIR_RIGHT,
        frameWidth = 50,
        frameHeight = 50,

        offset = vector(0,3),
        scale = vector(2,2),

        imagePathFormat = "costumes/toad/SophiaTheThird/sophiaTheThird.png",
    })
    
    --smasCharacterHealthSystem.enabled = true --Only for heart-related Mario/Luigi characters!
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    animationPal.deregisterCharacter(CHARACTER_TOAD)
    --smasCharacterHealthSystem.enabled = false --Only for heart-related Mario/Luigi characters!
end

Misc.storeLatestCostumeData(costume)

return costume