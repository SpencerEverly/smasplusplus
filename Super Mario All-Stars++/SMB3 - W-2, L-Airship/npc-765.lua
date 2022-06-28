local npcManager = require("npcManager")

local Cannonball = {}
local npcID = NPC_ID

local CannonballSettings = {
	id = npcID,
	gfxheight = 32,
	gfxwidth = 32,
	width = 32,
	height = 32,
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

npcManager.setNpcSettings(CannonballSettings)
npcManager.registerDefines(npcID,{NPC.HITTABLE})

npcManager.registerHarmTypes(npcID,{HARM_TYPE_JUMP}, {})

function Cannonball.onInitAPI()
	registerEvent(Cannonball,"onNPCHarm")
end

function Cannonball.onNPCHarm(_,v,_,_)
	if v.id == npcID then
		local cannonballdeath = Animation.spawn(765,v.x,v.y)
	end
end

return Cannonball