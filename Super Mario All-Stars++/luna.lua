--SUPER MARIO ALL-STARS++
--By Spencer Everly
--Here's the starting code that loads it all. How'd I do?

--Total Stars:
--SMB1 = 43 (Done!)
--SMB2 = 22 (Done! Still need code for several things though)
--SMB3 = TBD (WIP)
--SMBLL (Optional) = 52 (Done!)
--SMW = TBD (WIP)
--SMBS = TBD (WIP)
--WSMBA = 24 (Done!)
--Lava Lands = 5 (WIP)
--Side Quest (Optional) = TBD (WIP)
--True Ending = 1 (WIP)

--Since we're adding stuff like new NPC slots, the original LunaLua may be incompatible.
--[[if SMBX_VERSION ~= VER_SEE_MOD then
    Misc.dialog("Hey wait a minute! The LunaLua SEE Mod is required to play this game. Please download it from GitHub by going to https://github.com/SpencerEverly/smbx2-seemod/. Until then, you can't run this episode. Sorry about that!")
    Misc.exitEngine()
end]]

console:println("Super Mario All-Stars++ loading initated.")

if GameData.gameFirstLoaded == nil then
    GameData.gameFirstLoaded = true
end

--Make sure we aren't running Beta 3 and below before we actually start...
if (SMBX_VERSION < VER_BETA4_PATCH_3) then
    Text.windowDebugSimple("Hey wait a minute! At least SMBX2 Beta 4 Patch 3 is required to play this game. Please download it from the official site by going to https://codehaus.wohlsoft.ru/. Until then, you can't run this episode. Sorry about that!")
    Misc.exitEngine()
end

--Make sure to save the current episode folder and save slot numbers to it's own GameData variables to prevent the broken 1.3 launcher from launching the episode...
GameData.__EpisodeFolder = Misc.episodePath()
GameData.__SaveSlot = Misc.saveSlot()

--Make sure we warn the user to upgrade the legacy save data while we can...
if not Misc.inMarioChallenge() then
    if mem(0x00B251E0, FIELD_WORD) >= 1 then
        console:println("Legacy star count greater than 1! Assuming we're loading a save file from Demo 2 and below...")
        if GameData.warnUserAboutOldStars == nil then
            GameData.warnUserAboutOldStars = true
        end
        if GameData.warnUserAboutOldStars then
            Text.windowDebugSimple("It looks like your using a legacy save file from before Demo 3 (Or before April 10th, 2022). You'll need to migrate your save data as soon as you boot the game! That way your data can still be used in the future. Please migrate your save while you can!")
            GameData.warnUserAboutOldStars = false
        end
    end
end

if mem(0x00B251E0, FIELD_WORD) == 0 then
    --Make sure we do these if the star count is set at 0
    if mem(0x00B2C5AC,FIELD_FLOAT) > 1 then
        mem(0x00B2C5AC,FIELD_FLOAT,1) --Decrease legacy lives to 1
    end
    if Misc.score() > 0 then
        Misc.score(-Misc.score()) --Decrease legacy score to 0
    end
end

--For SEE Mod users, where they have a definite version of LunaLua.
if SMBX_VERSION == VER_SEE_MOD then
    console:println("SEE MOD DETECTED! Loading LunaDLL.dll...")
    _G.LunaDLL = ffi.load("LunaDll.dll")
end
if Misc.setWindowTitle ~= nil then
    console:println("Window title set.")
    Misc.setWindowTitle("Super Mario All-Stars++")
end
if Misc.setWindowIcon ~= nil then
    console:println("Window icon set.")
    Misc.setWindowIcon(Graphics.loadImageResolved("graphics/icon/icon.png"))
end

