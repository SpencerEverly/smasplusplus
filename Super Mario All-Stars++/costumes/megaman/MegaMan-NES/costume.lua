local costume = {}

local smasFunctions = require("smasFunctions")

function costume.onInit()
    registerEvent(costume, "onDraw");
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(149)) do
        v.width = 52;
        v.height = 56;
    end
end

Misc.storeLatestCostumeData(costume)

return costume;