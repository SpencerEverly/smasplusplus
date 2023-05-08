local smasCharacterHealthSystem = {}

--If enabled or not.
smasCharacterHealthSystem.enabled = false
--The health to start the character with on each level.
smasCharacterHealthSystem.defaultStartingHealth = 2

function smasCharacterHealthSystem.onInitAPI()
    registerEvent(smasCharacterHealthSystem,"onPlayerHarm")
    registerEvent(smasCharacterHealthSystem,"onDraw")
end

return smasCharacterHealthSystem