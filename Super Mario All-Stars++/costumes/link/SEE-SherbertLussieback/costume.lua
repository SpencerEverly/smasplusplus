local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onInputUpdate")
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onKeyboardPress")
    registerEvent(costume,"onControllerButtonPress")
    Audio.sounds[52].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/got-star.ogg")
    Audio.sounds[77].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-stab.ogg")
    Audio.sounds[78].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-hurt.ogg")
    Audio.sounds[79].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-heart.ogg")
    Audio.sounds[80].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-died.ogg")
    Audio.sounds[81].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-rupee.ogg")
    Audio.sounds[82].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-fire.ogg")
    Audio.sounds[83].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-item.ogg")
    Audio.sounds[84].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-key.ogg")
    Audio.sounds[85].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-shield.ogg")
    Audio.sounds[86].sfx = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
    Audio.sounds[87].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-fairy.ogg")
    Audio.sounds[88].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-grass.ogg")
    Audio.sounds[89].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-hit.ogg")
    Audio.sounds[90].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-sword-beam.ogg")
    
    Defines.player_walkspeed = 4
    Defines.player_runspeed = 5
    Defines.jumpheight = 25
    Defines.jumpheight_bounce = 25
    Defines.projectilespeedx = 7.0
    Defines.player_grav = 0.44
    
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

function costume.swooshattack()
    if (plr.powerup == 5) == false then
        plr:mem(0x140, FIELD_WORD, 0) --Blinker is 0
        player:mem(0x120, FIELD_BOOL, false) --Making sure Alt Jump isn't pressed until after the attack
        plr:mem(0x172, FIELD_BOOL, false) --No run either, in case
        Sound.playSFX(33)
        if plr.direction == 1 then
            plr.speedX = 8
            plr.speedY = -3
        elseif plr.direction == -1 then
            plr.speedX = -8
            plr.speedY = -3
        end
        lungingTicks = 0
        lunging = true
        if lungingTicks > 20 then
            lunging = false
        end
    end
end

function costume.onDraw()
    if SaveData.toggleCostumeAbilities == true then
        if lunging then
            player:playAnim({13,14,15,16}, 4, false, -25)
        end
        --local isJumping = player:mem(0x11C, FIELD_WORD) --Jumping detection
        local isUnderwater = plr:mem(0x36, FIELD_BOOL) --Underwater detection
        --if isJumping and plr:mem(0x14, FIELD_WORD) <= 0 and not isUnderwater and not player:isOnGround() then --Checks to see if the player is jumping...
            --plr:setFrame(12)
        --end
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
    if SaveData.toggleCostumeAbilities == true then
        if lunging then
            e.cancelled = true
            return
        end
    end
end

function costume.onKeyboardPress(keyCode, repeated)
    if SaveData.toggleCostumeAbilities == true then
        if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
            costume.swooshattack()
        end
    end
end

function costume.onControllerButtonPress(button, playerIdx)
    if SaveData.toggleCostumeAbilities == true then
        if playerIdx == 1 then
            if button == SaveData.specialbutton1stplayer then
                costume.swooshattack()
            end
        end
    end
end

function costume.onInputUpdate()
    if SaveData.toggleCostumeAbilities == true then
        if player.keys.run == KEYS_DOWN then
            plr:mem(0x168, FIELD_FLOAT, 10)
        else
            plr:mem(0x168, FIELD_FLOAT, 0)
        end
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
    Audio.sounds[14].sfx = nil
    Audio.sounds[15].sfx = nil
    Audio.sounds[16].sfx = nil
    Audio.sounds[17].sfx = nil
    Audio.sounds[18].sfx = nil
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
    Audio.sounds[83].sfx = nil
    Audio.sounds[84].sfx = nil
    Audio.sounds[85].sfx = nil
    Audio.sounds[86].sfx = nil
    Audio.sounds[87].sfx = nil
    Audio.sounds[88].sfx = nil
    Audio.sounds[89].sfx = nil
    Audio.sounds[90].sfx = nil
    Audio.sounds[91].sfx = nil
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
end

return costume;