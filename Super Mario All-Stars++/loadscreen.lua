local letterWidths = {
    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},
    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},

    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},
}

do
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
end

do --Table helper functions
	function table.ifindlast(t, val)
		for i = #t,1,-1 do
			if(t[i] == val) then
				return i;
			end
		end
		return nil;
	end

	function table.findlast(t, val)
		local lst = nil;
		for k,v in pairs(t) do
			if(v == val) then
				lst = k;
			end
		end
		return lst;
	end

	function table.ifind(t, val)
		for k,v in ipairs(t) do
			if(v == val) then
				return k;
			end
		end
		return nil;
	end

	function table.find(t, val)
		for k,v in pairs(t) do
			if(v == val) then
				return k;
			end
		end
		return nil;
	end

	function table.ifindall(t, val)
		local rt = {};
		for k,v in ipairs(t) do
			if(v == val) then
				table.insert(rt,k);
			end
		end
		return rt;
	end

	function table.findall(t, val)
		local rt = {};
		for k,v in pairs(t) do
			if(v == val) then
				table.insert(rt,k);
			end
		end
		return rt;
	end

	function table.icontains(t, val)
		return table.ifind(t, val) ~= nil;
	end

	function table.contains(t, val)
		return table.find(t, val) ~= nil;
	end

	function table.iclone(t)
		local rt = {};
		for k,v in ipairs(t) do
			rt[k] = v;
		end
		setmetatable(rt, getmetatable(t));
		return rt;
	end

	function table.clone(t)
		local rt = {};
		for k,v in pairs(t) do
			rt[k] = v;
		end
		setmetatable(rt, getmetatable(t));
		return rt;
	end

	function table.ideepclone(t)
		local rt = {};
		for k,v in ipairs(t) do
			if(type(v) == "table") then
				rt[k] = table.deepclone(v);
			else
				rt[k] = v;
			end
		end
		setmetatable(rt, getmetatable(t));
		return rt;
	end

	function table.deepclone(t)
		local rt = {};
		for k,v in pairs(t) do
			if(type(v) == "table") then
				rt[k] = table.deepclone(v);
			else
				rt[k] = v;
			end
		end
		setmetatable(rt, getmetatable(t));
		return rt;
	end

	function table.ishuffle(t)
		for i=#t,2,-1 do 
			local j = rng.randomInt(1,i)
			t[i], t[j] = t[j], t[i]
		end
		return t
	end
	
	function table.map(t)
		local t2 = {};
		for _,v in ipairs(t) do
			t2[v] = true;
		end
		return t2;
	end
	
	function table.unmap(t)
		local t2 = {};
		for k,_ in pairs(t) do
			table.insert(t2,k);
		end
		return t2;
	end

	function table.join(...)
		local ts = {...};
		local t = {};
		local ct = #ts;
		for i=ct,1,-1 do
			for k,v in pairs(ts[i]) do
				t[k] = v;
			end
		end
		return t;
	end
	
	function table.append(...)
		local ts = {...}
		local t = {};
		for _,t1 in ipairs(ts) do
			for _,v in ipairs(t1) do
				table.insert(t,v);
			end
		end
		return t;
	end

	function table.reverse(t)
		local len = 0
		for k,_ in ipairs(t) do
			len = k
		end
		local rt = {}
		for i = 1, len do
			rt[len - i + 1] = t[i]
		end
		return rt
	end
	
	function table.flatten(t)
		local t2 = {};
		for _,v in ipairs(t) do
			if(pcall(ipairs(v))) then
				for _,v2 in ipairs(v) do
					table.insert(t2, v2);
				end
			else
				table.insert(t2, v);
			end
		end
		return t2;
	end
end

-- Address of the first player's character. Equivalent to 'player.character', except the player class doesn't exist in loading screens
local FIRST_PLAYER_CHARACTER_ADDR = mem(0x00B25A20,FIELD_DWORD) + 0x184 + 0xF0

--package.path = package.path .. ";./scripts/?.lua"
local episodePath = mem(0x00B2C61C, FIELD_STRING)
local rng = require("base/rng")

local textplus = require("textplus")

local image = Graphics.loadImage("loadscreen.png")
local blackscreen = Graphics.loadImage("black-screen.png")
local loadicon = Graphics.loadImage("loadscreen-logo.png")

local frame = 0
local frame2 = 0
local timer = 0
local speed = 0

local didyouknow = {"didyouknow1.png", "didyouknow2.png", "didyouknow3.png", "didyouknow4.png", "didyouknow5.png", "didyouknow6.png", "didyouknow7.png", "didyouknow8.png", "didyouknow9.png", "didyouknow10.png", "didyouknow11.png", "didyouknow12.png", "didyouknow13.png", "didyouknow14.png", "didyouknow15.png", "didyouknow16.png", "didyouknow17.png"}
local selecter = rng.randomInt(1,#didyouknow)
local knowledge = Graphics.loadImage(episodePath..didyouknow[selecter]);

if os ~= nil then
	local nativeOS = os
	local newOS = {}
	newOS.clock = nativeOS.clock
	newOS.date = nativeOS.date
	newOS.time = nativeOS.time
	newOS.difftime = nativeOS.difftime
	newOS.exit = function() error("Shutdown") end
	
	os = newOS
	_G.os = newOS
end

local letterData = {}

local time = 0

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
	Graphics.drawImage(loadicon, 672, 536, 1, frame2 * 64, 128, 64, opacity)
	frame = math.floor(timer/speed)%7
	timer = timer + 1	
	frame2 = math.floor(timer/8)%7
	
	Graphics.drawImage(knowledge, 0, 0, 1, 0, 800, 600, opacity)
	textplus.print{x=700, y=15, text = "Date and time not", priority=1, color=Color.white}
	textplus.print{x=700, y=30, text = "available until loading", priority=1, color=Color.white}
	textplus.print{x=700, y=45, text = "is complete.", priority=1, color=Color.white}

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

    time = time + 1
end