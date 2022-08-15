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

local commandlist = {}

commandlist.sfxFile = Misc.resolveSoundFile("_OST/All Stars Secrets/Command List")

local musicChunk;

function commandlist.onInitAPI()
    registerEvent(commandlist, "onKeyboardPress")
    registerEvent(commandlist, "onDraw")
    registerEvent(commandlist, "onLevelExit")
    
    musicChunk = Audio.SfxOpen(commandlist.sfxFile)
    ready = true
end

function commandlist.onStart()
    if not ready then return end
    
    activeText = {}
    doyouwantogo = textplus.layout(textplus.parse("<color red>Do you want to go to the HUB (Me and Larry City)?</color>"))
    pressforthis = textplus.layout(textplus.parse("<color yellow>Press Y to do so, press F8 again to not.</color>"))
    useiffailsafe = textplus.layout(textplus.parse("(Use this if you are stuck on a level, or for faster travel convenience)"))
end

function commandlist.onTick()
    if active then
        player.pauseKeyPressing = false
    end
    if not active then
        player.pauseKeyPressing = true
    end
end
        

function commandlist.onKeyboardPress(k)
    if k == VK_F9 then
        active = not active
    end
    if active then
        player.pauseKeyPressing = false
        if k == VK_F9 then
            Sound.playSFX("commandlist_open.ogg")
            onePressedState = false
        end
    end
    if not active then
        if k == VK_F9 then
            Sound.playSFX("commandlist_close.ogg")
            onePressedState = true
        end
    end
end

function commandlist.onDraw(k)
    if active then
        player.pauseKeyPressing = false
        Graphics.drawBox{x=240, y=153, width=320, height=295, color=Color.darkgrey..0.8, priority=10}

        textplus.print{x=255, y=165, text = "Command List (Welcome to the dark realm, enjoy it)", priority=10}
        textplus.print{x=255, y=180, text = "!!! Only for keyboards, NOT compatible with controllers !!!", priority=10}
        textplus.print{x=255, y=195, text = "!!!!! All commands DO NOT use misc.pause, use them wisely !!!!!", priority=10}

        textplus.print{x=255, y=225, text = "F1: Save & Exit Command Settings (This episode only)", priority=10}
        textplus.print{x=255, y=240, text = "F2: LunaLua Dependency List (All episodes)", priority=10}
        textplus.print{x=255, y=255, text = "F3: LunaLua Memory Checker/Profiler (All episodes)", priority=10}
        textplus.print{x=255, y=270, text = "F4: Fullscreen Letterbox Toggling (All episodes)", priority=10}
        textplus.print{x=255, y=285, text = "F5: Map/Level/HUB/Intro Command Settings (This episode only)", priority=10}
        textplus.print{x=255, y=300, text = "F6: Character/Costume Command Settings (This episode only)", priority=10}
        textplus.print{x=255, y=315, text = "F7: Switch all music in every section to a Sparta Remix", priority=10}
        textplus.print{x=255, y=330, text = "F8: Not used (N/A)", priority=10}
        textplus.print{x=255, y=345, text = "F9: Show this command list (This episode only)", priority=10}
        textplus.print{x=255, y=360, text = "F10: Pause the game, press again to unpause (All episodes)", priority=10}
        textplus.print{x=255, y=375, text = "F11: Record a GIF (All episodes, Saves to 'data/gif-recordings')", priority=10}
        textplus.print{x=255, y=390, text = "F12: Take a snapshot (All episodes, Saves to 'data/screenshots')", priority=10}

        textplus.print{x=255, y=415, text = "To exit this list, press F9 again.", priority=10}
    end
end

return commandlist