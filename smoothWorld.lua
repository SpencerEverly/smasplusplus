smoothWorld = {}
if not isOverworld then return {} end
camera = Camera.get()[1]
x = 0
y = 0
frameCnt = 0
xToMove = 0.0
yToMove = 0.0
xPos = {0,0,0,0}
yPos = {0,0,0,0}
startMove = false

function onStart()
    x = camera.x
    y = camera.y  
end
oldX = 0
oldY = 0

function smoothWorld.onDraw()
    if startMove then
        frameCnt = frameCnt + 1
        camera.x = xPos[frameCnt]
        camera.y = yPos[frameCnt]
        x = camera.x
        y = camera.y
        if frameCnt >= 4 then
            frameCnt = 0
            startMove = false
        end
        return {}
    end
    if world.playerIsCurrentWalking then
        x = camera.x
        y = camera.y
        return nil
    end
    if (x == camera.x and y == camera.y) then
        oldX = camera.x
        oldY = camera.y
        return nil
    end
    xPos[1] = math.lerp(x,camera.x,0.25)
    yPos[1] = math.lerp(y,camera.y,0.25)
    xPos[2] = math.lerp(x,camera.x,0.50)
    yPos[2] = math.lerp(y,camera.y,0.50)
    xPos[3] = math.lerp(x,camera.x,0.75)
    yPos[3] = math.lerp(y,camera.y,0.75)
    xPos[4] = math.lerp(x,camera.x,1)
    yPos[4] = math.lerp(y,camera.y,1)
    x = camera.x
    y = camera.y
    camera.x = oldX
    camera.y = oldY
    startMove = true
end

function smoothWorld.onInitAPI()
    registerEvent(smoothWorld, "onDraw")
end
return smoothWorld