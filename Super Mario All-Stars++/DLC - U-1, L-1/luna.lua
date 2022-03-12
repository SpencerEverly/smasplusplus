local level_dependencies_normal = require("level_dependencies_normal")

function onTick()
	if player.deathTimer > 175 then
		Level.load("SMAS - Map.lvlx", nil, nil)
	end
end