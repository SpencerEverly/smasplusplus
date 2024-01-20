local repll = {}

--Whether to enable sounds by default. Toggle it false on the actual console if it gets annoying to you.
repll.enableSounds = true

-- TODO: Handle unicode better. Textplus renders utf-8 fine, but repll for cursor management
--       purposes repll is not respecting multi-byte characters properly.

local inspect = require("ext/inspect")
local textplus = require("textplus")
local rng = require("base/rng")
local repl = require("game/repl")

local unpack = _G.unpack or table.unpack
local memo_mt = {__mode = "k"} --recommended by Rednaxela

local blinker = 0

-- Memoize a function with one argument.
local function memoize(func)
    local t = {}
    setmetatable(t, memo_mt)
    return function(x)
        if t[x] then
            return unpack(t[x])
        else
            local ret = {func(x)}
            t[x] = ret
            return unpack(ret)
        end
    end
end

-- Splits a string at a position.
local function split(str, idx)
    return str:sub(1, idx), str:sub(idx + 1)
end

------------
-- SYNTAX --
------------

local repll_env = {}
local repll_mt = {__index = Misc.getCustomEnvironment()}
setmetatable(repll_env, repll_mt)

local rawload = load
local function load(str)
    return rawload(str, str, "t", repll_env)
end
load = memoize(load)

-- Check whether a string is syntactically valid Lua.
local function isValid(str)
    return not not load(str)
end
isValid = memoize(isValid)

-- Check whether a string is a valid Lua expression.
local function isExpression(str)
    return isValid("return " .. str .. ";")
end
isExpression = memoize(isExpression)

-- Check whether a string is a valid Lua function call.
-- Anything that's both an expression and a chunk is a function call.
local function isFunctionCall(str)
    return isExpression(str) and isValid(str)
end
isFunctionCall = memoize(isFunctionCall)

-- Create a shallow copy of a list, missing the first entry.
local function trim(t)
    local ret = {}
    for k,v in ipairs(t) do
        if k ~= 1 then
            ret[k - 1] = v
        end
    end
    return ret
end

---------------------------
-- CONSOLE FUNCTIONALITY --
---------------------------


if GameData._repll == nil then
    GameData._repll = { history = {}, log = {} }
end

repll.log = GameData._repll.log
repll.history = GameData._repll.history
repll.buffer = ""
repll.historyPos = 0
repll.cursorPos = 0

local function printString(str)
    if str == nil then
        str = ""
    end
    if str:find("\n") then
        for k,v in ipairs(str:split("\n")) do
            table.insert(repll.log, v)
        end
    elseif str then
        table.insert(repll.log, str)
    end
end

local function printValues(vals)
    if next(vals, nil) == nil then
        return
    end
    local t = {}
    local multiline = false
    local maxIdx = 0
    for k,v in pairs(vals) do
        maxIdx = math.max(maxIdx, k)
        t[k] = inspect(v)
        if t[k]:find("\n") then
            multiline = true
        end
    end
    if multiline then
        for i = 1, maxIdx do
            printString(t[i] or "nil")
        end
    else
        local s = ""
        for i = 1, maxIdx do
            if s ~= "" then
                s = s .. " "
            end
            s = s .. (t[i] or "nil")
        end
        printString(s)
    end
end

_G.rawprint = print
function _G.print(...)
    printValues{...}
end

local function printError(err)
    printString("error: " .. err:gsub("%[?.*%]?:%d+: ", "", 1))
end

local function exec(block)
    local chunk = load(block)
    local x = {pcall(chunk)}
    local success = x[1]
    local vals = trim(x)
    if success then
        printValues(vals)
    else
        printError(vals[1])
    end
end

local function eval(expr)
    local chunk = load("return " .. expr .. ";")
    local x = {pcall(chunk)}
    local success = x[1]
    local vals = trim(x)
    if success then
        printValues(vals)
        if next(vals, nil) == nil and not isFunctionCall(expr) then
            printString("nil")
        end
    else
        printError(vals[1])
    end
end

