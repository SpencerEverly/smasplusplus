--------------------------------------
-- SMW Coin snake
--------------------------------------

local npcManager = require("npcManager")
local smascharacterinfo
pcall(function() smascharacterinfo = require("smascharacterinfo") end)
local clamp = math.clamp
local max = math.max
local v2 = vector.v2

local npcID = NPC_ID

local TERMINUS = require("redirector").TERMINUS
local DIR_UP = -2
local DIR_DOWN = 2

local DEF_BLOCK = 4
local coinToBlock = {
	[33] = 89,
	[258] = 89,
	[88] = 188,
	[103] = 280,
	[138] = 193,
}

local snake = {}

snake.sfxFile = SFX.open(Misc.resolveSoundFile("pswitch/pswitch_smw.ogg"))

npcManager.setNpcSettings{
	id = npcID,
	gfxheight = 32,
	gfxwidth = 32,
	width = 32,
	height = 32,
	frames = 5,
	framestyle = 0,
	speed = 2,
	nohurt = true,
	jumphurt = true,
	nogravity = true,
	noblockcollision = true,
	noyoshi = true,
	luahandlesspeed = true,
	
	coinframes = 4, -- Number of frames in the coin animation; the remaining frames go to the block animation
	coinlimit = 50, -- Maximum number of coins to spawn before dying
	coinid = 33, -- The ID of the NPC to use as a coin
}

function snake.onInitAPI()
	npcManager.registerEvent(npcID, snake, "onTickNPC")
	npcManager.registerEvent(npcID, snake, "onTickEndNPC")
	registerEvent(snake, "onStart")
	registerEvent(snake, "onTick")
	registerEvent(snake, "onPostEventDirect")
	registerEvent(snake, "onExitLevel")
end

local activeSnakes = 0
local cachedVolume
local playingSound

local function startSnake()
	if activeSnakes == 0 then
		Sound.muteMusic(-1)
		playingSound = SFX.play(snake.sfxFile, Audio.MusicVolume() / 100, 0)
	end
	activeSnakes = activeSnakes + 1
end

local function stopSnake()
	if activeSnakes == 1 then
		Sound.restoreMusic(-1)
		if playingSound ~= nil then
			playingSound:Stop()
			playingSound = nil
		end
	end
	activeSnakes = max(0, activeSnakes - 1)
end

local function init(npc)
	local data = npc.data._basegame
	local settings = npc.data._settings
	local cfg = NPC.config[npcID]
	
	if settings.coinLimit == nil or settings.coinLimit == 0 then
		data.coinsLeft = cfg.coinlimit
	else
		data.coinsLeft = clamp(settings.coinLimit, -1, 999)
	end
	
	-- if emerging downward from a block
	if npc:mem(0x138, FIELD_WORD) == 3 then
		data.direction = DIR_DOWN
	else
		data.direction = DIR_UP
	end
	
	data.controllingPlayer = Player.getNearest(npc.x + npc.width * .5, npc.y + npc.height * .5)
	
	data.collider = Colliders.Box(0, 0, cfg.width-8, cfg.height-8)
	
	data.animationFrame = 0
	data.animationTimer = 0
end

local function reachedDestination(npc, dest, dir)
	return dir == DIR_UP and npc.y <= dest.y
	    or dir == DIR_DOWN and npc.y >= dest.y
		or dir == DIR_LEFT and npc.x <= dest.x
		or dir == DIR_RIGHT and npc.x >= dest.x
end

local directionToDest = {
	[DIR_UP] = v2(0, -32),
	[DIR_DOWN] = v2(0, 32),
	[DIR_LEFT] = v2(-32, 0),
	[DIR_RIGHT] = v2(32, 0),
}
local directionToVel = {
	[DIR_UP] = v2(0, -1),
	[DIR_DOWN] = v2(0, 1),
	[DIR_LEFT] = v2(-1, 0),
	[DIR_RIGHT] = v2(1, 0),
}

local function hitTerminus(npc)
	for _,v in BGO.iterateIntersecting(npc.x + 8, npc.y + 8, npc.x + npc.width - 8, npc.y + npc.height - 8) do
		if v.id == TERMINUS and not v.isHidden then
			return true
		end
	end
end

local solidOrSemisolid
local function hitObstacle(npc)
	local data = npc.data._basegame
	
	data.collider.x = npc.x + 4
	data.collider.y = npc.y + 4
	
	for _,v in ipairs(Colliders.getColliding{a=data.collider, b=NPC.HITTABLE, btype=Colliders.NPC}) do
		if v ~= npc then
			return true
		end
	end
	
	if data.blockImmune then return end
	
	local blockIDs = data.direction == DIR_DOWN and solidOrSemisolid or Block.SOLID
	for _,v in ipairs(Colliders.getColliding{a=data.collider, b=blockIDs, btype=Colliders.BLOCK}) do
		if (Block.SOLID_MAP[v.id] or (Block.SEMISOLID_MAP[v.id] and npc.y < v.y)) and v ~= data.ignoredBlock then
			return true
		end
	end
