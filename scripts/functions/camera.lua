local Screen = {}

local inspect = require("ext/inspect")

Screen.debug = false

function Screen.onInitAPI()
    registerEvent(Screen,"onDraw")
end

function Screen.x() --Actual X position, with resolution support
    return camera.x
end

function Screen.y() --Actual Y position, with resolution support
    return camera.y
end

function Screen.width() --Actual width, with resolution support
    return camera.width
end

function Screen.height() --Actual height, with resolution support
    return camera.height
end

function Screen.cursorX() --Cursor X position (Used for Steve and cursor.lua). Resolution support coming later
    return mem(0x00B2D6BC, FIELD_DFLOAT)
end

function Screen.cursorY() --Cursor Y position (Used for Steve and cursor.lua). Resolution support coming later
    return mem(0x00B2D6C4, FIELD_DFLOAT)
end

local oldBoundaryLeft,oldBoundaryRight,oldBoundaryTop,oldBoundaryBottom = 0,0,0,0
local boundaryLeft,boundaryRight,boundaryTop,boundaryBottom = 0,0,0,0
local setCameraPosition = false
local cameraPanSpeed = 2 --Default speed for camera control
local cameraPausedWhileScrolling = true
Screen.playersOutOfBounds = {}
Screen.activeCameraScrolls = {} --Adds to a table whether any is active
local tempBool = false

function Screen.getSectionBounds(section)
    local bounds = Section(section).boundary
    return bounds.left, bounds.top, bounds.bottom, bounds.right
end

function Screen.setSectionBounds(section, left, top, bottom, right)
    local sectionObj = Section(section)
    local bounds = sectionObj.boundary
    bounds.left = left
    bounds.top = top
    bounds.bottom = bottom
    bounds.right = right
    sectionObj.boundary = bounds
end

local function setScrollToArguments(section)
    if section == nil then
        section = player.section
    end
    
    if cameraPanSpeed == nil or cameraPanSpeed <= 0 then    
        Screen.activeCameraScrolls[section] = nil
        return
    end
    
    local x1, y1, y2, x2 = Screen.getSectionBounds(section)
    local dX1 = boundaryLeft - x1
    local dY1 = boundaryTop - y1
    local dX2 = boundaryRight - x2
    local dY2 = boundaryBottom - y2
    local avgDX = (math.abs(dX1) + math.abs(dX2)) * 0.5
    local avgDY = (math.abs(dY1) + math.abs(dY2)) * 0.5
    local avgD = math.sqrt(avgDX * avgDX + avgDY * avgDY)
    if (avgD > cameraPanSpeed) then
        local factor = cameraPanSpeed / avgD
        avgDX = factor * avgDX
        avgDY = factor * avgDY
    end
    
    Screen.activeCameraScrolls[section] = {x1=boundaryLeft, y1=boundaryTop, x2=boundaryRight, y2=boundaryBottom, xs=avgDX, ys=avgDY}
    
    setCameraPosition = true
end

function Screen.setCameraPosition(leftbound,upbound,downbound,rightbound,speed,isPausedWhileScrolling) --This is used to set the camera boundaries for the specific section.
    local plr = player
    local section = plr.sectionObj
    local sectionidx = plr.section
    local bounds = section.boundary
    local bounds2 = {left = camera.x, top = camera.y, right = camera.x + camera.width, bottom = camera.y + camera.height}
    if leftbound == nil then
        leftbound = bounds.left
    end
    if rightbound == nil then
        rightbound = bounds.right
    end
    if upbound == nil then
        upbound = bounds.top
    end
    if downbound == nil then
        downbound = bounds.bottom
    end
    
    if speed == nil then
        speed = cameraPanSpeed
    end
    if isPausedWhileScrolling == nil then
        isPausedWhileScrolling = true
    end
    
    boundaryLeft = leftbound
    boundaryRight = rightbound
    boundaryTop = upbound
    boundaryBottom = downbound
    
    oldBoundaryLeft = bounds.left
    oldBoundaryRight = bounds.right
    oldBoundaryTop = bounds.up
    oldBoundaryBottom = bounds.down
    
    cameraPanSpeed = speed
    cameraPausedWhileScrolling = isPausedWhileScrolling
    
    section.boundary = bounds2
    
    setScrollToArguments(sectionidx)
    
    console:println("Camera scroll activated! Will scroll to the following bounds: "..tostring(leftbound).." (Left) , "..tostring(upbound).." (Up) , "..tostring(downbound).." (Down), "..tostring(rightbound).." (Right).")
