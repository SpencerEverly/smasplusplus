local textplus = require("textplus")

local active = false
local ready = false

onePressedState = false
twoPressedState = false
threePressedState = false
fourPressedState = false
fivePressedState = false
sixPressedState = false
sevenPressedState = false
eightPressedState = false
ninePressedState = false
zeroPressedState = false

local flag = true
local str = "Loading HUB..."

local malcwarp = {}

local soundObject

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

function malcwarp.onInitAPI()
    registerEvent(malcwarp, "onKeyboardPress")
    registerEvent(malcwarp, "onDraw")
    registerEvent(malcwarp, "onLevelExit")
    
    ready = true
end

function malcwarp.onStart()
    if not ready then return end
    
    activeText = {}
    doyouwantogo = textplus.layout(textplus.parse("<color red>Do you want to go to the HUB (Me and Larry City)?</color>"))
    pressforthis = textplus.layout(textplus.parse("<color yellow>Press Y to do so, press F8 again to not.</color>"))
    useiffailsafe = textplus.layout(textplus.parse("(Use this if you are stuck on a level, or for faster travel convenience)"))
    
end

function malcwarp.onKeyboardPress(k)
    if k == VK_F5 then
        player.pauseKeyPressing = false
        active = not active
    end
    if active then
        if k == VK_F5 then
        Sound.playSFX("hub_easytravel.ogg")
        onePressedState = false
        twoPressedState = false
        threePressedState = false
        fourPressedState = false
        end
    end
    if active then
        onePressedState = false
        if k == VK_1 then
            Level.load(Level.filename())
            onePressedState = true
        end
    end
    if active then
        twoPressedState = false
        if k == VK_2 then
            Level.load("MALC - HUB.lvlx", nil, nil)
            twoPressedState = true
        end
    end
    if active then
        threePressedState = false
        if k == VK_3 then
            Level.load("map.lvlx")
            threePressedState = true
        end
    end
    if not active then
        if k == VK_F5 then
            Sound.playSFX("hub_quitmenu.ogg")
            player.pauseKeyPressing = true
            fourPressedState = true
        end
    end
end

function malcwarp.onDraw(k)
    if active then
        player.pauseKeyPressing = false
        Graphics.drawBox{x=240, y=210, width=300, height=150, color=Color.orange..0.7, priority=10}

        textplus.print{x=245, y=237, text = "LEVEL OPTIONS (Command Mode, things WILL still run so be careful!)", priority=10}
        textplus.print{x=245, y=252, text = "Press F5 to exit this menu.", priority=10}
        textplus.print{x=245, y=267, text = "Press 1 to restart the level.", priority=10}
        textplus.print{x=245, y=282, text = "Press 2 to go to the HUB (Me and Larry City).", priority=10}
        textplus.print{x=245, y=297, text = "Press 3 to exit the level (You won't automatically win", priority=10}
        textplus.print{x=245, y=312, text = "by doing this option).", priority=10}
    end
end

return malcwarp