local function cmd(str)
    if isExpression(str) then
        eval(str)
        if repll.enableSounds then
            Sound.playSFX("console/console_info.ogg")
        end
    elseif isValid(str) then
        exec(str)
        if repll.enableSounds then
            Sound.playSFX("console/console_success.ogg")
        end
    else
        printError(select(2, load(str)))
        if repll.enableSounds then
            Sound.playSFX("console/console_error.ogg")
        end
    end
end

function repll.cmd()
    local isIncomplete = false
    if not isExpression(repll.buffer) then
        local _, err = load(repll.buffer)
        if err then
            isIncomplete = err:match("expected near '<eof>'$") or err:match("'end' expected")
        end
    end
    if isIncomplete then
        repll.buffer = repll.buffer .. "\n"
        repll.cursorPos = #repll.buffer
        return
    end
    printString(">" .. repll.buffer:gsub("\n", "\n "))
    if repll.buffer ~= "" then
        table.insert(repll.history, repll.buffer)
        cmd(repll.buffer)
        repll.buffer = ""
        repll.historyPos = 0
        repll.cursorPos = 0
    end
end

-----------------------------
-- SMBX ENGINE INTEGRATION --
-----------------------------

local event_tbl = {}
function repll_mt.__newindex(t, k, v)
    if Misc.LUNALUA_EVENTS_TBL[k] then
        if type(v) == "function" and type(event_tbl[k]) ~= "function" then
            registerEvent(event_tbl, k)
        elseif type(event_tbl[k]) == "function" and type(v) ~= "function" then
            unregisterEvent(event_tbl, k)
        end
        event_tbl[k] = v
    else
        _G[k] = v
    end
end

repll.active = false
repll.activeInEpisode = false
repll.background = Color(0,0,0,0.5)
repll.backgroundImg = Graphics.loadImageResolved("graphics/colors/black-repl.png")

repll.cursorOffsetX = 0
repll.cursorOffsetY = 0
repll.textOffsetX = 0
repll.textOffsetY = 0

repll.maxLines = 18
repll.maxScreenLength = 3200

function repll.onInitAPI()
    registerEvent(repll, "onKeyboardPressDirect")
    registerEvent(repll, "onDraw")
    registerEvent(repll, "onPasteText")
    registerEvent(repll, "onInputUpdate")
    
    if SMBX_VERSION == VER_SEE_MOD then
        registerEvent(repll, "onMouseWheelEvent")
    end
end

function repll.onInputUpdate()
    if Misc.inEditor() then
        repl.activeInEpisode = false
        repl.active = false
    end
    if not repll.active then
        if player.keys.dropItem == KEYS_PRESSED then

        end
    end
    if repll.active then
        if player.keys.dropItem == KEYS_PRESSED then
            player.keys.dropItem = KEYS_UNPRESSED
        end
    end
    if GameData.toggleoffkeys == true then
        for k,v in pairs(player.keys) do
            player.keys[k] = false
        end
    end
    if GameData.toggleoffkeys == false or GameData.toggleoffkeys == nil then
        
    end
end

