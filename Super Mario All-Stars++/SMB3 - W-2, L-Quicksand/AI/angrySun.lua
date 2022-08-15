--angrySun_movement.lua by IAmPlayer

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local angrySun = {}

local list = {}

--***************************************************************************************************
--                                                                                                  *
--              DEFAULTS AND NPC CONFIGURATION                                                      *
--                                                                                                  *
--***************************************************************************************************

function angrySun.register(id)
    npcManager.registerEvent(id, angrySun, "onTickNPC")
    registerEvent(angrySun, "onEvent")
    table.insert(list, id)
end

function angrySun.onEvent(eventname)
    for _, v in ipairs(NPC.get(list)) do
        local data = v.data
        
        if eventname == data.eventActivator then
            data.isActive = true
        elseif eventname == data.eventDeactivator then
            data.isActive = false
        end
    end
end

function angrySun.onTickNPC(v)
    --Don't act during time freeze
    if Defines.levelFreeze then return end
    
    local data = v.data
    data.state = data.state or 2 --0 is spinning, 1 is attack, 2 is idle
    data.timer = data.timer or 0
    data.lap = data.lap or 1 --spin boi, spin
    data.x = data.x or 0
    data.y = data.y or 0
    
    data.isActive = (data.isActive or data._settings.isActive) or NPC.config[v.id].isDefaultActive
    data.eventActivator = data.eventActivator or data._settings.active or "angrySun Active"
    data.eventDeactivator = data.eventDeactivator or data._settings.inactive or "angrySun Inactive"
    
    --If despawned
    if v:mem(0x12A, FIELD_WORD) <= 0 then
        --Reset our properties, if necessary
        data.initialized = false
        return
    end

    --Initialize
    if not data.initialized then
        data.initialized = true
    end

    --Depending on the NPC, these checks must be handled differently
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        --Handling
    end
    
    --AI
    --[[if data.isActive then
        data.timer = data.timer + 1
        v:mem(0x12A, FIELD_WORD, 180)
    end
    
    --old
    if data.state == 0 then
        v.animationTimer = 0
        
        if data.timer >= 0 and data.timer < 6 then
            data.y = data.y - 5.333
        elseif data.timer >= 6 and data.timer < 9 then
            data.x = data.x - 5.333 * v.direction
            data.y = data.y - 5.333
        elseif data.timer >= 9 and data.timer < 15 then
            data.x = data.x - 5.333 * v.direction
        elseif data.timer >= 15 and data.timer < 18 then
            data.x = data.x - 5.333 * v.direction
            data.y = data.y + 5.333
        elseif data.timer >= 18 and data.timer < 24 then
            data.y = data.y + 5.333
        elseif data.timer >= 24 and data.timer < 27 then
            data.y = data.y + 5.333
            data.x = data.x + 5.333 * v.direction
        elseif data.timer >= 27 and data.timer < 33 then
            data.x = data.x + 5.333 * v.direction
        elseif data.timer >= 33 and data.timer < 36 then
            data.x = data.x + 5.333 * v.direction
            data.y = data.y - 5.333
        end
        
        if data.timer >= 36 and data.lap == 5 then
            data.timer = 0
            data.lap = 0
            data.state = 1
        elseif data.timer >= 36 and data.lap ~= 5 then
            data.timer = 0
            data.lap = data.lap + 1
        end
    elseif data.state == 1 then
        if data.timer >= 0 and data.timer < 19 then
            data.x = 0
            data.y = 0
        elseif data.timer >= 19 and data.timer < 210 then
            data.x = data.x - 3.328 * v.direction
            data.y = data.y + ((-0.07)*(((data.timer-19)%191)-95))
        elseif data.timer >= 210 then
            v.direction = -v.direction
            
            data.timer = 0
            data.state = 2
        end
    elseif data.state == 2 then
        v.animationTimer = 0
        if data.x ~= 0 or data.y ~= 0 then
            
        end
        
        if data.timer >= 64 then
            data.timer = 0
            data.state = 0
        end
    end
    
    if player.section == v.section then
        if v.direction == DIR_LEFT then
            v.x = camera.x + 64 + data.x
            v.y = camera.y + 120 + data.y
        elseif v.direction == DIR_RIGHT then
            v.x = camera.x + 704 + data.x
            v.y = camera.y + 120 + data.y
        end
    end]]
    
    data.timer = data.timer + 1
    v:mem(0x12A, FIELD_WORD, 180)
    
    if data.state == 0 then
        v.animationTimer = 0
        
        if data.timer >= 0 and data.timer < 6 then
            data.y = data.y - 5.333
        elseif data.timer >= 6 and data.timer < 9 then
            data.x = data.x - 5.333 * v.direction
            data.y = data.y - 5.333
        elseif data.timer >= 9 and data.timer < 15 then
            data.x = data.x - 5.333 * v.direction
        elseif data.timer >= 15 and data.timer < 18 then
            data.x = data.x - 5.333 * v.direction
            data.y = data.y + 5.333
        elseif data.timer >= 18 and data.timer < 24 then
            data.y = data.y + 5.333
        elseif data.timer >= 24 and data.timer < 27 then
            data.y = data.y + 5.333
            data.x = data.x + 5.333 * v.direction
        elseif data.timer >= 27 and data.timer < 33 then
            data.x = data.x + 5.333 * v.direction
        elseif data.timer >= 33 and data.timer < 36 then
            data.x = data.x + 5.333 * v.direction
            data.y = data.y - 5.333
        end
        
        if data.timer >= 36 and data.lap == 5 then
            data.timer = 0
            data.lap = 0
            data.state = 1
        elseif data.timer >= 36 and data.lap ~= 5 then
            data.timer = 0
            data.lap = data.lap + 1
        end
    elseif data.state == 1 then
        if data.timer >= 0 and data.timer < 19 then
            data.x = 0
            data.y = 0
        elseif data.timer >= 19 and data.timer < 210 then
            data.x = data.x - 3.328 * v.direction
            data.y = data.y + ((-0.07)*(((data.timer-19)%191)-95))
        elseif data.timer >= 210 then
            v.direction = -v.direction
            
            data.timer = 0
            data.state = 2
        end
    elseif data.state == 2 then
        v.animationTimer = 0
        data.x = 0
        data.y = 0
            
        if data.timer >= 64 then
            data.timer = 0
            data.state = 0
        end
    end
    
    if v.direction == DIR_LEFT then
        v.x = camera.x + 64 + data.x
        v.y = camera.y + 120 + data.y
    elseif v.direction == DIR_RIGHT then
        v.x = camera.x + 704 + data.x
        v.y = camera.y + 120 + data.y
    end
    
    --Text.print(data.x..", "..data.y, 100, 100)
end

return angrySun