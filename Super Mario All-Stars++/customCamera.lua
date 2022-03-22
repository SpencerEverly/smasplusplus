--[[

    customCamera.lua (v1.0.1)
    by MrDoubleA

    Adds more advanced camera controls to SMBX.


    ---- DOCS FOR ADDING THINGS TO CUSTOMCAMERA.DRAWSCENE ----

    These three functions are for your own use:

    customCamera.registerNPCDraw(id, drawFunc)
    customCamera.registerBlockDraw(id, drawFunc)
    customCamera.registerSceneDraw(drawFunc)

    The first 2 register a drawing function for an NPC/block ID for when drawScene is used,
    and get the drawing args and the instance of the block/NPC as an argument.
    The third registers a function to be run whenever drawScene is used, regardless of object,
    and simply gets the drawing args.

    When using these, it's needed to use some of these functions:
    

    customCamera.convertPriority(args,priority)
    Converts and returns a given priority to work for the drawScene.

    customCamera.convertPosToScreen(args,x,y)
    Applies the rotation, scale and X/Y of the drawing args to an X/Y. Returns an X, Y, scale, rotation.

    customCamera.isInExclusion(args,x,y,width,height)
    Returns if the given is in the argument's "exclusion zone": an area in which it's fine to not draw anything.

]]

local blockutils = require("blocks/blockutils")
local npcutils = require("npcs/npcutils")
local playerManager = require("playerManager")
local sizable = require("game/sizable")
local handycam = require("handycam")


local customCamera = {}


local zoomedBuffer = Graphics.CaptureBuffer(800,600)


local STAR_COUNT_ADDR = 0x00B251E0


customCamera.transitionSpeed = 0.05
customCamera.boundaryEnterSpeed = 8
customCamera.boundaryExitSpeed = 8


customCamera.defaultZoom = 1
customCamera.defaultRotation = 0

customCamera.defaultOffsetX = 0
customCamera.defaultOffsetY = 0

customCamera.defaultScreenWidth = 0 -- 0 means to use camera.width/camera.height
customCamera.defaultScreenHeight = 0
customCamera.defaultScreenOffsetX = 0
customCamera.defaultScreenOffsetY = 0

customCamera.targets = {}


customCamera.controllerID = 0 -- these two are filled in by the block-n.lua files
customCamera.blockerID = 0

customCamera.lastSection = nil
customCamera.lastWarpCooldown = 0


customCamera.debug = false


