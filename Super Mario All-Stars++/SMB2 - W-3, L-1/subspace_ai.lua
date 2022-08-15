--[[

    Written by MrDoubleA
    Please give credit!

    Part of MrDoubleA's NPC Pack

]]

local playerManager = require("playerManager")
local blockutils = require("blocks/blockutils")
local npcutils = require("npcs/npcutils")
local sizeable = require("game/sizable")
local extrasounds = require("extrasounds")

local subspace = {}


--- SETTINGS ---

subspace.subspaceSection = 20
subspace.subspaceDuration = 512

subspace.fadeSpeed = 0.1
subspace.doorUseDuration = 48
subspace.endingBlinkTime = 64

subspace.subspaceColor = Color.fromHexRGB(0x294A7B)

subspace.subspaceMusic = "subspace_music.spc|0;g=2.7;"

subspace.gridSize = 32

subspace.subspaceIsFlipped = true



-- Actual variables and stuff --


subspace.subspaceActive = false
subspace.subspaceTimer = 0

subspace.hasBeenUsedBefore = false

subspace.returnX = nil
subspace.returnY = nil
subspace.returnDirection = nil
subspace.returnSection = nil

subspace.subspaceBlocks = {}
subspace.subspaceSizeables = {}
subspace.subspaceNPCs = {}
subspace.subspaceFakeBGOs = {}

subspace.subspaceOnlyNPCs = {}

subspace.originalAreaBounds = nil


local NPC_SUBSPACE_BEHAVIOUR = {
    DEFAULT = -1,
    ONLY_ORIGINAL = 0,
    IN_BOTH = 1,
    ONLY_SUBSPACE = 2,
}
subspace.NPC_SUBSPACE_BEHAVIOUR = NPC_SUBSPACE_BEHAVIOUR


subspace.npcSubspaceBehaviourOverride = {
    [91]  = NPC_SUBSPACE_BEHAVIOUR.IN_BOTH, -- grass containers
    [154] = NPC_SUBSPACE_BEHAVIOUR.IN_BOTH, -- mushroom block 1
    [155] = NPC_SUBSPACE_BEHAVIOUR.IN_BOTH, -- mushroom block 2
    [156] = NPC_SUBSPACE_BEHAVIOUR.IN_BOTH, -- mushroom block 3
    [157] = NPC_SUBSPACE_BEHAVIOUR.IN_BOTH, -- mushroom block 4
    [159] = NPC_SUBSPACE_BEHAVIOUR.IN_BOTH, -- diggable sand
}

function subspace.getNPCSubspaceBehaviour(npc)
    local id
    if type(npc) == "NPC" then
        local behaviourOverride = npc.data.subspaceBehaviourOverride
        if behaviourOverride ~= nil then
            return behaviourOverride
        end

        id = npc.id
    else
        id = npc
    end

    local config = NPC.config[id]

    if config.subspacebehaviour ~= NPC_SUBSPACE_BEHAVIOUR.DEFAULT then
        return config.subspacebehaviour
    end

    local behaviourOverride = subspace.npcSubspaceBehaviourOverride[id]
    if behaviourOverride ~= nil then
        return behaviourOverride
    end
    
    if config.isvine or (config.iscoin and (type(npc) ~= "NPC" or npc.ai1 == 0)) then
        return NPC_SUBSPACE_BEHAVIOUR.IN_BOTH
    end

    return NPC_SUBSPACE_BEHAVIOUR.ONLY_ORIGINAL
end


-- Add subspacebehaviour to all NPC's
for id = 1,NPC_MAX_ID do
    local config = NPC.config[id]

    if config.subspacebehaviour == nil then
        config:setDefaultProperty("subspacebehaviour",NPC_SUBSPACE_BEHAVIOUR.DEFAULT)
    end
end



local playerData = {}
function subspace.getPlayerData(idx)
    local data = playerData[idx]

    if data == nil then
        data = {}
        playerData[idx] = data

        data.usingDoor = nil
        data.doorTimer = 0
        data.doorNPC = nil

        data.fade = 0
    end

    return data
end


local function clearTable(tbl)
    for i = 1,#tbl do
        tbl[i] = nil
    end
end

local function deactivateSubspaceOnlyNPC(npc)
    npc:mem(0x124,FIELD_BOOL,false)
    npc:mem(0x74,FIELD_BOOL,false)
    npc.despawnTimer = -1
    npc.isHidden = false
