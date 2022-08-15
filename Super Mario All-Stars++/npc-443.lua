local bigSwitch = {}

local npcManager = require("npcManager")
local palaceSwitch = require("ai_smas/palaceswitch")

local npcID = NPC_ID

local settings = {id=npcID, color="blue", blockon=726, blockoff=727, iscustomswitch = true}

palaceSwitch.registerSwitch(settings)
return bigSwitch