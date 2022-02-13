local Routine = require("routine")
local pausemenu = require("pausemenu")
local littleDialogue = require("littleDialogue")

local SmgLifeSystem = require("SmgLifeSystem")
SmgLifeSystem.healthX = 650
SmgLifeSystem.healthY = 10

function onLoadSection0()
	SmgLifeSystem.daredevilActive = false
	SmgLifeSystem.AirMeterActive = false
end

local blacklayer = false

Graphics.activateHud(false)
pausemenu.pauseactivated = false
local invisible = true

function onDraw()
	if blacklayer then
		local blackbglayer = Graphics.drawScreen{color = Color.black, priority = 10}
	end
end

function onTick()
	if invisible == true then
		player:setFrame(50)
	end
end

function onEvent(eventName)
	if eventName == "1" then
		SFX.play("_OST/All Stars Secrets/The True Final Battle Begins (With Screaming, SFX).ogg")
	end
	if eventName == "2" then
		blacklayer = true
	end
	if eventName == "3" then
		blacklayer = false
		invisible = false
		player:teleport(-199632, -200544)
	end
	if eventName == "5" then
		SFX.play("_OST/_Sound Effects/is-the-pool-clean-evilmode.ogg")
	end
	if eventName == "6" then
		SFX.play("_OST/_Sound Effects/raca-chant.ogg")
		SFX.play("_OST/_Sound Effects/pigeon_attack.ogg")
	end
	if eventName == "7" then
		Audio.MusicChange(0, "_OST/Undertale/mus_f_part1.ogg")
	end
end