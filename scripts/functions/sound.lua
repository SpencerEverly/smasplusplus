local Sound = {}

local smasExtraSounds = require("smasExtraSounds")
local playerManager = require("playermanager")
local smasTables = require("smasTables")
local audiomasterSMAS = require("scripts/audiomasterSMAS")

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
    SysManager.sendToConsole("Opening '"..name.."'...")
    return Audio.SfxOpen(Sound.resolveSoundFile(name))
end

function Sound.playSFX(name, volume, loops, delay, pan) --If you want to play any sound, you can use Sound.playSFX(id), or you can use a string (You can also optionally play the sound with a volume, loop, and/or delay). This is similar to SFX.play, but with smasExtraSounds support!
    SysManager.sendToConsole("Playing sound '"..name.."'...")
    
    if unexpected_condition then error("That sound doesn't exist. Play something else.") end
    
    if name == nil then
        error("That sound doesn't exist. Play something else.")
        return
    end
    
    if volume == nil then
        volume = smasExtraSounds.volume
    end
    if smasExtraSounds.volume == nil then
        volume = 1
    end
    if loops == nil then
        loops = 1
    end
    if delay == nil then
        delay = 4
    end
    if pan == nil then
        pan = 0
    end
    
    local eventObj = {cancelled = false}
    EventManager.callEvent("onPlaySFX", eventObj, name, volume, loops, delay, pan)
    
    if not eventObj.cancelled then
        if Sound.isExtraSoundsActive() then
            if name == 0 then
                audiomasterSMAS.PlaySound({sound = "nothing.ogg", volume = volume, loops = loops, delay = delay, pan = pan})
            elseif not smasTables.stockSoundNumbersInOrder[name] and smasExtraSounds.sounds[name] then
                if not smasExtraSounds.sounds[name].muted then
                    audiomasterSMAS.PlaySound({sound = smasExtraSounds.sounds[name].sfx, volume = volume, loops = loops, delay = delay, pan = pan})
                end
            elseif smasTables.stockSoundNumbersInOrder[name] then
                audiomasterSMAS.PlaySound({sound = Audio.sounds[name].sfx, volume = volume, loops = loops, delay = delay, pan = pan})
            elseif name then
                local file = Sound.resolveSoundFile(name) --Common sound directories, see above for the entire list
                audiomasterSMAS.PlaySound({sound = file, volume = volume, loops = loops, delay = delay, pan = pan}) --Play it afterward
            end
        elseif not Sound.isExtraSoundsActive() then
            if name == 0 then
                audiomasterSMAS.PlaySound({sound = "nothing.ogg", volume = volume, loops = loops, delay = delay, pan = pan})
            elseif smasTables.allVanillaSoundNumbersInOrder[name] then
                audiomasterSMAS.PlaySound({sound = Audio.sounds[name].sfx, volume = volume, loops = loops, delay = delay, pan = pan})
            elseif name then
                local file = Sound.resolveSoundFile(name) --Common sound directories, see above for the entire list
                audiomasterSMAS.PlaySound({sound = file, volume = volume, loops = loops, delay = delay, pan = pan}) --Play it afterward
            end
        end
        EventManager.callEvent("onPostPlaySFX", name, volume, loops, delay, pan)
    end
end

function Sound.clearUnusedCostumeSounds()
    if lunatime.tick() > 10 then
        if SMBX_VERSION ~= VER_SEE_MOD then
            Misc.warn("You are using the original LunaLua, and not the SEE Mod for this command. Please retrieve the SEE Mod by downloading it over at this website: https://github.com/SpencerEverly/smbx2-seemod")
            SysManager.sendToConsole("NOT USING SEE MOD! Costume sound refresher has stopped.")
            return
        else
            for k,v in ipairs(smasTables.soundNamesInOrder) do
                if (smasTables.previouslyCachedSoundFiles[k] ~= smasTables.currentlyCachedSoundFiles[k]) then
                    SysManager.sendToConsole("Unmatched sound detected: "..smasTables.previouslyCachedSoundFiles[k]..", will clear off from cache until next reload...")
                    if Audio.SfxIsInCache(smasTables.previouslyCachedSoundFiles[k]) then
                        Audio.SfxClearFromCache(smasTables.previouslyCachedSoundFiles[k])
                    end
                end
            end
        end
    end
