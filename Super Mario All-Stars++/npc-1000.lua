local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local smasExtraSounds = require("smasExtraSounds")
local Routine = require("routine")
local rng = require("base/rng")
local smasBooleans = require("smasBooleans")
local smasStarSystem = require("smasStarSystem")

local newstar = {}

local npcID = NPC_ID
local id = 1000

local newstarSettings = {
    id = 1000,
    
    gfxwidth = 32,
    gfxheight = 32,

    gfxoffsetx = 0,
    gfxoffsety = 0,
    
    width = 32,
    height = 32,
    
    frames = 3,
    framestyle = 0,
    framespeed = 8,
    
    speed = 1,
    
    npcblock = false,
    npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
    playerblock = false,
    playerblocktop = false, --Also handles other NPCs walking atop this NPC.
    
    nohurt = true,
    nogravity = true,
    noblockcollision = false,
    nofireball = true,
    noiceball = true,
    noyoshi = true,
    nowaterphysics = false,
    
    jumphurt = true,
    spinjumpsafe = false,
    harmlessgrab = false,
    harmlessthrown = false,

    ignorethrownnpcs = true,

    isinteractable = true,
    sparkles = true,
    floats = true,
    
    
}

npcManager.setNpcSettings(newstarSettings)
npcManager.registerHarmTypes(npcID,
    {
        [HARM_TYPE_JUMP]            = 10,
        [HARM_TYPE_FROMBELOW]       = 10,
        [HARM_TYPE_NPC]             = 10,
        [HARM_TYPE_PROJECTILE_USED] = 10,
        [HARM_TYPE_HELD]            = 10,
        [HARM_TYPE_TAIL]            = 10,
        [HARM_TYPE_SPINJUMP]        = 10,
        [HARM_TYPE_SWORD]           = 10,
    }
)

local playervuln = false
local playerwon = false
newstar.collectableIDList = {}
newstar.collectableIDMap  = {}

function muteMusic(sectionid) --Mute all section music, or just mute a specific section
    if sectionid == -1 then --If -1, all section music will be muted
        for i = 0,20 do
            musiclist = {Section(i).music}
            GameData.levelMusicTemporary[i] = Section(i).music
            Audio.MusicChange(i, 0)
        end
    elseif sectionid >= 0 or sectionid <= 20 then
        musiclist = {Section(sectionid).music}
        GameData.levelMusicTemporary[sectionid] = Section(sectionid).music
        Audio.MusicChange(sectionid, 0)
    end
end

local plr

function starget(v)
    Misc.npcToCoins()
    for _,o in ipairs(Player.get()) do
        if o.idx ~= plr.idx then
            o.section = plr.section
            o.x = (plr.x+(plr.width/2)-(o.width/2))
            o.y = (plr.y+plr.height-o.height)
            o.speedX,o.speedY = 0,0
            o.forcedState,o.forcedTimer = 8,-plr.idx
        end
    end
    SFX.play(52)
    muteMusic(-1)
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    smasBooleans.musicMuted = true
    GameData.winStateActive = true
    playervuln = true
    playerwon = true
    Routine.wait(3, true)
    if v.data._settings.activateFadeIn then
        smasStarSystem.fadeInActive = true
    end
    Routine.wait(2, true)
    smasBooleans.musicMuted = false
    GameData.winStateActive = false
    Level.exit(v.data._settings.winType)
end

function newstar.onPostNPCKill(v,reason)
    if newstar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
        Routine.run(starget)
    end
end

function newstar.onInputUpdate()
    if playerwon then
        for k,_ in pairs(player.keys) do
            player.keys[k] = false
        end
        if Player.count() >= 2 then
            for k,_ in pairs(player2.keys) do
                player2.keys[k] = false
            end
        end
    end
end

function newstar.animateNPC(v)
    v.data.animationTimer = v.data.animationTimer + 1
    if v.data.animationTimer%NPC.config[v.id].framespeed == 0 then
        v.data.frame = v.data.frame + 1 
        if v.data.frame > ((NPC.config[v.id].frames*v.data.frameMulti)-1) then
            v.data.frame = ((NPC.config[v.id].frames*v.data.frameMulti)-1)
        end
        v.data.animationTimer = 0
    end
    v.animationFrame = npcutils.getFrameByFramestyle(v, {frame=v.data.frame})
end

function newstar.isStarCollected(npc, filename)
    local collected = false
    if npc.data._settings.useOptionalTable then
        if table.icontains(SaveData.completeLevelsOptional,Level.filename()) then
            collected = true
        end
    else
        if table.icontains(SaveData.completeLevels,Level.filename()) then
            collected = true
        end
    end
    return collected
