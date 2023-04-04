console:println("globalgenerals is now loading...")

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
    console:println("Classic Battle Mode active! Loading the pause menu library...")
    pausemenu2 = require("pausemenu2")
end

_G.smasacecoins = require("smasacecoins")
_G.smascharacterinfo = require("smascharacterinfo")
_G.smascharacterintros = require("smascharacterintros")
_G.smaslayersystem = require("smaslayersystem")
_G.smasextraactions = require("smasextraactions")
_G.smasblocksystem = require("smasblocksystem")
_G.smaspswitch = require("smaspswitch")
_G.smasenemysystem = require("smasenemysystem")
_G.smasnpcsystem = require("smasnpcsystem")
_G.smas2playersystem = require("smas2playersystem")
_G.smasresolutions = require("smasresolutions")

if SMBX_VERSION == VER_SEE_MOD then
    smasonlineplay = require("smasonlineplay")
end

local numberfont = textplus.loadFont("littleDialogue/font/1.ini")

if table.icontains(smastables._noLevelPlaces,Level.filename()) == false then
    if not SaveData.disableX2char then
        if SaveData.accessibilityTwirl then
            console:println("Twirling activated! Loading twirl library...")
            twirl = require("Twirl")
        end
        if SaveData.accessibilityWallJump then
            console:println("Wall jumping activated! Loading the anotherwalljump library...")
            aw = require("anotherwalljump")
            aw.registerAllPlayersDefault()
        end
        if SaveData.accessibilityGroundPound then
            console:println("Ground pounding activated! Loading GroundPound library...")
            GP = require("GroundPound")
            GP.enabled = true
        end
    end
end

if GameData.rushModeActive == true then
    console:println("Rush mode active! Loading rush mode dependencies...")
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

local easterCrash = false
local easterCrashDone = false
local easterCrashMsg = false
local easterCrashPrevLoad = false
local blockIdx5000Check = false

SaveData._anothercurrency = {SaveData.totalCoins}

if (table.icontains(smastables._noTransitionLevels,Level.filename())) or (GameData.rushModeActive) then
    warpTransition.musicFadeOut = false
    warpTransition.levelStartTransition = warpTransition.TRANSITION_NONE
    warpTransition.sameSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.crossSectionTransition = warpTransition.TRANSITION_NONE
    warpTransition.activateOnInstantWarps = false
end

if SaveData.disableX2char then
    console:println("1.3 Mode active! Changing some settings...")
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
    console:println("1.3 Mode Easter Egg found!")
    easterCrashPrevLoad = true
    smasbooleans.musicMuted = true
    Sound.playSFX("easteregg_smbx13crash.ogg")
    easterCrashMsg = true
    Routine.wait(2, true)
    smasbooleans.musicMuted = false
    Routine.wait(20, true)
    easterCrashMsg = false
    easterCrashDone = true
    easterCrash = false
end

--New pause menu was made, this is to prevent the old pause menu from opening
function globalgenerals.onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function globalgenerals.onEvent(eventName)
    if eventName then --If it executes any event...
        if smasbooleans.musicMuted then --If the music has been muted for any reason...
            console:println("Event started while music is muted. Storing changed music to the refresh table...")
            for i = 0,20 do
                if Section(i).music ~= 0 then --If the music is anything but 0...
                    Sound.refreshMusic(i) --Refresh that specific section
                    Sound.muteMusic(i) --Then mute
                end
            end
        end
    end
end

if GameData.tempReserve == nil then
    GameData.tempReserve = {}
    for i = 1,200 do
        GameData.tempReserve[i] = 0
    end
end

function globalgenerals.onStart()
    Sound.startupRefreshSystem()
    Playur.failsafeStartupPlayerCheck()
    smasresolutions.changeResolution()
    if Misc.inEditor() then
        debugbox = require("debugbox")
        debugbox.bootactive = true
        if SMBX_VERSION == VER_SEE_MOD then
            Misc.setNewTestModeLevelData(Level.filename())
            console:println("SEE MOD ACTIVE! Editor level starter has been set to "..Level.filename()..".")
        end
    end
    if GameData.____mainMenuComplete == true then
        if (mem(0x00B25724, FIELD_STRING) == "SMAS - Start.lvlx") then
            mem(0x00B25724, FIELD_STRING, "map.lvlx")
        end
    end
    if SaveData.lastLevelPlayed == nil then
        SaveData.lastLevelPlayed = Level.filename()
    end
    Sound.checkPWingSoundStatus()
    Sound.checkSMBXSoundSystemStatus()
    for _,p in ipairs(Player.get()) do
        if Misc.inEditor() then
            if GameData.tempReserve ~= {} and GameData.tempReserve ~= nil then
                p.reservePowerup = GameData.tempReserve[p.idx]
            end
        end
    end
end

function globalgenerals.onTickEnd()
    -- Fix blinking when starting the level/changing sections (Thanks MDA!)
    mem(0x00B250D4,FIELD_BOOL,false)
end

function globalgenerals.onTick()
    if lunatime.tick() == 1 then
        Sound.loadCostumeSounds()
    end
    for _,p in ipairs(Player.get()) do
        SaveData.reserveBoxItem[p.idx] = p.reservePowerup
    end
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
            blockIdx5000Check = true
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
    --[[if SaveData.goombaStomps >= 10 then
        Achievements.get(1):collect()
    end]]
