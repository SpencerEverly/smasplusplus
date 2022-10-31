local level_dependencies_normal = require("level_dependencies_hub")
local malcmusic = require ("malcmusic")
local littleDialogue = require("littleDialogue")
local HUDimage = Graphics.loadImage("MALC-HUD.png")
local playerManager = require("playerManager")
local areaNames = require("areaNames")
local textplus = require("textplus")
local ShopSystem = require("ShopSystem/ShopSystem")
local anothercurrency = require("ShopSystem/anothercurrency")
local smashud = require("smashud")

-- Images --
local shopItems = Graphics.loadImageResolved("ShopSystem/ShopSystem/shopItems.png")
local coinsIcon = Graphics.loadImageResolved("ShopSystem/ShopSystem/coinImage.png")

-- anothercurrency stuff --
coinCounter = anothercurrency.registerCurrency("totalcoins", true)

-- shopsystem stuff --
local myShop = ShopSystem.create{music = "_OST/Super Mario Bros Spencer/Shop.ogg"}

local mushroom = myShop:RegisterItem{NPCid =   9, inEgg = true, image = shopItems, price = 10,  amount = 5, name = "Mushroom", sourceX = 0, sourceY = 0, sourceWidth = 32, sourceHeight = 32, currency = coinCounter}
local fire =     myShop:RegisterItem{NPCid =  14, image = shopItems, price = 30,  amount = 5, name = "Fire Flower", description = "A burning flower!? Use this to shoot towards enemies.", sourceX = 0, sourceY = 32, sourceWidth = 32, sourceHeight = 32, currency = coinCounter}
local leaf =     myShop:RegisterItem{NPCid =  34, image = shopItems, price = 50,  amount = 5, name = "Leaf", sourceX = 0, sourceY = 64, sourceWidth = 32, sourceHeight = 32, currency = coinCounter, description = "<wave 2>Something seems strange about this leaf...</wave> You can wave your tail towards enemies with it."}
local tanooki =  myShop:RegisterItem{NPCid = 169, image = shopItems, price = 250,  amount = 5, name = "Tanooki Suit", sourceX = 0, sourceY = 96, sourceWidth = 32, sourceHeight = 32, currency = coinCounter, description = "Turn into a statue with this suit!"}
local hammer =   myShop:RegisterItem{NPCid = 170, inEgg = true, image = shopItems, price = 250,  amount = 5, name = "Hammer Suit", sourceX = 0, sourceY = 128, sourceWidth = 32, sourceHeight = 32, currency = coinCounter, description = "No one stands a chance if you wear this suit. Hammer throwing for the win!"}
local ice =      myShop:RegisterItem{NPCid = 264, inEgg = true, image = shopItems, price = 1000,  amount = 5, name = "Ice Flower", sourceX = 0, sourceY = 160, sourceWidth = 32, sourceHeight = 32, currency = coinCounter, description = "It's so cold! Use this to freeze enemies."}
local yoshigreen =      myShop:RegisterItem{NPCid = 95, inEgg = true, price = 250,  amount = 5, name = "Yoshi (Green)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies!"}
local yoshired =      myShop:RegisterItem{NPCid = 100, inEgg = true, price = 250,  amount = 5, name = "Yoshi (Red)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies!"}
local yoshiblue =      myShop:RegisterItem{NPCid = 98, inEgg = true, price = 250,  amount = 5, name = "Yoshi (Blue)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies!"}
local yoshiyellow =      myShop:RegisterItem{NPCid = 99, inEgg = true, price = 250,  amount = 5, name = "Yoshi (Yellow)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies!"}
local yoshipurple =      myShop:RegisterItem{NPCid = 149, inEgg = true, price = 250,  amount = 5, name = "Yoshi (Purple)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies!"}
local yoshipink =      myShop:RegisterItem{NPCid = 150, inEgg = true, price = 250,  amount = 5, name = "Yoshi (Pink)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies!"}
local yoshicyan =      myShop:RegisterItem{NPCid = 228, inEgg = true, price = 250,  amount = 5, name = "Yoshi (Cyan)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies!"}
local yoshiblack =      myShop:RegisterItem{NPCid = 148, inEgg = true, price = 250,  amount = 5, name = "Yoshi (Black)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies!"}
local yoshiorange =      myShop:RegisterItem{NPCid = 988, inEgg = true, price = 500,  amount = 5, name = "Yoshi (Orange)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies! <tremble 1>Looks like a rare Yoshi...!</tremble>"}
local yoshiwhite =      myShop:RegisterItem{NPCid = 990, inEgg = true, price = 600,  amount = 5, name = "Yoshi (White)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies! <tremble 1>Looks like a rare Yoshi...!</tremble>"}
local yoshibrown =      myShop:RegisterItem{NPCid = 992, inEgg = true, price = 700,  amount = 5, name = "Yoshi (Brown)", currency = coinCounter, description = "Yoshi is your companion to bring to any level and eat enemies! <tremble 1>Looks like a rare Yoshi...!</tremble>"}

