local player2 = Player(2)

Graphics.activateHud(false)

function onStart()
	mem(0x00B2C5AC,FIELD_FLOAT, 3)
end

function onTick()
    Audio.sounds[1].sfx  = Audio.SfxOpen("nothing.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("nothing.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("nothing.ogg")
	Audio.sounds[18].sfx  = Audio.SfxOpen("nothing.ogg")
	Audio.sounds[28].sfx  = Audio.SfxOpen("nothing.ogg")
end

function onEvent(eventName)
	if eventName == "Game Over Timing Execution 2" then
		SFX.play("game-over-sfx.ogg")
	end
    if eventName == "Game Over Timing Execution 3" then
		Level.exit()
	end
end