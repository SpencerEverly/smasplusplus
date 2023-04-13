--Modded tremendously by Spencer Everly. I took this broken code and did it justice. How did I do?
--Original message and credits by Coldcolor900:

--[[
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

This is my first library and lua script, so I apologize if the code is a bit messy.

I would like to thank Enjl, Marioman2007, Sambo, Hoeloe, and Rednaxela for helping me
with all this stuff. I probably would have gone insane if they didn't help.

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--]]

--Oh yeah, and I should give thanks to MDA for telling me I should write a variable instead, it helped BIG time.

local furyinventory = {}

local warpTransition = require("warpTransition")
local pausemenu = require("pauseplus")
local littleDialogue = require("littleDialogue")
local modernReserveItems = require("modernReserveItems")
local smasBooleans = require("smasBooleans")

furyinventory.furyinventoryopened = false
smasBooleans.toggleOffInventory = false

furyinventory.priority = 5

local cooldown = 0

local furyinventoryimg = Graphics.loadImage(Misc.resolveFile("inventorystuff/inventory.png"))
local furyinventorysmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/inventorysmol.png"))
local selector = Graphics.loadImage(Misc.resolveFile("inventorystuff/selector.png"))

local selection = false
local selectx = 30
local selecty = 508
local numx = 40
local numy = 570

furyinventory.activated = true --This will activate the furyinventory only when it's true
furyinventory.activatefuryinventory = true --this is part of the code that makes sure dialogue systems dont mess with the furyinventory, but you can probably use it to your advantage when making levels.
furyinventory.hidden = false --To hide the furyinventory for certain cutscenes

local furyinventoryopen = false

local pUpsTable = table.map{14, 182, 183, 264, 277, 34, 169, 170}

local powerup = {
                 2, 
                 3, 
                 7, 
                 4, 
                 5, 
                 6,
                 7}
local state = 1

-- how much of each powerup is being stored
SaveData.furyinventory = SaveData.furyinventory or {
    shroom = 0,
    fire = 0,
    ice = 0,
    leaf = 0,
    tanooki = 0,
    hammer = 0,
    reserve = 0
}

--these are the graphics that show when you dont have any of one powerup
local noshroom = Graphics.loadImage(Misc.resolveFile("inventorystuff/noshroom.png"))
local nofire = Graphics.loadImage(Misc.resolveFile("inventorystuff/nofire.png"))
local noice = Graphics.loadImage(Misc.resolveFile("inventorystuff/noice.png"))
local noleaf = Graphics.loadImage(Misc.resolveFile("inventorystuff/noleaf.png"))
local notanooki = Graphics.loadImage(Misc.resolveFile("inventorystuff/notanooki.png"))
local nohammer = Graphics.loadImage(Misc.resolveFile("inventorystuff/nohammer.png"))

local noshroomsmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/noshroomsmol.png"))
local nofiresmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/nofiresmol.png"))
local noicesmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/noicesmol.png"))
local noleafsmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/noleafsmol.png"))
local notanookismol = Graphics.loadImage(Misc.resolveFile("inventorystuff/notanookismol.png"))
local nohammersmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/nohammersmol.png"))


-- the maximum and minimum amout of each powerup that can be stored
local maxshroom = 10
local minshroom = 0

local maxfire = 5
local minfire = 0

local maxice = 5
local minice = 0

local maxleaf = 5
local minleaf = 0

local maxtanooki = 5
local mintanooki = 0

local maxhammer = 5
local minhammer = 0

local maxreserve = 1
local minreserve = 0


function furyinventory.onInitAPI()
    registerEvent(furyinventory , "onStart")
    registerEvent(furyinventory , "onDraw")
    registerEvent(furyinventory , "onPostNPCKill")
    registerEvent(furyinventory , "onTick")
    registerEvent(furyinventory , "onEvent")
    registerEvent(furyinventory , "onInputUpdate")
end

