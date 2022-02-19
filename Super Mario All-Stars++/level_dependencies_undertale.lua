local megaluavania = require("megaluavania")
local rng = API.load("rng")
local colliders = API.load("colliders")
local playerManager = require("playermanager")

local undertaledepends = {}

function undertaledepends.onInitAPI()
	registerEvent(undertaledepends,"onEvent")
	registerEvent(undertaledepends,"onPostNPCKill")
	registerEvent(undertaledepends,"onPlayerHarm")
	
	eventsRegistered = true
end

if SaveData.utencounter == nil then
	SaveData.utencounter = 0
end
if SaveData.utpoiton == nil then
	SaveData.utpoiton = 1
end 
if SaveData.uthealfood == nil then
	SaveData.uthealfood = 1
end
if SaveData.utxp == nil then
	SaveData.utxp = 0
end
if SaveData.utspare == nil then
	SaveData.utspare = 0
end

Misc.saveGame()

megaluavania.playerHP = 20
megaluavania.playerHPMax = 20
megaluavania.LV = 1
megaluavania.playerAtk = 15

local eventsRegistered = false

megaluavania.name = "Frisk"
megaluavania.exp = SaveData.utxp
megaluavania.gold = 0
megaluavania.expPerLV = function(LV)
	return 30 + 10 * LV * LV
end
megaluavania.HPPerLV = function(LV)
	if LV ~= 999 then
		return 99 + 8 * LV
	else
		return 999
	end	
end
megaluavania.atkPerLV = function(LV)
	if LV ~= 999 then
		return 35 + 5 * LV
	else
		return 999
	end
end
megaluavania.items = {}

for i = 1,SaveData.uthealfood do
	table.insert(megaluavania.items,{name = "Health Snacks",text = {"* You ate the Health Snacks.<br>* It's bad tastes reminds you of<br>how much you hate brocoilli.<br>"},rec = 10})
end

for i = 1,SaveData.utpoiton do
	table.insert(megaluavania.items,{name = "Orange Wine",text = {"* You drank the Orange Wine.<br>* It tastes like a mix between orange<br>juice and wine (Duh)."},rec = 20})
end

function undertaledepends.onPostNPCKill(npc, harmtype)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	local costumes
	local goombas = table.map{1,2,27,71,89,242,243,379,392,393,466,467}
	if goombas[npc.id] then
		if harmtype == HARM_TYPE_JUMP then
			if currentCostume == "UNDERTALE-FRISK" then
				triggerEvent("_UNDERTALEBATTLEGoomba")
				SaveData.utencounter = 1
			end
		end
    end
	--if npc.id == 4 or npc.id == 5 or npc.id == 6 or npc.id == 7 or npc.id == 55 or npc.id == 72 or npc.id == 73 or npc.id == 76 or npc.id == 110 or npc.id == 111 or npc.id == 112 or npc.id == 113 or npc.id == 114 or npc.id == 115 or npc.id == 116 or npc.id == 117 or npc.id == 118 or npc.id == 119 or npc.id == 120 or npc.id == 121 or npc.id == 122 or npc.id == 123 or npc.id == 124 or npc.id == 161 or npc.id == 76 or npc.id == 172 or npc.id == 173 or npc.id == 174 or npc.id == 175 or npc.id == 176 or npc.id == 177 or npc.id == 194 or npc.id == 578 or npc.id == 920 or npc.id == 921 then
        --SaveData.koopaStomps = SaveData.koopaStomps + 1
    --end
end

function undertaledepends.onPlayerHarm(npc, id, eventName)
    local goombas = table.map{1,2,3,27,71,89,165,166,242,243,244,379,392,393,466,467}
	if goombas[npc.id] then
		triggerEvent("_UNDERTALEBATTLEGoomba")
		SaveData.utencounter = 1
    end
	--if npc.id == 4 or npc.id == 5 or npc.id == 6 or npc.id == 7 or npc.id == 55 or npc.id == 72 or npc.id == 73 or npc.id == 76 or npc.id == 110 or npc.id == 111 or npc.id == 112 or npc.id == 113 or npc.id == 114 or npc.id == 115 or npc.id == 116 or npc.id == 117 or npc.id == 118 or npc.id == 119 or npc.id == 120 or npc.id == 121 or npc.id == 122 or npc.id == 123 or npc.id == 124 or npc.id == 161 or npc.id == 76 or npc.id == 172 or npc.id == 173 or npc.id == 174 or npc.id == 175 or npc.id == 176 or npc.id == 177 or npc.id == 194 or npc.id == 578 or npc.id == 920 or npc.id == 921 then
        --SaveData.koopaStomps = SaveData.koopaStomps + 1
    --end
