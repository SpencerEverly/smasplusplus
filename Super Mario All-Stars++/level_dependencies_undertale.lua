if smasBooleans.isOnMainMenu then return end

local undertaledepends = {}

SaveData.frisk = SaveData.frisk or {}
SaveData.frisk.hp = SaveData.frisk.hp or 20
SaveData.frisk.hpMax = SaveData.frisk.hpMax or 20
SaveData.frisk.LV = SaveData.frisk.LV or 1
SaveData.frisk.killCount = SaveData.frisk.killCount or 0
SaveData.frisk.itemPockets = SaveData.frisk.itemPockets or {}
SaveData.frisk.genocidePhase = SaveData.frisk.genocidePhase or 0
SaveData.frisk.isNeutral = SaveData.frisk.isNeutral or false
SaveData.frisk.isPacifist = SaveData.frisk.isPacifist or true
SaveData.frisk.cantChangeCharacters = SaveData.frisk.cantChangeCharacters or false

local stats = require("Stats")
local playerManager = require("playerManager")
local textplus = require("textplus")
local megaluavania2 = require("megaluavania2")

function undertaledepends.onInitAPI()
    registerEvent(undertaledepends,"onTick")
    registerEvent(undertaledepends,"onDraw")
end

undertaledepends.killedAll = false

function delayedMusicChange(killedNPC)
    Sound.changeMusic("_OST/Undertale/mus_toomuch.ogg", -1)
end

function undertaledepends.onTick()
    if SaveData.currentCostume == "UNDERTALE-FRISK" then
        if #NPC.get(smasTables.allBaseGameKillableEnemyIDs) == 0 and not table.icontains(smasTables._friendlyPlaces,Level.filename()) and not undertaledepends.killedAll then
            Routine.run(delayedMusicChange, killedNPC)
            undertaledepends.killedAll = true
        end
    elseif SaveData.currentCostume ~= "UNDERTALE-FRISK" then
        
    end
end

function undertaledepends.onDraw()
    if SaveData.currentCostume == "UNDERTALE-FRISK" then
        megaluavania2.enabled = true
        if player.powerup == 1 then
            player.powerup = 2
        end
        if player.forcedState == FORCEDSTATE_POWERDOWN_SMALL then
            player:mem(0x140, FIELD_WORD, 150)
            player.forcedState = FORCEDSTATE_NONE
        end
        if SaveData.frisk.killCount <= 0 then
            SaveData.frisk.isPacifist = true
        elseif SaveData.frisk.killCount >= 1 then
            SaveData.frisk.isPacifist = false
            SaveData.frisk.isNeutral = true
            if SaveData.frisk.genocidePhase >= 3 then
                SaveData.frisk.isNeutral = false
                SaveData.frisk.cantChangeCharacters = true
            end
        end
    elseif SaveData.currentCostume ~= "UNDERTALE-FRISK" then
        megaluavania2.enabled = false
    end
    local fontB = textplus.loadFont("littleDialogue/font/name.ini")
    if stats.enabled then
        textplus.print{
            x = 450,
            y = 95,
            xscale = 1,
            yscale = 1,
            font = fontB,
            text = "LV: " .. stat.level,
            priority = -4.2
        }
        textplus.print{
            x = 330,
            y = 119,
            xscale = 1,
            yscale = 1,
            font = fontB,
            text = "EXP: " .. stat.xp,
            priority = -4.2
        }
        if stat.hp >= stats.criticalHP then
            textplus.print{
                x = 234,
                y = 95,
                xscale = 1,
                yscale = 1,
                font = fontB,
                text = "HP: " .. stat.hp .. "/" .. stat.maxhp,
                priority = -4.2
            }
        else
            textplus.print{
                x = 234,
                y = 95,
                xscale = 1,
                yscale = 1,
                font = fontB,
                text = "HP: " .. stat.hp .."!/" .. stat.maxhp,
                priority = -4.2
            }
        end
    end
end

return undertaledepends