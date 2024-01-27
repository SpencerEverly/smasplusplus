local SysManager = {}

local playerManager = require("playerManager")
local smasBooleans = require("smasBooleans")
local inspect = require("ext/inspect")

SysManager.languageCodes = {
    [1025] = "Arabic (Saudi Arabia)",
    [1026] = "Bulgarian",
    [1027] = "Catalan",
    [1028] = "Chinese (Taiwan)",
    [1029] = "Czech",
    [1030] = "Danish",
    [1031] = "German (Standard)",
    [1032] = "Greek",
    [1033] = "English (United States)",
    [1034] = "Spanish (Spain)",
    [1035] = "Finnish",
    [1036] = "French (Standard)",
    [1037] = "Hebrew",
    [1038] = "Hungarian",
    [1039] = "Icelandic",
    [1040] = "Italian (Standard)",
    [1041] = "Japanese",
    [1042] = "Korean",
    [1043] = "Dutch",
    [1044] = "Norwegian (Bokmål)",
    [1045] = "Polish",
    [1046] = "Portuguese (Brazil)",
    [1047] = "Raeto (Romance)",
    [1048] = "Romanian",
    [1049] = "Russian",
    [1050] = "Croatian",
    [1051] = "Slovak",
    [1052] = "Albanian",
    [1053] = "Swedish",
    [1054] = "Thai",
    [1055] = "Turkish",
    [1056] = "Urdu (Pakistan)",
    [1057] = "Indonesian",
    [1058] = "Ukranian",
    [1059] = "Belarusian",
    [1060] = "Slovenian",
    [1061] = "Estonian",
    [1062] = "Latvian",
    [1063] = "Lithuanian",
    [1065] = "Farsi",
    [1066] = "Vietnamese",
    [1069] = "Basque",
    [1070] = "Sorbian",
    [1071] = "Macedonian (FYROM)",
    [1072] = "Sutu",
    [1073] = "Tsonga",
    [1074] = "Setsuana",
    [1076] = "Xhosa",
    [1077] = "Zulu",
    [1078] = "Afrikaans",
    [1080] = "Faeroese",
    [1081] = "Hindi",
    [1082] = "Maltese",
    [1084] = "Gaelic (Scotland)",
    [1085] = "Yiddish",
    [1086] = "Malay (Malaysia)",
    [2049] = "Arabic (Iraq)",
    [2052] = "Chinese (PRC)",
    [2055] = "German (Switzerland)",
    [2057] = "English (United Kingdom)",
    [2058] = "Spanish (Mexico)",
    [2060] = "French (Belgium)",
    [2064] = "Italian (Switzerland)",
    [2067] = "Dutch (Belgium)",
    [2070] = "Portuguese (Portugal)",
    [2072] = "Romanian (Moldova)",
    [2073] = "Russian (Moldova)",
    [2077] = "Swedish (Finland)",
    [3073] = "Arabic (Egypt)",
    [3076] = "Chinese (Hong Kong SAR)",
    [3079] = "German (Austrian)",
    [3081] = "English (Australia)",
    [3084] = "French (Canada)",
    [3098] = "Serbian (Cyrillic)",
    [4097] = "Arabic (Libya)",
    [4100] = "Chinese (Singapore)",
    [4103] = "German (Luxembourg)",
    [4105] = "English (Canada)",
    [4106] = "Spanish (Guatemala)",
    [4108] = "French (Switzerland)",
    [5121] = "Arabic (Algeria)",
    [5127] = "German (Liechtenstein)",
    [5129] = "English (New Zealand)",
    [5130] = "Spanish (Costa Rica)",
    [5132] = "French (Luxembourg)",
    [6145] = "Arabic (Morocco)",
    [6153] = "English (Ireland)",
    [6154] = "Spanish (Panama)",
    [7169] = "Arabic (Tunisia)",
    [7177] = "English (South Africa)",
    [7178] = "Spanish (Dominican Republic)",
    [8193] = "Arabic (Oman)",
    [8201] = "English (Jamaica)",
    [8202] = "Spanish (Venezuela)",
    [9217] = "Arabic (Yemen)",
    [9226] = "Spanish (Columbia)",
    [10241] = "Arabic (Syria)",
    [10249] = "English (Belize)",
    [10250] = "Spanish (Peru)",
    [11265] = "Arabic (Jordan)",
    [11273] = "English (Trinidad)",
    [11274] = "Spanish (Argentina)",
    [12289] = "Arabic (Lebanon)",
    [12298] = "Spanish (Ecuador)",
    [13313] = "Arabic (Kuwait)",
    [13322] = "Spanish (Chile)",
    [14337] = "Arabic (U.A.E.)",
    [14346] = "Spanish (Uruguay)",
    [15361] = "Arabic (Bahrain)",
    [15370] = "Spanish (Paraguay)",
    [16385] = "Arabic (Qatar)",
    [16394] = "Spanish (Bolivia)",
    [17418] = "Spanish (El Salvador)",
    [18442] = "Spanish (Honduras)",
    [19466] = "Spanish (Nicaragua)",
    [20490] = "Spanish (Puerto Rico)",
}

