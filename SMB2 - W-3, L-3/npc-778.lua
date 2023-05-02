local npcManager = require("npcManager")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    width = 64,
    gfxwidth = 64,
    height = 8,
    gfxheight = 16,
    
    jumphurt = true,
    nohurt = true,
    
    frames = 8,
    framespeed = 3,
    
    nogravity = true,
    noblockcollision = true,
    noyoshi = true,
    
    speed = 1,
    foreground = true,
    
    npcblocktop = true,
    playerblocktop = true,
    
    maxTime = 600,
})

function npc.onInitAPI()
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

local IDLE = 0
local PIDIGT = 1
local PIDIGT2 = 2
local HOVER = 3

local function init(v, data)
    if not data.init then
        data.direction = v.spawnDirection
        
        if v.ai1 ~= 0 then
            data.npc = NPC.spawn(v.ai1, v.x, v.y, v.section)
            
            data.npc.despawnTimer = v.despawnTimer
            data.npc.spawnDirection = v.direction
            data.npc.y = data.npc.y - data.npc.height
            data.npc.x = data.npc.x + data.npc.width / 2
            
            data.ai1 = PIDIGT
        end
        
        data.init = true
    end
end

function npc.onTickEndNPC(v)
    local data = v.data._basegame
    init(v, data)
    
    local n = data.npc
    
    if v.despawnTimer > 0 then
        v.despawnTimer = 180
    end
    
    if n and n.isValid then
        n.y = v.y - n.height
        n.x = v.x + (v.width - n.width) / 2
        n.noblockcollision = true
        n.speedX = v.speedX
        n.speedY = v.speedY
        
        if v.despawnTimer > 0 then
            n.despawnTimer = v.despawnTimer
        end
        
        if n:mem(0x130, FIELD_WORD) > 0 then
            data.npc = nil
        end
    else
        if data.ai1 == PIDIGT or data.ai1 == PIDIGT2 then
            data.ai1 = IDLE
        end
    end
    
    v.ai2 = v.ai2 + 1

    if data.ai1 == PIDIGT then
        v.speedX = math.cos(v.ai2 / 15) * (2 * data.direction)
        v.speedY = math.sin(v.ai2 / 5)
        
        if v.ai2 > 128 and v.speedY < 0 and v.speedX > -1 and v.speedX < 1 then
            data.ai1 = PIDIGT2
            v.ai2 = 0
            
            v.speedY = 5
        end
    elseif data.ai1 == PIDIGT2 then
        v.speedX = 3 * data.direction
        v.speedY = v.speedY - 0.1
        
        if v.y < v.spawnY then
            data.ai1 = PIDIGT
            v.ai2 = 0
            
            data.direction = -data.direction
        end
    elseif data.ai1 == IDLE then
        v.speedX = 0
        v.speedY = 0
        
        for k,p in ipairs(Player.getIntersecting(v.x, v.y - 2, v.x + v.width, v.y - v.height)) do
            data.ai1 = HOVER
            v.ai2 = 0
        end
    elseif data.ai1 == HOVER then
        local config = NPC.config[id]
        
        if v.ai2 >= config.maxTime / 1.5 then
            if math.random() > 0.5 then
                v.animationFrame = -1
            end
        end
        
        if v.ai2 >= config.maxTime then
            v:kill(9)
        end
        
        for _,p in ipairs(Player.getIntersecting(v.x, v.y - 2, v.x + v.width, v.y - v.height)) do
            local k = p.keys
            
            if k.right then
                v.speedX = v.speedX + 0.1
                
                p.speedX = 0
            elseif k.left then
                v.speedX = v.speedX - 0.1
                
                p.speedX = 0    
            else
                if v.speedX > 0 then
                    v.speedX = v.speedX - 0.25
                else
                    v.speedX = v.speedX + 0.25
                end
                
                if v.speedX >= -0.25 and v.speedX <= 0.25 then
                    v.speedX = 0
                end
            end
            
            if k.up then
                v.speedY = v.speedY - 0.1
            elseif k.down then
                v.speedY = v.speedY + 0.1            
            else
                if v.speedY > 0 then
                    v.speedY = v.speedY - 0.25
                else
                    v.speedY = v.speedY + 0.25
                end
                
                if v.speedY >= -0.25 and v.speedY <= 0.25 then
                    v.speedY = 0
                end
            end
            
            v.speedY = math.clamp(v.speedY, -4, 4)
            v.speedX = math.clamp(v.speedX, -4, 4)
        end
    end
    
    local layer = v.layerObj
    
    v.speedY = v.speedY + layer.speedY
    v.speedX = v.speedX + layer.speedX
    
    if v.despawnTimer > 0 and player.section ~= v.section then
        v:kill(9)
    end
end

return npc