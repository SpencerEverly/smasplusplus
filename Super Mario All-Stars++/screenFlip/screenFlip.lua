local screenFlip = {}

local handycam = require("handycam")

local flip = 0
local fliptimer = 0
local flipphase = 0
local flipwarningopacity = 0

function screenFlip.onTick()
	if screenFlip.enabled then
		handycam[1].rotation = flip
		handycam[2].rotation = flip
		fliptimer = fliptimer + 1
		if screenFlip.warnBeforeFlip then
			if fliptimer == (screenFlip.flipDelay - 64) then --Warm before flipping
				flipwarningopacity = 0.65
				SFX.play("screenFlip/light.wav")
			elseif fliptimer >= (screenFlip.flipDelay - 64) then
				flipwarningopacity = flipwarningopacity - 0.03
			end
		end
		if fliptimer >= screenFlip.flipDelay and screenFlip.flipDirection >= 1 then --Start flipping
			SFX.play("screenFlip/flip.wav", 1, 1, 50)
			flip = flip + screenFlip.flipSpeed
			fliptimer = screenFlip.flipDelay
		elseif fliptimer >= screenFlip.flipDelay and screenFlip.flipDirection <= -1 then
			SFX.play("screenFlip/flip.wav", 1, 1, 50)
			flip = flip - screenFlip.flipSpeed
			fliptimer = screenFlip.flipDelay
		end
		if flip > 180 and flipphase == 0 then --Stop flipping
			flip = 180
			flipphase = 1
			fliptimer = 0
		elseif flip < -180 and flipphase == 0 then
			flip = -180
			flipphase = 1
			fliptimer = 0
		end
		if flip > 360 and flipphase == 1 then --Stop flipping again
			flip = 0
			flipphase = 0
			fliptimer = 0
		elseif flip < -360 and flipphase == 1 then
			flip = 0
			flipphase = 0
			fliptimer = 0
		end
	else
		handycam[1].rotation = 0
		handycam[2].rotation = 0
		flip = 0
		fliptimer = 0
		flipphase = 0
		flipwarningopacity = 0
	end
end

function screenFlip.onInputUpdate()
    if (flip == 180 or flip == -180) then
        local oldLeft = player.keys.left

        player.keys.left = player.keys.right
        player.keys.right = oldLeft
		if Player(2) and Player(2).isValid then
			local oldLeft2 = player2.keys.left

			player2.keys.left = player2.keys.right
			player2.keys.right = oldLeft2
		end
    end
end

function screenFlip.onDraw()
	Graphics.drawScreen{color = Color.white .. flipwarningopacity, priority = 5}
end

function screenFlip.onInitAPI()
	registerEvent(screenFlip, "onTick")
	registerEvent(screenFlip, "onDraw")
	registerEvent(screenFlip, "onInputUpdate")
end

--------------------------------
----Custom settings-------------
--------------------------------
screenFlip.enabled = true --Whenever the code is enabled.
screenFlip.flipSpeed = 10 --How fast the screen rotates.
screenFlip.flipDirection = 1 --What direction the screen rotates.
screenFlip.flipDelay = 256 --How many frames it takes for the screen to rotate again.
screenFlip.warnBeforeFlip = true --Whenever the screen flashes white shortly before rotating.
--------------------------------
----Custom settings end here----
--------------------------------

return screenFlip