local rushmode = {}

GameData.rushModeActive = true

local texttimer1 = false
local gotext = false
local selecter2 = rng.randomInt(1,#GameData.rushlevelsrng)

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
	if table.icontains(GameData._smb1Levels,Level.filename()) then
		Timer.activate(100)
	elseif table.icontains(GameData._smb1Levels,"SMB1 - W-8, L-4.lvlx") then
		Timer.activate(220)
	elseif table.icontains(GameData._smb2Levels,Level.filename()) then
		Timer.activate(400)
	end
	Routine.run(startCountdown)
end

function rushmode.onDraw()
	if texttimer1 then
		Text.printWP("Get to the end of the level in", 150, 300, -1)
		Text.printWP(Timer.getValue().." seconds!", 150, 320, -1)
	end
	if gotext then
		Text.printWP("GO!", 350, 400, -1)
	end
end

function rushmode.onExit()
	GameData.rushModeActive = false
	if Level.endState() > 0 then
		Level.load(GameData.rushlevelsrng[selecter2], nil, nil)
	end
end

return rushmode