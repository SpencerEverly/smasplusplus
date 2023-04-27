local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
    player.pauseKeyPressing = false;
end

function onEvent(eventName)
    if eventName == "getmushroom" then
        smasMapInventorySystem.addPowerUp(0, 1)
        Audio.MusicFadeOut(0, 1)
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
    if eventName == "getfire" then
        smasMapInventorySystem.addPowerUp(1, 1)
        Audio.MusicFadeOut(0, 1)
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
    if eventName == "getleaf" then
        smasMapInventorySystem.addPowerUp(2, 1)
        Audio.MusicFadeOut(0, 1)
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