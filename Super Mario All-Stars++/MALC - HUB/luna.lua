local level_dependencies_normal = require("level_dependencies_hub")
local malcmusic = require ("malcmusic")
local littleDialogue = require("littleDialogue")
local HUDimage = Graphics.loadImage("MALC-HUD.png")
local playerManager = require("playerManager")
local areaNames = require("areaNames")
local textplus = require("textplus")

local hour = os.date("%H")
local day = os.date("%d")
local month = os.date("%m")
local exacttime = os.date("%X")
local minute = os.date("%M")
local second = os.date("%S")
local stars = mem(0x00B251E0, FIELD_WORD)
local infobooth1 = textplus.loadFont("littleDialogue/font/smb3-c.ini")

littleDialogue.registerStyle("endingtextone",{
	openSpeed = 1,
	pageScrollSpeed = 1, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 1, -- How fast it scrolls when switching answer pages.

	windowingOpeningEffectEnabled = true,

	typewriterEnabled = false,
    showTextWhileOpening = false,

	closeSoundEnabled = false,
	continueArrowEnabled = false,
	scrollArrowEnabled   = false,
	selectorImageEnabled = false,
})

areaNames.sectionNames = {
	[0] = "Me and Larry City (Main City)",
	[1] = "Building 3: ???",
	[2] = "Building 2: Hotel",
	[3] = "Building 4: Town Hall",
	[4] = "Building 1: Tourist Center",
	[5] = "Building 5: The True Ending",
	[6] = "Me and Larry City (Side Quest Area 1)",
	[7] = "Building 6: Plumber Area",
	[8] = "Hotel: Floors 1-5",
	[9] = "Information Booth",
	[10] = "Me and Larry City (Side Quest Area 2 & Ocean)",
	[11] = "Me and Larry City (Warp Zone)",
	[12] = "Character Switch Room",
	[13] = "Character Testing Area",
}

function onStart()
	Audio.MusicVolume(nil)
	if stars >= 4 then
		triggerEvent("Stage0.5")
	end
	if stars >= 10 then
		triggerEvent("Stage1")
	end
	if stars >= 16 then
		triggerEvent("Stage2")
	end
	if stars >= 22 then
		triggerEvent("Stage3")
	end
	if stars >= 28 then
		triggerEvent("Stage4")
	end
	if stars >= 32 then
		triggerEvent("Stage5")
	end
	if stars >= 38 then
		triggerEvent("Stage6")
	end
	--if stars >= 100 then
	--	triggerEvent("StageGenoside")
	--end
end

function onDraw()
	Graphics.drawImageWP(HUDimage, 0, 0, 4)
	
	if player.section == 9 then
		textplus.print{x=-19760, y=-20272, text = "Floor 1: Star List", priority=-86, color=Color.white, sceneCoords=true, font=infobooth1}
		textplus.print{x=-19808, y=-20656, text = "Floor 2: General Info", priority=-86, color=Color.white, sceneCoords=true, font=infobooth1}
		textplus.print{x=-19776, y=-21104, text = "Floor 3: Other Info", priority=-86, color=Color.white, sceneCoords=true, font=infobooth1}
	end
end

function onTick()
	if SaveData.disableX2char == nil then
		SaveData.disableX2char = SaveData.disableX2char or 0
	end
	if SaveData.disableX2char == 0 then
		triggerEvent("ShowX2Stuff")
	end
	if SaveData.disableX2char == 1 then
		triggerEvent("HideX2Stuff")
		--Player.setCostume(1, nil)
	end
	if player.section == 9 then
		Text.printWP("Welcome to the information booth.", 10, 577, 5)
	end
end

