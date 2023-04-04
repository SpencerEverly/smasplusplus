--[[

    Minecraft Steve Playable
    by MrDoubleA


    Minecraft sounds ripped by MattNL and JacobTheSpriter

]]

local playerManager = require("playerManager")
local smashud = require("smashud")
local blockutils = require("blocks/blockutils")

local configFileReader = require("configFileReader")
local textplus = require("textplus")

local lib3d = require("lib3d")

local steve = {}

local timer = 0

ready = false

_G.CHARACTER_STEVE = CHARACTER_ULTIMATERINKA


local MOUSE_X             = 0x00B2D6BC
local MOUSE_Y             = 0x00B2D6C4
local MOUSE_LEFT_PRESSED  = 0x00B2D6CC
local MOUSE_RIGHT_PRESSED = 0x00B2D6CE


SaveData.steveData = SaveData.steveData or {}
local savedData = SaveData.steveData

savedData.items = savedData.items or {}



local data = {} -- used kinda like an NPC's data
steve.playerData = data

steve.SKIN_TYPE = {
    NORMAL    = "normal",
    THIN_ARMS = "thinArms",
}


steve.bodyParts = {
    {name = "leftLeg" ,offset = vector(0,0.5,0)},
    {name = "rightLeg",offset = vector(0,0.5,0)},
    {name = "leftArm" ,offset = vector(-0.25,-0.125,0)},
    {name = "rightArm",offset = vector(0.25,-0.125,0)},
    {name = "torso"   ,offset = vector(0,0.625,0)},
    {name = "head"    ,offset = vector(0,-0.25,0)},
}

steve.itemTypes = {"tool","block"}
steve.TOOL_TYPE = {
    SWORD   = 1,
    PICKAXE = 2,
}
steve.TOOL_TIER = {
    NONE      = PLAYER_SMALL,
    WOOD      = PLAYER_BIG,
    STONE     = PLAYER_FIREFLOWER,
    IRON      = PLAYER_LEAF,
    DIAMOND   = PLAYER_TANOOKIE,
    NETHERITE = PLAYER_HAMMER,
    GOLD      = PLAYER_ICE,
}
steve.toolTypesCount = 2
steve.toolTiersCount = 7

steve.itemMaterialShader = Misc.resolveFile("steve/itemMaterialShader.glsl")

-- Filled in later
steve.bodyMaterial = nil
steve.camera = nil


local colBox = Colliders.Box(0,0,0,0)

-- Filters used for collision stuff
local function solidBlockFilter(v,includeSemisolid)
    local config = Block.config[v.id]

    return (
        Colliders.FILTER_COL_BLOCK_DEF(v)
        and (
            Block.SOLID_MAP[v.id]
            or Block.PLAYERSOLID_MAP[v.id]
            or (config.playerfilter > 0 and config.playerfilter ~= player.character and not config.passthrough and (includeSemisolid or not Block.SEMISOLID_MAP[v.id]))
            or (includeSemisolid and Block.SEMISOLID_MAP[v.id] and config.playerfilter == 0)
        )
    )
end
local function solidOrSemisolidBlockFilter(v)
    return solidBlockFilter(v,true)
end

local function solidNPCFilter(v,includeSemisolid)
    local config = NPC.config[v.id]

    return (
        Colliders.FILTER_COL_NPC_DEF(v)
        and v.despawnTimer > 0
        and (config.playerblock or (includeSemisolid and config.playerblocktop))

        and v:mem(0x12C,FIELD_WORD) == 0 -- grabbed by a player
        and not v:mem(0x136,FIELD_BOOL)  -- projectile flag
        and v:mem(0x138,FIELD_WORD) == 0 -- forced state
    )
end
local function solidOrSemisolidNPCFilter(v)
    return solidNPCFilter(v,true)
end


local function decreaseItemDurability(slot,amount,correctToolType)
    local item = data.inventoryItems[slot]

    if item.type ~= "tool" then
        return
    end

    
    if item.toolType ~= correctToolType and correctToolType ~= nil then
        amount = amount*2
    end

    item.durability = math.max(0,item.durability - amount)

    if item.durability == 0 then
        data.inventoryItems[slot] = {}

        SFX.play(steve.generalSettings.breakToolSound)
    end
end


local function blocksInTheWay(startX,startY,endX,endY,exceptionObj)
    colBox.x = math.min(startX,endX)
    colBox.y = math.min(startY,endY)
    colBox.width  = math.max(startX,endX)-colBox.x
    colBox.height = math.max(startY,endY)-colBox.y
    

    local potentialBlocksInTheWay = Colliders.getColliding{a = colBox,btype = Colliders.BLOCK,filter = solidBlockFilter}

    if #potentialBlocksInTheWay > 0 then
        local hit,_,_,hitBlock = Colliders.linecast(vector(startX,startY),vector(endX,endY),potentialBlocksInTheWay)

        if hit and hitBlock ~= exceptionObj then
            return true
        end
    end

    return false
end


local function getClosestObj(objs,x,y)
    local closestDistance
    local closestObj

    for _,obj in ipairs(objs) do
        local distance = vector(
            x-(obj.x+(obj.width *0.5)),
            y-(obj.y+(obj.height*0.5))
        )

        if closestDistance == nil or distance.length < closestDistance then
            closestDistance = distance.length
            closestObj = obj
        end
    end

    return closestObj,closestDistance
end

local function getObjectClickedOn(colliderType,filter,maxDistance)
    local mouseX = Screen.cursorX()+camera.x
    local mouseY = Screen.cursorY()+camera.y

    colBox.width = 8
    colBox.height = 8

    colBox.x = mouseX-(colBox.width *0.5)
    colBox.y = mouseY-(colBox.height*0.5)


    local potentialObjs = Colliders.getColliding{a = colBox,btype = colliderType,filter = filter}
    local obj,distance = getClosestObj(potentialObjs,mouseX,mouseY)


    -- Some validity checks
    if obj ~= nil then
        local distanceToObj = vector(
            (obj.x+(obj.width *0.5))-(player.x+(player.width *0.5)),
            (obj.y+(obj.height*0.5))-(player.y+(player.height*0.5))
        )

        if distanceToObj.length > maxDistance then
            obj = nil
        end
    end


    if obj ~= nil and blocksInTheWay(player.x+(player.width*0.5),player.y+(player.height*0.25),obj.x+(obj.width*0.5),obj.y+(obj.height*0.5),obj) then
        obj = nil
    end


    return obj,distance
end


local function dropAllItems()
    if steve.droppedItem == nil then return end

    for i=1,steve.inventorySettings.slots do
        local item = data.inventoryItems[i]

        if item.type ~= nil then
            local npc = NPC.spawn(steve.droppedItem.idList[1],player.x+(player.width*0.5),player.y+(player.height*0.5),player.section,false,true)
            local npcData = npc.data

            npcData.itemData = item

            npc.speedX = RNG.random(-2.5,2.5)
            npc.speedY = RNG.random(-6,-2)
        end

        data.inventoryItems[i] = {}
    end
end



-- Mesh loading
do
    local meshMacros = {UNLIT = 1,TONEMAP = false,ALPHAMODE = lib3d.macro.ALPHA_CUTOFF}


    function steve.destroyMeshes()
        for _,partData in ipairs(steve.bodyParts) do
            if data.bodyMeshes ~= nil then
                local mesh = data.bodyMeshes[partData.name]
        
                if mesh ~= nil and mesh.isValid then
                    mesh:destroy()
                    data.bodyMeshes[partData.name] = nil
                end
            end
        end

        steve.destroyHeldItemMeshes()
    end
    
    function steve.loadMeshes()
        steve.destroyMeshes()


        data.bodyMaterial = lib3d.Material(nil,{texture = Graphics.loadImageResolved("steve/skins/".. steve.skinSettings.name.. ".png")},nil,meshMacros)

        for _,partData in ipairs(steve.bodyParts) do
            -- Find the path. Tries the skin type's folder first, but if it can't find it there, tries the generic folder.
            local path = Misc.resolveFile("steve/bodyParts/".. steve.skinSettings.type.. "/".. partData.name.. ".obj") or Misc.resolveFile("steve/bodyParts/".. partData.name.. ".obj")
            assert(path ~= nil,"Could not find body model: ".. partData.name)


            local model = lib3d.loadMesh(path,{upaxis = lib3d.import.axis.POS_Y,uvorient = lib3d.import.axis.V_UP,scale = steve.generalSettings.modelScale})

            local mesh = lib3d.Mesh{meshdata = model,material = data.bodyMaterial}

            mesh.transform:setParent(data.meshParent)
            mesh.active = false

            data.bodyMeshes[partData.name] = mesh
        end

        steve.loadHeldItemMeshes()


        if steve.camera == nil then
            steve.camera = lib3d.Camera{renderscale = 1,projection = lib3d.projection.ORTHO}
            steve.camera.transform.position.z = -steve.camera.flength
        end
    end


    function steve.createItemMesh(type,isDropped) -- also used by dropped items
        local texture
        if type == "tool" then
            texture = steve.generalSettings.toolImage
        elseif type == "powerup" then
            texture = steve.generalSettings.powerupImage
        end


        local material = lib3d.Material(steve.itemMaterialShader,{texture = texture},nil,meshMacros)

        -- Minor performance thing: dropped blocks have a special model that cuts it down to just 4 tris
        local path = (isDropped and Misc.resolveFile("steve/".. type.. "_dropped.obj")) or Misc.resolveFile("steve/".. type.. ".obj")
        assert(path ~= nil,"Could not find held item model: ".. type)

        local model = lib3d.loadMesh(path,{upaxis = lib3d.import.axis.POS_Y,uvorient = lib3d.import.axis.V_UP,scale = steve.generalSettings.modelScale})

        local mesh = lib3d.Mesh{meshdata = model,material = material}

        mesh.active = false


        return mesh,material
    end


    function steve.destroyHeldItemMeshes()
        for _,name in ipairs(steve.itemTypes) do
            local mesh = data.heldItemMeshes[name]

            if mesh ~= nil and mesh.isValid then
                mesh:destroy()
                data.heldItemMeshes[name] = nil
            end
        end
    end

    function steve.loadHeldItemMeshes()
        steve.destroyHeldItemMeshes()


        for _,name in ipairs(steve.itemTypes) do
            local mesh,material = steve.createItemMesh(name,false)

            mesh.transform:setParent(data.bodyMeshes.leftArm.transform)

            data.heldItemMeshes[name] = mesh
            data.heldItemMaterials[name] = material
        end
    end
