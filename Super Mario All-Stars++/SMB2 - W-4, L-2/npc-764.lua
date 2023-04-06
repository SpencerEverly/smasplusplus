local npcManager = require("npcManager")
local extrasounds = require("extrasounds")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    gfxheight = 32,
    height = 32,
    width = 32,
    gfxwidth = 32,
    
    frames = 2,
    
    jumphurt = true,
    nohurt = true,
    
    npcblocktop = true,
    playerblocktop = true,
    
    nogravity = true,
    noblockcollision = true,
    
    noiceball = true,
    noyoshi = true,
    
    idleTime = 96,
    stayTime = 160,
})

local IDLE = 0
local UP = 1
local STAY = 2
local DOWN = 3

local npcutils = require("npcs/npcutils")

function npc.onCameraDrawNPC(v)
    if v.despawnTimer <= 0 then return end
    
    local config = NPC.config[id]
    local frame = math.floor(lunatime.tick() / config.framespeed) % config.frames
    
    npcutils.drawNPC(v, {
        frame = frame,
        priority = -75,
    })
    
    for y = v.height, v.ai2 * 32, v.height do
        npcutils.drawNPC(v, {
            frame = frame,
            priority = -75,
            yOffset = y,
            sourceY = config.gfxheight * 2,
        })
    end
end

function npc.onTickEndNPC(v)
    if v.despawnTimer <= 0 then return end
    
    if v.despawnTimer > 0 then
        v.despawnTimer = 180
    end
    
    local data = v.data._basegame
    local config = NPC.config[id]
    local len = v.ai2
    
    if v.friendly and not data.friendly then
        data.friendly = true
        v.friendly = false
    end
    
    if v.ai1 == 0 then
        v.y = v.y + v.height
        v.spawnY = v.y
        
        v.ai1 = 1
    end
    
    v.ai3 = v.ai3 + 1
    
    if v.ai4 == IDLE then
        if v.ai3 >= config.idleTime then
            v.ai4 = UP
            v.ai3 = 0
            
            SFX.play(extrasounds.sounds[119])
        end
    elseif v.ai4 == UP then
        v.speedY = v.speedY - 0.1
        
        if v.y < (v.spawnY - (32 * v.ai2)) then
            v.ai4 = STAY
            v.ai3 = 0
        end
     elseif v.ai4 == STAY then
        v.speedY = -math.sin(lunatime.tick() / 10) / 2
        
        if v.ai3 >= config.stayTime then
            v.ai4 = DOWN
            v.ai3 = 0
        end
    elseif v.ai4 == DOWN then
        for y = 0, v.ai2 * 32, 16 do
            local e = Effect.spawn(760, v.x + v.width / 2 - 8, v.y + y)
            e.speedY = 1
        end
        
        v.y = v.spawnY
        v.speedY = 0
        v.ai4 = IDLE
        v.ai3 = 0
    end
    
    v.animationFrame = -1
    
    if not data.friendly then
        for y = v.height, v.ai2 * 32, v.height do
            for k,p in ipairs(Player.getIntersecting(v.x, v.y + y + 2, v.x + v.width, v.y + y + 2 + v.height)) do
                p:harm()
            end
        end
    end
end

function npc.onInitAPI()
    npcManager.registerEvent(id, npc, 'onCameraDrawNPC')
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc