--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")

--Create the library table
local boomBoom = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local boomBoomSettings = {
	id = npcID,
	--Sprite size
    gfxwidth = 68,
	gfxheight = 54,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 68,
	height = 54,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 0,
	--Frameloop-related
	frames = 17,
	framestyle = 0,
	framespeed = 12, --# frames between frame change
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
npcManager.setNpcSettings(boomBoomSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_JUMP,
		--HARM_TYPE_FROMBELOW,
		HARM_TYPE_NPC,
		--HARM_TYPE_PROJECTILE_USED,
		--HARM_TYPE_LAVA,
		--HARM_TYPE_HELD,
		--HARM_TYPE_TAIL,
		HARM_TYPE_SPINJUMP,
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
boomBoom.walkingFrames = {1,2,3,4,3,2}
boomBoom.hurtFrames = {7,8}
boomBoom.flyingFrames = {9,10,11,12,13,14}
boomBoom.hurtFlightFrames = {15,16}

--Register events
function boomBoom.onInitAPI()
    --npcManager.registerEvent(npcID, boomBoom, "onStartNPC")
	npcManager.registerEvent(npcID, boomBoom, "onTickNPC")
	npcManager.registerEvent(npcID, boomBoom, "onTickEndNPC")
	--npcManager.registerEvent(npcID, boomBoom, "onDrawNPC")
	registerEvent(boomBoom, "onNPCHarm")
end

function boomBoom.onNPCHarm(eventToken, v, killReason, culprit)
    local data = v.data
    if v.id == npcID and killReason == HARM_TYPE_JUMP or killReason == HARM_TYPE_SPINJUMP then
        if data.bossHP > 0 then
            if data._settings.canFly then
                if not data.flightEnabled then
                    data.flightEnabled = true
                end
            end
            if data.bossStage == 1 or data.bossStage == 6 or data.bossStage == 7 then
                eventToken.cancelled = true
                data.bossHP = data.bossHP - 3
                SFX.play(39)
                data.ai1 = 0
                data.boomBoomWalk = false
                data.slowBegin = true
                data.bossStage = 2
            elseif data.bossStage == 2 or data.bossStage == 5 then
                eventToken.cancelled = true
            elseif data.bossStage == 0 or data.bossStage == 3 then
                eventToken.cancelled = true
                culprit:harm()
            end
        end
    end
    if v.id == npcID and killReason == HARM_TYPE_NPC then
        eventToken.cancelled = true
        SFX.play(9)
        data.bossHP = data.bossHP - 1
    end
end

function boomBoom.onTickEndNPC(v)
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
        data.bossStage = 0 --Boss stage, used for which stage Boom Boom is in
        data.bossHP = data._settings.HPAmount * 3 --The amount of HP Boom Boom has.
        data.bossPopOut = false --Whenever Boom Boom pops out to move again.
        data.ai1 = 0 --Boss timer 1, used for most things
        data.ai2 = 0 --Boss timer 2, used for jumping
        data.boomBoomWalk = false --Used to enable walking
        data.slowBegin = true --Used to detect whenever to use a slow beginning walk
        data.animationFramed = 1 --Animation frame counter
        data.flightEnabled = false --Used to indicate flight
        data.animationArray = 0
        data.timer = 0
		data.initialized = true
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
    
	if data.bossStage == 0 then --Stage 0: Beginning
        v.speedY = 4
        data.ai1 = data.ai1 + 1
        v.animationFrame = 6
        if data.ai1 >= 35 then
            data.ai1 = 0
            data.bossStage = 1
        end
    end
    if data.bossStage == 1 then --Stage 1: Walking
        data.ai1 = data.ai1 + 1
        if data.ai1 == 1 then
            data.bossPopOut = true
        end
        if data.slowBegin then
            if data.ai1 > 1 and data.ai1 < 40 then
                v.speedX = 2 * v.direction
            end
        else
            if data.ai1 > 1 and data.ai1 < 40 then
                v.speedX = 4 * v.direction
            end
        end
        if data._settings.canFly then
            if data.ai1 > 41 and data.ai1 < 325 then
                v.speedX = 4 * v.direction
            end
            if data.ai1 == 326 then
                v.speedX = 0
                data.ai1 = 0
                data.bossStage = 3
            end
        else
            if data.ai1 > 41 and data.ai1 < 525 then
                v.speedX = 4 * v.direction
            end
            if data.ai1 == 526 then
                v.speedX = 0
                data.ai1 = 0
                data.bossStage = 4
            end
        end
        if not data.flightEnabled then
            v.animationFrame = boomBoom.walkingFrames[data.animationFramed]
        else
            v.animationFrame = boomBoom.flyingFrames[data.animationFramed]
        end
    end
    if data.bossStage == 2 then --Stage 2: Hurting
        v.speedY = -0.25
        data.ai1 = data.ai1 + 1
        v.speedX = 0
        if data.ai1 > 45 then
            data.bossStage = 3
        end
        v:mem(0x12E,FIELD_WORD,75) --Can't hurt timer
        data.timer = data.timer + 1 --Rework the animation here, since we're making sure the hurt state is faster than the walk
        data.animationArray = data.timer % 4
        if data.animationArray >= 3 then
            data.animationFramed = data.animationFramed + 1
        end
        if data.animationFramed > 2 then
            data.animationFramed = 1
        end
        if not data.flightEnabled then
            v.animationFrame = boomBoom.hurtFrames[data.animationFramed]
        else
            v.animationFrame = boomBoom.hurtFlightFrames[data.animationFramed]
        end
    end
    if data.bossStage == 3 then --Stage 3: Spiking
        v.speedY = 6
        data.ai1 = data.ai1 + 1
        v.animationFrame = 6
        if data.ai1 >= 75 then
            data.ai1 = 0
            if not data.flightEnabled then
                data.bossStage = 1
            else
                data.bossStage = 5
            end
        end
    end
    if data.bossStage == 4 then --Stage 4: Jumping
        data.ai1 = data.ai1 + 1
        v.animationFrame = 0
        if data.ai1 >= 55 then
            data.ai1 = 0
            data.bossJumpHigh = true
            data.bossStage = 1
        end
    end
    if data.bossStage == 5 then --Stage 5: Begin Flying
        data.ai1 = data.ai1 + 1
        if data.ai1 > 0 and data.ai1 < 18 then
            v.speedY = -10.5
            v.speedX = 2 * v.direction
        end
        if data.ai1 >= 19 then
            data.ai1 = 0
            data.boomBoomWalk = true
            data.bossStage = 6
        end
    end
    if data.bossStage == 6 then --Stage 6: Flying
        data.ai1 = data.ai1 + 1
        v.speedY = -0.3
        v.speedX = 5 * v.direction
        if data.ai1 > 360 then
            data.ai1 = 0
            data.bossStage = 7
        end
        v.animationFrame = boomBoom.flyingFrames[data.animationFramed]
    end
    if data.bossStage == 7 then --Stage 7: Gliding
        data.ai1 = data.ai1 + 1
        if data.ai1 > 0 and data.ai1 < 45 then
            v.speedY = -0.3
            v.speedX = 0
        end
        if data.ai1 > 46 and data.ai1 < 68 then
            v.speedY = 8.3
            v.speedX = 3 * v.direction
        end
        if data.ai1 > 68 and data.ai1 < 89 then
            v.speedY = -8.3
            v.speedX = 3 * v.direction
        end
        if data.ai1 > 89 and data.ai1 < 100 then
            v.speedY = -0.3
            v.speedX = 0
        end
        if data.ai1 > 100 then
            data.bossStage = 6
        end
        v.animationFrame = boomBoom.flyingFrames[data.animationFramed]
    end
    if data.boomBoomWalk then --If walking is enabled, animation for walking will occur...
        data.timer = data.timer + 1
        data.animationArray = data.timer % 4
        if data.animationArray >= 3 then
            data.animationFramed = data.animationFramed + 1
        end
        if data.animationFramed > 6 then
            data.animationFramed = 1
        end
    end
    if data.bossPopOut then --Popping out from a spiked state.
        v.animationFrame = 5
        v.speedY = -3
        data.boomBoomWalk = true
        data.bossPopOut = false
    end
    if data.bossJumpHigh then --Jumping when standing still.
        data.ai2 = data.ai2 + 1
        if data.ai2 == 1 then
            data.slowBegin = false
        end
        if data.ai2 > 0 and data.ai2 < 8 then
            v.speedY = -8
        end
        if data.ai2 >= 9 then
            data.ai2 = 0
            data.bossJumpHigh = false
        end
    end
    if data.bossHP <= 0 then --This is when the boss is set to die.
		v:kill(HARM_TYPE_OFFSCREEN)
		local e = Effect.spawn(14, v.x + 25, v.y)
        if v.legacyBoss and not data._settings.orbExitActivator then
			local ball = NPC.spawn(16, v.x, v.y, v.section)
			ball.x = ball.x + ((v.width - ball.width) / 2)
			ball.y = ball.y + ((v.height - ball.height) / 2)
			ball.speedY = -6
			ball.despawnTimer = 100
			SFX.play(20)
		elseif data._settings.orbExitActivator then
            local ball = NPC.spawn(16, v.x, v.y, v.section)
			ball.x = ball.x + ((v.width - ball.width) / 2)
			ball.y = ball.y + ((v.height - ball.height) / 2)
			ball.speedY = -6
			ball.despawnTimer = 100
			SFX.play(20)
        end
	end
end

--Gotta return the library table!
return boomBoom