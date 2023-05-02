local widescreen = {}

local smasHud = require("smasHud")

function widescreen.onInitAPI()
    --registerEvent(twilightHUD, "onStart", "onStart")
    --registerEvent(twilightHUD, "onTick", "onTick")
end

--Widescreen Graphic
local widescreen = Graphics.loadImage("widescreen.png")

function widescreen.drawHUD(camIdx,priority,isSplit)

--Bar rendering
    Graphics.drawImageWP(widescreen, 0, 0, priority)

    end
end

Graphics.overrideHUD(widescreen.drawHUD)

return widescreen