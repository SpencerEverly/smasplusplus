local smwMap = require("smwMap")
local starman = require("starman/star")
local mega2 = require("mega/megashroom")
local playerManager = require("playermanager")
local littleDialogue = require("littleDialogue")
local extendedKoopas = require("extendedKoopas")
local autoscroll = require("autoscroll")
local warpTransition = require("warpTransition")

if (Level.filename() == "SMAS - Start.lvlx") == true or (Level.filename() == "SMAS - Intro.lvlx") == true or (Level.filename() == "SMAS - Game Over.lvlx") == true or (Level.filename() == "SMAS - Map.lvlx") == true or (Level.filename() == "SMAS - Raca's World (Part 0).lvlx") == true or (Level.filename() == "SMAS - Raca's World (Part 1).lvlx") == true then
	warpTransition.musicFadeOut = false
	warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
	warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
	warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
	warpTransition.activateOnInstantWarps = false
end

if SaveData.disableX2char == 1 then
	warpTransition.musicFadeOut = false
	warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
	warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
	warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
	warpTransition.activateOnInstantWarps = false
end

local steve = require("steve")
playerManager.overrideCharacterLib(CHARACTER_ULTIMATERINKA,require("steve"))

local snake = require("snakey")
playerManager.overrideCharacterLib(CHARACTER_SNAKE,require("snakey"))

local playerlives = mem(0x00B2C5AC,FIELD_FLOAT)
local killed = false

local player2_alt = Player(2)
local pipecounter = 0
local pipecounter2 = 0
local doorcounter = 0
local doorcounter2 = 0
local fadetolevel = false

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

local ready = false

local globalgenerals = {}

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
end

function globalgenerals.onCameraUpdate(c, camIdx)
	if Player.count() == 2 then
		if c == 1 then
			camera.renderX, camera.rendery = 0, 0
			camera.width, camera.height = 800, 600
		else
			camera2.renderX  = 800
		end
		local screenType = mem(0x00B25130,FIELD_WORD)

		if camera2.isSplit or screenType == 6 then -- split screen or supermario2 is active
			return camIdx
		elseif screenType == 5 then -- dynamic screen
			if Player(1):mem(0x13C,FIELD_BOOL) then -- player 1 is dead
				return 2
			elseif Player(2):mem(0x13C,FIELD_BOOL) then -- player 2 is dead
				return 1
			else
				return 0
			end
		elseif screenType == 2 or screenType == 3 or screenType == 7 then -- follows all players
			return 0
		else
			return 1
		end
	end
end
	
function globalgenerals.onTick()
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if currentCostume == "SMB3-WALUIGI" then
		Player.setCostume(10, nil)
	end
	
	mem(0x00B25130, FIELD_WORD, 2)
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
	
	if SaveData.disableX2char == 1 then
		warpTransition.doorclose = ("_OST/_Sound Effects/nothing.ogg")
		Player.setCostume(1, nil)
		Player.setCostume(2, nil)
		Player.setCostume(3, nil)
		Player.setCostume(4, nil)
		Player.setCostume(5, nil)
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
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-smb1.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/1-SMB1-Retro/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "14-NSMBDS-ORIGINAL" then
		littleDialogue.characterNames[1] = "Mario"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/14-NSMBDS-Original/starman")
		starman.duration[996] = 641
		starman.duration[994] = 641
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		littleDialogue.characterNames[1] = "Eric"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_southpark.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/SP-1-EricCartman/starman")
		starman.duration[996] = 962
		starman.duration[994] = 962
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "SMG4" then
		littleDialogue.characterNames[1] = "SMG4"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "GA-CAILLOU" then
		littleDialogue.characterNames[1] = "Caillou"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_goanimate.ogg")
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/GA-Caillou/starman")
		starman.duration[996] = 1090
		starman.duration[994] = 1090
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "KIRBY-SMB3" then
		littleDialogue.characterNames[3] = "Kirby"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "PAULINE" then
		littleDialogue.characterNames[3] = "Pauline"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("door-close.ogg")
	end
	
	
	if currentCostume == "SEE-TANGENT" then
		littleDialogue.characterNames[4] = "Tangent"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-nintendogs.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman/starman_nintendogs")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "SONIC" then
		littleDialogue.characterNames[4] = "Sonic"
		mega2.sfxFile = Misc.resolveSoundFile("costumes/toad/Sonic/starman")
		starman.sfxFile = Misc.resolveSoundFile("costumes/toad/Sonic/starman")
		starman.duration[996] = 1282
		starman.duration[994] = 1282
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "TOADETTE" then
		littleDialogue.characterNames[4] = "Toadette"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "YOSHI-SMB3" then
		littleDialogue.characterNames[4] = "Yoshi"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "NESS" then
		littleDialogue.characterNames[5] = "Ness"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_earthbound.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman/starman_earthbound.ogg")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("door-close.ogg")
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
		warpTransition.doorclose = ("door-close.ogg")
	end
	if currentCostume == "TAKESHI-SNES" then
		littleDialogue.characterNames[5] = "Takeshi"
		mega2.sfxFile = Misc.resolveSoundFile("megashroom.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
		warpTransition.doorclose = ("door-close.ogg")
	end
	
	
	if currentCostume == "SMA3" then
		littleDialogue.characterNames[10] = "Yoshi"
		mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
		starman.sfxFile = Misc.resolveSoundFile("starman/starman_sma3.ogg")
		starman.duration[996] = 1474
		starman.duration[994] = 1474
		warpTransition.doorclose = ("door-close.ogg")
	end
	
	
	if character == "CHARACTER_STEVE" then
		warpTransition.doorclose = ("door-close.ogg")
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
Cheats.deregister("thestarmen") --Grants the starman effect.
Cheats.deregister("bitemythumb") --Grants a mega mushroom.
Cheats.deregister("instantswitch") --Activates an automatic P-Switch.


--Here's some cheats specific for the episode:
Cheats.register("iwannabootbackhome",{
	onActivate = (function()
		Level.load("SMAS - Start.lvlx", nil, nil)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 12,
})

Cheats.register("letmeseetheintroagain",{
	onActivate = (function()
		Level.load("SMAS - Intro.lvlx", nil, nil)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 12,
})

Cheats.register("bootgamehelp",{
	onActivate = (function()
		Level.load("SMAS - Game Help.lvlx", nil, nil)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 12,
})

Cheats.register("sherbertsmiddlenameistoto",{
	onActivate = (function()
		player:kill()
		if Player.count() == 2 then
			player2:kill()
		end
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,
})

Cheats.register("ilikespencereverly",{
	onActivate = (function()
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