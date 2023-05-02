local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss Start") then
        Sound.changeMusic("_OST/Super Mario Bros/Bowser.spc|0;g=2.5", 0)
        Screen.setCameraPosition(-195552,-200600,-200000,-194752)
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
        Sound.changeMusic(0, 0)
        Screen.setCameraPosition(-194784,-200600,-200000,-193920)
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
end

function onLoadSection0()
    smasNoTurnBack.overrideSection = true
end

function onLoadSection1()
    smasNoTurnBack.overrideSection = false
end