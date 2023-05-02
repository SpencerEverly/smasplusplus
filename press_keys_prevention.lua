function(onStart)


function onEvent(eventName)
    if eventName == "Insert name here" then
    
    end
end

function onInputUpdate(cutsceneKeyPrevention)
    if(player.leftKeyPressing) then
        player.leftKeyPressing = false
    end
    if(player.rightKeyPressing) then
        player.rightKeyPressing = false
    end
    if(player.upKeyPressing) then
        player.upKeyPressing = false
    end
    if(player.downKeyPressing) then
        player.downKeyPressing = false
    end
    if(player.downKeyPressing) then
        player.jumpKeyPressing = false
    end
    if(player.altJumpKeyPressing) then
        player.altJumpKeyPressing = false
    end
    if(player.runKeyPressing) then
        player.runKeyPressing = false
    end
    if(player.altRunKeyPressing) then
        player.altRunKeyPressing = false
    end
    if(player.pauseKeyPressing) then
        player.pauseKeyPressing = false
    end
    if(player.dropItemKeyPressing) then
        player.dropItemKeyPressing = false
    end
end

function onInputUpdate(cutsceneEnd)
    if(player.leftKeyPressing) then
        player.leftKeyPressing = true
    end
    if(player.rightKeyPressing) then
        player.rightKeyPressing = true
    end
    if(player.upKeyPressing) then
        player.upKeyPressing = true
    end
    if(player.downKeyPressing) then
        player.downKeyPressing = true
    end
    if(player.downKeyPressing) then
        player.jumpKeyPressing = true
    end
    if(player.altJumpKeyPressing) then
        player.altJumpKeyPressing = true
    end
    if(player.runKeyPressing) then
        player.runKeyPressing = true
    end
    if(player.altRunKeyPressing) then
        player.altRunKeyPressing = true
    end
    if(player.pauseKeyPressing) then
        player.pauseKeyPressing = true
    end
    if(player.dropItemKeyPressing) then
        player.dropItemKeyPressing = true
    end
end

--For events that require the player to stay still. To revert set everything to true