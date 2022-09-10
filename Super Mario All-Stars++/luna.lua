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

--Make sure we aren't running Beta 3 and below before we actually start...
if (VER_BETA4_PATCH_3 == nil) or (SMBX_VERSION < VER_BETA4_PATCH_3) then
    Misc.dialog("Hey wait a minute! At least SMBX2 Beta 4 Patch 3 is required to play this game. Please download it from the official site by going to https://codehaus.wohlsoft.ru/. Until then, you can't run this episode. Sorry about that!")
    Misc.exitEngine()
end

--Make sure to save the current episode folder and save slot numbers to it's own GameData variables to prevent the broken 1.3 launcher from launching the episode...
GameData.__EpisodeFolder = Misc.episodePath()
GameData.__SaveSlot = Misc.saveSlot()

--Make sure we warn the user to upgrade the legacy save data while we can...
if not Misc.inMarioChallenge() then
    if mem(0x00B251E0, FIELD_WORD) >= 1 then
        if GameData.warnUserAboutOldStars == nil then
            GameData.warnUserAboutOldStars = true
        end
        if GameData.warnUserAboutOldStars == true then
            Misc.richDialog("It looks like your using a legacy save file from before Demo 3 (Or before April 10th, 2022).\n\nYou'll need to migrate your save data as soon as you boot the game!\nThat way your data can still be used in the future.\nPlease migrate your save while you can!")
            GameData.warnUserAboutOldStars = false
        end
    end
end

--For SEE Mod users, where they have a definite version of LunaLua.
if SMBX_VERSION == VER_SEE_MOD then
    Misc.setWindowTitle("Super Mario All-Stars++")
    Misc.setWindowIcon(Graphics.loadImageResolved("graphics/icon/icon.png"))
    _G.LunaDLL = ffi.load("LunaDll.dll")
end

--Now, before we get started, we require the most important libraries on the top.

--SMAS specific functions need to be required first:
_G.smasfunctions = require("smasfunctions")
_G.smasverbosemode = require("smasverbosemode")
_G.smasbooleans = require("smasbooleans")
_G.smastables = require("smastables")
_G.smascheats = require("smascheats")
_G.smashud = require("smashud")
_G.smasstarsystem = require("smasstarsystem")
_G.smasnoturnback = require("smasnoturnback")
_G.smasspencerfollower = require("smasspencerfollower")

--Then we do everything else.
GameData.levelMusicTemporary = {}
GameData.levelMusic = {}
_G.smwMap = require("smwMap")
_G.extrasounds = require("extrasounds")
_G.classicEvents = require("classiceventsmod")
_G.EventManager = require("main_events_mod")
_G.darkness = require("darknessa")
_G.events = require("editorevents_mod")
_G.extraNPCProperties = require("extraNPCProperties")
_G.cursor = require("cursor")
_G.lazyprint = require("lazyprint")

--Register some custom global event handlers...
Misc.LUNALUA_EVENTS_TBL["onPlaySFX"] = true
Misc.LUNALUA_EVENTS_TBL["onPostPlaySFX"] = true
Misc.LUNALUA_EVENTS_TBL["onChangeMusic"] = true
Misc.LUNALUA_EVENTS_TBL["onPostChangeMusic"] = true

--Making sure we're in the Mario Challenge... if so, automatically enable X2 characters.
if Misc.inMarioChallenge() then
    SaveData.disableX2char = false
end

--This will add multiple player arguments.
--for _,p in ipairs(Player.get()) do
    --_G["player".. p.idx] = p
--end
for i = 1,200 do
    _G["player".. i] = Player(i)
end

--Then we fix up some functions that the X2 team didn't fix yet (If they released a patch and fixed a certain thing, the code will be removed from here).
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
local globalgenerals = require("globalgenerals") --Most important library of all. This loads general stuff for levels.
local repll = require("repll") --Custom sound command line, for not only testing in the editor, but for an additional clear history command
local rng = require("base/rng") --Load up rng for etc. things
if SaveData.speedrunMode == true then
    speedruntimer = require("speedruntimer") -- Speedrun Timer Script on World Map (from MaGLX3 episode)
    inputoverlay = require("inputoverlay") -- Input Overlay (GFX by Wohlstand for TheXTech, script by me)
end

