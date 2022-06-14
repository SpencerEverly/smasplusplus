local level_dependencies_normal= require("level_dependencies_normal")

local inventory = require("customInventory")

local littleDialogue = require("littleDialogue")

littleDialogue.typewriterEnabled = true

local autoscroll = require("autoscroll")

local airshipScroll = require("airshipScroll")

function onLoadSection2()
    autoscroll.scrollRight(1)
end