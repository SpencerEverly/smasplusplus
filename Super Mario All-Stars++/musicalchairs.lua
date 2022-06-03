--Theme switching for if you wanna use this system in your episode.


---------MUSIC REPLACING---------

-----Replacing music sections-----

--For music, first add the requring stuffs:

local playerManager = require("playerManager")
local pausemenu = require("pauseplus")

local ready = false

--This is important so that the code will work
local costumes = {}

local musicalchairs = {}

local started = false

--This starts the script as a seperate library
function musicalchairs.onInitAPI()
	registerEvent(musicalchairs, "onStart")
	registerEvent(musicalchairs, "onTick")
	registerEvent(musicalchairs, "onEvent")
	registerEvent(musicalchairs, "onDraw")
	
	ready = true
end

function musdelay()
	for i = 0,20 do
		GameData.levelMusic[i] = Section(i).music
	end
	Routine.wait(0.1, true)
	started = true
end

function musicalchairs.switcher()
	started = false
	Routine.wait(0.1, true)
	for i = 0,20 do
		songname = GameData.levelMusic[i]
		Section(i).music = songname
	end
	started = true
end

function musicalchairs.onStart()
	Routine.run(musdelay)
end

--onTick is for sections that don't change the section music.
function musicalchairs.onTick()
	--section.musicPath is the command that changes sections. You can specify the original music path, and it'll replace it with the new path/to/file.extension.
	
	--If section.musicPath is called to change music on one big lua script. That way, more than a hundred scripts wouldn't be scripted seperately. They are placed on the "currentCostume if" part.
	--Example: if section.musicPath == "_OST/(music folder)/(music-file)(.ogg)" then
	--section.musicPath == "_OST/(music folder)/(music-file)(.ogg)" --Replace the file with this instead
	
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumeIdx = table.ifind(costumes,currentCostume)
	
	if started then
	
	--CHARACTER_MARIO
		for i = 0,20 do
			local section = Section(i)
			
			
			
			
			
			if currentCostume == "0-SMASPLUSPLUS-BETA" then
				--MALC HUB
				if section.musicPath == "_OST/Me and Larry City/Character Switch Room.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg"
				--Super Mario Bros. 1
				elseif section.musicPath == "_OST/Super Mario Bros/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Bonus.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Bonus.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Caves.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/AthleticSMB1.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Album.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BeforeCastleSMB1.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Castle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Castle.ogg"
				elseif section.music == 19 then
					section.music = "_OST/Super Mario All-Stars++ (Beta)/SMBDDX - Last Bowser Battle.ogg"
				elseif section.music == 21 then
					section.music = "_OST/Super Mario All-Stars++ (Beta)/SMBDDX - Bowser Battle.ogg"
				elseif section.music == "_OST/Super Mario Bros/Bowser.spc|0;g=2.5" then
					section.music = "_OST/Super Mario All-Stars++ (Beta)/SMBDDX - Bowser Battle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Desert.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/DesertSMB1.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Star Power (HD).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Water.ogg"
				elseif section.musicPath == "_OST/All Stars Secrets/Lineland.ogg" then
					section.musicPath = "_OST/All Stars Secrets/Lineland.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SnowSMB1.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Race.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/LakituSMB1.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow (Alternative).ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SnowSMB1.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SkiesSMB1.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Ghost House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BowserLandSMB1.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Last Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SMBDDX - Last Bowser Battle.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Bowser (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Final Battle.ogg"
				--Super Mario Bros. Lost Levels
				elseif section.musicPath == "_OST/Super Mario Bros/Airship.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/AirshipSMB1.ogg"
				--Super Mario Bros. 2
				elseif section.musicPath == "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Subcon.ogg"
				elseif section.music == "subspace_music.spc|0;g=2.7;" then
					section.music = "_OST/Super Mario All-Stars++ (Beta)/SubspaceDDP.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/CavesSMB2.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Jar.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/JarSMB2.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BeforeBossSMB2.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BirdoAlt.ogg"
				elseif section.music == 15 then
					section.music = "_OST/Super Mario All-Stars++ (Beta)/BirdoAlt.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground (Beta).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/CavesSMB2Beta.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/The Tree Skies.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/The Tree Skies.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Desert.ogg" then
					section.musicPath = "_OST/Super Mario Bros 2/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Albatrosses.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Albatosses.ogg"
				elseif section.musicPath == "__OST/Mario Forever/Human Lab.spc" then
					section.musicPath = "_OST/Mario Forever/Human Lab.spc"
				elseif section.musicPath == "_OST/Super Metroid/97 Continue.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Metrma.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Dark Zone.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/F-F-Fire.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle.ogg" then
					section.musicPath = "_OST/Super Mario Bros 2/Castle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Item Room).ogg" then
					section.musicPath = "_OST/Super Mario Bros 2/Castle (Item Room).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 2).ogg" then
					section.musicPath = "_OST/Super Mario Bros 2/Castle (Phase 2).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 3).ogg" then
					section.musicPath = "_OST/Super Mario Bros 2/Castle (Phase 3).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/King Wart.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Wart.ogg"
				elseif section.music == 43 then
					section.music = "_OST/Super Mario All-Stars++ (Beta)/Wart.ogg"
				elseif section.musicPath == "_OST/Doki Doki Panic/File Clear.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SubconsSavedSMB2.ogg"
				--Super Mario Bros. 3
				elseif section.musicPath == "_OST/Super Mario Bros 3/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Land.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Bonus Level.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BonusAreaSMB3.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/In The Clouds.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/WarpZoneSMB3.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Toad's House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/PSwitchSMB3-Remastered.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Fortress.spc|0;g=1.6" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Fort.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SMBDDX - Boss.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/King's Chamber.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/King.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Before Airship.spc|0;g=2.2" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BeforeAirshipSMB3.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship.spc" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Airship.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship Boss.spc|0;g=2.6" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/AirshipBossSMB3.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Desert.spc|0;g=3.2" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Land.ogg"
				--Super Mario World
				elseif section.musicPath == "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SMWOverworld.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/CavesSMW.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/secret1.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/ForestSMW.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SMWAthletic.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SMWAthletic.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/YI-_Jazzy!.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/YI-_Jazzy!.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Castle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SMW_Castle-KM.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Boss Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BossSMW.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SMWOverworld.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SMWOverworld.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/WaterSMW.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Underground 2.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Caves.ogg"
				--Super Mario Bros. Spencer
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Overworld.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/OverworldSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Star.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/StarSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Caves.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/CavesSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Athletic.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/AthleticSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Going Underground.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/OverworldSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Tower.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/TowerSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Boss Battle.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BossBattleSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Going Underwater.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/OverworldSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Water.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/WaterSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Forest.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/ForestSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Town.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Town.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Another World.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/AnotherWorldSMBS.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Castle.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/CastleSMBS.ogg"
				end
			end
			
			
			
			
			
			
			
			
			if currentCostume == "1-SMB1-RETRO" then
				if section.musicPath == "_OST/Me and Larry City/Character Switch Room.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg"
				--Super Mario Bros. 1
				elseif section.musicPath == "_OST/Super Mario Bros/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|0;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros/Bonus.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Bonus.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|1;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Album.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|0;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros/Castle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|3;g=1.5"
				elseif section.music == 19 then
					section.music = "_OST/Super Mario Bros (NES)/Final Battle.ogg"
				elseif section.music == 21 then
					section.music = "_OST/Super Mario Bros (NES)/Bowser Battle.ogg"
				elseif section.music == "_OST/Super Mario Bros/Bowser.spc|0;g=2.5" then
					section.music = "_OST/Super Mario Bros (NES)/Bowser Battle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Desert.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|4;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|2;g=1.5"
				elseif section.musicPath == "_OST/All Stars Secrets/Lineland.ogg" then
					section.musicPath = "_OST/All Stars Secrets/Lineland.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Snow.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Race.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Lakitu.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow (Alternative).ogg" then
					section.musicPath = "_OST/Super Mario Bros/Snow.spc|0;g=2.5"
				elseif section.musicPath == "_OST/Super Mario Bros/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Ghost House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Ghost House.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Last Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Final Battle.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Bowser (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Final Battle.ogg"
				--Super Mario Bros. Lost Levels
				elseif section.musicPath == "_OST/Super Mario Bros/Airship.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Airship.ogg"
				--Super Mario Bros. 2
				elseif section.musicPath == "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|0;g=1.5"
				elseif section.music == "subspace_music.spc|0;g=2.7;" then
					section.music = "_OST/Super Mario Bros 2 (NES)/Subspace.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|1;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Jar.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|1;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|3;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Bowser Battle.ogg"
				elseif section.music == 15 then
					section.music = "_OST/Super Mario Bros (NES)/Bowser Battle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground (Beta).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|1;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 2/The Tree Skies.ogg" then
					section.musicPath = "_OST/Super Mario Bros 2/The Tree Skies.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Desert.ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Albatrosses.ogg" then
					section.musicPath = "_OST/Super Mario Bros 2/Albatrosses.ogg"
				elseif section.musicPath == "__OST/Mario Forever/Human Lab.spc" then
					section.musicPath = "_OST/Mario Forever/Human Lab.spc"
				elseif section.musicPath == "_OST/Super Metroid/97 Continue.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Metroid/97 Continue.spc|0;g=2.5"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Dark Zone.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Volcano.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle.ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Volcano.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Item Room).ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Volcano.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 2).ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Volcano.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 3).ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Volcano.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/King Wart.ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Final Battle.ogg"
				elseif section.music == 43 then
					section.music = "_OST/Super Mario Bros (NES)/Final Battle.ogg"
				elseif section.musicPath == "_OST/Doki Doki Panic/File Clear.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|11;g=1.5"
				--Super Mario Bros. 3
				elseif section.musicPath == "_OST/Super Mario Bros 3/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|0;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Bonus Level.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Bonus.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/In The Clouds.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|4;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Toad's House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|4;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Fortress.spc|0;g=1.6" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|3;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Bowser Battle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/King's Chamber.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|1;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Before Airship.spc|0;g=2.2" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/BeforeAirshipSMB3.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship.spc" then
					section.musicPath = "_OST/Super Mario Bros (NES) - OST.nsf|3;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship Boss.spc|0;g=2.6" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Bowser Battle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Desert.spc|0;g=3.2" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Desert.ogg"
				--Super Mario Bros. Spencer
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Overworld.ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Overworld (SMBS).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Star.ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Star (SMBS).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Caves.ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Caves (SMBS).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Athletic.ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Athletic (SMBS).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Going Underground.ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Overworld (SMBS).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Tower.ogg" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Tower (SMBS).ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Boss Battle.ogg" then
					section.musicPath = "_OST/Super Mario Bros Spencer/Boss Battle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Going Underwater.ogg" then
					section.musicPath = "_OST/Super Mario Bros Spencer/Going Underwater.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Water.ogg" then
					section.musicPath = "_OST/Super Mario Bros Spencer/Water.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Forest.ogg" then
					section.musicPath = "_OST/Super Mario Bros Spencer/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Town.ogg" then
					section.musicPath = "_OST/Super Mario Bros Spencer/Town.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Another World.ogg" then
					section.musicPath = "_OST/Super Mario Bros Spencer/Another World.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros Spencer/Castle.ogg" then
					section.musicPath = "_OST/Super Mario Bros Spencer/Castle.ogg"
				end
			end
			
			
			
			
			
			
			
			
			
			if currentCostume == "2-SMB1-RECOLORED" then
				--Don't change
			end
			if currentCostume == "3-SMB1-SMAS" then
				--Don't change
			end
			if currentCostume == "4-SMB2-RETRO" then
				--MALC HUB
				if section.musicPath == "_OST/Me and Larry City/Character Switch Room.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2"
				--Super Mario Bros. 1
				elseif section.musicPath == "_OST/Super Mario Bros/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Bonus.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Album.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Castle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Castle.ogg"
				elseif section.music == 19 then
					section.music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2"
				elseif section.music == 21 then
					section.music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2"
				elseif section.music == "_OST/Super Mario Bros/Bowser.spc|0;g=2.5" then
					section.music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Desert.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Underwater.ogg"
				elseif section.musicPath == "_OST/All Stars Secrets/Lineland.ogg" then
					section.musicPath = "_OST/All Stars Secrets/Lineland.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Snow.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Race.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Lakitu.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow (Alternative).ogg" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Snow.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Ghost House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Airship.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Last Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Bowser (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|10;g=2"
				--Super Mario Bros. Lost Levels
				elseif section.musicPath == "_OST/Super Mario Bros/Airship.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Airship.ogg"
				--Super Mario Bros. 2
				elseif section.musicPath == "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				elseif section.music == "subspace_music.spc|0;g=2.7;" then
					section.music = "_OST/Super Mario Bros 2 (NES)/Subspace.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Jar.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Jar.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Before Boss.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2"
				elseif section.music == 15 then
					section.music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground (Beta).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3;g=1.5"
				elseif section.musicPath == "_OST/Super Mario Bros 2/The Tree Skies.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/The Tree Skies.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Desert.ogg" then
					section.musicPath = "_OST/Super Mario Bros 2/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Albatrosses.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Albatosses.ogg"
				elseif section.musicPath == "__OST/Mario Forever/Human Lab.spc" then
					section.musicPath = "_OST/Mario Forever/Human Lab.spc"
				elseif section.musicPath == "_OST/Super Metroid/97 Continue.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Airship.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Dark Zone.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Airship.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle.ogg" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Castle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Item Room).ogg" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Castle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 2).ogg" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Castle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 3).ogg" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Castle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/King Wart.ogg" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|10;g=2"
				elseif section.music == 43 then
					section.music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|10;g=2"
				elseif section.musicPath == "_OST/Doki Doki Panic/File Clear.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SubconsSavedSMB2.ogg"
				--Super Mario Bros. 3
				elseif section.musicPath == "_OST/Super Mario Bros 3/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Bonus Level.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/In The Clouds.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Sky Land.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Toad's House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/City.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Fortress.spc|0;g=1.6" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Castle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Boss.spc|0;g=2.5" then
					section.music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/King's Chamber.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/City.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Before Airship.spc|0;g=2.2" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Volcano Cave.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship.spc" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Airship.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship Boss.spc|0;g=2.6" then
					section.music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Desert.spc|0;g=3.2" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Desert.ogg"
				--Super Mario World
				elseif section.musicPath == "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Jar.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Castle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Castle.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Boss Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Underwater.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Underground 2.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3;g=1.5"
				end
			end
			if currentCostume == "5-SMB2-SMAS" then
				--Don't change
			end
			if currentCostume == "6-SMB3-RETRO" then
				--MALC HUB
				if section.musicPath == "_OST/Me and Larry City/Character Switch Room.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2"
				--Super Mario Bros. 1
				elseif section.musicPath == "_OST/Super Mario Bros/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Bonus.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Album.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Castle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2"
				elseif section.music == 19 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.music == 21 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.music == "_OST/Super Mario Bros/Bowser.spc|0;g=2.5" then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Desert.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|13;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|10;g=2"
				elseif section.musicPath == "_OST/All Stars Secrets/Lineland.ogg" then
					section.musicPath = "_OST/All Stars Secrets/Lineland.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Snow.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Race.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Lakitu.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow (Alternative).ogg" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Snow.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Ghost House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|20;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Last Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Bowser (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2"
				--Super Mario Bros. Lost Levels
				elseif section.musicPath == "_OST/Super Mario Bros/Airship.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|20;g=2"
				--Super Mario Bros. 2
				elseif section.musicPath == "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
				elseif section.music == "subspace_music.spc|0;g=2.7;" then
					section.music = "_OST/Super Mario Bros 2 (NES)/Subspace.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Jar.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Before Boss.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.music == 15 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground (Beta).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/The Tree Skies.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/The Tree Skies.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Desert.ogg" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Albatrosses.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Albatosses.ogg"
				elseif section.musicPath == "__OST/Mario Forever/Human Lab.spc" then
					section.musicPath = "_OST/Mario Forever/Human Lab.spc"
				elseif section.musicPath == "_OST/Super Metroid/97 Continue.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|20;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Dark Zone.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|20;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle.ogg" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Item Room).ogg" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 2).ogg" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 3).ogg" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/King Wart.ogg" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2"
				elseif section.music == 43 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2"
				elseif section.musicPath == "_OST/Doki Doki Panic/File Clear.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SubconsSavedSMB2.ogg"
				--Super Mario Bros. 3
				elseif section.musicPath == "_OST/Super Mario Bros 3/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Bonus Level.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/In The Clouds.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|12;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Toad's House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Fortress.spc|0;g=1.6" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/King's Chamber.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|19;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Before Airship.spc|0;g=2.2" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Volcano.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship.spc" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|20;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship Boss.spc|0;g=2.6" then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Desert.spc|0;g=3.2" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Desert.ogg"
				--Super Mario World
				elseif section.musicPath == "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Castle.spc|0;g=2.5" then
					section.musicPath = "__OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Boss Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|10;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Underground 2.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				end
			end
			if currentCostume == "9-SMW-PIRATE" then
				--MALC HUB
				if section.musicPath == "_OST/Me and Larry City/Character Switch Room.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				--Super Mario Bros. 1
				elseif section.musicPath == "_OST/Super Mario Bros/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros/Bonus.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Album.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros/Castle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.music == 19 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.music == 21 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.music == "_OST/Super Mario Bros/Bowser.spc|0;g=2.5" then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros/Desert.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Invincibility.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|13;g=2.2"
				elseif section.musicPath == "_OST/All Stars Secrets/Lineland.ogg" then
					section.musicPath = "_OST/All Stars Secrets/Lineland.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Snow.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Race.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Lakitu.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow (Alternative).ogg" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Snow.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Ghost House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros/Last Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Bowser (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2"
				--Super Mario Bros. Lost Levels
				elseif section.musicPath == "_OST/Super Mario Bros/Airship.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				--Super Mario Bros. 2
				elseif section.musicPath == "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.music == "subspace_music.spc|0;g=2.7;" then
					section.music = "_OST/Super Mario Bros 2 (NES)/Subspace.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Jar.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Before Boss.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.music == 15 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground (Beta).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/The Tree Skies.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/The Tree Skies.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Desert.ogg" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Albatrosses.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Albatosses.ogg"
				elseif section.musicPath == "__OST/Mario Forever/Human Lab.spc" then
					section.musicPath = "_OST/Mario Forever/Human Lab.spc"
				elseif section.musicPath == "_OST/Super Metroid/97 Continue.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Dark Zone.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle.ogg" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Item Room).ogg" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 2).ogg" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 3).ogg" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/King Wart.ogg" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2"
				elseif section.music == 43 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2"
				elseif section.musicPath == "_OST/Doki Doki Panic/File Clear.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SubconsSavedSMB2.ogg"
				--Super Mario Bros. 3
				elseif section.musicPath == "_OST/Super Mario Bros 3/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Bonus Level.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/In The Clouds.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|12;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Toad's House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Fortress.spc|0;g=1.6" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/King's Chamber.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|19;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Before Airship.spc|0;g=2.2" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Volcano.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship.spc" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship Boss.spc|0;g=2.6" then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Desert.spc|0;g=3.2" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Desert.ogg"
				--Super Mario World
				elseif section.musicPath == "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Castle.spc|0;g=2.5" then
					section.musicPath = "__OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Boss Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|13;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Underground 2.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				end
			end
			if currentCostume == "11-SMA1" or currentCostume == "12-SMA2" or currentCostume == "13-SMA4" then
				--Super Mario Bros. 1
				elseif section.musicPath == "_OST/Super Mario Bros/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Bonus.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Bonus Level.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Underground Level.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Normal Level 2.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Album.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Music Box.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Castle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Super Mario Brothers Castle.ogg"
				elseif section.music == 19 then
					section.music = "_OST/Super Mario Advance 4/Bowser Battle.ogg"
				elseif section.music == 21 then
					section.music = "_OST/Super Mario Advance 4/Bowser Battle.ogg"
				elseif section.music == "_OST/Super Mario Bros/Bowser.spc|0;g=2.5" then
					section.music = "_OST/Super Mario Advance 4/Bowser Battle.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Desert.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Coin Heaven.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Super Mario Brothers Water Level.ogg"
				elseif section.musicPath == "_OST/All Stars Secrets/Lineland.ogg" then
					section.musicPath = "_OST/All Stars Secrets/Lineland.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Advance 4/Snow.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Race.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros (NES)/Lakitu.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Snow (Alternative).ogg" then
					section.musicPath = "_OST/Super Mario Advance 4/Snow.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros/Ghost House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros/Last Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Bowser (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2"
				--Super Mario Bros. Lost Levels
				elseif section.musicPath == "_OST/Super Mario Bros/Airship.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				--Super Mario Bros. 2
				elseif section.musicPath == "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.music == "subspace_music.spc|0;g=2.7;" then
					section.music = "_OST/Super Mario Bros 2 (NES)/Subspace.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Jar.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros 2 (NES)/Before Boss.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.music == 15 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Underground (Beta).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/The Tree Skies.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/The Tree Skies.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Desert.ogg" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Desert.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Albatrosses.ogg" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Albatosses.ogg"
				elseif section.musicPath == "__OST/Mario Forever/Human Lab.spc" then
					section.musicPath = "_OST/Mario Forever/Human Lab.spc"
				elseif section.musicPath == "_OST/Super Metroid/97 Continue.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Dark Zone.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle.ogg" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Item Room).ogg" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 2).ogg" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 3).ogg" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 2/King Wart.ogg" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2"
				elseif section.music == 43 then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2"
				elseif section.musicPath == "_OST/Doki Doki Panic/File Clear.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/SubconsSavedSMB2.ogg"
				--Super Mario Bros. 3
				elseif section.musicPath == "_OST/Super Mario Bros 3/Overworld.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Bonus Level.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/In The Clouds.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|12;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Toad's House.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Fortress.spc|0;g=1.6" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Boss.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/King's Chamber.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|19;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Before Airship.spc|0;g=2.2" then
					section.musicPath = "_OST/Super Mario Bros 3 (NES)/Volcano.ogg"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship.spc" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|11;g=2.2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Airship Boss.spc|0;g=2.6" then
					section.music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario Bros 3/Desert.spc|0;g=3.2" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Desert.ogg"
				--Super Mario World
				elseif section.musicPath == "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Underground.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Forest.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Forest.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
					section.musicPath = "_OST/Super Mario World (Pirate)/Athletic.ogg"
				elseif section.musicPath == "_OST/Super Mario World/Castle.spc|0;g=2.5" then
					section.musicPath = "__OST/Super Mario World (NES, Pirate) - OST.nsf|12;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Boss Battle.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2"
				elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Swimming.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|13;g=2.2"
				elseif section.musicPath == "_OST/Super Mario World/Underground 2.spc|0;g=2.5" then
					section.musicPath = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				end
			end
			if currentCostume == "14-NSMBDS-SMBX" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
					Section(1).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Underground Theme.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
					Section(3).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg"
					Section(1).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Underground Theme.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Underwater.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg"
				end
			end
			if currentCostume == "15-NSMBDS-ORIGINAL" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
					Section(1).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Underground Theme.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
					Section(3).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg"
					Section(1).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Underground Theme.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Underwater.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg"
				end
			end
			if currentCostume == "A2XT-DEMO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(3).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/happyska.it"
					Section(1).music = "_OST/Adventures of Demo/Subway_spc.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/monkey_island_v1.xm"
					Section(2).music = "_OST/Adventures of Demo/happyska.it"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
			end
			if currentCostume == "DEMO-XMASPILY" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(3).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/happyska.it"
					Section(1).music = "_OST/Adventures of Demo/Subway_spc.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/monkey_island_v1.xm"
					Section(2).music = "_OST/Adventures of Demo/happyska.it"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
			end
			if currentCostume == "GA-CAILLOU" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/GoAnimate/Old Songs/Action - Adventure.mp3"
					Section(1).music = "_OST/GoAnimate/Old Songs/Ambient - Relaxing.mp3"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/GoAnimate/Old Songs/Ambient - Relaxing.mp3"
					Section(2).music = "_OST/GoAnimate/Old Songs/Action - Adventure.mp3"
					Section(3).music = "_OST/GoAnimate/Old Songs/Ambient - Relaxing.mp3"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/GoAnimate/Old Songs/Bossa Story.mp3"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/GoAnimate/Old Songs/Bossa Story.mp3"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/GoAnimate/Old Songs/Funky Mama.mp3"
					Section(1).music = "_OST/GoAnimate/Old Songs/Joyful - Tribal.mp3"
					Section(2).music = "_OST/GoAnimate/Old Songs/Ambient - Relaxing.mp3"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/GoAnimate/Old Songs/Sunny Side of the Road.mp3"
					Section(2).music = "_OST/GoAnimate/Old Songs/Funky Mama.mp3"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/GoAnimate/Old Songs/Bossa Story.mp3"
				end
			end
			if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.2"
					Section(1).music = "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2"
					Section(2).music = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.2"
					Section(3).music = "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/JC Foster Takes it to the Moon/mm2wood.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/JC Foster Takes it to the Moon/mm2wood.ogg"
					Section(1).music = "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2"
					Section(2).music = "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2"
					Section(2).music = "_OST/JC Foster Takes it to the Moon/mm2wood.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/JC Foster Takes it to the Moon/mm2wood.ogg"
				end
			end
			if currentCostume == "MARINK" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=2"
					Section(1).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|7;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|9;g=2"
					Section(2).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=2"
					Section(3).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|7;g=2"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|9;g=2.1"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|3;g=2"
					Section(1).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|3;g=2"
					Section(2).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|7;g=2"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|4;g=2"
					Section(2).music = "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|3;g=2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|9;g=2.1"
				end
			end
			if currentCostume == "MODERN" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Modern Mario/Overworld 1.ogg"
					Section(1).music = "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|2;g=2.7"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|2;g=2.7"
					Section(2).music = "_OST/Modern Mario/Overworld 1.ogg"
					Section(3).music = "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|9;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|1;g=2.4"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Modern Mario/Overworld 1.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Modern Mario/Desert (VRC6 by TrojanHorse711).nsf|0;g=2.2"
					Section(1).music = "_OST/Modern Mario/Staff Roll (VRC6 by TrojanHorse711).nsf|0;g=2.2"
					Section(2).music = "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|9;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|5;g=2.2"
					Section(2).music = "_OST/Modern Mario/Desert (VRC6 by TrojanHorse711).nsf|0;g=2.2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|1;g=2.4"
				end
			end
			if currentCostume == "PRINCESSRESCUE" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Princess Rescue/Overworld.ogg"
					Section(1).music = "_OST/Princess Rescue/Underground.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Princess Rescue/Underground.ogg"
					Section(2).music = "_OST/Princess Rescue/Overworld.ogg"
					Section(3).music = "_OST/Princess Rescue/Underground.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Princess Rescue/Overworld.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Princess Rescue/Overworld.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Princess Rescue/Overworld.ogg"
					Section(1).music = "_OST/Princess Rescue/Overworld.ogg"
					Section(2).music = "_OST/Princess Rescue/Underground.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Princess Rescue/Underground.ogg"
					Section(2).music = "_OST/Princess Rescue/Overworld.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Princess Rescue/Overworld.ogg"
				end
			end
			if currentCostume == "SMB0" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 0/Overworld1.ogg"
					Section(1).music = "_OST/Super Mario Bros 0/Underground.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 0/Underground.ogg"
					Section(2).music = "_OST/Super Mario Bros 0/Overworld1.ogg"
					Section(3).music = "_OST/Super Mario Bros 0/Bonus.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 0/Overworld1.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 0/Overworld1.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 0/Overworld2.ogg"
					Section(1).music = "_OST/Super Mario Bros 0/Bonus.ogg"
					Section(2).music = "_OST/Super Mario Bros 0/Underground.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 0/Underwater.ogg"
					Section(2).music = "_OST/Super Mario Bros 0/Overworld2.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 0/Overworld2.ogg"
				end
			end
			if currentCostume == "SMG4" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Smash Bros. Ultimate/Mario/a63_3dw_field01.ogg"
					Section(1).music = "_OST/Super Smash Bros. Ultimate/Mario/a04_lnd_chika.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Smash Bros. Ultimate/Mario/a04_lnd_chika.ogg"
					Section(2).music = "_OST/Super Smash Bros. Ultimate/Mario/a63_3dw_field01.ogg"
					Section(3).music = "_OST/Super Smash Bros. Ultimate/Mario/a04_lnd_chika.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Smash Bros. Ultimate/Mario/a67_sm64_slider.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Smash Bros. Ultimate/Mario/a63_3dw_field01.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Smash Bros. Ultimate/Mario/a85_smb3_chijyou.ogg"
					Section(1).music = "_OST/Super Smash Bros. Ultimate/Mario/aa15_sptss_countryfield_senkou.ogg"
					Section(2).music = "_OST/Super Smash Bros. Ultimate/Mario/a04_lnd_chika.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Smash Bros. Ultimate/Mario/a40_drm_chill_ver2.ogg"
					Section(2).music = "_OST/Super Smash Bros. Ultimate/Mario/a85_smb3_chijyou.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Smash Bros. Ultimate/Mario/a67_sm64_slider.ogg"
				end
			end
			if currentCostume == "SMW-MARIO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "SP-1-ERICCARTMAN" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/South Park (N64)/The Theme.ogg"
					Section(1).music = "_OST/South Park (N64)/Caves of South Park.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/South Park (N64)/Caves of South Park.ogg"
					Section(2).music = "_OST/South Park (N64)/The Theme.ogg"
					Section(3).music = "_OST/South Park (N64)/Caves of South Park.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/South Park (N64)/Insane Toys.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "__OST/South Park (N64)/Insane Toys.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/South Park (N64)/Warehouse In South Park.ogg"
					Section(1).music = "_OST/South Park (N64)/Banjo Barnyard.ogg"
					Section(2).music = "_OST/South Park (N64)/Caves Of South Park.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/South Park (N64)/The Theme.ogg"
					Section(2).music = "_OST/South Park (N64)/Warehouse In South Park.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/South Park (N64)/Insane Toys.ogg"
				end
			end
			if currentCostume == "Z-SMW2-ADULTMARIO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario World 2 - Yoshi's Island/109 Underground.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario World 2 - Yoshi's Island/109 Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario World 2 - Yoshi's Island/109 Underground.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario World 2 - Yoshi's Island/114 Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario World 2 - Yoshi's Island/122 Powerful Infant.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario World 2 - Yoshi's Island/109 Underground.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.2"
					Section(2).music = "_OST/Super Mario World 2 - Yoshi's Island/114 Overworld.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5"
				end
			end
			
			
			
			
			
			
			--CHARACTER_LUIGI
			if currentCostume == "0-SPENCEREVERLY" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros Spencer/Overworld.ogg"
					Section(1).music = "_OST/Super Mario Bros Spencer/Caves.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros Spencer/Ice Cream Desert (Underground).ogg"
					Section(2).music = "_OST/Super Mario Bros Spencer/Overworld.ogg"
					Section(3).music = "_OST/Super Mario Bros Spencer/Caves.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros Spencer/Athletic.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros Spencer/Overworld.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros Spencer/Ice Cream Desert (Missing Creams).ogg"
					Section(1).music = "_OST/Super Mario Bros Spencer/Star.ogg"
					Section(2).music = "_OST/Super Mario Bros Spencer/Caves.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros Spencer/Water.ogg"
					Section(2).music = "_OST/Super Mario Bros Spencer/Ice Cream Desert (Missing Creams).ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros Spencer/Athletic.ogg"
				end
			end
			if currentCostume == "3-SMB1-RETRO-MODERN" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2"
					Section(1).music = "_OST/Super Mario Bros (NES) - OST.nsf|1;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros (NES) - OST.nsf|1;g=2"
					Section(2).music = "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2"
					Section(3).music = "_OST/Super Mario Bros (NES) - OST.nsf|1;g=2"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros (NES)/Athletic.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros (NES)/Desert.ogg"
					Section(1).music = "_OST/Super Mario Bros (NES)/Sky.ogg"
					Section(2).music = "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros (NES) - OST.nsf|2;g=2"
					Section(2).music = "_OST/Super Mario Bros (NES)/Desert.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros (NES)/Athletic.ogg"
				end
			end
			if currentCostume == "4-SMB1-SMAS" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "5-SMB2-RETRO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(3).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Desert.ogg"
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
					Section(2).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Underwater.ogg"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
			end
			if currentCostume == "6-SMB2-SMAS" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "7-SMB3-RETRO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
					Section(2).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
					Section(3).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|12;g=2"
					Section(2).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|10;g=2"
					Section(2).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2"
				end
			end
			if currentCostume == "9-SMB3-MARIOCLOTHES" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "10-SMW-ORIGINAL" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "11-SMW-PIRATE" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
					Section(1).music = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
					Section(2).music = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
					Section(3).music = "_OST/Super Mario World (Pirate)/Bonus.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario World (Pirate)/Athletic.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario World (Pirate)/Desert.ogg"
					Section(1).music = "_OST/Super Mario World (Pirate)/Bonus.ogg"
					Section(2).music = "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario World (NES, Pirate) - OST.nsf|13;g=2.2"
					Section(2).music = "_OST/Super Mario World (Pirate)/Desert.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario World (Pirate)/Athletic.ogg"
				end
			end
			if currentCostume == "13-SMBDX" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "14-SMA1" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
					Section(1).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
					Section(2).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
					Section(3).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
					Section(1).music = "_OST/Super Mario Advance 4/The Tree Skies.ogg"
					Section(2).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 4/Super Mario Brothers Water Level.ogg"
					Section(2).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
			end
			if currentCostume == "15-SMA2" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
					Section(1).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
					Section(2).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
					Section(3).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
					Section(1).music = "_OST/Super Mario Advance 4/The Tree Skies.ogg"
					Section(2).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 4/Super Mario Brothers Water Level.ogg"
					Section(2).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
			end
			if currentCostume == "16-SMA4" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
					Section(1).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
					Section(2).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
					Section(3).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
					Section(1).music = "_OST/Super Mario Advance 4/The Tree Skies.ogg"
					Section(2).music = "_OST/Super Mario Advance 4/Underground Level.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 4/Super Mario Brothers Water Level.ogg"
					Section(2).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg"
				end
			end
			if currentCostume == "17-NSMBDS-SMBX" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
					Section(1).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Underground Theme.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
					Section(3).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg"
					Section(1).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Underground Theme.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Underwater.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg"
				end
			end
			if currentCostume == "18-NSMBDS-ORIGINAL" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
					Section(1).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Underground Theme.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
					Section(3).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Walking the Plains.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg"
					Section(1).music = "_OST/New Super Mario Bros. DS/Bonus Stage.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Underground Theme.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/New Super Mario Bros. DS/Underwater.ogg"
					Section(2).music = "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg"
				end
			end
			if currentCostume == "A2XT-IRIS" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(3).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/happyska.it"
					Section(1).music = "_OST/Adventures of Demo/Subway_spc.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/monkey_island_v1.xm"
					Section(2).music = "_OST/Adventures of Demo/happyska.it"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
			end
			if currentCostume == "LARRYTHECUCUMBER" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/VeggieTales/Theme Song.ogg"
					Section(1).music = "_OST/VeggieTales/Big Things Too.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/VeggieTales/Big Things Too.ogg"
					Section(2).music = "_OST/VeggieTales/Theme Song.ogg"
					Section(3).music = "_OST/VeggieTales/Big Things Too.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/VeggieTales/The Hairbrush Song.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/VeggieTales/Theme Song.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/VeggieTales/The Hairbrush Song.ogg"
				end
			end
			if currentCostume == "UNDERTALE-FRISK" then
				--if level == "SMB1 - W-1, L-1.lvlx" then
					--Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					--Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				--end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "WALUIGI" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			
			
			
			
			
			
			
			--CHARACTER_PEACH
			if currentCostume == "2P-SMB1-SMAS" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "3-SMB2-RETRO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(3).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Desert.ogg"
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
					Section(2).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Underwater.ogg"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
			end
			if currentCostume == "4-SMB3-RETRO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
					Section(2).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
					Section(3).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|12;g=2"
					Section(2).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|10;g=2"
					Section(2).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2"
				end
			end
			if currentCostume == "5-SMB3-SMAS" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "A2XT-KOOD" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(3).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/happyska.it"
					Section(1).music = "_OST/Adventures of Demo/Subway_spc.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/monkey_island_v1.xm"
					Section(2).music = "_OST/Adventures of Demo/happyska.it"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
			end
			if currentCostume == "DAISY" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "KIRBY-SMB3" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2"
					Section(1).music = "_OST/Kirby Superstar/14 White Wing Dynablade.spc|0;g=2.1"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Kirby Superstar/18 Cocoa Cave.spc|0;g=2.1"
					Section(2).music = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2"
					Section(3).music = "_OST/Kirby Superstar/14 White Wing Dynablade.spc|0;g=2.1"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Kirby Superstar/16 Peanut Plain.spc|0;g=2.4"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.2"
					Section(1).music = "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.2"
					Section(2).music = "_OST/Kirby Superstar/14 White Wing Dynablade.spc|0;g=2.1"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.2"
					Section(2).music = "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Kirby Superstar/16 Peanut Plain.spc|0;g=2.4"
				end
			end
			if currentCostume == "PAULINE" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			
			
			
			
			
			
			
			--CHARACTER_TOAD
			if currentCostume == "2-SMB1-SMAS" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "3-SMB2-RETRO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(3).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Desert.ogg"
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
					Section(2).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Underwater.ogg"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
			end
			if currentCostume == "4-SMB2-RETRO-YELLOW" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(3).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Desert.ogg"
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
					Section(2).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Underwater.ogg"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
			end
			if currentCostume == "5-SMB2-RETRO-RED" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
					Section(3).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Desert.ogg"
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
					Section(2).music = "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros 2 (NES)/Underwater.ogg"
					Section(2).music = "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros 2 (NES)/Sky.ogg"
				end
			end
			if currentCostume == "6-SMB3-BLUE" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "7-SMB3-YELLOW" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "A2XT-RAOCOW" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(3).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/happyska.it"
					Section(1).music = "_OST/Adventures of Demo/Subway_spc.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/monkey_island_v1.xm"
					Section(2).music = "_OST/Adventures of Demo/happyska.it"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
			end
			if currentCostume == "SEE-TANGENT" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Nintendogs/Overworld.ogg"
					Section(1).music = "_OST/Nintendogs/Underground.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Nintendogs/Underground.ogg"
					Section(2).music = "_OST/Nintendogs/Overworld.ogg"
					Section(3).music = "_OST/Nintendogs/Underground.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Nintendogs/Athletic.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Nintendogs/Overworld.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Nintendogs/Underwater.ogg"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Nintendogs/Athletic.ogg"
				end
			end
			if currentCostume == "SONIC" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Sonic Mania/GreenHill1.ogg"
					Section(1).music = "_OST/Sonic Mania/FlyingBattery1.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Sonic Mania/FlyingBattery1.ogg"
					Section(2).music = "_OST/Sonic Mania/GreenHill1.ogg"
					Section(3).music = "_OST/Sonic Mania/FlyingBattery1.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Sonic Mania/GreenHill2.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Sonic Mania/GreenHill2.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Sonic Mania/Hydrocity1.ogg"
					Section(1).music = "_OST/Sonic Mania/BlueSpheres.ogg"
					Section(2).music = "_OST/Sonic Mania/FlyingBattery1.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Sonic Mania/OilOcean1.ogg"
					Section(2).music = "_OST/Sonic Mania/Hydrocity1.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Sonic Mania/Hydrocity2.ogg"
				end
			end
			if currentCostume == "TOADETTE" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "YOSHI-SMB3" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			
			
			
			
			
			
			
			
			
			--CHARACTER_LINK
			if currentCostume == "1-LOZ1-RETRO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/The Legend of Zelda (NES) - OST.nsf|2;g=2"
					Section(1).music = "_OST/The Legend of Zelda (NES) - OST.nsf|2;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "2-ZED2-RETRO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Zelda II - The Adventure of Link (NES) - OST.nsf|1;g=2"
					Section(1).music = "_OST/Zelda II - The Adventure of Link (NES) - OST.nsf|1;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "3-LINKPAST-SNES" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.4"
					Section(1).music = "_OST/Legend of Zelda - A Link to the Past/13 Dank Dungeons.spc|0;g=2.1"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "4-LINKWAKE-GBC" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/The Legend of Zelda - Link's Awakening DX (GBC) - OST.gbs|4;g=1.9"
					Section(1).music = "_OST/The Legend of Zelda - Link's Awakening DX (GBC) - OST.gbs|8;g=2.2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "5-LINKWAKE-SNES" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Legend of Zelda - Link's Awakening (Switch)/10_Field_Normal.ry.48.dspadpcm.ogg"
					Section(1).music = "_OST/Legend of Zelda - Link's Awakening (Switch)/12_StrangeForest.ry.48.dspadpcm.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "6-4SWORDS-RED" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
					Section(1).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "7-4SWORDS-GREEN" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
					Section(1).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "8-4SWORDS-BLUE" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
					Section(1).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "9-4SWORDS-PURPLE" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
					Section(1).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "10-4SWORDS-YELLOW" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
					Section(1).music = "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "A2XT-SHEATH" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/analysis-8.mod"
					Section(3).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5"
				end
			if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/happyska.it"
					Section(1).music = "_OST/Adventures of Demo/Subway_spc.spc|0;g=2.5"
					Section(2).music = "_OST/Adventures of Demo/Medivo.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Adventures of Demo/monkey_island_v1.xm"
					Section(2).music = "_OST/Adventures of Demo/happyska.it"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Adventures of Demo/humble_down_theroad.mod"
				end
			end
			if currentCostume == "NESS" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/EarthBound/019b Onett Theme.spc|0;g=2.1"
					Section(1).music = "_OST/EarthBound/039 Dangerous Caves.spc|0;g=2.1"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/EarthBound/030 Battle Against a Weak Opponent.spc|0;g=2.1"
					Section(2).music = "_OST/EarthBound/019b Onett Theme.spc|0;g=2.1"
					Section(3).music = "_OST/EarthBound/030 Battle Against a Weak Opponent.spc|0;g=2.1"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/EarthBound/052a Peaceful Rest Valley.spc|0;g=2.1"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/EarthBound/019b Onett Theme.spc|0;g=2.1"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "SMB2-SNES" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "SMB3-BANDANA-DEE" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2"
					Section(1).music = "_OST/Kirby Superstar/14 White Wing Dynablade.spc|0;g=2.1"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Kirby Superstar/18 Cocoa Cave.spc|0;g=2.1"
					Section(2).music = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2"
					Section(3).music = "_OST/Kirby Superstar/14 White Wing Dynablade.spc|0;g=2.1"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Kirby Superstar/16 Peanut Plain.spc|0;g=2.4"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "TAKESHI" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
					Section(1).music = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
					Section(2).music = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
					Section(3).music = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "TAKESHI-SNES" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
					Section(1).music = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
					Section(2).music = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
					Section(3).music = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			
			
			
			
			
			
			
			--CHARACTER_MEGAMAN
			if currentCostume == "BASS" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			if currentCostume == "PROTOMAN" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			
			
			
			
			
			
			
			--CHARACTER_WARIO
			if currentCostume == "SMB3-WARIO" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			
			
			
			
			
			--CHARACTER_YOSHI
			if currentCostume == "SMA3" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 3/Flower Garden.ogg"
					Section(1).music = "_OST/Super Mario Advance 3/Underground BGM.ogg"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 3/Underground BGM.ogg"
					Section(2).music = "_OST/Super Mario Advance 3/Flower Garden.ogg"
					Section(3).music = "_OST/Super Mario Advance 3/Underground BGM.ogg"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 3/Athletic.ogg"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 3/Overworld.ogg"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 3/Flower Garden.ogg"
					Section(1).music = "_OST/Super Mario Advance 3/Bonus Game.ogg"
					Section(2).music = "_OST/Super Mario Advance 3/Underground BGM.ogg"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Advance 3/Overworld.ogg"
					Section(2).music = "_OST/Super Mario Advance 3/Flower Garden.ogg"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Advance 3/Athletic.ogg"
				end
			end
			
			
			
			
			
			
			--CHARACTER_NINJABOMBERMAN
			if currentCostume == "WALUIGI-SMB3" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
			
			
			
			if character == "CHARACTER_ULTIMATERINKA" then
				if level == "SMB1 - W-1, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(1).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.6"
				end
				if level == "SMB1 - W-1, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Underground.spc|0;g=2.5"
					Section(2).music = "_OST/Super Mario Bros/Overworld.spc|0;g=2.5"
					Section(3).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-1, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
				if level == "SMB1 - W-1, L-4.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Album.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-1.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.2"
					Section(1).music = "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7"
					Section(2).music = "_OST/Super Mario Bros/Bonus.spc|0;g=2.7"
				end
				if level == "SMB1 - W-2, L-2.lvlx" then
					Section(1).music = "_OST/Super Mario Bros/Swimming.spc|0;g=2.6"
					Section(2).music = "_OST/Super Mario Bros/Desert.spc|0;g=2.5"
				end
				if level == "SMB1 - W-2, L-3.lvlx" then
					Section(0).music = "_OST/Super Mario Bros/Athletic.spc|0;g=2.5"
				end
			end
		end
	end
end
	
	


return musicalchairs

---------X2 SOUND REPLACING---------

--atm idk how to make it work. Coming whenever I do fix the issue though



---------GRAPHIC REPLACING---------

-----Sprite Override-----

--Coming soon--