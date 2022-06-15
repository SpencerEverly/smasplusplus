local marioChallenge = require("smasmariochallenge")
local colliders = API.load("colliders")
local paralx = API.load("paralx2")
local pnpc = API.load("pnpc")
local imagic = API.load("imagic")
local textplus = API.load("textplus")
local particles = API.load("particles")
local pm = API.load("playermanager")
local rng = API.load("rng")

if smasbooleans.marioChallengeActivated == true then
	smasmariochallenge.Activate()
end

local basefont = {xscale=2, yscale=2, align="center", font = textplus.loadFont("textplus/font/3.ini")}


local modes = {
				"mariochallenge-onehitmode", 
				"mariochallenge-randomcharacters", 
				"mariochallenge-timer", 
				"mariochallenge-mirror",
				"mariochallenge-oneshot",
				"mariochallenge-slippery", 
				"mariochallenge-rinkas",
			  };

local c_levels;
local c_lives;
local c_reroll;

local active_settings = nil;
local settingsTimer = 0;

local oldkeys = {up = false, down = false}
local holdkeys = { up = 0, down = 0 }

local arrowCounter = 0;

local firstFrame = true;
local switchMuteTimer = 0;

local modemap = {
				  ["mariochallenge-onehitmode"] = {get = marioChallenge.getModeOHKO, set = marioChallenge.setModeOHKO, img = Graphics.sprites.mariochallenge["mode-ohko"]},
				  ["mariochallenge-randomcharacters"] = {get = marioChallenge.getModeShuffle, set = marioChallenge.setModeShuffle, img = Graphics.sprites.mariochallenge["rerolls"]},
				  ["mariochallenge-timer"] = {get = marioChallenge.getModeTimer, set = marioChallenge.setModeTimer, img = Graphics.sprites.mariochallenge["timer"]},
				  ["mariochallenge-mirror"] = {get = marioChallenge.getModeMirror, set = marioChallenge.setModeMirror, img = Graphics.sprites.mariochallenge["mode-mirror"]},
				  ["mariochallenge-oneshot"] = {get = marioChallenge.getModeOneshot, set = marioChallenge.setModeOneshot, img = Graphics.sprites.mariochallenge["mode-oneshot"]},
				  ["mariochallenge-slippery"] = {get = marioChallenge.getModeSlippery, set = marioChallenge.setModeSlippery, img = Graphics.sprites.mariochallenge["mode-slippery"]},
				  ["mariochallenge-rinkas"] = {get = marioChallenge.getModeRinka, set = marioChallenge.setModeRinka, img = Graphics.sprites.mariochallenge["mode-rinka"]}
				};
				

local signNPCs = {[94] = true, [151] = true, [101] = true}
local exitwarp;
local cannonimg = Graphics.loadImage(Misc.resolveFile("cannon.png"))
local cannonframespeed = 4;
local part_cannon = particles.Emitter(0,0,Misc.resolveFile("p_cannon.ini"));

local part_clouds = {}
for i=1,2 do
	part_clouds[i] = particles.Emitter(0,0,Misc.resolveFile("p_cloud.ini"), -4);
end
part_clouds[2].texture = Graphics.loadImage(Misc.resolveFile("prlx_bgclouds2.png"));

for _,v in ipairs(part_clouds) do
	v:AttachToCamera(Camera.get()[1]);
end

local shootingStars = {};
local starYbound = -201184;

local function MuteSwitches()
	Audio.sounds[32].muted = true;
	switchMuteTimer = 10;
end

local function spawnStar(x,y)
	local s = {t = 48, x = Camera.get()[1].x, y = Camera.get()[1].y, speedX = rng.random(4,8), speedY = rng.random(0,4), effect = particles.Ribbon(x,y,Misc.resolveFile("r_stars.ini"))};
	table.insert(shootingStars, s)
end


local function getTalkNPC()
	local best = nil;
	local distance = math.huge;
	for _,v in ipairs(NPC.getIntersecting(player.x,player.y,player.x+player.width,player.y+player.height)) do
		if(v:mem(0x44,FIELD_BOOL)) then
			local dx = (v.x+v.width*0.5) - (player.x+player.width*0.5);
			local dy = (v.y+v.height*0.5) - (player.y+player.height*0.5);
			if(dx*dx + dy*dy < distance) then
				best = v;
			end
		end
	end
	
	if  best ~= nil  then
		best = pnpc.wrap(best)
	end
	return best;
