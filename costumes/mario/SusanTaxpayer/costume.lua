local playerManager = require("playerManager")
local smasFunctions = require("smasFunctions")
local smasExtraSounds = require("smasExtraSounds")

local costume = {}

local plr


costume.pSpeedAnimationsEnabled = true
costume.yoshiHitAnimationEnabled = true
costume.kickAnimationEnabled = true

Defines.player_runspeed = 6
Defines.player_walkspeed = 4
Defines.jumpheight = 16


costume.hammerID = 171
costume.hammerConfig = {
	gfxwidth = 32,
	gfxheight = 32,
	frames = 8,
	framespeed = 4,
	framestyle = 1,
}


local eventsRegistered = false


local characterSpeedModifiers = {
	[CHARACTER_PEACH] = 0.93,
	[CHARACTER_TOAD]  = 1.07,
}
local characterNeededPSpeeds = {
	[CHARACTER_MARIO] = 40,
	[CHARACTER_LUIGI] = 40,
	[CHARACTER_PEACH] = 80,
	[CHARACTER_TOAD]  = 40,
    [CHARACTER_WARIO] = 135,
}
local characterDeathEffects = {
	[CHARACTER_MARIO] = 3,
	[CHARACTER_LUIGI] = 5,
	[CHARACTER_PEACH] = 129,
	[CHARACTER_TOAD]  = 130,
    [CHARACTER_WARIO] = 150,
}

local deathEffectFrames = 8

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

local function getWalkAnimationSpeed(p)
    return math.max(0.35,math.abs(p.speedX)/Defines.player_walkspeed)
end

local animationSet = {
    idle = {1, defaultFrameX = 1},
    lookUp = {11, defaultFrameX = 1},
    walk = {2,3,4,5,6,7,8,9,10, defaultFrameX = 1, frameDelay = 3},
    jump = {1, defaultFrameX = 2,loops = false},
    fall = {2, defaultFrameX = 2},
    
    run = {1,2,3,4,5, defaultFrameX = 3, frameDelay = 3},

    holdingIdle = {1, defaultFrameX = 4},
    holdingWalk = {2,3,4,5,6,7,8,9, defaultFrameX = 4,frameDelay = 3},
    holdingJump = {8, defaultFrameX = 4},
    holdingFall = {9, defaultFrameX = 4},

    duck = {1, defaultFrameX = 5},
    slide = {12, defaultFrameX = 5},
    pluck = {3,4,5, defaultFrameX = 5,frameDelay = 4},

    front = {7, defaultFrameX = 5},
    back = {9, defaultFrameX = 5},
    
    spinJump = {6,7,8,9, defaultFrameX = 5,frameDelay = 4},

    climb = {10,11, defaultFrameX = 5,frameDelay = 8},

    skid = {2, defaultFrameX = 5},

    swimIdle = {1,2, defaultFrameX = 6},
    swimStroke = {3,4,3, defaultFrameX = 6,frameDelay = 4,loops = false},

    yoshi = {1, defaultFrameX = 7},
    yoshiDuck = {2, defaultFrameX = 7},
}

-- This function returns the name of the custom animation currently playing.
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
        return "spinJump"
        --[[if p:mem(0x52,FIELD_WORD) < 3 then
            return "idle"
        elseif p:mem(0x52,FIELD_WORD) < 6 then
            return "back"
        elseif p:mem(0x52,FIELD_WORD) < 9 then
            return "idle"
        else
            return "front"
        end]]
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
            if p.speedX < 5 and p.speedX > -5 then
                return "walk",getWalkAnimationSpeed(p)
            else
                return "run",getWalkAnimationSpeed(p)
            end
        end
        
        --Looking up
        if p.keys.up then
            return "lookUp"
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
    
    registerEvent(costume,"onDraw")
    
    animationPal.registerCharacter(CHARACTER_MARIO,{
        findAnimationFunc = findAnimation,
        animationSet = animationSet,

        imageDirection = DIR_RIGHT,
        frameWidth = 100,
        frameHeight = 100,

        offset = vector(0,17),
        scale = vector(1,1),

        imagePathFormat = "costumes/mario/SusanTaxpayer/mario-%d.png",
    })
    
    smasCharacterHealthSystem.enabled = true --Only for heart-related Mario/Luigi characters!
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    animationPal.deregisterCharacter(CHARACTER_MARIO)
    smasCharacterHealthSystem.enabled = false --Only for heart-related Mario/Luigi characters!
end

costume.heldNPCTimer = 0
costume.heldNPCX = 0
costume.heldNPCY = 0

function costume.onDraw()
    player.powerup = 2 --For now, until we get the other states done, this'll do for now
    
    
    if player.holdingNPC ~= nil and player.holdingNPC.isValid then
        local settings = PlayerSettings.get(playerManager.getBaseID(player.character),player.powerup)
        
        local heldNPCY = (player.y + player.height - player.holdingNPC.height) - 46
        local heldNPCX

        if player.direction == DIR_RIGHT then
            heldNPCX = player.x + settings.grabOffsetX + 12
        else
            heldNPCX = player.x + player.width - settings.grabOffsetX - player.holdingNPC.width - 12
        end
        
        setHeldNPCPosition(player,heldNPCX,heldNPCY)
    else
        costume.heldNPCTimer = 0
    end
    
	-- Change death effects
    local deathEffectID = characterDeathEffects[CHARACTER_MARIO]

    for _,e in ipairs(Effect.get(deathEffectID)) do
        e.animationFrame = -999

        local image = Graphics.sprites.effect[e.id].img

        local width = image.width
        local height = image.height / deathEffectFrames

        local frame = math.floor((150 - e.timer) / 8) % deathEffectFrames

        Graphics.drawImageToSceneWP(image, e.x + e.width*0.5 - width*0.5,e.y + e.height*0.5 - height*0.5, 0,frame*height, width,height, -5)
    end
end

Misc.storeLatestCostumeData(costume)

return costume