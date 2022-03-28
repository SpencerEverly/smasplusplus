local inputconfigurator = {}

function inputconfigurator.onInitAPI()
	registerEvent(inputconfigurator, "onKeyboardPressDirect")
	registerEvent(inputconfigurator, "onDraw")
	registerEvent(inputconfigurator, "onControllerButtonPress")
	registerEvent(inputconfigurator, "onTick")
	registerEvent(inputconfigurator, "onInputUpdate")
	registerEvent(inputconfigurator, "onStart")
	registerEvent(inputconfigurator, "onExit")
	
	ready = true
end

inputconfigurator.controlConfigOpen = false
local controlConfigCount = 0
local controlConfigs = { 	[0] = "Press any button to start",
							"Jump",
							"Run",
							"Alt Jump",
							"Alt Run",
							"Drop Item",
							"Pause",
							"Press any button to confirm"
						}
						
local configButtons = 	{	
							{ img = 0, pos = vector.v2(64, 14) },
							{ img = 0, pos = vector.v2(44, -6) },
							{ img = 0, pos = vector.v2(84, -6) },
							{ img = 0, pos = vector.v2(64, -26) },
							{ img = 1, pos = vector.v2(-34, 2) },
							{ img = 1, pos = vector.v2(-6, 2) }
						}
						
local currentController = nil
local currentConfig = {}

local function writeButtonConfigs()
	if currentController == nil then
		return
	else
		local t = nil
		
		if currentController[2] == 2 then
			t = inputConfig2
		else
			t = inputConfig1
		end
		
		if t.inputType == 0 then
			return
		else
			t.jump = currentConfig[1]
			t.run = currentConfig[2]
			t.altjump = currentConfig[3]
			t.altrun = currentConfig[4]
			t.dropitem = currentConfig[5]
			t.pause = currentConfig[6]
			currentConfig = {}
		end
	end
end

function inputconfigurator.onKeyboardPressDirect(k, repeated)
	if repeated then return end
	
	if (k == VK_RETURN) then
		inputconfigurator.returnPressedState = true
	elseif (k == VK_BACKSPACE) then
		inputconfigurator.backspacePressedState = true
	end
end

function inputconfigurator.onControllerButtonPress(btn, pnum, controller)
	if inputconfigurator.controlConfigOpen then
		if controlConfigCount == 0 then
			currentController = { controller, pnum }
			controlConfigCount = 1
			return
		elseif currentController == nil then
			currentController = { controller, pnum }
		end
		
		if currentController[1] == controller and currentController[2] == pnum then
			if controlConfigCount < #controlConfigs then
				currentConfig[controlConfigCount] = btn
				controlConfigCount = controlConfigCount + 1
			else
				inputconfigurator.controlConfigOpen = false
				Audio.playSFX(20)
				writeButtonConfigs()
				lockSelect = true
			end
		end
	end
end

function inputconfigurator.onDraw()
	if inputconfigurator.controlConfigOpen then
		
		local w = 400
		local h = 256
		
		local xPos = 400 - w*0.5
		local yPos = 300 - h*0.5
		
		Graphics.drawBox{x = xPos, y = yPos - 20, width = w, height = h, color={0,0,0,0.5}, priority = 10}
		Graphics.drawImageWP(Graphics.sprites.hardcoded["57-0"].img, 400 - 128, 300 - 64 - 40, 10)
		
		textPrintCentered("Controller Configurator", 400, yPos + 10)
		
		textPrintCentered(controlConfigs[controlConfigCount], 400, yPos + 160)
		
		if configButtons[controlConfigCount] then
			local v = configButtons[controlConfigCount]
			Graphics.drawImageWP(Graphics.sprites.hardcoded["57-1"].img, 400 + v.pos.x, 300-40 + v.pos.y, 0, 20*v.img, 20, 20, 10)
		end
		
		textPrintCentered("Press Backspace to cancel", 400, yPos + 210)
		
		if escPressedState then
			inputconfigurator.controlConfigOpen = false
			Audio.playSFX(30)
		end
	end
	inputconfigurator.returnPressedState = false
	escPressedState = false
end

return inputconfig