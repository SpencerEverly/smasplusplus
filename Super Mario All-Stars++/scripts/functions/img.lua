local Img = {}

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

--Img.draw(ImageName, x coordinate, y coordinate, true/false if it's with the priority, true/false if using scene coordinates, priority, opacity)
function Img.draw(name, x, y, withPriority, sceneCoords, arg6, arg7) --PLEASE DO NOT USE! This is outdated and is recommended to use Graphics.drawImage INSTEAD!
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

function Img.registerSceneDraw(image,xPos,yPos,widthPos,heightPos,sourceWidthPos,sourceHeightPos,priorityNum)
    if image == nil then
        return false
    end
    if xPos == nil then
        return false
    end
    if yPos == nil then
        return false
    end
    if widthPos == nil then
        return false
    end
    if heightPos == nil then
        return false
    end
    if sourceWidthPos == nil then
        return false
    end
    if sourceHeightPos == nil then
        return false
    end
    if priorityNum == nil then
        return false
    end
    customCamera.registerSceneDraw(
        function(args)
            local X,Y,scale,rotation = customCamera.convertPosToScreen(args,xPos,yPos)
            Graphics.drawBox{
                texture        = image,	
                sceneCoords    = false,
                x              = X,
                y              = Y,
                width          = widthPos * scale,
                height         = heightPos * scale,
                sourceX        = 0,
                sourceY        = 0,
                sourceWidth    = sourceWidthPos,
                sourceHeight   = sourceHeightPos,
                centered       = true,
                priority       = customCamera.convertPriority(args,priorityNum),
                rotation       = rotation,
                target         = args.target,
                linearFiltered = args.linearFiltered,
            }
        end
    )
    return true
end

return Img