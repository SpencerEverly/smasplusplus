local smasLayerSystem = {}

smasLayerSystem.layers = {}
smasLayerSystem.layerIsHidden = {}

function smasLayerSystem.onInitAPI()
    registerEvent(smasLayerSystem,"onStart")
    registerEvent(smasLayerSystem,"onDraw")
end

function smasLayerSystem.createLayer(layerName,isHidden)
    if layerName == nil then
        error("You must have a layer name!")
        return
    end
    if isHidden == nil then
        error("You must specifiy to make it hidden or not!")
        return
    end
    
    table.insert(smasLayerSystem.layers, layerName)
    table.insert(smasLayerSystem.layerIsHidden, isHidden)
end

function smasLayerSystem.showLayer(layer)
    if (type(layer) ~= "string") then
        error("The layer must be a string!")
        return
    end
    if layer ~= nil then --If not nil...
        local foundLayer = table.ifind(smasLayerSystem.layers, layer) --The name ID will then be added here.
        if foundLayer == nil then --But if nil...
            error("Layer wasn't found! You need to specify a valid layer.") --Error and return it
            return
        else --Or if not...
            smasLayerSystem.layerIsHidden[foundLayer] = false --Change the status of the layer to show it
        end
    else
        error("Nothing is specified on the layer name!")
        return
    end
end

function smasLayerSystem.hideLayer(layer)
    if (type(layer) ~= "string") then
        error("The layer must be a string!")
        return
    end
    if layer ~= nil then --If not nil...
        local foundLayer = table.ifind(smasLayerSystem.layers, layer) --The name ID will then be added here.
        if foundLayer == nil then --But if nil...
            error("Layer wasn't found! You need to specify a valid layer.") --Error and return it
            return
        else --Or if not...
            smasLayerSystem.layerIsHidden[foundLayer] = true --Change the status of the layer to show it
        end
    else
        error("Nothing is specified on the layer name!")
        return
    end
end

function smasLayerSystem.onStart()
    smasLayerSystem.createLayer("Default",false)
end

function smasLayerSystem.onDraw()
    --[[for k,v in ipairs(smasLayerSystem.layers) do
        if smasLayerSystem.layerIsHidden[k] then
            
        elseif not smasLayerSystem.layerIsHidden[k] then
            
        end
    end]]
end

return smasLayerSystem