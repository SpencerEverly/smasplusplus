local textplus = require("textplus")

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

local smbx13font = textplus.loadFont("littleDialogue/smbx13/font.ini")
local lockSelect = false
inputconfigurator.controlConfigOpen = false

local controlConfigCount = 0
local controlConfigs = { 	[0] = "Press any button to start.",
							"Press a key to assign Jump.",
							"Press a key to assign Run.",
							"Press a key to assign Alt Jump.",
							"Press a key to assign Alt Run.",
							"Press a key to assign Drop Item.",
							"Press a key to assign Pause.",
							"Press any button to confirm."
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
		inputconfigurator.nocontroller = false
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
	
	if inputconfigurator.controlConfigOpen then
		if (k == VK_BACK) then
			inputconfigurator.backspacePressedState = true
			playSound("inputconfig/input_quit.ogg")
			inputconfigurator.controlConfigOpen = false
			GameData.reopenmenu = true
		end
	end
end

function inputconfigurator.onControllerButtonPress(btn, pnum, controller)
	if inputconfigurator.controlConfigOpen then
		if controlConfigCount == 0 then
			currentController = { controller, pnum }
			controlConfigCount = 1
			playSound("inputconfig/input_started.ogg")
			return
		elseif currentController == nil then
			currentController = { controller, pnum }
			inputconfigurator.nocontroller = true
		end
		
		if currentController[1] == controller and currentController[2] == pnum then
			inputconfigurator.nocontroller = false
			if controlConfigCount < #controlConfigs then
				currentConfig[controlConfigCount] = btn
				playSound("inputconfig/input_switchpressed.ogg")
				controlConfigCount = controlConfigCount + 1
			else
				inputconfigurator.controlConfigOpen = false
				playSound("inputconfig/input_success.ogg")
				writeButtonConfigs()
				lockSelect = true
				GameData.reopenmenu = true
			end
		end
	end
end

local function textPrint(t, x, y, color)
	textplus.print{text=t, x=x, y=y, plaintext=true, xscale=1, yscale=1, color=color, priority = -1, font = smbx13font}
end

local function textPrintCentered(t, x, y, color)
	textplus.print{text=t, x=x, y=y, plaintext=true, pivot=vector.v2(0.5,0.5), xscale=1, yscale=1, color=color, priority = -1, font = smbx13font}
end

function inputconfigurator.onDraw()
	if inputconfigurator.controlConfigOpen then
		
		local w = 580
		local h = 260
		
		local xPos = 400 - w*0.5
		local yPos = 300 - h*0.5
		
		Graphics.drawBox{x = xPos, y = yPos - 20, width = w, height = h, color={0,0,0,0.75}, priority = -2}
		Graphics.drawImageWP(Graphics.sprites.hardcoded["57-0"].img, 400 - 128, 300 - 64 - 40, -2)
		
		textPrintCentered("Controller Configurator", 400, yPos + -1)
		
		textPrintCentered(controlConfigs[controlConfigCount], 400, yPos + 160)
		
		if configButtons[controlConfigCount] then
			local v = configButtons[controlConfigCount]
			Graphics.drawImageWP(Graphics.sprites.hardcoded["57-1"].img, 400 + v.pos.x, 300-40 + v.pos.y, 0, 20*v.img, 20, 20, -2)
		end
		
		textPrintCentered("Press Backspace to cancel", 400, yPos + 210)
		
		if escPressedState then
			inputconfigurator.controlConfigOpen = false
			GameData.reopenmenu = true
		end
	end
	inputconfigurator.returnPressedState = false
	escPressedState = false
end

return inputconfigurator