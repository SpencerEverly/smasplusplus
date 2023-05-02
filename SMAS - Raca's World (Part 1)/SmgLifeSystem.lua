--[[
        SmgLifeSystem.lua
        v1.2

        By Marioman2007
        inspired from smgModder.lua by PixelPest
]]

local SmgLifeSystem = {}

local Hudoverride = require("hudoverride") -- Hudoverride.lua is required to remove the display of hearts
local npcManager = require("npcManager")

----------- Local stuff -----------
local Air = 0
local restoreAir = 0
local AirMeterOpacity = 0
local coinsCollected = 0
local HurtAnimframes = 0
local canSethurtFrame = true

local fancyAnimActive = false
local DisplayMaxHealth = false
local PlayerX = 0
local PlayerY = 0
local goingUpX = false
local goingUpY = false
local LerpTimer = 0
local MaxHealthAnim = 0
local CountingUp = false
local Ysource = 0
local YsourceTwo = 0

local icantswim_waterBoxes = {}
local icantswim_inWater = false


function SmgLifeSystem.onStart()
        Air = SmgLifeSystem.AirTime

    for _,v in ipairs(Liquid.get()) do
        if v.isQuicksand == false then
            table.insert(icantswim_waterBoxes, v)
        end
    end
end

function SmgLifeSystem.onTick()
    icantswim_inWater = false
    for _,w in ipairs(icantswim_waterBoxes) do
        if w.layer.isHidden == false then
            if (table.maxn(Player.getIntersecting(w.x, w.y, w.x + w.width, w.y + w.height)) > 0) then
                icantswim_inWater = true
            end
        end
    end

        if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL then
        HurtAnimframes = math.floor((lunatime.tick() / SmgLifeSystem.HarmedFrameSpeed) % SmgLifeSystem.HarmedFrames[player.character]) -- Frame calculation for hurt frames
    else
        HurtAnimframes = 0
    end

        if player.powerup == 1 and player.forcedState ~= FORCEDSTATE_POWERDOWN_SMALL then
                player.powerup = 2
        end
        
        if SmgLifeSystem.HealthCounter == 0 and player.deathTimer == 0 then
                player:kill()
        end

        -- Increasing the opacity of the Air Meter
        if ((player:mem(0x34, FIELD_WORD) > 0 and player:mem(0x06, FIELD_WORD) == 0) or (SmgLifeSystem.icantswimSupport and icantswim_inWater)) and SmgLifeSystem.AirMeterActive then
                if AirMeterOpacity < 1 then
                        AirMeterOpacity = AirMeterOpacity + SmgLifeSystem.AirFadeSpeed
                elseif AirMeterOpacity > 1 then
                        AirMeterOpacity = 1
                end
        else
                if AirMeterOpacity > 0 then
                        AirMeterOpacity = AirMeterOpacity - SmgLifeSystem.AirFadeSpeed
                elseif AirMeterOpacity < 0 then
                        AirMeterOpacity = 0
                end
        end

        -- Freeze Game Effect
        if SmgLifeSystem.FreezeGameEnabled then
                Defines.levelFreeze = (SmgLifeSystem.powerupStates[player.forcedState] or mem(0x00B2C62E,FIELD_WORD,  0))
        end

        -- Activation of Daredevil Run
    if SmgLifeSystem.daredevilActive then
        SmgLifeSystem.daredevilRun()
                SmgLifeSystem.HealthCounter = SmgLifeSystem.MainHealth

                Audio.sounds[5].muted = true
        else
                Audio.sounds[5].muted = false
    end

        -- Activation of Coin health system
    if SmgLifeSystem.coinHealthActive then
        SmgLifeSystem.coinHealth()
    end

        -- Activation of Air Meter
    if SmgLifeSystem.AirMeterActive then
        SmgLifeSystem.airMeter()
    end
end

