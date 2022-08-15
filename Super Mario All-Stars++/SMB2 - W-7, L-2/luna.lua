local level_dependencies_normal= require("level_dependencies_normal")

local nokeys = false
local nokeysexceptjump = false

function onEvent(eventName)
    if eventName == "BossBegin" then
        Sound.changeMusic("_OST/Super Mario Bros 2/King Wart.ogg", 1)
    end
    if eventName == "Boss End" then
        nokeys = true
    end
    if eventName == "Boss End 2" then
        Sound.playSFX(137)
    end
    if eventName == "Boss End 3" then
        nokeys = false
    end
    if eventName == "Subcons Saved Part 2" then
        nokeys = true
    end
    if eventName == "Subcons Saved Part 3" then
        nokeys = false
        nokeysexceptjump = true
    end
    if eventName == "Subcons Saved Part 4" then
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
        if Player.count() >= 2 then
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
        if Player.count() >= 2 then
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