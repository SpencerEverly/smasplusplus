--[[
    icantswim.lua v1.0.2
    
    A library that puts players in a low gravity state when they're in water, instead of a swimming state.
    
    by cold soup
]]

local icantswim = {}

-------- modifiable variables --------

-- filenames and effect IDs
icantswim.splashEffectID = 962
icantswim.bubbleEffectID = 963
icantswim.splashSound = Audio.SfxOpen("_OST/_Sound Effects/sonic_splash.ogg")

-- booleans to disable or enable effects/sounds
icantswim.doSplash = true
icantswim.doBubble = true
icantswim.doSplashSound = true

-- physics of the player in water
icantswim.waterJumpHeight = 40 -- jump height of the player in water (base jump height is 20)
icantswim.waterFallSpeed = 3 -- fall speed of the player in water (base fall speed is 12)
icantswim.waterRunSpeed = 4 -- run speed of the player in water (base fall speed is 12)

---------- code starts here ----------

local waterBoxes = {}
local inWater = false
local hasEnterSplashed = false
local hasExitSplashed = true
local players = Player.get()
local p = players[1]
local currentBox
local bubbleTimer = 0
local randomValue = 0

local bettereffects = require("base/game/bettereffects")

function icantswim.onInitAPI()
    registerEvent(icantswim, "onStart")
    registerEvent(icantswim, "onTick")
end

function icantswim.spawnSplash(w)
    if icantswim.doSplash then
        if (table.maxn(Player.getIntersecting(currentBox.x, currentBox.y-16, currentBox.x+currentBox.width, currentBox.y+16)) > 0) then
            Animation.spawn(icantswim.splashEffectID, p.x-24, currentBox.y-32)
        end
        if icantswim.doSplashSound then
            SFX.play(icantswim.splashSound)
        end
    end
end

function icantswim.spawnBubble(o)
    if icantswim.doBubble then
        if RNG.randomInt(5) == 0 then
            Animation.spawn(icantswim.bubbleEffectID, (o.x+(o.width/2)+((o.width/4)*o.direction))-8, o.y+(o.height/2)-8)
        end
    end
end

function icantswim.onStart()
    for _,v in ipairs(Liquid.get()) do
        if v.isQuicksand == false then
            table.insert(waterBoxes, v)
            v.isHidden = true
        end
    end
end

function icantswim.onTick()
    inWater = false
    bubbleTimer = bubbleTimer + 1
    for _,w in ipairs(waterBoxes) do
        if w.layer.isHidden == false then
            if (table.maxn(Player.getIntersecting(w.x, w.y, w.x+w.width, w.y+w.height)) > 0) then
                currentBox = w
                if hasEnterSplashed == false then
                    icantswim.spawnSplash()
                    hasEnterSplashed = true
                end
                hasExitSplashed = false
                inWater = true
            end
            for _,n in ipairs(NPC.getIntersecting(w.x, w.y, w.x+w.width, w.y+w.height)) do
                n:mem(0x1C, FIELD_WORD, 3)
            end
        end
    end
    
    if inWater == true then
        if not hasChangedDefines then
            hasChangedDefines = true
            
            defJumpHeight = Defines.jumpheight
            defJumpHeightBounce = Defines.jumpheight_bounce
            defGravity = Defines.gravity
            defWalkSpeed = Defines.player_walkspeed
            defRunSpeed = Defines.player_runspeed
            
            Defines.jumpheight = icantswim.waterJumpHeight
            Defines.jumpheight_bounce = icantswim.waterJumpHeight
            Defines.gravity = icantswim.waterFallSpeed
            Defines.player_walkspeed = icantswim.waterRunSpeed/2
            Defines.player_runspeed = icantswim.waterRunSpeed
        end
        
        if bubbleTimer >= 15 then
            icantswim.spawnBubble(p)
        end
    else
        if hasChangedDefines then
            hasChangedDefines = false
            
            Defines.jumpheight = defJumpHeight
            Defines.jumpheight_bounce = defJumpHeightBounce
            Defines.gravity = defGravity
            Defines.player_walkspeed = defWalkSpeed
            Defines.player_runspeed = defRunSpeed
        end
        
        if hasExitSplashed == false then
            icantswim.spawnSplash()
            hasExitSplashed = true
            p:mem(0x11C,FIELD_WORD,(p:mem(0x11C,FIELD_WORD)/2))
        end
        
        hasEnterSplashed = false
    end
    
    for _,a in ipairs(bettereffects.getEffectObjects(icantswim.bubbleEffectID)) do
        bubbleInWater = false
        for _,b in ipairs(waterBoxes) do
            if ((a.x >= b.x and a.x <= b.x+b.width) and (a.y >= b.y and a.y <= b.y+b.height) and b.layer.isHidden == false)  then
                bubbleInWater = true
            end
        end
        if bubbleInWater == false then
            a.timer = 0
        end
    end
    
    if bubbleTimer >= 15 then
        bubbleTimer = 0
    end
end

return icantswim