--[[
    By Marioman2007

    Version - 1.0

    Credits to Enjl too as this script is based on anothercurrency.lua:
    https://www.supermariobrosx.org/forums/viewtopic.php?t=24798

    Special thanks to -
        Rednaxela for helping me to add support for multiple shops!
        Enjl for giving lots of useful feedbacks!


    Documentation: 
]]

local ShopSystem = {}
local shops = {}
local Shop = {}
local ShopMT = {__index = Shop}

local textplus = require("textplus") -- :))))))))

ShopSystem.font = textplus.loadFont("ShopSystem/shopFont.ini")
ShopSystem.leastPriority = 7 -- least priority of the shop, the shop will be drawn at priority between (ShopSystem.leastPriority) and (ShopSystem.leastPriority + 0.9)
ShopSystem.selectrFrames = 4 -- frames of the selector
ShopSystem.selectrFrSpeed = 5.8 -- framespeed of the selector
ShopSystem.dialogueActive = 0 -- 1 - item out of stock, 2 - not enough coins, 3 - confirmation

-- movement related
-- type 0 = not moving
-- type 1 = moving inwards
-- type 2 = moving outwards
ShopSystem.movement = {}
ShopSystem.movement.title          = {type = 0, position = -34,  goal = 0  , speed = 1}
ShopSystem.movement.itemsTab       = {type = 0, position = -592, goal = 12 , speed = 15}
ShopSystem.movement.sidePanels     = {type = 0, position = 800,  goal = 604, speed = 5}
ShopSystem.movement.descriptionBox = {type = 0, position = 600,  goal = 526, speed = 2}

-- table for the currently active shop
ShopSystem.activeShop = {}


-- Image table
ShopSystem.Image = {
    powerups  = Graphics.loadImageResolved("ShopSystem/ShopSystem/playerPowerups.png"),
    selector  = Graphics.loadImageResolved("ShopSystem/ShopSystem/selector.png"),
    selector2 = Graphics.loadImageResolved("ShopSystem/ShopSystem/selector2.png"),
    shopMenus = Graphics.loadImageResolved("ShopSystem/ShopSystem/shopMain.png"),
    shopBox   = Graphics.loadImageResolved("ShopSystem/ShopSystem/box.png"),
    msgBox    = Graphics.loadImageResolved("ShopSystem/ShopSystem/msgBox.png"),
    options   = Graphics.loadImageResolved("ShopSystem/ShopSystem/options.png"),
    arrows    = Graphics.loadImageResolved("ShopSystem/ShopSystem/arrows.png"),
    rIcon     = Graphics.loadImageResolved("ShopSystem/ShopSystem/reserve.png"),
    defaultCIcon = Graphics.loadImageResolved("ShopSystem/ShopSystem/coinImage.png")
}


-- SFX table
ShopSystem.SFX = {
    choose = {id = SFX.open(Misc.resolveSoundFile("ShopSystem/SFX/shop_cursor")),  volume = 0.6},
    buy    = {id = SFX.open(Misc.resolveSoundFile("ShopSystem/SFX/shop_buy")),  volume = 1},
    fail   = {id = SFX.open(Misc.resolveSoundFile("ShopSystem/SFX/shop_fail")), volume = 0.3},
    select = {id = SFX.open(Misc.resolveSoundFile("ShopSystem/SFX/shop_select")), volume = 0.7},
    dialogue = {id = SFX.open(Misc.resolveSoundFile("ShopSystem/SFX/shop_dialogue")),  volume = 0.8}
}


-- Background related
local bgTexture = Graphics.loadImageResolved("ShopSystem/ShopSystem/texture.png")
local bgTX = 0
local bgTY = 0
local bgTopacity = 0
local opacityFadeType = 0 -- 0 = not fading, 1 = fading in and 2 = fading out

-- make the names of the tables short, or face the headache
local mov = ShopSystem.movement
local actShop = ShopSystem.activeShop
local shopImage = ShopSystem.Image
local shopSFX = ShopSystem.SFX

-- other
local selectorFrames = 0
local movementOver = false
local desX = 800
local dialogSel = 1
local canPress = false

