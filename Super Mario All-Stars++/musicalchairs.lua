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

local musicposition = 0
local musicposition2 = 0
local yoshicounter = 3
local yoshicounteroff = 3

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
    
    if started and not SaveData.disableX2char then
        for i = 0,20 do
            for _,p in ipairs(Player.get()) do
                local section = Section(i)
                
                if p.mount ~= 3 then
                    musicposition = Audio.MusicGetPos()
                    yoshicounter = 3
                    yoshicounteroff = yoshicounteroff - 1
                    if yoshicounteroff <= 2 and yoshicounteroff >= 1 then
                        Audio.MusicSetPos(musicposition2)
                    end
                    if yoshicounteroff <= 0 then
                        yoshicounteroff = 0
                    end
                end
                
                
                
                
                if p.mount == 3 then
                    yoshicounteroff = 3
                    musicposition2 = Audio.MusicGetPos()
                    yoshicounter = yoshicounter - 1
                    if yoshicounter <= 2 and yoshicounter >= 1 then
                        Audio.MusicSetPos(musicposition)
                    end
                    if yoshicounter <= 0 then
                        yoshicounter = 0
                    end
                    --Super Mario World
                    if section.musicPath == "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Here We Go (Advance) (Yoshi).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Underground.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Underground (Yoshi).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Forest.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Forest (Yoshi).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Athletic.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Athletic (Yoshi).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
                        section.musicPath = "_OST/Super Mario World/Athletic 3.spc|0;g=2.1"
                    elseif section.musicPath == "_OST/Super Mario World/Castle.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Castle (Yoshi).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Boss Battle.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Boss Battle.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Memory/11 Here We Go (Yoshi).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Swimming.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Swimming (Yoshi).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Underground 2.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Underground 2.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Ghost House.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Ghost House (Yoshi).spc|0;g=2.5"
                    --Super Mario Bros. Spencer
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Overworld.ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Overworld (Yoshi).ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Caves.ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Caves (Yoshi).ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Athletic.ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Athletic (Yoshi).ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Tower.ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Tower (Yoshi).ogg"
                    end
                else
                    if section.musicPath == "_OST/Super Mario World/Here We Go (Advance) (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Here We Go (Advance).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Underground (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Underground.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Bonus (Yoshi).spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Forest (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Forest.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Athletic (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Athletic.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Athletic 3.spc|0;g=2.1" then
                        section.musicPath = "_OST/Super Mario World/Athletic 3.spc|0;g=2.1"
                    elseif section.musicPath == "_OST/Super Mario World/Castle (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Castle.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Boss Battle.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Boss Battle.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Memory/11 Here We Go (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Memory/11 Here We Go.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Swimming (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Swimming.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Underground 2.spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Underground 2.spc|0;g=2.5"
                    elseif section.musicPath == "_OST/Super Mario World/Ghost House (Yoshi).spc|0;g=2.5" then
                        section.musicPath = "_OST/Super Mario World/Ghost House.spc|0;g=2.5"
                    --Super Mario Bros. Spencer
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Overworld (Yoshi).ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Overworld.ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Caves (Yoshi).ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Caves.ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Athletic (Yoshi).ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Athletic.ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Tower (Yoshi).ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Tower.ogg"
                    --[[elseif section.musicPath == "_OST/Super Mario Bros Spencer/Water.ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Water.ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Forest.ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Forest.ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Town.ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Town.ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Another World.ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Another World.ogg"
                    elseif section.musicPath == "_OST/Super Mario Bros Spencer/Castle.ogg" then
                        section.musicPath = "_OST/Super Mario Bros Spencer/Castle.ogg"]]
                    end
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