end


local function clearSubspaceObjectTables()
    clearTable(subspace.subspaceBlocks)
    clearTable(subspace.subspaceSizeables)
    clearTable(subspace.subspaceNPCs)
    clearTable(subspace.subspaceFakeBGOs)
end


local function getMusic(value)
    if type(value) == "string" then
        local filename = value:match("^(.*)|.*$") or value

        -- If the file exists in the episode folder, use that
        if io.exists(Misc.episodePath().. filename) then
            return value
        -- Otherwise, just use it as-is
        else
            return value
        end
    elseif type(value) == "number" then
        return value
    else
        return 0
    end
end


local function convertPosToSubspace(x,y)
    local b = Section(subspace.subspaceSection).boundary

    x = (x - subspace.originalAreaBounds.left) + b.left
    y = (y - subspace.originalAreaBounds.top) + b.top

    return x,y
end

local function sizeableSortingFunc(a,b)
    return (a.y < b.y or (a.y == b.y and a.idx < b.idx))
end

local function addSubspaceSizeablesToList()
    subspace.subspaceSizeables = {}

    -- Add each subspace sizeable
    for _,block in ipairs(subspace.subspaceBlocks) do
        if Block.SIZEABLE_MAP[block.id] then
            table.insert(subspace.subspaceSizeables,block)
        end
    end

    -- Sort them based on Y position
    table.sort(subspace.subspaceSizeables,sizeableSortingFunc)
end


local function cloneAreaToSubspace()
    clearSubspaceObjectTables()

    local origAreaBounds = subspace.originalAreaBounds

    local x1 = origAreaBounds.left   - 256
    local y1 = origAreaBounds.top    - 64
    local x2 = origAreaBounds.right  + 256
    local y2 = origAreaBounds.bottom + 64

    for _,origBlock in Block.iterateIntersecting(x1,y1,x2,y2) do
        if not origBlock.isHidden then
            local x,y = convertPosToSubspace(origBlock.x,origBlock.y)
            local newBlock = Block.spawn(1,x,y)

            newBlock.id = origBlock.id

            newBlock.width = origBlock.width
            newBlock.height = origBlock.height

            newBlock.contentID = origBlock.contentID
            newBlock.slippery = origBlock.slippery
            newBlock:mem(0x5A,FIELD_BOOL,origBlock:mem(0x5A,FIELD_BOOL))

            table.insert(subspace.subspaceBlocks,newBlock)
        end
    end

    for _,origNPC in NPC.iterateIntersecting(x1,y1,x2,y2) do
        local behaviour = subspace.getNPCSubspaceBehaviour(origNPC)

        if origNPC.spawnId > 0
        and (
            (behaviour == NPC_SUBSPACE_BEHAVIOUR.IN_BOTH and origNPC.despawnTimer > 0 and not origNPC.isHidden and not origNPC.isGenerator)
            or behaviour == NPC_SUBSPACE_BEHAVIOUR.ONLY_SUBSPACE
        )
        then
            local x,y = convertPosToSubspace(origNPC.spawnX,origNPC.spawnY)
            local newNPC = NPC.spawn(origNPC.id,x,y,subspace.subspaceSection,false,false)

            newNPC.spawnDirection = origNPC.spawnDirection
            newNPC.direction = newNPC.spawnDirection

            newNPC.friendly = origNPC.friendly
            newNPC.dontMove = origNPC.dontMove
            newNPC.legacyBoss = origNPC.legacyBoss

            newNPC.spawnAi1 = origNPC.spawnAi1
            newNPC.spawnAi2 = origNPC.spawnAi2
            newNPC.ai1 = newNPC.spawnAi1
            newNPC.ai2 = newNPC.spawnAi2

            newNPC.isGenerator        = origNPC.isGenerator
            newNPC.generatorInterval  = origNPC.generatorInterval
            newNPC.generatorTimer     = origNPC.generatorTimer
            newNPC.generatorDirection = origNPC.generatorDirection
            newNPC.generatorType      = origNPC.generatorType

            newNPC.data.subspaceBehaviourOverride = origNPC.data.subspaceBehaviourOverride
            newNPC.data.subspaceOriginalNPC = origNPC
            newNPC.data.subspaceDontDeleteOriginal = (behaviour ~= NPC_SUBSPACE_BEHAVIOUR.ONLY_SUBSPACE)

            table.insert(subspace.subspaceNPCs,newNPC)
        end
    end

    for _,origBGO in BGO.iterateIntersecting(x1,y1,x2,y2) do
        if not origBGO.isHidden then
            local newBGO = {}

            newBGO.id = origBGO.id
            newBGO.width = origBGO.width
            newBGO.height = origBGO.height

            newBGO.x,newBGO.y = convertPosToSubspace(origBGO.x,origBGO.y)

            table.insert(subspace.subspaceFakeBGOs,newBGO)
        end
    end

    addSubspaceSizeablesToList()
