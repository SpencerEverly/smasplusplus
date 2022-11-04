local smaspswitch = {}

function smaspswitch.onInitAPI()
    registerEvent(smaspswitch,"onDraw")
end

local pSwitchMusic

function smaspswitch.onDraw()
    Defines.pswitch_music = false
    for _,p in ipairs(Player.get()) do --Make sure all players are counted if i.e. using supermario128...
        --P-Switch code
        if mem(0x00B2C62C, FIELD_WORD) == mem(0x00B2C87C, FIELD_WORD) - 1 or mem(0x00B2C62E, FIELD_WORD) == mem(0x00B2C87C, FIELD_WORD) - 1 then
            if not p.hasStarman and not p.isMega then
                Sound.muteMusic(-1)
                smasbooleans.musicMuted = true
                pSwitchMusic = SFX.play(smascharacterinfo.pSwitchMusic, Audio.MusicVolume() / 100, 0)
            end
            smasbooleans.pSwitchActive = true
        end
        if p.hasStarman or p.isMega or GameData.winStateActive or Level.endState() > 0 then
            if pSwitchMusic ~= nil then
                smasbooleans.musicMuted = false
                pSwitchMusic:Stop()
            end
        end
        if mem(0x00B2C62C, FIELD_WORD) == 1 or mem(0x00B2C62E, FIELD_WORD) == 1 then
            smasbooleans.pSwitchActive = false
            if pSwitchMusic ~= nil then
                pSwitchMusic:Stop()
            end
            if not p.hasStarman and not p.isMega then
                smasbooleans.musicMuted = false
                Sound.restoreMusic(-1)
            end
        end
    end
end

return smaspswitch