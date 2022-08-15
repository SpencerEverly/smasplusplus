-------------------------------------------------
--[[      jukebox.lua v1.1 by KBM-Quine      ]]--
--[[    "custom" overworld music library     ]]--
-------------------------------------------------

local jukebox = {}

jukebox.autoPlayMusic = true

local curMusicID = mem(0x00B2C5D8, FIELD_WORD)
local curTrack = -1

function jukebox.resolveMusicFile(path) -- straight up stealing from classexpander...
    local validAudioFiles = {".ogg", ".mp3", ".wav", ".voc", ".flac", ".spc", ".opus", ".mid", ".midi", ".xmi", ".mus", ".cmf", ".imf", ".ay", ".gbs", ".gym", ".hes", ".kss", ".nsf", ".nsfe", ".sap", ".vgm", ".vgz", ".669", ".amf", ".apun", ".dsm", ".dbm", ".dtm", ".digi", ".emod", ".far", ".flx", ".fnk", ".gdm", ".it", ".imf", ".liq", ".mdl", ".mod", ".med", ".mtm", ".mtn", ".mgt", ".okt", ".ptm", ".rtm", ".s3m", ".stm", ".stx", ".sfx", ".ult", ".uni", ".wow", ".xm"} -- solely to fill this thing with all formats lol
    
    --table.map doesn't exist yet
    local validFilesMap = {};
    for _,v in ipairs(validAudioFiles) do
        validFilesMap[v] = true;
    end
    
    local p,e = string.match(string.lower(path), "^(.+)(%..+)$")
    local t = {}
    local idx = 1
    local typeslist = validAudioFiles
    if e and validFilesMap[e] then
        --Re-arrange type list to prioritise type that was provided to the resolve function
        if e ~= validAudioFiles[1] then
            typeslist = { e }
            for _,v in ipairs(validAudioFiles) do
                if v ~= e then
                    table.insert(typeslist, v)
                end
            end
        end
        path = p
    end
    for _,typ in ipairs(typeslist) do
        t[idx] = path..typ
        t[idx+#typeslist] = "sound/"..path..typ
        t[idx+2*#typeslist] = "sound/extended/"..path..typ
        idx = idx+1
    end
    
    return Misc.multiResolveFile(table.unpack(t))
end

local function resolveTrack(string) -- to make default tracks easier to replace
    local returnString = jukebox.resolveMusicFile(string) or jukebox.resolveMusicFile("music\\" .. string)
    return returnString
end

local tracks = {
    [-1] = nil,
    [0] = nil,
    [1] = resolveTrack("smb3-world1") .. "|0;g=2.7;",
    [2] = resolveTrack("smb3-world4") .. "|0;g=2.7;",
    [3] = resolveTrack("smb3-world7") .. "|0;g=2.7;",
    [4] = resolveTrack("smw-worldmap") .. "|0;g=2.7;",
    [5] = resolveTrack("nsmb-world"),
    [6] = resolveTrack("smb3-world2") .. "|0;g=2.7;",
    [7] = resolveTrack("smw-forestofillusion") .. "|0;g=2.7;",
    [8] = resolveTrack("smb3-world3") .. "|0;g=2.7;",
    [9] = resolveTrack("smb3-world8") .. "|0;g=2.7;",
    [10] = resolveTrack("smb3-world6") .. "|0;g=2.7;",
    [11] = resolveTrack("smb3-world5") .. "|0;g=2.7;",
    [12] = resolveTrack("smw-special") .. "|0;g=2.7;",
    [13] = resolveTrack("smw-bowserscastle") .. "|0;g=2.7;",
    [14] = resolveTrack("smw-starroad") .. "|0;g=2.7;",
    [15] = resolveTrack("smw-yoshisisland") .. "|0;g=2.7;",
    [16] = resolveTrack("smw-vanilladome") .. "|0;g=2.7;",
}

function jukebox.setTrack(id, filepath)
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
    local mus = Musicbox.getIntersecting(x, y, x+32, y+32)[1]
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

function jukebox.onInitAPI()
    registerEvent(jukebox, "onStart")
    registerEvent(jukebox, "onTick")
    registerEvent(jukebox, "onExit")
end

function jukebox.onStart()
    if not isOverworld then return end
    Audio.SeizeStream(-1)
end

function jukebox.onTick()
    if not isOverworld then return end
    curMusicID = mem(0x00B2C5D8, FIELD_WORD) -- to allow the var to update
    if not (curTrack == curMusicID) then
        if jukebox.autoPlayMusic then
            jukebox.playTrack(curMusicID)
        end
    end
end

function jukebox.onExit()
    if not isOverworld then return end
    curTrack = -1
    Audio.MusicFadeOut(-1, 1000)
    Audio.ReleaseStream(-1)
end

return jukebox