local pressDelay = 13
local pressDelayTimer = 0
local pressed = false
local roomcalc = 0
local finalRoom = -1
local arrowMovement = 0
local arrowMovementOffset = 5
local goUp = true

local prevMusic


local priorityStuff = {}
priorityStuff.BgTexture    = ShopSystem.leastPriority
priorityStuff.tabs         = ShopSystem.leastPriority + 0.5
priorityStuff.box          = ShopSystem.leastPriority + 0.6
priorityStuff.items        = ShopSystem.leastPriority + 0.65
priorityStuff.text         = ShopSystem.leastPriority + 0.66
priorityStuff.arrows       = ShopSystem.leastPriority + 0.67
priorityStuff.selectr      = ShopSystem.leastPriority + 0.77
priorityStuff.dark         = ShopSystem.leastPriority + 0.8777777
priorityStuff.dialg        = ShopSystem.leastPriority + 0.8888888
priorityStuff.dialgOptions = ShopSystem.leastPriority + 0.8999999
priorityStuff.dialgslctr   = ShopSystem.leastPriority + 0.9


function ShopSystem.dialogue(shopItem)
    if (actShop.selection == shopItem.id) then
        if shopItem.currency:compareMoney(shopItem.price) then
            if (shopItem.amount ~= 0) and (shopItem.usesLeft ~= 0) then
                ShopSystem.dialogueActive = 3
                
                if shopSFX.select ~= nil then
                    SFX.play(shopSFX.select.id, shopSFX.select.volume)
                end
            elseif shopItem.amount == 0 or (shopItem.usesLeft == 0) then
                ShopSystem.dialogueActive = 1

                if shopSFX.fail ~= nil then
                    SFX.play(shopSFX.fail.id, shopSFX.fail.volume)
                end
            end
        else
            ShopSystem.dialogueActive = 2
            
            if shopSFX.fail ~= nil then
                SFX.play(shopSFX.fail.id, shopSFX.fail.volume)
            end
        end
    end
end


function ShopSystem.costStuff(shopItem)
    shopItem.currency:addMoney(-shopItem.price)

    if shopItem.amount ~= -1 and shopItem.amount ~= 0 then
        if shopItem.usesLeft ~= 0 then
            shopItem.usesLeft = shopItem.usesLeft - 1
        end
    end

    shopItem:jumpKeyPressed()
end


function ShopSystem.jumpKeyPressed(shopItem)
    local itemX = player.x + (player.width / 2)
    local itemY = player.y + (player.height / 2) - player.height
    local spawnItem = true
    
    if (actShop.selection == shopItem.id) then
        if shopSFX.buy ~= nil then
            SFX.play(shopSFX.buy.id, shopSFX.buy.volume)
        end

        if not shopItem.useReserve or (Graphics.getHUDType(player.character) == Graphics.HUD_HEARTS) then
            spawnItem = true
        elseif shopItem.useReserve and (Graphics.getHUDType(player.character) == Graphics.HUD_ITEMBOX) then
            spawnItem = false
        end

        if shopItem.NPCid > 0 then
            if spawnItem then
                if not shopItem.inEgg then
                    local mushrooms = table.map{9, 184, 185, 153, 249, 273, 425, 186, 187, 90}

                    local n = NPC.spawn(shopItem.NPCid, itemX, itemY, player.section, false, true)
                    n.speedX = 0
                    n.speedY = -9

                    if mushrooms[shopItem.NPCid] then
                        n.dontMove = true
                    end
                elseif shopItem.inEgg then
                    local egg = NPC.spawn(96, itemX, itemY, player.section, false, true)
                    egg.ai1 = shopItem.NPCid
                    egg.speedY = -9
                end

            elseif not spawnItem then
                player.reservePowerup = shopItem.NPCid
            end

            if shopItem.closeAfterPurchase then
                Shop:close()
            end
        end
    end
end


local function canUpdateInput()
    return (
        movementOver == true
        and ShopSystem.dialogueActive == 0
    )
end


