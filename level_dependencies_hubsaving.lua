function onStart()
-- If SaveData.currentHub specified an alternate hub level, set that as the hub level path
    if (SaveData.currentHub = "SMAS - Start.lvlx") then
        mem(0xB25724, FIELD_STRING, SaveData.currentHub)
        SaveData.currentHub = "SMAS - Map.lvlx"
    end
end

function onExit()
    if (SaveData.currentHub = "SMAS - Map.lvlx") then
        mem(0xB25724, FIELD_STRING, SaveData.currentHub)
        SaveData.currentHub = "SMAS - Start.lvlx"
    end
end