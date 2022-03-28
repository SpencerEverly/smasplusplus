local repl = {}

-- TODO: Handle unicode better. Textplus renders utf-8 fine, but repl for cursor management
--       purposes repl is not respecting multi-byte characters properly.

local inspect = require("ext/inspect")
local textplus = require("textplus")
local rng = require("base/rng")

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

local repl_env = {}
local repl_mt = {__index = Misc.getCustomEnvironment()}
setmetatable(repl_env, repl_mt)

local rawload = load
local function load(str)
	return rawload(str, str, "t", repl_env)
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


if GameData._repl == nil then
	GameData._repl = { history = {}, log = {} }
end

repl.log = GameData._repl.log
repl.history = GameData._repl.history
repl.buffer = ""
repl.historyPos = 0
repl.cursorPos = 0

local function printString(str)
	if str == nil then
		str = ""
	end
	if str:find("\n") then
		for k,v in ipairs(str:split("\n")) do
			table.insert(repl.log, v)
		end
	elseif str then
		table.insert(repl.log, str)
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
	elseif isValid(str) then
		exec(str)
	else
		printError(select(2, load(str)))
	end
end

function repl.cmd()
	local isIncomplete = false
	if not isExpression(repl.buffer) then
		local _, err = load(repl.buffer)
		if err then
			isIncomplete = err:match("expected near '<eof>'$") or err:match("'end' expected")
		end
	end
	if isIncomplete then
		repl.buffer = repl.buffer .. "\n"
		repl.cursorPos = #repl.buffer
		return
	end
	printString(">" .. repl.buffer:gsub("\n", "\n "))
	if repl.buffer ~= "" then
		table.insert(repl.history, repl.buffer)
		cmd(repl.buffer)
		repl.buffer = ""
		repl.historyPos = 0
		repl.cursorPos = 0
	end
end

-----------------------------
-- SMBX ENGINE INTEGRATION --
-----------------------------

local event_tbl = {}
function repl_mt.__newindex(t, k, v)
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

repl.active = false
repl.activeInEpisode = false
repl.background = Color(0,0,0,0.5)

function repl.onInitAPI()
	registerEvent(repl, "onKeyboardPressDirect")
	registerEvent(repl, "onDraw")
	registerEvent(repl, "onPasteText")
	registerEvent(repl, "onInputUpdate")
end

function console.onInputUpdate()
	if not repl.active then
		if player.keys.dropItem == KEYS_PRESSED then
			player.keys.dropItem = KEYS_PRESSED
		end
	end
	if repl.active then
		if player.keys.dropItem == KEYS_PRESSED then
			player.keys.dropItem = KEYS_UNPRESSED
		end
	end
end

