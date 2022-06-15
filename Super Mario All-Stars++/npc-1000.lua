local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")
local Routine = require("routine")
local rng = require("base/rng")

local dudstar = {}

local npcID = NPC_ID
local id = 1000

local dudStarSettings = {
	id = 1000,
	
	gfxwidth = 32,
	gfxheight = 32,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 32,
	height = 32,
	
	frames = 3,
	framestyle = 0,
	framespeed = 8,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.
	
	nohurt = true,
	nogravity = true,
	noblockcollision = false,
	nofireball = true,
	noiceball = true,
	noyoshi = true,
	nowaterphysics = false,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	ignorethrownnpcs = true,

	isinteractable = true,
	sparkles = true,
	floats = true,
	
	
}

npcManager.setNpcSettings(dudStarSettings)
npcManager.registerHarmTypes(npcID,
	{
		[HARM_TYPE_JUMP]            = 10,
		[HARM_TYPE_FROMBELOW]       = 10,
		[HARM_TYPE_NPC]             = 10,
		[HARM_TYPE_PROJECTILE_USED] = 10,
		[HARM_TYPE_HELD]            = 10,
		[HARM_TYPE_TAIL]            = 10,
		[HARM_TYPE_SPINJUMP]        = 10,
		[HARM_TYPE_SWORD]           = 10,
	}
)

local playervuln = false
local playerwon = false
dudstar.collectableIDList = {}
dudstar.collectableIDMap  = {}

function muteMusic(sectionid) --Mute all section music, or just mute a specific section
	if sectionid == -1 then --If -1, all section music will be muted
		for i = 0,20 do
			musiclist = {Section(i).music}
			GameData.levelMusicTemporary[i] = Section(i).music
			Audio.MusicChange(i, 0)
		end
	elseif sectionid >= 0 or sectionid <= 20 then
		musiclist = {Section(sectionid).music}
		GameData.levelMusicTemporary[sectionid] = Section(sectionid).music
		Audio.MusicChange(sectionid, 0)
	end
end

function starget()
	Level.finish(LEVEL_END_STATE_STAR, true)
	Misc.npcToCoins()
	SFX.play(52)
	muteMusic(-1)
	GameData.____muteMusic = true
	GameData.winStateActive = true
	playervuln = true
	playerwon = true
end

function dudstar.onPostNPCKill(v,reason)
	if dudstar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
		Routine.run(starget)
	end
end

function dudstar.onInputUpdate()
	if playerwon then
		player.upKeyPressing = false
		player.downKeyPressing = false
		player.leftKeyPressing = false
		player.rightKeyPressing = false
		player.altJumpKeyPressing = false
		player.runKeyPressing = false
		player.altRunKeyPressing = false
		player.dropItemKeyPressing = false
		player.jumpKeyPressing = false
		player.pauseKeyPressing = false
		if Player(2) and Player(2).isValid then
			player2.upKeyPressing = false
			player2.downKeyPressing = false
			player2.leftKeyPressing = false
			player2.rightKeyPressing = false
			player2.altJumpKeyPressing = false
			player2.runKeyPressing = false
			player2.altRunKeyPressing = false
			player2.dropItemKeyPressing = false
			player2.jumpKeyPressing = false
			player2.pauseKeyPressing = false
		end
	end
end

function dudstar.animateNPC(v)
    v.data.animationTimer = v.data.animationTimer + 1
    if v.data.animationTimer%NPC.config[v.id].framespeed == 0 then
        v.data.frame = v.data.frame + 1 
        if v.data.frame > ((NPC.config[v.id].frames*v.data.frameMulti)-1) then
            v.data.frame = ((NPC.config[v.id].frames*v.data.frameMulti)-1)
        end
        v.data.animationTimer = 0
    end
    v.animationFrame = npcutils.getFrameByFramestyle(v, {frame=v.data.frame})
end

function dudstar.isStarCollected(npc, filename)
    local collected = false
	if table.icontains(SaveData.completeLevelsOptional,Level.filename()) then
		collected = true
	end
    return collected
end

function dudstar.onTickEndNPC(v)
    local data = v.data
 
    if not data.initialized then
        data._settings.starIndex = data._settings.starIndex or 1
        
        data.collected = dudstar.isStarCollected(v, Level.filename())
        if data.collected then
            data.frameMulti = 1
        else
            data.frameMulti = 0.5
        end
        data.frame = ((NPC.config[v.id].frames*data.frameMulti)-1)
        data.animationTimer = 0
        data.initialized = true
    end
 
    if Defines.levelFreeze then return end
 
    dudstar.animateNPC(v)
 
    if NPC.config[v.id].sparkles then
        v.ai4 = v.ai4 + 1
        if v.ai4 >= 10*data.frameMulti then
            v.ai4 = 0
            local e = Effect.spawn(80, v.x + RNG.random()*v.width - 2, v.y + RNG.random()*v.height)
            e.speedX = RNG.random()*1 - 0.5
            e.speedY = RNG.random()*1 - 0.5
            if data.frameMulti == 1 then -- set frame of effects only for collected stars
                e.animationFrame = 1
            end
        end
    end
 
    if NPC.config[v.id].floats and not v:mem(0x136, FIELD_BOOL) then
        if v.ai2 == 0 then
            v.speedY = v.speedY - 0.04
            if v.speedY <= -1.4 then v.ai2 = 1 end
        else
            v.speedY = v.speedY + 0.04
            if v.speedY >= 1.4 then v.ai2 = 0 end
        end
        -- if v.ai3 == 0 then -- idk what this for but it's in source?
        --     v.speedX = v.speedX - 0.03
        --     if v.speedX <= -0.6 then v.ai3 = 1 end
        -- else
        --     v.speedX = v.speedX + 0.03
        --     if v.speedX >= 0.6 then v.ai3 = 0 end
        -- end
    end
 
    if NPC.config[v.id].uselayerspeed then -- can't be used in conjunction with floats
        v.speedX, v.speedY = npcutils.getLayerSpeed(v)
    end
 
end

function dudstar.onPlayerHarm(evt)
	if playervuln == true then
		evt.cancelled = true
	end
end

function dudstar.onExit()
	GameData.____muteMusic = false
	GameData.winStateActive = false
	if Level.endState(LEVEL_END_STATE_STAR) then
		Level.exit(LEVEL_WIN_TYPE_STAR)
	end
end

function dudstar.onPostNPCKill(v,reason)
	if dudstar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
		Routine.run(starget)
		if GameData.rushModeActive == false or GameData.rushModeActive == nil then
			if GameData.marioChallengeActivated == false then
				if not table.icontains(SaveData.completeLevelsOptional,Level.filename()) then
					table.insert(SaveData.completeLevelsOptional,Level.filename())
					SaveData.totalStarCount = SaveData.totalStarCount
				elseif table.icontains(SaveData.completeLevelsOptional,Level.filename()) then
					SaveData.totalStarCount = SaveData.totalStarCount
				end
			end
		end
	end
end

function dudstar.onInitAPI()
	npcManager.registerEvent(npcID,dudstar,"onTickNPC")
	npcManager.registerEvent(npcID,dudstar,"onTickEndNPC")
	npcManager.registerEvent(npcID,dudstar,"onDrawNPC")
	
	table.insert(dudstar.collectableIDList,id)
	dudstar.collectableIDMap[id] = true
	
	registerEvent(dudstar,"onPlayerHarm")
	registerEvent(dudstar,"onInputUpdate")
	registerEvent(dudstar,"onPostNPCKill")
	registerEvent(dudstar,"onExit")
end

return dudstar