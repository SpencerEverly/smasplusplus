local larry = {}

local npcManager = require("npcManager")
local koopalings = require("ai_smas/koopalings")

local npcID = NPC_ID

function larry.onInitAPI()
    koopalings.register(npcID, 941)
end

return larry