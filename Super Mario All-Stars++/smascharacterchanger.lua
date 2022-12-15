--smascharacterchanger.lua (v1.0)
--By Spencer Everly

local smascharacterchanger = {}

local playerManager = require("playerManager")
local textplus = require("textplus")
local smbx13font = textplus.loadFont("littleDialogue/font/smilebasic.ini") --The font for the changer menu.

function smascharacterchanger.onInitAPI()
    registerEvent(smascharacterchanger,"onDraw")
    registerEvent(smascharacterchanger,"onInputUpdate")
    registerEvent(smascharacterchanger,"onKeyboardPressDirect")
end

if SaveData.currentCharacter == nil then
    SaveData.currentCharacter = player.character
end
if SaveData.currentCharacter2 == nil then
    if Player.count() >= 2 then
        SaveData.currentCharacter2 = player2.character
    end
end

smascharacterchanger.tvImage = Img.load("graphics/characterchangermenu/tv.png") --The image for the TV.
smascharacterchanger.scrollSFX = "_OST/_Sound Effects/characterchangermenu/scrolling-tv.ogg"
smascharacterchanger.stopSFX = "_OST/_Sound Effects/characterchangermenu/scrolled-tv.ogg"
smascharacterchanger.turnOnSFX = "_OST/_Sound Effects/characterchangermenu/turn-on-tv.ogg"
smascharacterchanger.moveSFX = 26 --Sound effects used for the menu
smascharacterchanger.menuActive = false --True if the menu is active.
smascharacterchanger.animationActive = false --True if the animation is active.
smascharacterchanger.animationTimer = 0 --Timer for the animation, both for the start and end sequences.
smascharacterchanger.tvScrollNumber = -600 --This is used for the TV animation sequence.
smascharacterchanger.menuBGM = "_OST/All Stars Menu/Character Changer Menu.ogg"
smascharacterchanger.selectionNumber = 1 --For scrolling left and right
smascharacterchanger.selectionNumberUpDown = 1 --For scrolling up and down

local colorChange1 = 0
local colorChange2 = 0
local colorChange3 = 0

local reserveChange = 0

--These tables below will be used for the system.
smascharacterchanger.names = {}
smascharacterchanger.namesGame = {}
smascharacterchanger.namesCharacter = {}
smascharacterchanger.namesCostume = {}

function smascharacterchanger.addCharacter(name,game,character,costume) --Adds a character to the tables above. Example: smascharacterchanger.addCharacter("My Character","Game Information",CHARACTER_NUMBERGOESHERE,"COSTUMEGOESHERE, else nil")
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
    
    table.insert(smascharacterchanger.names, name)
    table.insert(smascharacterchanger.namesGame, {game})
    table.insert(smascharacterchanger.namesCharacter, character)
    table.insert(smascharacterchanger.namesCostume, {costume})
end

function smascharacterchanger.addVariant(nameToFind,game,costume) --Adds a variant to the character table. Example: smascharacterchanger.addVariant("My Character","Game Information of the 2nd character","COSTUMEGOESHERE of the 2nd character variant")
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
        local foundName = table.ifind(smascharacterchanger.names, nameToFind) --The name ID will then be added here.
        if foundName == nil then --But if nil...
            error("Name wasn't found! You need to specify a valid name.") --Error and return it
            return
        else --Or if not...
            table.insert(smascharacterchanger.namesGame[foundName], game) --Add the info to the tables
            table.insert(smascharacterchanger.namesCostume[foundName], costume)
        end
    end
end

local changed = false

local soundObject1 --Used for the TV scroll SFX
local menuBGMObject --Used for the menu BGM
local oldIniFile --Used for reverting to the old ini file when exiting the menu without changing to a character

local started = false
local ending = false

local function textPrintCentered(t, x, y, color) --Taken from the input config menu from the editor and edited slightly. Thanks Hoeloe lol
    textplus.print{text=t, x=x, y=y, plaintext=true, pivot=vector.v2(0.5,0.5), xscale=1.5, yscale=1.5, color=color, priority = -1.7, font = smbx13font}
end

function smascharacterchanger.startChanger() --This is the command that starts the menu up. Use this to enable the menu.
    smascharacterchanger.menuActive = true
    smascharacterchanger.animationActive = true
end

function smascharacterchanger.stopChanger() --This is the command that stops the menu. Use this to disable the menu.
    smascharacterchanger.menuActive = false
end