local loadactivate = true
local steve = require("steve")
local yoshi = require("yiYoshi/yiYoshi")
local playerManager = require("playermanager") --Load up this to change Ultimate Rinka and Ninja Bomberman to Steve and Yoshi (You can still use UR and NB, check out the Toad costumes)
--These will need to be overwritten over the original libraries, because we're fixing graphics/bugs from these characters.
playerManager.overrideCharacterLib(CHARACTER_MEGAMAN,require("megamann"))
playerManager.overrideCharacterLib(CHARACTER_SNAKE,require("snakey"))
playerManager.overrideCharacterLib(CHARACTER_BOWSER,require("bowserr"))
playerManager.overrideCharacterLib(CHARACTER_ROSALINA,require("rosalinaa"))
playerManager.overrideCharacterLib(CHARACTER_SAMUS,require("samuss"))
playerManager.overrideCharacterLib(CHARACTER_WARIO,require("warioo"))
playerManager.overrideCharacterLib(CHARACTER_ZELDA,require("zeldaa"))
playerManager.overrideCharacterLib(CHARACTER_KLONOA,require("klonoaa"))
playerManager.overrideCharacterLib(CHARACTER_UNCLEBROADSWORD,require("unclebroadswordd"))
playerManager.overrideCharacterLib(CHARACTER_ULTIMATERINKA,require("steve"))
Graphics.sprites.effect[152].img = Graphics.loadImageResolved("graphics/smbx2og/effect/effect-152.png")
Graphics.sprites.effect[153].img = Graphics.loadImageResolved("graphics/smbx2og/effect/effect-153.png")
Graphics.sprites.ultimaterinka[player.powerup].img = Graphics.loadImageResolved("graphics/smbx2og/character/ultimaterinka-2.png")

--First time SaveData settings, for resolutions and other settings

--**Themes, resolutions**
if SaveData.resolution == nil then --By default, the resolution will be set as fullscreen.
    SaveData.resolution = "fullscreen"
end
if SaveData.letterbox == nil then --Letterbox default is true
    SaveData.letterbox = true
end
if SaveData.borderEnabled == nil then --Border default is false
    SaveData.borderEnabled = true
end
if SaveData.clockTheme == nil then --Default clock theme is "normal"
    SaveData.clockTheme = "normal"
end

--**Hud stuff**
if SaveData.totalcoins == nil then --The total coin count, used outside of the classic coin count which counts all coins overall
    SaveData.totalcoins = 0
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
if SaveData.totalScoreClassic == nil then --This will add a score counter which goes up to a billion, cause why not
    SaveData.totalScoreClassic = 0
end

--**1.3 Mode default setting**
if SaveData.disableX2char == nil then --This will make sure 1.3 Mode isn't enabled on first boot, which will also prevent errors
    SaveData.disableX2char = false
end

--**Date/time stuffs**
if SaveData.dateplayedmonth == nil then
    SaveData.dateplayedmonth = os.date("%m")
end
if SaveData.dateplayedday == nil then
    SaveData.dateplayedday = os.date("%d")
end
if SaveData.dateplayedyear == nil then
    SaveData.dateplayedyear = os.date("%Y")
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

--Other stuff
if SaveData.openingComplete == nil then
    SaveData.openingComplete = false
end

Progress.value = SaveData.totalStarCount --Every level load, we will save the total stars used with the launcher

if SaveData.playerName == nil then --This is for adding the player name to the launcher, aside from the total stars used
    Progress.savename = "Player" --If the player name is nil, use "Player" instead
else
    Progress.savename = SaveData.playerName --Or else just use the SaveData variable if it exists
end

--Get some day/month/year stuff for the weather changing...
SaveData.dateplayedday = os.date("%d")
SaveData.dateplayedmonth = os.date("%m")
SaveData.dateplayedyear = os.date("%Y")

--Make sure the warp door system doesn't get active until onStart saves the original count first...
local warpstaractive = false

--Now load the loading sound file!
local loadingsoundFile = Misc.resolveSoundFile("loadscreen.ogg")

--Placing in levels onto a table that'll prevent the loading sound from playing
smastables._noLoadingSoundLevels = {
    "SMAS - Start.lvlx",
    "SMAS - Raca's World (Part 0).lvlx",
    "SMAS - Raca's World (Part 1).lvlx",
    "map.lvlx"
}

