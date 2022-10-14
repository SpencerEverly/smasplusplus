local smascharacterchanger = {}

local playerManager = require("playerManager")
local textplus = require("textplus")
local smbx13font = textplus.loadFont("littleDialogue/font/smilebasic.ini")

function smascharacterchanger.onInitAPI()
    registerEvent(smascharacterchanger,"onDraw")
    registerEvent(smascharacterchanger,"onInputUpdate")
    registerEvent(smascharacterchanger,"onKeyboardPressDirect")
end

smascharacterchanger.tvImage = Img.load("graphics/characterchangermenu/tv.png") --The image for the TV.
smascharacterchanger.scrollSFX = "_OST/_Sound Effects/characterchangermenu/scrolling-tv.ogg"
smascharacterchanger.stopSFX = "_OST/_Sound Effects/characterchangermenu/scrolled-tv.ogg"
smascharacterchanger.turnOnSFX = "_OST/_Sound Effects/characterchangermenu/turn-on-tv.ogg"
smascharacterchanger.menuActive = false --True if the menu is active.
smascharacterchanger.animationActive = false --True if the animation is active.
smascharacterchanger.animationTimer = 0 --Timer for the animation, both for the start and end sequences.
smascharacterchanger.tvScrollNumber = -600 --This is used for the TV animation sequence.
smascharacterchanger.menuBGM = "_OST/All Stars Menu/Character Changer Menu.ogg"
smascharacterchanger.selectionNumber = 1 --For scrolling left and right
smascharacterchanger.selectionNumberUpDown = 1 --For scrolling up and down

smascharacterchanger.names = {}
smascharacterchanger.namesGame = {}
smascharacterchanger.namesCharacter = {}
smascharacterchanger.namesCostume = {}

function smascharacterchanger.addCharacter(name,game,character,costume)
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

function smascharacterchanger.addVariant(nameToFind,game,costume)
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
    if nameToFind ~= nil then
        local foundName = table.ifind(smascharacterchanger.names, nameToFind)
        if foundName == nil then
            error("Name wasn't found! You need to specify a valid name.")
            return
        else
            --Misc.dialog(tostring(foundName))
            table.insert(smascharacterchanger.namesGame[foundName], game)
            table.insert(smascharacterchanger.namesCostume[foundName], costume)
        end
    end
end

smascharacterchanger.addCharacter("Mario","Super Mario Bros. 3",1,"!DEFAULT")
smascharacterchanger.addCharacter("Luigi","Super Mario Bros. 3",2,"!DEFAULT")
smascharacterchanger.addCharacter("Peach","Super Mario Bros. 2",3,"!DEFAULT")
smascharacterchanger.addCharacter("Toad","Super Mario Bros. 2",4,"!DEFAULT")
smascharacterchanger.addCharacter("Wario","Super Mario Bros. X2",7,"nil")
smascharacterchanger.addCharacter("Waluigi","Mario Tennis",2,"WALUIGI")
smascharacterchanger.addCharacter("Bowser","Super Mario Bros. X2",8,"nil")
smascharacterchanger.addCharacter("Goomba","Super Mario Bros. 3",1,"Goomba")
smascharacterchanger.addCharacter("Link","Zelda II",5,"!DEFAULT")
smascharacterchanger.addCharacter("Mega Man","Mega Man X7",6,"nil")
smascharacterchanger.addCharacter("Klonoa","Klonoa 2 (GBA)",9,"nil")
smascharacterchanger.addCharacter("Plunder Bomber","Super Bomberman 5",3,"NINJABOMBERMAN")
smascharacterchanger.addCharacter("Rosalina","Super Mario Bros. X2",11,"nil")
smascharacterchanger.addCharacter("Rosalina (Alt)","Super Mario Bros. X2",1,"ROSALINA")
smascharacterchanger.addCharacter("Snake","Super Mario Bros. X2",12,"nil")
smascharacterchanger.addCharacter("Zelda","Super Mario Bros. X2",13,"nil")
smascharacterchanger.addCharacter("Ultimate Rinka","Super Mario Bros. X2",4,"ULTIMATERINKA")
smascharacterchanger.addCharacter("Samus","Metroid (SMBX2)",16,"nil")
smascharacterchanger.addCharacter("Frisk","Undertale",2,"UNDERTALE-FRISK")
smascharacterchanger.addCharacter("Yoshi","SMW2: Yoshi's Island",10,"nil")
smascharacterchanger.addCharacter("Steve","Minecraft",14,"nil")
smascharacterchanger.addCharacter("Demo","A2XT",1,"A2XT-DEMO")
smascharacterchanger.addCharacter("Iris","A2XT",2,"A2XT-IRIS")
smascharacterchanger.addCharacter("Kood","A2XT",3,"A2XT-KOOD")
smascharacterchanger.addCharacter("Raocow","A2XT/YouTube",4,"A2XT-RAOCOW")
smascharacterchanger.addCharacter("Sheath","A2XT",5,"A2XT-SHEATH")
smascharacterchanger.addCharacter("Uncle Broadsword","A2XT",15,"nil")
smascharacterchanger.addCharacter("Pily","A2XT2: Gaiden 2",1,"DEMO-XMASPILY")
smascharacterchanger.addCharacter("Tangent","Spencer Everly (SEE)",4,"SEE-TANGENT")
smascharacterchanger.addCharacter("SpongeBob","SpongeBob SquarePants",1,"SPONGEBOBSQUAREPANTS")
smascharacterchanger.addCharacter("Eric Cartman","South Park",1,"SP-1-ERICCARTMAN")
smascharacterchanger.addCharacter("Rebel Trooper","LEGO Star Wars",4,"LEGOSTARWARS-REBELTROOPER")
smascharacterchanger.addCharacter("SMG4","SMG4 (YouTube)",1,"SMG4")
smascharacterchanger.addCharacter("PAC-MAN","PAC-MAN Arrangement",4,"PACMAN-ARRANGEMENT-PACMAN")
smascharacterchanger.addCharacter("Taizo","Dig Dug: Digging Strike",4,"DIGDUG-DIGGINGSTRIKE")
smascharacterchanger.addCharacter("Caillou","GoAnimate/Vyond",1,"GA-CAILLOU")
smascharacterchanger.addCharacter("Boris","GoAnimate/Vyond",2,"GA-BORIS")
smascharacterchanger.addCharacter("Runner Red","10 Second Run (DSi)",1,"GO-10SECONDRUN")
smascharacterchanger.addCharacter("JC Foster","JC Foster Takes it to the Moon",1,"JCFOSTERTAKESITTOTHEMOON")
smascharacterchanger.addCharacter("Larry the Cucumber","VeggieTales",2,"LARRYTHECUCUMBER")
smascharacterchanger.addCharacter("Takeshi","Takeshi's Challenge",5,"TAKESHI")
smascharacterchanger.addCharacter("Sherbert Lussieback","Spencer! The Show! REBOOT",5,"SEE-SHERBERTLUSSIEBACK")

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