end

local function cleanUpClonedArea()
    for _,block in ipairs(subspace.subspaceBlocks) do
        if block.isValid then
            block:delete()
        end
    end

    for _,npc in ipairs(subspace.subspaceNPCs) do
        if npc.isValid then
            npc.data.subspaceDontDeleteOriginal = true
            npc:kill(HARM_TYPE_VANISH)
        end
    end

    clearSubspaceObjectTables()
end


local function resetPlayer(p)
    p.speedX = 0
    p.speedY = 0

    p:mem(0x0C,FIELD_BOOL,false) -- fairy
    p:mem(0x26,FIELD_WORD,0)     
    p:mem(0x3C,FIELD_BOOL,false) -- sliding down slope
    p:mem(0x40,FIELD_WORD,0)     -- climbing
    p:mem(0x48,FIELD_WORD,0)     -- stood on slope
    p:mem(0x4A,FIELD_BOOL,false) -- statue
    p:mem(0x50,FIELD_BOOL,false) -- spin jumping
    p:mem(0x56,FIELD_WORD,0)     -- enemy kill combo
    p:mem(0x5C,FIELD_BOOL,false) -- yoshi ground pounding
    p:mem(0x5E,FIELD_BOOL,false) -- yoshi ground pound bounce
    p:mem(0x11C,FIELD_WORD,0)    -- jump force
    p:mem(0x176,FIELD_WORD,0)    -- stood on NPC
end


function subspace.enterSubspace(p,x,y,direction,section)
    if subspace.subspaceActive then
        return
    end

    subspace.returnX = x or (p.x + p.width*0.5)
    subspace.returnY = y or (p.y + p.height)
    subspace.returnDirection = direction or p.direction
    subspace.returnSection = section or p.section

    subspace.subspaceActive = true
    subspace.subspaceTimer = subspace.subspaceDuration


    -- Convert whichever section into subspace
    local origSection = Section(subspace.returnSection)
    local destSection = Section(subspace.subspaceSection)

    if not subspace.hasBeenUsedBefore then
        if destSection.music ~= 0 or destSection.backgroundID ~= 0 or destSection.isUnderwater
        or destSection.wrapH or destSection.wrapV or destSection.hasOffscreenExit or destSection.noTurnBack
        then
            Misc.warn("Section ".. subspace.subspaceSection.. " cannot be used in a level with subspace doors.")
        end

        subspace.hasBeenUsedBefore = true
    end

    destSection.music = getMusic(subspace.subspaceMusic)
    destSection.backgroundID = 0
    destSection.wrapH = origSection.wrapH
    destSection.wrapV = origSection.wrapV
    destSection.hasOffscreenExit = false
    destSection.noTurnBack = false
    destSection.isUnderwater = origSection.isUnderwater


    local ob = origSection.boundary

    subspace.originalAreaBounds = {}
    subspace.originalAreaBounds.left   = math.clamp(math.floor((subspace.returnX - 400)/subspace.gridSize + 0.5) * subspace.gridSize,ob.left,ob.right-800)
    subspace.originalAreaBounds.top    = math.clamp(math.floor((subspace.returnY - 300)/subspace.gridSize + 0.5) * subspace.gridSize,ob.top,ob.bottom-600)
    subspace.originalAreaBounds.right  = subspace.originalAreaBounds.left + 800
    subspace.originalAreaBounds.bottom = subspace.originalAreaBounds.top + 600


    local b = destSection.boundary

    b.left   = -200000 + 20000*subspace.subspaceSection
    b.bottom = -200000 + 20000*subspace.subspaceSection
    b.right  = b.left + 800
    b.top    = b.bottom - 600

    destSection.boundary = b
    destSection.origBoundary = b


    -- Move player to subspace
    p.x,p.y = convertPosToSubspace(subspace.returnX - p.width*0.5,subspace.returnY - p.height)

    if subspace.subspaceIsFlipped then
        p.direction = -subspace.returnDirection
    else
        p.direction = subspace.returnDirection
    end

    p.section = subspace.subspaceSection

    resetPlayer(p)

    playMusic(p.section)

    cloneAreaToSubspace()
