--smasNPCSystem.lua
--By Spencer Everly

--[[
    NPC option values:
    
    levelID = The actual level ID that NPC is taking
    id = The ID of the NPC
    image = Image of the NPC
    frameCount = Frame count of the NPC
    x = X position, used via scene coordinates
    y = Y position, used via scene coordinates
    width = Width of the NPC
    height = Height of the NPC
    direction = The direction the NPC is facing
    message = The message the NPC is using
    friendly = Whether the NPC is friendly or not
    cantMove = Whether the NPC doesn't move
    usingVanillaLayers = If this is using the vanilla layer system or not, if false this uses the smasLayerSystem library
    layer = The layer the NPC is attached to
    speed = The movement speed the NPC takes
    priority = The priority to draw the NPC on
    speedX = The speedX of the NPC
    speedY = the speedY of the NPC
    frameSpeed = The frame speed of the NPC
]]

local smasNPCSystem = {}

local littleDialogue
pcall(function() littleDialogue = require("littleDialogue") end)

smasNPCSystem.createdNPCs = {}
smasNPCSystem.NPCCount = 0
smasNPCSystem.messageMarkPriority = -40

local testNPC = Graphics.loadImageResolved("MALC - HUB/npc-466.png")
local testNPC2 = Graphics.loadImageResolved("npc-946.png")
local messageDialogMark = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-43.png")

function smasNPCSystem.onInitAPI()
    registerEvent(smasNPCSystem,"onStart")
    registerEvent(smasNPCSystem,"onTick")
    registerEvent(smasNPCSystem,"onDraw")
end

function smasNPCSystem.countNPCs()
    return smasNPCSystem.NPCCount
end

function smasNPCSystem.removeNPC(args)
    args.npcLevelID = args.npcLevelID or 1
    smasNPCSystem.NPCCount = smasNPCSystem.NPCCount - 1
    table.remove(smasNPCSystem.createdNPCs, args.npcLevelID)
end

function smasNPCSystem.createNPC(args) --smasNPCSystem.createNPC{id = 1, image = testNPC2, frameCount = 17, x = -200752, y = -200128, width = 68, height = 54, direction = -1, messageToSpeak = "Test", isFriendly = true, cantMove = true, useVanillaLayers = false, attachToLayer = "Default", movementSpeed = 2, frameSpeed = 3}
    if args.image == nil then
        error("You must specify an image for this Lua NPC!")
        return
    end
    if args.id == nil then
        error("You must specify the ID for this Lua NPC!")
        return
    end
    if args.frameCount == nil then
        frameCount = 1
    end
    if args.width == nil then
        error("You must specify the width for this Lua NPC!")
        return
    end
    if args.height == nil then
        error("You must specify the height for this Lua NPC!")
        return
    end
    if args.x == nil then
        error("You must specify an X coordinate for this Lua NPC!")
        return
    end
    if args.y == nil then
        error("You must specify an Y coordinate for this Lua NPC!")
        return
    end
    if args.isFriendly == nil then
        isFriendly = false
    end
    if args.cantMove == nil then
        cantMove = false
    end
    if args.messageToSpeak == nil then
        messageToSpeak = ""
    end
    if args.useVanillaLayers == nil then
        useVanillaLayers = false
    end
    if args.attachToVanillaLayer == nil then
        attachToVanillaLayer = "Default"
    end
    if args.movementSpeed == nil then
        args.movementSpeed = 0
    end
    if args.priority == nil then
        args.priority = -45
    end
    if args.speedX == nil then
        args.speedX = 0
    end
    if args.speedY == nil then
        args.speedY = 0
    end
    if args.frameSpeed == nil then
        args.frameSpeed = 8
    end
    
    smasNPCSystem.NPCCount = smasNPCSystem.NPCCount + 1
    
    table.insert(smasNPCSystem.createdNPCs, {
        id = args.id,
        levelID = smasNPCSystem.NPCCount,
        image = args.image,
        frameCount = args.frameCount,
        x = args.x,
        y = args.y,
        width = args.width,
        height = args.height,
        direction = args.direction,
        message = args.messageToSpeak,
        friendly = args.isFriendly,
        cantMove = args.cantMove,
        usingVanillaLayers = args.useVanillaLayers,
        layer = args.attachToLayer,
        speed = args.movementSpeed,
        priority = args.priority,
        speedX = args.speedX,
        speedY = args.speedY,
        frameSpeed = args.frameSpeed,
    })
end