function SysManager.onInitAPI()
    registerEvent(SysManager,"onTick")
end

--Lives

function SysManager.lifeCount() --This lists the current life count
    if SaveData.SMASPlusPlus.hud.lives == nil then
        return 0
    else
        return SaveData.SMASPlusPlus.hud.lives
    end
end

function SysManager.lifeCountWithCrowns() --This lists the current life count, with the crown system. Crowns will be with "!" instead of an actual crown symbol.
    if SaveData.SMASPlusPlus.hud.lives == nil then
        return mem(0x00B2C5AC, FIELD_FLOAT)
    elseif SaveData.SMASPlusPlus.hud.lives < 1000 then
        return SaveData.SMASPlusPlus.hud.lives
    elseif SaveData.SMASPlusPlus.hud.lives >= 1000 and SaveData.SMASPlusPlus.hud.lives <= 1009 then
        return string.format("!0%1d",tostring(SaveData.SMASPlusPlus.hud.lives):sub(3, 4))
    elseif SaveData.SMASPlusPlus.hud.lives >= 1010 and SaveData.SMASPlusPlus.hud.lives < 1100 then
        return string.format("!%2d",tostring(SaveData.SMASPlusPlus.hud.lives):sub(3, 4))
    elseif SaveData.SMASPlusPlus.hud.lives >= 1100 and SaveData.SMASPlusPlus.hud.lives < 1110 then
        return string.format("!!%1d",tostring(SaveData.SMASPlusPlus.hud.lives):sub(4, 4))
    elseif SaveData.SMASPlusPlus.hud.lives == 1110 then
        return "!!!"
    end
end