end

function subspace.exitSubspace()
    if not subspace.subspaceActive then
        return
    end

    subspace.subspaceActive = false

    for _,p in ipairs(Player.get()) do
        if p.section == subspace.subspaceSection then
            if p.forcedState == FORCEDSTATE_RESPAWN then
                p.forcedState = FORCEDSTATE_NONE
                p.forcedTimer = 0
            end
            
            p.x = subspace.returnX - p.width*0.5
            p.y = subspace.returnY - p.height
            p.direction = subspace.returnDirection
            p.section = subspace.returnSection

            p:mem(0x140,FIELD_WORD,100)

            resetPlayer(p)

            playMusic(p.section)

            SFX.play(41)
        end
    end

    cleanUpClonedArea()
end


function subspace.startEnteringDoor(p,npc)
    -- Check if another player is entering a door
    for _,otherPlayer in ipairs(Player.get()) do
        local data = subspace.getPlayerData(otherPlayer.idx)

        if data.usingDoor or (otherPlayer.section == subspace.subspaceSection and p.section ~= subspace.subspaceSection) then
            return false
        end
    end

    local data = subspace.getPlayerData(p.idx)

    data.usingDoor = true
    data.doorTimer = 0
    data.doorNPC = npc

    p.x = npc.x + npc.width*0.5 - p.width*0.5
    p.y = npc.y + npc.height - p.height

    p.forcedState = FORCEDSTATE_DOOR
    p.forcedTimer = 5

    resetPlayer(p)

    SFX.play(46)

    return true
end



function subspace.onStart()
    -- Apply any behaviour modifier NPC's
    if subspace.behaviourModifierNPCID ~= nil then
        for _,npc in NPC.iterate(subspace.behaviourModifierNPCID) do
            local x1 = npc.x + npc.width *0.5 - 64
            local x2 = npc.x + npc.width *0.5 + 64
            local y1 = npc.y + npc.height*0.5 - 64
            local y2 = npc.y + npc.height*0.5 + 64

            local closestDistance = math.huge
            local closestNPC

            for _,otherNPC in NPC.iterateIntersecting(x1,y1,x2,y2) do
                if otherNPC ~= npc then
                    local distance = vector(
                        (npc.x + npc.width *0.5) - (otherNPC.x + otherNPC.width *0.5),
                        (npc.y + npc.height*0.5) - (otherNPC.y + otherNPC.height*0.5)
                    )
                    local length = distance.length

                    if length < closestDistance then
                        closestNPC = otherNPC
                        closestDistance = length
                    end
                end
            end

            
            if closestNPC ~= nil then
                closestNPC.data.subspaceBehaviourOverride = npc.data._settings.behaviour
            end

            npc:kill(HARM_TYPE_VANISH)
        end
    end

    -- Add any subspace-only NPC's to the list
    for _,npc in NPC.iterate() do
        local behaviour = subspace.getNPCSubspaceBehaviour(npc)

        if behaviour == NPC_SUBSPACE_BEHAVIOUR.ONLY_SUBSPACE and npc.section ~= subspace.subspaceSection then
            table.insert(subspace.subspaceOnlyNPCs,npc)
            deactivateSubspaceOnlyNPC(npc)
        end
    end
end


local characterGrabSpeeds = {
    [CHARACTER_MARIO] = 12,
    [CHARACTER_LUIGI] = 12,
    [CHARACTER_PEACH] = 16,
    [CHARACTER_TOAD]  = 8,
}