function SmgLifeSystem.onDraw()
        ---- Calculation of the maximum health drawing system BEGINS here ----
        local XcoordCalculation = camera.x + SmgLifeSystem.healthX
        local YcoordCalculation = camera.y + SmgLifeSystem.healthY
        local NewXcoordCalculation = XcoordCalculation + SmgLifeSystem.MaxOffsetX
        local NewYcoordCalculation = YcoordCalculation + SmgLifeSystem.MaxOffsetY
        local YsourceCalculation = SmgLifeSystem.HealthCounter
        local FancyXcoord = 0
        local FancyYcoord = 0

        if CountingUp then
                MaxHealthAnim = MaxHealthAnim + 1
        end

        if MaxHealthAnim == SmgLifeSystem.FancyAnimFrameSpeed then
                Ysource = Ysource + 1
                MaxHealthAnim = 0
                YsourceTwo = 0
        end

        if Ysource == SmgLifeSystem.FancyAnimFrames then
                SmgLifeSystem.DoFancyStuff()
                MaxHealthAnim = 0
                Ysource = 0
        end

        if Ysource <= (SmgLifeSystem.FancyAnimFrames - 1) then
                YsourceTwo = Ysource
        end

        if fancyAnimActive then
                LerpTimer = LerpTimer + 0.025
                
                if goingUpX then
                        FancyXcoord = math.lerp(PlayerX, NewXcoordCalculation, LerpTimer)
                end

                if goingUpY then
                        FancyYcoord = math.lerp(PlayerY, NewYcoordCalculation, LerpTimer)
                end
        else
                LerpTimer = 0
        end

        if FancyXcoord == NewXcoordCalculation then
                goingUpX = false
        end

        if FancyYcoord == NewYcoordCalculation then
                goingUpY = false
        end

        if (FancyXcoord == NewXcoordCalculation) and (FancyYcoord == NewYcoordCalculation) then
                SmgLifeSystem.StopFancyStuff()
        end

        if SmgLifeSystem.HealthCounter <= SmgLifeSystem.MainHealth then
                YsourceCalculation = SmgLifeSystem.HealthCounter
        elseif SmgLifeSystem.HealthCounter > SmgLifeSystem.MainHealth then
                YsourceCalculation = SmgLifeSystem.MaxHealth + 2
        end
        ---- Calculation of the maximum health drawing system ENDS here ----


        ---- Drawing BEGINS here ----
        if player.deathTimer == 0 then
                -- When daredevil mode isn't active
                if not SmgLifeSystem.daredevilActive then
                        Graphics.drawImageToSceneWP(
                                SmgLifeSystem.health,
                                XcoordCalculation,
                                YcoordCalculation,
                                0,
                                SmgLifeSystem.HealthMeterHeight * YsourceCalculation,
                                SmgLifeSystem.HealthMeterWidth,
                                SmgLifeSystem.HealthMeterHeight,
                                SmgLifeSystem.HealthPriority
                        )

                        if (SmgLifeSystem.HealthCounter > SmgLifeSystem.MainHealth) and (DisplayMaxHealth or (not SmgLifeSystem.doFancyAnim)) then
                                Graphics.drawImageToSceneWP(
                                        SmgLifeSystem.health,
                                        NewXcoordCalculation,
                                        NewYcoordCalculation,
                                        0,
                                        SmgLifeSystem.HealthMeterHeight * SmgLifeSystem.HealthCounter,
                                        SmgLifeSystem.HealthMeterWidth,
                                        SmgLifeSystem.HealthMeterHeight,
                                        SmgLifeSystem.HealthPriority
                                )
                        end

                        if CountingUp then
                                Graphics.drawImageToSceneWP(
                                        SmgLifeSystem.FancyAnimSheet,
                                        PlayerX,
                                        PlayerY,
                                        0,
                                        YsourceTwo * SmgLifeSystem.HealthMeterHeight,
                                        SmgLifeSystem.HealthMeterWidth,
                                        SmgLifeSystem.HealthMeterHeight,
                                        SmgLifeSystem.HealthPriority
                                )
                        end

                        if fancyAnimActive then
                                Graphics.drawImageToSceneWP(
                                        SmgLifeSystem.FancyAnimSheet,
                                        FancyXcoord,
                                        FancyYcoord,
                                        0,
                                        (SmgLifeSystem.FancyAnimFrames - 1) * SmgLifeSystem.HealthMeterHeight,
                                        SmgLifeSystem.HealthMeterWidth,
                                        SmgLifeSystem.HealthMeterHeight,
                                        SmgLifeSystem.HealthPriority
                                )
                        end
                end

                -- When daredevil mode is active
                if SmgLifeSystem.daredevilActive then
                    Graphics.drawImageToSceneWP(
                                SmgLifeSystem.health,
                                XcoordCalculation,
                                YcoordCalculation,
                                0,
                                SmgLifeSystem.HealthMeterHeight * (SmgLifeSystem.MaxHealth + 1),
                                SmgLifeSystem.HealthMeterWidth,
                                SmgLifeSystem.HealthMeterHeight,
                                SmgLifeSystem.HealthPriority
                        )
                end

        -- Drawing "0" health
        elseif player.deathTimer > 0 then
                Graphics.drawImageToSceneWP(
                        SmgLifeSystem.health,
                        XcoordCalculation,
                        YcoordCalculation,
                        0,
                        0,
                        SmgLifeSystem.HealthMeterWidth,
                        SmgLifeSystem.HealthMeterHeight,
                        SmgLifeSystem.HealthPriority
                )
        end

        -- Drawing the Air Meter
        if (SmgLifeSystem.AirAlwaysVisible and SmgLifeSystem.AirMeterActive) or SmgLifeSystem.AirMeterActive then
                Graphics.drawImageWP(
                        SmgLifeSystem.AirMeter,
                        SmgLifeSystem.AirX,
                        SmgLifeSystem.AirY,
                        0,
                        SmgLifeSystem.AirMeterHeight * SmgLifeSystem.AirLeft,
                        SmgLifeSystem.AirMeterWidth,
                        SmgLifeSystem.AirMeterHeight,
                        AirMeterOpacity,
                        SmgLifeSystem.AirPriority
                )
        end
        ---- Drawing ENDS here ----


        -- Set the opacity of the Air Meter to 1, when it should be always visible
        if SmgLifeSystem.AirAlwaysVisible or SmgLifeSystem.AirLeft < SmgLifeSystem.AirMax then
                AirMeterOpacity = 1
        end

        -- preventing the healing powerups to get stored in the reserve Box
        if (SmgLifeSystem.HealingPowerups[player.reservePowerup]) then
            player.reservePowerup = 0
        end

        -- Remove heart display
        if (Graphics.getHUDType(player.character) == Graphics.HUD_HEARTS) then
                smasHud.visible.itemBox = false
        else
                smasHud.visible.itemBox = true
        end

        -- hurt animation stuff
        if (SmgLifeSystem.daredevilActive) or (player.deathTimer > 0) or (SmgLifeSystem.HealthCounter == 0) then
                canSethurtFrame = false
        else
                canSethurtFrame = true
        end

        if SmgLifeSystem.SetHurtFrame then
                SmgLifeSystem.setHurtFrame()
        end

        -- snippet for icantswim.lua support
    InWaterBoxes = false
        local liquids = Liquid.get()
        for _, liquid in ipairs(liquids) do
                if (not liquid.isQuicksand) and (not liquid.layer.isHidden) then
                        if liquid.getIntersecting(player.x, player.y, player.width, player.height) then
                                InWaterBoxes = true
                        end
                end
        end
