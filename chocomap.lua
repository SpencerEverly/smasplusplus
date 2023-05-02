local chocoMap = {}

if not isOverworld then return chocoMap end

local textParser = require("configFileReader")
local switchpalace = require("game/switchpalace")

chocoMap.tiles = {}
chocoMap.scenery = {}
chocoMap.paths = {}
chocoMap.levels = {}

--thank you redigit
chocoMap.levels.LEVEL0 = {}

chocoMap.cameraBoundaries = {}

--changing these 4 will only have an effect if you do so right here
chocoMap.TILE_PRIORITY = 1
chocoMap.SCENERY_PRIORITY = 1
chocoMap.PATH_PRIORITY = 2
chocoMap.LEVEL_PRIORITY = 2

--these can be changed whenever
chocoMap.PLAYER_PRIORITY = 3
chocoMap.HUD_PRIORITY = 3

chocoMap.defaultConfigs = {}
chocoMap.defaultConfigs.tiles = {}
chocoMap.defaultConfigs.scenery = {}
chocoMap.defaultConfigs.paths = {}
chocoMap.defaultConfigs.levels = {}

chocoMap.tiles.maxID = 400
chocoMap.tiles.filePrefix = "tile-"
chocoMap.tiles.defaultConfig = "tiles"
chocoMap.tiles.frameTable = {}

chocoMap.scenery.maxID = 100
chocoMap.scenery.filePrefix = "scene-"
chocoMap.scenery.defaultConfig = "scenery"
chocoMap.scenery.frameTable = {}

chocoMap.paths.maxID = 100
chocoMap.paths.filePrefix = "path-"
chocoMap.paths.defaultConfig = "paths"
chocoMap.paths.frameTable = {}

chocoMap.levels.maxID = 100
chocoMap.levels.filePrefix = "level-"
chocoMap.levels.defaultConfig = "levels"
chocoMap.levels.frameTable = {}
chocoMap.levels.frameTable.LEVEL0 = 0

local pauseX = 210
local pauseY = 200
local pauseW = 380
local pauseH = 200

local pauseSelector = Graphics.loadImage(Misc.resolveGraphicsFile("hardcoded-34-0.png"))

local pauseXOffset = 42
local pauseYOffset = 57
local pauseXOffsetCheat = 56
local pauseYOffsetCheat = 15

local pauseXSpacing = 4
local pauseYSpacing = 35

local SCRWIDTH = 800
local SCRHEIGHT = 600

local drawTick = 0
local camCount = 1

local playerSprite

local function ___setConfig(tbl, id, w, h, f, fs)
    chocoMap.defaultConfigs[tbl][id] = {
        width = w or chocoMap.defaultConfigs[tbl][id].width,
        height = h or chocoMap.defaultConfigs[tbl][id].height,
        frames = f or chocoMap.defaultConfigs[tbl][id].frames,
        framespeed = fs or chocoMap.defaultConfigs[tbl][id].framespeed,
        priority = chocoMap.defaultConfigs[tbl][id].priority
    }
end

local function switchPalace(id)
    return id >= 33 and id <= 36
end

local function sceneryActive(idx)
    return mem(mem(0x00B2592C, FIELD_DWORD) + (0x34 * idx) + 0x32, FIELD_WORD) ~= 0
end

local function switchPalacePressed(id)
    return SaveData._basegame.bigSwitch[switchpalace.colors[id]]
end

local function initTable(tbl)
    for instID = 1, tbl.maxID do
        tbl[instID] = {}
        
        tbl[instID].texture = Graphics.loadImage(Misc.resolveGraphicsFile(tbl.filePrefix..tostring(instID)..".png"))
        local configTable = textParser.parseTxt(tbl.filePrefix..tostring(instID)..".txt")
        
        tbl[instID].config = chocoMap.defaultConfigs[tbl.defaultConfig][instID]
        if(configTable) then
            for key, value in pairs(configTable) do
                tbl[instID].config[key] = tonumber(value)
            end
        end
        
        if(not (tbl == "levels" and switchPalace(instID))) then tbl.frameTable[instID] = 0 end
    end
end

