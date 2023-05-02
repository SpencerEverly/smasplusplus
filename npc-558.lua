local npcManager = require("npcManager")

local cherries =  {}

local npcID = NPC_ID

local cherrySettings = npcManager.setNpcSettings({
    id = npcID, 
    gfxwidth = 32, 
    gfxheight = 32, 
    width = 32, 
    height = 32, 
    frames = 6,
    framestyle = 0,
    framespeed = 8,
    score = 1,
    playerblock=false,
    nogravity = false,
    nofireball=true,
    noiceball=true,
    grabside = false,
    nohurt=true,
    isinteractable=true,
    iscoin=true,
    starID = 994,
    limit = 5
})

local cherryCounters = {}

function cherries.onInitAPI()
    npcManager.registerEvent(npcID, cherries, "onTickEndNPC")
    registerEvent(cherries, "onNPCHarm")
    registerEvent(cherries, "onNPCKill")
end

function cherries.onTickEndNPC(v)
    if not v:mem(0x136, FIELD_BOOL) then
        v.speedX = 0
    end
end

function cherries.onNPCHarm(eo, v, reason, culprit)
    if v.id ~= npcID then return end
    if reason ~= 2 then return end
    eo.cancelled = true
end

function cherries.onNPCKill(_, v, reason)
    if v.id ~= npcID then return end
    if reason ~= 9 then return end
    if(v:mem(0x12E, FIELD_WORD) == 0) then
        for _,p in ipairs(Player.get()) do
            --  Just been eaten                   --  Player riding yoshi             --  Tongue moving back in  --  Tongue not extended (last two only occur after eating something)
            if((v:mem(0x138,FIELD_WORD) == 5 and p:mem(0x108,FIELD_WORD) == 3 and p:mem(0xB6,FIELD_BOOL) and not p:mem(0x10C,FIELD_BOOL)) --[[Eaten by yoshi]] or Colliders.collide(v, p) or Colliders.speedCollide(v, p) or Colliders.slash(p,v) or Colliders.downSlash(p,v)) then
                if cherryCounters[p] == nil then
                    cherryCounters[p] = 0
                end
                cherryCounters[p] = cherryCounters[p] + 1
                if cherryCounters[p] == NPC.config[v.id].limit then
                    Sound.playSFX("cherry-5.ogg")
                    local cameraPlayer = player
                    if camera2.isSplit and (p.idx == 2) then
                        cameraPlayer = p
                    end
                    local c = Camera(cameraPlayer.idx)
                    if (cameraPlayer.section == p.section) then
                        local star = NPC.spawn(NPC.config[v.id].starID, p.x + 0.5 * p.width, c.y + c.height, p.section)
                        star:mem(0x12A, FIELD_WORD, 180)
                        star.direction = p.direction
                        star.layerName = "Spawned NPCs"
                    end
                    cherryCounters[p] = 0
                end
                break
            end
        end
    end
end

return cherries