--smasCharacterChanger.lua (v1.0)
--By Spencer Everly

local smasCharacterChanger = {}

if Misc.inEditor() then
    smasCharacterChanger.inTestMode = true
else
    smasCharacterChanger.inTestMode = false
end

local smasFunctions = require("smasFunctions")

local playerManager = require("playerManager")
local textplus = require("textplus")
local steve = require("steve")
local smbx13font = textplus.loadFont("littleDialogue/font/smilebasic.ini") --The font for the changer menu.

function smasCharacterChanger.onInitAPI()
    registerEvent(smasCharacterChanger,"onStart")
    registerEvent(smasCharacterChanger,"onDraw")
    registerEvent(smasCharacterChanger,"onInputUpdate")
    registerEvent(smasCharacterChanger,"onKeyboardPressDirect")
    
    if SMBX_VERSION == VER_SEE_MOD then
        registerEvent(smasCharacterChanger,"onWindowFocus")
        registerEvent(smasCharacterChanger,"onWindowUnfocus")
    end
end

if SaveData.currentCharacter == nil then
    SaveData.currentCharacter = player.character
end
if SaveData.currentCharacter2 == nil then
    if Player.count() >= 2 then
        SaveData.currentCharacter2 = player2.character
    end
end

smasCharacterChanger.tvImage = Graphics.loadImageResolved("graphics/characterchangermenu/tv-full.png") --The image for the TV.
smasCharacterChanger.scrollSFX = "_OST/_Sound Effects/characterchangermenu/scrolling-tv.ogg"
smasCharacterChanger.stopSFX = "_OST/_Sound Effects/characterchangermenu/scrolled-tv.ogg"
smasCharacterChanger.turnOnSFX = "_OST/_Sound Effects/characterchangermenu/turn-on-tv.ogg"
smasCharacterChanger.moveSFX = 26 --Sound effects used for the menu
smasCharacterChanger.menuActive = false --True if the menu is active.
smasCharacterChanger.animationActive = false --True if the animation is active.
smasCharacterChanger.animationTimer = 0 --Timer for the animation, both for the start and end sequences.
smasCharacterChanger.tvScrollNumber = -628 --This is used for the TV animation sequence.
smasCharacterChanger.menuBGM = "_OST/All Stars Menu/Character Changer Menu.ogg"
smasCharacterChanger.selectionNumber = 1 --For scrolling left and right
smasCharacterChanger.selectionNumberUpDown = 1 --For scrolling up and down
smasCharacterChanger.selectionNumberAlteration = 0 --For choosing an alteration
smasCharacterChanger.oldIniFile = SysManager.loadDefaultCharacterIni() --Used for reverting to the old ini file when exiting the menu without changing to a character
smasCharacterChanger.iniFile = SysManager.loadDefaultCharacterIni() --Used to update the ini format when showing the character on screen
smasCharacterChanger.characterPreviewImagesCostume = {} --Will be used to add character preview images throughout the menu
smasCharacterChanger.characterPreviewImagesCharacter = {} --Will be used to add character preview images throughout the menu

local colorChange1 = 0
local colorChange2 = 0
local colorChange3 = 0

local reserveChange = 0

--These tables below will be used for the system.
smasCharacterChanger.names = {}
smasCharacterChanger.namesGame = {}
smasCharacterChanger.namesCharacter = {}
smasCharacterChanger.namesCostume = {}
smasCharacterChanger.namesAlteration = {}

function smasCharacterChanger.addCharacter(name,game,character,costume) --Adds a character to the tables above. Example: smasCharacterChanger.addCharacter("My Character","Game Information",CHARACTER_NUMBERGOESHERE,"COSTUMEGOESHERE, else nil")
    if name == nil then
        error("You must add a name as a string to this character.")
        return
    end
    if game == nil then
        error("You must add a game as a string to this character.")
        return
    end
    if character == nil then
        error("You must add a character as a string or a number, which specifies the first 16 characters.")
        return
    end
    if costume == nil then
        error("You must add a costume as a string to this character (All caps). If specifying nil, make sure that nil is a string.")
        return
    end
    
    if table.ifind(smasCharacterChanger.names, name) == nil then
        table.insert(smasCharacterChanger.names, name)
        table.insert(smasCharacterChanger.namesGame, {game})
        table.insert(smasCharacterChanger.namesCharacter, character)
        table.insert(smasCharacterChanger.namesCostume, {costume})
    end
end

function smasCharacterChanger.addVariant(nameToFind,game,costume) --Adds a variant to the character table. Example: smasCharacterChanger.addVariant("My Character","Game Information of the 2nd character","COSTUMEGOESHERE of the 2nd character variant")
    if nameToFind == nil then
        error("You must add a name to find who to add this to.")
        return
    end
    if game == nil then
        error("You must add a game as a string to this character.")
        return
    end
    if costume == nil then
        error("You must add a costume as a string to this character (All caps). If specifying nil, make sure that nil is a string.")
        return
    end
    if nameToFind ~= nil then --If not nil...
        local foundName = table.ifind(smasCharacterChanger.names, nameToFind) --The name ID will then be added here.
        if foundName == nil then --But if nil...
            error("Name wasn't found! You need to specify a valid name.") --Error and return it
            return
        else --Or if not...
            if table.ifind(smasCharacterChanger.namesCostume[foundName], costume) == nil then
                table.insert(smasCharacterChanger.namesGame[foundName], game) --Add the info to the tables
                table.insert(smasCharacterChanger.namesCostume[foundName], costume)
            end
        end
    end
end

