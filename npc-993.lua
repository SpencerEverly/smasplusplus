local npcManager = require("npcManager")
local babyYoshis = require("babyyoshis")
babyYoshis.colors.BROWN = {egg = 10, yoshi = 992}

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
    Misc.doPOW();
    local veggie = NPC.spawn(147, v.x, v.y, v:mem(0x146, FIELD_WORD), false, true);
    veggie.speedX = -2.5 * v.direction;
    veggie.speedY = -4.5;
    veggie.layerName = "Spawned NPCs"
    SFX.play(75);
end

function greenBabyYoshi.onInitAPI()
    babyYoshis.register(npcID, babyYoshis.colors.BROWN, swallowFunction);
end

return greenBabyYoshi;