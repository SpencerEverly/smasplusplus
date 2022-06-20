local smascheats = {}

local starman = require("starman/star")
local megashroom = require("mega/megashroom")

--Some cheats will be disabled until I rework them to make them compatible with my episode. All win NPCs will be remade entirely to be compatible with the episode-specific star system, this is why.

--First off, the move-to-the-next-level-without-doing-anything stuff:
Cheats.deregister("mylifegoals") --This gives a a SMW goal exit on the wrong ID
Cheats.deregister("mysteryball") --This gives a a SMB3 goal orb on the wrong ID


--These cheats are disabled but reenabled below to switch IDs on the respective cheats.
Cheats.deregister("waitinginthesky") --Changes the starman music and duration. Starman is on the wrong ID for this cheat (This episode uses a different lua script for the starman)
Cheats.deregister("thestarmen") --Grants the starman effect on the wrong ID.
Cheats.deregister("bitemythumb") --Grants a mega mushroom on the wrong ID.
Cheats.deregister("getdemstars") --This would give the wrong star on the wrong ID.
Cheats.deregister("foundmycarkeys") --Instantly grants a keyhole exit. Wanted to put SFXs on it for no reason at all
Cheats.deregister("itsvegas") --This gives a a SMB3 roulette exit on the wrong ID


--Here's some cheats specific for the episode (Global cheats, other level specific cheats will be under level_Dependencies_normal/hub):




--**Episode-specific cheats**

