--megaman.lua
--v1.0.10
--Created by Horikawa Otane, 2015
--Continued by Enjl, 2016
--Contact me at https://www.youtube.com/subscription_center?add_user=msotane

local colliders = require("colliders")
local imagic = require("imagic")
local particles = require("particles")
local rng = require("rng")
local panim = require("playeranim")
local pm = require("playerManager")
local smasFunctions = require("smasFunctions")
local barrelAI = require("npcs/ai/launchBarrel")
local smasBooleans = require("smasBooleans")

--[[
Things to fix:
- Player collects power-ups even when they despawn.
- The rushjet graphic is not loaded. Would be better than airship piece, and if only the bullets shot by megaman used it. (may need to be fixed later).
- Player has wrong shooting frame while on slopes. It looks like they are in air.
- Error happens on example level (on start-up). http://i.imgur.com/cqBy9nG.png
- When returning to the hub, the npc replacements are not loaded for some reason. http://i.imgur.com/QII2ypH.png
]]

--------------------------------
-- HEALTH POINT LIBRARY SETUP --
--------------------------------

-- HealthPoint support is commented out because we don't want this happening for other characters and HealthPoint
-- cannot be disabled/enabled at will easily.
--[[
local HealthPoint = require("HealthPoint")

local npcgroups = {
{hp=3, list={1,2,8,242,89,27,165,166,93,51,52,36,285,59,61,63,65,245,117,118,119,120,55,232,233,229,230,28,236}},
{hp=4, list={271,176,76,171,123,161,121,122,124,174,175,4,6,111,109,110,112,167,243,244,3,162,163,19,20,128,126,127,23,270}},
{hp=6, list={231,235,54,29,272,47,77,25,261,247,53,130,131,132,125,129,135,136,284}},
{hp=9, list={71,164,74,48,210,275,168,234,72,205}}
}

local damagetypes = {
{dmg=1, list={1,3,8}},
{dmg=2, list={4,15}},
{dmg=3, list={5,14,9}}
}

for _, npcgroup in ipairs(npcgroups) do
    for _, id in ipairs(npcgroup.list) do
        HealthPoint.setNPCHealth(id, npcgroup.hp)
        for _, damage in ipairs(damagetypes) do
            for _, why in ipairs(damage.list) do
                HealthPoint.setNPCDamage(id,why,damage.dmg)
            end
        end
    end
end
]]

-- REARS --

local chargeType1 = particles.Emitter(-20400,-20000, (Misc.multiResolveFile("chargeParticles1.ini", "graphics\\megaman\\chargeParticles1.ini")))
local chargeType2 = particles.Emitter(-20400,-20000, (Misc.multiResolveFile("chargeParticles2.ini", "graphics\\megaman\\chargeParticles2.ini")))
local pointField1

local megaman = {}

local health = 28
local healtimer = 0
local isNearDeath = false
local megamanHud = pm.registerGraphic(CHARACTER_MEGAMAN,"hud.png");
local energyBits = pm.registerGraphic(CHARACTER_MEGAMAN,"energy.png");
local npcPowerup = {id = 13, speedX = 10, delay = 0, cost = 0, xOffset = 0, yOffset = 24}
local playerFireballs = {}
local playerHammers = {}
local isPlaying = false
local formerX
local formerY
local formerPowerUp = 1
local beenHitOnce = false
local playerJets = {}
local pIncNPC = 0
local pIncTimer = 0
local cantShoot = false

local inIntro = false
local introTime = 0
local introOver = false
local introDelay = false
local introFlickerOff = false
local readySign = pm.registerGraphic(CHARACTER_MEGAMAN,"readysign.png");
local teleportImage = pm.registerGraphic(CHARACTER_MEGAMAN,"teleport.png");

local runanim = panim.Anim({2,3,2,4});
local rungrabanim = panim.Anim({12,13});

local teleportModifier = 0
local noMoreMovement = false
local recordedTime
local hasPlayedTeleport = false
local firstRun = true
megaman.playIntro = false

local isSliding = false
local slidingTime = 0
local wasKeyComboPressed = false
local shootAlarm = 0;
local direction = 0;

local initiatedSlide = false

local disableTable = {}
disableTable[2] = true
disableTable[227] = true
disableTable[228] = true

local wasDownPressed = false
local wasUpPressed = false
local wasSelectPressed = false

local chargeTime = 0;

local inPause = false
local pauseBlink = 0
local menuPosition = 0
local megamanPause = pm.registerGraphic(CHARACTER_MEGAMAN,"megamanpause.png")
local hudSide = pm.registerGraphic(CHARACTER_MEGAMAN,"hudSide.png")
local powerupImages = pm.registerGraphic(CHARACTER_MEGAMAN,"menuIcons.png")

local powerupFlicker = false
local currentMenu = {}
local menuPositionSet = false
local inPauseReset = true
megaman.powerUpStuff = {{name = "M. Buster", hasCollected = true, id = 13, cost = 0, delay = 0, speedX = 10, yOffset = 24, xOffset = 0, left = 0},
                        {name = "M. Buster", hasCollected = true, id = 13, cost = 0, delay = 0, speedX = 10, yOffset = 24, xOffset = 0, left = 0},
                        {name = "A. Fire", hasCollected = false, id = 282, cost = 2, delay = 10, speedX = 10, yOffset = 24, xOffset = 0, left = 28},
                        {name = "R. Cutter", hasCollected = false, id = 292, cost = 4, delay = 10, speedX = 10, yOffset = 24, xOffset = 80, left = 28},
                        {name = "R. Jet", hasCollected = false, id = 160, cost = 8, delay = 10, speedX = 2, yOffset = 0, xOffset = 40, left = 28},
                        {name = "T. Spin", hasCollected = false, id = 24, cost = 3, delay = 10, speedX = 10, yOffset = 0, xOffset = 40, left = 28},
                        {name = "I. Wall", hasCollected = false, id = 237, cost = 2, delay = 10, speedX = 10, yOffset = 0, xOffset = 0, left = 28}}

