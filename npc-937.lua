local larry = {}

local npcManager = require("npcManager")
local koopalings = require("ai_smas/koopalings")

local npcID = NPC_ID

function larry.onInitAPI()
    koopalings.register{
        npcID = npcID,
        transformShellID = 936,
        koopalingConfig = "morton",
        gfxwidth = 84,
        gfxheight = 70,
        width = 44,
        height = 70,
        effectID = 985,
    }
end

return larry