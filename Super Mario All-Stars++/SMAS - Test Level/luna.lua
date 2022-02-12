local warpTransition = require("warpTransition")
local commandlist = require("commandlist")
local textplus = require("textplus")
local littleDialogue = require("littleDialogue")
local pausemenu = require("pausemenu")
--local megaluavania = require("megaluavania")
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
	if eventName == "pauseenable" then
		pausemenu.pauseactivated = true
	end
	if eventName == "pausedisable" then
		pausemenu.pauseactivated = false
	end
end