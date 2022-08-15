-- Script from episode MaGLX3
-- Edited by LooKiCH (Lukinsky)

local speedruntimer = {} -- Lib
speedruntimer.resetTimerToStart = false

local textplus = require("textplus") -- Text Lib

SaveData.trackers = SaveData.trackers or {
    speedrunTimer = 0,
    levels = {}
}

GameData.SpeedrunTimerOnStart = GameData.SpeedrunTimerOnStart or 0

local font = textplus.loadFont("textplus/font/6.ini")  -- You can choose the path to the custom font on Level, ready-made fonts are in /data/scripts/textplus/font/

if SaveData.trackers.levels == nil then
    SaveData.trackers.levels = {}
end

function speedruntimer.onDraw()
    local space = Misc.GetKeyState(0x20)
    local f12 = Misc.GetKeyState(0x7B)
    if not space or not f12 then
        local timer1 = SaveData.trackers.speedrunTimer or 0
        -- Total Timer
        local t1 = string.format("%.1d:%.2d:%.2d.%.3d", timer1/(60 * 60 * 65), (timer1/(60*65))%60, (timer1/65)%60, ((timer1%65)/65) * 1000)
        textplus.print{
            text = t1,
            pivot = {0.5, 1},
            x = 400,
            y = 600,
            xscale = 2,
            font = font,
            yscale = 2,
            priority = -1
        }
        -- Level Timer
        local timer2 = GameData.localTimer or 0
        local t2 = string.format("%.1d:%.2d:%.2d.%.3d", timer2/(60 * 60 * 65), (timer2/(60*65))%60, (timer2/65)%60, ((timer2%65)/65) * 1000)
        textplus.print{
            text = t2,
            pivot = {0.5, 1},
            x = 400,
            y = 582,
            xscale = 2,
            font = font,
            yscale = 2,
            color = Color.lightgrey,
            priority = -1
        }
        -- Best Timer
        if not isOverworld then
            local best = SaveData.trackers.levels[Level.filename()].bestTime
            if best >= 0 then
                local t3 = string.format("%.1d:%.2d:%.2d.%.3d", best/(60 * 60 * 65), (best/(60*65))%60, (best/65)%60, ((best%65)/65) * 1000)
                textplus.print{
                    text = t3,
                    pivot = {0.5, 1},
                    x = 400,
                    y = 564,
                    xscale = 2,
                    font = font,
                    yscale = 2,
                    color = Color.lightgreen,
                    priority = -1
                }
            end
            if Level.winState() > 0 and not hasWon then -- Show Best Timer after Level Win
                hasWon = true
                local tracker = SaveData.trackers.levels[Level.filename()]
                if tracker.bestTime == -1 or tracker.bestTime > GameData.localTimer then -- Update Best Timer
                    tracker.bestTime = GameData.localTimer
                end
            end
            if GameData.winStateActive then -- Show Best Timer after Level Win
                hasWon = true
                local tracker = SaveData.trackers.levels[Level.filename()]
                if tracker.bestTime == -1 or tracker.bestTime > GameData.localTimer then -- Update Best Timer
                    tracker.bestTime = GameData.localTimer
                end
            end
        end
        if (not Misc.isPaused()) and (not hasWon) and (not hasDied) then -- Stop Timer on Pause, Level Win or Player Death
            GameData.localTimer = GameData.localTimer + 1 -- Launch Level Timer
        end
        -- You can change time format on 'local t1, t2 or t3'
        SaveData.trackers.speedrunTimer = SaveData.trackers.speedrunTimer + 1 -- Launch Total Timer
    end
end

function speedruntimer.onStart()
    if isOverworld then
        GameData.localTimer = 0
    else
        GameData.localTimer = GameData.localTimerSave or 0 -- Set Started Level Timer, saved after Checkpoint, else Started Level Timer = 0
    end
    if not isOverworld then
        if GameData.__checkpoints[Level.filename()].current == nil or GameData.localTimerSave == nil then -- If Unknown Level Timer, saved after Checkpoint
            GameData.localTimerSave = 0
            GameData.localTimer = 0
        end
        if SaveData.trackers.levels[Level.filename()] == nil then -- If Unknown Best Level Timer
            SaveData.trackers.levels[Level.filename()] =
            {
                bestTime = -1
            }
        end
    end
    if GameData.QuickRestart.LoadPowerUps and speedruntimer.resetTimerToStart then
        SaveData.trackers.speedrunTimer = GameData.SpeedrunTimerOnStart
    else
        GameData.SpeedrunTimerOnStart = SaveData.trackers.speedrunTimer
    end
end

function speedruntimer.onCheckpoint()
    GameData.SpeedrunTimerOnStart = SaveData.trackers.speedrunTimer
    if GameData.localTimerSave < GameData.localTimer then -- Save Level Timer after Checkpoint
        GameData.localTimerSave = GameData.localTimer
    end
end

-- Register Events for Lib
registerEvent(speedruntimer, "onStart")
registerEvent(speedruntimer, "onDraw")
registerEvent(speedruntimer, "onCheckpoint")

return speedruntimer -- Return Lib