local smasMapInventorySystem = {}

local smwMap
pcall(function() smwMap = require("smwMap") end)

local textplus = require("textplus")
local font = textplus.loadFont("textplus/font/1.ini")

--[[

-Items-

1: Mushroom
2: Fire flower
3: Leaf
4: Tanooki Suit
5: Hammer Suit
6: Ice Flower
7: Starman
8: P-Wing
9: Hammer (For destroying rocks)
10: Warp Whistle (For the warp zone on SMB3)


10,566
]]

--Below is used for easily figuring out which is which.
smasMapInventorySystem.itemList = {
    MUSHROOM = 1,
    FIRE_FLOWER = 2,
    SUPER_LEAF = 3,
    TANOOKI_SUIT = 4,
    HAMMER_SUIT = 5,
    ICE_FLOWER = 6,
    STARMAN = 7,
    PWING = 8,
    HAMMER = 9,
    WARP_WHISTLE = 10,
}
smasMapInventorySystem.menuSelectionAt = 1 --For naviagting the menu
smasMapInventorySystem.menuSelectionAtSelector = 10 --For where to draw the selector
smasMapInventorySystem.menuSelectionIsSelected = 0 --For what to show when selecting something
smasMapInventorySystem.minimumPriority = 4 --For drawing things
smasMapInventorySystem.widthOfEachItem = 78

--Images are below.
smasMapInventorySystem.menuImage = Graphics.loadImageResolved("OverworldHUD/Menu-2X.png")
smasMapInventorySystem.menuIconsImage = Graphics.loadImageResolved("OverworldHUD/InvIcons.png")
smasMapInventorySystem.selectorImage = Graphics.loadImageResolved("OverworldHUD/Selector.png")

smasMapInventorySystem.isOpen = false --Is the inventory open?

smasMapInventorySystem.maxItemCount = 99 --The max amount of items to store.
smasMapInventorySystem.numberOfItems = 10 --The number of items that can be stored.

SaveData.SMASPlusPlus.map = SaveData.SMASPlusPlus.map or {}
SaveData.SMASPlusPlus.map.inventory = SaveData.SMASPlusPlus.map.inventory or {}

if SaveData.SMASPlusPlus.map.inventory.canUseStarman == nil then
    SaveData.SMASPlusPlus.map.inventory.canUseStarman = false
end
if SaveData.SMASPlusPlus.map.inventory.canUsePWing == nil then
    SaveData.SMASPlusPlus.map.inventory.canUsePWing = false
end

for i = 1,smasMapInventorySystem.numberOfItems do
    SaveData.SMASPlusPlus.map.inventory.storedItems = SaveData.SMASPlusPlus.map.inventory.storedItems or {}
    SaveData.SMASPlusPlus.map.inventory.storedItems[i] = SaveData.SMASPlusPlus.map.inventory.storedItems[i] or 0
end

local isOnSMWMap = (smwMap ~= nil and Level.filename() == smwMap.levelFilename)

function smasMapInventorySystem.onInitAPI()
    registerEvent(smasMapInventorySystem,"onStart")
    registerEvent(smasMapInventorySystem,"onTick")
    registerEvent(smasMapInventorySystem,"onInputUpdate")    
    registerEvent(smasMapInventorySystem,"onDraw")
    registerEvent(smasMapInventorySystem,"onDrawEnd")
    registerEvent(smasMapInventorySystem,"onExit")
end

function smasMapInventorySystem.onStart()
    if not isOnSMWMap then
        if SaveData.SMASPlusPlus.map.inventory.canUseStarman then
            for _,p in ipairs(Player.get()) do
                NPC.spawn(996, p.x, p.y, p.section)
            end
            SaveData.SMASPlusPlus.map.inventory.canUseStarman = false
        end
    end
end

function smasMapInventorySystem.executeInventoryItem(inventoryItem)
    if inventoryItem == nil then
        error("inventoryItem must have a value!")
        return
    end
    
    for _,p in ipairs(Player.get()) do
        if SaveData.SMASPlusPlus.map.inventory.storedItems[inventoryItem] >= 1 then
            if inventoryItem >= smasMapInventorySystem.itemList.MUSHROOM and inventoryItem <= smasMapInventorySystem.itemList.ICE_FLOWER then
                if not (p.powerup >= 2 and inventoryItem == 1) then
                    p.powerup = inventoryItem + 1
                end
                Sound.playSFX(6)
            end
            if inventoryItem == smasMapInventorySystem.itemList.STARMAN then
                Sound.playSFX(6)
                SaveData.SMASPlusPlus.map.inventory.canUseStarman = true
            end
            if inventoryItem == smasMapInventorySystem.itemList.PWING then
                Sound.playSFX(6)
                SaveData.SMASPlusPlus.map.inventory.canUsePWing = true
            end
            if inventoryItem == smasMapInventorySystem.itemList.HAMMER then
                Sound.playSFX(27)
                smwMap.unlockLockedPath()
            end
            if inventoryItem == smasMapInventorySystem.itemList.WARP_WHISTLE then
                Sound.playSFX(27)
                --Fill this out later
            end
            SaveData.SMASPlusPlus.map.inventory.storedItems[inventoryItem] = SaveData.SMASPlusPlus.map.inventory.storedItems[inventoryItem] - 1
            smasMapInventorySystem.closeInventory()
        else
            Sound.playSFX(152)
        end
    end
    