function subspace.onTick()
    -- Subspace door stuff
    for _,p in ipairs(Player.get()) do
        local data = subspace.getPlayerData(p.idx)

        if data.usingDoor then
            local npc = data.doorNPC

            if npc.isValid and npc.despawnTimer > 0 then
                data.doorTimer = data.doorTimer + 1

                p.x = npc.x + npc.width*0.5 - p.width*0.5
                p.y = npc.y + npc.height - p.height

                p.forcedState = FORCEDSTATE_DOOR
                p.forcedTimer = 5

                if data.doorTimer >= subspace.doorUseDuration then
                    p.forcedState = FORCEDSTATE_NONE
                    p.forcedTimer = 0
                    
                    data.usingDoor = false

                    p:mem(0x15C,FIELD_WORD,40)

                    if subspace.subspaceActive then
                        subspace.exitSubspace()
                    else
                        subspace.enterSubspace(p,npc.x + npc.width*0.5,npc.y + npc.height,p.direction,npc.section)
                    end

                    -- Create a door in subspace
                    local x,y = convertPosToSubspace(npc.x + npc.width*0.5,npc.y + npc.height*0.5)
                    local subspaceDoor = NPC.spawn(npc.id,x,y,subspace.subspaceSection,false,true)
                end
            else
                p.forcedState = FORCEDSTATE_NONE
                p.forcedTimer = 0
                data.usingDoor = false
            end
        end


        local fadeTime = 1/subspace.fadeSpeed

        if data.usingDoor and data.doorTimer >= subspace.doorUseDuration-fadeTime
        or subspace.subspaceActive and p.section == subspace.subspaceSection and subspace.subspaceTimer <= fadeTime
        then
            data.fade = math.min(1,data.fade + subspace.fadeSpeed)
        else
            data.fade = math.max(0,data.fade - subspace.fadeSpeed)
        end
    end


    -- Actually in subspace
    if subspace.subspaceActive then
        local playerIsInSubspace = false

        for _,p in ipairs(Player.get()) do
            if p.section == subspace.subspaceSection then
                -- Invert left/right keys
                if subspace.subspaceIsFlipped then
                    local leftKey = p.keys.left
                    local rightKey = p.keys.right
        
                    p.keys.left = rightKey
                    p.keys.right = leftKey
                end

                if not p:mem(0x13C,FIELD_BOOL) then
                    playerIsInSubspace = true
                end


                -- Make grass containers give coins
                local grabSpeed = characterGrabSpeeds[playerManager.getBaseID(p.character)]

                if p.standingNPC ~= nil and p.standingNPC.id == 91
                and subspace.getNPCSubspaceBehaviour(p.standingNPC) ~= NPC_SUBSPACE_BEHAVIOUR.ONLY_SUBSPACE
                and grabSpeed ~= nil and p:mem(0x26,FIELD_WORD) >= grabSpeed then
                    -- Give a coin
                    Misc.coins(1,true)
                    SFX.play(extrasounds.sound.sfx[14])
                    Effect.spawn(11,p.standingNPC.x + p.standingNPC.width*0.5,p.standingNPC.y)

                    -- Do normal stuff to end the grabbing animation
                    p.speedX = p:mem(0x28,FIELD_FLOAT)
                    p.speedY = p.standingNPC.speedY

                    if p.speedY == 0 then
                        p.speedY = 0.01
                    end

                    p:mem(0x26,FIELD_WORD,0) -- grab timer
                    p:mem(0x28,FIELD_FLOAT,0) -- grab speed
                    p:mem(0x164,FIELD_WORD,0) -- tail swipe timer

                    p.standingNPC:kill(HARM_TYPE_VANISH)
                end
            end
        end


        subspace.subspaceTimer = subspace.subspaceTimer - 1

        if subspace.subspaceTimer <= 0 or not playerIsInSubspace then
            subspace.exitSubspace()
        end
    end


    -- Hide subspace-only NPC's
    for i = #subspace.subspaceOnlyNPCs, 1, -1 do
        local npc = subspace.subspaceOnlyNPCs[i]

        if npc.isValid then
            deactivateSubspaceOnlyNPC(npc)
        else
            table.remove(subspace.subspaceOnlyNPCs,i)
        end
    end
end


function subspace.onTickEnd()
    -- Blinking before subspace ends
    for _,p in ipairs(Player.get()) do
        local data = subspace.getPlayerData(p.idx)

        if subspace.subspaceActive and p.section == subspace.subspaceSection and subspace.subspaceTimer <= subspace.endingBlinkTime and subspace.subspaceTimer%6 < 3
        or data.usingDoor and data.doorTimer > subspace.doorUseDuration*0.5
        then
            p:mem(0x142,FIELD_BOOL,true)
        end
    end
end



-- Rendering
local screenBuffer = Graphics.CaptureBuffer(800,600)
local temporarilyHiddenBlocks = {}


