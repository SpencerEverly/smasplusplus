--zelda.lua
--v1.0.0
--Created by Horikawa Otane, 2015
--Contact me at https://www.youtube.com/subscription_center?add_user=msotane

--[[
Things to fix:
- Need a better way of handling the volume change (currently temporarily reroutes the Audio.MusicVolume function)
- Saving block state can break levels with moving layers
]]

local savestate = require("savestate")
local colliders = require("colliders")
local particles = require("particles")
local pm = require("playerManager")
--local graphx = require("graphX")

local zelda = {}

local state = nil
local isPlaying
local timeTravelAccess = true
local loopCounter = 0
local canTimeTravel = false
local hasSetPoint = false
local firstUseAvailable = true

local fluteused = pm.registerGraphic(CHARACTER_ZELDA,"fluteused.png")
local flute = pm.registerGraphic(CHARACTER_ZELDA,"flute.png")
local fluteready = pm.registerGraphic(CHARACTER_ZELDA,"fluteready.png")
local flutegrey = pm.registerGraphic(CHARACTER_ZELDA,"flutegrey.png")
local warpspotimg = pm.registerGraphic(CHARACTER_ZELDA,"warpspot.png")
local warporb = pm.registerGraphic(CHARACTER_ZELDA,"warporb.png")
local songring = pm.registerGraphic(CHARACTER_ZELDA,"songring.png")

local canTeleport = true
local canTeleportCounter = 50

local formerPowerup = nil
local currentPowerup = 1

local playerStates = {}

local warpspot = nil;
local warpframe = 0;
local warpanimtimer = 13;

local flashtimer = 0;

local ringtimer = 0;
local spawningRing = false;
local ringCol = {r=1,g=1,b=1,a=0.5};

local musicvolume = Audio.MusicVolume();


playerStates[1] = savestate.STATE_BLOCK
playerStates[2] = savestate.STATE_BLOCK
playerStates[3] = savestate.STATE_PLAYER
playerStates[4] = savestate.STATE_NPC
playerStates[5] = savestate.STATE_NPC
playerStates[6] = savestate.STATE_NPC
playerStates[7] = savestate.STATE_PLAYER

local playerSongs = {};
playerSongs[savestate.STATE_BLOCK] = "zelda_song2_";
playerSongs[savestate.STATE_PLAYER] = "zelda_song1_";
playerSongs[savestate.STATE_NPC] = "zelda_song3_";

for k,v in pairs(playerSongs) do
	pm.registerSound(CHARACTER_ZELDA, v.."1", v.."1.ogg");
	pm.registerSound(CHARACTER_ZELDA, v.."2", v.."2.ogg");
end

local songColours = {};
songColours[savestate.STATE_BLOCK] = {r=0,g=0.6,b=1,a=0.5};
songColours[savestate.STATE_PLAYER] = {r=1,g=0.5,b=0.7,a=0.5};
songColours[savestate.STATE_NPC] = {r=0,g=1,b=0.4,a=0.5};

local playerStateGraphic = {}

playerStateGraphic[1] = pm.registerGraphic(CHARACTER_ZELDA,"block.png")
playerStateGraphic[2] = playerStateGraphic[1]
playerStateGraphic[3] = pm.registerGraphic(CHARACTER_ZELDA,"zelda.png")
playerStateGraphic[4] = pm.registerGraphic(CHARACTER_ZELDA,"npc.png")
playerStateGraphic[5] = playerStateGraphic[4]
playerStateGraphic[6] = playerStateGraphic[4]
playerStateGraphic[7] = playerStateGraphic[3] 

Graphics.registerCharacterHUD(CHARACTER_ZELDA, Graphics.HUD_ITEMBOX)

local teleportTrail = particles.Ribbon(0,0,Misc.resolveGraphicsFile("zelda\\teleportTrail.ini"));
local teleportEmitting = 0;
local teleportTarget = nil;
local teleportStart = nil;
local teleportOrbTimer = 0;
local teleportCollider = colliders.Box(0,0,0,0);
local teleportTime = 8;
local teleportHeight = 128;
local teleportDoJump = false;

