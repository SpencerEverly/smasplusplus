local textplus = require("textplus")
local imagic = require("imagic")
local rng = require("rng")
local playerManager = require("playerManager")
local Routine = require("routine")

local blackscreen = Graphics.loadImage("blackscreen.png")

local active = true
local active2 = false
local ready = false
local exitscreen = false

local cooldown = 0

local player2 = Player(2)

local pausefont = textplus.loadFont("littleDialogue/font/sonicMania-bigFont.ini")
local pausefont2 = textplus.loadFont("littleDialogue/font/smb1-a.ini")
local pausefont3 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")

onePressedState = false
twoPressedState = false
threePressedState = false
fourPressedState = false
fivePressedState = false
sixPressedState = false
sevenPressedState = false
eightPressedState = false
ninePressedState = false
zeroPressedState = false

local flag = true
local str = "Loading HUB..."

local pausemenu2 = {}

local soundObject
if not isOverworld then
	local levelfolder = Level.folderPath()
	local levelname = Level.filename()
	local levelformat = Level.format()
end

local paused = false;
local pause_box;
local pause_height = 0;
local pause_width = 700;

local pause_options;
local character_options;
local pause_index = 0;

local pauseactive = false
local charactive = false

if not isOverworld then
	local level = Level.filename()
end

function pausemenu2.onInitAPI()
	registerEvent(pausemenu2, "onKeyboardPress")
	registerEvent(pausemenu2, "onDraw")
	registerEvent(pausemenu2, "onLevelExit")
	registerEvent(pausemenu2, "onTick")
	registerEvent(pausemenu2, "onInputUpdate")
	registerEvent(pausemenu2, "onStart")
	
	ready = true
end

local function unpause()
	paused = false
	Misc.unpause()
	cooldown = 5
	SFX.play(30)
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
end

function pausemenu2.onStart()
	if not ready then return end
end

local function quitgame()
	Audio.MusicVolume(0)
	SFX.play(59)
	SFX.play(31)
	Routine.run(function() exitscreen = true Routine.wait(2.1, true) Misc.saveGame() paused = false Misc.unpause() Misc.loadEpisode("Super Mario All-Stars++") end)
end

local function quitonly()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	SFX.play("wrong.ogg")
	SFX.play(31)
	Routine.run(function() exitscreen = true Routine.wait(2.1, true) paused = false Misc.unpause() Misc.loadEpisode("Super Mario All-Stars++") end)
end

local function savegame()
	paused = false
	SFX.play(58)
	Misc.saveGame()
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
end

local function exitlevelsave()
	Audio.MusicVolume(0)
	SFX.play(59)
	Routine.run(function() exitscreen = true Routine.wait(0.4, true) paused = false Misc.saveGame() Misc.unpause() Audio.MusicVolume(65) Level.exit() end)
end

local function exitlevel()
	Audio.MusicVolume(0)
	SFX.play(59)
	Routine.run(function() exitscreen = true Routine.wait(0.4, true) paused = false Misc.unpause() Audio.MusicVolume(65) Level.exit() end)
end

local function restartlevel()
	Audio.MusicVolume(0)
	SFX.play(59)
	Routine.run(function() exitscreen = true Routine.wait(0.4, true) paused = false Misc.unpause() Audio.MusicVolume(65) Level.load(Level.filename()) end)
end

local function changeresolution()
	SFX.play("resolution-set.ogg")
	if SaveData.resolution == "fullscreen" then
		SaveData.resolution = "widescreen"
	elseif SaveData.resolution == "widescreen" then
		SaveData.resolution = "ultrawide"
	elseif SaveData.resolution == "ultrawide" then
		SaveData.resolution = "nes"
	elseif SaveData.resolution == "nes" then
		SaveData.resolution = "gameboy"
	elseif SaveData.resolution == "gameboy" then
		SaveData.resolution = "gba"
	elseif SaveData.resolution == "gba" then
		SaveData.resolution = "iphone1st"
	elseif SaveData.resolution == "iphone1st" then
		SaveData.resolution = "3ds"
	elseif SaveData.resolution == "3ds" then
		SaveData.resolution = "fullscreen"
	end
end

local function changeresolutionborder()
	if SaveData.borderEnabled == true then
		SFX.play("resolutionborder-disable.ogg")
		SaveData.borderEnabled = false
	elseif SaveData.borderEnabled == false then
		SFX.play("resolutionborder-enable.ogg")
		SaveData.borderEnabled = true
	end
end

local function changeletterbox()
	if SaveData.letterbox == true then
		SFX.play("letterbox-disable.ogg")
		SaveData.letterbox = false
	elseif SaveData.letterbox == false then
		SFX.play("letterbox-enable.ogg")
		SaveData.letterbox = true
	end
end

local function startteleport()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	world.playerX = 832
	world.playerY = -1152
	SFX.play(34)
end

local function hubmapteleport()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	world.playerX = 320
	world.playerY = -1088
	SFX.play(34)
end

