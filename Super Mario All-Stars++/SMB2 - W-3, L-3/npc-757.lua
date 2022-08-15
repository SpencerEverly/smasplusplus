local npc = {}
local id = NPC_ID

-- local npcutils = require("npcs/npcutils")
local playerStun = require("playerstun")

local settings = {
    id = id,
    
    gfxwidth = 70,
    gfxheight = 138,
    
    width = 70,
    height = 112,
    
    frames = 0,
    framespeed = 8,
    
    playerblocktop = true,

    noiceball = true,
    noyoshi = true,
    
    score = 7,
    eggId = id + 1,
    
    effect = 756,
    hp = 5,
    
    hurttime = 96,
}

local IDLE = -1
local WALKS_BACKWARDS = 0
local SHOOTS = 1
local RUNS = 2
local JUMPS = 3
local WALKS = 4
local HURT = 5

function npc.onCameraDrawNPC(v)
    -- if v:mem(0x138, FIELD_WORD) == 8 then return end
    
    -- if v:mem(0x138, FIELD_WORD) ~= 0 then
        -- npcutils.drawNPC(v, {
            -- frame = 0,
            -- texture = bodyTexture,
            -- width = bodyTexture.width,
        -- })
    -- end
end

local function init(v, data)
    if not data.init then
        if v.friendly then
            data.friendly = true
        end

        data.frame = 0
        data.frametimer = 0
        data.direction = nil
        
        data.state = WALKS
        data.time = 0
        data.time2 = 0
        
        data.hp = NPC.config[id].hp
        
        data.init = true
    end
end

local function animation(v)
    local data = v.data._basegame
    local config = NPC.config[id]
    
    data.frame = (data.direction == 1 and 6) or 0
    
    if data.state == WALKS or data.state == RUNS or data.state == WALKS_BACKWARDS then
        data.frametimer = (data.frametimer + 1) % config.framespeed
        
        if data.frametimer >= config.framespeed / 2 then
            data.frame = data.frame + 1
        end
    elseif data.state == JUMPS then
        data.frame = (v.collidesBlockBottom and data.frame + 2) or data.frame
    elseif data.state == SHOOTS then
        data.frame = data.frame + 3
    elseif data.state == HURT then
        data.frametimer = (data.frametimer + 1) % config.framespeed
        data.frame = data.frame + 4

        if data.frametimer >= config.framespeed / 2 then
            data.frame = data.frame + 1
        end    
    end
    
    v.animationFrame = data.frame
end


function npc.onTickEndNPC(v)    
    if Defines.levelFreeze or v.despawnTimer <= 0 then return end
    
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        if v:mem(0x138, FIELD_WORD) ~= 8 then
            v.animationFrame = (v.direction == 1 and 6) or 0
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
    
    data.time = data.time + 1
    data.direction = v.direction
    
    if data.state == WALKS then
        local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
        
        if (v.x + v.width / 2) > (p.x + p.width / 2) then
            v.direction = -1
        else
            v.direction = 1
        end
        
        v.speedX = 2 * v.direction
        
        if data.time >= 80 then
            data.state = (math.random(32) > 16 and JUMPS) or SHOOTS
            data.time = 0
        end
    elseif data.state == JUMPS then
        v.speedX = 0
        
        if data.time == 48 then
            if v.collidesBlockBottom then
                v.y = v.y - 1
                v.speedY = -6
            end
        elseif data.time > 48 then
            if v.collidesBlockBottom then
                if data.time2 == 0 then
                    SFX.play(37)
                    
                    Defines.earthquake = 6
                    
                    local x = v.x - 64
                    local y = v.y + v.height - 64

                    Effect.spawn(755, x, y)
                    Effect.spawn(755, x + v.width + 64, y)
                    
                    if not v.friendly then
                        for k, p in ipairs(Player.get()) do
                            if p:isGroundTouching() and not playerStun.isStunned(k) and v.section == player.section then
                                playerStun.stunPlayer(k, 32)
                            end
                        end
                    end    
                end
                
                data.time2 = data.time2 + 1
            end
        end
        
        if data.time2 >= 48 then
            data.state = RUNS
            data.time = 0
            data.time2 = 0
        end
    elseif data.state == RUNS then
        SFX.play(3, 1, 1, 4)

        v.speedX = 6 * v.direction
        
        if v.collidesBlockLeft or v.collidesBlockRight then
            data.state = WALKS_BACKWARDS
            data.time = 0
        end
    elseif data.state == WALKS_BACKWARDS then
        v.speedX = 2 * v.direction    
        
        data.direction = -data.direction
        
        if data.time >= 160 then
            data.time = 0
            data.state = IDLE
        end
    elseif data.state == IDLE then
        v.speedX = 0
        
        local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
        
        if (v.x + v.width / 2) > (p.x + p.width / 2) then
            v.direction = -1
        else
            v.direction = 1
        end
        
        if data.time >= 48 then
            data.state = WALKS
            data.time = 0
        end
    elseif data.state == SHOOTS then
        v.speedX = 0
        
        if data.time >= (48 * 3) + 24 then
            data.state = JUMPS
            data.time = 0
            return
        end
        
        if (data.time % 48) == 0 then
            local egg = NPC.spawn(config.eggId, v.x, v.y, v.section)
            egg.x = (v.direction == 1 and egg.x + v.width + 4 - egg.width) or egg.x - 4
            egg.y = egg.y + (config.gfxheight - v.height) - (egg.height / 2)
            egg.direction = v.direction
            egg.speedX = 4 * egg.direction
            egg.despawnTimer = 100
            egg.friendly = v.friendly
            egg.layerName = "Spawned NPCs"
                
            SFX.play(38)
        end
    elseif data.state == HURT then
        if data.time >= config.hurttime then
            data.state = RUNS
            data.time = 0
            data.time2 = 0
        end
    end
    
    animation(v)
end

function npc.onNPCHarm(e, v, r, o)
    if v.id ~= id then return end
    
    local data = v.data._basegame
    local hp = data.hp
    
    if hp >= 0 then
        if data.state ~= HURT then
            SFX.play(39)
            
            if r == HARM_TYPE_NPC or r == HARM_TYPE_PROJECTILE_USED or r == HARM_TYPE_SWORD then
                data.time = 0
                data.state = HURT
                data.hp = data.hp - 1
                v.speedX = 0
            end
        end
        
        e.cancelled = true
    else
        local e = Effect.spawn(NPC.config[id].effect, v.x, v.y)
        e.speedX = 0
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
        },
        {

        }
    );

    nm.registerEvent(id, npc, 'onCameraDrawNPC')
    nm.registerEvent(id, npc, 'onTickEndNPC')
    registerEvent(npc, 'onNPCHarm')
end

return npc