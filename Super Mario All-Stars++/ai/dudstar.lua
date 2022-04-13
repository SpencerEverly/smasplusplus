local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")

local dudstar = {}

local playervuln = false
local playerwon = false
dudstar.collectableIDList = {}
dudstar.collectableIDMap  = {}

function starget()
	playervuln = true
	Routine.wait(5, true)
	Level.exit(LEVEL_WIN_TYPE_STAR)
end

function dudstar.registerCollectable(id)
	npcManager.registerEvent(id,dudstar,"onTickNPC","onTickCollectable")
	npcManager.registerEvent(id,dudstar,"onPostNPCKill","onPostNPCKill")
	npcManager.registerEvent(id,dudstar,"onInputUpdate","onInputUpdate")
	npcManager.registerEvent(id,dudstar,"onPlayerHarm","onPlayerHarm")
	
	table.insert(dudstar.collectableIDList,id)
	dudstar.collectableIDMap[id] = true
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

function dudstar.onPlayerHarm(evt)
	if playervuln == true then
		evt.cancelled = true
	end
end

function dudstar.onTickCollectable(v)
	
end

function dudstar.onPostNPCKill(v,reason)
	if dudstar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
		playSound(52)
		Routine.run(starget)
	end
end