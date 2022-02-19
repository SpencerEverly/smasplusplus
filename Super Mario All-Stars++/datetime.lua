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
		Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=8}
		textplus.print{x=724, y=580, text = "Time - ", priority=8, color=Color.white} --What time is it...!?
		textplus.print{x=755, y=580, text = os.date("%I"), priority=8, color=Color.white}
		textplus.print{x=765, y=580, text = ":", priority=8, color=Color.white}
		textplus.print{x=768, y=580, text = os.date("%M"), priority=8, color=Color.white}
		textplus.print{x=780, y=580, text = os.date("%p"), priority=8, color=Color.white}
		Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=8}
		textplus.print{x=700, y=557, text = "Date - ", priority=8, color=Color.white} --What's the day, sir?!
		textplus.print{x=733, y=557, text = os.date("%a"), priority=8, color=Color.white}
		textplus.print{x=752, y=557, text = os.date("%x"), priority=8, color=Color.white}
	end
	if datetime.topright then
		Graphics.drawBox{x=719, y=43, width=76, height=20, color=Color.black..0.2, priority=8}
		textplus.print{x=724, y=38, text = "Time - ", priority=8, color=Color.white} --What time is it...!?
		textplus.print{x=755, y=38, text = os.date("%I"), priority=8, color=Color.white}
		textplus.print{x=765, y=38, text = ":", priority=8, color=Color.white}
		textplus.print{x=768, y=38, text = os.date("%M"), priority=8, color=Color.white}
		textplus.print{x=780, y=38, text = os.date("%p"), priority=8, color=Color.white}
		Graphics.drawBox{x=695, y=10, width=100, height=20, color=Color.black..0.2, priority=8}
		textplus.print{x=700, y=15, text = "Date - ", priority=8, color=Color.white} --What's the day, sir?!
		textplus.print{x=733, y=15, text = os.date("%a"), priority=8, color=Color.white}
		textplus.print{x=752, y=15, text = os.date("%x"), priority=8, color=Color.white}
	end
end

return datetime