end

function Sound.resolveCostumeSound(name, stringOnly) --Resolve a sound for a costume being worn.
    if stringOnly == nil then
        stringOnly = false
    end
    local costumeSoundDir
    if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        if SaveData.SMASPlusPlus.player[1].currentCostume == "N/A" and SaveData.SMASPlusPlus.player[1].currentAlteration == "N/A" then
            costumeSoundDir = Sound.resolveSoundFile(name)
        elseif SaveData.SMASPlusPlus.player[1].currentCostume ~= "N/A" and SaveData.SMASPlusPlus.player[1].currentAlteration == "N/A" then
            costumeSoundDir = Sound.resolveSoundFile("costumes/"..playerManager.getName(player.character).."/"..SaveData.SMASPlusPlus.player[1].currentCostume.."/"..name)
        elseif SaveData.SMASPlusPlus.player[1].currentAlteration ~= "N/A" then
            if SaveData.SMASPlusPlus.player[1].currentCostume ~= "N/A" then
                costumeSoundDir = Sound.resolveSoundFile("alterations/"..playerManager.getName(player.character).."/!!!costumes/"..SaveData.SMASPlusPlus.player[1].currentCostume.."/"..SaveData.SMASPlusPlus.player[1].currentAlteration.."/"..name)
                if costumeSoundDir == nil then
                    costumeSoundDir = Sound.resolveSoundFile("costumes/"..playerManager.getName(player.character).."/"..SaveData.SMASPlusPlus.player[1].currentCostume.."/"..name)
                end
            else
                costumeSoundDir = Sound.resolveSoundFile("alterations/"..playerManager.getName(player.character).."/"..SaveData.SMASPlusPlus.player[1].currentAlteration.."/"..name)
                if costumeSoundDir == nil then
                    costumeSoundDir = Sound.resolveSoundFile(name)
                end
            end
        end
    elseif SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        costumeSoundDir = Sound.resolveSoundFile("_OST/_Sound Effects/1.3Mode/"..name)
    end
    if not stringOnly then
        if costumeSoundDir ~= nil then
            return Audio.SfxOpen(costumeSoundDir)
        else
            return Audio.SfxOpen(Sound.resolveSoundFile(name))
        end
    else
        if costumeSoundDir ~= nil then
            return costumeSoundDir
        else
            return Sound.resolveSoundFile(name)
        end
    end
    
    if costumeSoundDir ~= nil then
        SysManager.sendToConsole("Character sound '"..costumeSoundDir.."' loaded.")
    else
        SysManager.sendToConsole("Character sound '"..name.."' loaded.")
    end
end

function Sound.loadCostumeSounds() --Load up the sounds when a costume is being worn. If there is no costume, it'll load up stock sounds instead.
    for k,v in ipairs(smasTables.soundNamesInOrder) do
        smasTables.previouslyCachedSoundFiles[k] = smasTables.currentlyCachedSoundFiles[k]
        
        if not smasTables.stockSoundNumbersInOrder[k] then
            smasExtraSounds.sounds[k].sfx = Sound.resolveCostumeSound(v)
        elseif smasTables.stockSoundNumbersInOrder[k] then
            Audio.sounds[k].sfx = Sound.resolveCostumeSound(v)
        end
        
        smasTables.currentlyCachedSoundFiles[k] = Sound.resolveCostumeSound(v, true)
    end
    Sound.clearUnusedCostumeSounds()
end