end

function smasMapInventorySystem.openInventory()
    Misc.pause()
    smasMapInventorySystem.isOpen = true
    if pauseplus then
        pauseplus.canPause = false
    end
    smasMapInventorySystem.menuSelectionAt = 1
    smasMapInventorySystem.menuSelectionAtSelector = 10
    Sound.playSFX("OverworldHUD/Enter.spc")
end

function smasMapInventorySystem.closeInventory()
    Misc.unpause()
    smasMapInventorySystem.isOpen = false
    if pauseplus then
        pauseplus.canPause = true
    end
    smasMapInventorySystem.menuSelectionAt = 1
    smasMapInventorySystem.menuSelectionAtSelector = 10
    Sound.playSFX("OverworldHUD/Exit.spc")
end

function smasMapInventorySystem.onDrawEnd()
    for _,p in ipairs(Player.get()) do
        if isOnSMWMap then
            if smwMap.mainPlayer.state == 0 then
                if p.keys.altRun == KEYS_PRESSED then
                    if not smasMapInventorySystem.isOpen then
                        smasMapInventorySystem.openInventory()
                    elseif smasMapInventorySystem.isOpen then
                        smasMapInventorySystem.closeInventory()
                    end
                end
            end
            if smasMapInventorySystem.isOpen then
                if p.keys.jump == KEYS_PRESSED then
                    smasMapInventorySystem.executeInventoryItem(smasMapInventorySystem.menuSelectionAt)
                end
                if p.keys.left == KEYS_PRESSED then
                    if smasMapInventorySystem.menuSelectionAt > 1 then
                        smasMapInventorySystem.menuSelectionAt = smasMapInventorySystem.menuSelectionAt - 1
                        smasMapInventorySystem.menuSelectionAtSelector = smasMapInventorySystem.menuSelectionAtSelector - 80
                        Sound.playSFX(26)
                    end
                end
                if p.keys.right == KEYS_PRESSED then
                    if smasMapInventorySystem.menuSelectionAt < smasMapInventorySystem.numberOfItems then
                        smasMapInventorySystem.menuSelectionAt = smasMapInventorySystem.menuSelectionAt + 1
                        smasMapInventorySystem.menuSelectionAtSelector = smasMapInventorySystem.menuSelectionAtSelector + 80
                        Sound.playSFX(26)
                    end
                end
            end
        end
    end
end

function smasMapInventorySystem.onDraw()
    for i = 1,smasMapInventorySystem.numberOfItems do
        if SaveData.SMASPlusPlus.map.inventory.storedItems[i] > smasMapInventorySystem.maxItemCount then
            SaveData.SMASPlusPlus.map.inventory.storedItems[i] = 99
        end
    end
    
    if isOnSMWMap then
        if smasMapInventorySystem.isOpen then
            Graphics.drawImageWP(smasMapInventorySystem.menuImage, 0, 548, smasMapInventorySystem.minimumPriority)
            
            for i = 1,smasMapInventorySystem.numberOfItems do
                
                if SaveData.SMASPlusPlus.map.inventory.storedItems[i] > smasMapInventorySystem.maxItemCount then
                    SaveData.SMASPlusPlus.map.inventory.storedItems[i] = 99
                end
                
                if smasMapInventorySystem.menuSelectionAt == i then
                    smasMapInventorySystem.menuSelectionIsSelected = 1
                else
                    smasMapInventorySystem.menuSelectionIsSelected = 0
                end
                
                textplus.print{text=string.format("%02d", SaveData.SMASPlusPlus.map.inventory.storedItems[i]), x = (i - 1) * 50 + smasMapInventorySystem.widthOfEachItem - 68, y = 540, font = font, plaintext = true, priority = smasMapInventorySystem.minimumPriority + .0002}
                
                Graphics.draw{
                    type = RTYPE_IMAGE,
                    image = smasMapInventorySystem.menuIconsImage,
                    x = (i - 1) * 50 + smasMapInventorySystem.widthOfEachItem - 68,
                    y = 556,
                    sourceX = smasMapInventorySystem.menuSelectionIsSelected * 36,
                    sourceY = (i - 1) * 36,
                    sourceWidth = 36,
                    sourceHeight = 36,
                    priority = smasMapInventorySystem.minimumPriority + .0001,
                }
            end
        end
    end
end

function smasMapInventorySystem.addPowerUp(pID, amount)
    SaveData.SMASPlusPlus.map.inventory.storedItems[pID] = SaveData.SMASPlusPlus.map.inventory.storedItems[pID] + amount
end

function smasMapInventorySystem.setPowerUp(pID, number)
    SaveData.SMASPlusPlus.map.inventory.storedItems[pID] = number
end

return smasMapInventorySystem