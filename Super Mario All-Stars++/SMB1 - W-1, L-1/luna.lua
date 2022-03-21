local level_dependencies_normal= require("level_dependencies_normal")

local hudshow = false

local HUDimage = Graphics.loadImage("level-hud.png")

function onDraw()
	if hudshow then
		--Graphics.drawImageWP(HUDimage, 0, 18, -15)
	end
end