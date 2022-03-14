local versionnumber = "Open Source Edition" --This is the version number of this episode. It can be changed to any version we're on.
local littleDialogue = require("littleDialogue")
local textplus = require("textplus")
--if Misc.inEditor() then
	--Misc.showRichDialog("SMAS++ Boot Menu Level", "Hello!\n\nYou are trying to access the boot level through the editor. What are YOU doing here?\nI bet you just wanna snoop around and mess with the episode, eh?\n\nOh well, I don't blame you. Everything is open, so go right ahead!", true)
--end
local extrasounds = require("extrasounds")
local autoscroll = require("autoscrolla")
local backgroundTarget = Graphics.CaptureBuffer(800,600)
local sec = Section(0)

local player2 = Player(2)

local ready = false

local fontthree = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")

runPressedState = false

local bootmenu = {}

extrasounds.active = false
bootmenu.active = true

local aprilfools = false
local aprilfoolserror = Graphics.loadImageResolved("SMAS - Intro/aprilfools1.png")

local Routine = require("routine")

local level = Level.filename()
local m = RNG.randomInt(1,56-1)

local versionactive = true
local logo = true
local pressjumpwords = true
local active = false
local active2 = true
local active3 = false
local charactercheck = false
local keyinput1 = false
local killed = false
local active4 = false

local cooldown = 0

Graphics.activateHud(false)

local middle = 0

local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

local hour = os.date("%H")

local day = os.date("%d")

local month = os.date("%m")

local exacttime = os.date("%X")

littleDialogue.registerStyle("smbx13",{
	textXScale = 1,
    textYScale = 1,
    borderSize = 36,
	textMaxWidth = 500,
	speakerNameGap = 6,
	speakerNameXScale = 1.2,        -- X scale of the speaker's name.
    speakerNameYScale = 1.2,
	
	openSpeed = 5,
	pageScrollSpeed = 5, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 5, -- How fast it scrolls when switching answer pages.
	borderSize = 8,
	
	forcedPosEnabled = true,       -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
    forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
    forcedPosY = 150,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
    forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
    forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

	windowingOpeningEffectEnabled = false,

	typewriterEnabled = false,
    showTextWhileOpening = true,

	closeSoundEnabled = false,
	continueArrowEnabled = false,
	scrollArrowEnabled   = false,
	selectorImageEnabled = true,
	
})

local function introExit()
	Routine.waitFrames(38)
	Level.load("SMAS - Intro.lvlx", nil, nil)
end

local function mapExit()
	Routine.waitFrames(38)
	Level.exit()
end

local function theme1()
	SaveData.introselect = 1
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_SMAS.lvlx", nil, nil)
end

local function theme2()
	SaveData.introselect = 2
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_SMBX1.0.lvlx", nil, nil)
end

local function theme3()
	SaveData.introselect = 3
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_SMBX1.1.lvlx", nil, nil)
end

local function theme4()
	SaveData.introselect = 4
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_SMBX1.2.lvlx", nil, nil)
end

local function theme4scrolling()
	autoscroll.scrollRight(6)
	Routine.wait(19)
	autoscroll.scrollLeft(15)
	Routine.wait(8.2)
	Routine.loop(1768, theme4scrolling, true)
end

local function theme5()
	SaveData.introselect = 5
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_SMBX1.3.lvlx", nil, nil)
end

local function theme5scrolling()
	autoscroll.scrollRight(6)
	Routine.wait(17)
	autoscroll.scrollLeft(15)
	Routine.wait(7.2)
	Routine.loop(1573, theme5scrolling, true)
end

local function theme6()
	SaveData.introselect = 6
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_WSMBA.lvlx", nil, nil)
end

local function theme6scrolling()
	autoscroll.scrollRight(6)
	Routine.wait(19.5)
	autoscroll.scrollLeft(15)
	Routine.wait(8)
	Routine.loop(1787, theme6scrolling, true)
end

local function theme7()
	SaveData.introselect = 7
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_SMBX2.lvlx", nil, nil)
end

local function theme8()
	SaveData.introselect = 8
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_bossedit8.lvlx", nil, nil)
end

local function theme8scrolling()
	autoscroll.scrollRight(6)
	Routine.wait(17.5)
	autoscroll.scrollLeft(15)
	Routine.wait(7.5)
	Routine.loop(1625, theme8scrolling, true)
end

local function theme9()
	SaveData.introselect = 9
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_SMBX1.3og.lvlx", nil, nil)
end

local function theme9scrolling()
	autoscroll.scrollRight(6)
	Routine.wait(13.8)
	autoscroll.scrollLeft(15)
	Routine.wait(6.2)
	Routine.loop(1265, theme9scrolling, true)
end

local function theme10()
	SaveData.introselect = 10
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_SMBX2b3.lvlx", nil, nil)
end

local function theme11()
	SaveData.introselect = 11
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_8bit.lvlx", nil, nil)
end

local function theme11scrolling()
	autoscroll.scrollRight(6)
	Routine.wait(16.2)
	autoscroll.scrollLeft(15)
	Routine.wait(7.2)
	Routine.loop(1521, theme11scrolling, true)
end

local function theme12()
	SaveData.introselect = 12
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_S!TS!.lvlx", nil, nil)
end

local function theme13()
	SaveData.introselect = 13
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_sunsetbeach.lvlx", nil, nil)
end

local function theme14()
	SaveData.introselect = 14
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_scrollingheights.lvlx", nil, nil)
end

local function theme14scrolling()
	autoscroll.scrollUp(6)
	Routine.wait(13.6)
	autoscroll.scrollDown(15)
	Routine.wait(6.4)
	Routine.loop(1300, theme14scrolling, true)
end

local function theme15()
	SaveData.introselect = 15
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("intro_jakebrito1.lvlx", nil, nil)
end

local function theme15scrolling()
	autoscroll.scrollRight(6)
	Routine.wait(26.2)
	autoscroll.scrollLeft(15)
	Routine.wait(11.0)
	Routine.loop(2418, theme15scrolling, true)
end

local function mapExit()
	autoscroll.scrollLeft(5000)
	Routine.waitFrames(38)
	Level.exit()
end

local function easterEgg() --SnooPINGAS I see? ._.
	Routine.wait(900)
	Audio.MusicFadeOut(player.section, 4000)
	Routine.waitFrames(4000)
	Routine.wait(300)
	Audio.MusicChange(0, "_OST/All Stars Secrets/ZZZ_Easter Egg.ogg")
	Routine.wait(4.2)
	active4 = true
end

local function SaveDataError2()
	Audio.MusicChange(0, 0)
	Audio.SeizeStream(0)
	Routine.wait(1.5)
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.0>It looks like SavaData couldn't be read or corrupted.<page>If that is happening, you probably loaded this episode on the broken X2 launcher found in the actual SMBX2 program.<page>Unfortunately, this means that SaveData could be corrupted.<page>Next time, please launch the game using the X2 launch menu found on SMBX2.exe.<page>Please close this dialogue box by pressing jump, then press pause to exit the game.", speakerName = "Whoops!", pauses = false, updatesInPause = true})
end

