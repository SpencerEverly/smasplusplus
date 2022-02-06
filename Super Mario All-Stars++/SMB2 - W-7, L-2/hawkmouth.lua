local hawk = {}

local idList  = {}
local canHarm = {}

local defaultSettings = {
	width = 32,
	height = 82,
	
	gfxwidth = 32,
	gfxheight = 82,
	
	playerblocktop = true,
	npcblocktop = true,
	npcblock = true,
	playerblock = true,
	
	jumphurt = true,
	
	nohurt = true,
	nogravity = true,
	noblockcollision = true,
	noiceball = true,
	noyoshi = true,
	
	frames = 1,
	
	maxLen = 22,
	notcointransformable = true,
	
	boss = false,
	hp = 3,
}

local npcManager = require 'npcManager'

function hawk.register(config)
    table.insert(idList, config.id)
	local config = table.join(config, defaultSettings)
	npcManager.setNpcSettings(config)
	
	if config.boss then
		canHarm[config.id] = true
	
		npcManager.registerHarmTypes(config.id,
			{
				HARM_TYPE_NPC,
				HARM_TYPE_PROJECTILE_USED,
			},
			{
		
			}
		)
	end
	
	npcManager.registerEvent(config.id, hawk, "onCameraDrawNPC")
	npcManager.registerEvent(config.id, hawk, "onTickEndNPC")
end

local npcutils = require 'npcs/npcutils'

local IDLE = 0
local READY = 1
local UP = 2
local DOWN = 3
local BACK = 4

function hawk.onCameraDrawNPC(v)
	local config = NPC.config[v.id]
	
	
	if v.ai2 == UP or v.ai2 == DOWN or v.ai2 == BACK then
		local frame = ((v.direction == 1 and config.frames + 1) or 0)
		
		for i = v.ai1, 0, -1 do
			npcutils.drawNPC(v, {
				sourceY = 58,
				frame = frame + 1,
				height = 2,
				yOffset = -v.ai1 + 58 + i,
				priority = -66,
			})
		end
		
		npcutils.drawNPC(v, {
			frame = frame + 1,
			height = 58,
			yOffset = -v.ai1,
			priority = -66,
		})
		
		npcutils.drawNPC(v, {
			frame = frame + 1,
			height = 22,
			sourceY = 60,
			yOffset = 60,
			priority = -66,
		})
	else
		local frame = ((v.direction == 1 and config.frames + 1) or 0) + ((v.ai2 == READY and 1) or 0)
		
		if v.ai2 == READY and v.ai1 <= 64 then
			if math.random(8) > 4 then
				frame = frame + 4
			end
		end
		
		npcutils.drawNPC(v, {
			frame = frame,
			priority = -75,
		})
	end
	
	if v.ai3 > 0 then
		local p = Player(v.ai3)
		
		p:render{
			ignorestate = true,
			priority = -70,
		}
	end
	
	if v.ai3 > 0 then
		Graphics.drawScreen{
			color = Color.black .. v.ai5,
		}
	end
end

local COLLISION_SIDE_NONE    = 0
local COLLISION_SIDE_TOP     = 1
local COLLISION_SIDE_RIGHT   = 2
local COLLISION_SIDE_BOTTOM  = 3
local COLLISION_SIDE_LEFT    = 4
local COLLISION_SIDE_UNKNOWN = 5

local function side(Loc1, Loc2, leniencyForTop)
    leniencyForTop = leniencyForTop or 0
    
	local right = (Loc1.x + Loc1.width) - Loc2.x - Loc2.speedX
	local left = (Loc2.x + Loc2.width) - Loc1.x - Loc1.speedX
	local bottom = (Loc1.y + Loc1.height) - Loc2.y - Loc2.speedY
	local top = (Loc2.y + Loc2.height) - Loc1.y - Loc1.speedY
	
	if right < left and right < top and right < bottom then
		return COLLISION_SIDE_RIGHT
	elseif left < top and left < bottom then
		return COLLISION_SIDE_LEFT
	elseif top < bottom then
		return COLLISION_SIDE_TOP
	else
		return COLLISION_SIDE_BOTTOM
	end
end

