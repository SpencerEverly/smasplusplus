local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local rng = require ("rng")
local playerStun = require("playerstun")

local playerX
local playerY

local wait = 10
local projectile

local koopalings = {}

--Defines NPC config for our NPC. You can remove superfluous definitions.
local koopalingSettings = {
	id = npcID,
	--Sprite size
    gfxwidth = 84,
	gfxheight = 62,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 44,
	height = 50,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 3,
	--Frameloop-related
	frames = 10,
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
	nofireball = false,
	noiceball = true,
	noyoshi= true,
	nowaterphysics = false,
	--Various interactions
	jumphurt = false, --If true, spiny-like
	spinjumpsafe = true, --If true, prevents player hurt when spinjumping
	harmlessgrab = false, --Held NPC hurts other NPCs if false
	harmlessthrown = false, --Thrown NPC hurts other NPCs if false

	--Identity-related flags. Apply various vanilla AI based on the flag:
	--iswalker = true,
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
	health = 15,
	attackTimer = 30,
	attackDelay = 10,
	attackCount = 3,
	jumpCounter = 0,
	projectile =  269,
    transformShellID = 941,
}

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.

local idslist = {}

function koopalings.register(npcID, transformShellID)
    koopalings[npcID] = {}
	koopalingSettings.id = npcID
    table.insert(idslist, npcID)
    koopalingSettings.transformShellID = transformShellID
    koopalings[npcID].config = npcManager.setNpcSettings(koopalingSettings)
    npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_JUMP,
		HARM_TYPE_FROMBELOW,
		HARM_TYPE_NPC,
		HARM_TYPE_PROJECTILE_USED,
		HARM_TYPE_LAVA,
		HARM_TYPE_HELD,
		--HARM_TYPE_TAIL,
		HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		HARM_TYPE_SWORD
	}, 
	{
		[HARM_TYPE_JUMP]=988,
		[HARM_TYPE_FROMBELOW]=988,
		[HARM_TYPE_NPC]=988,
		[HARM_TYPE_PROJECTILE_USED]=988,
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]=10,
		--[HARM_TYPE_TAIL]=10,
		[HARM_TYPE_SPINJUMP]=988,
		[HARM_TYPE_OFFSCREEN]=988,
		[HARM_TYPE_SWORD]=988,
	})
    
    npcManager.registerEvent(npcID, koopalings, "onTickNPC")
	npcManager.registerEvent(npcID, koopalings, "onDrawNPC")
    registerEvent(koopalings, "onNPCHarm")
end

function koopalings.animator(leNPC)
	--data = leNPC.data
	leNPC.data.frame = 0
	if leNPC.data.special == 0 then
        if leNPC.speedY == 0 then
            if leNPC.speedX == 0 then
                leNPC.data.frame = 0
            else
                leNPC.data.framecount = leNPC.data.framecount + 1
				
                if leNPC.data.framecount < 8 then
                    leNPC.data.frame = 0
                elseif leNPC.data.framecount < 16 then
                    leNPC.data.frame = 1
                else
                    leNPC.data.frame = 0
                    leNPC.data.framecount = 0
                end
            end
        else
            leNPC.data.frame = 1
        end
    elseif leNPC.data.special == 1 then
            leNPC.data.framecount = leNPC.data.framecount + 1
        if leNPC.data.framecount < 2 then
            leNPC.data.frame = 2
        elseif leNPC.data.framecount < 4 then
            leNPC.data.frame = 3
        elseif leNPC.data.framecount < 6 then
            leNPC.data.frame = 4
        elseif leNPC.data.framecount < 8 then
            leNPC.data.frame = 5
        else
            leNPC.data.frame = 2
            leNPC.data.framecount = 0
        end
    elseif leNPC.data.special == 2 then
        leNPC.data.framecount = leNPC.data.framecount + 1
        if leNPC.data.framecount < 2 then
            leNPC.data.frame = 6
        elseif leNPC.data.framecount < 4 then
            leNPC.data.frame = 7
        elseif leNPC.data.framecount < 6 then
            leNPC.data.frame = 8
        elseif leNPC.data.framecount < 8 then
            leNPC.data.frame = 9
        else
			leNPC.data.frame = 6
            leNPC.data.framecount = 0
        end
	end
    if leNPC.data.dir == 1 then
		leNPC.data.frame = leNPC.data.frame + 10
	end
	leNPC.animationFrame = leNPC.data.frame