local NPCItemSfxArray = {}
NPCItemSfxArray[184] = {isIncreaseHealth = true, powerupSfx = 1, increaseValue = 4, setPower = false}
NPCItemSfxArray[185] = {isIncreaseHealth = true, powerupSfx = 1, increaseValue = 4, setPower = false}
NPCItemSfxArray[186] = {isIncreaseHealth = true, powerupSfx = 1, increaseValue = 4, setPower = false}
NPCItemSfxArray[9] = {isIncreaseHealth = true, powerupSfx = 1, increaseValue = 4, setPower = false}
NPCItemSfxArray[186] = {isIncreaseHealth = false, powerupSfx = 1, increaseValue = 4, setPower = false}
NPCItemSfxArray[187] = {isIncreaseHealth = false, powerupSfx = 2, increaseValue = 16, setPower = false}
NPCItemSfxArray[249] = {isIncreaseHealth = true, powerupSfx = 2, increaseValue = 20, setPower = false}
NPCItemSfxArray[14] = {setPower = true, powerValue = 3, powerupSfx = 2, increaseValue = 28}
NPCItemSfxArray[183] = {setPower = true, powerValue = 3, powerupSfx = 2, increaseValue = 28}
NPCItemSfxArray[182] = {setPower = true, powerValue = 3, powerupSfx = 2, increaseValue = 28}
NPCItemSfxArray[34] = {setPower = true, powerValue = 4, powerupSfx = 2, increaseValue = 28}
NPCItemSfxArray[169] = {setPower = true, powerValue = 5, powerupSfx = 2, increaseValue = 28}
NPCItemSfxArray[170] = {setPower = true, powerValue = 6, powerupSfx = 2, increaseValue = 28}
NPCItemSfxArray[264] = {setPower = true, powerValue = 7, powerupSfx = 2, increaseValue = 28}
NPCItemSfxArray[277] = {setPower = true, powerValue = 7, powerupSfx = 2, increaseValue = 28}
                        
local itemSfxObject
local chargeSfxObject
local itemSfx = {}
itemSfx[1] = pm.registerSound(CHARACTER_MEGAMAN, "mm_itemgetshort.ogg")
itemSfx[2] = pm.registerSound(CHARACTER_MEGAMAN, "mm_itemgetlong.ogg")
local chargeSfx = pm.registerSound(CHARACTER_MEGAMAN, "mm_charge1.ogg")
local chargeFullSfx = pm.registerSound(CHARACTER_MEGAMAN, "mm_charge2.ogg")
local chargeReleaseSfx = pm.registerSound(CHARACTER_MEGAMAN, "mm_chargerelease.ogg")

local sfx_hurt = pm.registerSound(CHARACTER_MEGAMAN, "mm_hurt.ogg");
local sfx_shoot = pm.registerSound(CHARACTER_MEGAMAN, "mm_shoot.ogg");
local sfx_teleport = pm.registerSound(CHARACTER_MEGAMAN, "mm_teleport.ogg");
local sfx_cursor = pm.registerSound(CHARACTER_MEGAMAN, "mm_cursor.ogg");
local sfx_pause = pm.registerSound(CHARACTER_MEGAMAN, "mm_pause.ogg");

local isExternallyPaused = false

local slideCollider = colliders.Box(0,0,0,0)

local function drawBar(x, y, powerup, value, priority)
    Graphics.drawImageWP(pm.getGraphic(CHARACTER_MEGAMAN,megamanHud), x - 8, y + 80, -5)
    for i=1, value do
        imagic.Draw{texture = pm.getGraphic(CHARACTER_MEGAMAN,energyBits),
                    rotation = 90,
                    align = imagic.ALIGN_CENTRE,
                    x=x,
                    y=115 + y + 80 - (4 * i),
                    priority=smasHud.priority,
                    sourceY=12 * (powerup - 1),
                    sourceWidth=2,
                    sourceHeight=12}
    end
end

local function drawHudElements(playerIdx, camObj, playerObj, priority, isSplit, playerCount)
    local healthValue = health
    if healthValue < 0 then
        healthValue = 0
    end
    
    local offset = 28;
    local side = 1;
    
    local y = 20;
    
    if(isSplit) then
        y = 50;
    end
    
    if(playerIdx == 2 and not isSplit) then
        side = -1;
        offset = 800-offset;
    end
    
    drawBar(offset, y, 1, healthValue, -5)
    if playerObj.powerup > 2 then
        drawBar(offset+20*side, y, playerObj.powerup, megaman.powerUpStuff[playerObj.powerup].left, -5)
    end
end

Graphics.registerCharacterHUD(CHARACTER_MEGAMAN, Graphics.HUD_NONE, drawHudElements)
                        
