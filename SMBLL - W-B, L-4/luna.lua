local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss Start") then
        Sound.changeMusic("_OST/Super Mario Bros/Bowser.spc|0;g=2.5", 1)
        Screen.setCameraPosition(-172960,-180600,-180000,-172128)
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
        Sound.changeMusic(0, 1)
        Screen.setCameraPosition(-172160,-180600,-180000,-171200)
        for k,v in ipairs(NPC.get(87)) do
            if v.isValid then
                v:kill(HARM_TYPE_VANISH)
            end
        end
    end
end

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 6 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World D
            SaveData.smwMap.playerX = -195424
            SaveData.smwMap.playerY = -201024
        end
    end
end