local function bgStuff()
    bgTX = bgTX + 0.4
    bgTY = bgTY - 0.4

    if opacityFadeType == 1 then
        bgTopacity = bgTopacity + 0.1
    elseif opacityFadeType == 2 then
        bgTopacity = bgTopacity - 0.1
    end
    if ((bgTopacity > 1) or (bgTopacity < 0)) then
        opacityFadeType = 0
    elseif bgTopacity > 1 then
        bgTopacity = 1
    elseif bgTopacity < 0 then
        bgTopacity = 0
    end
    if bgTX > 8 then
        bgTX = 0
    end
    if bgTY < -8 then
        bgTY = 0
    end
end


local function doMassCalculation() -- the most great part of this script
    if mov.title.type == 1 then
        mov.title.position = mov.title.position + mov.title.speed
    elseif mov.title.type == 2 then
        mov.title.position = mov.title.position - mov.title.speed
    end
    if mov.itemsTab.type == 1 then
        mov.itemsTab.position = mov.itemsTab.position + mov.itemsTab.speed
    elseif mov.itemsTab.type == 2 then
        mov.itemsTab.position = mov.itemsTab.position - mov.itemsTab.speed
    end
    if mov.sidePanels.type == 1 then
        mov.sidePanels.position = mov.sidePanels.position - mov.sidePanels.speed
    elseif mov.sidePanels.type == 2 then
        mov.sidePanels.position = mov.sidePanels.position + mov.sidePanels.speed
    end
    if mov.descriptionBox.type == 1 then
        mov.descriptionBox.position = mov.descriptionBox.position - mov.descriptionBox.speed
    elseif mov.descriptionBox.type == 2 then
        mov.descriptionBox.position = mov.descriptionBox.position + mov.descriptionBox.speed
    end

    if mov.title.position > mov.title.goal then
        mov.title.type = 0
        mov.title.position = mov.title.goal
    elseif mov.title.position < -34 then
        mov.title.type = 0
        mov.title.position = -34
    end
    if mov.itemsTab.position > mov.itemsTab.goal then
        mov.itemsTab.type = 0
        mov.itemsTab.position = mov.itemsTab.goal
        movementOver = true
    elseif mov.itemsTab.position < -592 then
        mov.itemsTab.type = 0
        mov.itemsTab.position = -592
    end
    if mov.sidePanels.position < mov.sidePanels.goal then
        mov.sidePanels.type = 0
        mov.sidePanels.position = mov.sidePanels.goal
    elseif mov.sidePanels.position > 800 then
        mov.sidePanels.type = 0
        mov.sidePanels.position = 800
    end
    if mov.descriptionBox.position < mov.descriptionBox.goal then
        mov.descriptionBox.type = 0
        mov.descriptionBox.position = mov.descriptionBox.goal
    elseif mov.descriptionBox.position > 600 then
        mov.descriptionBox.type = 0
        mov.descriptionBox.position = 600
    end

    -- when the shop is properly opened
    if mov.title.position == 0
    and mov.itemsTab.position == 12
    and mov.sidePanels.position == 604
    and mov.descriptionBox.position == 526 then
        if actShop.music ~= nil then
            Audio.MusicChange(player.section, actShop.music, -1)
        end
    end

    -- when the shop is properly closed
    if mov.title.position == -34
    and mov.itemsTab.position == -592
    and mov.sidePanels.position == 800
    and mov.descriptionBox.position == 600 then
        actShop.id = nil
        actShop.items = {}
        actShop.selection = nil
        actShop.room = 0
        actShop.music = nil
        desX = 800
        Misc.unpause()
        Audio.MusicChange(player.section, prevMusic, -1)
        prevMusic = nil
    end
end


