local iceblock = {}

local npcutils = require("npcs/npcutils")
local npcID = NPC_ID

function iceblock.onInitAPI()
    NPC.registerEvent(iceblock, "onTickNPC")
end

function iceblock.onTickNPC(v)
    if v.ai1 == 0 then --Fixes dumb bug with layer movement when the block is inactive
        npcutils.applyLayerMovement(v)
    end
end

return iceblock