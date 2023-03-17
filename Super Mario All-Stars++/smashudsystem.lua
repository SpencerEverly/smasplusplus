--smashudsystem, or anotherHudSystem by Spencer Everly
--Check all the comments, plus the end of the file for more info

local Routine = require("routine")
local extrasounds = require("extrasounds")
local rng = require("base/rng")
local textplus = require("textplus")
local battledependencies = require("classicbattlemode")
battledependencies.battlemodeactive = false

local hudfont = textplus.loadFont("littleDialogue/font/1.ini")

local smashudsystem = {} --This is the old name of the library. Rather than change it, I went ahead and kept the name for compatibility.

if SaveData.deathCount == nil then --Death count! For outside 1.3 mode, and inside it
    SaveData.deathCount = 0
end
if SaveData.totalLives == nil then --The total lives used the for the episode.
    SaveData.totalLives = 5
end
if SaveData.totalCoinsClassic == nil then --The temporary coins used during the level, for 1UPs when reaching 100 coins
    SaveData.totalCoinsClassic = 0
end
if SaveData.totalScoreClassic == nil then --The score, since I wanna remake it because why not
    SaveData.totalScoreClassic = 0
end
if SaveData.totalCherries == nil then
    SaveData.totalCherries = 0
end

local deathFrames = {
    [CHARACTER_MARIO] = 3,
    [CHARACTER_LUIGI] = 5,
    [CHARACTER_PEACH] = 129,
    [CHARACTER_TOAD]  = 130,
    [CHARACTER_LINK]  = 134,
    [CHARACTER_MEGAMAN]  = 149,
    [CHARACTER_WARIO]  = 150,
    [CHARACTER_BOWSER]  = 151,
    [CHARACTER_KLONOA]  = 152,
    [CHARACTER_NINJABOMBERMAN] = 153,
    [CHARACTER_ROSALINA] = 154,
    [CHARACTER_ZELDA] = 156,
    [CHARACTER_UNCLEBROADSWORD] = 159,
    [CHARACTER_SAMUS] = 161,
    [CHARACTER_ULTIMATERINKA] = 157,
    [CHARACTER_SNAKE] = 160,
}

local killed = false
local ready = false
local time = 0
local opacity = math.min(1,time/42)
local fadeoutcompleted = false

local killed1 = false
local killed2 = false

local deathTimer = 0

function smashudsystem.onInitAPI() --This requires all the libraries that will be used
    registerEvent(smashudsystem, "onStart")
    registerEvent(smashudsystem, "onDraw")
    registerEvent(smashudsystem, "onExit")
    registerEvent(smashudsystem, "onTick")
    registerEvent(smashudsystem, "onPlayerHarm")
    registerEvent(smashudsystem, "onPlayerKill")
    registerEvent(smashudsystem, "onPostPlayerKill")
    registerEvent(smashudsystem, "onPostNPCKill")
    registerEvent(smashudsystem, "onPostBlockHit")
    
    ready = true
end

local gameoveractivate = false
local gameoveractivate2 = false
local gameovershow = false
local blackscreenonly = false

--if SaveData.GameOverCount == nil then
    --SaveData.GameOverCount = 0 --This is only when the library publically releases for the wild to use
--end

smashudsystem.hasDied = false --If the player died or not
smashudsystem.exittomap = false --Whenever to exit to the map after dying instead of reloading the level afterward (Not commonly used as reloading the level is much faster than kicking straight to the map)
smashudsystem.activated = true --Whenever the death animation is activated

function addsmashpoints(block, fromUpper, playerornil) --This will add 50 points from smashing bricks, as said from the source code.
    Routine.waitFrames(2, true)
    if block.isHidden and block.layerName == "Destroyed Blocks" then
        console:println("Brick "..tostring(block.idx).." was smashed.")
        SaveData.totalScoreClassic = SaveData.totalScoreClassic + 50
    end
end

function detecttopcoin(block, fromUpper, playerornil)
    if not fromUpper then
        for k,v in NPC.iterateIntersecting(block.x, block.y - 32, block.x + 32, block.y) do
            if NPC.config[v.id].iscoin and not v.isHidden and not v.isGenerator then
                console:println("Coin from a top of a block was collected.")
                SaveData.totalCoinsClassic = SaveData.totalCoinsClassic + 1
                break
            end
        end
    end
end

function smashudsystem.onStart()
    SaveData.totalCherries = 0 --Reset cherry count because each level has a different cherry count
end

