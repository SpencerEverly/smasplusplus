local littleDialogue = require("littleDialogue")
local playerManager = require("playerManager")
local inventory = require("customInventory")
local textplus = require("textplus")
local autoscroll = require("autoscroll")
local datetime = require("datetime")
local musicalchairs = require("musicalchairs")
local Routine = require("routine")
local extrasounds = require("extrasounds")

local dying = false;
local deathVisibleCount = 198;
local deathTimer = deathVisibleCount;
local earlyDeathCheck = 3;
local cooldown = 0

local timer_deathTimer;
local deltaTime = Routine.deltaTime
local deathDelay = lunatime.toTicks(1.2)
local deathTimer = deathDelay

local costumes = {}

local dependencies = {}

function dependencies.onInitAPI()
	registerEvent(dependencies, "onStart")
	registerEvent(dependencies, "onLoad")
	registerEvent(dependencies, "onTick")
	registerEvent(dependencies, "onDraw")
	registerEvent(dependencies, "onCameraUpdate")
	registerEvent(dependencies, "onInputUpdate")
end

function dependencies.onStart()
	if SaveData.ut_enabled == nil then
		SaveData.ut_enabled = SaveData.ut_enabled or 0
	end
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if player.character == CHARACTER_NINJABOMBERMAN then
		Defines.player_walkspeed = 6
		Defines.player_runspeed = 6
	end
	
	local costumes
	if SaveData.disableX2char == 0 then
		mm = require("Characters/megaman");
		mm.playIntro = false;
		undertaledepends = require("level_dependencies_undertale")
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

function dependencies.onInputUpdate()
	if SaveData.disableX2char == 1 then
		if player.count() == 1 then
			--Nothing
		end
	end
	if SaveData.disableX2char == 1 then
		if Player.count() == 2 then
			if player.keys.altRun == KEYS_PRESSED then
				if pausemenu13.paused == false then
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
	if SaveData.disableX2char == 1 then
		if Player(2) and Player(2).isValid then
			if Player(2).keys.altRun == KEYS_PRESSED then
				if pausemenu13.paused == false then
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

function dependencies.onTick()
	if player.character == CHARACTER_SNAKE then
		Graphics.activateHud(true)
	end
	if player.character == CHARACTER_NINJABOMBERMAN then
		Graphics.activateHud(true)
	end
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	local costumes
	if Level.filename() == "SMB2 - W-1, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-1, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-1, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-2, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-2, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-2, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-3, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-3, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-3, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-4, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-4, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-4, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-5, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-5, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-5, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-6, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-6, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-6, L-3.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-7, L-1.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() == "SMB2 - W-7, L-2.lvlx" then
		if NPC.config[274].score == 11 then
			SFX.play("ace-coins-5.ogg")
			NPC.config[274].score = 6
		end
	elseif Level.filename() then
		if NPC.config[274].score == 11 then
			NPC.config[274].score = 6 --Nothing plays btw, just resets
		end
	end
end

return dependencies