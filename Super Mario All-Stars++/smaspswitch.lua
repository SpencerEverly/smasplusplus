local smaspswitch = {}

function smaspswitch.onInitAPI()
    registerEvent(smaspswitch,"onDraw")
end

local pSwitchMusic
smaspswitch.pSwitchMusicStarted = false



function smaspswitch.startPSwitchMusic() --Starts the P-Switch music.
    if not smaspswitch.pSwitchMusicStarted then
        if not smaspswitch.inNoPSwitchMusicPlayingSituations() then
            console:println("P-Switch music activated!")
            Sound.muteMusic(-1)
            smasbooleans.musicMuted = true
            pSwitchMusic = SFX.play(smascharacterinfo.pSwitchMusic, Audio.MusicVolume() / 100, 0)
            smaspswitch.pSwitchMusicStarted = true
        end
    end
end



function smaspswitch.stopPSwitchMusic(resetLevelMusic) --Stops the P-Switch music.
    if resetLevelMusic == nil then
        resetLevelMusic = true
    end
    
    if pSwitchMusic ~= nil then
        pSwitchMusic:Stop()
    end
    
    smaspswitch.pSwitchMusicStarted = false
    
    if not smaspswitch.inNoPSwitchMusicPlayingSituations() then
        if resetLevelMusic then
            console:println("P-Switch music deactivated!")
            smasbooleans.musicMuted = false
            Sound.restoreMusic(-1)
        end
    end
end



function smaspswitch.inNoPSwitchMusicPlayingSituations()
    for _,p in ipairs(Player.get()) do
        return (p.hasStarman
            or p.isMega
            or GameData.winStateActive
            or Level.endState() > 0
        )
    end
end



function smaspswitch.onDraw()
    Defines.pswitch_music = false
    for _,p in ipairs(Player.get()) do --Make sure all players are counted if i.e. using supermario128...
        
        
        
        
        --Start P-Switch/Stopwatch codes
        if mem(0x00B2C62C, FIELD_WORD) == mem(0x00B2C87C, FIELD_WORD) - 1 then --P-Switch
            smaspswitch.startPSwitchMusic()
            smasbooleans.pSwitchActive = true
        end
        if mem(0x00B2C62E, FIELD_WORD) == mem(0x00B2C87C, FIELD_WORD) - 1 then --Stopwatch
            smaspswitch.startPSwitchMusic()
            smasbooleans.stopWatchActive = true
        end
        
        
        
        --Make sure the music stops when collecting a starman, a megashroom, or winning a level if active
        if smaspswitch.inNoPSwitchMusicPlayingSituations() then
            if pSwitchMusic ~= nil then
                smasbooleans.musicMuted = false
                pSwitchMusic:Stop()
            end
        end
        
        
        
        --Stop P-Switch/Stopwatch codes
        if mem(0x00B2C62C, FIELD_WORD) == 1 then --P-Switch
            smasbooleans.pSwitchActive = false
            smaspswitch.stopPSwitchMusic()
        end
        if mem(0x00B2C62E, FIELD_WORD) == 1 then --Stopwatch
            smasbooleans.stopWatchActive = false
            smaspswitch.stopPSwitchMusic()
        end
        
        
        
        
    end
end

return smaspswitch