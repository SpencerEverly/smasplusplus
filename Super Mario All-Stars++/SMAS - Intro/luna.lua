Graphics.activateHud(false)

local textplus = require("textplus")
local datetime = require("datetime")

local timer1 = 0
local speed = 0
local numberup = 0
local time = 0
local time2 = 0
local time3 = 0

local opacity = timer1/speed
local middle = math.floor(timer1*numberup)

function onInitAPI()
    registerEvent("onExitLevel", "onExit");
    registerEvent("onKeyboardPress");
    registerEvent("onInputUpdate");
end

function onStart(p)
    datetime.topright = true
    datetime.bottomright = false
    p = p or player;
    smasbooleans.musicMuted = true
    Audio.MusicVolume(80)
end

function onTick()
    player.runKeyPressing = false;
    player.upKeyPressing = false;
    player.altJumpKeyPressing = false;
    player.altRunKeyPressing = false;
    player.dropItemKeyPressing = false;
    player.leftKeyPressing = false;
    --player.rightKeyPressing = false;
    
    --Prevent donthurtme cheat, for obvious reasons
    Defines.cheat_donthurtme = used_donthurtme;
    used_donthurtme = nil;
    Audio.sounds[1].sfx  = Audio.SfxOpen("SMAS - Intro/player-jump.ogg")
    if(not killed and player:mem(0x13E,FIELD_BOOL)) then
        killed = true;
        Level.load()
    end
    player:setFrame(50)
end

function onDraw()
    Graphics.draw{type = RTYPE_TEXT, x = 55, y = 580, priority = 0, text = "Press down to skip, jump for Game Help"}
    
    Graphics.drawBox{x=5, y=5, width=95, height=20, color=Color.red..0.5, priority=-1}
    textplus.print{x=10, y=10, text = "Press pause to quit.", priority=0, color=Color.yellow}
    
    if player.downKeyPressing then
        triggerEvent("Skip Intro")
    end
    if player.jumpKeyPressing then
        Graphics.draw{type = RTYPE_TEXT, x = 220, y = 20, priority = 0, text = "Loading Game Help..."}
        triggerEvent("jumping")
    end
    if fadeout1 then
        time = time + 1
        Graphics.drawScreen{color = Color.black..math.max(0,time/20),priority = 3}
    end
    if fadeout2 then
        time = time - 1
        Graphics.drawScreen{color = Color.black..math.min(1,time/20),priority = 3}
    end
    if fadeout3 then
        time3 = time3 + 1
        Graphics.drawScreen{color = Color.black..math.max(0,time3/20),priority = 3}
    end
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onEvent(eventName)
    if eventName == "Logo Stage 1 - Head Movement" then
        SFX.play("SMAS - Intro/sounds/head-spin.ogg")
        Sound.changeMusic("_OST/Intro.ogg", 0)
    end
    if eventName == "Logo Stage 2 - Bump" then
        SFX.play("SMAS - Intro/sounds/head-stop.ogg")
    end
    if eventName == "Logo Stage 5 - Words (Fade In 1)" then
        SFX.play("SMAS - Intro/sounds/se-words.ogg")
    end
    if eventName == "Logo Stage 8 - Divison Wordline" then
        SFX.play("SMAS - Intro/sounds/intro-byline.ogg")
    end
    if eventName == "Logo Stage 9 - Fade Out 1" then
        SFX.play("SMAS - Intro/sounds/intro-fadeout.ogg")
        fadeout1 = true
    end
    if eventName == "Logo Stage 14 - Opening Transition Complete" then
        fadeout1 = false
    end
    if eventName == "Opening Stage 1 - Fade In 1" then
        fadeout2 = true
    end
    if eventName == "Opening Stage 5 - Lights On" then
        SFX.play("SMAS - Intro/sounds/coin.ogg")
    end
    if eventName == "Opening Stage 7 - Fade Out 1" then
        SFX.play("SMAS - Intro/sounds/opening-end.ogg")
        fadeout3 = true
    end
    if eventName == "Opening Stage 10 - End of Intro" then
        Audio.MusicVolume(65)
    end
    if eventName == "Skip Intro" then
        player.downKeyPressing = false
    end
    if eventName == "WorldMapWarp" then
        Level.load("map.lvlx")
    end
    if eventName == "Skip Intro Execution" then
        Level.load("map.lvlx")
    end
end

function onInputUpdate()
    if player.rawKeys.pause == KEYS_PRESSED then
        Misc.exitEngine()
    end
end

--The rest will disable most cheats to avoid breaking the intro. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

Cheats.enabled = false

function onExit()
    smasbooleans.musicMuted = false
    Audio.MusicVolume(65)
    datetime.topright = false
    datetime.bottomright = true
end