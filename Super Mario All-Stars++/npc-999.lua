local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")
local Routine = require("routine")
local rng = require("base/rng")

local realstar = {}

local npcID = NPC_ID
local id = 999

local realStarSettings = {
	id = 999,
	
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
	
}

local playervuln = false
local playerwon = false
realstar.collectableIDList = {}
realstar.collectableIDMap  = {}
realstar.collectableIDStar = {}

npcManager.setNpcSettings(realStarSettings)
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
	SFX.play(52)
	muteMusic(-1)
	GameData.muteMusic = true
	playervuln = true
	playerwon = true
end

function realstar.onPostNPCKill(v,reason)
	if realstar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
		Routine.run(starget)
		if not table.icontains(SaveData.completeLevels,Level.filename()) then
			SaveData.totalStarCount = SaveData.totalStarCount + 1
			table.insert(SaveData.completeLevels,Level.filename())
		elseif table.icontains(SaveData.completeLevels,Level.filename()) then
			SaveData.totalStarCount = SaveData.totalStarCount
		end
	end
end

function realstar.onInputUpdate()
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

function realstar.onPlayerHarm(evt)
	if playervuln == true then
		evt.cancelled = true
	end
end

function realstar.onExit()
	GameData.muteMusic = false
	if Level.endState(LEVEL_END_STATE_STAR) then
		Level.exit(LEVEL_WIN_TYPE_STAR)
	end
end

function realstar.onInitAPI()
	npcManager.registerEvent(npcID,realstar,"onTickNPC")
	
	table.insert(realstar.collectableIDList,id)
	realstar.collectableIDMap[id] = true
	realstar.collectableIDStar[97] = true
	
	registerEvent(realstar,"onPlayerHarm")
	registerEvent(realstar,"onInputUpdate")
	registerEvent(realstar,"onPostNPCKill")
	registerEvent(realstar,"onExit")
end

return realstar