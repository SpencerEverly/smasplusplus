local smasCharacterIntros = {}

local portalopenergfx = Graphics.loadImageResolved("costumes/mario/GO-10SecondRun/openingportal.png")
local portalopengfx = Graphics.loadImageResolved("costumes/mario/GO-10SecondRun/portalopen.png")
local countdown3gfx = Graphics.loadImageResolved("costumes/mario/GO-10SecondRun/countdown-3.png")
local countdown2gfx = Graphics.loadImageResolved("costumes/mario/GO-10SecondRun/countdown-2.png")
local countdown1gfx = Graphics.loadImageResolved("costumes/mario/GO-10SecondRun/countdown-1.png")
local countdowngogfx = Graphics.loadImageResolved("costumes/mario/GO-10SecondRun/countdown-go.png")

local warpTransition = require("warpTransition")
local playerManager = require("playerManager")
local Routine = require("routine")

function smasCharacterIntros.onInitAPI()
    registerEvent(smasCharacterIntros,"onStart")
    registerEvent(smasCharacterIntros,"onDraw")
end

smasCharacterIntros.animationactive = false --This is used to animate the intro

local dontshowplayer = false

local portalopen1 = false
local portalopen2 = false
local portalopen3 = false
local portalopened = false
local falldownplayer = false
local playerlanded = false
local playerstance = false
local threetext = false
local twotext = false
local onetext = false
local gotext = false

local fallernumber = 24
local opacitycountdown = 1
local opacitycountdown2 = 1
local opacitycountdown3 = 1
local opacitycountdown4 = 1

local playerwhooshpacman = false
local playerwhooshpacman2 = false
local playerwhooshpacman3 = false
local playerwhooshpacman4 = false

local playerstancepacman = false
local playerstancepacman2 = false

local characters = {}

local character = player.character;
local costumes = playerManager.getCostumes(player.character)
local currentCostume = player:getCostume()

local costumes

function smasCharacterIntros.onStart()
    if not smasBooleans.isOnMainMenu then
        pauseplus = require("pauseplus")
    end
    local characters = {}
    
    local character = player.character;
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()

    local costumes
    if SaveData.toggleCostumeAbilities == true then
        if SaveData.SMASPlusPlus.options.enableIntros then
            if table.icontains(smasTables._noLevelPlacesPlusOtherLevels,Level.filename()) == false then
                console:println("Character intro will now be played.")
                if SaveData.SMASPlusPlus.player[1].currentCostume == "GO-10SECONDRUN" then
                    Routine.run(tensecondrunstartinganimation)
                    pauseplus.canPause = false
                elseif SaveData.SMASPlusPlus.player[1].currentCostume == "PACMAN-ARRANGEMENT-PACMAN" then
                    Routine.run(pacmanstartinganimation)
                    pauseplus.canPause = false
                end
            end
        end
    end
end

