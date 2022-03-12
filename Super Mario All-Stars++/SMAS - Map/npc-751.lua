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
        smwMap.mainPlayer.x = v.x
        smwMap.mainPlayer.y = v.y

        v:remove()
    end),
})


return obj