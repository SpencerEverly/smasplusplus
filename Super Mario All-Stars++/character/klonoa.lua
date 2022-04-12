--[[
Things to fix:
- See clean up notes.
]]

local klonoa = {};

local colliders = require("colliders")
local expandedDefines = require("expandedDefines")
local xmem = require("xmem");
local playerManager = require("playerManager");

local grabbed = 0;
local grabbedNPC;
local pressedGrab = false;
local runspeed = 6;

function klonoa.onInitAPI()
	registerEvent(klonoa, "onInputUpdate", "onInputUpdate", false)
	registerEvent(klonoa, "onLoop", "onLoop", true)
	registerEvent(klonoa, "onNPCKill", "onNPCKill", true)
	registerEvent(klonoa, "onLevelExit", "onLevelExit", true)
	registerEvent(klonoa, "onDraw", "onDraw", true)
	registerEvent(klonoa, "onHUDDraw", "onHUDDraw", true)
end

local ringbox = colliders.Box(0, 0, 32, 32); 

local sprite = {sheet = playerManager.registerGraphic(CHARACTER_KLONOA, "ringShot.png"), width = 64, height = 64}

local flash = {sheet = playerManager.registerGraphic(CHARACTER_KLONOA, "ringFlash.png"), width = 64, height = 64}

playerManager.registerSound(CHARACTER_KLONOA, "ringshot", "klonoa_ring.ogg");
playerManager.registerSound(CHARACTER_KLONOA, "die", "klonoa_die.ogg");
playerManager.registerSound(CHARACTER_KLONOA, "flutter", "klonoa_flutter.ogg");
playerManager.registerSound(CHARACTER_KLONOA, "grab", "klonoa_grab.ogg");
playerManager.registerSound(CHARACTER_KLONOA, "hurt", "klonoa_hurt.ogg");
playerManager.registerSound(CHARACTER_KLONOA, "throw", "klonoa_throw.ogg");
playerManager.registerSound(CHARACTER_KLONOA, "wahoo", "klonoa_wahoo.ogg");
playerManager.registerSound(CHARACTER_KLONOA, "yah", "klonoa_yah.ogg");

Graphics.registerCharacterHUD(CHARACTER_KLONOA, Graphics.HUD_HEARTS)

function sprite:drawFrame(x,y,i,j)
	Graphics.drawImageToSceneWP(playerManager.getGraphic(CHARACTER_KLONOA, self.sheet), x, y, self.width*i, self.height*j, self.width, self.height, -24);
end

flash.drawFrame = sprite.drawFrame;

local ringEffectFrame = -1;
local ringEffectDir = 0;
local effectFrame = -1;

local thrown = {};
local throwTimer = -1;
local vthrowTimer = -1;
local icecooldown = {};

local jumped = false;

local flaptimer = 0;
local flaplocktimer = 0
local flapped = false;
local flapdir = 1;

local function contains(tbl,val)
	for _,v in ipairs(tbl) do
		if(v == val) then
			return true;
		end
	end
	return false;
end

local function sign(a)
	if(a > 0) then return 1;
	elseif(a < 0) then return -1;
	else return 0; end
end

local grabNPCs = {31,32,238,22,158,159,45,279,278,134,241,195,26,49,154,155,156,157,96,263,35,193,191,40,296, 348, 408, 468, 325, 326, 327, 328, 329, 330, 331, 332};
local ungrabNPCs = {284,47,18,44,21,39,199,15,200,86,181,84,85,87,189,72,208,71,164,74,162,210,203,180,37,275,205,93,8,52,51,74,245, 295, 296, 297, 298, 302, 303, 304, 307, 351, 357, 360, 376, 380, 395, 402, 415, 417, 426, 431, 432, 435, 437, 446, 447, 448, 449, 463, 464, 466, 467, 492, 493, 499, 509, 510, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 531, 532, 564};
local containers = {283}
local grass = {91}

klonoa.flapAnimSpeed = 6;

klonoa.GrabableNPCs = {};
klonoa.UngrabableNPCs  = {};
klonoa.ReplaceGrabbedNPC = {};
for _,v in ipairs(grabNPCs) do
	klonoa.GrabableNPCs[v] = true;
end
for _,v in ipairs(ungrabNPCs) do
	klonoa.UngrabableNPCs[v] = true;
end

do --Replace koopas with their respective shells, and paragoombas with regular goombas
klonoa.ReplaceGrabbedNPC[176] = 172;
klonoa.ReplaceGrabbedNPC[173] = 172;

klonoa.ReplaceGrabbedNPC[76] = 5;
klonoa.ReplaceGrabbedNPC[4] = 5;

