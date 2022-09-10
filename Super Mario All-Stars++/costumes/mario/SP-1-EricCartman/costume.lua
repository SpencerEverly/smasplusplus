local pm = require("playerManager")
local extrasounds = require("extrasounds")
local rng = require("base/rng")

local costume = {}

local cooldown = 0
local snowballymove = 0
local killed = false

local snowballImg = Graphics.loadImageResolved("costumes/mario/SP-1-EricCartman/snowball.png")

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onPlayerKill")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onKeyboardPress")
    registerEvent(costume,"onControllerButtonPress")
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-shrink.ogg")
    Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/key.ogg")
    Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/yoshi-hurt.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/got-star.ogg")
    Defines.player_walkspeed = 2
    Defines.player_runspeed = 5
    Defines.jumpheight = 17
    Defines.jumpheight_bounce = 22
    
    Graphics.sprites.npc[266].img = Graphics.loadImageResolved("costumes/mario/SP-1-EricCartman/snowball.png")
    
    costume.abilitesenabled = true
    costume.usesnowball = false
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

function costume.onKeyboardPress(keyCode, repeated)
    if SaveData.toggleCostumeAbilities == true then
        if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
            costume.throwSnowball()
        end
    end
end

function costume.onControllerButtonPress(button, playerIdx)
    if SaveData.toggleCostumeAbilities == true then
        if playerIdx == 1 then
            if button == SaveData.specialbutton1stplayer then
                costume.throwSnowball()
            end
        end
    end
end

function costume.throwSnowball()
    if (plr.powerup == 5) == false then
        plr:mem(0x120, FIELD_BOOL, false) --Making sure Alt Jump isn't pressed until after the attack
        plr:mem(0x172, FIELD_BOOL, false) --No run either, in case
        local x = plr.x
        local y = plr.y + plr.height/2 - 5
        if (plr.direction == 1) then
            x = x + plr.width
        end
        local snowballid = 266
        local snowballNpc = NPC.spawn(snowballid, x, y, player.section, false, true)
        costume.usesnowball = true
        snowballNpc.frames = 1
        if (plr.direction == 1) then
            snowballNpc.speedX = 8.5
            snowballNpc.speedY = 1
        else
            snowballNpc.speedX = -8.5
            snowballNpc.speedY = 1
        end
        if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
            Sound.playSFX("mario/SP-1-EricCartman/snowball_throw.ogg")
        end
        costume.usesnowball = false
        cooldown = 35
        if cooldown <= 0 then
            plr:mem(0x120, FIELD_BOOL, true)
            plr:mem(0x172, FIELD_BOOL, true)
        end
    end
end

function costume.onPostNPCKill(npc, harmType)
    local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
    local itemgetrng
    if SaveData.toggleCostumeProfanity then
        itemgetrng = rng.randomInt(1,7)
    else
        itemgetrng = rng.randomInt(4,7)
    end
    if costume.abilitesenabled then
        if items[npc.id] and Colliders.collide(plr, npc) then
            SFX.play("costumes/mario/SP-1-EricCartman/voices/item/"..itemgetrng..".ogg", 1, 1, 80)
        end
    end
end

function costume.onPlayerHarm()
    if costume.abilitesenabled then
        if not plr.hasStarman or plr.isMega then
            local hurtvoicerng
            if SaveData.toggleCostumeProfanity then
                hurtvoicerng = rng.randomInt(1,10)
            else
                hurtvoicerng = rng.randomInt(7,8)
            end
            Sound.playSFX("mario/SP-1-EricCartman/voices/hurt/"..hurtvoicerng..".ogg")
        end
    end
end

function costume.onPlayerKill()
    local dyingvoicerng
    if SaveData.toggleCostumeProfanity then
        dyingvoicerng = rng.randomInt(1,10)
    else
        dyingvoicerng = rng.randomInt(3,5)
    end
    if costume.abilitesenabled then
        Sound.playSFX("mario/SP-1-EricCartman/voices/dying/"..dyingvoicerng..".ogg")
    end
end

function costume.onCleanup(p)
    extrasounds.sound.sfx[1] = nil    
    Audio.sounds[2].sfx  = nil
    Audio.sounds[3].sfx  = nil
    Audio.sounds[4].sfx  = nil
    Audio.sounds[5].sfx  = nil
    Audio.sounds[6].sfx  = nil
    Audio.sounds[7].sfx  = nil
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
    Audio.sounds[59].sfx = nil
    Audio.sounds[61].sfx = nil
    Audio.sounds[62].sfx = nil
    Audio.sounds[63].sfx = nil
    Audio.sounds[71].sfx = nil
    Audio.sounds[72].sfx = nil
    Audio.sounds[73].sfx = nil
    Audio.sounds[75].sfx = nil
    Audio.sounds[76].sfx = nil
    Audio.sounds[77].sfx = nil
    Audio.sounds[78].sfx = nil
    Audio.sounds[79].sfx = nil
    Audio.sounds[80].sfx = nil
    extrasounds.sound.sfx[81] = nil
    Audio.sounds[82].sfx = nil
    Audio.sounds[91].sfx = nil
    extrasounds.sound.sfx92 = Audio.SfxOpen(Misc.resolveSoundFile("sound/sprout-vine.ogg"))
    extrasounds.sound.sfx93 = Audio.SfxOpen(Misc.resolveSoundFile("sound/iceball.ogg"))
    extrasounds.sound.sfx94 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi-freeze.ogg"))
    extrasounds.sound.sfx95 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi-icebreak.ogg"))
    extrasounds.sound.sfx96 = Audio.SfxOpen(Misc.resolveSoundFile("sound/2up.ogg"))
    extrasounds.sound.sfx97 = Audio.SfxOpen(Misc.resolveSoundFile("sound/3up.ogg"))
    extrasounds.sound.sfx98 = Audio.SfxOpen(Misc.resolveSoundFile("sound/5up.ogg"))
    extrasounds.sound.sfx99 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get2.ogg"))
    extrasounds.sound.sfx100 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get3.ogg"))
    extrasounds.sound.sfx101 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get4.ogg"))
    extrasounds.sound.sfx102 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get5.ogg"))
    extrasounds.sound.sfx103 = Audio.SfxOpen(Misc.resolveSoundFile("sound/cherry.ogg"))
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.4
    
    Graphics.sprites.npc[266].img = nil
    
    costume.abilitesenabled = false
end

return costume