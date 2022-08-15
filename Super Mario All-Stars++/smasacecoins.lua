local smasacecoins = {}

local playerManager = require("playermanager")

function smasacecoins.onInitAPI()
    registerEvent(smasacecoins,"onTick")
end

function smasacecoins.onTick()
    if table.icontains(smastables.__smb2Levels,Level.filename()) == true then
        if NPC.config[274].score == 11 then
            Sound.playSFX(147)
            NPC.config[274].score = 6
        end
    elseif Level.filename() then
        if NPC.config[274].score == 11 then
            NPC.config[274].score = 6 --Nothing plays btw, just resets
        end
    end
end

return smasacecoins