function Sound.cleanupCostumeSounds()
    for k,v in ipairs(smasTables.soundNamesInOrder) do
        if not smasTables.stockSoundNumbersInOrder[k] then
            if SMBX_VERSION == VER_SEE_MOD then
                Audio.SfxClearFromCache(smasExtraSounds.sounds[k].sfx)
            end
            smasExtraSounds.sounds[k].sfx = nil
        elseif smasTables.stockSoundNumbersInOrder[k] then
            Audio.sounds[k].sfx = nil
        end
    end
end

function Sound.isExtraSoundsActive()
    if smasExtraSounds then
        return smasExtraSounds.active
    else
        return false
    end
end

function Sound.changeMusic(name, sectionid, canRefreshWhenMuted) --Music changing is now a LOT easier
    canRefreshWhenMuted = canRefreshWhenMuted or true
    
    local eventObj = {cancelled = false}
    
    EventManager.callEvent("onChangeMusic", eventObj, name, sectionid)
    
    if not eventObj.cancelled then
        if sectionid == -1 then --If -1, all section music will change to the specified song
            SysManager.sendToConsole("All music will be changed to '"..tostring(name).."'.")
            for i = 0,20 do
                Section(i).music = name
                if smasBooleans then
                    if smasBooleans.musicMuted and canRefreshWhenMuted then
                        Sound.refreshMusic(i)
                        Sound.muteMusic(i)
                    end
                end
            end
        elseif sectionid >= 0 or sectionid <= 20 then
            SysManager.sendToConsole("Music from section "..tostring(sectionid).." will be changed to '"..tostring(name).."'.")
            Section(sectionid).music = name
            if smasBooleans then
                if smasBooleans.musicMuted and canRefreshWhenMuted then
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
        SysManager.sendToConsole("Muting music on all sections...")
        for i = 0,20 do
            musiclist = {Section(i).music}
            GameData.levelMusicTemporary[i] = Section(i).music
            Audio.MusicChange(i, 0)
        end
        if smasBooleans then
            SysManager.sendToConsole("smasBooleans music muted boolean set to true.")
            smasBooleans.musicMutedTemporary = true
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        SysManager.sendToConsole("Muting music on section "..tostring(sectionid).."...")
        musiclist = {Section(sectionid).music}
        GameData.levelMusicTemporary[sectionid] = Section(sectionid).music
        Audio.MusicChange(sectionid, 0)
        if smasBooleans then
            SysManager.sendToConsole("smasBooleans music muted boolean set to true.")
            smasBooleans.musicMutedTemporary = true
        end
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
        return
    end
end

function Sound.restoreMusic(sectionid) --Restore all section music, or just restore a specific section
    if sectionid == -1 then --If -1, all section music will be restored
        SysManager.sendToConsole("Restoring music on all sections...")
        for i = 0,20 do
            songname = GameData.levelMusicTemporary[i]
            Section(i).music = songname
        end
        if smasBooleans then
            SysManager.sendToConsole("smasBooleans music muted boolean set to false.")
            smasBooleans.musicMutedTemporary = false
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        SysManager.sendToConsole("Restoring music on section "..tostring(sectionid).."...")
        songname = GameData.levelMusicTemporary[sectionid]
        Section(sectionid).music = songname
        if smasBooleans then
            SysManager.sendToConsole("smasBooleans music muted boolean set to false.")
            smasBooleans.musicMutedTemporary = false
        end
    elseif sectionid >= 21 then
        error("That's higher than SMBX2 can go. Go to a lower section than that.")
        return
    end
end

