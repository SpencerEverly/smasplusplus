local level_dependencies_normal= require("level_dependencies_normal")

local rooms = require("rooms")

local stars = mem(0x00B251E0, FIELD_WORD)

function onStart()
	Audio.MusicVolume(nil)
	--if stars >= 100 then
		--triggerEvent("GenosideEnding")
	--end
end

function onEvent(eventName)
	if eventName == "GenosideEnding" then
		Audio.MusicChange(0, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(1, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(2, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(3, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(4, "_OST/Undertale/mus_inmyway.ogg")
		Audio.MusicChange(5, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(6, "_OST/Undertale/mus_inmyway.ogg")
		Audio.MusicChange(7, "_OST/Undertale/mus_inmyway.ogg")
	end
end