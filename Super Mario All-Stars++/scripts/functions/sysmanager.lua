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
        return mem(0x00B2C5AC, FIELD_FLOAT)
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
        return mem(0x00B2C5AC, FIELD_FLOAT)
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

if Misc.inSuperMarioAllStarsPlusPlus() then
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
end
    
function SysManager.starCount() --This lists the count of the stars
    if SaveData.totalStarCount == nil then
        return mem(0x00B251E0, FIELD_WORD)
    else
        return SaveData.totalStarCount
    end
end

function SysManager.scoreCount() --Returns the score count.
    if SaveData.totalScoreClassic == nil then
        return Misc.score()
    else
        return SaveData.totalScoreClassic
    end
end

function SysManager.scoreCountWithZeroes() --Returns the score count with zeroes.
    if SaveData.totalScoreClassic == nil then
        return Misc.score()
    elseif SaveData.totalScoreClassic >= 0 then
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
    if SaveData.totalScoreClassic == nil then
        return Misc.score()
    elseif SaveData.totalScoreClassic <= 9999999 then
        return SaveData.totalScoreClassic
    elseif SaveData.totalScoreClassic >= 9999999 then
        return 9999999
    end
end

function SysManager.coinCountClassic() --Returns the classic coin count.
    if SaveData.totalCoinsClassic == nil then
        return mem(0x00B2C5A8, FIELD_WORD)
    else
        return SaveData.totalCoinsClassic
    end
end

function SysManager.coinCountClassicWith99Limit() --Returns the classic coin count, but with a 99 coin limiter when above 100.
    if SaveData.totalScoreClassic == nil then
        return mem(0x00B2C5A8, FIELD_WORD)
    elseif SaveData.totalCoinsClassic < 100 then
        return SaveData.totalCoinsClassic
    elseif SaveData.totalCoinsClassic >= 100 then
        return 99
    end
end

function SysManager.loadIntroTheme() --Loads the theme after execution. If setting a new intro, set the intro number first before executing. 
    if SaveData.introselect == 1 then
        Level.load("intro_SMAS.lvlx", nil, nil)
    end
    if SaveData.introselect == 2 then
        Level.load("intro_SMBX1.0.lvlx", nil, nil)
    end
    if SaveData.introselect == 3 then
        Level.load("intro_SMBX1.1.lvlx", nil, nil)
    end
    if SaveData.introselect == 4 then
        Level.load("intro_SMBX1.2.lvlx", nil, nil)
    end
    if SaveData.introselect == 5 then
        Level.load("intro_SMBX1.3.lvlx", nil, nil)
    end
    if SaveData.introselect == 6 then
        Level.load("intro_WSMBA.lvlx", nil, nil)
    end
    if SaveData.introselect == 7 then
        Level.load("intro_SMBX2.lvlx", nil, nil)
    end
    if SaveData.introselect == 8 then
        Level.load("intro_theeditedboss.lvlx", nil, nil)
    end
    if SaveData.introselect == 9 then
        Level.load("intro_SMBX1.3og.lvlx", nil, nil)
    end
    if SaveData.introselect == 10 then
        Level.load("intro_SMBX2b3.lvlx", nil, nil)
    end
    if SaveData.introselect == 11 then
        Level.load("intro_8bit.lvlx", nil, nil)
    end
    if SaveData.introselect == 12 then
        Level.load("intro_S!TS!.lvlx", nil, nil)
    end
    if SaveData.introselect == 13 then
        Level.load("intro_sunsetbeach.lvlx", nil, nil)
    end
    if SaveData.introselect == 14 then
        Level.load("intro_scrollingheights.lvlx", nil, nil)
    end
    if SaveData.introselect == 15 then
        Level.load("intro_jakebrito1.lvlx", nil, nil)
    end
    if SaveData.introselect == 16 then
        Level.load("intro_marioforever.lvlx", nil, nil)
    end
    if SaveData.introselect == 17 then
        Level.load("intro_jakebrito2.lvlx", nil, nil)
    end
    if SaveData.introselect == 18 then
        Level.load("intro_circuitcity.lvlx", nil, nil)
    end
    if SaveData.introselect == 19 then
        Level.load("intro_metroidprime2.lvlx", nil, nil)
    end
end