end

local goomba = megaluavania.newEncounter()

local goombamain = Graphics.loadImage("megaluavania/goomba_normal.png")
local goombahurt = Graphics.loadImage("megaluavania/goomba_hurt.png")
local goombaattack1 = Graphics.loadImage("megaluavania/goomba_attack1.png")

local goombatwirl = {}
local goombaTwist = {}
local goombaAttacks = {}

goomba.name = "Goomba"
goomba.NPCID = 1
goomba.event = "_UNDERTALEBATTLEGoomba"
--goomba.hideLayers = {""}
goomba.enemyHPMax = 45
goomba.overrideDeath = false
goomba.enemyDef = -3
goomba.canspare = false
goomba.canflee = true
goomba.randomDialogue = {{req = function() return goomba.turn == 1; end,text = {{{text = "<wave>Bowser<br>wants you<br>dead,<br>hero!</wave>",sprite = goombamain}}}}}
goomba.randomDialogue = {{req = function() return goomba.turn == 2; end,text = {{{text = "<wave>All hail<br>King Bowser!</wave>",sprite = goombamain}}}}}
goomba.flavorText = {{req = function() return goomba.turn == 1; end,text = {"* A Goomba appeared!"}},
					{req = function() return goomba.turn == 2; end,text = {"* The Goomba thinks you're part<br>  of Mario's team!"}},
					{req = function() return goomba.canspare; end,text = {"* The Goomba is sparing you."}},
					{req = function() return true; end,text = {"* The Goomba had a thought of combat.<br>  He rushes to try it out!","* The Goomba thinks you're Mario.","* The Goomba looks squishable.","* The Goomba is trying to not<br>  get squished.","* The Goomba is now gonna combat."}}}
goomba.acts = {	{name = "Check",text = {"* Goomba ATK 15 DEF -3<br>* Part of the army<br>* Bowser sent over to annihilate you."}},
				{name = "Talk",text = {"* You try to talk to the Goomba,<br>  reminding him that you're<br>  not Mario."}}}
goomba.typeSounds = {"littleDialogue/dr/typewriter.ogg"}
goomba.music = "_OST/Undertoad/Tough and Tumble.ogg"
goomba.sprite = goombamain
goomba.spriteHurt = goombamain
goomba.gold = 25
goomba.exp = 15
					
goombaAttacks[1] = {	boxWidth = 200,
					boxHeight = 200,
					time = 320}
					
goombaAttacks[1].func = function(counter)
	if counter == 0 then
		goombaTwist = {}
		for i = 1,4 do
			table.insert(goombaTwist,{x = rng.randomInt(megaluavania.centerX - goombaAttacks[3].boxWidth/2 + 5,megaluavania.centerX + goombaAttacks[3].boxWidth/2 - 31),y = rng.randomInt(megaluavania.centerY - goombaAttacks[3].boxHeight/2 + 5,megaluavania.centerY + goombaAttacks[3].boxHeight/2 - 17),speedX = 1.5*(2*rng.randomInt(0,1) - 1),speedY = 1.5*(2*rng.randomInt(0,1) - 1)})
		end
	end
	if counter == 40 then
		for k,v in pairs(goombaTwist) do
			goombatwirl[k] = megaluavania.createBullet({sprite = goombaattack1,x = v.x,y = v.y,dmg = 2})
		end
	end
	for k,v in ipairs(goombaTwist) do
		v.x = math.min(megaluavania.centerX + goombaAttacks[3].boxWidth/2 - 31,math.max(megaluavania.centerX - goombaAttacks[3].boxWidth/2 + 5,v.x + v.speedX))
		if v.x == megaluavania.centerX + goombaAttacks[3].boxWidth/2 - 31 or v.x == megaluavania.centerX - goombaAttacks[3].boxWidth/2 + 5 then
			v.speedX = -v.speedX
		end
		v.y = math.min(megaluavania.centerY + goombaAttacks[3].boxHeight/2 - 17,math.max(megaluavania.centerY - goombaAttacks[3].boxHeight/2 + 5,v.y + v.speedY))
		if v.y == megaluavania.centerY + goombaAttacks[3].boxHeight/2 - 17 or v.y == megaluavania.centerY - goombaAttacks[3].boxHeight/2 + 5 then
			v.speedY = -v.speedY
		end
		if goombatwirl[k] ~= nil then
			goombatwirl[k].x = v.x
			goombatwirl[k].y = v.y
		end
	end
	if counter < 40 then
		for _,v in ipairs(goombaTwist) do
			Graphics.drawImage(goombaattack1,v.x,v.y,counter/40)
		end
	end
