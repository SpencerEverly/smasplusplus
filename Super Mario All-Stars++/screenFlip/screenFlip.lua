local screenFlip = {}

local handycam = require("handycam")
local cam1 = handycam[1]

local flip = 0
local fliptimer = 0
local flipphase = 0
local flipwarningopacity = 0

function screenFlip.onTick()
    if screenFlip.enabled then
        cam1.rotation = flip
        fliptimer = fliptimer + 1
        if screenFlip.warnBeforeFlip then
            if fliptimer == (screenFlip.flipDelay - 64) then --Warm before flipping
                flipwarningopacity = 0.65
                SFX.play("screenFlip/light.wav")
            elseif fliptimer >= (screenFlip.flipDelay - 64) then
                flipwarningopacity = flipwarningopacity - 0.03
            end
        end
        
        
        
        if fliptimer >= screenFlip.flipDelay and screenFlip.flipDirection >= 1 then --Start flipping
            SFX.play("screenFlip/flip.wav", 1, 1, 50)
            flip = flip + screenFlip.flipSpeed
            fliptimer = screenFlip.flipDelay
        elseif fliptimer >= screenFlip.flipDelay and screenFlip.flipDirection <= -1 then
            SFX.play("screenFlip/flip.wav", 1, 1, 50)
            flip = flip - screenFlip.flipSpeed
            fliptimer = screenFlip.flipDelay
        end
        
        
        
        if flip > 180 and flipphase == 0 then --Stop flipping
            flip = 180
            flipphase = 1
            fliptimer = 0
        elseif flip < -180 and flipphase == 0 then
            flip = -180
            flipphase = 1
            fliptimer = 0
        end
        if flip > 360 and flipphase == 1 then --Stop flipping again
            flip = 0
            flipphase = 0
            fliptimer = 0
        elseif flip < -360 and flipphase == 1 then
            flip = 0
            flipphase = 0
            fliptimer = 0
        end
        
        
    elseif screenFlip.enabledfourway then
        cam1.rotation = flip
        fliptimer = fliptimer + 1
        if screenFlip.warnBeforeFlip then
            if fliptimer == (screenFlip.flipDelay - 64) then --Warm before flipping
                flipwarningopacity = 0.65
                SFX.play("screenFlip/light.wav")
            elseif fliptimer >= (screenFlip.flipDelay - 64) then
                flipwarningopacity = flipwarningopacity - 0.03
            end
        end
        
        
        
        if fliptimer >= screenFlip.flipDelay and screenFlip.flipDirection >= 1 then --Start flipping
            SFX.play("screenFlip/flip.wav", 1, 1, 50)
            flip = flip + screenFlip.flipSpeed
            fliptimer = screenFlip.flipDelay
        elseif fliptimer >= screenFlip.flipDelay and screenFlip.flipDirection <= -1 then
            SFX.play("screenFlip/flip.wav", 1, 1, 50)
            flip = flip - screenFlip.flipSpeed
            fliptimer = screenFlip.flipDelay
        end
        
        
        
        
        if fliptimer >= screenFlip.flipDelay and screenFlip.flipDirection == 2 then
            SFX.play("screenFlip/flip.wav", 1, 1, 50)
            flipphase = 2
            flip = flip + screenFlip.flipSpeed
            fliptimer = screenFlip.flipDelay
        elseif fliptimer >= screenFlip.flipDelay and screenFlip.flipDirection >= 3 then
            SFX.play("screenFlip/flip.wav", 1, 1, 50)
            flipphase = 3
            flip = flip + screenFlip.flipSpeed
            fliptimer = screenFlip.flipDelay
        elseif fliptimer >= screenFlip.flipDelay and screenFlip.flipDirection <= -1 then
            SFX.play("screenFlip/flip.wav", 1, 1, 50)
            flip = flip - screenFlip.flipSpeed
            fliptimer = screenFlip.flipDelay
        end
        
        
        
        if flip > 90 and flipphase == 0 then --Stop flipping
            flip = 90
            flipphase = 1
            fliptimer = 0
        elseif flip < -90 and flipphase == 0 then
            flip = -90
            flipphase = 1
            fliptimer = 0
        end
        
        
        if flip > 180 and flipphase == 1 then --Stop flipping
            flip = 180
            flipphase = 2
            fliptimer = 0
        elseif flip < -180 and flipphase == 1 then
            flip = -180
            flipphase = 2
            fliptimer = 0
        end
        
        
        if flip > 270 and flipphase == 2 then --Stop flipping again
            flip = 270
            flipphase = 3
            fliptimer = 0
        elseif flip < -270 and flipphase == 2 then
            flip = -270
            flipphase = 3
            fliptimer = 0
        end
        
        
        if flip > 360 and flipphase == 3 then --Stop flipping again
            flip = 0
            flipphase = 0
            fliptimer = 0
        elseif flip < -360 and flipphase == 3 then
            flip = 0
            flipphase = 0
            fliptimer = 0
        end
    else
        cam1.rotation = 0
        flip = 0
        fliptimer = 0
        flipphase = 0
        flipwarningopacity = 0
    end
