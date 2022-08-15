local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}
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
    Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/toad/SEE-Tangent/player-shrink.ogg")
    extrasounds.sound.sfx[8]  = Audio.SfxOpen("costumes/toad/SEE-Tangent/player-died.ogg")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/toad/SEE-Tangent/got-star.ogg")
    Audio.sounds[76].sfx = Audio.SfxOpen("costumes/toad/SEE-Tangent/smb2-hit.ogg")
    
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
    if SaveData.toggleCostumeAbilities == true then
        if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
            costume.lungeattack()
        end
    end
end

function costume.onControllerButtonPress(button, playerIdx)
    if SaveData.toggleCostumeAbilities == true then
        if playerIdx == 1 then
            if button == SaveData.specialbutton1stplayer then
                costume.lungeattack()
            end
        end
    end
end

function costume.onCleanup(p)
    Graphics.registerCharacterHUD(CHARACTER_TOAD, Graphics.HUD_HEARTS)
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
    Audio.sounds[77].sfx = nil
    Audio.sounds[78].sfx = nil
    Audio.sounds[79].sfx = nil
    Audio.sounds[80].sfx = nil
    Audio.sounds[81].sfx = nil
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
        
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    
end

return costume;