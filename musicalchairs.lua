--musicalChairs.lua v1.0
--By Spencer Everly
--Yoshi beats for the win! SEE Mod only for now.

local musicalChairs = {}

--If enabled, Yoshi beats will be active.
musicalChairs.enabled = true
musicalChairs.musicList = {
    
    --Super Mario World
    ["Here We Go! (Advance)"] = {
        yoshiTrack = 6,
    },
    
    --Super Mario Bros. Spencer
    ["Overworld (SMBSE)"] = {
        yoshiTrack = 2,
    },
    ["Athletic (SMBSE)"] = {
        yoshiTrack = 2,
    },
    ["Boss Battle (SMBSE)"] = {
        yoshiTrack = 2,
    },
    
    --Extra tracks
    ["STRM_BGM_CHIJOU.ogg"] = {
        yoshiTrack = 2,
    },
    
}

function musicalChairs.onInitAPI()
    registerEvent(musicalChairs,"onDraw")
end

function musicalChairs.onDraw()
    if SMBX_VERSION == VER_SEE_MOD then
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated and musicalChairs.enabled then
            if musicalChairs.musicList[Audio.MusicTitle()] ~= nil then
                if player.mount == MOUNT_YOSHI then
                    Sound.unmuteChannel(musicalChairs.musicList[Audio.MusicTitle()].yoshiTrack)
                else
                    Sound.muteChannel(musicalChairs.musicList[Audio.MusicTitle()].yoshiTrack)
                end
            end
        end
    end
end

return musicalChairs