mushroom.description = "<tremble 1>Mmm.. a tasty mushroom!</tremble>"

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

littleDialogue.registerStyle("smwjapanese",{

})

areaNames.sectionNames = {
    [0] = "Me and Larry City (Main City)",
    [1] = "Building 3: ???",
    [2] = "Building 2: Hotel",
    [3] = "Building 4: Town Hall",
    [4] = "Building 1: Tourist Center",
    [5] = "Building 5: The True Ending",
    [6] = "Me and Larry City (Side Quest Area 1)",
    [7] = "Building 7: Plumber Area",
    [8] = "Hotel: Floors 1-5",
    [9] = "Information Booth",
    [10] = "Me and Larry City (Side Quest Area 2 & Ocean)",
    [11] = "Me and Larry City (Warp Zone)",
    [12] = "Character Switch Room",
    [13] = "Character Testing Area",
    [14] = "Building 6: Shop Area",
}

function Stage0()
    local layer1 = Layer.get("Stage 0.5 - 4 Stars")
    local layer2 = Layer.get("Stage 5 - Construction")
    local layer3 = Layer.get("Stage 0 - 0 Stars (TC)")
    local layer4 = Layer.get("Stage 2 and Beyond - Mayor")
    layer1:show(true)
    layer2:show(true)
    layer3:hide(true)
    layer4:hide(true)
end

function Stage1()
    local layer1 = Layer.get("Stage 1 - 10 Stars")
    local layer2 = Layer.get("Stage 5 - Construction")
    local layer3 = Layer.get("Stage 0 - 0 Stars")
    local layer4 = Layer.get("Stage 0 - 0 Stars (TC)")
    local layer5 = Layer.get("Stage 2 and Beyond - Mayor")
    layer1:show(true)
    layer2:show(true)
    layer3:hide(true)
    layer4:hide(true)
    layer5:hide(true)
end

function Stage2()
    local layer1 = Layer.get("Stage 2 - 16 Stars")
    local layer2 = Layer.get("Stage 5 - Construction")
    local layer3 = Layer.get("Stage 0 - 0 Stars")
    local layer4 = Layer.get("Stage 0 - 0 Stars (TC)")
    local layer5 = Layer.get("Stage 2 and Beyond - Mayor")
    layer1:show(true)
    layer2:show(true)
    layer3:hide(true)
    layer4:hide(true)
    layer5:show(true)
end

function Stage3()
    local layer1 = Layer.get("Stage 3 - 22 Stars")
    local layer2 = Layer.get("Stage 5 - Construction")
    local layer3 = Layer.get("Stage 0 - 0 Stars")
    local layer4 = Layer.get("Stage 0 - 0 Stars (TC)")
    local layer5 = Layer.get("Stage 2 and Beyond - Mayor")
    layer1:show(true)
    layer2:show(true)
    layer3:hide(true)
    layer4:hide(true)
    layer5:show(true)
end

function Stage4()
    local layer1 = Layer.get("Stage 4 - 28 Stars")
    local layer2 = Layer.get("Stage 5 - Construction")
    local layer3 = Layer.get("Stage 0 - 0 Stars")
    local layer4 = Layer.get("Stage 0 - 0 Stars (TC)")
    local layer5 = Layer.get("Stage 2 and Beyond - Mayor")
    layer1:show(true)
    layer2:show(true)
    layer3:hide(true)
    layer4:hide(true)
    layer5:show(true)
end

