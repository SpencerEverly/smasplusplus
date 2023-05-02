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
escPressedState = false

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
            --This is needed if booting for the first time, and for the usual yadda yadda
            --Level.load("SMAS - World Map Warp.lvlx", nil, nil)
            Level.load("map.lvlx")
            onePressedState = true
        end
    end
    if active then
        twoPressedState = false
        if k == VK_2 then
            Level.load("SMAS - Game Help.lvlx", nil, nil)
            twoPressedState = true
        end
    end
    if active then
        threePressedState = false
        if k == VK_3 then
            Level.load("MALC - HUB.lvlx", nil, nil)
            threePressedState = true
        end
    end
    if active then
        escPressedState = false
        if k == VK_ESCAPE then
            Misc.exitEngine()
            escPressedState = true
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
        Graphics.drawBox{x=220, y=225, width=320, height=110, color=Color.red..0.5, priority=10}

        textplus.print{x=225, y=237, text = "INTRO/BOOT OPTIONS (Command Mode, things WILL still run so be careful!)", priority=10}
        textplus.print{x=225, y=252, text = "Press F5 to exit this menu.", priority=10}
        textplus.print{x=225, y=267, text = "Press 1 to instantly skip to the world map.", priority=10, color=Color.yellow}
        textplus.print{x=225, y=282, text = "Press 2 to start Game Help.", priority=10, color=Color.teal}
        textplus.print{x=225, y=297, text = "Press 3 to warp to the HUB.", priority=10, color=Color.orange}
        textplus.print{x=225, y=312, text = "Press ESC to exit the game.", priority=10, color=Color.yellow}
    end
end

return malcwarp