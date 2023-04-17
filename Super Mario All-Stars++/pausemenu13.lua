local textplus = require("textplus")
local imagic = require("imagic")
local rng = require("rng")
local playerManager = require("playerManager")
local Routine = require("routine")

local blackscreen = Graphics.loadImage("blackscreen.png")

local active = true
local active2 = false
local ready = false
local exitscreen = false

local pausefont = textplus.loadFont("littleDialogue/font/11-pause.ini")

local cooldown = 0

onePressedState = false
twoPressedState = false
threePressedState = false
fourPressedState = false
fivePressedState = false
sixPressedState = false
sevenPressedState = false
eightPressedState = false
ninePressedState = false
zeroPressedState = false

local flag = true
local str = "Loading HUB..."

local pausemenu13 = {}

pausemenu13.pauseactivated = true

local soundObject

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

pausemenu13.paused = false;
pausemenu13.paused_char = false;
pausemenu13.paused_char_temp = false;
local pause_box;
local pause_height = 0;
local pause_width = 700;

local pause_options;
local pause_options_char;
local character_options;
local pause_index = 0
local pause_index_char = 0

local pauseactive = false
local charactive = false

local level = Level.filename()

function pausemenu13.onInitAPI()
    registerEvent(pausemenu13, "onKeyboardPress")
    registerEvent(pausemenu13, "onDraw")
    registerEvent(pausemenu13, "onLevelExit")
    registerEvent(pausemenu13, "onTick")
    registerEvent(pausemenu13, "onInputUpdate")
    registerEvent(pausemenu13, "onStart")
    
    local Routine = require("routine")
    
    ready = true
end

local function nothing()
    --Nothing happens here
end

local function unpause()
    pausemenu13.paused = false
    Misc.unpause()
    SFX.play(30)
end

function pausemenu13.onStart()
    if not ready then return end
end

local function x2modeenable()
    Graphics.activateHud(false)
    Cheats.trigger("1player")
    Defines.player_hasCheated = false
    if SaveData.disableX2char then
        SaveData.disableX2char = false
        Level.load(Level.filename())
    end
    pausemenu13.paused = false
    Misc.unpause()
end

local function x2modedisable()
    pausemenu13.paused = false
    Misc.unpause()
    if not SaveData.disableX2char then
        SaveData.disableX2char = true
        Level.load(Level.filename())
    end
end

local function quitgame()
    Audio.MusicVolume(0)
    Misc.saveGame()
    SFX.play(14)
    pausemenu13.paused = false
    Routine.run(function() exitscreen = true Routine.wait(0.4, true) Misc.unpause() Audio.MusicVolume(nil) Misc.exitEngine() end)
end

local function savegame()
    pausemenu13.paused = false
    SFX.play(58)
    Misc.saveGame()
    Misc.unpause()
end

