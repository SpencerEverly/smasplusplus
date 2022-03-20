local npcManager = require("npcManager")
local colliders = require("colliders")
local npcutils = require("npcs/npcutils")

local babyYoshis = {}

--***************************************************************************************************
--                                                                                                  *
--              DEFAULTS AND NPC CONFIGURATION                                                      *
--                                                                                                  *
--***************************************************************************************************

local isBabyYoshi = {};
local babyYoshiInfo = {};

babyYoshis.babyYoshiSettings = {
	gfxoffsety = 0, 
	gfxwidth = 32, 
	gfxheight = 32, 
	width = 32, 
	height = 32, 
	frames = 2, 
	framespeed = 8, 
	framestyle = 1, 
	score = 0, 
	nofireball = 1, 
	noiceball = -1,
	noyoshi = 1, 
	nohurt = -1, 
	jumphurt = 1, 
	grabside = 1,
	harmlessgrab = true,
	harmlessthrown = true,
	-- Custom
	blinktimer = 25,
	blinklength = 8,
	bounceheight = -2, 
	hunger = 5
};

--just some constants
babyYoshis.colors = {
	GREEN = {egg = 0, yoshi = 95},
	RED = {egg = 3, yoshi = 100},
	BLUE = {egg = 1, yoshi = 98},
	YELLOW = {egg = 2, yoshi = 99},
	BLACK = {egg = 4, yoshi = 148},
	PURPLE = {egg = 5, yoshi = 149},
	PINK = {egg = 6, yoshi = 150},
	CYAN = {egg = 7, yoshi = 228}
}

function babyYoshis.registerColor(name, eggCol, yoshiID)
	babyYoshis.colors[name] = {egg = eggCol, yoshi = yoshiID}
end

-- Setup for registering baby yoshis
function babyYoshis.register(id, color, swallowFunction)
	isBabyYoshi[id] = true
	
	local info = {}
	info.swallowFunction = swallowFunction;
	info.eggColor = color.egg;
	info.yoshi = color.yoshi;
	babyYoshiInfo[id] = info;
	
	npcManager.registerEvent(id, babyYoshis, "onTickEndNPC")
	
	npcManager.registerHarmTypes(id, 	
	{HARM_TYPE_LAVA}, {[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5}});
end

function babyYoshis.onInitAPI()
	npcManager.registerEvent(96, babyYoshis, "onTickEndNPC", "onTickEndNPCEgg")
	registerEvent(babyYoshis, "onTickEnd", "onTickEndEggEffect");
	registerEvent(babyYoshis, "onNPCKill");
end

--*********************************************
--                                            *
--              MAIN YOSHI AI                 *
--                                            *
--*********************************************

-- stolen from mechakoopa
local function setDir(dir, v)
	if dir then
		v.direction = 1
	else
		v.direction = -1
	end
end

function babyYoshis.onNPCKill(e,v,r)
	if isBabyYoshi[id] then
		for k,n in ipairs(v.data._basegame.eatenNPCs) do
			if n.npc.isValid then
				n.npc:kill(9)
			end
		end
	end
end