function smascharacterchanger.startupChanger() --The animation that starts the menu up.
    Misc.pause()
    Sound.muteMusic(-1)
    if pauseplus then
        pauseplus.canPause = false
    end
    if SaveData.currentCostume ~= "N/A" then
        oldIniFile = Misc.resolveFile("costumes/"..playerManager.getName(player.character).."/"..player:getCostume().."/"..player.character.."-"..player.powerup..".ini")
    else
        oldIniFile = Misc.resolveFile("config/character_defaults/"..player.character.."-"..player.powerup..".ini")
    end
    soundObject1 = SFX.play(smascharacterchanger.scrollSFX)
    Routine.waitFrames(10, true)
    Misc.pause()
    smasbooleans.toggleOffInventory = true
    Routine.waitFrames(54, true)
    if soundObject1 ~= nil then
        soundObject1:FadeOut(10)
    end
    SFX.play(smascharacterchanger.stopSFX)
    Routine.waitFrames(14, true)
    SFX.play(smascharacterchanger.turnOnSFX)
    Routine.waitFrames(14, true)
    smascharacterchanger.animationActive = false
    menuBGMObject = SFX.play(smascharacterchanger.menuBGM, Audio.MusicVolume() / 100, 0)
    started = true
end

function smascharacterchanger.shutdownChanger() --The animation that shuts the menu down.
    started = false
    ending = true
    smascharacterchanger.animationActive = true
    Sound.playSFX("menu/dialog-confirm.ogg")
    Routine.waitFrames(35, true)
    smascharacterchanger.selectionNumberUpDown = 1
    Misc.unpause()
    if changed then
        smascharacterinfo.setCostumeSpecifics()
        changed = false
    end
    Sound.restoreMusic(-1)
    if pauseplus then
        pauseplus.canPause = true
    end
    smasbooleans.toggleOffInventory = false
    smascharacterchanger.animationActive = false
    smascharacterchanger.tvScrollNumber = -600
    smascharacterchanger.animationTimer = 0
    ending = false
    if smasbooleans.mainMenuActive then
        optionsMenu1()
    end
end

function smascharacterchanger.onInputUpdate()
    if smascharacterchanger.menuActive and started then
        if player.keys.run == KEYS_PRESSED then
            Misc.loadCharacterHitBoxes(player.character, player.powerup, oldIniFile)
            smascharacterchanger.menuActive = false
        end
        if player.keys.up == KEYS_PRESSED then
            Sound.playSFX(smascharacterchanger.moveSFX)
            smascharacterchanger.selectionNumberUpDown = smascharacterchanger.selectionNumberUpDown + 1
            if smascharacterchanger.selectionNumberUpDown > #smascharacterchanger.namesGame[smascharacterchanger.selectionNumber] then
                smascharacterchanger.selectionNumberUpDown = 1
            end
        elseif player.keys.down == KEYS_PRESSED then
            Sound.playSFX(smascharacterchanger.moveSFX)
            smascharacterchanger.selectionNumberUpDown = smascharacterchanger.selectionNumberUpDown - 1
            if smascharacterchanger.selectionNumberUpDown < 1 then
                smascharacterchanger.selectionNumberUpDown = #smascharacterchanger.namesGame[smascharacterchanger.selectionNumber]
            end
        end
        if player.keys.left == KEYS_PRESSED then
            Sound.playSFX(smascharacterchanger.moveSFX)
            smascharacterchanger.selectionNumber = smascharacterchanger.selectionNumber - 1
            smascharacterchanger.selectionNumberUpDown = 1
        elseif player.keys.right == KEYS_PRESSED then
            Sound.playSFX(smascharacterchanger.moveSFX)
            smascharacterchanger.selectionNumber = smascharacterchanger.selectionNumber + 1
            smascharacterchanger.selectionNumberUpDown = 1
        end
        if player.keys.jump == KEYS_PRESSED then
            Sound.playSFX("charcost_costume.ogg")
            Sound.playSFX("charcost-selected.ogg")
            
            
            
            if smascharacterchanger.selectionNumber then
                if smascharacterchanger.namesCostume[smascharacterchanger.selectionNumber] ~= "nil" then --Reason why nil needs to be a string is because anything that's nil isn't really a literal "nil" at all, so putting it as a string fixes that
                    reserveChange = player.reservePowerup --Keep the reserve for the old character, in case if we're switching to a different character
                    player:transform(smascharacterchanger.namesCharacter[smascharacterchanger.selectionNumber], false)
                    player.setCostume(smascharacterchanger.namesCharacter[smascharacterchanger.selectionNumber], smascharacterchanger.namesCostume[smascharacterchanger.selectionNumber][smascharacterchanger.selectionNumberUpDown], false)
                else
                    reserveChange = player.reservePowerup --Reapply the reserve to the player
                    player:transform(smascharacterchanger.namesCharacter[smascharacterchanger.selectionNumber], false)
                    player.setCostume(smascharacterchanger.namesCharacter[smascharacterchanger.selectionNumber], nil, false)
                end
                changed = true
                player.reservePowerup = reserveChange
                smascharacterchanger.menuActive = false
            end
            
            
            
        end
    end
