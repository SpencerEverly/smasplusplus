local costume = {}

function costume.onInit()
    registerEvent(costume, "onDraw");
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(5)) do
        v.width = 28;
        v.height = 62;
    end
end

Misc.storeLatestCostumeData(costume)

return costume;