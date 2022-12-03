local npc = {}

local id = NPC_ID
local childId = (id - 1)

local bloopers = require("bloopers")

local function spawnChild(v, c)
    local n = NPC.spawn(childId, v.x, v.y)
    n.data._basegame.parent = v
    n.data._basegame.count = c
    
    return n
end

bloopers.register{
    id = id,
    
    behavior = function(v, data)
        data.children = data.children or {
            spawnChild(v, 1),
            spawnChild(v, 2),
            spawnChild(v, 3),
        }
    end,
}

return npc