local function drawPauseMenu()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            Graphics.drawImageWP(pm.getGraphic(CHARACTER_MEGAMAN,megamanPause), 412, 50, 5)
            local realPositon = 0
            if not menuPositionSet then
                local pos = 0
                for i=3, 7 do
                    if megaman.powerUpStuff[i].hasCollected and i <= p.powerup then
                        pos = pos + 1
                    end
                end
                menuPosition = pos
                menuPositionSet = true
            end
            for counter, v in ipairs(megaman.powerUpStuff) do
                if v.hasCollected and counter >= 2 then
                    if not powerupFlicker or menuPosition ~= realPositon then
                        local collectedOffset = 32
                        if v.left == 0 and counter > 2 then
                            collectedOffset = 0
                        end
                        if realPositon > 0 then
                            thisPower = v.left
                        else
                            thisPower = health
                        end
                        Graphics.drawImageWP(pm.getGraphic(CHARACTER_MEGAMAN,powerupImages), 454, -8 + 64 * counter, collectedOffset, 32 * (counter-1), 32, 32, 5.01)
                        Text.printWP(v.name, 502, -8 + 64 * counter,5.02)
                        Graphics.drawImageWP(pm.getGraphic(CHARACTER_MEGAMAN,hudSide), 504, 10 + 64 * counter, 5.01)
                        for j = 1, thisPower do
                            Graphics.drawImageWP(pm.getGraphic(CHARACTER_MEGAMAN,energyBits), 502 + j * 4, 12 + 64 * counter, 0, 12 * (counter-1), 2, 12, 5.02)
                        end
                    end
                    currentMenu[realPositon] = counter
                    realPositon = realPositon + 1
                end
            end
            
            pauseBlink = pauseBlink + 1
            if pauseBlink % 20 == 0 then
                powerupFlicker = not powerupFlicker
            end
            if pauseBlink > 30000 then
                pauseBlink = 0
            end
            inPauseReset = false
        end
    end
end


local function introTeleport()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            local flickerTime, teleportSound
            if not introOver then
                introDelay = true;
                if(p:mem(0x122,FIELD_WORD) == 3 or p:mem(0x122,FIELD_WORD) == 7 or p:mem(0x122,FIELD_WORD) == 8) then
                    introOver = true;
                else
                    p:mem(0x114, FIELD_WORD, 50)
                    introTime = introTime + 1
                    Misc.pause()
                    flickerTime = 160
                    if (introTime) < flickerTime then
                        if (not introFlickerOff) then
                            Graphics.drawImageWP(pm.getGraphic(CHARACTER_MEGAMAN,readySign), 362, 293, 5)
                        end
                        if introTime % 20 == 0 then
                            introFlickerOff = not introFlickerOff
                        end
                    else
                        if not (hasPlayedTeleport) then
                            local teleportSound = Audio.SfxOpen(pm.getSound(CHARACTER_MEGAMAN,sfx_teleport))
                            Audio.SfxPlayCh(18, teleportSound, 0)
                            hasPlayedTeleport = true
                        end    
                        local heightMod = 0
                        local cam = camera
                        
                        if not noMoreMovement then
                            teleportModifier = teleportModifier + 32
                            if p.y + p.height - 64 < cam.y + teleportModifier then
                                recordedTime = introTime
                                noMoreMovement = true
                                teleportModifier = p.y + p.height - 64 - cam.y
                            end
                        else
                            if introTime == (recordedTime + 5) then
                                introOver = true
                            elseif introTime > (recordedTime + 3) then
                                heightMod = 2
                            elseif introTime > (recordedTime + 1) then
                                heightMod = 1
                            end
                        end
                        Graphics.drawImageToSceneWP(pm.getGraphic(CHARACTER_MEGAMAN,teleportImage), p.x - 8, cam.y + teleportModifier, 48 * (p.powerup - 1), 64 * heightMod, 48, 64, -20)
                    end
                end
            end
            if introOver then
                Misc.unpause()
            end
        end
    end
end

local function checkKeys(v)
    local winstate = Level.winState()
    -- HOLD KEYS YEAH?!?
    if(v ~= nil and v.isValid and v.id == 31) then
        local w = v.width*0.5;
        local h = v.height*0.5;
                
        if(w <= 0) then w = 1; end
        if(h <= 0) then h = 1; end
                
        for _, q in ipairs(BGO.getIntersecting(v.x+w*0.5, v.y + h * 0.5, v.x + w*1.5, v.y + h*2.5)) do
            if q.id == 35 and not q.isHidden and winstate == 0 then
                Level.winState(3)
                v.y = v.y + 0.5 * w
                Audio.SeizeStream(-1)
                Audio.MusicStop()
                playSFX(31)
            end
        end
    end
end

local function checkValidity(b)
    return not (b.isHidden)
end

local function cancelCharge()
    chargeTime = 0
    if(chargeSfxObject ~= nil and chargeSfxObject:IsPlaying()) then
        chargeSfxObject:Stop();
        chargeSfxObject = nil;
    end
end

local function doPowerIncrease()
    local toIncrease = megaman.powerUpStuff[pIncNPC.powerValue].left
    
    if pIncNPC.isIncreaseHealth then
        toIncrease = health
    end
    
    if pIncTimer%3 == 0 then
        toIncrease = math.min(toIncrease + 1, 28)
        if pIncNPC.isIncreaseHealth then
            health = toIncrease
        else
            megaman.powerUpStuff[pIncNPC.powerValue].left = toIncrease
        end
    end
    pIncTimer = pIncTimer + 1
    if pIncTimer >= pIncNPC.increaseValue * 3 or ((megaman.powerUpStuff[pIncNPC.powerValue].left == 28 or (pIncNPC.isIncreaseHealth and health == 28)) and pIncTimer > 8) then
        increasingPower = false
        if Audio.SfxIsPlaying(12) then
            Audio.SfxStop(12)
        end
        pIncTimer = 0
        Misc.unpause()
    end
