local npc = {}
local id = NPC_ID

local bloopers = require("bloopers")
bloopers.register{
    id = id,
    
    width = 16,
    height = 20,
    gfxwidth = 16,
    gfxheight = 20,

    effect = 796,
    
    behavior = function(v, data)
        local p = data.parent
        
        if not p or not p.isValid then return end
        
        data.path = (data.path or {})
        
        table.insert(data.path, 1, {x = p.x, y = p.y, frame = p.animationFrame})
        local distance = 16
        local max = (distance * 3)
        
        if #data.path > max then
            table.remove(data.path)
        end    

        local pos = data.path[math.min (#data.path, distance * data.count)]
        
        v.x = (pos.x + p.width * .5) - v.width * .5
        v.y = (pos.y + p.height * .5) - v.height * .5
        v.animationFrame = pos.frame

        return true
    end
}

return npc