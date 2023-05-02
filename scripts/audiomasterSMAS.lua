local audio = {}
local vectr = require("vectr");

audio.SOURCE_POINT = 0;
audio.SOURCE_CIRCLE = 1;
audio.SOURCE_BOX = 2;
audio.SOURCE_LINE = 3;

audio.LISTEN_PLAYER = 0;
audio.LISTEN_CAMERA = 1;

local min = math.min;
local max = math.max;
local abs = math.abs;

local sqrt = math.sqrt;

local panRange = 400;
local minVol = 1/32;

local VolumeSet = {};
function VolumeSet.__index(tbl,key)
	return rawget(tbl, key) or 1;
end


local function falloff_sqr(sqrfl, sqrdist)
	return sqrfl/((sqrdist/minVol) - sqrdist + sqrfl);
end

local function falloff_lin(sqrfl, sqrdist)
	return 1-sqrt(sqrdist/sqrfl);
end

local function falloff_none()
	return 1;
end

audio.FALLOFF_NONE = falloff_none;
audio.FALLOFF_LINEAR = falloff_lin;
audio.FALLOFF_SQUARE = falloff_sqr;

--Set audio.volume.tag to adjust the volume for audio with a specific tag.
audio.volume = {};
audio.volume.MASTER = 1;
setmetatable(audio.volume, VolumeSet);

--Determine whether to listen for audio from the camera or the player.
audio.listener = audio.LISTEN_CAMERA;

function audio.onInitAPI()
	registerEvent(audio, "onCameraDraw", "onCameraDraw", false);
	registerEvent(audio, "onDraw", "onDraw", false);
	registerEvent(audio, "onExitLevel", "onExitLevel", false);
end

local sources = {};
local sourceList = {};

local function convertAudioSource(sound)
	if type(sound) == "number" then
		local d
		if pcall(function() d = Audio.sounds[sound] end) then
			return sound, d.sfx
		else 
			Misc.warn("Unknown sound ID: "..sound, 3);
			return
		end
	elseif type(sound) == "userdata" and sound.allocated == 1 and sound.alen ~= nil then
		return sound, sound
	else
		local s
		if pcall(function() s = Audio.SfxOpen(sound) end) then
			return sound, s
		else
			Misc.warn("Could not load sound: "..sound, 3)
			return
		end
	end
end

local AudioSource = {};
function AudioSource.__index(tbl, key)
	if(key == "isValid") then
		return true;
	else
		return AudioSource[key];
	end
end
function AudioSource.__newindex(tbl, key, val)
	if(key == "isValid") then
		error("Cannot assign to readonly property isValid.", 2);
	else
		rawset(tbl,key,val);
	end
end


local NullMT = {}
function NullMT.__index(tbl,key)
	if(key == "isValid") then
		return false;
	else
		error("Attempted to access a destroyed audio source.", 2);
	end
end

function NullMT.__newindex(tbl,key,val)
	error("Attempted to access a destroyed audio source.", 2);
end


--Audio.Create{}								[[Creates an audio source in the scene that emits sound in physical space.]]
--x,y 						[[number]]			[[REQUIRED: Position of the centre of the audio source.]]
--falloffRadius				[[number]]			[[REQUIRED: Distance the sound travels from the source before it is silent.]]
--sound						[[string]]			[[The sound file path]]
--falloffType				[[enum/function]]	[[The falloff function to use. Supports FALLOFF_NONE, FALLOFF_LINEAR and FALLOFF_SQUARE. Can also use a custom function of the form 'falloff(squaredFalloff, squaredDistance)'. Defaults to FALLOFF_SQUARE.]]
--type						[[enum]]			[[Shape of the audio source (to emit at max volume). Supports SOURCE_POINT, SOURCE_CIRCLE, SOURCE_BOX and SOURCE_LINE. Defaults to SOURCE_POINT.]]
--play						[[bool]]			[[Should the sound play immediately? Defaults to true.]]
--loops						[[integer]]			[[The number of loops for this sound to play for. 0 to loop forever. Defaults to 0.]]
--volume					[[number]]			[[The volume of this audio source, between 0 and 1. Defaults to 1.]]
--parent					[[object]]			[[Object to attach the source to. Defaults to nil.]]
--tags						[[table of string]]	[[List of tags for this sound source. Allows volume to be adjusted for every sound with a given tag.]]
--tag						[[string]]			[[Single tag for this sound source. Allows volume to be adjusted for every sound with a given tag.]]

