--[[
wario.lua
v1.2.1
Remade practically from scratch by arabslmon/ohmato, 2016
Original (the awful one) by Horikawa Otane
And then Enjl took the shop out.
(And then Saturnyoshi made it work again, and added HDOverride stuff)
And then Enjl attempted to make the character more playable

Things to do:
]]

local colliders = require("colliders")
local rng = require("rng")
local pm = require("playerManager")
local expandedDefines = require("expandedDefines")
local wario = {}

local chars = pm.getCharacters();

-- Debug variables
local debugmode = false
if debugmode then mem(0x00B2C5AC, FIELD_FLOAT, 3) end

local fx_groundpound = pm.registerGraphic(CHARACTER_WARIO, "poundFX.png")
local fx_charge = {
	[-1] = pm.registerGraphic(CHARACTER_WARIO, "chargeFXL.png"),
	[1] = pm.registerGraphic(CHARACTER_WARIO, "chargeFXR.png")
}

-- Graphical/audio assets
local HUD = {
	stars 	= pm.registerGraphic(CHARACTER_WARIO, "HUD\\wario_stars.png"),
	lives 	= pm.registerGraphic(CHARACTER_WARIO, "HUD\\wario_lives.png"),
	meter 	= pm.registerGraphic(CHARACTER_WARIO, "HUD\\HUD_meter.png")
}

local function drawFX(effect, offset)
	local img = pm.getGraphic(CHARACTER_WARIO,  effect)
	local h = img.height / 3
	
	Graphics.drawImageToSceneWP(
		img,
		player.x + 0.5 * player.width + offset.x,
		player.y + 0.5 * player.height + offset.y,
		0,
		h * (math.floor(lunatime.tick() * 0.25) % 3),
		img.width,
		h,
		-25
	)
end

local sfx = {
	footstep = {}
}
for i = 1,3 do sfx.footstep[i] = pm.registerSound(CHARACTER_WARIO, "wario_footstep"..tostring(i)..".ogg") end

local itembox = pm.registerGraphic(CHARACTER_WARIO, "itembox.png")

-- Dash-associated variables
local dashtimer = 0			-- Aggregate timer for dashing
local dashing = false		-- Is the player currently dashing?
local DASHCHARGETIME = 24	-- Dash length
local DASHSPEED = 8			-- Speed while dashing
local DASHACCEL = 4         -- Acceleration to top speed while dashing
local lockedDirection = 0

-- Crawling-associated variables
local crawling = false		-- Is the player currently crawling?
local ducking = false		-- Is the player currently ducking?
local CRAWLSPEED = 2		-- Speed while crawling
local crawltimer = 0		-- Timer for crawl frames

local isGroundPounding = false

function wario.onInitAPI()
	registerEvent(wario, "onInputUpdate", "onInputUpdate", false)
	registerEvent(wario, "onNPCKill")
	registerEvent(wario, "onTick", "onTick", false)
	registerEvent(wario, "onDraw")
	registerEvent(wario, "onTickEnd", "DebugDraw")
end


-- Input management for store UI and dashing
function wario.onInputUpdate()
	-- If the player is Wario
	if player.character == CHARACTER_WARIO then
		if Misc.isPaused() then return end
		pm.winStateCheck()
		-- Increase the dash timer when running on the ground
		if player.powerup > 1 then
			if not isGroundPounding then
				if player.keys.altRun == KEYS_PRESSED and player.forcedState == 0 and dashtimer == 0 then
					if player:isGroundTouching() then dashtimer = DASHCHARGETIME end
					lockedDirection = player.direction
				end
				if player.keys.altJump == KEYS_PRESSED then
					if ducking then
						player.jumpKeyPressing = true
						player.keys.altJump = nil
					else
						if not player:mem(0x36, FIELD_BOOL) and player.mount == 0 then
							if player:isGroundTouching() or ducking or crawling then
								player.keys.altJump = nil
								player.jumpKeyPressing = true
							else
								lockedDirection = player.direction
								isGroundPounding = true
								player.speedY = -4
							end
						end
					end
				end
			else
				if player.keys.altJump == KEYS_PRESSED then
					isGroundPounding = false
				end
			end
		end
		-- If holding something or on a mount, prevent dashing
		if player:mem(0x154, FIELD_WORD) ~= 0 or player:mem(0x108, FIELD_WORD) ~= 0 then dashtimer = 0 end
	end
