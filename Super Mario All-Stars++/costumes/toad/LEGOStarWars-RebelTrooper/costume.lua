local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smashud = require("smashud")
local rng = require("base/rng")

local costume = {}

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
    
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/toad/LEGOStarWars-RebelTrooper/player-jump.ogg")
    Audio.sounds[6].sfx   = Audio.SfxOpen("costumes/toad/LEGOStarWars-RebelTrooper/player-grow.ogg")
    extrasounds.sound.sfx[8]     = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/LEGOStarWars-RebelTrooper/player-died.ogg"))
    extrasounds.sound.sfx[14]    = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/LEGOStarWars-RebelTrooper/coin.ogg"))
    Audio.sounds[34].sfx  = Audio.SfxOpen("costumes/toad/LEGOStarWars-RebelTrooper/racoon.ogg")
    Audio.sounds[46].sfx  = Audio.SfxOpen("costumes/toad/LEGOStarWars-RebelTrooper/door.ogg")
    Audio.sounds[52].sfx  = Audio.SfxOpen("costumes/toad/LEGOStarWars-RebelTrooper/got-star.ogg")
    extrasounds.sound.sfx[59]    = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/LEGOStarWars-RebelTrooper/dragon-coin.ogg"))
    extrasounds.sound.sfx[99]    = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/LEGOStarWars-RebelTrooper/dragon-coin-get2.ogg")) --Dragon Coin #2
    extrasounds.sound.sfx[100]   = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/LEGOStarWars-RebelTrooper/dragon-coin-get3.ogg")) --Dragon Coin #3
    extrasounds.sound.sfx[101]   = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/LEGOStarWars-RebelTrooper/dragon-coin-get4.ogg")) --Dragon Coin #4
    extrasounds.sound.sfx[102]   = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/LEGOStarWars-RebelTrooper/dragon-coin-get5.ogg")) --Dragon Coin #5
    
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
    plr:mem(0x172, FIELD_BOOL, false) --Make sure run isn't pressed again until cooldown is over, in case
    local x = plr.x
    local y = plr.y + plr.height/2 - 5
    if (plr.direction == 1) then
        x = x + plr.width
    end
    local gunid = 266
    local gunNpc = NPC.spawn(gunid, x, y, player.section, false, true)
    Sound.playSFX("toad/LEGOStarWars-RebelTrooper/blaster.ogg")
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

function costume.onInputUpdate()
    if player.keys.altRun == KEYS_PRESSED then
        if (player.powerup == 5) == false then
            costume.shootLaser1()
        end
    end
end

function costume.onTick()
    if SaveData.toggleCostumeAbilities == true then
        if player:isOnGround() or player:isClimbing() then --Checks to see if the player is on the ground, is climbing, is not underwater (smasfunctions), the death timer is at least 0, the end state is none, or the mount is a clown car
            hasJumped = false
        elseif (not hasJumped) and player.keys.jump == KEYS_PRESSED and player.deathTimer == 0 and Level.endState() == 0 and player.mount == 0 and not isPlayerUnderwater(player) then
            hasJumped = true
            player:mem(0x11C, FIELD_WORD, 10)
            if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
                Sound.playSFX("toad/LEGOStarWars-RebelTrooper/player-doublejump.ogg")
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
    if SaveData.toggleCostumeAbilities == true then
        if not player.hasStarman and not player.isMega then
            local hurtsoundrng = rng.randomInt(1,9)
            Sound.playSFX("toad/LEGOStarWars-RebelTrooper/hit/"..hurtsoundrng..".ogg")
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

function costume.onPlayerHarm()
    costume.hphit()
end

