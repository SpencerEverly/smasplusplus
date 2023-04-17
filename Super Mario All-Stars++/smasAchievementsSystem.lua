local smasAchievementsSystem = {}

function smasAchievementsSystem.onInitAPI()
    registerEvent(smasAchievementsSystem,"onDraw")
end

function smasAchievementsSystem.onDraw()
    if SaveData.goombaStomps >= 10 then
        Achievements.get(1):collect()
    end
    if SaveData.goombaStomps >= 100 then
        Achievements.get(2):collect()
    end
end

return smasAchievementsSystem