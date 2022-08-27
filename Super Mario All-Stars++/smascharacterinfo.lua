local smascharacterinfo = {}

local littleDialogue = require("littleDialogue")
local starman = require("starman/star")
local mega2 = require("mega/megashroom")
local extrasounds = require("extrasounds")
local playerManager = require("playermanager")
local steve = require("steve")
local yoshi = require("yiYoshi/yiYoshi")

function smascharacterinfo.onInitAPI()
    registerEvent(smascharacterinfo,"onTickEnd")
end

smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"

function smascharacterinfo.onTickEnd()
    local characters = {}
    
    local character = player.character;
    local costumes = playerManager.getCostumes(player.character)
    local currentCostume = player:getCostume()

    local costumes
    
    if SaveData.disableX2char == true then
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        for _,p in ipairs(Player.get()) do
            p.setCostume(1, nil)
            p.setCostume(2, nil)
            p.setCostume(3, nil)
            p.setCostume(4, nil)
            p.setCostume(5, nil)
        end
    end
    
    if currentCostume == nil or currentCostume == "!DEFAULT" then
        littleDialogue.characterNames[1] = "Mario"
        littleDialogue.characterNames[2] = "Luigi"
        littleDialogue.characterNames[3] = "Peach"
        littleDialogue.characterNames[4] = "Toad"
        littleDialogue.characterNames[5] = "Link"
        littleDialogue.characterNames[9] = "Klonoa"
        littleDialogue.characterNames[14] = "Steve"
        if table.icontains(smastables.__smb3Levels,Level.filename()) == true then
            smascharacterinfo.pSwitchMusic = "pswitch/pswitch_smas.ogg"
        elseif table.icontains(smastables.__smwLevels,Level.filename()) == true then
            smascharacterinfo.pSwitchMusic = "pswitch/pswitch_smw.ogg"
        else
            smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
        end
    end
    if currentCostume == "00-SMASPLUSPLUS-BETA" then
        if table.icontains(smastables.__smb2Levels,Level.filename()) == true then
            starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta_smb2.ogg")
        elseif Level.filename() then
            starman.sfxFile = Misc.resolveSoundFile("starman/starman_2012beta.ogg")
        end
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_2012beta.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_2012beta.ogg"
    end
    if currentCostume == "01-SMB1-RETRO" then
        if table.icontains(smastables.__smb2Levels,Level.filename()) == true then
            starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1_smb2.ogg")
        elseif Level.filename() then
            starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb1.ogg")
        end
        littleDialogue.characterNames[1] = "Mario"
        littleDialogue.characterNames[2] = "Luigi"
        littleDialogue.characterNames[3] = "Peach"
        littleDialogue.characterNames[4] = "Toad"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-smb1.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_smb1.ogg"
    end
    if currentCostume == "02-SMB1-RECOLORED" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smas_smb1.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/01-SMB1-Retro/door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "03-SMB1-SMAS" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smas.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "04-SMB2-RETRO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-smb2.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb2.ogg")
        starman.duration[996] = 577
        starman.duration[994] = 577
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/04-SMB2-Retro/door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_smb2.ogg"
    end
    if currentCostume == "05-SMB2-SMAS" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smas_smb2.ogg")
        starman.duration[996] = 577
        starman.duration[994] = 577
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "06-SMB3-RETRO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-smb3.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smb3.ogg")
        starman.duration[996] = 705
        starman.duration[994] = 705
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/06-SMB3-Retro/door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_smb3.ogg"
    end
    if currentCostume == "07-SML2" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_sml2.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_sml2.ogg")
        starman.duration[996] = 878
        starman.duration[994] = 878
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "08-SMBSPECIAL" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_smbspecial.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smbspecial.ogg")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_smbspecial.ogg"
    end
    if currentCostume == "09-SMW-PIRATE" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_smw_pirate.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw_pirate.ogg")
        starman.duration[996] = 1410
        starman.duration[994] = 1410
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "11-SMA1" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
        starman.sfxFile = Misc.resolveSoundFile("costumes/mario/11-SMA1/starman")
        starman.duration[996] = 577
        starman.duration[994] = 577
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_sma2.ogg"
    end
    if currentCostume == "12-SMA2" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
        starman.sfxFile = Misc.resolveSoundFile("costumes/mario/12-SMA2/starman")
        starman.duration[996] = 1090
        starman.duration[994] = 1090
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_sma2.ogg"
    end
    if currentCostume == "13-SMA4" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
        starman.sfxFile = Misc.resolveSoundFile("costumes/mario/13-SMA4/starman")
        starman.duration[996] = 705
        starman.duration[994] = 705
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_sma4.ogg"
    end
    if currentCostume == "14-NSMBDS-SMBX" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_nsmbds")
        starman.duration[996] = 641
        starman.duration[994] = 641
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "15-NSMBDS-ORIGINAL" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_nsmbds")
        starman.duration[996] = 641
        starman.duration[994] = 641
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "16-NSMBWII-MARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_nsmbwii")
        starman.duration[996] = 641
        starman.duration[994] = 641
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "A2XT-DEMO" then
        littleDialogue.characterNames[1] = "Demo"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "DEMO-XMASPILY" then
        littleDialogue.characterNames[1] = "Pily"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt2.ogg")
        starman.duration[996] = lunatime.toTicks(26.6)
        starman.duration[994] = lunatime.toTicks(26.6)
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "MODERN" then
        littleDialogue.characterNames[1] = "Mario"
        littleDialogue.characterNames[2] = "Luigi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "MODERN2" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
        littleDialogue.characterNames[1] = "JC Foster"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_jcfoster.ogg")
        starman.duration[996] = 1026
        starman.duration[994] = 1026
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SP-1-ERICCARTMAN" then
        littleDialogue.characterNames[1] = "Eric"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_southpark.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_southpark")
        starman.duration[996] = 962
        starman.duration[994] = 962
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMG4" then
        littleDialogue.characterNames[1] = "SMG4"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SPONGEBOBSQUAREPANTS" then
        littleDialogue.characterNames[1] = "SpongeBob"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-spongebob.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_spongebob")
        starman.duration[996] = 1090
        starman.duration[994] = 1090
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "PRINCESSRESCUE" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("starman/starman_princessrescue.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_princessrescue.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMB0" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_smb0.ogg"
    end
    if currentCostume == "SMW-MARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = 1090
        starman.duration[994] = 1090
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "GA-CAILLOU" then
        littleDialogue.characterNames[1] = "Caillou"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_goanimate.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_goanimate")
        starman.duration[996] = 1090
        starman.duration[994] = 1090
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_goanimate.ogg"
    end
    if currentCostume == "Z-SMW2-ADULTMARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw2.ogg")
        starman.duration[996] = 1282
        starman.duration[994] = 1282
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Z-SMW2-AdultMario/door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMBDDX-MARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("starman/starmanmegashroom_smbddx")
        starman.sfxFile = Misc.resolveSoundFile("starman/starmanmegashroom_smbddx")
        starman.duration[996] = lunatime.toTicks(14)
        starman.duration[994] = lunatime.toTicks(14)
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_smbddx.ogg"
    end
    if currentCostume == "SMM2-LUIGI" then
        littleDialogue.characterNames[1] = "Luigi"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMM2-MARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMM2-TOAD" then
        littleDialogue.characterNames[1] = "Toad"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMM2-TOADETTE" then
        littleDialogue.characterNames[1] = "Toadette"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMM2-YELLOWTOAD" then
        littleDialogue.characterNames[1] = "Toad"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "GO-10SECONDRUN" then
        littleDialogue.characterNames[1] = "Runner Red"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    if currentCostume == "00-SPENCEREVERLY" then
        littleDialogue.characterNames[2] = "Spencer"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_smbs.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smbs.ogg")
        starman.duration[996] = 1282
        starman.duration[994] = 1282
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "LARRYTHECUCUMBER" then
        littleDialogue.characterNames[2] = "Larry"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/luigi/LarryTheCucumber/door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "WALUIGI" then
        littleDialogue.characterNames[2] = "Waluigi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "A2XT-IRIS" then
        littleDialogue.characterNames[2] = "Iris"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "UNDERTALE-FRISK" then
        littleDialogue.characterNames[2] = "Frisk"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_undertale")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_undertale")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/luigi/Undertale-Frisk/door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "09-SMB3-MARIOCLOTHES" then
        littleDialogue.characterNames[2] = "Marigi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "GA-BORIS" then
        littleDialogue.characterNames[2] = "Boris"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_goanimate")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_goanimate")
        starman.duration[996] = 1090
        starman.duration[994] = 1090
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    
    if currentCostume == "A2XT-KOOD" then
        littleDialogue.characterNames[3] = "Kood"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "DAISY" then
        littleDialogue.characterNames[3] = "Daisy"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "KIRBY-SMB3" then
        littleDialogue.characterNames[3] = "Kirby"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "PAULINE" then
        littleDialogue.characterNames[3] = "Pauline"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "NINJABOMBERMAN" then
        littleDialogue.characterNames[3] = "Plunder Bomber"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    if currentCostume == "SEE-TANGENT" then
        littleDialogue.characterNames[4] = "Tangent"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-nintendogs")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_nintendogs")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SONIC" then
        littleDialogue.characterNames[4] = "Sonic"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_sonic")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_sonic")
        starman.duration[996] = 1282
        starman.duration[994] = 1282
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "IMAJIN-NES" then
        littleDialogue.characterNames[4] = "Imajin"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_ddp")
        starman.duration[996] = lunatime.toTicks(8)
        starman.duration[994] = lunatime.toTicks(8)
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "JASMINE" then
        littleDialogue.characterNames[4] = "Jasmine"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "LEGOSTARWARS-REBELTROOPER" then
        littleDialogue.characterNames[4] = "Rebel Trooper"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_starwars")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_starwars")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/LEGOStarWars-RebelTrooper/door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "MOTHERBRAINRINKA" then
        littleDialogue.characterNames[4] = "Mother Brain Rinka"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "TOADETTE" then
        littleDialogue.characterNames[4] = "Toadette"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "YOSHI-SMB3" then
        littleDialogue.characterNames[4] = "Yoshi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "A2XT-RAOCOW" then
        littleDialogue.characterNames[4] = "Raocow"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "PACMAN-ARRANGEMENT-PACMAN" then
        littleDialogue.characterNames[4] = "Pac-Man"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    
    if currentCostume == "A2XT-SHEATH" then
        littleDialogue.characterNames[5] = "Sheath"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMB3-BANDANA-DEE" then
        littleDialogue.characterNames[5] = "Bandana Dee"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "NESS" then
        littleDialogue.characterNames[5] = "Ness"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_earthbound.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_earthbound.ogg")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "pswitch/pswitch_earthbound.ogg"
    end
    if currentCostume == "TAKESHI" then
        littleDialogue.characterNames[5] = "Takeshi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/link/Takeshi/door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SEE-SHERBERTLUSSIEBACK" then
        littleDialogue.characterNames[5] = "Sherbert"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "TAKESHI-SNES" then
        littleDialogue.characterNames[5] = "Takeshi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    if currentCostume == "SMA3" then
        littleDialogue.characterNames[10] = "Yoshi"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_sma3.ogg")
        starman.duration[996] = 1474
        starman.duration[994] = 1474
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    
    
    if currentCostume == "SMW2-YOSHI" then
        littleDialogue.characterNames[9] = "Yoshi"
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "YS-GREEN" then
        littleDialogue.characterNames[9] = "Yoshi"
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    if (character == CHARACTER_STEVE) == true then
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = 769
        starman.duration[994] = 769
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smascharacterinfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    if currentCostume == "DJCTRE-CUBIXTRON" then
        littleDialogue.characterNames[14] = "Cubix Tron"
    end
    if currentCostume == "DJCTRE-CUBIXTRONDAD" then
        littleDialogue.characterNames[14] = "Cubix Tron Dad"
    end
    if currentCostume == "DJCTRE-STULTUS" then
        littleDialogue.characterNames[14] = "Stultus"
    end
    if currentCostume == "DLC-FESTIVE-CHRISTMASTREE" then
        littleDialogue.characterNames[14] = "Christmas Tree"
    end
    if currentCostume == "ED-EDEDDANDEDDY" then
        littleDialogue.characterNames[14] = "Ed"
    end
    if currentCostume == "EXPLODINGTNT" then
        littleDialogue.characterNames[14] = "ExplodingTNT"
    end
    if currentCostume == "GEORGENOTFOUNDYT" then
        littleDialogue.characterNames[14] = "GeorgeNotFound"
    end
    if currentCostume == "HANGOUTYOSHIGUYYT" then
        littleDialogue.characterNames[14] = "Stone"
    end
    if currentCostume == "KARLJACOBSYT" then
        littleDialogue.characterNames[14] = "Karl"
    end
    if currentCostume == "KOOPAPANZER" then
        littleDialogue.characterNames[14] = "Koopapanzer"
    end
    if currentCostume == "MC-ALEX" then
        littleDialogue.characterNames[14] = "Alex"
    end
    if currentCostume == "MC-CAPTAINTOAD" then
        littleDialogue.characterNames[14] = "Captain Toad"
    end
    if currentCostume == "MC-FNF-BOYFRIEND" then
        littleDialogue.characterNames[14] = "Boyfriend"
    end
    if currentCostume == "MC-FNF-GIRLFRIEND" then
        littleDialogue.characterNames[14] = "Girlfriend"
    end
    if currentCostume == "MC-FRISK" then
        littleDialogue.characterNames[14] = "Frisk"
    end
    if currentCostume == "MC-HEROBRINE" then
        littleDialogue.characterNames[14] = "Herobrine"
    end
    if currentCostume == "MC-IMPOSTOR" then
        littleDialogue.characterNames[14] = "Impostor"
    end
    if currentCostume == "MC-ITSHARRY" then
        littleDialogue.characterNames[14] = "Harry"
    end
    if currentCostume == "MC-ITSJERRY" then
        littleDialogue.characterNames[14] = "Jerry"
    end
    if currentCostume == "MC-KERALIS" then
        littleDialogue.characterNames[14] = "Keralis"
    end
    if currentCostume == "MC-KRIS" then
        littleDialogue.characterNames[14] = "Kris"
    end
    if currentCostume == "MC-MARIO" then
        littleDialogue.characterNames[14] = "Mario"
    end
    if currentCostume == "MC-NOELLE-DELTARUNE" then
        littleDialogue.characterNames[14] = "Noelle"
    end
    if currentCostume == "MC-NOTCH" then
        littleDialogue.characterNames[14] = "Notch"
    end
    if currentCostume == "MC-PATRICK" then
        littleDialogue.characterNames[14] = "Patrick"
    end
    if currentCostume == "MC-RALSEI" then
        littleDialogue.characterNames[14] = "Ralsei"
    end
    if currentCostume == "MC-SONIC" then
        littleDialogue.characterNames[14] = "Sonic"
    end
    if currentCostume == "MC-SPIDERMAN" then
        littleDialogue.characterNames[14] = "Spiderman"
    end
    if currentCostume == "MC-SPONGEBOB" then
        littleDialogue.characterNames[14] = "SpongeBob"
    end
    if currentCostume == "MC-SQUIDWARD" then
        littleDialogue.characterNames[14] = "Squidward"
    end
    if currentCostume == "MC-SUSIE-DELTARUNE" then
        littleDialogue.characterNames[14] = "Susie"
    end
    if currentCostume == "MC-TAILS" then
        littleDialogue.characterNames[14] = "Tails"
    end
    if currentCostume == "MC-ZOMBIE" then
        littleDialogue.characterNames[14] = "Zombie"
    end
    if currentCostume == "MYSTERYMANBRO" then
        littleDialogue.characterNames[14] = "Mystery Man Bro"
    end
    if currentCostume == "QUACKITYYT" then
        littleDialogue.characterNames[14] = "Quackity"
    end
    if currentCostume == "SEE-MC-EVILME" then
        littleDialogue.characterNames[14] = "Evil Me"
    end
    if currentCostume == "SEE-MC-GERANIUM" then
        littleDialogue.characterNames[14] = "Geranium"
    end
    if currentCostume == "SEE-MC-LEWBERTLUSSIEBACK" then
        littleDialogue.characterNames[14] = "Lewbert"
    end
    if currentCostume == "SEE-MC-LILIJUCIEBACK" then
        littleDialogue.characterNames[14] = "Lili"
    end
    if currentCostume == "SEE-MC-MIMIJUCIEBACK" then
        littleDialogue.characterNames[14] = "Mimi"
    end
    if currentCostume == "SEE-MC-RONDAVIS" then
        littleDialogue.characterNames[14] = "Ron Davis"
    end
    if currentCostume == "SEE-MC-SHENICLE" then
        littleDialogue.characterNames[14] = "Shenicle"
    end
    if currentCostume == "SEE-MC-SHELLEYKIRK" then
        littleDialogue.characterNames[14] = "Shelley Kirk"
    end
    if currentCostume == "SEE-MC-SHERBERTLUSSIEBACK" then
        littleDialogue.characterNames[14] = "Sherbert"
    end
    if currentCostume == "SEE-MC-SPENCER2" then
        littleDialogue.characterNames[14] = "Spencer 2"
    end
    if currentCostume == "SEE-MC-SPENCEREVERLY" then
        littleDialogue.characterNames[14] = "Spencer"
    end
    if currentCostume == "SEE-MC-TIANELY" then
        littleDialogue.characterNames[14] = "Tianely"
    end
    if currentCostume == "TOMMYINNITYT" then
        littleDialogue.characterNames[14] = "TommyInnit"
    end
    if currentCostume == "TECHNOBLADE" then
        littleDialogue.characterNames[14] = "Technoblade"
    end
    if currentCostume == "UNOFFICIALSTUDIOSYT" then
        littleDialogue.characterNames[14] = "Riley"
    end
    
    
    
    
    
    
    
    if currentCostume == nil and SaveData.disableX2char == false then
        steve.skinSettings.name = "steve"
        if Cheats.get("waitinginthesky").active == false then
            mega2.sfxFile = Misc.resolveSoundFile("megashroom")
            starman.sfxFile = Misc.resolveSoundFile("starman")
            starman.duration[996] = 769
            starman.duration[994] = 769
        end
        extrasounds.sound.sfx[148] = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
    end
end

return smascharacterinfo