function smasCharacterIntros.onDraw()
    if SaveData.toggleCostumeAbilities == true then
        if SaveData.SMASPlusPlus.player[1].currentCostume == "GO-10SECONDRUN" then
            if SaveData.SMASPlusPlus.options.enableIntros == true then
                if smasCharacterIntros.animationactive == true then
                    --Invisible player
                    if dontshowplayer then
                        player:setFrame(50)
                    else
                        player:setFrame(nil)
                    end
                    --Portal opener
                    if portalopen1 then
                        Graphics.drawImageToSceneWP(portalopenergfx, Playur.startPointCoordinateX(1) - 14, Playur.startPointCoordinateY(1) - 120, 0, 0, 24, 46, 1, -24)
                    end
                    if portalopen2 then
                        Graphics.drawImageToSceneWP(portalopenergfx, Playur.startPointCoordinateX(1) - 14, Playur.startPointCoordinateY(1) - 120, 0, 46, 24, 46, 1, -24)
                    end
                    if portalopen3 then
                        Graphics.drawImageToSceneWP(portalopenergfx, Playur.startPointCoordinateX(1) - 14, Playur.startPointCoordinateY(1) - 120, 0, 92, 24, 46, 1, -24)
                    end
                    if portalopened then
                        Graphics.drawImageToSceneWP(portalopengfx, Playur.startPointCoordinateX(1) - 14, Playur.startPointCoordinateY(1) - 128, 0, 0, 24, 54, 1, -24)
                    end
                    if falldownplayer then
                        fallernumber = fallernumber + 3
                        player:render{frame = 5, x = Playur.startPointCoordinateX(1) - 12, y = Playur.startPointCoordinateY(1) - 148 + fallernumber, priority = -25, powerup = 2}
                    end
                    if playerlanded then
                        fallernumber = 0
                        player:render{frame = 7, x = Playur.startPointCoordinateX(1) - 12, y = Playur.startPointCoordinateY(1) - 28, priority = -25, powerup = 2}
                    end
                    if playerstance then
                        player:render{frame = 1, x = Playur.startPointCoordinateX(1) - 12, y = Playur.startPointCoordinateY(1) - 28, priority = -25, powerup = 2}
                    end
                    if threetext then
                        opacitycountdown = opacitycountdown - 0.02
                        Graphics.drawImageWP(countdown3gfx, 322, 176, opacitycountdown, -4)
                    end
                    if twotext then
                        opacitycountdown2 = opacitycountdown2 - 0.02
                        Graphics.drawImageWP(countdown2gfx, 314, 174, opacitycountdown2, -4)
                    end
                    if onetext then
                        opacitycountdown3 = opacitycountdown3 - 0.02
                        Graphics.drawImageWP(countdown1gfx, 357, 179, opacitycountdown3, -4)
                    end
                    if gotext then
                        opacitycountdown4 = opacitycountdown4 - 0.02
                        Graphics.drawImageWP(countdowngogfx, 339, 272, opacitycountdown4, -4)
                    end
                end
            end
        elseif SaveData.SMASPlusPlus.player[1].currentCostume == "PACMAN-ARRANGEMENT-PACMAN" then
            if SaveData.SMASPlusPlus.options.enableIntros == true then
                if smasCharacterIntros.animationactive == true then
                    --Invisible player
                    if dontshowplayer then
                        player:setFrame(50)
                    else
                        player:setFrame(nil)
                    end
                    if playerwhooshpacman then
                        player:render{frame = 1, direction = 1, x = Playur.startPointCoordinateX(1) - 12, y = Playur.startPointCoordinateY(1) - 28, priority = -25}
                    end
                    if playerwhooshpacman2 then
                        player:render{frame = 15, direction = 1, x = Playur.startPointCoordinateX(1) - 12, y = Playur.startPointCoordinateY(1) - 28, priority = -25}
                    end
                    if playerwhooshpacman3 then
                        player:render{frame = 1, direction = -1, x = Playur.startPointCoordinateX(1) - 12, y = Playur.startPointCoordinateY(1) - 28, priority = -25}
                    end
                    if playerwhooshpacman4 then
                        player:render{frame = 13, direction = 1, x = Playur.startPointCoordinateX(1) - 12, y = Playur.startPointCoordinateY(1) - 28, priority = -25}
                    end
                    if playerstancepacman then
                        player:render{frame = 2, direction = 1, x = Playur.startPointCoordinateX(1) - 12, y = Playur.startPointCoordinateY(1) - 28, priority = -25}
                    end
                    if playerstancepacman2 then
                        player:render{frame = 3, direction = 1, x = Playur.startPointCoordinateX(1) - 12, y = Playur.startPointCoordinateY(1) - 28, priority = -25}
                    end
                end
            end
        end
    end
end

