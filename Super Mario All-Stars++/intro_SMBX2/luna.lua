local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

local m = RNG.randomInt(1,56-1)

local backgroundTarget = Graphics.CaptureBuffer(800,600)

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

littleDialogue.registerAnswer("IntroTheme",{text = "Return to Previous Menu",chosenFunction = function() triggerEvent("OptionsMenu0") end})
littleDialogue.registerAnswer("IntroTheme",{text = "Super Mario All-Stars++",chosenFunction = function() Routine.run(theme1) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.0",chosenFunction = function() Routine.run(theme2) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.1",chosenFunction = function() Routine.run(theme3) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.2",chosenFunction = function() Routine.run(theme4) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.3",chosenFunction = function() Routine.run(theme5) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Where SMB Attacks",chosenFunction = function() Routine.run(theme6) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX2 Beta 4",chosenFunction = function() triggerEvent("ThemeAlreadyInUse") end})

function onStart()
	Audio.MusicChange(0, m)
	Misc.saveGame()
end

function onEvent()
	if eventName == "BootDialogueMusicReset" then
		Audio.MusicChange(0, m)
	end
	if eventName == "ExitDialogueMusicReset" then
		Audio.MusicChange(0, m)
	end
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onDraw()
	if not init then
		Section(0).backgroundID = RNG.randomInt(1,65)

		local m = RNG.randomInt(1,56-1)
		
		--Don't select "custom" music.
		if m >= 24 then
			m = m+1
		end
		Audio.MusicChange(0, m)

		init = true
	end
	backgroundTarget:captureAt(-100)
	for _,v in ipairs(Effect.get()) do
		v.timer = 0
		v.x = 0
	end
	
	if mem(0x00B2C89C, FIELD_BOOL) then --We're loading into the credits, some weird rendering stuff happens here, so let's just draw a black screen instead.
		Graphics.drawScreen{color=Color.black,priority=0}
	else
		Graphics.drawScreen{texture=backgroundTarget,priority=-99}
	end
end