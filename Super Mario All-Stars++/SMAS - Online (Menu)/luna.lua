local mleb = require("multilayeredearthboundbg")
Graphics.activateHud(false)
local title = Graphics.loadImage("title-final-2x.png")

mleb.addShaderSection(0, {
        texture = bg_example,
        interlace = 4,
        interlaceIntensity = 2,
        animationPhase = -0.533,
        animationSpeed = 0.5,
        verticalWobble = 0.1,
        oscillationAmplitude = 0.1,
        oscillationFrequency = 0.2,
        move = vector(0, 0),
        iFrequency = 0.1,
        iAmplitude = 0.158,
        tint=Color.blue,
        distortion = vector(0.1, 0),
       -- palette = bg_example_palB,
        paletteHeight = 2,
})

mleb.addShaderSection(0, {
        texture = bg_example,
        interlace = 4,
        interlaceIntensity = 2,
        animationPhase = 0.33,
        animationSpeed = 0.25,
        verticalWobble = 0.4,
        tint=Color.red,
        oscillationAmplitude = 0.1,
        oscillationFrequency = 0.2,
        move = vector(0, 0),
        iFrequency = -0.2,
        iAmplitude = 0.158,
        distortion = vector(0, 0),
        --palette = loadImage("bg_example_palA"),
        paletteHeight = 2,
})

mleb.addShaderSection(0, {
        texture = title,
        interlace = 2,
        interlaceIntensity = 2,
        animationPhase = 2,
        animationSpeed = 0.78,
        verticalWobble = 0.05,
        oscillationAmplitude = 0.1,
        oscillationFrequency = 0.4,
        move = vector(0, 0),
        iFrequency = 0.2,
        iAmplitude = 0.28,
        distortion = vector(0, 0),
    })
	
function onTick()
	player:setFrame(50)
	player:mem(0x140, FIELD_BOOL, 150)
	if player:mem(0x140, FIELD_BOOL) == 0 then
		player:mem(0x140, FIELD_BOOL, 150)
	end
end