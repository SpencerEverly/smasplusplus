local level_dependencies_smb2 = require("level_dependencies_normal")

local playerManager = require("playerManager")

local nesCostumes = {
    "04-SMB2-RETRO",
    "05-SMB2-RETRO",
    "03-SMB2-RETRO",
    "IMAJIN-NES",
}

local gbaCostumes = {
    "11-SMA1",
    "12-SMA2",
}

function onStart()
    if player:mem(0x15E, FIELD_WORD) == 7 then
        if SaveData.currentCostume == "N/A" then
            Sound.playSFX("smb2-beginning.ogg")
        elseif nesCostumes[SaveData.currentCostume] then
            Sound.playSFX("smb1-nes-beginning.ogg")
        elseif gbaCostumes[SaveData.currentCostume] then
            Sound.playSFX("sma1-beginning.ogg")
        elseif SaveData.currentCostume then
            Sound.playSFX("smb2-beginning.ogg")
        end
    end
end

function onEvent(eventName)
    if eventName == "Boss Start" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Boss.spc|0;g=2.5", 4)
    end
    if eventName == "Boss End" then
        Sound.changeMusic(0, 4)
        Sound.playSFX(40)
    end
    if eventName == "Boss End 2" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Boss.spc|0;g=2.5", 4)
    end
    --[[if SaveData.currentCostume == "11-SMA1" then
        if eventName == "Boss Start" then
            Sound.playSFX("mario/11-SMA1/birdo-thisisasfarasyougo.wav")
        end
    end
    if SaveData.currentCostume == "11-SMA1" then
        if eventName == "Boss End" then
            Sound.playSFX("mario/11-SMA1/birdo-I'llrememberthis.wav")
        end
    end]]
end