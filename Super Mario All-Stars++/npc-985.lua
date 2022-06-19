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

local collectactive = false
local playervuln = false
local playerwon = false
local playermovement = 0
local player2movement = 0
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
	Misc.npcToCoins()
	GameData.winStateActive = true
	playervuln = true
	playerwon = true
	SFX.play(52)
	muteMusic(-1)
	GameData.____muteMusic = true
	Routine.wait(5, true)
	GameData.winStateActive = false
	Level.exit(LEVEL_WIN_TYPE_STAR)
end

walkCycles = {}

walkCycles[CHARACTER_MARIO]           = {[PLAYER_SMALL] = {1,2, framespeed = 8},[PLAYER_BIG] = {1,2,3,2, framespeed = 6}}
walkCycles[CHARACTER_LUIGI]           = walkCycles[CHARACTER_MARIO]
walkCycles[CHARACTER_PEACH]           = {[PLAYER_BIG] = {1,2,3,2, framespeed = 6}}
walkCycles[CHARACTER_TOAD]            = walkCycles[CHARACTER_PEACH]
walkCycles[CHARACTER_LINK]            = {[PLAYER_BIG] = {4,3,2,1, framespeed = 6}}
walkCycles[CHARACTER_MEGAMAN]         = {[PLAYER_BIG] = {2,3,2,4, framespeed = 12}}
walkCycles[CHARACTER_WARIO]           = walkCycles[CHARACTER_MARIO]
walkCycles[CHARACTER_BOWSER]          = walkCycles[CHARACTER_TOAD]
walkCycles[CHARACTER_KLONOA]          = walkCycles[CHARACTER_TOAD]
walkCycles[CHARACTER_NINJABOMBERMAN]  = walkCycles[CHARACTER_PEACH]
walkCycles[CHARACTER_ROSALINA]        = walkCycles[CHARACTER_PEACH]
walkCycles[CHARACTER_SNAKE]           = walkCycles[CHARACTER_LINK]
walkCycles[CHARACTER_ZELDA]           = walkCycles[CHARACTER_LUIGI]
walkCycles[CHARACTER_ULTIMATERINKA]   = walkCycles[CHARACTER_TOAD]
walkCycles[CHARACTER_UNCLEBROADSWORD] = walkCycles[CHARACTER_TOAD]
walkCycles[CHARACTER_SAMUS]           = walkCycles[CHARACTER_LINK]

walkCycles["SMW-MARIO"] = {[PLAYER_SMALL] = {1,2, framespeed = 8},[PLAYER_BIG] = {3,2,1, framespeed = 6}}
walkCycles["SMW-LUIGI"] = walkCycles["SMW-MARIO"]

walkCycles["ACCURATE-SMW-MARIO"] = walkCycles["SMW-MARIO"]
walkCycles["ACCURATE-SMW-LUIGI"] = walkCycles["SMW-MARIO"]
walkCycles["ACCURATE-SMW-TOAD"]  = walkCycles["SMW-MARIO"]

local yoshiAnimationFrames = {
        {bodyFrame = 0,headFrame = 0,headOffsetX = 0 ,headOffsetY = 0,bodyOffsetX = 0,bodyOffsetY = 0,playerOffset = 0},
        {bodyFrame = 1,headFrame = 0,headOffsetX = -1,headOffsetY = 2,bodyOffsetX = 0,bodyOffsetY = 1,playerOffset = 1},
        {bodyFrame = 2,headFrame = 0,headOffsetX = -2,headOffsetY = 4,bodyOffsetX = 0,bodyOffsetY = 2,playerOffset = 2},
        {bodyFrame = 1,headFrame = 0,headOffsetX = -1,headOffsetY = 2,bodyOffsetX = 0,bodyOffsetY = 1,playerOffset = 1},
	}
	
local bootBounceData = {}

local player2camerax
local player2cameray
local inactivekeysonly = false

