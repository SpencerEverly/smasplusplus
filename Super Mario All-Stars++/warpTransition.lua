--[[

    warpTransition.lua (v1.1.3)
    by MrDoubleA (Modded by Spencer Everly)

    See bottom of file for settings

]]

local playerManager = require("playerManager")
local extrasounds = require("extrasounds")

local warpTransition = {}

warpTransition.doorclose = extrasounds.sound.sfx[148]

warpTransition.currentTransitionType = nil
warpTransition.transitionTimer = 0

warpTransition.transitionIsFromLevelStart = false
warpTransition.currentWarp = nil


local RETURN_WARP_ADDR = 0x00B2C6D8
local STAR_COUNT_ADDR  = 0x00B251E0

local panCameraPosition

local customMusicPathsTbl = mem(0xB257B8, FIELD_DWORD)
local function getMusicPathForSection(section) -- thanks to Rednaxela for providing this function!
    return mem(customMusicPathsTbl + section*4, FIELD_STRING)
end

local function exitHasDifferentMusic(warp)
    if warpTransition.transitionIsFromLevelStart then
        return false
    elseif not warpTransition.currentWarp.isValid then
        return true
    end


    local entranceMusic = Section(warp.entranceSection).musicID
    local exitMusic     = Section(warp.exitSection).musicID

    return (
        warp.levelFilename ~= ""     -- Exits to another level3
        or warp:mem(0x84,FIELD_BOOL) -- Exits to world map
        or (entranceMusic ~= exitMusic)
        or (entranceMusic == 24 and exitMusic == 24 and getMusicPathForSection(warp.entranceSection) ~= getMusicPathForSection(warp.exitSection)) -- Both have custom music, but the files are different
    )
end


local buffer = Graphics.CaptureBuffer(800,600)
function warpTransition.applyShader(priority,shader,uniforms)
    buffer:captureAt(4)
    Graphics.drawScreen{texture = buffer,priority = 4,shader = shader,uniforms = uniforms}
end


