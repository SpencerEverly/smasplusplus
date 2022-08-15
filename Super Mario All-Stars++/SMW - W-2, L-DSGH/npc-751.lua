--[[

	Written by MrDoubleA
	Please give credit!

    Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")

local bigBooBoss = {}
local npcID = NPC_ID

local deathEffectID = (npcID)

local bigBooBossSettings = {
	id = npcID,
	
	gfxwidth = 144,
	gfxheight = 128,

	gfxoffsetx = 0,
	gfxoffsety = 8,
	
	width = 112,
	height = 112,
	
	frames = 11,
	framestyle = 1,
	framespeed = 8,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt = false,
	nogravity = true,
	noblockcollision = true,
	nofireball = true,
	noiceball = true,
	noyoshi = true,
	nowaterphysics = true,
	
	jumphurt = true,
	spinjumpsafe = true,
	harmlessgrab = false,
	harmlessthrown = false,

	staticdirection = true,
	foreground = true,


	-- Visual settings
	fadingMin = 0.095,
	fadingMax = 1,

	useAdditiveBlending = true,

	-- Animation settings
	hideFrames = 1,
	hideFrameSpeed = 8,

	lookFrames = 1,
	lookFrameSpeed = 8,

	turnAroundFrames = 2,
	turnAroundFrameSpeed = 8,

	flashFrames = 6,
	flashFrameSpeed = 2,

	-- Behaviour settings
	prepareDuration = 96,
	fadeInDuration = 32,
	fadeOutDuration = 32,

	hurtFlashDuration = 64,
	hurtFlyAroundDuration = 256,

	legacyBossDropID = 16,
	legacyBossMusic = 51,

	-- Sounds
	fallSound = extrasounds.sound.sfx[127],
}

npcManager.setNpcSettings(bigBooBossSettings)
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_NPC,
		HARM_TYPE_PROJECTILE_USED,
		HARM_TYPE_HELD,
		HARM_TYPE_SWORD
	},
	{
		[HARM_TYPE_JUMP]            = deathEffectID,
		[HARM_TYPE_FROMBELOW]       = deathEffectID,
		[HARM_TYPE_NPC]             = deathEffectID,
		[HARM_TYPE_PROJECTILE_USED] = deathEffectID,
		[HARM_TYPE_LAVA]            = {id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]            = deathEffectID,
		[HARM_TYPE_TAIL]            = deathEffectID,
		[HARM_TYPE_SWORD]           = deathEffectID,
	}
)


function bigBooBoss.onInitAPI()
	npcManager.registerEvent(npcID, bigBooBoss, "onTickEndNPC")
	npcManager.registerEvent(npcID, bigBooBoss, "onDrawNPC")
	registerEvent(bigBooBoss,"onNPCHarm")
end


local STATE = {
	PREPARE = 0,
	FADE_IN = 1,
	FLY_AROUND = 2,
	HURT = 3,
	HURT_FADE_OUT = 4,
	HURT_FLY_AROUND = 5,
}

local STATE_ANIM = {
	HIDE = 0,
	LOOK = 1,
	FLASH = 2,
}


local function handleFlyAround(v,data,config,settings)
	local horizontalDistance = settings.flyAroundHorizontalDistance*0.5*v.spawnDirection
	local verticalDistance = settings.flyAroundVerticalDistance*0.5
	local horizontalTime = settings.flyAroundHorizontalTime / math.pi / 2
	local verticalTime   = settings.flyAroundVerticalTime   / math.pi / 2

	v.speedX = math.sin(data.flyAroundTimer / horizontalTime)*horizontalDistance / horizontalTime
	v.speedY = math.sin(data.flyAroundTimer / verticalTime  )*verticalDistance   / verticalTime

	data.flyAroundTimer = data.flyAroundTimer + 1

	npcutils.faceNearestPlayer(v)
end


local function throwProjectiles(v,data,config,settings)
	if settings.throwProjectileCount <= 0 or settings.throwProjectileID == 0 then
		return
	end

	local id = settings.throwProjectileID
	if id < 0 then
		id = 10
	end

	local projectileConfig = NPC.config[id]
		

	for i = 0,settings.throwProjectileCount-1 do
		local npc = NPC.spawn(id,v.x + v.width*0.5,v.y + v.height*0.5,v.section,false,true)

		-- Set speed/direction
		if settings.throwProjectileCount > 1 then
			local angle = ((i / settings.throwProjectileCount-1)*2 + 1)*settings.throwProjectileAngle
			local speed = vector(0,-settings.throwProjectileSpeed):rotate(angle)

			if speed.x == 0 then
				npc.direction = v.direction
			else
				npc.direction = math.sign(speed.x)
			end

			npc.speedX = speed.x
			npc.speedY = speed.y
		else
			npc.direction = v.direction
			npc.speedX = 0
			npc.speedY = -settings.throwProjectileSpeed
		end

		npc.speedY = npc.speedY + 0.01

		if projectileConfig.iscoin then
			npc.ai1 = 1
		end
	end
