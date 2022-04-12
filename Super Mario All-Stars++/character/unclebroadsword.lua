--[[
	Uncle Broadsword API
	v1.1.0
	Created by Ohmato/Arabsalmon
	
THINGS TO DO (Please list any bugs/suggestions here):
	-- Expose sword colliders (ON HOLD - WAITING FOR STANDARDIZATION)
]]


local colliders = require("colliders")
local rng = require("rng")
local pm = require("playerManager")
local blockutils = require("blocks/blockutils")

local unclebroadsword = {}

unclebroadsword.debugMode = false

local inputBlockingForcedStates = table.map{
	FORCEDSTATE_POWERUP_BIG,
	FORCEDSTATE_POWERDOWN_SMALL,
	FORCEDSTATE_PIPE,
	FORCEDSTATE_POWERUP_FIRE,
	FORCEDSTATE_POWERUP_LEAF,
	FORCEDSTATE_RESPAWN,
	--FORCEDSTATE_DOOR, clear pipes use this
	FORCEDSTATE_INVISIBLE,
	FORCEDSTATE_ONTONGUE,
	FORCEDSTATE_SWALLOWED,
	FORCEDSTATE_POWERUP_TANOOKI,
	FORCEDSTATE_POWERUP_HAMMER,
	FORCEDSTATE_POWERUP_ICE,
	FORCEDSTATE_POWERDOWN_FIRE,
	FORCEDSTATE_POWERDOWN_ICE,
	FORCEDSTATE_MEGASHROOM,
	FORCEDSTATE_TANOOKI_POOF,
}


-- Graphics/Audio Loading --------------------------------------------------------------------
local sfx = {
	drop = 	pm.registerSound(CHARACTER_UNCLEBROADSWORD, "ub_drop.wav"),
	knife = pm.registerSound(CHARACTER_UNCLEBROADSWORD, "ub_knife.wav"),
	lunge = pm.registerSound(CHARACTER_UNCLEBROADSWORD, "ub_lunge.wav"),
	swipe = pm.registerSound(CHARACTER_UNCLEBROADSWORD, "ub_swipe.wav"),
	charging = pm.registerSound(CHARACTER_UNCLEBROADSWORD, "ub_charging.wav")
}
local deathFX_left	= pm.registerGraphic(CHARACTER_UNCLEBROADSWORD, "dead_left.png")
local deathFX_right = pm.registerGraphic(CHARACTER_UNCLEBROADSWORD, "dead_right.png")
local afterimage	= pm.registerGraphic(CHARACTER_UNCLEBROADSWORD, "afterimage.png")
local statue_img	= pm.registerGraphic(CHARACTER_UNCLEBROADSWORD, "statue_img.png")
local itembox		= pm.registerGraphic(CHARACTER_UNCLEBROADSWORD, "itembox.png")
local afterimagepos = {}			-- Positions for stall-and-fall afterimages	
local charge_sfxobj	= nil			-- SFX channel for charging sound effect

Graphics.registerCharacterHUD(CHARACTER_UNCLEBROADSWORD, Graphics.HUD_ITEMBOX, nil, 
	{ 
		reserveBox = itembox, 
		reserveBox2P = itembox
	})

-- Attack logic ------------------------------------------------------------------------------
unclebroadsword.swordCollider = nil	-- Sword hitbox

local ATKSTATE = {					-- Possible sword swipe states
	COOLDOWN = -6,					-- Recovery period, cannot swing sword
	CHARGED = -5,					-- Ready to release charged lunge
	CHARGING = -4,					-- Currently charging lunge
	STALLED = -3,					-- Can't move after stall-and-fall
	PAUSE2 = -2,					-- Pause after upward swipe
	PAUSE1 = -1,					-- Pause after downward swipe
	NONE = 0,						-- Ready to attack
	SWIPE1 = 1,						-- Upward swipe
	SWIPE2 = 2,						-- Downward swipe
	LUNGE_COMBO = 3,				-- Combo lunging after two swipes
	LUNGE_CHARGE = 4,				-- Performing charged lunge
	UPWARDSTAB = 5,					-- Stabbing upward (in air)
	STALLANDFALL = 6,				-- Stall-and-fall
	STATUEFALL = 7					-- Falling as statue
}

unclebroadsword.attackState = ATKSTATE.NONE	        -- Current attack state
local queue_state = ATKSTATE.NONE	                -- Next attack state to assign if already in the middle of one
local attack_timer = 0				                -- Timer for managing attack state
local can_aerial = true				                -- Can an aerial swipe be performed?
local can_stallnfall = true			                -- Can a stall-and-fall be performed?
local charge_timer = 0				                -- Timer for charging lunge
local charge_fraction = 0			                -- Fraction of the charge meter filled before a charged lunge
local doublejump_ready = true		                -- Is a double jump available?
local aerial_atk_stall = false		                -- Should the player stall in the air when swiping?


-- Attack configuration ----------------------------------------------------------------------
local DURATION = {					-- Frame durations for attack state
	[ATKSTATE.CHARGING] =		70,	-- Time required to fully charge a lunge
	[ATKSTATE.STALLED] = 		24,	-- Time after a stall-and-fall during which input is blocked
	[ATKSTATE.PAUSE1] =			12,	-- Pause length between swipes
	[ATKSTATE.PAUSE2] =			12, 
	[ATKSTATE.COOLDOWN] =		3,	-- Time required after attacking before you can attack again
	[ATKSTATE.SWIPE1] =			2,	-- (x3)
	[ATKSTATE.SWIPE2] =			2,	-- (x3)
	[ATKSTATE.LUNGE_COMBO] =	30,	-- Time required to perform a full combo lunge
	[ATKSTATE.LUNGE_CHARGE] =	40	-- Time required to perform a full charged lunge
}
local LUNGEDIST_COMBO = 256			-- Distance travelled during a combo lunge
local LUNGEDIST_CHARGE = 192		-- Distance travelled during a charged lunge
local LUNGELAG_COMBO = 10			-- Frames of end lag after a combo lunge
local LUNGELAG_CHARGE = 25			-- Frames of end lag after a charged lunge
local CHARGING_SOUND_DURATION = 44	-- Duration of "charging" sound effect		===== DO NOT CHANGE =====
local FALLSPEED = 40				-- Maximum speed of stall-and-fall
local AFTERIMAGE_COUNT = 5			-- How many afterimages does the stall-and-falla leave?
local SWIPE_WIDTH = 38				-- Width of swipe hitbox
local SWIPE_HEIGHT = 28				-- Height of swipe hitbox
local LUNGE_WIDTH = 40				-- Width of lunge hitbox
local LUNGE_HEIGHT = 20				-- Height of lunge hitbox
local UDSTAB_WIDTH = 16				-- Width of up/downstab hitbox
local UDSTAB_HEIGHT = 20			-- Height of up/downstab hitbox


