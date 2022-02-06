--[[

	Written by MrDoubleA
	Please give credit!

	Part of MrDoubleA's NPC Pack

]]

local blockManager = require("blockManager")
local blockutils = require("blocks/blockutils")

local oneWayWall = {}


oneWayWall.DIRECTION_UP    = vector(0 ,-1)
oneWayWall.DIRECTION_RIGHT = vector(1 ,0 )
oneWayWall.DIRECTION_DOWN  = vector(0 ,1 )
oneWayWall.DIRECTION_LEFT  = vector(-1,0 )


oneWayWall.playerDucking = {} -- Keeps track of if a player is ducking, so we can tell when they stop


oneWayWall.idList = {}
oneWayWall.idMap  = {}


-- The harm type that an NPC is killed by when touching a one-way wall
local destroyOnWallIDMap = table.map{13,40,45,133,237,263,265}

local function npcHitWall(v,w) -- Logic for an NPC hitting a one-way wall
    if not w:mem(0x136,FIELD_BOOL) then
        w:mem(0x120,FIELD_BOOL,true) -- Turn around
    else
        w.speedX = -w.speedX
    end

    if destroyOnWallIDMap[w.id] then
        w:kill(HARM_TYPE_PROJECTILE_USED)
    end
end


local pushObjectFunctions = { -- Functions to push objects out of the block
    [oneWayWall.DIRECTION_UP   ] = (function(v,w)
        -- We don't need to do anything here, since redigit's already done it for us
    end),
    [oneWayWall.DIRECTION_RIGHT] = (function(v,w)
        w.x = v.x+v.width

        if type(w) == "Player" then
            w:mem(0x148,FIELD_WORD,2)
            w.speedX = 0
        elseif type(w) == "NPC" then
            npcHitWall(v,w)

            w.collidesBlockLeft = true
        end
    end),
    [oneWayWall.DIRECTION_DOWN ] = (function(v,w)
        w.y = v.y+v.height
        w.speedY = 0

        if type(w) == "Player" then
            w:mem(0x11C,FIELD_WORD,0) -- Jump force
            w:mem(0x14A,FIELD_WORD,2)
        elseif type(w) == "NPC" then
            w.collidesBlockUp = true
        end
    end),
    [oneWayWall.DIRECTION_LEFT ] = (function(v,w)
        w.x = v.x-w.width

        if type(w) == "Player" then
            w:mem(0x14C,FIELD_WORD,2)
            w.speedX = 0
        elseif type(w) == "NPC" then
            npcHitWall(v,w)
            
            w.collidesBlockRight = true
        end
    end),
}

local function objectHasCollision(v) -- Get whether a player/NPC has collision. Obviously not perfect, but I guess it does the job
    if type(v) == "Player" then
        return ((v.forcedState == 0 and v.deathTimer == 0 and not v:mem(0x13C,FIELD_BOOL)) and not Defines.cheat_shadowmario)
    elseif type(v) == "NPC" then
        local config = NPC.config[v.id]
        return ((v.despawnTimer > 0 and not v.isGenerator and not v.isHidden) and not v.noblockcollision and (not config or not config.noblockcollision) and v.id ~= 266 and v:mem(0x12C,FIELD_WORD) == 0 and v:mem(0x138,FIELD_WORD) == 0)
    end
end
local function getHitDirection(v,w) -- Get the direction that an object (w) hit a block (v) from.
    if (w.y+w.height-w.speedY) <= (v.y-v.speedY) and (w.speedY >= 0) then -- From top
        return oneWayWall.DIRECTION_UP
    elseif (w.x-w.speedX) >= (v.x+v.width-v.speedX) and (w.speedX < 0 or v.speedX > 0) then -- From right
        return oneWayWall.DIRECTION_RIGHT
    elseif (w.y-w.speedY) >= (v.y+v.height-v.speedY) and (w.speedY < 0) then -- From bottom
        return oneWayWall.DIRECTION_DOWN
    elseif (w.x+w.width-w.speedX) <= (v.x-v.speedX) and (w.speedX > 0 or v.speedX < 0) then -- From left
        return oneWayWall.DIRECTION_LEFT
    elseif (type(w) == "Player" and (w.y+w.height) >= (v.y+v.height) and not w:isGroundTouching() and (oneWayWall.playerDucking[w] and not w:mem(0x12E,FIELD_BOOL))) then -- Prevent clipping when uncrouching
        return oneWayWall.DIRECTION_DOWN
    end