function smashudsystem.onPostBlockHit(block, fromUpper, playerornil) --Let's start off with block hitting.
    local bricksnormal = table.map{4,60,90,188,226,293} --These are a list of breakable bricks, without the Super Metroid breakable.
    local questionblocks = table.map{5,88,193,224} --A list of question mark blocks
    if not smasbooleans.mainMenuActive then
        if playerornil then
            if block.contentID == 1000 or block.contentID == 0 or playerornil.character == CHARACTER_TOAD or playerornil.character == CHARACTER_KLONOA then
                SaveData.totalCoinsClassic = SaveData.totalCoinsClassic
            elseif block.contentID <= 99 and block.contentID >= 1 then
                console:println("One coin from a block collected.")
                SaveData.totalCoinsClassic = SaveData.totalCoinsClassic + 1
            end
        end
        --**BRICK SMASHING**
        if bricksnormal[block.id] then
            Routine.run(addsmashpoints, block, fromUpper, playerornil)
        end
        --**COIN TOP DETECTION**
        if bricksnormal[block.id] or questionblocks[block.id] then
            Routine.run(detecttopcoin, block, fromUpper, playerornil)
        end
    end
end

function smashudsystem.onPostNPCKill(npc, harmtype, player) --This will add coins to the classic counter.
    if not smasbooleans.mainMenuActive then
        for _,p in ipairs(Player.get()) do
            
            
            if smastables.allCoinNPCIDs[npc.id] and (Colliders.collide(p, npc) or Colliders.speedCollide(p, npc) or Colliders.slash(p, npc) or Colliders.downSlash(p, npc)) then
                console:println("One coin from colliding collected.")
                SaveData.totalCoinsClassic = SaveData.totalCoinsClassic + 1 --One coin collected
            end
            
            
            if npc.id == 558 and (Colliders.collide(p, npc) or Colliders.speedCollide(p, npc) or Colliders.slash(p, npc) or Colliders.downSlash(p, npc)) then
                console:println("One cherry from colliding collected.")
                SaveData.totalCherries = SaveData.totalCherries + 1 --One cherry collected
            end
        end
    end
end

function smashudsystem.gameOverSequences() --These are all the game over sequences that get RNG'ed. ONLY use this on a Routine call!!!!
    local rngkey = rng.randomInt(1,29) --This will randomly sort an rng where it picks a random game over track to play.
    
    console:println("Game over "..tostring(rngkey).." will now be played.")
    
    Sound.playSFX("gameover/gameover-"..rngkey..".ogg")
    
    --If any rng'ed number is any numbers below, do an specific routine timer which plays the whole thing
    if rngkey == 1 then
        Routine.wait(3, true)
        
    elseif rngkey == 2 then
        Routine.wait(5, true)
        
    elseif rngkey == 3 then
        Routine.wait(3, true)
        
    elseif rngkey == 4 then
        Routine.wait(3, true)
        
    elseif rngkey == 5 then
        Routine.wait(5, true)
        
    elseif rngkey == 6 then
        Routine.wait(4, true)
        
    elseif rngkey == 7 then
        Routine.wait(2, true)
        
    elseif rngkey == 8 then
        Routine.wait(6, true)
        
    elseif rngkey == 9 then
        Routine.wait(3, true)
        
    elseif rngkey == 10 then
        Routine.wait(14, true)
        
    elseif rngkey == 11 then
        Routine.wait(10, true)
        
    elseif rngkey == 12 then
        Routine.wait(10, true)
        
    elseif rngkey == 13 then
        Routine.wait(5, true)
        
    elseif rngkey == 14 then
        Routine.wait(6, true)
    
    elseif rngkey == 15 then
        Routine.wait(6, true)
        
    elseif rngkey == 16 then
        Routine.wait(7, true)
        
    elseif rngkey == 17 then
        Routine.wait(3, true)
        
    elseif rngkey == 18 then
        Routine.wait(4, true)
        
    elseif rngkey == 19 then
        Routine.wait(7, true)
        
    elseif rngkey == 20 then
        Routine.wait(9, true)
        
    elseif rngkey == 21 then
        Routine.wait(3, true)
        
    elseif rngkey == 22 then --This one is exceptional, since it's the GoAnimate Grounded game over screen, feat. Boris
        console:println("Kayloo how dare you read this that's it you're grounded grounded grounded grounded for 43904568949 years go to bed now")
        Sound.playSFX("gameover/gameover-22-voice.ogg")
        Routine.wait(17, true)
        
    elseif rngkey == 23 then
        Routine.wait(4, true)
        
    elseif rngkey == 24 then
        Routine.wait(6, true)
        
    elseif rngkey == 25 then
        Routine.wait(6, true)
        
    elseif rngkey == 26 then
        Routine.wait(5, true)
        
    elseif rngkey == 27 then
        Routine.wait(8, true)
        
    elseif rngkey == 28 then
        Routine.wait(8, true)
    
    elseif rngkey == 29 then
        Routine.wait(6, true)
        
        
    end
