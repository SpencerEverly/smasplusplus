local npcManager = require("npcManager")

local burnerBottom = {}
local npcID = NPC_ID

local burnerBottomSettings = {
	id = npcID,
	gfxheight = 32,
	gfxwidth = 32,
	width = 32,
	height = 32,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 1,
	framestyle = 0,
	framespeed = 8,
	speed = 1,
	
	npcblock = true,
	npcblocktop = false,
	playerblock = true,
	playerblocktop = true,

	nohurt=true,
	nogravity = true,
	noblockcollision = true,
	nofireball = true,
	noiceball = true,
	noyoshi= true,
	nowaterphysics = true,
	
	jumphurt = false,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	fireID = 775,
	fireDirection = 1,
	cooldown = 95,
	burnerType = 1,
	notcointransformable = true,
}

local configFile = npcManager.setNpcSettings(burnerBottomSettings)

npcManager.registerDefines(npcID, {NPC.UNHITTABLE})

function burnerBottom.onInitAPI()
	npcManager.registerEvent(npcID, burnerBottom, "onStartNPC")
	npcManager.registerEvent(npcID, burnerBottom, "onTickNPC")
	registerEvent(burnerBottom, "onTick")
end

local DIR_ON = -1
local DIR_OFF = 1

local globalNPCs = {}
local globalTimer = 0
local globalState = 0

function burnerBottom.onTick()
	if #globalNPCs > 0 then
		if globalState == 0 then
			if globalTimer >= configFile.globalCooldown + 48 then
				globalState = 1
				globalTimer = 0
			end
		elseif globalState == 1 then
			if globalTimer >= configFile.globalCooldown + 48 then
				globalState = 0
				globalTimer = 0
			end
		end
	end
end

function burnerBottom.onStartNPC(v)
	local data = v.data
	if v.direction == DIR_OFF then
		data.state = 0
	elseif v.direction == DIR_ON then
		data.state = 1
	end
	
	if data._settings.isGlobal then
		table.insert(globalNPCs, v)
	end
	
	if v.friendly then
		data.friendly = true
		v.friendly = false
	else
		data.friendly = false
	end
end

function burnerBottom.onTickNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	data.timer = data.timer or 0
	data.state = data.state or 0 --0 is for cooldown, 1 is for releasing fire
	
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		data.initialized = false
		return
	end

	if not data.initialized then
		data.initialized = true
	end

	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--a
	else
		--b
	end
	
	--AI
	if lunatime.tick() > 0 and not data._settings.isGlobal then
		data.timer = data.timer + 1
	end
	
	if data._settings.isGlobal then
		data.state = 0
		data.timer = 0
		if globalState == 1 then
			if globalTimer == 1 then
				SFX.play(42)
				data.flame = NPC.spawn(configFile.fireID, v.x + 2, v.y + v.height, v:mem(0x146, FIELD_WORD))
				
				data.flame.direction = configFile.fireDirection
				data.flame.layerName = "Spawned NPCs"
				data.flame.friendly = data.friendly
				data.flame.data._settings.parent = v
			end
		end
	else
		if data.state == 0 then
			if data.timer >= configFile.cooldown + 48 then
				data.state = 1
				data.timer = 0
			end
		elseif data.state == 1 then
			if data.timer == 1 then
				SFX.play(42)
				data.flame = NPC.spawn(configFile.fireID, v.x + 2, v.y + v.height, v:mem(0x146, FIELD_WORD))
				
				data.flame.direction = configFile.fireDirection
				data.flame.layerName = "Spawned NPCs"
				data.flame.friendly = data.friendly
				data.flame.data._basegame.parent = v
			elseif data.timer >= configFile.cooldown + 48 then
				data.state = 0
				data.timer = 0
			end
		end
	end
	
	--make this thing movable, shall we?
	v.x = v.x + v.layerObj.speedX
	v.y = v.y + v.layerObj.speedY
end

--Gotta return the library table!
return burnerBottom