local level_dependencies_normal= require("level_dependencies_normal")

local HUDimage = Graphics.loadImage("level-hud.png")

function onDraw()
	Graphics.drawImageWP(HUDimage, 0, 18, -15)
end