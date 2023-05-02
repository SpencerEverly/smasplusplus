local npc = {}
local npcutils = require("npcs/npcutils")

local id = NPC_ID

local settings = {
    id = id,
    
    frames = 2,
    framespeed = 8,
    framestyle = 1,
    
    width = 32,
    gfxwidth = 32,
    
    height = 56,
    gfxheight = 64,
    
    jumphurt = true,
    nohurt = true,

    speed = 3,
    
    noiceball = true,
    nofireball = true,
    noyoshi = true,
    
    playerblocktop = true,
    npcblocktop = true,
    npcblock = true,
    playerblock = true,
    
    shoottime = 96,
    shootId = id + 1,
}

function npc.onInitAPI()
    local npcManager = require("npcManager")
    
    npcManager.registerHarmTypes(id,
        {
            HARM_TYPE_NPC,
        },
        {
            [HARM_TYPE_NPC] = 759,
        }
    );
    npcManager.setNpcSettings(settings)
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

function npc.onTickEndNPC(v)    
    if Defines.levelFreeze or v.despawnTimer <= 0 then return end
    
    v.speedX = 1 * v.direction
    
    for k,n in NPC.iterateIntersecting(v.x - 1, v.y - 1, v.x + v.width + 1, v.y + 1) do
        if n.idx ~= v.idx and not n.isHidden and v:mem(0x12C, FIELD_WORD) == 0 and not NPC.config[n.id].noblockcollision and not NPC.config[n.id].nogravity then
            v.ai1 = v.ai1 + 1
            
            n.direction = v.direction
            n.x = math.clamp(n.x, v.x, v.x + (n.width - v.width))
        end    
    end
    
    local config = NPC.config[id]
    
    if v.ai1 >= config.shoottime then
        SFX.play(16)
        
        local fire = NPC.spawn(config.shootId, v.x, v.y, v.section)
        fire.x = (v.direction == -1 and fire.x - v.width) or fire.x + v.width
        fire.direction = v.direction
        fire.speedX = 2 * fire.direction
        fire.despawnTimer = 100
        fire.friendly = v.friendly
        fire.layerName = "Spawned NPCs"
        
        v.ai1 = 0
    end
    
    v:mem(0x134, FIELD_WORD, 0)
end

return npc