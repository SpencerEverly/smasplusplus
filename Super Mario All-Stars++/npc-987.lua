local npc = {}
local id = NPC_ID

local npcManager = require "npcManager"

npcManager.setNpcSettings{
	id = id,
	
	frames = 1,
	framestyle = 0,
	
	nohurt = true,
	jumphurt = true,
	noiceball = true,

	width=12,
	height=12,
	gfxwidth=12,
	gfxheight=12,
	
	effect = 774,
	noyoshi = true,
}

function npc.onTickEndNPC(v)
	if v.collidesBlockBottom or v.collidesBlockTop or v.collidesBlockLeft or v.collidesBlockRight then
		v:kill(9)
		return
	end
	
	for k,n in ipairs(Colliders.getColliding{
		a = v,
		b = NPC.HITTABLE,
		btype = Colliders.NPC,
		filter = function(w)
			if (not w.isHidden) and w:mem(0x64, FIELD_BOOL) == false and w:mem(0x12A, FIELD_WORD) > 0 and w:mem(0x138, FIELD_WORD) == 0 and w:mem(0x12C, FIELD_WORD) == 0 then
				return true
			end
			return false
		end
	}) do
		v:kill(9)
		n:harm(3)
		return
	end
end

function npc.onPostNPCKill(v, r)
	if v.id ~= id then return end
	
	local config = NPC.config[v.id]
	
	for i = 1, 4 do
		local e = Effect.spawn(config.effect, v.x, v.y)
		e.speedX = math.random(-2,2)
		e.speedY = math.random(-2,2)
	end
end

function npc.onInitAPI()
	registerEvent(npc, 'onPostNPCKill')
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc