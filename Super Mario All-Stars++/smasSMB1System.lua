local smasSMB1System = {}

smasSMB1System.debug = false
GameData.smasSMB1System = GameData.smasSMB1System or {}
GameData.smasSMB1System.crossedCheckpoint = GameData.smasSMB1System.crossedCheckpoint or ""

if GameData.smasSMB1System.crossedCheckpoint == Level.filename() then
    if smasSMB1System.checkpointCoordinates[Level.filename()] ~= nil then
        smasSMB1System.checkpointCoordinates[Level.filename()].crossed = true
    end
end

smasSMB1System.checkpointCoordinates = {
    ["SMB1 - W-1, L-1.lvlx"] = {x = -197402, y = -200608, playerX = -197402, playerY = -200160, crossed = false},
    --[["SMB1 - W-1, L-2.lvlx",
    "SMB1 - W-1, L-3.lvlx",
    "SMB1 - W-1, L-4.lvlx",
    "SMB1 - W-2, L-1.lvlx",
    "SMB1 - W-2, L-2.lvlx",
    "SMB1 - W-2, L-3.lvlx",
    "SMB1 - W-2, L-4.lvlx",
    "SMB1 - W-3, L-1.lvlx",
    "SMB1 - W-3, L-2.lvlx",
    "SMB1 - W-3, L-3.lvlx",
    "SMB1 - W-3, L-4.lvlx",
    "SMB1 - W-4, L-1.lvlx",
    "SMB1 - W-4, L-2.lvlx",
    "SMB1 - W-4, L-3.lvlx",
    "SMB1 - W-4, L-4.lvlx",
    "SMB1 - W-5, L-1.lvlx",
    "SMB1 - W-5, L-2.lvlx",
    "SMB1 - W-5, L-3.lvlx",
    "SMB1 - W-5, L-4.lvlx",
    "SMB1 - W-6, L-1.lvlx",
    "SMB1 - W-6, L-2.lvlx",
    "SMB1 - W-6, L-3.lvlx",
    "SMB1 - W-6, L-4.lvlx",
    "SMB1 - W-7, L-1.lvlx",
    "SMB1 - W-7, L-2.lvlx",
    "SMB1 - W-7, L-3.lvlx",
    "SMB1 - W-7, L-4.lvlx",
    "SMB1 - W-8, L-1.lvlx",
    "SMB1 - W-8, L-2.lvlx",
    "SMB1 - W-8, L-3.lvlx",
    "SMB1 - W-8, L-4.lvlx",
    "SMB1 - W-9, L-1.lvlx",
    "SMB1 - W-9, L-2.lvlx",
    "SMB1 - W-9, L-3.lvlx",
    "SMB1 - W-9, L-4.lvlx",]]
}

function smasSMB1System.onInitAPI()
    registerEvent(smasSMB1System,"onStart")
    registerEvent(smasSMB1System,"onTick")
    registerEvent(smasSMB1System,"onExitLevel")
end

local smb1Checkpoint

if smasSMB1System.checkpointCoordinates[Level.filename()] ~= nil then
    smb1Checkpoint = Checkpoint({x = smasSMB1System.checkpointCoordinates[Level.filename()].playerX, y = smasSMB1System.checkpointCoordinates[Level.filename()].playerY, section = player.section})
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
                    v:kill(HARM_TYPE_VANISH)
                end
            end
        end
    end
end

function smasSMB1System.onTick()
    if table.icontains(smasTables.__smb1Levels,Level.filename()) then
        for _,p in ipairs(Player.get()) do
            if smasSMB1System.checkpointCoordinates[Level.filename()] ~= nil then
                if Collisionz.CheckCollisionNoEntity(smasSMB1System.checkpointCoordinates[Level.filename()].x, smasSMB1System.checkpointCoordinates[Level.filename()].y, 32, 600, p.x, p.y, p.width, p.height) and not smasSMB1System.checkpointCoordinates[Level.filename()].crossed then
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