local glDrawArgs = {vertexCoords = {},textureCoords = {},primitive = Graphics.GL_TRIANGLE_STRIP}
local glDrawVC = glDrawArgs.vertexCoords
local glDrawTC = glDrawArgs.textureCoords


local function prepareGLDrawQuad(texture,x,y,width,height,sourceX,sourceY,sourceWidth,sourceHeight)
    glDrawArgs.texture = texture

    -- Prepare vertex coords
    local x1 = x
    local y1 = y
    local x2 = x + width
    local y2 = y + height

    glDrawVC[1] = x1 -- top left
    glDrawVC[2] = y1
    glDrawVC[3] = x2 -- top right
    glDrawVC[4] = y1
    glDrawVC[5] = x1 -- bottom left
    glDrawVC[6] = y2
    glDrawVC[7] = x2 -- bottom right
    glDrawVC[8] = y2

    -- Prepare texture coords
    local x1 = (sourceX) / texture.width
    local y1 = (sourceY) / texture.height
    local x2 = (sourceX + sourceWidth) / texture.width
    local y2 = (sourceY + sourceHeight) / texture.height

    glDrawTC[1] = x1 -- top left
    glDrawTC[2] = y1
    glDrawTC[3] = x2 -- top right
    glDrawTC[4] = y1
    glDrawTC[5] = x1 -- bottom left
    glDrawTC[6] = y2
    glDrawTC[7] = x2 -- bottom right
    glDrawTC[8] = y2
end


local function hideBlock(block)
    block.isHidden = true
    table.insert(temporarilyHiddenBlocks,block)
end


local function drawBlock(block)
    local image = Graphics.sprites.block[block.id].img
    if image == nil then
        return
    end

    local x = block.x
    local y = block.y
    local width = block.width
    local height = block.height
    local frame = math.max(0,blockutils.getBlockFrame(block.id))

    prepareGLDrawQuad(image,x,y,width,height,0,frame*height,width,height)

    glDrawArgs.priority = -65
    glDrawArgs.color = subspace.subspaceColor
    glDrawArgs.sceneCoords = true

    Graphics.glDraw(glDrawArgs)
end


local lowPriorityStates = table.map{1,3,4}
local invisibleStates = table.map{8}

local holdOnTopCharacters = table.map{CHARACTER_PEACH,CHARACTER_TOAD}

local function getNPCPriority(npc,config)
    local forcedState = npc:mem(0x138,FIELD_WORD)

    if npc:mem(0x12C,FIELD_WORD) > 0 then
        local p = Player(npc:mem(0x12C,FIELD_WORD))

        if p.isValid then
            if p.forcedState == FORCEDSTATE_PIPE then
                return -70.01
            elseif holdOnTopCharacters[playerManager.getBaseID(p.character)] then
                return -24.99
            end
        end

        return -30
    end

    if lowPriorityStates[forcedState] or config.iscoin then
        return -55
    end

    if config.isvine or forcedState == 208 then
        return -75
    end

    if config.foreground then
        return -15
    end

    return -45
end

local function drawNPC(npc)
    local image = Graphics.sprites.npc[npc.id].img
    if image == nil then
        return
    end

    local config = NPC.config[npc.id]
    local forcedState = npc:mem(0x138,FIELD_WORD)

    if invisibleStates[forcedState] then
        return
    end

    local gfxwidth = npcutils.gfxwidth(npc)
    local gfxheight = npcutils.gfxheight(npc)
    local x = npc.x + npc.width*0.5 - gfxwidth*0.5 + config.gfxoffsetx
    local y = npc.y + npc.height - gfxheight + config.gfxoffsety
    local frame = npc.animationFrame

    prepareGLDrawQuad(image,x,y,gfxwidth,gfxheight,0,frame*gfxheight,gfxwidth,gfxheight)

    glDrawArgs.priority = getNPCPriority(npc,config)
    glDrawArgs.color = subspace.subspaceColor
    glDrawArgs.sceneCoords = true

    Graphics.glDraw(glDrawArgs)
end



local function drawBGO(bgo)
    local image = Graphics.sprites.background[bgo.id].img
    if image == nil then
        return
    end

    local config = BGO.config[bgo.id]

    local x = bgo.x
    local y = bgo.y
    local width = bgo.width
    local height = bgo.height
    local frame = math.floor(lunatime.drawtick() / config.framespeed) % config.frames

    prepareGLDrawQuad(image,x,y,width,height,0,frame*height,width,height)

    glDrawArgs.priority = config.priority
    glDrawArgs.color = subspace.subspaceColor
    glDrawArgs.sceneCoords = true

    Graphics.glDraw(glDrawArgs)
