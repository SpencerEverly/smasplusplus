local starman = require("starman/star")
local mega2 = require("mega/megashroom")
local playerManager = require("playermanager")
local littleDialogue = require("littleDialogue")
local extendedKoopas = require("extendedKoopas")
local warpTransition = require("warpTransition")
local textplus = require("textplus")
local repll = require("repll")
local namehover = require("namehover")
local hearthover = require("hearthover")
local steve = require("steve")
local yoshi = require("yiYoshi/yiYoshi")
local inventory = require("customInventory")
local inputconfigurator = require("inputconfig")
local customCamera = require("customCamera")
local smallScreen = require("smallScreen")
local musicalchairs = require("musicalchairs")

if GameData.enableBattleMode then
    pausemenu2 = require("pausemenu2")
end

_G.smasacecoins = require("smasacecoins")
_G.smascharacterinfo = require("smascharacterinfo")
_G.smascharacterintros = require("smascharacterintros")
_G.smasextraactions = require("smasextraactions")
_G.smasblocksystem = require("smasblocksystem")
_G.smaspswitch = require("smaspswitch")
_G.smasenemysystem = require("smasenemysystem")
_G.smas2playersystem = require("smas2playersystem")
_G.smasresolutions = require("smasresolutions")

if SMBX_VERSION == VER_SEE_MOD then
    smasonlineplay = require("smasonlineplay")
end

local numberfont = textplus.loadFont("littleDialogue/font/1.ini")

if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
    if not SaveData.disableX2char then
        if SaveData.accessibilityTwirl then
            twirl = require("Twirl")
        end
        if SaveData.accessibilityWallJump then
            aw = require("anotherwalljump")
            aw.registerAllPlayersDefault()
        end
        if SaveData.accessibilityGroundPound then
            GP = require("GroundPound")
            GP.enabled = true
        end
    end
end

if GameData.rushModeActive == true then
    level_dependencies_rushmode = require("level_dependencies_rushmode")
end

if SaveData.SMB1HardModeActivated == nil then
    SaveData.SMB1HardModeActivated = false
end
if SaveData.SMB1LLAllNightNipponActivated == nil then
    SaveData.SMB1LLAllNightNipponActivated = false
end
if SaveData.WSMBAOriginalGraphicsActivated == nil then
    SaveData.WSMBAOriginalGraphicsActivated = false
end
if SaveData.SMA1ModeActivated == nil then
    SaveData.SMA1ModeActivated = false
end

if SaveData.framerateEnabled == nil then
    SaveData.framerateEnabled = false
end
if SaveData.disablePWingSFX == nil then
    SaveData.disablePWingSFX = false
end
if SaveData.SMBXSoundSystem == nil then
    SaveData.SMBXSoundSystem = false
end

namehover.active = false
local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

smashud.visible.starcoins = false
GameData.activateAbilityMessage = false

local eastercrash = false
local eastercrashdone = false
local eastercrashmsg = false
local eastercrashprevload = false
local blockidx5000check = false

local nesborder = Graphics.loadImageResolved("graphics/resolutionborders/nes.png")
local gbborder = Graphics.loadImageResolved("graphics/resolutionborders/gb.png")
local gbaborder = Graphics.loadImageResolved("graphics/resolutionborders/gba.png")
local iphoneoneborder = Graphics.loadImageResolved("graphics/resolutionborders/iphone1st.png")
local threedsborder = Graphics.loadImageResolved("graphics/resolutionborders/3ds.png")

SaveData._anothercurrency = {SaveData.totalCoins}

if (table.icontains(smastables._noTransitionLevels,Level.filename())) or (GameData.rushModeActive) then
    warpTransition.musicFadeOut = false
    warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
    warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.activateOnInstantWarps = false
end

if SaveData.disableX2char then
    warpTransition.musicFadeOut = false
    warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
    warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.activateOnInstantWarps = false
    extrasounds.enableFireFlowerHitting = false
    local keyhole = require("tweaks/keyhole") --Disable X2 keyhole effect
    keyhole.onCameraDraw = function() end
    mega2.sfxFile = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom13.ogg")
    mega2.megagrowsfx = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom-grow-1.3.ogg")
    mega2.megashrinksfx = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom-shrink-1.3.ogg")
    mega2.megarunningoutsfx = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/megashroom-runningout-1.3.ogg")
    starman.sfxFile = Misc.resolveSoundFile("_OST/_Sound Effects/1.3Mode/starman.ogg")
end

local killed = false
local killed2 = false

local pipecounter = 0
local pipecounter2 = 0
local doorcounter = 0
local doorcounter2 = 0
local fadetolevel = false

local ready = false

local globalgenerals = {}