end

function smascharacterchanger.onDraw()
    SaveData.currentCharacter = player.character
    if Player.count() == 2 then
        SaveData.currentCharacter2 = player2.character
    end
    
    if smascharacterchanger.menuActive then
        if smascharacterchanger.animationActive then
            smascharacterchanger.animationTimer = smascharacterchanger.animationTimer + 1
            if smascharacterchanger.animationTimer == 1 then
                Routine.run(smascharacterchanger.startupChanger)
            end
            if smascharacterchanger.animationTimer >= 1 and smascharacterchanger.animationTimer <= 64 then
                smascharacterchanger.tvScrollNumber = smascharacterchanger.tvScrollNumber + 9.2
                Graphics.drawImageWP(smascharacterchanger.tvImage, 0, smascharacterchanger.tvScrollNumber, -1.5)
            end
            if smascharacterchanger.animationTimer >= 65 then
                smascharacterchanger.tvScrollNumber = 0
                Graphics.drawImageWP(smascharacterchanger.tvImage, 0, 0, -1.5)
            end
        end
        if started then
            textPrintCentered("Select your character!", 410, 100)
            if smascharacterchanger.selectionNumber < 1 then
                smascharacterchanger.selectionNumber = #smascharacterchanger.names
            elseif smascharacterchanger.selectionNumber > #smascharacterchanger.names then
                smascharacterchanger.selectionNumber = 1
            end
            if smascharacterchanger.selectionNumber and smascharacterchanger.selectionNumberUpDown then
                textPrintCentered(smascharacterchanger.names[smascharacterchanger.selectionNumber], 410, 200)
                textPrintCentered(smascharacterchanger.namesGame[smascharacterchanger.selectionNumber][smascharacterchanger.selectionNumberUpDown], 410, 250)
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
            Graphics.drawScreen{color = rainbowyColor .. 1, priority = -1.8}
            local iniFile = Misc.resolveFile("costumes/"..playerManager.getName(player.character).."/"..player:getCostume().."/"..player.character.."-"..player.powerup..".ini")
            Misc.loadCharacterHitBoxes(player.character, player.powerup, iniFile)
            player:render{frame = 1, direction = 1, x = 400, y = 450, priority = -1.7}
        end
        if not smascharacterchanger.animationActive and started then
            Graphics.drawImageWP(smascharacterchanger.tvImage, 0, 0, -1.5)
            smascharacterchanger.animationTimer = 0
        end
    elseif not smascharacterchanger.menuActive and started then
        if menuBGMObject ~= nil then
            menuBGMObject:FadeOut(2000)
        end
        Routine.run(smascharacterchanger.shutdownChanger)
    elseif not smascharacterchanger.menuActive and ending then
        if smascharacterchanger.animationActive then
            smascharacterchanger.animationTimer = smascharacterchanger.animationTimer + 1
            if smascharacterchanger.animationTimer >= 1 and smascharacterchanger.animationTimer <= 34 then
                smascharacterchanger.tvScrollNumber = smascharacterchanger.tvScrollNumber - 20
                Graphics.drawImageWP(smascharacterchanger.tvImage, 0, smascharacterchanger.tvScrollNumber, -0.5)
            end
        end
    end
end