function onEvent(eventName)
	if eventName == "SideQuestWarpOpen" then
		SFX.play(27)
	end
	if eventName == "DLCWarpOpen" then
		SFX.play(27)
	end
	if eventName == "StarList" then
		littleDialogue.create({text = "<boxStyle infobooth>OUR RECORDS SHOW THAT YOU HAVE AT LEAST "..stars.." STARS IN YOUR GAME PROGRESSION.<page>THE STARS YOU HAVE COLLECTED IN THE MANDATORY LEVELS IS (number). THE STARS YOU HAVE COLLECTED IN ALL OTHER LEVELS IS (tbd).<page>THE STAR COUNT OF EVERY STAR YOU COLLECTED OVERALL IS "..SaveData.starsgrabbed..".<page>TO FINISH YOUR GAME AND UNLOCK THE TRUE ENDING, YOU'LL NEED TO COLLECT (starcounttbd) MORE.<page>THANKS FOR PROCESSING THE INFORMATION I HAVE EXPLAINED. GOOD DAY."})
	end
	if eventName == "GeneralList" then
		littleDialogue.create({text = "<boxStyle infobooth>OUR RECORDS SHOW THAT YOU HAVE GOT "..SaveData.GameOverCount.." GAME OVERS IN YOUR GAME PROGRESSION.<page>YOU ALSO HAVE RECENTLY WENT IN (number) LEVELS.<page>THE SCORE COUNT IS "..Misc.score().." AND THE COIN COUNT IS "..Misc.coins()..".<page>YOU HAVE ALSO STOMPED ON "..SaveData.goombaStomps.." GOOMBAS, AND "..SaveData.koopaStomps.." KOOPA TROOPAS.<page>THE TOTAL AMOUNT OF COINS COLLECTED OVERALL IS "..SaveData.totalcoins..".<page>OVERALL, YOU HAVE USED "..SaveData.totalmushrooms.." MUSHROOMS, "..SaveData.totalfireflowers.." FIRE FLOWERS, "..SaveData.totalleafs.." SUPER LEAFS, "..SaveData.totaltanookis.." TANOOKI SUITS, "..SaveData.totalhammersuits.." HAMMER SUITS, AND "..SaveData.totaliceflowers.." ICE FLOWERS.<page>YOU ALSO GRABBED "..SaveData.starsgrabbed.." TOTAL STARS REGARDLESS OF COMPLETION OR NOT, USED "..SaveData.starmansused.." STARMANS, "..SaveData.megamushroomssused.." MEGA MUSHROOMS,<page>AND I HOPE YOU'VE HAD A FUN TIME.<page>THANKS FOR PROCESSING THE INFORMATION I HAVE EXPLAINED. GOOD DAY."})
	end
	if eventName == "OtherList" then
		littleDialogue.create({text = "<boxStyle infobooth>OUR RECORDS SHOW THAT YOU HAVE GOT TO WAIT UNTIL THIS LIST WORKS.<page>THIS PART OF THE INFORMATION BOOTH WILL TELL YOU OTHER THINGS NOT RELATED TO ANYTHING.<page>COME BACK WHEN THE FULL EPISODE IS RELEASED. THANK YOU FOR YOUR TIME."})
	end
	if eventName == "Stage5" then
		Section(4).musicPath = "_OST/Me and Larry City/Story Mode Hub Theme 3, With Building Sounds (Super Mario Maker 2).ogg"
	end
	if eventName == "Stage6" then
		Section(4).musicPath = "_OST/Me and Larry City/Story Mode Hub Theme 3, With Building Sounds (Super Mario Maker 2).ogg"
	end
	if eventName == ("DisEnabledX2Char") then
		if SaveData.disableX2char == 0 then
			triggerEvent("HUBDisableX2")
			Level.load(Level.filename())
		end
		if SaveData.disableX2char == 1 then
			triggerEvent("HUBEnableX2")
			Level.load(Level.filename())
		end
	end
	if eventName == "HUBEnableX2" then
		SaveData.disableX2char = SaveData.disableX2char - 1
	end
	if eventName == "HUBDisableX2" then
		SaveData.disableX2char = SaveData.disableX2char + 1
		Graphics.activateHud(false)
		Cheats.trigger("1player")
		Defines.player_hasCheated = false
	end
	if eventName == "HourChange" then
		SFX.play("hour-change.ogg")
	end
