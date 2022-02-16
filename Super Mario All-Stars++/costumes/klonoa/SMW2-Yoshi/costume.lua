local costume = {}
local klonoa = API.load("characters/klonoa");

function costume.onInit()
	registerEvent(costume, "onDraw");
	klonoa.flapAnimSpeed=3;
	
end

function costume.onDraw()
	for _,v in ipairs(Animation.get(152)) do
		v.height = 64;
	end
	
	if(player.holdingNPC) then
		player.holdingNPC.x = player.x-65536;
		player.holdingNPC.y = player.y-65536;
	end
end

function costume.onCleanup(playerObject)
	klonoa.flapAnimSpeed = 6;
end

return costume;