end

function newstar.onTickEndNPC(v)
    local data = v.data
 
    if not data.initialized then
        data._settings.starIndex = data._settings.starIndex or 1
        
        data.collected = newstar.isStarCollected(v, Level.filename())
        if data.collected then
            data.frameMulti = 1
        else
            data.frameMulti = 0.5
        end
        data.frame = ((NPC.config[v.id].frames*data.frameMulti)-1)
        data.animationTimer = 0
        data.initialized = true
    end
 
    if Defines.levelFreeze then return end
 
    newstar.animateNPC(v)
 
    if NPC.config[v.id].sparkles then
        v.ai4 = v.ai4 + 1
        if v.ai4 >= 10*data.frameMulti then
            v.ai4 = 0
            local e = Effect.spawn(80, v.x + RNG.random()*v.width - 2, v.y + RNG.random()*v.height)
            e.speedX = RNG.random()*1 - 0.5
            e.speedY = RNG.random()*1 - 0.5
            if data.frameMulti == 1 then -- set frame of effects only for collected stars
                e.animationFrame = 1
            end
        end
    end
 
    if NPC.config[v.id].floats and not v:mem(0x136, FIELD_BOOL) then
        if v.ai2 == 0 then
            v.speedY = v.speedY - 0.04
            if v.speedY <= -1.4 then v.ai2 = 1 end
        else
            v.speedY = v.speedY + 0.04
            if v.speedY >= 1.4 then v.ai2 = 0 end
        end
        -- if v.ai3 == 0 then -- idk what this for but it's in source?
        --     v.speedX = v.speedX - 0.03
        --     if v.speedX <= -0.6 then v.ai3 = 1 end
        -- else
        --     v.speedX = v.speedX + 0.03
        --     if v.speedX >= 0.6 then v.ai3 = 0 end
        -- end
    end
 
    if NPC.config[v.id].uselayerspeed then -- can't be used in conjunction with floats
        v.speedX, v.speedY = npcutils.getLayerSpeed(v)
    end
 
end

function newstar.onPlayerHarm(evt)
    if playervuln == true then
        evt.cancelled = true
    end
end

function newstar.onPlayerKill(evt)
    if playervuln == true then
        evt.cancelled = true
    end
end

function newstar.onPostNPCKill(v,reason)
    if newstar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
        for _,p in ipairs(Player.get()) do
            if Colliders.collide(p, v) then
                plr = p
            end
        end
        Routine.run(starget, v)
        if GameData.rushModeActive == false or GameData.rushModeActive == nil then
            if Misc.inMarioChallenge() == false then
                if v.data._settings.useOptionalTable then
                    if not table.icontains(SaveData.completeLevelsOptional,Level.filename()) then
                        if v.data._settings.addToTable then
                            table.insert(SaveData.completeLevelsOptional,Level.filename())
                        end
                        if v.data._settings.incrementStarCount then
                            SaveData.totalStarCount = SaveData.totalStarCount + 1
                        else
                            SaveData.totalStarCount = SaveData.totalStarCount
                        end
                    elseif table.icontains(SaveData.completeLevelsOptional,Level.filename()) then
                        SaveData.totalStarCount = SaveData.totalStarCount
                    end
                else
                    if not table.icontains(SaveData.completeLevels,Level.filename()) then
                        if v.data._settings.addToTable then
                            table.insert(SaveData.completeLevels,Level.filename())
                        end
                        if v.data._settings.incrementStarCount then
                            SaveData.totalStarCount = SaveData.totalStarCount + 1
                        else
                            SaveData.totalStarCount = SaveData.totalStarCount
                        end
                    elseif table.icontains(SaveData.completeLevels,Level.filename()) then
                        SaveData.totalStarCount = SaveData.totalStarCount
                    end
                end
            end
        end
    end
end

function newstar.onInitAPI()
    npcManager.registerEvent(npcID,newstar,"onTickNPC")
    npcManager.registerEvent(npcID,newstar,"onTickEndNPC")
    npcManager.registerEvent(npcID,newstar,"onDrawNPC")
    
    table.insert(newstar.collectableIDList,id)
    newstar.collectableIDMap[id] = true
    
    registerEvent(newstar,"onPlayerHarm")
    registerEvent(newstar,"onPlayerKill")
    registerEvent(newstar,"onInputUpdate")
    registerEvent(newstar,"onPostNPCKill")
    registerEvent(newstar,"onExit")
    registerEvent(newstar,"onDraw")
end

return newstar