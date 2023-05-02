--autoscroll.lua
--v1.0.5
--Created by Rednaxela, 2015
--Edited by Spencer Everly

if (not API.isLoadingShared()) then
    Misc.warning("autoscroll API should be loaded shared")
end

local autoscroll = {}
local active_scrolls = {}
local GM_CAMERA_X = mem(0x00B2B984, FIELD_DWORD)
local GM_CAMERA_Y = mem(0x00B2B9A0, FIELD_DWORD)
local GM_ORIG_LVL_BOUNDS = mem(0x00B2587C, FIELD_DWORD)


--Deferring events if they're called "too early" so that the camera has time to catch up
local preOnCameraDraw = true
local shouldDiscardOnCameraDraw = false

local deferredEvents = {}

local function deferEvent(thisFunction, thisArgs)
    table.insert(deferredEvents, {func=thisFunction, args=thisArgs})
end


local function getCameraXY(playerIdx)
    local x = -mem(GM_CAMERA_X + playerIdx * 0x8, FIELD_DFLOAT)
    local y = -mem(GM_CAMERA_Y + playerIdx * 0x8, FIELD_DFLOAT)
    return x, y
end
autoscroll.getCameraXY = getCameraXY

local function getOrigSectionBounds(section)
    local ptr    = GM_ORIG_LVL_BOUNDS + 0x30 * section
    local left   = mem(ptr + 0x00, FIELD_DFLOAT)
    local top    = mem(ptr + 0x08, FIELD_DFLOAT)
    local bottom = mem(ptr + 0x10, FIELD_DFLOAT)
    local right  = mem(ptr + 0x18, FIELD_DFLOAT)
    return left, top, bottom, right
end

local function getSectionBounds(section)
    local bounds = Section(section).boundary
    return bounds.left, bounds.top, bounds.bottom, bounds.right
end

local function setSectionBounds(section, left, top, bottom, right)
    local sectionObj = Section(section)
    local bounds = sectionObj.boundary
    bounds.left = left
    bounds.top = top
    bounds.bottom = bottom
    bounds.right = right
    sectionObj.boundary = bounds
end

function autoscroll.onInitAPI()
    if (Player.count() >= 1) then
        registerEvent(autoscroll, "onTick")
        registerEvent(autoscroll, "onCameraDraw")
        registerEvent(autoscroll, "onExit")
    end
end

local function transiton(from, to, deadline)
    return from + (to - from) / deadline
end

function autoscroll.onTick()
    --Text.print("bao", 100, 150)
    
    if shouldDiscardOnCameraDraw then
        shouldDiscardOnCameraDraw = false
    end
    
    if not Playur.inForcedState() then
        for section, state in pairs(active_scrolls) do
            local x1, y1, y2, x2 = getSectionBounds(section)
            
            local dX1 = state.x1 - x1
            local dY1 = state.y1 - y1
            local dX2 = state.x2 - x2
            local dY2 = state.y2 - y2
            
            if (dX1 == 0) and (dX2 == 0) and (dY1 == 0) and (dY2 == 0) then
                active_scrolls[section] = nil
            else        
                dX1 = math.min(math.max(-state.xs, dX1), state.xs)
                dX2 = math.min(math.max(-state.xs, dX2), state.xs)
                dY1 = math.min(math.max(-state.ys, dY1), state.ys)
                dY2 = math.min(math.max(-state.ys, dY2), state.ys)
                
                x1 = x1 + dX1
                x2 = x2 + dX2
                y1 = y1 + dY1
                y2 = y2 + dY2
                setSectionBounds(section, x1, y1, y2, x2)
            end
        end
    end
end

function autoscroll.onCameraDraw()
    if preOnCameraDraw then
        preOnCameraDraw = false
        for k,v in ipairs(deferredEvents) do
            v.func(v.args[1], v.args[2], v.args[3], v.args[4], v.args[5], v.args[6])
        end
        deferredEvents = {}
        shouldDiscardOnCameraDraw = true
    end
end

function autoscroll.lockScreen(playerIdx)
    if preOnCameraDraw then
        deferEvent(autoscroll.lockScreen, {playerIdx})
        return
    end
    playerIdx = playerIdx or 1
    local section = Player(playerIdx).section
    local x1, y1 = getCameraXY(playerIdx)
    local x2, y2 = x1 + 800, y1 + 600 -- Incompatible with split-screen
    setSectionBounds(section, x1, y1, y2, x2)
    active_scrolls[section] = nil
end

function autoscroll.scrollRight(speed, boundary, section)
    if preOnCameraDraw then
        deferEvent(autoscroll.scrollRight, {speed, boundary, section})
        return
    end

    if section == nil then section = player.section end
    
    local x1, y1, y2, x2 = getOrigSectionBounds(section)
    if boundary == nil then
        boundary = x2
    end
    
    x1, y1, y2, x2 = getSectionBounds(section)

    if player.section == section then
        local c = camera
        x1 = c.x
    elseif Player.count() >= 2 then
        if player2.section == section then
            local c = camera2
            x1 = c.x
        end
    end
    
    x2 = x1 + 800
    setSectionBounds(section, x1, y1, y2, x2)
    
    x2 = boundary
    x1 = x2 - 800
    
    autoscroll.scrollToBox(x1, y1, x2, y2, speed, section)
