local smascombosounds = {}

function smascombosounds.onInitAPI()
    registerEvent(smascombosounds,"onPostNPCHarm")
end

local SCORE_ADDR = 0x00B2C8E4

function smascombosounds.getScore()
    return Misc.score() + mem(SCORE_ADDR,FIELD_DWORD)
end

function smascombosounds.getCombo(oldScore,oldLives)
    local scoreDifference = (getScore() - oldScore)
    
    return comboScores[scoreDifference] or 0
end

function smascombosounds.onPostNPCHarm(npc, harmType)
    if harmType == HARM_TYPE_NPC then
        
    end
end

return smascombosounds