-- Player states -----------------------------------------------------------------------------
local function ducking_ext()
	-- Ignore if not holding down
	if not player.downKeyPressing then return false end
	
	-- Check if dead
	if player:mem(0x13e, FIELD_WORD) > 0 then return false end
	-- Check if submerged and standing on the ground
	if (player:mem(0x34, FIELD_WORD) ~= 0 or player:mem(0x36, FIELD_WORD) ~= 0)
	and not player:isGroundTouching() then return false end
	-- Check if on a slope and not underwater
	if player:mem(0x48, FIELD_WORD) ~= 0 and player:mem(0x36, FIELD_WORD) == 0 then return false end
	-- Check if sliding, climbing, holding an item, in statue form, or spinjumping
	if player:mem(0x3c, FIELD_WORD) ~= 0
	or player:mem(0x40, FIELD_WORD) ~= 0
	or player:mem(0x154, FIELD_WORD) > 0
	or player:mem(0x4a, FIELD_WORD) == -1
	or player:mem(0x50, FIELD_WORD) ~= 0 then return false end
	-- Check if in a forced animation
	if player.forcedState == 1	-- Powering up
	or player.forcedState == 2	-- Powering down
	or player.forcedState == 3	-- Entering pipe
	or player.forcedState == 4	-- Getting fire flower
	or player.forcedState == 7	-- Entering door
	or player.forcedState == 41	-- Getting ice flower
	or player.forcedState == 500 then return false end
	
	return true
end
local function ducking()			-- In ducking state
	if player.powerup == PLAYER_SMALL then
		return ducking_ext()
	else
		return (player:mem(0x12e, FIELD_WORD) ~= 0)
	end
end
local function submerged()			-- In quicksand or water
return (player:mem(0x34, FIELD_WORD) ~= 0 or player:mem(0x36, FIELD_WORD) ~= 0) end
local function sliding()			-- Sliding down slope
return (player:mem(0x3c, FIELD_WORD) ~= 0) end
local function climbing()			-- Climbing ladder/fence
return (player:mem(0x40, FIELD_WORD) ~= 0) end
local function spinjumping()		-- Spinjumping
return (player:mem(0x50, FIELD_WORD) ~= 0) end
local function mounted()			-- On a mount
return (player:mem(0x108, FIELD_WORD) > 0) end
local function holding()			-- Holding an object
return (player:mem(0x154, FIELD_WORD) > 0) end
local function grounded()			-- Touching solid ground
return player:isGroundTouching(); end
local function pickingup()			-- Currently picking something up
return (player:mem(0x26, FIELD_WORD) > 0) end
local function standing()			-- On the ground, not ducking, not on a mount, and not sliding
return (not ducking() and grounded() and player:mem(0x108, FIELD_WORD) == 0 and player:mem(0x3c, FIELD_WORD) == 0) end
local function airborne()			-- In the air and not ducking
return not (grounded() or submerged() or climbing()) end
local function inforcedanim()		-- In a forced animation
return (player.forcedState ~= 0) end
local function statued()			-- In tanooki statue form
return (player:mem(0x4a, FIELD_WORD) == -1) end
local function warping()
return (player.forcedState == 3) end
local is_hurt = false				-- Has the player just been hurt?
local knockback = true				-- Should knockback be delivered?


-- Entity typing -----------------------------------------------------------------------------
local BLOCK_PLAYERSWITCH = {622,623,624,625,631,639,641,643,645,647,649,651,653,655,657,659,661,663}
local BLOCK_BRICK = {4,60,188,226,293, 90}
local BLOCK_BOUNCY = {55, 682}
local NPC_BONUS = {10,33,88,103,138,152,240,248,251,252,253,258,274}
local NPC_POWERUP = {9,14,34,90,153,169,170,182,183,184,185,186,187,188,249,250,254,264,273,277,287,287,293}
local NPC_CARRYABLETOOL = {22,26,31,45,49,92,139,140,141,142,143,144,145,146,147,154,155,156,157,158,159,179,195,241,278} -- Does not include Mouser's bomb
local NPC_BOUNCY = {26}
local function isType(id, idtable)
	for _, val in ipairs(idtable) do
		if id == val then return true end
	end
	return false
end


-- PLAYER_SMALL frame management -------------------------------------------------------------
local holding_frames = {9,8,9,10}	-- Frames to display when holding an item
local holding_frame_timer = 1		-- Frame timer for holding frames
local holding_frame_index = 1		-- Current holding frame to display

local walking_frames = {2,1,2,3}	-- Frames to display when walking/running
local walking_frame_timer = 1		-- Frame timer for walking/running frames
local walking_frame_index = 1		-- Current walking/running frame to display
local running_durations = {1,2,2}	-- Frame durations to use when approaching running speed
local running_duration_index = 1	-- Current frame duration to use when running
----------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------- INPUT MANAGEMENT --------------------------------

local bufferedInputs = {"jump", "altJump"}
local inputBuffer = {}

local function BlockMovement() -------------------------------------------------------------------- Block arrow movement and jumping
	--player.upKeyPressing = false
	if is_hurt or (not ducking() and not airborne()) then player.downKeyPressing = false end
	for k,v in ipairs(bufferedInputs) do
		inputBuffer[v] = player.keys[v]
	end
	player.leftKeyPressing = false
	player.rightKeyPressing = false
	player.jumpKeyPressing = false
	player.altJumpKeyPressing = false
	player.altRunKeyPressing = false
end

local function RemoveInputBuffer()
	for k,v in ipairs(bufferedInputs) do
		if inputBuffer[v] then
			if player.keys[v] then
				player.keys[v] = KEYS_UP
				player[v .. "KeyPressing"] = false
			else
				inputBuffer[v] = false
			end
		end
	end
end

function unclebroadsword.getAttackState()
	return unclebroadsword.attackState
end

local function SetCooldown() ---------------------------------------------------------------------- Sets cooldown state
	unclebroadsword.attackState = ATKSTATE.COOLDOWN
	attack_timer = DURATION[ATKSTATE.COOLDOWN]
end

