local npc = {}
local id = NPC_ID
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")

local settings = {
    id = id,
    
    gfxwidth = 48,
    gfxheight = 96,
    
    width = 48,
    height = 96,
    
    frames = 2,
    hurtframes=2,
    framespeed = 4,
    
    jumphurt = true,
    spinjumpsafe = true,
    
    noiceball = true,
    noyoshi= true,
    
    cliffturn = true,
    
    hp = 3,
    hurttime = 64,
    
    headMaxLen = 10,
    headMaxFire = 4,
    headFireTimer = 10,
    headFireSpeed = 3,

    fireId = 778,
    
    effect = 752,
}

local headTexture = Graphics.loadImageResolved('npc-' .. id .. '-head.png')
local bodyTexture = Graphics.loadImageResolved('npc-' .. id .. 'e.png')

local IDLE = 0
local HURT = 1

function npc.onCameraDrawNPC(v)
    if v.despawnTimer <= 0 then return end
    
    if v:mem(0x138, FIELD_WORD) == 8 then return end
    
    if v:mem(0x138, FIELD_WORD) ~= 0 then
        npcutils.drawNPC(v, {
            frame = 0,
            texture = bodyTexture,
            width = bodyTexture.width,
        })
    end
    
    local data = v.data._basegame
    local config = NPC.config[id]
    
    if not data.init then return end
    
    for k, head in ipairs(data.heads) do
        local h = headTexture.height / 2
        local w = headTexture.width / (config.hurtframes + 1)
        
        Graphics.drawImageToSceneWP(
            headTexture, 
            v.x - head.x - (v.width / 2 - 2), v.y + head.y,
            w * data.hurt_frame,    h * ((head.x ~= 0 and data.state ~= HURT and 1) or 0),
            w,                        h,
            -46
        )
    end
    
    local texture = Graphics.sprites.npc[id].img
    
    if data.hurt_frame ~= 0 then
        npcutils.drawNPC(v, {
            sourceX = (texture.width / (config.hurtframes + 1)) * data.hurt_frame,
            frame = (data.frame >= config.frames * 4 and 0) or (data.frame >= config.frames and data.frame % config.frames) or data.frame,
        })
    end
end

local function init(v, data)
    if not data.init then
        if v.friendly then
            data.friendly = true
        end
    
        data.heads = {
            {time = math.random(-32,0), time2 = 0, state = 0, x = 0, y = 0, fire = 0},
            {time = math.random(-32,0), time2 = 0, state = 0, x = 0, y = 32, fire = 0},        
        }
        
        data.frame = 0
        data.frametimer = 0
        
        data.hurt_frame = 0
        data.hurt_frametimer = 0
        
        data.state = 0
        data.time = 0
        data.hp = NPC.config[id].hp
        
        data.init = true
    end
end

local function animation(v)
    local data = v.data._basegame
    local config = NPC.config[id]
    
    data.frametimer = (data.frametimer + 1)
    if data.frametimer >= config.framespeed then
        data.frame = data.frame + 1
        data.frametimer = 0
    end
    
    v.animationFrame = (data.frame >= config.frames * 4 and 0) or (data.frame >= config.frames and data.frame % config.frames) or data.frame
    
    if data.frame >= config.frames * 8 then
        data.frame = 0
    end
    
    if data.hurt_frame ~= 0 then
        v.animationFrame = -1
    end
end

local function heads(v)
    local data = v.data._basegame
    local config = NPC.config[id]
    
    for k, head in ipairs(data.heads) do
        if data.state == HURT then
            head.time = 0
        end
        
        head.time = head.time + 1
        
        if head.state == 0 then
            if head.time > 24 then
                head.x = head.x + 0.25
                
                if head.x >= config.headMaxLen then
                    local random = math.random(0, 32)
                    local max = config.headMaxFire
                    
                    if random >= 8 then
                        head.fire = math.floor(math.random(max / 2, max + 0.6))
                    elseif random < 8 then
                        head.fire = math.floor(math.random(1, max + 0.6))                
                    end
                    
                    head.time2 = config.headFireTimer - 1
                    head.time = 0
                    head.state = 1
                end
                
                if head.fire ~= 0 then
                    head.time2 = (head.time2 + 1)
                    
                    if head.time2 >= config.headFireTimer then
                        SFX.play(42)
                        
                        do
                            local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
                            
                            local startX = p.x + p.width / 2
                            local startY = p.y + p.height / 2
                            local X = v.x + v.width / 2
                            local Y = v.y + v.height / 2
                            
                            local angle = math.atan2((Y - startY), (X - startX))
                            
                            local fire = NPC.spawn(config.fireId, v.x - head.x - (v.width / 2 - 2), v.y + head.y, v.section)
                            fire.speedX = -config.headFireSpeed * math.cos(angle)
                            fire.speedY = -config.headFireSpeed * math.sin(angle)
                            fire.friendly = v.friendly
                            fire.layerName = "Spawned NPCs"
                            fire.despawnTimer = 100
                        end
                        
                        head.time2 = 0
                        
                        head.fire = (head.fire - 1)
                        
                        if head.fire <= 0 then
                            head.time = 0
                            head.state = 1
                        end
                    end
                end
            end
        else
            head.x = head.x - 0.1
            
            if head.x <= 0 then
                head.time = math.random(-8,0)
                head.state = 0
            end
        end
        
        head.x = math.clamp(head.x, 0, config.headMaxLen)
    end
