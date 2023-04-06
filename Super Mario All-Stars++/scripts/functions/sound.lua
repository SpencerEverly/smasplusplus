local Sound = {}

local extrasounds = require("extrasounds")
local playerManager = require("playermanager")
local smastables = require("smastables")

if GameData.levelMusicTemporary == nil then
    GameData.levelMusicTemporary = {}
end

if GameData.levelMusic == nil then
    GameData.levelMusic = {}
end

function Sound.onInitAPI()
    registerEvent(Sound,"onDraw")
end

local started = false

Sound.soundDelays = {}
Sound.soundDelayArray = {}
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

function Sound.multiResolveFile(...)
	local t = {...}
	
	--If passed a complete path, just return it as-is (as long as the file exists)
	for _,v in ipairs(t) do
		if string.match(v, "^%a:[\\/]") and io.exists(v) then
			return v
		end
	end

	for _,p in ipairs(Sound.resolvePaths) do
		for _,v in ipairs(t) do
			if io.exists(p..v) then
				return p..v
			end
		end
	end
	return nil
end

local validAudioFiles = {".ogg", ".mp3", ".wav", ".voc", ".flac", ".spc"}
	
--table.map doesn't exist yet
local validFilesMap = {};
for _,v in ipairs(validAudioFiles) do
    validFilesMap[v] = true;
end