end

local function spawnLegacyBossDrop(v,data,config,settings)
	if not v.legacyBoss or config.legacyBossDropID == nil or config.legacyBossDropID <= 0 then
		return
	end

	-- Is there another big boo? If so, do not spawn it
	for _,npc in NPC.iterate(v.id) do
		if npc.legacyBoss then
			return
		end
	end


	local npc = NPC.spawn(config.legacyBossDropID,v.x + v.width*0.5,v.y + v.height*0.5,v.section,true,true)

	npc.speedY = -8
	npc.y = npc.y - 0.01
end


local stateFunctions = {}

stateFunctions[STATE.PREPARE] = (function(v,data,config,settings)
	data.stateAnimation = STATE_ANIM.HIDE
	data.timer = data.timer + 1

	if data.timer >= config.prepareDuration then
		data.state = STATE.FADE_IN
		data.timer = 0

		SFX.play(41)
	end
end)

stateFunctions[STATE.FADE_IN] = (function(v,data,config,settings)
	data.timer = data.timer + 1

	data.fadeProgress = math.clamp(data.timer / config.fadeInDuration)

	if data.fadeProgress >= 1 then
		data.state = STATE.FLY_AROUND
		data.timer = 0
	end
end)

stateFunctions[STATE.FLY_AROUND] = (function(v,data,config,settings)
	data.stateAnimation = STATE_ANIM.LOOK
	handleFlyAround(v,data,config,settings)
end)

stateFunctions[STATE.HURT] = (function(v,data,config,settings)
	data.stateAnimation = STATE_ANIM.FLASH
	v.speedX = 0
	v.speedY = 0

	data.timer = data.timer + 1

	if data.timer >= config.hurtFlashDuration then
		if data.health > 0 then
			data.state = STATE.HURT_FADE_OUT
			data.timer = 0

			throwProjectiles(v,data,config,settings)

			SFX.play(41)
		else
			spawnLegacyBossDrop(v,data,config,settings)

			v:kill(HARM_TYPE_NPC)
			SFX.play(config.fallSound)
		end
	end
end)

stateFunctions[STATE.HURT_FADE_OUT] = (function(v,data,config,settings)
	data.stateAnimation = STATE_ANIM.HIDE

	data.timer = data.timer + 1
	data.fadeProgress = 1 - math.clamp(data.timer / config.fadeOutDuration)

	if data.fadeProgress <= 0 then
		data.state = STATE.HURT_FLY_AROUND
		data.timer = 0
	end
end)

stateFunctions[STATE.HURT_FLY_AROUND] = (function(v,data,config,settings)
	data.timer = data.timer + 1

	if data.timer >= config.hurtFlyAroundDuration then
		data.state = STATE.FADE_IN
		data.timer = 0

		v.speedX = 0
		v.speedY = 0

		SFX.play(41)
	else
		handleFlyAround(v,data,config,settings)
	end
end)



local function resetMainStateData(v,data,config,settings)
	data.state = STATE.PREPARE
	data.timer = 0

	data.stateAnimation = STATE_ANIM.HIDE

	data.fadeProgress = 0

	if not v.friendly then
		data.temporarilyFriendly = true
		v.friendly = true
	end
end

local function initialise(v,data,config,settings)
	data.initialized = true

	resetMainStateData(v,data,config,settings)

	data.health = settings.health

	data.flyAroundTimer = 0

	data.animationTimer = 0

	data.turnActive = false
	data.oldDirection = v.direction

	data.hasSetMusic = data.hasSetMusic or false
end



local function mainBehaviour(v,data,config,settings)
	if v:mem(0x12C, FIELD_WORD) > 0    -- Grabbed
	or v:mem(0x136, FIELD_BOOL)        -- Projectile
	or v:mem(0x138, FIELD_WORD) > 0    -- Contained within
	then
		resetMainStateData(v,data,config,settings)
		return
	end


	local func = stateFunctions[data.state]

	if func ~= nil then
		func(v,data,config,settings)
	end


	if data.fadeProgress < 1 then
		if not v.friendly then
			v.friendly = true
			data.temporarilyFriendly = true
		end
	elseif data.temporarilyFriendly then
		v.friendly = false
		data.temporarilyFriendly = false
	end
end