end

local function increasePower(thisNPC)
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            increasingPower = true
            Misc.pause()
            Audio.SfxPlayCh(12, Audio.SfxOpen(pm.getSound(CHARACTER_MEGAMAN, itemSfx[thisNPC.powerupSfx])), 0)
            pIncNPC = thisNPC
            
            if not pIncNPC.powerValue then
                pIncNPC.powerValue = p.powerup
            end
        end
    end
end

local function checkPowerup(altPowerup)
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            if altPowerup == nil then altPowerup = p.powerup end
            npcPowerup.id = megaman.powerUpStuff[altPowerup].id
            npcPowerup.cost = megaman.powerUpStuff[altPowerup].cost
            npcPowerup.delay = megaman.powerUpStuff[altPowerup].delay
            npcPowerup.speedX = megaman.powerUpStuff[altPowerup].speedX
            npcPowerup.yOffset = megaman.powerUpStuff[altPowerup].yOffset
            npcPowerup.xOffset = megaman.powerUpStuff[altPowerup].xOffset
        end
    end
end

local function makeNPCInvisible(npcRef)
    npcRef:mem(0xE4, FIELD_WORD, 255)
    npcRef:mem(0xE8, FIELD_FLOAT, 0)
    npcRef:mem(0xEC, FIELD_FLOAT, 0)
end

local function removeInvalidNPCS(npcList)
    local i, j
    for i, j in pairs(npcList) do
        if (not j.isValid) then
            table.remove(npcList, i)
        end
    end
end

local function checkShots()
    local i, j, v, spawnModifier
    removeInvalidNPCS(playerFireballs)
    removeInvalidNPCS(playerHammers)
    for _, j in pairs(playerFireballs) do
        for _, v in pairs(playerHammers) do
            if v.isValid and j.isValid then
                makeNPCInvisible(v)
                if (j.direction == -1) then
                    spawnModifier = 0
                else
                    spawnModifier = NPC.config[282].width
                end
                v.x = j.x + spawnModifier
                v.y = j.y + (0.5 * NPC.config[282].height)
            end
        end
    end
    removeInvalidNPCS(playerJets)
    for _, j in pairs(playerJets) do
        if j.isValid then
            if j.direction == -1 then
                j.speedX = -2
            else
                j.speedX = 2
            end
        end
    end
end

local function handleSlide()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            if p:mem(0x140, FIELD_WORD) <= 95 then
                -- Get slide direction
                local collidedSideways
                local slidingOffset
                if (p:mem(0x106, FIELD_WORD) == -1) then
                    slidingOffset = -6.5
                    collidedSideways = (p:mem(0x148, FIELD_WORD) ~= 0)
                else
                    slidingOffset = 6.5
                    collidedSideways = (p:mem(0x14C, FIELD_WORD) ~= 0)
                end
                local fallingOff = (not p:isGroundTouching())
                
                local collisionAbove = false
                    
                -- Detect if something above us might force us to continue sliding
                -- Imperfect, but probably good enough...
                do
                    slideCollider.x = p.x; slideCollider.y = p.y - 23
                    slideCollider.width = p.width; slideCollider.height = p.height + 23
                    if p:isGroundTouching() then
                        collisionAbove = colliders.collideBlock(slideCollider, colliders.BLOCK_SOLID, p.section, checkValidity)
                    end
                end
                
                if isSliding and (slidingTime > 40 or collidedSideways or fallingOff or p.keys.jump) then
                    -- If nothing collides above us, end the slide
                    if not collisionAbove then
                        hasCollided = false
                        isSliding = false
                        cantShoot = true
                        slidingTime = 0
                        
                        -- Clear horizontal momentum if on the ground
                        if (p:isGroundTouching()) then
                            p.speedX = 0
                        end
                        -- We can start falling right away
                        if not (p.keys.jump) then
                            p.speedY = 0
                            p:mem(0x11E, FIELD_WORD, 1)
                        end
                    end
                end
                if isSliding then
                    -- Mark as having used our jump already
                    p:mem(0x60, FIELD_WORD, -1)
                    p.keys.run = false
                    -- Get some horizontal speed, and set just the right amount of upward momentum so we say perfectly level
                    p.speedX = slidingOffset
                    if p.keys.run then
                        p.speedX = slidingOffset
                    end
                    p.speedY = -0.4 - 5.9662852436304e-09
                    slidingTime = slidingTime + 1
                end
            end
        end
    end
end

local function checkDownWarp()
    for k,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            for _, warp in pairs(Warp.getIntersectingEntrance(p.x - .5 * p.width, p.y + .5 * p.height, p.x + 1.5 * p.width, p.y + p.height + 8)) do
                if warp:mem(0x80,FIELD_WORD) == 3 then
                    return true
                end
            end
        end
    end
end

