--[[
	Groundpound.lua
	By Marioman2007 - v1.1
]]

local pm = require("playermanager")
local extrasounds = require("extrasounds")
local GP = {}

GP.STATE_NONE = 0
GP.STATE_SPIN = 1
GP.STATE_POUND = 2
GP.STATE_POUND_AFTER = 3

GP.enabled = true -- the player cannot ground pound if set to false
GP.poundJumpEnabled = true -- is the pound jump enabled?
GP.poundJumpHeight = 28
GP.slopeSpeed = 5 -- the speed of the player when they pound into a slope
GP.poundSpeed = 12 -- 12 is the maximum value, if you don't mess with Defines.gravity
GP.yAccel = 0.5 -- if the player's speed is less than the pound speed while pounding, this will be their acceleration
GP.stopPlayer = true -- stops the pound when hitting certain blocks, if set to true
GP.state = GP.STATE_NONE
GP.isPounding = false
GP.GFXoffsetX = 0
GP.GFXoffsetY = 0
GP.turnBlocks = table.map{90} -- turn blocks are handled a bit differently

GP.animation = { -- table for frames and framespeed for separate states
	spin       = {frames = 4, framespeed = 3},
	pound      = {frames = 1, framespeed = 8},
	poundAfter = {frames = 1, framespeed = 5},
}

GP.playerFrames = { -- table for frames when here is no ground pound image
    -- character         -- spin frames    pound frames  poundAfter frames
    [CHARACTER_MARIO] = {{1, 2, 3, 2},     {24},         {7}},
	[CHARACTER_LUIGI] = {{1, 2, 3, 2},     {24},         {7}},
	[CHARACTER_PEACH] = {{7, 7, 7, 7},      {7},         {7}},
	[CHARACTER_TOAD]  = {{7, 7, 7, 7},      {7},         {7}},
}

GP.effects = {
	smoke = 900,
	poof  = 901,
	stars = 902,
}

GP.SFX = {
	poundStart = {id = extrasounds.sounds[159].sfx,  volume = extrasounds.volume},
	poundJump  = {id = extrasounds.sounds[59].sfx, volume = extrasounds.volume},
	poundHit   = {id = extrasounds.sounds[160].sfx, volume = extrasounds.volume},
}

local bottomTouchingNPCs
local bottomTouchingBLOCKs
local belowBoxHeight = 4
local canPressJump = true
local canPressAltJump = true
local canPoundAfterBlck = true
local canHit = true
local hitTimer = 0
local hitDelay = 16
local poundingTurnBlocks = false
local bonkOffset = 0
local playerOpacity = 1

local storedPX = 0
local storedPY = 0

local spinTimer = 0
local poundTimer = 0
local poundAfterTimer = 0

local spinFrame = 0
local poundFrame = 0
local poundAfterFrame = 0

local spinDuration = 0
local restDuration = 0
local totalFrames = 0

function GP.startPound()
	storedPX = player.x
	storedPY = player.y
	GP.state = GP.STATE_SPIN
	SFX.play(GP.SFX.poundStart.id, GP.SFX.poundStart.volume)
	player.speedX = 0
end

function GP.cancelPound()
	GP.state = GP.STATE_NONE
end

-- Returns if a player is wall sliding with anotherwalljump.lua, thanks to MrDoubleA!!
local anotherwalljumpEnabled = nil
local anotherwalljump
local function aWisWallSliding(p)
	if anotherwalljumpEnabled == nil then
		-- Try to find anotherwalljump if we haven't already
		pcall(function() anotherwalljump = anotherwalljump or require("anotherwalljump") end)
		pcall(function() anotherwalljump = anotherwalljump or require("aw")              end)

		anotherwalljumpEnabled = (anotherwalljump ~= nil and anotherwalljump.isWallSliding ~= nil)
	end

	return (anotherwalljumpEnabled and anotherwalljump.isWallSliding(p) ~= 0)
end

