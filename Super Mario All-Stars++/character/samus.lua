--samus.lua
--v1.0.0
--Created by Rednaxela and Horikawa Otane, 2015
--Contact Horikawa at https://www.youtube.com/subscription_center?add_user=msotane

--[[
Things to fix:
- ...
]]

--------------------
-- Parent handler --
--------------------
local samus = {}

local colliders = require("colliders")
local rng = require("rng")
local pm = require("playerManager")
local imagic = require("imagic")
local defs = require("expandedDefines")
local HUDOverride = require("hudoverride")

local megashroom = require("NPCs/AI/megashroom")

local playerBullets = {}
playerBullets[1] = 266
playerBullets[2] = 266
playerBullets[3] = 13
playerBullets[4] = 266
playerBullets[5] = 266
playerBullets[6] = 171
playerBullets[7] = 265

local mushrooms = {9, 184, 185, 249, 250}
local oneUpMushrooms = {90, 186, 187, 273}

local samusHealth = 2
local samusLocalMaxHealth = 2
local samusMaxHealth = 20
local hasJumpedCounter = 0
local hasDied = false

function samus.onInitAPI()
	registerEvent(samus, "onTick", "onTick", false)
	registerEvent(samus, "onDraw", "onDraw", false)
	registerEvent(samus, "onExitLevel", "onExitLevel", false)
	registerEvent(samus, "onInputUpdate", "onInputUpdate", false)
	registerEvent(samus, "onJumpEnd", "onJumpEnd", false)
	registerEvent(samus, "onNPCKill", "onNPCKill", false)
	registerEvent(samus, "onMessageBox", "onMessageBox", false)
end

local sfx_missileHit = pm.registerSound(CHARACTER_SAMUS, "samus_missile.ogg");
local sfx_shoot = pm.registerSound(CHARACTER_SAMUS, "samus_shoot.ogg");
local sfx_shootice = pm.registerSound(CHARACTER_SAMUS, "samus_shoot_ice.ogg");
local sfx_shootmissile = pm.registerSound(CHARACTER_SAMUS, "samus_shoot_missile.ogg");
local sfx_twirl = pm.registerSound(CHARACTER_SAMUS, "samus_twirl.ogg");

local shotData = {}
shotData[266] = {img=pm.registerGraphic(CHARACTER_SAMUS,"samus_shot.png"), frames=1, height=16, width=16}
shotData[13] = {img=pm.registerGraphic(CHARACTER_SAMUS,"samus_missile.png"), frames=2, height=16, width=30}
shotData[171] = {img=pm.registerGraphic(CHARACTER_SAMUS,"samus_missile_2.png"), frames=2, height=12, width=30}
shotData[265] = {img=pm.registerGraphic(CHARACTER_SAMUS,"samus_shock.png"),height=16,width=20}

local shotNPCs = {}

------------
-- Images --
------------
local ballTable = {}
local ballTableSprite = {1, 1, 2, 3, 3, 4, 5}
for i = 1, 7 do
ballTable[i] = pm.registerGraphic(CHARACTER_SAMUS,"ball".. tostring(ballTableSprite[i]..".png"))
end
local bombImg = pm.registerGraphic(CHARACTER_SAMUS,"samusbomb.png")
local healthBox = pm.registerGraphic(CHARACTER_SAMUS,"samushealth.png")
local emptyBox = pm.registerGraphic(CHARACTER_SAMUS,"samusempty.png")
local fullBox = pm.registerGraphic(CHARACTER_SAMUS,"samusfull.png")
local blackBox = pm.registerGraphic(CHARACTER_SAMUS,"samusblack.png")

---------------
-- Utilities --
---------------

local function blockFilter(b)
	return not b.isHidden;
end

local function _rot1(x, y, s1, c1)
	local x2 = (x*c1) - (y*s1)
	local y2 = (y*c1) + (x*s1)
	return x2, y2
end

local function checkForCeiling()
	local colliding = false
	local box = colliders.Box(player.x + 3, player.y - 32, 20, 32)
	colliding = colliders.collideBlock(box, colliders.BLOCK_SOLID, blockFilter)
	
	return colliding
