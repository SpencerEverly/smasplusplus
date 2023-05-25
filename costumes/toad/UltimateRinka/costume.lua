-- costume.lua
-- v1.1
-- Created by Pyro, 2015-2016
-- ALL HAIL ULTIMATE RINKA

--------------------
-- INITIALIZATION --
--------------------

local costume = {}
--I don't know why you did it this way, but I appreciate it Pyro.

-- Load helper libraries
local ed = require("expandedDefines")
local colliders = require("colliders")
local rng = require("rng")
local pm = require("playerManager")
local imagic = require("imagic")
local smasFunctions = require("smasFunctions")
local smasHud = require("smasHud")
local smasTables = require("smasTables")

-- Load events
function costume.onInit(p)
    registerEvent(costume, "onTick", "onTick", false)
    registerEvent(costume, "onNPCKill", "onNPCKill", false)
    registerEvent(costume, "onInputUpdate", "onInputUpdate", false)
    registerEvent(costume, "onDraw", "onDraw", false)
    
    Defines.player_runspeed = 5.5;
    Defines.player_walkspeed = 5.5
    Audio.sounds[8].muted = true
    
    costume.abilitiesenabled = true
    costume.hud = true
end

-- Player variables
local floatFactor = 0;
local floatTimer = 0;
local numberOfRinkas = 0;
local doingPow = false;
local specialCooldown = 0;
local direction = 1;
local spawnedDeath = false;

-- Misc. stuff
local rinkaHUD = Graphics.loadImageResolved("costumes/toad/UltimateRinka/rinka.png");
local rinkaFlightGradient = Graphics.loadImageResolved("costumes/toad/UltimateRinka/flightgradient.png");
local rinkaAtkGradient = Graphics.loadImageResolved("costumes/toad/UltimateRinka/attackgradient.png");
local flightColor = Graphics.getPixelData(rinkaFlightGradient);
local attackColor = Graphics.getPixelData(rinkaAtkGradient);

local rinkaProjectile = Graphics.loadImageResolved("costumes/toad/UltimateRinka/rinka_shooter.png");

for k,v in ipairs(flightColor) do
    flightColor[k] = v/255;
end
for k,v in ipairs(attackColor) do
    attackColor[k] = v/255;
end
local meterBase = Graphics.loadImageResolved("costumes/toad/UltimateRinka/ur_meter_base.png");

local sfx_claw = Audio.SfxOpen("sound/character/ur_claw.ogg");
local sfx_fireflower = Audio.SfxOpen("sound/character/ur_fire.ogg");
local sfx_iceflower = Audio.SfxOpen("sound/character/ur_ice.ogg");
local sfx_invin = Audio.SfxOpen("sound/character/ur_invincible.ogg");
local sfx_metalblade = Audio.SfxOpen("sound/character/ur_metalblade.ogg");
local sfx_powerstone = Audio.SfxOpen("sound/character/ur_powerstone.ogg");

local specialTable = {14,182,183,170,277,264,34,169}
local initialRun = false;

local rinka_projectiles = {};

---------------------
-- LOCAL FUNCTIONS --
---------------------

local function returnCenter()
    if player.powerup == 1 then
        return 0;
    else
        return 16;
    end
end

local function spawnRinka()
    if player:mem(0x13E,FIELD_WORD) == 0 then
        ball = NPC.spawn(108,player.x+returnCenter(),player.y+returnCenter(),player.section)
        local n = ball;
        n.data.frame = 0;
        n.data.ftimer = 8;
        table.insert(rinka_projectiles, n);
    
        if player:mem(0x106,FIELD_WORD) == -1 then
            ball.speedX = -8
        else
            ball.speedX = 8
        end
        ball.speedY = 0
            
        if player.upKeyPressing == true and player.downKeyPressing == false and player.rightKeyPressing == false and player.leftKeyPressing == false then
            ball.speedY = -8
            ball.speedX = 0;
        elseif player.downKeyPressing == true and player.upKeyPressing == false and player.rightKeyPressing == false and player.leftKeyPressing == false then
            ball.speedY = 8
            ball.speedX = 0;
        elseif player.upKeyPressing == true and player.downKeyPressing == false then
            ball.speedY = -8
        elseif player.downKeyPressing == true and player.upKeyPressing == false then
            ball.speedY = 8
        end
    end
