local rng = require("rng")

betterrng = function(tbl, x)
    local t = {}
        for _, v in ipairs(tbl) do
            if v ~= x then
                table.insert(t, v)
            end
        end
    return rng.irandomEntry(t)
end

function string.endswith(String,End)
    return End == '' or string.sub(String, -string.len(End)) == End
end

local randomsong = function()
    local files = Misc.listLocalFiles("../_OST/_Best Hand Picked Music/"))
    local musicfiles = {}
    for i = 1, #files do
        if string.endswith(files[i], ".ogg") or string.endswith(files[i], ".spc") or string.endswith(files[i], ".mp3") or string.endswith(files[i], ".s3m") or string.endswith(files[i], ".mod")  or string.endswith(files[i], ".xm") then
            table.insert(musicfiles, files[i])
        end
    end
    if #musicfiles ~= 0 then
        local songname
    end
    if #musicfiles == 1 then
        songname = musicfiles[1]
    else
        songname = betterrng(musicfiles, prevsong)
    end
    section.musicPath = Misc.resolveFile("../_OST/_Best Hand Picked Music/"..songname
    prevsong = songname
end