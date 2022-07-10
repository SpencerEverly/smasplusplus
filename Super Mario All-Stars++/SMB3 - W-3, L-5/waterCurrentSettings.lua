self = {}

--[[
This is the place where settings for the water currents will be kept. You can change these here, or you can use
local waterCurrentSettings = require("waterCurrentSettings")
and then use waterCurrentSettings.settingName = value
inside of luna.lua if you ever wish to change these dynamically.
]]

self.allowShadowMarioThroughCurrent = false -- Boolean. If true, Shadowstar Mario will be allowed to go through currents without being affected.

self.showBubblesOutsideWater = false -- Boolean. If true, bubbles will also show when outside water.

self.affectOutsideWater = false -- Boolean. If true, will also affect players when outside water.

self.activateDespawnedNPCs = true	-- Boolean. If true, code will also run for despawned water currents.
									-- If you use a lot of them, you might want to turn this off.

self.prewarm = true		-- Boolean. If true, prewarms the current's particles.
						-- Prewarming means that the bubbles will already exist once the npc spawns, unless self.activateDespawnedNPCs is true, in which case the current will always be active.

self.neverCull = false	-- Boolean. If true, particles will NEVER be culled. This means serious performance issues.

self.affectMetal = false -- Boolean. If true, will also affect players who are metal. !YOU NEED MY METAL MARIO THING FOR THIS TO WORK! Download link: https://www.supermariobrosx.org/forums/viewtopic.php?f=101&t=26228

return self