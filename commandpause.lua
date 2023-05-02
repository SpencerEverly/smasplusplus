local textplus = require("textplus")
local playerManager = require("playerManager")

local active = false
local ready = false

f10PressedState = false

local costumes = {}

local flag = true
local str = "Loading HUB..."

local commandpause = {}

local oldCostume = {}
local costumes = {}
local idMap = {}

local soundObject

local characterID = 1

--local levelfolder = Level.folderPath()
--local levelname = Level.filename()
--local levelformat = Level.format()

function commandpause.onInitAPI()
    registerEvent(commandpause, "onKeyboardPress")
    registerEvent(commandpause, "onDraw")
    registerEvent(commandpause, "onLevelExit")
    registerEvent(commandpause, "onTick")
    registerEvent(commandpause, "onTickEnd")
    registerEvent(commandpause, "onEvent")
    
    ready = true
end

function commandpause.onStart()
    if not ready then return end
    
    activeText = {}
    doyouwantogo = textplus.layout(textplus.parse("<color red>Do you want to go to the HUB (Me and Larry City)?</color>"))
    pressforthis = textplus.layout(textplus.parse("<color yellow>Press Y to do so, press F8 again to not.</color>"))
    useiffailsafe = textplus.layout(textplus.parse("(Use this if you are stuck on a level, or for faster travel convenience)"))
    
end

function commandpause.onKeyboardPress(k)
    if k == VK_F10 then
        active = not active
    end
    if active then
        f10PressedState = false
        if k == VK_F10 then
            f10PressedState = true
            SFX.play("pausemenu.wav")
        end
    end
    if not active then
        f10PressedState = true
        if k == VK_F10 then
            f10PressedState = false
            SFX.play("pausemenu.wav")
        end
    end
end

function commandpause.onDraw(k)
    if active then
        player.pauseKeyPressing = false
        Graphics.drawBox{x=0, y=0, width=0, height=0, color=Color.black..0.6, priority=10}
    end
end

return commandpause