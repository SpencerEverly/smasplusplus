local textplus = require("textplus")
local imagic = require("imagic")
local rng = require("rng")

local active = true
local active2 = false
local ready = false

local cooldown = 0

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

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

local paused = false;
local pause_box;
local pause_height = 0;
local pause_width = 700;

local pause_options;
local character_options;
local pause_index = 0;

local pauseactive = false
local charactive = false

local level = Level.filename()

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
	paused = false;
	SFX.play("pausemenu-closed.wav")
end

function pausemenu2.onStart()
	if not ready then return end
end

local function quitgame()
	paused = false
	Misc.unpause()
	Misc.saveGame();
	Misc.exitEngine();
end

local function quitonly()
	paused = false
	Misc.unpause()
	Misc.exitEngine();
end

local function savegame()
	paused = false
	Misc.unpause()
	Misc.saveGame();
	SFX.play("save_dismiss.ogg")
end

local function exitlevelsave()
	paused = false
	Misc.unpause()
	Misc.saveGame();
	Level.exit()
end

local function exitlevel()
	paused = false
	Misc.unpause()
	Level.exit()
end

local function restartlevel()
	paused = false
	Misc.unpause()
	Level.load("MALC - HUB.lvlx", nil, nil)
end

local function warpzonehub()
	paused = false
	Misc.unpause()
	SFX.play("level-select.ogg")
	player:teleport(20496, 19520, bottomCenterAligned)
end

local function touristhub()
	paused = false
	Misc.unpause()
	SFX.play("level-select.ogg")
	player:teleport(-119968, -120128, bottomCenterAligned)
end

local function starthub()
	paused = false
	Misc.unpause()
	SFX.play("level-select.ogg")
	player:teleport(-200608, -200128, bottomCenterAligned)
end

local function switchhub()
	paused = false
	Misc.unpause()
	SFX.play("level-select.ogg")
	player:teleport(40176, 39876, bottomCenterAligned)
end

local function wip()
	SFX.play("wrong.wav")
end

local function hubteleport()
	paused = false
	Misc.unpause()
	Level.load("MALC - HUB.lvlx", nil, nil)
end

local function drawPauseMenu(y, alpha)
	local name = "Super Mario All-Stars++"
	local levelcurrent = "You are at "
	local levelname = "Me and Larry City."
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(name, {xscale=2, yscale=2, align="center", color=Color.red..1.0}), pause_width)
	local layout2 = textplus.layout(textplus.parse(levelcurrent, {xscale=2, yscale=2, align="center", color=Color.canary..1.0}), pause_width)
	local layout3 = textplus.layout(textplus.parse(levelname, {xscale=2, yscale=2, align="center", color=Color.yellow..1.0}), pause_width)
	local w,h = layout.width, layout.height
	textplus.render{layout = layout, x = 175 - w*0.5, y = y+16, color = Color.white..alpha, priority = 7}
	textplus.render{layout = layout2, x = 584 - w*0.5, y = y+16, color = Color.white..alpha, priority = 7}
	textplus.render{layout = layout3, x = 680 - w*0.5, y = y+16, color = Color.white..alpha, priority = 7}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+16--font.charHeight;
	y = y+h;
	
	
	if(pause_options == nil) then
		pause_options = 
		{
			{name="Continue", action=unpause}
		}
		
		table.insert(pause_options, {name="Restart HUB", action = restartlevel});
		table.insert(pause_options, {name="Teleport to the Tourist Center", action = touristhub});
		table.insert(pause_options, {name="Teleport to the Warp Zone", action = warpzonehub});
		table.insert(pause_options, {name="Teleport to the Character Switch Menu", action = switchhub});
		table.insert(pause_options, {name="Teleport Back to the Start", action = starthub});
		table.insert(pause_options, {name="Save and Exit to Map", action = exitlevelsave});
		table.insert(pause_options, {name="Save and Continue", action = savegame});
		table.insert(pause_options, {name="Save and Quit", action = quitgame});
		table.insert(pause_options, {name="Exit without Saving (DATA WILL BE LOST)", action = quitonly});
	end
	if(character_options == nil) then
		character_options = 
		{
			{name="Go Back", action=returntomainchar}
		}
		
		table.insert(character_options, {name="Mario", action = smario});
		table.insert(character_options, {name="Luigi", action = sluigi});
		table.insert(character_options, {name="Peach", action = speach});
		table.insert(character_options, {name="Toad", action = stoad});
		table.insert(character_options, {name="Link", action = slink});
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
			
		local layout = textplus.layout(textplus.parse(n, {xscale=2, yscale=2}), pause_width)
		local h2 = layout.height
		textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y, color = Color.fromHex(c+alpha*255), priority = 8}
		--local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
		h2 = h2+2+6--font.charHeight;
		y = y+h2;
		h = h+h2;
	end

	
	return h;
end

function pausemenu2.onDraw()
	if paused then
		if(pause_box == nil) then
			pause_height = drawPauseMenu(-600,0);
			pause_box = imagic.Create{x=400,y=300,width=700,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pause_box:Draw(5, 0x000000BB);
		drawPauseMenu(300-pause_height*0.5,1)
		
		--Fix for anything calling Misc.unpause
		Misc.pause();
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
			SFX.play("pausemenu-closed.wav")
			cooldown = 2
			Misc.unpause()
			player:mem(0x11E,FIELD_BOOL,false)
		elseif(player:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused()) then
			--Misc.pause();
			paused = true
			pauseactive = true
			pause_index = 0;
			SFX.play("pausemenu.wav")
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
			SFX.play("pausemenu_cursor.wav")
		elseif(player.keys.up == KEYS_PRESSED) then
			repeat
				pause_index = (pause_index-1)%#pause_options;
			until(not pause_options[pause_index+1].inactive);
			SFX.play("pausemenu_cursor.wav")
		elseif(player.keys.jump == KEYS_PRESSED) then
			player:mem(0x11E,FIELD_BOOL,false)
			for i=1, 3 do
				for k,v in ipairs(pause_options[i]) do
					if v then
						v.activeLerp = 0
					end
				end
			end
			SFX.play("quitmenu.wav")
			pause_options[pause_index+1].action();
			Misc.unpause();
		end
		if player.count() == 2 then
			if(player2.keys.down == KEYS_PRESSED) then
				repeat
					pause_index = (pause_index+1)%#pause_options;
				until(not pause_options[pause_index+1].inactive);
				SFX.play("pausemenu_cursor.wav")
			elseif(player2.keys.up == KEYS_PRESSED) then
				repeat
					pause_index = (pause_index-1)%#pause_options;
				until(not pause_options[pause_index+1].inactive);
				SFX.play("pausemenu_cursor.wav")
			elseif(player2.keys.jump == KEYS_PRESSED) then
				SFX.play("quitmenu.wav")
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