--[[SOURCE_CIRCLE only]]
--sourceRadius				[[number]]			[[REQUIRED:	The radius of the audio source.]]

--[[SOURCE_BOX only]]
--sourceWidth/sourceHeight	[[number]]			[[REQUIRED:	The dimensions of the audio source.]]

--[[SOURCE_LINE only]]
--sourceVector				[[Vector2]]			[[REQUIRED:	The vector describing the line. Line will span from {x,y} to {x,y}+sourceVector.]]

function AudioSource.Create(args)
	local s = {};
	s.type = args.type or audio.SOURCE_POINT;
	if(args.tags ~= nil) then
		s.tags = table.iclone(args.tags);
	else
		s.tags = {};
	end
	table.insert(s.tags, args.tag);
	s.x = args.x;
	s.y = args.y;
	if(s.type == audio.SOURCE_CIRCLE) then
		s.sourceRadius = args.sourceRadius;
	elseif(s.type == audio.SOURCE_BOX) then
		s.sourceWidth = args.sourceWidth;
		s.sourceHeight = args.sourceHeight;
	elseif(s.type == audio.SOURCE_LINE) then
		if(args.sourceVector._type == "Vector2") then
			s.sourceVector = args.sourceVector;
		else
			s.sourceVector = vectr.v2(args.sourceVector.x or args.sourceVector[1], args.sourceVector.y or args.sourceVector[2]);
		end
	end
	s.falloffRadius = args.falloffRadius;
	s.falloffType = args.falloffType or audio.FALLOFF_SQUARE;
	s.__object = nil;
	if(args.sound) then
		_,s.sound = convertAudioSource(args.sound)
	end
	s.playing = args.play;
	if(s.playing == nil) then
		s.playing = true;
	end
	s.loops = args.loops or 0;
	s.audible = false;
	s.volume = args.volume or 1;
	s.parent = args.parent;
	
	sources[s] = {};
	table.insert(sourceList, s);
	
	setmetatable(s, AudioSource);
	return s;
end

function AudioSource.Play(s)
	s.playing = true;
end
AudioSource.play = AudioSource.Play;

function AudioSource.Stop(s)
	s.playing = false;
end
AudioSource.stop = AudioSource.Stop;

function AudioSource.Destroy(s)
	s:Stop();
	if(s.__object) then
		s.__object:Volume(128);
		s.__object:SetPanning(255,255);
		s.__object:Stop();
		s.__object = nil;
		
		sources[s] = nil;
		local idx = table.ifind(sourceList, s);
		if(idx ~= nil) then
			table.remove(sourceList, idx);
		end
	end
	setmetatable(s, NullMT);
end
AudioSource.destroy = AudioSource.Destroy;

