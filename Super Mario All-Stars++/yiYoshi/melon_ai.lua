--[[

	See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local melon = {}


melon.melonSharedSettings = {
	gfxwidth = 32,
	gfxheight = 32,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 32,
	height = 32,
	
	frames = 1,
	framestyle = 0,
	framespeed = 8,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt = true,
	nogravity = false,
	noblockcollision = false,
	nofireball = true,
	noiceball = true,
	noyoshi = false,
	nowaterphysics = false,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

    ignorethrownnpcs = true,


    yoshitonguebehaviour = 6,

	yoshimeloncooldown = 32,
	yoshimelonspeedx = 0,
	yoshimelonspeedy = 0,
    yoshimelonshots = 9,
    yoshimeloncanhold = false,
}


melon.melonIDList = {}
melon.melonIDMap  = {}

function melon.registerMelon(npcID)
    npcManager.registerEvent(npcID,melon,"onTickNPC","onTickMelon")

    table.insert(melon.melonIDList,npcID)
    melon.melonIDMap[npcID] = true
end


function melon.onTickMelon(v)
	if Defines.levelFreeze
    or v.despawnTimer <= 0
    or v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then return end
	
	if v:mem(0x08,FIELD_BOOL) then
		if v.speedX > 0 then
			v.speedX = math.max(0,v.speedX - 0.05)
		elseif v.speedX < 0 then
			v.speedX = math.min(0,v.speedX + 0.05)
		end
	elseif v.collidesBlockBottom and not v:mem(0x136, FIELD_BOOL) then
        v.speedX = 0
    end
end



melon.projectileSharedSettings = {
	gfxwidth = 32,
	gfxheight = 32,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 32,
	height = 32,
	
	frames = 4,
	framestyle = 0,
	framespeed = 4,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt = true,
	nogravity = true,
	noblockcollision = true,
	nofireball = true,
	noiceball = true,
	noyoshi = true,
	nowaterphysics = true,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	ignorethrownnpcs = true,
	nogliding = true,


	spawnSound = 41,

	spawnTime = 2,
	chainLength = 6,

	raiseSpeed = -0.8,
}


melon.projectileIDList = {}
melon.projectileIDMap = {}

function melon.registerProjectile(npcID)
    npcManager.registerEvent(npcID,melon,"onTickEndNPC","onTickEndProjectile")

    table.insert(melon.projectileIDList,npcID)
    melon.projectileIDMap[npcID] = true
end

function melon.onTickEndProjectile(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v.despawnTimer <= 0 then
		data.initialized = false
		return
	end

	local config = NPC.config[v.id]

	if not data.initialized then
		data.initialized = true
		
		data.timer = 0

		data.chainIndex = data.chainIndex or 1

		SFX.play(config.spawnSound)
	end


	local npcs = Colliders.getColliding{a = v,b = NPC.HITTABLE,btype = Colliders.NPC}

	for _,npc in ipairs(npcs) do
		if npc:mem(0x138,FIELD_WORD) == 0 and npc:mem(0x12C,FIELD_WORD) == 0 then
			config.hitFunction(v,npc)
		end
	end

	v.speedX = 0
	v.speedY = config.raiseSpeed

	v:mem(0x12E,FIELD_BOOL,true)

	-- Spawn more
	if data.chainIndex < config.chainLength and data.timer == config.spawnTime then
		local npc = NPC.spawn(v.id,v.spawnX + v.width*0.5 + v.width*v.direction,v.spawnY + v.height*0.5,v.section,false,true)

		npc.direction = v.direction

		npc.data.chainIndex = data.chainIndex + 1
	end

	-- Animation stuff
	local frame = math.floor(data.timer / config.framespeed)

	if frame < config.frames then
		v.animationFrame = npcutils.getFrameByFramestyle(v,{frame = frame})
	else
		v:kill(HARM_TYPE_VANISH)
		v.animationFrame = -1000
	end

	data.timer = data.timer + 1
end


function melon.onNPCHarm(eventObj,v,reason,culprit)
	if melon.melonIDMap[v.id] then
		if reason == HARM_TYPE_FROMBELOW then
			v.speedY = -5
			SFX.play(2)

			eventObj.cancelled = true
		elseif reason == HARM_TYPE_SWORD then
			-- Bounce!
			if type(culprit) == "Player" then
				v.direction = culprit.direction
			else
				v.direction = RNG.irandomEntry{DIR_LEFT,DIR_RIGHT}
			end

			v.speedX = 3 * v.direction
			v.speedY = -5

			v:mem(0x08,FIELD_BOOL,true)
			v:mem(0x136,FIELD_BOOL,true)

			SFX.play(9)

			eventObj.cancelled = true
		end
	end
end


function melon.onInitAPI()
	registerEvent(melon,"onNPCHarm")
end


return melon