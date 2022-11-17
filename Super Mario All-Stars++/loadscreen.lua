local letterWidths = {
    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},
    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},

    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},
}

--[[do
    local function exists(path)
        local f = io.open(path,"r")

        if f ~= nil then
            f:close()
            return true
        else
            return false
        end
    end

    Misc.resolveFile = (function(path)
        local inScriptPath = getSMBXPath().. "\\scripts\\".. path
        local inEpisodePath = _episodePath.. path

        return (exists(path) and path) or (exists(inEpisodePath) and inEpisodePath) or (exists(inScriptPath) and inScriptPath) or nil
    end)

    -- Make require work better
    local oldRequire = require

    function require(path)
        local inScriptPath = getSMBXPath().. "\\scripts\\".. path.. ".lua"
        local inScriptBasePath = getSMBXPath().. "\\scripts\\base\\".. path.. ".lua"
        local inEpisodePath = _episodePath.. path.. ".lua"

        local path = (exists(inEpisodePath) and inEpisodePath) or (exists(inScriptPath) and inScriptPath) or (exists(inScriptBasePath) and inScriptBasePath)
        assert(path ~= nil,"module '".. path.. "' not found.")

        return oldRequire(path)
    end

    -- lunatime
    _G.lunatime = require("engine/lunatime")

    -- Color
    _G.Color = require("engine/color")
    
    -- Textplus
    _G.textplus = require("textplus")
end]]

package.path = package.path .. ";./scripts/?.lua"
-- Address of the first player's character. Equivalent to 'player.character', except the player class doesn't exist in loading screens
local FIRST_PLAYER_CHARACTER_ADDR = mem(0x00B25A20,FIELD_DWORD) + 0x184 + 0xF0
local episodePath = mem(0x00B2C61C, FIELD_STRING)
local rng = require("base/rng")
Misc.setLoadScreenTimeout(3)

local image = Graphics.loadImage("loadscreen.png")
local blackscreen = Graphics.loadImage("black-screen.png")
local loadicon = Graphics.loadImage("loadscreen-logo.png")
local datetimeunavailable = Graphics.loadImage("datetimenotavailable.png")
local nesborder = Graphics.loadImage("graphics/resolutionborders/nes.png")
local gbborder = Graphics.loadImage("graphics/resolutionborders/gb.png")
local gbaborder = Graphics.loadImage("graphics/resolutionborders/gba.png")
local iphoneoneborder = Graphics.loadImage("graphics/resolutionborders/iphone1st.png")
local threedsborder = Graphics.loadImage("graphics/resolutionborders/3ds.png")
local mariochallengemodeimg = Graphics.loadImage("graphics/mariochallenge/loadimage.png")

local frame = 0
local frame2 = 0
local timer = 0
local speed = 0

local loadinfo = "fullscreen"

local didyouknow = {"didyouknow1.png", "didyouknow2.png", "didyouknow3.png", "didyouknow4.png", "didyouknow5.png", "didyouknow6.png", "didyouknow7.png", "didyouknow8.png", "didyouknow9.png", "didyouknow10.png", "didyouknow11.png", "didyouknow12.png", "didyouknow13.png", "didyouknow14.png", "didyouknow15.png", "didyouknow16.png", "didyouknow17.png", "didyouknow18.png", "didyouknow19.png", "didyouknow20.png", "didyouknow21.png", "didyouknow22.png", "didyouknow23.png", "didyouknow24.png", "didyouknow25.png", "didyouknow26.png", "didyouknow27.png", "didyouknow28.png", "didyouknow29.png", "didyouknow30.png", "didyouknow31.png", "didyouknow32.png", "didyouknow33.png", "didyouknow34.png", "didyouknow35.png"}

