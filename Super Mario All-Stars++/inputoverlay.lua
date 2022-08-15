-- Scripted by LooKiCH (Lukinsky)
-- GFX by Wohlstand for TheXTech

local inputoverlay = {} -- Lib

local inputoverlaybg = Graphics.loadImage(Misc.resolveFile("inputoverlay/inputoverlaybg.png")) -- Input Overlay BG

-- Pressed Keys:
local controlkey = Graphics.loadImage(Misc.resolveFile("inputoverlay/control.png"))
local jumpkey = Graphics.loadImage(Misc.resolveFile("inputoverlay/jump.png"))
local altjumpkey = Graphics.loadImage(Misc.resolveFile("inputoverlay/altjump.png"))
local runkey = Graphics.loadImage(Misc.resolveFile("inputoverlay/run.png"))
local altrunkey = Graphics.loadImage(Misc.resolveFile("inputoverlay/altrun.png"))
local bottomkeys = Graphics.loadImage(Misc.resolveFile("inputoverlay/bottomkey.png"))
local specialkey = Graphics.loadImage(Misc.resolveFile("inputoverlay/specialkey.png"))

-- Input Overlay:
function inputoverlay.onDraw()
    local p = player
    Graphics.drawImageWP(inputoverlaybg,4,566,5.1) -- Released Keys
    if p.keys.left == KEYS_DOWN then -- Pressed Left Key
        Graphics.drawImageWP(controlkey,8,578,5.2) 
    end
    if p.keys.right == KEYS_DOWN then -- Pressed Right Key
        Graphics.drawImageWP(controlkey,20,578,5.2)
    end
    if p.keys.up == KEYS_DOWN then -- Pressed Up Key
        Graphics.drawImageWP(controlkey,14,572,5.2)
    end
    if p.keys.down == KEYS_DOWN then -- Pressed Down Key
        Graphics.drawImageWP(controlkey,14,584,5.2)
    end
    if p.keys.jump == KEYS_DOWN then -- Pressed Jump Key
        Graphics.drawImageWP(jumpkey,68,584,5.2)
    end
    if p.keys.run == KEYS_DOWN then -- Pressed Run Key
        Graphics.drawImageWP(runkey,58,582,5.2)
    end
    if p.keys.altJump == KEYS_DOWN then -- Pressed Alt Jump Key
        Graphics.drawImageWP(altjumpkey,70,574,5.2)
    end
    if p.keys.altRun == KEYS_DOWN then -- Pressed Alt Run Key
        Graphics.drawImageWP(altrunkey,60,572,5.2)
    end
    if p.keys.dropItem == KEYS_DOWN then -- Pressed Drop Item Key
        Graphics.drawImageWP(bottomkeys,30,588,5.2)
    end
    if p.keys.pause == KEYS_DOWN then -- Pressed Pause Key
        Graphics.drawImageWP(bottomkeys,44,588,5.2)
    end
    if Player.count() >= 2 then then
        Graphics.drawImageWP(inputoverlaybg,8 + inputoverlaybg.width,566,5.1) -- Released Keys
        if p2.keys.left == KEYS_DOWN then -- Pressed Left Key
            Graphics.drawImageWP(controlkey,12 + inputoverlaybg.width,578,5.2) 
        end
        if p2.keys.right == KEYS_DOWN then -- Pressed Right Key
            Graphics.drawImageWP(controlkey,24 + inputoverlaybg.width,578,5.2)
        end
        if p2.keys.up == KEYS_DOWN then -- Pressed Up Key
            Graphics.drawImageWP(controlkey,18 + inputoverlaybg.width,572,5.2)
        end
        if p2.keys.down == KEYS_DOWN then -- Pressed Down Key
            Graphics.drawImageWP(controlkey,18 + inputoverlaybg.width,584,5.2)
        end
        if p2.keys.jump == KEYS_DOWN then -- Pressed Jump Key
            Graphics.drawImageWP(jumpkey,72 + inputoverlaybg.width,584,5.2)
        end
        if p2.keys.run == KEYS_DOWN then -- Pressed Run Key
            Graphics.drawImageWP(runkey,62 + inputoverlaybg.width,582,5.2)
        end
        if p2.keys.altJump == KEYS_DOWN then -- Pressed Alt Jump Key
            Graphics.drawImageWP(altjumpkey,74 + inputoverlaybg.width,574,5.2)
        end
        if p2.keys.altRun == KEYS_DOWN then -- Pressed Alt Run Key
            Graphics.drawImageWP(altrunkey,64 + inputoverlaybg.width,572,5.2)
        end
        if p2.keys.dropItem == KEYS_DOWN then -- Pressed Drop Item Key
            Graphics.drawImageWP(bottomkeys,34 + inputoverlaybg.width,588,5.2)
        end
        if p2.keys.pause == KEYS_DOWN then -- Pressed Pause Key
            Graphics.drawImageWP(bottomkeys,48 + inputoverlaybg.width,588,5.2)
        end
    end
end

function inputoverlay.onInitAPI()
    registerEvent(inputoverlay, 'onDraw')
end

return inputoverlay -- Return Lib