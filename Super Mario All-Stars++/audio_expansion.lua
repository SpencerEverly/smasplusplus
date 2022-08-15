local audioext = {}

function audioext.resolveMusicFile(path) -- straight up stealing from classexpander...
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
        t[idx+3*#typeslist] = "worlds/Super Mario All-Stars++/sounds-ext/"..path..typ
        idx = idx+1
    end
    
    return Misc.multiResolveFile(table.unpack(t))
end

return audioext