end

local function paintHealth(countChoice, graphicChoice)
	for i = 1, countChoice do
		if i <= 10 then
			Graphics.drawImageWP(graphicChoice, 292 + (18 * i), 45, -5)
		else
			Graphics.drawImageWP(graphicChoice, 292 + (18 * (i - 10)), 61, -5)
		end
	end
end

local function checkHealth()
	for _, v in pairs(NPC.get(oneUpMushrooms, player.section)) do
		if colliders.collide(player, v) then
			v:kill(9)
			samusLocalMaxHealth = samusLocalMaxHealth + 1
			samusHealth = samusHealth + 1
			playSFX(83)
		end
	end
	for _, v in pairs(NPC.get(mushrooms, player.section)) do
		if colliders.collide(player, v) then
			v:kill(9)
			samusHealth = samusHealth + 1
		end
	end
	if samusHealth > samusLocalMaxHealth then
		samusHealth = samusLocalMaxHealth
	end
	if samusLocalMaxHealth > samusMaxHealth then
		samusLocalMaxHealth = samusMaxHealth
	end
	if player.powerup == 1 then
		player.powerup = 2
	end
	player:mem(0x16, FIELD_WORD, 3)
	if player:mem(0x140, FIELD_WORD) > 120 and not isFlashing then
		samusHealth = samusHealth - 1
		isFlashing = true
	end		
	if isFlashing and player:mem(0x140, FIELD_WORD) == 0 then
		isFlashing = false
	end
	if samusHealth == 0 and player:mem(0x13E,FIELD_WORD) == 0 then
		player:kill()
	end
	Graphics.drawImageWP(pm.getGraphic(CHARACTER_SAMUS, healthBox), 313, 5, -5)
	Text.printWP("SUPPLY", 348, 2, -5)
	Text.printWP("Energy Tank", 303, 22,-5)
	paintHealth(samusMaxHealth, pm.getGraphic(CHARACTER_SAMUS, blackBox))
	paintHealth(samusLocalMaxHealth, pm.getGraphic(CHARACTER_SAMUS, emptyBox))
	paintHealth(samusHealth, pm.getGraphic(CHARACTER_SAMUS, fullBox))
end

local function drawImageRotated(img, x, y, w, h, rotate)

	x = x - (player.x - player.screen.left)
	y = y - (player.y - player.screen.top)
	local s1 = math.sin(rotate)
	local c1 = math.cos(rotate)
	w = w * 0.5
	h = h * 0.5
	
	local x1 = (-w*c1) - (-h*s1)
	local y1 = (-h*c1) + (-w*s1)
	local x2 = (w*c1) - (h*s1)
	local y2 = (h*c1) + (w*s1)

	local vertCoords = {}
	vertCoords[1], vertCoords[2] = _rot1(-w, -h, s1, c1);
	vertCoords[3], vertCoords[4] = _rot1(-w, h, s1, c1);
	vertCoords[5], vertCoords[6] = _rot1(w, -h, s1, c1);
	vertCoords[7], vertCoords[8] = _rot1(w, h, s1, c1);
	vertCoords[9], vertCoords[10] = _rot1(-w, h, s1, c1);
	vertCoords[11], vertCoords[12] = _rot1(w, -h, s1, c1);
	for i = 1,12,2 do
		vertCoords[i] = vertCoords[i] + x + w
		vertCoords[i+1] = vertCoords[i+1] + y + h
	end

    Graphics.glDraw{vertexCoords=vertCoords, texture=img, textureCoords={0,0,0,1,1,0,1,1,0,1,1,0},
            primitive=Graphics.GL_TRIANGLE_STRIP, priority=-66, color={1.0, 1.0, 1.0, 1.0}}
end

local function checkDownWarp()
	for _, warp in pairs(Warp.getIntersectingEntrance(player.x - .5 * player.width, player.y - .5 * player.height, player.x + 1.5 * player.width, player.y + 1.5 * player.height)) do
		if warp:mem(0x80,FIELD_WORD) == 3 then
			return true;
		end
	end