function unclebroadsword.onInputUpdate()
	if player.character == CHARACTER_UNCLEBROADSWORD then
		pm.winStateCheck()
		if player.keys.jump == KEYS_PRESSED and not (is_hurt or statued()) then
			-- Prevent attacking when submerged, sliding, climbing, spinjumping, mounted, holding, or picking up something
			if inforcedanim() or submerged() or sliding() or climbing() or spinjumping() or mounted() or holding() or pickingup() then return end
			-- Prevent attacking in air if you already have
			if airborne() and not can_aerial then return end
			-- Alter attack combo state
			if unclebroadsword.attackState == ATKSTATE.NONE	then
				unclebroadsword.attackState = ATKSTATE.SWIPE1				-- Swipe upward
				attack_timer = DURATION[ATKSTATE.SWIPE1]*3
				Audio.SfxPlayCh(-1, Audio.SfxOpen(pm.getSound(CHARACTER_UNCLEBROADSWORD, sfx.swipe)), 0)
			elseif	unclebroadsword.attackState == ATKSTATE.SWIPE1 and attack_timer <= DURATION[ATKSTATE.SWIPE1]*3/2 then
				queue_state = ATKSTATE.SWIPE2				-- Queue up second swipe if during first swipe
			elseif	unclebroadsword.attackState == ATKSTATE.PAUSE1	then
				unclebroadsword.attackState = ATKSTATE.SWIPE2				-- Swipe downward
				attack_timer = DURATION[ATKSTATE.SWIPE2]*3
				Audio.SfxPlayCh(-1, Audio.SfxOpen(pm.getSound(CHARACTER_UNCLEBROADSWORD, sfx.swipe)), 0)
			elseif	unclebroadsword.attackState == ATKSTATE.SWIPE2 and attack_timer <= DURATION[ATKSTATE.SWIPE2]*3/2 and not ducking() and player.powerup > PLAYER_SMALL then
				queue_state = ATKSTATE.LUNGE_COMBO			-- Queue up combo lunge if during second swipe
			elseif	unclebroadsword.attackState == ATKSTATE.PAUSE2 and not ducking() and player.powerup > PLAYER_SMALL then
				unclebroadsword.attackState = ATKSTATE.LUNGE_COMBO			-- Combo lunge forward
				attack_timer = DURATION[ATKSTATE.LUNGE_COMBO] + LUNGELAG_COMBO
				Audio.SfxPlayCh(-1, Audio.SfxOpen(pm.getSound(CHARACTER_UNCLEBROADSWORD, sfx.lunge)), 0)
			end
		-- Stall-and-fall
		elseif player.keys.down == KEYS_PRESSED and player.powerup > PLAYER_SMALL and airborne() and can_stallnfall then
			unclebroadsword.attackState = ATKSTATE.STALLANDFALL
			can_stallnfall = false
		-- Cancel charge when moving
		elseif player.keys.left == KEYS_PRESSED or player.keys.right == KEYS_PRESSED and (unclebroadsword.attackState == ATKSTATE.CHARGING or unclebroadsword.attackState == ATKSTATE.CHARGED) then
			SetCooldown()
		-- Falling statue
		elseif player.powerup == PLAYER_TANOOKIE and player.keys.run == KEYS_PRESSED and not grounded() and not mounted() then
			unclebroadsword.attackState = ATKSTATE.STATUEFALL
			can_stallnfall = false
		-- Double jump
		elseif (player.powerup == PLAYER_LEAF or player.powerup == PLAYER_TANOOKIE) and player.keys.jump == KEYS_PRESSED or player.keys.altJump == KEYS_PRESSED and doublejump_ready and player:mem(0x60, FIELD_WORD) == -1 then
			colliders.bounceResponse(player, nil, false)
			doublejump_ready = false
			if keycode == KEY_JUMP then
				playSFX(1)
				player:mem(0x50, FIELD_WORD, 0)
			else
				playSFX(33)
				player:mem(0x50, FIELD_WORD, -1)
			end
			-- Spawn visual effects
			for i = 1,6 do
				local star = Animation.spawn(80, player.x + player.width/2 + player.speedX, player.y + player.height/2 + player.speedY)
				local angle = rng.random(2)*math.pi
				star.speedX = math.cos(angle)*rng.random(0.2,1.2)
				star.speedY = math.sin(angle)*rng.random(0.2,1.2)
			end
		end
	
		-- Block movement if attacking or hurt
		if is_hurt or (unclebroadsword.attackState >= ATKSTATE.STALLED
		and	unclebroadsword.attackState <= ATKSTATE.LUNGE_CHARGE
		and	unclebroadsword.attackState ~= ATKSTATE.NONE)
		or unclebroadsword.attackState == ATKSTATE.STALLANDFALL or inputBlockingForcedStates[player.forcedState] then 
			BlockMovement()
		else
			RemoveInputBuffer()
		end
		if unclebroadsword.attackState == ATKSTATE.STALLED then player.downKeyPressing = true end
		
		-- Prevent fire/ice projectiles from firing
		if player.powerup > PLAYER_BIG then player:mem(0x160, FIELD_WORD,1) end
		
		-- Disable tail swipe/flying
		if player.powerup == PLAYER_LEAF or player.powerup == PLAYER_TANOOKIE then
			player:mem(0x164, FIELD_WORD, -2)
			-- Re-enable ducking
			if ducking_ext() then player:mem(0x12e, FIELD_WORD, -1) end
		else
			player:mem(0x164, FIELD_WORD, 0)
		end
		player:mem(0x168, FIELD_FLOAT, 0)
		player:mem(0x174, FIELD_WORD, 0)
		
		-- Force statue form
		if unclebroadsword.attackState == ATKSTATE.STATUEFALL then player.altRunKeyPressing = true end
		
		-- Prevent movement while ducking
		if player.powerup == PLAYER_SMALL then
			if ducking_ext() then
				player.leftKeyPressing = false
				player.rightKeyPressing = false
				-- Alter hitbox
				player.character = CHARACTER_MARIO
				player:getCurrentPlayerSetting().hitboxHeight = 44
				player.character = CHARACTER_UNCLEBROADSWORD
			else
				player.character = CHARACTER_MARIO
				player:getCurrentPlayerSetting().hitboxHeight = 54
				player.character = CHARACTER_UNCLEBROADSWORD
			end
		end
	end
end



---------------------------------------------------------------------------------------------- PER-FRAME LOGIC ---------------------------------
local function CheckHurtState() ------------------------------------------------------------------- Check if player is being hurt and knocked back
	-- Check if no longer hurt
	if is_hurt and player:mem(0x140, FIELD_WORD) < 80 then is_hurt = false end
	
	-- If powering down and not invincible blinking
	if player.forcedState == 2 and player:mem(0x140, FIELD_WORD) == 0 then
		-- If not on a mount and not holding anything
		if player:mem(0x108, FIELD_WORD) == 0 and player:mem(0x154, FIELD_WORD) <= 0 then is_hurt = true end
		-- Knockback
		if is_hurt then
			-- Stop climbing
			player:mem(0x40, FIELD_WORD, 0)
			-- Set knockback
			if knockback then
				unclebroadsword.attackState = ATKSTATE.NONE
				attack_timer = 0
				player.speedX = -player:mem(0x106, FIELD_WORD)*3
				player.speedY = -7
			else
				knockback = true
			end
		end
		-- Cancel power down
		player.forcedState = 0
		player.powerup = PLAYER_SMALL
		-- Set invincibility timer
		player:mem(0x140, FIELD_WORD, 120)
	end
	
	-- Change death animation
	if player:mem(0x13e, FIELD_WORD) > 0 then
		local gfx = Animation.get(159)[1]
		if gfx then gfx.speedX = -2*player:mem(0x106, FIELD_WORD) end
		if player:mem(0x106, FIELD_WORD) == 1 then
			Graphics.sprites.effect[159].img = pm.getGraphic(CHARACTER_UNCLEBROADSWORD, deathFX_right)
		else Graphics.sprites.effect[159].img = pm.getGraphic(CHARACTER_UNCLEBROADSWORD, deathFX_left) end
	end