end

----------------------
-- PLAYER CHARACTER --
----------------------

function costume.onCleanup(p)
    -- UR does some weird stuff...
    -- This seems to be some sort of countdown timer it sets every tick? Well, it needs to go away when changing away from this character
    player:mem(0x160,FIELD_WORD,0)
    player:mem(0x164,FIELD_WORD,0)
    floatTimer = 0 --reset this too
    
    Defines.player_runspeed = nil;
    Defines.player_walkspeed = nil;
    Audio.sounds[8].muted = false;
    
    costume.hud = false
    costume.abilitiesenabled = false
end

function costume.onTick()
    if SaveData.toggleCostumeAbilities == true then
    
        -- Check direction faced
        direction = player:mem(0x106,FIELD_WORD)

        -- Hovering
        if player.forcedState == 0 then
            if (player.jumpKeyPressing and floatTimer < 180) then
                player.speedY = -floatFactor;
                player:mem(0x44,FIELD_WORD,0)
            end
        end
        if floatTimer < 180 and (not player:isGroundTouching()) and player:mem(0x13E,FIELD_WORD) == 0 and player.jumpKeyPressing and player:mem(0x40, FIELD_WORD) == 0 then
            local butt = Animation.spawn(12,player.x+rng.randomInt(8,player.width-8) - 16, player.y + player.height - 48)
            butt.speedY = 2;
            if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                playSFX(16)
            end
        end
    
        -- Prevent actual jumping
        if player:mem(0x108,FIELD_WORD) == 0 and player:mem(0x44,FIELD_WORD) == 0 then
            player:mem(0x11E,FIELD_BOOL,false)
            player:mem(0x120,FIELD_BOOL,false)
        end
    
        -- Stop from using normal powerups
        player:mem(0x160,FIELD_WORD,666)
        if player.powerup == 4 or player.powerup == 5 then
            if player.runKeyPressing then
                player:mem(0x164,FIELD_WORD, -1)
            else
                player:mem(0x164,FIELD_WORD, 0)
            end
        end
    
        -- Increase float factor
        if player.forcedState == 0 then
            if player:isGroundTouching() then
                floatFactor = 1.5;
                if floatTimer > 0 then
                    floatTimer = floatTimer - 6;
                elseif floatTimer < 0 then
                    floatTimer = 0
                end
            else
                if player.jumpKeyPressing and player:mem(0x40, FIELD_WORD) == 0 then
                    floatFactor = floatFactor + 0.05;
                    floatTimer = floatTimer + 1;
                end
            end
        end
    
        if floatFactor >= 4.5 then
            floatFactor = 4.5;
        end
    
        -- Limit rinkas
        if numberOfRinkas >= 25 then
            numberOfRinkas = 25;
        end
    
        -- Make all rinkas friendly
        for k,v in pairs(NPC.get(210,player.section)) do
            v.friendly = true;
            if colliders.collide(player,v) then
                v:kill(9)
                numberOfRinkas = numberOfRinkas + 1;
                playSFX(79)
            end
        end
    
        -- Special attack cooldown
        if specialCooldown > 0 then
            specialCooldown = specialCooldown - 1;
        end
    
        if specialCooldown < 0 then
            specialCooldown = 0;
        end
        
        -- Death effect
        if player:mem(0x13E,FIELD_WORD) ~= 0 and spawnedDeath == false then
            Animation.spawn(108,player.x+player.width*0.5,player.y+player.height*0.5,0)
            playSFX(65)
            spawnedDeath = true;
        end
    end
    
end

function costume.onNPCKill(eventObj,killedNPC,killReason)
    if SaveData.toggleCostumeAbilities == true then
        if killReason ~= 9 and NPC.HITTABLE_MAP[killedNPC.id] then
            local rinka = NPC.spawn(210,killedNPC.x + 0.5 * killedNPC.width,killedNPC.y + 0.5 * killedNPC.height,player.section, false, true)
            rinka.friendly = true
        end
    
        if killedNPC.id == 14 or killedNPC.id == 182 or killedNPC.id == 183 or killedNPC.id == 170 or killedNPC.id == 277 or killedNPC.id == 264 or killedNPC.id == 34 or killedNPC.id == 169 then
            specialCooldown = 0;
            playSFX(88)
        end
    
        if killedNPC.id == 237 then
            for i=0,3,6 do
                local debris = NPC.spawn(265,killedNPC.x,killedNPC.y,player.section)
                debris.speedX = -9 + i * direction;
                debris.speedY = -3;
            end
        end
    end
