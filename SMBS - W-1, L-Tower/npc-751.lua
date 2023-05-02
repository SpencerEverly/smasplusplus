--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local rng = require("base/rng")
local smasExtraSounds = require("smasExtraSounds")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
    id = npcID,
    effect = 998,
    --Sprite size
    gfxheight = 64,
    gfxwidth = 64,
    --Hitbox size. Bottom-center-bound to sprite size.
    width = 64,
    height = 64,
    --Sprite offset from hitbox for adjusting hitbox anchor on sprite.
    gfxoffsetx = 0,
    gfxoffsety = 0,
    --Frameloop-related
    frames = 4,
    framestyle = 0,
    framespeed = 8, --# frames between frame change
    --Movement speed. Only affects speedX by default.
    speed = 1,
    --Collision-related
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.

    nohurt=false,
    nogravity = false,
    noblockcollision = false,
    nofireball = true,
    noiceball = true,
    noyoshi= true,
    nowaterphysics = false,
    --Various interactions
    jumphurt = false, --If true, spiny-like
    spinjumpsafe = true, --If true, prevents player hurt when spinjumping
    harmlessgrab = false, --Held NPC hurts other NPCs if false
    harmlessthrown = false, --Thrown NPC hurts other NPCs if false

    grabside=false,
    grabtop=false,

    --Identity-related flags. Apply various vanilla AI based on the flag:
    --iswalker = false,
    --isbot = false,
    --isvegetable = false,
    --isshoe = false,
    --isyoshi = false,
    --isinteractable = false,
    --iscoin = false,
    --isvine = false,
    --iscollectablegoal = false,
    --isflying = false,
    --iswaternpc = false,
    --isshell = false,

    --Emits light if the Darkness feature is active:
    --lightradius = 100,
    --lightbrightness = 1,
    --lightoffsetx = 0,
    --lightoffsety = 0,
    --lightcolor = Color.white,

    --Define custom properties below
}

--Applies NPC settings
npcManager.setNpcSettings(sampleNPCSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
    {
        HARM_TYPE_JUMP,
        --HARM_TYPE_FROMBELOW,
        HARM_TYPE_NPC,
        --HARM_TYPE_PROJECTILE_USED,
        HARM_TYPE_LAVA,
        --HARM_TYPE_HELD,
        --HARM_TYPE_TAIL,
        --HARM_TYPE_SPINJUMP,
        --HARM_TYPE_OFFSCREEN,
        HARM_TYPE_SWORD
    }, 
    {
        --[HARM_TYPE_JUMP]=10,
        --[HARM_TYPE_FROMBELOW]=10,
        --[HARM_TYPE_NPC]=10,
        --[HARM_TYPE_PROJECTILE_USED]=10,
        --[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
        --[HARM_TYPE_HELD]=10,
        --[HARM_TYPE_TAIL]=10,
        --[HARM_TYPE_SPINJUMP]=10,
        --[HARM_TYPE_OFFSCREEN]=10,
        --[HARM_TYPE_SWORD]=10,
    }
);

--Custom local definitions below


--Register events
function sampleNPC.onInitAPI()
    npcManager.registerEvent(npcID, sampleNPC, "onTickNPC")
    npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
    npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
    registerEvent(sampleNPC, "onNPCHarm")
    registerEvent(sampleNPC, "onNPCKill")
end

function sampleNPC.onTickEndNPC(v)
    --Don't act during time freeze
    if Defines.levelFreeze then return end
    
    local data = v.data
    
    --If despawned
    if v.despawnTimer <= 0 then
        --Reset our properties, if necessary
        data.initialized = false
        return
    end

    --Initialize
    if not data.initialized then
        --Initialize necessary data.
        data.initialized = true
        
        data.moving = true
        data.jump = false
        data.jumpactive = true
        data.hurtstate = false
        
        data.jumpmovement = 0
        
        data.hurtstate2 = false
        
        v.ai1 = 0
        v.ai2 = 70
        
        data.hp = 4
    end

    --Depending on the NPC, these checks must be handled differently
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        --Handling
    end
    
    --Execute main AI. This template just jumps when it touches the ground.
    if data.moving then
        v.ai1 = v.ai1 + 1
        if data.hp >= 4 then
            v.speedX = 2 * v.direction
        elseif data.hp >= 2 then
            v.speedX = 3 * v.direction
        elseif data.hp >= 1 then
            v.speedX = 4 * v.direction
        end
    end
    if not data.moving then
        v.speedX = 0
    end
    if data.jumpactive then
        if v.ai1 >= RNG.randomInt(1,50) then
            v.ai1 = -180
            data.jump = true
        end
        if data.jump then
            v.speedY = -7
            data.jumpmovement = data.jumpmovement + 1
            if data.jumpmovement == 1 then
                SFX.play(Misc.resolveSoundFile("robot-jump"))
            end
            if data.jumpmovement >= 5 then
                data.jumpmovement = 0
                data.jump = false
            end
        end
    end
    if not data.jumpactive then
        v.speedY = 6
    end
    
    if data.hp <= 0 then
        v:kill(HARM_TYPE_OFFSCREEN)
        local e =  Effect.spawn(998, v.x + 15, v.y + 85)
        SFX.play(Misc.resolveSoundFile("robot-dead"))
    end
    
    if data.hurtstate then
        if v.direction == -1 then
            v.animationFrame = 1
        elseif v.direction == 1 then
            v.animationFrame = 5
        end
        data.moving = false
        data.jumpactive = false
        v.ai2 = v.ai2 - 1
        if v.ai2 <= 0 then
            v.ai2 = 70
            data.moving = true
            data.jumpactive = true
            data.hurtstate = false
            data.hurtstate2 = false
        end
    end
end

function sampleNPC.onNPCHarm(eventObj, v, killReason, culprit)
    if npcID ~= v.id or v.isGenerator then return end
    local data = v.data
    
    if not data.hurtstate2 then
        if killReason ~= HARM_TYPE_VANISH then
            eventObj.cancelled = true
            SFX.play(smasExtraSounds.sounds[39].sfx)
            data.hp = data.hp - 1
            if data.hp >= 1 then
                SFX.play(Misc.resolveSoundFile("robot-hurt"))
            end
            data.hurtstate2 = true
            data.hurtstate = true
        elseif killReason == HARM_TYPE_SWORD then
            eventObj.cancelled = true
            SFX.play(smasExtraSounds.sounds[39].sfx)
            data.hp = data.hp - 2
            if data.hp >= 1 then
                SFX.play(Misc.resolveSoundFile("robot-hurt"))
            end
            data.hurtstate2 = true
            data.hurtstate = true
        end
    end
    if data.hurtstate2 then
        eventObj.cancelled = true
    end
end

--Gotta return the library table!
return sampleNPC