--smasNPCSystem.lua
--By Spencer Everly

--[[
    NPC option number values:

    1 = Image of the NPC
    2 = Frame count of the NPC
    3 = X position, used via scene coordinates
    4 = Y position, used via scene coordinates
    5 = Width of the NPC
    6 = Height of the NPC
    7 = The direction the NPC is facing
    8 = The message the NPC is using
    9 = Whether the NPC is friendly or not
    10 = Whether the NPC doesn't move
    11 = If this is using the vanilla layer system or not, if false this uses the smasLayerSystem library
    12 = The layer the NPC is attached to
    13 = The movement speed the NPC takes
    14 = The priority to draw the NPC on
    15 = The speedX of the NPC
    16 = the speedY of the NPC
    17 = The frame speed of the NPC
]]

local smasNPCSystem = {}

local littleDialogue
pcall(function() littleDialogue = require("littleDialogue") end)

smasNPCSystem.createdNPCs = {}

local testNPC = Graphics.loadImageResolved("MALC - HUB/npc-466.png")
local testNPC2 = Graphics.loadImageResolved("npc-946.png")
local messageDialogMark = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-43.png")

local solidBlocks = Block.SOLID_MAP
local semiSolidBlocks = Block.SEMISOLID_MAP
local sizableBlocks = Block.SIZEABLE_MAP

local getMT = {__pairs = ipairs}

function smasNPCSystem.onInitAPI()
    registerEvent(smasNPCSystem,"onStart")
    registerEvent(smasNPCSystem,"onTick")
    registerEvent(smasNPCSystem,"onDraw")
end

function smasNPCSystem.countNPCs()
    local finalvalue = 0
    for k,v in ipairs(smasNPCSystem.createdNPCs) do
        finalvalue = finalvalue + k
    end
    return finalvalue
end

function smasNPCSystem.getIntersecting(x1, y1, x2, y2)
    if (type(x1) ~= "number") or (type(y1) ~= "number") or (type(x2) ~= "number") or (type(y2) ~= "number") then
        error("Invalid parameters to getIntersecting")
    end
    
    local ret = {}
    
    for idx = 0, smasNPCSystem.countNPCs()-1 do
        local bx = smasNPCSystem.createdNPCs[idx][3]
        if (x2 > bx) then
            local by = smasNPCSystem.createdNPCs[idx][4]
            if (y2 > by) then
                local bw = smasNPCSystem.createdNPCs[idx][5]
                if (bx + bw > x1) then
                    local bh = smasNPCSystem.createdNPCs[idx][6]
                    if (by + bh > y1) then
                        ret[#ret+1] = NPC(idx)
                    end
                end
            end
        end
    end
    
    setmetatable(ret, getMT)    
    return ret
end

function smasNPCSystem.createNPC(args)
    if args.image == nil then
        error("You must specify an image for this Lua NPC!")
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
    if (type(args.messageToSpeak) ~= "string") then
        error("The message must be a string!")
        return
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
    
    table.insert(smasNPCSystem.createdNPCs, {args.image, args.frameCount, args.x, args.y, args.width, args.height, args.direction, args.messageToSpeak, args.isFriendly, args.cantMove, args.useVanillaLayers, args.attachToLayer, args.movementSpeed, args.priority, args.speedX, args.speedY, args.frameSpeed})
end

function smasNPCSystem.drawNPC(id)
    if id == nil then
        error("NPC ID must be specified!")
        return
    end
    
    
    
    if smasNPCSystem.createdNPCs[id][7] == -1 then --If the direction is -1 (left), draw the NPC to the left
        Graphics.drawImageToSceneWP(smasNPCSystem.createdNPCs[id][1], smasNPCSystem.createdNPCs[id][3], smasNPCSystem.createdNPCs[id][4], 0, 0, smasNPCSystem.createdNPCs[id][5], smasNPCSystem.createdNPCs[id][6], smasNPCSystem.createdNPCs[id][14])
    elseif smasNPCSystem.createdNPCs[id][7] == 1 then --If the direction is 1 (right), draw the NPC to the right
        Graphics.drawImageToSceneWP(smasNPCSystem.createdNPCs[id][1], smasNPCSystem.createdNPCs[id][3], smasNPCSystem.createdNPCs[id][4], 0, smasNPCSystem.createdNPCs[id][6], smasNPCSystem.createdNPCs[id][5], smasNPCSystem.createdNPCs[id][6], smasNPCSystem.createdNPCs[id][14])
    end
end

function smasNPCSystem.onStart()
    if Level.filename() == "MALC - HUB.lvlx" then
        --smasNPCSystem.createNPC{image = testNPC2, frameCount = 17, x = -200752, y = -200128, width = 68, height = 54, direction = -1, messageToSpeak = "Test", isFriendly = true, cantMove = true, useVanillaLayers = false, attachToLayer = "Default", movementSpeed = 2, frameSpeed = 3}
    end
end

function smasNPCSystem.onDraw()
    if EventManager.onStartRan then
        if Level.filename() == "MALC - HUB.lvlx" then
            --Text.printWP(Npc.frameNPC[1], 100, 100, 0)
        end
        for k,v in ipairs(smasNPCSystem.createdNPCs) do
            if smasNPCSystem.createdNPCs[k] ~= nil then --If nothing is nil...
                if smasNPCSystem.createdNPCs[k][11] then --If we're using the vanilla layer system...
                    local layer = Layer.get(smasNPCSystem.createdNPCs[k][12]) --Get the name of the layer
                    if layer ~= nil then
                        if not layer.isHidden then
                            smasNPCSystem.drawNPC(k)
                        end
                    end
                elseif not smasNPCSystem.createdNPCs[k][11] then --Elseif using smasLayerSystem, draw the NPC using the new system instead
                    for a,b in ipairs(smasLayerSystem.layers) do
                        if not smasLayerSystem.layerIsHidden[a] then
                            smasNPCSystem.drawNPC(k)
                        end
                    end
                end
                --Message box system!
                for a,b in ipairs(Player.getIntersecting(smasNPCSystem.createdNPCs[k][3], smasNPCSystem.createdNPCs[k][4], smasNPCSystem.createdNPCs[k][3] + smasNPCSystem.createdNPCs[k][5], smasNPCSystem.createdNPCs[k][4] + smasNPCSystem.createdNPCs[k][6])) do
                    for c,d in ipairs(smasLayerSystem.layers) do
                        if not smasLayerSystem.layerIsHidden[c] then --If not hidden...
                            if smasNPCSystem.createdNPCs[k][8] ~= "" then --If the message isn't blank...
                                Graphics.drawImageToSceneWP(messageDialogMark, smasNPCSystem.createdNPCs[k][3] + 25, smasNPCSystem.createdNPCs[k][4] - 20, -40) --Draw a exclamation mark if the player is nearby
                                if b.keys.up == KEYS_PRESSED and not Misc.isPaused() then --Is the player nearby presses up...
                                    if littleDialogue then
                                        littleDialogue.create({text = smasNPCSystem.createdNPCs[k][8]})
                                    else
                                        Text.showMessageBox(smasNPCSystem.createdNPCs[k][8]) --Show the message!
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

return smasNPCSystem