function SysManager.lifeCountWithCrownsAndZeroFailsafe() --This lists the current life count (With a less than or equal to 0 value if below -1), with the crown system. Crowns will be with "!" instead of an actual crown symbol.
    if SaveData.SMASPlusPlus.hud.lives == nil then
        return mem(0x00B2C5AC, FIELD_FLOAT)
    elseif SaveData.SMASPlusPlus.hud.lives < 0 then
        return 0
    elseif SaveData.SMASPlusPlus.hud.lives < 1000 then
        return SaveData.SMASPlusPlus.hud.lives
    elseif SaveData.SMASPlusPlus.hud.lives >= 1000 and SaveData.SMASPlusPlus.hud.lives <= 1009 then
        return string.format("!0%1d",tostring(SaveData.SMASPlusPlus.hud.lives):sub(3, 4))
    elseif SaveData.SMASPlusPlus.hud.lives >= 1010 and SaveData.SMASPlusPlus.hud.lives < 1100 then
        return string.format("!%2d",tostring(SaveData.SMASPlusPlus.hud.lives):sub(3, 4))
    elseif SaveData.SMASPlusPlus.hud.lives >= 1100 and SaveData.SMASPlusPlus.hud.lives < 1110 then
        return string.format("!!%1d",tostring(SaveData.SMASPlusPlus.hud.lives):sub(4, 4))
    elseif SaveData.SMASPlusPlus.hud.lives >= 1110 then
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
            SaveData.SMASPlusPlus.hud.lives = SaveData.SMASPlusPlus.hud.lives - lives
        elseif mathcount then
            SaveData.SMASPlusPlus.hud.lives = SaveData.SMASPlusPlus.hud.lives + lives
        end
    end

    function SysManager.maxOutLives() --This maxes out the lives to 1110 (All three crowns).
        Sound.playSFX(98)
        SaveData.SMASPlusPlus.hud.lives = 1110
        SysManager.sendToConsole("Lives are now maxed out.")
    end

    function SysManager.resetLives() --This resets the lives back to 5
        Sound.playSFX(67)
        SaveData.SMASPlusPlus.hud.lives = 5
        SysManager.sendToConsole("Lives have been reset.")
    end

    --Death Count

    function SysManager.deathCount() --This lists the current life count
        if SaveData.SMASPlusPlus.hud.deathCount == nil then
            return 0
        else
            return SaveData.SMASPlusPlus.hud.deathCount
        end
    end

    function SysManager.maxOutDeathCount() --This maxes out the death count to 999
        Sound.playSFX(67)
        SaveData.SMASPlusPlus.hud.deathCount = 999
        SysManager.sendToConsole("Death count is now maxed out.")
    end

    function SysManager.resetDeathCount() --This resets the death count back to 0
        Sound.playSFX(98)
        SaveData.SMASPlusPlus.hud.deathCount = 0
        SysManager.sendToConsole("Death count has been reset.")
    end
    
    --Star Count
    
    function SysManager.maxOutStars() --This maxs the star count to 9999
        SaveData.totalStarCount = 9999
        SysManager.sendToConsole("Star count is now maxed out.")
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
        SysManager.sendToConsole("Star count has been reset and cleared. All level completion status has also been deleted.")
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
    if SaveData.SMASPlusPlus.hud.score == nil then
        return 0
    else
        return SaveData.SMASPlusPlus.hud.score
    end
end

function SysManager.scoreCountWithZeroes() --Returns the score count with zeroes.
    if SaveData.SMASPlusPlus.hud.score == nil then
        return tostring(000000000)
    elseif SaveData.SMASPlusPlus.hud.score >= 0 then
        return string.format("%000000009d",tostring(SaveData.SMASPlusPlus.hud.score))
    elseif SaveData.SMASPlusPlus.hud.score >= 9 then
        return string.format("%00000008d",tostring(SaveData.SMASPlusPlus.hud.score))
    elseif SaveData.SMASPlusPlus.hud.score >= 99 then
        return string.format("%0000007d",tostring(SaveData.SMASPlusPlus.hud.score))
    elseif SaveData.SMASPlusPlus.hud.score >= 999 then
        return string.format("%000006d",tostring(SaveData.SMASPlusPlus.hud.score))
    elseif SaveData.SMASPlusPlus.hud.score >= 9999 then
        return string.format("%00005d",tostring(SaveData.SMASPlusPlus.hud.score))
    elseif SaveData.SMASPlusPlus.hud.score >= 99999 then
        return string.format("%0004d",tostring(SaveData.SMASPlusPlus.hud.score))
    elseif SaveData.SMASPlusPlus.hud.score >= 999999 then
        return string.format("%003d",tostring(SaveData.SMASPlusPlus.hud.score))
    elseif SaveData.SMASPlusPlus.hud.score >= 9999999 then
        return string.format("%02d",tostring(SaveData.SMASPlusPlus.hud.score))
    elseif SaveData.SMASPlusPlus.hud.score >= 99999999 then
        return string.format("%1d",tostring(SaveData.SMASPlusPlus.hud.score))
    elseif SaveData.SMASPlusPlus.hud.score >= 999999999 then
        return tostring(SaveData.SMASPlusPlus.hud.score)
    end
