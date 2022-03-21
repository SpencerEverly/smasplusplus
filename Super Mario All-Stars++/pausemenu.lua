local textplus = require("textplus")
local imagic = require("imagic")
local rng = require("rng")
local playerManager = require("playerManager")
local Routine = require("routine")

local blackscreen = Graphics.loadImage("blackscreen.png")

local player2 = Player(2)

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

if not isOverworld then
	local levelname = Level.filename()
	local levelformat = Level.format()
	local costumes = playerManager.getCostumes(player.character)
	local level = Level.filename()
end

pausemenu.paused = false;
pausemenu.paused_char = false;
pausemenu.paused_char_temp = false;
pausemenu.paused_tele = false;

pausemenu.pause_box = nil
local pause_height = 0;
local pause_height_char = 350;
local pause_width = 700;

local pause_options;
local pause_options_char;
local pause_options_tele;
local character_options;
local pause_index = 0
local pause_index_char = 0
local pause_index_tele = 0

pausemenu.pauseactive = false
local charactive = false
local teleactive = false

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
	pausemenu.paused = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/pausemenu-closed.ogg")
	cooldown = 5
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
end

function pausemenu.onStart()
	if not ready then return end
end

local function switchtochar()
	SFX.play("_OST/_Sound Effects/quitmenu.ogg")
	pause_index_char = 0
	Routine.run(function() Routine.wait(0.01, true) pause_index_char = 1 end)
	cooldown = 1
	pausemenu.paused_char = true
	pausemenu.paused = false
end

local function pausemenureturn()
	SFX.play("_OST/_Sound Effects/quitmenu_close.ogg")
	pause_index_char = 0
	cooldown = 1
	pausemenu.paused = true
	pausemenu.paused_char = false
end

local function switchtotele()
	SFX.play("_OST/_Sound Effects/quitmenu.ogg")
	pause_index_tele = 0
	Routine.run(function() Routine.wait(0.01, true) pause_index_tele = 1 end)
	cooldown = 1
	pausemenu.paused_tele = true
	pausemenu.paused = false
end

local function pausemenureturnhub()
	SFX.play("_OST/_Sound Effects/quitmenu_close.ogg")
	pause_index_tele = 0
	cooldown = 1
	pausemenu.paused = true
	pausemenu.paused_tele = false
end

local function x2modedisable()
	pausemenu.paused = false
	Misc.unpause()
	if SaveData.disableX2char == false then
		SaveData.disableX2char = true
		Level.load(Level.filename())
	end
end

local function x2modeenable()
	pausemenu.paused = false
	Misc.unpause()
	if SaveData.disableX2char == true then
		SaveData.disableX2char = false
		Level.load(Level.filename())
	end
end

