local level_dependencies_normal= require("level_dependencies_normal")

local inventory = require("customInventory")
local autoscroll = require("autoscroll")
local airshipScroll = require("airshipScroll")

function onLoadSection2()
    autoscroll.scrollRight(1)
end

function onEvent(eventName)
    if eventName == "Airship Begin" then
        Sound.playSFX(27)
    end
    if eventName == "Door Appear" then
        Sound.playSFX(20)
    end
end