function repll.onKeyboardPressDirect(vk, repeated, char)
    if not (repll.activeInEpisode or Misc.inEditor()) then return end

    if not repll.active then
        if (vk == VK_TAB) and (not repeated) then
            repl.active = false
            Misc.pause()
            if repll.enableSounds then
                Sound.playSFX("console/console_open.ogg")
            end
            Misc.cheatBuffer("")
            repll.active = true
            smasBooleans.toggleOffInventory = true
        end
        return
    end
    
    local rngkey = rng.randomInt(1,7)
    if (not repeated) then
        if repll.enableSounds then
            Sound.playSFX("console/console_keypress"..rngkey..".ogg")
        end
    end
    
    if repll.active then
        repll.textOffsetY = 0
        repll.cursorOffsetY = 0
        if vk == VK_TAB or vk == VK_ESCAPE then
            if (not repeated) then
                Misc.unpause()
                if repll.enableSounds then
                    Sound.playSFX("console/console_close.ogg")
                end
                repll.active = false
                smasBooleans.toggleOffInventory = false
            end
        elseif vk == VK_RETURN then
            if repll.enableSounds then
                Sound.playSFX("console/console_keypressenter.ogg")
            end
            if Misc.GetKeyState(VK_SHIFT) then
                local left, right = split(repll.buffer, repll.cursorPos)
                repll.buffer = left .. "\n" .. right
                repll.cursorPos = repll.cursorPos + 1
                blinker = 1
            else
                repll.cmd()
            end
        elseif vk == VK_BACK then
            local left, right = split(repll.buffer, repll.cursorPos)
            repll.buffer = left:sub(1, -2) .. right
            repll.cursorPos = math.max(0, repll.cursorPos - 1)
            if repll.enableSounds then
                Sound.playSFX("console/console_keypressbackspace.ogg")
            end
            blinker = 1
        elseif vk == VK_DELETE then
            local left, right = split(repll.buffer, repll.cursorPos)
            repll.buffer = left .. right:sub(2)
            if repll.enableSounds then
                Sound.playSFX("console/console_keypress7.ogg")
            end
            blinker = 1
        elseif vk == VK_UP or vk == VK_DOWN then
            if vk == VK_UP then
                repll.historyPos = math.min(repll.historyPos + 1, #repll.history)
            elseif vk == VK_DOWN then
                repll.historyPos = math.max(0, repll.historyPos - 1)
            end
            if repll.historyPos == 0 then
                repll.buffer = ""
            else
                repll.buffer = repll.history[#repll.history - repll.historyPos + 1]
            end
            repll.cursorPos = #repll.buffer
            blinker = 1
        elseif vk == VK_LEFT then
            repll.cursorPos = math.max(0, repll.cursorPos - 1)
            blinker = 1
            if repll.enableSounds then
                Sound.playSFX("console/console_keypress"..rngkey..".ogg")
            end
        elseif vk == VK_RIGHT then
            repll.cursorPos = math.min(repll.cursorPos + 1, #repll.buffer)
            blinker = 1
            if repll.enableSounds then
                Sound.playSFX("console/console_keypress"..rngkey..".ogg")
            end
        elseif vk == VK_HOME then
            if repll.enableSounds then
                Sound.playSFX("console/console_resetfont.ogg")
            end
            if Misc.GetKeyState(VK_MENU) then
                repll.resetFontSize()
            else
                repll.cursorPos = 0
                blinker = 1
            end
        elseif vk == VK_END then
            repll.cursorPos = #repll.buffer
            blinker = 1
        elseif vk == VK_PRIOR then
            repll.increaseFontSize(0.1)
            if repll.enableSounds then
                Sound.playSFX("console/console_zoomin.ogg")
            end
        elseif vk == VK_NEXT then
            repll.decreaseFontSize(0.1)
            if repll.enableSounds then
                Sound.playSFX("console/console_zoomout.ogg")
            end
        elseif vk == VK_F9 then
            if repll.enableSounds then
                Sound.playSFX("console/console_resetfont.ogg")
            end
            repll.clearLog()
        elseif char ~= nil then
            local left, right = split(repll.buffer, repll.cursorPos)
            repll.buffer = left .. char .. right
            repll.cursorPos = repll.cursorPos + #char
            blinker = 1
        end
    end
    Misc.cheatBuffer("")
end

function repll.onPasteText(pastedText)
    local left, right = split(repll.buffer, repll.cursorPos)
    repll.buffer = left .. pastedText .. right
    repll.cursorPos = repll.cursorPos + #pastedText
    if repll.active then
        if repll.enableSounds then
            Sound.playSFX("console/console_paste.ogg")
        end
    end
    blinker = 1
end

function repll.onMouseWheelEvent(wheel, delta)
    if repll.active then
        if wheel == 0 then
            if delta == 120 then
                repll.textOffsetY = repll.textOffsetY + 18
                repll.cursorOffsetY = repll.cursorOffsetY + 18
            elseif delta == -120 then
                repll.textOffsetY = repll.textOffsetY - 18
                repll.cursorOffsetY = repll.cursorOffsetY - 18
            end
        end
    end
end

do
    local gtltrepllace = {["<"] = "<lt>", [">"] = "<gt>", ["\n"] = "<br>"}
    
    local baseX, baseY = 0, 600
    local doprint = {font=textplus.loadFont("textplus/font/5.ini"), color=Color.white, plaintext=true}

    doprint.xscale = GameData._repll.fontscale or 2
    doprint.yscale = doprint.xscale
    
    local glyphwid = (doprint.font.cellWidth + doprint.font.spacing)*doprint.xscale
    
    function repll.increaseFontSize(n)
        doprint.xscale = math.min(doprint.xscale + n, 3)
        doprint.yscale = doprint.xscale
        glyphwid = (doprint.font.cellWidth + doprint.font.spacing)*doprint.xscale
        GameData._repll.fontscale = doprint.xscale
    end
    
    function repll.decreaseFontSize(n)
        doprint.xscale = math.max(doprint.xscale - n, 1)
        doprint.yscale = doprint.xscale
        glyphwid = (doprint.font.cellWidth + doprint.font.spacing)*doprint.xscale
        GameData._repll.fontscale = doprint.xscale
    end
    
    function repll.resetFontSize()
        doprint.xscale = 2
        doprint.yscale = doprint.xscale
        glyphwid = (doprint.font.cellWidth + doprint.font.spacing)*doprint.xscale
        GameData._repll.fontscale = doprint.xscale
    end
    
    function repll.clearLog()
        repll.log = {"History cleared!"}
        GameData._repll.log = {"History cleared!"}
        Misc.cheatBuffer("")
    end
    
    local gsub = string.gsub
    local sub = string.sub
    local split = string.split
    local find = string.find
    local function _print(str, x, y)
        local textLayout = textplus.layout(str, nil, doprint)
        y = y - textLayout.height
        textplus.render{x = x, y = y, layout = textLayout, priority = 9.9}
    end
    local printlist = {}
    local listidx = 1
    local function addprint(v)
        printlist[listidx] = v
        listidx = listidx + 1
    end
    
    function repll.onDraw()
        if baseY ~= Screen.getScreenSize()[2] then
            baseY = Screen.getScreenSize()[2]
        end
        
        if not repll.active then
            GameData.toggleoffkeys = false
            return
        end
        if repll.active then
            GameData.toggleoffkeys = true
        end
        Graphics.drawScreen({color = repll.background, priority = 9.8})
        local buffer
        if find(repll.buffer, "\n") then
            buffer = split(repll.buffer, "\n")
        else
            buffer = {repll.buffer}
        end

        local y = baseY
        for i = #buffer, 1, -1 do
            if (i ~= #buffer) then
                y = y - 9*doprint.yscale
                addprint("\n")
            end
            if y < 0 then
                break
            end
            addprint(buffer[i])
            if i == 1 then
                addprint(">")
            else
                addprint(" ")
            end
        end
        
        if blinker > 0 then
            local x = baseX + glyphwid/2
            local y = y
            if #buffer > 1 then
                local t = 0
                for i = 1, #buffer do
                    local nt = t + #(buffer[i]) + 1
                    if nt > repll.cursorPos then
                        x = x + (glyphwid * (repll.cursorPos - t))
                        break
                    elseif nt == repll.cursorPos then
                        x = baseX + 4*doprint.xscale
                        y = y + 9*doprint.yscale
                        break
                    end
                    y = y + 9*doprint.yscale
                    t = nt
                end
            else
                x = x + (glyphwid * repll.cursorPos)
            end
            _print("|", x + repll.cursorOffsetX, y + repll.cursorOffsetY)
        end
        blinker = blinker + 1
        if blinker > 32 then
            blinker = -32
        end
        
        local originalScreenLength = repll.maxScreenLength
        
        for i = #repll.log, 1, -1 do
            repll.maxScreenLength = repll.maxScreenLength - repll.maxLines
            addprint("\n")
            if repll.maxScreenLength < 0 then
                repll.maxScreenLength = originalScreenLength
                break
            end
            addprint(repll.log[i])
        end

        printlist[listidx] = nil
        listidx = 1
        
        _print(table.concat(table.reverse(printlist)), baseX + repll.textOffsetX, baseY + repll.textOffsetY)
    end
end

return repll