end


-- Determines value of a coin NPC
local function coinval(id)
	if id == 152 or id == 88 or id == 138 or id == 10 or id == 33 or id == 251 or id == 274 then
										return 1
	elseif id == 103 then 				return 2
	elseif id == 252 or id == 258 then 	return 5
	elseif id == 253 then 				return 20
	else 								return 0
	end
end

-- Checks if an NPC is onscreen
local function onscreen(npc)
	-- Get camera boundaries
	local left = camera.x;		local right = left + camera.width;
	local top = camera.y;		local bottom = top + camera.height;
	-- Check if offscreen
	if npc.x + npc.width < left or npc.x > right then return false
	elseif npc.y + npc.height < top or npc.y > bottom then return false
	else return true end
end

-- Spawn coins when killing an enemy, coin counter management, and monitor Lakitu helper crates
function wario.onNPCKill(eventObj, killedNPC, killReason)
	-- If the player is Wario
	if player.character == CHARACTER_WARIO then
		-- If the player kills an enemy, drop some coins (ignore death of projectiles, powerups, in lava, an iceball, or egg)
		if killReason <= 8 and killReason ~= 6 and killReason ~= 4 and NPC.HITTABLE_MAP[killedNPC.id] then
			for i = 1, NPC.config[killedNPC.id].score do
				local coin = NPC.spawn(10, killedNPC.x + 0.5 * killedNPC.width, killedNPC.y + 0.5 * killedNPC.height, player.section, false, true)
				coin.speedX = rng.random(-2,2)
				coin.speedY = rng.random(-4)
				coin.ai1 = 1
				killedNPC:mem(0x74, FIELD_WORD, -1)
			end
		end
	end
end


-- Initialization and cleanup of Wario character data
function wario.initCharacter()	
	-- Make Wario "heavier"
	Defines.player_runspeed = 4
	Defines.player_walkspeed = 2
	Defines.jumpheight = 18
	Defines.jumpheight_bounce = 18
	
	-- Adjust size of player-thrown fireball/iceball graphic
	NPC.config[13].gfxwidth = 32;	NPC.config[265].gfxwidth = 32;
	NPC.config[13].gfxheight = 32;	NPC.config[265].gfxheight = 32;
	NPC.config[13].height = 32;		NPC.config[265].height = 32;
	NPC.config[13].width = 32;		NPC.config[265].width = 32;
end

function wario.cleanupCharacter()
	
	-- Return physics to normal
	Defines.player_runspeed = nil
	Defines.player_walkspeed = nil
	Defines.jumpheight = nil
	Defines.jumpheight_bounce = nil
	
	-- Reset grabbing ability
	Defines.player_grabSideEnabled = nil
	Defines.player_grabShellEnabled = nil
	
	-- Reset dimensions for player-thrown fireball/iceball
	NPC.config[13].gfxwidth = 16;	NPC.config[265].gfxwidth = 16;
	NPC.config[13].gfxheight = 16;	NPC.config[265].gfxheight = 16;
	NPC.config[13].height = 16;		NPC.config[265].height = 16;
	NPC.config[13].width = 16;		NPC.config[265].width = 16;
end

-- Render dash charge meter
local function renderDashMeter(xpos, ypos)
	Graphics.draw {x = xpos, y = ypos, type = RTYPE_IMAGE, priority = -5, image = pm.getGraphic(CHARACTER_WARIO, HUD.meter), sourceHeight = 18}
	if dashtimer < DASHCHARGETIME then
		Graphics.draw {x = xpos, y = ypos, type = RTYPE_IMAGE, priority = -5, image = pm.getGraphic(CHARACTER_WARIO, HUD.meter),
			sourceY = 18, sourceWidth = 10*math.floor(dashtimer/DASHCHARGETIME*8), sourceHeight = 18}
	else
		Graphics.draw {x = xpos, y = ypos, type = RTYPE_IMAGE, priority = -5, image = pm.getGraphic(CHARACTER_WARIO, HUD.meter),
			sourceY = 18, sourceWidth = 70, sourceHeight = 18}
		if math.floor(lunatime.tick()*10)%2 == 0 then
			Graphics.draw {x = xpos + 70, y = ypos, type = RTYPE_IMAGE, priority = -5, image =pm.getGraphic(CHARACTER_WARIO,  HUD.meter),
				sourceX = 70, sourceY = 18, sourceWidth = 26, sourceHeight = 18}
		end
	end
