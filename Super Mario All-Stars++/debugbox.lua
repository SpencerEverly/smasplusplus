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

local soundObject

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

if SaveData.resolution == "fullscreen" then
	littleDialogue.registerStyle("smbx13",{
		textXScale = 1.4,
		textYScale = 1.4,
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
end

if SaveData.resolution == "widescreen" then
	littleDialogue.registerStyle("smbx13",{
		textXScale = 0.8,
		textYScale = 0.8,
		borderSize = 36,
		textMaxWidth = 500,
		speakerNameGap = 6,
		speakerNameXScale = 1.0,        -- X scale of the speaker's name.
		speakerNameYScale = 1.0,
		
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
end

function debugbox.onInitAPI()
	registerEvent(debugbox, "onKeyboardPress")
	registerEvent(debugbox, "onDraw")
	registerEvent(debugbox, "onLevelExit")
	
	ready = true
end

function debugbox.onStart()
	if not ready then return end
end

function debugbox.onKeyboardPress(k)
	if k == VK_F8 then
		SFX.play("cheating_victory.ogg")
		littleDialogue.create({text = "<boxStyle smbx13>NNW SMSK? (What shall you do?)<page><question DEBUG>", updatesInPause = true})
	end
end


littleDialogue.registerAnswer("DEBUG",{text = "Exit Menu",addText = "Press jump to exit. Press F8 to revisit the DEBUG MENU."})
littleDialogue.registerAnswer("DEBUG",{text = "IDU (Warp to level/area)",addText = "IDU<question AREA>"})
littleDialogue.registerAnswer("DEBUG",{text = "GtZStTI (Goods Edit/Powerup Menu)",addText = "GtZKWER<question POWERUP>"})
littleDialogue.registerAnswer("DEBUG",{text = "FST PLYR (Toggle 1st Player)", chosenFunction = function() Cheats.trigger("1player") end})
littleDialogue.registerAnswer("DEBUG",{text = "SND PLYR (Toggle 2nd Player)", chosenFunction = function() Cheats.trigger("2player") end})
littleDialogue.registerAnswer("DEBUG",{text = "SUND (Sound Menu)",addText = "SUND? (Which sound section?)<question MUSIC>"})
littleDialogue.registerAnswer("DEBUG",{text = "CODSOD (Add 1000 Coins to Total Coin Count)", chosenFunction = function() SaveData.totalcoins = SaveData.totalcoins + 1000 SFX.play(27) end})
littleDialogue.registerAnswer("DEBUG",{text = "EXT (Exit Level)", chosenFunction = function() Level.exit() end})
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
littleDialogue.registerAnswer("BGM",{text = "1",chosenFunction = function() Audio.MusicChange(0, 1) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "2",chosenFunction = function() Audio.MusicChange(0, 2) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "3",chosenFunction = function() Audio.MusicChange(0, 3) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "4",chosenFunction = function() Audio.MusicChange(0, 4) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "5",chosenFunction = function() Audio.MusicChange(0, 5) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "6",chosenFunction = function() Audio.MusicChange(0, 6) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "7",chosenFunction = function() Audio.MusicChange(0, 7) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "8",chosenFunction = function() Audio.MusicChange(0, 8) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "9",chosenFunction = function() Audio.MusicChange(0, 9) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "10",chosenFunction = function() Audio.MusicChange(0, 10) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "11",chosenFunction = function() Audio.MusicChange(0, 11) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "12",chosenFunction = function() Audio.MusicChange(0, 12) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "13",chosenFunction = function() Audio.MusicChange(0, 13) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "14",chosenFunction = function() Audio.MusicChange(0, 14) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "15",chosenFunction = function() Audio.MusicChange(0, 15) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "16",chosenFunction = function() Audio.MusicChange(0, 16) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "17",chosenFunction = function() Audio.MusicChange(0, 17) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "18",chosenFunction = function() Audio.MusicChange(0, 18) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "19",chosenFunction = function() Audio.MusicChange(0, 19) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "20",chosenFunction = function() Audio.MusicChange(0, 20) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "21",chosenFunction = function() Audio.MusicChange(0, 21) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "22",chosenFunction = function() Audio.MusicChange(0, 22) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "23",chosenFunction = function() Audio.MusicChange(0, 23) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "24",chosenFunction = function() Audio.MusicChange(0, 24) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "25",chosenFunction = function() Audio.MusicChange(0, 25) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "26",chosenFunction = function() Audio.MusicChange(0, 26) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "27",chosenFunction = function() Audio.MusicChange(0, 27) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "28",chosenFunction = function() Audio.MusicChange(0, 28) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "29",chosenFunction = function() Audio.MusicChange(0, 29) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "30",chosenFunction = function() Audio.MusicChange(0, 30) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "31",chosenFunction = function() Audio.MusicChange(0, 31) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "32",chosenFunction = function() Audio.MusicChange(0, 32) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "33",chosenFunction = function() Audio.MusicChange(0, 33) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "34",chosenFunction = function() Audio.MusicChange(0, 34) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "35",chosenFunction = function() Audio.MusicChange(0, 35) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "36",chosenFunction = function() Audio.MusicChange(0, 36) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "37",chosenFunction = function() Audio.MusicChange(0, 37) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "38",chosenFunction = function() Audio.MusicChange(0, 38) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "39",chosenFunction = function() Audio.MusicChange(0, 39) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "40",chosenFunction = function() Audio.MusicChange(0, 40) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "41",chosenFunction = function() Audio.MusicChange(0, 41) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "42",chosenFunction = function() Audio.MusicChange(0, 42) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "43",chosenFunction = function() Audio.MusicChange(0, 43) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "44",chosenFunction = function() Audio.MusicChange(0, 44) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "45",chosenFunction = function() Audio.MusicChange(0, 45) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "46",chosenFunction = function() Audio.MusicChange(0, 46) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "47",chosenFunction = function() Audio.MusicChange(0, 47) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "48",chosenFunction = function() Audio.MusicChange(0, 48) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "49",chosenFunction = function() Audio.MusicChange(0, 49) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "50",chosenFunction = function() Audio.MusicChange(0, 50) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "51",chosenFunction = function() Audio.MusicChange(0, 51) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "52",chosenFunction = function() Audio.MusicChange(0, 52) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "53",chosenFunction = function() Audio.MusicChange(0, 53) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "54",chosenFunction = function() Audio.MusicChange(0, 54) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "55",chosenFunction = function() Audio.MusicChange(0, 55) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "56",chosenFunction = function() Audio.MusicChange(0, 56) end, addText = "Playing in Room 0.<page>NNW SMSK? (What shall you do?)<page><question DEBUG>"})
littleDialogue.registerAnswer("BGM",{text = "Up one",addText = "SUND? (Which sound section?)<question MUSIC>"})




littleDialogue.registerAnswer("SFX",{text = "Up one",addText = "SND? (Which sound section?)<question MUSIC>"})
littleDialogue.registerAnswer("SFX",{text = "1 - Jump",chosenFunction = function() SFX.play(1) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "2 - Stomp",chosenFunction = function() SFX.play(2) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "3 - Block Hit",chosenFunction = function() SFX.play(3) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "4 - Block Smashed",chosenFunction = function() SFX.play(4) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "5 - Shrink",chosenFunction = function() SFX.play(5) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "6 - Grow",chosenFunction = function() SFX.play(6) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "7 - Mushroom",chosenFunction = function() SFX.play(7) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "8 - Player Died",chosenFunction = function() SFX.play(8) end, addText = "SND? (Which sound section?)<question SFX>"})
littleDialogue.registerAnswer("SFX",{text = "9 - Shell Kick",chosenFunction = function() SFX.play(9) end, addText = "SND? (Which sound section?)<question SFX>"})



return debugbox