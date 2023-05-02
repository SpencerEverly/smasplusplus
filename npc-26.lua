local spring = {}

local npcutils = require("npcs/npcutils")
local smasBooleans = require("smasBooleans")
local npcID = NPC_ID

function spring.onInitAPI()
    NPC.registerEvent(spring, "onTickNPC")
end

function spring.onTickNPC(v)
    if smasBooleans.compatibilityMode13Mode then
        mem(0x00B2C6E4, FIELD_WORD, 55)
    else
        mem(0x00B2C6E4, FIELD_WORD, 38)
    end
end

return spring