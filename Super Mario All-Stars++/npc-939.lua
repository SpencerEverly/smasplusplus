local wendy = {}

local npcManager = require("npcManager")
local koopalings = require("ai_smas/koopalings")

local npcID = NPC_ID

function wendy.onInitAPI()
    koopalings.register{
        npcID = npcID,
        transformShellID = 938,
        koopalingConfig = "wendy",
        gfxwidth = 84,
        gfxheight = 64,
        width = 44,
        height = 52,
        effectID = 986,
    }
end

return wendy