local function noBeneathBlocks()
	local desiredBlocks = {}
	for k, blck in ipairs(bottomTouchingBLOCKs) do
		if blck.isValid and (not Block.PLAYER_MAP[blck.id]) and (not Block.config[blck.id].passthrough) and (not blck.isHidden) and (not blck.invisible) then
			table.insert(desiredBlocks, blck)
		end
	end
	return #desiredBlocks == 0
end

local function canHitNPC(v)
	if v.isValid and (NPC.HITTABLE_MAP[v.id]) and (not v.friendly) and (not v.isGenerator) and (not v.isHidden) and (not NPC.config[v.id].jumphurt) then
		return true
	end
end

local function validBlock(v)
	if v.isValid and (not Block.SLOPE_MAP[v.id]) and (not Block.SEMISOLID_MAP[v.id]) and (not Block.SIZEABLE_MAP[v.id]) and (not v.isHidden) then
		return true
	end
end

local function isOnGround() -- Detects if the player is on the ground, the redigit way. Sometimes more reliable than just player:isOnGround().
	return (
		(player.speedY == 0 and ((not poundingTurnBlocks or noBeneathBlocks()) or GP.stopPlayer)) -- "on a block"
		or player:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
		or (player:mem(0x48,FIELD_WORD) ~= 0) -- on a slope
	)
end

local function handleSpeed()
	if GP.stopPlayer then
		if player.keys.altJump then
			player.speedY = 0.05
		else
			player.speedY = 0
		end
	else
		player.speedY = 0.05
	end
end

local function canPound()
	return (
        GP.enabled
		and canPoundAfterBlck
		and not aWisWallSliding(player)
		and not isOnGround()
		and player.forcedState == FORCEDSTATE_NONE
		and player.deathTimer == 0 and not player:mem(0x13C, FIELD_BOOL) -- not dead
		and player.mount == MOUNT_NONE
		and not player:mem(0x0C, FIELD_BOOL) -- fairy
		and not player:mem(0x3C, FIELD_BOOL) -- sliding
		and not player:mem(0x44, FIELD_BOOL) -- surfing on a rainbow shell
		and not player:mem(0x4A, FIELD_BOOL) -- statue
		and player:mem(0x26,FIELD_WORD) == 0 -- picking up something from the top
		and player.holdingNPC == nil
	)
end

local function shouldStop() -- used when in spin state
	return (
		player.forcedState == 3 or player.forcedState == 7 or player.forcedState == 8
		or aWisWallSliding(player)
		or player.mount ~= MOUNT_NONE
		or player:mem(0x4A, FIELD_BOOL) -- statue
		or player:mem(0x3C, FIELD_BOOL) -- sliding
		or player:mem(0x0C, FIELD_BOOL) -- fairy
		or (player.deathTimer > 0 and player:mem(0x13C, FIELD_BOOL))
	)
end

local function shouldStop2() -- used when in pound state
	return (
		isOnGround()
		or shouldStop()
	)
end

local function poundNPC(v)
	local eventObj = {cancelled = false}
	EventManager.callEvent("onNPCPound", eventObj, v)

	if canHitNPC(v) and (not v.data.GP_pounded) and (not eventObj.cancelled) then
		if NPC.MULTIHIT_MAP[v.id] then
			v:harm(HARM_TYPE_JUMP, 5)
		else
			v:kill(HARM_TYPE_NPC)
			local correctScore = player:mem(0x56, FIELD_WORD) + 2

			if player:mem(0x56, FIELD_WORD) < 9 then
				player:mem(0x56, FIELD_WORD, player:mem(0x56,FIELD_WORD) + 1)
			else
				player:mem(0x56, FIELD_WORD, 8)
			end

			if (correctScore) >= 2 then
				Misc.givePoints(correctScore, vector(player.x, player.y))
			end
		end
		if NPC.config[v.id].gpBounce > 0 then
			GP.cancelPound()
			player.speedY = NPC.config[v.id].gpBounce
		end
		v.data.GP_pounded = true
	end
end

local function checkRoom(id, v) -- check if it's safe to hit the block from upper
	local desiredBlocks = {}
	local bottomCollision = Block.getIntersecting(v.x, v.y + v.height, v.x + v.width, v.y + v.height + NPC.config[id].height)

	for k, blck in ipairs(bottomCollision) do
		if blck.isValid and (not Block.SEMISOLID_MAP[blck.id]) and (not Block.PLAYERSOLID_MAP[blck.id]) and (not Block.config[blck.id].passthrough) and (not blck.isHidden) and (not blck.invisible) then
			table.insert(desiredBlocks, blck)
		end
	end

	return #desiredBlocks == 0
end

local function poundBlock(v)
	local smashType = Block.config[v.id].smashable
	local eventObj = {cancelled = false}
	EventManager.callEvent("onBlockPound", eventObj, v)

	if validBlock(v) and (not eventObj.cancelled) then
		if (v.contentID > 0 and v.contentID <= 99) then -- coins
			if canHit then
				v:hit(true, player)
				SFX.play(3)
			end

			player.speedY = 10
			if not player.keys.altJump then
				GP.cancelPound()
			else
				canHit = false
			end
		elseif v.contentID >= 1001 then -- other npcs
			SFX.play(3)
			if not checkRoom(v.contentID - 1000, v) then
				player.keys.altJump = false
				GP.cancelPound()
				v:hit(false, player)
				canPoundAfterBlck = false
				player.speedY = -5 -- imagine not having this line and the content is an enemy
			else
				v:hit(true, player)
				player.speedY = 10
			end
		elseif v.contentID == 0 then -- empty
			if player.powerup == 1 then
				SFX.play(3)
				v:hit(true, player)
				if GP.turnBlocks[v.id] then
					handleSpeed()
				end
			elseif player.powerup >= 2 then
				if GP.turnBlocks[v.id] then
					v:hit(true, player)
					SFX.play(3)
					handleSpeed()
				else
					if smashType and smashType >= 2 then
						v:remove(true)
						handleSpeed()
					else
						v:hit(true, player)
					end
				end
			end
		end
	end
end

registerEvent(GP, "onStart")
registerEvent(GP, "onTick")
registerEvent(GP, "onDraw")
registerEvent(GP, "onInputUpdate")

function GP.onStart()
	spinDuration = GP.animation.spin.frames * GP.animation.spin.framespeed
	restDuration = GP.animation.poundAfter.frames * GP.animation.poundAfter.framespeed
	totalFrames = GP.animation.spin.frames + GP.animation.pound.frames + GP.animation.poundAfter.frames

	for id = 1, NPC_MAX_ID do
		NPC.config[id]:setDefaultProperty("gpBounce", 0)
	end

	for id = 1, BLOCK_MAX_ID do
		Block.config[id]:setDefaultProperty("gpStopPound", false)
	end
end

