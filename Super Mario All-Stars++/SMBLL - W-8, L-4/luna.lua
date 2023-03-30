local level_dependencies_normal = require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss Start") then
        Screen.setCameraPosition(-115872,-120600,-120000,-115072)
    end
    if eventName == ("Bridge Break") then
        Sound.playSFX(4)
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
    if eventName == ("Boss End") then
        Sound.playSFX(138)
        Sound.changeMusic(0, 4)
        Screen.setCameraPosition(-115104,-120600,-120000,-114208)
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
    if eventName == ("Cutscene 4") then
        Sound.playSFX("pigeon_attack.ogg")
    end
end