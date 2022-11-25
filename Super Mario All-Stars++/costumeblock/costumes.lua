local costumeblock = {}

local blockmanager = require("blockmanager")
local blockutils = require("blocks/blockutils")
local playerManager = require("playerManager")
local smascharacterchanger = require("smascharacterchanger")

local oldCostume = {}
local costumes = {}
local idMap = {}

function costumeblock.onPostBlockHit(v, fromUpper, playerOrNil)
	if not idMap[v.id] then return end
	if v:mem(0x56, FIELD_WORD) ~= 0 then return end
	if playerOrNil == nil or type(playerOrNil) ~= "Player" then return end
    
	Animation.spawn(10,playerOrNil.x+playerOrNil.width*0.5-16,playerOrNil.y+playerOrNil.height*0.5);
	SFX.play(32)
    smascharacterchanger.menuActive = true
    smascharacterchanger.animationActive = true
end

function costumeblock.register(id)
    idMap[id] = true
    blockmanager.registerEvent(id, blockutils, "onTickEndBlock", "bumpDuringTimefreeze")
end

function costumeblock.onInitAPI()
    registerEvent(costumeblock, "onPostBlockHit")
end

return costumeblock