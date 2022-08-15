local smasextraactions = {}

function smasextraactions.onInitAPI()
    registerEvent(smasextraactions,"onInputUpdate")
    registerEvent(smasextraactions,"onPostNPCKill")
end

function smasextraactions.onInputUpdate()
    if not SaveData.disableX2char then
        for _,p in ipairs(Player.get()) do
            --Faster climbing when holding run
            if p.climbing and p.forcedState == 0 and p.deathTimer == 0 then
                if p.keys.run then
                    if p.keys.left then
                        p.x = p.x - 1.5
                    elseif p.keys.right then
                        p.x = p.x + 1.5
                    end
                end
            end
        end
    end
end

function smasextraactions.onPostNPCKill(killedNPC, harmType, culprit)
    if not SaveData.disableX2char then
        if harmType == HARM_TYPE_SPINJUMP and type(culprit) == "Player" then
            if culprit.keys.jump or culprit.keys.altJump then
                culprit.speedY = -Defines.jumpheight_bounce
            end
        end
    end
end

return smasextraactions