klonoa.ReplaceGrabbedNPC[177] = 174;
klonoa.ReplaceGrabbedNPC[175] = 174;

klonoa.ReplaceGrabbedNPC[161] = 7;
klonoa.ReplaceGrabbedNPC[6] = 7;

klonoa.ReplaceGrabbedNPC[123] = 115;
klonoa.ReplaceGrabbedNPC[111] = 115;

klonoa.ReplaceGrabbedNPC[122] = 114;
klonoa.ReplaceGrabbedNPC[110] = 114;

klonoa.ReplaceGrabbedNPC[124] = 116;
klonoa.ReplaceGrabbedNPC[112] = 116;

klonoa.ReplaceGrabbedNPC[109] = 113;
klonoa.ReplaceGrabbedNPC[121] = 113;

klonoa.ReplaceGrabbedNPC[167] = 166;
klonoa.ReplaceGrabbedNPC[244] = 1;
klonoa.ReplaceGrabbedNPC[243] = 242;
klonoa.ReplaceGrabbedNPC[3] = 2;

klonoa.ReplaceGrabbedNPC[408] = 409;
klonoa.ReplaceGrabbedNPC[578] = 579;
end

klonoa.forceHearts = true; --Convert super mushrooms into hearts
klonoa.forceRupees = true; --Convert coins into rupees

function klonoa.isHoldingObject()
	return player:mem(0x154, FIELD_WORD) > 0 and grabbedNPC ~= nil and grabbedNPC.isValid;
end

function klonoa.canFly()
	return player:mem(0x16E, FIELD_BOOL) or player:mem(0x16C, FIELD_BOOL);
end

function klonoa.isMovementLocked()
	return not (player:mem(0x122,FIELD_WORD) == 0 or player:mem(0x122,FIELD_WORD) == 7 or player:mem(0x122,FIELD_WORD) == 500);
end

local function replaceNPC(npc,id)
	npc:transform(id);
--[[
	npc.id = id;
	local w = npcconfig[npc.id].width;
	local h = npcconfig[npc.id].height;
	npc:xmem(0x90, w);
	npc:xmem(0x88, h);
	if(npcconfig[npc.id].gfxwidth ~= 0) then
		w = npcconfig[npc.id].gfxwidth;
	end
	if(npcconfig[npc.id].gfxheight ~= 0) then
		h = npcconfig[npc.id].gfxheight;
	end
	npc:xmem(0xB8, w);
	npc:xmem(0xC0, h);
	npc:xmem(0xE4, 0);]]
end

local function onGrab(npc)
	Audio.playSFX(playerManager.getSound(CHARACTER_KLONOA,"grab"));
	if(player.powerup == PLAYER_ICE) then
		if(npc.id ~= 263 and NPC.HITTABLE_MAP[npc.id]) then
			npc.ai1 = npc.id;
			npc.id = 263
		end
	end
end

local fireballs = {};

local function onThrow(npc)
	if(npc.id == 263) then
		npc.ai3 = 1;
	end
end

local lastPlayerID = 0;
local shooting = false;

local climbing = false;
--local climbableNPC = {221,217,215,213,214,216,224,222,223,227,226,225,220,218,219};
--local climbableBGO = {186,185,184,183,182,181,180,179,178,177,176,175,174};

local ringEnabled = true;

local function throwGrabbed(x,y,xspeed,yspeed)
	throw = true;
	grabbedNPC.x = x;
	grabbedNPC.y = y;
	grabbedNPC:mem(0x12C,FIELD_WORD,0);
	local x_s = nil;
	if(xspeed == 0) then x_s = grabbedNPC.x; end
	local y_s = nil;
	if(yspeed == 0) then y_s = grabbedNPC.y; end
	table.insert(thrown,{npc = grabbedNPC, speedx = xspeed, speedy = yspeed, x = x_s, y = y_s, power = player.powerup});
	Audio.playSFX(playerManager.getSound(CHARACTER_KLONOA,"throw"))
	onThrow(grabbedNPC);
	
	if(player.powerup == PLAYER_FIREFLOWER) then
		SFX.play(42)
		local dir = player.FacingDirection;
		local sx,sy;
		local vx,vy;
		local bx,by;
		if(xspeed ~= 0 and yspeed == 0) then
			sx = player.x+player.width/2 + (player.width/2)*dir
			sy = player.y + 8;
			vx = 3;
			vy = 0;
			by = sy;
		elseif(yspeed ~= 0 and xspeed == 0) then
			sx = player.x+player.width/2;
			sy = player.y + player.height;
			vx = 0;
			vy = 3;
			bx = sx;
		end
		local angle = math.sin(math.pi*0.25);
		Routine.setFrameTimer(12,function()
				table.insert(fireballs, {npc = NPC.spawn(13,sx,sy,player.section),speedx = dir*vx, speedy = vy, x = bx, y = by})
				table.insert(fireballs, {npc = NPC.spawn(13,sx,sy,player.section),speedx = dir*vx + vy*angle, speedy = vy+vx*angle})
				table.insert(fireballs, {npc = NPC.spawn(13,sx,sy,player.section),speedx = dir*vx + vy*-angle, speedy = vy+vx*-angle})
		end);
	end
	
	player.runKeyPressing = false;
	grabbedNPC = nil;
	grabbed = 0;
