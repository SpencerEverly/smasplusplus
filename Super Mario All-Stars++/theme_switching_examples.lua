--Theme switching lua examples for if you wanna use this system in your episode.


---------MUSIC REPLACING---------

-----Replacing music sections-----

--For music, first add the requring stuffs:

local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()
local level = Level.filename()

--This is important so that the code will work
local costumes = {}

--onTick is for sections that don't change the section music.
function onTick()
    local character = player.character;
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()
    
    --Audio.MusicChange is the command that changes sections. Followed by a room number found in the level, and then the path/to/file.extension.
    
    --If level is called to change music on the one big lua script. That way, more than a hundred scripts wouldn't be scripted seperately. They are placed on the "currentCostume if" part.
    --Example: if level == "SMB1 - W-1, L-1.lvlx" then
    
    local costumes
    --CHARACTER_MARIO
    if currentCostume == "00-SMASPLUSPLUS-BETA" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "01-SMB1-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "02-SMB1-RECOLORED" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "03-SMB1-SMAS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "04-SMB2-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "05-SMB2-SMAS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "06-SMB3-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "09-SMW-PIRATE" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "11-SMA1" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "12-SMA2" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "13-SMA4" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "14-NSMBDS-SMBX" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "15-NSMBDS-ORIGINAL" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "A2XT-DEMO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "GA-CAILLOU" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "JCFOSTERTAKESITTIOTHEMOON" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "MARINK" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "MODERN" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "PRINCESSRESCUE" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "SMB0" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "SMG4" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "SMW-MARIO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "SP-1-ERICCARTMAN" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "Z-SMW2-ADULTMARIO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    
    
    
    
    
    --CHARACTER_LUIGI
    if currentCostume == "00-SPENCEREVERLY" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "03-SMB1-RETRO-MODERN" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "04-SMB1-SMAS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "05-SMB2-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "06-SMB2-SMAS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "07-SMB3-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "09-SMB3-MARIOCLOTHES" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "10-SMW-ORIGINAL" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "11-SMW-PIRATE" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "13-SMBDX" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "14-SMA1" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "15-SMA2" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "16-SMA4" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "17-NSMBDS-SMBX" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "18-NSMBDS-ORIGINAL" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "A2XT-IRIS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "LARRYTHECUCUMBER" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "UNDERTALE-FRISK" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "WALUIGI" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    
    
    
    
    --CHARACTER_PEACH
    if currentCostume == "2P-SMB1-SMAS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "03-SMB2-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "4-SMB3-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "5-SMB3-SMAS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "A2XT-KOOD" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "DAISY" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "KIRBY-SMB3" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "PAULINE" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    
    
    
    
    
    --CHARACTER_TOAD
    if currentCostume == "02-SMB1-SMAS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "03-SMB2-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "04-SMB2-RETRO-YELLOW" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "06-SMB3-BLUE" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "07-SMB3-YELLOW" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "A2XT-RAOCOW" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "SEE-TANGENT" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "SONIC" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "TOADETTE" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "YOSHI-SMB3" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    
    
    
    
    
    --CHARACTER_LINK
    if currentCostume == "1-LOZ1-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "2-ZED2-RETRO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "3-LINKPAST-SNES" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "4-LINKWAKE-GBC" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "05-LINKWAKE-SNES" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "6-4SWORDS-RED" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "7-4SWORDS-GREEN" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "8-4SWORDS-BLUE" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "9-4SWORDS-PURPLE" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "10-4SWORDS-YELLOW" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "A2XT-SHEATH" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "NESS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "SMB2-SNES" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "SMB3-BANDANA-DEE" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "TAKESHI" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "TAKESHI-SNES" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    
    
    
    
    
    --CHARACTER_MEGAMAN
    if currentCostume == "BASS" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    if currentCostume == "PROTOMAN" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    
    
    
    
    
    --CHARACTER_WARIO
    if currentCostume == "SMB3-WARIO" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
    
    
    
    
    
    --CHARACTER_NINJABOMBERMAN
    if currentCostume == "WALUIGI-SMB3" then
        if level == "level.lvlx" then
            Audio.MusicChange(0, "insert-anything-here")
        end
    end
end

--The next stuff is for events that do change music, since onTick overwrites event music stuff

function onEvent(eventName)
    local character = player.character;
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()
    
    --Default events for no costume stuff, could be anything
    
    if eventName == "BossBegin" then
        Audio.MusicChange(0, "insert-anything-here")
    end
    if eventName == "BossEnd2" then
        Audio.MusicChange(0, "insert-anything-here")
    end
    
    --costchangemusic is used if there's a before boss room, like SMB2.
    
    local costumes
    if currentCostume == "00-SMASPLUSPLUS-BETA" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "01-SMB1-RETRO" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "02-SMB1-RECOLORED" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "03-SMB1-SMAS" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "04-SMB2-RETRO" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "05-SMB2-SMAS" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "06-SMB3-RETRO" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "Z-SMW2-ADULTMARIO" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "11-SMA1" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "12-SMA2" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "14-NSMBDS-SMBX" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "15-NSMBDS-ORIGINAL" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "A2XT-DEMO" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "MODERN" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "PRINCESSRESCUE" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "SMW-MARIO" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "SP-1-ERICCARTMAN" then
        if eventName == "CostChangeMusic" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    
    --And finally, the boss start-related stuff.
    
    if currentCostume == "00-SMASPLUSPLUS-BETA" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "01-SMB1-RETRO" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "02-SMB1-RECOLORED" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "03-SMB1-SMAS" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "04-SMB2-RETRO" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "05-SMB2-SMAS" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "06-SMB3-RETRO" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "Z-SMW2-ADULTMARIO" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "11-SMA1" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "12-SMA2" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "14-NSMBDS-SMBX" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "15-NSMBDS-ORIGINAL" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "A2XT-DEMO" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "MODERN" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "PRINCESSRESCUE" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "SMW-MARIO" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
    if currentCostume == "SP-1-ERICCARTMAN" then
        if eventName == "Boss Start" then
            if level == "level.lvlx" then
                Audio.MusicChange(0, "insert-anything-here")
            end
        end
    end
end

---------X2 SOUND REPLACING---------

--atm idk how to make it work. Coming whenever I do fix the issue though



---------GRAPHIC REPLACING---------

-----Sprite Override-----

--Coming soon--