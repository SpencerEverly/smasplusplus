--[[

	Extended Koopas (v1.1)
	Made by MrDoubleA

    Classic SMW Koopas made by AwesomeZack (https://mfgg.net/index.php?act=resdb&param=02&c=1&id=31552)
    SMB2 Koopa, Buzzy Beetle and Spiny sprites by Cruise Elroy and mariofan230 (https://mfgg.net/index.php?act=resdb&param=02&c=1&id=36053, https://mfgg.net/index.php?act=resdb&param=02&c=1&id=32112)

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local extendedKoopas = {}


local THROWN_NPC_COOLDOWN    = 0x00B2C85C
local SHELL_HORIZONTAL_SPEED = 0x00B2C860
local SHELL_VERTICAL_SPEED   = 0x00B2C864


local colBox = Colliders.Box(0,0,0,0)
local colBox2 = Colliders.Box(0,0,0,0)


local function launchShell(v,culprit,upsideDown)
    if type(culprit) == "Player" then
        if (v.x + v.width*0.5) > (culprit.x + culprit.width*0.5) then
            v.direction = DIR_RIGHT
        else
            v.direction = DIR_LEFT
        end

        v:mem(0x12E,FIELD_WORD,100) -- can't hurt timer
        v:mem(0x130,FIELD_WORD,culprit.idx) -- can't hurt player
    else
        v.direction = -v.direction
    end

    v.speedX = 1 * v.direction
    v.speedY = -8

    v:mem(0x136,FIELD_BOOL,true)

    local data = v.data

    data.upsideDown = upsideDown
    data.wakeUpTimer = 0
    data.bouncing = true
end

local function handleFacingPlayer(v,data,config)
    if config.facePlayerTime <= 0 then
        return
    end
    
    data.facePlayerTimer = data.facePlayerTimer + 1

    if data.facePlayerTimer >= config.facePlayerTime then
        npcutils.faceNearestPlayer(v)
        data.facePlayerTimer = 0
    end
end


local function setConfigDefault(config,name,value)
    if config[name] == nil then
        config:setDefaultProperty(name,value)
    end
end


-- Koopas
do
    extendedKoopas.koopaIDList = {}
    extendedKoopas.koopaIDMap  = {}

    function extendedKoopas.registerKoopa(npcID)
        npcManager.registerEvent(npcID,extendedKoopas,"onTickEndNPC","onTickEndKoopa")
        npcManager.registerEvent(npcID,extendedKoopas,"onTickNPC","onTickKoopa")
        npcManager.registerEvent(npcID,extendedKoopas,"onDrawNPC","onDrawKoopa")

        table.insert(extendedKoopas.koopaIDList,npcID)
        extendedKoopas.koopaIDMap[npcID] = true


        local config = NPC.config[npcID]

        setConfigDefault(config,"turnFrames",0)
        setConfigDefault(config,"turnTime",0)

        setConfigDefault(config,"facePlayerTime",0) -- for yellow koopas, which turn to face the player every so often
        setConfigDefault(config,"droppedCoinID",0) -- yellow koopas drop coins! 'cause why not, I guess

        setConfigDefault(config,"hopOverProjectiles",false) -- for hopping para-koopas
        setConfigDefault(config,"airFrames",0)

        setConfigDefault(config,"shellID",0)
        setConfigDefault(config,"beachKoopaID",0)
        setConfigDefault(config,"nonWingedKoopaID",0)

        setConfigDefault(config,"customRenderPriority",-101) -- smb2 koopas have higher priority
    end


    local function turnIntoShell(v)
        local originalConfig = NPC.config[v.id]
        local insideNPCID = v.id

        if originalConfig.nonWingedKoopaID > 0 then -- if this is a parakoopa, put the non-winged version inside instead
            insideNPCID = originalConfig.nonWingedKoopaID
        end


        v:transform(originalConfig.shellID)

        local data = v.data

        data.insideNPCID = insideNPCID
        data.upsideDown = false
        data.bouncing = false

        v.speedX = 0
        v.speedY = 0
        v:mem(0x18,FIELD_FLOAT,0) -- "real" speed x
    end


    local function dropCoin(v,data,config,culprit)
        if config.droppedCoinID <= 0 then
            return
        end

        local direction = v.direction
        if type(culprit) == "Player" then
            if (v.x + v.width*0.5) > (culprit.x + culprit.width*0.5) then
                direction = DIR_RIGHT
            else
                direction = DIR_LEFT
            end
        end


        local coin = NPC.spawn(config.droppedCoinID, v.x + v.width*0.5 + v.width*0.5*direction,v.y + v.height - NPC.config[config.droppedCoinID].height*0.5,v.section,false,true)

        coin.direction = direction

        coin.speedX = 0.75 * coin.direction
        coin.speedY = -7

        coin.ai1 = 1
    end


    local function npcIsAProjectile(v)
        return (
            Colliders.FILTER_COL_NPC_DEF(v)
            and v:mem(0x136,FIELD_BOOL)
        )
    end

    local function handleHoppingOverProjectiles(v,data,config)
        if not config.hopOverProjectiles then
            return
        end


        if v.collidesBlockBottom then
            colBox.width = 64 * config.speed
            colBox.height = 2

            colBox.y = v.y + v.height - colBox.height

            if v.direction == DIR_LEFT then
                colBox.x = v.x - colBox.width
            else
                colBox.x = v.x + v.width
            end

            
            local npcs = Colliders.getColliding{a = colBox,btype = Colliders.NPC,filter = npcIsAProjectile}

            for _,npc in ipairs(npcs) do
                v.speedY = -5
            end
        end
    end


    local function handleAnimation(v,data,config)
        local frame,direction

        local walkFrames = (config.frames - config.turnFrames - config.airFrames)

        if data.turnDirection == 0 then
            if v.collidesBlockBottom or config.airFrames <= 0 then
                frame = math.floor(data.animationTimer / config.framespeed) % walkFrames
            else
                frame = math.floor(data.animationTimer / config.framespeed) % config.airFrames + walkFrames
            end

            direction = v.direction
        else
            local framespeed = (config.turnTime / config.turnFrames) * 0.5

            frame = (math.floor(data.animationTimer / framespeed) % config.turnFrames) + (config.frames - config.turnFrames)

            if data.animationTimer >= (config.turnTime * 0.5) then
                direction = -data.turnDirection
            else
                direction = data.turnDirection
            end
        end


        v.animationFrame = npcutils.getFrameByFramestyle(v,{frame = frame,direction = direction})


        data.animationTimer = data.animationTimer + 1

        if data.turnDirection ~= 0 and data.animationTimer >= config.turnTime then
            data.turnDirection = 0
            data.animationTimer = 0
        end
    end


    function extendedKoopas.onTickEndKoopa(v)
        if Defines.levelFreeze then return end
        
        local data = v.data
        
        if v.despawnTimer <= 0 then
            data.initializedID = nil
            return
        end


        if not extendedKoopas.koopaIDMap[v.id] then -- idk
            return
        end


        local config = NPC.config[v.id]

        if data.initializedID == nil or data.initializedID ~= v.id then
            data.initializedID = v.id

            data.animationTimer = 0

            data.oldDirection = v.direction
            data.turnDirection = 0

            data.facePlayerTimer = 0
        end


        if v:mem(0x12C,FIELD_WORD) > 0 and (config.grabtop or config.grabside) and config.shellID > 0 then -- smb2 koopa picked up
            turnIntoShell(v)

            dropCoin(v,data,config, Player(v:mem(0x12C,FIELD_WORD)))

            return
        end


        if v:mem(0x138,FIELD_WORD) == 5 and config.shellID > 0 then
            turnIntoShell(v)
            return
        end


        if v:mem(0x12C, FIELD_WORD) == 0 and v:mem(0x138, FIELD_WORD) == 0 and not v:mem(0x136, FIELD_BOOL) then
            if not config.isflying then
                handleFacingPlayer(v,data,config)

                v.speedX = config.speed * v.direction

                handleHoppingOverProjectiles(v,data,config)
            else
                if v.ai1 == 3 then -- fly and turn vertical
                    v.direction = (v.speedY > 0 and DIR_LEFT) or DIR_RIGHT
                end
            end

            if v.direction ~= data.oldDirection and config.turnFrames > 0 and config.turnTime > 0 then
                data.turnDirection = data.oldDirection
                data.animationTimer = 0
            end
        end

        data.oldDirection = v.direction

        handleAnimation(v,data,config)
    end


    function extendedKoopas.onTickKoopa(v)
        local data = v.data

        if not data.changedBehaviour and extendedKoopas.koopaIDMap[v.id] then
            local config = NPC.config[v.id]

            data.changedBehaviour = true

            if v.id >= 751 and v.id <= 1000 and config.isflying then
                v.spawnAi1 = v.spawnAi2
                v.spawnAi2 = 0

                v.ai1 = v.spawnAi1
                v.ai2 = v.spawnAi2
                v.ai3 = 0
                v.ai4 = 0
                v.ai5 = 0
            end
        end
    end



    function extendedKoopas.onDrawKoopa(v)
        if v.despawnTimer <= 0 or v.isHidden then return end

        if not extendedKoopas.koopaIDMap[v.id] then -- idk
            return
        end

        local config = NPC.config[v.id]

        if config.customRenderPriority < -100 or v.friendly or v:mem(0x138,FIELD_WORD) > 0 or v:mem(0x12C,FIELD_WORD) > 0 then
            return
        end

        npcutils.drawNPC(v,{priority = config.customRenderPriority})

        npcutils.hideNPC(v)
    end


    function extendedKoopas.onNPCHarmKoopa(eventObj,v,reason,culprit)
        if not extendedKoopas.koopaIDMap[v.id] then return end

        local config = NPC.config[v.id]
        local data = v.data

        if reason == HARM_TYPE_JUMP then
            if config.nonWingedKoopaID > 0 then
                v:transform(config.nonWingedKoopaID)
                
                eventObj.cancelled = true
            elseif config.beachKoopaID > 0 then
                -- Turn into beach koopa
                v:transform(config.beachKoopaID)

                if type(culprit) == "Player" then
                    if (v.x + v.width*0.5) > (culprit.x + culprit.width*0.5) then
                        v.direction = DIR_RIGHT
                    else
                        v.direction = DIR_LEFT
                    end
                end

                v.speedX = mem(SHELL_HORIZONTAL_SPEED,FIELD_FLOAT) * v.direction
                v.speedY = 0

                v:mem(0x136,FIELD_BOOL,true) -- set projectile flag

                -- Create a shell
                if config.shellID > 0 then
                    local shell = NPC.spawn(config.shellID, v.x + v.width*0.5,v.y + v.height - NPC.config[config.shellID].height*0.5,v.section,false,true)
                end

                eventObj.cancelled = true
            elseif config.shellID > 0 then
                turnIntoShell(v)
                eventObj.cancelled = true
            end


            -- Drop a coin, for yellow koopas
            dropCoin(v,data,config,culprit)
            

            SFX.play(2)
        elseif reason == HARM_TYPE_FROMBELOW or (reason == HARM_TYPE_TAIL and v:mem(0x26,FIELD_WORD) == 0) then
            if config.shellID > 0 then
                turnIntoShell(v)
                launchShell(v,culprit,true)
                eventObj.cancelled = true
            end

            if reason == HARM_TYPE_TAIL then
                v:mem(0x26,FIELD_WORD,8)
                SFX.play(9)
            else
                SFX.play(2)
            end      
        elseif reason == HARM_TYPE_SPINJUMP and (config.isflying and config.spinjumpsafe) then -- isflying is hardcoded to always let spin jumps work! for some reason!
            eventObj.cancelled = true      
        end
    end
end


-- Shells
do
    extendedKoopas.shellIDList = {}
    extendedKoopas.shellIDMap  = {}

    extendedKoopas.customShellIDMap = {}

    function extendedKoopas.registerShell(npcID,isCustom)
        npcManager.registerEvent(npcID,extendedKoopas,"onTickEndNPC","onTickEndShell")

        table.insert(extendedKoopas.shellIDList,npcID)
        extendedKoopas.shellIDMap[npcID] = true

        extendedKoopas.customShellIDMap[npcID] = isCustom or false


        local config = NPC.config[npcID]

        setConfigDefault(config,"wakeUpTime",512)
        setConfigDefault(config,"shakeTime",48)

        setConfigDefault(config,"facePlayerAfterWakingUp",true)

        setConfigDefault(config,"spinFramesUpsideDown",0)
        setConfigDefault(config,"eyeFramesNormal",0)
        setConfigDefault(config,"eyeFramesUpsideDown",0)

        setConfigDefault(config,"beforeBlinkTime",384)
        setConfigDefault(config,"blinkLength",16)

        setConfigDefault(config,"hoppedInsideID",0)

        setConfigDefault(config,"hurtsOnTop",false)

        setConfigDefault(config,"yoshiMouthAbility",0)
    end


    local function getBlinkingFrame(v,data,config,eyeFrames,spinFrames)
        if eyeFrames == 0 then
            return -spinFrames
        end

        local timer = (data.wakeUpTimer % (config.beforeBlinkTime + config.blinkLength))

        if timer < config.beforeBlinkTime then
            return math.floor((timer / config.beforeBlinkTime) * (eyeFrames - 1))
        else
            return (eyeFrames - 1)
        end
    end

    local function handleAnimation(v,data,config)
        local totalNormalFrames = (config.frames - config.eyeFramesUpsideDown - config.spinFramesUpsideDown)
        local spinNormalFrames = (totalNormalFrames - config.eyeFramesNormal)

        local frame

        if v.speedX ~= 0 and not data.bouncing then
            -- Spinning
            if data.upsideDown then
                frame = (math.floor(data.animationTimer / config.framespeed) % config.spinFramesUpsideDown) + totalNormalFrames
            else
                frame = math.floor(data.animationTimer / config.framespeed) % spinNormalFrames
            end

            data.animationTimer = data.animationTimer + 1
        elseif data.insideNPCID > 0 then
            if data.upsideDown then
                frame = getBlinkingFrame(v,data,config,config.eyeFramesUpsideDown,config.spinFramesUpsideDown) + (config.frames - config.eyeFramesUpsideDown)
            else
                frame = getBlinkingFrame(v,data,config,config.eyeFramesNormal,spinNormalFrames) + spinNormalFrames
            end

            data.animationTimer = 0
        else
            if data.upsideDown then
                frame = totalNormalFrames
            else
                frame = 0
            end

            data.animationTimer = 0
        end


        v.animationFrame = npcutils.getFrameByFramestyle(v,{frame = frame})
    end


    local function getOutOfThePlayersLovingArms(v)
        if v:mem(0x12C,FIELD_WORD) > 0 then
            local holdingPlayer = Player(v:mem(0x12C,FIELD_WORD))

            holdingPlayer:mem(0x154,FIELD_WORD,0)
            
            v:mem(0x12E,FIELD_WORD,0) -- can't hurt timer
            v:mem(0x130,FIELD_WORD,0) -- can't hurt player

            v.direction = holdingPlayer.direction

            v:mem(0x12C,FIELD_WORD,0)
        end
    end


    local function wakeUp(v,data,config)
        local newConfig = NPC.config[data.insideNPCID]

        local oldID = v.id
        local oldConfig = NPC.config[oldID]

        if newConfig.beachKoopaID ~= nil and newConfig.beachKoopaID > 0 then
            local holdingPlayerIdx = v:mem(0x12C,FIELD_WORD)

            local oldX,oldY = v.x,v.y
            local oldFrame = v.animationFrame

            -- Hop out as a beach koopa
            v:transform(newConfig.beachKoopaID)

            v.speedY = -5

            getOutOfThePlayersLovingArms(v)
            v:mem(0x136,FIELD_BOOL,false)


            npcutils.faceNearestPlayer(v)

            if not oldConfig.facePlayerAfterWakingUp then
                v.direction = -v.direction
            end



            -- Create a shell
            local shell = NPC.spawn(oldID, oldX,oldY,v.section,false,false)

            local shellData = shell.data

            shellData.upsideDown = data.upsideDown
            shell.animationFrame = oldFrame


            if holdingPlayerIdx > 0 then
                shell:mem(0x12C,FIELD_WORD,holdingPlayerIdx) -- holding player
                Player(holdingPlayerIdx):mem(0x154,FIELD_WORD,shell.idx + 1)
            end

            v.y = shell.y - v.height
        else
            v:transform(data.insideNPCID)

            getOutOfThePlayersLovingArms(v)

            
            npcutils.faceNearestPlayer(v)

            if not oldConfig.facePlayerAfterWakingUp then
                v.direction = -v.direction
            end
        end
    end


    local yoshiAbilityFlags = {
        [1] = 0x68, -- fire
        [2] = 0x66, -- flight
        [3] = 0x64, -- earthquake
    }


    function extendedKoopas.onTickEndShell(v)
        if Defines.levelFreeze then return end
        
        local data = v.data
        
        if v.despawnTimer <= 0 then
            data.initializedID = nil
            return
        end


        if not extendedKoopas.shellIDMap[v.id] then -- idk
            return
        end


        local config = NPC.config[v.id]

        if data.initializedID == nil or data.initializedID ~= v.id then
            data.initializedID = v.id

            data.insideNPCID = data.insideNPCID or 0

            if data.bouncing == nil then
                data.bouncing = false
            end
            
            data.animationTimer = 0

            data.wakeUpTimer = 0
            data.shakeTimer = 0
        end


        if v:mem(0x138,FIELD_WORD) == 6 then -- in yoshi's mouth
            local offset = yoshiAbilityFlags[config.yoshiMouthAbility]
            local yoshiPlayerIdx = v:mem(0x13C,FIELD_DFLOAT)

            if offset ~= nil and (yoshiPlayerIdx >= 1 and yoshiPlayerIdx <= Player.count()) then
                local yoshiPlayer = Player(yoshiPlayerIdx)

                if yoshiPlayer:mem(0xB8,FIELD_WORD) == (v.idx + 1) then -- the NPC is actually in yoshi's mouth
                    yoshiPlayer:mem(offset, FIELD_BOOL, true)
                end
            end
        end


        if v:mem(0x12C, FIELD_WORD) == 0 and v:mem(0x138, FIELD_WORD) == 0 then
            if data.bouncing then
                v.speedX = v.speedX * 0.984

                if v.collidesBlockBottom and (math.abs(v.speedX) <= 0.35 or v.speedY == 0) then
                    v.speedX = 0
                    v:mem(0x18,FIELD_FLOAT,0) -- "real" speed x

                    v:mem(0x12E,FIELD_WORD,0) -- can't hurt timer
                    v:mem(0x130,FIELD_WORD,0) -- can't hurt player

                    data.bouncing = false
                elseif v:mem(0x12E,FIELD_WORD) > 0 then -- can't hurt timer
                    v:mem(0x12E,FIELD_WORD,100)
                end
            end
        else
            data.bouncing = false
        end


        if (v.speedX == 0 or data.bouncing) and (v:mem(0x138,FIELD_WORD) == 0) and data.insideNPCID > 0 then
            data.wakeUpTimer = data.wakeUpTimer + 1

            if data.wakeUpTimer >= config.wakeUpTime then
                wakeUp(v,data,config)
            elseif data.wakeUpTimer >= (config.wakeUpTime - config.shakeTime) then
                data.shakeTimer = data.shakeTimer + 1

                if data.shakeTimer%2 == 0 then
                    v.x = v.x - 2
                else
                    v.x = v.x + 2
                end
            else
                data.shakeTimer = 0
            end
        else
            data.wakeUpTimer = 0
            data.shakeTimer = 0
        end


        -- If the player is standing on this shell, the shell is not upside down, and the shell hurts on the top, hurt the player
        if config.hurtsOnTop and not data.upsideDown then
            for _,p in ipairs(Player.get()) do
                if p.standingNPC == v then
                    p:harm()
                end
            end
        end


        handleAnimation(v,data,config)
    end


    function extendedKoopas.onNPCHarmShell(eventObj,v,reason,culprit)
        if not extendedKoopas.shellIDMap[v.id] then return end

        local config = NPC.config[v.id]
        local data = v.data


        if reason == HARM_TYPE_FROMBELOW or (reason == HARM_TYPE_TAIL and v:mem(0x26,FIELD_WORD) == 0) then
            launchShell(v,culprit,true)

            data.wakeUpTimer = 0

            if reason == HARM_TYPE_TAIL then
                SFX.play(9)
            else
                SFX.play(2)
            end

            eventObj.cancelled = true

            return
        end


        if reason == HARM_TYPE_JUMP and config.hurtsOnTop then
            -- If a player jumped onto a spiny shell, and they're going into the spiky side, hurt them and cancel the kick
            if type(culprit) == "Player" and ((not data.upsideDown and culprit.y+culprit.height-8 <= v.y-v.speedY) or (data.upsideDown and culprit.y+4 >= v.y+v.height-v.speedY)) then
                culprit:harm()

                eventObj.cancelled = true
                return
            end
        end


        -- The rest of this code is for handling kicking for custom shells. Since for some reason, isshell only half works
        if not extendedKoopas.customShellIDMap[v.id] then
            return
        end


        local culpritIsPlayer = (type(culprit) == "Player")
        local culpritIsNPC = (type(culprit) == "NPC")

        if reason == HARM_TYPE_JUMP then
            if v:mem(0x138,FIELD_WORD) == 2 then -- dropping out of the item box
                v:mem(0x138,FIELD_WORD,0)
            end


            if not culpritIsPlayer or (culprit:mem(0xBC,FIELD_WORD) <= 0 and culprit.mount ~= MOUNT_CLOWNCAR) then -- I have no CLUE what this check is for but it's in redigit's code!
                local playerIsCantHurtPlayer = (culpritIsPlayer and v:mem(0x130,FIELD_WORD) == culprit.idx)
                
                if v.speedX == 0 and not playerIsCantHurtPlayer then
                    -- Kick it
                    SFX.play(9)

                    if culpritIsPlayer then
                        v.direction = culprit.direction

                        -- Set don't hurt player and timer
                        v:mem(0x12E,FIELD_WORD, mem(THROWN_NPC_COOLDOWN,FIELD_WORD))
                        v:mem(0x130,FIELD_WORD, culprit.idx)
                    end

                    v.speedX = mem(SHELL_HORIZONTAL_SPEED,FIELD_FLOAT) * v.direction
                    v.speedY = 0

                    v:mem(0x136,FIELD_BOOL,true) -- set projectile flag
                elseif not playerIsCantHurtPlayer or (culpritIsPlayer and v:mem(0x22,FIELD_WORD) == 0 and not culprit.climbing) then
                    -- Stop it
                    SFX.play(2)

                    v.speedX = 0
                    v.speedY = 0

                    v:mem(0x18,FIELD_FLOAT,0) -- "real speed x"
                    v:mem(0x136,FIELD_BOOL,false) -- projectile flag
                end
            end

            eventObj.cancelled = true
            return
        elseif reason == HARM_TYPE_PROJECTILE_USED then
            -- Shells won't die when hitting an NPC UNLESS the NPC it hit is a projectile and is not a beach koopa
            if not culpritIsNPC or (not culprit:mem(0x136,FIELD_BOOL) or not extendedKoopas.beachKoopaIDMap[culprit.id]) then
                eventObj.cancelled = true
                return
            end
        end
    end
end


-- Beack hoopas
do
    extendedKoopas.beachKoopaIDList = {}
    extendedKoopas.beachKoopaIDMap  = {}

    function extendedKoopas.registerBeachKoopa(npcID)
        npcManager.registerEvent(npcID,extendedKoopas,"onTickEndNPC","onTickEndBeachKoopa")

        table.insert(extendedKoopas.beachKoopaIDList,npcID)
        extendedKoopas.beachKoopaIDMap[npcID] = true


        local config = NPC.config[npcID]

        setConfigDefault(config,"afterKickTime",-1)
        setConfigDefault(config,"beforeKickTime",-1)
        
        setConfigDefault(config,"quickerSliding",false)
        setConfigDefault(config,"facePlayerTime",0)

        setConfigDefault(config,"kickFrames",0)
        setConfigDefault(config,"slidingFrames",0)
    end


    local function handleAnimation(v,data,config)
        local frame

        local walkFrames = (config.frames - config.slidingFrames - config.kickFrames)

        
        if v:mem(0x136,FIELD_BOOL) then -- sliding
            if math.abs(v.speedX) >= 0.5 then
                frame = (config.frames - config.slidingFrames)
            else
                frame = (math.floor(data.animationTimer / config.framespeed) % config.slidingFrames) + (config.frames - config.slidingFrames)
                data.animationTimer = data.animationTimer + 1
            end
        elseif data.kickNPC ~= nil then -- kicking
            if data.kickTimer < config.beforeKickTime then
                frame = 0
            else
                frame = math.floor(((data.kickTimer - config.beforeKickTime) / config.afterKickTime) * config.kickFrames) + walkFrames
            end

            data.animationTimer = 0
        elseif data.dontMoveTimer > 0 then
            frame = 0
        else
            frame = math.floor(data.animationTimer / config.framespeed) % walkFrames

            data.animationTimer = data.animationTimer + 1
        end


        v.animationFrame = npcutils.getFrameByFramestyle(v,{frame = frame})
    end


    extendedKoopas.alwaysKickableIDs = table.map{45,137,194,166,409}

    extendedKoopas.kickedUnharmfulNPCs = {}


    local koopaCausingFilter

    local function npcIsKickable(v)
        return (
            Colliders.FILTER_COL_NPC_DEF(v)
            and v.despawnTimer > 0
            and v:mem(0x12C,FIELD_WORD) <= 0 -- held
            and v:mem(0x138,FIELD_WORD) == 0 -- forced state
            and (
                NPC.SHELL_MAP[v.id]
                or NPC.VEGETABLE_MAP[v.id]
                or extendedKoopas.alwaysKickableIDs[v.id]
                or (
                    koopaCausingFilter:mem(0x12C,FIELD_WORD) > 0
                    and NPC.HITTABLE_MAP[v.id]
                )
            )
        )
    end


    local function cancelKick(v,data,config)
        if data.kickNPC ~= nil and data.kickNPC.isValid and data.kickNPC:mem(0x12C,FIELD_WORD) == -1 and (data.kickTimer < config.beforeKickTime) then
            data.kickNPC:mem(0x12C,FIELD_WORD,0)
        end

        data.kickNPC = nil
    end



    local function handleKicking(v,data,config)
        local holdingPlayerIdx = v:mem(0x12C,FIELD_WORD)

        koopaCausingFilter = v -- the getColliding filter needs to know the beach koopa that's actually doing the check, so use this

        if data.kickNPC == nil then
            if config.beforeKickTime < 0 or config.afterKickTime < 0 then
                return
            end

            -- We're not kicking, so search for something to kick
            colBox.width = 4
            colBox.height = 18

            colBox.y = v.y + v.height - colBox.height

            if v.direction == DIR_LEFT then
                colBox.x = v.x + v.speedX - colBox.width
            else
                colBox.x = v.x + v.speedX + v.width
            end


            local npcs = Colliders.getColliding{a = colBox,btype = Colliders.NPC,filter = npcIsKickable}

            for _,kickNPC in ipairs(npcs) do
                if kickNPC ~= v then
                    data.kickNPC = kickNPC
                    data.kickTimer = 0

                    v.speedX = kickNPC.speedX * 0.75
                    kickNPC.speedX = 0

                    v:mem(0x18,FIELD_FLOAT,v.speedX)
                    kickNPC:mem(0x18,FIELD_FLOAT,0)

                    if v.direction == DIR_LEFT then
                        v.x = kickNPC.x + kickNPC.width
                    else
                        v.x = kickNPC.x - v.width
                    end

                    break
                end
            end
        end
        

        -- Check if the NPC is valid
        if data.kickNPC == nil or not data.kickNPC.isValid or not npcIsKickable(data.kickNPC) then
            cancelKick(v,data,config)
            return
        end


        if (v.speedX == 0 and (v.collidesBlockBottom and data.kickNPC.collidesBlockBottom)) or (data.kickTimer >= config.beforeKickTime) or (holdingPlayerIdx > 0) then
            v.speedX = 0
            v:mem(0x18,FIELD_FLOAT,0)

            data.kickTimer = data.kickTimer + 1
        elseif v.collidesBlockBottom then
            -- Sliding about
            if math.abs(v.speedX) > 0.5 and not v.underwater then
                v.speedX = v.speedX * 0.96
                data.kickTimer = 0

                if lunatime.tick()%3 == 0 then
                    local e = Effect.spawn(74,v.x + v.width*0.5 - v.width*0.5*v.direction,v.y + v.height)

                    e.x = e.x - e.width*0.5
                    e.y = e.y - e.height*0.5
                end
            else
                v.speedX = 0
                v:mem(0x18,FIELD_FLOAT,0)
            end
        else
            data.kickTimer = 0
        end



        if data.kickTimer == config.beforeKickTime then
            data.kickNPC.direction = v.direction
            data.kickNPC.speedX = v.direction * mem(SHELL_HORIZONTAL_SPEED,FIELD_FLOAT)

            if not NPC.SHELL_MAP[data.kickNPC.id] then
                data.kickNPC.speedY = -4
            end


            
            data.kickNPC:mem(0x136,FIELD_BOOL,true)

            data.kickNPC:mem(0x120,FIELD_BOOL,false)

            data.kickNPC:mem(0x12C,FIELD_WORD,0)


            if holdingPlayerIdx > 0 then
                data.kickNPC:mem(0x12E,FIELD_WORD,holdingPlayerIdx)
                data.kickNPC:mem(0x130,FIELD_WORD,30)
                data.kickNPC:mem(0x132,FIELD_WORD,holdingPlayerIdx)
            else
                data.kickNPC:mem(0x12E,FIELD_WORD,0)
                data.kickNPC:mem(0x130,FIELD_WORD,0)
                data.kickNPC:mem(0x132,FIELD_WORD,-1)

                if NPC.config[data.kickNPC.id].nohurt then
                    table.insert(extendedKoopas.kickedUnharmfulNPCs,data.kickNPC)
                end
            end



            if v.direction == DIR_LEFT then
                data.kickNPC.x = v.x - data.kickNPC.width
            else
                data.kickNPC.x = v.x + v.width
            end


            local e = Effect.spawn(75,0,0)

            e.x = v.x + v.width*0.5 + v.width*0.5*v.direction - e.width*0.5
            e.y = v.y + v.height - e.height

            SFX.play(9)
        elseif data.kickTimer >= (config.beforeKickTime + config.afterKickTime) then
            data.kickNPC = nil
            return
        end

        -- Stop the NPC
        if data.kickTimer < config.beforeKickTime then
            if v.direction == DIR_LEFT then
                data.kickNPC.x = v.x - data.kickNPC.width
            else
                data.kickNPC.x = v.x + v.width
            end

            if holdingPlayerIdx > 0 then
                data.kickNPC.direction = v.direction
                data.kickNPC.y = v.y + v.height - data.kickNPC.height

                data.kickNPC:mem(0x12C,FIELD_WORD,-1)
            elseif data.kickNPC:mem(0x136,FIELD_BOOL) then
                data.kickNPC.speedX = 0
                data.kickNPC:mem(0x18,FIELD_FLOAT,0)
                data.kickNPC.x = data.kickNPC.x + v.direction*2
            end
        end
    end


    local function npcIsShellFilter(v)
        if (
            not Colliders.FILTER_COL_NPC_DEF(v)
            or v:mem(0x136,FIELD_BOOL) -- projectile
            or v:mem(0x138,FIELD_WORD) ~= 0 -- forced state
            or v:mem(0x12C,FIELD_WORD) ~= 0 -- held
            or not extendedKoopas.shellIDMap[v.id]
        ) then
            return false
        end

        if NPC.config[v.id].hoppedInsideID == 0 then
            return false
        end

        local data = v.data

        if data.insideNPCID == nil or data.insideNPCID > 0 then
            return false
        end

        return true        
    end


    extendedKoopas.shellsToDejank = {}

    local defaultJumpableShells = {113,114,115,116}

    local function handleHoppingIntoShell(v,data,config)
        if config.beforeKickTime >= 0 and config.afterKickTime >= 0 then
            return
        end

        
        -- Hopping
        if v.collidesBlockBottom then
            data.hopping = false

            
            colBox.width = 24 * config.speed
            colBox.height = 1

            colBox.y = v.y + v.height - colBox.height

            if v.direction == DIR_LEFT then
                colBox.x = v.x + v.width*0.5 - colBox.width
            else
                colBox.x = v.x + v.width*0.5
            end


            local shells = Colliders.getColliding{a = colBox,btype = Colliders.NPC,filter = npcIsShellFilter}

            for _,shell in ipairs(shells) do
                if v ~= shell then
                    v.speedY = -4
                    data.hopping = true
                end
            end
        end


        -- Actually getting into the shell
        colBox.width = 8
        colBox.height = 1

        colBox.x = v.x + v.width*0.5 - colBox.width*0.5
        colBox.y = v.y + v.height - colBox.height


        local shells = Colliders.getColliding{a = colBox,btype = Colliders.NPC,filter = npcIsShellFilter}

        for _,shell in ipairs(shells) do
            colBox2.width = shell.width * 0.5
            colBox2.height = 4

            colBox2.x = shell.x + shell.width*0.5 - colBox2.width*0.5
            colBox2.y = shell.y + shell.height - colBox2.height

            if colBox:collide(colBox2) then
                local newID = NPC.config[shell.id].hoppedInsideID

                v:transform(newID)

                v.x = shell.x + shell.width*0.5 - v.width*0.5
                v.y = shell.y + shell.height - v.height

                if shell.spawnId > 0 then
                    shell:mem(0x124,FIELD_BOOL,false)
                    shell.despawnTimer = 0
                else
                    shell:kill(HARM_TYPE_VANISH)
                end

                return
            end
        end


        -- Stop getting into shells via redigit (AAAAAAAAAAAAAAAAAAAAAAAAAA)
        colBox.width = 12
        colBox.height = v.height + 4

        colBox.x = v.x + 10
        colBox.y = v.y - 2

        local shells = Colliders.getColliding{a = v,b = defaultJumpableShells,btype = Colliders.NPC}

        for _,shell in ipairs(shells) do
            colBox2.width = 12
            colBox2.height = shell.height + 4

            colBox2.x = shell.x + 10
            colBox2.y = shell.y - 2

            if colBox:collide(colBox2) then
                shell.friendly = true
                table.insert(extendedKoopas.shellsToDejank,shell)
            end
        end
    end


    function extendedKoopas.onTickEndBeachKoopa(v)
        if Defines.levelFreeze then return end
        
        local data = v.data
        
        if v.despawnTimer <= 0 then
            data.initializedID = nil
            return
        end


        if not extendedKoopas.beachKoopaIDMap[v.id] then -- idk
            return
        end


        local config = NPC.config[v.id]

        if data.initializedID == nil or data.initializedID ~= v.id then
            data.initializedID = v.id

            data.animationTimer = 0

            data.kickTimer = 0
            data.kickNPC = nil

            data.dontMoveTimer = 0

            data.facePlayerTimer = 0

            data.hopping = false
        end


        if v:mem(0x12C,FIELD_WORD) > 0 then
            handleKicking(v,data,config)
        elseif v:mem(0x136,FIELD_BOOL) then
            if config.quickerSliding then
                -- Blue koopas get out of their shells a little faster
                v.speedX = v.speedX * 0.98

                if math.abs(v.speedX) < 0.4 then
                    v.speedX = 0
                    v:mem(0x18,FIELD_FLOAT)

                    v:mem(0x136,FIELD_BOOL,false)

                    data.dontMoveTimer = 20
                end
            end
        elseif v:mem(0x12C,FIELD_WORD) == 0 and v:mem(0x138, FIELD_WORD) == 0 then
            handleKicking(v,data,config)

            if data.kickNPC == nil then
                if v:mem(0x120,FIELD_BOOL) then
                    if not data.hopping then
                        v.direction = -v.direction
                    end

                    v:mem(0x120,FIELD_BOOL,false)
                end

                if data.dontMoveTimer > 0 then
                    data.dontMoveTimer = data.dontMoveTimer - 1
                    v.speedX = 0
                else
                    handleFacingPlayer(v,data,config)

                    v.speedX = config.speed * v.direction

                    handleHoppingIntoShell(v,data,config)
                end
            end
        else
            data.kickNPC = nil
        end


        v.ai1 = -1 -- disable original kicking

        -- Disable original jumping into shell
        if v.speedY == 0 then
            v.speedY = v.speedY + 0.0001
        end


        handleAnimation(v,data,config)
    end


    function extendedKoopas.onPostNPCKillBeachKoopa(v,reason)
        if not extendedKoopas.beachKoopaIDMap[v.id] then return end

        local config = NPC.config[v.id]
        local data = v.data

        cancelKick(v,data,config)
    end
end


function extendedKoopas.onTickEnd()
    -- jank...
    for i = #extendedKoopas.shellsToDejank, 1, -1 do
        local shell = extendedKoopas.shellsToDejank[i]

        if shell.isValid then
            shell.friendly = false
        end

        extendedKoopas.shellsToDejank[i] = nil
    end

    -- Make kicked vegetables and stuff actually hurt the player
    for i = #extendedKoopas.kickedUnharmfulNPCs, 1, -1 do
        local v = extendedKoopas.kickedUnharmfulNPCs[i]

        if v.isValid and v.despawnTimer > 0 and Colliders.FILTER_COL_NPC_DEF(v) and v:mem(0x136,FIELD_BOOL) and v:mem(0x12C,FIELD_WORD) == 0 then
            for _,p in ipairs(Player.getIntersecting(v.x + v.speedX,v.y + v.speedY,v.x + v.width + v.speedX,v.y + v.height + v.speedY)) do
                p:harm()
            end
        else
            table.remove(extendedKoopas.kickedUnharmfulNPCs,i)
        end
    end
end


function extendedKoopas.onInitAPI()
    registerEvent(extendedKoopas,"onNPCHarm","onNPCHarmShell")
    registerEvent(extendedKoopas,"onNPCHarm","onNPCHarmKoopa")
    registerEvent(extendedKoopas,"onPostNPCKill","onPostNPCKillBeachKoopa")

    registerEvent(extendedKoopas,"onTickEnd")
end


-- Register all the original koopas
do
    local defaultKoopaIDs = {
        109,110,111,112, 285, -- smw
        4,6,23,36, -- smb3
        173,175, -- smb
    }
    local defaultParakoopaIDs = {
        121,122,123,124, -- smw
        76,161, -- smb3
        176,177, -- smb
    }
    local defaultShellIDs = {
        113,114,115,116, -- smw
        5,7,24, -- smb3
        172,174, -- smb
    }
    local defaultBeachKoopaIDs = {
        117,118,119,120,
    }

    for _,npcID in ipairs(defaultKoopaIDs) do
        NPC.config[npcID].iswalker = false
        NPC.config[npcID].luahandlesspeed = true

        extendedKoopas.registerKoopa(npcID)

        npcManager.registerHarmTypes(npcID,
            {
                HARM_TYPE_JUMP,
                HARM_TYPE_FROMBELOW,
                HARM_TYPE_TAIL,
            },{}
        )
    end

    for _,npcID in ipairs(defaultParakoopaIDs) do
        extendedKoopas.registerKoopa(npcID)

        npcManager.registerHarmTypes(npcID,
            {
                HARM_TYPE_JUMP,
                HARM_TYPE_FROMBELOW,
                HARM_TYPE_TAIL,
            },{}
        )
    end

    for _,npcID in ipairs(defaultShellIDs) do
        extendedKoopas.registerShell(npcID,false)

        npcManager.registerHarmTypes(npcID,
            {
                HARM_TYPE_FROMBELOW,
                HARM_TYPE_TAIL,
            },{}
        )
    end

    for _,npcID in ipairs(defaultBeachKoopaIDs) do
        NPC.config[npcID].iswalker = false
        NPC.config[npcID].luahandlesspeed = true
        NPC.config[npcID].staticdirection = true

        extendedKoopas.registerBeachKoopa(npcID)
    end
end


return extendedKoopas