local wendyShell = {}

local npcManager = require("npcManager")
local koopalingShells = require("ai_smas/koopalingShells")

local npcID = NPC_ID

function wendyShell.onInitAPI()
    koopalingShells.register{
        npcID = npcID,
        transformKoopaID = 939,
        canJump = true,
        koopalingConfig = "wendy",
        gfxwidth = 44,
        gfxheight = 32,
        width = 32,
        height = 28,
    }
end

return wendyShell