end

function SysManager.scoreCount13() --Returns the score count limited within 1.3 Mode's digit numbers.
    if SaveData.SMASPlusPlus.hud.score == nil then
        return 0000000
    elseif SaveData.SMASPlusPlus.hud.score <= 9999999 then
        return SaveData.SMASPlusPlus.hud.score
    elseif SaveData.SMASPlusPlus.hud.score >= 9999999 then
        return 9999999
    end
end

function SysManager.coinCountClassic() --Returns the classic coin count.
    if SaveData.SMASPlusPlus.hud.coinsClassic == nil then
        return 0
    else
        return SaveData.SMASPlusPlus.hud.coinsClassic
    end
end

function SysManager.coinCountClassicWith99Limit() --Returns the classic coin count, but with a 99 coin limiter when above 100.
    if SaveData.SMASPlusPlus.hud.score == nil then
        return mem(0x00B2C5A8, FIELD_WORD)
    elseif SaveData.SMASPlusPlus.hud.coinsClassic < 100 then
        return SaveData.SMASPlusPlus.hud.coinsClassic
    elseif SaveData.SMASPlusPlus.hud.coinsClassic >= 100 then
        return 99
    end
end

function SysManager.loadIntroTheme() --Loads the theme after execution. If setting a new intro, set the intro number first before executing.
    SysManager.sendToConsole("Loading intro theme...")
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
    SysManager.sendToConsole("Loading world map...")
    if not Misc.inEditor() then
        Level.load("map.lvlx")
    elseif Misc.inEditor() then
        Level.load(SaveData.editorWinnerLevelReload)
    end
end

function SysManager.exitLevel(winType) --Exits a level with the win type specified.
    if not Misc.inMarioChallenge() then
        for _,p in ipairs(Player.get()) do
            if not (p:mem(0x15E, FIELD_WORD) >= 1 and p.forcedState == FORCEDSTATE_INVISIBLE) then
                if winType >= 1 then
                    SysManager.sendToConsole("You won! You got the win type "..tostring(winType)..".")
                    SysManager.loadMap()
                end
            else
                SysManager.sendToConsole("This warp has a level warp point. Warping to "..Warp.get()[p:mem(0x15E, FIELD_WORD) - 1].levelFilename.."...")
                local warp = p:mem(0x15E, FIELD_WORD) - 1
                EventManager.callEvent("onWarpToOtherLevel", warp, p)
                SysManager.exitLevelToWarpPoint(warp)
            end
        end
    end
end

function SysManager.exitLevelToWarpPoint(warp)
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) >= warp and p.forcedState == FORCEDSTATE_INVISIBLE then
            if (Warp.get()[warp].levelFilename == "" or Warp.get()[warp].levelFilename == nil) then
                SysManager.loadMap()
            else
                Level.load(Warp.get()[warp].levelFilename)
            end
        end
    end
end

function SysManager.clearSaveDataAndGameDataAndRestart()
    Text.windowDebugSimple("There WILL be a few errors before restarting. This is normal. Just click okay (Or press ENTER) on all dialog boxes that pop up, and the episode will restart.")
    SaveData.clear()
    GameData.clear()
    SaveData.flush()
    SysManager.sendToConsole("All SaveData/GameData values are cleared. Initating game restart...")
    if not Misc.loadEpisode("Super Mario All-Stars++") then
        error("SMAS++ is not found. How is that even possible? Reinstall the game using the SMASUpdater, since something has gone terribly wrong.")
    end
end

function SysManager.loadDefaultCharacterIni()
    return (Misc.episodePath()..playerManager.getName(player.character).."-"..player.powerup..".ini"
        or Misc.levelPath()..playerManager.getName(player.character).."-"..player.powerup..".ini"
        or getSMBXPath().."config/character_defaults/"..playerManager.getName(player.character).."-"..player.powerup..".ini"
    )
end

function SysManager.getEnteredCheckpointID()
    if Checkpoint.getActive() ~= nil then
        return Checkpoint.getActive().id
    else
        return 0
    end
