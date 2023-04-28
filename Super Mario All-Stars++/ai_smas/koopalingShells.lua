local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local rng = require ("rng")
local playerStun = require("playerstun")
local smasExtraSounds = require("smasExtraSounds")

local p = 0

local koopalingShells = {}

--Defines NPC config for our NPC. You can remove superfluous definitions.
local koopalingShellSettings = {
	id = npcID,
	--Sprite size
	gfxheight = 32,
	gfxwidth = 44,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 28,
	height = 32,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 0,
	--Frameloop-related
	frames = 6,
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
	noyoshi= true,
	nowaterphysics = false,
	--Various interactions
	jumphurt = false, --If true, spiny-like
	spinjumpsafe = true, --If true, prevents player hurt when spinjumping
	harmlessgrab = false, --Held NPC hurts other NPCs if false
	harmlessthrown = false, --Thrown NPC hurts other NPCs if false
	staticdirection = true,
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
	counter = 0,
    transformKoopaID = 942,
    canJump = false,
    koopalingShellConfig = "larry"
}

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.

local idslist = {}

function koopalingShells.register(args)
    args.npcID = args.npcID or 941
    args.transformKoopaID = args.transformKoopaID or 942
    
    if args.canJump == nil then
        args.canJump = true
    end
    
    args.koopalingShellConfig = args.koopalingShellConfig or "larry"
    
    args.gfxwidth = args.gfxwidth or 44
    args.gfxheight = args.gfxheight or 32
    args.width = args.width or 32
    args.height = args.height or 28
    
    koopalingShells[args.npcID] = {}
    
	koopalingShellSettings.id = args.npcID
    koopalingShellSettings.transformKoopaID = args.transformKoopaID
    koopalingShellSettings.canJump = args.canJump
    koopalingShellSettings.koopalingShellConfig = args.koopalingShellConfig
    
    koopalingShellSettings.gfxwidth = args.gfxwidth
    koopalingShellSettings.gfxheight = args.gfxheight
    koopalingShellSettings.width = args.width
    koopalingShellSettings.height = args.height
    
    table.insert(idslist, args.npcID, {
        id = args.npcID,
        transformKoopaID = args.transformKoopaID,
        canJump = args.canJump,
        koopalingShellConfig = args.koopalingShellConfig,
        counter = koopalingShellSettings.counter,
    })
    
    koopalingShells[args.npcID].config = npcManager.setNpcSettings(koopalingShellSettings)
    npcManager.registerHarmTypes(args.npcID,
	{
        HARM_TYPE_JUMP,
        --HARM_TYPE_FROMBELOW,
        HARM_TYPE_NPC,
        HARM_TYPE_PROJECTILE_USED,
        HARM_TYPE_LAVA,
        --HARM_TYPE_HELD,
        --HARM_TYPE_TAIL,
        --HARM_TYPE_SPINJUMP,
        HARM_TYPE_OFFSCREEN,
        HARM_TYPE_SWORD
    }, 
    {
        --[HARM_TYPE_JUMP]=10,
        --[HARM_TYPE_FROMBELOW]=10,
        [HARM_TYPE_NPC]=10,
        [HARM_TYPE_PROJECTILE_USED]=10,
        [HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
        --[HARM_TYPE_HELD]=10,
        --[HARM_TYPE_TAIL]=10,
        --[HARM_TYPE_SPINJUMP]=10,
        [HARM_TYPE_OFFSCREEN]=10,
        [HARM_TYPE_SWORD]=10,
    })
    
    npcManager.registerEvent(args.npcID, koopalingShells, "onTickEndNPC")
    registerEvent(koopalingShells, "onNPCHarm")
end

function koopalingShells.onTickEndNPC(v)
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
		data.special = 0
		data.counter = idslist[v.id].counter --or 0
		data.jumping = false
		data.hp = data.hp or 15
		data.immunity = 0
		p = 0
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	--Execute main AI.
	if p == 0 then 
        C = 0
		while(p==0) do
			B = Player(rng.randomInt(0, Player.count()))
			if B:mem(0x13C, FIELD_BOOL) == false and B.section == v:mem(0x146,FIELD_WORD) then
				p = B
			end
			C = C + 1
			if C >= 20 then
				p = player
			end
		end
	end
    
    SFX.play(smasExtraSounds.sounds[116].sfx, SFX.volume.MASTER, 1, smasExtraSounds.boomerangDelay)
    
	--npcutils.faceNearestPlayer(v)
	if data.special == 0 then
		data.counter = data.counter + 1
		if data.counter == 1 then
			v.speedY = 0
			v.speedX = 0
		end
		if data.counter >= 60 then
			data.special = 1
			data.counter = 0
		end
	elseif data.special == 1 then
        --Text.print(data.counter, 100, 100)
		v.speedX = v.speedX + (0.2 * v.direction)
		if v.speedX > 5 then
			v.speedX = 5
		elseif v.speedX < -5 then
			v.speedX = -5
		end
		data.counter = data.counter + 1
        
        if idslist[v.id].canJump then
            if v.collidesBlockBottom and data.counter < 45 then
                v.speedY = -7.5
                if idslist[v.id].koopalingShellConfig == "ludwig" then
                    Misc.doPOW(12, true, false, "SMB3 Koopaling Shell Earthquake")
                    SFX.play(37)
                end
            end
        end
        
        if v.collidesBlockLeft then
            v.direction = 1
        end
        if v.collidesBlockRight then
            v.direction = -1
        end
                
		if data.counter >= 45 and v.speedY == 0 then
			data.special = 2
			data.counter = 0
		end
	elseif data.special == 2 then
		v.speedY = -5 - rng.randomInt(1,3)
        if idslist[v.id].koopalingShellConfig == "ludwig" then
            Misc.doPOW(12, true, false, "SMB3 Koopaling Shell Earthquake")
            SFX.play(37)
        end
		data.special = 3
	elseif data.special == 3 then
		if v.speedX > 2.5 then
			v.speedX = v.speedX - 0.2
		elseif v.speedX < -2.5 then
			v.speedX = v.speedX + 0.2
		end
		data.counter = data.counter + 1
                
		if data.counter == 20 then
			local helth = data.hp
			local immune = data.immunity
			isboss = v.legacyBoss
			v:transform(idslist[v.id].transformKoopaID)
			v.data.hp = helth
			v.legacyBoss = isboss
			v.data.special = 0
			v.data.dir = v.direction
			v.data.harmable = true
			v.data.immunity = immune
			--.Special4 = 0
			p = 0
			--.Special6 = 0
		end
	else
		data.special = 0
	end
	if data.immunity > 0 then
		data.immunity = data.immunity - 1
	end
	v.despawnTimer = 10
end

function koopalingShells.onNPCHarm (eventObj, killedNPC, killReason, culprit)
    if idslist[killedNPC.id] ~= nil then
        if killedNPC.id == idslist[killedNPC.id].id and killReason ~= HARM_TYPE_OFFSCREEN then
            if killReason ~= HARM_TYPE_LAVA then
                eventObj.cancelled = true
                local data = killedNPC.data
                immune = data.immunity
                if immune == 0 then
                if killReason == HARM_TYPE_PROJECTILE_USED  then
                    data.hp = data.hp - 1
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
                elseif killReason == HARM_TYPE_JUMP then
                    SFX.play(2)
                    if culprit.x + culprit.width / 2 < killedNPC.x + killedNPC.width / 2 then
                        culprit.speedX = -3
                    else
                        culprit.speedX = 3
                    end
                end
                if data.hp <= 0  then
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
                    killedNPC:kill(HARM_TYPE_OFFSCREEN)
                end
                else
                    immune = immune - 1
                end
                data.immunity = immune
            end
        end
    end
end

return koopalingShells