--***CHARACTERS***
smascharacterchanger.addCharacter("Mario","Default (SMAS++)",1,"!DEFAULT")
smascharacterchanger.addCharacter("Luigi","Super Mario Bros. 3",2,"!DEFAULT")
smascharacterchanger.addCharacter("Peach","Super Mario Bros. 2",3,"!DEFAULT")
smascharacterchanger.addCharacter("Toad","Super Mario Bros. 2",4,"!DEFAULT")
smascharacterchanger.addCharacter("Yoshi (SMB3)","Super Mario Bros. 3",4,"YOSHI-SMB3")
smascharacterchanger.addCharacter("Yoshi (SMW)","Super Mario World",2,"SMW1-YOSHI")
smascharacterchanger.addCharacter("Yoshi (SMW2)","SMW2: Yoshi's Island",10,"nil")
smascharacterchanger.addCharacter("Yoshi (SMW2, Alt)","SMW2: Yoshi's Island",9,"SMW2-YOSHI")
smascharacterchanger.addCharacter("Wario","Super Mario Bros. X2",7,"nil")
smascharacterchanger.addCharacter("Waluigi (SMW)","Mario Tennis",2,"WALUIGI")
smascharacterchanger.addCharacter("Daisy","Super Mario Bros. 3",3,"DAISY")
smascharacterchanger.addCharacter("Pauline","Super Mario Bros. 3",3,"PAULINE")
smascharacterchanger.addCharacter("Professor E. Gadd","Luigi's Mansion",13,"E. GADD")
smascharacterchanger.addCharacter("Bowser","Super Mario Bros. X2",8,"nil")
smascharacterchanger.addCharacter("Goomba","Super Mario Bros. 3",1,"Goomba")
smascharacterchanger.addCharacter("King Boo","Luigi's Mansion",11,"KING BOO")
smascharacterchanger.addCharacter("Link","Zelda II (SMBX)",5,"!DEFAULT")
smascharacterchanger.addCharacter("Zelda","Super Mario Bros. X2",13,"nil")
smascharacterchanger.addCharacter("Mega Man","Mega Man X7",6,"nil")
smascharacterchanger.addCharacter("Bass","Mega Man",6,"BASS")
smascharacterchanger.addCharacter("Dr. Wily","Mega Man",6,"DR. WILY")
smascharacterchanger.addCharacter("Proto Man","Mega Man",6,"PROTOMAN")
smascharacterchanger.addCharacter("Roll","Mega Man",6,"ROLL")
smascharacterchanger.addCharacter("Klonoa","Klonoa 2 (GBA)",9,"nil")
smascharacterchanger.addCharacter("Plunder Bomber","Super Bomberman 5",3,"NINJABOMBERMAN")
smascharacterchanger.addCharacter("Rosalina","Super Mario Bros. X2",11,"nil")
smascharacterchanger.addCharacter("Rosalina (Alt)","Super Mario Bros. X2",1,"ROSALINA")
smascharacterchanger.addCharacter("Snake","Super Mario Bros. X2",12,"nil")
smascharacterchanger.addCharacter("Ultimate Rinka","Super Mario Bros. X2",4,"ULTIMATERINKA")
smascharacterchanger.addCharacter("Samus","Metroid (SMBX2)",16,"nil")
smascharacterchanger.addCharacter("Sonic","Sonic the Hedgehog",4,"SONIC")
smascharacterchanger.addCharacter("Frisk","Undertale",2,"UNDERTALE-FRISK")
smascharacterchanger.addCharacter("Minecraft","Steve (Default)",14,"nil")
smascharacterchanger.addCharacter("Demo","A2XT",1,"A2XT-DEMO")
smascharacterchanger.addCharacter("Iris","A2XT",2,"A2XT-IRIS")
smascharacterchanger.addCharacter("Kood","A2XT",3,"A2XT-KOOD")
smascharacterchanger.addCharacter("Raocow","A2XT/YouTube",4,"A2XT-RAOCOW")
smascharacterchanger.addCharacter("Sheath","A2XT",5,"A2XT-SHEATH")
smascharacterchanger.addCharacter("Uncle Broadsword","A2XT",15,"nil")
smascharacterchanger.addCharacter("Pily","A2XT2: Gaiden 2",1,"DEMO-XMASPILY")
smascharacterchanger.addCharacter("Tangent","Spencer Everly (SEE)",4,"SEE-TANGENT")
smascharacterchanger.addCharacter("SpongeBob","SpongeBob SquarePants",1,"SPONGEBOBSQUAREPANTS")
smascharacterchanger.addCharacter("Imajin","Yume Kojo: Doki Doki Panic",4,"IMAJIN-NES")
smascharacterchanger.addCharacter("Eric Cartman","South Park",1,"SP-1-ERICCARTMAN")
smascharacterchanger.addCharacter("Rebel Trooper","LEGO Star Wars",4,"LEGOSTARWARS-REBELTROOPER")
smascharacterchanger.addCharacter("SMG4","SMG4 (YouTube)",1,"SMG4")
smascharacterchanger.addCharacter("PAC-MAN","PAC-MAN Arrangement",4,"PACMAN-ARRANGEMENT-PACMAN")
smascharacterchanger.addCharacter("Mother Brain Rinka","Spencer Everly (SEE, SMBX2)",4,"MOTHERBRAINRINKA")
smascharacterchanger.addCharacter("Taizo","Dig Dug: Digging Strike",4,"DIGDUG-DIGGINGSTRIKE")
smascharacterchanger.addCharacter("Caillou","GoAnimate/Vyond",1,"GA-CAILLOU")
smascharacterchanger.addCharacter("Boris","GoAnimate/Vyond",2,"GA-BORIS")
smascharacterchanger.addCharacter("Runner Red","10 Second Run (DSi)",1,"GO-10SECONDRUN")
smascharacterchanger.addCharacter("JC Foster","JC Foster Takes it to the Moon",1,"JCFOSTERTAKESITTOTHEMOON")
smascharacterchanger.addCharacter("Kirby (SMB3)","Super Mario Bros. 3",3,"KIRBY-SMB3")
smascharacterchanger.addCharacter("Kirby (SMBX2)","Super Mario Bros. X2",15,"KIRBY-SMBX")
smascharacterchanger.addCharacter("Larry the Cucumber","VeggieTales",2,"LARRYTHECUCUMBER")
smascharacterchanger.addCharacter("Takeshi","Takeshi's Challenge",5,"TAKESHI")
smascharacterchanger.addCharacter("Sherbert Lussieback","Spencer! The Show! REBOOT",5,"SEE-SHERBERTLUSSIEBACK")
smascharacterchanger.addCharacter("Marisa Kirisame","Touhou",6,"MARISAKIRISAME")
smascharacterchanger.addCharacter("Utsuho Reiuji","Touhou",11,"UTSUHOREIUJI")
smascharacterchanger.addCharacter("Bill Rizer","Contra (NES)",16,"BILLRIZER")
smascharacterchanger.addCharacter("Wohlstand","TheXTech",2,"WOHLSTAND")
smascharacterchanger.addCharacter("Shantae","Shantae Galaxy",2,"SHANTAE")
smascharacterchanger.addCharacter("Tux","SuperTux",3,"TUX")
smascharacterchanger.addCharacter("Hamtaro","Hamtaro",4,"HAMTARO")
smascharacterchanger.addCharacter("Ness","EarthBound",5,"NESS")
smascharacterchanger.addCharacter("Bandana Dee (SMB3)","Kirby",5,"SMB3-BANDANA-DEE")
smascharacterchanger.addCharacter("Baldi","Baldi's Basics (PC)",2,"BALDISBASICS")

