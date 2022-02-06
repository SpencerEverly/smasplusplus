--Theme switching for if you wanna use this system in your episode.


---------MUSIC REPLACING---------

-----Replacing music sections-----

--For music, first add the requring stuffs:

local playerManager = require("playerManager")

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()
local level = Level.filename()

local ready = false

--This is important so that the code will work
local costumes = {}

local musicalchairs = {}

--This starts the script as a seperate library
function musicalchairs.onInitAPI()
	registerEvent(musicalchairs, "onStart")
	registerEvent(musicalchairs, "onTick")
	registerEvent(musicalchairs, "onEvent")
	
	ready = true
end

function musicalchairs.onStart()
	if not ready then return end
end

--onTick is for sections that don't change the section music.
function musicalchairs.onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	--Audio.MusicChange is the command that changes sections. Followed by a room number found in the level, and then the path/to/file.extension.
	
	--If level is called to change music on one big lua script. That way, more than a hundred scripts wouldn't be scripted seperately. They are placed on the "currentCostume if" part.
	--Example: if level == "SMB1 - W-1, L-1.lvlx" then
	
	local costumes
	--CHARACTER_MARIO
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg")
			Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/Bonus.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/Caves.ogg")
			Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg")
			Audio.MusicChange(3, "_OST/Super Mario All-Stars++ (Beta)/Bonus.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/AthleticSMB1.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/BeforeCastleSMB1.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|1;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros (NES) - OST.nsf|1;g=2")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros (NES)/Athletic.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES)/Sky.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		end
	end
	if currentCostume == "9-SMW-PIRATE" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2")
			Audio.MusicChange(1, "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2")
			Audio.MusicChange(2, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2")
			Audio.MusicChange(3, "_OST/Super Mario World (Pirate)/Bonus.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario World (Pirate)/Athletic.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "11-SMA1" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance 4/Underground Level.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance 4/Underground Level.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		end
	end
	if currentCostume == "13-SMA4" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance 4/Underground Level.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Bonus Stage.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Underground Theme.ogg")
			Audio.MusicChange(2, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(3, "_OST/New Super Mario Bros. DS/Bonus Stage.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Bonus Stage.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Underground Theme.ogg")
			Audio.MusicChange(2, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(3, "_OST/New Super Mario Bros. DS/Bonus Stage.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(3, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/humble_down_theroad.mod")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5")
		end
	end
	if currentCostume == "GA-CAILLOU" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/GoAnimate/Old Songs/Action - Adventure.mp3")
			Audio.MusicChange(1, "_OST/GoAnimate/Old Songs/Ambient - Relaxing.mp3")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/GoAnimate/Old Songs/Ambient - Relaxing.mp3")
			Audio.MusicChange(2, "_OST/GoAnimate/Old Songs/Action - Adventure.mp3")
			Audio.MusicChange(3, "_OST/GoAnimate/Old Songs/Ambient - Relaxing.mp3")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/GoAnimate/Old Songs/Bossa Story.mp3")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/GoAnimate/Old Songs/Bossa Story.mp3")
		end
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.2")
			Audio.MusicChange(1, "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2")
			Audio.MusicChange(2, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.2")
			Audio.MusicChange(3, "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/JC Foster Takes it to the Moon/mm2wood.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.2")
		end
	end
	if currentCostume == "MARINK" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=2")
			Audio.MusicChange(1, "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|7;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|9;g=2")
			Audio.MusicChange(2, "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=2")
			Audio.MusicChange(3, "_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|7;g=2")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|9;g=2.1")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "MODERN" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Modern Mario/Overworld 1.ogg")
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|2;g=2.7")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|2;g=2.7")
			Audio.MusicChange(2, "_OST/Modern Mario/Overworld 1.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|9;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|1;g=2.4")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Modern Mario/Overworld 1.ogg")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(1, "_OST/Princess Rescue/Underground.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Princess Rescue/Underground.ogg")
			Audio.MusicChange(2, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(3, "_OST/Princess Rescue/Underground.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Princess Rescue/Overworld.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "SMB0" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 0/Overworld1.ogg")
			Audio.MusicChange(1, "_OST/Super Mario Bros 0/Underground.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 0/Underground.ogg")
			Audio.MusicChange(2, "_OST/Super Mario Bros 0/Overworld1.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Bros 0/Bonus.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 0/Overworld1.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "SMG4" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Smash Bros. Ultimate/Mario/a63_3dw_field01.ogg")
			Audio.MusicChange(1, "_OST/Super Smash Bros. Ultimate/Mario/a04_lnd_chika.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Smash Bros. Ultimate/Mario/a04_lnd_chika.ogg")
			Audio.MusicChange(2, "_OST/Super Smash Bros. Ultimate/Mario/a63_3dw_field01.ogg")
			Audio.MusicChange(3, "_OST/Super Smash Bros. Ultimate/Mario/a04_lnd_chika.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Smash Bros. Ultimate/Mario/a67_sm64_slider.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/South Park (N64)/The Theme.ogg")
			Audio.MusicChange(1, "_OST/South Park (N64)/Caves of South Park.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/South Park (N64)/Caves of South Park.ogg")
			Audio.MusicChange(2, "_OST/South Park (N64)/The Theme.ogg")
			Audio.MusicChange(3, "_OST/South Park (N64)/Caves of South Park.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/South Park (N64)/Insane Toys.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "__OST/South Park (N64)/Insane Toys.ogg")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/109 Underground.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/109 Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/109 Underground.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		end
	end
	
	
	
	
	
	
	--CHARACTER_LUIGI
	if currentCostume == "0-SPENCEREVERLY" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros Spencer/Overworld.ogg")
			Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Caves.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Ice Cream Desert (Underground).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Bros Spencer/Overworld.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Bros Spencer/Caves.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros Spencer/Athletic.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "3-SMB1-RETRO-MODERN" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|1;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros (NES) - OST.nsf|1;g=2")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros (NES)/Athletic.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "4-SMB1-SMAS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "5-SMB2-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES)/Sky.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "6-SMB2-SMAS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "7-SMB3-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "10-SMW-ORIGINAL" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "11-SMW-PIRATE" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2")
			Audio.MusicChange(1, "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario World (NES, Pirate) - OST.nsf|10;g=2.2")
			Audio.MusicChange(2, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2.2")
			Audio.MusicChange(3, "_OST/Super Mario World (Pirate)/Bonus.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "13-SMBDX" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "14-SMA1" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "15-SMA2" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "16-SMA4" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Advance 4/Underground Level.ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance 4/Bonus Level.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "17-NSMBDS-SMBX" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Bonus Stage.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "18-NSMBDS-ORIGINAL" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Bonus Stage.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Mushroom Waltz.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "A2XT-IRIS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(3, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/humble_down_theroad.mod")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5")
		end
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(1, "_OST/VeggieTales/Big Things Too.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/VeggieTales/Big Things Too.ogg")
			Audio.MusicChange(2, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(3, "_OST/VeggieTales/Big Things Too.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/VeggieTales/The Hairbrush Song.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "UNDERTALE-FRISK" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "WALUIGI" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	
	
	
	
	
	
	
	--CHARACTER_PEACH
	if currentCostume == "2P-SMB1-SMAS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "3-SMB2-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES)/Sky.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "4-SMB3-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "5-SMB3-SMAS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
	end
	if currentCostume == "A2XT-KOOD" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(3, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/humble_down_theroad.mod")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5")
		end
	end
	if currentCostume == "DAISY" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "KIRBY-SMB3" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2")
			Audio.MusicChange(1, "_OST/Kirby Superstar/14 White Wing Dynablade.spc|0;g=2.1")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Kirby Superstar/18 Cocoa Cave.spc|0;g=2.1")
			Audio.MusicChange(2, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2")
			Audio.MusicChange(3, "_OST/Kirby Superstar/14 White Wing Dynablade.spc|0;g=2.1")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Kirby Superstar/16 Peanut Plain.spc|0;g=2.4")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2")
		end
	end
	if currentCostume == "PAULINE" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	
	
	
	
	
	
	
	--CHARACTER_TOAD
	if currentCostume == "2-SMB1-SMAS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "3-SMB2-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES)/Sky.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "4-SMB2-RETRO-YELLOW" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES)/Sky.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "5-SMB2-RETRO-RED" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|3")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES)/Sky.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "6-SMB3-BLUE" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "7-SMB3-YELLOW" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "A2XT-RAOCOW" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(3, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/humble_down_theroad.mod")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5")
		end
	end
	if currentCostume == "SEE-TANGENT" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Nintendogs/Overworld.ogg")
			Audio.MusicChange(1, "_OST/Nintendogs/Underground.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Nintendogs/Underground.ogg")
			Audio.MusicChange(2, "_OST/Nintendogs/Overworld.ogg")
			Audio.MusicChange(3, "_OST/Nintendogs/Underground.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Nintendogs/Athletic.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "SONIC" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Sonic Mania/GreenHill1.ogg")
			Audio.MusicChange(1, "_OST/Sonic Mania/FlyingBattery1.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Sonic Mania/FlyingBattery1.ogg")
			Audio.MusicChange(2, "_OST/Sonic Mania/GreenHill1.ogg")
			Audio.MusicChange(3, "_OST/Sonic Mania/FlyingBattery1.ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Sonic Mania/GreenHill2.ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Sonic Mania/GreenHill2.ogg")
		end
	end
	if currentCostume == "TOADETTE" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "YOSHI-SMB3" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	
	
	
	
	
	
	
	
	
	--CHARACTER_LINK
	if currentCostume == "1-LOZ1-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/The Legend of Zelda (NES) - OST.nsf|2;g=2")
			Audio.MusicChange(1, "_OST/The Legend of Zelda (NES) - OST.nsf|2;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "2-ZED2-RETRO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Zelda II - The Adventure of Link (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(1, "_OST/Zelda II - The Adventure of Link (NES) - OST.nsf|1;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "3-LINKPAST-SNES" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.4")
			Audio.MusicChange(1, "_OST/Legend of Zelda - A Link to the Past/13 Dank Dungeons.spc|0;g=2.1")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "4-LINKWAKE-GBC" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/The Legend of Zelda - Link's Awakening DX (GBC) - OST.gbs|4;g=1.9")
			Audio.MusicChange(1, "_OST/The Legend of Zelda - Link's Awakening DX (GBC) - OST.gbs|8;g=2.2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "5-LINKWAKE-SNES" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Legend of Zelda - Link's Awakening (Switch)/10_Field_Normal.ry.48.dspadpcm.ogg")
			Audio.MusicChange(1, "_OST/Legend of Zelda - Link's Awakening (Switch)/12_StrangeForest.ry.48.dspadpcm.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "6-4SWORDS-RED" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
			Audio.MusicChange(1, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "7-4SWORDS-GREEN" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
			Audio.MusicChange(1, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "8-4SWORDS-BLUE" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
			Audio.MusicChange(1, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "9-4SWORDS-PURPLE" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
			Audio.MusicChange(1, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "10-4SWORDS-YELLOW" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
			Audio.MusicChange(1, "_OST/Legend of Zelda - Four Swords Adventures/bgm_stage1_L.ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "A2XT-SHEATH" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Adventures of Demo/analysis-8.mod")
			Audio.MusicChange(3, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/humble_down_theroad.mod")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5")
		end
	end
	if currentCostume == "NESS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/EarthBound/019b Onett Theme.spc|0;g=2.1")
			Audio.MusicChange(1, "_OST/EarthBound/039 Dangerous Caves.spc|0;g=2.1")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/EarthBound/030 Battle Against a Weak Opponent.spc|0;g=2.1")
			Audio.MusicChange(2, "_OST/EarthBound/019b Onett Theme.spc|0;g=2.1")
			Audio.MusicChange(3, "_OST/EarthBound/030 Battle Against a Weak Opponent.spc|0;g=2.1")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/EarthBound/052a Peaceful Rest Valley.spc|0;g=2.1")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/EarthBound/019b Onett Theme.spc|0;g=2.1")
		end
	end
	if currentCostume == "SMB2-SNES" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "SMB3-BANDANA-DEE" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2")
			Audio.MusicChange(1, "_OST/Kirby Superstar/14 White Wing Dynablade.spc|0;g=2.1")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Kirby Superstar/18 Cocoa Cave.spc|0;g=2.1")
			Audio.MusicChange(2, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2")
			Audio.MusicChange(3, "_OST/Kirby Superstar/14 White Wing Dynablade.spc|0;g=2.1")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Kirby Superstar/16 Peanut Plain.spc|0;g=2.4")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.2")
		end
	end
	if currentCostume == "TAKESHI" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(1, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(2, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "TAKESHI-SNES" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(1, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(2, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(3, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	
	
	
	
	
	
	
	--CHARACTER_MEGAMAN
	if currentCostume == "BASS" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	if currentCostume == "PROTOMAN" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	
	
	
	
	
	
	
	--CHARACTER_WARIO
	if currentCostume == "SMB3-WARIO" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
	
	
	
	
	
	
	--CHARACTER_NINJABOMBERMAN
	if currentCostume == "WALUIGI-SMB3" then
		if level == "SMB1 - W-1, L-1.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(1, "_OST/Super Mario Bros/Bonus.spc|0;g=2.6")
		end
		if level == "SMB1 - W-1, L-2.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Underground.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
		end
		if level == "SMB1 - W-1, L-3.lvlx" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		end
		if level == "SMB1 - W-1, L-4.lvlx" then
			Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		end
	end
end








--The next stuff is for events that do change music, since onTick overwrites event music stuff









function musicalchairs.onEvent(eventName)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	
	
	
	
	--Event transitions, from castle music to anything else
	
	
	
	
	
	if currentCostume == nil then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.5")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	
	
	
	
	--CHARACTER_MARIO
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario All-Stars++ (Beta)/Going Underground SFX.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/Castle.ogg")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/SMBDDX - Bowser Battle.ogg")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario All-Stars++ (Beta)/Clear! (SFX).ogg")
			end
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros (NES) - OST.nsf|10;g=2")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros (NES) - OST.nsf|6;g=2")
			end
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros 2 (NES)/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES)/Castle.ogg")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros 2 (NES) - OST.nsf|11;g=2")
			end
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros 3 (NES)/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros 3 (NES) - OST.nsf|28;g=2")
			end
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Advance 4/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Advance/Castle.ogg")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Advance/Boss.ogg")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Advance/Boss Cleared.ogg")
			end
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Advance 4/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Castle.ogg")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Advance 2/Boss Battle.ogg")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Advance 2/Fortress Clear.ogg")
			end
		end
	end
	if currentCostume == "13-SMA4" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Advance 4/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Castle.ogg")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Advance 2/Boss Battle.ogg")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Advance 4/Fortress Clear (SFX).ogg")
			end
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Castle Boss.ogg")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/New Super Mario Bros. DS/gameClear.ogg")
			end
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Adventures of Demo/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/time_is_running.spc|0;g=2.5")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/aws_spac.xm")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Adventures of Demo/Game Beat!.ogg")
			end
		end
	end
	if currentCostume == "GA-CAILLOU" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/GoAnimate/Going Underground (SFX).ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/GoAnimate/Old Songs/Melancholy - Somber.mp3")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/GoAnimate/Old Songs/Rock & Roll.mp3")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("costumes/mario/GA-Caillou/got-star-catchsfx.ogg")
			end
		end
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/JC Foster Takes it to the Moon/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/JC Foster Takes it to the Moon/Mario & Luigi - Partners in Time - Dark Dungeons.spc|0;g=2.2")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "MARINK" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "MODERN" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|4;g=2.7")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|6;g=2.7")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/The Legend of Zelda (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|22;g=2")
			end
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Princess Rescue/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Princess Rescue/Underground.ogg")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				--Nothing happens
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Princess Rescue/Course Clear!.ogg")
			end
		end
	end
	if currentCostume == "SMW-MARIO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/South Park/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/South Park (N64)/Mad Robots.ogg")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/South Park (N64)/South Park Boss Encounter.ogg")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/South Park/Banjo Lick (SFX).ogg")
			end
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario World 2 - Yoshi's Island/118b Big Boss (No Intro).spc|0;g=2.3")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario World 2 - Yoshi's Island/119 Big Boss Clear.spc|0;g=2.5")
			end
		end
	end
	
	
	
	
	--CHARACTER_LUIGI
	if currentCostume == "0-SPENCEREVERLY" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "3-SMB1-RETRO-MODERN" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "4-SMB1-SMAS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "5-SMB2-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "6-SMB2-SMAS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "7-SMB3-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "9-SMB3-MARIOCLOTHES" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "10-SMW-ORIGINAL" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "11-SMW-PIRATE" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "13-SMBDX" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "14-SMA1" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "15-SMA2" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "16-SMA4" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "17-NSMBDS-SMBX" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "18-NSMBDS-ORIGINAL" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "A2XT-IRIS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Adventures of Demo/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/time_is_running.spc|0;g=2.5")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/aws_spac.xm")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Adventures of Demo/Game Beat!.ogg")
			end
		end
	end
	if currentCostume == "LARRYTHECUCUMBER" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "UNDERTALE-FRISK" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "WALUIGI" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	
	
	
	
	
	--CHARACTER_PEACH
	if currentCostume == "2P-SMB1-SMAS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "3-SMB2-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "4-SMB3-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "5-SMB3-SMAS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "A2XT-KOOD" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Adventures of Demo/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/time_is_running.spc|0;g=2.5")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/aws_spac.xm")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Adventures of Demo/Game Beat!.ogg")
			end
		end
	end
	if currentCostume == "DAISY" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "KIRBY-SMB3" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Kirby Superstar/23 Dynablade's Nest.spc|0;g=2.1")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Kirby Superstar/26 Crash! Gourmet Race.spc|0;g=2.1")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "PAULINE" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	
	
	
	
	
	
	--CHARACTER_TOAD
	if currentCostume == "2-SMB1-SMAS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "3-SMB2-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "4-SMB2-RETRO-YELLOW" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "5-SMB2-RETRO-RED" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "6-SMB3-BLUE" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "7-SMB3-YELLOW" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "A2XT-RAOCOW" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Adventures of Demo/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/time_is_running.spc|0;g=2.5")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/aws_spac.xm")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Adventures of Demo/Game Beat!.ogg")
			end
		end
	end
	if currentCostume == "SEE-TANGENT" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "SONIC" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Sonic Mania/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Sonic Mania/FlyingBattery2.ogg")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Sonic Mania/BossEggman1.ogg")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Sonic Mania/ActClearSFX.ogg")
			end
		end
	end
	if currentCostume == "TOADETTE" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "YOSHI-SMB3" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	
	
	
	
	
	
	
	
	
	--CHARACTER_LINK
	if currentCostume == "1-LOZ1-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "2-ZED2-RETRO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "3-LINKPAST-SNES" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "4-LINKWAKE-GBC" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "5-LINKWAKE-SNES" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "6-4SWORDS-RED" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "7-4SWORDS-GREEN" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "8-4SWORDS-BLUE" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "9-4SWORDS-PURPLE" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "10-4SWORDS-YELLOW" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "A2XT-SHEATH" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Adventures of Demo/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/time_is_running.spc|0;g=2.5")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Adventures of Demo/aws_spac.xm")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Adventures of Demo/Game Beat!.ogg")
			end
		end
	end
	if currentCostume == "NESS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "SMB2-SNES" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "SMB3-BANDANA-DEE" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Kirby Superstar/23 Dynablade's Nest.spc|0;g=2.1")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Kirby Superstar/26 Crash! Gourmet Race.spc|0;g=2.1")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "TAKESHI" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "TAKESHI-SNES" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	
	
	
	
	
	
	
	--CHARACTER_MEGAMAN
	if currentCostume == "BASS" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	if currentCostume == "PROTOMAN" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	
	
	
	
	
	
	
	--CHARACTER_WARIO
	if currentCostume == "SMB3-WARIO" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
	
	
	
	
	
	
	--CHARACTER_NINJABOMBERMAN
	if currentCostume == "WALUIGI-SMB3" then
		if eventName == "Level - Start" then
			if level == "SMB1 - W-1, L-2.lvlx" then
				SFX.play("_OST/Super Mario Bros/Going Underground.ogg")
			end
		end
		if eventName == "CostChangeMusic" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
			end
		end
		if eventName == "Boss Start" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
			end
		end
		if eventName == "Boss End" then
			if level == "SMB1 - W-1, L-4.lvlx" then
				SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
			end
		end
	end
end
	
	


return musicalchairs

---------X2 SOUND REPLACING---------

--atm idk how to make it work. Coming whenever I do fix the issue though



---------GRAPHIC REPLACING---------

-----Sprite Override-----

--Coming soon--