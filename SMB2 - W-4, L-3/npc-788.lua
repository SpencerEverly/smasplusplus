local npc = {}

local id = NPC_ID

function npc.onInitAPI()
    local npcManager = require("npcManager")

    registerEvent(npc, 'onNPCHarm')
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
    npcManager.setNpcSettings({
        id=id,
        width=32,
        height=32,
        gfxheight=64,
        gfxwidth=32,
        framestyle=2,
        framespeed=4,
        frames=2,
        
        npcblocktop = true,
        npcblock = true,
        playerblocktop = true,
        grabtop = true,
        
        foreground = true,
    })
    
    npcManager.registerHarmTypes(id,
        {
            HARM_TYPE_NPC,
            HARM_TYPE_SWORD,
            HARM_TYPE_LAVA,
        }, 
        {
            [HARM_TYPE_NPC] = 765,
            [HARM_TYPE_LAVA]=10,
        }
    );
end

local function init(v)
    local data = v.data._basegame
    
    if not data.init then
        if v.ai1 ~= 0 then
            data.npc = NPC.spawn(v.ai1, v.x, v.y)
            data.npc.y = v.y - data.npc.height
        end
        
        data.init = true
    end
end

function npc.onNPCHarm(e, v, r, c)
    if v.id ~= id then return end
    
    local data = v.data._basegame
    local n = data.npc
    
    if n and n.isValid then
        n:kill(r)
    end
end

function npc.onTickEndNPC(v)
    if v.despawnTimer <= 0 then return end
    
    if v.despawnTimer > 0 then
        v.despawnTimer = 180
    end
    
    local data = v.data._basegame
    init(v)
    
    local n = data.npc
    
    if n and n.isValid and n.id ~= 263 then
        local fs = v:mem(0x138, FIELD_WORD)
        local ft = v:mem(0x13C, FIELD_WORD)
        local ftt = v:mem(0x144, FIELD_WORD)
        
        n:mem(0x138, FIELD_WORD, fs)
        n:mem(0x13C, FIELD_WORD, ft)
        n:mem(0x144, FIELD_WORD, ftt)
        
        n.x = v.x + (v.width - n.width) / 2
        n.y = v.y - n.height
        n.noblockcollision = true
        n.speedX = v.speedX
        n.speedY = v.speedY
        n.despawnTimer = v.despawnTimer
        
        if n:mem(0x130, FIELD_WORD) > 0 then
            data.npc = nil
        end
        
        local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
        
        if (p.x + p.width / 2) > (v.x + v.width * 3) then
            v.direction = 1
        elseif (p.x + p.width / 2) < (v.x - v.width * 3) then
            v.direction = -1
        end
    end
    
    if v.collidesBlockBottom then
        v.speedY = -3
    end
    
    v.speedX = 3 * v.direction
end
    
return npc