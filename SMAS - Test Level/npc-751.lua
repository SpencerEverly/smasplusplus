local npc = {}
local id = NPC_ID
local settings = {
    id = id,
    
    width = 64,
    height = 64,
    gfxwidth = 64,
    gfxheight = 64,
    
    frames = 8,
    framespeed = 16,
    
    jumphurt = true,
    spinjumpsafe = true,
    noiceball = true,
    noyoshi= true,
    
    walktime = 120,
    picktime = 16,
    holdtime = 24,
    readytime = 32,
    hurttime = 64,
    
    walkspeed = 2,
    cliffturn = true,
    
    grabsfx = 23,
    
    throwsfx = 25,
    throwspeedX = 6,
    throwspeedY = 6,
    throwid = id + 1,
    
    hp = 5,
    score = 0,
    
    effect = 751,
}

local WALKING = 0
local PICKING = 1
local HOLDING = 2
local READY = 3
local HURT = 4

local function init(v)
    local data = v.data._basegame
    
    if not data.init then
        if v.friendly then
            data.friendly = true
        end
        
        if v.ai2 > 0 then
            data.rockID = v.ai2
        end
        
        data.hp = NPC.config[id].hp
        data.time = 0
        data.state = WALKING
        
        data.frame = 0
        data.frametimer = 0
        
        data.init = true
    end
end

local function animation(v)
    local data = v.data._basegame
    
    local config = NPC.config[id]
    
    local walkframes = 2

    local framespeed = (data.state == HURT and 4) or config.framespeed
    
    data.frametimer = data.frametimer + 1
    
    if data.frametimer >= framespeed then
        data.frame = (data.frame + 1)
        
        data.frametimer = 0
    end

    if data.state == PICKING then
        data.frame = (v.direction == -1 and 2) or 3
    elseif data.state == HOLDING then
        data.frame = 4
    elseif data.state == READY then
        data.frame = 5
    elseif data.state == HURT then
        if data.frame < 6 then
            data.frame = 7
        elseif data.frame >= 8 then
            data.frame = 6
        end
    else
        data.frame = data.frame % walkframes
    end
    
    v.animationFrame = data.frame
    v.animationTimer = 0
end

local function throw(v)
    local config = NPC.config[id]
    SFX.play(config.throwsfx)
    
    local rock = NPC.spawn(config.throwid, v.x, v.y, v.section)
    rock.x = rock.x + ((v.width - rock.width) / 2)
    rock.y = rock.y - rock.height
    
    local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
    
    rock.direction = (p.x < 0 and -1) or 1
    
    rock.speedX = config.throwspeedX * rock.direction
    rock.speedY = -config.throwspeedY
    rock.data._basegame.canHurt = true
    rock.friendly = v.friendly
    rock.layerName = "Spawned NPCs"
    rock.despawnTimer = 100
    rock:mem(0x132, FIELD_WORD, 207)
end

local function setState(data, state, time, newState, f)
    if data.state == state then
        if data.time >= time then
            if f then
                f()
            end
            
            data.state = newState
            data.frametimer = 0
            data.time = 0    
        end
    end
end

function npc.onTickEndNPC(v)
    if Defines.levelFreeze or v.despawnTimer <= 0 then return end
    
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        if v:mem(0x138, FIELD_WORD) ~= 8 then
            v.animationFrame = 0
        end
        
        return
    end
    
    local update = true
    
    if v.despawnTimer > 1 and v.legacyBoss then
        v.despawnTimer = 100
        
        local section = Section(v.section)
        
        if section.musicID ~= 6 and section.musicID ~= 15 and section.musicID ~= 21 then
            Audio.MusicChange(v.section, 15)
        end
    end
    
    local config = NPC.config[id]
    local data = v.data._basegame
    init(v)
    
    if not data.friendly then
        v.friendly = (data.state == HURT)
    end
    
    data.time = data.time + 1
    
    if data.state == WALKING then
        v.speedX = config.walkspeed * v.direction
    else
        v.speedX = 0
    end
    
    local rockID = data.rockID
    
    if rockID then
        if data.state == WALKING and data.time >= config.walktime then
            local offset = 1
            
            local x = v.x + (offset * v.direction)
            local y = v.y
            local w = x + v.width
            local h = y + v.height
            
            local count = false
            
            for bid, block in Block.iterateIntersecting(x, y, w, h) do
                local invis1 = block:mem(0x5A, FIELD_WORD)
                local invis2 = block.isHidden
                
                if block.id == rockID and invis1 >= 0 and not invis2 then
                    SFX.play(config.grabsfx)
                        
                    data.state = PICKING
                    data.frametimer = 0
                    data.time = 0
                    
                    v.speedX = 0
                    
                    break
                end
                
                count = true
            end
            
            if not count then
                update = false
            end
        end
    end
    
    if update then
        setState(data, WALKING, config.walktime, PICKING, function()
            SFX.play(config.grabsfx)
        end)
    end
    
    setState(data, PICKING, config.picktime, HOLDING)
    setState(data, HOLDING, config.holdtime, READY)
    setState(data, READY, config.readytime, WALKING, function()
        throw(v)
    end)
    setState(data, HURT, config.hurttime, WALKING)
    
    animation(v)
end

function npc.onNPCHarm(e, v, r, o)
    if v.id ~= id then return end
    
    if r == 9 or r == HARM_TYPE_LAVA then return end
    
    local data = v.data._basegame
    local hp = data.hp
    
    if hp >= 0 then
        if data.state ~= HURT then
            SFX.play(39)
            
            if (r == HARM_TYPE_NPC and o and o.id ~= 13) or r == HARM_TYPE_HELD or r == HARM_TYPE_PROJECTILE_USED or r == HARM_TYPE_SWORD then
                data.time = 0
                data.state = HURT
                data.hp = data.hp - 1
                data.frametimer = 0
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

    nm.registerEvent(id, npc, 'onTickEndNPC')
    registerEvent(npc, 'onNPCHarm')
end

return npc