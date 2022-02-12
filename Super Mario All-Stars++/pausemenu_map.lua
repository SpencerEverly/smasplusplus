local textplus = require("textplus")
local imagic = require("imagic")
local rng = require("rng")
local Routine = require("routine")
local playerManager = require("playermanager")

local pausefont = textplus.loadFont("littleDialogue/font/sonicMania-bigFont.ini")
local pausefont2 = textplus.loadFont("littleDialogue/font/smb1-a.ini")
local pausefont3 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")

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

local paused = false;
local pause_box;
local pause_height = 0;
local pause_width = 700;

local pause_options;
local character_options;
local pause_index = 0;

local pauseactive = false
local charactive = false

local mapselectsfx = "charcost_mapselect.ogg"

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
	cooldown = 5
	SFX.play("_OST/_Sound Effects/pausemenu-closed.ogg")
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
end

function pausemenu2.onStart()
	if not ready then return end
end

local function quitonly()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	Misc.exitEngine();
end

local function quitgame()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	Misc.saveGame();
	Misc.exitEngine();
end

local function savegame()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	Misc.saveGame();
	SFX.play("_OST/_Sound Effects/save_dismiss.ogg")
end

local function startteleport()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	world.playerX = -2880
	world.playerY = -1664
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
end

local function sideteleport()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	world.playerX = -3168
	world.playerY = -1536
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
end

local function hubmapteleport()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	world.playerX = -3040
	world.playerY = -1760
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
end

local function dlcteleport()
	paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	SFX.play("_OST/_Sound Effects/hub_travelactivated.ogg")
	world.playerX = -1760
	world.playerY = -1568
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
end