--Register some custom global event handlers...
console:println("Registering global event handlers...")
Misc.LUNALUA_EVENTS_TBL["onPlaySFX"] = true
Misc.LUNALUA_EVENTS_TBL["onPostPlaySFX"] = true
Misc.LUNALUA_EVENTS_TBL["onChangeMusic"] = true
Misc.LUNALUA_EVENTS_TBL["onPostChangeMusic"] = true
Misc.LUNALUA_EVENTS_TBL["onPOW"] = true
Misc.LUNALUA_EVENTS_TBL["onPostPOW"] = true
Misc.LUNALUA_EVENTS_TBL["onEarthquake"] = true
Misc.LUNALUA_EVENTS_TBL["onPostEarthquake"] = true
Misc.LUNALUA_EVENTS_TBL["onCheatActivate"] = true
if SMBX_VERSION == VER_SEE_MOD then
    Misc.LUNALUA_EVENTS_TBL["onCheatDeactivate"] = true
end
Misc.LUNALUA_EVENTS_TBL["onWarpToOtherLevel"] = true
Misc.LUNALUA_EVENTS_TBL["onWarpBegin"] = true

--Now, before we get started, we require the most important libraries on the top.
console:println("Loading important libraries...")

--SMAS specific functions need to be required first:
_G.smasGlobals = require("smasGlobals")
_G.smasMemoryAddresses = require("smasMemoryAddresses")
_G.smasFunctions = require("smasFunctions")
_G.smasKeySystem = require("smasKeySystem")
_G.smasAudioVolumeSystem = require("smasAudioVolumeSystem")
_G.smasAnimationSystem = require("smasAnimationSystem")
_G.smasVerboseMode = require("smasVerboseMode")
_G.smasBooleans = require("smasBooleans")
_G.smasTables = require("smasTables")
_G.smasCheats = require("smasCheats")
_G.smasHud = require("smasHud")
_G.smasStarSystem = require("smasStarSystem")
_G.smasNoTurnBack = require("smasNoTurnBack")
_G.smasSpencerFollower = require("smasSpencerFollower")
_G.smasCharacterChanger = require("smasCharacterChanger")
_G.smasFireballs = require("smasFireballs")
_G.smasPWing = require("smasPWing")
_G.smasExtraSounds = require("smasExtraSounds")

--Then we do everything else.
GameData.levelMusicTemporary = {}
GameData.levelMusic = {}
_G.smwMap = require("smwMap")
_G.classicEvents = require("classiceventsmod")
_G.darkness = require("darknessa")
_G.events = require("editorevents_mod")
_G.extraNPCProperties = require("extraNPCProperties")
_G.cursor = require("cursor")
_G.Timer = require("timer-mod")
_G.lazyprintSMAS = require("lazyprintSMAS")
_G.autoscrolla = require("autoscrolla")

--Making sure we're in the Mario Challenge... if so, automatically enable X2 characters.
if Misc.inMarioChallenge() then
    console:println("Mario Challenge detected! Loading game in minimal mode...")
    SaveData.disableX2char = false
end

--This will add multiple player arguments.
for i = 1,200 do
    _G["player".. i] = Player(i)
end

--Then we fix up some functions that the X2 team didn't fix yet (If they released a patch and fixed a certain thing, the code will be removed from here).
if (VER_BETA4_PATCH_4_1 ~= nil) and (SMBX_VERSION <= VER_BETA4_PATCH_4_1 or SMBX_VERSION == VER_SEE_MOD) then
    function Player:teleport(x, y, bottomCenterAligned) --This fixes 2nd player teleporting, when using player/player2:teleport. This will be removed after a few months when the next SMBX2 patch releases (The next patch will fix this), to make sure people upgrade on time.
        -- If using bottom center aligned coordinates, handle that sensibly
        if bottomCenterAligned then
            x = x - (self.width * 0.5)
            y = y - self.height
        end

        -- Move the player and update section, including music
        local oldSection = self.section
        local newSection = Section.getIdxFromCoords(x, y)
        self.x, self.y = x, y
        if (newSection ~= oldSection) then
            self.section = newSection
            playMusic(newSection)
        end
    end
end