function makereservefalse()
    Routine.wait(0.1)
    modernReserveItems.dropped = false
end

function furyinventory.onDraw()
    if player.deathTimer > 0 then
        smasBooleans.toggleOffInventory = true
    end
    if furyinventory.hidden == false then
        if furyinventory.activatefuryinventory then
            if furyinventory.furyinventoryopened then
                numx = 54
                numy = 574

            

                if SaveData.furyinventory.shroom >= 10 then
                    Text.printWP(SaveData.furyinventory.shroom, numx-8, numy, furyinventory.priority - 0.5)
                else
                    Text.printWP(SaveData.furyinventory.shroom, numx, numy, furyinventory.priority - 0.5)
                end

                if SaveData.furyinventory.fire >= 10 then
                    Text.printWP(SaveData.furyinventory.fire, numx+64-8, numy, furyinventory.priority - 0.5)
                else
                    Text.printWP(SaveData.furyinventory.fire, numx+64, numy, furyinventory.priority - 0.5)
                end

                if SaveData.furyinventory.ice >= 10 then
                    Text.printWP(SaveData.furyinventory.ice, numx+128-8, numy, furyinventory.priority - 0.5)
                else
                    Text.printWP(SaveData.furyinventory.ice, numx+128, numy, furyinventory.priority - 0.5)
                end

                if SaveData.furyinventory.leaf >= 10 then
                    Text.printWP(SaveData.furyinventory.leaf, numx+192-8, numy, furyinventory.priority - 0.5)
                else
                    Text.printWP(SaveData.furyinventory.leaf, numx+192, numy, furyinventory.priority - 0.5)
                end

                if SaveData.furyinventory.tanooki >= 10 then
                    Text.printWP(SaveData.furyinventory.tanooki, numx+256-8, numy, furyinventory.priority - 0.5)
                else
                    Text.printWP(SaveData.furyinventory.tanooki, numx+256, numy, furyinventory.priority - 0.5)
                end

                if SaveData.furyinventory.hammer >= 10 then
                    Text.printWP(SaveData.furyinventory.hammer, numx+320-8, numy, furyinventory.priority - 0.5)
                else
                    Text.printWP(SaveData.furyinventory.hammer, numx+320, numy, furyinventory.priority - 0.5)
                end



                if not furyinventory.activatefuryinventory then
                    --Nothing
                end
            end
        end

    --makes sure that you don't go over the limit of items
        if SaveData.furyinventory.shroom >= maxshroom then
            SaveData.furyinventory.shroom = maxshroom
        end

        if SaveData.furyinventory.fire >= maxfire then
            SaveData.furyinventory.fire = maxfire
        end

        if SaveData.furyinventory.ice >= maxice then
            SaveData.furyinventory.ice = maxice
        end

        if SaveData.furyinventory.leaf >= maxleaf then
            SaveData.furyinventory.leaf = maxleaf
        end

        if SaveData.furyinventory.tanooki >= maxtanooki then
            SaveData.furyinventory.tanooki = maxtanooki
        end

        if SaveData.furyinventory.hammer >= maxhammer then
            SaveData.furyinventory.hammer = maxhammer
        end

        -- same, but for minimum
        if SaveData.furyinventory.shroom <= minshroom then
            SaveData.furyinventory.shroom = minshroom
        end

        if SaveData.furyinventory.fire <= minfire then
            SaveData.furyinventory.fire = minfire
        end

        if SaveData.furyinventory.ice <= minice then
            SaveData.furyinventory.ice = minice
        end

        if SaveData.furyinventory.leaf <= minleaf then
            SaveData.furyinventory.leaf = minleaf
        end

        if SaveData.furyinventory.tanooki <= mintanooki then
            SaveData.furyinventory.tanooki = mintanooki
        end

        if SaveData.furyinventory.hammer <= minhammer then
            SaveData.furyinventory.hammer = minhammer
        end

        if furyinventory.activatefuryinventory then
            if furyinventory.furyinventoryopened then
                Graphics.drawImageWP(furyinventoryimg, 30, 508, furyinventory.priority - 0.4)
                Graphics.drawImageWP(selector, selectx, selecty, furyinventory.priority - 0.5)
                if SaveData.furyinventory.shroom == 0 then
                    Graphics.drawImageWP(noshroom, 30, 508, furyinventory.priority - 0.2)
                end
                if SaveData.furyinventory.fire == 0 then
                    Graphics.drawImageWP(nofire, 94, 508, furyinventory.priority - 0.2)
                end
                if SaveData.furyinventory.ice == 0 then
                    Graphics.drawImageWP(noice, 158, 508, furyinventory.priority - 0.2)
                end 
                if SaveData.furyinventory.leaf == 0 then
                    Graphics.drawImageWP(noleaf, 222, 508, furyinventory.priority - 0.2)
                end
                if SaveData.furyinventory.tanooki == 0 then
                    Graphics.drawImageWP(notanooki, 286, 508, furyinventory.priority - 0.2)
                end
                if SaveData.furyinventory.hammer == 0 then
                    Graphics.drawImageWP(nohammer, 350, 508, furyinventory.priority - 0.2)
                end
            end
        end
        if furyinventory.activatefuryinventory == false then
            --Nothing
        end
    end