function Sound.refreshMusic(sectionid) --Refresh the music that's currently playing by updating the music table
    if sectionid == -1 then --If -1, all section music will be counted
        SysManager.sendToConsole("Refreshing music on all sections...")
        for i = 0,20 do
            musiclist = {Section(i).music}
            GameData.levelMusicTemporary[i] = Section(i).music
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        SysManager.sendToConsole("Refreshing music on section "..tostring(sectionid).."...")
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
            SysManager.sendToConsole("Refreshing originally stored music on all sections...")
            for i = 0,20 do
                songname = GameData.levelMusic[i]
                Section(i).music = songname
            end
        else
            return
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        if GameData.levelMusic ~= {} then
            SysManager.sendToConsole("Refreshing originally stored music on section "..tostring(sectionid).."...")
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
        SysManager.sendToConsole("Music refresh system has been set up.")
        started = true
    end
end

function Sound.checkPWingSoundStatus()
    if SaveData.disablePWingSFX then
        SysManager.sendToConsole("P-Wing sound effect setting has been set to disabled.")
        smasExtraSounds.enablePWingSFX = false
    elseif not SaveData.disablePWingSFX then
        SysManager.sendToConsole("P-Wing sound effect setting has been set to enabled.")
        smasExtraSounds.enablePWingSFX = true
    end
end

function Sound.checkSMBXSoundSystemStatus()
    if SaveData.SMBXSoundSystem then
        SysManager.sendToConsole("Original SMBX sound system setting has been set to disabled.")
        smasExtraSounds.enableGrabShellSFX = false
        smasExtraSounds.playPSwitchTimerSFX = false
        smasExtraSounds.enableSMB2EnemyKillSounds = false
        smasExtraSounds.useOriginalSpinJumpForBigEnemies = true
        smasExtraSounds.enableHPCollecting = false
        smasExtraSounds.useOriginalDragonCoinSounds = true
        smasExtraSounds.useOriginalBowserFireballInstead = true
        smasExtraSounds.enableIceBlockBreaking = false
        smasExtraSounds.useOriginalBlockSproutInstead = true
        smasExtraSounds.useFireworksInsteadOfOtherExplosions = true
        smasExtraSounds.use1UPSoundForAll1UPs = true
        smasExtraSounds.useJumpSoundInsteadWhenUnmountingYoshi = true
        smasExtraSounds.enableBoomerangBroBoomerangSFX = false
        smasExtraSounds.enableToadBoomerangSFX = false
        smasExtraSounds.useFireSoundForHammerSuit = true
        smasExtraSounds.useFireSoundForIce = true
    elseif not SaveData.SMBXSoundSystem then
        SysManager.sendToConsole("Original SMBX sound system setting has been set to enabled.")
        smasExtraSounds.enableGrabShellSFX = true
        smasExtraSounds.playPSwitchTimerSFX = true
        smasExtraSounds.enableSMB2EnemyKillSounds = true
        smasExtraSounds.useOriginalSpinJumpForBigEnemies = false
        smasExtraSounds.enableHPCollecting = true
        smasExtraSounds.useOriginalDragonCoinSounds = false
        smasExtraSounds.useOriginalBowserFireballInstead = false
        smasExtraSounds.enableIceBlockBreaking = true
        smasExtraSounds.useOriginalBlockSproutInstead = false
        smasExtraSounds.useFireworksInsteadOfOtherExplosions = false
        smasExtraSounds.use1UPSoundForAll1UPs = false
        smasExtraSounds.useJumpSoundInsteadWhenUnmountingYoshi = false
        smasExtraSounds.enableBoomerangBroBoomerangSFX = true
        smasExtraSounds.enableToadBoomerangSFX = true
        smasExtraSounds.useFireSoundForHammerSuit = false
        smasExtraSounds.useFireSoundForIce = false
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

function Sound.muteChannel(channel)
    if SMBX_VERSION == VER_SEE_MOD then
        return Audio.MusicInstChannelMute(channel - 1)
    else
        return
    end
end

function Sound.unmuteChannel(channel)
    if SMBX_VERSION == VER_SEE_MOD then
        return Audio.MusicInstChannelUnmute(channel - 1)
    else
        return
    end
end





function Sound.onDraw()
    
end




return Sound