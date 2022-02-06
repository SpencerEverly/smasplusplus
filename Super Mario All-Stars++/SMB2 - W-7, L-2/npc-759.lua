local npcManager = require("npcManager")
local beezos = require 'beezos'

local npc = {}

local id = NPC_ID

local settings = {
	id = id,
}

beezos.register(settings)

return npc