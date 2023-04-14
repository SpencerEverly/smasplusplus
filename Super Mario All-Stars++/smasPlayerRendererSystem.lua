local smasPlayerRendererSystem = {}

local playerManager = require("playerManager")

function smasPlayerRendererSystem.onInitAPI()
    registerEvent(smasPlayerRendererSystem,"onDraw")
end

smasPlayerRendererSystem.playerSettings = player:getCurrentPlayerSetting()
smasPlayerRendererSystem.frameBoxMax = 100
smasPlayerRendererSystem.currentCharacterImages = {}
smasPlayerRendererSystem.currentCharacterImages[player.idx] = {}

smasPlayerRendererSystem.frame = 1
smasPlayerRendererSystem.frameSpeed = 6
smasPlayerRendererSystem.priority = -25
smasPlayerRendererSystem.pipePrioirity = -70

smasPlayerRendererSystem.dimensions = {
    width = 1000,
    height = 1000,
    totalFrames = 100,
}

smasPlayerRendererSystem.animationsSmall = {
    standing = {1},
    walking = {1,2},
    jumping = {3},
    skidding = {4},
    holding = {5},
    holdWalking = {5,6},
    front = {13},
    back = {15},
    spinJump = {1,13,-1,15},
    slide = {24},
    climb = {25,26},
    grabbing = {22,23},
    yoshiRide = {30},
    idleSwim = {40,41},
    swimming = {41,42,43,42},
    yoshiRideDuck = {31},
}

smasPlayerRendererSystem.animationsBig = {
    standing = {1},
    walking = {1,2,3,2},
    jumping = {4},
    falling = {5},
    skidding = {6},
    ducking = {7},
    holding = {8},
    holdWalking = {8,9,10,9},
    front = {13},
    back = {15},
    spinJump = {1,13,-1,15},
    slide = {24},
    climb = {25,26},
    grabbing = {22,23},
    yoshiRide = {30},
    idleSwim = {40,41,42,41},
    swimming = {42,43,44,43},
    yoshiRideDuck = {31},
    fireball = {11,12,11},
    leafSlowFall = {5,3,11,3},
    leafRun = {16,17,18,17},
    leafFly = {19,20,21,20},
    leafFlyJump = {19},
    statue = {0},
}

for i = 1,7 do
    smasPlayerRendererSystem.currentCharacterImages[player.idx][i] = Img.loadCharacter(playerManager.getName(player.character).."-"..tostring(i)..".png")
end

function smasPlayerRendererSystem.convertPlayerFrameX(f, direction)
	direction = direction or 1
	if(direction > 0) then
		return math.floor((f-1)/10)+5
	else
		return 4-math.floor((f)/10)
	end
end

function smasPlayerRendererSystem.convertPlayerFrameY(f, direction)
	direction = direction or 1
	if(direction > 0) then
		return (f-1)%10
	else
		return 9-(f)%10
	end
end

function smasPlayerRendererSystem.getPlayerHitboxWidth()
    return player:getCurrentPlayerSetting().hitboxWidth
end

function smasPlayerRendererSystem.getPlayerHitboxHeight()
    return player:getCurrentPlayerSetting().hitboxHeight
end

function smasPlayerRendererSystem.getPlayerHitboxDuckHeight()
    return player:getCurrentPlayerSetting().hitboxDuckHeight
end

function smasPlayerRendererSystem.getPlayerGrabOffsetX()
    return player:getCurrentPlayerSetting().grabOffsetX
end

function smasPlayerRendererSystem.getPlayerGrabOffsetY()
    return player:getCurrentPlayerSetting().grabOffsetY
end

function smasPlayerRendererSystem.getPlayerSpriteOffsetX(frame, direction)
    local a, b = Player.convertFrame(frame, direction)
    return player:getCurrentPlayerSetting():getSpriteOffsetX(a, b)
end

function smasPlayerRendererSystem.getPlayerSpriteOffsetY(frame, direction)
    local a, b = Player.convertFrame(frame, direction)
    return player:getCurrentPlayerSetting():getSpriteOffsetY(a, b)
end

function smasPlayerRendererSystem.getPlayerHitboxHeightWithDucking(plr)
    if plr:mem(0x12E, FIELD_BOOL) then
        return smasPlayerRendererSystem.getPlayerHitboxDuckHeight()
    else
        return smasPlayerRendererSystem.getPlayerHitboxHeight()
    end
end

function smasPlayerRendererSystem.getPlayerPriority()
    if player.forcedState == FORCEDSTATE_PIPE then
        return smasPlayerRendererSystem.pipePriority
    else
        return smasPlayerRendererSystem.priority
    end
end

