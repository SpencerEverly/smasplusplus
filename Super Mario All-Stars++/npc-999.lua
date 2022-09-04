local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")
local Routine = require("routine")
local rng = require("base/rng")
local smasbooleans = require("smasbooleans")
local smasstarsystem = require("smasstarsystem")

local neworb = {}

local npcID = NPC_ID
local id = 999

local neworbSettings = {
    id = 999,
    
    gfxwidth = 32,
    gfxheight = 32,

    gfxoffsetx = 0,
    gfxoffsety = 0,
    
    width = 32,
    height = 32,
    
    frames = 8,
    framestyle = 1,
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
    
    
}

npcManager.setNpcSettings(neworbSettings)
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
neworb.collectableIDList = {}
neworb.collectableIDMap  = {}

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
    smasbooleans.musicMuted = true
    GameData.winStateActive = true
    playervuln = true
    playerwon = true
    Routine.wait(3, true)
    if v.data._settings.activateFadeIn then
        smasstarsystem.fadeInActive = true
    end
    Routine.wait(2, true)
    smasbooleans.musicMuted = false
    GameData.winStateActive = false
    Level.exit(v.data._settings.winType)
end

function neworb.onPostNPCKill(v,reason)
    if neworb.collectableIDMap[v.id] and npcManager.collected(v,reason) then
        Routine.run(starget)
    end
end

function neworb.onInputUpdate()
    if playerwon then
        for k,p in ipairs(Player.get()) do
            p.upKeyPressing = false
            p.downKeyPressing = false
            p.leftKeyPressing = false
            p.rightKeyPressing = false
            p.altJumpKeyPressing = false
            p.runKeyPressing = false
            p.altRunKeyPressing = false
            p.dropItemKeyPressing = false
            p.jumpKeyPressing = false
            p.pauseKeyPressing = false
        end
    end
end

function neworb.animateNPC(v)
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

function neworb.isStarCollected(npc, filename)
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

function neworb.onPlayerHarm(evt)
    if playervuln == true then
        evt.cancelled = true
    end
end

function neworb.onPlayerKill(evt)
    if playervuln == true then
        evt.cancelled = true
    end
end

function neworb.onPostNPCKill(v,reason)
    if neworb.collectableIDMap[v.id] and npcManager.collected(v,reason) then
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
                        table.insert(SaveData.completeLevelsOptional,Level.filename())
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
                        table.insert(SaveData.completeLevels,Level.filename())
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

function neworb.onInitAPI()
    npcManager.registerEvent(npcID,neworb,"onTickNPC")
    npcManager.registerEvent(npcID,neworb,"onTickEndNPC")
    npcManager.registerEvent(npcID,neworb,"onDrawNPC")
    
    table.insert(neworb.collectableIDList,id)
    neworb.collectableIDMap[id] = true
    
    registerEvent(neworb,"onPlayerHarm")
    registerEvent(neworb,"onPlayerKill")
    registerEvent(neworb,"onInputUpdate")
    registerEvent(neworb,"onPostNPCKill")
    registerEvent(neworb,"onExit")
    registerEvent(neworb,"onDraw")
end

return neworb