local function init()
    initTable(chocoMap.tiles)
    initTable(chocoMap.scenery)
    initTable(chocoMap.paths)
    initTable(chocoMap.levels)
    
    chocoMap.setSwitchPalaceAnim()
    
    chocoMap.levels.LEVEL0.texture = Graphics.loadImage(Misc.resolveGraphicsFile("level-0.png"))
    chocoMap.levels.LEVEL0.config = {
        width = 32,
        height = 32,
        frames = 1,
        framespeed = 8,
        priority = chocoMap.LEVEL_PRIORITY
    }
    
    local configTable = textParser.parseTxt("level-0.txt")
    if(configTable) then
        for key, value in pairs(configTable) do
            chocoMap.levels.LEVEL0.config[key] = tonumber(value)
        end
    end
end

local function check_range(a, b, c)
    return a >= b and a <= c
end

local function isVisible(x, y, w, h)
    local cCam = Camera.get()[1]
    
    return (check_range(x, cCam.x, cCam.x + SCRWIDTH) or check_range(cCam.x, x, x + w)) and (check_range(y, cCam.y, cCam.y + SCRHEIGHT) or check_range(cCam.y, y, y + h))
end

function chocoMap.onInitAPI()

    for tileID = 1, chocoMap.tiles.maxID do
        chocoMap.defaultConfigs.tiles[tileID] = {
            width = 32,
            height = 32,
            frames = 1,
            framespeed = 8,
            priority = chocoMap.TILE_PRIORITY
        }
    end
    
    ___setConfig("tiles", 8, 64, 64, nil, nil)
    ___setConfig("tiles", 9, 96, 96, nil, nil)
    ___setConfig("tiles", 12, 64, 64, nil, nil)
    ___setConfig("tiles", 13, 96, 96, nil, nil)
    ___setConfig("tiles", 14, nil, nil, 4, 16)
    ___setConfig("tiles", 27, 128, 128, 4, 16)
    ___setConfig("tiles", 325, 64, 64, nil, nil)
    
    for sceneID = 1, chocoMap.scenery.maxID do
        chocoMap.defaultConfigs.scenery[sceneID] = {
            width = 32,
            height = 32,
            frames = 1,
            framespeed = 8,
            priority = chocoMap.SCENERY_PRIORITY
        }
    end
    
    ___setConfig("scenery", 1, nil, nil, 4, 12)
    ___setConfig("scenery", 4, nil, nil, 4, nil)
    ___setConfig("scenery", 5, nil, nil, 4, 12)
    ___setConfig("scenery", 6, nil, nil, 4, 12)
    ___setConfig("scenery", 9, nil, nil, 4, 11)
    ___setConfig("scenery", 10, nil, nil, 4, 12)
    ___setConfig("scenery", 12, nil, nil, 4, 12)
    ___setConfig("scenery", 15, 16, 16, nil, nil)
    ___setConfig("scenery", 16, 16, 16, nil, nil)
    ___setConfig("scenery", 17, 16, 16, nil, nil)
    ___setConfig("scenery", 18, 16, 16, nil, nil)
    ___setConfig("scenery", 20, 64, 64, nil, nil)
    ___setConfig("scenery", 21, 16, 16, nil, nil)
    ___setConfig("scenery", 24, 16, 16, nil, nil)
    ___setConfig("scenery", 27, 48, 16, 12, nil)
    ___setConfig("scenery", 28, 48, 16, 12, nil)
    ___setConfig("scenery", 29, 64, 16, 12, nil)
    ___setConfig("scenery", 30, 64, 16, 12, nil)
    ___setConfig("scenery", 33, 14, 14, 14, 6)
    ___setConfig("scenery", 34, 14, 14, 14, 6)
    ___setConfig("scenery", 35, 16, 16, nil, nil)
    ___setConfig("scenery", 36, 16, 16, nil, nil)
    ___setConfig("scenery", 37, 16, 16, nil, nil)
    ___setConfig("scenery", 38, 16, 16, nil, nil)
    ___setConfig("scenery", 39, 16, 16, nil, nil)
    ___setConfig("scenery", 44, 62, nil, nil, nil)
    ___setConfig("scenery", 50, 64, 48, nil, nil)
    ___setConfig("scenery", 51, 30, nil, 4, nil)
    ___setConfig("scenery", 52, nil, nil, 4, 12)
    ___setConfig("scenery", 53, nil, nil, 4, 12)
    ___setConfig("scenery", 54, 30, 24, 4, 12)
    ___setConfig("scenery", 55, 30, 24, 4, 12)
    ___setConfig("scenery", 57, 64, 64, nil, nil)
    ___setConfig("scenery", 58, 16, 16, nil, nil)
    ___setConfig("scenery", 59, 16, 16, nil, nil)
    ___setConfig("scenery", 60, 48, 48, nil, nil)
    ___setConfig("scenery", 61, 64, 76, nil, nil)
    ___setConfig("scenery", 62, nil, nil, 8, 6)
    ___setConfig("scenery", 63, 16, 16, 8, 6)
    
    for pathID = 1, chocoMap.paths.maxID do
        chocoMap.defaultConfigs.paths[pathID] = {
            width = 32,
            height = 32,
            frames = 1,
            framespeed = 8,
            priority = chocoMap.PATH_PRIORITY
        }
    end
    
    for levelID = 1, chocoMap.levels.maxID do
        chocoMap.defaultConfigs.levels[levelID] = {
            width = 32,
            height = 32,
            frames = 1,
            framespeed = 8,
            priority = chocoMap.LEVEL_PRIORITY
        }
        if(switchPalace(levelID)) then
            chocoMap.defaultConfigs.levels[levelID].pframes = 1
        end
    end
    
    ___setConfig("levels", 2, nil, nil, 6, 6)
    ___setConfig("levels", 8, nil, nil, 4, 10)
    ___setConfig("levels", 9, nil, nil, 6, 6)
    ___setConfig("levels", 12, nil, nil, 2, nil)
    ___setConfig("levels", 13, nil, nil, 6, 6)
    ___setConfig("levels", 14, nil, nil, 6, 6)
    ___setConfig("levels", 15, nil, nil, 6, 6)
    ___setConfig("levels", 21, nil, 48, nil, nil)
    ___setConfig("levels", 22, 64, 64, nil, nil)
    ___setConfig("levels", 23, 96, 96, nil, nil)
    ___setConfig("levels", 24, nil, 48, nil, nil)
    ___setConfig("levels", 25, nil, nil, 4, nil)
    ___setConfig("levels", 26, nil, nil, 4, nil)
    ___setConfig("levels", 28, nil, 44, nil, nil)
    ___setConfig("levels", 29, 64, nil, nil, nil)
    ___setConfig("levels", 31, nil, nil, 6, 6)
    ___setConfig("levels", 32, nil, nil, 6, 6)
    ___setConfig("levels", 37, nil, nil, 6, 6)
    ___setConfig("levels", 38, nil, nil, 6, 6)
    ___setConfig("levels", 39, nil, nil, 6, 6)
    ___setConfig("levels", 40, nil, nil, 6, 6)
    ___setConfig("levels", 95, nil, nil, 2, nil)
    ___setConfig("levels", 96, nil, nil, 8, nil)
    ___setConfig("levels", 98, nil, nil, 4, nil)
    ___setConfig("levels", 99, nil, nil, 4, nil)
    ___setConfig("levels", 100, nil, nil, 4, nil)
    
    init()
    
    registerEvent(chocoMap, "onDraw", "doDraw")
    registerEvent(chocoMap, "onStart", "setSwitchPalaceAnim")
    registerEvent(chocoMap, "onTickEnd", "enforceCameraBoundaries")