-- Transition types
do
    warpTransition.TRANSITION_NONE = nil

    local function doorTransitionEffects()
        if warpTransition.currentWarp.isValid and warpTransition.currentWarp.warpType == 2 then
            player.frame = 1
            Sound.playSFX(148)
        end
    end
    function warpTransition.stopTransition()
        warpTransition.currentTransitionType = warpTransition.TRANSITION_NONE
        warpTransition.transitionTimer = 0
    
        warpTransition.transitionIsFromLevelStart = false
        warpTransition.currentWarp = nil
        Misc.unpause()
    end
    local function stopTransitionNoPuase()
        warpTransition.currentTransitionType = warpTransition.TRANSITION_NONE
        warpTransition.transitionTimer = 0
    
        warpTransition.transitionIsFromLevelStart = false
        warpTransition.currentWarp = nil
        Misc.unpause()
    end
    local function exitLevelLogic() -- Exit the level if the warp is set to do so
        if not warpTransition.currentWarp.isValid then return end

        if warpTransition.currentWarp.levelFilename ~= "" then
            Level.load(warpTransition.currentWarp.levelFilename,nil,warpTransition.currentWarp.warpNumber)
            mem(RETURN_WARP_ADDR,FIELD_WORD,player:mem(0x15E,FIELD_WORD))
        elseif warpTransition.currentWarp:mem(0x84,FIELD_BOOL) then
            player.forcedState = 8
            player.forcedTimer = 2921
        end
    end


    function warpTransition.TRANSITION_PAN()
        if panCameraPosition == nil then -- If the camera position isn't set
            panCameraPosition = vector(camera.x,camera.y)
        end

        local offset = vector((warpTransition.currentWarp.exitWidth/2),warpTransition.currentWarp.exitHeight)

        if warpTransition.currentWarp.warpType == 1 then -- Pipes
            if warpTransition.currentWarp.exitDirection == 1 then -- Down
                offset = vector((warpTransition.currentWarp.exitWidth/2),-8)
            elseif warpTransition.currentWarp.exitDirection == 2 then -- Right
                offset = vector((-player.width/2)-8,warpTransition.currentWarp.exitHeight)
            elseif warpTransition.currentWarp.exitDirection == 3 then -- Up
                offset = vector((warpTransition.currentWarp.exitWidth/2),warpTransition.currentWarp.exitHeight+8+player.height)
            elseif warpTransition.currentWarp.exitDirection == 4 then -- Left
                offset = vector(warpTransition.currentWarp.exitWidth+(player.width/2)+8,warpTransition.currentWarp.exitHeight)
            end
        end

        local targetPosition = vector(
            math.clamp(warpTransition.currentWarp.exitX+offset.x-(camera.width /2),player.sectionObj.boundary.left,player.sectionObj.boundary.right -camera.width ),
            math.clamp(warpTransition.currentWarp.exitY+offset.y-(camera.height/2),player.sectionObj.boundary.top ,player.sectionObj.boundary.bottom-camera.height)
        )

        local distance = vector(targetPosition.x-panCameraPosition.x,targetPosition.y-panCameraPosition.y)
        local speed = distance:normalise()*math.min(distance.length,warpTransition.transitionSpeeds[warpTransition.currentTransitionType])

        panCameraPosition = panCameraPosition + speed

        if panCameraPosition.x == targetPosition.x and panCameraPosition.y == targetPosition.y then -- The camera is in the right position
            warpTransition.stopTransition()
        end
    end


    function warpTransition.TRANSITION_FADE()
        warpTransition.transitionTimer = warpTransition.transitionTimer + 1.0

        local opacity = (warpTransition.transitionTimer/warpTransition.transitionSpeeds[warpTransition.currentTransitionType])
        local middle = math.floor(warpTransition.transitionSpeeds[warpTransition.currentTransitionType]*1.00)

        if warpTransition.transitionIsFromLevelStart then
            middle = 0
        end


        if warpTransition.transitionTimer == middle-1 and not warpTransition.transitionIsFromLevelStart then
            exitLevelLogic()
            player:mem(0x140,FIELD_WORD,100)
            Misc.unpause()
        elseif warpTransition.transitionTimer == middle+1 and not warpTransition.transitionIsFromLevelStart then
            doorTransitionEffects()
            Misc.pause(true)
        elseif warpTransition.transitionTimer > middle then
            opacity = 1.00-((warpTransition.transitionTimer-middle)/warpTransition.transitionSpeeds[warpTransition.currentTransitionType])

            if opacity <= 0 then
                warpTransition.stopTransition()
            end
        end

        Graphics.drawScreen{color = Color.black..opacity, priority = 6}


        return middle
    end


    local irisOutShader = Shader()
    irisOutShader:compileFromFile(nil,Misc.resolveFile("warpTransition_irisOut.frag"))
    function warpTransition.TRANSITION_IRIS_OUT()
        warpTransition.transitionTimer = warpTransition.transitionTimer + 1.4

        local startRadius = math.max(camera.width,camera.height)

        local radius = math.max(0,startRadius-(warpTransition.transitionTimer*warpTransition.transitionSpeeds[warpTransition.currentTransitionType]))
        local middle = math.floor((startRadius+100)/warpTransition.transitionSpeeds[warpTransition.currentTransitionType])

        if warpTransition.transitionIsFromLevelStart then
            middle = 0
        end
        

        if warpTransition.transitionTimer == middle-1 and not warpTransition.transitionIsFromLevelStart then
            exitLevelLogic()
            Misc.unpause()
        elseif warpTransition.transitionTimer == middle+1 and not warpTransition.transitionIsFromLevelStart then
            doorTransitionEffects()
            Misc.pause(true)
        elseif warpTransition.transitionTimer > middle then
            radius = (warpTransition.transitionTimer-middle)*warpTransition.transitionSpeeds[warpTransition.currentTransitionType]

            if radius > startRadius then
                warpTransition.stopTransition()
            end
        end

        warpTransition.applyShader(6,irisOutShader,{center = vector(player.x+(player.width/2)-camera.x,player.y+(player.height/2)-camera.y),radius = radius})


        return middle
    end

    
    local mosaicShader = Shader()
    mosaicShader:compileFromFile(nil,Misc.multiResolveFile("fuzzy_pixel.frag","shaders/npc/fuzzy_pixel.frag"))
    function warpTransition.TRANSITION_MOSAIC()
        warpTransition.transitionTimer = warpTransition.transitionTimer + 1

        local opacity = (warpTransition.transitionTimer/warpTransition.transitionSpeeds[warpTransition.currentTransitionType])
        local mosaic = (warpTransition.transitionTimer/(warpTransition.transitionSpeeds[warpTransition.currentTransitionType]/64))

        local middle = math.floor(warpTransition.transitionSpeeds[warpTransition.currentTransitionType]*0.01)

        if warpTransition.transitionIsFromLevelStart then
            middle = 0
        end


        if warpTransition.transitionTimer == middle-1 and not warpTransition.transitionIsFromLevelStart then
            exitLevelLogic()
            Misc.unpause()
        elseif warpTransition.transitionTimer == middle+1 and not warpTransition.transitionIsFromLevelStart then
            Misc.pause(true)
        elseif warpTransition.transitionTimer > middle then
            opacity = 1.35-((warpTransition.transitionTimer-middle)/warpTransition.transitionSpeeds[warpTransition.currentTransitionType])
            mosaic = (math.floor(warpTransition.transitionSpeeds[warpTransition.currentTransitionType]*1.35)/(warpTransition.transitionSpeeds[warpTransition.currentTransitionType]/64))-((warpTransition.transitionTimer-middle)/(warpTransition.transitionSpeeds[warpTransition.currentTransitionType]/64))

            if opacity <= 0 then
                warpTransition.stopTransition()
            end
        end

        Graphics.drawScreen{color = Color.black.. opacity,priority = 6}
        warpTransition.applyShader(6,mosaicShader,{pxSize = {camera.width/math.max(1,mosaic),camera.height/math.max(1,mosaic)}})


        return middle
    end


    function warpTransition.TRANSITION_CROSSFADE()
        warpTransition.transitionTimer = warpTransition.transitionTimer + 1

        if warpTransition.transitionTimer == 1 then
            exitLevelLogic()
            Misc.unpause()

            buffer:captureAt(0)
        end


        local opacity = 1-(warpTransition.transitionTimer/warpTransition.transitionSpeeds[warpTransition.currentTransitionType])

        if opacity <= 0 then
            warpTransition.stopTransition()
        end

        Graphics.drawScreen{texture = buffer,color = Color.white.. opacity,priority = 4}
    end


    local meltShader = Shader()
    meltShader:compileFromFile(nil,Misc.resolveFile("warpTransition_melt.frag"))
    function warpTransition.TRANSITION_MELT() -- It's the thing from doom :v
        warpTransition.transitionTimer = warpTransition.transitionTimer + 1

        if warpTransition.transitionTimer == 1 then
            exitLevelLogic()
            Misc.unpause()

            buffer:captureAt(0)
        end


        local rng = RNG.new(1)

        local yOffsets = {}
        local done = true

        for i=0,camera.width-1 do
            yOffsets[i] = math.max(0,(warpTransition.transitionTimer/warpTransition.transitionSpeeds[warpTransition.currentTransitionType])-rng:random(0,0.2))

            done = (done and yOffsets[i] > 1)
        end

        if done then
            warpTransition.stopTransition()
        end

        Graphics.drawScreen{texture = buffer,priority = 0,shader = meltShader,uniforms = {yOffsets = yOffsets}}
    end


    function warpTransition.TRANSITION_SWIRL()
        warpTransition.transitionTimer = warpTransition.transitionTimer + 1


        local middle = math.floor(warpTransition.transitionSpeeds[warpTransition.currentTransitionType]*1.1)
        local endPoint = (middle*2)

        local progress = (warpTransition.transitionTimer/warpTransition.transitionSpeeds[warpTransition.currentTransitionType])

        if warpTransition.transitionIsFromLevelStart then
            endPoint = (endPoint/2)
            middle = 0
        end
        

        if warpTransition.transitionTimer == middle-1 and not warpTransition.transitionIsFromLevelStart then
            exitLevelLogic()
            Misc.unpause()
        elseif warpTransition.transitionTimer == middle+1 and not warpTransition.transitionIsFromLevelStart then
            doorTransitionEffects()
            Misc.pause(true)
        elseif warpTransition.transitionTimer > middle then
            progress = ((endPoint-warpTransition.transitionTimer)/warpTransition.transitionSpeeds[warpTransition.currentTransitionType])

            if progress < 0 then
                warpTransition.stopTransition()
            end
        end


        progress = math.min(1,progress)

        for i=0,progress,0.0015 do
            local personalProgress = (i*512)
            local position = vector(0,(-math.max(camera.width,camera.height)/1.5)+(personalProgress/1)):rotate(personalProgress*4) --vector(0,(-math.max(camera.width,camera.height)/2)+(i*middle))

            position = position + vector(camera.width/2,camera.height/2)

            Graphics.drawCircle{
                x = position.x,y = position.y,radius = 48,
                color = Color.black,priority = 6,
            }
        end


        return middle
    end