end
local function UpdateAttackState() ---------------------------------------------------------------- Advance attack state timers	
	-- Should the state be changed?
	if attack_timer <= 0 then
		-- Pause after swiping
		if		unclebroadsword.attackState == ATKSTATE.SWIPE1	then
			-- Check if the next attack has been queued
			if queue_state == ATKSTATE.SWIPE2 then
				unclebroadsword.attackState = ATKSTATE.SWIPE2				-- Swipe downward
				attack_timer = DURATION[ATKSTATE.SWIPE2]*3 - 1
				Audio.SfxPlayCh(-1, Audio.SfxOpen(pm.getSound(CHARACTER_UNCLEBROADSWORD, sfx.swipe)), 0)
				queue_state = ATKSTATE.NONE
			else
				unclebroadsword.attackState = ATKSTATE.PAUSE1
				attack_timer = DURATION[ATKSTATE.PAUSE1]
			end
		elseif	unclebroadsword.attackState == ATKSTATE.SWIPE2	then
			-- Check if the next attack has been queued
			if queue_state == ATKSTATE.LUNGE_COMBO then
				unclebroadsword.attackState = ATKSTATE.LUNGE_COMBO			-- Combo lunge forward
				attack_timer = DURATION[ATKSTATE.LUNGE_COMBO] - 1 + LUNGELAG_COMBO
				Audio.SfxPlayCh(-1, Audio.SfxOpen(pm.getSound(CHARACTER_UNCLEBROADSWORD, sfx.lunge)), 0)
				queue_state = ATKSTATE.NONE
			else
				unclebroadsword.attackState = ATKSTATE.PAUSE2
				attack_timer = DURATION[ATKSTATE.PAUSE2]
			end
			
		-- Cooldown after pausing
		elseif	unclebroadsword.attackState == ATKSTATE.PAUSE1
			or  unclebroadsword.attackState == ATKSTATE.PAUSE2
			or  unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO
			or  unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE
			or 	unclebroadsword.attackState == ATKSTATE.STALLED then
			unclebroadsword.attackState = ATKSTATE.COOLDOWN
			-- Skip cooldown if ducking
			if not ducking() then attack_timer = DURATION[ATKSTATE.COOLDOWN] end
			-- Prevent further aerials
			can_aerial = false
		elseif	unclebroadsword.attackState == ATKSTATE.COOLDOWN then
			unclebroadsword.attackState = ATKSTATE.NONE
		end
		
		-- Check if charging
		if player.powerup > PLAYER_SMALL and standing() then
			-- Holding charge button and don't move
			if player.runKeyPressing then
				if unclebroadsword.attackState == ATKSTATE.COOLDOWN then unclebroadsword.attackState = ATKSTATE.CHARGING
				elseif unclebroadsword.attackState == ATKSTATE.CHARGING then
					charge_timer = charge_timer + 1
					if charge_timer >= DURATION[ATKSTATE.CHARGING] then
						unclebroadsword.attackState = ATKSTATE.CHARGED
						Audio.SfxPlayCh(-1, Audio.SfxOpen(pm.getSound(CHARACTER_UNCLEBROADSWORD, sfx.knife)), 0)
					elseif charge_timer == DURATION[ATKSTATE.CHARGING] - CHARGING_SOUND_DURATION then
						charge_sfxobj = Audio.SfxPlayObj(Audio.SfxOpen(pm.getSound(CHARACTER_UNCLEBROADSWORD, sfx.charging)), 0)
					end
				end
			else
				-- Lunge forward
				if charge_timer >= DURATION[ATKSTATE.CHARGING] - CHARGING_SOUND_DURATION then
					unclebroadsword.attackState = ATKSTATE.LUNGE_CHARGE
					attack_timer = DURATION[ATKSTATE.LUNGE_CHARGE] + LUNGELAG_CHARGE
					Audio.SfxPlayCh(-1, Audio.SfxOpen(pm.getSound(CHARACTER_UNCLEBROADSWORD, sfx.lunge)), 0)
					charge_fraction = charge_timer/DURATION[ATKSTATE.CHARGING]
				-- Cancel the charge
				elseif unclebroadsword.attackState == ATKSTATE.CHARGING then SetCooldown() end
				
				-- Stop playing the charging sound
				if charge_sfxobj and charge_sfxobj:IsPlaying() then charge_sfxobj:Stop() end
				-- Reset charge timer
				charge_timer = 0
			end
		end
		if (unclebroadsword.attackState == ATKSTATE.CHARGING or unclebroadsword.attackState == ATKSTATE.CHARGED)
		and (not standing() or statued() or player.leftKeyPressing or player.rightKeyPressing) then
			-- Cancel the charge if not standing on the ground
			SetCooldown()
			charge_timer = 0
			if charge_sfxobj and charge_sfxobj:IsPlaying() then charge_sfxobj:Stop() end
		end
	-- Decrement timer
	else attack_timer = attack_timer - 1 end
	
	-- Check for upward stabbing
	if airborne() then
		if unclebroadsword.attackState == ATKSTATE.NONE or unclebroadsword.attackState == ATKSTATE.UPWARDSTAB then
			if player.upKeyPressing then unclebroadsword.attackState = ATKSTATE.UPWARDSTAB
			else unclebroadsword.attackState = ATKSTATE.NONE end
		end
	end
	
	-- Landing on the ground or bouncing off of a spring
	if grounded() or player:mem(0x11c,FIELD_WORD) == 55 or player:mem(0x11c,FIELD_WORD) == 49 then
		-- Refresh aerial attack state
		can_aerial = true
		can_stallnfall = true
		doublejump_ready = true
		
		if unclebroadsword.attackState == ATKSTATE.UPWARDSTAB then
			unclebroadsword.attackState = ATKSTATE.NONE
		elseif unclebroadsword.attackState == ATKSTATE.STALLANDFALL or unclebroadsword.attackState == ATKSTATE.STATUEFALL then
			-- Kick up some dust
			local smoke = Animation.spawn(10, player.x - 24, player.y + player.height - 16)
			smoke.speedX = -1
			smoke = Animation.spawn(10, player.x + player.width - 8, player.y + player.height - 16)
			smoke.speedX = 1
			-- Shake the screen a bit
			Audio.SfxPlayCh(-1, Audio.SfxOpen(pm.getSound(CHARACTER_UNCLEBROADSWORD, sfx.drop)), 0)
			if unclebroadsword.attackState == ATKSTATE.STATUEFALL then Defines.earthquake = 15
			else Defines.earthquake = 3 end
			-- Stall player after hitting ground
			unclebroadsword.attackState = ATKSTATE.STALLED
			attack_timer = DURATION[ATKSTATE.STALLED]
		end
	end
	
	-- Reset if downstabbing onto a note block
	if unclebroadsword.attackState == ATKSTATE.STALLANDFALL and player.speedY < 0 then
		check = colliders.Box(player.x, player.y + player.height, player.width, UDSTAB_HEIGHT)
		if colliders.collideBlock(check, 55) then unclebroadsword.attackState = ATKSTATE.NONE end
	end
	
	
	-- Cancel state if necessary
	if submerged() or sliding() or climbing() or (statued() and mounted())--[[or mounted() or holding() or pickingup() or warping()--]] then
		unclebroadsword.attackState = ATKSTATE.NONE
		if(statued() and mounted()) then
			player:mem(0x4a, FIELD_WORD, 0)
		end
		can_aerial = true
		can_stallnfall = true
		doublejump_ready = true
	end
