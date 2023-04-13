local Img = {}

Img.loadedImages = {}
Img.loadedImagesRegistered = {}

function Img.load(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
    local file = File.load(name) or File.load(name..".png")
    if file then
        return Graphics.loadImageResolved(name)
            or Graphics.loadImageResolved("costumes/" .. name)
            or Graphics.loadImageResolved("graphics/" .. name)
            or Graphics.loadImageResolved("___MainUserDirectory/" .. name)
    end
    return nil
end

function Img.loadCharacterHitBoxes(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
    if SaveData.currentCostume == "N/A" then
        return File.load(name)
            or File.load("costumes/" .. name)
            or File.load("graphics/" .. name)
            or File.load("___MainUserDirectory/" .. name)
    elseif SaveData.currentCostume ~= "N/A" then
        return File.load("costumes/"..playerManager.getName(player.character).."/"..player:getCostume().."/"..name)
    end
    return nil
end

function Img.loadDefaultCharacterImage()
    return (Graphics.loadImageResolved(playerManager.getName(player.character).."-"..player.powerup..".png")
        or Graphics.loadImageResolved("config/character_defaults/"..playerManager.getName(player.character).."-"..player.powerup..".png")
    )
end

function Img.loadCharacter(name) --This will not only check the main SMBX2 folders, but will also check for other common SMAS++ directories
    local file = File.load(name) or File.load(name..".png")
    if file and SaveData.currentCostume == "N/A" then
        return Graphics.loadImageResolved(name)
            or Graphics.loadImageResolved("costumes/" .. name)
            or Graphics.loadImageResolved("graphics/" .. name)
            or Graphics.loadImageResolved("___MainUserDirectory/" .. name)
    elseif file and SaveData.currentCostume ~= "N/A" then
        return Graphics.loadImageResolved("costumes/"..playerManager.getName(player.character).."/"..player:getCostume().."/"..name)
    end
    return nil
end

function Img.saveImageData(name)
    if Img.loadedImages[name] == nil then --Only load it once
        local imgpath = Misc.resolveFile(name) 
        if imgpath == nil then
            imgpath = "graphics/stock-0.png"
        end
        Img.loadedImages[name] = Graphics.loadImage(imgpath) --Try loading the image, but if nil then load the stock-0.png file
    end
end

--Img.draw(ImageName, x coordinate, y coordinate, opacity)
function Img.draw(name, x, y, arg6)
    Img.saveImageData(name)
    
    if x == nil or y == nil then
        error("You didn't specify the image with any coordinates. Try specifiying coordinates and try again.")
    end
    
    if opacity == nil then
        opacity = 1
    end
    
    if (arg6 ~= nil) then
        opacity = arg6
    end
    
    Graphics.drawImage(Img.loadedImages[name], x, y, arg6)
end

--Img.drawWP(ImageName, x coordinate, y coordinate, priority, opacity)
function Img.drawWP(name, x, y, arg6, arg7)
    Img.saveImageData(name)
    
    if priority == nil then
        priority = -1
    end
    if opacity == nil then
        opacity = 1
    end
    
    if x == nil or y == nil then
        error("You didn't specify the image with any coordinates. Try specifiying coordinates and try again.")
    end
    
    if (arg6 ~= nil) and (arg7 ~= nil) then
        priority = arg6
        opacity = arg7
    elseif (arg7 ~= nil) then
        opacity = arg6
    elseif (arg6 ~= nil) then
        priority = arg6
    else
        
    end
    
    Graphics.drawImageWP(Img.loadedImages[name], x, y, arg7, arg6)
end

--Img.drawToScene(ImageName, x coordinate, y coordinate, opacity)
function Img.drawToScene(name, x, y, arg6)
    Img.saveImageData(name)
    
    if x == nil or y == nil then
        error("You didn't specify the image with any coordinates. Try specifiying coordinates and try again.")
    end
    
    if opacity == nil then
        opacity = 1
    end
    
    if (arg6 ~= nil) then
        opacity = arg6
    end
    
    Graphics.drawImageToScene(Img.loadedImages[name], x, y, arg6)
end

--Img.drawToScene(ImageName, x coordinate, y coordinate, priority, opacity)
function Img.drawToSceneWP(name, x, y, arg6, arg7)
    Img.saveImageData(name)
    
    if priority == nil then
        priority = -1
    end
    if opacity == nil then
        opacity = 1
    end
    
    if x == nil or y == nil then
        error("You didn't specify the image with any coordinates. Try specifiying coordinates and try again.")
    end
    
    if (arg6 ~= nil) and (arg7 ~= nil) then
        priority = arg6
        opacity = arg7
    elseif (arg7 ~= nil) then
        opacity = arg6
    elseif (arg6 ~= nil) then
        priority = arg6
    else
        
    end

    Graphics.drawImageToSceneWP(Img.loadedImages[name], x, y, arg7, arg6)
end

return Img