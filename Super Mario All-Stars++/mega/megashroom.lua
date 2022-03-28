local panim = require("playeranim")
local pm = require("playermanager")
local npcManager = require("npcmanager")

local starman = require("starman/star")

local mega2 = {}

local offsets = nil;
mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
mega2.megashrinksfx = Misc.resolveSoundFile("_OST/_Sound Effects/mega_shrink.ogg")
mega2.megagrowsfx = Misc.resolveSoundFile("_OST/_Sound Effects/mega_grow.ogg")
mega2.megarunningoutsfx = Misc.resolveSoundFile("megashroom-running-out.ogg")

mega2.duration = lunatime.toTicks(13.8);
local soundObject;
local musicChunk;
local musicvolcache;

local megaTimers = {};

local growthTime = 95;

local chars = pm.getCharacters();

local function loadHitbox(p, hbtype, characterID)
	characterID = characterID or p.character;
	local iniFileName = chars[characterID].name .. "-"..hbtype..".ini"
	local costume = Player.getCostume(characterID)
	local iniFilePath
	if costume then
		iniFilePath = Misc.resolveFile("costumes\\"..chars[characterID].name.."\\"..costume.."\\"..iniFileName) or Misc.resolveFile(iniFileName) or getSMBXPath().."\\config\\character_defaults\\" .. iniFileName
	else
		iniFilePath = Misc.resolveFile(iniFileName) or getSMBXPath().."\\config\\character_defaults\\" .. iniFileName
	end
	
	if (iniFilePath == nil) then
		Misc.warn("Cannot find: " .. iniFileName)
	else
		if(offsets == nil) then
			offsets = {};
		end
		
		local ps = PlayerSettings.get(chars[characterID].base, 2);
		for x=0,9,1 do
			offsets[x] = {};
			for y=0,9,1 do
				offsets[x][y] = { x=ps:getSpriteOffsetX(x,y), y=ps:getSpriteOffsetY(x,y) };
			end
		end
		
		Misc.loadCharacterHitBoxes(chars[characterID].base, 2, iniFilePath)
		ps = PlayerSettings.get(chars[characterID].base, 2);
		if(p:mem(0x12E,FIELD_BOOL)) then --is ducking
			p.height = ps.hitboxDuckHeight;
		else
			p.height = ps.hitboxHeight;
		end
		p.width = ps.hitboxWidth;
	end
end

local scaleFactor = {};
local megaHeight = {};

local inMega = {};
local wasOnGround = {};
local lastyspeed = {};

mega2.breakableBlocks = { 4, 5, 60, 88, 89, 90, 115, 186, 188, 192, 193, 224, 225, 226, 293, 526, 668, 682, 683, 694 }
mega2.hittableBlocks = { 666, 667, 682, 683 }

local collidingBlocks = {}

local breakableBlockMap = {};

for _,v in ipairs(mega2.breakableBlocks) do
	breakableBlockMap[v] = true;
	table.insert(collidingBlocks,v);
end
local hittableBlockMap = {};

for _,v in ipairs(mega2.hittableBlocks) do
	hittableBlockMap[v] = true;
	table.insert(collidingBlocks,v);
end

local megaIDs = {}

function mega2.register(id)
    megaIDs[id] = true
    npcManager.registerEvent(id, mega2, "onTickNPC");
    npcManager.registerEvent(id, mega2, "onDrawNPC");
end

function mega2.onInitAPI()
		registerEvent(mega2, "onInputUpdate")
		registerEvent(mega2, "onTick", "onTick", false)
		registerEvent(mega2, "onDraw")
		registerEvent(mega2, "onPostNPCKill")
		registerEvent(mega2, "onDrawEnd")
		
		registerCustomEvent(mega2, "onEnterMega");
		registerCustomEvent(mega2, "onExitMega");
end


function mega2.onInputUpdate()
	for _,p in ipairs(Player.get()) do
		if(inMega[p]) then
			if not Misc.isPaused() then
				p.downKeyPressing = false;
				p.runKeyPressing = false;
				p.upKeyPressing = false;
				p.altJumpKeyPressing = false;
				p.altRunKeyPressing = false;
				p.dropItemKeyPressing = false;
			end
		end
	end
end

