local hearthover = {}

hearthover.active = false

local textplus = require("textplus")
local smbxdefault = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus.ini")

local ready = false

function hearthover.onInitAPI() --This requires all the libraries that will be used
	registerEvent(hearthover, "onDraw")
	registerEvent(hearthover, "onExit")
	registerEvent(hearthover, "onTick")
	
	ready = true
end

function hearthover.onTick()
	if hearthover.active == true then
		if player.powerup == 1 then
			
		end
	end
end

function hearthover.onDraw()
	if hearthover.active == true then
		local namep1 = "<color white>"..GameData.heartstatus.."</color>"
		local name1 = textplus.layout(textplus.parse(namep1, {xscale=1, yscale=1, align="center", color=Color.white..1.0, font=smbxdefault, maxWidth=450}), player.x - camera.x + 16)
		local w = name1.width
		textplus.render{x = player.x - camera.x + 8 - name1.width*0.5, y = player.y - camera.y, layout = name1, priority = -24}
	end
end

return hearthover