function smasCharacterChanger.addAlteration(characterName,characterVariant,alterationFolder,alterationName,alterationInfo)
    if characterName == nil then
        error("You must add a name to find who to add this to.")
        return
    end
    if characterVariant == nil then
        error("You must add a costume as a string to this character (All caps). If specifying nil, make sure that nil is a string.")
        return
    end
    if alterationFolder == nil then
        error("You must add a alteration folder name as a string to this character.")
        return
    end
    if alterationFolder == nil then
        error("You must add a alteration character name as a string to this character.")
        return
    end
    if alterationInfo == nil then
        error("You must add a alteration character game place as a string to this character.")
        return
    end
    if characterName ~= nil then --If not nil...
        local foundName = table.ifind(smasCharacterChanger.names, characterName) --The name ID will then be added here.
        if foundName == nil then --But if nil, just return it
            return
        else --Or if not...
            local foundVariant = table.ifind(smasCharacterChanger.namesCostume[foundName], characterVariant) --The variant ID will then be added here.
            if foundVariant == nil then --But if nil, just return it
                return
            else
                if smasCharacterChanger.namesAlteration[foundName] == nil then
                    smasCharacterChanger.namesAlteration[foundName] = {}
                end
                if smasCharacterChanger.namesAlteration[foundName][foundVariant] == nil then
                    smasCharacterChanger.namesAlteration[foundName][foundVariant] = {}
                end
                table.insert(smasCharacterChanger.namesAlteration[foundName][foundVariant], {folder = alterationFolder, name = alterationName, game = alterationInfo}) --Add the info to the table
            end
        end
    end
end

function smasCharacterChanger.drawPreviewImage() --Simple function to draw images for the current character added to the roster.
    local numberOfCostumes = #smasCharacterChanger.namesCostume
    local tempImg
    if smasCharacterChanger.namesCostume[smasCharacterChanger.selectionNumber][smasCharacterChanger.selectionNumberUpDown] ~= "nil" then
        pcall(function() tempImg = Graphics.loadImageResolved("costumes/"..playerManager.getName(smasCharacterChanger.namesCharacter[smasCharacterChanger.selectionNumber]).."/"..smasCharacterChanger.namesCostume[smasCharacterChanger.selectionNumber][smasCharacterChanger.selectionNumberUpDown].."/character-preview.png") end)
    else
        pcall(function() tempImg = Graphics.loadImageResolved("costumes/character-preview.png") end) --Temporary solution for now
    end
    
    if tempImg == nil then
        pcall(function() tempImg = Graphics.loadImageResolved("costumes/character-preview.png") end)
    end
    return tempImg
end

local changed = false

local soundObject1 --Used for the TV scroll SFX
local menuBGMObject --Used for the menu BGM

local started = false
local ending = false

local function textPrintCentered(t, x, y, color) --Taken from the input config menu from the editor and edited slightly. Thanks Hoeloe lol
    textplus.print{text=t, x=x, y=y, plaintext=true, pivot=vector.v2(0.5,0.5), xscale=1.5, yscale=1.5, color=color, priority = 7.4, font = smbx13font}
end

function smasCharacterChanger.startChanger() --This is the command that starts the menu up. Use this to enable the menu.
    smasCharacterChanger.menuActive = true
    smasCharacterChanger.animationActive = true
    SysManager.sendToConsole("Character changer menu starting...")
end

function smasCharacterChanger.stopChanger() --This is the command that stops the menu. Use this to disable the menu.
    SysManager.sendToConsole("Character changer menu stopping...")
    smasCharacterChanger.menuActive = false
end

function smasCharacterChanger.startupChanger() --The animation that starts the menu up.
    Misc.pause()
    Sound.muteMusic(-1)
    if pauseplus then
        pauseplus.canPause = false
    end
    if SaveData.SMASPlusPlus.player[1].currentCostume ~= "N/A" then
        smasCharacterChanger.oldIniFile = Misc.resolveFile("costumes/"..playerManager.getName(player.character).."/"..SaveData.SMASPlusPlus.player[1].currentCostume.."/"..playerManager.getName(player.character).."-"..player.powerup..".ini")
    else
        smasCharacterChanger.oldIniFile = SysManager.loadDefaultCharacterIni()
    end
    soundObject1 = SFX.play(smasCharacterChanger.scrollSFX)
    smasBooleans.toggleOffInventory = true
    Routine.waitFrames(64, true)
    if soundObject1 ~= nil then
        soundObject1:FadeOut(10)
    end
    SFX.play(smasCharacterChanger.stopSFX)
    Routine.waitFrames(14, true)
    SFX.play(smasCharacterChanger.turnOnSFX)
    Routine.waitFrames(14, true)
    smasCharacterChanger.animationActive = false
    menuBGMObject = SFX.play(smasCharacterChanger.menuBGM, Audio.MusicVolume() / 100, 0)
    started = true
end

function smasCharacterChanger.shutdownChanger() --The animation that shuts the menu down.
    started = false
    ending = true
    smasCharacterChanger.animationActive = true
    Sound.playSFX("menu/dialog-confirm.ogg")
    Routine.waitFrames(35, true)
    smasCharacterChanger.selectionNumberUpDown = 1
    smasCharacterChanger.selectionNumberAlteration = 0
    Misc.unpause()
    if changed then
        smasCharacterInfo.setCostumeSpecifics()
        changed = false
    end
    Sound.loadCostumeSounds()
    Sound.restoreMusic(-1)
    if pauseplus then
        pauseplus.canPause = true
    end
    smasBooleans.toggleOffInventory = false
    smasCharacterChanger.animationActive = false
    smasCharacterChanger.tvScrollNumber = -628
    smasCharacterChanger.animationTimer = 0
    ending = false
    if smasBooleans.isOnMainMenu then
        optionsMenu1()
    end
end

local chars = playerManager.getCharacters()
local selectionAutoTimer = 0