end

function npc.onTickEndNPC(v)    
    if Defines.levelFreeze or v.despawnTimer <= 0 then return end
    
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        if v:mem(0x138, FIELD_WORD) ~= 8 then
            v.animationFrame = -1
        end
        
        return
    end
    
    if v.despawnTimer > 1 and v.legacyBoss then
        v.despawnTimer = 100
        
        local section = Section(v.section)
        
        if section.musicID ~= 6 and section.musicID ~= 15 and section.musicID ~= 21 then
            Audio.MusicChange(v.section, 15)
        end
    end
    
    
    local data = v.data._basegame
    local config = NPC.config[id]
    init(v, data)
    
    if not data.friendly then
        v.friendly = (data.state == HURT)
    end
    
    v.speedX = 0.25 * v.direction
    
    heads(v)
    animation(v)
    
    if data.state == HURT then
        v.speedX = 0
        
        data.hurt_frametimer = (data.hurt_frametimer + 1)
        
        if data.hurt_frametimer >= 8 then
            data.hurt_frame = ((data.hurt_frame) + 1) % (config.hurtframes + 1)
            data.hurt_frametimer = 0
        end
        
        if data.hurt_frame <= 0 then
            data.hurt_frame = 1
        end
        
        data.time = (data.time + 1)
        
        if data.time >= config.hurttime then
            data.time = 0
            data.state = IDLE
            data.hurt_frame = 0
            data.hurt_frametimer = 0
            
            for k, head in ipairs(data.heads) do
                head.fire = 0
                head.state = 1
                head.time = 0
            end
        end
    end
end

function npc.onNPCHarm(e, v, r, o)
    if v.id ~= id then return end
    
    if r == 9 or r == HARM_TYPE_LAVA then return end
    
    local data = v.data._basegame
    local hp = data.hp
    
    if hp >= 0 then
        if data.state ~= HURT then
            SFX.play(extrasounds.sound.sfx[39])
            
            if (r == HARM_TYPE_NPC and o and o.id ~= 13) or r == HARM_TYPE_HELD or r == HARM_TYPE_PROJECTILE_USED or r == HARM_TYPE_SWORD then
                if o and o.id ~= 13 then
                    o.speedX = 4 * -v.direction
                    o.speedY = -3
                end
                
                data.time = 0
                data.state = HURT
                data.hp = data.hp - 1
            elseif (r == HARM_TYPE_NPC and o and o.id == 13) then
                data.hp = data.hp - 0.25    
            end
        end
        
        e.cancelled = true
    else
        local e = Effect.spawn(NPC.config[id].effect, v.x, v.y)
        e.speedX = 4 * -v.direction
        e.speedY = -8
        
        if v.legacyBoss then
            local ball = NPC.spawn(41, v.x, v.y, v.section)
            ball.x = ball.x + ((v.width - ball.width) / 2)
            ball.y = ball.y + ((v.height - ball.height) / 2)
            ball.speedY = -6
            ball.despawnTimer = 100
            
            SFX.play(41)
        end
    end
end

function npc.onInitAPI()
    local nm = require 'npcManager'
    
    nm.setNpcSettings(settings)
    
    nm.registerHarmTypes(id,
        {
            HARM_TYPE_NPC,
            HARM_TYPE_PROJECTILE_USED,
            HARM_TYPE_SWORD,
            HARM_TYPE_LAVA
        },
        {
            [HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5}
        }
    );

    nm.registerEvent(id, npc, 'onCameraDrawNPC')
    nm.registerEvent(id, npc, 'onTickEndNPC')
    registerEvent(npc, 'onNPCHarm')
end

return npc