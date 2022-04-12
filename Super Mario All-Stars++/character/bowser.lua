--bowser.lua
--v2.0.0
--Created by Horikawa Otane, 2015
--Contact me at https://www.youtube.com/subscription_center?add_user=msotane
--v2.0 Created by Hoeloe

local colliders = require("colliders")
local rng = require("rng")
local pm = require("playerManager")
local panim = require("playeranim")
local followa = require("followa")
local vectr = require("vectr")
local defs = require("expandedDefines")

local bowser = {}

local mountlist = {};

local prevkeys = {run=false,down=false,sel=false,tanooki=false}
local pressedTanooki = false;

local punchTimer = 0;
local punchDur = 24;
local punchingActive = false;
local punchStarted = false;

local punchBox = pm.registerCollider(CHARACTER_BOWSER, 1, "punch", colliders.Box(0,0,24,24));

--Everything that can be hit by Bowser's punch and minions
local hittables = {};

for _,v in ipairs(NPC.HITTABLE) do
	table.insert(hittables,v);
end

local minionQueue = {};
local warriorList = {};
local shield = {};
local hammerList = {};

local fireballs = {};
local iceballs = {};

bowser.MINION_GOOMBA = 0;
bowser.MINION_KOOPA = 1;
bowser.MINION_PARAGOOMBA = 2;
bowser.MINION_PARAKOOPA = 3;
bowser.MINION_CHEEPCHEEP = 4;
bowser.MINION_HAMMERBRO = 5;

--Minion IDs and types
do

--List of possible minions and their AI type
bowser.minionList = {};
bowser.minionList[1] = bowser.MINION_GOOMBA;
bowser.minionList[2] = bowser.MINION_GOOMBA;
bowser.minionList[3] = bowser.MINION_PARAGOOMBA;
bowser.minionList[4] = bowser.MINION_KOOPA;
bowser.minionList[6] = bowser.MINION_KOOPA;
bowser.minionList[27] = bowser.MINION_GOOMBA;
bowser.minionList[28] = bowser.MINION_CHEEPCHEEP;
bowser.minionList[29] = bowser.MINION_HAMMERBRO;
bowser.minionList[36] = bowser.MINION_GOOMBA;
bowser.minionList[48] = bowser.MINION_GOOMBA;
bowser.minionList[53] = bowser.MINION_GOOMBA;
bowser.minionList[54] = bowser.MINION_GOOMBA;
bowser.minionList[55] = bowser.MINION_GOOMBA;
bowser.minionList[71] = bowser.MINION_GOOMBA;
bowser.minionList[72] = bowser.MINION_KOOPA;
bowser.minionList[76] = bowser.MINION_PARAKOOPA;
bowser.minionList[89] = bowser.MINION_GOOMBA;
bowser.minionList[109] = bowser.MINION_KOOPA;
bowser.minionList[110] = bowser.MINION_KOOPA;
bowser.minionList[111] = bowser.MINION_KOOPA;
bowser.minionList[112] = bowser.MINION_KOOPA;
bowser.minionList[117] = bowser.MINION_GOOMBA;
bowser.minionList[118] = bowser.MINION_GOOMBA;
bowser.minionList[119] = bowser.MINION_GOOMBA;
bowser.minionList[120] = bowser.MINION_GOOMBA;
bowser.minionList[121] = bowser.MINION_PARAKOOPA;
bowser.minionList[122] = bowser.MINION_PARAKOOPA;
bowser.minionList[123] = bowser.MINION_PARAKOOPA;
bowser.minionList[124] = bowser.MINION_PARAKOOPA;
bowser.minionList[125] = bowser.MINION_GOOMBA;
bowser.minionList[126] = bowser.MINION_GOOMBA;
bowser.minionList[161] = bowser.MINION_PARAKOOPA;
bowser.minionList[162] = bowser.MINION_GOOMBA;
bowser.minionList[163] = bowser.MINION_GOOMBA;
bowser.minionList[164] = bowser.MINION_GOOMBA;
bowser.minionList[165] = bowser.MINION_GOOMBA;
bowser.minionList[167] = bowser.MINION_PARAGOOMBA;
bowser.minionList[168] = bowser.MINION_GOOMBA;
bowser.minionList[173] = bowser.MINION_KOOPA;
bowser.minionList[175] = bowser.MINION_KOOPA;
bowser.minionList[176] = bowser.MINION_PARAKOOPA;
bowser.minionList[177] = bowser.MINION_PARAKOOPA;
bowser.minionList[189] = bowser.MINION_GOOMBA;
bowser.minionList[207] = bowser.MINION_GOOMBA;
bowser.minionList[229] = bowser.MINION_CHEEPCHEEP;
bowser.minionList[230] = bowser.MINION_CHEEPCHEEP;
bowser.minionList[231] = bowser.MINION_CHEEPCHEEP;
bowser.minionList[232] = bowser.MINION_CHEEPCHEEP;
bowser.minionList[233] = bowser.MINION_CHEEPCHEEP;
bowser.minionList[234] = bowser.MINION_CHEEPCHEEP;
bowser.minionList[235] = bowser.MINION_CHEEPCHEEP;
bowser.minionList[236] = bowser.MINION_CHEEPCHEEP;
bowser.minionList[242] = bowser.MINION_GOOMBA;
bowser.minionList[243] = bowser.MINION_PARAGOOMBA;
bowser.minionList[244] = bowser.MINION_PARAGOOMBA;
bowser.minionList[247] = bowser.MINION_GOOMBA;
bowser.minionList[285] = bowser.MINION_GOOMBA;
bowser.minionList[286] = bowser.MINION_GOOMBA;
bowser.minionList[296] = bowser.MINION_GOOMBA;
bowser.minionList[302] = bowser.MINION_PARAGOOMBA;
bowser.minionList[309] = bowser.MINION_GOOMBA;
bowser.minionList[375] = bowser.MINION_GOOMBA;
bowser.minionList[380] = bowser.MINION_PARAGOOMBA;
bowser.minionList[382] = bowser.MINION_GOOMBA;
bowser.minionList[383] = bowser.MINION_GOOMBA;
bowser.minionList[392] = bowser.MINION_PARAGOOMBA;
bowser.minionList[407] = bowser.MINION_GOOMBA;
bowser.minionList[408] = bowser.MINION_GOOMBA;
bowser.minionList[415] = bowser.MINION_GOOMBA;
bowser.minionList[417] = bowser.MINION_PARAGOOMBA;
bowser.minionList[578] = bowser.MINION_GOOMBA;
bowser.minionList[611] = bowser.MINION_GOOMBA;
bowser.minionList[612] = bowser.MINION_GOOMBA;