end

function SmgLifeSystem.onPostNPCKill(killedNPC, harmType)
        if npcManager.collected(killedNPC, harmType) and harmType == HARM_TYPE_VANISH then
                -- Adding HP to the health counter when the player "kills" any of the healing powerups
                if not SmgLifeSystem.daredevilActive then
                        if (SmgLifeSystem.HealingPowerups[killedNPC.id]) then
                                if SmgLifeSystem.HealthCounter ~= SmgLifeSystem.MainHealth and SmgLifeSystem.HealthCounter ~= SmgLifeSystem.MaxHealth then
                                        SmgLifeSystem.HealthCounter = SmgLifeSystem.HealthCounter + 1
                                        coinsCollected = 0
                                else
                                        if SmgLifeSystem.CoinsReward > 0 then
                                                Misc.coins(SmgLifeSystem.CoinsReward, false)
                                        end
                                end
                        end

                        -- Counting how many coins the player has collected when HP is not full
                        if SmgLifeSystem.coinHealthActive then
                                if (SmgLifeSystem.HealingCoins[killedNPC.id]) then
                                        if SmgLifeSystem.HealthCounter ~= SmgLifeSystem.MainHealth and SmgLifeSystem.HealthCounter ~= SmgLifeSystem.MaxHealth then
                                                coinsCollected = coinsCollected + 1
                                        end
                                elseif (SmgLifeSystem.BlueCoins[killedNPC.id]) then
                                        coinsCollected = coinsCollected + 5
                                end
                        end
                end
        end