local function characterchange()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(2, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(3, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(4, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(5, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(6, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_MEGAMAN) then
		player:transform(7, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_WARIO) then
		player:transform(8, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_BOWSER) then
		player:transform(9, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_KLONOA) then
		player:transform(10, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_NINJABOMBERMAN) then
		player:transform(11, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_ROSALINA) then
		player:transform(12, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_SNAKE) then
		player:transform(13, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_ZELDA) then
		player:transform(14, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_ULTIMATERINKA) then
		player:transform(15, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_UNCLEBROADSWORD) then
		player:transform(16, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_SAMUS) then
		player:transform(1, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
end

local function characterchange13()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(2, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(3, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(4, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(5, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(1, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
end

local function characterchange13_2p()
	local character = player2.character;
	if (character == CHARACTER_MARIO) then
		player2:transform(2, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player2:transform(3, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player2:transform(4, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player2:transform(5, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LINK) then
		player2:transform(1, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
end

local function characterchangeleft()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(16, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(1, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(2, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(3, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(4, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_MEGAMAN) then
		player:transform(5, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_WARIO) then
		player:transform(6, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_BOWSER) then
		player:transform(7, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_KLONOA) then
		player:transform(8, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_NINJABOMBERMAN) then
		player:transform(9, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_ROSALINA) then
		player:transform(10, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_SNAKE) then
		player:transform(11, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_ZELDA) then
		player:transform(12, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_ULTIMATERINKA) then
		player:transform(13, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_UNCLEBROADSWORD) then
		player:transform(14, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_SAMUS) then
		player:transform(15, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
end

local function characterchange13left()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(5, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(1, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(2, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(3, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(4, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
end

local function characterchange13_2pleft()
	local character = player2.character;
	if (character == CHARACTER_MARIO) then
		player2:transform(5, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player2:transform(1, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player2:transform(2, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player2:transform(3, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
	if (character == CHARACTER_LINK) then
		player2:transform(4, false)
		SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	end
end

local function costumechangeright()
	SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumeIdx = table.ifind(costumes,currentCostume)

	if costumeIdx ~= nil then
		player:setCostume(costumes[costumeIdx + 1])
	else
		player:setCostume(costumes[1])
		onePressedState = true
	end
end

local function costumechangeleft()
	SFX.play("_OST/_Sound Effects/charcost_mapselect.ogg")
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumeIdx = table.ifind(costumes,currentCostume)

	if costumeIdx ~= nil then
		player:setCostume(costumes[costumeIdx - 1])
	else
		player:setCostume(costumes[1])
		onePressedState = true
	end
end

local function wip()
	SFX.play("_OST/_Sound Effects/wrong.ogg")
end

local function drawPauseMenu(y, alpha)
	local name = "<color yellow>PAUSED</color>"
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
	local w,h = layout.width, layout.height
	textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 7}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+8--font.charHeight;
	y = y+h;
	
	
	if(pause_options == nil) then
		pause_options = 
		{
			{name="Continue", action=unpause}
		}
		
		if SaveData.disableX2char == 0 then
			table.insert(pause_options, {name="Change Character (Left)", action = characterchangeleft});
		end
		if SaveData.disableX2char == 0 then
			table.insert(pause_options, {name="Change Character (Right)", action = characterchange});
		end
		if SaveData.disableX2char == 1 then
			table.insert(pause_options, {name="Change 1P's Character (Left)", action = characterchange13left});
		end
		if SaveData.disableX2char == 1 then
			table.insert(pause_options, {name="Change 1P's Character (Right)", action = characterchange13});
		end
		if SaveData.disableX2char == 1 then
			if Player.count() == 2 then
				table.insert(pause_options, {name="Change 2P's Character (Left)", action = characterchange13_2pleft});
			end
		end
		if SaveData.disableX2char == 1 then
			if Player.count() == 2 then
				table.insert(pause_options, {name="Change 2P's Character (Right)", action = characterchange13_2p});
			end
		end
		if SaveData.disableX2char == 0 then
			table.insert(pause_options, {name="Change Costume (Left)", action = costumechangeleft});
		end
		if SaveData.disableX2char == 0 then
			table.insert(pause_options, {name="Change Costume (Right)", action = costumechangeright});
		end
		table.insert(pause_options, {name="Teleport back to the Start", action = startteleport});
		table.insert(pause_options, {name="Teleport to the HUB", action = hubmapteleport});
		table.insert(pause_options, {name="Teleport to the Side Quest", action = sideteleport});
		table.insert(pause_options, {name="Teleport to the DLC World", action = dlcteleport});
		table.insert(pause_options, {name="Save and Continue", action = savegame});
		table.insert(pause_options, {name="Save and Quit", action = quitgame});
		table.insert(pause_options, {name="Exit Without Saving (DATA WILL BE LOST)", action = quitonly});
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
			pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pause_box:Draw(5, 0x00000077);
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
			SFX.play("_OST/_Sound Effects/pausemenu-closed.ogg")
			cooldown = 5
			Misc.unpause()
		elseif(player:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld) and not Misc.isPaused()) then
			Misc.pause();
			paused = true
			pauseactive = true
			pause_index = 0;
			SFX.play("_OST/_Sound Effects/pausemenu.ogg")
		end
	end
	lastPauseKey = player.keys.pause;
	
	if(paused and pause_options) then
		if(player.keys.down == KEYS_PRESSED) then
			repeat
				pause_index = (pause_index+1)%#pause_options;
			until(not pause_options[pause_index+1].inactive);
			SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
		elseif(player.keys.up == KEYS_PRESSED) then
			repeat
				pause_index = (pause_index-1)%#pause_options;
			until(not pause_options[pause_index+1].inactive);
			SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
		elseif player.keys.left == KEYS_PRESSED then
			player.keys.left = KEYS_UNPRESSED
		elseif player.keys.right == KEYS_PRESSED then
			player.keys.right = KEYS_UNPRESSED
		elseif(player.keys.jump == KEYS_PRESSED) then
			player:mem(0x11E,FIELD_BOOL,false)
			for i=1, 3 do
				for k,v in ipairs(pause_options[i]) do
					if v then
						v.activeLerp = 0
					end
				end
			end
			--SFX.play("_OST/_Sound Effects/quitmenu.ogg")
			pause_options[pause_index+1].action();
			Misc.unpause();
		end
		if player.count() == 2 then
			if(player2.keys.down == KEYS_PRESSED) then
				repeat
					pause_index = (pause_index+1)%#pause_options;
				until(not pause_options[pause_index+1].inactive);
				SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
			elseif(player2.keys.up == KEYS_PRESSED) then
				repeat
					pause_index = (pause_index-1)%#pause_options;
				until(not pause_options[pause_index+1].inactive);
				SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
			elseif(player2.keys.jump == KEYS_PRESSED) then
				--SFX.play("_OST/_Sound Effects/quitmenu.ogg")
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