function smasPlayerRendererSystem.getAnimation()
    if player.character >= 1 and player.character <= 2 then
        if player.powerup == 1 then
            if Playur.findAnimation(player) == "stance" then
                return smasPlayerRendererSystem.animationsSmall.standing
            elseif Playur.findAnimation(player) == "walkSmall" then
                return smasPlayerRendererSystem.animationsSmall.walking
            elseif Playur.findAnimation(player) == "runSmall" then
                return smasPlayerRendererSystem.animationsSmall.walking
            elseif Playur.findAnimation(player) == "holding" then
                return smasPlayerRendererSystem.animationsSmall.holding
            elseif Playur.findAnimation(player) == "walkHolding" or Playur.findAnimation(player) == "runHolding" then
                return smasPlayerRendererSystem.animationsSmall.holdWalking
            elseif Playur.findAnimation(player) == "jump" then
                return smasPlayerRendererSystem.animationsSmall.jumping
            elseif Playur.findAnimation(player) == "runJump" then
                return smasPlayerRendererSystem.animationsSmall.jumping
            elseif Playur.findAnimation(player) == "fall" then
                return smasPlayerRendererSystem.animationsSmall.jumping
            elseif Playur.findAnimation(player) == "skidding" then
                return smasPlayerRendererSystem.animationsSmall.skidding
            elseif Playur.findAnimation(player) == "lookUp" then
                return smasPlayerRendererSystem.animationsSmall.standing
            elseif Playur.findAnimation(player) == "lookUpHolding" then
                return smasPlayerRendererSystem.animationsSmall.holding
            elseif Playur.findAnimation(player) == "warpUp" or Playur.findAnimation(player) == "warpDown" then
                return smasPlayerRendererSystem.animationsSmall.front
            elseif Playur.findAnimation(player) == "mountedOnYoshi" then
                return smasPlayerRendererSystem.animationsSmall.yoshiRide
            elseif Playur.findAnimation(player) == "spinJump" then
                return smasPlayerRendererSystem.animationsSmall.spinJump
            elseif Playur.findAnimation(player) == "climbing" then
                return smasPlayerRendererSystem.animationsSmall.climb
            elseif Playur.findAnimation(player) == "sliding" then
                return smasPlayerRendererSystem.animationsSmall.slide
            elseif Playur.findAnimation(player) == "grabFromTop" then
                return smasPlayerRendererSystem.animationsSmall.grabbing
            elseif Playur.findAnimation(player) == "door" then
                return smasPlayerRendererSystem.animationsSmall.back
            elseif Playur.findAnimation(player) == "swimIdle" then
                return smasPlayerRendererSystem.animationsSmall.idleSwim
            elseif Playur.findAnimation(player) == "swimStroke" or Playur.findAnimation(player) == "swimStrokeSmall" then
                return smasPlayerRendererSystem.animationsSmall.swimming
            else
                return smasPlayerRendererSystem.animationsSmall.standing
            end
        else
            if Playur.findAnimation(player) == "stance" then
                return smasPlayerRendererSystem.animationsBig.standing
            elseif Playur.findAnimation(player) == "walk" then
                return smasPlayerRendererSystem.animationsBig.walking
            elseif Playur.findAnimation(player) == "run" then
                if player.powerup == 4 or player.powerup == 5 then
                    return smasPlayerRendererSystem.animationsBig.leafRun
                else
                    return smasPlayerRendererSystem.animationsBig.walking
                end
            elseif Playur.findAnimation(player) == "holding" then
                return smasPlayerRendererSystem.animationsBig.holding
            elseif Playur.findAnimation(player) == "walkHolding" or Playur.findAnimation(player) == "runHolding" then
                return smasPlayerRendererSystem.animationsBig.holdWalking
            elseif Playur.findAnimation(player) == "jump" then
                return smasPlayerRendererSystem.animationsBig.jumping
            elseif Playur.findAnimation(player) == "runJump" then
                if player.powerup == 4 or player.powerup == 5 then
                    return smasPlayerRendererSystem.animationsBig.leafFlyJump
                else
                    return smasPlayerRendererSystem.animationsBig.jumping
                end
            elseif Playur.findAnimation(player) == "fall" then
                return smasPlayerRendererSystem.animationsBig.falling
            elseif Playur.findAnimation(player) == "skidding" then
                return smasPlayerRendererSystem.animationsBig.skidding
            elseif Playur.findAnimation(player) == "lookUp" then
                return smasPlayerRendererSystem.animationsBig.standing
            elseif Playur.findAnimation(player) == "lookUpHolding" then
                return smasPlayerRendererSystem.animationsBig.holding
            elseif Playur.findAnimation(player) == "warpUp" or Playur.findAnimation(player) == "warpDown" then
                return smasPlayerRendererSystem.animationsBig.front
            elseif Playur.findAnimation(player) == "mountedOnYoshi" then
                return smasPlayerRendererSystem.animationsBig.yoshiRide
            elseif Playur.findAnimation(player) == "tailAttack" or Playur.findAnimation(player) == "spinJump" or Playur.findAnimation(player) == "spinjumpSidwaysToad" then
                return smasPlayerRendererSystem.animationsBig.spinJump
            elseif Playur.findAnimation(player) == "climbing" then
                return smasPlayerRendererSystem.animationsBig.climb
            elseif Playur.findAnimation(player) == "sliding" then
                return smasPlayerRendererSystem.animationsBig.slide
            elseif Playur.findAnimation(player) == "grabFromTop" then
                return smasPlayerRendererSystem.animationsBig.grabbing
            elseif Playur.findAnimation(player) == "door" then
                return smasPlayerRendererSystem.animationsBig.back
            elseif Playur.findAnimation(player) == "swimIdle" then
                return smasPlayerRendererSystem.animationsBig.idleSwim
            elseif Playur.findAnimation(player) == "swimStroke" or Playur.findAnimation(player) == "swimStrokeSmall" then
                return smasPlayerRendererSystem.animationsBig.swimming
            elseif Playur.findAnimation(player) == "leafFly" then
                return smasPlayerRendererSystem.animationsBig.leafFly
            elseif Playur.findAnimation(player) == "slowFall" or Playur.findAnimation(player) == "runJumpLeafDown" or Playur.findAnimation(player) == "runSlowFall" then
                return smasPlayerRendererSystem.animationsBig.leafSlowFall
            elseif Playur.findAnimation(player) == "shootAir" or Playur.findAnimation(player) == "shootWater" or Playur.findAnimation(player) == "shootGround" then
                return smasPlayerRendererSystem.animationsBig.fireball
            else
                return smasPlayerRendererSystem.animationsBig.standing
            end
        end
    end