local growing = {};

--Note indexed by player object - currently multiplayer not supported, but futureproof yo
function mega2.isMega(pl)
	return inMega[pl] or (growing[pl] ~= 0 and growing[pl] ~= nil);
end

Player._isMega = mega2.isMega;

local powerCache = {};
local hitbox = {};

local hitboxXbuffer = 1;
local hitboxYbuffer = 1;

local used_donthurtme;


local function updateHitbox(p)
	hitbox[p].x = p.x-hitboxXbuffer;
	hitbox[p].y = p.y-hitboxYbuffer;
	hitbox[p].width = p.width+2*hitboxXbuffer;
	hitbox[p].height = p.height+hitboxYbuffer;
end

local function breakBlocks(p)
	for _,v in ipairs(Colliders.getColliding{a=hitbox[p], b=collidingBlocks, btype=Colliders.BLOCK}) do
		if(hittableBlockMap[v.id]) then
			v:hit(false, p);
		end
		if(breakableBlockMap[v.id]) then
			v:remove(true);
		end
	end		
end


function mega2.StopMega(pobj, useShrink)
	pobj = pobj or player;
	if not inMega[pobj] then
		return
	end
	mega2.onExitMega(pobj, useShrink);
	inMega[pobj] = false
	
	if(useShrink) then
		growing[pobj] = -growthTime;
		SFX.play(mega2.megashrinksfx);
		Defines.player_walkspeed = nil;
	elseif(used_donthurtme) then
		Defines.cheat_donthurtme = used_donthurtme;
		used_donthurtme = nil;
	end
	
	Audio.MusicVolume(musicvolcache);
	GameData.megashroomActive = false
	
	if soundObject ~= nil then
		soundObject:Stop()
		soundObject = nil;
	end
end

local mountNPCs = 
		{
		{35,191,193},
		56,
		{95,98,99,100,148,149,150,228}
		}

local lastCharacter = {};

local function yeetMount(p)
	if(p:mem(0x108,FIELD_WORD) > 0) then	--has a mount
		local mttype = mountNPCs[p:mem(0x108,FIELD_WORD)];
		if(p:mem(0x108,FIELD_WORD) ~= 2) then
			mttype = mttype[p:mem(0x10A,FIELD_WORD)];
		end
		local n = NPC.spawn(mttype, p.x+player.width, p.y+player.height, p.section)
		n.x = n.x-n.width*0.5;
		n.y = n.y-n.height*0.5;
		p.x = p.x+n.width*0.5;
		p:mem(0x108,FIELD_WORD,0)
		p:mem(0x144,FIELD_WORD,1) 
	end
end

