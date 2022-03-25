local player2 = Player(2)

local extrasounds = require("extrasounds")
local littleDialogue = require("littleDialogue")
local blackscreen = false

Graphics.activateHud(false)

littleDialogue.registerStyle("gameoverdialog",{
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
	forcedPosY = 450,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
	forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
	forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

	windowingOpeningEffectEnabled = false,

	typewriterEnabled = false,
	showTextWhileOpening = true,

	openSoundEnabled = false,
    closeSoundEnabled = false,
    scrollSoundEnabled = false,
    moveSelectionSoundEnabled = true,
    chooseAnswerSoundEnabled = false,

    continueArrowEnabled = false,
})

function onStart()
    if SaveData.GameOverCount == nil then
        SaveData.GameOverCount = SaveData.GameOverCount or 0
    end
	SaveData.GameOverCount = SaveData.GameOverCount + 1
	mem(0x00B2C5AC,FIELD_FLOAT, 3)
	SFX.play("_OST/_Sound Effects/gameover-sound.ogg")
end

function onTick()
    Audio.sounds[1].muted  = true
	Audio.sounds[2].muted  = true
	Audio.sounds[3].muted  = true
	Audio.sounds[18].muted  = true
	Audio.sounds[28].muted  = true
end

function onInputUpdate()
	player.leftKeyPressing = false
	player.rightKeyPressing = false
	player.altJumpKeyPressing = false
	player.runKeyPressing = false
	player.altRunKeyPressing = false
	player.dropItemKeyPressing = false
	player.pauseKeyPressing = false
end

function onEvent(eventName)
	if eventName == "Game Over Timing Execution 2" then
		SFX.play("_OST/_Sound Effects/gameover-announcer.ogg")
	end
	if eventName == "Game Over Timing Execution 3" then
		littleDialogue.create({text = "<setPos 400 32 0.5 -4.5><boxStyle gameoverdialog><question gameoverselect>", pauses = true, updatesInPause = true})
	end
	if eventName == "Continued1" then
		SFX.play(extrasounds.id27)
	end
	if eventName == "Continued2" then
		Level.load(SaveData.lastLevelPlayed, nil, 0)
	end
	if eventName == "Restart1" then
		SFX.play(extrasounds.id27)
	end
	if eventName == "Restart2" then
		Level.load("SMAS - Start.lvlx", nil, nil)
	end
	if eventName == "EndGame1" then
		SFX.play(extrasounds.id14)
		blackscreen = true
		Misc.saveGame()
	end
	if eventName == "EndGame2" then
		Misc.exitEngine()
	end
end

function onDraw()
	if blackscreen then
		Graphics.drawScreen{color = Color.black, priority = 10}
	end
end

littleDialogue.registerAnswer("gameoverselect",{text = "Continue",chosenFunction = function() triggerEvent("Continued1") end})
littleDialogue.registerAnswer("gameoverselect",{text = "Restart",chosenFunction = function() triggerEvent("Restart1") end})
littleDialogue.registerAnswer("gameoverselect",{text = "End Game",chosenFunction = function() triggerEvent("EndGame1") end})