local function drawShop()
    bgStuff()
    doMassCalculation()

    -- background texture
    Graphics.drawImageWP(bgTexture, bgTX - 16, bgTY - 16, bgTopacity, priorityStuff.BgTexture)

    -- title panel
    Graphics.drawBox{texture = shopImage.shopMenus, x = 350, y = mov.title.position, sourceX = 350, sourceY = 0, sourceWidth = 100, sourceHeight = 34, priority = priorityStuff.tabs,}

    -- items tab
    Graphics.drawBox{texture = shopImage.shopMenus, x = mov.itemsTab.position, y = 48, sourceX = 12, sourceY = 48, sourceWidth = 580, sourceHeight = 464, priority = priorityStuff.tabs,}

    -- details tab, currencies tab and reserve powerup tab
    Graphics.drawBox{texture = shopImage.shopMenus, x = mov.sidePanels.position, y = 48, sourceX = 604, sourceY = 48, sourceWidth = 186, sourceHeight = 464, priority = priorityStuff.tabs,}

    -- description bar
    Graphics.drawBox{texture = shopImage.shopMenus, x = 0, y = mov.descriptionBox.position, sourceX = 0, sourceY = 526, sourceWidth  = 800, sourceHeight = 58, priority = priorityStuff.tabs,}

    -- Player's current powerup
    Graphics.drawBox{texture = shopImage.powerups, x = mov.sidePanels.position + 54, y = 416, sourceX = 0, sourceY = 32 * (player.powerup - 1), sourceWidth = 32, sourceHeight = 32, centered = true, priority = priorityStuff.items,}

    -- Player's reserve item
    if player.reservePowerup == 0 or (Graphics.getHUDType(player.character) == Graphics.HUD_HEARTS) then
        Graphics.drawBox{texture = shopImage.powerups, x = mov.sidePanels.position + 128, y = 416, sourceX = 0, sourceY = 0, sourceWidth = 32, sourceHeight = 32, centered = true, priority = priorityStuff.items,}
    elseif player.reservePowerup ~= 0 and (Graphics.getHUDType(player.character) == Graphics.HUD_ITEMBOX) then
        -- this part of code obtained from ModernStyledHud.lua by Elf of Happy and Love
        local rItem = Graphics.sprites.npc[player.reservePowerup].img
        local rPowerup = player.reservePowerup
        Graphics.drawBox{texture = rItem, x = mov.sidePanels.position + 128, y = 416, sourceWidth = NPC.config[rPowerup].width, sourceHeight = NPC.config[rPowerup].height, centered = true, priority = priorityStuff.items,}
    end

    local slctrX = 0
    local yesX = 236
    local noX = yesX + 301
    local okayX = 400
    local optionsY = 323

    if ShopSystem.dialogueActive == 1 or ShopSystem.dialogueActive == 2 then
        slctrX = okayX
        Graphics.drawBox{texture = shopImage.options, x = okayX, y = optionsY, sourceX = 0, sourceY = 64, sourceWidth = shopImage.options.width, sourceHeight = 36, centered = true, priority = priorityStuff.dialgOptions,}
    elseif ShopSystem.dialogueActive == 3 then
        if dialogSel == 1 then
            slctrX = yesX
        elseif dialogSel == 2 then
            slctrX = noX
        end

        Graphics.drawBox{texture = shopImage.options, x = yesX, y = optionsY, sourceX = 0, sourceY = 0, sourceWidth = shopImage.options.width, sourceHeight = 32, centered = true, priority = priorityStuff.dialgOptions,}
        Graphics.drawBox{texture = shopImage.options, x = noX, y = optionsY, sourceX = 0, sourceY = 32, sourceWidth = shopImage.options.width, sourceHeight = 32, centered = true, priority = priorityStuff.dialgOptions,}

        -- selector
        Graphics.drawBox{texture = shopImage.selector2, x = slctrX, y = optionsY, centered = true, priority = priorityStuff.dialgslctr,} 
    end

    if ShopSystem.dialogueActive ~= 0 then
        Graphics.drawScreen{color = {0,0,0,0.5}, priority = priorityStuff.dark}
        Graphics.drawBox{texture = shopImage.msgBox, x = 400, y = 300, centered = true, priority = priorityStuff.dialg,}
    end

    if mov.descriptionBox.type == 0 then
        desX = desX - 2
    end
    
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    for a, shopItem in ipairs(actShop.items) do
        local item = actShop.items[actShop.selection + 1] -- for stopping the headache


        local space = 104
        local itemX = mov.itemsTab.position + 82 + (space * shopItem.id)
        local itemY = 124
        local newSourceX = 0

        local FormattedDescription = textplus.parse(shopItem.description, {font = ShopSystem.font})
        local ItemDescription = textplus.layout(FormattedDescription)
    
        local FormattedName = textplus.parse(shopItem.name, {font = ShopSystem.font})
        local ItemName = textplus.layout(FormattedName, 146)

        local FormattedMsg1 = textplus.parse("Sorry, but the "..item.name.." is currently out of stock.", {font = ShopSystem.font})
        local FormattedMsg2 = textplus.parse("You need "..item.price.." "..item.currency.name.." for this item.", {font = ShopSystem.font})
        local FormattedMsg3 = textplus.parse("Do you want "..item.article.." "..item.name.."? Sure, that'll cost you "..item.price.." "..item.currency.name..".", {font = ShopSystem.font})

        local msg1 = textplus.layout(FormattedMsg1, 600)
        local msg2 = textplus.layout(FormattedMsg2, 600)
        local msg3 = textplus.layout(FormattedMsg3, 600)

        shopItem.room = (math.floor(shopItem.id / 20) * 1)
        shopItem.x = itemX - (520 * (math.floor(shopItem.id / 5)))
        shopItem.y = (itemY + math.floor(shopItem.id / 5) * space) - (shopItem.room * space * 4)

        
        if (shopItem.amount == 0 or shopItem.usesLeft == 0) and shopItem.updateFrame then
            newSourceX = shopItem.sourceWidth
        else
            newSourceX = 0
        end

        if desX < -(800 + ItemDescription.width) then
            desX = 800
        end
        
        if actShop.selection == shopItem.id then
            -- selector
            Graphics.drawBox{
                texture      = shopImage.selector,
                x            = shopItem.x,
                y            = shopItem.y,
                sourceX      = 0,
                sourceY      = 100 * selectorFrames,
                sourceWidth  = 100,
                sourceHeight = 100,
                centered     = true,
                priority     = priorityStuff.selectr,
            }

            -- box
            Graphics.drawBox{
                texture      = shopImage.shopBox,
                x            = mov.sidePanels.position + 63 + shopItem.xOffset,
                y            = 94 + shopItem.yOffset,
                centered     = true,
                priority     = priorityStuff.box,
            }

            -- Item's image
            Graphics.drawBox{
                texture      = shopItem.image,
                x            = mov.sidePanels.position + 63 + shopItem.xOffset,
                y            = 94 + shopItem.yOffset,
                sourceX      = shopItem.sourceX,
                sourceY      = shopItem.sourceY,
                sourceWidth  = shopItem.sourceWidth,
                sourceHeight = shopItem.sourceHeight,
                centered     = true,
                priority     = priorityStuff.items,
            }

            -- Item's currency's image
            Graphics.drawBox{texture = shopItem.cIcon, x = mov.sidePanels.position + 45, y = 147, centered = true, priority = priorityStuff.items,}

            -- Item's Description
            textplus.render{x = desX, y = mov.descriptionBox.position + 20, layout = ItemDescription, priority = priorityStuff.text}

            -- Item's Name
            textplus.render{x = mov.sidePanels.position + 20, y = 195, layout = ItemName, priority = priorityStuff.text}

            -- Item's Cost
            textplus.print{x = mov.sidePanels.position + 67, y = 139, text = tostring(shopItem.price), font = ShopSystem.font, priority = priorityStuff.text}

            -- Item's uses left
            if shopItem.amount ~= -1 and shopItem.amount ~= 0 then
                textplus.print{x = mov.sidePanels.position + 31, y = 171, text = string.format("%02d", shopItem.usesLeft).."/"..string.format("%02d", shopItem.amount), font = ShopSystem.font, priority = priorityStuff.text}
            else
                textplus.print{x = mov.sidePanels.position + 31, y = 172, text = "--", font = ShopSystem.font, priority = priorityStuff.text}
            end
        end

        if shopItem.room == actShop.room then
            -- items
            Graphics.drawBox{
                texture      = shopItem.image,
                x            = shopItem.x,
                y            = shopItem.y,
                sourceX      = shopItem.sourceX + newSourceX,
                sourceY      = shopItem.sourceY,
                sourceWidth  = shopItem.sourceWidth,
                sourceHeight = shopItem.sourceHeight,
                centered     = true,
                priority     = priorityStuff.items,
            }

            local OffsetY = (shopImage.shopBox.height / 2) - (shopImage.rIcon.height / 4)

            -- reserve icon
            if shopItem.useReserve and (Graphics.getHUDType(player.character) == Graphics.HUD_ITEMBOX) then
                Graphics.drawBox{texture = shopImage.rIcon, x = shopItem.x, y = shopItem.y + OffsetY, centered = true, priority = priorityStuff.items,}
            end

            -- box
            Graphics.drawBox{texture = shopImage.shopBox, x = shopItem.x, y = shopItem.y, centered = true, priority = priorityStuff.box,}
        end

        -- Arrows
        if actShop.room ~= 0 then
            Graphics.drawBox{texture = shopImage.arrows, x = mov.itemsTab.position + 290, y = 75 + arrowMovement, sourceX = 0, sourceY = 0, sourceWidth = shopImage.arrows.width, sourceHeight = shopImage.arrows.height / 2, centered = true, priority = priorityStuff.arrows,}
        end

        if actShop.room ~= finalRoom then
            Graphics.drawBox{texture = shopImage.arrows, x = mov.itemsTab.position + 290, y = 485 + (-arrowMovement), sourceX = 0, sourceY = shopImage.arrows.height / 2, sourceWidth = shopImage.arrows.width, sourceHeight = shopImage.arrows.height / 2, centered = true, priority = priorityStuff.arrows,}
        end


        -- Dialogue text
        if ShopSystem.dialogueActive == 1 then
            textplus.render{x = 105, y = 254, layout = msg1, priority = priorityStuff.dialgOptions}
        elseif ShopSystem.dialogueActive == 2 then
            textplus.render{x = 105, y = 254, layout = msg2, priority = priorityStuff.dialgOptions}
        elseif ShopSystem.dialogueActive == 3 then
            textplus.render{x = 105, y = 254, layout = msg3, priority = priorityStuff.dialgOptions}
        end
    end
