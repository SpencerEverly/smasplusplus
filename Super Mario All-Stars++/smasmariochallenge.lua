local rng = require("rng")
local lunajson = require("ext/lunajson")
local pm = require("playerManager")
local imagic = require("imagic");
local pausemenu2 = require("pausemenu2")

local smasmariochallenge = {}

local EP_LIST_PTR = mem(0x00B250FC, FIELD_DWORD)
local EP_LIST_COUNT = mem(0x00B250E8, FIELD_WORD)
local currentEpisodeIndex = mem(0x00B2C628, FIELD_WORD)

local rerollCount = 150;

local levelsPlayed = {}
local fullLevelList;

local topEpisodeName = "Super Mario All-Stars++"
local introLevel = "mariochallenge_hub.lvlx"
local datapath = "\\worlds\\Super Mario All-Stars++\\smasmc_data.json"

Graphics.sprites.Register("mariochallenge", "mariochallenge-rerolls")
Graphics.sprites.Register("mariochallenge", "mariochallenge-stages")
Graphics.sprites.Register("mariochallenge", "mariochallenge-lives")
Graphics.sprites.Register("mariochallenge", "mariochallenge-timer")
Graphics.sprites.Register("mariochallenge", "mariochallenge-congrats")
Graphics.sprites.Register("mariochallenge", "mariochallenge-results")
Graphics.sprites.Register("mariochallenge", "mariochallenge-deathmark")
Graphics.sprites.Register("mariochallenge", "mariochallenge-deathmark-large")


Graphics.sprites.Register("mariochallenge", "mariochallenge-mode-ohko")
Graphics.sprites.Register("mariochallenge", "mariochallenge-mode-slippery")
Graphics.sprites.Register("mariochallenge", "mariochallenge-mode-rinka")
Graphics.sprites.Register("mariochallenge", "mariochallenge-mode-mirror")
Graphics.sprites.Register("mariochallenge", "mariochallenge-mode-oneshot")

local audio_hurryup;

local mode_images;

local firstFrame = true;
local earlyDeathCheck = 3;

local dying = false;
local deathVisibleCount = 210;
local deathTimer = deathVisibleCount;

local lastWinState = 0;

local mcData;

--Holds all data that will be held between levels
local mcTable = {};
local mcDeathTable = {};
local activated = false;

local default_levels = 5;
local default_lives = 10;
local default_rerolls = 5;

local isIntro
local timer
local selectKeyDown
local defs
local textplus
local mainfont
local inputs;
local inputs2;

local timer_deathTimer;
local timer_initscore;
local timer_hurry;

local rinka_exclude;
local rinka_counter;

local mirror_capture;

local oneshot_buffer;

local function readData()
	local f = io.open(getSMBXPath()..datapath, "r");
	if(f == nil) then return {}; end
	local content = f:read("*all");
    f:close();
	if(content ~= "") then
		return lunajson.decode(content);
	else
		return {};
	end
end

local function writeData(data)
	local f = io.open(getSMBXPath()..datapath, "w");

	f:write(lunajson.encode(data));
	f:flush();
	f:close();
end

function Misc.inMarioChallenge()
	return activated;
end

function smasmariochallenge.getConfigRerolls()
	return mcTable.config_rerolls;
end

function smasmariochallenge.setConfigRerolls(newValue)
	mcTable.config_rerolls = newValue;
	mcTable.rerolls = mcTable.config_rerolls;
end

function smasmariochallenge.resetConfigRerolls()
	smasmariochallenge.setConfigRerolls(default_rerolls);
end


function smasmariochallenge.getConfigLives()
	return mcTable.config_lives;
end

function smasmariochallenge.setConfigLives(newValue)
	mcTable.config_lives = newValue;
end

function smasmariochallenge.resetConfigLives()
	smasmariochallenge.setConfigLives(default_lives);
end


function smasmariochallenge.getConfigLevels()
	return mcTable.config_levels;
end

function smasmariochallenge.setConfigLevels(newValue)
	mcTable.config_levels = newValue;
end

function smasmariochallenge.resetConfigLevels()
	smasmariochallenge.setConfigLevels(default_levels);
end


function smasmariochallenge.getModeShuffle()
	return mcTable.mode_shuffle;
end
function smasmariochallenge.setModeShuffle(newValue)
	mcTable.mode_shuffle = newValue;
end

function smasmariochallenge.getModeSlippery()
	return mcTable.mode_slippery;
end
function smasmariochallenge.setModeSlippery(newValue)
	mcTable.mode_slippery = newValue;
end

function smasmariochallenge.getModeTimer()
	return mcTable.mode_timer;
end
function smasmariochallenge.setModeTimer(newValue)
	mcTable.mode_timer = newValue;
end

function smasmariochallenge.getModeOHKO()
	return mcTable.mode_onehit;
end
function smasmariochallenge.setModeOHKO(newValue)
	mcTable.mode_onehit = newValue;
end

function smasmariochallenge.getModeRinka()
	return mcTable.mode_rinka;
end
function smasmariochallenge.setModeRinka(newValue)
	mcTable.mode_rinka = newValue;
