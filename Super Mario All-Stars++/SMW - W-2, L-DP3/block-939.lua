---------------------------------------------------------
-- Bonus Block code made by MrDoubleA & Hatsune Blake. --
-- Please credit! <3                                   --
---------------------------------------------------------

--Blockmanager is required for setting basic Block properties
local blockManager = require("blockManager")
local blockutils = require("blocks/blockutils")
local smasExtraSounds = require("smasExtraSounds")

--Locals for the Bonus Block
local oldCoins = SaveData.totalCoinsClassic
local oldLives = SaveData.totalLives
local levelCoins = 0

--Create the library table
local bonusBlock = {}
--BLOCK_ID is dynamic based on the name of the library file
local blockID = BLOCK_ID

--Defines Block config for our Block. You can remove superfluous definitions.
local bonusBlockSettings = {
    id = blockID,
    --Frameloop-related
    frames = 1,
    framespeed = 8, --# frames between frame change

    bumpable = true, --can be hit from below

}

--Applies blockID settings
blockManager.setBlockSettings(bonusBlockSettings)

--Register events
function bonusBlock.onInitAPI()
    registerEvent(bonusBlock, "onPostBlockHit")
    blockManager.registerEvent(blockID, bonusBlock, "onTickBlock")
end

-- Checks the coin & 1-up values.
function bonusBlock.onTickBlock(v)
    local data = v.data
    data.bonusNPC = data._settings.bonusNPC or 0
    data.coinGoal = data._settings.coinGoal or 0

    if SaveData.totalCoinsClassic > oldCoins then
        levelCoins = levelCoins + (SaveData.totalCoinsClassic - oldCoins)
    elseif SaveData.totalLives > oldLives then
       levelCoins = levelCoins + SaveData.totalCoinsClassic + 1
    end

    oldCoins = SaveData.totalCoinsClassic
    oldLives = SaveData.totalLives
end

-- Defines what happens right after the block is hit.
function bonusBlock.onPostBlockHit(v,fromTop,playerObj)
    local data = v.data
    data.bonusNPC = data._settings.bonusNPC or 0
    data.coinGoal = data._settings.coinGoal or 0

    if v.id ~= blockID then return end

    if levelCoins >= data.coinGoal then
        -- True NPC ID is contentID - 1000. Example: 1187 - 1000 = 187... the SMW 1-Up.
        v.contentID = data.bonusNPC + 1000
        SFX.play(smasExtraSounds.sounds[151].sfx)
    else
        -- Contains a single coin.
        v.contentID = 1
        SFX.play(smasExtraSounds.sounds[152].sfx)
    end
end

-- Gotta return the library table!
return bonusBlock