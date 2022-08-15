local pm = require("playerManager")

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
    steve.skinSettings.name = "rondavis"
    steve.loadMeshes()
end

function costume.onCleanup(p)
    lib3d = require("lib3d")
    steve = require("steve")
    steve.skinSettings.name = "steve"
    steve.loadMeshes()
end

return costume;