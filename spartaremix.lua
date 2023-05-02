local textplus = require("textplus")
local playerManager = require("playerManager")
local rng = require("rng")

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

f8PressedState = false

local costumes = {}

local flag = true
local str = "Loading HUB..."

local spartaremix = {}

local oldCostume = {}
local costumes = {}
local idMap = {}

local soundObject

local characterID = 1

local printplus = function(text, x, y, z, color, pivot)
  textplus.print{text = text, x = x, y = y, priority = z, xscale = 2, yscale = 2, color = color, plaintext = true, pivot = pivot}
end

--local levelfolder = Level.folderPath()
--local levelname = Level.filename()
--local levelformat = Level.format()

-- Better rng used by multiple modules
spartaremix.betterrng = function(tbl, x)
  local t = {}
  for _, v in ipairs(tbl) do
    if v ~= x then
      table.insert(t, v)
    end
  end
  return rng.irandomEntry(t)
end

function string.endswith(String,End)
  return End == '' or string.sub(String, -string.len(End)) == End
end

local randomsong = function()
  local files = Misc.listLocalFiles("../_OST/Sparta Remixes/")
  local musicfiles = {}
  for i = 1, #files do
    if string.endswith(files[i], ".mp3") or string.endswith(files[i], ".ogg") then
      table.insert(musicfiles, files[i])
    end
  end
  if #musicfiles ~= 0 then
    local songname
    if #musicfiles == 1 then
      songname = musicfiles[1]
    else
      songname = spartaremix.betterrng(musicfiles, prevsong)
    end
    Audio.MusicOpen(Misc.resolveFile("../_OST/Sparta Remixes/"..songname))
    Audio.MusicPlay()
    Sound.changeMusic("/_OST/Sparta Remixes/"..songname, -1)
    --randomsong.setFrameTimer(1, function() printplus("Remix playing: "..songname, 792, 8, 6, Color.white, vector.v2(1, 0)) end, 100)
    --randomsong.setFrameTimer(1, function() printplus("If you are the creator and want this remix removed,", 792, 30, 6, Color.white, vector.v2(1, 0)) end, 100)
    --randomsong.setFrameTimer(1, function() printplus("contact me at spencer.everly@gmail.com", 792, 52, 6, Color.white, vector.v2(1, 0)) end, 100)
    prevsong = songname
  end
end

local printplus = function(text, x, y, z, color, pivot)
  textplus.print{text = text, x = x, y = y, priority = z, xscale = 2, yscale = 2, color = color}
end

function spartaremix.onInitAPI()
    registerEvent(spartaremix, "onKeyboardPress")
    registerEvent(spartaremix, "onInputUpdate")
    registerEvent(spartaremix, "onDraw")
    registerEvent(spartaremix, "onLevelExit")
    registerEvent(spartaremix, "onTick")
    registerEvent(spartaremix, "onEvent")
    
    ready = true
end

function spartaremix.onStart()
    if not ready then return end
end

function spartaremix.onKeyboardPress(k)
    if k == VK_F7 then
        player.pauseKeyPressing = false
        f8PressedState = true
        active = not active
    end
    if active then
        if k == VK_F7 then
        SFX.play("remix-on.ogg")
        local myRoutine = Routine.run(randomsong)
        end
    end
    if not active then
        if k == VK_F7 then
            SFX.play("remix-off.ogg")
            f8PressedState = false
        end
    end
end

function spartaremix.onDraw(k)
    if active then
        
        Graphics.drawBox{x=0, y=565, width=558, height=46, color=Color.black..0.7, priority=-2}
        textplus.print{x=5, y=572, text = "Sparta Remix now playing. If it's not playing, change out of a costume first. Press F7 to exit and press F7 again to play another.", priority=-1, color=Color.white}
        textplus.print{x=5, y=586, text = "(To reset the music please restart the level, this is due to MusicChange not having a reset command)", priority=-1, color=Color.white}
    end
end

return spartaremix