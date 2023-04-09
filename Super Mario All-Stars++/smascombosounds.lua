local smasComboSounds = {}

function smasComboSounds.onInitAPI()
    registerEvent(smasComboSounds,"onPostNPCHarm")
end

local SCORE_ADDR = 0x00B2C8E4

function smasComboSounds.getScore()
    return Misc.score() + mem(SCORE_ADDR,FIELD_DWORD)
end

function smasComboSounds.getCombo(oldScore,oldLives)
    local scoreDifference = (getScore() - oldScore)
    
    return comboScores[scoreDifference] or 0
end

function smasComboSounds.onPostNPCHarm(npc, harmType)
    if harmType == HARM_TYPE_NPC then
        
    end
end

return smasComboSounds