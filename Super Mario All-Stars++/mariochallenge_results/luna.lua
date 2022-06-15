local particles = API.load("particles");

local part_clouds = {}
for i=1,7 do
	part_clouds[i] = particles.Emitter(0,0,Misc.resolveFile("p_cloud.ini"), 0);
	if(i < 4) then
		part_clouds[i].texture = Graphics.loadImage(Misc.resolveFile("cloud"..i..".png"));
	else
		part_clouds[i].texture = Graphics.loadImage(Misc.resolveFile("cloudstrip"..(i-3)..".png"));
	end
	part_clouds[i]:setParam("width",part_clouds[i].texture.width);
	part_clouds[i]:setParam("height",part_clouds[i].texture.height);
end

for _,v in ipairs(part_clouds) do
	v:AttachToCamera(Camera.get()[1]);
	v:setPrewarm(12);
end

local ending = false;
local fading = false;
local anchor;
local anchorpos = 0;

local sfx_anchor_up = Misc.resolveFile("anchorup.ogg");
local sfx_anchor_down = Misc.resolveFile("anchorreturn.ogg");

local anchorSound;

function onStart()
	Misc.saveGame();
	SFX.play(Misc.resolveFile("game over.ogg"))
	anchor = Layer.get("anchor");
end

function onTick()
	if(player.y+player.height < -200192 and player:isGroundTouching()) then
		for k,v in getmetatable(player.keys).__pairs(player.keys) do
			player.keys[k] = false;
		end
		if(not ending) then
			anchorSound = SFX.play(sfx_anchor_up);
			anchor.speedY = -2;
			ending = true;
		end
	else
		ending = false;
		fading = false;
		if(anchorpos < 0) then
			anchor.speedY = 1;
		else
			if(anchor.speedY > 0) then
				anchorSound:Stop();
				SFX.play(sfx_anchor_down);
			end
			anchor.speedY = 0;
		end
	end
	
	anchorpos = anchorpos + anchor.speedY;
	
	if(not fading and anchorpos < -200 and anchorSound ~= nil) then
		anchorSound:FadeOut(800);
		fading = true;
	end
	if(anchorpos < -300) then
		Level.exit();
	end
end

function onPause(obj)
	if(ending) then
		obj.cancelled = true;
	end
end

function onDraw()
	Graphics.activateHud(false)
	
	for _,v in ipairs(part_clouds) do
		v:Draw(-95, true);
	end
	
	if(anchorpos < -200) then
		Graphics.drawScreen{color = {0,0,0,-(anchorpos+200)/50}, priority = 10};
	end
end