function globalgenerals.onInitAPI()
    registerEvent(globalgenerals,"onExit")
    registerEvent(globalgenerals,"onExitLevel")
    registerEvent(globalgenerals,"onStart")
    registerEvent(globalgenerals,"onTick")
    registerEvent(globalgenerals,"onTickEnd")
    registerEvent(globalgenerals,"onCameraUpdate")
    registerEvent(globalgenerals,"onInputUpdate")
    registerEvent(globalgenerals,"onEvent")
    registerEvent(globalgenerals,"onDraw")
    registerEvent(globalgenerals,"onPlayerHarm")
    registerEvent(globalgenerals,"onPostNPCKill")
    registerEvent(globalgenerals,"onPostBlockHit")
    registerEvent(globalgenerals,"onBlockHit")
    registerEvent(globalgenerals,"onPause")
    registerEvent(globalgenerals,"onExplosion")
    registerEvent(globalgenerals,"onKeyboardPress")
    registerEvent(globalgenerals,"onControllerButtonPress")
    
    local Routine = require("routine")
    
    ready = true
end

function lavaShroomEasterEgg()
    eastercrashprevload = true
    smasbooleans.musicMuted = true
    Sound.playSFX("easteregg_smbx13crash.ogg")
    eastercrashmsg = true
    Routine.wait(2, true)
    smasbooleans.musicMuted = false
    Routine.wait(20, true)
    eastercrashmsg = false
    eastercrashdone = true
    eastercrash = false
end

--New pause menu was made, this is to prevent the old pause menu from opening
function globalgenerals.onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function globalgenerals.onEvent(eventName)
    if eventName then --If it executes any event...
        if smasbooleans.musicMuted then --If the music has been muted for any reason...
            for i = 0,20 do
                if Section(i).music ~= 0 then --If the music is anything but 0...
                    Sound.refreshMusic(i) --Refresh that specific section
                    Sound.muteMusic(i) --Then mute
                end
            end
        end
    end
end

function globalgenerals.onStart()
    Sound.loadCostumeSounds()
    Sound.startupRefreshSystem()
    Playur.failsafeStartupPlayerCheck()
    if Misc.inEditor() then
        debugbox = require("debugbox")
        debugbox.bootactive = true
    end
    if GameData.____mainMenuComplete == true then
        if (mem(0x00B25724, FIELD_STRING) == "SMAS - Start.lvlx") then
            mem(0x00B25724, FIELD_STRING, "map.lvlx")
        end
    end
    if SaveData.lastLevelPlayed == nil then
        SaveData.lastLevelPlayed = Level.filename()
    end
    if SaveData.disablePWingSFX then
        extrasounds.enablePWingSFX = false
    elseif not SaveData.disablePWingSFX then
        extrasounds.enablePWingSFX = true
    end
    if SaveData.SMBXSoundSystem then
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

function CheckStarAvailability()
    GameData.activateAbilityMessage = false
end

function ExitFeature()
    GameData.activateAbilityMessage = false
end

littleDialogue.registerAnswer("WallOfWeaponsDialog",{text = "Yes",chosenFunction = function() Routine.run(CheckStarAvailability) end})
littleDialogue.registerAnswer("WallOfWeaponsDialog",{text = "No",chosenFunction = function() Routine.run(ExitFeature) end})

local cooldown = 0

function globalgenerals.checkSpecialAbilityMessage()
    if SaveData.currentCostume == "GA-BORIS" then
        if not Misc.isPaused() then
            if SaveData.toggleCostumeAbilities == true then
                if player.keys.altRun == KEYS_PRESSED and GameData.activateAbilityMessage == false or GameData.activateAbilityMessage == nil then
                    if table.icontains(smastables._friendlyPlaces,Level.filename()) == false then
                        player:mem(0x172, FIELD_BOOL, false)
                        cooldown = 5
                        GameData.activateAbilityMessage = true
                        littleDialogue.create({text = "<boxStyle smbx13><setPos 400 32 0.5 -1.4>Would you like to use The Wall of Weapons? You can only use this every 5 stars you collect.<question WallOfWeaponsDialog>", pauses = true, updatesInPause = true})
                        if cooldown <= 0 then
                            player:mem(0x172, FIELD_BOOL, true)
                        end
                    else
                        player:mem(0x172, FIELD_BOOL, false)
                        cooldown = 10
                        if cooldown <= 0 then
                            player:mem(0x172, FIELD_BOOL, true)
                        end
                    end
                end
            end
        end
    end
end

function globalgenerals.onTickEnd()
    -- Fix blinking when starting the level/changing sections (Thanks MDA!)
    mem(0x00B250D4,FIELD_BOOL,false)
end

