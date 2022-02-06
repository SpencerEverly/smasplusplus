local level_dependencies_normal= require("level_dependencies_normal")

local inventory = require("customInventory")

function onEvent(eventName)
	if eventName == "3" then
		Audio.MusicChange(0, "_OST/Super Mario Bros 3/Battle Mode.spc|0;g=2.5")
		SFX.play("battle-countdown.wav")
	end
	if eventName == "2" then
		SFX.play("battle-countdown.wav")
	end
	if eventName == "1" then
		SFX.play("battle-countdown.wav")
	end
	if eventName == "GO" then
		SFX.play("battle-start.wav")
	end
	if eventName == "START" then
		Timer.activate(50)
	end
	if eventName == "Smash!" then
		SFX.play("hits1.wav")
	end
	if eventName == "Finish!" then
		Timer.deactivate()
	end
    if eventName == "Finish 3" then
        inventory.addPowerUp(7, 1)
		SFX.play("chest.wav")
		player.upKeyPressing = false;
		player.downKeyPressing = false;
		player.altJumpKeyPressing = false;
		player.altRunKeyPressing = false;
		player.dropItemKeyPressing = false;
		player.leftKeyPressing = false;
		player.rightKeyPressing = false;
		player.jumpKeyPressing = false;
		player.runKeyPressing = false;
		SFX.play("_OST/Super Mario Bros 3/Battle Mode Win.ogg")
    end
    if eventName == "End Level" then
        Level.exit()
    end
end