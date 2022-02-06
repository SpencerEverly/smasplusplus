local npcManager = require("npcManager")

local panser = {}

local npcID = NPC_ID

npcManager.setNpcSettings({
	id=npcID,
	width=20,
	height=20,
	gfxheight=32,
	gfxwidth=32,
	framestyle=1,
	framespeed=4,
	frames=3,
	gfxoffsety=4,
	
	noblockcollision = true,
	
	ignorethrownnpcs = true,
	linkshieldable = true,
	nogravity = true,
	spinjumpsafe = false,
	
	npcblock=false,
	effectID=10,
	lightradius=64,
	lightcolor=Color.orange,
	lightbrightness=1,
	jumphurt=true,
	
	nofireball=true,
	noiceball = true,
	ishot = true,
	durability = 3
})

function panser.onInitAPI()
	npcManager.registerEvent(npcID, panser, "onTickEndNPC")
end

local function puff(v)
	local e = Effect.spawn(147, v.x, v.y)
	e.animationFrame = 2
				
	v:kill(9)
end

--Fireballs
function panser.onTickEndNPC(v)
	--Local variable for data
	local data = v.data._basegame
	
	if v.ai1 == 0 then
		for k,b in Block.iterateIntersecting(v.x, v.y, v.x + v.width, v.y + v.height) do
			local invis1 = b:mem(0x5A, FIELD_WORD)
			local invis2 = b.isHidden
			
			if not Block.config[b.id].semisolid and not invis2 and invis1 >= 0 then
				return puff(v)
			end
		end
		
		for k,b in NPC.iterateIntersecting(v.x, v.y, v.x + v.width, v.y + v.height) do
			if NPC.config[b.id].npcblock and not b.isHidden and b:mem(0x12C, FIELD_WORD) == 0 and not b.isFriendly then
				return puff(v)
			end
		end
	end
end

return panser