end

------------------
-- Data Storage --
------------------
local state = {}
local function initDataStorage()
	state.isMorphBall = false
	state.lastPlayerX = nil
	state.lastPlayerY = nil
	state.xMovementAmount = 0
	state.rotationAmount = 0
	state.onFloor = false
	state.wasOnFloor = false
end
initDataStorage()


function samus.onJumpEnd()
	if player.character == CHARACTER_SAMUS then
		hasJumpedCounter = 0
	end
end

------------
-- onLoop --
------------

local messaged = false
function samus.onTick()
	
	messaged = false

	-- debug cheat, don't use
	killcheatcode = Misc.cheatBuffer()
    	killcheat = string.find(killcheatcode, "killsamus", 1)
	if (killcheat ~= 0 and killcheat ~= nil) then
        	player:kill()
        	Misc.cheatBuffer("")
    	end

	samus.onBombLoop()

	if (player.character == CHARACTER_SAMUS) and (player:mem(0x13E, FIELD_WORD) == 0) then
		-- Some state detection
		state.onFloor = (player:mem(0x146, FIELD_WORD) ~= 0) or (player:mem(0x48, FIELD_WORD) ~= 0)
		if (state.lastPlayerX ~= nil) then
			if (state.onFloor and state.wasOnFloor) then
				local dx = player.x - state.lastPlayerX
				local dy = player.y - state.lastPlayerY
				if (dx ~= 0) then
					state.xMovementAmount = (dx/math.abs(dx)) * math.sqrt(dx*dx + dy*dy)
				else
					state.xMovementAmount = 0
				end
			else
				state.xMovementAmount = state.xMovementAmount * 0.95
			end
		else
			state.lastPlayerX = player.x
			state.lastPlayerY = player.y
		end
	
		-- Morph ball mode
		if (state.isMorphBall) then
			samus.morphBallOnLoop()
		end
		
		-- Normal mode
		player.speedX = math.min(math.max(player.speedX, -3.5), 3.5)
		
		for _, v in ipairs(shotNPCs) do
			if(v.isValid) then
				if(v.id ~= 266 and v.id ~= 171) then
					v.speedY = -0.4
				end
				
				if v.id == 13 then
					v.speedX = v.speedX + (0.4 * v:mem(0xEC,FIELD_FLOAT))
					if v.speedX >= 35 or v.speedX <= -35 then
						Animation.spawn(108, v.x, v.y)
						--Misc.doBombExplosion(v.x,v.y,3)
						v:kill()
					end
				elseif v.id == 171 then
					v.speedY = 0;
					v.y = v:mem(0xB0,FIELD_DFLOAT);
					v.speedX = v.speedX + (0.7 * v:mem(0xEC,FIELD_FLOAT))
					if colliders.collideBlock(v, Block.SOLID..Block.NONSOLID..Block.LAVA..Block.PLAYER, blockFilter) then
						v:kill(9)
						Animation.spawn(108, v.x, v.y)
						missileHit = Audio.SfxOpen(pm.getSound(CHARACTER_SAMUS, sfx_missileHit))
						Audio.SfxPlayCh(16, missileHit, 0)
					end
					if v.speedX >= 35 or v.speedX <= -35 then
						Animation.spawn(108, v.x, v.y)
						--Misc.doBombExplosion(v.x,v.y,3)
						v:kill()
					end
				end
			end
		end
		
		player:mem(0x0E, FIELD_WORD, 1)
		player:mem(0x10, FIELD_WORD, 0)
		if player.powerup == 6 then
			player:mem(0x162, FIELD_WORD, 19)
		else
			player:mem(0x162, FIELD_WORD, 0)
		end
		if player.powerup == 5 then
			Defines.jumpheight = 30
			Defines.jumpheight_bounce = 30
		else
			Defines.jumpheight = nil
			Defines.jumpheight_bounce = nil
		end
		
		if (player:mem(0x146, FIELD_WORD) == 0) and (player:mem(0x48, FIELD_WORD) == 0) and (player.powerup == 4 or player.powerup == 5) then
			if player:mem(0x40, FIELD_WORD) ~= 3 then
				if not hasJumped then
					canJump = true
					hasJumped = true
					hasJumpedCounter = 0
				end
			else
				canJump = false
				hasJumped = false
			end
		else
			canJump = false
			hasJumped = false
		end
		-- Some cleanup
		state.lastPlayerX = player.x
		state.lastPlayerY = player.y
		state.wasOnFloor = state.onFloor
		
		for _, q in pairs(NPC.getIntersecting(player.x-4, player.y-4, player.x + player.width + 4, player.y + player.height + 4)) do
			if q.id == 31 then
				q:kill()
				player:mem(0x12,FIELD_WORD,1)
				playSFX(84)
			end
		end
		
		winstate = Level.winState()
		
		for _, q in pairs(BGO.getIntersecting(player.x-4, player.y-4, player.x + player.width + 4, player.y + player.height + 4)) do
			if q.id == 35 and player:mem(0x12,FIELD_WORD) == 1 and winstate == 0 then
				Level.winState(3)
				Audio.SeizeStream(-1)
				playSFX(31)
			end
		end

	end
