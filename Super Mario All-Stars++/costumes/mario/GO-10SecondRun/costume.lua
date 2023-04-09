local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smasHud = require("smasHud")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loadedSounds = false

local plr
local tensecondhp
local hit = false

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onStart")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onDrawEnd")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPostPlayerHarm")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onPlayerKill")
    registerEvent(costume,"onPostPlayerKill")
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 5
    Defines.player_runspeed = 5
    Defines.jumpheight_bounce = 24
    Defines.projectilespeedx = 6.2
    Defines.player_grav = 0.28
    
    smasHud.visible.itembox = false
    tensecondhp = 2 --This can be set, from 1-3 (Loads every level start)
    costume.abilitesenabled = true
    
    Routine = require("routine")
end

function costume.onPostNPCKill(npc, harmType)
    local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
    local healitems = table.map{9,184,185,249,14,182,183,34,169,170,277,264}
    if healitems[npc.id] and Colliders.collide(plr, npc) then
        tensecondhp = tensecondhp + 1
    end
end

function costume.onDraw()
    if SaveData.toggleCostumeAbilities == true then
        --Health system
        if plr.powerup <= 1 then
            plr.powerup = 2
        elseif plr.powerup >= 3 then
            plr.powerup = 2
        end
        if tensecondhp > 3 then
            tensecondhp = 3
        end
        if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL or player.forcedState == FORCEDSTATE_POWERDOWN_FIRE or player.forcedState == FORCEDSTATE_POWERDOWN_ICE then
            player.forcedState = FORCEDSTATE_NONE
            player:mem(0x140, FIELD_WORD, 150)
        end
        if smasHud.visible.customitembox == true then
            local heartfull = Graphics.loadImageResolved("hardcoded/hardcoded-36-1.png")
            local heartempty = Graphics.loadImageResolved("hardcoded/hardcoded-36-2.png")
            if tensecondhp <= 0 then
                Graphics.drawImageWP(heartempty, 357,  16, -4.2)
                Graphics.drawImageWP(heartempty, 388,  16, -4.2)
                Graphics.drawImageWP(heartempty, 421,  16, -4.2)
            end
            if tensecondhp == 1 then
                Graphics.drawImageWP(heartfull, 357,  16, -4.2)
                Graphics.drawImageWP(heartempty, 388,  16, -4.2)
                Graphics.drawImageWP(heartempty, 421,  16, -4.2)
            end
            if tensecondhp == 2 then
                Graphics.drawImageWP(heartfull, 357,  16, -4.2)
                Graphics.drawImageWP(heartfull, 388,  16, -4.2)
                Graphics.drawImageWP(heartempty, 421,  16, -4.2)
            end
            if tensecondhp >= 3 then
                Graphics.drawImageWP(heartfull, 357,  16, -4.2)
                Graphics.drawImageWP(heartfull, 388,  16, -4.2)
                Graphics.drawImageWP(heartfull, 421,  16, -4.2)
            end
        end
    end
end

function costume.hphit()
    if SaveData.toggleCostumeAbilities == true then
        if not player.hasStarman and not player.isMega then
            hit = true
            if hit then
                tensecondhp = tensecondhp - 1
            end
            if tensecondhp < 1 then
                player:kill()
            end
        end
    end
end

function costume.onPlayerHarm()
    costume.hphit()
end

function costume.onPostPlayerKill()
    Sound.playSFX("mario/GO-10SecondRun/fanfares/go-game-over.ogg")
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
    
    smasHud.visible.itembox = true
    costume.abilitesenabled = false
end

return costume