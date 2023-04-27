local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Item Get!" then
        smasMapInventorySystem.addPowerUp(6, 1)
        Sound.playSFX("chest.ogg")
        SFX.play("_OST/Super Mario Bros 3/Battle Mode Win.ogg")
    end
    if eventName == "End Level" then
        Level.load("map.lvlx")
    end
end