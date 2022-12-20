--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local utils = require("npcs/npcutils")
local playerStun = require("playerstun")

local bros = {}

--Register events
function bros.register(npcID)
	npcManager.registerEvent(npcID, bros, "onTickNPC")
	--npcManager.registerEvent(npcID, bros, "onTickEndNPC")
	npcManager.registerEvent(npcID, bros, "onDrawNPC")
	--registerEvent(bros, "onNPCKill")
end

function bros.onTickNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
    
    if data.hammerTimer == nil then
        data.hammerTimer = NPC.config[v.id].thrownDelay - math.random(20, 100)
    end
	
	--If despawned
	if v.despawnTimer <= 0 then
		--Reset our properties, if necessary
		data.initialized = false
		return
	end

	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		data.initialized = true
		
		data.jumpTimer = 0
		data.walkTimer = 0
		data.walkDirection = -1
		data.jumpsDown = 0
		data.passthrough = 0
		
		data.hammerTimer = NPC.config[v.id].thrownDelay - math.random(20, 100)
		
		data.blockCheckUp = Colliders.Box(v.x, v.y - 128, v.width, v.height)
		
		data.blockCheckDown = Colliders.Box(v.x, v.y + (v.height * 2), v.width, v.height)
		
		data.triedUp = false
		data.triedDown = false
		
		data.blockDetect = nil
		
		data.thrownFrames = 0
		
		data.stillJump = false
		
		data.isFireShooting = false
		data.fireShot = 0
		
		data.hammerOffset = 0
		data.sledgeReady = false
		
		if NPC.config[v.id].chaseTimer ~= nil then
			data.chaseTimer = NPC.config[v.id].chaseTimer
		end
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	
	--Execute main AI. This template just jumps when it touches the ground.
	if data.chaseTimer == 0 and v.direction == v.spawnDirection then
		v.speedX = (NPC.config[v.id].speed + .5) * v.direction
	elseif data.stillJump == false and data.isFireShooting == false then
		data.walkTimer = data.walkTimer + 1
		
		v.speedX = NPC.config[v.id].speed * data.walkDirection
		
		if data.chaseTimer ~= nil and data.chaseTimer > 0 then
			data.chaseTimer = data.chaseTimer - 1
		end
	elseif v.collidesBlockBottom then
		data.stillJump = false
	end
	
	if data.walkTimer == 25 then
		data.walkTimer = -25
		data.walkDirection = data.walkDirection * -1
	end
	
	--Sledge Bro Stomp
	if v.speedY > 1 and NPC.config[v.id].isSledge then
		v.speedY = v.speedY + .5
		data.sledgeReady = true
	end
	
	if data.sledgeReady and v.collidesBlockBottom then
		for k, p in ipairs(Player.get()) do --Section copypasted from the Sledge Bros. code
			if p:isGroundTouching() and not playerStun.isStunned(k) and v:mem(0x146, FIELD_WORD) == player.section then
				playerStun.stunPlayer(k, 70)
			end
		end
		data.sledgeReady = false
		SFX.play(37)
		Defines.earthquake = 6
	end
	
	data.blockCheckUp.x = v.x
	data.blockCheckUp.y = v.y - 128
	
	data.blockCheckDown.x = v.x
	data.blockCheckDown.y = v.y + (v.height * 1.7)
	
	if player.x > v.x + (v.width / 2) then
		v.direction = 1
	else
		v.direction = -1
	end
	
	if v.collidesBlockBottom then --Jumping through blocks, god this code's a mess
		data.jumpTimer = data.jumpTimer + 1
		if data.jumpTimer == math.random(50, NPC.config[v.id].jumpCooldown) or data.jumpTimer >= NPC.config[v.id].jumpCooldown then
			data.jumpTimer = 0
			if NPC.config[v.id].jumpsThroughBlock then
				if data.triedDown == false and data.triedUp == false then
					data.jumpsDown = math.random(0, 1)
				elseif data.triedDown and data.triedUp then
					data.jumpsDown = -1
				end
				
				if data.jumpsDown == 0 then
					for _,z in ipairs(Block.getIntersecting(data.blockCheckUp.x, data.blockCheckUp.y, 
					data.blockCheckUp.x + v.width, data.blockCheckUp.y + v.height)) do
						if not z.invisible then
							data.blockDetect = z.id
						end
					end
					
					if not table.icontains(Block.SOLID, data.blockDetect) then
						data.blockDetect = nil
					end
					
					if data.blockDetect == nil then
						v.speedY = -NPC.config[v.id].jumpHeight
						if NPC.config[v.id].jumpSoundID > 0 then
							SFX.play(NPC.config[v.id].jumpSoundID)
						end
						
						if NPC.config[v.id].moveWhenJumping == false then
							v.speedX = 0
							data.stillJump = true
						end
						data.passthrough = 25
					elseif data.triedDown == false then
						data.jumpTimer = 300
						data.jumpsDown = 1
					end
					
					data.triedUp = true
				elseif data.jumpsDown == 1 then
					for _,z in ipairs(Block.getIntersecting(data.blockCheckDown.x, data.blockCheckDown.y, 
					data.blockCheckDown.x + v.width, data.blockCheckDown.y + v.height)) do
						if not z.invisible then
							data.blockDetect = z.id
						end
					end
					
					if not table.icontains(Block.SOLID, data.blockDetect) then
						data.blockDetect = nil
					end
					
					if data.blockDetect == nil then
						v.speedY = -2
						if NPC.config[v.id].jumpSoundID > 0 then
							SFX.play(NPC.config[v.id].jumpSoundID)
						end
						if NPC.config[v.id].moveWhenJumping == false then
							v.speedX = 0
							data.stillJump = true
						end
						
						if NPC.config[v.id].isSledge then
							data.passthrough = 30
						else
							data.passthrough = 35
						end
					elseif data.triedUp == false then
						data.jumpTimer = 300
						data.jumpsDown = 0
					end
					
					data.triedDown = true
				end
				data.blockDetect = nil
			else
				if NPC.config[v.id].jumpSoundID > 0 then
					SFX.play(NPC.config[v.id].jumpSoundID)
				end
				if NPC.config[v.id].moveWhenJumping == false then
					v.speedX = 0
					data.stillJump = true
				end
				v.speedY = -NPC.config[v.id].jumpHeight
			end
		end
	end
	
	if data.passthrough > 0 then
		data.passthrough = data.passthrough - 1
		v.noblockcollision = true
		data.triedUp = false
		data.triedDown = false
	else
		v.noblockcollision = false
	end

	data.hammerTimer = data.hammerTimer + 1
	if data.hammerTimer == NPC.config[v.id].thrownDelay + NPC.config[v.id].thrownHold and NPC.config[v.id].isFire == false then --Throwing Hammer
		data.hammerTimer = 0
		p = NPC.spawn(NPC.config[v.id].thrownNPC, v.x + data.hammerOffset + (NPC.config[v.id].holdX * -v.direction), v.y - NPC.config[v.id].holdY)
		p.direction = v.direction
		p.speedX = NPC.config[v.id].thrownSpeedX * v.direction
		p.speedY = NPC.config[v.id].thrownSpeedY
		if NPC.config[v.id].throwSoundID > 0 then
			SFX.play(NPC.config[v.id].throwSoundID)
		end
	elseif data.hammerTimer >= NPC.config[v.id].thrownDelay and NPC.config[v.id].isFire then
		data.isFireShooting = true
		v.speedX = 0
		if data.hammerTimer == NPC.config[v.id].thrownDelay + NPC.config[v.id].thrownHold then
			if data.fireShot == 2 then
				data.fireShot = 0
				data.hammerTimer = 0
				data.isFireShooting = false
			else
				data.fireShot = data.fireShot + 1
				data.hammerTimer = NPC.config[v.id].thrownDelay
				SFX.play(NPC.config[v.id].throwSoundID)
				
				p = NPC.spawn(NPC.config[v.id].thrownNPC, v.x + (v.width / 2), v.y + (v.height / 6))
				p.direction = v.direction
				p.speedX = NPC.config[v.id].thrownSpeedX * v.direction
				p.speedY = NPC.config[v.id].thrownSpeedY
			end
		end
	end