end

function thirteenModeDeath()
    console:println("Everyone has died.")
    smasbooleans.musicMuted = true
    Audio.MusicVolume(0)
    if SaveData.totalLives < 0 and SaveData.enableLives then
        gameoveractivate = true
        SaveData.totalLives = 0
    elseif SaveData.totalLives < 0 and not SaveData.enableLives then
        gameoveractivate2 = true
    end
    Routine.waitFrames(195)
    if not gameoveractivate then
        blackscreenonly = true
        Misc.pause()
        Routine.waitFrames(45, true)
        if gameoveractivate2 then
            SaveData.totalLives = 5
        end
        Misc.unpause() --Unpause afterward
    end
    if gameoveractivate then --Quick game over screen stuff.
        blackscreenonly = true
        Misc.pause()
        Routine.waitFrames(45, true)
        gameovershow = true --Show the GAME OVER text
        SaveData.GameOverCount = SaveData.GameOverCount + 1 --Increase a game over count marker
        smashudsystem.gameOverSequences()
        Misc.unpause() --Unpause afterward
        SaveData.totalLives = 5 --Refill the lives back to 5
    end
    smasbooleans.musicMuted = false
    smashudsystem.hasDied = true --The player has now died
    if smashudsystem.exittomap == false then
        Level.load(Level.filename())
    elseif smashudsystem.exittomap == true then
        Level.load("map.lvlx")
    end
end

