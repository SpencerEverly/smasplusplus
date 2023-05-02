local loadscreenext = {}

ready = false

local timer1 = 0
local speed = 0
local numberup = 0
local time = 0

local blackscreen = Graphics.loadImage("black-screen.png")

local opacity = math.min(1,time/42)
local middle = math.floor(timer1*numberup)

fadetolevel = false

function loadscreenext.onInitAPI()
    registerEvent(loadscreenext, "onLoad")
    registerEvent(loadscreenext, "onStart")
    registerEvent(loadscreenext, "onDraw")

    ready = true
end

function loadscreenext.onLoad()
    fadetolevel = true
end

function loadscreenext.onDraw()
    if fadetolevel then
        time = time + 1
        Graphics.drawImage(blackscreen, 0, 0, 1, 0, 800, 600,opacity)
    end
end

function loadscreenext.onStart()
    fadetolevel = false
end

return loadscreenext