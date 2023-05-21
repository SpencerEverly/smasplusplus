local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local DiagCannon = {}
local npcID = NPC_ID

local DiagCannonSettings = {
    id = npcID,
    gfxheight = 32,
    gfxwidth = 32,
    width = 32,
    height = 32,
    gfxoffsetx = 0,
    gfxoffsety = 0,
    frames = 1,
    framestyle = 1,
    speed = 0,
    npcblock = true,
    npcblocktop = true,
    playerblock = true,
    playerblocktop = true,
    nohurt=true,
    nogravity = true,
    noblockcollision = false,
    nofireball = false,
    noiceball = false,
    noyoshi = true,
    nowaterphysics = true,
    --Various interactions
    jumphurt = true,
    spinjumpsafe = false,
    harmlessgrab = false,
    harmlessthrown = true,
    shootrate = 295
}

npcManager.setNpcSettings(DiagCannonSettings)
npcManager.registerDefines(npcID,{NPC.UNHITTABLE})

function DiagCannon.onInitAPI()
    npcManager.registerEvent(npcID, DiagCannon,"onTickNPC")
    npcManager.registerEvent(npcID, DiagCannon,"onStartNPC")
end

function DiagCannon.onStartNPC(v)
    if v:mem(0xDE,FIELD_WORD) == 0 then
        v:mem(0xDE,FIELD_WORD,136)
    end
end

function DiagCannon.onTickNPC(v)
    if Defines.levelFreeze then return end
    
    local data = v.data
    
    if v:mem(0x12A, FIELD_WORD) <= 0 then
        data.waitingframe = 0
        return
    end

    if data.waitingframe == nil then
        data.waitingframe = 0
    end

    if v:mem(0x12C, FIELD_WORD) > 0
    or v:mem(0x136, FIELD_BOOL)
    or v:mem(0x138, FIELD_WORD) > 0
    then
        data.waitingframe = 0
    else
        data.waitingframe = data.waitingframe + 1
    end
    
    npcutils.applyLayerMovement(v)
    
    if data.waitingframe > NPC.config[npcID].shootrate then
        v1 = NPC.spawn(v:mem(0xDE,FIELD_WORD),v.x+(NPC.config[npcID].width*v.direction),v.y-NPC.config[npcID].height,player.section)
        v1.direction = v.direction
        if Player.count() >= 2 then
            if player.section ~= player2.section then
                v2 = NPC.spawn(v:mem(0xDE,FIELD_WORD),v.x+(NPC.config[npcID].width*v.direction),v.y-NPC.config[npcID].height,player2.section)
                v2.direction = v.direction
            end
        end
        Animation.spawn(10,v.x+(NPC.config[npcID].width*v.direction)/2,v.y-NPC.config[npcID].height/2)
        SFX.play(22)
        data.waitingframe = 0
    end
end

return DiagCannon