end

-- Animation
local resetPartAnimationData
local handleAnimation

do
    steve.animations = {
        idle   = {hasIdleSwinging = true},
        walk   = {hasWalking = true},
        lookUp = {hasIdleSwinging = true},

        climb = {targetRotation = vector(0,180,0)},

        death = {hasWalking = true,noCrouching = true},

        upgradeTool = {hasIdleSwinging = true,noHoldingNPCArmsRaise = true,noCrouching = true},

        pipeVertical        = {hasIdleSwinging = true,targetRotation = vector(0,0,0)},
        pipeHorizontal      = {hasWalking = true},
        clearPipeHorizontal = {hasIdleSwinging = true},
        clearPipeVertical   = {hasIdleSwinging = true,targetRotation = vector(0,0,0)},
        door                = {hasIdleSwinging = true,targetRotation = vector(0,180,0)},
    }


    function resetPartAnimationData()
        for _,partData in ipairs(steve.bodyParts) do
            data.partAnimationData[partData.name] = {offset = vector.zero3,rotation = vector.zero3}
        end
    end

    local function getWalkAnimationSpeed()
        return math.abs(player.speedX)/Defines.player_walkspeed
    end

    local function getCurrentAnimation()
        if player.deathTimer > 0 then
            return "death",math.max(0,(32-player.deathTimer)/16)
        end


        if data.upgradingItemSlot ~= nil and player.forcedState == FORCEDSTATE_POWERUP_BIG then
            return "upgradeTool"
        else
            data.upgradingItemSlot = nil
        end


        if player.forcedState == FORCEDSTATE_PIPE then
            local warp = Warp(player:mem(0x15E,FIELD_WORD)-1)
            local direction

            if player.forcedTimer == 0 then
                direction = warp.entranceDirection
            else
                direction = warp.exitDirection
            end

            if direction == 2 or direction == 4 then
                return "pipeHorizontal"
            else
                return "pipeVertical"
            end
        elseif player.forcedState == FORCEDSTATE_DOOR then
            -- Clear pipes share a forced state with doors for some reason, and the only way to detect it is by the frame
            if data.onTickFrame == 2 then
                return "clearPipeHorizontal"
            elseif data.onTickFrame == 15 then
                return "clearPipeVertical"
            else
                return "door"
            end
        elseif player.forcedState ~= FORCEDSTATE_NONE then
            return "idle"
        end
        

        -- Change direction while climbing
        if player.climbing then
            if player.keys.left then
                player.direction = DIR_LEFT
            elseif player.keys.right then
                player.direction = DIR_RIGHT
            end
        end


        if math.abs(player.speedX) <= 0.25 then
            if player.keys.up and player.forcedState == FORCEDSTATE_NONE then
                return "lookUp"
            else
                return "idle"
            end
        else
            return "walk",getWalkAnimationSpeed()
        end
    end

    local function canContinuePunchAnimation()
        return (
            player.forcedState == FORCEDSTATE_NONE and player.deathTimer == 0
            and player.holdingNPC == nil
        )
    end

    
    local twoPi = (math.pi*2)

    function handleAnimation()
        local newAnimation,newSpeed = getCurrentAnimation()

        if data.currentAnimation ~= newAnimation and newAnimation ~= nil then
            data.currentAnimation = newAnimation
            data.animationTimer = 0
            data.animationSpeed = 1
        end

        resetPartAnimationData()

        data.animationSpeed = newSpeed or data.animationSpeed


        local animationData = steve.animations[data.currentAnimation]

        local targetRotation = animationData.targetRotation or vector(0,steve.generalSettings.normalYRotation,0)
        local targetHeadRotation = 0


        -- Arm swinging / breathing
        if animationData.hasIdleSwinging then
            local rotation = vector(math.sin(data.animationTimer/64)*2,0,(-math.cos(data.animationTimer/48)*3)+3)

            data.partAnimationData.leftArm.rotation = rotation
            data.partAnimationData.rightArm.rotation = -rotation

            data.animationTimer = data.animationTimer + data.animationSpeed
        end

        -- Walking
        if animationData.hasWalking then
            local rotation = vector(math.cos(data.animationTimer/5.5)*data.animationSpeed*20,0,0)

            data.partAnimationData.leftArm.rotation  =  rotation*1
            data.partAnimationData.rightArm.rotation = -rotation*1
            data.partAnimationData.leftLeg.rotation  = -rotation*1
            data.partAnimationData.rightLeg.rotation =  rotation*1

            data.animationTimer = data.animationTimer + data.animationSpeed
        end


        -- Upgrade tool
        if data.currentAnimation == "upgradeTool" then
            local headRotation = vector.zero3
            local armRotation = vector.zero3

            local time = data.animationTimer
            if time > 28 then
                time = math.max(0,28-(time-28))
            end

            armRotation.x = -math.min(90,(time^1.6)*0.75)
            armRotation.y = -math.min(30,(time^1.6)*0.225)

            headRotation.x = -math.min(20,(time^1.55)*0.15)
            headRotation.y = math.min(17.5,(time^1.55)*0.135)

            data.globalMeshRotation.y = (steve.generalSettings.normalYRotation-(math.min(20,(time^1.6)*0.3)*player.direction))*-player.direction

            

            data.partAnimationData.leftArm.rotation = armRotation
            data.partAnimationData.head.rotation = headRotation

            data.partAnimationData.torso.rotation.y = headRotation.y*0.5

            targetRotation = nil


            if data.animationTimer == 20 then
                if player.direction == DIR_RIGHT then
                    data.glintSprite.x = player.x+(player.width*0.5)
                else
                    data.glintSprite.x = player.x
                end
                data.glintSprite.y = player.y

                data.glintTimer = 0

                SFX.play(steve.generalSettings.upgradeToolSound)
            end

            if time <= 0 then
                player.forcedState = FORCEDSTATE_NONE
                player.forcedTimer = 0

                data.upgradingItemSlot = nil
            else
                player.forcedTimer = 1
            end
        end


        -- Put arm out a bit if an item is selected
        local item = data.inventoryItems[data.upgradingItemSlot or data.selectedInventorySlot]

        if item.type ~= nil and player.holdingNPC == nil then
            data.partAnimationData.leftArm.rotation.x = data.partAnimationData.leftArm.rotation.x - 10
        end


        -- Punch
        if data.punchAnimationTimer ~= nil and canContinuePunchAnimation() then
            local time = (data.punchAnimationTimer/13)
            local armRotation = vector.zero3

            if time < 0.4 then
                local armTime = time*0.65*twoPi
                
                armRotation.x = math.sin(armTime  )*-80
                armRotation.y = math.sin(armTime*2)*40
                armRotation.z = math.sin(armTime  )*-5
            else
                local armTime = (((time+0.8)*0.5)-0.4)*twoPi
                
                armRotation.x = math.sin(armTime  )*-80
                armRotation.y = math.sin(armTime*2)*30
                armRotation.z = math.sin(armTime  )*-5
            end

            data.partAnimationData.leftArm.rotation = armRotation


            local bodyRotation = (math.sin(time*twoPi*1)*(1-time)*14)

            data.partAnimationData.torso.rotation.y = data.partAnimationData.torso.rotation.y + bodyRotation

            data.partAnimationData.leftLeg.rotation.y  = data.partAnimationData.leftLeg.rotation.y  + bodyRotation
            data.partAnimationData.rightLeg.rotation.y = data.partAnimationData.rightLeg.rotation.y + bodyRotation

            data.partAnimationData.leftArm.rotation.y  = data.partAnimationData.leftArm.rotation.y  + bodyRotation*0.5
            data.partAnimationData.rightArm.rotation.y = data.partAnimationData.rightArm.rotation.y + bodyRotation*0.5


            data.punchAnimationTimer = data.punchAnimationTimer + 1
            if time >= 1 then
                data.punchAnimationTimer = nil
            end
        else
            data.punchAnimationTimer = nil
        end


        -- Crouching
        if (player:mem(0x12E,FIELD_BOOL) or (player.climbing and player.keys.down and player.forcedState == FORCEDSTATE_NONE)) and not animationData.noCrouching then
            -- pain.
            data.partAnimationData.torso.offset.y = 0
            data.partAnimationData.torso.offset.z = 0.3125
            data.partAnimationData.torso.rotation.x = 22.5

            data.partAnimationData.head.offset.y = 0.0625

            data.partAnimationData.leftLeg.offset.z = 0.25
            data.partAnimationData.rightLeg.offset.z = 0.25

            data.partAnimationData.leftArm.rotation.x = data.partAnimationData.leftArm.rotation.x + 11.25
            data.partAnimationData.leftArm.offset.y = 0.0625
            data.partAnimationData.rightArm.rotation.x = data.partAnimationData.rightArm.rotation.x + 11.25
            data.partAnimationData.rightArm.offset.y = 0.0625
        end

        -- Put up arms if holding an NPC
        if player.holdingNPC ~= nil and not animationData.noHoldingNPCArmsRaise then
            data.partAnimationData.leftArm.rotation.x = -180
            data.partAnimationData.rightArm.rotation.x = -180
        end


        -- Death
        if data.currentAnimation == "death" then
            --data.globalMeshRotation.z = math.min(90,player.deathTimer*3.5)*-player.direction
            data.globalMeshRotation.z = math.clamp(data.globalMeshRotation.z+(4.5*-player.direction),-90,90)

            if player.deathTimer == 80 then
                for i=1,20 do
                    Effect.spawn(steve.generalSettings.deathEffectID,player.x+(player.width*0.5)-(((player.width*0.5)+14)*player.direction),player.y+player.height)
                end

                dropAllItems()
            end

            targetRotation = nil
        end


        -- Looking up
        local lookingAtTarget = (data.miningBlock or data.swingingAtPosition or nil)

        if lookingAtTarget ~= nil and lookingAtTarget.isValid ~= false then
            local x = lookingAtTarget.x
            local y = lookingAtTarget.y

            if lookingAtTarget.width ~= nil and lookingAtTarget.height ~= nil then
                x = x + (lookingAtTarget.width *0.5)
                y = y + (lookingAtTarget.height*0.5)
            end


            targetHeadRotation = math.deg(math.atan2(
                y-(player.y+(player.height*0.25)),
                math.abs(x-(player.x+(player.width*0.5)))
            ))
            targetHeadRotation = math.clamp(targetHeadRotation,-steve.miningSettings.maxHeadRotation,steve.miningSettings.maxHeadRotation)
        elseif data.currentAnimation == "lookUp" then
            targetHeadRotation = steve.generalSettings.headLookUpRotation
        end


        -- Rotation
        if targetRotation ~= nil then
            for i=1,3 do
                local target = targetRotation[i]
                if i == 2 then
                    target = target*-player.direction
                end

                if data.globalMeshRotation[i] > target then
                    data.globalMeshRotation[i] = math.max(target,data.globalMeshRotation[i] - steve.generalSettings.turningRotationSpeed)
                elseif data.globalMeshRotation[i] < target then
                    data.globalMeshRotation[i] = math.min(target,data.globalMeshRotation[i] + steve.generalSettings.turningRotationSpeed)
                end
            end
        end

        if data.headXRotation > targetHeadRotation then
            data.headXRotation = math.max(targetHeadRotation,data.headXRotation - steve.generalSettings.headRotationSpeed)
        elseif data.headXRotation < targetHeadRotation then
            data.headXRotation = math.min(targetHeadRotation,data.headXRotation + steve.generalSettings.headRotationSpeed)
        end

        data.partAnimationData.head.rotation.x = data.partAnimationData.head.rotation.x + data.headXRotation
    end
