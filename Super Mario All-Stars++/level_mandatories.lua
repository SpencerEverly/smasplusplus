local smwMap = require("smwMap")
local starman = require("starman/star")
local playerManager = require("playermanager")
local littleDialogue = require("littleDialogue")
local extendedKoopas = require("extendedKoopas")

local steve = require("steve")
playerManager.overrideCharacterLib(CHARACTER_ULTIMATERINKA,require("steve"))

local killed = false
local playerlives = mem(0x00B2C5AC,FIELD_FLOAT)

littleDialogue.registerStyle("infobooth",{
    borderSize = 32,

    openSpeed = 0.025,

    windowingOpeningEffectEnabled = true,
    showTextWhileOpening = true,

    speakerNameOnTop = true,
    speakerNameOffsetY = 24,
})

loadingsoundFile = Misc.resolveSoundFile("_OST/All Stars Menu/Loading Screen.ogg")

function onLoad()
	if not Misc.inEditor() then --If luna errors during testing, this will be useful to not load the audio to prevent the audio from still being played until terminated
		loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
		loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
	end
end

--New pause menu was made, this is to prevent the old pause menu from opening
function onPause(evt)
	evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onStart()
	if not Misc.inEditor() then
		loadingSoundObject:FadeOut(500)
	end
end
	