local function drawPauseMenu(y, alpha)
    local name = " "
    --local font = textblox.FONT_SPRITEDEFAULT3X2;
    
    local layout = textplus.layout(textplus.parse(name, {xscale=2, yscale=2, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
    local w,h = layout.width, layout.height
    textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 5}
    --local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = pausefont, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
    
    h = h+4+0--font.charHeight;
    y = y+h;
    
    
    if(pause_options == nil) then
        pause_options = 
        {
            {name="CONTINUE", action=unpause}
        }
        if SaveData.disableX2char then
            table.insert(pause_options, {name="TURN OFF SMBX 1.3 MODE", action = x2modeenable});
        end
        if not SaveData.disableX2char then
            table.insert(pause_options, {name="TURN ON SMBX 1.3 MODE", action = x2modedisable});
        end
        table.insert(pause_options, {name="SAVE AND CONTINUE", action = savegame});
        table.insert(pause_options, {name="SAVE AND QUIT", action = quitgame});
    end
    for k,v in ipairs(pause_options) do
        local c = 0xFFFFFF00;
        local n = v.name;
        if(v.inactive) then
            c = 0x99999900;
        end
        if(k == pause_index+1) then
            n = "! ".."<color white>"..n.."</color>";
        end
            
        local layout = textplus.layout(textplus.parse(n, {xscale=2, yscale=2, font = pausefont}), pause_width)
        local h2 = layout.height
        textplus.render{layout = layout, x = 583 - layout.width, y = y, color = Color.fromHex(c+alpha*255), priority = 0}
        --local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
        h2 = h2+2+18--font.charHeight;
        y = y+h2;
        h = h+h2;
    end

    
    return h;
end

function pausemenu13.onDraw(camIdx,priority,isSplit)
    if pausemenu13.paused then
        Misc.pause()
        if(pause_box == nil) then
            pause_height = drawPauseMenu(-600,0);
            pause_box = imagic.Create{x=393,y=300,width=405,height=pause_height,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
        end
        pause_box:Draw(-1, 0x000000FF);
        drawPauseMenu(300-pause_height*0.5,1)
        
        --Fix for anything calling Misc.unpause
        Misc.pause();
    end
    if not pausemenu13.paused then
        pause_box = nil
    end
    if exitscreen then
        Graphics.drawScreen{color = Color.black, priority = 10}
    end
end

local lastPauseKey = false;

function pausemenu13.onInputUpdate()
    if(player.keys.pause and not lastPauseKey) then
        if pausemenu13.paused then
            pausemenu13.paused = false
            pausemenu13.paused_char = false
            pauseactive = false
            SFX.play(30)
            cooldown = 5
            Misc.unpause()
            player:mem(0x11E,FIELD_BOOL,false)
        elseif(player:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and pausemenu13.pauseactivated == true) then
            --Misc.pause();
            pausemenu13.paused = true
            pauseactive = true
            pause_index = 0;
            SFX.play(30)
        elseif player.count(2) then
            if pausemenu13.paused then
                pausemenu13.paused = false
                pausemenu13.paused_char = false
                aused_tele = false
                pauseactive = false
                SFX.play(30)
                cooldown = 5
                Misc.unpause()
                player2:mem(0x11E,FIELD_BOOL,false)
            end
        elseif player.count(2) then
            if(player2:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and pausemenu.pauseactivated == true) then
                --Misc.pause();
                pausemenu13.paused = true
                pauseactive = true
                pause_index = 0;
                SFX.play(30)
            end
        end
        if cooldown <= 0 then
            player:mem(0x11E,FIELD_BOOL,true)
        end
        if pause_index_char == 0 then
            pause_index_char = pause_index_char + 1
        end
    end
    lastPauseKey = player.keys.pause;
    
    if(pausemenu13.paused and pause_options) then
        if(player.keys.down == KEYS_PRESSED) then
            repeat
                pause_index = (pause_index+1)%#pause_options;
            until(not pause_options[pause_index+1].inactive);
            SFX.play(26)
        elseif(player.keys.up == KEYS_PRESSED) then
            repeat
                pause_index = (pause_index-1)%#pause_options;
            until(not pause_options[pause_index+1].inactive);
            SFX.play(26)
        elseif(player.keys.jump == KEYS_PRESSED) then
            player:mem(0x11E,FIELD_BOOL,false)
            for i=1, 3 do
                for k,v in ipairs(pause_options[i]) do
                    if v then
                        v.activeLerp = 0
                    end
                end
            end
            pause_options[pause_index+1].action();
            Misc.unpause();
        end
        if Player.count() >= 2 then
            if(Player(2).keys.down == KEYS_PRESSED) then
                repeat
                    pause_index = (pause_index+1)%#pause_options;
                until(not pause_options[pause_index+1].inactive);
                SFX.play(26)
            elseif(Player(2).keys.up == KEYS_PRESSED) then
                repeat
                    pause_index = (pause_index-1)%#pause_options;
                until(not pause_options[pause_index+1].inactive);
                SFX.play(26)
            elseif(Player(2).keys.jump == KEYS_PRESSED) then
                pause_options[pause_index+1].action();
                Misc.unpause();
            end
        end
    end
    if(pausemenu13.paused_char and pause_options_char) then
        if(player.keys.down == KEYS_PRESSED) then
            repeat
                pause_index_char = (pause_index_char+1)%#pause_options_char;
            until(not pause_options_char[pause_index_char+1].inactive);
            SFX.play(26)
        elseif(player.keys.up == KEYS_PRESSED) then
            repeat
                pause_index_char = (pause_index_char-1)%#pause_options_char;
            until(not pause_options_char[pause_index_char+1].inactive);
            SFX.play(26)
        elseif(player.keys.jump == KEYS_PRESSED) then
            pause_options_char[pause_index_char+1].action();
            Misc.unpause();
        end
        if Player.count() >= 2 then
            if(player2.keys.down == KEYS_PRESSED) then
                repeat
                    pause_index_char = (pause_index_char+1)%#pause_options_char;
                until(not pause_options_char[pause_index_char+1].inactive);
                SFX.play(26)
            elseif(player2.keys.up == KEYS_PRESSED) then
                repeat
                    pause_index_char = (pause_index_char-1)%#pause_options_char;
                until(not pause_options_char[pause_index_char+1].inactive);
                SFX.play(26)
            elseif(player2.keys.jump == KEYS_PRESSED) then
                pause_options_char[pause_index_char+1].action();
                Misc.unpause();
            end
        end
    end
end

function pausemenu13.onTick()
    if(pausemenu13.paused) then
        Misc.pause();
    end
    if(pausemenu13.paused_char) then
        if pause_index_char == 0 then
            pause_index_char = 1
        end
        if pause_options_char == 0 then
            pause_options_char = 1
        end
    end
    if pausemenu13.pauseactivated == true then
        if player.pauseKeyPressing == false then
            player.pauseKeyPressing = true
        end
        if Player.count() >= 2 then
            if Player(2).pauseKeyPressing == false then
                Player(2).pauseKeyPressing = true
            end
        end
    end
    if pausemenu13.pauseactivated == false then
        if player.pauseKeyPressing == true then
            player.pauseKeyPressing = false
        end
        if Player.count() >= 2 then
            if Player(2).pauseKeyPressing == true then
                Player(2).pauseKeyPressing = false
            end
        end
    end
end

return pausemenu13