end

function autoscroll.scrollLeft(speed, boundary, section)
    if preOnCameraDraw then
        deferEvent(autoscroll.scrollLeft, {speed, boundary, section})
        return
    end
    if section == nil then section = player.section end
    
    local x1, y1, y2, x2 = getOrigSectionBounds(section)
    if boundary == nil then
        boundary = x1
    end
    
    x1, y1, y2, x2 = getSectionBounds(section)

    if player.section == section then
        local c = camera
        x2 = c.x + c.width
    elseif Player.count() >= 2 then
        if player2.section == section then
            local c = camera2
            x2 = c.x + c.width
        end
    end
    
    x1 = x2 - 800
    setSectionBounds(section, x1, y1, y2, x2)
    
    x1 = boundary
    x2 = x1 + 800
    
    autoscroll.scrollToBox(x1, y1, x2, y2, speed, section)
end

function autoscroll.scrollUp(speed, boundary, section)
    if preOnCameraDraw then
        deferEvent(autoscroll.scrollUp, {speed, boundary, section})
        return
    end
    if section == nil then section = player.section end
    
    local x1, y1, y2, x2 = getOrigSectionBounds(section)
    if boundary == nil then
        boundary = y1
    end
    
    x1, y1, y2, x2 = getSectionBounds(section)

    if player.section == section then
        local c = camera
        y2 = c.y + c.height
    elseif Player.count() >= 2 then
        if player2.section == section then
            local c = camera2
            y2 = c.y + c.height
        end
    end
    
    y1 = y2 - 600
    setSectionBounds(section, x1, y1, y2, x2)
    
    y1 = boundary
    y2 = y1 + 600
    
    autoscroll.scrollToBox(x1, y1, x2, y2, speed, section)
end

function autoscroll.scrollDown(speed, boundary, section)
    if preOnCameraDraw then
        deferEvent(autoscroll.scrollDown, {speed, boundary, section})
        return
    end
    if section == nil then section = player.section end
    
    local x1, y1, y2, x2 = getOrigSectionBounds(section)
    if boundary == nil then
        boundary = y2
    end
    
    x1, y1, y2, x2 = getSectionBounds(section)
    
    if player.section == section then
        local c = camera
        y1 = c.y
    elseif Player.count() >= 2 then
        if player2.section == section then
            local c = camera2
            y1 = c.y
        end
    end
    
    y2 = y1 + 600
    setSectionBounds(section, x1, y1, y2, x2)
    
    y2 = boundary
    y1 = y2 - 600
    
    autoscroll.scrollToBox(x1, y1, x2, y2, speed, section)
end

function autoscroll.scrollTo(left, bottom, speed, section)
    if preOnCameraDraw then
        deferEvent(autoscroll.scrollTo, {left, bottom, speed, section})
        return
    end
    if section == nil then section = player.section end
    
    local x1, y2 = left, bottom
    local x2 = x1 + 800
    local y1 = y2 - 600
    
    if (speed ~= nil) and (speed ~= 0) and (section == player.section) then
        autoscroll.lockScreen(1)
    end
    autoscroll.scrollToBox(x1, y1, x2, y2, speed, section)
end    

function autoscroll.scrollToBox(gX1, gY1, gX2, gY2, speed, section)
    if preOnCameraDraw then
        deferEvent(autoscroll.scrollToBox, {gX1, gY1, gX2, gY2, speed, section})
        return
    end
    if section == nil then section = player.section end
    
    if speed == nil or speed <= 0 then    
        setSectionBounds(section, gX1, gY1, gY2, gX2)
        active_scrolls[section] = nil
        return
    end
    
    local x1, y1, y2, x2 = getSectionBounds(section)
    local dX1 = gX1 - x1
    local dY1 = gY1 - y1
    local dX2 = gX2 - x2
    local dY2 = gY2 - y2
    local avgDX = (math.abs(dX1) + math.abs(dX2)) * 0.5
    local avgDY = (math.abs(dY1) + math.abs(dY2)) * 0.5
    local avgD = math.sqrt(avgDX * avgDX + avgDY * avgDY)
    if (avgD > speed) then
        local factor = speed / avgD
        avgDX = factor * avgDX
        avgDY = factor * avgDY
    end
    
    active_scrolls[section] = {x1=gX1, y1=gY1, x2=gX2, y2=gY2, xs=avgDX, ys=avgDY}
end

function autoscroll.unlockSection(section, speed)
    if section == nil then section = player.section end
    if speed == nil or speed == 0 then return end
    
    local x1, y1, y2, x2 = getOrigSectionBounds(section)
    if speed == nil or speed <= 0 then    
        setSectionBounds(section, x1, y1, y2, x2)
        active_scrolls[section] = nil
        return
    end
    
    active_scrolls[section] = {x1=x1, y1=y1, x2=x2, y2=y2, xs=speed, ys=speed}
end

function autoscroll.isSectionScrolling(section)
    if section == nil then section = player.section end
    return (active_scrolls[section] ~= nil)
end

return autoscroll
