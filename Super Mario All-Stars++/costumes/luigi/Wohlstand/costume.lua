local costume = {}

function costume.onInit()
    registerEvent(costume, "onDraw");
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(5)) do
        v.width = 22;
        v.height = 38;
    end
end

return costume;