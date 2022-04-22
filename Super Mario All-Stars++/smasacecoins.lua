local smasacecoins = {}

local playerManager = require("playermanager")

function smasacecoins.onInitAPI()
	registerEvent(smasacecoins,"onTick")
end

function smasacecoins.onTick()
	local characters = {}
	
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	local costumes
	
	if table.icontains(GameData._smb2Levels,Level.filename()) == true then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() then
		if NPC.config[274].score == 11 then
			NPC.config[274].score = 6 --Nothing plays btw, just resets
		end
	end
end

return smasacecoins