end

function bros.onDrawNPC(v)
	local data = v.data
	
	utils.restoreAnimation(v)
	walk = utils.getFrameByFramestyle(v, {
		frames = NPC.config[v.id].walkFrames,
		gap = NPC.config[v.id].holdFrames,
		offset = 0
	})
	hold = utils.getFrameByFramestyle(v, {
		frames = NPC.config[v.id].holdFrames,
		gap = 0,
		offset = NPC.config[v.id].walkFrames
	})
    
	if data.hammerTimer >= NPC.config[v.id].thrownDelay then
		v.animationFrame = hold
		
		
		if NPC.config[v.id].isFire == false then
			local heldNPC = NPC.config[v.id].thrownNPC
		
			if v.direction == 1 then
				if NPC.config[heldNPC].framestyle ~= 0 then
					data.thrownFrames = NPC.config[heldNPC].frames
				end
				if v.width > 32 then
					data.hammerOffset = v.width - 32
				else
					data.hammerOffset = 0
				end
			else
				data.thrownFrames = 0
				data.hammerOffset = 0
			end
		
			Graphics.draw{
				type = RTYPE_IMAGE,
				image = Graphics.sprites.npc[heldNPC].img, 
				x = v.x + data.hammerOffset + (NPC.config[v.id].holdX * -v.direction),
				y = v.y - NPC.config[v.id].holdY,
				sceneCoords = true,
				sourceX = 0, 
				sourceY = NPC.config[heldNPC].gfxheight * data.thrownFrames, 
				sourceWidth = NPC.config[heldNPC].gfxwidth,
				sourceHeight = NPC.config[heldNPC].gfxheight,
				priority = -44
			}
		end
	else
		v.animationFrame = walk
	end
end

--Gotta return the library table!
return bros