end

function Screen.viewPortCoordinateX(x,width)
    return x / 2 - (width * 0.5)
end

function Screen.viewPortCoordinateY(y,height)
    return y / 2 - (height * 0.5)
end

function Screen.changeResolution(width,height)
    if SMBX_VERSION ~= VER_SEE_MOD then
        Misc.warn("You are using the original LunaLua, and not the SEE Mod for this command. Please retrieve the SEE Mod by downloading it over at this website: https://github.com/SpencerEverly/smbx2-seemod")
        console:println("NOT USING SEE MOD! Resolution changer has stopped.")
        return
    else
        if width == nil then
            width = 800
        end
        if height == nil then
            height = 600
        end
        Graphics.setFramebufferSize(width,height)
        camera.width = width
        camera.height = height
        camera:mem(0x10, FIELD_DFLOAT, width)
        camera:mem(0x18, FIELD_DFLOAT, height)
    end
end

function Screen.calculateCameraDimensions(value, isWidthOrHeight)
    if value == nil then
        error("Must have a value for Screen.calculateCameraDimensions!")
        return
    else
        if isWidthOrHeight == nil then
            error("Must have a width or height for Screen.calculateCameraDimensions! You must use a string value for this (Or a number), like e.g. \"width\" or \"height\", or 1 or 2.")
            return
        end
        local originalWidth = 800
        local originalHeight = 600
        
        local pixelDifferenceWidth = originalWidth / camera.width
        local pixelDifferenceHeight = originalHeight / camera.height
        
        local additionalWidth = camera.width - originalWidth
        local additionalHeight = camera.height - originalHeight
        
        local extendedWidth = additionalWidth / 2
        local extendedHeight = additionalHeight / 2
        
        if (isWidthOrHeight == "width" or isWidthOrHeight == 1) then
            return value + extendedWidth
        elseif (isWidthOrHeight == "height" or isWidthOrHeight == 2) then
            return value + extendedHeight
        else
            error("This is not a valid value for isWidthOrHeight. You must use a string value for this (Or a number), like e.g. \"width\" or \"height\", or 1 or 2.")
            return
        end
    end
end

function Screen.onDraw()
    if setCameraPosition then --Camera position stuff
        if cameraPausedWhileScrolling then
            Misc.pause()
        end
        --[[for i = 1,Player.count() do
            if Player(i).x + Player(i).width >= boundaryRight then
                if Player(i).y <= boundaryBottom then
                    tempBool = true
                    table.insert(Screen.playersOutOfBounds, Player(i))
                end
            end
            if not tempBool then
                
            end
        end]]
        for section, state in pairs(Screen.activeCameraScrolls) do
            local x1, y1, y2, x2 = Screen.getSectionBounds(section)
            
            local dX1 = state.x1 - x1
            local dY1 = state.y1 - y1
            local dX2 = state.x2 - x2
            local dY2 = state.y2 - y2
            
            if (dX1 == 0) and (dX2 == 0) and (dY1 == 0) and (dY2 == 0) then
                Screen.activeCameraScrolls[section] = nil
            else        
                dX1 = math.min(math.max(-state.xs, dX1), state.xs)
                dX2 = math.min(math.max(-state.xs, dX2), state.xs)
                dY1 = math.min(math.max(-state.ys, dY1), state.ys)
                dY2 = math.min(math.max(-state.ys, dY2), state.ys)
                
                x1 = x1 + dX1
                x2 = x2 + dX2
                y1 = y1 + dY1
                y2 = y2 + dY2
                Screen.setSectionBounds(section, x1, y1, y2, x2)
            end
        end
        if camera.x == boundaryLeft then
            local section = player.sectionObj
            local bounds = section.boundary
            bounds.left = boundaryLeft
            bounds.right = boundaryRight
            bounds.top = boundaryTop
            bounds.bottom = boundaryBottom
            section.boundary = bounds
            cameraPanTimer = 0
            if cameraPausedWhileScrolling then
                Misc.unpause()
            end
            setCameraPosition = false
        end
    end
    if Screen.debug then
        Text.printWP("CURSOR X/Y POS:", 100, 80, 0)
        Text.printWP(Screen.cursorX(), 100, 100, 0)
        Text.printWP(Screen.cursorY(), 100, 120, 0)
        Text.printWP("CAMERA CONTROL ON: "..setCameraPosition, 100, 140, 0)
    end
end

return Screen