local textplus = require("textplus")
local playerManager = require("playerManager")

local active = false
local ready = false

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

local costumes = {}

local flag = true
local str = "Loading HUB..."

local thecostumemap = {}

local oldCostume = {}
local costumes = {}
local idMap = {}

local soundObject

local timerswitch = 0.1

local tbl = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16
}

local characterID = 1

--local levelfolder = Level.folderPath()
--local levelname = Level.filename()
--local levelformat = Level.format()

function thecostumemap.onInitAPI()
    registerEvent(thecostumemap, "onKeyboardPress")
    registerEvent(thecostumemap, "onDraw")
    registerEvent(thecostumemap, "onLevelExit")
    registerEvent(thecostumemap, "onTick")
    registerEvent(thecostumemap, "onTickEnd")
    registerEvent(thecostumemap, "onEvent")
    
    ready = true
end

function thecostumemap.onStart()
    if not ready then return end
    
    activeText = {}
    doyouwantogo = textplus.layout(textplus.parse("<color red>Do you want to go to the HUB (Me and Larry City)?</color>"))
    pressforthis = textplus.layout(textplus.parse("<color yellow>Press Y to do so, press F8 again to not.</color>"))
    useiffailsafe = textplus.layout(textplus.parse("(Use this if you are stuck on a level, or for faster travel convenience)"))
    
end

function thecostumemap.onKeyboardPress(k, v, fromUpper, playerOrNil)
    if k == VK_F6 then
        player.pauseKeyPressing = false
        active = not active
    end
    if active then
        if k == VK_F6 then
        SFX.play("charcost_open.wav")
        onePressedState = false
        twoPressedState = false
        threePressedState = false
        fourPressedState = false
        end
    end
    if active then
        onePressedState = false
        if k == VK_1 then
            local character = player.character;
            if (character == CHARACTER_MARIO) then
                player:transform(2)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_LUIGI) then
                player:transform(3)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_PEACH) then
                player:transform(4)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_TOAD) then
                player:transform(5)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_LINK) then
                player:transform(6)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_MEGAMAN) then
                player:transform(7)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_WARIO) then
                player:transform(8)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_BOWSER) then
                player:transform(9)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_KLONOA) then
                player:transform(10)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_NINJABOMBERMAN) then
                player:transform(11)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_ROSALINA) then
                player:transform(13)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_ZELDA) then
                player:transform(14)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_ULTIMATERINKA) then
                player:transform(15)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_UNCLEBROADSWORD) then
                player:transform(16)
                SFX.play("charcost_mapselect.wav")
            end
            if (character == CHARACTER_SAMUS) then
                player:transform(1)
                SFX.play("charcost_mapselect.wav")
            end
            twoPressedState = true
        end
    end
    if not active then
        if k == VK_F6 then
            SFX.play("charcost-close.wav")
        end
    end
end

function thecostumemap.onTick(k)
    if active then
    onePressedState = false
        if k == VK_1 then
            if Misc.isPaused(true) then
                player.rawKeys.left = KEYS_PRESSED
                else if Misc.isPaused(false) then
                    Misc.unpause()
                end
            end
        end
    end
    if active then
        twoPressedState = false
        if k == VK_2 then
            if Misc.isPaused(true) then
                player.rawKeys.right = KEYS_PRESSED
                else if Misc.isPaused(false) then
                    Misc.unpause()
                end
            end
        end
    end
end

function thecostumemap.onDraw(k)
    if active then
        player.pauseKeyPressing = false
        Graphics.drawBox{x=230, y=230, width=370, height=120, color=Color.canary..0.6, priority=10}

        textplus.print{x=240, y=250, text = "MAP CHARACTER OPTIONS (Command Mode, things WILL still run so be careful!)", priority=10, color=Color.maroon}
        textplus.print{x=240, y=265, text = "Press F6 to exit this menu.", priority=10, color=Color.brown}
        textplus.print{x=240, y=280, text = "Press 1 to change your character.", priority=10, color=Color.brown}
        textplus.print{x=240, y=310, text = "To change costumes, first start a level, then press F6 again.", priority=10, color=Color.brown}
    end
end

return thecostumemap