end


function oneWayWall.register(id)
    blockManager.registerEvent(id,oneWayWall,"onTickEndBlock")
    blockManager.registerEvent(id,oneWayWall,"onCameraDrawBlock")

    table.insert(oneWayWall.idList,id)
    oneWayWall.idMap[id] = true
end


function oneWayWall.interact(v,w)
    local config = Block.config[v.id]
    local data = v.data

    if getHitDirection(v,w) == config.direction then
        pushObjectFunctions[config.direction](v,w)

        if data.touchCooldown == 0 then
            data.rotation = 0
            data.shakeTarget = 8

            if config.interactSFX then
                SFX.play(config.interactSFX)
            end
        end

        data.touchCooldown = 2 -- Used to prevent it continuously "clicking"
    end
end


function oneWayWall.onInitAPI()
    registerEvent(oneWayWall,"onTick")
    registerEvent(oneWayWall,"onDraw")
end


function oneWayWall.onTick()
    for _,playerObj in ipairs(Player.get()) do
        oneWayWall.playerDucking[playerObj] = playerObj:mem(0x12E,FIELD_BOOL)
    end
end

function oneWayWall.onDraw()
    for _,id in ipairs(oneWayWall.idList) do
        blockutils.setBlockFrame(id,-1000) -- Make the block invisible
    end
end



function oneWayWall.onTickEndBlock(v)
	if v.isHidden or v:mem(0x5A, FIELD_BOOL) then return end
	
	local config = Block.config[v.id]
    local data = v.data
	
    data.touchCooldown = math.max(0,(data.touchCooldown or 0)-1)

    data.rotation = (data.rotation or 0)
    data.shakeTarget = (data.shakeTarget or 0)

    if math.abs(data.rotation) > math.abs(data.shakeTarget) and math.sign(data.rotation) == math.sign(data.shakeTarget) then
        data.rotation = data.shakeTarget
        data.shakeTarget = -data.shakeTarget*0.4

        if math.abs(data.rotation) < 1 then
            data.rotation = 0
            data.shakeTarget = 0
        end
    else
        data.rotation = data.rotation+(math.sign(data.shakeTarget)*12)
    end

    -- Handle collisions

    -- Players
    for _,w in ipairs(Player.get()) do
        if objectHasCollision(w) and v:collidesWith(w) > 0 then
            oneWayWall.interact(v,w)
        end
    end
    -- NPCs
    local hitbox = blockutils.getHitbox(v,0.3)

    for _,w in ipairs(Colliders.getColliding{a = hitbox,btype = Colliders.NPC,filter = objectHasCollision}) do
        oneWayWall.interact(v,w)
    end
end

function oneWayWall.onCameraDrawBlock(v,camIdx)
    if v.isHidden or v:mem(0x5A, FIELD_BOOL) or not blockutils.visible(Camera(camIdx),v.x,v.y,v.width,v.height) then return end

    local config = Block.config[v.id]
    local data = v.data

    if data.sprite == nil then
        data.sprite = Sprite{texture = Graphics.sprites.block[v.id].img,frames = config.frames}

        data.sprite.align    = Sprite.align.CENTRE
        data.sprite.texalign = data.sprite.align
    end

    local frame = (math.floor(lunatime.drawtick()/config.framespeed)%config.frames)

    data.sprite.position = vector(v.x+(v.width/2),v.y+(v.height/2))
    data.sprite.rotation = data.rotation

    data.sprite:draw{frame = frame+1,priority = -65.5,sceneCoords = true}
end


return oneWayWall