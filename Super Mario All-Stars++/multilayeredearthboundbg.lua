--[[
MLEB by Enjl V1.0

This library lets you define backgrounds for a section using an earthbound bg shader.
You can add an arbitrary number of layers for each section.

The entrypoint is mleb.addShaderSection(
    section (number or table of section indices),
    args (named)
)

Available args:
            args.texture or nil, -- Texture of the backround effect
            args.verticalWobble or 0, -- Multiplier for the background's vertical wobbling
            args.distortion or vector(0,0) -- Horizontal and vertical wobble distortion multipliers
            args.frequency or 0, -- Frequency of sine wave movements
            args.amplitude or 0, -- Amplitude of sine wave movements
            args.move or vector(0,0), -- SpeedX and SpeedY of the background layer image
            args.tint or Color.white, -- Background color tint value
            args.interlace or 2, -- If interlaceIntensity is set, this determines the interlace interval
            args.interlaceIntensity or 1, -- Determines the strength of the interlacing effect. Disabled if unset.
            args.animationPhase or 0, -- Offsets the animation
            args.animationSpeed or 1, -- Speed multiplier for the animation
            args.oscillationAmplitude or nil, -- Vertical oscillation frequency
            args.oscillationFrequency or nil, -- Vertical oscillation amplitude
            args.palette or nil, -- Texture for the palette. See example texture to see what the layout should be (a color strip with time on the x axis and the starting colors on the left)
            args.paletteSpeed or 1, -- Speed of palette animation cycling
            args.paletteHeight or 0 -- Height of the palette texture in pixels

Example usage (copy into luna.lua)

local mleb = require("multilayeredearthboundbg")

local bg_example = Graphics.loadImage("bg_example.png")
local bg_example_palA = Graphics.loadImage("bg_example_palette_1.png")
local bg_example_palB = Graphics.loadImage("bg_example_palette_2.png")

-- The backgrounds are rendered in order of being added.

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
        tint=Color.purple,
        distortion = vector(0.1, 0),
        palette = bg_example_palB,
        paletteHeight = 2,
})

mleb.addShaderSection(0, {
        texture = bg_example,
        interlace = 4,
        interlaceIntensity = 2,
        animationPhase = 0.33,
        animationSpeed = 0.25,
        verticalWobble = 0.4,
        tint=Color.darkred,
        oscillationAmplitude = 0.1,
        oscillationFrequency = 0.2,
        move = vector(0, 0),
        iFrequency = -0.2,
        iAmplitude = 0.158,
        distortion = vector(0, 0),
        palette = loadImage("bg_example_palA"),
        paletteHeight = 2,
})
]]

local mleb = {}

local newbg = Shader()
newbg:compileFromFile(nil, Misc.resolveFile("earthbound.frag"))

local sectionBackgrounds = {}
for i=0, 20 do
    sectionBackgrounds[i] = {}
end

local function getT()
    return lunatime.drawtick() * 0.005
end

function mleb.addShaderSection(sections, args)
    args.distortion = args.distortion or {}

    local i2 = 0
    if args.interlaceIntensity then i2 = 1 end
    args.move = args.move or {}

    local vW = 0
    if args.verticalWobble then vW = 1 end
    local e = {
        texture = args.texture,
        uniforms = {
            iDistortion = args.verticalWobble or 0,
            iDistortionX = args.distortion.x or 0,
            iDistortionY = args.distortion.y or 0,
            iFrequency = args.frequency or 0,
            iAmplitude = args.amplitude or 0,
            iMoveX = args.move.x or 0,
            iMoveY = args.move.y or 0,
            iTime = 0,
            iTint = args.tint or Color.white,
            iOffset = vector.zero2,
            iInterlacingOn = i2,
            iInterlace2 = args.interlace or 2,
            iInterlaceSize = args.interlaceIntensity or 1,
            iAnimationPhase = args.animationPhase or 0,
            iAnimationSpeed = args.animationSpeed or 1,
            iVerticalWobbleOn = vW,
            iOscillationYAmplitude = args.oscillationAmplitude,
            iOscillationYFrequency = args.oscillationFrequency,
            iPalette = args.palette,
            iPaletteSpeed = args.paletteSpeed or 1,
            iPaletteHeight = args.paletteHeight or 0
        }
    }

    if type(sections) == "number" then
        sections = {sections}
    end
    for k,v in ipairs(sections) do
        table.insert(sectionBackgrounds[v], e)
    end
    return e
end

function mleb.onDraw()
    if sectionBackgrounds[player.section] then
        local shaderSec = sectionBackgrounds[player.section]
        Graphics.drawScreen{color = Color.black, priority = -100}
        for k,v in ipairs(shaderSec) do
            v.uniforms.iTime = getT()
            --v.uniforms.offset = camOffset
            Graphics.drawScreen{
                shader = newbg,
                texture = v.texture,
                priority = -100 + 0.01 * k + 0.003,
                uniforms = v.uniforms
            }
        end
    end
end

registerEvent(mleb, "onDraw")

return mleb