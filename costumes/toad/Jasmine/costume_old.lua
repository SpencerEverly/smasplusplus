--Things to fix:
--1. Implement the rest of the Powerups, like ones beyond being Big Juni
--That's pretty much it, idk what else

--LOCALS

-- Declare our API object
local costume = {}

local colliders = API.load("colliders")
local savestate = API.load("savestate")
local playeranim = API.load("playeranim")
local playerManager = require("playerManager")

costume.highjump = false
costume.wallclimb = true
costume.running = true
costume.doublejump = true
costume.parasol = false
costume.hologram = false

costume.usesavestate = false;

local junijump = -2
local jumpo = 0
local jumped = false
local climb = false
local jumpmax = 1
local parasolopen = false
local umbrellR = Graphics.loadImageResolved("costumes/toad/Jasmine/UmbrellaR.png")
local umbrLa =  Graphics.loadImageResolved("costumes/toad/Jasmine/UmbrellaL.png")
local holographic = Graphics.loadImageResolved("costumes/toad/Jasmine/Holoplayer_0_stopped_1.png")
local holostart = false
local junistarted = 0

local hologram = Audio.SfxOpen("sound/character/jasmine/HologramA.ogg");
local sfx_doublejump = Audio.SfxOpen("sound/character/jasmine/KnyttDoubleJump.ogg");
local jumpsfx = Audio.SfxOpen("sound/character/jasmine/KnyttJump.ogg");
local savepoint = Audio.SfxOpen("sound/character/jasmine/Savepoint.ogg");
local umbrellaa = Audio.SfxOpen("sound/character/jasmine/UmbrellaA.ogg");
local umbrellab = Audio.SfxOpen("sound/character/jasmine/UmbrellaB.ogg");

-----------------
---ON INIT API---
-----------------

function costume.onInit(p)
    -- Default Movement
    registerEvent(costume, "onInputUpdate")
    registerEvent(costume, "onTick")
    Defines.player_runspeed = 2.2
    Defines.player_walkspeed = 2
    Defines.jumpheight = 15
    Defines.jumpheight_bounce = 13
    Audio.sounds[1].muted = true
    Audio.sounds[71].muted = true
    costume.abilitiesenabled = true
end

function costume.onCleanup(p)
    -- Return physics to normal
    Defines.player_runspeed = nil
    Defines.player_walkspeed = nil
    Defines.jumpheight = nil
    Defines.jumpheight_bounce = nil
    costume.abilitiesenabled = false
    Audio.sounds[1].muted = false
    Audio.sounds[71].muted = false
end

-------------------
---ONLOOP STARTS---
-------------------

function costume.onTick()

    --ONLOOP CONTENTS
    if SaveData.toggleCostumeAbilities == true then
        Audio.sounds[1].muted = true
        Audio.sounds[71].muted = true
        --ON LEVEL START
        if (player.isValid) then
            if junistarted == 0 then
                juniPowerupSave1, juniPowerupSave2, juniPowerupSave3, juniPowerupSave4, juniPowerupSave5, juniPowerupSave6 = costume.doublejump, costume.running, costume.highjump, costume.hologram, costume.parasol, costume.wallclimb
                junisave = savestate.save(savestate.STATE_ALL)
                junistarted = 1
            end
        end
        
        --die on water
        if player:mem(0x34, FIELD_WORD) == 2 then
            --player:kill() 
        end
        
        --Prevent freezing when collecting power-ups.
        if player:mem(0x122, FIELD_WORD) > 0 and not player:mem(0x122, FIELD_WORD) == 3 and not player:mem(0x122, FIELD_WORD) == 7 then
            player:mem(0x122, FIELD_WORD, 0)
            player:mem(0x124, FIELD_WORD, 0)
        end
        
        --change player BIG
        --if player.powerup ~= PLAYER_BIG and player:mem(0x122, FIELD_WORD) == 0 then
            --player.powerup = PLAYER_BIG
        --end
        --if player.powerup >= 3 then
            --player:mem(0x16, FIELD_WORD, 3)
        --end
        
        
        --VERTICAL MOVEMENT.
        
        --no spinjump
        player:mem(0x50, FIELD_WORD, 0)
        player:mem(0x52, FIELD_WORD, 0)
        player:mem(0x120, FIELD_WORD, 0)

        --Wall Climb
         if costume.wallclimb and (player:mem(0x148, FIELD_WORD) > 0 or player:mem(0x14C, FIELD_WORD) > 0) then
            jumpo = 0
            jumped=true
            climb = true
        else
            climb = false
        end
        
        --IF HIGHJUMP
        if costume.highjump then
            Defines.jumpheight = 17
            Defines.jumpheight_bounce = 18
        else 
            Defines.jumpheight = 12.2
            Defines.jumpheight_bounce = 10.2
        end
        
        --IF DOUBLEJUMP
        if costume.doublejump then 
            jumpmax = 2
        else 
            jumpmax = 1
        end

        --IF PARASOL
        if costume.parasol and parasolopen then
        
            if player.speedY > 0.86 then 
                player.speedY = 0.86
            end
            
            if player:mem(0x106, FIELD_WORD) == -1 then
                Graphics.drawImageToSceneWP(umbrLa,player.x-6,player.y-20,-25)
            else 
                Graphics.drawImageToSceneWP(umbrellR,player.x-14,player.y-20,-25)
            end
        end


        --COLLECTING POWERS
        
        if colliders.collideNPC(player, 184) then
            costume.highjump = true

        end
        if colliders.collideNPC(player,14) then
            costume.doublejump = true

        end
        if colliders.collideNPC(player, 34)  then
            costume.wallclimb = true

        end
        if colliders.collideNPC(player,170)  then
            costume.parasol = true

        end
        if colliders.collideNPC(player,169)  then
            costume.hologram = true

        end
        if colliders.collideNPC(player,9)  then
            costume.running = true

        end
        if colliders.collideNPC(player, 192) then
            junisave = savestate.save(savestate.STATE_ALL)
            juniPowerupSave1, juniPowerupSave2, juniPowerupSave3, juniPowerupSave4, juniPowerupSave5, juniPowerupSave6 = costume.doublejump, costume.running, costume.highjump, costume.hologram, costume.parasol, costume.wallclimb
        end

        --Hologram flash
        if player:mem(0x140, FIELD_WORD) > 0 and holostart then
            Graphics.drawImageToSceneWP(holographic,holox,holoy,-25)
        end

        --IF RUNNING
        if costume.running == false then 
            Defines.player_runspeed = 2.2
            Defines.player_walkspeed = 2.2
        else
            Defines.player_runspeed = 4
            Defines.player_walkspeed = 2.2
        end 
        
        --IF PLAYER DEATH ANIMATION--
        if player:mem(0x13E, FIELD_WORD) > 0 then
            
        end
    end
    --Text.print(tostring(player.speedX), 0, 20)