local function FirstBoot1()
	Audio.MusicChange(0, "_OST/_Sound Effects/nothing.ogg")
	Routine.wait(1.5)
	active = true
	logo = false
	pressjumpwords = false
	Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu (First Time Boot Menu).ogg")
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.5>Welcome to Super Mario All-Stars++.<page>This game combines Super Mario Bros. 1-3, The Lost Levels, World,<page>And also includes a new game, along with extra content.<page>Please note that this is an Open Source project.<page>So please understand that BUGS may occur! Don't hesitate to report them on the GitHub page.<page>You can find it at https://github.com/SpencerEverly/smasplusplus/.<page>Other than that, please enjoy the game!<page>But, before we get started, this game needs to set up some prerequisite options.<question FirstBootMenuOne>", speakerName = "Welcome!", pauses = false, updatesInPause = true})
end

local function FirstBoot3()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.2>Check the date and time below (It should be on the bottom-right corner). Is that time, and the system date correct?<question FirstBootMenuTwo>", pauses = false, updatesInPause = true})
end

local function FirstBoot4()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.6>What is your name? (Not finished yet)<question FirstBootMenuThree>", pauses = false, updatesInPause = true})
end

local function FirstBoot5()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.0>Looks like you're good! Before you begin, do you know how to play the game?<page>If you already know how to play, you can select Skip.<question FirstBootMenuFour>", pauses = false, updatesInPause = true})
end

local function FirstBoot6()
	Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu (First Boot).ogg")
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.5>Without further ado, Super Mario All-Stars++!<question FirstBootMenuFive>", pauses = false, updatesInPause = true})
	if SaveData.firstBootCompleted == 0 then
		SaveData.firstBootCompleted = SaveData.firstBootCompleted + 1
	end
	Misc.saveGame()
	if SaveData.firstBootCompleted == 2 then
		SaveData.firstBootCompleted = SaveData.firstBootCompleted - 2
	end
end
	
local function FirstBootGameHelp()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.8>To get help in playing the game, you'll need to redirect to the Game Help level. Would you like to enter the level, or skip? You can load Game Help again on the title screen later if you want to.<question FirstBootMenuGameHelp>", pauses = false, updatesInPause = true})
	Misc.saveGame()
end

local function TimeFixInfo1()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.3><setPos 400 32 0.5 -1.2>Depending on the issue, please visit sites like https://support.kaspersky.com/common/windows/3508<page>Or use Google/DuckDuckGo and search up -fixing system time-.<page>Please fix the time first, then after fixing the time should automatically update. Press -Recheck- to recheck the time again.<question FirstBootMenuTimeFix>", pauses = false, updatesInPause = true})
end

local function FailsafeMessage1()
	active = true
	if SaveData.failsafeMessageOne == 1 then
		SaveData.failsafeMessageOne = SaveData.failsafeMessageOne - 1
	end
	Audio.MusicChange(0, 0)
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.9>It looks like the menu restarted.<page>When that happened, you probably died here in the boot screen.<page>If there are any problems, don't hesitate to email spencer.everly at gmail.com or contact them on Discord at Spencer Everly#1997.<question ToMenuResetTwo>", speakerName = "Whoops!", pauses = false, updatesInPause = true})
end

local function bootDialogue()
	active = true
	active4 = false
	logo = false
	pressjumpwords = false
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.3><question MainMenu>", speakerName = "Main Menu", pauses = false, updatesInPause = true})
end

local function menuDialogue()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.1><question MainMenu>", speakerName = "Main Menu", pauses = false, updatesInPause = true})
end

local function gamebootDialogue()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.9><question GameBoot>", speakerName = "Start Game", pauses = false, updatesInPause = true})
end

local function optionsMenu1()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.8><question Options>", speakerName = "Options", pauses = false, updatesInPause = true})
end

local function themeMenu1()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.8><question IntroTheme>", speakerName = "Themes", pauses = false, updatesInPause = true})
end


local function credits1()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.1>For information on everything that made this episode possible, it wouldn't have been possible without more than 100 people and counting.<page>To see the credits of this episode, go into the worlds folder, the SMAS folder, and redirect to the CREDITS.txt file in the folder.<question ReturnMenu>", speakerName = "Credits", pauses = false, updatesInPause = true})
end

local function X2Char()
	if SaveData.disableX2char == 0 then
		SFX.play("_OST/_Sound Effects/1.3-mode-enabled.ogg")
		SaveData.disableX2char = SaveData.disableX2char + 1
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.6>Game settings have been applied.<question OkayToMenu>", pauses = false, updatesInPause = true})
	elseif SaveData.disableX2char == 1 then
		SFX.play("_OST/_Sound Effects/x2-mode-enabled.ogg")
		SaveData.disableX2char = SaveData.disableX2char - 1
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.6>Game settings have been applied.<question OkayToMenu>", pauses = false, updatesInPause = true})
	end
end

local function InputConfig1()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.7>To begin configuring the inputs of the game, please select Begin to get started.<question ToBeAddedSoon>", pauses = false, updatesInPause = true})
end

local function X2DisableCheck1()
	if Player.count() == 1 then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.75>Would you like to enable/disable SMBX 1.3 mode? If enabled, certain features will be disabled and some compatibility for 2 player mode will be restored. (Costumes will reset, so be careful!)<question X2CharacterDisableOne>", pauses = false, updatesInPause = true})
	end
	if Player.count() == 2 then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.7>You can't use 2 player mode on X2 mode. Please enable SMBX 1.3 mode first before proceeding.<question OkayToMenuTwoOptions>", pauses = false, updatesInPause = true})
	end
end

local function TwoPlayerDisEnable1()
	if SaveData.disableX2char == 1 then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.6>Since you have X2 characters disabled, you can use 2 playermode!<page>Would you like to enable/disable 2 player mode?<question TwoPlayerDisableOne>", pauses = false, updatesInPause = true})
	elseif SaveData.disableX2char == 0 then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.6>Unfortunately, you'll need to disable X2 characters to toggle this on and off.<page>This is due to stability and game breaking reasons.<question OkayToMenuTwoOptions>", pauses = false, updatesInPause = true})
	end
end

local function FramerateToggle1()
	Cheats.trigger("framerate")
	Defines.player_hasCheated = false
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.4>Framerate has been toggled either on or off. You can see it on the top-left corner of the screen.<question OkayToMenu>", pauses = false, updatesInPause = true})
end

local function TwoPlayerCheck()
	if Player.count() == 1 then
		Cheats.trigger("2player")
		Defines.player_hasCheated = false
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -3.1>2 player mode activated.<question OkayToMenu>", pauses = false, updatesInPause = true})
	end
end

local function OnePlayerCheck()
	if Player.count() == 2 then
		Cheats.trigger("1player")
		Defines.player_hasCheated = false
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -3.1>1 player mode activated.<question OkayToMenu>", pauses = false, updatesInPause = true})
	end
end

local function FailsafeMessage1()
	local playerlives = mem(0x00B2C5AC,FIELD_FLOAT)
	playerlives = playerlives + 1
end

local function PathFix1()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.6>Would you like to fix the world map paths? Only do this if future updates break the map.<question ToBeAddedSoon>", pauses = false, updatesInPause = true})
end

