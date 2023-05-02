--██╗███╗░░██╗██╗░░░██╗███████╗███╗░░██╗████████╗░█████╗░██████╗░██╗░░░██╗
--██║████╗░██║██║░░░██║██╔════╝████╗░██║╚══██╔══╝██╔══██╗██╔══██╗╚██╗░██╔╝
--██║██╔██╗██║╚██╗░██╔╝█████╗░░██╔██╗██║░░░██║░░░██║░░██║██████╔╝░╚████╔╝░
--██║██║╚████║░╚████╔╝░██╔══╝░░██║╚████║░░░██║░░░██║░░██║██╔══██╗░░╚██╔╝░░
--██║██║░╚███║░░╚██╔╝░░███████╗██║░╚███║░░░██║░░░╚█████╔╝██║░░██║░░░██║░░░
--╚═╝╚═╝░░╚══╝░░░╚═╝░░░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░


local inventory = {}

-- Customizable Stuff --
-- This defines with how many items do you want to start --
inventory.startingItems = 0

local particles = require("particles")
local hOverride = require("smasHud")
local shader = Misc.multiResolveFile("starman.frag", "shaders\\npc\\starman.frag")

-- Variables --
local invIsOpen = false
local chooseIsOpen = false
local invBack =  Graphics.loadImageResolved("OverworldHUD/Back.png")
local invIcons =  Graphics.loadImageResolved("OverworldHUD/InvIcons.png")
local invChoose =  Graphics.loadImageResolved("OverworldHUD/Choose.png")
local invChar =  Graphics.loadImageResolved("OverworldHUD/characters.png")
local selector = Graphics.loadImageResolved("OverworldHUD/Selector.png")
local pIcon = Graphics.loadImageResolved("OverworldHUD/p.png")
local isSelected = 0
local bScale = 0
local cScale = 0
local selectedOffset = 0
local selectedPlayer = 1
local ps
local pGet

-- The Sprite Class --
local backSprite = Sprite{
    image = invBack,
    x = 70,
    y = 530,
    align = Sprite.align.BOTTOMLEFT,
}

local chooseSprite = Sprite{
    image = invChoose,
    x = 400,
    y = 382,
    align = Sprite.align.CENTER,
}

-- Textplus Font --
local textplus = require("textplus")
local font = textplus.loadFont("textplus/font/1.ini")

-- The Data Saving --
-- The Item order is: Mushroom, FireFlower, Leaf, Tanooki, Hammer, IceFlower, Starman, PWing --
if SaveData.inventoryTable == nil then
    SaveData.inventoryTable = {}
    for i = 0, 7 do
        SaveData.inventoryTable[i] = inventory.startingItems
    end
end

if SaveData.useStarman == nil then
    SaveData.useStarman = false
end

if SaveData.usePWing == nil then
    SaveData.usePWing = false
end



function inventory.onInitAPI()
    registerEvent(inventory, "onStart")
    if Level.filename() == "map.lvlx" then
        registerEvent(inventory, "onDraw")
        registerEvent(inventory, "onDrawEnd", "onDrawEndWorld")
        registerEvent(inventory, "onInputUpdate", "onInputWorld")
    else
        registerEvent(inventory, "onTick")
        registerEvent(inventory, "onExitLevel")
    end
end


function inventory.onStart()
    pGet = Player.get()

    if Level.filename() ~= "map.lvlx" and SaveData.useStarman then
        NPC.spawn(996, player.x, player.y, player.section)
        if Player.count() >= 2 then
            NPC.spawn(996, player2.x, player2.y, player2.section)
        end
        SaveData.useStarman = false
    end
end


function inventory.onDrawEndWorld()
    -- Opening the Inventory --
    if player.keys.altRun == KEYS_PRESSED then
        if not Misc.isPaused() and not invIsOpen then
            Misc.pause()
            invIsOpen = true
            SFX.play(Misc.resolveFile("OverworldHUD/Enter.spc"))
        else
            Misc.unpause()
            invIsOpen = false
            SFX.play(Misc.resolveFile("OverworldHUD/Exit.spc"))
        end
    end

    if invIsOpen == false then chooseIsOpen = false end
end