end

function SmgLifeSystem.onPostPlayerKill()
        SmgLifeSystem.HealthCounter = 0
        Defines.earthquake = SmgLifeSystem.EarthquakePower -- Earthquake effect when the player dies
end

function SmgLifeSystem.onPostPlayerHarm()
        if player.deathTimer == 0 then
                if not daredevilActive then
                        if (player.mount ~= MOUNT_BOOT and player.mount ~= MOUNT_YOSHI) and player.powerup == 2 then
                                if not player.hasStarman then
                                        SmgLifeSystem.HealthCounter = SmgLifeSystem.HealthCounter - 1
                                        Defines.earthquake = SmgLifeSystem.EarthquakePower
                                        coinsCollected = 0
                                end
                        end
                end

                if SmgLifeSystem.HealthCounter == 0 then
                        Audio.sounds[5].muted = true
                else
                        Audio.sounds[5].muted = false
                end
        end
end

function SmgLifeSystem.CountUp()
        Misc.pause()
        CountingUp = true
        PlayerX = player.x
        PlayerY = player.y
end

function SmgLifeSystem.DoFancyStuff()
        CountingUp = false
        fancyAnimActive = true
        goingUpX = true
        goingUpY = true
end

function SmgLifeSystem.StopFancyStuff()
        Misc.unpause()
        MaxHealthAnim = 0
        fancyAnimActive = false
        goingUpX = false
        goingUpY = false
        DisplayMaxHealth = true

        if not SmgLifeSystem.daredevilActive then
                if SmgLifeSystem.HealthCounter ~= SmgLifeSystem.MaxHealth then
                        SmgLifeSystem.setHealth(SmgLifeSystem.MaxHealth, 1)
                end
        end
end

function SmgLifeSystem.setHurtFrame()
        if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL and canSethurtFrame then
                player.frame = -50 -- Make player invisible

                Graphics.drawBox{
                        texture      = SmgLifeSystem.HarmedSheet[player.character],
                        sceneCoords  = true,
                        x            = player.x + (player.width / 2) + SmgLifeSystem.HarmedFrameOffsetX[player.character],
                        y            = ((player.y + (player.height / 2)) + SmgLifeSystem.HarmedFrameOffsetY[player.character]),
                        width        = SmgLifeSystem.perFrameSideLength * player.direction,
                        height       = SmgLifeSystem.perFrameSideLength,
                        sourceX      = SmgLifeSystem.perFrameSideLength * SmgLifeSystem.HarmedSheetRow[player.character],
                        sourceY      =  SmgLifeSystem.perFrameSideLength * HurtAnimframes,
                        sourceWidth  = SmgLifeSystem.perFrameSideLength,
                        sourceHeight = SmgLifeSystem.perFrameSideLength,
                        centered     = true,
                        priority     = -25,
                }
        end
end

local function PreventOverflow()
        if SmgLifeSystem.HealthCounter > SmgLifeSystem.MaxHealth then
                SmgLifeSystem.HealthCounter = SmgLifeSystem.MaxHealth
        end

        if SmgLifeSystem.AirLeft > SmgLifeSystem.AirMax then
                SmgLifeSystem.AirLeft = SmgLifeSystem.AirMax
        end
