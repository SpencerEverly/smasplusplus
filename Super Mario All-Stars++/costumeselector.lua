local textplus = require("textplus")
local imagic = require("imagic")
local rng = require("rng")
local playerManager = require("playerManager")
local Routine = require("routine")

local costumes = playerManager.getCostumes(player.character)
local currentCostume = player:getCostume()
local costumeIdx = table.ifind(costumes,currentCostume)

local blackscreen = Graphics.loadImage("blackscreen.png")

costumechangerOST =  = Misc.resolveSoundFile("_OST/All Stars Menu/Character Changer Menu.ogg")

local active = true
local active2 = false
local ready = false
local exitscreen = false

local pausefont = textplus.loadFont("littleDialogue/font/sonicMania-bigFont.ini")
local pausefont2 = textplus.loadFont("littleDialogue/font/smb1-a.ini")
local pausefont3 = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")

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

local costumeselector = {}

costumeselector.activated = false

local soundObject

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()
local costumes = playerManager.getCostumes(player.character)

local paused = false
local pause_box;
local pause_height = 0;
local pause_width = 700;

local pause_options;
local pause_options_char;
local pause_options_tele;
local character_options;
local pause_index = 0
local pause_index_char = 0
local pause_index_tele = 0

local pauseactive = false
local charactive = false
local teleactive = false

local level = Level.filename()

function costumeselector.onInitAPI()
    registerEvent(costumeselector, "onKeyboardPress")
    registerEvent(costumeselector, "onDraw")
    registerEvent(costumeselector, "onLevelExit")
    registerEvent(costumeselector, "onTick")
    registerEvent(costumeselector, "onInputUpdate")
    registerEvent(costumeselector, "onStart")
    
    local Routine = require("routine")
    
    ready = true
end

local function nothing()
    --Nothing happens here
end

local function closechanger()
    costumeselector.activated = false
    Misc.unpause()
    Sound.playSFX("costumeselector-closed.ogg")
end

function costumeselector.onStart()
    if not ready then return end
end

