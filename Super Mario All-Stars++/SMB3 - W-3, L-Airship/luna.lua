local level_dependencies_normal= require("level_dependencies_normal")

local inventory = require("customInventory")
local autoscroll = require("autoscroll")
local airshipScroll = require("airshipScroll")

function onLoadSection2()
    autoscrolla.scrollRight(1)
end