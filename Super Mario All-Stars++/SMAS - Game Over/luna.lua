local player2 = Player(2)

Graphics.activateHud(false)

local warpTransition = require("warpTransition")

warpTransition.levelStartTransition = warpTransition.TRANSITION_CROSSFADE
warpTransition.sameSectionTransition = warpTransition.TRANSITION_PAN
warpTransition.crossSectionTransition = warpTransition.TRANSITION_FADE
warpTransition.activateOnInstantWarps = true
warpTransition.musicFadeOut = true
warpTransition.TRANSITION_FADE = 35
warpTransition.TRANSITION_SWIRL = 96
warpTransition.TRANSITION_IRIS_OUT = 15
warpTransition.TRANSITION_PAN = 15

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