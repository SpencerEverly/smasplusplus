local versionnumber = "Demo 2" --This is the version number of this episode. It can be changed to any version we're on.
--if Misc.inEditor() then
--  Misc.showRichDialog("SMAS++ Boot Menu Level", "Hello!\n\nYou are trying to access the boot level through the editor. What are YOU doing here?\nI bet you just wanna snoop around and mess with the episode, eh?\n\nOh well, I don't blame you. Everything is open, so go right ahead!", true)
--end

local player2_alt = Player(2)

runPressedState = false

local active = false
local active2 = true
local active3 = false
local charactercheck = false
local keyinput1 = false
local killed = false
local active4 = false

local cooldown = 35555

Graphics.activateHud(false)

local Routine = require("routine")

local warpTransition = require("warpTransition")

warpTransition.levelStartTransition = warpTransition.TRANSITION_IRIS_OUT
warpTransition.sameSectionTransition = warpTransition.TRANSITION_PAN
warpTransition.crossSectionTransition = warpTransition.TRANSITION_FADE
warpTransition.activateOnInstantWarps = true
warpTransition.musicFadeOut = true
warpTransition.TRANSITION_FADE = 1
warpTransition.TRANSITION_SWIRL = 1
warpTransition.TRANSITION_IRIS_OUT = 1
warpTransition.TRANSITION_PAN = 6

local middle = 0

local malcwarpintro = require("malcwarp_intro")
local commandlist = require("commandlist")
local textplus = require("textplus")
local littleDialogue = require("littleDialogue")

local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

local hour = os.date("%H")

local day = os.date("%d")

local month = os.date("%m")

local exacttime = os.date("%X")




littleDialogue.registerAnswer("MainMenu",{text = "Start Super Mario All-Stars++",chosenFunction = function() triggerEvent("BootSMASPlusPlusPreExecute") end})
littleDialogue.registerAnswer("MainMenu",{text = "Start Where SMB Attacks",chosenFunction = function() triggerEvent("BootWSMBAPreExecute") end})
littleDialogue.registerAnswer("MainMenu",{text = "Load Game Help",chosenFunction = function() triggerEvent("BootGameHelpPreExecute") end})
littleDialogue.registerAnswer("MainMenu",{text = "Settings/Options",chosenFunction = function() triggerEvent("OptionsMenu1") end})
littleDialogue.registerAnswer("MainMenu",{text = "Exit Main Menu",chosenFunction = function() triggerEvent("ExitDialogue") end})
littleDialogue.registerAnswer("MainMenu",{text = "Exit Game",chosenFunction = function() triggerEvent("ExitGame1") end})




littleDialogue.registerAnswer("Options",{text = "Return to Previous Menu",chosenFunction = function() triggerEvent("BootDialogue") end})
littleDialogue.registerAnswer("Options",{text = "Change Character",chosenFunction = function() triggerEvent("ChangeChar1") end})
littleDialogue.registerAnswer("Options",{text = "2 Player Mode",chosenFunction = function() triggerEvent("2PlayerDisEnable1") end})
littleDialogue.registerAnswer("Options",{text = "SMBX 1.3 Mode",chosenFunction = function() triggerEvent("X2DisableCheck1") end})
littleDialogue.registerAnswer("Options",{text = "Input Configuration",chosenFunction = function() triggerEvent("InputConfig1") end})
littleDialogue.registerAnswer("Options",{text = "Fix Broken Map Paths",chosenFunction = function() triggerEvent("PathFix1") end})
littleDialogue.registerAnswer("Options",{text = "Framerate Toggling",chosenFunction = function() triggerEvent("FramerateToggle1") end})
littleDialogue.registerAnswer("Options",{text = "Save Options",chosenFunction = function() triggerEvent("SaveOptions1") end})
littleDialogue.registerAnswer("Options",{text = "Credits",chosenFunction = function() triggerEvent("Credits1") end})