end


-- HUD
local initHUD
local cleanupHUD

do
    local hudElementsToMove = {"lives",1, "deathcount",1}
    local originalHUDOffsets = {}

    function initHUD()
        for i=1,#hudElementsToMove,2 do
            local name = hudElementsToMove[i]
            local direction = hudElementsToMove[i+1]

            originalHUDOffsets[(i*0.5)+0.5] = {name,smashud.offsets[name].y}

            smashud.offsets[name].y = smashud.offsets[name].y + (steve.hudSettings.moveHUDElementsDistance*direction)
        end
    end
    function cleanupHUD()
        for _,data in ipairs(originalHUDOffsets) do
            local name = data[1]
            local offset = data[2]

            smashud.offsets[name].y = offset
        end

        originalHUDOffsets = {}
    end


    local blockNameCache = {}
    local function getItemName(item)
        if item.type == "tool" then
            return steve.inventorySettings.toolNames[item.toolType][item.toolTier]
        elseif item.type == "block" then
            if blockNameCache[item.blockID] == nil then
                local name = ""
                local iniFilePath = Misc.resolveFile("block-".. item.blockID.. ".ini") or Misc.resolveFile("PGE/configs/SMBX2-Integration/items/blocks/block-".. item.blockID.. ".ini")

                if iniFilePath ~= nil then
                    local parsed = configFileReader.rawParse(iniFilePath)

                    if parsed ~= nil and parsed.name ~= nil then
                        name = parsed.name
                    end
                end

                blockNameCache[item.blockID] = name
            end

            return blockNameCache[item.blockID]
        end
    end


    local textLayouts = {}
    local function drawText(index,text,x,y,pivot,priority,color,maxWidth,scale)
        scale = steve.hudSettings.fontScale*(scale or 1)
        color = color or Color.white

        if textLayouts[index] == nil or textLayouts[index][2] ~= text then
            local layout = textplus.layout(text,maxWidth,{font = steve.hudSettings.font,xscale = scale,yscale = scale})

            textLayouts[index] = {layout,text}
        end

        local layout = textLayouts[index][1]
        local args = {}

        args.layout = layout
        args.priority = priority


        args.color = color:lerp(Color.black,0.75)
        args.color = args.color*color.a
        args.color.a = color.a

        args.x = x-(layout.width *pivot.x)+scale
        args.y = y-(layout.height*pivot.y)+scale

        textplus.render(args) -- shadow


        args.color = color
        args.x = args.x-scale
        args.y = args.y-scale

        textplus.render(args) -- main text
    end


    local heartsY = 10

    function steve.drawHearts(playerIdx,camObj,playerObj,priority,isSplit,playerCount)
        local image = steve.hudSettings.healthImage

        local width = image.width
        local height = image.height/4

        local max = steve.generalSettings.maxHealth
        local current = savedData.health

        
        for i=1,max do
            local x = (camObj.width*0.5)-(max*width*0.5)+(width*(i-1))-(width*0.5)
            local y = heartsY

            local frame = 2
            if i <= current then
                frame = 0
            end
            if (player:mem(0x140,FIELD_WORD) >= 100 or player.deathTimer > 0 and player.deathTimer <= 50) and lunatime.tick()%16 < 8 then
                frame = frame + 1
            end


            Graphics.drawImageWP(image,x,y,0,frame*height,width,height,priority)
        end
    end


    local inventoryY = heartsY+18+4 --21

    local function getItemPosition(camObj,slotWidth,slotHeight,slots,width,height,slotIndex)
        local x = (camObj.width*0.5)-(slotWidth*slots*0.5)+(slotWidth*(slotIndex-1))+(slotWidth*0.5)-(width*0.5)
        local y = inventoryY+2+(slotHeight*0.5)-(height*0.5)

        return x,y
    end
    function steve.drawInventory(playerIdx,camObj,playerObj,priority,isSplit,playerCount)
        local inventoryImage = steve.hudSettings.inventoryImage
        local slotWidth = steve.hudSettings.inventorySlotWidth
        local slotHeight = steve.hudSettings.inventorySlotHeight
        local slots = steve.inventorySettings.slots

        Graphics.drawImageWP(inventoryImage,(camObj.width*0.5)-(inventoryImage.width*0.5),inventoryY,priority)


        -- Draw item selector
        if data.selectedInventorySlot > 0 then
            local image = steve.hudSettings.selectedInventoryImage

            local x,y = getItemPosition(camObj,slotWidth,slotHeight,slots,image.width,image.height,data.selectedInventorySlot)

            Graphics.drawImageWP(image,x,y,priority)


            -- Item name
            local name = getItemName(data.inventoryItems[data.selectedInventorySlot])
            local opacity = 0

            if data.selectedItemTime <= steve.hudSettings.itemNameStayTime then
                opacity = 1
            elseif data.selectedItemTime <= (steve.hudSettings.itemNameStayTime+steve.hudSettings.itemNameFadeTime) then
                opacity = 1-((data.selectedItemTime-steve.hudSettings.itemNameStayTime)/steve.hudSettings.itemNameFadeTime)
            end

            if name ~= nil and name ~= "" and opacity > 0 then
                local x = (camObj.width*0.5)
                local y = inventoryY+inventoryImage.height+8

                drawText("itemName",name,x,y,vector(0.5,0),priority,Color.white*opacity,inventoryImage.width)
            end
        end


        -- Draw item icons
        for i=1,slots do
            local image
            local sourceX,sourceY
            local width,height

            local item = data.inventoryItems[i]

            if item.type == "tool" or (item.type == nil and i <= steve.toolTypesCount) then
                image = steve.generalSettings.toolImage

                width = image.width/steve.toolTypesCount
                height = image.height/steve.toolTiersCount

                if item.type ~= nil then
                    sourceX = (item.toolType-1)*width
                    sourceY = (item.toolTier-1)*height
                else
                    sourceX = (i-1)*width
                    sourceY = 0
                end
            elseif item.type == "block" then
                local config = Block.config[item.blockID]

                image = Graphics.sprites.block[item.blockID].img

                width  = math.min(config.width ,slotWidth )
                height = math.min(config.height,slotHeight)
                sourceX = (config.width *0.5)-(width *0.5)
                sourceY = (config.height*0.5)-(height*0.5)

                if data.selectedInventorySlot == i then
                    sourceY = sourceY + (height*blockutils.getBlockFrame(item.blockID))
                end
            end


            if image ~= nil then
                local x,y = getItemPosition(camObj,slotWidth,slotHeight,slots,width,height,i)

                Graphics.drawImageWP(image,x,y,sourceX,sourceY,width,height,priority)
            end
            if item.type ~= nil and item.count > 1 then
                local x,y = getItemPosition(camObj,slotWidth,slotHeight,slots,0,0,i)

                x = x + (slotWidth *0.5) - 2
                y = y + (slotHeight*0.5) - 2

                drawText("itemCount_".. i,tostring(item.count),x,y,vector(1,1),priority)
            end

            -- Durability
            if item.durability ~= nil and item.durability ~= item.durabilityMax then
                local totalWidth = (slotWidth-12)
                local totalHeight = 2
                local x,y = getItemPosition(camObj,slotWidth,slotHeight,slots,totalWidth,0,i)

                y = y + (slotHeight*0.5) - totalHeight - 6


                local durabilityLeft = (item.durability/item.durabilityMax)
                local filledWidth = durabilityLeft*totalWidth
                local color = Color.lerp(Color.red,Color.green,durabilityLeft)
                

                local args = {
                    color = Color.black,priority = priority,
                    x = x,y = y,width = totalWidth,height = totalHeight,
                }

                Graphics.drawBox(args)

                args.color = color
                args.width = filledWidth

                Graphics.drawBox(args)
            end
        end
    end

    function steve.drawHUD(playerIdx,camObj,playerObj,priority,isSplit,playerCount)
        steve.drawHearts(playerIdx,camObj,playerObj,priority,isSplit,playerCount)
        steve.drawInventory(playerIdx,camObj,playerObj,priority,isSplit,playerCount)
    end
    
    Graphics.registerCharacterHUD(CHARACTER_STEVE,Graphics.HUD_NONE,steve.drawHUD)