function globalgenerals.onTick()
    if smasbooleans.compatibilityMode13Mode then
        mem(0x00B2C860, FIELD_FLOAT, 7.0999999046326)
    else
        mem(0x00B2C860, FIELD_FLOAT, 6.2)
    end
    if table.icontains(smastables.__wsmbaLevels,Level.filename()) then
        if not SaveData.disableX2char then
            littleDialogue.defaultStyleName = "smbx13"
        end
        warpTransition.musicFadeOut = false
        warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
        warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
        warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
        warpTransition.activateOnInstantWarps = false
    end
    if player.character == CHARACTER_SNAKE then
        smashud.visible.keys = true
        smashud.visible.itembox = true
        smashud.visible.bombs = true
        smashud.visible.coins = true
        smashud.visible.stars = true
        smashud.visible.timer = true
        smashud.visible.levelname = true
        smashud.visible.overworldPlayer = true
    end
    if player.character == CHARACTER_NINJABOMBERMAN then
        smashud.visible.keys = true
        smashud.visible.itembox = true
        smashud.visible.bombs = true
        smashud.visible.coins = true
        smashud.visible.stars = true
        smashud.visible.timer = true
        smashud.visible.levelname = true
        smashud.visible.overworldPlayer = true
    end
    if player.character == CHARACTER_UNCLEBROADSWORD then
        --smashud.visible.lives = false
    end
    if player.character == CHARACTER_ULTIMATERINKA then
        smashud.visible.keys = true
        smashud.visible.itembox = true
        smashud.visible.bombs = true
        smashud.visible.coins = true
        smashud.visible.stars = true
        smashud.visible.timer = true
        smashud.visible.levelname = true
        smashud.visible.overworldPlayer = true
    end
    for k,block in ipairs(Block.get(smastables.allLavaBlockIDs)) do
        if block.idx >= 5000 then --Easter egg block IDX detection, for the epic 1.3 mode crash thingy
            blockidx5000check = true
        end
    end
    
    if SaveData.currentCostume == "SMB3-WALUIGI" and SaveData.currentCharacter == CHARACTER_YOSHI then
        Player.setCostume(10, nil)
    end
    
    if SaveData.GameOverCount == nil then
        SaveData.GameOverCount = 0
    end
    
    if SaveData.goombaStomps == nil then
        SaveData.goombaStomps = 0
    end
    if SaveData.koopaStomps == nil then
        SaveData.koopaStomps = 0
    end
    
    if SaveData.starmansused == nil then
        SaveData.starmansused = 0
    end
    if SaveData.megamushroomssused == nil then
        SaveData.megamushroomssused = 0
    end
    if SaveData.starsgrabbed == nil then
        SaveData.starsgrabbed = 0
    end
    if SaveData.totalmushrooms == nil then
        SaveData.totalmushrooms = 0
    end
    if SaveData.totalfireflowers == nil then
        SaveData.totalfireflowers = 0
    end
    if SaveData.totalleafs == nil then
        SaveData.totalleafs = 0
    end
    if SaveData.totaltanookis == nil then
        SaveData.totaltanookis = 0
    end
    if SaveData.totalhammersuits == nil then
        SaveData.totalhammersuits = 0
    end
    if SaveData.totaliceflowers == nil then
        SaveData.totaliceflowers = 0
    end
    if SaveData.mandatoryStars == nil then
        SaveData.mandatoryStars = 0
    end
    --if SaveData.totalMandatoryStars == nil then
        --SaveData.totalMandatoryStars = 999 --Value isn't final, until all levels are made
    --end
    
    
    
    --Achievements
    if SaveData.goombaStomps >= 10 then
        Achievements.get(1):collect()
    end
end

function globalgenerals.onPostNPCKill(npc, harmType)
    for _,p in ipairs(Player.get()) do
        if smastables.allGoombaNPCIDs[npc.id] then
            SaveData.goombaStomps = SaveData.goombaStomps + 1
        end
        if smastables.allKoopaNPCIDs[npc.id] then
            SaveData.koopaStomps = SaveData.koopaStomps + 1
        end
        if smastables.allStarmanNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.starmansused = SaveData.starmansused + 1
        end
        if npc.id == 997 and Colliders.collide(p, npc) then
            SaveData.megamushroomssused = SaveData.megamushroomssused + 1
        end
        if smastables.allCollectableStarNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.starsgrabbed = SaveData.starsgrabbed + 1
        end
        if smastables.allCoinNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.totalCoins = SaveData.totalCoins + 1
        end
        if smastables.allMushroomNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.totalmushrooms = SaveData.totalmushrooms + 1
        end
        if smastables.allFireFlowerNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.totalfireflowers = SaveData.totalfireflowers + 1
        end
        if npc.id == 34 and Colliders.collide(p, npc) then
            SaveData.totalleafs = SaveData.totalleafs + 1
        end
        if npc.id == 169 and Colliders.collide(p, npc) then
            SaveData.totaltanookis = SaveData.totaltanookis + 1
        end
        if npc.id == 170 and Colliders.collide(p, npc) then
            SaveData.totalhammersuits = SaveData.totalhammersuits + 1
        end
        if npc.id == 277 or npc.id == 264 and Colliders.collide(p, npc) then
            SaveData.totaliceflowers = SaveData.totaliceflowers + 1
        end
        if SaveData.disableX2char then
            if smastables.allInteractableNPCIDs[npc.id] then
                if blockidx5000check then
                    if harmType == HARM_TYPE_LAVA then
                        eastercrash = true
                        if not eastercrashprevload then
                            Routine.run(lavaShroomEasterEgg)
                        end
                    end
                end
            end
        end
    end
