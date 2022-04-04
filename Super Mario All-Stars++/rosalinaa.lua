--rosalina.lua
--v1.0.1
--Created by Horikawa Otane, 2015
--Contact me at https://www.youtube.com/subscription_center?add_user=msotane

local defs = require("expandedDefines")
local vectr = require("vectr")
local colliders = require("colliders")
local starman;
if(not isOverworld) then
	starman = require("NPCs/ai/starman")
end
local pm = require("playerManager")

local rosalina = {}

local canJump = true
local hasStar = false --No free stars
local inStar = false

local preRosaCoins = 0;
local rosaCoins = 0;

local lumatarget = pm.registerGraphic(CHARACTER_ROSALINA, "lumatarget.png")
local lumabase = pm.registerGraphic(CHARACTER_ROSALINA, "star_base.png")
local lumafill = pm.registerGraphic(CHARACTER_ROSALINA, "star_fill.png")
local lumacolorbase = pm.registerGraphic(CHARACTER_ROSALINA, "star_color.png");
local starbitcounter = pm.registerGraphic(CHARACTER_ROSALINA, "starbit.png");
local lumacolor = Graphics.getPixelData(pm.getGraphic(CHARACTER_ROSALINA, lumacolorbase));
for k,v in ipairs(lumacolor) do
	lumacolor[k] = v/255;
end

Graphics.registerCharacterHUD(CHARACTER_ROSALINA, Graphics.HUD_HEARTS, nil, { coins = starbitcounter } )

local coinTable = {}
coinTable[274] = 20;
coinTable[258] = 2;
coinTable[138] = 2;
coinTable[88] = 2;
coinTable[33] = 2;
coinTable[10] = 2;
coinTable[103] = 2;
coinTable[152] = 2;
coinTable[251] = 2;
coinTable[252] = 2;
coinTable[253] = 2;


local finalLuma = pm.registerGraphic(CHARACTER_ROSALINA, "luma.png")


local targettedNPC;
local hasFoundPeterPan = false

local projectileType = {}
projectileType[3] = 13
projectileType[6] = 291
projectileType[7] = 265

local firstRun = true
local listOfBombs = {}
local dropCounter = 0

function pm.onCostumeChange(playerID, newCostume)
	if(playerID == CHARACTER_ROSALINA) then
		lumacolor = Graphics.getPixelData(pm.getGraphic(CHARACTER_ROSALINA, lumacolorbase));
		for k,v in ipairs(lumacolor) do
			lumacolor[k] = v/255;
		end
	end
end


local function tableSortCat(a, b)
	if a.y > b.y then
		return true
	elseif a.y < b.y then
		return false
	else
		return a.x < b.x
	end
end

local function findMePeterPan(rDirection)
	local x1 = math.floor(player.x) - player.screen.left
	local y1 = math.floor(player.y) - player.screen.top
	local x2 = x1 + 800
	local y2 = y1 + 600
	local localNpcList = NPC.getIntersecting(x1, y1, x2, y2)
	local realNpcList = {}
	for i, j in pairs(localNpcList) do
		if (j.isValid and NPC.HITTABLE_MAP[j.id] and j.id ~= 17 and j.id ~= 18 and not j.friendly and j:mem(0x124, FIELD_BOOL) and not j:mem(0x64, FIELD_BOOL) and not j.isHidden) then
			table.insert(realNpcList, j)
		end
	end
	if #realNpcList ~= 0 then
		table.sort(realNpcList, tableSortCat)
		local targetIndex = 1;
		if(targettedNPC ~= nil and targettedNPC.isValid) then
			for i=1,#realNpcList do
				if(realNpcList[i] == targettedNPC) then
					targetIndex = i;
					break;
				end
			end
		end
		targetIndex = targetIndex + rDirection
		if targetIndex > #realNpcList then
			targetIndex = 1
		end
		if targetIndex < 1 then
			targetIndex = #realNpcList
		end
		targettedNPC = realNpcList[targetIndex]
		hasFoundPeterPan = true
	else
		hasFoundPeterPan = false
	end
end

function rosalina.onInitAPI()
	registerEvent(rosalina, "onInputUpdate", "onInputUpdate", false)
	registerEvent(rosalina, "onTick", "onTick", false)
	registerEvent(rosalina, "onJump", "onJump", false)
	registerEvent(rosalina, "onJumpEnd", "onJumpEnd", false)
	registerEvent(rosalina, "onDraw", "onDraw", false)
	registerEvent(rosalina, "onNPCKill", "onNPCKill", false)
end

local function cleanUpBombs()
	for _, checkFireball in pairs(listOfBombs) do
		if not checkFireball.isValid then
			checkFireball = nil
		end
	end
end

local function getBombs()
	for _, fireball in pairs(NPC.get(projectileType[player.powerup], player.section)) do
		butts = fireball
		table.insert(listOfBombs, butts)
	end