function onTick()
	Defines.player_hasCheated = false
	
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
	
	local characters = {}
	if (characters[player.character] ~= nil) then
		playerManager.updateCharacterHitbox(player.character)
	end
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/0-SMASPlusPlus-Beta/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "1-SMB1-RETRO" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/1-SMB1-Retro/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/2-SMB1-Recolored/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "3-SMB1-SMAS" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/3-SMB1-SMAS/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "4-SMB2-RETRO" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/4-SMB2-RETRO/starman")
		starman.duration[996] = 577
		starman.duration[994] = 577
	end
	if currentCostume == "5-SMB2-SMAS" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/5-SMB2-SMAS/starman")
		starman.duration[996] = 577
		starman.duration[994] = 577
	end
	if currentCostume == "6-SMB3-RETRO" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/6-SMB3-Retro/starman")
		starman.duration[996] = 705
		starman.duration[994] = 705
	end
	if currentCostume == "9-SMW-Pirate" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/9-SMW-Pirate/starman")
		starman.duration[996] = 2200
		starman.duration[994] = 2200
	end
	if currentCostume == "11-SMA1" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/11-SMA1/starman")
		starman.duration[996] = 577
		starman.duration[994] = 577
	end
	if currentCostume == "12-SMA2" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/12-SMA2/starman")
		starman.duration[996] = 1090
		starman.duration[994] = 1090
	end
	if currentCostume == "13-SMA4" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/13-SMA4/starman")
		starman.duration[996] = 705
		starman.duration[994] = 705
	end
	if currentCostume == "A2XT-DEMO" then
		littleDialogue.characterNames[1] = "Demo"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/A2XT-Demo/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		littleDialogue.characterNames[1] = "JC Foster"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/JCFosterTakesItToTheMoon/starman")
		starman.duration[996] = 1026
		starman.duration[994] = 1026
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		littleDialogue.characterNames[1] = "Eric"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/SP-1-EricCartman/starman")
		starman.duration[996] = 962
		starman.duration[994] = 962
	end
	if currentCostume == "SMG4" then
		littleDialogue.characterNames[1] = "SMG4"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "PRINCESSRESCUE" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/PrincessRescue/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "SMW-MARIO" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/SMW-Mario/starman")
		starman.duration[996] = 1090
		starman.duration[994] = 1090
	end
	if currentCostume == "GA-CAILLOU" then
		littleDialogue.characterNames[1] = "Caillou"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/GA-Caillou/starman")
		starman.duration[996] = 1090
		starman.duration[994] = 1090
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		littleDialogue.characterNames[1] = "Mario"
		starman.sfxFile = Misc.resolveSoundFile("costumes/mario/Z-SMW2-AdultMario/starman")
		starman.duration[996] = 1282
		starman.duration[994] = 1282
	end
	
	
	if currentCostume == "0-SPENCEREVERLY" then
		littleDialogue.characterNames[2] = "Spencer"
		starman.sfxFile = Misc.resolveSoundFile("costumes/luigi/0-SpencerEverly/starman")
		starman.duration[996] = 1282
		starman.duration[994] = 1282
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		littleDialogue.characterNames[2] = "Larry"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "WALUIGI" then
		littleDialogue.characterNames[2] = "Waluigi"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "A2XT-IRIS" then
		littleDialogue.characterNames[2] = "Iris"
		starman.sfxFile = Misc.resolveSoundFile("costumes/luigi/A2XT-Iris/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "UNDERTALE-FRISK" then
		littleDialogue.characterNames[2] = "Frisk"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		littleDialogue.characterNames[2] = "Marigi"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	
	
	if currentCostume == "A2XT-KOOD" then
		littleDialogue.characterNames[3] = "Kood"
		starman.sfxFile = Misc.resolveSoundFile("costumes/peach/A2XT-Kood/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "DAISY" then
		littleDialogue.characterNames[3] = "Daisy"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "KIRBY-SMB3" then
		littleDialogue.characterNames[3] = "Kirby"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "PAULINE" then
		littleDialogue.characterNames[3] = "Pauline"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	
	
	if currentCostume == "SEE-TANGENT" then
		littleDialogue.characterNames[4] = "Tangent"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "SONIC" then
		littleDialogue.characterNames[4] = "Sonic"
		starman.sfxFile = Misc.resolveSoundFile("costumes/toad/Sonic/starman")
		starman.duration[996] = 1282
		starman.duration[994] = 1282
	end
	if currentCostume == "TOADETTE" then
		littleDialogue.characterNames[4] = "Toadette"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "YOSHI-SMB3" then
		littleDialogue.characterNames[4] = "Yoshi"
		starman.sfxFile = Misc.resolveSoundFile("starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "A2XT-RAOCOW" then
		littleDialogue.characterNames[4] = "Raocow"
		starman.sfxFile = Misc.resolveSoundFile("costumes/toad/A2XT-Raocow/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	
	
	
	if currentCostume == "A2XT-SHEATH" then
		littleDialogue.characterNames[5] = "Sheath"
		starman.sfxFile = Misc.resolveSoundFile("costumes/link/A2XT-Sheath/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "SMB3-BANDANA-DEE" then
		littleDialogue.characterNames[5] = "Bandana Dee"
		starman.sfxFile = Misc.resolveSoundFile("costumes/link/A2XT-Sheath/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "NESS" then
		littleDialogue.characterNames[5] = "Ness"
		starman.sfxFile = Misc.resolveSoundFile("costumes/link/A2XT-Sheath/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "TAKESHI" then
		littleDialogue.characterNames[5] = "Takeshi"
		starman.sfxFile = Misc.resolveSoundFile("costumes/link/A2XT-Sheath/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
	end
	if currentCostume == "TAKESHI-SNES" then
		littleDialogue.characterNames[5] = "Takeshi"
		starman.sfxFile = Misc.resolveSoundFile("costumes/link/A2XT-Sheath/starman")
		starman.duration[996] = 769
		starman.duration[994] = 769
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
	if currentCostume == "EXPLODINGTNT" then
		littleDialogue.characterNames[14] = "ExplodingTNT"
	end
	if currentCostume == "GEORGENOTFOUNDYT" then
		littleDialogue.characterNames[14] = "GeorgeNotFound"
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
	
	
	if currentCostume == nil then
		littleDialogue.characterNames[1] = "Mario"
		littleDialogue.characterNames[2] = "Luigi"
		littleDialogue.characterNames[3] = "Peach"
		littleDialogue.characterNames[4] = "Toad"
		littleDialogue.characterNames[5] = "Link"
		littleDialogue.characterNames[14] = "Steve"
		steve.skinSettings.name = "steve"
	end
	
	


	--if playerlives == 0 then
	--	if(not killed and player:mem(0x13E,FIELD_BOOL)) then
	--		killed = true
	--		mem(0x00B2C5AC,FIELD_FLOAT, 0)
	--	end
	--end
end

function onExit()
	if playerlives == 0 and killed == true then
		Level.load("SMAS - Game Over.lvlx", nil, nil)
	end
	GameData.SMAS_activated = true
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