function mega2.StartMega(p, id)
	p = p or player;
	if inMega[p] then
		megaTimers[p] = mega2.duration;
		SFX.play(mega2.megagrowsfx);
		return
		--mega.StopMega(p, false);
	else
		growing[p] = growthTime;
	end
	
	local initx = p.x;
	local inity = p.y;
	
	if(p.isMega and p.character ~= lastCharacter[p]) then
		local ps = PlayerSettings.get(chars[lastCharacter[p]].base, 2);
		p.x = p.x + (ps.hitboxWidth - p.width)*0.5;
		loadHitbox(p, "2", lastCharacter[p])
		mega2.StopMega(p, false);
	end
	local pset = PlayerSettings.get(chars[p.character].base, 2);
	if((pset.hitboxHeight < megaHeight[p] or megaHeight[p] < 0) and growing[p] >= growthTime-1) then
	end	
	mega2.ForceReloadMega(p);
	local pset = PlayerSettings.get(chars[p.character].base, 2);
	
	local canGrow = true;
	local col = Colliders.Box(p.x+(p.width-pset.hitboxWidth)*0.5,p.y+p.height-pset.hitboxHeight,pset.hitboxWidth,pset.hitboxHeight)
	for _,v in ipairs(Colliders.getColliding{a=col, b=Block.SOLID..Block.LAVA..Block.PLAYER, btype=Colliders.BLOCK}) do
		if(not breakableBlockMap[v.id] and v.id ~= chars[p.character].filterBlock) then
			p.powerup = powerCache[p];
			growing[p] = 0;
			canGrow = false;
			
			local costume = pm.getCostume(p.character);
			loadHitbox(p,"2");
			pm.setCostume(p.character, nil, true)
			pm.setCostume(p.character, costume, true)
			local ps2 = PlayerSettings.get(chars[lastCharacter[p]].base, powerCache[p]);
			p.width = ps2.hitboxWidth;
			if(p:mem(0x12E,FIELD_BOOL)) then --is ducking
				p.height = ps2.hitboxDuckHeight;
			else
				p.height = ps2.hitboxHeight;
			end
			if(p.isMega) then
				mega2.StopMega(p,false);
			end
			p.x = initx;
			p.y = inity;
			megaHeight[p] = -1;
			
			if(Graphics.getHUDType(p.character) == Graphics.HUD_ITEMBOX) then
				p.reservePowerup = id;
				SFX.play(mega2.megagrowsfx);
			else
				p:mem(0x16,FIELD_WORD,p:mem(0x16,FIELD_WORD)+1);
				if(p.powerup == 1) then
					p:mem(0x140, FIELD_WORD, 50);
					p:mem(0x120, FIELD_WORD, 1);
					SFX.play(mega2.megagrowsfx);
				else
					SFX.play(12);
				end
				p.powerup = math.max(p.powerup, 2)
			end
			p:mem(0x122,FIELD_WORD,0)
			p:mem(0x124,FIELD_DFLOAT,0)
			break;
		end
	end
	
	if(canGrow) then
		SFX.play(mega2.megagrowsfx);
		
		starman.stop(p);

		--Drop held npc
		if(p.holdingNPC and p.holdingNPC.isValid) then
			p.holdingNPC:mem(0x12C,FIELD_WORD,0)
		end
		
		yeetMount(p)
		
		megaTimers[p] = mega2.duration;
		
		used_donthurtme = Defines.cheat_donthurtme;
		Defines.cheat_donthurtme = true
		inMega[p] = true
		
		Defines.player_walkspeed = 6;
		mega2.onEnterMega(p);
	end
end

local growthScale = {};

local function cachePower(pobj)
	powerCache[pobj] = pobj.powerup;
	pobj.powerup = PLAYER_BIG;
end

local mountList = {};
local warpList = {}

local function mountFilter(v)
	return (not v.friendly or mountList[v] ~= nil)
end

function mega2.onPostNPCKill(npc, reason)
	--TODO: Fix this to be more robust
	if(reason == HARM_TYPE_JUMP) then
		local box = Colliders.Box(npc.x-8, npc.y-8, npc.width + 16, npc.height+16);
		for _,p in ipairs(Player.get()) do
			if(inMega[p] and Colliders.collide(p, box)) then
				p.speedY = 1;
			end
		end
	end
	
	if(megaIDs[npc.id]) then
		local t = npcManager.collected(npc, reason);
		if(t) then
			mega2.StartMega(t, npc.id);
		end
	end
end