-- regular tick behavior
function babyYoshis.onTickEndNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data._basegame
	
	if (v:mem(0x12A, FIELD_WORD) <= 0 or v:mem(0x138, FIELD_WORD) > 0) then	
		-- failsafe to come out of block as egg
		if (v:mem(0x138, FIELD_WORD) == 1 or v:mem(0x138, FIELD_WORD) == 3) then
			v.ai1 = v.id;
			v.id = 96;
			
			if (v:mem(0x138, FIELD_WORD) == 1) then
				v.speedY = -5;
				
				v.y = v.y - (NPC.config[v.ai1].gfxheight);
				v:mem(0x13C, FIELD_DFLOAT, NPC.config[v.ai1].gfxheight)
			end
		else
			v.ai1 = NPC.config[v.id].blinktimer; -- Blinking Timer
			v.ai2 = 0; -- Enemies Devoured Counter
			v.ai4 = 0; -- eating animation countdown
		
			v.animationFrame = npcutils.getFrameByFramestyle(v, {
				frame = 0,
				frames = 2 * NPC.config[v.id].frames
			})
		end
		return
	end
	
	local data = v.data._basegame
	if data.exists == nil then
		v.ai2 = 0;
		data.exists = 1;
		data.frame = 0;
		data.voreCollider = colliders.Box(v.x - v.width / 3, v.y - v.height / 3, v.width + 16, v.height + 16);
		
		data.eatenNPCs = {};
	end
	
	---------------
	-- Actual AI --
	---------------
	
	-- blinking
	if data.frame <= 1 then
		v.ai1 = v.ai1 - 1;
		if v.ai1 <= 0 then
			data.frame = 1;
		end
		if v.ai1 == -NPC.config[v.id].blinklength then
			v.ai1 = NPC.config[v.id].blinktimer;
			data.frame = 0;
		end
	end
				
	-- bouncing
	if v.collidesBlockBottom then
		v.speedY = NPC.config[v.id].bounceheight;
		
		if math.abs(v.speedX) < 0.1 then
			v.speedX = 0
		else
			v.speedX = v.speedX * 0.3
		end
	end
	
	-- update animation frames
	v.animationFrame = npcutils.getFrameByFramestyle(v, {
		frame = data.frame,
		frames = NPC.config[v.id].frames * 2
	});
	v.animationTimer = 500;
	
	-- Don't do this stuff if it's friendly
	if v.friendly then return end;
	
	-- player collide
	for _,w in ipairs(Player.get()) do
		if colliders.collide(w, v) and not w.runKeyPressing and not w.altRunKeyPressing and not v.dontMove and v.speedY > -5 then
			setDir(w.x < v.x, v)
			
			v.speedX = 3 * v.direction;
			SFX.play(9)
		end
	end
	
	-- Time to vore some enemies
	
	-- Update eating collider
	data.voreCollider.x = v.x - 8;
	data.voreCollider.y = v.y - 8;

	local cfg = NPC.config[v.id]

	if v.ai2 < cfg.hunger then

		-- Get any NPC that might be colliding
		local collidingNPCs = colliders.getColliding{
			a = data.voreCollider,
			b = NPC.HITTABLE .. NPC.POWERUP,
			btype = colliders.NPC,
			filter = function(other)
			if (not other:mem(0x64, FIELD_BOOL)) and (not other.isHidden) and (not NPC.config[other.id].noyoshi) and other:mem(0x12A, FIELD_WORD) > 0 and not other.friendly then
				return true
			end
			return false
			end
		};
		
		-- Determine what to eat
		for k, _ in ipairs(collidingNPCs) do
			setDir(collidingNPCs[k].x > v.x, v)
			data.frame = 2;
			table.insert(data.eatenNPCs, 1, {npc = collidingNPCs[k], timer = 25});
		end

		if #data.eatenNPCs == 0 and data.frame == 2 then
			data.frame = 0
		end

		-- Actual eating code
		for k = #data.eatenNPCs, 1, -1 do
			local e = data.eatenNPCs[k]
			if e and e.npc.isValid then
				e.npc:mem(0x138, FIELD_WORD, 5)
				if v.ai2 >= cfg.hunger then
					e.npc.friendly = false;
					-- Billy Gun failsafe case
					if (e.npc.id == 17) then
						e.npc:kill(9)
					end
					table.remove(data.eatenNPCs, k);
				else
					e.timer = e.timer - 1;
					
					local offset = (e.timer / 3) * v.direction
					if v.direction == -1 then
						offset = offset - e.npc.width
					end
					-- Update target npc, bound to the bottom edge closest to yoshi
					e.npc.x = v.x + v.width * 0.5 + offset;
					e.npc.y = v.y + v.height - e.npc.height;
					e.npc.direction = v.direction;
					e.npc.friendly = true;
					
					-- Swallow
					if e.timer == 0 then
						-- only change animation if there's no more enemies left to eat after this
						if (#data.eatenNPCs == 1) then
							data.frame = 3;
						end
						
						-- Update eating counters
						local increment = 1;
						if (NPC.POWERUP_MAP[e.npc.id]) then
							increment = cfg.hunger;
						end
					
						e.npc:kill(9);
						table.remove(data.eatenNPCs, k);
						
						v.ai2 = v.ai2 + increment;
						
						-- If he's not ready do some stuff
						if (v.ai2 < cfg.hunger) then
							SFX.play(55);
							babyYoshiInfo[v.id].swallowFunction(v);
							v.ai4 = 15;
						end
					end
				end
			else
				table.remove(data.eatenNPCs, k);
			end
		end
	elseif v.ai4 == 0 then
		local new = {
			[828] = true,
			[829] = true,
			[830] = true,
		}
		
		-- Spawn grown up effect
		if new[v.id] then
			SFX.play(48)
			
			local e = Effect.spawn(v.id - 50, v)
			e.npcID = babyYoshiInfo[v.id].yoshi
		else
			local grownUps2 = Effect.spawn(58, v);
			grownUps2.animationFrame = babyYoshiInfo[v.id].eggColor * 2;
			grownUps2.npcID = babyYoshiInfo[v.id].yoshi;
			grownUps2.direction = v.direction;		
		end
		-- Kill baby yoshi itself
		v:kill(9);
	end
	
	-- decrement timer
	if (v.ai4 > 0) then
		v.ai4 = v.ai4 - 1;
	end
	
	-- Reset animation
	if v.ai4 == 1 then
		if #data.eatenNPCs ~= 0 then
			v.ai4 = v.ai4 + 1;
		else
			data.frame = 0;
		end
	end
end

-- Properly update egg colors
function babyYoshis.onTickEndNPCEgg(v)
	if isBabyYoshi[v.ai1] then
		v.animationFrame = babyYoshiInfo[v.ai1].eggColor;
	end
end

function babyYoshis.onTickEndEggEffect()
	for _, v in ipairs(Effect.get(56)) do	
		if (isBabyYoshi[v.npcID]) then
			local offset = 0;
			if (babyYoshiInfo[v.npcID].eggColor > 0) then
				offset = 1;
			end
		
			if (v.animationFrame < (babyYoshiInfo[v.npcID].eggColor * 2) + offset and v.animationFrame ~= 2) then
				v.animationFrame = (babyYoshiInfo[v.npcID].eggColor * 2) + offset;
			end
		end
	end
end

return babyYoshis;