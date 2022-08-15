--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local bridge = require("bridge")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
    id = npcID,
    --Sprite size
    gfxwidth = 32,
    gfxheight = 112,
    --Hitbox size. Bottom-center-bound to sprite size.
    width = 32,
    height = 32,
    --Sprite offset from hitbox for adjusting hitbox anchor on sprite.
    gfxoffsetx = 0,
    gfxoffsety = 80,
    --Frameloop-related
    frames = 15,
    framestyle = 1,
    framespeed = 3, --# frames between frame change
    --Movement speed. Only affects speedX by default.
    speed = 1,
    --Collision-related
    npcblock = true,
    npcblocktop = true, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = true,
    playerblocktop = true, --Also handles other NPCs walking atop this NPC.
    staticdirection = true,

    nohurt=true,
    nogravity = true,
    noblockcollision = true,
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
        --HARM_TYPE_NPC,
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
    npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
    --npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
    --npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
    --registerEvent(sampleNPC, "onNPCKill")
end

function sampleNPC.onDrawNPC(v)
    --Don't act during time freeze
    if Defines.levelFreeze then return end
    if mem(0x00B2B9E4, FIELD_BOOL) == true then return end
    
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
        v.ai1 = 0
        local directionalAnimation = 0
    end

    --Depending on the NPC, these checks must be handled differently
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        --Handling
    end
    
    --Execute main AI. This template just jumps when it touches the ground.
    if v.direction == -1 then
        directionalAnimation = 0
    else
        directionalAnimation = sampleNPCSettings.frames
    end
    
    if v.ai1 == 0 then
        v.animationTimer = 1
        v.animationFrame = 0 + directionalAnimation
        if Colliders.collide(bridge.collapseBox, v) then
            v.animationFrame = 1 + directionalAnimation
            v.ai1 = 1
        end
    elseif v.animationFrame == 14 + directionalAnimation then
        v:kill(HARM_TYPE_OFFSCREEN)
    elseif v.ai1 == 1 then
        v.animationTimer = v.animationTimer + 1
        if v.animationTimer == sampleNPCSettings.framespeed then
            v.animationFrame = v.animationFrame + 1
            v.animationTimer = 0
        end
    end
end

--Gotta return the library table!
return sampleNPC