local function handleCharge()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            if(p:mem(0x13E, FIELD_WORD) > 0) then
                cancelCharge()
                return;
            end
            -- charging!!
            if(chargeSfxObject ~= nil and not chargeSfxObject:IsPlaying()) then
                chargeSfxObject = Audio.SfxPlayObj(Audio.SfxOpen(pm.getSound(CHARACTER_MEGAMAN,chargeFullSfx)), -1)
            end
            if not isDead and introOver and not isSliding and not inPause and p.powerup <= 2 then
                if p.keys.run then
                    chargeTime = chargeTime + 1
                else
                    if chargeTime > 80 and chargeSfxObject ~= nil then
                        if (p:mem(0x106, FIELD_WORD) == -1) then
                            assignSpeedX = -1 * npcPowerup.speedX
                            if (npcPowerup.id ~= 160) then
                                xOffset = -1 * npcPowerup.xOffset
                            else
                                xOffset = (-1 * NPC.config[160].width)
                            end
                        else
                            assignSpeedX = npcPowerup.speedX
                            xOffset = npcPowerup.xOffset
                        end
                        theFireball = NPC.spawn(108, p.x + xOffset, p.y + 0.5 * npcPowerup.yOffset + (p:mem(0xD0, FIELD_DFLOAT) - 53)*0.5 - 16, p.section)
                        theFireball.speedX = 15 * direction;
                        theFireball:mem(0xF0, FIELD_DFLOAT, 4)
                        shootAlarm = 10;
                        chargeTime = 0;
                        chargeSfxObject:Stop()
                        chargeSfxObject = nil;
                        Audio.playSFX(pm.getSound(CHARACTER_MEGAMAN,chargeReleaseSfx))
                    elseif chargeTime ~= 0 and chargeSfxObject ~= nil then
                        cancelCharge()
                    end
                    chargeType1:KillParticles()
                    chargeType2:KillParticles()
                end

                if chargeTime == 20 then
                    chargeSfxObject = Audio.SfxPlayObj(Audio.SfxOpen(pm.getSound(CHARACTER_MEGAMAN,chargeSfx)), 0)
                end
                pointField1.x = p.x + 0.5 * p.width
                pointField1.y = p.y + 0.5 * p.height
            else
                cancelCharge()
            end
        end
    end
end

function megaman.resetPowerups()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            for i=3,7 do
                megaman.powerUpStuff[i].hasCollected = false;
                megaman.powerUpStuff[i].left = 28;
            end
            p.powerup = 2;
            formerPowerUp = 2;
        end
    end
end

function megaman.resetHealth()
    health = math.max(health, 28);
end

function megaman.makeSmall()
    health = math.min(health, 4);
end

local hurtSpeedX = 0

local function handlePowerupLogic()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            if p.BlinkTimer == 0 and not p.BlinkState and barrelcannontimer == 0 then
                p:mem(0x172,FIELD_BOOL,false)
            end
            if p:mem(0x108, FIELD_WORD) == 0 and p:mem(0x108, FIELD_WORD) == 0 then
                p:mem(0x120,FIELD_BOOL,false)
            end
            
            if (manualChange) then
                formerPowerUp = p.powerup
                manualChange = false
            elseif formerPowerUp ~= p.powerup and not manualChange then
                p.powerup = formerPowerUp
            end
            if health <= 4 and p.powerup == 2 then
                p.powerup = 1
            elseif health > 4 and (p.powerup == 1 or p.forcedState == 1) then
                p.powerup = 2
            end
            if health > 28 then
                health = 28
            end
            
            local fireballs = NPC.get(13, p.section)
            if p:mem(0x160, FIELD_WORD) > 1 or table.getn(fireballs) > 1 then
                p:mem(0x160, FIELD_WORD,1)
            end
            for g,f in pairs(fireballs) do
                f.speedY = -.33
                f:mem(0xE2, FIELD_WORD, 13)
            end
            if disableTable[p.forcedState] then
                p.forcedState = 0
                p:mem(0x140, FIELD_WORD, 150)
            end
            if p:mem(0x140, FIELD_WORD) >= 149 and not beenHitOnce then
                Audio.playSFX(pm.getSound(CHARACTER_MEGAMAN,sfx_hurt))
                cancelCharge()
                health = health - 6
                if health < 1 then
                    p:kill()
                    isDead = true
                else
                    hurtSpeedX = -1 * p:mem(0x106,FIELD_WORD)
                end
                beenHitOnce = true
            end
            if p:mem(0x140, FIELD_WORD) == 0 then
                beenHitOnce = false
            end
            if p.powerup == 2 then
                handleCharge()
            end
        end
    end
end

local hasBeenRunning = 0

local function handleMovementPhysics()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            local hurtFrames = p:mem(0x140, FIELD_WORD)
            if hurtFrames <= 95 then
                if p:mem(0x0C,FIELD_WORD) == 0 then
                    if p.forcedState == 0 then
                        if hasBeenRunning > 4 or not p:isGroundTouching() then
                            if p.keys.right then
                                p.speedX = 3.2
                            elseif p.keys.left then
                                p.speedX = -3.2
                            end
                        else
                            if p.keys.right then
                                p.speedX = 0.01
                            elseif p.keys.left then
                                p.speedX = -0.01
                            end
                        end
                        if not (p.keys.left or p.keys.right) then
                            p.speedX = 0
                        end
                    end
                end
            else
                p.speedX = hurtSpeedX
            end
        end
    end
end


function megaman.onInitAPI()
    -- Particle Setup --
    for _,p in ipairs(Player.get()) do
        chargeType1:Attach(p)
        chargeType2:Attach(p)
        pointField1 = particles.PointField(p.x + 0.5 * p.width, p.y + 0.5 * p.height, 800, 2000)
        pointField1:addEmitter(chargeType1)
        pointField1:addEmitter(chargeType2)
    end
    registerEvent(megaman, "onTick", "onTick", false)
    registerEvent(megaman, "onTickEnd", "onTickEnd", false)
    registerEvent(megaman, "onInputUpdate", "onInputUpdate", false)
    registerEvent(megaman, "onMessageBox", "onMessageBox", false)
    registerEvent(megaman, "onCameraUpdate", "onCameraUpdate", false)
    registerEvent(megaman, "onNPCKill", "onNPCKill", false)
    registerEvent(megaman, "onStart", "onStart", false)
    registerEvent(megaman, "onDraw", "onDraw", true)
    registerEvent(megaman, "onDrawEnd", "onDrawEnd", false)
    for _,p in ipairs(Player.get()) do
        if (p.character == CHARACTER_MEGAMAN) then
            megaman.powerUpStuff[p.powerup].hasCollected = true
        end
    end