end

function SysManager.startingAtStartPoint()
    if Checkpoint.getActive() ~= nil then
        return false
    elseif Checkpoint.getActive() == nil then
        for _,p in ipairs(Player.get()) do
            if Playur.currentWarp(p) == 0 then
                return true
            end
        end
    end
end

function SysManager.numberTableToNumbersWithCommas(tablel)
    local epic = table.concat(tablel,",")
    return epic
end

function SysManager.getDefaultPlayerUsername()
    local name = string.match(getSMBXPath(),[[^C:\Users\([^%\]+)\]])
    if name == nil then
        name = "Player"
    end
    return name
end

function SysManager.totalStarsLeftForTrueEnding()
    local stars = (200 - SaveData.totalStarCount)
    if stars < 0 then
        return 0
    else
        return stars
    end
end

function SysManager.isOutsideOfUnplayeredAreas()
    return (
        (
            smasBooleans.isInLevel
            or smasBooleans.isInHub
        )
        and not smasBooleans.isOnMainMenu
        and not (
            GameData.gameFirstLoaded
            or GameData.gameFirstLoaded == nil
        )
        and not smasBooleans.isInClassicBattleMode
    )
end

function SysManager.loadLevel(levelFilename, warpIdx)
    -- 0 means default warp index
    if warpIdx == nil then
        warpIdx = 0
    end
    
    -- Set teleport destination
    mem(0x00B2C6DA, FIELD_WORD, warpIdx)    -- GM_NEXT_LEVEL_WARPIDX
    mem(0x00B25720, FIELD_STRING, levelFilename) -- GM_NEXT_LEVEL_FILENAME
    
    -- Force modes such that we trigger level exit
    mem(0x00B250B4, FIELD_WORD, 0)  -- GM_IS_EDITOR_TESTING_NON_FULLSCREEN
    mem(0x00B25134, FIELD_WORD, 0)  -- GM_ISLEVELEDITORMODE
    mem(0x00B2C89C, FIELD_WORD, 0)  -- GM_CREDITS_MODE
    mem(0x00B2C620, FIELD_WORD, 0)  -- GM_INTRO_MODE
    mem(0x00B2C5B4, FIELD_WORD, -1) -- GM_EPISODE_MODE (set to leave level)
end

function SysManager.sendToConsole(data)
    return console:println(tostring(data))
end

SysManager.editorValues = {
    [1] = {oldStr = "ID:", newStr = "id"},
    [2] = {oldStr = "X:", newStr = "x"},
    [3] = {oldStr = "Y:", newStr = "y"},
    [4] = {oldStr = "D:", newStr = "direction"},
    [5] = {oldStr = "FD:", newStr = "friendly"},
    [6] = {oldStr = "NM:", newStr = "dontMove"},
    [7] = {oldStr = "BS:", newStr = "legacyBoss"},
    [8] = {oldStr = "MG:", newStr = "message"},
    [9] = {oldStr = "GE:", newStr = "generatorEnabled"},
    [10] = {oldStr = "GD:", newStr = "generatorDirection"},
    [11] = {oldStr = "GM:", newStr = "generatorWaitTime"},
    [12] = {oldStr = "GT:", newStr = "generatorType"},
    [13] = {oldStr = "LR:", newStr = "currentLayer"},
    [14] = {oldStr = "LA:", newStr = "attachToLayer"},
    [15] = {oldStr = "EA:", newStr = "eventActivate"},
    [16] = {oldStr = "ED:", newStr = "eventDeath"},
    [17] = {oldStr = "ET:", newStr = "eventTalk"},
    [18] = {oldStr = "EE:", newStr = "eventLayerEmpty"},
    [19] = {oldStr = "W:", newStr = "width"},
    [20] = {oldStr = "H:", newStr = "height"},
}

