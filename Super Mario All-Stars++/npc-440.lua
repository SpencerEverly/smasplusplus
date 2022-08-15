local bigSwitch = {}

local npcManager = require("npcManager")
local palaceSwitch = require("ai_smas/palaceswitch")

local npcID = NPC_ID

local settings = {id=npcID, color="yellow", blockon=724, blockoff=725, iscustomswitch = true}

palaceSwitch.registerSwitch(settings)
return bigSwitch