local smasResolutions = {}

local CRTShader = Shader()
local filterBuffer = Graphics.CaptureBuffer(800,600)

function smasResolutions.onInitAPI()
    registerEvent(smasResolutions,"onDraw")
end

function smasResolutions.onDraw()
    if SaveData.SMASPlusPlus.options.enableCRTFilter then
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
            if not CRTShader._isCompiled then
                CRTShader:compileFromFile(nil, "shaders/crt.frag")
            end
            filterBuffer:captureAt(10)
            Graphics.drawScreen{texture = filterBuffer, shader = CRTShader, uniforms = {iResolution = vector.v3(800,600)}, priority = 10}
        end
    end
end

return smasResolutions