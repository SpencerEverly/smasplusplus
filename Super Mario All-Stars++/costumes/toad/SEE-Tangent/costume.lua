local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smasfunctions = require("smasfunctions")

local costume = {}

costume.loadedSounds = false

local lunging = false

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onStart")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPlayerKill")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onTickEnd")
    registerEvent(costume,"onCleanup")
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onKeyboardPress")
    registerEvent(costume,"onControllerButtonPress")
    registerEvent(costume,"onInputUpdate")
    Graphics.registerCharacterHUD(CHARACTER_TOAD, Graphics.HUD_NONE)
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
    Defines.player_walkspeed = 5
    Defines.player_runspeed = 8
    Defines.jumpheight = 26
    Defines.jumpheight_bounce = 26
    
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

function costume.onDraw()
    if SaveData.toggleCostumeAbilities == true then
        if lunging then
            plr.frame = 3
        end
    end
end

function costume.lungeattack()
    if (plr.powerup == 5) == false then
        plr:mem(0x140, FIELD_WORD, 0) --Blinker is 0
        player:mem(0x120, FIELD_BOOL, false) --Making sure Alt Jump isn't pressed until after the attack
        plr:mem(0x172, FIELD_BOOL, false) --No run either, in case
        if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
            Sound.playSFX("toad/SEE-Tangent/tangent-lunge.ogg")
        end
        if plr.direction == 1 then
            plr.speedX = 5
            plr.speedY = -3
        elseif plr.direction == -1 then
            plr.speedX = -5
            plr.speedY = -3
        end
        lungingTicks = 0
        lunging = true
        if lungingTicks > 15 then
            lunging = false
        end
    end
end

function costume.onTick()
    if SaveData.toggleCostumeAbilities == true then
        local hitNPCs = Colliders.getColliding{a = player, b = hitNPCs, btype = Colliders.NPC}
        if lunging then
            plr.keys.left = false
            plr.keys.right = false
            plr.keys.up = false
            plr.keys.down = false
            plr.keys.jump = false
            plr.keys.altJump = false
            plr.keys.run = false
            for _,npc in ipairs(hitNPCs) do
                if npc ~= v and npc.id > 0 then
                    -- Hurt the NPC, and make sure to not give the automatic score
                    local oldScore = NPC.config[npc.id].score
                    NPC.config[npc.id].score = 0
                    NPC.config[npc.id].score = oldScore
                    
                    local hurtNPC = harmNPC(npc,HARM_TYPE_NPC)
                    if hurtNPC then
                        Misc.givePoints(0,{x = npc.x+npc.width*1.5,y = npc.y+npc.height*0.5},true)
                    end
                end
            end
            lungingTicks = lungingTicks + 1

            plr.x = plr.x + 4 * plr.direction

            if lungingTicks > 15 then
                lunging = false
                plr:mem(0x140, FIELD_WORD, 50)
            end
        end
    end
end

function costume.onPlayerHarm(e, p)
    if lunging then
        e.cancelled = true
    end
end

function costume.onKeyboardPress(keyCode, repeated)
    if SaveData.toggleCostumeAbilities then
        if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
            costume.lungeattack()
        end
    end
end

function costume.onControllerButtonPress(button, playerIdx)
    if SaveData.toggleCostumeAbilities then
        if playerIdx == 1 then
            if button == SaveData.specialbutton1stplayer then
                costume.lungeattack()
            end
        end
    end
end

function costume.onCleanup(p)
    Graphics.registerCharacterHUD(CHARACTER_TOAD, Graphics.HUD_HEARTS)
    for i = 1,91 do
        Audio.sounds[i].sfx = nil
    end
    for i = 1,165 do
        extrasounds.sound.sfx[i] = nil
    end
        
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    
end

return costume;