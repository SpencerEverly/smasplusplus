local Playur = {}

if smasGlobals == nil then
    smasGlobals = require("smasGlobals")
end

Playur.animationState = {}
Playur.opacityValue = {}
Playur.isVisibleOverride = {}

Playur.priorityValue = {}
Playur.priorityValue.normal = {}
Playur.priorityValue.pipe = {}
Playur.priorityValue.clownCar = {}
Playur.priorityValue.ignoreState = {}

for i = 1,200 do
    Playur.animationState[i] = ""
    Playur.opacityValue[i] = 1
    
    Playur.priorityValue.normal[i] = -25
    Playur.priorityValue.pipe[i] = -70
    Playur.priorityValue.clownCar[i] = -35
    Playur.priorityValue.ignoreState[i] = -25
    
    Playur.isVisibleOverride[i] = true
end

local starman = require("starman/star")
local megashroom = require("mega/megashroom")

local rng = require("base/rng")
local inspect = require("ext/inspect")
local playerManager = require("playerManager")

local GM_PLAYERS_COUNT_ADDR = 0x00B2595E
local GM_PLAYERS_ADDR = mem(0x00B25A20, FIELD_DWORD) --For the player adding and removing function
local PLAYER_START_POINT_ADDR = mem(0x00B25148,FIELD_DWORD)

Playur.characterSpeedModifiers = {
    [CHARACTER_PEACH] = 0.93,
    [CHARACTER_TOAD]  = 1.07,
}

Playur.characterNeededPSpeeds = {
    [CHARACTER_MARIO] = 35,
    [CHARACTER_LUIGI] = 40,
    [CHARACTER_PEACH] = 80,
    [CHARACTER_TOAD]  = 60,
    [CHARACTER_LINK]  = 10,
    [CHARACTER_MEGAMAN] = 60,
    [CHARACTER_WARIO] = 35,
    [CHARACTER_BOWSER] = 40,
    [CHARACTER_KLONOA] = 60,
    [CHARACTER_NINJABOMBERMAN] = 80,
    [CHARACTER_ROSALINA] = 80,
    [CHARACTER_SNAKE] = 10,
    [CHARACTER_ZELDA] = 40,
    [CHARACTER_ULTIMATERINKA] = 60,
    [CHARACTER_UNCLEBROADSWORD] = 35,
    [CHARACTER_SAMUS] = 10,
}

Playur.characterDeathEffects = {
    [CHARACTER_MARIO] = 3,
    [CHARACTER_LUIGI] = 5,
    [CHARACTER_PEACH] = 129,
    [CHARACTER_TOAD]  = 130,
    [CHARACTER_LINK]  = 134,
}

Playur.leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKIE}
Playur.shootingPowerups = table.map{PLAYER_FIREFLOWER,PLAYER_ICE,PLAYER_HAMMER}
Playur.smb2Characters = table.map{CHARACTER_PEACH,CHARACTER_TOAD}

local threePlayersOnSEEModActive = false

function Playur.onInitAPI()
    registerEvent(Playur,"onDraw")
end

function Playur.getScreenCoords(pl)
	local cam = camera
	local px = pl.x
	local py = pl.y
	local cx = cam.x
	local cy = cam.y
	local r = {}
	r.left = px - cx
	r.top = py - cy
	r.right = (px - cx) + pl.width
	r.bottom = (py - cy) + pl.height
	return r
end