littleDialogue.registerAnswer("SavingMenuOne",{text = "Return to Previous Menu",chosenFunction = function() triggerEvent("OptionsMenu0") end})
littleDialogue.registerAnswer("SavingMenuOne",{text = "Move Save to a Different Slot",chosenFunction = function() triggerEvent("SaveSlot1") end})
littleDialogue.registerAnswer("SavingMenuOne",{text = "Erase Save Data",chosenFunction = function() triggerEvent("EraseSave1") end})




littleDialogue.registerAnswer("SaveEraseChoice",{text = "Don't Erase",chosenFunction = function() triggerEvent("BootDialogueMusicReset") end})
littleDialogue.registerAnswer("SaveEraseChoice",{text = "ERASE",chosenFunction = function() triggerEvent("SaveEraseStart") end})




littleDialogue.registerAnswer("SaveErasePreChoice",{text = "I understand",chosenFunction = function() triggerEvent("EraseSave2") end})
littleDialogue.registerAnswer("SaveErasePreChoice",{text = "Nevermind",chosenFunction = function() triggerEvent("BootDialogueMusicReset") end})




littleDialogue.registerAnswer("ReturnMenu",{text = "Exit",chosenFunction = function() triggerEvent("BootDialogue") end})



littleDialogue.registerAnswer("RestartOption",{text = "Restart",chosenFunction = function() triggerEvent("RestartSMASPlusPlusPreExecute") end})



littleDialogue.registerAnswer("FirstBootMenuOne",{text = "Begin",chosenFunction = function() triggerEvent("FirstBoot3") end})




littleDialogue.registerAnswer("FirstBootMenuTwo",{text = "Yes",chosenFunction = function() triggerEvent("FirstBoot4") end})
littleDialogue.registerAnswer("FirstBootMenuTwo",{text = "No",chosenFunction = function() triggerEvent("TimeFixInfo1") end})




littleDialogue.registerAnswer("FirstBootMenuThree",{text = "Confirm",chosenFunction = function() triggerEvent("FirstBoot5") end})




littleDialogue.registerAnswer("FirstBootMenuFour",{text = "How do I play?",chosenFunction = function() triggerEvent("FirstBootGameHelp") end})
littleDialogue.registerAnswer("FirstBootMenuFour",{text = "Skip",chosenFunction = function() triggerEvent("FirstBoot6") end})




littleDialogue.registerAnswer("FirstBootMenuGameHelp",{text = "Start Game Help",chosenFunction = function() triggerEvent("BootGameHelpPreExecute") end})
littleDialogue.registerAnswer("FirstBootMenuGameHelp",{text = "Skip",chosenFunction = function() triggerEvent("FirstBoot6") end})




littleDialogue.registerAnswer("FirstBootMenuFive",{text = "Let's get started!",chosenFunction = function() triggerEvent("ExitDialogue") end})



littleDialogue.registerAnswer("FirstBootMenuTimeFix",{text = "Recheck",chosenFunction = function() triggerEvent("FirstBoot3") end})



littleDialogue.registerAnswer("SaveSlotMove1",{text = "WIP",chosenFunction = function() triggerEvent("BootDialogue") end})



littleDialogue.registerAnswer("InputConfigStart",{text = "Begin",chosenFunction = function() triggerEvent("BootDialogue") end})



littleDialogue.registerAnswer("X2CharacterDisableOne",{text = "No",chosenFunction = function() triggerEvent("OptionsMenu1") end})
littleDialogue.registerAnswer("X2CharacterDisableOne",{text = "Yes",chosenFunction = function() triggerEvent("DisableX2Check") end})


littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "Yes",chosenFunction = function() triggerEvent("2PlayerCheck") end})
littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "No",chosenFunction = function() triggerEvent("OptionsMenu1") end})


littleDialogue.registerAnswer("ToBeAddedSoon",{text = "WIP",chosenFunction = function() triggerEvent("BootDialogue") end})