function SysManager.parseSMBX64Bool(string) --Parses a bool from a save file (Thanks KBM_Quine!)
    if string.match(string, "#TRUE#") then return true end
    if string.match(string, "#FALSE#") then return false end
end

function SysManager.parseSaveFile(slot) --Parses a save file (Thanks KBM_Quine!)
    local t = {}
    local savFile = Misc.resolveFile("save" .. slot ..".sav")
    local lines = io.readFileLines(savFile)
    local currentLine = 0
    local objectIndex = 1

    t.fileVersion = tonumber(lines[1])
    t.lives = tonumber(lines[2])
    t.coins = tonumber(lines[3])
    t.worldPlayerX = tonumber(lines[4])
    t.worldPlayerY = tonumber(lines[5])

    t.character = {}
    currentLine = 5
    for i=1,5 do
        t.character[i] = {}
        t.character[i].powerup = tonumber(lines[currentLine+1])
        t.character[i].reservePowerup = tonumber(lines[currentLine+2])
        t.character[i].mount = tonumber(lines[currentLine+3])
        t.character[i].mountColor = tonumber(lines[currentLine+4])
        t.character[i].hearts = tonumber(lines[currentLine+5])
        currentLine = currentLine + 5
    end

    t.overworldMusicID = tonumber(lines[31])
    t.gameCompleted = SysManager.parseSMBX64Bool(lines[32])

    t.levelVisiblity = {}
    currentLine = 33
    while (lines[currentLine] ~= '"next"') do
        t.levelVisiblity[objectIndex] = SysManager.parseSMBX64Bool(lines[currentLine])
        objectIndex = objectIndex + 1
        currentLine = currentLine + 1
    end

    t.pathVisiblity = {}
    currentLine = currentLine + 1
    objectIndex = 1
    while (lines[currentLine] ~= '"next"') do
        t.pathVisiblity[objectIndex] = SysManager.parseSMBX64Bool(lines[currentLine])
        objectIndex = objectIndex + 1
        currentLine = currentLine + 1
    end

    t.sceneryVisiblity = {}
    currentLine = currentLine + 1
    objectIndex = 1
    while (lines[currentLine] ~= '"next"') do
        t.sceneryVisiblity[objectIndex] = SysManager.parseSMBX64Bool(lines[currentLine])
        objectIndex = objectIndex + 1
        currentLine = currentLine + 1
    end

    t.stars = {}
    currentLine = currentLine + 1
    objectIndex = 1
    while (lines[currentLine] ~= '"next"') do
        t.stars[objectIndex] = {}
        t.stars[objectIndex].levelName = lines[currentLine]
        t.stars[objectIndex].section = tonumber(lines[currentLine + 1]) 
        objectIndex = objectIndex + 1
        currentLine = currentLine + 2
    end

    currentLine = currentLine + 1
    objectIndex = 1
    t.mapStarTotal = tonumber(lines[currentLine])

    return t
end

function SysManager.loadMap() --Loads the map, or the editor-specified area.
    if not Misc.inEditor() then
        Level.load("map.lvlx")
    elseif Misc.inEditor() then
        Level.load(SaveData.editorWinnerLevelReload)
    end
end

function SysManager.exitLevel(winType) --Exits a level with the win type specified.
    if not Misc.inMarioChallenge() then
        if winType >= 1 then
            SysManager.loadMap()
        end
        for _,p in ipairs(Player.get()) do
            if p:mem(0x15E, FIELD_WORD) >= 1 and p.forcedState == FORCEDSTATE_INVISIBLE then
                if Warp.get()[p:mem(0x15E, FIELD_WORD)].levelFilename == "" then
                    SysManager.loadMap()
                end
            end
        end
    end
end

function SysManager.clearSaveDataAndGameDataAndRestart()
    Text.windowDebugSimple("There WILL be a few errors before restarting. This is normal. Just click okay (Or press ENTER) on all dialog boxes that pop up, and the episode will restart.")
    SaveData.clear()
    GameData.clear()
    SaveData.flush()
    if not Misc.loadEpisode("Super Mario All-Stars++") then
        error("SMAS++ is not found. How is that even possible? Reinstall the game using the SMASUpdater, since something has gone terribly wrong.")
    end
end

return SysManager