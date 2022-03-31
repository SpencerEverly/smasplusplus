local starman = require("starman/star")
local mega2 = require("mega/megashroom")
local playerManager = require("playermanager")
local littleDialogue = require("littleDialogue")
local extendedKoopas = require("extendedKoopas")
local warpTransition = require("warpTransition")
local customCamera = require("customCamera")
local smallScreen = require("smallScreen")
local steve = require("steve")
local yoshi = require("yiYoshi/yiYoshi")
local HUDOverride = require("hudoverridee")
local textplus = require("textplus")
local repll = require("repll")
local extrasounds = require("extrasounds")
local namehover = require("namehover")

local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

HUDOverride.priority = -4.5
HUDOverride.visible.starcoins = false

local eastercrash = false
local eastercrashdone = false
local eastercrashmsg = false
local eastercrashprevload = false
local blockidx5000check = false

local wideborder = Graphics.loadImageResolved("graphics/resolutionborders/widescreen.png")
local ultrawideborder = Graphics.loadImageResolved("graphics/resolutionborders/ultrawide.png")
local nesborder = Graphics.loadImageResolved("graphics/resolutionborders/nes.png")
local gbborder = Graphics.loadImageResolved("graphics/resolutionborders/gb.png")
local gbaborder = Graphics.loadImageResolved("graphics/resolutionborders/gba.png")
local iphoneoneborder = Graphics.loadImageResolved("graphics/resolutionborders/iphone1st.png")
local threedsborder = Graphics.loadImageResolved("graphics/resolutionborders/3ds.png")

customCamera.transitionSpeed = 5

SaveData._anothercurrency = {SaveData.totalcoins}

if (Level.filename() == "SMAS - Start.lvlx") == true or (Level.filename() == "SMAS - Intro.lvlx") == true or (Level.filename() == "SMAS - Game Over.lvlx") == true or (Level.filename() == "SMAS - Map.lvlx") == true or (Level.filename() == "SMAS - Raca's World (Part 0).lvlx") == true or (Level.filename() == "SMAS - Raca's World (Part 1).lvlx") == true or (Level.filename() == "intro_8bit.lvlx") == true or (Level.filename() == "intro_bossedit8.lvlx") == true  or (Level.filename() == "intro_jakebrito1.lvlx") == true or (Level.filename() == "intro_marioforever.lvlx") == true or (Level.filename() == "intro_S!TS!.lvlx") == true or (Level.filename() == "intro_scrollingheights.lvlx") == true or (Level.filename() == "intro_SMAS.lvlx") == true or (Level.filename() == "intro_SMBX1.0.lvlx") == true or (Level.filename() == "intro_SMBX1.1.lvlx") == true or (Level.filename() == "intro_SMBX1.2.lvlx") == true or (Level.filename() == "intro_SMBX1.3.lvlx") == true or (Level.filename() == "intro_SMBX1.3og.lvlx") == true or (Level.filename() == "intro_SMBX2.lvlx") == true or (Level.filename() == "intro_SMBX2b3.lvlx") == true or (Level.filename() == "intro_sunsetbeach.lvlx") == true or (Level.filename() == "intro_WSMBA.lvlx") == true then
	warpTransition.musicFadeOut = false
	warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
	warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
	warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
	warpTransition.activateOnInstantWarps = false
end

if SaveData.disableX2char == true then
	warpTransition.musicFadeOut = false
	warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
	warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
	warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
	warpTransition.activateOnInstantWarps = false
end

local playerlives = mem(0x00B2C5AC,FIELD_FLOAT)
local killed = false

littleDialogue.registerStyle("smbx13og",{
	textXScale = 1,
	textYScale = 1,
	borderSize = 36,
	textMaxWidth = 500,
	speakerNameGap = 6,
	speakerNameXScale = 1.2,        -- X scale of the speaker's name.
	speakerNameYScale = 1.2,
	
	openSpeed = 5,
	pageScrollSpeed = 5, -- How fast it scrolls when switching pages.
	answerPageScrollSpeed = 5, -- How fast it scrolls when switching answer pages.
	borderSize = 8,
	
	forcedPosEnabled = true,       -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
	forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
	forcedPosY = 150,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
	forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
	forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

	windowingOpeningEffectEnabled = false,

	typewriterEnabled = true,
	typewriterDelayNormal = 0.5, -- The usual delay between each character.
	typewriterDelayLong = 4,  -- The extended delay after any of the special delaying characters, listed below.
	typewriterSoundDelay = 4.1,
	showTextWhileOpening = true,

	closeSoundEnabled = false,
	continueArrowEnabled = false,
	scrollArrowEnabled   = false,
	selectorImageEnabled = true,
	
})

littleDialogue.registerStyle("smbx13",{
	textXScale = 1,
	textYScale = 1,
	borderSize = 36,
	textMaxWidth = 500,
	speakerNameGap = 6,
	speakerNameXScale = 1.2,        -- X scale of the speaker's name.
	speakerNameYScale = 1.2,
	
	openSpeed = 5,
	pageScrollSpeed = 5, -- How fast it scrolls when switching pages.
	answerPageScrollSpeed = 5, -- How fast it scrolls when switching answer pages.
	borderSize = 8,
	
	forcedPosEnabled = true,       -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
	forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
	forcedPosY = 150,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
	forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
	forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

	windowingOpeningEffectEnabled = false,

	typewriterEnabled = false,
	showTextWhileOpening = true,

	closeSoundEnabled = false,
	continueArrowEnabled = false,
	scrollArrowEnabled   = false,
	selectorImageEnabled = true,
	
})

