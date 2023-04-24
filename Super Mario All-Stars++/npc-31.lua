--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local smasBooleans = require("smasBooleans")
local smasKeyholeSystem = require("smasKeyholeSystem")

--Create the library table
local keyNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Custom local definitions below


--Register events
function keyNPC.onInitAPI()
	npcManager.registerEvent(npcID, keyNPC, "onTickNPC")
	--npcManager.registerEvent(npcID, keyNPC, "onTickEndNPC")
	--npcManager.registerEvent(npcID, keyNPC, "onDrawNPC")
	--registerEvent(keyNPC, "onNPCKill")
end

function keyNPC.onTickNPC(v)
	local data = v.data
	
    for _,p in ipairs(Player.get()) do
        for k,j in ipairs(BGO.get(997)) do
            if Colliders.collide(v, j) and p.holdingNPC == v then
                if not smasBooleans.keyholeActivated then
                    smasKeyholeSystem.startKeyholeAnimation(v)
                end
            end
        end
    end
end

--Gotta return the library table!
return keyNPC