local function ChangeChar1()
	if SaveData.disableX2char == 0 then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.8>Who shall you change into? (X2 Characters Enabled)<question CharacterListX2>", pauses = false, updatesInPause = true})
	end
	if SaveData.disableX2char == 1 then
		if Player.count() == 2 then
			littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.7>Which player do you want to change characters to?<question PlayerChoosingOne>", pauses = false, updatesInPause = true})
		elseif Player.count() == 1 then
			littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.9>Who shall you change Player 1 into? (X2 Characters Disabled)<question CharacterList1>", pauses = false, updatesInPause = true})
		end
	end
end

local function ChangeChar1P()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.9>Who shall you change Player 1 into? (X2 Characters Disabled)<question CharacterList1>", pauses = false, updatesInPause = true})
end

local function ChangeChar2P()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.9>Who shall you change Player 2 into? (X2 Characters Disabled)<question CharacterList2>", pauses = false, updatesInPause = true})
end

local function ChangedCharacter()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	if Player.count() == 1 then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -3.2>Character changing succeeded.<question OkayToMenuOptions>", pauses = false, updatesInPause = true})
	end
	if Player.count() == 2 then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -3.2>Character changing succeeded.<question OkayToMenuOptions>", pauses = false, updatesInPause = true})
	end
end

local function SaveOptions1()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.7><question SavingMenuOne>", speakerName = "Saving Options", pauses = false, updatesInPause = true})
end

local function SaveSlot1()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.9>Select slot by typing the number above. Press jump when you have picked the right slot (Max is 32,767) DATA FROM THE PREVIOUS SLOT, IF ANY, WILL BE OVERWRITTEN! Don't put a number in to cancel this option.<question ToBeAddedSoon>", pauses = false, updatesInPause = true})
end

local function EraseSave1()
	Audio.MusicChange(0, 0)
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.6>Once you erase your save, you CAN NOT go back unless you use tools like Recuva.<page>Erasing your save is for if you want to start over from the beginning.<question SaveErasePreChoice>", pauses = false, updatesInPause = true})
end

local function EraseSave2()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.0>ARE YOU SURE YOU WANT TO ERASE YOUR SAVE DATA?<question SaveEraseChoice>", pauses = false, updatesInPause = true})
end