function costume.onCleanup(p)
    extrasounds.sound.sfx[1] = nil    
    Audio.sounds[2].sfx  = nil
    Audio.sounds[3].sfx  = nil
    extrasounds.sound.sfx[4] = nil
    Audio.sounds[5].sfx  = nil
    Audio.sounds[6].sfx  = nil
    extrasounds.sound.sfx[7] = nil
    extrasounds.sound.sfx[8] = nil
    Audio.sounds[9].sfx  = nil
    extrasounds.sound.sfx[10] = nil
    Audio.sounds[11].sfx = nil
    Audio.sounds[12].sfx = nil
    Audio.sounds[13].sfx = nil
    extrasounds.sound.sfx[14] = nil
    extrasounds.sound.sfx[15] = nil
    Audio.sounds[16].sfx = nil
    Audio.sounds[17].sfx = nil
    extrasounds.sound.sfx[18] = nil
    Audio.sounds[19].sfx = nil
    Audio.sounds[20].sfx = nil
    Audio.sounds[21].sfx = nil
    Audio.sounds[22].sfx = nil
    Audio.sounds[23].sfx = nil
    Audio.sounds[24].sfx = nil
    Audio.sounds[25].sfx = nil
    Audio.sounds[29].sfx = nil
    Audio.sounds[31].sfx = nil
    Audio.sounds[32].sfx = nil
    extrasounds.sound.sfx[33] = nil
    Audio.sounds[34].sfx = nil
    Audio.sounds[35].sfx = nil
    extrasounds.sound.sfx[36] = nil
    Audio.sounds[37].sfx = nil
    Audio.sounds[38].sfx = nil
    extrasounds.sound.sfx[39] = nil
    Audio.sounds[41].sfx = nil
    extrasounds.sound.sfx[42] = nil
    extrasounds.sound.sfx[43] = nil
    Audio.sounds[44].sfx = nil
    Audio.sounds[46].sfx = nil
    Audio.sounds[47].sfx = nil
    Audio.sounds[48].sfx = nil
    Audio.sounds[49].sfx = nil
    Audio.sounds[50].sfx = nil
    Audio.sounds[51].sfx = nil
    Audio.sounds[52].sfx = nil
    Audio.sounds[54].sfx = nil
    Audio.sounds[55].sfx = nil
    Audio.sounds[56].sfx = nil
    Audio.sounds[57].sfx = nil
    Audio.sounds[58].sfx = nil
    extrasounds.sound.sfx[59] = nil
    Audio.sounds[61].sfx = nil
    Audio.sounds[62].sfx = nil
    Audio.sounds[63].sfx = nil
    Audio.sounds[71].sfx = nil
    Audio.sounds[72].sfx = nil
    Audio.sounds[73].sfx = nil
    Audio.sounds[75].sfx = nil
    Audio.sounds[76].sfx = nil
    extrasounds.sound.sfx[77] = nil
    Audio.sounds[78].sfx = nil
    Audio.sounds[79].sfx = nil
    Audio.sounds[80].sfx = nil
    extrasounds.sound.sfx[81] = nil
    Audio.sounds[82].sfx = nil
    Audio.sounds[91].sfx = nil
    extrasounds.sound.sfx[92] = nil
    extrasounds.sound.sfx[93] = nil
    extrasounds.sound.sfx[94] = nil
    extrasounds.sound.sfx[95] = nil
    extrasounds.sound.sfx[96] = nil
    extrasounds.sound.sfx[97] = nil
    extrasounds.sound.sfx[98] = nil
    extrasounds.sound.sfx[99] = nil
    extrasounds.sound.sfx[100] = nil
    extrasounds.sound.sfx[101] = nil
    extrasounds.sound.sfx[102] = nil
    extrasounds.sound.sfx[103] = nil
    extrasounds.sound.sfx[104] = nil
    extrasounds.sound.sfx[105] = nil
    extrasounds.sound.sfx[106] = nil
    extrasounds.sound.sfx[107] = nil
    extrasounds.sound.sfx[108] = nil
    extrasounds.sound.sfx[109] = nil
    extrasounds.sound.sfx[110] = nil
    extrasounds.sound.sfx[111] = nil
    extrasounds.sound.sfx[112] = nil
    
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