--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local inspect = require("ext/inspect")
local extrasounds
pcall(function() extrasounds = require("extrasounds") end)

--Create the library table
local SMB3BowserNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local SMB3BowserNPCSettings = {
	id = npcID,
	--Sprite size
	gfxheight = 80,
	gfxwidth = 64,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 80,
	height = 62,
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
npcManager.setNpcSettings(SMB3BowserNPCSettings)

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
		HARM_TYPE_OFFSCREEN,
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
function SMB3BowserNPC.onInitAPI()
	npcManager.registerEvent(npcID, SMB3BowserNPC, "onTickEndNPC")
	--npcManager.registerEvent(npcID, SMB3BowserNPC, "onTickEndNPC")
	--npcManager.registerEvent(npcID, SMB3BowserNPC, "onDrawNPC")
	registerEvent(SMB3BowserNPC, "onNPCKill")
end

function bowserKilled(npc, harmType)
    SFX.play(44)
    Routine.wait(4, false)
    SFX.play(37)
    Defines.earthquake = 6
end

function SMB3BowserNPC.onNPCKill(eventToken, npc, harmType)
    if npc.id ~= npcID then return end
    if npc.id == NPC_ID then
        local data = npc.data
        if harmType == HARM_TYPE_OFFSCREEN and not data.dead then
            Routine.run(bowserKilled, npc, harmType)
            data.dead = true
        end
    end
end

local followSpeed = 8 -- OUTSIDE of any functions
local nearPlayer

SMB3BowserNPC.lookAroundFrames = {4,3,12,9,8,9,12,3}

function fireballAI(v)
    SFX.play("sound/bowser-fire.ogg")
    if v.direction == -1 then
        local fire = NPC.spawn(87, v.x, v.y)
        fire.speedX = -1.5
        fire.speedY = 1.5
        Routine.waitFrames(45, false)
        fire.speedY = 0
    else
        local fire = NPC.spawn(87, v.x + 16, v.y)
        fire.speedX = 1.5
        fire.speedY = 1.5
        Routine.waitFrames(45, false)
        fire.speedY = 0
    end
end

function SMB3BowserNPC.onTickEndNPC(v)
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
        data.startBattle = false --Start battle indicator
        data.bossStage = 0 --Boss stage indicator
        data.ai1 = 0 --Time while jumping on the ground
        data.ai2 = 0 --Timer for smashing on the ground
        data.dontJump = false
        data.fireCount = 2 --Set to fire fireballs 2-3 times per spit
        data.hitBlocks = false --Making sure get get only one frame of hitting Bowser bricks
        data.animationFramed = 1
        data.animationArray = 0
        data.dead = false
        data.timer = 0
        
        nearPlayer = Player.getNearest(v.x, v.y)

        data.adjacent = (nearPlayer.x + (nearPlayer.width / 2)) - (v.x + 0.5 * v.height)
        data.opposite = (nearPlayer.y + (nearPlayer.height / 2)) - (v.y + 0.5 * v.width)
        data.radian     = math.atan2(data.opposite, data.adjacent)
        data.finalAngle = math.floor(math.deg(data.radian) + 0.5) + 180
        data.direction = -vector.right2:rotate(data.finalAngle)

        data.forceX = data.direction.x * followSpeed
        data.forceY = data.direction.y * followSpeed
        
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
    if not data.startBattle then
        if v.collidesBlockBottom then
            data.bossStage = 1
            data.startBattle = true
        end
    end
    if data.startBattle then
        --[[Text.print(data.bossStage, 100, 100)
        Text.print(data.ai1, 100, 120)
        Text.print(data.ai2, 100, 140)]]
        if not data.dead then
            
            
            if not data.dontJump then --To make sure Bowser doesn't jump when active
                data.ai1 = data.ai1 + 1
                if data.ai1 > 20 and data.ai1 < 45 then
                    v.speedY = -1.2
                end
                if data.ai1 > 45 and data.ai1 < 70 then
                    v.speedY = 1.2
                end
                if data.ai1 > 75 then
                    data.ai1 = 0
                end
            end
            
            
            
            
            if data.bossStage == 1 then --Stage 1: Jumping
                if data.ai1 > -1 and data.ai1 < 20 then
                    if v.direction == -1 then
                        v.animationFrame = 1
                    else
                        v.animationFrame = 6
                    end
                end
                if data.ai1 > 20 and data.ai1 < 70 then
                    if v.direction == -1 then
                        v.animationFrame = 0
                    else
                        v.animationFrame = 5
                    end
                end
                if data.ai1 > 62 and data.ai1 < 76 then
                    if v.direction == -1 then
                        v.animationFrame = 1
                    else
                        v.animationFrame = 6
                    end
                end
                if data.ai1 >= 75 then
                    data.bossStage = 2
                    data.ai1 = 0
                end
            end
            if data.bossStage == 2 then --Stage 2: Firing
                if data.ai1 > 0 and data.ai1 < 20 then
                    if v.direction == -1 then
                        v.animationFrame = 2
                    else
                        v.animationFrame = 7
                    end
                end
                if data.ai1 > 20 and data.ai1 < 62 then
                    if v.direction == -1 then
                        v.animationFrame = 13
                    else
                        v.animationFrame = 14
                    end
                end
                if data.ai1 == 62 then
                    Routine.run(fireballAI, v)
                end
                if data.ai1 > 62 and data.ai1 <= 75 then
                    if v.direction == -1 then
                        v.animationFrame = 1
                    else
                        v.animationFrame = 6
                    end
                end
                if data.ai1 >= 75 then
                    if v.direction == -1 then
                        v.animationFrame = 1
                    else
                        v.animationFrame = 6
                    end
                    if data.fireCount <= 0 then
                        data.bossStage = 3
                    else
                        data.bossStage = 2
                    end
                    data.fireCount = data.fireCount - 1
                    data.ai1 = 0
                end
            end
            if data.bossStage == 3 then --Stage 3: Jumping before Smashing
                if data.ai1 > -1 and data.ai1 < 20 then
                    if v.direction == -1 then
                        v.animationFrame = 1
                    else
                        v.animationFrame = 6
                    end
                end
                if data.ai1 > 20 and data.ai1 < 70 then
                    if v.direction == -1 then
                        v.animationFrame = 0
                    else
                        v.animationFrame = 5
                    end
                end
                if data.ai1 > 62 and data.ai1 < 76 then
                    if v.direction == -1 then
                        v.animationFrame = 1
                    else
                        v.animationFrame = 6
                    end
                end
                if data.ai1 >= 75 then
                    data.fireCount = 2
                    data.bossStage = 4
                    data.ai1 = 0
                end
            end
            if data.bossStage == 4 then --Stage 4: Smashing
                data.ai2 = data.ai2 + 1
                if data.ai2 == 1 then
                    data.dontJump = true
                    data.ai1 = 0
                end
                if data.ai2 >= 0 and data.ai2 < 35 then
                    if v.direction == -1 then
                        v.animationFrame = 1
                    else
                        v.animationFrame = 6
                    end
                end
                if data.ai2 == 35 then
                    nearPlayer = Player.getNearest(v.x, v.y)
                    
                    if v.direction == -1 then
                        data.adjacent = (nearPlayer.x + (nearPlayer.width / 2)) - (v.x + 0.5 * v.height)
                        data.opposite = (nearPlayer.y + (nearPlayer.height / 2)) - (v.y + 0.5 * v.width) - 200
                        data.radian     = math.atan2(data.opposite, data.adjacent)
                        data.finalAngle = math.floor(math.deg(data.radian) + 0.5) + 180
                        data.direction = -vector.right2:rotate(data.finalAngle)
                        data.forceX = data.direction.x * followSpeed
                    else
                        data.adjacent = (nearPlayer.x + (nearPlayer.width / 2)) - (v.x + 0.5 * v.height)
                        data.opposite = (nearPlayer.y + (nearPlayer.height / 2)) - (v.y + 0.5 * v.width) - 200
                        data.radian     = math.atan2(data.opposite, data.adjacent)
                        data.finalAngle = math.floor(math.deg(data.radian) + 0.5) + 180
                        data.direction = -vector.right2:rotate(data.finalAngle)
                        data.forceX = -data.direction.x * followSpeed
                    end
                    
                    data.forceX = data.direction.x * followSpeed
                    data.forceY = data.direction.y * followSpeed
                end
                
                if data.ai2 > 35 and data.ai2 < 65 then
                    v.speedX = data.forceX
                    v.speedY = data.forceY
                end
                if data.ai2 > 65 and data.ai2 < 100 then
                    v.animationFrame = 10
                    v.speedX = 0
                    v.speedY = -0.25
                end
                if data.ai2 > 100 and not v.collidesBlockBottom then
                    v.animationFrame = 10
                    v.speedY = 8
                end
                if data.ai2 > 100 and v.collidesBlockBottom and not data.hitBlocks then
                    Defines.earthquake = 6
                    SFX.play("sound/explode.ogg")
                    for k,v in ipairs(Block.getIntersecting(v.x, v.y + 8, v.x + v.width, v.y + v.height + 8)) do
                        if v.id == 186 then
                            v:remove(true)
                        end
                    end
                    data.hitBlocks = true
                end
                if data.ai2 > 100 and data.ai2 < 190 and v.collidesBlockBottom and data.hitBlocks then
                    v.animationFrame = 11
                end
                if data.ai2 >= 190 then
                    data.hitBlocks = false
                    data.ai2 = 0
                    data.bossStage = 5
                end
            end
            if data.bossStage == 5 then --Stage 5: Looking around before repeating
                data.ai2 = data.ai2 + 1
                data.timer = data.timer + 1
                data.animationArray = data.timer % 4
                if data.animationArray >= 3 then
                    data.animationFramed = data.animationFramed + 1
                end
                if data.animationFramed > 8 then
                    data.animationFramed = 1
                end
                if data.ai2 >= 0 and data.ai2 <= 35 then
                    v.animationFrame = SMB3BowserNPC.lookAroundFrames[data.animationFramed]
                end
                if data.ai2 >= 36 then
                    local nearestPlayer = Player.getNearest(v.x, v.y)
                    local calculation = v.x - nearestPlayer.x
                    if calculation <= 1 then
                        v.direction = 1
                    elseif calculation >= 1 then
                        v.direction = -1
                    elseif calculation == 0 then
                        v.direction = 1
                    end
                    data.dontJump = false
                    data.ai2 = 0
                    data.bossStage = 1
                end
            end
        end
    end
end

--Gotta return the library table!
return SMB3BowserNPC