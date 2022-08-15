local costume = {}

function costume.onInit()
    registerEvent(costume, "onDraw");
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(149)) do
        v.width = 54;
        v.height = 50;
    end
end

return costume;