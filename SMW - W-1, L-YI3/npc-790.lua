--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")

--Create the library table
local CheckboardGrey = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local CheckboardGreySettings = {
    id = npcID,
    --Sprite size
    gfxheight = 22,
    gfxwidth = 160,
    --Hitbox size. Bottom-center-bound to sprite size.
    width = 160,
    height = 22,
    --Sprite offset from hitbox for adjusting hitbox anchor on sprite.
    gfxoffsetx = 0,
    gfxoffsety = 0,
    --Frameloop-related
    frames = 1,
    framestyle = 0,
    framespeed = 8, --# frames between frame change
    --Movement speed. Only affects speedX by default.
    speed = 1,
    --Collision-related
    npcblock = false,
    npcblocktop = true, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = true, --Also handles other NPCs walking atop this NPC.

    nohurt=true,
    nogravity = true,
    noblockcollision = true,
    nofireball = false,
    noiceball = true,
    noyoshi= true,
    nowaterphysics = true,
    --Various interactions
    jumphurt = false, --If true, spiny-like
    spinjumpsafe = false, --If true, prevents player hurt when spinjumping
    harmlessgrab = true, --Held NPC hurts other NPCs if false
    harmlessthrown = true, --Thrown NPC hurts other NPCs if false

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
npcManager.setNpcSettings(CheckboardGreySettings)

--Registers the category of the NPC. Options include HITTABLE, UNHITTABLE, POWERUP, COLLECTIBLE, SHELL. For more options, check expandedDefines.lua
npcManager.registerDefines(npcID, {NPC.UNHITTABLE})


function CheckboardGrey.onInitAPI()
    npcManager.registerEvent(npcID, CheckboardGrey, "onTickNPC")
    --npcManager.registerEvent(npcID, CheckboardGrey, "onTickEndNPC")
    --npcManager.registerEvent(npcID, CheckboardGrey, "onDrawNPC")
    --registerEvent(CheckboardGrey, "onNPCKill")
end

function CheckboardGrey.onTickNPC(v)
    --Don't act during time freeze
    if Defines.levelFreeze then return end
    
    local data = v.data
    --If despawned
    if v:mem(0x12A, FIELD_WORD) <= 0 then
        data.movespeed = 0
        return
    end

    if data.movespeed == nil then
        data.movespeed = 0
        data._settings.direction = data._settings.direction or 0
    end
    data.movespeed = data.movespeed + 1/65
    --Depending on the NPC, these checks must be handled differently
    if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
    or v:mem(0x136, FIELD_BOOL)        --Thrown
    or v:mem(0x138, FIELD_WORD) > 0    --Contained within
    then
        --Handling
    end
    if data._settings.direction == 0 then
        v.speedX = math.sin(-1*data.movespeed)*NPC.config[npcID].speed*1.125
    elseif data._settings.direction == 1 then
        v.speedY = math.sin(-1*data.movespeed)*NPC.config[npcID].speed*1.375
    end
end

return CheckboardGrey