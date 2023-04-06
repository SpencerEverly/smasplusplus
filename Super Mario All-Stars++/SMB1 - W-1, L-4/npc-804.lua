--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local bridge = require("bridge")
local extrasounds = require("extrasounds")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
    id = npcID,
    --Sprite size
    gfxwidth = 32,
    gfxheight = 32,
    --Hitbox size. Bottom-center-bound to sprite size.
    width = 32,
    height = 32,
    --Sprite offset from hitbox for adjusting hitbox anchor on sprite.
    gfxoffsetx = 0,
    gfxoffsety = 0,
    --Frameloop-related
    frames = 3,
    framestyle = 0,
    framespeed = 8, --# frames between frame change
    --Movement speed. Only affects speedX by default.
    speed = 1,
    --Collision-related
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.

    nohurt=true,
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
local cameralock = nil
local direction = 0
local bridgecollapse = extrasounds.sounds[153].sfx

--Register events
function sampleNPC.onInitAPI()
    npcManager.registerEvent(npcID, sampleNPC, "onTickNPC")
    --npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
    --npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
    --registerEvent(sampleNPC, "onNPCKill")
    registerEvent(sampleNPC, "onCameraUpdate")
end

function sampleNPC.onTickNPC(v)
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
        cameralock = v.x + 96
        direction = v.direction
    end

    --Depending on the NPC, these checks must be handled differently
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        --Handling
    end
    
    --Execute main AI. This template just jumps when it touches the ground.
    v.friendly = true
    
    for _,p in ipairs(Player.get()) do
        if Colliders.collide(p, v) then
            p.speedX = 0
            p.x = p.x - v.direction
            SFX.play(bridgecollapse)
            bridge.active = true
            bridge.cameraX = camera.x
            bridge.cameraY = camera.y
            bridge.collapseHitboxX = v.x
            bridge.collapseHitboxY = v.y
            bridge.collapseHitboxWidth = 32
            bridge.collapseHitboxHeight = 96
            bridge.collapseHitboxDirection = v.direction
            v:kill(HARM_TYPE_OFFSCREEN)
            cameralock = nil
        end
    end
end

function sampleNPC.onCameraUpdate()
    if cameralock ~= nil then
        if direction == -1 then
            --if camera.x + 800 > cameralock then
            --    camera.x = cameralock - 800
            --end
            --if player.x > camera.x + 775 then
            --    player.x = camera.x + 775
            --end
        elseif direction == 1 then
            --if camera.x < cameralock - 160 then
            --    camera.x = cameralock - 160
            --end
            --if player.x < camera.x then
                --player.x = camera.x
            --end
        end
    end
end

--Gotta return the library table!
return sampleNPC