function diedanimation(plr) --The entire animation when dying. The pause and sound is there to avoid not animating at all, but is IS a nice touch
    if smashudsystem.activated then
        if not smasbooleans.mainMenuActive then
            if not Misc.inMarioChallenge() then
                if not SaveData.disableX2char then
                    if not battledependencies.battlemodeactive then
                        console:println("The player has died.")
                        if (player.character == CHARACTER_MARIO) == true or (player.character == CHARACTER_LUIGI) == true or (player.character == CHARACTER_PEACH) == true or (player.character == CHARACTER_TOAD) == true or (player.character == CHARACTER_LINK) == true or (player.character == CHARACTER_MEGAMAN) == true or (player.character == CHARACTER_WARIO) == true or (player.character == CHARACTER_BOWSER) == true or (player.character == CHARACTER_KLONOA) == true or (player.character == CHARACTER_ROSALINA) == true or (player.character == CHARACTER_SNAKE) == true or (player.character == CHARACTER_ZELDA) == true or (player.character == CHARACTER_ULTIMATERINKA) == true or (player.character == CHARACTER_UNCLEBROADSWORD) == true or (player.character == CHARACTER_SAMUS) == true then
                            if player.deathTimer == 0 then
                                smasbooleans.musicMuted = true
                                Audio.MusicVolume(0)
                                SaveData.deathCount = SaveData.deathCount + 1 --This marks a death count, for info regarding how many times you died
                                SaveData.totalLives = SaveData.totalLives - 1 --This marks a life lost
                                if SaveData.totalLives < 0 and SaveData.enableLives then --If less than 0, the quick game over screen will activate
                                    console:println("A game over screen will occur.")
                                    gameoveractivate = true
                                    SaveData.totalLives = 0
                                elseif SaveData.totalLives < 0 and not SaveData.enableLives then
                                    gameoveractivate2 = true
                                end
                                Misc.saveGame() --Save the game to save what we've added/edited
                                Routine.waitFrames(165)
                                Misc.pause()
                                fadeoutdeath = true --This starts the fade out animation
                                Routine.waitFrames(110, true)
                                smasbooleans.musicMuted = false
                                Misc.unpause()
                                if gameoveractivate == false then --If not in a gameover state...
                                    fadeoutcompleted = true --...when waited enough time, unpause and reload the level
                                end
                                if fadeoutcompleted then
                                    if gameoveractivate2 then
                                        SaveData.totalLives = 5
                                    end
                                    smashudsystem.hasDied = true
                                    if smashudsystem.exittomap == false then --Reload the level from here
                                        Level.load(Level.filename())
                                    elseif smashudsystem.exittomap == true then --Or else, just exit the level. It can be smwMap, or the vanilla map
                                        Level.load("map.lvlx")
                                    end
                                end
                                if gameoveractivate then --Quick game over screen stuff.
                                    Misc.pause()
                                    gameovershow = true --Show the GAME OVER text
                                    SaveData.GameOverCount = SaveData.GameOverCount + 1 --Increase a game over count marker
                                    smashudsystem.gameOverSequences()
                                    Misc.unpause() --Unpause afterward
                                    SaveData.totalLives = 5 --Refill the lives back to 5
                                    smashudsystem.hasDied = true --The player has now died
                                    if smashudsystem.exittomap == false then
                                        Level.load(Level.filename())
                                    elseif smashudsystem.exittomap == true then
                                        Level.load("map.lvlx", nil, nil)
                                    end
                                end
                            end
                        end
                        if (player.character == CHARACTER_NINJABOMBERMAN) == true then --Do a different death animation with yiYoshi if active
                            if player.deathTimer == 0 then
                                smasbooleans.musicMuted = true
                                Audio.MusicVolume(0)
                                SaveData.deathCount = SaveData.deathCount + 1 --This marks a death count, for info regarding how many times you died
                                SaveData.totalLives = SaveData.totalLives - 1
                                if SaveData.totalLives < 0 and SaveData.enableLives then
                                    gameoveractivate = true
                                    SaveData.totalLives = 0
                                elseif SaveData.totalLives < 0 and not SaveData.enableLives then
                                    gameoveractivate2 = true
                                end
                                Misc.saveGame() --Save the game to save what we've added/edited
                                Routine.waitFrames(360, true)
                                smasbooleans.musicMuted = false
                                Misc.unpause()
                                if gameoveractivate == false then
                                    fadeoutcompleted = true --When waited enough time, unpause and reload the level
                                end
                                if fadeoutcompleted then --Or else, just exit the level
                                    if gameoveractivate2 then
                                        SaveData.totalLives = 5
                                    end
                                    smashudsystem.hasDied = true
                                    if smashudsystem.exittomap == false then
                                        Level.load(Level.filename())
                                    elseif smashudsystem.exittomap == true then
                                        Level.load("map.lvlx")
                                    end
                                end
                                if gameoveractivate then --Quick game over screen stuff.
                                    Misc.pause()
                                    gameovershow = true --Show the GAME OVER text
                                    SaveData.GameOverCount = SaveData.GameOverCount + 1 --Increase a game over count marker
                                    smashudsystem.gameOverSequences()
                                    Misc.unpause() --Unpause afterward
                                    SaveData.totalLives = 5 --Refill the lives back to 5
                                    smashudsystem.hasDied = true --The player has now died
                                    if smashudsystem.exittomap == false then
                                        Level.load(Level.filename())
                                    elseif smashudsystem.exittomap == true then
                                        Level.load("map.lvlx")
                                    end
                                end
                            end
                        end
                    end
                end
                if SaveData.disableX2char then
                    if not battledependencies.battlemodeactive then
                        console:println("A player has died.")
                        SaveData.deathCount = SaveData.deathCount + 1 --This marks a death count, for info regarding how many times you died
                        SaveData.totalLives = SaveData.totalLives - 1 --This marks a life lost
                    end
                end
            end
            if Misc.inMarioChallenge() then
                console:println("The player has died.")
                SaveData.deathCount = SaveData.deathCount + 1 --This marks a death count, for info regarding how many times you died
                SaveData.totalLives = SaveData.totalLives - 1 --This marks a life lost
            end
        end
    end
end

function smashudsystem.onPostPlayerKill(plr) --To cancel the death entirely
    Routine.run(diedanimation, plr)
end

