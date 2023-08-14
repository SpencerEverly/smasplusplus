local smasCharacterInfo = {}

local littleDialogue
pcall(function() littleDialogue = require("littleDialogue") end)
local starman = require("starman/star")
local mega2 = require("mega/megashroom")
local playerManager = require("playermanager")
local steve = require("steve")
local yoshi = require("yiYoshi/yiYoshi")

function smasCharacterInfo.onInitAPI()
    registerEvent(smasCharacterInfo,"onStart")
end

smasCharacterInfo.costumeSpecifics = {}
smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"

function smasCharacterInfo.registerCharacterInfo(args) --Example: smasCharacterInfo.registerCharacterInfo{costumeName = "00-SMASPLUSPLUS-BETA", name = "Mario", characterID = 1, starmanTheme = "starman/starman_2012beta.ogg", DDPStarmanTheme = "starman/starman_2012beta_ddp.ogg", megashroomTheme = "mega/megashroom_2012beta.ogg", starmanDuration = 12, doorCloseSFX = "door-close.ogg", pSwitchTheme = "pswitch/pswitch_2012beta.ogg"}
    if args.costumeName == nil then
        error("Must input costume name for registering this character!")
        return
    end
    if args.characterID == nil then
        error("Must input character ID for registering this character!")
        return
    end
    if args.name == nil then
        error("Must input name for registering this character!")
        return
    end
    if args.starmanTheme == nil then
        args.starmanTheme = Misc.resolveSoundFile("starman")
    end
    if args.DDPStarmanTheme == nil then
        args.DDPStarmanTheme = Misc.resolveSoundFile("starman")
    end
    if args.megashroomTheme == nil then
        args.megashroomTheme = Misc.resolveSoundFile("megashroom")
    end
    if args.starmanDuration == nil then
        args.starmanDuration = 12
    end
    if args.doorCloseSFX == nil then
        args.doorCloseSFX = "door-close.ogg"
    end
    if args.pSwitchTheme == nil then
        if table.icontains(smasTables.__smb3Levels,Level.filename()) then
            args.pSwitchTheme = "pswitch/pswitch_smas.ogg"
        elseif table.icontains(smasTables.__smwLevels,Level.filename()) then
            args.pSwitchTheme = "pswitch/pswitch_smw.ogg"
        else
            args.pSwitchTheme = "_OST/P-Switch (v2).ogg"
        end
    end
    
    smasCharacterInfo.costumeSpecifics[args.costumeName] = {}
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID] = {}
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID].costume = args.costumeName
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID].name = args.name
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID].id = args.characterID
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID].starmanTheme = args.starmanTheme
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID].ddpStarmanTheme = args.DDPStarmanTheme
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID].megashroomTheme = args.megashroomTheme
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID].starmanDuration = args.starmanDuration
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID].doorCloseSFX = args.doorCloseSFX
    smasCharacterInfo.costumeSpecifics[args.costumeName][args.characterID].pSwitchTheme = args.pSwitchTheme
end

