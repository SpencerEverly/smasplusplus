local loadscreensound = {}

local loadingsoundFile = Misc.resolveSoundFile("_OST/All Stars Menu/Loading Screen.ogg")

function loadscreensound.onLoad()
    loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
    loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
end

function loadscreensound.onStart()
    loadingSoundObject:FadeOut(500)
end

return loadscreensound