end


function furyinventory.onPostNPCKill(v,reason)
    for _,p in ipairs(Player.get()) do --This will get actions regards to the player itself
        if v.id == 14 or v.id == 183 or v.id == 182 and Colliders.collide(p, v) then -- collecting fire flower
            if  player.isMega == true then
                SaveData.furyinventory.fire = SaveData.furyinventory.fire + 1
            end
        elseif v.id == 9 or v.id == 184 or v.id == 185 or v.id == 249 and Colliders.collide(p, v) then -- collecting mushroom
            if player.powerup >= 2 or player.isMega == true then
                SaveData.furyinventory.shroom = SaveData.furyinventory.shroom + 1
            end
        elseif v.id == 264 or v.id == 277 and Colliders.collide(p, v) then -- collecting ice flower
            if player.isMega == true then
                SaveData.furyinventory.ice = SaveData.furyinventory.ice + 1
            end
        elseif v.id == 34 and Colliders.collide(p, v) then -- collecting super leaf
            if player.isMega == true then
                SaveData.furyinventory.leaf = SaveData.furyinventory.leaf + 1
            end
        elseif v.id == 169 and Colliders.collide(p, v) then -- collecting tanooki suit
            if player.isMega == true then
                SaveData.furyinventory.tanooki = SaveData.furyinventory.tanooki + 1
            end
        elseif v.id == 170 and Colliders.collide(p, v) then -- collecting hammer suit
            if player.isMega == true then
                SaveData.furyinventory.hammer = SaveData.furyinventory.hammer + 1
            end
        end
    end


    if player.powerup == PLAYER_BIG then
        if pUpsTable[v.id] then
            SaveData.furyinventory.shroom = SaveData.furyinventory.shroom + 1
        end
    elseif player.powerup == PLAYER_FIREFLOWER then
        if pUpsTable[v.id] then
            SaveData.furyinventory.fire = SaveData.furyinventory.fire + 1
        end
    elseif player.powerup == PLAYER_LEAF then
        if pUpsTable[v.id] then
            SaveData.furyinventory.leaf = SaveData.furyinventory.leaf + 1
        end
    elseif player.powerup == PLAYER_TANOOKIE then
        if pUpsTable[v.id] then
            SaveData.furyinventory.tanooki = SaveData.furyinventory.tanooki + 1
        end
    elseif player.powerup == PLAYER_HAMMER then
        if pUpsTable[v.id] then
            SaveData.furyinventory.hammer = SaveData.furyinventory.hammer + 1
        end
    elseif player.powerup == PLAYER_ICE then
        if pUpsTable[v.id] then
            SaveData.furyinventory.ice = SaveData.furyinventory.ice + 1
        end
    elseif SaveData.reserveBoxItem[1] then
        SaveData.furyinventory.reserve = SaveData.reserveBoxItem[1]
    end