local selecter = rng.randomInt(1,#didyouknow)
local knowledge = Graphics.loadImage(episodePath.."graphics/didyouknow/"..didyouknow[selecter]);

local function loadtextfile()
    local file = io.open(episodePath .. "loadscreeninfo.txt", "r")
    loadinfo = file:read("*line")
    file:close()
end

loadtextfile()

local letterData = {}

local time = 0

--loadingsoundFile = Misc.resolveSoundFile("_OST/All Stars Menu/Loading Screen.ogg")

--function onLoad()
    --loadingsoundchunk = Audio.SfxOpen(loadingsoundFile)
    --loadingSoundObject = Audio.SfxPlayObj(loadingsoundchunk, -1)
    --fadetolevel = true
--end

function onDraw()
    if image == nil then -- this sometimes happens?
        return
    end

    local message = mem(FIRST_PLAYER_CHARACTER_ADDR,FIELD_WORD)
    local widths = letterWidths[message]

    if widths == nil then
        message = #letterWidths
        widths = letterWidths[message]
    end
    
    local opacity = math.min(1,time/42)

    local height = (image.height/#letterWidths)
    local sourceY = (message-1) * height

    local baseX = (400 - image.width*0.5)
    local baseY = (300 - height*0.5 - 32)
    local xOffset = 0

    local count = #widths
    
    speed = speed - 1
    
    if loadinfo == "fullscreen" then
        Graphics.drawImage(loadicon, 672, 535, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(knowledge, 0, 0, 1, 0, 800, 600, opacity)
        Graphics.drawImage(datetimeunavailable, 0, 0, 1, 0, 800, 600, opacity)
    end
    if loadinfo == "widescreen" then
        Graphics.drawImage(loadicon, 672, 465, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(knowledge, 0, -70, 1, 0, 800, 600, opacity)
        Graphics.drawImage(datetimeunavailable, 0, -70, 1, 0, 800, 600, opacity)
    end
    if loadinfo == "ultrawide" then
        Graphics.drawImage(loadicon, 672, 395, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(knowledge, 0, -140, 1, 0, 800, 600, opacity)
        Graphics.drawImage(datetimeunavailable, 0, -140, 1, 0, 800, 600, opacity)
    end
    if loadinfo == "steamdeck" then
        Graphics.drawImage(loadicon, 672, 505, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(knowledge, 0, -35, 1, 0, 800, 600, opacity)
        Graphics.drawImage(datetimeunavailable, 0, 35, 1, 0, 800, 600, opacity)
    end
    if loadinfo == "nes" then
        Graphics.drawImageWP(nesborder, 0, 0, 1, 0, 800, 600, opacity, 2)
        Graphics.drawImage(loadicon, 572, 455, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(knowledge, 80, -80, 1, 0, 800, 600, opacity)
        Graphics.drawImage(datetimeunavailable, -100, 85, 1, 0, 800, 600, opacity)
    end
    if loadinfo == "gameboy" then
        Graphics.drawImageWP(gbborder, 0, 0, 1, 0, 800, 600, opacity, 2)
        Graphics.drawImage(loadicon, 442, 382, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(datetimeunavailable, -230, 140, 1, 0, 800, 600, opacity)
    end
    if loadinfo == "gba" then
        Graphics.drawImageWP(gbaborder, 0, 0, 1, 0, 800, 600, opacity, 2)
        Graphics.drawImage(loadicon, 522, 410, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(datetimeunavailable, -150, 135, 1, 0, 800, 600, opacity)
    end
    if loadinfo == "iphone1st" then
        Graphics.drawImageWP(iphoneoneborder, 0, 0, 1, 0, 800, 600, opacity, 2)
        Graphics.drawImage(loadicon, 402, 425, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(datetimeunavailable, -270, 112, 1, 0, 800, 600, opacity)
    end
    if loadinfo == "3ds" then
        Graphics.drawImageWP(threedsborder, 0, 0, 1, 0, 800, 600, opacity, 2)
        Graphics.drawImage(loadicon, 555, 485, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(datetimeunavailable, -110, 190, 1, 0, 800, 600, opacity)
    end
    if loadinfo == "mariochallenge" then
        Graphics.drawImageWP(mariochallengemodeimg, 0, 0, 1, 0, 800, 600, opacity, 2)
        Graphics.drawImage(loadicon, 672, 535, 1, frame2 * 64, 128, 64, opacity)
        Graphics.drawImage(knowledge, 0, 0, 1, 0, 800, 600, opacity)
    end
    
    
    frame = math.floor(timer/speed)%7
    timer = timer + 1    
    frame2 = math.floor(timer/8)%7
    
    for index,width in ipairs(widths) do
        letterData[index] = letterData[index] or {offset = 0,speed = 0}
        local data = letterData[index]

        if (time/8)%(count+8) == index-1 then
            data.speed = -3.5
        end

        data.speed = data.speed + 0.26
        data.offset = math.min(0,data.offset + data.speed)
        
        Graphics.drawImage(image,baseX+xOffset,baseY+data.offset,xOffset,sourceY,width,height,opacity)
        xOffset = xOffset + width
    end
    
    local opacityend = math.min(1,time/42)
    if Misc.setLoadScreenTimeout(1) then
        Graphics.drawImage(blackscreen, 0, 0, 1, 0, 800, 600, opacityend)
    end

    time = time + 1
end