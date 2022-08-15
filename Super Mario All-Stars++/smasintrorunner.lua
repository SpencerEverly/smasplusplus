local smasintrorunner = {}

local smasbooleans = require("smasbooleans")

local introtime = 0
local jumptime = 0
local activatejump = false

local threeplayermode = false
local fourplayermode = false

function smasintrorunner.onInitAPI()
    registerEvent(smasintrorunner,"onDraw")
    registerEvent(smasintrorunner,"onInputUpdate")
    registerEvent(smasintrorunner,"onStart")
end

function smasintrorunner.onInputUpdate()
    if smasbooleans.introModeActivated then
        local playernumber = rng.randomInt(1,6)
        for i = 2,Player.count() do
            for k,_ in pairs(player.keys) do
                Player(i).keys[k] = not Player(1).keys[k]
            end
            Player(i).keys.left = false
            Player(i).keys.right = true --These keys are force-held like the og intro
            Player(i).keys.run = true
        end
        if Player(i).powerup == 4 or Player(i).powerup == 5 then --If leaf or tanooki, fly down when flying
            if Player(i):mem(0x16E, FIELD_BOOL, true) then
                Player(i).keys.jump = true
            end
        end
        if Player(i):mem(0x11C, FIELD_WORD) >= 1 then --Jump momentum detection
            Player(i).keys.jump = true
        end
        if activatejump then
            Player(playernumber).keys.jump = true
        end
    end
    if threeplayermode then
        for k,p in ipairs(Player.get()) do
            if Player.count() >= 2 then
                
            end
            if Player(3) and Player(3).isValid then
                
            end
        end
    end
end

function smasintrorunner.onDraw()
    if smasbooleans.introModeActivated then
        introtime = introtime - 3
        jumptime = 29
        for i = 1,6 do
            Player(i).direction = 1 --Direction is always right
            if introtime <= 0 then
                introtime = rng.randomInt(1,120)
                activatejump = true
            end
            if activatejump then
                jumptime = jumptime - 1
                if jumptime <= 0 then
                    jumptime = 29
                    activatejump = false
                end
            end
        end
    end
end

return smasintrorunner