end

function furyinventory.onTick()
    selectx = 30
    selecty = 508
    numx = 40
    numy = 570
    
    SaveData.furyinventory.reserve = SaveData.reserveBoxItem[1]
    Defines.player_hasCheated = false -- disables the disabling of saving when using a cheat code
    if warpTransition.transitionTimer >= 0.1 then
        furyinventory.activated = false
    end
    if warpTransition.transitionTimer == 0 then
        furyinventory.activated = true
    end
    if warpTransition.crossSectionTransition == warpTransition.TRANSITION_FADE then
        furyinventory.activated = false
    end
    
    if furyinventory.hidden == false then
        Graphics.drawImageWP(furyinventorysmol, 32, 538, furyinventory.priority - 0.4) -- draws the furyinventory
        
            numx = 40
            numy = 570

        if SaveData.furyinventory.shroom >= 10 then
            Text.printWP(SaveData.furyinventory.shroom, numx-10, numy, furyinventory.priority - 0.5)
        else
            Text.printWP(SaveData.furyinventory.shroom, numx, numy, furyinventory.priority - 0.5)
        end

        if SaveData.furyinventory.fire >= 10 then
            Text.printWP(SaveData.furyinventory.fire, numx-10, numy, furyinventory.priority - 0.5)
        else
            Text.printWP(SaveData.furyinventory.fire, numx+32, numy, furyinventory.priority - 0.5)
        end

        if SaveData.furyinventory.ice >= 10 then
            Text.printWP(SaveData.furyinventory.ice, numx+64-10, numy, furyinventory.priority - 0.5)
        else
            Text.printWP(SaveData.furyinventory.ice, numx+64, numy, furyinventory.priority - 0.5)
        end

        if SaveData.furyinventory.leaf >= 10 then
            Text.printWP(SaveData.furyinventory.leaf, numx+96-10, numy, furyinventory.priority - 0.5)
        else
            Text.printWP(SaveData.furyinventory.leaf, numx+96, numy, furyinventory.priority - 0.5)
        end

        if SaveData.furyinventory.tanooki >= 10 then
            Text.printWP(SaveData.furyinventory.tanooki, numx+128-10, numy, furyinventory.priority - 0.5)
        else
            Text.printWP(SaveData.furyinventory.tanooki, numx+128, numy, furyinventory.priority - 0.5)
        end

        if SaveData.furyinventory.hammer >= 10 then
            Text.printWP(SaveData.furyinventory.hammer, numx+160-10, numy, furyinventory.priority - 0.5)
        else
            Text.printWP(SaveData.furyinventory.hammer, numx+160, numy, furyinventory.priority - 0.5)
        end



        if SaveData.furyinventory.shroom == 0 then
            Graphics.drawImageWP(noshroomsmol, 32, 538, furyinventory.priority - 0.5)
        end
        if SaveData.furyinventory.fire == 0 then
            Graphics.drawImageWP(nofiresmol, 64, 538, furyinventory.priority - 0.5)
        end
        if SaveData.furyinventory.ice == 0 then
            Graphics.drawImageWP(noicesmol, 96, 538, furyinventory.priority - 0.5)
        end
        if SaveData.furyinventory.leaf == 0 then
            Graphics.drawImageWP(noleafsmol, 128, 538, furyinventory.priority - 0.5)
        end
        if SaveData.furyinventory.tanooki == 0 then
            Graphics.drawImageWP(notanookismol, 160, 538, furyinventory.priority - 0.5)
        end
        if SaveData.furyinventory.hammer == 0 then
            Graphics.drawImageWP(nohammersmol, 192, 538, furyinventory.priority - 0.5)
        end
    end
end