end



-- Inventory
local resetInventoryData
local handleInventory

do
    local numberKeys = {[VK_1] = 1,[VK_2] = 2,[VK_3] = 3,[VK_4] = 4,[VK_5] = 5,[VK_6] = 6,[VK_7] = 7,[VK_8] = 8,[VK_9] = 9,[VK_0] = 10}


    function resetInventoryData()
        data.inventoryItems = {}
        for i=1,steve.inventorySettings.slots do
            local item = savedData.items[i] or steve.inventorySettings.defaultItems[i] or {}

            if item.type == "tool" then
                item.durabilityMax = item.durabilityMax or steve.inventorySettings.toolDurability[item.toolType][item.toolTier]
                item.durability = item.durability or item.durabilityMax
            end

            data.inventoryItems[i] = item
        end

        data.selectedInventorySlot = 1
        data.selectedItemTime = math.huge
    end

    local function canUseNumberKeys()
        if Misc.GetSelectedControllerName(1) ~= "Keyboard" then
            return false
        end

        -- Can only use number keys if none are set to an action
        for name,_ in pairs(player.keys) do
            if numberKeys[inputConfig1[name] or inputConfig1[name:lower()]] then
                return false
            end
        end

        return true
    end

    local function canChangeSelectedSlot()
        if not isOverworld then
            return (
                player.deathTimer == 0
                and Level.winState() == 0
            )
        end
    end
    
    local function canDropItem()
        if not isOverworld then
            return (
                player.forcedState == FORCEDSTATE_NONE and player.deathTimer == 0

                and player.holdingNPC == nil
                and not player.climbing
                and player:mem(0x26,FIELD_WORD) == 0
            
                and Level.winState() == 0
            )
        end
    end


    function steve.setSelectedInventorySlot(value)
        value = ((value-1)%steve.inventorySettings.slots)+1

        if value ~= data.selectedInventorySlot then
            data.selectedInventorySlot = value
            data.selectedItemTime = 0
        end
    end

    local itemFields = {"type","count","toolType","toolTier","blockID","powerupID"}
    local function cloneItem(item)
        local clone = {}

        for _,name in ipairs(itemFields) do
            clone[name] = item[name]
        end

        return clone
    end

    function steve.collectItem(item)
        local slot

        -- Find its slot
        for i=1,steve.inventorySettings.slots do
            local itemHere = data.inventoryItems[i]
            
            local slotType = "block"
            if i <= steve.toolTypesCount then
                slotType = "tool"
            end

            if item.type == slotType then
                if item.type == itemHere.type and item.blockID == itemHere.blockID and itemHere.count < steve.inventorySettings.maxItems[itemHere.type] then
                    slot = i
                    break
                elseif itemHere.type == nil and slot == nil then
                    slot = i
                end
            end
        end

        -- If there is one, put it in
        if slot ~= nil then
            local itemHere = data.inventoryItems[slot]
            local max = steve.inventorySettings.maxItems[item.type]

            data.inventoryItems[slot] = item

            if itemHere.type ~= nil then
                -- Put the old item's count and the new item's counts together
                item.count = item.count + itemHere.count
            elseif data.selectedInventorySlot == slot then
                data.selectedItemTime = 0
            end

            if item.count > max then -- If we've gone past the maximum, try to fill in another slot
                local clone = cloneItem(item)

                clone.count = item.count - max
                item.count = max

                steve.collectItem(clone)
            end
        end


        return slot
    end
    

    function handleInventory()
        if canChangeSelectedSlot() then
            if player.rawKeys.altJump == KEYS_PRESSED then
                steve.setSelectedInventorySlot(data.selectedInventorySlot-1)
            elseif player.rawKeys.altRun == KEYS_PRESSED then
                steve.setSelectedInventorySlot(data.selectedInventorySlot+1)
            end
        end
        if canDropItem() and player.keys.dropItem == KEYS_PRESSED and steve.droppedItem ~= nil then
            local item = data.inventoryItems[data.selectedInventorySlot]

            if item.type == "block" then
                local npc = NPC.spawn(steve.droppedItem.idList[1],player.x+(player.width*0.5),player.y+(player.height*0.25),player.section,false,true)
                local npcData = npc.data

                npcData.itemData = item

                npc.speedX = 3*player.direction
                npc.speedY = -3


                data.punchAnimationTimer = 0
                data.inventoryItems[data.selectedInventorySlot] = {}
            end
        end

        data.selectedItemTime = data.selectedItemTime + 1
    end

    function steve.onKeyboardPressDirect(keyCode, repeated, character)
        if player.character ~= CHARACTER_STEVE or not canChangeSelectedSlot() then
            return
        end

        local value = numberKeys[keyCode]

        if value ~= nil and value >= 1 and value <= steve.inventorySettings.slots and canUseNumberKeys() then
            steve.setSelectedInventorySlot(value)
        end
    end
end


-- Powerups/tool upgrading
local resetPowerupData
local handlePowerups

