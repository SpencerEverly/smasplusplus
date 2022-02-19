local level_dependencies_normal= require("level_dependencies_normal")

local hudshow = true

local HUDimage = Graphics.loadImage("level-hud.png")

function onDraw()
	if hudshow then
		--Graphics.drawImageWP(HUDimage, 0, 0, 4)
	end
end