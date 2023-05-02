local npcManager = require("npcManager")
local babyYoshis = require("babyyoshis")
babyYoshis.colors.WHITE = {egg = 9, yoshi = 990}

local greenBabyYoshi = {}
local npcID = NPC_ID;

--baby yoshi adaptations, please define your npc config here
local settings = {
    id = npcID
}

-- Settings for npc
npcManager.setNpcSettings(table.join(settings, babyYoshis.babyYoshiSettings));

-- Final setup
local function swallowFunction (v)
end

function greenBabyYoshi.onInitAPI()
    babyYoshis.register(npcID, babyYoshis.colors.WHITE, swallowFunction);
end

return greenBabyYoshi;