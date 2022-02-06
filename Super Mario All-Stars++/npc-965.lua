--[[

	See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")

local ai = require("yiYoshi/melon_ai")


local projectile = {}
local npcID = NPC_ID

local projectileSettings = table.join({
	id = npcID,

	hitFunction = (function(v,npc)
		npc:toIce()
	end),

	raiseSpeed = 0.8,
},ai.projectileSharedSettings)

npcManager.setNpcSettings(projectileSettings)
npcManager.registerHarmTypes(npcID,{HARM_TYPE_OFFSCREEN},{})


ai.registerProjectile(npcID)


return projectile