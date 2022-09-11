local playerManager = require("playerManager")
local extrasounds = require("extrasounds")
local smashud = require("smashud")
local rng = require("base/rng")
local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local costume = {}

costume.grenade = false
local eventsRegistered = false
local plr
local borishp
local hit = false
local cooldown = 0

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onStart")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onTickEnd")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onPlayerKill")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onNPCKill")
    registerEvent(costume,"onNPCHarm")
    registerEvent(costume,"onKeyboardPress")
    registerEvent(costume,"onControllerButtonPress")
    
    npcManager.registerEvent(291, costume, "onTickEndNPC")
    
    extrasounds.sound.sfx[1] = Audio.SfxOpen("costumes/luigi/GA-Boris/player-jump.ogg")
    Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/stomped.ogg")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/player-shrink.ogg")
    Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/player-grow.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/luigi/GA-Boris/player-died.ogg")
    Audio.sounds[10].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/player-slide.ogg")
    extrasounds.sound.sfx[14]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/luigi/GA-Boris/coin.ogg"))
    extrasounds.sound.sfx[18]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/luigi/GA-Boris/fireball.ogg"))
    Audio.sounds[21].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/dungeon-win.ogg")
    Audio.sounds[23].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/grab.ogg")
    extrasounds.sound.sfx[33] = Audio.SfxOpen("costumes/luigi/GA-Boris/tail.ogg")
    Audio.sounds[34].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/racoon.ogg")
    extrasounds.sound.sfx[43] = Audio.SfxOpen("costumes/luigi/GA-Boris/fireworks.ogg")
    Audio.sounds[46].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/door.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/got-star.ogg")
    Audio.sounds[54].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/player-died2.ogg")
    Audio.sounds[73].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/grab2.ogg")
    Audio.sounds[75].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/smb2-throw.ogg")
    
    Graphics.sprites.effect[998].img = Graphics.loadImageResolved("costumes/luigi/GA-Boris/effect-998.png")
    
    costume.abilitiesenabled = true
    costume.useGun1 = false
    costume.useGrenade2 = false
    costume.grenade = true
    --smashud.visible.itembox = false
    borishp = 3
    if costume.grenade then
        local grenade = {
            id = 291,
            
            effect = 998,
            }
        
        npcManager.setNpcSettings(grenade)
    end
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

costume.grenadeID = 291
costume.goanimateExplosionID = 998

function costume.shootGun1()
    --plr:mem(0x172, FIELD_BOOL, false) --Make sure run isn't pressed again until cooldown is over, in case
    local x = plr.x
    local y = plr.y + plr.height/2 - 5
    if (plr.direction == 1) then
        x = x + plr.width
    end
    local gunid = 266
    local gunNpc = NPC.spawn(gunid, x, y, player.section, false, true)
    costume.useGun1 = true
    gunNpc.frames = 1
    if (plr.direction == 1) then
        gunNpc.speedX = 14.5
        gunNpc.speedY = 0
    else
        gunNpc.speedX = -14.5
        gunNpc.speedY = 0
    end
    costume.useGun1 = false
    cooldown = 10
    if cooldown <= 0 then
        --plr:mem(0x172, FIELD_BOOL, true)
    end
end

function costume.shootGrenade2()
    plr:mem(0x160, FIELD_WORD, 5)
    local x = plr.x
    local y = plr.y + plr.height/2 - 5
    if (plr.direction == 1) then
        x = x + plr.width
    end
    local grenadeid = 291
    local grenadeNpc = NPC.spawn(291, x, y, player.section, false, true)
    costume.useGrenade2 = true
    grenadeNpc.frames = 1
    if (plr.direction == 1) then
        grenadeNpc.speedX = 7.5
        grenadeNpc.speedY = 0.2
    else
        grenadeNpc.speedX = -7.5
        grenadeNpc.speedY = -0.2
    end
    costume.useGrenade2 = false
end

function costume.shootGrenade2Upwards()
    plr:mem(0x160, FIELD_WORD, 5)
    local x = plr.x
    local y = plr.y + plr.height/2 - 5
    if (plr.direction == 1) then
        x = x + plr.width
    end
    local grenadeid = 291
    local grenadeNpc = NPC.spawn(291, x, y, player.section, false, true)
    costume.useGrenade2 = true
    grenadeNpc.frames = 1
    if (plr.direction == 1) then
        grenadeNpc.speedX = 0
        grenadeNpc.speedY = -7.5
    else
        grenadeNpc.speedX = -0
        grenadeNpc.speedY = -7.5
    end
    costume.useGrenade2 = false
end

function costume.onNPCKill(eventToken, npc, harmType)
    if npc.id == 291 then
        local hurtNPC = harmNPC(npc,HARM_TYPE_NPC)
    end
end