local function handleAnimation(v,data,config,settings)
	-- Initialise the turning direction
	if data.oldDirection ~= v.direction and v:mem(0x12C,FIELD_WORD) == 0 then
		data.turnActive = true
		data.animationTimer = 0
	end
	data.oldDirection = v.direction

	-- Find the frame/direction to use
	local direction = v.direction
	local frame = 0

	if data.turnActive then
		local turnDuration = config.turnAroundFrames * config.turnAroundFrameSpeed * 2

		frame = math.floor(data.animationTimer / config.turnAroundFrameSpeed)

		if frame >= config.turnAroundFrames then
			frame = config.turnAroundFrames - (frame - config.turnAroundFrames) - 1
		else
			direction = -direction
		end

		frame = frame + config.hideFrames + config.lookFrames

		data.turnActive = (data.animationTimer+1 < turnDuration)
	elseif data.stateAnimation == STATE_ANIM.HIDE then
		frame = math.floor(data.animationTimer / config.hideFrameSpeed) % config.hideFrames
	elseif data.stateAnimation == STATE_ANIM.LOOK then
		frame = (math.floor(data.animationTimer / config.lookFrameSpeed) % config.lookFrames) + config.hideFrames
	elseif data.stateAnimation == STATE_ANIM.FLASH then
		if data.animationTimer%config.flashFrameSpeed < config.flashFrameSpeed*0.5 then
			frame = math.floor(data.animationTimer / config.flashFrameSpeed) % config.flashFrames
		end

		frame = frame + config.hideFrames + config.lookFrames + config.turnAroundFrames
	end

	v.animationFrame = npcutils.getFrameByFramestyle(v,{frame = frame,direction = direction})

	data.animationTimer = data.animationTimer + 1
end


function bigBooBoss.onTickEndNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v.despawnTimer <= 0 then
		data.initialized = false

		if data.temporarilyFriendly then
			v.friendly = false
			data.temporarilyFriendly = false
		end

		return
	end

	local config = NPC.config[v.id]
	local settings = v.data._settings

	if not data.initialized then
		initialise(v,data,config,settings)
	end

	if v.despawnTimer >= 10 then
		if v.legacyBoss and not data.hasSetMusic and config.legacyBossMusic ~= nil then
			v.sectionObj.music = config.legacyBossMusic
		end
		
		v.despawnTimer = math.max(100,v.despawnTimer)
	end

	mainBehaviour(v,data,config,settings)

	handleAnimation(v,data,config,settings)
end


local lowPriorityStates = table.map{1,3,4}

local function getNPCPriority(v,data,config,settings)
	if v:mem(0x12C,FIELD_WORD) > 0 then
		return -30
	elseif lowPriorityStates[v:mem(0x138,FIELD_WORD)] then
		return -75
	end

	if config.foreground then
		return -15
	end

	return -45
end

function bigBooBoss.onDrawNPC(v)
	if v.despawnTimer <= 0 or v.isHidden then return end

	local config = NPC.config[v.id]
	local data = v.data
	
	local settings = v.data._settings

	if not data.initialized then
		initialise(v,data,config,settings)
	end


	local texture = Graphics.sprites.npc[v.id].img
	if texture == nil then
		return
	end

	-- Handle fading/opacity
	local opacity = math.lerp(config.fadingMin,config.fadingMax,data.fadeProgress)
	local color
	local vertexColors

	if config.useAdditiveBlending then
		-- Additive blending can be achieved by using vertexColors rather than the usual color argument,
		-- and making the alpha 0, and the rest the same as the opacity
		vertexColors = {}

		for i = 1,4 do
			-- Insert R, G and B
			for j = 1,3 do
				table.insert(vertexColors,opacity)
			end

			-- Insert A
			table.insert(vertexColors,0)
		end
	else
		color = Color.white.. opacity
	end

	-- Prepare for the actual rendering
	local priority = getNPCPriority(v,data,config)

	local x = v.x + v.width*0.5 + config.gfxoffsetx
	local y = v.y + v.height - config.gfxheight*0.5 + config.gfxoffsety

	local width = config.gfxwidth
	local height = config.gfxheight

	local sourceX = 0
	local sourceY = v.animationFrame*height

	Graphics.drawBox{
		texture = texture,priority = priority,color = color,vertexColors = vertexColors,
		sceneCoords = true,centred = true,

		x = x,y = y,width = width,height = height,
		sourceX = sourceX,sourceY = sourceY,sourceWidth = width,sourceHeight = height,
	}

	npcutils.hideNPC(v)
end


function bigBooBoss.onNPCHarm(eventObj,v,reason,culprit)
	if v.id ~= npcID or v.despawnTimer <= 0 then return end


	if reason == HARM_TYPE_OFFSCREEN or reason == HARM_TYPE_LAVA then
		return
	end


	local config = NPC.config[v.id]
	local data = v.data
	
	local settings = v.data._settings

	if not data.initialized then
		initialise(v,data,config,settings)
	end


	if data.stateAnimation == STATE_ANIM.LOOK then
		if v:mem(0x156,FIELD_WORD) == 0 then
			data.state = STATE.HURT
			data.timer = 0

			data.health = math.max(0,data.health - 1)

			v:mem(0x156,FIELD_WORD,40)
		end

		if reason == HARM_TYPE_NPC and type(culprit) == "NPC" then
			culprit:harm(HARM_TYPE_NPC)
		end

		SFX.play(39)
	end

	eventObj.cancelled = true
end


return bigBooBoss