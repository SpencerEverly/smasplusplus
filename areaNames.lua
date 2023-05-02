--        ______________
--       |AREANAMES.LUA|
--       --------------
-- by Enjl, V1.0
-- of note:
--   not multiplayer compatible

--ADD TO THIS to have names show up on section transitions
local areanames = {}

local textplus

local currentName = ""
local timer = 0

local font

areanames.sectionNames = {}

--CALL THIS to manually show names
function areanames.show(name)
    timer = 0
    currentName = name
end

function areanames.onLoadSection()
    if areanames.sectionNames[player.section] then
        areanames.show(areanames.sectionNames[player.section])
    end
end

--OVERWRITE THIS to implement custom drawing functions
function areanames.draw(name, t)
    if t < #name * 4 + 80 then
        if font == nil then
            textplus = require("textplus")
            font = textplus.loadFont("textplus/font/6.ini")
        end
        textplus.print{
            x = 20,
            y = 100,
            text = name,
            priority = -1,
            limit = math.floor(t / 4),
            font = font,
            xscale = 2,
            yscale = 2
        }
    end
end

function areanames.onDraw()
    areanames.draw(currentName, timer)
    timer = timer + 1
end

function areanames.onInitAPI()
    registerEvent(areanames, "onLoadSection")
    registerEvent(areanames, "onDraw")
end

return areanames