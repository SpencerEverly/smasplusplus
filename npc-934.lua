--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local smasFunctions = require("smasFunctions")
local smasExtraSounds = require("smasExtraSounds")

--Create the library table
local wart = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local wartSettings = {
	id = npcID,
	--Sprite size
    gfxwidth = 80,
	gfxheight = 94,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 80,
	height = 94,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 0,
	--Frameloop-related
	frames = 8,
	framestyle = 1,
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
	nowaterphysics = true,
	--Various interactions
	jumphurt = true, --If true, spiny-like
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
npcManager.setNpcSettings(wartSettings)

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
		--[HARM_TYPE_NPC]=106,
		--[HARM_TYPE_PROJECTILE_USED]=106,
		--[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		--[HARM_TYPE_HELD]=10,
		--[HARM_TYPE_TAIL]=10,
		--[HARM_TYPE_SPINJUMP]=10,
		--[HARM_TYPE_OFFSCREEN]=10,
		--[HARM_TYPE_SWORD]=106,
	}
);

--Custom local definitions below


--Register events
function wart.onInitAPI()
    npcManager.registerEvent(npcID, wart, "onTickEndNPC")
    --npcManager.registerEvent(npcID, wart, "onDrawNPC")
    registerEvent(wart, "onNPCHarm")
    registerEvent(wart, "onNPCKill")
end

function wart.onNPCKill(eventObj, npc)
    if npc.id ~= npcID then
        return
    elseif npc.id == npcID then
        local data = npc.data
        if data.isVulnerable and not data.hurt then
            if data.health > 0 then
                NPC.config[npcID].score = 0
                eventObj.cancelled = true
            end
        elseif (data.hurt or not data.isVulnerable) then
            eventObj.cancelled = true
        else
            Sound.playSFX(63)
            Effect.spawn(106, v.x, v.y, 1)
        end
    end
end

function wart.onNPCHarm(eventObj, npc, killType, culprit)
    if npc.id ~= npcID then
        return
    elseif npc.id == npcID then
        local data = npc.data
        if data.health > 0 then
            if data.isVulnerable and not data.hurt then
                if killType == HARM_TYPE_NPC then
                    eventObj.cancelled = true
                    data.health = data.health - 6
                    Sound.playSFX(39)
                    data.isVulnerable = false
                    data.timer = 0
                    data.hurt = true
                end
            elseif killType == HARM_TYPE_NPC and data.hurt then
                eventObj.cancelled = true
            end
        end
    end
end

function wart.doWalkingAnimation(v)
    local data = v.data
    data.animationTimer = data.animationTimer + 1
    v.animationFrame = math.floor(data.animationTimer / 8) % 2 + 0 --v.animationFrame = math.floor(data.animationTimer/framespeed) % frames + offset
    if data.animationTimer >= 16 then
        data.animationTimer = 0
    end
end

function wart.doHurtAnimation(v)
    local data = v.data
    data.animationTimer = data.animationTimer + 1
    v.animationFrame = math.floor(data.animationTimer / 4) % 4 + 4 --v.animationFrame = math.floor(data.animationTimer/framespeed) % frames + offset
    if data.animationTimer > 16 then
        data.animationTimer = 0
    end
end

function wart.onTickEndNPC(v)
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
        data.timer = 0
        data.animationTimer = 0
        data.ballThrowupTimer = 0
        
        data.stage = 1
        data.ballThrowupDistance = -10
        data.isVulnerable = false
        
        data.hurt = false
        
        data.health = 24
        
		data.initialized = true
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	
	--Execute main AI.
    if not data.hurt then
        if data.stage == 1 then
            data.timer = data.timer + 1
            wart.doWalkingAnimation(v)
            if data.timer >= 1 and data.timer <= lunatime.toTicks(2.5) then
                v.speedX = -1
            end
            if data.timer >= lunatime.toTicks(2.5) and data.timer <= lunatime.toTicks(3.5) then
                v.speedX = 0
            end
            if data.timer >= lunatime.toTicks(3.5) and data.timer <= lunatime.toTicks(6) then
                v.speedX = 1
            end
            if data.timer >= lunatime.toTicks(6) then
                v.speedX = 0
                data.timer = 0
                data.stage = 2
            end
        end
        if data.stage == 2 then
            data.isVulnerable = true
            data.timer = data.timer + 1
            if data.timer >= 0 then
                v.animationFrame = 2
            end
            if data.timer == lunatime.toTicks(0.5) then
                Sound.playSFX(115)
            end
            if data.timer >= lunatime.toTicks(0.5) and data.timer <= lunatime.toTicks(2) then
                data.ballThrowupTimer = data.ballThrowupTimer + 1
                if data.ballThrowupDistance < 0 then
                    data.ballThrowupDistance = data.ballThrowupDistance + 0.1
                end
                if data.ballThrowupTimer == lunatime.toTicks(0.1) or data.ballThrowupTimer == lunatime.toTicks(0.4) or data.ballThrowupTimer == lunatime.toTicks(0.8) or data.ballThrowupTimer == lunatime.toTicks(1.2) or data.ballThrowupTimer == lunatime.toTicks(1.6) then  
                    local ball = NPC.spawn(935, v.x, v.y + 10, v.section, false, true)
                    ball.speedX = data.ballThrowupDistance
                    ball.speedY = -1
                end
            end
            if data.timer >= lunatime.toTicks(2) then
                data.timer = 0
                data.isVulnerable = false
                data.ballThrowupDistance = -10
                data.ballThrowupTimer = 0
                data.stage = 1
            end
        end
    elseif data.hurt then
        data.ballThrowupDistance = -10
        data.ballThrowupTimer = 0
        wart.doHurtAnimation(v)
        v.speedX = 0
        data.timer = data.timer + 1
        if data.timer >= lunatime.toTicks(2) then
            data.hurt = false
            data.timer = 0
            data.stage = 1
        end
    end
end

--Gotta return the library table!
return wart