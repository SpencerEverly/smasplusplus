local smascheats = {}

local starman = require("starman/star")
local megashroom = require("mega/megashroom")
local rng = require("base/rng")

--Some cheats will be disabled until I rework them to make them compatible with my episode. All win NPCs will be remade entirely to be compatible with the episode-specific star system, this is why.

--These cheats are disabled but reedone below to either switch IDs on respective cheats, or just to remake them for some other reason.
Cheats.deregister("fourthwall") --This uses the wrong repl console, we're using repll, with extra sounds!
Cheats.deregister("waitinginthesky") --Changes the starman music and duration. Starman is on the wrong ID for this cheat (This episode uses a different lua script for the starman)
Cheats.deregister("thestarmen") --Grants the starman effect on the wrong ID.
Cheats.deregister("bitemythumb") --Grants a mega mushroom on the wrong ID.
Cheats.deregister("getdemstars") --This would give the wrong star on the wrong ID.
Cheats.deregister("foundmycarkeys") --Instantly grants a keyhole exit. Wanted to put SFXs on it for no reason at all
Cheats.deregister("itsvegas") --This gives a a SMB3 roulette exit on the wrong ID
Cheats.deregister("mylifegoals") --This gives a a SMW goal exit on the wrong ID
Cheats.deregister("mysteryball") --This gives a a SMB3 goal orb on the wrong ID
Cheats.deregister("redigitiscool") --This will be deregistered because I'm going to use this for an misc easter egg.
Cheats.deregister("framerate") --This will be deregistered because I use a SaveData variable instead.
Cheats.deregister("supermario2") --This will be deregistered because we're gonna remake this for customCamera target detection
Cheats.deregister("supermario4") --This will be deregistered because we're gonna remake this for customCamera target detection
Cheats.deregister("supermario8") --This will be deregistered because we're gonna remake this for customCamera target detection
Cheats.deregister("supermario16") --This will be deregistered because we're gonna remake this for customCamera target detection
Cheats.deregister("supermario32") --This will be deregistered because we're gonna remake this for customCamera target detection
Cheats.deregister("supermario64") --This will be deregistered because we're gonna remake this for customCamera target detection
Cheats.deregister("supermario128") --This will be deregistered because we're gonna remake this for customCamera target detection
Cheats.deregister("1player") --This will be deregistered because we're gonna remake this for customCamera target detection
Cheats.deregister("2player") --This will be deregistered because we're gonna remake this for customCamera target detection
Cheats.deregister("moneytree") --This will be deregistered because I'm going to remake this since the coin system was remade

function smascheats.onInitAPI()
    registerEvent(smascheats,"onDraw")
    registerEvent(smascheats,"onTick")
end

smascheats.moneytreeActive = false

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
        Playur.execute(-1, function(plr) plr:kill() end)
        return true -- this makes the cheat not toggleable
    end),
    flashPlayer = true,
})

if not SaveData.disableX2char then
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

if not SaveData.disableX2char then --Same as above
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

if not SaveData.disableX2char then --Same as above
    Cheats.register("itsamespencer",{
        onActivate = (function()
            Defines.player_hasCheated = false
            player:transform(2, false)
            playerManager.setCostume(CHARACTER_LUIGI, "00-SpencerEverly")
            return true -- this makes the cheat not toggleable
        end),
        flashPlayer = true,activateSFX = 12,
    })
end

if not SaveData.disableX2char then
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

if not SaveData.disableX2char then
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

if not SaveData.disableX2char then
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

if not SaveData.disableX2char then
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

if not SaveData.disableX2char then
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

if not SaveData.disableX2char then
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

if not SaveData.disableX2char then
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

if not SaveData.disableX2char then
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
        Sound.changeMusic("_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg", -1)
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
        Sound.playSFX("input_success.ogg")
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
        Sound.playSFX("input_success.ogg")
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
            Sound.playSFX("cheats/waitinginthesky_activated")
            starman.sfxFile = Misc.resolveSoundFile("waitinginthesky")
            starman.duration[994] = lunatime.toTicks(30.5);
            starman.duration[996] = lunatime.toTicks(30.5);
        else
            Sound.playSFX("cheats/waitinginthesky_deactivated")
            starman.sfxFile = Misc.resolveSoundFile("starman.ogg")
            starman.duration[994] = lunatime.toTicks(NPC.config[id].duration)
            starman.duration[996] = lunatime.toTicks(NPC.config[id].duration)
        end
    end),
    flashPlayer = true,activateSFX = nil,
})

