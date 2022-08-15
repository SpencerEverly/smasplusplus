local blooper = {}

local npcManager = require("npcManager")

blooper.settings = {
    frames = 2,
    
    jumphurt = true,
}

blooper.harmTypes = {
    {
        -- HARM_TYPE_JUMP,
        HARM_TYPE_FROMBELOW,
        HARM_TYPE_NPC,
        HARM_TYPE_PROJECTILE_USED,
        HARM_TYPE_LAVA,
        HARM_TYPE_HELD,
        HARM_TYPE_TAIL,
        HARM_TYPE_SPINJUMP,
        --HARM_TYPE_OFFSCREEN,
        HARM_TYPE_SWORD
    }, 
    {
        --[HARM_TYPE_JUMP]=10,
        --[HARM_TYPE_FROMBELOW]=10,
        --[HARM_TYPE_NPC]=10,
        --[HARM_TYPE_PROJECTILE_USED]=10,
        [HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
        --HARM_TYPE_HELD]=10,
        --[HARM_TYPE_TAIL]=10,
        --[HARM_TYPE_SPINJUMP]=10,
        --[HARM_TYPE_OFFSCREEN]=10,
        --[HARM_TYPE_SWORD]=10,
    }
}

blooper.idMap = {}

function blooper.register(config)
    local id = config.id

    local harmTypes = blooper.harmTypes
    local config = table.join(config, blooper.settings)
    npcManager.setNpcSettings(config)
    
    local harmEffects = {}
    for k,v in ipairs(harmTypes[1]) do
        if k ~= HARM_TYPE_LAVA and k ~= HARM_TYPE_SWORD then
            harmEffects[k] = (config.effect or 117)
        end
    end
    
    harmEffects[HARM_TYPE_LAVA] = harmTypes[2][HARM_TYPE_LAVA]
    
    npcManager.registerHarmTypes(id, harmTypes[1], harmEffects)
    
    npcManager.registerEvent(id, blooper, 'onTickEndNPC')
    
    local behavior = true
    if config.behavior then
        behavior = config.behavior
    end
    
    blooper.idMap[id] = behavior
end

local function underwater(v)
    return (v.underwater and v:mem(0x04, FIELD_WORD) ~= 2)
end

function blooper.onTickEndNPC(v)
    if Defines.levelFreeze then return end
    local data = v.data._basegame
    
    if v.despawnTimer <= 0 then
        data.player = nil
        return
    end

    local behavior = blooper.idMap[v.id]
    if type(behavior) == 'function' then
        local cancel = behavior(v, data)
        
        if cancel then
            return
        end
    end
    
    if not underwater(v) then
        v.speedX = v.speedX * .7
        
        if v.speedY < -1 then
            v.speedY = -1
        end
        
        v.animationFrame = 0
        
        return
    else
        if math.random() > 0.99 then
            Effect.spawn(113, v.x + v.width * .5, v.y + v.height * .5)
        end
    end
    
    local p = Player.getNearest(v.x + v.width * .5, v.y + v.height * .5)
    
    if p.x + p.width * .5 > v.x + v.width * .5 then
        v.direction = 1
    elseif p.x + p.width * .5 < v.x + v.width * .5 then
        v.direction = -1
    end
    
    if p.y < v.y and v.speedY >= 0 then
        v.speedX = 2 * v.direction
        v.speedY = -4
    end
    
    if v.speedY >= 1 then
        v.animationFrame = 1
        v.speedX = 0
        v:mem(0x18, FIELD_FLOAT, 0)
        v.speedY = 1
    else
        v.animationFrame = 0
    end
end

return blooper