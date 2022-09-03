--smasnoturnback.lua
--By Spencer Everly
--This script provides a remake of the noTurnBack option, but with additional things like going left but not turning back right, and other things!

--This is only compatible with customCamera, to support zooming and area stretching. If you want the script without it, remove the customCamera mentions and do this:
--local fullX = camera.x
--local fullY = camera.y

local smasnoturnback = {}

local customCamera = require("customCamera")
local autoscroll = require("autoscroll")

smasnoturnback.enabled = false --Enable this to activate everything here
smasnoturnback.overrideSection = false --Set to true to prevent the turn back on a certain area, useful for onLoadSection(number)
smasnoturnback.turnBack = "left" --Set to 'right' for a no right turn back, or 'up' for a no top turn back, or even 'down' for a no bottom turn back. Anything else accidentally set will be automatically set to 'left'.

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
    registerEvent(smasnoturnback,"onTick")
end

smasnoturnback.failsafeTable = {
    "left",
    "right",
    "up",
    "down",
}

function smasnoturnback.onCameraUpdate()
    for i = 0,20 do
        if not autoscroll.isSectionScrolling(i) then
            if smasnoturnback.enabled and not smasnoturnback.overrideSection then
                for i = 1,4 do
                    if smasnoturnback.turnBack ~= smasnoturnback.failsafeTable[i] then --Failsafe is the turnBack argument is anything else but the things in this script
                        smasnoturnback.turnBack = "left"
                    end
                end
                if smasnoturnback.turnBack == "left" then
                    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
                    if camera.x >= player.sectionObj.boundary.left then
                        local x1 = fullX
                        smasnoturnback.setSectionBounds(player.section, x1, player.sectionObj.boundary.top, player.sectionObj.boundary.bottom, player.sectionObj.boundary.right)
                    end
                elseif smasnoturnback.turnBack == "right" then
                    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
                    if camera.x <= player.sectionObj.boundary.right then
                        local x1 = fullX + 800
                        smasnoturnback.setSectionBounds(player.section, player.sectionObj.boundary.left, player.sectionObj.boundary.top, player.sectionObj.boundary.bottom, x1)
                    end
                elseif smasnoturnback.turnBack == "up" then
                    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
                    if camera.y >= player.sectionObj.boundary.top then
                        local x1 = fullY
                        smasnoturnback.setSectionBounds(player.section, player.sectionObj.boundary.left, x1, player.sectionObj.boundary.bottom, player.sectionObj.boundary.right)
                    end
                elseif smasnoturnback.turnBack == "down" then
                    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
                    if camera.y <= player.sectionObj.boundary.bottom then
                        local x1 = fullY + 600
                        smasnoturnback.setSectionBounds(player.section, player.sectionObj.boundary.left, player.sectionObj.boundary.top, x1, player.sectionObj.boundary.right)
                    end
                end
            end
        end
        if autoscroll.isSectionScrolling(i) then
            smasnoturnback.enabled = false
            smasnoturnback.overrideSection = true
        end
    end
end

local levelTablesWithNoTurnbacks = {
    "levelsGoHere.lvlx",
    "youCanPutAnything.lvlx",
    "inThisTable.lvlx",
    "thatCanHaveANoTurnBack.lvlx",
}

function smasnoturnback.onTick() --If you want a certain level or more, make a table with level filenames on it. A sample table is included above.
    --This is a sample table used for applying no-turn-backs on levels.
    --if table.icontains(levelTablesWithNoTurnbacks,Level.filename()) and not smasnoturnback.overrideSection then
        --smasnoturnback.enabled = true
    --end
    
    
    --These here are episode specific.
    if table.icontains(smastables.__smb1Levels,Level.filename()) and not smasnoturnback.overrideSection then
        smasnoturnback.enabled = true
    end
    if table.icontains(smastables.__smb1Levels,Level.filename()) and not smasnoturnback.overrideSection then
        smasnoturnback.enabled = true
    end
    if table.icontains(smastables.__smbspecialLevels,Level.filename()) and not smasnoturnback.overrideSection then
        smasnoturnback.enabled = true
    end
    
    
    
    if smasnoturnback.overrideSection then
        smasnoturnback.enabled = false
    end
end

return smasnoturnback