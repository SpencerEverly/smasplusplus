local npcManager = require("npcManager")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    width = 64,
    gfxwidth = 64,
    height = 64,
    gfxheight = 64,
    
    jumphurt = true,
    nohurt = true,
    
    frames = 1,
    
    idleTime = 96,
    maxLen = 96,
    
    nogravity = true,
    noblockcollision = true,
    
    speed = 5,
    
    blockId = 38
})

function npc.onInitAPI()
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
    npcManager.registerEvent(id, npc, 'onCameraDrawNPC')
end

function npc.onCameraDrawNPC(v)
    if v.despawnTimer <= 0 then return end
    
    local img = Graphics.sprites.npc[id].img
    local b = v.data._basegame.block
    
    Graphics.drawBox{
        texture = img,
        
        x = b.x + ((96 - v.width) / 2),
        y = v.y,
        height = (b.y + b.height) - v.y,
        
        sceneCoords = true,
        priority = -45,
    }
end

local IDLE = 0
local UP = 1
local DOWN = 2

function npc.onTickEndNPC(v)
    local data = v.data._basegame
    local config = NPC.config[id]
    
    data.block = data.block or Block.spawn(config.blockId, v.x - ((96 - v.width) / 2), v.y - 96)
    data.block.width = 96
    data.block.height = 96
    data.block.isHidden = v.isHidden
    
    local b = data.block
    
    if b:collidesWith(player) == 1 then
        if v.ai1 <= 0 and v.ai3 == IDLE then
            v.ai3 = UP
            
            SFX.play(24)
        end
    end
    
    if v.ai3 == UP then
        v.ai1 = v.ai1 + config.speed
        
        b:translate(0, -config.speed)
        b.speedY = -config.speed * 2
        
        if v.ai1 >= v.ai2 + 48 then
            v.ai3 = DOWN
        end
    elseif v.ai3 == DOWN then
        v.ai1 = v.ai1 - config.speed / 4
        
        b:translate(0, config.speed / 4)
        b.speedY = config.speed / 4
        
        if v.ai1 < config.speed / 4 then
            v.ai1 = 64
            v.ai3 = IDLE
        end
    elseif v.ai3 == IDLE then
        if v.ai1 > 0 then
            v.ai1 = v.ai1 - 1
        end
    end
    
    local layer = v.layerObj
    
    b.speedX = b.speedX + layer.speedX
    
    b:translate(layer.speedX, layer.speedY)
    
    v.animationFrame = -1
    v.y = v.spawnY
end

return npc