end

-- Function to Add Health / Air
function SmgLifeSystem.addHealth(value, type)
        local ExtraHp = SmgLifeSystem.MainHealth - SmgLifeSystem.HealthCounter

        if type == 1 then
                if SmgLifeSystem.HealthCounter <= SmgLifeSystem.MainHealth and value > ExtraHp then
                        value = ExtraHp
                end
                SmgLifeSystem.HealthCounter = math.max(SmgLifeSystem.HealthCounter + value, 0)
        elseif type == 2 then
                SmgLifeSystem.AirLeft = math.max(SmgLifeSystem.AirLeft + value, 0)
        end

        PreventOverflow()
end

-- Function to Set Health / Air
function SmgLifeSystem.setHealth(value, type)
        if type == 1 then
                SmgLifeSystem.HealthCounter = math.max(value, 0)
        elseif type == 2 then
                SmgLifeSystem.AirLeft = math.max(value, 0)
        end

        PreventOverflow()
end

-- Daredevil Run
function SmgLifeSystem.daredevilRun()
    if not SmgLifeSystem.daredevilAllowPowerups then
        player.powerup = 2
    end

    if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL then
        player:kill()
    end
end

-- Coin Health System
function SmgLifeSystem.coinHealth()
        if coinsCollected == SmgLifeSystem.CoinsToHeal and not SmgLifeSystem.daredevilActive then
                if SmgLifeSystem.HealthCounter ~= SmgLifeSystem.MainHealth and SmgLifeSystem.HealthCounter ~= SmgLifeSystem.MaxHealth then
                        SmgLifeSystem.HealthCounter = SmgLifeSystem.HealthCounter + 1
                        coinsCollected = 0
                end
        end
end

-- Air Meter
function SmgLifeSystem.airMeter()
        if (player:mem(0x34, FIELD_WORD) > 0 and player:mem(0x06, FIELD_WORD) == 0) or (SmgLifeSystem.icantswimSupport and icantswim_inWater) then
        if player.forcedState == FORCEDSTATE_NONE then
                    Air = Air - 1
        end
        else
                if restoreAir < SmgLifeSystem.AirRestoreTime and player.deathTimer == 0 then
                        restoreAir = restoreAir + 1
                end
        end

        if SmgLifeSystem.AirLeft ~= SmgLifeSystem.AirMax and (restoreAir == SmgLifeSystem.AirRestoreTime) then
                restoreAir = 0
                SmgLifeSystem.AirLeft = SmgLifeSystem.AirLeft + 1
        end

        if Air == 0 then
                if SmgLifeSystem.AirLeft ~= 0 then
                        SmgLifeSystem.AirLeft = SmgLifeSystem.AirLeft - 1
                elseif SmgLifeSystem.AirLeft == 0 then
                        SmgLifeSystem.HealthCounter = SmgLifeSystem.HealthCounter - 1
                        Defines.earthquake = SmgLifeSystem.EarthquakePower
                end

                Air = SmgLifeSystem.AirTime
                restoreAir = 0
        end
end


-- registering the events
function SmgLifeSystem.onInitAPI()
        -- Main Events
        registerEvent(SmgLifeSystem, "onStart", "onStart", false)
    registerEvent(SmgLifeSystem, "onTick", "onTick", false)
    registerEvent(SmgLifeSystem, "onDraw", "onDraw", false)
    registerEvent(SmgLifeSystem, "onPostNPCKill", "onPostNPCKill", false)
        registerEvent(SmgLifeSystem, "onPostPlayerKill", "onPostPlayerKill", false)
        registerEvent(SmgLifeSystem, "onPostPlayerHarm", "onPostPlayerHarm", false)

        -- Library Specific Events
    registerEvent(SmgLifeSystem, "daredevilRun", "daredevilRun", false)
        registerEvent(SmgLifeSystem, "coinHealth", "coinHealth", false)
        registerEvent(SmgLifeSystem, "airMeter", "airMeter", false)