function Stage5()
    local layer1 = Layer.get("Stage 5 - 32 Stars")
    local layer2 = Layer.get("Stage 5 - Renovation")
    local layer3 = Layer.get("Stage 0 - 0 Stars")
    local layer4 = Layer.get("Stage 0 - 0 Stars (TC)")
    local layer5 = Layer.get("Stage 2 and Beyond - Mayor")
    local layer6 = Layer.get("Stage 5 - Construct Stage 1")
    local layer7 = Layer.get("Stage 5 - Construction")
    layer1:show(true)
    layer2:show(true)
    layer3:hide(true)
    layer4:hide(true)
    layer5:show(true)
    layer6:show(true)
    layer7:hide(true)
    Sound.changeMusic("_OST/Me and Larry City/Story Mode Hub Theme 3, With Building Sounds (Super Mario Maker 2).ogg", 4)
end

function Stage6()
    local layer1 = Layer.get("Stage 6 - 38 Stars")
    local layer2 = Layer.get("Stage 5 - Renovation")
    local layer3 = Layer.get("Stage 0 - 0 Stars")
    local layer4 = Layer.get("Stage 0 - 0 Stars (TC)")
    local layer5 = Layer.get("Stage 2 and Beyond - Mayor")
    local layer6 = Layer.get("Stage 6 - Construct Stage 2")
    local layer7 = Layer.get("Stage 5 - Construction")
    local layer8 = Layer.get("Stage 6 - Yoshi Rooms Unfinished 1")
    layer1:show(true)
    layer2:show(true)
    layer3:hide(true)
    layer4:hide(true)
    layer5:show(true)
    layer6:show(true)
    layer7:hide(true)
    layer8:show(true)
    Sound.changeMusic("_OST/Me and Larry City/Story Mode Hub Theme 3, With Building Sounds (Super Mario Maker 2).ogg", 4)
end

function Stage7()
    local layer1 = Layer.get("Stage 7 - 44 Stars")
    local layer2 = Layer.get("Stage 5 - Renovation")
    local layer3 = Layer.get("Stage 0 - 0 Stars")
    local layer4 = Layer.get("Stage 0 - 0 Stars (TC)")
    local layer5 = Layer.get("Stage 2 and Beyond - Mayor")
    local layer6 = Layer.get("Stage 6 - Construct Stage 2")
    local layer7 = Layer.get("Stage 5 - Construction")
    local layer8 = Layer.get("Stage 7 - Yoshi Rooms Finished")
    layer1:show(true)
    layer2:show(true)
    layer3:hide(true)
    layer4:hide(true)
    layer5:show(true)
    layer6:show(true)
    layer7:hide(true)
    layer8:show(true)
end

function onStart()
    if SaveData.disableX2char == nil then
        SaveData.disableX2char = false
    end
    if not SaveData.disableX2char then
        triggerEvent("ShowX2Stuff")
    elseif SaveData.disableX2char then
        triggerEvent("HideX2Stuff")
        for _,p in ipairs(Player.get()) do
            p.setCostume(1, nil)
            p.setCostume(2, nil)
            p.setCostume(3, nil)
            p.setCostume(4, nil)
            p.setCostume(5, nil)
        end
    end
    if not malcmusic.holiday then --and SaveData.genosideStage <= 2 and SaveData.currentCostume ~= "UNDERTALE-FRISK" then
        if SaveData.totalStarCount >= 4 and SaveData.totalStarCount <= 9 then
            Routine.run(Stage0)
        end
        if SaveData.totalStarCount >= 10 and SaveData.totalStarCount <= 15 then
            Routine.run(Stage1)
        end
        if SaveData.totalStarCount >= 16 and SaveData.totalStarCount <= 21 then
            Routine.run(Stage2)
        end
        if SaveData.totalStarCount >= 22 and SaveData.totalStarCount <= 27 then
            Routine.run(Stage3)
        end
        if SaveData.totalStarCount >= 28 and SaveData.totalStarCount <= 31 then
            Routine.run(Stage4)
        end
        if SaveData.totalStarCount >= 32 and SaveData.totalStarCount <= 37 then
            Routine.run(Stage5)
        end
        if SaveData.totalStarCount >= 38 and SaveData.totalStarCount <= 43 then
            Routine.run(Stage6)
        end
        if SaveData.totalStarCount >= 44 then
            Routine.run(Stage7)
        end
    end
    --if SaveData.genosideStage >= 3 and SaveData.currentCostume == "UNDERTALE-FRISK" then
    --    triggerEvent("StageGenoside")
    --end
