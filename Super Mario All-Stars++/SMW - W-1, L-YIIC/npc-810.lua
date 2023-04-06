--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local utils = require("npcs/npcutils")
local extrasounds = require("extrasounds")
--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
    id = npcID,
    --Sprite size
    gfxheight = 60,
    gfxwidth = 80,
    --Hitbox size. Bottom-center-bound to sprite size.
    width = 32,
    height = 32,
    --Sprite offset from hitbox for adjusting hitbox anchor on sprite.
    gfxoffsetx = 0,
    gfxoffsety = 0,
    --Frameloop-related
    frames = 18,
    framestyle = 1,
    framespeed = 8, --# frames between frame change
    --Movement speed. Only affects speedX by default.
    speed = 1,
    --Collision-related
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.
    staticdirection = true,
    
    nohurt=false,
    nogravity = false,
    noblockcollision = false,
    nofireball = false,
    noiceball = true,
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
        HARM_TYPE_JUMP,
        --HARM_TYPE_FROMBELOW,
        HARM_TYPE_NPC,
        HARM_TYPE_PROJECTILE_USED,
        HARM_TYPE_LAVA,
        --HARM_TYPE_HELD,
        --HARM_TYPE_TAIL,
        HARM_TYPE_SPINJUMP,
        --HARM_TYPE_OFFSCREEN,
        --HARM_TYPE_SWORD
    }, 
    {
        [HARM_TYPE_JUMP]=10,
        --[HARM_TYPE_FROMBELOW]=10,
        --[HARM_TYPE_NPC]=10,
        --[HARM_TYPE_PROJECTILE_USED]=10,
        [HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
        --[HARM_TYPE_HELD]=10,
        --[HARM_TYPE_TAIL]=10,
        [HARM_TYPE_SPINJUMP]=10,
        --[HARM_TYPE_OFFSCREEN]=10,
        --[HARM_TYPE_SWORD]=10,
    }
);

--Custom local definitions below


--Register events
function sampleNPC.onInitAPI()
    npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
    --npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
    npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
    registerEvent(sampleNPC, "onNPCHarm", "onNPCHarm", false)
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
        v.ai1 = 0 --Current state
        v.ai2 = 0 --Firing timer
        v.ai3 = 0 --Turning timer
        local directionalAnimation = 0
        v.npcNotSpawned = true
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
    
    if v.ai3 ~= 0 then
        v.ai3 = v.ai3 - 1
    end
    
    if v.ai1 < 3 then
        v.ai2 = v.ai2 + 1
    end
    
    if v.ai1 == 0 then
        v.speedX = 1 * v.direction
        v.animationTimer = v.animationTimer + 3
        if v.ai3 == 0 then
            if (player.x > v.x and v.direction == -1) or (player.x < v.x and v.direction == 1) then
                v.ai1 = 1
                v.ai3 = 60
            elseif v.collidesBlockLeft or v.collidesBlockRight then
                v.ai1 = 1
                v.ai3 = 60
            end
        end
        
        if v.ai2 == 150 then
            v.ai2 = 0
            v.ai1 = 2
            v.animationFrame = 5 + directionalAnimation
        end
    elseif v.ai1 == 1 then
        v.speedX = 0
        if v.ai3 == 50 then
            v.direction = v.direction * -1
        elseif v.ai3 == 40 then
            v.ai1 = 0
            v.ai2 = 0
        end
    elseif v.ai1 == 2 then
        v.speedX = 0
        if v.animationFrame < 6 + directionalAnimation then
            v.animationTimer = v.animationTimer - .7
        else
            v.animationTimer = v.animationTimer - .5
        end
        
        if v.animationFrame == 11 + directionalAnimation then
            if v.npcNotSpawned == true then
                SFX.play(38)
                if v.direction == -1 then
                    fireball = NPC.spawn(811, v.x - 12, v.y - v.height + 2)
                else
                    fireball = NPC.spawn(811, v.x + v.width + 12, v.y - v.height + 2)
                end
                fireball.direction = v.direction
                fireball.speedX = 2.5 * fireball.direction
                v.npcNotSpawned = false
            end
        elseif v.animationFrame == 12 + directionalAnimation then
            v.npcNotSpawned = true
            v.ai1 = 0
            v.ai2 = 0
        end
    else
        for s,slope in ipairs(Block.getIntersecting(v.x, v.y + v.height, v.x + v.width, v.y + v.height + 2)) do
            if v.collidesBlockBottom and not slope.isHidden then
                if Block.SLOPE_LR_FLOOR_MAP[slope.id] then 
                    v.speedX = -4
                elseif Block.SLOPE_RL_FLOOR_MAP[slope.id] then
                    v.speedX = 4
                else
                    v.speedX = -4 * v.direction
                end
            else
                v.speedX = -4 * v.direction
            end
        end
        
        if v.ai3 <= 20 and v.ai3 >= 6 then
            v.ai1 = 3
        elseif v.ai3 == 0 then
            v.ai1 = 0
        else
            v.ai1 = 4
        end
    end
end

function sampleNPC.onNPCHarm(eventObj, v, killReason, culprit)
    if npcID ~= v.id or v.isGenerator then return end

    if killReason ~= HARM_TYPE_LAVA then
        eventObj.cancelled = true
        v.ai1 = 4
        v.ai3 = 25
        if killReason == HARM_TYPE_JUMP or killReason == HARM_TYPE_SPINJUMP then
            SFX.play(2)
        end
        SFX.play(extrasounds.sounds[39].sfx)
    end
    if killReason == HARM_TYPE_LAVA then
        SFX.play(extrasounds.sounds[128].sfx)
    end
end

function sampleNPC.onDrawNPC(v)
    run = utils.getFrameByFramestyle(v, {
        frames = 4,
        gap = 14,
        offset = 0
    })
    turn = utils.getFrameByFramestyle(v, {
        frames = 1,
        gap = 13,
        offset = 4
    })
    hurt = utils.getFrameByFramestyle(v, {
        frames = 1,
        gap = 4,
        offset = 13
    })
    shell = utils.getFrameByFramestyle(v, {
        frames = 4,
        gap = 0,
        offset = 14
    })
    
    if v.ai1 == 0 then
        v.animationFrame = run
        utils.restoreAnimation(v)
    elseif v.ai1 == 1 then
        v.animationFrame = turn
        utils.restoreAnimation(v)
    elseif v.ai1 == 2 then
        return
    elseif v.ai1 == 3 then
        v.animationFrame = shell
        utils.restoreAnimation(v)
    else
        v.animationFrame = hurt
        utils.restoreAnimation(v)
    end
end

--Gotta return the library table!
return sampleNPC