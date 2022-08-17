local File = {}

function File.load(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
    return Misc.resolveFile(name)
        or Misc.resolveFile("_OST/" .. name)
        or Misc.resolveFile("_OST/_Sound Effects/"..name)
        or Misc.resolveFile("costumes/" .. name)
        or Misc.resolveFile("scripts/" .. name)
        or Misc.resolveFile("graphics/" .. name)
        or Misc.resolveFile("sound/" .. name)
        or Misc.resolveFile("___MainUserDirectory/" .. name)
end

function File.writeToFile(name, text) --Write to a file using io. This will overwrite everything with the text specified, so BE CAREFUL!
    name = Misc.resolveFile(name)
    if name == nil then
        error("You need to specify the name of the file.")
    end
    if not "string" then
        error("That needs to be a string.")
    end

    local f = io.open(name,"w")
    if f == nil then
        return
    end

    f:write(text)
    f:close()
end

function File.addToFile(name, text) --Add to a file using io. This won't overwrite everything, just adds something to the file, so this one is fine (UNLESS you overwrite important data in the episode).
    name = Misc.resolveFile(name)
    if name == nil then
        error("You need to specify the name of the file.")
    end
    if not "string" then
        error("That needs to be a string.")
    end

    local f = io.open(name,"a")
    if f == nil then
        return
    end

    f:write(text)
    f:close()
end

function File.readFile(name) --Read a file using io. This won't overwrite everything, just reads a file, so this one is fine.
    name = Misc.resolveFile(name)
    if name == nil then
        error("You need to specify the name of the file.")
    end
    
    local text

    local f = io.open(name,"r")
    if f == nil then
        return
    end
    
    return f:read("*all")
end

return File