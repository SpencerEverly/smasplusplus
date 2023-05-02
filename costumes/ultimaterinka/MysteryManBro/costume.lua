local pm = require("playerManager")
local smasFunctions = require("smasFunctions")

local costume = {}

local eventsRegistered = false

function costume.onInit(p)
    Routine = require("routine")
    Routine.run(costumechange)
    eventsRegistered = true
end

function costumechange()
    Routine.wait(0)
    lib3d = require("lib3d")
    steve = require("steve")
    steve.skinSettings.name = "mysterymanbro"
    steve.loadMeshes()
end

function costume.onCleanup(p)
    lib3d = require("lib3d")
    steve = require("steve")
    steve.skinSettings.name = "steve"
    steve.loadMeshes()
end

Misc.storeLatestCostumeData(costume)

return costume;