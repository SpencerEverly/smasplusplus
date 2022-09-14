local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss Start") then
        Misc.setCameraPosition(-136960,-140600,-140000,-136160,8,"right")
    end
    if eventName == ("Bridge") then
        Sound.playSFX(4)
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
    if eventName == ("Boss End") then
        Sound.playSFX(138)
        Sound.changeMusic(0, 3)
        Misc.setCameraPosition(-136224,-140600,-140000,-135328,5,"right")
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
    if eventName == ("Ending 3") then
        Sound.playSFX("pigeon_attack.ogg")
    end
end