function Playur.resetVariables(p)
    console:println("Resetting variables for Player "..tostring(p.idx).."...")
    
    local chars = playerManager.getCharacters()
    
    if p.mount == 2 then
        p.mount = 0
    end
    if chars[p.character].base >= 3 and p.mount == 3 then
        p.mount = 0
    end
    
    p:mem(0x0A, FIELD_BOOL, false) --Slippery ground
    p:mem(0x00, FIELD_BOOL, false) --Toad double jump
    p:mem(0x02, FIELD_WORD, 0) --Flying sparks
    p:mem(0x06, FIELD_WORD, 0) --In quicksand?
    p:mem(0x08, FIELD_WORD, 0) --Number of Bombs Link has
    p:mem(0x34, FIELD_WORD, 0) --In water? Greater than 2 when in water/quicksand
    p:mem(0x44, FIELD_BOOL, false) --In a rainbow shell?
    p:mem(0x36, FIELD_BOOL, false) --In water?
    p:mem(0x3C, FIELD_BOOL, false) --Is the player sliding?
    p:mem(0x40, FIELD_WORD, 0) --Climbing state
    p:mem(0x2C, FIELD_WORD, 0) --Climbing state (NPC)
    p:mem(0x0C, FIELD_BOOL, false) --Is a fairy?
    p:mem(0x28, FIELD_FLOAT, 0) --Grab top momentum
    p:mem(0x26, FIELD_WORD, 0) --Grab timer
    p:mem(0x14, FIELD_WORD, 0) --Link slash cooldown
    p:mem(0x162, FIELD_WORD, 0) --Link projectile cooldown
    p:mem(0x50, FIELD_BOOL, false) --Is spinjumping?
    p:mem(0x4A, FIELD_BOOL, false) --Is currently in a Tanooki statue?
    p:mem(0x48, FIELD_WORD, 0) --Slope index
    p:mem(0x54, FIELD_WORD, 0) --Fireball spinjump direction
    p:mem(0x52, FIELD_WORD, 0) --Spinjump timer
end

function Playur.setupPlayers()
    console:println("Setting up players...")
    
    local PLR_HEARTS = 0x16
    local PLR_HOLDINGNPC = 0x154
    local PLR_ITEMBOX = 0x158
    
    local chars = playerManager.getCharacters()
    
    for i = 1,200 do
        if Player(i).isValid then
            if Player(i).character == 0 then
                Player(i).character = 1;
                if Player.count() == 2 and i == 2 then
                    Player(i).character = 2;
                end
            end
            if Player(i).powerup == 0 then
                Player(i).powerup = 1;
            end
            if chars[Player(i).character].base == 3 or chars[Player(i).character].base == 4 or chars[Player(i).character].base == 5 then
                if Player(i):mem(PLR_HEARTS, FIELD_WORD) <= 0 then
                    Player(i):mem(PLR_HEARTS, FIELD_WORD, 1)
                end
                
                if (Player(i):mem(PLR_HEARTS, FIELD_WORD) <= 1 and Player(i).powerup > 1 and Player(i).character ~= 5) then
                    Player(i):mem(PLR_HEARTS, FIELD_WORD, 2)
                end
                
                if(Player(i):mem(PLR_ITEMBOX, FIELD_WORD) > 0) then
                    Player(i):mem(PLR_HEARTS, FIELD_WORD, Player(i):mem(PLR_HEARTS, FIELD_WORD) + 1)
                    Player(i):mem(PLR_ITEMBOX, FIELD_WORD, 0)
                end
                if(Player(i).powerup == 1 and Player(i):mem(PLR_HEARTS, FIELD_WORD) > 1) then
                    Player(i).powerup = 2;
                end
                if (Player(i):mem(PLR_HEARTS, FIELD_WORD) > 3) then
                    Player(i):mem(PLR_HEARTS, FIELD_WORD, 3)
                end
                if Player(i).mount == 3 then
                    Player(i).mount = 0
                end
            else
                if (Player(i):mem(PLR_HEARTS, FIELD_WORD) == 3 and Player(i):mem(PLR_ITEMBOX, FIELD_WORD) == 0) then
                    Player(i):mem(PLR_ITEMBOX, FIELD_WORD, 9)
                    Player(i):mem(PLR_HEARTS, FIELD_WORD, 0)
                end
            end
            if Player(i).character == 5 then
                Player(i).mount = 0
            end
            Player(i).direction = 1;
            Playur.resetVariables(Player(i))
        end
    end
end

