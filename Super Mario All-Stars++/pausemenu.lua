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

local pausefont = textplus.loadFont("littleDialogue/font/sonicMania-bigFont.ini")
local pausefont2 = textplus.loadFont("littleDialogue/font/smb1-a.ini")
local pausefont3 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")

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

local pausemenu = {}

pausemenu.pauseactivated = true

local soundObject

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()
local costumes = playerManager.getCostumes(player.character)

local paused = false;
local paused_char = false;
local paused_char_temp = false;
local paused_tele = false;
local pause_box;
local pause_height = 0;
local pause_width = 700;

local pause_options;
local pause_options_char;
local pause_options_tele;
local character_options;
local pause_index = 0
local pause_index_char = 0
local pause_index_tele = 0

local pauseactive = false
local charactive = false
local teleactive = false

local level = Level.filename()

function pausemenu.onInitAPI()
	registerEvent(pausemenu, "onKeyboardPress")
	registerEvent(pausemenu, "onDraw")
	registerEvent(pausemenu, "onLevelExit")
	registerEvent(pausemenu, "onTick")
	registerEvent(pausemenu, "onInputUpdate")
	registerEvent(pausemenu, "onStart")
	
	local Routine = require("routine")
	
	ready = true
end

local function nothing()
	--Nothing happens here
end

local function unpause()
	paused = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/pausemenu-closed.ogg")
end

function pausemenu.onStart()
	if not ready then return end
end

local function switchtochar()
	SFX.play("_OST/_Sound Effects/quitmenu.ogg")
	pause_index_char = 0
	Routine.run(function() Routine.wait(0.01, true) pause_index_char = 1 end)
	cooldown = 1
	paused_char = true
	paused = false
end

local function pausemenureturn()
	SFX.play("_OST/_Sound Effects/quitmenu_close.ogg")
	pause_index_char = 0
	cooldown = 1
	paused = true
	paused_char = false
end

local function switchtotele()
	SFX.play("_OST/_Sound Effects/quitmenu.ogg")
	pause_index_tele = 0
	Routine.run(function() Routine.wait(0.01, true) pause_index_tele = 1 end)
	cooldown = 1
	paused_tele = true
	paused = false
end

local function pausemenureturnhub()
	SFX.play("_OST/_Sound Effects/quitmenu_close.ogg")
	pause_index_tele = 0
	cooldown = 1
	paused = true
	paused_tele = false
end

local function x2modedisable()
	paused = false
	Misc.unpause()
	if SaveData.disableX2char == 0 then
		SaveData.disableX2char = SaveData.disableX2char + 1
		Level.load(Level.filename())
	end
end

local function x2modeenable()
	paused = false
	Misc.unpause()
	if SaveData.disableX2char == 1 then
		SaveData.disableX2char = SaveData.disableX2char - 1
		Level.load(Level.filename())
	end
end

