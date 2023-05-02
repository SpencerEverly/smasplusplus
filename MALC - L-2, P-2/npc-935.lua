local minecart = {}

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local npcID = NPC_ID

local sfx_ride = Audio.SfxOpen(Misc.multiResolveFile("minecart-ride.wav", "../sound/minecart-ride.wav"))
local sfx_jump = Audio.SfxOpen(Misc.multiResolveFile("minecart-jump.wav", "../sound/minecart-jump.wav"))

local config = npcManager.setNpcSettings({
    id = npcID,
    gfxwidth = 96,
    gfxheight = 68,
    width = 96,
    height = 68,
    gfxoffsety = 0,
    speed = 1,
    frames = 4,
    framespeed = 4,
    framestyle = 0,
    score = 0,
    jumphurt = true,
    spinjumpsafe = false,
    nohurt = true,
    noyoshi=true,
    grabside = false,
    harmlessthrown=false,
    noiceball=false,
    nofireball=false,
    nogravity = false,
    foreground = true,
})
npcManager.registerHarmTypes(npcID, {HARM_TYPE_EXT_FIRE, HARM_TYPE_EXT_ICE, HARM_TYPE_EXT_HAMMER})

local disableinputjump = function(p)
  Routine.run(function()
    local t = 0
    while true do
      t = t + 1
      if t > 5 and p.rawKeys.jump == KEYS_PRESSED or (p.character == CHARACTER_ROSALINA or p.character == CHARACTER_NINJABOMBERMAN) then
        break
      end
      p.jumpKeyPressing = false
      Routine.waitFrames(1)
    end
  end)

  Routine.run(function()
    local t = 0
    while true do
      t = t + 1
      if t > 5 and p.rawKeys.altJump == KEYS_PRESSED or ((p.character == CHARACTER_PEACH or p.character == CHARACTER_KLONOA or p.character == CHARACTER_ROSALINA or p.character == CHARACTER_NINJABOMBERMAN) and p.speedY >= 0) then
        break
      end
      p.altJumpKeyPressing = false
      Routine.waitFrames(1)
    end
  end)
end

local iniNPC = function(n)
  local data = n.data
  if not data.check then
        data.check = true
    data.animationTimer = 0
        data._settings.speed = 7
        data._settings.allowjump = true
        data.speed = data._settings.speed
        data.allowjump = data._settings.allowjump
        data.loopsound = SFX.play(sfx_ride)
        data.sprite = Sprite.box{x = n.x, y = n.y, width = npcutils.gfxwidth(n), height = npcutils.gfxheight(n), texture = Graphics.sprites.npc[n.id].img, rotation = 0, align = vector(0.5, 1), frames = npcutils.getTotalFramesByFramestyle(n)}
        data.storedplayer = {}
    end
end

function minecart.onTickNPC(n)
  local data = n.data
    iniNPC(n)
    local sprite = data.sprite


    local blist = Colliders.getColliding{a = Colliders.Box(n.x, n.y + n.height, n.width, 32), b = Block.ALL, btype = Colliders.BLOCK, filter=function() return true end}
    if blist[1] then
        local _, _, N = Colliders.raycast(vector(n.x + n.width, n.y + n.height - 2), vector(0, 18), blist)
        if not N then
            _, _, N = Colliders.raycast(vector(n.x, n.y + n.height - 2), vector(0, 32), blist)
        end
        if N then
            sprite.rotation = math.deg(math.atan2(N.y, N.x)) + 90
        else
            sprite.rotation = 0
        end
    else
        sprite.rotation = 0
    end


    if #data.storedplayer > 0 then
        n.speedX = math.min(data.speed, math.max(-data.speed, n.speedX + 0.4))
        if not data.loopsound:isPlaying() then
          data.loopsound = SFX.play(sfx_ride)
        end
    else
        n.speedX = n.speedX*0.95
  end

    for k, p in ipairs(Player.get()) do
        -- Add player to minacart
    if p.y > n.y and p.speedY > 0 and #data.storedplayer <= 2 and data.storedplayer[1] ~= p and data.storedplayer[2] ~= p and Colliders.collide(n, p) then
            p:mem(0x18,    FIELD_BOOL, true)
            p:mem(0x1C, FIELD_WORD, 0)
            p:mem(0x50, FIELD_BOOL, false)
            table.insert(data.storedplayer, p)
        end
    end


    for k = #data.storedplayer, 1, -1 do
        local p = data.storedplayer[k]
        -- Remove dead players
        if p.deathTimer > 0 then
            table.remove(data.storedplayer, k)
        else
            -- Hop out of the minecart
            if p.keys.altJump == KEYS_PRESSED and data.allowjump then
                disableinputjump(p)
                p:mem(0x18,    FIELD_BOOL, true)
                p:mem(0x1C, FIELD_WORD, 0)
                p:mem(0x50, FIELD_BOOL, false)
                p.speedY = -10
                SFX.play(1)
                table.remove(data.storedplayer, k)
            else
                p.y = n.y + 0.4*n.height - p.height
            end

      -- Jump
            if p.keys.jump == KEYS_PRESSED and n.collidesBlockBottom  then
                SFX.play(sfx_jump)
                n.speedY = -8
            end
        end
    end

    if #data.storedplayer == 1 then
        local p = data.storedplayer[1]
        p.x = n.x + 0.5*n.width - 0.5*p.width
    elseif #data.storedplayer == 2 then
        local p1, p2 = data.storedplayer[1], data.storedplayer[2]
        p1.x = n.x + 0.70*n.width - 0.5*p1.width
        p2.x = n.x + 0.25*n.width - 0.5*p2.width
    end

end

function minecart.onDrawNPC(n)
    local data = n.data
    iniNPC(n)
    local sprite = data.sprite

    n.animationTimer = 0
    if math.abs(n.speedX) < 0.1 then
    else
        local v = math.min(n.data.speed, math.abs(n.speedX))
        data.animationTimer = math.floor(data.animationTimer + v/2)
    end

    local framespeed = config.framespeed
    if data.animationTimer >= framespeed then
        n.animationTimer = framespeed
        data.animationTimer = data.animationTimer - framespeed
    end

    sprite.x = n.x + n.width*0.5 + config.gfxoffsetx
    sprite.y = n.y + n.height
    local p = -45
    if config.foreground then
        p = -15
    end

    local y = sprite.texposition.y
    sprite.texposition.y = y - npcutils.gfxheight(n)*n.animationFrame
    sprite:draw{priority = p, sceneCoords = true}
    sprite.texposition.y = y
    npcutils.hideNPC(n)
end

function minecart.onInitAPI()
  npcManager.registerEvent(npcID, minecart, "onTickNPC")
    npcManager.registerEvent(npcID, minecart, "onDrawNPC")
end

return minecart