function Playur.execute(index, func) --Better player/player2 detection, for simplifying mem functions, or detecting either player for any code-related function. Example: Playur.execute(1, function(p) p:kill() end)
    if index == nil then
        index = 1
    end
    if index == -1 then
        console:println("Next player function will be executed on all players.")
        for i = 1,200 do
            if Player(i).isValid then
                func(Player(i))
            end
        end
    else
        console:println("Next player function will be executed on player "..tostring(index)..".")
        local p = Player(index)
        if p.isValid then
            func(plr)
        end
    end
    console:println("Executed a player function with Playur.execute.")
end

function Playur.setCount(count) --Sets the total count of the players in the level.
    if count < 1 or count > 200 then
        error("You cannot set the player count at this number.")
        return
    end
    console:println("Player count has been set to "..tostring(count)..".")
    return mem(GM_PLAYERS_COUNT_ADDR, FIELD_WORD, count)
end

function Playur.threePlayersOrAboveActiveWithNoCheats()
    if EventManager.onStartRan then
        return (Player.count() > 2
            and not Cheats.get("supermario2").active
            and not Cheats.get("supermario4").active
            and not Cheats.get("supermario8").active
            and not Cheats.get("supermario16").active
            and not Cheats.get("supermario32").active
            and not Cheats.get("supermario64").active
            and not Cheats.get("supermario128").active
            --and not Cheats.get("supermario200").active
        )
    else
        return false
    end
end

function Playur.activate1stPlayer(enablexplosion) --Activates 1st player mode
    if enablexplosion == nil then
        enablexplosion = false
    end
    Playur.setCount(1)
    if smasBooleans then
        smasBooleans.introModeActivated = false
        console:println("Player intro mode disabled to prevent any issues.")
    end
    if enableexplosion then
        local rngbomb = rng.randomEntry({69,71})
        Effect.spawn(rngbomb, player.x, player.y, player.section)
        console:println("Explosion has been activated for changing player count.")
    end
    console:println("1 player mode activated.")
end

function Playur.toggleSingleCoOp(enableexplosion) --Activates/deactivates single Co-Op mode, which is the cheat supermario2
    if enablexplosion == nil then
        enablexplosion = false
    end
    if mem(0x00B2C896, FIELD_WORD) == 0 then
        Playur.setCount(2)
        mem(0x00B2C896, FIELD_WORD, 1) --This sets SingleCoop to 1, according to the source code
        if Player.count() >= 2 then
            player2.x = player.x - player.width * 0.5
            player2.y = player.y - 10
            player2.character = player.character
            player2.speedY = rng.randomInt() * 24 - 12
            player.speedX = 3
            if player2.powerup == 0 then
                player2.powerup = player.powerup
            end
        end
        if smasBooleans then
            smasBooleans.introModeActivated = false
            console:println("Player intro mode disabled to prevent any issues.")
        end
        if enableexplosion then
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
            console:println("Explosion has been activated for changing player count.")
        end
        console:println("Single Co-Op enabled.")
    elseif mem(0x00B2C896, FIELD_WORD) == 1 then
        if enableexplosion then
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player2.x, player2.y, player2.section)
        end
        Playur.activate1stPlayer()
        mem(0x00B2C896, FIELD_WORD, 0) --Reupdate SingleCoop to 0, according to the source code
        console:println("Single Co-Op disabled.")
    end
end

function Playur.activate2ndPlayer(enablexplosion) --Activates 2nd player mode
    if enablexplosion == nil then
        enablexplosion = false
    end
    Playur.setCount(2)
    if Player.count() >= 2 then
        player2.x = player.x - player.width * 0.5
        player2.y = player.y - 10
        player2.character = 2
        player2.frame = 1
        player2.section = player.section
        if player2.powerup == 0 then
            console:println("Player 2 was without powerup, so the game will set it to state 2 (Big).")
            player2.powerup = 2
        end
    end
    if smasBooleans then
        smasBooleans.introModeActivated = false
        console:println("Player intro mode disabled to prevent any issues.")
    end
    if enableexplosion then
        local rngbomb = rng.randomEntry({69,71})
        Effect.spawn(rngbomb, player.x, player.y, player.section)
        console:println("Explosion has been activated for changing player count.")
    end
    console:println("2 player mode activated.")
