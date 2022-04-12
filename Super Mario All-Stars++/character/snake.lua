--solidsnake.lua
--v1.0.0
--Created by Hoeloe, 2015
--Find Hoeloe at https://www.youtube.com/user/Hoeloe42

--[[
Things to fix:
- The camera vision cones on level seem to crach the game.
]]

if Player(2) and Player(2).isValid then return end

local colliders = require("colliders")
local rng = require("rng");
local vectr = require("vectr")
local vision = require("visioncone")
local panim = require("playeranim")
local textplus = require("textplus")
local pm = require("playerManager")
local defs = require("expandedDefines")

local snake = {}

_G.CHARACTER_SNAKE = CHARACTER_SNAKE

--Generated enemy vision cone info
local visioncones = {}

snake.enemies = {}

local enemylist = {1, 2, 3, 4, 6, 19, 20, 23, 25, 27, 28, 29, 36, 39, 42, 49, 53, 54, 55, 59, 61, 63, 
65, 71, 72, 76, 77, 89, 109, 110, 111, 112, 117, 118, 119, 120, 121, 122, 123, 124, 125, 129, 130, 131, 132, 
135, 136, 161, 162, 164, 165, 167, 173, 175, 176, 177, 204, 229, 230, 232, 233, 234, 236, 242, 243, 244, 285, --[[296,]] 299}

local FONT = {priority = 5, xscale=1, yscale=1, font = textplus.loadFont("textplus/font/6.ini")}

--Customisable settings for specific NPCs. Default is "snake.visionSettings[npcID] = {length = 256, angle = 30, height = 8}"
snake.visionSettings = {}

--Load graphics
snake.EXCLAMATION = pm.registerGraphic(CHARACTER_SNAKE, "exclaim.png")
snake.HUD_CAMO = pm.registerGraphic(CHARACTER_SNAKE, "camo.png")
snake.HUD_POWER_ARMOUR = pm.registerGraphic(CHARACTER_SNAKE, "power_armour.png")
snake.HUD_POWER_C4 = pm.registerGraphic(CHARACTER_SNAKE, "power_c4.png")
snake.HUD_POWER_ATHLETIC = pm.registerGraphic(CHARACTER_SNAKE, "power_athletic.png")
snake.HUD_POWER_BOX = pm.registerGraphic(CHARACTER_SNAKE, "power_box.png")
snake.HUD_POWER_GRENADE = pm.registerGraphic(CHARACTER_SNAKE, "power_grenade.png")
snake.HUD_POWER_MK22 = pm.registerGraphic(CHARACTER_SNAKE, "power_mk22.png")

local sfx_alert = pm.registerSound(CHARACTER_SNAKE, "snake_alert.ogg")

--Set to false to disable drawing vision cones on enemies - Huge performance saving
snake.drawCones = true;

--Data for enemy spawns
local exclamations = {}
local spawningsources = {}

--Alert cooldown timers
snake.alertTimer = 0;
snake.alertCooldown = 600;

--Lists of spawned objects NOTE: when converting to lua-only object, use these to store the data
local c4;
local grenades = {};
local mk22;

-- Other stuff
local playerDirection = -1;
local sleepIcon = pm.registerGraphic(CHARACTER_SNAKE, "zzz.png")
local mkBullet = pm.registerGraphic(CHARACTER_SNAKE, "mk22bullet.png")
local useCamera = camera
local climbtime = 6;
local climbTimer = climbtime;

--Does a table contain a specific object
local function contains(a,b)
	if(type(a) == 'number') then return a == b; end
	for _,v in ipairs(a) do
		if(v == b) then
			return true;
		end
	end
	return false;
end

function snake.onInitAPI()
	registerEvent(snake, "onTick", "onTick", false)
	registerEvent(snake, "onDraw", "onDraw", false)
	registerEvent(snake, "onInputUpdate", "onInputUpdate", false)
	registerEvent(snake, "onJump", "onJump", true)
	registerEvent(snake, "onJumpEnd", "onJumpEnd", false)
	
	--Force hearts to 1 if the player starts as Snake
	if (player.isValid) then
		if (player.character == CHARACTER_SNAKE) then
			player:mem(0x16, FIELD_WORD, 1)
		end
	end
	
	for k,v in pairs(enemylist) do
		snake.enemies[v]=true 
	end