--For Koopa and Parakoopa type minions, this determines the ID of the shell they will turn into.
bowser.koopaShells = {}
bowser.koopaShells[4] = 5;
bowser.koopaShells[6] = 7;
bowser.koopaShells[72] = 73;
bowser.koopaShells[76] = 5;
bowser.koopaShells[109] = 113;
bowser.koopaShells[110] = 114;
bowser.koopaShells[111] = 115;
bowser.koopaShells[112] = 116;
bowser.koopaShells[121] = 113;
bowser.koopaShells[122] = 114;
bowser.koopaShells[123] = 115;
bowser.koopaShells[124] = 116;
bowser.koopaShells[161] = 7;
bowser.koopaShells[173] = 172;
bowser.koopaShells[175] = 174;
bowser.koopaShells[176] = 172;
bowser.koopaShells[177] = 174;

--Deployed Paragoomba and Parakoopa troops will ignore IDs in this list.
bowser.shieldIgnoreList = {}
bowser.shieldIgnoreList[5] = true
bowser.shieldIgnoreList[7] = true
bowser.shieldIgnoreList[73] = true
bowser.shieldIgnoreList[113] = true
bowser.shieldIgnoreList[114] = true
bowser.shieldIgnoreList[115] = true
bowser.shieldIgnoreList[116] = true
bowser.shieldIgnoreList[172] = true
bowser.shieldIgnoreList[174] = true
end

local HUD = {}
HUD.npc_box = pm.registerGraphic(CHARACTER_BOWSER, "bowser-hud-npc.png");
HUD.hit_full = pm.registerGraphic(CHARACTER_BOWSER, "bowser-hud-hit.png");
HUD.hit_empty = pm.registerGraphic(CHARACTER_BOWSER, "bowser-hud-hit-empty.png");

local hp = nil;
local power = 2;
local powerdown = false;
local stallTimer = 0;
local stallFall = false;
local killed = false;

function bowser.setHP(v)
	hp = math.min(2,math.max(1,v));
end

function bowser.getHP(v)
	return hp;
end

local function contains(tbl,val)
	for _,v in ipairs(tbl) do
		if(v == val) then
			return true;
		end
	end
	return false;
end

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

--Change the ID of an NPC
local function replaceNPC(npc,id)
	npc:transform(id);
	--[[
	npc.id = id;
	local w = NPC.config[npc.id].width;
	local h = NPC.config[npc.id].height;
	npc:mem(0x90, FIELD_DFLOAT, w);
	npc:mem(0x88, FIELD_DFLOAT, h);
	if(NPC.config[npc.id].gfxwidth ~= 0) then
		w = NPC.config[npc.id].gfxwidth;
	end
	if(NPC.config[npc.id].gfxheight ~= 0) then
		h = NPC.config[npc.id].gfxheight;
	end
	npc:mem(0xB8, FIELD_DFLOAT, w);
	npc:mem(0xC0, FIELD_DFLOAT, h);
	npc:mem(0xE4, FIELD_WORD, 0);
	]]
end

--Spawn a tiny smoke puff on the location of an object.
local function spawnSmoke(k)
	local a = Animation.spawn(10,k.x+k.width*0.5,k.y+k.height*0.5);
	a.x = a.x - a.width*0.5;
	a.y = a.y - a.height*0.5;
end