function pacmanstartinganimation()
    Routine.wait(0.1, true)
    Sound.muteMusic(-1)
    smasCharacterIntros.animationactive = true
    dontshowplayer = true
    playerwhooshpacman = false
    Sound.playSFX("toad/PacMan-Arrangement-PacMan/level-starting.ogg")
    Routine.wait(0.3, true)
    Misc.pause()
    
    
    --Spinning
    playerwhooshpacman = true
    Routine.waitFrames(5, true)
    playerwhooshpacman = false
    playerwhooshpacman2 = true
    Routine.waitFrames(5, true)
    playerwhooshpacman2 = false
    playerwhooshpacman3 = true
    Routine.waitFrames(5, true)
    playerwhooshpacman3 = false
    playerwhooshpacman4 = true
    Routine.waitFrames(5, true)
    playerwhooshpacman4 = false
    playerwhooshpacman = true
    Routine.waitFrames(5, true)
    playerwhooshpacman = false
    playerwhooshpacman2 = true
    Routine.waitFrames(5, true)
    playerwhooshpacman2 = false
    playerwhooshpacman3 = true
    Routine.waitFrames(5, true)
    playerwhooshpacman3 = false
    playerwhooshpacman4 = true
    Routine.waitFrames(5, true)
    playerwhooshpacman4 = false
    playerwhooshpacman = true
    Routine.waitFrames(5, true)
    playerwhooshpacman = false
    playerwhooshpacman2 = true
    Routine.waitFrames(5, true)
    playerwhooshpacman2 = false
    playerwhooshpacman3 = true
    Routine.waitFrames(5, true)
    playerwhooshpacman3 = false
    playerwhooshpacman4 = true
    Routine.waitFrames(5, true)
    playerwhooshpacman4 = false
    playerwhooshpacman = true
    
    
    --Bounce
    Routine.waitFrames(10, true)
    playerwhooshpacman = false
    playerstancepacman = true
    Routine.waitFrames(10, true)
    playerstancepacman = false
    playerstancepacman2 = true
    Routine.waitFrames(10, true)
    playerstancepacman2 = false
    playerstancepacman = true
    Routine.waitFrames(10, true)
    playerstancepacman = false
    playerwhooshpacman = true
    
    
    Routine.wait(2.5, true)
    Misc.unpause()
    playerwhooshpacman = false
    dontshowplayer = false
    Sound.restoreMusic(-1)
    smasCharacterIntros.animationactive = false
    pauseplus.canPause = true
end

function tensecondrunstartinganimation()
    Routine.wait(0.1, true)
    Sound.muteMusic(-1)
    smasCharacterIntros.animationactive = true
    dontshowplayer = true
    Routine.wait(0.3, true)
    Misc.pause()
    SFX.play("costumes/mario/GO-10SecondRun/countdown/entrance.ogg")
    Routine.waitFrames(10, true)
    portalopen1 = true
    Routine.waitFrames(10, true)
    portalopen1 = false
    portalopen2 = true
    Routine.waitFrames(10, true)
    portalopen2 = false
    portalopen3 = true
    Routine.waitFrames(10, true)
    portalopen3 = false
    portalopened = true
    Routine.waitFrames(10, true)
    falldownplayer = true
    Routine.waitFrames(33, true)
    falldownplayer = false
    playerlanded = true
    Routine.waitFrames(17, true)
    playerlanded = false
    playerstance = true
    Routine.waitFrames(8, true)
    portalopened = false
    portalopen3 = true
    Routine.waitFrames(3, true)
    portalopen3 = false
    portalopen2 = true
    Routine.waitFrames(3, true)
    portalopen2 = false
    portalopen1 = true
    Routine.waitFrames(3, true)
    portalopen1 = false
    SFX.play("costumes/mario/GO-10SecondRun/countdown/countdown.ogg")
    threetext = true
    Routine.wait(1, true)
    SFX.play("costumes/mario/GO-10SecondRun/countdown/countdown.ogg")
    threetext = false
    twotext = true
    Routine.wait(1, true)
    SFX.play("costumes/mario/GO-10SecondRun/countdown/countdown.ogg")
    twotext = false
    onetext = true
    Routine.wait(1, true)
    SFX.play("costumes/mario/GO-10SecondRun/countdown/start-course.ogg")
    onetext = false
    Misc.unpause()
    gotext = true
    dontshowplayer = false
    playerstance = false
    Sound.restoreMusic(-1)
    Routine.wait(2, true)
    gotext = false
    smasCharacterIntros.animationactive = false
    pauseplus.canPause = true
end

return smasCharacterIntros