local level_dependencies_normal= require("level_dependencies_normal")
local screenFlip = require("screenFlip/screenFlip")

screenFlip.enabled = false

function onLoadSection0()
    screenFlip.enabled = true
    screenFlip.enabledfourway = false
    screenFlip.flipSpeed = 10
    screenFlip.flipDirection = 1
    screenFlip.flipDelay = 500
    screenFlip.warnBeforeFlip = true
end

function onLoadSection1()
    screenFlip.enabled = true
    screenFlip.enabledfourway = false
    screenFlip.flipSpeed = 10
    screenFlip.flipDirection = 1
    screenFlip.flipDelay = 450
    screenFlip.warnBeforeFlip = true
end

function onLoadSection2()
    screenFlip.enabled = false
    screenFlip.enabledfourway = false
end

function onLoadSection3()
    screenFlip.enabled = true
    screenFlip.enabledfourway = false
    screenFlip.flipSpeed = 10
    screenFlip.flipDirection = 1
    screenFlip.flipDelay = 350
    screenFlip.warnBeforeFlip = true
end

function onLoadSection4()
    screenFlip.enabled = false
    screenFlip.enabledfourway = false
end

function onEvent(eventName)
    if eventName == "Boss Start" then
        screenFlip.enabled = false
        screenFlip.enabledfourway = true
        screenFlip.flipSpeed = 10
        screenFlip.flipDirection = 1
        screenFlip.flipDelay = 400
        screenFlip.warnBeforeFlip = false
    end
    if eventName == "Boss End" then
        screenFlip.enabled = false
        screenFlip.enabledfourway = false
    end
end