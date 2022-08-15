local textplus = require("textplus")

local active = false
local ready = false

local active2 = false

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

local colorfilter = Shader()

function malcwarp.onInitAPI()
    registerEvent(malcwarp, "onKeyboardPress")
    registerEvent(malcwarp, "onDraw")
    registerEvent(malcwarp, "onLevelExit")
    
    ready = true
end

function malcwarp.onStart()
    if not ready then return end
end

function malcwarp.onKeyboardPress(k)
    if k == VK_F7 then
        player.pauseKeyPressing = false
        active = not active
        active2 = not active2
    end
    if active then
        if k == VK_F7 then
        Sound.playSFX("othersettings_open.ogg")
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
        end
    end
    if active then
        onePressedState = false
        if k == VK_1 then
            active2 = true
        end
    end
    if active2 then
        if k == VK_1 then
        Sound.playSFX("othersettings_open.ogg")
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
        end
    end
    if active then
        twoPressedState = false
        if k == VK_2 then
            
        end
    end
    if active then
        threePressedState = false
        if k == VK_3 then
            
        end
    end
    if active then
        threePressedState = false
        if k == VK_7 then
            
        end
    end
    if not active then
        if k == VK_F7 then
            Sound.playSFX("othersettings_close.ogg")
            player.pauseKeyPressing = true
        end
    end
    if not active2 then
        if k == VK_F7 then
            Sound.playSFX("othersettings_close.ogg")
            player.pauseKeyPressing = true
        end
    end
end

function malcwarp.onDraw(k)
    if active then
        player.pauseKeyPressing = false
        Graphics.drawBox{x=240, y=210, width=300, height=150, color=Color.orange..0.7, priority=10}

        textplus.print{x=245, y=240, text = "OTHER OPTIONS (Command Mode, things WILL still run so be careful!)", priority=10}
        textplus.print{x=245, y=255, text = "Press F7 to exit this menu.", priority=10}
        textplus.print{x=245, y=270, text = "Press 1 to change the save slot (Another menu will appear).", priority=10}
        textplus.print{x=245, y=285, text = "Press 2 to show information about where you are.", priority=10}
        textplus.print{x=245, y=300, text = "Press 3 to filter everything to red (For nighttime gameplay).", priority=10}
        textplus.print{x=245, y=315, text = "Press 4 to turn everything to black and white.", priority=10}
        textplus.print{x=245, y=330, text = "Press 5 to turn everything into color.", priority=10}
        textplus.print{x=245, y=345, text = "Press 6 to turn everything into dark mode.", priority=10}
        textplus.print{x=245, y=360, text = "Press 7 to show the framerate.", priority=10}
        textplus.print{x=245, y=375, text = "Press 8 to enable/disable X2 characters.", priority=10}
        textplus.print{x=245, y=390, text = "Press 9 to load Where SMB Attacks.", priority=10}
        textplus.print{x=245, y=405, text = "(If you don't have this episode it will boot back to SMAS++)", priority=10, color=Color.red}
        textplus.print{x=245, y=435, text = "Press 0 to show the credits.", priority=10, color=Color.darkred}
    end
        if k == VK_3 then
            Graphics.drawScreen{
                color = Color.red .. math.sin(lunatime.tick() * 0.01)
        }
    end
end

return malcwarp