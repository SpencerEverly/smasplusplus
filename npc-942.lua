local larry = {}

local npcManager = require("npcManager")
local koopalings = require("ai_smas/koopalings")

local npcID = NPC_ID

function larry.onInitAPI()
    koopalings.register{
        npcID = npcID,
        transformShellID = 941,
        koopalingConfig = "larry",
        gfxwidth = 84,
        gfxheight = 62,
        width = 44,
        height = 50,
        effectID = 988,
    }
end

return larry