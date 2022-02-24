local player2 = Player(2)

Graphics.activateHud(false)

function onStart()
    if SaveData.GameOverCount == nil then
        SaveData.GameOverCount = SaveData.GameOverCount or 0
    end
	SaveData.GameOverCount = SaveData.GameOverCount + 1
	mem(0x00B2C5AC,FIELD_FLOAT, 3)
end

function onTick()
    Audio.sounds[1].sfx  = Audio.SfxOpen("SMAS - Start/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("SMAS - Start/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("SMAS - Start/block-hit.ogg")
	Audio.sounds[18].sfx  = Audio.SfxOpen("SMAS - Start/fireball.ogg")
	Audio.sounds[28].sfx  = Audio.SfxOpen("SMAS - Start/level-select.ogg")
end

function onEvent(eventName)
	if eventName == "Game Over Timing Execution 2" then
		SFX.play("_OST/_Sound Effects/game-over-sfx.ogg")
	end
    if eventName == "Game Over Timing Execution 3" then
		Level.load("SMAS - Start.lvlx", nil, nil)
	end
end