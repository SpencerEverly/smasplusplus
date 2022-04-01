local costume = {}

function costume.onInit()
	registerEvent(costume, "onDraw");
end

function costume.onDraw()
	for _,v in ipairs(Animation.get(152)) do
		v.width = 39;
		v.height = 42;
	end
end

function costume.onCleanup(playerObject)
end

return costume;