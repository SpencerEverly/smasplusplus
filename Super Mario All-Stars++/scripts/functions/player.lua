local Playur = {}

local starman
local megashroom

if Misc.inSuperMarioAllStarsPlusPlus() then
    starman = require("starman/star")
    megashroom = require("mega/megashroom")
else
    starman = require("npcs/AI/starman")
    megashroom = require("npcs/AI/megashroom")
end

local rng = require("base/rng")

local GM_PLAYERS_COUNT_ADDR = 0x00B2595E
local GM_PLAYERS_ADDR = mem(0x00B25A20, FIELD_DWORD) --For the player adding and removing function
local PLAYER_START_POINT_ADDR = mem(0x00B25148,FIELD_DWORD)

local threePlayersOnSEEModActive = false

function Playur.onInitAPI()
    registerEvent(Playur,"onDraw")
end

function Playur.execute(index, func) --Better player/player2 detection, for simplifying mem functions, or detecting either player for any code-related function. Example: Playur.execute(1, function(p) p:kill() end)
    if index == nil then
        index = 1
    end
    if index == -1 then
        for i = 1,200 do
            if Player(i).isValid then
                func(Player(i))
            end
        end
    else
        local p = Player(index)
        if p.isValid then
            func(plr)
        end
    end
end

function Playur.setCount(count) --Sets the total count of the players in the level.
    if count < 1 or count > 200 then
        error("You cannot set the player count at this number.")
        return
    end
    return mem(GM_PLAYERS_COUNT_ADDR, FIELD_WORD, count)
end

function Playur.threePlayersOrAboveActiveWithNoCheats()
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
end

function Playur.activate1stPlayer(enablexplosion) --Activates 1st player mode
    if enablexplosion == nil then
        enablexplosion = false
    end
    Playur.setCount(1)
    if smasbooleans then
        smasbooleans.introModeActivated = false
    end
    if enableexplosion then
        local rngbomb = rng.randomEntry({69,71})
        Effect.spawn(rngbomb, player.x, player.y, player.section)
    end
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
        if smasbooleans then
            smasbooleans.introModeActivated = false
        end
        if enableexplosion then
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player.x, player.y, player.section)
        end
    elseif mem(0x00B2C896, FIELD_WORD) == 1 then
        if enableexplosion then
            local rngbomb = rng.randomEntry({69,71})
            Effect.spawn(rngbomb, player2.x, player2.y, player2.section)
        end
        Playur.activate1stPlayer()
        mem(0x00B2C896, FIELD_WORD, 0) --Reupdate SingleCoop to 0, according to the source code
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
        if player2.powerup == 0 then
            player2.powerup = 2
        end
    end
    if smasbooleans then
        smasbooleans.introModeActivated = false
    end
    if enableexplosion then
        local rngbomb = rng.randomEntry({69,71})
        Effect.spawn(rngbomb, player.x, player.y, player.section)
    end
end

if Misc.inSuperMarioAllStarsPlusPlus() then
    function Playur.activate3rdPlayer() --Activates 3rd player mode (TBD)
        if SMBX_VERSION == VER_SEE_MOD then
            if Playur.threePlayersOrAboveActiveWithNoCheats() then
                Misc.disable1stPlayerInputsOn3rdPlayerAndMore(true)
            end
        end
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
        if smasbooleans then
            smasbooleans.introModeActivated = false
        end
    end

    function Playur.activate4thPlayer() --Activates 4th player mode (TBD)
        if Playur.threePlayersOrAboveActiveWithNoCheats() then
            if SMBX_VERSION == VER_SEE_MOD then
                Misc.disable1stPlayerInputsOn3rdPlayerAndMore(true)
            end
        end
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
        if smasbooleans then
            smasbooleans.introModeActivated = false
        end
    end

    function Playur.activatePlayerIntroMode() --Activates the player intro mode
        if Playur.threePlayersOrAboveActiveWithNoCheats() then
            if SMBX_VERSION == VER_SEE_MOD then
                Misc.disable1stPlayerInputsOn3rdPlayerAndMore(true)
            end
        end
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
        if smasbooleans then
            smasbooleans.introModeActivated = true
        end
    end
end

function Playur.isJumping(p)
    return (p:mem(0x11E, FIELD_BOOL) and p.keys.jump == KEYS_PRESSED)
end

function Playur.countEveryPlayer(p)
    local playertable = {}
    for _,p in ipairs(Player.get()) do
        for i = 1,Player.count() do
            table.insert(playertable, i)
        end
    end
    return playertable
end

function Playur.checkLivingIndex() --Code to check the isAnyPlayerAlive() code.
    for k, p in ipairs(Player.get()) do
        if p.deathTimer == 0 and p:mem(0x13C, FIELD_BOOL) == false then
            return p.idx
        end
    end
end

function Playur.isAnyPlayerAlive() --Returns if any player is still alive.
    if Playur.checkLivingIndex() ~= nil then
        return true
    else
        return false
    end
end

function Playur.underwater(p) --Returns true if the specified player is underwater.
    return (
        p:mem(0x34,FIELD_WORD) > 0
        and p:mem(0x06,FIELD_WORD) == 0
    )
end

function Playur.grabbing(p) --Returns true if the specified player is grabbing something.
    if p:mem(0x26, FIELD_WORD) >= 1 then
        return true
    elseif p:mem(0x26, FIELD_WORD) == 0 then
        return false
    end
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
    if not SaveData.disableX2char then
        Playur.activate1stPlayer()
    end
end

function Playur.inForcedState()
    for _,p in ipairs(Player.get()) do
        if p.forcedState == 0 then
            return false
        else
            return true
        end
    end
end

return Playur