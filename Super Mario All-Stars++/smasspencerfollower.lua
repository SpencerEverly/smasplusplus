local smasSpencerFollower = {}

local playerManager = require("playerManager")

function smasSpencerFollower.onInitAPI()
    registerEvent(smasSpencerFollower,"onDraw")
end

smasSpencerFollower.enabled = true --True if we should draw Spencer or not
smasSpencerFollower.spencerSprites = Graphics.loadImageResolved("costumes/luigi/00-SpencerEverly/spencerFollower-sprites.png")
smasSpencerFollower.dimensions = {
    width = 16,
    height = 32,
    totalFrames = 32,
}
smasSpencerFollower.frame = 1
smasSpencerFollower.frameSpeed = 8
smasSpencerFollower.animations = {
    standing = {1},
    walking = {1,2,3,2},
    jumping = {4},
    falling = {5},
    skidding = {6},
    ducking = {7},
    spinJump = {1,8,32,9},
    slide = {10},
    climb = {11,12},
    grabbing = {13,14},
    holding = {15},
    holdWalking = {15,16,17,16},
    yoshiRide = {18},
    idleSwim = {19,20,21,20},
    swimming = {20,22,23,22},
    yoshiRideDuck = {24},
    fireball = {25,26,25},
    running = {27,28,29,28},
    runJump = {30},
    flagpole = {31},
    front = {8},
    back = {9},
}

function smasSpencerFollower.dontMovePlayerDetection()
    return (player:mem(0x50,FIELD_BOOL)
        and player.forcedState == FORCEDSTATE_PIPE
    )
end

function smasSpencerFollower.getSpencerPriority()
    if player.forcedState == FORCEDSTATE_PIPE then
        return -70
    else
        return -25
    end
end

function smasSpencerFollower.getAnimation()
    if Playur.findAnimation(player) == "stance" then
        return smasSpencerFollower.animations.standing
    elseif Playur.findAnimation(player) == "walkSmall" or Playur.findAnimation(player) == "walk" or Playur.findAnimation(player) == "walkSMB2" then
        return smasSpencerFollower.animations.walking
    elseif Playur.findAnimation(player) == "run" or Playur.findAnimation(player) == "runSmall" or Playur.findAnimation(player) == "runSMB2" then
        return smasSpencerFollower.animations.running
    elseif Playur.findAnimation(player) == "walkHolding" or Playur.findAnimation(player) == "runHolding" then
        return smasSpencerFollower.animations.holdWalking
    elseif Playur.findAnimation(player) == "dead" then
        return smasSpencerFollower.animations.ducking
    elseif Playur.findAnimation(player) == "jump" then
        return smasSpencerFollower.animations.jumping
    elseif Playur.findAnimation(player) == "runJump" or Playur.findAnimation(player) == "leafFly" then
        return smasSpencerFollower.animations.runJump
    elseif Playur.findAnimation(player) == "slowFall" or Playur.findAnimation(player) == "runJumpLeafDown" or Playur.findAnimation(player) == "runSlowFall" or Playur.findAnimation(player) == "fall" then
        return smasSpencerFollower.animations.falling
    elseif Playur.findAnimation(player) == "skidding" then
        return smasSpencerFollower.animations.skidding
    elseif Playur.findAnimation(player) == "lookUp" then
        return smasSpencerFollower.animations.standing
    elseif Playur.findAnimation(player) == "lookUpHolding" then
        return smasSpencerFollower.animations.holding
    elseif Playur.findAnimation(player) == "warpUp" or Playur.findAnimation(player) == "warpDown" then
        return smasSpencerFollower.animations.front
    elseif Playur.findAnimation(player) == "mountedOnYoshi" then
        return smasSpencerFollower.animations.yoshiRide
    elseif Playur.findAnimation(player) == "shootAir" or Playur.findAnimation(player) == "shootWater" or Playur.findAnimation(player) == "shootGround" then
        return smasSpencerFollower.animations.fireball
    elseif Playur.findAnimation(player) == "tailAttack" or Playur.findAnimation(player) == "spinJump" or Playur.findAnimation(player) == "spinjumpSidwaysToad" then
        return smasSpencerFollower.animations.spinJump
    elseif Playur.findAnimation(player) == "climbing" then
        return smasSpencerFollower.animations.climb
    elseif Playur.findAnimation(player) == "sliding" then
        return smasSpencerFollower.animations.slide
    elseif Playur.findAnimation(player) == "grabFromTop" then
        return smasSpencerFollower.animations.grabbing
    elseif Playur.findAnimation(player) == "door" then
        return smasSpencerFollower.animations.back
    elseif Playur.findAnimation(player) == "swimIdle" then
        return smasSpencerFollower.animations.idleSwim
    elseif Playur.findAnimation(player) == "swimStroke" or Playur.findAnimation(player) == "swimStrokeSmall" then
        return smasSpencerFollower.animations.swimming
    else
        return smasSpencerFollower.animations.standing
    end