end

function onDraw()
    Graphics.drawImageWP(HUDimage, 0, 0, -4.69)
    
    if player.section == 9 then
        textplus.print{x=-19760, y=-20272, text = "Floor 1: Star List", priority=-86, color=Color.white, sceneCoords=true, font=infobooth1}
        textplus.print{x=-19808, y=-20656, text = "Floor 2: General Info", priority=-86, color=Color.white, sceneCoords=true, font=infobooth1}
        textplus.print{x=-19776, y=-21104, text = "Floor 3: Other Info", priority=-86, color=Color.white, sceneCoords=true, font=infobooth1}
    end
    if ShopSystem.activeShop.id ~= nil then -- detect if ANY shop is currently open
        Graphics.drawBox{texture = coinsIcon, x = ShopSystem.movement.sidePanels.position + 22, y = 292, priority = ShopSystem.leastPriority + 0.65}
        textplus.print{x = ShopSystem.movement.sidePanels.position + 58, y = 300, text = string.format("%04d", coinCounter:getMoney()), font = ShopSystem.font, priority = ShopSystem.leastPriority + 0.65}
    end
end

function onTick()
    if player.section == 9 then
        --Text.printWP("Welcome to the information booth.", 10, 577, 4.9)
    end
end

function onEvent(eventName)
    if eventName == "SideQuestWarpOpen" then
        Sound.playSFX(27)
    end
    if eventName == "DLCWarpOpen" then
        Sound.playSFX(27)
    end
    if eventName == "ShopOpen2" then
        myShop:open()
    end
    if eventName == "StarList" then
        littleDialogue.create({text = "<boxStyle infobooth>OUR RECORDS SHOW THAT YOU HAVE AT LEAST "..SaveData.totalStarCount.." STARS IN YOUR GAME PROGRESSION.<page>THE STARS YOU HAVE COLLECTED IN THE MANDATORY LEVELS IS "..#SaveData.completeLevels..". THE STARS YOU HAVE COLLECTED IN ALL OTHER LEVELS IS "..#SaveData.completeLevelsOptional..".<page>THE STAR COUNT OF EVERY STAR YOU COLLECTED OVERALL IS "..SaveData.starsgrabbed..".<page>TO FINISH YOUR GAME AND UNLOCK THE TRUE ENDING, YOU'LL NEED TO COLLECT "..(999 - SaveData.totalStarCount).." MORE.<page>THANKS FOR PROCESSING THE INFORMATION I HAVE EXPLAINED. GOOD DAY."})
    end
    if eventName == "GeneralList" then
        littleDialogue.create({text = "<boxStyle infobooth>OUR RECORDS SHOW THAT YOU HAVE GOT "..SaveData.GameOverCount.." GAME OVERS IN YOUR GAME PROGRESSION.<page>YOU ALSO HAVE RECENTLY WENT IN (number) LEVELS.<page>THE SCORE COUNT IS "..SaveData.totalScoreClassic.." AND THE COIN COUNT IS "..SaveData.totalCoinsClassic..".<page>YOU HAVE ALSO STOMPED ON "..SaveData.goombaStomps.." GOOMBAS, AND "..SaveData.koopaStomps.." KOOPA TROOPAS.<page>THE TOTAL AMOUNT OF COINS COLLECTED OVERALL IS "..SaveData.totalcoins..".<page>OVERALL, YOU HAVE USED "..SaveData.totalmushrooms.." MUSHROOMS, "..SaveData.totalfireflowers.." FIRE FLOWERS, "..SaveData.totalleafs.." SUPER LEAFS, "..SaveData.totaltanookis.." TANOOKI SUITS, "..SaveData.totalhammersuits.." HAMMER SUITS, AND "..SaveData.totaliceflowers.." ICE FLOWERS.<page>YOU ALSO GRABBED "..SaveData.starsgrabbed.." TOTAL STARS REGARDLESS OF COMPLETION OR NOT, USED "..SaveData.starmansused.." STARMANS, "..SaveData.megamushroomssused.." MEGA MUSHROOMS,<page>AND I HOPE YOU'VE HAD A FUN TIME.<page>THANKS FOR PROCESSING THE INFORMATION I HAVE EXPLAINED. GOOD DAY."})
    end
    if eventName == "OtherList" then
        littleDialogue.create({text = "<boxStyle infobooth>OUR RECORDS SHOW THAT YOU HAVE DIED "..SaveData.deathCount.." TIMES.<page>THANKS FOR PROCESSING THE INFORMATION I HAVE EXPLAINED. GOOD DAY."})
    end
    --if eventName == "Stage5" then
        --Section(4).musicPath = "_OST/Me and Larry City/Story Mode Hub Theme 3, With Building Sounds (Super Mario Maker 2).ogg"
    --end
    --if eventName == "Stage6" then
        --Section(4).musicPath = "_OST/Me and Larry City/Story Mode Hub Theme 3, With Building Sounds (Super Mario Maker 2).ogg"
    --end
    if eventName == ("DisEnabledX2Char") then
        if SaveData.disableX2char == false then
            triggerEvent("HUBDisableX2")
            Level.load(Level.filename())
        end
        if SaveData.disableX2char == true then
            triggerEvent("HUBEnableX2")
            Level.load(Level.filename())
        end
    end
    if eventName == "HUBEnableX2" then
        SaveData.disableX2char = false
    end
    if eventName == "HUBDisableX2" then
        SaveData.disableX2char = true
        Graphics.activateHud(false)
        Cheats.trigger("1player")
        Defines.player_hasCheated = false
    end
    if eventName == "HourChange" then
        Sound.playSFX("hour-change.ogg")
    end
end

function onExit()
    if player:mem(0x15E, FIELD_WORD) == 65 and player.forcedState == FORCEDSTATE_INVISIBLE then --DLC World
        SaveData.smwMap.playerX = -199584
        SaveData.smwMap.playerY = -196768
    end
    if player:mem(0x15E, FIELD_WORD) == 38 and player.forcedState == FORCEDSTATE_INVISIBLE then --Side Quest
        SaveData.smwMap.playerX = -195616
        SaveData.smwMap.playerY = -196736
    end
end


-- Register questions


littleDialogue.registerAnswer("shopstuff",{text = "Buy something",addText = "Alright! Whadda need?",chosenFunction = function() triggerEvent "ShopOpen" end})
littleDialogue.registerAnswer("shopstuff",{text = "What is this?",addText = "This is the Me and Larry City Shop, full of rarities and things that's valuable!<page>As you collect coins, you have a total coin count you collect throughout your journey to spend on stuff here.<page>Spend wisely, is all I say! These items are worth your valuables!<page>That is all. Talk to me again if you need anything. Come again!"})
littleDialogue.registerAnswer("shopstuff",{text = "Nevermind.",addText = "Okay! Let me know if you need anything. Come again!"})


littleDialogue.registerAnswer("favgame1",{text = "Super Mario All-Stars Plus Plus",addText = "This must be the best game then, isn't it? I love it too!"})
littleDialogue.registerAnswer("favgame1",{text = "EarthBound",addText = "Is that the Trading Company or something? That name isn't familiar. Oh well..."})
littleDialogue.registerAnswer("favgame1",{text = "Sonic the Hedgehog",addText = "Heh, such a hedgehog! I really like Sonic Mania! It's the best."})
littleDialogue.registerAnswer("favgame1",{text = "Super Mario 64",addText = "Hey, that's what I played! I forgot what it was called. Thank for reminding me!"})
littleDialogue.registerAnswer("favgame1",{text = "Have you even played a video game before?",addText = "Yes, I think it had this one objective to collect stars, but I don't know what it was called..."})
littleDialogue.registerAnswer("favgame1",{text = "Aren't we all in a video game?",addText = "...really? You must be that hero that's splitting facts or something!"})





littleDialogue.registerAnswer("strike1",{text = "No thanks",addText = "I hate you, you stupid hero!"})
littleDialogue.registerAnswer("strike1",{text = "Sure",addText = "That's one signature ahead of our goal! Thanks, hero!"})





littleDialogue.registerAnswer("mayoradvice",{text = "My name is wrong (Or something isn't right).",addText = "If you're name is wrong, don't direct it to me! Direct it to Spencer Everly. They'll fix the issue on the next update.<page>Spencer should be able to reach you on Discord at Spencer Everly#1997.<page>Or use their email at spencer.everly@gmail.com.<page>Or you can report bugs on the official GitHub page.<page>Reporting bugs makes the player experience a lot better if you do these things!"})
littleDialogue.registerAnswer("mayoradvice",{text = "Give me advice.",addText = "Sure thing! Here is what you need to know:<page>Unfinished advice is the advice that's never gonna get answered until the game's first version is released.<page>That means wait until the full release."})
littleDialogue.registerAnswer("mayoradvice",{text = "Why is everyone orange guns?",addText = "Because Spencer Everly was a dumb kid who made this species. I don't have anything else to say."})
littleDialogue.registerAnswer("mayoradvice",{text = "Is life even good anymore?",addText = "If you feel suicidal, call 988.<page>I can't see another life taken away from me, and NOT right here."})
littleDialogue.registerAnswer("mayoradvice",{text = "Where am I?",addText = "You're in Mars, in the biggest city of the planet, Me and Larry City.<page>Filled with tall buildings and many areas, us Mearians roam through life trying to live and survive like any other human does.<page>Where did we come from? Why are we here? Why can't we live with humans in peace?<page>Nobody knows..."})
littleDialogue.registerAnswer("mayoradvice",{text = "Nevermind.",addText = "Gotcha. Let me know if you need anything."})





littleDialogue.registerAnswer("mayoradvicehigh",{text = "My name is wrong (Or something isn't right).",addText = "Do a... email...<page>spencer.everly@outloo... uh, yahoo... uh...<page>No... it's gmail.com... yeah.<page>Email that."})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Give me advice.",addText = "Advise 1: I want more weed.<page>Advise 2: Then give me more weed.<page>Advise 3: Uh... I forgot, what again?"})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Why is everyone orange guns?",addText = "Because tomatoes talk in... a show... I forgot."})
littleDialogue.registerAnswer("mayoradvicehigh",{text = "Is life even good anymore?",addText = "Call the 988 number.<page>It's a number... weed, ack!"})
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
littleDialogue.registerAnswer("strangerQuestion",{text = "No thanks.",addText = "You ASKED for it!! HAHAHAHA!",chosenFunction = function() player:kill() Sound.playSFX("evil-laugh.ogg") end})



