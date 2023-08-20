local smasResolutions = {}

local CRTShader = Shader()
local filterBuffer = Graphics.CaptureBuffer(800,600)

function smasResolutions.onInitAPI()
    registerEvent(smasResolutions,"onStart")
    registerEvent(smasResolutions,"onDraw")
end

function smasResolutions.changeCRTSetting(onMainMenu)
    if onMainMenu == nil then
        onMainMenu = false
    end
    Routine.run(function()
        SaveData.SMASPlusPlus.options.enableCRTFilter = not SaveData.SMASPlusPlus.options.enableCRTFilter
        Routine.waitFrames(1, true)
        if onMainMenu then
            if SaveData.SMASPlusPlus.options.enableCRTFilter then
                SaveData.pauseplus.selectionData["screensettings"]["enable crt display"] = true
            else
                SaveData.pauseplus.selectionData["screensettings"]["enable crt display"] = false
            end
        end
    end)
end

function smasResolutions.changeResolution(onMainMenu)
    if onMainMenu == nil then
        onMainMenu = false
    end
    if SMBX_VERSION == VER_SEE_MOD then
        Routine.run(function()
            Routine.waitFrames(1, true)
            if SaveData.SMASPlusPlus.options.resolution == "fullscreen" then
                Screen.changeResolution(800,600)
                if onMainMenu then
                    SaveData.pauseplus.selectionData["screensettings"]["switch resolution"] = 1
                end
            elseif SaveData.SMASPlusPlus.options.resolution == "widescreen" then
                Screen.changeResolution(1066,600)
                if onMainMenu then
                    SaveData.pauseplus.selectionData["screensettings"]["switch resolution"] = 2
                end
            elseif SaveData.SMASPlusPlus.options.resolution == "ultrawide" then
                Screen.changeResolution(1424,600)
                if onMainMenu then
                    SaveData.pauseplus.selectionData["screensettings"]["switch resolution"] = 3
                end
            elseif SaveData.SMASPlusPlus.options.resolution == "steamdeck" then
                Screen.changeResolution(960,600)
                if onMainMenu then
                    SaveData.pauseplus.selectionData["screensettings"]["switch resolution"] = 4
                end
            else
                Screen.changeResolution(800,600)
                if onMainMenu then
                    SaveData.pauseplus.selectionData["screensettings"]["switch resolution"] = 1
                end
            end
        end)
    end
end

function smasResolutions.onStart()
    smasResolutions.changeResolution()
end

function smasResolutions.onDraw()
    --CRT Filter
    if SaveData.SMASPlusPlus.options.enableCRTFilter then
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
            if SMBX_VERSION == VER_SEE_MOD then
                if (filterBuffer.width ~= camera.width or filterBuffer.height ~= camera.height) then
                    filterBuffer = Graphics.CaptureBuffer(camera.width, camera.height)
                end
            end
            if not CRTShader._isCompiled then
                CRTShader:compileFromFile(nil, "shaders/crt.frag")
            end
            filterBuffer:captureAt(10)
            Graphics.drawScreen{texture = filterBuffer, shader = CRTShader, uniforms = {iResolution = vector.v3(Screen.getScreenSize()[1],Screen.getScreenSize()[2])}, priority = 10}
        end
    end
end

return smasResolutions