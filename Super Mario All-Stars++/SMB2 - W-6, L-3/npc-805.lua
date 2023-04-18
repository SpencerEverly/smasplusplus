--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local rng = require("base/rng")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
    id = npcID,
    --Sprite size
    gfxheight = 64,
    gfxwidth = 128,
    --Hitbox size. Bottom-center-bound to sprite size.
    width = 128,
    height = 32,
    --Sprite offset from hitbox for adjusting hitbox anchor on sprite.
    gfxoffsetx = 0,
    gfxoffsety = 0,
    --Frameloop-related
    frames = 10,
    framestyle = 0,
    framespeed = 8, --# frames between frame change
    --Movement speed. Only affects speedX by default.
    speed = 1,
    --Collision-related
    npcblock = false,
    npcblocktop = true, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = true, --Also handles other NPCs walking atop this NPC.

    nohurt=false,
    nogravity = false,
    noblockcollision = false,
    nofireball = false,
    noiceball = false,
    noyoshi= false,
    nowaterphysics = false,
    --Various interactions
    jumphurt = false, --If true, spiny-like
    spinjumpsafe = false, --If true, prevents player hurt when spinjumping
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
        --HARM_TYPE_JUMP,
        --HARM_TYPE_FROMBELOW,
        HARM_TYPE_NPC,
        --HARM_TYPE_PROJECTILE_USED,
        --HARM_TYPE_LAVA,
        --HARM_TYPE_HELD,
        --HARM_TYPE_TAIL,
        --HARM_TYPE_SPINJUMP,
        --HARM_TYPE_OFFSCREEN,
        --HARM_TYPE_SWORD
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
    registerEvent(sampleNPC, "onNPCKill")
    registerEvent(sampleNPC, "onNPCHarm")
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
        
        data.still = true
        data.jumping = false
        
        data.haltjump = false
        data.tonguelick = false
        data.hurtstate = false
        data.hurtstate2 = false
        
        v.ai1 = 0 --Jump timer
        v.ai2 = 0 --Timer till the tongue thing
        v.ai3 = 0 --AI to know when to start the tongue animation
        v.ai4 = 0 --For when you hurt Croako
        
        data.hp = 5
    end

    --Depending on the NPC, these checks must be handled differently
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        --Handling
    end
    
    if data.initialized then
        v.ai1 = v.ai1 - 1
        v.ai2 = v.ai2 + 1
    end
    
    if data.still then
        if v.direction == -1 then
            v.animationFrame = 0
        elseif v.direction == 1 then
            v.animationFrame = 5
        end
        v.speedX = 0
        v.speedY = 6
    end
    
    if v.ai1 <= -10 and not data.haltjump and not data.hurtstate2 then
        data.jumping = true
        data.still = false
    end
    if v.ai1 == -11 and not data.haltjump and not data.hurtstate2 then
        SFX.play(24)
    end
    if v.ai1 <= -35 and not data.haltjump and not data.hurtstate2 then
        data.jumping = false
        data.still = true
        v.ai1 = 105
    end
    if data.jumping then
        if v.direction == -1 then
            v.animationFrame = 1
            v.speedX = -1.8
            v.speedY = -7
        elseif v.direction == 1 then
            v.animationFrame = 6
            v.speedX = 1.8
            v.speedY = -7
        end
    end
    if data.haltjump == true then
        v.ai3 = v.ai3 - 1
    end
    if v.ai2 == 100 then
        v.direction = 1
    end
    if v.ai2 == 200 then
        v.direction = -1
    end
    if v.ai2 == 300 then
        v.direction = 1
    end
    if v.ai2 == 400 then
        v.direction = -1
    end
    if v.ai2 == 500 then
        data.haltjump = true
    end
    if v.ai3 <= -25 then
        data.tonguelick = true
    end
    if v.ai3 == -26 then
        SFX.play(50)
    end
    if data.tonguelick and not data.hurtstate2 then
        if v.direction == -1 then
            v.animationFrame = 2
        elseif v.direction == 1 then
            v.animationFrame = 7
        end
        v.speedX = 0
        v.speedY = 6
    end
    if v.ai3 <= -60 then
        v.animationFrame = 0
        data.tonguelick = false
    end
    if v.ai3 <= -100 then
        data.haltjump = false
        v.ai1 = 0
        v.ai2 = 0
        v.ai3 = 0
    end
    if data.hurtstate2 then
        v.ai1 = 0
        v.ai2 = 0
        v.ai3 = 0
        v.speedX = 0
        v.speedY = 6
        data.haltjump = true
        data.jumping = false
        v.ai4 = v.ai4 - 1
        if v.direction == -1 then
            v.animationFrame = 4
        elseif v.direction == 1 then
            v.animationFrame = 9
        end
    end
    if v.ai4 <= -120 then
        data.hurtstate2 = false
        data.haltjump = false
        v.ai1 = 0
        v.ai2 = 0
        v.ai3 = 0
        v.ai4 = 0
        v.ai2 = v.ai2 + 1
    end
    if data.hp <= 0 then
        v:kill(HARM_TYPE_OFFSCREEN)
        local e =  Effect.spawn(779, v.x + 15, v.y + 85)
        SFX.play(63)
    end
end

function sampleNPC.onNPCHarm(eventObj, v, killReason, culprit)
    if npcID ~= v.id or v.isGenerator then return end
    local data = v.data
    
    if not data.hurtstate2 then
        if killReason == HARM_TYPE_NPC then
            eventObj.cancelled = true
            SFX.play(smasExtraSounds.sounds[39].sfx)
            data.hp = data.hp - 1
            data.hurtstate = true
            data.hurtstate2 = true
        elseif killReason == HARM_TYPE_SWORD then
            eventObj.cancelled = true
            SFX.play(smasExtraSounds.sounds[39].sfx)
            data.hp = data.hp - 2
            data.hurtstate = true
            data.hurtstate2 = true
        end
    end
    if data.hurtstate2 then
        eventObj.cancelled = true
    end
end

--Gotta return the library table!
return sampleNPC