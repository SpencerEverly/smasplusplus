local level_dependencies_normal= require("level_dependencies_normal")

local flipperino = require("flipperino")
local littleDialogue = require("littleDialogue")

function onEvent(eventName)
    if eventName == "Path Message 2" then
        littleDialogue.create({text = "Which path shall you take?<page>One path will lead to 2-A, the other one will lead to 2-Tower.<page>Make your choice...!", pauses = true})
    end
    if eventName == "flip" then
        SFX.play("ender_portal.ogg")
    end
    if eventName == "flipNormal" then
        SFX.play("ender_portal.ogg")
    end
end