local smasfireballs = {}

function smasfireballs.onInitAPI()
    registerEvent(smasfireballs,"onNPCKill")
    registerEvent(smasfireballs,"onPostNPCHarm")
    registerEvent(smasfireballs,"onDrawEnd")
end

local fireballtimer = 0

function smasfireballs.onPostNPCHarm(npc, harmType)
    if SaveData.currentCostume == "MODERN2" then
        if npc.id == 13 then
            if harmType == HARM_TYPE_PROJECTILE_USED then
                Audio.sounds[3].muted = true
                fireballtimer = 2
            end
        end
    end
end

function smasfireballs.onDrawEnd()
    if SaveData.currentCostume == "MODERN2" then
        if fireballtimer > 0 then
            fireballtimer = fireballtimer - 1
            if fireballtimer == 0 then
                Audio.sounds[3].muted = false
            end
        end
    end
end

return smasfireballs