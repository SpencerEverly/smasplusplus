local npc = {}
local npcManager = require("npcManager")

local id = NPC_ID

npcManager.setNpcSettings{
    id = id,
    
    noyoshi = true,
    noiceball = true,
    
    gfxwidth = 84,
    gfxheight = 64,
    width = 44,
    height = 52,
    
    score = 0,
    
    ringId = id + 1,
    hp = 3,
    effect = 771,
    
    transform = 805,
}

local function animation(v)
    local data = v.data._basegame
    
    data.frame = 0
    
   if(v.ai1 == 0) then
        if(v.speedY == 0) then
            if(v.speedX == 0) then
                data.frame = 0;
            else
            
                data.frametimer = data.frametimer + 1;
                if(data.frametimer < 8) then
                    data.frame = 0;
                elseif(data.frametimer < 16) then
                    data.frame = 1;
                else
                
                    data.frame = 0;
                    data.frametimer = 0;
                end
            end
        else
            data.frame = 1;
        end
    elseif(v.ai1 == 1) then
        data.frametimer = data.frametimer + 1;
        if(data.frametimer < 2) then
            data.frame = 2;
        elseif(data.frametimer < 4) then
            data.frame = 3;
        elseif(data.frametimer < 6) then
            data.frame = 4;
        elseif(data.frametimer < 8) then
            data.frame = 5;
        else
            data.frame = 2;
            data.frametimer = 0;
        end
    elseif(v.ai1 == 2) then
        data.frametimer = data.frametimer + 1;
        if(data.frametimer < 2) then
            data.frame = 6;
        elseif(data.frametimer < 4) then
            data.frame = 7;
        elseif(data.frametimer < 6) then
            data.frame = 8;
        elseif(data.frametimer < 8) then
            data.frame = 9;
        else
            data.frame = 6;
            data.frametimer = 0;
        end
    end
    
    if(v.direction == 1) then
        data.frame = data.frame + 10;
    end
    
    v.animationFrame = data.frame
end

--i'll just port some part of nsmbx's wendy ai
local function ai(v)
    local config = NPC.config[id]
    
    v.ai5 = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2).idx
    
    local p = Player(v.ai5)
    
    local px = p.x + p.width / 2
    local vx = v.x + v.width / 2
    
    v.direction = (px < vx and -1) or 1
    
    if v.ai2 == 0 then
        v.ai2 = v.direction
    end
    
    if v.ai1 == 0 then
        if v.ai2 == -1 then
            v.speedX = -2.5
        else
            v.speedX = 2.5
        end
        
        if v.collidesBlockLeft or v.collidesBlockRight then
            v.ai2 = -v.ai2
        end
        
        if v.x < p.x - 400 then
            v.ai2 = 1
        elseif v.x > p.x + 400 then
            v.ai2 = -1
        end
        
        if v.collidesBlockBottom then
            v.ai4 = v.ai4 + 1
            if v.ai4 >= 100 + math.random(100) then
                v.ai1 = 1
                v.ai5 = 0
                v.ai3 = 0
                v.ai4 = 0
            end
            
            v.ai3 = v.ai3 + 1
            if v.ai3 >= 30 + math.random(100) then
                v.ai3 = 0
                v.speedY = -5 - math.random(4)
            end
        else
            v.ai3 = 0
        end
    elseif v.ai1 == 1 then
        v.direction = (px < vx and -1) or 1
        
        v.ai2 = v.direction
        v.speedX = 0
        v.ai3 = v.ai3 + 1
        if v.ai3 >= 10 then
            v.ai3 = 0
            v.ai1 = 2
        end
    elseif v.ai1 == 2 then
        v.speedX = 0
        v.ai3 = v.ai3 + 1
        
        if v.ai3 == 3 then
            SFX.play(34)
            
            local ring = NPC.spawn(config.ringId, v.x, v.y)
            ring.direction = v.direction
            ring.x = ring.x + ((v.width - ring.width + 20) or -20)
            ring.y = ring.y - v.height / 2
            ring.despawnTimer = 100
            ring.layerName = "Spawned NPCs"
            ring.speedX = 4 * ring.direction
            ring.speedY = -4
        end
        
        if v.ai3 >= 30 then
            v.ai4 = 0
            v.ai1 = 0
            v.ai5 = 0
            v.ai3 = 0
        end
    end
end

function npc.onTickEndNPC(v)
    local data = v.data._basegame
    data.frame = data.frame or 0
    data.frametimer = data.frametimer or 0
    data.hp = data.hp or NPC.config[id].hp
    
    ai(v)
    animation(v)
end

function npc.onNPCHarm(e, v, r, c)
    if v.id ~= id then return end
    
    local cancelled = true
    
    -- // B = 1      Jumped on by a player (or kicked)
    -- // B = 2      Hit by a shaking block
    -- // B = 3      Hit by projectile
    -- // B = 4      Hit something as a projectile
    -- // B = 5      Hit something while being held
    -- // B = 6      Touched a lava block
    -- // B = 7      Hit by a tail
    -- // B = 8      Stomped by Boot
    -- // B = 9      Fell of a cliff
    -- // B = 10     Link stab
    
    local data = v.data._basegame
    local config = NPC.config[id]
    
    
    if data.hp <= 0 then
        SFX.play(63)
        
        Effect.spawn(config.effect, v.x, v.y)
        
        e.cancelled = false
        return
    end
    
    if r == 1 or r == 2 or r == 8 or r == 3 then
        local hp = data.hp
        local d = 1
        
        if r == 1 or r == 8 then
            SFX.play(2)
        end
        
        if r == 3 and c then
            if c.id == 13 or c.id == 108 then
                SFX.play(9)
                d = 0.25
                e.cancelled = true
                
                return
            end
            
            SFX.play(39)
        end
        
        v.speedX = 0
        v.speedY = 0
        v:transform(config.transform)
        v.data._basegame.immune = 10
        v.data._basegame.hp = hp - d
    elseif r == 10 then
        data.hp = data.hp - 2
        SFX.play(89)
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