local function BootDialogueMusicReset()
	active = true
	active4 = false
	logo = false
	pressjumpwords = false
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.3><question MainMenu>", speakerName = "Main Menu", pauses = false, updatesInPause = true})
	if Level.filename() == "intro_8bit.lvlx" then
		Audio.MusicChange(0, "intro_8bit/8-Bit File Select Theme (Super Mario 64).ogg")
	end
	if Level.filename() == "intro_bossedit8.lvlx" then
		Audio.MusicChange(0, "_OST/Super Smash Bros. Melee/smari3.ogg")
	end
	if Level.filename() == "intro_S!TS!.lvlx" then
		Audio.MusicChange(0, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
	end
	if Level.filename() == "intro_SMAS.lvlx" then
		Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu.ogg")
	end
	if Level.filename() == "intro_SMBX1.0.lvlx" then
		Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	end
	if Level.filename() == "intro_SMBX1.1.lvlx" then
		Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	end
	if Level.filename() == "intro_SMBX1.2.lvlx" then
		Audio.MusicChange(0, 53)
	end
	if Level.filename() == "intro_SMBX1.3.lvlx" then
		Audio.MusicChange(0, 56)
	end
	if Level.filename() == "intro_SMBX1.3og.lvlx" then
		Audio.MusicChange(0, 55)
	end
	if Level.filename() == "intro_SMBX2.lvlx" then
		Audio.MusicChange(0, m)
	end
	if Level.filename() == "intro_SMBX2b3.lvlx" then
		--Music doesn't mute
	end
	if Level.filename() == "intro_WSMBA.lvlx" then
		Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|0;g=2.2")
	end
	if Level.filename() == "intro_sunsetbeach.lvlx" then
		Audio.MusicChange(0, "_OST/Super Mario Galaxy 2/SMG2_galaxy06_strm.ogg")
	end
	if Level.filename() == "intro_scrollingheights.lvlx" then
		Audio.MusicChange(0, "_OST/Nintendo Land/J_Blf_night.w.48.dspadpcm.ogg")
	end
	if Level.filename() == "intro_jakebrito1.lvlx" then
		Audio.MusicChange(0, "_OST/Mario & Luigi - Bowser's Inside Story/In the Final.ogg")
	end
end

local function ExitDialogueFirstBoot()
	active = false
	logo = true
	pressjumpwords = true
	if SaveData.firstBootCompleted == 1 then
		GameData.startedmenu = GameData.startedmenu - 1
	end
	if GameData.startedmenu == nil then
		GameData.startedmenu = 4
	end
end

local function ExitDialogue()
	active = false
	logo = true
	pressjumpwords = true
	if SaveData.firstBootCompleted == 1 then
		GameData.startedmenu = GameData.startedmenu - 1
	end
end

local function ExitDialogueMusicReset()
	active = false
	logo = true
	pressjumpwords = true
	if SaveData.firstBootCompleted == 1 then
		GameData.startedmenu = GameData.startedmenu - 1
	end
	if Level.filename() == "intro_8bit.lvlx" then
		Audio.MusicChange(0, "intro_8bit/8-Bit File Select Theme (Super Mario 64).ogg")
	end
	if Level.filename() == "intro_bossedit8.lvlx" then
		Audio.MusicChange(0, "_OST/Super Smash Bros. Melee/smari3.ogg")
	end
	if Level.filename() == "intro_S!TS!.lvlx" then
		Audio.MusicChange(0, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
	end
	if Level.filename() == "intro_SMAS.lvlx" then
		Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu.ogg")
	end
	if Level.filename() == "intro_SMBX1.0.lvlx" then
		Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	end
	if Level.filename() == "intro_SMBX1.1.lvlx" then
		Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	end
	if Level.filename() == "intro_SMBX1.2.lvlx" then
		Audio.MusicChange(0, 53)
	end
	if Level.filename() == "intro_SMBX1.3.lvlx" then
		Audio.MusicChange(0, 56)
	end
	if Level.filename() == "intro_SMBX1.3og.lvlx" then
		Audio.MusicChange(0, 55)
	end
	if Level.filename() == "intro_SMBX2.lvlx" then
		Audio.MusicChange(0, m)
	end
	if Level.filename() == "intro_SMBX2b3.lvlx" then
		--Music doesn't mute
	end
	if Level.filename() == "intro_WSMBA.lvlx" then
		Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|0;g=2.2")
	end
	if Level.filename() == "intro_sunsetbeach.lvlx" then
		Audio.MusicChange(0, "_OST/Super Mario Galaxy 2/SMG2_galaxy06_strm.ogg")
	end
	if Level.filename() == "intro_scrollingheights.lvlx" then
		Audio.MusicChange(0, "_OST/Nintendo Land/J_Blf_night.w.48.dspadpcm.ogg")
	end
	if Level.filename() == "intro_jakebrito1.lvlx" then
		Audio.MusicChange(0, "_OST/Mario & Luigi - Bowser's Inside Story/In the Final.ogg")
	end
end

local function ExitGame1()
	exitscreen = true
	Audio.MusicChange(0, 0)
	Misc.saveGame()
	Routine.wait(0.4)
	Misc.exitEngine()
end

local function SaveEraseStart()
	SaveData.clear()
	GameData.clear()
	SaveData.flush()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.1>Erasing complete (Save data erasing hasn't been added to SMBX2 yet, so your save is still available. Please erase the save by deleting your save slot in the episode folder).<question RestartOption>", pauses = false, updatesInPause = true})
end

local function ExitToIntro()
	Level.load("SMAS - Intro.lvlx", nil, nil)
end

local function ExitToMap()
	Level.exit()
end

local function BootSMASPlusPlusPreExecute()
	SFX.play("_OST/_Sound Effects/boot_wsmba.ogg")
	active3 = true
	logo = true
	Routine.wait(3.0)
	exitscreen = true
	logo = false
	active3 = false
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.5)
	Misc.saveGame()
	if (player.keys.down == KEYS_DOWN) == true then
		Routine.run(mapExit)
	end
	if (player.keys.down == KEYS_DOWN) == false then 
		Routine.run(introExit)
	end
end

local function BootCredits()
	Audio.MusicChange(0, 0)
	exitscreen = true
	SFX.play(14)
	Routine.wait(0.5)
	Level.load("SMAS - Credits.lvlx", nil, nil)
end
	
local function BootWSMBAPreExecute()
	Audio.MusicChange(0, 0)
	exitscreen = true
	SFX.play(14)
	autoscroll.scrollLeft(5000)
	Routine.wait(0.5)
	Audio.sounds[1].sfx  = nil	
	Audio.sounds[2].sfx  = nil
	Audio.sounds[3].sfx  = nil
	Audio.sounds[4].sfx  = nil
	Audio.sounds[5].sfx  = nil
	Audio.sounds[6].sfx  = nil
	Audio.sounds[7].sfx  = nil
	Audio.sounds[8].sfx  = nil
	Audio.sounds[9].sfx  = nil
	Audio.sounds[10].sfx = nil
	Audio.sounds[11].sfx = nil
	Audio.sounds[12].sfx = nil
	Audio.sounds[13].sfx = nil
	Audio.sounds[14].sfx = nil
	Audio.sounds[15].sfx = nil
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	Audio.sounds[18].sfx = nil
	Audio.sounds[19].sfx = nil
	Audio.sounds[20].sfx = nil
	Audio.sounds[21].sfx = nil
	Audio.sounds[22].sfx = nil
	Audio.sounds[23].sfx = nil
	Audio.sounds[24].sfx = nil
	Audio.sounds[25].sfx = nil
	Audio.sounds[29].sfx = nil
	Audio.sounds[31].sfx = nil
	Audio.sounds[32].sfx = nil
	Audio.sounds[33].sfx = nil
	Audio.sounds[34].sfx = nil
	Audio.sounds[35].sfx = nil
	Audio.sounds[36].sfx = nil
	Audio.sounds[37].sfx = nil
	Audio.sounds[38].sfx = nil
	Audio.sounds[39].sfx = nil
	Audio.sounds[41].sfx = nil
	Audio.sounds[42].sfx = nil
	Audio.sounds[43].sfx = nil
	Audio.sounds[44].sfx = nil
	Audio.sounds[46].sfx = nil
	Audio.sounds[47].sfx = nil
	Audio.sounds[48].sfx = nil
	Audio.sounds[49].sfx = nil
	Audio.sounds[50].sfx = nil
	Audio.sounds[51].sfx = nil
	Audio.sounds[52].sfx = nil
	Audio.sounds[54].sfx = nil
	Audio.sounds[55].sfx = nil
	Audio.sounds[56].sfx = nil
	Audio.sounds[57].sfx = nil
	Audio.sounds[58].sfx = nil
	Audio.sounds[59].sfx = nil
	Audio.sounds[61].sfx = nil
	Audio.sounds[62].sfx = nil
	Audio.sounds[63].sfx = nil
	Audio.sounds[71].sfx = nil
	Audio.sounds[72].sfx = nil
	Audio.sounds[73].sfx = nil
	Audio.sounds[75].sfx = nil
	Audio.sounds[76].sfx = nil
	Audio.sounds[77].sfx = nil
	Audio.sounds[78].sfx = nil
	Audio.sounds[79].sfx = nil
	Audio.sounds[80].sfx = nil
	Audio.sounds[81].sfx = nil
	Audio.sounds[82].sfx = nil
	Audio.sounds[83].sfx = nil
	Audio.sounds[84].sfx = nil
	Audio.sounds[85].sfx = nil
	Audio.sounds[86].sfx = nil
	Audio.sounds[87].sfx = nil
	Audio.sounds[88].sfx = nil
	Audio.sounds[89].sfx = nil
	Audio.sounds[90].sfx = nil
	Audio.sounds[91].sfx = nil
	Misc.loadEpisode("Where SMB Attacks (Remake, SMAS++ Version)")
	if Misc.loadEpisode("Where SMB Attacks (Remake, SMAS++ Version)") == false then
		SFX.play("wrong.ogg")
		GameData.startedmenu = 1
		exitscreen = false
		Misc.dialog("Where SMB Attacks does not exist. You apprently have a broken copy of SMAS++. Please reinstall using the SMASUpdater.")
	end
end
local function BootWSMBAOGPreExecute()
	Audio.MusicChange(0, 0)
	exitscreen = true
	SFX.play(14)
	autoscroll.scrollLeft(5000)
	Routine.wait(0.5)
	Audio.sounds[1].sfx  = nil	
	Audio.sounds[2].sfx  = nil
	Audio.sounds[3].sfx  = nil
	Audio.sounds[4].sfx  = nil
	Audio.sounds[5].sfx  = nil
	Audio.sounds[6].sfx  = nil
	Audio.sounds[7].sfx  = nil
	Audio.sounds[8].sfx  = nil
	Audio.sounds[9].sfx  = nil
	Audio.sounds[10].sfx = nil
	Audio.sounds[11].sfx = nil
	Audio.sounds[12].sfx = nil
	Audio.sounds[13].sfx = nil
	Audio.sounds[14].sfx = nil
	Audio.sounds[15].sfx = nil
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	Audio.sounds[18].sfx = nil
	Audio.sounds[19].sfx = nil
	Audio.sounds[20].sfx = nil
	Audio.sounds[21].sfx = nil
	Audio.sounds[22].sfx = nil
	Audio.sounds[23].sfx = nil
	Audio.sounds[24].sfx = nil
	Audio.sounds[25].sfx = nil
	Audio.sounds[29].sfx = nil
	Audio.sounds[31].sfx = nil
	Audio.sounds[32].sfx = nil
	Audio.sounds[33].sfx = nil
	Audio.sounds[34].sfx = nil
	Audio.sounds[35].sfx = nil
	Audio.sounds[36].sfx = nil
	Audio.sounds[37].sfx = nil
	Audio.sounds[38].sfx = nil
	Audio.sounds[39].sfx = nil
	Audio.sounds[41].sfx = nil
	Audio.sounds[42].sfx = nil
	Audio.sounds[43].sfx = nil
	Audio.sounds[44].sfx = nil
	Audio.sounds[46].sfx = nil
	Audio.sounds[47].sfx = nil
	Audio.sounds[48].sfx = nil
	Audio.sounds[49].sfx = nil
	Audio.sounds[50].sfx = nil
	Audio.sounds[51].sfx = nil
	Audio.sounds[52].sfx = nil
	Audio.sounds[54].sfx = nil
	Audio.sounds[55].sfx = nil
	Audio.sounds[56].sfx = nil
	Audio.sounds[57].sfx = nil
	Audio.sounds[58].sfx = nil
	Audio.sounds[59].sfx = nil
	Audio.sounds[61].sfx = nil
	Audio.sounds[62].sfx = nil
	Audio.sounds[63].sfx = nil
	Audio.sounds[71].sfx = nil
	Audio.sounds[72].sfx = nil
	Audio.sounds[73].sfx = nil
	Audio.sounds[75].sfx = nil
	Audio.sounds[76].sfx = nil
	Audio.sounds[77].sfx = nil
	Audio.sounds[78].sfx = nil
	Audio.sounds[79].sfx = nil
	Audio.sounds[80].sfx = nil
	Audio.sounds[81].sfx = nil
	Audio.sounds[82].sfx = nil
	Audio.sounds[83].sfx = nil
	Audio.sounds[84].sfx = nil
	Audio.sounds[85].sfx = nil
	Audio.sounds[86].sfx = nil
	Audio.sounds[87].sfx = nil
	Audio.sounds[88].sfx = nil
	Audio.sounds[89].sfx = nil
	Audio.sounds[90].sfx = nil
	Audio.sounds[91].sfx = nil
	Misc.loadEpisode("Where SMB Attacks (Original)")
	if Misc.loadEpisode("Where SMB Attacks (Original)") == false then
		SFX.play("wrong.ogg")
		GameData.startedmenu = 1
		exitscreen = false
		Misc.dialog("Where SMB Attacks does not exist. You apprently have a broken copy of SMAS++. Please reinstall using the SMASUpdater.")
	end
end

local function WSMBAOGComing()
	littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.5>The original has NOT been found yet! We're still trying to find and perserve the original WSMBA to release with this episode. If you know someone who might have it downloaded, contact spencer.everly at gmail.com, or DM me on Discord at Spencer Everly#1997!<question OkayToMenu>", pauses = false, updatesInPause = true})
end

local function RestartSMASPlusPlus()
	Audio.MusicChange(0, 0)
	exitscreen = true
	Routine.wait(0.5)
	Misc.loadEpisode("Super Mario All-Stars++")
	if Misc.loadEpisode("Super Mario All-Stars++") == false then
		SFX.play("wrong.ogg")
		player.jumpKeyPressing = true
		player.runKeyPressing = true
		active = false
	end
end

local function BootGameHelpPreExecute()
	exitscreen = true
	autoscroll.scrollLeft(5000)
	Audio.MusicChange(0, 0)
	Routine.wait(0.4)
	Misc.saveGame()
	Level.load("SMAS - Game Help (Boot Menu).lvlx", nil, nil)
end

local function PigeonRaca1()
	if player.keys.jump == KEYS_PRESSED then
		player.keys.jump = KEYS_UNPRESSED
		Routine.wait(4.5)
		GameData.startedmenu = 0
		Level.load("SMAS - Raca's World (Part 0).lvlx", nil, nil)
	end
end

local function foolsinapril()
	autoscroll.scrollLeft(5000)
	Misc.pause()
	Routine.wait(5.5, true)
	Misc.unpause()
	GameData.startedmenu = 4
end

function bootmenu.onInitAPI()
	registerEvent(bootmenu,"onExitLevel", "onExit")
	registerEvent(bootmenu,"onStart")
	registerEvent(bootmenu,"onTick")
	registerEvent(bootmenu,"onInputUpdate")
	registerEvent(bootmenu,"onEvent")
	registerEvent(bootmenu,"onDraw")
	registerEvent(bootmenu,"onEvent")
	registerEvent(bootmenu,"onPlayerHarm")
	
	local Routine = require("routine")
	
	ready = true
end

function bootmenu.onStart()
	Audio.MusicVolume(nil)
	if SaveData.firstBootCompleted == nil then
        SaveData.firstBootCompleted = SaveData.firstBootCompleted or 0
    end
	if SaveData.firstBootCompleted == 0 then
		Routine.run(FirstBoot1)
		GameData.startedmenu = 1
	end
	if SaveData.firstBootCompleted == 1 then
		Routine.run(easterEgg, true)
	end
	if month == "12" and day == "25" then
		Section(0).getWeatherEffect(2)
	end
	if SaveData.disableX2char == 0 then
		x2noticecheck = active
		x2noticecheckactive = not active
	end
	if SaveData.disableX2char == 1 then
		x2noticecheck = not active
		x2noticecheckactive = active
	end
	Misc.saveGame()
	Defines.cheat_donthurtme = true
	Defines.cheat_shadowmario = true
	if os.date("*t").month == 04 and os.date("*t").day == 01 then
		GameData.startedmenu = 1
	end
	if Level.filename() == "intro_SMAS.lvlx" then
		if SaveData.firstBootCompleted == 0 then
			--Nothing
		end
	end
	if Level.filename() == "intro_SMAS.lvlx" then
		if SaveData.firstBootCompleted == 1 then
			Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu.ogg")
		end
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
	if Level.filename() == "intro_bossedit8.lvlx" then
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
end

function bootmenu.onPlayerHarm(eventToken, harmedPlayer)
    if stateVar == 1 then
        eventToken.cancelled = true
    end
end

function bootmenu.onTick()
	if SaveData.firstBootCompleted == nil then
        SaveData.firstBootCompleted = SaveData.firstBootCompleted or 0
    end
	if SaveData.firstBootCompleted == 0 then
		GameData.startedmenu = 1
	end
	if SaveData.firstBootCompleted == 1 then
		
	end
	if GameData.startedmenu == nil then
		GameData.startedmenu = GameData.startedmenu or 0
	end
	player:setFrame(50)
	player:mem(0x140, FIELD_BOOL, 150)
	if player:mem(0x140, FIELD_BOOL) == 0 then
		player:mem(0x140, FIELD_BOOL, 150)
	end
	player.x = camera.x + 400 - (player.width / 2)
	player.y = camera.y + 300 - (player.height / 2)
	if Player.count() == 1 then
		twoplayercheck = active
		twoplayercheckactive = not active
	end
	if Player.count() == 2 then
		player2:setFrame(50)
		player2:mem(0x142, FIELD_BOOL, true)
		twoplayercheck = not active
		twoplayercheckactive = active
		player2.x = camera.x + 432 - (player2.width / 2)
		player2.y = camera.y + 300 - (player2.height / 2)
	end
	if SaveData == nil then
		Routine.run(SaveDataError1)
	end
	if SaveData.disableX2char == nil then
        SaveData.disableX2char = SaveData.disableX2char or 0
    end
	if SaveData.disableX2char == 0 then
		x2noticecheck = active
		x2noticecheckactive = not active
	end
	if SaveData.disableX2char == 1 then
		x2noticecheck = not active
		x2noticecheckactive = active
		Player.setCostume(1, nil)
		Player.setCostume(2, nil)
		Player.setCostume(3, nil)
		Player.setCostume(4, nil)
		Player.setCostume(5, nil)
	end
	if(not killed and player:mem(0x13E,FIELD_BOOL)) then
		killed = true
		SaveData.failsafeMessageOne = SaveData.failsafeMessageOne + 1
	end
	if SaveData.failsafeMessageOne == nil then
        SaveData.failsafeMessageOne = SaveData.failsafeMessageOne or 0
    end
	if SaveData.failsafeMessageOne == 0 then
		--Nothing happens
	end
	if SaveData.failsafeMessageOne == 1 then
		Routine.run(FailsafeMessage1)
	end
	--player.upKeyPressing = false;
	--player.downKeyPressing = false;
	player.runKeyPressing = false;
	player.altJumpKeyPressing = false;
	player.altRunKeyPressing = false;
	player.dropItemKeyPressing = false;
	--player.leftKeyPressing = false;
	--player.rightKeyPressing = false;
	
	Audio.sounds[1].muted = true
	Audio.sounds[2].muted = true
	Audio.sounds[3].muted = true
	Audio.sounds[4].muted = true
	Audio.sounds[5].muted = true
	Audio.sounds[6].muted = true
	Audio.sounds[7].muted = true
	Audio.sounds[8].muted = true
	Audio.sounds[9].muted = true
	Audio.sounds[10].muted = true
	Audio.sounds[11].muted = true
	Audio.sounds[12].muted = true
	Audio.sounds[13].muted = true
	Audio.sounds[14].muted = true
	Audio.sounds[15].muted = true
	Audio.sounds[16].muted = true
	Audio.sounds[17].muted = true
	Audio.sounds[18].muted = true
	Audio.sounds[19].muted = true
	Audio.sounds[20].muted = true
	Audio.sounds[21].muted = true
	Audio.sounds[22].muted = true
	Audio.sounds[23].muted = true
	Audio.sounds[24].muted = true
	Audio.sounds[25].muted = true
	Audio.sounds[29].muted = true
	Audio.sounds[31].muted = true
	Audio.sounds[32].muted = true
	Audio.sounds[33].muted = true
	Audio.sounds[34].muted = true
	Audio.sounds[35].muted = true
	Audio.sounds[36].muted = true
	Audio.sounds[37].muted = true
	Audio.sounds[42].muted = true
	Audio.sounds[43].muted = true
	Audio.sounds[44].muted = true
	Audio.sounds[46].muted = true
	Audio.sounds[48].muted = true
	Audio.sounds[49].muted = true
	Audio.sounds[50].muted = true
	Audio.sounds[51].muted = true
	Audio.sounds[52].muted = true
	Audio.sounds[54].muted = true
	Audio.sounds[55].muted = true
	Audio.sounds[57].muted = true
	Audio.sounds[58].muted = true
	Audio.sounds[59].muted = true
	Audio.sounds[61].muted = true
	Audio.sounds[62].muted = true
	Audio.sounds[63].muted = true
	Audio.sounds[71].muted = true
	Audio.sounds[72].muted = true
	Audio.sounds[73].muted = true
	Audio.sounds[74].muted = true
	Audio.sounds[75].muted = true
	Audio.sounds[76].muted = true
	Audio.sounds[77].muted = true
	Audio.sounds[78].muted = true
	Audio.sounds[79].muted = true
	Audio.sounds[80].muted = true
	Audio.sounds[81].muted = true
	Audio.sounds[82].muted = true
	Audio.sounds[83].muted = true
	Audio.sounds[84].muted = true
	Audio.sounds[85].muted = true
	Audio.sounds[86].muted = true
	Audio.sounds[87].muted = true
	Audio.sounds[88].muted = true
	Audio.sounds[89].muted = true
	Audio.sounds[90].muted = true
	Audio.sounds[91].muted = true
	
	if runPressedState == true then
		player.runKeyPressing = false
	end
end

function bootmenu.onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function bootmenu.onInputUpdate()
	if player.rawKeys.pause == KEYS_PRESSED then
		Routine.run(ExitGame1)
	end
	if GameData.startedmenu == 0 then
		if player.keys.jump == KEYS_PRESSED then
			Routine.run(bootDialogue)
			GameData.startedmenu = GameData.startedmenu + 1
		end
	end
	if GameData.startedmenu == 1 then
		if player.keys.jump == KEYS_PRESSED then
			--Nothing
		end
	end
	if GameData.startedmenu == 2 then
		if player.keys.jump == KEYS_PRESSED then
			Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu (Crash SFX).ogg")
			Section(player.section).effects.weather = WEATHER_NONE
			x2noticecheck = false
			x2noticecheckactive = false
			x2noticecheck = false
			twoplayercheck = false
			twoplayercheckactive = false
			versionactive = false
			logo = false
			active2 = false
			active = true
			pressjumpwords = false
			sec.backgroundID = 6
			Routine.run(PigeonRaca1)
		end
	end
	if (os.date("*t").month == 04 and os.date("*t").day == 01) then
		if player.keys.jump == KEYS_PRESSED then
			player.jumpKeyPressing = false
			player.keys.jump = false
			player.rawKeys.jump = false
			GameData.startedmenu = 1
			Audio.MusicChange(0, 0)
			logo = false
			active2 = false
			active = true
			pressjumpwords = false
			aprilfools = true
			SFX.play("_OST/_Sound Effects/windows_error.ogg")
			Routine.run(foolsinapril)
		end
	end
	if GameData.startedmenu == 4 then
		player.jumpKeyPressing = true
		player.keys.jump = true
		player.rawKeys.jump = true
		if player.keys.jump == KEYS_PRESSED then
			Level.load("SMAS - Start.lvlx", nil, nil)
		end
	end
	if SaveData.racaActivated == 1 then
		GameData.startedmenu = 2
	end
end

function bootmenu.onDraw()
	local smaslogo = Graphics.loadImageResolved("SMAS - Start/background-851.png")
	local pressstart = Graphics.loadImageResolved("SMAS - Start/background-850-startonly.png")
	local bluecurtains = Graphics.loadImageResolved("theming_smbxcurtainsblue.png")
	local redcurtains = Graphics.loadImageResolved("theming_smbxcurtainsred.png")
	
	if versionactive then
		Graphics.drawBox{x=660, y=5, width=136, height=20, color=Color.black..0.5, priority=-7}
		textplus.print{x=667, y=10, text = versionnumber, priority=-6, color=Color.white, font=fontthree} --Version number of the episode
	end
	
	if pressjumpwords then
		Graphics.drawImage(pressstart, 150, 552, 1)
	end
	if logo then
		Graphics.drawImage(smaslogo, 176, 136, 2)
	end
	if exitscreen then
		Graphics.drawScreen{color = Color.black, priority = 10}
	end
	if not logo then
		--nothing
	end
	if twoplayercheck then
		textplus.print{x=295, y=10, text = "Two player mode is DISABLED", priority=-7, color=Color.yellow, font=statusFont}
	end
	if twoplayercheckactive then
		textplus.print{x=300, y=10, text = "Two player mode is ENABLED", priority=-7, color=Color.lightred, font=statusFont}
	end
	if x2noticecheck then
		textplus.print{x=303, y=20, text = "SMBX 1.3 mode is DISABLED", priority=-7, color=Color.yellow, font=statusFont}
	end
	if x2noticecheckactive then
		textplus.print{x=308, y=20, text = "SMBX 1.3 mode is ENABLED", priority=-7, color=Color.lightred, font=statusFont}
	end
	if charactercheck then
		textplus.print{x=303, y=20, text = "P1's Active Character: ", priority=-7, color=Color.yellow, font=statusFont}
	end
	if not charactercheck then
		--nothing
	end
	if not active then
		textplus.print{x=290, y=520, text = "Game by Spencer Everly, SMBX by redigit, SMBX2 by", priority=-7, color=Color.red}
		textplus.print{x=286, y=517, text = "Game by Spencer Everly, SMBX by redigit, SMBX2 by", priority=-6, color=Color.yellow}
		textplus.print{x=286, y=530, text = "Horikawa Otane, Kevsoft, Rednaxela, Hoeloe, and Enjl", priority=-7, color=Color.red}
		textplus.print{x=282, y=527, text = "Horikawa Otane, Kevsoft, Rednaxela, Hoeloe, and Enjl", priority=-6, color=Color.yellow}
	end
	if active then
		--nothing
	end
	if active2 then
		Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=8}
		textplus.print{x=724, y=580, text = "Time - ", priority=8, color=Color.white} --What time is it...!?
		textplus.print{x=755, y=580, text = os.date("%I"), priority=8, color=Color.white}
		textplus.print{x=765, y=580, text = ":", priority=8, color=Color.white}
		textplus.print{x=768, y=580, text = os.date("%M"), priority=8, color=Color.white}
		textplus.print{x=780, y=580, text = os.date("%p"), priority=8, color=Color.white}
		Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=8}
		textplus.print{x=700, y=557, text = "Date - ", priority=8, color=Color.white} --What's the day, sir?!
		textplus.print{x=733, y=557, text = os.date("%a"), priority=8, color=Color.white}
		textplus.print{x=752, y=557, text = os.date("%x"), priority=8, color=Color.white}
		textplus.print{x=10, y=10, text = "Press pause to quit.", priority=-6, color=Color.yellow}
		Graphics.drawBox{x=5, y=5, width=95, height=20, color=Color.red..0.5, priority=-7}
	end
	if active3 then
		textplus.print{x=160, y=580, text = "Hold down NOW to instantly skip to the World Map (3 seconds).", priority=3, color=Color.red, font=statusFont}
	end
	if not active3 then
		--nothing
	end
	if active4 then
		textplus.print{x=150, y=490, text = "Welcome to Totaka's Song. Congrats, you found the easter egg ;)", priority=3, color=Color.yellow, font=statusFont}
	end
	if not active4 then
		--nothing
	end
	if keyinput1 then
		textplus.print{x=300, y=400, text = "Press the key that will assign the up button.", priority=6, color=Color.lightred, font=statusFont}
	end
	if not keyinput1 then
		--nothing
	end
	if aprilfools then	
		Graphics.drawImageWP(aprilfoolserror, 0, 0, 10)
	end
