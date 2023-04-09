local smasFireballs = {}

function smasFireballs.onInitAPI()
    registerEvent(smasFireballs,"onNPCKill")
    registerEvent(smasFireballs,"onPostNPCHarm")
    registerEvent(smasFireballs,"onDrawEnd")
end

local fireballtimer = 0
local iceballtimer = 0

function smasFireballs.onPostNPCHarm(npc, harmType)
    if SaveData.currentCostume == "MODERN2" then
        if npc.id == 13 then
            if harmType == HARM_TYPE_PROJECTILE_USED then
                Audio.sounds[3].muted = true
                fireballtimer = 2
            end
        end
        if npc.id == 265 then
            if harmType == HARM_TYPE_NPC then
                Audio.sounds[3].muted = true
                iceballtimer = 2
            end
            if harmType == HARM_TYPE_PROJECTILE_USED then
                Audio.sounds[3].muted = true
                iceballtimer = 2
            end
        end
    end
end

function smasFireballs.onDrawEnd()
    if SaveData.currentCostume == "MODERN2" then
        if fireballtimer > 0 then
            fireballtimer = fireballtimer - 1
            if fireballtimer == 0 then
                Audio.sounds[3].muted = false
            end
        end
        if iceballtimer > 0 then
            iceballtimer = iceballtimer - 1
            if iceballtimer == 1 then
                SFX.play("costumes/mario/Modern2/iceball-hit.ogg")
            end
            if iceballtimer == 0 then
                Audio.sounds[3].muted = false
            end
        end
    end
end

return smasFireballs