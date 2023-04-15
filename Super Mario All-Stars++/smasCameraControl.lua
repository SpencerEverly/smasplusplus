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
smasCameraControl.isPanningCamera = false
smasCameraControl.panTimer = 0
smasCameraControl.normalPanTimer = smasCameraControl.panAmount
smasCameraControl.mathClampedValue = 0

function smasCameraControl.onInitAPI()
    registerEvent(smasCameraControl,"onCameraUpdate")
    registerEvent(smasCameraControl,"onInputUpdate")
    registerEvent(smasCameraControl,"onTick")
end

function smasCameraControl.onInputUpdate()
    if not SaveData.disableX2char and (smasBooleans.isInLevel or smasBooleans.isInHub) then
        if smasCameraControl.canPanCamera and player.keys.left == KEYS_PRESSED then
            Sound.playSFX(13)
            smasCameraControl.timerUpdatable = 0
            smasCameraControl.isPanningCamera = true
            if smasCameraControl.cameraPanned == smasCameraControl.camera.right then
                smasCameraControl.cameraPreviousPan = smasCameraControl.camera.right
                smasCameraControl.cameraPanned = smasCameraControl.camera.normal
            else
                smasCameraControl.cameraPreviousPan = smasCameraControl.camera.normal
                smasCameraControl.cameraPanned = smasCameraControl.camera.left
            end
        elseif smasCameraControl.canPanCamera and player.keys.right == KEYS_PRESSED then
            Sound.playSFX(13)
            smasCameraControl.timerUpdatable = 0
            smasCameraControl.isPanningCamera = true
            if smasCameraControl.cameraPanned == smasCameraControl.camera.left then
                smasCameraControl.cameraPreviousPan = smasCameraControl.camera.left
                smasCameraControl.cameraPanned = smasCameraControl.camera.normal
            else
                smasCameraControl.cameraPreviousPan = smasCameraControl.camera.normal
                smasCameraControl.cameraPanned = smasCameraControl.camera.right
            end
        end
    end
end

function smasCameraControl.onCameraUpdate(camIdx)
    if not SaveData.disableX2char and (smasBooleans.isInLevel or smasBooleans.isInHub) then
        if smasCameraControl.isPanningCamera then
            if smasCameraControl.cameraPanned == smasCameraControl.camera.left then
                camera.x = camera.x - smasCameraControl.panTimer
            elseif smasCameraControl.cameraPanned == smasCameraControl.camera.right then
                camera.x = camera.x + smasCameraControl.panTimer
            elseif smasCameraControl.cameraPanned == smasCameraControl.camera.normal then
                if smasCameraControl.cameraPreviousPan == smasCameraControl.camera.left then
                    camera.x = camera.x - smasCameraControl.normalPanTimer
                else
                    camera.x = camera.x + smasCameraControl.normalPanTimer
                end
            end
        else
            if smasCameraControl.cameraPanned == smasCameraControl.camera.left then
                camera.x = camera.x - smasCameraControl.panAmount
            elseif smasCameraControl.cameraPanned == smasCameraControl.camera.right then
                camera.x = camera.x + smasCameraControl.panAmount
            end
        end
    end
end

function smasCameraControl.onTick()
    if not SaveData.disableX2char and (smasBooleans.isInLevel or smasBooleans.isInHub) then
        for i = 0,20 do
            if player.keys.altJump and player.keys.altRun then
                smasCameraControl.timerUpdatable = smasCameraControl.timerUpdatable + 1
                if smasCameraControl.timerUpdatable >= smasCameraControl.ticksUntilYouCanPressLeftOrRight and not autoscroll.isSectionScrolling(i) then
                    smasCameraControl.canPanCamera = true
                else
                    smasCameraControl.canPanCamera = false
                end
            else
                smasCameraControl.timerUpdatable = 0
                smasCameraControl.canPanCamera = false
            end
        end
        if smasCameraControl.isPanningCamera then
            smasCameraControl.panTimer = smasCameraControl.panTimer + 5
            smasCameraControl.normalPanTimer = smasCameraControl.normalPanTimer - 5
            if smasCameraControl.panTimer >= smasCameraControl.panAmount then
                smasCameraControl.panTimer = 0
                smasCameraControl.isPanningCamera = false
            end
            if smasCameraControl.normalPanTimer <= 0 then
                smasCameraControl.normalPanTimer = smasCameraControl.panAmount
                smasCameraControl.isPanningCamera = false
            end
        end
        if not smasCameraControl.isPanningCamera then
            if smasCameraControl.cameraPanned == smasCameraControl.camera.left then
                smasCameraControl.mathClampedValue = math.clamp(smasCameraControl.panAmount, camera.x, camera.x)
            elseif smasCameraControl.cameraPanned == smasCameraControl.camera.right then
                smasCameraControl.mathClampedValue = math.clamp(smasCameraControl.panAmount, camera.x, camera.x)
            end
        else
            if smasCameraControl.cameraPanned == smasCameraControl.camera.left then
                smasCameraControl.mathClampedValue = math.clamp(smasCameraControl.panTimer, camera.x, camera.x)
            elseif smasCameraControl.cameraPanned == smasCameraControl.camera.right then
                smasCameraControl.mathClampedValue = math.clamp(smasCameraControl.panTimer, camera.x, camera.x)
            elseif smasCameraControl.cameraPanned == smasCameraControl.camera.normal then
                if smasCameraControl.cameraPreviousPan == smasCameraControl.camera.left then
                    smasCameraControl.mathClampedValue = math.clamp(smasCameraControl.normalPanTimer, camera.x, camera.x)
                else
                    smasCameraControl.mathClampedValue = math.clamp(smasCameraControl.normalPanTimer, camera.x, camera.x)
                end
            end
        end
    end
end

return smasCameraControl