--***VARIANTS***

--**Mario variants**
smascharacterchanger.addVariant("Mario","Default (SMBX 38A)","!DEFAULT-38A")
smascharacterchanger.addVariant("Mario","Default (SMBX 1.3)","!DEFAULT-ORIGINAL")
smascharacterchanger.addVariant("Mario","SMAS++ 2012 Beta","00-SMASPLUSPLUS-BETA")
smascharacterchanger.addVariant("Mario","Super Mario Bros. (NES)","01-SMB1-RETRO")
smascharacterchanger.addVariant("Mario","Super Mario Bros. (NES, Recolored)","02-SMB1-RECOLORED")
smascharacterchanger.addVariant("Mario","Super Mario Bros. (SNES)","03-SMB1-SMAS")
smascharacterchanger.addVariant("Mario","Super Mario Bros. 2 (NES)","04-SMB2-RETRO")
smascharacterchanger.addVariant("Mario","Super Mario Bros. 2 (SNES)","05-SMB2-SMAS")
smascharacterchanger.addVariant("Mario","Super Mario Bros. 3 (NES)","06-SMB3-RETRO")
smascharacterchanger.addVariant("Mario","Super Mario World (SNES)","SMW-MARIO")
smascharacterchanger.addVariant("Mario","Super Mario World 2 (SNES)","Z-SMW2-ADULTMARIO")
smascharacterchanger.addVariant("Mario","Super Mario Land 2 (GB)","07-SML2")
smascharacterchanger.addVariant("Mario","Super Mario Bros. Special (PC-8801/Sharp X1)","08-SMBSPECIAL")
smascharacterchanger.addVariant("Mario","Super Mario World (NES, Pirate)","09-SMW-PIRATE")
smascharacterchanger.addVariant("Mario","Hotel Mario (Philips CD-i)","10-HOTELMARIO")
smascharacterchanger.addVariant("Mario","Super Mario Advance 1 (GBA)","11-SMA1")
smascharacterchanger.addVariant("Mario","Super Mario Advance 2 (GBA)","12-SMA2")
smascharacterchanger.addVariant("Mario","Super Mario Advance 4 (GBA)","13-SMA4")
smascharacterchanger.addVariant("Mario","New Super Mario Bros. (SMBX)","14-NSMBDS-SMBX")
smascharacterchanger.addVariant("Mario","New Super Mario Bros. (NDS)","15-NSMBDS-ORIGINAL")
smascharacterchanger.addVariant("Mario","New Super Mario Bros. Wii (Wii)","16-NSMBWII-MARIO")
smascharacterchanger.addVariant("Mario","Super Mario Bros. DDX (PC)","SMBDDX-MARIO")
smascharacterchanger.addVariant("Mario","Princess Rescue (Atari 2600)","PRINCESSRESCUE")

