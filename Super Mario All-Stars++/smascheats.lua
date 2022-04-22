local smascheats = {}

--Some cheats will break playing this game. I will start having these cheats that could break any point of the game disabled. Most things, like the framerate, character stuff, most other cheats that won't break the game in normal cases, and until the release, imtiredofallthiswalking, will be kept in. Map codes are in map.lua (Only illparkwhereiwant is disabled)

--Some cheats that are disabled are also recoded to fit in with compatibility for the episode, such as getdemstars.

--First off, the obvious move-to-the-next-level-without-doing-anything stuff:
Cheats.deregister("foundmycarkeys") --Instantly grants a keyhole exit
Cheats.deregister("mylifegoal") --This gives a a SMW goal exit
Cheats.deregister("mysteryball") --This gives a a SMB3 goal orb
Cheats.deregister("itsvegas") --This gives a a SMB3 roulette exit
Cheats.deregister("getdemstars") --This would ruin spoilers, though I recoded this to be compatible with the episode (See below)


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

Cheats.register("fourthwall",{ --Opens up the repl console, used using TAB. This one needs to be reregistered though because I'm using a fork of the console, with sounds(TM) and extra features
	onActivate = (function()
		Defines.player_hasCheated = false
		local repll = require("repll")
		repll.activeInEpisode = true
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = 67,
})

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

Cheats.register("sherbertsmiddlenameistoto",{ --Kills the player (And player2 if existing) after typing. Bad luck amok!
	onActivate = (function()
		Defines.player_hasCheated = false
		player:kill()
		if Player(2) and Player(2).isValid then
			Player(2):kill()
		end
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

Cheats.register("jario",{ --Requires the spartaremix library
	onActivate = (function()
		Defines.player_hasCheated = false
		spartaremix = require("spartaremix")
		return true -- this makes the cheat not toggleable
	end),
	flashPlayer = true,activateSFX = "_OST/_Sound Effects/HIT_4.ogg",
})

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

Cheats.register("getdemstars",{ --This needs to be reregistered because it was using the wrong star ID
	onActivate = (function()
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

return smascheats