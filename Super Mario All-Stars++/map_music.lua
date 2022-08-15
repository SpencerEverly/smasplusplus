local jukebox = require("jukebox-v11")
local playerManager = require("playerManager")

local map_music = {}

function map_music.onInitAPI()
    registerEvent(map_music, "onStart")
    registerEvent(map_music, "onTick")
end

--SMB1 Secret Warps
jukebox.setTrack(750, jukebox.resolveMusicFile(Misc.episodePath().."_OST/Super Mario Bros/World Music/Super Players.ogg"))
jukebox.setMusicBox(750, 256, 704)
jukebox.setMusicBox(750, 320, 704)
jukebox.setMusicBox(750, 736, 960)
jukebox.setMusicBox(750, 800, 960)
jukebox.setMusicBox(750, 1312, 960)
jukebox.setMusicBox(750, 1376, 960)
jukebox.setMusicBox(750, 1792, 960)
jukebox.setMusicBox(750, 1792, 1024)
jukebox.setMusicBox(750, 1792, 1120)
jukebox.setMusicBox(750, 2112, 1184)
jukebox.setMusicBox(750, 2176, 1184)
jukebox.setMusicBox(750, 2720, 1632)
jukebox.setMusicBox(750, 2752, 1664)
jukebox.setMusicBox(750, 2784, 1632)

--Game Select
jukebox.setTrack(751, jukebox.resolveMusicFile("_OST/All Stars Menu/World Music/Game Select.ogg"))
jukebox.setMusicBox(751, -3040, -2048)
jukebox.setMusicBox(751, -3040, -1760)
jukebox.setMusicBox(751, -2912, -1760)
jukebox.setMusicBox(751, -2880, -1664)
jukebox.setMusicBox(751, -2624, -1760)
jukebox.setMusicBox(751, -2336, -1760)
jukebox.setMusicBox(751, -2048, -1760)
jukebox.setMusicBox(751, -1760, -1760)
jukebox.setMusicBox(751, -1760, -1568)
jukebox.setMusicBox(751, -1472, -1760)
jukebox.setMusicBox(751, -1184, -1760)
jukebox.setMusicBox(751, -896, -1760)

--SMB1 World 1
jukebox.setTrack(752, jukebox.resolveMusicFile("_OST/Super Mario Bros/World 1.ogg"))
jukebox.setMusicBox(752, 160, 352)
jukebox.setMusicBox(752, 224, 352)
jukebox.setMusicBox(752, 416, 416)
jukebox.setMusicBox(752, 576, 352)

--SMB1 World 2
jukebox.setTrack(753, jukebox.resolveMusicFile("_OST/Super Mario Bros/World 2.ogg"))
jukebox.setMusicBox(753, 672, 352)
jukebox.setMusicBox(753, 704, 352)
jukebox.setMusicBox(753, 704, 416)
jukebox.setMusicBox(753, 704, 672)
jukebox.setMusicBox(753, 864, 704)

--SMB1 World 3
jukebox.setTrack(754, jukebox.resolveMusicFile("_OST/Super Mario Bros/World 3.ogg"))
jukebox.setMusicBox(754, 960, 704)
jukebox.setMusicBox(754, 1024, 672)
jukebox.setMusicBox(754, 1024, 608)
jukebox.setMusicBox(754, 1312, 704)
jukebox.setMusicBox(754, 1408, 576)

--SMB1 World 4
jukebox.setTrack(755, jukebox.resolveMusicFile("_OST/Super Mario Bros/World 4.ogg"))
jukebox.setMusicBox(755, 1568, 576)
jukebox.setMusicBox(755, 1632, 608)
jukebox.setMusicBox(755, 1696, 608)
jukebox.setMusicBox(755, 1856, 736)
jukebox.setMusicBox(755, 1952, 672)

--SMB1 World 5
jukebox.setTrack(756, jukebox.resolveMusicFile("_OST/Super Mario Bros/World 5.ogg"))
jukebox.setMusicBox(756, 2112, 672)
jukebox.setMusicBox(756, 2144, 736)
jukebox.setMusicBox(756, 2144, 672)
jukebox.setMusicBox(756, 2176, 864)
jukebox.setMusicBox(756, 2304, 928)