local function UpdateMegaState()
	if(isOverworld) then return end;
	local newMounts = {}
	local newWarps = {}
			
	for _,p in ipairs(Player.get()) do
		if(hitbox[p] == nil) then
			hitbox[p] = Colliders.Box(p.x,p.y,p.width,p.height)
		end
		
		if(mega2.isMega(p)) then	
		
			yeetMount(p)
			
			--Cancel powerup changes during mega mode
			if(p:mem(0x122,FIELD_WORD) == 1 
			or p:mem(0x122,FIELD_WORD) == 2
			or p:mem(0x122,FIELD_WORD) == 4
			or p:mem(0x122,FIELD_WORD) == 5
			or p:mem(0x122,FIELD_WORD) == 11
			or p:mem(0x122,FIELD_WORD) == 12
			or p:mem(0x122,FIELD_WORD) == 41) then
				p:mem(0x122,FIELD_WORD, 0);
			end
		
			if((growing[p] ~= 0 and growing[p] ~= nil)) then
				p:mem(0x122,FIELD_WORD,499)
				if(growing[p] > 0) then --growing
					growing[p] = growing[p]-1;
					growthScale[p] = 1-(growing[p]/growthTime);
					if(growing[p] == 1) then
						updateHitbox(p);
						breakBlocks(p);
					end
				elseif(growing[p] < 0) then --shrinking
					growing[p] = growing[p]+1;
					growthScale[p] = math.abs(growing[p])/growthTime;
				end
				if(growing[p] == 0) then
					p:mem(0x122,FIELD_WORD,0)
					p:mem(0x124,FIELD_DFLOAT,0)
				end
			else
				if soundObject ~= nil then
					if (soundObject:IsPlaying()) then -- Mega will stop if music stops
					
						megaTimers[p] = megaTimers[p] - 1;
						if(megaTimers[p] <= 0) then
							megaTimers[p] = nil;
							mega2.StopMega(p,true)
						end
					
						if(Audio.MusicVolume() > 0 and growing[p] >= 0) then
							musicvolcache = Audio.MusicVolume()
							Audio.MusicVolume(0);
							GameData.megashroomActive = true
						end
						
						if(p:mem(0x13E, FIELD_WORD) > 0) then
							mega2.StopMega(p,false)
						end
						
						if(megaTimers[p] == lunatime.toTicks(3.8)) then
							SFX.play(mega2.megarunningoutsfx)
						end
						
						--NO CLIMB THING
						p:mem(0x40,FIELD_WORD,0)
						
						do	
							local sx,sy = math.abs(p.speedX)*2,math.abs(p.speedY)*2
							local hb = Colliders.Box(p.x-sx,p.y-sy,p.width + 2*sx, p.height + 2*sy);
							
							--TODO: Make this player independent
							for _,v in ipairs(Colliders.getColliding{a=hb, b=NPC.MOUNT, btype=Colliders.NPC, filter=mountFilter}) do
								newMounts[v] = true;
								if(mountList[v] == nil) then
									mountList[v] = v.friendly;
									v.friendly = true;
								end
							end
							
							--TODO: Make this player independent
							for _,v in ipairs(Warp.getIntersectingEntrance(hb.x,hb.y,hb.x+hb.width,hb.y+hb.height)) do
								local id = v.idx;
								newWarps[id] = true;
								if(warpList[id] == nil) then
									warpList[id] = v:mem(0x0C, FIELD_BOOL);
									v:mem(0x0C, FIELD_BOOL, true);
								end
							end
						end
					
						cachePower(p);
						
						if(starman.active(p)) then
							starman.stop(p);
						end
						
						if(not Defines.cheat_donthurtme) then
							used_donthurtme = not used_donthurtme;
						end
						
						updateHitbox(p);
						
						if(not wasOnGround[p] and p:isGroundTouching()) then
							Defines.earthquake = 4;
							Animation.spawn(10,p.x-16,p.y+p.height-16)
							Animation.spawn(10,p.x+p.width-16,p.y+p.height-16)
							SFX.play(37)
							if(lastyspeed[p] ~= nil and lastyspeed[p] > 5) then
								hitbox[p].height = hitbox[p].height+1;
							end
						end
						
						breakBlocks(p);
						
						for _,v in ipairs(Colliders.getColliding{a=hitbox[p], b=NPC.HITTABLE, btype=Colliders.NPC}) do
							v:harm(HARM_TYPE_HELD);
						end
						
						wasOnGround[p] = p:isGroundTouching();
						lastyspeed[p] = p.speedY;
					elseif (not soundObject:IsPlaying() and growing[p] == 0) then
						mega2.StopMega(p,true)
					end
				elseif(growing[p] == 0) then
					soundObject = SFX.play(mega2.sfxFile, 1, 0)
				end
		end
		--Delay turning off invincibility for a frame to allow resizing to happen, in case we're intersecting lava or something
		elseif(used_donthurtme ~= nil) then
			Defines.cheat_donthurtme = used_donthurtme;
			used_donthurtme = nil;
		end
	end
	
	--TODO: Make this character dependent
	for k,v in pairs(mountList) do
		if(newMounts[k] == nil) then
			if(k.isValid) then
				k.friendly = v;
			end
			mountList[k] = nil;
		end
	end
	
	for k,v in ipairs(Warp.get()) do
		local id = v.idx;
		if(warpList[id] ~= nil) then
			if(newWarps[id] == nil) then
				v:mem(0x0C, FIELD_BOOL, warpList[id]);
				warpList[id] = nil;
			end
		end
	end