function costume.onPostNPCKill(npc, harmType)
    local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
    local healitems = table.map{9,184,185,249,14,182,183,34,169,170,277,264}
    local rngkey
    if SaveData.toggleCostumeProfanity then
        rngkey = rng.randomInt(1,6)
        if items[npc.id] and Colliders.collide(plr, npc) then
            Sound.playSFX("luigi/GA-Boris/voices/items/"..rngkey..".ogg", 1, 1, 80)
        end
    else
        rngkey = rng.randomInt(3,6)
        if items[npc.id] and Colliders.collide(plr, npc) then
            Sound.playSFX("luigi/GA-Boris/voices/items/"..rngkey..".ogg", 1, 1, 80)
        end
    end
    if healitems[npc.id] and Colliders.collide(plr, npc) then
        borishp = borishp + 1
    end
    if npc.id == 291 then
        for _,v in ipairs(NPC.get(291)) do
            local explosion = Effect.spawn(998, v.x, v.y + 35, player.section, false, true)
        end
    end
end

function costume.onDraw(p)
    if SaveData.toggleCostumeAbilities == true then
        --Gun states
        if borishp == 1 or borishp == 2 and (player.powerup == 3) == false and (player.powerup == 7) == false and player.powerup == 2 then
            Graphics.sprites.npc[266].img = Graphics.loadImageResolved("costumes/luigi/GA-Boris/gunbullet-1.png")
            local gun1 = Graphics.loadImageResolved("costumes/luigi/GA-Boris/gun-1.png")
            if player.direction == -1 then
                Graphics.drawImageWP(gun1, player.x - camera.x - 14,  player.y - camera.y + 10, 0, 0, 35, 28, -24)
            end
            if player.direction == 1 then
                Graphics.drawImageWP(gun1, player.x - camera.x + 4,  player.y - camera.y + 10, 0, 28, 35, 28, -24)
            end
        end
        if borishp == 3 and (player.powerup == 3) == false and (player.powerup == 7) == false and player.powerup == 2 then
            Graphics.sprites.npc[266].img = Graphics.loadImageResolved("costumes/luigi/GA-Boris/gunbullet-1.png")
            local gun2 = Graphics.loadImageResolved("costumes/luigi/GA-Boris/gun-2.png")
            if player.direction == -1 then
                Graphics.drawImageWP(gun2, player.x - camera.x - 20,  player.y - camera.y + 10, 0, 0, 65, 23, -24)
            end
            if player.direction == 1 then
                Graphics.drawImageWP(gun2, player.x - camera.x - 14,  player.y - camera.y + 10, 0, 23, 65, 23, -24)
            end
        end
        if player.powerup == 3 or player.powerup == 7 then
            local gun4 = Graphics.loadImageResolved("costumes/luigi/GA-Boris/gun-4.png")
            if player:mem(0x160, FIELD_WORD) <= 34 and player:mem(0x160, FIELD_WORD) >= 25 then
                if player.direction == -1 then
                    Graphics.drawImageWP(gun4, player.x - camera.x - 45,  player.y - camera.y, 0, 0, 45, 38, -24)
                end
                if player.direction == 1 then
                    Graphics.drawImageWP(gun4, player.x - camera.x + 25,  player.y - camera.y, 0, 38, 45, 38, -24)
                end
            end
        end
        if borishp == 3 and player.powerup == 4 then
            Graphics.sprites.npc[266].img = Graphics.loadImageResolved("costumes/luigi/GA-Boris/gunbullet-1.png")
            local gun3 = Graphics.loadImageResolved("costumes/luigi/GA-Boris/gun-3.png")
            if player.direction == -1 then
                Graphics.drawImageWP(gun3, player.x - camera.x - 45,  player.y - camera.y + 10, 0, 0, 91, 25, -24)
            end
            if player.direction == 1 then
                Graphics.drawImageWP(gun3, player.x - camera.x - 15,  player.y - camera.y + 10, 0, 25, 91, 25, -24)
            end
        end
        if borishp == 3 and player.powerup == 5 and player:mem(0x4A, FIELD_BOOL) == false then
            Graphics.sprites.npc[266].img = Graphics.loadImageResolved("costumes/luigi/GA-Boris/gunbullet-2.png")
            local gun5 = Graphics.loadImageResolved("costumes/luigi/GA-Boris/gun-5.png")
            if player.direction == -1 then
                Graphics.drawImageWP(gun5, player.x - camera.x - 45,  player.y - camera.y + 10, 0, 30, 78, 30, -24)
            end
            if player.direction == 1 then
                Graphics.drawImageWP(gun5, player.x - camera.x - 10,  player.y - camera.y + 10, 0, 0, 78, 30, -24)
            end
        end
        if borishp == 3 and player.powerup == 6 then
            Graphics.sprites.npc[291].img = Graphics.loadImageResolved("costumes/luigi/GA-Boris/grenade.png")
        end
    end
end

