local smasCharacterInfo = {}

local littleDialogue
pcall(function() littleDialogue = require("littleDialogue") end)
local starman = require("starman/star")
local mega2 = require("mega/megashroom")
local playerManager = require("playermanager")
local steve = require("steve")
local yoshi = require("yiYoshi/yiYoshi")

if SaveData.currentCostume == nil then
    SaveData.currentCostume = "N/A"
end

function smasCharacterInfo.onInitAPI()
    registerEvent(smasCharacterInfo,"onStart")
end

smasCharacterInfo.costumeSpecifics = {}
smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"

function smasCharacterInfo.registerCharacterInfo(costumeName, name, characterID, starmanTheme, DDPStarmanTheme, megashroomTheme, starmanDuration, doorCloseSFX, pSwitchTheme)
    if costumeName == nil then
        error("Must input costume name for registering this character!")
        return
    end
    if characterID == nil then
        error("Must input character ID for registering this character!")
        return
    end
    if name == nil then
        error("Must input name for registering this character!")
        return
    end
    if starmanTheme == nil then
        starmanTheme = Misc.resolveSoundFile("starman")
    end
    if DDPStarmanTheme == nil then
        DDPStarmanTheme = Misc.resolveSoundFile("starman")
    end
    if megashroomTheme == nil then
        starmanTheme = Misc.resolveSoundFile("megashroom")
    end
    if starmanDuration == nil then
        starman.duration[996] = lunatime.toTicks(starmanDuration)
        starman.duration[994] = lunatime.toTicks(starmanDuration)
    end
    if doorCloseSFX == nil then
        doorCloseSFX = "door-close.ogg"
    end
    if pSwitchTheme == nil then
        if table.icontains(smasTables.__smb3Levels,Level.filename()) then
            smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_smas.ogg"
        elseif table.icontains(smasTables.__smwLevels,Level.filename()) then
            smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_smw.ogg"
        else
            smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
        end
    end
    
    smasCharacterInfo.costumeSpecifics[costumeName] = {}
    smasCharacterInfo.costumeSpecifics[costumeName][characterID] = {}
    smasCharacterInfo.costumeSpecifics[costumeName][characterID].costume = costumeName
    smasCharacterInfo.costumeSpecifics[costumeName][characterID].name = name
    smasCharacterInfo.costumeSpecifics[costumeName][characterID].id = characterID
    smasCharacterInfo.costumeSpecifics[costumeName][characterID].starmanTheme = starmanTheme
    smasCharacterInfo.costumeSpecifics[costumeName][characterID].ddpStarmanTheme = DDPStarmanTheme
    smasCharacterInfo.costumeSpecifics[costumeName][characterID].megashroomTheme = megashroomTheme
    smasCharacterInfo.costumeSpecifics[costumeName][characterID].starmanDuration = starmanDuration
    smasCharacterInfo.costumeSpecifics[costumeName][characterID].doorCloseSFX = doorCloseSFX
    smasCharacterInfo.costumeSpecifics[costumeName][characterID].pSwitchTheme = pSwitchTheme
end

smasCharacterInfo.registerCharacterInfo("00-SMASPLUSPLUS-BETA","Mario",1,"starman/starman_2012beta.ogg","starman/starman_2012beta_ddp.ogg","mega/megashroom_2012beta.ogg",12,"door-close.ogg","pswitch/pswitch_2012beta.ogg")
smasCharacterInfo.registerCharacterInfo("01-SMB1-RETRO","Mario",1,"starman/starman_smb1.ogg","starman/starman_smb1_ddp.ogg","mega/megashroom-smb1.ogg",12,"door-close.ogg","pswitch/pswitch_smb1.ogg")
smasCharacterInfo.registerCharacterInfo("02-SMB1-RECOLORED","Mario",1,"starman/starman_smas_smb1.ogg","starman/starman_smas_smb1.ogg","mega/megashroom_snes.ogg",12,"costumes/mario/01-SMB1-Retro/door-close.ogg","_OST/P-Switch (v2).ogg")
smasCharacterInfo.registerCharacterInfo("03-SMB1-SMAS","Mario",1,"starman/starman_smas.ogg","starman/starman_smas.ogg","mega/megashroom_snes.ogg",12,"door-close.ogg","_OST/P-Switch (v2).ogg")
smasCharacterInfo.registerCharacterInfo("04-SMB2-RETRO","Mario",1,"starman/starman_smb2.ogg","starman/starman_smb2_ddp.ogg","mega/megashroom-smb2.ogg",9.0012,"costumes/mario/04-SMB2-Retro/door-close.ogg","pswitch/pswitch_smb2.ogg")
smasCharacterInfo.registerCharacterInfo("05-SMB2-SMAS","Mario",1,"starman/starman_smas_smb2.ogg","starman/starman_smas_smb2.ogg","mega/megashroom_snes.ogg",9.0012,"door-close.ogg","_OST/P-Switch (v2).ogg")
smasCharacterInfo.registerCharacterInfo("06-SMB3-RETRO","Mario",1,"starman/starman_smb3.ogg","starman/starman_smb3_ddp.ogg","mega/megashroom-smb3.ogg",10.998,"costumes/mario/06-SMB3-Retro/door-close.ogg","pswitch/pswitch_smb3.ogg")
smasCharacterInfo.registerCharacterInfo("07-SML2","Mario",1,"starman/starman_sml2.ogg","starman/starman_sml2.ogg","mega/megashroom_sml2.ogg",13.7,"door-close.ogg","_OST/P-Switch (v2).ogg")

function smasCharacterInfo.onStart()
    smasCharacterInfo.setCostumeSpecifics()
end

function smasCharacterInfo.setCostumeSpecifics()
    console:println("Character information will now be changed.")
    
    local currentCostume = SaveData.currentCostume
    
    if SaveData.disableX2char then
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
    
    if currentCostume == "08-SMBSPECIAL" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_smbspecial.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smbspecial.ogg")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_smbspecial.ogg"
    end
    if currentCostume == "09-SMW-PIRATE" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_smw_pirate.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_smw_pirate.ogg")
        starman.duration[996] = lunatime.toTicks(22)
        starman.duration[994] = lunatime.toTicks(22)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "10-HOTELMARIO" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_hotelmario.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_hotelmario.ogg")
        starman.duration[996] = lunatime.toTicks(12)
        starman.duration[994] = lunatime.toTicks(12)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("costumes/mario/10-HotelMario/door-close.ogg"))
        smasCharacterInfo.pSwitchMusic = "_OST/P-Switch (v2).ogg"
    end
    if currentCostume == "11-SMA1" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_sma1")
        starman.duration[996] = lunatime.toTicks(9.0012)
        starman.duration[994] = lunatime.toTicks(9.0012)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_sma2.ogg"
    end
    if currentCostume == "12-SMA2" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_sma2")
        starman.duration[996] = lunatime.toTicks(17.004)
        starman.duration[994] = lunatime.toTicks(17.004)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_sma2.ogg"
    end
    if currentCostume == "13-SMA4" then
        littleDialogue.characterNames[1] = "Mario"
        mega2.sfxFile = Misc.resolveSoundFile("mega/megashroom_gba.ogg")
        starman.sfxFile = Misc.resolveSoundFile("starman/starman_sma4")
        starman.duration[996] = lunatime.toTicks(10.998)
        starman.duration[994] = lunatime.toTicks(10.998)
        smasExtraSounds.sounds[148].sfx = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg"))
        smasCharacterInfo.pSwitchMusic = "pswitch/pswitch_sma4.ogg"
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
    if (currentCostume == "N/A" or currentCostume == "!DEFAULT") and not SaveData.disableX2char then
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