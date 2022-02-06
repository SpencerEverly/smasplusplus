local pm = require("playerManager")
local lib3d = require("lib3d")
local steve = require("steve")

local costume = {}

function costume.onInit(p)        
    steve.skinSettings.name = "stultus"
    steve.loadMeshes()
end

function costume.onCleanup(p)
    steve.skinSettings.name = "steve"
    steve.loadMeshes()
end

return costume;