local smasIntroRunner = {}

local smasBooleans = require("smasBooleans")

local introtime = 0
local jumptime = 0
local activatejump = false

local threeplayermode = false
local fourplayermode = false

function smasIntroRunner.onInitAPI()
    registerEvent(smasIntroRunner,"onDraw")
    registerEvent(smasIntroRunner,"onInputUpdate")
    registerEvent(smasIntroRunner,"onStart")
end

local tempBool = false
local tempLocation = {}

function smasIntroRunner.onInputUpdate()
    if smasBooleans.introModeActivated then
        --[[mem(0x00B2C896, FIELD_WORD, 0)
        
        --only restore the level on the first frame that all players are dead
        local restore_done = false
        
        local any_living = Playur.isAnyPlayerAlive()
        
        if (not any_living and not restore_done) then
            local destroyedLayer = Layer.get("Destroyed Blocks")
            destroyedLayer:show(true)
            
            NPC.restoreClass("NPC")
        elseif(any_living)
            restore_done = false
        end
        
        for i = 1,Player.count() do
            if Player(i).deathTimer > 0 then
                Player(i).deathTimer = 0
                Player(i):mem(0x13C, FIELD_BOOL, true)
            end
            
            Player(i).keys.down = false
            Player(i).keys.dropItem = false
            Player(i).keys.right = true --These keys are force-held like the og intro
            Player(i).keys.left = false
            Player(i).keys.run = true
            Player(i).keys.up = false
            Player(i).keys.altRun = false
            Player(i).keys.altJump = false
            
            if Player(i):mem(0x11C, FIELD_WORD) == 0 or Player(i).y < Player(i).sectionObj.top + 200 then
                Player(i).keys.jump = false
            end
            
            if (Player(i).speedX < 0.5) then
                Player(i).keys.jump  = true
                if (Player(i):mem(0x48, FIELD_WORD) > 0 or Player(i).standingNPC > 0 or Player(i).speedY == 0) then
                    Player(i):mem(0x11E, FIELD_BOOL, true)
                end
            end
            
            if Player(i).holdingNPC == 0 then
                if (Player(i).powerup == 3 or Player(i).powerup == 6 or Player(i).powerup == 7) and RNG.randomInit(1,100) >= 90 then
                    if Player(i):mem(0x160, FIELD_WORD) == 0 and not Player(i):mem(0x172, FIELD_BOOL) then
                        Player(i).keys.run = false
                    end
                end
                
                if (Player(i).powerup == 4 or Player(i).powerup == 5) and Player(i):mem(0x164, FIELD_WORD) == 0 and not Player(i):mem(0x172, FIELD_BOOL) then
                    tempLocation.width = 24
                    tempLocation.height = 20
                    tempLocation.Y = Player(i).y + Player(i).height - 22
                    tempLocation.X = Player(i).x + Player(i).width
                    
                    
                end
            end
        end]]
        
        local playernumber = rng.randomInt(1,6)
        for i = 2,maxPlayers do
            for k,_ in pairs(player.keys) do
                if Player(i).isValid then
                    Player(i).keys[_] = not player.keys[_]
                end
            end
        end
        if Player(i).powerup == 4 or Player(i).powerup == 5 then --If leaf or tanooki, fly down when flying
            if Player(i):mem(0x16E, FIELD_BOOL, true) then
                Player(i).keys.jump = true
            end
        end
        if Player(i):mem(0x11C, FIELD_WORD) >= 1 then --Jump momentum detection
            Player(i).keys.jump = true
        end
        if activatejump then
            Player(playernumber).keys.jump = true
        end
    end
    if threeplayermode then
        for k,p in ipairs(Player.get()) do
            if Player.count() >= 2 then
                
            end
            if Player(3) and Player(3).isValid then
                
            end
        end
    end
end

function smasIntroRunner.onDraw()
    if smasBooleans.introModeActivated then
        introtime = introtime - 3
        jumptime = 29
        for i = 1,6 do
            Player(i).direction = 1 --Direction is always right
            if introtime <= 0 then
                introtime = rng.randomInt(1,120)
                activatejump = true
            end
            if activatejump then
                jumptime = jumptime - 1
                if jumptime <= 0 then
                    jumptime = 29
                    activatejump = false
                end
            end
        end
    end
end

return smasIntroRunner