end

smasSpencerFollower.animateFramed = 1
local animationTable = {}
smasSpencerFollower.playerYActualWidth = 0
smasSpencerFollower.playerXActualWidth = 0
smasSpencerFollower.spencerCoordinateX = 0
smasSpencerFollower.spencerDistance = 35

function smasSpencerFollower.onDraw()
    if table.icontains(smasTables.__smbspencerLevels,Level.filename()) and smasSpencerFollower.enabled then
        if not SaveData.disableX2char then
            if not (SaveData.currentCostume == "00-SPENCEREVERLY") then
                animationTable = smasSpencerFollower.getAnimation()
                smasSpencerFollower.animateFramed = math.floor((lunatime.tick() / smasSpencerFollower.frameSpeed) % #smasSpencerFollower.getAnimation()) + 1
                
                smasSpencerFollower.playerYActualWidth = (player.screen.bottom + camera.y) - smasSpencerFollower.dimensions.height
                
                smasSpencerFollower.playerXActualWidth = player.x + (player.width / 2) - smasSpencerFollower.spencerCoordinateX
                
                if not smasSpencerFollower.dontMovePlayerDetection() then
                    if player.direction == 1 then
                        if player.x - smasSpencerFollower.spencerCoordinateX > player.x - smasSpencerFollower.spencerDistance then
                            smasSpencerFollower.spencerCoordinateX = smasSpencerFollower.spencerCoordinateX + 2
                        end
                    else
                        if player.x - smasSpencerFollower.spencerCoordinateX < player.x + smasSpencerFollower.spencerDistance then
                            smasSpencerFollower.spencerCoordinateX = smasSpencerFollower.spencerCoordinateX - 2
                        end
                    end
                end
                if player.forcedState == FORCEDSTATE_PIPE then
                    local warp = Warp(player:mem(0x15E,FIELD_WORD) - 1)
                    local direction
                    if player.forcedTimer == 0 then
                        direction = warp.entranceDirection
                    else
                        direction = warp.exitDirection
                    end
                    if direction == 1 or direction == 3 then
                        smasSpencerFollower.spencerCoordinateX = 0
                    end
                end
                
                Graphics.drawBox{
                    texture      = smasSpencerFollower.spencerSprites,
                    sceneCoords  = true,
                    x            = smasSpencerFollower.playerXActualWidth,
                    y            = smasSpencerFollower.playerYActualWidth,
                    width        = smasSpencerFollower.dimensions.width * player.direction * 2,
                    height       = smasSpencerFollower.dimensions.height * 2,
                    sourceX      = 0,
                    sourceY      = smasSpencerFollower.dimensions.height * smasSpencerFollower.getAnimation()[smasSpencerFollower.animateFramed] - smasSpencerFollower.dimensions.height,
                    sourceWidth  = smasSpencerFollower.dimensions.width,
                    sourceHeight = smasSpencerFollower.dimensions.height,
                    centered     = true,
                    priority     = smasSpencerFollower.getSpencerPriority(),
                }
                
            end
        end
    end
end

return smasSpencerFollower