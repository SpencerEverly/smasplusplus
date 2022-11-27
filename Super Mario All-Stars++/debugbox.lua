local littleDialogue = require("littleDialogue")
local textplus = require("textplus")

local active = false
local ready = false

onePressedState = false
twoPressedState = false
threePressedState = false
fourPressedState = false
fivePressedState = false
sixPressedState = false
sevenPressedState = false
eightPressedState = false
ninePressedState = false
zeroPressedState = false

local flag = true
local str = "Loading HUB..."

local debugbox = {}

debugbox.bootactive = false

local soundObject

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

littleDialogue.registerStyle("smbx13",{
    textXScale = 1,
    textYScale = 1,
    borderSize = 36,
    textMaxWidth = 500,
    speakerNameGap = 6,
    speakerNameXScale = 1.2,        -- X scale of the speaker's name.
    speakerNameYScale = 1.2,
    
    openSpeed = 5,
    pageScrollSpeed = 5, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 5, -- How fast it scrolls when switching answer pages.
    borderSize = 8,
    
    forcedPosEnabled = true,       -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
    forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
    forcedPosY = 150,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
    forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
    forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

    windowingOpeningEffectEnabled = false,

    typewriterEnabled = false,
    showTextWhileOpening = true,

    closeSoundEnabled = false,
    continueArrowEnabled = false,
    scrollArrowEnabled   = false,
    selectorImageEnabled = true,
    
})

function debugbox.onInitAPI()
    registerEvent(debugbox, "onKeyboardPress")
    registerEvent(debugbox, "onDraw")
    registerEvent(debugbox, "onLevelExit")
    
    ready = true
end

function debugbox.onStart()
    if not ready then return end
end

function debugbox.onKeyboardPress(k, repeated)
    if debugbox.bootactive == true then
        if k == VK_F4 then
            Sound.playSFX("cheating_victory.ogg")
            littleDialogue.create({text = "<boxStyle smbx13>NNW SMSK? (What shall you do?)<page><question DEBUG>", updatesInPause = true})
        end
    end
end


littleDialogue.registerAnswer("DEBUG",{text = "Exit Menu",addText = "Press jump to exit. Press F4 to revisit the DEBUG MENU."})
littleDialogue.registerAnswer("DEBUG",{text = "IDU (Warp to level/area)",addText = "IDU<question AREA>"})
littleDialogue.registerAnswer("DEBUG",{text = "GtZStTI (Goods Edit/Powerup Menu)",addText = "GtZKWER<question POWERUP>"})
littleDialogue.registerAnswer("DEBUG",{text = "FST PLYR (Toggle 1st Player)", chosenFunction = function() Playur.activate1stPlayer() end})
littleDialogue.registerAnswer("DEBUG",{text = "SND PLYR (Toggle 2nd Player)", chosenFunction = function() Playur.activate2ndPlayer() end})
littleDialogue.registerAnswer("DEBUG",{text = "SUND (Sound Menu)",addText = "SUND? (Which sound section?)<question MUSIC>"})
littleDialogue.registerAnswer("DEBUG",{text = "CODSOD (Add 1000 Coins to Total Coin Count)", chosenFunction = function() SaveData.totalCoins = SaveData.totalcoins + 1000 Sound.playSFX(27) end})
littleDialogue.registerAnswer("DEBUG",{text = "EXT (Exit Level)", chosenFunction = function() Level.load("map.lvlx") end})
littleDialogue.registerAnswer("DEBUG",{text = "RESTT (Restart Level)", chosenFunction = function() Level.load() end})
littleDialogue.registerAnswer("DEBUG",{text = "KIL (Kill Player)", chosenFunction = function() player:kill() end})




