--smasverbosemode.lua
--By Spencer Everly

local textplus = require("textplus")
local lazyprintSMAS = require("lazyprintSMAS")
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
    registerEvent(smasverbosemode,"onInputUpdate")
end

function smasverbosemode.onStart()
    console:println("Level has officially started.")
    console:println("Level filename: "..Level.filename())
    console:println("Level name: "..Misc.getActualLevelName())
    if Playur.currentWarp(player) == 0 then
        console:println("Player 1 starting point (X/Y): "..tostring(Playur.startPointCoordinateX(1)).."/"..tostring(Playur.startPointCoordinateY(1)))
        if Player.count() >= 2 then
            console:println("Player 2 starting point (X/Y): "..tostring(Playur.startPointCoordinateX(2)).."/"..tostring(Playur.startPointCoordinateY(2)))
        end
    end
    --lazyprintSMAS.monitor(player, {"x", "y", "powerup", "width", "height", "character"})
    --lazyprintSMAS.monitor(player, {"mount", "mountColor", "mountType", "forcedState", "forcedTimer"})
    --lazyprintSMAS.monitor(camera, {"x", "y", "width", "height"})
    --for i = 0,20 do
        --lazyprintSMAS.monitor(Section(i), {"music", "underwater", "noTurnBack"})
    --end
end

function smasverbosemode.onEvent(eventName)
    if eventName then
        console:println("Event "..eventName.." has executed.")
    end
end

function startLevel()
    
end

function smasverbosemode.onDraw()
    for _,p in ipairs(Player.get()) do
        if Playur.isJumping(p) then
            console:println("Player "..p.idx.." has jumped.")
        end
        if p:mem(0x26, FIELD_WORD) == 1 then
            console:println("Player "..p.idx.." is grabbing something.")
        end
    end
end

function smasverbosemode.onInputUpdate()
    for _,p in ipairs(Player.get()) do
        if p.keys.left == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the left button.")
        end
        if p.keys.right == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the right button.")
        end
        if p.keys.up == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the up button.")
        end
        if p.keys.down == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the down button.")
        end
        if p.keys.jump == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the jump button.")
        end
        if p.keys.run == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the run button.")
        end
        if p.keys.altJump == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the alt-jump button.")
        end
        if p.keys.altRun == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the alt-run button.")
        end
        if p.keys.pause == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the pause button.")
        end
        if p.keys.dropItem == KEYS_PRESSED then
            console:println("Player "..p.idx.." has pressed the drop item button.")
        end
    end
end

return smasverbosemode