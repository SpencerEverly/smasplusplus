local Liquidz = {}

function Liquidz.spawn(x, y, width, height, quicksand, layerName, isHidden)
    if layerName == nil then
        layerName = "Default"
    end
    if isHidden == nil then
        isHidden = false
    end
    writemem(0x00B25700, FIELD_WORD, Liquid.count() + 1)
    local newLiquid = Liquid(Liquid.count())

    newLiquid.layerName = layerName
    newLiquid.isHidden = isHidden
    writemem(newLiquid._ptr + 0x08, FIELD_FLOAT, 0) -- buoyancy
    if quicksand then
        newLiquid.isQuicksand = true
    else
        newLiquid.isQuicksand = false
    end
    newLiquid.x = x
    newLiquid.y = y
    newLiquid.width = width
    newLiquid.height = height
    newLiquid.speedX = 0
    newLiquid.speedY = 0
      
    return newLiquid
end

return Liquidz