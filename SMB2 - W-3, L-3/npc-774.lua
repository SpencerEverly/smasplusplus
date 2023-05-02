local npcManager = require("npcManager")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    width = 64,
    gfxwidth = 64,
    height = 32,
    gfxheight = 32,
    
    playerblocktop = true,
    npcblocktop = true,
    
    jumphurt = true,
    nohurt = true,
    
    frames = 4,
    
    nogravity = true,
    noblockcollision = true,
    
    noiceball = true,
    noyoshi = true,
})

function npc.onInitAPI()
    npcManager.registerEvent(id, npc, 'onCameraDrawNPC')
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

function npc.onCameraDrawNPC(v)
    if v.despawnTimer <= 0 then
        return
    end
    
    local config = NPC.config[id]
    
    Graphics.drawBox{
        texture = Graphics.sprites.npc[id].img,
        
        x = v.x + config.gfxoffsetx + v.width / 2,
        y = v.y + config.gfxoffsety + v.height / 2,
        
        sourceY = v.height * v.ai2,
        sourceHeight = v.height,
        
        sceneCoords = true,
        priority = -45,
        rotation = math.sin(v.ai3 / 5) * v.ai3,
        centered = true,
    }
end

function npc.onTickEndNPC(v)
    v.animationFrame = (v.ai3 <= 0 and v.ai2) or -1
    
    for k,p in ipairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
        if p.deathTimer <= 0 then
            if v.ai3 <= 0 then
                v.ai3 = 48
            end
        end
    end
    
    if v.ai3 > 0 then
        v.ai3 = v.ai3 - 1
    end
end

return npc