function GP.onTick()
	if player.speedY > 4 then
		belowBoxHeight = player.speedY
	else
		belowBoxHeight = 4
	end

	if belowBoxHeight > math.max(GP.poundSpeed, 32) then
		belowBoxHeight = math.max(GP.poundSpeed, 32) -- once upon a time, I saw belowBoxHeight reach 1000 pixels
	end

	bottomTouchingNPCs = NPC.getIntersecting(player.x, player.y + player.height, player.x + player.width, player.y + player.height+belowBoxHeight)
	bottomTouchingBLOCKs = Block.getIntersecting(player.x, player.y + player.height, player.x + player.width, player.y + player.height+belowBoxHeight)
	
	if GP.isPounding then
		player.keys.right = false
		player.keys.left = false
		player:mem(0x172, FIELD_BOOL, false) -- run
		player:mem(0x174, FIELD_BOOL, false) -- jump
		player:mem(0x50, FIELD_BOOL, false) -- spin jump

		if player:mem(0x48, FIELD_WORD) == 0 then
			player.keys.down = false
		end

		if player.powerup ~= 5 then
			player.keys.altRun = false
		end
		
		canPressAltJump = false
	else
		if not canPressAltJump and not player.keys.altJump then
			canPressAltJump = true
		end
	end

	if GP.isPounding and GP.state ~= GP.STATE_POUND_AFTER then
		canPressJump = false
	else
		if not canPressJump and not player.keys.jump then
			canPressJump = true
		end
	end

	if not canPressJump then
		player.keys.jump = false
	end

	if not canPressAltJump then
		player:mem(0x120, FIELD_BOOL, false)
	end

	if not canPoundAfterBlck and player.speedY <= 0 then
		canPoundAfterBlck = true
	end

	if GP.state == GP.STATE_SPIN then
		spinTimer = spinTimer + 1
		spinFrame = math.floor(spinTimer / GP.animation.spin.framespeed) % GP.animation.spin.frames
		player.speedY = -Defines.player_grav
		player.x = storedPX
		player.y = storedPY
		player.keys.up = false

		if shouldStop() then
			GP.cancelPound()
		end
	else
		spinTimer = 0
		spinFrame = 0
	end

	if GP.state == GP.STATE_POUND then
		poundTimer = poundTimer + 1
		poundFrame = math.floor(poundTimer / GP.animation.pound.framespeed) % GP.animation.pound.frames

		for k,v in ipairs(bottomTouchingNPCs) do
			poundNPC(v)
		end

		for k,v in ipairs(bottomTouchingBLOCKs) do
			poundBlock(v)

			if player:mem(0x48, FIELD_WORD) ~= 0 then
				player.keys.down = true
				player:mem(0x3C, FIELD_BOOL, true)
				player.keys.altJump = false

				if Block.SLOPE_LR_FLOOR_MAP[v.id] then
					player.speedX = -GP.slopeSpeed
				elseif Block.SLOPE_RL_FLOOR_MAP[v.id] then
					player.speedX = GP.slopeSpeed
				end
			end
		end

		if shouldStop2() then
			if isOnGround() and player:mem(0x48, FIELD_WORD) == 0 then
				GP.state = GP.STATE_POUND_AFTER
				SFX.play(GP.SFX.poundHit.id, GP.SFX.poundHit.volume)
				for i = 1, 2 do
					local dir = 1
					local offsetX = 0

					if i == 1 then
						dir = 1
						offsetX = player.width + 8
					elseif i == 2 then
						dir = 2
						offsetX = -player.width - 8
					end

					local poof = Effect.spawn(GP.effects.poof, player.x + player.width/2 + offsetX, player.y + player.height)
					poof.direction = dir
					poof.y = poof.y - poof.height/2
				end

				local stars = Effect.spawn(GP.effects.stars, player.x + player.width/2, player.y + player.height)
			else
				GP.cancelPound()
			end
		end

		if player.powerup == 4 or player.powerup == 5 then
			if noBeneathBlocks() and player:mem(0x48, FIELD_WORD) == 0 then
				player.keys.altJump = false
			end
		end

		if player.speedY < GP.poundSpeed then
			player.speedY = player.speedY + GP.yAccel
			player.keys.altJump = false -- trampolines!!
		elseif player.speedY > GP.poundSpeed then
			player.speedY = GP.poundSpeed
		end
	else
		poundTimer = 0
		poundFrame = 0

		if #bottomTouchingNPCs == 0 then
			for k, v in NPC.iterate() do
				v.data.GP_pounded = false
			end
		end
	end

	if GP.state == GP.STATE_POUND_AFTER then
		poundAfterTimer = poundAfterTimer + 1
		poundAfterFrame = math.floor(poundAfterTimer / GP.animation.poundAfter.framespeed) % GP.animation.poundAfter.frames
	
		if isOnGround() then
			if player.keys.jump == KEYS_PRESSED and GP.poundJumpEnabled then
				player.speedY = -7
				player:mem(0x11C, FIELD_WORD, GP.poundJumpHeight)
				SFX.play(GP.SFX.poundJump.id, GP.SFX.poundJump.volume)
				Routine.run(function() -- the first time I ever touched routines
					for i = 1, 4 do
						if player.speedY < 0 then
							Routine.waitFrames(3)
							local smokeEffect = Effect.spawn(GP.effects.smoke, player.x + player.width/2, player.y + player.height)
						end
					end
				end)
				GP.cancelPound()
			end
		end
	else
		poundAfterTimer = 0
		poundAfterFrame = 0
	end

	if spinTimer >= spinDuration then
		spinFrame = GP.animation.spin.frames
	end

	if spinTimer >= spinDuration + GP.animation.spin.framespeed then
		player.speedY = GP.poundSpeed
		GP.state = GP.STATE_POUND
	end

	if poundAfterTimer >= restDuration then
		poundAfterFrame = GP.animation.poundAfter.frames - 1
	end

	if poundAfterTimer >= restDuration + GP.animation.poundAfter.framespeed then
		GP.state = GP.STATE_NONE
	end

	if not canHit then
		hitTimer = hitTimer + 1
	end

	if hitTimer >= hitDelay then
		canHit = true
		hitTimer = 0
	end
