local smasAceCoins = {}

local playerManager = require("playermanager")

function smasAceCoins.onInitAPI()
    registerEvent(smasAceCoins,"onTick")
end

function smasAceCoins.onTick()
    if table.icontains(smasTables.__smb2Levels,Level.filename()) == true then
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

return smasAceCoins