Graphics.activateHud(false)

function onTick()
    player.runKeyPressing = false;
    player.upKeyPressing = false;
    player.downKeyPressing = false;
    player.jumpKeyPressing = false;
    player.altJumpKeyPressing = false;
    player.altRunKeyPressing = false;
    player.dropItemKeyPressing = false;
    player.leftKeyPressing = false;
    player.rightKeyPressing = false;
    player.pauseKeyPressing = false;
    --Prevent donthurtme cheat, for obvious reasons
    Defines.cheat_donthurtme = used_donthurtme;
    used_donthurtme = nil;
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onEvent(eventName)
    if eventName == "ExitToMap2" then
        Level.load("map.lvlx")
    end
end

function onExit()
    Audio.MusicVolume(65)
end