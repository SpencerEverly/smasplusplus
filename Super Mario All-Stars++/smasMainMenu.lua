--SMAS++ MAIN MENU
--Code by Spencer Everly, MrDoubleA, and others

local smasMainMenu = {}

local littleDialogue = require("littleDialogue")
local textplus = require("textplus")
local datetime = require("datetime")
local autoscroll = require("autoscrolla")
local rng = require("base/rng")
local inputconfigurator = require("inputconfig")
local keyboard = require("keyboard")
local newkeyboard = require("newkeyboard")
local hearthover = require("hearthover") --Require hearthover to disable it
local sprite = require("base/sprite")
local aw = require("anotherwalljump")

_G.smasMainMenuSystem = require("smasMainMenuSystem")

local ready = false

smasMainMenu.sonicManiaFont = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")
smasMainMenu.mainMenuFont = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus-1x.ini")
smasMainMenu.mainMenuFontWebsite = textplus.loadFont("littleDialogue/font/hardcoded-45-2-website-textplus-1x.ini")

smasMainMenu.smasLogoImg = Graphics.loadImageResolved("smaslogo.png")
smasMainMenu.smasLogoJpnImg = Graphics.loadImageResolved("smaslogo-jpn.png")

smasMainMenu.blueCurtainsImage = Graphics.loadImageResolved("theming_smbxcurtainsblue.png")
smasMainMenu.redCurtainsImage = Graphics.loadImageResolved("theming_smbxcurtainsred.png")
smasMainMenu.orangeCurtainsImage = Graphics.loadImageResolved("theming_smbxcurtainsorange.png")

smasMainMenu.active = true
smasMainMenu.menuActive = false
smasMainMenu.introModeActive = false
smasMainMenu.battleModeLevel = 0
smasMainMenu.themeSelected = 0
smasMainMenu.enableMouseEnemyKilling = true

if smasMainMenu.active then
    smasBooleans.isOnMainMenu = true
    aw.enabled = false
    littleDialogue.cursorEnabled = false
    Graphics.activateHud(false)
    smasHud.visible.keys = false
    smasHud.visible.itembox = false
    smasHud.visible.bombs = false
    smasHud.visible.coins = false
    smasHud.visible.score = false
    smasHud.visible.lives = false
    smasHud.visible.stars = false
    smasHud.visible.starcoins = false
    smasHud.visible.timer = false
    smasHud.visible.levelname = false
    smasHud.visible.overworldPlayer = false
    smasHud.visible.deathcount = false
    smasHud.visible.customitembox = false
    smasHud.visible.pWing = false
    datetime.bottomright = true
    datetime.topright = false
    extrasounds.active = false
    smasMainMenu.startedmenu = 0
end

GameData.____holidayMenuEventEnded = false

smasMainMenu.aprilFools = false
smasMainMenu.aprilFoolsErrorImg = Graphics.loadImageResolved("SMAS - Intro/aprilfools1.png")

smasMainMenu.showVersionNumber = true
smasMainMenu.showEscapeToQuitMessage = true
smasMainMenu.showPlayerNameOnScreen = false
smasMainMenu.showPFPImageOnScreen = false
smasMainMenu.showWebsiteTextOnScreen = true
smasMainMenu.hideGameSMBXAndSMBX2Credits = false

smasMainMenu.showLogoOnScreen = true
smasMainMenu.showPressJumpText = true

smasMainMenu.showEasterEggMessage = false
smasMainMenu.showP1ActiveCharacterOnScreen = false
smasMainMenu.showStatusOf13ModeOnScreen = true
smasMainMenu.showStatusOfMultiplayerOnScreen = true

smasMainMenu.showWorldMapSkipMessage = false

smasMainMenu.showBlackScreen = false

local killed = false
local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

function introExit()
    GameData.____mainMenuComplete = true
    autoscroll.scrollLeft(5000)
    Routine.waitFrames(38)
    smasMainMenu.startedmenu = 0
    if SaveData.openingComplete then
        Level.load("SMAS - Intro.lvlx")
    else
        Level.load("SMAS - Opening Cutscene.lvlx")
    end
end

