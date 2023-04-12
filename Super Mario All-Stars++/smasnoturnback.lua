--smasNoTurnBack.lua (v1.2)
--By Spencer Everly
--This script provides a remake of the noTurnBack option, but with additional things like going left but not turning back right, and other things!

--This is also compatible with customCamera, and supports zooming and area stretching with it. You don't have to use customCamera to use this library, but just a reminder that it works with it.

local smasNoTurnBack = {}

local customCamera
pcall(function() customCamera = require("customCamera") end)
local autoscroll = require("autoscroll")

smasNoTurnBack.enabled = false --Enable this to activate everything here
smasNoTurnBack.overrideSection = false --Set to true to prevent the turn back on a certain area, useful for onLoadSection(number)
smasNoTurnBack.turnBack = "left" --Set to 'right' for a no right turn back, or 'up' for a no top turn back, or even 'down' for a no bottom turn back. Anything else accidentally set will be automatically set to 'left'.

function smasNoTurnBack.setSectionBounds(section, left, top, bottom, right)
    local sectionObj = Section(section)
    local bounds = sectionObj.boundary
    bounds.left = left
    bounds.top = top
    bounds.bottom = bottom
    bounds.right = right
    sectionObj.boundary = bounds
end

function smasNoTurnBack.onInitAPI()
    registerEvent(smasNoTurnBack,"onStart")
    registerEvent(smasNoTurnBack,"onCameraDraw")
    registerEvent(smasNoTurnBack,"onCameraUpdate")
    registerEvent(smasNoTurnBack,"onDraw")
    registerEvent(smasNoTurnBack,"onTick")
end

smasNoTurnBack.originalBoundariesTop = {}
smasNoTurnBack.originalBoundariesBottom = {}
smasNoTurnBack.originalBoundariesLeft = {}
smasNoTurnBack.originalBoundariesRight = {}

smasNoTurnBack.failsafeTable = {
    "left",
    "right",
    "up",
    "down",
}

function smasNoTurnBack.onStart()
    for i = 0,20 do
        table.insert(smasNoTurnBack.originalBoundariesTop, Section(i).origBoundary.top)
        table.insert(smasNoTurnBack.originalBoundariesBottom, Section(i).origBoundary.bottom)
        table.insert(smasNoTurnBack.originalBoundariesLeft, Section(i).origBoundary.left)
        table.insert(smasNoTurnBack.originalBoundariesRight, Section(i).origBoundary.right)
    end
end

function smasNoTurnBack.onCameraUpdate()
    if not SaveData.disableX2char then
        for k,v in ipairs(Section.getActiveIndices()) do
            if not autoscroll.isSectionScrolling(v) then
                if smasNoTurnBack.enabled and not smasNoTurnBack.overrideSection then
                    for itwo = 1,4 do
                        if smasNoTurnBack.turnBack ~= smasNoTurnBack.failsafeTable[itwo] then --Failsafe if the turnBack argument is anything else but the things in this script
                            smasNoTurnBack.turnBack = "left"
                        end
                    end
                    if smasNoTurnBack.turnBack == "left" then
                        if customCamera then
                            local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
                            if fullX >= player.sectionObj.boundary.left then
                                local x1 = fullX
                                smasNoTurnBack.setSectionBounds(player.section, x1, player.sectionObj.boundary.top, player.sectionObj.boundary.bottom, player.sectionObj.boundary.right)
                            end
                        else
                            local fullX = camera.x
                            if camera.x >= player.sectionObj.boundary.left then
                                local x1 = fullX
                                smasNoTurnBack.setSectionBounds(player.section, x1, player.sectionObj.boundary.top, player.sectionObj.boundary.bottom, player.sectionObj.boundary.right)
                            end
                        end
                    elseif smasNoTurnBack.turnBack == "right" then
                        if customCamera then
                            local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
                            if fullX <= player.sectionObj.boundary.right then
                                local x1 = fullX + 800
                                smasNoTurnBack.setSectionBounds(player.section, player.sectionObj.boundary.left, player.sectionObj.boundary.top, player.sectionObj.boundary.bottom, x1)
                            end
                        else
                            local fullX = camera.x
                            if camera.x <= player.sectionObj.boundary.right then
                                local x1 = fullX + 800
                                smasNoTurnBack.setSectionBounds(player.section, player.sectionObj.boundary.left, player.sectionObj.boundary.top, player.sectionObj.boundary.bottom, x1)
                            end
                        end
                    elseif smasNoTurnBack.turnBack == "up" then
                        if customCamera then
                            local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
                            if fullY >= player.sectionObj.boundary.top then
                                local x1 = fullY
                                smasNoTurnBack.setSectionBounds(player.section, player.sectionObj.boundary.left, x1, player.sectionObj.boundary.bottom, player.sectionObj.boundary.right)
                            end
                        else
                            local fullY = camera.y
                            if camera.y >= player.sectionObj.boundary.top then
                                local x1 = fullY
                                smasNoTurnBack.setSectionBounds(player.section, player.sectionObj.boundary.left, x1, player.sectionObj.boundary.bottom, player.sectionObj.boundary.right)
                            end
                        end
                    elseif smasNoTurnBack.turnBack == "down" then
                        if customCamera then
                            local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
                            if fullY <= player.sectionObj.boundary.bottom then
                                local x1 = fullY + 600
                                smasNoTurnBack.setSectionBounds(player.section, player.sectionObj.boundary.left, player.sectionObj.boundary.top, x1, player.sectionObj.boundary.right)
                            end
                        else
                            local fullY = camera.y
                            if camera.y <= player.sectionObj.boundary.bottom then
                                local x1 = fullY + 600
                                smasNoTurnBack.setSectionBounds(player.section, player.sectionObj.boundary.left, player.sectionObj.boundary.top, x1, player.sectionObj.boundary.right)
                            end
                        end
                    end
                end
            else
                smasNoTurnBack.enabled = false
                smasNoTurnBack.overrideSection = true
            end
        end
    end
