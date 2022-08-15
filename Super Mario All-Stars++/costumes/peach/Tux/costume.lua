local costume = {}

function costume.onInit()
    registerEvent(costume, "onDraw");
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(129)) do
        v.width = 51;
        v.height = 43;
    end
end

return costume;