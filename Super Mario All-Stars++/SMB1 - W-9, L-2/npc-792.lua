local npc = {}
local npcManager = require("npcManager")
local id = NPC_ID

npcManager.setNpcSettings({
	id = id,
	
	gfxheight = 24,
	height = 24,
	width = 18,
	gfxwidth = 18,
	
	frames = 1,
	
	nogravity = true,
	noblockcollision = true,
	
	jumphurt = true,
	nohurt = true,
	
	noiceball = true,
	noyoshi = true,
	
	maxWidth = 96,
	
	platformId = id + 1,
	
	acceleration = 0.075,
})

local npcutils = require 'npcs/npcutils'

local function renderLines(v, n, w)
	if not n.isValid then return end
	
	local distance = (v.y + v.height) - n.y
	
	for i = 0, -distance do
		npcutils.drawNPC(v, {
			frame = (w == 0 and 0) or 2,
			xOffset = w,
			yOffset = 24 + i,
			sourceY = 18,
			height = 1,
		})
	end
end

function npc.onCameraDrawNPC(v)
	if v.despawnTimer <= 0 then return end
	
	local config = NPC.config[id]
	local settings = v.data._settings
	
	npcutils.drawNPC(v, {
		xOffset = settings.len,
		frame = 2,
	})
	
	for i = 0, settings.len - 16 do
		npcutils.drawNPC(v, {
			xOffset = i + 16,
			width = 1,
			frame = 1,
		})
	end
	
	local data = v.data._basegame
	local plt = data.platforms
	
	if plt and #plt ~= 0 then
		for k,n in ipairs(plt) do
			renderLines(v, n, (k == 2 and settings.len) or 0)
		end
	end
end

local function init(v)
	local data = v.data._basegame
	local settings = v.data._settings
	
	if not data.init then
		local config = NPC.config[id]
		
		v.width = settings.len + v.width + 80
		v.x = v.x - (v.width / 2) + 8
		
		data.platforms = {}
		
		data.platforms[1] = NPC.spawn(config.platformId, v.x + (v.width / 2) - 40, v.y + 24 + v.ai2, v.section)
		data.platforms[2] = NPC.spawn(config.platformId, v.x + (v.width / 2) + settings.len - 24, v.y + 24 + v.ai2, v.section)
		data.platforms[1].ai1 = 1
		data.platforms[2].ai1 = 1
	
		v.height = v.ai2 + 24
		v.y = v.y - v.ai2
		
		data.init = true
	end
end

local function platformBreak(v)
	local data = v.data._basegame

	for k,n in ipairs(data.platforms) do
		n.ai1 = 2
		n.speedY = 0
	end
	
	data.platforms = {}
end

local function platformLogic(p, v)
	local data = v.data._basegame
	local plt = data.platforms
	local config = NPC.config[id]
	
	plt[1].ai1 = 1
	plt[2].ai1 = 1
		
	if p.standingNPC == plt[1] then
		plt[1].speedY = plt[1].speedY + config.acceleration
		plt[2].speedY = plt[2].speedY - config.acceleration
	elseif p.standingNPC == plt[2] then
		plt[1].speedY = plt[1].speedY - config.acceleration
		plt[2].speedY = plt[2].speedY + config.acceleration
	end
	
	if p.standingNPC == plt[1] or p.standingNPC == plt[2] then
		for k,n in ipairs(plt) do
			if n.y < v.y + v.height then
				n.y = v.y + v.height
				
				platformBreak(v)
			end
		end
	end
end

function npc.onTickEndNPC(v)
	local data = v.data._basegame
	
	if v.section ~= player.section then
		data.platforms = nil 
		data.init = nil
		return
	end
	
	init(v)
	local plt = data.platforms
	
	if plt and #plt ~= 0 then
		if v.despawnTimer > 0 then
			v.despawnTimer = 180
		end
		
		if plt[1] and plt[2] and plt[1].isValid and plt[2].isValid then
			plt[1].despawnTimer = 180
			plt[2].despawnTimer = 180
		end
		
		if plt[1].isValid and plt[2].isValid then
			for k,p in ipairs(Player.get()) do
				if p.standingNPC and p.standingNPC.isValid then
					platformLogic(p, v)
				else
					plt[1].speedY = 0
					plt[2].speedY = 0
				end
			end
		end
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onCameraDrawNPC')
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc