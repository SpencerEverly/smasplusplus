local littleDialogue = require("littleDialogue")

local thecostume = require("thecostume")

local playerManager = require("playerManager")

local pausemenu = require("pausemenu")

local inventory = require("customInventory")

local textplus = require("textplus")

local costumes = {}

local dying = false;
local deathVisibleCount = 100;
local deathTimer = deathVisibleCount;
local earlyDeathCheck = 3;

local timer_deathTimer;
local deltaTime = Routine.deltaTime

local nbm = require("Characters/ninjabomberman");
nbm.usesavestate = false;
nbm.deathDelay = deathVisibleCount;
	
local mm = require("Characters/megaman");
mm.playIntro = false;

local dependencies2 = {}

function dependencies2.onInitAPI()
	registerEvent(dependencies2, "onStart")
	registerEvent(dependencies2, "onTick")
	registerEvent(dependencies2, "onDraw")
end

function dependencies2.onStart()
	if Misc.inEditor() then
		debugbox = require("debugbox")
	end
	if SaveData.disableX2char == 0 then
		warpTransition = require("warpTransition")
		anotherPowerDownLibrary = require("anotherPowerDownLibrary")
		playerphysicspatch = require("playerphysicspatch")
		kindHurtBlock = require("kindHurtBlock")
		comboSounds = require("comboSounds")
		warpTransition.musicFadeOut = false
		warpTransition.levelStartTransition = warpTransition.TRANSITION_IRIS_OUT
		warpTransition.sameSectionTransition = warpTransition.TRANSITION_PAN
		warpTransition.crossSectionTransition = warpTransition.TRANSITION_FADE
		warpTransition.activateOnInstantWarps = false
		warpTransition.TRANSITION_FADE = 1
		warpTransition.TRANSITION_SWIRL = 1
		warpTransition.TRANSITION_IRIS_OUT = 1
		warpTransition.TRANSITION_PAN = 6
		littleDialogue.defaultStyleName = "smw"
		if currentCostume == nil then
			if SaveData.disableX2char == 0 then
				warpTransition.doorclose = ("door-close.wav")
			end
		end
	end
	if SaveData.disableX2char == 1 then
		littleDialogue.defaultStyleName = "smbx13"
		Audio.sounds[46].sfx = Audio.SfxOpen("door-smbx13.ogg")
	end
end

function dependencies2.onTick()
	if player.character == CHARACTER_NINJABOMBERMAN then
		Graphics.activateHud(true)
	end
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	local costumes
	if currentCostume == "1-SMB1-RETRO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/1-SMB1-Retro/door-close.ogg")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		return
	end
	if currentCostume == "3-SMB1-SMAS" then
		return
	end
	if currentCostume == "4-SMB2-RETRO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/4-SMB2-Retro/door-close.ogg")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		return
	end
	if currentCostume == "6-SMB3-RETRO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/6-SMB3-Retro/door-close.ogg")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		return
	end
	if currentCostume == "A2XT-DEMO" then
		return
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		return
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		return
	end
	if currentCostume == "SMG4" then
		return
	end
	if currentCostume == "PRINCESSRESCUE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/PrincessRescue/door-close.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		return
	end
	if currentCostume == "GA-CAILLOU" then
		return
	end
	
	
	if currentCostume == "0-SPENCEREVERLY" then
		return
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		return
	end
	if currentCostume == "WALUIGI" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/luigi/LarryTheCucumber/door-close.ogg")
		end
	end
	if currentCostume == "A2XT-IRIS" then
		return
	end
	if currentCostume == "UNDERTALE-FRISK" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/luigi/Undertale-Frisk/door-close.ogg")
		end
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		return
	end
	
	
	if currentCostume == "A2XT-KOOD" then
		return
	end
	if currentCostume == "DAISY" then
		return
	end
	if currentCostume == "KIRBY-SMB3" then
		return
	end
	if currentCostume == "PAULINE" then
		return
	end
	
	
	if currentCostume == "SEE-TANGENT" then
		return
	end
	if currentCostume == "SONIC" then
		return
	end
	if currentCostume == "TOADETTE" then
		return
	end
	if currentCostume == "YOSHI-SMB3" then
		return
	end
	if currentCostume == "A2XT-RAOCOW" then
		return
	end
	
	
	
	if currentCostume == "A2XT-SHEATH" then
		return
	end
	if currentCostume == "SMB3-BANDANA-DEE" then
		return
	end
	if currentCostume == "NESS" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/link/Ness/door-close.ogg")
		end
	end
	if currentCostume == "TAKESHI" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/link/Takeshi/door-close.ogg")
		end
	end
	if currentCostume == "TAKESHI-SNES" then
		return
	end
end
	
return dependencies2

--function onStart()
-- If SaveGame.currentHub specified an alternate hub level, set that as the hub level path
--	if (SaveGame.currentHub = "SMAS - Start.lvlx") then
--		mem(0xB25724, FIELD_STRING, SaveGame.currentHub)
--		SaveGame.currentHub = "MALC - HUB.lvlx"
--	end
--end

--function onExit()
-- If SaveGame.currentHub specified an alternate hub level, set that as the hub level path
--	if (SaveGame.currentHub = "MALC - HUB.lvlx") then
--		mem(0xB25724, FIELD_STRING, SaveGame.currentHub)
--		SaveGame.currentHub = "SMAS - Start.lvlx"
--	end
--end