littleDialogue.registerStyle("infobooth",{
	borderSize = 32,

	openSpeed = 0.025,

	windowingOpeningEffectEnabled = true,
	showTextWhileOpening = true,

	speakerNameOnTop = true,
	speakerNameOffsetY = 24,
})

littleDialogue.registerStyle("smwwide",{
	textXScale = 1.4,
	textYScale = 1.4,
	speakerNameXScale = 1.6,
	speakerNameYScale = 1.6,
})

local player2_alt = Player(2)
local pipecounter = 0
local pipecounter2 = 0
local doorcounter = 0
local doorcounter2 = 0
local fadetolevel = false

local ready = false

local globalgenerals = {}

local pipecounter1p = 0
local pipecounter2p = 0

function globalgenerals.onInitAPI()
	registerEvent(globalgenerals,"onExitLevel", "onExit")
	registerEvent(globalgenerals,"onStart")
	registerEvent(globalgenerals,"onTick")
	registerEvent(globalgenerals,"onCameraUpdate")
	registerEvent(globalgenerals,"onInputUpdate")
	registerEvent(globalgenerals,"onEvent")
	registerEvent(globalgenerals,"onDraw")
	registerEvent(globalgenerals,"onEvent")
	registerEvent(globalgenerals,"onPlayerHarm")
	registerEvent(globalgenerals,"onPostNPCKill")
	registerEvent(globalgenerals,"onPause")
	
	local Routine = require("routine")
	
	ready = true
end

function lavashroomeasteregg()
	eastercrashprevload = true
	GameData.cutsceneMusicControl = true
	SFX.play("_OST/_Sound Effects/easteregg_smbx13crash.ogg")
	eastercrashmsg = true
	Routine.wait(2, true)
	GameData.cutsceneMusicControl = false
	Routine.wait(20, true)
	eastercrashmsg = false
	eastercrashdone = true
	eastercrash = false
end

--New pause menu was made, this is to prevent the old pause menu from opening
function globalgenerals.onPause(evt)
	evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function globalgenerals.onStart()
	if Misc.inEditor() then
		debugbox = require("debugbox")
	end
	if SaveData.lastLevelPlayed == nil then
		SaveData.lastLevelPlayed = SaveData.lastLevelPlayed or Level.filename()
	end
	if SaveData.disableX2char == true then
		mega2.sfxFile = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom13.ogg")
		mega2.megagrowsfx = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom-grow-1.3.ogg")
		mega2.megashrinksfx = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom-shrink-1.3.ogg")
		mega2.megarunningoutsfx = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom-runningout-1.3.ogg")
		starman.sfxFile = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/starman.ogg")
		Audio.sounds[1].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-jump.ogg")
		Audio.sounds[2].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/stomped.ogg")
		Audio.sounds[3].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-hit.ogg")
		extrasounds.id4  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/block-smash.ogg"))
		Audio.sounds[5].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-shrink.ogg")
		Audio.sounds[6].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-grow.ogg")
		extrasounds.id7  = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/mushroom.ogg"))
		Audio.sounds[8].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died.ogg")
		Audio.sounds[9].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/shell-hit.ogg")
		Audio.sounds[10].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-slide.ogg")
		Audio.sounds[11].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/item-dropped.ogg")
		Audio.sounds[12].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/has-item.ogg")
		Audio.sounds[13].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/camera-change.ogg")
		extrasounds.id14 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/coin.ogg"))
		extrasounds.id15 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/1up.ogg"))
		Audio.sounds[16].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/lava.ogg")
		Audio.sounds[17].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/warp.ogg")
		extrasounds.id18 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireball.ogg"))
		Audio.sounds[19].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/level-win.ogg")
		Audio.sounds[20].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boss-beat.ogg")
		Audio.sounds[21].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dungeon-win.ogg")
		Audio.sounds[22].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bullet-bill.ogg")
		Audio.sounds[23].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab.ogg")
		Audio.sounds[24].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/spring.ogg")
		Audio.sounds[25].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/hammer.ogg")
		Audio.sounds[29].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/do.ogg")
		Audio.sounds[31].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/key.ogg")
		Audio.sounds[32].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/pswitch.ogg")
		Audio.sounds[33].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/tail.ogg")
		Audio.sounds[34].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/racoon.ogg")
		Audio.sounds[35].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/boot.ogg")
		Audio.sounds[36].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smash.ogg")
		Audio.sounds[37].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/thwomp.ogg")
		Audio.sounds[42].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/npc-fireball.ogg")
		extrasounds.id43 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/fireworks.ogg"))
		Audio.sounds[44].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bowser-killed.ogg")
		Audio.sounds[46].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/door.ogg")
		Audio.sounds[48].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi.ogg")
		Audio.sounds[49].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-hurt.ogg")
		Audio.sounds[50].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-tongue.ogg")
		Audio.sounds[51].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-egg.ogg")
		Audio.sounds[52].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/got-star.ogg")
		Audio.sounds[54].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died2.ogg")
		Audio.sounds[55].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/yoshi-swallow.ogg")
		Audio.sounds[57].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dry-bones.ogg")
		Audio.sounds[58].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-checkpoint.ogg")
		extrasounds.id59 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg"))
		Audio.sounds[61].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-blaarg.ogg")
		Audio.sounds[62].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-bubble.ogg")
		Audio.sounds[63].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-die.ogg")
		Audio.sounds[71].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/climbing.ogg")
		Audio.sounds[72].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/swim.ogg")
		Audio.sounds[73].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab2.ogg")
		Audio.sounds[75].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-throw.ogg")
		Audio.sounds[76].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smb2-hit.ogg")
		Audio.sounds[77].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-stab.ogg")
		Audio.sounds[78].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hurt.ogg")
		Audio.sounds[79].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-heart.ogg")
		Audio.sounds[80].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-died.ogg")
		Audio.sounds[81].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-rupee.ogg")
		Audio.sounds[82].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fire.ogg")
		Audio.sounds[83].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-item.ogg")
		Audio.sounds[84].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-key.ogg")
		Audio.sounds[85].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-shield.ogg")
		Audio.sounds[86].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-dash.ogg")
		Audio.sounds[87].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-fairy.ogg")
		Audio.sounds[88].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-grass.ogg")
		Audio.sounds[89].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-hit.ogg")
		Audio.sounds[90].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/zelda-sword-beam.ogg")
		Audio.sounds[91].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/bubble.ogg")
		extrasounds.id92 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/sprout-vine.ogg")) --Vine sprout
		extrasounds.id93 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/iceball.ogg")) --Iceball
		extrasounds.id94 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/yi_freeze.ogg")) --Freeze enemies
		extrasounds.id95 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/yi_icebreak.ogg")) --Enemy ice breaker
		extrasounds.id96 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/2up.ogg")) --2UP
		extrasounds.id97 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/3up.ogg")) --3UP
		extrasounds.id98 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/5up.ogg")) --5UP
		extrasounds.id99 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #2
		extrasounds.id100 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #3
		extrasounds.id101 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #4
		extrasounds.id102 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")) --Dragon Coin #5
		extrasounds.id103 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/cherry.ogg")) --Cherry
		extrasounds.id104 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/explode.ogg")) --SMB2 Explosion
		extrasounds.id105 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/hammerthrow.ogg")) --Player hammer throw
		extrasounds.id106 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo1.ogg")) --Shell hit 2
		extrasounds.id107 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo2.ogg")) --Shell hit 3
		extrasounds.id108 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo3.ogg")) --Shell hit 4
		extrasounds.id109 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo4.ogg")) --Shell hit 5
		extrasounds.id110 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo5.ogg")) --Shell hit 6
		extrasounds.id111 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo6.ogg")) --Shell hit 7
		extrasounds.id112 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo7.ogg")) --Shell hit 8
		extrasounds.id113 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/combo8.ogg")) --Shell hit 9, basically a shell hit and a 1UP together
	end
