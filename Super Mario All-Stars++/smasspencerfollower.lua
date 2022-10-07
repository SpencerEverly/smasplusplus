local smasspencerfollower = {}

if table.icontains(smastables.__smbspencerLevels,Level.filename()) == false then return end

local cc = require("scripts/cosmicClones/cosmicclones")
local playerManager = require("playerManager")

function smasspencerfollower.onInitAPI()
    registerEvent(smasspencerfollower,"onStart")
end

function smasspencerfollower.onStart()
    if not SaveData.disableX2char then
        if not (SaveData.currentCostume == "00-SPENCEREVERLY") then
            playerManager.setCostume(CHARACTER_LUIGI, "00-SpencerEverly")
            cc.activate(1, 25)
            if player.direction == 1 then
                --Img.draw("costumes/luigi/00-SpencerEverly/luigi-2.png", player.x - 50, player.y, true, true, -25, 1)
            else
                --Img.draw("costumes/luigi/00-SpencerEverly/luigi-2.png", player.x + 50, player.y, true, true, -25, 1)
            end
        end
    end
end

return smasspencerfollower