end

function bootmenu.onExit()
	Audio.MusicVolume(nil)
	autoscroll.unlockSection(0, 1)
	if SaveData.firstBootCompleted == 1 then
		GameData.startedmenu = 0
	end
	if SaveData.firstBootCompleted == 0 then
		GameData.startedmenu = 1
	end
	Defines.cheat_donthurtme = false
	Defines.cheat_shadowmario = false
end

Cheats.deregister("iwannabootbackhome") --We're already home, you dolt
Cheats.deregister("letmeseetheintroagain") --You can see the intro again by starting SMAS++.
Cheats.deregister("bootgamehelp") --Wrong Game Help to boot.
Cheats.deregister("ilikespencereverly") --Like ya too, but wait until you're on an actual level ;)
Cheats.deregister("sherbertsmiddlenameistoto") --Bad luck is deactivated here. You're welcome, scaredy cats.

--The rest will disable most cheats to avoid breaking the boot level. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

Cheats.deregister("getmeouttahere")
Cheats.deregister("hadron")
Cheats.deregister("groundhog")
Cheats.deregister("wingman")
Cheats.deregister("sonicstooslow")
Cheats.deregister("gottagofast")
Cheats.deregister("ahippinandahoppin")
Cheats.deregister("jumpman")
Cheats.deregister("flamethrower")
Cheats.deregister("moneytree")
Cheats.deregister("captainn")
Cheats.deregister("passerby")
Cheats.deregister("fromthedepths")
Cheats.deregister("rinkamania")
Cheats.deregister("rinkamadness")
Cheats.deregister("iceage")
Cheats.deregister("wariotime")
Cheats.deregister("murder")
Cheats.deregister("redrum")
Cheats.deregister("wetwater")
Cheats.deregister("itsrainingmen")
Cheats.deregister("itsrainingmegan")
Cheats.deregister("andmyaxe")
Cheats.deregister("donttypethis")
Cheats.deregister("boomtheroom")
Cheats.deregister("liveforever")
Cheats.deregister("rosebud")
Cheats.deregister("fairymagic")
Cheats.deregister("launchme")
Cheats.deregister("getdown")
Cheats.deregister("geddan")
Cheats.deregister("horikawaisradicola")
Cheats.deregister("worldpeace")
Cheats.deregister("supermario2")
Cheats.deregister("supermario4")
Cheats.deregister("supermario8")
Cheats.deregister("supermario16")
Cheats.deregister("supermario32")
Cheats.deregister("supermario64")
Cheats.deregister("supermario128")
Cheats.deregister("stophittingme")
Cheats.deregister("suicide")
Cheats.deregister("dressmeup")
Cheats.deregister("undress")
Cheats.deregister("laundryday")
Cheats.deregister("wherearemycarkeys")
Cheats.deregister("boingyboing")
Cheats.deregister("bombsaway")
Cheats.deregister("firemissiles")
Cheats.deregister("powhammer")
Cheats.deregister("hammerinmypants")
Cheats.deregister("rainbowrider")
Cheats.deregister("upandout")
Cheats.deregister("burnthehousedown")
Cheats.deregister("greenegg")
Cheats.deregister("redegg")
Cheats.deregister("blueegg")
Cheats.deregister("yellowegg")
Cheats.deregister("purpleegg")
Cheats.deregister("pinkegg")
Cheats.deregister("coldegg")
Cheats.deregister("blackegg")
Cheats.deregister("needashell")
Cheats.deregister("needaredshell")
Cheats.deregister("needablueshell")
Cheats.deregister("needayellowshell")
Cheats.deregister("needaturnip")
Cheats.deregister("needa1up")
Cheats.deregister("needamoon")
Cheats.deregister("needatanookisuit")
Cheats.deregister("needahammersuit")
Cheats.deregister("needamushroom")
Cheats.deregister("needaflower")
Cheats.deregister("needaniceflower")
Cheats.deregister("needanegg")
Cheats.deregister("needaplant")
Cheats.deregister("needagun")
Cheats.deregister("needaswitch")
Cheats.deregister("needaclock")
Cheats.deregister("needabomb")
Cheats.deregister("needashoe")
Cheats.deregister("needaredshoe")
Cheats.deregister("needablueshoe")