end

function smasmariochallenge.getModeMirror()
	return mcTable.mode_mirror;
end
function smasmariochallenge.setModeMirror(newValue)
	mcTable.mode_mirror = newValue;
end

function smasmariochallenge.getModeOneshot()
	return mcTable.mode_oneshot;
end
function smasmariochallenge.setModeOneshot(newValue)
	mcTable.mode_oneshot = newValue;
end

local function cleanUp()
	mcTable = {}
end

local function isIntroLevel()
	return not isOverworld and mcTable.currentLevel.episodeName == topEpisodeName and Level.filename() == introLevel;
end

local function initCostumes()
	for i=1,18 do
		local c = mcTable.costumes[i];
		if(c == "") then
			c = nil;
		end
		pm.setCostume(i, nil, true);
		pm.setCostume(i, c, true);
	end
end

local function refreshData()
		mcTable = {};
		
		mcTable.config_levels = default_levels;
		mcTable.config_rerolls = default_rerolls;
		mcTable.config_lives = default_lives;
		
		mcTable.playIndex = -2; -- 2 means loading up a new Mario Challenge
		mcTable.isIntro = true;
		mcTable.loadInProgress = true;
		mcTable.rerolls = mcTable.config_rerolls;
		mcTable.rerollCounter = 0;
		mcTable.hasWon = false;
		mcTable.hasLost = false;
		mcTable.hubLocation = 1;
		mcTable.levelsPlayed = {};
		mcTable.deaths = 0;
		mcTable.startingDeaths = 0;
		mcTable.hasSeenText = false;
		mcTable.currentLevel = {episodeNumber=1,levelFile="",episodeName=topEpisodeName};
		mcTable.character = CHARACTER_MARIO;
		
		mcTable.costumes = {};
		for i=1,18 do
			local c = pm.getCostumeFromData(i);
			if(c == nil) then
				c = "";
			end
			mcTable.costumes[i] = c;
		end
		
		mcTable.mode_shuffle = false;
		mcTable.mode_slippery = false;
		mcTable.mode_timer = false;
		mcTable.mode_onehit = false;
		mcTable.mode_rinka = false;
		mcTable.mode_mirror = false;
		mcTable.mode_oneshot = false;
end

local function initData()
	local t = mcData.data;
	if(t == nil or mem(0x00B2C62A, FIELD_WORD) == 0) then
		--Set values for new Mario Challenge run here
		refreshData();
	else
		mcTable = t;
	end
	
	isIntro = mcTable.isIntro;
	mcTable.isIntro = false;
	
	mcData.data = nil;
	writeData(mcData);
	
	if(mcData.deaths == nil) then
		mcData.deaths = {};
	end
	local deathmarks = mcData.deaths[mcTable.currentLevel.episodeName..":"..mcTable.currentLevel.levelFile];
	if(deathmarks == nil) then
		mcDeathTable = {};
	else
		mcDeathTable = deathmarks;
	end
	
	if(isIntroLevel()) then
		local settings = mcData.settings;
		if(settings ~= nil and settings ~= {}) then
			local settingstable = settings;
			if(settingstable.levels ~= nil) then
				smasmariochallenge.setConfigLevels(settingstable.levels);
			end
			if(settingstable.lives ~= nil) then
				smasmariochallenge.setConfigLives(settingstable.lives);
			end
			if(settingstable.rerolls ~= nil) then
				smasmariochallenge.setConfigRerolls(settingstable.rerolls);
			end
			if(settingstable.mode_shuffle ~= nil) then
				smasmariochallenge.setModeShuffle(settingstable.mode_shuffle);
			end
			if(settingstable.mode_onehit ~= nil) then
				smasmariochallenge.setModeOHKO(settingstable.mode_onehit);
			end
			if(settingstable.mode_rinka ~= nil) then
				smasmariochallenge.setModeRinka(settingstable.mode_rinka);
			end
			if(settingstable.mode_slippery ~= nil) then
				smasmariochallenge.setModeSlippery(settingstable.mode_slippery);
			end
			if(settingstable.mode_timer ~= nil) then
				smasmariochallenge.setModeTimer(settingstable.mode_timer);
			end
			if(settingstable.mode_mirror ~= nil) then
				smasmariochallenge.setModeMirror(settingstable.mode_mirror);
			end
			if(settingstable.mode_oneshot ~= nil) then
				smasmariochallenge.setModeOneshot(settingstable.mode_oneshot);
			end
		end
	end
end

local function flushData()
	if(isIntroLevel()) then
		local settings =
		{
			levels = mcTable.config_levels,
			lives = mcTable.config_lives,
			rerolls = mcTable.config_rerolls,
			mode_onehit = mcTable.mode_onehit,
			mode_rinka = mcTable.mode_rinka,
			mode_shuffle = mcTable.mode_shuffle,
			mode_slippery = mcTable.mode_slippery,
			mode_timer = mcTable.mode_timer,
			mode_mirror = mcTable.mode_mirror,
			mode_oneshot = mcTable.mode_oneshot
		}
		mcData.settings = settings;
		
		for i=1,18 do
			local c = pm.getCostume(i);
			if(c == nil) then
				c = "";
			end
			mcTable.costumes[i] = c;
		end
	end
	mcData.data = mcTable;
	mcData.active = true;
	writeData(mcData);