--Mario
smasCharacterInfo.registerCharacterInfo{costumeName = "00-SMASPLUSPLUS-BETA", name = "Mario", characterID = 1, starmanTheme = "starman/starman_2012beta.ogg", DDPStarmanTheme = "starman/starman_2012beta_ddp.ogg", megashroomTheme = "mega/megashroom_2012beta.ogg", starmanDuration = 12, doorCloseSFX = "door-close.ogg", pSwitchTheme = "pswitch/pswitch_2012beta.ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "01-SMB1-RETRO", name = "Mario", characterID = 1, starmanTheme = "starman/starman_smb1.ogg", DDPStarmanTheme = "starman/starman_smb1_ddp.ogg", megashroomTheme = "mega/megashroom-smb1.ogg", starmanDuration = 12, doorCloseSFX = "costumes/mario/01-SMB1-Retro/door-close.ogg", pSwitchTheme = "pswitch/pswitch_smb1.ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "02-SMB1-RECOLORED", name = "Mario", characterID = 1, starmanTheme = "starman/starman_smas_smb1.ogg", DDPStarmanTheme = "starman/starman_smas_smb1.ogg", megashroomTheme = "mega/megashroom_snes.ogg", starmanDuration = 12, doorCloseSFX = "door-close.ogg", pSwitchTheme = "_OST/P-Switch (v2).ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "03-SMB1-SMAS", name = "Mario", characterID = 1, starmanTheme = "starman/starman_smas.ogg", DDPStarmanTheme = "starman/starman_smas.ogg", megashroomTheme = "mega/megashroom_snes.ogg", starmanDuration = 12, doorCloseSFX = "door-close.ogg", pSwitchTheme = "_OST/P-Switch (v2).ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "04-SMB2-RETRO", name = "Mario", characterID = 1, starmanTheme = "starman/starman_smb2.ogg", DDPStarmanTheme = "starman/starman_smb2_ddp.ogg", megashroomTheme = "mega/megashroom-smb2.ogg", starmanDuration = 9.0012, doorCloseSFX = "costumes/mario/04-SMB2-Retro/door-close.ogg", pSwitchTheme = "pswitch/pswitch_smb2.ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "05-SMB2-SMAS", name = "Mario", characterID = 1, starmanTheme = "starman/starman_smas_smb2.ogg", DDPStarmanTheme = "starman/starman_smas_smb2.ogg", megashroomTheme = "mega/megashroom_snes.ogg", starmanDuration = 9.0012, doorCloseSFX = "door-close.ogg", pSwitchTheme = "_OST/P-Switch (v2).ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "06-SMB3-RETRO", name = "Mario", characterID = 1, starmanTheme = "starman/starman_smb3.ogg", DDPStarmanTheme = "starman/starman_smb3_ddp.ogg", megashroomTheme = "mega/megashroom-smb3.ogg", starmanDuration = 10.998, doorCloseSFX = "costumes/mario/06-SMB3-Retro/door-close.ogg", pSwitchTheme = "pswitch/pswitch_smb3.ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "07-SML2", name = "Mario", characterID = 1, starmanTheme = "starman/starman_sml2.ogg", DDPStarmanTheme = "starman/starman_sml2.ogg", megashroomTheme = "mega/megashroom_sml2.ogg", starmanDuration = 13.7, doorCloseSFX = "door-close.ogg", pSwitchTheme = "_OST/P-Switch (v2).ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "08-SMBSPECIAL", name = "Mario", characterID = 1, starmanTheme = "starman/starman_smbspecial.ogg", DDPStarmanTheme = "starman/starman_smbspecial.ogg", megashroomTheme = "mega/megashroom_smbspecial.ogg", starmanDuration = 12, doorCloseSFX = "door-close.ogg", pSwitchTheme = "pswitch/pswitch_smbspecial.ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "09-SMW-PIRATE", name = "Mario", characterID = 1, starmanTheme = "starman/starman_smw_pirate.ogg", DDPStarmanTheme = "starman/starman_smw_pirate.ogg", megashroomTheme = "mega/megashroom_smw_pirate.ogg", starmanDuration = 22, doorCloseSFX = "_OST/_Sound Effects/nothing.ogg", pSwitchTheme = "_OST/P-Switch (v2).ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "10-HOTELMARIO", name = "Mario", characterID = 1, starmanTheme = "starman/starman_hotelmario.ogg", DDPStarmanTheme = "starman/starman_hotelmario.ogg", megashroomTheme = "mega/megashroom_hotelmario.ogg", starmanDuration = 12, doorCloseSFX = "costumes/mario/10-HotelMario/door-close.ogg", pSwitchTheme = "_OST/P-Switch (v2).ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "11-SMA1", name = "Mario", characterID = 1, starmanTheme = "starman/starman_sma1", DDPStarmanTheme = "starman/starman_sma1", megashroomTheme = "mega/megashroom_gba.ogg", starmanDuration = 9.0012, doorCloseSFX = "_OST/_Sound Effects/nothing.ogg", pSwitchTheme = "pswitch/pswitch_sma2.ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "12-SMA2", name = "Mario", characterID = 1, starmanTheme = "starman/starman_sma1", DDPStarmanTheme = "starman/starman_sma1", megashroomTheme = "mega/megashroom_gba.ogg", starmanDuration = 17.004, doorCloseSFX = "_OST/_Sound Effects/nothing.ogg", pSwitchTheme = "pswitch/pswitch_sma2.ogg"}
smasCharacterInfo.registerCharacterInfo{costumeName = "13-SMA4", name = "Mario", characterID = 1, starmanTheme = "starman/starman_sma4", DDPStarmanTheme = "starman/starman_sma4", megashroomTheme = "mega/megashroom_gba.ogg", starmanDuration = 10.998, doorCloseSFX = "_OST/_Sound Effects/nothing.ogg", pSwitchTheme = "pswitch/pswitch_sma4.ogg"}




