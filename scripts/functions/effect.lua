local Effectx = {}

function Effectx.spawnScoreEffect(scoreNumber, xPos, yPos)
    SysManager.sendToConsole("Score effect spawned, with the score number "..tostring(scoreNumber)..".")
    return Misc.givePoints(scoreNumber, vector(xPos, yPos), true)
end

return Effectx