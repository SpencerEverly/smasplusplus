local npcManager = require("npcmanager")

local megashroom = require("mega/megashroom")

local mega2 = {};

local npcID = NPC_ID;

local settings = {
    id=npcID, 
    gfxheight = 80, 
    gfxwidth = 104, 
    width = 64, 
    height = 64, 
    framespeed = 8, 
    frames = 2, 
    framestyle = 0,
    score = 4,
    gfxoffsetx=0,
    gfxoffsety=0,
    nogravity=false,
    nofireball=true,
    noiceball=true,
    noyoshi=true,
    grabside=false,
    grabtop=false,
    isshoe=false,
    isyoshi=false,
    nohurt=true,
    jumphurt=true,
    spinjumpsafe=false,
    isinteractable = true,
    speed=1.5,
    luahandlesspeed = true,
    bounceanims=3,
    keeppower=false}

npcManager.setNpcSettings(settings);

megashroom.register(npcID)

return mega2;

