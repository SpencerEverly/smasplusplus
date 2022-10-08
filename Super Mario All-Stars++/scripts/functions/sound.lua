local Sound = {}

local extrasounds = require("extrasounds")
local playerManager = require("playermanager")
local smastables = require("smastables")

function Sound.onInitAPI()
    registerEvent(Sound,"onDraw")
end

Sound.resolvePaths = {
    Misc.levelPath(),
    Misc.episodePath(),
    getSMBXPath().."\\scripts\\",
    getSMBXPath().."\\",
    Misc.episodePath().."\\_OST\\",
    Misc.episodePath().."\\_OST\\_Sound Effects\\",
    Misc.episodePath().."\\costumes\\",
    Misc.episodePath().."\\scripts\\",
    Misc.episodePath().."\\sound\\",
    Misc.episodePath().."\\___MainUserDirectory\\",
}

function Sound.openSFX(name) --Opening SFXs
    return SFX.open(name)
        or SFX.open("_OST/" .. name)
        or SFX.open("_OST/_Sound Effects/"..name)
        or SFX.open("costumes/" .. name)
        or SFX.open("scripts/" .. name)
        or SFX.open("sound/" .. name)
        or SFX.open("___MainUserDirectory/" .. name)
end

function Sound.playSFX(name, volume, loops, delay) --If you want to play any sound, you can use Sound.playSFX(id), or you can use a string (You can also optionally play the sound with a volume, loop, and/or delay). This is similar to SFX.play, but with extrasounds support!
    if unexpected_condition then error("That sound doesn't exist. Play something else.") end
    
    if name == nil then
        error("That sound doesn't exist. Play something else.")
        return
    end
    
    local eventObj = {cancelled = false}
    EventManager.callEvent("onPlaySFX", eventObj, name, volume, loops, delay)
    
    if eventObj.cancelled then
        return
    end
    
    if volume == nil then
        volume = extrasounds.volume
    end
    if extrasounds.volume == nil then
        volume = 1
    end
    if loops == nil then
        loops = 1
    end
    if delay == nil then
        delay = 4
    end
    
    if Sound.isExtraSoundsActive() then
        if extrasounds.sound.sfx[name] and not smastables.stockSoundNumbersInOrder[name] then
            SFX.play(extrasounds.sound.sfx[name], volume, loops, delay)
        elseif smastables.stockSoundNumbersInOrder[name] then
            SFX.play(name, volume, loops, delay)
        elseif name then
            local file = Misc.resolveSoundFile(name) or Misc.resolveSoundFile("_OST/"..name) or Misc.resolveSoundFile("_OST/_Sound Effects/"..name) or Misc.resolveSoundFile("costumes/"..name) or Misc.resolveSoundFile("___MainUserDirectory/"..name) --Common sound directories, see above for the entire list
            SFX.play(file, volume, loops, delay) --Then play it afterward
        end
    elseif not Sound.isExtraSoundsActive() then
        if extrasounds.allVanillaSoundNumbersInOrder[name] then
            SFX.play(name, volume, loops, delay)
        elseif name then
            local file = Misc.resolveSoundFile(name) or Misc.resolveSoundFile("_OST/"..name) or Misc.resolveSoundFile("_OST/_Sound Effects/"..name) or Misc.resolveSoundFile("costumes/"..name) or Misc.resolveSoundFile("___MainUserDirectory/"..name) --Common sound directories, see above for the entire list
            SFX.play(file, volume, loops, delay) --Then play it afterward
        end
    end
    
    EventManager.callEvent("onPostPlaySFX", name, volume, loops, delay)
end

function Sound.resolveCostumeSound(name) --Resolve a sound for a costume being worn.
    local costumesounddir
    if SaveData.currentCostume == "N/A" then
        costumesounddir = Misc.resolveSoundFile(name)
    else
        costumesounddir = Misc.resolveSoundFile("costumes/"..playerManager.getName(player.character).."/"..player:getCostume().."/"..name)
    end
    if costumesounddir ~= nil then
        return Audio.SfxOpen(costumesounddir)
    else
        return Audio.SfxOpen(Misc.resolveSoundFile(name))
    end