end

function GP.onDraw()
	if player:mem(0x140, FIELD_WORD) ~= 0 then
		if player:mem(0x142, FIELD_BOOL) then
			playerOpacity = 1
		else
			playerOpacity = 0
		end
	else
		playerOpacity = 1
	end

	if GP.state ~= 0 then
		GP.isPounding = true
	else
		GP.isPounding = false
	end

	if GP.state == GP.STATE_POUND then
		local ps = PlayerSettings.get(pm.getCharacters()[player.character].base, player.powerup)
		player.height = ps.hitboxDuckHeight

		if not Misc.isPaused() and player.forcedState == 0 then
			player.y = player.y + ps.hitboxHeight - ps.hitboxDuckHeight
		end
	end

	if GP.isPounding then
		player:setFrame(-50 * player.direction)

		--[[if GP.images[player.character] then -- draw image
			local img = GP.images[player.character]
			local offsetY = 0
			local frame = spinFrame			

			if GP.state == GP.STATE_SPIN then
				offsetY = 0
				frame = spinFrame
			elseif GP.state == GP.STATE_POUND then
				offsetY = GP.animation.spin.frames
				frame = poundFrame
			elseif GP.state == GP.STATE_POUND_AFTER then
				offsetY = GP.animation.spin.frames + GP.animation.pound.frames
				frame = poundAfterFrame
			end

			Graphics.drawBox{
				texture = img, x = player.x+player.width/2 + GP.GFXoffsetX, y = player.y+player.height/2 + bonkOffset + GP.GFXoffsetY,
				width = 100*player.direction, height = 100,
				sourceX = 100*(player.powerup-1), sourceY = (offsetY + frame)*100,
				sourceWidth = 100, sourceHeight = 100,
				centered = true, sceneCoords = true, priority = -25, color = Color.white .. playerOpacity,
			}]]
		if GP.playerFrames[player.character] then -- set frames
			local frame = GP.playerFrames[player.character][1][spinFrame + 1]

			if GP.state == GP.STATE_SPIN then
				frame = GP.playerFrames[player.character][1][spinFrame + 1]
			elseif GP.state == GP.STATE_POUND then
				frame = GP.playerFrames[player.character][2][poundFrame + 1]
			elseif GP.state == GP.STATE_POUND_AFTER then
				frame = GP.playerFrames[player.character][3][poundAfterFrame + 1]
			end

			player:render{x = player.x + GP.GFXoffsetX, y = player.y + bonkOffset + GP.GFXoffsetY, frame = frame}
		end
	end

	if GP.state == GP.STATE_POUND and bottomTouchingBLOCKs then
		for k,v in ipairs(bottomTouchingBLOCKs) do
			local bonkingOffset = v:mem(0x56, FIELD_WORD)

			if validBlock(v) and (v.contentID > 0) then
				bonkOffset = bonkingOffset
			else
				bonkOffset = 0
			end

			if validBlock(v) then
				if GP.turnBlocks[v.id] then
					poundingTurnBlocks = true
				else
					poundingTurnBlocks = false
				end
			end
		end
	else
		poundingTurnBlocks = false
	end
end

function GP.onInputUpdate()
	if player.keys.up == KEYS_PRESSED and not player.keys.altJump then
		if GP.state == GP.STATE_POUND then
			GP.cancelPound()
		end
	end

	if player.keys.altJump == KEYS_PRESSED and player.keys.down and not player.keys.up then
		if canPound() and not GP.isPounding then
			GP.startPound()
		end
	end
end

return GP