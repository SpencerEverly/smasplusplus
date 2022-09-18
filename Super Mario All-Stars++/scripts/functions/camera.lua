local Screen = {}

local customCamera = require("customCamera")

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
    return mem(0x00B2D6BC, FIELD_DFLOAT) + (Screen.width()*zoom)*0.5
end

function Screen.cursorY() --Cursor Y position with full resolution support (Used for Steve and cursor.lua)
    local zoom = customCamera.defaultZoom + 1 / 2 - 1
    return mem(0x00B2D6C4, FIELD_DFLOAT) + (Screen.height()*zoom)*0.5
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

return Screen