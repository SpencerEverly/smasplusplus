local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")
local Routine = require("routine")
local rng = require("base/rng")
local smasBooleans = require("smasBooleans")

local dudstar = {}

local npcID = NPC_ID
local id = 982

local dudStarSettings = {
    id = 982,
    
    gfxwidth = 32,
    gfxheight = 32,

    gfxoffsetx = 0,
    gfxoffsety = 0,
    
    width = 32,
    height = 32,
    
    frames = 1,
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

npcManager.setNpcSettings(dudStarSettings)
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
dudstar.collectableIDList = {}
dudstar.collectableIDMap  = {}

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

function dudstar.onPostNPCKill(v,reason)
    if dudstar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
        Routine.run(starget)
    end
end

function dudstar.onInputUpdate()
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

function dudstar.onPlayerHarm(evt)
    if playervuln == true then
        evt.cancelled = true
    end
end

function dudstar.onPlayerKill(evt)
    if playervuln == true then
        evt.cancelled = true
    end
end

function dudstar.onPostNPCKill(v,reason)
    if dudstar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
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

function dudstar.onInitAPI()
    table.insert(dudstar.collectableIDList,id)
    dudstar.collectableIDMap[id] = true
    
    registerEvent(dudstar,"onPlayerHarm")
    registerEvent(dudstar,"onPlayerKill")
    registerEvent(dudstar,"onInputUpdate")
    registerEvent(dudstar,"onPostNPCKill")
    registerEvent(dudstar,"onExit")
end

return dudstar