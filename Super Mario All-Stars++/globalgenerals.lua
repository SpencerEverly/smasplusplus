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

HUDOverride.priority = -4.5
HUDOverride.visible.starcoins = false

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

globalgenerals.showitembox = false

--New pause menu was made, this is to prevent the old pause menu from opening
function globalgenerals.onPause(evt)
	evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function globalgenerals.onStart()
	fadetolevel = false
	if Misc.inEditor() then
		debugbox = require("debugbox")
	end
	if not Misc.inEditor() and (Level.filename() == "SMAS - Start.lvlx") == false then
		loadingSoundObject:FadeOut(500)
	end
	if SaveData.lastLevelPlayed == nil then
		SaveData.lastLevelPlayed = SaveData.lastLevelPlayed or Level.filename()
	end
end

function globalgenerals.onInputUpdate()
	if SaveData.disableX2char == true then
		if player.count() == 1 then
			--Nothing
		end
	end
	if SaveData.disableX2char == true then
		if Player.count() == 2 then
			if player.keys.altRun == KEYS_PRESSED then
				if pausemenu.paused == false then
					player:teleport(player2.x + 32, player2.y - 32, bottomCenterAligned)
					SFX.play("_OST/_Sound Effects/player-tp-2player.ogg")
					cooldown = 5
					player:mem(0x172,FIELD_BOOL,false)
				end
				if cooldown <= 0 then
					player:mem(0x172,FIELD_BOOL,true)
				end
			end
		end
	end
	if SaveData.disableX2char == true then
		if Player(2) and Player(2).isValid then
			if Player(2).keys.altRun == KEYS_PRESSED then
				if pausemenu.paused == false then
					Player(2):teleport(player.x - 32, player.y - 32, bottomCenterAligned)
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
end
	
function globalgenerals.onTick()
	if player.character == CHARACTER_SNAKE then
		HUDOverride.visible.keys = true
		HUDOverride.visible.itembox = true
		HUDOverride.visible.bombs = true
		HUDOverride.visible.coins = true
		HUDOverride.visible.score = true
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
		HUDOverride.visible.score = true
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
		if globalgenerals.showitembox == true then
			HUDOverride.visible.itembox = true
		elseif globalgenerals.showitembox == false then
			HUDOverride.visible.itembox = false
		end
		if player.character == CHARACTER_PEACH or player.character == CHARACTER_TOAD or player.character == CHARACTER_LINK or player.character == CHARACTER_KLONOA or player.character == CHARACTER_ROSALINA or player.character == CHARACTER_UNCLEBROADSWORD or player.character == CHARACTER_SNAKE then
			globalgenerals.showitembox = true
			HUDOverride.visible.itembox = true
		elseif player.character == CHARACTER_MARIO or player.character == CHARACTER_LUIGI or player.character == CHARACTER_MEGAMAN or player.character == CHARACTER_WARIO or player.character == CHARACTER_BOWSER or player.character == CHARACTER_NINJABOMBERMAN or player.character == CHARACTER_NINJABOMBERMAN or player.character == CHARACTER_ULTIMATERINKA or player.character == CHARACTER_SAMUS then
			HUDOverride.visible.itembox = false
		end
	end
	if SaveData.disableX2char == false then --This'll save the lives from 1.3 mode, and will reapply back whenever necessary
		--Nothing happens
	elseif SaveData.disableX2char == true then
		SaveData.thirteenmodelives = mem(0x00B2C5AC,FIELD_FLOAT)
	end
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
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1.33
			smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
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
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1.80
			smallScreen.offsetX = 0
		smallScreen.offsetY = 0
		elseif SaveData.letterbox == true then
			smallScreen.scaleX = 1
			smallScreen.scaleY = 1
			smallScreen.offsetX = 0
			smallScreen.offsetY = 0
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
		smallScreen.scaleX = 1.25
		smallScreen.scaleY = 1.08
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
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
	end
	if SaveData.resolution == "gba" then
		customCamera.defaultScreenWidth = 480
		customCamera.defaultScreenHeight = 320
		customCamera.defaultZoom = 0.54
		customCamera.defaultScreenOffsetX = 0
		customCamera.defaultScreenOffsetY = 0
		customCamera.defaultOffsetX = 0
		customCamera.defaultOffsetY = 0
		smallScreen.scaleX = 1
		smallScreen.scaleY = 1
		smallScreen.offsetX = 0
		smallScreen.offsetY = 0
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
end

function globalgenerals.onDraw()
	if SaveData.resolution == "widescreen" then
		if SaveData.borderEnabled == true then
			if SaveData.letterbox == true then
				Graphics.drawImageWP(wideborder, 0, 0, 5)
			end
		end
	end
	if SaveData.resolution == "ultrawide" then
		if SaveData.borderEnabled == true then
			if SaveData.letterbox == true then
				Graphics.drawImageWP(ultrawideborder, 0, 0, 5)
			end
		end
	end
	if SaveData.resolution == "nes" then
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(nesborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "gameboy" then
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(gbborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "gba" then
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(gbaborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "iphone1st" then
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(iphoneoneborder, 0, 0, 5)
		end
	end
	if SaveData.resolution == "3ds" then
		if SaveData.borderEnabled == true then
			Graphics.drawImageWP(threedsborder, 0, 0, 5)
		end
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
Cheats.deregister("noclip") --Moves the player like a cursor


--All of these would break the game, I think. It's there just in case if something happens:
Cheats.deregister("speeddemon") --This uncaps the framerate... would rather disable it
Cheats.deregister("stickyfingers") --Allows players to grab any NPC. Not every NPC can be grabbed.
Cheats.deregister("nowiknowhowameatballfeels") --Allows Yoshi to eat any NPC. Not everything can be eaten.
Cheats.deregister("shadowstar") --Anything involving shadowstar is disabled, to prevent clipping through blocks and breaking the game
Cheats.deregister("holytrinity") --Activates shadowstar, donthurtme, jumpman. This has shadowstar.
Cheats.deregister("theessentials") --Activates sonicstooslow, shadowstar, donthurtme, jumpman. This has shadowstar.
Cheats.deregister("theessenjls") --Activates sonicstooslow, shadowstar, donthurtme, jumpman. Enjl is gonna get mad when he finds out his code is deactivated lmao
Cheats.deregister("fromthedepths") --Jump high when falling into a pit instead of dying. Dying is crucial for certain events, such as the Boot Level.
Cheats.deregister("waitinginthesky") --Changes the starman music and duration. Starman breaking, probably (This uses a different lua script for the starman)
Cheats.deregister("istillplaywithlegos") --Causes all broken blocks in the level to be restored. To prevent Steve from mining a ton of blocks at one time, this is disabled.
Cheats.deregister("thestarmen") --Grants the starman effect on the wrong ID.
Cheats.deregister("bitemythumb") --Grants a mega mushroom on the wrong ID.
Cheats.deregister("instantswitch") --Activates an automatic P-Switch.


--Here's some cheats specific for the episode:
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
		Audio.MusicChange(0, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(4, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(5, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(6, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(9, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(10, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(14, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(15, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(16, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(17, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(18, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(19, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		Audio.MusicChange(20, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/sts vocals ending correct timing final (smbx2).wav",
})

return globalgenerals