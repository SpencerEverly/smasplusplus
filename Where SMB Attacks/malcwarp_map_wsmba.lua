local textplus = require("textplus")

local active = false
local ready = false

onePressedState = false
twoPressedState = false
threePressedState = false
fourPressedState = false
fivePressedState = false

local flag = true
local str = "Loading HUB..."

local malcwarp = {}

--malcwarp.sfxFile = Misc.resolveSoundFile("hub_travelactivated")

function malcwarp.onInitAPI()
	registerEvent(malcwarp, "onKeyboardPress")
	registerEvent(malcwarp, "onDraw")
	registerEvent(malcwarp, "onLevelExit")
	--musicChunk = Audio.SfxOpen(malcwarp.sfxFile)
	
	ready = true
end

function malcwarp.onStart()
	if not ready then return end
	
	activeText = {}
	doyouwantogo = textplus.layout(textplus.parse("<color red>Do you want to go to the HUB (Me and Larry City)?</color>"))
	pressforthis = textplus.layout(textplus.parse("<color yellow>Press Y to do so, press F8 again to not.</color>"))
	useiffailsafe = textplus.layout(textplus.parse("(Use this if you are stuck on a level, or for faster travel convenience)"))
end

function malcwarp.onKeyboardPress(k)
	if k == VK_F5 then
		player.pauseKeyPressing = false
		active = not active
	end
	if active then
		if k == VK_F5 then
		SFX.play("hub_easytravel.wav")
		onePressedState = false
		twoPressedState = false
		threePressedState = false
		end
	end
	if active then
		if k == VK_1 then
			SFX.play("hub_travelactivated.wav")
			world.playerX = 832
			world.playerY = -1152
			SFX.play("world_warp.ogg")
			onePressedState = true
			active = false
		end
	end
	if active then
		if k == VK_2 then
			SFX.play("hub_travelactivated.wav")
			world.playerX = 320
			world.playerY = -1088
			SFX.play("world_warp.ogg")
			twoPressedState = true
			active = false
		end
	end
	if not active then
		if k == VK_F5 then
			SFX.play("hub_quitmenu.wav")
			player.pauseKeyPressing = true
			onePressedState = true
			twoPressedState = true
			threePressedState = true
		end
	end
end

function malcwarp.onDraw(k)
	if active then
		player.pauseKeyPressing = false
		Graphics.drawBox{x=240, y=250, width=300, height=100, color=Color.darkgrey..0.8, priority=10}

		textplus.print{x=255, y=257, text = "WHERE SMB ATTACKS OPTIONS", priority=10}
		textplus.print{x=255, y=272, text = "Press 1 to go back to the start of the map.", priority=10, color=Color.green}
		textplus.print{x=255, y=287, text = "Press 2 to go to Mario's City.", priority=10, color=Color.green}
		textplus.print{x=255, y=302, text = "Press F5 to exit this menu.", priority=10, color=Color.lightred}
		
		textplus.print{x=255, y=332, text = "For more options, press F1 on the map/level or F5 on a level.", priority=10, color=Color.lightred}
	end
end

return malcwarp