local Img = {}

function Img.load(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
    local file = File.load(name) or File.load(name..".png")
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

--Img.draw(ImageName, x coordinate, y coordinate, true/false if it's with the priority, true/false if using scene coordinates, priority, opacity)
function Img.draw(name, x, y, withPriority, sceneCoords, arg6, arg7) --Drawing graphics got a lot better.
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

return Img