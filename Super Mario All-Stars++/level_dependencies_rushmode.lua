local rng = require("base/rng")

local rushmode = {}

local texttimer1 = false
local gotext = false
local selecter2 = rng.randomInt(1,#smastables.__allMandatoryLevels)

function rushmode.onInitAPI()
	registerEvent(rushmode,"onStart")
	registerEvent(rushmode,"onTick")
	registerEvent(rushmode,"onDraw")
	registerEvent(rushmode,"onExit")
end

function startCountdown()
	Routine.wait(0.1, true)
	texttimer1 = true
	muteMusic(-1)
	Misc.pause()
	playSound("rushmode/whoosh.ogg")
	playSound("rushmode/start.ogg")
	Routine.wait(1.0, true)
	gotext = true
	playSound("rushmode/dong.ogg")
	Routine.wait(1.5, true)
	Misc.unpause()
	texttimer1 = false
	gotext = false
	restoreMusic(-1)
end

function rushmode.onStart()
	if table.icontains(smastables.__smb1Levels,Level.filename()) then
		Timer.activate(100)
	elseif Level.filename() == "SMB1 - W-8, L-4.lvlx" then
		Timer.activate(220)
	elseif table.icontains(smastables.__smb2Levels,Level.filename()) then
		Timer.activate(400)
	elseif Level.filename() == "SMB2 - W-7, L-2.lvlx" then
		Timer.activate(550)
	end
	if table.icontains(smastables.__smb1Levels,Level.filename()) or table.icontains(smastables.__smb2Levels,Level.filename()) then
		Routine.run(startCountdown)
	end
	GameData.rushModeWon = false
end

function rushmode.onDraw()
	if texttimer1 then
		Text.printWP("Get to the end of the level in", 150, 200, -1)
		Text.printWP(Timer.getValue().." seconds!", 150, 220, -1)
	end
	if gotext then
		Text.printWP("GO!", 350, 400, -1)
	end
	if Level.endState() >= 1 then
		GameData.rushModeWon = true
	end
	if GameData.rushModeWon == true then
		Text.printWP("You won!", 350, 250, -1)
	end
end

function rushmode.onExit()
	if GameData.rushModeWon then
		Level.load("SMAS - Rush Mode Results.lvlx")
	end
end

return rushmode