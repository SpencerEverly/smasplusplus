local smasZoomSystem = {}

local handycam = require("handycam")

smasZoomSystem.isOnClassicLevel = false
smasZoomSystem.beginningZoomTimer = 5

function smasZoomSystem.onInitAPI()
    registerEvent(smasZoomSystem,"onStart")
    registerEvent(smasZoomSystem,"onDraw")
end

function smasZoomSystem.onStart()
    if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        if (smasBooleans.isInLevel and not table.icontains(smasTables.__smbspencerLevels,Level.filename())) then
            smasZoomSystem.isOnClassicLevel = true
            --handycam[1].zoom = 1.5625 --SNES resolution
        end
    end
end

return smasZoomSystem