end


-- Images
SmgLifeSystem.health = Graphics.loadImageResolved("SmgLifeSystem/healthMeter.png")
SmgLifeSystem.AirMeter = Graphics.loadImageResolved("SmgLifeSystem/AirMeter.png")
SmgLifeSystem.FancyAnimSheet = Graphics.loadImageResolved("SmgLifeSystem/healthMeter_fancy.png")

SmgLifeSystem.HarmedSheet = {
        [CHARACTER_MARIO] = Graphics.loadImageResolved("SmgLifeSystem/Harmed Mario Sheet.png"),
        [CHARACTER_LUIGI] = Graphics.loadImageResolved("SmgLifeSystem/Harmed Luigi Sheet.png"),
        [CHARACTER_PEACH] = Graphics.loadImageResolved("SmgLifeSystem/Harmed Peach Sheet.png"),
        [CHARACTER_TOAD] = Graphics.loadImageResolved("SmgLifeSystem/Harmed Toad Sheet.png")}

----------- A Ton of Customizable Stuff -----------
---- Health Meter related ----
SmgLifeSystem.healthX = 0                                         -- X co-ordinate of the health meter
SmgLifeSystem.healthY = 0                                         -- Y co-ordinate of the health meter
SmgLifeSystem.MaxOffsetX = -24                                    -- Offset X bettwen the main health counter and max health counter
SmgLifeSystem.MaxOffsetY = 0                                      -- Offset Y bettwen the main health counter and max health counter
SmgLifeSystem.HealthMeterHeight = 96                              -- Height of the health bar, useful for drawing level specific health meters
SmgLifeSystem.HealthMeterWidth = 86                               -- Width of the health bar
SmgLifeSystem.HealthPriority = 5                                  -- Priority of the Health Meter stuff
SmgLifeSystem.MainHealth = 3                                      -- Main Health of the player
SmgLifeSystem.MaxHealth = 6                                       -- Max Health of the player
SmgLifeSystem.HealthCounter = SmgLifeSystem.MainHealth            -- the player's health

---- Air Meter related ----
SmgLifeSystem.AirX = 0                                            -- X co-ordinate of the air meter for drawing level specific air meters
SmgLifeSystem.AirY = 120                                          -- Y co-ordinate of the air meter
SmgLifeSystem.AirMeterHeight = 96                                 -- Height of the health bar, useful for drawing level specific air meters
SmgLifeSystem.AirMeterWidth = 86                                  -- Width of the health bar, useful, useful for drawing level specific health meters
SmgLifeSystem.AirPriority = 6                                     -- Priority of the Air Meter stuff
SmgLifeSystem.AirFadeSpeed = 0.05                                 -- How fast the Air Meter should fade
SmgLifeSystem.AirAlwaysVisible = false                            -- Whether the Air Meter will be always visible
SmgLifeSystem.AirMax = 6                                          -- Max value of the air meter
SmgLifeSystem.AirLeft = SmgLifeSystem.AirMax                      -- the player's  Air

---- Bools (True/False) ----
SmgLifeSystem.daredevilAllowPowerups = false                      -- Whether to allow powerups in daredevil run or not
SmgLifeSystem.FreezeGameEnabled = true                            -- Whether the game will be freezed while powering up or down (Thanks to MrDoubleA!)
SmgLifeSystem.SetHurtFrame = true                                 -- set a custom harmed frame when the player gets hurt? NOTE: to properly remove the hurt animation, you also need to remove the players' ini files
SmgLifeSystem.icantswimSupport = true                             -- use the Air Meter with icantswim.lua?

SmgLifeSystem.daredevilActive = false                             -- is the Daredevil Mode active?
SmgLifeSystem.coinHealthActive = false                            -- is the Coin Health System active?
SmgLifeSystem.AirMeterActive = false                              -- is the Air Meter active?