end

function samus.morphBallOnLoop()
	state.rotationAmount = (state.rotationAmount + state.xMovementAmount / 12)
	local t = pm.getGraphic(CHARACTER_SAMUS, ballTable[player.powerup]);
	--Temporarily use camera position rather than sceneCoords because sceneCoords is slightly broken
	local cam = camera
	local p = -25;
	if(player.forcedState == 3) then
		p = -65.1;
	end
	imagic.Draw{texture = t, align=imagic.ALIGN_CENTRE, x = player.x + t.width*0.5 - cam.x, y = player.y + 12 - cam.y, rotation = state.rotationAmount*57.2957795131, priority = p}
	--drawImageRotated(pm.getGraphic(CHARACTER_SAMUS, ballTable[player.powerup]), player.x+player.speedX, player.y+player.speedY, 24, 24, state.rotationAmount)
end

-------------------
-- onInputUpdate --
-------------------

local function UpdateMorphBall()
	if (state.isMorphBall) then
		local ballini = pm.resolveIni("samus-ball.ini");
		if(ballini) then
			for i = 1,7 do
				Misc.loadCharacterHitBoxes(5, i, ballini);
			end
		end
	else
		for i = 1,7 do
			local ini = pm.resolveIni("samus-"..i..".ini");
			if(ini) then
				Level.loadPlayerHitBoxes(5, i, ini)
			end
		end
	end
end

function samus.setMorph(val)
	state.isMorphBall = val;	
	UpdateMorphBall();
end

function megashroom.onEnterMega(plyr)
	if (plyr.character == CHARACTER_SAMUS) then
		if(state.isMorphBall) then
			state.isMorphBall = false;	
			local ps = PlayerSettings.get(CHARACTER_LINK, plyr.powerup);
			local h = ps.hitboxHeight;
			local w = ps.hitboxWidth;
			UpdateMorphBall();
			ps = PlayerSettings.get(CHARACTER_LINK, plyr.powerup);
			local h2 = ps.hitboxHeight;
			local w2 = ps.hitboxWidth;
			plyr.x = plyr.x+(w-w2)
			plyr.y = plyr.y+(h-h2)
			megashroom.ForceReloadMega(plyr);
		end
	end
end

function pm.onCostumeChange(playerID, newCostume)
	if(playerID == CHARACTER_SAMUS and player.character == CHARACTER_SAMUS) then
		UpdateMorphBall();
	end
end

