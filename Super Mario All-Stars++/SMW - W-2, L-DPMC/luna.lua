local level_dependencies_normal= require("level_dependencies_normal")
local slm = require("simpleLayerMovement")

slm.addLayer{name = "Moving Platforms",speed = 75,horizontalMovement = slm.MOVEMENT_COSINE,horizontalSpeed = 482,horizontalDistance = -1}