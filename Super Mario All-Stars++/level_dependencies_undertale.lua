megaluavania = require("megaluavania")

if SaveData.ut_encounter == nil then
	SaveData.ut_encounter = SaveData.ut_encounter or 0
end
if SaveData.ut_poiton == nil then
	SaveData.ut_poiton = SaveData.ut_poiton or 0
end 
if SaveData.ut_healfood == nil then
	SaveData.ut_healfood = SaveData.ut_healfood or 0
end
if SavaData.ut_xp == nil then
	SavaData.ut_xp = SavaData.ut_xp or 0
end

megaluavania.playerHPMax = 20
megaluavania.LV = 1
megaluavania.playerAtk = 15
megaluavania.name = "Frisk"
megaluavania.exp = undertale:get("xp")
megaluavania.gold = 0
megaluavania.expPerLV = function(LV)
	return 30 + 10 * LV * LV
end
megaluavania.HPPerLV = function(LV)
	if LV ~= 20 then
		return 16 + 4 * LV
	else
		return 99
	end	
end
megaluavania.atkPerLV = function(LV)
	if LV ~= 20 then
		return 5 + 2 * LV
	else
		return 50
	end
end
megaluavania.items = {}

for i = 1,SaveData.ut_healfood do
	table.insert(megaluavania.items,{name = "Monster Candy",text = {"* You ate the Monster Candy.<br>* ... tastes like licorice.<br>* You recovered 10 HP!<br>"},rec = 10})
end

for i = 1,SaveData.ut_poiton do
	table.insert(megaluavania.items,{name = "Spider Cider",text = {"* You drank the Spider Cider.<br>  You recovered 24 HP!<br>"},rec = 24})
end

--textboxes got 32 chars, dialogue boxes 14

function onStart()
	if SaveData.ut_encounter == 1 then
		triggerEvent("ut_goombaspawn")
	end
end

local goomba = Graphics.loadImage("megaluavania/goomba_normal.png")
local goombahurt = Graphics.loadImage("megaluavania/goomba_hurt.png")

local goomba = megaluavania.newEncounter()

goomba.name = "Goomba"
goomba.NPCID = nil
goomba.event = "goombautspawn"
goomba.hideLayers = {"Default"}
goomba.enemyHPMax = 45
goomba.overrideDeath = false
goomba.enemyDef = -3
goomba.canspare = true
goomba.canflee = true
goomba.randomDialogue = {{req = function() return goomba.turn == 1; end,text = {{{text = "<wave>Bowser<br>wants you<br>dead,<br>hero!</wave>",sprite = goomba}}}}
goomba.flavorText = {{req = function() return goomba.turn == 1; end,text = {"* A Goomba appeared!"}},
					{req = function() return goomba.turn == 2; end,text = {"* The Goomba thinks you're part<br>  of Mario's team!"}},
					{req = function() return goomba.canspare; end,text = {"* The Goomba is sparing you."}},
					{req = function() return true; end,text = {"* The Goomba had a thought of combat.<br>  He rushes to try it out!","* The Goomba thinks you're Mario.","* The Goomba looks squishable.","* The Goomba is trying to not<br>  get squished.","* The Goomba is now gonna combat."}}}
goomba.acts = {	{name = "Check",text = {"* Goomba ATK 15 DEF -3<br>* Part of the army<br>* Bowser sent over to annihilate you."}},
				{name = "Talk",text = {"* You try to talk to the Goomba,<br>  reminding him that you're<br>  not Mario."}}}
goomba.typeSounds = {"littleDialogue/dr/typewriter.ogg"}
goomba.music = "_OST/Undertoad/Tough and Tumble.ogg"
goomba.sprite = goomba
goomba.spriteHurt = goombahurt
goomba.gold = 25
goomba.exp = 220

local new = {	boxWidth = 580,
				boxHeight = 140,
				time = math.huge}

new.func = function(counter)
	megaluavania.heart.move = false
	megaluavania.heart.y = megaluavania.centerY - 12
	textblox.print("Yes",210,megaluavania.centerY - 16,megaluavania.determination)
	textblox.print("No",540,megaluavania.centerY - 16,megaluavania.determination)
	if newChoice == 1 then
		megaluavania.heart.x = 185
		if player.rawKeys.right == KEYS_PRESSED then
			newChoice = 2
			Audio.playSFX(megaluavania.resourcePath.."menu1.ogg")
		elseif player.rawKeys.jump == KEYS_PRESSED then
			new.stop = true
			gotTutorial = 1
			Audio.playSFX(megaluavania.resourcePath.."menu2.ogg")
			megaluavania.heart.move = true
		end
	else
		megaluavania.heart.x = 515
		if player.rawKeys.left == KEYS_PRESSED then
			newChoice = 1
			Audio.playSFX(megaluavania.resourcePath.."menu1.ogg")
		elseif player.rawKeys.jump == KEYS_PRESSED then
			new.stop = true
			gotTutorial = 2
			Audio.playSFX(megaluavania.resourcePath.."menu2.ogg")
			megaluavania.heart.move = true
		end
	end
end

local tut1 = {	boxWidth = 250,
				boxHeight = 200,
				time = math.huge}
				
tut1.func = function(counter)
	if counter == 0 then
		table.insert(fire1,megaluavania.createBullet{sprite = joeyFire,x = megaluavania.centerX - 8,y = megaluavania.centerY - tut1.boxHeight/2 + 5,height = 16,dmg = 7,nFrames = 4,frameSpeed = 6})
	end
	if megaluavania.heart.isMoving then
		hasMoved = true
	end
	for _,v in pairs(fire1) do
		v.y = math.min(v.y + 1,megaluavania.centerY + tut1.boxHeight/2 - 21)
		if megaluavania.heart.invincibility ~= 0 then
			tut1.stop = true
			if hasMoved then
				tutDia[1] = {{text = "<wave>Erm...<br>Are you<br>serious?</wave>",sprite = goomba},{text = "<wave>That was<br>literally<br>one bullet.</wave>",sprite = joeySassy},{text = "<wave>You know,<br>forget it,<br>I hope you<br>learned your<br>lesson.</wave>",sprite = joeySad},{text = "<wave>So, next up:<br>Cyan bullets.<br>Just don't<br>move and<br>they won't<br>hurt you.</wave>",sprite = joey,func = function() tutTurn = 3; end}}
			else
				tutDia[1] = {{text = "<wave>Erm...<br>Are you<br>serious?</wave>",sprite = goomba},{text = "<wave>You do know<br>that you can<br>move around,<br>right?</wave>",sprite = joeySassy},{text = "<wave>Wait,<br>actually, it<br>seems to be<br>your lucky<br>day!</wave>",sprite = joeyWink},{text = "<wave>Next up are<br>cyan bullets.<br>Just continue<br>not moving and<br>they won't<br>hurt you.</wave>",sprite = joey,func = function() tutTurn = 3; end}}
			end
		elseif v.y == megaluavania.centerY + tut1.boxHeight/2 - 21 then
			tut1.stop = true
			tutDia[1] = {{text = "<wave>Wow,<br>good job.</wave>",sprite = goomba},{text = "<wave>You dodged<br>one bullet.</wave>",sprite = joeySassy},{text = "<wave>I hope you're<br>proud of<br>yourself.</wave>",sprite = goomba},{text = "<wave>So, next up:<br>Cyan bullets.<br>Just don't<br>move and<br>they won't<br>hurt you.</wave>",sprite = goomba,func = function() tutTurn = 3; end}}
		end
	end
end