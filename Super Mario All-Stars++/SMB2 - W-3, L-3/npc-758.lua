local npcManager = require("npcManager")

local egg = {}

local npcID = NPC_ID

npcManager.setNpcSettings({
    id=npcID,
    
    width=32,
    
    height=24,
    gfxheight=24,
    
    gfxwidth=32,
    
    frames=1,
    
    jumphurt=true,
    
    npcblock=true,
    playerblocktop = true,
    npcblocktop = true,
    
    grabtop = true,
    
    nofireball=true,
    nogravity = true,
    noblockcollision = true,
})

function egg.onInitAPI()
    npcManager.registerEvent(npcID, egg, "onCameraDrawNPC")
    npcManager.registerEvent(npcID, egg, "onTickEndNPC")
end    

function egg.onCameraDrawNPC(v)
    if v.ai1 ~= 0 then
        Sprite.draw{
            texture = Graphics.sprites.npc[npcID].img,
            
            x = v.x + v.width / 2,
            y = v.y + v.height / 2,
            
            width = v.width + v.ai1,
            height = v.height + v.ai1,
            
            pivot = Sprite.align.CENTRE,
            texpivot = Sprite.align.CENTER,
            sceneCoords = true,
            
            priority = -45,
        }
        
        v.animationFrame = -99
    end
    
    v.ai1 = v.ai1 + 0.5
    v.ai1 = math.clamp(v.ai1, 0, 16)
end

function egg.onTickEndNPC(v)
    if v:mem(0x12C, FIELD_WORD) > 0 then
        v.ai2 = 1
    end
    
    if v.ai2 == 1 then
        v.speedY = v.speedY + 0.3
        
        for k,n in NPC.iterateIntersecting(v.x, v.y, v.x + v.width, v.y + v.height) do
            n:harm(3)
        end
    end
end

return egg