do
    local function npcHarmfulFilter(v)
        local config = NPC.config[v.id]

        return (
            Colliders.FILTER_COL_NPC_DEF(v)
            and v.despawnTimer > 0
            and not config.nohurt
        )
    end
    local function getHarmCulprit()
        local col = Colliders.getSpeedHitbox(player)

        col.x = col.x - 2
        col.width = col.width + 4
        col.y = col.y - 2
        col.height = col.height + 4


        local npcs   = Colliders.getColliding{a = col,btype = Colliders.NPC  ,filter = npcHarmfulFilter}
        local blocks = Colliders.getColliding{a = col,btype = Colliders.BLOCK,b = Block.HURT           }

        return (npcs[1] or blocks[1])
    end


    local function harmPlayer(amount)
        savedData.health = savedData.health - (amount or 1)

        SFX.play(RNG.irandomEntry(steve.generalSettings.hitSounds))


        if savedData.health > 0 then
            player:mem(0x140,FIELD_WORD,150)
            data.hitRedTimer = steve.generalSettings.hitRedTime


            local culprit = getHarmCulprit()
            local direction = player.direction

            if culprit ~= nil then
                direction = math.sign((culprit.x+(culprit.width*0.5))-(player.x+(player.width*0.5)))
            end

            player.speedX = steve.generalSettings.hitKnockbackSpeed.x*direction
            player.speedY = steve.generalSettings.hitKnockbackSpeed.y
        else
            player:kill()
        end
    end
    local function healPlayer(amount)
        savedData.health = math.min(steve.generalSettings.maxHealth,savedData.health + (amount or 1))
    end


    steve.toolTierWorth = {
        [steve.TOOL_TIER.NONE]      = 0,
        [steve.TOOL_TIER.WOOD]      = 1,
        [steve.TOOL_TIER.STONE]     = 2,
        [steve.TOOL_TIER.IRON]      = 3,
        [steve.TOOL_TIER.GOLD]      = 3,
        [steve.TOOL_TIER.DIAMOND]   = 4,
        [steve.TOOL_TIER.NETHERITE] = 5,
    }

    local function canDoUpgradingAnimation()
        return (
            player.forcedState == FORCEDSTATE_NONE and player.deathTimer == 0
        )
    end

    function steve.upgradeTools(powerupID,force,instant)
        if not instant and not canDoUpgradingAnimation() then
            return false
        end

        -- Upgrade any tools
        local newWorth = steve.toolTierWorth[powerupID]

        local slot

        for i=1,steve.inventorySettings.slots do
            local item = data.inventoryItems[i]

            local currentWorth = steve.toolTierWorth[item.toolTier]

            if (item.type == "tool" and (item.toolTier ~= powerupID or item.durability < item.durabilityMax) and (newWorth >= currentWorth or force)) or (item.type == nil and i <= steve.toolTypesCount) then
                if slot == nil or i == data.selectedInventorySlot then
                    slot = i
                end


                item.toolTier = powerupID

                if item.type == nil then
                    item.type = "tool"
                    item.count = 1
                    item.toolType = i
                end

                item.durabilityMax = steve.inventorySettings.toolDurability[item.toolType][item.toolTier]
                item.durability = item.durabilityMax
            end
        end


        -- Upgrading animation
        if slot ~= nil and not instant then
            if slot == data.selectedInventorySlot then
                data.selectedItemTime = 0
            end

            player.forcedState = FORCEDSTATE_POWERUP_BIG
            player.forcedTimer = 0

            data.upgradingItemSlot = slot
        end

        -- Heal the player and give points
        if not instant then
            Misc.givePoints(6,{x = player.x+(player.width*0.5),y = player.y+(player.height*0.5)},true)
            healPlayer(1)

            if slot == nil then
                SFX.play(12)
            end
        end


        return (slot ~= nil)
    end



    function resetPowerupData()
        data.upgradingItemSlot = nil
        data.hitRedTimer = 0

        if savedData.health == nil or savedData.health <= 0 or Misc.inEditor() then
            savedData.health = steve.generalSettings.startingHealth
        end
    end

    function handlePowerups()
        data.hitRedTimer = math.max(0,data.hitRedTimer-1)

        if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL then
            player.forcedState = FORCEDSTATE_NONE
            player.forcedTimer = 0

            harmPlayer(1)
        elseif player.deathTimer > 0 then
            if player.deathTimer == 1 and player.y > (player.sectionObj.boundary.bottom+64) then
                SFX.play(steve.generalSettings.dieOffScreenSound)
            end

            savedData.health = 0
        end
        
        if player:mem(0x16,FIELD_WORD) > 2 then
            healPlayer(1)
        end

        player:mem(0x16,FIELD_WORD,2)
    end
end


-- Crouching movement
local handleCrouchingMovement

