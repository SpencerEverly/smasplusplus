--[[ Speedrun Timer on Level (from MaGLX3 episode)
Scripted by Lukinsky (LooKiCH)
My YT channels:
• LooKiCH (podcast videos & several streams): https://www.youtube.com/channel/UCWT47hfGW84gWQ5CQ9DapCA
• LooKiCH • SMBX (SMBX videos from streams): https://www.youtube.com/channel/UCFkVstoD5SR_wY2febw9uOA
• Pro SMBX-er (SMBX videos without comments): https://www.youtube.com/channel/UCLciCUubaVl7bNzL1astePw
]]--


local speedruntimer = {}

local textplus = require("textplus")

SaveData.trackers = SaveData.trackers or {
	speedrunTimer = 0,
	levels = {}
}

local thisRunTime = 0
local font = textplus.loadFont("textplus/font/6.ini")  -- You can choose the path to the custom font on Level, ready-made fonts are in /data/scripts/textplus/font/

if SaveData.trackers.levels == nil then
	SaveData.trackers.speedrunTimer = 0
	SaveData.trackers.levels = {}
end

local function drawSpeedrunTimer()
	local timer1 = SaveData.trackers.speedrunTimer
	-- Total Timer ↓
    local t1= string.format("%.1d:%.2d:%.2d.%.3d", timer1/(60 * 60 * 65), (timer1/(60*65))%60, (timer1/65)%60, ((timer1%65)/65) * 1000)
    local dt = thisRunTime
	-- World Map Timer ↓
    local t2 = string.format("%.1d:%.2d:%.2d.%.3d", dt/(60 * 60 * 65), (dt/(60*65))%60, (dt/65)%60, ((dt%65)/65) * 1000)
	-- You can change time format on 'local t1, t2 or t3'
	textplus.print{
		text = t1,
		pivot = {1, 0},
		x = 488,
		y = 582,
		xscale = 2,
		font = font,
		yscale = 2,
		priority = -1
	} -- Timer placement settings
	textplus.print{
		text = t2,
		pivot = {1, 0},
		x = 488,
		y = 566,
		xscale = 2,
		font = font,
		yscale = 2,
		color = Color.lightgrey,
		priority = -1
	}
    local best = SaveData.trackers.levels[Level.filename()].bestTime
	if best >= 0 then
	-- Min Record Timer ↓
    	local t3 = string.format("%.1d:%.2d:%.2d.%.3d", best/(60 * 60 * 65), (best/(60*65))%60, (best/65)%60, ((best%65)/65) * 1000)
		textplus.print{
			text = t3,
			pivot = {1, 0},
			x = 488,
			y = 550,
			xscale = 2,
			font = font,
			yscale = 2,
			color = Color.lightgreen,
			priority = -1
		}
	end
end

Graphics.addHUDElement(drawInputDisplay)
Graphics.addHUDElement(drawSpeedrunTimer)


function speedruntimer.onDraw()
	SaveData.trackers.speedrunTimer = SaveData.trackers.speedrunTimer + 1
	if (not Misc.isPaused()) and (not hasWon) and (not hasDied) then
		thisRunTime = thisRunTime + 1
	end

	if Level.winState() > 0 and not hasWon then
		hasWon = true
		local tracker = SaveData.trackers.levels[Level.filename()]
		if tracker.bestTime == -1 or tracker.bestTime > thisRunTime then
			tracker.bestTime = thisRunTime
		end
	end

	if not isPaused then return end
end

function speedruntimer.onStart()
	if SaveData.trackers.levels[Level.filename()] == nil then
		SaveData.trackers.levels[Level.filename()] = {
			bestTime = -1,
			storedCheckpointTime = 0
		}
	end
end

registerEvent(speedruntimer, "onPause")
registerEvent(speedruntimer, "onInputUpdate")
registerEvent(speedruntimer, "onMessageBox")
registerEvent(speedruntimer, "onStart")
registerEvent(speedruntimer, "onTickEnd")
registerEvent(speedruntimer, "onDraw")

return speedruntimer