local debugbox = require("debugbox")
local smasDateAndTime = require("smasDateAndTime")

smasDateAndTime.enabled = false

smasBooleans.disablePauseMenu = true

GameData.gameFirstLoaded = true

smasBooleans.isOnMainMenu = false
debugbox.bootactive = false
GameData.rushModeActive = false

local active = false
local timer = 128

local activeselected = 1
local activeselecty = 32

if SaveData.racaActivated == nil or not SaveData.racaActivated then
    activeselecty = 32
elseif SaveData.racaActivated then
    activeselecty = 44
end

local bootshow = true
local blackscreen = false

local updateractive = false

local onePressedState = false
local twoPressedState = false
local threePressedState = false
local fourPressedState = false
local fivePressedState = false
local sixPressedState = false

local f8PressedState = false

GameData.weatherset = true
GameData.rushModeActive = false

local cooldown = 3

Graphics.activateHud(false)

local Routine = require("routine")
local textplus = require("textplus")
local littleDialogue = require("littleDialogue")

local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

if GameData.____mainMenuComplete == nil then
    GameData.____mainMenuComplete = false
end

local function startupdater()
    bootshow = false
    blackscreen = true
    if SMBX_VERSION == VER_SEE_MOD then
        if not Misc.isSetToRunWhenUnfocused() then
            Misc.runWhenUnfocused(true)
        end
    end
    updateractive = true
    Routine.wait(1, true)
    Sound.changeMusic("_OST/All Stars Menu/Updater.ogg", 0)
    if SMBX_VERSION == VER_SEE_MOD then
        smasUpdater.doUpdate = true
        smasUpdater.doneUpdating = false
        smasUpdater.drawUpdateText = true
    end
end

function onKeyboardPress(k, v)
    if not updateractive and not blackscreen then
        if k == VK_F8 then
            f8PressedState = true
            bootshow = false
            active = true
        end
        if active then
            if k == VK_F8 then
                onePressedState = false
                twoPressedState = false
                threePressedState = false
                fourPressedState = false
            end
        end
    end
end

local bootimage = Graphics.loadImageResolved("SMAS - Start/bootscreen_final.png")

function onDraw()
    if bootshow then
        Graphics.drawImageWP(bootimage, Screen.calculateCameraDimensions(0, 1), Screen.calculateCameraDimensions(0, 2), 6)
    end
    if blackscreen then
        Graphics.drawScreen{color = Color.black, priority = 6}
    end
    if active then
        if SaveData.racaActivated == nil or not SaveData.racaActivated then
            if cooldown > 0 then
                cooldown = cooldown - 1
            end
            Graphics.drawScreen{color = Color.black, priority = -2}
            textplus.print{x=40, y=10, text = "Super Mario All-Stars++ Temporary Boot Option List", priority=-1, color=Color.white}
            textplus.print{x=40, y=32, text = "1) Continue booting", priority=-1, color=Color.white}
            textplus.print{x=40, y=44, text = "2) Load world map instantly (With default settings on first boot)", priority=-1, color=Color.white}
            textplus.print{x=40, y=56, text = "3) Enable speedrun mode", priority=-1, color=Color.white}
            textplus.print{x=40, y=68, text = "4) Reset character", priority=-1, color=Color.white}
            textplus.print{x=40, y=80, text = "5) Reset the main menu theme", priority=-1, color=Color.white}
            textplus.print{x=40, y=92, text = "6) Reset profile picture and player name", priority=-1, color=Color.white}
            textplus.print{x=40, y=104, text = "7) Erase save data (NO WARNING WILL SHOW UP!)", priority=-1, color=Color.white}
            
            textplus.print{x=20, y=activeselecty, plaintext = true, text = "->", priority=-1, color=Color.white}
            
            if activeselected < 1 then
                activeselecty = 104
                activeselected = 7
            elseif activeselected > 7 then
                activeselecty = 32
                activeselected = 1
            end
        elseif SaveData.racaActivated then
            if cooldown > 0 then
                cooldown = cooldown - 1
            end
            Graphics.drawScreen{color = Color.black, priority = -2}
            textplus.print{x=40, y=10, text = "Super Mario All-Stars++ Temporary Boot Option List", priority=-1, color=Color.white}
            textplus.print{x=40, y=32, text = "(Options are limited during the True Final Battle)", priority=-1, color=Color.white}
            textplus.print{x=40, y=44, text = "1) Continue booting", priority=-1, color=Color.white}
            textplus.print{x=40, y=56, text = "2) Reset save data (NO WARNING WILL SHOW UP!)", priority=-1, color=Color.white}
            
            textplus.print{x=20, y=activeselecty, plaintext = true, text = "->", priority=-1, color=Color.white}
            
            if activeselected < 1 then
                activeselecty = 56
                activeselected = 2
            elseif activeselected > 2 then
                activeselecty = 44
                activeselected = 1
            end
        end
    end
    if updateractive then
        
    end
    
    for _,p in ipairs(Player.get()) do
        p.forcedState = FORCEDSTATE_INVISIBLE
    end
end

function restartAfterUpdating()
    if SMBX_VERSION == VER_SEE_MOD then
        if Misc.isSetToRunWhenUnfocused() then
            Misc.runWhenUnfocused(false)
        end
    end
    if not Misc.loadEpisode("Super Mario All-Stars++") then
        error("SMAS++ is not found. How is that even possible? Reinstall the game using the SMASUpdater, since something has gone terribly wrong.")
    end