--Add a minion to the queue.
local function pushMinion(npc)
	local target = minionQueue[#minionQueue];
	if(target == nil) then 
		target = player; 
	else
		target = target.npc;
	end
	npc:mem(0xDC,FIELD_WORD,0); --Prevent respawning
	local ftype = followa.TYPE.WALK_JUMP;
	if(bowser.minionList[npc.id] == bowser.MINION_CHEEPCHEEP) then
		ftype = followa.TYPE.FLY;
	end
	followa.Follow(npc,target,4,vectr.v2(0,0),target.width,320,ftype);
	table.insert(minionQueue, {id = npc.id, npc = npc});
	if(bowser.minionList[npc.id] == bowser.MINION_PARAGOOMBA or bowser.minionList[npc.id] == bowser.MINION_PARAKOOPA) then
		minionQueue[#minionQueue].ai1 = npc.ai1;
	end
end

--Remove a minion from the queue.
local function popMinion()
	if(#minionQueue > 0) then
		local npc = minionQueue[1];
		table.remove(minionQueue, 1);
		if(#minionQueue > 0) then
			followa.Follow(minionQueue[1].npc,player,4,vectr.v2(0,0),player.width,320);
		end
		if(npc.npc.isValid) then
			return npc;
		end
	end
	return nil;
end

--Change the order of the minion queue.
local function rotateMinions()
	if(#minionQueue > 1) then
		local npc = popMinion();
		if(npc ~= nil) then
			followa.Follow(npc.npc,minionQueue[#minionQueue].npc,4,vectr.v2(0,0),minionQueue[#minionQueue].npc.width,320);
			table.insert(minionQueue, {id = npc.npc.id, npc = npc.npc});
		end
	end
end

--Kill a minion from the queue.
local function discardMinion()
	local npc = popMinion();	
	spawnSmoke(npc.npc);
	npc.npc:kill(9);
end

function bowser.onInitAPI()
	registerEvent(bowser, "onTick", "onTick", false)
	registerEvent(bowser, "onDraw", "onDraw", false)
	registerEvent(bowser, "onInputUpdate", "onInputUpdate", false)
	registerEvent(bowser, "onNPCKill", "onNPCKill", false)
	registerEvent(bowser, "onExitLevel", "onExitLevel", false)
end

function bowser.onInputUpdate()
	if player.character == CHARACTER_BOWSER then
		pm.winStateCheck()
		if(player:mem(0x13E,FIELD_BOOL)) then --Oops we dead.
			return;
		end
		
		--Keep track of previous key states.
		local prun = prevkeys.run;
		local psel = prevkeys.sel;
		local ptan = prevkeys.tanooki;
		prevkeys.run = player.runKeyPressing;
		prevkeys.sel = player.dropItemKeyPressing;
		prevkeys.tanooki = player.altRunKeyPressing
		
		--If we're doing Tanooki Bowser's stall-and-fall, then hijack controls early.
		if(stallFall) then
			--Force statue mode
			player:mem(0x4A,FIELD_BOOL,true);
			player:mem(0x4C,FIELD_WORD,9999);
			player:mem(0x4E,FIELD_WORD,1);
			
			if(stallTimer > 0) then 	--STALL
				player.speedX = 0;
				stallTimer = stallTimer - 1;
				player.speedY = -Defines.player_grav-math.max(0,(stallTimer-10)/5);
			else						--FALL
				player.speedY = 24;
				if(player:isGroundTouching() and stallTimer == 0) then --We just hit the ground
					Defines.earthquake = 6;
					local a1 = Animation.spawn(10,player.x,player.y+player.height);
					local a2 = Animation.spawn(10,player.x+player.width,player.y+player.height);
					a1.x = a1.x-a1.width*0.5
					a2.x = a2.x-a1.width*0.5
					a1.y = a1.y-a1.height*0.5
					a2.y = a2.y-a1.height*0.5
					local _,_,cs = colliders.collideNPC(colliders.Box(player.x-32,player.y+player.height-16,player.width+32,16),hittables);
					for _,v in ipairs(cs) do
						if(not v.friendly and not v.isHidden) then
							v:harm(HARM_TYPE_FROMBELOW)
						end
					end
					playSFX(37);
					stallTimer = -1;
				end
				if(stallTimer < 0) then
					stallTimer = stallTimer - 1;
				end
				--Hold "statue" mode for a bit after we hit the ground.
				if(stallTimer <= -30 and not player.downKeyPressing or stallTimer <= -140) then
					stallFall = false;
					player:mem(0x4A,FIELD_BOOL,false);
				end
			end
			
			--Disable all input if we're stall-and-falling.
			player.upKeyPressing = false;
			player.downKeyPressing = false;
			player.leftKeyPressing = false;
			player.rightKeyPressing = false;
			player.jumpKeyPressing = false;
			player.altJumpKeyPressing = false;
			player.runKeyPressing = false;
			player.altRunKeyPressing = false;
			player.dropItemKeyPressing = false;
		end
		
		--Disable input if we're punching.
		if(punchTimer > 0 and not Misc.isPaused()) then
			player.upKeyPressing = false;
			player.downKeyPressing = prevkeys.down;
			player.leftKeyPressing = false;
			player.rightKeyPressing = false;
			player.jumpKeyPressing = false;
			player.altJumpKeyPressing = false;
			player.runKeyPressing = false;
			player.altRunKeyPressing = false;
			player.dropItemKeyPressing = false;
		end
		
		--Activate stall-and-fall
		if(not stallFall and player.powerup == PLAYER_TANOOKIE and prevkeys.down == false and player.downKeyPressing and not player:isGroundTouching()) then
			stallFall = true;
			playSFX(34);
			stallTimer = 22;
		end
		
		prevkeys.down = player.downKeyPressing;
	
		--Disable spinjump
		if(player.altJumpKeyPressing and player:mem(0x108,FIELD_WORD) == 0 --[[No mount]]) then
			player.jumpKeyPressing = true;
			player.altJumpKeyPressing = false;
		end
		
		--Rotate minion queue
		if(not psel and player.dropItemKeyPressing) then
			if(#minionQueue > 1) then
				playSFX(26);
				rotateMinions();
			end
		end
		
		--Release minion
		if(not ptan and player.altRunKeyPressing) then
			if(player.powerup == PLAYER_TANOOKIE) then
				player.runKeyPressing = true;
			end
			--Take a minion from the front of the queue.
			local p = popMinion();
			if(p ~= nil) then
				--Set the minion direction and start special behaviour
				p.npc.direction = player:mem(0x106,FIELD_WORD)
				
				--Ensure the punch anim happens
				punchTimer = punchDur;
				punchStarted = false;
				player.runKeyPressing = false;
	
				if(bowser.minionList[p.npc.id] == bowser.MINION_GOOMBA or bowser.minionList[p.npc.id] == bowser.MINION_CHEEPCHEEP) then			--GOOMBA/CHEEPCHEEP			RELEASE MINION TO DEFAULT AI
					followa.StopFollowing(p.npc);
					table.insert(warriorList,p.npc);
				elseif(bowser.minionList[p.npc.id] == bowser.MINION_KOOPA) then																	--KOOPACONVERT				CONVERT TO SHELL AND THROW FORWARDS
					replaceNPC(p.npc, bowser.koopaShells[p.npc.id]);
					p.npc.data.isDanger = true;
					p.npc.data.dangerCounter = 30;
					p.npc.speedX = p.npc.direction*5;
					followa.StopFollowing(p.npc);
					table.insert(warriorList,p.npc)
				elseif(bowser.minionList[p.npc.id] == bowser.MINION_PARAGOOMBA or bowser.minionList[p.npc.id] == bowser.MINION_PARAKOOPA) then	--PARAGOOMBA/PARAKOOPA		ADD TO ROTATING SHIELD
					table.insert(warriorList,p.npc)
					p.npc.data.isShield = true;
					local t = vectr.v2(player.x+(player.width-p.npc.width)*0.5 + 128*player:mem(0x106,FIELD_WORD),player.y + (player.height-p.npc.height)*0.5);
					table.insert(shield,{npc=p.npc,target=t,pos=vectr.v2(p.npc.x,p.npc.y),t=90*player:mem(0x106,FIELD_WORD)})
					followa.StopFollowing(p.npc);
				elseif(bowser.minionList[p.npc.id] == bowser.MINION_HAMMERBRO) then																--HAMMERBRO					ADD TO HAMMERBRO LIST AND RELEASE TO DEFAULT AI
					table.insert(hammerList,p.npc)
					followa.StopFollowing(p.npc);
				end
			end
		end
		
		--Disable statue form
		if(player.powerup == PLAYER_TANOOKIE) then
			player.altRunKeyPressing = false;
		end
		
		
		--Filter mounts
		if player:mem(0x108,FIELD_WORD) ~= 2 then
			player:mem(0x108,FIELD_WORD,0)
		end
		
		local newmounts = {}
		local sx = math.abs(player.speedX)*2;
		local sy = math.abs(player.speedY)*2;
		for k,v in ipairs(NPC.getIntersecting(player.x-sx,player.y-sy,player.x+player.width+sx,player.y+player.height+sy)) do
			if(v.id == 35 or v.id == 193 or v.id == 191 or v.id == 148 or v.id == 98 or v.id == 228 or v.id == 95 or v.id == 150 or v.id == 149 or v.id == 100 or v.id == 99) then
				if(mountlist[v] ~= nil) then
					newmounts[v] = mountlist[v];
				else
					newmounts[v] = v.friendly;
				end
				v.friendly = true;
			end
		end
		for k,v in pairs(mountlist) do
			if(newmounts[k] == nil and k.isValid) then
				k.friendly = v;
			end
		end
		mountlist = newmounts;
		
		--Do punch
		if(player.runKeyPressing and not prun and player.forcedState == 0 and player:mem(0x40,FIELD_WORD) == 0) then
			punchTimer = punchDur;
			punchStarted = false;
			player.runKeyPressing = false;
		end
	end
end

local function managePowerups()
	local i = 1;
	
	--Track fireballs
	while(i <= #fireballs) do
		local v = fireballs[i];
		if(v.isValid) then
			local killed = false;
			local b,_,cs = colliders.collideNPC(v,hittables);
			
			--Hit things with fireballs
			for _,w in ipairs(cs) do
				if(not w.friendly and not w.isHidden) then
					w:harm(HARM_TYPE_PROJECTILE_USED);
					spawnSmoke(v);
					playSFX(3)
					v:kill(4);
					killed = true;
					break;
				end
			end
			
			--Melt ice blocks
			if(not killed) then
				local b,_,cs = colliders.collideBlock(v,colliders.BLOCK_SOLID..colliders.BLOCK_LAVA..colliders.BLOCK_PLAYER);
				for _,w in ipairs(cs) do
					if(not w.isHidden) then
						if (w.id == 633 or w.id == 620 or w.id == 621 or w.id == 634) then
							-- Frozen coin
							if (w.id == 620) then 
								NPC.spawn(10, w.x, w.y, player.section);
							end
							-- Large ice block
							if (w.id == 634) then
								if(v.x > w.x) then --hit right side
									Block.spawn(633, w.x, w.y);
									Block.spawn(633, w.x, w.y+w.height*0.5);
									Animation.spawn(10, w.x, w.y);
									Animation.spawn(10, w.x, w.y+w.height*0.5);
								else --hit left side
									Block.spawn(633, w.x+w.width*0.5, w.y);
									Block.spawn(633, w.x+w.width*0.5, w.y+w.height*0.5);
									Animation.spawn(10, w.x+w.width*0.5, w.y);
									Animation.spawn(10, w.x+w.width*0.5, w.y+w.height*0.5);
								end
							elseif (w.id == 621) then --Munch munch
								Block.spawn(109, w.x, w.y);
							else
								Animation.spawn(10, w.x, w.y)
							end
							w:remove();
							playSFX(16);
						end
						spawnSmoke(v);
						playSFX(3)
						v:kill(4);
						killed = true;
						break;
					end
				end
			end
			i = i+1;
		else
			table.remove(fireballs,i);
		end
	end
	
	i = 1;
	--Track iceballs
	while(i <= #iceballs) do
		local v = iceballs[i];
		if(v.isValid) then
			local b,_,cs = colliders.collideNPC(v,hittables);
			--Hit things with iceballs and freeze them
			for _,w in ipairs(cs) do
				if(not w.friendly and not w.isHidden) then
					w:toIce();
					playSFX(3)
					v:kill(4);
					break;
				end
			end
			i = i+1;
		else
			table.remove(iceballs,i);
		end
	end
	
	--Change jumpheight based on powerup
	if(player.character == CHARACTER_BOWSER) then
		if(player.powerup == PLAYER_LEAF or player.powerup == PLAYER_TANOOKIE) then
			player:mem(0x164,FIELD_WORD,-2);
			if(ducking_ext()) then
				player:mem(0x12E,FIELD_BOOL,true);
			end
			Defines.jumpheight = 40;
			Defines.jumpheight_bounce = 40;
			player:mem(0x172,FIELD_BOOL,false);
			player:mem(0x168,FIELD_FLOAT,0);
		else
			Defines.jumpheight = 13;
			Defines.jumpheight_bounce = 13;
		end
	end
end

function bowser.onTick()
	if player.character == CHARACTER_BOWSER then
	
		player:mem(0x160,FIELD_WORD, 2);	--Disable default projectiles
		
		if(not killed and player:mem(0x13E,FIELD_BOOL)) then
			killed = true;
			playSFX(5);
		end
		
		if(player:mem(0x122,FIELD_WORD) == 2) then	--Powering down? Then update HP.
			if(not powerdown and hp == 1) then --This happens if player is hurt when on 1HP, so should die.
				killed = true;
				player:kill();
			end
			powerdown = true;
			panim.setFrame(player,30);	--Set hurt frame
		else
			powerdown = false;
		end
			
		if((player:mem(0x122,FIELD_WORD) == 1 or player:mem(0x122,FIELD_WORD) == 4 or player:mem(0x122,FIELD_WORD) == 5 or player:mem(0x122,FIELD_WORD) == 11 or player:mem(0x122,FIELD_WORD) == 12 or player:mem(0x122,FIELD_WORD) == 41) and hp == 1) then
			hp = 2;
		end
		--Lock player to "big" state, for animation purposes.
		if (player.powerup == 1) then
			hp = 1;
			player.powerup = 2;
		end
		
		--Update Bowser's hitboxes and spritesheets based on "hp" variable. This allows the "bowser-1" information to be used even though we lock him to "big" state.
		if(hp < 2) then
			Graphics.sprites.bowser[2].img = Graphics.sprites.bowser[1].img;
			if(power > 1) then
				power = 1;
				Misc.loadCharacterHitBoxes(2, player.powerup, pm.getHitboxPath(CHARACTER_BOWSER,1));
			end
		else
			if(power < 2) then
				power = 2;
				Graphics.sprites.bowser[2].img = pm.getCostumeImage(CHARACTER_BOWSER,2);
				Misc.loadCharacterHitBoxes(2, player.powerup, pm.getHitboxPath(CHARACTER_BOWSER,player.powerup));
			end
		end
		
		--No reserve powerups for you.
		player.reservePowerup = 0
		
		--Update rotating shield
		local i = 1;
		while(i <= #shield) do
			local v = shield[i];
			if(v.npc.isValid) then
				--Stop despawning and make rotating shield NPCs stay in the same section as Bowser
				v.npc:mem(0x12A, FIELD_WORD, 180);
				v.npc:mem(0x128, FIELD_BOOL, false);
				v.npc:mem(0x146, FIELD_WORD, player.section);
				v.npc:mem(0x74, FIELD_BOOL, false);
				
				v.target.x = player.x+(player.width-v.npc.width)*0.5 + 128*math.sin(v.t);
				v.target.y = player.y+(player.height-v.npc.height)*0.5 + 128*math.cos(v.t);
				v.t = v.t+0.05;
				if((v.pos-v.target).length > 800) then
					v.pos = v.target;
				end
				v.pos = vectr.lerp(v.pos, v.target, 0.2)
				v.npc.x = v.pos.x;
				v.npc.y = v.pos.y;
				i = i + 1;
			else
				table.remove(shield,i);
			end
		end
		
		--Update followers
		local k = 1;
		while(k <= #minionQueue) do
			v = minionQueue[k];
			if(v.npc.isValid) then
				--Stop despawning and make followers stay in the same section as Bowser
				v.npc:mem(0x12A, FIELD_WORD, 180);
				v.npc:mem(0x128, FIELD_BOOL, false);
				v.npc:mem(0x146, FIELD_WORD, player.section);
				v.npc:mem(0x74, FIELD_BOOL, false);
				
				--Update follower behaviours
				if(bowser.minionList[v.id] == bowser.MINION_PARAGOOMBA or bowser.minionList[v.id] == bowser.MINION_PARAKOOPA) then
					v.npc.ai1 = 0;
					if(minionQueue[k+1] ~= nil) then
						followa.Update(minionQueue[k+1].npc, vectr.v2(v.npc.x+v.npc.width*0.5,player.y+player.height));
					end
				elseif(bowser.minionList[v.id] == bowser.MINION_CHEEPCHEEP) then
					if(v.npc.underwater) then
						followa.SetBehaviour(v.npc, followa.TYPE.FLY);
						if(minionQueue[k+1] ~= nil) then
							followa.Update(minionQueue[k+1].npc, v.npc);
						end
					else
						followa.SetBehaviour(v.npc, followa.TYPE.WALK);
						if(minionQueue[k+1] ~= nil) then
							followa.Update(minionQueue[k+1].npc, vectr.v2(v.npc.x+v.npc.width*0.5,player.y+player.height));
						end
					end
				end
				k = k+1;
			else
				table.remove(minionQueue,k);
			end
		end;
		
		if(not player:mem(0x13E,FIELD_BOOL)) then --We not dead.
			--Update punch
			if(punchTimer > 0) then
				punchTimer = punchTimer - 1;
				
				local f = 46;
				local yoff = 16;
				--Get frame and hitbox offset based on crouch state
				if(player:mem(0x12E, FIELD_BOOL)) then
					f = f + 2;
					yoff = 0;
				end
				--Second punching frame active
				if(punchTimer<punchDur*0.6) then
					if(not punchStarted) then --Punch just happened
						playSFX(77);
						punchBox.active = true;
						
						--Spawn projecties
						if(player.powerup == PLAYER_FIREFLOWER) then		--SPAWN FIREBALL
							local n = NPC.spawn(87,player.x+(1+player:mem(0x106,FIELD_WORD))*player.width*0.5,player.y + 16, player.section);
							n.direction = player:mem(0x106,FIELD_WORD);
							if(n.direction == -1) then
								n.x = n.x-n.width;
							end
							n.speedX = n.direction * 3;
							n.friendly = true;
							playSFX(42);
							table.insert(fireballs,n);
						elseif(player.powerup == PLAYER_ICE) then			--SPAWN ICEBALL
							local n = NPC.spawn(237,player.x+(1+player:mem(0x106,FIELD_WORD))*player.width*0.5,player.y + 16, player.section);
							n.direction = player:mem(0x106,FIELD_WORD);
							if(n.direction == -1) then
								n.x = n.x-n.width;
							end
							n.speedX = n.direction * 3;
							n.friendly = true;
							playSFX(25);
							table.insert(iceballs,n);
							elseif(player.powerup == PLAYER_HAMMER) then	--SPAWN 3 HAMMERS
								local f = function() 
												local n = NPC.spawn(171,player.x+(1+player:mem(0x106,FIELD_WORD))*player.width*0.5,player.y + 16, player.section);
												n.direction = player:mem(0x106,FIELD_WORD);
												if(n.direction == -1) then
													n.x = n.x-n.width;
												end
												n.speedX = n.direction * 3;
												n.speedY = -8;
												playSFX(25);
											end
							f();	--Spawn first hammer immediately
							Routine.setFrameTimer(8, f, 2); --Spawn 2 more hammers
						end
					end
					
					--Set frame offsets
					punchStarted = true;
					f = f + 1;
					
					--Hitbox
					if(punchTimer > punchDur*0.3) then
						punchBox.active = true;
						--Set hitbox offsets
						local offset = -punchBox.width;
						if(player:mem(0x106,FIELD_WORD) == 1) then --Player is facing right
							offset = player.width;
						end
						punchBox.x = player.x+offset;
						punchBox.y = player.y+yoff;
					else
						punchBox.active = false;
						punchingActive = false;
					end
				end
				
				--Set animation frame
				panim.setFrame(player,f);
				
				--Do punch collision tests!
				if(punchBox.active) then
					local h,_,cs = colliders.collideNPC(punchBox, hittables);
					if(h) then
						for _,v in ipairs(cs) do
							if(not v.friendly and not v.isHidden) then
								v:harm(HARM_TYPE_SWORD);
								punchBox.active = false;
							end
						end
					end
				end
		
			else
				punchBox.active = false;
			end
		end
		
		--Update activated "warrior" minions
		local i = 1;
		while (i <= #warriorList) do
			local rem = false;
			--Check that the npc hasn't died or despawned
			if(warriorList[i].isValid and warriorList[i]:mem(0x12A,FIELD_WORD) > 0) then
				
				--Should this NPC hurt Bowser? (i.e. is a koopa shell). Make sure it's clear of his hitbox before making it unfriendly.
				if(warriorList[i].data.isDanger) then
					if(warriorList[i].data.dangerCounter > 0) then
						warriorList[i].data.dangerCounter = warriorList[i].data.dangerCounter - 1;
					elseif (not colliders.collide(warriorList[i],player)) then
						warriorList[i].friendly = false;
					end

				else
				--Do collisions manually if the NPC is a friendly one.
				
					local h,_,cs = colliders.collideNPC(warriorList[i], hittables);
					if(h) then
						for _,v in ipairs(cs) do
							if(not v.friendly and not v:mem(0x40,FIELD_BOOL)) then
								--Make sure the collision is between a rotating shield NPC and an NPC on the shield ignore list.
								if(warriorList[i].data.isShield ~= true or bowser.shieldIgnoreList[v.id] ~= true) then
									--Harm the enemy, but make sure it register being hurt by a warrior so it doesn't get added to the minion queue.
									if(v ~= warriorList[i]) then
										v.data.BOWSER_killedByMinion = true;
										v:harm(HARM_TYPE_HELD);
										if(bowser.minionList[warriorList[i].id] == bowser.MINION_PARAKOOPA) then
											NPC.spawn(bowser.koopaShells[warriorList[i].id],warriorList[i].x,warriorList[i].y,warriorList[i]:mem(0x146,FIELD_WORD));
											warriorList[i]:kill(9);
										else
											warriorList[i].data.BOWSER_killedByMinion = true;
											warriorList[i]:kill(HARM_TYPE_HELD);
										end
										rem = true;
										break;
									end
								end
							end
						end
					end
				end
			else
				rem = true;
			end
			if(not rem) then
				i = i + 1;
			else
				table.remove(warriorList,i);
			end
		end
		
		--Check for newly thrown hammers from friendly hammer bros to convert them to player-type hammers.
		--TODO: Replace this with a more robust check (this is as robust as it gets without a reference to the NPC that threw the hammers)
		local i = 1;
		while (i <= #hammerList) do
			if(hammerList[i].isValid) then
				if(hammerList[i]:mem(0xE4,FIELD_WORD) == 2 or hammerList[i]:mem(0xE4,FIELD_WORD) == 5) then
					local b,_,cs = colliders.collideNPC(colliders.Box(hammerList[i].x, hammerList[i].y,1,1), 30);
					for _,v in ipairs(cs) do
						if(v.friendly and not v.isHidden and v:mem(0x124,FIELD_WORD) == -1 and v.animationFrame == 0 and v.speedX == 3*hammerList[i].direction and v.speedY == -8 and hammerList[i].x == v.x and hammerList[i].y == v.y) then
							replaceNPC(v,171);
							v.friendly = false;
							break;
						end
					end
				end
				i = i+1;
			else
				table.remove(hammerList,i);
			end
		end
	end
		
	managePowerups();
end

local function drawHUD()
	--NPC box
	Graphics.draw{x=405,y=16,type=RTYPE_IMAGE,image=pm.getGraphic(CHARACTER_BOWSER,HUD.npc_box), priority=-5};
	if(#minionQueue > 0 and minionQueue[1].npc.isValid) then
		local gfxw = NPC.config[minionQueue[1].id].gfxwidth;
		local gfxh = NPC.config[minionQueue[1].id].gfxheight;
		if(gfxw == 0) then
			gfxw = minionQueue[1].npc.width;
		end
		if(gfxh == 0) then
			gfxh = minionQueue[1].npc.height;
		end
		Graphics.draw{x=433-gfxw*0.5,y=44-gfxh*0.5,type=RTYPE_IMAGE,image=Graphics.sprites.npc[minionQueue[1].id].img,sourceX=0,sourceY=0,sourceWidth=gfxw,sourceHeight=gfxh, priority=-5};
	end
	
	--HP box
	local hitimg;
	if(hp > 1) then
		hitimg = pm.getGraphic(CHARACTER_BOWSER,HUD.hit_full);
	else
		hitimg = pm.getGraphic(CHARACTER_BOWSER,HUD.hit_empty);
	end
	Graphics.draw{x=339,y=16,type=RTYPE_IMAGE,image=hitimg, priority=-5};
	
	--Life counter
	--Graphics.draw{x=234,y=26,type=RTYPE_IMAGE,image=Graphics.sprites.hardcoded["33-3"].img, priority=-5};
	--Graphics.draw{x=274,y=27,type=RTYPE_IMAGE,image=Graphics.sprites.hardcoded["33-1"].img, priority=-5};
	--Text.printWP(mem(0x00B2C5AC,FIELD_FLOAT),1,296,27,-5);
	
	--Coin counter
	--Graphics.draw{x=488,y=26,type=RTYPE_IMAGE,image=Graphics.sprites.hardcoded["33-2"].img, priority=-5};
	--Graphics.draw{x=512,y=27,type=RTYPE_IMAGE,image=Graphics.sprites.hardcoded["33-1"].img, priority=-5};
	--Text.printWP(mem(0x00B2C5A8,FIELD_WORD),1,552-18*(#tostring(mem(0x00B2C5A8,FIELD_WORD))-1),27, -5);
	
	--Score
	--Text.printWP(mem(0x00B2C8E4,FIELD_DWORD),1,552-18*(#tostring(mem( 0x00B2C8E4,FIELD_DWORD))-1),47, -5);
	
	--Star counter
	--if(mem(0x00B251E0,FIELD_WORD) > 0) then
		--Graphics.draw{x=250,y=46,type=RTYPE_IMAGE,image=Graphics.sprites.hardcoded["33-5"].img, priority=-5};
		--Graphics.draw{x=274,y=47,type=RTYPE_IMAGE,image=Graphics.sprites.hardcoded["33-1"].img, priority=-5};
		--Text.printWP(mem(0x00B251E0,FIELD_WORD),1,296,47,5);
	--end
end

function bowser.onDraw()
	if(player.character == CHARACTER_BOWSER) then
		drawHUD();
		
		--Update rotating shield positions before drawing them to avoid visual glitchiness when they're inside walls.
		for k,v in ipairs(shield) do
			if(v.npc.isValid) then
				v.npc.x = v.pos.x;
				v.npc.y = v.pos.y;
			end
		end
	end
end

function bowser.onNPCKill(eventObj, npc, reason)
	if player.character == CHARACTER_BOWSER then
		if(reason == 9 and (contains(NPC.POWERUP,npc.id) or npc.id == 250) and npc.id ~= 90 and npc.id ~= 186 and npc.id ~= 187 and npc.id ~= 188 and npc.id ~= 273 and colliders.collide(npc,player)) then
			--Register powerups to keep track of health
			hp = 2;
		elseif(reason == 9 and npc:mem(0x12A,FIELD_WORD) == -1) then
			--Check for despawning minions, and stop them despawning
			for _,v in ipairs(minionQueue) do
				if(v.npc == npc) then
					eventObj.cancelled = true;
					break;
				end
			end
			for _,v in ipairs(shield) do
				if(v.npc == npc) then
					eventObj.cancelled = true;
					break;
				end
			end
		elseif(reason <= 10 and reason ~= 9 and reason ~= 6 and reason ~= 4 and reason ~= 3 and bowser.minionList[npc.id] ~= nil and npc.data.BOWSER_killedByMinion ~= true) then
				--Recruit a minion!
				pushMinion(npc);
				eventObj.cancelled = true;
				playSFX(13);
				playSFX(2);
		end
	end
end

function bowser.onExitLevel()
	--Revert powerup based on health so it can be restored in the next level.
	if(player.character == CHARACTER_BOWSER) then
		if(hp == nil or hp < 2) then
			player.powerup = 1;
		end
	end
end

function bowser.initCharacter()
	--Set Bowser's mobility stats
	--TODO: Make this more stable
	Defines.player_walkspeed = 2;
	Defines.player_runspeed = 4;
	Defines.jumpheight = 13;
	Defines.jumpheight_bounce = 13;
	
	--Update powerup based on HP if the value is already set (means we've changed character to Bowser after having switched away from him).
	if(hp ~= nil and hp < 2) then
		player.powerup = 1;
	end
	
	--Set health based on powerup state.
	if(player.powerup > 1) then
		hp = 2;
	else
		hp = 1;
	end
	
	if(player.powerup < 2) then
		player.powerup = 2;
	end
	
	--TODO: Make this more stable
	--hud(false);
end

function bowser.cleanupCharacter()
		--Revert any mounts we've set to be unusable
		for k,v in pairs(mountlist) do
			if(k.isValid) then
				k.friendly = v;
			end
		end
		
		--Reset Bowser's mobility stats
		--TODO: Make this more stable
		Defines.player_walkspeed = nil;
		Defines.player_runspeed = nil;
		Defines.jumpheight = nil;
		Defines.jumpheight_bounce = nil;
		
		--Despawn all minions
		while(#minionQueue > 0) do
			discardMinion();
		end
		
		--Despawn rotating shield
		while(#shield > 0) do
			if(shield[#shield].npc.isValid) then
				local k = shield[#shield].npc;
				spawnSmoke(k);
				shield[#shield].npc:kill(9);
			end
			shield[#shield] = nil;
		end
		
	--TODO: Make this more stable
		hud(true);
end

return bowser