local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smashud = require("smashud")
local rng = require("base/rng")
local smasfunctions = require("smasfunctions")

local costume = {}

costume.loadedSounds = false

local plr
local characterhp
local hit = false

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPostPlayerHarm")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onPlayerKill")
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onKeyboardPress")
    registerEvent(costume,"onControllerButtonPress")
    
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
    Graphics.sprites.npc[266].img = Graphics.loadImageResolved("costumes/toad/LEGOStarWars-RebelTrooper/laser.png")
    
    Defines.jumpheight = 22
    Defines.player_walkspeed = 3.4
    Defines.player_runspeed = 4.7
    Defines.jumpheight_bounce = 36
    Defines.projectilespeedx = 7
    Defines.player_grav = 0.38
    
    smashud.visible.itembox = false
    characterhp = 3
    costume.useLaser1 = false
    costume.abilitesenabled = true
end

local function harmNPC(npc,...) -- npc:harm but it returns if it actually did anything
    local oldKilled     = npc:mem(0x122,FIELD_WORD)
    local oldProjectile = npc:mem(0x136,FIELD_BOOL)
    local oldHitCount   = npc:mem(0x148,FIELD_FLOAT)
    local oldImmune     = npc:mem(0x156,FIELD_WORD)
    local oldID         = npc.id
    local oldSpeedX     = npc.speedX
    local oldSpeedY     = npc.speedY

    npc:harm(...)

    return (
           oldKilled     ~= npc:mem(0x122,FIELD_WORD)
        or oldProjectile ~= npc:mem(0x136,FIELD_BOOL)
        or oldHitCount   ~= npc:mem(0x148,FIELD_FLOAT)
        or oldImmune     ~= npc:mem(0x156,FIELD_WORD)
        or oldID         ~= npc.id
        or oldSpeedX     ~= npc.speedX
        or oldSpeedY     ~= npc.speedY
    )
end

local shootingframe = 10

function costume.shootLaser1()
    --plr:mem(0x172, FIELD_BOOL, false) --Make sure run isn't pressed again until cooldown is over, in case
    local x = plr.x
    local y = plr.y + plr.height/2 - 5
    if (plr.direction == 1) then
        x = x + plr.width
    end
    local gunid = 266
    local gunNpc = NPC.spawn(gunid, x, y, player.section, false, true)
    Sound.playSFX(smascharacterglobals.soundSettings.rebelTrooperBlasterSFX)
    costume.useLaser1 = true
    gunNpc.frames = 1
    if (plr.direction == 1) then
        gunNpc.speedX = 14.5
        gunNpc.speedY = 0
    else
        gunNpc.speedX = -14.5
        gunNpc.speedY = 0
    end
    cooldown = 15
    if cooldown <= 0 then
        plr:mem(0x172, FIELD_BOOL, true)
        costume.useLaser1 = false
    end
end

function costume.onPostNPCKill(npc, harmType)
    local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
    local healitems = table.map{9,184,185,249,14,182,183,34,169,170,277,264}
    if healitems[npc.id] and Colliders.collide(plr, npc) then
        characterhp = characterhp + 1
    end
end

function costume.onKeyboardPress(keyCode, repeated)
    if SaveData.toggleCostumeAbilities then
        if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
            if (player.powerup == 5) == false then
                if smascharacterglobals.abilitySettings.rebelTrooperCanShootBlaster then
                    costume.shootLaser1()
                end
            end
        end
    end
end

function costume.onControllerButtonPress(button, playerIdx)
    if SaveData.toggleCostumeAbilities then
        if playerIdx == 1 then
            if button == SaveData.specialbutton1stplayer then
                if (player.powerup == 5) == false then
                    if smascharacterglobals.abilitySettings.rebelTrooperCanShootBlaster then
                        costume.shootLaser1()
                    end
                end
            end
        end
    end
end

function costume.onTick()
    if SaveData.toggleCostumeAbilities then
        if player:isOnGround() or player:isClimbing() then --Checks to see if the player is on the ground, is climbing, is not underwater (smasfunctions), the death timer is at least 0, the end state is none, or the mount is a clown car
            hasJumped = false
        elseif (not hasJumped) and player.keys.jump == KEYS_PRESSED and player.deathTimer == 0 and Level.endState() == 0 and player.mount == 0 and not Playur.underwater(player) then
            if smascharacterglobals.abilitySettings.rebelTrooperCanDoubleJump then
                hasJumped = true
                player:mem(0x11C, FIELD_WORD, 10)
                if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                    Sound.playSFX(smascharacterglobals.soundSettings.rebelTrooperDoubleJumpSFX)
                end
            end
        end
    end
end

function costume.onDraw()
    if SaveData.toggleCostumeAbilities then
        --Health system
        if smascharacterglobals.abilitySettings.rebelTrooperCanUseCustomHurtSystem then
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
        if costume.useLaser1 then
            cooldown = 15
            shootingframe = shootingframe - 1
            if shootingframe <= 9 then
                plr:setFrame(3)
            end
            if shootingframe <= 0 then
                shootingframe = 5
                plr:setFrame(nil)
                costume.useLaser1 = false
            end
        end
    end
end

function costume.hphit()
    if SaveData.toggleCostumeAbilities then
        if smascharacterglobals.abilitySettings.rebelTrooperCanUseCustomHurtSystem then
            if not player.hasStarman and not player.isMega then
                local hurtsoundrng = rng.randomInt(1,9)
                if smascharacterglobals.soundSettings.rebelTrooperCanUseHurtSFX then
                    Sound.playSFX("toad/LEGOStarWars-RebelTrooper/hit/"..hurtsoundrng..".ogg")
                end
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
end

function costume.onPlayerHarm()
    costume.hphit()
end

function costume.onCleanup(p)
    for i = 1,91 do
        Audio.sounds[i].sfx = nil
    end
    for i = 1,165 do
        extrasounds.sound.sfx[i] = nil
    end
    
    Graphics.sprites.npc[266].img = nil
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
    
    smashud.visible.itembox = true
    costume.abilitesenabled = false
end

return costume