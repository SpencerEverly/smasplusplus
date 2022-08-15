local textplus = require("textplus")

local active = false
local ready = false

onePressedState = false
twoPressedState = false
threePressedState = false

local flag = true
local str = "Loading HUB..."

local exitcommands = {}

function exitcommands.onInitAPI()
    registerEvent(exitcommands, "onKeyboardPress")
    registerEvent(exitcommands, "onDraw")
    registerEvent(exitcommands, "onLevelExit")
    
    ready = true
end

function exitcommands.onStart()
    if not isPaused then return end
end
    
function exitcommands.onKeyboardPress(k)
    if k == VK_F1 then
        player.pauseKeyPressing = false
        onePressedState = false
        twoPressedState = false
        threePressedState = false
        fourPressedState = false
        active = not active
    end
    if active then
        if k == VK_F1 then
            Sound.playSFX("quitmenu.ogg")
        end
    end
    if active then
        if k == VK_1 then
            Sound.playSFX("save_dismiss.ogg")
            Misc.saveGame()
            twoPressedState = true
            active = false
        end
    end
    if active then
        if k == VK_2 then
            Misc.saveGame()
            Misc.exitEngine()
            onePressedState = true
        end
    end
    if active then
        if k == VK_3 then
            Misc.exitEngine()
            threePressedState = true
        end
    end
    if not active then
        if k == VK_F1 then
            Sound.playSFX("quitmenu_close.ogg")
            player.pauseKeyPressing = true
            onePressedState = true
            twoPressedState = true
            threePressedState = true
        end
    end
end

function exitcommands.onDraw(k)
    if active then
        player.pauseKeyPressing = false
        Graphics.drawBox{x=235, y=230, width=310, height=105, color=Color.lightred..0.8, priority=10}

        textplus.print{x=245, y=237, text = "SAVE/EXIT MENU (Command Mode, things WILL still run so be careful!)", priority=10, color=Color.white}
        textplus.print{x=245, y=252, text = "Press F1 to exit the menu.", priority=10, color=Color.green}
        textplus.print{x=245, y=267, text = "Press 1 to save & continue.", priority=10, color=Color.green}
        textplus.print{x=245, y=282, text = "Press 2 to save & quit (Exits SMBX2).", priority=10, color=Color.green}
        textplus.print{x=245, y=297, text = "Press 3 to quit the episode without saving.", priority=10, color=Color.green}
        textplus.print{x=245, y=312, text = "(DATA WILL BE LOST IF YOU QUIT WITHOUT SAVING!)", priority=10, Color.red}
    end
end

return exitcommands