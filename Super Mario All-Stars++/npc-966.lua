local npcManager = require("npcManager")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
	id = id,
	
	frames = 2,
	framestyle = 1,
	framespeed = 4,
	
	foreground = true,
	
	jumphurt = true,
	nohurt = true,
	
	noiceball = true,
	noyoshi = true,
	
	nogravity = true,
	disableSparkles = false,
})

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onCameraDrawNPC')
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

local npcutils = require 'npcs/npcutils'

--damn you, redigit
framestyleone_npcs = {
	[162] = true,
	[163] = true,
	[17] = true,
	[119] = true,
	[117] = true,
	[118] = true,
	[120] = true,
	[108] = true,
	[148] = true,
	[95] = true,
	[100] = true,
	[98] = true,
	[99] = true,
	[149] = true,
	[150] = true,
	[228] = true,
	[282] = true,
	[189] = true,
	[42] = true,
	[43] = true,
	[44] = true,
	[203] = true,
	[20] = true,
	[19] = true,
	[25] = true,
	[129] = true,
	[135] = true,
	[173] = true,
	[176] = true,
	[175] = true,
	[177] = true,
	[4] = true,
	[6] = true,
	[72] = true,
	[76] = true,
	[161] = true,
	[23] = true,
	[36] = true,
	[229] = true,
	[230] = true,
	[86] = true,
	[267] = true,
	[84] = true,
	[38] = true,
	[94] = true,
	[75] = true,
	[101] = true,
	[198] = true,
	[87] = true,
	[85] = true,
	[39] = true,
	[262] = true,
	[201] = true,
	[28] = true,
	[223] = true,
	[102] = true,
	[125] = true,
	[209] = true,
	[204] = true,
	[168] = true,
	[158] = true,
	[107] = true,
	[272] = true,
	[285] = true,
	[109] = true,
	[110] = true,
	[111] = true,
	[112] = true,
	[117] = true,
	[118] = true,
	[119] = true,
	[120] = true,
	[164] = true,
	[18] = true,
}	

function npc.onCameraDrawNPC(v)
	if v.despawnTimer <= 0 then return end
	local data = v.data._basegame
	
	if not data.init then return end

	local n = data.npc
	
	if not n or not n.isValid then return end
	
	local config = NPC.config[id]
	local nc = NPC.config[n.id]
	local ndata = n.data._basegame
	
	local frame = math.floor((lunatime.tick() / config.framespeed) % config.frames)
	local condition = (ndata.direction == 1 or ndata.lockDirection == 1 or ndata.facingDirection == 1 or n.direction == 1)
	
	if condition and config.framestyle > 0 and (nc.framestyle > 0 or (nc.frames == 0 and framestyleone_npcs[n.id])) then
		frame = frame + config.frames
	end
	
	if nc.framestyle > 0 or (nc.frames == 0 and framestyleone_npcs[n.id]) then
		npcutils.drawNPC(n, {
			texture = Graphics.sprites.npc[id].img,
			frame = 0,
			
			sourceY = config.height * frame,
			xOffset = ((not condition) and nc.width) or -config.width,
			yOffset = -config.height / 2,
			
			width = config.width,
			height = config.height,
			
			applyFrameStyle = false,
		})
	else
		for i = 1, 2 do
			npcutils.drawNPC(n, {
				texture = Graphics.sprites.npc[id].img,
				frame = 0,
				
				sourceY = (i == 2 and config.framestyle == 1 and config.height * (frame + config.frames)) or config.height * frame,
				xOffset = (i == 1 and n.width) or -config.width,
				yOffset = -config.height / 2,
				
				width = config.width,
				height = config.height,
				
				applyFrameStyle = false,
			})
		end
	end
	
	-- Graphics.drawBox{
		-- x = v.x,
		-- y = v.y,
		-- width = v.width,
		-- height = v.height,
		
		-- sceneCoords = true,
	-- }
end