end


-- Gets the index of the player that the camera belongs to. A return value of 0 means that it belongs to everybody
local function getCameraPlayer(camIdx)
    local screenType = mem(0x00B25130,FIELD_WORD)

    if camera2.isSplit or screenType == 6 then -- split screen or supermario2 is active
        return camIdx
    elseif screenType == 5 then -- dynamic screen
        if Player(1):mem(0x13C,FIELD_BOOL) then -- player 1 is dead
            return 2
        elseif Player(2):mem(0x13C,FIELD_BOOL) then -- player 2 is dead
            return 1
        else
            return 0
        end
    elseif screenType == 2 or screenType == 3 or screenType == 7 then -- follows all players
        return 0
    else
        return 1
    end
end


function subspace.onCameraDraw(camIdx)
    local c = Camera(camIdx)
    local cameraPlayerIdx = getCameraPlayer(camIdx)


    -- Fading transitions
    if cameraPlayerIdx > 0 and not camera2.isSplit then
        local data = subspace.getPlayerData(cameraPlayerIdx)

        if data.fade > 0 then
            Graphics.drawBox{color = Color.black.. data.fade,priority = 4,x = 0,y = 0,width = c.width,height = c.height}
        end
    end


    -- Return if the camera isn't in subspace
    if not subspace.subspaceActive then
        return
    elseif cameraPlayerIdx > 0 then
        local p = Player(cameraPlayerIdx)

        if p.section ~= subspace.subspaceSection then
            return
        end
    end


    -- Background color
    Graphics.drawBox{
        color = subspace.subspaceColor,priority = -101,
        x = 0,y = 0,width = c.width,height = c.height,
    }

    -- Flip screen
    if subspace.subspaceIsFlipped then
        screenBuffer:captureAt(-5)

        Graphics.drawBox{
            texture = screenBuffer,priority = -5,
            x = c.width,y = 0,width = -c.width,height = c.height,
            sourceWidth = c.width,sourceHeight = c.height,
        }
    end


    -- Draw blocks
    for _,block in ipairs(subspace.subspaceBlocks) do
        if block.isValid and not block.isHidden and not Block.SEMISOLID_MAP[block.id] then
            drawBlock(block)
            hideBlock(block)
        end
    end

    for _,block in ipairs(subspace.subspaceSizeables) do
        if block.isValid and not block.isHidden and Block.SEMISOLID_MAP[block.id] then
            sizeable.drawSizable(block,c,-90,nil,subspace.subspaceColor,nil)
            hideBlock(block)
        end
    end

    -- Draw NPC's
    for _,npc in ipairs(subspace.subspaceNPCs) do
        if npc.isValid and not npc.isHidden and npc.despawnTimer > 0 and npc.animationFrame >= 0
        and subspace.getNPCSubspaceBehaviour(npc) ~= NPC_SUBSPACE_BEHAVIOUR.ONLY_SUBSPACE
        then
            drawNPC(npc)
            npcutils.hideNPC(npc)
        end
    end

    -- Draw BGO's
    for _,bgo in ipairs(subspace.subspaceFakeBGOs) do
        drawBGO(bgo)
    end
end

function subspace.onDrawEnd()
    for i = 1, #temporarilyHiddenBlocks do
        local block = temporarilyHiddenBlocks[i]

        if block.isValid and block.isHidden then
            block.isHidden = false
        end

        temporarilyHiddenBlocks[i] = nil
    end
end


function subspace.onPostNPCKill(npc,reason)
    -- If the NPC is subspace-only and was just killed, kill the original to prevent it from coming back
    local origNPC = npc.data.subspaceOriginalNPC

    if npc.section == subspace.subspaceSection and origNPC ~= nil and origNPC.isValid and not npc.data.subspaceDontDeleteOriginal then
        origNPC:kill(HARM_TYPE_VANISH)
    end
end



function subspace.onInitAPI()
    registerEvent(subspace,"onStart")
    registerEvent(subspace,"onTick")
    registerEvent(subspace,"onTickEnd")
    registerEvent(subspace,"onCameraDraw","onCameraDraw",false)
    registerEvent(subspace,"onDrawEnd")

    registerEvent(subspace,"onPostNPCKill")
end


return subspace