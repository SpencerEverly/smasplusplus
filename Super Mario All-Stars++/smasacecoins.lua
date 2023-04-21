local smasAceCoins = {}

if SaveData.SMASPlusPlus.levels.complete.dragonCoins == nil then
    SaveData.SMASPlusPlus.levels.complete.dragonCoins = {}
end
if SaveData.SMASPlusPlus.levels.complete.aceCoins == nil then
    SaveData.SMASPlusPlus.levels.complete.aceCoins = {}
end

function smasAceCoins.onInitAPI()
    registerEvent(smasAceCoins,"onStart")
    registerEvent(smasAceCoins,"onTick")
end

smasAceCoins.dragonCoinIndex = {}
smasAceCoins.totalDragonCoins = 0
smasAceCoins.allDragonCoinsCollected = false

function smasAceCoins.onStart()
    NPC.config[274].score = 6
    for k,v in ipairs(NPC.get(274)) do
        smasAceCoins.totalDragonCoins = smasAceCoins.totalDragonCoins + 1
        smasAceCoins.dragonCoinIndex[smasAceCoins.totalDragonCoins] = {
            npcData = v,
            x = v.x,
            y = v.y,
            collected = false,
        }
    end
end

function smasAceCoins.checkDragonCoinStatus(isAceCoin)
    if isAceCoin == nil then
        isAceCoin = false
    end
    if NPC.config[274].score == 11 then
        if isAceCoin then
            Sound.playSFX(147)
        end
        if not smasAceCoins.allDragonCoinsCollected then
            if isAceCoin then
                if not table.icontains(SaveData.SMASPlusPlus.levels.complete.dragonCoins,Level.filename()) then
                    table.insert(SaveData.SMASPlusPlus.levels.complete.dragonCoins, Level.filename())
                end
            else
                if not table.icontains(SaveData.SMASPlusPlus.levels.complete.aceCoins,Level.filename()) then
                    table.insert(SaveData.SMASPlusPlus.levels.complete.aceCoins, Level.filename())
                end
            end
            smasAceCoins.allDragonCoinsCollected = true
        end
        NPC.config[274].score = 6
    end
end

function smasAceCoins.onTick()
    if table.icontains(smasTables.__smb2Levels,Level.filename()) then
        smasAceCoins.checkDragonCoinStatus(true)
    else
        smasAceCoins.checkDragonCoinStatus(false)
    end
    for _,p in ipairs(Player.get()) do
        for i = 1,smasAceCoins.totalDragonCoins do
            if not smasAceCoins.dragonCoinIndex[i].collected and Colliders.collide(p, smasAceCoins.dragonCoinIndex[i].npcData) then
                smasAceCoins.dragonCoinIndex[i].collected = true
            end
        end
    end
end

return smasAceCoins