end


function warpTransition.onInitAPI()
    registerEvent(warpTransition,"onStart")
    registerEvent(warpTransition,"onExitLevel")

    registerEvent(warpTransition,"onTick")
    registerEvent(warpTransition,"onCameraDraw")

    registerEvent(warpTransition,"onCameraUpdate")
end

function warpTransition.onStart()
    if SMBX_VERSION < VER_BETA4_PATCH_2_1 then
        error("You currently have an outdated version of SMBX2. To use warpTransition, you need at least the patch 2 hotfix. You can download the latest version at: http://codehaus.wohlsoft.ru/downloads.php")
    end


    if warpTransition.levelStartTransition ~= warpTransition.TRANSITION_NONE then
        warpTransition.currentTransitionType = warpTransition.levelStartTransition
        warpTransition.transitionTimer = 0

        warpTransition.transitionIsFromLevelStart = true

        -- Prevent the long wait when starting from a warp
        warpTransition.currentWarp = Warp(player:mem(0x15E,FIELD_WORD)-1)

        if warpTransition.currentWarp and warpTransition.currentWarp.isValid then
            if warpTransition.currentWarp.warpType == 1 then -- Pipes
                player.forcedTimer = 901
            else -- Doors
                player.forcedState = 0
                player.forcedTimer = 0
            end
        end
    end