end

local dead = false;

function klonoa.resetFlutter()
	flapped = false;
end

function klonoa.disableRing()
	ringEnabled = false;
end

function klonoa.enableRing()
	ringEnabled = true;
	pressedGrab = true;
end

local forcejumped = false;
function klonoa.forceJumped()
	forcejumped = true;
end

function klonoa.isFlapping()
	return flaptimer > 0;
end

function klonoa.onInputUpdate()
	--player:memdump(0x106,0x106)
	if Misc.isPaused() then pressedGrab = true; return end; --pause menu
	
	if(player.character ~= lastPlayerID) then
		jumped = true;
		flapped = true;
	end
	
	lastPlayerID = player.character;
	if(player.character == CHARACTER_KLONOA) then
		playerManager.winStateCheck()
		
		player:mem(0x160, FIELD_WORD, 2);
		player:mem(0x162, FIELD_WORD, 2);
		player:mem(0x164, FIELD_WORD, -1);
		
		ringbox.x = player.x + player.width/2 - ringbox.width/2 + player.FacingDirection*48;
		ringbox.y = player.y + 16;
		
		if(grabbedNPC ~= nil and not grabbedNPC.isValid) then
			grabbedNPC = nil;
			grabbed = 0;
			player:mem(0x154,FIELD_WORD,0)
		end		
		
		--update grabbed value
		if(grabbedNPC ~= nil) then
			for k,v in ipairs(NPC.get()) do
				if(grabbedNPC == v) then
					grabbed = k;
					player:mem(0x154,FIELD_WORD,k)
					break;
				end
			end
		end
	 
		--ringbox:Draw();
		--colliders.getHitbox(player):Draw();
		
	if(ringEnabled and (shooting or throwTimer >= 0 or dead or klonoa.isMovementLocked())) then
		player.runKeyPressing = true;
		player.leftKeyPressing = false;
		player.rightKeyPressing = false;
		player.upKeyPressing = false;
		player.downKeyPressing = false;
		player.jumpKeyPressing = false;
		player.altJumpKeyPressing = false;
		
		jumped = true;
		player:mem(0x144,FIELD_WORD,1);	
		if(grabbedNPC ~= nil and grabbedNPC.isValid) then
			grabbedNPC:mem(0x12C,FIELD_WORD,1);
		end
		player:mem(0x154, FIELD_WORD, grabbed) 
		return;
	end
		
		if(player.altJumpKeyPressing and player:mem(0x108, FIELD_WORD) == 0) then --Disable spinjump
			player.altJumpKeyPressing = false;
			player.jumpKeyPressing = true;
		end
		
		--[[
		local climbBGO = false;
		for _,v in ipairs(BGO.getIntersecting(player.x,player.y,player.x+player.width,player.y+player.height)) do
			if(contains(climbableBGO,v.id)) then
				climbBGO = true;
				break;
			end
		end
		local climbBGOTop = false;
		for _,v in ipairs(BGO.getIntersecting(player.x,player.y-player.height,player.x+player.width,player.y)) do
			if(contains(climbableBGO,v.id)) then
				climbBGOTop = true;
				break;
			end
		end
		
		local climbHit = climbBGO or colliders.collideNPC(player,climbableNPC);
		local climbTop = climbBGOTop or colliders.collideNPC(colliders.Box(player.x,player.y-player.height,player.width,player.height),climbableNPC);
		if((climbing or player:xmem(0xF2) == -1 or player:xmem(0xF4) == -1) and not klonoa.isHoldingObject() and (climbHit and (climbTop or climbing))) then
			player:xmem(0x40,3);
			climbing = true;
			jumped = false;
			flapped = false;
		elseif (not climbhit and not climbTop) then
			climbing = false;
		end
		
		if(climbHit and not climbTop and climbing) then
				player:xmem(0x40,2);
		end
				
		if(jumped) then
			climbing = false;
		end
	
		if(not climbing) then
			--player:xmem(0xF4,0) --Disable ducking
		end]]
		
		if(player:mem(0x40, FIELD_WORD) == 3 or player:mem(0x40, FIELD_WORD)==2) then
			jumped = false;
			flapped = false;
			climbing = true;
		else
			climbing = false;
		end
		
		player:mem(0x00,FIELD_BOOL,false); --disable leaf double jump
		
		local throw = false;
		
		if(not player.jumpKeyPressing) then
			jumped = false;
		end
		
		if(player:isGroundTouching() or player:mem(0x34, FIELD_WORD) == 2) then
			jumped = false;
			flapped = false;
		end
		
		if(player:mem(0x108, FIELD_WORD) ~= 0) then
			jumped = true;
		end		
		
		if(forcejumped) then
			jumped = true;
			forcejumped = false;
		end
		
		if(player.jumpKeyPressing and not jumped) then --press jump key
			if(not player:isGroundTouching() and not climbing and player:mem(0x34, FIELD_WORD) ~= 2 and not klonoa.canFly() and player:mem(0x108, FIELD_WORD) == 0) then --airborne and not climbing and not swimming and not flying and not riding anything
				if(ringEnabled and klonoa.isHoldingObject()) then
					player.speedY = -9;
					vthrowTimer = 15;
					throwGrabbed(player.x+(player.width-grabbedNPC.width)*0.5, player.y+player.height-grabbedNPC.height, 0, 8)
					player.runKeyPressing = true;
					Audio.playSFX(playerManager.getSound(CHARACTER_KLONOA,"wahoo"))
					pressedGrab = true;
					flapped = false;
					flapdir = nil;
				elseif not flapped then
					Audio.playSFX(playerManager.getSound(CHARACTER_KLONOA,"flutter"));
					flaptimer = 40;
					flapped = true;
					flapdir = player.FacingDirection;
				end 
			end
			jumped = true;
		end
		
		if(flaptimer > 0) then
			throw = true
			player.speedY = -((40-flaptimer)/25)
			if(player.powerup == PLAYER_LEAF or player.powerup == PLAYER_TANOOKIE) then
				player.speedY = player.speedY*1.75
			end
			player:mem(0x11C,FIELD_WORD,player.speedY)
			flaptimer = flaptimer-1
			if flaptimer == 0 and player.keys.jump and (player.powerup == PLAYER_LEAF or player.powerup == PLAYER_TANOOKIE) then
				player:mem(0x11C,FIELD_WORD, 5)
			end
			flaplocktimer = 16
		elseif flaplocktimer > 0 then
			flaplocktimer = flaplocktimer-1
		end
		
		if(player.runKeyPressing) then
			Defines.player_runspeed = runspeed;
		else
			Defines.player_runspeed = Defines.player_walkspeed;
		end
		
		if(ringEnabled and player.runKeyPressing and player:mem(0x108, FIELD_WORD) == 0) then
			if not pressedGrab then 
				if(mem(0xB250E2, FIELD_WORD) ~= -1) then -- if messagebox not open 
					if(klonoa.isHoldingObject()) then
						throwGrabbed(player.x + (1+player.FacingDirection)*player.width/2 + ((player.FacingDirection-1)/2)*grabbedNPC.width, player.y + 40 - grabbedNPC.height, 4*player.FacingDirection, 0)
						throwTimer = 15;
						Audio.playSFX(playerManager.getSound(CHARACTER_KLONOA,"yah"));
					else
						throw = true;
						player.runKeyPressing = false;
						
						if(not climbing and flaptimer <= 0 and not player:mem(0x16E, FIELD_BOOL) and (player.forcedState == 0 or player.forcedState == 7 or player.forcedState == 500)) then --if not climbing, not flapping, not flying and not being hurt/powering up
						
							Routine.setFrameTimer(1,function ()
								if(not klonoa.isHoldingObject()) then
									effectFrame = 0;
									ringEffectFrame = 0;
									ringEffectDir = player.FacingDirection;
									Routine.setFrameTimer(3, 
										function() 
											effectFrame = effectFrame + 1;
											if(effectFrame >= 7 or effectFrame <= 0) then
												effectFrame = -1;
												Routine.breakTimer();
											end
										end, true)
										
									Routine.setFrameTimer(5, 
										function() 
											ringEffectFrame = ringEffectFrame + 1;
											if(ringEffectFrame >= 4) then
												ringEffectFrame = -1;
												Routine.breakTimer();
											end
										end, true)
									Audio.playSFX(playerManager.getSound(CHARACTER_KLONOA,"ringshot"));
								end
							end);
					
						end
					end
				else
					throw = true;
					player.runKeyPressing = false;
				end
				pressedGrab = true;
			end
		else
			pressedGrab = false;
		end
		
		if not throw or not ringEnabled then 
			player.runKeyPressing = true;
		end
		
		if(grabbedNPC ~= nil and grabbedNPC.isValid) then
			grabbedNPC:mem(0x12C,FIELD_WORD,1);
		end
		player:mem(0x154, FIELD_WORD, grabbed)
	end
