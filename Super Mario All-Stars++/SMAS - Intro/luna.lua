--Copy these, they'll be important for changing music throughout characters anywhere
local section0 = 0
local section1 = 1
local section2 = 2
local section3 = 3
local section4 = 4
local section5 = 5
local section6 = 6
local section7 = 7
local section8 = 8
local section9 = 9
local section10 = 10
local section11 = 11
local section12 = 12
local section13 = 13
local section14 = 14
local section15 = 15
local section16 = 16
local section17 = 17
local section18 = 18
local section19 = 19
local section20 = 20

Graphics.activateHud(false)

local textplus = require("textplus")
local datetime = require("datetime")

function onInitAPI()
	registerEvent("onExitLevel", "onExit");
	registerEvent("onKeyboardPress");
	registerEvent("onInputUpdate");
end

function onStart(p)
	datetime.topright = true
	datetime.bottomright = false
	p = p or player;
	Audio.MusicVolume(80)
end

function onTick()
	player.runKeyPressing = false;
	player.upKeyPressing = false;
	player.altJumpKeyPressing = false;
	player.altRunKeyPressing = false;
	player.dropItemKeyPressing = false;
	player.leftKeyPressing = false;
	--player.rightKeyPressing = false;
	
	--Prevent donthurtme cheat, for obvious reasons
	Defines.cheat_donthurtme = used_donthurtme;
	used_donthurtme = nil;
	Audio.sounds[1].sfx  = Audio.SfxOpen("SMAS - Intro/player-jump.ogg")
	if(not killed and player:mem(0x13E,FIELD_BOOL)) then
		killed = true;
		Level.load()
	end
end

function onDraw()
	Graphics.draw{type = RTYPE_TEXT, x = 55, y = 580, priority = 10, text = "Press down to skip, jump for Game Help"}
	
	Graphics.drawBox{x=5, y=5, width=95, height=20, color=Color.red..0.5, priority=7}
	textplus.print{x=10, y=10, text = "Press pause to quit.", priority=8, color=Color.yellow}
	
	if player.downKeyPressing then
		triggerEvent("Skip Intro")
	end
	if player.jumpKeyPressing then
		Graphics.draw{type = RTYPE_TEXT, x = 220, y = 20, priority = 10, text = "Loading Game Help..."}
		triggerEvent("jumping")
	end
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onEvent(eventName)
	if eventName == "Logo Stage 1 - Head Movement" then
		SFX.play("SMAS - Intro/sounds/head-spin.ogg")
	end
	if eventName == "Logo Stage 2 - Bump" then
		SFX.play("SMAS - Intro/sounds/head-stop.ogg")
	end
	if eventName == "Logo Stage 5 - Words (Fade In 1)" then
		SFX.play("SMAS - Intro/sounds/se-words.ogg")
	end
	if eventName == "Logo Stage 8 - Divison Wordline" then
		SFX.play("SMAS - Intro/sounds/intro-byline.ogg")
	end
	if eventName == "Logo Stage 9 - Fade Out 1" then
		SFX.play("SMAS - Intro/sounds/intro-fadeout.ogg")
	end
	if eventName == "Opening Stage 5 - Lights On" then
		SFX.play("SMAS - Intro/sounds/coin.ogg")
	end
	if eventName == "Opening Stage 7 - Fade Out 1" then
		SFX.play("SMAS - Intro/sounds/opening-end.ogg")
	end
	if eventName == "Opening Stage 10 - End of Intro" then
		Audio.MusicVolume(nil)
	end
	if eventName == "Skip Intro" then
		player.downKeyPressing = false
	end
	if eventName == "WorldMapWarp" then
		Level.exit()
	end
	if eventName == "Skip Intro Execution" then
		Level.exit()
	end
end

function onInputUpdate()
	if player.rawKeys.pause == KEYS_PRESSED then
		Misc.exitEngine()
	end
end

Cheats.deregister("iwannabootbackhome") --We're already home, you dolt
Cheats.deregister("letmeseetheintroagain") --You can see the intro again by starting SMAS++.
Cheats.deregister("bootgamehelp") --Wrong Game Help to boot.
Cheats.deregister("ilikespencereverly") --Like ya too, but wait until you're on an actual level ;)

--The rest will disable most cheats to avoid breaking the intro. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

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
	datetime.topright = false
	datetime.bottomright = true
end