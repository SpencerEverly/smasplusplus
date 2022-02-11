local level_dependencies_normal = require("level_dependencies_normal")
local killed = false

function onTick()
	if(not killed and player:mem(0x13E,FIELD_BOOL)) then
		killed = true
		mem(0x00B2C5AC,FIELD_FLOAT)
	end
	if player.deathTimer > 175 then
		Level.load("SMAS - DLC World.lvlx", nil, nil)
	end
end