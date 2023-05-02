--Mother Brain Rinka
--v1.1.0
--Created by by Spencer Everly

local rng = require("rng")
local colliders = require("colliders")

local costume = {}
GameData.friendlyArea = false

local rinkaCounter = 0
local hasDied = false
local displayText = true
local hasBeenActivated
local nextRinka = 1000

function costume.onInit(p)
    registerEvent(costume, "onTick")
    registerEvent(costume, "onStart")
    costume.abilitiesenabled = true
end

function costume.onCleanup(p)
    costume.abilitiesenabled = false
end

function costume.onTick()
    if SaveData.toggleCostumeAbilities == true then
        if GameData.friendlyArea == false then
            for _, v in pairs(NPC.get(player.powerup, player.section)) do
                if colliders.collide(player, v) then
                    NPC.spawn(211, v.x, v.y, player.section)
                end
            end
            rinkaCounter = rinkaCounter + 1
            if rinkaCounter == (nextRinka - 140) then
                displayText = true
            elseif rinkaCounter > (nextRinka - 140) and rinkaCounter < nextRinka then
                if (math.min(rinkaCounter, 25) == 0) then
                    displayText = not displayText
                end
                if displayText then
                    Text.printWP("RINKA INCOMING", 274, 295,-4)
                end                
            elseif rinkaCounter == nextRinka then
                for i = 0, rng.randomInt(1, 6), 1 do
                    local halfW = (player.width * 0.5)
                    local halfH = (player.height * 0.5)
                    local xDir = (rng.randomInt(0, 1) * 2 - 1)
                    local yDir = (rng.randomInt(0, 1) * 2 - 1)
                    local xOff = halfW + xDir * (halfW + rng.random(64, 128))
                    local yOff = halfH + yDir * (halfH + rng.random(64, 128))
                    NPC.spawn(210, player.x + xOff, player.y + yOff, player.section, false, true)
                end
                rinkaCounter = 0
                nextRinka = rng.randomInt(500, 1000)
            end
        end
    end
end

Misc.storeLatestCostumeData(costume)

return costume