--SMB1 World 6
jukebox.setTrack(757, jukebox.resolveMusicFile("_OST/Super Mario Bros/World 6.ogg"))
jukebox.setMusicBox(757, 2464, 928)
jukebox.setMusicBox(757, 2560, 928)
jukebox.setMusicBox(757, 2560, 864)
jukebox.setMusicBox(757, 2848, 992)

--SMB1 World 7
jukebox.setTrack(758, jukebox.resolveMusicFile("_OST/Super Mario Bros/World 7.ogg"))
jukebox.setMusicBox(758, 2848, 1216)
jukebox.setMusicBox(758, 2848, 1248)
jukebox.setMusicBox(758, 2912, 1248)
jukebox.setMusicBox(758, 2944, 1376)
jukebox.setMusicBox(758, 3072, 1440)

--SMB1 World 8
jukebox.setTrack(759, jukebox.resolveMusicFile("_OST/Super Mario Bros/World 8.ogg"))
jukebox.setMusicBox(759, 3264, 1152)
jukebox.setMusicBox(759, 3264, 864)
jukebox.setMusicBox(759, 3200, 864)
jukebox.setMusicBox(759, 3520, 832)
jukebox.setMusicBox(759, 3744, 832)

--SMB1 World 9
jukebox.setTrack(762, jukebox.resolveMusicFile("_OST/Super Mario Bros/World 9.ogg"))
jukebox.setMusicBox(762, 3776, 832)
jukebox.setMusicBox(762, 4096, 832)
jukebox.setMusicBox(762, 4512, 832)
jukebox.setMusicBox(762, 4064, 832)
jukebox.setMusicBox(762, 4736, 736)
jukebox.setMusicBox(762, 4736, 896)
--SMBLL World 9, same as SMB1 World 9
jukebox.setMusicBox(762, 5344, 3008)
jukebox.setMusicBox(762, 5248, 3008)
jukebox.setMusicBox(762, 5120, 2944)

--SMBLL World 1
jukebox.setTrack(764, jukebox.resolveMusicFile("_OST/The Lost Levels/World 1.ogg"))
jukebox.setMusicBox(764, 4896, 3680)
jukebox.setMusicBox(764, 4960, 3616)
jukebox.setMusicBox(764, 5248, 3392)

--SMBLL World 2
jukebox.setTrack(765, jukebox.resolveMusicFile("_OST/The Lost Levels/World 2.ogg"))
jukebox.setMusicBox(765, 5344, 3392)
jukebox.setMusicBox(765, 5408, 3392)
jukebox.setMusicBox(765, 5760, 3456)

--SMBLL World 3
jukebox.setTrack(766, jukebox.resolveMusicFile("_OST/The Lost Levels/World 3.ogg"))
jukebox.setMusicBox(766, 5760, 3488)
jukebox.setMusicBox(766, 5760, 3616)
jukebox.setMusicBox(766, 6080, 3744)

--SMBLL World 4
jukebox.setTrack(767, jukebox.resolveMusicFile("_OST/The Lost Levels/World 4.ogg"))
jukebox.setMusicBox(767, 6176, 3744)
jukebox.setMusicBox(767, 6272, 3744)
jukebox.setMusicBox(767, 6336, 3424)

--SMBLL World 5
jukebox.setTrack(768, jukebox.resolveMusicFile("_OST/The Lost Levels/World 5.ogg"))
jukebox.setMusicBox(768, 6400, 3424)
jukebox.setMusicBox(768, 6432, 3424)
jukebox.setMusicBox(768, 6688, 3232)

--SMBLL World 6
jukebox.setTrack(769, jukebox.resolveMusicFile("_OST/The Lost Levels/World 6.ogg"))
jukebox.setMusicBox(769, 6688, 3136)
jukebox.setMusicBox(769, 6688, 3104)
jukebox.setMusicBox(769, 6560, 2880)