end

local vanillaFrame = 0;

function megaman.onTickEnd()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            vanillaFrame = p:mem(0x114,FIELD_WORD);
        end
    end
end

function megaman.onDraw()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            if(vanillaFrame == 4) then
                p:mem(0x114,FIELD_WORD, 5);
            elseif(vanillaFrame == 6) then
                p:mem(0x114,FIELD_WORD, 4);
            elseif(vanillaFrame == 7) then
                p:mem(0x114,FIELD_WORD, 27);
            elseif(vanillaFrame == 8 and not rungrabanim:isPlaying(p)) then
                p:mem(0x114,FIELD_WORD, 11);
            elseif(vanillaFrame == 9 and not rungrabanim:isPlaying(p)) then
                p:mem(0x114,FIELD_WORD, 12);
            elseif(vanillaFrame == 10 and not rungrabanim:isPlaying(p)) then
                p:mem(0x114,FIELD_WORD, 13);
            elseif(vanillaFrame == 13) then
                p:mem(0x114,FIELD_WORD, 14);
            end
            
            if shootAlarm > 0 then
                shootAlarm = shootAlarm - 1;
                if not p:isGroundTouching() then
                    p:mem(0x114,FIELD_WORD,10)
                else
                    if vanillaFrame <= 5 then
                        p:mem(0x114,FIELD_WORD,p:mem(0x114,FIELD_WORD) + 5)
                    end
                end
            end
            if p:mem(0x140, FIELD_WORD) > 95 then
                p:mem(0x114,FIELD_WORD,16)
            end
        end
    end
end

function megaman.onDrawEnd()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            p:mem(0x114,FIELD_WORD, vanillaFrame);
        end
    end
end

function megaman.onStart()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            formerPowerUp = p.powerup
            if megaman.playIntro then
                formerX = p.x
                formerY = p.y + p:mem(0xD0, FIELD_DFLOAT)
            else
                introOver = true
            end
        else
            introOver = true
        end
    end
end

local barrelcannontimer = 0

function megaman.onTick()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            local slopeIdx = player:mem(0x48,FIELD_WORD)

            if slopeIdx > 0 then
                local slopeBlock = Block(slopeIdx)
                local slopeValue = slopeBlock.height/slopeBlock.width

                player.speedY = math.abs(player.speedX)*slopeValue*4
            end
            
            if p.BlinkTimer == 1 and p.BlinkState then
                if p.keys.jump then
                    barrelcannontimer = 1
                end
            end
            
            if p:isOnGround() then
                barrelcannontimer = 0
            end
            
            if isSliding then
                for _, v in pairs(NPC.getIntersecting(p.x - 8, p.y - 8, p.x + p.width + 8, p.y + p.height + 8)) do
                    if v.id == 91 and (not v.isHidden) and (not v.friendly) then
                        v.y = v.y - v.height
                        v:transform(v.ai1)
                        v:mem(0x130, FIELD_WORD, 1)
                        v:mem(0x132, FIELD_WORD, 1)
                        v:mem(0x134, FIELD_WORD, 1)
                        v.speedY = -7
                        v.direction = -p.direction
                        v.speedX = 2 * -p.direction
                        p:mem(0x140, FIELD_WORD, 25)
                        playSFX(88)
                    end
                end
            end
            if(p:mem(0x13E,FIELD_WORD) > 0) then
                health = 0;
            else
                if p.keys.left or p.keys.right then
                    hasBeenRunning = hasBeenRunning + 1
                else
                    hasBeenRunning = 0
                end
                handleMovementPhysics()
            end
            
            if(p:isGroundTouching() and p.speedX ~= 0 and hasBeenRunning > 8 and not p:mem(0x12E,FIELD_BOOL)) then
                runanim.speed = 14-math.ceil(math.abs(p.speedX))
                rungrabanim.speed = runanim.speed * 0.8;
                if(p:mem(0x154,FIELD_WORD) == 0 and not runanim:isPlaying(p)) then
                    runanim:play(p);
                elseif(p:mem(0x154,FIELD_WORD) > 0 and not rungrabanim:isPlaying(p)) then
                    rungrabanim:play(p);
                end
            else
                runanim:stop(p);
                rungrabanim:stop(p);
            end
            
            if p.holdingNPC ~= nil then
                cancelCharge()
                checkKeys(p.holdingNPC)
            end
            
            if(p:mem(0x13E,FIELD_WORD) > 0 or p:mem(0x122,FIELD_WORD) == 3 or p:mem(0x122,FIELD_WORD) == 7 or p:mem(0x122,FIELD_WORD) == 8) then
                cancelCharge()
            end
            
            checkPowerup()
            checkShots()
            p:mem(0x16, FIELD_WORD, 3) -- always set to 3 hearts after powerups are set
            if not isDead then
                handlePowerupLogic()
            end
            handleSlide()
        end
    end
end