end

local pSwitchActive = false
local pSwitchStartFlag = false

function snake.onTickNPC(npc)
	if Defines.levelFreeze then return end
	
	local data = npc.data._basegame

	if npc.despawnTimer <= 0 then
		npc:kill(HARM_TYPE_VANISH)
		stopSnake()
		return
	end
	
	if not data.coinsLeft then
		init(npc)
		startSnake()
	end
	
	-- do nothing if held or contained
	if npc:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or npc:mem(0x136, FIELD_BOOL)        --Thrown
	or npc:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		return
	end
	
	if not data.destination or reachedDestination(npc, data.destination, data.direction) then
		local cfg = NPC.config[npcID]
	
		-- lock to the destination (if there is one)
		if data.destination then
			npc.x = data.destination.x
			npc.y = data.destination.y
		end
		
		-- spawn a coin (will respawn, centered on this NPC), or a block if the P-Switch is active
		if pSwitchActive then
			local b = Block.spawn(coinToBlock[cfg.coinid] or DEF_BLOCK, npc.x + npc.width * .5, npc.y + npc.height * .5)
			b.x = b.x - b.width * .5  -- center the block
			b.y = b.y - b.height * .5
			b:mem(0x5C, FIELD_WORD, cfg.coinid) -- set the block to transform into the coin once the P-Switch has ended
			data.ignoredBlock = b
		else
			NPC.spawn(cfg.coinid, npc.x + npc.width * .5, npc.y + npc.height * .5, npc.section, true, true)
		end
		
		if data.coinsLeft > 0 then
			data.coinsLeft = data.coinsLeft - 1
		end
		if data.coinsLeft == 0 or hitTerminus(npc) then
			npc:kill(HARM_TYPE_VANISH)
			stopSnake()
			return
		end
		
		-- set the direction based on player input
		local pk = data.controllingPlayer.keys
		local nextDirection
		if pk.up then nextDirection = DIR_UP
		elseif pk.down then nextDirection = DIR_DOWN
		elseif pk.left then nextDirection = DIR_LEFT
		elseif pk.right then nextDirection = DIR_RIGHT
		end
		-- the next direction cannot be the reverse of the current direction 
		if nextDirection and nextDirection ~= -data.direction then
			data.direction = nextDirection
		end
	
		-- Update the destination
		data.destination = v2(npc.x, npc.y) + directionToDest[data.direction]
		
		-- Check for coins at the destination
		data.collider.x = data.destination.x + 4
		data.collider.y = data.destination.y + 4
		for _,v in ipairs(Colliders.getColliding{a=data.collider, b=cfg.coinid, btype=Colliders.NPC}) do
			npc:kill(HARM_TYPE_VANISH)
			stopSnake()
			return
		end
		
		-- Update speed
		local nextVel = directionToVel[data.direction]
		npc.speedX = nextVel.x * cfg.speed
		npc.speedY = nextVel.y * cfg.speed
		
		data.blockImmune = false
	end
end

function snake.onTickEndNPC(npc)

	if Defines.levelFreeze
	or npc.despawnTimer <= 0
	or npc:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or npc:mem(0x136, FIELD_BOOL)        --Thrown
	or npc:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		return
	end

	local data = npc.data._basegame
	local cfg = NPC.config[npcID]
	
	data.animationTimer = (data.animationTimer or 0) + 1
	data.animationFrame = data.animationFrame or 0
	if data.animationTimer == cfg.framespeed then
		data.animationTimer = 0
		if pSwitchActive then
			data.animationFrame = (data.animationFrame + 1) % (cfg.frames - cfg.coinframes)
		else
			data.animationFrame = (data.animationFrame + 1) % cfg.coinframes
		end
	end
	npc.animationFrame = pSwitchActive and (data.animationFrame + cfg.coinframes) or data.animationFrame
	npc.animationTimer = 0
	
	if pSwitchStartFlag then
		data.blockImmune = true
	end
	
	if hitObstacle(npc) then
		npc:kill(HARM_TYPE_VANISH)
		stopSnake()
		return
	end
end

function snake.onStart()
	solidOrSemisolid = Block.SOLID..Block.SEMISOLID
end

function snake.onTick()
	pSwitchStartFlag = false
end

function snake.onPostEventDirect(name)
	if name == "P Switch - Start" then
		pSwitchActive = true
		pSwitchStartFlag = true
	elseif name == "P Switch - End" then
		pSwitchActive = false
	end
end

function snake.onExitLevel()
	activeSnakes = 1
	stopSnake()
end

return snake