end

local levelTablesWithNoTurnbacks = {
    "levelsGoHere.lvlx",
    "youCanPutAnything.lvlx",
    "inThisTable.lvlx",
    "thatCanHaveANoTurnBack.lvlx",
}

function smasNoTurnBack.onTick() --If you want a certain level or more, make a table with level filenames on it. A sample table is included above.
    --This is a sample table used for applying no-turn-backs on levels.
    --if table.icontains(levelTablesWithNoTurnbacks,Level.filename()) and not smasNoTurnBack.overrideSection then
        --smasNoTurnBack.enabled = true
    --end
    
    
    --These here are episode specific.
    if table.icontains(smasTables.__smb1Levels,Level.filename()) and not smasNoTurnBack.overrideSection then
        smasNoTurnBack.enabled = true
    end
    if table.icontains(smasTables.__smbllLevels,Level.filename()) and not smasNoTurnBack.overrideSection then
        smasNoTurnBack.enabled = true
    end
    if table.icontains(smasTables.__smbspecialLevels,Level.filename()) and not smasNoTurnBack.overrideSection then
        smasNoTurnBack.enabled = true
    end
    
    
    
    if smasNoTurnBack.overrideSection then
        smasNoTurnBack.enabled = false
    end
end

function smasNoTurnBack.sectionsWithNoPlayers()
    local nonPlayeredSections = {}
    local playeredSections = Section.getActiveIndices()
    for i = 0,20 do
        if playeredSections[i] ~= i then
            table.insert(nonPlayeredSections, i)
        end
    end
    return nonPlayeredSections
end

function smasNoTurnBack.reviveOriginalBoundaries()
    for k,v in ipairs(smasNoTurnBack.sectionsWithNoPlayers()) do
        if not autoscroll.isSectionScrolling(v) then
            if smasNoTurnBack.enabled and not smasNoTurnBack.overrideSection then
                for _,p in ipairs(Player.get()) do
                    local sectionObj = Section(v)
                    local bounds = sectionObj.boundary
                    bounds.left = smasNoTurnBack.originalBoundariesLeft[v + 1]
                    bounds.top = smasNoTurnBack.originalBoundariesTop[v + 1]
                    bounds.bottom = smasNoTurnBack.originalBoundariesBottom[v + 1]
                    bounds.right = smasNoTurnBack.originalBoundariesRight[v + 1]
                    sectionObj.boundary = bounds
                end
            end
        end
    end
end

function smasNoTurnBack.onDraw()
    for k,v in ipairs(smasNoTurnBack.sectionsWithNoPlayers()) do
        if not autoscroll.isSectionScrolling(v) then
            if smasNoTurnBack.enabled and not smasNoTurnBack.overrideSection then
                for _,p in ipairs(Player.get()) do
                    if p.sectionObj.idx ~= v then
                        local sectionObj = Section(v)
                        local bounds = sectionObj.boundary
                        bounds.left = smasNoTurnBack.originalBoundariesLeft[v + 1]
                        bounds.top = smasNoTurnBack.originalBoundariesTop[v + 1]
                        bounds.bottom = smasNoTurnBack.originalBoundariesBottom[v + 1]
                        bounds.right = smasNoTurnBack.originalBoundariesRight[v + 1]
                        sectionObj.boundary = bounds
                    end
                end
            end
        end
    end
end

return smasNoTurnBack