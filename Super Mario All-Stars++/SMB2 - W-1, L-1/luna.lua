local level_dependencies_smb2 = require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

function onStart()
    if player:mem(0x15E, FIELD_WORD) == 7 then
        if SaveData.currentCostume == "N/A" then
            Sound.playSFX("smb2-beginning.ogg")
        elseif SaveData.currentCostume == "04-SMB2-RETRO" then
            Sound.playSFX("smb1-nes-beginning.ogg")
        elseif SaveData.currentCostume == "05-SMB2-RETRO" then
            Sound.playSFX("smb1-nes-beginning.ogg")
        elseif SaveData.currentCostume == "03-SMB2-RETRO" then
            Sound.playSFX("smb1-nes-beginning.ogg")
        elseif SaveData.currentCostume == "IMAJIN-NES" then
            Sound.playSFX("smb1-nes-beginning.ogg")
        elseif SaveData.currentCostume == "11-SMA1" then
            Sound.playSFX("sma1-beginning.ogg")
        elseif SaveData.currentCostume == "12-SMA2" then
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
    if eventName == "Boss End 2" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Boss.spc|0;g=2.5", 4)
    end
    
    local costumes
    if SaveData.currentCostume == "11-SMA1" then
        if eventName == "Boss Start" then
            Sound.playSFX("mario/11-SMA1/birdo-thisisasfarasyougo.wav")
        end
    end
    if SaveData.currentCostume == "11-SMA1" then
        if eventName == "Boss End" then
            Sound.playSFX("mario/11-SMA1/birdo-I'llrememberthis.wav")
        end
    end
end