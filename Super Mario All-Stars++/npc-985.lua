local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")
local Routine = require("routine")
local rng = require("base/rng")

local roulettestar = {}

local npcID = NPC_ID
local id = 985

local roulettestarSettings = {
	id = 985,
	
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
roulettestar.collectableIDList = {}
roulettestar.collectableIDMap  = {}
roulettestar.collectableIDStar = {}

npcManager.setNpcSettings(roulettestarSettings)
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
	playervuln = true
	playerwon = true
	SFX.play(52)
	muteMusic(-1)
	GameData.muteMusic = true
	Routine.wait(5, true)
	Level.exit(LEVEL_WIN_TYPE_STAR)
end

function roulettestar.onPostNPCKill(v,reason)
	if roulettestar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
		Routine.run(starget)
		if not table.icontains(SaveData.completeLevels,Level.filename()) then
			SaveData.totalStarCount = SaveData.totalStarCount + 1
			table.insert(SaveData.completeLevels,Level.filename())
		elseif table.icontains(SaveData.completeLevels,Level.filename()) then
			SaveData.totalStarCount = SaveData.totalStarCount
		end
		if v.frame == 1 then
			SaveData.totalScoreClassic = SaveData.totalScoreClassic + 1000
			Misc.givePoints(6, vector(player.x, player.y))
		elseif v.frame == 2 then
			SaveData.totalScoreClassic = SaveData.totalScoreClassic + 4000
			Misc.givePoints(8, vector(player.x, player.y))
		elseif v.frame == 3 then
			SaveData.totalLives = SaveData.totalLives + 1
			Misc.givePoints(10, vector(player.x, player.y))
			playSound(15)
		end
	end
end

function roulettestar.onInputUpdate()
	if playerwon then
		player.upKeyPressing = false
		player.downKeyPressing = false
		player.leftKeyPressing = false
		player.rightKeyPressing = true
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

function roulettestar.onPlayerHarm(evt)
	if playervuln == true then
		evt.cancelled = true
	end
end

function roulettestar.onPlayerKill(evt)
	if playervuln == true then
		evt.cancelled = true
	end
end

function roulettestar.onExit()
	GameData.muteMusic = false
	if Level.endState() == LEVEL_END_STATE_ROULETTE then
		GameData.smwMap.winType = 6
		Level.exit(LEVEL_WIN_TYPE_STAR)
	end
end

function roulettestar.onInitAPI()
	npcManager.registerEvent(npcID,roulettestar,"onTickNPC")
	
	table.insert(roulettestar.collectableIDList,id)
	roulettestar.collectableIDMap[id] = true
	roulettestar.collectableIDStar[97] = true
	
	registerEvent(roulettestar,"onPlayerHarm")
	registerEvent(roulettestar,"onPlayerKill")
	registerEvent(roulettestar,"onInputUpdate")
	registerEvent(roulettestar,"onPostNPCKill")
	registerEvent(roulettestar,"onExit")
end

return roulettestar