function furyinventory.onInputUpdate()
    if furyinventoryopen == false then
        if player.keys.up == KEYS_PRESSED then
            furyinventory.activatefuryinventory = false
        end
        if player.keys.down == KEYS_PRESSED then
            furyinventory.activatefuryinventory = false
        end
    end
    if smasBooleans.toggleOffInventory then
        furyinventory.activatefuryinventory = false
        furyinventory.activated = false
        furyinventory.hidden = true
    end
    if not smasBooleans.toggleOffInventory then
        furyinventory.activated = true
        furyinventory.hidden = false
    end
    if furyinventory.activated == true or furyinventory.hidden == false or smasBooleans.toggleOffInventory == false then
        if player.rawKeys.dropItem == KEYS_PRESSED and furyinventory.activated == true then -- toggle furyinventory menu
            furyinventory.activatefuryinventory = true
            furyinventory.furyinventoryopened = not furyinventory.furyinventoryopened
            cooldown = 5
            player:mem(0x130,FIELD_BOOL,false)
            if cooldown <= 0 then
                player:mem(0x130,FIELD_BOOL,true)
            end
            if furyinventory.furyinventoryopened == false and player.rawKeys.dropItem == KEYS_PRESSED then
                furyinventoryopen = false
                furyinventory.furyinventoryopened = false
                if smasBooleans.toggleOffInventory == false then
                    Audio.playSFX(Misc.resolveFile("inventorystuff/invclose.wav"))
                end
                Misc.unpause()
                state = 1
            elseif furyinventory.furyinventoryopened == true and player.rawKeys.dropItem == KEYS_PRESSED then
                furyinventoryopen = true
                furyinventory.furyinventoryopened = true
                if smasBooleans.toggleOffInventory == false then
                    Audio.playSFX(Misc.resolveFile("inventorystuff/invopen.wav"))
                end
                Misc.pause()
                state = 1
            end
        end
        if furyinventory.activated == false or furyinventory.hidden == false then
            if player.rawKeys.dropItem == KEYS_PRESSED then
                player.rawKeys.dropItem = KEYS_UNPRESSED
            end
        end
    end
    if furyinventory.activatefuryinventory == true then
        if furyinventory.furyinventoryopened == true then -- selects the powerup
            if player.rawKeys.jump == KEYS_PRESSED and furyinventory.activated == true then
                if player.powerup == powerup[state] then
                    Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                elseif state == 1 then
                    if SaveData.furyinventory.shroom > 0 then -- mushroom
                        if player.powerup == 1 then
                            Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                            Audio.playSFX(6)
                            player.powerup = powerup[state]
                            SaveData.furyinventory.shroom = SaveData.furyinventory.shroom - 1
                            state = 1
                            furyinventory.furyinventoryopened = false
                            cooldown = 5
                            Misc.unpause()
                            player:mem(0x11E,FIELD_BOOL,false)
                            if cooldown <= 0 then
                                player:mem(0x11E,FIELD_BOOL,true)
                            end
                        end
                    elseif SaveData.furyinventory.shroom <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 2 then
                    if SaveData.furyinventory.fire > 0 then -- SaveData.furyinventory.fire flower
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(6)
                        player.powerup = powerup[state]
                        SaveData.furyinventory.fire = SaveData.furyinventory.fire - 1
                        state = 1
                        furyinventory.furyinventoryopened = false
                        cooldown = 5
                        Misc.unpause()
                        player:mem(0x11E,FIELD_BOOL,false)
                        if cooldown <= 0 then
                            player:mem(0x11E,FIELD_BOOL,true)
                        end
                    elseif SaveData.furyinventory.fire <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 3 then
                    if SaveData.furyinventory.ice > 0 then -- SaveData.furyinventory.ice flower
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(6)
                        player.powerup = powerup[state]
                        SaveData.furyinventory.ice = SaveData.furyinventory.ice - 1
                        state = 1
                        furyinventory.furyinventoryopened = false
                        cooldown = 5
                        Misc.unpause()
                        player:mem(0x11E,FIELD_BOOL,false)
                        if cooldown <= 0 then
                            player:mem(0x11E,FIELD_BOOL,true)
                        end
                    elseif SaveData.furyinventory.ice <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 4 then
                    if SaveData.furyinventory.leaf > 0 then -- super SaveData.furyinventory.leaf
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(34)
                        player.powerup = powerup[state]
                        SaveData.furyinventory.leaf = SaveData.furyinventory.leaf - 1
                        state = 1
                        furyinventory.furyinventoryopened = false
                        cooldown = 5
                        Misc.unpause()
                        player:mem(0x11E,FIELD_BOOL,false)
                        if cooldown <= 0 then
                            player:mem(0x11E,FIELD_BOOL,true)
                        end
                    elseif SaveData.furyinventory.leaf <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 5 then
                    if SaveData.furyinventory.tanooki > 0 then -- SaveData.furyinventory.tanooki suit
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(34)
                        player.powerup = powerup[state]
                        SaveData.furyinventory.tanooki = SaveData.furyinventory.tanooki - 1
                        state = 1
                        furyinventory.furyinventoryopened = false
                        cooldown = 5
                        Misc.unpause()
                        player:mem(0x11E,FIELD_BOOL,false)
                        if cooldown <= 0 then
                            player:mem(0x11E,FIELD_BOOL,true)
                        end
                    elseif SaveData.furyinventory.tanooki <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 6 then
                    if SaveData.furyinventory.hammer > 0 then -- SaveData.furyinventory.hammer suit
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        Audio.playSFX(34)
                        player.powerup = powerup[state]
                        SaveData.furyinventory.hammer = SaveData.furyinventory.hammer - 1
                        state = 1
                        furyinventory.furyinventoryopened = false
                        cooldown = 5
                        Misc.unpause()
                        player:mem(0x11E,FIELD_BOOL,false)
                        if cooldown <= 0 then
                            player:mem(0x11E,FIELD_BOOL,true)
                        end
                    elseif SaveData.furyinventory.hammer <= 0 then
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                elseif state == 7 then
                    if SaveData.furyinventory.reserve >= 1 then
                        p = player
                        Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
                        modernReserveItems.drop(SaveData.reserveBoxItem[1], p)
                        cooldown = 5
                        state = 1
                        furyinventory.furyinventoryopened = false
                        Misc.unpause()
                        player:mem(0x11E,FIELD_BOOL,false)
                        if cooldown <= 0 then
                            player:mem(0x11E,FIELD_BOOL,true)
                        end
                    elseif SaveData.furyinventory.reserve <= 0 then
                        --modernReserveItems.dropped = false
                        Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
                    end
                end
            end
        end
    end
    if furyinventory.furyinventoryopened == true then -- move cursor right
        if player.rawKeys.right == KEYS_PRESSED then
            Audio.playSFX(Misc.resolveFile("inventorystuff/menuselect.wav"))
            selectx = selectx + 64
            state = state + 1
        end
    end
    if furyinventory.furyinventoryopened == true then -- move cursor left
        if player.rawKeys.left == KEYS_PRESSED then
            Audio.playSFX(Misc.resolveFile("inventorystuff/menuselect.wav"))
            selectx = selectx - 64
            state = state - 1
        end
    end
    if furyinventory.furyinventoryopened == true then -- if the cursor is on the far right or left, it will loop around
        if selectx < 30 then
            selectx = 30 + 384
        end 
    end
    if furyinventory.furyinventoryopened == true then
        if selectx > 30 + 414 then
            selectx = 30
        end 
    end
    if furyinventory.furyinventoryopened == true then
        if state > 7 then
            state = 1
        end
    end
    if furyinventory.furyinventoryopened == true then
        if state < 1 then
            state = 7
        end
    end
    if furyinventory.furyinventoryopened == false then
        --Nothing
    end
end

return furyinventory