end

function Sound.loadCostumeSounds() --Load up the sounds when a costume is being worn. If there is no costume, it'll load up stock sounds instead.
    for k,v in ipairs(smastables.soundNamesInOrder) do
        if smastables.extrasoundsNumbersInOrder[k] then
            extrasounds.sound.sfx[k] = Sound.resolveCostumeSound(v)
        else
            Audio.sounds[k].sfx = Sound.resolveCostumeSound(v)
        end
    end
end

function Sound.isExtraSoundsActive()
    return extrasounds.active
end

function Sound.changeMusic(name, sectionid) --Music changing is now a LOT easier
    local eventObj = {cancelled = false}
    
    EventManager.callEvent("onChangeMusic", eventObj, name, sectionid)
    if eventObj.cancelled then return end
    
    if sectionid == -1 then --If -1, all section music will change to the specified song
        for i = 0,20 do
            Section(i).music = name
            if smasbooleans.musicMuted then
                Sound.refreshMusic(i)
                Sound.muteMusic(i)
            end
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        Section(sectionid).music = name
        if smasbooleans.musicMuted then
            Sound.refreshMusic(sectionid)
            Sound.muteMusic(sectionid)
        end
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
    end
    EventManager.callEvent("onPostChangeMusic", name, sectionid)
end

function Sound.muteMusic(sectionid) --Mute all section music, or just mute a specific section
    if sectionid == -1 then --If -1, all section music will be muted
        for i = 0,20 do
            musiclist = {Section(i).music}
            GameData.levelMusicTemporary[i] = Section(i).music
            Audio.MusicChange(i, 0)
        end
        smasbooleans.musicMutedTemporary = true
    elseif sectionid >= 0 or sectionid <= 20 then
        musiclist = {Section(sectionid).music}
        GameData.levelMusicTemporary[sectionid] = Section(sectionid).music
        Audio.MusicChange(sectionid, 0)
        smasbooleans.musicMutedTemporary = true
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
    end
end

function Sound.restoreMusic(sectionid) --Restore all section music, or just restore a specific section
    if sectionid == -1 then --If -1, all section music will be restored
        for i = 0,20 do
            songname = GameData.levelMusicTemporary[i]
            Section(i).music = songname
        end
        smasbooleans.musicMutedTemporary = false
    elseif sectionid >= 0 or sectionid <= 20 then
        songname = GameData.levelMusicTemporary[sectionid]
        Section(sectionid).music = songname
        smasbooleans.musicMutedTemporary = false
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
    end
end

function Sound.refreshMusic(sectionid) --Refresh the music that's currently playing by updating the music table
    if sectionid == -1 then --If -1, all section music will be counted
        for i = 0,20 do
            musiclist = {Section(i).music}
            GameData.levelMusicTemporary[i] = Section(i).music
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        musiclist = {Section(sectionid).music}
        GameData.levelMusicTemporary[sectionid] = Section(sectionid).music
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
    end
end

function Sound.restoreOriginalMusic(sectionid) --Restore all original section music, or just restore a specific section
    if sectionid == -1 then --If -1, all section music will be restored
        for i = 0,20 do
            songname = GameData.levelMusic[i]
            Section(i).music = songname
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        songname = GameData.levelMusic[sectionid]
        Section(sectionid).music = songname
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
    end
end

function Sound.getMusicID(sectionNumber)
    return mem(mem(0x00B25828, FIELD_DWORD) + 2*sectionNumber, FIELD_WORD)
end

function Sound.getCustomMusicFromSection(sectionNumber)
    return mem(mem(0x00B257B8, FIELD_DWORD) + 4*sectionNumber, FIELD_STRING)
end

function Sound.enablePSwitchMusic(bool)
    if bool == nil then
        return
    elseif bool == true then
        mem(0x00B25888, FIELD_DWORD, -1)
    else
        mem(0x00B25888, FIELD_DWORD, Sound.getMusicID(player.sectionObj.idx))
    end
end




function Sound.onDraw()
    
end




return Sound