end

function globalgenerals.onPostNPCKill(npc, harmType)
    for _,p in ipairs(Player.get()) do
        if smastables.allGoombaNPCIDs[npc.id] then
            SaveData.goombaStomps = SaveData.goombaStomps + 1
            console:println(tostring(SaveData.goombaStomps).." Goombas have been stomped in total.")
        end
        if smastables.allKoopaNPCIDs[npc.id] then
            SaveData.koopaStomps = SaveData.koopaStomps + 1
            console:println(tostring(SaveData.koopaStomps).." Koopas have been stomped in total.")
        end
        if smastables.allStarmanNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.starmansused = SaveData.starmansused + 1
            console:println(tostring(SaveData.starmansused).." Starman's have been used in total.")
        end
        if npc.id == 997 and Colliders.collide(p, npc) then
            SaveData.megamushroomssused = SaveData.megamushroomssused + 1
            console:println(tostring(SaveData.megamushroomssused).." Mega Mushroom's have been used in total.")
        end
        if smastables.allCollectableStarNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.starsgrabbed = SaveData.starsgrabbed + 1
            console:println(tostring(SaveData.starsgrabbed).." stars have been grabbed in total.")
        end
        if smastables.allCoinNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.totalCoins = SaveData.totalCoins + 1
            console:println(tostring(SaveData.totalCoins).." coins have been collected in total.")
        end
        if smastables.allMushroomNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.totalmushrooms = SaveData.totalmushrooms + 1
            console:println(tostring(SaveData.totalmushrooms).." Mushrooms have been used in total.")
        end
        if smastables.allFireFlowerNPCIDs[npc.id] and Colliders.collide(p, npc) then
            SaveData.totalfireflowers = SaveData.totalfireflowers + 1
            console:println(tostring(SaveData.totalfireflowers).." Fire Flowers have been used in total.")
        end
        if npc.id == 34 and Colliders.collide(p, npc) then
            SaveData.totalleafs = SaveData.totalleafs + 1
            console:println(tostring(SaveData.totalleafs).." Super Leafs have been used in total.")
        end
        if npc.id == 169 and Colliders.collide(p, npc) then
            SaveData.totaltanookis = SaveData.totaltanookis + 1
            console:println(tostring(SaveData.totaltanookis).." Tanooki Suits have been used in total.")
        end
        if npc.id == 170 and Colliders.collide(p, npc) then
            SaveData.totalhammersuits = SaveData.totalhammersuits + 1
            console:println(tostring(SaveData.totalhammersuits).." Hammer Suits have been used in total.")
        end
        if npc.id == 277 or npc.id == 264 and Colliders.collide(p, npc) then
            SaveData.totaliceflowers = SaveData.totaliceflowers + 1
            console:println(tostring(SaveData.totaliceflowers).." Ice Flowers have been used in total.")
        end
        if SaveData.disableX2char then
            if smastables.allInteractableNPCIDs[npc.id] then
                if blockIdx5000Check then
                    if harmType == HARM_TYPE_LAVA then
                        easterCrash = true
                        if not easterCrashPrevLoad then
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
    
    if easterCrashMsg then
        textplus.print{x=145, y=80, text = "Congrats! You reached more than the 5000th block idx and burned a ", priority=-3, color=Color.yellow, font=statusFont}
        textplus.print{x=155, y=90, text = "collectable in the lava. This would've crashed SMBX 1.3!", priority=-3, color=Color.yellow, font=statusFont}
        textplus.print{x=195, y=100, text = "You're really good at finding secrets, player ;)", priority=-3, color=Color.yellow, font=statusFont}
    end
    
    for _,p in ipairs(Player.get()) do --Custom reserve storage
        if p.reservePowerup ~= 0 then
            SaveData.reserveBoxItem[_] = p.reservePowerup
            p.reservePowerup = 0
        end
    end
end

function globalgenerals.onExitLevel(winType)
    SysManager.exitLevel(winType)
end

function globalgenerals.onExit()
    if mem(0x00B2C5AC,FIELD_FLOAT) == 0 then
        if (killed == true or killed2 == true) then
            mem(0x00B2C5AC,FIELD_FLOAT,1)
            Level.load(Level.filename())
        end
    end
    if mem(0x00B2C89C, FIELD_BOOL) then --Let's prevent the credits from execution.
        console:println("Credits exiting detected! Exiting to the credits level...")
        Level.load("SMAS - Credits.lvlx")
    end
    if not table.icontains(smastables._friendlyPlaces,Level.filename()) then
        SaveData.lastLevelPlayed = Level.filename()
    end
    if not Misc.inMarioChallenge() then
        for _,p in ipairs(Player.get()) do
            if Misc.inEditor() then
                GameData.tempReserve[p.idx] = p.reservePowerup
            end
        end
        File.writeToFile("loadscreeninfo.txt", SaveData.resolution)
    elseif Misc.inMarioChallenge() then
        File.writeToFile("loadscreeninfo.txt", "mariochallenge")
    end
end

return globalgenerals