local wasDownKeyPressing = false
local wasJumpKeyPressing = false
local wasRunKeyPressing = false
function samus.onInputUpdate()
	if (player.character == CHARACTER_SAMUS) then
		pm.winStateCheck()
		if player.keys.jump == KEYS_PRESSED and (player.powerup == 4 or player.powerup == 5) and hasJumpedCounter < 5 and canJump then
			player.speedY = -7
			hasJumpedCounter = hasJumpedCounter + 1
			twirl = Audio.SfxOpen(pm.getSound(CHARACTER_SAMUS, sfx_twirl))
			Audio.SfxPlayCh(16, twirl, 0)
		end
	end
	
	if Misc.isPaused() then return end
	
	local nextWasDownKeyPressing = player.downKeyPressing
	local nextWasJumpKeyPressing = player.jumpKeyPressing
	local nextWasRunKeyPressing = player.runKeyPressing

	if (player.character == CHARACTER_SAMUS) then
		checkHealth()
		
		if messaged == false then
			if (state.isMorphBall) then
				if (player.runKeyPressing and not wasRunKeyPressing) then
					samus.dropBomb()
				end
				
				if (player.jumpKeyPressing and not wasJumpKeyPressing and player.powerup == 5 and player:mem(0x146,FIELD_WORD) == 2) then
					player.speedY = -10;
				end
			
				player.jumpKeyPressing = false
				player.altJumpKeyPressing = false
				player.runKeyPressing = false
				player.altRunKeyPressing = false
				player.upKeyPressing = false
			else
				if (player.runKeyPressing and not wasRunKeyPressing and player.forcedState == 0) then
					samus.fireGun()
				end
			
				-- Normal mode
				player.runKeyPressing = false
				player.altRunKeyPressing = false
			end
			
			local downwarp = checkDownWarp()
			local ceiling = false
			if state.isMorphBall then
				ceiling = checkForCeiling()
			end
			
			if (player.downKeyPressing and not wasDownKeyPressing and downwarp ~= true and player.forcedState == 0 and ceiling == false) then
				state.isMorphBall = not state.isMorphBall
				UpdateMorphBall();
			end
			if downwarp ~= true then
				player.downKeyPressing = false
			end
		end
	end
	
	for _, warp in pairs(Warp.getIntersectingEntrance(player.x - .5 * player.width, player.y - .5 * player.height, player.x + 1.5 * player.width, player.y + 1.5 * player.height)) do
		if player:mem(0x12,FIELD_WORD) == 1 and warp:mem(0x00,FIELD_WORD) ~= 0 then
			warp:mem(0x00,FIELD_WORD,0)
			player:mem(0x12,FIELD_WORD,0)
		end
	end
	
	wasJumpKeyPressing = nextWasJumpKeyPressing
	wasDownKeyPressing = nextWasDownKeyPressing
	wasRunKeyPressing = nextWasRunKeyPressing
end

--ON MESSAGE BOX

function samus.onMessageBox(eventObj, message)
	messaged=true
end

---------
-- GUN --
---------

