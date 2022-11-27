local smasresolutions = {}

local customCamera = require("customCamera")
customCamera.transitionSpeed = 5

function smasresolutions.onInitAPI()
    registerEvent(smasresolutions,"onDraw")
end

function smasresolutions.onDraw()
    if SaveData.resolution == "fullscreen" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 600
        customCamera.defaultZoom = 1
        customCamera.defaultScreenOffsetY = 0
        if not SaveData.letterbox then
            smallScreen.priority = 10
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
    elseif SaveData.resolution == "widescreen" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 450
        customCamera.defaultZoom = 0.75
        customCamera.defaultScreenOffsetY = 0
        Graphics.drawImageWP(widebars, 0, 0, 7)
        if not SaveData.letterbox then
            smallScreen.priority = 10
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1.33
            smallScreen.offsetX = 0
        smallScreen.offsetY = 0
        elseif SaveData.letterbox then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
    elseif SaveData.resolution == "ultrawide" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 337
        customCamera.defaultZoom = 0.562
        customCamera.defaultScreenOffsetY = 0
        Graphics.drawImageWP(ultrawidebars, 0, 0, 7)
        if not SaveData.letterbox then
            smallScreen.priority = 10
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1.80
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
    elseif SaveData.resolution == "steamdeck" then
        customCamera.defaultScreenWidth = 800
        customCamera.defaultScreenHeight = 500
        customCamera.defaultZoom = 0.84
        customCamera.defaultScreenOffsetY = 0
        Graphics.drawImageWP(steamdeckbars, 0, 0, 7)
        if not SaveData.letterbox then
            smallScreen.priority = 10
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1.2
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
    end
    if SaveData.resolution == "nes" then
        customCamera.defaultScreenWidth = 520
        customCamera.defaultScreenHeight = 612
        customCamera.defaultZoom = 0.60
        customCamera.defaultScreenOffsetY = 0
        Graphics.drawImageWP(nesbars, 0, 0, 7)
        if not SaveData.letterbox then
            smallScreen.priority = 10
            smallScreen.scaleX = 1.56
            smallScreen.scaleY = 1.67
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox then
            smallScreen.priority = 4
            smallScreen.scaleX = 1.25
            smallScreen.scaleY = 1.08
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(nesborder, 0, 0, 8)
        end
    end
    if SaveData.resolution == "gba" then
        customCamera.defaultScreenWidth = 480
        customCamera.defaultScreenHeight = 320
        customCamera.defaultZoom = 0.54
        customCamera.defaultScreenOffsetY = 0
        if not SaveData.letterbox then
            smallScreen.priority = 10
            smallScreen.scaleX = 1.7
            smallScreen.scaleY = 1.9
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        elseif SaveData.letterbox then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(gbaborder, 0, 0, 8)
        end
    end
    if SaveData.resolution == "3ds" then
        customCamera.defaultScreenWidth = 700
        customCamera.defaultScreenHeight = 419
        customCamera.defaultZoom = 0.58
        customCamera.defaultScreenOffsetY = 70
        Graphics.drawImageWP(threedsbars, 0, 0, 7)
        if not SaveData.letterbox then
            smallScreen.priority = 10
            smallScreen.scaleX = 1.50
            smallScreen.scaleY = 1.72
            smallScreen.offsetX = 4
            smallScreen.offsetY = -118
        elseif SaveData.letterbox then
            smallScreen.priority = 4
            smallScreen.scaleX = 1
            smallScreen.scaleY = 1
            smallScreen.offsetX = 0
            smallScreen.offsetY = 0
        end
        if SaveData.borderEnabled == true then
            Graphics.drawImageWP(threedsborder, 0, 0, 8)
        end
    end
end

return smasresolutions