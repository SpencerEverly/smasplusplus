	
local littleDialogue = require("littleDialogue")

local pausemenu = require("pausemenu")

local playerManager = require("playerManager")

local inventory = require("customInventory")

local datetime = require("datetime")

local musicalchairs = require("musicalchairs")

local dying = false;
local deathVisibleCount = 198;
local deathTimer = deathVisibleCount;
local earlyDeathCheck = 3;

local timer_deathTimer;
local deltaTime = Routine.deltaTime
local deathDelay = lunatime.toTicks(1.2)
local deathTimer = deathDelay

local costumes = {}

local nbm = require("Characters/ninjabomberman");
nbm.usesavestate = false;
nbm.deathDelay = deathVisibleCount;
	
local mm = require("Characters/megaman");
mm.playIntro = false;

local dependencies = {}

function dependencies.onInitAPI()
	registerEvent(dependencies, "onStart")
	registerEvent(dependencies, "onTick")
	registerEvent(dependencies, "onDraw")
end

function dependencies.onStart()
	if Misc.inEditor() then
		debugbox = require("debugbox")
	end
	if SaveData.ut_enabled == nil then
		SaveData.ut_enabled = SaveData.ut_enabled or 0
	end
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	local costumes
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
		Player.setCostume(1, nil)
		Player.setCostume(2, nil)
		Player.setCostume(3, nil)
		Player.setCostume(4, nil)
		Player.setCostume(5, nil)
	end
	if character == "CHARACTER_LUIGI" then
		if currentCostume == "UNDERTALE-FRISK" then
			if SaveData.ut_enabled == 0 then
				SaveData.ut_enabled = SaveData.ut_enabled + 1
			end
			level_dependencies_undertale = require("level_dependencies_undertale")
		end
		if currentCostume == "WALUIGI" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "MODERN" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "LARRYTHECUCUMBER" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "A2XT-IRIS" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "17-NSMBDS-SMBX" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "16-SMA4" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "15-SMA2" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "13-SMBDX" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "10-SMW-ORIGINAL" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "9-SMB3-MARIOCLOTHES" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "7-SMB3-RETRO" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "6-SMB2-SMAS" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "5-SMB2-RETRO" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "4-SMB1-SMAS" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "3-SMB1-RETRO-MODERN" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "2-SMB1-RECOLORED" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "1-SMB1-RETRO" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
		if currentCostume == "0-SPENCEREVERLY" then
			if SaveData.ut_enabled == 1 then
				SaveData.ut_enabled = SaveData.ut_enabled - 1
			end
		end
	end
	
end

function dependencies.onTick()
	if player.character == CHARACTER_NINJABOMBERMAN then
		Graphics.activateHud(true)
	end
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	local costumes
	if currentCostume == nil then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/1-SMB1-Retro/door-close.ogg")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/2-SMB1-Recolored/door-close.ogg")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/3-SMB1-SMAS/door-close.ogg")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/4-SMB2-Retro/door-close.ogg")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/5-SMB2-SMAS/door-close.ogg")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/6-SMB3-Retro/door-close.ogg")
		end
	end
	if currentCostume == "9-SMW-PIRATE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("nothing.ogg")
		end
	end
	if currentCostume == "11-SMA1" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "13-SMA4" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "GA-CAILLOU" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/PrincessRescue/door-close.ogg")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "SMG4" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/Z-SMW2-AdultMario/door-close.ogg")
		end
	end
	
	
	if currentCostume == "0-SPENCEREVERLY" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "WALUIGI" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/luigi/LarryTheCucumber/door-close.ogg")
		end
	end
	if currentCostume == "A2XT-IRIS" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "UNDERTALE-FRISK" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/luigi/Undertale-Frisk/door-close.ogg")
		end
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	
	
	if currentCostume == "A2XT-KOOD" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "DAISY" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "KIRBY-SMB3" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "PAULINE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	
	
	if currentCostume == "SEE-TANGENT" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "SONIC" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "TOADETTE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "YOSHI-SMB3" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	if currentCostume == "A2XT-RAOCOW" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	
	
	
	if currentCostume == "A2XT-SHEATH" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("costumes/mario/A2XT-Demo/door-close.ogg")
		end
	end
	if currentCostume == "SMB3-BANDANA-DEE" then
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
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
		if SaveData.disableX2char == 0 then
			warpTransition.doorclose = ("door-close.ogg")
		end
	end
	
	
	
	

end

return dependencies