local File = {}

function File.loadFile(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
    return Misc.resolveFile(name)
        or Misc.resolveFile("_OST/" .. name)
        or Misc.resolveFile("_OST/_Sound Effects/"..name)
        or Misc.resolveFile("costumes/" .. name)
        or Misc.resolveFile("scripts/" .. name)
        or Misc.resolveFile("graphics/" .. name)
        or Misc.resolveFile("sound/" .. name)
        or Misc.resolveFile("___MainUserDirectory/" .. name)
end

function File.loadImg(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
    local file = File.loadFile(name) or File.loadFile(name..".png")
    if file then
        return Graphics.loadImageResolved(name)
            or Graphics.loadImageResolved("_OST/" .. name)
            or Graphics.loadImageResolved("costumes/" .. name)
            or Graphics.loadImageResolved("scripts/" .. name)
            or Graphics.loadImageResolved("graphics/" .. name)
            or Graphics.loadImageResolved("___MainUserDirectory/" .. name)
    end
    return nil
end

--drawImg(ImageName, x coordinate, y coordinate, true/false if it's with the priority, true/false if using scene coordinates, priority, opacity)
function File.drawImg(name, x, y, withPriority, sceneCoords, arg6, arg7) --Drawing graphics got a lot better.
    local fileImage = Graphics.loadImageResolved(name)
    if fileImage == nil then
        fileImage = Graphics.loadImageResolved("noimage.png")
    end
    
    if priority == nil then
        local priority = -1
    end
    if opacity == nil then
        local opacity = 1
    end
    
    if x == nil or y == nil then
        error("You didn't specify the image with any coordinates. Try specifiying coordinates and try again.")
    end
    if withPriority == nil or sceneCoords == nil then
        error("You didn't specify if the image is with a priority, or with scene coordinates. Try setting the booleans and try again.")
    end
    
    if (arg6 ~= nil) and (arg7 ~= nil) then
        if (withPriority) then
            priority = arg6
        end
        opacity = arg7
    elseif (arg7 ~= nil) and ((not withPriority) or (arg6 ~= nil)) then
        opacity = arg6
    elseif (withPriority) then
        priority = arg6
    else
    end
    if (withPriority) and (sceneCoords) then
        Graphics.drawImageToSceneWP(fileImage, x, y, true, true, arg7, arg6)
    elseif (withPriority) and (not sceneCoords) then
        Graphics.drawImageWP(fileImage, x, y, true, false, arg7, arg6)
    elseif (not withPriority) and (sceneCoords) then
        Graphics.drawImageToScene(fileImage, x, y, false, true, arg6)
    elseif (not withPriority) and (not sceneCoords) then
        Graphics.drawImage(fileImage, x, y, false, false, arg6)
    end
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