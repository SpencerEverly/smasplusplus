local pm = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasHud = require("smasHud")
local rng = require("base/rng")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

local characterhp
local plr

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPostPlayerHarm")
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    smasHud.visible.itemBox = false
    characterhp = 3
end

function costume.onTick()
    if SaveData.toggleCostumeAbilities then
        if player:isOnGround() or player:isClimbing() then --Checks to see if the player is on the ground, is climbing, is not underwater (smasFunctions), the death timer is at least 0, the end state is none, or the mount is a clown car
            hasJumped = false
        elseif (not hasJumped) and player.keys.jump == KEYS_PRESSED and player.deathTimer == 0 and Level.endState() == 0 and player.mount == 0 and not isPlayerUnderwater(player) then
            if smasCharacterGlobals.abilitySettings.jasmineCanDoubleJump then
                hasJumped = true
                player:mem(0x11C, FIELD_WORD, 14)
                if not table.icontains(smasTables._noLevelPlaces,Level.filename()) then
                    Sound.playSFX(smasCharacterGlobals.soundSettings.jasmineDoubleJumpSFX)
                end
            end
        end
    end
end

function costume.onDraw()
    if SaveData.toggleCostumeAbilities then
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
        if smasHud.visible.customItemBox == true then
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
    if SaveData.toggleCostumeAbilities then
        if not player.hasStarman and not player.isMega then
            local hurtsoundrng = rng.randomInt(1,9)
            Sound.playSFX("toad/Jasmine/hit/"..hurtsoundrng..".ogg")
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
    Sound.cleanupCostumeSounds()
end

Misc.storeLatestCostumeData(costume)

return costume