end

function chocoMap.setSwitchPalaceAnim()
    for switchID = 33, 36 do
        if(switchPalacePressed(switchID)) then
            chocoMap.levels.frameTable[switchID] = chocoMap.levels[switchID].config.frames
        end
    end
end

function chocoMap.updateFrameData()
    local frame = drawTick

    for tileID = 1, chocoMap.tiles.maxID do
        if(frame % chocoMap.tiles[tileID].config.framespeed == 0) then
            chocoMap.tiles.frameTable[tileID] = (chocoMap.tiles.frameTable[tileID] + 1) % chocoMap.tiles[tileID].config.frames
        end
    end
    
    for sceneID = 1, chocoMap.scenery.maxID do
        if(frame % chocoMap.scenery[sceneID].config.framespeed == 0) then
            chocoMap.scenery.frameTable[sceneID] = (chocoMap.scenery.frameTable[sceneID] + 1) % chocoMap.scenery[sceneID].config.frames
        end
    end
    
    for pathID = 1, chocoMap.paths.maxID do
        if(frame % chocoMap.paths[pathID].config.framespeed == 0) then
            chocoMap.paths.frameTable[pathID] = (chocoMap.paths.frameTable[pathID] + 1) % chocoMap.paths[pathID].config.frames
        end
    end
    
    if(frame % chocoMap.levels.LEVEL0.config.framespeed == 0) then
        chocoMap.levels.frameTable.LEVEL0 = (chocoMap.levels.frameTable.LEVEL0 + 1) % chocoMap.levels.LEVEL0.config.frames
    end
    
    for levelID = 1, chocoMap.levels.maxID do
        if(frame % chocoMap.levels[levelID].config.framespeed == 0) then
            if(not switchPalace(levelID)) then
                chocoMap.levels.frameTable[levelID] = (chocoMap.levels.frameTable[levelID] + 1) % chocoMap.levels[levelID].config.frames
            else
                if(not switchPalacePressed(levelID)) then
                    chocoMap.levels.frameTable[levelID] = (chocoMap.levels.frameTable[levelID] + 1) % chocoMap.levels[levelID].config.frames
                else
                    chocoMap.levels.frameTable[levelID] = chocoMap.levels.frameTable[levelID] + 1
                    if(chocoMap.levels.frameTable[levelID] == chocoMap.levels[levelID].config.frames + chocoMap.levels[levelID].config.pframes) then
                        chocoMap.levels.frameTable[levelID] = chocoMap.levels[levelID].config.frames
                    end
                end
            end
        end
    end
    
    drawTick = drawTick + 1
    if(drawTick < 0) then drawTick = 0 end --maybe make this cleaner at some point
