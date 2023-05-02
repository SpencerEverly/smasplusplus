local textplus = require("textplus")

local active = false
local ready = false

local flag = true
local str = "Loading HUB..."

local savecommand = {}

function savecommand.onInitAPI()
    registerEvent(savecommand, "onKeyboardPress")
    registerEvent(savecommand, "onDraw")
    registerEvent(savecommand, "onLevelExit")
    
    ready = true
end

function savecommand.onStart()
    if not ready then return end
    sfx1:stop()
end

function savecommand.onKeyboardPress(k)
    if k == VK_F4 then
        active = true
    end
    if active then
        SFX.play("saved.ogg")
        Misc.saveGame()
    end
    if k == VK_1 then
        SFX.play("save_dismiss.ogg")
        active = false
    end
    if not active then
    
        return
    end
end

function savecommand.onDraw(k)
    if active then
        Graphics.drawBox{x=5, y=5, width=150, height=20, color=Color.black..0.6, priority=10}

        textplus.print{x=8, y=8, text = "Data saved! Press 1 to dismiss.", priority=10}
    end
end

--function savecommand.onDrawEnd(k)

return savecommand