end


function ShopSystem.create(args)
    if args.draw == nil then args.draw = drawShop end

    local shop = {
        draw = args.draw, -- function that draw this shop
        music = args.music, -- music that will be played while this shop is open
        
        -- don't touch
        items = {}, -- table to store the items of this shop
        selection = 0, -- current selection of this shop
        room = 0, -- current room of this shop
        id = #shops + 1
    }

    table.insert(shops, shop)
    setmetatable(shop, ShopMT)
    return shop
end


function Shop:open()
    local currentSection = Section(player.section)
    prevMusic = currentSection.music
    Audio.MusicFadeOut(player.section, 500)
    
    actShop.id = self.id
    actShop.items = self.items
    actShop.selection = self.selection
    actShop.room = self.room
    actShop.music = self.music
    
    Misc.pause()
    mov.title.type = 1
    mov.itemsTab.type = 1
    mov.sidePanels.type = 1
    mov.descriptionBox.type = 1
    opacityFadeType = 1
    movementOver = false
end


function Shop:close()
    Audio.MusicFadeOut(player.section, 500)

    mov.title.type = 2
    mov.itemsTab.type = 2
    mov.sidePanels.type = 2
    mov.descriptionBox.type = 2
    opacityFadeType = 2
    movementOver = false
end


function Shop:RegisterItem(args)    
    -- these 3 args are required
    if args.NPCid == nil then error("No NPC id was provided to register in the shop.") end
    if args.currency == nil then error("No currency was provided for the item.") end
    if args.price == nil then error("No price was provided for the item.") end

    -- manage nil stuff
    if args.article == nil then args.article = "" end
    if args.xOffset == nil then args.xOffset = 0 end
    if args.yOffset == nil then args.yOffset = 0 end
    if args.amount == nil then args.amount = -1 end
    if args.description == nil then args.description = "" end
    if args.name == nil then args.name = "" end
    if args.updateFrame == nil then args.updateFrame = false end
    if args.cIcon == nil then args.cIcon = shopImage.defaultCIcon end
    if args.useReserve == nil then args.useReserve = false end
    if args.closeAfterPurchase == nil then args.closeAfterPurchase = false end
    if args.inEgg == nil then args.inEgg = false end

    if args.image == nil then
        if args.NPCid ~= 0 then
            args.image = Graphics.sprites.npc[args.NPCid].img
            args.sourceWidth = NPC.config[args.NPCid].width
            args.sourceHeight = NPC.config[args.NPCid].height
        end

        args.sourceX = 0
        args.sourceY = 0
    end

    if args.sourceX == nil then args.sourceX = 0 end
    if args.sourceY == nil then args.sourceY = 0 end
    if args.sourceWidth == nil then args.sourceWidth = args.image.width end
    if args.sourceHeight == nil then args.sourceHeight = args.image.height end

    if args.draw == nil then args.draw = drawItems end
    if args.jumpKeyPressed == nil then args.jumpKeyPressed = ShopSystem.jumpKeyPressed end
    if args.dialogue == nil then args.dialogue = ShopSystem.dialogue end
    if args.costStuff == nil then args.costStuff = ShopSystem.costStuff end

    local item = {
        -- required args
        NPCid        = args.NPCid, -- ID of the npc to spawn, set to 0 for none
        currency     = args.currency, -- currency used by the item, must be an anothercurrency.lua currency
        price        = args.price, -- price of the item

        -- optional args
        inEgg        = args.inEgg, -- will the item be spawned via an egg or not
        useReserve   = args.useReserve, -- will the NPC go in the reserve box
        name         = args.name, -- name of the item, must be a string
        image        = args.image, -- image of the item to display
        cIcon        = args.cIcon, -- icon for the currency this item uses
        article      = args.article, -- article used by the item - a / an / the
        xOffset      = args.xOffset, -- X offset of the image
        yOffset      = args.yOffset, -- Y offset of the image
        sourceX      = args.sourceX, -- source X of the image
        sourceY      = args.sourceY, -- source Y of the image
        sourceWidth  = args.sourceWidth, -- width of the image
        sourceHeight = args.sourceHeight, -- height of the image
        amount       = args.amount, -- number of times this item can be used, set to -1 for infinite
        description  = args.description, -- description of the item, must be a string
        updateFrame  = args.updateFrame, -- if set to true, the item's sourceX will change to display the updated frame when it is out of stock
        closeAfterPurchase = args.closeAfterPurchase, -- if set to true, the shop will be closed after buying this item

        -- other
        dialogue = args.dialogue, -- function that handles the dialogue system for this item
        costStuff = args.costStuff, -- function to manage currency handling
        jumpKeyPressed  = args.jumpKeyPressed, -- function that handles when the player presses the jump key, executes after costStuff

        -- Don't touch these unless you know what you're doing
        usesLeft = args.amount,
        id = #self.items
    }

    table.insert(self.items, item)
    return item
