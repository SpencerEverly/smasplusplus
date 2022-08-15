local npc = {}
local npcManager = require("npcManager")
local id = NPC_ID

npcManager.setNpcSettings({
    id = id,
    
    gfxheight = 64,
    height = 64,
    width = 64,
    gfxwidth = 64,
    
    frames = 1,
    
    nogravity = true,
    noblockcollision = true,
    
    jumphurt = true,
    nohurt = true,
    
    noiceball = true,
    noyoshi = true,
    
    isinteractable = true,
})

local READY = 1
local GO = 2

function npc.onNPCKill(e, v, r, c)
    if v.id ~= id then return end
    
    if r == 9 then
        for k,p in ipairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
            if v.ai4 == 0 then
                local data = v.data._basegame
    
                v.ai4 = k
                v.ai2 = READY
                data.effect = Effect.spawn(766, v.x, v.y + v.height)
                p.x = v.x + v.width / 2
                
                SFX.play 'rocket_prepare.spc'
                
                break
            else
                e.cancelled = false
            end
        end
        
        e.cancelled = true
    end
end

function npc.onTickEndNPC(v)
    local settings = v.data._settings
    
    if v:mem(0x130, FIELD_WORD) > 0 then
        local p = Player(v:mem(0x130, FIELD_WORD))
        
        v:mem(0x130, FIELD_WORD, 0)
        p:mem(0x154, FIELD_WORD, -1)
        
        v:kill(9)
    end
    
    local data = v.data._basegame
    
    if v.ai4 > 0 then
        local p = Player(v.ai4)
        
        p.ForcedAnimationState = FORCEDSTATE_INVISIBLE
        
        p.y = v.y + v.height / 2
    end
    
    if v.ai2 == READY then
        data.effect.x = v.x
        
        v.ai1 = v.ai1 + 1
        
        if v.ai1 > 96 then
            v.ai2 = GO
            v.ai1 = 0
            
            data.effect.y = data.effect.y + 9000
            data.effect = Effect.spawn(767, v.x, v.y + v.height)
            
            return
        end
        
        v.speedX = math.cos(lunatime.tick()) * 1.5
    elseif v.ai2 == GO then
        data.effect.x = v.x
        data.effect.y = v.y + v.height
        
        v.speedX = 0
        v.speedY = v.speedY - 0.1
        
        local section = Section(v.section)
        
        if v.section == settings.section then
            v.ai5 = v.ai5 - 0.1
        end
        
        if v.y < section.boundary.top then
            if settings.section == -1 then
                Level.winState(4)
            else
                if v.section ~= settings.section then
                    v.ai5 = v.ai5 + 0.1
                    
                    if v.ai5 > 1 then
                        local newSection = Section(settings.section).boundary
                        
                        v.y = newSection.bottom
                        v.x = newSection.left + 400 - v.width / 2
                        v.section = settings.section
                        
                        local p = Player(v.ai4)
                        
                        p:teleport(v.x, v.y)
                    end
                else
                    data.effect.y = data.effect.y + 9000
                    
                    SFX.play(43)
                    
                    Effect.spawn(69, v.x + v.width / 2, v.y + v.height / 2)
                    
                    local p = Player(v.ai4)
                    
                    p.ForcedAnimationState = 0
                    p.speedX = 0
                    p.speedY = 12
                    p.y = v.y - v.height
                    
                    v.ai4 = 0
                    v:kill(1)
                end
            end
        end
    end
end

function npc.onCameraDrawNPC(v)
    if v.ai4 ~= 0 then
        Graphics.drawScreen{
            color = Color.black .. v.ai5,
        }
    end
end

function npc.onInitAPI()
    registerEvent(npc, 'onNPCKill')
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
    npcManager.registerEvent(id, npc, 'onCameraDrawNPC')
end

return npc