local shots = {}
function samus.fireGun()
	if messaged == false then
		local dir = player:mem(0x106, FIELD_WORD)
		for idx=#shots,1,-1 do
			local oldShot = shots[idx]
			if not oldShot.isValid then
				table.remove(shots, idx)
			end
		end
		if (#shots >= 5) then
			return
		end

		
		local x = player.x
		local y = player.y + player.height/2 - 5
		if (dir >= 0) then
			x = x + player.width
		end
		
		local npcid = playerBullets[player.powerup]
		--npcid = 13
		local shot = spawnNPC(npcid, x, y, player.section, false, true)
		table.insert(shotNPCs, shot);
		if player.powerup == 5 then
			if (dir >= 0) then
				shot.speedX = 9
			else
				shot.speedX = -9
			end
		else
			if (dir >= 0) then
				shot.speedX = 5
			else
				shot.speedX = -5
			end
		end
		--Sound Effects
		if player.powerup == 2 or player.powerup == 4 or player.powerup == 5 then
			shoot = Audio.SfxOpen(pm.getSound(CHARACTER_SAMUS, sfx_shoot))
			Audio.SfxPlayCh(16, shoot, 0)
		end
		if player.powerup == 3 or player.powerup == 6 then
			missileshoot = Audio.SfxOpen(pm.getSound(CHARACTER_SAMUS, sfx_shootmissile))
			Audio.SfxPlayCh(16, missileshoot, 0)
		end
		if player.powerup == 7 then
			ice = Audio.SfxOpen(pm.getSound(CHARACTER_SAMUS, sfx_shootice))
			Audio.SfxPlayCh(16, ice, 0)
		end
			
		
		playSFX(77)
		table.insert(shots, shot)
	end
end

-----------
-- Bombs --
-----------
local bombs = {}
function samus.dropBomb()
	if messaged == false then
		if #bombs >= 3 then
			return
		end

		local bomb = {}
		bomb.x = player.x + 12
		bomb.y = player.y + 12
		bomb.section = player.section
		bomb.tick = 0
		
		table.insert(bombs, bomb)
	end
end

local function onBombTick(bomb)
	bomb.tick = bomb.tick + 1
	
	if (bomb.tick > 60) then
		-- Explode!
		playSFX(64)
		Animation.spawn(108, bomb.x, bomb.y)
		
		-- Bombjump!
		if (state.isMorphBall) then
			local dx = (player.x + 12) - bomb.x
			local dy = (player.y + 12) - bomb.y
			local dsq = dx*dx + dy*dy
			if (dsq < 32*32) then
				player.speedY = -8
			end
		end
		
		-- NPC interactions
		for _, hurtableNPC in pairs (NPC.getIntersecting(bomb.x-32, bomb.y-32, bomb.x+32, bomb.y+32)) do
			if (not hurtableNPC.isHidden) and (not hurtableNPC:mem(0x64, FIELD_BOOL)) then
				if NPC.HITTABLE_MAP[hurtableNPC.id] and not hurtableNPC.friendly then
					hurtableNPC:kill(3)
				end
				if hurtableNPC.id == 45 or hurtableNPC.id == 159 then
					hurtableNPC:kill()
				end
				if hurtableNPC.id == 241 then
					hurtableNPC:kill()
					Misc.doPOW()
				end
				if hurtableNPC.id == 154 or hurtableNPC.id == 155 or hurtableNPC.id == 156 or hurtableNPC.id == 157 or hurtableNPC.id == 158 then
					hurtableNPC.speedX = rng.randomInt(1,4) * player:mem(0x106,FIELD_WORD); 
					hurtableNPC.speedY = -4;
				end
				if hurtableNPC.id == 92 or hurtableNPC.id == 139 or hurtableNPC.id == 140 or hurtableNPC.id == 141 or hurtableNPC.id == 142 or hurtableNPC.id == 143 or hurtableNPC.id == 144 or hurtableNPC.id == 145 or hurtableNPC.id == 146 then
					hurtableNPC.speedX = rng.randomInt(1,6) * player:mem(0x106,FIELD_WORD); 
					hurtableNPC.speedY = -7;
				end
				if hurtableNPC.id == 91 then
					butts = NPC.spawn(hurtableNPC:mem(0xF0,FIELD_DFLOAT),hurtableNPC.x,hurtableNPC.y-32,player.section)
					butts.speedX = rng.randomInt(-2,2)
					hurtableNPC:kill()
					playSFX(88)
				end
			end
		end
		-- Explode/hit some blocks
		for _,block in pairs(Block.getIntersecting(bomb.x-32, bomb.y-32, bomb.x+32, bomb.y+32)) do
			local blockid = block.id
			if (blockid == 4) or (blockid == 526) or (blockid == 188) or (blockid == 60) or (blockid == 226) or (blockid == 293) or (blockid == 370) then
				if block.contentID ~= 0 then
					block:hit()
				else
					block:remove(true)
				end
			end
			if (blockid == 5) or (blockid == 193) or (blockid == 88) or (blockid == 90) or (blockid == 224) then
				block:hit()
			end
		end
		
		return true
	end
	
	local frame = math.floor(bomb.tick / 6) % 4
	Graphics.drawImageToSceneWP(pm.getGraphic(CHARACTER_SAMUS, bombImg), bomb.x-8, bomb.y-8, 0, frame*16, 16, 16, -45)
	
	
	return false -- Don't remove
end

function samus.onBombLoop()
	for idx=#bombs,1,-1 do
		local bomb = bombs[idx]
		if onBombTick(bomb) then
			-- Remove...
			table.remove(bombs, idx)
		end
	end
end

function samus.onDraw()
	local i = 1;
	while i <= #shotNPCs do
		if(shotNPCs[i].isValid) then
			local v = shotNPCs[i];
			if(v.id == 171) then
				v.speedY = 0;
				v.y = v:mem(0xB0,FIELD_DFLOAT);
			end
			local frame = v.animationFrame + NPC.config[v.id].frames*(math.max(v.direction,0));
			if(shotData[v.id].frames ~= nil) then
				if(v.data.frame == nil) then
					v.data.frame = 0;
					v.data.framecounter = 8;
				end
				v.data.framecounter = v.data.framecounter - 1;
				if(v.data.framecounter == 0) then
					v.data.frame = (v.data.frame + 1)%shotData[v.id].frames;
					v.data.framecounter = 8;
				end
				frame = v.data.frame + shotData[v.id].frames*(math.max(v.direction,0));
			end
			local x = v.x+(v.width - shotData[v.id].width)*0.5;
			local y = v.y+(v.height - shotData[v.id].height)*0.5;
			
			v.animationFrame = 99;
			Graphics.draw{type=RTYPE_IMAGE, x = x, y = y, isSceneCoordinates = true, image = pm.getGraphic(CHARACTER_SAMUS,shotData[v.id].img), sourceX = 0, sourceY = frame*shotData[v.id].height, sourceWidth = shotData[v.id].width, sourceHeight = shotData[v.id].height, priority = -45};
			
			i = i + 1;
		else
			table.remove(shotNPCs,i);
		end
	end
end

------------------
-- Random Drops --
------------------
function samus.onNPCKill(eventObj, killingNPC, killReason)
	if (killReason == 10 or killReason == 1 or killReason == 2 or killReason == 3) and player.character == CHARACTER_SAMUS and NPC.HITTABLE_MAP[killingNPC.id] then
		randValue = rng.randomInt(1, 10)
		if (randValue == 1) then
			NPC.spawn (250, killingNPC.x, killingNPC.y, player.section)
		end
	end
end

-----------------
-- onExitLevel --
-----------------

function samus.onExitLevel()
end

----------------------
-- Init and Cleanup --
----------------------

function samus.initCharacter()
	initDataStorage()
	
	-- CLEANUP NOTE: This is not safe if a level makes it's own use of activateHud
	HUDOverride.visible.keys = true
	HUDOverride.visible.bombs = true
	HUDOverride.visible.coins = true
	HUDOverride.visible.score = false
	HUDOverride.visible.lives = false
	HUDOverride.visible.stars = true
	HUDOverride.visible.starcoins = false
	HUDOverride.visible.timer = true
	HUDOverride.visible.levelname = true
	HUDOverride.visible.overworldPlayer = true
	
	-- CLEANUP NOTE: This is not quite safe in various cases
	Defines.player_link_shieldEnabled = false
	
	-- CLEANUP NOTE: This is not safe if a level makes it's own use of jumpheight
	if player.powerup == 5 then
		Defines.jumpheight = 30
		Defines.jumpheight_bounce = 30
	else
		Defines.jumpheight = nil
		Defines.jumpheight_bounce = nil
	end
end

function samus.cleanupCharacter()
	initDataStorage()
	
	HUDOverride.visible.keys = true
	HUDOverride.visible.bombs = true
	HUDOverride.visible.coins = true
	HUDOverride.visible.score = false
	HUDOverride.visible.lives = false
	HUDOverride.visible.stars = true
	HUDOverride.visible.starcoins = false
	HUDOverride.visible.timer = true
	HUDOverride.visible.levelname = true
	HUDOverride.visible.overworldPlayer = true
	
	-- CLEANUP NOTE: This is not quite safe in various cases
	Defines.player_link_shieldEnabled = true
	
	-- CLEANUP NOTE: This is not safe if a level makes it's own use of jumpheight
	Defines.jumpheight = nil
	Defines.jumpheight_bounce = nil
end

------------
-- Output --
------------
return samus