Cheats.register("foundmycarkeys",{ --This needs to be reregistered because I wanted to add SFXs to it
    onActivate = (function()
        Defines.player_hasCheated = false
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
                Sound.playSFX("cheats/foundmycarkeys_keyholenotfound")
                break;
            end
        end
        
        if toTeleportData.section then
            Sound.playSFX("cheats/foundmycarkeys_activate")
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
        Defines.player_hasCheated = false
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

Cheats.register("mylifegoals",{ --This needs to be reregistered because it was using the wrong goal tape ID
    onActivate = (function()
        Defines.player_hasCheated = false
        if(isOverworld) then
            return true;
        end
        local goal = NPC.spawn(984, player.x, player.y, player.section)
        goal.x = player.x + (player.width - goal.width)*0.5;
        goal.y = player.y + (player.height - goal.height)*0.5;
            
        return true;
    end),
    flashPlayer = true,activateSFX = nil,
})

Cheats.register("mysteryball",{ --This needs to be reregistered because it was using the wrong ?-Sphere ID
    onActivate = (function()
        Defines.player_hasCheated = false
        if(isOverworld) then
            return true;
        end
        local goal = NPC.spawn(982, player.x, player.y, player.section)
        goal.x = player.x + (player.width - goal.width)*0.5;
        goal.y = player.y + (player.height - goal.height)*0.5;
        
        return true;
    end),
    flashPlayer = true,activateSFX = nil,
})

Cheats.register("mylifeorbs",{ --This one uses the SMW goal orb, instead of the goal tape!
    onActivate = (function()
        Defines.player_hasCheated = false
        if(isOverworld) then
            return true;
        end
        local goal = NPC.spawn(983, player.x, player.y, player.section)
        goal.x = player.x + (player.width - goal.width)*0.5;
        goal.y = player.y + (player.height - goal.height)*0.5;
            
        return true;
    end),
    flashPlayer = true,activateSFX = nil,
})

Cheats.register("framerate",{ --This needs to be reregistered because it uses a SaveData variable instead
    onActivate = (function()
        Defines.player_hasCheated = false
        SaveData.framerateEnabled = not SaveData.framerateEnabled
    end),
    flashPlayer = true,activateSFX = nil,
})

Cheats.register("supermario2",{ --Remaking this, for no reason at all...
    onActivate = (function()
        if SaveData.disableX2char then
            Defines.player_hasCheated = false
            Playur.toggleSingleCoOp(true)
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        else
            Sound.playSFX(152)
        end
        return true -- this makes the cheat not toggleable
    end),
    onDeactivate = (function()
        Defines.player_hasCheated = false
        Playur.setCount(1)
        Playur.toggleSingleCoOp(false)
        local rngbomb = rng.randomEntry({69,71})
        Effect.spawn(rngbomb, player.x, player.y, player.section)
    end),
    flashPlayer = true,activateSFX = nil,
})

if SaveData.disableX2char then
    Cheats.register("supermario4",{ --Remaking this, for no reason at all...
        onActivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(4)
            if Player.count() >= 2 then
                for i = 1,4 do
                    Player(i).x = player.x - player.width * 0.5
                    Player(i).y = player.y - 10
                    Player(i).character = player.character
                    Player(i).speedY = rng.randomInt() * 24 - 12
                    player.speedX = 3
                    if Player(i).powerup == 0 then
                        Player(i).powerup = player.powerup
                    end
                end
            end
            smasbooleans.introModeActivated = false
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        onDeactivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(1)
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        flashPlayer = true,activateSFX = nil,
    })

    Cheats.register("supermario8",{ --Remaking this, for no reason at all...
        onActivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(8)
            if Player.count() >= 2 then
                for i = 1,8 do
                    Player(i).x = player.x - player.width * 0.5
                    Player(i).y = player.y - 10
                    Player(i).character = player.character
                    Player(i).speedY = rng.randomInt() * 24 - 12
                    player.speedX = 3
                    if Player(i).powerup == 0 then
                        Player(i).powerup = player.powerup
                    end
                end
            end
            smasbooleans.introModeActivated = false
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        onDeactivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(1)
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        flashPlayer = true,activateSFX = nil,
    })

    Cheats.register("supermario16",{ --Remaking this, for no reason at all...
        onActivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(16)
            if Player.count() >= 2 then
                for i = 1,16 do
                    Player(i).x = player.x - player.width * 0.5
                    Player(i).y = player.y - 10
                    Player(i).character = player.character
                    Player(i).speedY = rng.randomInt() * 24 - 12
                    player.speedX = 3
                    if Player(i).powerup == 0 then
                        Player(i).powerup = player.powerup
                    end
                end
            end
            smasbooleans.introModeActivated = false
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        onDeactivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(1)
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        flashPlayer = true,activateSFX = nil,
    })

    Cheats.register("supermario32",{ --Remaking this, for no reason at all...
        onActivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(32)
            if Player.count() >= 2 then
                for i = 1,32 do
                    Player(i).x = player.x - player.width * 0.5
                    Player(i).y = player.y - 10
                    Player(i).character = player.character
                    Player(i).speedY = rng.randomInt() * 24 - 12
                    player.speedX = 3
                    if Player(i).powerup == 0 then
                        Player(i).powerup = player.powerup
                    end
                end
            end
            smasbooleans.introModeActivated = false
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        onDeactivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(1)
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        flashPlayer = true,activateSFX = nil,
    })

    Cheats.register("supermario64",{ --Remaking this, for no reason at all...
        onActivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(64)
            if Player.count() >= 2 then
                for i = 1,64 do
                    Player(i).x = player.x - player.width * 0.5
                    Player(i).y = player.y - 10
                    Player(i).character = player.character
                    Player(i).speedY = rng.randomInt() * 24 - 12
                    player.speedX = 3
                    if Player(i).powerup == 0 then
                        Player(i).powerup = player.powerup
                    end
                end
            end
            smasbooleans.introModeActivated = false
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        onDeactivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(1)
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        flashPlayer = true,activateSFX = nil,
    })

    Cheats.register("supermario128",{ --Remaking this, for no reason at all...
        onActivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(128)
            if Player.count() >= 2 then
                for i = 1,128 do
                    Player(i).x = player.x - player.width * 0.5
                    Player(i).y = player.y - 10
                    Player(i).character = player.character
                    Player(i).speedY = rng.randomInt() * 24 - 12
                    player.speedX = 3
                    if Player(i).powerup == 0 then
                        Player(i).powerup = player.powerup
                    end
                end
            end
            smasbooleans.introModeActivated = false
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        onDeactivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(1)
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        flashPlayer = true,activateSFX = nil,
    })

    --[[Cheats.register("supermario200",{ --New cheat to comply with the supermario fad lol (This would crash when a player above 128 touches a moving block, don't use)
        onActivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(200)
            if Player.count() >= 2 then
                for i = 1,200 do
                    Player(i).x = player.x - player.width * 0.5
                    Player(i).y = player.y - 10
                    Player(i).character = player.character
                    Player(i).speedY = rng.randomInt() * 24 - 12
                    player.speedX = 3
                    if Player(i).powerup == 0 then
                        Player(i).powerup = player.powerup
                    end
                end
            end
            smasbooleans.introModeActivated = false
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        onDeactivate = (function()
            Defines.player_hasCheated = false
            Playur.setCount(1)
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end),
        flashPlayer = true,activateSFX = nil,
    })]]
end

local iscoolstrings = {
    "redigitiscool",
    "spencereverlyiscool",
}

for i = 1,2 do
    Cheats.register(iscoolstrings[i],{ --A message box pops up, referencing 38A's password screen, but will have a hint on guessing the password below it. When guessed correctly, you will enter to the very first SpencerlyEverly video of the level that was shown on Levels of NSMBDS, Level Editor! After clearing, you'll be taken back to where you were before.
        onActivate = (function()
            Defines.player_hasCheated = false
            Routine.run(easteregggoodnessyeah)
        end),
        flashPlayer = true,activateSFX = 69,
    })
end

Cheats.register("moneytree",{ --This will be reregistered because the coin system was remade and needs to be redone here
    onActivate = (function()
        Defines.player_hasCheated = false
        smascheats.moneytreeActive = true
        Sound.playSFX(6)
    end),
    onDeactivate = (function()
        Defines.player_hasCheated = false
        smascheats.moneytreeActive = false
        Sound.playSFX(5)
    end),
    flashPlayer = true,activateSFX = nil,
})

function easteregggoodnessyeah()
    Sound.playSFX(92)
    Routine.wait(3, true)
    if Cheats.get("redigitiscool").active == true then
        Cheats.trigger("redigitiscool")
    elseif Cheats.get("spencereverlyiscool").active == true then
        Cheats.trigger("spencereverlyiscool")
    end
    if Level.filename() == "LONSMBDSLE - W-1, L-2.lvlx" then
        Level.load(SaveData.lastLevelPlayed)
    else
        Level.load("LONSMBDSLE - W-1, L-2.lvlx")
    end
end

function smascheats.onDraw()
    if Cheats.get("redigitiscool").active == true or Cheats.get("spencereverlyiscool").active == true then
        Misc.cheatBuffer("")
        for _,p in ipairs(Player.get()) do
            p.forcedState = FORCEDSTATE_INVISIBLE
        end
    end
end

function smascheats.onTick()
    if Cheats.get("moneytree").active == true then
        Sound.playSFX(14)
        SaveData.totalCoinsClassic = SaveData.totalCoinsClassic + 1
        SaveData.totalcoins = SaveData.totalcoins + 1
    end
end

return smascheats