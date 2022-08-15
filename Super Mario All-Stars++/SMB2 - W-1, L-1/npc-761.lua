local npc = {}

local id = NPC_ID

local settings = {
    id = id,
    
    frames = 2,
    framespeed = 8,
    
    width = 64,
    gfxwidth = 64,
    height = 32,
    gfxheight = 32,
    
    jumphurt = true,
    nohurt = true,

    playerblocktop = true,
    npcblocktop = true,
    
    nogravity = true,
    noblockcollision = true,
    noiceball = true,
    noyoshi = true,
}

function npc.onInitAPI()
    local npcManager = require("npcManager")
    
    npcManager.setNpcSettings(settings)
    npcManager.registerEvent(id, npc, 'onCameraDrawNPC')
    npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

local function drawNPC(npcobject, args)
    args = args or {}
    if npcobject.__type ~= "NPC" then
        error("Must pass a NPC object to draw. Example: drawNPC(myNPC)")
    end
    local frame = args.frame or npcobject.animationFrame

    local afs = args.applyFrameStyle
    if afs == nil then afs = true end

    local cfg = NPC.config[npcobject.id]
    
    --gfxwidth/gfxheight can be unreliable
    local trueWidth = cfg.gfxwidth
    if trueWidth == 0 then trueWidth = npcobject.width end

    local trueHeight = cfg.gfxheight
    if trueHeight == 0 then trueHeight = npcobject.height end

    --drawing position isn't always exactly hitbox position
    local x = npcobject.x + 0.5 * npcobject.width - 0.5 * trueWidth + cfg.gfxoffsetx + (args.xOffset or 0)
    local y = npcobject.y + npcobject.height - trueHeight + cfg.gfxoffsety + (args.yOffset or 0)

    --cutting off our sprite might be nice for piranha plants and the likes
    local w = args.width or trueWidth
    local h = args.height or trueHeight

    local o = args.opacity or 1

    --the bane of the checklist's existence
    local p = args.priority or -45

    local sourceX = args.sourceX or 0
    local sourceY = args.sourceY or 0

    --framestyle is a weird thing...

    local frames = args.frames or cfg.frames
    local f = frame or 0
    --but only if we actually pass a custom frame...
    if args.frame and afs and cfg.framestyle > 0 then
        if cfg.framestyle == 2 then
            if npcobject:mem(0x12C, FIELD_WORD) > 0 or npcobject:mem(0x132, FIELD_WORD) > 0 then
                f = f + 2 * frames
            end
        end
        if npcobject.direction == 1 then
            f = f + frames
        end
    end

    Graphics.drawImageToSceneWP(args.texture or Graphics.sprites.npc[npcobject.id].img, x, y, sourceX, sourceY + trueHeight * f, w, h, o, p)
end

function npc.onCameraDrawNPC(v)
    if v:mem(0x138, FIELD_WORD) == 0 then return end
    
    if v:mem(0x138, FIELD_WORD) ~= 8 then
        local config = NPC.config[id]
        
        local framespeed = config.framespeed * 4
        local frame = 0
        local frametimer = lunatime.tick() % framespeed
        
        if frametimer >= framespeed / 2 then
            frame = 1
        end
    
        drawNPC(v, {frame = frame, priority = -96})
        v.animationFrame = -1
    end
end

function npc.onTickEndNPC(v)    
    if v.ai1 == 0 then
        v.speedY = v.speedY + 0.025
    end
end

return npc