local npcManager = require("npcManager")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    width = 64,
    gfxwidth = 64,
    height = 64,
    gfxheight = 64,
    
    frames=8,
    
    jumphurt = true,
    nohurt = true,
    grabtop = true,
    
    npcblock = true,
    npcblocktop = true,
    playerblock = true,
    playerblocktop = true,
    
    harmlessgrab=true,
    harmlessthrown=true,
    
    stop = 3,
})

function npc.onInitAPI()
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

function npc.onTickEndNPC(v)
    if v:mem(0x136, FIELD_BOOL) and v:mem(0x12E, FIELD_WORD) < 30 then
        v.ai1 = 1
    end
    
    if v.ai1 == 1 then
        if v.collidesBlockBottom then
            Effect.spawn(755, v.x, v.y)
            local e = Effect.spawn(761, v.x, v.y + v.height / 2)
            e.speedY = -6
            e.speedX = v.speedX / 2
            
            Misc.doPOW()
            v.y = v.y - 1
            v.speedY = -6
            
            v.ai2 = v.ai2 + 1
            v.ai3 = 12
        end
    end
    
    if v.ai2 >= NPC.config[id].stop + 1 then
        v:kill(9)
    end
    
    if v.ai3 > 0 then
        v.ai3 = v.ai3 -1
        v.animationFrame = -1
    end
end

return npc