level_normals = require("level_normals")

function onEvent(eventName)
	if eventName == "Event 2" then
		SFX.play("sound/block-smash.ogg")
	end
end