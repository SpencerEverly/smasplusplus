local level_dependencies_normal= require("level_dependencies_normal")
local Routine = require("routine")
local pausemenu = require("pausemenu")

player.setCostume(1, nil)
player:transform(1, false)
Graphics.activateHud(false)
pausemenu.pauseactivated = false

function onStart()
	Misc.saveGame()
end

function onTick()
	if SaveData.racaActvated == 1 then
		SaveData.racaActvated = SaveData.racaActvated - 1
		Misc.saveGame()
	end
end