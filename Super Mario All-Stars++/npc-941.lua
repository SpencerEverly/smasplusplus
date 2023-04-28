local larryShell = {}

local npcManager = require("npcManager")
local koopalingShells = require("ai_smas/koopalingShells")

local npcID = NPC_ID

function larryShell.onInitAPI()
	koopalingShells.register(npcID, 942, false)
end

return larryShell