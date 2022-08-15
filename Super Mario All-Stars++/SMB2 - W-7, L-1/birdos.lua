local birdos = {}
local npcManager = require("npcManager")
local extrasounds = require("extrasounds")

local idList  = {}
local canHarm = {}

local defaultSettings = {
    width = 32,
    height = 60,
    
    gfxwidth = 40,
    gfxheight = 72,
    gfxoffsetx = 2,
    gfxoffsety = 3,
    
    playerblocktop = true,
    npcblocktop = true,
    
    noiceball = true,
    noyoshi = true,
    
    frames = 0,
    
    score = 7,
    
    eggId = 40,
    fireId = 803,
    eggSfx = 38,
    fireSfx = 16,
    
    canShootFire = false,
    
    shoot = 1,
    hp = 3,
    effect = 29,
}

function birdos.register(config)
    canHarm[config.id] = true
    
    table.insert(idList, config.id)
    local config = table.join(config, defaultSettings)
    npcManager.setNpcSettings(config)
    
    npcManager.registerHarmTypes(config.id, {3, 4, 10, 6}, {
        [HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5}
    })
    
    npcManager.registerEvent(config.id, birdos, "onTickEndNPC")
end

function birdos.onNPCHarm(e, v, r, c)
    if not canHarm[v.id] then return end
    
    local config = NPC.config[v.id]
    local data = v.data._basegame
    
    if data.hp < config.hp then
        if v.ai1 >= 0 then
            if r ~= 6 then
                v.ai1 = -30
                data.hp = data.hp + 1
                v.direction = -v.direction
                    
                SFX.play(extrasounds.sound.sfx[39])
            end
        end
        
        if r ~= 6 then
            e.cancelled = true    
        end
    elseif data.hp >= config.hp - 1 then
        SFX.play(39)
        
        if v.legacyBoss then
            local ball = NPC.spawn(41, v.x, v.y, v.section)
            ball.x = ball.x + ((v.width - ball.width) / 2)
            ball.y = ball.y + ((v.height - ball.height) / 2)
            ball.speedY = -6
            ball.despawnTimer = 100
            
            SFX.play(41)
        end
        
        Effect.spawn(config.effect, v.x, v.y)
        e.cancelled = false
    end
end

local function animation(v)
    v.ai4 = (v.direction == 1 and 5) or 0
    
    if v.ai1 == 0 then
        if v.speedX ~= 0 then
            v.ai5 = (v.ai5 + 1) % 12
            
            if v.ai5 >= 6 then
                v.ai4 = v.ai4 + 1
            end
        end
    elseif v.ai1 < 0 then
        v.ai4 = v.ai4 + 3
        v.ai5 = (v.ai5 + 1) % 8
        
        if v.ai5 >= 4 then
            v.ai4 = v.ai4 + 1
        end
    else
        v.ai4 = v.ai4 + 2
    end
    
    v.animationFrame = v.ai4
end

function birdos.onTickEndNPC(v)
    if Defines.levelFreeze or v.despawnTimer <= 0 then return end
    
    if v.id == 39 then
        if v.ai2 == 124 then
            v.ai3 = v.speedY
        end
        
        if v.ai2 == 125 and not v.collidesBlockBottom then
            v.y = v.y + 1
            v.speedY = v.ai3
            v.ai3 = 0
        elseif v.collidesBlockBottom then
            v.ai3 = 0
        end
        
        return
    end
    
    local config = NPC.config[v.id]        
    local data = v.data._basegame
    
    if v.despawnTimer > 1 and v.legacyBoss then
        v.despawnTimer = 100
        
        local section = Section(v.section)
        
        if section.musicID ~= 6 and section.musicID ~= 15 and section.musicID ~= 21 then
            Audio.MusicChange(v.section, 15)
        end
    end
    
    data.shoot = (data.shoot or 1)
    data.hp = (data.hp or 0)
    
    if v.ai1 >= 0 then
        local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
        
        if (v.x + v.width / 2) > (p.x + p.width / 2) then
            v.direction = -1
        else
            v.direction = 1
        end
        
        v.ai2 = v.ai2 + 1
        if v.ai2 == 125 then
            if v.collidesBlockBottom then
                v.y = v.y - 1
                v.speedY = -5
            end
        elseif v.ai2 == 239 then
            data.shoot = math.floor(math.random(1, config.shoot - 1))
        elseif v.ai2 >= 240 then
            if v.ai2 == 260 then
                local id = config.eggId
                
                if math.random(32) >= 16 and config.canShootFire then
                    id = config.fireId
                end
                
                local egg = NPC.spawn(id, v.x + v.width / 2, v.y + 14, v.section)
                egg.y = egg.y - egg.height / 2
                egg.x = (v.direction == 1 and egg.x) or egg.x - egg.width
                egg.direction = v.direction
                egg.speedX = 4 * egg.direction
                egg.despawnTimer = 100
                egg.ai1 = 1
                egg.friendly = v.friendly
                egg.layerName = "Spawned NPCs"
                
                SFX.play((id == config.eggId and config.eggSfx) or config.fireSfx)
            end
            
            v.ai1 = 1
            
            if v.ai2 > 280 then
                if data.shoot > 0 then
                    data.shoot = data.shoot - 1
                    v.ai2 = 240
                    
                    return
                elseif data.shoot <= 0 then
                    v.ai2 = 0
                    v.ai1 = 0
                end
            end
        end
        
        if v.ai1 == 0 and v.collidesBlockBottom then
            v.ai3 = v.ai3 + 1
            if v.ai3 <= 200 then
                v.speedX = -1
            elseif v.ai3 > 500 then
                v.ai3 = 0
            elseif v.ai3 > 250 and v.ai3 <= 450 then
                v.speedX = 1
            else
                v.speedX = 0
            end
        else
            v.speedX = 0
        end
    else
        v.ai1 = v.ai1 + 1
        v.speedX = 0
    end
    
    animation(v)
end

function birdos.onInitAPI()
    registerEvent(birdos, 'onNPCHarm')
end

npcManager.registerEvent(39, birdos, "onTickEndNPC")
return birdos