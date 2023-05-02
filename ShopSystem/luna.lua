-- Loading Libraries --
local anothercurrency = require("anothercurrency")
local ShopSystem = require("ShopSystem")
local textplus = require("textplus")
local hudoverride = require("hudoverride")

-- Images --
local shopItems = Graphics.loadImageResolved("ShopSystem/ShopSystem/shopItems.png")
local coinsIcon = Graphics.loadImageResolved("ShopSystem/ShopSystem/coinImage.png")

-- anothercurrency stuff --
coinCounter = anothercurrency.registerCurrency("coins", false)
coinCounter:registerLimit(9999, function() end)

-- shopsystem stuff --
local myShop = ShopSystem.create{music = "ShopSystem/34 Buy Somethin' Will Ya!.ogg"}
local miscShop = ShopSystem.create{music = "ShopSystem/34 Buy Somethin' Will Ya!.ogg"}
local bootShop = ShopSystem.create{music = ""}
local animalShop = ShopSystem.create{}

local mushroom = myShop:RegisterItem{NPCid =   9, inEgg = true, image = shopItems, price = 10,  amount = 5, name = "Mushroom", sourceX = 0, sourceY = 0, sourceWidth = 32, sourceHeight = 32, currency = coinCounter}
local fire =     myShop:RegisterItem{NPCid =  14, image = shopItems, price = 20,  amount = 5, name = "Fire Flower", description = "A burning flower!?", sourceX = 0, sourceY = 32, sourceWidth = 32, sourceHeight = 32, currency = coinCounter}
local leaf =     myShop:RegisterItem{NPCid =  34, image = shopItems, price = 30,  amount = 5, name = "Leaf", sourceX = 0, sourceY = 64, sourceWidth = 32, sourceHeight = 32, currency = coinCounter, description = "<wave 2>something seems strange about this leaf...</wave>"}
local tanooki =  myShop:RegisterItem{NPCid = 169, image = shopItems, price = 50,  amount = 5, name = "Tanooki Suit", sourceX = 0, sourceY = 96, sourceWidth = 32, sourceHeight = 32, currency = coinCounter, description = "tanookieeeeeeeeeeee"}
local hammer =   myShop:RegisterItem{NPCid = 170, inEgg = true, image = shopItems, price = 50,  amount = 5, name = "Hammer Suit", sourceX = 0, sourceY = 128, sourceWidth = 32, sourceHeight = 32, currency = coinCounter, description = "No one stands a chance if you wear this suit."}
local ice =      myShop:RegisterItem{NPCid = 264, useReserve = true, image = shopItems, closeAfterPurchase = true, price = 30,  amount = 5, name = "Ice Flower", sourceX = 0, sourceY = 160, sourceWidth = 32, sourceHeight = 32, currency = coinCounter, description = "It's so cold!!"}

mushroom.description = "<tremble 2>Mmm.. a tasty mushroom!</tremble>"