end

function koopalings.turnToTarget(npc,player)
	local stuff = npc.data
	local p = Player.getNearest(npc.x + 0.5 * npc.width, npc.y)
	if p.x + p.width / 2 < npc.x + npc.width / 2 then
        if npc.data.dir == 1 then
            stuff.jumpCount = stuff.jumpCount + 30
        end
        npc.data.dir = -1
    else
        if npc.data.dir == -1 then
            stuff.jumpCount = stuff.jumpCount + 30
        end
        npc.data.dir = 1
    end
end

function koopalings.onTickNPC(v)
	--Don't act during time freeze or when it's hidden
	if Defines.levelFreeze then return end
	
	local data = v.data
	for _,k in ipairs(NPC.get(268)) do
	end
	--If despawned
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		--Reset our properties, if necessary
		data.initialized = false
		return
	end
	local cfg = NPC.config[v.id]
	-- Initialize the data if it doesn't exist yet
	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		data.jumpCount = koopalingSettings.jumpCounter --or 30
		data.attackTime = koopalingSettings.attackTimer --or 30
		data.attackDelay = koopalingSettings.attackDelay --or 10
		data.hp = data.hp or koopalingSettings.health --or 15
		data.frame = 0
		data.framecount = data.framecount or 0
		data.special = -1
        data.timer = 0
		data.dir = v.direction
		data.initialized = true
		data.harmable = true
		data.jumping = false
		data.immunity = 0
	end
	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	
	--Execute main AI.
    if data.special == -1 then
        data.timer = data.timer + 1
        if data.timer >= 25 then
            data.timer = 0
            data.special = 0
        end
    end
    if data.special == 0 then
        if v.dontMove == false then
            v.speedX = 2*v.direction
        end
        koopalings.turnToTarget(v,player)
        if v.speedY == 0 then
            data.jumpCount = data.jumpCount + 1
            if data.jumpCount == 30 + rng.randomInt(0, 99) then
                data.jumpCount = 0
                v.speedY = -5 - rng.randomInt(0, 3)
                data.jumping = true
            end
        else
            data.jumpCount = 0
        end
        if data.jumping and v.speedY == 0 then
            --[[if v.collidesBlockBottom then
                Defines.earthquake = 6
                data.jumping = false
                SFX.play(37)
                for k, p in ipairs(Player.get()) do
                    if p:isGroundTouching() and not playerStun.isStunned(k) and v:mem(0x146, FIELD_WORD) == player.section then
                        playerStun.stunPlayer(k, 70)
                    end
                end
            end]]
        end
        data.attackTime = data.attackTime + 1
        if data.attackTime >= 200 + rng.randomInt(0, 99) and v.speedY == 0 then
            data.special = 1
            p = 0
            data.jumpCount = 0
            data.attackTime = 0
            data.immunity = 0
        end
    elseif data.special == 1 then
        if p==0 then
            p = Player.getNearest(v.x + 0.5 * v.width, v.y)
        end
        if p.x + p.width / 2 < v.x + v.width / 2 then
            v.direction = -1
        else
            v.direction = 1
        end
        v.data.dir = v.direction
        v.speedX = 0
        data.attackDelay = data.attackDelay + 1
        if data.attackDelay >= 10 then
            data.attackDelay = 0
            data.attackCount = 0
            data.special = 2
        end
    elseif data.special == 2 then
        v.speedX = 0
        if data.attackCount == 0 or data.attackCount == 6 or data.attackCount == 12 then
            if data.attackCount == 0 then
                playerX = p.x + p.width / 2
                playerY = p.y + p.height / 2 + 16
            end
            if data.attackCount == 0 then
                Audio.playSFX(34)
            end
            if v.direction == -1 then
                projectile = v.spawn(269, v.x - 18, v.y+39, v:mem(0x146,FIELD_WORD),false,true)
            else
                projectile = v.spawn(269, v.x + v.width - 10 + 22, v.y+39, v:mem(0x146,FIELD_WORD),false,true)
            end
            projectile.direction = v.direction
            projectile.ai2 = data.attackCount
            projectile.speedX = 3 * projectile.direction
            C = (projectile.x + projectile.width / 2) - playerX
            D = (projectile.y + projectile.height / 2) - playerY
            projectile.speedY = D / C * projectile.speedX
            if projectile.speedY > 3 then
                projectile.speedY = 3
            elseif projectile.speedY < -3 then
                projectile.speedY = -3
            end
        end
        data.attackCount = data.attackCount + 1
        if data.attackCount >= 30 then
            data.special = 0
            playerX = 0
            data.attackTime = 0
            playerY = 0
        end
    end
    if data.immunity > 0 then
        data.immunity = data.immunity - 1
    end
    if v.despawnTimer > 1 then 
        v.despawnTimer = 100
    end