function smasCharacterChanger.onInputUpdate()
    if smasCharacterChanger.menuActive and started and player.keys.altRun == KEYS_UP then
        if (player.keys.run == KEYS_PRESSED or Misc.GetKeyState(VK_ESCAPE)) then
            --Misc.loadCharacterHitBoxes(chars[player.character].base, player.powerup, smasCharacterChanger.oldIniFile)
            smasCharacterChanger.menuActive = false
        end
        if player.keys.up == KEYS_PRESSED then
            Sound.playSFX(smasCharacterChanger.moveSFX)
            smasCharacterChanger.selectionNumberUpDown = smasCharacterChanger.selectionNumberUpDown + 1
            if smasCharacterChanger.selectionNumberUpDown > #smasCharacterChanger.namesGame[smasCharacterChanger.selectionNumber] then
                smasCharacterChanger.selectionNumberUpDown = 1
            end
            smasCharacterChanger.selectionNumberAlteration = 0
        elseif player.keys.down == KEYS_PRESSED then
            Sound.playSFX(smasCharacterChanger.moveSFX)
            smasCharacterChanger.selectionNumberUpDown = smasCharacterChanger.selectionNumberUpDown - 1
            if smasCharacterChanger.selectionNumberUpDown < 1 then
                smasCharacterChanger.selectionNumberUpDown = #smasCharacterChanger.namesGame[smasCharacterChanger.selectionNumber]
            end
            smasCharacterChanger.selectionNumberAlteration = 0
        end
        if player.keys.left == KEYS_PRESSED then
            Sound.playSFX(smasCharacterChanger.moveSFX)
            smasCharacterChanger.selectionNumber = smasCharacterChanger.selectionNumber - 1
            --Misc.loadCharacterHitBoxes(chars[currentSelection].base, player.powerup, smasCharacterChanger.iniFile)
            smasCharacterChanger.selectionNumberUpDown = 1
            smasCharacterChanger.selectionNumberAlteration = 0
        elseif player.keys.right == KEYS_PRESSED then
            Sound.playSFX(smasCharacterChanger.moveSFX)
            smasCharacterChanger.selectionNumber = smasCharacterChanger.selectionNumber + 1
            --Misc.loadCharacterHitBoxes(chars[currentSelection].base, player.powerup, smasCharacterChanger.iniFile)
            smasCharacterChanger.selectionNumberUpDown = 1
            smasCharacterChanger.selectionNumberAlteration = 0
        end
        
        if player.keys.jump == KEYS_PRESSED then
            --Misc.loadCharacterHitBoxes(chars[player.character].base, player.powerup, smasCharacterChanger.oldIniFile)
            Sound.playSFX("charcost_costume.ogg")
            Sound.playSFX("charcost-selected.ogg")
            
            
            
            if smasCharacterChanger.selectionNumber then
                Playur.changeCharacter(player, false, smasCharacterChanger.selectionNumber, smasCharacterChanger.selectionNumberUpDown, smasCharacterChanger.selectionNumberAlteration) --One simple function to change the character correctly, for the episode
                changed = true
                smasCharacterChanger.menuActive = false
            end
        end
        
        if player.keys.altJump == KEYS_PRESSED then
            Sound.playSFX(smasCharacterChanger.moveSFX)
            if smasCharacterChanger.namesAlteration[smasCharacterChanger.selectionNumber][smasCharacterChanger.selectionNumberUpDown] ~= nil then
                smasCharacterChanger.selectionNumberAlteration = smasCharacterChanger.selectionNumberAlteration + 1
                if smasCharacterChanger.selectionNumberAlteration > #smasCharacterChanger.namesAlteration[smasCharacterChanger.selectionNumber][smasCharacterChanger.selectionNumberUpDown] then
                    smasCharacterChanger.selectionNumberAlteration = 0
                end
            else
                smasCharacterChanger.selectionNumberAlteration = 0
            end
        end
    end
    if smasCharacterChanger.menuActive and started and player.keys.altRun == KEYS_PRESSED then
        --Utilize a search function, coming later
    end
end

function smasCharacterChanger.onWindowUnfocus()
    if smasCharacterChanger.menuActive and started then
        --menuBGMObject:pause()
    end
end

function smasCharacterChanger.onWindowFocus()
    if smasCharacterChanger.menuActive and started then
        --menuBGMObject:resume()
    end
end

