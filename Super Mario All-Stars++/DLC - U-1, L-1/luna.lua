local level_dependencies_normal = require("level_dependencies_normal")
local killed = false

function onTick()
	if(not killed and player:mem(0x13E,FIELD_BOOL)) then
		killed = true
		mem(0x00B2C5AC,FIELD_FLOAT)
	end
end

function onEnd()
	if killed == true then
		Level.load("SMAS - DLC World.lvlx", nil, nil)
	end
end