function plObjectErrorWorkaround() --To prevent the plObject a nil value error, this needs to be redone here
    local players = Player.get()
    for plIndex, plData in ipairs(playerData) do
        local plObject = players[plIndex]
        for _,keymapEnumValue in ipairs(playerKeymapKeys) do
            local keymapPropertyName = playerKeymapProperties[keymapEnumValue]
            checkKeyboardEvent(plObject, plIndex, plData, keymapPropertyName, keymapEnumValue)
        end
        if(plObject:mem(0x60, FIELD_WORD) == -1 and plData.playerJumping == false)then
            EventManager.callEventInternal("onJump", {plIndex})
        elseif(plObject:mem(0x60, FIELD_WORD) == 0 and plData.playerJumping == true)then
            EventManager.callEventInternal("onJumpEnd", {plIndex})
        end
        
        local section = plObject.section
        if(section ~= plData.currentSection)then
            local evLoadSecitionName = "onLoadSection"
            EventManager.callEventInternal(evLoadSecitionName, {plIndex})
            EventManager.callEventInternal(evLoadSecitionName .. section, {plIndex})
        end
        EventManager.callEventInternal("onLoopSection" .. section, {plIndex})
        
        -- Copy new data here to plData
        for _,keymapEnumValue in ipairs(playerKeymapKeys) do
            local keymapPropertyName = playerKeymapProperties[keymapEnumValue]
            plData[keymapPropertyName] = plObject[keymapPropertyName]
        end
        
        plData.playerJumping = plObject:mem(0x60, FIELD_WORD) == -1
        
        plData.currentSection = section
    end
end

function classicEvents.doEvents() --To prevent the plObject a nil value error, this needs to be moved to a pcall function
    pcall (function() plObjectErrorWorkaround() end)
end

--Now that everything has been loaded, start loading the medium important stuff

console:println("Loading medium important libraries...")

_G.transplate = require("transplate")
_G.globalgenerals = require("globalgenerals") --Most important library of all. This loads general stuff for levels.
_G.repll = require("repll") --Custom sound command line, for not only testing in the editor, but for an additional clear history command
_G.rng = require("base/rng") --Load up rng for etc. things
if SaveData.speedrunMode then
    console:println("Speedrun mode enabled! Loading speedrun libraries...")
    speedruntimer = require("speedruntimer") -- Speedrun Timer Script on World Map (from MaGLX3 episode)
    inputoverlay = require("inputoverlay") -- Input Overlay (GFX by Wohlstand for TheXTech, script by me)
end

local npc_APIs = {
    "waternpcplusExt",
};
for _,v in ipairs(npc_APIs) do
    require("extra-settings/"..v);
end

local loadactivate = true
console:println("Loading Steve and SMW2 Yoshi characters...")
local steve = require("steve")
local yoshi = require("yiYoshi/yiYoshi")
local playerManager = require("playermanager") --Load up this to change Ultimate Rinka and Ninja Bomberman to Steve and Yoshi (You can still use UR and NB, check out the Toad costumes)
--These will need to be overwritten over the original libraries, because we're fixing graphics/bugs from these characters.
console:println("Overriding original character libraries...")
playerManager.overrideCharacterLib(CHARACTER_MEGAMAN,require("characters/megamann"))
playerManager.overrideCharacterLib(CHARACTER_SNAKE,require("characters/snakey"))
playerManager.overrideCharacterLib(CHARACTER_BOWSER,require("characters/bowserr"))
playerManager.overrideCharacterLib(CHARACTER_ROSALINA,require("characters/rosalinaa"))
playerManager.overrideCharacterLib(CHARACTER_SAMUS,require("characters/samuss"))
playerManager.overrideCharacterLib(CHARACTER_WARIO,require("characters/warioo"))
playerManager.overrideCharacterLib(CHARACTER_ZELDA,require("characters/zeldaa"))
playerManager.overrideCharacterLib(CHARACTER_KLONOA,require("characters/klonoaa"))
playerManager.overrideCharacterLib(CHARACTER_UNCLEBROADSWORD,require("characters/unclebroadswordd"))
playerManager.overrideCharacterLib(CHARACTER_ULTIMATERINKA,require("steve"))
Graphics.sprites.effect[152].img = Graphics.loadImageResolved("graphics/smbx2og/effect/effect-152.png")
Graphics.sprites.effect[153].img = Graphics.loadImageResolved("graphics/smbx2og/effect/effect-153.png")
Graphics.sprites.ultimaterinka[player.powerup].img = Graphics.loadImageResolved("graphics/smbx2og/character/ultimaterinka-2.png")