end

-- Set up HUD
local function drawHudElements(playerIdx, camObj, playerObj, priority, isSplit, playerCount)
	--renderDashMeter(camObj.width / 2 - 48, 72)
end

Graphics.registerCharacterHUD(CHARACTER_WARIO, Graphics.HUD_ITEMBOX, drawHudElements, 
{ 	
	reserveBox2P = itembox,
	lives = HUD.lives,
	stars = HUD.stars,
})

-- Per-frame logic
function wario.onTick()
	-- If the player is Wario
	if player.character ~= CHARACTER_WARIO then return end

	-- Cap run/walk speed
	if dashtimer == 0 then
		Defines.player_runspeed = 4
		Defines.player_walkspeed = 4
		Defines.player_grabSideEnabled = true
		Defines.player_grabShellEnabled = true
	else
		Defines.player_runspeed = DASHSPEED
		Defines.player_walkspeed = DASHSPEED
		Defines.player_grabSideEnabled = false
		Defines.player_grabShellEnabled = false
	end

	if player:mem(0x40, FIELD_WORD) > 0 or player:mem(0x36, FIELD_WORD) > 0 then
		player.jumpKeyPressing = player.jumpKeyPressing or player.altJumpKeyPressing
		player.keys.altJump = nil
	end
	
	-- Dash mechanic
	if isGroundPounding then
		player:mem(0x164, FIELD_WORD, 0)
		player.leftKeyPressing = false
		player.rightKeyPressing = false
		player.altRunKeyPressing = false
		player.runKeyPressing = true
		player.downKeyPressing = false
		player.speedX = 0
	
		Defines.gravity = 13
		Defines.player_grav = 0.8

		if player:mem(0x40, FIELD_WORD) > 0 or player:mem(0x36, FIELD_BOOL) then
			isGroundPounding = false
			Defines.gravity = 12
			Defines.player_grav = 0.4
		end
		
		if player:isGroundTouching() then
			isGroundPounding = false
			Defines.earthquake = 4
			player.speedY = -4
			Defines.gravity = 12
			Defines.player_grav = 0.4
			playSFX(37)
		end
		if player.speedY > 0 then
			drawFX(fx_groundpound, {x = -41, y = -16})
		
		
			for _,block in ipairs(Block.getIntersecting(player.x, player.y + player.height, player.x + player.width, player.y + player.height + 14)) do
					-- If block is visible
					if block.isHidden == false and block:mem(0x5a, FIELD_WORD) == 0 then
						-- If the block should be broken, destroy it
						if expandedDefines.BLOCK_MEGA_SMASH_MAP[block.id] then
							if block.contentID > 0 then
								block:hit(true, player)
							else
								block:remove(true)
							end
						elseif expandedDefines.BLOCK_MEGA_HIT_MAP[block.id] then
							block:hit(true, player)
							isGroundPounding = false
							Defines.earthquake = 4
							player.speedY = -4
							playSFX(37)
							Defines.gravity = 12
							Defines.player_grav = 0.4
						elseif (expandedDefines.BLOCK_SOLID_MAP[block.id] or (expandedDefines.BLOCK_SEMISOLID_MAP[block.id] and player.y + player.height <= block.y + 4) or expandedDefines.BLOCK_PLAYERSOLID_MAP[block.id]) and not expandedDefines.BLOCK_SLOPE_MAP[block.id] then
							block:hit(true, player)
							isGroundPounding = false
							Defines.earthquake = 4
							player.speedY = -4
							Defines.gravity = 12
							Defines.player_grav = 0.4
							playSFX(37)
						end
					end
			end
		end
		for _, npc in ipairs(NPC.getIntersecting(player.x, player.y + player.height, player.x + player.width, player.y + player.height + 10)) do
			if NPC.HITTABLE_MAP[npc.id] and (not NPC.config[npc.id].jumphurt) and (not npc.friendly) and npc:mem(0x12A, FIELD_WORD) > 0 and (not npc:mem(0x64, FIELD_BOOL)) and not (npc:mem(0x138, FIELD_WORD) > 0) and not (npc:mem(0x12C, FIELD_WORD) > 0) then
				npc:kill(8)
				colliders.bounceResponse(player)
				isGroundPounding = false
			end
		end
	else
		Defines.gravity = 12
		Defines.player_grav = 0.4
	end
	if dashtimer > 0 then
		player:mem(0x164, FIELD_WORD, 0)
		player.leftKeyPressing = false
		player.rightKeyPressing = false
		player.runKeyPressing = true
		player.downKeyPressing = false
		if (not player.altRunKeyPressing) or player:mem(0x40, FIELD_WORD) > 0 then
			dashtimer = 0
			lockedDirection = 0
		end

		if dashtimer == 1 then
			-- Increase speed
			player.direction = lockedDirection
			if lockedDirection == 1 then
				player.speedX = math.min(player.speedX + DASHACCEL, DASHSPEED)
			else
				player.speedX = math.max(player.speedX - DASHACCEL, -DASHSPEED)
			end
			
			-- Destroy blocks when dashing
			local left = 0; local right = 0
			local top = player.y + 2
			local bottom = player.y + player.height - 2
			if lockedDirection < 0 then
				right = player.x
				left = right + player.speedX
			elseif lockedDirection > 0 then
				left = player.x + player.width
				right = left + player.speedX
			end
			for _,block in ipairs(Block.getIntersecting(left, top, right, bottom)) do
				-- If block is visible
				if block.isHidden == false and block:mem(0x5a, FIELD_WORD) == 0 then
					-- If the block should be broken, destroy it
					if expandedDefines.BLOCK_MEGA_SMASH_MAP[block.id] then
						if block.contentID > 0 then
							block:hit(false, player)
						else
							block:remove(true)
						end
					elseif expandedDefines.BLOCK_MEGA_HIT_MAP[block.id] then
						block:hit(true, player)
						dashtimer = 0
						player.speedX = -2 * lockedDirection
						player.speedY = -5
					end
				end
			end
			
			for _, npc in ipairs(NPC.getIntersecting(left, top, right, bottom)) do
				if NPC.HITTABLE_MAP[npc.id] and (not npc.friendly) and npc:mem(0x12A, FIELD_WORD) > 0 and (not npc:mem(0x64, FIELD_BOOL)) and not (npc:mem(0x138, FIELD_WORD) > 0) and not (npc:mem(0x12C, FIELD_WORD) > 0) then
					npc:harm(3)
					dashtimer = 0
					player.speedX = -2 * lockedDirection
					player.speedY = -5
				end
			end
			if player:mem(0x148, FIELD_WORD) ~= 0 or player:mem(0x14C, FIELD_WORD) ~= 0 then
				dashtimer = 0
				for k,v in ipairs(Block.getIntersecting(left, top, right, bottom)) do
					v:hit(false, player)
					dashtimer = 0
					player.speedX = -2 * lockedDirection
					player.speedY = -5
					Defines.earthquake = 4
					playSFX(37)
				end
			end
			
			-- Visual effects if touching ground
			if player:isGroundTouching() then
				Animation.spawn(74, player.x + rng.random(player.width/2) + 4 + player.speedX, player.y + player.height + rng.random(-4, 4) - 4)
			end
		elseif dashtimer > 0 then
			dashtimer = dashtimer - 1
		end
	end

	if ducking then
		local ps = PlayerSettings.get(chars[player.character].base, player.powerup);
		local h = ps.hitboxHeight;

		local speedXMod = 0
		if player.leftKeyPressing then speedXMod = -CRAWLSPEED
		elseif player.rightKeyPressing then speedXMod = CRAWLSPEED
		end
		player.keys.altJump = nil

		local overheadBlocks = Block.getIntersecting(player.x + speedXMod, player.y + player.height - h, player.x + player.width + speedXMod, player.y)
		for k,v in ipairs(overheadBlocks) do
			if Block.SOLID_MAP[v.id] and (not v.isHidden) and v:mem(0x5A, FIELD_WORD) == 0 then
				player:mem(0x12e, FIELD_WORD, -1)
				player.downKeyPressing = true
				break
			end
		end
	end
	
	-- Crawling
	crawling = false
	ducking = false
	if player:mem(0x12e, FIELD_WORD) == -1 and player.downKeyPressing and player:mem(0x108, FIELD_WORD) == 0 then
		dashtimer = 0
		if player:isGroundTouching() then
			player.speedX = player.speedX * 0.95
			if player.leftKeyPressing then
				player.speedX = -CRAWLSPEED
				crawling = true
			elseif player.rightKeyPressing then
				player.speedX = CRAWLSPEED
				crawling = true
			end
		end
		ducking = true
	end

	if player:mem(0x122, FIELD_WORD) > 0 then
		dashtimer = 0
		crawling = false
		ducking = false
		isGroundPounding = false
	end

	if player.powerup == 1 then
		dashtimer = 0
		crawling = false
		ducking = false
		if player.mount == 0 then
			player.jumpKeyPressing = player.jumpKeyPressing or player.altJumpKeyPressing
			player.keys.altJump = nil
		end
		isGroundPounding = false
	end