end

goombaAttacks[2] = {	boxWidth = 200,
					boxHeight = 200,
					time = 320}
					
goombaAttacks[2].func = function(counter)
	if counter == 0 then
		goombaTwist = {}
		for i = 1,4 do
			table.insert(goombaTwist,{x = rng.randomInt(megaluavania.centerX - goombaAttacks[3].boxWidth/2 + 5,megaluavania.centerX + goombaAttacks[3].boxWidth/2 - 31),y = rng.randomInt(megaluavania.centerY - goombaAttacks[3].boxHeight/2 + 5,megaluavania.centerY + goombaAttacks[3].boxHeight/2 - 17),speedX = 1.5*(2*rng.randomInt(0,1) - 1),speedY = 1.5*(2*rng.randomInt(0,1) - 1)})
		end
	end
	if counter == 40 then
		for k,v in pairs(goombaTwist) do
			goombatwirl[k] = megaluavania.createBullet({sprite = goombaattack1,x = v.x,y = v.y,dmg = 2})
		end
	end
	for k,v in ipairs(goombaTwist) do
		v.x = math.min(megaluavania.centerX + goombaAttacks[3].boxWidth/2 - 31,math.max(megaluavania.centerX - goombaAttacks[3].boxWidth/2 + 5,v.x + v.speedX))
		if v.x == megaluavania.centerX + goombaAttacks[3].boxWidth/2 - 31 or v.x == megaluavania.centerX - goombaAttacks[3].boxWidth/2 + 5 then
			v.speedX = -v.speedX
		end
		v.y = math.min(megaluavania.centerY + goombaAttacks[3].boxHeight/2 - 17,math.max(megaluavania.centerY - goombaAttacks[3].boxHeight/2 + 5,v.y + v.speedY))
		if v.y == megaluavania.centerY + goombaAttacks[3].boxHeight/2 - 17 or v.y == megaluavania.centerY - goombaAttacks[3].boxHeight/2 + 5 then
			v.speedY = -v.speedY
		end
		if goombatwirl[k] ~= nil then
			goombatwirl[k].x = v.x
			goombatwirl[k].y = v.y
		end
	end
	if counter < 40 then
		for _,v in ipairs(goombaTwist) do
			Graphics.drawImage(goombaattack1,v.x,v.y,counter/40)
		end
	end
end
	
goombaSpareA =	{	boxWidth = 175,
					boxHeight = 175,
					time = 1}
				
goombaSpareA.func = function(counter)
end

function megaluavania.onAttack(encounter)
	if encounter == goomba then
		if goombaAttacks1 then
			return goomba.goombaAttacks1
		elseif goombaAttacks2 then
			return goomba.goombaAttacks2
		elseif goomba.canspare then
			return goomba.goombaSpareA
		end
	end
end

function megaluavania.onFight(encounter)
	if encounter == goomba then
		if encounter.turn == 1 and megaluavania.dmg > 0 then
			megaluavania.dmg = 15
			return {{text = "<wave>All hail<br>King Bowser!<br></wave>",sprite = goombamain}}
		end
		if encounter.turn == 2 and megaluavania.dmg > 0 then
			megaluavania.dmg = 15
			return {{text = "<wave>OW!<br>Stop hitting<br>me you<br>idiot!</wave>",sprite = goombamain,req = function() return joeyE.canspare; end}}
		end
	end
end

function megaluavania.onKill(encounter)
	if encounter == goomba then
		SaveData.utencounter = 0
		SaveData.utxp = megaluavania.exp
		Misc.saveGame()
	end
end

function megaluavania.onSpareDialogue(encounter)
	if encounter == goomba then
		if encounter.turn ~= 1 then
			SaveData.utspare = SaveData.utspare + 1
		end
	end
end


function undertaledepends.onCleanup()
end

return undertaledepends