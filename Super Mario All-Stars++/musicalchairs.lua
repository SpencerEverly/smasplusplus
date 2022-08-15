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
    registerEvent(musicalchairs, "onDraw")
    registerEvent(musicalchairs, "onEvent")
    
    ready = true
end

function musdelay()
    Routine.wait(0, true)
    started = true
end

function musicalchairs.switcher()
    started = false
    Routine.wait(0, true)
    Sound.restoreOriginalMusic(-1)
    started = true
end

function musicalchairs.onStart()
    Routine.run(musdelay)
end

--onTick is for sections that don't change the section music.
function musicalchairs.onDraw()
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
            
            
            
            
            
            if SaveData.currentCostume == "00-SMASPLUSPLUS-BETA" then
                --MALC HUB
                if section.musicPath == "_OST/Me and Larry City/Character Switch Room.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BonusSMB3.mid|s1;"
                --Super Mario Bros. 1
                elseif section.musicPath == "_OST/Super Mario Bros/Overworld.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Classic.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Bonus.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Bonus.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Underground.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Caves.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Athletic.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/AthleticSMB1.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Album.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BeforeCastleSMB1.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Castle.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Castle.mid|s1;"
                elseif section.music == 19 then
                    section.music = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMBDDX - Last Bowser Battle.mid|s1;"
                elseif section.music == 21 then
                    section.music = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMBDDX - Bowser Battle.mid|s1;"
                elseif section.music == "_OST/Super Mario Bros/Bowser.spc|0;g=2.5" then
                    section.music = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMBDDX - Bowser Battle.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Desert.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/DesertSMB1.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/Star Power (HD).ogg"
                elseif section.musicPath == "_OST/Super Mario Bros/Swimming.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Water.mid|s1;"
                elseif section.musicPath == "_OST/All Stars Secrets/Lineland.mid|s1;" then
                    section.musicPath = "_OST/All Stars Secrets/Lineland.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Snow.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SnowSMB1.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Race.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/LakituSMB1.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Snow (Alternative).mid|s1;" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SnowSMB1.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Forest.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SkiesSMB1.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Ghost House.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BowserLandSMB1.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros/Last Battle.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMBDDX - Last Bowser Battle.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Bowser (Advance).spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Final Battle.mid|s1;"
                --Super Mario Bros. Lost Levels
                elseif section.musicPath == "_OST/Super Mario Bros/Airship.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/AirshipSMB1.mid|s1;"
                --Super Mario Bros. 2
                elseif section.musicPath == "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Subcon.mid|s1;"
                elseif section.music == "subspace_music.spc|0;g=2.7;" then
                    section.music = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SubspaceDDP.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Underground.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/CavesSMB2.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Jar.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/JarSMB2.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BeforeBossSMB2.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BirdoAlt.mid|s1;"
                elseif section.music == 15 then
                    section.music = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BirdoAlt.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Underground (Beta).spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/CavesSMB2Beta.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/The Tree Skies.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/The Tree Skies.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Desert.ogg" then
                    section.musicPath = "_OST/Super Mario Bros 2/Desert.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Albatrosses.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Albatosses.mid|s1;"
                elseif section.musicPath == "__OST/Mario Forever/Human Lab.spc" then
                    section.musicPath = "_OST/Mario Forever/Human Lab.spc"
                elseif section.musicPath == "_OST/Super Metroid/97 Continue.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Metrma.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Dark Zone.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/F-F-Fire.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Castle.mid|s1;" then
                    section.musicPath = "_OST/Super Mario Bros 2/Castle.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Item Room).ogg" then
                    section.musicPath = "_OST/Super Mario Bros 2/Castle (Item Room).mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 2).ogg" then
                    section.musicPath = "_OST/Super Mario Bros 2/Castle (Phase 2).mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/Castle (Phase 3).ogg" then
                    section.musicPath = "_OST/Super Mario Bros 2/Castle (Phase 3).mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 2/King Wart.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Wart.mid|s1;"
                elseif section.music == 43 then
                    section.music = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Wart.mid|s1;"
                elseif section.musicPath == "_OST/Doki Doki Panic/File Clear.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SubconsSavedSMB2.mid|s1;"
                --Super Mario Bros. 3
                elseif section.musicPath == "_OST/Super Mario Bros 3/Overworld.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Land.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/Bonus Level.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BonusAreaSMB3.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/Athletic.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Athletic.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/In The Clouds.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/WarpZoneSMB3.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/Toad's House.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/PSwitchSMB3-Remastered.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/Fortress.spc|0;g=1.6" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Fort.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/Boss.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMBDDX - Boss.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/King's Chamber.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/King.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/Before Airship.spc|0;g=2.2" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BeforeAirshipSMB3.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/Airship.spc" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Airship.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/Airship Boss.spc|0;g=2.6" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/AirshipBossSMB3.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros 3/Desert.spc|0;g=3.2" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Land.mid|s1;"
                --Super Mario World
                elseif section.musicPath == "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMWOverworld.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Underground.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/CavesSMW.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/secret1.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Forest.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/ForestSMW.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Athletic.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMWAthletic.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Athletic.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMWAthletic.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/YI-_Jazzy!.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/YI-_Jazzy!.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Castle.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMW_Castle-KM.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Boss Battle.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BossSMW.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMWOverworld.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/SMWOverworld.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Swimming.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/WaterSMW.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario World/Underground 2.spc|0;g=2.5" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Caves.mid|s1;"
                --Super Mario Bros. Spencer
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Overworld.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/OverworldSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Star.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/StarSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Caves.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/CavesSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Athletic.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/AthleticSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Going Underground.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/OverworldSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Tower.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/TowerSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Boss Battle.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/BossBattleSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Going Underwater.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/OverworldSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Water.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/WaterSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Forest.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/ForestSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Town.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/Town.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Another World.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/AnotherWorldSMBS.mid|s1;"
                elseif section.musicPath == "_OST/Super Mario Bros Spencer/Castle.ogg" then
                    section.musicPath = "_OST/Super Mario All-Stars++ (Beta)/MIDIs/CastleSMBS.mid|s1;"
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