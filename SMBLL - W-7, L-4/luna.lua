local level_dependencies_normal = require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss Start") then
        Sound.changeMusic("_OST/Super Mario Bros/Bowser.spc|0;g=2.5", 1)
        Screen.setCameraPosition(-172928,-180600,-180000,-172096)
    end
    if eventName == ("Axe Break") then
        Sound.playSFX(4)
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
    if eventName == ("Boss End") then
        Sound.playSFX(138)
        Sound.changeMusic(0, 1)
        Screen.setCameraPosition(-172128,-180600,-180000,-171264)
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
end