SysManager.editorValuesNPCAllValues = {
    ["id"] = 0,
    ["x"] = 0,
    ["y"] = 0,
    ["direction"] = -1,
    ["friendly"] = 0,
    ["dontMove"] = 0,
    ["legacyBoss"] = 0,
    ["message"] = "",
    ["generatorEnabled"] = 0,
    ["generatorDirection"] = 0,
    ["generatorWaitTime"] = 0,
    ["generatorType"] = 1,
    ["currentLayer"] = "Default",
    ["attachToLayer"] = "",
    ["eventActivate"] = "",
    ["eventDeath"] = "",
    ["eventTalk"] = "",
    ["eventLayerEmpty"] = "",
}

SysManager.editorValuesBlockAllValues = {
    ["id"] = 0,
    ["x"] = 0,
    ["y"] = 0,
    ["direction"] = -1,
    ["friendly"] = 0,
    ["dontMove"] = 0,
    ["legacyBoss"] = 0,
    ["message"] = "",
    ["generatorEnabled"] = 0,
    ["generatorDirection"] = 0,
    ["generatorWaitTime"] = 0,
    ["generatorType"] = 1,
    ["currentLayer"] = "Default",
    ["attachToLayer"] = "",
    ["eventActivate"] = "",
    ["eventDeath"] = "",
    ["eventTalk"] = "",
    ["eventLayerEmpty"] = "",
}

SysManager.editorMessageValuesToReplace = {
    [1] = {oldStr = "\\,", newStr = ","},
    [2] = {oldStr = "\\\"", newStr = "\""},
    [3] = {oldStr = "\\n", newStr = "/n"},
    [4] = {oldStr = "\"", newStr = ""},
}