smasCharacterInfo.registerCharacterInfo{costumeName = "GRAYTRAP", name = "Graytrap", characterID = 2}




function smasCharacterInfo.onStart()
    smasCharacterInfo.setCostumeSpecifics()
end

function smasCharacterInfo.setCostumeSpecifics()
    console:println("Character information will now be changed.")
    
    local currentCostume = SaveData.SMASPlusPlus.player[1].currentCostume
    
    if SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        for _,p in ipairs(Player.get()) do
            p.setCostume(1, nil)
            p.setCostume(2, nil)
            p.setCostume(3, nil)
            p.setCostume(4, nil)
            p.setCostume(5, nil)
        end
    end
    
    if (currentCostume == "N/A" or currentCostume == "!DEFAULT") then
        littleDialogue.characterNames[1] = "Mario"
        littleDialogue.characterNames[2] = "Luigi"
        littleDialogue.characterNames[3] = "Peach"
        littleDialogue.characterNames[4] = "Toad"
        littleDialogue.characterNames[5] = "Link"
        littleDialogue.characterNames[9] = "Klonoa"
        littleDialogue.characterNames[14] = "Steve"
        
        --P-Switch themes for default characters
        if table.icontains(smasTables.__smb3Levels,Level.filename()) then
            smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_smas.ogg"
        elseif table.icontains(smasTables.__smwLevels,Level.filename()) then
            smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_smw.ogg"
        else
            smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
        end
    end
    
    if (smasCharacterInfo.costumeSpecifics[currentCostume] ~= nil) then
        if (smasCharacterInfo.costumeSpecifics[currentCostume][player.character] ~= nil) then
            if currentCostume == smasCharacterInfo.costumeSpecifics[currentCostume][player.character].costume then
                local idNumber = smasCharacterInfo.costumeSpecifics[currentCostume][player.character].id
                littleDialogue.characterNames[idNumber] = smasCharacterInfo.costumeSpecifics[currentCostume][player.character].name
                mega2.sfxFile = Misc.resolveSoundFile(smasCharacterInfo.costumeSpecifics[currentCostume][player.character].megashroomTheme)
                if table.icontains(smasTables.__smb2Levels,Level.filename()) then
                    starman.sfxFile = Misc.resolveSoundFile(smasCharacterInfo.costumeSpecifics[currentCostume][player.character].ddpStarmanTheme)
                elseif Level.filename() then
                    starman.sfxFile = Misc.resolveSoundFile(smasCharacterInfo.costumeSpecifics[currentCostume][player.character].starmanTheme)
                end
                starman.duration[996] = lunatime.toTicks(smasCharacterInfo.costumeSpecifics[currentCostume][player.character].starmanDuration)
                starman.duration[994] = lunatime.toTicks(smasCharacterInfo.costumeSpecifics[currentCostume][player.character].starmanDuration)
                smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile(smasCharacterInfo.costumeSpecifics[currentCostume][player.character].doorCloseSFX))
                smasCharacterInfo.pSwitchMusic = smasCharacterInfo.costumeSpecifics[currentCostume][player.character].pSwitchTheme
            end
        end
    end
    
    
    if currentCostume == "14-NSMBDS-SMBX" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_nsmbds")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_nsmbds")
        starman.duration[996] = lunatime.toTicks(9.9996)
        starman.duration[994] = lunatime.toTicks(9.9996)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "15-NSMBDS-ORIGINAL" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_nsmbds")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_nsmbds")
        starman.duration[996] = lunatime.toTicks(9.9996)
        starman.duration[994] = lunatime.toTicks(9.9996)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "16-NSMBWII-MARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_nsmbwii")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_nsmbwii")
        starman.duration[996] = lunatime.toTicks(9.9996)
        starman.duration[994] = lunatime.toTicks(9.9996)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "A2XT-DEMO" then
        littleDialogue.characterNames[1] = "Demo"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt.ogg")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "DEMO-XMASPILY" then
        littleDialogue.characterNames[1] = "Pily"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt2.ogg")
        starman.duration[996] = lunatime.toTicks(26.6)
        starman.duration[994] = lunatime.toTicks(26.6)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "MODERN" then
        littleDialogue.characterNames[1] = "Mario"
        littleDialogue.characterNames[2] = "Luigi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "MODERN2" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        if table.icontains(smasTables.__smb2Levels,Level.filename()) then
            starman.sfxFile = Misc.resolveSoundFile("starman/starman_darsonic55_ddp")
        elseif Level.filename() then
            starman.sfxFile = Misc.resolveSoundFile("starman/starman_darsonic55")
        end
        starman.duration[996] = lunatime.toTicks(25.7)
        starman.duration[994] = lunatime.toTicks(25.7)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
        littleDialogue.characterNames[1] = "JC Foster"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_jcfoster.ogg")
        starman.duration[996] = lunatime.toTicks(16.0056)
        starman.duration[994] = lunatime.toTicks(16.0056)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SP-1-ERICCARTMAN" then
        littleDialogue.characterNames[1] = "Eric"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_southpark.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_southpark")
        starman.duration[996] = lunatime.toTicks(15.0072)
        starman.duration[994] = lunatime.toTicks(15.0072)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMG4" then
        littleDialogue.characterNames[1] = "SMG4"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SPONGEBOBSQUAREPANTS" then
        littleDialogue.characterNames[1] = "SpongeBob"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-spongebob.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_spongebob")
        starman.duration[996] = lunatime.toTicks(17.004)
        starman.duration[994] = lunatime.toTicks(17.004)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/SpongeBobSquarePants/door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "PRINCESSRESCUE" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("starman/starman_princessrescue.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_princessrescue.ogg")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMB0" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_smb0.ogg"
    end
    if currentCostume == "SMW-MARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(17.004)
        starman.duration[994] = lunatime.toTicks(17.004)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "GA-CAILLOU" then
        littleDialogue.characterNames[1] = "Caillou"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_goanimate.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_goanimate")
        starman.duration[996] = lunatime.toTicks(17.004)
        starman.duration[994] = lunatime.toTicks(17.004)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_goanimate.ogg"
    end
    if currentCostume == "Z-SMW2-ADULTMARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw2.ogg")
        starman.duration[996] = lunatime.toTicks(19.9992)
        starman.duration[994] = lunatime.toTicks(19.9992)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/Z-SMW2-AdultMario/door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMBDDX-MARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("starman/starmanmegashroom_smbddx")
        starman.sfxFile = Misc.resolveSoundFile("starman/starmanmegashroom_smbddx")
        starman.duration[996] = lunatime.toTicks(14)
        starman.duration[994] = lunatime.toTicks(14)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_smbddx.ogg"
    end
    if currentCostume == "SMM2-LUIGI" then
        littleDialogue.characterNames[1] = "Luigi"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMM2-MARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMM2-TOAD" then
        littleDialogue.characterNames[1] = "Toad"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMM2-TOADETTE" then
        littleDialogue.characterNames[1] = "Toadette"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMM2-YELLOWTOAD" then
        littleDialogue.characterNames[1] = "Toad"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_snes.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw")
        starman.duration[996] = lunatime.toTicks(10)
        starman.duration[994] = lunatime.toTicks(10)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "GO-10SECONDRUN" then
        littleDialogue.characterNames[1] = "Runner Red"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "ROSA-ISABELLA" then
        littleDialogue.characterNames[1] = "Rosa"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "ZERO-SONIC" then
        littleDialogue.characterNames[1] = "Zero"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    if currentCostume == "00-SPENCEREVERLY" then
        littleDialogue.characterNames[2] = "Spencer"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_smbs.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smbs.ogg")
        starman.duration[996] = lunatime.toTicks(19.9992)
        starman.duration[994] = lunatime.toTicks(19.9992)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "09-SMB3-MARIOCLOTHES" then
        littleDialogue.characterNames[2] = "Marigi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "14-SMA1" then
        littleDialogue.characterNames[2] = "Luigi"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_sma1")
        starman.duration[996] = lunatime.toTicks(9.0012)
        starman.duration[994] = lunatime.toTicks(9.0012)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_sma2.ogg"
    end
    if currentCostume == "LARRYTHECUCUMBER" then
        littleDialogue.characterNames[2] = "Larry"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/luigi/LarryTheCucumber/door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "WALUIGI" then
        littleDialogue.characterNames[2] = "Waluigi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "A2XT-IRIS" then
        littleDialogue.characterNames[2] = "Iris"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt.ogg")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "UNDERTALE-FRISK" then
        littleDialogue.characterNames[2] = "Frisk"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_undertale")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_undertale")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/luigi/Undertale-Frisk/door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "GA-BORIS" then
        littleDialogue.characterNames[2] = "Boris"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_goanimate")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_goanimate")
        starman.duration[996] = lunatime.toTicks(17.004)
        starman.duration[994] = lunatime.toTicks(17.004)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SHANTAE" then
        littleDialogue.characterNames[2] = "Shantae"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    
    if currentCostume == "A2XT-KOOD" then
        littleDialogue.characterNames[3] = "Kood"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt.ogg")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "DAISY" then
        littleDialogue.characterNames[3] = "Daisy"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "KIRBY-SMB3" then
        littleDialogue.characterNames[3] = "Kirby"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "PAULINE" then
        littleDialogue.characterNames[3] = "Pauline"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "NINJABOMBERMAN" then
        littleDialogue.characterNames[3] = "Plunder Bomber"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_superbomberman5")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "TUX" then
        littleDialogue.characterNames[3] = "Tux"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_supertux")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    if currentCostume == "SEE-TANGENT" then
        littleDialogue.characterNames[4] = "Tangent"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom-nintendogs")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_nintendogs")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SONIC" then
        littleDialogue.characterNames[4] = "Sonic"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_sonic")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_sonic")
        starman.duration[996] = lunatime.toTicks(19.9992)
        starman.duration[994] = lunatime.toTicks(19.9992)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "IMAJIN-NES" then
        littleDialogue.characterNames[4] = "Imajin"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_ddp")
        starman.duration[996] = lunatime.toTicks(8)
        starman.duration[994] = lunatime.toTicks(8)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "JASMINE" then
        littleDialogue.characterNames[4] = "Jasmine"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "LEGOSTARWARS-REBELTROOPER" then
        littleDialogue.characterNames[4] = "Rebel Trooper"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_starwars")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_starwars")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/LEGOStarWars-RebelTrooper/door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_starwars.ogg"
    end
    if currentCostume == "MOTHERBRAINRINKA" then
        littleDialogue.characterNames[4] = "Mother Brain Rinka"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "TOADETTE" then
        littleDialogue.characterNames[4] = "Toadette"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "YOSHI-SMB3" then
        littleDialogue.characterNames[4] = "Yoshi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "A2XT-RAOCOW" then
        littleDialogue.characterNames[4] = "Raocow"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "PACMAN-ARRANGEMENT-PACMAN" then
        littleDialogue.characterNames[4] = "Pac-Man"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_pacmanarrangement")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_pacmanarrangement")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "DIGDUG-DIGGINGSTRIKE" then
        littleDialogue.characterNames[4] = "Taizo"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_digdug")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_digdug")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    
    if currentCostume == "A2XT-SHEATH" then
        littleDialogue.characterNames[5] = "Sheath"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_a2xt.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_a2xt.ogg")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SMB3-BANDANA-DEE" then
        littleDialogue.characterNames[5] = "Bandana Dee"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "NESS" then
        littleDialogue.characterNames[5] = "Ness"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_earthbound.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_earthbound.ogg")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_earthbound.ogg"
    end
    if currentCostume == "TAKESHI" then
        littleDialogue.characterNames[5] = "Takeshi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/link/Takeshi/door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "SEE-SHERBERTLUSSIEBACK" then
        littleDialogue.characterNames[5] = "Sherbert"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "TAKESHI-SNES" then
        littleDialogue.characterNames[5] = "Takeshi"
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    if currentCostume == "SMA3" then
        littleDialogue.characterNames[10] = "Yoshi"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_sma3.ogg")
        starman.duration[996] = lunatime.toTicks(22.9944)
        starman.duration[994] = lunatime.toTicks(22.9944)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    
    
    if currentCostume == "SMW2-YOSHI" then
        littleDialogue.characterNames[9] = "Yoshi"
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "YS-GREEN" then
        littleDialogue.characterNames[9] = "Yoshi"
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    
    
    
    
    
    
    
    
    if (character == CHARACTER_STEVE) == true then
        mega2.sfxFile = Misc.resolveSoundFile("megashroom")
        starman.sfxFile = Misc.resolveSoundFile("starman")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
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
    
    
    
    
    
    
    --Starman/Megashroom themes/default settings for default characters
    if (currentCostume == "N/A" or currentCostume == "!DEFAULT") and not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        steve.skinSettings.name = "steve"
        if not Cheats.get("waitinginthesky").active then
            if player.character == CHARACTER_YOSHI then
                mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_smw2")
                starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw2")
            else
                mega2.sfxFile = Misc.resolveSoundFile("megashroom")
                starman.sfxFile = Misc.resolveSoundFile("starman")
            end
            starman.duration[996] = lunatime.toTicks(12)
            starman.duration[994] = lunatime.toTicks(12)
        end
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
    end
end

return smasCharacterInfo