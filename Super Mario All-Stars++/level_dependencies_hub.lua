local littleDialogue = require("littleDialogue")

local playerManager = require("playerManager")

local inventory = require("customInventory")

local textplus = require("textplus")

local autoscroll = require("autoscroll")

local datetime = require("datetime")

local Routine = require("routine")

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
	registerEvent(dependencies2, "onCameraUpdate")
end

function dependencies2.onCameraUpdate(c, camIdx)
	if player.count(2) then
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

function dependencies2.onStart()
	if Misc.inEditor() then
		debugbox = require("debugbox")
	end
	if SaveData.disableX2char == 0 then
		pausemenu = require("pausemenu")
		warpTransition = require("warpTransition")
		anotherPowerDownLibrary = require("anotherPowerDownLibrary")
		playerphysicspatch = require("playerphysicspatch")
		kindHurtBlock = require("kindHurtBlock")
		comboSounds = require("comboSounds")
		inventory = require('furyinventory')
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
				warpTransition.doorclose = ("_OST/_Sound Effects/door-close.ogg")
			end
		end
	end
	if SaveData.disableX2char == 1 then
		Cheats.deregister("dressmeup")
		Cheats.deregister("undress")
		Cheats.deregister("laundryday")
		warpTransition = require("warpTransition")
		warpTransition.musicFadeOut = false
		warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
		warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
		warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
		warpTransition.activateOnInstantWarps = false
		pausemenu13 = require("pausemenu13")
		littleDialogue.defaultStyleName = "smbx13og"
		Player.setCostume(1, nil)
		Player.setCostume(2, nil)
		Player.setCostume(3, nil)
		Player.setCostume(4, nil)
		Player.setCostume(5, nil)
		Audio.sounds[1].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-jump.ogg")
		Audio.sounds[2].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/stomped.ogg")
		Audio.sounds[3].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-hit.ogg")
		Audio.sounds[4].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/block-smash.ogg")
		Audio.sounds[5].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-shrink.ogg")
		Audio.sounds[6].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-grow.ogg")
		Audio.sounds[7].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/mushroom.ogg")
		Audio.sounds[8].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-died.ogg")
		Audio.sounds[9].sfx  = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/shell-hit.ogg")
		Audio.sounds[10].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/player-slide.ogg")
		Audio.sounds[11].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/item-dropped.ogg")
		Audio.sounds[12].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/has-item.ogg")
		Audio.sounds[13].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/camera-change.ogg")
		Audio.sounds[14].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/coin.ogg")
		Audio.sounds[15].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/1up.ogg")
		Audio.sounds[16].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/lava.ogg")
		Audio.sounds[17].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/warp.ogg")
		Audio.sounds[18].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/fireball.ogg")
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
		Audio.sounds[43].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/fireworks.ogg")
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
		Audio.sounds[59].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/dragon-coin.ogg")
		Audio.sounds[61].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/smw-blaarg.ogg")
		Audio.sounds[62].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-bubble.ogg")
		Audio.sounds[63].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/wart-die.ogg")
		Audio.sounds[71].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/climbing.ogg")
		Audio.sounds[72].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/swim.ogg")
		Audio.sounds[73].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/grab2.ogg")
		--Audio.sounds[74].sfx = Audio.SfxOpen("_OST/_Sound Effects/1.3Mode/saw.ogg")
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
	end
end

function dependencies2.onTick()
	if player.character == CHARACTER_SNAKE then
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