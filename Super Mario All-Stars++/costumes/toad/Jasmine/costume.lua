local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smashud = require("smashud")
local rng = require("base/rng")

local costume = {}
local characterhp
local plr

function costume.onInit(p)
	plr = p
	registerEvent(costume,"onTick")
	registerEvent(costume,"onDraw")
	registerEvent(costume,"onPostPlayerHarm")
	Audio.sounds[1].sfx = Audio.SfxOpen("costumes/toad/Jasmine/player-jump.ogg")
	
	smashud.visible.itembox = false
	characterhp = 3
end

function costume.onTick()
	if SaveData.toggleCostumeAbilities == true then
		if player:isOnGround() or player:isClimbing() then --Checks to see if the player is on the ground, is climbing, is not underwater (smasfunctions), the death timer is at least 0, the end state is none, or the mount is a clown car
			hasJumped = false
		elseif (not hasJumped) and player.keys.jump == KEYS_PRESSED and player.deathTimer == 0 and Level.endState() == 0 and player.mount == 0 and not isPlayerUnderwater() then
			hasJumped = true
			player:mem(0x11C, FIELD_WORD, 14)
			if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
				playSound("toad/Jasmine/player-doublejump.ogg")
			end
		end
	end
end

function costume.onDraw()
	if SaveData.toggleCostumeAbilities == true then
		--Health system
		if plr.powerup <= 1 then
			plr.powerup = 2
		end
		if characterhp > 3 then
			characterhp = 3
		end
		if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL or player.forcedState == FORCEDSTATE_POWERDOWN_FIRE or player.forcedState == FORCEDSTATE_POWERDOWN_ICE then
			player.forcedState = FORCEDSTATE_NONE
			player:mem(0x140, FIELD_WORD, 150)
		end
		if smashud.visible.customitembox == true then
			local heartfull = Graphics.loadImageResolved("hardcoded/hardcoded-36-1.png")
			local heartempty = Graphics.loadImageResolved("hardcoded/hardcoded-36-2.png")
			if characterhp <= 0 then
				Graphics.drawImageWP(heartempty, 357,  16, -4.2)
				Graphics.drawImageWP(heartempty, 388,  16, -4.2)
				Graphics.drawImageWP(heartempty, 421,  16, -4.2)
			end
			if characterhp == 1 then
				Graphics.drawImageWP(heartfull, 357,  16, -4.2)
				Graphics.drawImageWP(heartempty, 388,  16, -4.2)
				Graphics.drawImageWP(heartempty, 421,  16, -4.2)
			end
			if characterhp == 2 then
				Graphics.drawImageWP(heartfull, 357,  16, -4.2)
				Graphics.drawImageWP(heartfull, 388,  16, -4.2)
				Graphics.drawImageWP(heartempty, 421,  16, -4.2)
			end
			if characterhp >= 3 then
				Graphics.drawImageWP(heartfull, 357,  16, -4.2)
				Graphics.drawImageWP(heartfull, 388,  16, -4.2)
				Graphics.drawImageWP(heartfull, 421,  16, -4.2)
			end
			if player.powerup == 3 then
				Text.printWP("FIRE FLOWER", 310, 60, -4.2)
			end
			if player.powerup == 4 then
				Text.printWP("SUPER LEAF", 310, 60, -4.2)
			end
			if player.powerup == 5 then
				Text.printWP("TANOOKI SUIT", 290, 60, -4.2)
			end
			if player.powerup == 6 then
				Text.printWP("HAMMER SUIT", 302, 60, -4.2)
			end
			if player.powerup == 7 then
				Text.printWP("ICE FLOWER", 316, 60, -4.2)
			end
		end
	end
end

function costume.hphit()
	if SaveData.toggleCostumeAbilities == true then
		if not player.hasStarman and not player.isMega then
			local hurtsoundrng = rng.randomInt(1,9)
			playSound("toad/Jasmine/hit/"..hurtsoundrng..".ogg")
			hit = true
			if hit then
				characterhp = characterhp - 1
			end
			if characterhp < 1 then
				player:kill()
			end
		end
	end
end

function costume.onPostPlayerHarm()
	costume.hphit()
end

function costume.onCleanup(p)
	Audio.sounds[1].sfx = nil
end

return costume