smascharacterchanger.addVariant("Mario","Golden Mario","GOLDENMARIO")
smascharacterchanger.addVariant("Mario","Marink","MARINK")
smascharacterchanger.addVariant("Mario","Modern Mario","MODERN")
smascharacterchanger.addVariant("Mario","Super Mario World: Mario Enhanced","MODERN2")

smascharacterchanger.addVariant("Mario","SMM2: Super Mario World (Mario)","SMM2-MARIO")
smascharacterchanger.addVariant("Mario","SMM2: Super Mario World (Luigi)","SMM2-LUIGI")
smascharacterchanger.addVariant("Mario","SMM2: Super Mario World (Blue Toad)","SMM2-TOAD")
smascharacterchanger.addVariant("Mario","SMM2: Super Mario World (Yellow Toad)","SMM2-YELLOWTOAD")
smascharacterchanger.addVariant("Mario","SMM2: Super Mario World (Toadette)","SMM2-TOADETTE")

--**Luigi variants**
smascharacterchanger.addVariant("Luigi","Spencer Everly (SMBSE)","00-SPENCEREVERLY")
smascharacterchanger.addVariant("Luigi","Super Mario Bros. (NES)","01-SMB1-RETRO")
smascharacterchanger.addVariant("Luigi","Super Mario Bros. (NES, Recolored)","02-SMB1-RECOLORED")
smascharacterchanger.addVariant("Luigi","Super Mario Bros. (NES, Modern)","03-SMB1-RETRO-MODERN")
smascharacterchanger.addVariant("Luigi","Super Mario Bros. (SNES)","04-SMB1-SMAS")
smascharacterchanger.addVariant("Luigi","Super Mario Bros. 2 (NES)","05-SMB2-RETRO")
smascharacterchanger.addVariant("Luigi","Super Mario Bros. 2 (SNES)","06-SMB2-SMAS")
smascharacterchanger.addVariant("Luigi","Super Mario Bros. 3 (NES)","07-SMB3-RETRO")
smascharacterchanger.addVariant("Luigi","Super Mario World (SMAS)","SMW-LUIGI")
smascharacterchanger.addVariant("Luigi","Super Mario World (SNES)","10-SMW-ORIGINAL")
smascharacterchanger.addVariant("Luigi","Super Mario Bros. Deluxe (GBC)","13-SMBDX")
smascharacterchanger.addVariant("Luigi","Super Mario Advance 1 (GBA)","14-SMA1")
smascharacterchanger.addVariant("Luigi","Super Mario Advance 2 (GBA)","15-SMA2")
smascharacterchanger.addVariant("Luigi","Super Mario Advance 4 (GBA)","16-SMA4")
smascharacterchanger.addVariant("Luigi","New Super Mario Bros. DS (SMBX)","17-NSMBDS-SMBX")

smascharacterchanger.addVariant("Luigi","Marigi","09-SMB3-MARIOCLOTHES")
smascharacterchanger.addVariant("Luigi","Modern Luigi","MODERN")

--**Peach variants**
smascharacterchanger.addVariant("Peach","Super Mario Bros. (NES)","01-SMB1-RETRO")
smascharacterchanger.addVariant("Peach","Super Mario Bros. (SNES)","02-SMB1-SMAS")
smascharacterchanger.addVariant("Peach","Super Mario World (SNES)","SMW-PEACH")
smascharacterchanger.addVariant("Peach","Super Mario Advance 4 (GBA)","SMA4")