end

if Misc.inSuperMarioAllStarsPlusPlus() then
    function Playur.activate3rdPlayer() --Activates 3rd player mode (TBD)
        Playur.setCount(3)
        if Player.count() >= 2 then
            player2.x = player.x - player.width * 0.5
            player2.y = player.y - 10
            player2.character = 2
            player2.frame = 1
            if player2.powerup == 0 then
                player2.powerup = 2
            end
        end
        if Player.count() >= 2 and player3.isValid then
            player3.x = player.x - player.width * 0.5
            player3.y = player.y - 10
            player3.character = 3
            player3.frame = 1
            if player3.powerup == 0 then
                player3.powerup = 2
            end
        end
        if smasBooleans then
            smasBooleans.introModeActivated = false
            console:println("Player intro mode disabled to prevent any issues.")
        end
        
        console:println("3 player mode activated.")
    end

    function Playur.activate4thPlayer() --Activates 4th player mode (TBD)
        Playur.setCount(4)
        if Player.count() >= 2 then
            player2.x = player.x - player.width * 0.5
            player2.y = player.y - 10
            player2.character = 2
            player2.frame = 1
            if player2.powerup == 0 then
                player2.powerup = 2
            end
        end
        if Player.count() >= 2 and player3.isValid then
            player3.x = player.x - player.width * 0.5
            player3.y = player.y - 10
            player3.character = 3
            player3.frame = 1
            if player3.powerup == 0 then
                player3.powerup = 2
            end
        end
        if Player.count() >= 2 and player4.isValid then
            player4.x = player.x - player.width * 0.5
            player4.y = player.y - 10
            player4.character = 4
            player4.frame = 1
            if player4.powerup == 0 then
                player4.powerup = 2
            end
        end
        if smasBooleans then
            smasBooleans.introModeActivated = false
            console:println("Player intro mode disabled to prevent any issues.")
        end
        
        console:println("4 player mode activated.")
    end

    function Playur.activatePlayerIntroMode() --Activates the player intro mode
        Playur.setCount(6)
        if Player.count() >= 2 then
            player2.x = player.x
            player2.y = player.y
            player2.character = 2
            player2.frame = 1
            if player2.powerup == 0 then
                player2.powerup = 2
            end
        end
        if Player.count() >= 2 and player3.isValid then
            player3.x = player.x
            player3.y = player.y
            player3.character = 3
            player3.frame = 1
            if player3.powerup == 0 then
                player3.powerup = 2
            end
        end
        if Player.count() >= 2 and player4.isValid then
            player4.x = player.x
            player4.y = player.y
            player4.character = 4
            player4.frame = 1
            if player4.powerup == 0 then
                player4.powerup = 2
            end
        end
        if Player.count() >= 2 and player5.isValid then
            player5.x = player.x
            player5.y = player.y
            player5.character = 4
            player5.frame = 1
            if player5.powerup == 0 then
                player5.powerup = 2
            end
        end
        if Player.count() >= 2 and player6.isValid then
            player6.x = player.x
            player6.y = player.y
            player6.character = 4
            player6.frame = 1
            if player6.powerup == 0 then
                player6.powerup = 2
            end
        end
        local rngcharacter1 = rng.randomInt(1,5)
        local rngcharacter2 = rng.randomInt(1,5)
        local rngcharacter3 = rng.randomInt(1,5)
        local rngcharacter4 = rng.randomInt(1,5)
        local rngcharacter5 = rng.randomInt(1,5)
        local rngcharacter6 = rng.randomInt(1,5)
        local poweruprng1 = rng.randomInt(1,7)
        local poweruprng2 = rng.randomInt(1,7)
        local poweruprng3 = rng.randomInt(1,7)
        local poweruprng4 = rng.randomInt(1,7)
        local poweruprng5 = rng.randomInt(1,7)
        local poweruprng6 = rng.randomInt(1,7)
        Player(1):transform(rngcharacter1, false)
        player2:transform(rngcharacter2, false)
        player3:transform(rngcharacter3, false)
        player4:transform(rngcharacter4, false)
        player5:transform(rngcharacter5, false)
        player6:transform(rngcharacter6, false)
        Player(1).powerup = poweruprng1
        player2.powerup = poweruprng2
        player3.powerup = poweruprng3
        player4.powerup = poweruprng4
        player5.powerup = poweruprng5
        player6.powerup = poweruprng6
        if smasBooleans then
            smasBooleans.introModeActivated = true
        end
        
        console:println("Player intro mode activated.")
    end