--First time SaveData settings, for resolutions and other settings

--***This will be used for the future, once we replace each SaveData/GameData variable to ones that look cleaner and are better to use***
SaveData.SMASPlusPlus = SaveData.SMASPlusPlus or {}
SaveData.SMASPlusPlus.options = SaveData.SMASPlusPlus.options or {}
SaveData.SMASPlusPlus.accessibility = SaveData.SMASPlusPlus.accessibility or {}
SaveData.SMASPlusPlus.hud = SaveData.SMASPlusPlus.hud or {}
SaveData.SMASPlusPlus.keys = SaveData.SMASPlusPlus.keys or {}
SaveData.SMASPlusPlus.audio = SaveData.SMASPlusPlus.audio or {}
SaveData.SMASPlusPlus.game = SaveData.SMASPlusPlus.game or {}
SaveData.SMASPlusPlus.player = SaveData.SMASPlusPlus.player or {}
for i = 1,8 do
    SaveData.SMASPlusPlus.player[i] = SaveData.SMASPlusPlus.player[i] or {}
end
--***End of clean variables***

if SaveData.totalcoins ~= nil then --If using the old SaveData function, use the new one and nil the original out
    SaveData.totalCoins = SaveData.totalcoins
    SaveData.totalcoins = nil
end

--**Player-related data**
SaveData.currentCostume = SaveData.currentCostume or "N/A"
SaveData.currentAlteration = SaveData.currentAlteration or "N/A"

--**Themes, resolutions**
SaveData.resolution = SaveData.resolution or "fullscreen"
if SaveData.clockTheme == nil then --Default clock theme is "normal"
    SaveData.clockTheme = "normal"
end

--**Hud stuff**
if SaveData.totalCoins == nil then --The total coin count, used outside of the classic coin count which counts all coins overall
    SaveData.totalCoins = 0
end
if SaveData.deathCount == nil then --Death count! For outside 1.3 mode, and inside it
    SaveData.deathCount = 0
end
if SaveData.totalLives == nil then --The total lives used the for the episode.
    SaveData.totalLives = 5
end
if SaveData.totalCoinsClassic == nil then --This will display a classic coin count for the episode
    SaveData.totalCoinsClassic = 0
end
if SaveData.totalScoreClassic == nil then --This will add a score counter which goes up to a trillion, cause why not
    SaveData.totalScoreClassic = 0
end
if SaveData.reserveBoxItem == nil then
    SaveData.reserveBoxItem = {}
end
for i = 1,200 do
    if SaveData.reserveBoxItem[i] == nil then
        SaveData.reserveBoxItem[i] = 0
    end
end
if SaveData.totalCheatCount == nil then --A tally number of cheats you have executed since the first cheat. This'll be an SEE Mod-only feature for now.
    SaveData.totalCheatCount = 0
end

--**1.3 Mode default setting**
if SaveData.disableX2char == nil then --This will make sure 1.3 Mode isn't enabled on first boot, which will also prevent errors
    SaveData.disableX2char = false
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

Progress.value = SaveData.totalStarCount --Every level load, we will save the total stars used with the launcher

if SaveData.playerName == nil then --This is for adding the player name to the launcher, aside from the total stars used
    Progress.savename = "Player" --If the player name is nil, use "Player" instead
else
    Progress.savename = SaveData.playerName --Or else just use the SaveData variable if it exists
end

--Make sure the warp door system doesn't get active until onStart saves the original count first...
local warpstaractive = false

--Now load the loading sound file!
local loadingsoundFile = Misc.resolveSoundFile("loadscreen.ogg")

--Placing in levels onto a table that'll prevent the loading sound from playing
smasTables._noLoadingSoundLevels = {
    "SMAS - Start.lvlx",
    "SMAS - Raca's World (Part 0).lvlx",
    "SMAS - Raca's World (Part 1).lvlx",
    "map.lvlx"
}

