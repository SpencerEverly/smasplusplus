local costumeblock = {}

local blockmanager = require("blockmanager")
local blockutils = require("blocks/blockutils")
local playerManager = require("playerManager")

local oldCostume = {}
local costumes = {}
local idMap = {}

function costumeblock.onPostBlockHit(v, fromUpper, playerOrNil)
	if not idMap[v.id] then return end
	if v:mem(0x56, FIELD_WORD) ~= 0 then return end
	if playerOrNil == nil or type(playerOrNil) ~= "Player" then return end
	local character = playerOrNil.character
	if(costumes[character] == nil) then
		costumes[character] = playerManager.getCostumes(character);
	end
	--If costume is default then find which one we are using, or if we can't assume 0 (default).
	if oldCostume[character] == nil then
		local current = playerManager.getCostume(character);
		oldCostume[character] = 0
		if(current ~= nil) then
			for k,c in ipairs(costumes[character]) do
				if(c == current) then
					oldCostume[character] = k;
					break;
				end
			end
		end
	end
	local newCostume = (oldCostume[character]+1) % (#costumes[character] + 1);
	playerManager.setCostume(character,costumes[character][newCostume])
	oldCostume[character] = newCostume

	Animation.spawn(10,playerOrNil.x+playerOrNil.width*0.5-16,playerOrNil.y+playerOrNil.height*0.5);
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