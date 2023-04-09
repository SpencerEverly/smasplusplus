local lazyprint = {}
local textplus = require("textplus")


--[[
QUICK & DIRTY DEBUG PRINTING LIB
To save yourself a dozen Text.print calls
by Enjl
                                            
v0.0.1                                    
                                            
ADDED:    2022-09-02                  
UPDATED:  2022-09-02

(someone please de-rixify this library!!)
--]]



--[[ lazyprint.printPairs args:

        values
            key/value pair table
            the properties to monitor

        position
            vector2 (optional, default (0,0) )
            the position to draw the debug monitor at

        x
            number
            the x position to draw the debug monitor at

        y
            number
            the y position to draw the debug monitor at

        keyWidth
            number (optional, default 180)
            the width of the key column

        valueWidth
            number (optional, default 20)
            the width of the value column

        priority
            number (optional, default 0)
            the priority to draw the debug monitor at
--]]

local monitoredMap = {}
local monitoredObjects = {}

local autoUnmonitorList = {}

function lazyprint.monitor(object, keys)
    if monitoredMap[object] then
        monitoredMap[object] = table.append(monitoredMap[object], keys)
    else
        monitoredMap[object] = keys
        table.insert(monitoredObjects, object)
    end
end

function lazyprint.stopMonitoring(object)
    if monitoredMap[object] then
        monitoredMap[object] = nil
        for k,v in ipairs(monitoredObjects) do
            if v == object then
                table.remove(monitoredObjects, k)
            end
        end
    end
end

function lazyprint.print(object, keys)
    lazyprint.monitor(object, keys)
    table.insert(autoUnmonitorList, object)
end

function lazyprint.onDraw()
    if smasVerboseMode.activated then
        local xOffset = 0
        local yOffset = 0
        local padX = 4
        local padY = 4

        local maxWidth = 140

        local lastColumnWidth = 0

        for k,v in ipairs(monitoredObjects) do
            local objKeys = monitoredMap[v]

            local layouts = {}
            local currentYOffset = 0

            local estimatedHeight = 0

            for idx, value in ipairs(objKeys) do
                local l = textplus.layout(textplus.parse(value), maxWidth)
                table.insert(layouts, l)

                estimatedHeight = estimatedHeight + l.height
            end

            local resetColumn = false

            if yOffset + estimatedHeight > 600 then
                xOffset = xOffset + lastColumnWidth
                yOffset = 0
                lastColumnWidth = 0
                resetColumn = true
            end

            for idx, value in ipairs(objKeys) do
                local layout = textplus.layout(textplus.parse(tostring(v[value])), maxWidth)

                textplus.render{
                    x = xOffset + padX,
                    y = yOffset + padY + currentYOffset,
                    color = Color.white,
                    priority = 0,
                    layout = layouts[idx]
                }

                textplus.render{
                    x = xOffset + padX + maxWidth - layout.width,
                    y = yOffset + padY + currentYOffset,
                    color = Color.white,
                    priority = 0,
                    layout = layout
                }

                currentYOffset = currentYOffset + math.max(layout.height, layouts[idx].height) + 2

                lastColumnWidth = math.max(lastColumnWidth, maxWidth + 6 + 2 * padX + 6)
            end

            Graphics.drawBox{
                x=xOffset,
                y=yOffset,
                width= maxWidth + 2 * padX,
                height = currentYOffset + 2 * padY,
                color = Color.alphablack .. (0.35),
                priority = -1,
            }

            yOffset = yOffset + currentYOffset + padY * 6
        end

        -- local position = vector.zero2
        -- local position = args.position  or  vector.zero2
        -- local priority = args.priority  or  0
        -- local keyWidth = args.keyWidth  or  180
        -- local valueWidth = args.valueWidth  or  20 

        -- local i = 0
        -- for  k,v in pairs (args.values)  do

        --     local x = (args.x  or  position.x)
        --     local y = (args.y  or  position.y) + 12*i
        --     textplus.print{
        --         x = x,
        --         y = y,
        --         color = Color.white,
        --         text = tostring(k),
        --         priority = priority+0.001
        --     }
        --     i = i+1
        --     textplus.print{
        --         x = x + keyWidth,
        --         y = y,
        --         color = Color.white,
        --         text = tostring(v),
        --         pivot = vector(1,0),
        --         priority = priority+0.001
        --     }
        -- end

        for k,v in ipairs(autoUnmonitorList) do
            lazyprint.stopMonitoring(v)
        end

        autoUnmonitorList = {}
    end
end

function lazyprint.onInitAPI()
    registerEvent(lazyprint, "onDraw")
end    



return lazyprint