-- SMB3 Wood Platform
local p = {}

local npcManager = require("npcManager")
local lineguide = require("lineguide")
local platforms = require("npcs/ai/platforms")

local npcID = NPC_ID
lineguide.registerNpcs(npcID)

--*************************************************************************
--*
--*								Settings
--*
--*************************************************************************

npcManager.setNpcSettings(table.join({id = npcID}, platforms.thickPlatformSettings))

lineguide.properties[npcID] = {
	lineSpeed = 2,
	activeByDefault = false,
	fallWhenInactive = false,
	activateOnStanding = true,
	extendedDespawnTimer = true,
	buoyant=true
}

return p