end

function Playur.stoned(p)
    return p:mem(0x4A, FIELD_BOOL)
end

function Playur.isJumping(p)
    return (p:mem(0x11E, FIELD_BOOL) and p.keys.jump == KEYS_PRESSED)
end

function Playur.countEveryPlayer()
    local playertable = {}
    for i = 1,Player.count() do
        table.insert(playertable, i)
    end
    return playertable
end

function Playur.isAnyPlayerAlive() --Returns if any player is still alive.
    for k, p in ipairs(Player.get()) do
        if p.deathTimer == 0 and not p:mem(0x13C, FIELD_BOOL) then
            return true
        end
    end
    return false
end

function Playur.underwater(p) --Returns true if the specified player is underwater.
    return (
        p:mem(0x34,FIELD_WORD) > 0
        and p:mem(0x06,FIELD_WORD) == 0
    )
end

function Playur.getNPCStandingIndex(p)
    return p:mem(0x176, FIELD_WORD)
end

function Playur.getSlopeIndex(p)
    return p:mem(0x48, FIELD_WORD)
end

function Playur.sliding(p)
    return p:mem(0x3C, FIELD_BOOL)
end

function Playur.grabbing(p) --Returns true if the specified player is grabbing something.
    if p:mem(0x26, FIELD_WORD) >= 1 then
        return true
    elseif p:mem(0x26, FIELD_WORD) == 0 then
        return false
    end
end

function Playur.isSlidingOnIce(p)
    return (p:mem(0x0A,FIELD_BOOL) and (not p.keys.left and not p.keys.right))
end

function Playur.isSlowFalling(p)
    return (Playur.leafPowerups[p.powerup] and p.speedY > 0 and (p.keys.jump or p.keys.altJump))
end

