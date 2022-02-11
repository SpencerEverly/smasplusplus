local costumeblock = {}

local blockmanager = require("blockmanager")
local blockutils = require("blocks/blockutils")
local playerManager = require("playerManager")
local steve = require("steve")

local oldCostume = {}
local costumes = {}
local idMap = {}

function costumeblock.onPostBlockHit(v, fromUpper, playerOrNil)
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumeIdx = table.ifind(costumes,currentCostume)

	if costumeIdx ~= nil then
		player:setCostume(costumes[costumeIdx - 1])
	else
		player:setCostume(costumes[1])
	end
	SFX.play(32)
end

function costumeblock.register(id)
    idMap[id] = true
    blockmanager.registerEvent(id, blockutils, "onTickEndBlock", "bumpDuringTimefreeze")
end

function costumeblock.onInitAPI()
    registerEvent(costumeblock, "onPostBlockHit")
end

return costumeblock