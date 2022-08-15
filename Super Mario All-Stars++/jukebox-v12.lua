-------------------------------------------------
--[[      jukebox.lua v1.2 by KBM-Quine      ]]--
--[[    "custom" overworld music library     ]]--
-------------------------------------------------

local iniParse = require("configFileReader")
local jukebox = {}

jukebox.autoPlayMusic = true

local curMusicID = mem(0x00B2C5D8, FIELD_WORD) -- "curWorldMusic" from source. takes care of musicboxes for saving and other purposes
local curTrack = -1 -- the current playing jukebox track. used to compare against curMusicID

function jukebox.resolveMusicFile(path) -- straight up stealing from classexpander...
    local validMusicFiles = {".ogg", ".mp3", ".wav", ".voc", ".flac", ".spc", ".opus", ".mid", ".midi", ".xmi", ".mus", ".cmf", ".imf", ".ay", ".gbs", ".gym", ".hes", ".kss", ".nsf", ".nsfe", ".sap", ".vgm", ".vgz", ".669", ".amf", ".apun", ".dsm", ".dbm", ".dtm", ".digi", ".emod", ".far", ".flx", ".fnk", ".gdm", ".it", ".imf", ".liq", ".mdl", ".mod", ".med", ".mtm", ".mtn", ".mgt", ".okt", ".ptm", ".rtm", ".s3m", ".stm", ".stx", ".sfx", ".ult", ".uni", ".wow", ".xm"} -- solely to fill this thing with all formats lol
    
    --table.map doesn't exist yet
    local validFilesMap = {};
    for _,v in ipairs(validMusicFiles) do
        validFilesMap[v] = true;
    end
    
    local p,e = string.match(string.lower(path), "^(.+)(%..+)$")
    local t = {}
    local idx = 1
    local typeslist = validMusicFiles
    if e and validFilesMap[e] then
        --Re-arrange type list to prioritise type that was provided to the resolve function
        if e ~= validMusicFiles[1] then
            typeslist = { e }
            for _,v in ipairs(validMusicFiles) do
                if v ~= e then
                    table.insert(typeslist, v)
                end
            end
        end
        path = p
    end
    for _,typ in ipairs(typeslist) do
        t[idx] = path..typ
        t[idx+#typeslist] = "music/"..path..typ
        t[idx+2*#typeslist] = "music/extended/"..path..typ
        idx = idx+1
    end
    
    return Misc.multiResolveFile(table.unpack(t))
end

local tracks = {
    [-1] = nil,
    [0] = nil,
}

function jukebox.setTrack(id, filepath)
    if id <= 0 then
        return error("ID cannot be 0 or lower", 1)
    end
    tracks[id] = filepath 
end

function jukebox.getTrack(id)
    return tracks[id]
end

function jukebox.getPlayingTrack()
    return tracks[curTrack]
end

function jukebox.getPlayingTrackID()
    return curTrack
end

function jukebox.setMusicBox(id, x, y)
    if not isOverworld then return end
    local mus = Musicbox.getIntersecting(x, y, x+32, y+32)[1] -- assumes musicboxes are always 32x32 widthxheight. may update to eventually use mem addresses for that
    mus.id = id
end

function jukebox.playTrack(trackID)
    Audio.MusicStop()
    if trackID > 0 then -- use 0 to allow making the music stop
        Audio.MusicOpen(tracks[trackID])
        Audio.MusicPlay()
        curMusicID = trackID
        curTrack = trackID
    else
        curTrack = 0 
    end
end

local function deconstructFileString(file) -- manipulates the file string to get some things about it
    if file == nil then return nil end
    local tbl = {}
    tbl.fileAndArgs = string.gsub(file, ".+%/", "")
    tbl.file = string.gsub(tbl.fileAndArgs, "%|.+", "")
    --tbl.pathArgs = string.gsub(tbl.fileAndArgs, ".+%.%a+", "")
    tbl.fileName = string.gsub(tbl.file, "%.%w+", "")
    tbl.fileType = string.gsub(tbl.file, ".+%.", "")
    return tbl
end

local function ParseMusicini(path, isBasegame) -- used to auto fill the track list for basegame overworld music
    local files, headerdata = iniParse.parseWithHeaders(path, {General = true}, enums, false, true)
    for _,f in ipairs(files) do
        local s = string.match(f._header, "world%-music%-%d+")
        if s then
            local index = tonumber(string.match(s, "%d+"))
            tracks[index] = f.file
            if (isBasegame) then
                local fileInfo = deconstructFileString(f.file)
                local pathString = jukebox.resolveMusicFile(fileInfo.fileName) or jukebox.resolveMusicFile("music\\" .. fileInfo.fileName) -- allows easy music overwriting in the same vain as sounds
                local newFileInfo = deconstructFileString(pathString)
                if (pathString) and newFileInfo.fileType == "spc" then -- add some gain to spcs
                    pathString = pathString .. "|0;g=2.5"
                end
                if (pathString) then
                    tracks[index] = pathString
                end
            end
        end
    end
end

function jukebox.onInitAPI()
    if isOverworld then -- only worry about this if we're on the overworld
        ParseMusicini(getSMBXPath() .. "\\music.ini", true) -- do it once for the basegame music.ini...
        if io.exists(Misc.episodePath() .. "music.ini") then -- check to see if the episode has one...
            ParseMusicini(Misc.episodePath() .. "music.ini") -- and then do it again if it does
        end
    end
    
    registerEvent(jukebox, "onStart")
    registerEvent(jukebox, "onTick")
    registerEvent(jukebox, "onExit")
end

local function updateTrack()
    curMusicID = mem(0x00B2C5D8, FIELD_WORD) -- to allow the var to update
    if not (curTrack == curMusicID) then
        if jukebox.autoPlayMusic then
            jukebox.playTrack(curMusicID)
        end
    end
end

function jukebox.onStart()
    if not isOverworld then return end
    Audio.SeizeStream(-1)
    -- can't properly update the current music during pathing, have to handle it ourselves
    for _, v in ipairs (Musicbox.getIntersecting(world.playerX, world.playerY, world.playerX + world:mem(0x50, FIELD_DFLOAT), world.playerY + world:mem(0x58, FIELD_DFLOAT))) do -- map player height and width
        if not (v.id == curMusicID) then
            mem(0x00B2C5D8, FIELD_WORD, v.id)
        end
    end
    updateTrack()
end

function jukebox.onTick()
    if not isOverworld then return end
    updateTrack()
end

function jukebox.onExit()
    if not isOverworld then return end
    curTrack = -1
    Audio.MusicStop()
    Audio.ReleaseStream(-1)
end

return jukebox