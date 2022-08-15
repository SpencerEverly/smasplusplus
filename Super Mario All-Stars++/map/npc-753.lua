--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


smwMap.setObjSettings(npcID,{
    hidden = true,

    onInitObj = (function(v)
        local areaObj = {}

        areaObj.collider = Colliders.Box(v.x - v.width*0.5,v.y - v.height*0.5,v.settings.width,v.settings.height)
        areaObj.restrictCamera = v.settings.restrictCamera

        if v.settings.music == 0 then -- don't change
            areaObj.music = nil
        elseif v.settings.music == 1 then -- none
            areaObj.music = 0
        elseif v.settings.music == 2 then -- custom
            areaObj.music = v.settings.customMusicPath
        else -- some other songs
            areaObj.music = v.settings.music - 2
        end

        areaObj.backgroundName  = v.settings.backgroundName
        areaObj.backgroundColor = v.settings.backgroundColor


        table.insert(smwMap.areas,areaObj)


        v:remove()
    end),
})


return obj