--Now use onLoad to play the loading sound...
function onLoad()
    if not Misc.inEditor() and not table.icontains(smasTables._noLoadingSoundLevels,Level.filename()) and loadactivate then --If luna errors during testing in the editor, this will be useful to not load the audio to prevent the audio from still being played until the engine is terminated
        console:println("Loading sound playing!")
        loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
        loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
        fadetolevel = true
    end
end

function onLoop() --I'm sorry for using deprecated crap, this is used specifically for stopping the loading sound when erroring
    if fadetolevel then
        if unexpected_condition then
            pcall(function() loadactivate = false fadetolevel = false loadingSoundObject:Stop() end)
        end
    end
end

function onStart() --Now do onStart...
    --From earlier, if the GameData info is mismatched, run a dialog and afterward exit the engine
    if GameData.__EpisodeFolder ~= Misc.episodePath() and GameData.__SaveSlot ~= Misc.saveSlot() then
        Misc.dialog("Uh oh... it looks like you launched the episode using the broken SMBX 1.3 Launcher. Please use the SMBX2 launcher to launch the episode. Until then, you can't run this episode. Sorry about that!")
        Misc.exitEngine()
    end
    --Below will start the star door system
    warpstaractive = true
    if Misc.inMarioChallenge() then --Just in case if the Mario Challenge is active, do these things to update the Challenge...
        SaveData.totalCoinsClassic = mem(0x00B2C5A8, FIELD_WORD)
        SaveData.totalStarCount = mem(0x00B251E0, FIELD_WORD)
    end
    --Do the weather SaveData additions
    if SaveData.dateplayedweather == nil then
        SaveData.dateplayedweather = weatherControl
    end
    --Calculate Easter Sunday
    Time.easterYear(os.date("*t").year)
    if SaveData.dateplayedyesterday == nil then
        yesterdaynumber = os.date("*t").day - 1
        SaveData.dateplayedyesterday = yesterdaynumber
    end
    if SaveData.dateplayedtomorrow == nil then
        tomorrownumber = os.date("*t").day + 1
        SaveData.dateplayedtomorrow = tomorrownumber
    end
    if GameData.weatherset then --This'll be better in the future. For now, it just loads the weather when restarting the game to the start preboot screen, or starting it up every time
        possibleWeather = {"sunny","rain","snow"}
        weatherControl = rng.randomEntry(possibleWeather)
        SaveData.dateplayedweather = weatherControl --Write in a better onetime day function for this
        GameData.weatherset = false
    end
    if not Misc.inEditor() and not table.icontains(smasTables._noLoadingSoundLevels,Level.filename()) then --Make sure to fade out the loading sound when onStart is active...
        fadetolevel = false
        if loadactivate then
            loadingSoundObject:FadeOut(800)
            loadactivate = false
        end
        GameData.gameFirstLoaded = false --Because what if we load into a level instead of the boot menu?
    end
    if SaveData.disableX2char == 0 then --Migrate old saves from pre-March 2022 if there are any.
        SaveData.disableX2char = false
    end
    if SaveData.disableX2char == 1 then
        SaveData.disableX2char = true
    end
    if SaveData.firstBootCompleted == 0 then
        SaveData.firstBootCompleted = false
    end
    if SaveData.firstBootCompleted == 1 then
        SaveData.firstBootCompleted = true
    end
    if not Misc.inMarioChallenge() and (not SaveData.disableX2char) and not Misc.inEditor() and (SaveData.currentCharacter ~= nil and SaveData.currentCostume ~= nil) then
        player.character = SaveData.currentCharacter
        player.setCostume(SaveData.currentCharacter, SaveData.currentCostume, false)
    end
    if Misc.inEditor() and SysManager.isOutsideOfUnplayeredAreas() then
        GameData.gameFirstLoaded = false
    end
end

local cameratimer = 10
local cameratimer2 = 10
if GameData.__gifIsRecording == nil then
    GameData.__gifIsRecording = false
end
local gifRecordTimer = 0

