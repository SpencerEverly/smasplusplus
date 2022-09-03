--smasverbosemode.lua
--By Spencer Everly

local textplus = require("textplus")
local lazyprint = require("lazyprint")
local inspect = require("ext/inspect")

local smasverbosemode = {}

local gtltrepllace = {["<"] = "<lt>", [">"] = "<gt>", ["\n"] = "<br>"}
local verbosefont = textplus.loadFont("littleDialogue/font/6.ini")

local doprint = {font=textplus.loadFont("littleDialogue/font/6.ini"), color=Color.white, plaintext=true}
    
doprint.xscale = 1
doprint.yscale = 1

smasverbosemode.activated = false
GameData.verboseLog = {}
smasverbosemode.verboseLog = GameData.verboseLog

local function _print(str, x, y)
    local textLayout = textplus.layout(str, nil, doprint)
    y = y - textLayout.height
    textplus.render{x = x, y = y, layout = textLayout, priority = 0}
end

local printlist = {}
local listidx = 1
local baseX, baseY = 10, 590

local function addprint(v)
    printlist[listidx] = v
    listidx = listidx + 1
end

local function _storeVerboseString(stringvalue)
    if stringvalue == nil then
        stringvalue = ""
    end
    if stringvalue:find("\n") then
        for k,v in ipairs(stringvalue:split("\n")) do
            table.insert(smasverbosemode.verboseLog, v)
        end
    elseif stringvalue then
        table.insert(smasverbosemode.verboseLog, stringvalue)
    end
    local y = baseY
    for i = #smasverbosemode.verboseLog, 1, -1 do
        y = y + 10
        addprint("\n")
        if y < 0 then
            break
        end
        addprint(smasverbosemode.verboseLog[i])
    end
end

local function _printVerboseList()
    _print(table.concat(printlist), baseX, baseY)
end

function smasverbosemode.onInitAPI()
    registerEvent(smasverbosemode,"onStart")
    registerEvent(smasverbosemode,"onEvent")
    registerEvent(smasverbosemode,"onDraw")
end

function smasverbosemode.onStart()
    if smasverbosemode.activated then
        --Routine.run(startLevel)
    end
    lazyprint.monitor(player, {"x", "y", "powerup", "width", "height", "character"})
    lazyprint.monitor(player, {"mount", "mountColor", "mountType", "forcedState", "forcedTimer"})
    lazyprint.monitor(Playur, {"isJumping(player)", "underwater(player)", "grabbing(player)", "ducking(player)", "getBattleLives(1)"})
    lazyprint.monitor(camera, {"x", "y", "width", "height"})
    for i = 0,20 do
        lazyprint.monitor(Section(i), {"music", "underwater", "noTurnBack"})
    end
end

function smasverbosemode.onEvent(eventName)
    if smasverbosemode.activated then
        if eventName then
            --_storeVerboseString("Event "..eventName.." has executed.")
        end
    end
end

function startLevel()
    Routine.wait(0.1, true)
    --_storeVerboseString("Level has officially started.")
end

function smasverbosemode.onDraw()
    if smasverbosemode.activated then
        _printVerboseList()
        for _,p in ipairs(Player.get()) do
            if p:mem(0x11C, FIELD_WORD) == 1 then
                --_storeVerboseString("Player "..p.idx.." has jumped.")
            end
        end
    end
end

return smasverbosemode