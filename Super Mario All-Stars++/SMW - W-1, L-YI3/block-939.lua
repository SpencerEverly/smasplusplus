---------------------------------------------------------
-- Bonus Block code made by MrDoubleA & Hatsune Blake. --
-- Please credit! <3                                   --
---------------------------------------------------------

--Blockmanager is required for setting basic Block properties
local blockManager = require("blockManager")
local blockutils = require("blocks/blockutils")

--Locals for the Bonus Block
local oldCoins = mem(0x00B2C5A8,FIELD_WORD)
local oldLives = mem(0x00B2C5AC,FIELD_FLOAT)
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

    if mem(0x00B2C5A8,FIELD_WORD) > oldCoins then
        levelCoins = levelCoins + (mem(0x00B2C5A8,FIELD_WORD) - oldCoins)
    elseif mem(0x00B2C5AC,FIELD_FLOAT) > oldLives then
       levelCoins = levelCoins + mem(0x00B2C5A8,FIELD_WORD) + 1
    end

    oldCoins = mem(0x00B2C5A8,FIELD_WORD)
    oldLives = mem(0x00B2C5AC,FIELD_FLOAT)
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
		SFX.play("littleDialogue/choose.wav")
    else
        -- Contains a single coin.
        v.contentID = 1
		SFX.play("wrong.ogg")
    end
end

-- Gotta return the library table!
return bonusBlock