end

function koopalings.onDrawNPC(v)
	if not Defines.levelFreeze and not v.attachedLayerObj.isHidden then
		koopalings.animator(v)
	end
end

function koopalings.onNPCHarm(eventObj, killedNPC, killReason, culprit)
    if killedNPC.friendly then
        return
    end
    if killedNPC.id == koopalingSettings.id and killReason ~= HARM_TYPE_OFFSCREEN then
        if killReason ~= HARM_TYPE_LAVA then
            eventObj.cancelled = true
            local data = killedNPC.data
            immune = data.immunity
            if immune == nil then
                immune = 0
            end
            if immune == 0 then
                if killReason == HARM_TYPE_JUMP or killReason == HARM_TYPE_SPINJUMP or killReason == HARM_TYPE_FROMBELOW then
                    SFX.play(2)
                    data.hp = data.hp - 5
                    data.special = 5
                    immune = 10
                elseif killReason == HARM_TYPE_SWORD then
                    SFX.play(89)
                    data.hp = data.hp - 2
                    immune = 10
                elseif killReason == HARM_TYPE_NPC then
                    if culprit.id == 13  then
                        SFX.play(9)
                        data.hp = data.hp - 1
                        immune = 10
                    else
                        SFX.play(39)
                        data.hp = data.hp - 5
                        data.special = 5
                        immune = 10
                    end
                elseif killReason == HARM_TYPE_LAVA and killedNPC ~= nil then
                    killedNPC:kill(HARM_TYPE_OFFSCREEN)
                end
                if data.hp <= 0  then
                    killedNPC:kill(HARM_TYPE_OFFSCREEN)
                    if killedNPC.legacyBoss then
                        oldX = killedNPC.x
                        oldY = killedNPC.y
                        oldWidth = killedNPC.width
                        oldSection = killedNPC:mem(0x146,FIELD_WORD)
                        Routine.run(function()
                            Routine.wait(1,false)
                            goal = NPC.spawn(16, oldX, oldY, oldSection,true,true)
                            goal:mem(0xA8, FIELD_DFLOAT,0)
                            goal.speedY = -5
                            end
                        )
                    end
                elseif data.special == 5 then
                    data.special = 0
                    data.dir = 0
                    data.jumpCount = 0
                    data.attackTime = 0
                    p = 0
                    playerX = 0
                    local helth = data.hp
                    local isboss = killedNPC.legacyBoss
                    killedNPC:transform(koopalingSettings.transformShellID)
                    killedNPC.data.hp = helth
                    killedNPC.legacyBoss = isboss
                    killedNPC.data.counter = 0
                    killedNPC.data.immunity = immune
                end
            end
            data.immunity = immune
        end
    end
end

return koopalings