end

function chocoMap.renderPauseMenu()
    if(mem(0x00B250E2, FIELD_BOOL)) then
        Graphics.drawBox {
            color = Color.black,
            x = pauseX,
            y = pauseY,
            width = pauseW,
            height = pauseH,
            priority = 10
        }
        
        local selectedOption = mem(0x00B2C880, FIELD_WORD)
        local selectorX = pauseX + pauseXOffset
        local selectorY =  pauseY + pauseYOffset + (selectedOption * pauseYSpacing)
        local cheated = Defines.player_hasCheated
        
        if(cheated) then
            selectorX = selectorX + pauseXOffsetCheat
            selectorY = selectorY + pauseYOffsetCheat
        end
        
        Graphics.draw {
            type = RTYPE_IMAGE,
            image = pauseSelector,
            x = selectorX,
            y = selectorY,
            priority = 10
        }
        
        if(not cheated) then
            Graphics.draw {
                type = RTYPE_TEXT,
                text = "CONTINUE",
                x = pauseX + pauseXOffset + pauseXSpacing + pauseSelector.width,
                y = pauseY + pauseYOffset + (0 * pauseYSpacing),
                priority = 10
            }
            Graphics.draw {
                type = RTYPE_TEXT,
                text = "SAVE & CONTINUE",
                x = pauseX + pauseXOffset + pauseXSpacing + pauseSelector.width,
                y = pauseY + pauseYOffset + (1 * pauseYSpacing),
                priority = 10
            }
            Graphics.draw {
                type = RTYPE_TEXT,
                text = "SAVE & QUIT",
                x = pauseX + pauseXOffset + pauseXSpacing + pauseSelector.width,
                y = pauseY + pauseYOffset + (2 * pauseYSpacing),
                priority = 10
            }
        else
            Graphics.draw {
                type = RTYPE_TEXT,
                text = "CONTINUE",
                x = pauseX + pauseXOffset + pauseXSpacing + pauseSelector.width + pauseXOffsetCheat,
                y = pauseY + pauseYOffset + (0 * pauseYSpacing) + pauseYOffsetCheat,
                priority = 10
            }
            Graphics.draw {
                type = RTYPE_TEXT,
                text = "QUIT",
                x = pauseX + pauseXOffset + pauseXSpacing + pauseSelector.width + pauseXOffsetCheat,
                y = pauseY + pauseYOffset + (1 * pauseYSpacing) + pauseYOffsetCheat,
                priority = 10
            }
        end
    end
end