do
	local tv = vectr.v2(0,0);
	local spos = vectr.v2(0,0);
	function AudioSource.Listen(s, listener, offset)
		spos.x,spos.y = 0,0;
		
		if(s.type == audio.SOURCE_POINT) then
			spos.x = s.x;
			spos.y = s.y;
		elseif(s.type == audio.SOURCE_CIRCLE) then	
			tv.x,tv.y = listener.x - s.x, listener.y - s.y;
			local dir = tv;
			if(dir.sqrlength < s.sourceRadius*s.sourceRadius) then
				return true, 1, 0;
			end
			local l = dir.length;
			dir.x, dir.y = dir.x*s.sourceRadius/l,dir.y*s.sourceRadius/l;
			spos.x = s.x + dir.x;
			spos.y = s.y + dir.y;
		elseif(s.type == audio.SOURCE_BOX) then
			spos.x = min(max(listener.x, s.x - (s.sourceWidth * 0.5)), s.x + (s.sourceWidth * 0.5));
			spos.y = min(max(listener.y, s.y - (s.sourceHeight * 0.5)), s.y + (s.sourceHeight * 0.5));
		elseif(s.type == audio.SOURCE_LINE) then
			spos.x,spos.y = listener.x-s.x, listener.y-s.y;
			tv.x,tv.y = s.sourceVector.x,s.sourceVector.y;
			local l = tv.length;
			tv.x,tv.y = tv.x/l,tv.y/l;
			local dp = spos..tv;
			spos.x,spos.y = dp*tv.x,dp*tv.y;
			
			--Above is destructive equivalent to:
			-- spos = (vectr.v2(listener.x-s.x, listener.y-s.y)%s.sourceVector);
			
			if((spos.x > 0 and s.sourceVector.x < 0) or (spos.x < 0 and s.sourceVector.x > 0) or
			   (spos.y > 0 and s.sourceVector.y < 0) or (spos.y < 0 and s.sourceVector.y > 0) or
			   (s.sourceVector.x == 0 and s.sourceVector.y == 0)) then
					spos.x = 0;
					spos.y = 0;
			elseif(spos.sqrlength > s.sourceVector.sqrlength) then
				spos.x = s.sourceVector.x;
				spos.y = s.sourceVector.y;
			end
			
			spos.x = spos.x + s.x;
			spos.y = spos.y + s.y;
		end
		
		tv.x,tv.y = spos.x - listener.x, spos.y - listener.y;
		local distance = tv;
		local r = distance.sqrlength;
		local fr = s.falloffRadius + (offset or 0);
		fr = fr * fr;
		if(r > fr) then
			return false, 0, 0;
		end
		local vol = s.falloffType(fr, r);
		local pan = max(min(distance.x,panRange),-panRange)/panRange;
		
		return true, vol, pan;
	end
end

audio.Create = AudioSource.Create;
audio.create = AudioSource.Create;

local function MapPanning(pan)
	return (1-max(pan,0))*254, (1-max(-pan,0))*254;
end

local playingSounds = {};
local playingSoundsList = {};

local function ComputeTagVolume(taglist)
	local tagVol = audio.volume.MASTER;
	for _,v in ipairs(taglist) do
		tagVol = tagVol * audio.volume[v];
	end
	return tagVol;
end


local AudioObj = {};
do
	--Reimplement subset of PlayingSFXInstance
	local function obj_pause(obj)
		return obj[4]:Pause();
	end
	local function obj_resume(obj)
		return obj[4]:Resume();
	end
	local function obj_stop(obj)
		return obj[4]:Stop();
	end
	local function obj_expire(obj, ticks)
		return obj[4]:Expire(ticks);
	end
	local function obj_fadeout(obj, ms)
		return obj[4]:FadeOut(ms);
	end
	local function obj_isplaying(obj)
		return obj[4]:IsPlaying();
	end
	local function obj_ispaused(obj)
		return obj[4]:IsPaused();
	end
	local function obj_isfading(obj)
		return obj[4]:IsFading();
	end

	function AudioObj.__index(tbl, key)
		if(key == "vol" or key == "volume") then
			return rawget(tbl,1);
		elseif(key == "tags") then
			return rawget(tbl,2);
		elseif(key == "pan" or key == "panning") then
			return rawget(tbl,3);
		elseif(key == "Pause" or key == "pause") then
			return obj_pause;
		elseif(key == "Resume" or key == "resume") then
			return obj_resume;
		elseif(key == "Stop" or key == "stop") then
			return obj_stop;
		elseif(key == "Expire" or key == "expire") then
			return obj_expire;
		elseif(key == "FadeOut" or key == "fadeOut" or key == "fadeout") then
			return obj_fadeout;
		elseif(key == "IsPlaying" or key == "isPlaying" or key == "isplaying") then
			return obj_isplaying;
		elseif(key == "IsPaused" or key == "isPaused" or key == "ispaused") then
			return obj_ispaused;
		elseif(key == "IsFading" or key == "isFading" or key == "isfading") then
			return obj_isfading;
		elseif(key == "isValid") then
			return true;
		end
	end
	function AudioObj.__newindex(tbl, key, val)
		if(key == "vol" or key == "volume") then
			rawset(tbl, 1, val);
		elseif(key == "tags") then
			rawset(tbl, 2, val);
		elseif(key == "pan" or key == "panning") then
			rawset(tbl, 3, val);
		elseif(key == "isValid") then
			error("Cannot assign to readonly property isValid.", 2);
		else
			rawget(tbl,3)[key] = val;
		end
	end
