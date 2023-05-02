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
            Misc.saveGame()
            Level.load("map.lvlx")
            onePressedState = true
        end
    end
    if active then
        twoPressedState = false
        if k == VK_2 then
            SFX.play("level-select.ogg")
            player:teleport(20496, 19520, bottomCenterAligned)
            twoPressedState = true
            active = false
        end
    end
    if active then
        threePressedState = false
        if k == VK_3 then
            SFX.play("level-select.ogg")
            player:teleport(-119968, -120128, bottomCenterAligned)
            threePressedState = true
            active = false
        end
    end
    if active then
        threePressedState = false
        if k == VK_4 then
            SFX.play("level-select.ogg")
            player:teleport(-200608, -200128, bottomCenterAligned)
            threePressedState = true
            active = false
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

        textplus.print{x=245, y=237, text = "HUB OPTIONS (Command Mode, things WILL still run so be careful!)", priority=10}
        textplus.print{x=245, y=252, text = "Press F5 to exit this menu.", priority=10}
        textplus.print{x=245, y=267, text = "Press 1 to exit the HUB (This will save automatically).", priority=10}
        textplus.print{x=245, y=282, text = "Press 2 to warp to the warp zone.", priority=10}
        textplus.print{x=245, y=297, text = "Press 3 to warp to the Tourist Center.", priority=10}
        textplus.print{x=245, y=312, text = "Press 4 to warp back to the start.", priority=10}
    end
end

return malcwarp