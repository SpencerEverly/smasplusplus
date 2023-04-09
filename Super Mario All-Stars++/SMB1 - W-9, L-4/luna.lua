local level_dependencies_normal= require("level_dependencies_normal")

function onLoadSection0()
    smasNoTurnBack.overrideSection = true
end

function onLoadSection1()
    smasNoTurnBack.overrideSection = false
end