end

function costume.onInputUpdate()
    if SaveData.toggleCostumeAbilities == true then
        if player:mem(0x13E,FIELD_WORD) == 0 then
            if player.forcedState == FORCEDSTATE_NONE then
                -- Regular rinka attack
                if player.keys.altRun == KEYS_PRESSED and player:mem(0x26,FIELD_WORD) == 0 then
                    if numberOfRinkas > 0 then
                        if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                            SFX.play(sfx_metalblade)
                        end
                        spawnRinka()
                        numberOfRinkas = numberOfRinkas - 1;
                    end
                end

                -- Fire flower
                if player.keys.altJump == KEYS_PRESSED and player.powerup == 3 and specialCooldown == 0 then
                    if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                        SFX.play(sfx_fireflower)
                    end
                    specialCooldown = 250;
                    for i=1,10 do
                        butts = NPC.spawn(13,player.x+(player.width/2),player.y,player.section, false, true)
                        butts.speedX = rng.randomInt(-6,6)
                        butts.speedY = rng.randomInt(-13,-7)
                    end
                end

                -- Ice flower

                if player.keys.altJump == KEYS_PRESSED and player.powerup == 7 and specialCooldown == 0 then
                    if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                        SFX.play(sfx_iceflower)
                    end
                    ice = NPC.spawn(237,player.x+(player.width/2),player.y,player.section, false, true)
                    ice.speedX = 6 * direction;
                    specialCooldown = 150;
                end

                -- Leaf
                
                if player.keys.altJump == KEYS_PRESSED and player.powerup == 4 and specialCooldown == 0 then
                    if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                        SFX.play(sfx_claw)
                    end
                    rrr = NPC.spawn(266,player.x+(player.width/2),player.y,player.section, false, true)
                    rrr.speedX = 8 * direction;
                    rrr.speedY = 4;
                    rrr = NPC.spawn(266,player.x+(player.width/2),player.y,player.section, false, true)
                    rrr.speedX = -8 * direction;
                    rrr.speedY = 4;
                    rrr = NPC.spawn(266,player.x+(player.width/2),player.y,player.section, false, true)
                    rrr.speedX = 8 * direction;
                    rrr.speedY = -4;
                    rrr = NPC.spawn(266,player.x+(player.width/2),player.y,player.section, false, true)
                    rrr.speedX = -8 * direction;
                    rrr.speedY = -4;
                    specialCooldown = 50;
                end

                -- Tanooki
                if player.keys.altJump == KEYS_PRESSED and player.powerup == 5 and specialCooldown == 0 then
                    if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                        SFX.play(sfx_claw)
                    end
                    for i=-1,1,2 do
                        for q=-1,1,2 do
                        rrr = NPC.spawn(266,player.x+(player.width/2),player.y,player.section, false, true)
                        rrr.speedX = 8 * direction * i;
                        rrr.speedY = 4 * q;
                        end
                    end
                    rrr = NPC.spawn(266,player.x+(player.width/2),player.y,player.section, false, true)
                    rrr.speedX = 11 * direction;
                    rrr.speedY = 0;
                    rrr = NPC.spawn(266,player.x+(player.width/2),player.y,player.section, false, true)
                    rrr.speedX = -11 * direction;
                    rrr.speedY = 0;
                    specialCooldown = 75;
                end

                if player.keys.run == KEYS_PRESSED and player.powerup == 5 then
                    if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                        SFX.play(sfx_invin)
                    end
                    butts = NPC.spawn(13,player.x + player.width/2,player.y,player.section, false, true)
                    butts.speedX = rng.randomInt(-6,6)
                    butts.speedY = rng.randomInt(-13,-7)
                end

                -- Hammer suit
                if player.keys.altJump == KEYS_PRESSED and player.powerup == 6 and specialCooldown == 0 then
                    if table.icontains(smasTables._noLevelPlaces,Level.filename()) == false then
                        SFX.play(sfx_powerstone)
                    end
                    for i = 1, 2 do
                        for j = -1, 1 do
                        local rrr = NPC.spawn(171,player.x+(player.width/2),player.y,player.section, false, true)
                        rrr.speedY = 6 * j;
                            if i == 1 then
                                rrr.speedX = 8;
                            else
                                rrr.speedX = -8
                            end
                        end
                    end
                    specialCooldown = 200;
                end
            end
        end
    end