--Now use onLoad to play the loading sound...
function onLoad()
    if not Misc.inEditor() and not table.icontains(smastables._noLoadingSoundLevels,Level.filename()) and loadactivate == true then --If luna errors during testing in the editor, this will be useful to not load the audio to prevent the audio from still being played until the engine is terminated
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
    if Misc.inMarioChallenge() then
        SaveData.totalCoinsClassic = mem(0x00B2C5A8, FIELD_WORD)
        SaveData.totalScoreClassic = Misc.score()
        SaveData.totalLives = mem(0x00B2C5AC, FIELD_FLOAT)
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
    if GameData.weatherset == true then --This'll be better in the future. For now, it just loads the weather when restarting the game to the start preboot screen, or starting it up every time
        possibleWeather = {"sunny","rain","snow"}
        weatherControl = rng.randomEntry(possibleWeather)
        SaveData.dateplayedweather = weatherControl --Write in a better onetime day function for this
        GameData.weatherset = false
    end
    if not Misc.inEditor() and not table.icontains(smastables._noLoadingSoundLevels,Level.filename()) then --Make sure to fade out the loading sound when onStart is active...
        fadetolevel = false
        if loadactivate == true then
            loadingSoundObject:FadeOut(800)
            loadactivate = false
        end
    end
    tomorrowget()
    yesterdayget()
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
    Audio.MusicVolume(nil) --Reset the music volume on onStart, just in case
end

function tomorrowget()
    tomorrownumber = os.date("*t").day + 1
    SaveData.dateplayedtomorrow = tomorrownumber
end

function yesterdayget()
    yesterdaynumber = os.date("*t").day - 1
    SaveData.dateplayedyesterday = yesterdaynumber
end

local cameratimer = 10
local cameratimer2 = 10
if GameData.__gifIsRecording == nil then
    GameData.__gifIsRecording = false
end

local inputhudbg = Graphics.loadImage(Misc.resolveFile("inputhud/inputhud.png"))
local controlkey = Graphics.loadImage(Misc.resolveFile("inputhud/control.png"))
local jumpkey = Graphics.loadImage(Misc.resolveFile("inputhud/jump.png"))
local altjumpkey = Graphics.loadImage(Misc.resolveFile("inputhud/altjump.png"))
local runkey = Graphics.loadImage(Misc.resolveFile("inputhud/run.png"))
local altrunkey = Graphics.loadImage(Misc.resolveFile("inputhud/altrun.png"))
local bottomkeys = Graphics.loadImage(Misc.resolveFile("inputhud/bottomkey.png"))

function onPlaySFX(eventToken, sfx)
    if sfx == 1 then
        eventToken.cancelled = true
    end
end

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
end

function onKeyboardPressDirect(k, repeated) --This will replace the GIF recording/snapshot sounds to some custom ones
    if k == VK_F11 then
        Audio.sounds[12].muted = true
        Audio.sounds[24].muted = true
        noSoundGif = true
        if not GameData.__gifIsRecording then
            Sound.playSFX("gif-start.ogg")
        elseif GameData.__gifIsRecording then
            Sound.playSFX("gif-end.ogg")
        end
    end
    if k == VK_F12 then
        Audio.sounds[12].muted = true
        noItemSound = true
        Sound.playSFX("snapshot.ogg")
    end
end

function onTick()
    if mem(0x00B25130,FIELD_WORD) == 5 then
        mem(0x00B25130,FIELD_WORD, 2) --This will prevent split screen, again (Just in case)
    end
    --Let's not get game overs/broken launcher kicking (These are life global memories).
    if mem(0x00B2C5AC,FIELD_FLOAT) <= 2 then --If lower or equal to two, go to 3...
        mem(0x00B2C5AC,FIELD_FLOAT,3)
    elseif mem(0x00B2C5AC,FIELD_FLOAT) >= 99 then --Else if greater than or equal to 99, go to 98...
        mem(0x00B2C5AC,FIELD_FLOAT,98)
    end
    if table.icontains(smastables._friendlyPlaces,Level.filename()) == true then
        GameData.friendlyArea = true --Set this to prevent Mother Brain Rinka from getting killed in places such as the boot screen, intro, or the Hub
    end
    --Now we'll overhaul the door star required system
    if warpstaractive == true then
        for _,warp in ipairs(Warp.get()) do
            if warp.starsRequired <= SaveData.totalStarCount then
                warp.starsRequired = 0
            elseif warp.starsRequired > SaveData.totalStarCount then
                --warp.starsRequired = warpStarDoorList(warp) --Try to have this read-only?
            end
        end
    end
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onExit()
    if Misc.inMarioChallenge() then
        local oldpoints = Misc.score()
        mem(0x00B2C5A8, FIELD_WORD, SaveData.totalCoinsClassic)
        if SaveData.totalScoreClassic > 9999999 then
            SaveData.totalScoreClassic = 9999999
        end
        Misc.score(oldpoints - SaveData.totalScoreClassic)
        if SaveData.totalLives > 99 then
            mem(0x00B2C5AC, FIELD_FLOAT, 99)
        else
            mem(0x00B2C5AC, FIELD_FLOAT, SaveData.totalLives)
        end
    end
end

--That's the end of this file!