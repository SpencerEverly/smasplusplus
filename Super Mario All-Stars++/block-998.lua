local customCamera = require("customCamera")
local blockManager = require("blockManager")

local cameraBlocker = {}
local blockID = BLOCK_ID


local cameraBlockerSettings = {
	id = blockID,

	sizeable = true,
	passthrough = true,
}

blockManager.setBlockSettings(cameraBlockerSettings)


customCamera.blockerID = blockID


return cameraBlocker