function hawk.onTickEndNPC(v)
	local data = v.data._basegame
	local config = NPC.config[v.id]
	
	if v.despawnTimer > 0 then
		v.despawnTimer = 180
	end
	
	if config.boss then
		if not data.boss then
			data.hp = config.hp
			data.boss = true
		end
	end
	
	if v.ai2 == UP then
		v.ai1 = v.ai1 + 1
		
		if v.ai1 > config.maxLen then
			v.ai1 = config.maxLen
			v.ai4 = v.ai4 + 1
			
			if v.ai4 > 128 and config.boss then
				v.ai4 = 0
				v.ai2 = BACK
				SFX.play 'hawk_close.spc'
				
				return
			end
			
			for k,p in ipairs(Player.getIntersecting(v.x - 1, v.y - 1, v.x + v.width + 1, v.y + v.height + 1)) do
				local s = side(v, p)
				
				if s == 4 or s == 2 and k == 1 then
					v.ai3 = 1
					v.ai2 = DOWN
					v.ai4 = v.ai1
					SFX.play 'hawk_close.spc'
					
					return
				end
			end
		end
	elseif v.ai2 == DOWN then
		if v.ai1 > 0 then
			v.ai1 = v.ai1 - 0.5
		end
		
		local p = Player(v.ai3)
		
		if v.ai4 > -p.width then
			v.ai4 = v.ai4 - 1
		end
	elseif v.ai2 == BACK then
		if v.ai1 > 0 then
			v.ai1 = v.ai1 - 0.5
		else
			v.ai2 = READY
			v.ai1 = 64
			
			data.hp = config.hp
		end
	else
		if v.ai2 == READY then
			v.ai1 = v.ai1 + 1
			
			if v.ai1 > 64 then
				if config.boss and data.hp > 0 then
					local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
					
					if (p.x + p.width / 2) > v.x + v.width / 2 then
						v.speedX = v.speedX + 0.05
					else
						v.speedX = v.speedX - 0.05			
					end
					
					if (p.y + p.height / 2) > v.y + v.height / 2 then
						v.speedY = v.speedY + 0.01
					else
						v.speedY = v.speedY - 0.01		
					end
					
					v.speedX = math.clamp(v.speedX, -6, 6)
					v.speedY = math.clamp(v.speedY, -6, 6)
					
					for k,n in ipairs(Player.getIntersecting(v.x - 1, v.y, v.x + v.width + 1, v.y + v.height + 1)) do
						n:harm()
					end
				else
					v.ai1 = 0
					v.ai2 = UP
					
					SFX.play 'hawk_open.spc'
				end
			end
		end
	end
	
	local settings = v.data._settings
	
	if v.ai3 > 0 then
		local p = Player(v.ai3)
		
		p.ForcedAnimationState = FORCEDSTATE_INVISIBLE
		
		if not config.boss then
			p.x = v.x + (v.ai4 * v.direction)
		else
			p.x = v.x + (-p.width / 4 * v.direction)
		end
		
		p.y = v.y + v.height - p.height - 12
		p.frame = (lunatime.tick() / 8) % 2
		p.frame = p.frame + 1
		p:mem(0x140, FIELD_WORD, 100)
		
		if v.ai4 <= -p.width then
			v.ai5 = v.ai5 + 0.1
			
			if v.ai5 > 1 then
				p.frame = 0
				
				if config.boss then
					if settings.tele[1] ~= 0 and settings.tele[2] ~= 0 then
						p:teleport(settings.tele[1], settings.tele[2])
						v:kill(9)
						p.ForcedAnimationState = 0
						
						return
					end
				end
				
				Level.winState(4)
			end
		end
	end
	
	v.animationFrame = -1
end

function hawk.onNPCKill(e, v, r)
	if v.id ~= 41 then return end
	
	local hawks = NPC.get(idList, v.section)
	
	if #hawks ~= 0 then
		Level.winState(0)
		
		for k,h in ipairs(hawks) do
			h.ai2 = READY
			h.ai1 = 0
		end
	end
end

function hawk.onNPCHarm(e, v)
	if not canHarm[v.id] then return end
	
	local data = v.data._basegame
	
	if v.ai1 >= 64 and v.ai2 == READY then
		SFX.play(39)
		
		v.ai1 = 0
		v.ai2 = READY
		v.speedX = 0
		v.speedY = 0
		
		data.hp = data.hp - 1
	end
	
	e.cancelled = true
end

function hawk.onInitAPI()
	registerEvent(hawk, 'onNPCKill')
	registerEvent(hawk, 'onNPCHarm')
end

return hawk