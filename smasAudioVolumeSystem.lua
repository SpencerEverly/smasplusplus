local smasAudioVolumeSystem = {}

local audiomasterSMAS = require("scripts/audiomasterSMAS")

function smasAudioVolumeSystem.onInitAPI()
    registerEvent(smasAudioVolumeSystem,"onDraw")
end

function smasAudioVolumeSystem.onDraw()
    if not Misc.inMarioChallenge() then
        GameData.SMASPlusPlus.audio.musicVolume = GameData.SMASPlusPlus.audio.musicVolume or 60
        GameData.SMASPlusPlus.audio.sfxVolume = GameData.SMASPlusPlus.audio.sfxVolume or 1
        if pausemenu2 and pauseplus then
            if smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
                Audio.MusicVolume(0)
            elseif not smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
                Audio.MusicVolume(pauseplus.getSelectionValue("soundsettings","Music Volume"))
            end
            GameData.SMASPlusPlus.audio.musicVolume = pauseplus.getSelectionValue("soundsettings","Music Volume")
            GameData.SMASPlusPlus.audio.sfxVolume = pauseplus.getSelectionValue("soundsettings","SFX Volume")
        elseif pausemenu2 == nil and pauseplus == nil then
            if smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
                Audio.MusicVolume(0)
            elseif not smasBooleans.musicMuted and not smasBooleans.overrideMusicVolume then
                Audio.MusicVolume(GameData.SMASPlusPlus.audio.musicVolume)
            end
        end
        for i = 1,91 do
            pcall(function() Audio.sounds[i].sfx.volume = math.floor(GameData.SMASPlusPlus.audio.sfxVolume * 128 + 0.5) end)
        end
        if smasExtraSounds.active then
            if Audio.sounds[43].muted then
                Audio.sounds[43].sfx.volume = 0
            end
        end
        SFX.volume.MASTER = GameData.SMASPlusPlus.audio.sfxVolume
        audiomasterSMAS.volume.MASTER = GameData.SMASPlusPlus.audio.sfxVolume
    end
end

return smasAudioVolumeSystem