local function init(v)
	local config = NPC.config[id]
	local data = v.data._basegame
	
	if not data.init then
		if v.friendly then
			data.friendly = v.friendly
		end
		
		v.friendly = true
		
		if v.ai1 > 0 then
			local nc = NPC.config[v.ai1]
			
			data.npc = NPC.spawn(v.ai1, v.x, v.y - (nc.height - v.height) / 2, v.section, true, true)
			data.npc.msg = v.msg
			data.npc.spawnDirection = v.direction
			data.npc.direction = v.direction
			data.npc.despawnTimer = v.despawnTimer
			
			v.msg = ""
		else
			v:kill(9)
			return
		end
		
		data.init = true
	end
end

local sine = {
	[2] = true,
	[5] = true,
}

local function ai(v)
	local data = v.data._basegame
	local n = data.npc
	
	if not n or not n.isValid then return end
	
	local nc = NPC.config[n.id]
	
	if v.ai2 == 1 or v.ai2 == 4 then
		n.speedX = 1.2 * n.direction
		
		if nc.nogravity then
			n.speedY = n.speedY + Defines.npc_grav	
		end
		
		if nc.noblockcollision then
			n.noblockcollision = false
			v.noblockcollision = false
		end
	else
		if nc.noblockcollision then
			n.noblockcollision = true
			v.noblockcollision = true
		end
	end
	
	if v.ai2 == 0 then
		local p = Player.getNearest(n.x + n.width / 2, n.y + n.height / 2)
		
		local px = p.x + p.width / 2
		local nx = n.x + n.width / 2
		local py = p.y - n.height / 2
		local ny = n.y + n.height / 2
		
		if px > nx then
			n.direction = 1
		else
			n.direction = -1
		end
		
		if py > ny then
			v.speedY = v.speedY + 0.1
		else
			v.speedY = v.speedY - 0.1
		end
		
		v.speedX = v.speedX + (0.1 * n.direction)
		v.speedX = math.clamp(v.speedX, -6, 6)
		v.speedY = math.clamp(v.speedY, -6, 6)
		
		n.speedX = v.speedX
		n.speedY = v.speedY
	end
	
	local time = v.ai3 / 1.2
	
	if sine[v.ai2] then
		n.speedY = math.sin(time)
	end
	
	if v.ai2 == 5 then
		n.speedX = 1.2 * n.spawnDirection
	elseif v.ai2 == 2 then
		n.speedX = math.cos(v.ai3 / 10) * 1.2 * n.spawnDirection
	end
	
	if v.ai2 == 3 then
		n.speedY = math.sin(v.ai3 / 10) * 1.2 * n.spawnDirection
	elseif v.ai2 == 6 then
		n.speedY = 1.2 * n.spawnDirection
	end
	
	if n.collidesBlockBottom then
		n.speedY = (v.ai2 == 1 and -9) or -4
		
		n.y = n.y - 0.1
	end
end

function npc.onTickEndNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data._basegame
	init(v)
	
	v.ai3 = v.ai3 + 0.1
	
	ai(v)
	
	if data.npc and data.npc.isValid then
		if data.npc:mem(0x130, FIELD_WORD) > 0 then
			data.npc = nil
			return
		end
		
		data.npc:mem(0x138, FIELD_WORD, v:mem(0x138, FIELD_WORD))
		data.npc:mem(0x13C, FIELD_WORD, v:mem(0x13C, FIELD_WORD))
		data.npc:mem(0x144, FIELD_WORD, v:mem(0x144, FIELD_WORD))
		
		local ndata = data.npc.data._basegame
		
		ndata._hasWings = v.idx
		
		v.x = data.npc.x
		v.y = data.npc.y
		v.width = data.npc.width
		v.height = data.npc.height
		
		data.npc.despawnTimer = v.despawnTimer
		
		data.npc.isHidden = v.isHidden
		
		if math.random() > 0.5 and not NPC.config[id].disableSparkles and data.npc.despawnTimer > 0 then
			Effect.spawn(80, data.npc.x + math.random(0, data.npc.width), data.npc.y + math.random(0, data.npc.height))
		end
	else
		v:kill(9)
	end
	
	v.animationFrame = -1
end

return npc