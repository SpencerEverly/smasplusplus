local warpTransition = require("warpTransition")
local commandlist = require("commandlist")
local textplus = require("textplus")
local littleDialogue = require("littleDialogue")
local pausemenu = require("pausemenu")

local debugbox = require("debugbox") --Uncomment in the final release

warpTransition.musicFadeOut = false
warpTransition.levelStartTransition = warpTransition.TRANSITION_IRIS_OUT
warpTransition.sameSectionTransition = warpTransition.TRANSITION_PAN
warpTransition.crossSectionTransition = warpTransition.TRANSITION_FADE
warpTransition.activateOnInstantWarps = false

warpTransition.TRANSITION_FADE = 1
warpTransition.TRANSITION_SWIRL = 1
warpTransition.TRANSITION_IRIS_OUT = 1
warpTransition.TRANSITION_PAN = 6

function onStart()
	return
end

function onEvent(eventName)
	if eventName == "changethemusic1" then
		Audio.MusicChange(4, 72)
	end
end