function SysManager.checkEditorEntity()
    if SMBX_VERSION == VER_SEE_MOD and Misc.inEditor() then
        local placedItem = Misc.getEditorPlacedItem()
        if placedItem == "nil" then return {} end

        local draftTable = {}
        local finalTable = {}
        
        local splitValues

        local tbl = json.decode(placedItem)
        for values in tbl.sendItemPlacing:gmatch("([^\n]+)") do 
            table.insert(draftTable, values)
        end
        
        splitValues = Tabled.splitString(draftTable[2], ";")
        
        if draftTable[1] ~= "nil" then
            for i = 1,#SysManager.editorValues do
                local tempValue = SysManager.editorValues[i]
                local tempIndex = Tabled.findStringPartFromTable(splitValues, SysManager.editorValues[i].oldStr, true)
                if tempIndex ~= nil then
                    local tempStr = string.gsub(splitValues[tempIndex], SysManager.editorValues[i].oldStr, "")
                    draftTable[tempValue.newStr] = tempStr
                end
            end
            
            if draftTable[1] == "NPC" then
                if draftTable.direction == nil then
                    draftTable.direction = SysManager.editorValuesNPCAllValues["direction"]
                end
                if draftTable.friendly == nil then
                    draftTable.friendly = SysManager.editorValuesNPCAllValues["friendly"]
                end
                if draftTable.dontMove == nil then
                    draftTable.dontMove = SysManager.editorValuesNPCAllValues["dontMove"]
                end
                if draftTable.legacyBoss == nil then
                    draftTable.legacyBoss = SysManager.editorValuesNPCAllValues["legacyBoss"]
                end
                if draftTable.generatorEnabled == nil then
                    draftTable.generatorEnabled = SysManager.editorValuesNPCAllValues["generatorEnabled"]
                end
                if draftTable.generatorDirection == nil then
                    draftTable.generatorDirection = SysManager.editorValuesNPCAllValues["generatorDirection"]
                end
                if draftTable.generatorWaitTime == nil then
                    draftTable.generatorWaitTime = SysManager.editorValuesNPCAllValues["generatorWaitTime"]
                end
                if draftTable.generatorType == nil then
                    draftTable.generatorType = SysManager.editorValuesNPCAllValues["generatorType"]
                end
            end
            
            if draftTable[1] == "BLOCK" then
                if draftTable.width == nil then
                    draftTable.width = SysManager.editorValuesNPCAllValues["width"]
                end
                
                if draftTable.height == nil then
                    draftTable.height = SysManager.editorValuesNPCAllValues["height"]
                end
            end
            
            for i = 1,#SysManager.editorMessageValuesToReplace do
                if draftTable[1] == "NPC" then
                    if draftTable.message ~= nil then
                        draftTable.message = string.gsub(draftTable.message, SysManager.editorMessageValuesToReplace[i].oldStr, SysManager.editorMessageValuesToReplace[i].newStr)
                    else
                        draftTable.message = SysManager.editorValuesNPCAllValues["message"]
                    end
                    if draftTable.eventActivate ~= nil then
                        draftTable.eventActivate = string.gsub(draftTable.eventActivate, SysManager.editorMessageValuesToReplace[i].oldStr, SysManager.editorMessageValuesToReplace[i].newStr)
                    else
                        draftTable.eventActivate = SysManager.editorValuesNPCAllValues["eventActivate"]
                    end
                    if draftTable.eventDeath ~= nil then
                        draftTable.eventDeath = string.gsub(draftTable.eventDeath, SysManager.editorMessageValuesToReplace[i].oldStr, SysManager.editorMessageValuesToReplace[i].newStr)
                    else
                        draftTable.eventDeath = SysManager.editorValuesNPCAllValues["eventDeath"]
                    end
                    if draftTable.eventTalk ~= nil then
                        draftTable.eventTalk = string.gsub(draftTable.eventTalk, SysManager.editorMessageValuesToReplace[i].oldStr, SysManager.editorMessageValuesToReplace[i].newStr)
                    else
                        draftTable.eventTalk = SysManager.editorValuesNPCAllValues["eventTalk"]
                    end
                    if draftTable.eventLayerEmpty ~= nil then
                        draftTable.eventLayerEmpty = string.gsub(draftTable.eventLayerEmpty, SysManager.editorMessageValuesToReplace[i].oldStr, SysManager.editorMessageValuesToReplace[i].newStr)
                    else
                        draftTable.eventLayerEmpty = SysManager.editorValuesNPCAllValues["eventLayerEmpty"]
                    end
                    if draftTable.attachToLayer ~= nil then
                        draftTable.attachToLayer = string.gsub(draftTable.attachToLayer, SysManager.editorMessageValuesToReplace[i].oldStr, SysManager.editorMessageValuesToReplace[i].newStr)
                    else
                        draftTable.attachToLayer = SysManager.editorValuesNPCAllValues["attachToLayer"]
                    end
                end
                
                if draftTable.currentLayer ~= nil then
                    draftTable.currentLayer = string.gsub(draftTable.currentLayer, SysManager.editorMessageValuesToReplace[i].oldStr, SysManager.editorMessageValuesToReplace[i].newStr)
                else
                    draftTable.currentLayer = SysManager.editorValuesNPCAllValues["currentLayer"]
                end
            end
            
            finalTable = {
                entityType = draftTable[1],
                id = tonumber(draftTable.id),
                x = tonumber(draftTable.x),
                y = tonumber(draftTable.y),
                width = tonumber(draftTable.width),
                height = tonumber(draftTable.height),
                direction = tonumber(draftTable.direction),
                friendly = tonumber(draftTable.friendly),
                dontMove = tonumber(draftTable.dontMove),
                legacyBoss = tonumber(draftTable.legacyBoss),
                message = draftTable.message,
                generatorEnabled = tonumber(draftTable.generatorEnabled),
                generatorDirection = tonumber(draftTable.generatorDirection),
                generatorWaitTime = tonumber(draftTable.generatorWaitTime),
                generatorType = tonumber(draftTable.generatorType),
                currentLayer = draftTable.currentLayer,
                attachToLayer = draftTable.attachToLayer,
                eventActivate = draftTable.eventActivate,
                eventDeath = draftTable.eventDeath,
                eventTalk = draftTable.eventTalk,
                eventLayerEmpty = draftTable.eventLayerEmpty,
            }
        end
        return finalTable
    else
        return {}
    end
end

return SysManager