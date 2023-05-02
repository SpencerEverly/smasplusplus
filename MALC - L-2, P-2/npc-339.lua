-- SMW Wood Platform
local p = {}

local npcManager = require("npcManager")
local lineguide = require("lineguide")
local platforms = require("npcs/ai/platforms")
local npcID = NPC_ID
lineguide.registerNpcs(npcID)

--*************************************************************************
--*
--*                                Settings
--*
--*************************************************************************

npcManager.setNpcSettings(table.join(
    {
        id = npcID, 
        width = 64, 
        height = 50
    }, 
    platforms.basicPlatformSettings
))

lineguide.properties[npcID] = {
    lineSpeed = 6.0, 
    activeByDefault = false, 
    fallWhenInactive = false, 
    activateOnStanding = true, 
    extendedDespawnTimer = true,
    buoyant = true
}

return p
