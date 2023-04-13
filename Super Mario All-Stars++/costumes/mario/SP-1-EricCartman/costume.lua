local pm = require("playerManager")
local extrasounds = require("extrasounds")
local rng = require("base/rng")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

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
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
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
        if keyCode == smasTables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
            if smasCharacterGlobals.abilitySettings.southParkEricCanThrowSnowballs then
                costume.throwSnowball()
            end
        end
    end
end

function costume.onControllerButtonPress(button, playerIdx)
    if SaveData.toggleCostumeAbilities == true then
        if playerIdx == 1 then
            if button == SaveData.specialbutton1stplayer then
                if smasCharacterGlobals.abilitySettings.southParkEricCanThrowSnowballs then
                    costume.throwSnowball()
                end
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
        if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
            Sound.playSFX(smasCharacterGlobals.soundSettings.southParkEricSnowballThrowSFX)
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
            if smasCharacterGlobals.soundSettings.southParkEricCanUseVoice then
                SFX.play("costumes/mario/SP-1-EricCartman/voices/item/"..itemgetrng..".ogg", 1, 1, 80)
            end
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
            if smasCharacterGlobals.soundSettings.southParkEricCanUseVoice then
                Sound.playSFX("mario/SP-1-EricCartman/voices/hurt/"..hurtvoicerng..".ogg")
            end
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
        if smasCharacterGlobals.soundSettings.southParkEricCanUseVoice then
            Sound.playSFX("mario/SP-1-EricCartman/voices/dying/"..dyingvoicerng..".ogg")
        end
    end
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.4
    
    Graphics.sprites.npc[266].img = nil
    
    costume.abilitesenabled = false
end

Misc.storeLatestCostumeData(costume)

return costume