function megaman.onCameraUpdate()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            if not introOver then
                introTeleport()
            else
                introDelay = false;
                if not isDead then
                    --drawHudElements()
                    if inPause then
                        Misc.pause()
                        drawPauseMenu()
                    elseif not inPause and not inPauseReset then
                        inPauseReset = true
                        Misc.unpause()
                        menuPositionSet = false
                    end
                    if increasingPower then
                        doPowerIncrease()
                    end
                    if chargeTime > 20 then
                        if chargeTime >= 80 then
                            chargeType2:Draw(-25)
                        end
                        chargeType1:Draw(-25)
                    end
                    p:mem(0x00,FIELD_WORD,0)
                    p:mem(0x16E,FIELD_WORD,0)
                    p:mem(0x16C,FIELD_WORD,0)
                    p:mem(0x174,FIELD_WORD,0)
                
                    direction = p:mem(0x106,FIELD_WORD)
                
                    -- -1 is left!
                end
            end
        end
    end
end

local function setPlayerPowerup()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            p.powerup = currentMenu[menuPosition]
            if p.powerup == 1 and health >= 4 then
                p.powerup = 2
            elseif p.powerup == 2 and health < 4 then
                p.powerup = 1
            end
        end
    end
end

local function handleAnim(anim)
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            if isExternallyPaused or inPause or increasingPower then
                if anim:isPlaying(p) then
                    anim:pause()
                end
            else
                if not anim:isPlaying(p) then
                    anim:resume()
                end
            end
        end
    end
end