end

function screenFlip.onInputUpdate()
    if (flip == 90 or flip == -90) then
        local oldLeft = player.keys.left
        local oldRight = player.keys.right
        local oldUp = player.keys.up
        local oldDown = player.keys.down
        
        player.keys.up = oldLeft
        player.keys.down = oldRight
        player.keys.left = oldDown
        player.keys.right = oldUp
        if Player.count() >= 2 then
            local oldLeft2 = player2.keys.left
            local oldRight2 = player2.keys.right
            local oldUp2 = player2.keys.up
            local oldDown2 = player2.keys.down

            player2.keys.up = oldLeft2
            player2.keys.down = oldRight2
            player2.keys.left = oldDown2
            player2.keys.right = oldUp2
        end
    end
    if (flip == 180 or flip == -180) then
        local oldLeft = player.keys.left
        local oldUp = player.keys.up

        player.keys.left = player.keys.right
        player.keys.right = oldLeft
        player.keys.up = player.keys.down
        player.keys.down = oldUp
        if Player.count() >= 2 then
            local oldLeft2 = player2.keys.left
            local oldUp2 = player2.keys.up

            player2.keys.left = player2.keys.right
            player2.keys.right = oldLeft2
            player2.keys.up = player2.keys.down
            player2.keys.down = oldUp2
        end
    end
    if (flip == 270 or flip == -270) then
        local oldLeft = player.keys.right
        local oldRight = player.keys.left
        local oldUp = player.keys.down
        local oldDown = player.keys.up

        player.keys.up = oldLeft
        player.keys.down = oldRight
        player.keys.left = oldDown
        player.keys.right = oldUp
        if Player.count() >= 2 then
            local oldLeft2 = player2.keys.left
            local oldRight2 = player2.keys.right
            local oldUp2 = player2.keys.up
            local oldDown2 = player2.keys.down

            player2.keys.up = oldLeft2
            player2.keys.down = oldRight2
            player2.keys.left = oldDown2
            player2.keys.right = oldUp2
        end
    end
end

function screenFlip.onDraw()
    Graphics.drawScreen{color = Color.white .. flipwarningopacity, priority = 5}
    Text.printWP(lunatime.toSeconds(fliptimer), 340, 80, -4.3)
end

function screenFlip.onInitAPI()
    registerEvent(screenFlip, "onTick")
    registerEvent(screenFlip, "onDraw")
    registerEvent(screenFlip, "onInputUpdate")
end

--------------------------------
----Custom settings-------------
--------------------------------
screenFlip.enabled = true --Whenever the code is enabled (Classic 180 and back).
screenFlip.enabledfourway = false --Whenever the code is enabled (All four directions, don't stack this with what's above).
screenFlip.flipSpeed = 10 --How fast the screen rotates.
screenFlip.flipDirection = 1 --What direction the screen rotates.
screenFlip.flipDelay = 256 --How many frames it takes for the screen to rotate again.
screenFlip.warnBeforeFlip = true --Whenever the screen flashes white shortly before rotating.
--------------------------------
----Custom settings end here----
--------------------------------

return screenFlip