local function quitgame()
	Audio.MusicVolume(0)
	Misc.saveGame()
	SFX.play("_OST/_Sound Effects/savequit.ogg")
	paused = false
	Routine.run(function() exitscreen = true Routine.wait(1.8, true) Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function quitonly()
	Graphics.drawScreen{color = Color.black, priority = 10}
	Audio.MusicVolume(0)
	SFX.play("_OST/_Sound Effects/nosave.ogg")
	Routine.run(function() exitscreen = true Routine.wait(0.9, true) Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function savegame()
	paused = false
	SFX.play("_OST/_Sound Effects/save_dismiss.ogg")
	Misc.saveGame()
	Misc.unpause()
end

local function exitlevelsave()
	paused = false
	Audio.MusicVolume(0)
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
	Routine.run(function() exitscreen = true Routine.wait(0.7, true) Misc.unpause() Audio.MusicVolume(nil) Misc.saveGame() Level.exit() end)
end

local function exitlevel()
	paused = false
	Audio.MusicVolume(0)
	SFX.play("_OST/_Sound Effects/quitmenu_close.ogg")
	Routine.run(function() exitscreen = true Routine.wait(0.4, true) Misc.unpause() Audio.MusicVolume(nil) Level.exit() end)
end

local function restartlevel()
	paused = false
	Audio.MusicVolume(0)
	SFX.play("_OST/_Sound Effects/skip-intro.ogg")
	Routine.run(function() exitscreen = true Routine.wait(1.5, true) Misc.unpause() Audio.MusicVolume(nil) Level.load(Level.filename()) end)
end

local function restartlevelhub()
	paused = false
	Audio.MusicVolume(0)
	SFX.play("_OST/_Sound Effects/skip-intro.ogg")
	Routine.run(function() exitscreen = true Routine.wait(1.5, true) Misc.unpause() Audio.MusicVolume(nil) Level.load("MALC - HUB.lvlx", nil, nil) end)
end

local function warpzonehub()
	paused = false
	paused_tele = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/level-select.ogg")
	player:teleport(20496, 19520, bottomCenterAligned)
end

local function touristhub()
	paused = false
	paused_tele = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/level-select.ogg")
	player:teleport(-119968, -120128, bottomCenterAligned)
end

local function starthub()
	paused = false
	paused_tele = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/level-select.ogg")
	player:teleport(-200608, -200128, bottomCenterAligned)
end

local function switchhub()
	paused = false
	paused_tele = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/level-select.ogg")
	player:teleport(40176, 39876, bottomCenterAligned)
end

local function characterchange()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(6, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_MEGAMAN) then
		player:transform(7, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_WARIO) then
		player:transform(8, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_BOWSER) then
		player:transform(9, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_KLONOA) then
		player:transform(10, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_NINJABOMBERMAN) then
		player:transform(11, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ROSALINA) then
		player:transform(12, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_SNAKE) then
		player:transform(13, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ZELDA) then
		player:transform(14, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ULTIMATERINKA) then
		player:transform(15, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_UNCLEBROADSWORD) then
		player:transform(16, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_SAMUS) then
		player:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchange13()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchange13_2p()
	local character = player2.character;
	if (character == CHARACTER_MARIO) then
		player2:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player2:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player2:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player2:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player2:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchangeleft()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(16, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_MEGAMAN) then
		player:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_WARIO) then
		player:transform(6, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_BOWSER) then
		player:transform(7, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_KLONOA) then
		player:transform(8, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_NINJABOMBERMAN) then
		player:transform(9, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ROSALINA) then
		player:transform(10, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_SNAKE) then
		player:transform(11, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ZELDA) then
		player:transform(12, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_ULTIMATERINKA) then
		player:transform(13, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_UNCLEBROADSWORD) then
		player:transform(14, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_SAMUS) then
		player:transform(15, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchange13left()
	local character = player.character;
	if (character == CHARACTER_MARIO) then
		player:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function characterchange13_2pleft()
	local character = player2.character;
	if (character == CHARACTER_MARIO) then
		player2:transform(5, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LUIGI) then
		player2:transform(1, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_PEACH) then
		player2:transform(2, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_TOAD) then
		player2:transform(3, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
	if (character == CHARACTER_LINK) then
		player2:transform(4, false)
		SFX.play(32)
		SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
		SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	end
end

local function costumechangeright()
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumeIdx = table.ifind(costumes,currentCostume)
	
	if costumeIdx ~= nil then
		player:setCostume(costumes[costumeIdx + 1])
	else
		player:setCostume(costumes[1])
	end
	SFX.play("_OST/_Sound Effects/charcost_costume.ogg")
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	--Routine.run(function() paused_char = false paused_char_temp = true Routine.waitFrames(2) paused_char = true paused_char_temp = false end)
end

local function costumechangeleft()
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumeIdx = table.ifind(costumes,currentCostume)
	
	if costumeIdx ~= nil then
		player:setCostume(costumes[costumeIdx - 1])
	else
		player:setCostume(costumes[1])
	end
	SFX.play("_OST/_Sound Effects/charcost_costume.ogg")
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	--Routine.run(function() paused_char = false paused_char_temp = true Routine.waitFrames(2) paused_char = true paused_char_temp = false end)
end

local function mainmenu()
	paused = false
	Misc.unpause()
	Misc.saveGame()
	Level.load("SMAS - Start.lvlx", nil, nil)
end

local function wrong()
	SFX.play("_OST/_Sound Effects/wrong.ogg")
end

local function hubteleport()
	paused = false
	Misc.unpause()
	Level.load("MALC - HUB.lvlx", nil, nil)
end

local function dlcmapload()
	paused = false
	Misc.unpause()
	Level.load("SMAS - DLC World.lvlx", nil, nil)
end

local function drawPauseMenu(y, alpha)
	local name = "<color yellow>PAUSED</color>"
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
	local w,h = layout.width, layout.height
	textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 5}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+8--font.charHeight;
	y = y+h;
	
	
	if(pause_options == nil) then
		pause_options = 
		{
			{name="Continue", action=unpause}
		}
		table.insert(pause_options, {name="Restart", action = restartlevel});
		if Level.filename() == "SMAS - DLC World.lvlx" then
			table.insert(pause_options, {name="Return to the Main Map", action = exitlevel});
		end
		if (Level.name() == "SMAS - DLC World") == false then
			table.insert(pause_options, {name="Go to the DLC Map", action = dlcmapload});
		end
		if (Level.name() == "MALC - HUB") == false then
			table.insert(pause_options, {name="Teleport to the HUB", action = hubteleport});
		end
		if SaveData.disableX2char == 1 then
			table.insert(pause_options, {name="Turn OFF SMBX 1.3 Mode", action = x2modeenable});
		end
		if SaveData.disableX2char == 0 then
			table.insert(pause_options, {name="Turn ON SMBX 1.3 Mode", action = x2modedisable});
		end
		if Level.filename() == "MALC - HUB.lvlx" then
			table.insert(pause_options, {name="Teleporting Options", action = switchtotele});
		end
		table.insert(pause_options, {name="Character Options", action = switchtochar});
		table.insert(pause_options, {name="Save and Reset Game", action = mainmenu});
		table.insert(pause_options, {name="Save and Exit to Map", action = exitlevelsave});
		table.insert(pause_options, {name="Save and Continue", action = savegame});
		table.insert(pause_options, {name="Save and Quit", action = quitgame});
		table.insert(pause_options, {name="Exit without Saving", action = quitonly});
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
		textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y+8, color = Color.fromHex(c+alpha*255), priority = 8}
		--local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
		h2 = h2+2+6--font.charHeight;
		y = y+h2;
		h = h+h2;
	end

	
	return h;
end

local function drawCharacterMenu(y, alpha)
	local name = "<color yellow>PAUSED</color>"
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
	local w,h = layout.width, layout.height
	textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 5}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+8--font.charHeight;
	y = y+h;
	
	
	if(pause_options_char == nil) then
		pause_options_char = 
		{
			{name2="Character Options", action=nothing}
		}
		
		table.insert(pause_options_char, {name2="Go Back", action = pausemenureturn});
		if SaveData.disableX2char == 0 then
			table.insert(pause_options_char, {name2="Change Character (Left)", action = characterchangeleft});
		end
		if SaveData.disableX2char == 0 then
			table.insert(pause_options_char, {name2="Change Character (Right)", action = characterchange});
		end
		if SaveData.disableX2char == 1 then
			table.insert(pause_options_char, {name2="Change 1P's Character (Left)", action = characterchange13left});
		end
		if SaveData.disableX2char == 1 then
			table.insert(pause_options_char, {name2="Change 1P's Character (Right)", action = characterchange13});
		end
		if SaveData.disableX2char == 1 then
			if Player.count() == 2 then
				table.insert(pause_options_char, {name2="Change 2P's Character (Left)", action = characterchange13_2pleft});
				table.insert(pause_options_char, {name2="Change 2P's Character (Right)", action = characterchange13_2p});
			end
		end
		if SaveData.disableX2char == 0 then
			table.insert(pause_options_char, {name2="Change Costume (Left)", action = costumechangeleft});
		end
		if SaveData.disableX2char == 0 then
			table.insert(pause_options_char, {name2="Change Costume (Right)", action = costumechangeright});
		end
	end
	for k,v in ipairs(pause_options_char) do
		local c = 0xFFFFFF00;
		local n = v.name2;
		if(v.inactive) then
			c = 0x99999900;
		end
		if(k == pause_index_char+1) then
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
	
	local currentCostume = player:getCostume()
	if currentCostume then
		costumename = "<color red>Current costume: "..currentCostume.."</color>"
	end
	if currentCostume == nil then
		costumename = "<color red>Current costume: N/A</color>"
	end
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(costumename, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
	textplus.render{layout = layout, x = 230 - w*0.5, y = y+4, color = Color.white..alpha, priority = 5}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+8--font.charHeight;
	y = y+h;

	
	return h;
end

local function drawHUBTeleportMenu(y, alpha)
	local name = "<color yellow>PAUSED</color>"
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
	local w,h = layout.width, layout.height
	textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 5}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+8--font.charHeight;
	y = y+h;
	
	
	if(pause_options_tele == nil) then
		pause_options_tele = 
		{
			{name3="Teleporting Options", action=nothing}
		}
		
		table.insert(pause_options_tele, {name3="Go Back", action = pausemenureturnhub});
		table.insert(pause_options_tele, {name3="Teleport to the Tourist Center", action = touristhub});
		table.insert(pause_options_tele, {name3="Teleport to the Warp Zone", action = warpzonehub});
		table.insert(pause_options_tele, {name3="Teleport to the Character Switch Menu", action = switchhub});
		table.insert(pause_options_tele, {name3="Teleport Back to the Start", action = starthub});
	end
	for k,v in ipairs(pause_options_tele) do
		local c = 0xFFFFFF00;
		local n = v.name3;
		if(v.inactive) then
			c = 0x99999900;
		end
		if(k == pause_index_tele+1) then
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

