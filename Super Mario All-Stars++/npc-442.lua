local bigSwitch = {}

local npcManager = require("npcManager")
local palaceSwitch = require("ai_smas/palaceswitch")

local npcID = NPC_ID

local settings = {id=npcID, color="red", blockon=730, blockoff=731, iscustomswitch = true}

palaceSwitch.registerSwitch(settings)
return bigSwitch