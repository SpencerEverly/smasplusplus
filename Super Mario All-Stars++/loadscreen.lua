local letterWidths = {
    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},
    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},

    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},
}

local EP_LIST_PTR = mem(0x00B250FC, FIELD_DWORD)
local episodePath = _episodePath
 
do
    -- The following code makes the loading screen slightly less restricted
 
    local function exists(path)
        local f = io.open(path,"r")
 
        if f ~= nil then
            f:close()
            return true
        else
            return false
        end
    end
    
    Misc.episodePath = (function()
        return Native.getEpisodePath()
    end)
    
    Misc.episodeName = (function()
        local idx = mem(0x00B2C628, FIELD_WORD) - 1
        if(idx < 0) then
            return "SMBX2"
        end
        return tostring(mem(EP_LIST_PTR + (idx * 0x18), FIELD_STRING))
    end)
    
    local resolvePaths = {
				Misc.episodePath(),
				getSMBXPath().."\\scripts\\",
				getSMBXPath().."\\"
			}
    
    Misc.multiResolveFile = (function(...)
        local t = {...}
        
        --If passed a complete path, just return it as-is (as long as the file exists)
        for _,v in ipairs(t) do
            if string.match(v, "^%a:[\\/]") and io.exists(v) then
                return v
            end
        end

        for _,p in ipairs(resolvePaths) do
            for _,v in ipairs(t) do
                if io.exists(p..v) then
                    return p..v
                end
            end
        end
        return nil
    end)
    
    Misc.resolveFile = (function(path)
        local inScriptPath = getSMBXPath().. "\\scripts\\".. path
        local inEpisodePath = episodePath.. path
 
        return (exists(path) and path) or (exists(inEpisodePath) and inEpisodePath) or (exists(inScriptPath) and inScriptPath) or nil
    end)
 
    Misc.resolveGraphicsFile = Misc.resolveFile -- good enough lol
    
    -- Make require work better
    local oldRequire = require
 
    function require(path)
        local inScriptPath = getSMBXPath().. "\\scripts\\".. path.. ".lua"
        local inScriptBasePath = getSMBXPath().. "\\scripts\\base\\".. path.. ".lua"
        local inEpisodePath = episodePath.. path.. ".lua"
 
        local path = (exists(inEpisodePath) and inEpisodePath) or (exists(inScriptPath) and inScriptPath) or (exists(inScriptBasePath) and inScriptBasePath)
        assert(path ~= nil,"module '".. path.. "' not found.")
 
        return oldRequire(path)
    end
 
 
    -- classexpender stuff
    function string.split(s, p, exclude, plain)
        if  exclude == nil  then  exclude = false; end;
        if  plain == nil  then  plain = true; end;
 
        local t = {};
        local i = 0;
    
        if(#s <= 1) then
            return {s};
        end
    
        while true do
            local ls,le = s:find(p, i, plain);  --find next split pattern
            if (ls ~= nil) then
                table.insert(t, string.sub(s, i,le-1));
                i = ls+1;
                if  exclude  then
                    i = le+1;
                end
            else
                table.insert(t, string.sub(s, i));
                break;
            end
        end
        
        return t;
    end
 
    function table.clone(t)
        local rt = {};
        for k,v in pairs(t) do
            rt[k] = v;
        end
        setmetatable(rt, getmetatable(t));
        return rt;
    end
 
    function table.ishuffle(t)
        for i=#t,2,-1 do 
            local j = RNG.randomInt(1,i)
            t[i], t[j] = t[j], t[i]
        end
        return t
    end
 
    function math.clamp(a,mi,ma)
        mi = mi or 0;
        ma = ma or 1;
        return math.min(ma,math.max(mi,a));
    end
 
    
    local validAudioFiles = {".ogg", ".mp3", ".wav", ".voc", ".flac", ".spc"}
	
	--table.map doesn't exist yet
	local validFilesMap = {};
	for _,v in ipairs(validAudioFiles) do
		validFilesMap[v] = true;
	end
	
	Misc.resolveSoundFile = (function(path)
		local p,e = string.match(string.lower(path), "^(.+)(%..+)$")
		local t = {}
		local idx = 1
		local typeslist = validAudioFiles
		if e and validFilesMap[e] then
			--Re-arrange type list to prioritise type that was provided to the resolve function
			if e ~= validAudioFiles[1] then
				typeslist = { e }
				for _,v in ipairs(validAudioFiles) do
					if v ~= e then
						table.insert(typeslist, v)
					end
				end
			end
			path = p
		end
		for _,typ in ipairs(typeslist) do
			t[idx] = path..typ
			t[idx+#typeslist] = "sound/"..path..typ
			t[idx+2*#typeslist] = "sound/extended/"..path..typ
			idx = idx+1
		end
		
		return Misc.multiResolveFile(table.unpack(t))
	end)
 
    
    _G.lunatime = require("engine/lunatime")
    _G.Color = require("engine/color")
    _G.rng = require("rng")
    _G.textplus = require("textplus")
end

package.path = package.path .. ";./scripts/?.lua"
-- Address of the first player's character. Equivalent to 'player.character', except the player class doesn't exist in loading screens
local FIRST_PLAYER_CHARACTER_ADDR = mem(0x00B25A20,FIELD_DWORD) + 0x184 + 0xF0
local episodePath = mem(0x00B2C61C, FIELD_STRING)

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
local loadingTimer = 0

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
    
    loadingTimer = loadingTimer + 1
    
    textplus.print{
        x = 0,
        y = 0,
        text = "Loadtimer: "..tostring(loadingTimer)
    }

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