-- drawScene function
do
    local SPECIAL_FRAMES_ADDR = mem(0x00B2BF30,FIELD_DWORD)
    local PLAYER_FAIRY_FRAME_ADDR = SPECIAL_FRAMES_ADDR + 9*2

    local screenBuffer = Graphics.CaptureBuffer(800,600)
    local sizableBuffer = Graphics.CaptureBuffer(512,1200)
    local playerBuffer = Graphics.CaptureBuffer(400,150)
    local backgroundBuffer = Graphics.CaptureBuffer(800,600)


    local npcDraws = {}
    local blockDraws = {}
    local sceneDraws = {}

    function customCamera.registerNPCDraw(id,func)
        npcDraws[id] = func
    end
    function customCamera.registerBlockDraw(id,func)
        blockDraws[id] = func
    end
    function customCamera.registerSceneDraw(func)
        table.insert(sceneDraws,func)
    end


    function customCamera.convertPriority(args,priority)
        return math.lerp(args.maxPriority,args.minPriority,math.clamp(priority/-100))
    end

    function customCamera.convertPosToScreen(args,x,y) -- returns x, y, scale, and rotation
        x = x - args.x
        y = y - args.y

        if args.rotation%360 > 0 then
            local w = args.width*0.5
            local h = args.height*0.5
            local baseX = x - w
            local baseY = y - h

            x = baseX*args.rotationCos - baseY*args.rotationSin + w
            y = baseX*args.rotationSin + baseY*args.rotationCos + h
        end

        x = x*args.scale
        y = y*args.scale

        return x,y,args.scale,args.rotation
    end

    function customCamera.isInExclusion(args,x,y,width,height)
        if args.exclusionX1 == nil then
            return false
        end

        return (x >= args.exclusionX1 and y >= args.exclusionY1 and x+width <= args.exclusionX2 and y+height <= args.exclusionY2)
    end


    local quadVC = {}
    local quadTC = {}
    local quadDrawArgs = {vertexCoords = quadVC,textureCoords = quadTC,primitive = Graphics.GL_TRIANGLE_FAN}

    function customCamera.drawQuadToScene(args,texture,priority,x,y,width,height,sourceX,sourceY,scale,rotation)
        local screenX,screenY,screenScale,screenRotation = customCamera.convertPosToScreen(args,x,y)

        quadDrawArgs.priority = customCamera.convertPriority(args,priority)
        quadDrawArgs.linearFiltered = args.linearFiltered
        quadDrawArgs.target = args.target
        quadDrawArgs.texture = texture

        rotation = rotation or 0
        scale = scale or 1

        -- Vertex coords
        local cos,sin

        if rotation%360 > 0 then
            screenRotation = math.rad(screenRotation + rotation)

            cos = math.cos(screenRotation)
            sin = math.sin(screenRotation)
        else
            cos = args.rotationCos
            sin = args.rotationSin
        end

        local w = width*scale*screenScale*0.5
        local h = height*scale*screenScale*0.5
        local w1 = cos*w
        local w2 = sin*w
        local h1 = sin*h
        local h2 = cos*h

        quadVC[1] = screenX + h1 - w1 -- top left
        quadVC[2] = screenY - h2 - w2
        quadVC[3] = screenX + h1 + w1 -- top right
        quadVC[4] = screenY - h2 + w2
        quadVC[5] = screenX - h1 + w1 -- bottom right
        quadVC[6] = screenY + h2 + w2
        quadVC[7] = screenX - h1 - w1 -- bottom left
        quadVC[8] = screenY + h2 - w2

        -- Texture coords
        local tx1 = sourceX/texture.width
        local ty1 = sourceY/texture.height
        local tx2 = (sourceX + width)/texture.width
        local ty2 = (sourceY + height)/texture.height

        quadTC[1] = tx1 -- top left
        quadTC[2] = ty1
        quadTC[3] = tx2 -- top right
        quadTC[4] = ty1
        quadTC[5] = tx2 -- bottom right
        quadTC[6] = ty2
        quadTC[7] = tx1 -- bottom left
        quadTC[8] = ty2

        -- Draw!
        Graphics.glDraw(quadDrawArgs)
    end


    -- Player
    local invisiblePlayerStates = table.map{FORCEDSTATE_INVISIBLE,FORCEDSTATE_POWERUP_LEAF,FORCEDSTATE_SWALLOWED}

    local function renderPlayer(args,p)
        if customCamera.isInExclusion(args,p.x - 16,p.y - 16,p.width + 32,p.height + 32) then
            return
        end

        if invisiblePlayerStates[p.forcedState] or p:mem(0x142,FIELD_BOOL) then
            return
        end


        local priority
        if p.forcedState == FORCEDSTATE_PIPE then
            priority = customCamera.convertPriority(args,-75)
        elseif p.mount == MOUNT_CLOWNCAR then
            priority = customCamera.convertPriority(args,-35)
        else
            priority = customCamera.convertPriority(args,-25)
        end


        if p:mem(0x0C,FIELD_BOOL) then -- fairy
            local texture = Graphics.sprites.npc[254].img -- kinda weird this uses the actual NPC image instead of a hardcoded one like the rest but whatever
            if texture == nil then
                return
            end

            local frame = mem(PLAYER_FAIRY_FRAME_ADDR,FIELD_WORD) + 1
            if p.direction == DIR_LEFT then
                frame = frame + 2
            end

            local width = 32
            local height = 32

            local x,y,scale,rotation = customCamera.convertPosToScreen(args,p.x + width*0.5 - 5,p.y + height*0.5 - 2)

            Graphics.drawBox{
                texture = texture,target = args.target,priority = priority,
                linearFiltered = args.linearFiltered,centred = true,

                x = x,y = y,rotation = rotation,
                width = width*scale,
                height = height*scale,

                sourceWidth = width,
                sourceHeight = height,
                sourceY = frame*height,
            }

            return
        end

        -- Normal rendering
        local topLeftX = (playerBuffer.width  - p.width )*0.5
        local topLeftY = (playerBuffer.height - p.height)*0.5

        playerBuffer:clear(priority)


        -- Yoshi tongue
        if p.mount == MOUNT_YOSHI and p:mem(0x10C,FIELD_WORD) > 0 then
            local headImage = Graphics.sprites.hardcoded["21-1"].img
            local headX = p:mem(0x80,FIELD_DFLOAT) - p.x + topLeftX
            local headY = p:mem(0x88,FIELD_DFLOAT) - p.y + topLeftY
            local headFrame = 0

            local bodyImage = Graphics.sprites.hardcoded["21-2"].img
            local bodyLength = p:mem(0xB4,FIELD_WORD)
            local bodyX = headX

            if p.direction == DIR_RIGHT then
                bodyX = bodyX - bodyLength
            else
                bodyX = bodyX + 16
                headFrame = 1
            end

            -- "Body" of the tongue
            Graphics.drawBox{
                texture = bodyImage,target = playerBuffer,priority = priority,
                sourceWidth = bodyLength + 2,
                sourceHeight = 16,
                
                x = bodyX,y = headY,
            }

            -- "Head" of the tongue
            Graphics.drawBox{
                texture = headImage,target = playerBuffer,priority = priority,
                sourceWidth = 16,
                sourceHeight = 16,
                sourceY = 16*headFrame,
                x = headX,y = headY,
            }
        end


        p:render{
            target = playerBuffer,priority = priority,sceneCoords = false,
            ignorestate = (p.forcedState == 73), -- noclip cheat fix
            x = topLeftX,y = topLeftY,
        }


        -- Yoshi/blue boot wings
        if (p.mount == MOUNT_YOSHI and p:mem(0x66,FIELD_BOOL)) or (p.mount == MOUNT_BOOT and p.mountColor == BOOTCOLOR_BLUE) then
            local frame = p:mem(0x6A,FIELD_WORD)
            local wingsX,wingsY

            local width = 32
            local height = 32

            if p.mount == MOUNT_BOOT then
                wingsX = topLeftX + p.width*0.5 - 20*p.direction - width*0.5
                wingsY = topLeftY + p.height - height - 8
            else
                wingsX = p:mem(0x76,FIELD_WORD) + topLeftX - 12*p.direction
                wingsY = p:mem(0x78,FIELD_WORD) + topLeftY - height*0.5
            end

            Graphics.drawBox{
                texture = Graphics.sprites.hardcoded["19"].img,target = playerBuffer,priority = priority,
                sourceWidth = width,
                sourceHeight = height,
                sourceY = height*frame,
                x = wingsX,y = wingsY,
            }
        end


        customCamera.drawQuadToScene(args,playerBuffer,priority,p.x + p.width*0.5,p.y + p.height*0.5,playerBuffer.width,playerBuffer.height,0,0)
    end


    -- NPC
    local function spawnNPC(args,n)
        if n.isHidden then
            return
        end

        -- Complex and weird system to fix NPC spawning with a zoomed out camera...
        if n.despawnTimer <= 0 and not n:mem(0x126,FIELD_BOOL) and (n.x+n.width < camera.x or n.y+n.height < camera.y or n.x > camera.x+camera.width or n.y > camera.y+camera.height) then
            n.data._customCameraNoSpawnTime = lunatime.tick()
        else
            local noSpawnTime = n.data._customCameraNoSpawnTime

            if noSpawnTime ~= nil and noSpawnTime > lunatime.tick()-2 then
                n.data._customCameraNoSpawnTime = lunatime.tick()
            else
                n.data._customCameraNoSpawnTime = nil
            end
        end


        if n:mem(0x124,FIELD_BOOL) or (n:mem(0x126,FIELD_BOOL) and n.data._customCameraNoSpawnTime == nil) then
            if not n:mem(0x124,FIELD_BOOL) then
                n:mem(0x124,FIELD_BOOL,true)
                n:mem(0x14C,FIELD_WORD,1)
            end

            n.despawnTimer = 180
        end

        n:mem(0x126,FIELD_BOOL,false)
        n:mem(0x128,FIELD_BOOL,false)
    end


    local lowPriorityNPCStates = table.map{1,3,4,208}
    local visibleNPCStates = table.map{0,1,3,4,5,208}

    local yoshiRunAnimationFrames = {0,0,1,1,2,2,1,1}
    local yoshiNPCColors = {
        [95]  = YOSHICOLOR_GREEN,
        [98]  = YOSHICOLOR_BLUE,
        [99]  = YOSHICOLOR_YELLOW,
        [100] = YOSHICOLOR_RED,
        [148] = YOSHICOLOR_BLACK,
        [149] = YOSHICOLOR_PURPLE,
        [150] = YOSHICOLOR_PINK,
        [228] = YOSHICOLOR_CYAN,
    }

    local function getNPCPriority(n,normalPriority,forePriority)
        if lowPriorityNPCStates[n:mem(0x138,FIELD_WORD)] then
            return -75
        end
        

        local holdingPlayerIdx = n:mem(0x12C,FIELD_WORD)

        if holdingPlayerIdx > 0 then
            local p = Player(holdingPlayerIdx)

            if p.isValid then
                local baseChar = playerManager.getBaseID(p.character)

                if baseChar == CHARACTER_PEACH or baseChar == CHARACTER_TOAD then
                    return -24.99
                else
                    return -30
                end
            end
        end


        if NPC.config[n.id].foreground then
            return forePriority or -15
        else
            return normalPriority or -45
        end
    end

    local function renderNPC(args,n)
        local func = npcDraws[n.id]

        if func ~= nil then
            func(args,n)
            return
        end


        local texture = Graphics.sprites.npc[n.id].img

        if texture == nil or n.despawnTimer <= 0 or n.animationFrame < 0
        or not visibleNPCStates[n:mem(0x138,FIELD_WORD)] or customCamera.isInExclusion(args,n.x,n.y,n.width,n.height)
        then
            return
        end

        local priority = getNPCPriority(n)
        local config = NPC.config[n.id]


        if config.isyoshi then
            local color = yoshiNPCColors[n.id] or YOSHICOLOR_GREEN

            local headImage = Graphics.sprites.yoshit[color].img
            local headWidth = 32
            local headHeight = 32
            local headFrame = 0
            local headX = 20
            local headY = -32

            local bodyImage = Graphics.sprites.yoshib[color].img
            local bodyWidth = 32
            local bodyHeight = 32
            local bodyFrame = 6
            local bodyX = 0
            local bodyY = 0
            
            -- Yoshi animation only updates when on screen, so we have to do it manually here. Also, to keep it accurate to the original,
            -- this doesn't check if the game is paused.
            local updateAnimation = (not Defines.levelFreeze and (n.x+n.width < camera.x or n.y+n.height < camera.y or n.x > camera.x+camera.width or n.y > camera.y+camera.height))

            if n.ai1 > 0 then
                if updateAnimation then
                    n.animationTimer = (n.animationTimer + 1) % 8
                    n.ai2 = (n.ai2 + 1) % 30
                end

                local frame = yoshiRunAnimationFrames[n.animationTimer] or 0
                
                headX = headX + frame
                headY = headY + frame*2
                bodyY = bodyY + frame
                bodyFrame = frame
                
                if n.ai2 > 10 then
                    headFrame = 2
                end
            else
                if updateAnimation then
                    n.animationTimer = (n.animationTimer + 1) % 70
                end

                if n.animationTimer >= 50 then
                    headFrame = 3
                end

                headY = headY + 10
                bodyY = bodyY + 10
            end

            if n.direction == DIR_RIGHT then
                headFrame = headFrame + 5
                bodyFrame = bodyFrame + 7
            else
                headX = -headX
                bodyX = -bodyX
            end

            customCamera.drawQuadToScene(args,bodyImage,priority,n.x + bodyX + bodyWidth*0.5,n.y + bodyY + bodyHeight*0.5,bodyWidth,bodyHeight,0,bodyFrame*bodyHeight)
            customCamera.drawQuadToScene(args,headImage,priority,n.x + headX + headWidth*0.5,n.y + headY + headHeight*0.5,headWidth,headHeight,0,headFrame*headHeight)

            return
        end


        local fullGFXWidth = config.gfxwidth
        local fullGFXHeight = config.gfxheight
        local partGFXWidth = fullGFXWidth
        local partGFXHeight = fullGFXHeight

        if fullGFXWidth == 0 then
            fullGFXWidth = config.width
            partGFXWidth = n.width
        end
        if fullGFXHeight == 0 then
            fullGFXHeight = config.height
            partGFXHeight = n.height
        end


        local sceneX = n.x + n.width*0.5 + config.gfxoffsetx
        local sceneY = n.y + n.height - partGFXHeight*0.5 + config.gfxoffsety

        customCamera.drawQuadToScene(args,texture,priority,sceneX,sceneY,partGFXWidth,partGFXHeight,0,n.animationFrame*fullGFXHeight)
    end


    -- Blocks
    local function renderBlock(args,b)
        local func = blockDraws[b.id]

        if func ~= nil then
            func(args,b)
            return
        end

        
        local texture = Graphics.sprites.block[b.id].img

        if texture == nil or b.isHidden or b:mem(0x5A,FIELD_BOOL) or customCamera.isInExclusion(args,b.x,b.y,b.width,b.height) then
            return
        end

        local config = Block.config[b.id]

        local sceneX = b.x + b.width*0.5
        local sceneY = b.y + b.height*0.5

        local priority
        local frame = 0
        local image
        
        if Block.SIZEABLE_MAP[b.id] then
            priority = -90

            -- Block is larger than the sizeable buffer is, so sort that out
            if b.width > sizableBuffer.width or b.height > sizableBuffer.height then
                sizableBuffer = Graphics.CaptureBuffer(math.max(sizableBuffer.width,b.width),math.max(sizableBuffer.height,b.height))
            else
                sizableBuffer:clear(priority)
            end

            -- Move block to be in top left of the screen and then draw to the sizeable buffer
            local originalX = b.x
            local originalY = b.y

            b.x = camera.x
            b.y = camera.y

            sizable.drawSizable(b,camera,priority,sizableBuffer)

            b.x = originalX
            b.y = originalY

            
            image = sizableBuffer
        else
            sceneY = sceneY + b:mem(0x56,FIELD_WORD)

            frame = blockutils.getBlockFrame(b.id)
            image = texture

            if Block.LAVA_MAP[b.id] then
                priority = -15
            else
                priority = -65
            end
        end

        if frame < 0 then
            return
        end


        customCamera.drawQuadToScene(args,image,priority,sceneX,sceneY,b.width,b.height,0,frame*config.height)
    end


    -- BGO's
    local function renderBGO(args,b)
        local texture = Graphics.sprites.background[b.id].img

        if texture == nil or b.isHidden or customCamera.isInExclusion(args,b.x,b.y,b.width,b.height) then
            return
        end

        local config = BGO.config[b.id]

        local frame = math.floor(lunatime.drawtick()/math.max(1,config.framespeed)) % config.frames -- actual frame table is local...

        customCamera.drawQuadToScene(args,texture,config.priority,b.x + b.width*0.5,b.y + b.height*0.5,b.width,b.height,0,frame*config.height)
    end


    -- Effects
    local lowPriorityEffects = table.map{112,54,55,59,77,81,82,103,104,114,123,124}

    local function renderEffect(args,e)
        local texture = Graphics.sprites.effect[e.id].img

        if texture == nil or e.animationFrame < 0 or customCamera.isInExclusion(args,e.x,e.y,e.width,e.height) then
            return
        end

        local priority
        if lowPriorityEffects[e.id] then
            priority = -60
        else
            priority = -5
        end

        customCamera.drawQuadToScene(args,texture,priority,e.x + e.width*0.5,e.y + e.height*0.5,e.width,e.height,0,e.animationFrame*e.height)
    end



    function customCamera.drawScene(args)
        args.minPriority = args.minPriority or -100
        args.maxPriority = args.maxPriority or 0

        args.rotation = args.rotation or 0
        args.scale = args.scale or 1
        args.x = args.x or camera.x
        args.y = args.y or camera.y

        if args.target ~= nil then
            args.width  = args.width  or (args.target.width /args.scale)
            args.height = args.height or (args.target.height/args.scale)
        else
            args.width  = args.width  or (camera.width /args.scale)
            args.height = args.height or (camera.height/args.scale)
        end

        if args.linearFiltered == nil then
            -- By default, just match if the screen is gonna use it
            args.linearFiltered = (args.scale < 1 or args.rotation%360 > 0)
        end

        args.rotationRad = math.rad(args.rotation)
        args.rotationSin = math.sin(args.rotationRad)
        args.rotationCos = math.cos(args.rotationRad)


        -- Calculate culling
        do
            local w = args.width*0.5
            local h = args.height*0.5

            local x = args.x + w
            local y = args.y + h
            
            local w1 = args.rotationCos*w
            local w2 = args.rotationSin*w
            local h1 = args.rotationSin*h
            local h2 = args.rotationCos*h

            --[[
            x + h1 - w1    top left
            y - h2 - w2
            x + h1 + w1    top right
            y - h2 + w2
            x - h1 + w1    bottom right
            y + h2 + w2
            x - h1 - w1    bottom left
            y + h2 - w2
            ]]

            args.cullX1 = math.min(x + h1 - w1,x - h1 - w1)
            args.cullY1 = math.min(y - h2 - w2,y - h2 + w2)
            args.cullX2 = math.max(x + h1 + w1,x - h1 + w1)
            args.cullY2 = math.max(y + h2 + w2,y + h2 - w2)
        end

        if args.useScreen then
            args.exclusionX1 = camera.x
            args.exclusionY1 = camera.y
            args.exclusionX2 = camera.x + camera.width
            args.exclusionY2 = camera.y + camera.height
        end

        
        -- Render non-sizeable blocks
        for _,b in Block.iterateIntersecting(args.cullX1,args.cullY1,args.cullX2,args.cullY2) do
            if not Block.SIZEABLE_MAP[b.id] then
                renderBlock(args,b)
            end
        end

        -- Render sizeables (must be done in a specific order, hence why it's done separate)
        for _,b in Block.iterateSizable() do
            if b.x < args.cullX2 and b.x+b.width > args.cullX1 and b.y < args.cullY2 and b.y+b.height > args.cullY1 then
                renderBlock(args,b)
            end
        end



        for _,b in BGO.iterateIntersecting(args.cullX1,args.cullY1,args.cullX2,args.cullY2) do
            renderBGO(args,b)
        end

        for _,n in NPC.iterateIntersecting(args.cullX1,args.cullY1,args.cullX2,args.cullY2) do
            if not args.dontAffectSpawning then
                spawnNPC(args,n)
            end

            renderNPC(args,n)
        end

        for _,e in ipairs(Effect.get()) do
            if type(e) ~= "table" then -- bettereffects failsafe
                renderEffect(args,e)
            end
        end

        for _,p in ipairs(Player.get()) do
            renderPlayer(args,p)
        end


        for _,func in ipairs(sceneDraws) do
            func(args)
        end




        if args.useScreen then
            local x,y,scale,rotation = customCamera.convertPosToScreen(args,camera.x + camera.width*0.5,camera.y + camera.height*0.5)

            local width = screenBuffer.width*scale
            local height = screenBuffer.height*scale

            if args.drawBackgroundToScreen then
                backgroundBuffer:captureAt(-96)

                Graphics.drawScreen{
                    texture = backgroundBuffer,target = args.target,priority = math.max(-96,args.minPriority),
                    linearFiltered = args.linearFiltered,
                }

                Graphics.drawBox{
                    texture = backgroundBuffer,priority = -96,centred = true,
                    --color = Color.lightgrey,
                    rotation = -rotation,

                    x = camera.width*0.5,y = camera.height*0.5,
                    width = backgroundBuffer.width/scale,
                    height = backgroundBuffer.height/scale,
                    sourceX = x - backgroundBuffer.width*0.5,
                    sourceY = y - backgroundBuffer.height*0.5,
                }
            end
            
            screenBuffer:captureAt(args.maxPriority)

            Graphics.drawBox{
                texture = screenBuffer,target = args.target,priority = args.maxPriority,
                --color = Color.grey,
                centred = true,

                x = x,y = y,rotation = rotation,
                width = width,height = height,
            }
        end
    end
end


-- Special compatbility for NPC's for drawScene
do
    local function drawBarrel(args,n)
        if n.despawnTimer <= 0 or n.isHidden or customCamera.isInExclusion(args,n.x,n.y,n.width,n.height) then
            return
        end

        local data = n.data._basegame
        local sprite = data.sprite

        if sprite == nil then
            return
        end

        -- Copied from launchBarrel.lua
        local config = NPC.config[n.id]

        local p = -45
        if config.foreground then
            p = -15
        end

        customCamera.drawQuadToScene(args,sprite.texture,p,sprite.x,sprite.y,sprite.width,sprite.height,0,0,1,sprite.rotation)
    end

    for id = 600,603 do
        customCamera.registerNPCDraw(id,drawBarrel)
    end
end



function customCamera.getFullCameraPos()
    local b = player.sectionObj.boundary

    local zoom = customCamera.currentZoom
    local handycamObj = rawget(handycam,1)

    if handycamObj ~= nil and zoom == 1 then
        zoom = handycamObj.zoom
    end

    local fullWidth = customCamera.screenWidth/zoom
    local fullHeight = customCamera.screenHeight/zoom
    local fullX = camera.x + (camera.width  - fullWidth )*0.5
    local fullY = camera.y + (camera.height - fullHeight)*0.5

    return fullX,fullY,fullWidth,fullHeight
end

function customCamera.clampFocusToBounds(focus)
    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()

    local settings = customCamera.currentSettings
    local oldSettings = customCamera.previousSettings

    local b = player.sectionObj.boundary

    local boundLeft   = math.max(customCamera.currentBounds[1] or -math.huge,b.left)
    local boundRight  = math.min(customCamera.currentBounds[2] or  math.huge,b.right)
    local boundTop    = math.max(customCamera.currentBounds[3] or -math.huge,b.top)
    local boundBottom = math.min(customCamera.currentBounds[4] or  math.huge,b.bottom)

    local boundsWidth = boundRight - boundLeft
    local boundsHeight = boundBottom - boundTop


    local x = focus.x
    local y = focus.y

    if boundsWidth > fullWidth then
        x = math.clamp(x,boundLeft + fullWidth*0.5,boundRight - fullWidth*0.5)
    else
        x = boundLeft + boundsWidth*0.5
    end
    if boundsHeight > fullHeight then
        y = math.clamp(y,boundTop + fullHeight*0.5,boundBottom - fullHeight*0.5)
    else
        y = boundTop + boundsHeight*0.5
    end

    return vector(x,y)
end

function customCamera.isOnScreen(x,y,width,height) -- accepts an X/Y, X/Y/width/height, or any object with properties for those.
    if type(x) ~= "number" then
        return customCamera.isOnScreen(x.x,x.y,x.width,x.height)
    end

    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()

    if width ~= nil then
        return (x+width > fullX and x < fullX+fullWidth and y+height > fullY and y < fullY+fullHeight)
    else
        return (x > fullX and x < fullX+fullWidth and y > fullY and y < fullY+fullHeight)
    end
end



local function canResetFromWarping()
    if customCamera.lastSection ~= player.section or (player.forcedState == FORCEDSTATE_PIPE and player.forcedTimer == 101) then
        return true
    end

    if player:mem(0x15C,FIELD_WORD) > customCamera.lastWarpCooldown then
        -- Check if in an exit to a warp, if so we can guess that it came from a warp (not perfect, but hey!)
        for _,warp in ipairs(Warp.getIntersectingExit(player.x,player.y,player.x+player.width,player.height)) do
            if not warp.isHidden and not warp.toOtherLevel and not warp.locked and warp.warpType ~= 1 and mem(STAR_COUNT_ADDR,FIELD_WORD) >= warp.starsRequired then
                return true
            end
        end
    end

    return false
end


local compareSettings = {"zoom","rotation","screenWidth","screenHeight","screenOffsetX","screenOffsetY","offsetX","offsetY","targetNPCID"}

local function settingsAreDifferent(a,b)
    for _,name in ipairs(compareSettings) do
        if a[name] ~= b[name] then
            return true
        end
    end

    for i = 1,4 do
        if a.bounds[i] ~= b.bounds[i] then
            return true
        end
    end

    return false
end

local function copyBounds(t)
    local b = {}

    for i = 1,4 do
        b[i] = t[i]
    end

    return b
end

local function sortControllers(a,b)
    local settingsA = a.data._settings
    local settingsB = b.data._settings

    if settingsA.priority ~= settingsB.priority then
        return (settingsA.priority < settingsB.priority)
    end

    if a.y ~= b.y then
        return (a.y < b.y)
    end

    return (a.idx < b.idx)
end


local function makeDefaultSettings()
    local screenWidth = customCamera.defaultScreenWidth
    local screenHeight = customCamera.defaultScreenHeight

    if screenWidth == 0 then
        screenWidth = camera.width
    end
    if screenHeight == 0 then
        screenHeight = camera.height
    end


    return {
        zoom = customCamera.defaultZoom,
        rotation = customCamera.defaultRotation,

        offsetX = customCamera.defaultOffsetX,
        offsetY = customCamera.defaultOffsetY,

        screenWidth = screenWidth,
        screenHeight = screenHeight,
        screenOffsetX = customCamera.defaultScreenOffsetX,
        screenOffsetY = customCamera.defaultScreenOffsetY,

        targetNPCID = 0,

        bounds = {nil,nil,nil,nil},
    }
end



local function targetsAreDifferent(listA,listB)
    local countA = #listA
    local countB = #listB

    if countA ~= countB then
        return true
    end

    for _,a in ipairs(listA) do
        if not table.icontains(listB,a) then
            return true
        end
    end

    return false
end

local function getTargets()
    -- Use customCamera.targets if possible
    local targets = {}
    local count = 0

    for _,v in ipairs(customCamera.targets) do
        if v.isValid ~= false and (v[1] ~= nil or v.x ~= nil) and (v[2] ~= nil or v.y ~= nil) then
            table.insert(targets,v)
            count = count + 1
        end
    end

    if count > 0 then
        return targets
    end

    -- Otherwise, use NPC ID system
    if customCamera.currentSettings.targetNPCID > 0 then
        for _,n in NPC.iterate(customCamera.currentSettings.targetNPCID) do
            if n.despawnTimer > 0 and customCamera.isOnScreen(n) then
                table.insert(targets,n)
                count = count + 1
            end
        end
    end

    -- Add player
    table.insert(targets,player)
    count = count + 1

    return targets
end

local function getCameraFocusFromTargets(targets)
    local total = vector.zero2
    local count = 0

    for _,v in ipairs(targets) do
        if v.isValid ~= false then
            local x = v[1] or v.x
            local y = v[2] or v.y
            local width = v.width
            local height = v.height

            if width ~= nil and height ~= nil then
                x = x + width*0.5
                y = y + height
            end

            total.x = total.x + x
            total.y = total.y + y
            count = count + 1
        end
    end

    if count == 0 then
        total.x = player.x + player.width*0.5
        total.y = player.y + player.height
    else
        total.x = total.x/count
        total.y = total.y/count
    end

    return total
end


local function getCurrentSettings()
    local settings = makeDefaultSettings()

    if customCamera.controllerID > 0 and EventManager.onStartRan then
        -- Collect active controllers, then sort
        local controllers = {}

        for _,b in Block.iterateIntersecting(player.x,player.y,player.x+player.width,player.y+player.height) do
            if b.id == customCamera.controllerID and not b.isHidden and not b:mem(0x5A,FIELD_BOOL) then
                table.insert(controllers,b)
            end
        end

        if #controllers > 1 then
            table.sort(controllers,sortControllers)
        end

        -- Consider its effects, now in order of priority
        for _,b in ipairs(controllers) do
            local blockSettings = b.data._settings

            if blockSettings.zoom > 0 then
                settings.zoom = blockSettings.zoom
            end
            if blockSettings.rotation ~= 0 then
                settings.rotation = blockSettings.rotation
            end
            if blockSettings.targetNPCID > 0 then
                settings.targetNPCID = blockSettings.targetNPCID
            end

            if blockSettings.screenWidth > 0 then
                settings.screenWidth = blockSettings.screenWidth
            end
            if blockSettings.screenHeight > 0 then
                settings.screenHeight = blockSettings.screenHeight
            end

            settings.screenOffsetX = settings.screenOffsetX + blockSettings.screenOffsetX
            settings.screenOffsetY = settings.screenOffsetY + blockSettings.screenOffsetY


            if blockSettings.boundOnLeft then
                settings.bounds[1] = math.max(settings.bounds[1] or -math.huge,b.x)
            end
            if blockSettings.boundOnRight then
                settings.bounds[2] = math.min(settings.bounds[2] or math.huge,b.x + b.width)
            end
            if blockSettings.boundOnTop then
                settings.bounds[3] = math.max(settings.bounds[3] or -math.huge,b.y)
            end
            if blockSettings.boundOnBottom then
                settings.bounds[4] = math.min(settings.bounds[4] or math.huge,b.y + b.height)
            end

            settings.treatCameraBoundsAsPhysical = settings.treatCameraBoundsAsPhysical or blockSettings.treatCameraBoundsAsPhysical -- verbose...

            settings.offsetX = settings.offsetX + blockSettings.offsetX
            settings.offsetY = settings.offsetY + blockSettings.offsetY
        end
    end

    return settings
end


local function getBlockerDirection(b,fullX,fullY,fullWidth,fullHeight)
    local settings = b.data._settings

    if b.y+b.height >= fullY and b.y <= fullY+fullHeight then -- on screen vertically
        if b.x+b.width-16 <= fullX and settings.canBlockRight then
            return 1
        elseif b.x+16 >= fullX+fullWidth and settings.canBlockLeft then
            return 2
        end
    end

    if b.x+b.width >= fullX and b.x <= fullX+fullWidth then -- on screen horizontally
        if b.y+b.height-16 <= fullY and settings.canBlockBottom then
            return 3
        elseif b.y+16 >= fullY+fullHeight and settings.canBlockTop then
            return 4
        end
    end

    return 0
end

local function getExtraBounds()
    local bounds = copyBounds(customCamera.currentSettings.bounds)

    if customCamera.blockerID == 0 then
        return bounds
    end

    local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()

    for _,b in Block.iterateIntersecting(fullX - 32,fullY - 32,fullX + fullWidth + 32,fullY + fullHeight + 32) do
        if b.id == customCamera.blockerID and not b.isHidden and not b:mem(0x5A,FIELD_BOOL) then
            local pushDirection = getBlockerDirection(b,fullX,fullY,fullWidth,fullHeight)

            if pushDirection == 1 then
                bounds[pushDirection] = math.max(bounds[pushDirection] or -math.huge,b.x + b.width)
            elseif pushDirection == 2 then
                bounds[pushDirection] = math.min(bounds[pushDirection] or math.huge,b.x)
            elseif pushDirection == 3 then
                bounds[pushDirection] = math.max(bounds[pushDirection] or -math.huge,b.y + b.height)
            elseif pushDirection == 4 then
                bounds[pushDirection] = math.min(bounds[pushDirection] or math.huge,b.y)
            end
        end
    end

    return bounds
end



function customCamera.updateHandycamUse()
    if customCamera.currentZoom > 1 then
        if not customCamera.usingHandycam then
            customCamera.handycamWasUsedBefore = (rawget(handycam,1) ~= nil)
            customCamera.oldHandycamZoom = handycam[1].zoom
            customCamera.oldHandycamRotation = handycam[1].rotation
        end

        handycam[1].zoom = customCamera.currentZoom
        handycam[1].rotation = -customCamera.currentRotation

        customCamera.usingHandycam = true
    elseif customCamera.usingHandycam then
        if customCamera.handycamWasUsedBefore then
            handycam[1].zoom = customCamera.oldHandycamZoom
            handycam[1].rotation = customCamera.oldHandycamRotation
        else
            handycam[1]:release()
        end

        customCamera.usingHandycam = false
    end
end

function customCamera.resetCameraState()
    customCamera.currentSettings = getCurrentSettings()
    customCamera.previousSettings = customCamera.currentSettings
    customCamera.settingsTransition = 0
    
    customCamera.currentZoom = customCamera.currentSettings.zoom
    customCamera.currentRotation = customCamera.currentSettings.rotation
    customCamera.currentOffsetX = customCamera.currentSettings.offsetX
    customCamera.currentOffsetY = customCamera.currentSettings.offsetY
    customCamera.targetNPCID = customCamera.currentSettings.targetNPCID

    customCamera.screenWidth = customCamera.currentSettings.screenWidth
    customCamera.screenHeight = customCamera.currentSettings.screenHeight
    customCamera.screenOffsetX = customCamera.currentSettings.screenOffsetX
    customCamera.screenOffsetY = customCamera.currentSettings.screenOffsetY


    customCamera.currentTargets = getTargets()
    customCamera.previousTargetsFous = vector.zero2
    customCamera.targetsTransition = 0

    customCamera.currentBounds = copyBounds(customCamera.currentSettings.bounds)

    customCamera.updateHandycamUse()
end




function customCamera.onTick()
    -- Update settings
    local newSettings = getCurrentSettings()

    if settingsAreDifferent(customCamera.currentSettings,newSettings) then
        if customCamera.settingsTransition > 0 and not settingsAreDifferent(customCamera.previousSettings,newSettings) then
            customCamera.settingsTransition = 1 - customCamera.settingsTransition
        else
            customCamera.settingsTransition = 1
        end

        customCamera.previousSettings = customCamera.currentSettings
        customCamera.currentSettings = newSettings
    end

    -- Update targets
    local newTargets = getTargets()

    if targetsAreDifferent(customCamera.currentTargets,newTargets) then
        customCamera.previousTargetsFous = vector(camera.x + camera.width*0.5,camera.y + camera.height*0.5)
        customCamera.currentTargets = newTargets

        customCamera.targetsTransition = 1
    end



    local oldSettings = customCamera.previousSettings

    customCamera.settingsTransition = math.max(0,customCamera.settingsTransition - customCamera.transitionSpeed)
    customCamera.targetsTransition = math.max(0,customCamera.targetsTransition - customCamera.transitionSpeed)
    
    customCamera.currentZoom = math.lerp(newSettings.zoom,oldSettings.zoom,customCamera.settingsTransition)
    customCamera.currentRotation = math.lerp(newSettings.rotation,oldSettings.rotation,customCamera.settingsTransition)
    customCamera.currentOffsetX = math.lerp(newSettings.offsetX,oldSettings.offsetX,customCamera.settingsTransition)
    customCamera.currentOffsetY = math.lerp(newSettings.offsetY,oldSettings.offsetY,customCamera.settingsTransition)
    customCamera.targetNPCID = newSettings.targetNPCID

    customCamera.screenWidth = math.lerp(newSettings.screenWidth,oldSettings.screenWidth,customCamera.settingsTransition)
    customCamera.screenHeight = math.lerp(newSettings.screenHeight,oldSettings.screenHeight,customCamera.settingsTransition)
    customCamera.screenOffsetX = math.lerp(newSettings.screenOffsetX,oldSettings.screenOffsetX,customCamera.settingsTransition)
    customCamera.screenOffsetY = math.lerp(newSettings.screenOffsetY,oldSettings.screenOffsetY,customCamera.settingsTransition)

    customCamera.updateHandycamUse()


    if customCamera.lastSection == player.section then
        -- Update bounds
        local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()
        local boundsCurrent = customCamera.currentBounds

        local bounds = getExtraBounds()

        for i = 1,4 do
            local boundSetting = bounds[i]

            local isVertical = (i > 2)
            local direction = (i - 1)%2
            local sign = direction*2 - 1

            local cameraSide = (isVertical and (fullY + fullHeight*direction)) or (fullX + fullWidth*direction)

            if boundSetting ~= nil then
                boundsCurrent[i] = boundsCurrent[i] or cameraSide

                if direction == 0 then
                    boundsCurrent[i] = math.min(boundSetting,math.max(cameraSide,boundsCurrent[i]) + customCamera.boundaryEnterSpeed)
                else
                    boundsCurrent[i] = math.max(boundSetting,math.min(cameraSide,boundsCurrent[i]) - customCamera.boundaryEnterSpeed)
                end
            elseif boundsCurrent[i] ~= nil then
                boundsCurrent[i] = boundsCurrent[i] + sign*customCamera.boundaryExitSpeed

                if (direction == 0 and boundsCurrent[i] <= cameraSide-32) or (direction == 1 and boundsCurrent[i] >= cameraSide+32) then
                    boundsCurrent[i] = nil
                end
            end
        end

        -- Treat as a physical border
        if customCamera.currentSettings.treatCameraBoundsAsPhysical and player.deathTimer == 0 and player.forcedState == FORCEDSTATE_NONE then
            if player.x <= fullX then
                player.speedX = math.max(0,player.speedX)
                player.x = fullX

                player:mem(0x148,FIELD_WORD,2)
            elseif player.x >= fullX + fullWidth - player.width then
                player.speedX = math.min(0,player.speedX)
                player.x = fullX + fullWidth - player.width

                player:mem(0x14C,FIELD_WORD,2)
            end
    
            if player.y >= fullY + fullHeight + 64 then
                player:kill()
            else
                player.y = math.max(player.y,fullY - player.height - 32)
            end
        end
    end
end


local function shouldUseCustomFocus()
    return (
        customCamera.targetsTransition > 0 or (customCamera.currentTargets[1] ~= player or customCamera.currentTargets[2] ~= nil) -- not just targetting player
        or customCamera.screenWidth < camera.width or customCamera.screenHeight < camera.height -- smaller screen
    )
end


function customCamera.onCameraUpdate()
    if canResetFromWarping() then
        customCamera.resetCameraState()
    end

    customCamera.lastWarpCooldown = player:mem(0x15C,FIELD_WORD)
    customCamera.lastSection = player.section


    local focus

    if shouldUseCustomFocus() then -- not just targetting player
        focus = getCameraFocusFromTargets(customCamera.currentTargets)

        if customCamera.targetsTransition > 0 then
            focus = math.lerp(focus,customCamera.previousTargetsFous,customCamera.targetsTransition)
        end
    else
        focus = vector(camera.x + camera.width*0.5,camera.y + camera.height*0.5)
    end

    focus.x = focus.x + customCamera.currentOffsetX
    focus.y = focus.y + customCamera.currentOffsetY

    focus = customCamera.clampFocusToBounds(focus)

    camera.x = focus.x - camera.width*0.5
    camera.y = focus.y - camera.height*0.5
end

function customCamera.onCameraDraw()
    local settingsNeedDrawScene = (customCamera.currentZoom < 1 or customCamera.currentRotation%360 > 0) and not customCamera.usingHandycam
    local settingsNeedCrop = (customCamera.screenWidth < camera.width or customCamera.screenHeight < camera.height or customCamera.screenOffsetX ~= 0 or customCamera.screenOffsetY ~= 0)

    if settingsNeedDrawScene then
        local fullX,fullY,fullWidth,fullHeight = customCamera.getFullCameraPos()

        zoomedBuffer:clear(-100)

        customCamera.drawScene{
            target = zoomedBuffer,useScreen = true,drawBackgroundToScreen = true,
            scale = customCamera.currentZoom,rotation = customCamera.currentRotation,
            x = fullX,y = fullY,width = fullWidth,zoomHeight = fullHeight,
        }

        --Graphics.drawScreen{color = Color.black,priority = 0}
        Graphics.drawScreen{texture = zoomedBuffer,priority = 0}
    end

    if settingsNeedCrop then
        local borderHor = (camera.width - customCamera.screenWidth)
        local borderVer = (camera.height - customCamera.screenHeight)

        local sourceX = 0
        local sourceY = 0

        if not settingsNeedDrawScene then
            sourceX = borderHor*0.5
            sourceY = borderVer*0.5
        end

        zoomedBuffer:captureAt(0.001)

        Graphics.drawScreen{color = Color.black,priority = 0.001}

        Graphics.drawBox{
            texture = zoomedBuffer,priority = 0.001,
            x = borderHor*0.5 + customCamera.screenOffsetX,
            y = borderVer*0.5 + customCamera.screenOffsetY,
            sourceX = sourceX,
            sourceY = sourceY,
            sourceWidth = customCamera.screenWidth,
            sourceHeight = customCamera.screenHeight,
        }
    end

    
    if customCamera.debug then
        for i = 1,4 do
            Text.print(customCamera.currentBounds[i],32,i*32)
        end
    end
end


function customCamera.onStart()
    -- Change sizeable images depending on if debug is on
    local emptyImage = Graphics.loadImageResolved("stock-0.png")

    for _,id in ipairs{customCamera.controllerID,customCamera.blockerID} do
        if id > 0 then
            if customCamera.debug then
                Graphics.sprites.block[id].img = Graphics.loadImageResolved("block-".. id.. "e.png")
            else
                Graphics.sprites.block[id].img = emptyImage
            end
        end
    end


    customCamera.resetCameraState()
end


function customCamera.onInitAPI()
    registerEvent(customCamera,"onTick")
    registerEvent(customCamera,"onCameraUpdate","onCameraUpdate")
    registerEvent(customCamera,"onCameraDraw")

    registerEvent(customCamera,"onStart")

    customCamera.resetCameraState()
end


return customCamera