end
local function AttackPhysics() -------------------------------------------------------------------- Set player speed and sword hitbox
	-- If in air while attacking, don't fall
	if player.forcedState ~= 0 then return end
	if aerial_atk_stall or unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE then
		player.speedY = 0
		player.y = player.y - Defines.player_grav
	end
	if unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE and player:mem(0x48, FIELD_WORD) ~= 0 then player.y = player.y - 1 end
	if unclebroadsword.attackState < ATKSTATE.PAUSE2 or unclebroadsword.attackState > ATKSTATE.LUNGE_CHARGE or unclebroadsword.attackState == ATKSTATE.NONE then
		aerial_atk_stall = false;
	end
	
	-- Boost player forward slightly when swiping in the air
	if airborne() then
		if unclebroadsword.attackState == ATKSTATE.SWIPE1 or unclebroadsword.attackState == ATKSTATE.SWIPE2 then
			--player.speedX = player:mem(0x106, FIELD_WORD)*1
			player.speedY = math.min(player.speedY, 1)
		elseif unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO then
			aerial_atk_stall = true
		end
	end
	
	-- Lunging speeds
	if unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO or unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE then
		-- Maximum time duration
		local tmax = DURATION[unclebroadsword.attackState]
		-- Time parameter; Maximum distance traveled
		local t = 0; local xmax = 0;
		
		-- Set parameters
		if unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO then
			t = attack_timer - LUNGELAG_COMBO
			if(attack_timer > tmax) then
				player.speedY = 0
			end
			xmax = LUNGEDIST_COMBO
		elseif unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE then
			t = attack_timer - LUNGELAG_CHARGE
			xmax = LUNGEDIST_CHARGE*charge_fraction*charge_fraction
		end
		if t < 0 then t = 0 end
		
		if airborne() then
			can_stallnfall = true
		end
		
		-- Set speed
		player.speedX = player.direction*2*xmax/tmax/tmax*t
	end
		
	if mounted() or statued() then
		can_stallnfall = false
	end
	
	-- Lose momentum when swiping
	if grounded() then
		if unclebroadsword.attackState == ATKSTATE.SWIPE1 or unclebroadsword.attackState == ATKSTATE.SWIPE2 then
			if math.abs(player.speedX) < 0.02 then player.speedX = 0
			else player.speedX = player.speedX - player:mem(0x106, FIELD_WORD)*0.02 end
		end
	end
	
	-- Toss boomerang
	if player.powerup == PLAYER_HAMMER then
		if (unclebroadsword.attackState == ATKSTATE.SWIPE2 and attack_timer == DURATION[ATKSTATE.SWIPE2]*2) then
			local n = NPC.spawn(436, unclebroadsword.swordCollider.x + unclebroadsword.swordCollider.width/2, unclebroadsword.swordCollider.y + unclebroadsword.swordCollider.height/2, player.section, false, true)
			n:mem(0x12E, FIELD_WORD, 1)
			n:mem(0x13A, FIELD_WORD, player.idx)
			n.direction = player.direction
		end
	end
	
	-- Stall-and-fall
	if (unclebroadsword.attackState == ATKSTATE.STALLANDFALL or unclebroadsword.attackState == ATKSTATE.STATUEFALL) and player.speedY > 0 then
		-- Set physics
		Defines.gravity = FALLSPEED
		player.speedY = player.speedY + 1.5
		player.speedX = 0
		player.downKeyPressing = false
		if unclebroadsword.attackState == ATKSTATE.STATUEFALL then player:mem(0x4a, FIELD_WORD, -1) end
		
		-- Remember positions
		if #afterimagepos < AFTERIMAGE_COUNT then
			afterimagepos[#afterimagepos + 1] = {x = player.x, y = player.y, state = unclebroadsword.attackState}
		else
			for i = 1, #afterimagepos-1 do afterimagepos[i] = afterimagepos[i+1] end
			afterimagepos[#afterimagepos] = {x = player.x, y = player.y, state = unclebroadsword.attackState}
		end
	else
		Defines.gravity = nil
		if #afterimagepos > 0 then table.remove(afterimagepos, 1) end
	end
	
	-- Set sword hitbox
	if unclebroadsword.attackState > ATKSTATE.NONE then
		if unclebroadsword.swordCollider == nil then unclebroadsword.swordCollider = colliders.Box(0,0,0,0) end
		if unclebroadsword.attackState == ATKSTATE.SWIPE1 or unclebroadsword.attackState == ATKSTATE.SWIPE2 then
			unclebroadsword.swordCollider.x = 		player.x - SWIPE_WIDTH + ( player:mem(0x106, FIELD_WORD) + 1 )*( player.width + SWIPE_WIDTH )/2 + player.speedX
			unclebroadsword.swordCollider.y = 		player.y + player.height/2 - SWIPE_HEIGHT/2
			unclebroadsword.swordCollider.width = 	SWIPE_WIDTH
			unclebroadsword.swordCollider.height = SWIPE_HEIGHT
		elseif unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO or unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE then
			unclebroadsword.swordCollider.x = 		player.x - LUNGE_WIDTH + ( player:mem(0x106, FIELD_WORD) + 1 )*( player.width + LUNGE_WIDTH )/2 + player.speedX
			unclebroadsword.swordCollider.y = 		player.y + player.height/2 - LUNGE_HEIGHT/2 + 6
			unclebroadsword.swordCollider.width = 	LUNGE_WIDTH
			unclebroadsword.swordCollider.height = LUNGE_HEIGHT
		elseif unclebroadsword.attackState == ATKSTATE.UPWARDSTAB then
			unclebroadsword.swordCollider.x = 		player.x + player.width/2 - UDSTAB_WIDTH/2 + player.speedX
			unclebroadsword.swordCollider.y = 		player.y - UDSTAB_HEIGHT + player.speedY
			unclebroadsword.swordCollider.width = 	UDSTAB_WIDTH
			unclebroadsword.swordCollider.height = UDSTAB_HEIGHT
		elseif unclebroadsword.attackState == ATKSTATE.STALLANDFALL then
			unclebroadsword.swordCollider.x = 		player.x + player.width/2 - UDSTAB_WIDTH/2 + player.speedX
			unclebroadsword.swordCollider.y = 		player.y + player.height + player.speedY
			unclebroadsword.swordCollider.width = 	UDSTAB_WIDTH
			unclebroadsword.swordCollider.height = UDSTAB_HEIGHT
		elseif unclebroadsword.attackState == ATKSTATE.STATUEFALL then
			unclebroadsword.swordCollider.x = 		player.x + player.speedX
			unclebroadsword.swordCollider.y = 		player.y + player.height + player.speedY
			unclebroadsword.swordCollider.width = 	player.width
			unclebroadsword.swordCollider.height = player.speedY
		end
	else
		unclebroadsword.swordCollider = nil
	end
end
local function PerformSwordBlockCollisions() ------------------------------------------------------ Detect interactions of sword/tanooki statue with blocks
	-- Block collisions
	for _,block in pairs(Block.getIntersecting(unclebroadsword.swordCollider.x, unclebroadsword.swordCollider.y, unclebroadsword.swordCollider.x + unclebroadsword.swordCollider.width, unclebroadsword.swordCollider.y + unclebroadsword.swordCollider.height)) do
		-- If block is visible
		if block:mem(0x1c, FIELD_WORD) == 0 and block:mem(0x5a, FIELD_WORD) == 0 then
			-- Not bouncing from noteblocks (can get stuck)
			if isType(block.id, BLOCK_BOUNCY) and block.contentID == 0 then
				if unclebroadsword.attackState == ATKSTATE.STALLANDFALL then unclebroadsword.attackState = ATKSTATE.NONE end
			end
			-- Destroy bricks
			if isType(block.id, BLOCK_BRICK) and block.contentID == 0 then
				block:remove(true)
				if unclebroadsword.attackState == ATKSTATE.STALLANDFALL then colliders.bounceResponse(player) end
			-- Melting ice blocks with fire sword
			elseif block.id == 1151 then
				if player.powerup == PLAYER_ICE then
					blockutils.spawnNPC(block)
					
					Animation.spawn(10, block.x, block.y)
					playSFX(16)
					block:remove()
				end
			elseif block.id == 620 or block.id == 621 or block.id == 669 then
				if player.powerup == PLAYER_FIREFLOWER then
					-- Frozen coin
					if block.id == 620 then NPC.spawn(10, block.x, block.y, player.section) end
					-- Frozen muncher
					if block.id == 621 then Block.spawn(109, block.x, block.y) end
					-- Ice block container
					if block.id == 669 then
						blockutils.spawnNPC(block)
					end
					
					Animation.spawn(10, block.x, block.y)
					playSFX(16)
					block:remove()
				end
			-- Ignore player blocks
			elseif not isType(block.id, BLOCK_PLAYERSWITCH) then
				if unclebroadsword.attackState >= ATKSTATE.STALLANDFALL then
					block:hit(true, player)
					-- Bounce if it's a SMW turn block or it had something inside
					if (block.id == 90 or block.contentID ~= 0) and unclebroadsword.attackState == ATKSTATE.STALLANDFALL then
						colliders.bounceResponse(player)
						unclebroadsword.attackState = ATKSTATE.STALLED
						attack_timer = DURATION[ATKSTATE.STALLED]
					end
				else
					-- When lunging, only hit the block on the first frames
					if not ((unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO or unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE) and attack_timer < DURATION[unclebroadsword.attackState]) then
						block:hit()
					end
				end
			end
		end
	end
end
local function PerformSwordNPCCollisions() -------------------------------------------------------- Detect interactions of sword with NPCs
	-- NPC collisions
	if player.forcedState ~= 0 then return end 
	for _,npc in ipairs(NPC.getIntersecting(unclebroadsword.swordCollider.x, unclebroadsword.swordCollider.y, unclebroadsword.swordCollider.x + unclebroadsword.swordCollider.width, unclebroadsword.swordCollider.y + unclebroadsword.swordCollider.height)) do
		-- Check if hittable and not a generator
		if not (npc.invincibleToSword or npc.friendly or npc.isHidden) and npc:mem(0x64, FIELD_WORD) == 0 then
			-- Prevent infinite bounce on springboards on stall-and-fall
			if isType(npc.id, NPC_BOUNCY) then
				if unclebroadsword.attackState == ATKSTATE.STALLANDFALL then unclebroadsword.attackState = ATKSTATE.NONE end
			end
			-- Catch powerups
			if isType(npc.id, NPC_POWERUP) or isType(npc.id, NPC_BONUS) then
				if unclebroadsword.attackState < ATKSTATE.UPWARDSTAB then
					npc.x = player.x + player.width/2 - npc.width/2
					npc.y = player.y + player.height/2 - npc.height/2
				end
			-- Frozen enemy
			elseif npc.id == 263 then
				-- If swiping, only destroy on the first attack frame
				if (unclebroadsword.attackState == ATKSTATE.SWIPE1 or unclebroadsword.attackState == ATKSTATE.SWIPE2)
				and attack_timer == 3*DURATION[unclebroadsword.attackState] - 1 then npc:harm(HARM_TYPE_SWORD)
				elseif unclebroadsword.attackState >= ATKSTATE.LUNGE_COMBO then
					npc:harm(HARM_TYPE_SWORD)
					if unclebroadsword.attackState == ATKSTATE.STALLANDFALL then colliders.bounceResponse(player) end
				end
			else
				-- Freeze enemy if you have the ice flower and it can be frozen
				if player.powerup == PLAYER_ICE and not NPC.config[npc.id].noiceball then
					npc:harm(HARM_TYPE_EXT_ICE)
				-- Ignore if a tool, an egg, or Mouser's bomb
				elseif not (npc.id == 96 or npc.id == 134 or isType(npc.id, NPC_CARRYABLETOOL)) then
					npc:harm(HARM_TYPE_SWORD)
				end
				-- Bounce if a boss character and stall-and-fall
				if unclebroadsword.attackState >= ATKSTATE.STALLANDFALL and npc:mem(0x148, FIELD_FLOAT) ~= 0 then
					colliders.bounceResponse(player)
					if unclebroadsword.attackState == ATKSTATE.STATUEFALL then player.forcedState = 500 end
					SetCooldown()
				end
			end
			
			-- Stall if swiping in the air
			if airborne() and not inforcedanim()
			and (unclebroadsword.attackState == ATKSTATE.SWIPE1 or unclebroadsword.attackState == ATKSTATE.SWIPE2) then
				aerial_atk_stall = true;
			end
		end
	end
end
local function SpawnAttackGFX() ------------------------------------------------------------------- Display visual effects for fire/ice sword
	-- Generate smoke puffs
	if (unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE or unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO) and grounded() then
		local x = math.random(player.x + player.width/2, player.x + player.width/2*(1 - player:mem(0x106, FIELD_WORD)))
		local y = player.y + player.height + rng.random(-2,2) - 4
		Animation.spawn(74, x, y)
	end
	
	-- Show effect for fire/ice powerups
	if unclebroadsword.swordCollider and ((unclebroadsword.attackState >= ATKSTATE.SWIPE1 and unclebroadsword.attackState <= ATKSTATE.LUNGE_CHARGE) or unclebroadsword.attackState == ATKSTATE.STALLANDFALL) then
		if player.powerup == PLAYER_FIREFLOWER then
			local fire = Animation.spawn( 12,
				rng.random(unclebroadsword.swordCollider.x, unclebroadsword.swordCollider.x + unclebroadsword.swordCollider.width) - 14,
				rng.random(unclebroadsword.swordCollider.y, unclebroadsword.swordCollider.y + unclebroadsword.swordCollider.height) - 44
			)
			fire.speedX = 0; fire.speedY = 0
		elseif player.powerup == PLAYER_ICE then
			if not (unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE or unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO) or attack_timer%3 == 0 then
				local star = Animation.spawn( 80,
					rng.random(unclebroadsword.swordCollider.x, unclebroadsword.swordCollider.x + unclebroadsword.swordCollider.width) - 8,
					rng.random(unclebroadsword.swordCollider.y, unclebroadsword.swordCollider.y + unclebroadsword.swordCollider.height) - 8
				)
				star.speedX = 0; star.speedY = 0
			end
		end
	end
end
local function PrintAttackState(x, y) ------------------------------------------------------------- Print name of current attack state and charge meter reading
	local msg = ""
	if		unclebroadsword.attackState == ATKSTATE.COOLDOWN		then msg = "cooldown"
	elseif	unclebroadsword.attackState == ATKSTATE.NONE			then msg = "none"
	elseif	unclebroadsword.attackState == ATKSTATE.SWIPE1			then msg = "swipe1"
	elseif	unclebroadsword.attackState == ATKSTATE.PAUSE1			then msg = "pause1"
	elseif	unclebroadsword.attackState == ATKSTATE.SWIPE2			then msg = "swipe2"
	elseif	unclebroadsword.attackState == ATKSTATE.PAUSE2 		then msg = "pause2"
	elseif	unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO	then msg = "lunge combo"
	elseif	unclebroadsword.attackState == ATKSTATE.CHARGING		then msg = "charging"
	elseif	unclebroadsword.attackState == ATKSTATE.CHARGED		then msg = "charged"
	elseif	unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE	then msg = "lunge charge"
	elseif	unclebroadsword.attackState == ATKSTATE.UPWARDSTAB		then msg = "upward stab"
	elseif	unclebroadsword.attackState == ATKSTATE.STALLANDFALL	then msg = "stall-and-fall"
	elseif	unclebroadsword.attackState == ATKSTATE.STATUEFALL		then msg = "falling statue"	
	elseif	unclebroadsword.attackState == ATKSTATE.STALLED		then msg = "stalled" end
	Text.print(msg, x, y)
	Text.print("Charge: "..tostring(charge_timer), x, y + 20)
	Text.print("Aerial: "..tostring(can_aerial), x, y + 40)
end
function unclebroadsword.onTick()
	if player.character == CHARACTER_UNCLEBROADSWORD and player:mem(0x13E,FIELD_WORD) == 0 then
		-- Check for hurt state
		CheckHurtState()
		
		-- Update current attacking state
		UpdateAttackState()
		-- Change player speed when attacking
		AttackPhysics()
		-- Perform hit detection for sword
		if unclebroadsword.swordCollider then
			PerformSwordBlockCollisions()
			PerformSwordNPCCollisions()
		end
		-- Draw visual effects
		SpawnAttackGFX()
		
		if unclebroadsword.debugMode then PrintAttackState(20, 500) end
	end
end



---------------------------------------------------------------------------------------------- RENDERING ---------------------------------------
local function SetFrame(frame) -------------------------------------------------------------------- Set player frame
	player:mem(0x114, FIELD_WORD, frame)
end
local function ShowSmallFrames() ------------------------------------------------------------------ PLAYER_SMALL frame management
	if ducking_ext()and not mounted() then SetFrame(7)			-- Ducking
	elseif sliding() then SetFrame(24)							-- Sliding down slope
	elseif player:mem(0x58, FIELD_WORD) ~= 0 then				-- Changing direction
		SetFrame(6)
		if holding() then SetFrame(10) end
	elseif holding() then										-- Holding an item
		if grounded() then
			if player.speedX == 0 then
				SetFrame(8)
				holding_frame_timer = 1
				holding_frame_index = 1
			else
				if math.abs(player.speedX) < Defines.player_walkspeed then
					if holding_frame_timer > 5 then
						holding_frame_timer = 1
						holding_frame_index = holding_frame_index + 1
					end
				else
					if holding_frames[holding_frame_index] == 9 then
						if holding_frame_timer > 2 then
							holding_frame_timer = 1
							holding_frame_index = holding_frame_index + 1
						end
					else
						if holding_frame_timer > 3 then
							holding_frame_timer = 1
							holding_frame_index = holding_frame_index + 1
						end
					end
				end
				if holding_frame_index > 4 then holding_frame_index = 1 end
				SetFrame(holding_frames[holding_frame_index])
				holding_frame_timer = holding_frame_timer + 1
			end
		else
			SetFrame(10)
		end
	else
		if grounded() then										-- Walking/running
			if player.speedX == 0 then
				walking_frame_timer = 1
				walking_frame_index = 1
				running_duration_index = 1
			else
				if math.abs(player.speedX) < Defines.player_walkspeed then
					if walking_frame_timer > 5 then
						walking_frame_timer = 1
						walking_frame_index = walking_frame_index + 1
					end
				elseif math.abs(player.speedX) < Defines.player_walkspeed + 1.5 then
					if walking_frames[walking_frame_index] == 2 then
						if walking_frame_timer > 2 then
							walking_frame_timer = 1
							walking_frame_index = walking_frame_index + 1
						end
					else
						if walking_frame_timer > 3 then
							walking_frame_timer = 1
							walking_frame_index = walking_frame_index + 1
						end
					end
				else
					if walking_frame_timer > running_durations[running_duration_index] then
						walking_frame_timer = 1
						walking_frame_index = walking_frame_index + 1
						running_duration_index = running_duration_index + 1
					end
					if running_duration_index > 3 then running_duration_index = 1 end
				end
				if walking_frame_index > 4 then walking_frame_index = 1 end
				SetFrame(walking_frames[walking_frame_index])
				walking_frame_timer = walking_frame_timer + 1
			end
		end
	end
end
local function ShowAttackFrames() ----------------------------------------------------------------- Render frames when attacking
	-- Sword swipe/lunge/stab frames frames
	if 	   unclebroadsword.attackState == ATKSTATE.SWIPE1 then
		local offset = math.floor(attack_timer / DURATION[ATKSTATE.SWIPE1])
		if ducking() then		SetFrame(29 - offset)
		elseif grounded() then	SetFrame(20 - offset)
		else					SetFrame(35 - offset) end
	elseif unclebroadsword.attackState == ATKSTATE.PAUSE1 then
		if ducking() then		SetFrame(7)
		elseif grounded() then	SetFrame(21)
		else					SetFrame(36) end
	elseif unclebroadsword.attackState == ATKSTATE.SWIPE2 then
		local offset = math.floor(attack_timer / DURATION[ATKSTATE.SWIPE2])
		if ducking() then		SetFrame(27 + offset)
		elseif grounded() then	SetFrame(19 + offset)
		else					SetFrame(33 + offset) end
	elseif unclebroadsword.attackState == ATKSTATE.PAUSE2 then
		if ducking() then		SetFrame(7)
		elseif grounded() then	SetFrame(17)
		else					SetFrame(32) end
	elseif unclebroadsword.attackState == ATKSTATE.LUNGE_COMBO then
		SetFrame(39)
	elseif unclebroadsword.attackState == ATKSTATE.CHARGING then
		SetFrame(45)
	elseif unclebroadsword.attackState == ATKSTATE.CHARGED then
		if math.floor(os.clock()*12)%2 == 0 then SetFrame(46)
		else SetFrame(45) end
	elseif unclebroadsword.attackState == ATKSTATE.LUNGE_CHARGE then
		local max_speed = 2*LUNGEDIST_CHARGE/DURATION[ATKSTATE.LUNGE_CHARGE]
		if math.abs(player.speedX) < max_speed/6 then SetFrame(39)
		elseif math.abs(player.speedX) < max_speed/3 then SetFrame(38)
		else SetFrame(37) end
	elseif unclebroadsword.attackState == ATKSTATE.STALLANDFALL then
		SetFrame(47)
	elseif unclebroadsword.attackState == ATKSTATE.UPWARDSTAB then
		if spinjumping() then
			if player:mem(0x114, FIELD_WORD) == 13 then SetFrame(14)
			elseif player:mem(0x114, FIELD_WORD) == 15 then SetFrame(16)
			else SetFrame(48) end
		else SetFrame(48) end
	end
end
function unclebroadsword.onDraw()
	if player.character == CHARACTER_UNCLEBROADSWORD then
		-- Render afterimages for stall-and-fall
		if(player:mem(0x13E,FIELD_WORD) == 0) then
			for i,pos in ipairs(afterimagepos) do
				if pos.state == ATKSTATE.STALLANDFALL then
					Graphics.draw {x = pos.x - 12, y = pos.y - 20, type = RTYPE_IMAGE, image = pm.getGraphic(CHARACTER_UNCLEBROADSWORD, afterimage),
									isSceneCoordinates = true, opacity = 0.7*i/(#afterimagepos + 1), priority = -26,
									sourceX = ( player:mem(0x106, FIELD_WORD) + 1 )/2*100, sourceY = player.powerup*100 - 100,
									sourceWidth = 100, sourceHeight = 100}
				elseif pos.state == ATKSTATE.STATUEFALL then
					Graphics.draw {x = pos.x - 8, y = pos.y - 26, type = RTYPE_IMAGE, image = pm.getGraphic(CHARACTER_UNCLEBROADSWORD, statue_img),
									isSceneCoordinates = true, opacity = 0.7*i/(#afterimagepos + 1), priority = -26}
				end
			end
		end
	
		if(player:mem(0x13E,FIELD_WORD) == 0) then
			if player.powerup == PLAYER_SMALL then ShowSmallFrames() end
			
			if unclebroadsword.attackState ~= ATKSTATE.NONE and unclebroadsword.attackState ~= ATKSTATE.COOLDOWN then ShowAttackFrames()
			elseif is_hurt then SetFrame(49) end
		end
	end
end



---------------------------------------------------------------------------------------------- CHARACTER MANAGEMENT ----------------------------
function unclebroadsword.onInitAPI()
	registerEvent(unclebroadsword, "onInputUpdate", "onInputUpdate")
	registerEvent(unclebroadsword, "onNPCKill", "onNPCKill")
	registerEvent(unclebroadsword, "onTick", "onTick")
	registerEvent(unclebroadsword, "onDraw", "onDraw")
	if unclebroadsword.debugMode then registerEvent(unclebroadsword, "onDraw", "DebugDraw") end
end
function unclebroadsword.initCharacter()
	-- Prevent from dropping rupees
	Defines.kill_drop_link_rupeeID1 = 0
	Defines.kill_drop_link_rupeeID2 = 0
	Defines.kill_drop_link_rupeeID3 = 0
	-- Slightly nerf speed
	Defines.player_runspeed = 5
end
function unclebroadsword.cleanupCharacter()
	-- Reset death effect
	Graphics.sprites.effect[3].img = nil
	-- Reset maximum player fall/run speed
	Defines.gravity = nil
	Defines.player_runspeed = nil
	-- Reset rupee drop
	Defines.kill_drop_link_rupeeID1 = nil
	Defines.kill_drop_link_rupeeID2 = nil
	Defines.kill_drop_link_rupeeID3 = nil
end



---------------------------------------------------------------------------------------------- DEBUG FUNCTIONS ---------------------------------
function DrawRect(x1, y1, x2, y2, clr) ------------------------------------------------------------ OpenGL box drawing
	Graphics.glDraw {vertexCoords = {x1,y1,x2,y1,x2,y1,x2,y2,x2,y2,x1,y2,x1,y2,x1,y1}, sceneCoords=true, color = clr, primitive = Graphics.GL_LINES}
end
function unclebroadsword.DebugDraw() -------------------------------------------------------------- Render hitboxes
	if player.character == CHARACTER_UNCLEBROADSWORD then
		local playerbox = colliders.getHitbox(player)
		DrawRect(playerbox.x, playerbox.y, playerbox.x + playerbox.width, playerbox.y + playerbox.height, {0,1,0})
		if unclebroadsword.swordCollider ~= nil then
			DrawRect(unclebroadsword.swordCollider.x, unclebroadsword.swordCollider.y, unclebroadsword.swordCollider.x + unclebroadsword.swordCollider.width, unclebroadsword.swordCollider.y + unclebroadsword.swordCollider.height, {1,0,0})
		end
	end
end

return unclebroadsword















