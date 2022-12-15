local undertaledepends = {}

local stats = require("Stats")
local playerManager = require("playerManager")
local textplus = require("textplus")

function undertaledepends.onInitAPI()
    registerEvent(undertaledepends,"onTick")
    registerEvent(undertaledepends,"onDraw")
    if smasbooleans.mainMenuActive then return end
end

function delayedMusicChange(killedNPC)
    Sound.changeMusic("_OST/Undertale/mus_toomuch.ogg", -1)
end

function undertaledepends.onTick()
    if SaveData.currentCostume == "UNDERTALE-FRISK" then
        stats.enabled = true
        stats.alwaysBig = true
        --Tables aren't detecting anything, so we have to manually put everything in a for loop... tis broken, so omit it for now
        --[[for i = 1, NPC_MAX_ID do
            stats.registerNPC(i, 2, 3, 2) --NPCid, pow, def, xpdrop
            stats.xpDrop(i, 1) --NPCID, reward
        end]]
        if #NPC.get(smastables.allBaseGameKillableEnemyIDs) == 0 and not table.icontains(smastables._friendlyPlaces,Level.filename()) then
            Routine.run(delayedMusicChange, killedNPC)
        end
    elseif SaveData.currentCostume ~= "UNDERTALE-FRISK" then
        stats.enabled = false
        stats.alwaysBig = false
    end
end

function undertaledepends.onDraw()
    local fontB = textplus.loadFont("littleDialogue/font/name.ini")
    if stats.enabled == true then
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