end


--------------------
---ONINPUT UPDATE---
--------------------

function costume.onInputUpdate()
    if SaveData.toggleCostumeAbilities == true then
        --SAVEPOINTS
        if player.keys.down == KEYS_PRESSED and colliders.collideNPC(player, 182) then
            junisave = savestate.save(savestate.STATE_ALL)
            SFX.play(savepoint)
            juniPowerupSave1, juniPowerupSave2, juniPowerupSave3, juniPowerupSave4, juniPowerupSave5, juniPowerupSave6 = costume.doublejump, costume.running, costume.highjump, costume.hologram, costume.parasol, costume.wallclimb
        end

        --HOLOGRAM
        if player.keys.altJump == KEYS_PRESSED and player:mem(0x140, FIELD_WORD) == 0 then

            if costume.hologram then
                --if on ground
                if  player:mem(0x146,FIELD_WORD) ~= 0 or player:mem(0x48,FIELD_WORD) ~= 0 or player:mem(0x176,FIELD_WORD) ~= 0 then 
                    SFX.play(hologram)
                    holox, holoy = player.x, player.y
                    player:mem(0x140, FIELD_WORD, 150)
                    holostart = true
                end
            end
        end
        --DOUBLEJUMP
        if not climb then
            if player.keys.jump == KEYS_PRESSED and Level.winState() == 0 and not Misc.isPaused() then
                jumped=false
                if  player:mem(0x146,FIELD_WORD) == 0 or player:mem(0x48,FIELD_WORD) == 0 or player:mem(0x176,FIELD_WORD) == 0 or player:mem(0x40, FIELD_WORD) == 3 then 
                    jumpo = jumpo+1
                end
                if jumpo == 1 then
                    if  player:mem(0x146,FIELD_WORD) ~= 0 or player:mem(0x48,FIELD_WORD) ~= 0 or player:mem(0x176,FIELD_WORD) ~= 0 or player:mem(0x40, FIELD_WORD) == 3 then 
                        SFX.play(jumpsfx)
                    else
                        if costume.doublejump then
                            SFX.play(sfx_doublejump)
                        end
                    end
                end
            end
        
        --IF ON GROUND--
            if  player:mem(0x146,FIELD_WORD) ~= 0 or player:mem(0x48,FIELD_WORD) ~= 0 or player:mem(0x176,FIELD_WORD) ~= 0 or player:mem(0x40, FIELD_WORD) == 3 then 
                if jumpo > 0 then
                    jumpo = 0
                end
            elseif  jumpo > 0 and jumpo < jumpmax and not jumped then
                jumped=true
                if costume.highjump then
                    player.speedY = -Defines.jumpheight*0.6
                else 
                    player.speedY = -Defines.jumpheight*0.8
                end
            end
        end
        
        --WALLCLIMB
        if costume.wallclimb and climb then
            climb = false
            player.speedX=0
            jumpo = 0
            if player.upKeyPressing then
                player:mem(0x40, FIELD_WORD, 3)
            else
                player:mem(0x40, FIELD_WORD, 1)
                playeranim.setFrame(player,25)
            end
        end

        --UMBRELLA
        if player.keys.altRun == KEYS_PRESSED and Level.winState() == 0 then
            if costume.parasol then
                if parasolopen then 
                    SFX.play(umbrellaa)
                    parasolopen = false
                elseif parasolopen == false then
                    SFX.play(umbrellab)
                    parasolopen = true
                end 
            end
        end
    end
end

Misc.storeLatestCostumeData(costume)

return costume