end

local cancelPowerupAnim = false;

local killednpcs = {}

function klonoa.onNPCKill(obj,npc,reason)
	if(player.character == CHARACTER_KLONOA) then
		if(reason == 9 and player.powerup == PLAYER_SMALL and contains({250,249,185,184,9},npc.id)) then
			cancelPowerupAnim = true;
			if(npc.id == 250) then
				SFX.play(79)
			else
				SFX.play(12)
			end
		end
	end
end

local hp = 1;

function klonoa.onLoop()
	if(player.character == CHARACTER_KLONOA) then
		
		--Drop NPC on death
		if(grabbedNPC ~= nil and grabbedNPC.isValid and player:mem(0x13E, FIELD_WORD) > 0) then
			grabbedNPC:mem(0x12C,FIELD_WORD,0);
			grabbedNPC:mem(0x136, FIELD_BOOL, false)	
			grabbedNPC = nil;
		end
		
		if(player:mem(0x13E, FIELD_WORD) > 0) then
			if(not dead) then
				Audio.playSFX(playerManager.getSound(CHARACTER_KLONOA,"die"));
			end
			dead = true;
			return;
		else 
			dead = false; 
		end
		
		if(player:mem(0x16, FIELD_WORD) < hp and hp > 1 and not dead) then
			Audio.playSFX(playerManager.getSound(CHARACTER_KLONOA,"hurt"))
			if(hp == 2) then
				player:mem(0x124,FIELD_DFLOAT,49);
			end
		end		
		
		hp = player:mem(0x16, FIELD_WORD);
		
		if(cancelPowerupAnim and player.forcedState == 1) then
			player:mem(0x124,FIELD_DFLOAT,49);
			cancelPowerupAnim = false;
		end
		
		local winstate = Level.winState()
		
		
		-- THROW KEYS AT LOCKS MAKE THEM OPEN AND END LEVELS
		for _,trn in ipairs(thrown) do
			local v = trn.npc;
			if(v ~= nil and v.isValid and v.id == 31) then --KEYS ONLY PL0X
				local w = v.width*0.5;
				local h = v.height*0.5;
				
				if(w <= 0) then w = 1; end
				if(h <= 0) then h = 1; end
				
				for _, q in ipairs(BGO.getIntersecting(v.x+w*0.5, v.y + h * 0.5, v.x + w*1.5, v.y + h*1.5)) do
					if q.id == 35 and not q.isHidden and winstate == 0 then
						Level.winState(3)
						Audio.SeizeStream(-1)
						Audio.MusicStop()
						SFX.play(31)
					end
				end
			end
		end
		
		local i = 1;
		if(not Defines.levelFreeze) then
			while(i <= #thrown) do
				local v = thrown[i];
			
				if v == nil or not v.npc.isValid or v.npc.data.shouldRemove or v.npc:mem(0x12A, FIELD_WORD) < 1 then
					table.remove(thrown,i);
				else
					if(v.npc.data.shouldKill) then
						local bx = v.npc.x+v.npc.width/2;
						local by = v.npc.y+v.npc.height/2;
						local powr = v.power;
						local bnpc = v.npc;
						Routine.setFrameTimer(1, function()
							if(bnpc.isValid) then
								bnpc.data.shouldKill = false;
								bnpc:kill(8);
							end	
							if(powr == PLAYER_HAMMER) then
								Misc.doBombExplosion(bx,by,2);
							end
						end);
					end
					i = i + 1;
					v.npc.speedX = v.speedx;
					v.npc.speedY = v.speedy;
					
					if(v.x ~= nil) then
						v.npc.x = v.x;
					else
						v.npc.x = v.npc.x + v.speedx;
					end
					if(v.y ~= nil) then
						v.npc.y = v.y;
					elseif v.npc.id == 17 then --hacky workaround woo
						v.npc.y = v.npc.y + v.speedy;
					end
					
					if(v.power ~= PLAYER_HAMMER or not NPC.HITTABLE_MAP[v.npc.id]) then
						v.npc:mem(0x12E,FIELD_WORD,30);
						v.npc:mem(0x136,FIELD_BOOL,true);
					else
						v.npc:mem(0x136,FIELD_BOOL,false);
						v.npc.x = v.npc.x + v.speedx;
					end
					
					if(v.npc.id == 263) then --is ice
						v.speedx = v.speedx*0.9;
						v.speedy = v.speedy*0.9;
						
						if(math.abs(v.speedx) < 0.1 and math.abs(v.speedy) < 0.1) then
							v.npc.speedX = 0;
							v.npc.speedY = 0;
							v.npc:mem(0x136,FIELD_BOOL,false);
							v.npc:mem(0x12C,FIELD_WORD,0);
							v.npc.ai3 = 1;
							v.npc.data.shouldRemove = true;
							if(not contains(icecooldown,v.npc)) then
								table.insert(icecooldown, v.npc)
							end
						end
					end
					
					if(NPC.config[v.npc.id].isvegetable) then
						local _,_,hits = colliders.collideBlock(v.npc, colliders.BLOCK_SOLID..colliders.BLOCK_LAVA..colliders.BLOCK_NONSOLID..colliders.BLOCK_HURT..colliders.BLOCK_PLAYER);
						local j = 1;
						while j <= #hits do
							if(hits[j].isHidden) then
								table.remove(hits,j);
							else
								j = j+1;
							end
						end
						if(#hits > 0) then
							v.npc.data.shouldKill = true;
							SFX.play(36);
						end
					end
					
					
					local b,_,ps = colliders.collideNPC(colliders.getSpeedHitbox(v.npc),NPC.HITTABLE,player.section);
					if(b) then
						local p = nil;
						for _,n in ipairs(ps) do
							if(not n.friendly and not n:mem(0x64, FIELD_BOOL) and n ~= v.npc) then
								p = n;
								break;
							end
						end
						if(p ~= nil) then
							if(not klonoa.GrabableNPCs[v.npc.id]) then
								v.npc.data.shouldKill = true;
							elseif (v.npc.id ~= 263) then --Don't remove ice on contact
								v.npc.data.shouldRemove = true;
							end
							if(not NPC.MULTIHIT_MAP[p.id]) then
								local pn = p;
								Routine.setFrameTimer(1, function()
										if(pn.isValid) then
											pn:harm(8);
										end
									end);
							end
						end
					end
					
					if(v.npc:mem(0x0A, FIELD_WORD) == 2 or v.npc:mem(0x0C, FIELD_WORD) == 2 or v.npc:mem(0x0E, FIELD_WORD) == 2 or v.npc:mem(0x10, FIELD_WORD) == 2) then
						if(not klonoa.GrabableNPCs[v.npc.id]) then
							v.npc.data.shouldKill = true;
						elseif (v.npc.id ~= 263) then --Don't remove ice on contact
							v.npc.data.shouldRemove = true;
						end
					else
						local _,_,hits = colliders.collideBlock(v.npc, colliders.BLOCK_SOLID..colliders.BLOCK_LAVA..colliders.BLOCK_NONSOLID..colliders.BLOCK_HURT..colliders.BLOCK_PLAYER);
						local j = 1;
						while j <= #hits do
							if(hits[j].isHidden) then
								table.remove(hits,j);
							else
								j = j+1;
							end
						end
						if(#hits > 0) then
							if(not klonoa.GrabableNPCs[v.npc.id]) then
								v.npc.data.shouldKill = true;
							elseif (v.npc.id ~= 263) then --Don't remove ice on contact
								v.npc.data.shouldRemove = true;
							end
						end
					end
				end
			end
		
			i = 1;
			
			while i <= #fireballs do
				local v = fireballs[i];
				if(not v.npc.isValid) then
					table.remove(fireballs,i);
				else
					v.npc.speedX = v.speedx;
					v.npc.speedY = v.speedy;
					local sx,sy = v.npc.x,v.npc.y;
					if(v.x ~= nil) then
						sx = v.x;
					end
					if(v.y ~= nil) then
						sy = v.y;
					end
					v.npc.x = sx + v.speedx;
					v.npc.y = sy + v.speedy;
				i = i+1;
				end
			end
		end
		
		--Make ice take longer to despawn than normal
		i = 1;
		while i <= #icecooldown do
			local v = icecooldown[i];
			if(not v.isValid) then
				table.remove(icecooldown,i);
			else
				if(not v:mem(0x128, FIELD_BOOL)) then
					v:mem(0x12A, FIELD_WORD, 720);
				end
				i = i+1;
			end
		end
		
		if(throwTimer >= 0) then
			throwTimer = throwTimer - 1;
		end
		
		if(vthrowTimer >= 0) then
			vthrowTimer = vthrowTimer - 1;
		end
		
		if klonoa.isHoldingObject() then
			effectFrame = -1;
			shooting = false;
		end
		
		shooting = effectFrame >= 0 and not klonoa.isHoldingObject() 
		
		
		if (shooting) then
				local ps = NPC.getIntersecting(ringbox.x, ringbox.y, ringbox.x+ringbox.width, ringbox.y+ringbox.height);
				local p;
				for _,v in ipairs(ps) do
					if (
						not v.friendly
					and not v:mem(0x64, FIELD_BOOL)
					and v:mem(0x12A, FIELD_WORD) > 0
					and (v:mem(0x138, FIELD_WORD) == 0 or v:mem(0x138, FIELD_WORD) == 3)
					and v:mem(0x12C, FIELD_WORD) <= 0
					and (not v.isHidden)
					and (
							(
								NPC.HITTABLE_MAP[v.id]
							and not NPC.MULTIHIT_MAP[v.id]
							)
							or klonoa.GrabableNPCs[v.id]
							or NPC.config[v.id].isvegetable
						)
					and not klonoa.UngrabableNPCs[v.id]) then
						p = v;
						break;
					end
					if(not v.friendly and v:mem(0x12A, FIELD_WORD) > 0 and v:mem(0x138, FIELD_WORD) == 0 and not v:mem(0x64, FIELD_BOOL) and contains(containers,v.id)) then
						replaceNPC(v, v.ai1);
						v:mem(0xDC, FIELD_WORD, 0);
						v.ai1 = 0;
						--v:xmem(0xE2, v.id);
						v.y = v.y - v.height - 16;
						v.speedY = -2
					end
				end
				if(p ~= nil) then
					grabbedNPC = p;
					if(klonoa.ReplaceGrabbedNPC[grabbedNPC.id] ~= nil) then
						replaceNPC(grabbedNPC, klonoa.ReplaceGrabbedNPC[grabbedNPC.id]);
					end
					grabbedNPC:mem(0x12C, FIELD_WORD, 1);
					grabbedNPC.data.shouldKill = false;
					grabbedNPC.data.shouldRemove = false;
					grabbedNPC:mem(0x136, FIELD_BOOL, true)	
					Animation.spawn(80,player.x+player.width/2,player.y)
					Animation.spawn(80,player.x,player.y)
					Animation.spawn(80,player.x+player.width,player.y)
					onGrab(grabbedNPC);
					grabbed = p.idx;
				else
					ps = NPC.getIntersecting(ringbox.x, ringbox.y+32, ringbox.x+ringbox.width, ringbox.y+32+ringbox.height);
					for _,v in ipairs(ps) do
						if(not v.friendly and v:mem(0x12A, FIELD_WORD) > 0 and v:mem(0x138, FIELD_WORD) == 0 and not v:mem(0x64, FIELD_BOOL) and contains(grass,v.id)) then
							replaceNPC(v, v.ai1);
							v:mem(0xDC, FIELD_WORD, 0);
							v.ai1 = 0;
							--v:xmem(0xE2, v.id);
							v.y = v.y - v.height - 16;
							v.speedY = -2
							SFX.play(88)
						end
					end
					
					--Dig up sand
					ps = Block.getIntersecting(ringbox.x, ringbox.y+32, ringbox.x+ringbox.width, ringbox.y+32+ringbox.height);
					for _,v in ipairs(ps) do
						if(v.id == 370 and not v.isHidden and v:mem(0x5C, FIELD_WORD) == 0) then
							v:remove();
							effectFrame = -1;
							SFX.play(88)
							break;
						end
					end
				end
			
		end
		
	end
	
end

function klonoa.onHUDDraw()
end

local function isJumping()
	return not player:isGroundTouching() and not climbing and not klonoa.canFly() and (player:mem(0x114, FIELD_WORD) == 4 or player:mem(0x114, FIELD_WORD) == 5 or player:mem(0x114, FIELD_WORD) == 9  or player:mem(0x114, FIELD_WORD) == 10) and player:mem(0x34, FIELD_WORD) ~= 2;
end


function klonoa.onDraw()
	if(ringEffectFrame >= 0) then
		flash:drawFrame(player.x + player.width/2 - 32 + 32*ringEffectDir, ringbox.y - 20, ringEffectFrame, 1-((ringEffectDir+1)/2));
	end
	
	if(effectFrame >= 0) then
		sprite:drawFrame(ringbox.x + ringbox.width/2 - 32 - 16*ringEffectDir, ringbox.y - 20, effectFrame, 1-((ringEffectDir+1)/2));
	end
	
	if(player.character == CHARACTER_KLONOA) then

			if(klonoa.forceHearts) then
				for _,v in ipairs(NPC.get({9,185,184},player.section)) do
					if(v:mem(0x124, FIELD_BOOL)) then
						local h = v.height;
						local w = v.width;
						local x,y = v.x,v.y;
						replaceNPC(v,250)
						--Don't break when hearts come out of blocks and such
						local contained = v:mem(0x138, FIELD_WORD);
						if(contained == 1 or contained == 3 or contained == 4) then
							v.x = x;
							v.y = y;
							v.height = h;
							v.width = w;
						end
					end
				end
			end
			
			if(klonoa.forceRupees) then
				for _,v in ipairs(NPC.get({138,88,33,10},player.section)) do
					if(v:mem(0x124, FIELD_BOOL)) then
						replaceNPC(v,251)
						--If this NPC has no respawn ID (i.e. was spawned into the level later), then make it fall (hacky fix for the "rupees fly into oblivion" bug)
						if(v:mem(0xDC,FIELD_WORD) == 0) then
							v.ai1 = 1;
						end
					end
				end
			end
			
		if(player:mem(0x34, FIELD_WORD) == 2) then
			if(not player:isGroundTouching()) then
				if(player:mem(0x114, FIELD_WORD) == 1) then
					player:mem(0x114, FIELD_WORD,34);
				elseif(player:mem(0x114, FIELD_WORD) == 2) then
					player:mem(0x114, FIELD_WORD,33);
				elseif(player:mem(0x114, FIELD_WORD) == 5) then
					player:mem(0x114, FIELD_WORD,32);
				elseif(player:mem(0x114, FIELD_WORD) == 10) then
					player:mem(0x114, FIELD_WORD,30);
				end
			end
		else
			if flapped and isJumping() and flaplocktimer > 0 then
				player.direction = flapdir
			end
			if(flaptimer>0 and isJumping()) then --flapping animation
				player:mem(0x114, FIELD_WORD,31+math.floor(flaptimer/klonoa.flapAnimSpeed)%4)
			elseif(shooting and not klonoa.isHoldingObject()) then
				player:mem(0x114, FIELD_WORD,35);
			elseif(throwTimer > 0 and not klonoa.isHoldingObject()) then
				player:mem(0x114, FIELD_WORD,14);
			elseif(vthrowTimer > 0 and not klonoa.isHoldingObject() and isJumping()) then
				player:mem(0x114, FIELD_WORD,36);
			elseif(player:mem(0x34, FIELD_WORD) == 2) then--swimming
				local offset = 0;
				if(klonoa.isHoldingObject()) then offset = 6 end;
				
				player:mem(0x114, FIELD_WORD,22+offset+math.floor(3*player:mem(0x38, FIELD_WORD)/16));
				
			elseif(isJumping()) then
				local offset = 0;
				if(klonoa.isHoldingObject()) then offset = 6 end;
				if(player.speedY <= -2) then
					player:mem(0x114, FIELD_WORD,22+offset);
				elseif(player.speedY >= 2) then
					player:mem(0x114, FIELD_WORD,24+offset);
				else
					player:mem(0x114, FIELD_WORD,23+offset);
				end
			end
		end
	end
end

local function disableGrab()
	-- Disable side grab
	mem(0x009AD622, FIELD_WORD, 0xE990)
	--mem(0x009AD622, FIELD_WORD, 0x850F)
	
	-- Disable top grab
	mem(0x009CC392, FIELD_WORD, 0xE990)
	--mem(0x009CC392, FIELD_WORD, 0x850F)
	
	-- Disable shell side grab
	mem(0x009ADA63, FIELD_WORD, 0x9090)
	--mem(0x009ADA63, FIELD_WORD, 0x1474)
	
	 -- Disable shell top grab
	mem(0x009AC6C4, FIELD_WORD, 0xE990)
	--mem(0x009AC6C4, FIELD_WORD, 0x850F)
	
end

local function enableGrab()
	-- side grab
	mem(0x009AD622, FIELD_WORD, 0x850F)

	-- top grab
	mem(0x009CC392, FIELD_WORD, 0x850F)

	--  shell side grab
	mem(0x009ADA63, FIELD_WORD, 0x1474)

	-- shell top grab
	mem(0x009AC6C4, FIELD_WORD, 0x850F)
end

function klonoa.initCharacter()
	-- CLEANUP NOTE: This is not safe if a level makes it's own use jumpheight
	Defines.jumpheight = 17
	Defines.jumpheight_bounce = 17
	
	-- CLEANUP NOTE: This should be replaced with a better hook in core LunaLua
	disableGrab()
	
	--Not valid if this value is set mid level
	runspeed = Defines.player_runspeed;
	Defines.player_runspeed = Defines.player_walkspeed;
end

function klonoa.cleanupCharacter()
	-- CLEANUP NOTE: This is not safe if a level makes it's own use jumpheight
	Defines.jumpheight = nil
	Defines.jumpheight_bounce = nil
	player:mem(0x164, FIELD_WORD, 0);
	
	-- CLEANUP NOTE: This should be replaced with a better hook in core LunaLua
	enableGrab()
	
	--Not valid if this value is set mid level
	Defines.player_runspeed = runspeed;
end

return klonoa;