function repl.onKeyboardPressDirect(vk, repeated, char)
	if not (repl.activeInEpisode or Misc.inEditor()) then return end

	if not repl.active then
		if (vk == VK_TAB) and (not repeated) then
			Misc.pause()
			SFX.play("_OST/_Sound Effects/console/console_open.ogg")
			GameData.toggleoffinventory = true
			Misc.cheatBuffer("")
			repl.active = true
		end
		return
	end
	
	local rngkey = rng.randomInt(1,7)
	SFX.play("_OST/_Sound Effects/console/console_keypress"..rngkey..".ogg")
	
	if vk == VK_TAB or vk == VK_ESCAPE then
		if (not repeated) then
			Misc.unpause()
			SFX.play("_OST/_Sound Effects/console/console_close.ogg")
			GameData.toggleoffinventory = false
			repl.active = false
		end
	elseif vk == VK_RETURN then
		if Misc.GetKeyState(VK_SHIFT) then
			local left, right = split(repl.buffer, repl.cursorPos)
			repl.buffer = left .. "\n" .. right
			repl.cursorPos = repl.cursorPos + 1
			blinker = 1
			SFX.play("_OST/_Sound Effects/console/console_keypressenter.ogg")
		else
			repl.cmd()
		end
	elseif vk == VK_BACK then
		local left, right = split(repl.buffer, repl.cursorPos)
		repl.buffer = left:sub(1, -2) .. right
		repl.cursorPos = math.max(0, repl.cursorPos - 1)
		SFX.play("_OST/_Sound Effects/console/console_keypressbackspace.ogg")
		blinker = 1
	elseif vk == VK_DELETE then
		local left, right = split(repl.buffer, repl.cursorPos)
		repl.buffer = left .. right:sub(2)
		SFX.play("_OST/_Sound Effects/console/console_keypress7.ogg")
		blinker = 1
	elseif vk == VK_UP or vk == VK_DOWN then
		if vk == VK_UP then
			repl.historyPos = math.min(repl.historyPos + 1, #repl.history)
		elseif vk == VK_DOWN then
			repl.historyPos = math.max(0, repl.historyPos - 1)
		end
		if repl.historyPos == 0 then
			repl.buffer = ""
		else
			repl.buffer = repl.history[#repl.history - repl.historyPos + 1]
		end
		repl.cursorPos = #repl.buffer
		blinker = 1
	elseif vk == VK_LEFT then
		repl.cursorPos = math.max(0, repl.cursorPos - 1)
		blinker = 1
	elseif vk == VK_RIGHT then
		repl.cursorPos = math.min(repl.cursorPos + 1, #repl.buffer)
		blinker = 1
	elseif vk == VK_HOME then
		if Misc.GetKeyState(VK_MENU) then
			repl.resetFontSize()
		else
			repl.cursorPos = 0
			blinker = 1
		end
	elseif vk == VK_END then
		repl.cursorPos = #repl.buffer
		blinker = 1
	elseif vk == VK_PRIOR then
		repl.increaseFontSize(0.1)
	elseif vk == VK_NEXT then
		repl.decreaseFontSize(0.1)
	elseif char ~= nil then
		local left, right = split(repl.buffer, repl.cursorPos)
		repl.buffer = left .. char .. right
		repl.cursorPos = repl.cursorPos + #char
		blinker = 1
	end
	Misc.cheatBuffer("")
end

function repl.onPasteText(pastedText)
	local left, right = split(repl.buffer, repl.cursorPos)
	repl.buffer = left .. pastedText .. right
	repl.cursorPos = repl.cursorPos + #pastedText
	SFX.play("_OST/_Sound Effects/console/console_paste.ogg")
	blinker = 1
end

do
	local gtltreplace = {["<"] = "<lt>", [">"] = "<gt>", ["\n"] = "<br>"}

	local doprint = {font=textplus.loadFont("textplus/font/5.ini"), color=Color.white, plaintext=true}
	
	doprint.xscale = GameData._repl.fontscale or 2
	doprint.yscale = doprint.xscale
	
	local glyphwid = (doprint.font.cellWidth + doprint.font.spacing)*doprint.xscale
	
	function repl.increaseFontSize(n)
		doprint.xscale = math.min(doprint.xscale + n, 3)
		doprint.yscale = doprint.xscale
		glyphwid = (doprint.font.cellWidth + doprint.font.spacing)*doprint.xscale
		GameData._repl.fontscale = doprint.xscale
	end
	
	function repl.decreaseFontSize(n)
		doprint.xscale = math.max(doprint.xscale - n, 1)
		doprint.yscale = doprint.xscale
		glyphwid = (doprint.font.cellWidth + doprint.font.spacing)*doprint.xscale
		GameData._repl.fontscale = doprint.xscale
	end
	
	function repl.resetFontSize()
		doprint.xscale = 2
		doprint.yscale = doprint.xscale
		glyphwid = (doprint.font.cellWidth + doprint.font.spacing)*doprint.xscale
		GameData._repl.fontscale = doprint.xscale
	end
	
	local gsub = string.gsub
	local sub = string.sub
	local split = string.split
	local find = string.find
	local function _print(str, x, y)
		local textLayout = textplus.layout(str, nil, doprint)
		y = y - textLayout.height
		textplus.render{x = x, y = y, layout = textLayout, priority=10}
	end
	
	local bgobj = {color = repl.background, priority = 10}
	local printlist = {}
	local listidx = 1
	local function addprint(v)
		printlist[listidx] = v
		listidx = listidx + 1
	end
	local baseX, baseY = 0, 600
	
	function repl.onDraw()
		if not repl.active then
			return
		end
		
		--Graphics.drawScreen(bgobj)
		local buffer
		if find(repl.buffer, "\n") then
			buffer = split(repl.buffer, "\n")
		else
			buffer = {repl.buffer}
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
					if nt > repl.cursorPos then
						x = x + (glyphwid * (repl.cursorPos - t))
						break
					elseif nt == repl.cursorPos then
						x = baseX + 4*doprint.xscale
						y = y + 9*doprint.yscale
						break
					end
					y = y + 9*doprint.yscale
					t = nt
				end
			else
				x = x + (glyphwid * repl.cursorPos)
			end
			_print("|", x, y)
		end
		blinker = blinker + 1
		if blinker > 32 then
			blinker = -32
		end
		
		for i = #repl.log, 1, -1 do
			y = y - 18
			addprint("\n")
			if y < 0 then
				break
			end
			addprint(repl.log[i])
		end

		printlist[listidx] = nil
		listidx = 1
		
		_print(table.concat(table.reverse(printlist)), baseX, baseY)
	end
end

return repl