local npc = {}
local id = NPC_ID
local yoshis = require 'yoshis'

local yoshi = {
    id = 9,
    npcId = id,
    juiceId = 987,
    
    name = 'ORANGE',
}

yoshi.onInputUpdate = function(v)
    local keys = v.keys
    
    if v:mem(0xB8,FIELD_WORD) > 0 then return end
    
    if keys.run == KEYS_PRESSED and v.speedX == 0 then
        keys.run = false
        
        if v:mem(0xBC, FIELD_WORD) <= 1 then
            v:mem(0xBC, FIELD_WORD, 32)
        end
    elseif keys.run == KEYS_PRESSED and v.speedX ~= 0 then
        if v:mem(0xBC, FIELD_WORD) > 0 then
            keys.run = false
        end
    end
end

yoshi.onTickEnd = function(v)
    if v:mem(0xBC, FIELD_WORD) > 0 then
        local f = 3
        
        if v.direction == 1 then
            f = f + 5
        end
        
        v:mem(0x72, FIELD_WORD, f)
        
        -- juice
        if (v:mem(0xBC, FIELD_WORD) % 4) == 0 then
            local x = (v.direction and v.width) or 0
            x = x + (24 * v.direction)
            x = x - 12
            
            local y = (v.keys.down and -12) or 0
            
            local juice = NPC.spawn(yoshi.juiceId, v.x + x, v.y + 8 + y)
            juice.direction = v.direction
            juice.speedX = 4.75 * juice.direction
            juice.speedY = -1
        end
    end
end

yoshis.registerColor(yoshi)

yoshis.register{
    id = id,
    
    color = 9,
}

return npc