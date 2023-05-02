--[[

    Extended Koopas
    Made by MrDoubleA

    See extendedKoopas.lua for full credits

]]

local npcManager = require("npcManager")

local extendedKoopas = require("extendedKoopas")


local koopa = {}
local npcID = NPC_ID

local deathEffect = (npcID + 1)


local koopaSettings = {
    id = npcID,

    luahandlesspeed = true,
}

npcManager.setNpcSettings(koopaSettings)
npcManager.registerHarmTypes(npcID,
    {
        HARM_TYPE_JUMP,
        HARM_TYPE_FROMBELOW,
        HARM_TYPE_NPC,
        HARM_TYPE_PROJECTILE_USED,
        HARM_TYPE_LAVA,
        HARM_TYPE_HELD,
        HARM_TYPE_TAIL,
        HARM_TYPE_SPINJUMP,
        HARM_TYPE_OFFSCREEN,
        HARM_TYPE_SWORD,
    },
    {
        [HARM_TYPE_JUMP]            = deathEffect,
        [HARM_TYPE_FROMBELOW]       = deathEffect,
        [HARM_TYPE_NPC]             = deathEffect,
        [HARM_TYPE_PROJECTILE_USED] = deathEffect,
        [HARM_TYPE_HELD]            = deathEffect,
        [HARM_TYPE_TAIL]            = deathEffect,
        [HARM_TYPE_LAVA]            = {id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
        [HARM_TYPE_SPINJUMP]        = 10,
    }
)


extendedKoopas.registerKoopa(npcID)


return koopa