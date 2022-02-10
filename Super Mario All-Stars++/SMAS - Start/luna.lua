local player2_alt = Player(2)

runPressedState = false

local active = false

local cooldown = 0

Graphics.activateHud(false)

local Routine = require("routine")

local middle = 0

local textplus = require("textplus")
local littleDialogue = require("littleDialogue")

local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

local hour = os.date("%H")

local day = os.date("%d")

local month = os.date("%m")

local exacttime = os.date("%X")

local function introselection()
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
end

function onStart()
	if SaveData.introselect == nil then
        SaveData.introselect = SaveData.introselect or 1
    end
	Misc.saveGame()
	Routine.run(introselection)
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onDraw()
	Graphics.drawScreen{x=0, y=0, width=800, height=600, color=Color.black..1, priority=10}
end



--The rest will disable most cheats to avoid breaking the boot level. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

Cheats.deregister("iwannabootbackhome") --We're going home, you dolt
Cheats.deregister("letmeseetheintroagain") --You can see the intro again by starting SMAS++.
Cheats.deregister("bootgamehelp") --We can't boot Game Help yet.
Cheats.deregister("ilikespencereverly") --Like ya too, but wait until you're on an actual level ;)
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