end

function mega2.onTickNPC(v)
	local settings = NPC.config[v.id]
	if(v.data._basegame.__init == nil) then
		v.data._basegame.__init = true;
		v.data._basegame.__spawned = false;
		v.data._basegame.__readyToSpawn = false;
		v.data._basegame.animFrame = 0;
	elseif(v.data._basegame.__readyToSpawn) then
		v.speedX = settings.speed;
		local p = Player.getNearest(v.x + v.width * 0.5, v.y + v.height)
		if(p.x + 0.5 * p.width > v.x + 0.5 * v.width) then
			v.speedX = -v.speedX;
		end
		v.data._basegame.__spawned = true;
		v.data._basegame.__readyToSpawn = false;
	end
	if(v.data._basegame.__spawned) then
		if(v.data._basegame.__playAnim == nil or v.data._basegame.__playAnim <= 0) then
			v.animationTimer = 0;
		elseif(v.animationTimer == 0) then
			v.data._basegame.__playAnim = v.data._basegame.__playAnim-1;
		end
		if(v.collidesBlockBottom) then
			v.speedY = -5;
			v.animationFrame = 1-v.animationFrame;
			v.data._basegame.__playAnim = settings.bounceanims;
		end
	end
end

function mega2.onTick()
	UpdateMegaState();
end

local lastFrame = {};

--local reserveIDs = table.map{ CHARACTER_MARIO, CHARACTER_LUIGI, CHARACTER_ZELDA, CHARACTER_ROSALINA, CHARACTER_UNCLEBROADSWORD }

function mega2.ForceReloadMega(pobj)
			wasOnGround[pobj] = pobj:isGroundTouching();
			
			cachePower(pobj);
			local ps = PlayerSettings.get(chars[pobj.character].base, powerCache[pobj]);
			local h = ps.hitboxHeight;
			local w = ps.hitboxWidth;
			local dh = ps.hitboxDuckHeight;
			local isduck = false;
			if(pobj:mem(0x12E,FIELD_BOOL)) then --probably ducking
				isduck = true;
				pobj.y = pobj.y + (dh-h);
			end
			local ps = PlayerSettings.get(chars[pobj.character].base, 2);
			local h2 = ps.hitboxHeight;
			loadHitbox(pobj,"mega");
			ps = PlayerSettings.get(chars[pobj.character].base, 2);
			local h3 = ps.hitboxHeight;
			if(isduck) then
				h3 = ps.hitboxDuckHeight;
			end
			pobj.y = pobj.y + (h-h3);
			pobj.x = pobj.x + (w-ps.hitboxWidth)*0.5;
			scaleFactor[pobj] = ps.hitboxHeight/h2;
			megaHeight[pobj] = ps.hitboxHeight;
end

function mega2.onDrawNPC(v)
	if(v:mem(0x138,FIELD_WORD) == 1 or v:mem(0x138,FIELD_WORD) == 4) then
		v.data._basegame.__doSpawnAnim = true;
		if(v:mem(0x72, FIELD_WORD) > 0) then --Coming from a generator (checks generator type)
			v.animationFrame = 2;
		else --coming out of top of block
			v.animationFrame = -2;
			local settings = NPC.config[v.id]
			Graphics.draw{type=RTYPE_IMAGE, x = v.x+(v.width-settings.gfxwidth)*0.5 + settings.gfxoffsetx, y = v.y + settings.gfxoffsety, sourceX = 0, sourceWidth = settings.gfxwidth, sourceY = 2*settings.gfxheight, sourceHeight = v.height, image=Graphics.sprites.npc[v.id].img,isSceneCoordinates=true, priority = -55}
		end
			
	elseif(v.data._basegame.__init) then
		if(v.data._basegame.__doSpawnAnim) then
			if(v.animationTimer == 0) then
				v.data._basegame.animFrame = v.data._basegame.animFrame + 1;
			end
			if(v.data._basegame.animFrame > 3) then
				v.data._basegame.__readyToSpawn = true;
			else
				v.animationFrame = 2+v.data._basegame.animFrame;
			end
		else
			v.data._basegame.__readyToSpawn = true;
			v.data._basegame.__playAnim = 3;
		end
	elseif(v:mem(0x138,FIELD_WORD) == 2) then --itembox
		v.animationFrame = 1
		v.data._basegame.__readyToSpawn = true;
		v.data._basegame.__spawned = true;
		--v.friendly = true;
	end