end

function globalgenerals.onInputUpdate()
	if Player(2) and Player(2).isValid then
		if Player(1).keys.altRun == KEYS_PRESSED and Player(1).keys.up == KEYS_PRESSED then
			if pausemenu.paused == false then
				Player(1):teleport(Player(2).x + 32, Player(2).y - 32, bottomCenterAligned)
				SFX.play("_OST/_Sound Effects/player-tp-2player.ogg")
				cooldown = 5
				Player(1):mem(0x172,FIELD_BOOL,false)
			end
			if cooldown <= 0 then
				Player(1):mem(0x172,FIELD_BOOL,true)
			end
		end
		if Player(2).keys.altRun == KEYS_PRESSED and Player(2).keys.up == KEYS_PRESSED then
			if pausemenu.paused == false then
				Player(2):teleport(Player(1).x - 32, Player(1).y - 32, bottomCenterAligned)
				SFX.play("_OST/_Sound Effects/player-tp-2player.ogg")
				cooldown = 5
				Player(2):mem(0x172,FIELD_BOOL,false)
			end
			if cooldown <= 0 then
				Player(2):mem(0x172,FIELD_BOOL,true)
			end
		end
	end
end
	
function globalgenerals.onTick()
	if player.character == CHARACTER_SNAKE then
		HUDOverride.visible.keys = true
		HUDOverride.visible.itembox = true
		HUDOverride.visible.bombs = true
		HUDOverride.visible.coins = true
		HUDOverride.visible.stars = true
		HUDOverride.visible.timer = true
		HUDOverride.visible.levelname = true
		HUDOverride.visible.overworldPlayer = true
	end
	if player.character == CHARACTER_NINJABOMBERMAN then
		HUDOverride.visible.keys = true
		HUDOverride.visible.itembox = true
		HUDOverride.visible.bombs = true
		HUDOverride.visible.coins = true
		HUDOverride.visible.stars = true
		HUDOverride.visible.timer = true
		HUDOverride.visible.levelname = true
		HUDOverride.visible.overworldPlayer = true
	end
	if player.character == CHARACTER_UNCLEBROADSWORD then
		HUDOverride.visible.lives = false
	end
	if SaveData.disableX2char == false then
		HUDOverride.visible.lives = false
		HUDOverride.visible.score = false
	end
	if SaveData.disableX2char == true then
		SaveData.thirteenmodelives = mem(0x00B2C5AC,FIELD_FLOAT)
	end
	for k,block in ipairs(Block.get{371,405,30,406,1268,404,420,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487}) do
		if block.idx >= 5000 then --Easter egg block IDX detection, for the epic 1.3 mode crash thingy
			blockidx5000check = true
		end
	end
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if currentCostume == "SMB3-WALUIGI" then
		Player.setCostume(10, nil)
	end
	
	--mem(0x00B25130, FIELD_WORD, 2)
	if playerlives == 0 then
        if(not killed and player:mem(0x13E,FIELD_BOOL)) then
            killed = true
            mem(0x00B2C5AC,FIELD_FLOAT, 1)
        end
	end
	if SaveData.GameOverCount == nil then
        SaveData.GameOverCount = SaveData.GameOverCount or 0
    end
	if SaveData.goombaStomps == nil then
        SaveData.goombaStomps = SaveData.goombaStomps or 0
    end
	if SaveData.koopaStomps == nil then
        SaveData.koopaStomps = SaveData.koopaStomps or 0
    end
	if SaveData.starmansused == nil then
        SaveData.starmansused = SaveData.starmansused or 0
    end
	if SaveData.megamushroomssused == nil then
        SaveData.megamushroomssused = SaveData.megamushroomssused or 0
    end
	if SaveData.starsgrabbed == nil then
        SaveData.starsgrabbed = SaveData.starsgrabbed or 0
    end
	if SaveData.totalcoins == nil then
        SaveData.totalcoins = SaveData.totalcoins or 0
    end
	if SaveData.totalmushrooms == nil then
        SaveData.totalmushrooms = SaveData.totalmushrooms or 0
    end
	if SaveData.totalfireflowers == nil then
        SaveData.totalfireflowers = SaveData.totalfireflowers or 0
    end
	if SaveData.totalleafs == nil then
        SaveData.totalleafs = SaveData.totalleafs or 0
    end
	if SaveData.totaltanookis == nil then
        SaveData.totaltanookis = SaveData.totaltanookis or 0
    end
	if SaveData.totalhammersuits == nil then
        SaveData.totalhammersuits = SaveData.totalhammersuits or 0
    end
	if SaveData.totaliceflowers == nil then
        SaveData.totaliceflowers = SaveData.totaliceflowers or 0
    end
	if SaveData.mandatoryStars == nil then
		SaveData.mandatoryStars = SaveData.mandatoryStars or 0
	end
	--if SaveData.totalmandatoryStars == nil then
		--SaveData.mandatoryStars = SaveData.mandatoryStars or 999 --Value isn't final, until all levels are made
	--end
	
	local characters = {}
	
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	local costumes
	
	if SaveData.disableX2char == true then
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
		Player.setCostume(1, nil)
		Player.setCostume(2, nil)
		Player.setCostume(3, nil)
		Player.setCostume(4, nil)
		Player.setCostume(5, nil)
		HUDOverride.visible.lives = true
	end
	
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if Level.filename() == "SMB2 - W-1, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-1, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-1, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-2, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-2, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-2, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-3, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-3, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-3, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-4, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-4, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-4, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-5, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-5, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-5, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-6, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-6, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-6, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-7, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-7, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
		elseif Level.filename() then
			starman.sfxFile = Misc.resolveSoundFile("costumes/mario/0-SMASPlusPlus-Beta/starman")
		end
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_2012beta.ogg")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		if Level.filename() == "SMB2 - W-1, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-1, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-1, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-2, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-2, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-2, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-3, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-3, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-3, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-4, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-4, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-4, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-5, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-5, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-5, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-6, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-6, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-6, L-3.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-7, L-1.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() == "SMB2 - W-7, L-2.lvlx" then
			starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
		elseif Level.filename() then
			starman.sfxFile = Misc.resolveSoundFile("costumes/mario/1-SMB1-Retro/starman")
		end
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-smb1.ogg")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/2-SMB1-Recolored/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("costumes/mario/1-SMB1-Retro/door-close.ogg")
	end
	if currentCostume == "3-SMB1-SMAS" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/3-SMB1-SMAS/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "4-SMB2-RETRO" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-smb2.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/4-SMB2-RETRO/starman")
		starman.duration[996] = 577
		starman.duration[994] = 577
		warpTransition.doorclose = ("costumes/mario/4-SMB2-Retro/door-close.ogg")
	end
	if currentCostume == "5-SMB2-SMAS" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/5-SMB2-SMAS/starman")
		starman.duration[996] = 577
		starman.duration[994] = 577
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "6-SMB3-RETRO" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-smb3.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/6-SMB3-Retro/starman")
		starman.duration[996] = 705
		starman.duration[994] = 705
		warpTransition.doorclose = ("costumes/mario/6-SMB3-Retro/door-close.ogg")
	end
	if currentCostume == "7-SML2" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_sml2.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman/starman_sml2.ogg")
		starman.duration[996] = 878
		starman.duration[994] = 878
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "9-SMW-PIRATE" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("costumes/mario/9-SMW-Pirate/starman-alt.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/9-SMW-Pirate/starman.ogg")
		starman.duration[996] = 1410
		starman.duration[994] = 1410
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "11-SMA1" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/11-SMA1/starman")
		starman.duration[996] = 577
		starman.duration[994] = 577
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "12-SMA2" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/12-SMA2/starman")
		starman.duration[996] = 1090
		starman.duration[994] = 1090
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "13-SMA4" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/13-SMA4/starman")
		starman.duration[996] = 705
		starman.duration[994] = 705
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/14-NSMBDS-SMBX/starman")
		starman.duration[996] = 641
		starman.duration[994] = 641
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "14-NSMBDS-ORIGINAL" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/14-NSMBDS-Original/starman")
		starman.duration[996] = 641
		starman.duration[994] = 641
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "A2XT-DEMO" then
		littleDialogue.characterNames[1] = "Demo"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/A2XT-Demo/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "DEMO-XMASPILY" then
		littleDialogue.characterNames[1] = "Pily"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/Demo-XmasPily/starman")
		starman.duration[996] = lunatime.toTicks(26.6)
		starman.duration[994] = lunatime.toTicks(26.6)
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		littleDialogue.characterNames[1] = "JC Foster"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/JCFosterTakesItToTheMoon/starman")
		starman.duration[996] = 1026
		starman.duration[994] = 1026
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		littleDialogue.characterNames[1] = "Eric"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_southpark.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/SP-1-EricCartman/starman")
		starman.duration[996] = 962
		starman.duration[994] = 962
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "SMG4" then
		littleDialogue.characterNames[1] = "SMG4"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "PRINCESSRESCUE" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("costumes/mario/PrincessRescue/starman")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/PrincessRescue/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "SMW-MARIO" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/SMW-Mario/starman")
		starman.duration[996] = 1090
		starman.duration[994] = 1090
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "GA-CAILLOU" then
		littleDialogue.characterNames[1] = "Caillou"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_goanimate.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/GA-Caillou/starman")
		starman.duration[996] = 1090
		starman.duration[994] = 1090
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/Z-SMW2-AdultMario/starman")
		starman.duration[996] = 1282
		starman.duration[994] = 1282
		warpTransition.doorclose = ("costumes/mario/Z-SMW2-AdultMario/door-close.ogg")
	end
	
	
	if currentCostume == "0-SPENCEREVERLY" then
		littleDialogue.characterNames[2] = "Spencer"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_smbs.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/luigi/0-SpencerEverly/starman")
		starman.duration[996] = 1282
		starman.duration[994] = 1282
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		littleDialogue.characterNames[2] = "Larry"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("costumes/luigi/LarryTheCucumber/door-close.ogg")
	end
	if currentCostume == "WALUIGI" then
		littleDialogue.characterNames[2] = "Waluigi"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "A2XT-IRIS" then
		littleDialogue.characterNames[2] = "Iris"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/luigi/A2XT-Iris/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "UNDERTALE-FRISK" then
		littleDialogue.characterNames[2] = "Frisk"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_undertale.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman/starman_undertale.ogg")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("costumes/luigi/Undertale-Frisk/door-close.ogg")
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		littleDialogue.characterNames[2] = "Marigi"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	
	
	if currentCostume == "A2XT-KOOD" then
		littleDialogue.characterNames[3] = "Kood"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/peach/A2XT-Kood/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "DAISY" then
		littleDialogue.characterNames[3] = "Daisy"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "KIRBY-SMB3" then
		littleDialogue.characterNames[3] = "Kirby"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "PAULINE" then
		littleDialogue.characterNames[3] = "Pauline"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	
	
	if currentCostume == "SEE-TANGENT" then
		littleDialogue.characterNames[4] = "Tangent"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-nintendogs.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman/starman_nintendogs")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "SONIC" then
		littleDialogue.characterNames[4] = "Sonic"
		mega2.sfxFile = Misc.resolveSoundFile("costumes/toad/Sonic/starman")
		starman.sfxFile = Misc.resolveSoundFile("costumes/toad/Sonic/starman")
		starman.duration[996] = 1282
		starman.duration[994] = 1282
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "TOADETTE" then
		littleDialogue.characterNames[4] = "Toadette"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "YOSHI-SMB3" then
		littleDialogue.characterNames[4] = "Yoshi"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "A2XT-RAOCOW" then
		littleDialogue.characterNames[4] = "Raocow"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/toad/A2XT-Raocow/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	
	
	
	if currentCostume == "A2XT-SHEATH" then
		littleDialogue.characterNames[5] = "Sheath"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/link/A2XT-Sheath/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
	end
	if currentCostume == "SMB3-BANDANA-DEE" then
		littleDialogue.characterNames[5] = "Bandana Dee"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "NESS" then
		littleDialogue.characterNames[5] = "Ness"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_earthbound.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman/starman_earthbound.ogg")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "TAKESHI" then
		littleDialogue.characterNames[5] = "Takeshi"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("costumes/link/Takeshi/door-close.ogg")
	end
	if currentCostume == "SEE-SHERBERTLUSSIEBACK" then
		littleDialogue.characterNames[5] = "Sherbert"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	if currentCostume == "TAKESHI-SNES" then
		littleDialogue.characterNames[5] = "Takeshi"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	
	
	if currentCostume == "SMA3" then
		littleDialogue.characterNames[10] = "Yoshi"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman/starman_sma3.ogg")
		starman.duration[996] = 1474
		starman.duration[994] = 1474
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	
	
	
	if currentCostume == "SMW2-YOSHI" then
		littleDialogue.characterNames[9] = "Yoshi"
	end
	if currentCostume == "YS-GREEN" then
		littleDialogue.characterNames[9] = "Yoshi"
	end
	
	
	if (character == CHARACTER_STEVE) == true then
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("sound/door-close.ogg")
	end
	
	if currentCostume == "DJCTRE-CUBIXTRON" then
		littleDialogue.characterNames[14] = "Cubix Tron"
	end
	if currentCostume == "DJCTRE-CUBIXTRONDAD" then
		littleDialogue.characterNames[14] = "Cubix Tron Dad"
	end
	if currentCostume == "DJCTRE-STULTUS" then
		littleDialogue.characterNames[14] = "Stultus"
	end
	if currentCostume == "DLC-FESTIVE-CHRISTMASTREE" then
		littleDialogue.characterNames[14] = "Christmas Tree"
	end
	if currentCostume == "ED-EDEDDANDEDDY" then
		littleDialogue.characterNames[14] = "Ed"
	end
	if currentCostume == "EXPLODINGTNT" then
		littleDialogue.characterNames[14] = "ExplodingTNT"
	end
	if currentCostume == "GEORGENOTFOUNDYT" then
		littleDialogue.characterNames[14] = "GeorgeNotFound"
	end
	if currentCostume == "HANGOUTYOSHIGUYYT" then
		littleDialogue.characterNames[14] = "Stone"
	end
	if currentCostume == "KARLJACOBSYT" then
		littleDialogue.characterNames[14] = "Karl"
	end
	if currentCostume == "KOOPAPANZER" then
		littleDialogue.characterNames[14] = "Koopapanzer"
	end
	if currentCostume == "MC-ALEX" then
		littleDialogue.characterNames[14] = "Alex"
	end
	if currentCostume == "MC-CAPTAINTOAD" then
		littleDialogue.characterNames[14] = "Captain Toad"
	end
	if currentCostume == "MC-FNF-BOYFRIEND" then
		littleDialogue.characterNames[14] = "Boyfriend"
	end
	if currentCostume == "MC-FNF-GIRLFRIEND" then
		littleDialogue.characterNames[14] = "Girlfriend"
	end
	if currentCostume == "MC-FRISK" then
		littleDialogue.characterNames[14] = "Frisk"
	end
	if currentCostume == "MC-HEROBRINE" then
		littleDialogue.characterNames[14] = "Herobrine"
	end
	if currentCostume == "MC-IMPOSTOR" then
		littleDialogue.characterNames[14] = "Impostor"
	end
	if currentCostume == "MC-ITSHARRY" then
		littleDialogue.characterNames[14] = "Harry"
	end
	if currentCostume == "MC-ITSJERRY" then
		littleDialogue.characterNames[14] = "Jerry"
	end
	if currentCostume == "MC-KERALIS" then
		littleDialogue.characterNames[14] = "Keralis"
	end
	if currentCostume == "MC-KRIS" then
		littleDialogue.characterNames[14] = "Kris"
	end
	if currentCostume == "MC-MARIO" then
		littleDialogue.characterNames[14] = "Mario"
	end
	if currentCostume == "MC-NOELLE-DELTARUNE" then
		littleDialogue.characterNames[14] = "Noelle"
	end
	if currentCostume == "MC-NOTCH" then
		littleDialogue.characterNames[14] = "Notch"
	end
	if currentCostume == "MC-PATRICK" then
		littleDialogue.characterNames[14] = "Patrick"
	end
	if currentCostume == "MC-RALSEI" then
		littleDialogue.characterNames[14] = "Ralsei"
	end
	if currentCostume == "MC-SONIC" then
		littleDialogue.characterNames[14] = "Sonic"
	end
	if currentCostume == "MC-SPIDERMAN" then
		littleDialogue.characterNames[14] = "Spiderman"
	end
	if currentCostume == "MC-SPONGEBOB" then
		littleDialogue.characterNames[14] = "SpongeBob"
	end
	if currentCostume == "MC-SQUIDWARD" then
		littleDialogue.characterNames[14] = "Squidward"
	end
	if currentCostume == "MC-SUSIE-DELTARUNE" then
		littleDialogue.characterNames[14] = "Susie"
	end
	if currentCostume == "MC-TAILS" then
		littleDialogue.characterNames[14] = "Tails"
	end
	if currentCostume == "MC-ZOMBIE" then
		littleDialogue.characterNames[14] = "Zombie"
	end
	if currentCostume == "QUACKITYYT" then
		littleDialogue.characterNames[14] = "Quackity"
	end
	if currentCostume == "SEE-MC-EVILME" then
		littleDialogue.characterNames[14] = "Evil Me"
	end
	if currentCostume == "SEE-MC-GERANIUM" then
		littleDialogue.characterNames[14] = "Geranium"
	end
	if currentCostume == "SEE-MC-LEWBERTLUSSIEBACK" then
		littleDialogue.characterNames[14] = "Lewbert"
	end
	if currentCostume == "SEE-MC-LILIJUCIEBACK" then
		littleDialogue.characterNames[14] = "Lili"
	end
	if currentCostume == "SEE-MC-MIMIJUCIEBACK" then
		littleDialogue.characterNames[14] = "Mimi"
	end
	if currentCostume == "SEE-MC-RONDAVIS" then
		littleDialogue.characterNames[14] = "Ron Davis"
	end
	if currentCostume == "SEE-MC-SHENICLE" then
		littleDialogue.characterNames[14] = "Shenicle"
	end
	if currentCostume == "SEE-MC-SHELLEYKIRK" then
		littleDialogue.characterNames[14] = "Shelley Kirk"
	end
	if currentCostume == "SEE-MC-SHERBERTLUSSIEBACK" then
		littleDialogue.characterNames[14] = "Sherbert"
	end
	if currentCostume == "SEE-MC-SPENCER2" then
		littleDialogue.characterNames[14] = "Spencer 2"
	end
	if currentCostume == "SEE-MC-SPENCEREVERLY" then
		littleDialogue.characterNames[14] = "Spencer"
	end
	if currentCostume == "SEE-MC-TIANELY" then
		littleDialogue.characterNames[14] = "Tianely"
	end
	if currentCostume == "TOMMYINNITYT" then
		littleDialogue.characterNames[14] = "TommyInnit"
	end
	if currentCostume == "UNOFFICIALSTUDIOSYT" then
		littleDialogue.characterNames[14] = "Riley"
	end
	
	
	if currentCostume == nil then
		littleDialogue.characterNames[1] = "Mario"
		littleDialogue.characterNames[2] = "Luigi"
		littleDialogue.characterNames[3] = "Peach"
		littleDialogue.characterNames[4] = "Toad"
		littleDialogue.characterNames[5] = "Link"
		littleDialogue.characterNames[9] = "Klonoa"
		littleDialogue.characterNames[14] = "Steve"
		steve.skinSettings.name = "steve"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
