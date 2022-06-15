local vectr = API.load("vectr");
local particles = API.load("particles");

local earth_img = Graphics.loadImage(Misc.resolveFile("earth.png"));
local cloud_img = Graphics.loadImage(Misc.resolveFile("clouds.png"));
local perlin_img = Graphics.loadImage(Misc.resolveFile("perlin.png"));
local starfield_img = Graphics.loadImage(Misc.resolveFile("starfield.png"));
--local palette_img = Graphics.loadImage(Misc.resolveFile("palette.png"));

local bg_shader = Shader();
bg_shader:compileFromFile(nil, Misc.resolveFile("background.frag"));

--[[
local filter_shader = Shader();
filter_shader:compileFromFile(nil, Misc.resolveFile("filter.frag"));
--]]

local backgroundTarget = Graphics.CaptureBuffer(800,600);

local planet = 	{ 	
					shader = bg_shader, 
					texture = earth_img, 
					priority = -100, 
					target = backgroundTarget,
					x = 0, y = 0, width = backgroundTarget.width, height = backgroundTarget.height,
					uniforms = 
					{ 
						perlin = perlin_img, 
						stars = starfield_img, 
						clouds = cloud_img, 
						sun = vectr.v2(0,0),
						centre = vectr.v2(0,980),
						rendersize = vectr.v2(backgroundTarget.width, backgroundTarget.height),
						radius = 1000
					}
				}

local floor_shader = Shader();
floor_shader:compileFromFile(nil, Misc.resolveFile("floor.frag"));

local waterfall = particles.Emitter(-199600, -200084, Misc.resolveFile("p_floor.ini"), 0.7);
local waterSound = SFX.create{sound="waterfall.ogg", x=-199600, y=-200084, type = SFX.SOURCE_BOX, type = SFX.SOURCE_BOX, sourceWidth = 576, sourceHeight = 32, falloffRadius = 800, volume = 0.1, tag = "sfx"}

SFX.listener = SFX.LISTEN_PLAYER;

local cam = Camera.get()[1];

function onStart()
	Misc.saveGame();
	player.x = -199600 - player.width*0.5;
	player.y = -200032;
	if(player.character == CHARACTER_MEGAMAN) then
		player.speedY = -6;
	else
		player.speedY = -4.4;
	end
end

local falltimer = 0;
local falltime = 64;
		
function onPause(obj)
	if(falltimer > 0) then
		obj.cancelled = true;
	end
end
		
function onTick()
	if(player.speedY ~= 0) then
		player.speedY = player.speedY-0.33;
	end
	
	if(player.y > -200000) then
		player.y = -200000;
		player.speedY = 0;
		for k,v in getmetatable(player.keys).__pairs(player.keys) do
			player.keys[k] = false;
		end
		
		falltimer = falltimer + 1;
		SFX.volume.sfx = 1-(falltimer/falltime);
		Audio.MusicVolume(128*SFX.volume.sfx);
		if(falltimer > falltime) then
			Level.exit();
		end
	elseif(falltimer > 0) then
		falltimer = falltimer - 1;
	end
end

function onDraw()
	Graphics.activateHud(false)
	planet.uniforms.time = lunatime.time();
	planet.target = nil;
	Graphics.drawBox(planet);
	--Graphics.drawScreen{texture = backgroundTarget, priority = -100, shader = filter_shader, uniforms = { palette = palette_img }}
	
	if(falltime > 0) then
		Graphics.drawScreen{color = {0,0,0,falltimer/falltime}, priority = 10};
	end
	
	waterfall:Draw(-10);
end

function onCameraDraw()
end