littleDialogue.registerAnswer("strangerQuestionTwo",{text = "Nonononono!",addText = "Huh... well imma kill someone else now, bye!"})
littleDialogue.registerAnswer("strangerQuestionTwo",{text = "YES!",addText = "Well today's your LUCKY DAY!!!! HAHAHAHA!",chosenFunction = function() player:kill() Sound.playSFX("evil-laugh.ogg") end})



littleDialogue.registerAnswer("starcountinfo",{text = "Sure",chosenFunction = function() triggerEvent("StarList") end})
littleDialogue.registerAnswer("starcountinfo",{text = "No thanks",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("generalcountinfo",{text = "Sure",chosenFunction = function() triggerEvent("GeneralList") end})
littleDialogue.registerAnswer("generalcountinfo",{text = "No thanks",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("othercountinfo",{text = "Sure",chosenFunction = function() triggerEvent("OtherList") end})
littleDialogue.registerAnswer("othercountinfo",{text = "No thanks",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("malcbeginmsg",{text = "Warp me to the Side Quest Levels",addText = "PROCESS ACCEPTED. ENTER THE PIPE TO MEET YOUR SATISFACTION.",chosenFunction = function() triggerEvent("SideQuestWarpOpen") end})
littleDialogue.registerAnswer("malcbeginmsg",{text = "Warp me to the DLC/Extra Game World",addText = "PROCESS ACCEPTED. ENTER THE PIPE TO MEET YOUR SATISFACTION.",chosenFunction = function() triggerEvent("DLCWarpOpen") end})
littleDialogue.registerAnswer("malcbeginmsg",{text = "Nevermind",addText = "PROCESS ACCEPTED. COME BACK ANYTIME."})




littleDialogue.registerAnswer("AmIChristian",{text = "Yes",addText = "Oh! Well then I guess I didn't offend you!"})
littleDialogue.registerAnswer("AmIChristian",{text = "No",addText = "I am SO sorry... whatever religion you believe, you believe it!<page>It's not in MY control to convert you to anything!"})