local changed = false

local soundObject1
local menuBGMObject

local started = false
local ending = false

local function textPrintCentered(t, x, y, color)
    textplus.print{text=t, x=x, y=y, plaintext=true, pivot=vector.v2(0.5,0.5), xscale=1.5, yscale=1.5, color=color, priority = -1.7, font = smbx13font}
end

function smascharacterchanger.startupChanger()
    Misc.pause()
    Sound.muteMusic(-1)
    if pauseplus then
        pauseplus.canPause = false
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

function smascharacterchanger.shutdownChanger()
    started = false
    ending = true
    smascharacterchanger.animationActive = true
    Sound.playSFX(1001)
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
end

function smascharacterchanger.onInputUpdate()
    if smascharacterchanger.menuActive and started then
        if player.keys.run == KEYS_PRESSED then
            smascharacterchanger.menuActive = false
        end
        if player.keys.up == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumberUpDown = smascharacterchanger.selectionNumberUpDown + 1
            if smascharacterchanger.selectionNumberUpDown > #smascharacterchanger.namesGame[smascharacterchanger.selectionNumber] then
                smascharacterchanger.selectionNumberUpDown = 1
            end
        elseif player.keys.down == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumberUpDown = smascharacterchanger.selectionNumberUpDown - 1
            if smascharacterchanger.selectionNumberUpDown < 1 then
                smascharacterchanger.selectionNumberUpDown = #smascharacterchanger.namesGame[smascharacterchanger.selectionNumber]
            end
        end
        if player.keys.left == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumber = smascharacterchanger.selectionNumber - 1
            smascharacterchanger.selectionNumberUpDown = 1
        elseif player.keys.right == KEYS_PRESSED then
            Sound.playSFX(26)
            smascharacterchanger.selectionNumber = smascharacterchanger.selectionNumber + 1
            smascharacterchanger.selectionNumberUpDown = 1
        end
        if player.keys.jump == KEYS_PRESSED then
            Sound.playSFX("charcost_costume.ogg")
            Sound.playSFX("charcost-selected.ogg")
            
            
            
            if smascharacterchanger.selectionNumber then
                if smascharacterchanger.namesCostume[smascharacterchanger.selectionNumber] ~= "nil" then
                    player:transform(smascharacterchanger.namesCharacter[smascharacterchanger.selectionNumber], false)
                    player.setCostume(smascharacterchanger.namesCharacter[smascharacterchanger.selectionNumber], smascharacterchanger.namesCostume[smascharacterchanger.selectionNumber][smascharacterchanger.selectionNumberUpDown], false)
                else
                    player:transform(smascharacterchanger.namesCharacter[smascharacterchanger.selectionNumber], false)
                    player.setCostume(smascharacterchanger.namesCharacter[smascharacterchanger.selectionNumber], nil, false)
                end
                changed = true
                smascharacterchanger.menuActive = false
            end
            
            
            
        end
    end
end

function smascharacterchanger.onDraw()
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
            textPrintCentered("Select your character!", 400, 100)
            Text.print(smascharacterchanger.selectionNumber, 100, 100)
            Text.print(smascharacterchanger.selectionNumberUpDown, 100, 120)
            if smascharacterchanger.selectionNumber < 1 then
                smascharacterchanger.selectionNumber = #smascharacterchanger.names
            elseif smascharacterchanger.selectionNumber > #smascharacterchanger.names then
                smascharacterchanger.selectionNumber = 1
            end
            if smascharacterchanger.selectionNumber and smascharacterchanger.selectionNumberUpDown then
                textPrintCentered(smascharacterchanger.names[smascharacterchanger.selectionNumber], 400, 200)
                textPrintCentered(smascharacterchanger.namesGame[smascharacterchanger.selectionNumber][smascharacterchanger.selectionNumberUpDown], 400, 250)
            end
        end
        if not smascharacterchanger.animationActive and started then
            Graphics.drawImageWP(smascharacterchanger.tvImage, 0, 0, -1.5)
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

return smascharacterchanger