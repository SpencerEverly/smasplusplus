local playerManager = require("playerManager")

local costume = {}

local eventsRegistered = false

function costume.onInit(p)
    Routine = require("routine")
    Routine.run(costumechange)
    eventsRegistered = true
end

function costumechange()
    Routine.wait(0)
    yoshi = require("yiYoshi/yiYoshi")
    yoshi.initCharacter()
    Player.setCostume(10, nil)
end

function costume.onCleanup(p)
    Player.setCostume(10, nil)
end

return costume