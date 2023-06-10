local smasAudioVolumeSystem = {}

local audiomasterSMAS = require("scripts/audiomasterSMAS")

function smasAudioVolumeSystem.onInitAPI()
    registerEvent(smasAudioVolumeSystem,"onDraw")
end

function smasAudioVolumeSystem.onDraw()
    if not Misc.inMarioChallenge() then
        GameData.____currentMusicVolume = GameData.____currentMusicVolume or 60
        GameData.____sfxVolume = GameData.____sfxVolume or 1
        if pausemenu2 and pauseplus then
            if smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
                Audio.MusicVolume(0)
            elseif not smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
                Audio.MusicVolume(pauseplus.getSelectionValue("soundsettings","Music Volume"))
            end
            GameData.____currentMusicVolume = pauseplus.getSelectionValue("soundsettings","Music Volume")
            GameData.____sfxVolume = pauseplus.getSelectionValue("soundsettings","SFX Volume")
        elseif pausemenu2 == nil and pauseplus == nil then
            if smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
                Audio.MusicVolume(0)
            elseif not smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
                Audio.MusicVolume(GameData.____currentMusicVolume)
            end
        end
        for i = 1,91 do
            pcall(function() Audio.sounds[i].sfx.volume = math.floor(GameData.____sfxVolume * 128 + 0.5) end)
        end
        if smasExtraSounds.active then
            if Audio.sounds[43].muted then
                Audio.sounds[43].sfx.volume = 0
            end
        end
        SFX.volume.MASTER = GameData.____sfxVolume
        audiomasterSMAS.volume.MASTER = GameData.____sfxVolume
    end
end

return smasAudioVolumeSystem