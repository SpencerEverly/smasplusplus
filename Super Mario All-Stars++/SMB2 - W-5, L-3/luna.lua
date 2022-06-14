local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
	local character = player.character
	if (character == CHARACTER_YOSHI) then
		triggerEvent("YoshiBossAddition")
	end
end

local nokeys = false
local nokeysexceptjump = false

function onEvent(eventName)
	if eventName == "Boss End (Part 2)" then
		nokeys = true
	end
	if eventName == "Boss End 2 (Part 2)" then
		playSound(137)
	end
	if eventName == "Boss End 3 (Part 2)" then
		nokeys = false
	end
	if eventName == "World Clear 1" then
		nokeys = true
	end
	if eventName == "World Clear 2" then
		playSound(4)
	end
	if eventName == "World Clear 4" then
		playSound("record-scratch.ogg")
		nokeys = false
		nokeysexceptjump = true
	end
	if eventName == "World Clear 8" then
		nokeysexceptjump = false
	end
end

function onPlayerHarm(eventToken)
	if nokeys then
		eventToken.cancelled = true
	end
end

function onInputUpdate()
	if nokeys then
		player.upKeyPressing = false;
		player.downKeyPressing = false;
		player.leftKeyPressing = false;
		player.rightKeyPressing = false;
		player.altJumpKeyPressing = false;
		player.runKeyPressing = false;
		player.altRunKeyPressing = false;
		player.dropItemKeyPressing = false;
		player.jumpKeyPressing = false;
		if Player(2) and Player(2).isValid then
			player2.upKeyPressing = false;
			player2.downKeyPressing = false;
			player2.leftKeyPressing = false;
			player2.rightKeyPressing = false;
			player2.altJumpKeyPressing = false;
			player2.runKeyPressing = false;
			player2.altRunKeyPressing = false;
			player2.dropItemKeyPressing = false;
			player2.jumpKeyPressing = false;
		end
	end
	if nokeysexceptjump then
		player.upKeyPressing = false;
		player.downKeyPressing = false;
		player.leftKeyPressing = false;
		player.rightKeyPressing = false;
		player.altJumpKeyPressing = false;
		player.runKeyPressing = false;
		player.altRunKeyPressing = false;
		player.dropItemKeyPressing = false;
		if Player(2) and Player(2).isValid then
			player2.upKeyPressing = false;
			player2.downKeyPressing = false;
			player2.leftKeyPressing = false;
			player2.rightKeyPressing = false;
			player2.altJumpKeyPressing = false;
			player2.runKeyPressing = false;
			player2.altRunKeyPressing = false;
			player2.dropItemKeyPressing = false;
		end
	end
end