end

local soundDelays = {}
local soundDelayArray = {}

--Audio.PlaySound{}								[[Plays a one-shot sound.]]
--sound						[[string]]			[[REQUIRED: The sound file path]]
--loops						[[integer]]			[[The number of loops for this sound to play for. 0 to loop forever. Defaults to 1.]]
--volume					[[number]]			[[The volume of this audio clip, between 0 and 1. Defaults to 1.]]
--pan						[[number]]			[[The left/right panning of this audio clip, between -1 and 1. Defaults to 0.]]
--tags						[[table of string]]	[[List of tags for this sound clip. Allows volume to be adjusted for every sound with a given tag.]]
--tag						[[string]]			[[Single tag for this sound clip. Allows volume to be adjusted for every sound with a given tag.]]
--delay						[[integer]]			[[The number of ticks before the same sound can be played again. Defaults to 4.]]
function audio.PlaySound(args, vol, loops, delay)
	if(type(args) == "string" or type(args) == "number" or type(args) == "userdata") then --Simple version
		args = {sound = args, volume = vol, loops = loops, delay = delay};
	end
	vol = args.volume or 1;
	loops = (args.loops or 1) -1;
	delay = args.delay or 4;
	
	local sound, soundData = convertAudioSource(args.sound)
	
	if sound == nil then
		return setmetatable({}, NullMT)
	end
	
	if(soundDelays[sound] ~= nil) then
		return soundDelays[sound][2]
	end
	
	soundDelays[sound] = {delay, nil};
	table.insert(soundDelayArray, sound);
	
	local tags;
	if(args.tags ~= nil) then
		tags = table.iclone(args.tags);
	else
		tags = {};
	end
	table.insert(tags, args.tag);
	
	local obj = Audio.SfxPlayObjVol(soundData, loops, min(vol*128*ComputeTagVolume(tags),128));
	local pan = args.pan or 0;
	
	obj:SetPanning(MapPanning(pan));
	
	local s = {vol, tags, pan, obj};
	playingSounds[obj] = s;
	table.insert(playingSoundsList, obj);
	
	setmetatable(s, AudioObj);
	
	soundDelays[sound][2] = s
	
	return s;
end
audio.playSound = audio.PlaySound;
audio.play = audio.PlaySound;
audio.Play = audio.PlaySound;

function audio.onExitLevel()
	for _,k in ipairs(sourceList) do
		k:Destroy();
	end
	
	for _,k in ipairs(playingSoundsList) do
		k:Volume(128);
		k:SetPanning(255,255);
	end
end

