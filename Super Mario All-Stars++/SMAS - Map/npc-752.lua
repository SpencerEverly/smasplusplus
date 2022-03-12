--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")

local spline = require("spline")


local npcID = NPC_ID
local obj = {}


local function parseList(str,isNumbers)
    local ret = string.split(str,",")

    -- Remove any spaces
    for k,v in ipairs(ret) do
        v = v:match("^%s*(.+)%s*$")

        -- Convert to a number
        if isNumbers then
            v = tonumber(v)
        end

        ret[k] = v
    end

    return ret
end

local function doLevelPathChecks(pathObj,levelObj,directionName)
    if levelObj.settings["path_".. directionName] ~= pathObj.name then
        return
    end
    

    if levelObj.settings["unlock_".. directionName] == 1 then -- level has "always active" set for this path, so activate this path
        SaveData.smwMap.unlockedPaths[pathObj.name] = true
    end

    if SaveData.smwMap.unlockedPaths[pathObj.name] then -- this path is unlocked, so unlock the level too
        levelObj.lockedFade = 0
    end

    if not pathObj.hideIfLocked then -- this path is NOT set to hide if locked, so make the level match that
        levelObj.hideIfLocked = false
    end
end


smwMap.setObjSettings(npcID,{
    hidden = true,

    onInitObj = (function(v)
        local numbers = parseList(v.settings.points,true)

        -- Convert numbers into vectors (3D, has x,y,index)
        local points = {}

        for i = 1, #numbers, 2 do
            table.insert(points,vector(numbers[i],numbers[i+1],#points+1))
        end


        -- Find types
        local types = parseList(v.settings.types,false)

        types[1] = types[1] or "normal"

        local originalTypeCount = #types

        for i = originalTypeCount + 1, #points do
            types[i] = types[originalTypeCount]
        end


        -- Create a path (spline, name, object)
        local pathObj = {}

        pathObj.splineObj = spline.new{x = v.x,y = v.y,points = points,smoothness = v.settings.smoothness}
        pathObj.splineLength = pathObj.splineObj.length
        pathObj.pointCount = #points

        pathObj.types = types
        pathObj.name = v.settings.name
        pathObj.originalObj = v
        pathObj.hideIfLocked = v.settings.hideIfLocked


        -- Figure out these, for culling
        pathObj.minX = math.huge
        pathObj.minY = math.huge
        pathObj.maxX = -math.huge
        pathObj.maxY = -math.huge

        for distance = 0, pathObj.splineLength, 8 do
            local position = pathObj.splineObj:evaluate(distance / pathObj.splineLength)
            local type = pathObj.types[math.floor(position.z) or "normal"]

            local config = smwMap.getPathConfig(type)
            local width = config.partWidth*0.5 + smwMap.pathSettings.cullingPadding

            pathObj.minX = math.min(position.x - width,pathObj.minX)
            pathObj.minY = math.min(position.y - width,pathObj.minY)
            pathObj.maxX = math.max(position.x + width,pathObj.maxX)
            pathObj.maxY = math.max(position.y + width,pathObj.maxY)
        end


        v.data.pathObj = pathObj

        smwMap.pathsMap[v.settings.name] = pathObj
        table.insert(smwMap.pathsList,pathObj)


        v:remove()
    end),

    onStartObj = (function(v)
        local pathObj = v.data.pathObj
        if pathObj == nil or pathObj.name == "" then
            return
        end


        for _,levelObj in ipairs(smwMap.objects) do
            if smwMap.getObjectConfig(levelObj.id).isLevel then
                doLevelPathChecks(pathObj,levelObj,"up")
                doLevelPathChecks(pathObj,levelObj,"right")
                doLevelPathChecks(pathObj,levelObj,"down")
                doLevelPathChecks(pathObj,levelObj,"left")
            end
        end
    end),
})


return obj