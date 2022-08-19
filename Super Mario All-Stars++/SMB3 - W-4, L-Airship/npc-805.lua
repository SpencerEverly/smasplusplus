local npc = {}
local npcManager = require("npcManager")

local id = NPC_ID

npcManager.setNpcSettings{
    id = id,
    
    noyoshi = true,
    noiceball = true,
    
    gfxwidth = 44,
    width = 32,
    height = 32,
    gfxheight = 32,
    
    jumphurt = false,
    
    score = 8,
    effect = 771,
    
    transform = 803,
}

local function animation(v)
    local data = v.data._basegame
    
    data.frame = data.frame or 0
    data.frametimer = data.frametimer or 0
    
    data.frametimer = data.frametimer + 1
    
    if data.frametimer >= 4 then
        data.frame = data.frame + v.direction
        data.frametimer = 0
    end
    
    if data.frame < 0 then
        data.frame = 5
    end
    
    if data.frame > 5 then
        data.frame = 0
    end
    
    v.animationFrame = data.frame
end

function npc.onTickEndNPC(v)
    local data = v.data._basegame
    
    data.accel = data.accel or 0
    data.immune = data.immune or 0
    
    if data.immune > 0 then
        data.immune = data.immune - 1
    end
    
    v.ai5 = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2).idx
    
    local p = Player(v.ai5)
    
    local px = p.x + p.width / 2
    local vx = v.x + v.width / 2
    
    if px < v.x then
        v.direction = -1
    else
        v.direction = 1
    end
    
    if v.ai1 == 0 then
        v.ai2 = v.ai2 + 1
        if v.ai2 >= 60 then
            v.ai1 = 1
            v.ai2 = 0
        end
    elseif v.ai1 == 1 then
        data.accel = data.accel + (0.2 * v.direction)
        v.speedX = v.speedX + data.accel
        
        data.accel = math.clamp(data.accel, -5, 5)
        
        v.ai2 = v.ai2 + 1
        
        if v.ai2 >= 300 and v.collidesBlockBottom then
            v.ai1 = 2
            v.ai2 = 0
        end
    elseif v.ai1 == 2 then
        v.speedY = -5 - math.random(3)
        v.ai1 = 3
    else
        if v.speedX > 2.5 then
            v.speedX = v.speedX - 0.2
        elseif v.speedX < -2.5 then
            v.speedX = v.speedX + 0.2
        end
        
        v.ai2 = v.ai2 + 1
        if v.ai2 == 20 then
            local config = NPC.config[id]
            local hp = data.hp
            
            v:transform(config.transform)
            v.data._basegame.hp = hp
        end
    end
    
    animation(v)
end

function npc.onNPCHarm(e, v, r, c)
    if v.id ~= id then return end
    
    local cancelled = true
    
    local data = v.data._basegame
    local config = NPC.config[id]
    
    if data.hp <= 0 then
        SFX.play(63)
        
        Effect.spawn(config.effect, v.x, v.y)
        
        e.cancelled = false
        return
    end
    
    if data.immune > 0 and r ~= 6 then
        e.cancelled = true
        return
    end
    
    if (r == 1 or r == 8) and c then
        SFX.play(2)
        
        c.speedX = 3 * -c.direction
        c.speedY = -c.speedY
    elseif r == 3 or r == 4 or r == 5 and c then
        if c.id == 13 or c.id == 108 then
            data.hp = data.hp - 0.25
            SFX.play(9)
            data.immune = 10
        else
            data.hp = data.hp - 0.5
            SFX.play(39)
            data.immune = 10
        end
    elseif r == 6 then
        cancelled = false
    end
    
    e.cancelled = cancelled
end

function npc.onInitAPI()
    npcManager.registerHarmTypes(id,
        {
            1,
            3,
            4,
            5,
            8,
            6,
        },
        {
            
        }
    )
        
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
    registerEvent(npc, 'onNPCHarm')
end

return npc