local inputhudbg = Graphics.loadImageResolved("inputhud/inputhud.png")
local controlkey = Graphics.loadImageResolved("inputhud/control.png")
local jumpkey = Graphics.loadImageResolved("inputhud/jump.png")
local altjumpkey = Graphics.loadImageResolved("inputhud/altjump.png")
local runkey = Graphics.loadImageResolved("inputhud/run.png")
local altrunkey = Graphics.loadImageResolved("inputhud/altrun.png")
local bottomkeys = Graphics.loadImageResolved("inputhud/bottomkey.png")

function onDraw()
    if Misc.inEditor() then
        player.keys.pause = false
        if Player.count() >= 2 then
            player2.keys.pause = false
        end
    end
    if noItemSound then
        Audio.sounds[12].muted = true
        cameratimer = cameratimer - 1
        if cameratimer <= 0 then
            cameratimer = 10
            Audio.sounds[12].muted = false
            noItemSound = false
        end
    end

    if SMBX_VERSION ~= VER_SEE_MOD then
        if noSoundGif then
            Audio.sounds[12].muted = true
            Audio.sounds[24].muted = true
            cameratimer = cameratimer - 1
            if not GameData.__gifIsRecording then
                GameData.__gifIsRecording = true
            else
                GameData.__gifIsRecording = false
            end
            if cameratimer <= 0 then
                cameratimer = 10
                Audio.sounds[12].muted = false
                Audio.sounds[24].muted = false
                noItemSoundGif = false
            end
        end
        if GameData.__gifIsRecording then
            
        end
    else
        if Misc.isGIFRecording() then
            gifRecordTimer = gifRecordTimer + 1
            if gifRecordTimer <= 5 then
                Audio.sounds[12].muted = true
                Audio.sounds[24].muted = true
            end
            if gifRecordTimer == 1 then
                
            end
            if gifRecordTimer == 6 then
                Audio.sounds[12].muted = false
                Audio.sounds[24].muted = false
            end
        elseif not Misc.isGIFRecording() then
            gifRecordTimer = 0
        end
    end
    if SaveData.speedrunMode then
        Graphics.drawImageWP(inputhudbg,4,566,-1.9) -- Released Keys
        if player.keys.left == KEYS_DOWN then -- Pressed Left Key
            Graphics.drawImageWP(controlkey,8,578,-1) 
        end
        if player.keys.right == KEYS_DOWN then -- Pressed Right Key
            Graphics.drawImageWP(controlkey,20,578,-1)
        end
        if player.keys.up == KEYS_DOWN then -- Pressed Up Key
            Graphics.drawImageWP(controlkey,14,572,-1)
        end
        if player.keys.down == KEYS_DOWN then -- Pressed Down Key
            Graphics.drawImageWP(controlkey,14,584,-1)
        end
        if player.keys.jump == KEYS_DOWN then -- Pressed Jump Key
            Graphics.drawImageWP(jumpkey,68,584,-1)
        end
        if player.keys.run == KEYS_DOWN then -- Pressed Run Key
            Graphics.drawImageWP(runkey,58,582,-1)
        end
        if player.keys.altJump == KEYS_DOWN then -- Pressed Alt Jump Key
            Graphics.drawImageWP(altjumpkey,70,574,-1)
        end
        if player.keys.altRun == KEYS_DOWN then -- Pressed Alt Run Key
            Graphics.drawImageWP(altrunkey,60,572,-1)
        end
        if player.keys.dropItem == KEYS_DOWN then -- Pressed Drop Item Key
            Graphics.drawImageWP(bottomkeys,30,588,-1)
        end
        if player.keys.pause == KEYS_DOWN then -- Pressed Pause Key
            Graphics.drawImageWP(bottomkeys,44,588,-1)
        end
    end
    
    --This'll update the costume throughout the game
    local currentCostume = player:getCostume()
    if currentCostume ~= nil then
        SaveData.currentCostume = currentCostume
    elseif currentCostume == nil then
        SaveData.currentCostume = "N/A"
    end
    
    --This'll update the path for costumes
    if currentCostume ~= nil then
        if SaveData.currentCostume ~= "N/A" then
            SaveData.currentCostumePath = "costumes/"..playerManager.getName(player.character).."/"..SaveData.currentCostume
        else
            SaveData.currentCostumePath = "N/A"
        end
    end
    
    if Misc.inMarioChallenge() then
        if lunatime.tick() == 6 then
            if player.character == 10 then
                if player:getCostume() == "SMB3-WALUIGI" then
                    player.setCostume(3, "SMB3-WALUIGI", false)
                    player:transform(3, false)
                else
                    player.setCostume(3, "NINJABOMBERMAN", false)
                    player:transform(3, false)
                end
            elseif player.character == 14 then
                player.setCostume(4, "ULTIMATERINKA", false)
                player:transform(4, false)
            end
        end
    end
