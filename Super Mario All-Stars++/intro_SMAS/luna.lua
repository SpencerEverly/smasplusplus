local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

local function theme1()
	SaveData.introselect = 1
	Level.load("intro_SMAS.lvlx", nil, nil)
end

local function theme2()
	SaveData.introselect = 2
	Level.load("intro_SMBX1.0.lvlx", nil, nil)
end

local function theme3()
	SaveData.introselect = 3
	Level.load("intro_SMBX1.1.lvlx", nil, nil)
end

local function theme4()
	SaveData.introselect = 4
	Level.load("intro_SMBX1.2.lvlx", nil, nil)
end

local function theme5()
	SaveData.introselect = 5
	Level.load("intro_SMBX1.3.lvlx", nil, nil)
end

local function theme6()
	SaveData.introselect = 6
	Level.load("intro_WSMBA.lvlx", nil, nil)
end

local function theme7()
	SaveData.introselect = 7
	Level.load("intro_SMBX2.lvlx", nil, nil)
end

local function theme8()
	SaveData.introselect = 8
	Level.load("intro_bossedit8.lvlx", nil, nil)
end

littleDialogue.registerAnswer("IntroTheme",{text = "Return to Previous Menu",chosenFunction = function() triggerEvent("OptionsMenu0") end})
littleDialogue.registerAnswer("IntroTheme",{text = "Super Mario All-Stars++",chosenFunction = function() triggerEvent("ThemeAlreadyInUse") end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.0",chosenFunction = function() Routine.run(theme2) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.1",chosenFunction = function() Routine.run(theme3) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.2",chosenFunction = function() Routine.run(theme4) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.3",chosenFunction = function() Routine.run(theme5) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Where SMB Attacks",chosenFunction = function() Routine.run(theme6) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX2 Beta 4",chosenFunction = function() Routine.run(theme7) end})
littleDialogue.registerAnswer("IntroTheme",{text = "bossedit8",chosenFunction = function() Routine.run(theme8) end})

function onStart()
	Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu.ogg")
	Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end