end

-- Register questions


littleDialogue.registerAnswer("favgame1",{text = "Super Mario All-Stars Plus Plus",addText = "This must be the best game then, isn't it? I love it too!"})
littleDialogue.registerAnswer("favgame1",{text = "EarthBound",addText = "Is that the Trading Company or something? That name isn't familiar. Oh well..."})
littleDialogue.registerAnswer("favgame1",{text = "Sonic the Hedgehog",addText = "Heh, such a hedgehog! I really like Sonic Mania! It's the best."})
littleDialogue.registerAnswer("favgame1",{text = "Super Mario 64",addText = "Hey, that's what I played! I forgot what it was called. Thank for reminding me!"})
littleDialogue.registerAnswer("favgame1",{text = "Have you even played a video game before?",addText = "Yes, I think it had this one objective to collect stars, but I don't know what it was called..."})
littleDialogue.registerAnswer("favgame1",{text = "Aren't we all in a video game?",addText = "...really? You must be that hero that's splitting facts or something!"})





littleDialogue.registerAnswer("strike1",{text = "No thanks",addText = "I hate you, you stupid hero!"})
littleDialogue.registerAnswer("strike1",{text = "Sure",addText = "That's one signature ahead of our goal! Thanks, hero!"})





littleDialogue.registerAnswer("mayoradvice",{text = "My name is wrong (Or something isn't right).",addText = "If you're name is wrong, don't direct it to me! Direct it to Spencer Everly. They'll fix the issue on the next update.<page>Spencer should be able to reach you on Discord at Spencer Everly#1997.<page>Or use their email at spencer.everly@gmail.com.<page>Reporting bugs makes the player experience a lot better if you do these things!"})
littleDialogue.registerAnswer("mayoradvice",{text = "Give me advice.",addText = "Sure thing! Here is what you need to know:<page>Unfinished advice is the advice that's never gonna get answered until the game's first version is released.<page>That means wait until the full release."})
littleDialogue.registerAnswer("mayoradvice",{text = "Why is everyone orange guns?",addText = "Because Spencer Everly was a dumb kid who made this species. I don't have anything else to say."})
littleDialogue.registerAnswer("mayoradvice",{text = "Is life even good anymore?",addText = "If you feel suicidal, call 1-800-273-8255.<page>I can't see another life taken away from me, and NOT right here."})
littleDialogue.registerAnswer("mayoradvice",{text = "Where am I?",addText = "You're in Mars, in the biggest city of the planet, Me and Larry City.<page>Filled with tall buildings and many areas, us Mearians roam through life trying to live and survive like any other human does.<page>Where did we come from? Why are we here? Why can't we live with humans in peace?<page>Nobody knows..."})
littleDialogue.registerAnswer("mayoradvice",{text = "Nevermind.",addText = "Gotcha. Let me know if you need anything."})





littleDialogue.registerAnswer("mayoradvicehigh",{text = "My name is wrong (Or something isn't right).",addText = "Do a... email...<page>spencer.everly@outloo... uh, yahoo... uh...<page>No... it's gmail.com... yeah.<page>Email that."})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Give me advice.",addText = "Advise 1: I want more weed.<page>Advise 2: Then give me more weed.<page>Advise 3: Uh... I forgot, what again?"})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Why is everyone orange guns?",addText = "Because tomatoes talk in... a show... I forgot."})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Is life even good anymore?",addText = "Call 1-800-273-8255.<page>It's a number... weed, ack!"})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Where am I?",addText = "You... are in some planet...<page>Gee, I forgot where I even am... stupid weed..."})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Nevermind.",addText = "Ah okay..."})