littleDialogue.registerAnswer("MainMenu",{text = "Start Game",chosenFunction = function() Routine.run(gamebootDialogue) end})
littleDialogue.registerAnswer("MainMenu",{text = "Load Game Help",chosenFunction = function() Routine.run(BootGameHelpPreExecute) end})
littleDialogue.registerAnswer("MainMenu",{text = "Settings/Options",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("MainMenu",{text = "Exit Main Menu",chosenFunction = function() Routine.run(ExitDialogue) end})
littleDialogue.registerAnswer("MainMenu",{text = "Exit Game",chosenFunction = function() Routine.run(ExitGame1) end})



littleDialogue.registerAnswer("GameBoot",{text = "Start Super Mario All-Stars++",chosenFunction = function() Routine.run(BootSMASPlusPlusPreExecute) end})
littleDialogue.registerAnswer("GameBoot",{text = "Start Where SMB Attacks",chosenFunction = function() Routine.run(BootWSMBAPreExecute) end})
--littleDialogue.registerAnswer("GameBoot",{text = "Start Where SMB Attacks (Original)",chosenFunction = function() Routine.run(BootWSMBAOGPreExecute) end})
littleDialogue.registerAnswer("GameBoot",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("Options",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})
littleDialogue.registerAnswer("Options",{text = "Change Character",chosenFunction = function() Routine.run(ChangeChar1) end})
littleDialogue.registerAnswer("Options",{text = "2 Player Mode",chosenFunction = function() Routine.run(TwoPlayerDisEnable1) end})
littleDialogue.registerAnswer("Options",{text = "SMBX 1.3 Mode",chosenFunction = function() Routine.run(X2DisableCheck1) end})
littleDialogue.registerAnswer("Options",{text = "Boot Menu Themes",chosenFunction = function() Routine.run(themeMenu1) end})
littleDialogue.registerAnswer("Options",{text = "Input Configuration",chosenFunction = function() Routine.run(InputConfig1) end})
littleDialogue.registerAnswer("Options",{text = "Fix Broken Map Paths",chosenFunction = function() Routine.run(PathFix1) end})
littleDialogue.registerAnswer("Options",{text = "Framerate Toggling",chosenFunction = function() Routine.run(FramerateToggle1) end})
littleDialogue.registerAnswer("Options",{text = "Save Options",chosenFunction = function() Routine.run(SaveOptions1) end})
littleDialogue.registerAnswer("Options",{text = "Credits",chosenFunction = function() Routine.run(BootCredits) end})



littleDialogue.registerAnswer("IntroTheme",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Super Mario All-Stars++",chosenFunction = function() Routine.run(theme1) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Where SMB Attacks",chosenFunction = function() Routine.run(theme6) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.0.0",chosenFunction = function() Routine.run(theme2) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.1.0",chosenFunction = function() Routine.run(theme3) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.2.2",chosenFunction = function() Routine.run(theme4) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.3.0",chosenFunction = function() Routine.run(theme9) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.3.0.1",chosenFunction = function() Routine.run(theme5) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX2 Beta 3",chosenFunction = function() Routine.run(theme10) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX2 Beta 4",chosenFunction = function() Routine.run(theme7) end})
littleDialogue.registerAnswer("IntroTheme",{text = "The Edited Boss (Eighth Edition)",chosenFunction = function() Routine.run(theme8) end})
littleDialogue.registerAnswer("IntroTheme",{text = "8-Bit (By TepigFan101)",chosenFunction = function() Routine.run(theme11) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Spencer! The Show! REBOOT",chosenFunction = function() Routine.run(theme12) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Sunset Beach (By IkOshi1)",chosenFunction = function() Routine.run(theme13) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Scrolling Heights",chosenFunction = function() Routine.run(theme14) end})
littleDialogue.registerAnswer("IntroTheme",{text = "The Firey Castle (By Jake Brito)",chosenFunction = function() Routine.run(theme15) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("SavingMenuOne",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("SavingMenuOne",{text = "Move Save to a Different Slot",chosenFunction = function() Routine.run(SaveSlot1) end})
littleDialogue.registerAnswer("SavingMenuOne",{text = "Erase Save Data",chosenFunction = function() Routine.run(EraseSave1) end})




littleDialogue.registerAnswer("SaveEraseChoice",{text = "Do not Erase",chosenFunction = function() Routine.run(BootDialogueMusicReset) end})
littleDialogue.registerAnswer("SaveEraseChoice",{text = "ERASE",chosenFunction = function() Routine.run(SaveEraseStart) end})




littleDialogue.registerAnswer("SaveErasePreChoice",{text = "I understand",chosenFunction = function() Routine.run(EraseSave2) end})
littleDialogue.registerAnswer("SaveErasePreChoice",{text = "Nevermind",chosenFunction = function() Routine.run(BootDialogueMusicReset) end})




littleDialogue.registerAnswer("ReturnMenu",{text = "Exit",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("RestartOption",{text = "Restart",chosenFunction = function() Routine.run(RestartSMASPlusPlus) end})



littleDialogue.registerAnswer("FirstBootMenuOne",{text = "Begin",chosenFunction = function() Routine.run(FirstBoot3) end})




littleDialogue.registerAnswer("FirstBootMenuTwo",{text = "Yes",chosenFunction = function() Routine.run(FirstBoot4) end})
littleDialogue.registerAnswer("FirstBootMenuTwo",{text = "No",chosenFunction = function() Routine.run(TimeFixInfo1) end})




littleDialogue.registerAnswer("FirstBootMenuThree",{text = "Confirm",chosenFunction = function() Routine.run(FirstBoot5) end})




littleDialogue.registerAnswer("FirstBootMenuFour",{text = "How do I play?",chosenFunction = function() Routine.run(FirstBootGameHelp) end})
littleDialogue.registerAnswer("FirstBootMenuFour",{text = "Skip",chosenFunction = function() Routine.run(FirstBoot6) end})




littleDialogue.registerAnswer("FirstBootMenuGameHelp",{text = "Start Game Help",chosenFunction = function() Routine.run(BootGameHelpPreExecute) end})
littleDialogue.registerAnswer("FirstBootMenuGameHelp",{text = "Skip",chosenFunction = function() Routine.run(FirstBoot6) end})




littleDialogue.registerAnswer("FirstBootMenuFive",{text = "Let's get started!",chosenFunction = function() Routine.run(ExitDialogueFirstBoot) end})



littleDialogue.registerAnswer("FirstBootMenuTimeFix",{text = "Recheck",chosenFunction = function() Routine.run(FirstBoot3) end})



littleDialogue.registerAnswer("SaveSlotMove1",{text = "WIP",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("InputConfigStart",{text = "Begin",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("X2CharacterDisableOne",{text = "No",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("X2CharacterDisableOne",{text = "Yes", chosenFunction = function() Routine.run(X2Char) end})


littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "Yes (2 Player Mode)",chosenFunction = function() Routine.run(TwoPlayerCheck) end})
littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "Yes (1 Player Mode)",chosenFunction = function() Routine.run(OnePlayerCheck) end})
littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "No",chosenFunction = function() Routine.run(optionsMenu1) end})


littleDialogue.registerAnswer("ToBeAddedSoon",{text = "WIP",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("OkayToMenuTwo",{text = "Alright.",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("OkayToMenuTwoOptions",{text = "Alright.",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("OkayToMenu",{text = "Okay!",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("OkayToMenuOptions",{text = "Okay!",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("OkayToMenuTheme",{text = "Oh yeah, right.",chosenFunction = function() Routine.run(themeMenu1) end})



littleDialogue.registerAnswer("ToMenuResetTwo",{text = "Gotcha.",chosenFunction = function() Routine.run(ExitDialogueMusicReset) end})





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

return bootmenu