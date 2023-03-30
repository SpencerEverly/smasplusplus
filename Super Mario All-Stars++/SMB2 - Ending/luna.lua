local textplus = require("textplus")
local cutsceneenabled = false
Graphics.activateHud(false)
smasbooleans.disablePauseMenu = true

local timer1 = 0
local speed = 0
local numberup = 0
local time = 0
local opacity = timer1/speed
local middle = math.floor(timer1*numberup)
local blackfadein = false
local blackfadeout = false

function onInputUpdate()
    player.upKeyPressing = false
    player.downKeyPressing = false
    player.leftKeyPressing = false
    player.rightKeyPressing = false
    player.altJumpKeyPressing = false
    player.runKeyPressing = false
    player.altRunKeyPressing = false
    player.dropItemKeyPressing = false
    if player.keys.pause == KEYS_PRESSED then
        player:teleport(-179648, -180320)
        if Player.count() >= 2 then
            player2:teleport(-179584, -180320)
        end
    end
end

function onDraw()
    textplus.print{x=10, y=10, text = "Press pause to skip.", priority=0, color=Color.yellow}
    Graphics.drawBox{x=5, y=5, width=95, height=20, color=Color.red..0.5, priority=-1}
    if blackfadein then
        time = time + 1
        Graphics.drawScreen{color = Color.black..math.max(0,time/47),priority = 1}
    end
    if whiteflashpre1 then
        time = time + 1
        Graphics.drawScreen{color = Color.white..math.max(0,time/293),priority = 1}
    end
    if whiteflashpre2 then
        time = time + 1
        Graphics.drawScreen{color = Color.white..math.max(0,time/243),priority = 1}
    end
end

function onTick()
    for i=1, 91 do
        Audio.sounds[i].muted = true
    end
    player:setFrame(50) --Prevent the player from showing up on the boot menu
    player:mem(0x140, FIELD_BOOL, 150)
    if Player.count() >= 2 then
        player2:setFrame(50)
        player2:mem(0x142, FIELD_BOOL, true)
    end
    if player.section == 4 then
        Text.printWP("That following night...", 200, 300, -2)
    end
end

function onEvent(eventName)
    if eventName == "Cutscene Stop Pressing 2" then
        
    end
    if eventName == "Cutscene 3" then
        blackfadein = true
    end
    if eventName == "Cutscene 4" then
        player:teleport(-159488, -160224)
        if Player.count() >= 2 then
            player2:teleport(-159328, -160224)
        end
        blackfadein = false
        blackfadein = nil
        time = 0
    end
    if eventName == "Cutscene 8" then
        blackfadein = true
    end
    if eventName == "Cutscene 9" then
        blackfadein = false
        blackfadein = nil
        time = 0
        player:teleport(-119808, -120384)
        if Player.count() >= 2 then
            player2:teleport(-119712, -120384)
        end
    end
    if eventName == "Cutscene 10" then
        player:teleport(-139712, -140416)
        if Player.count() >= 2 then
            player2:teleport(-139616, -140416)
        end
    end
    if eventName == "Cutscene 11" then
        whiteflashpre1 = true
    end
    if eventName == "Cutscene 12" then
        whiteflashpre1 = false
        whiteflashpre1 = nil
        time = 0
        player:teleport(-99648, -100160)
        if Player.count() >= 2 then
            player2:teleport(-99584, -100160)
        end
    end
    if eventName == "Cutscene 15" then
        Audio.MusicFadeOut(player.section, 4000)
        whiteflashpre2 = true
    end
    if eventName == "Cutscene 16" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Ending Cutscene (Part 3).ogg", 3)
        whiteflashpre2 = false
        whiteflashpre2 = nil
        time = 0
        player:teleport(-139712, -140416)
        if Player.count() >= 2 then
            player2:teleport(-139616, -140416)
        end
        cutsceneenabled = false
    end
    if eventName == "Cutscene 17" then
        
    end
end

