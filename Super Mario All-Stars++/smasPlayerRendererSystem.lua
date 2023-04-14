local smasPlayerRendererSystem = {}

local playerManager = require("playerManager")

function smasPlayerRendererSystem.onInitAPI()
    registerEvent(smasPlayerRendererSystem,"onDraw")
end

--Each box needs how much a sprite should max out to.
smasPlayerRendererSystem.frameBoxMaxWidth = 100
smasPlayerRendererSystem.frameBoxMaxHeight = 100

--This here is for how much rows and columns the frame boxes should be.
smasPlayerRendererSystem.frameBoxRowsTopToBottom = 30
smasPlayerRendererSystem.frameBoxRowsLeftToRight = 30

--The total frames for the frame box.
smasPlayerRendererSystem.frameBoxTotalFrames = 300

--The total size for the sprite sheet in total.
smasPlayerRendererSystem.frameBoxTotalSizeWidth = 3000
smasPlayerRendererSystem.frameBoxTotalSizeHeight = 3000

--The current row and column for the animation frame.
smasPlayerRendererSystem.currentRow = 1
smasPlayerRendererSystem.currentColumn = 1

--Create the table for the player info...
smasPlayerRendererSystem.playerInfo = {}

--The frame to use for the player. Default is 1.
smasPlayerRendererSystem.playerInfo.frame = 1

--Frame speed for the player. This will be updated automatically.
smasPlayerRendererSystem.playerInfo.frameSpeed = 4

--For updating the speed of the player.
smasPlayerRendererSystem.playerInfo.animationFramed = 0

--The priorities for normal uses and pipe warping.
smasPlayerRendererSystem.playerInfo.priority = -25
smasPlayerRendererSystem.playerInfo.priorityPipe = -70

--The table where it will store the player images.
smasPlayerRendererSystem.playerInfo.images = {}
smasPlayerRendererSystem.playerInfo.images[player.idx] = {}

