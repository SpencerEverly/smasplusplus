--[[

	Written by MrDoubleA
    Please give credit!
    
    Credits to Eri7 for help on improving Mario's P-Balloon sprites

	Part of MrDoubleA's NPC Pack

]]

local playerManager = require("playerManager")
local npcManager = require("npcManager")

local pBalloon = {}

pBalloon.playerInfo = {}

pBalloon.playerImages = {}

pBalloon.idMap = {}

local disableForcedStates = table.map{2,227,228,499,500}

local mountNPCs = {
    [1] = {35,191,193},
    [2] = 56,
    [3] = {95,98,99,100,148,149,150,228},
}

local function unmountPlayer(v)
    if v.mount > 0 then
        local id = mountNPCs[v.mount]
        if type(id) == "table" then
            id = id[v.mountColor]
        end

        if id then
            local w = NPC.spawn(id,v.x+(v.width/2),v.y+(v.height/2),v.section,false,true)

            w.direction = v.direction
        end

        v.mount = 0
    end
end

function pBalloon.stop(v)
    pBalloon.playerInfo[v.idx] = nil

    v:mem(0x15C,FIELD_WORD,0) -- Allow warp entering
    v:mem(0x160,FIELD_WORD,0) -- Allow fireball throwing/sword slashes
    v:mem(0x164,FIELD_WORD,0) -- Allow tail swipe
    v:mem(0x154,FIELD_WORD,0) -- Allow holding items
end

function pBalloon.register(id)
    pBalloon.idMap[id] = true
end

function pBalloon.onInitAPI()
    registerEvent(pBalloon,"onTick")
    registerEvent(pBalloon,"onDraw")

    registerEvent(pBalloon,"onPostNPCKill")
end

function pBalloon.onPostNPCKill(v,reason)
    if v.isGenerator or not pBalloon.idMap[v.id] then return end

    local collected = npcManager.collected(v,reason)
	local config = NPC.config[v.id]

    if not config or not collected then return end
    
    if config.collectSFX then
        SFX.play(config.collectSFX)
    end

    local info = pBalloon.playerInfo[collected.idx]

    if info then
        info.timer = 0
        info.render = false
        info.id = v.id
    else
        collected:mem(0x11C,FIELD_WORD,0)

        pBalloon.playerInfo[collected.idx] = {
            timer = 0,id = v.id,
            speedX = collected.speedX,
            speedY = collected.speedY/4,
            render = false,
        }

        unmountPlayer(collected)
    end
end

function pBalloon.onTick()
    for _,v in ipairs(Player.get()) do
        local info = pBalloon.playerInfo[v.idx]

        if info then
            if disableForcedStates[v.forcedState]          -- Powering down
            or v:mem(0x4A,FIELD_BOOL)                      -- Statue
            or v.deathTimer > 0 or v:mem(0x13C,FIELD_BOOL) -- Dead
            then
                pBalloon.stop(v) -- ABORT! ABORT!
            else
                local config = NPC.config[info.id]

                -- Prevent a bunch of stuff

                v:mem(0x15C,FIELD_WORD,2)    -- Prevent warp entering
                v:mem(0x160,FIELD_WORD,2)    -- Prevent fireball throwing/sword slashes
                v:mem(0x154,FIELD_WORD,-1)   -- Prevent holding items
                v:mem(0x164,FIELD_WORD,-1)   -- Prevent tail swipe
                v:mem(0x18,FIELD_BOOL,false) -- Prevent Peach hovering
                v:mem(0x3C,FIELD_BOOL,false) -- Prevent sliding
                v:mem(0x50,FIELD_BOOL,false) -- Prevent spin jumping

                -- Prevent leaf flying
                v:mem(0x168,FIELD_FLOAT,0)
                v:mem(0x170,FIELD_WORD,0)
                v:mem(0x16C,FIELD_BOOL,false)
                v:mem(0x16E,FIELD_BOOL,false)

                unmountPlayer(v) -- Prevent using mounts (could maybe be done better?)



                -- Main logic
                info.timer = info.timer + 1

                if info.timer == 4 then
                    info.render = true
                elseif info.timer > (config.duration or 512) then
                    pBalloon.stop(v)
                elseif info.timer > (config.duration or 512)-(config.warnTime or 160) then
                    info.render = (math.floor(((config.warnTime or 160)-((config.duration or 512)-info.timer)-1)%((config.warnTime or 160)/3)) < ((config.warnTime or 160)/6))
                end

                -- Horizontal movement
                if v:mem(0x148,FIELD_WORD) > 0 or v:mem(0x14C,FIELD_WORD) > 0 then
                    info.speedX = 0
                elseif v.keys.left then
                    info.speedX = math.max(-(config.horizontalSpeed or 2),info.speedX - (config.horizontalAcceleration or 0.075))
                    v.direction = DIR_LEFT
                elseif v.keys.right then
                    info.speedX = math.min( (config.horizontalSpeed or 2),info.speedX + (config.horizontalAcceleration or 0.075))
                    v.direction = DIR_RIGHT
                elseif info.speedX > 0 then
                    info.speedX = math.max(0,info.speedX - (config.horizontalDeacceleration or 0.05))
                elseif info.speedX < 0 then
                    info.speedX = math.min(0,info.speedX + (config.horizontalDeacceleration or 0.05))
                end
                
                v.speedX = info.speedX

                v.keys.left,v.keys.right = false,false -- Disable normal movement (probably a better wait to do this?)

                -- Vertical movement
                if v:mem(0x11C,FIELD_WORD) > 0 then
                    v:mem(0x11C,FIELD_WORD,0)
                    info.speedY = -2
                end

                local target = config.neutralSpeed or -0.75
                if v.keys.up then
                    target = config.upwardsSpeed or -1.25
                elseif v.keys.down then
                    target = config.downwardsSpeed or 0.5
                end

                if v:isGroundTouching() then
                    info.speedY = -0.01
                elseif v:mem(0x14A,FIELD_WORD) > 0 then
                    info.speedY = 0.5
                elseif info.speedY > target then
                    info.speedY = math.max(target,info.speedY - (config.upwardsAcceleration or 0.05))
                elseif info.speedY < target then
                    info.speedY = math.min(target,info.speedY + (config.downwardsAcceleration or 0.025))
                end

                v.speedY = info.speedY - Defines.player_grav
            end
        end
    end
end

function pBalloon.onDraw()
    for k,v in ipairs(Player.get()) do
        local info = pBalloon.playerInfo[v.idx]

        if info then
            local name = playerManager.getName(v.character)

            if pBalloon.playerImages[name] == nil then
                local path = Misc.resolveFile("pballoon_player_".. tostring(name).. ".png")

                if path then
                    pBalloon.playerImages[name] = Graphics.loadImage(path)
                else
                    pBalloon.playerImages[name] = false
                end
            end

            if info.render and pBalloon.playerImages[name] and not player:mem(0x142,FIELD_BOOL) then
                Graphics.drawImageToSceneWP(pBalloon.playerImages[name],v.x+(v.width/2)-50,v.y+v.height-76,(v.powerup-1)*100,0,100,100,1,-25)

                v.frame = -50*v.direction
            else
                if playerManager.getBaseID(v.character) == CHARACTER_LINK then
                    v.frame = 1
                else
                    v.frame = 15
                end
            end
        end
    end
end

return pBalloon