local SysManager = {}

--Lives

function SysManager.lifeCount() --This lists the current life count
    if SaveData.totalLives == nil then
        return 0
    else
        return SaveData.totalLives
    end
end

function SysManager.lifeCountWithCrowns() --This lists the current life count, with the crown system. Crowns will be with "!" instead of an actual crown symbol.
    if SaveData.totalLives == nil then
        return 0
    elseif SaveData.totalLives < 1000 then
        return SaveData.totalLives
    elseif SaveData.totalLives >= 1000 and SaveData.totalLives <= 1009 then
        return string.format("!0%1d",tostring(SaveData.totalLives):sub(3, 4))
    elseif SaveData.totalLives >= 1010 and SaveData.totalLives < 1100 then
        return string.format("!%2d",tostring(SaveData.totalLives):sub(3, 4))
    elseif SaveData.totalLives >= 1100 and SaveData.totalLives < 1110 then
        return string.format("!!%1d",tostring(SaveData.totalLives):sub(4, 4))
    elseif SaveData.totalLives == 1110 then
        return "!!!"
    end
end

function SysManager.lifeCountWithCrownsAndZeroFailsafe() --This lists the current life count (With a less than or equal to 0 value if below -1), with the crown system. Crowns will be with "!" instead of an actual crown symbol.
    if SaveData.totalLives == nil then
        return 0
    elseif SaveData.totalLives < 0 then
        return 0
    elseif SaveData.totalLives < 1000 then
        return SaveData.totalLives
    elseif SaveData.totalLives >= 1000 and SaveData.totalLives <= 1009 then
        return string.format("!0%1d",tostring(SaveData.totalLives):sub(3, 4))
    elseif SaveData.totalLives >= 1010 and SaveData.totalLives < 1100 then
        return string.format("!%2d",tostring(SaveData.totalLives):sub(3, 4))
    elseif SaveData.totalLives >= 1100 and SaveData.totalLives < 1110 then
        return string.format("!!%1d",tostring(SaveData.totalLives):sub(4, 4))
    elseif SaveData.totalLives >= 1110 then
        return "!!!"
    end
end

function SysManager.manageLives(lives, mathcount) --arg1 = number of lives, arg2 = to add (true) or subtract them (false)
    if lives == nil then
        error("You need to specify the number of lives.")
    end
    if mathcount == nil then
        error("You need to specify whenever to add (true) or subtract (false) the life count.")
    end
    if not mathcount then
        SaveData.totalLives = SaveData.totalLives - lives
    elseif mathcount then
        SaveData.totalLives = SaveData.totalLives + lives
    end
end

function SysManager.maxOutLives() --This maxes out the lives to 1110 (All three crowns).
    Sound.playSFX(98)
    SaveData.totalLives = 1110
end

function SysManager.resetLives() --This resets the lives back to 5
    Sound.playSFX(67)
    SaveData.totalLives = 5
end

--Death Count

function SysManager.deathCount() --This lists the current life count
    if SaveData.deathCount == nil then
        return 0
    else
        return SaveData.deathCount
    end
end

function SysManager.maxOutDeathCount() --This maxes out the death count to 999
    Sound.playSFX(67)
    SaveData.deathCount = 999
end

function SysManager.resetDeathCount() --This resets the death count back to 0
    Sound.playSFX(98)
    SaveData.deathCount = 0
end

--Star Count

function SysManager.starCount() --This lists the count of the stars
    if SaveData.totalStarCount == nil then
        return 0
    else
        return SaveData.totalStarCount
    end
end

function SysManager.maxOutStars() --This maxs the star count to 9999
    SaveData.totalStarCount = 9999
end

function SysManager.clearAllStars() --This clears all the stars, and even all the level tables
    Sound.playSFX(67)
    SaveData.totalStarCount = 0
    for k in pairs(SaveData.completeLevels) do
        SaveData.completeLevels[k] = nil
    end
    for k in pairs(SaveData.completeLevelsOptional) do
        SaveData.completeLevelsOptional[k] = nil
    end
    SaveData.completeLevels = {}
    SaveData.completeLevelsOptional = {}
end

function SysManager.manageStars(arg1, arg2) --arg1 = Number of stars, arg2 = To add or subtract them
    if arg1 == nil then
        error("You need to specify the number of stars.")
    end
    if arg2 == nil then
        error("You need to specify whenever to subtract or add the stars.")
    end
    if (arg1 ~= nil) and (arg2 ~= nil) then
        stars = arg1
        mathcount = arg2
    else
    end
    if mathcount == subtract then
        SaveData.totalStarCount = SaveData.totalStarCount - stars
    elseif mathcount == add then
        SaveData.totalStarCount = SaveData.totalStarCount + stars
    end
end

function SysManager.scoreCount() --Returns the score count.
    return SaveData.totalScoreClassic
end

function SysManager.scoreCountWithZeroes() --Returns the score count with zeroes.
    if SaveData.totalScoreClassic >= 0 then
        return string.format("%000000009d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 9 then
        return string.format("%00000008d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 99 then
        return string.format("%0000007d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 999 then
        return string.format("%000006d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 9999 then
        return string.format("%00005d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 99999 then
        return string.format("%0004d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 999999 then
        return string.format("%003d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 9999999 then
        return string.format("%02d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 99999999 then
        return string.format("%1d",tostring(SaveData.totalScoreClassic))
    elseif SaveData.totalScoreClassic >= 999999999 then
        return SaveData.totalScoreClassic
    end
end

function SysManager.scoreCount13() --Returns the score count limited within 1.3 Mode's digit numbers.
    if SaveData.totalScoreClassic <= 9999999 then
        return SaveData.totalScoreClassic
    elseif SaveData.totalScoreClassic >= 9999999 then
        return 9999999
    end
end

function SysManager.coinCountClassic() --Returns the classic coin count.
    return SaveData.totalCoinsClassic
end

function SysManager.coinCountClassicWith99Limit() --Returns the classic coin count, but with a 99 coin limiter when above 100.
    if SaveData.totalCoinsClassic < 100 then
        return SaveData.totalCoinsClassic
    elseif SaveData.totalCoinsClassic >= 100 then
        return 99
    end
end

return SysManager