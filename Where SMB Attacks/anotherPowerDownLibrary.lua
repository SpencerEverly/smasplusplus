-------------------------------------------------------
--[[anotherPowerDownLibrary.lua v1.1.2 by KBM-Quine]]--
--[[              with code help from:             ]]--
--[[         rixithechao, Enjl, and Hoeloe         ]]--
-------------------------------------------------------
local anotherPowerDownLibrary = {}
local pm = require("playermanager")
local bowser
if not isOverworld then
    bowser = require("characters/bowser")
end

anotherPowerDownLibrary.enabled = true
anotherPowerDownLibrary.customForcedState = 751
anotherPowerDownLibrary.powerDownSFX = 5

local usableCharacters = { --most characters either don't work with it or have unique enough gameplay that warrants exclusion
    [CHARACTER_MARIO] = true,
    [CHARACTER_LUIGI] = true,
    [CHARACTER_PEACH] = false,
    [CHARACTER_TOAD] = false,
    [CHARACTER_LINK] = false,
    [CHARACTER_MEGAMAN] = false,
    [CHARACTER_WARIO] = true,
    [CHARACTER_BOWSER] = false, --bowser is coded to work, but will be disabled by default
    [CHARACTER_KLONOA] = false,
    [CHARACTER_NINJABOMBERMAN] = false,
    [CHARACTER_ROSALINA] = false,
    [CHARACTER_SNAKE] = false,
    [CHARACTER_ZELDA] = true,
    [CHARACTER_ULTIMATERINKA] = false,
    [CHARACTER_UNCLEBROADSWORD] = true,
    [CHARACTER_SAMUS] = false
}

function anotherPowerDownLibrary.setCharacterActive(charID, bool)
    usableCharacters[charID] = bool
end

function anotherPowerDownLibrary.onInitAPI()
    registerEvent(anotherPowerDownLibrary, "onTick", "onTick", true)
    registerEvent(anotherPowerDownLibrary, "onPlayerHarm", "onPlayerHarm", true)
end

function anotherPowerDownLibrary.onPlayerHarm(event, p)
    if usableCharacters[p.character] and anotherPowerDownLibrary.enabled then
        if p.character == CHARACTER_UNCLEBROADSWORD or p.character == CHARACTER_BOWSER then
            event.cancelled = false
        elseif p.powerup > 2 and p.mount == MOUNT_NONE and not p:mem(0x0C, FIELD_BOOL) and p:mem(0x16, FIELD_WORD) < 3 and not p.hasStarman then
            event.cancelled = true
            SFX.play(anotherPowerDownLibrary.powerDownSFX)
            p.forcedState = anotherPowerDownLibrary.customForcedState
        end
    end
end

local playerData = {}

function anotherPowerDownLibrary.onTick()
    if not isOverworld and anotherPowerDownLibrary.enabled then
        for _, p in ipairs(Player.get()) do
            local ps = PlayerSettings.get(pm.getCharacters()[p.character].base, p.powerup)
            playerData[p] = playerData[p] or {}
            playerData[p].curState = playerData[p].curState or 0

            if p.BlinkTimer == 120 and p.character == CHARACTER_UNCLEBROADSWORD and playerData[p].curState ~= PLAYER_BIG then --allows uncle broadsword to use this libaray without overwriting his unique mechanics
                p.powerup = PLAYER_BIG
            end
            if p.BlinkTimer > 0 and p.character == CHARACTER_BOWSER then --allows bowser to use this libaray without overwriting his unique mechanics
                if playerData[p].curState > PLAYER_BIG then
                    if bowser ~= nil then
                        bowser.setHP(2)
                    end
                end
                return
            end
            
            if p.forcedTimer == 0 then --if a forcedState timer isn't active, track player powerup
                playerData[p].curState = p.powerup
            end
            if p.forcedState == anotherPowerDownLibrary.customForcedState then --taken from modPlayer.bas, line 7477
                if p:mem(0x12E, FIELD_BOOL) then --ducking state, seemingly wouldn't work if using player.InDuckingPosition?
                    p:mem(0x132, FIELD_BOOL, true) --standing value?? seems to corrilates to .stand in modPlayer.bas, is player.Unknown132
                    p:mem(0x12E, FIELD_BOOL, false)
                    p.height = ps.hitboxHeight
                    p.y = p.y - ps.hitboxHeight + ps.hitboxDuckHeight
                end
                p.forcedTimer = p.forcedTimer + 1
                p.CurrentPlayerSprite = 1
                if p.forcedTimer % 5 == 0 then
                    if p.powerup == PLAYER_BIG then
                        p.powerup = playerData[p].curState
                    else
                        p.powerup = PLAYER_BIG
                    end
                end
                if p.forcedTimer >= 50 then
                    if p.powerup == playerData[p].curState then
                        p.powerup = PLAYER_BIG
                    end
                    p.BlinkTimer = 150
                    p.BlinkState = true
                    p.forcedState = 0
                    p.forcedTimer = 0
                end
            end
        end
    end
end

return anotherPowerDownLibrary