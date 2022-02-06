local npcManager = require("npcManager")

local MovingCloud = {}
local npcID = NPC_ID

local MovingCloudSettings = {
	id = npcID,
	gfxheight = 32,
	gfxwidth = 96,
	width = 96,
	height = 32,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 1,
	framestyle = 1,
	framespeed = 8,
	speed = 1,
	npcblock = false,
	npcblocktop = true,
	playerblock = false,
	playerblocktop = true,
	nohurt=true,
	nogravity = true,
	noblockcollision = true,
	nofireball = false,
	noiceball = true,
	noyoshi= true,
	nowaterphysics = true,
	jumphurt = false,
	spinjumpsafe = false,
	harmlessgrab = true,
	harmlessthrown = true
}

npcManager.setNpcSettings(MovingCloudSettings)
npcManager.registerDefines(npcID, {NPC.UNHITTABLE})


function MovingCloud.onInitAPI()
	npcManager.registerEvent(npcID, MovingCloud, "onTickNPC")
end

function MovingCloud.onTickNPC(v)
	if Defines.levelFreeze then return end
	v.speedX = NPC.config[npcID].speed*v.direction
end

return MovingCloud