--SMBLL World 7
jukebox.setTrack(770, jukebox.resolveMusicFile("_OST/The Lost Levels/World 7.ogg"))
jukebox.setMusicBox(770, 6496, 2880)
jukebox.setMusicBox(770, 6432, 2880)
jukebox.setMusicBox(770, 6144, 2880)

--SMBLL World 8
jukebox.setTrack(771, jukebox.resolveMusicFile("_OST/The Lost Levels/World 8.ogg"))
jukebox.setMusicBox(771, 6048, 2880)
jukebox.setMusicBox(771, 5888, 2912)
jukebox.setMusicBox(771, 5472, 3008)
jukebox.setMusicBox(771, 5664, 2944)

--SMB2 Worlds 1-7
jukebox.setTrack(760, jukebox.resolveMusicFile("_OST/Super Mario Bros 2/World Music/Player Select.ogg"))
jukebox.setMusicBox(760, -1408, -4096)
jukebox.setMusicBox(760, -1312, -4096)
jukebox.setMusicBox(760, -1120, -4032)
jukebox.setMusicBox(760, -1120, -3968)
jukebox.setMusicBox(760, -1280, -3968)
jukebox.setMusicBox(760, -1280, -3904)
jukebox.setMusicBox(760, -1120, -3840)
jukebox.setMusicBox(760, -1120, -3776)
jukebox.setMusicBox(760, -1280, -3776)
jukebox.setMusicBox(760, -1280, -3712)
jukebox.setMusicBox(760, -1120, -3648)
jukebox.setMusicBox(760, -1120, -3584)
jukebox.setMusicBox(760, -1280, -3584)
jukebox.setMusicBox(760, -1280, -3520)
jukebox.setMusicBox(760, -1184, -3520)
jukebox.setMusicBox(760, -1088, -3520)
jukebox.setMusicBox(760, -1184, -3072)
    
--Me and Larry City HUB, Convienent Level Choosing World
jukebox.setTrack(761, jukebox.resolveMusicFile("_OST/Me and Larry City/World Music/Dreamy Somnom Labyrinth (M&L - Dream Team).ogg"))
jukebox.setMusicBox(761, -3168, -1600)
jukebox.setMusicBox(761, -3168, -1536)
--jukebox.setMusicBox(761, -3040, -1536)

--Lava Lands 1
jukebox.setTrack(763, jukebox.resolveMusicFile("_OST/Lava Lands/World Music/Escape!!!.ogg"))
jukebox.setMusicBox(763, 4736, 704)
jukebox.setMusicBox(763, 4736, 608)
--Lava Lands 2
jukebox.setMusicBox(763, -3040, -2080)
jukebox.setMusicBox(763, -3040, -2144)
--Lava Lands 3
jukebox.setMusicBox(763, 5664, 2912)
--Lava Lands 4
jukebox.setMusicBox(763, -1184, -3040)
jukebox.setMusicBox(763, -1184, -2976)
jukebox.setMusicBox(763, -1184, -2912)

--SMBS World 1
jukebox.setTrack(772, jukebox.resolveMusicFile("_OST/Super Mario Bros Spencer/World Music/World 1.ogg"))
jukebox.setMusicBox(772, 0, -1088)
jukebox.setMusicBox(772, 640, -1152)

--SMBS World 2
jukebox.setTrack(773, jukebox.resolveMusicFile("_OST/Super Mario Bros Spencer/World Music/World 2.ogg"))
jukebox.setMusicBox(773, 1152, -1376)
jukebox.setMusicBox(773, 1536, -1856)

--SMW Chocolate Desert
jukebox.setTrack(774, jukebox.resolveMusicFile("_OST/Super Mario World/World Music/Chocolate Desert.ogg"))
jukebox.setMusicBox(774, 7584, 1280)
jukebox.setMusicBox(774, 7168, 1440)
jukebox.setMusicBox(774, 7392, 1312)

--SMBLL Worlds A-D
jukebox.setTrack(775, jukebox.resolveMusicFile("_OST/The Lost Levels/Worlds A-D.ogg"))
jukebox.setMusicBox(775, 5088, 4896)
jukebox.setMusicBox(775, 5088, 5088)

return map_music