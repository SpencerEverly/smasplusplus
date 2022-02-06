local npc = {}
local id = NPC_ID

local settings = {
	id = id,
	
	frames = 8,
	framespeed = 16,
	
	jumphurt = true,
	nohurt = true,
	
	npcblock = true,
	npcblocktop = true,
	playerblock = true,
	playerblocktop = true,
	
	grabside = true,
	grabtop = true,
	
	noiceball = true,
	noyoshi= true,
	nofireball = true,

	harmlessgrab=true,
}

function npc.onCameraDrawNPC(v)
	if v.despawnTimer <= 0 then return end
	
	Sprite.draw{
		texture = Graphics.sprites.npc[v.id].img,
		
		x = v.x + v.width / 2,
		y = v.y + v.height / 2,
		sceneCoords = true,
		
		rotation = v.ai1,
		
		align=Sprite.align.CENTER,
		priority = -45,
	}
end

function npc.onTickEndNPC(v)	
	local data = v.data._basegame
	local rad2deg = 180.0 / math.pi
	
	v.ai1 = v.ai1 + (v.speedX / (0.5 * v.height)) * rad2deg
	
	v.animationFrame = -1
	v:mem(0x134, FIELD_WORD, 0)
	
	if v.speedX ~= 0 and v.collidesBlockBottom then
		local abs = math.abs(v.speedX)
		
		v.speedY = -abs / 2
	end
	
	if data.canHurt and v:mem(0x12C, FIELD_WORD) <= 0 then
		for k,p in ipairs(Player.getIntersecting(v.x - 1, v.y + 1, v.x + v.width + 2, v.y + v.height + 1)) do
			p:harm()
		end
	elseif v:mem(0x12C, FIELD_WORD) > 0 then
		data.canHurt = false
	end
end

function npc.onInitAPI()
	local nm = require 'npcManager'
	
	nm.setNpcSettings(settings)
	nm.registerEvent(NPC_ID, npc, 'onCameraDrawNPC')
	nm.registerEvent(NPC_ID, npc, 'onTickEndNPC')
end

return npc