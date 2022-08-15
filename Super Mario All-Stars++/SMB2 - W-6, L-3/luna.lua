local level_dependencies_normal= require("level_dependencies_normal")

local nokeys = false
local nokeysexceptjump = false

function onEvent(eventName)
    if eventName == "Boss End (Part 2)" then
        nokeys = true
    end
    if eventName == "Boss End 2 (Part 2)" then
        Sound.playSFX(137)
    end
    if eventName == "Boss End 3 (Part 2)" then
        nokeys = false
    end
    if eventName == "World Clear 1" then
        nokeys = true
    end
    if eventName == "World Clear 2" then
        Sound.playSFX(4)
    end
    if eventName == "World Clear 4" then
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
        for _,p in ipairs(Player.get()) do
            p.upKeyPressing = false;
            p.downKeyPressing = false;
            p.leftKeyPressing = false;
            p.rightKeyPressing = false;
            p.altJumpKeyPressing = false;
            p.runKeyPressing = false;
            p.altRunKeyPressing = false;
            p.dropItemKeyPressing = false;
            p.jumpKeyPressing = false;
        end
    end
    if nokeysexceptjump then
        for _,p in ipairs(Player.get()) do
            p.upKeyPressing = false;
            p.downKeyPressing = false;
            p.leftKeyPressing = false;
            p.rightKeyPressing = false;
            p.altJumpKeyPressing = false;
            p.runKeyPressing = false;
            p.altRunKeyPressing = false;
            p.dropItemKeyPressing = false;
        end
    end
end