local item1 = miscShop:RegisterItem{NPCid = 1, price = 10,  amount = 5, currency = coinCounter, useReserve = true}
local item2 = miscShop:RegisterItem{NPCid = 2, price = 20,  amount = 5, currency = coinCounter, useReserve = true}
local item3 = miscShop:RegisterItem{NPCid = 3, price = 30,  amount = 5, currency = coinCounter, useReserve = true}
local item4 = miscShop:RegisterItem{NPCid = 4, price = 50,  amount = 5, currency = coinCounter, useReserve = true}
local item5 = miscShop:RegisterItem{NPCid = 5, price = 50,  amount = 5, currency = coinCounter, useReserve = true}
local item6 = miscShop:RegisterItem{NPCid = 6, price = 30,  amount = 5, currency = coinCounter, useReserve = true}
local item7 = miscShop:RegisterItem{NPCid = 7, price = 10,  amount = 5, currency = coinCounter, useReserve = true}
local item8 = miscShop:RegisterItem{NPCid = 8, price = 20,  amount = 5, currency = coinCounter, useReserve = true}
local item9 = miscShop:RegisterItem{NPCid = 9, price = 30,  amount = 5, currency = coinCounter, useReserve = true}
local item10 = miscShop:RegisterItem{NPCid = 10, price = 50,  amount = 5, currency = coinCounter}
local item11 = miscShop:RegisterItem{NPCid = 11, price = 50,  amount = 5, currency = coinCounter}
local item12 = miscShop:RegisterItem{NPCid = 12, price = 30,  amount = 5, currency = coinCounter}
local item13 = miscShop:RegisterItem{NPCid = 13, price = 10,  amount = 5, currency = coinCounter}
local item14 = miscShop:RegisterItem{NPCid = 14, price = 20,  amount = 5, currency = coinCounter}
local item15 = miscShop:RegisterItem{NPCid = 15, price = 30,  amount = 5, currency = coinCounter}
local item16 = miscShop:RegisterItem{NPCid = 16, price = 50,  amount = 5, currency = coinCounter}
local item17 = miscShop:RegisterItem{NPCid = 17, price = 50,  amount = 5, currency = coinCounter}
local item18 = miscShop:RegisterItem{NPCid = 50, price = 30,  amount = 5, currency = coinCounter}
local item19 = miscShop:RegisterItem{NPCid = 19, price = 50,  amount = 5, currency = coinCounter}
local item20 = miscShop:RegisterItem{NPCid = 21, price = 50,  amount = 5, currency = coinCounter}
local item21 = miscShop:RegisterItem{NPCid = 22, price = 30,  amount = 5, currency = coinCounter}
local item22 = miscShop:RegisterItem{NPCid = 23, price = 10,  amount = 5, currency = coinCounter}
local item23 = miscShop:RegisterItem{NPCid = 24, price = 20,  amount = 5, currency = coinCounter}
local item24 = miscShop:RegisterItem{NPCid = 25, price = 30,  amount = 5, currency = coinCounter}
local item25 = miscShop:RegisterItem{NPCid = 26, price = 50,  amount = 5, currency = coinCounter}
local item26 = miscShop:RegisterItem{NPCid = 27, price = 50,  amount = 5, currency = coinCounter}
local item27 = miscShop:RegisterItem{NPCid = 28, price = 30,  amount = 5, currency = coinCounter}
local item28 = miscShop:RegisterItem{NPCid = 31, price = 50,  amount = 5, currency = coinCounter}
local item29 = miscShop:RegisterItem{NPCid = 32, price = 30,  amount = 5, currency = coinCounter}
local item30 = miscShop:RegisterItem{NPCid = 33, price = 10,  amount = 5, currency = coinCounter}
local item31 = miscShop:RegisterItem{NPCid = 34, price = 20,  amount = 5, currency = coinCounter}
local item32 = miscShop:RegisterItem{NPCid = 35, price = 30,  amount = 5, currency = coinCounter}
local item33 = miscShop:RegisterItem{NPCid = 36, price = 50,  amount = 5, currency = coinCounter}
local item34 = miscShop:RegisterItem{NPCid = 37, price = 50,  amount = 5, currency = coinCounter}
local item35 = miscShop:RegisterItem{NPCid = 38, price = 30,  amount = 5, currency = coinCounter}
local item36 = miscShop:RegisterItem{NPCid = 41, price = 50,  amount = 5, currency = coinCounter}
local item37 = miscShop:RegisterItem{NPCid = 42, price = 30,  amount = 5, currency = coinCounter}
local item38 = miscShop:RegisterItem{NPCid = 43, price = 10,  amount = 5, currency = coinCounter}
local item39 = miscShop:RegisterItem{NPCid = 44, price = 20,  amount = 5, currency = coinCounter}
local item40 = miscShop:RegisterItem{NPCid = 45, price = 30,  amount = 5, currency = coinCounter}
local item41 = miscShop:RegisterItem{NPCid = 46, price = 50,  amount = 5, currency = coinCounter}
local item42 = miscShop:RegisterItem{NPCid = 47, price = 50,  amount = 5, currency = coinCounter}
local item43 = miscShop:RegisterItem{NPCid = 48, price = 30,  amount = 5, currency = coinCounter}
local item44 = miscShop:RegisterItem{NPCid = 51, price = 50,  amount = 5, currency = coinCounter}
local item45 = miscShop:RegisterItem{NPCid = 52, price = 30,  amount = 5, currency = coinCounter}
local item46 = miscShop:RegisterItem{NPCid = 53, price = 10,  amount = 5, currency = coinCounter}
local item47 = miscShop:RegisterItem{NPCid = 54, price = 20,  amount = 5, currency = coinCounter}
local item48 = miscShop:RegisterItem{NPCid = 55, price = 30,  amount = 5, currency = coinCounter}
local item49 = miscShop:RegisterItem{NPCid = 56, price = 50,  amount = 5, currency = coinCounter}
local item50 = miscShop:RegisterItem{NPCid = 57, price = 50,  amount = 5, currency = coinCounter}
local item51 = miscShop:RegisterItem{NPCid = 58, price = 30,  amount = 5, currency = coinCounter}

local item52 = bootShop:RegisterItem{NPCid =  35, price = 50,  amount = 5, currency = coinCounter}
local item53 = bootShop:RegisterItem{NPCid = 191, price = 50,  amount = 5, currency = coinCounter}
local item54 = bootShop:RegisterItem{NPCid = 193, price = 30,  amount = 5, currency = coinCounter}

local item55 = animalShop:RegisterItem{NPCid =  95, price = 50,  amount = 5, currency = coinCounter}
local item56 = animalShop:RegisterItem{NPCid =  98, price = 30,  amount = 5, currency = coinCounter}
local item57 = animalShop:RegisterItem{NPCid =  99, price = 10,  amount = 5, currency = coinCounter}
local item58 = animalShop:RegisterItem{NPCid = 100, price = 20,  amount = 5, currency = coinCounter}
local item59 = animalShop:RegisterItem{NPCid = 148, price = 30,  amount = 5, currency = coinCounter}
local item60 = animalShop:RegisterItem{NPCid = 149, price = 50,  amount = 5, currency = coinCounter}
local item61 = animalShop:RegisterItem{NPCid = 150, price = 50,  amount = 5, currency = coinCounter}
local item62 = animalShop:RegisterItem{NPCid = 228, price = 30,  amount = 5, currency = coinCounter}


local function newHUD()
    hudoverride.offsets.coins.value.y = -50 -- move the coin counter's position up by 50 pixels so that it is offscreen and not visible
    Text.printWP(string.format("%04d",coinCounter:getMoney()),1,538,27,5) -- print the new coin counter
end
Graphics.addHUDElement(newHUD) -- register our render function in the default hud


function onDraw()
    if ShopSystem.activeShop.id ~= nil then -- detect if ANY shop is currently open
        Graphics.drawBox{texture = coinsIcon, x = ShopSystem.movement.sidePanels.position + 22, y = 292, priority = ShopSystem.leastPriority + 0.65}
        textplus.print{x = ShopSystem.movement.sidePanels.position + 58, y = 300, text = string.format("%04d", coinCounter:getMoney()), font = ShopSystem.font, priority = ShopSystem.leastPriority + 0.65}
    end
end

function onEvent(eventName)
    if eventName == "test1" then
        myShop:open()
    elseif eventName == "test2" then
        miscShop:open()
    elseif eventName == "test3" then
        bootShop:open()
    elseif eventName == "test4" then
        animalShop:open()
    end
end