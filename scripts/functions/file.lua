local File = {}

function File.load(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
    return (Misc.resolveFile(name)
        or Misc.resolveFile("_OST/" .. name)
        or Misc.resolveFile("_OST/_Sound Effects/"..name)
        or Misc.resolveFile("costumes/" .. name)
        or Misc.resolveFile("scripts/" .. name)
        or Misc.resolveFile("graphics/" .. name)
        or Misc.resolveFile("sound/" .. name)
        or Misc.resolveFile("___MainUserDirectory/" .. name)
    )
end

function File.readFromDefaultCharacterDirectory(name)
    return (File.load(name)
        or File.load("config/character_defaults/"..name)
    )
end

function File.readFromCharacterDirectory(name)
    if SaveData.SMASPlusPlus.player[1].currentCostume ~= "N/A" then
        local file = File.load("costumes/"..playerManager.getName(player.character).."/"..SaveData.SMASPlusPlus.player[1].currentCostume.."/states/"..name)
        if file then
            return file
        else
            file = File.readFromDefaultCharacterDirectory(name)
            return file
        end
    else
        local file = File.readFromDefaultCharacterDirectory(name)
        if file then
            return file
        end
    end
    return nil
end

function File.writeToFile(name, text) --Write to a file using io. This will overwrite everything with the text specified, so BE CAREFUL!
    local name2 = Misc.resolveFile(name)
    if name2 == nil then
        error("You need to specify the name of the file.")
    end

    local f = io.open(name2,"w")
    if f == nil then
        return
    end

    f:write(tostring(text))
    f:close()
    
    SysManager.sendToConsole("File "..name2.." was overwritten to with text data.")
end

function File.addToFile(name, text) --Add to a file using io. This won't overwrite everything, just adds something to the file, so this one is fine (UNLESS you overwrite important data in the episode).
    local name2 = Misc.resolveFile(name)
    if name2 == nil then
        error("You need to specify the name of the file.")
    end

    local f = io.open(name2,"a")
    if f == nil then
        return
    end

    f:write(tostring(text))
    f:close()
    
    SysManager.sendToConsole("File "..name2.." was written to with text data.")
end

function File.readFile(name) --Read a file using io. This won't overwrite everything, just reads a file, so this one is fine.
    local name2 = Misc.resolveFile(name)
    if name2 == nil then
        error("You need to specify the name of the file.")
    end
    
    local text

    local f = io.open(name2,"r")
    if f == nil then
        return
    end
    
    SysManager.sendToConsole("File "..name.." was recently read.")
    
    return f:read("*all")
end

function File.readSpecificAreaFromFile(name, linenumber) --Read a file using io. This won't overwrite everything, just reads a file, so this one is fine.
    name2 = Misc.resolveFile(name)
    if name2 == nil then
        error("You need to specify the name of the file.")
    end
    
    local linesToRead = io.readFileLines(name2)
    
    SysManager.sendToConsole("File "..name.." was read at line"..tostring(linenumber)..".")
    
    return linesToRead[linenumber]
end

function File.stringToHex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

function File.cdataToString(ffidata)
    if SMBX_VERSION ~= VER_SEE_MOD then
        Misc.warn("You are using the original LunaLua, and not the SEE Mod for this command. Please retrieve the SEE Mod by downloading it over at this website: https://github.com/SpencerEverly/smbx2-seemod")
        return
    else
        return ffi.string(ffi.cast("void*",ffidata),ffi.sizeof(ffidata))
    end
end

function File.stringToCData(stringdata, ffidata)
    if SMBX_VERSION ~= VER_SEE_MOD then
        Misc.warn("You are using the original LunaLua, and not the SEE Mod for this command. Please retrieve the SEE Mod by downloading it over at this website: https://github.com/SpencerEverly/smbx2-seemod")
        return
    else
        local text = stringdata
        --local c_str = ffi.new("char[?]", #text + 1)
        ffi.copy(ffidata, text)
        return ffidata
    end
end

function File.splitCharacters(stringg)
    local t = {}
    stringg:gsub(".",function(c) table.insert(t,c) end)
    return t
end

function File.fileToByteSize(file)
    local input = io.readFileLines(file)
    if input == nil then
        return
    end
    
    local outputtext = {}
    local output = 0
    
    for i = 1,#input do
        outputtext[i] = File.splitCharacters(input[i])
        for k,v in ipairs(outputtext[i]) do
            output = output + 1
        end
    end
    
    return output
end

function File.fileToKilobyteSize(file)
    local bytesize = File.fileToByteSize(file)
    return bytesize / 1024
end

return File