end

smasPlayerRendererSystem.playerYActualWidth = 0  
smasPlayerRendererSystem.playerXActualWidth = 0
smasPlayerRendererSystem.playerSourceX = 0
smasPlayerRendererSystem.playerSourceY = 0

smasPlayerRendererSystem.animateFramed = 1

function smasPlayerRendererSystem.onDraw()
    if not SaveData.disableX2char then
        smasPlayerRendererSystem.animateFramed = math.floor((lunatime.tick() / smasPlayerRendererSystem.frameSpeed) % #smasPlayerRendererSystem.getAnimation() + 1)
        
        smasPlayerRendererSystem.playerXActualWidth = player.x + (player.width / 2) - (smasPlayerRendererSystem.getPlayerHitboxWidth() / 2)
        smasPlayerRendererSystem.playerYActualWidth = player.y + (player.height / 2) + (smasPlayerRendererSystem.getPlayerHitboxHeightWithDucking(player) / 2)
        
        smasPlayerRendererSystem.playerSourceX = (math.floor(((smasPlayerRendererSystem.getAnimation()[smasPlayerRendererSystem.animateFramed]) - 1) / 10) + 5) * smasPlayerRendererSystem.frameBoxMax
        smasPlayerRendererSystem.playerSourceY = ((smasPlayerRendererSystem.getAnimation()[smasPlayerRendererSystem.animateFramed]) - 1) % 10* smasPlayerRendererSystem.frameBoxMax
        
        
        if player.mount == 0 then
            Graphics.drawBox{
                texture             = smasPlayerRendererSystem.currentCharacterImages[player.idx][player.powerup],
                sceneCoords         = true,
                x                   = player.x - smasPlayerRendererSystem.convertPlayerFrameX(smasPlayerRendererSystem.getAnimation()[smasPlayerRendererSystem.animateFramed], 1),
                y                   = player.y + smasPlayerRendererSystem.convertPlayerFrameY(smasPlayerRendererSystem.getAnimation()[smasPlayerRendererSystem.animateFramed], 1),
                width               = smasPlayerRendererSystem.frameBoxMax,
                height              = smasPlayerRendererSystem.frameBoxMax,
                sourceX             = smasPlayerRendererSystem.playerSourceX,
                sourceY             = smasPlayerRendererSystem.playerSourceY,
                sourceWidth         = smasPlayerRendererSystem.frameBoxMax,
                sourceHeight        = smasPlayerRendererSystem.frameBoxMax,
                centered            = false,
                priority            = smasPlayerRendererSystem.getPlayerPriority(),
            }
        end
    end
end

return smasPlayerRendererSystem