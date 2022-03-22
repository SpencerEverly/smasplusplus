local smallScreen = {}


local crispShader = Shader()
crispShader:compileFromFile("scripts/shaders/crisp.vert", "scripts/shaders/crisp.frag")


function smallScreen.onInitAPI()
    registerEvent(smallScreen,"onCameraUpdate")
    registerEvent(smallScreen,"onCameraDraw")
end

local buffer = Graphics.CaptureBuffer(800,600)
function smallScreen.onCameraDraw()
    if not smallScreen.croppingEnabled then return end

    
    buffer:captureAt(smallScreen.priority)

    local width  = smallScreen.width *smallScreen.scaleX
    local height = smallScreen.height*smallScreen.scaleY

    local borderColor = Color.black
    if Misc.inEditor() and Misc.GetKeyState(VK_B) then
        borderColor = borderColor.. 0.4
    end

    local linearFiltered = false
    local shader,uniforms

    if smallScreen.useCrispShader and (smallScreen.scaleX ~= 1 or smallScreen.scaleY ~= 1) then
        shader = crispShader
        uniforms = {inputSize = {camera.width,camera.height},crispScale = {camera.width/smallScreen.width,camera.height/smallScreen.height}}
        linearFiltered = true
    end

    Graphics.drawScreen{priority = smallScreen.priority,color = borderColor}
    Graphics.drawBox{
        texture = buffer,priority = smallScreen.priority,
        linearFiltered = linearFiltered,shader = shader,uniforms = uniforms,
        
        x = (buffer.width*0.5)+smallScreen.offsetX,y = (buffer.height*0.5)+smallScreen.offsetY,centred = true,
        width = width,height = height,sourceWidth = smallScreen.width,sourceHeight = smallScreen.height,
        sourceX = (buffer.width*0.5)-(smallScreen.width*0.5),sourceY = (buffer.height*0.5)-(smallScreen.height*0.5),
    }
end

function smallScreen.onCameraUpdate()
    if not smallScreen.positionChangingEnabled then return end


    local b = player.sectionObj.boundary

    local widthDifference = ((camera.width-smallScreen.width)*0.5)
    camera.x = math.clamp(player.x+(player.width*0.5)-(camera.width*0.5),b.left-widthDifference,b.right+widthDifference-camera.width)

    local heightDifference = ((camera.height-smallScreen.height)*0.5)
    camera.y = math.clamp(player.y+player.height-(camera.height*0.5),b.top-heightDifference,b.bottom+heightDifference-camera.height)
end



smallScreen.width = 800
smallScreen.height = 600

smallScreen.scaleX = 1
smallScreen.scaleY = 1

smallScreen.offsetX = 0
smallScreen.offsetY = 0

smallScreen.priority = 15

smallScreen.croppingEnabled = true
smallScreen.positionChangingEnabled = true
smallScreen.editSectionBounds = true

smallScreen.useCrispShader = true


return smallScreen