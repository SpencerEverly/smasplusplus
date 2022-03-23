local npcManager = require("npcManager")
local playermanager = require("playerManager")
local particles = require("particles")
local colliders = require("colliders")
local darkness = require("darkness")

local starman = {}

local killed = false

starman.ids = {};
starman.duration = {};
starman.ignore = {};
starman.ignore[108] = true;

local idMap = {}

local p = p or player
--local character = player.character()
--local chars = playermanager.getCharacters()
--local currentCostume = player.getCostume()

starman.sfxFile = Misc.resolveSoundFile("starman.ogg")

local starSoundObject;
local starTimers = {};
local starActivePlayers = {};
local starSparkleObjects = {};
local starlights = {};
local sparklesize = {};
local activeStarIDs = {}

local musicvolcache;

function starman.register(id, ignoreOnNPCKill)
	table.insert(starman.ids, id)
	if not ignoreOnNPCKill then
		idMap[id] = true
	end
    starman.duration[id] =  lunatime.toTicks(NPC.config[id].duration)
end

function starman.animationCheck(p)
	return p.forcedState ~= 5 and p.forcedState ~= 8 and p.forcedState ~= 11 and p.forcedState ~= 12
end

function starman.active(idx)
	if(type(idx) == "Player") then idx = idx.idx end;
	if(idx) then return starActivePlayers[idx] == true end;
	for k,_ in pairs(starActivePlayers) do
		return true;
	end
	return false;
end

Player._hasStarman = starman.active;

local function startMusic()
	if(starman.active() and starSoundObject ~= nil) then
		return
	else
	starSoundObject = SFX.play(starman.sfxFile, 1, 0)
		if GameData.muteMusic == false then
			GameData.starActive = true
		end
		if(musicvolcache == nil) then
			musicvolcache = Audio.MusicVolume();
			Audio.MusicVolume(0)
		end
	end
end

local function stopMusic(idx)
	local onlyPlayer = true;
	for k,_ in pairs(starActivePlayers) do
		if(k ~= idx) then
			onlyPlayer = false;
			break;
		end
	end
	if(onlyPlayer and starSoundObject ~= nil) then
		starSoundObject:FadeOut(500)
		Audio.MusicVolume(musicvolcache);
		if GameData.muteMusic == true then
			Audio.MusicVolume(0)
		end
		if GameData.starActive == true then
			GameData.starActive = false
		end
		musicvolcache = nil;
	end
end

local function stopMusicImmediately(idx)
	starSoundObject:Stop()
	Audio.MusicVolume(musicvolcache);
	musicvolcache = math.max(0,Audio.MusicVolume()+math.ceil(56/(middle+12)))
end

local function resetMusic()
	if(not starman.active()) then
		Audio.MusicVolume(musicvolcache);
		musicvolcache = nil;
	end
end

function starman.stop(p)
	p = p or player;
	local idx = p.idx;
	activeStarIDs[idx]  =nil
	starActivePlayers[idx] = nil;
	if(starlights[idx] ~= nil) then
		starlights[idx]:destroy();
	end
	starlights[idx] = nil;
	--starSoundObject = nil;
	stopMusic(idx);
	p:mem(0x140, FIELD_WORD, 0);
	resetMusic();
end

starman.stopTheStar = starman.stop;

function starman.start(p, id)
	id = id or starman.ids[1]
	p = p or player;
	if(p.isMega) then
		return;
	end
	startMusic();
	SFX.play(6);
	local idx = p.idx;
	activeStarIDs[idx] = id
	starTimers[idx] = starman.duration[id];		
	
	if(starlights[idx] == nil) then
		starlights[idx] = darkness.addLight(darkness.light(0,0,300,2,Color.white));
	else
		starlights[idx].enabled = true;
	end
	if(starSparkleObjects[idx] == nil) then
		starSparkleObjects[idx] = particles.Emitter(0,0,Misc.multiResolveFile("p_starman_sparkle.ini", "particles\\p_starman_sparkle.ini"));
	else
		starSparkleObjects[idx].enabled = true;
	end
	starActivePlayers[idx] = true;
	starSparkleObjects[idx]:Attach(p);
	starlights[idx]:attach(p, true);
end

starman.startTheStar = starman.start;

local function starmanFilter(v)
	return colliders.FILTER_COL_NPC_DEF(v) and not starman.ignore[v.id];
end

