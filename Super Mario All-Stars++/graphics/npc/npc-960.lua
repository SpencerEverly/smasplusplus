--[[

	See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")

local ai = require("yiYoshi/melon_ai")


local melon = {}
local npcID = NPC_ID

local projectileID = (npcID + 1)

local melonSettings = table.join({
	id = npcID,
	
	yoshimelonid = projectileID,
	yoshimelonspeedx = 6.5,
	yoshimelonsound = Misc.resolveSoundFile("yiYoshi/seedShot"),
	yoshimeloncooldown = 8,
	yoshimeloncanhold = true,
	yoshimelonshots = 10,
},ai.melonSharedSettings)

npcManager.setNpcSettings(melonSettings)
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_FROMBELOW,
		HARM_TYPE_LAVA,
		HARM_TYPE_OFFSCREEN,
		HARM_TYPE_SWORD,
	},
	{
		[HARM_TYPE_LAVA] = {id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
	}
)


ai.registerMelon(npcID)


return melon