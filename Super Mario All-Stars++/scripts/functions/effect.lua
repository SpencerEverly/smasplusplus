local Effectx = {}

function Effectx.spawnScoreEffect(scoreNumber, xPos, yPos)
    return Misc.givePoints(scoreNumber, vector(xPos, yPos))
end

return Effectx