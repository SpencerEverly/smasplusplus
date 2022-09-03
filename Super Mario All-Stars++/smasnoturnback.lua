local smasnoturnback = {}

local customCamera = require("customCamera")

smasnoturnback.enabled = false
smasnoturnback.overrideSection = false

local GM_CAMERA_X = mem(0x00B2B984, FIELD_DWORD)
local GM_CAMERA_Y = mem(0x00B2B9A0, FIELD_DWORD)
local GM_ORIG_LVL_BOUNDS = mem(0x00B2587C, FIELD_DWORD)

function smasnoturnback.getCameraXY(playerIdx)
    local x = -mem(GM_CAMERA_X + playerIdx * 0x8, FIELD_DFLOAT)
    local y = -mem(GM_CAMERA_Y + playerIdx * 0x8, FIELD_DFLOAT)
    return x, y
end

function smasnoturnback.getOrigSectionBounds(section)
    local ptr    = GM_ORIG_LVL_BOUNDS + 0x30 * section
    local left   = mem(ptr + 0x00, FIELD_DFLOAT)
    local top    = mem(ptr + 0x08, FIELD_DFLOAT)
    local bottom = mem(ptr + 0x10, FIELD_DFLOAT)
    local right  = mem(ptr + 0x18, FIELD_DFLOAT)
    return left, top, bottom, right
end

function smasnoturnback.getSectionBounds(section)
    local bounds = Section(section).boundary
    return bounds.left, bounds.top, bounds.bottom, bounds.right
end

function smasnoturnback.setSectionBounds(section, left, top, bottom, right)
    local sectionObj = Section(section)
    local bounds = sectionObj.boundary
    bounds.left = left
    bounds.top = top
    bounds.bottom = bottom
    bounds.right = right
    sectionObj.boundary = bounds
end

function smasnoturnback.onInitAPI()
    registerEvent(smasnoturnback,"onCameraDraw")
    registerEvent(smasnoturnback,"onCameraUpdate")
    registerEvent(smasnoturnback,"onDraw")
end

function smasnoturnback.onCameraUpdate()
    if smasnoturnback.enabled and not smasnoturnback.overrideSection then
        local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
        if camera.x >= player.sectionObj.boundary.left then
            local x1 = fullX
            smasnoturnback.setSectionBounds(player.section, x1, player.sectionObj.boundary.top, player.sectionObj.boundary.bottom, player.sectionObj.boundary.right)
        end
    end
end

return smasnoturnback