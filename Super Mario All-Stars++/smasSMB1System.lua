local smasSMB1System = {}

smasSMB1System.debug = false --True if debug mode is on
smasSMB1System.areaToCoverUpwards = 480 --How many tiles up should it be for the player to cross to get the checkpoint?
GameData.smasSMB1System = GameData.smasSMB1System or {}
GameData.smasSMB1System.crossedCheckpoint = GameData.smasSMB1System.crossedCheckpoint or ""

smasSMB1System.checkpointCoordinates = {
    ["SMB1 - W-1, L-1.lvlx"] = {x = -197402, y = -200128, crossed = false},
    ["SMB1 - W-1, L-2.lvlx"] = {x = -176826, y = -180128, crossed = false},
    ["SMB1 - W-1, L-3.lvlx"] = {x = -197978, y = -200128, crossed = false},
    ["SMB1 - W-2, L-1.lvlx"] = {x = -196894, y = -200128, crossed = false},
    ["SMB1 - W-2, L-2.lvlx"] = {x = -177374, y = -180128, crossed = false},
    ["SMB1 - W-2, L-3.lvlx"] = {x = -196222, y = -200128, crossed = false},
    ["SMB1 - W-3, L-1.lvlx"] = {x = -196862, y = -200128, crossed = false},
    ["SMB1 - W-3, L-2.lvlx"] = {x = -196666, y = -200128, crossed = false},
    ["SMB1 - W-3, L-3.lvlx"] = {x = -197818, y = -200096, crossed = false},
    ["SMB1 - W-4, L-1.lvlx"] = {x = -196250, y = -200128, crossed = false},
    ["SMB1 - W-4, L-2.lvlx"] = {x = -176442, y = -180128, crossed = false},
    ["SMB1 - W-4, L-3.lvlx"] = {x = -197818, y = -200128, crossed = false},
    --[[["SMB1 - W-5, L-1.lvlx"],
    ["SMB1 - W-5, L-2.lvlx"],
    ["SMB1 - W-5, L-3.lvlx"],
    ["SMB1 - W-5, L-4.lvlx"],
    ["SMB1 - W-6, L-1.lvlx"],
    ["SMB1 - W-6, L-2.lvlx"],
    ["SMB1 - W-6, L-3.lvlx"],
    ["SMB1 - W-6, L-4.lvlx"],
    ["SMB1 - W-7, L-1.lvlx"],
    ["SMB1 - W-7, L-2.lvlx"],
    ["SMB1 - W-7, L-3.lvlx"],
    ["SMB1 - W-7, L-4.lvlx"],
    ["SMB1 - W-8, L-1.lvlx"],
    ["SMB1 - W-8, L-2.lvlx"],
    ["SMB1 - W-8, L-3.lvlx"],
    ["SMB1 - W-8, L-4.lvlx"],
    ["SMB1 - W-9, L-1.lvlx"],
    ["SMB1 - W-9, L-2.lvlx"],
    ["SMB1 - W-9, L-3.lvlx"],
    ["SMB1 - W-9, L-4.lvlx"],]]
}

if GameData.smasSMB1System.crossedCheckpoint == Level.filename() then
    smasSMB1System.checkpointCoordinates[Level.filename()].crossed = true
end

function smasSMB1System.onInitAPI()
    registerEvent(smasSMB1System,"onStart")
    registerEvent(smasSMB1System,"onTick")
    registerEvent(smasSMB1System,"onExitLevel")
end

local smb1Checkpoint

if smasSMB1System.checkpointCoordinates[Level.filename()] ~= nil then
    smb1Checkpoint = Checkpoint({x = smasSMB1System.checkpointCoordinates[Level.filename()].x, y = smasSMB1System.checkpointCoordinates[Level.filename()].y, section = player.section})
end

function smasSMB1System.onExitLevel(winType)
    if winType > 0 then
        GameData.smasSMB1System.crossedCheckpoint = ""
    end
end

function smasSMB1System.onStart()
    if table.icontains(smasTables.__smb1Levels,Level.filename()) then 
        if SysManager.getEnteredCheckpointID() ~= 0 then
            for k,v in ipairs(NPC.get()) do
                if NPC.isOnScreen(v) then
                    if not smasTables.allNPCsToExcludeOnSMASSMB1System[v.id] then
                        v:kill(HARM_TYPE_VANISH)
                    end
                end
            end
        end
    end
end

function smasSMB1System.onTick()
    if table.icontains(smasTables.__smb1Levels,Level.filename()) then
        for _,p in ipairs(Player.get()) do
            if smasSMB1System.checkpointCoordinates[Level.filename()] ~= nil then
                if Collisionz.CheckCollisionNoEntity(smasSMB1System.checkpointCoordinates[Level.filename()].x, smasSMB1System.checkpointCoordinates[Level.filename()].y - smasSMB1System.areaToCoverUpwards, 32, 600, p.x, p.y, p.width, p.height) and not smasSMB1System.checkpointCoordinates[Level.filename()].crossed then
                    if smasSMB1System.debug then
                        Sound.playSFX(58)
                    end
                    smb1Checkpoint:collect()
                    GameData.smasSMB1System.crossedCheckpoint = Level.filename()
                    smasSMB1System.checkpointCoordinates[Level.filename()].crossed = true
                end
            end
        end
    end
end

return smasSMB1System