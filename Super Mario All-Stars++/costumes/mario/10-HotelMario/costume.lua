local playerManager = require("playerManager")
local extrasounds = require("extrasounds")
local smasHud = require("smasHud")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

local plr
local mariohp
local hit = false

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPostPlayerHarm")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onPlayerKill")
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    mariohp = 2
end

function costume.onPostNPCKill(npc, harmType)
    local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
    local healitems = table.map{9,184,185,249,14,182,183,34,169,170,277,264}
    if healitems[npc.id] and Colliders.collide(plr, npc) then
        mariohp = mariohp + 1
    end
end

local timeddelay = 0
local heartfull = Graphics.loadImageResolved("hardcoded/hardcoded-36-1.png")
local heartempty = Graphics.loadImageResolved("hardcoded/hardcoded-36-2.png")

function costume.onDraw()
    if SaveData.toggleCostumeAbilities == true then
        if Level.endState() == 0 and not GameData.winStateActive or GameData.winStateActive == nil then
            if Timer.getValue() == 100 then
                timeddelay = timeddelay + 1
                if timeddelay == 1 then
                    Sound.playSFX("mario/10-HotelMario/hm-gottabequick")
                end
            else
                timeddelay = 0
            end
        end
        --Health system
        if plr.powerup <= 1 then
            plr.powerup = 2
        end
        if mariohp > 3 then
            mariohp = 3
        end
        if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL or player.forcedState == FORCEDSTATE_POWERDOWN_FIRE or player.forcedState == FORCEDSTATE_POWERDOWN_ICE then
            player.forcedState = FORCEDSTATE_NONE
            player:mem(0x140, FIELD_WORD, 150)
        end
        if smasHud.visible.customitembox then
            if mariohp <= 0 then
                Graphics.drawImageWP(heartempty, 357,  80, -4.2)
                Graphics.drawImageWP(heartempty, 388,  80, -4.2)
                Graphics.drawImageWP(heartempty, 421,  80, -4.2)
            end
            if mariohp == 1 then
                Graphics.drawImageWP(heartfull, 357,  80, -4.2)
                Graphics.drawImageWP(heartempty, 388,  80, -4.2)
                Graphics.drawImageWP(heartempty, 421,  80, -4.2)
            end
            if mariohp == 2 then
                Graphics.drawImageWP(heartfull, 357,  80, -4.2)
                Graphics.drawImageWP(heartfull, 388,  80, -4.2)
                Graphics.drawImageWP(heartempty, 421,  80, -4.2)
            end
            if mariohp >= 3 then
                Graphics.drawImageWP(heartfull, 357,  80, -4.2)
                Graphics.drawImageWP(heartfull, 388,  80, -4.2)
                Graphics.drawImageWP(heartfull, 421,  80, -4.2)
            end
        end
    end
end

function costume.hphit()
    if SaveData.toggleCostumeAbilities == true then
        if not player.hasStarman and not player.isMega then
            hit = true
            if hit then
                mariohp = mariohp - 1
            end
            if mariohp < 1 then
                player:kill()
            end
        end
    end
end

function costume.onPlayerHarm()
    costume.hphit()
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
end

Misc.storeLatestCostumeData(costume)

return costume