local costume = {}

function costume.onInit()
    registerEvent(costume, "onDraw");
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(154)) do
        v.width = 64;
        v.height = 56;
    end
end

Misc.storeLatestCostumeData(costume)

return costume;