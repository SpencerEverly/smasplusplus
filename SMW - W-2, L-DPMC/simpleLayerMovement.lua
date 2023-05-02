--[[

    simpleLayerMovement.lua
    by MrDoubleA


    -- GENERAL FUNCTIONS --

    To add a bit of layer movement, you can use 'slm.addLayer{arguments}'.
    Here's a list of arguments you can put in those brakets:

    name           Should be a string which is the name of the layer it should affect.

    movement       Should be a function (see below for a list of default ones) which controls the X and Y movement of the layer.
    speed          Should be a number which affects the speed of the layer.
    distance       Should be a number which affects how far the layer moves.

    points         Should be a table containing a list of 2D vectors to move to when using 'slm.MOVEMENT_POINTS' as the movement function.

    horizontalMovement,verticalMovement   Similar to 'movement', except it only affects the movement of the specified direction.
    horizontalSpeed,verticalSpeed         Similar to 'speed', except it only affects the speed of the specified direction.
    horizontalDistance,verticalDistance   Similar to 'distance', except it only affects the distance of the specified direction.


    There is also 'slm.removeLayer(layer name OR layer object)', which disables all the custom movement for the layer.
    In addition, if no arguments are provided, all layers will have their custom movement disabled.


    
    - MOVEMENT FUNCTIONS -

    Movement functions that affect X and Y movement:

    - slm.MOVEMENT_CIRCLE    Causes the layer to move around in a circular pattern.
    - slm.MOVEMENT_POINTS    Causes the layer to visit each point defined in its 'points' table.

    Movement functions that control either X or Y movement:

    - slm.MOVEMENT_COSINE    Causes the layer to move around in a cosine wave in the specified direction.
    - slm.MOVEMENT_SINE      Causes the layer to move around in a sine wave in the specified direction.
    - slm.MOVEMENT_LOOP      Causes the layer to move constantly in the specified direction, until it reaches its 'distance', at which points it goes back to its starting position.

]]

local slm = {}

slm.movementObjs = {}


-- Movement functions (which affect x OR y movement)
function slm.MOVEMENT_COSINE(v,offset,speed,distance) return math.cos(v.timer/speed)*distance end
function slm.MOVEMENT_SINE  (v,offset,speed,distance) return math.sin(v.timer/speed)*distance end
function slm.MOVEMENT_LOOP  (v,offset,speed,distance)
    if offset > distance then
        speed = -distance+speed
    end
    return speed
end

-- Movement functions (which affect x AND y movement)
function slm.MOVEMENT_CIRCLE(v,hSpeed,vSpeed,hDistance,vDistance) return math.cos(v.timer/hSpeed)*hDistance,math.sin(v.timer/vSpeed)*vDistance end
function slm.MOVEMENT_POINTS(v,hSpeed,vSpeed,hDistance,vDistance)
    if not v.points or #v.points == 0 then error("A 'points' property is required for slm.MOVEMENT_POINTS") end
    
    local x,y = v.points[v.currentPoint].x,v.points[v.currentPoint].y
    local angle = -math.atan2(y-v.offset.y,x-v.offset.x)

    if (math.abs(x-v.offset.x)+math.abs(y-v.offset.y)) < (hSpeed+vSpeed) then
        v.currentPoint = (v.currentPoint % #v.points) + 1
    end

    return (math.cos(angle)*hSpeed),-(math.sin(angle)*vSpeed)
end



function slm.onInitAPI()
    registerEvent(slm,"onTickEnd")
    registerEvent(slm,"onReset") -- rooms.lua support
end

local copyFromArgs = {"movement","speed","distance","horizontalMovement","horizontalSpeed","horizontalDistance","verticalMovement","verticalSpeed","verticalDistance","points"}

function slm.addLayer(args)
    if not args or not args.name then error("'name' is a required field for slm.addLayer.") end

    local v = {}

    -- Copy a few properties from the arguments into the object
    for _,w in ipairs(copyFromArgs) do
        v[w] = args[w]
    end

    v.layerName = args.name -- The actual layer object is defined later

    v.timer = 0
    v.offset = vector(0,0)

    v.currentPoint = 1 -- Used for point movement

    v.remove = false
    --v.madeAfterStart = (lunatime.tick() > 1) -- Used for rooms.lua reset

    table.insert(slm.movementObjs,v)

    return movementObj
end

function slm.removeLayer(name)
    if name and type(name) ~= "string" then name = (name.name or name.layerName) end

    for k,v in ipairs(slm.movementObjs) do
        if name == nil or v.layerName == name then
            v.remove = true
        end
    end
end

function slm.onReset(fromRespawn)
    for k,v in ipairs(slm.movementObjs) do
        if v.layerObj then
            v.timer = 0
            v.offset.x,v.offset.y = 0,0

            v.currentPoint = 1
        end
    end
end

function slm.onTickEnd()
    -- Remove movement objects that are set to be removed
    local k = 1
    while k <= #slm.movementObjs do
        local v = slm.movementObjs[k]

        if v.remove then
            table.remove(slm.movementObjs,k)
        else
            k = k + 1
        end
    end

    if Defines.levelFreeze or Layer.isPaused() then return end

    for k,v in ipairs(slm.movementObjs) do
        -- Get the layer object if we don't have it yet
        if not v.layerObj then
            v.layerObj = Layer.get(v.layerName)
        end
        if not v.layerObj then error("Could not find layer of name specified.") end

        v.timer = v.timer + 1

        if v.horizontalMovement then
            v.layerObj.speedX = v.horizontalMovement(v,v.offset.x,v.horizontalSpeed or v.speed or 48,v.horizontalDistance or v.distance or 1)
        end
        if v.verticalMovement then
            v.layerObj.speedY = v.verticalMovement(v,v.offset.y,v.verticalSpeed or v.speed or 48,v.verticalDistance or v.distance or 1)
        end
        if v.movement then
            v.layerObj.speedX,v.layerObj.speedY = v.movement(v,v.horizontalSpeed or v.speed or 48,v.verticalSpeed or v.speed or 48,v.horizontalDistance or v.distance or 1,v.verticalDistance or v.distance or 1)
        end

        v.offset.x = v.offset.x + v.layerObj.speedX
        v.offset.y = v.offset.y + v.layerObj.speedY
    end
end

return slm