local function quitgame()
	Audio.MusicVolume(0)
	Audio.MusicPause()
	Misc.saveGame()
	SFX.play("_OST/_Sound Effects/savequit.ogg")
	Routine.run(function() exitscreen = true Routine.wait(1.8, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function quitonly()
	Graphics.drawScreen{color = Color.black, priority = 10}
	Audio.MusicVolume(0)
	Audio.MusicPause()
	SFX.play("_OST/_Sound Effects/nosave.ogg")
	Routine.run(function() exitscreen = true Routine.wait(0.9, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function savegame()
	pausemenu.paused = false
	SFX.play("_OST/_Sound Effects/save_dismiss.ogg")
	Misc.saveGame()
	Misc.unpause()
end

local function quitgamemap()
	Audio.MusicVolume(0)
	Audio.MusicPause()
	Misc.saveGame()
	SFX.play("_OST/_Sound Effects/savequit.ogg")
	Routine.run(function() exitscreen = true Routine.wait(1.8, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function changeresolution()
	SFX.play("_OST/_Sound Effects/resolution-set.ogg")
	if SaveData.resolution == "widescreen" then
		SaveData.resolution = "fullscreen"
	elseif SaveData.resolution == "fullscreen" then
		SaveData.resolution = "widescreen"
	end
end

local function quitonlymap()
	Graphics.drawScreen{color = Color.black, priority = 10}
	Audio.MusicVolume(0)
	Audio.MusicPause()
	SFX.play("_OST/_Sound Effects/nosave.ogg")
	Routine.run(function() exitscreen = true Routine.wait(0.9, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function savegamemap()
	pausemenu.paused = false
	cooldown = 5
	Misc.unpause()
	player:mem(0x17A,FIELD_BOOL,false)
	if cooldown <= 0 then
		player:mem(0x17A,FIELD_BOOL,true)
	end
	Misc.saveGame();
	SFX.play("_OST/_Sound Effects/save_dismiss.ogg")
end

local function returntolastlevel()
	Audio.MusicVolume(0)
	Audio.MusicPause()
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
	Routine.run(function() exitscreen = true Routine.wait(0.7, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Level.load(SaveData.lastLevelPlayed, nil, nil) end)
end

local function exitlevel2()
	Audio.MusicVolume(0)
	Audio.MusicPause()
	SFX.play("_OST/_Sound Effects/world_warp.ogg")
	Routine.run(function() exitscreen = true Routine.wait(0.7, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Level.exit() end)
end

local function exitlevel()
	Audio.MusicVolume(0)
	Audio.MusicPause()
	SFX.play("_OST/_Sound Effects/quitmenu_close.ogg")
	Routine.run(function() exitscreen = true Routine.wait(0.4, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Level.exit() end)
end

local function restartlevel()
	Audio.MusicVolume(0)
	Audio.MusicPause()
	SFX.play("_OST/_Sound Effects/skip-intro.ogg")
	Routine.run(function() exitscreen = true Routine.wait(1.5, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Level.load(Level.filename()) end)
end

local function restartlevelhub()
	Audio.MusicVolume(0)
	Audio.MusicPause()
	SFX.play("_OST/_Sound Effects/skip-intro.ogg")
	Routine.run(function() exitscreen = true Routine.wait(1.5, true) pausemenu.paused = false Misc.unpause() Audio.MusicVolume(nil) Level.load("MALC - HUB.lvlx", nil, nil) end)
end

local function warpzonehub()
	pausemenu.paused = false
	pausemenu.paused_tele = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/level-select.ogg")
	player:teleport(20496, 19520, bottomCenterAligned)
end

local function touristhub()
	pausemenu.paused = false
	pausemenu.paused_tele = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/level-select.ogg")
	player:teleport(-119968, -120128, bottomCenterAligned)
end

local function starthub()
	pausemenu.paused = false
	pausemenu.paused_tele = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/level-select.ogg")
	player:teleport(-200608, -200128, bottomCenterAligned)
end

local function switchhub()
	pausemenu.paused = false
	pausemenu.paused_tele = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/level-select.ogg")
	player:teleport(40176, 39876, bottomCenterAligned)
end

local function shophub()
	pausemenu.paused = false
	pausemenu.paused_tele = false
	Misc.unpause()
	SFX.play("_OST/_Sound Effects/level-select.ogg")
	player:teleport(80144, 79868, bottomCenterAligned)
end

local function startteleport()
	pausemenu.paused_tele = false;
	cooldown = 5
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
	pausemenu.paused_tele = false;
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
	pausemenu.paused_tele = false;
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
	pausemenu.paused_tele = false;
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

local function charmario()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(1, false)
end

local function charluigi()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(2, false)
end

local function charpeach()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(3, false)
end

local function chartoad()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(4, false)
end

local function charlink()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(5, false)
end

local function charmegaman()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(6, false)
end

local function charmegaman()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(6, false)
end

local function charwario()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(7, false)
end

local function charbowser()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(8, false)
end

local function charklonoa()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(9, false)
end

local function charyoshi()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(10, false)
end

local function charrosalina()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(11, false)
end

local function charsnake()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(12, false)
end

local function charzelda()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(13, false)
end

local function charsteve()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(14, false)
end

local function charunclebroadsword()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(15, false)
end

local function charsamus()
	SFX.play("_OST/_Sound Effects/charcost-selected.ogg")
	SFX.play("_OST/_Sound Effects/racoon-changechar.ogg")
	player:transform(16, false)
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
	--Routine.run(function() pausemenu.paused_char = false pausemenu.paused_char_temp = true Routine.waitFrames(2) pausemenu.paused_char = true pausemenu.paused_char_temp = false end)
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
	--Routine.run(function() pausemenu.paused_char = false pausemenu.paused_char_temp = true Routine.waitFrames(2) pausemenu.paused_char = true pausemenu.paused_char_temp = false end)
end

local function mainmenu()
	pausemenu.paused = false
	Misc.unpause()
	Misc.saveGame()
	Routine.run(function() exitscreen = true Audio.MusicVolume(0) SFX.play("_OST/_Sound Effects/shutdown.ogg") Routine.wait(2.4, true) paused = false Misc.saveGame() Misc.unpause() Audio.MusicVolume(65) Level.load("SMAS - Start.lvlx", nil, nil) end)
end

local function wrong()
	SFX.play("_OST/_Sound Effects/wrong.ogg")
end

local function hubteleport()
	pausemenu.paused = false
	Misc.unpause()
	Level.load("MALC - HUB.lvlx", nil, nil)
end

local function dlcmapload()
	pausemenu.paused = false
	Misc.unpause()
	Level.load("SMAS - Map.lvlx", nil, nil)
end

local function cycle(dir)
	if #pause_options_char[pause_index_char] == 0 then return end
	SFX.play(sfx.move)
	currentMenuPosition[pause_index_char] = currentMenuPosition[pause_index_char] + dir
	local pos = currentMenuPosition[pause_index_char]
	if (not pause_options_char[pause_index_char][pos] and pos > 0 and pos <= #pause_options_char[pause_index_char]) then
		return cycle(dir)
	end

	if currentMenuPosition[pause_index_char] <= 0 then
		currentMenuPosition[pause_index_char] = #pause_options_char[pause_index_char] + 1
		return cycle(dir)
	end

	if currentMenuPosition[pause_index_char] > #pause_options_char[pause_index_char] then
		currentMenuPosition[pause_index_char] = 0
		return cycle(dir)
	end
end

local function drawPauseMenu(y, alpha)
	local name = "<color yellow>PAUSED</color>"
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(name, {xscale=1, yscale=1, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
	local w,h = layout.width, layout.height
	textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 5}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+4--font.charHeight;
	y = y+h;
	
	
	if(pause_options == nil) then
		pause_options = 
		{
			{name="Continue", action=unpause}
		}
		if not isOverworld then
			table.insert(pause_options, {name="Restart", action = restartlevel});
		end
		if not isOverworld then
			table.insert(pause_options, {name="Exit to the Main Map", action = exitlevel2});
		end
		if not isOverworld then
			table.insert(pause_options, {name="Return to the Previous Level", action = returntolastlevel});
		end
		if not isOverworld then
			if (Level.name() == "SMAS - Map") == false then
				table.insert(pause_options, {name="Go to the Extra Game/DLC Map", action = dlcmapload});
			end
		end
		if not isOverworld then
			if (Level.name() == "MALC - HUB") == false then
				table.insert(pause_options, {name="Teleport to the HUB", action = hubteleport});
			end
		end
		if not isOverworld then
			if SaveData.disableX2char == true then
				table.insert(pause_options, {name="Turn OFF SMBX 1.3 Mode", action = x2modeenable});
			end
		end
		if not isOverworld then
			if SaveData.disableX2char == false then
				table.insert(pause_options, {name="Turn ON SMBX 1.3 Mode", action = x2modedisable});
			end
		end
		if not isOverworld then
			if Level.filename() == "MALC - HUB.lvlx" then
				table.insert(pause_options, {name="Teleporting Options", action = switchtotele});
			end
		end
		if isOverworld then
			table.insert(pause_options, {name="Teleporting Options", action = switchtotele});
		end
		if not isOverworld then
			table.insert(pause_options, {name="Character Options", action = switchtochar});
		end
		if isOverworld then
			table.insert(pause_options, {name="Character Options", action = switchtochar});
		end
		table.insert(pause_options, {name="Change Resolution", action = changeresolution});
		if not isOverworld and Defines.player_hasCheated == false then
			table.insert(pause_options, {name="Save and Continue", action = savegame});
		end
		if isOverworld and Defines.player_hasCheated == false then
			table.insert(pause_options, {name="Save and Continue", action = savegamemap});
		end
		if not isOverworld and Defines.player_hasCheated == false then
			table.insert(pause_options, {name="Save and Reset Game", action = mainmenu});
		end
		if not isOverworld and Defines.player_hasCheated == false then
			table.insert(pause_options, {name="Save and Quit", action = quitgame});
		end
		if isOverworld and Defines.player_hasCheated == false then
			table.insert(pause_options, {name="Save and Quit", action = quitgamemap});
		end
		if not isOverworld then
			table.insert(pause_options, {name="Exit without Saving", action = quitonly});
		end
		if isOverworld then
			table.insert(pause_options, {name="Exit without Saving", action = quitonlymap});
		end
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
			
		local layout = textplus.layout(textplus.parse(n, {xscale=1, yscale=1, font=pausefont3}), pause_width)
		local h2 = layout.height
		textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y+8, color = Color.fromHex(c+alpha*255), priority = 8}
		
		--local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
		h2 = h2+2+4--font.charHeight;
		y = y+h2;
		h = h+h2;
	end
	
	if SaveData.resolution == "fullscreen" then
		resolutionshow = "<color red>Resolution: Fullscreen (4:3)</color>"
	end
	if SaveData.resolution == "widescreen" then
		resolutionshow = "<color red>Resolution: Widescreen (16:9)</color>"
	end
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(resolutionshow, {xscale=1, yscale=1, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
	textplus.render{layout = layout, x = 250 - w*0.5, y = y+4, color = Color.white..alpha, priority = 5}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})

	h = h+4+6--font.charHeight;
	y = y+h;

	
	return h;
end

local function drawCharacterMenu(y, alpha)
	local name = "<color yellow>PAUSED</color>"
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(name, {xscale=1, yscale=1, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
	local w,h = layout.width, layout.height
	textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 5}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+4--font.charHeight;
	y = y+h;
	
	
	if(pause_options_char == nil) then
		pause_options_char = 
		{
			{name2="Character Options", action=nothing}
		}
		
		table.insert(pause_options_char, {name2="Go Back", action = pausemenureturn});
		if SaveData.disableX2char == false then
			table.insert(pause_options_char, {name2="Change Character (Left)", action = characterchangeleft});
		end
		if SaveData.disableX2char == false then
			table.insert(pause_options_char, {name2="Change Character (Right)", action = characterchange});
		end
		if SaveData.disableX2char == true then
			table.insert(pause_options_char, {name2="Change 1P's Character (Left)", action = characterchange13left});
		end
		if SaveData.disableX2char == true then
			table.insert(pause_options_char, {name2="Change 1P's Character (Right)", action = characterchange13});
		end
		if SaveData.disableX2char == true then
			if Player.count() == 2 then
				table.insert(pause_options_char, {name2="Change 2P's Character (Left)", action = characterchange13_2pleft});
				table.insert(pause_options_char, {name2="Change 2P's Character (Right)", action = characterchange13_2p});
			end
		end
		if SaveData.disableX2char == false then
			table.insert(pause_options_char, {name2="Change Costume (Left)", action = costumechangeleft});
		end
		if SaveData.disableX2char == false then
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
			
		local layout = textplus.layout(textplus.parse(n, {xscale=1, yscale=1, font=pausefont3}), pause_width)
		local h2 = layout.height
		textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y, color = Color.fromHex(c+alpha*255), priority = 8}
		--local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
		h2 = h2+2+4--font.charHeight;
		y = y+h2;
		h = h+h2;
	end
	
	local currentCostume = player:getCostume()
	if currentCostume then
		costumename = "<color red>Current costume: "..currentCostume.."</color>"
	end
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		costumename = "<color red>Current costume: SMAS++ 2012 Beta Mario</color>"
	end
	if currentCostume == "1-SMB1-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. (NES)</color>"
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		costumename = "<color red>Current costume: Super Mario Bros. (Recolored)</color>"
	end
	if currentCostume == "3-SMB1-SMAS" then
		costumename = "<color red>Current costume: Super Mario Bros. (SNES)</color>"
	end
	if currentCostume == "4-SMB2-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. 2 (NES)</color>"
	end
	if currentCostume == "5-SMB2-SMAS" then
		costumename = "<color red>Current costume: Super Mario Bros. 2 (SNES)</color>"
	end
	if currentCostume == "6-SMB3-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. 3 (NES)</color>"
	end
	if currentCostume == "7-SML2" then
		costumename = "<color red>Current costume: Super Mario Land 2 (GB)</color>"
	end
	if currentCostume == "9-SMW-PIRATE" then
		costumename = "<color red>Current costume: Super Mario World (NES, Bootleg)</color>"
	end
	if currentCostume == "11-SMA1" then
		costumename = "<color red>Current costume: Super Mario Advance 1 (GBA)</color>"
	end
	if currentCostume == "12-SMA2" then
		costumename = "<color red>Current costume: Super Mario Advance 2 (GBA)</color>"
	end
	if currentCostume == "13-SMA4" then
		costumename = "<color red>Current costume: Super Mario Advance 4 (GBA)</color>"
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		costumename = "<color red>Current costume: New Super Mario Bros. (SMBX)</color>"
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		costumename = "<color red>Current costume: New Super Mario Bros. (NDS)</color>"
	end
	if currentCostume == "A2XT-DEMO" then
		costumename = "<color red>Current costume: Demo (A2XT)</color>"
	end
	if currentCostume == "DEMO-XMASPILY" then
		costumename = "<color red>Current costume: Pily (A2XT: Gaiden 2)</color>"
	end
	if currentCostume == "GA-CAILLOU" then
		costumename = "<color red>Current costume: Caillou (GoAnimate, Vyond)</color>"
	end
	if currentCostume == "GOLDENMARIO" then
		costumename = "<color red>Current costume: Golden Mario (SMBX)</color>"
	end
	if currentCostume == "GOOMBA" then
		costumename = "<color red>Current costume: Goomba (SMBX)</color>"
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		costumename = "<color red>Current costume: JC Foster Takes it to the Moon</color>"
	end
	if currentCostume == "MARINK" then
		costumename = "<color red>Current costume: The Legend of Mario (SMBX)</color>"
	end
	if currentCostume == "MODERN" then
		costumename = "<color red>Current costume: Modern Mario Bros.</color>"
	end
	if currentCostume == "PRINCESSRESCUE" then
		costumename = "<color red>Current costume: Princess Rescue (Atari 2600)</color>"
	end
	if currentCostume == "SMB0" then
		costumename = "<color red>Current costume: Super Mario Bros. 0 (SMBX)</color>"
	end
	if currentCostume == "SMG4" then
		costumename = "<color red>Current costume: SuperMarioGlitchy4 (YouTube)</color>"
	end
	if currentCostume == "SMM2-MARIO" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Mario)</color>"
	end
	if currentCostume == "SMM2-LUIGI" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Luigi)</color>"
	end
	if currentCostume == "SMM2-TOAD" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Toad)</color>"
	end
	if currentCostume == "SMM2-TOADETTE" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Toadette)</color>"
	end
	if currentCostume == "SMM2-YELLOWTOAD" then
		costumename = "<color red>Current costume: Super Mario Maker (SMW, Yellow Toad)</color>"
	end
	if currentCostume == "SMW-MARIO" then
		costumename = "<color red>Current costume: Super Mario World (SNES)</color>"
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		costumename = "<color red>Current costume: Eric Cartman (South Park)</color>"
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		costumename = "<color red>Current costume: Super Mario World 2 (SNES)</color>"
	end
	
	if currentCostume == "0-SPENCEREVERLY" then
		costumename = "<color red>Current costume: Spencer Everly (SMBS)</color>"
	end
	if currentCostume == "3-SMB1-RETRO-MODERN" then
		costumename = "<color red>Current costume: Super Mario Bros. (NES, Modern)</color>"
	end
	if currentCostume == "4-SMB1-SMAS" then
		costumename = "<color red>Current costume: Super Mario Bros. (SNES)</color>"
	end
	if currentCostume == "5-SMB2-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. 2 (NES)</color>"
	end
	if currentCostume == "6-SMB2-SMAS" then
		costumename = "<color red>Current costume: Super Mario Bros. 2 (SNES)</color>"
	end
	if currentCostume == "7-SMB3-RETRO" then
		costumename = "<color red>Current costume: Super Mario Bros. 3 (NES)</color>"
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		costumename = "<color red>Current costume: Marigi</color>"
	end
	if currentCostume == "10-SMW-ORIGINAL" then
		costumename = "<color red>Current costume: Super Mario World (SNES)</color>"
	end
	if currentCostume == "13-SMBDX" then
		costumename = "<color red>Current costume: Super Mario Bros. Deluxe (GBC)</color>"
	end
	if currentCostume == "15-SMA2" then
		costumename = "<color red>Current costume: Super Mario Advance 2 (GBA)</color>"
	end
	if currentCostume == "16-SMA4" then
		costumename = "<color red>Current costume: Super Mario Advance 4 (GBA)</color>"
	end
	if currentCostume == "17-NSMBDS-SMBX" then
		costumename = "<color red>Current costume: New Super Mario Bros. (SMBX)</color>"
	end
	if currentCostume == "A2XT-IRIS" then
		costumename = "<color red>Current costume: Iris (A2XT)</color>"
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		costumename = "<color red>Current costume: Larry (VeggieTales)</color>"
	end
	if currentCostume == "UNDERTALE-FRISK" then
		costumename = "<color red>Current costume: Frisk (Undertale)</color>"
	end
	if currentCostume == "WALUIGI" then
		costumename = "<color red>Current costume: Waluigi</color>"
	end
	if currentCostume == "SMW-LUIGI" then
		costumename = "<color red>Current costume: Super Mario World (SMAS)</color>"
	end
	
	if currentCostume == nil then
		costumename = "<color red>Current costume: N/A</color>"
	end
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(costumename, {xscale=1, yscale=1, align="center", color=Color.canary..1.0, font=pausefont3}), pause_width)
	textplus.render{layout = layout, x = 300 - w*0.5, y = y+4, color = Color.white..alpha, priority = 5}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+4+8--font.charHeight;
	y = y+h;

	
	return h;
end

local function drawHUBTeleportMenu(y, alpha)
	local name = "<color yellow>PAUSED</color>"
	--local font = textblox.FONT_SPRITEDEFAULT3X2;
	
	local layout = textplus.layout(textplus.parse(name, {xscale=1, yscale=1, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
	local w,h = layout.width, layout.height
	textplus.render{layout = layout, x = 450 - w*0.5, y = y+8, color = Color.white..alpha, priority = 5}
	--local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
	
	h = h+16+4--font.charHeight;
	y = y+h;
	
	
	if(pause_options_tele == nil) then
		pause_options_tele = 
		{
			{name3="Teleporting Options", action=nothing}
		}
		
		table.insert(pause_options_tele, {name3="Go Back", action = pausemenureturnhub});
		if not isOverworld then
			table.insert(pause_options_tele, {name3="Teleport to the Tourist Center", action = touristhub});
		end
		if not isOverworld then
			table.insert(pause_options_tele, {name3="Teleport to the Warp Zone", action = warpzonehub});
		end
		if not isOverworld then
			table.insert(pause_options_tele, {name3="Teleport to the Character Switch Menu", action = switchhub});
		end
		if not isOverworld then
			table.insert(pause_options_tele, {name3="Teleport to the Shop", action = shophub});
		end
		if not isOverworld then
			table.insert(pause_options_tele, {name3="Teleport Back to the Start", action = starthub});
		end
		if isOverworld then
			table.insert(pause_options_tele, {name3="Teleport back to the Start", action = startteleport});
		end
		if isOverworld then
			table.insert(pause_options_tele, {name3="Teleport to the HUB", action = hubmapteleport});
		end
		if isOverworld then
			table.insert(pause_options_tele, {name3="Teleport to the Side Quest", action = sideteleport});
		end
		if isOverworld then
			table.insert(pause_options_tele, {name3="Teleport to the DLC World", action = dlcteleport});
		end
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
			
		local layout = textplus.layout(textplus.parse(n, {xscale=1, yscale=1, font=pausefont3}), pause_width)
		local h2 = layout.height
		textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y, color = Color.fromHex(c+alpha*255), priority = 8}
		--local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
		h2 = h2+2+4--font.charHeight;
		y = y+h2;
		h = h+h2;
	end

	
	return h;
end

function pausemenu.onDraw(isSplit)
	if pausemenu.paused then
		Misc.pause()
		if(pausemenu.pause_box == nil) then
			pause_height = drawPauseMenu(-600,0);
			pausemenu.pause_box = imagic.Create{x=400,y=300,width=400,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pausemenu.pause_box:Draw(5, 0x00000077);
		drawPauseMenu(300-pause_height*0.5,1)
		
		--Fix for anything calling Misc.unpause
		--Misc.pause();
	end
	if not pausemenu.paused then
		pausemenu.pause_box = nil
	end
	if pausemenu.paused_char then
		Misc.pause()
		if(pausemenu.pause_box == nil) then
			pause_height = drawCharacterMenu(-600,0);
			pausemenu.pause_box = imagic.Create{x=400,y=300,width=400,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pausemenu.pause_box:Draw(5, 0x00000077);
		drawCharacterMenu(300-pause_height*0.5,1)
		
		--Fix for anything calling Misc.unpause
		--Misc.pause();
	end
	if not pausemenu.paused_char then
		pausemenu.pause_box = nil
	end
	if pausemenu.paused_tele then
		Misc.pause()
		if(pausemenu.pause_box == nil) then
			pause_height = drawHUBTeleportMenu(-600,0);
			pausemenu.pause_box = imagic.Create{x=400,y=300,width=400,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pausemenu.pause_box:Draw(5, 0x00000077);
		drawHUBTeleportMenu(300-pause_height*0.5,1)
		
		--Fix for anything calling Misc.unpause
		Misc.pause();
	end
	if not pausemenu.paused_tele then
		pausemenu.pause_box = nil
	end
	if pausemenu.paused_char_temp then
		--Misc.pause()
		if(pausemenu.pause_box == nil) then
			pause_height = drawCharacterMenu(-600,0);
			pausemenu.pause_box = imagic.Create{x=400,y=300,width=400,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
		end
		pausemenu.pause_box:Draw(5, 0x00000077);
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
		if pausemenu.paused then
			pausemenu.paused = false
			pausemenu.paused_char = false
			pausemenu.paused_tele = false
			pausemenu.pauseactive = false
			SFX.play("_OST/_Sound Effects/pausemenu-closed.ogg")
			cooldown = 5
			Misc.unpause()
			player:mem(0x11E,FIELD_BOOL,false)
		elseif(player:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and pausemenu.pauseactivated == true) then
			--Misc.pause();
			pausemenu.paused = true
			pausemenu.pauseactive = true
			pause_index = 0;
			SFX.play("_OST/_Sound Effects/pausemenu.ogg")
		elseif player.count() == 2 then
			if pausemenu.paused then
				pausemenu.paused = false
				pausemenu.paused_char = false
				pausemenu.paused_tele = false
				pausemenu.pauseactive = false
				SFX.play("_OST/_Sound Effects/pausemenu-closed.ogg")
				cooldown = 5
				Misc.unpause()
				player2:mem(0x11E,FIELD_BOOL,false)
			end
		elseif player.count() == 2 then
			if(player2:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and pausemenu.pauseactivated == true) then
				--Misc.pause();
				pausemenu.paused = true
				pausemenu.pauseactive = true
				pause_index = 0;
				SFX.play("_OST/_Sound Effects/pausemenu.ogg")
			end
		end
		if cooldown <= 0 then
			player:mem(0x11E,FIELD_BOOL,true)
		end
		if pause_index_char == -1 then
			if player.keys.down == KEYS_PRESSED then
				cycle(1)
			end
			if player.keys.up == KEYS_PRESSED then
				cycle(-1)
			end
		end
		if pause_index_tele == 0 then
			pause_index_tele = pause_index_tele + 1
		end
	end
	lastPauseKey = player.keys.pause;
	
	if(pausemenu.paused and pause_options) then
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
		elseif(player.keys.left == KEYS_PRESSED) then
			player.keys.left = KEYS_UNPRESSED
		elseif(player.keys.right == KEYS_PRESSED) then
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
			elseif(player2.keys.left == KEYS_PRESSED) then
				player2.keys.left = KEYS_UNPRESSED
			elseif(player2.keys.right == KEYS_PRESSED) then
				player2.keys.right = KEYS_UNPRESSED
			elseif(player2.keys.jump == KEYS_PRESSED) then
				pause_options[pause_index+1].action();
				Misc.unpause();
			end
		end
	end
	if(pausemenu.paused_char and pause_options_char) then
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
		elseif(player.keys.left == KEYS_PRESSED) then
			player.keys.left = KEYS_UNPRESSED
		elseif(player.keys.right == KEYS_PRESSED) then
			player.keys.right = KEYS_UNPRESSED
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
			elseif(player2.keys.left == KEYS_PRESSED) then
				player2.keys.left = KEYS_UNPRESSED
			elseif(player2.keys.right == KEYS_PRESSED) then
				player2.keys.right = KEYS_UNPRESSED
			elseif(player2.keys.jump == KEYS_PRESSED) then
				pause_options_char[pause_index_char+1].action();
				Misc.unpause();
			end
		end
	end
	if(pausemenu.paused_tele and pause_options_tele) then
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
		elseif(player.keys.left == KEYS_PRESSED) then
			player.keys.left = KEYS_UNPRESSED
		elseif(player.keys.right == KEYS_PRESSED) then
			player.keys.right = KEYS_UNPRESSED
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
			elseif(player2.keys.left == KEYS_PRESSED) then
				player2.keys.left = KEYS_UNPRESSED
			elseif(player2.keys.right == KEYS_PRESSED) then
				player2.keys.right = KEYS_UNPRESSED
			elseif(player2.keys.jump == KEYS_PRESSED) then
				pause_options_tele[pause_index_tele+1].action();
				Misc.unpause();
			end
		end
	end
end

function pausemenu.onTick()
	if(pausemenu.paused) then
		--Misc.pause();
	end
	if(pausemenu.paused_char) then
		if pause_index_char == 0 then
			pause_index_char = 1
		end
		if pause_options_char == 0 then
			pause_options_char = 1
		end
	end
	if(pausemenu.paused_tele) then
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