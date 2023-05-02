local smasCameraControl = {}

local autoscroll = require("autoscroll")

smasCameraControl.ticksUntilYouCanPressLeftOrRight = lunatime.toTicks(1.5) --For holding alt-run + alt-jump
smasCameraControl.timerUpdatable = 0
smasCameraControl.canPanCamera = false
smasCameraControl.camera = {
    normal = 1,
    left = 2,
    right = 3,
}
smasCameraControl.cameraPanned = smasCameraControl.camera.normal --Normal is the default setting
smasCameraControl.cameraPreviousPan = smasCameraControl.camera.normal --To make sure we know what the pan should be
smasCameraControl.panAmount = 150
smasCameraControl.panAmountFinal = 0
smasCameraControl.isPanningCamera = false
smasCameraControl.panTimer = 0
smasCameraControl.normalPanTimer = smasCameraControl.panAmount
smasCameraControl.mathClampedValue = 0
smasCameraControl.offBounds = false

function smasCameraControl.onInitAPI()
    registerEvent(smasCameraControl,"onCameraUpdate")
    registerEvent(smasCameraControl,"onInputUpdate")
    registerEvent(smasCameraControl,"onTick")
end

function smasCameraControl.canDoCameraControlling()
    return (not SaveData.SMASPlusPlus.game.onePointThreeModeActivated
        and (
            smasBooleans.isInLevel
            or smasBooleans.isInHub
        )
        and Level.endState() == 0
        and (
            not GameData.winStateActive
            or GameData.winStateActive == nil
        )
    )
end

function smasCameraControl.onInputUpdate()
    if smasCameraControl.canDoCameraControlling() then --Make sure that these requirements are met...
        if smasCameraControl.canPanCamera and player.keys.left == KEYS_PRESSED then --If pressing left, do these...
            Sound.playSFX(13) --Play the camera sound effect
            smasCameraControl.timerUpdatable = 0 --Make sure this is 0...
            smasCameraControl.isPanningCamera = true --We're panning baby!
            if smasCameraControl.cameraPanned == smasCameraControl.camera.right then --Set the settings for panning here
                smasCameraControl.cameraPreviousPan = smasCameraControl.camera.right
                smasCameraControl.cameraPanned = smasCameraControl.camera.normal
            else
                smasCameraControl.cameraPreviousPan = smasCameraControl.camera.normal
                smasCameraControl.cameraPanned = smasCameraControl.camera.left
            end
        elseif smasCameraControl.canPanCamera and player.keys.right == KEYS_PRESSED then --Same as above, except we're doing the right button here
            Sound.playSFX(13)
            smasCameraControl.timerUpdatable = 0
            smasCameraControl.isPanningCamera = true
            if smasCameraControl.cameraPanned == smasCameraControl.camera.left then --Set the settings for panning here
                smasCameraControl.cameraPreviousPan = smasCameraControl.camera.left
                smasCameraControl.cameraPanned = smasCameraControl.camera.normal
            else
                smasCameraControl.cameraPreviousPan = smasCameraControl.camera.normal
                smasCameraControl.cameraPanned = smasCameraControl.camera.right
            end
        end
    end
end

function smasCameraControl.onCameraUpdate(camIdx) --onCameraUpdate is used for the panning and camera control
    if smasCameraControl.canDoCameraControlling() then
        for i = 0,20 do
            if player.keys.altJump and player.keys.altRun then --When holding alt-run and alt-jump...
                smasCameraControl.timerUpdatable = smasCameraControl.timerUpdatable + 1 --Update the ticks for the holding.
                if smasCameraControl.timerUpdatable >= smasCameraControl.ticksUntilYouCanPressLeftOrRight and not autoscroll.isSectionScrolling(i) then --Make sure we're not autoscrolling before camera controlling...
                    smasCameraControl.canPanCamera = true --We pan camera!
                else
                    smasCameraControl.canPanCamera = false --Don't do it if not met the requirements
                end
            else
                smasCameraControl.timerUpdatable = 0 --Don't update if not holding alt-run and alt-jump
                smasCameraControl.canPanCamera = false
            end
        end
        if smasCameraControl.isPanningCamera then
            smasCameraControl.panTimer = smasCameraControl.panTimer + 5 --This makes a pan happen, on the right
            smasCameraControl.normalPanTimer = smasCameraControl.normalPanTimer - 5 --Make sure that this is used for panning to the left
            if smasCameraControl.panTimer >= smasCameraControl.panAmount then --If met the right pan amount, reset the right pan timer and make panning false...
                smasCameraControl.panTimer = 0
                smasCameraControl.isPanningCamera = false
            end
            if smasCameraControl.normalPanTimer <= 0 then --If met the left pan amount, reset the left pan timer and make panning false...
                smasCameraControl.normalPanTimer = smasCameraControl.panAmount
                smasCameraControl.isPanningCamera = false
            end
            if smasCameraControl.cameraPanned == smasCameraControl.camera.left then --Here we update the camera panning
                camera.x = math.clamp(camera.x - smasCameraControl.panTimer, player.sectionObj.boundary.left, player.sectionObj.boundary.right - camera.width)
            elseif smasCameraControl.cameraPanned == smasCameraControl.camera.right then --For right...
                camera.x = math.clamp(camera.x + smasCameraControl.panTimer, player.sectionObj.boundary.left, player.sectionObj.boundary.right - camera.width)
            elseif smasCameraControl.cameraPanned == smasCameraControl.camera.normal then --If normal and we pressed either left or right, we'll need to pan from there
                if smasCameraControl.cameraPreviousPan == smasCameraControl.camera.left then --Left panning goes from here
                    camera.x = math.clamp(camera.x - smasCameraControl.normalPanTimer, player.sectionObj.boundary.left, player.sectionObj.boundary.right - camera.width)
                elseif smasCameraControl.cameraPreviousPan == smasCameraControl.camera.right then --Same for right camera panning
                    camera.x = math.clamp(camera.x + smasCameraControl.normalPanTimer, player.sectionObj.boundary.left, player.sectionObj.boundary.right - camera.width)
                end
            end
        else
            if smasCameraControl.cameraPanned == smasCameraControl.camera.left then --Are we already panned? Use the default values
                camera.x = math.clamp(camera.x - smasCameraControl.panAmount, player.sectionObj.boundary.left, player.sectionObj.boundary.right - camera.width)
            elseif smasCameraControl.cameraPanned == smasCameraControl.camera.right then --Here's the ones for right
                camera.x = math.clamp(camera.x + smasCameraControl.panAmount, player.sectionObj.boundary.left, player.sectionObj.boundary.right - camera.width)
            end
        end
        if camera.x < player.sectionObj.boundary.left then
            smasCameraControl.offBounds = true
        elseif camera.x > player.sectionObj.boundary.right - camera.width then
            smasCameraControl.offBounds = true
        else
            smasCameraControl.offBounds = false
        end
    end
end

return smasCameraControl