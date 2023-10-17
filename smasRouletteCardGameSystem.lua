local smasRouletteCardGameSystem = {}

smasRouletteCardGameSystem.currentRouletteGames = {}
smasRouletteCardGameSystem.currentCardGames = {}

smasRouletteCardGameSystem.randomRNGNumber = RNG.randomInt()
smasRouletteCardGameSystem.randomRNGNumber2 = RNG.randomInt()
smasRouletteCardGameSystem.randomRNGNumber3 = RNG.randomInt()

function smasRouletteCardGameSystem.startRouletteGame(sectionID)
    table.insert(smasRouletteCardGameSystem.currentRouletteGames, {
        
    })
end

function smasRouletteCardGameSystem.onInitAPI()
    registerEvent(smasRouletteCardGameSystem,"onDraw")
end

function smasRouletteCardGameSystem.onDraw()
    
end

return smasRouletteCardGameSystem