end

--Destroy the C4 object
local function killc4()
	--Tweak bob-omb timer to make it explode
	c4:mem(0xF8,FIELD_DFLOAT,1);
	c4.friendly = false;
	c4:mem(0xF0,FIELD_DFLOAT,349);
	c4 = nil;
end

local function npcfilter(v)
	return not v.friendly and not v.isHidden and snake.enemies[v.id];
end

--Disable up and down slash
function snake.onInputUpdate()
	if (player.character == CHARACTER_SNAKE) then
		--Powerup handling
		pm.winStateCheck()
		--Pressed Tanuki and not climbing
		if (player.keys.run == KEYS_PRESSED) and player:mem(0x114,FIELD_WORD) ~= 11 and player:mem(0x114,FIELD_WORD) ~= 10 and player:mem(0x40,FIELD_WORD) ~= 3 then
			if(player.powerup == PLAYER_FIREFLOWER) then
				if(c4 == nil) then
					--Spawn new C4 object
					if(player:mem(0x146,FIELD_WORD) ~= 0 or player:mem(0x48,FIELD_WORD) ~= 0) then
						c4 = NPC.spawn(137,player.x,player.y+player.height-32,player.section);
						c4.friendly = true;
					end
				else
					--Destroy C4 object
					killc4();
				end
			elseif(player.powerup == PLAYER_HAMMER) then
				local yoffset = 0;
				if(player:mem(0x12E,FIELD_WORD) == -1) then --player is crouching
					yoffset = 8;
				end
				--Spawn peachbomb (grenade)
				local n =  NPC.spawn(291,player.x+player.width/2,player.y+yoffset,player.section);
				n.speedX = player:mem(0x106,FIELD_WORD)*7;
				n.speedY = -2;
				table.insert(grenades,n);
			elseif(player.powerup == PLAYER_ICE) and mk22 == nil then
				playerDirection = player:mem(0x106,FIELD_WORD);
				playSFX(83)
				mk22 = {}
				mk22.speedX = 1.5 * playerDirection
				mk22.box = colliders.Box(player.x + (player.width*0.5),player.y + (player.height*0.5) - 8,16,8);
				if playerDirection == 1 then
					mk22.offset = 8;
				else
					mk22.offset = 0;
				end
			end
		end
		if(Misc.isPaused()) then
			return;
		end
		if((player.jumpKeyPressing or player.altJumpKeyPressing) and player:mem(0x60,FIELD_WORD) ~= -1) then
			--player.upKeyPressing = false;
		end
		if(player:mem(0x146,FIELD_WORD) == 0 and player:mem(0x48,FIELD_WORD) == 0 and (player:mem(0x40, FIELD_WORD) ~= 3 and player:mem(0x40, FIELD_WORD) ~= 2)) then
			player.downKeyPressing = false;
		end
	end
end

--Is snake visible to enemeies (i.e. not in Tanuki box)
function snake.canAlert()
	return player.isValid and player:mem(0x4A, FIELD_WORD) == 0;
end

--Alert that Snake has been seen and create a new enemy spawning object
function snake.alert(source, spawnid)
	if(snake.canAlert()) then
		table.insert(spawningsources, {source = source, id = spawnid})
		snake.alertTimer = snake.alertCooldown;
	end
end

