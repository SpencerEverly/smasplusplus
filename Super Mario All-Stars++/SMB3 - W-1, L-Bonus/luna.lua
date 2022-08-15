local level_dependencies_normal= require("level_dependencies_normal")

local inventory = require("customInventory")

function onEvent(eventName)
    if eventName == "3" then
        Sound.changeMusic("_OST/Super Mario Bros 3/Battle Mode.spc|0;g=2.5", 0)
        Sound.playSFX("battle-countdown.ogg")
    end
    if eventName == "2" then
        Sound.playSFX("battle-countdown.ogg")
    end
    if eventName == "1" then
        Sound.playSFX("battle-countdown.ogg")
    end
    if eventName == "GO" then
        Sound.playSFX("battle-start.ogg")
    end
    if eventName == "START" then
        Timer.activate(40)
    end
    if eventName == "Smash!" then
        Sound.playSFX("hits1.ogg")
    end
    if eventName == "Finish!" then
        Timer.deactivate()
    end
    if eventName == "Finish 3" then
        inventory.addPowerUp(6, 1)
        Sound.playSFX("chest.ogg")
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
        Level.load("map.lvlx")
    end
end