end

local function fillScreen()
	--Graphical irregularity can occur while loading new levels, so cover it in black so we can't see it.
	Graphics.glDraw{vertexCoords ={0,0,800,0,800,600,0,600}, color={0,0,0,1},primitive=Graphics.GL_TRIANGLE_FAN,priority=10};
end

local function checkForExclusion(fileList)
	if(fileList == nil) then
		return true;
	end
	for _, file in pairs(fileList) do
		file = file:lower();
		if string.match(file, "^excludefrommariochallenge") or string.match(file, "^nomariochallenge") then
			return false;
		end
	end
	return true;
end

local function getFullLevelList()
	local episodeData = {}
	local finalList = {}
	local indexer = 1
	episodeData[indexer] = {}
	episodeData[indexer].episodeName = "Super Mario All-Stars++"
	episodeData[indexer].episodePath = tostring(mem(mem(0x00B250FC, FIELD_DWORD) + ((mem(0x00B250E8, FIELD_WORD) - 1) * 0x18) + 0x4, FIELD_STRING))
	if episodeData[indexer].episodeName == topEpisodeName then
		mcTable.hubLocation = indexer;
	end
	if(mcTable.levelData == nil) then
		local episodeFiles = Misc.listFiles(episodeData[indexer].episodePath);
		local doEpisode = checkForExclusion(episodeFiles);
		if(doEpisode) then
			for _, file in pairs(episodeFiles) do
				if string.match(file, "%.lvlx?$") and episodeData[indexer].episodeName ~= topEpisodeName then
					if(checkForExclusion(Misc.listFiles(episodeData[indexer].episodePath .. file:sub(1,-5)))) then
						
						local headerData = FileFormats.openLevelHeader(episodeData[indexer].episodePath .. file)
						if headerData.meta and headerData.meta.isValid and (headerData.data.showInMarioChallenge ~= false --[[include if field isn't present]]) then
							table.insert(finalList, {episodeNumber = indexer, levelFile = file, episodeName = episodeData[indexer].episodeName})
						end
					end
				end
			end
		end
	end
	if(mcTable.levelData == nil) then
		mcTable.levelData = finalList;
	else
		finalList = mcTable.levelData;
	end
	return finalList
end

function smasmariochallenge.forceUpdateLevelList()
	mcTable.levelData = nil;
	getFullLevelList()
end

function smasmariochallenge.LevelCount()
	if(mcTable.levelData == nil) then
		getFullLevelList();
	end
	return #smastables.__allLevels;
end


local function loadNextLevel(dontIncrement)
	if(dontIncrement == nil) then
		dontIncrement = false;
	end
	if not dontIncrement and mcTable.config_levels > 0 and mcTable.playIndex >= mcTable.config_levels then
		mcTable.hasWon = true;
		Level.load("mariochallenge_victory.lvlx")
	elseif not dontIncrement and mcTable.hasLost then
		refreshData();
		mcTable.character = player.character;
		mcData.data = mcTable;
		writeData(mcData);
		Level.load(introLevel, nil, 4);
	else	
		if(not dontIncrement) then
			mcTable.playIndex = mcTable.playIndex + 1;
		end
		
		if(not isOverworld) then
			mcTable.levelsPlayed[mcTable.currentLevel.episodeName..":"..Level.filename()] = true;
		end
		
		mcTable.hasSeenText = false;
		mcTable.startingDeaths = mcTable.deaths;
		
		fullLevelList = getFullLevelList();
		local levelList = {};
		
		local i = 1;
		for _,v in ipairs(fullLevelList) do
			if(not mcTable.levelsPlayed[v.episodeName..":"..v.levelFile]) then
				table.insert(levelList, v);
			end
		end
		
		if(#levelList == 0) then
			mcTable.levelsPlayed = {}
			levelList = fullLevelList;
		end
		
		local nextData = rng.irandomEntry(levelList);
		
		mcTable.currentLevel = nextData;
		
		Level.load(smastables.__allMandatoryLevels[rng.randomInt(1,#smastables.__allMandatoryLevels)])
	end
end

local function isWinning()
	if tostring(mem(EP_LIST_PTR + (currentEpisodeIndex - 1) * 0x18 + 0x0, FIELD_STRING)) == topEpisodeName and not mcTable.hasWon and not mcTable.hasLost then
		return true
	else
		return false
	end
end

local shouldLoadIntroAgain = false;
function smasmariochallenge.reloadIntro()
	mcData.active = nil;
	refreshData();
	mcTable.character = player.character;
	mcData.data = mcTable;
	writeData(mcData)
	Level.load(introLevel, nil, 4);
	shouldLoadIntroAgain = true;
end

function smasmariochallenge.onExitLevel(winState)
	Cheats.reset();
	if(shouldLoadIntroAgain) then
		return;
	end
	
	if (not isOverworld) then
		if winState > 0 then
			mcTable.levelsPlayed[mcTable.currentLevel.episodeName..":"..Level.filename()] = true;
		end
		
		if (((mcTable.hasWon and Level.filename() == "mariochallenge_victory.lvlx") or (mcTable.hasLost and Level.filename() == "mariochallenge_results.lvlx"))) then
			local shouldwin = (mcTable.hasWon and Level.filename() == "mariochallenge_victory.lvlx");
			refreshData();
			mcTable.character = player.character;
			mcTable.justWon = shouldwin;
			
			mcData.data = mcTable;
			writeData(mcData)
			return;
		end
	end
	
	if(isIntroLevel()) then
		mcTable.character = player.character;
	end
	
	if not isOverworld then
		if(mcTable.mode_shuffle) then
			mcTable.character = rng.randomInt(1,#pm.getCharacters());
		end
		
		
		pcall(Player.transform, player, mcTable.character);
	end
	-- Flush our local data back to the data file before warping
	flushData();
end

local function drawValue(x,y,val,priority)
		priority = priority or -4.2;
		if(val == -1) then
			Graphics.draw{type = RTYPE_IMAGE, x=x, y=y, image=Graphics.sprites.hardcoded["50-11"].img, priority=priority};
		else
			local text = tostring(val);
			Graphics.draw{type = RTYPE_TEXT, x=x+18-(18*#text), y=y+1, text=text, fontType = 1, priority=priority};
		end
end

local function drawUI(x, y, image, firstVal, secondVal)
		
		Graphics.draw{type = RTYPE_IMAGE, x=x-32, y=y, image=image, priority=-4.2};
		Graphics.draw{type = RTYPE_IMAGE, x=x-8, y=y+1, image=Graphics.sprites.hardcoded["33-1"].img, priority=-4.2};
		
		if(secondVal ~= nil) then
			local slashx = x+118-#tostring(secondVal)*18;
			Graphics.draw{type = RTYPE_IMAGE, x=slashx, y=y, image=Graphics.sprites.hardcoded["50-10"].img, priority=-4.2};
			drawValue(slashx-18,y,firstVal);
		else
			secondVal = firstVal;
		end
		drawValue(x+118,y,secondVal);
end

local function getLevelName()
	local levelname = Level.name();
	if levelname == nil or levelname == "" then
		levelname = string.sub(Level.filename(), 0, -5);
	end
	return mcTable.currentLevel.episodeName .. "<br>" .. levelname;
end

local function drawLevelName()
	local levelname = getLevelName();
	local lineCount = math.ceil(#levelname / 44)
	
	mainfont.text = levelname
	mainfont.x = 16
	mainfont.y = 584
	mainfont.maxWidth = 600
	mainfont.pivot = {0,1}
	textplus.print(mainfont)
	--textblox.printExt(levelname, {x = 16, y = 584, width=600, font = textblox.FONT_SPRITEDEFAULT3X2, halign = textblox.HALIGN_LEFT, valign = textblox.VALIGN_BOTTOM, z=10})
end

local victoryTimer = 0;

local function drawVictoryStat(x,y,image,text,value,priority)
		priority = priority or -4;
		Graphics.draw{type = RTYPE_IMAGE, x=x, y=y, image=image, priority=priority};
		
		
		mainfont.text = ":"
		mainfont.x = x+16
		mainfont.y = y
		mainfont.maxWidth = 780
		mainfont.pivot = {0,0}
		textplus.print(mainfont)
		
		--textblox.printExt(":", {x=x+16, y=y, width = 780, font = textblox.FONT_SPRITEDEFAULT3X2, halign = textblox.HALIGN_LEFT, valign = textblox.VALIGN_TOP, z=priority})
		
		drawValue(x+16+(18*2),y,value,priority);
		
		mainfont.text = text
		mainfont.x = x+16+(18*4)
		mainfont.y = y
		mainfont.maxWidth = 780
		mainfont.pivot = {0,0}
		textplus.print(mainfont)
		--textblox.printExt(text, {x=x+16+(18*4), y=y, width = 780, font = textblox.FONT_SPRITEDEFAULT3X2, halign = textblox.HALIGN_LEFT, valign = textblox.VALIGN_TOP, z=priority})
end

local function drawVictoryStats(stagesOffset, x, y, iconstop, priority)
	priority = priority or -4;
	drawVictoryStat(x-140, y, Graphics.sprites.mariochallenge["stages"].img, "stages cleared", math.max(0, mcTable.playIndex + stagesOffset), priority);
	drawVictoryStat(x-140, y+30, Graphics.sprites.mariochallenge["rerolls"].img, "rerolls", mcTable.rerollCounter, priority);
	drawVictoryStat(x-140, y+60, Graphics.sprites.mariochallenge["lives"].img, "deaths", mcTable.deaths, priority);
	
	local modelist = {}
	for _,v in ipairs(mode_images) do
		if(v.active()) then
			table.insert(modelist,v.img.img);
		end
	end
	
	x = x-(10*#modelist);
	if(iconstop) then
		y = y-30;
	else
		y = y + 90;
	end
	for k,v in ipairs(modelist) do
		Graphics.draw{type = RTYPE_IMAGE, x=x+20*(k-1), y=y, image=v, priority=priority};
	end
	
end

local function drawVictory()
	local maxtimer = 200;
	if(victoryTimer < maxtimer) then
		victoryTimer = victoryTimer + 1;
	end
	local x = 400;
	local y = 140-96;
	local img = Graphics.sprites.mariochallenge["congrats"].img
	local w = img.width*0.5;
	local h = img.height;
	Graphics.glDraw{vertexCoords={x-w,y,x+w,y,x+w,y+h,x-w,y+h}, primitive=Graphics.GL_TRIANGLE_FAN, textureCoords={0,0,1,0,1,1,0,1}, texture = img, color = {1,1,1,victoryTimer/maxtimer}, priority=-4.1};
	
	--textblox.printExt("You beat the Mario Challenge!", {y = y+64, width = 780, font = textblox.FONT_SPRITEDEFAULT3X2, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_BOTTOM, z=5})
	
	drawVictoryStats(0, 400, y+80, false, 4.999);
	
end

local function drawResults()
	local maxtimer = 200;
	if(victoryTimer < maxtimer) then
		victoryTimer = victoryTimer + 1;
	end
	
	local x = 240--400;
	if(mcTable.mode_mirror) then
		x = 800-x;
	end
	
	local y = 200--100;
	local img = Graphics.sprites.mariochallenge["results"].img
	local w = img.width*0.5;
	local h = img.height;
	Graphics.glDraw{vertexCoords={x-w,y,x+w,y,x+w,y+h,x-w,y+h}, primitive=Graphics.GL_TRIANGLE_FAN, textureCoords={0,0,1,0,1,1,0,1}, texture = img, color = {1,1,1,victoryTimer/maxtimer}, priority=-4.1};
	
	--textblox.printExt("", {y = y+216, width = 780, font = textblox.FONT_SPRITEDEFAULT3X2, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_BOTTOM, z=10})
	
	drawVictoryStats(-1, x, y+80, true, 4.999);
end

local deathmarkDrawData;

local function DrawDeathMarks(a)
	local img = Graphics.sprites.mariochallenge["deathmark"].img
	if(deathmarkDrawData == nil) then
		local halfwid = img.width*0.5;
		local hei = img.height;
		deathmarkDrawData = {verts = {}, uvs = {}};
		for k,v in ipairs(mcDeathTable) do
			if(k == #mcDeathTable) then
				--Skip the last element - it's actually our current death!
				break;
			end
			table.insert(deathmarkDrawData.verts, v.x-halfwid);
			table.insert(deathmarkDrawData.verts, v.y-hei);
			table.insert(deathmarkDrawData.uvs, 0);
			table.insert(deathmarkDrawData.uvs, 0);
			
			table.insert(deathmarkDrawData.verts, v.x+halfwid);
			table.insert(deathmarkDrawData.verts, v.y-hei);
			table.insert(deathmarkDrawData.uvs, 1);
			table.insert(deathmarkDrawData.uvs, 0);
			
			table.insert(deathmarkDrawData.verts, v.x-halfwid);
			table.insert(deathmarkDrawData.verts, v.y);
			table.insert(deathmarkDrawData.uvs, 0);
			table.insert(deathmarkDrawData.uvs, 1);
			
			table.insert(deathmarkDrawData.verts, v.x-halfwid);
			table.insert(deathmarkDrawData.verts, v.y);
			table.insert(deathmarkDrawData.uvs, 0);
			table.insert(deathmarkDrawData.uvs, 1);
			
			table.insert(deathmarkDrawData.verts, v.x+halfwid);
			table.insert(deathmarkDrawData.verts, v.y-hei);
			table.insert(deathmarkDrawData.uvs, 1);
			table.insert(deathmarkDrawData.uvs, 0);
			
			table.insert(deathmarkDrawData.verts, v.x+halfwid);
			table.insert(deathmarkDrawData.verts, v.y);
			table.insert(deathmarkDrawData.uvs, 1);
			table.insert(deathmarkDrawData.uvs, 1);
		end
	end
	
	--local a = (math.sin(lunatime.time())+0.5)*0.5;
	Graphics.glDraw{vertexCoords = deathmarkDrawData.verts, sceneCoords = true, textureCoords = deathmarkDrawData.uvs, primitive = Graphics.GL_TRIANGLES, texture = img, color = {1,1,1,a}, priority = -2};
end

local function RunDeathEvent()
	if(deathTimer > 0) then
		player:mem(0x13E, FIELD_WORD, 198);
		deathTimer = deathTimer-1;
		local alpha = 1 - deathTimer/deathVisibleCount;
		DrawDeathMarks((alpha)*50);
		local starty = camera.y;
		local bounds = Section(player.section).boundary;
		local targy = math.min(bounds.bottom, player.y + player.height);
		
		local t = math.min(1, math.max(0, alpha*12 - 0.25));
		
		local y = starty*(1-t) + targy*(t)
		
		local img = Graphics.sprites.mariochallenge["deathmark-large"].img
		Graphics.draw{type=RTYPE_IMAGE, image = img, x = player.x+(player.width-img.width-1)*0.5, y = y - img.height - 4, isSceneCoordinates = true, priority = -2}
	else
		mcTable.loadInProgress = true;
		if(mem(0x00B2C5AC, FIELD_FLOAT) > 0) then
			dying = false;
			if(mcTable.config_lives >= 0) then
				mem(0x00B2C5AC, FIELD_FLOAT, mem(0x00B2C5AC, FIELD_FLOAT) - 1)
			end
			Level.load(mcTable.currentLevel.levelFile)
		else
			mcTable.hasLost = true;
			Level.load("mariochallenge_results.lvlx")
		end
	end
end

local function shouldFillScreen()
	return firstFrame or (mcTable.loadInProgress);
end

function smasmariochallenge.onCameraDraw(idx)
	if(mcTable.mode_mirror and mirror_capture ~= nil and not isIntroLevel() and not isOverworld and not shouldFillScreen()) then

		local mirrorPriority = -5;
		local cam = Camera(idx);
		for _,v in ipairs(NPC.getIntersecting(cam.x,cam.y,cam.x+cam.width,cam.y+cam.height)) do
			if(v:mem(0x138,FIELD_WORD) == 2) then --Is an NPC dropped from the itembox
				if(v.animationFrame > 0) then
					if not v.isGenerator then
						v.data._basegame.mariochallenge.animframe = v.animationFrame;
					end
				end
				v.animationFrame = -1;
				if(v:mem(0x12A,FIELD_WORD) == 179) then
					local f = 0;
					if(not v.isGenerator and v.data._basegame and v.data._basegame.mariochallenge and v.data._basegame.mariochallenge.animframe) then
						f = v.data._basegame.mariochallenge.animframe;
					end
					
					local w = v:mem(0xC0,FIELD_DFLOAT);
					if(w == 0) then w = v.width; end
					local h = v:mem(0xB8,FIELD_DFLOAT);
					if(h == 0) then h = v.height; end
					
					Graphics.drawImageToSceneWP(Graphics.sprites.npc[v.id].img, v.x, v.y, 0, f*h, w, h, mirrorPriority-0.0001)
				end
				break;
			end
		end
		
		mirror_capture:captureAt(mirrorPriority-0.000001);
		Graphics.glDraw{vertexCoords = {0,0,800,0,800,600,0,600}, textureCoords = {1,0,0,0,0,1,1,1}, primitive = Graphics.GL_TRIANGLE_FAN, texture=mirror_capture, priority = mirrorPriority};
	end
	
	if(mcTable.mode_oneshot and oneshot_buffer ~= nil and mem(0x00B2C5AC, FIELD_FLOAT) > oneshot_buffer) then
		mem(0x00B2C5AC, FIELD_FLOAT,oneshot_buffer);
	end
end

local function exitChallenge()
	mcTable.loadInProgress = true;
	mcTable.hasLost = true;
	Level.load("mariochallenge_results.lvlx")
end

local function reroll()
	if(mcTable.rerolls > 0) then
		mcTable.rerolls = mcTable.rerolls - 1;
	end
	mcTable.rerollCounter = mcTable.rerollCounter+1;
	mcTable.loadInProgress = true;
	loadNextLevel(true);
end

function smasmariochallenge.onHUDDraw()
	if(shouldFillScreen()) then
		fillScreen();
		firstFrame = false;
		return;
	end
	if (not isIntro) then
		if isWinning() or mcTable.hasWon then
			drawVictory();
		elseif mcTable.hasLost then
			drawResults();
		elseif not isOverworld then
			if(dying) then
				RunDeathEvent();
			end
			local x = 800-144;
			local y = 600-72;
			if(mcTable.mode_timer) then
				local t = math.ceil((timer_deathTimer/64) + (mem(0x00B2C8E4,FIELD_DWORD) - timer_initscore)/1000 --[[1000 points = 1 extra second]]);
				drawUI(x,y-24,Graphics.sprites.mariochallenge["timer"].img,t);
				if(t <= 60 and not timer_hurry) then
					Audio.SfxPlayCh(-1,audio_hurryup,0);
					timer_hurry = true;
				end
				if(player:mem(0x13E,FIELD_WORD) == 0 and winState() == 0 and not Misc.isPaused()) then
					if(t > 0 and player:mem(0x13E,FIELD_WORD) == 0) then
						timer_deathTimer = timer_deathTimer - 1;
					end
				end
			end
			if(mcTable.rerolls < 0) then
				drawUI(x,y,Graphics.sprites.mariochallenge["rerolls"].img,mcTable.rerolls);
			else
				drawUI(x,y,Graphics.sprites.mariochallenge["rerolls"].img,mcTable.rerolls,mcTable.config_rerolls);
			end
			
			if(mcTable.config_lives < 0) then
				drawUI(x,y+24,Graphics.sprites.mariochallenge["lives"].img, mcTable.config_lives);
			else
				drawUI(x,y+24,Graphics.sprites.mariochallenge["lives"].img,mem(0x00B2C5AC,FIELD_FLOAT), mcTable.config_lives);
			end
			
			local lvls = mcTable.playIndex;
			local boostIndex = 0;
			boostIndex = math.floor(lvls/100);
			lvls = lvls%100;
			
			for i = 1,boostIndex do
				Graphics.draw{type = RTYPE_IMAGE, x=x-(16*i), y=y+48, image=Graphics.sprites.mariochallenge["stages"].img, priority=-4.2};
			end
			
			drawUI(x,y+48,Graphics.sprites.mariochallenge["stages"].img,lvls,mcTable.config_levels);
		end
		if timer > 0 then
			if not isWinning() and not mcTable.hasWon and not mcTable.hasLost then
				if not isOverworld and not mcTable.hasSeenText then
					drawLevelName();
				end
			end
			timer = timer - 1
		elseif timer == 0 and not mcTable.hasSeenText then
			timer = 0
			mcTable.hasSeenText = true;
		end
	end
end

local lastPauseKey = false;

function smasmariochallenge.onInputUpdate()
	if(mcTable.mode_mirror and mirror_capture ~= nil and not isIntroLevel() and not isOverworld and not shouldFillScreen() and not Misc.isPaused()) then
		local right = player.rightKeyPressing;
		player.rightKeyPressing = player.leftKeyPressing;
		player.leftKeyPressing = right;
	end
end

function smasmariochallenge.onTick()
	if(isIntroLevel()) then
		return;
	end
	
 	if(earlyDeathCheck > 0) then
		earlyDeathCheck = earlyDeathCheck - 1;
	end
	if(lunatime.tick() == 4 or lunatime.tick() == 2) then
		initCostumes();
	end
	
	if(mcTable.mode_slippery and not isIntroLevel()) then
		for _,v in ipairs(Block.get()) do
			v.slippery = true;
		end
	end
	
	if(mcTable.mode_onehit and not isIntroLevel()) then
		if(player:mem(0x140, FIELD_WORD) > 140 or player:mem(0x122,FIELD_WORD) == 2) then
			player:mem(0x140, FIELD_WORD, 0);
			player:kill();
		end
	end
	
	if(mcTable.mode_rinka and not isIntroLevel()) then
		rinka_counter = rinka_counter + 1;
			if rinka_counter >= 180 then
				rinka_counter = 0;
				for _,v in ipairs(NPC.get(NPC.HITTABLE, player.section)) do
					if not v.friendly and not v.isHidden and rinka_exclude[v.id] == nil and v:mem(0x12C,FIELD_WORD) == 0 and v:mem(0x128,FIELD_WORD) ~= -1 and not v:mem(0x64,FIELD_BOOL) then
						local n = NPC.spawn(210,v.x+v.width*0.5,v.y+v.height*0.5, player.section);
						n.x = n.x-n.width*0.5;
						n.y = n.y-n.height*0.5;
					end
				end
			end
	end
	
	if(mcTable.mode_timer and not isIntroLevel()) then
		if(player:mem(0x13E,FIELD_WORD) == 0 and winState() == 0 and not Misc.isPaused() and timer_deathTimer <= 0) then
			player:kill();
		end
	end
	--[[if player.dropItemKeyPressing and player:mem(0x13E, FIELD_WORD) == 0 and not (isWinning() or mcTable.hasWon or mcTable.hasLost) then
		selectKeyDown = selectKeyDown + 1
	else
		selectKeyDown = 0
	end
	if selectKeyDown == rerollCount and (mcTable.rerolls > 0 or mcTable.rerolls == -1) then
		reroll();
	elseif selectKeyDown > 0 then
		if(mcTable.rerolls > 0 or mcTable.rerolls == -1) then
			local a = math.floor((selectKeyDown/rerollCount)*255);
			textblox.printExt("<wave>Rerolling Level...</wave>", {color = a+0xFFFFFF00, font = textblox.FONT_SPRITEDEFAULT3X2, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_BOTTOM, z=10});
		end
		
		if(selectKeyDown > 25) then
			drawLevelName();
		end
	end]]
	
	if player:mem(0x13E, FIELD_WORD) >= 198 or (player.character == CHARACTER_NINJABOMBERMAN and player:mem(0x13E, FIELD_WORD) >= 1) then
		if(earlyDeathCheck > 0) then
			mcTable.loadInProgress = true;
			loadNextLevel(true);
		elseif not dying then
			player:mem(0x13E, FIELD_WORD, 198);
			
			mcTable.deaths = mcTable.deaths + 1;
			
			local bounds = Section(player.section).boundary;
			table.insert(mcDeathTable, {x=player.x+(player.width-1)*0.5, y = math.max(bounds.top + 4 + Graphics.sprites.mariochallenge["deathmark"].img.height, math.min(bounds.bottom - 4, player.y + player.height - 4))})
			if(mcData.deaths == nil) then
				mcData.deaths = {};
			end
			mcData.deaths[mcTable.currentLevel.episodeName..":"..mcTable.currentLevel.levelFile] = mcDeathTable;
			writeData(mcData);
		
			dying = true;
		end
	end
	
	--Cancel game end events
	if(Level.winState() == 5) then
		Level.winState(lastWinState);
	end
end

function smasmariochallenge.onNPCKill()
	lastWinState = Level.winState();
end

function smasmariochallenge.Activate()
	activated = true;
	initData();
	fullLevelList = getFullLevelList();
	
	
	pcall(Player.transform, player, mcTable.character);
	
	if(mcTable.mode_timer and not isOverworld) then
		timer_deathTimer = (180 + (mcTable.deaths-mcTable.startingDeaths) * 15) * 64; --3 minutes (180 seconds) base time
		timer_initscore = mem(0x00B2C8E4,FIELD_DWORD);
		audio_hurryup = Audio.SfxOpen(Misc.resolveSoundFile("hurry-up"));
		timer_hurry = false;
	end
	
	if(mcTable.mode_mirror and not isOverworld) then
		mirror_capture = Graphics.CaptureBuffer(800,600);
	end
	
	if(mcTable.mode_oneshot and not isOverworld) then
		oneshot_buffer = mem(0x00B2C5AC, FIELD_FLOAT);
	end


    mode_images = {
				{active=smasmariochallenge.getModeOHKO,img=Graphics.sprites.mariochallenge["mode-ohko"]}, 
				{active=smasmariochallenge.getModeShuffle,img=Graphics.sprites.mariochallenge["rerolls"]}, 
				{active=smasmariochallenge.getModeSlippery,img=Graphics.sprites.mariochallenge["mode-slippery"]}, 
				{active=smasmariochallenge.getModeTimer,img=Graphics.sprites.mariochallenge["timer"]}, 
				{active=smasmariochallenge.getModeRinka,img=Graphics.sprites.mariochallenge["mode-rinka"]}, 
				{active=smasmariochallenge.getModeMirror,img=Graphics.sprites.mariochallenge["mode-mirror"]}, 
				{active=smasmariochallenge.getModeOneshot,img=Graphics.sprites.mariochallenge["mode-oneshot"]}
			  };
	
	if(mcTable.mode_rinka and not isOverworld) then
		rinka_exclude = {}
		rinka_exclude[210] = true;
		rinka_exclude[258] = true;
		rinka_exclude[138] = true;
		rinka_exclude[88] = true;
		rinka_exclude[33] = true;
		rinka_exclude[10] = true;
		rinka_exclude[103] = true;
		rinka_exclude[274] = true;
		rinka_exclude[152] = true;
		rinka_exclude[252] = true;
		rinka_exclude[251] = true;
		rinka_exclude[253] = true;
		rinka_exclude[278] = true;
		rinka_exclude[210] = true;
		rinka_counter = 0;
	end
	
	--Fresh Mario Challenge - load the intro level!
	if(isOverworld and isIntro and mcTable.playIndex == -2) then
		mcTable.playIndex = -1;
		mcTable.isIntro = true;
		if(mcTable.justWon) then
			mcTable.justWon = false;
			Level.load(introLevel, nil, 5);
		else
			Level.load(introLevel, nil, 4);
		end
		return;
	end
	
	if(isOverworld) then
		flushData();
	end
	if not isOverworld and (Level.filename() == "mariochallenge_intro.lvlx" or Level.filename() == "mariochallenge_outro.lvlx") then
		cleanUp()
		return;
	end
	
	if isWinning() and isOverworld then
		if(mcTable.config_lives >= 0) then
			mem(0x00B2C5AC, FIELD_FLOAT, mcTable.config_lives)
		else
			mem(0x00B2C5AC, FIELD_FLOAT, 99)
		end
		loadNextLevel()
	else
		registerEvent(smasmariochallenge, "onExitLevel", "onExitLevel", false)
		registerEvent(smasmariochallenge, "onHUDDraw", "onHUDDraw", false)
		registerEvent(smasmariochallenge, "onCameraDraw", "onCameraDraw", false)
		registerEvent(smasmariochallenge, "onTick", "onTick", false)
		registerEvent(smasmariochallenge, "onInputUpdate", "onInputUpdate", true)
		registerEvent(smasmariochallenge, "onPause", "onPause", true)
		registerEvent(smasmariochallenge, "onNPCKill", "onNPCKill", true)
		
		timer = 400
		selectKeyDown = 0
		defs = require("expandedDefines")
		textplus = require("textplus")
		mainfont = {xscale=2, yscale=2, priority = -4.2, font = textplus.loadFont("textplus/font/6.ini")}
		
		if not mcTable.loadInProgress then
			if isOverworld then
				-- We're going to trigger loading, so flag that it's in progress so we don't get stuck re-loading forever
				mcTable.loadInProgress = true;
				loadNextLevel()
			end
		else
			if (not isOverworld) then
				-- If we're not in the overworld anymore, loading finished and we can re-arm
				mcTable.loadInProgress = false;
			end
		end
	end
end

function smasmariochallenge.Deactivate()
	activated = false;
	flushData();
end

function smasmariochallenge.onInitAPI()
	mcData = readData();
	if mcData.active then
		mcData.active = nil;
		writeData(mcData);
		smasmariochallenge.Activate();
		--GameData.__activatedCheats = {};
	end
end

return smasmariochallenge