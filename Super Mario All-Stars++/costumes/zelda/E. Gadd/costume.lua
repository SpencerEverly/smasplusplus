local costume = {}

local smasFunctions = require("smasFunctions")

function costume.onInit()
    registerEvent(costume, "onDraw");
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(156)) do
        v.width = 30;
        v.height = 38;
    end
end

Misc.storeLatestCostumeData(costume)

return costume;