local debugbox = require("debugbox")
debugbox.bootactive = false

local player2_alt = Player(2)

local active = false
local bootshow = true

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

f8PressedState = false

GameData.weatherset = true

local cooldown = 0

local timer = 128
local flag = true

local blackbg = false

local f8pressed = false

Graphics.activateHud(false)

local Routine = require("routine")
local deltaTime = Routine.deltaTime

local middle = 0

local textplus = require("textplus")
local littleDialogue = require("littleDialogue")

local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

local hour = os.date("%H")

local day = os.date("%d")

local month = os.date("%m")

local exacttime = os.date("%X")

local runPressedState = false

if GameData.menucomplete == nil then
	GameData.menucomplete = false
end

local function preboot()
	if SaveData.introselect == 1 then
		Level.load("intro_SMAS.lvlx", nil, nil)
	end
	if SaveData.introselect == 2 then
		Level.load("intro_SMBX1.0.lvlx", nil, nil)
	end
	if SaveData.introselect == 3 then
		Level.load("intro_SMBX1.1.lvlx", nil, nil)
	end
	if SaveData.introselect == 4 then
		Level.load("intro_SMBX1.2.lvlx", nil, nil)
	end
	if SaveData.introselect == 5 then
		Level.load("intro_SMBX1.3.lvlx", nil, nil)
	end
	if SaveData.introselect == 6 then
		Level.load("intro_WSMBA.lvlx", nil, nil)
	end
	if SaveData.introselect == 7 then
		Level.load("intro_SMBX2.lvlx", nil, nil)
	end
	if SaveData.introselect == 8 then
		Level.load("intro_bossedit8.lvlx", nil, nil)
	end
	if SaveData.introselect == 9 then
		Level.load("intro_SMBX1.3og.lvlx", nil, nil)
	end
	if SaveData.introselect == 10 then
		Level.load("intro_SMBX2b3.lvlx", nil, nil)
	end
	if SaveData.introselect == 11 then
		Level.load("intro_8bit.lvlx", nil, nil)
	end
	if SaveData.introselect == 12 then
		Level.load("intro_S!TS!.lvlx", nil, nil)
	end
	if SaveData.introselect == 13 then
		Level.load("intro_sunsetbeach.lvlx", nil, nil)
	end
	if SaveData.introselect == 14 then
		Level.load("intro_scrollingheights.lvlx", nil, nil)
	end
	if SaveData.introselect == 15 then
		Level.load("intro_jakebrito1.lvlx", nil, nil)
	end
	if SaveData.introselect == 16 then
		Level.load("intro_marioforever.lvlx", nil, nil)
	end
	if SaveData.introselect == 17 then
		Level.load("intro_jakebrito2.lvlx", nil, nil)
	end
end

function onKeyboardPress(k, v)
	if k == VK_F8 then
		f8PressedState = true
		active = true
	end
	if active then
		if k == VK_F8 then
			onePressedState = false
			twoPressedState = false
			threePressedState = false
			fourPressedState = false
		end
	end
	if active then
		onePressedState = false
		if k == VK_1 then
			player.setCostume(1, nil)
			player.setCostume(2, nil)
			player.setCostume(3, nil)
			player.setCostume(4, nil)
			player.setCostume(5, nil)
			player.setCostume(6, nil)
			player.setCostume(7, nil)
			player.setCostume(8, nil)
			player.setCostume(9, nil)
			player.setCostume(10, nil)
			player.setCostume(11, nil)
			player.setCostume(12, nil)
			player.setCostume(13, nil)
			player.setCostume(14, nil)
			player.setCostume(15, nil)
			player.setCostume(16, nil)
			Routine.run(preboot)
			onePressedState = true
		end
	end
	if active then
		twoPressedState = false
		if k == VK_2 then
			SaveData.introselect = 1
			Level.load("intro_SMAS.lvlx", nil, nil)
			twoPressedState = true
		end
	end
	if active then
		threePressedState = false
		if k == VK_3 then
			SaveData.clear()
			SaveData.flush()
			Level.load("intro_SMAS.lvlx", nil, nil)
			threePressedState = true
		end
	end
	if active then
		fourPressedState = false
		if k == VK_4 then
			Routine.run(preboot)
			fourPressedState = true
		end
	end
	if active then
		fivePressedState = false
		if k == VK_5 then
			Level.exit()
			fivePressedState = true
		end
	end
	if not active then
		if k == VK_F8 then
			f8PressedState = true
		end
	end
end

function onDraw()
	local bootimage = Graphics.loadImageResolved("SMAS - Start/bootscreen_final.png")
	local bootimagewide = Graphics.loadImageResolved("SMAS - Start/bootscreen_final_wide.png")
	
	if bootshow then
		Graphics.drawImageWP(bootimage, 0, 0, -2)
	end
	if active then
		Graphics.drawScreen{color = Color.black, priority = -1}
		textplus.print{x=10, y=10, text = "Super Mario All-Stars++ Temporary Boot Option List", priority=0, color=Color.white}
		textplus.print{x=10, y=32, text = "1) Reset all costumes (Including X2 character costumes)", priority=0, color=Color.white}
		textplus.print{x=10, y=44, text = "2) Reset the main menu theme", priority=0, color=Color.white}
		textplus.print{x=10, y=56, text = "3) Clear/Flush SaveData", priority=0, color=Color.white}
		textplus.print{x=10, y=68, text = "4) Continue booting", priority=0, color=Color.white}
		textplus.print{x=10, y=80, text = "5) Load world map instantly (NOT RECOMMENDED)", priority=0, color=Color.white}
	end
end

function onInputUpdate()
	player.upKeyPressing = false;
	player.downKeyPressing = false;
	player.leftKeyPressing = false;
	player.rightKeyPressing = false;
	player.altJumpKeyPressing = false;
	player.runKeyPressing = false;
	player.altRunKeyPressing = false;
	player.dropItemKeyPressing = false;
	player.jumpKeyPressing = false;
	if Player.count() == 2 then --Idk why this is needed here but oh well
		player2.upKeyPressing = false;
		player2.downKeyPressing = false;
		player2.leftKeyPressing = false;
		player2.rightKeyPressing = false;
		player2.altJumpKeyPressing = false;
		player2.runKeyPressing = false;
		player2.altRunKeyPressing = false;
		player2.dropItemKeyPressing = false;
		player2.jumpKeyPressing = false;
	end
end

function onTick()
	timer = timer - 1
	
	if timer <= 0 then
		Routine.run(preboot)
	end
	
	if active then
		timer = timer + 1
	end
end

local playerlives = mem(0x00B2C5AC,FIELD_FLOAT)

function onStart()
	if SaveData.introselect == nil then
        SaveData.introselect = SaveData.introselect or 1
    end
	if SaveData.firstBootCompleted == nil then
        SaveData.firstBootCompleted = SaveData.firstBootCompleted or 0
    end
	if SaveData.utencounter == nil then
		SaveData.utencounter = 0
	end
	if SaveData.utpoiton == nil then
		SaveData.utpoiton = 1
	end 
	if SaveData.uthealfood == nil then
		SaveData.uthealfood = 1
	end
	if SaveData.utxp == nil then
		SaveData.utxp = 0
	end
	if mem(0x00B2C5AC,FIELD_FLOAT,0) then
		mem(0x00B2C5AC,FIELD_FLOAT,3)
	end
	Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end



--The rest of the code will disable cheats to avoid breaking the pre-boot level. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

Cheats.enabled = false

function onExit()
	Audio.MusicVolume(65)
end