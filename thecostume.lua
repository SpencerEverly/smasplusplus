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

f1PressedState = false
f5PressedState = false

local costumes = {}

local flag = true
local str = "Loading HUB..."

local thecostume = {}

local oldCostume = {}
local costumes = {}
local idMap = {}

local soundObject

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

function thecostume.onInitAPI()
    registerEvent(thecostume, "onKeyboardPress")
    registerEvent(thecostume, "onDraw")
    registerEvent(thecostume, "onLevelExit")
    registerEvent(thecostume, "onTick")
    registerEvent(thecostume, "onEvent")
    
    ready = true
end

function thecostume.onStart()
    if not ready then return end
    
    activeText = {}
    doyouwantogo = textplus.layout(textplus.parse("<color red>Do you want to go to the HUB (Me and Larry City)?</color>"))
    pressforthis = textplus.layout(textplus.parse("<color yellow>Press Y to do so, press F8 again to not.</color>"))
    useiffailsafe = textplus.layout(textplus.parse("(Use this if you are stuck on a level, or for faster travel convenience)"))
    
end

function thecostume.onKeyboardPress(k, v, fromUpper, playerOrNil)
    if k == VK_F6 then
        player.pauseKeyPressing = false
        f1PressedState = true
        f5PressedState = true
        active = not active
    end
    if active then
        if k == VK_F6 then
        Sound.playSFX("charcost_open.ogg")
        onePressedState = false
        twoPressedState = false
        threePressedState = false
        fourPressedState = false
        end
    end
    if active then
        onePressedState = false
        if k == VK_1 then
            Sound.playSFX("charcost_costume.ogg")
            Sound.playSFX("charcost-selected.ogg")
            local costumes = playerManager.getCostumes(player.character)
            local currentCostume = player:getCostume()

            local costumeIdx = table.ifind(costumes,currentCostume)

            if costumeIdx ~= nil then
                player:setCostume(costumes[costumeIdx + 1])
            else
                player:setCostume(costumes[1])
                onePressedState = true
            end
        end
    end
    if active then
        twoPressedState = false
        if k == VK_2 then
            local character = player.character;
            if (character == CHARACTER_MARIO) then
                player:transform(2, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_LUIGI) then
                player:transform(3, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_PEACH) then
                player:transform(4, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_TOAD) then
                player:transform(5, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_LINK) then
                player:transform(6, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_MEGAMAN) then
                player:transform(7, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_WARIO) then
                player:transform(8, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_BOWSER) then
                player:transform(9, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_KLONOA) then
                player:transform(11, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_ROSALINA) then
                player:transform(13, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_ZELDA) then
                player:transform(15, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_UNCLEBROADSWORD) then
                player:transform(1, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_STEVE) then
                player:transform(1, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_NINJABOMBERMAN) then
                player:transform(1, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            if (character == CHARACTER_SAMUS) then
                player:transform(1, true)
                SFX.play(32)
                Sound.playSFX("charcost-selected.ogg")
            end
            twoPressedState = true
        end
    end
    if not active then
        if k == VK_F6 then
            Sound.playSFX("charcost-close.ogg")
            f1PressedState = false
            f5PressedState = false
        end
    end
end

function thecostume.onDraw(k)
    if active then
        player.pauseKeyPressing = false
        Graphics.drawBox{x=195, y=230, width=370, height=195, color=Color.canary..0.6, priority=10}

        textplus.print{x=207, y=257, text = "CHARACTER/COSTUME OPTIONS (Command Mode, things WILL still run so be careful!)", priority=10, color=Color.maroon}
        textplus.print{x=207, y=272, text = "Press F6 to exit this menu.", priority=10, color=Color.brown}
        textplus.print{x=207, y=287, text = "Press 1 to change your costume.", priority=10, color=Color.brown}
        textplus.print{x=207, y=302, text = "Press 2 to change your character.", priority=10, color=Color.brown}
        textplus.print{x=207, y=332, text = "Due to compatibility reasons, Samus/Steve/Ninja Bomberman won't be on this list.", priority=10, color=Color.brown}
        textplus.print{x=207, y=347, text = "Use the character/costume changer in the HUB or the map", priority=10, color=Color.brown}
        textplus.print{x=207, y=362, text = "to switch to Samus/Steve/Ninja Bomberman.", priority=10, color=Color.brown}
        textplus.print{x=207, y=377, text = "If you want to switch characters as Samus, please go to the character/costume", priority=10, color=Color.brown}
        textplus.print{x=207, y=392, text = "changer in the HUB to switch (This is an issue with the engine)", priority=10, color=Color.brown}
    end
end

return thecostume