function Sound.resolveSoundFile(path)
    local p,e = string.match(string.lower(path), "^(.+)(%..+)$")
    local t = {}
    local idx = 1
    local typeslist = validAudioFiles
    if e and validFilesMap[e] then
        --Re-arrange type list to prioritise type that was provided to the resolve function
        if e ~= validAudioFiles[1] then
            typeslist = { e }
            for _,v in ipairs(validAudioFiles) do
                if v ~= e then
                    table.insert(typeslist, v)
                end
            end
        end
        path = p
    end
    for _,typ in ipairs(typeslist) do
        t[idx] = path..typ
        t[idx+#typeslist] = "sound/"..path..typ
        t[idx+2*#typeslist] = "sound/extended/"..path..typ
        idx = idx+1
    end
    
    return Sound.multiResolveFile(table.unpack(t))
end

function Sound.openSFX(name) --Opening SFXs
    console:println("Opening '"..name.."'...")
    return Audio.SfxOpen(Misc.resolveSoundFile(name))
        or Audio.SfxOpen(Misc.resolveSoundFile("_OST/" .. name))
        or Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/"..name))
        or Audio.SfxOpen(Misc.resolveSoundFile("costumes/" .. name))
        or Audio.SfxOpen(Misc.resolveSoundFile("scripts/" .. name))
        or Audio.SfxOpen(Misc.resolveSoundFile("sound/" .. name))
        or Audio.SfxOpen(Misc.resolveSoundFile("___MainUserDirectory/" .. name))
end

function Sound.playSFX(name, volume, loops, delay) --If you want to play any sound, you can use Sound.playSFX(id), or you can use a string (You can also optionally play the sound with a volume, loop, and/or delay). This is similar to SFX.play, but with extrasounds support!
    console:println("Playing sound '"..name.."'...")
    
    if unexpected_condition then error("That sound doesn't exist. Play something else.") end
    
    if name == nil then
        error("That sound doesn't exist. Play something else.")
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
    
    if loops ~= nil then
        loops = loops - 1
    end
    
    local obj
    
    local eventObj = {cancelled = false}
    EventManager.callEvent("onPlaySFX", eventObj, name, volume, loops, delay)
    
    if not eventObj.cancelled then
        Sound.soundDelays[name] = delay
        table.insert(Sound.soundDelayArray, name)
        if Sound.isExtraSoundsActive() then
            if not smastables.stockSoundNumbersInOrder[name] and extrasounds.sounds[name] then
                obj = Audio.SfxPlayObjVol(extrasounds.sounds[name].sfx, loops, math.min(volume*128,128))
            elseif smastables.stockSoundNumbersInOrder[name] then
                obj = Audio.SfxPlayObjVol(Audio.sounds[name].sfx, loops, math.min(volume*128,128))
            elseif name then
                local file = Sound.resolveSoundFile(name) --Common sound directories, see above for the entire list
                if file ~= nil then
                    finalFile = Audio.SfxOpen(file)
                    obj = Audio.SfxPlayObjVol(finalFile, loops, math.min(volume*128,128)) --Then play it afterward
                end
            end
        elseif not Sound.isExtraSoundsActive() then
            if smastables.allVanillaSoundNumbersInOrder[name] then
                obj = Audio.SfxPlayObjVol(Audio.sounds[name].sfx, loops, math.min(volume*128,128))
            elseif name then
                local file = Sound.resolveSoundFile(name) --Common sound directories, see above for the entire list
                if file ~= nil then
                    finalFile = Audio.SfxOpen(file)
                    obj = Audio.SfxPlayObjVol(finalFile, loops, math.min(volume*128,128)) --Then play it afterward
                end
            end
        end
        
        EventManager.callEvent("onPostPlaySFX", name, volume, loops, delay)
        
        return obj
    end
end

function Sound.clearUnusedCostumeSounds()
    if SMBX_VERSION ~= VER_SEE_MOD then
        Misc.warn("You are using the original LunaLua, and not the SEE Mod for this command. Please retrieve the SEE Mod by downloading it over at this website: https://github.com/SpencerEverly/smbx2-seemod")
        console:println("NOT USING SEE MOD! Costume sound refresher has stopped.")
        return
    else
        for k,v in ipairs(smastables.soundNamesInOrder) do
            if (smastables.previouslyCachedSoundFiles[k] ~= smastables.currentlyCachedSoundFiles[k]) then
                console:println("Unmatched sound detected: "..smastables.previouslyCachedSoundFiles[k]..", will clear off from cache until next reload...")
                CacheSystem.ClearSpecifiedSoundFromCache(smastables.previouslyCachedSoundFiles[k])
            end
        end
    end
end

function Sound.resolveCostumeSound(name, stringOnly) --Resolve a sound for a costume being worn.
    if stringOnly == nil then
        stringOnly = false
    end
    local costumeSoundDir
    if not SaveData.disableX2char then
        if SaveData.currentCostume == "N/A" then
            costumeSoundDir = Misc.resolveSoundFile(name)
        else
            costumeSoundDir = Misc.resolveSoundFile("costumes/"..playerManager.getName(player.character).."/"..SaveData.currentCostume.."/"..name)
        end
    elseif SaveData.disableX2char then
        costumeSoundDir = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/"..name)
    end
    if not stringOnly then
        if costumeSoundDir ~= nil then
            return Audio.SfxOpen(costumeSoundDir)
        else
            return Audio.SfxOpen(Misc.resolveSoundFile(name))
        end
    else
        if costumeSoundDir ~= nil then
            return costumeSoundDir
        else
            return Misc.resolveSoundFile(name)
        end
    end
    
    if costumeSoundDir ~= nil then
        console:println("Character sound '"..costumeSoundDir.."' loaded.")
    else
        console:println("Character sound '"..name.."' loaded.")
    end
end

function Sound.loadCostumeSounds() --Load up the sounds when a costume is being worn. If there is no costume, it'll load up stock sounds instead.
    for k,v in ipairs(smastables.soundNamesInOrder) do
        smastables.previouslyCachedSoundFiles[k] = smastables.currentlyCachedSoundFiles[k]
        
        if not smastables.stockSoundNumbersInOrder[k] then
            extrasounds.sounds[k].sfx = Sound.resolveCostumeSound(v)
        elseif smastables.stockSoundNumbersInOrder[k] then
            Audio.sounds[k].sfx = Sound.resolveCostumeSound(v)
        end
        
        smastables.currentlyCachedSoundFiles[k] = Sound.resolveCostumeSound(v, true)
    end
    
    --[[for i = 1, #smastables.soundNamesInOrder do
        local cachedSounds = {}
        if cachedSounds[i] == nil then
            cachedSounds[i] = Sound.resolveCostumeSound(smastables.soundNamesInOrder[i])
        end
        extrasounds.sounds[i].sfx = cachedSounds[i]
        if i <= 91 then
            Audio.sounds[i].sfx = cachedSounds[i]
        end
    end]]
end

function Sound.cleanupCostumeSounds()
    for k,v in ipairs(smastables.soundNamesInOrder) do
        if not smastables.stockSoundNumbersInOrder[k] then
            extrasounds.sounds[k].sfx = nil
        elseif smastables.stockSoundNumbersInOrder[k] then
            Audio.sounds[k].sfx = nil
        end
    end
end

function Sound.isExtraSoundsActive()
    if extrasounds then
        return extrasounds.active
    else
        return false
    end
end

function Sound.changeMusic(name, sectionid) --Music changing is now a LOT easier
    local eventObj = {cancelled = false}
    
    EventManager.callEvent("onChangeMusic", eventObj, name, sectionid)
    
    if not eventObj.cancelled then
        if sectionid == -1 then --If -1, all section music will change to the specified song
            console:println("All music will be changed to '"..tostring(name).."'.")
            for i = 0,20 do
                Section(i).music = name
                if smasbooleans then
                    if smasbooleans.musicMuted then
                        Sound.refreshMusic(i)
                        Sound.muteMusic(i)
                    end
                end
            end
        elseif sectionid >= 0 or sectionid <= 20 then
            console:println("Music from section "..tostring(sectionid).." will be changed to '"..tostring(name).."'.")
            Section(sectionid).music = name
            if smasbooleans then
                if smasbooleans.musicMuted then
                    Sound.refreshMusic(sectionid)
                    Sound.muteMusic(sectionid)
                end
            end
        elseif sectionid >= 21 then
            error("That's higher than SMBX2 can go. Go to a lower section than that.")
            return
        end
        EventManager.callEvent("onPostChangeMusic", name, sectionid)
    end
end

function Sound.muteMusic(sectionid) --Mute all section music, or just mute a specific section
    if sectionid == -1 then --If -1, all section music will be muted
        console:println("Muting music on all sections...")
        for i = 0,20 do
            musiclist = {Section(i).music}
            GameData.levelMusicTemporary[i] = Section(i).music
            Audio.MusicChange(i, 0)
        end
        if smasbooleans then
            console:println("smasbooleans music muted boolean set to true.")
            smasbooleans.musicMutedTemporary = true
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        console:println("Muting music on section "..tostring(sectionid).."...")
        musiclist = {Section(sectionid).music}
        GameData.levelMusicTemporary[sectionid] = Section(sectionid).music
        Audio.MusicChange(sectionid, 0)
        if smasbooleans then
            console:println("smasbooleans music muted boolean set to true.")
            smasbooleans.musicMutedTemporary = true
        end
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
        return
    end
end

function Sound.restoreMusic(sectionid) --Restore all section music, or just restore a specific section
    if sectionid == -1 then --If -1, all section music will be restored
        console:println("Restoring music on all sections...")
        for i = 0,20 do
            songname = GameData.levelMusicTemporary[i]
            Section(i).music = songname
        end
        if smasbooleans then
            console:println("smasbooleans music muted boolean set to false.")
            smasbooleans.musicMutedTemporary = false
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        console:println("Restoring music on section "..tostring(sectionid).."...")
        songname = GameData.levelMusicTemporary[sectionid]
        Section(sectionid).music = songname
        if smasbooleans then
            console:println("smasbooleans music muted boolean set to false.")
            smasbooleans.musicMutedTemporary = false
        end
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
        return
    end
end

function Sound.refreshMusic(sectionid) --Refresh the music that's currently playing by updating the music table
    if sectionid == -1 then --If -1, all section music will be counted
        console:println("Refreshing music on all sections...")
        for i = 0,20 do
            musiclist = {Section(i).music}
            GameData.levelMusicTemporary[i] = Section(i).music
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        console:println("Refreshing music on section "..tostring(sectionid).."...")
        musiclist = {Section(sectionid).music}
        GameData.levelMusicTemporary[sectionid] = Section(sectionid).music
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
        return
    end
end

function Sound.restoreOriginalMusic(sectionid) --Restore all original section music, or just restore a specific section
    if sectionid == -1 then --If -1, all section music will be restored
        if GameData.levelMusic ~= {} then
            console:println("Refreshing originally stored music on all sections...")
            for i = 0,20 do
                songname = GameData.levelMusic[i]
                Section(i).music = songname
            end
        else
            return
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        if GameData.levelMusic ~= {} then
            console:println("Refreshing originally stored music on section "..tostring(sectionid).."...")
            songname = GameData.levelMusic[sectionid]
            Section(sectionid).music = songname
        else
            return
        end
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
        return
    end
end

function Sound.getMusicID(sectionNumber)
    if sectionNumber >= 0 or sectionNumber <= 20 then
        return mem(mem(0x00B25828, FIELD_DWORD) + 2*sectionNumber, FIELD_WORD)
    elseif sectionNumber >= 21 or sectionNumber <= -1 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
        return
    end
end

function Sound.getCustomMusicFromSection(sectionNumber)
    if sectionNumber >= 0 or sectionNumber <= 20 then
        return mem(mem(0x00B257B8, FIELD_DWORD) + 4*sectionNumber, FIELD_STRING)
    elseif sectionNumber >= 21 or sectionNumber <= -1 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
        return
    end
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

function Sound.startupRefreshSystem()
    if started then
        error("This function can only be started once!")
        return
    elseif not started then
        for i = 0,20 do
            GameData.levelMusic[i] = Section(i).music
        end
        for i = 0,20 do
            GameData.levelMusicTemporary[i] = Section(i).music
        end
        console:println("Music refresh system has been set up.")
        started = true
    end
end

function Sound.checkPWingSoundStatus()
    if SaveData.disablePWingSFX then
        console:println("P-Wing sound effect setting has been set to disabled.")
        extrasounds.enablePWingSFX = false
    elseif not SaveData.disablePWingSFX then
        console:println("P-Wing sound effect setting has been set to enabled.")
        extrasounds.enablePWingSFX = true
    end
end

function Sound.checkSMBXSoundSystemStatus()
    if SaveData.SMBXSoundSystem then
        console:println("Original SMBX sound system setting has been set to disabled.")
        extrasounds.enableGrabShellSFX = false
        extrasounds.playPSwitchTimerSFX = false
        extrasounds.enableSMB2EnemyKillSounds = false
        extrasounds.useOriginalSpinJumpForBigEnemies = true
        extrasounds.enableHPCollecting = false
        extrasounds.useOriginalDragonCoinSounds = true
        extrasounds.useOriginalBowserFireballInstead = true
        extrasounds.enableIceBlockBreaking = false
        extrasounds.useOriginalBlockSproutInstead = true
        extrasounds.useFireworksInsteadOfOtherExplosions = true
        extrasounds.use1UPSoundForAll1UPs = true
        extrasounds.useJumpSoundInsteadWhenUnmountingYoshi = true
        extrasounds.enableBoomerangBroBoomerangSFX = false
        extrasounds.enableToadBoomerangSFX = false
        extrasounds.useFireSoundForHammerSuit = true
        extrasounds.useFireSoundForIce = true
    elseif not SaveData.SMBXSoundSystem then
        console:println("Original SMBX sound system setting has been set to enabled.")
        extrasounds.enableGrabShellSFX = true
        extrasounds.playPSwitchTimerSFX = true
        extrasounds.enableSMB2EnemyKillSounds = true
        extrasounds.useOriginalSpinJumpForBigEnemies = false
        extrasounds.enableHPCollecting = true
        extrasounds.useOriginalDragonCoinSounds = false
        extrasounds.useOriginalBowserFireballInstead = false
        extrasounds.enableIceBlockBreaking = true
        extrasounds.useOriginalBlockSproutInstead = false
        extrasounds.useFireworksInsteadOfOtherExplosions = false
        extrasounds.use1UPSoundForAll1UPs = false
        extrasounds.useJumpSoundInsteadWhenUnmountingYoshi = false
        extrasounds.enableBoomerangBroBoomerangSFX = true
        extrasounds.enableToadBoomerangSFX = true
        extrasounds.useFireSoundForHammerSuit = false
        extrasounds.useFireSoundForIce = false
    end
end

function Sound.changeMusicRNG(songTable, sectionNumber)
    if songTable == nil then
        error("Must have a table to RNG music!")
        return
    end
    local musicCount = #songtable
    if sectionNumber == -1 then
        for i = 0,20 do
            Sound.changeMusic(songTable[RNG.randomInt(1,musicCount)], i)
        end
    elseif sectionNumber >= 0 or sectionNumber <= 20 then
        Sound.changeMusic(songTable[RNG.randomInt(1,musicCount)], sectionNumber)
    else
        error("Section ID is invalid.")
        return
    end
end

function Sound.onDraw()
    for i = #Sound.soundDelayArray,1,-1 do
        local s = Sound.soundDelayArray[i]
        if(Sound.soundDelays[s] > 0) then
            Sound.soundDelays[s] = Sound.soundDelays[s] - 1
        else
            Sound.soundDelays[s] = nil;
            table.remove(Sound.soundDelayArray, i)
        end
    end
end




return Sound