end

local bgObj;
local signObjs;
				
function onStart()
	Misc.saveGame();
	
	bgObj = paralx.get(0);
	exitwarp = Warp(0);
	part_cannon.x = exitwarp.entranceX+16;
	part_cannon.y = exitwarp.entranceY+16;
	
	for _,v in ipairs(Block.get(283)) do
		local s = v:mem(0x0C, FIELD_STRING);
		if(modemap[s] ~= nil and modemap[s].get()) then
			v.id = 282; --Change to active block
		end
	end
	
	for _,v in ipairs(NPC.get(178)) do
		v = pnpc.getExistingWrapper(v);
		if(v) then
			local d = v.data.type;
			if(d) then
				local c = colliders.Box(v.x+v.width*0.5-16, v.y+v.height-32, 32, 32);
				v:kill();
				if(d == "levels") then
					c_levels = c;
				elseif(d == "lives") then
					c_lives = c;
				elseif(d == "rerolls") then
					c_reroll = c;
				end
			end
		end
	end
	
	signObjs = {};
	for _,v in ipairs(NPC.get(94)) do
		table.insert(signObjs, pnpc.wrap(v));
	end
	
	playMusic(0);
end

function onInputUpdate()

	if (mem(0x00B250E2, FIELD_BOOL) or Misc.isPausedByLua()) then
		oldkeys.up = player.upKeyPressing;
		oldkeys.down = player.downKeyPressing;
		
		return;
	end

	if(active_settings ~= nil) then
		
		if(player.upKeyPressing) then
			holdkeys.up = holdkeys.up + 1;
		else
			holdkeys.up = 0;
		end
		
		if(player.downKeyPressing) then
			holdkeys.down = holdkeys.down + 1;
		else
			holdkeys.down = 0;
		end
	
		player.leftKeyPressing = false;
		player.rightKeyPressing = false;
		player.speedX = (active_settings.x - player.width*0.5 - player.x)/5;
		player.speedY = 0;
		settingsTimer = 64;
		
		if(holdkeys.up > 48) then
			oldkeys.up = false;
		end
		if(holdkeys.down > 48) then
			oldkeys.down = false;
		end
		
		if(not oldkeys.up and player.upKeyPressing) then
			local newval = active_settings.getfunc()+1;
			if(holdkeys.up > 192) then
				newval = newval + 4;
			end
			if(newval >= active_settings.maxval+1 or newval == 0) then
				if(newval == active_settings.maxval+1) then
					newval = -1; --Unlimited
				else
					newval = active_settings.minval;
				end
			end
			SFX.play(74);
			active_settings.setfunc(newval);
		end
		if(not oldkeys.down and player.downKeyPressing) then
			local newval = active_settings.getfunc()-1;
			if(holdkeys.down > 192) then
				newval = newval - 4;
			end
			if(newval < -1) then
				newval = active_settings.maxval;
			elseif(newval < active_settings.minval) then
				newval = -1;
			end
			SFX.play(74);
			active_settings.setfunc(newval);
		end
		oldkeys.up = player.upKeyPressing;
		oldkeys.down = player.downKeyPressing;
		
		player.upKeyPressing = false;
		player.downKeyPressing = false;
		arrowCounter = arrowCounter + 1;
	else
		oldkeys.up = player.upKeyPressing;
		oldkeys.down = player.downKeyPressing;
		arrowCounter = 0;
	end
end

local function showCannonBlock(val)
	for _,v in ipairs(Block.getIntersecting(exitwarp.entranceX,exitwarp.entranceY+32,exitwarp.entranceX+32,exitwarp.entranceY+66)) do
		if(v.id == 21 or v.id == 22) then
			v.isHidden = not val;
		end
	end
end

local drawCannon = false;

local deathobj;
local sparkleobj;
local sparkleimg = Graphics.loadImage(Misc.resolveFile("sparkle.png"));
local loadTimer = 0;
local loading = false;

local pipetimer = 0;
local hidePlayer = false;
local fadein = 64;