end

function onKeyboardPressDirect(k, repeated) --This will replace the GIF recording/snapshot sounds to some custom ones
    if k == VK_F11 then
        Audio.sounds[12].muted = true
        Audio.sounds[24].muted = true
        noSoundGif = true
        if SMBX_VERSION ~= VER_SEE_MOD then
            if not GameData.__gifIsRecording then
                Sound.playSFX("gif-start.ogg")
            elseif GameData.__gifIsRecording then
                Sound.playSFX("gif-end.ogg")
            end
        else
            if Misc.isGIFRecording() then
                Sound.playSFX("gif-end.ogg")
            elseif not Misc.isGIFRecording() then
                Sound.playSFX("gif-start.ogg")
            end
        end
    end
    if k == VK_F12 then
        Audio.sounds[12].muted = true
        noItemSound = true
        Sound.playSFX("snapshot.ogg")
    end
end

function onTick()
    mem(0x00B25130,FIELD_WORD,2) --This will prevent split screen, again (Just in case)
    --Let's not get game overs/broken launcher kicking (These are life global memories).
    if mem(0x00B2C5AC,FIELD_FLOAT) < 1 then --This is to prevent the old Game Over system
        mem(0x00B2C5AC,FIELD_FLOAT,1)
    end
    if table.icontains(smasTables._friendlyPlaces,Level.filename()) then
        GameData.friendlyArea = true --Set this to prevent Mother Brain Rinka from getting killed in places such as the boot screen, intro, or the Hub
    end
    --Now we'll overhaul the door star required system
    if warpstaractive then
        for _,warp in ipairs(Warp.get()) do
            if warp.starsRequired <= SaveData.totalStarCount then
                warp.starsRequired = 0
            elseif warp.starsRequired > SaveData.totalStarCount then
                --warp.starsRequired = warpStarDoorList(warp) --Try to have this read-only?
            end
        end
    end
    for i = 1,200 do
        if Player(i).isValid then
            if Player(i).forcedState == FORCEDSTATE_PIPE then
                if Player(i).forcedTimer == 1 then
                    local warp = Player(i):mem(0x15E, FIELD_WORD) - 1
                    EventManager.callEvent("onWarpBegin", Warp(warp), Player(i))
                end
            end
        end
    end
end

function onPause(evt)
    evt.cancelled = true
    isPauseMenuOpen = not isPauseMenuOpen
end

function onExit()
    if Misc.inMarioChallenge() then
        local oldpoints = Misc.score()
        mem(0x00B2C5A8, FIELD_WORD, SaveData.totalCoinsClassic)
        if SaveData.totalScoreClassic > 9999990 then
            SaveData.totalScoreClassic = 9999990
        end
        Misc.score(oldpoints - SaveData.totalScoreClassic)
        if SaveData.totalLives > 99 then
            mem(0x00B2C5AC, FIELD_FLOAT, 99)
        else
            mem(0x00B2C5AC, FIELD_FLOAT, SaveData.totalLives)
        end
        if player.character == 3 and SaveData.currentCostume == "NINJABOMBERMAN" then
            player:transform(10, false)
        elseif player.character == 4 and SaveData.currentCostume == "ULTIMATERINKA" then
            player:transform(14, false)
        end
    end
end

function onCheatActivate(cheat)
    if cheat.id then
        SaveData.totalCheatCount = SaveData.totalCheatCount + 1
    end
end

--That's the end of this file!