littleDialogue.registerAnswer("AREA",{text = "Up one",addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("AREA",{text = "Preboot Menu",chosenFunction = function() Level.load("SMAS - Start.lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "S.E. 2022 SMBX2 Remake Intro",chosenFunction = function() Level.load("SMAS - Intro.lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "HUB (MALC)",chosenFunction = function() Level.load("MALC - HUB.lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "HUB (MALC): True Ending",chosenFunction = function() Level.load("MALC - HUB.lvlx", nil, 15) end})
littleDialogue.registerAnswer("AREA",{text = "HUB (MALC): Character Room",chosenFunction = function() Level.load("MALC - HUB.lvlx", nil, 41) end})
littleDialogue.registerAnswer("AREA",{text = "SMB1: 1-1",chosenFunction = function() Level.load("SMB1 - W-1, L-1.lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "SMB1: 1-2",chosenFunction = function() Level.load("SMB1 - W-1, L-2.lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "SMW: Yoshi's House",chosenFunction = function() Level.load("SMW - W-1, L-YH.lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) Game Select",chosenFunction = function() Level.load("SMAS - Game Select (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) SMB1 Game Select",chosenFunction = function() Level.load("SMB1 - Game Select (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) SMBLL Game Select",chosenFunction = function() Level.load("SMBLL - Game Select (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) SMB1: World 8-4, Original Ver.",chosenFunction = function() Level.load("SMB1 - W-8, L-4 (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) SMB1: Warp Level",chosenFunction = function() Level.load("SMB1 - Warp (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) SMBLL: Warp Level",chosenFunction = function() Level.load("SMBLL - Warp (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) SMB2: Warp Level",chosenFunction = function() Level.load("SMB2 - Warp (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) SMB3: Warp Level",chosenFunction = function() Level.load("SMB3 - Warp (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) SMW: Warp Level",chosenFunction = function() Level.load("SMW - Warp (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(SCRAPPED) SMBS: Warp Level",chosenFunction = function() Level.load("SMBS - Warp (Scrapped).lvlx", nil, nil) end})
littleDialogue.registerAnswer("AREA",{text = "(BROKEN) SMB3: Bonus Challenge 1",chosenFunction = function() Level.load("SMB2 - Warp (Scrapped).lvlx", nil, nil) end})





littleDialogue.registerAnswer("POWERUP",{text = "Up one",addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("POWERUP",{text = "Small",chosenFunction = function() player.powerup = 1 end, addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("POWERUP",{text = "Big",chosenFunction = function() player.powerup = 2 end, addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("POWERUP",{text = "Fire",chosenFunction = function() player.powerup = 3 end, addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("POWERUP",{text = "Leaf",chosenFunction = function() player.powerup = 4 end, addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("POWERUP",{text = "Tanooki",chosenFunction = function() player.powerup = 5 end, addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("POWERUP",{text = "Hammer",chosenFunction = function() player.powerup = 6 end, addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("POWERUP",{text = "Ice",chosenFunction = function() player.powerup = 7 end, addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})



littleDialogue.registerAnswer("MUSIC",{text = "Up one",addText = "NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("MUSIC",{text = "BGM",addText = "1-57? (Which track?)<page><question BGM>"})
littleDialogue.registerAnswer("MUSIC",{text = "SE (SFX)",addText = "1-91? (Which sound?)<page><question SFX>"})

littleDialogue.registerAnswer("BGM",{text = "Up one",addText = "SUND? (Which sound section?)<question MUSIC>"})
littleDialogue.registerAnswer("BGM",{text = "1",chosenFunction = function() Sound.changeMusic(1, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "2",chosenFunction = function() Sound.changeMusic(2, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "3",chosenFunction = function() Sound.changeMusic(3, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "4",chosenFunction = function() Sound.changeMusic(4, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "5",chosenFunction = function() Sound.changeMusic(5, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "6",chosenFunction = function() Sound.changeMusic(6, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "7",chosenFunction = function() Sound.changeMusic(7, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "8",chosenFunction = function() Sound.changeMusic(8, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "9",chosenFunction = function() Sound.changeMusic(9, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "10",chosenFunction = function() Sound.changeMusic(10, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "11",chosenFunction = function() Sound.changeMusic(11, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "12",chosenFunction = function() Sound.changeMusic(12, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "13",chosenFunction = function() Sound.changeMusic(13, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "14",chosenFunction = function() Sound.changeMusic(14, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "15",chosenFunction = function() Sound.changeMusic(15, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "16",chosenFunction = function() Sound.changeMusic(16, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "17",chosenFunction = function() Sound.changeMusic(17, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "18",chosenFunction = function() Sound.changeMusic(18, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "19",chosenFunction = function() Sound.changeMusic(19, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "20",chosenFunction = function() Sound.changeMusic(20, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "21",chosenFunction = function() Sound.changeMusic(21, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "22",chosenFunction = function() Sound.changeMusic(22, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "23",chosenFunction = function() Sound.changeMusic(23, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "24",chosenFunction = function() Sound.changeMusic(24, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "25",chosenFunction = function() Sound.changeMusic(25, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "26",chosenFunction = function() Sound.changeMusic(26, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "27",chosenFunction = function() Sound.changeMusic(27, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "28",chosenFunction = function() Sound.changeMusic(28, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "29",chosenFunction = function() Sound.changeMusic(29, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "30",chosenFunction = function() Sound.changeMusic(30, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "31",chosenFunction = function() Sound.changeMusic(31, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "32",chosenFunction = function() Sound.changeMusic(32, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "33",chosenFunction = function() Sound.changeMusic(33, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "34",chosenFunction = function() Sound.changeMusic(34, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "35",chosenFunction = function() Sound.changeMusic(35, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "36",chosenFunction = function() Sound.changeMusic(36, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "37",chosenFunction = function() Sound.changeMusic(37, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "38",chosenFunction = function() Sound.changeMusic(38, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "39",chosenFunction = function() Sound.changeMusic(39, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "40",chosenFunction = function() Sound.changeMusic(40, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "41",chosenFunction = function() Sound.changeMusic(41, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "42",chosenFunction = function() Sound.changeMusic(42, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "43",chosenFunction = function() Sound.changeMusic(43, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "44",chosenFunction = function() Sound.changeMusic(44, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "45",chosenFunction = function() Sound.changeMusic(45, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "46",chosenFunction = function() Sound.changeMusic(46, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "47",chosenFunction = function() Sound.changeMusic(47, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "48",chosenFunction = function() Sound.changeMusic(48, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "49",chosenFunction = function() Sound.changeMusic(49, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "50",chosenFunction = function() Sound.changeMusic(50, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "51",chosenFunction = function() Sound.changeMusic(51, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "52",chosenFunction = function() Sound.changeMusic(52, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "53",chosenFunction = function() Sound.changeMusic(53, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "54",chosenFunction = function() Sound.changeMusic(54, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "55",chosenFunction = function() Sound.changeMusic(55, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "56",chosenFunction = function() Sound.changeMusic(56, 0) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "Up one",addText = "SUND? (Which sound section?)<question MUSIC>"})




littleDialogue.registerAnswer("SFX",{text = "Up one",addText = "SND? (Which sound section?)<question MUSIC>"})
littleDialogue.registerAnswer("SFX",{text = "1 - Jump",chosenFunction = function() Sound.playSFX(1) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "2 - Stomp",chosenFunction = function() Sound.playSFX(2) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "3 - Block Hit",chosenFunction = function() Sound.playSFX(3) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "4 - Block Smashed",chosenFunction = function() Sound.playSFX(4) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "5 - Shrink",chosenFunction = function() Sound.playSFX(5) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "6 - Grow",chosenFunction = function() Sound.playSFX(6) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "7 - Mushroom",chosenFunction = function() Sound.playSFX(7) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "8 - Player Died",chosenFunction = function() Sound.playSFX(8) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "9 - Shell Kick",chosenFunction = function() Sound.playSFX(9) end, addText = "SND? (Which sound section?)<question SFX>"})



return debugbox