end

local function handleJumps()
	if (player:mem(0x146, FIELD_WORD) == 0) and (player:mem(0x48, FIELD_WORD) == 0) then
		if player:mem(0x40, FIELD_WORD) ~= 3 then
			if not hasJumped then
				canJump = true
				hasJumped = true
			end
		else
			canJump = false
			hasJumped = false
		end
		if  player.keys.jump == KEYS_DOWN or player.keys.altJump == KEYS_DOWN then
			if player.speedY > 0.2 then 
				player.speedY = 0.2
			end
			--Sparkle
			player:mem(0x02, FIELD_WORD, -1)
			--Hover timer
			player:mem(0x1C, FIELD_WORD, -1)
		end			
	else
		canJump = false
		hasJumped = false
		--No Sparkle
		player:mem(0x02, FIELD_WORD, 0)
	end
end

local function drawStarPower()
		local coins = mem(0x00B2C5A8, FIELD_WORD)
		if(hasStar) then
			coins = 100;
		end
		local x,y = 576,24;
		local p = (coins/100);
		local c = math.ceil(#lumacolor*0.25);
		c = math.min(4*math.floor(p*c + 0.5) + 1, #lumacolor-3);
		p = 1-p;
		Graphics.drawImageWP(pm.getGraphic(CHARACTER_ROSALINA,lumabase), x, y, -5);
		Graphics.glDraw {
		vertexCoords={x+6,y+6+(32*p),x+32+6,y+6+(32*p),x+32+6,y+32+6,x+6,y+32+6}, 
		primitive=Graphics.GL_TRIANGLE_FAN,
		textureCoords={0,p,1,p,1,1,0,1},
		texture=pm.getGraphic(CHARACTER_ROSALINA,lumafill),
		color={lumacolor[c+2],lumacolor[c+1],lumacolor[c],lumacolor[c+3]},
		priority=-5
						}
	if hasStar then
		Graphics.drawImageWP(pm.getGraphic(CHARACTER_ROSALINA,finalLuma), x+4, y+4, -5);
	else
		--for i, v in pairs(coinTable) do
		--	if coins >= v.coinLowerValue and coins < v.coinUpperValue then
		--		Graphics.drawImage(v.coinFile, 580, 25);
		--		break
		--	end
		--end
	end
end

function rosalina.onDraw()
	if(player.character == CHARACTER_ROSALINA) then
		if (player.powerup == 3 or player.powerup == 7) then
			if hasFoundPeterPan and targettedNPC.isValid then
				Graphics.drawImageToSceneWP(pm.getGraphic(CHARACTER_ROSALINA,lumatarget), targettedNPC.x + .5 * targettedNPC.width - 24, targettedNPC.y - 37, -25)
			end
		end
		if hasStar then
			mem(0x00B2C5A8, FIELD_WORD,0);
		end
		drawStarPower()
	end
end

local function handleProjectiles()
	if(player:mem(0x13E,FIELD_WORD) == 0) then
		if (player.powerup == 3 or player.powerup == 7) then
			if hasFoundPeterPan and targettedNPC.isValid then
				for _, fireball in pairs(NPC.get(projectileType[player.powerup], player.section)) do
					fireball.speedX = 0
					fireball.speedY = -.21
					local direction = vectr.v2(targettedNPC.x + targettedNPC.width*0.5 - fireball.x, targettedNPC.y + targettedNPC.height*0.5 - fireball.y):normalise() * 3
					fireball.x = fireball.x + direction.x
					fireball.y = fireball.y + direction.y
				end
			end
		elseif player.powerup == 6 then
			cleanUpBombs()
			for _, fireball in pairs(listOfBombs) do
				if fireball.data.drop == nil and fireball.isValid then
					fireball.speedX = 0
					fireball.speedY = -.21
				end
			end
		end
		if dropCounter == 20 and projectileType[player.powerup] ~= nil then
			for _, fireball in pairs(NPC.get(projectileType[player.powerup], player.section)) do
				butts = fireball
				butts.data.drop = true
				if(player.holdingNPC == fireball) then
					player:mem(0x154,FIELD_WORD,0);
				end
			end
		end
		--Check if there are stil targets on screen.
		if hasFoundPeterPan then
			findMePeterPan(0)
		end
	end
end

function rosalina.onNPCKill(event, npc, reason)
	if(player.character == CHARACTER_ROSALINA) then
		if(reason == 9 and (colliders.collide(player,npc) or colliders.speedCollide(player,npc))) then
			if(coinTable[npc.id] ~= nil) then
				local newCoinCount = mem(0x00B2C5A8, FIELD_WORD) + coinTable[npc.id] - 1;
				if newCoinCount >= 100 then
					mem(0x00B2C5A8, FIELD_WORD, 0)
					hasStar = true
				else
					mem(0x00B2C5A8, FIELD_WORD, newCoinCount)
				end
			--[[elseif (npc.id == 258 or npc.id == 138 or npc.id == 88 or npc.id == 33 or npc.id == 10 or npc.id == 103 or npc.id == 152 or npc.id == 251 or npc.id == 252 or npc.id == 253) then
				if not hasStar and mem(0x00B2C5A8, FIELD_WORD) >= 99 and not inStar then
						hasStar = true
						mem(0x00B2C5A8, FIELD_WORD, 0)
					end]]
			end
		end
	end
end

local pressedRun = false;

function rosalina.onInputUpdate()
	if player.character == CHARACTER_ROSALINA then
		pm.winStateCheck()
		if(not Misc.isPaused()) then
			if player.keys.jump == KEYS_PRESSED or player.keys.altJump == KEYS_PRESSED then
				if (canJump) then
					player.speedY = -8
					playSFX(1)
					canJump = false
				end
			end
			if player.keys.altRun == KEYS_PRESSED then
				if (player.powerup == 3 or player.powerup == 7) then
					findMePeterPan(1)
				end
				if (player.powerup == 6) then
					gotBombs = NPC.get(projectileType[player.powerup], player.section)
					if #gotBombs >= 1 then
						local bomb = gotBombs[1]
						bomb.data.drop = true
					end
					--for _, fireball in pairs(NPC.get(projectileType[player.powerup], player.section)) do
						--butts = fireball
						--butts.data.drop = true
					--end
				end
			end
			if player.keys.run == KEYS_PRESSED then
				if (not inStar) and (hasStar) then
					hasStar = false
					mem(0x00B2C5A8, FIELD_WORD, 0);
					starman.startTheStar()
				end
			end
			if hasFoundPeterPan then
				if player.keys.dropItem == KEYS_DOWN then
					if (keycode == KEY_RIGHT) then
						findMePeterPan(1)
					end
					if (keycode == KEY_LEFT) then
						findMePeterPan(-1)
					end
				end
			end
			if(player.runKeyPressing or player.altRunKeyPressing) then
				if(not pressedRun) then
					if(player.powerup == PLAYER_HAMMER and player.holdingNPC == nil and player.altRunKeyPressing) then
						local n = NPC.spawn(projectileType[PLAYER_HAMMER], player.x+player.width*0.5, player.y, player.section);
						n.x = n.x-n.width*0.5;
						table.insert(listOfBombs,n);
						player:mem(0x154, FIELD_WORD, NPC.count());
						n:mem(0x12C,FIELD_WORD,1);
						Audio.playSFX(23)
					end
					pressedRun = true;
				end
			else
				pressedRun = false;
			end
			
			if player.dropItemKeyPressing then
				dropCounter = dropCounter + 1
			else
				dropCounter = 0
			end
		else
			pressedRun = true;
		end
	end
end

local function setPlayerSettings()
	--Princess hover is available
	player:mem(0x18, FIELD_WORD, -1)
	--Star sparkling effect on player
	player:mem(0x02, FIELD_WORD, -1)
	--Holding jump button
	player:mem(0x1A, FIELD_WORD, 0)
end

function rosalina.onTick()
	if (player.character == CHARACTER_ROSALINA) then
		if Level.winState() == 0 then
			if(player.powerup == PLAYER_HAMMER) then
				player:mem(0x160,FIELD_WORD,2);
			end
			cleanUpBombs()
			handleProjectiles()
			setPlayerSettings()
			handleProjectiles()
			handleJumps()
		end
	end
end

function rosalina.onJump()
	if (player.character == CHARACTER_ROSALINA) then
		canJump = true
	end
end

function rosalina.onJumpEnd()
	if (player.character == CHARACTER_ROSALINA) then
		canJump = false
	end
end

function rosalina.initCharacter()
	-- CLEANUP NOTE: This is not safe if a level makes it's own use of jumpheight
	Defines.jumpheight = 7
	Defines.jumpheight_bounce = 8
	
	preRosaCoins = mem(0x00B2C5A8, FIELD_WORD);
	mem(0x00B2C5A8, FIELD_WORD, rosaCoins);
end

function rosalina.cleanupCharacter()
	
	-- CLEANUP NOTE: This is not safe if a level makes it's own use of jumpheight
	Defines.jumpheight = nil
	Defines.jumpheight_bounce = nil
	
	Graphics.sprites.hardcoded["33-2"].img = nil;
	
	rosaCoins = mem(0x00B2C5A8, FIELD_WORD);
	mem(0x00B2C5A8, FIELD_WORD, preRosaCoins);
	
	-- CLEANUP NOTE: This is not quite safe for various reasons...
	--mem(0x00B2C8C0, FIELD_WORD, 0)
end

return rosalina