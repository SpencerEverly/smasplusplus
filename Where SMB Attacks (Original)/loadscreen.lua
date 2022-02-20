package.path = package.path .. ";./scripts/?.lua"
local episodePath = mem(0x00B2C61C, FIELD_STRING)

local loadicon = Graphics.loadImage("hardcoded-30-5.png")

local frame = 0
local frame2 = 0
local timer = 0
local speed = 0

local time = 0

function onDraw()
	local opacity = math.min(1,time/42)
	
	speed = speed - 1
	Graphics.drawImage(loadicon, 672, 536, 0, frame2 * 64, 128, 64,opacity)
	frame = math.floor(timer/speed)%7
	timer = timer + 1	
	frame2 = math.floor(timer/8)%7

    time = time + 1
end