function onTick()
	if(fadein > 0) then
		fadein = fadein-1;
	end

	if(switchMuteTimer > 0) then
		switchMuteTimer = switchMuteTimer-1;
		if(switchMuteTimer == 0) then
			Audio.sounds[32].muted = false;
		end
	end

	if player.y > Section(player.section).boundary.bottom then
		player.speedY = -25;
		player.y = player.y - 4;
		SFX.play(24);
	end
	
	if(settingsTimer > 0) then
		settingsTimer = settingsTimer - 1;
	end
	
	if(settingsTimer == 0) then
		if(player:isGroundTouching() and player.speedY == 0) then
			local py = player.y+player.height;
			if(py <= c_reroll.y+c_reroll.height+2 and colliders.collide(player, c_reroll)) then
				active_settings = {x = c_reroll.x+c_reroll.width*0.5, y = c_reroll.y, setfunc = marioChallenge.setConfigRerolls, getfunc = marioChallenge.getConfigRerolls, minval = 0, maxval=999, img = Graphics.sprites.mariochallenge["rerolls"].img}
			elseif(py <= c_lives.y+c_lives.height+2 and colliders.collide(player, c_lives)) then
				active_settings = {x = c_lives.x+c_lives.width*0.5, y = c_lives.y, setfunc = marioChallenge.setConfigLives, getfunc = marioChallenge.getConfigLives, minval = 0, maxval=99, img = Graphics.sprites.mariochallenge["lives"].img}
			elseif(py <= c_levels.y+c_levels.height+2 and colliders.collide(player, c_levels)) then
				active_settings = {x = c_levels.x+c_levels.width*0.5, y = c_levels.y, setfunc = marioChallenge.setConfigLevels, getfunc = marioChallenge.getConfigLevels, minval = 1, maxval=999, img = Graphics.sprites.mariochallenge["stages"].img}
			else
				active_settings = nil;
			end
		else
			active_settings = nil;
		end
	elseif(not player:isGroundTouching()) then
		active_settings = nil;
	end
	
	for k,v in ipairs(bgObj:get()) do
		if(v.name:match("^clouds%d+$")) then
			v.speedY = 0.8*math.sin(lunatime.tick()*0.02*k);
		elseif(v.name == "Stars") then
			v.opacity=1-((player.y+201392)/600)
		elseif(v.name == "Gradient2") then
			v.opacity=1-((player.y+201392-200)/400)
		end
	end
	
	
	if(player:mem(0x15E, FIELD_WORD) == 1 and player.forcedState == 3 and player:mem(0x124, FIELD_DFLOAT) > 0) then

		if(marioChallenge.LevelCount() == 0) then
			if(pipetimer == 0) then
				Text.showMessageBox("Uh oh! You don't have any valid levels installed! Download some episodes and try again!")
				SFX.play(17);
			end
			player:mem(0x124, FIELD_DFLOAT, 2);
			pipetimer = pipetimer + 1;
			if(pipetimer > player.height+8) then
				player.forcedState = 0
				player:mem(0x15E, FIELD_WORD, 0)
				player:mem(0x124, FIELD_DFLOAT,0)
				pipetimer = 0;
			end
		else
			drawCannon = true;
		end
		player:mem(0x124, FIELD_DFLOAT,-1)
	elseif(drawCannon) then
		pipetimer = pipetimer + 1;
		if(pipetimer == cannonframespeed*4) then
			part_cannon:Emit(200);
			SFX.play(22);
			hidePlayer = true;
		elseif(pipetimer >= cannonframespeed*6) then
			drawCannon = false;
			local img = Graphics.sprites.effect[pm.getCharacters()[player.character].deathEffect].img;
			
			local frames = 1;
			if(player.character == CHARACTER_LINK or player.character == CHARACTER_SNAKE or player.character == CHARACTER_SAMUS) then --frames in the death anim
				frames = 2;
			end
			
			deathobj = imagic.Create{x=exitwarp.entranceX+16, y=exitwarp.entranceY-300, width=img.width, height=img.height/frames, texture=img, filltype=imagic.TEX_PLACE, texalign=imagic.ALIGN_TOP, scene=true, primitive=imagic.TYPE_BOX, align=imagic.ALIGN_CENTRE}
			deathobj:Scale(1.1)
			Audio.MusicStopFadeOut(3000);
			Audio.SeizeStream(0);
		end
	else
		pipetimer = 0;
	end
	
	if(deathobj) then
		deathobj.y = deathobj.y + 1.1
		deathobj:Scale(0.99)
		if(math.abs(deathobj.y - (exitwarp.entranceY-120)) < 1) then
			sparkleobj = imagic.Create{x=deathobj.x, y=deathobj.y, width=16, height=16, texture=sparkleimg, scene=true, primitive=imagic.TYPE_BOX, align=imagic.ALIGN_CENTRE}
			SFX.play(14);
			loadTimer = lunatime.toTicks(0.5);
			deathobj = nil;
		end
	end
	
	if(sparkleobj) then
		sparkleobj:Rotate(1);
		sparkleobj:Scale(0.96);
		if(loadTimer <= 1) then
			loadTimer = lunatime.toTicks(1);
			sparkleobj = nil;
		end
	end
	
	if(loadTimer > 0) then
		loadTimer = loadTimer-1;
		if(loadTimer == 0) then
			Misc.saveGame();
			Level.load(smastables.__allMandatoryLevels[rng.randomInt(1,#smastables.__allMandatoryLevels)]);
			loading = true;
		end
	end
	
	if(player.y < -200736 and player.speedY ~= 0) then
		player.speedY = player.speedY-math.lerp(0,0.275,math.min((-200736 - player.y)/200, 1));
	end
	if(player.y < -201184 and rng.randomInt(0,60) == 0) then
		spawnStar(rng.random(player.x-600, player.x+300), rng.random(Camera.get()[1].y-64,starYbound));
	end
	
	if(player:mem(0x13E, FIELD_WORD) > 160) then
		marioChallenge.reloadIntro();
	end
end

local function drawUI(x, y, image, text, scene)
	if(scene == nil) then
		scene = false;
	end
	if(text ~= nil and text ~= "nil") then
		if(scene) then
			Graphics.drawImageToSceneWP(image, x-16, y, 10);
			Graphics.drawImageToSceneWP(Graphics.sprites.hardcoded["33-1"].img, x+8, y+1, 10);
		else
			Graphics.drawImageWP(image, x-16, y, 10);
			Graphics.drawImageWP(Graphics.sprites.hardcoded["33-1"].img, x+8, y+1, 10);
		end
		if(text == -1) then
			if(scene) then
				Graphics.drawImageToSceneWP(Graphics.sprites.hardcoded["50-11"].img, x+64, y, 10);
			else
				Graphics.drawImageWP(Graphics.sprites.hardcoded["50-11"].img, x+64, y, 10);
			end
		else
			
			text = tostring(text);
			Graphics.draw{type = RTYPE_TEXT, x=x+82-(18*#text), y=y+1, text=text, fontType = 1, sceneCoords = scene, priority = -1};
		end
	end
end

function onEvent(event)
	if(modemap[event] ~= nil) then
		modemap[event].set(not modemap[event].get());
	elseif(event == "mariochallenge-reset") then
		MuteSwitches();
		
		--Disable mode switches
		for _,v in ipairs(Block.get(282)) do
			local s = v:mem(0x0C, FIELD_STRING);
			if(modemap[s] ~= nil and modemap[s].get()) then
				v:hit();
			end
		end
		
		marioChallenge.resetConfigLevels();
		marioChallenge.resetConfigLives();
		marioChallenge.resetConfigRerolls();
		SFX.play(61);
		Defines.earthquake = 4;
	end
end

function onMessageBox(eventObj, message)
--[[
	local npc = nil;
	if(player.upKeyPressing) then
		npc = getTalkNPC();
	end
	]]
	
	eventObj.cancelled = true
end

local textbox = nil;
local textboximg = Graphics.loadImage(Misc.resolveFile("textbox.png"))
local lastShouldDrawCannon = false;

function onDraw()
	Graphics.activateHud(false)
	
	local camera = Camera.get()[1];
	local cx = camera.x;
	local cy = camera.y;
	
	--Draw hardcoded HUD elements properly
	if(firstFrame) then
		firstFrame = false;
		return;
	end
	
	for _,v in ipairs(signObjs) do
		v.speedY = 0;
	end
	
	if(cx + camera.width >= -197856) then --Performance saver - don't do the Block.get call if you don't need to
		for _,v in ipairs(Block.get({283,282})) do
			if(modemap[v:mem(0x0C, FIELD_STRING)]) then
				Graphics.drawImageToSceneWP(modemap[v:mem(0x0C, FIELD_STRING)].img.img, v.x+8, v.y+v:mem(0x56,FIELD_WORD)-20, -80);
			end
		end
	end
	
	if(active_settings ~= nil) then
		local yoff = 8*math.sin(arrowCounter*0.1);
		local yhei = -64;
		Graphics.drawImageToSceneWP(Graphics.sprites.hardcoded["50-12"].img, 	active_settings.x-8, active_settings.y+yoff+yhei-24, 10);
		Graphics.drawImageToSceneWP(Graphics.sprites.hardcoded["50-13"].img, 	active_settings.x-8, active_settings.y-yoff+yhei+24, 10);
		drawUI(active_settings.x-41, active_settings.y+yhei, active_settings.img, active_settings.getfunc(), true)
	end
	
	local x = 800-96;
	local y = 600-72;
	drawUI(x,y,		Graphics.sprites.mariochallenge["rerolls"].img,	marioChallenge.getConfigRerolls())
	drawUI(x,y+24,	Graphics.sprites.mariochallenge["lives"].img,	marioChallenge.getConfigLives())
	drawUI(x,y+48,	Graphics.sprites.mariochallenge["stages"].img,	marioChallenge.getConfigLevels())
	
	x = 800-32;
	do
		local xoff = 0;
		for i = #modes,1,-1 do
			local mode = modes[i];
			if(modemap[mode].get()) then
				Graphics.drawImageWP(modemap[mode].img.img, x-xoff*20, 600-96, 10);
				xoff = xoff + 1;
			end
		end
	end
	
	local firstcannonframe = cannonframespeed*3;
	local shouldrawcannon = drawCannon and pipetimer > firstcannonframe and pipetimer < firstcannonframe+cannonframespeed*2;
	local shotframes = 8;
	
	if(shouldrawcannon ~= lastShouldDrawCannon) then
		showCannonBlock(not shouldrawcannon);
	end
	lastShouldDrawCannon = shouldrawcannon;
	if(shouldrawcannon) then
		Graphics.drawImageToSceneWP(cannonimg, exitwarp.entranceX-16,exitwarp.entranceY+32-8, 0, math.floor((pipetimer-firstcannonframe)/cannonframespeed)*72, 64, 72, -65);
	end
	
	if(pipetimer >= firstcannonframe + cannonframespeed and pipetimer < firstcannonframe + cannonframespeed + shotframes) then
		local x = exitwarp.entranceX+16;
		local y = exitwarp.entranceY+32;
		local t = (pipetimer - (firstcannonframe + cannonframespeed))/shotframes;
		local w = math.lerp(24,0,t)
		Graphics.glDraw{
						vertexCoords={x-w,y-600,x+w,y-600,x+w,y,x-w,y},
						primitive=Graphics.GL_TRIANGLE_FAN,
						sceneCoords=true,
						priority = -67,
						color=Color(1,1,1,math.lerp(0.75,0,t))
						}
	end
	
	if(part_cannon:Count() > 0) then
		part_cannon:Draw(-66);
	end
	
	if(deathobj) then
		deathobj:Draw(-99);
	end
	if(sparkleobj) then
		sparkleobj:Draw(-99);
	elseif(loadTimer > 0 or loading) then
		Graphics.drawScreen{color=math.lerp(Color.black, Color.transparent, loadTimer/64), priority = 10}
	end
	
	if(hidePlayer) then
		player:mem(0x114,FIELD_WORD,player.FacingDirection*-50); --Out of Bounds animation frame
	end
	
	for i = #shootingStars,1,-1 do
		
		local nx = math.lerp(cx,shootingStars[i].x,0.8);
		local ny = math.lerp(cy,shootingStars[i].y,0.9);
		
		local k = 1;
		while(k <= #shootingStars[i].effect.segments) do
			local v = shootingStars[i].effect.segments[k];
			v.x = v.x-nx+cx;
			v.y = v.y-ny+cy;
			k = k+1;
		end
		shootingStars[i].effect.x = shootingStars[i].effect.x-nx + cx;
		shootingStars[i].effect.y = shootingStars[i].effect.y-ny + cy;
		shootingStars[i].effect:Draw(-99);
		
		k = 1;
		while(k <= #shootingStars[i].effect.segments) do
			local v = shootingStars[i].effect.segments[k];
			v.x = v.x-cx+nx;
			v.y = v.y-cy+ny;
			k = k+1;
		end
		shootingStars[i].effect.x = shootingStars[i].effect.x-cx+nx + shootingStars[i].speedX;
		shootingStars[i].effect.y = shootingStars[i].effect.y-cy+ny + shootingStars[i].speedY;
		
		shootingStars[i].speedY = shootingStars[i].speedY+0.1
		shootingStars[i].t = shootingStars[i].t-1;
		if(shootingStars[i].t <= 0 or shootingStars[i].effect.y-shootingStars[i].y > 420 or player.y > starYbound) then
			shootingStars[i].effect.enabled = false;
			if(shootingStars[i].effect:Count() == 0) then
				table.remove(shootingStars,i);
			end
		end
	end
	
	local talkNPC = getTalkNPC();
	
	if(talkNPC or textbox) then
		if(textbox ~= nil or signNPCs[talkNPC.id]) then
			local priority = -1;
			local msg;
			local alpha = 255;
			local x,y;
			if(textbox) then
				msg = textbox.msg;
				x = textbox.x;
				y = textbox.y;
				
				if(textbox.closing and textbox.npc == talkNPC) then
					textbox.closing = false;
				end
				
			else
				msg = tostring(talkNPC.msg);
				x=(talkNPC.data.x or 400);
				y=(talkNPC.data.y or 300);
				alpha = 0;
			end
			local w,h = 0,0;
			local scale = 2;
			local layout
			if(textbox == nil or textbox.t >= 1) then
				layout = textplus.layout(textplus.parse(msg, basefont), (400-32))
				w,h = layout.width,layout.height
				
				--w=w*scale;
				--h=h*scale;
				
				w = math.max(w,64) + 32;
				h = math.max(h,48) + 64;
				
				--round to nearest 2 pixels to avoid aliasing errors
				w = math.ceil(w/2)*2;
				h = math.ceil(h/2)*2;
			end
			if(textbox == nil) then
				textbox = {npc = talkNPC, x=x, y=y, w=w, h=h, msg=msg, t=0, closing=false, box = imagic.Create{x=x,y=y,width=64,height=48,primitive=imagic.TYPE_BOX, align=imagic.ALIGN_CENTRE,bordertex=textboximg,borderwidth=32}}
			elseif(textbox.t < 1 or textbox.closing) then
				if(textbox.closing) then
					textbox.t = math.max(textbox.t-0.2,0);
				else
					textbox.t = math.min(textbox.t+0.2,1);
				end
				textbox.box = imagic.Create{x=textbox.x,y=textbox.y,width=math.lerp(64,textbox.w,textbox.t),height=math.lerp(48,textbox.h,textbox.t),primitive=imagic.TYPE_BOX, align=imagic.ALIGN_CENTRE,bordertex=textboximg,borderwidth=32}
			end
			textbox.box:Draw(priority,0xE2A498FF);
			if layout ~= nil and alpha > 0 then
				textplus.render{layout = layout, x = x-layout.width*0.5, y=y-layout.height*0.5 + 8, priority = priority, color = Color.fromHex(0x58527A00+alpha)}
			end
		end
	end
	
	if(textbox ~= nil and talkNPC ~= textbox.npc) then
		textbox.closing = true;
		if(textbox.t <= 0) then
			textbox = nil;
		end
	end
	
	if(player.section == 0) then
		for _,v in ipairs(part_clouds) do
			v:Draw(-5);
		end
	end
end

local cameraOffset = 0;
local doSpaceTransition = false;
function onCameraUpdate(idx)
	if(player.section == 0) then
		if(not Misc.isPausedByLua()) then
			if(player.y+player.height <= -201296) then
				if(player:isGroundTouching()) then
					doSpaceTransition = true;
				end
				if(doSpaceTransition) then
					cameraOffset = math.max(-150, cameraOffset - 1.5);
				end
			else
				doSpaceTransition = false;
				cameraOffset = math.min(0, cameraOffset + 3);
			end
		end
		local c = Camera.get()[1];
		
		local bounds = Section(0).boundary;
		
		c.y = math.clamp(player.y +player.height - c.height*0.5 + cameraOffset, bounds.top, bounds.bottom-c.height);
	end
end

function onCameraDraw()
	if(fadein > 0) then
		Graphics.drawScreen{color=Color(0,0,0,fadein/64), priority = 10};
	end
end