---- Variables ----
SmgLifeSystem.CoinsToHeal = 10                                    -- Amount of coins needed to heal one health
SmgLifeSystem.CoinsReward = 10                                    -- The amount of coins given to the player when the player collects a mushroom when the HP is full, NOTE: this is for the powerups in the SmgLifeSystem.HealingPowerups table, for custom powerups, use NPC configs
SmgLifeSystem.EarthquakePower = 5                                 -- Power of the earthquake, when the player takes damage
SmgLifeSystem.AirTime = 64                                        -- How long the player can air under-water (for one segment of Air Meter, in Ticks). NOTE: 64 Ticks = 1 Second
SmgLifeSystem.AirRestoreTime = 64                                 -- Number of Ticks to restore 1 segment of Air Meter. NOTE: 64 Ticks = 1 Second

---- Tables ----
SmgLifeSystem.HealingCoins = table.map{10, 33, 88, 138, 411}      -- Coins that once collected enough, restore HP
SmgLifeSystem.BlueCoins = table.map{258}                          -- Coins that are equal to 5 normal coins

SmgLifeSystem.HealingPowerups = table.map{9, 184, 185, 249, 250}  -- Power-Ups that restore HP, NOTE: this table is mainly for vanilla NPCs, custom NPCs can be set to grant HP (see example Power-Ups)

-- Forced-States in which the game will freeze if SmgLifeSystem.FreezeGameEnabled is true
SmgLifeSystem.powerupStates = table.map{
    FORCEDSTATE_POWERUP_BIG, FORCEDSTATE_POWERDOWN_SMALL, FORCEDSTATE_POWERUP_FIRE, FORCEDSTATE_POWERUP_LEAF, FORCEDSTATE_POWERUP_TANOOKI,
    FORCEDSTATE_POWERUP_HAMMER, FORCEDSTATE_POWERUP_ICE, FORCEDSTATE_POWERDOWN_FIRE, FORCEDSTATE_POWERDOWN_ICE, FORCEDSTATE_MEGASHROOM,}

---- Fancy Animation related ----
SmgLifeSystem.doFancyAnim = true                                  -- Will there be a fancy animation when the player's health gets to maximum value
SmgLifeSystem.FancyAnimFrames = 4                                 -- frames of the fancy animation
SmgLifeSystem.FancyAnimFrameSpeed = 16                            -- Speed of the fancy animation

---- Hurt Animation Related ----
SmgLifeSystem.HarmedFrameSpeed = 5                                -- Speed of the hurt animation
SmgLifeSystem.perFrameSideLength = 100                            -- the length of the side of each hurt frame

SmgLifeSystem.HarmedFrames = {                                    -- Value of the frames the hurt animation has (Per-Character)
        [CHARACTER_MARIO] = 2, [CHARACTER_LUIGI] = 2,
        [CHARACTER_PEACH] = 2, [CHARACTER_TOAD] = 2}

SmgLifeSystem.HarmedSheetRow = {                                  -- row of the image in the harmed frames image, starts from 0 (Per-Character)
        [CHARACTER_MARIO] = 4, [CHARACTER_LUIGI] = 0,
        [CHARACTER_PEACH] = 0, [CHARACTER_TOAD] = 0}

SmgLifeSystem.HarmedFrameOffsetX = {                              -- X-Offset of the hurt animation (Per-Character)
        [CHARACTER_MARIO] = 0, [CHARACTER_LUIGI] = 0,
        [CHARACTER_PEACH] = 0, [CHARACTER_TOAD] = 0}

SmgLifeSystem.HarmedFrameOffsetY = {                              -- Y-Offset of the hurt animation (Per-Character)
        [CHARACTER_MARIO] = -3, [CHARACTER_LUIGI] = 0,
        [CHARACTER_PEACH] = -12, [CHARACTER_TOAD] = -1}

---- Functions to add and set health air ----
-- SmgLifeSystem.addHealth(value, type) adds the given value to the type, set the type to 1 for the health meter and 2 for the air meter
-- SmgLifeSystem.setHealth(value, type) sets the given value to the type, set the type to 1 for the health meter and 2 for the air meter

return SmgLifeSystem