function roulettestar.onDraw()
	local playercameray = player.y - camera.y
	local playercamerax = player.x - camera.x
	if Player.count() >= 2 and Player(2).isValid then
		player2camerax = Player(2).x - camera.x
		player2cameray = Player(2).y - camera.y
	end
	if collectactive then
		for idx,p in ipairs(Player.get()) do
			local animation = walkCycles[p:getCostume()] or walkCycles[p.character]

			if animation ~= nil then
				local frame

				local x = 500
				local y = 10 - p.height

				if p.mount == MOUNT_BOOT then -- bouncing along in a boot
					bootBounceData[idx] = bootBounceData[idx] or {speed = 0,offset = 0}
					local bounceData = bootBounceData[idx]
							
					if not Misc.isPaused() then
						bounceData.speed = bounceData.speed + Defines.player_grav
						bounceData.offset = bounceData.offset + bounceData.speed

						if bounceData.offset >= 0 then
							bounceData.speed = -3.4
							bounceData.offset = 0
						end
					end

					y = y + bounceData.offset

					frame = 1
				elseif p.mount == MOUNT_CLOWNCAR then -- don't think this is even possible? but eh it's here
					frame = 1
				elseif p.mount == MOUNT_YOSHI then -- riding yoshi, yoshi's animation is a complete mess
					frame = 30

					local yoshiAnimationData = yoshiAnimationFrames[(math.floor(lunatime.tick() / 8) % #yoshiAnimationFrames) + 1]

					local xOffset = 4
					local yOffset = (72 - p.height)

					p:mem(0x72,FIELD_WORD,yoshiAnimationData.headFrame + 5)
					p:mem(0x7A,FIELD_WORD,yoshiAnimationData.bodyFrame + 7)

					p:mem(0x6E,FIELD_WORD,20 - xOffset + yoshiAnimationData.headOffsetX)
					p:mem(0x70,FIELD_WORD,10 - yOffset + yoshiAnimationData.headOffsetY)

					p:mem(0x76,FIELD_WORD,0  - xOffset + yoshiAnimationData.bodyOffsetX)
					p:mem(0x78,FIELD_WORD,42 - yOffset + yoshiAnimationData.bodyOffsetY)

					p:mem(0x10E,FIELD_WORD,yoshiAnimationData.playerOffset - yOffset)
				else -- just good ol' walking
					local walkCycle = animation[p.powerup] or animation[PLAYER_BIG]

					frame = walkCycle[(math.floor(lunatime.tick() / walkCycle.framespeed) % #walkCycle) + 1]
				end
				if player:isOnGround() then
					player:setFrame(-50*player.direction)
					playerwon = false
					inactivekeysonly = true
					playermovement = playermovement + Defines.player_walkspeed
					playermovement2 = playercamerax + playermovement
					p.direction = DIR_RIGHT

					player:render{
						x = playermovement2,y = playercameray,
						ignorestate = true,sceneCoords = false,priority = -25,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
						frame = frame,
					}
				end
				if Player.count() >= 2 and Player(2).isValid then
					p2 = player2 or Player(2)
					if p2:isOnGround() then
						p2:setFrame(-50*player.direction)
						playerwon = false
						inactivekeysonly = true
						player2movement = player2movement + Defines.player_walkspeed
						player2movement2 = player2camerax + player2movement
						p2.direction = DIR_RIGHT

						p2:render{
							x = player2movement2,y = player2cameray,
							ignorestate = true,sceneCoords = false,priority = -25,color = (Defines.cheat_shadowmario and Color.black) or Color.white,
							frame = frame,
						}
					end
				end
			end
		end
	end
end

function roulettestar.onNPCKill(eventToken, v)
	
end

function roulettestar.onPostNPCKill(v,reason)
	for _,p in ipairs(Player.get()) do
		if v.id == 985 and Colliders.collide(p, v) then
			if v.animationFrame == 0 then
				Misc.givePoints(6, vector(v.x + 26, v.y))
			elseif v.animationFrame == 1 then
				Misc.givePoints(8, vector(v.x + 26, v.y))
			elseif v.animationFrame == 2 then
				Misc.givePoints(10, vector(v.x + 26, v.y))
			end
		end
	end
	if roulettestar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
		Routine.run(starget)
		GameData.winStateActive = true
		collectactive = true
		if GameData.rushModeActive == false or GameData.rushModeActive == nil then
			if Misc.inMarioChallenge() == false then
				if not table.icontains(SaveData.completeLevels,Level.filename()) then
					SaveData.totalStarCount = SaveData.totalStarCount + 1
					table.insert(SaveData.completeLevels,Level.filename())
				elseif table.icontains(SaveData.completeLevels,Level.filename()) then
					SaveData.totalStarCount = SaveData.totalStarCount
				end
			end
		end
	end
end

function roulettestar.onInputUpdate()
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
		if Player.count() >= 2 and Player(2).isValid then
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
	if inactivekeysonly then
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
		if Player.count() >= 2 and Player(2).isValid then
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
	GameData.____muteMusic = false
	GameData.winStateActive = false
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
	registerEvent(roulettestar,"onNPCKill")
	registerEvent(roulettestar,"onPostNPCKill")
	registerEvent(roulettestar,"onDraw")
	registerEvent(roulettestar,"onExit")
end

return roulettestar