local costume = {}

function costume.onInit()
	registerEvent(costume, "onDraw");
	
	--[[
	--Breaks other bullets due to non-standard animation.
	npcconfig[13].frames = 6;
	npcconfig[13].width = 22;
	npcconfig[13].height = 22;
	]]
end

function costume.onDraw()
	for _,v in ipairs(Animation.get(149)) do
		v.width = 40;
		v.height = 56;
	end
end

--[[
function costume.onCleanup()
	npcconfig[13].frames = 9;
	npcconfig[13].width = 16;
	npcconfig[13].height = 16;
end]]

return costume;