local function checkStarStatus(p)
	local idx = p.idx;
	if(starActivePlayers[idx]) then
		p:mem(0x140, FIELD_WORD, -2);
		p:mem(0x142, FIELD_WORD, 0);
		
		for _,v in ipairs(colliders.getColliding{a = p, b = NPC.HITTABLE, btype = colliders.NPC, filter = starmanFilter}) do
			v:harm(HARM_TYPE_EXT_HAMMER);
		end
		
		starTimers[idx] = starTimers[idx] - 1;
		if(starTimers[idx] == math.min(starman.duration[activeStarIDs[idx]]-1, math.floor(lunatime.toTicks(2.6)))) then
			SFX.play("starman-running-out.ogg")
		end
		if(starTimers[idx] == math.min(starman.duration[activeStarIDs[idx]]-1, math.floor(lunatime.toTicks(1)))) then
			stopMusic(idx);
			if(starSparkleObjects[idx] ~= nil) then
				starSparkleObjects[idx].enabled = false;
			end
		elseif(starTimers[idx] <= 0) then
			starTimers[idx] = nil;
			starman.stop(p);
		end
	end
end

local currentFrames = {};
local shader = Misc.multiResolveFile("starman.frag", "shaders\\npc\\starman.frag")

function starman.onInitAPI()
	registerEvent(starman, "onStart")
	registerEvent(starman, "onTick")
	registerEvent(starman, "onDraw", "onDraw", false)
	registerEvent(starman, "onExitLevel")
    registerEvent(starman, "onNPCKill")
	registerEvent(starman, "onPostNPCKill")
    
    for k,v in ipairs(starman.ids) do
        idMap[v] = true
    end
	
	--starman.reloadMusic();
end

--function starman.reloadMusic()
	--local starmanMusicChunk = SFX.open(starman.sfxFile)
--end

local function drawStar(p)
	if(type(shader) == "string") then
		local s = Shader();
		s:compileFromFile(nil, shader);
		shader = s;
	end
	
	local idx = p.idx;

	if(starSoundObject ~= nil) then
		--if(Misc.isPaused()) then
			--starSoundObject:Pause()
		--else
			--starSoundObject:Resume()
		--end
	end
	
	if(starSparkleObjects[idx] ~= nil and p:mem(0x13E, FIELD_WORD) == 0) then
		if(sparklesize[idx] == nil or p.width ~= sparklesize[idx].w or p.height ~= sparklesize[idx].h) then
			sparklesize[idx] = {w=p.width,h=p.height};
			local wid = "-"..(sparklesize[idx].w*0.5)..":"..(sparklesize[idx].w*0.5);
			local hei = "-"..(sparklesize[idx].h*0.5)..":"..(sparklesize[idx].h*0.5)
			starSparkleObjects[idx]:setParam("xOffset",wid);
			starSparkleObjects[idx]:setParam("yOffset",hei);
		end
		
		
		if(starActivePlayers[idx] and starman.animationCheck(p)) then
			p:render{
						shader = shader, 
						uniforms =
								{
									time = lunatime.tick()*2;
								},
						drawmounts = (player:mem(0x108, FIELD_WORD) ~= 3)
					};
					
			local priority = -25;
			if(p.forcedState == 3) then
				priority = -70;
			end
			starSparkleObjects[idx]:Draw(priority);
		
		end
	end
end

function starman.onDraw()
	for _,v in ipairs(Player.get()) do
		local idx = v.idx;
		if(starActivePlayers[idx]) then
			drawStar(v);
		elseif(starSparkleObjects[idx] and not starSparkleObjects[idx].enabled and starSparkleObjects[idx]:Count() == 0) then
			starSparkleObjects[idx] = nil;
			sparklesize[idx] = nil;
		end
	end
end

function starman.onNPCKill(event,npc,reason)	
	local id = npc.id;
	if(idMap[npc.id]) then
		local t = npcManager.collected(npc, reason);
		if(t) then
			starman.start(t, npc.id)
		end
	end
end

function starman.onPostNPCKill(npc, harmType)
	local stars = table.map{97,196}
	if stars[npc.id] then
		starman.stop(p)
	end
end

function starman.onTick()
	if(not isOverworld) then
		for _,v in ipairs(Player.get()) do
			checkStarStatus(v)
		end
	end
	if starman.active() then
		if(not killed and player:mem(0x13E,FIELD_BOOL)) then
			killed = true
			starman.stop(p)
		end
	end
end

function starman.onExitLevel()
	for _,v in ipairs(Player.get()) do
			starman.stop(v);
	end
end


return starman;