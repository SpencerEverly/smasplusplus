local textplus = require("textplus")
local cutsceneenabled = false
Graphics.activateHud(false)

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
    if player.rawKeys.pause == KEYS_PRESSED then
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
    Audio.sounds[1].muted = true
    Audio.sounds[2].muted = true
    Audio.sounds[3].muted = true
    Audio.sounds[4].muted = true
    Audio.sounds[5].muted = true
    Audio.sounds[6].muted = true
    Audio.sounds[7].muted = true
    Audio.sounds[8].muted = true
    Audio.sounds[9].muted = true
    Audio.sounds[10].muted = true
    Audio.sounds[11].muted = true
    Audio.sounds[12].muted = true
    Audio.sounds[13].muted = true
    Audio.sounds[14].muted = true
    Audio.sounds[15].muted = true
    Audio.sounds[16].muted = true
    Audio.sounds[17].muted = true
    Audio.sounds[18].muted = true
    Audio.sounds[19].muted = true
    Audio.sounds[20].muted = true
    Audio.sounds[21].muted = true
    Audio.sounds[22].muted = true
    Audio.sounds[23].muted = true
    Audio.sounds[24].muted = true
    Audio.sounds[25].muted = true
    Audio.sounds[29].muted = true
    Audio.sounds[31].muted = true
    Audio.sounds[32].muted = true
    Audio.sounds[33].muted = true
    Audio.sounds[34].muted = true
    Audio.sounds[35].muted = true
    Audio.sounds[36].muted = true
    Audio.sounds[37].muted = true
    Audio.sounds[42].muted = true
    Audio.sounds[43].muted = true
    Audio.sounds[44].muted = true
    Audio.sounds[46].muted = true
    Audio.sounds[48].muted = true
    Audio.sounds[49].muted = true
    Audio.sounds[50].muted = true
    Audio.sounds[51].muted = true
    Audio.sounds[54].muted = true
    Audio.sounds[55].muted = true
    Audio.sounds[57].muted = true
    Audio.sounds[58].muted = true
    Audio.sounds[59].muted = true
    Audio.sounds[61].muted = true
    Audio.sounds[62].muted = true
    Audio.sounds[63].muted = true
    Audio.sounds[71].muted = true
    Audio.sounds[72].muted = true
    Audio.sounds[73].muted = true
    Audio.sounds[74].muted = true
    Audio.sounds[75].muted = true
    Audio.sounds[76].muted = true
    Audio.sounds[77].muted = true
    Audio.sounds[78].muted = true
    Audio.sounds[79].muted = true
    Audio.sounds[80].muted = true
    Audio.sounds[81].muted = true
    Audio.sounds[82].muted = true
    Audio.sounds[83].muted = true
    Audio.sounds[84].muted = true
    Audio.sounds[85].muted = true
    Audio.sounds[86].muted = true
    Audio.sounds[87].muted = true
    Audio.sounds[88].muted = true
    Audio.sounds[89].muted = true
    Audio.sounds[90].muted = true
    Audio.sounds[91].muted = true
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
        Audio.MusicChange(3, "_OST/Super Mario Bros 2/Ending Cutscene (Part 3).ogg")
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