function smashudsystem.onTick()
    if mem(0x00B2C5AC, FIELD_FLOAT) < 1 then --This is to prevent the old Game Over system
        mem(0x00B2C5AC, FIELD_FLOAT, 1)
    end
    if SaveData.totalCoinsClassic > 99 then --This is to give the player a life when reaching 100 coins
        console:println("100 coins reached! Gaining an extra life...")
        SaveData.totalCoinsClassic = 0
        if SaveData.enableLives then
            Sound.playSFX(15)
        else
            Sound.playSFX(150)
        end
        SaveData.totalLives = SaveData.totalLives + 1 --If 100, increase the lives by one
    end
    
    if SaveData.totalCherries >= 5 then
        SaveData.totalCherries = 0
    end
    
    if SaveData.disableX2char then
        if not Playur.isAnyPlayerAlive() then
            deathTimer = deathTimer + 1
            if deathTimer == 1 then
                Routine.run(thirteenModeDeath)
            end
        end
    end
    if(not killed1 and player:mem(0x13E,FIELD_BOOL)) then
        killed1 = true --killed1 detects to see if the 1st player is dead.
    end
    if Player.count() >= 2 then --2nd player compability
        smasbooleans.multiplayerActive = true --This makes sure the death animation doesn't play when on multiplayer
        if battledependencies.battlemodeactive then
            if(not killed2 and player2:mem(0x13E,FIELD_BOOL)) then
                killed2 = true --killed2 detects to see if the 2nd player is dead.
            end
        end
    end
    if Player.count() == 1 then
        smasbooleans.multiplayerActive = false
    end
    if SaveData.totalLives >= 1110 then
        SaveData.totalLives = 1110 --The max amount of lives in the episode is 1110, used for the crown hud easter egg that was from Super Mario 3D Land/New Super Mario Bros. 2/Super Mario 3D World.
    end
    if SaveData.totalScoreClassic >= 999999999 then --The max score is NSMBU's score tally, which is 999 trillion.
        SaveData.totalScoreClassic = 999999999
    end
    if not battledependencies.battlemodeactive then
        if not smasbooleans.mainMenuActive then
            for index,scoreboard in ipairs(Animation.get(79)) do --Score values!
                if scoreboard.animationFrame == 0 and scoreboard.speedY == -1.94 then --Score 10
                    console:println("10 points earned.")
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 10
                end
                if scoreboard.animationFrame == 1 and scoreboard.speedY == -1.94 then --Score 100
                    console:println("100 points earned.")
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 100
                end
                if scoreboard.animationFrame == 2 and scoreboard.speedY == -1.94 then --Score 200
                    console:println("200 points earned.")
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 200
                end
                if scoreboard.animationFrame == 3 and scoreboard.speedY == -1.94 then --Score 400
                    console:println("400 points earned.")
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 400
                end
                if scoreboard.animationFrame == 4 and scoreboard.speedY == -1.94 then --Score 800
                    console:println("800 points earned.")
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 800
                end
                if scoreboard.animationFrame == 5 and scoreboard.speedY == -1.94 then --Score 1000
                    console:println("1000 points earned.")
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 1000
                end
                if scoreboard.animationFrame == 6 and scoreboard.speedY == -1.94 then --Score 2000
                    console:println("2000 points earned.")
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 2000
                end
                if scoreboard.animationFrame == 7 and scoreboard.speedY == -1.94 then --Score 4000
                    console:println("4000 points earned.")
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 4000
                end
                if scoreboard.animationFrame == 8 and scoreboard.speedY == -1.94 then --Score 8000
                    console:println("8000 points earned.")
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 8000
                end
                if scoreboard.animationFrame == 9 and scoreboard.speedY == -1.94 then --1UP, Score 10000
                    console:println("1UP and 10000 points earned.")
                    SaveData.totalLives = SaveData.totalLives + 1
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 10000
                    Misc.score(10000) --Just in case if the Mario Challenge is active
                end
                if scoreboard.animationFrame == 10 and scoreboard.speedY == -1.94 then --2UP, Score 20000
                    console:println("2UP and 20000 points earned.")
                    SaveData.totalLives = SaveData.totalLives + 2
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 20000
                    Misc.score(20000)
                end
                if scoreboard.animationFrame == 11 and scoreboard.speedY == -1.94 then --3UP, Score 30000
                    console:println("3UP and 30000 points earned.")
                    SaveData.totalLives = SaveData.totalLives + 3
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 30000
                    Misc.score(30000)
                end
                if scoreboard.animationFrame == 12 and scoreboard.speedY == -1.94 then --5UP, Score 50000
                    console:println("5UP and 50000 points earned.")
                    SaveData.totalLives = SaveData.totalLives + 5
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 50000
                    Misc.score(50000)
                end
            end
        end
    end
end

function smashudsystem.onDraw()
    if fadeoutdeath then --Fade out related code
        time = time + 1
        Graphics.drawScreen{color = Color.black..math.max(0,time/35),priority = 6}
    end
    if gameovershow then --Drawing for the quick game over screen
        Text.printWP("GAME OVER", 310, 290, 7)
    end
    if blackscreenonly then --Black screen related code
        Graphics.drawScreen{color = Color.black..1,priority = 6}
    end
end

function smashudsystem.onExit()
    smasbooleans.musicMuted = false --This is specific for my episode. Remove this if you wanna use this yourself.
    Audio.MusicVolume(64) --Reset the music exiting the level
    if smashudsystem.hasDied and not smashudsystem.exittomap then
        Level.load(Level.filename())
    elseif smashudsystem.hasDied and smashudsystem.exittomap then
        Level.load("map.lvlx")
    end
end

return smashudsystem