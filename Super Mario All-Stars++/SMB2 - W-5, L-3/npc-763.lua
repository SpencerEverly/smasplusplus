local npcManager = require("npcManager")

local panser = {}

local npcID = NPC_ID

npcManager.setNpcSettings({
    id=npcID,
    width=32,
    height=20,
    gfxheight=32,
    gfxwidth=32,
    
    framestyle=1,
    framespeed=4,
    frames=2,
    
    gfxoffsety=4,
    
    noblockcollision = true,
    
    ignorethrownnpcs = true,
    linkshieldable = true,
    nogravity = true,
    spinjumpsafe = false,
    
    npcblock=false,
    speed = 2,
    
    lightradius=64,
    lightcolor=Color.orange,
    lightbrightness=1,
    jumphurt=true,
    
    nofireball=true,
    noiceball = true,
    ishot = true,
})

function panser.onInitAPI()
    npcManager.registerEvent(npcID, panser, "onTickEndNPC")
end

return panser