function inventory.onDraw()
    -- Animation --
    if invIsOpen then
        if bScale < 1 then bScale = bScale + 0.1 end
    else
        if bScale > 0 then bScale = bScale - 0.1 end
    end

    if chooseIsOpen then
        if cScale < 1 then cScale = cScale + 0.1 end
    else
        if cScale > 0 then cScale = cScale - 0.1 end
    end

    -- Lets cap the scale --
    if bScale < 0 then bScale = 0 end
    if bScale > 1 then bScale = 1 end

    if cScale < 0 then cScale = 0 end
    if cScale > 1 then cScale = 1 end

    -- Scaling the sprites --
    if bScale > 0 then
        backSprite:draw{priority = -1.7}
        backSprite.transform.scale = vector(1, bScale)
    end

    if cScale > 0 then
        chooseSprite:draw{priority = -1.4}
        chooseSprite.transform.scale = vector(cScale, cScale)
    end

    -- Drawing the Item Icons --
    if bScale >= 1 then
        for i = 0, 7, 1 do
            if selectedOffset == i then
                isSelected = 1
            else
                isSelected = 0
            end
            textplus.print{text=string.format("%02d", SaveData.inventoryTable[i]), x=i*82+94, y=452, font=font, plaintext=true, priority=-1.6}
            Graphics.draw{
                type = RTYPE_IMAGE,
                image = invIcons,
                x = i * 82 + 94,
                y = 478,
                sourceY = i * 36,
                sourceHeight = 36,
                sourceX = isSelected * 36,
                sourceWidth = 36,
                priority = -1.4
            }
        end
    end

    if cScale == 1 then
        Graphics.draw{
            type = RTYPE_IMAGE,
            image = invChar,
            x = 330,
            y = 320,
            sourceX = tonumber(player.character - 1) * 40,
            sourceWidth = 40,
            priority = -1.5
        }
        if Player.count() >= 2 then
            Graphics.draw{
                type = RTYPE_IMAGE,
                image = invChar,
                x = 430,
                y = 320,
                sourceX = tonumber(player2.character - 1) * 40,
                sourceWidth = 40,
                priority = -1.5
            }
        end
        Text.printWP("Choose a", 330, 278, 5.3)
        Text.printWP("Player", 346, 298, 5.3)

        Graphics.draw{
            type = RTYPE_IMAGE,
            image = selector,
            x = 100 * (selectedPlayer - 1) + 316,
            y = 350,
            priority = -1.6
        }
    end

    if(type(shader) == "string") then
        local s = Shader()
        s:compileFromFile(nil, shader)
        shader = s
    end

    if SaveData.usePWing then
        Graphics.draw{type=RTYPE_IMAGE, image=pIcon, x=84, y=96, priority = -1.2}
    end
end


function inventory.onInputWorld()
    -- Lets disable character changing --
    if Misc.isPaused and invIsOpen then
        player.keys.left = false
        player.keys.right = false
    end

    -- Moving through the menu --
    if invIsOpen then
        if chooseIsOpen then
            if player.rawKeys.left == KEYS_PRESSED and selectedPlayer > 1 then
                selectedPlayer = selectedPlayer - 1
                SFX.play(29)
            elseif player.rawKeys.right == KEYS_PRESSED and selectedPlayer < 2 then
                selectedPlayer = selectedPlayer + 1
                SFX.play(29)
            end
        else
            if player.rawKeys.left == KEYS_PRESSED and selectedOffset > 0 then
                selectedOffset = selectedOffset - 1
                SFX.play(29)
            elseif player.rawKeys.right == KEYS_PRESSED and selectedOffset < 7 then
                selectedOffset = selectedOffset + 1
                SFX.play(29)
            end
        end
        -- Adding PowerUps! --
        if player.keys.jump == KEYS_PRESSED then
            if SaveData.inventoryTable[selectedOffset] > 0 then
                if selectedOffset < 6 then
                    if Player.count() >= 2 then
                        chooseIsOpen = true
                        SFX.play(29)
                        if cScale >= 1 then
                            if pGet[selectedPlayer].powerup == selectedOffset + 2 or pGet[selectedPlayer].powerup >= 2 and selectedOffset == 0 then SFX.play(3) return end
                            pGet[selectedPlayer].powerup = selectedOffset + 2
                            ps = PlayerSettings.get(pGet[selectedPlayer].character, selectedOffset + 2)
                            pGet[selectedPlayer].height = ps.hitboxHeight
                            SFX.play(6)
                            SaveData.inventoryTable[selectedOffset] = SaveData.inventoryTable[selectedOffset] - 1
                            chooseIsOpen = false
                        end
                    else
                        if player.powerup == selectedOffset + 2 or player.powerup >= 2 and selectedOffset == 0 then SFX.play(3) return end
                        player.powerup = selectedOffset + 2
                        ps = PlayerSettings.get(player.character, selectedOffset + 2)
                        player.height = ps.hitboxHeight
                        SFX.play(6)
                        SaveData.inventoryTable[selectedOffset] = SaveData.inventoryTable[selectedOffset] - 1
                    end
                elseif selectedOffset == 6 and not SaveData.useStarman then
                    SaveData.useStarman = true
                    SFX.play(6)
                    SaveData.inventoryTable[6] = SaveData.inventoryTable[6] - 1
                elseif selectedOffset == 7 and not SaveData.usePWing then
                    SaveData.usePWing = true
                    player.powerup = 4
                    ps = PlayerSettings.get(player.character, 4)
                    player.height = ps.hitboxHeight

                    if Player.count() >= 2 then
                        player2.powerup = 4
                        ps = PlayerSettings.get(player2.character, 4)
                        player2.height = ps.hitboxHeight
                    end
                    
                    SFX.play(6)
                    SaveData.inventoryTable[7] = SaveData.inventoryTable[7] - 1
                end
            else
                SFX.play(3)
            end
        end
    end    
end


function inventory.onTick()
    if SaveData.usePWing then
        player:mem(0x168, FIELD_FLOAT, 40)
        player:mem(0x170, FIELD_WORD, 100)
    end

    if Player.count() >= 2 then
        if player.powerup ~= 4 then
            SaveData.usePWing = false
        end
    end
end

function inventory.onExitLevel()
    SaveData.usePWing = false
    SaveData.useStarman = false
end


-- Utilizable functions --
-- This one adds Items to the inventory, select which item you want to add and the amount --
function inventory.addPowerUp(pID, amount)
    SaveData.inventoryTable[pID] = SaveData.inventoryTable[pID] + amount
end

-- This one sets the amount of Items that you have, select which item do you want to set and the number --
function inventory.setPowerUp(pID, number)
    SaveData.inventoryTable[pID] = number
end

return inventory