function megaman.onInputUpdate()
     for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            isExternallyPaused = false
            if ((Misc.isPausedByLua() and not (inPause or increasingPower)) or (mem(0x00B250E2, FIELD_BOOL) and not Misc.isPausedByLua()))  then
                isExternallyPaused = true
            end
            handleAnim(runanim)
            handleAnim(rungrabanim)
            if p.character == CHARACTER_MEGAMAN then
                if(p:mem(0x13E, FIELD_WORD) > 0) or (p.forcedState ~= 0) then
                    return;
                end
                
                if cantShoot then
                    cantShoot = false
                    return
                end
                
                if p.keys.run == KEYS_PRESSED and not isDead and introOver and not introDelay and not isSliding and not inPause then
                    if megaman.powerUpStuff[p.powerup].left > 0 or p.powerup <= 2 then
                        local assignSpeedX, xOffset, spawnModifier
                        Audio.playSFX(pm.getSound(CHARACTER_MEGAMAN,sfx_shoot));
                        shootAlarm = 10;
                        assignSpeedX = direction * npcPowerup.speedX
                        if (npcPowerup.id == 160 and direction == -1) then
                            xOffset = (-1 * NPC.config[160].width)
                        else
                            xOffset = direction * npcPowerup.xOffset
                        end
                        theFireball = NPC.spawn(npcPowerup.id, p.x + xOffset, p.y - 8 + npcPowerup.yOffset + (p:mem(0xD0, FIELD_DFLOAT) - 53)*0.5, p.section)
                        theFireball.direction = direction
                        if (npcPowerup.id) == 13 then
                            theFireball.ai1 = 4
                        elseif (npcPowerup.id == 282) then
                            theFireball.friendly = true
                        elseif (npcPowerup.id == 292) then
                            theFireball.ai3 = 1
                            theFireball.ai5 = 1
                            theFireball:mem(0x11E, FIELD_BYTE, 240)
                        end
                        if (p.powerup == 3) then
                            table.insert(playerFireballs, theFireball)
                            if (theFireball.direction == -1) then
                                spawnModifier = 0
                            else
                                spawnModifier = NPC.config[282].width
                            end
                            theHammer = NPC.spawn(171, theFireball.x + spawnModifier, theFireball.y + (0.5 * NPC.config[282].height), p.section)
                            table.insert(playerHammers, theHammer)
                        end
                        if (p.powerup == 5) then
                            table.insert(playerJets, theFireball)
                        end
                        theFireball.speedX = assignSpeedX
                        megaman.powerUpStuff[p.powerup].left = math.max(megaman.powerUpStuff[p.powerup].left - npcPowerup.cost,0)
                    end
                end
            end
            if not isExternallyPaused then
                if (p:mem(0x140, FIELD_WORD) > 95 and not inPause) or Level.winState() > 0 then
                    p.keys.jump = false
                    p.keys.run = false
                    p.keys.altRun = false
                    p.keys.left = false
                    p.keys.right = false
                    if Level.winState() > 0 then
                        if Level.winState() == 1 or Level.winState() == 7 then
                            p.keys.right = true
                        end
                        isSliding = false
                        p.keys.down = false
                        inPause = false
                        p.keys.up = false
                    end
                end
                if itemSfxObject ~= nil then --lock p during powerup
                    if itemSfxObject:IsPlaying() then
                        cancelCharge()
                        p.keys.run = false
                        p.keys.altRun = false
                    end
                end
                if inPause then
                    p.keys.left = false
                    p.keys.right = false
                end
            
                -- But if we're sliding, hold the down key
                if isSliding and not inPause then
                    p.keys.down = true
                end
                
                -- And if we're pressing the down key plus the jump key, that's the key combo
                local keyComboPressed = (p.keys.down and p.keys.jump)
                
                
                -- Consider the key combo invalid if we're not on the ground
                -- NOTE: Remove this check if you want to allow air-sliding ( http://www.romhacking.net/hacks/1177/ ? )
                if (not p:isGroundTouching()) then
                    keyComboPressed = false
                end
                
                -- And if we hadn't pressed the combo last tick, am now, and we're not currently sliding... start sliding
                local startSlide = keyComboPressed and not wasKeyComboPressed and not isSliding
                
                local downwarp = checkDownWarp()
                
                -- If we're sliding, ignore the non-movement buttons (even on the very tick where we used the jump key to initiate slide)
                if isSliding then
                    if initiatedSlide then
                        if not p.keys.jump then
                            initiatedSlide = false
                        end
                        p.keys.jump = false
                    end
                else
                
                    if startSlide then
                        isSliding = true
                        p.keys.jump = false
                        initiatedSlide = true
                        p:mem(0x164, FIELD_WORD, 0)
                    else
                        p:mem(0x164, FIELD_WORD, -1)
                    end
                    -- EDIT: Don't do this as it breaks pipes and pulling up things
                    -- p.keys.down = false
                end
                
                --old
                --if p:mem(0x40,FIELD_WORD) ~= 3 and (not downwarp) and (not keyComboPressed) and (not isSliding) and (not inPause) and (p:mem(0x0C, FIELD_WORD) == 0) then
                    --p.keys.down = false;
                --end
                --disable ducking
                if p:mem(0x12E, FIELD_WORD) == -1 and p:mem(0x164, FIELD_WORD) == -1 then
                    p.keys.down = false
                end
                
                if (p.keys.down and inPause) and (not wasDownPressed) and (not isDead) then
                    menuPosition = menuPosition + 1
                    Audio.playSFX(pm.getSound(CHARACTER_MEGAMAN,sfx_cursor))
                    if menuPosition > #currentMenu then
                        menuPosition = 0
                    end
                    manualChange = true
                    setPlayerPowerup()
                end
                if (p.keys.up and inPause) and (not isDead) and (not wasUpPressed) then
                    menuPosition = menuPosition - 1
                    Audio.playSFX(pm.getSound(CHARACTER_MEGAMAN,sfx_cursor))
                    if menuPosition < 0 then
                        menuPosition = #currentMenu
                    end
                    manualChange = true
                    setPlayerPowerup()
                end
                if p.keys.altJump == KEYS_PRESSED and (not wasSelectPressed) and (not isDead) and Level.winState() == 0 then
                    Audio.playSFX(pm.getSound(CHARACTER_MEGAMAN,sfx_pause))
                    if not inPause then
                        p.powerup = 2;
                        menuPosition = 1;
                    end
                    smasBooleans.toggleOffInventory = not smasBooleans.toggleOffInventory
                    inPause = not inPause
                end
                
                --disable hover
                --soon
            end
                
            wasKeyComboPressed = keyComboPressed
            wasDownPressed = p.keys.down
            wasUpPressed = p.keys.up
            wasSelectPressed = p.keys.altJump
        end
    end
end


function megaman.onNPCKill(eventObj, npc, killReason)
     for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            if NPCItemSfxArray[npc.id] ~= nil then
                if killReason == 9 and colliders.collideNPC(p, npc) then
                    if NPCItemSfxArray[npc.id].setPower then
                        local toSetValue = 0
                        checkPowerup(NPCItemSfxArray[npc.id].powerValue)
                        toSetValue = 2 * npcPowerup.cost
                        if not megaman.powerUpStuff[NPCItemSfxArray[npc.id].powerValue].hasCollected then
                            p.powerup = NPCItemSfxArray[npc.id].powerValue
                            megaman.powerUpStuff[NPCItemSfxArray[npc.id].powerValue].hasCollected = true
                            manualChange = true
                        else
                            manualChange = true
                        end
                        cancelCharge()
                        p.forcedState = 0
                        increasePower(NPCItemSfxArray[npc.id])
                        checkPowerup()
                    else
                        increasePower(NPCItemSfxArray[npc.id])
                    end
                end
            end
        end
    end
end

function megaman.onMessageBox(eventObj,message)
    isSliding = false;
end

function megaman.initCharacter()
    -- CLEANUP NOTE: This is not safe if a level makes it's own use of defines
    Defines.player_runspeed = 4 / 1.07 -- Correction for 7% toad speed boost
    Defines.player_walkspeed = 3 / 1.07 -- Correction for 7% toad speed boost
    Defines.jumpheight = 21
    Defines.jumpheight_bounce = 18
    Defines.gravity = 16
    Defines.player_grav = 0.45
    
    -- Adjust size of player chargeshot
    NPC.config[108].gfxwidth = 64;
    NPC.config[108].gfxheight = 60;
    NPC.config[108].height = 64;
    NPC.config[108].width = 60;
    NPC.config[108].frames = 3;
    NPC.config[108].framestyle = 1;
end

function megaman.cleanupCharacter()
    -- CLEANUP NOTE: This is not safe if a level makes it's own use of defines
    Defines.player_runspeed = nil
    Defines.player_walkspeed = nil
    Defines.jumpheight = nil
    Defines.jumpheight_bounce = nil
    Defines.gravity = nil
    Defines.player_grav = nil
    
    -- Reset dimensions for player chargeshot
    NPC.config[108].gfxwidth = 32;
    NPC.config[108].gfxheight = 32;
    NPC.config[108].height = 32;
    NPC.config[108].width = 32;
    NPC.config[108].frames = 2;
    NPC.config[108].framestyle = 1;
    
    introOver = true
    introDelay = false
    firstRun = true
    cancelCharge()
    for _,p in ipairs(Player.get()) do
        if p.character == CHARACTER_MEGAMAN then
            runanim:stop(p);
            rungrabanim:stop(p);
        end
    end
    
    inPause = false
    pauseBlink = 0
    menuPosition = 0
end

return megaman