end

function mega2.drawPlayer(p, sceneCoords, priority, shader, uniforms, attributes, color, target)
	if(sceneCoords == nil) then
		sceneCoords = true;
	end
	priority = priority or -25;
	shader = shader or nil;
	uniforms = uniforms or nil;
	attributes = attributes or nil;
	color = color or nil;

	local tx1,ty1 = panim.getFrame(p, true);
	lastFrame[p] = panim.getFrame(p);
	
	if(tx1 >= 0 and tx1 < 10 and ty1 >= 0 and ty1 < 10) then
	
		if(growthScale[p] == nil) then
			growthScale[p] = 1-(growing[p]/growthTime);
		end
		
		--Workaround for starman-related crash
		if(scaleFactor[p] ~= nil) then
			
			local scl = vector.lerp(1,scaleFactor[p], growthScale[p]);
			
			local xoffset = (offsets[tx1][ty1].x-1)*scaleFactor[p];
			local yoffset = (offsets[tx1][ty1].y-1)*scaleFactor[p];
			
			xoffset = vector.lerp((offsets[tx1][ty1].x-1)+((p.width-(p.width/scaleFactor[p]))*0.5), xoffset, growthScale[p])
			yoffset = vector.lerp((offsets[tx1][ty1].y-1)+((p.height-(p.height/scaleFactor[p]))), yoffset, growthScale[p])
			
			tx1 = tx1/10;
			ty1 = ty1/10;
			local tx2 = tx1 + 0.1;
			local ty2 = ty1 + 0.1;
					
			if(p:mem(0x122,FIELD_WORD) ~= 499 or (growing[p] ~= 0 and growing[p] ~= nil) and math.abs(growing[p])%8 <4) then
				Graphics.glDraw{vertexCoords={p.x + xoffset, p.y + yoffset, p.x + xoffset + 100*scl, p.y + yoffset, p.x + xoffset + 100*scl, p.y + yoffset + 100*scl, p.x + xoffset, p.y + yoffset + 100*scl },
								textureCoords={tx1,ty1,tx2,ty1,tx2,ty2,tx1,ty2}, primitive=Graphics.GL_TRIANGLE_FAN, texture=Graphics.sprites[chars[p.character].name][2].img, sceneCoords=sceneCoords, priority = priority,
								shader = shader, uniforms = uniforms, attributes = attributes, color = color, target = target}
			end
			
		end
			
	end
end

function mega2.onDraw()
	
	for _,p in ipairs(Player.get()) do
		if(megaHeight[p] == nil) then
			megaHeight[p] = -1;
			lastCharacter[p] = p.character;
		end
		if(not p.isMega) then
			if(megaHeight[p] ~= -1) then
				if(p.keepPowerOnMega) then
					p.powerup = math.max(powerCache[p],PLAYER_BIG);
				else
					p.powerup = PLAYER_BIG;
				end
				local ps = PlayerSettings.get(chars[p.character].base, p.powerup);
				local h = p.height;
				local w = ps.hitboxWidth;
				local costume = pm.getCostume(p.character);
				loadHitbox(p,"2");
				pm.setCostume(p.character, nil, true)
				pm.setCostume(p.character, costume, true)
				ps = PlayerSettings.get(chars[p.character].base, 2);
				p.y = p.y + (h-p.height);
				p.x = p.x + (w-ps.hitboxWidth)*0.5;
				megaHeight[p] = -1;
			end
		end
		lastCharacter[p] = p.character;
		
		if not (offsets == nil or not mega2.isMega(p)) then
		
			p:mem(0x142,FIELD_BOOL,true);
		
			mega2.drawPlayer(p);
		end
	end
end

function mega2.onDrawEnd()
	for _,p in ipairs(Player.get()) do
		if(inMega[p] or (growing[p] ~= 0 and growing[p] ~= nil)) then
			p:mem(0x114,FIELD_WORD,lastFrame[p]);
		end
	end
end

function mega2.onCleanup()
	
end

return mega2