end

function warpTransition.onExitLevel()
    -- Music volume doesn't reset when restarting a level, so here's a fix
    if Audio.MusicVolume() == 0 then
        Audio.MusicVolume(65)
    end
end



local instantWarps = table.map{0,3}
function warpTransition.onTick()
    if warpTransition.currentTransitionType ~= warpTransition.TRANSITION_NONE then return end


    if player.forcedState == 3 and player.forcedTimer == 1 or player.forcedState == 7 and player.forcedTimer == 29 then
        warpTransition.currentWarp = Warp(player:mem(0x15E,FIELD_WORD)-1)
    elseif player:mem(0x15C,FIELD_WORD) == 0 and warpTransition.activateOnInstantWarps then
        -- Instant/portal warps

        -- Sorta janky fix for ducking
        local playerSettings = PlayerSettings.get(playerManager.getBaseID(player.character),player.powerup)

        local x = (player.x+(player.speedX*1.5))
        local y = (player.y+(player.speedY*1.5))

        if player:mem(0x12E,FIELD_BOOL) and not player.keys.down then
            y = (y+player.height-playerSettings.hitboxHeight)
        end


        for _,warp in ipairs(Warp.getIntersectingEntrance(x,y,x+player.width,y+player.height)) do
            if instantWarps[warp.warpType] and not warp.isHidden and not warp.fromOtherLevel
            and (not warp.locked or (player.holdingNPC ~= nil and player.holdingNPC.id == 31))
            and (warp.starsRequired <= mem(STAR_COUNT_ADDR,FIELD_WORD))
            then
                -- Make sure the player goes in
                player.x = x
                player.y = y

                warpTransition.currentWarp = warp
            end
        end
    end

    if warpTransition.currentWarp ~= nil then
        if warpTransition.currentWarp.isValid and warpTransition.currentWarp.entranceSection == warpTransition.currentWarp.exitSection and warpTransition.currentWarp.levelFilename == "" and not warpTransition.currentWarp:mem(0x84,FIELD_BOOL) then
            warpTransition.currentTransitionType = warpTransition.sameSectionTransition
        else
            warpTransition.currentTransitionType = warpTransition.crossSectionTransition
        end

        if warpTransition.currentTransitionType ~= warpTransition.TRANSITION_NONE then
            warpTransition.transitionTimer = 0
            Misc.pause()
        end
    end