end

local frametimer = 0
local actualframecount

function globalgenerals.onDraw()
    if not SaveData.disableX2char then
        if player.character <= 5 then
            if SaveData.currentCostume == "N/A" then
                local costumes = playerManager.getCostumes(player.character)
                local currentCostume = player:getCostume()
                local costumeIdx = table.ifind(costumes,currentCostume)
                player:setCostume(costumes[1])
            end
        end
    elseif SaveData.disableX2char then
        if player.character <= 5 then
            if SaveData.currentCostume ~= "N/A" then
                player:setCostume(nil)
            end
        end
    end
    if SaveData._basegame.hud.score >= 9999900 then --Fixing combo sounds when score is set as it's max
        SaveData._basegame.hud.score = 9990000
    end
    
    --Framerate timer stuff
    frametimer = frametimer + 1
    if actualframecount == nil then
        actualframecount = tostring(0)
    end
    if not Misc.isPaused() then
        if frametimer >= 65 then
            actualframecount = tostring(mem(0x00B2C670, FIELD_DWORD))
            frametimer = 0
        end
    end
    if SaveData.framerateEnabled then
        textplus.print{x = 8, y = 8, text = actualframecount, font = numberfont, priority = 0, xscale = 1, yscale = 1}
    end
    
    if eastercrashmsg then
        textplus.print{x=145, y=80, text = "Congrats! You reached more than the 5000th block idx and burned a ", priority=-3, color=Color.yellow, font=statusFont}
        textplus.print{x=155, y=90, text = "collectable in the lava. This would've crashed SMBX 1.3!", priority=-3, color=Color.yellow, font=statusFont}
        textplus.print{x=195, y=100, text = "You're really good at finding secrets, player ;)", priority=-3, color=Color.yellow, font=statusFont}
    end
end

function globalgenerals.onKeyboardPress(keyCode, repeated)
    if SaveData.toggleCostumeAbilities == true then
        if keyCode == smastables.keyboardMap[SaveData.specialkey1stplayer] and not repeated then
            globalgenerals.checkSpecialAbilityMessage()
        end
    end
end

function globalgenerals.onControllerButtonPress(button, playerIdx)
    if not SaveData.disableX2char then
        if SaveData.toggleCostumeAbilities then
            if playerIdx == 1 then
                if button == SaveData.specialbutton1stplayer then
                    globalgenerals.checkSpecialAbilityMessage()
                end
            end
        end
    end
end

function globalgenerals.onExitLevel(winType)
    if not Misc.inMarioChallenge() then
        if winType >= 1 and winType ~= LEVEL_END_STATE_GAMEEND then
            if not Misc.inEditor() then
                Level.load("map.lvlx")
            elseif Misc.inEditor() then
                Level.load(SaveData.editorWinnerLevelReload)
            end
        elseif winType == LEVEL_END_STATE_GAMEEND then
            Level.load("SMAS - Credits.lvlx")
        elseif winType == LEVEL_END_STATE_SMB2ORB then
            if not Misc.inEditor() then
                Level.load("map.lvlx")
            elseif Misc.inEditor() then
                Level.load(SaveData.editorWinnerLevelReload)
            end
        end
    end
end

function globalgenerals.onExit()
    if mem(0x00B2C5AC,FIELD_FLOAT) == 0 then
        if (killed == true or killed2 == true) then
            Level.load(Level.filename())
            mem(0x00B2C5AC,FIELD_FLOAT,1)
        end
    end
    if mem(0x00B2C89C, FIELD_BOOL) then --Let's prevent the credits from execution.
        Level.load("SMAS - Credits.lvlx")
    end
    if not table.icontains(smastables._friendlyPlaces,Level.filename()) then
        SaveData.lastLevelPlayed = Level.filename()
    end
    if not Misc.inMarioChallenge() then
        File.writeToFile("loadscreeninfo.txt", SaveData.resolution)
    elseif Misc.inMarioChallenge() then
        File.writeToFile("loadscreeninfo.txt", "mariochallenge")
    end
end

return globalgenerals