do
	local listener = vectr.v2(0,0);
	--Aggregate audio sources from different listeners
	function audio.onCameraDraw(camidx)
		local cam; 
		local offset;
		if(audio.listener == audio.LISTEN_PLAYER) then
			cam = Player(camidx);
			offset = 0;
		elseif(audio.listener == audio.LISTEN_CAMERA) then
			cam = Camera(camidx);
			offset = cam.width*0.33;
		end
		listener.x,listener.y = cam.x + cam.width*0.5, cam.y + cam.height*0.5;
		for _,k in ipairs(sourceList) do
			if(k.isValid) then
				table.insert(sources[k], {k:Listen(listener, offset)});
			end
		end
	end
end

do
	local invalid = {};
	--Run through aggregated sources and amalgamate them to a single sound
	function audio.onDraw()

		--former onTick
		for i = #soundDelayArray,1,-1 do
			local s = soundDelayArray[i];
			if(soundDelays[s][1] > 0) then
				soundDelays[s][1] = soundDelays[s][1]-1;
			else
				soundDelays[s] = nil;
				table.remove(soundDelayArray, i);
			end
		end
		

		for _,k in ipairs(sourceList) do
			if(k.parent) then
				if(k.parent.isValid == nil or k.parent.isValid == true) then
					k.x = k.parent.x;
					k.y = k.parent.y;
				else
					k.playing = false;
				end
			end
		end
		
		local invalids = {};
		
		for idx = #playingSoundsList,1,-1 do
			local k = playingSoundsList[idx];
			local v = playingSounds[k];
			if(k:IsPlaying()) then
				k:Volume(min(v[1]*128*ComputeTagVolume(v[2]),128));
				k:SetPanning(MapPanning(v[3]));
			else
				k:Volume(128);
				k:SetPanning(255,255);
				table.insert(invalids, k);
				table.remove(playingSoundsList, idx);
			end
		end
		
		while (#invalids > 0) do
			
			playingSounds[invalids[#invalids]] = nil;
			table.remove(invalids, #invalids);
		end
		
		
		--former onDraw
		for idx = #sourceList,1,-1 do
			local k = sourceList[idx];
			local v = sources[k];
			if(k.isValid) then
				local vol, pan, audible, count = 0,0,false,0
				while(#v > 0) do
					if(v[1][1]) then
						audible = true;
						vol = vol + v[1][2];
						pan = pan + v[1][3];
						count = count + 1;
					end
					vol = vol/count;
					pan = pan/count;
					table.remove(v,1);
				end
				
				if(k.__object) then
					if (not k.playing or (not audible and k.loops <= 0)) then
						k.__object:Volume(128);
						k.__object:SetPanning(255,255);
						k.__object:Stop();
						k.__object = nil;
					elseif(k.playing and not k.__object:IsPlaying()) then
						k.__object = nil;
						k.playing = false;
					end
				end
				if(k.playing and (audible or k.loops > 0)) then
					local doplay = not k.__object and k.sound ~= nil
					
					if(audible) then
						k.audible = true;
						
						if(audio.listener == audio.LISTEN_CAMERA) then
							pan = pan * 0.70710678118; --Camera isn't actually in the scene, so multiply panning by 1/sqrt2
						end
						if doplay then
							k.__object = Audio.SfxPlayObjVol(k.sound, k.loops-1, min(vol*128*k.volume*ComputeTagVolume(k.tags),128));
						else
							k.__object:Volume(min(vol*128*k.volume*ComputeTagVolume(k.tags),128))
						end
						k.__object:SetPanning(MapPanning(pan));
					else
						k.audible = false;
						
						if doplay then
							k.__object = Audio.SfxPlayObjVol(k.sound, k.loops-1, 0);
						end
					end
				end
			else
				table.insert(invalid, k);
				table.remove(sourceList, idx);
				setmetatable(k, NullMT);
			end
		end
		
		while(#invalid > 0) do
			sources[invalid[#invalid]] = nil;
			table.remove(invalid, #invalid);
		end
	end
end

function audio.open(path)
	local s
	if pcall(function() s = Audio.SfxOpen(path) end) then
		return s
	else
		error("Could not load sound: "..path, 2)
	end
end

return audio;