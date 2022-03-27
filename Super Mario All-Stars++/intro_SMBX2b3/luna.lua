local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

local rng = API.load("rng")

local songList = {};
local fileList = Misc.listLocalFiles(".");
local mediaExtensions = {".wav", ".aiff", ".voc", ".mod", ".xm", ".s3m", ".it", ".669", ".mid", ".midi", ".ogg", ".mp3", ".flac", ".apun", ".dsm", ".far", ".amf", ".gdm", ".imf", ".med", ".mtm", ".okt", ".stm", ".stx", ".ult", ".uni", ".spc", ".nsf", ".hes", ".vgm"}
local globalData = Data(Data.DATA_GLOBAL, "systemData")

function onLoad()
	for _, i in pairs(fileList) do
		for _, j in pairs(mediaExtensions) do
			if string.match(i, j) then
				table.insert(songList, i)
			end
		end
	end
	if #songList ~= 0 then
		Audio.SeizeStream(0)
		songToPlay = songList[rng.randomInt(1, #songList)]
		Audio.MusicOpen(songToPlay)
		Audio.MusicPlay()
		globalData:set("loadedIntroSong", Audio.MusicTitle())
		globalData:save()
	end
end

function onStart()
	Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end