--Default small animation table for animations.
smasPlayerRendererSystem.playerInfo.animationsSmall = {
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
--Default big animation table for animations.
smasPlayerRendererSystem.playerInfo.animationsBig = {
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
    smasPlayerRendererSystem.playerInfo.images[player.idx][i] = Img.loadCharacter("states/"..playerManager.getName(player.character).."-"..tostring(i)..".png")
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

--These will be filled out on smasCharacterInfo.lua
smasPlayerRendererSystem.playerInfo.playerSettings = {}

--X coordinate of the player.
smasPlayerRendererSystem.playerInfo.playerSettings.x = 0
--Y coordinate of the player.
smasPlayerRendererSystem.playerInfo.playerSettings.y = 0
--Width of the player's hitbox.
smasPlayerRendererSystem.playerInfo.playerSettings.width = 0
--Height of the player's hitbox.
smasPlayerRendererSystem.playerInfo.playerSettings.height = 0
--Height (When ducking) of the player's hitbox. In this system, the duck height will be centered along the bottom of the original height hitbox.
smasPlayerRendererSystem.playerInfo.playerSettings.heightDuck = 0
--Grab offset (X)
smasPlayerRendererSystem.playerInfo.playerSettings.grabOffsetX = 0
--Grab offset (Y)
smasPlayerRendererSystem.playerInfo.playerSettings.grabOffsetY = 0
--Player offset (X)
smasPlayerRendererSystem.playerInfo.playerSettings.offsetX = 0
--Player offset (Y)
smasPlayerRendererSystem.playerInfo.playerSettings.offsetY = 0

function smasPlayerRendererSystem.getPlayerPriority()
    if player.forcedState == FORCEDSTATE_PIPE then
        return smasPlayerRendererSystem.playerInfo.priorityPipe
    else
        return smasPlayerRendererSystem.playerInfo.priority
    end
end

function smasPlayerRendererSystem.getAnimation()
    if player.character >= 1 and player.character <= 2 then
        if player.powerup == 1 then
            if Playur.findAnimation(player) == "stance" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.standing
            elseif Playur.findAnimation(player) == "walkSmall" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.walking
            elseif Playur.findAnimation(player) == "runSmall" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.walking
            elseif Playur.findAnimation(player) == "holding" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.holding
            elseif Playur.findAnimation(player) == "walkHolding" or Playur.findAnimation(player) == "runHolding" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.holdWalking
            elseif Playur.findAnimation(player) == "jump" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.jumping
            elseif Playur.findAnimation(player) == "runJump" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.jumping
            elseif Playur.findAnimation(player) == "fall" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.jumping
            elseif Playur.findAnimation(player) == "skidding" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.skidding
            elseif Playur.findAnimation(player) == "lookUp" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.standing
            elseif Playur.findAnimation(player) == "lookUpHolding" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.holding
            elseif Playur.findAnimation(player) == "warpUp" or Playur.findAnimation(player) == "warpDown" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.front
            elseif Playur.findAnimation(player) == "mountedOnYoshi" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.yoshiRide
            elseif Playur.findAnimation(player) == "spinJump" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.spinJump
            elseif Playur.findAnimation(player) == "climbing" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.climb
            elseif Playur.findAnimation(player) == "sliding" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.slide
            elseif Playur.findAnimation(player) == "grabFromTop" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.grabbing
            elseif Playur.findAnimation(player) == "door" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.back
            elseif Playur.findAnimation(player) == "swimIdle" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.idleSwim
            elseif Playur.findAnimation(player) == "swimStroke" or Playur.findAnimation(player) == "swimStrokeSmall" then
                return smasPlayerRendererSystem.playerInfo.animationsSmall.swimming
            else
                return smasPlayerRendererSystem.playerInfo.animationsSmall.standing
            end
        else
            if Playur.findAnimation(player) == "stance" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.standing
            elseif Playur.findAnimation(player) == "walk" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.walking
            elseif Playur.findAnimation(player) == "run" then
                if player.powerup == 4 or player.powerup == 5 then
                    return smasPlayerRendererSystem.playerInfo.animationsBig.leafRun
                else
                    return smasPlayerRendererSystem.playerInfo.animationsBig.walking
                end
            elseif Playur.findAnimation(player) == "holding" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.holding
            elseif Playur.findAnimation(player) == "walkHolding" or Playur.findAnimation(player) == "runHolding" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.holdWalking
            elseif Playur.findAnimation(player) == "jump" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.jumping
            elseif Playur.findAnimation(player) == "runJump" then
                if player.powerup == 4 or player.powerup == 5 then
                    return smasPlayerRendererSystem.playerInfo.animationsBig.leafFlyJump
                else
                    return smasPlayerRendererSystem.playerInfo.animationsBig.jumping
                end
            elseif Playur.findAnimation(player) == "fall" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.falling
            elseif Playur.findAnimation(player) == "skidding" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.skidding
            elseif Playur.findAnimation(player) == "lookUp" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.standing
            elseif Playur.findAnimation(player) == "lookUpHolding" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.holding
            elseif Playur.findAnimation(player) == "warpUp" or Playur.findAnimation(player) == "warpDown" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.front
            elseif Playur.findAnimation(player) == "mountedOnYoshi" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.yoshiRide
            elseif Playur.findAnimation(player) == "tailAttack" or Playur.findAnimation(player) == "spinJump" or Playur.findAnimation(player) == "spinjumpSidwaysToad" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.spinJump
            elseif Playur.findAnimation(player) == "climbing" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.climb
            elseif Playur.findAnimation(player) == "sliding" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.slide
            elseif Playur.findAnimation(player) == "grabFromTop" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.grabbing
            elseif Playur.findAnimation(player) == "door" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.back
            elseif Playur.findAnimation(player) == "swimIdle" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.idleSwim
            elseif Playur.findAnimation(player) == "swimStroke" or Playur.findAnimation(player) == "swimStrokeSmall" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.swimming
            elseif Playur.findAnimation(player) == "leafFly" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.leafFly
            elseif Playur.findAnimation(player) == "slowFall" or Playur.findAnimation(player) == "runJumpLeafDown" or Playur.findAnimation(player) == "runSlowFall" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.leafSlowFall
            elseif Playur.findAnimation(player) == "shootAir" or Playur.findAnimation(player) == "shootWater" or Playur.findAnimation(player) == "shootGround" then
                return smasPlayerRendererSystem.playerInfo.animationsBig.fireball
            else
                return smasPlayerRendererSystem.playerInfo.animationsBig.standing
            end
        end
    end
end

function smasPlayerRendererSystem.onDraw()
    if not SaveData.disableX2char then
        smasPlayerRendererSystem.playerInfo.animationFramed = math.floor((lunatime.tick() / smasPlayerRendererSystem.playerInfo.frameSpeed) % #smasPlayerRendererSystem.getAnimation() + 1)
        
        
            --[[Graphics.drawBox{
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
            }]]
    end
end

return smasPlayerRendererSystem