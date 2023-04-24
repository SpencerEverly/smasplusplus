local smasKeyholeSystem = {}

smasKeyholeSystem.keyholeTimer = 0
smasKeyholeSystem.keyholeTimerEnd = 192
smasKeyholeSystem.blackScreenOpacity = 0
smasKeyholeSystem.keyholeImage = Graphics.loadImageResolved("background-997.png")
local savedBGO

function smasKeyholeSystem.onInitAPI()
    registerEvent(smasKeyholeSystem,"onDraw")
end

function smasKeyholeSystem.startKeyholeAnimation(v)
    savedBGO = v
    smasBooleans.keyholeActivated = true
end

function smasKeyholeSystem.onDraw()
    if smasBooleans.keyholeActivated then
        if smasKeyholeSystem.keyholeTimer < smasKeyholeSystem.keyholeTimerEnd then
            Misc.pause()
        end
        GameData.winStateActive = true
        smasKeyholeSystem.keyholeTimer = smasKeyholeSystem.keyholeTimer + 1
        if smasKeyholeSystem.keyholeTimer == 1 then
            Sound.muteMusic(-1)
            Sound.playSFX(31)
        end
        
        local keyholeDone = smasKeyholeSystem.keyholeTimerEnd - 65
        local ratio = 256 * smasKeyholeSystem.keyholeTimer / keyholeDone
        if (ratio > 255) then
            ratio = 255
        end
        
        local realKeyholeBottom = savedBGO.y + 24
        local idealKeyholeBottom = 32 * math.ceil(realKeyholeBottom / 32)
        
        local keyholeGrowthCoord = ratio / 100
        
        if (keyholeGrowthCoord > 1) then
            keyholeGrowthCoord = 1
        end
        
        local keyholeScale = keyholeGrowthCoord * 12
        
        if (ratio < 128) then
            keyholeScale = keyholeScale + (1 - keyholeGrowthCoord)
        end

        local keyholeBottom = realKeyholeBottom * (1 - keyholeGrowthCoord) + idealKeyholeBottom * keyholeGrowthCoord
        
        Graphics.drawBox{
            texture = smasKeyholeSystem.keyholeImage,
            x = -camera.x + savedBGO.x + savedBGO.width / 2 - savedBGO.width * keyholeScale / 2,
            y = -camera.y + keyholeBottom - 24 * keyholeScale,
            width = savedBGO.width * keyholeScale,
            height = savedBGO.height * keyholeScale,
            sourceWidth = savedBGO.width,
            sourceHeight = savedBGO.height,
            priority = -26,
            sceneCoords = false,
        }
        
        if (ratio >= 128) then
            savedBGO.isHidden = true
        end
        
        if smasKeyholeSystem.keyholeTimer >= smasKeyholeSystem.keyholeTimerEnd then
            Misc.unpause()
            Level.exit(LEVEL_WIN_TYPE_KEYHOLE)
        end
    end
end

local function RenderTexturePlayerScale()
    
end

return smasKeyholeSystem