end

function warpTransition.onCameraDraw(camIdx)
    -- Transition effects
    local middle = 0 -- Middle point for the transition

    if warpTransition.currentTransitionType ~= warpTransition.TRANSITION_NONE then
        middle = warpTransition.currentTransitionType()

        
        if warpTransition.transitionIsFromLevelStart and not Misc.isPaused() and lunatime.tick() > 1 then
            Misc.pause(true)
        end

        if warpTransition.currentTransitionType ~= warpTransition.TRANSITION_NONE and warpTransition.musicFadeOut and exitHasDifferentMusic(warpTransition.currentWarp) then
            -- Music fade out
            if (middle ~= nil and middle ~= 0) and warpTransition.transitionTimer < middle then
                smasbooleans.overrideMusicVolume = true
                Audio.MusicVolume(math.max(0,Audio.MusicVolume()-math.ceil(56/(middle-12))))
            elseif Audio.MusicVolume() == 0 then
                Audio.MusicVolume(56)
            end
        end
    end
end

function warpTransition.onCameraUpdate()
    if panCameraPosition ~= nil then
        camera.x,camera.y = panCameraPosition.x,panCameraPosition.y

        if warpTransition.currentTransitionType ~= warpTransition.TRANSITION_PAN then -- If the transition is finished
            panCameraPosition = nil
        end
    end
end


-- The type of transition used when using a warp that leads to somewhere else in the same section. Can be 'warpTransition.TRANSITION_NONE', 'warpTransition.TRANSITION_FADE', 'warpTransition.TRANSITION_PAN', 'warpTransition.TRANSITION_IRIS_OUT', 'warpTransition.TRANSITION_MOSAIC', 'warpTransition.TRANSITION_CROSSFADE', 'warpTransition.TRANSITION_MELT', or 'warpTransition.TRANSITION_SWIRL'.
warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
-- The type of transition used when using a warp that leads to a different section. Can be 'warpTransition.TRANSITION_NONE', 'warpTransition.TRANSITION_FADE', 'warpTransition.TRANSITION_IRIS_OUT', 'warpTransition.TRANSITION_MOSAIC', 'warpTransition.TRANSITION_CROSSFADE', 'warpTransition.TRANSITION_MELT', or 'warpTransition.TRANSITION_SWIRL'.
warpTransition.crossSectionTransition = warpTransition.TRANSITION_FADE

-- The type of transition used when entering the level. Can be 'warpTransition.TRANSITION_NONE', 'warpTransition.TRANSITION_FADE', 'warpTransition.TRANSITION_IRIS_OUT', 'warpTransition.TRANSITION_MOSAIC', or 'warpTransition.TRANSITION_SWIRL'.
warpTransition.levelStartTransition = warpTransition.TRANSITION_FADE


warpTransition.transitionSpeeds = {
    [warpTransition.TRANSITION_FADE     ] = 24, -- How long it takes to fade in/out.
    [warpTransition.TRANSITION_PAN      ] = 12, -- How fast the camera pan is.
    [warpTransition.TRANSITION_IRIS_OUT ] = 14, -- How quickly the radius of the iris out shrinks.
    [warpTransition.TRANSITION_MOSAIC   ] = 24, -- How long it takes to fade in/out.
    [warpTransition.TRANSITION_CROSSFADE] = 24, -- How long it takes to fade in/out.
    [warpTransition.TRANSITION_MELT     ] = 64, -- How long it takes one "slice" to go down.
    [warpTransition.TRANSITION_SWIRL    ] = 96, -- How many frames it takes to complete the transition.
}

-- Whether or not transitions can be activated by 'insant' and 'portal' warps.
warpTransition.activateOnInstantWarps = false

-- Whether or not the music will fade out when travelling between sections with different music.
warpTransition.musicFadeOut = false

return warpTransition