local smasSaveDataSystem = {}

--First time SaveData settings, for resolutions and other settings
if SaveData.SMASPlusPlus == nil then
    SaveData.SMASPlusPlus = {}
end
SaveData.SMASPlusPlus.options = SaveData.SMASPlusPlus.options or {}
SaveData.SMASPlusPlus.accessibility = SaveData.SMASPlusPlus.accessibility or {}
SaveData.SMASPlusPlus.hud = SaveData.SMASPlusPlus.hud or {}
SaveData.SMASPlusPlus.keys = SaveData.SMASPlusPlus.keys or {}
SaveData.SMASPlusPlus.audio = SaveData.SMASPlusPlus.audio or {}
SaveData.SMASPlusPlus.game = SaveData.SMASPlusPlus.game or {}
SaveData.SMASPlusPlus.player = SaveData.SMASPlusPlus.player or {}
SaveData.SMASPlusPlus.misc = SaveData.SMASPlusPlus.misc or {}
SaveData.SMASPlusPlus.levels = SaveData.SMASPlusPlus.levels or {}
SaveData.SMASPlusPlus.levels.complete = SaveData.SMASPlusPlus.levels.complete or {}
for i = 1,8 do
    SaveData.SMASPlusPlus.player[i] = SaveData.SMASPlusPlus.player[i] or {}
    SaveData.SMASPlusPlus.player[i].currentCostume = SaveData.SMASPlusPlus.player[i].currentCostume or "N/A"
    SaveData.SMASPlusPlus.player[i].currentAlteration = SaveData.SMASPlusPlus.player[i].currentAlteration or "N/A"
end

--**Player-related data**
--**Themes, resolutions**
if SaveData.SMASPlusPlus.options.resolution == nil then
    SaveData.SMASPlusPlus.options.resolution = "fullscreen"
end
if SaveData.SMASPlusPlus.options.clockTheme == nil then --Default clock theme is "normal"
    SaveData.SMASPlusPlus.options.clockTheme = "normal"
end
if SaveData.SMASPlusPlus.options.enableCRTFilter == nil then
    SaveData.SMASPlusPlus.options.enableCRTFilter = false
end

--**Hud stuff**
if SaveData.SMASPlusPlus.hud.coins == nil then --The total coin count, used outside of the classic coin count which counts all coins overall
    SaveData.SMASPlusPlus.hud.coins = 0
end
if SaveData.SMASPlusPlus.hud.deathCount == nil then --Death count! For outside 1.3 mode, and inside it
    SaveData.SMASPlusPlus.hud.deathCount = 0
end
if SaveData.SMASPlusPlus.hud.lives == nil then --The total lives used the for the episode.
    SaveData.SMASPlusPlus.hud.lives = 5
end
if SaveData.SMASPlusPlus.hud.coinsClassic == nil then --This will display a classic coin count for the episode
    SaveData.SMASPlusPlus.hud.coinsClassic = 0
end
if SaveData.SMASPlusPlus.hud.score == nil then --This will add a score counter which goes up to a trillion, cause why not
    SaveData.SMASPlusPlus.hud.score = 0
end
if SaveData.SMASPlusPlus.hud.reserve == nil then
    SaveData.SMASPlusPlus.hud.reserve = {}
end
for i = 1,200 do
    if SaveData.SMASPlusPlus.hud.reserve[i] == nil then
        SaveData.SMASPlusPlus.hud.reserve[i] = 0
    end
end
if SaveData.SMASPlusPlus.misc.totalCheatsExecuted == nil then --A tally number of cheats you have executed since the first cheat. This'll be an SEE Mod-only feature for now.
    SaveData.SMASPlusPlus.misc.totalCheatsExecuted = 0
end

--**1.3 Mode default setting**
if SaveData.SMASPlusPlus.game.onePointThreeModeActivated == nil then --This will make sure 1.3 Mode isn't enabled on first boot, which will also prevent errors
    SaveData.SMASPlusPlus.game.onePointThreeModeActivated = false
end



--**This is for the upgrade save thing**
if SaveData.firstBootMapPathFixed == nil then
    SaveData.firstBootMapPathFixed = false
end

--**Special button assignments**
if SaveData.specialbutton1stplayer == nil then --Special button (Controller), 1P
    SaveData.specialbutton1stplayer = 4
end
if SaveData.specialkey1stplayer == nil then --Special button (Keyboard), 1P
    SaveData.specialkey1stplayer = 68
end
if SaveData.specialbutton2ndplayer == nil then --Special button (Controller), 2P
    SaveData.specialbutton2ndplayer = 4
