local level_dependencies_normal= require("level_dependencies_normal")

function onLoadSection1()
    Defines.gravity = Defines.gravity - 9
    Defines.jumpheight = Defines.jumpheight + 10
end

function onLoadSection0()
    Defines.gravity = nil
    Defines.jumpheight = nil
end