function smasCharacterChanger.onDraw()
    SaveData.currentCharacter = player.character
    if Player.count() >= 2 then
        SaveData.currentCharacter2 = player2.character
    end
    
    if SaveData.SMASPlusPlus.player[1].currentCostume ~= "N/A" then
        pcall(function() smasCharacterChanger.iniFile = Misc.episodePath().."costumes/"..playerManager.getName(player.character).."/"..player:getCostume().."/"..player.character.."-"..player.powerup..".ini" end)
    else
        pcall(function() smasCharacterChanger.iniFile = SysManager.loadDefaultCharacterIni() end)
    end
    
    if smasCharacterChanger.menuActive then
        if smasCharacterChanger.animationActive then
            smasCharacterChanger.animationTimer = smasCharacterChanger.animationTimer + 1
            if smasCharacterChanger.animationTimer == 1 then
                Routine.run(smasCharacterChanger.startupChanger)
            end
            if smasCharacterChanger.animationTimer >= 1 and smasCharacterChanger.animationTimer <= 64 then
                Misc.pause()
                smasCharacterChanger.tvScrollNumber = smasCharacterChanger.tvScrollNumber + 9.2
                Graphics.drawImageWP(smasCharacterChanger.tvImage, Screen.calculateCameraDimensions(-20, 1), Screen.calculateCameraDimensions(smasCharacterChanger.tvScrollNumber, 2), 7.5)
            end
            if smasCharacterChanger.animationTimer >= 65 then
                smasCharacterChanger.tvScrollNumber = 0
                Graphics.drawImageWP(smasCharacterChanger.tvImage, Screen.calculateCameraDimensions(-20, 1), Screen.calculateCameraDimensions(-28, 2), 7.5)
            end
        end
        if started then
            if (player.keys.left or player.keys.right or player.keys.up or player.keys.down) then
                selectionAutoTimer = selectionAutoTimer + 1
            end
            if not (player.keys.left or player.keys.right or player.keys.up or player.keys.down) then
                selectionAutoTimer = 0
            end
            if selectionAutoTimer >= 25 then
                if player.keys.left == KEYS_DOWN then
                    Sound.playSFX(smasCharacterChanger.moveSFX)
                    smasCharacterChanger.selectionNumber = smasCharacterChanger.selectionNumber - 1
                    smasCharacterChanger.selectionNumberUpDown = 1
                elseif player.keys.right == KEYS_DOWN then
                    Sound.playSFX(smasCharacterChanger.moveSFX)
                    smasCharacterChanger.selectionNumber = smasCharacterChanger.selectionNumber + 1
                    smasCharacterChanger.selectionNumberUpDown = 1
                elseif player.keys.up == KEYS_DOWN then
                    Sound.playSFX(smasCharacterChanger.moveSFX)
                    smasCharacterChanger.selectionNumberUpDown = smasCharacterChanger.selectionNumberUpDown + 1
                    if smasCharacterChanger.selectionNumberUpDown > #smasCharacterChanger.namesGame[smasCharacterChanger.selectionNumber] then
                        smasCharacterChanger.selectionNumberUpDown = 1
                    end
                elseif player.keys.down == KEYS_DOWN then
                    Sound.playSFX(smasCharacterChanger.moveSFX)
                    smasCharacterChanger.selectionNumberUpDown = smasCharacterChanger.selectionNumberUpDown - 1
                    if smasCharacterChanger.selectionNumberUpDown < 1 then
                        smasCharacterChanger.selectionNumberUpDown = #smasCharacterChanger.namesGame[smasCharacterChanger.selectionNumber]
                    end
                end
                selectionAutoTimer = 15
            end
            textPrintCentered("Select your character!", Screen.calculateCameraDimensions(410, 1), Screen.calculateCameraDimensions(100, 2))
            if smasCharacterChanger.selectionNumber < 1 then
                smasCharacterChanger.selectionNumber = #smasCharacterChanger.names
            elseif smasCharacterChanger.selectionNumber > #smasCharacterChanger.names then
                smasCharacterChanger.selectionNumber = 1
            end
            if smasCharacterChanger.selectionNumber and smasCharacterChanger.selectionNumberUpDown then
                if smasCharacterChanger.selectionNumberAlteration <= 0 then
                    textPrintCentered(smasCharacterChanger.names[smasCharacterChanger.selectionNumber], Screen.calculateCameraDimensions(410, 1), Screen.calculateCameraDimensions(160, 2))
                    textPrintCentered(smasCharacterChanger.namesGame[smasCharacterChanger.selectionNumber][smasCharacterChanger.selectionNumberUpDown], Screen.calculateCameraDimensions(410, 1), Screen.calculateCameraDimensions(210, 2))
                else
                    textPrintCentered(smasCharacterChanger.namesAlteration[smasCharacterChanger.selectionNumber][smasCharacterChanger.selectionNumberUpDown][smasCharacterChanger.selectionNumberAlteration].name, Screen.calculateCameraDimensions(410, 1), Screen.calculateCameraDimensions(160, 2))
                    textPrintCentered(smasCharacterChanger.namesAlteration[smasCharacterChanger.selectionNumber][smasCharacterChanger.selectionNumberUpDown][smasCharacterChanger.selectionNumberAlteration].game, Screen.calculateCameraDimensions(410, 1), Screen.calculateCameraDimensions(210, 2))
                end
            end
            colorChange1 = colorChange1 + 0.001
            colorChange2 = colorChange2 + 0.0005
            colorChange3 = colorChange3 + 0.0001
            if colorChange1 > 1 then
                colorChange1 = 0
            end
            if colorChange2 > 1 then
                colorChange2 = 0
            end
            if colorChange3 > 1 then
                colorChange3 = 0
            end
            local rainbowyColor = Color(colorChange1, colorChange2, colorChange3)
            Graphics.drawBox{x = Screen.calculateCameraDimensions(0, 1), y = Screen.calculateCameraDimensions(0, 2), width = 800, height = 600, color = rainbowyColor .. 1, priority = 7.3}
            
            Graphics.drawImageWP(smasCharacterChanger.drawPreviewImage(), Screen.calculateCameraDimensions(360, 1), Screen.calculateCameraDimensions(290, 2), 7.4)
            
            textPrintCentered("Press Alt-Jump to change alterations.", Screen.calculateCameraDimensions(410, 1), Screen.calculateCameraDimensions(430, 2))
        end
        if not smasCharacterChanger.animationActive and started then
            Graphics.drawImageWP(smasCharacterChanger.tvImage, Screen.calculateCameraDimensions(-20, 1), Screen.calculateCameraDimensions(-28, 2), 7.5)
            smasCharacterChanger.animationTimer = 0
        end
    elseif not smasCharacterChanger.menuActive and started then
        if menuBGMObject ~= nil then
            if Audio.MusicVolume() ~= 0 then
                menuBGMObject:FadeOut(2000)
            else
                menuBGMObject:Stop()
            end
        end
        Routine.run(smasCharacterChanger.shutdownChanger)
    elseif not smasCharacterChanger.menuActive and ending then
        if smasCharacterChanger.animationActive then
            smasCharacterChanger.animationTimer = smasCharacterChanger.animationTimer + 1
            if smasCharacterChanger.animationTimer >= 1 and smasCharacterChanger.animationTimer <= 34 then
                smasCharacterChanger.tvScrollNumber = smasCharacterChanger.tvScrollNumber - 20
                Graphics.drawImageWP(smasCharacterChanger.tvImage, Screen.calculateCameraDimensions(-20, 1), Screen.calculateCameraDimensions(smasCharacterChanger.tvScrollNumber, 2), 7.5)
            end
        end
    end
    
    
    
    --***CHARACTERS***
    
    --SMBX Defaults
    smasCharacterChanger.addCharacter("Mario","Default (SMAS++)",1,"!DEFAULT")
    smasCharacterChanger.addCharacter("Luigi","Super Mario Bros. 3",2,"!DEFAULT")
    smasCharacterChanger.addCharacter("Peach","Super Mario Bros. 2",3,"!DEFAULT")
    smasCharacterChanger.addCharacter("Toad","Super Mario Bros. 2",4,"!DEFAULT")
    smasCharacterChanger.addCharacter("Link","Zelda II (SMBX)",5,"!DEFAULT")
    
    --SMBX2
    smasCharacterChanger.addCharacter("Mega Man","Mega Man X7",6,"nil")
    smasCharacterChanger.addCharacter("Wario","Super Mario Bros. X2",7,"nil")
    smasCharacterChanger.addCharacter("Bowser","Super Mario Bros. X2",8,"nil")
    smasCharacterChanger.addCharacter("Klonoa","Klonoa 2 (GBA)",9,"nil")
    smasCharacterChanger.addCharacter("Plunder Bomber","Super Bomberman 5",3,"NINJABOMBERMAN")
    smasCharacterChanger.addCharacter("Rosalina","Super Mario Bros. X2",11,"nil")
    smasCharacterChanger.addCharacter("Snake","Super Mario Bros. X2",12,"nil")
    smasCharacterChanger.addCharacter("Zelda","Super Mario Bros. X2",13,"nil")
    smasCharacterChanger.addCharacter("Ultimate Rinka","Super Mario Bros. X2",4,"ULTIMATERINKA")
    smasCharacterChanger.addCharacter("Uncle Broadsword","A2XT",15,"nil")
    smasCharacterChanger.addCharacter("Samus","Metroid (SMBX2)",16,"nil")
    
    --Custom Characters
    smasCharacterChanger.addCharacter("Yoshi (SMW2)","SMW2: Yoshi's Island",10,"nil")
    smasCharacterChanger.addCharacter("Minecraft","Steve (Default)",14,"nil")
    
    --SMAS++ Characters (Unlocked on first-boot)
    smasCharacterChanger.addCharacter("Frisk","Undertale",2,"UNDERTALE-FRISK")
    smasCharacterChanger.addCharacter("Tangent","Spencer Everly (SEE)",4,"SEE-TANGENT")
    smasCharacterChanger.addCharacter("SpongeBob","SpongeBob SquarePants",1,"SPONGEBOBSQUAREPANTS")
    smasCharacterChanger.addCharacter("Eric Cartman","South Park",1,"SP-1-ERICCARTMAN")
    smasCharacterChanger.addCharacter("Rebel Trooper","LEGO Star Wars",4,"LEGOSTARWARS-REBELTROOPER")
    smasCharacterChanger.addCharacter("Caillou","GoAnimate/Vyond",1,"GA-CAILLOU")
    smasCharacterChanger.addCharacter("Sonic","Sonic the Hedgehog",4,"SONIC")
    
    --Rest will be unlockables via Achievements, Score Shop (In the future), and other things. Everything is still unlocked until then, though.
    smasCharacterChanger.addCharacter("Yoshi (SMB3)","Super Mario Bros. 3",4,"YOSHI-SMB3")
    smasCharacterChanger.addCharacter("Yoshi (SMW)","Super Mario World",2,"SMW1-YOSHI")
    smasCharacterChanger.addCharacter("Yoshi (SMW2, Alt)","SMW2: Yoshi's Island",9,"SMW2-YOSHI")
    smasCharacterChanger.addCharacter("Waluigi (SMW)","Mario Tennis",2,"WALUIGI")
    smasCharacterChanger.addCharacter("Daisy","Super Mario Bros. 3",3,"DAISY")
    smasCharacterChanger.addCharacter("Pauline","Super Mario Bros. 3",3,"PAULINE")
    smasCharacterChanger.addCharacter("Professor E. Gadd","Luigi's Mansion",13,"E. GADD")
    smasCharacterChanger.addCharacter("Goomba","Super Mario Bros. 3",1,"Goomba")
    smasCharacterChanger.addCharacter("King Boo","Luigi's Mansion",11,"KING BOO")
    smasCharacterChanger.addCharacter("Bass","Mega Man",6,"BASS")
    smasCharacterChanger.addCharacter("Dr. Wily","Mega Man",6,"DR. WILY")
    smasCharacterChanger.addCharacter("Proto Man","Mega Man",6,"PROTOMAN")
    smasCharacterChanger.addCharacter("Roll","Mega Man",6,"ROLL")
    smasCharacterChanger.addCharacter("Rosalina (Alt)","Super Mario Bros. X2",1,"ROSALINA")
    smasCharacterChanger.addCharacter("Demo","A2XT",1,"A2XT-DEMO")
    smasCharacterChanger.addCharacter("Iris","A2XT",2,"A2XT-IRIS")
    smasCharacterChanger.addCharacter("Kood","A2XT",3,"A2XT-KOOD")
    smasCharacterChanger.addCharacter("Raocow","A2XT/YouTube",4,"A2XT-RAOCOW")
    smasCharacterChanger.addCharacter("Sheath","A2XT",5,"A2XT-SHEATH")
    smasCharacterChanger.addCharacter("Pily","A2XT2: Gaiden 2",1,"DEMO-XMASPILY")
    smasCharacterChanger.addCharacter("Imajin","Yume Kojo: Doki Doki Panic",4,"IMAJIN-NES")
    smasCharacterChanger.addCharacter("SMG4","SMG4 (YouTube)",1,"SMG4")
    smasCharacterChanger.addCharacter("PAC-MAN","PAC-MAN Arrangement",4,"PACMAN-ARRANGEMENT-PACMAN")
    smasCharacterChanger.addCharacter("Mother Brain Rinka","Spencer Everly (SEE, SMBX2)",4,"MOTHERBRAINRINKA")
    smasCharacterChanger.addCharacter("Taizo","Dig Dug: Digging Strike",4,"DIGDUG-DIGGINGSTRIKE")
    smasCharacterChanger.addCharacter("Boris","GoAnimate/Vyond",2,"GA-BORIS")
    smasCharacterChanger.addCharacter("Runner Red","10 Second Run (DSi)",1,"GO-10SECONDRUN")
    smasCharacterChanger.addCharacter("JC Foster","JC Foster Takes it to the Moon",1,"JCFOSTERTAKESITTOTHEMOON")
    smasCharacterChanger.addCharacter("Kirby (SMB3)","Super Mario Bros. 3",3,"KIRBY-SMB3")
    smasCharacterChanger.addCharacter("Kirby (SMBX2)","Super Mario Bros. X2",15,"KIRBY-SMBX")
    smasCharacterChanger.addCharacter("Larry the Cucumber","VeggieTales",2,"LARRYTHECUCUMBER")
    smasCharacterChanger.addCharacter("Takeshi","Takeshi's Challenge",5,"TAKESHI")
    smasCharacterChanger.addCharacter("Sherbert Lussieback","Spencer! The Show! REBOOT",5,"SEE-SHERBERTLUSSIEBACK")
    smasCharacterChanger.addCharacter("Marisa Kirisame","Touhou",6,"MARISAKIRISAME")
    smasCharacterChanger.addCharacter("Utsuho Reiuji","Touhou",11,"UTSUHOREIUJI")
    smasCharacterChanger.addCharacter("Bill Rizer","Contra (NES)",16,"BILLRIZER")
    smasCharacterChanger.addCharacter("Wohlstand","TheXTech",2,"WOHLSTAND")
    smasCharacterChanger.addCharacter("Shantae","Shantae Galaxy",2,"SHANTAE")
    smasCharacterChanger.addCharacter("Tux","SuperTux",3,"TUX")
    smasCharacterChanger.addCharacter("Hamtaro","Hamtaro",4,"HAMTARO")
    smasCharacterChanger.addCharacter("Ness","EarthBound",5,"NESS")
    smasCharacterChanger.addCharacter("Bandana Dee (SMB3)","Kirby",5,"SMB3-BANDANA-DEE")
    smasCharacterChanger.addCharacter("Baldi","Baldi's Basics (PC)",2,"BALDISBASICS")
    smasCharacterChanger.addCharacter("Rosa (Isabella)","The Rosa Game (Working Title)",1,"ROSA-ISABELLA")
    smasCharacterChanger.addCharacter("Zero (SMBX OC)","Zero Unhope",1,"ZERO-SONIC")
    smasCharacterChanger.addCharacter("Homer Simpson","The Simpsons",5,"TS-HOMERSIMPSON")
    smasCharacterChanger.addCharacter("Peter Griffin","Family Guy",5,"FG-PETERGRIFFIN")
    smasCharacterChanger.addCharacter("Sophia the III","Blaster Master",4,"SOPHIATHETHIRD")
    --smasCharacterChanger.addCharacter("Susan Taxpayer","Susan Taxpayer (SMBX2)",1,"SUSANTAXPAYER")
    --smasCharacterChanger.addCharacter("Graytrap","Grayson Dietrich",2,"GRAYTRAP")

    --***VARIANTS***

    --**Mario variants**
    smasCharacterChanger.addVariant("Mario","Default (SMBX 38A)","!DEFAULT-38A")
    smasCharacterChanger.addVariant("Mario","Default (SMBX 1.3)","!DEFAULT-ORIGINAL")
    smasCharacterChanger.addVariant("Mario","SMAS++ 2012 Beta","00-SMASPLUSPLUS-BETA")
    if Achievements.get(1).collected then
        smasCharacterChanger.addVariant("Mario","Super Mario Bros. (NES)","01-SMB1-RETRO")
    end
    smasCharacterChanger.addVariant("Mario","Super Mario Bros. (NES, Recolored)","02-SMB1-RECOLORED")
    if Achievements.get(2).collected then
        smasCharacterChanger.addVariant("Mario","Super Mario Bros. (SNES)","03-SMB1-SMAS")
    end
    smasCharacterChanger.addVariant("Mario","Super Mario Bros. 2 (NES)","04-SMB2-RETRO")
    smasCharacterChanger.addVariant("Mario","Super Mario Bros. 2 (SNES)","05-SMB2-SMAS")
    smasCharacterChanger.addVariant("Mario","Super Mario Bros. 3 (NES)","06-SMB3-RETRO")
    smasCharacterChanger.addVariant("Mario","Super Mario World (SNES)","SMW-MARIO")
    smasCharacterChanger.addVariant("Mario","Super Mario World 2 (SNES)","Z-SMW2-ADULTMARIO")
    smasCharacterChanger.addVariant("Mario","Super Mario Land 1 (GB)","19-SML1")
    smasCharacterChanger.addVariant("Mario","Super Mario Land 2 (GB)","07-SML2")
    smasCharacterChanger.addVariant("Mario","Super Mario Bros. Special (PC-8801/Sharp X1)","08-SMBSPECIAL")
    smasCharacterChanger.addVariant("Mario","Super Mario World (NES, Pirate)","09-SMW-PIRATE")
    smasCharacterChanger.addVariant("Mario","Hotel Mario (Philips CD-i)","10-HOTELMARIO")
    smasCharacterChanger.addVariant("Mario","Super Mario Advance 1 (GBA)","11-SMA1")
    smasCharacterChanger.addVariant("Mario","Super Mario Advance 2 (GBA)","12-SMA2")
    smasCharacterChanger.addVariant("Mario","Super Mario Advance 4 (GBA)","13-SMA4")
    smasCharacterChanger.addVariant("Mario","New Super Mario Bros. (SMBX)","14-NSMBDS-SMBX")
    smasCharacterChanger.addVariant("Mario","New Super Mario Bros. (NDS)","15-NSMBDS-ORIGINAL")
    smasCharacterChanger.addVariant("Mario","New Super Mario Bros. Wii (Wii)","16-NSMBWII-MARIO")
    smasCharacterChanger.addVariant("Mario","Super Mario Bros. DDX (PC)","SMBDDX-MARIO")
    smasCharacterChanger.addVariant("Mario","Princess Rescue (Atari 2600)","PRINCESSRESCUE")

    smasCharacterChanger.addVariant("Mario","Golden Mario","GOLDENMARIO")
    smasCharacterChanger.addVariant("Mario","Marink","MARINK")
    smasCharacterChanger.addVariant("Mario","Modern Mario","MODERN")
    smasCharacterChanger.addVariant("Mario","Super Mario World: Mario Enhanced","MODERN2")

    smasCharacterChanger.addVariant("Mario","SMM2: Super Mario World (Mario)","SMM2-MARIO")
    smasCharacterChanger.addVariant("Mario","SMM2: Super Mario World (Luigi)","SMM2-LUIGI")
    smasCharacterChanger.addVariant("Mario","SMM2: Super Mario World (Blue Toad)","SMM2-TOAD")
    smasCharacterChanger.addVariant("Mario","SMM2: Super Mario World (Yellow Toad)","SMM2-YELLOWTOAD")
    smasCharacterChanger.addVariant("Mario","SMM2: Super Mario World (Toadette)","SMM2-TOADETTE")

    --**Luigi variants**
    smasCharacterChanger.addVariant("Luigi","Spencer Everly (SMBSE)","00-SPENCEREVERLY")
    smasCharacterChanger.addVariant("Luigi","Super Mario Bros. (NES)","01-SMB1-RETRO")
    smasCharacterChanger.addVariant("Luigi","Super Mario Bros. (NES, Recolored)","02-SMB1-RECOLORED")
    smasCharacterChanger.addVariant("Luigi","Super Mario Bros. (NES, Modern)","03-SMB1-RETRO-MODERN")
    smasCharacterChanger.addVariant("Luigi","Super Mario Bros. (SNES)","04-SMB1-SMAS")
    smasCharacterChanger.addVariant("Luigi","Super Mario Bros. 2 (NES)","05-SMB2-RETRO")
    smasCharacterChanger.addVariant("Luigi","Super Mario Bros. 2 (SNES)","06-SMB2-SMAS")
    smasCharacterChanger.addVariant("Luigi","Super Mario Bros. 3 (NES)","07-SMB3-RETRO")
    smasCharacterChanger.addVariant("Luigi","Super Mario World (SMAS)","SMW-LUIGI")
    smasCharacterChanger.addVariant("Luigi","Super Mario World (SNES)","10-SMW-ORIGINAL")
    smasCharacterChanger.addVariant("Luigi","Super Mario Bros. Deluxe (GBC)","13-SMBDX")
    smasCharacterChanger.addVariant("Luigi","Super Mario Advance 1 (GBA)","14-SMA1")
    smasCharacterChanger.addVariant("Luigi","Super Mario Advance 2 (GBA)","15-SMA2")
    smasCharacterChanger.addVariant("Luigi","Super Mario Advance 4 (GBA)","16-SMA4")
    smasCharacterChanger.addVariant("Luigi","New Super Mario Bros. DS (SMBX)","17-NSMBDS-SMBX")

    smasCharacterChanger.addVariant("Luigi","Marigi","09-SMB3-MARIOCLOTHES")
    smasCharacterChanger.addVariant("Luigi","Modern Luigi","MODERN")

    --**Peach variants**
    smasCharacterChanger.addVariant("Peach","Super Mario Bros. (NES)","01-SMB1-RETRO")
    smasCharacterChanger.addVariant("Peach","Super Mario Bros. (SNES)","02-SMB1-SMAS")
    smasCharacterChanger.addVariant("Peach","Super Mario World (SNES)","SMW-PEACH")
    smasCharacterChanger.addVariant("Peach","Super Mario Advance 4 (GBA)","SMA4")

    --**Toad variants**
    smasCharacterChanger.addVariant("Toad","Super Mario Bros. (NES)","01-SMB1-RETRO")
    smasCharacterChanger.addVariant("Toad","Super Mario Bros. (SNES)","02-SMB1-SMAS")
    smasCharacterChanger.addVariant("Toad","Super Mario Bros. 2 (NES, Blue)","03-SMB2-RETRO")
    smasCharacterChanger.addVariant("Toad","Super Mario Bros. 2 (NES, Yellow)","04-SMB2-RETRO-YELLOW")
    smasCharacterChanger.addVariant("Toad","Super Mario Bros. 2 (NES, Red)","05-SMB2-RETRO-RED")
    smasCharacterChanger.addVariant("Toad","Super Mario Bros. 3 (SNES, Blue)","06-SMB3-BLUE")
    smasCharacterChanger.addVariant("Toad","Super Mario Bros. 3 (SNES, Yellow)","07-SMB3-YELLOW")
    smasCharacterChanger.addVariant("Toad","Super Mario World (SNES)","SMM2-TOAD")

    smasCharacterChanger.addVariant("Toad","Captain Toad (SMW)","CAPTAINTOAD")
    smasCharacterChanger.addVariant("Toad","Toadette (SNES)","TOADETTE")

    --**Link variants**
    smasCharacterChanger.addVariant("Link","The Legend of Zelda (NES)","01-ZELDA1-NES")
    smasCharacterChanger.addVariant("Link","Zelda: Link's Awakening (SNES)","05-LINKWAKE-SNES")
    smasCharacterChanger.addVariant("Link","Super Mario Bros. (SNES)","SMB1-SNES")
    smasCharacterChanger.addVariant("Link","Super Mario Bros. 2 (SNES)","SMB2-SNES")

    --**Mega Man variants**
    smasCharacterChanger.addVariant("Mega Man","Mega Man 1-6 (NES)","MEGAMAN-NES")
    smasCharacterChanger.addVariant("Mega Man","Bad Box Art Mega Man","BAD BOX ART MEGA MAN")

    --**Yoshi (SMW2) variants**
    smasCharacterChanger.addVariant("Yoshi (SMW2)","Super Mario Advance 3","SMA3")

    --**Yoshi (SMW2, Alt) variants**
    smasCharacterChanger.addVariant("Yoshi (SMW2, Alt)","Yoshi's Story","YS-GREEN")

    --**Rosalina variants**
    smasCharacterChanger.addVariant("Rosalina","Super Mario Bros. 2 (SNES)","SMB2-SMAS")

    --**Samus variants**
    smasCharacterChanger.addVariant("Samus","Metroid (NES)","SAMUS-NES")

    --**Steve variants**
    smasCharacterChanger.addVariant("Minecraft","Alex (Default)","MC-ALEX")
    smasCharacterChanger.addVariant("Minecraft","Herobrine","MC-HEROBRINE")
    smasCharacterChanger.addVariant("Minecraft","Zombie","MC-ZOMBIE")
    smasCharacterChanger.addVariant("Minecraft","Notch","MC-NOTCH")

    smasCharacterChanger.addVariant("Minecraft","ExplodingTNT (YouTube)","EXPLODINGTNT")
    smasCharacterChanger.addVariant("Minecraft","GeorgeNotFound (YouTube)","GEORGENOTFOUNDYT")
    smasCharacterChanger.addVariant("Minecraft","HangoutYoshiGuy (YouTube)","HANGOUTYOSHIGUYYT")
    smasCharacterChanger.addVariant("Minecraft","Karl Jacobs (YouTube)","KARLJACOBSYT")
    smasCharacterChanger.addVariant("Minecraft","ItsHarry (YouTube)","MC-ITSHARRY")
    smasCharacterChanger.addVariant("Minecraft","ItsJerry (YouTube)","MC-ITSJERRY")
    smasCharacterChanger.addVariant("Minecraft","Keralis (YouTube)","MC-KERALIS")
    smasCharacterChanger.addVariant("Minecraft","Mystery Man Bro (YouTube)","MYSTERYMANBRO")
    smasCharacterChanger.addVariant("Minecraft","Quackity (YouTube)","QUACKITYYT")
    smasCharacterChanger.addVariant("Minecraft","TechnoBlade (YouTube)","TECHNOBLADE")
    smasCharacterChanger.addVariant("Minecraft","TommyInnit (YouTube)","TOMMYINNITYT")
    smasCharacterChanger.addVariant("Minecraft","UnofficialStudios (YouTube)","UNOFFICIALSTUDIOSYT")

    smasCharacterChanger.addVariant("Minecraft","Christmas Tree (DLC)","DLC-DESTIVE-CHRISTMASTREE")

    smasCharacterChanger.addVariant("Minecraft","Mario (Super Mario Bros.)","MC-MARIO")
    smasCharacterChanger.addVariant("Minecraft","Captain Toad","MC-CAPTAINTOAD")
    smasCharacterChanger.addVariant("Minecraft","Koopapanzer","KOOPAPANZER")
    smasCharacterChanger.addVariant("Minecraft","Sonic (Sonic the Hedgehog)","MC-SONIC")
    smasCharacterChanger.addVariant("Minecraft","Tails (Sonic the Hedgehog)","MC-TAILS")
    smasCharacterChanger.addVariant("Minecraft","SpongeBob (SpongeBob)","MC-SPONGEBOB")
    smasCharacterChanger.addVariant("Minecraft","Patrick (SpongeBob)","MC-PATRICK")
    smasCharacterChanger.addVariant("Minecraft","Squidward (SpongeBob)","MC-SQUIDWARD")
    smasCharacterChanger.addVariant("Minecraft","Frisk (Undertale)","MC-FRISK")
    smasCharacterChanger.addVariant("Minecraft","Kris (Deltarune)","MC-KRIS")
    smasCharacterChanger.addVariant("Minecraft","Susie (Deltarune)","MC-SUSIE-DELTARUNE")
    smasCharacterChanger.addVariant("Minecraft","Ralsei (Deltarune)","MC-RALSEI")
    smasCharacterChanger.addVariant("Minecraft","Noelle (Deltarune)","MC-NOELLE-DELTARUNE")
    smasCharacterChanger.addVariant("Minecraft","Boyfriend (FNF)","MC-FNF-BOYFRIEND")
    smasCharacterChanger.addVariant("Minecraft","Girlfriend (FNF)","MC-FNF-GIRLFRIEND")
    smasCharacterChanger.addVariant("Minecraft","Impostor (Among Us)","MC-IMPOSTOR")
    smasCharacterChanger.addVariant("Minecraft","Ed (Ed Edd and Eddy)","ED-EDEDDANDEDDY")
    smasCharacterChanger.addVariant("Minecraft","Spiderman","MC-SPIDERMAN")

    smasCharacterChanger.addVariant("Minecraft","Cubix Tron (C!TS!)","DJCTRE-CUBIXTRON")
    smasCharacterChanger.addVariant("Minecraft","Cubix Tron Dad (C!TS!)","DJCTRE-CUBIXTRONDAD")
    smasCharacterChanger.addVariant("Minecraft","Stultus (C!TS!)","DJCTRE-STULTUS")

    smasCharacterChanger.addVariant("Minecraft","Spencer (S!TS! REBOOT)","SEE-MC-SPENCEREVERLY")
    smasCharacterChanger.addVariant("Minecraft","Spencer 2 (S!TS! REBOOT)","SEE-MC-SPENCER2")
    smasCharacterChanger.addVariant("Minecraft","Sherbert (S!TS! REBOOT)","SEE-MC-SHERBERTLUSSIEBACK")
    smasCharacterChanger.addVariant("Minecraft","Lewbert (S!TS! REBOOT)","SEE-MC-LEWBERTLUSSIEBACK")
    smasCharacterChanger.addVariant("Minecraft","Evil Me (S!TS! REBOOT)","SEE-MC-EVILME")
    smasCharacterChanger.addVariant("Minecraft","Shenicle (S!TS! REBOOT)","SEE-MC-SHENICLE")
    smasCharacterChanger.addVariant("Minecraft","Tianely (S!TS! REBOOT)","SEE-MC-TIANELY")
    smasCharacterChanger.addVariant("Minecraft","Lili (S!TS! REBOOT)","SEE-MC-LILIJUCIEBACK")
    smasCharacterChanger.addVariant("Minecraft","Mimi (S!TS! REBOOT)","SEE-MC-MIMIJUCIEBACK")
    smasCharacterChanger.addVariant("Minecraft","Geranium (S!TS! REBOOT)","SEE-MC-GERANIUM")
    smasCharacterChanger.addVariant("Minecraft","Shelley (S!TS! REBOOT)","SEE-MC-SHELEYKIRK")
    smasCharacterChanger.addVariant("Minecraft","Ron (S!TS! REBOOT)","SEE-MC-RONDAVIS")

    --**Wario variants**
    smasCharacterChanger.addVariant("Wario","Super Mario Bros. 3","SMB3-WARIO")

    --**Takeshi variants**
    smasCharacterChanger.addVariant("Takeshi","Takeshi's Challenge (SNES)","TAKESHI-SNES")
    
    if lunatime.drawtick() == 1 then --Alterations deal with a complex set of adding values to a table, so to prevent adding multiple values of the same table, we'll need to well, add it on the first tick...
        --***ALTERATIONS***
    
        --**Mario alterations**
        smasCharacterChanger.addAlteration("Mario","!DEFAULT","FlipnoteStudio","Mario","Flipnote Studio (DSi)")
    end
end

return smasCharacterChanger