end

function launchAfterNoUpdate()
    if SMBX_VERSION == VER_SEE_MOD then
        if Misc.isSetToRunWhenUnfocused() then
            Misc.runWhenUnfocused(false)
        end
    end
    SysManager.loadIntroTheme()
end

function onInputUpdate()
    player.leftKeyPressing = false
    player.rightKeyPressing = false
    player.altJumpKeyPressing = false
    player.runKeyPressing = false
    player.altRunKeyPressing = false
    player.dropItemKeyPressing = false
    if Player.count() >= 2 then
        player2.leftKeyPressing = false
        player2.rightKeyPressing = false
        player2.altJumpKeyPressing = false
        player2.runKeyPressing = false
        player2.altRunKeyPressing = false
        player2.dropItemKeyPressing = false
    end
    if not updateractive and not blackscreen then
        if player.keys.jump == KEYS_PRESSED then
            f8PressedState = true
            bootshow = false
            active = true
            player:mem(0x11E, FIELD_BOOL, false)
        end
    end
    if active then
        if player.keys.down == KEYS_PRESSED then
            activeselected = activeselected + 1
            activeselecty = activeselecty + 12
        elseif player.keys.up == KEYS_PRESSED then
            activeselected = activeselected - 1
            activeselecty = activeselecty - 12
        end
        if cooldown == 0 then
            if SaveData.racaActivated == nil or not SaveData.racaActivated then
                if player.keys.jump == KEYS_PRESSED then
                    if activeselected == 1 then
                        SysManager.loadIntroTheme()
                    end
                    if activeselected == 2 then
                        GameData.____mainMenuComplete = true
                        GameData.gameFirstLoaded = false
                        Level.load("map.lvlx")
                    end
                    if activeselected == 3 then
                        GameData.____mainMenuComplete = true
                        SaveData.speedrunMode = not SaveData.speedrunMode
                        if not SaveData.firstBootCompleted then
                            SaveData.firstBootCompleted = true
                        end
                        GameData.gameFirstLoaded = false
                        Misc.saveGame()
                        Level.load("map.lvlx")
                    end
                    if activeselected == 4 then
                        player.setCostume(1, nil)
                        player.setCostume(2, nil)
                        player.setCostume(3, nil)
                        player.setCostume(4, nil)
                        player.setCostume(5, nil)
                        player.setCostume(6, nil)
                        player.setCostume(7, nil)
                        player.setCostume(8, nil)
                        player.setCostume(9, nil)
                        player.setCostume(10, nil)
                        player.setCostume(11, nil)
                        player.setCostume(12, nil)
                        player.setCostume(13, nil)
                        player.setCostume(14, nil)
                        player.setCostume(15, nil)
                        player.setCostume(16, nil)
                        player:transform(CHARACTER_MARIO, false)
                        SysManager.loadIntroTheme()
                    end
                    if activeselected == 5 then
                        SaveData.introselect = 1
                        Level.load("intro_SMAS.lvlx")
                    end
                    if activeselected == 6 then
                        SaveData.playerName = nil
                        SaveData.playerPfp = nil
                        SysManager.loadIntroTheme()
                    end
                    if activeselected == 7 then
                        Misc.eraseSaveSlot(Misc.saveSlot())
                        SysManager.clearSaveDataAndGameDataAndRestart()
                    end
                end
            elseif SaveData.racaActivated then
                if player.keys.jump == KEYS_PRESSED then
                    if activeselected == 1 then
                        SysManager.loadIntroTheme()
                    end
                    if activeselected == 2 then
                        Misc.eraseSaveSlot(Misc.saveSlot())
                        SysManager.clearSaveDataAndGameDataAndRestart()
                    end
                end
            end
        end
    end
end

function onTick()
    timer = timer - 1
    
    if timer <= 0 then
        if SMBX_VERSION ~= VER_SEE_MOD then
            SysManager.loadIntroTheme()
        elseif SMBX_VERSION == VER_SEE_MOD then
            if not smasBooleans.skipUpdater then
                Routine.run(startupdater)
            else
                SysManager.loadIntroTheme()
            end
        end
    end
    
    if active then
        timer = timer + 1
    end
end

local playerlives = mem(0x00B2C5AC,FIELD_FLOAT)

function onStart()
    if SaveData.introselect == nil then
        SaveData.introselect = SaveData.introselect or 1
    end
    if SaveData.firstBootCompleted == nil then
        SaveData.firstBootCompleted = false
    end
    GameData.toggleoffkeys = false
    if mem(0x00B2C5AC,FIELD_FLOAT,0) then
        mem(0x00B2C5AC,FIELD_FLOAT,3)
    end
    if GameData.temporaryPowerupStored ~= nil then
        player.powerup = GameData.temporaryPowerupStored
        GameData.temporaryPowerupStored = nil
    end
    if GameData.temporaryReserveStored ~= nil then
        player.reservePowerup = GameData.temporaryReserveStored
        GameData.temporaryReserveStored = nil
    end
    Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end



--The rest of the code will disable cheats to avoid breaking the pre-boot level. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

smasCheats.checkCheatStatusAndDisable()

function onExit()
    Audio.MusicVolume(65)
end