function pausemenu.onDraw(isSplit)
	if paused then
		Misc.pause()
		if(pause_box == nil) then
			pause_height = drawPauseMenu(-600,0);
			pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pause_box:Draw(5, 0x00000077);
		drawPauseMenu(300-pause_height*0.5,1)
		
		--Fix for anything calling Misc.unpause
		Misc.pause();
	end
	if not paused then
		pause_box = nil
	end
	if paused_char then
		Misc.pause()
		if(pause_box == nil) then
			pause_height = drawCharacterMenu(-600,0);
			pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pause_box:Draw(5, 0x00000077);
		drawCharacterMenu(300-pause_height*0.5,1)
		
		--Fix for anything calling Misc.unpause
		Misc.pause();
	end
	if not paused_char then
		pause_box = nil
	end
	if paused_tele then
		Misc.pause()
		if(pause_box == nil) then
			pause_height = drawHUBTeleportMenu(-600,0);
			pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pause_box:Draw(5, 0x00000077);
		drawHUBTeleportMenu(300-pause_height*0.5,1)
		
		--Fix for anything calling Misc.unpause
		Misc.pause();
	end
	if not paused_tele then
		pause_box = nil
	end
	if paused_char_temp then
		--Misc.pause()
		if(pause_box == nil) then
			pause_height = drawCharacterMenu(-600,0);
			pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pause_box:Draw(5, 0x00000077);
		drawCharacterMenu(300-pause_height*0.5,1)
		
		--Fix for anything calling Misc.unpause
		--Misc.pause();
	end
	if exitscreen then
		Graphics.drawScreen{color = Color.black, priority = 10}
	end
