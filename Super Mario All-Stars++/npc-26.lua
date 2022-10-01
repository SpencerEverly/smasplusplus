local spring = {}

local npcutils = require("npcs/npcutils")
local smasbooleans = require("smasbooleans")
local npcID = NPC_ID

function spring.onInitAPI()
    NPC.registerEvent(spring, "onTickNPC")
end

function spring.onTickNPC(v)
    if smasbooleans.compatibilityMode13Mode then
        mem(0x00B2C6E4, FIELD_WORD, 55)
    else
        mem(0x00B2C6E4, FIELD_WORD, 38)
    end
end

return spring