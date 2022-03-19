local level_dependencies_normal= require("level_dependencies_normal")
local screenFlip = require("screenFlip/screenFlip")

screenFlip.enabled = false

function onLoadSection0()
	screenFlip.enabled = true
	screenFlip.flipSpeed = 10
	screenFlip.flipDirection = 1
	screenFlip.flipDelay = 256
	screenFlip.warnBeforeFlip = true
end

function onLoadSection1()
	screenFlip.enabled = true
	screenFlip.flipSpeed = 10
	screenFlip.flipDirection = 1
	screenFlip.flipDelay = 500
	screenFlip.warnBeforeFlip = true
end