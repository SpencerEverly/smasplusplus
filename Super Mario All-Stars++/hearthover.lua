local hearthover = {}

hearthover.active = true

local textplus = require("textplus")
local playerManager = require("playermanager")
local smbxdefault = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus.ini")

local ready = false

function hearthover.onInitAPI() --This requires all the libraries that will be used
    registerEvent(hearthover, "onDraw")
    registerEvent(hearthover, "onExit")
    registerEvent(hearthover, "onTick")
    
    ready = true
end

function hearthover.onTick()
    if hearthover.active == true then
        if player.powerup == 1 then
            
        end
    end
end

function hearthover.onDraw()
    if hearthover.active == true then
        if SaveData.currentCostume == "SPONGEBOBSQUAREPANTS" then
            local heartfull = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/heartfull.png")
            local heartempty = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/heartempty.png")
            local leaficon = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/leafhud.png")
            local tanookiicon = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/tanookihud.png")
            local hammericon = Graphics.loadImageResolved("costumes/mario/SpongeBobSquarePants/hammerhud.png")
            if player.deathTimer >= 0 then
                Graphics.drawImageWP(heartempty, player.x - camera.x - 34,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty, player.x - camera.x - 6,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty, player.x - camera.x + 22,  player.y - camera.y - 55, -24)
            end
            if player.powerup == 1 then
                Graphics.drawImageWP(heartfull, player.x - camera.x - 34,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty, player.x - camera.x - 6,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty, player.x - camera.x + 22,  player.y - camera.y - 55, -24)
            end
            if player.powerup == 2 then
                Graphics.drawImageWP(heartfull, player.x - camera.x - 34,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x - 6,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty, player.x - camera.x + 22,  player.y - camera.y - 55, -24)
            end
            if player.powerup == 3 then
                Graphics.drawImageWP(heartfull, player.x - camera.x - 34,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x - 6,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x + 22,  player.y - camera.y - 55, -24)
            end
            if player.powerup == 4 then
                Graphics.drawImageWP(heartfull, player.x - camera.x - 34,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x - 6,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x + 22,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(leaficon, player.x - camera.x - 3,  player.y - camera.y - 74, -24)
            end
            if player.powerup == 5 then
                Graphics.drawImageWP(heartfull, player.x - camera.x - 34,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x - 6,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x + 22,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(tanookiicon, player.x - camera.x - 3,  player.y - camera.y - 74, -24)
            end
            if player.powerup == 6 then
                Graphics.drawImageWP(heartfull, player.x - camera.x - 34,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x - 6,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x + 22,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(hammericon, player.x - camera.x - 3,  player.y - camera.y - 74, -24)
            end
            if player.powerup == 7 then
                Graphics.drawImageWP(heartfull, player.x - camera.x - 34,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x - 6,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull, player.x - camera.x + 22,  player.y - camera.y - 55, -24)
            end
        end
        if SaveData.currentCostume == "SEE-TANGENT" then
            local heartfull2 = Graphics.loadImageResolved("costumes/toad/SEE-Tangent/heartfull.png")
            local heartempty2 = Graphics.loadImageResolved("costumes/toad/SEE-Tangent/heartempty.png")
            if player.deathTimer >= 0 then
                Graphics.drawImageWP(heartempty2, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty2, player.x - camera.x,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty2, player.x - camera.x + 28,  player.y - camera.y - 55, -24)
            end
            if player.powerup == 1 then
                Graphics.drawImageWP(heartfull2, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty2, player.x - camera.x,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty2, player.x - camera.x + 28,  player.y - camera.y - 55, -24)
            end
            if player.powerup == 2 then
                Graphics.drawImageWP(heartfull2, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull2, player.x - camera.x,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartempty2, player.x - camera.x + 28,  player.y - camera.y - 55, -24)
            end
            if player.powerup >= 3 then
                Graphics.drawImageWP(heartfull2, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull2, player.x - camera.x,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull2, player.x - camera.x + 28,  player.y - camera.y - 55, -24)
            end
        end
        if SaveData.currentCostume == "GA-CAILLOU" then
            local heartfull3 = Graphics.loadImageResolved("costumes/luigi/GA-Boris/heart.png")
            if player.deathTimer >= 0 then
                
            end
            if player.powerup == 1 then
                Graphics.drawImageWP(heartfull3, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
            end
            if player.powerup == 2 then
                Graphics.drawImageWP(heartfull3, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull3, player.x - camera.x,  player.y - camera.y - 55, -24)
            end
            if player.powerup >= 3 then
                Graphics.drawImageWP(heartfull3, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull3, player.x - camera.x,  player.y - camera.y - 55, -24)
                Graphics.drawImageWP(heartfull3, player.x - camera.x + 28,  player.y - camera.y - 55, -24)
            end
        end
    end
end

return hearthover