Cheats.register("iwannabootbackhome",{ --Restarts the game
	onActivate = (function()
		Defines.player_hasCheated = false
		Level.load("SMAS - Start.lvlx", nil, nil)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 12,
})

Cheats.register("letmeseetheintroagain",{ --Boots the SEE Intro
	onActivate = (function()
		Defines.player_hasCheated = false
		Level.load("SMAS - Intro.lvlx", nil, nil)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 12,
})

Cheats.register("bootgamehelp",{ --Boots the Game Help level
	onActivate = (function()
		Defines.player_hasCheated = false
		Level.load("SMAS - Game Help.lvlx", nil, nil)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 12,
})

Cheats.register("sherbertsmiddlenameistoto",{ --Kills all/any player(s) after typing. Bad luck amok!
	onActivate = (function()
		Defines.player_hasCheated = false
		betterPlayer(-1, function(plr) plr:kill() end)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,
})

if SaveData.disableX2char == false then
	Cheats.register("huskiesareamazing",{ --Turns the player into Tangent (Spencer's dog)
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(4, false)
			playerManager.setCostume(CHARACTER_TOAD, "SEE-Tangent")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then --Same as above
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
	Cheats.register("itsametakeshi",{ --Turns the player into Takeshi (NES)
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
	Cheats.register("itsamelarry",{ --Turns the player into Larry the Cucumber
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
	Cheats.register("itsamepily",{ --Turns the player into Pily from A2XT
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
	Cheats.register("itsameeric",{ --Turns the player into Eric Cartman
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
	Cheats.register("itsamejcfoster",{ --Turns the player into JC Foster
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
	Cheats.register("itsamefrisk",{ --Turns the player into Frisk
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(2, false)
			playerManager.setCostume(CHARACTER_LUIGI, "Undertale-Frisk")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then
	Cheats.register("itsamerebeltrooper",{ --Turns the player into the LEGO Star Wars II GBA Rebel Trooper
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(4, false)
			playerManager.setCostume(CHARACTER_TOAD, "LEGOStarWars-RebelTrooper")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

if SaveData.disableX2char == false then
	Cheats.register("hardmode",{ --Turns the player into Mother Brain Rinka (This is actually a Beta 3 Cheat, which was brought back for this one)
		onActivate = (function()
			Defines.player_hasCheated = false
			player:transform(4, false)
			playerManager.setCostume(CHARACTER_TOAD, "MotherBrainRinka")
			return true -- this makes the cheat not toggleable
		end),
		flashPlayer = true,activateSFX = 12,
	})
end

--Cheats.register("jario",{ --Loads/requires the spartaremix library
	--onActivate = (function()
		--Defines.player_hasCheated = false
		--spartaremix = require("spartaremix")
		--return true -- this makes the cheat not toggleable
	--end),
	--flashPlayer = true,activateSFX = "_OST/_Sound Effects/HIT_4.ogg",
--})

Cheats.register("fourwallsmas",{ --Unlocks the debugbox, useful for the editor
	onActivate = (function()
		Defines.player_hasCheated = false
		debugbox = require("debugbox")
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 67,
})

Cheats.register("ilikespencereverly",{ --Turns all music into the future S!TS! new reboot theme song
	onActivate = (function()
		Defines.player_hasCheated = false
		for i = 0,20 do
			Audio.MusicChange(i, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/Spencer Everly/Spencer! The Show!/Theme Song/sts vocals ending correct timing final (smbx2).wav",
})

Cheats.register("fuckthisshitgimmiethetrueending",{ --Teleports to the inside of the True Ending building
	onActivate = (function()
		Defines.player_hasCheated = false
		Level.load("MALC - HUB.lvlx", nil, 15)
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/_Sound Effects/hub_travelactivated.ogg",
})







--**Reregisted Cheats**
Cheats.register("fourthwall",{ --Opens up the new repll console, used using TAB. This one needs to be reregistered though because I'm using a fork of the console, with sounds(TM) and extra features such as log clearing
	onActivate = (function()
		Defines.player_hasCheated = false
		local repll = require("repll")
		repll.activeInEpisode = true
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 67,
})

Cheats.register("getdemstars",{ --This needs to be reregistered because it was using the wrong star ID
	onActivate = (function()
		Defines.player_hasCheated = false
		if(isOverworld) then
			return;
		end
		playSound("input_success.ogg")
		local theNextStar, spawnedBlock;
		Defines.cheat_donthurtme = true;
		Defines.cheat_shadowmario = true;
		
		local stars = {[999]={}, [1000]={}}
		
		for _, v in ipairs(NPC.get({999, 1000}, -1)) do
			if v:mem(0xF0, FIELD_DFLOAT) ~= 1 and not v:mem(0x64, FIELD_BOOL) and not v.friendly then
				table.insert(stars[v.id], v)
			end
		end
		
		if (#stars[1000] >= 1 or #stars[999] >= 1) then
			local star = table.remove(stars[1000], 1) or table.remove(stars[999], 1)
			if tostring(star.layerName) ~= "" then
				Layer.get(tostring(star.layerName)):show(false)
			end
			player:mem(0x15A, FIELD_WORD, star:mem(0x146, FIELD_WORD))
			player.x = star.x
			player.y = star.y
			if (#stars[999] >= 1) then
				mem(0x00B2C59E, FIELD_WORD, 0) --stop ending level
			end
		else
			player.speedX = 0
			player.speedY = 0
			
			local cheat = cheat_getdemstars;
			
			player:mem(0x15A, FIELD_WORD, cheat.start.section)
			player.x = cheat.start.x;
			player.y = cheat.start.y;
			
			Defines.cheat_donthurtme = cheat.start.donthurtme;
			Defines.cheat_shadowmario = cheat.start.shadowstar;
		end
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/_Sound Effects/hub_travelactivated.ogg",
})

Cheats.register("itsvegas",{ --This needs to be reregistered because it was using the wrong roulette ID
	onActivate = (function()
		Defines.player_hasCheated = false
		if(isOverworld) then
			return true;
		end
		playSound("input_success.ogg")
		local goal = NPC.spawn(985, player.x, player.y, player.section)
		goal.x = player.x + (player.width - goal.width)*0.5;
		goal.y = player.y + (player.height - goal.height)*0.5;
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/_Sound Effects/hub_travelactivated.ogg",
})

Cheats.register("thestarmen",{ --This needs to be reregistered because it was using the wrong star ID
	onActivate = (function()
		Defines.player_hasCheated = false
		if(starman) then
			starman.start(player)
		end
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/_Sound Effects/hub_travelactivated.ogg",
})

Cheats.register("bitemythumb",{ --This needs to be reregistered because it was using the wrong megashroom ID
	onActivate = (function()
		Defines.player_hasCheated = false
		if(megashroom) then
			if(not player.isMega) then
				megashroom.StartMega(player);
			else
				megashroom.StopMega(player, true);
			end
		end
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/_Sound Effects/hub_travelactivated.ogg",
})

Cheats.register("waitinginthesky",{ --This needs to be reregistered because it was using the wrong star ID
	onActivate = (function()
		Defines.player_hasCheated = false
		if(starman) then
			playSound("cheats/waitinginthesky_activated")
			starman.sfxFile = Misc.resolveSoundFile("waitinginthesky")
			starman.duration[994] = lunatime.toTicks(30.5);
			starman.duration[996] = lunatime.toTicks(30.5);
		else
			playSound("cheats/waitinginthesky_deactivated")
			starman.sfxFile = Misc.resolveSoundFile("starman.ogg")
			starman.duration[994] = lunatime.toTicks(NPC.config[id].duration)
			starman.duration[996] = lunatime.toTicks(NPC.config[id].duration)
		end
	end),
	flashPlayer = true,activateSFX = nil,
})

Cheats.register("foundmycarkeys",{ --This needs to be reregistered because I wanted to add SFXs to it
	onActivate = (function()
		if(isOverworld) then
			return true;
		end
		local toTeleportData = {}
		for k, v in ipairs(Section.get()) do
			if (not toTeleportData.section) then
				for _,bgo in ipairs(BGO.getIntersecting(v.boundary.left, v.boundary.top, v.boundary.right, v.boundary.bottom)) do
					if (bgo.id == 35) then
						toTeleportData.section = k - 1;
						toTeleportData.x = bgo.x;
						toTeleportData.y = bgo.y;
						break;
					end
				end
			else
				playSound("cheats/foundmycarkeys_keyholenotfound")
				break;
			end
		end
		
		if toTeleportData.section then
			playSound("cheats/foundmycarkeys_activate")
			local npc = NPC.spawn(31, toTeleportData.x, toTeleportData.y, toTeleportData.section)
			player.HeldNPCIndex = npc.idx + 1
			player.x = toTeleportData.x
			player.y = toTeleportData.y
			npc:mem(0x12C, FIELD_WORD, 1)
			player:mem(0x15A, FIELD_WORD, toTeleportData.section)
		end
		
		return true;
	end),
	flashPlayer = true,activateSFX = nil,
})

Cheats.register("itsvegas",{ --This needs to be reregistered because it was using the wrong roulette ID
	onActivate = (function()
		if(isOverworld) then
			return true;
		end
		local goal = NPC.spawn(985, player.x, player.y, player.section)
		goal.x = player.x + (player.width - goal.width)*0.5;
		goal.y = player.y + (player.height - goal.height)*0.5;
		
		return true;
	end),
	flashPlayer = true,activateSFX = nil,
})

return smascheats