local textplus = require("textplus")

local active = false
local ready = false

onePressedState = false
twoPressedState = false
threePressedState = false
fourPressedState = false
fivePressedState = false

local flag = true
local str = "Loading HUB..."

local malcwarp = {}

--malcwarp.sfxFile = Misc.resolveSoundFile("hub_travelactivated")

function malcwarp.onInitAPI()
    registerEvent(malcwarp, "onKeyboardPress")
    registerEvent(malcwarp, "onDraw")
    registerEvent(malcwarp, "onLevelExit")
    --musicChunk = Audio.SfxOpen(malcwarp.sfxFile)
    
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
        end
    end
    if active then
        if k == VK_1 then
            Sound.playSFX("hub_travelactivated.ogg")
            world.playerX = -2880
            world.playerY = -1664
            Sound.playSFX("world_warp.ogg")
            onePressedState = true
            active = false
        end
    end
    if active then
        if k == VK_2 then
            Sound.playSFX("hub_travelactivated.ogg")
            world.playerX = -3168
            world.playerY = -1536
            Sound.playSFX("world_warp.ogg")
            twoPressedState = true
            active = false
        end
    end
    if active then
        if k == VK_3 then
            Sound.playSFX("hub_travelactivated.ogg")
            world.playerX = -3040
            world.playerY = -1760
            Sound.playSFX("world_warp.ogg")
            threePressedState = true
            active = false
        end
    end
    if not active then
        if k == VK_F5 then
            Sound.playSFX("hub_quitmenu.ugg")
            player.pauseKeyPressing = true
            onePressedState = true
            twoPressedState = true
            threePressedState = true
        end
    end
end

function malcwarp.onDraw(k)
    if active then
        player.pauseKeyPressing = false
        Graphics.drawBox{x=250, y=250, width=300, height=100, color=Color.darkgrey..0.8, priority=10}

        textplus.print{x=255, y=255, text = "MAP OPTIONS (Command Mode, things WILL still run so be careful!)", priority=10}
        textplus.print{x=255, y=270, text = "Press F5 to exit the menu.", priority=10, color=Color.green}
        textplus.print{x=255, y=285, text = "Press 1 to go back to the start (Game Help).", priority=10, color=Color.lightred}
        textplus.print{x=255, y=300, text = "Press 2 to go to the Me and Larry City Side Quest.", priority=10, color=Color.orange}
        textplus.print{x=255, y=315, text = "(To make 2 work, please enter the first pipe in the HUB.)", priority=10, color=Color.orange}
        textplus.print{x=255, y=330, text = "Press 3 to go to the HUB level on the map.", priority=10, color=Color.lightred}
    end
end

return malcwarp