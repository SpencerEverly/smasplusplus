local larryShell = {}

local npcManager = require("npcManager")
local koopalingShells = require("ai_smas/koopalingShells")

local npcID = NPC_ID

function larryShell.onInitAPI()
    koopalingShells.register{
        npcID = npcID,
        transformKoopaID = 937,
        canJump = true,
        koopalingConfig = "morton",
        gfxwidth = 44,
        gfxheight = 32,
        width = 32,
        height = 28,
    }
end

return larryShell