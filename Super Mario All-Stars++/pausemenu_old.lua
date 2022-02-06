local textplus = require("textplus")

local active = false
local ready = false

local flag = true
local str = "Loading HUB..."

pausedPressedState = false
downPressedState = false
upPressedState = false

local mainFont = textplus.loadFont("littleDialogue/font2.ini")

local pausemenu = {}

function pausemenu.onInitAPI()
	registerEvent(pausemenu, "onKeyboardPress")
	registerEvent(pausemenu, "onDraw")
	registerEvent(pausemenu, "onLevelExit")
	registerEvent(pausemenu, "onInputUpdate")
	
	ready = true
end

function pausemenu.onStart()
	if not ready then return end
end

function pausemenu.onInputUpdate()
	if player.rawKeys.pause == KEYS_PRESSED then
		pausedPressedState = false
		downPressedState = false
		upPressedState = false
		active = not active
	end
	if active then
		if player.rawKeys.pause == KEYS_PRESSED then
			SFX.play("pausemenu.wav")
			Misc.pause()
			pausedPressedState = true
		end
	end
	if active then
		if player.rawKeys.up == KEYS_PRESSED then
			SFX.play("save_dismiss.wav")
			Misc.saveGame()
			Misc.unpause()
			upPressedState = true
			active = false
		end
	end
	if active then
		if player.rawKeys.down == KEYS_PRESSED then
			Misc.saveGame()
			Misc.exitEngine()
			Misc.unpause()
			downPressedState = true
			active = false
		end
	end
	if not active then
		pausedPressedState = true
		if player.rawKeys.pause == KEYS_PRESSED then
			pausedPressedState = true
			upPressedState = true
			downPressedState = true
			SFX.play("pausemenu-closed.wav")
			Misc.unpause()
		end
	end
end

function pausemenu.onTick()
	return
end

function pausemenu.onDraw(k)
	if active then
		Graphics.drawBox{x=178, y=117, width=445, height=366, color=Color.black..0.6, priority=10}

		textplus.print{x=192, y=155, text = "Paused. Press pause again", priority=10, font=mainFont}
		textplus.print{x=192, y=175, text = "to unpause.", priority=10, font=mainFont}
		textplus.print{x=192, y=215, text = "Press up to save and", priority=10, color=Color.green, font=mainFont}
		textplus.print{x=192, y=235, text = "continue.", priority=10, color=Color.green, font=mainFont}
		textplus.print{x=192, y=275, text = "Press down to save and", priority=10, color=Color.orange, font=mainFont}
		textplus.print{x=192, y=295, text = "quit.", priority=10, color=Color.orange, font=mainFont}
		textplus.print{x=192, y=335, text = "To switch characters, use", priority=10, color=Color.lightblue, font=mainFont}
		textplus.print{x=192, y=355, text = "the left and right", priority=10, color=Color.lightblue, font=mainFont}
		textplus.print{x=192, y=375, text = "buttons (Map only).", priority=10, color=Color.lightblue, font=mainFont}
		textplus.print{x=192, y=415, text = "For more options, unpause", priority=10, color=Color.red, font=mainFont}
		textplus.print{x=192, y=435, text = "then press F9.", priority=10, color=Color.red, font=mainFont}
	end
end

--function pausemenu.onDrawEnd(k)

return pausemenu