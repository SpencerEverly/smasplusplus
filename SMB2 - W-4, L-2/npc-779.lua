local npcManager = require("npcManager")
local npc = {}
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    jumphurt = true,

    frames = 2,
    framespeed = 4,
    framestyle = 2,
    
    grabtop = true,
    playerblocktop = true,
    npcblocktop = true,
    
    speed = 1,
})

function npc.onInitAPI()
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
    
    npcManager.registerHarmTypes(id,
        {
            HARM_TYPE_NPC,
            HARM_TYPE_SWORD,
            HARM_TYPE_LAVA,
        }, 
        {
            [HARM_TYPE_NPC] = 763,
            [HARM_TYPE_LAVA]=10,
        }
    );
end

function npc.onTickEndNPC(v)
    if v:mem(0x136, FIELD_BOOL) then
        v.noblockcollision = true
    end
end

return npc