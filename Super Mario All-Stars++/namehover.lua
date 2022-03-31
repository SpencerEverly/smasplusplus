local namehover = {}

local ready = false

function namehover.onInitAPI() --This requires all the libraries that will be used
	registerEvent(namehover, "onDraw")
	registerEvent(namehover, "onExit")
	registerEvent(namehover, "onTick")
	
	ready = true
end

function namehover.onDraw()
	Text.printWP("Spencerly", player.x, player.y - 64, 0)
end