local smasnpcsystem = {}

smasnpcsystem.createdNPCs = {}

local testNPC = Graphics.loadImageResolved("MALC - HUB/npc-466.png")
local messageDialogMark = Graphics.loadImageResolved("graphics/hardcoded/hardcoded-43.png")

local solidBlocks = Block.SOLID_MAP
local semiSolidBlocks = Block.SEMISOLID_MAP
local sizableBlocks = Block.SIZEABLE_MAP

function smasnpcsystem.onInitAPI()
    registerEvent(smasnpcsystem,"onStart")
    registerEvent(smasnpcsystem,"onTick")
    registerEvent(smasnpcsystem,"onDraw")
end

function smasnpcsystem.createNPC(args)
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
        args.movementSpeed = 1
    end
    if args.priority == nil then
        args.priority = -45
    end
    
    table.insert(smasnpcsystem.createdNPCs, {args.image, args.frameCount, args.x, args.y, args.width, args.height, args.direction, args.messageToSpeak, args.isFriendly, args.cantMove, args.useVanillaLayers, args.attachToLayer, args.movementSpeed, args.priority})
end

function smasnpcsystem.drawNPC(id, isVisible)
    if id == nil then
        error("NPC ID must be specified!")
        return
    end
    if isVisible == nil then
        isVisible = true
    end
    
    
    
    if isVisible then
        if smasnpcsystem.createdNPCs[id][7] == -1 then
            Graphics.drawImageToSceneWP(smasnpcsystem.createdNPCs[id][1], smasnpcsystem.createdNPCs[id][3], smasnpcsystem.createdNPCs[id][4], 0, 0, smasnpcsystem.createdNPCs[id][5], smasnpcsystem.createdNPCs[id][6], smasnpcsystem.createdNPCs[id][14])
        elseif smasnpcsystem.createdNPCs[id][7] == 1 then
            Graphics.drawImageToSceneWP(smasnpcsystem.createdNPCs[id][1], smasnpcsystem.createdNPCs[id][3], smasnpcsystem.createdNPCs[id][4], 0, smasnpcsystem.createdNPCs[id][6], smasnpcsystem.createdNPCs[id][5], smasnpcsystem.createdNPCs[id][6], smasnpcsystem.createdNPCs[id][14])
        end
    end
end

function smasnpcsystem.onStart()
    if Level.filename() == "MALC - HUB.lvlx" then
        --smasnpcsystem.createNPC{image = testNPC, frameCount = 1, x = -200752, y = -200128, width = 64, height = 64, direction = 1, messageToSpeak = "Test", isFriendly = true, cantMove = true, useVanillaLayers = false, attachToLayer = "Default", movementSpeed = 2}
    end
end

function smasnpcsystem.onDraw()
    for k,v in ipairs(smasnpcsystem.createdNPCs) do
        if smasnpcsystem.createdNPCs[k] ~= nil then --If nothing is nil...
            if smasnpcsystem.createdNPCs[k][11] then --If we're using the vanilla layer system...
                local layer = Layer.get(smasnpcsystem.createdNPCs[k][12]) --Get the name of the layer
                if layer ~= nil then
                    if layer.isHidden then
                        smasnpcsystem.drawNPC(k, false)
                    elseif not layer.isHidden then
                        smasnpcsystem.drawNPC(k, true)
                    end
                end
            elseif not smasnpcsystem.createdNPCs[k][11] then --Elseif using smaslayersystem, draw the NPC using the new system instead
                for a,b in ipairs(smaslayersystem.layers) do
                    if smaslayersystem.layerIsHidden[a] then
                        smasnpcsystem.drawNPC(k, false)
                    elseif not smaslayersystem.layerIsHidden[a] then
                        smasnpcsystem.drawNPC(k, true)
                    end
                end
            end
            for a,b in ipairs(Player.getIntersecting(smasnpcsystem.createdNPCs[k][3], smasnpcsystem.createdNPCs[k][4], smasnpcsystem.createdNPCs[k][3] + smasnpcsystem.createdNPCs[k][5], smasnpcsystem.createdNPCs[k][4] + smasnpcsystem.createdNPCs[k][6])) do --Message box system!
                for c,d in ipairs(smaslayersystem.layers) do
                    if not smaslayersystem.layerIsHidden[c] then --If not hidden...
                        if smasnpcsystem.createdNPCs[k][8] ~= "" then --If the message isn't blank...
                            Graphics.drawImageToSceneWP(messageDialogMark, smasnpcsystem.createdNPCs[k][3] + 25, smasnpcsystem.createdNPCs[k][4] - 20, -40) --Draw a exclaimation mark if the player is nearby
                            if b.keys.up == KEYS_PRESSED and not Misc.isPaused() then --Is the player nearby presses up...
                                Text.showMessageBox(smasnpcsystem.createdNPCs[k][8]) --Show the message!
                            end
                        end
                    end
                end
            end
        end
    end
end

return smasnpcsystem