local function twoplayercheck()
	paused = false
	Misc.unpause()
	if player.count() == 1 then
		Cheats.trigger("2player")
		Defines.player_hasCheated = false
	end
	if player.count() == 2 then
		Cheats.trigger("1player")
		Defines.player_hasCheated = false
	end
end

local function characterchange13()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(2, false)
		SFX.play(32)
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(3, false)
		SFX.play(32)
	end
	if (character == CHARACTER_PEACH) then
		player:transform(4, false)
		SFX.play(32)
	end
	if (character == CHARACTER_TOAD) then
		player:transform(5, false)
		SFX.play(32)
	end
	if (character == CHARACTER_LINK) then
		player:transform(1, false)
		SFX.play(32)
	end
end

local function characterchange13_2p()
	local character = player2.character;
	if (character == CHARACTER_MARIO) then
		player2:transform(2, false)
		SFX.play(32)
	end
	if (character == CHARACTER_LUIGI) then
		player2:transform(3, false)
		SFX.play(32)
	end
	if (character == CHARACTER_PEACH) then
		player2:transform(4, false)
		SFX.play(32)
	end
	if (character == CHARACTER_TOAD) then
		player2:transform(5, false)
		SFX.play(32)
	end
	if (character == CHARACTER_LINK) then
		player2:transform(1, false)
		SFX.play(32)
	end
end

local function wip()
	SFX.play("wrong.ogg")
end

local function hubteleport()
	paused = false
	Misc.unpause()
	Level.load("MariosTown.lvlx", nil, nil)
end

