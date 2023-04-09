local smasResolutions = {}

local customCamera = require("customCamera")
customCamera.transitionSpeed = 5

local widebars = Graphics.loadImageResolved("graphics/resolutions/widescreen.png")
local ultrawidebars = Graphics.loadImageResolved("graphics/resolutions/ultrawide.png")
local steamdeckbars = Graphics.loadImageResolved("graphics/resolutions/steamdeck.png")
local nesbars = Graphics.loadImageResolved("graphics/resolutions/nes.png")
local threedsbars = Graphics.loadImageResolved("graphics/resolutions/3ds.png")

local nesborder = Graphics.loadImageResolved("graphics/resolutionborders/nes.png")
local gbborder = Graphics.loadImageResolved("graphics/resolutionborders/gb.png")
local gbaborder = Graphics.loadImageResolved("graphics/resolutionborders/gba.png")
local iphoneoneborder = Graphics.loadImageResolved("graphics/resolutionborders/iphone1st.png")
local threedsborder = Graphics.loadImageResolved("graphics/resolutionborders/3ds.png")

function smasResolutions.onInitAPI()
    registerEvent(smasResolutions,"onDraw")
end

function smasResolutions.changeResolution()
    console:println("Changing resolution settings set for "..SaveData.resolution.."...")
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
    end
    --[[if SaveData.resolution == "3ds" then
        customCamera.defaultScreenWidth = 700
        customCamera.defaultScreenHeight = 419
        customCamera.defaultZoom = 0.58
        customCamera.defaultScreenOffsetY = 70
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
    end]]
end

function smasResolutions.onDraw()
    if SaveData.resolution == "widescreen" then
        Graphics.drawImageWP(widebars, 0, 0, 7)
    elseif SaveData.resolution == "ultrawide" then
        Graphics.drawImageWP(ultrawidebars, 0, 0, 7)
    elseif SaveData.resolution == "steamdeck" then
        Graphics.drawImageWP(steamdeckbars, 0, 0, 7)
    elseif SaveData.resolution == "nes" then
        Graphics.drawImageWP(nesbars, 0, 0, 7)
        if SaveData.borderEnabled then
            Graphics.drawImageWP(nesborder, 0, 0, 8)
        end
    elseif SaveData.resolution == "gba" then
        if SaveData.borderEnabled then
            Graphics.drawImageWP(gbaborder, 0, 0, 8)
        end
    end
    --[[if SaveData.resolution == "3ds" then
        Graphics.drawImageWP(threedsbars, 0, 0, 7)
        if SaveData.borderEnabled then
            Graphics.drawImageWP(threedsborder, 0, 0, 8)
        end
    end]]
end

return smasResolutions