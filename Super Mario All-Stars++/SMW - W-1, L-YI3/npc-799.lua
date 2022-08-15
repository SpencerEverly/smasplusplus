--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
    id = npcID,
    --Sprite size
    gfxheight = 32,
    gfxwidth = 32,
    --Hitbox size. Bottom-center-bound to sprite size.
    width = 32,
    height = 32,
    --Sprite offset from hitbox for adjusting hitbox anchor on sprite.
    gfxoffsetx = 0,
    gfxoffsety = 0,
    --Frameloop-related
    frames = 1,
    framestyle = 0,
    framespeed = 0, --# frames between frame change
    --Movement speed. Only affects speedX by default.
    speed = 1,
    --Collision-related
    npcblock = true,
    npcblocktop = true, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = true,
    playerblocktop = true, --Also handles other NPCs walking atop this NPC.

    nohurt=true,
    nogravity = true,
    noblockcollision = true,
    nofireball = false,
    noiceball = false,
    noyoshi= false,
    nowaterphysics = true,
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
    npcManager.registerEvent(npcID, sampleNPC, "onTickNPC")
    --npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
    --npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
    --registerEvent(sampleNPC, "onNPCKill")
end

function sampleNPC.onTickNPC(v)
    --Don't act during time freeze
    if Defines.levelFreeze then return end
    
    local data = v.data
    
    --If despawned
    if v:mem(0x12A, FIELD_WORD) <= 0 then
        --Reset our properties, if necessary
        data.initialized = false
        return
    end

    --Initialize
    if not data.initialized then
        --Initialize necessary data.
        data.initialized = true
        v.altframe = false
        v.Xspeed = 0
        v.Yspeed = 0
        v.timer = 0
        v.alternating = false
        v.upleft = false
    end

    --Depending on the NPC, these checks must be handled differently
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        --Handling
    end
    v.Xspeed = data._settings.Xspeed
    --Execute main AI. This template just jumps when it touches the ground.
    v.timer = v.timer + 1
    
    if data._settings.movedir == 1 then
        v.upleft = true
    end
    
    if v.timer == 60 then
        if v.upleft == true then
            v.speedY = v.Xspeed * v.direction
        else
            v.speedX = v.Xspeed * v.direction
        end
    elseif v.timer == 92 then
        if v.upleft == true then
            v.speedY = 0
        else
            v.speedX = 0
        end
    elseif v.timer == 152 then
        if v.upleft == true then
            v.speedY = v.Xspeed * v.direction * -1
        else
            v.speedX = v.Xspeed * v.direction * -1
        end
    elseif v.timer == 184 then
        if v.upleft == true then
            v.speedY = 0
        else
            v.speedX = 0
        end
    elseif v.timer == 234 then
        v.timer = 49
        if v.direction == 1 then
            v.direction = -1
        else
            v.direction = 1
        end
        
        if data._settings.movedir == 2 and v.upleft == false then
            v.upleft = true
        elseif data._settings.movedir == 2 then
            v.upleft = false
        end
    end
end

--Gotta return the library table!
return sampleNPC