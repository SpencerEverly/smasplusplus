local textplus = require("textplus")

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

local flag = true
local str = "Loading HUB..."

local datetime = {}

datetime.bottomright = true
datetime.topright = false

local exacttime = os.date("%X")

local minute = os.date("%M")

local second = os.date("%S")

local hour = os.date("%H")

local day = os.date("%d")

local month = os.date("%m")

local soundObject

local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

function datetime.onInitAPI()
	registerEvent(datetime, "onKeyboardPress")
	registerEvent(datetime, "onDraw")
	registerEvent(datetime, "onLevelExit")
	
	ready = true
end

function datetime.onStart()
	if not ready then return end
end

function datetime.onDraw()
	if datetime.bottomright then
		if SaveData.resolution == "widescreen" then
			Graphics.drawBox{x=719, y=495, width=76, height=20, color=Color.black..0.2, priority=8}
			textplus.print{x=724, y=500, text = "Time - ", priority=8, color=Color.white} --What time is it...!?
			textplus.print{x=755, y=500, text = os.date("%I"), priority=8, color=Color.white}
			textplus.print{x=765, y=500, text = ":", priority=8, color=Color.white}
			textplus.print{x=768, y=500, text = os.date("%M"), priority=8, color=Color.white}
			textplus.print{x=780, y=500, text = os.date("%p"), priority=8, color=Color.white}
			Graphics.drawBox{x=695, y=472, width=100, height=20, color=Color.black..0.2, priority=8}
			textplus.print{x=700, y=477, text = "Date - ", priority=8, color=Color.white} --What's the day, sir?!
			textplus.print{x=733, y=477, text = os.date("%a"), priority=8, color=Color.white}
			textplus.print{x=752, y=477, text = os.date("%x"), priority=8, color=Color.white}
		elseif SaveData.resolution == "fullscreen" then
			Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=8}
			textplus.print{x=724, y=580, text = "Time - ", priority=8, color=Color.white} --What time is it...!?
			textplus.print{x=755, y=580, text = os.date("%I"), priority=8, color=Color.white}
			textplus.print{x=765, y=580, text = ":", priority=8, color=Color.white}
			textplus.print{x=768, y=580, text = os.date("%M"), priority=8, color=Color.white}
			textplus.print{x=780, y=580, text = os.date("%p"), priority=8, color=Color.white}
			Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=8}
			textplus.print{x=700, y=557, text = "Date - ", priority=8, color=Color.white} --What's the day, sir?!
			textplus.print{x=733, y=557, text = os.date("%a"), priority=8, color=Color.white}
			textplus.print{x=754, y=557, text = os.date("%x"), priority=8, color=Color.white}
		end
	end
	if datetime.topright then
		if SaveData.resolution == "widescreen" then
			Graphics.drawBox{x=719, y=103, width=76, height=20, color=Color.black..0.2, priority=8}
			textplus.print{x=724, y=108, text = "Time - ", priority=8, color=Color.white} --What time is it...!?
			textplus.print{x=755, y=108, text = os.date("%I"), priority=8, color=Color.white}
			textplus.print{x=765, y=108, text = ":", priority=8, color=Color.white}
			textplus.print{x=768, y=108, text = os.date("%M"), priority=8, color=Color.white}
			textplus.print{x=780, y=108, text = os.date("%p"), priority=8, color=Color.white}
			Graphics.drawBox{x=695, y=80, width=100, height=20, color=Color.black..0.2, priority=8}
			textplus.print{x=700, y=85, text = "Date - ", priority=8, color=Color.white} --What's the day, sir?!
			textplus.print{x=733, y=85, text = os.date("%a"), priority=8, color=Color.white}
			textplus.print{x=752, y=85, text = os.date("%x"), priority=8, color=Color.white}
		elseif SaveData.resolution == "fullscreen" then
			Graphics.drawBox{x=719, y=5, width=76, height=20, color=Color.black..0.2, priority=8}
			textplus.print{x=724, y=10, text = "Time - ", priority=8, color=Color.white} --What time is it...!?
			textplus.print{x=755, y=10, text = os.date("%I"), priority=8, color=Color.white}
			textplus.print{x=765, y=10, text = ":", priority=8, color=Color.white}
			textplus.print{x=768, y=10, text = os.date("%M"), priority=8, color=Color.white}
			textplus.print{x=780, y=10, text = os.date("%p"), priority=8, color=Color.white}
			Graphics.drawBox{x=695, y=27, width=100, height=20, color=Color.black..0.2, priority=8}
			textplus.print{x=700, y=32, text = "Date - ", priority=8, color=Color.white} --What's the day, sir?!
			textplus.print{x=733, y=32, text = os.date("%a"), priority=8, color=Color.white}
			textplus.print{x=752, y=32, text = os.date("%x"), priority=8, color=Color.white}
		end
	end
end

return datetime