end
if SaveData.specialkey2ndplayer == nil then --Special button (Keyboard), 2P
    SaveData.specialkey2ndplayer = 68
end

--Music volume/SFX specifics
if GameData.____currentMusicVolume == nil then
    GameData.____currentMusicVolume = 60
end
if GameData.____sfxVolume == nil then
    GameData.____sfxVolume = 1
end

--Accessibility options
if SaveData.accessibilityTwirl == nil then
    SaveData.accessibilityTwirl = false
end
if SaveData.accessibilityWallJump == nil then
    SaveData.accessibilityWallJump = false
end
if SaveData.accessibilityInventory == nil then
    SaveData.accessibilityInventory = false
end
if SaveData.enableLives == nil then
    SaveData.enableLives = true
end
if SaveData.accessibilityGroundPound == nil then
    SaveData.accessibilityGroundPound = false
end

--Other stuff
if SaveData.openingComplete == nil then
    SaveData.openingComplete = false
end
if SaveData.currentLanguage == nil then
    SaveData.currentLanguage = "english"
end
if SaveData.enableIntros == nil then
    SaveData.enableIntros = true --Enable the intro here, or not
end
if SaveData.framerateEnabled == nil then
    SaveData.framerateEnabled = false
end
if SaveData.SMB1HardModeActivated == nil then
    SaveData.SMB1HardModeActivated = false
end
if SaveData.SMB1LLAllNightNipponActivated == nil then
    SaveData.SMB1LLAllNightNipponActivated = false
end
if SaveData.WSMBAOriginalGraphicsActivated == nil then
    SaveData.WSMBAOriginalGraphicsActivated = false
end
if SaveData.framerateEnabled == nil then
    SaveData.framerateEnabled = false
end
if SaveData.disablePWingSFX == nil then
    SaveData.disablePWingSFX = false
end
if SaveData.SMBXSoundSystem == nil then
    SaveData.SMBXSoundSystem = false
end
if SaveData.enableLives == nil then
    SaveData.enableLives = true
end





--Bring legacy SaveData values over to the new ones
if SaveData.currentCostume ~= nil then  
    SaveData.SMASPlusPlus.player[1].currentCostume = SaveData.currentCostume
    SaveData.currentCostume = nil
end
if SaveData.clockTheme ~= nil then
    SaveData.SMASPlusPlus.options.clockTheme = SaveData.clockTheme
    SaveData.clockTheme = nil
end
if SaveData.totalCoins ~= nil then
    SaveData.SMASPlusPlus.hud.coins = SaveData.totalCoins
    SaveData.totalCoins = nil
end
if SaveData.deathCount ~= nil then
    SaveData.SMASPlusPlus.hud.deathCount = SaveData.deathCount
    SaveData.deathCount = nil
end
if SaveData.totalLives ~= nil then
    SaveData.SMASPlusPlus.hud.lives = SaveData.totalLives
    SaveData.totalLives = nil
end
if SaveData.totalCoinsClassic ~= nil then
    SaveData.SMASPlusPlus.hud.coinsClassic = SaveData.totalCoinsClassic
    SaveData.totalCoinsClassic = nil
end
if SaveData.totalScoreClassic ~= nil then
    SaveData.SMASPlusPlus.hud.score = SaveData.totalScoreClassic
    SaveData.totalScoreClassic = nil
end
if SaveData.reserveBoxItem ~= nil then
    SaveData.SMASPlusPlus.hud.reserve = {}
    for i = 1,200 do    
        SaveData.SMASPlusPlus.hud.reserve[i] = SaveData.reserveBoxItem[i]
    end
    SaveData.reserveBoxItem = nil
end
if SaveData.totalCheatCount ~= nil then
    SaveData.SMASPlusPlus.misc.totalCheatsExecuted = SaveData.totalCheatCount
    SaveData.totalCheatCount = nil
end
if SaveData.disableX2char ~= nil then
    SaveData.SMASPlusPlus.game.onePointThreeModeActivated = SaveData.disableX2char
    SaveData.disableX2char = nil
end
if SaveData.resolution ~= nil then
    SaveData.SMASPlusPlus.options.resolution = SaveData.resolution
    SaveData.resolution = nil
end

if SaveData.totalcoins ~= nil then --If using the old SaveData function, use the new one and nil the original out
    SaveData.SMASPlusPlus.hud.coins = SaveData.totalcoins
    SaveData.totalcoins = nil
end







return smasSaveDataSystem