end

local divisionPerPower = {} --glDraw shenanigans for different powerup cooldowns
divisionPerPower[3] = 250
divisionPerPower[4] = 50
divisionPerPower[5] = 75
divisionPerPower[6] = 200
divisionPerPower[7] = 150

function costume.onDraw()

    local i = 1;
    while i <= #rinka_projectiles do
        if(rinka_projectiles[i].isValid) then
            rinka_projectiles[i].animationFrame = 9;
            rinka_projectiles[i].data.ftimer = rinka_projectiles[i].data.ftimer - 1;
            if(rinka_projectiles[i].data.ftimer == 0) then
                rinka_projectiles[i].data.frame = (rinka_projectiles[i].data.frame + 1)%4;
                rinka_projectiles[i].data.ftimer = 8;
            end
            local x = rinka_projectiles[i].x + (rinka_projectiles[i].width - 28)*0.5;
            local y = rinka_projectiles[i].y + (rinka_projectiles[i].height - 32)*0.5;
            Graphics.draw{type=RTYPE_IMAGE, x = x, y = y, isSceneCoordinates = true, image = rinkaProjectile, sourceX = 0, sourceY = rinka_projectiles[i].data.frame*32, sourceWidth = 28, sourceHeight = 32, priority = -45};
            i = i + 1;
        else
            table.remove(rinka_projectiles,i);
        end
    end

    if SaveData.toggleCostumeAbilities == true then
        -- Rinka count
        local rinkaDisplayOffset = 0
        if numberOfRinkas > 9 then
            rinkaDisplayOffset = 8
        end
        if costume.hud == true then
            Graphics.draw{type=RTYPE_IMAGE, image=rinkaHUD, x = 400 - 16 - rinkaDisplayOffset, y = 74, priority = -4.2}
            Text.printWP(numberOfRinkas,400+8 - rinkaDisplayOffset,74, -4.2)
        end
        
        --make rinkas friendly definitely
        for k,v in pairs(NPC.get(210, -1)) do
            v.friendly = true
        end
        
        --flight timer
        
        
        local floatTimerMod = floatTimer/180 * 96
        if floatTimerMod > 98 then
            floatTimerMod = 98
        end
        local p = (floatTimerMod/98);
        local c = math.ceil(#flightColor*0.25);
        c = math.min(4*math.floor(p*c + 0.5) + 1, #flightColor-3);
        p = 1-p;
        if costume.hud == true then
            imagic.Bar{priority = 5, 
                   x = 400, 
                   y = 55, 
                   width=98, 
                   height=8, 
                   align = imagic.ALIGN_CENTRE, 
                   texture=meterBase, 
                   percent = p, 
                   color = {flightColor[c+2], flightColor[c+1], flightColor[c], flightColor[c+3]},
                   outline = true,
                   priority = -4.2
                   };
        end
        
        
        -- Special attack ready?
        
        p = 0
        if player.powerup > 2 then
            p = (specialCooldown/divisionPerPower[player.powerup]);
            c = math.ceil(#attackColor*0.25);
            c = math.min(4*math.floor(p*c + 0.5) + 1, #attackColor-3);
            p = 1-p;
        end
        if costume.hud == true then
            imagic.Bar{priority = 5, 
                   x = 400, 
                   y = 66, 
                   width=98, 
                   height=8, 
                   align = imagic.ALIGN_CENTRE, 
                   texture=meterBase, 
                   percent = p, 
                   color = {attackColor[c+2], attackColor[c+1], attackColor[c], attackColor[c+3]},
                   outline = true,
                   priority = -4.2
                   };
        end        
    end
end

Misc.storeLatestCostumeData(costume)

return costume