littleDialogue.registerAnswer("semoviefav",{text = "Super Mario All-Stars Plus Plus",addText = "That's not a movie, that's a game you dolt!"})
littleDialogue.registerAnswer("semoviefav",{text = "Caillou Gets Grounded: The Movie",addText = "Are you deranged or something? I hated those killing scenes!"})
littleDialogue.registerAnswer("semoviefav",{text = "Beverly Hills ChihWALL-E",addText = "And we're married! ...that movie is weird."})
littleDialogue.registerAnswer("semoviefav",{text = "Caillou Gets Grounded 2: The Revenge",addText = "Massive improvement, not gonna lie...<page>Some stuff felt... off though. But that's just me."})
littleDialogue.registerAnswer("semoviefav",{text = "The Spencer! The Show! Endgame",addText = "I really liked that one! It shows how much Spencer has improved."})
littleDialogue.registerAnswer("semoviefav",{text = "Spencer! The Movie! FOR REAL",addText = "I heard that Spencer regret making that movie. I don't know why, but they do."})





littleDialogue.registerAnswer("dumbhigh1",{text = "Your face.",addText = "I didn't know I had a face... I'm seeing colors..."})
littleDialogue.registerAnswer("dumbhigh1",{text = "Your butt.",addText = "Good answer... hahahahaha!!!!!"})
littleDialogue.registerAnswer("dumbhigh1",{text = "You ask someone something for an answer.",addText = "That's... wrong!!!!!! it's my PET SHOP Hoi!<page>I'm so high right now........"})




littleDialogue.registerAnswer("YesNoX2Char",{text = "Yes, sure.",chosenFunction = function() triggerEvent("DisEnabledX2Char") end})
littleDialogue.registerAnswer("YesNoX2Char",{text = "No thanks.",addText = "Gotcha. Hit the block again if you want to choose next time!"})



littleDialogue.registerAnswer("strangerQuestion",{text = "Uh...",addText = "What? Are you afraid imma KILL YA? <question strangerQuestionTwo>"})
littleDialogue.registerAnswer("strangerQuestion",{text = "No thanks.",addText = "You ASKED for it!! HAHAHAHA!",chosenFunction = function() player:kill() SFX.play("_OST/_Sound Effects/evil-laugh.ogg") end})



littleDialogue.registerAnswer("strangerQuestionTwo",{text = "Nonononono!",addText = "Huh... well imma kill someone else now, bye!"})
littleDialogue.registerAnswer("strangerQuestionTwo",{text = "YES!",addText = "Well today's your LUCKY DAY!!!! HAHAHAHA!",chosenFunction = function() player:kill() SFX.play("_OST/_Sound Effects/evil-laugh.ogg") end})



littleDialogue.registerAnswer("starcountinfo",{text = "Sure",chosenFunction = function() triggerEvent("StarList") end})
littleDialogue.registerAnswer("starcountinfo",{text = "No thanks",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("generalcountinfo",{text = "Sure",chosenFunction = function() triggerEvent("GeneralList") end})
littleDialogue.registerAnswer("generalcountinfo",{text = "No thanks",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("othercountinfo",{text = "Sure",chosenFunction = function() triggerEvent("OtherList") end})
littleDialogue.registerAnswer("othercountinfo",{text = "No thanks",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("malcbeginmsg",{text = "Warp me to the Side Quest Levels",addText = "PROCESS ACCEPTED. ENTER THE PIPE TO MEET YOUR SATISFACTION.",chosenFunction = function() triggerEvent("SideQuestWarpOpen") end})
littleDialogue.registerAnswer("malcbeginmsg",{text = "Warp me to the DLC World",addText = "PROCESS ACCEPTED. ENTER THE PIPE TO MEET YOUR SATISFACTION.",chosenFunction = function() triggerEvent("DLCWarpOpen") end})
littleDialogue.registerAnswer("malcbeginmsg",{text = "Nevermind",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("AmIChristian",{text = "Yes",addText = "Oh! Well then I guess I didn't offend you!"})
littleDialogue.registerAnswer("AmIChristian",{text = "No",addText = "I am SO sorry... whatever religion you believe, you believe it!<page>It's not in MY control to convert you to anything!"})