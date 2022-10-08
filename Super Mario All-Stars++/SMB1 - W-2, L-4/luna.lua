local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss Start") then
        Sound.changeMusic("_OST/Super Mario Bros/Bowser.spc|0;g=2.5", 0)
        Screen.setCameraPosition(-195616,-200600,-200000,-194752)
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
        Sound.changeMusic(0, 0)
        Screen.setCameraPosition(-194848,-200600,-200000,-193824)
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
end

function onLoadSection0()
    smasnoturnback.overrideSection = true
end

function onLoadSection1()
    smasnoturnback.overrideSection = false
end

function onLoadSection2()
    smasnoturnback.overrideSection = true
end