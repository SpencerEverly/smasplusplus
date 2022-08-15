--[[

    See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")

local yoshi = require("yiYoshi/yiYoshi")


local egg = {}


egg.collectableIDList = {}
egg.collectableIDMap  = {}

function egg.registerCollectable(id)
    npcManager.registerEvent(id,egg,"onTickNPC","onTickCollectable")
    
    table.insert(egg.collectableIDList,id)
    egg.collectableIDMap[id] = true
end


function egg.onTickCollectable(v)
    if Defines.levelFreeze
    or v.despawnTimer <= 0
    or v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136,FIELD_BOOL)         --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then return end
    
    if v.collidesBlockBottom and not v.noblockcollision then
        v.speedX = 0
    end
end


function egg.onPostNPCKill(v,reason)
    if egg.collectableIDMap[v.id] and npcManager.collected(v,reason) then
        yoshi.giveEgg(v.id)
        SFX.play(72)
    end
end


egg.thrownIDList = {}
egg.thrownIDMap  = {}

function egg.registerThrown(id)
    npcManager.registerEvent(id,egg,"onTickEndNPC","onTickEndThrown")
    npcManager.registerEvent(id,egg,"onDrawNPC","onDrawThrown")

    table.insert(egg.thrownIDList,id)
    egg.thrownIDMap[id] = true
end


local HIT_SIDE_TOP     = 1
local HIT_SIDE_BOTTOM  = 2
local HIT_SIDE_RIGHT   = 3
local HIT_SIDE_LEFT    = 4
local HIT_SIDE_UNKNOWN = 5

local function getHitSide(v,other)
    if v.y+v.height-v.speedY <= other.y-other.speedY then
        return HIT_SIDE_TOP
    elseif v.y-v.speedY >= other.y+other.height-other.speedY then
        return HIT_SIDE_BOTTOM
    elseif v.x+v.width-v.speedX <= other.x-other.speedX then
        return HIT_SIDE_RIGHT
    elseif v.x-v.speedX >= other.x+other.width-other.speedX then
        return HIT_SIDE_LEFT
    else
        return HIT_SIDE_UNKNOWN
    end
end


-- Handle bouncing, thanks to seta for helping!
local function objIsSolid(v,obj)
    local side = getHitSide(v,obj)

    if type(obj) == "Block" then
        local blockConfig = Block.config[obj.id]

        if blockConfig.passthrough then
            return false
        end

        if (blockConfig.semisolid or blockConfig.sizeable) and side ~= HIT_SIDE_TOP then
            return false
        end

        if blockConfig.npcfilter == -1 or blockConfig.npcfilter == v.id then
            return false
        end

        return true
    elseif type(obj) == "NPC" then
        local npcConfig = NPC.config[obj.id]

        if npcConfig.npcblock then
            return true
        elseif npcConfig.playerblocktop then
            return (side == HIT_SIDE_TOP)
        end

        return false
    end
end


local function harmNPC(npc,...) -- npc:harm but it returns if it actually did anything
    local oldKilled     = npc:mem(0x122,FIELD_WORD)
    local oldProjectile = npc:mem(0x136,FIELD_BOOL)
    local oldHitCount   = npc:mem(0x148,FIELD_FLOAT)
    local oldImmune     = npc:mem(0x156,FIELD_WORD)
    local oldID         = npc.id
    local oldSpeedX     = npc.speedX
    local oldSpeedY     = npc.speedY

    npc:harm(...)

    return (
           oldKilled     ~= npc:mem(0x122,FIELD_WORD)
        or oldProjectile ~= npc:mem(0x136,FIELD_BOOL)
        or oldHitCount   ~= npc:mem(0x148,FIELD_FLOAT)
        or oldImmune     ~= npc:mem(0x156,FIELD_WORD)
        or oldID         ~= npc.id
        or oldSpeedX     ~= npc.speedX
        or oldSpeedY     ~= npc.speedY
    )
end


local function breakEgg(v,data,config,mimicConfig)
    if mimicConfig.hitFunction ~= nil then
        mimicConfig.hitFunction(v,npc)
    end

    SFX.play(egg.hitSound)

    if mimicConfig.crackEffectID ~= nil then
        local e = Effect.spawn(mimicConfig.crackEffectID,v.x+v.width*0.5,v.y+v.height)

        e.x = e.x - e.width*0.5
        e.y = e.y - e.height
    end

    v:kill(HARM_TYPE_VANISH)
end


local function doBouncing(v,data,config,mimicConfig)
    local col = Colliders.getHitbox(v)

    col.x = col.x + data.speed.x - 1
    col.y = col.y + data.speed.y - 1
    col.width  = col.width  + 2
    col.height = col.height + 2


    local blocks = Colliders.getColliding{a = col,btype = Colliders.BLOCK}
    local npcs = Colliders.getColliding{a = col,btype = Colliders.NPC}

    -- Handle solid block/NPC hitting
    local solidsList = table.append(blocks,npcs)

    -- Hit stuff, and removing any nonsolid blocks
    for i = #solidsList, 1, -1 do
        local obj = solidsList[i]
        local isSolid = objIsSolid(v,obj)

        -- Hit stuff!
        if type(obj) == "Block" and isSolid then
            if obj.contentID == 0 and obj.id == 90 then
                obj:hit()
                isSolid = false

                SFX.play(3)
            elseif obj.id == 370 or obj.contentID == 0 and Block.MEGA_SMASH_MAP[obj.id] then
                obj:remove(true)
                isSolid = false
                SFX.play(extrasounds.sound.sfx[4])
            else
                obj:hit()
            end
        end

        -- If nonsolid, do not keep for the raycast
        if not isSolid then
            table.remove(solidsList,i)
        end
    end


    -- Handle bouncing
    local hit,hitPoint,hitNormal,hitObj

    if solidsList[1] ~= nil then
        hit,hitPoint,hitNormal,hitObj = Colliders.raycast(vector(v.x+v.width*0.5 - data.speed.x,v.y+v.height*0.5 - data.speed.y),data.speed * math.max(v.width,v.height) * 2,solidsList)
    end



    -- Hurt NPC's
    local hitNPCs = Colliders.getColliding{a = v,b = NPC.HITTABLE,btype = Colliders.NPC}

    for _,npc in ipairs(hitNPCs) do
        if npc:mem(0x138,FIELD_WORD) ~= 5 and npc:mem(0x138,FIELD_WORD) ~= 6 then
            local hurtNPC = harmNPC(npc,HARM_TYPE_NPC)

            if hurtNPC then
                breakEgg(v,data,config,mimicConfig)
                return
            end
        end
    end

    -- Rescue baby
    if yoshi.playerData.babyMario.state == yoshi.BABY_STATE.BUBBLE and yoshi.playerData.babyMario.collider:collide(v) then
        yoshi.rescueBaby()

        breakEgg(v,data,config,mimicConfig)
        return
    end


    local bounced = false


    if hit and hitNormal ~= vector.zero2 then
        data.speed = -2*(data.speed.. hitNormal)*hitNormal + data.speed
        bounced = true
    end

    if bounced then
        data.bounces = data.bounces + 1
        
        data.mimicID = mimicConfig.bounceNPCID or data.mimicID

        SFX.play(egg.bounceSounds[data.bounces] or egg.bounceSounds[#egg.bounceSounds],0.75)

        if data.bounces > config.maxBounces then
            if mimicConfig.fallEffectID ~= nil then
                local e = Effect.spawn(mimicConfig.fallEffectID,v.x+v.width*0.5,v.y+v.height)

                e.x = e.x - e.width*0.5
                e.y = e.y - e.height
            end

            v:kill(HARM_TYPE_VANISH)
            return
        end
    end
end


local function doBigEggPOW(v)
    local combo = 2

    for _,npc in NPC.iterate(NPC.HITTABLE) do
        if npc ~= v and npc.id > 0 then
            -- Hurt the NPC, and make sure to not give the automatic score
            local oldScore = NPC.config[npc.id].score
            NPC.config[npc.id].score = 0

            local hurtNPC = harmNPC(npc,HARM_TYPE_NPC,15)
            
            NPC.config[npc.id].score = oldScore

            
            if hurtNPC then
                Misc.givePoints(combo,{x = npc.x+npc.width*0.5,y = npc.y+npc.height*0.5},true)
                combo = math.min(10,combo + 1)

                if combo >= 10 then
                    SFX.play(extrasounds.sound.sfx[15])
                end
            end
        end
    end

    for _,block in Block.iterateIntersecting(camera.x,camera.y,camera.x+camera.width,camera.y+camera.height) do
        if not block.isHidden then
            if block.contentID == 0 and not block:mem(0x5A,FIELD_BOOL) and block.id ~= 90 and Block.MEGA_SMASH_MAP[block.id] then
                block:remove(true)
            else
                block:hit()
            end
        end
    end

    Defines.earthquake = 16
    SFX.play(37)
end


function egg.onTickEndThrown(v)
    if Defines.levelFreeze then return end

    local data = v.data

    if v.despawnTimer <= 0 then
        data.timer = nil
        return
    end

    data.mimicID = data.mimicID or yoshi.tongueSettings.normalEggNPCID

    local config = NPC.config[v.id]
    local mimicConfig = NPC.config[data.mimicID]

    if data.timer == nil then
        data.timer = 0

        data.bounces = 0

        data.speed = data.speed or vector(v.speedX,v.speedY)

        -- Change size
        v.x = v.x + v.width*0.5 - mimicConfig.width*0.5
        v.width = mimicConfig.width

        v.y = v.y + v.height - mimicConfig.height
        v.height = mimicConfig.height
    end


    data.timer = data.timer + 1

    if not mimicConfig.isBigEgg then
        -- Normal behaviour
        if data.timer%2 == 0 then
            local e = Effect.spawn(config.smokeEffectID,v.x+v.width*0.5,v.y+v.height*0.5)
    
            e.x = e.x - e.width *0.5
            e.y = e.y - e.height*0.5
        end


        doBouncing(v,data,config,mimicConfig)

        v.speedX = data.speed.x
        v.speedY = data.speed.y
    else
        if v.underwater then
            v.speedY = math.min(1.6,v.speedY + Defines.npc_grav*0.2)
        else
            v.speedY = math.min(8,v.speedY + Defines.npc_grav)
        end

        if v.collidesBlockBottom then
            if mimicConfig.fallEffectID ~= nil then
                local e = Effect.spawn(mimicConfig.fallEffectID,v.x+v.width*0.5,v.y+v.height)

                e.x = e.x - e.width*0.5
                e.y = e.y - e.height
            end

            v:kill(HARM_TYPE_VANISH)

            --Misc.doPOW()
            doBigEggPOW(v)
        end

        if (v.collidesBlockLeft or v.collidesBlockRight) and v:mem(0x120,FIELD_BOOL) then
            v.speedX = 0
        end
    end

    v:mem(0x120,FIELD_BOOL,false)
end


function egg.onDrawThrown(v)
    if v.despawnTimer <= 0 or v.isHidden then return end

    local data = v.data

    if data.mimicID == nil then
        return
    end

    
    local mimicConfig = NPC.config[data.mimicID]
    local image = Graphics.sprites.npc[data.mimicID].img

    if mimicConfig == nil or image == nil then
        return
    end


    local gfxwidth  = (mimicConfig.gfxwidth  ~= 0 and mimicConfig.gfxwidth ) or mimicConfig.width
    local gfxheight = (mimicConfig.gfxheight ~= 0 and mimicConfig.gfxheight) or mimicConfig.height

    local x = v.x + v.width*0.5 - gfxwidth*0.5
    local y = v.y + v.height - gfxheight

    local priority = (mimicConfig.foreground and -15) or -45

    local frame = 0

    Graphics.drawImageToSceneWP(image,x,y,0,frame*gfxheight,gfxwidth,gfxheight,priority)
end



function egg.onInitAPI()
    registerEvent(egg,"onPostNPCKill")
end



egg.bounceSounds = {
    SFX.open(Misc.resolveSoundFile("yiYoshi/egg_hit")),
}

egg.hitSound = SFX.open(Misc.resolveSoundFile("yiYoshi/pop"))


return egg