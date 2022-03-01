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
			Routine.run(preboot)
			twoPressedState = true
		end
	end
	if active then
		threePressedState = false
		if k == VK_3 then
			SaveData.clear()
			SaveData.flush()
			Routine.run(preboot)
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
	
	if bootshow then
		Graphics.drawImage(bootimage, 0, 0, 8)
	end
	if active then
		Graphics.drawScreen{color = Color.black, priority = 8}
		textplus.print{x=10, y=10, text = "Super Mario All-Stars++ Temporary Boot Option List", priority=9, color=Color.white}
		textplus.print{x=10, y=32, text = "1) Reset all costumes (Including X2 character costumes)", priority=9, color=Color.white}
		textplus.print{x=10, y=44, text = "2) Reset the main menu theme", priority=9, color=Color.white}
		textplus.print{x=10, y=56, text = "3) Clear/Flush SaveData", priority=9, color=Color.white}
		textplus.print{x=10, y=68, text = "4) Continue booting", priority=9, color=Color.white}
		textplus.print{x=10, y=80, text = "5) Load world map instantly (NOT RECOMMENDED)", priority=9, color=Color.white}
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
	Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end



--The rest will disable most cheats to avoid breaking the pre-boot level. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

Cheats.deregister("iwannabootbackhome") --We're going home, you dolt
Cheats.deregister("letmeseetheintroagain") --You can see the intro again by starting SMAS++.
Cheats.deregister("bootgamehelp") --We can't boot Game Help yet.
Cheats.deregister("ilikespencereverly") --Like ya too, but wait until you're on an actual level ;)
Cheats.deregister("sherbertsmiddlenameistoto") --Bad luck is deactivated here. You're welcome, scaredy cats

Cheats.deregister("getmeouttahere")
Cheats.deregister("hadron")
Cheats.deregister("groundhog")
Cheats.deregister("newleaf")
Cheats.deregister("donthurtme")
Cheats.deregister("wingman")
Cheats.deregister("sonicstooslow")
Cheats.deregister("gottagofast")
Cheats.deregister("ahippinandahoppin")
Cheats.deregister("jumpman")
Cheats.deregister("flamethrower")
Cheats.deregister("moneytree")
Cheats.deregister("captainn")
Cheats.deregister("passerby")
Cheats.deregister("fromthedepths")
Cheats.deregister("rinkamania")
Cheats.deregister("rinkamadness")
Cheats.deregister("iceage")
Cheats.deregister("wariotime")
Cheats.deregister("murder")
Cheats.deregister("redrum")
Cheats.deregister("wetwater")
Cheats.deregister("itsrainingmen")
Cheats.deregister("itsrainingmegan")
Cheats.deregister("andmyaxe")
Cheats.deregister("donttypethis")
Cheats.deregister("boomtheroom")
Cheats.deregister("liveforever")
Cheats.deregister("rosebud")
Cheats.deregister("fairymagic")
Cheats.deregister("launchme")
Cheats.deregister("getdown")
Cheats.deregister("geddan")
Cheats.deregister("horikawaisradicola")
Cheats.deregister("worldpeace")
Cheats.deregister("supermario2")
Cheats.deregister("supermario4")
Cheats.deregister("supermario8")
Cheats.deregister("supermario16")
Cheats.deregister("supermario32")
Cheats.deregister("supermario64")
Cheats.deregister("supermario128")
Cheats.deregister("stophittingme")
Cheats.deregister("suicide")
Cheats.deregister("dressmeup")
Cheats.deregister("undress")
Cheats.deregister("laundryday")
Cheats.deregister("wherearemycarkeys")
Cheats.deregister("boingyboing")
Cheats.deregister("bombsaway")
Cheats.deregister("firemissiles")
Cheats.deregister("powhammer")
Cheats.deregister("hammerinmypants")
Cheats.deregister("rainbowrider")
Cheats.deregister("upandout")
Cheats.deregister("burnthehousedown")
Cheats.deregister("greenegg")
Cheats.deregister("redegg")
Cheats.deregister("blueegg")
Cheats.deregister("yellowegg")
Cheats.deregister("purpleegg")
Cheats.deregister("pinkegg")
Cheats.deregister("coldegg")
Cheats.deregister("blackegg")
Cheats.deregister("needashell")
Cheats.deregister("needaredshell")
Cheats.deregister("needablueshell")
Cheats.deregister("needayellowshell")
Cheats.deregister("needaturnip")
Cheats.deregister("needa1up")
Cheats.deregister("needamoon")
Cheats.deregister("needatanookisuit")
Cheats.deregister("needahammersuit")
Cheats.deregister("needamushroom")
Cheats.deregister("needaflower")
Cheats.deregister("needaniceflower")
Cheats.deregister("needanegg")
Cheats.deregister("needaplant")
Cheats.deregister("needagun")
Cheats.deregister("needaswitch")
Cheats.deregister("needaclock")
Cheats.deregister("needabomb")
Cheats.deregister("needashoe")
Cheats.deregister("needaredshoe")
Cheats.deregister("needablueshoe")

function onExit()
	Audio.MusicVolume(nil)
end