local sfx_warp = pm.registerSound(CHARACTER_ZELDA, "zelda_warp.ogg");

local ocarinaChannel;
local rawMusVol = Audio.MusicVolume;

local function musvol(volume)
	if(volume == nil) then
		return 20;
	else
		musicvolume = volume;
	end
end

local function playASong(songName)
	Audio.SeizeStream(player:mem(0x15A, FIELD_WORD));
	musicvolume = Audio.MusicVolume();
	Audio.MusicVolume(20)
	Audio.MusicVolume = musvol;
	savesound = Audio.SfxOpen(songName)
	if(ocarinaChannel ~= nil) then
		ocarinaChannel:Stop();
	end
	ocarinaChannel =  Audio.SfxPlayObj(savesound, 0);
	spawningRing = true;
	ringCol = songColours[playerStates[player.powerup]];
	isPlaying = true
end

function zelda.onInitAPI()
	registerEvent(zelda, "onInputUpdate", "onInputUpdate", false)
	registerEvent(zelda, "onTick", "onTick", false)
	registerEvent(zelda, "onJump", "onJump", false)
	registerEvent(zelda, "onJumpEnd", "onJumpEnd", false)
	registerEvent(zelda, "onDraw", "onDraw", false)
	teleportTrail.enabled = false;
end