do
    local function canCrouchMove()
        return (
            player.forcedState == FORCEDSTATE_NONE and player.deathTimer == 0

            and player:mem(0x12E,FIELD_BOOL)
            and player:isOnGround()

            and player:mem(0x26,FIELD_WORD) == 0 -- picking something up from above
            and player.mount == MOUNT_NONE
        )
    end


    local function safeBlockFilter(v)
        return (solidOrSemisolidBlockFilter(v) and not Block.HURT_MAP[v.id])
    end

    local function positionIsSafe()
        colBox.width = (player.width*0.5)
        colBox.height = 1

        colBox.x = player.x+(player.width*0.5)
        colBox.y = player.y+player.height

        if player.direction == DIR_LEFT then
            colBox.x = colBox.x-colBox.width
        end


        local blocks = Colliders.getColliding{a = colBox,btype = Colliders.BLOCK,filter = safeBlockFilter          }
        local npcs   = Colliders.getColliding{a = colBox,btype = Colliders.NPC  ,filter = solidOrSemisolidNPCFilter}

        return (#blocks > 0 or #npcs > 0)
    end


    function handleCrouchingMovement()
        if not canCrouchMove() then
            return
        end


        local direction = (player.keys.left and DIR_LEFT) or (player.keys.right and DIR_RIGHT) or 0        

        if direction ~= 0 then
            local acceleration = steve.generalSettings.crouchingAcceleration
            local max = steve.generalSettings.crouchingMaxSpeed
            
            if math.abs(player.speedX) <= max and positionIsSafe() then
                player.speedX = math.clamp(player.speedX+(acceleration*direction),-max,max)
            end
        end
    end
end


-- Mining
local resetMiningData

local handleMining
local applyDestroyingEffect

do
    -- Added 'steveDestroyingTime' config, if >= 0 multiplier for destroying time, if < 0 cannot be mined
    for id=1,BLOCK_MAX_ID do
        local config = Block.config[id]
        
        config:setDefaultProperty("steveDestroyingTime",1)
    end



    local function minableBlockFilter(v)
        return (
            solidOrSemisolidBlockFilter(v)
            and not Block.SIZEABLE_MAP[v.id]
            and not Block.LAVA_MAP[v.id]
        )
    end

    local function getNeededMiningTime(block)
        local config = Block.config[block.id]
        local item = data.inventoryItems[data.selectedInventorySlot]


        local time = steve.miningSettings.baseDestroyingTime

        if item.type == "tool" and item.toolType == steve.TOOL_TYPE.PICKAXE then
            time = time*(steve.miningSettings.toolSpeed[item.toolTier] or 1)
        else
            time = time*(steve.miningSettings.toolSpeed[steve.TOOL_TIER.NONE])
        end

        if config.steveDestroyingTime >= 0 then
            time = time*config.steveDestroyingTime
        else
            time = math.huge
        end


        return time
    end

    local function destroyBlock(block)
        if steve.droppedItem ~= nil then -- droppedItem is from droppedItem_ai.lua
            local npc = NPC.spawn(steve.droppedItem.idList[1],block.x+(block.width*0.5),block.y+(block.height*0.5),nil,false,true)
            local npcData = npc.data

            npcData.itemData = {type = "block",count = 1,blockID = block.id}

            npc.speedY = -5
        end

        -- Spawn contents (based on blockutils.spawnNPC)
        local id = (block.data._basegame.content or block.contentID)

        if id > 1000 then
            local npc = NPC.spawn(id-1000,block.x+(block.width*0.5),block.y+(block.height*0.5),nil,false,true)

            npc:mem(0x136,FIELD_BOOL,true)
            npc.speedY = -6
        else
            for i=1,id do
                local npc = NPC.spawn(10,block.x+(block.width*0.5),block.y+(block.height*0.5),nil,false,true)

                npc.speedX = RNG.random(-3,3)
                npc.speedY = RNG.random(-5,-1)
                npc.ai1 = 1
            end
        end

        
        if getNeededMiningTime(block) > 0 then
            decreaseItemDurability(data.selectedInventorySlot,1,steve.TOOL_TYPE.PICKAXE)
        end

        block:remove(false)
        block:delete()
    end


    local function canMine()
        if not isOverworld then
            return (
                player.forcedState == FORCEDSTATE_NONE and player.deathTimer == 0

                and player:mem(0x26,FIELD_WORD) == 0 -- pulling something out of the ground
                and player.holdingNPC == nil
                and Level.winState() == 0
            )
        end
    end


    function resetMiningData()
        data.miningBlock = nil
        data.miningTime = 0

        data.miningSound = nil
    end

    function handleMining()
        if not canMine() then
            resetMiningData()
            return
        end


        local block,distance
        if mem(MOUSE_LEFT_PRESSED,FIELD_BOOL) then
            block,distance = getObjectClickedOn(Colliders.BLOCK,minableBlockFilter,steve.miningSettings.maxDistanceFromBlock)
        end
        

        if block ~= nil then
            if block ~= data.miningBlock then
                data.miningBlock = block
                data.miningTime = 0

                local direction = math.sign((block.x+(block.width*0.5))-(player.x+(player.width*0.5)))

                if direction ~= 0 then
                    player.direction = direction
                end
            end

            data.miningTime = data.miningTime + 1
            if data.miningTime >= getNeededMiningTime(data.miningBlock) then
                destroyBlock(data.miningBlock)
            end

            if (data.miningTime-1)%steve.miningSettings.soundDelay == 0 then
                data.miningSound = SFX.play(RNG.irandomEntry(steve.miningSettings.sounds))
            end

            data.punchAnimationTimer = data.punchAnimationTimer or 0
        else
            resetMiningData()
        end
    end


    local applyShader = Shader()
    applyShader:compileFromFile(nil, Misc.resolveFile("steve/applyDestroyingEffect.frag"))

    function applyDestroyingEffect()
        local block = data.miningBlock

        if block == nil or not block.isValid then
            return
        end
        
        local blockImage = Graphics.sprites.block[block.id].img
        if blockImage == nil then
            return
        end

        local blockFrame = math.max(0,blockutils.getBlockFrame(block.id))
        local blockSourceY = (blockFrame*block.height)

        local destroyingImage = steve.miningSettings.destroyingImage
        local destroyingFrames = steve.miningSettings.destroyingFrames
        local destroyingFrame = math.min(destroyingFrames-1,math.floor((data.miningTime/getNeededMiningTime(block))*destroyingFrames))


        Graphics.drawBox{
            texture = blockImage,priority = -64.99,sceneCoords = true,

            x = block.x,y = block.y,sourceX = 0,sourceY = blockSourceY,
            width = block.width,height = block.height,sourceWidth = block.width,sourceHeight = block.height,

            shader = applyShader,uniforms = {
                blockImageSize = vector(blockImage.width,blockImage.height),
                blockSourceY = (blockSourceY/blockImage.height),

                destroyingImage = destroyingImage,
                destroyingSize = vector(destroyingImage.width,destroyingImage.height),
                destroyingFrames = destroyingFrames,
                destroyingFrame = destroyingFrame,
            },
        }
    end
end


-- "Combat"/punching stuff
local resetCombatData
local handleCombat

do
    local function canSwing()
        if not isOverworld then
            return (
            
                player.forcedState == FORCEDSTATE_NONE and player.deathTimer == 0

                and player:mem(0x26,FIELD_WORD) == 0 -- pulling something out of the ground
                and player.holdingNPC == nil
                and Level.winState() == 0

                and data.miningBlock == nil
            )
        end
    end

    local function hittableNPCFilter(v)
        return (
            Colliders.FILTER_COL_NPC_DEF(v)
            and v.despawnTimer > 0
            and NPC.HITTABLE_MAP[v.id]
        )
    end



    function resetCombatData()
        data.swingingAtPosition = nil
        data.swingingAtTimer = 0
        
        data.wasLeftClicking = mem(MOUSE_LEFT_PRESSED,FIELD_BOOL)
    end

    function handleCombat()
        if not canSwing() then
            resetCombatData()
            return
        end

        if mem(MOUSE_LEFT_PRESSED,FIELD_BOOL) and not data.wasLeftClicking then
            local direction = math.sign((mem(MOUSE_X,FIELD_DFLOAT)+camera.x)-(player.x+(player.width*0.5)))
            if direction ~= 0 then
                player.direction = direction
            end


            -- Try to hit any NPC's
            local item = data.inventoryItems[data.selectedInventorySlot]
            local hitNPC

            if item.type == "tool" --[[and item.toolType == steve.TOOL_TYPE.SWORD]] then
                hitNPC = getObjectClickedOn(Colliders.NPC,hittableNPCFilter,steve.combatSettings.maxDistanceFromNPC)

                if hitNPC ~= nil then
                    data.swingingAtPosition = vector(hitNPC.x+(hitNPC.width*0.5),hitNPC.y+(hitNPC.height*0.5))
                    data.swingingAtTimer = 0
                    decreaseItemDurability(data.selectedInventorySlot,1,steve.TOOL_TYPE.SWORD)

                    local damage = steve.combatSettings.toolStrength[item.toolTier]
                    if item.toolType ~= steve.TOOL_TYPE.SWORD then
                        damage = damage*0.5
                    end

                    hitNPC:harm(HARM_TYPE_NPC,damage)
                end
            end

            if data.swingingAtPosition == nil then
                data.swingingAtPosition = vector(mem(MOUSE_X,FIELD_DFLOAT)+camera.x,mem(MOUSE_Y,FIELD_DFLOAT)+camera.y)
                data.swingingAtTimer = 0

                SFX.play(RNG.irandomEntry(steve.combatSettings.missSounds),0.75)
            else
                SFX.play(RNG.irandomEntry(steve.combatSettings.hitSounds),0.75)
            end


            data.punchAnimationTimer = 0
        end

        if data.swingingAtPosition ~= nil then
            data.swingingAtTimer = data.swingingAtTimer + 1

            if data.swingingAtTimer > 32 then
                data.swingingAtPosition = nil
                data.swingingAtTimer = 0
            end
        end


        data.wasLeftClicking = mem(MOUSE_LEFT_PRESSED,FIELD_BOOL)
    end
end


-- Block placing
local resetPlacingBlockData
local handleBlockPlacing
local drawPlacingBlockPreview

do
    local function canPlaceBlocks()
        if not isOverworld then
            return (
            
                player.forcedState == FORCEDSTATE_NONE and player.deathTimer == 0

                and player:mem(0x26,FIELD_WORD) == 0 -- pulling something out of the ground
                and player.holdingNPC == nil
                and Level.winState() == 0
                and data.miningBlock == nil
            )
        end
    end

    local function getPlacingBlockPosition()
        local position = vector(mem(MOUSE_X,FIELD_DFLOAT)+camera.x,mem(MOUSE_Y,FIELD_DFLOAT)+camera.y)
        local gridSize = steve.blockPlacingSettings.gridSize

        position.x = math.floor((position.x/gridSize)+0)*gridSize
        position.y = math.floor((position.y/gridSize)+0)*gridSize

        return position
    end


    local function npcFilter(v)
        return (v.despawnTimer > 0 and not v.isHidden and not v.isGenerator)
    end
    local function blockFilter(v)
        return (not v.isHidden and not Block.SIZEABLE_MAP[v.id])
    end
    local function positionIsClear(x,y,width,height,id)
        colBox.x = x
        colBox.y = y
        colBox.width = width
        colBox.height = height

        if colBox:collide(player) and not Block.SEMISOLID_MAP[id] then
            return false
        end

        if #Colliders.getColliding{a = colBox,btype = Colliders.NPC,filter = npcFilter} > 0 then
            return false
        end

        if #Colliders.getColliding{a = colBox,btype = Colliders.BLOCK,filter = blockFilter} > 0 then
            return false
        end


        return true
    end


    local function placeBlock(item)
        local item = data.inventoryItems[data.selectedInventorySlot]
        local config = Block.config[item.blockID]

        local block = Block.spawn(item.blockID,data.placingBlockPosition.x,data.placingBlockPosition.y)

        

        -- Animation stuff
        local direction = math.sign(data.placingBlockPosition.x-(player.x+(player.width*0.5)))
        if direction ~= 0 then
            player.direction = direction
        end


        data.punchAnimationTimer = 0

        data.swingingAtPosition = data.placingBlockPosition
        data.swingingAtTimer = 0


        SFX.play(RNG.irandomEntry(steve.blockPlacingSettings.sounds))


        -- Remove 1 from the item
        item.count = math.max(0,item.count - 1)

        if item.count == 0 then
            data.inventoryItems[data.selectedInventorySlot] = {}
        end
    end


    function resetPlacingBlockData()
        data.placingBlockID = nil
        data.placingBlockPosition = nil
    end

    function handleBlockPlacing()
        -- Right click detection is weird
        local rightPressed = mem(MOUSE_RIGHT_PRESSED,FIELD_BOOL)
        mem(MOUSE_RIGHT_PRESSED,FIELD_BOOL,false)


        if not canPlaceBlocks() then
            resetPlacingBlockData()
            return
        end


        local item = data.inventoryItems[data.selectedInventorySlot]

        if item.type == "block" then
            -- Finding a position for the block
            local config = Block.config[item.blockID]
            local position = getPlacingBlockPosition()

            local distance = (position-vector(player.x+(player.width*0.5),player.y+(player.height*0.5)))


            if distance.length < steve.blockPlacingSettings.maxDistanceFromPlayer and positionIsClear(position.x,position.y,config.width,config.height,item.blockID) and not blocksInTheWay(player.x+(player.width*0.5),player.y+(player.height*0.25),position.x,position.y) then
                data.placingBlockID = item.blockID
                data.placingBlockPosition = position
            else
                data.placingBlockPosition = nil
            end


            -- Actually placing it
            if data.placingBlockPosition ~= nil and rightPressed then
                placeBlock()
            end
        else
            data.placingBlockPosition = nil
        end
    end


    function drawPlacingBlockPreview()
        if data.placingBlockPosition == nil then
            return
        end


        local texture = Graphics.sprites.block[data.placingBlockID].img
        local config = Block.config[data.placingBlockID]

        if texture == nil or config == nil then
            return
        end


        local opacity = (math.abs(math.sin(lunatime.tick()/32))*0.25)+0.35

        Graphics.drawImageToSceneWP(texture,data.placingBlockPosition.x,data.placingBlockPosition.y,0,0,config.width,config.height,opacity,-64.95)
    end
end



local function resetData()
    data.initialised = true


    data.meshParent = Transform(vector.zero3) -- All the body's meshes are parented to this

    data.bodyMaterial = nil
    data.bodyMeshes = {}

    data.heldItemMaterials = {}
    data.heldItemMeshes = {}


    data.globalMeshRotation = vector(0,player.direction*-steve.generalSettings.normalYRotation,0)
    data.headXRotation = 0

    data.partAnimationData = {}
    resetPartAnimationData()

    data.currentAnimation = "idle"
    data.animationTimer = 0
    data.animationSpeed = 1

    data.punchAnimationTimer = nil


    data.glintSprite = Sprite{texture = steve.generalSettings.glintImage,frames = steve.generalSettings.glintFrames,pivot = Sprite.align.CENTRE}
    data.glintTimer = nil

    data.onTickFrame = player.frame


    resetInventoryData()
    resetMiningData()
    resetCombatData()
    resetPowerupData()
end



function steve.onInitAPI()
    registerEvent(steve,"onTick")
    registerEvent(steve,"onTickEnd")

    registerEvent(steve,"onCameraDraw")
    registerEvent(steve,"onDraw")

    registerEvent(steve,"onExitLevel")

    registerEvent(steve,"onKeyboardPressDirect")
        
    ready = true
end


function steve.initCharacter()
    resetData()

    
    steve.loadMeshes()

    Defines.player_walkspeed = steve.generalSettings.walkSpeed
    Defines.player_runspeed  = steve.generalSettings.runSpeed
    Defines.jumpheight = steve.generalSettings.jumpForce
    
    Audio.sounds[5].muted = true

    initHUD()
end

function steve.cleanupCharacter()
    steve.destroyMeshes()
    data.initialised = false

    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight = nil

    Audio.sounds[5].muted = false

    cleanupHUD()
end


function steve.onTick()
    if player.character ~= CHARACTER_STEVE then
        return
    end


    -- No spin jumping
    if player.mount == MOUNT_NONE then
        player:mem(0x120,FIELD_BOOL,false)
    end

    -- Update glint effect
    if data.glintTimer ~= nil then
        data.glintTimer = data.glintTimer + 1

        if data.glintTimer > steve.generalSettings.glintFrames*steve.generalSettings.glintFrameDelay then
            data.glintTimer = nil
        end
    end

    player.powerup = PLAYER_BIG


    handleInventory()
    handleCrouchingMovement()
    handleMining()
    handleBlockPlacing()
    handleCombat()

    handlePowerups()

    
    data.onTickFrame = player.frame
end

function steve.onTickEnd()
    if player.character ~= CHARACTER_STEVE then
        return
    end

    -- Move the held NPC
    local settings = PlayerSettings.get(playerManager.getBaseID(player.character),player.powerup)

    if player.holdingNPC ~= nil and player.holdingNPC.isValid then
        player.holdingNPC.x = player.x+(player.width*0.5)-(player.holdingNPC.width*0.5)
        player.holdingNPC.y = player.y+player.height-settings.hitboxHeight-player.holdingNPC.height+6
    end


    handleAnimation()
end


function steve.onDraw()
    if player.character ~= CHARACTER_STEVE then
        return
    end

    
    Graphics.sprites.ultimaterinka[player.powerup].img = Graphics.loadImageResolved("graphics/smbx2og/character/ultimaterinka-2.png")
    
    if data.glintTimer ~= nil then
        data.glintSprite:draw{frame = math.floor(data.glintTimer/steve.generalSettings.glintFrameDelay)+1,priority = -5,sceneCoords = true}
    end

    applyDestroyingEffect()
    drawPlacingBlockPreview()
end


function steve.onExitLevel()
    if data.inventoryItems == nil or Misc.inEditor() then
        return
    end

    -- Save tools
    for i=1,steve.inventorySettings.slots do
        local item = data.inventoryItems[i]

        if item.type == "tool" then
            savedData.items[i] = item
        else
            savedData.items[i] = nil
        end
    end
end



-- Rendering
do
    local defaultQuat = vector.quat(0,0,0)
    local function quat(x,y,z)
        if x == 0 and y == 0 and z == 0 then
            return defaultQuat
        else
            return vector.quat(x,y,z)
        end
    end


    function steve.setupItemMesh(mesh,item,setupPosition) -- also used by dropped items
        if mesh == nil or not mesh.isValid then
            return
        end


        local material = mesh.materials[1]

        if item.type == "tool" then
            material:setUniform("frames",vector(steve.toolTypesCount,steve.toolTiersCount))
            material:setUniform("frame",vector(item.toolType-1,item.toolTier-1))

            if setupPosition then
                mesh.transform.position = steve.generalSettings.heldToolOffset*steve.generalSettings.modelScale
            end
        elseif item.type == "block" then
            local texture = Graphics.sprites.block[item.blockID].img
            local config = Block.config[item.blockID]

            material:setUniform("texture",texture)
            material:setUniform("frames",vector(1,texture.height/config.height))
            material:setUniform("frame",vector(0,math.max(0,blockutils.getBlockFrame(item.blockID))))

            if setupPosition then
                mesh.transform.position = steve.generalSettings.heldBlockOffset*steve.generalSettings.modelScale
            end
        elseif item.type == "powerup" then
            material:setUniform("frames",vector(1,steve.toolTiersCount-1))
            material:setUniform("frame",vector(0,item.powerupID-2))
        end

        
        if setupPosition then
            if data.currentAnimation == "upgradeTool" then
                local armRotation = data.partAnimationData.leftArm.rotation
                local moved = math.max(0,-(armRotation.x+10)/90)

                mesh.transform.rotation = quat(moved*55,0,0)
                mesh.transform.position = mesh.transform.rotation*(mesh.transform.position*vector(1,math.lerp(1,0.5,moved),math.lerp(1,1.5,moved)))
            else
                mesh.transform.rotation = quat(0,0,0)
            end
        end


        mesh.active = true
    end


    local noDrawForcedStates = table.map{FORCEDSTATE_INVISIBLE}
    local function canDrawPlayer()
        return (
            not noDrawForcedStates[player.forcedState]
            and player.deathTimer < 80
            and (not player:mem(0x142,FIELD_BOOL) or data.hitRedTimer > 0)
        )
    end

    local function getPriority()
        if player.forcedState == FORCEDSTATE_PIPE then
            return -70
        elseif smasbooleans.activateWarpWhistleRoomWarp[1] then
            return -70
        else
            return -25
        end
    end
    

    local hurtColor = Color(1,0.5,0.5,1)

    local function getColor()
        if Defines.cheat_shadowmario then
            return Color.black
        elseif data.hitRedTimer > 0 or player.deathTimer > 0 then
            return hurtColor
        else
            return nil
        end
    end

    local starmanShader = Shader()
    starmanShader:compileFromFile(nil,Misc.multiResolveFile("starman.frag","shaders\\npc\\starman.frag"))

    local function getShader()
        if player.hasStarman then
            return starmanShader,{time = lunatime.tick()*2}
        end

        return nil,nil
    end


    function steve.render(args)
        if not args.ignorestate and not canDrawPlayer() then
            return
        end

        if not data.initialised then
            resetData()
            steve.loadMeshes()
        end


        -- Activate all the meshes and put them into position, preparing it for rendering
        local animationData = steve.animations[data.currentAnimation]

        data.meshParent.position.x = (args.x or player.x)+(player.width*0.5)
        data.meshParent.position.y = (args.y or player.y)+player.height
        data.meshParent.position.z = 0

        data.meshParent.rotation = quat(data.globalMeshRotation.x,data.globalMeshRotation.y,data.globalMeshRotation.z)

        for _,partData in ipairs(steve.bodyParts) do
            local partAnimationData = data.partAnimationData[partData.name]
            local mesh = data.bodyMeshes[partData.name]

            if mesh ~= nil and mesh.isValid then
                mesh.transform.position = (partData.offset+partAnimationData.offset+vector(0,-1.2,0))*steve.generalSettings.modelScale
                mesh.transform.rotation = quat(partAnimationData.rotation.x,partAnimationData.rotation.y,partAnimationData.rotation.z)

                mesh.active = true
            end
        end


        local item = data.inventoryItems[data.upgradingItemSlot or data.selectedInventorySlot]
        
        if item.type ~= nil and (player.holdingNPC == nil or animationData.noHoldingNPCArmsRaise) then
            local mesh = data.heldItemMeshes[item.type]

            steve.setupItemMesh(mesh,item,true)
        end



        if args.sceneCoords ~= false then
            steve.camera.transform.position.x = camera.x+(camera.width *0.5)
            steve.camera.transform.position.y = camera.y+(camera.height*0.5)
        else
            steve.camera.transform.position.x = (camera.width *0.5)
            steve.camera.transform.position.y = (camera.height*0.5)
        end

        -- Actually draw the scene
        local color = args.color or getColor()
        local priority = args.priority or (getPriority()-0.01)
        local shader,uniforms = args.shader,args.uniforms

        if shader == nil then
            shader,uniforms = getShader()
        end


        steve.camera:draw(priority)
        Graphics.drawScreen{texture = steve.camera.target,target = args.target,color = color,priority = priority,shader = shader,uniforms = uniforms,attributes = args.attributes}

        
        -- Deactivate all the meshes
        for _,partData in ipairs(steve.bodyParts) do
            local mesh = data.bodyMeshes[partData.name]

            if mesh.isValid then
                mesh.active = false
            end
        end
        for _,name in ipairs(steve.itemTypes) do
            local mesh = data.heldItemMeshes[name]

            if mesh.isValid then
                mesh.active = false
            end
        end
    end


    function steve.onCameraDraw()
        if player.character ~= CHARACTER_STEVE then
            return
        end

        steve.render{}
    end


    -- Maaaybe find better method to do this?
    local normalPlayerRender = Player.render

    function Player:render(args)
        if (args.character or player.character) == CHARACTER_STEVE then
            steve.render(args)
            return
        end

        normalPlayerRender(self,args)
    end
end



steve.skinSettings = {
    -- The name of the skin. The image comes from steve/skins.
    name = "steve",
    -- The body type used for this skin. Can be NORMAL or THIN_ARMS.
    type = steve.SKIN_TYPE.NORMAL,
}

steve.generalSettings = {
    walkSpeed = 2,
    runSpeed  = 4,

    jumpForce = 18,


    -- How fast crouch-walking is.
    crouchingAcceleration = 0.3,
    crouchingMaxSpeed = 1,

    -- The number of hearts the player starts with.
    startingHealth = 5,
    -- The maximum number of hearts the player can have.
    maxHealth = 5,


    -- The Y rotation that the player usually has.
    normalYRotation = 40,
    -- How fast the player rotates when turning.
    turningRotationSpeed = 16,

    -- How much the models are scaled when they're being loaded.
    modelScale = 30,


    -- How much the currently held item is offset from the hand.
    heldToolOffset  = vector(-0.125,0.1875,-0.375),
    heldBlockOffset = vector(-0.125,0.3125,-0.25),

    -- How far the head gets rotated when looking up.
    headLookUpRotation = -35,
    -- How fast the head's rotation can change.
    headRotationSpeed = 3,


    -- The graphic used by tools.
    toolImage = Graphics.loadImageResolved("steve/tools.png"),
    -- The graphic used by powerups.
    powerupImage = Graphics.loadImageResolved("steve/powerups.png"),
    -- The graphic used by the glint effect used in the tool upgrading animation.
    glintImage = Graphics.loadImageResolved("steve/glint.png"),
    glintFrames = 3,
    glintFrameDelay = 3,

    -- The sound played when upgrading a tool.
    upgradeToolSound = SFX.open(Misc.resolveSoundFile("steve/upgradeTool")),
    -- The sound played when a tool runs out of durability.
    breakToolSound = SFX.open(Misc.resolveSoundFile("steve/breakTool")),

    -- The sounds played when the player gets hurt.
    hitSounds = {
        SFX.open(Misc.resolveSoundFile("steve/hurt_1")),
        SFX.open(Misc.resolveSoundFile("steve/hurt_2")),
        SFX.open(Misc.resolveSoundFile("steve/hurt_3")),
    },
    -- The sound played when dying due to a bottomless pit.
    dieOffScreenSound = SFX.open(Misc.resolveSoundFile("steve/fall")),
    -- The amount of ticks that the player goes red for when getting hit.
    hitRedTime = 16,
    -- The knockback recieved by the player upon getting hit.
    hitKnockbackSpeed = vector(-5,-4),


    -- The ID of the dust spawned when dying.
    deathEffectID = 961,
}

steve.hudSettings = {
    -- The image used by the inventory/hotbar.
    inventoryImage = Graphics.loadImageResolved("steve/inventory.png"),
    -- The image used for the item currently selected.
    selectedInventoryImage = Graphics.loadImageResolved("steve/inventory_selected.png"),

    itemNameStayTime = 96,
    itemNameFadeTime = 32,

    -- The size of each individual inventory slot.
    inventorySlotWidth  = 40,
    inventorySlotHeight = 40,


    -- The image used by the hearts.
    healthImage = Graphics.loadImageResolved("steve/heart.png"),


    -- How much certain HUD elements are moved when using the character.
    moveHUDElementsDistance = 45,


    -- The font used in the HUD.
    font = textplus.loadFont("steve/font.ini"),
    fontScale = 2,
}


steve.inventorySettings = {
    -- How many slots there are for items.
    slots = 9,

    -- The maximum amount of each item type you can have.
    maxItems = {
        tool = 1,
        block = 64,
    },

    defaultItems = {
        [1] = {type = "tool",count = 1,toolType = steve.TOOL_TYPE.SWORD,toolTier = steve.TOOL_TIER.WOOD},
        [2] = {type = "tool",count = 1,toolType = steve.TOOL_TYPE.PICKAXE,toolTier = steve.TOOL_TIER.WOOD},

        [9] = {type = "block",count = 12,blockID = 950},
    },

    -- How many uses each type of tool can take.
    toolDurability = {
        [steve.TOOL_TYPE.SWORD] = {
            [steve.TOOL_TIER.WOOD]      = 30,
            [steve.TOOL_TIER.STONE]     = 68,
            [steve.TOOL_TIER.IRON]      = 90,
            [steve.TOOL_TIER.DIAMOND]   = 135,
            [steve.TOOL_TIER.NETHERITE] = 150,
            [steve.TOOL_TIER.GOLD]      = 19,
        },
        [steve.TOOL_TYPE.PICKAXE] = {
            [steve.TOOL_TIER.WOOD]      = 40,
            [steve.TOOL_TIER.STONE]     = 90,
            [steve.TOOL_TIER.IRON]      = 120,
            [steve.TOOL_TIER.DIAMOND]   = 180,
            [steve.TOOL_TIER.NETHERITE] = 200,
            [steve.TOOL_TIER.GOLD]      = 25,
        },
    },
    -- The names of each tool.
    toolNames = {
        [steve.TOOL_TYPE.SWORD] = {
            [steve.TOOL_TIER.WOOD]      = "Wooden Sword",
            [steve.TOOL_TIER.STONE]     = "Stone Sword",
            [steve.TOOL_TIER.IRON]      = "Iron Sword",
            [steve.TOOL_TIER.DIAMOND]   = "Diamond Sword",
            [steve.TOOL_TIER.NETHERITE] = "Netherite Sword",
            [steve.TOOL_TIER.GOLD]      = "Golden Sword",
        },
        [steve.TOOL_TYPE.PICKAXE] = {
            [steve.TOOL_TIER.WOOD]      = "Wooden Pickaxe",
            [steve.TOOL_TIER.STONE]     = "Stone Pickaxe",
            [steve.TOOL_TIER.IRON]      = "Iron Pickaxe",
            [steve.TOOL_TIER.DIAMOND]   = "Diamond Pickaxe",
            [steve.TOOL_TIER.NETHERITE] = "Netherite Pickaxe",
            [steve.TOOL_TIER.GOLD]      = "Golden Pickaxe",
        },
    },
}

steve.miningSettings = {
    -- The maximum distance that the mining block can be from the player.
    maxDistanceFromBlock = 256,
    -- The amount of time needed to mine a block before any multipliers are added.
    baseDestroyingTime = 96,

    -- The maximum rotation that the player's head can have.
    maxHeadRotation = 65,

    -- The image used for the effect while destroying a block.
    destroyingImage = Graphics.loadImageResolved("steve/destroying.png"),
    -- How many stages the image specified above has.
    destroyingFrames = 10,

    -- The sounds played while mining a block.
    sounds = {
        SFX.open(Misc.resolveSoundFile("steve/mine_1")),
        SFX.open(Misc.resolveSoundFile("steve/mine_2")),
        SFX.open(Misc.resolveSoundFile("steve/mine_3")),
        SFX.open(Misc.resolveSoundFile("steve/mine_4")),
    },
    -- The number of ticks between each sound.
    soundDelay = 12,


    -- How long each type of pickaxe takes to destroy one block. Each value here is a multiplier.
    toolSpeed = {
        [steve.TOOL_TIER.NONE]      = 6.6,
        [steve.TOOL_TIER.WOOD]      = 1,
        [steve.TOOL_TIER.STONE]     = 0.5,
        [steve.TOOL_TIER.IRON]      = 0.33,
        [steve.TOOL_TIER.DIAMOND]   = 0.26,
        [steve.TOOL_TIER.NETHERITE] = 0.23,
        [steve.TOOL_TIER.GOLD]      = 0.16,
    },
}

steve.combatSettings = {
    -- The maximum distance that the hit block can be from the player.
    maxDistanceFromNPC = 256,

    -- How much damage is done to a multi-hit NPC.
    toolStrength = {
        [steve.TOOL_TIER.WOOD]      = 0.35,
        [steve.TOOL_TIER.STONE]     = 0.45,
        [steve.TOOL_TIER.IRON]      = 0.6,
        [steve.TOOL_TIER.DIAMOND]   = 0.75,
        [steve.TOOL_TIER.NETHERITE] = 1.05,
        [steve.TOOL_TIER.GOLD]      = 2.25,
    },

    -- The sounds played when successfully hitting an enemy.
    hitSounds = {
        SFX.open(Misc.resolveSoundFile("steve/attack_1")),
        SFX.open(Misc.resolveSoundFile("steve/attack_2")),
        SFX.open(Misc.resolveSoundFile("steve/attack_3")),
        SFX.open(Misc.resolveSoundFile("steve/attack_4")),
        SFX.open(Misc.resolveSoundFile("steve/attack_5")),
        SFX.open(Misc.resolveSoundFile("steve/attack_6")),
        SFX.open(Misc.resolveSoundFile("steve/attack_7")),
    },
    -- The sounds played when missing an enemy.
    missSounds = {
        SFX.open(Misc.resolveSoundFile("steve/miss_1")),
        SFX.open(Misc.resolveSoundFile("steve/miss_2")),
        SFX.open(Misc.resolveSoundFile("steve/miss_3")),
        SFX.open(Misc.resolveSoundFile("steve/miss_4")),
    },
}

steve.blockPlacingSettings = {
    -- The maximum distance from the player that a placed block can be.
    maxDistanceFromPlayer = 384,

    -- The size of the grid blocks are snapped to when placed.
    gridSize = 32,

    -- The sounds played when placing a block.
    sounds = steve.miningSettings.sounds,
}




return steve