local function characterchange()
    local character = player.character;
    if (character == CHARACTER_MARIO) then
        player:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player:transform(6, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_MEGAMAN) then
        player:transform(7, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_WARIO) then
        player:transform(8, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_BOWSER) then
        player:transform(9, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_KLONOA) then
        player:transform(10, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_NINJABOMBERMAN) then
        player:transform(11, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ROSALINA) then
        player:transform(12, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_SNAKE) then
        player:transform(13, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ZELDA) then
        player:transform(14, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ULTIMATERINKA) then
        player:transform(15, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_UNCLEBROADSWORD) then
        player:transform(16, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_SAMUS) then
        player:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchange13()
    local character = player.character;
    if (character == CHARACTER_MARIO) then
        player:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchange13_2p()
    local character = player2.character;
    if (character == CHARACTER_MARIO) then
        player2:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player2:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player2:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player2:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player2:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchangeleft()
    local character = player.character;
    if (character == CHARACTER_MARIO) then
        player:transform(16, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_MEGAMAN) then
        player:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_WARIO) then
        player:transform(6, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_BOWSER) then
        player:transform(7, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_KLONOA) then
        player:transform(8, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_NINJABOMBERMAN) then
        player:transform(9, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ROSALINA) then
        player:transform(10, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_SNAKE) then
        player:transform(11, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ZELDA) then
        player:transform(12, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_ULTIMATERINKA) then
        player:transform(13, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_UNCLEBROADSWORD) then
        player:transform(14, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_SAMUS) then
        player:transform(15, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchange13left()
    local character = player.character;
    if (character == CHARACTER_MARIO) then
        player:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function characterchange13_2pleft()
    local character = player2.character;
    if (character == CHARACTER_MARIO) then
        player2:transform(5, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LUIGI) then
        player2:transform(1, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_PEACH) then
        player2:transform(2, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_TOAD) then
        player2:transform(3, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
    if (character == CHARACTER_LINK) then
        player2:transform(4, false)
        SFX.play(32)
        Sound.playSFX("charcost-selected.ogg")
        Sound.playSFX("racoon-changechar.ogg")
    end
end

local function costumechangeright()
    if costumeIdx ~= nil then
        player:setCostume(costumes[costumeIdx + 1])
    else
        player:setCostume(costumes[1])
    end
    Sound.playSFX("charcost_costume.ogg")
    Sound.playSFX("charcost-selected.ogg")
end

local function wrong()
    Sound.playSFX("wrong.ogg")
end

local function drawCostumeSelector(y, alpha)
    local name = "<color yellow>SELECT CHARACTER</color>"
    --local font = textblox.FONT_SPRITEDEFAULT3X2;
    
    local layout = textplus.layout(textplus.parse(name, {xscale=1.5, yscale=1.5, align="center", color=Color.canary..1.0, font=pausefont}), pause_width)
    local w,h = layout.width, layout.height
    textplus.render{layout = layout, x = 400 - w*0.5, y = y+8, color = Color.white..alpha, priority = 5}
    --local _,h = textblox.printExt(name, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP, z=10, color = 0xFFFFFF00+alpha*255})
    
    h = h+16+8--font.charHeight;
    y = y+h;
    
    
    if(pause_options == nil) then
        pause_options = 
        {
            {name="Go Back", action=unpause}
        }
        table.insert(pause_options, {name="Restart", action = restartlevel});
        if Level.filename() == "SMAS - Map.lvlx" then
            table.insert(pause_options, {name="Return to the Main Map", action = exitlevel});
        end
        if (Level.name() == "SMAS - DLC World") == false then
            table.insert(pause_options, {name="Go to the DLC Map", action = dlcmapload});
        end
        if (Level.name() == "MALC - HUB") == false then
            table.insert(pause_options, {name="Teleport to the HUB", action = hubteleport});
        end
        if SaveData.disableX2char == true then
            table.insert(pause_options, {name="Turn OFF SMBX 1.3 Mode", action = x2modeenable});
        end
        if SaveData.disableX2char == false then
            table.insert(pause_options, {name="Turn ON SMBX 1.3 Mode", action = x2modedisable});
        end
        if Level.filename() == "MALC - HUB.lvlx" then
            table.insert(pause_options, {name="Teleporting Options", action = switchtotele});
        end
        table.insert(pause_options, {name="Character Options", action = switchtochar});
        table.insert(pause_options, {name="Save and Exit to Map", action = exitlevelsave});
        table.insert(pause_options, {name="Save and Continue", action = savegame});
        table.insert(pause_options, {name="Save and Reset Game", action = mainmenu});
        table.insert(pause_options, {name="Save and Quit", action = quitgame});
        table.insert(pause_options, {name="Exit without Saving", action = quitonly});
    end
    for k,v in ipairs(pause_options) do
        local c = 0xFFFFFF00;
        local n = v.name;
        if(v.inactive) then
            c = 0x99999900;
        end
        if(k == pause_index+1) then
            n = "<color rainbow><wave 1>"..n.."</wave></color>";
        end
            
        local layout = textplus.layout(textplus.parse(n, {xscale=1.5, yscale=1.5, font=pausefont3}), pause_width)
        local h2 = layout.height
        textplus.render{layout = layout, x = 400 - layout.width*0.5, y = y+8, color = Color.fromHex(c+alpha*255), priority = 8}
        --local _,h2 = textblox.printExt(n, {x = 400, y = y, width=pause_width, font = font, halign = textblox.HALIGN_MID, valign = textblox.VALIGN_TOP,z=10, color = c+alpha*255})
        h2 = h2+2+6--font.charHeight;
        y = y+h2;
        h = h+h2;
    end

    
    return h;
end

function costumeselector.onDraw(isSplit)
    if paused then
        Misc.pause()
        if(pause_box == nil) then
            pause_height = drawcostumeselector(-600,0);
            pause_box = imagic.Create{x=400,y=300,width=500,height=pause_height+16,primitive=imagic.TYPE_BOX,align=imagic.ALIGN_CENTRE}
        end
        pause_box:Draw(5, 0x00000077);
        drawcostumeselector(300-pause_height*0.5,1)
        
        --Fix for anything calling Misc.unpause
        Misc.pause();
    end
    if not paused then
        pause_box = nil
    end
    if exitscreen then
        Graphics.drawScreen{color = Color.black, priority = 10}
    end
end

local lastPauseKey = false;

function costumeselector.onInputUpdate()
    if costumeselector.activated == true then
        if(player:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and costumeselector.activated == true) then
            Audio.MusicVolume(0)
            costumeOSTchunk = Audio.SfxOpen(costumechangerOST)
            costumeOSTObject = Audio.SfxPlayObj(costumechangerOST, -1)
            --Misc.pause();
            paused = true
            pauseactive = true
            pause_index = 0;
            Sound.playSFX("charcost_open.ogg")
        elseif costumeselector.activated == false then
            Audio.MusicVolume(nil)
            costumeOSTObject:FadeOut(300)
            paused = false
            pauseactive = false
            Sound.playSFX("charcost-close.ogg")
            cooldown = 5
            Misc.unpause()
            player:mem(0x11E,FIELD_BOOL,false)
        elseif player.count(2) then
            if costumeselector.activated == true
                paused = false
                pauseactive = false
                Sound.playSFX("charcost-close.ogg")
                cooldown = 5
                Misc.unpause()
                player2:mem(0x11E,FIELD_BOOL,false)
            end
        elseif player.count(2) then
            if(player2:mem(0x13E, FIELD_WORD) == 0 and not dying and (isOverworld or Level.winState() == 0) and not Misc.isPaused() and costumeselector.pauseactivated == true) then
                --Misc.pause();
                paused = true
                pauseactive = true
                pause_index = 0;
                Sound.playSFX("charcost_open.ogg")
            end
        end
        if cooldown <= 0 then
            player:mem(0x11E,FIELD_BOOL,true)
        end
    end
    
    if(costumeselector.activated == true and pause_options) then
        if(player.keys.down == KEYS_PRESSED) then
            repeat
                pause_index = (pause_index+1)%#pause_options;
            until(not pause_options[pause_index+1].inactive);
            Sound.playSFX("costumeselector_cursor.ogg")
        elseif(player.keys.up == KEYS_PRESSED) then
            repeat
                pause_index = (pause_index-1)%#pause_options;
            until(not pause_options[pause_index+1].inactive);
            Sound.playSFX("costumeselector_cursor.ogg")
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
            if(player2.keys.down == KEYS_PRESSED) then
                repeat
                    pause_index = (pause_index+1)%#pause_options;
                until(not pause_options[pause_index+1].inactive);
                Sound.playSFX("costumeselector_cursor.ogg")
            elseif(player2.keys.up == KEYS_PRESSED) then
                repeat
                    pause_index = (pause_index-1)%#pause_options;
                until(not pause_options[pause_index+1].inactive);
                Sound.playSFX("costumeselector_cursor.ogg")
            elseif(player2.keys.jump == KEYS_PRESSED) then
                pause_options[pause_index+1].action();
                Misc.unpause();
            end
        end
    end
end

function costumeselector.onTick()
    if costumeselector.activated == true then
        --Nothing
    end
end

return costumeselector