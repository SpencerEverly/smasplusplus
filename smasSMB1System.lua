local smasSMB1System = {}

smasSMB1System.debug = false --True if debug mode is on
smasSMB1System.areaToCoverUpwards = 480 --How many tiles up should it be for the player to cross to get the checkpoint?
smasSMB1System.areaToCoverDownwards = 64 --How many tiles down should it be for the player to cross to get the checkpoint?
GameData.smasSMB1System = GameData.smasSMB1System or {}
GameData.smasSMB1System.crossedCheckpoint = GameData.smasSMB1System.crossedCheckpoint or ""

smasSMB1System.checkpointCoordinates = {
    ["SMB1 - W-1, L-1.lvlx"] = {x = -197402, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-1, L-2.lvlx"] = {x = -176826, y = -180128, crossed = false, section = 1},
    ["SMB1 - W-1, L-3.lvlx"] = {x = -197978, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-2, L-1.lvlx"] = {x = -196894, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-2, L-2.lvlx"] = {x = -177374, y = -180128, crossed = false, section = 1},
    ["SMB1 - W-2, L-3.lvlx"] = {x = -196222, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-3, L-1.lvlx"] = {x = -196862, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-3, L-2.lvlx"] = {x = -196666, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-3, L-3.lvlx"] = {x = -197818, y = -200096, crossed = false, section = 0},
    ["SMB1 - W-4, L-1.lvlx"] = {x = -196250, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-4, L-2.lvlx"] = {x = -176442, y = -180128, crossed = false, section = 1},
    ["SMB1 - W-4, L-3.lvlx"] = {x = -197818, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-5, L-1.lvlx"] = {x = -196730, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-5, L-2.lvlx"] = {x = -196794, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-5, L-3.lvlx"] = {x = -197946, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-6, L-1.lvlx"] = {x = -196826, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-6, L-2.lvlx"] = {x = -196890, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-6, L-3.lvlx"] = {x = -196922, y = -200096, crossed = false, section = 0},
    ["SMB1 - W-7, L-1.lvlx"] = {x = -196858, y = -200128, crossed = false, section = 0},
    ["SMB1 - W-7, L-2.lvlx"] = {x = -177370, y = -180128, crossed = false, section = 1},
    ["SMB1 - W-7, L-3.lvlx"] = {x = -197050, y = -200224, crossed = false, section = 0},
    ["SMBLL - W-1, L-1.lvlx"] = {x = -196058, y = -200128, crossed = false, section = 0},
    ["SMBLL - W-1, L-2.lvlx"] = {x = -177018, y = -180128, crossed = false, section = 1},
}

smasSMB1System.correctPathCoordinates = {
    ["SMB1 - W-4, L-4.lvlx"] = {
        rightPath = {
            [1] = 
                {x = -179386, y = -180384, sizeY = 96, passed = false},
            [2] = 
                {x = -176474, y = -180128, sizeY = 48, passed = false},
            },
        wrongPath = {
            [1] = 
                {x = -177850, y = -180160, sizeY = 96, playerX = -179546, playerY = -180224},
            [2] = 
                {x = -175354, y = -180256, sizeY = 96, playerX = -176762, playerY = -180224},
            },
    },
    ["SMB1 - W-7, L-4.lvlx"] = {
        rightPath = {
            [1] = 
                {x = -178650, y = -180160, sizeY = 96, passed = false},
            [2] = 
                {x = -178074, y = -180256, sizeY = 96, passed = false},
            [3] = 
                {x = -177466, y = -180384, sizeY = 96, passed = false},
            [4] = 
                {x = -176858, y = -180384, sizeY = 128, passed = false},
            [5] = 
                {x = -176090, y = -180256, sizeY = 96, passed = false},
            [6] = 
                {x = -175514, y = -180384, sizeY = 96, passed = false},
            },
        wrongPath = {
            [1] = 
                {x = -177498, y = -180160, sizeY = 96, playerX = -179066, playerY = -180256},
            [2] = 
                {x = -175546, y = -180256, sizeY = 96, playerX = -177146, playerY = -180256},
            },
    },
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
    smb1Checkpoint = Checkpoint({x = smasSMB1System.checkpointCoordinates[Level.filename()].x, y = smasSMB1System.checkpointCoordinates[Level.filename()].y, section = smasSMB1System.checkpointCoordinates[Level.filename()].section})
end

function smasSMB1System.onExitLevel(winType)
    if winType > 0 then
        GameData.smasSMB1System.crossedCheckpoint = ""
    end
end

function smasSMB1System.onStart()
    if (table.icontains(smasTables.__smb1Levels,Level.filename()) or table.icontains(smasTables.__smbllLevels,Level.filename())) then 
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
    if (table.icontains(smasTables.__smb1Levels,Level.filename()) or table.icontains(smasTables.__smbllLevels,Level.filename())) then
        for _,p in ipairs(Player.get()) do
            if smasSMB1System.checkpointCoordinates[Level.filename()] ~= nil then
                if smasSMB1System.debug then
                    Graphics.drawBox{
                        x = smasSMB1System.checkpointCoordinates[Level.filename()].x,
                        y = smasSMB1System.checkpointCoordinates[Level.filename()].y - smasSMB1System.areaToCoverUpwards,
                        width = 32,
                        height = 600,
                        sceneCoords = true,
                        color = Color.lightgreen..0.5,
                    }
                end
                if Collisionz.CheckCollisionNoEntity(smasSMB1System.checkpointCoordinates[Level.filename()].x, smasSMB1System.checkpointCoordinates[Level.filename()].y - smasSMB1System.areaToCoverUpwards, 32, 600, p.x, p.y, p.width, p.height) and not smasSMB1System.checkpointCoordinates[Level.filename()].crossed then
                    if smasSMB1System.debug then
                        Sound.playSFX(58)
                    end
                    smb1Checkpoint:collect()
                    GameData.smasSMB1System.crossedCheckpoint = Level.filename()
                    smasSMB1System.checkpointCoordinates[Level.filename()].crossed = true
                end
            end
            if smasSMB1System.correctPathCoordinates[Level.filename()] ~= nil then
                for i = 1,#smasSMB1System.correctPathCoordinates[Level.filename()].rightPath do
                    if smasSMB1System.debug then
                        Graphics.drawBox{
                            x = smasSMB1System.correctPathCoordinates[Level.filename()].rightPath[i].x,
                            y = smasSMB1System.correctPathCoordinates[Level.filename()].rightPath[i].y,
                            width = 32,
                            height = smasSMB1System.correctPathCoordinates[Level.filename()].rightPath[i].sizeY,
                            sceneCoords = true,
                            color = Color.green..0.5,
                        }
                    end
                    if Collisionz.CheckCollisionNoEntity(smasSMB1System.correctPathCoordinates[Level.filename()].rightPath[i].x, smasSMB1System.correctPathCoordinates[Level.filename()].rightPath[i].y, 32, smasSMB1System.correctPathCoordinates[Level.filename()].rightPath[i].sizeY, p.x, p.y, p.width, p.height) and not smasSMB1System.correctPathCoordinates[Level.filename()].rightPath[i].passed then
                        Sound.playSFX(151)
                        smasSMB1System.correctPathCoordinates[Level.filename()].rightPath[i].passed = true
                    end
                end
            end
            if smasSMB1System.correctPathCoordinates[Level.filename()] ~= nil then
                for i = 1,#smasSMB1System.correctPathCoordinates[Level.filename()].wrongPath do
                    if smasSMB1System.debug then
                        Graphics.drawBox{
                            x = smasSMB1System.correctPathCoordinates[Level.filename()].wrongPath[i].x,
                            y = smasSMB1System.correctPathCoordinates[Level.filename()].wrongPath[i].y,
                            width = 32,
                            height = smasSMB1System.correctPathCoordinates[Level.filename()].wrongPath[i].sizeY,
                            sceneCoords = true,
                            color = Color.red..0.5,
                        }
                    end
                    if Collisionz.CheckCollisionNoEntity(smasSMB1System.correctPathCoordinates[Level.filename()].wrongPath[i].x, smasSMB1System.correctPathCoordinates[Level.filename()].wrongPath[i].y, 32, smasSMB1System.correctPathCoordinates[Level.filename()].wrongPath[i].sizeY, p.x, p.y, p.width, p.height) then
                        Sound.playSFX(152)
                        smasNoTurnBack.reviveOriginalBoundaries()
                        p:teleport(smasSMB1System.correctPathCoordinates[Level.filename()].wrongPath[i].playerX, smasSMB1System.correctPathCoordinates[Level.filename()].wrongPath[i].playerY, true)
                    end
                end
            end
        end
    end
end

return smasSMB1System