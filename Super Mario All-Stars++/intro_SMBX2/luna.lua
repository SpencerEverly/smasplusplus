local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")
local autoscroll = require("autoscroll")

local m = RNG.randomInt(1,56-1)

local backgroundTarget = Graphics.CaptureBuffer(800,600)

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
	local bluecurtains = Graphics.loadImageResolved("theming_smbxcurtainsblue.png")
	Graphics.drawImage(bluecurtains, 0, 0, 2)
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