--**Toad variants**
smascharacterchanger.addVariant("Toad","Super Mario Bros. (NES)","01-SMB1-RETRO")
smascharacterchanger.addVariant("Toad","Super Mario Bros. (SNES)","02-SMB1-SMAS")
smascharacterchanger.addVariant("Toad","Super Mario Bros. 2 (NES, Blue)","03-SMB2-RETRO")
smascharacterchanger.addVariant("Toad","Super Mario Bros. 2 (NES, Yellow)","04-SMB2-RETRO-YELLOW")
smascharacterchanger.addVariant("Toad","Super Mario Bros. 2 (NES, Red)","05-SMB2-RETRO-RED")
smascharacterchanger.addVariant("Toad","Super Mario Bros. 3 (SNES, Blue)","06-SMB3-BLUE")
smascharacterchanger.addVariant("Toad","Super Mario Bros. 3 (SNES, Yellow)","07-SMB3-YELLOW")
smascharacterchanger.addVariant("Toad","Super Mario World (SNES)","SMM2-TOAD")

smascharacterchanger.addVariant("Toad","Captain Toad (SMW)","CAPTAINTOAD")
smascharacterchanger.addVariant("Toad","Toadette (SNES)","TOADETTE")

--**Link variants**
smascharacterchanger.addVariant("Link","The Legend of Zelda (NES)","01-ZELDA1-NES")
smascharacterchanger.addVariant("Link","Zelda: Link's Awakening (SNES)","05-LINKWAKE-SNES")
smascharacterchanger.addVariant("Link","Super Mario Bros. (SNES)","SMB1-SNES")
smascharacterchanger.addVariant("Link","Super Mario Bros. 2 (SNES)","SMB2-SNES")

--**Mega Man variants**
smascharacterchanger.addVariant("Mega Man","Mega Man 1-6 (NES)","MEGAMAN-NES")
smascharacterchanger.addVariant("Mega Man","Bad Box Art Mega Man","BAD BOX ART MEGA MAN")

--**Yoshi (SMW2) variants**
smascharacterchanger.addVariant("Yoshi (SMW2, Alt)","Yoshi's Story","YS-GREEN")

--**Rosalina variants**
smascharacterchanger.addVariant("Rosalina","Super Mario Bros. 2 (SNES)","SMB2-SMAS")

--**Samus variants**
smascharacterchanger.addVariant("Samus","Metroid (NES)","SAMUS-NES")

--**Steve variants**
smascharacterchanger.addVariant("Minecraft","Alex (Default)","MC-ALEX")
smascharacterchanger.addVariant("Minecraft","Herobrine","MC-HEROBRINE")
smascharacterchanger.addVariant("Minecraft","Zombie","MC-ZOMBIE")
smascharacterchanger.addVariant("Minecraft","Notch","MC-NOTCH")

smascharacterchanger.addVariant("Minecraft","ExplodingTNT (YouTube)","EXPLODINGTNT")
smascharacterchanger.addVariant("Minecraft","GeorgeNotFound (YouTube)","GEORGENOTFOUNDYT")
smascharacterchanger.addVariant("Minecraft","HangoutYoshiGuy (YouTube)","HANGOUTYOSHIGUYYT")
smascharacterchanger.addVariant("Minecraft","Karl Jacobs (YouTube)","KARLJACOBSYT")
smascharacterchanger.addVariant("Minecraft","ItsHarry (YouTube)","MC-ITSHARRY")
smascharacterchanger.addVariant("Minecraft","ItsJerry (YouTube)","MC-ITSJERRY")
smascharacterchanger.addVariant("Minecraft","Keralis (YouTube)","MC-KERALIS")
smascharacterchanger.addVariant("Minecraft","Mystery Man Bro (YouTube)","MYSTERYMANBRO")
smascharacterchanger.addVariant("Minecraft","Quackity (YouTube)","QUACKITYYT")
smascharacterchanger.addVariant("Minecraft","TechnoBlade (YouTube)","TECHNOBLADE")
smascharacterchanger.addVariant("Minecraft","TommyInnit (YouTube)","TOMMYINNITYT")
smascharacterchanger.addVariant("Minecraft","UnofficialStudios (YouTube)","UNOFFICIALSTUDIOSYT")

smascharacterchanger.addVariant("Minecraft","Christmas Tree (DLC)","DLC-DESTIVE-CHRISTMASTREE")

