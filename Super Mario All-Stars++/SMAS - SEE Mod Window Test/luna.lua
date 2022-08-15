local flyy = 0
local flying = false
local timer = 0.06

function onStart()
    if SMBX_VERSION == VER_SEE_MOD then
        Routine.run(chachaslide)
    else
        Sound.playSFX("wrong.ogg")
    end
end

function onTick()
    if flying then
        
    end
end

function chachaslide()
    Misc.centerWindow()
    Routine.wait(5.8, true)
    Misc.setWindowPosition(Misc.getWindowXPosition() - 80, Misc.getWindowYPosition())
    Routine.wait(1.8, true)
    Misc.setWindowPosition(Misc.getWindowXPosition() + 80, Misc.getWindowYPosition())
    Routine.wait(1.6, true)
    Misc.setWindowPosition(Misc.getWindowXPosition(), Misc.getWindowYPosition() - 50)
    Routine.wait(0.4, true)
    Misc.setWindowPosition(Misc.getWindowXPosition(), Misc.getWindowYPosition() + 50)
end

function windowflying()
    Routine.waitFrames(35, true)
    Misc.centerWindow()
    Misc.setWindowPosition(Misc.getWindowXPosition() - 10, Misc.getWindowYPosition() - 15)
    Routine.waitFrames(1, true)
    Misc.setWindowPosition(Misc.getWindowXPosition() + 10, Misc.getWindowYPosition() + 12)
    Routine.waitFrames(1, true)
    Misc.setWindowPosition(Misc.getWindowXPosition() + 9, Misc.getWindowYPosition() - 11)
    Routine.waitFrames(1, true)
    Misc.setWindowPosition(Misc.getWindowXPosition() - 8, Misc.getWindowYPosition() + 10)
    Routine.waitFrames(1, true)
    Misc.centerWindow()
end