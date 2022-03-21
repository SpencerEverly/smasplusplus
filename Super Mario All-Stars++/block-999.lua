local customCamera = require("customCamera")
local blockManager = require("blockManager")

local cameraController = {}
local blockID = BLOCK_ID


local cameraControllerSettings = {
	id = blockID,

	sizeable = true,
	passthrough = true,
}

blockManager.setBlockSettings(cameraControllerSettings)


customCamera.controllerID = blockID


return cameraController