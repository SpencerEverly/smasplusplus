--Credits to MrDoubleA and Hoeloe
local npcManager = require("npcManager")
local blooper = {}
local playerManager = require("playerManager")
--Register events
function blooper.register(id)
	--npcManager.registerEvent(npcID, blooper, "onTickNPC")
	npcManager.registerEvent(id, blooper, "onTickEndNPC")
	--npcManager.registerEvent(npcID, blooper, "onDrawNPC")
	--registerEvent(blooper, "onNPCKill")
end

function blooper.onTickEndNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	--If despawned
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		--Reset our properties, if necessary
		data.initialized = false
		return
	end

	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		data.initialized = true
		data.blooperstate = 1 --1 = sinking, 2 = floating, 3 = beached
		data.noticetimer = 0 --Set to 50
		data.noticecooldown = 0 --set to 5
		data.determinedirection = 0
		data.aquatic = NPC.config[v.id].aquatic
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	local settings = PlayerSettings.get(playerManager.getBaseID(player.character),player.powerup)
	
	v.animationTimer = 0
	if data.aquatic == true and v.underwater == false then
		data.blooperstate = 3
	elseif data.blooperstate == 3 and v.underwater == true then
		data.blooperstate = 1
		data.noticecooldown = 20
	end
	if data.noticecooldown == 0 and player.y - settings.hitboxDuckHeight < v.y and data.blooperstate ~= 3 then
		data.blooperstate = 2
		data.noticetimer = 50
		if player.x > v.x then
			v.direction = 1
		else
			v.direction = -1
		end
		data.determinedirection = math.random(1, 5)
		if data.determinedirection == 5 then
			v.direction = v.direction * -1
		end
	end
	if data.blooperstate == 1 then
		v.animationFrame = 1
		v.speedX = 0
		v.speedY = 1
	elseif data.blooperstate == 2 then
		v.animationFrame = 0
		data.noticecooldown = 2
		v.speedX = data.noticetimer * .105 * v.direction
		v.speedY = data.noticetimer * -.105 - .5
		if data.noticetimer <= 0 or v.collidesBlockUp then
			data.noticetimer = 0
			data.blooperstate = 1
			data.noticecooldown = 20
		end
	else
		v.speedY = Defines.gravity
		if v.collidesBlockBottom then
			v.speedX = 0
		end
	end
	
	if data.noticetimer > 0 then
		data.noticetimer = data.noticetimer - 2
	end
	if data.noticecooldown > 0 then
		data.noticecooldown = data.noticecooldown - 1
	end
end

return blooper