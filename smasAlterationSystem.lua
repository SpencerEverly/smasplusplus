local smasAlterationSystem = {}

smasAlterationSystem.enableGraphicRevertation = false

local playerManager = require("playerManager")

function smasAlterationSystem.onInitAPI()
    registerEvent(smasAlterationSystem, "onDraw")
end

function smasAlterationSystem.characterAlterationChange(playerID)
    if SaveData.SMASPlusPlus.player[playerID].currentAlteration ~= "N/A" then
        for i = 1,7 do
            Graphics.sprites[playerManager.getName(Player(playerID).character)][i].img = Img.loadAlterationPose(playerManager.getName(Player(playerID).character).."-"..tostring(i)..".png")
        end
    else
        if smasAlterationSystem.enableGraphicRevertation then
            for i = 1,7 do
                Graphics.sprites[playerManager.getName(Player(playerID).character)][i].img = Img.loadCharacter(playerManager.getName(Player(playerID).character).."-"..tostring(i)..".png")
            end
        end
    end
end

return smasAlterationSystem