function costume.onInputUpdate()
    if SaveData.toggleCostumeAbilities == true then
        if not Misc.isPaused() then
            if borishp == 1 or borishp == 2 and (player.powerup == 3) == false and (player.powerup == 7) == false and (player.powerup == 6) == false then
                if player.keys.run == KEYS_PRESSED and (player.keys.altRun == KEYS_PRESSED) == false then
                    if player:mem(0x26, FIELD_WORD) <= 1 and (player.keys.down == KEYS_PRESSED) == false then
                        Sound.playSFX("costumes/luigi/GA-Boris/gunshot-1.ogg", 1, 1, 35)
                        costume.shootGun1()
                    end
                end
            end
            if borishp == 3 and (player.powerup == 3) == false and (player.powerup == 7) == false and (player.powerup == 6) == false then
                if player.keys.run == KEYS_PRESSED and (player.keys.altRun == KEYS_PRESSED) == false then
                    if player:mem(0x26, FIELD_WORD) <= 1 and (player.keys.down == KEYS_PRESSED) == false then
                        Sound.playSFX("costumes/luigi/GA-Boris/gunshot-2.ogg", 1, 1, 35)
                        costume.shootGun1()
                    end
                end
            end
            if player.powerup == 4 then
                if player.keys.run == KEYS_PRESSED and (player.keys.altRun == KEYS_PRESSED) == false then
                    if player:mem(0x26, FIELD_WORD) <= 1 and (player.keys.down == KEYS_PRESSED) == false then
                        Sound.playSFX("costumes/luigi/GA-Boris/gunshot-3.ogg", 1, 1, 35)
                        costume.shootGun1()
                    end
                end
            end
            if player.powerup == 5 then
                if player.keys.run == KEYS_PRESSED and (player.keys.altRun == KEYS_PRESSED) == false then
                    if player:mem(0x26, FIELD_WORD) <= 1 and (player.keys.down == KEYS_PRESSED) == false then
                        Sound.playSFX("costumes/luigi/GA-Boris/gunshot-4.ogg", 1, 1, 35)
                        costume.shootGun1()
                    end
                end
            end
            if player.powerup == 6 then
                if player.keys.run == KEYS_PRESSED and (player.keys.altRun == KEYS_PRESSED) == false and (player.keys.up == KEYS_DOWN) == false then
                    Sound.playSFX("costumes/luigi/GA-Boris/grenade-launch.ogg", 1, 1, 35)
                    costume.shootGrenade2()
                end
                if player.keys.run == KEYS_PRESSED and (player.keys.altRun == KEYS_PRESSED) == false and player.keys.up == KEYS_DOWN then
                    Sound.playSFX("costumes/luigi/GA-Boris/grenade-launch.ogg", 1, 1, 35)
                    costume.shootGrenade2Upwards()
                end
            end
        end
    end
end

function costume.unmutebill()
    Routine.wait(0.1)
    Audio.sounds[22].muted = false
end

function costume.unmutehammer()
    Routine.wait(0.1)
    extrasounds.sound.sfx[105].volume = 1
    Audio.sounds[25].muted = false
end

function costume.onTick(p)
    local shootingPowerups = table.map{PLAYER_FIREFLOWER,PLAYER_ICE,PLAYER_HAMMER}
    local isShooting = (plr:mem(0x118,FIELD_FLOAT) >= 100 and plr:mem(0x118,FIELD_FLOAT) <= 118 and shootingPowerups[player.powerup])
    if SaveData.toggleCostumeAbilities == true then
        --Health system
        if plr.powerup <= 1 then
            plr.powerup = 2
        end
        if borishp > 3 then
            borishp = 3
        end
        
        
        
        --Switching frames when shooting fireballs as Boris
        if isShooting then
            plr:setFrame(27)
        end
        
        
        
        --Boris HP Hover System
        local heartfull3 = Graphics.loadImageResolved("costumes/luigi/GA-Boris/heart.png")
        if borishp <= 0 then
            
        end
        if borishp == 1 then
            Graphics.drawImageWP(heartfull3, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
        end
        if borishp == 2 then
            Graphics.drawImageWP(heartfull3, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
            Graphics.drawImageWP(heartfull3, player.x - camera.x,  player.y - camera.y - 55, -24)
        end
        if borishp >= 3 then
            Graphics.drawImageWP(heartfull3, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
            Graphics.drawImageWP(heartfull3, player.x - camera.x,  player.y - camera.y - 55, -24)
            Graphics.drawImageWP(heartfull3, player.x - camera.x + 28,  player.y - camera.y - 55, -24)
        end
        
        for index,explosion in ipairs(Animation.get(148)) do --Explosion SFX
            Audio.sounds[22].muted = true
            SFX.play("costumes/luigi/GA-Boris/grenade-explode.ogg", 1, 1, 25)
            Routine.run(costume.unmutebill)
        end
        for index,explosion in ipairs(NPC.get(291)) do --Throw SFX
            Audio.sounds[25].muted = true
            extrasounds.sound.sfx[105].volume = 0
            SFX.play("costumes/luigi/GA-Boris/grenade-launch.ogg", 1, 1, 500)
            Routine.run(costume.unmutehammer)
        end
    end
end

function costume.hphit()
    if SaveData.toggleCostumeAbilities == true then
        if not player.hasStarman and not player.isMega then
            hit = true
            if hit then
                borishp = borishp - 1
            end
            if borishp < 1 then
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
    costume.abilitiesenabled = false
    costume.grenade = false
    --smashud.visible.itembox = true
end

return costume