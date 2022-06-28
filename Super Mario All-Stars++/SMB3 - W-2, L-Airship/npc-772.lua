local npcManager = require("npcManager")

local LargeCannonball = {}
local npcID = NPC_ID

local LargeCannonballSettings = {
	id = npcID,
	gfxheight = 48,
	gfxwidth = 48,
	width = 48,
	height = 48,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 1,
	speed = 1,
	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,
	nohurt = false,
	nogravity = true,
	noblockcollision = true,
	nofireball = true,
	noiceball = false,
	noyoshi = false,
	nowaterphysics = true,
	jumphurt = false,
	spinjumpsafe = false,
	foreground = false
}

npcManager.setNpcSettings(LargeCannonballSettings)
npcManager.registerDefines(npcID,{NPC.HITTABLE})

npcManager.registerHarmTypes(npcID,{HARM_TYPE_JUMP}, {})

function LargeCannonball.onInitAPI()
	registerEvent(LargeCannonball,"onNPCHarm")
end

function LargeCannonball.onNPCHarm(_,v,_,_)
	if v.id == npcID then
		local LargeCannonballdeath = Animation.spawn(766,v.x,v.y)
	end
end

return LargeCannonball