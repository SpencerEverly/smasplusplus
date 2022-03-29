local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
	if eventName == "Claps" then
		SFX.play("_OST/_Sound Effects/pcoins-allcollected.ogg")
	end
end