end


local function doSomeStuff()
    if shopSFX.choose ~= nil then
        SFX.play(shopSFX.choose.id, shopSFX.choose.volume)
    end

    desX = 800
    pressDelayTimer = 0
    pressed = true
end


-- registering the events --
registerEvent(ShopSystem, "onInputUpdate")
registerEvent(ShopSystem, "onDraw")


function ShopSystem.onInputUpdate()
    if canUpdateInput() then
        if player.rawKeys.run == KEYS_PRESSED then
            Shop:close()

        elseif player.rawKeys.jump == KEYS_PRESSED then
            actShop.items[actShop.selection + 1]:dialogue()

        -- update the selection
        elseif (player.rawKeys.right and pressDelayTimer == 0) and ((actShop.selection + 1) <= (#actShop.items - 1)) then
            actShop.selection = actShop.selection + 1

            if roomcalc ~= 19 then
                roomcalc = roomcalc + 1
            elseif roomcalc == 19 then
                actShop.room = actShop.room + 1
                roomcalc = 0
            end

            doSomeStuff()
        elseif (player.rawKeys.left and pressDelayTimer == 0) and ((actShop.selection - 1) >= 0) then
            actShop.selection = actShop.selection - 1

            if roomcalc ~= 0 then
                roomcalc = roomcalc - 1
            elseif roomcalc == 0 then
                actShop.room = actShop.room - 1
                roomcalc = 19
            end
            
            doSomeStuff()
        elseif (player.rawKeys.down and pressDelayTimer == 0) then
            if ((actShop.selection + 5) <= (#actShop.items - 1)) then
                actShop.selection = actShop.selection + 5
                roomcalc = roomcalc + 5

                if roomcalc > 19 then
                    roomcalc = roomcalc - 20
                    actShop.room = actShop.room + 1
                end

                doSomeStuff()
            else
                if actShop.selection ~= (#actShop.items - 1) then
                    actShop.selection = (#actShop.items - 1)
                    for a, shopItem in ipairs(actShop.items) do
                        roomcalc = (#actShop.items - 1) - (shopItem.room * 20)
                    end
                    actShop.room = finalRoom
                    doSomeStuff()
                end
            end
        elseif (player.rawKeys.up and pressDelayTimer == 0) then
            if ((actShop.selection - 5) >= 0) then
                actShop.selection = actShop.selection - 5
                roomcalc = roomcalc - 5

                if roomcalc < 0 then
                    actShop.room = actShop.room - 1
                    roomcalc = 20 + roomcalc
                end

                doSomeStuff()
            else
                if actShop.selection > 0 then
                    actShop.selection = 0
                    roomcalc = 0
                    actShop.room = 0
                    doSomeStuff()
                end
            end
        end
    end


    if ShopSystem.dialogueActive == 3 then
        if player.rawKeys.right == KEYS_PRESSED and dialogSel ~= 2 then
            dialogSel = dialogSel + 1
        elseif player.rawKeys.left == KEYS_PRESSED and dialogSel ~= 1 then
            dialogSel = dialogSel - 1
        end

        if player.rawKeys.jump == KEYS_PRESSED then
            if dialogSel == 0 then
                dialogSel = 1
            elseif dialogSel == 1 then
                actShop.items[actShop.selection + 1]:costStuff()
                ShopSystem.dialogueActive = 0
            elseif dialogSel == 2 then
                ShopSystem.dialogueActive = 0
                
                if shopSFX.select ~= nil then
                    SFX.play(shopSFX.select.id, shopSFX.select.volume)
                end
            end
        elseif player.rawKeys.run == KEYS_PRESSED then
            ShopSystem.dialogueActive = 0

            if shopSFX.select ~= nil then
                SFX.play(shopSFX.select.id, shopSFX.select.volume)
            end
        end
    elseif ShopSystem.dialogueActive == 1 or ShopSystem.dialogueActive == 2 then
        if player.rawKeys.jump == KEYS_PRESSED or player.rawKeys.run == KEYS_PRESSED then
            if not canPress then
                canPress = true
            elseif canPress then
                ShopSystem.dialogueActive = 0

                if shopSFX.select ~= nil then
                    SFX.play(shopSFX.select.id, shopSFX.select.volume)
                end
            end
        end
    else
        dialogSel = 0
        canPress = false
    end
end


function ShopSystem.onDraw()
    if actShop.id ~= nil then
        -- draw the shop and also update frames for the selector
        shops[actShop.id]:draw()
        selectorFrames = math.floor((lunatime.drawtick() / ShopSystem.selectrFrSpeed) % ShopSystem.selectrFrames)

        -- Input stuff
        if pressed then
            pressDelayTimer = pressDelayTimer + 1
        end

        if pressDelayTimer > pressDelay then
            pressed = false
            pressDelayTimer = 0
        end

        -- Arrow's movement
        if goUp then
            arrowMovement = arrowMovement + 0.3
        elseif not goUp then
            arrowMovement = arrowMovement - 0.3
        end

        if arrowMovement >= arrowMovementOffset then
            goUp = false
        elseif arrowMovement <= 0 and not goUp then
            goUp = true
        end

        -- set the id for the last room
        for k, v in ipairs(actShop.items) do
            finalRoom = v.room
        end
    else
        -- reset some stuff
        selectorFrames = 0
        pressDelayTimer = 0
        pressed = false
        roomcalc = 0
        finalRoom = -1
        arrowMovement = 0
    end
end

return ShopSystem