function battleRandomLevelSelect()
    smasMainMenu.showBlackScreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = true
    GameData.enableBattleMode = true
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load(smasTables.__classicBattleModeLevels[rng.randomInt(1,#smasTables.__classicBattleModeLevels)])
end

function battleLevelSelected()
    smasMainMenu.showBlackScreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    GameData.enableBattleMode = true
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load(smasTables.__classicBattleModeLevels[smasMainMenu.battleModeLevel])
end



function startRushMode()
    smasMainMenu.showBlackScreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.rushModeActive = true
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load(smasTables.__allMandatoryLevels[rng.randomInt(1,#smasTables.__allMandatoryLevels)], nil, nil)
end



function themeSelected()
    SaveData.introselect = smasMainMenu.themeSelected
    smasMainMenu.showBlackScreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load(smasTables.__mainMenuThemes[SaveData.introselect])
end

function theme4scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(19)
    autoscroll.scrollLeft(15)
    Routine.wait(8.2)
    Routine.loop(1768, theme4scrolling, true)
end

function theme5scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(17.3)
    autoscroll.scrollLeft(15)
    Routine.wait(7.2)
    Routine.loop(1571, theme5scrolling, true)
end

function theme6scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(19.5)
    autoscroll.scrollLeft(15)
    Routine.wait(8)
    Routine.loop(1787, theme6scrolling, true)
end

function theme8scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(17.5)
    autoscroll.scrollLeft(15)
    Routine.wait(7.5)
    Routine.loop(1625, theme8scrolling, true)
end

function theme9scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(13.8)
    autoscroll.scrollLeft(15)
    Routine.wait(6.2)
    Routine.loop(1265, theme9scrolling, true)
end

function theme11scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(16.2)
    autoscroll.scrollLeft(15)
    Routine.wait(7.2)
    Routine.loop(1521, theme11scrolling, true)
end

function theme14scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollUp(6)
    Routine.wait(13.6)
    autoscroll.scrollDown(15)
    Routine.wait(6.4)
    Routine.loop(1300, theme14scrolling, true)
end

function theme15scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(26.2)
    autoscroll.scrollLeft(15)
    Routine.wait(11.0)
    Routine.loop(2418, theme15scrolling, true)
end

function theme17scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(10.6)
    autoscroll.scrollLeft(15)
    Routine.wait(4.6)
    Routine.loop(lunatime.toTicks(15.2), theme17scrolling, true)
end

function theme18scrolling()
    NPC.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(16.6)
    autoscroll.scrollLeft(15)
    Routine.wait(7)
    Routine.loop(lunatime.toTicks(23.6), theme18scrolling, true)
end

function mapExit()
    GameData.____mainMenuComplete = true
    autoscroll.scrollLeft(5000)
    Routine.waitFrames(38)
    if not SaveData.openingComplete then
        Level.load("SMAS - Opening Cutscene.lvlx")
    else
        Level.load("map.lvlx")
    end
end

function easterEgg() --SnooPINGAS I see? ._.
    Routine.wait(0.1, true)
    Routine.wait(900, true)
    smasBooleans.overrideMusicVolume = true
    Audio.MusicFadeOut(player.section, 4000)
    Routine.wait(10, true)
    Sound.changeMusic("_OST/All Stars Secrets/ZZZ_Easter Egg.ogg", 0)
    Routine.wait(4.2, true)
    smasMainMenu.showEasterEggMessage = true
end

function FirstBoot1() --Welcome to SMAS++
    Sound.changeMusic("_OST/_Sound Effects/nothing.ogg", 0)
    Routine.wait(1.5)
    smasMainMenu.hideGameSMBXAndSMBX2Credits = true
    smasMainMenu.showLogoOnScreen = false
    smasMainMenu.showPressJumpText = false
    Sound.changeMusic("_OST/All Stars Menu/Boot Menu (First Time Boot Menu).ogg", 0)
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000001"), speakerName = "Welcome!", pauses = false, updatesInPause = true})
end

function MigrateOldSave1() --Migration message
    Sound.changeMusic("_OST/_Sound Effects/nothing.ogg", 0)
    Routine.wait(1.5)
    smasMainMenu.hideGameSMBXAndSMBX2Credits = true
    smasMainMenu.showLogoOnScreen = false
    smasMainMenu.showPressJumpText = false
    Sound.changeMusic("_OST/Photo Channel (Wii)/Slideshow (Scenic).ogg", 0)
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000009"), pauses = false, updatesInPause = true})
end

function MigrateOldSave2() --Migration Warning
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000010"), pauses = false, updatesInPause = true})
end

function MigrateOldSave3() --Migration started + completed
    SaveData.totalCoinsClassic = mem(0x00B2C5A8, FIELD_WORD)
    SaveData.totalLives = mem(0x00B2C5AC, FIELD_FLOAT)
    SaveData.totalScoreClassic = Misc.score()
    GameData.temporaryPowerupStored = player.powerup
    GameData.temporaryReserveStored = player.reservePowerup
    for k,v in ipairs(smasTables.__allLevels) do
        if table.icontains(Misc.getLegacyStarsCollectedNameOnly(),v) then
            table.insert(SaveData.completeLevels, v)
        end
    end
    for k,v in ipairs(smasTables.__allLevelsOptional) do
        if table.icontains(Misc.getLegacyStarsCollectedNameOnly(),v) then
            table.insert(SaveData.completeLevelsOptional, v)
        end
    end
    SaveData.totalStarCount = #SaveData.completeLevels
    Misc.eraseMainSaveSlot(Misc.saveSlot())
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000011"), pauses = false, updatesInPause = true})
end

function MigrateOldSaveCancelled()
    Sound.changeMusic("_OST/_Sound Effects/nothing.ogg", 0)
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000012"), pauses = false, updatesInPause = true})
end

function FirstBoot3() --Check the data/time
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000002"), pauses = false, updatesInPause = true})
end

function FirstBoot4() --Know your name
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000003"), pauses = false, updatesInPause = true})
end

function FirstBootKeyboardConfig() --Config inputs
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000004"), pauses = false, updatesInPause = true})
end

function FirstBoot5() --Game help?
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000005"), pauses = false, updatesInPause = true})
end

function FirstBoot6() --Without further ado, SMAS++!
    Sound.changeMusic("_OST/All Stars Menu/Boot Menu (First Boot).ogg", 0)
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000006"), pauses = false, updatesInPause = true})
    if not SaveData.firstBootCompleted then
        SaveData.firstBootCompleted = true
        GameData.playernameenterfirstboot = false
    end
    GameData.playernameenterfirstboot = false
    Misc.saveGame()
end
    
function FirstBootGameHelp() --Get game help or nah?
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000007"), pauses = false, updatesInPause = true})
    Misc.saveGame()
end

function TimeFixInfo1()
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000008"), pauses = false, updatesInPause = true})
end

function FailsafeMessage1() --You died on the main menu
    smasMainMenu.hideGameSMBXAndSMBX2Credits = true
    if SaveData.failsafeMessageOne then
        SaveData.failsafeMessageOne = false
    end
    SaveData.totalLives = SaveData.totalLives + 1
    Sound.muteMusic(-1)
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000013"), speakerName = "Whoops!", pauses = false, updatesInPause = true})
end

function bootDialogue(resetMusic)
    if resetMusic == nil then
        resetMusic = false
    end
    smasMainMenu.menuActive = true
    smasMainMenu.hideGameSMBXAndSMBX2Credits = true
    smasMainMenu.showEasterEggMessage = false
    smasMainMenu.showPressJumpText = false
    smasMainMenu.showPlayerNameOnScreen = false
    smasMainMenu.showPFPImageOnScreen = false
    --littleDialogue.create({text = transplate.getTranslation("0x0000000000000014"), speakerName = "Main Menu", pauses = false, updatesInPause = true})
    Sound.playSFX(14)
    smasMainMenuSystem.menuOpen = true
    if resetMusic then
        Sound.restoreMusic(-1)
    end
end

function battleModeDialogue() --Minigames
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000015"), speakerName = "Minigames", pauses = false, updatesInPause = true})
end

function optionsMenu1() --Options
    smasMainMenuSystem.menuOpen = true
end

function themeMenu1() --Intro theme menu
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000017"), speakerName = "Themes", pauses = false, updatesInPause = true})
end

function ResolutionSelect1() --Resolution settings
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000018"), speakerName = "Resolution Selection", pauses = false, updatesInPause = true})
end

function ClockSelect1() --Clock settings
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000019"), speakerName = "Clock Theme Selection", pauses = false, updatesInPause = true})
end



function classicBattleSelect() --Select level.
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000020"), pauses = false, updatesInPause = true})
end

function ChangeName1() --To change your name...
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000021"), pauses = false, updatesInPause = true})
end

function ChangePFP1() --To change your PFP...
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000022"), pauses = false, updatesInPause = true})
end

function ResolutionChange1() --Resolution changed.
    Sound.playSFX("resolution-set.ogg")
    Routine.waitFrames(1, true)
    smasResolutions.changeResolution()
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000023"), pauses = false, updatesInPause = true})
end

function ResolutionChangeBorder2() --Border toggled on/off.
    if SaveData.borderEnabled then
        Sound.playSFX("resolutionborder-disable.ogg")
        SaveData.borderEnabled = false
        Routine.waitFrames(1, true)
        smasResolutions.changeResolution()
    elseif not SaveData.borderEnabled then
        Sound.playSFX("resolutionborder-enable.ogg")
        SaveData.borderEnabled = true
        Routine.waitFrames(1, true)
        smasResolutions.changeResolution()
    end
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000024"), pauses = false, updatesInPause = true})
end

function ResolutionChangeScale3()
    if SaveData.letterbox then
        Sound.playSFX("letterbox-disable.ogg")
        SaveData.letterbox = false
        Routine.waitFrames(1, true)
        smasResolutions.changeResolution()
    elseif not SaveData.letterbox then
        Sound.playSFX("letterbox-enable.ogg")
        SaveData.letterbox = true
        Routine.waitFrames(1, true)
        smasResolutions.changeResolution()
    end
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000025"), pauses = false, updatesInPause = true})
end

function AccessibilityOptions1() --Accessibility Options
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000026"), speakerName = "Accessibility Options", pauses = false, updatesInPause = true})
end

function AccessibilityOptionToggle1() --Accessibility turned on/off
    SaveData.accessibilityTwirl = not SaveData.accessibilityTwirl
    if SaveData.accessibilityTwirl then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000027"), pauses = false, updatesInPause = true})
    else
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000028"), pauses = false, updatesInPause = true})
    end
end

function AccessibilityOptionToggle2() --Accessibility turned on/off
    SaveData.accessibilityWallJump = not SaveData.accessibilityWallJump
    if SaveData.accessibilityWallJump then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000027"), pauses = false, updatesInPause = true})
    else
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000028"), pauses = false, updatesInPause = true})
    end
end

function AccessibilityOptionToggle3() --Accessibility turned on/off
    SaveData.accessibilityInventory = not SaveData.accessibilityInventory
    if SaveData.accessibilityInventory then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000027"), pauses = false, updatesInPause = true})
    else
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000028"), pauses = false, updatesInPause = true})
    end
end

function AccessibilityOptionToggle4() --Accessibility turned on/off
    SaveData.enableLives = not SaveData.enableLives
    if SaveData.enableLives then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000027"), pauses = false, updatesInPause = true})
    else
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000028"), pauses = false, updatesInPause = true})
    end
end

function AccessibilityOptionToggle5() --Accessibility turned on/off
    SaveData.accessibilityGroundPound = not SaveData.accessibilityGroundPound
    if SaveData.accessibilityGroundPound then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000027"), pauses = false, updatesInPause = true})
    else
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000028"), pauses = false, updatesInPause = true})
    end
end

function ClockChange1() --Clock theme changed.
    Sound.playSFX("hour-change.ogg")
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000029"), pauses = false, updatesInPause = true})
end

function credits1() --Credits
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000030"), speakerName = "Credits", pauses = false, updatesInPause = true})
end

function X2Char() --Game settings applied
    if not SaveData.disableX2char then
        Sound.playSFX("1.3Mode/bowser-killed.ogg")
        SaveData.disableX2char = true
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000031"), pauses = false, updatesInPause = true})
    elseif SaveData.disableX2char then
        Sound.playSFX("x2-mode-enabled.ogg")
        SaveData.disableX2char = false
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000031"), pauses = false, updatesInPause = true})
    end
end

function InputConfig1() --Config inputs
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000032"), pauses = false, updatesInPause = true})
end

function startConfigurator()
    inputconfigurator.controlConfigOpen = true
end

function startPreConfiguratorKeyboard() --Which player?
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000033"), pauses = false, updatesInPause = true})
end

function startConfiguratorKeyboard()
    inputconfigurator.keyConfigOpen = true
    inputconfigurator.assigningToPlayer1 = true
end

function startConfiguratorKeyboardP2()
    inputconfigurator.keyConfigOpen = true
    inputconfigurator.assigningToPlayer2 = true
end

local nameBoard = newkeyboard.create{isImportant = true, isImportantButCanBeCancelled = true, clear = true, setVariable = SaveData.playerName, pause = false}
local pfpBoard = newkeyboard.create{isImportant = true, isImportantButCanBeCancelled = true, clear = true, setVariable = SaveData.playerPfp, pause = false}

function startKeyboard()
    newkeyboard.setVariable = SaveData.playerName
    nameBoard:open()
    GameData.playernameenter = true
end

function startKeyboardFirstBoot()
    newkeyboard.setVariable = SaveData.playerName
    nameBoard:open()
    GameData.playernameenterfirstboot = true
end

function startKeyboardPFP()
    newkeyboard.setVariable = SaveData.playerPfp
    pfpBoard:open()
    GameData.playerpfpenter = true
end

function startSaveSwitcher1()
    keyboard.active = true
    GameData.enablekeyboard = true
    GameData.saveslotswitchenter = true
end

function PFPinfo1() --PFP information
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000034"), pauses = false, updatesInPause = true})
end

function X2DisableCheck1()
    smasMainMenuSystem.menuOpen = false
    if Player.count() == 1 then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000035"), pauses = false, updatesInPause = true})
    end
    if Player.count() >= 2 then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000036"), pauses = false, updatesInPause = true})
    end
end

function TwoPlayerDisEnable1()
    smasMainMenuSystem.menuOpen = false
    if SaveData.disableX2char then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000037"), pauses = false, updatesInPause = true})
    elseif not SaveData.disableX2char then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000038"), pauses = false, updatesInPause = true})
    end
end

function BattleModeDisEnable1()
    smasMainMenuSystem.menuOpen = false
    if SaveData.disableX2char then
        if Player.count() == 1 then
            littleDialogue.create({text = transplate.getTranslation("0x0000000000000039"), pauses = false, updatesInPause = true})
        elseif Player.count() >= 2 then
            if Player.count() >= 3 then
                Playur.activate2ndPlayer()
            end
            littleDialogue.create({text = transplate.getTranslation("0x0000000000000040"), pauses = false, updatesInPause = true})
        end
    elseif not SaveData.disableX2char then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000041"), pauses = false, updatesInPause = true})
    end
end

function RushModeMenu1()
    smasMainMenuSystem.menuOpen = false
    if Player.count() == 1 then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000042"), pauses = false, updatesInPause = true})
    end
    if Player.count() >= 2 then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000043"), pauses = false, updatesInPause = true})
    end
end

function FramerateToggle1()
    SaveData.framerateEnabled = not SaveData.framerateEnabled
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000044"), pauses = false, updatesInPause = true})
end

function TwoPlayerCheck()
    Playur.activate2ndPlayer()
    Defines.player_hasCheated = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000045").."<question OkayToMenu>", pauses = false, updatesInPause = true})
end

function TwoPlayerCheckBattle()
    Playur.activate2ndPlayer()
    Defines.player_hasCheated = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000045").."<question OkayToBattle>", pauses = false, updatesInPause = true})
end

function ExitClassicBattle()
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000046"), pauses = false, updatesInPause = true})
end

function OnePlayerCheck()
    Playur.activate1stPlayer()
    Defines.player_hasCheated = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000047").."<question OkayToMenu>", pauses = false, updatesInPause = true})
end

function ChangeChar1()
    smasMainMenuSystem.menuOpen = false
    if not SaveData.disableX2char then
        smasCharacterChanger.menuActive = true
        smasCharacterChanger.animationActive = true
    elseif SaveData.disableX2char then
        if Player.count() == 2 then
            littleDialogue.create({text = transplate.getTranslation("0x0000000000000048"), pauses = false, updatesInPause = true})
        elseif Player.count() == 1 then
            littleDialogue.create({text = transplate.getTranslation("0x0000000000000049"), pauses = false, updatesInPause = true})
        end
    end
end

function ChangeChar1P()
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000049"), pauses = false, updatesInPause = true})
end

function ChangeChar2P()
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000050"), pauses = false, updatesInPause = true})
end

function ChangedCharacter()
    Sound.playSFX("charcost-selected.ogg")
    if Player.count() == 1 then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000051"), pauses = false, updatesInPause = true})
    end
    if Player.count() == 2 then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000051"), pauses = false, updatesInPause = true})
    end
end

function SaveOptions1()
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000052"), speakerName = "Saving Options", pauses = false, updatesInPause = true})
end

function SaveSlot1()
    if not Misc.inEditor() then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000053"), pauses = false, updatesInPause = true})
    elseif Misc.inEditor() then
        littleDialogue.create({text = transplate.getTranslation("0x0000000000000054"), pauses = false, updatesInPause = true})
    end
end

function EraseSave1()
    Sound.muteMusic(-1)
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000055"), pauses = false, updatesInPause = true})
end

function EraseSave2()
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000056"), pauses = false, updatesInPause = true})
end

function ExitDialogue(resetMusic, firstBootActive)
    smasMainMenuSystem.menuOpen = false
    Sound.playSFX(29)
    if resetMusic == nil then
        resetMusic = false
    end
    if firstBootActive == nil then
        firstBootActive = false
    end
    if not firstBootActive then
        smasMainMenu.menuActive = false
        smasMainMenu.hideGameSMBXAndSMBX2Credits = false
        smasMainMenu.showLogoOnScreen = true
        smasMainMenu.showPlayerNameOnScreen = true
        smasMainMenu.showPFPImageOnScreen = true
        smasMainMenu.showPressJumpText = true
        if SaveData.firstBootCompleted then
            smasMainMenu.startedmenu = 0
        end
        if Time.month() == 03 and Time.day() == 17 then
            stpatricksday = true
        end
        if resetMusic then
            Sound.restoreMusic(-1)
        end
    else
        smasMainMenu.menuActive = false
        smasMainMenu.showPlayerNameOnScreen = true
        smasMainMenu.showPFPImageOnScreen = true
        smasMainMenu.hideGameSMBXAndSMBX2Credits = false
        smasMainMenu.showLogoOnScreen = true
        smasMainMenu.showPressJumpText = true
        if SaveData.firstBootCompleted then
            smasMainMenu.startedmenu = 0
        end
        if Time.month() == 03 and Time.day() == 17 then
            stpatricksday = true
        end
        if resetMusic then
            Sound.restoreMusic(-1)
        end
    end
end

function MusicReset()
    smasMainMenu.menuActive = false
    if Time.month() == 03 and Time.day() == 17 then
        stpatricksday = true
    end
    Sound.restoreMusic(-1)
end

function ExitGame1()
    smasMainMenuSystem.menuOpen = false
    Sound.playSFX(29)
    smasMainMenu.showBlackScreen = true
    Sound.muteMusic(-1)
    Misc.saveGame()
    Routine.wait(0.4)
    Misc.exitEngine()
end

function ExitGameNoSave()
    smasMainMenu.showBlackScreen = true
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.exitEngine()
end

function SaveEraseStart()
    --Start opening SMAS++'s save files. From there, write default data to the files.
    Misc.eraseSaveSlot(Misc.saveSlot())
    --Then make the message telling that it's erased.
    littleDialogue.create({text = transplate.getTranslation("0x0000000000000057"), pauses = false, updatesInPause = true})
end

function BootSMASPlusPlusPreExecute() --This is the routine animation to execute the SMAS++ countdown to load either the intro or the map.
    smasMainMenuSystem.menuOpen = false
    Sound.playSFX("startsmasboot-executed.ogg")
    Sound.playSFX("startsmasboot-timerbeep.ogg")
    smasMainMenu.showWorldMapSkipMessage = true
    smasMainMenu.showLogoOnScreen = true
    Routine.wait(1.0) --Each second play a sound
    Sound.playSFX("startsmasboot-timerbeep.ogg")
    Routine.wait(1.0)
    Sound.playSFX("startsmasboot-timerbeep.ogg")
    Routine.wait(1.0)
    Sound.playSFX("startsmasboot-fullyexecuted.ogg")
    smasMainMenu.showBlackScreen = true --Black out everything
    smasMainMenu.showLogoOnScreen = false
    smasMainMenu.showWorldMapSkipMessage = false
    autoscroll.scrollLeft(5000) --Make sure that autoscroll doesn't move the player when loading any other level by accident
    Sound.muteMusic(-1) --Change the music to nothing
    Routine.wait(0.5)
    GameData.gameFirstLoaded = false
    Misc.saveGame()
    if (player.keys.down == KEYS_DOWN) then --Either one when holding down or not, executes a routine on which one to execute
        Routine.run(mapExit)
    end
    if not (player.keys.down == KEYS_DOWN) then 
        Routine.run(introExit)
    end
end

function BootCredits() --The credits lvl will probably be scrapped or not, depends
    Sound.muteMusic(-1)
    smasMainMenu.showBlackScreen = true
    Sound.playSFX(14)
    Routine.wait(0.5)
    Level.load("SMAS - Credits.lvlx")
end

function RestartSMASPlusPlus(clearSave) --This restarts SMAS++ entirely
    if clearSave == nil then
        clearSave = false
    end
    Sound.muteMusic(-1)
    smasMainMenu.showBlackScreen = true
    Routine.wait(0.5)
    if clearSave then
        SysManager.clearSaveDataAndGameDataAndRestart()
    else
        if not Misc.loadEpisode("Super Mario All-Stars++") then
            error("SMAS++ is not found. How is that even possible? Reinstall the game using the SMASUpdater, since something has gone terribly wrong.")
        end
    end
end

function BootGameHelpPreExecute() --Boot the game help level, the boot menu version at least
    smasMainMenuSystem.menuOpen = false
    Sound.playSFX(29)
    smasMainMenu.showBlackScreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    --GameData.gameHelpIntroActive = true
    Level.load("SMAS - Game Help (Boot Menu).lvlx")
end

function BootOnlinePreExecute() --Boot the Online Menu level
    if SMBX_VERSION == VER_SEE_MOD then
        smasMainMenuSystem.menuOpen = false
        Sound.playSFX(29)
        smasMainMenu.showBlackScreen = true
        autoscroll.scrollLeft(5000)
        Sound.muteMusic(-1)
        Routine.wait(0.4)
        Misc.saveGame()
        Level.load("SMAS - Online (Menu).lvlx")
    else
        Sound.playSFX(152)
    end
end

function PigeonRaca1() --This executes the True Final Battle
    if player.keys.jump == KEYS_PRESSED then
        player.keys.jump = KEYS_UNPRESSED
        Routine.wait(4.5) --Wait until loading the True Final Battle cutscene...
        smasMainMenu.startedmenu = 0
        Level.load("SMAS - Raca's World (Part 0).lvlx")
    end
end

function foolsinapril() --April Fools event for 4/1 of any year
    GameData.holidayrun = false
    Misc.pause()
    Routine.wait(5.5, true)
    Sound.playSFX("aprilfools.ogg")
    Routine.wait(2, true)
    Misc.unpause()
    smasMainMenu.aprilFools = false
    GameData.musreset = true
    smasMainMenu.showLogoOnScreen = true
    datetime.bottomright = true
    smasMainMenu.hideGameSMBXAndSMBX2Credits = false
    smasMainMenu.showPressJumpText = true
    GameData.____holidayMenuEventEnded = true
    smasMainMenu.startedmenu = 0
end

function SettingsSubmenu1()
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.1><question OptionsSubmenuOne>", speakerName = "Manage Settings", pauses = false, updatesInPause = true})
end

function SettingsSubmenu2()
    smasMainMenuSystem.menuOpen = false
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.3><question OptionsSubmenuTwo>", speakerName = "Resolution Settings", pauses = false, updatesInPause = true})
end
















function smasMainMenu.onInitAPI() --This requires some libraries to start
    registerEvent(smasMainMenu,"onExit")
    registerEvent(smasMainMenu,"onStart")
    registerEvent(smasMainMenu,"onTick")
    registerEvent(smasMainMenu,"onTickEnd")
    registerEvent(smasMainMenu,"onInputUpdate")
    registerEvent(smasMainMenu,"onEvent")
    registerEvent(smasMainMenu,"onDraw")
    registerEvent(smasMainMenu,"onEvent")
    registerEvent(smasMainMenu,"onPlayerHarm")
    registerEvent(smasMainMenu,"onPlayerKill")
    
    local Routine = require("routine")
    
    ready = true --We're ready, so we can begin
end

function smasMainMenu.onStart()
    if smasMainMenu.active then
        cursor.create()
        cursor.showCursor = true
        Audio.MusicVolume(nil) --Let the music volume reset
        
        if SaveData.failsafeMessageOne == 1 then --Change these values for users after 12/7/2022
            SaveData.failsafeMessageOne = true
        elseif SaveData.failsafeMessageOne == 0 then
            SaveData.failsafeMessageOne = false
        end
        if SaveData.failsafeMessageOne == nil then
            SaveData.failsafeMessageOne = false
        end
        
        if mem(0x00B251E0, FIELD_WORD) >= 1 then
            GameData.saveDataMigrated = false
        end
        if mem(0x00B251E0, FIELD_WORD) == 0 then
            GameData.saveDataMigrated = true
        end
        if not GameData.saveDataMigrated then
            Routine.run(MigrateOldSave1)
            smasMainMenu.startedmenu = 1
        end
        if SaveData.firstBootCompleted == nil then
            SaveData.firstBootCompleted = false --If starting for the first time, first boot will happen
        end
        if not SaveData.firstBootCompleted and GameData.saveDataMigrated and not SaveData.failsafeMessageOne then
            Routine.run(FirstBoot1)
            smasMainMenu.startedmenu = 1
        end
        if SaveData.firstBootCompleted and GameData.saveDataMigrated and not SaveData.failsafeMessageOne then
            GameData.playernameenterfirstboot = false
            Routine.run(easterEgg, true)
            smasMainMenu.showPlayerNameOnScreen = true
            smasMainMenu.showPFPImageOnScreen = true
        end
        if SaveData.failsafeMessageOne then
            Routine.run(FailsafeMessage1)
        end
        if Time.month() == 12 and Time.day() == 25 then --Change the weather on Christmas Day to snow
            Section(0).effects.weather = WEATHER_SNOW
        end
        Misc.saveGame()
        Defines.cheat_donthurtme = true --These are to prevent the player from dying
        Defines.cheat_shadowmario = true
        hearthover.active = false --No hearthover on the smasMainMenu
        if Time.month() == 04 and Time.day() == 01 then --BSOD lmao
            if GameData.____holidayMenuEventExecuted == nil or not GameData.____holidayMenuEventExecuted and not GameData.____holidayMenuEventEnded then
                smasMainMenu.startedmenu = 1
            elseif GameData.____holidayMenuEventEnded == true then
                smasMainMenu.startedmenu = 0
            end
        end
        if Time.month() == 03 and Time.day() == 17 then --St. Patrick's Day event
            stpatricksday = true
        end
        if Level.filename() == "intro_SMBX1.2.lvlx" then
            Routine.run(theme4scrolling)
        end
        if Level.filename() == "intro_SMBX1.3.lvlx" then
            Routine.run(theme5scrolling)
        end
        if Level.filename() == "intro_WSMBA.lvlx" then
            Routine.run(theme6scrolling)
        end
        if Level.filename() == "intro_theeditedboss.lvlx" then
            Routine.run(theme8scrolling)
        end
        if Level.filename() == "intro_SMBX1.3og.lvlx" then
            Routine.run(theme9scrolling)
        end
        if Level.filename() == "intro_8bit.lvlx" then
            Routine.run(theme11scrolling)
        end
        if Level.filename() == "intro_scrollingheights.lvlx" then
            Routine.run(theme14scrolling)
        end
        if Level.filename() == "intro_jakebrito1.lvlx" then
            Routine.run(theme15scrolling)
        end
        if Level.filename() == "intro_jakebrito2.lvlx" then
            Routine.run(theme17scrolling)
        end
        if Level.filename() == "intro_circuitcity.lvlx" then
            Routine.run(theme18scrolling)
        end
    end
end

function smasMainMenu.onTick()
    if smasMainMenu.active then
        if SaveData.firstBootCompleted == nil then
            SaveData.firstBootCompleted = false
        end
        if SaveData.firstBootCompleted == false then
            smasMainMenu.startedmenu = 1
        end
        if SaveData.firstBootCompleted == true then
            
        end
        if smasMainMenu.startedmenu == nil then
            smasMainMenu.startedmenu = 0
        end
        if GameData.reopenmenu then
            Routine.run(bootDialogue)
            GameData.reopenmenu = false
        end
        if GameData.firstbootfive then
            Routine.run(FirstBoot5)
            GameData.firstbootfive = false
        end
        if GameData.firstbootkeyboardconfig == true then
            Routine.run(FirstBootKeyboardConfig)
            GameData.firstbootkeyboardconfig = false
        end
        if GameData.reopenmenumusreset == true then
            Routine.run(BootDialogue, true)
            GameData.reopenmenumusreset = false
        end
        if GameData.musreset == true then
            Routine.run(MusicReset)
            GameData.musreset = false
        end
        Graphics.activateHud(false)
        littleDialogue.defaultStyleName = "bootmenudialog" --Change the text box to the SMBX 1.3 menu textbox format
        if SaveData.disableX2char == nil then
            SaveData.disableX2char = false
        end
        if not SaveData.disableX2char then
            smasHud.visible.lives = false
        elseif SaveData.disableX2char then
            smasHud.visible.lives = false
            for _,p in ipairs(Player.get()) do
                p.setCostume(1, nil)
                p.setCostume(2, nil)
                p.setCostume(3, nil)
                p.setCostume(4, nil)
                p.setCostume(5, nil)
            end
        end
        if (not killed and player:mem(0x13E,FIELD_BOOL)) then
            killed = true
            SaveData.failsafeMessageOne = true
            Level.load(Level.filename())
        end
        for i = 1,91 do
            Audio.sounds[i].muted = true
        end
    end
end

function smasMainMenu.onPause(evt)
    if smasMainMenu.active then
        evt.cancelled = true;
        isPauseMenuOpen = not isPauseMenuOpen
    end
end

function smasMainMenu.onInputUpdate()
    if smasMainMenu.active then
        player.keys.altJump = false
        player.keys.altRun = false
        player.keys.dropItem = false
        if player.rawKeys.pause == KEYS_PRESSED and not smasMainMenu.menuActive then
            if SaveData.firstBootCompleted then
                Routine.run(ExitGame1)
                Sound.playSFX("littleDialogue/smbx13/choose.wav")
            end
        end
        if smasMainMenu.startedmenu == 0 then
            if player.keys.jump == KEYS_PRESSED then
                Routine.run(bootDialogue)
                smasMainMenu.startedmenu = 1
            end
        end
        if smasMainMenu.startedmenu == 1 then
            if player.keys.jump == KEYS_PRESSED then
                --Nothing
            end
        end
        if smasMainMenu.startedmenu == 2 then
            if player.keys.jump == KEYS_PRESSED then
                Sound.changeMusic("_OST/All Stars Menu/Boot Menu (Crash SFX).ogg", 0)
                Section(player.section).effects.weather = WEATHER_NONE
                x2noticecheck = false
                x2noticecheckactive = false
                x2noticecheck = false
                twoplayercheck = false
                twoplayercheckactive = false
                smasMainMenu.showVersionNumber = false
                smasMainMenu.showLogoOnScreen = false
                datetime.bottomright = false
                smasMainMenu.hideGameSMBXAndSMBX2Credits = true
                smasMainMenu.showPressJumpText = false
                Section(0).backgroundID = 6
                Routine.run(PigeonRaca1)
            end
        end
        if (Time.month() == 04 and Time.day() == 01) then
            if GameData.____holidayMenuEventExecuted == nil or GameData.____holidayMenuEventExecuted == false and GameData.____holidayMenuEventEnded == false then
                if player.keys.jump == KEYS_PRESSED then
                    smasMainMenu.startedmenu = 1
                    Sound.muteMusic(-1)
                    smasMainMenu.showLogoOnScreen = false
                    datetime.bottomright = false
                    smasMainMenu.hideGameSMBXAndSMBX2Credits = true
                    smasMainMenu.showPressJumpText = false
                    smasMainMenu.aprilFools = true
                    Sound.playSFX("windows_error.ogg")
                    GameData.holidayrun = true
                    if GameData.holidayrun == true then
                        GameData.____holidayMenuEventExecuted = true
                        Routine.run(foolsinapril)
                    end
                end
                if GameData.____holidayMenuEventExecuted == true then
                    --Nothing
                end
            elseif GameData.____holidayMenuEventEnded == true then
                if player.keys.jump == KEYS_PRESSED then
                    
                end
            end
        end
        if smasMainMenu.startedmenu == 4 then
            if player.keys.jump == KEYS_PRESSED then
                Level.load("SMAS - Start.lvlx")
            end
        end
        if SaveData.racaActivated then
            smasMainMenu.startedmenu = 2
        end
    end
end

function harmNPC(npc,...) -- npc:harm but it returns if it actually did anything
    local oldKilled     = npc:mem(0x122,FIELD_WORD)
    local oldProjectile = npc:mem(0x136,FIELD_BOOL)
    local oldHitCount   = npc:mem(0x148,FIELD_FLOAT)
    local oldImmune     = npc:mem(0x156,FIELD_WORD)
    local oldID         = npc.id
    local oldSpeedX     = npc.speedX
    local oldSpeedY     = npc.speedY

    npc:harm(...)

    return (
           oldKilled     ~= npc:mem(0x122,FIELD_WORD)
        or oldProjectile ~= npc:mem(0x136,FIELD_BOOL)
        or oldHitCount   ~= npc:mem(0x148,FIELD_FLOAT)
        or oldImmune     ~= npc:mem(0x156,FIELD_WORD)
        or oldID         ~= npc.id
        or oldSpeedX     ~= npc.speedX
        or oldSpeedY     ~= npc.speedY
    )
end

function smasMainMenu.onPlayerKill(e)
    if smasMainMenu.active then
        e.cancelled = true
    end
end

function smasMainMenu.onPlayerHarm(e)
    if smasMainMenu.active then
        e.cancelled = true
    end
end

function smasMainMenu.onDraw()
    if smasMainMenu.active then
        if not smasMainMenu.introModeActive then
            for _,p in ipairs(Player.get()) do
                p.forcedState = FORCEDSTATE_INVISIBLE --Prevent any player from showing up on the boot menu
                p.x = camera.x + 450 - (p.width / 2) --Force all players somewhere to prevent deaths
                p.y = camera.y - 1 - (p.height / 2)
            end
        end
        
        local stpatricksday = false
        local hitNPCs = Colliders.getColliding{a = cursor.scenepos, b = hitNPCs, btype = Colliders.NPC}
        
        if smasMainMenu.showPFPImageOnScreen then
            if SaveData.playerPfp == nil then
                sprite.draw{texture = Img.load("pfp/pfp.png"), width = 40, height = 40, x = 10, y = 555, priority = -7}
            elseif SaveData.playerPfp then
                sprite.draw{texture = Img.load("___MainUserDirectory/"..SaveData.playerPfp..""), width = 40, height = 40, x = 10, y = 555, priority = -7}
            elseif unexpected_condition then
                sprite.draw{texture = Img.load("pfp/pfp.png"), width = 40, height = 40, x = 10, y = 555, priority = -7}
            end
        end
        if smasMainMenu.showPlayerNameOnScreen then
            if SaveData.playerName == nil then
                textplus.print{x = 60, y = 569, text = "<color rainbow>"..SysManager.getDefaultPlayerUsername().."</color>", font = smasMainMenu.sonicManiaFont, priority = -7, xscale = 1, yscale = 1}
            else
                textplus.print{x = 60, y = 569, text = "<color rainbow>"..SaveData.playerName.."</color>", font = smasMainMenu.sonicManiaFont, priority = -7, xscale = 1, yscale = 1}
            end
        end
        if Level.filename() == "intro_8bit.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_theeditedboss.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_S!TS!.lvlx" then
            --No curtains
        end
        if Level.filename() == "intro_SMAS.lvlx" then
            --No curtains
        end
        if Level.filename() == "intro_SMBX1.0.lvlx" then
            Graphics.drawImageWP(smasMainMenu.redCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX1.1.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX1.2.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX1.3.lvlx" then
            Graphics.drawImageWP(smasMainMenu.orangeCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX1.3og.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX2.lvlx" then
            --No curtains
        end
        if Level.filename() == "intro_SMBX2b3.lvlx" then
            Graphics.drawImageWP(smasMainMenu.orangeCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_WSMBA.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_sunsetbeach.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_scrollingheights.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_jakebrito1.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_jakebrito2.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        if Level.filename() == "intro_circuitcity.lvlx" then
            Graphics.drawImageWP(smasMainMenu.blueCurtainsImage, -1000, 0, -12)
        end
        
        if smasMainMenu.enableMouseEnemyKilling then
            local rngSpark = rng.randomInt(1,20)
            local rngSparkMovement = rng.randomInt(1,1.2)
            
            local randomValue = RNG.randomInt(1,6) - 1
            
            if cursor.left == KEYS_DOWN then
                if randomValue >= 2 then
                    local spark = Effect.spawn(80, cursor.sceneX, cursor.sceneY, player.section, false, true)
                    spark.speedX = RNG.random() * 4 - 2
                    spark.speedY = RNG.random() * 4 - 2
                end
                for _,npc in ipairs(hitNPCs) do
                    if not NPC.config[npc.id].iscoin then
                        -- Hurt the NPC, and make sure to not give the automatic score
                        local oldScore = NPC.config[npc.id].score
                        NPC.config[npc.id].score = 0
                        
                        local hurtNPC = harmNPC(npc,HARM_TYPE_NPC)
                        
                        if hurtNPC then
                            Misc.givePoints(0,{x = npc.x+npc.width*1.5,y = npc.y+npc.height*0.5},true)
                        end
                    else
                        -- Hurt the NPC, and make sure to not give the automatic score
                        local oldScore = NPC.config[npc.id].score
                        NPC.config[npc.id].score = 0
                        
                        local effect = Effect.spawn(78, npc.x, npc.y, player.section, false, true)
                        
                        local hurtNPC = harmNPC(npc,HARM_TYPE_NPC)
                        
                        if hurtNPC then
                            Misc.givePoints(0,{x = npc.x+npc.width*1.5,y = npc.y+npc.height*0.5},true)
                        end
                    end
                end
            end
        end
        if smasMainMenu.showVersionNumber then
            Graphics.drawBox{x=710, y=5, width=84, height=28, color=Color.black..0.5, priority=-7}
            textplus.print{x=718, y=10, text = VersionOfEpisode, priority=-6, color=Color.white, font=smasMainMenu.sonicManiaFont, xscale = 1.6, yscale = 1.6} --Version number of the episode
        end
        if smasMainMenu.showEscapeToQuitMessage then
            textplus.print{x=12, y=12, text = "Press pause to quit.", priority=-6, color=Color.yellow, xscale = 1.6, yscale = 1.6}
            Graphics.drawBox{x=5, y=5, width=148, height=28, color=Color.red..0.5, priority=-7}
        end
        if smasMainMenu.showPressJumpText then
            textplus.print{x=210, y=390, text = "Press jump to start", priority=-6, xscale = 2, yscale = 2, color=Color.white, font=smasMainMenu.mainMenuFont}
        end
        if smasMainMenu.showWebsiteTextOnScreen then
            textplus.print{x=30, y=522, text = "github.com/SpencerEverly/smasplusplus", priority=-6, xscale = 2, yscale = 2, color=Color.white, font=smasMainMenu.mainMenuFontWebsite}
        end
        if smasMainMenu.showLogoOnScreen then
            if SaveData.currentLanguage == "english" then
                Graphics.drawImageWP(smasMainMenu.smasLogoImg, 176, 16, -4)
            elseif SaveData.currentLanguage == "japanese" then
                Graphics.drawImageWP(smasMainMenu.smasLogoJpnImg, 106, 20, -4)
            else
                Graphics.drawImageWP(smasMainMenu.smasLogoImg, 176, 16, -4)
            end
        end
        if smasMainMenu.showBlackScreen then
            Graphics.drawScreen{color = Color.black, priority = 10}
        end
        if smasMainMenu.showStatusOfMultiplayerOnScreen then
            if Player.count() == 1 then
                textplus.print{x=243, y=10, text = "2 player mode is DISABLED", priority=-7, color=Color.yellow, font=statusFont, xscale = 1.6, yscale = 1.6}
            elseif Player.count() >= 2 then
                textplus.print{x=248, y=10, text = "2 player mode is ENABLED", priority=-7, color=Color.lightred, font=statusFont, xscale = 1.6, yscale = 1.6}
            end
        end
        if smasMainMenu.showStatusOf13ModeOnScreen then
            if not SaveData.disableX2char then
                textplus.print{x=243, y=26, text = "SMBX 1.3 mode is DISABLED", priority=-7, color=Color.yellow, font=statusFont, xscale = 1.6, yscale = 1.6}
            elseif SaveData.disableX2char then
                textplus.print{x=248, y=26, text = "SMBX 1.3 mode is ENABLED", priority=-7, color=Color.lightred, font=statusFont, xscale = 1.6, yscale = 1.6}
            end
        end
        if smasMainMenu.showP1ActiveCharacterOnScreen then
            textplus.print{x=303, y=20, text = "P1's Active Character: ", priority=-7, color=Color.yellow, font=statusFont}
        end
        if not smasMainMenu.hideGameSMBXAndSMBX2Credits then
            textplus.print{x=180, y=480, text = "Game by Spencer Everly, SMBX by redigit, SMBX2 by", priority=-7, color=Color.red, xscale = 2, yscale = 2}
            textplus.print{x=178, y=477, text = "Game by Spencer Everly, SMBX by redigit, SMBX2 by", priority=-6, color=Color.yellow, xscale = 2, yscale = 2}
            textplus.print{x=170, y=500, text = "Horikawa Otane, Kevsoft, Rednaxela, Hoeloe, and Enjl", priority=-7, color=Color.red, xscale = 2, yscale = 2}
            textplus.print{x=168, y=497, text = "Horikawa Otane, Kevsoft, Rednaxela, Hoeloe, and Enjl", priority=-6, color=Color.yellow, xscale = 2, yscale = 2}
        end
        if smasMainMenu.showWorldMapSkipMessage then
            if SaveData.openingComplete then
                textplus.print{x=40, y=450, text = "Hold down NOW to instantly skip to the World Map (3 seconds).", priority=0, color=Color.red, font=statusFont, xscale = 1.5, yscale = 1.5}
            end
        end
        if smasMainMenu.showEasterEggMessage then
            textplus.print{x=150, y=550, text = "Welcome to Totaka's Song. Congrats, you found the easter egg ;)", priority=0, color=Color.yellow, font=statusFont}
        end
        if smasMainMenu.aprilFools then    
            Graphics.drawImageWP(aprilFoolsErrorImg, 0, 0, 0)
        end
        if stpatricksday then
            textplus.print{x=300, y=460, text = "Happy St. Patricks Day!", priority=0, color=Color.green, font=statusFont}
        end
    end
end

function smasMainMenu.onExit()
    if smasMainMenu.active then
        Audio.MusicVolume(nil)
        autoscroll.unlockSection(0, 1)
        if SaveData.firstBootCompleted then
            smasMainMenu.startedmenu = 0
        elseif not SaveData.firstBootCompleted then
            smasMainMenu.startedmenu = 1
        end
        Defines.cheat_donthurtme = false
        Defines.cheat_shadowmario = false
        autoscroll.scrollLeft(5000)
    end
end

--The rest of the code will disable cheats to avoid breaking the main menu. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

if smasMainMenu.active then
    smasCheats.checkCheatStatusAndDisable()
end

smasMainMenuSystem.addSection{section = smasMainMenuSystem.menuSections.SECTION_MAIN, title = "Main Menu", xCenter = 150}
smasMainMenuSystem.addSection{section = smasMainMenuSystem.menuSections.SECTION_MINIGAMES, title = "Minigames", menuBackTo = smasMainMenuSystem.menuSections.SECTION_MAIN, xCenter = 150}
smasMainMenuSystem.addSection{section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, title = "Settings/Options", menuBackTo = smasMainMenuSystem.menuSections.SECTION_MAIN, xCenter = 200}
smasMainMenuSystem.addSection{section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MANAGE, title = "Manage Settings", menuBackTo = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, xCenter = 200}

smasMainMenuSystem.addMenuItem{name = "Start Game", section = smasMainMenuSystem.menuSections.SECTION_MAIN, sectionItem = 1, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(BootSMASPlusPlusPreExecute) end}
smasMainMenuSystem.addMenuItem{name = "Load Game Help", section = smasMainMenuSystem.menuSections.SECTION_MAIN, sectionItem = 2, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(BootGameHelpPreExecute) end}
smasMainMenuSystem.addMenuItem{name = "Minigames", section = smasMainMenuSystem.menuSections.SECTION_MAIN, sectionItem = 3, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() smasMainMenuSystem.goToMenuSection(2, 0, false) end}
smasMainMenuSystem.addMenuItem{name = "Online Multiplayer", section = smasMainMenuSystem.menuSections.SECTION_MAIN, sectionItem = 4, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(BootOnlinePreExecute) end}
smasMainMenuSystem.addMenuItem{name = "Main Menu Themes", section = smasMainMenuSystem.menuSections.SECTION_MAIN, sectionItem = 5, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(themeMenu1) end}
smasMainMenuSystem.addMenuItem{name = "Settings/Options", section = smasMainMenuSystem.menuSections.SECTION_MAIN, sectionItem = 6, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() smasMainMenuSystem.goToMenuSection(smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, 0, false) end}
smasMainMenuSystem.addMenuItem{name = "Credits", section = smasMainMenuSystem.menuSections.SECTION_MAIN, sectionItem = 7, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(credits1) end}
smasMainMenuSystem.addMenuItem{name = "Exit Main Menu", section = smasMainMenuSystem.menuSections.SECTION_MAIN, sectionItem = 8, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(ExitDialogue) end}
smasMainMenuSystem.addMenuItem{name = "Exit Game", section = smasMainMenuSystem.menuSections.SECTION_MAIN, sectionItem = 9, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(ExitGame1) end}




smasMainMenuSystem.addMenuItem{name = "Classic Battle Mode (2P)", section = smasMainMenuSystem.menuSections.SECTION_MINIGAMES, sectionItem = 1, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(BattleModeDisEnable1) end}
smasMainMenuSystem.addMenuItem{name = "Rush Mode (1P)", section = smasMainMenuSystem.menuSections.SECTION_MINIGAMES, sectionItem = 2, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(RushModeMenu1) end}




smasMainMenuSystem.addMenuItem{name = "2 Player Mode", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, sectionItem = 1, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(TwoPlayerDisEnable1) end}
smasMainMenuSystem.addMenuItem{name = "SMBX 1.3 Mode", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, sectionItem = 2, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(X2DisableCheck1) end}
smasMainMenuSystem.addMenuItem{name = "Input Configuration", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, sectionItem = 3, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(InputConfig1) end}
smasMainMenuSystem.addMenuItem{name = "Accessibility Options", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, sectionItem = 4, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(AccessibilityOptions1) end}
smasMainMenuSystem.addMenuItem{name = "Framerate Toggling", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, sectionItem = 5, menuType = smasMainMenuSystem.menuTypes.MENU_BOOLEAN, isFunction = false, booleanToUse = "framerateEnabled", isSaveData = true, isGameData = false}
smasMainMenuSystem.addMenuItem{name = "Manage Settings", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, sectionItem = 6, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() smasMainMenuSystem.goToMenuSection(smasMainMenuSystem.menuSections.SECTION_SETTINGS_MANAGE, 0, false) end}
smasMainMenuSystem.addMenuItem{name = "Save Data Settings", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MAIN, sectionItem = 7, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(SaveOptions1) end}





smasMainMenuSystem.addMenuItem{name = "Change Character", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MANAGE, sectionItem = 1, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(ChangeChar1) end}
smasMainMenuSystem.addMenuItem{name = "Change Player Name", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MANAGE, sectionItem = 2, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(ChangeName1) end}
smasMainMenuSystem.addMenuItem{name = "Change Profile Picture", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MANAGE, sectionItem = 3, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(ChangePFP1) end}
smasMainMenuSystem.addMenuItem{name = "Change Clock Theme", section = smasMainMenuSystem.menuSections.SECTION_SETTINGS_MANAGE, sectionItem = 4, menuType = smasMainMenuSystem.menuTypes.MENU_SELECTABLE, isFunction = true, functionToRun = function() Routine.run(ClockSelect1) end}






littleDialogue.registerAnswer("AccessibilityStuff",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("AccessibilityStuff",{text = "Toggle Twirling",chosenFunction = function() Routine.run(AccessibilityOptionToggle1) end})
littleDialogue.registerAnswer("AccessibilityStuff",{text = "Toggle Wall Jumping",chosenFunction = function() Routine.run(AccessibilityOptionToggle2) end})
littleDialogue.registerAnswer("AccessibilityStuff",{text = "Toggle Ground Pound",chosenFunction = function() Routine.run(AccessibilityOptionToggle5) end})
littleDialogue.registerAnswer("AccessibilityStuff",{text = "Toggle Additional Inventory",chosenFunction = function() Routine.run(AccessibilityOptionToggle3) end})
littleDialogue.registerAnswer("AccessibilityStuff",{text = "Toggle Lives",chosenFunction = function() Routine.run(AccessibilityOptionToggle4) end})
littleDialogue.registerAnswer("AccessibilityStuff",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})




littleDialogue.registerAnswer("IntroTheme",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Super Mario All-Stars++",chosenFunction = function() smasMainMenu.themeSelected = 1 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Where SMB Attacks",chosenFunction = function() smasMainMenu.themeSelected = 6 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.0.0",chosenFunction = function() smasMainMenu.themeSelected = 2 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.1.0",chosenFunction = function() smasMainMenu.themeSelected = 3 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.2.2",chosenFunction = function() smasMainMenu.themeSelected = 4 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.3.0",chosenFunction = function() smasMainMenu.themeSelected = 9 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.3.0.1",chosenFunction = function() smasMainMenu.themeSelected = 5 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX2 Beta 3",chosenFunction = function() smasMainMenu.themeSelected = 10 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX2 Beta 4",chosenFunction = function() smasMainMenu.themeSelected = 7 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "The Edited Boss (Eighth Edition)",chosenFunction = function() smasMainMenu.themeSelected = 8 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "8-Bit (By TepigFan101)",chosenFunction = function() smasMainMenu.themeSelected = 11 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Spencer! The Show! REBOOT",chosenFunction = function() smasMainMenu.themeSelected = 12 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Sunset Beach (By IkOshi1)",chosenFunction = function() smasMainMenu.themeSelected = 13 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Scrolling Heights",chosenFunction = function() smasMainMenu.themeSelected = 14 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "The Firey Castle (By Jake Brito)",chosenFunction = function() smasMainMenu.themeSelected = 15 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Mario Forever (Classic)",chosenFunction = function() smasMainMenu.themeSelected = 16 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "The Watery Airship (By Jake Brito)",chosenFunction = function() smasMainMenu.themeSelected = 17 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Circuit Central (By RvBNut91)",chosenFunction = function() smasMainMenu.themeSelected = 18 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Metroid Prime 2 (By SilverDeoxys)",chosenFunction = function() smasMainMenu.themeSelected = 19 Routine.run(themeSelected) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("BattleLevelSelect",{text = "Exit Battle Mode",chosenFunction = function() Routine.run(ExitClassicBattle) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Random Level",chosenFunction = function() Routine.run(battleRandomLevelSelect) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Battle Zone (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 1 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Battleshrooms (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 2 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Classic Castle Battle (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 3 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Dry Dry Desert (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 4 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Hyrule Temple (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 5 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Invasion Battlehammer (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 6 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Lakitu Mechazone (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 7 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Lethal Lava Level (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 8 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Retroville Underground (SMBX 1.3.0.1)",chosenFunction = function() smasMainMenu.battleModeLevel = 9 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Slippy Slap Snowland (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 10 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Woody Warzone (SMBX 1.3)",chosenFunction = function() smasMainMenu.battleModeLevel = 11 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Sky High Into the Skies",chosenFunction = function() smasMainMenu.battleModeLevel = 12 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "New Super Mario Bros. DS, Level 1 (By hrthrdh)",chosenFunction = function() smasMainMenu.battleModeLevel = 13 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "New Super Mario Bros. DS, Level 2 (By hrthrdh)",chosenFunction = function() smasMainMenu.battleModeLevel = 14 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "New Super Mario Bros. DS, Level 3 (By hrthrdh)",chosenFunction = function() smasMainMenu.battleModeLevel = 15 Routine.run(battleLevelSelected) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Exit Battle Mode",chosenFunction = function() Routine.run(ExitClassicBattle) end})



littleDialogue.registerAnswer("ClockSelect",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Disable Clock",chosenFunction = function() SaveData.clockTheme = "disabled" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Default (Normal)",chosenFunction = function() SaveData.clockTheme = "normal" Routine.run(ClockChange1) end})
--littleDialogue.registerAnswer("ClockSelect",{text = "Vintage",chosenFunction = function() SaveData.clockTheme = "vintage" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Homedics SS-4000",chosenFunction = function() SaveData.clockTheme = "homedics" Routine.run(ClockChange1) end})
--littleDialogue.registerAnswer("ClockSelect",{text = "R.O.B. Clock",chosenFunction = function() SaveData.clockTheme = "rob" Routine.run(ClockChange1) end})
--littleDialogue.registerAnswer("ClockSelect",{text = "Modern",chosenFunction = function() SaveData.clockTheme = "modern" Routine.run(ClockChange1) end})
--littleDialogue.registerAnswer("ClockSelect",{text = "Windows 98",chosenFunction = function() SaveData.clockTheme = "windows98" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Windows XP",chosenFunction = function() SaveData.clockTheme = "windowsxp" Routine.run(ClockChange1) end})
--littleDialogue.registerAnswer("ClockSelect",{text = "Windows 7",chosenFunction = function() SaveData.clockTheme = "windows7" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Windows 10",chosenFunction = function() SaveData.clockTheme = "windows10" Routine.run(ClockChange1) end})
--littleDialogue.registerAnswer("ClockSelect",{text = "Windows 11",chosenFunction = function() SaveData.clockTheme = "windows11" Routine.run(ClockChange1) end})
--littleDialogue.registerAnswer("ClockSelect",{text = "Mac OS X",chosenFunction = function() SaveData.clockTheme = "macosx" Routine.run(ClockChange1) end})
--littleDialogue.registerAnswer("ClockSelect",{text = "Ubuntu",chosenFunction = function() SaveData.clockTheme = "ubuntu" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Disable Clock",chosenFunction = function() SaveData.clockTheme = "disabled" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("ResolutionSelect",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Fullscreen (Default)",chosenFunction = function() SaveData.resolution = "fullscreen" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Widescreen (Most Screens)",chosenFunction = function() SaveData.resolution = "widescreen" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Ultrawide (Movie Resolution)",chosenFunction = function() SaveData.resolution = "ultrawide" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Steam Deck (PC Game System)",chosenFunction = function() SaveData.resolution = "steamdeck" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "NES, SNES, Genesis",chosenFunction = function() SaveData.resolution = "nes" Routine.run(ResolutionChange1) end})
--littleDialogue.registerAnswer("ResolutionSelect",{text = "Gameboy, Gameboy Color",chosenFunction = function() SaveData.resolution = "gameboy" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Gameboy Advance",chosenFunction = function() SaveData.resolution = "gba" Routine.run(ResolutionChange1) end})
--littleDialogue.registerAnswer("ResolutionSelect",{text = "iPhone (1st Generation)",chosenFunction = function() SaveData.resolution = "iphone1st" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Nintendo 3DS (Top Screen)",chosenFunction = function() SaveData.resolution = "3ds" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("SavingMenuOne",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("SavingMenuOne",{text = "Move Save to a Different Slot",chosenFunction = function() Routine.run(SaveSlot1) end})
littleDialogue.registerAnswer("SavingMenuOne",{text = "Erase Save Data",chosenFunction = function() Routine.run(EraseSave1) end})




littleDialogue.registerAnswer("SaveEraseChoice",{text = "Do not Erase",chosenFunction = function() Routine.run(BootDialogue, true) end})
littleDialogue.registerAnswer("SaveEraseChoice",{text = "ERASE",chosenFunction = function() Routine.run(SaveEraseStart) end})




littleDialogue.registerAnswer("SaveErasePreChoice",{text = "I understand",chosenFunction = function() Routine.run(EraseSave2) end})
littleDialogue.registerAnswer("SaveErasePreChoice",{text = "Nevermind",chosenFunction = function() Routine.run(BootDialogue, true) end})



littleDialogue.registerAnswer("StartNameChange",{text = "Begin",chosenFunction = function() Routine.run(startKeyboard) end})
littleDialogue.registerAnswer("StartNameChange",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("StartPFPChange",{text = "Begin",chosenFunction = function() Routine.run(startKeyboardPFP) end})
littleDialogue.registerAnswer("StartPFPChange",{text = "How do I use this?",chosenFunction = function() Routine.run(PFPinfo1) end})
littleDialogue.registerAnswer("StartPFPChange",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("StartInputs",{text = "Keyboard",chosenFunction = function() Routine.run(startPreConfiguratorKeyboard) end})
littleDialogue.registerAnswer("StartInputs",{text = "Controller",chosenFunction = function() Routine.run(startConfigurator) end})
littleDialogue.registerAnswer("StartInputs",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("StartInputPlayers",{text = "Player 1",chosenFunction = function() Routine.run(startConfiguratorKeyboard) end})
littleDialogue.registerAnswer("StartInputPlayers",{text = "Player 2",chosenFunction = function() Routine.run(startConfiguratorKeyboardP2) end})
littleDialogue.registerAnswer("StartInputPlayers",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("StartSaveSwitcher",{text = "Begin",chosenFunction = function() Routine.run(startSaveSwitcher1) end})
littleDialogue.registerAnswer("StartSaveSwitcher",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("ReturnMenu",{text = "Exit",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("RestartOption",{text = "Restart",chosenFunction = function() Routine.run(RestartSMASPlusPlus, true) end})



littleDialogue.registerAnswer("RestartOptionNoSaveErase",{text = "Restart",chosenFunction = function() Routine.run(RestartSMASPlusPlus) end})



littleDialogue.registerAnswer("FirstBootMenuOne",{text = "Begin",chosenFunction = function() Routine.run(FirstBoot3) end})



littleDialogue.registerAnswer("MigrateSaveMenuOne",{text = "Upgrade now",chosenFunction = function() Routine.run(MigrateOldSave2) end})
littleDialogue.registerAnswer("MigrateSaveMenuOne",{text = "No thanks",chosenFunction = function() Routine.run(MigrateOldSaveCancelled) end})


littleDialogue.registerAnswer("MigrateSaveMenuCancel",{text = "Quit Game",chosenFunction = function() Routine.run(ExitGameNoSave) end})



littleDialogue.registerAnswer("MigrateSaveMenuTwo",{text = "Start the upgrade now",chosenFunction = function() Routine.run(MigrateOldSave3) end})
littleDialogue.registerAnswer("MigrateSaveMenuTwo",{text = "No thanks",chosenFunction = function() Routine.run(MigrateOldSaveCancelled) end})


littleDialogue.registerAnswer("FirstBootMenuTwo",{text = "Yes",chosenFunction = function() Routine.run(FirstBoot4) end})
littleDialogue.registerAnswer("FirstBootMenuTwo",{text = "No",chosenFunction = function() Routine.run(TimeFixInfo1) end})




littleDialogue.registerAnswer("FirstBootMenuThree",{text = "Begin",chosenFunction = function() Routine.run(startKeyboardFirstBoot) end})




littleDialogue.registerAnswer("FirstBootMenuKeyboard",{text = "Start",chosenFunction = function() Routine.run(startConfiguratorKeyboard) end})



littleDialogue.registerAnswer("OnePlayerChoosing",{text = "Yes",chosenFunction = function() Routine.run(OnePlayerCheck) end})
littleDialogue.registerAnswer("OnePlayerChoosing",{text = "No",chosenFunction = function() Routine.run(optionsMenu1) end})


littleDialogue.registerAnswer("FirstBootMenuFour",{text = "How do I play?",chosenFunction = function() Routine.run(FirstBootGameHelp) end})
littleDialogue.registerAnswer("FirstBootMenuFour",{text = "Skip",chosenFunction = function() Routine.run(FirstBoot6) end})




littleDialogue.registerAnswer("FirstBootMenuGameHelp",{text = "Start Game Help",chosenFunction = function() Routine.run(BootGameHelpPreExecute) end})
littleDialogue.registerAnswer("FirstBootMenuGameHelp",{text = "Skip",chosenFunction = function() Routine.run(FirstBoot6) end})




littleDialogue.registerAnswer("FirstBootMenuFive",{text = "Let's get started!",chosenFunction = function() Routine.run(ExitDialogue, false, true) end})



littleDialogue.registerAnswer("FirstBootMenuTimeFix",{text = "Recheck",chosenFunction = function() Routine.run(FirstBoot3) end})



littleDialogue.registerAnswer("SaveSlotMove1",{text = "WIP",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("InputConfigStart",{text = "Begin",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("X2CharacterDisableOne",{text = "No",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("X2CharacterDisableOne",{text = "Yes", chosenFunction = function() Routine.run(X2Char) end})




littleDialogue.registerAnswer("BattleTwoPlayerCheckOne",{text = "Yes",chosenFunction = function() Routine.run(TwoPlayerCheckBattle) end})
littleDialogue.registerAnswer("BattleTwoPlayerCheckOne",{text = "No",chosenFunction = function() Routine.run(ExitClassicBattle) end})




littleDialogue.registerAnswer("BattleTwoPlayerCheckTwo",{text = "Yes",chosenFunction = function() Routine.run(classicBattleSelect) end})
littleDialogue.registerAnswer("BattleTwoPlayerCheckTwo",{text = "No",chosenFunction = function() Routine.run(ExitClassicBattle) end})



littleDialogue.registerAnswer("RushModeSelectionOne",{text = "Yes",chosenFunction = function() Routine.run(startRushMode) end})
littleDialogue.registerAnswer("RushModeSelectionOne",{text = "No",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "Yes (2 Player Mode)",chosenFunction = function() Routine.run(TwoPlayerCheck) end})
littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "Yes (1 Player Mode)",chosenFunction = function() Routine.run(OnePlayerCheck) end})
littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "No",chosenFunction = function() Routine.run(optionsMenu1) end})


littleDialogue.registerAnswer("ToBeAddedSoon",{text = "WIP",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("OkayToMenuTwo",{text = "Alright.",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("OkayToMenuTwoOptions",{text = "Alright.",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("OkayToBattle",{text = "Alrighty!",chosenFunction = function() Routine.run(classicBattleSelect) end})



littleDialogue.registerAnswer("OkayToMenu",{text = "Okay!",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("OkayToMenuOptions",{text = "Okay!",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("OkayToMenuTheme",{text = "Oh yeah, right.",chosenFunction = function() Routine.run(themeMenu1) end})



littleDialogue.registerAnswer("ToMenuResetTwo",{text = "Gotcha.",chosenFunction = function() Routine.run(ExitDialogue, true) end})





littleDialogue.registerAnswer("PlayerChoosingOne",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})
littleDialogue.registerAnswer("PlayerChoosingOne",{text = "Player 1",chosenFunction = function() Routine.run(ChangeChar1P) end})
littleDialogue.registerAnswer("PlayerChoosingOne",{text = "Player 2",chosenFunction = function() Routine.run(ChangeChar2P) end})



littleDialogue.registerAnswer("CharacterList1",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Mario (Slot 1)",chosenFunction = function() player:transform(1, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Luigi (Slot 2)",chosenFunction = function() player:transform(2, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Peach (Slot 3)",chosenFunction = function() player:transform(3, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Toad (Slot 4)",chosenFunction = function() player:transform(4, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Link (Slot 5)",chosenFunction = function() player:transform(5, true) Routine.run(ChangedCharacter) end})


littleDialogue.registerAnswer("CharacterList2",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Mario (Slot 1)",chosenFunction = function() player2:transform(1, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Luigi (Slot 2)",chosenFunction = function() player2:transform(2, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Peach (Slot 3)",chosenFunction = function() player2:transform(3, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Toad (Slot 4)",chosenFunction = function() player2:transform(4, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Link (Slot 5)",chosenFunction = function() player2:transform(5, true) Routine.run(ChangedCharacter) end})


littleDialogue.registerAnswer("CharacterListX2",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Mario (Slot 1)",chosenFunction = function() player:transform(1, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Luigi (Slot 2)",chosenFunction = function() player:transform(2, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Peach (Slot 3)",chosenFunction = function() player:transform(3, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Toad (Slot 4)",chosenFunction = function() player:transform(4, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Link (Slot 5)",chosenFunction = function() player:transform(5, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Mega Man (Slot 6)",chosenFunction = function() player:transform(6, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Wario (Slot 7)",chosenFunction = function() player:transform(7, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Bowser (Slot 8)",chosenFunction = function() player:transform(8, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Klonoa (Slot 9)",chosenFunction = function() player:transform(9, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Yoshi (Slot 10)",chosenFunction = function() player:transform(10, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Rosalina (Slot 11)",chosenFunction = function() player:transform(11, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Snake (Slot 12)",chosenFunction = function() player:transform(12, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Zelda (Slot 13)",chosenFunction = function() player:transform(13, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Minecraft Steve (Slot 14)",chosenFunction = function() player:transform(14, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Uncle Broadsword (Slot 15)",chosenFunction = function() player:transform(15, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Samus (Slot 16)",chosenFunction = function() player:transform(16, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})

return smasMainMenu