littleDialogue.registerAnswer("OkayToMenuTwo",{text = "Alright.",chosenFunction = function() triggerEvent("BootDialogue") end})



littleDialogue.registerAnswer("OkayToMenuTwoOptions",{text = "Alright.",chosenFunction = function() triggerEvent("OptionsMenu1") end})



littleDialogue.registerAnswer("OkayToMenu",{text = "Okay!",chosenFunction = function() triggerEvent("BootDialogue") end})



littleDialogue.registerAnswer("OkayToMenuOptions",{text = "Okay!",chosenFunction = function() triggerEvent("OptionsMenu1") end})



littleDialogue.registerAnswer("ToMenuResetTwo",{text = "Gotcha.",chosenFunction = function() triggerEvent("ExitDialogueMusicReset") end})


littleDialogue.registerAnswer("CharacterList",{text = "Return to Previous Menu",chosenFunction = function() triggerEvent("BootDialogue") end})
littleDialogue.registerAnswer("CharacterList",{text = "Mario (Slot 1)",chosenFunction = function() player:transform(1, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterList",{text = "Luigi (Slot 2)",chosenFunction = function() player:transform(2, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterList",{text = "Peach (Slot 3)",chosenFunction = function() player:transform(3, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterList",{text = "Toad (Slot 4)",chosenFunction = function() player:transform(4, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterList",{text = "Link (Slot 5)",chosenFunction = function() player:transform(5, true) triggerEvent("ChangedCharacter") end})


littleDialogue.registerAnswer("CharacterListX2",{text = "Return to Previous Menu",chosenFunction = function() triggerEvent("BootDialogue") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Mario (Slot 1)",chosenFunction = function() player:transform(1, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Luigi (Slot 2)",chosenFunction = function() player:transform(2, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Peach (Slot 3)",chosenFunction = function() player:transform(3, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Toad (Slot 4)",chosenFunction = function() player:transform(4, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Link (Slot 5)",chosenFunction = function() player:transform(5, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Mega Man (Slot 6)",chosenFunction = function() player:transform(6, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Wario (Slot 7)",chosenFunction = function() player:transform(7, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Bowser (Slot 8)",chosenFunction = function() player:transform(8, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Yoshi (Slot 9)",chosenFunction = function() player:transform(9, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Ninja Bomberman (Slot 10)",chosenFunction = function() player:transform(10, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Rosalina (Slot 11)",chosenFunction = function() player:transform(11, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Snake (Slot 12)",chosenFunction = function() player:transform(12, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Zelda (Slot 13)",chosenFunction = function() player:transform(13, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Minecraft Steve (Slot 14)",chosenFunction = function() player:transform(14, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Uncle Broadsword (Slot 15)",chosenFunction = function() player:transform(15, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Samus (Slot 16)",chosenFunction = function() player:transform(16, true) triggerEvent("ChangedCharacter") end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Return to Previous Menu",chosenFunction = function() triggerEvent("BootDialogue") end})


local function introExit()
	Routine.waitFrames(38)
	Level.load("SMAS - Intro.lvlx", nil, nil)
end

local function mapExit()
	Routine.waitFrames(38)
	Level.exit()
end

local function easterEgg() --SnooPINGAS I see? ._.
	Routine.wait(1800)
	Audio.MusicChange(0, 0)
	Routine.wait(596)
	Audio.MusicChange(0, "_OST/All Stars Secrets/ZZZ_Easter Egg.ogg")
	Audio.MusicChange(1, "_OST/All Stars Secrets/ZZZ_Easter Egg.ogg")
	Routine.wait(4.2)
	active4 = true
end

function onInitAPI()
	registerEvent("onExitLevel", "onExit");
	registerEvent("onKeyboardPress");
	registerEvent("onTick");
end

function onStart()
	Audio.MusicVolume(nil)
	if SaveData.firstBootCompleted == nil then
        SaveData.firstBootCompleted = SaveData.firstBootCompleted or 0
    end
	if SaveData.firstBootCompleted == 0 then
		triggerEvent("FirstBoot1")
	end
	if SaveData.firstBootCompleted == 1 then
		Routine.run(easterEgg, whilePaused)
	end
	if month == "12" and day == "25" then
		Section(0).getWeatherEffect(2)
	end
	if SaveData.disableX2char == 0 then
		x2noticecheck = active
	end
	if SaveData.disableX2char == 1 then
		x2noticecheck = not active
	end
	Misc.saveGame()
end

function onTick()
	if SaveData == nil then
		triggerEvent("SaveDataError1")
	end
	if Player.count() == 1 then
		twoplayercheck = active
	end
	if Player.count() == 2 then
		twoplayercheck = not active
	end
	if SaveData.disableX2char == nil then
        SaveData.disableX2char = SaveData.disableX2char or 0
    end
	if SaveData.disableX2char == 0 then
		x2noticecheck = active
	end
	if SaveData.disableX2char == 1 then
		x2noticecheck = not active
		Player.setCostume(1, nil)
		Player.setCostume(2, nil)
		Player.setCostume(3, nil)
		Player.setCostume(4, nil)
		Player.setCostume(5, nil)
	end
	if(not killed and player:mem(0x13E,FIELD_BOOL)) then
		killed = true
		SaveData.failsafeMessageOne = SaveData.failsafeMessageOne + 1
		Level.load()
	end
	if SaveData.failsafeMessageOne == nil then
        SaveData.failsafeMessageOne = SaveData.failsafeMessageOne or 0
    end
	if SaveData.failsafeMessageOne == 0 then
		--Nothing happens
	end
	if SaveData.failsafeMessageOne == 1 then
		triggerEvent("FailsafeMessage1")
	end
	--player.upKeyPressing = false;
	--player.downKeyPressing = false;
	player.altJumpKeyPressing = false;
	player.altRunKeyPressing = false;
	player.dropItemKeyPressing = false;
	--player.leftKeyPressing = false;
	--player.rightKeyPressing = false;
	
	if runPressedState == true then
		player.runKeyPressing = false
	end
	Audio.sounds[1].sfx  = Audio.SfxOpen("SMAS - Start/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("SMAS - Start/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("SMAS - Start/block-hit.ogg")
	Audio.sounds[18].sfx  = Audio.SfxOpen("SMAS - Start/fireball.ogg")
	Audio.sounds[28].sfx  = Audio.SfxOpen("SMAS - Start/level-select.ogg")
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onInputUpdate()
	if player.rawKeys.pause == KEYS_PRESSED then
		Misc.exitEngine()
	end
	--Where SMB Attacks old run code. The Boot Menu replaces this feature.
	--if player.keys.jump == KEYS_PRESSED then
		--triggerEvent("BootDialogue")
		--player.jumpKeyPressing = false;
	--end
	--if player.rawKeys.run == KEYS_PRESSED then
	--	active = true
	--	if active then
	--		runPressedState = true
	--		player.jumpKeyPressing = false
	--		player.runKeyPressing = false
	--		triggerEvent("WSMBABootActivated")
			--SFX.play("boot_wsmba.wav")
	--	end
	--	if not active then
	--		runPressedState = false
	--	end
--	end
end

function onEvent(eventName)
	if eventName == "SaveDataError2" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.0>It looks like SavaData couldn't be read or corrupted.<page>If that is happening, you probably loaded this episode on the broken X2 launcher found in the actual SMBX2 program.<page>Unfortunately, this means that SaveData could be corrupted.<page>Next time, please launch the game using the X2 launch menu found on SMBX2.exe, or use the SMASLauncher.<page>Please close this dialogue box by pressing jump, then press pause to exit the game.", speakerName = "Whoops!", pauses = false, updatesInPause = true})
	end
	if eventName == "FirstBoot1" then
		active = true
		Audio.MusicChange(0, 0)
		Audio.MusicChange(1, 0)
	end
	if eventName == "FirstBoot2" then
		Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu (First Time Boot Menu).ogg")
		Audio.MusicChange(1, "_OST/All Stars Menu/Boot Menu (First Time Boot Menu).ogg")
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.3>Welcome to Super Mario All-Stars Plus Plus.<page>This game combines Super Mario Bros. 1-3, The Lost Levels, World,<page>And also includes a new game, along with extra content.<page>Before we get started, this game needs to set up some prerequisite options.<question FirstBootMenuOne>", speakerName = "Welcome!", pauses = false, updatesInPause = true})
	end
	if eventName == "FirstBoot3" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.0>Check the date and time below (It should be on the bottom-right corner). Is that time, and the system date correct?<question FirstBootMenuTwo>", pauses = false, updatesInPause = true})
	end
	if eventName == "FirstBoot4" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -3.2>What is your name? (WIP)<question FirstBootMenuThree>", pauses = false, updatesInPause = true})
	end
	if eventName == "FirstBoot5" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.8>Looks like you're good! Before you begin, do you know how to play the game?<page>If you already know how to play, you can select Skip.<question FirstBootMenuFour>", pauses = false, updatesInPause = true})
	end
	if eventName == "FirstBoot6" then
		Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu (First Boot).ogg")
		Audio.MusicChange(1, "_OST/All Stars Menu/Boot Menu (First Boot).ogg")
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.2>Without further ado, Super Mario All-Stars++!<question FirstBootMenuFive>", pauses = false, updatesInPause = true})
		SaveData.firstBootCompleted = SaveData.firstBootCompleted or 1
		if SaveData.firstBootCompleted == 0 then
			SaveData.firstBootCompleted = SaveData.firstBootCompleted + 1
		end
		Misc.saveGame()
	end
	if eventName == "FirstBootGameHelp" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.7>To get help in playing the game, you'll need to redirect to the Game Help level. Would you like to enter the level, or skip? You can load Game Help again on the title screen later if you want to.<question FirstBootMenuGameHelp>", pauses = false, updatesInPause = true})
		if SaveData.firstBootCompleted == 0 then
			SaveData.firstBootCompleted = SaveData.firstBootCompleted + 1
		end
		Misc.saveGame()
	end
	if eventName == "FirstBootGHReturn" then
		active = true
	end
	if eventName == "FirstBootGHReturn2" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.2>Looks like you've returned from the Game Help level. Do you want to enter the level again, or skip?<question FirstBootMenuGameHelp>", pauses = false, updatesInPause = true})
		Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu (First Time Boot Menu).ogg")
		Audio.MusicChange(1, "_OST/All Stars Menu/Boot Menu (First Time Boot Menu).ogg")
	end
	if eventName == "FirstBoot6GH" then
		Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu (First Boot).ogg")
		Audio.MusicChange(1, "_OST/All Stars Menu/Boot Menu (First Boot).ogg")
		SaveData.firstBootCompleted = SaveData.firstBootCompleted or 1
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.2>Without further ado, Super Mario All-Stars++!<question FirstBootMenuFive>", pauses = false, updatesInPause = true})
		Misc.saveGame()
	end
	if eventName == "TimeFixInfo1" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.1><setPos 400 32 0.5 -1.2>Depending on the issue, please visit sites like https://support.kaspersky.com/common/windows/3508<page>Or use Google/DuckDuckGo and search up -fixing system time-.<page>Please fix the time first, then after fixing the time should automatically update. Press -Recheck- to recheck the time again.<question FirstBootMenuTimeFix>", pauses = false, updatesInPause = true})
	end
	if eventName == "FailsafeMessage1" then
		active = true
		Audio.MusicChange(0, 0)
		Audio.MusicChange(1, 0)
		if SaveData.failsafeMessageOne == 1 then
			SaveData.failsafeMessageOne = SaveData.failsafeMessageOne - 1
		end
	end
	if eventName == "FailsafeMessage2" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.9>It looks like the menu restarted.<page>When that happened, you probably died here in the boot screen.<page>If there are any problems, don't hesitate to email spencer.everly at gmail.com or contact them on Discord at Spencer Everly#1997.<question ToMenuResetTwo>", speakerName = "Whoops!", pauses = false, updatesInPause = true})
	end
	if eventName == "BootDialogue" then
		active = true
		active4 = false
	end
	if eventName == "MenuDialogue" then
		if Player.count() == 1 then
			player:teleport(-199632, -200330)
		end
		if Player.count() == 2 then
			player:teleport(-199632, -200506)
		end
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.0><question MainMenu>", speakerName = "Main Menu", pauses = false, updatesInPause = true})
	end
	if eventName == "ExitDialoguePCheck" then
		if Player.count() == 1 then
			triggerEvent("ExitDialogue1P")
		end
		if Player.count() == 2 then
			triggerEvent("ExitDialogue2P")
		end
	end
	if eventName == "OptionsMenu1" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.8><question Options>", speakerName = "Options", pauses = false, updatesInPause = true})
	end
	if eventName == "Credits1" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.9>For information on everything that made this episode possible, it wouldn't have been possible without more than 100 people and counting.<page>To see the credits of this episode, go into the worlds folder, the SMAS folder, and redirect to the CREDITS.txt file in the folder.<question ReturnMenu>", speakerName = "Credits", pauses = false, updatesInPause = true})
	end
	if eventName == "InputConfig1" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.7>To begin configuring the inputs of the game, please select Begin to get started.<question ToBeAddedSoon>", pauses = false, updatesInPause = true})
	end
	if eventName == "X2DisableCheck1" then
		if Player.count() == 1 then
			littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.7>Would you like to enable/disable SMBX 1.3 mode? If enabled, certain features will be disabled and some compatibility for 2 player mode will be restored. (Costumes will reset, so be careful!)<question X2CharacterDisableOne>", pauses = false, updatesInPause = true})
		end
		if Player.count() == 2 then
			littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.3>You can't use 2 player mode on X2 mode. Please enable SMBX 1.3 mode first before proceeding.<question OkayToMenuTwoOptions>", pauses = false, updatesInPause = true})
		end
	end
	if eventName == "DisableX2Check" then
		if SaveData.disableX2char == 0 then
			triggerEvent("DisableX2")
			SFX.play("1.3-mode-enabled.wav")
		end
		if SaveData.disableX2char == 1 then
			triggerEvent("EnableX2")
			SFX.play("x2-mode-enabled.wav")
		end
	end
	if eventName == "EnableX2" then
		SaveData.disableX2char = SaveData.disableX2char - 1
		triggerEvent("DisableX2Check2")
	end
	if eventName == "DisableX2" then
		SaveData.disableX2char = SaveData.disableX2char + 1
		triggerEvent("DisableX2Check2")
	end
	if eventName == "DisableX2Check2" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.3>Game settings have been applied.<question OkayToMenu>", pauses = false, updatesInPause = true})
	end
	if eventName == "2PlayerDisEnable1" then
		if SaveData.disableX2char == 1 then
			littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.8>Since you have X2 characters disabled, you can use 2 player mode!<page>Would you like to enable/disable 2 player mode?<question TwoPlayerDisableOne>", pauses = false, updatesInPause = true})
		end
		if SaveData.disableX2char == 0 then
			littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.0>Unfortunately, you'll need to disable X2 characters to toggle this on and off.<page>This is due to stability and game breaking reasons.<question OkayToMenuTwoOptions>", pauses = false, updatesInPause = true})
		end
	end
	if eventName == "FramerateToggle1" then
		Cheats.trigger("framerate")
		Defines.player_hasCheated = false
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.4>Framerate has been toggled either on or off. You can see it on the top-left corner of the screen.<question OkayToMenu>", pauses = false, updatesInPause = true})
	end
	if eventName == "2PlayerCheck" then
		if Player.count() == 1 then
			triggerEvent("Enable2Player")
		end
		if Player.count() == 2 then
			triggerEvent("Disable2Player")
		end
	end
	if eventName == "Enable2Player" then
		Cheats.trigger("2player")
		Defines.player_hasCheated = false
		player:teleport(-199632, -200484, bottomCenterAligned)
		triggerEvent("2PlayerDisEnable2")
	end
	if eventName == "Disable2Player" then
		Cheats.trigger("1player")
		Defines.player_hasCheated = false
		player:teleport(-199632, -200307, bottomCenterAligned)
		triggerEvent("2PlayerDisEnable2")
	end
	if eventName == "2PlayerDisEnable2" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.6>2 Player settings have been applied.<question OkayToMenu>", pauses = false, updatesInPause = true})
	end
	if eventName == "PathFix1" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.6>Would you like to fix the world map paths? Only do this if future updates break the map.<question ToBeAddedSoon>", pauses = false, updatesInPause = true})
	end
	if eventName == "ChangeChar1" then
		if SaveData.disableX2char == 0 then
			littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.7>Who shall you change into? (X2 Characters Enabled)<question CharacterListX2>", pauses = false, updatesInPause = true})
		end
		if SaveData.disableX2char == 1 then
			littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.9>Who shall you change into? (X2 Characters Disabled)<question CharacterList>", pauses = false, updatesInPause = true})
		end
	end
	if eventName == "ChangedCharacter" then
		SFX.play("charcost-selected.wav")
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -2.65>Character changing succeeded.<question OkayToMenuOptions>", pauses = false, updatesInPause = true})
	end
	if eventName == "SaveOptions1" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.7><question SavingMenuOne>", speakerName = "Saving Options", pauses = false, updatesInPause = true})
	end
	if eventName == "SaveSlot1" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.9>Select slot by typing the number above. Press jump when you have picked the right slot (Max is 32,767) DATA FROM THE PREVIOUS SLOT, IF ANY, WILL BE OVERWRITTEN! Don't put a number in to cancel this option.<question ToBeAddedSoon>", pauses = false, updatesInPause = true})
	end
	if eventName == "SaveEraseComplete" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -3.1>Erasing complete.<question RestartOption>", pauses = false, updatesInPause = true})
	end
	if eventName == "EraseSave1" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.4>Once you erase your save, you CAN NOT go back unless you use tools like Recuva.<page>Erasing your save is for if you want to start over from the beginning.<question SaveErasePreChoice>", pauses = false, updatesInPause = true})
	end
	if eventName == "EraseSave2" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.8>ARE YOU SURE YOU WANT TO ERASE YOUR SAVE DATA?<question SaveEraseChoice>", pauses = false, updatesInPause = true})
	end
	if eventName == "BootDialogueMusicReset" then
		active = true
		Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu.ogg")
	end
	if eventName == "ExitDialogue" then
		active = false
	end
	if eventName == "ExitDialogueMusicReset" then
		active = false
		Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu.ogg")
		Audio.MusicChange(1, "_OST/All Stars Menu/Boot Menu.ogg")
	end
	if eventName == "ExitGame1" then
		Misc.saveGame()
	end
	if eventName == "ExitGame2" then
		Misc.exitEngine()
	end
	if eventName == "SaveEraseStart" then
		SaveData.clear()
		GameData.clear()
		SaveData.flush()
		--os.remove(Misc.resolveFile("save"..Misc.saveSlot()..".sav"))
		--os.remove(Misc.resolveFile("save"..Misc.saveSlot().."-ext.dat"))
	end
	if eventName == "ExitToIntro" then
		Level.load("SMAS - Intro.lvlx", nil, nil)
	end
	if eventName == "ExitToMap" then
		Level.exit()
	end
	if eventName == "BootSMASPlusPlusPreExecute" then
		SFX.play("boot_wsmba.wav")
		active3 = true
	end
	if eventName == "BootSMASPlusPlus2" then
		active3 = false
	end
	if eventName == "BootSMASPlusPlus3" then
		if (player.keys.down == KEYS_DOWN) == true then
			Routine.run(mapExit)
		end
		if (player.keys.down == KEYS_DOWN) == false then 
			Routine.run(introExit)
		end
	end
	if eventName == "BootWSMBA" then
		Misc.loadEpisode("Where SMB Attacks (SMAS++)")
		if Misc.loadEpisode("Where SMB Attacks (SMAS++)") == false then
			--SFX.play("wrong.ogg")
			triggerEvent("WSMBANotFound")
			player.jumpKeyPressing = true
			player.runKeyPressing = true
			active = false
		end
	end
	if eventName == "WSMBAOGComing" then
		littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -0.5>The original has NOT been found yet! We're still trying to find and perserve the original WSMBA to release with this episode. If you know someone who might have it downloaded, contact spencer.everly at gmail.com, or DM me on Discord at Spencer Everly#1997!<question OkayToMenu>", pauses = false, updatesInPause = true})
	end
	if eventName == "BootWSMBAOG" then
		triggerEvent("WSMBAOGComing")
		--Misc.loadEpisode("Where SMB Attacks")
		--if Misc.loadEpisode("Where SMB Attacks") == false then
			--SFX.play("wrong.ogg")
		--	triggerEvent("WSMBANotFound")
		--	player.jumpKeyPressing = true
		--	player.runKeyPressing = true
		--	active = false
		--end
	end
	if eventName == "RestartSMASPlusPlus" then
		Misc.loadEpisode("Super Mario All-Stars++")
		if Misc.loadEpisode("Super Mario All-Stars++") == false then
			--SFX.play("wrong.ogg")
			triggerEvent("WSMBANotFound")
			player.jumpKeyPressing = true
			player.runKeyPressing = true
			active = false
		end
	end
	if eventName == "BootGameHelp" then
		Misc.saveGame()
		Level.load("SMAS - Game Help (Boot Menu).lvlx", nil, nil)
	end
end

function onDraw()
	Graphics.drawBox{x=748, y=5, width=47, height=20, color=Color.black..0.5, priority=-7}
	textplus.print{x=757, y=10, text = versionnumber, priority=-6, color=Color.white} --Version number of the episode
	
	if twoplayercheck then
		textplus.print{x=295, y=10, text = "Two player mode is DISABLED", priority=-7, color=Color.yellow, font=statusFont}
	end
	if not twoplayercheck then
		textplus.print{x=300, y=10, text = "Two player mode is ENABLED", priority=-7, color=Color.lightred, font=statusFont}
	end
	if x2noticecheck then
		textplus.print{x=303, y=20, text = "SMBX 1.3 mode is DISABLED", priority=-7, color=Color.yellow, font=statusFont}
	end
	if not x2noticecheck then
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
	if not active2 then
		return
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
end

Cheats.deregister("iwannabootbackhome") --We're already home, you dolt
Cheats.deregister("letmeseetheintroagain") --You can see the intro again by starting SMAS++.
Cheats.deregister("bootgamehelp") --Wrong Game Help to boot.
Cheats.deregister("ilikespencereverly") --Like ya too, but wait until you're on an actual level ;)

--The rest will disable most cheats to avoid breaking the boot level. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

Cheats.deregister("getmeouttahere")
Cheats.deregister("hadron")
Cheats.deregister("groundhog")
Cheats.deregister("newleaf")
Cheats.deregister("donthurtme")
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

function onExit()
	Audio.MusicVolume(nil)
end