end

function globalgenerals.onPostNPCKill(npc, harmType)
	local goombas = table.map{1,2,27,71,89,242,243,379,392,393,466,467}
	if goombas[npc.id] then
        SaveData.goombaStomps = SaveData.goombaStomps + 1
    end
	local koopas = table.map{4,5,6,7,55,72,73,76,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,161,172,173,174,175,176,177,194,578,920,921}
	if koopas[npc.id] then
        SaveData.koopaStomps = SaveData.koopaStomps + 1
    end
	local starmans = table.map{994,996}
	if starmans[npc.id] then
		SaveData.starmansused = SaveData.starmansused + 1
	end
	if npc.id == 997 then
		SaveData.megamushroomssused = SaveData.megamushroomssused + 1
	end
	local stars = table.map{97,196}
	if stars[npc.id] then
		SaveData.starsgrabbed = SaveData.starsgrabbed + 1
	end
	local coins = table.map{10,33,88,103,258,528}
	if coins[npc.id] then
		SaveData.totalcoins = SaveData.totalcoins + 1
	end
	local mushrooms = table.map{9,184,185,249}
	if mushrooms[npc.id] then
        SaveData.totalmushrooms = SaveData.totalmushrooms + 1
    end
	local fireflowers = table.map{14,182,183}
	if fireflowers[npc.id] then
        SaveData.totalfireflowers = SaveData.totalfireflowers + 1
    end
	if npc.id == 34 then
        SaveData.totalleafs = SaveData.totalleafs + 1
    end
	if npc.id == 169 then
        SaveData.totaltanookis = SaveData.totaltanookis + 1
    end
	if npc.id == 170 then
        SaveData.totalhammersuits = SaveData.totalhammersuits + 1
    end
	if npc.id == 277 or npc.id == 264 then
        SaveData.totaliceflowers = SaveData.totaliceflowers + 1
    end
	local interactable = table.map{9,10,14,31,33,34,35,88,90,92,139,140,141,142,143,144,145,146,147,153,154,155,156,157,169,170,184,185,186,187,188,191,193,249,250,258,274,293,425,462,559,994,996,997}
	if SaveData.disableX2char == true then
		if interactable[npc.id] then
			if blockidx5000check == true then
				if harmType == HARM_TYPE_LAVA then
					eastercrash = true
					if eastercrashprevload == false then
						Routine.run(lavashroomeasteregg)
					end
				end
			end
		end
	end