end

local lastPauseKey = false;

function pausemenu.onInputUpdate()
	if(player.pauseKeyPressing == true and not lastPauseKey) then
		if paused then
			paused = false
			paused_char = false
			paused_tele = false
			pauseactive = false
			SFX.play("_OST/_Sound Effects/pausemenu-closed.ogg")
			cooldown = 5
			Misc.unpause()
			player:mem(0x11E,FIELD_BOOL,false)
		elseif(player:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and pausemenu.pauseactivated == true) then
			--Misc.pause();
			paused = true
			pauseactive = true
			pause_index = 0;
			SFX.play("_OST/_Sound Effects/pausemenu.ogg")
		elseif player.count(2) then
			if paused then
				paused = false
				paused_char = false
				aused_tele = false
				pauseactive = false
				SFX.play("_OST/_Sound Effects/pausemenu-closed.ogg")
				cooldown = 5
				Misc.unpause()
				player2:mem(0x11E,FIELD_BOOL,false)
			end
		elseif player.count(2) then
			if(player2:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and pausemenu.pauseactivated == true) then
				--Misc.pause();
				paused = true
				pauseactive = true
				pause_index = 0;
				SFX.play("_OST/_Sound Effects/pausemenu.ogg")
			end
		end
		if cooldown <= 0 then
			player:mem(0x11E,FIELD_BOOL,true)
		end
		if pause_index_char == 0 then
			pause_index_char = pause_index_char + 1
		end
		if pause_index_tele == 0 then
			pause_index_tele = pause_index_tele + 1
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
		elseif(player.keys.jump == KEYS_PRESSED) then
			player:mem(0x11E,FIELD_BOOL,false)
			for i=1, 3 do
				for k,v in ipairs(pause_options[i]) do
					if v then
						v.activeLerp = 0
					end
				end
			end
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
				pause_options[pause_index+1].action();
				Misc.unpause();
			end
		end
	end
	if(paused_char and pause_options_char) then
		if(player.keys.down == KEYS_PRESSED) then
			repeat
				pause_index_char = (pause_index_char+1)%#pause_options_char;
			until(not pause_options_char[pause_index_char+1].inactive);
			SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
		elseif(player.keys.up == KEYS_PRESSED) then
			repeat
				pause_index_char = (pause_index_char-1)%#pause_options_char;
			until(not pause_options_char[pause_index_char+1].inactive);
			SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
		elseif(player.keys.jump == KEYS_PRESSED) then
			pause_options_char[pause_index_char+1].action();
			Misc.unpause();
		end
		if player.count() == 2 then
			if(player2.keys.down == KEYS_PRESSED) then
				repeat
					pause_index_char = (pause_index_char+1)%#pause_options_char;
				until(not pause_options_char[pause_index_char+1].inactive);
				SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
			elseif(player2.keys.up == KEYS_PRESSED) then
				repeat
					pause_index_char = (pause_index_char-1)%#pause_options_char;
				until(not pause_options_char[pause_index_char+1].inactive);
				SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
			elseif(player2.keys.jump == KEYS_PRESSED) then
				pause_options_char[pause_index_char+1].action();
				Misc.unpause();
			end
		end
	end
	if(paused_tele and pause_options_tele) then
		if(player.keys.down == KEYS_PRESSED) then
			repeat
				pause_index_tele = (pause_index_tele+1)%#pause_options_tele;
			until(not pause_options_tele[pause_index_tele+1].inactive);
			SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
		elseif(player.keys.up == KEYS_PRESSED) then
			repeat
				pause_index_tele = (pause_index_tele-1)%#pause_options_tele;
			until(not pause_options_tele[pause_index_tele+1].inactive);
			SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
		elseif(player.keys.jump == KEYS_PRESSED) then
			pause_options_tele[pause_index_tele+1].action();
			Misc.unpause();
		end
		if player.count() == 2 then
			if(player2.keys.down == KEYS_PRESSED) then
				repeat
					pause_index_tele = (pause_index_tele+1)%#pause_options_tele;
				until(not pause_options_tele[pause_index_tele+1].inactive);
				SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
			elseif(player2.keys.up == KEYS_PRESSED) then
				repeat
					pause_index_tele = (pause_index_tele-1)%#pause_options_tele;
				until(not pause_options_tele[pause_index_tele+1].inactive);
				SFX.play("_OST/_Sound Effects/pausemenu_cursor.ogg")
			elseif(player2.keys.jump == KEYS_PRESSED) then
				pause_options_tele[pause_index_tele+1].action();
				Misc.unpause();
			end
		end
	end
end

function pausemenu.onTick()
	if(paused) then
		Misc.pause();
	end
	if(paused_char) then
		if pause_index_char == 0 then
			pause_index_char = 1
		end
		if pause_options_char == 0 then
			pause_options_char = 1
		end
	end
	if(paused_tele) then
		if pause_index_tele == 0 then
			pause_index_tele = 1
		end
		if pause_options_tele == 0 then
			pause_options_tele = 1
		end
	end
	if pausemenu.pauseactivated == true then
		if player.pauseKeyPressing == false then
			player.pauseKeyPressing = true
		end
	end
	if pausemenu.pauseactivated == false then
		if player.pauseKeyPressing == true then
			player.pauseKeyPressing = false
		end
	end
end

return pausemenu