-- Detects if the player is on the ground, the redigit way. Sometimes more reliable than just p:isOnGround().
function Playur.isOnGround(p)
    return (
        p.speedY == 0 -- "on a block"
        or p:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or p:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end

function Playur.ducking(p) --Returns if the player is ducking.
    return (
        p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and p.mount == MOUNT_NONE
        and not p.climbing
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p:mem(0x3C,FIELD_BOOL) -- sliding
        and not p:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not p:mem(0x4A,FIELD_BOOL) -- statue
        and not p:mem(0x50,FIELD_BOOL) -- spin jumping
        and p:mem(0x26,FIELD_WORD) == 0 -- picking up something from the top
        and (p:mem(0x34,FIELD_WORD) == 0 or Playur.isOnGround(p)) -- underwater or on ground

        and (
            p:mem(0x48,FIELD_WORD) == 0 -- not on a slope (ducking on a slope is weird due to sliding)
            or (p.holdingNPC ~= nil and p.powerup == PLAYER_SMALL) -- small and holding an NPC
            or p:mem(0x34,FIELD_WORD) > 0 -- underwater
        )
    )
end

function Playur.player2Active()
    if Player.count() == 2 then
        return true
    else
        return false
    end
end

function Playur.player2OrMoreActive()
    if Player.count() >= 2 then
        return true
    else
        return false
    end
end

function Playur.getBattleLives(playerIdx) --This will get the lives for the Battle Mode system.
    if (playerIdx < 1) or (playerIdx > 200) then
        error("Invalid player index")
    end
    return mem(mem(0xB2D754, FIELD_DWORD) + (playerIdx-1)*2, FIELD_WORD)
end

function Playur.setBattleLives(playerIdx, value) --This will set lives for the Battle Mode system to any player and value specified.
    mem(mem(0xB2D754, FIELD_DWORD) + (playerIdx-1)*2, FIELD_WORD, value)
    console:println("Battle lives for player "..tostring(playerIdx).." has been set to "..tostring(value)..".")
end

function Playur.activateStarman(p) --Starts the starman as the specified player.
    if(starman) then
        starman.start(p)
        
    end
end

function Playur.activateMegashroom(p) --Starts or stops the megashroom as the specified player.
    if(megashroom) then
        if(not p.isMega) then
            if Misc.inSuperMarioAllStarsPlusPlus() then
                megashroom.StartMega(p, 996)
            else
                megashroom.StartMega(p, 425)
            end
        else
            megashroom.StopMega(p)
        end
    end
end

function Playur.jumpPose(p) --Gets the frame of the jump pose this specified character is using.
    if p.character <= 2 or p.character == 7 or p.character == 8 or p.character == 13 or p.character == 15 then
        if p.powerup == 1 then
            return 3
        else
            return 4
        end
    elseif p.character >= 3 or p.character <= 4 or p.character == 6 or p.character == 9 or p.character == 10 or p.character == 11 or p.character == 14 then
        return 4
    elseif p.character == 5 or p.character == 12 or p.character == 16 then
        return 5
    end
end

function Playur.hasCharacter(p, characterid)  --Checks if a specified player has a specific character
    if p.character == characterid then
        local chartable = {[true] = p.idx}
        return chartable
    else
        local chartable = {[false] = p.idx}
        return chartable
    end
end

function Playur.characterList() --Returns the players that have a specified character.
    local characterTable = {}
    for i = 1,16 do
        table.insert(characterTable, Playur:hasCharacter(player, i))
    end
    return characterTable
end

function Playur.startPointCoordinateX(index) --Gets the X coordinate starting point for either player1/2.
    if index < 1 or index > 2 then
        error("Invalid player start point")
    end

    local addr = PLAYER_START_POINT_ADDR + (index - 1)*48
    local x      = mem(addr       ,FIELD_DFLOAT)
    local y      = mem(addr + 0x08,FIELD_DFLOAT)
    local height = mem(addr + 0x10,FIELD_DFLOAT)
    local width  = mem(addr + 0x18,FIELD_DFLOAT)

    return x + width*0.5
end

function Playur.startPointCoordinateY(index) --Gets the Y coordinate starting point for either player1/2.
    if index < 1 or index > 2 then
        error("Invalid player start point")
    end

    local addr = PLAYER_START_POINT_ADDR + (index - 1)*48
    local x      = mem(addr       ,FIELD_DFLOAT)
    local y      = mem(addr + 0x08,FIELD_DFLOAT)
    local height = mem(addr + 0x10,FIELD_DFLOAT)
    local width  = mem(addr + 0x18,FIELD_DFLOAT)

    return y + height
end

function Playur.sectionsWithNoPlayers() --Lists a table with sections with no players in them.
    local nonPlayeredSections = {}
    local playeredSections = Section.getActiveIndices()
    for i = 0,20 do
        if playeredSections[i] ~= i then
            table.insert(nonPlayeredSections, i)
        end
    end
    return nonPlayeredSections
end

function Playur.runInInactiveSections(func) --Runs anything in player inactive sections.
    local playeredSections = Section.getActiveIndices()
    for i = 0,20 do
        if playeredSections[i] ~= i then
            func(i)
        end
    end
end

function Playur.failsafeStartupPlayerCheck() --Checks to see if Player.count() isn't set to 0, and auto-enables 1st player mode on Normal Mode
    if Player.count() <= 0 then
        Playur.activate1stPlayer()
    end
    if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        Playur.activate1stPlayer()
    end
end

function Playur.inForcedState() --Returns true if the forced state is set to 0 on all players, else it's false.
    for _,p in ipairs(Player.get()) do
        if not smasBooleans.isOnMainMenu then
            if p.forcedState == 0 then
                return false
            else
                return true
            end
        elseif smasBooleans.isOnMainMenu then
            if p.forcedState == 0 or p.forcedState == 8 then
                return false
            else
                return true
            end
        end
    end
end

function Playur.getWalkAnimationSpeed(p)
    return math.max(0.35,math.abs(p.speedX)/Defines.player_walkspeed)
end

function Playur.findAnimation(p) --This function returns the name of the custom animation currently playing.
    -- What P-Speed values gets used is dependent on if the player has a leaf powerup
    local atPSpeed = (p.holdingNPC == nil)

    if atPSpeed then
        if Playur.leafPowerups[p.powerup] then
            atPSpeed = p:mem(0x16C,FIELD_BOOL) or p:mem(0x16E,FIELD_BOOL)
        end
    end


    if p.deathTimer > 0 then
        return "dead"
    end


    if p.mount == MOUNT_YOSHI then
        return "mountedOnYoshi"
    elseif p.mount ~= MOUNT_NONE then
        return nil
    end


    if p.forcedState == FORCEDSTATE_PIPE then
        local warp = Warp(p:mem(0x15E,FIELD_WORD) - 1)

        local direction
        if p.forcedTimer == 0 then
            direction = warp.entranceDirection
        else
            direction = warp.exitDirection
        end

        if direction == 2 or direction == 4 then
            if p.powerup == PLAYER_SMALL then
                return "walkSmall"
            else
                return "walk"
            end
        elseif direction == 1 then
            return "warpUp"
        elseif direction == 3 then
            return "warpDown"
        end
        
        return nil
    elseif p.forcedState == FORCEDSTATE_DOOR then
        return "door"
    elseif p.forcedState ~= FORCEDSTATE_NONE then
        return nil
    end


    if p:mem(0x26,FIELD_WORD) > 0 then
        return "grabFromTop"
    end


    if p:mem(0x12E,FIELD_BOOL) then
        if Playur.smb2Characters[p.character] then
            return "duck"
        elseif p.holdingNPC ~= nil then
            return "duckHolding"
        elseif p.powerup == PLAYER_SMALL then
            return "duckSmall"
        else
            return "duck"
        end
    end


    
    if p.climbing then
        return "climbing"
    end
    
    if p:mem(0x3C,FIELD_BOOL) then
        return "sliding"
    end
    
    if p:mem(0x44,FIELD_BOOL) then
        return "shellSurfing"
    end
    
    if p:mem(0x4A,FIELD_BOOL) then
        return "statue"
    end
    
    if p:mem(0x164,FIELD_WORD) ~= 0 then
        return "tailAttack"
    end


    if p:mem(0x50,FIELD_BOOL) then -- spin jumping
        if Playur.smb2Characters[p.character] and p.frame == 5 then -- dumb bug
            return "spinjumpSidwaysToad"
        else
            return "spinJump"
        end
    end


    local isShooting = (p:mem(0x118,FIELD_FLOAT) >= 100 and p:mem(0x118,FIELD_FLOAT) <= 118 and Playur.shootingPowerups[p.powerup])

    local walkSpeed = math.max(0.35,math.abs(p.speedX)/Defines.player_walkspeed)
    if Playur.isOnGround(p) then
        -- GROUNDED ANIMATIONS --
        if p.speedX == 0 and p.speedY == 0 then
            if p.holdingNPC ~= nil then
                return "holding"
            else
                return "stance"
            end
        end

        if isShooting then
            return "shootGround"
        end


        -- Skidding
        if (p.speedX < 0 and p.keys.right) or (p.speedX > 0 and p.keys.left) or p:mem(0x136,FIELD_BOOL) then
            return "skidding"
        end


        -- Walking
        if p.speedX ~= 0 and not Playur.isSlidingOnIce(p) then
            local animationName

            if walkSpeed >= 2 then
                animationName = "run"
            else
                animationName = "walk"

                if p.holdingNPC ~= nil then
                    animationName = animationName.. "Holding"
                end
            end

            if p.powerup == PLAYER_SMALL then
                animationName = animationName.. "Small"

                if Playur.smb2Characters[p.character] then
                    animationName = animationName.. "SMB2"
                end
            end


            return animationName
        end

        -- Looking up
        if p.keys.up then
            if p.holdingNPC == nil then
                return "lookUp"
            else
                return "lookUpHolding"
            end
        end

        return nil
    elseif (p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0) and p.holdingNPC == nil then -- swimming
        -- SWIMMING ANIMATIONS --


        if isShooting then
            return "shootWater"
        end
        

        if p:mem(0x38,FIELD_WORD) == 15 then
            if p.powerup == PLAYER_SMALL then
                return "swimStrokeSmall"
            else
                return "swimStroke"
            end
        end

        return "swimIdle"
    else
        -- AIR ANIMATIONS --


        if isShooting then
            return "shootAir"
        end
        

        if p:mem(0x16E,FIELD_BOOL) then -- flying with leaf
            return "leafFly"
        end

        
        if atPSpeed then
            if Playur.isSlowFalling(p) then
                return "runSlowFall"
            elseif Playur.leafPowerups[p.powerup] and p.speedY > 0 then
                return "runJumpLeafDown"
            elseif walkSpeed >= 2 then
                return "runJump"
            elseif p.speedY > 0 then
                return "fall"
            else
                return "jump"
            end
        end

        if p.holdingNPC == nil then
            if Playur.isSlowFalling(p) then
                return "slowFall"
            end
        end
        
        if p.speedY > 0 then
            return "fall"
        else
            return "jump"
        end
        
        return "none"
    end
end

function Playur.currentWarp(plr)
    return plr:mem(0x15E, FIELD_WORD)
end

function Playur.isInSplitScreen()
    return (mem(0x00B25130, FIELD_WORD) == 5)
end

function Playur.splitScreenType()
    return mem(0x00B25132, FIELD_WORD)
end

function Playur.setHeldNPCPosition(p, x, y)
    local holdingNPC = p.holdingNPC

    holdingNPC.x = x
    holdingNPC.y = y


    if holdingNPC.id == 49 and holdingNPC.ai2 > 0 then -- toothy pipe
        -- You'd think that redigit's pointers work, but nope! this has to be done instead
        for _,toothy in NPC.iterate(50,p.section) do
            if toothy.ai1 == p.idx then
                if p.direction == DIR_LEFT then
                    toothy.x = holdingNPC.x - toothy.width
                else
                    toothy.x = holdingNPC.x + holdingNPC.width
                end

                toothy.y = holdingNPC.y
            end
        end
    end
end

--[[for i = 1,maxPlayers do
    Playur[i] = {}
    Playur[i].x                       = 0
    Playur[i].y                       = 0
    Playur[i].width                   = 0
    Playur[i].height                  = 0
    Playur[i].speedX                  = 0
    Playur[i].speedY                  = 0

    Playur[i].idx                     = i
    Playur[i].isValid                 = false
    Playur[i].screen                  = Playur.getScreenCoords(Playur[i])
    Playur[i].isMega                  = false
    Playur[i].hasStarman              = false
    Playur[i].keepPowerOnMega         = false

    Playur[i].section                 = 0
    Playur[i].sectionObj              = Section(Playur[i].section)
    Playur[i].climbing                = false
    Playur[i].climbingNPC             = 0 --NOT cleared when player stops climbing
    Playur[i].powerup                 = 0
    Playur[i].character               = 0
    Playur[i].reservePowerup          = 0
    Playur[i].holdingNPC              = 0

    Playur[i].direction               = 1
    Playur[i].deathTimer              = 0
    Playur[i].standingNPC             = 0
    Playur[i].mount                   = 0
    Playur[i].mountColor              = 0
    Playur[i].frame                   = 0
    Playur[i].forcedState             = 0
    Playur[i].forcedTimer             = 0
    Playur[i].warpIndex               = 0
    
    Playur[i].underwater              = false
    Playur[i].slopeBlockIndex         = 0
    Playur[i].standingNPCIndex        = 0
    Playur[i].sliding                 = false
    Playur[i].dead                    = false
    Playur[i].stoned                  = false
end]]

return Playur