end

function globalgenerals.onDraw()
	if SaveData.resolution == "fullscreen" then
		customCamera.defaultScreenWidth = 800
		customCamera.defaultScreenHeight = 600
		customCamera.defaultZoom = 1
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		smallScreen.priority = 4
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
	end
	if SaveData.resolution == "widescreen" then
		customCamera.defaultScreenWidth = 800
		customCamera.defaultScreenHeight = 450
		customCamera.defaultZoom = 0.75
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1.33
			smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			if SaveData.letterbox == true then
				Graphics.drawImageWP(wideborder, 0, 0, 5)
			end
		end
	end
	if SaveData.resolution == "ultrawide" then
		customCamera.defaultScreenWidth = 800
		customCamera.defaultScreenHeight = 337
		customCamera.defaultZoom = 0.562
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.scaleX = 1
		smallScreen.scaleY = 1
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1.80
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			if SaveData.letterbox == true then
				Graphics.drawImageWP(ultrawideborder, 0, 0, 5)
			end
		end
	end
	if SaveData.resolution == "nes" then
		customCamera.defaultScreenWidth = 512
		customCamera.defaultScreenHeight = 448
		customCamera.defaultZoom = 0.75
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0.20
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1.56
			smallScreen.scaleY = 1.34
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1.25
			smallScreen.scaleY = 1.08
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(nesborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "gameboy" then
		customCamera.defaultScreenWidth = 320
		customCamera.defaultScreenHeight = 228
		customCamera.defaultZoom = 0.38
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.scaleX = 1
		smallScreen.scaleY = 1
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 2.5
			smallScreen.scaleY = 2.65
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(gbborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "gba" then
		customCamera.defaultScreenWidth = 480
		customCamera.defaultScreenHeight = 320
		customCamera.defaultZoom = 0.54
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1.7
			smallScreen.scaleY = 1.9
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(gbaborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "iphone1st" then
		customCamera.defaultScreenWidth = 400
		customCamera.defaultScreenHeight = 600
		customCamera.defaultZoom = 0.62
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.scaleX = 1
		smallScreen.scaleY = 1
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 3.3
			smallScreen.scaleY = 1.65
			smallScreen.offsetX = 5
			smallScreen.offsetY = -8
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(iphoneoneborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "3ds" then
		customCamera.defaultScreenWidth = 700
		customCamera.defaultScreenHeight = 419
		customCamera.defaultZoom = 0.58
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 70
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.scaleX = 1
		smallScreen.scaleY = 1
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		if SaveData.letterbox == false then
			smallScreen.priority = 10
			smallScreen.scaleX = 1.50
			smallScreen.scaleY = 1.72
			smallScreen.offsetX = 4
			smallScreen.offsetY = -118
		elseif SaveData.letterbox == true then
			smallScreen.priority = 4
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
		end
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(threedsborder, 0, 0, 5)
		end
	end
	if eastercrashmsg then
		textplus.print{x=145, y=80, text = "Congrats! You reached more than the 5000th block idx and burned a ", priority=-3, color=Color.yellow, font=statusFont}
		textplus.print{x=155, y=90, text = "collectable in the lava. This would've crashed SMBX 1.3!", priority=-3, color=Color.yellow, font=statusFont}
		textplus.print{x=195, y=100, text = "You're really good at finding secrets, player ;)", priority=-3, color=Color.yellow, font=statusFont}
	end
end

function globalgenerals.onExit()
	if playerlives == 0 then
		if killed == true then
			Level.load("SMAS - Game Over.lvlx", nil, nil)
		end
	end
	if mem(0x00B2C89C, FIELD_BOOL) then --Let's prevent the credits from execution.
		Level.load("SMAS - Credits.lvlx", nil, nil)
	end
	if (Level.filename() == "MALC - HUB.lvlx") == false or (Level.filename() == "SMAS - Start.lvlx") == false or (Level.filename() == "SMAS - Map.lvlx") == false or (Level.filename() == "intro_"..smasintros..".lvlx") == false or (Level.filename() == "SMAS - Intro.lvlx") == false then
		SaveData.lastLevelPlayed = Level.filename()
	end
end


	
	
	
--Some cheats will break playing this game. Demo 2 will start having these cheats that could break any point of the game disabled. Most things, like the framerate, chracter stuff, most other cheats that won't break the game in normal cases, and until the release, imtiredofallthiswalking, will be kept in. Map codes are in map.lua (Only illparkwhereiwant is disabled)


--First off, the obvious move-to-the-next-level-without-doing-anything stuff:
Cheats.deregister("foundmycarkeys") --Instantly grants a keyhole exit
Cheats.deregister("mylifegoal") --This gives a a SMW goal exit
Cheats.deregister("mysteryball") --This gives a a SMB3 goal orb
Cheats.deregister("itsvegas") --This gives a a SMB3 roulette exit
Cheats.deregister("getdemstars") --This would ruin spoilers if this wasn't disabled


--All of these would break the game, I think. It's there just in case if something happens:
Cheats.deregister("noclip") --Moves the player like a cursor
Cheats.deregister("speeddemon") --This uncaps the framerate... would rather disable it
Cheats.deregister("shadowstar") --Anything involving shadowstar is disabled, to prevent clipping through blocks and breaking the game
Cheats.deregister("holytrinity") --Activates shadowstar, donthurtme, jumpman. This has shadowstar.
Cheats.deregister("theessentials") --Activates sonicstooslow, shadowstar, donthurtme, jumpman. This has shadowstar.
Cheats.deregister("theessenjls") --Activates sonicstooslow, shadowstar, donthurtme, jumpman. Enjl is gonna get mad when he finds out his code is deactivated lmao
Cheats.deregister("fromthedepths") --Jump high when falling into a pit instead of dying. Dying is crucial for certain events, such as the Boot Level.
Cheats.deregister("waitinginthesky") --Changes the starman music and duration. Starman is on the wrong ID for this cheat (This episode uses a different lua script for the starman)
Cheats.deregister("thestarmen") --Grants the starman effect on the wrong ID.
Cheats.deregister("bitemythumb") --Grants a mega mushroom on the wrong ID.


--Here's some cheats specific for the episode:

Cheats.register("fourthwall",{ --This one needs to be reregistered because I'm using a fork of the console, with sounds(TM)
	onActivate = (function()
		Defines.player_hasCheated = false
		local repll = require("repll")
		repll.activeInEpisode = true
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 67,
})

Cheats.register("iwannabootbackhome",{
	onActivate = (function()
		Defines.player_hasCheated = false
		Level.load("SMAS - Start.lvlx", nil, nil)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 12,
})

Cheats.register("letmeseetheintroagain",{
	onActivate = (function()
		Defines.player_hasCheated = false
		Level.load("SMAS - Intro.lvlx", nil, nil)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 12,
})

Cheats.register("bootgamehelp",{
	onActivate = (function()
		Defines.player_hasCheated = false
		Level.load("SMAS - Game Help.lvlx", nil, nil)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 12,
})

Cheats.register("sherbertsmiddlenameistoto",{
	onActivate = (function()
		Defines.player_hasCheated = false
		player:kill()
		if Player.count() == 2 then
			player2:kill()
		end
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,
})

if SaveData.disableX2char == false then
	Cheats.register("huskiesareamazing",{
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(4, false)
			playerManager.setCostume(CHARACTER_TOAD, "SEE-Tangent")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then
	Cheats.register("itsametangent",{
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(4, false)
			playerManager.setCostume(CHARACTER_TOAD, "SEE-Tangent")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then
	Cheats.register("itsametakeshi",{
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(5, false)
			playerManager.setCostume(CHARACTER_LINK, "Takeshi")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then
	Cheats.register("itsamelarry",{
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(2, false)
			playerManager.setCostume(CHARACTER_LUIGI, "LarryTheCucumber")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then
	Cheats.register("itsamepily",{
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(1, false)
			playerManager.setCostume(CHARACTER_MARIO, "Demo-XmasPily")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then
	Cheats.register("itsameeric",{
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(1, false)
			playerManager.setCostume(CHARACTER_MARIO, "SP-1-EricCartman")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then
	Cheats.register("itsamejcfoster",{
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(1, false)
			playerManager.setCostume(CHARACTER_MARIO, "JCFosterTakesItToTheMoon")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then
	Cheats.register("itsamefrisk",{
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(2, false)
			playerManager.setCostume(CHARACTER_LUIGI, "Undertale-Frisk")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

Cheats.register("jario",{
	onActivate = (function()
		Defines.player_hasCheated = false
		spartaremix = require("spartaremix")
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/_Sound Effects/HIT_4.ogg",
})

Cheats.register("fourwallsmas",{
	onActivate = (function()
		Defines.player_hasCheated = false
		debugbox = require("debugbox")
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 67,
})

Cheats.register("ilikespencereverly",{
	onActivate = (function()
		Defines.player_hasCheated = false
		for i = 0,20 do
			Audio.MusicChange(i, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/sts vocals ending correct timing final (smbx2).wav",
})

return globalgenerals