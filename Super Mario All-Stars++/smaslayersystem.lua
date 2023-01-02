local smaslayersystem = {}

smaslayersystem.layers = {}
smaslayersystem.layerIsHidden = {}

function smaslayersystem.onInitAPI()
    registerEvent(smaslayersystem,"onStart")
    registerEvent(smaslayersystem,"onDraw")
end

function smaslayersystem.createLayer(layerName,isHidden)
    if layerName == nil then
        error("You must have a layer name!")
        return
    end
    if isHidden == nil then
        error("You must specifiy to make it hidden or not!")
        return
    end
    
    table.insert(smaslayersystem.layers, layerName)
    table.insert(smaslayersystem.layerIsHidden, isHidden)
end

function smaslayersystem.showLayer(layer)
    if (type(layer) ~= "string") then
        error("The layer must be a string!")
        return
    end
    if layer ~= nil then --If not nil...
        local foundLayer = table.ifind(smaslayersystem.layers, layer) --The name ID will then be added here.
        if foundLayer == nil then --But if nil...
            error("Layer wasn't found! You need to specify a valid layer.") --Error and return it
            return
        else --Or if not...
            smaslayersystem.layerIsHidden[foundLayer] = false --Change the status of the layer to show it
        end
    else
        error("Nothing is specified on the layer name!")
        return
    end
end

function smaslayersystem.hideLayer(layer)
    if (type(layer) ~= "string") then
        error("The layer must be a string!")
        return
    end
    if layer ~= nil then --If not nil...
        local foundLayer = table.ifind(smaslayersystem.layers, layer) --The name ID will then be added here.
        if foundLayer == nil then --But if nil...
            error("Layer wasn't found! You need to specify a valid layer.") --Error and return it
            return
        else --Or if not...
            smaslayersystem.layerIsHidden[foundLayer] = true --Change the status of the layer to show it
        end
    else
        error("Nothing is specified on the layer name!")
        return
    end
end

function smaslayersystem.onStart()
    smaslayersystem.createLayer("Default",false)
end

function smaslayersystem.onDraw()
    --[[for k,v in ipairs(smaslayersystem.layers) do
        if smaslayersystem.layerIsHidden[k] then
            
        elseif not smaslayersystem.layerIsHidden[k] then
            
        end
    end]]
end

return smaslayersystem