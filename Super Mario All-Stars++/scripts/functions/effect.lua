local Effectx = {}

function Effectx.spawnScoreEffect(scoreNumber, xPos, yPos)
    console:println("Score effect spawn, with the score number "..tostring(scoreNumber)..".")
    return Misc.givePoints(scoreNumber, vector(xPos, yPos))
end

return Effectx