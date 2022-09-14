local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local extrasounds = require("extrasounds")
local Routine = require("routine")
local rng = require("base/rng")
local customCamera = require("customCamera")
local smasbooleans = require("smasbooleans")

local roulettestar = {}

local npcID = NPC_ID
local id = 985

local roulettestarSettings = {
    id = 985,
    
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
    
}

local collectactive = false
local playervuln = false
local playerwon = false
local playermovement = 0
local player2movement = 0
roulettestar.collectableIDList = {}
roulettestar.collectableIDMap  = {}
roulettestar.collectableIDStar = {}

npcManager.setNpcSettings(roulettestarSettings)
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
local newboundary
local oldboundary
local endRoomToScroll = 0

function starget()
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
    oldboundary = plr.sectionObj.origBoundary
    GameData.winStateActive = true
    inactivekeysonly = true
    playervuln = true
    playerwon = true
    SFX.play(52)
    muteMusic(-1)
    Audio.SeizeStream(-1)
    Audio.MusicStop()
    smasbooleans.musicMuted = true
    smasbooleans.targetPlayers = false
    smasbooleans.overrideTargets = true
    local currentSection = Section(plr.section)
    newboundary = plr.sectionObj.boundary
    newboundary.right = newboundary.right + 350
    plr.sectionObj.boundary = newboundary
    Routine.wait(5, true)
    GameData.winStateActive = false
    Level.exit(LEVEL_WIN_TYPE_STAR)
end

function roulettestar.onCameraUpdate()
    if collectactive then
        if camera.x > oldboundary.left then
            camera.x = oldboundary.right - camera.width
        end
    end
end

local player2camerax
local player2cameray
local inactivekeysonly = false

function roulettestar.onDraw()
    local playercameray = player.y - camera.y
    local playercamerax = player.x - camera.x
    if Player.count() >= 2 then
        player2camerax = Player(2).x - camera.x
        player2cameray = Player(2).y - camera.y
    end
    if collectactive then
        for _,p in ipairs(Player.get()) do
            if p:isOnGround() then
                p.speedX = 3
                playerwon = false
                inactivekeysonly = true
                p.direction = DIR_RIGHT
            end
        end
    end
end

function roulettestar.onPostNPCKill(v,reason)
    for _,p in ipairs(Player.get()) do
        if v.id == 985 and Colliders.collide(p, v) then
            if v.animationFrame == 0 then
                Misc.givePoints(6, vector(v.x + 26, v.y))
            elseif v.animationFrame == 1 then
                Misc.givePoints(8, vector(v.x + 26, v.y))
            elseif v.animationFrame == 2 then
                Misc.givePoints(10, vector(v.x + 26, v.y))
            end
        end
    end
    for _,p in ipairs(Player.get()) do
        if Colliders.collide(p, v) then
            plr = p
        end
    end
    if roulettestar.collectableIDMap[v.id] and npcManager.collected(v,reason) then
        Routine.run(starget)
        GameData.winStateActive = true
        collectactive = true
        if GameData.rushModeActive == false or GameData.rushModeActive == nil then
            if Misc.inMarioChallenge() == false then
                if not table.icontains(SaveData.completeLevels,Level.filename()) then
                    SaveData.totalStarCount = SaveData.totalStarCount + 1
                    table.insert(SaveData.completeLevels,Level.filename())
                elseif table.icontains(SaveData.completeLevels,Level.filename()) then
                    SaveData.totalStarCount = SaveData.totalStarCount
                end
            end
        end
    end
end

function roulettestar.onInputUpdate()
    if playerwon then
        player.upKeyPressing = false
        player.downKeyPressing = false
        player.leftKeyPressing = false
        player.rightKeyPressing = false
        player.altJumpKeyPressing = false
        player.runKeyPressing = false
        player.altRunKeyPressing = false
        player.dropItemKeyPressing = false
        player.jumpKeyPressing = false
        player.pauseKeyPressing = false
        if Player.count() >= 2 then
            player2.upKeyPressing = false
            player2.downKeyPressing = false
            player2.leftKeyPressing = false
            player2.rightKeyPressing = false
            player2.altJumpKeyPressing = false
            player2.runKeyPressing = false
            player2.altRunKeyPressing = false
            player2.dropItemKeyPressing = false
            player2.jumpKeyPressing = false
            player2.pauseKeyPressing = false
        end
    end
    if inactivekeysonly then
        player.upKeyPressing = false
        player.downKeyPressing = false
        player.leftKeyPressing = false
        player.rightKeyPressing = false
        player.altJumpKeyPressing = false
        player.runKeyPressing = false
        player.altRunKeyPressing = false
        player.dropItemKeyPressing = false
        player.jumpKeyPressing = false
        player.pauseKeyPressing = false
        if Player.count() >= 2 then
            player2.upKeyPressing = false
            player2.downKeyPressing = false
            player2.leftKeyPressing = false
            player2.rightKeyPressing = false
            player2.altJumpKeyPressing = false
            player2.runKeyPressing = false
            player2.altRunKeyPressing = false
            player2.dropItemKeyPressing = false
            player2.jumpKeyPressing = false
            player2.pauseKeyPressing = false
        end
    end
end

function roulettestar.onPlayerHarm(evt)
    if playervuln == true then
        evt.cancelled = true
    end
end

function roulettestar.onPlayerKill(evt)
    if playervuln == true then
        evt.cancelled = true
    end
end

function roulettestar.onExit()
    smasbooleans.musicMuted = false
    GameData.winStateActive = false
    if Level.endState() == LEVEL_END_STATE_ROULETTE then
        GameData.smwMap.winType = 6
        Level.exit(LEVEL_WIN_TYPE_STAR)
    end
end

function roulettestar.onInitAPI()
    npcManager.registerEvent(npcID,roulettestar,"onTickNPC")
    
    table.insert(roulettestar.collectableIDList,id)
    roulettestar.collectableIDMap[id] = true
    roulettestar.collectableIDStar[97] = true
    
    registerEvent(roulettestar,"onPlayerHarm")
    registerEvent(roulettestar,"onPlayerKill")
    registerEvent(roulettestar,"onInputUpdate")
    registerEvent(roulettestar,"onNPCKill")
    registerEvent(roulettestar,"onPostNPCKill")
    registerEvent(roulettestar,"onDraw")
    registerEvent(roulettestar,"onExit")
    registerEvent(roulettestar,"onCameraUpdate")
end

return roulettestar