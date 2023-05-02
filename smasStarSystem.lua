local starsystem = {}

starsystem.fadeInActive = false
starsystem.fadePriority = 6

starsystem.stardoor = Graphics.loadImageResolved("starlock.png")

local opacity = 0

--Star system SaveData variables
if SaveData.totalStarCount == nil then --This will make a new star count system that won't corrupt save files
    SaveData.totalStarCount = 0
end
if SaveData.completeLevels == nil then --This will add a table to list completed levels when collecting win states
    SaveData.completeLevels = {}
end
if SaveData.completeLevelsOptional == nil then --This will add a table to list completed levels when collecting win states in optional levels
    SaveData.completeLevelsOptional = {}
end

function starsystem.onInitAPI()
    registerEvent(starsystem,"onDraw")
end

function starsystem.onDraw()
    local warps = Warp.get()
    for _,v in ipairs(warps) do
        if v.isValid and (not v.isHidden) and v.starsRequired > SaveData.totalStarCount then
            Graphics.drawImageToSceneWP(starsystem.stardoor, v.entranceX + 0.5 * v.entranceWidth - 12, v.entranceY - 20, -40) --This will draw the star door locks, since the original image is invisible
        end
    end
    if starsystem.fadeInActive then
        opacity = opacity + 0.01
        Graphics.drawScreen{color = Color.black .. opacity, priority = starsystem.fadePriority}
    end
end

return starsystem