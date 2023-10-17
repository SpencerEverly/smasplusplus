local level_dependencies_normal = require("level_dependencies_normal")

local fadeActive = false
local fadeActive2 = false

local opacityTimer = 0

function onEvent(eventName)
    if eventName == "Start Roulette" then
        fadeActive = true
        Sound.playSFX(28)
    end
end

function onDraw()
    if fadeActive then
        if opacityTimer < 1 then
            opacityTimer = opacityTimer + 0.05
        elseif opacityTimer >= 1 then
            fadeActive2 = true
            fadeActive = false
        end
        Graphics.drawScreen{color = Color.black .. opacityTimer, priority = 10}
    end
    if fadeActive2 then
        if opacityTimer >= 1 then
            
        end
        if opacityTimer > 0 then
            opacityTimer = opacityTimer - 0.05
        elseif opacityTimer <= 0 then
            fadeActive2 = false
        end
        Graphics.drawScreen{color = Color.black .. opacityTimer, priority = 10}
    end
end