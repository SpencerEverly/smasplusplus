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

local inventory = {}

local warpTransition = require("warpTransition")
local pausemenu = require("pausemenu")
local littleDialogue = require("littleDialogue")
local yoshi = require("yiYoshi/yiYoshi")
local modernReserveItems = require("modernReserveItems")
local hudoverride = require("hudoverride")
local globalgenerals = require("globalgenerals")

inventory.inventoryopened = false

local cooldown = 0

local inventoryimg = Graphics.loadImage(Misc.resolveFile("inventorystuff/inventory.png"))
local inventorysmol = Graphics.loadImage(Misc.resolveFile("inventorystuff/inventorysmol.png"))
local selector = Graphics.loadImage(Misc.resolveFile("inventorystuff/selector.png"))

local selection = false
local selectx = 30
local selecty = 508
local numx = 40
local numy = 570

inventory.activated = true --This will activate the inventory only when it's true
inventory.activateinventory = true --this is part of the code that makes sure dialogue systems dont mess with the inventory, but you can probably use it to your advantage when making levels.
inventory.hidden = false --To hide the inventory for certain cutscenes

local inventoryopen = false

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
SaveData.inventory = SaveData.inventory or {
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


function inventory.onInitAPI()
    registerEvent(inventory , "onStart")
    registerEvent(inventory , "onDraw")
    registerEvent(inventory , "onPostNPCKill")
    registerEvent(inventory , "onTick")
    registerEvent(inventory , "onEvent")
    registerEvent(inventory , "onInputUpdate")
end

function makereservefalse()
	Routine.wait(0.1)
	modernReserveItems.dropped = false
end

function inventory.onDraw()
	if inventory.hidden == false then
		--player.reservePowerup = 0 -- disables the item box
		if inventory.activateinventory == true then
			if inventory.inventoryopened == true then
				if SaveData.resolution == "fullscreen" or SaveData.resolution == "widescreen" or SaveData.resolution == "ultrawide" or SaveData.resolution == "gameboy" or SaveData.resolution == "gba" or SaveData.resolution == "3ds" then
					numx = 54
					numy = 574

				

					if SaveData.inventory.shroom >= 10 then
						Text.printWP(SaveData.inventory.shroom, numx-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.shroom, numx, numy, -1.9)
					end

					if SaveData.inventory.fire >= 10 then
						Text.printWP(SaveData.inventory.fire, numx+64-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.fire, numx+64, numy, -1.9)
					end

					if SaveData.inventory.ice >= 10 then
						Text.printWP(SaveData.inventory.ice, numx+128-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.ice, numx+128, numy, -1.9)
					end

					if SaveData.inventory.leaf >= 10 then
						Text.printWP(SaveData.inventory.leaf, numx+192-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.leaf, numx+192, numy, -1.9)
					end

					if SaveData.inventory.tanooki >= 10 then
						Text.printWP(SaveData.inventory.tanooki, numx+256-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.tanooki, numx+256, numy, -1.9)
					end

					if SaveData.inventory.hammer >= 10 then
						Text.printWP(SaveData.inventory.hammer, numx+320-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.hammer, numx+320, numy, -1.9)
					end
				end
				if SaveData.resolution == "nes" then
					numx = 114
					numy = 554

				

					if SaveData.inventory.shroom >= 10 then
						Text.printWP(SaveData.inventory.shroom, numx-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.shroom, numx, numy, -1.9)
					end

					if SaveData.inventory.fire >= 10 then
						Text.printWP(SaveData.inventory.fire, numx+64-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.fire, numx+64, numy, -1.9)
					end

					if SaveData.inventory.ice >= 10 then
						Text.printWP(SaveData.inventory.ice, numx+128-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.ice, numx+128, numy, -1.9)
					end

					if SaveData.inventory.leaf >= 10 then
						Text.printWP(SaveData.inventory.leaf, numx+192-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.leaf, numx+192, numy, -1.9)
					end

					if SaveData.inventory.tanooki >= 10 then
						Text.printWP(SaveData.inventory.tanooki, numx+256-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.tanooki, numx+256, numy, -1.9)
					end

					if SaveData.inventory.hammer >= 10 then
						Text.printWP(SaveData.inventory.hammer, numx+320-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.hammer, numx+320, numy, -1.9)
					end
				end
				if SaveData.resolution == "iphone1st" then
					numx = 214
					numy = 574

				

					if SaveData.inventory.shroom >= 10 then
						Text.printWP(SaveData.inventory.shroom, numx-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.shroom, numx, numy, -1.9)
					end

					if SaveData.inventory.fire >= 10 then
						Text.printWP(SaveData.inventory.fire, numx+64-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.fire, numx+64, numy, -1.9)
					end

					if SaveData.inventory.ice >= 10 then
						Text.printWP(SaveData.inventory.ice, numx+128-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.ice, numx+128, numy, -1.9)
					end

					if SaveData.inventory.leaf >= 10 then
						Text.printWP(SaveData.inventory.leaf, numx+192-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.leaf, numx+192, numy, -1.9)
					end

					if SaveData.inventory.tanooki >= 10 then
						Text.printWP(SaveData.inventory.tanooki, numx+256-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.tanooki, numx+256, numy, -1.9)
					end

					if SaveData.inventory.hammer >= 10 then
						Text.printWP(SaveData.inventory.hammer, numx+320-8, numy, -1.9)
					else
						Text.printWP(SaveData.inventory.hammer, numx+320, numy, -1.9)
					end
				end



				if inventory.activateinventory == false then
					--Nothing
				end
			end
		end

	--makes sure that you don't go over the limit of items
		if SaveData.inventory.shroom >= maxshroom then
			SaveData.inventory.shroom = maxshroom
		end

		if SaveData.inventory.fire >= maxfire then
			SaveData.inventory.fire = maxfire
		end

		if SaveData.inventory.ice >= maxice then
			SaveData.inventory.ice = maxice
		end

		if SaveData.inventory.leaf >= maxleaf then
			SaveData.inventory.leaf = maxleaf
		end

		if SaveData.inventory.tanooki >= maxtanooki then
			SaveData.inventory.tanooki = maxtanooki
		end

		if SaveData.inventory.hammer >= maxhammer then
			SaveData.inventory.hammer = maxhammer
		end

		-- same, but for minimum
		if SaveData.inventory.shroom <= minshroom then
			SaveData.inventory.shroom = minshroom
		end

		if SaveData.inventory.fire <= minfire then
			SaveData.inventory.fire = minfire
		end

		if SaveData.inventory.ice <= minice then
			SaveData.inventory.ice = minice
		end

		if SaveData.inventory.leaf <= minleaf then
			SaveData.inventory.leaf = minleaf
		end

		if SaveData.inventory.tanooki <= mintanooki then
			SaveData.inventory.tanooki = mintanooki
		end

		if SaveData.inventory.hammer <= minhammer then
			SaveData.inventory.hammer = minhammer
		end

		if inventory.activateinventory == true then
			if inventory.inventoryopened == true then
				if SaveData.resolution == "fullscreen" or SaveData.resolution == "widescreen" or SaveData.resolution == "ultrawide" or SaveData.resolution == "gameboy" or SaveData.resolution == "gba" or SaveData.resolution == "3ds" then
					Graphics.drawImageWP(inventoryimg, 30, 508, -1.8)
					Graphics.drawImageWP(selector, selectx, selecty, -1.9)
					if SaveData.inventory.shroom == 0 then
						Graphics.drawImageWP(noshroom, 30, 508, -1.98)
					end
					if SaveData.inventory.fire == 0 then
						Graphics.drawImageWP(nofire, 94, 508, -1.98)
					end
					if SaveData.inventory.ice == 0 then
						Graphics.drawImageWP(noice, 158, 508, -1.98)
					end 
					if SaveData.inventory.leaf == 0 then
						Graphics.drawImageWP(noleaf, 222, 508, -1.98)
					end
					if SaveData.inventory.tanooki == 0 then
						Graphics.drawImageWP(notanooki, 286, 508, -1.98)
					end
					if SaveData.inventory.hammer == 0 then
						Graphics.drawImageWP(nohammer, 350, 508, -1.98)
					end
				end
				if SaveData.resolution == "nes" then
					Graphics.drawImageWP(inventoryimg, 90, 488, -1.8)
					Graphics.drawImageWP(selector, selectx, selecty, -1.9)
					if SaveData.inventory.shroom == 0 then
						Graphics.drawImageWP(noshroom, 90, 488, -1.98)
					end
					if SaveData.inventory.fire == 0 then
						Graphics.drawImageWP(nofire, 154, 488, -1.98)
					end
					if SaveData.inventory.ice == 0 then
						Graphics.drawImageWP(noice, 218, 488, -1.98)
					end 
					if SaveData.inventory.leaf == 0 then
						Graphics.drawImageWP(noleaf, 282, 488, -1.98)
					end
					if SaveData.inventory.tanooki == 0 then
						Graphics.drawImageWP(notanooki, 346, 488, -1.98)
					end
					if SaveData.inventory.hammer == 0 then
						Graphics.drawImageWP(nohammer, 410, 488, -1.98)
					end
				end
				if SaveData.resolution == "iphone1st" then
					Graphics.drawImageWP(inventoryimg, 190, 508, -1.8)
					Graphics.drawImageWP(selector, selectx, selecty, -1.9)
					if SaveData.inventory.shroom == 0 then
						Graphics.drawImageWP(noshroom, 190, 508, -1.98)
					end
					if SaveData.inventory.fire == 0 then
						Graphics.drawImageWP(nofire, 254, 508, -1.98)
					end
					if SaveData.inventory.ice == 0 then
						Graphics.drawImageWP(noice, 318, 508, -1.98)
					end 
					if SaveData.inventory.leaf == 0 then
						Graphics.drawImageWP(noleaf, 382, 508, -1.98)
					end
					if SaveData.inventory.tanooki == 0 then
						Graphics.drawImageWP(notanooki, 446, 508, -1.98)
					end
					if SaveData.inventory.hammer == 0 then
						Graphics.drawImageWP(nohammer, 510, 508, -1.98)
					end
				end
			end
		end
		if inventory.activateinventory == false then
			--Nothing
		end
	end
end


function inventory.onPostNPCKill(v,reason)
    if v.id == 14 or v.id == 183 or v.id == 182 then -- collecting fire flower
        if  player.isMega == true then
            SaveData.inventory.fire = SaveData.inventory.fire + 1
        end
    elseif v.id == 9 or v.id == 184 or v.id == 185 or v.id == 249 then -- collecting mushroom
        if player.powerup >= 2 or player.isMega == true then
            SaveData.inventory.shroom = SaveData.inventory.shroom + 1
        end
    elseif v.id == 264 or v.id == 277 then -- collecting ice flower
        if player.isMega == true then
            SaveData.inventory.ice = SaveData.inventory.ice + 1
        end
    elseif v.id == 34 then -- collecting super leaf
        if player.isMega == true then
            SaveData.inventory.leaf = SaveData.inventory.leaf + 1
        end
    elseif v.id == 169 then -- collecting tanooki suit
        if player.isMega == true then
            SaveData.inventory.tanooki = SaveData.inventory.tanooki + 1
        end
    elseif v.id == 170 then -- collecting hammer suit
        if player.isMega == true then
            SaveData.inventory.hammer = SaveData.inventory.hammer + 1
        end
    end


    if player.powerup == PLAYER_BIG then
		if pUpsTable[v.id] then
			SaveData.inventory.shroom = SaveData.inventory.shroom + 1
		end
    elseif player.powerup == PLAYER_FIREFLOWER then
        if pUpsTable[v.id] then
            SaveData.inventory.fire = SaveData.inventory.fire + 1
        end
    elseif player.powerup == PLAYER_LEAF then
        if pUpsTable[v.id] then
            SaveData.inventory.leaf = SaveData.inventory.leaf + 1
        end
    elseif player.powerup == PLAYER_TANOOKIE then
        if pUpsTable[v.id] then
            SaveData.inventory.tanooki = SaveData.inventory.tanooki + 1
        end
    elseif player.powerup == PLAYER_HAMMER then
        if pUpsTable[v.id] then
            SaveData.inventory.hammer = SaveData.inventory.hammer + 1
        end
    elseif player.powerup == PLAYER_ICE then
        if pUpsTable[v.id] then
            SaveData.inventory.ice = SaveData.inventory.ice + 1
        end
	elseif player.reservePowerup then
		SaveData.inventory.reserve = player.reservePowerup
    end
end

function inventory.onTick()
	if SaveData.resolution == "fullscreen" or SaveData.resolution == "widescreen" or SaveData.resolution == "ultrawide" or SaveData.resolution == "gameboy" or SaveData.resolution == "gba" or SaveData.resolution == "3ds" then
		selectx = 30
		selecty = 508
		numx = 40
		numy = 570
	end
	if SaveData.resolution == "nes" then
		selectx = 90
		selecty = 488
		numx = 70
		numy = 550
	end
	if SaveData.resolution == "iphone1st" then
		selectx = 190
		selecty = 508
		numx = 200
		numy = 570
	end
	
	SaveData.inventory.reserve = player.reservePowerup
    Defines.player_hasCheated = false -- disables the disabling of saving when using a cheat code
	if warpTransition.transitionTimer >= 0.1 then
		inventory.activated = false
	end
	if warpTransition.transitionTimer == 0 then
		inventory.activated = true
	end
	if warpTransition.crossSectionTransition == warpTransition.TRANSITION_FADE then
		inventory.activated = false
	end
	if warpTransition.sameSectionTransition == warpTransition.TRANSITION_PAN then
		inventory.activated = false
	end
	if pausemenu.pauseactivated == false then
		inventory.activated = false
	end
	if pausemenu.paused == true then
		inventory.activated = false
	end
	
	if inventory.hidden == false then
		if SaveData.resolution == "fullscreen" or SaveData.resolution == "widescreen" or SaveData.resolution == "ultrawide" or SaveData.resolution == "gameboy" or SaveData.resolution == "gba" or SaveData.resolution == "3ds" then
			Graphics.drawImageWP(inventorysmol, 32, 538, -1.86) -- draws the inventory
			
				numx = 40
				numy = 570

			if SaveData.inventory.shroom >= 10 then
				Text.printWP(SaveData.inventory.shroom, numx-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.shroom, numx, numy, -1.9)
			end

			if SaveData.inventory.fire >= 10 then
				Text.printWP(SaveData.inventory.fire, numx-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.fire, numx+32, numy, -1.9)
			end

			if SaveData.inventory.ice >= 10 then
				Text.printWP(SaveData.inventory.ice, numx+64-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.ice, numx+64, numy, -1.9)
			end

			if SaveData.inventory.leaf >= 10 then
				Text.printWP(SaveData.inventory.leaf, numx+96-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.leaf, numx+96, numy, -1.9)
			end

			if SaveData.inventory.tanooki >= 10 then
				Text.printWP(SaveData.inventory.tanooki, numx+128-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.tanooki, numx+128, numy, -1.9)
			end

			if SaveData.inventory.hammer >= 10 then
				Text.printWP(SaveData.inventory.hammer, numx+160-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.hammer, numx+160, numy, -1.9)
			end



			if SaveData.inventory.shroom == 0 then
				Graphics.drawImageWP(noshroomsmol, 32, 538, -1.981)
			end
			if SaveData.inventory.fire == 0 then
				Graphics.drawImageWP(nofiresmol, 64, 538, -1.981)
			end
			if SaveData.inventory.ice == 0 then
				Graphics.drawImageWP(noicesmol, 96, 538, -1.981)
			end
			if SaveData.inventory.leaf == 0 then
				Graphics.drawImageWP(noleafsmol, 128, 538, -1.981)
			end
			if SaveData.inventory.tanooki == 0 then
				Graphics.drawImageWP(notanookismol, 160, 538, -1.981)
			end
			if SaveData.inventory.hammer == 0 then
				Graphics.drawImageWP(nohammersmol, 192, 538, -1.981)
			end
		end
		if SaveData.resolution == "nes" then
			Graphics.drawImageWP(inventorysmol, 92, 518, -1.86) -- draws the inventory
			
				numx = 100
				numy = 550

			if SaveData.inventory.shroom >= 10 then
				Text.printWP(SaveData.inventory.shroom, numx-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.shroom, numx, numy, -1.9)
			end

			if SaveData.inventory.fire >= 10 then
				Text.printWP(SaveData.inventory.fire, numx-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.fire, numx+32, numy, -1.9)
			end

			if SaveData.inventory.ice >= 10 then
				Text.printWP(SaveData.inventory.ice, numx+64-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.ice, numx+64, numy, -1.9)
			end

			if SaveData.inventory.leaf >= 10 then
				Text.printWP(SaveData.inventory.leaf, numx+96-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.leaf, numx+96, numy, -1.9)
			end

			if SaveData.inventory.tanooki >= 10 then
				Text.printWP(SaveData.inventory.tanooki, numx+128-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.tanooki, numx+128, numy, -1.9)
			end

			if SaveData.inventory.hammer >= 10 then
				Text.printWP(SaveData.inventory.hammer, numx+160-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.hammer, numx+160, numy, -1.9)
			end



			if SaveData.inventory.shroom == 0 then
				Graphics.drawImageWP(noshroomsmol, 92, 518, -1.981)
			end
			if SaveData.inventory.fire == 0 then
				Graphics.drawImageWP(nofiresmol, 124, 518, -1.981)
			end
			if SaveData.inventory.ice == 0 then
				Graphics.drawImageWP(noicesmol, 156, 518, -1.981)
			end
			if SaveData.inventory.leaf == 0 then
				Graphics.drawImageWP(noleafsmol, 284, 518, -1.981)
			end
			if SaveData.inventory.tanooki == 0 then
				Graphics.drawImageWP(notanookismol, 220, 518, -1.981)
			end
			if SaveData.inventory.hammer == 0 then
				Graphics.drawImageWP(nohammersmol, 252, 518, -1.981)
			end
		end
		if SaveData.resolution == "iphone1st" then
			Graphics.drawImageWP(inventorysmol, 202, 538, -1.86) -- draws the inventory
			
				numx = 210
				numy = 570

			if SaveData.inventory.shroom >= 10 then
				Text.printWP(SaveData.inventory.shroom, numx-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.shroom, numx, numy, -1.9)
			end

			if SaveData.inventory.fire >= 10 then
				Text.printWP(SaveData.inventory.fire, numx-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.fire, numx+32, numy, -1.9)
			end

			if SaveData.inventory.ice >= 10 then
				Text.printWP(SaveData.inventory.ice, numx+64-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.ice, numx+64, numy, -1.9)
			end

			if SaveData.inventory.leaf >= 10 then
				Text.printWP(SaveData.inventory.leaf, numx+96-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.leaf, numx+96, numy, -1.9)
			end

			if SaveData.inventory.tanooki >= 10 then
				Text.printWP(SaveData.inventory.tanooki, numx+128-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.tanooki, numx+128, numy, -1.9)
			end

			if SaveData.inventory.hammer >= 10 then
				Text.printWP(SaveData.inventory.hammer, numx+160-10, numy, -1.9)
			else
				Text.printWP(SaveData.inventory.hammer, numx+160, numy, -1.9)
			end



			if SaveData.inventory.shroom == 0 then
				Graphics.drawImageWP(noshroomsmol, 202, 538, -1.981)
			end
			if SaveData.inventory.fire == 0 then
				Graphics.drawImageWP(nofiresmol, 244, 538, -1.981)
			end
			if SaveData.inventory.ice == 0 then
				Graphics.drawImageWP(noicesmol,276, 538, -1.981)
			end
			if SaveData.inventory.leaf == 0 then
				Graphics.drawImageWP(noleafsmol, 308, 538, -1.981)
			end
			if SaveData.inventory.tanooki == 0 then
				Graphics.drawImageWP(notanookismol, 340, 538, -1.981)
			end
			if SaveData.inventory.hammer == 0 then
				Graphics.drawImageWP(nohammersmol, 372, 538, -1.981)
			end
		end
	end
end


function inventory.onInputUpdate()

--this bit makes sure the inventory doesn't clash with dialogue systems
	if inventoryopen == false then
		if player.keys.up == KEYS_PRESSED then
			inventory.activateinventory = false
		end
		if player.keys.down == KEYS_PRESSED then
			inventory.activateinventory = false
		end
		if pausemenu.pauseactivated == false then
			if player.rawKeys.dropItem == KEYS_PRESSED then
				player.rawKeys.dropItem = KEYS_UNPRESSED
			end
		end
		if pausemenu.pauseactivated == true then
			if player.rawKeys.dropItem == KEYS_PRESSED then
				--Nothing
			end
		end
	end
	if inventory.activated == true and inventory.hidden == false then
		if player.rawKeys.dropItem == KEYS_PRESSED then -- toggle inventory menu
			inventory.activateinventory = true
			inventory.inventoryopened = not inventory.inventoryopened
			if inventory.inventoryopened == false and player.rawKeys.dropItem == KEYS_PRESSED then
				inventoryopen = false
				inventory.inventoryopened = false
				Audio.playSFX(Misc.resolveFile("inventorystuff/invclose.wav"))
				Misc.unpause()
				state = 1
				globalgenerals.showitembox = false
			elseif inventory.inventoryopened == true and player.rawKeys.dropItem == KEYS_PRESSED then
				inventoryopen = true
				inventory.inventoryopened = true
				Audio.playSFX(Misc.resolveFile("inventorystuff/invopen.wav"))
				Misc.pause()
				state = 1
				globalgenerals.showitembox = true
			end
		end
	end
	if inventory.activateinventory == true then
		if inventory.inventoryopened == true then -- selects the powerup
			if player.rawKeys.jump == KEYS_PRESSED then
				if player.powerup == powerup[state] then
					Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
				elseif state == 1 then
					if SaveData.inventory.shroom > 0 then -- mushroom
						if player.powerup == 1 then
							Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
							Audio.playSFX(6)
							player.powerup = powerup[state]
							SaveData.inventory.shroom = SaveData.inventory.shroom - 1
							state = 1
							inventory.inventoryopened = false
							cooldown = 5
							Misc.unpause()
							globalgenerals.showitembox = false
							player:mem(0x11E,FIELD_BOOL,false)
							if cooldown <= 0 then
								player:mem(0x11E,FIELD_BOOL,true)
							end
						end
					elseif SaveData.inventory.shroom <= 0 then
						Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
					end
				elseif state == 2 then
					if SaveData.inventory.fire > 0 then -- SaveData.inventory.fire flower
						Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
						Audio.playSFX(6)
						player.powerup = powerup[state]
						SaveData.inventory.fire = SaveData.inventory.fire - 1
						state = 1
						inventory.inventoryopened = false
						cooldown = 5
						Misc.unpause()
						globalgenerals.showitembox = false
						player:mem(0x11E,FIELD_BOOL,false)
						if cooldown <= 0 then
							player:mem(0x11E,FIELD_BOOL,true)
						end
					elseif SaveData.inventory.fire <= 0 then
						Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
					end
				elseif state == 3 then
					if SaveData.inventory.ice > 0 then -- SaveData.inventory.ice flower
						Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
						Audio.playSFX(6)
						player.powerup = powerup[state]
						SaveData.inventory.ice = SaveData.inventory.ice - 1
						state = 1
						inventory.inventoryopened = false
						cooldown = 5
						Misc.unpause()
						globalgenerals.showitembox = false
						player:mem(0x11E,FIELD_BOOL,false)
						if cooldown <= 0 then
							player:mem(0x11E,FIELD_BOOL,true)
						end
					elseif SaveData.inventory.ice <= 0 then
						Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
					end
				elseif state == 4 then
					if SaveData.inventory.leaf > 0 then -- super SaveData.inventory.leaf
						Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
						Audio.playSFX(34)
						player.powerup = powerup[state]
						SaveData.inventory.leaf = SaveData.inventory.leaf - 1
						state = 1
						inventory.inventoryopened = false
						cooldown = 5
						Misc.unpause()
						globalgenerals.showitembox = false
						player:mem(0x11E,FIELD_BOOL,false)
						if cooldown <= 0 then
							player:mem(0x11E,FIELD_BOOL,true)
						end
					elseif SaveData.inventory.leaf <= 0 then
						Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
					end
				elseif state == 5 then
					if SaveData.inventory.tanooki > 0 then -- SaveData.inventory.tanooki suit
						Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
						Audio.playSFX(34)
						player.powerup = powerup[state]
						SaveData.inventory.tanooki = SaveData.inventory.tanooki - 1
						state = 1
						inventory.inventoryopened = false
						cooldown = 5
						Misc.unpause()
						globalgenerals.showitembox = false
						player:mem(0x11E,FIELD_BOOL,false)
						if cooldown <= 0 then
							player:mem(0x11E,FIELD_BOOL,true)
						end
					elseif SaveData.inventory.tanooki <= 0 then
						Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
					end
				elseif state == 6 then
					if SaveData.inventory.hammer > 0 then -- SaveData.inventory.hammer suit
						Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
						Audio.playSFX(34)
						player.powerup = powerup[state]
						SaveData.inventory.hammer = SaveData.inventory.hammer - 1
						state = 1
						inventory.inventoryopened = false
						cooldown = 5
						Misc.unpause()
						globalgenerals.showitembox = false
						player:mem(0x11E,FIELD_BOOL,false)
						if cooldown <= 0 then
							player:mem(0x11E,FIELD_BOOL,true)
						end
					elseif SaveData.inventory.hammer <= 0 then
						Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
					end
				elseif state == 7 then
					if SaveData.inventory.reserve >= 1 then
						p = player
						Audio.playSFX(Misc.resolveFile("inventorystuff/powerupselect.wav"))
						modernReserveItems.drop(p.reservePowerup, p)
						cooldown = 5
						state = 1
						inventory.inventoryopened = false
						Misc.unpause()
						globalgenerals.showitembox = false
						player:mem(0x11E,FIELD_BOOL,false)
						if cooldown <= 0 then
							player:mem(0x11E,FIELD_BOOL,true)
						end
					elseif SaveData.inventory.reserve <= 0 then
						--modernReserveItems.dropped = false
						Audio.playSFX(Misc.resolveFile("inventorystuff/error.wav"))
					end
				end
			end
		end
	end
	if inventory.inventoryopened == true then -- move cursor right
		if player.rawKeys.right == KEYS_PRESSED then
			Audio.playSFX(Misc.resolveFile("inventorystuff/menuselect.wav"))
			selectx = selectx + 64
			state = state + 1
		end
	end
	if inventory.inventoryopened == true then -- move cursor left
		if player.rawKeys.left == KEYS_PRESSED then
			Audio.playSFX(Misc.resolveFile("inventorystuff/menuselect.wav"))
			selectx = selectx - 64
			state = state - 1
		end
	end
	if SaveData.resolution == "fullscreen" or SaveData.resolution == "widescreen" or SaveData.resolution == "ultrawide" or SaveData.resolution == "gameboy" or SaveData.resolution == "gba" or SaveData.resolution == "3ds" then
		if inventory.inventoryopened == true then -- if the cursor is on the far right or left, it will loop around
			if selectx < 30 then
				selectx = 30 + 384
			end 
		end
		if inventory.inventoryopened == true then
			if selectx > 30 + 414 then
				selectx = 30
			end 
		end
		if inventory.inventoryopened == true then
			if state > 7 then
				state = 1
			end
		end
		if inventory.inventoryopened == true then
			if state < 1 then
				state = 7
			end
		end
	end
	if SaveData.resolution == "nes" then
		if inventory.inventoryopened == true then -- if the cursor is on the far right or left, it will loop around
			if selectx < 90 then
				selectx = 90 + 384
			end 
		end
		if inventory.inventoryopened == true then
			if selectx > 90 + 414 then
				selectx = 90
			end 
		end
		if inventory.inventoryopened == true then
			if state > 7 then
				state = 1
			end
		end
		if inventory.inventoryopened == true then
			if state < 1 then
				state = 7
			end
		end
	end
	if SaveData.resolution == "iphone1st" then
		if inventory.inventoryopened == true then -- if the cursor is on the far right or left, it will loop around
			if selectx < 190 then
				selectx = 190 + 384
			end 
		end
		if inventory.inventoryopened == true then
			if selectx > 190 + 414 then
				selectx = 190
			end 
		end
		if inventory.inventoryopened == true then
			if state > 7 then
				state = 1
			end
		end
		if inventory.inventoryopened == true then
			if state < 1 then
				state = 7
			end
		end
	end
	if inventory.inventoryopened == false then
		globalgenerals.showitembox = false
	end
end

return inventory