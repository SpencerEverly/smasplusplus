local npcManager = require("npcManager")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    frames = 1,
    
    width = 288,
    height = 272,
    gfxwidth = 288,
    gfxheight = 272,
    
    nogravity = true,
    noblockcollision = true,
    
    jumphurt = true,
    
    appearTime = 96,
    vspeed = 16,
})

function npc.onInitAPI()
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
    npcManager.registerEvent(id, npc, 'onCameraDrawNPC')
end

local IDLE = 0
local APPEAR = 1
local DOWN = 2
local UP = 3

local npcutils = require 'npcs/npcutils'

function npc.onCameraDrawNPC(v)
    if v.despawnTimer <= 0 then return end
    
    local config = NPC.config[id]
    
    local distance = (v.height - config.height)
    
    for y = 0, distance do
        npcutils.drawNPC(v, {
            frame = 0,
            yOffset = -y + config.height - 16,
            sourceY = y % config.height,
            height = 1,
            priority = -75,
        })
    end
    
    npcutils.drawNPC(v, {
        frame = 0,
        sourceX = config.gfxwidth,
        yOffset = config.height - 32,
        priority = -75,
    })
    
    -- Graphics.drawBox{
        -- x = v.x,
        -- y = v.y,
        -- width = v.width,
        -- height = v.height,
        
        -- sceneCoords = true,
        -- color = Color.white .. 0.5,
    -- }
end

function npc.onTickEndNPC(v)
    if v.despawnTimer <= 0 then return end
    
    local config = NPC.config[id]
    
    v.ai1 = v.ai1 + 1
    
    if v.ai2 == IDLE then
        if v.ai1 >= config.appearTime then
            v.ai2 = APPEAR
            v.ai1 = 0
        end
    elseif v.ai2 == APPEAR then
        if v.ai1 < 48 then
            v.height = v.height + 0.5
        else
            v.ai2 = DOWN
            v.ai1 = 0
        end
    elseif v.ai2 == DOWN then
        v.height = v.height + config.vspeed / 2
        
        if v.ai1 >= 4 then
            for k,b in Block.iterateIntersecting(v.x, v.y + v.height - 16, v.x + v.width, v.y + v.height) do
                local invis1 = b:mem(0x5A, FIELD_WORD)
                local invis2 = b.isHidden
                local cfg = Block.config[b.id]
                
                if not invis2 and invis1 >= 0 and ((cfg.npcfilter ~= -1 and cfg.npcfilter ~= v.id) and not cfg.passthrough) then
                    v.ai2 = UP
                    v.ai1 = 0
                    Defines.earthquake = 10
                    v.height = v.height - config.vspeed / 2

                    SFX.play(37)
                    return
                end
            end
        end
    elseif v.ai2 == UP then
        if v.ai1 >= 48 then
            v.height = v.height - config.vspeed
            
            if v.height < config.height then
                v.ai1 = 0
                v.ai2 = IDLE
                v.height = config.height
            end
        end
    end
    
    v.speedX = v.layerObj.speedX
    v.animationFrame = -1
end

return npc