smascharacterchanger.addVariant("Minecraft","Mario (Super Mario Bros.)","MC-MARIO")
smascharacterchanger.addVariant("Minecraft","Captain Toad","MC-CAPTAINTOAD")
smascharacterchanger.addVariant("Minecraft","Koopapanzer","KOOPAPANZER")
smascharacterchanger.addVariant("Minecraft","Sonic (Sonic the Hedgehog)","MC-SONIC")
smascharacterchanger.addVariant("Minecraft","Tails (Sonic the Hedgehog)","MC-TAILS")
smascharacterchanger.addVariant("Minecraft","SpongeBob (SpongeBob)","MC-SPONGEBOB")
smascharacterchanger.addVariant("Minecraft","Patrick (SpongeBob)","MC-PATRICK")
smascharacterchanger.addVariant("Minecraft","Squidward (SpongeBob)","MC-SQUIDWARD")
smascharacterchanger.addVariant("Minecraft","Frisk (Undertale)","MC-FRISK")
smascharacterchanger.addVariant("Minecraft","Kris (Deltarune)","MC-KRIS")
smascharacterchanger.addVariant("Minecraft","Susie (Deltarune)","MC-SUSIE-DELTARUNE")
smascharacterchanger.addVariant("Minecraft","Ralsei (Deltarune)","MC-RALSEI")
smascharacterchanger.addVariant("Minecraft","Noelle (Deltarune)","MC-NOELLE-DELTARUNE")
smascharacterchanger.addVariant("Minecraft","Boyfriend (FNF)","MC-FNF-BOYFRIEND")
smascharacterchanger.addVariant("Minecraft","Girlfriend (FNF)","MC-FNF-GIRLFRIEND")
smascharacterchanger.addVariant("Minecraft","Impostor (Among Us)","MC-IMPOSTOR")
smascharacterchanger.addVariant("Minecraft","Ed (Ed Edd and Eddy)","ED-EDEDDANDEDDY")
smascharacterchanger.addVariant("Minecraft","Spiderman","MC-SPIDERMAN")

smascharacterchanger.addVariant("Minecraft","Cubix Tron (C!TS!)","DJCTRE-CUBIXTRON")
smascharacterchanger.addVariant("Minecraft","Cubix Tron Dad (C!TS!)","DJCTRE-CUBIXTRONDAD")
smascharacterchanger.addVariant("Minecraft","Stultus (C!TS!)","DJCTRE-STULTUS")

smascharacterchanger.addVariant("Minecraft","Spencer (S!TS! REBOOT)","SEE-MC-SPENCEREVERLY")
smascharacterchanger.addVariant("Minecraft","Spencer 2 (S!TS! REBOOT)","SEE-MC-SPENCER2")
smascharacterchanger.addVariant("Minecraft","Sherbert (S!TS! REBOOT)","SEE-MC-SHERBERTLUSSIEBACK")
smascharacterchanger.addVariant("Minecraft","Lewbert (S!TS! REBOOT)","SEE-MC-LEWBERTLUSSIEBACK")
smascharacterchanger.addVariant("Minecraft","Evil Me (S!TS! REBOOT)","SEE-MC-EVILME")
smascharacterchanger.addVariant("Minecraft","Shenicle (S!TS! REBOOT)","SEE-MC-SHENICLE")
smascharacterchanger.addVariant("Minecraft","Tianely (S!TS! REBOOT)","SEE-MC-TIANELY")
smascharacterchanger.addVariant("Minecraft","Lili (S!TS! REBOOT)","SEE-MC-LILIJUCIEBACK")
smascharacterchanger.addVariant("Minecraft","Mimi (S!TS! REBOOT)","SEE-MC-MIMIJUCIEBACK")
smascharacterchanger.addVariant("Minecraft","Geranium (S!TS! REBOOT)","SEE-MC-GERANIUM")
smascharacterchanger.addVariant("Minecraft","Shelley (S!TS! REBOOT)","SEE-MC-SHELEYKIRK")
smascharacterchanger.addVariant("Minecraft","Ron (S!TS! REBOOT)","SEE-MC-RONDAVIS")

--**Wario variants**
smascharacterchanger.addVariant("Wario","Super Mario Bros. 3","SMB3-WARIO")

--**Takeshi variants**
smascharacterchanger.addVariant("Takeshi","Takeshi's Challenge (SNES)","TAKESHI-SNES")

return smascharacterchanger