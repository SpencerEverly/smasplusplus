--musicalChairs.lua v1.0
--By Spencer Everly
--Yoshi beats for the win! SEE Mod only for now.

local musicalChairs = {}

--If enabled, Yoshi beats will be active.
musicalChairs.enabled = true
musicalChairs.musicList = {
    
    --Super Mario World
    ["_OST/Super Mario World/Here We Go (Advance) (Yoshi).spc|0;g=2.5"] = {
        yoshiTrack = 6,
    },
    ["_OST/Super Mario World/Underground (Yoshi).spc|0;g=2.5"] = {
        yoshiTrack = 6,
    },
    ["_OST/Super Mario World/Forest (Yoshi).spc|0;g=2.5"] = {
        yoshiTrack = 6,
    },
    ["_OST/Super Mario World/Athletic (Yoshi).spc|0;g=2.5"] = {
        yoshiTrack = 6,
    },
    
    --Super Mario Bros. Spencer
    ["_OST/Super Mario Bros Spencer/Overworld.ogg|m1;c2;r2"] = {
        yoshiTrack = 2,
    },
    ["_OST/Super Mario Bros Spencer/Athletic.ogg|m1;c2;r2"] = {
        yoshiTrack = 2,
    },
    ["_OST/Super Mario Bros Spencer/Boss Battle.ogg|m1;c2;r2"] = {
        yoshiTrack = 2,
    },
    
    --Extra tracks
    ["_OST/New Super Mario Bros. Wii/STRM_BGM_CHIJOU.ogg|m1;c2;r2"] = {
        yoshiTrack = 2,
    },
    
}

function musicalChairs.onInitAPI()
    registerEvent(musicalChairs,"onDraw")
end

function musicalChairs.onDraw()
    if SMBX_VERSION == VER_SEE_MOD then
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated and musicalChairs.enabled then
            for i = 0,20 do
                if (musicalChairs.musicList[Section(i).music] ~= nil and player.section == i) then
                    if player.mount == MOUNT_YOSHI then
                        Sound.unmuteChannel(musicalChairs.musicList[Section(i).music].yoshiTrack)
                    else
                        Sound.muteChannel(musicalChairs.musicList[Section(i).music].yoshiTrack)
                    end
                end
            end
        end
    end
end

return musicalChairs