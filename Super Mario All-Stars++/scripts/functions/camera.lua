local Screen = {}

local customCamera = require("customCamera")
local inspect = require("ext/inspect")

Screen.debug = false

function Screen.onInitAPI()
    registerEvent(Screen,"onDraw")
end

function Screen.x() --Actual X position, with resolution support
    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
    return fullX
end

function Screen.y() --Actual Y position, with resolution support
    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
    return fullY
end

function Screen.width() --Actual width, with resolution support
    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
    return fullWidth
end

function Screen.height() --Actual height, with resolution support
    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
    return fullHeight
end

function Screen.cursorX() --Cursor X position with full resolution support (Used for Steve and cursor.lua)
    local zoom = customCamera.defaultZoom + 1 / 2 - 1
    return mem(0x00B2D6BC, FIELD_DFLOAT)
    --[[elseif SaveData.resolution == "widescreen" then
        return mem(0x00B2D6BC, FIELD_DFLOAT) - (Screen.width()*zoom)*0.5
    else
        return mem(0x00B2D6BC, FIELD_DFLOAT)
    end]]
end

function Screen.cursorY() --Cursor Y position with full resolution support (Used for Steve and cursor.lua)
    local zoom = customCamera.defaultZoom + 1 / 2 - 1
    return mem(0x00B2D6C4, FIELD_DFLOAT)
    --[[elseif SaveData.resolution == "widescreen" then
        return mem(0x00B2D6C4, FIELD_DFLOAT) + (Screen.height()*zoom)*0.5
    else
        return mem(0x00B2D6BC, FIELD_DFLOAT)
    end]]
end

function Screen.isOnScreen(x,y,width,height) --Checks to see if something is on screen
    if x == nil then
        error("You must return an X coordinate.")
        return
    end
    if y == nil then
        error("You must return an Y coordinate.")
        return
    end
    if width == nil then
        error("You must return the width.")
        return
    end
    if height == nil then
        error("You must return the height.")
        return
    end
    return customCamera.isOnScreen(x,y,width,height)
end

local oldBoundaryLeft,oldBoundaryRight,oldBoundaryTop,oldBoundaryBottom = 0,0,0,0
local boundaryLeft,boundaryRight,boundaryTop,boundaryBottom = 0,0,0,0
local setCameraPosition = false
local cameraPanSpeed = 5
Screen.playersOutOfBounds = {}
local tempBool = false

function Screen.setCameraPosition(leftbound,upbound,downbound,rightbound,speed) --This is used to set the camera boundaries for the specific section.
    local plr = player
    local section = plr.sectionObj
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
        speed = 5
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
    
    section.boundary = bounds2
    
    setCameraPosition = true
end

function Screen.onDraw()
    if setCameraPosition then --Camera position stuff
        local section = player.sectionObj
        local bounds = section.boundary
        bounds.left = boundaryLeft
        bounds.right = boundaryRight
        bounds.top = boundaryTop
        bounds.bottom = boundaryBottom
        section.boundary = bounds
        for i = 1,Player.count() do
            if Player(i).x + Player(i).width >= bounds.right then
                if Player(i).y <= bounds.bottom then
                    tempBool = true
                    table.insert(Screen.playersOutOfBounds, Player(i))
                end
            end
        end
        if tempBool == false then
            
        end
        setCameraPosition = false
    end
    if Screen.debug then
        Text.printWP("CURSOR X/Y POS:", 100, 80, 0)
        Text.printWP(Screen.cursorX(), 100, 100, 0)
        Text.printWP(Screen.cursorY(), 100, 120, 0)
        Text.printWP("CAMERA CONTROL ON: "..setCameraPosition, 100, 140, 0)
    end
end

return Screen