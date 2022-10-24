local lavaSystem = {}

lavaSystem.ids = {}

function lavaSystem.register(npcID)
    table.insert(lavaSystem.ids, npcID)
end

function lavaSystem.onInitAPI()
    registerEvent(lavaSystem,"onTick")
end

function lavaSystem.onTick()
    if Cheats.get("lavaplayer").active then
        for k,v in ipairs(lavaSystem.ids) do
            Block.config[v].setLavaKill = false
            Block.config[v].passthrough = true
            local lavaSwimLayer = Layer.get("Lava Swimmable")
            if lavaSwimLayer ~= nil then
                lavaSwimLayer:show(true)
            end
        end
    elseif not Cheats.get("lavaplayer").active then
        for k,v in ipairs(lavaSystem.ids) do
            Block.config[v].setLavaKill = true
            Block.config[v].passthrough = false
            local lavaSwimLayer = Layer.get("Lava Swimmable")
            if lavaSwimLayer ~= nil then
                lavaSwimLayer:hide(true)
            end
        end
    end
end

return lavaSystem