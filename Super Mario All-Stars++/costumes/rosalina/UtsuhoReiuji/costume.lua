local costume = {}

function costume.onInit()
	registerEvent(costume, "onDraw");
end

function costume.onDraw()
	for _,v in ipairs(Animation.get(154)) do
		v.width = 30;
		v.height = 42;
	end
end

return costume;