--mapTransition
--Based off mapTransition by MrDoubleA
--Coded by Spencer Everly

local mapTransition = {}

mapTransition.currentTransitionType = nil
mapTransition.transitionTimer = 0

function loadlevel()
    Misc.pause()
    if player.keys.left == KEYS_PRESSED then
        player.keys.left = KEYS_UNPRESSED
    elseif player.keys.right == KEYS_PRESSED then
        player.keys.right = KEYS_UNPRESSED
    end
    Sound.playSFX("levelload.ogg")
    Routine.wait(1.5)
    Misc.unpause()
end

do
    mapTransition.TRANSITION_NONE = nil
    
    local irisOutShader = Shader()
    irisOutShader:compileFromFile(nil,Misc.resolveFile("mapTransition_irisOut.frag"))
    function mapTransition.TRANSITION_IRIS_OUT()
        mapTransition.transitionTimer = mapTransition.transitionTimer + 1.4

        local startRadius = math.max(camera.width,camera.height)

        local radius = math.max(0,startRadius-(mapTransition.transitionTimer*mapTransition.transitionSpeeds[mapTransition.currentTransitionType]))
        local middle = math.floor((startRadius+100)/mapTransition.transitionSpeeds[mapTransition.currentTransitionType])

        if mapTransition.transitionTimer == middle-1 then
            Misc.unpause()
        elseif mapTransition.transitionTimer == middle+1 then
            world.playerCurrentDirection(3)
            if (middle ~= nil and middle ~= 0) and mapTransition.transitionTimer < middle then
                Audio.MusicVolume(math.max(0,Audio.MusicVolume()-math.ceil(56/(middle-12))))
            elseif Audio.MusicVolume() == 0 then
                Audio.MusicVolume(56)
            end
            
            Misc.pause()
        elseif mapTransition.transitionTimer > middle then
            radius = (mapTransition.transitionTimer-middle)*mapTransition.transitionSpeeds[mapTransition.currentTransitionType]

            if radius > startRadius then
                stopTransition()
            end
        end

        mapTransition.applyShader(6,irisOutShader,{center = vector(player.x+(player.width/2)-camera.x,player.y+(player.height/2)-camera.y),radius = radius})


        return middle
    end
end

function mapTransition.onInitAPI()
    registerEvent(mapTransition,"onStart")
    registerEvent(mapTransition,"onTick")
    registerEvent(mapTransition,"onExit")
end

function mapTransition.onTick()
    if world.levelObj(title) and player.keys.jump == KEYS_PRESSED then
        Routine.run(loadlevel)
    end
end

function mapTransition.onExit()
    -- Music volume doesn't reset, so here's a fix
    if Audio.MusicVolume() == 0 then
        Audio.MusicVolume(56)
    end
end