function snake.onTick()
	if(c4 ~= nil and c4.isValid) then
		c4:mem(0xF0,FIELD_DFLOAT,0); --Make C4 perpetual
		if(player.character ~= CHARACTER_SNAKE or player.powerup ~= PLAYER_FIREFLOWER) then	--Destroy C4 if the player changes character or powerup
			killc4();
		end
	end
	
	if c4 and c4.isValid then
		c4:mem(0x12A, FIELD_WORD, 180)
	else
		c4 = nil
	end
	
	--[[Text.print((#mk22),100,100)
	if (mk22[1]) ~= nil then
		Text.print(mk22[1].x,100,118)
	end]]--
	
	if (player.character == CHARACTER_SNAKE) then
		--Stop leaf powerup from floating down (allows the "armour" graphic to make sense)
		for k,v in ipairs(NPC.get(34, player.section)) do
			v.speedY = 0;
		end
	
		player:mem(0x10, FIELD_WORD, 0) --Disable fairy
		
		--Disable projectiles and more fairly cases
		player:mem(0x162, FIELD_WORD, 19)
		player:mem(0x0E, FIELD_WORD, 1)
		
		--Set player direction variable
		playerDirection = player:mem(0x106,FIELD_WORD)
		
		--Jump height
		Defines.jumpheight = 20
		
		--Cap to 2 hearts
		if(player:mem(0x16, FIELD_WORD) > 2) then
			player:mem(0x16, FIELD_WORD,2)
		end
		
		--Create vision cones, do mk22 stuff
		for k,v in ipairs(NPC.get()) do
			if(snake.enemies[v.id] == true and not v.friendly) and not v.isHidden and (not v:mem(0x64, FIELD_BOOL)) then
				local npc = v;
				if(npc.data.snake == nil) then
					npc.data.snake = {}
				end
				if(visioncones[npc.uid] == nil) then
					--Create default visionSettings for this NPC
					if (snake.visionSettings[npc.id] == nil) then
						snake.visionSettings[npc.id] = {length = 256, angle = 30, height = 8};
					end
					--Use existing visionSettings to create a vision cone and necessary extra information
					if (snake.visionSettings[npc.id] ~= nil) and (npc.data.snake.timer == nil) then
						visioncones[npc.uid] = {cone = vision.VisionCone(npc.x+ npc.width/2, npc.y+snake.visionSettings[npc.id].height, snake.visionSettings[npc.id].length * npc.direction * vectr.right2, snake.visionSettings[npc.id].angle), npc = npc};
					end
				end
				
				if npc.data.snake.x ~= nil then
					if npc.data.snake.timer > 0 then
						npc.data.snake.timer = npc.data.snake.timer - 1;
						Graphics.drawImageToSceneWP(pm.getGraphic(CHARACTER_SNAKE, sleepIcon),v.x,v.y-32,0,(npc.data.snake.zoffset)*32,32,32,-45)
						v.x = npc.data.snake.x;
						v.speedY = 0;
					end
					npc.data.snake.ztimer = npc.data.snake.ztimer + 1;
					if npc.data.snake.ztimer%4 == 0 then
						npc.data.snake.zoffset = npc.data.snake.zoffset + 1;
						npc.data.snake.ztimer = 0;
						if npc.data.snake.zoffset > 20 then
							npc.data.snake.zoffset = 0;
						end
					end
					if npc.data.snake.timer == 0 then
						if(visioncones[npc.uid] == nil) then
							visioncones[npc.uid] = {cone = vision.VisionCone(npc.x+ npc.width/2, npc.y+snake.visionSettings[npc.id].height, snake.visionSettings[npc.id].length * npc.direction * vectr.right2, snake.visionSettings[npc.id].angle), npc = npc};
						end
					end
				end
			end
		end
		
		-- mk22
		if(mk22 ~= nil) then
			mk22.box.x = mk22.box.x + mk22.speedX;

			local _,_,npcCollisions = colliders.collideNPC(mk22.box, NPC.HITTABLE, player.section, npcfilter);
			for _,v in ipairs(npcCollisions) do
				playSFX(38)
				local a = Animation.spawn(63,mk22.box.x+mk22.box.width*0.5,mk22.box.y+mk22.box.height*0.5);
				a.x = a.x-a.width*0.5;
				a.y = a.y-a.height*0.5;
				mk22 = nil;
				local npc = v;
				if(npc.data.snake == nil) then
					npc.data.snake = {}
				end
				npc.data.snake.x = v.x;
				npc.data.snake.timer = 360;
				npc.data.snake.ztimer = 0;
				npc.data.snake.zoffset = 0;
				break;
			end
			
			if(mk22 ~= nil) then
				local _,_,blockCollisions = colliders.collideBlock(mk22.box, colliders.BLOCK_SOLID..colliders.BLOCK_LAVA..colliders.BLOCK_HURT..colliders.BLOCK_PLAYER)
				for k,h in ipairs(blockCollisions) do
					if not h.isHidden then
						local a = Animation.spawn(10,mk22.box.x+mk22.box.width*0.5,mk22.box.y+mk22.box.height*0.5);
						a.x = a.x-a.width*0.5;
						a.y = a.y-a.height*0.5;
						mk22 = nil;
						break;
					end
				end
						
				if mk22 ~= nil and (mk22.box.x > useCamera.x+800 or mk22.box.x < useCamera.x-mk22.box.width or mk22.box.y > useCamera.y+600 or mk22.box.y < useCamera.y-mk22.box.height) then
					mk22 = nil;
				end
			end
		end
		
		--Count down alert timer
		if(snake.alertTimer > 0) then
			if not (Defines.levelFreeze) then
				snake.alertTimer = snake.alertTimer - 1;
				
				--If alert timer runs out, reset enemy spawning
				if(snake.alertTimer == 0) then
					exclamations = {};
					spawningsources = {};
				end
			end
		end
		
		--Reset alert timer if all NPCs involved have been removed
		if(#spawningsources == 0) then
			snake.alertTimer = 0;
			exclamations = {};
		else
			for k,v in ipairs(spawningsources) do
				--Remove spawning NPC if it has been killed
				if (not v.source.isValid and v.source.isValid ~= nil) then
					table.remove(spawningsources, k);
				end
			end
			
			--Do enemy spawn
			if not (Defines.levelFreeze) then
				if(rng.randomInt((256*(snake.alertCooldown-snake.alertTimer)/snake.alertCooldown)+100) == 0) then --Pick random number weighted by alertness
					local source = rng.randomEntry(spawningsources); --Pick a random spawning source
					if(source.source._type == "Vector2" or source.source.isValid) then --Allow vectr objects or NPCs to act as spawn locations (Vectr objects allow non-NPCs to create spawning sources)
						local trySpawn = 0;
						local coords = nil;
						local w = 32;
						local h = 32;
						--Get width and height of the source if not a vectr object
						if(source.source._type ~= "Vector2") then
							w = source.source:mem(0x90,FIELD_DFLOAT);
							h = source.source:mem(0x88,FIELD_DFLOAT);
						end
						while(trySpawn < 10) do --try spawning a limited number of times until a space is found that is not inside a block.
							coords = {x = source.source.x + rng.randomInt(-128,128), y = source.source.y - rng.randomInt(-32,64)};
							if(colliders.collideBlock(colliders.Box(coords.x, coords.y, w, h), colliders.BLOCK_SOLID)) then
								coords = nil;
								trySpawn = trySpawn + 1;
							else
								break;
							end
							
						end
						
						--If valid coordinates were found, spawn an NPC
						if (coords ~= nil) then
							--Spawn new NPC, and automatically set that NPC to be alerted to Snake's presence
							local n = NPC.spawn(source.id, coords.x, coords.y, player.section)
							Animation.spawn(10,n.x+n.width/2,n.y+n.height/2);
							table.insert(spawningsources, {source = n, id = n.id});
							exclamations[n.uid] = {t = 0, x = n.x, y = n.y};
						end
					end
				end
			end
		end
			
		--Update vision cones
		for k,v in pairs(visioncones) do
			if(v.npc.isValid and not v.npc.friendly and snake.visionSettings[v.npc.id] ~= nil and v.cone ~= nil and (v.npc.data.snake.timer == nil or v.npc.data.snake.timer == 0) and v.npc:mem(0x12A,FIELD_WORD)>1) then
			
				--Set vision cone location and direction
				v.cone.x = v.npc.x + v.npc.width/2;
				v.cone.y = v.npc.y+snake.visionSettings[v.npc.id].height;
				v.cone.direction = snake.visionSettings[v.npc.id].length * v.npc.direction * vectr.right2;
				--v.cone.collider:Draw(0xFF990033);
				
				--Check and draw vision cones
				if(player.isValid and v.cone:Check(player,v.cone.fov*0.6,nil,snake.drawCones) and player:mem(0x4A, FIELD_WORD) == 0) and not (Defines.levelFreeze) then
					--Create exclamation object and alert to Snake's presence
					if(exclamations[v.npc.uid] == nil) then
						exclamations[v.npc.uid] = {t = 65, x = v.npc.x, y = v.npc.y - 48};
						Audio.playSFX(pm.getSound(CHARACTER_SNAKE, sfx_alert))
						snake.alert(v.npc, v.npc.id);
					end
					snake.alertTimer = snake.alertCooldown;
				end
			else
				--If the NPC is no longer valid, remove the vision cone
				visioncones[k] = nil;
			end
		end
		
		--Update exclamation objects, so that they follow NPCs and will disappear after a set time
		for k,v in pairs(exclamations) do
			if(v.t > 0) then
				v.t = v.t-1;
				if(visioncones[k] ~= nil and visioncones[k].npc.isValid) then
					v.x =  visioncones[k].npc.x;
					v.y =  visioncones[k].npc.y - 48;
				end
				Graphics.drawImageToSceneWP(pm.getGraphic(CHARACTER_SNAKE, snake.EXCLAMATION), v.x, v.y, -45);
			end			
		end
		
	end
end

--Draw the HUD
function snake.onDraw()
		if(player.character == CHARACTER_SNAKE) then
		
			--We be climbing
			if((player:mem(0x40, FIELD_WORD) == 3 or player:mem(0x40, FIELD_WORD) == 2) and (panim.getFrameRaw(player) == 10 or panim.getFrameRaw(player) == -10)) then
				if(climbTimer <= 0) then
					panim.setFrame(player,-10);
				else
					panim.setFrame(player,10);
				end
				
				if((player.upKeyPressing or player.downKeyPressing) and player:mem(0x40, FIELD_WORD) == 3) then
					climbTimer=climbTimer - 1;
					if(climbTimer == climbtime or climbTimer == 0) then
						playSFX(71)
					end
				end
				
				if(climbTimer <= -climbtime) then
					climbTimer = climbtime;
				end
			else
				climbTimer = climbtime;
			end
			--Draw alertness element
			Graphics.drawImageWP(pm.getGraphic(CHARACTER_SNAKE, snake.HUD_CAMO), 348, 12, -1.99999);
			local camo = tostring(math.ceil(100*(snake.alertCooldown-snake.alertTimer)/(snake.alertCooldown)));
			--textblox.printExt("%",{x=774,y=38,font=textblox.FONT_SPRITEDEFAULT3, z=5});
			Text.printWP(camo,1,400-#camo*18 - 8,46,-5)
			
			--Draw powerup elements
			if(player:mem(0x16, FIELD_WORD) > 1 and player.forcedState ~= 1 and player.forcedState ~= 4) then
				local power = {label = "", graphic = snake.HUD_POWER_ARMOUR}
				if(player.powerup <= PLAYER_BIG) then
					power.label = "BODY ARMOR";
					power.graphic = snake.HUD_POWER_ARMOUR;
				elseif(player.powerup == PLAYER_FIREFLOWER) then
					power.label = "C4";
					power.graphic = snake.HUD_POWER_C4;
				elseif(player.powerup == PLAYER_LEAF) then
					power.label = "ATHLETIC ARMOR";
					power.graphic = snake.HUD_POWER_ATHLETIC;
				elseif(player.powerup == PLAYER_TANOOKIE) then
					power.label = "STEALTH BOX";
					power.graphic = snake.HUD_POWER_BOX;
				elseif(player.powerup == PLAYER_HAMMER) then
					power.label = "GRENADES";
					power.graphic = snake.HUD_POWER_GRENADE;
				elseif(player.powerup == PLAYER_ICE) then
					power.label = "MK22";
					power.graphic = snake.HUD_POWER_MK22;
				end
				Graphics.drawImageWP(pm.getGraphic(CHARACTER_SNAKE, power.graphic), 400, 12, -5);
				FONT.text = power.label
				FONT.x=398
				FONT.y=48
				FONT.maxWidth=65
				FONT.priority = -5
				textplus.print(FONT)
			end
			
			--Draw mk22
			if(mk22 ~= nil) then
				Graphics.drawImageToSceneWP(pm.getGraphic(CHARACTER_SNAKE, mkBullet),mk22.box.x,mk22.box.y,0,mk22.offset,mk22.box.width,mk22.box.height,-45)
			end
		end
end

function snake.initCharacter()
	-- CLEANUP NOTE: This is not safe if a level makes it's own use of activateHud
	--Graphics.activateHud(false)
	
	-- CLEANUP NOTE: This is not quite safe in various cases
	Defines.player_link_shieldEnabled = false
end

function snake.cleanupCharacter()
	-- CLEANUP NOTE: This is not safe if a level makes it's own use of activateHud
	--Graphics.activateHud(true)
	
	-- CLEANUP NOTE: This is not quite safe in various cases
	Defines.player_link_shieldEnabled = true
end

return snake;
