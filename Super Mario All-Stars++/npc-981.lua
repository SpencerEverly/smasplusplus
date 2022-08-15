local fuzzy = {}

local npcID = NPC_ID

local npcManager = require("npcManager")

fuzzy.settings = npcManager.setNpcSettings{
    id = npcID,
    
    width = 48,
    height = 40,
    gfxwidth = 64,
    gfxheight = 60,
    gfxoffsetx = 0,
    gfxoffsety = 6,
    ignorethrownnpcs = true,
    speed = 1,
    frames = 2,
    framespeed = 16,
    nogravity = true,
    noblockcollision = true,
    noyoshi = false,
    grabside = false,
    jumphurt = true,
    nohurt = true,
    isinteractable = true
}

local harmTypes = {
    HARM_TYPE_JUMP, HARM_TYPE_NPC, HARM_TYPE_EXT_FIRE, HARM_TYPE_EXT_ICE, HARM_TYPE_EXT_HAMMER, --no dizzy
    HARM_TYPE_TAIL --dizzy
}

local harmMap = {}
for _,v in ipairs(harmTypes) do
    harmMap[v] = 131
end

npcManager.registerHarmTypes(npcID, harmTypes, harmMap)

fuzzy.dizziness = lunatime.toTicks(15)
fuzzy.dizzySfx = Misc.resolveSoundFile("fuzzy-dizzy")

local function compileShader(filename)
    filename = filename..".frag"
    local shader = Shader()
    shader:compileFromFile(nil, Misc.multiResolveFile(filename, "shaders/npc/"..filename))
    return shader
end

local dizzyShader, backgroundShader, pixelShader

local screenBuffer = Graphics.CaptureBuffer(800,600)

local dizzy = 0

function fuzzy.getDizzy()
    dizzy = fuzzy.dizziness
    SFX.play(fuzzy.dizzySfx)
end

function fuzzy.isDizzy()
    return dizzy > 0
end

function fuzzy.onInitAPI()
    registerEvent(fuzzy, "onTick")
    npcManager.registerEvent(npcID, fuzzy, "onTickNPC")
    registerEvent(fuzzy, "onNPCKill")
    registerEvent(fuzzy, "onDraw")
end

function fuzzy.onTick()
    if fuzzy.isDizzy() then
        dizzy = dizzy - 1
    end
end

function fuzzy.onTickNPC(npc)
    if npc.isHidden or npc:mem(0x12A,FIELD_WORD) <= 0 or npc:mem(0x136, FIELD_BOOL) then
        return
    end
    
    npc.speedX = npc.direction --vanilla logic handles npc.txt speed multiplication
    npc.ai1 = npc.ai1 + 1
    npc.speedY = math.sin(lunatime.toSeconds(npc.ai1))*0.66666
end

function fuzzy.onNPCKill(_, npc, reason, culprit)
    if npc.id == npcID then
        if reason == 1 or reason == 7 or (reason == 9 and npcManager.collected(npc, reason)) or reason == 10 then
            if type(culprit) ~= "Player" or not (culprit.isMega or culprit.hasStarman) then
                fuzzy.getDizzy()
            end
        end
    end
end

function fuzzy.onDraw()
    if dizzy > 0 then
        dizzyShader      = dizzyShader      or compileShader("fuzzy")
        backgroundShader = backgroundShader or compileShader("fuzzy_bg")
        pixelShader      = pixelShader      or compileShader("fuzzy_pixel")    
        local d = (dizzy/(fuzzy.dizziness/2) - 1)
        local intensity = 1 - d * d
        screenBuffer:captureAt(-95)
        Graphics.drawScreen{
            texture = screenBuffer,
            shader = backgroundShader,
            priority = -95,
            uniforms = {
                time = lunatime.time(),
                intensity = intensity
            }
        }
        screenBuffer:captureAt(-5)
        Graphics.drawScreen{
            texture = screenBuffer,
            shader = dizzyShader,
            priority = -5,
            uniforms = {
                time = lunatime.time(),
                cameraX = (camera.x / camera.width) % 1,
                intensity = intensity
            }
        }
    end
    if dizzy >= fuzzy.dizziness/2 then
        local d = (dizzy/(fuzzy.dizziness/2) - 1)
        local size = 50 * d*d - 25
        if size > 1 then
            local pxSize = {camera.width/size,camera.height/size}
            screenBuffer:captureAt(-5)
            Graphics.drawScreen{
                texture = screenBuffer,
                shader = pixelShader,
                priority = -5,
                uniforms = {pxSize = pxSize}
            }
        end
    end
end

return fuzzy