function zelda.onDraw()
	if(teleportEmitting > 0) then
		teleportTrail.x = player.x + player.width*0.5;
		teleportTrail.y = player.y + (player.height*(teleportEmitting)/(teleportTime));
		--windowDebug("butts")
		if not Misc.isPaused() then
			teleportTrail:Emit(1);
			teleportEmitting = teleportEmitting - 1;
		end
		if(teleportEmitting == 0) then
			teleportTrail:Break();
			teleportDoJump = true;
		end
	end
	if (#teleportTrail.segments > 0) then
		teleportTrail:Draw(-26);
	end
	if(teleportEmitting > 0) then
		teleportOrbTimer = 15;
	end
	
	if(teleportOrbTimer > 0) then
		local a = teleportOrbTimer/15;
		Graphics.glDraw{
						priority=-25, 
						vertexCoords = {player.x+player.width*0.5-32,player.y+player.height*0.5-32,player.x+player.width*0.5+32,player.y+player.height*0.5-32,player.x+player.width*0.5+32,player.y+player.height*0.5+32,player.x+player.width*0.5-32,player.y+player.height*0.5+32},
						primitive = Graphics.GL_TRIANGLE_FAN,
						vertexColors = {a,a,a,0,a,a,a,0,a,a,a,0,a,a,a,0},
						textureCoords={0,0,1,0,1,1,0,1},
						texture = pm.getGraphic(CHARACTER_ZELDA, warporb),
						sceneCoords = true;
					   };
		teleportOrbTimer = teleportOrbTimer - 1;
		
	end
	
	if(flashtimer > 0) then
		Graphics.glDraw{priority = -5, vertexCoords = {0,0,800,0,800,600,0,600}, primitive=Graphics.GL_TRIANGLE_FAN, color = {1,1,1,flashtimer*0.1}};
		flashtimer = flashtimer - 1;
	end
	
	if (player.character == CHARACTER_ZELDA) then
	
		--Prevents a weird graphical bug
		if(player:isGroundTouching() and player.powerup > 1 and player:mem(0x114,FIELD_WORD) == 5) then
			player:mem(0x114,FIELD_WORD,3);
		end
	
		if (warpspot ~= nil and playerStates[player.powerup] == savestate.STATE_PLAYER and state ~= nil and not timeTravelAccess) then
			local rgba = {r=1,g=0.5,b=0.7,a=0.5}
			Graphics.glDraw{
							texture = pm.getGraphic(CHARACTER_ZELDA, warpspotimg), 
							vertexCoords = {warpspot.x-16, warpspot.y-64,warpspot.x+16, warpspot.y-64,warpspot.x+16, warpspot.y,warpspot.x-16, warpspot.y},
							primitive=Graphics.GL_TRIANGLE_FAN,
							vertexColors={rgba.r,rgba.g,rgba.b,rgba.a,rgba.r,rgba.g,rgba.b,rgba.a,rgba.r,rgba.g,rgba.b,rgba.a,rgba.r,rgba.g,rgba.b,rgba.a},
							priority=-24,
							textureCoords={warpframe*0.25,0,(warpframe+1)*0.25,0,(warpframe+1)*0.25,1,warpframe*0.25,1},
							sceneCoords=true
							};
			warpanimtimer = warpanimtimer - 1;
			if(warpanimtimer <= 0) then
				warpanimtimer = 13;
				warpframe = (warpframe+1)%4;
			end
		end
		
		if(spawningRing or ringtimer > 0) then
			local rgba = {};
			rgba.r = ringCol.r*ringtimer*0.01;
			rgba.g = ringCol.g*ringtimer*0.01;
			rgba.b = ringCol.b*ringtimer*0.01;
			rgba.a = ringCol.a*ringtimer*0.01;
			
			Graphics.glDraw{
								texture = pm.getGraphic(CHARACTER_ZELDA, songring),
								vertexCoords = {player.x+player.width*0.5-64, player.y+player.height*0.5-64,player.x+player.width*0.5+64, player.y+player.height*0.5-64,player.x+player.width*0.5+64, player.y+player.height*0.5+64,player.x+player.width*0.5-64, player.y+player.height*0.5+64},
								primitive=Graphics.GL_TRIANGLE_FAN,
								vertexColors={rgba.r,rgba.g,rgba.b,rgba.a,rgba.r,rgba.g,rgba.b,rgba.a,rgba.r,rgba.g,rgba.b,rgba.a,rgba.r,rgba.g,rgba.b,rgba.a},
								priority=-26,
								textureCoords={0,0,1,0,1,1,0,1},
								sceneCoords=true
						   };
			if(spawningRing) then
				ringtimer = ringtimer + 5;
				if(ringtimer >= 100) then
					spawningRing = false;
				end
			else
				ringtimer = ringtimer-1;
			end
				
		end
		
		if(timeTravelAccess) then
			Graphics.draw{type=RTYPE_IMAGE,image=pm.getGraphic(CHARACTER_ZELDA, flute),x=580,y=25,priority=-5}
		elseif(state ~= nil and canTimeTravel) then
			Graphics.draw{type=RTYPE_IMAGE,image=pm.getGraphic(CHARACTER_ZELDA, fluteused),x=580,y=25,priority=-5}
		else
			Graphics.draw{type=RTYPE_IMAGE,image=pm.getGraphic(CHARACTER_ZELDA, flutegrey),x=580,y=25,priority=-5}
		end
	
			Graphics.draw{type=RTYPE_IMAGE,image=pm.getGraphic(CHARACTER_ZELDA, playerStateGraphic[currentPowerup]),x=620,y=25,priority=-5}
	end
end

local waitForStatue = false;
local statueTriggerTime = 0;

function zelda.onInputUpdate()
	if (player.character == CHARACTER_ZELDA and player:mem(0x13E,FIELD_WORD) == 0 and not Misc.isPaused()) then
		pm.winStateCheck()
		if (player.character == CHARACTER_ZELDA) and player:mem(0x13E,FIELD_WORD) == 0 and ((player.forcedState == 0) or (player.forcedState == 500)) then
			if(player:mem(0x4A,FIELD_WORD) == 0) then
				if player.keys.run == KEYS_PRESSED then
					if (timeTravelAccess) then
						playASong(pm.getSound(CHARACTER_ZELDA, playerSongs[playerStates[player.powerup]].."1"))
						if(playerStates[player.powerup] == savestate.STATE_PLAYER) then
							warpspot = {x=player.x+player.width*0.5,y=player.y+player.height};
						end
						state = savestate.save(playerStates[player.powerup])
						timeTravelAccess = false
						canTimeTravel = false
						hasSetPoint = true
						firstUseAvailable = false
					end
				end
				if player.keys.run == KEYS_PRESSED and (state ~= nil) and canTimeTravel then
					playASong(pm.getSound(CHARACTER_ZELDA, playerSongs[playerStates[player.powerup]].."2"))
					flashtimer = 10;
					savestate.load(state, playerStates[player.powerup])
					canTimeTravel = false
					loopCounter = 0
					timeTravelAccess = true;
				end
			end
		end
		if(teleportDoJump and not player.jumpKeyPressing and not player.altJumpKeyPressing) then
				player.speedY = -4;
		end
		teleportDoJump = false;
		if (player:isGroundTouching()) and canTeleport and player.upKeyPressing and (player.jumpKeyPressing or player.altJumpKeyPressing) then
			if player.altJumpKeyPressing then
				player:mem(0x50, FIELD_WORD, -1)
				playSFX(33)
			end
			hasFoundBlocks = false
			local speedFrames = teleportTime;
			teleportHeight = 128;
			
			--First check if the end of the teleport is in a wall - this is clearly problematic! If it is, step backwards along the x axis to see if we're clipping a wall.
			for i = speedFrames,0,-1 do
				speedFrames = i;
				hasFoundBlocks = false;
				local _,_,hits = colliders.collideBlock(colliders.Box(player.x + player.speedX*speedFrames, player.y - 128, player.width, player.height),colliders.BLOCK_SOLID..colliders.BLOCK_PLAYER..colliders.BLOCK_HURT..colliders.BLOCK_LAVA);
				for  _,v in ipairs(hits) do
					if(not v.isHidden) then
						hasFoundBlocks = true;
						break;
					end
				end
				if(not hasFoundBlocks) then
					break;
				end
			end
				
			--If we're still stuck in a wall, perform a raycast to check where we would hit the wall, and attempt to position the player on the wall.
			if(hasFoundBlocks) then
				speedFrames = teleportTime;
				local casterblocks = Block.getIntersecting(math.min(player.x, player.x+player.speedX*speedFrames), player.y-128, math.max(player.x+player.width, player.x+player.width+player.speedX*speedFrames), player.y + player.height);
				local b,cast = colliders.linecast({player.x+player.width*0.5, player.y}, {player.x+player.width*0.5+player.speedX*speedFrames,player.y-128}, casterblocks);
				if(b) then --If the raycast didn't find anything, something went wrong, start ringing alarm bells, and give up trying to teleport.
					local _,_,hits = colliders.collideBlock(colliders.Box(cast.x, cast.y+player.height, player.width, player.height),colliders.BLOCK_SOLID..colliders.BLOCK_PLAYER..colliders.BLOCK_HURT..colliders.BLOCK_LAVA);
					hasFoundBlocks = false;
					teleportHeight = player.y - cast.y;
					for  _,v in ipairs(hits) do
						if(not v.isHidden) then
							hasFoundBlocks = true;
							break;
						end
					end
				end
			end
				
			--If we're still stuck in a wall after all that, give up, otherwise perform teleport.
			if not hasFoundBlocks then
				teleportTrail.x = player.x + player.width*0.5;
				teleportTrail.y = player.y + player.height*2;
				teleportTrail:Emit(1);
				teleportEmitting = teleportTime;
				
				Audio.playSFX(pm.getSound(CHARACTER_ZELDA,sfx_warp));
				
				teleportTarget = {x = player.x + player.speedX*speedFrames, y = player.y - teleportHeight};
				teleportStart = { x = player.x, y = player.y};
				canTeleport = false
				canTeleportCounter = 50
			end
		end
		
		--Prevents Zelda from throwing fireballs when using the Ocarina
		if(player.altRunKeyPressing) then
			player:mem(0x160,FIELD_WORD,1);
			player:mem(0x164,FIELD_WORD,-1);
			if(player.powerup == PLAYER_TANOOKIE) then
				if(not waitForStatue) then
					waitForStatue = true;
					statueTriggerTime = lunatime.tick()+15;
					if(lunatime.tick() < statueTriggerTime) then
						player:mem(0x4C,FIELD_WORD,10);
						player:mem(0x4A,FIELD_WORD,0);
					end
					if(lunatime.tick() >= statueTriggerTime) then
						player:mem(0x4C,FIELD_WORD,15);
						player:mem(0x4A,FIELD_WORD,0);
					end
				end
			end
		else
			if(player:mem(0x164,FIELD_WORD) < 0) then
				player:mem(0x164,FIELD_WORD,0);
			end
			waitForStatue = false;
		end
	end
end

function zelda.onTick()
	if (player.character == CHARACTER_ZELDA) then
	
		if(teleportTarget ~= nil) then
			player:mem(0x122,FIELD_WORD,8);
			teleportCollider.x = player.x + player.speedX;
			teleportCollider.y = player.y;
			teleportCollider.width = player.width;
			teleportCollider.height = player.height;
			
			--Stops Zelda clipping through walls while teleporting (can still clip through floors)
			if not(not colliders.collideBlock(player,colliders.BLOCK_SOLID..colliders.BLOCK_PLAYER..colliders.BLOCK_HURT..colliders.BLOCK_LAVA) and colliders.collideBlock(teleportCollider,colliders.BLOCK_SOLID..colliders.BLOCK_PLAYER..colliders.BLOCK_HURT..colliders.BLOCK_LAVA)) then
				player.x = player.x+(teleportTarget.x-teleportStart.x)/teleportTime;
			end
			
			player.y = teleportTarget.y + ((teleportHeight)*(teleportEmitting)/teleportTime);
			if(teleportEmitting == 0) then
				teleportTarget = nil;
				teleportStart = nil;
				player:mem(0x122,FIELD_WORD,0);
				player:mem(0x124,FIELD_DFLOAT,0);
			end
		end
	
		if canTeleportCounter > 0 then
			canTeleportCounter = canTeleportCounter - 1
		else
			canTeleport = true
		end
		if formerPowerup == nil then
			formerPowerup = player.powerup
		end
		
		if (player.forcedState == 0) or (player.forcedState == 500) then
			-- ^ Don't worry about player.powerup changes while the player is transitioning
			currentPowerup = player.powerup
			if currentPowerup ~= formerPowerup then
				if (playerStates[currentPowerup] == playerStates[formerPowerup]) then
				elseif currentPowerup == 1 then
					playerStates[1] = playerStates[formerPowerup]
					playerStateGraphic[1] = playerStateGraphic[formerPowerup]
				else
					hasSetPoint = false
					timeTravelAccess = true
				end
				formerPowerup = currentPowerup
			end
		end
		
		if (ocarinaChannel ~= nil and not ocarinaChannel:IsPlaying()) then
			Audio.MusicVolume = rawMusVol;
			Audio.MusicVolume(musicvolume)
			isPlaying = false
			Audio.ReleaseStream(player:mem(0x15A, FIELD_WORD))
			canTimeTravel = true
		end
		--[[for k,v in pairs(npcs()) do
			if (colliders.collide(player, v)) then
				if (v.id == 273) and (not timeTravelAccess) then
					timeTravelAccess = true
				end
			end
		end]]
	end
end

function zelda.cleanupCharacter()
	if(ocarinaChannel ~= nil) then
		ocarinaChannel:Stop();
	end
	if(Audio.MusicVolume ~= rawMusVol) then
		Audio.MusicVolume = rawMusVol;
		Audio.MusicVolume(musicvolume)
	end
	state = nil;
	canTimeTravel = false
	hasSetPoint = false;
	timeTravelAccess = true;
	
	spawningRing = false;
	ringtimer = 0;
	
	if(teleportEmitting > 0) then
		teleportTarget = nil;
		teleportStart = nil;
		player:mem(0x122,FIELD_WORD,0);
		player:mem(0x124,FIELD_DFLOAT,0);
		teleportEmitting = 0;
	end
end

return zelda