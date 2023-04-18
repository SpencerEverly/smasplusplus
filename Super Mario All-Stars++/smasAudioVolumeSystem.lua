local smasAudioVolumeSystem = {}

local audiomasterSMAS = require("scripts/audiomasterSMAS")

function smasAudioVolumeSystem.onInitAPI()
    registerEvent(smasAudioVolumeSystem,"onDraw")
end

function smasAudioVolumeSystem.onDraw()
    for i = 1, 91 do
        Audio.sounds[i].sfx.volume = math.floor(GameData.____sfxVolume * 128 + 0.5)
        if extrasounds.active then
            if Audio.sounds[43].muted then
                Audio.sounds[43].sfx.volume = 0
            end
        end
    end
    if pausemenu2 and pauseplus then
        if smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
            Audio.MusicVolume(0)
        elseif not smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
            Audio.MusicVolume(pauseplus.getSelectionValue("soundsettings","Music Volume"))
        end
        GameData.____currentMusicVolume = pauseplus.getSelectionValue("soundsettings","Music Volume")
        GameData.____sfxVolume = pauseplus.getSelectionValue("soundsettings","SFX Volume")
    else    
        if smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
            Audio.MusicVolume(0)
        elseif not smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
            Audio.MusicVolume(GameData.____currentMusicVolume)
        end
    end
    SFX.volume.MASTER = GameData.____sfxVolume
    audiomasterSMAS.volume.MASTER = GameData.____sfxVolume
end

return smasAudioVolumeSystem