function chocoMap.doDraw()

    chocoMap.updateFrameData()
    chocoMap.enforceCameraBoundaries()
    
    local playerCamera = Camera.get()[1]
    
    if (playerSprite ~= Graphics.sprites.player[player.character].img) then
        playerSprite = Graphics.sprites.player[player.character].img
    end

    Graphics.drawBox {
        x = 0,
        y = 0,
        width = SCRWIDTH,
        height = SCRHEIGHT,
        color = Color.black,
        priority = 0
    }

    for _, tile in ipairs(Tile.get()) do
        if(tile.isValid and isVisible(tile.x, tile.y, chocoMap.tiles[tile.id].config.width, chocoMap.tiles[tile.id].config.height)) then
            Graphics.draw {
                type = RTYPE_IMAGE,
                image = chocoMap.tiles[tile.id].texture,
                x = tile.x - playerCamera.x,
                y = tile.y - playerCamera.y,
                width = chocoMap.tiles[tile.id].config.width,
                height = chocoMap.tiles[tile.id].config.height,
                sourceX = 0,
                sourceY = chocoMap.tiles.frameTable[tile.id] * chocoMap.tiles[tile.id].config.height,
                sourceWidth = chocoMap.tiles[tile.id].config.width,
                sourceHeight = chocoMap.tiles[tile.id].config.height,
                priority = chocoMap.tiles[tile.id].config.priority
            }
        end
    end
    
    for _, scene in ipairs(Scenery.get()) do
        if(scene.isValid and sceneryActive(scene.idx) and isVisible(scene.x, scene.y, chocoMap.scenery[scene.id].config.width, chocoMap.scenery[scene.id].config.height)) then
            Graphics.draw {
                type = RTYPE_IMAGE,
                image = chocoMap.scenery[scene.id].texture,
                x = scene.x - playerCamera.x,
                y = scene.y - playerCamera.y,
                width = chocoMap.scenery[scene.id].config.width,
                height = chocoMap.scenery[scene.id].config.height,
                sourceX = 0,
                sourceY = chocoMap.scenery.frameTable[scene.id] * chocoMap.scenery[scene.id].config.height,
                sourceWidth = chocoMap.scenery[scene.id].config.width,
                sourceHeight = chocoMap.scenery[scene.id].config.height,
                priority = chocoMap.scenery[scene.id].config.priority
            }
        end
    end


    for _, path in ipairs(Path.get()) do
        if(path.isValid and path.visible and isVisible(path.x, path.y, chocoMap.paths[path.id].config.width, chocoMap.paths[path.id].config.height)) then
            Graphics.draw {
                type = RTYPE_IMAGE,
                image = chocoMap.paths[path.id].texture,
                x = path.x - playerCamera.x,
                y = path.y - playerCamera.y,
                width = chocoMap.paths[path.id].config.width,
                height = chocoMap.paths[path.id].config.height,
                sourceX = 0,
                sourceY = chocoMap.paths.frameTable[path.id] * chocoMap.paths[path.id].config.height,
                sourceWidth = chocoMap.paths[path.id].config.width,
                sourceHeight = chocoMap.paths[path.id].config.height,
                priority = chocoMap.paths[path.id].config.priority
            }
        end
    end
    
    for levelID = 1, chocoMap.levels.maxID do
        for _, level in ipairs(Level.get(levelID)) do
            if(level.visible) then
                local trueX = level.x
                local trueY = level.y
                if(chocoMap.levels[levelID].config.height ~= 32) then trueY = trueY - (chocoMap.levels[levelID].config.height - 32) end
                if(chocoMap.levels[levelID].config.width ~= 32) then trueX = trueX - (chocoMap.levels[levelID].config.width - 32) / 2 end
                
                local drawX = trueX
                local drawY = trueY
                local drawW = chocoMap.levels[levelID].config.width 
                local drawH = chocoMap.levels[levelID].config.height
                
                if(chocoMap.levels[levelID].config.width < chocoMap.levels.LEVEL0.config.width and level.isPathBackground) then 
                    drawX = drawX - (chocoMap.levels.LEVEL0.config.width - chocoMap.levels[levelID].config.width)
                    drawW = chocoMap.levels.LEVEL0.config.width
                end
                if(chocoMap.levels[levelID].config.height < chocoMap.levels.LEVEL0.config.height and level.isPathBackground) then
                    drawY = drawY - (chocoMap.levels.LEVEL0.config.height - chocoMap.levels[levelID].config.height)
                    drawH = chocoMap.levels.LEVEL0.config.height
                end
                
                if(drawW < chocoMap.levels[29].config.width and level.isBigBackground) then
                    drawX = drawX - (chocoMap.levels[29].config.width - drawW)
                    drawW = chocoMap.levels[29].config.width
                end
                if(level.isBigBackground) then
                    if(drawH < 3 * (chocoMap.levels[29].config.height / 4)) then drawY = drawY - (3 * (chocoMap.levels[29].config.height / 4) - drawH) end
                    drawH = drawH + (chocoMap.levels[29].config.height / 4)
                end
                
                if(isVisible(drawX, drawY, drawW, drawH)) then
                    if(level.isPathBackground) then
                        Graphics.draw {
                            type = RTYPE_IMAGE,
                            image = chocoMap.levels.LEVEL0.texture,
                            x = level.x - playerCamera.x,
                            y = level.y - playerCamera.y,
                            width = chocoMap.levels.LEVEL0.config.width,
                            height = chocoMap.levels.LEVEL0.config.height,
                            sourceX = 0,
                            sourceY = chocoMap.levels.frameTable.LEVEL0 * chocoMap.levels.LEVEL0.config.height,
                            sourceWidth = chocoMap.levels.LEVEL0.config.width,
                            sourceHeight = chocoMap.levels.LEVEL0.config.height,
                            priority = chocoMap.levels.LEVEL0.config.priority
                        }
                    end
                    
                    if(level.isBigBackground) then
                        Graphics.draw {
                            type = RTYPE_IMAGE,
                            image = chocoMap.levels[29].texture,
                            x = level.x - (chocoMap.levels[29].config.width / 4) - playerCamera.x,
                            y = level.y + (chocoMap.levels[29].config.height / 4) - playerCamera.y,
                            width = chocoMap.levels[29].config.width,
                            height = chocoMap.levels[29].config.height,
                            sourceX = 0,
                            sourceY = chocoMap.levels.frameTable[29] * chocoMap.levels[29].config.height,
                            sourceWidth = chocoMap.levels[29].config.width,
                            sourceHeight = chocoMap.levels[29].config.height,
                            priority = chocoMap.levels[29].config.priority
                        }
                    end
                    
                    local srcY = chocoMap.levels.frameTable[levelID] * chocoMap.levels[levelID].config.height
                    Graphics.draw {
                        type = RTYPE_IMAGE,
                        image = chocoMap.levels[levelID].texture,
                        x = trueX - playerCamera.x,
                        y = trueY - playerCamera.y,
                        width = chocoMap.levels[levelID].config.width,
                        height = chocoMap.levels[levelID].config.height,
                        sourceX = 0,
                        sourceY = srcY,
                        sourceWidth = chocoMap.levels[levelID].config.width,
                        sourceHeight = chocoMap.levels[levelID].config.height,
                        priority = chocoMap.levels[levelID].config.priority
                    }
                end
            end
        end
    end
    
    local playerHeight = 32
    if(player.character == CHARACTER_PEACH) then playerHeight = 44 end
    if(player.character == CHARACTER_TOAD) then playerHeight = 40 end
    
    Graphics.draw {
        type = RTYPE_IMAGE,
        image = playerSprite,
        x = world.playerX - playerCamera.x,
        y = world.playerY - playerCamera.y - (playerHeight - 22),
        width = 32,
        height = playerHeight,
        sourceX = 0,
        sourceY = world.playerWalkingFrame * playerHeight,
        sourceWidth = 32,
        sourceHeight = playerHeight,
        priority = chocoMap.PLAYER_PRIORITY
    }
    
    Graphics.drawVanillaOverworldHUD(chocoMap.HUD_PRIORITY)
    
    chocoMap.renderPauseMenu()
end

function chocoMap.addCameraBoundary(xPos, yPos, w, h)
    chocoMap.cameraBoundaries[camCount] = {}
    chocoMap.cameraBoundaries[camCount].x = xPos
    chocoMap.cameraBoundaries[camCount].y = yPos
    chocoMap.cameraBoundaries[camCount].width = math.max(w, SCRWIDTH)
    chocoMap.cameraBoundaries[camCount].height = math.max(h, SCRHEIGHT)
    camCount = camCount + 1
    return camCount - 1
end

function chocoMap.removeCameraBoundary(idx)
    chocoMap.cameraBoundaries[idx] = nil
end

function chocoMap.enforceCameraBoundaries()
    local playerCam = Camera.get()[1]
    for _, v in ipairs(chocoMap.cameraBoundaries) do
        if(v ~= nil) then
            if(check_range(world.playerX, v.x, v.x + v.width) and check_range(world.playerY, v.y, v.y + v.height)) then
                playerCam.x = math.max(v.x, math.min(playerCam.x, v.x + v.width - SCRWIDTH))
                playerCam.y = math.max(v.y, math.min(playerCam.y, v.y + v.height - SCRHEIGHT))
                break
            end
        end
    end
end

return chocoMap