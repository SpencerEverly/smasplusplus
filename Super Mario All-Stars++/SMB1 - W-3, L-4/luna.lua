local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss Start") then
        Sound.changeMusic("_OST/Super Mario Bros/Bowser.spc|0;g=2.5", 1)
        Screen.setCameraPosition(-176000,-180600,-180000,-175200)
    end
    if eventName == ("Axe") then
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
        Screen.setCameraPosition(-175264,-180600,-180000,-174336)
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
end

function onLoadSection0()
    smasnoturnback.overrideSection = false
end

function onLoadSection1()
    smasnoturnback.overrideSection = true
end

function onLoadSection2()
    smasnoturnback.overrideSection = true
end