local function drawPauseMenu(y, alpha)
	local name = "<color yellow>PAUSED</color>"
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
	local w,h = layout.width, layout.height
	if not isOverworld then
		textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 0}
	end
	if isOverworld then
		textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 7}
	end
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+8--font.charHeight;
	y = y+h;
	
	
	if(pause_options == nil) then
		pause_options = 
		{
			{name="Continue", action=unpause}
		}
		if not isOverworld then
			if (Level.filename() == "MariosTown.lvlx") == false then
				table.insert(pause_options, {name="Restart", action = restartlevel});
			end
		end
		if not isOverworld then
			if (Level.filename() == "MariosTown.lvlx") == true then
				table.insert(pause_options, {name="Restart HUB", action = restartlevel});
			end
		end
		if not isOverworld then
			if (Level.filename() == "MariosTown.lvlx") == false then
				table.insert(pause_options, {name="Teleport to Mario's City", action = hubteleport});
			end
		end
		if not isOverworld then
			table.insert(pause_options, {name="Change Character (1P)", action = characterchange13});
		end
		if not isOverworld then
			if player.count() == 2 then
				table.insert(pause_options, {name="Change Character (2P)", action = characterchange13_2p});
			end
		end
		table.insert(pause_options, {name="Change Resolution", action = changeresolution});
		table.insert(pause_options, {name="Toggle Widescreen Letterbox", action = changeletterbox});
		table.insert(pause_options, {name="Toggle Resolution Border", action = changeresolutionborder});
		if isOverworld then
			table.insert(pause_options, {name="Teleport back to the Start", action = startteleport});
		end
		if isOverworld then
			table.insert(pause_options, {name="Teleport to the HUB", action = hubmapteleport});
		end
		if not isOverworld then
			table.insert(pause_options, {name="Save and Exit to Map", action = exitlevelsave});
		end
		table.insert(pause_options, {name="Save and Continue", action = savegame});
		table.insert(pause_options, {name="Save and Exit to SMAS++", action = quitgame});
		table.insert(pause_options, {name="Exit to SMAS++ Without Saving", action = quitonly});
	end
	for k,v in ipairs(pause_options) do
		local c = 0xFFFFFF00;
		local n = v.name;
		if(v.inactive) then
			c = 0x99999900;
		end
		if(k == pause_index+1) then
			n = "<color rainbow><wave 1>"..n.."</wave></color>";
		end
			
		local layout = textplus.layout(textplus.parse(n, {xscale=1.5, yscale=1.5, font=pausefont3}), pause_width)
		local h2 = layout.height
		if not isOverworld then
			textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y+8, color = Color.fromHex(c+alpha*255), priority = 0}
		end
		if isOverworld then
			textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y+8, color = Color.fromHex(c+alpha*255), priority = 7}
		end
		--local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
		h2 = h2+2+6--font.charHeight;
		y = y+h2;
		h = h+h2;
	end
	
	if SaveData.resolution == "fullscreen" then
		resolutionshow = "<color red>Resolution: Fullscreen (4:3)</color>"
	end
	if SaveData.resolution == "widescreen" then
		resolutionshow = "<color red>Resolution: Widescreen (16:9)</color>"
	end
	if SaveData.resolution == "ultrawide" then
		resolutionshow = "<color red>Resolution: Ultrawide (21:9)</color>"
	end
	if SaveData.resolution == "nes" then
		resolutionshow = "<color red>Resolution: NES/SNES</color>"
	end
	if SaveData.resolution == "gameboy" then
		resolutionshow = "<color red>Resolution: Gameboy/Gameboy Color</color>"
	end
	if SaveData.resolution == "gba" then
		resolutionshow = "<color red>Resolution: Gameboy Advance</color>"
	end
	if SaveData.resolution == "iphone1st" then
		resolutionshow = "<color red>Resolution: iPhone (1st Generation)</color>"
	end
	if SaveData.resolution == "3ds" then
		resolutionshow = "<color red>Resolution: Nintendo 3DS (Top Screen)</color>"
	end
	
	if SaveData.letterbox == true then
		letterboxscale = "<color red>Scaling enabled: No</color>"
	end
	if SaveData.letterbox == false then
		letterboxscale = "<color red>Scaling enabled: Yes</color>"
	end
	
	if SaveData.borderEnabled == true then
		resolutiontheme = "<color red>Border enabled: Yes</color>"
	end
	if SaveData.borderEnabled == false then
		resolutiontheme = "<color red>Border enabled: No</color>"
	end

	--local font = textblox.FONT_SPRITEDEFAULT3X2;

	local layout = textplus.layout(textplus.parse(resolutionshow, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
	local layout2 = textplus.layout(textplus.parse(letterboxscale, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
	local layout3 = textplus.layout(textplus.parse(resolutiontheme, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
	if not isOverworld then
		textplus.render{layout = layout, x = 230 - w*0.5, y = y+4, color = Color.white..alpha, priority = 0}
		textplus.render{layout = layout2, x = 230 - w*0.5, y = y+20, color = Color.white..alpha, priority = 0}
		textplus.render{layout = layout3, x = 230 - w*0.5, y = y+36, color = Color.white..alpha, priority = 0}
	end
	if isOverworld then
		textplus.render{layout = layout, x = 230 - w*0.5, y = y+4, color = Color.white..alpha, priority = 7}
		textplus.render{layout = layout2, x = 230 - w*0.5, y = y+20, color = Color.white..alpha, priority = 7}
		textplus.render{layout = layout3, x = 230 - w*0.5, y = y+36, color = Color.white..alpha, priority = 7}
	end
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})

	h = h+4+44--font.charHeight;
	y = y+h;

	
	return h;
end

function pausemenu2.onDraw()
	local cooldown = 0
	if paused then
		Misc.pause()
		if(pause_box == nil) then
			pause_height = drawPauseMenu(-600,0);
			pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		if not isOverworld then
			pause_box:Draw(-1, 0x00000077);
		end
		if isOverworld then
			pause_box:Draw(7, 0x00000077);
		end
		drawPauseMenu(300-pause_height*0.5,1)
		
		--Fix for anything calling Misc.unpause
		Misc.pause();
	end
	if exitscreen then
		Graphics.drawScreen{color = Color.black, priority = 10}
	end
end

--function pausemenu2.onDraw()
--	if(paused) then
--		drawPauseMenu(-600,0)
--	end
--end

local lastPauseKey = false;

function pausemenu2.onInputUpdate()
	if(player.keys.pause and not lastPauseKey) then
		if paused then
			paused = false
			pauseactive = false
			SFX.play(30)
			cooldown = 5
			Misc.unpause()
			player:mem(0x11E,FIELD_BOOL,false)
		elseif(player:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused()) then
			--Misc.pause();
			paused = true
			pauseactive = true
			pause_index = 0;
			SFX.play(30)
		end
		if cooldown <= 0 then
			player:mem(0x11E,FIELD_BOOL,true)
		end
	end
	lastPauseKey = player.keys.pause;
	
	if(paused and pause_options) then
		if(player.keys.down == KEYS_PRESSED) then
			repeat
				pause_index = (pause_index+1)%#pause_options;
			until(not pause_options[pause_index+1].inactive);
			SFX.play(26)
		elseif(player.keys.up == KEYS_PRESSED) then
			repeat
				pause_index = (pause_index-1)%#pause_options;
			until(not pause_options[pause_index+1].inactive);
			SFX.play(26)
		elseif(player.keys.jump == KEYS_PRESSED) then
			player:mem(0x11E,FIELD_BOOL,false)
			for i=1, 3 do
				for k,v in ipairs(pause_options[i]) do
					if v then
						v.activeLerp = 0
					end
				end
			end
			--SFX.play("quitmenu.wav")
			pause_options[pause_index+1].action();
			Misc.unpause();
		end
		if player.count() == 2 then
			if(player2.keys.down == KEYS_PRESSED) then
				repeat
					pause_index = (pause_index+1)%#pause_options;
				until(not pause_options[pause_index+1].inactive);
				SFX.play(26)
			elseif(player2.keys.up == KEYS_PRESSED) then
				repeat
					pause_index = (pause_index-1)%#pause_options;
				until(not pause_options[pause_index+1].inactive);
				SFX.play(26)
			elseif(player2.keys.jump == KEYS_PRESSED) then
				--SFX.play("quitmenu.wav")
				pause_options[pause_index+1].action();
				Misc.unpause();
			end
		end
	end
end

function pausemenu2.onTick()
	if(paused) then
		Misc.pause();
	end
end

return pausemenu2