end

function wario.onDraw()
	if player.character ~= CHARACTER_WARIO then return end

	if isGroundPounding and  player.speedY > 0 then
		drawFX(fx_groundpound, {x = -41, y = -16})
	end

	if dashtimer ~= 1 then return end
	drawFX(fx_charge[lockedDirection], {x = -29 + 0.6 * player.width * lockedDirection, y = -40})
end


-- Debug drawing, for showing hitboxes in debug mode
local function DrawRect(x1, y1, x2, y2, clr)
	x1 = x1 - camera.x
	y1 = y1 - camera.y
	x2 = x2 - camera.x
	y2 = y2 - camera.y

	left = {
		x1,y1, x1+1,y1, x1+1,y2,
		x1,y1, x1,y2, x1+1,y2
	}
	right = {
		x2-1,y1, x2,y1, x2,y2,
		x2-1,y1, x2-1,y2, x2,y2
	}
	top = {
		x1,y1, x2,y1, x2,y1+1,
		x1,y1, x1,y1+1, x2,y1+1
	}
	bottom = {
		x1,y2-1, x2,y2-1, x2,y2,
		x1,y2-1, x1,y2, x2,y2
	}
	
	Graphics.glDraw {vertexCoords = left, color = clr}
	Graphics.glDraw {vertexCoords = right, color = clr}
	Graphics.glDraw {vertexCoords = top, color = clr}
	Graphics.glDraw {vertexCoords = bottom, color = clr}
