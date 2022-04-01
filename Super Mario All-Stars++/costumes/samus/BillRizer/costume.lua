local costume = {}

function costume.onInit()
	registerEvent(costume, "onDraw");
end

function costume.onDraw()
	for _,v in ipairs(Animation.get(161)) do
		v.width = 46;
		v.height = 64;
	end
end

return costume;