function smasNPCSystem.drawNPC(levelID)
    if levelID == nil then
        error("NPC ID must be specified!")
        return
    end
    
    
    
    if smasNPCSystem.createdNPCs[levelID].direction == -1 then --If the direction is -1 (left), draw the NPC to the left
        Graphics.drawImageToSceneWP(smasNPCSystem.createdNPCs[levelID].image, smasNPCSystem.createdNPCs[levelID].x, smasNPCSystem.createdNPCs[levelID].y, 0, 0, smasNPCSystem.createdNPCs[levelID].width, smasNPCSystem.createdNPCs[levelID].height, smasNPCSystem.createdNPCs[levelID].priority)
    elseif smasNPCSystem.createdNPCs[levelID].direction == 1 then --If the direction is 1 (right), draw the NPC to the right
        Graphics.drawImageToSceneWP(smasNPCSystem.createdNPCs[levelID].image, smasNPCSystem.createdNPCs[levelID].x, smasNPCSystem.createdNPCs[levelID].y, 0, smasNPCSystem.createdNPCs[levelID].height, smasNPCSystem.createdNPCs[levelID].width, smasNPCSystem.createdNPCs[levelID].height, smasNPCSystem.createdNPCs[levelID].priority)
    end
end

function smasNPCSystem.onStart()
    if Level.filename() == "SMB1 - W-1, L-1.lvlx" then
        --smasNPCSystem.createNPC{id = 1, image = testNPC2, frameCount = 17, x = player.x, y = player.y - 300, width = 68, height = 54, direction = -1, isFriendly = true, cantMove = true, useVanillaLayers = true, attachToLayer = "Default", movementSpeed = 2, frameSpeed = 3}
    end
end

function smasNPCSystem.onDraw()
    if EventManager.onStartRan then
        for k,v in ipairs(smasNPCSystem.createdNPCs) do
            if smasNPCSystem.createdNPCs[k] ~= nil then --If nothing is nil...
                if smasNPCSystem.createdNPCs[k].usingVanillaLayers then --If we're using the vanilla layer system...
                    local layer = Layer.get(smasNPCSystem.createdNPCs[k].layer) --Get the name of the layer
                    if layer ~= nil then
                        if not layer.isHidden then
                            smasNPCSystem.drawNPC(k)
                        end
                    end
                elseif not smasNPCSystem.createdNPCs[k].usingVanillaLayers then --Elseif using smasLayerSystem, draw the NPC using the new system instead
                    for a,b in ipairs(smasLayerSystem.layers) do
                        if not smasLayerSystem.layerIsHidden[a] then
                            smasNPCSystem.drawNPC(k)
                        end
                    end
                end
                --Message box system!
                for a,b in ipairs(Player.getIntersecting(smasNPCSystem.createdNPCs[k].x, smasNPCSystem.createdNPCs[k].y, smasNPCSystem.createdNPCs[k].x + smasNPCSystem.createdNPCs[k].width, smasNPCSystem.createdNPCs[k].y + smasNPCSystem.createdNPCs[k].height)) do
                    for c,d in ipairs(smasLayerSystem.layers) do
                        if not smasLayerSystem.layerIsHidden[c] then --If not hidden...
                            if smasNPCSystem.createdNPCs[k].message ~= "" then --If the message isn't blank...
                                Graphics.drawImageToSceneWP(messageDialogMark, smasNPCSystem.createdNPCs[k].x + 25, smasNPCSystem.createdNPCs[k].y - 20, smasNPCSystem.messageMarkPriority) --Draw a exclamation mark if the player is nearby
                                if b.keys.up == KEYS_PRESSED and not Misc.isPaused() then --Is the player nearby presses up...
                                    if littleDialogue then
                                        littleDialogue.create({text = smasNPCSystem.createdNPCs[k].message})
                                    else
                                        Text.showMessageBox(smasNPCSystem.createdNPCs[k].message) --Show the message!
                                    end
                                end
                            end
                        end
                    end
                end
                for a,b in ipairs(Block.get(Block.SOLID)) do
                    if Collisionz.EasyModeCollision(smasNPCSystem.createdNPCs[1], b, false) == Collisionz.CollisionSpot.COLLISION_NONE and Collisionz.CheckCollision(smasNPCSystem.createdNPCs[1], b) then
                        smasNPCSystem.createdNPCs[k].speedY = smasNPCSystem.createdNPCs[k].speedY + Defines.npc_grav * 0.05
                    end
                end
            end
        end
    end
end

return smasNPCSystem