end
function wario.DebugDraw()
	
	-- If the player is Wario
	if player.character == CHARACTER_WARIO then
		-- Show dashing frames when dashing and not on a mount
		if isGroundPounding then
			player.frame = 30
		end
		if dashtimer > 0 and player:mem(0x108, FIELD_WORD) == 0 then
			player:mem(0x114, FIELD_WORD, 32 + math.floor(lunatime.tick()*0.2)%2)
			if not player:isGroundTouching() then player:mem(0x114, FIELD_WORD, 33) end
			if player:isGroundTouching() and (lunatime.tick())%8 == 0 then Audio.SfxPlayCh(-1, Audio.SfxOpen(pm.getSound(CHARACTER_WARIO, rng.irandomEntry(sfx.footstep))), 0) end
		end
		
		-- Show crawling frames
		if crawling then
			if crawltimer < 10 then player:mem(0x114, FIELD_WORD, 22)
			elseif crawltimer < 10*2 then player:mem(0x114, FIELD_WORD, 23)
			else
				crawltimer = 0
				player:mem(0x114, FIELD_WORD, 22)
			end
			crawltimer = crawltimer + 1
		else crawltimer = 0 end
	end

	if debugmode and Graphics.isOpenGLEnabled() then
		DrawRect(player.x, player.y, player.x + player.width, player.y + player.height, {0,1,0})
	end
	--colliders.getHitbox(player):Draw(0xff00007f)
end

return wario














