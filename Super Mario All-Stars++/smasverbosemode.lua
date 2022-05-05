--smasverbosemode.lua
--By Spencer Everly

local textplus = require("textplus")
local doprint = {font=textplus.loadFont("littleDialogue/font/6.ini"), color=Color.white, plaintext=true}

local smasverbosemode = {}

smasverbosemode.activated = false
GameData.verboseLog = {}
smasverbosemode.verboseLog = GameData.verboseLog

function _verboseprintString(str)
	if str == nil then
		str = ""
	end
	if str:find("\n") then
		for k,v in ipairs(str:split("\n")) do
			table.insert(smasverbosemode.verboseLog, v)
		end
	elseif str then
		table.insert(smasverbosemode.verboseLog, str)
	end
end

local function _verboseprintValues(vals)
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
			_verboseprintString(t[i] or "nil")
		end
	else
		local s = ""
		for i = 1, maxIdx do
			if s ~= "" then
				s = s .. " "
			end
			s = s .. (t[i] or "nil")
		end
		_verboseprintString(s)
	end
end

function _verboseprint(str, x, y)
	local textLayout = textplus.layout(str, nil, doprint)
	y = y - textLayout.height
	textplus.render{x = x, y = y, layout = textLayout, priority = 0}
end

function smasverbosemode.onInitAPI()
	registerEvent(smasverbosemode,"onDraw")
end

function smasverbosemode.onDraw()
	if smasverbosemode.activated == true then
		--_verboseprint("I have no idea", 10, 10)
	end
end

return smasverbosemode