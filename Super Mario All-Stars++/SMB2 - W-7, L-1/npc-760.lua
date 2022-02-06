local npcManager = require("npcManager")
local beezos = require 'beezos'

local npc = {}

local id = NPC_ID

local settings = {
	id = id,
	canDive = false,
	effect = 758,
}
beezos.register(settings)

return npc